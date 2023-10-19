require "lib.moonloader"
local sampev = require "samp.events"
local cfg = require "inicfg"
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

local server = '{EA3A50}Arizona | Faraway'

local JsonStatus, Json = pcall(require, 'j-cfg')
assert(JsonStatus, 'jsoncfg.lua not found!')

script_url('vk.com/electronjsc')
script_name('Browser | Arizona')
script_authors('electronjsc | {37B5F0}Егор Зимов ('.. script.this.url ..')')
script_description('Данный скрипт был создан для полноценного использования, сервером '.. server ..'.')

-------------------------------------------

local status, cfg = Json('browser.json', {
    homepage = 'https://google.com/',
    window = {
        height = 190,
        weight = 70,
    }
});


function main()
    repeat wait(100) until isSampAvailable()

    sampAddChatMessage(string.format(u8'{DBFA5F}['.. script.this.name ..'] Loaded Script. Script Authors: ' .. table.concat(script.this.authors, ', ')), -1)
    sampAddChatMessage(string.format(u8'{DBFA5F}['.. script.this.name ..'] Description Script: ' .. script.this.description), -1)
    
    for i = 1, 3 do
        sampAddChatMessage(' ', 0xFFFFFF)
    end

    sampAddChatMessage(string.format(u8'{DBFA5F}['.. script.this.name ..'] {EEF425}Информация про настоящий сервер'), 0x70B95B)
    sampAddChatMessage(string.format(u8'{DBFA5F}['.. script.this.name ..'] {EEF425}IP сервера: {55D2F7}'.. sampGetCurrentServerAddress() ..':7777 '), -1)
    sampAddChatMessage(string.format(u8'{DBFA5F}['.. script.this.name ..'] {EEF425}Название сервера: {EA3A50}'.. sampGetCurrentServerName() ..' '), -1)

    sampRegisterChatCommand('browser', onBrowserInitialization)
end


function onBrowserInitialization()
    
    -- В разработке

end