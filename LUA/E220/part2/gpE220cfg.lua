 local wx = require("wx")
 require("COMPORT")

-- part 2

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
	pnCHAN	= wx.wxStaticBox( panelGP, ID_PN_CHAN, "Channel Control", wx.wxPoint( 10, 250), wx.wxSize( 380, 60) )	
    spnCHAN = wx.wxSpinCtrl( pnCHAN, ID_SPN_CHAN, "chan", wx.wxPoint( 15, 20), wx.wxSize( 50, 26))
    spnCHAN:SetRange ( 1, 20 )
	spnCHAN:SetFont( cbFont )
    frame:Connect( ID_SPN_CHAN, wx.wxEVT_SCROLL_LINEDOWN, OnSpinChan)
    frame:Connect( ID_SPN_CHAN, wx.wxEVT_SCROLL_LINEUP,   OnSpinChan)

	lblCHAN = wx.wxStaticText( pnCHAN, ID_LBL_CHAN, "frequency", wx.wxPoint( 70, 20 ), wx.wxSize( 150, 16))
	lblCHAN:SetFont( cbFont )
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
-- ---------
function OnSpinChan(event)
	local ch = spnCHAN:GetValue()
	local fr = 850.125 + ch
--	lblCHAN:SetLabel( string.format ( "= ".."%f", fr.." mHz"))
	lblCHAN:SetLabel( "= "..fr.." mHz")
end -- OnSpinChan


--
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


-- Handle the button event

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

			btnTxPower:Enable(true)


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
