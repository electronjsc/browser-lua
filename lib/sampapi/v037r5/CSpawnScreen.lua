--[[
    Project: SAMP-API.lua <https://github.com/imring/SAMP-API.lua>
    Developers: imring, LUCHARE, FYP

    Special thanks:
        SAMemory (https://www.blast.hk/threads/20472/) for implementing the basic functions.
        SAMP-API (https://github.com/BlastHackNet/SAMP-API) for the structures and addresses.
]]

local sampapi = require 'sampapi'
local shared = sampapi.shared
local mt = require 'sampapi.metatype'
local ffi = require 'ffi'

shared.require 'CRect'
shared.require 'v037r5.CFont'
shared.require 'v037r5.CFonts'

shared.ffi.cdef[[
typedef struct SCSpawnScreen SCSpawnScreen;
#pragma pack(push, 1)
struct SCSpawnScreen {
    BOOL m_bEnabled;
    char* m_szSpawnText;
    SCFonts* m_pFont;
    struct IDirect3DDevice9* m_pDevice;
    struct IDirect3DTexture9* m_pTexture;
    struct IDirect3DStateBlock9* m_pStateBlockSaved;
    struct IDirect3DStateBlock9* m_pStateBlockDraw;
    struct ID3DXSprite* m_pSprite;
};
#pragma pack(pop)
]]

shared.validate_size('struct SCSpawnScreen', 0x20)

local function RefSpawnScreen() return ffi.cast('SCSpawnScreen**', sampapi.GetAddress(0x26EB90))[0] end
local CSpawnScreen_constructor = ffi.cast('void(__thiscall*)(SCSpawnScreen*, IDirect3DDevice9*)', 0x70EF0)
local CSpawnScreen_destructor = ffi.cast('void(__thiscall*)(SCSpawnScreen*)', 0x70F30)
local function CSpawnScreen_new(...)
    local obj = ffi.gc(ffi.new('struct SCSpawnScreen[1]'), CSpawnScreen_destructor)
    CSpawnScreen_constructor(obj, ...)
    return obj
end

local SCSpawnScreen_mt = {
    SetText = ffi.cast('void(__thiscall*)(SCSpawnScreen*, const char*)', sampapi.GetAddress(0x70B90)),
    OnResetDevice = ffi.cast('void(__thiscall*)(SCSpawnScreen*)', sampapi.GetAddress(0x70BF0)),
    OnLostDevice = ffi.cast('void(__thiscall*)(SCSpawnScreen*)', sampapi.GetAddress(0x70EA0)),
    Draw = ffi.cast('void(__thiscall*)(SCSpawnScreen*)', sampapi.GetAddress(0x70F90)),
}
mt.set_handler('struct SCSpawnScreen', '__index', SCSpawnScreen_mt)

return {
    RefSpawnScreen = RefSpawnScreen,
    new = CSpawnScreen_new,
}