require "lib.moonloader"
local sampev = require "samp.events"
local inicfg = require 'inicfg'

local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

local browser = nil
local hasWebcore, webcore = pcall(require, 'webcore')

script_url('vk.com/electronjsc')
script_name('CEF Browser | DEV')
script_authors('electronjsc | {37B5F0}≈„Ó «ËÏÓ‚ ('.. script.this.url ..')')

-------------------------------------------

local cfg = inicfg.load({
    aBrowserHomePage = 'https://www.google.com/',
    aBrowserHTTPCode = 0,
    aBrowserX = 300,
    aBrowserY = 300,
    aBrowserWeight = 600,
    aBrowserHeight = 400,
    aBrowserOpen = false

}, '[dev]browser.ini')

function main()
    repeat wait(100) until isSampAvailable()
    while not webcore.inited() do wait(100) end

    browser = webcore:create(cfg.aBrowserHomePage, cfg.aBrowserX, cfg.aBrowserY, cfg.aBrowserWeight, cfg.aBrowserHeight)
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
        SendClientMessage(string.format(u8'Browser Pisition X: '.. cfg.aBrowserX ..'Browser Position Y: '.. cfg.aBrowserY ..' '))
        SendClientMessage(string.format(u8'Browser Size Weight: '.. cfg.aBrowserWeight ..'Browser Size Height: '.. cfg.aBrowserHeight ..' '))
        SendClientMessage(string.format(u8'Browser Home Page: '.. cfg.aBrowserHomePage ..''))
    end)

    sampRegisterChatCommand('browser', function() 
        if cfg.aBrowserOpen == true then
            browser:set_active(true)
            cfg.aBrowserOpen = false
        end
    end)
    
--------------------------

    local state_acsess = webcore.inited() and 'Enabled' or 'Disabled'

    SendClientMessage(string.format(u8'Loaded Script. | /browser | Script Authors: ' .. table.concat(script.this.authors, ', ')))
    SendClientMessage(string.format(u8'Version Script and WebCore: '.. webcore.version() ..' | WebCore Initialization: '.. state_acsess ..' '))
    
    for i = 1, 2 do
        sampAddChatMessage(' ', 0xFFFFFF)
    end

-------------------------

    browser:set_create_cb(
        function (_)
            SendClientMessage('| Browser Initialization |', 0xFFFFFF)
            SendClientMessage('| Browser URL: '.. cfg.aBrowserHomePage ..' ')
            SendClientMessage('| Demonstrate cursor - F; Close/Open the browser - X')
            SendClientMessage('| Scroll the page back - ¿rrow Left; Scroll the page forward - ¿rrow Right')
        end
    )

    browser:set_loading_cb(
        function (_, httpStatusCode)
            cfg.aBrowserHTTPCode = httpStatusCode
            inicfg.save(cfg)
            -- SendClientMessage('| Loading Done. HTTP StatusCode = '.. cfg.aBrowserHTTPCode ..' |', -1)
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

    while true do
        wait(10)

        if isKeyJustPressed(0x58) then 
            if cfg.aBrowserOpen == true then
                browser:set_active(false)
                cfg.aBrowserOpen = false
            else 
                browser:set_active(true)
                cfg.aBrowserOpen = true
            end
        end

        if isKeyJustPressed(0x46) then
            browser:set_input(true)
        end

        if isKeyJustPressed(0x25) then
            browser:go_back()
        end

        if isKeyJustPressed(0x27) then
            browser:go_forward()
        end
    end

    inicfg.save(cfg)
end

function SendClientMessage(text)
    sampAddChatMessage(string.format('{7D71FB}['.. script.this.name ..'] {FFFFFF}'.. text ..' '), -1)
end
