#include <avr/io.h>
#include <util/delay.h>

#define fosc 8000000

#define BAUD 9600
#define coef fosc/16/BAUD-1



#define VD_ON   PORTC |= 0b00000001 
#define VD_OFF  PORTC &= 0b11111110



void sendByte( unsigned char msg
) {
  while (! (UCSRA & (1 << UDRE)) );
  UDR = msg;

  

} // sendByte

int main(void)
{
  DDRD |= 1 << PIND1;
  DDRD &= ~(1 << PIND0);
  PORTD |= 1 << PIND0;
 
  DDRC |= 1 << PINC0;
 
//  int UBBRValue = 51; // ( F_CPU / ( 9600 * 16 )) -1;
//  UBRRH = (unsigned char) (UBBRValue >> 8);
//  UBRRL = (unsigned char) UBBRValue;
 

  UBRRH =  0; // (unsigned char)((coef)>> 8);
  UBRRL = 51; // (unsigned char)coef;

// UMSEL = 0 asynchronous; U2X = 0 normal mode

  UCSRB = ( 1<< RXEN ) | ( 1<<TXEN );
  UCSRC = ( 1<< URSEL) | ( 1<<USBS ) | ( 3<<UCSZ0); // 8data, 2stop bit


  unsigned char cnt = 0;
  while (1){
    VD_OFF;
    sendByte(0x02);
    sendByte(0b01010101);
    sendByte('0');
    sendByte('1');
    sendByte('2');
    sendByte('3');
    sendByte(';');
    sendByte(cnt+'0');
    sendByte(';');
    sendByte(0x0D);
    sendByte(0x03);
    VD_ON;
    cnt++;
	cnt &=0b00111111;
    _delay_ms(60000);
  }; // while
} // main