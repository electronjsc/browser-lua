require "lib.moonloader"
local sampev = require "samp.events"
local JsonStatus, Json = pcall(require, 'j-cfg');
assert(JsonStatus, 'jsoncfg.lua not found!');
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

local server = '{EA3A50}Bounce Project'
local hasWebcore, webcore = pcall(require, 'webcore')

script_url('vk.com/electronjsc')
script_name('CEF Browser | DEV')
script_authors('electronjsc | {37B5F0}Åãîð Çèìîâ ('.. script.this.url ..')')
script_description('Äàííûé ñêðèïò áûë ñîçäàí äëÿ ïîëíîöåííîãî èñïîëüçîâàíèÿ, ñåðâåðîì '.. server ..'.')

-------------------------------------------

local status, cfg = Json('browser.json', {
    homepage = 'https://google.com/',
    coords = {
        x = 40,
        y = 300
    },
    window = {
        height = 190,
        weight = 70
    }
})


function main()
    repeat wait(100) until isSampAvailable()

    print(cfg)

    if not hasWebcore then
        SendClientMessage('webcore.asi not loaded. Check please console for details', 0xFFFFFF)
        print(webcore)
        return
    else
        SendClientMessage('webcore.asi loaded.', 0xFFFFFF)
        print(webcore)
    end

    sampRegisterChatCommand('window', function()
        SendClientMessage(string.format(u8'Pisition X: '.. cfg.coords.x' Position Y: '.. cfg.coords.y ..' '))
        SendClientMessage(string.format(u8'Size W: '.. cfg.window.weight ..' Size H: 'cfg.window.height' '))
        SendClientMessage(string.format(u8'Home Page: '.. cfg.homepage ..''))
    end)

    sampRegisterChatCommand('browser', function()

        local browser = webcore:create(
            cfg.homepage, 
            cfg.coords.x, 
            cfg.coords.y, 
            cfg.window.weight, 
            cfg.window.height
        )

        browser:set_create_cb(
        function (_)
            SendClientMessage('| Browser Initialization |', 0xFFFFFF)
        end)

    end)
    
    local state_acsess = webcore.inited() and 'Enabled' or 'Disabled'

    SendClientMessage(string.format(u8'Loaded Script. Script Authors: ' .. table.concat(script.this.authors, ', ')))
    SendClientMessage(string.format(u8'Description Script: ' .. script.this.description))
    SendClientMessage(string.format(u8'Version Script and WebCore: '.. webcore.version() ..' | WebCore Initialization: '.. state_acsess ..' '))
    
    for i = 1, 3 do
        SendClientMessage(' ', 0xFFFFFF)
    end

    SendClientMessage(string.format(u8'Information From Server'))
    SendClientMessage(string.format(u8'IP Adress Server: {37B5F0}'.. sampGetCurrentServerAddress() ..':7777 '))
    SendClientMessage(string.format(u8'Name Server: {EA3A50}'.. sampGetCurrentServerName() ..' '))

    -- callFunction(onBrowserInitialization, 5, 5, cfg.homepage, cfg.coords.x, cfg.coords.y, cfg.window.weight, cfg.window.height)
end

function SendClientMessage(text)
    sampAddChatMessage(string.format('['.. script.this.name ..'] '.. text ..' '), 0xFFFFFF)
end
