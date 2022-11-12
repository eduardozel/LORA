 local wx = require("wx")
 require("COMPORT")
 require("os")
 
-- part 2 869.125 MHz 13dBm 290m Rx

-- http://bitop.luajit.org/api.html

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

	ID_PN_TxPower		= 2200
	ID_RG_TxPower		= 2210
    ID_LBL_TxPower		= 2212
    ID_BTN_TxPower		= 2214


    ID_PN_CHAN			= 2300
    ID_SPN_CHAN			= 2310
    ID_LBL_CHAN			= 2312
    ID_LBL_FHELP		= 2314
    ID_BTN_CHAN			= 2216


	cbFont = wx.wxFont(  12, wx.wxFONTFAMILY_MODERN, wx.wxFONTSTYLE_NORMAL, wx.wxFONTWEIGHT_NORMAL, false, "")

	btnSize = wx.wxSize( 60, 30)
	chSize	= wx.wxSize(  6, 10)

	tbCONSOLE = wx.wxTextCtrl( panelGP, ID_TBOX_CONSOLE, "+\n", wx.wxPoint(280, 20), wx.wxSize(240, 180), wx.wxTE_MULTILINE ) -- +wx.wxNO_BORDER


-- -----------
    btnTest = wx.wxButton( panelGP, ID_BUTTON_Test, "get config",
                          wx.wxPoint( 00, 20), wx.wxSize( 80, 30) )
    frame:Connect( ID_BUTTON_Test, wx.wxEVT_COMMAND_BUTTON_CLICKED, OnGETCFG)
	lblATOK = wx.wxStaticText(panelGP, ID_LBL_ATOK, "?", wx.wxPoint( 85, 25), chSize)

-- --------- U A R T

	pnUART = wx.wxStaticBox( panelGP, ID_PN_UART, "uart", wx.wxPoint( 10, 50), wx.wxSize( 180, 100) )	

    cbUARTrate    = wx.wxComboBox( pnUART, ID_CBOX_UARTrate,    "rate", wx.wxPoint( 10, 15), wx.wxSize( 130, 20), {})--, wx.wxTE_PROCESS_ENTER )
    cbUARTparity = wx.wxComboBox( pnUART, ID_CBOX_UARTparity, "parity", wx.wxPoint( 10, 55), wx.wxSize( 130, 20), {})--, wx.wxTE_PROCESS_ENTER )

--	cbUARTrate:SetFont( wxFont(12, wxSWISS, wxNORMAL,wxNORMAL, false, wxT("Tahoma")) );
--	cbUARTrate:SetFont( wxFont(12, wxSWISS, wxNORMAL,wxNORMAL, false) );
--	wxFont = font(wxFont(8, wxFONTFAMILY_TELETYPE, wxFONTSTYLE_NORMAL, wxFONTWEIGHT_NORMAL, false, _T("monospace")));
--fontItalic = wx.wxFont(10, wx.wxFONTFAMILY_MODERN, wx.wxFONTSTYLE_ITALIC, wx.wxFONTWEIGHT_NORMAL, false, "")

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
-- --
	pnTxPower	= wx.wxStaticBox( panelGP, ID_PN_TxPower, "tx power", wx.wxPoint( 10, 150), wx.wxSize( 380, 100) )	
	lblTxPower	= wx.wxStaticText( pnTxPower, ID_LBL_TxPower, "tx mWt", wx.wxPoint( 10, 65), wx.wxSize( 250, 16 ) )
	rgTxPower	= wx.wxRadioBox( pnTxPower, ID_RG_TxPower, "dBm", wx.wxPoint( 10, 15), wx.wxSize(  360, 40),
                            {"22", "17", "13", "10"}, 4,
                            wx.wxSUNKEN_BORDER)
    frame:Connect( ID_RG_TxPower, wx.wxEVT_COMMAND_RADIOBOX_SELECTED, OnSelectTxPower)
	rgTxPower:SetSelection( 1 )
    OnSelectTxPower(wx.wxEVT_COMMAND_RADIOBOX_SELECTED)
	lblTxPower:SetFont( cbFont )

    btnTxPower = wx.wxButton( pnTxPower, ID_BTN_TxPower, "save", wx.wxPoint( 180, 60), wx.wxSize( 80, 30) )
    frame:Connect( ID_BTN_TxPower, wx.wxEVT_COMMAND_BUTTON_CLICKED, OnClickTxPower)
	btnTxPower:Enable(false)


--	rgTxPower:SetFont( cbFont )
--	rgTxPower:Add("8N1")
--    rgTxPower.rb5 = wx.RadioButton( pnTxPower, 33, label = 'Value C',pos = (10,70))
-- local  x  =   os.clock ()
-- -----------
	pnCHAN	= wx.wxStaticBox( panelGP, ID_PN_CHAN, "Channel Control", wx.wxPoint( 10, 250), wx.wxSize( 380, 90) )	
    spnCHAN = wx.wxSpinCtrl( pnCHAN, ID_SPN_CHAN, "chan", wx.wxPoint( 15, 20), wx.wxSize( 50, 26))
    spnCHAN:SetRange ( 1, 20 )
	spnCHAN:SetFont( cbFont )
	
--	frame:Connect( ID_SPN_CHAN, wx.wxEVT_SCROLL_THUMBRELEASE, OnSpinChan)
    frame:Connect( ID_SPN_CHAN, wx.wxEVT_SCROLL_LINEUP,   OnSpinChan)
    frame:Connect( ID_SPN_CHAN, wx.wxEVT_SCROLL_LINEDOWN, OnSpinChan)

	lblCHAN = wx.wxStaticText( pnCHAN, ID_LBL_CHAN, "frequency", wx.wxPoint( 70, 20 ), wx.wxSize( 150, 16))
	lblCHAN:SetFont( cbFont )
	lblFHELP = wx.wxStaticText( pnCHAN, ID_LBL_FHELP, "864 - 865; 868.7 - 869.2; < 25 mWt", wx.wxPoint( 15, 60 ), wx.wxSize( 150, 16))
	lblFHELP:SetFont( cbFont )


    btnChan = wx.wxButton( pnCHAN, ID_BTN_CHAN, "save", wx.wxPoint( 180, 20), wx.wxSize( 80, 30) )
    frame:Connect( ID_BTN_CHAN, wx.wxEVT_COMMAND_BUTTON_CLICKED, OnClickChan)
--	btnChan:Enable(false)


--
-- https://58.rkn.gov.ru/directions/p2231/p9827/p20503/
-- 22. Неспециализированные (любого назначения) устройства в полосах радиочастот:
-- 864 - 865 MHz, 868.7 - 869.2 MHz; < 25 mWt
-- ---------
--    dt = os.time("%x")
    dt = os.date("%x")
    tbCONSOLE:AppendText( dt.."\n" )
    tm = os.date("%X")
    tbCONSOLE:AppendText( tm.."\n" )


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

-- ---------
function setFreq( chan )
	local fr = 850.125 + chan

	local chkFr = ( ( fr >= 864 )  and ( fr <= 865) ) or ( ( fr >= 868.7 ) and ( fr <= 869.2) )
	if ( chkFr ) then
		lblFHELP:SetBackgroundColour( wx.wxColour( 0, 255, 0))
		lblFHELP:SetLabel( "864 - 865; 868.7 - 869.2; <25 mWt")
    else
		lblFHELP:SetBackgroundColour( wx.wxColour( 255, 0, 0))
		lblFHELP:SetLabel( "864 - 865; 868.7 - 869.2; <25 mWt")
	end
	lblCHAN:SetLabel( "= "..fr.." mHz")
end -- setFreq

function OnSpinChan(event)
	local ch = spnCHAN:GetValue()
    local typ = event:GetEventType()
    if ( typ == wx.wxEVT_SCROLL_LINEDOWN ) then
		ch = ch - 1
	elseif ( typ == wx.wxEVT_SCROLL_LINEUP ) then
		ch = ch + 1
	end -- if
	setFreq(ch)
end -- OnSpinChan

--
-- Handle the button event
--
-- $00$00$17Helllo, World!!!

function OnSelectTxPower(event)
	local sl = rgTxPower:GetSelection()
	if     ( 0 == sl) then pwr = '158' -- 22
	elseif ( 1 == sl) then pwr =  '50' -- 17
	elseif ( 2 == sl) then pwr =  '20' -- 13
	elseif ( 3 == sl) then pwr =  '10' -- 10
	end
	lblTxPower:SetLabel("power = "..pwr..' mWt')
end -- OnSelectTxPower(event)

function OnClickTxPower(event)
end -- OnClickTxPower


function OnClickChan(event)
	local ch = spnCHAN:GetValue()
--	lblCHAN:SetLabel( "chan "..ch)
--	lblCHAN:SetLabel( "chan "..string.format ( "%x", (ch)))
	openCOM_HOST()
	sendCOM_HOST( string.char( 0xC0) )
	sendCOM_HOST( string.char( 0x04) )
	sendCOM_HOST( string.char( 0x01) )
	sendCOM_HOST( string.char( ch ) )

	local rpl0 = getRply()
	local rpl1 = getRply()
	local rpl2 = getRply()
	local rREG2 = getRply()	-- Channel Control（CH）

	closeCOM_HOST()
end -- OnClickChan


function OnGETCFG(event)
	openCOM_HOST()
    if ( pHOST ~= nil ) then
		sendCOM_HOST( string.char( 0xC1) )
		sendCOM_HOST( string.char( 0x00) )
		sendCOM_HOST( string.char( 0x05) )

		local rpl0 = getRply()
		local rpl1 = getRply()
		local rpl2 = getRply()
		local rADDH = getRply()
		local rADDL = getRply()
		local rREG0 = getRply()
		local rREG1 = getRply()
		local rREG2 = getRply()	-- Channel Control（CH）


		if ( string.char( 0xC1) == rpl0 ) then
			lblATOK:SetLabel("ok")
			lblATOK:SetBackgroundColour(wx.wxColour(0, 255, 0))

--			REG0	-------------------------

			local REG0  = string.byte( rREG0 ) + 0
			
			local URate = math.floor(( REG0  / 32 ))				-- bits 765
			cbUARTrate:SetSelection( URate )

			local UParity =  ( REG0 - ( URate * 32 ) )				-- bits 43
			UParity = math.floor(( UParity  / 8 ))
			cbUARTparity:SetSelection( UParity )

			local UAir = REG0 - ( math.floor(( REG0  / 8 )  )  * 8  )	-- bit 210
			if ( 2 == UAir ) then
				tbCONSOLE:AppendText( "air 2.4k" )
			end

--			REG1	-------------------------
			local REG1  = string.byte( rREG1 ) + 0

			local txpw = REG1 - ( math.floor(( REG1  / 4 )  )  * 4  ) -- bits 10 Transmitting Power
			rgTxPower:SetSelection( txpw )
			OnSelectTxPower(wx.wxEVT_COMMAND_RADIOBOX_SELECTED)


--			REG2	-------------------------
			local REG2  = string.byte( rREG2 ) + 0
			local fr =  850.125 + REG2 -- Actual frequency = 850.125 + CH *1M ( 873.125MHz  )
			local ch =  math.ceil( 868.0 - 850.125 )
			tbCONSOLE:AppendText( "\n")
			tbCONSOLE:AppendText( string.format ( "%f", fr).."\n")
			tbCONSOLE:AppendText( "\n")
			tbCONSOLE:AppendText( string.format ( "%d", ch).."\n")
			tbCONSOLE:AppendText( "\n")

			spnCHAN:SetValue( REG2 )
			setFreq( REG2 )
--			btnTxPower:Enable(true)


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
