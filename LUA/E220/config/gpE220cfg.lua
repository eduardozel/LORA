 local wx = require("wx")
 require("COMPORT")


function panelGpGSM()
    panelGP = wx.wxPanel(notebook, wx.wxID_ANY)
    sizerBC = wx.wxBoxSizer(wx.wxVERTICAL)

    ID_BUTTON_Test		= 1010
	ID_LBL_ATOK			= 1009
    ID_BUTTON_Status	= 1011
	ID_LBL_STOK			= 1012

	ID_PN_OPSOS			= 1100

	ID_BUTTON_OpSIM		= 1101
	ID_BUTTON_Operator	= 1112
    ID_BUTTON_Operators	= 1113


	ID_BUTTON_Signal	= 1015

    ID_BUTTON_Reg		= 1020
    ID_BUTTON_CVal		= 1021

    ID_BUTTON_TestPIN	= 1001
    ID_BUTTON_SetPIN	= 1002
	ID_TBOX_CONSOLE		= 1005

	ID_LBL_PINOK		= 1006

	ID_PN_FUNC			= 1201
    ID_BUTTON_FUNC		= 1202
	ID_RG_EMODE			= 1203

	ID_PN_OTHERS		= 1300
    ID_BUTTON_IMEI		= 1301

	btnSize = wx.wxSize( 60, 30)
	chSize	= wx.wxSize(  6, 10)

-- -----------
    btnTest = wx.wxButton( panelGP, ID_BUTTON_Test, "get config",
                          wx.wxPoint( 00, 20), wx.wxSize( 80, 30) )
    frame:Connect( ID_BUTTON_Test, wx.wxEVT_COMMAND_BUTTON_CLICKED, OnGETCFG)
	lblATOK = wx.wxStaticText(panelGP, ID_LBL_ATOK, "?", wx.wxPoint( 85, 25), chSize)
-- ---------

	pnFUNC  = wx.wxStaticBox(panelGP, ID_PN_FUNC, "functionality", wx.wxPoint( 00, 230), wx.wxSize( 210, 100) )

	rgFUNC	= wx.wxRadioBox(pnFUNC, ID_RG_EMODE, "", wx.wxPoint( 10, 15), wx.wxSize(  180, 40),
                            {"minimal", "normal", "flight"}, 3, -- 0.796, 1.02, 0.892 mA
                            wx.wxSUNKEN_BORDER)
	rgFUNC:SetSelection(1)


-- -----
	pnOTHERS = wx.wxStaticBox(panelGP, ID_PN_OTHERS, "others", wx.wxPoint( 00, 330), wx.wxSize( 210, 50) )

	tbCONSOLE = wx.wxTextCtrl( panelGP, ID_TBOX_CONSOLE, "+\n", wx.wxPoint(220, 20), wx.wxSize(240, 280), wx.wxTE_MULTILINE ) -- +wx.wxNO_BORDER
-- ---------
    notebook:AddPage(panelGP, "general commands")

end -- panelGpGSM


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
	tbCONSOLE:AppendText( string.format ( "%x", string.byte(rply)).."\n")

	return rply
end -- getRply

-- Handle the button event

function OnGETCFG(event)
	openCOM_HOST()
        sendCOM_HOST( string.char( 0xC1) )
        sendCOM_HOST( string.char( 0x00) )
        sendCOM_HOST( string.char( 0x03) )

	local rpl0 = getRply()
	local rpl1 = getRply()
	local rpl2 = getRply()
	local rADDH = getRply()
	local rADDL = getRply()
	local rREG0 = getRply()


	if ( string.char( 0xC1) == rpl0 ) then
		lblATOK:SetLabel("ok")
		lblATOK:SetBackgroundColour(wx.wxColour(0, 255, 0))
		local REG0  = string.byte( rREG0 ) + 0
		local URate = math.floor(( REG0  / 32 )) -- bit 765
		if ( 3 == URate ) then
			tbCONSOLE:AppendText( "baude 9600" )
		end
		local UBit = math.floor(( REG0  / 8 )) -- bit 43
		local UAir = REG0 - 8 * math.floor(( REG0  / 8 ) ) -- bit 210
		if ( 2 == UAir ) then
			tbCONSOLE:AppendText( "air 2.4k" )
		end


--		tbCONSOLE:AppendText( URate )

	end
	closeCOM_HOST()
end -- OnTest(event)

--
