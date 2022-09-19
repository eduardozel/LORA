 local wx = require("wx")
 require("COMPORT")

-- part 1


function panelGpGSM()
    panelGP = wx.wxPanel(notebook, wx.wxID_ANY)
    sizerBC = wx.wxBoxSizer(wx.wxVERTICAL)

    ID_BUTTON_Test		= 1010
    ID_LBL_ATOK			= 1009

	ID_LBL_STOK			= 1012


	ID_TBOX_CONSOLE		= 1005


	ID_PN_UART			= 2100
    ID_CBOX_UARTrate	= 2102
    ID_CBOX_UARTparity	= 2104


	cbFont = wx.wxFont(  12, wx.wxFONTFAMILY_MODERN, wx.wxFONTSTYLE_NORMAL, wx.wxFONTWEIGHT_NORMAL, false, "")


	btnSize = wx.wxSize( 60, 30)
	chSize	= wx.wxSize(  6, 10)

	tbCONSOLE = wx.wxTextCtrl( panelGP, ID_TBOX_CONSOLE, "+\n", wx.wxPoint(220, 20), wx.wxSize(240, 160), wx.wxTE_MULTILINE ) -- +wx.wxNO_BORDER
	tbFont = wx.wxFont(  12, wx.wxFONTFAMILY_MODERN, wx.wxFONTSTYLE_NORMAL, wx.wxFONTWEIGHT_NORMAL, false, "")
	tbCONSOLE:SetFont( tbFont )


-- -----------
    btnTest = wx.wxButton( panelGP, ID_BUTTON_Test, "get config",
                          wx.wxPoint( 00, 20), wx.wxSize( 80, 30) )
    frame:Connect( ID_BUTTON_Test, wx.wxEVT_COMMAND_BUTTON_CLICKED, OnGETCFG)
	lblATOK = wx.wxStaticText(panelGP, ID_LBL_ATOK, "?", wx.wxPoint( 85, 25), chSize)

-- --------- U A R T

	pnUART = wx.wxStaticBox( panelGP, ID_PN_UART, "uart", wx.wxPoint( 10, 50), wx.wxSize( 180, 100) )	

    cbUARTrate   = wx.wxComboBox( pnUART, ID_CBOX_UARTrate,     "rate", wx.wxPoint( 10, 15), wx.wxSize( 130, 20), {})--, wx.wxTE_PROCESS_ENTER )
    cbUARTparity = wx.wxComboBox( pnUART, ID_CBOX_UARTparity, "parity", wx.wxPoint( 10, 55), wx.wxSize( 130, 20), {})--, wx.wxTE_PROCESS_ENTER )

	cbUARTrate:SetFont( cbFont )
	cbUARTparity:SetFont( cbFont )


	cbUARTrate:Append("1200")
	cbUARTrate:Append("2400")
	cbUARTrate:Append("4800")
	cbUARTrate:Append("9600")
	cbUARTrate:Append("19200")
	cbUARTrate:Append("38400")
	cbUARTrate:Append("57600")
	cbUARTrate:Append("115200")
--	idx = cbUARTrate:FindString("9600")
--	cbUARTrate:SetSelection( idx )	

	cbUARTparity:Append("8N1")
	cbUARTparity:Append("8O1")
	cbUARTparity:Append("8E1")
	cbUARTparity:Append("8N1")

-- ---------
    notebook:AddPage(panelGP, "E220 configuration")
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
    if ( pHOST ~= nil ) then
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
			
			local URate = math.floor(( REG0  / 32 ))				-- bits 765
			cbUARTrate:SetSelection( URate )

			local UParity =  ( REG0 - ( URate * 32 ) )				-- bits 43
			UParity = math.floor(( UParity  / 8 ))
			cbUARTparity:SetSelection( UParity )

			local UAir = REG0 - ( math.floor(( REG0  / 8 ) )  * 8 )	-- bit 210
			if ( 2 == UAir ) then
				tbCONSOLE:AppendText( "air 2.4k" )
			end
		end
		closeCOM_HOST()
	else
		lblATOK:SetLabel("port com problem")
		lblATOK:SetBackgroundColour(wx.wxColour( 255, 0, 0))

		tbCONSOLE:AppendText( "com por not open \n" )
		tbCONSOLE:AppendText( "check cable\n" )
		tbCONSOLE:AppendText( "check pin \nM0 = 1; M1 = 1" )
	end -- if comport open

end -- OnTest(event)
