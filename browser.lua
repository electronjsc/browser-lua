require "lib.moonloader"
local sampev = require "samp.events"
local ini = require 'inicfg'
local imgui = require 'mimgui'

local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

local browser = nil
local hasWebcore, webcore = pcall(require, 'webcore')


script_url('vk.com/electronjsc')
script_name('CEF Browser | DEV')
script_authors('electronjsc | {37B5F0}���� ����� ('.. script.this.url ..')')

-------------------------------------------

local cfg = ini.load({
    aBrowserHomePage = 'https://www.google.com/',
    aBrowserLastURL = 'https://www.google.com/',
    aBrowserHTTPCode = 0,

    aBrowserX = 300,
    aBrowserY = 300,
    aBrowserWeight = 600,
    aBrowserHeight = 400,

    aBrowserOpen = false,
    aBrowserFullScreen = false,

    aBrowserServiceYouTube = 'https://www.youtube.com/',
    aBrowserServiceVK = 'https://vk.com/',
    aBrowserServiceForum = 'https://forum.arizona-rp.com/',
    aBrowserServiceGitHub = 'https://github.com/electronjsc'

}, "browser.ini")

local new = imgui.new
local newFrame = new.bool(false)

local sw, sh = getScreenResolution()
local Width = imgui.new.float(cfg.aBrowserWeight)
local Height = imgui.new.float(cfg.aBrowserHeight)
local X = imgui.new.float(cfg.aBrowserX)
local Y = imgui.new.float(cfg.aBrowserY)
local BrowserFullScreen = new.bool()

function main()
    repeat wait(100) until isSampAvailable()
    while not webcore.inited() do wait(100) end
    reconnect(5)

    browser = webcore:create(cfg.aBrowserHomePage, cfg.aBrowserX, cfg.aBrowserY, cfg.aBrowserWeight, cfg.aBrowserHeight)
    browser:set_active(false)
    cfg.aBrowserOpen = true;

-------------------------

    if not hasWebcore then
        SendClientMessage('webcore.asi not loaded. Check please console for details', 0xFFFFFF)
        print(webcore)
        return
    else
        SendClientMessage('webcore.asi loaded.', 0xFFFFFF)
        print(webcore)
    end

--------------------------

    sampRegisterChatCommand('window', function()
        SendClientMessage(string.format(u8'Browser Pisition X: '.. math.modf(cfg.aBrowserX) ..' | Browser Position Y: '.. math.modf(cfg.aBrowserY) ..' '))
        SendClientMessage(string.format(u8'Browser Size Weight: '.. math.modf(cfg.aBrowserWeight) ..' | Browser Size Height: '.. math.modf(cfg.aBrowserHeight) ..' '))
        SendClientMessage(string.format(u8'Browser Home Page: '.. cfg.aBrowserHomePage ..''))
    end)

    sampRegisterChatCommand('browser', function() 
        newFrame[0] = not newFrame[0]
    end)
    
--------------------------

    local state_acsess = webcore.inited() and 'Enabled' or 'Disabled'

    SendClientMessage(string.format(u8'Loaded Script. | Script Authors: ' .. table.concat(script.this.authors, ', ')))
    SendClientMessage(string.format(u8'Version Script and WebCore: '.. webcore.version() ..' | WebCore Initialization: '.. state_acsess ..' '))
    
    for i = 1, 2 do
        sampAddChatMessage(' ', 0xFFFFFF)
    end

-------------------------

    browser:set_create_cb(
        function (_)
            SendClientMessage('| Browser Initialization | /browser - settings', 0xFFFFFF)
            SendClientMessage('| Demonstrate cursor - F; Close/Open the browser - X')
            SendClientMessage('| Scroll the page back - �rrow Left; Scroll the page forward - �rrow Right')
        end
    )

    browser:set_loading_cb(
        function (_, httpStatusCode)
            cfg.aBrowserHTTPCode = httpStatusCode
            ini.save(cfg, 'browser.ini')

            cfg.aBrowserLastURL = browser:get_url()
            SendClientMessage('| Loading Done. | Browser URL: ' .. cfg.aBrowserLastURL, -1)
        end
    )

    browser:set_close_cb(
        function (_)
            SendClientMessage('| Closed Browser. HTTP StatusCode = '.. cfg.aBrowserHTTPCode ..' ', -1)
            cfg.aBrowserOpen = false
            browser = nil
        end
    )

------------------------

local newFrame = imgui.OnFrame( 
    function() return newFrame[0] end, 
    function(player)        
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(500, 305), imgui.Cond.FirstUseEver)
        imgui.Begin("CEF Browser | DEV", newFrame, imgui.WindowFlags.NoResize)
            imgui.SetCursorPosX((imgui.GetWindowWidth() - imgui.CalcTextSize(u8("������ ������")).x)/2)
            imgui.Text(u8"������ ���� ��������")
            imgui.PushItemWidth(480)
            if imgui.SliderFloat("##1", Width, 0.0, 2000.0) then 
                cfg.aBrowserWeight = Width[0] 
                ini.save(cfg, 'browser.ini') 
            end
            imgui.Separator()
            imgui.SetCursorPosX((imgui.GetWindowWidth() - imgui.CalcTextSize(u8("������ ������")).x)/2)
            imgui.Text(u8"������ ���� ��������")
            imgui.PushItemWidth(480)
            if imgui.SliderFloat("##2", Height, 0.0, 2000.0) then 
                cfg.aBrowserHeight = Height[0] 
                ini.save(cfg, 'browser.ini') 
            end
            imgui.Separator()
            imgui.SetCursorPosX((imgui.GetWindowWidth() - imgui.CalcTextSize(u8("���������� X")).x)/2)
            imgui.Text(u8"���������� X")
            imgui.PushItemWidth(480)
            if imgui.SliderFloat("##3", X, 0.0, sw) then 
                cfg.aBrowserX = X[0] 
                ini.save(cfg, 'browser.ini') 
            end
            imgui.Separator()
            imgui.SetCursorPosX((imgui.GetWindowWidth() - imgui.CalcTextSize(u8("���������� Y")).x)/2)
            imgui.Text(u8"���������� Y")
            imgui.PushItemWidth(480)
            if imgui.SliderFloat("##4", Y, 0.0, sh/2) then 
                cfg.aBrowserY = Y[0]
                ini.save(cfg, 'browser.ini') 
            end
            imgui.Separator()
            imgui.SetCursorPosX((imgui.GetWindowWidth() - imgui.CalcTextSize(u8("���������")).x)/2)
            imgui.Text(u8"���������")
            if imgui.Button(u8"��������� ���������!", imgui.ImVec2(480, 20)) then
                SendClientMessage('��������� ���������!', 0x9562DE)
                browser:set_rect(cfg.aBrowserX, cfg.aBrowserY, cfg.aBrowserWeight, cfg.aBrowserHeight)
            end
            if imgui.Checkbox(u8'�������� ������������� �����', BrowserFullScreen) then
                if not cfg.aBrowserFullScreen then 
                    cfg.aBrowserHeight = 1077
                    cfg.aBrowserWeight = 1920

                    cfg.aBrowserX = 0
                    cfg.aBrowserY = 0

                    browser:set_rect(cfg.aBrowserX, cfg.aBrowserY, cfg.aBrowserWeight, cfg.aBrowserHeight)
                    cfg.aBrowserFullScreen = true
                else 
                    cfg.aBrowserWeight = 600
                    cfg.aBrowserHeight = 400

                    cfg.aBrowserX = 300
                    cfg.aBrowserY = 300

                    browser:set_rect(cfg.aBrowserX, cfg.aBrowserY, cfg.aBrowserWeight, cfg.aBrowserHeight) 
                    cfg.aBrowserFullScreen = false
                end
            end
            imgui.Separator()
            imgui.SetCursorPosX((imgui.GetWindowWidth() - imgui.CalcTextSize(u8("�������")).x)/2)
            imgui.Text(u8"�������")
            if imgui.Button(u8"������� ������ YouTube", imgui.ImVec2(-1, 20)) then 
                browser:load_url(cfg.aBrowserServiceYouTube)
            end
            if imgui.Button(u8"������� ������ VK", imgui.ImVec2(-1, 20)) then
                browser:load_url(cfg.aBrowserServiceVK)
            end
            if imgui.Button(u8"������� ������ Arizona Forum", imgui.ImVec2(-1, 20)) then
                browser:load_url(cfg.aBrowserServiceForum)
            end
            if imgui.Button(u8"������� ������ GitHub (electronjsc)", imgui.ImVec2(-1, 20)) then
                browser:load_url(cfg.aBrowserServiceGitHub)
            end
        imgui.End()                
    end
)

------------------------

    while true do
        wait(10)

        if isKeyJustPressed(0x58) then 
            if cfg.aBrowserOpen == true then
                browser:set_active(false)
                cfg.aBrowserOpen = false
            elseif not sampIsChatInputActive() then
                browser:set_active(true)
                cfg.aBrowserOpen = true
            end
        end

        if isKeyJustPressed(0x46) then
            if not sampIsChatInputActive() then
                browser:set_input(true)
            end
        end

        if isKeyJustPressed(0x25) then
            if not browser:input_active() and not sampIsChatInputActive() then
                browser:go_back()
            end
        end

        if isKeyJustPressed(0x27) then
            if not browser:input_active() and not sampIsChatInputActive() then
                browser:go_forward()
            end
        end
    end

    ini.save(cfg, 'browser.ini')
end

function SendClientMessage(text)
    sampAddChatMessage(string.format('{7D71FB}['.. script.this.name ..'] {FFFFFF}'.. text ..' '), -1)
end

function reloadScripts()
    browser:load_url(cfg.aBrowserHomePage)
    browser:close(browser)
end

function reconnect(timeout)
    lua_thread.create(function()
        SendClientMessage('| Reconnect 5 second')
        sampSetGamestate(5)
        sampDisconnectWithReason(1)
        wait(timeout*1000)
        sampSetGamestate(1)
    end)
end
