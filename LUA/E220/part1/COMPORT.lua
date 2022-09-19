 local wx = require("wx")

--luars232.RS232_DTR_ON      as a parameter
--luars232.RS232_RTS_ON

 rs232 = require( "luars232" )

 comHOST = "COM3"
 pHOST = null

function openCOM_HOST()
  e, pHOST = rs232.open(comHOST)
  if e ~= rs232.RS232_ERR_NOERROR then
--    out:write( "port not open \n")
--    wx.wxMessageBox("can't open serial port '%s', error: \n", wx.wxOK + wx.wxICON_INFORMATION, frame)

--    wx.wxMessageBox(string.format("can't open serial port '%s', error: '%s'\n",
--			port_name, rs232.error_tostring(e)),  "COM PORT Error", wx.wxOK + wx.wxICON_INFORMATION, frame)
    return
  end -- if


  assert(pHOST:set_baud_rate(rs232.RS232_BAUD_9600) == rs232.RS232_ERR_NOERROR)
  assert(pHOST:set_data_bits(rs232.RS232_DATA_8) == rs232.RS232_ERR_NOERROR)
  assert(pHOST:set_parity(rs232.RS232_PARITY_NONE) == rs232.RS232_ERR_NOERROR)
  assert(pHOST:set_stop_bits(rs232.RS232_STOP_1) == rs232.RS232_ERR_NOERROR)
  assert(pHOST:set_flow_control(rs232.RS232_FLOW_OFF)  == rs232.RS232_ERR_NOERROR)

-- out:write(string.format("OK, port open with values '%s'\n", tostring(p)))
end -- openCOM_HOST

function sendCOM_HOST( data )
  err, len_written = pHOST:write( data )
  assert(e == rs232.RS232_ERR_NOERROR)
end -- sendCOM_HOST


function closeCOM_HOST()
  assert(pHOST:close() == rs232.RS232_ERR_NOERROR)
end -- closeCOM_HOST
