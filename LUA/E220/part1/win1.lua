-- LuaForWindows_v5.1.5-52

 require("gpE220cfg")


 local wx = require("wx")

    frame = wx.wxFrame( wx.NULL, wx.wxID_ANY, "Test LORA E220 modem"
                                 , wx.wxDefaultPosition, wx.wxSize( 500, 270)
                                 , wx.wxDEFAULT_FRAME_STYLE)

    frame:Show(true)
    frame:CreateStatusBar(1)
    notebook = wx.wxNotebook(frame, wx.wxID_ANY,
                                   wx.wxDefaultPosition, wx.wxDefaultSize)
                                   --wx.wxNB_BOTTOM)

    panelGpGSM()

wx.wxGetApp():MainLoop()
