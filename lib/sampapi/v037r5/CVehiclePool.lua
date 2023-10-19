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

shared.require 'v037r5.CEntity'
shared.require 'v037r5.CVehicle'
shared.require 'CMatrix'
shared.require 'CVector'

shared.ffi.cdef[[
enum {
    MAX_VEHICLES = 2000,
    WAITING_LIST_SIZE = 100,
};

typedef struct SVehicleInfo SVehicleInfo;
#pragma pack(push, 1)
struct SVehicleInfo {
    ID m_nId;
    int m_nType;
    SCVector m_position;
    float m_fRotation;
    NUMBER m_nPrimaryColor;
    NUMBER m_nSecondaryColor;
    float m_fHealth;
    char m_nInterior;
    int m_nDoorDamageStatus;
    int m_nPanelDamageStatus;
    char m_nLightDamageStatus;
    bool m_bDoorsLocked;
    bool m_bHasSiren;
};
#pragma pack(pop)

typedef struct SCVehiclePool SCVehiclePool;
#pragma pack(push, 1)
struct SCVehiclePool {
    int m_nCount;
    struct {
        SVehicleInfo m_entry[100];
        BOOL m_bNotEmpty[100];
    } m_waitingList;
    SCVehicle* m_pObject[2000];
    BOOL m_bNotEmpty[2000];
    struct CVehicle* m_pGameObject[2000];
    unsigned int pad_6ef4[2000];
    ID m_nLastUndrivenId[2000];
    TICK m_lastUndrivenProcessTick[2000];
    BOOL m_bIsActive[2000];
    BOOL m_bIsDestroyed[2000];
    TICK m_tickWhenDestroyed[2000];
    SCVector m_spawnedAt[2000];
    BOOL m_bNeedsToInitializeLicensePlates;
};
#pragma pack(pop)
]]

shared.validate_size('struct SVehicleInfo', 0x28)
shared.validate_size('struct SCVehiclePool', 0x17898)

local CVehiclePool_constructor = ffi.cast('void(__thiscall*)(SCVehiclePool*)', 0x1EA10)
local CVehiclePool_destructor = ffi.cast('void(__thiscall*)(SCVehiclePool*)', 0x1F060)
local function CVehiclePool_new(...)
    local obj = ffi.gc(ffi.new('struct SCVehiclePool[1]'), CVehiclePool_destructor)
    CVehiclePool_constructor(obj, ...)
    return obj
end

local SCVehiclePool_mt = {
    UpdateCount = ffi.cast('void(__thiscall*)(SCVehiclePool*)', sampapi.GetAddress(0x1E9B0)),
    Delete = ffi.cast('BOOL(__thiscall*)(SCVehiclePool*, ID)', sampapi.GetAddress(0x1EA80)),
    ChangeInterior = ffi.cast('void(__thiscall*)(SCVehiclePool*, ID, int)', sampapi.GetAddress(0x1EB00)),
    SetParams = ffi.cast('void(__thiscall*)(SCVehiclePool*, ID, bool, bool)', sampapi.GetAddress(0x1EB30)),
    Find = ffi.cast('ID(__thiscall*)(SCVehiclePool*, struct CVehicle*)', sampapi.GetAddress(0x1EB90)),
    GetRef = ffi.cast('GTAREF(__thiscall*)(SCVehiclePool*, int)', sampapi.GetAddress(0x1EBC0)),
    GetRef = ffi.cast('GTAREF(__thiscall*)(SCVehiclePool*, int)', sampapi.GetAddress(0x1EBC0)),
    GetNearest = ffi.cast('ID(__thiscall*)(SCVehiclePool*)', sampapi.GetAddress(0x1EC00)),
    GetNearest = ffi.cast('ID(__thiscall*)(SCVehiclePool*)', sampapi.GetAddress(0x1EC00)),
    AddToWaitingList = ffi.cast('void(__thiscall*)(SCVehiclePool*, const SVehicleInfo*)', sampapi.GetAddress(0x1ED10)),
    ConstructLicensePlates = ffi.cast('void(__thiscall*)(SCVehiclePool*)', sampapi.GetAddress(0x1ED70)),
    ShutdownLicensePlates = ffi.cast('void(__thiscall*)(SCVehiclePool*)', sampapi.GetAddress(0x1EDE0)),
    Create = ffi.cast('BOOL(__thiscall*)(SCVehiclePool*, SVehicleInfo*)', sampapi.GetAddress(0x1F080)),
    SendDestroyNotification = ffi.cast('void(__thiscall*)(SCVehiclePool*, ID)', sampapi.GetAddress(0x1F230)),
    ProcessWaitingList = ffi.cast('void(__thiscall*)(SCVehiclePool*)', sampapi.GetAddress(0x1F300)),
    Process = ffi.cast('void(__thiscall*)(SCVehiclePool*)', sampapi.GetAddress(0x1F3C0)),
    Get = ffi.cast('SCVehicle * (__thiscall*)(SCVehiclePool*, ID)', sampapi.GetAddress(0x1120)),
    DoesExist = ffi.cast('BOOL(__thiscall*)(SCVehiclePool*, ID)', sampapi.GetAddress(0x1150)),
}
mt.set_handler('struct SCVehiclePool', '__index', SCVehiclePool_mt)

return {
    new = CVehiclePool_new,
}