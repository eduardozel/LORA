 local wx = require("wx")
 require("COMPORT")
 require("os")
 
function panelRX()
    panel_RX = wx.wxPanel(notebook, wx.wxID_ANY)
    sizerBC = wx.wxBoxSizer(wx.wxVERTICAL)

    local ID_BUTTON_LOG		= 211
    local ID_BUTTON_STOP	= 212

    local ID_LBL_LOG		= 209
    local ID_TBOX_LOG		= 205




	cbFont = wx.wxFont(  12, wx.wxFONTFAMILY_MODERN, wx.wxFONTSTYLE_NORMAL, wx.wxFONTWEIGHT_NORMAL, false, "")

	local btnSize	= wx.wxSize( 60, 30)
	local chSize	= wx.wxSize(  6, 10)

	tbLOG = wx.wxTextCtrl( panel_RX, ID_TBOX_LOG, "+\n", wx.wxPoint(280, 20), wx.wxSize(240, 180), wx.wxTE_MULTILINE ) -- +wx.wxNO_BORDER

-- -----------
    btnLOG = wx.wxButton( panel_RX, ID_BUTTON_LOG, "start log",
                          wx.wxPoint( 00, 20), wx.wxSize( 80, 30) )
    frame:Connect( ID_BUTTON_LOG, wx.wxEVT_COMMAND_BUTTON_CLICKED, OnStartLog)

    btnSTOP = wx.wxButton( panel_RX, ID_BUTTON_STOP, "stop log",
                          wx.wxPoint( 00, 60), wx.wxSize( 80, 30) )
    frame:Connect( ID_BUTTON_STOP, wx.wxEVT_COMMAND_BUTTON_CLICKED, OnStopLog)
	btnSTOP:Enable(false)

	lblLOG = wx.wxStaticText(panel_RX, ID_LBL_LOG, "?", wx.wxPoint( 85, 25), chSize)

    dt = os.date("%x")
    tbLOG:AppendText( dt.."\n" )
    tm = os.date("%X")
    tbLOG:AppendText( tm.."\n" )


	notebook:AddPage(panel_RX, "RX LOG")
end -- panelRX

 
function strToHost( msg )
	for i = 1, string.len(msg) do
		sendCOM_HOST( string.sub( msg, i, i) )
	end -- for i
end -- strToHost

function getRply(
)
	local CR = string.char( 0x0D)

	local rd_len = 1
	local timeout = 4000
        local rp = ""

	local err, rply,  size = pHOST:read( rd_len, timeout )
	tbLOG:AppendText( string.format ( "%x", string.byte(rply)).."\n")

	return rply
end -- getRply

-- ---------
function OnStopLog(event)
	btnLOG:Enable(false)
	tbLOG:AppendText( "\n".."STOP LOG".."\n")
    if ( pHOST ~= nil ) then
		closeCOM_HOST()
	end -- if comport open
end -- OnStopLog(event)



function OnStartLog(event)
	local STX = string.char( 0x02)
	openCOM_HOST()
    if ( pHOST ~= nil ) then
		tbLOG:AppendText( "START LOG".."\n")
		btnLOG:Enable(false)
		btnSTOP:Enable(true)
		repeat
			repeat
				local err, stt,  size = pHOST:read( 1, 1000 )
			until stt == STX
			local err, msg,  size = pHOST:read( 8, 100 )
			local err, ett,  size = pHOST:read( 1, 100 )
			local err, et1,  size = pHOST:read( 1, 100 )
			local err, rssi, size = pHOST:read( 1, 100 )
			tm = os.date("%X")
			tbLOG:AppendText( tm..";"..msg..string.byte(rssi)..";".."\n")
		until false
	else
		tbLOG:AppendText( "no com port".."\n")
	end -- if comport open

end -- OnStartLog(event)
