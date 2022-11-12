#include <avr/io.h>
#include <util/delay.h>

#define fosc 8000000

#define BAUD 9600
#define coef fosc/16/BAUD-1



#define VD_ON   PORTC |= 0b00000001 
#define VD_OFF  PORTC &= 0b11111110


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
  
 
  while (1)
  {
         while (! (UCSRA & (1 << UDRE)) );
         {
         VD_OFF;
          UDR = 0b01010101;
         _delay_ms(500);
		 VD_ON;
         _delay_ms(5000);
		 }
  } // while
}