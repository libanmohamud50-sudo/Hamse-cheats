-- ============================================================================
-- THIS LUA IS ENCRYPTED BY @HAMSECHEATS
-- YOU CAN JOIN MY CHANNEL :- ASSET_FINDER
-- ============================================================================

-- ========================================
-- >>> WELCOME TO HAMSECHEATS VIP MOD PAK FILE <<<
-- =======================================
-- =======================================
-- CREDIT: @HAMSECHEATS - SOMALI VIP PAK
-- CONTACT: Telegram @hamsecheatsvip
-- VERSION: 4.6 PAK EDITION (FIXED LICENSE SYSTEM)
-- ========================================

local BRPlayerCharacterBase = {
  ServerRPC = {},
  ClientRPC = {},
  MulticastRPC = {}
}
BRPlayerCharacterBase.ServerRPC.ServerRPC_NearDeathGiveupRescue = {
  Reliable = true,
  Params = {}
}
BRPlayerCharacterBase.ServerRPC.ServerRPC_CarryDeadBox = {
  Reliable = true,
  Params = {
    UEnums.EPropertyClass.Object
  }
}
BRPlayerCharacterBase.ServerRPC.RPC_Server_GmPlayAction = {
  Reliable = true,
  Params = {
    UEnums.EPropertyClass.Int
  }
}
BRPlayerCharacterBase.MulticastRPC.MulticastRPC_GmPlayAction = {
  Reliable = true,
  Params = {
    UEnums.EPropertyClass.Int
  }
}
BRPlayerCharacterBase.ClientRPC.RPC_Client_SetShouldCheckPassWall = {
  Reliable = true,
  Params = {
    UEnums.EPropertyClass.Bool
  }
}
local ENetRole = import("ENetRole")
local EPawnState = import("EPawnState")
local GameplayData = require("GameLua.GameCore.Data.GameplayData")
local GamePlayTools = require("GameLua.Mod.BaseMod.Common.GamePlayTools")

local KismetSystemLibrary = import("KismetSystemLibrary")
local packageName = KismetSystemLibrary.GetGameBundleId()

-- Support all game versions without returning
local function GetGamePaths(pkg)
    local paths = {
        ["com.tencent.ig"] = {
            base = "/storage/emulated/0/Android/data/com.tencent.ig/files/",
            sdcard = "/sdcard/Android/data/com.tencent.ig/files/",
            saved = "/storage/emulated/0/Android/data/com.tencent.ig/files"
        },
        ["com.pubg.imobile"] = {
            base = "/storage/emulated/0/Android/data/com.pubg.imobile/files/",
            sdcard = "/sdcard/Android/data/com.pubg.imobile/files/",
            saved = "/storage/emulated/0/Android/data/com.pubg.imobile/files/"
        },
        ["com.vng.pubgmobile"] = {
            base = "/storage/emulated/0/Android/data/com.vng.pubgmobile/files/",
            sdcard = "/sdcard/Android/data/com.vng.pubgmobile/files/",
            saved = "/storage/emulated/0/Android/data/com.vng.pubgmobile/files/"
        },
        ["com.pubg.krmobile"] = {
            base = "/storage/emulated/0/Android/data/com.pubg.krmobile/files/",
            sdcard = "/sdcard/Android/data/com.pubg.krmobile/files/",
            saved = "/storage/emulated/0/Android/data/com.pubg.krmobile/files/"
        },
        ["com.rekoo.pubgm"] = {
            base = "/storage/emulated/0/Android/data/com.rekoo.pubgm/files/",
            sdcard = "/sdcard/Android/data/com.rekoo.pubgm/files/",
            saved = "/storage/emulated/0/Android/data/com.rekoo.pubgm/files/"
        },
        ["com.garena.game.kgtw"] = {
            base = "/storage/emulated/0/Android/data/com.garena.game.kgtw/files/",
            sdcard = "/sdcard/Android/data/com.garena.game.kgtw/files/",
            saved = "/storage/emulated/0/Android/data/com.garena.game.kgtw/files/"
        },
        ["com.pubg.jpmobile"] = {
            base = "/storage/emulated/0/Android/data/com.pubg.jpmobile/files/",
            sdcard = "/sdcard/Android/data/com.pubg.jpmobile/files/",
            saved = "/storage/emulated/0/Android/data/com.pubg.jpmobile/files/"
        }
    }
    return paths[pkg] or {
        base = "/storage/emulated/0/Android/data/" .. pkg .. "/files/",
        sdcard = "/sdcard/Android/data/" .. pkg .. "/files/",
        saved = "/storage/emulated/0/Android/data/" .. pkg .. "/files/"
    }
end

local currentGamePaths = GetGamePaths(packageName)
if type(currentGamePaths.saved) == "string" and currentGamePaths.saved:sub(-1) ~= "/" then
    currentGamePaths.saved = currentGamePaths.saved .. "/"
end

-- ============================================================================
-- HAMSECHEATS ONLINE LICENSE SYSTEM (MIGRATED FROM )
-- All mod features remain hard-locked until the online key is verified.
-- ============================================================================

-- 1. LICENSE CONFIG + CORE
-- ============================================================================
local MasterLicenseConfig = (function()
    return {
              url = 'https://a.hamse.workers.dev', game = 'BGMI',
        timeout = 10, clockSkew = 120, expiryPath = nil,
        manualExpiry = "2026-12-31 23:59:59", tamperTolerance = 5,
        secret = 'HAMSE_CHEATS_VIP_2026_V1',
    }
end)()

local MasterLicenseCore = (function()
    local Primitives = (function()
        local floor, abs, max = math.floor, math.abs, math.max
        local byte, char, format = string.byte, string.char, string.format
        local U32 = 4294967296
        local AND, XOR = {}, {}
        for a = 0, 15 do for b = 0, 15 do
            local av, bv, both, different, place = a, b, 0, 0, 1
            for _ = 1, 4 do
                local x, y = av % 2, bv % 2
                if x == 1 and y == 1 then both = both + place end
                if x ~= y then different = different + place end
                av, bv, place = floor(av / 2), floor(bv / 2), place * 2
            end
            AND[a * 16 + b], XOR[a * 16 + b] = both, different
        end end
        local function bitop(a, b, lookup)
            local value, place = 0, 1
            for _ = 1, 8 do
                value = value + lookup[(a % 16) * 16 + b % 16] * place
                a, b, place = floor(a / 16), floor(b / 16), place * 16
            end
            return value
        end
        local function band(a, b) return bitop(a, b, AND) end
        local function bxor(a, b) return bitop(a, b, XOR) end
        local function rol(value, amount)
            local divisor = 2 ^ (32 - amount)
            return (value % divisor) * 2 ^ amount + floor(value / divisor)
        end
        local function little32(value)
            return char(value % 256, floor(value / 256) % 256,
                floor(value / 65536) % 256, floor(value / 16777216) % 256)
        end
        local K = {
            0xd76aa478,0xe8c7b756,0x242070db,0xc1bdceee,0xf57c0faf,0x4787c62a,0xa8304613,0xfd469501,
            0x698098d8,0x8b44f7af,0xffff5bb1,0x895cd7be,0x6b901122,0xfd987193,0xa679438e,0x49b40821,
            0xf61e2562,0xc040b340,0x265e5a51,0xe9b6c7aa,0xd62f105d,0x02441453,0xd8a1e681,0xe7d3fbc8,
            0x21e1cde6,0xc33707d6,0xf4d50d87,0x455a14ed,0xa9e3e905,0xfcefa3f8,0x676f02d9,0x8d2a4c8a,
            0xfffa3942,0x8771f681,0x6d9d6122,0xfde5380c,0xa4beea44,0x4bdecfa9,0xf6bb4b60,0xbebfbc70,
            0x289b7ec6,0xeaa127fa,0xd4ef3085,0x04881d05,0xd9d4d039,0xe6db99e5,0x1fa27cf8,0xc4ac5665,
            0xf4292244,0x432aff97,0xab9423a7,0xfc93a039,0x655b59c3,0x8f0ccc92,0xffeff47d,0x85845dd1,
            0x6fa87e4f,0xfe2ce6e0,0xa3014314,0x4e0811a1,0xf7537e82,0xbd3af235,0x2ad7d2bb,0xeb86d391
        }
        local SHIFT = {7,12,17,22,5,9,14,20,4,11,16,23,6,10,15,21}
        local function md5_raw(input)
            assert(type(input) == "string", "MD5 input must be a string")
            local size = #input
            local message = input .. char(128) .. string.rep(char(0), (55 - size) % 64)
                .. little32((size * 8) % U32) .. little32(floor(size / 536870912))
            local h0, h1, h2, h3 = 0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476
            local words = {}
            for offset = 1, #message, 64 do
                for j = 0, 15 do
                    local a, b, c, d = byte(message, offset + j * 4, offset + j * 4 + 3)
                    words[j] = a + b * 256 + c * 65536 + d * 16777216
                end
                local a, b, c, d = h0, h1, h2, h3
                for i = 0, 63 do
                    local f, g, shiftBase
                    if i < 16 then
                        f, g, shiftBase = band(b, c) + band(U32 - 1 - b, d), i, 0
                    elseif i < 32 then
                        f, g, shiftBase = band(d, b) + band(U32 - 1 - d, c), (5 * i + 1) % 16, 4
                    elseif i < 48 then
                        f, g, shiftBase = bxor(bxor(b, c), d), (3 * i + 5) % 16, 8
                    else
                        local bOrNotD = U32 - 1 - band(U32 - 1 - b, d)
                        f, g, shiftBase = bxor(c, bOrNotD), (7 * i) % 16, 12
                    end
                    local nextB = (b + rol((a + f + K[i + 1] + words[g]) % U32,
                        SHIFT[shiftBase + i % 4 + 1])) % U32
                    a, b, c, d = d, nextB, b, c
                end
                h0, h1, h2, h3 = (h0 + a) % U32, (h1 + b) % U32, (h2 + c) % U32, (h3 + d) % U32
            end
            return little32(h0) .. little32(h1) .. little32(h2) .. little32(h3)
        end
        local function hex(input)
            return (input:gsub(".", function(c) return format("%02x", byte(c)) end))
        end
        local function md5(input) return hex(md5_raw(input)) end
        local function form_encode(input)
            assert(type(input) == "string", "Form value must be a string")
            return (input:gsub("[^A-Za-z0-9%-%._~ ]", function(c)
                return format("%%%02X", byte(c)) end):gsub(" ", "+"))
        end
        local function constant_time_equal(a, b)
            if type(a) ~= "string" or type(b) ~= "string" then return false end
            local difference = abs(#a - #b)
            for i = 1, max(#a, #b) do
                difference = difference + abs((byte(a, i) or 0) - (byte(b, i) or 0))
            end
            return difference == 0
        end
        local function name_uuid(input)
            local digest = md5_raw(input)
            local h = hex(digest:sub(1,6) .. char(byte(digest,7) % 16 + 48)
                .. digest:sub(8,8) .. char(byte(digest,9) % 64 + 128) .. digest:sub(10))
            return h:sub(1,8) .. "-" .. h:sub(9,12) .. "-" .. h:sub(13,16)
                .. "-" .. h:sub(17,20) .. "-" .. h:sub(21,32)
        end
        return {md5 = md5, md5_raw = md5_raw, form_encode = form_encode,
                constant_time_equal = constant_time_equal, name_uuid = name_uuid}
    end)()

    local SESSION_KEY = '__MasterLicenseSession_v1'
    local function loadSession()
        local g = rawget(_G, SESSION_KEY)
        if type(g) ~= 'table' or g.authorized ~= true then return nil end
        if type(g.expiresAt) == 'number' and g.expiresAt <= os.time() then
            _G[SESSION_KEY] = nil; return nil
        end
        return g
    end
    local function saveSession(expiresAt)
        pcall(function()
            _G[SESSION_KEY] = {authorized = true, expiresAt = expiresAt, issuedAt = os.time()}
        end)
    end
    local function clearSession() pcall(function() _G[SESSION_KEY] = nil end) end

    local CreateLocalExpiry = (function()
        return function(cfg, wallReader)
            local E = {}
            local expiredText = 'Mod expired. DM @HAMSECHEATS for renewal.'
            local tamperText  = "Don't be over smart"
            local blockedMessage, blockedPhase
            local function finite(n)
                return type(n) == 'number' and n == n and n ~= math.huge and n ~= -math.huge
            end
            local function parse(text)
                if type(text) ~= 'string' then return nil end
                local y,m,d,h,n,s = text:match('^(%d%d%d%d)%-(%d%d)%-(%d%d) (%d%d):(%d%d):(%d%d)$')
                y,m,d,h,n,s = tonumber(y),tonumber(m),tonumber(d),tonumber(h),tonumber(n),tonumber(s)
                if not y or y < 1970 or y > 9999 or m < 1 or m > 12 or h > 23 or n > 59 or s > 59 then return nil end
                local leap = y % 4 == 0 and (y % 100 ~= 0 or y % 400 == 0)
                local months = {31, leap and 29 or 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
                if d < 1 or d > months[m] then return nil end
                local prior = y - 1
                local days = 365 * (y - 1970) + math.floor(prior / 4) - math.floor(1969 / 4)
                    - math.floor(prior / 100) + math.floor(1969 / 100)
                    + math.floor(prior / 400) - math.floor(1969 / 400)
                for i = 1, m - 1 do days = days + months[i] end
                return (days + d - 1) * 86400 + h * 3600 + n * 60 + s - 6 * 3600
            end
            local configured = type(cfg.manualExpiry) == 'string'
                and cfg.manualExpiry:match('^%s*(.-)%s*$') or cfg.manualExpiry
            local expiry = parse(configured)
            local skew = cfg.clockSkew or 120
            if configured ~= nil and configured ~= '' and not expiry then
                blockedMessage, blockedPhase = 'Invalid local expiry date. Use YYYY-MM-DD HH:MM:SS.', 'error'
            end
            local function block(message, phase)
                if not blockedMessage then blockedMessage, blockedPhase = message, phase end
                return false, blockedMessage, blockedPhase
            end
            function E.Status() return not blockedMessage, blockedMessage, blockedPhase end
            function E.MarkTampered() return block(tamperText, 'tampered') end
            function E.GetExpiry() return expiry end
            function E.Accept(server, now, world, phone, rtt)
                if blockedMessage then return E.Status() end
                if not finite(server) or not finite(now) or now < 0 or world == nil
                    or not finite(rtt) or rtt < 0 or not finite(phone) then
                    return block('Clock verification unavailable.', 'error')
                end
                if math.abs(phone - server) > skew + rtt then return E.MarkTampered() end
                if expiry and server + rtt >= expiry then return block(expiredText, 'expired') end
                return true
            end
            return E
        end
    end)()

    local CreateAuth = (function()
        return function(P, cfg, deps)
            local A = {}
            local phase, message = 'locked', 'Enter your key to sign in.'
            local allowed, pending, generation = false, nil, 0
            local expiresAt
            local lastRequestLatencyMs, lastResponseTime, lastResponseWorld
            local startFn, stopFn, payloadStarted, restartRequired
            local localExpiry = deps.localExpiry
            do
                local stored = loadSession()
                if stored then
                    allowed = true; expiresAt = stored.expiresAt
                    phase, message = 'active', 'Session restored'
                end
            end
            if localExpiry then
                local ok, text, state = localExpiry.Status()
                if not ok then message, phase = text, state end
            end
            local function finite(n)
                return type(n) == 'number' and n == n and n ~= math.huge and n ~= -math.huge
            end
            local function readClock()
                local ok, n, w = pcall(deps.clock)
                if ok and finite(n) and n >= 0 and w ~= nil then return n, w end
            end
            local function notify(text, state)
                message, phase = text, state
                if type(deps.status) == 'function' then pcall(deps.status, text, state) end
            end
            local function stopPayload()
                if payloadStarted then
                    payloadStarted = false
                    local ok, accepted = pcall(stopFn)
                    if not ok or accepted == false then restartRequired = true end
                end
            end
            local function revoke(text, state)
                generation = generation + 1
                allowed, pending, expiresAt = false, nil, nil
                lastRequestLatencyMs, lastResponseTime, lastResponseWorld = nil, nil, nil
                stopPayload()
                local localDenied = false
                if localExpiry then
                    local ok, localText, localPhase = localExpiry.Status()
                    if not ok then text, state, localDenied = localText, localPhase, true end
                end
                notify(restartRequired and not localDenied
                    and 'Restart required: payload cleanup failed.' or text, state or 'error')
            end
            local function startPayload()
                if payloadStarted or not startFn then return true end
                payloadStarted = true
                local before = generation
                local ok, accepted = pcall(startFn)
                if not ok or accepted == false then
                    restartRequired = true
                    revoke('Restart required: offline script startup failed.', 'error')
                    return false
                end
                return generation == before and allowed
            end
            local function denyReason(reason)
                if type(reason) ~= 'string' then return 'Expired' end
                local lower = reason:sub(1, 120):lower():gsub('[_%s%-]+', ' ')
                if lower == 'max devices' or lower == 'maximum devices'
                    or lower == 'max devices reached' then
                    return 'Max Devices'
                end
                local clean = reason
                for _, field in ipairs({'key', 'serial'}) do
                    if pending and type(pending[field]) == 'string' and #pending[field] > 0 then
                        local needle = pending[field]:gsub('([^%w])', '%%%1')
                        clean = clean:gsub(needle, '[' .. field .. ']')
                    end
                end
                if type(cfg.secret) == 'string' and #cfg.secret > 0 then
                    clean = clean:gsub(cfg.secret:gsub('([^%w])', '%%%1'), '[credential]')
                end
                clean = clean:gsub('[%c]', ' '):sub(1, 120)
                return clean == '' and 'Expired' or ('Expired: ' .. clean)
            end
            local function configuredExpiry(result)
                if cfg.expiryPath == nil then return nil, true end
                if type(cfg.expiryPath) ~= 'table' or #cfg.expiryPath == 0 then return nil, false end
                local v = result
                for _, name in ipairs(cfg.expiryPath) do
                    if type(v) ~= 'table' then return nil, false end
                    v = rawget(v, name)
                end
                return v, finite(v) and v > 0 and v % 1 == 0
            end
            local function begin(key)
                if restartRequired or pending then return false end
                if localExpiry then
                    local ok, text, state = localExpiry.Status()
                    if not ok then revoke(text, state); return false end
                end
                if type(key) ~= 'string' then key = '' end
                key = key:match('^%s*(.-)%s*$')
                if #key == 0 or #key > 512 then
                    revoke('Expired: enter a valid key.', 'denied'); return false
                end
                local now, world = readClock()
                if not now then
                    revoke('Game clock unavailable. Try again in a match.', 'error'); return false
                end
                local okSerial, serial = pcall(deps.serial, key)
                if not okSerial or type(serial) ~= 'string' or #serial == 0 or #serial > 512 then
                    revoke('Device identifier unavailable.', 'error'); return false
                end
                generation = generation + 1
                local requestId = generation
                pending = {id = requestId, key = key, serial = serial,
                           started = now, world = world, deadline = now + cfg.timeout}
                notify('Signing in...', 'pending')
                if not pending or pending.id ~= requestId or generation ~= requestId then return false end
                local body = 'game=' .. P.form_encode(cfg.game)
                    .. '&user_key=' .. P.form_encode(key)
                    .. '&serial=' .. P.form_encode(serial)
                local function received(success, raw)
                    if not pending or pending.id ~= requestId or generation ~= requestId then return end
                    local current, worldNow = readClock()
                    if not current or worldNow ~= pending.world or current < pending.started
                        or current >= pending.deadline then
                        revoke('Request expired. Please sign in again.', 'error'); return
                    end
                    if success ~= true or type(raw) ~= 'string' or #raw == 0 or #raw > 32768 then
                        revoke('Connection failed. Please try again.', 'error'); return
                    end
                    local ok, result = pcall(deps.decode, raw)
                    if not ok or type(result) ~= 'table' then
                        revoke('Invalid server response.', 'error'); return
                    end
                    if result.status ~= true then revoke(denyReason(result.reason), 'denied'); return end
                    local data = result.data
                    if type(data) ~= 'table' or type(data.token) ~= 'string' or #data.token ~= 32
                        or not data.token:match('^[%x]+$') or not finite(data.rng) or data.rng % 1 ~= 0 then
                        revoke('Incomplete server response.', 'error'); return
                    end
                    local expected = P.md5(cfg.game .. '-' .. key .. '-' .. serial .. '-' .. cfg.secret)
                    if not P.constant_time_equal(data.token:lower(), expected) then
                        revoke('Server token verification failed.', 'denied'); return
                    end
                    local okWall, wall = pcall(deps.wall)
                    if not okWall or not finite(wall) then
                        revoke('Phone clock unavailable.', 'error'); return
                    end
                    if localExpiry then
                        local accepted, text, state = localExpiry.Accept(
                            data.rng, current, worldNow, wall, current - pending.started)
                        if not accepted then revoke(text, state); return end
                    elseif math.abs(wall - data.rng) > cfg.clockSkew then
                        revoke('Phone/server clock mismatch. Check automatic time.', 'error'); return
                    end
                    local expiry, validExpiry = configuredExpiry(result)
                    if not validExpiry then
                        revoke('Configured server expiry field is missing or invalid.', 'error'); return
                    end
                    if expiry and expiry - data.rng - (current - pending.started) <= 0 then
                        revoke('Expired', 'denied'); return
                    end
                    local fixedExpiry = localExpiry and localExpiry.GetExpiry()
                    if fixedExpiry then expiry = math.min(expiry or fixedExpiry, fixedExpiry) end
                    lastRequestLatencyMs = (current - pending.started) * 1000
                    lastResponseTime, lastResponseWorld = current, worldNow
                    pending = nil
                    allowed, expiresAt = true, expiry
                    saveSession(expiresAt)
                    if not startPayload() then return end
                    notify('Login successful.', 'active')
                end
                local ok, accepted = pcall(deps.post, cfg.url,
                    {['Content-Type'] = 'application/x-www-form-urlencoded'},
                    body, received, cfg.timeout)
                if not ok or accepted == false then
                    revoke('HTTP request could not start.', 'error'); return false
                end
                return true
            end
            function A.Login(key) if allowed then return false end; return begin(key) end
            function A.Tick()
                if not pending then return end
                local now, world = readClock()
                if not now or world ~= pending.world or now < pending.started then
                    revoke('Login interrupted by map loading. Please try again when ready.', 'locked'); return
                end
                if now >= pending.deadline then
                    revoke('Request timed out. Please try again.', 'error')
                end
            end
            function A.IsAuthorized()
                if allowed and not restartRequired then return true end
                local stored = loadSession()
                if stored and not restartRequired then
                    allowed = true; expiresAt = stored.expiresAt; return true
                end
                return false
            end
            function A.Logout() clearSession(); revoke('Expired: signed out.', 'locked') end
            function A.FailClosed(text, requiresRestart)
                if requiresRestart == true then restartRequired = true end
                revoke(text or 'Online access unavailable.', 'error')
            end
            function A.ReportClockTampering()
                if localExpiry then localExpiry.MarkTampered() end
                revoke("Don't be over smart", 'tampered')
            end
            function A.Bind(onStart, onStop)
                if type(onStart) ~= 'function' or type(onStop) ~= 'function' then
                    return false, 'START_AND_STOP_REQUIRED'
                end
                if startFn and (startFn ~= onStart or stopFn ~= onStop) then
                    return false, 'ALREADY_BOUND'
                end
                startFn, stopFn = onStart, onStop
                if A.IsAuthorized() then return startPayload() end
                return true
            end
            function A.Unbind()
                revoke('Offline script disconnected.', 'locked')
                startFn, stopFn = nil, nil
            end
            function A.GetRemainingSeconds() return nil end
            function A.GetState()
                local authorized = A.IsAuthorized()
                local sample, age
                if authorized and lastRequestLatencyMs ~= nil then
                    local now, world = readClock()
                    if now and world == lastResponseWorld and now >= lastResponseTime then
                        sample, age = lastRequestLatencyMs, now - lastResponseTime
                    end
                end
                return {
                    phase = phase, message = message, authorized = authorized,
                    sessionAuthorized = authorized, expiresAt = expiresAt,
                    accessPolicy = "game_session", expiryCheckPolicy = "login_only",
                    periodicRecheck = false, pending = pending ~= nil,
                    linked = startFn ~= nil, restartRequired = restartRequired == true,
                    lastRequestLatencyMs = sample, lastRequestLatencyAgeSeconds = age,
                    latencyScope = "license_http_round_trip"
                }
            end
            return A
        end
    end)()

    local Core = {Primitives = Primitives, createExpiry = CreateLocalExpiry}
    function Core.new(config, dependencies)
        assert(type(config) == 'table' and type(dependencies) == 'table',
            'License configuration and dependencies required')
        local deps = {}
        for key, value in pairs(dependencies) do deps[key] = value end
        if deps.localExpiry == nil then deps.localExpiry = CreateLocalExpiry(config, deps.wall) end
        return CreateAuth(Primitives, config, deps)
    end
    return Core
end)()

-- ============================================================================
-- ============================================================================
-- 2. LOGIN UI  —  v3  (Login your key / clear button / premium ad banner)
-- ============================================================================
local MasterLoginUI = (function()
    local Module = {}
    function Module.new(env)
        env = env or _G
        local require = env.require or require
        local function global(name)
            local ok, v = pcall(function() return env[name] end)
            if ok then return v end
        end
        local UI = {_status = "Enter your key to sign in", _busy = false, _data = nil}
        local function member(o, k)
            if o == nil then return nil end
            local ok, v = pcall(function() return o[k] end)
            if ok then return v end
        end
        local function valid(o)
            if o == nil then return false end
            local chk = member(global("slua"), "isValid")
            if type(chk) == "function" then
                local ok, r = pcall(chk, o); if ok and r == true then return true end
            end
            local g = global("Game"); local fb = member(g, "IsValid")
            if type(fb) == "function" then
                local ok, r = pcall(fb, g, o); return ok and r == true
            end
            return false
        end
        local function imported(name)
            local ld = global("import")
            if type(ld) ~= "function" then return nil end
            local ok, r = pcall(ld, name); if ok then return r end
        end
        local function construct(cls, ...)
            if cls == nil then return nil end
            local ok, r = pcall(cls, ...); if ok then return r end
        end
        local function vector(x, y)
            return construct(global("FVector2D") or imported("Vector2D"), x, y) or {X=x, Y=y}
        end
        local function color(r, g, b, a)
            return construct(global("FLinearColor") or imported("LinearColor"), r, g, b, a)
                or {R=r, G=g, B=b, A=a}
        end
        local function visibility(w, v)
            local s = member(w, "SetWidgetVisibility") or member(w, "SetVisibility")
            assert(type(s) == "function", "UI_VISIBILITY_UNAVAILABLE"); s(w, v)
        end
        local function setTextStyle(w, sz, col)
            pcall(function()
                local f = w.Font
                if f then
                    f.Size = math.max(1, math.floor(sz * (UI._scale or 1) + 0.5))
                    local ok = pcall(function() w.Font = f end)
                    if not ok then w:SetFont(f) end
                end
            end)
            pcall(function() w:SetAutoWrapText(true) end)
            pcall(function()
                local sl = construct(imported("SlateColor"), col)
                if sl then w:SetColorAndOpacity(sl) end
            end)
        end
        local function detach(d)
            if not d then return end
            d.visible = false
            pcall(function() if valid(d.input) then d.input:SetText("") end end)
            if d.event and d.eventHandle ~= nil then
                pcall(function() d.event:Remove(d.eventHandle) end)
            end
            if d.closeEvent and d.closeEventHandle ~= nil then
                pcall(function() d.closeEvent:Remove(d.closeEventHandle) end)
            end
            if d.clrEvent and d.clrHandle ~= nil then
                pcall(function() d.clrEvent:Remove(d.clrHandle) end)
            end
            if valid(d.container) then
                pcall(function() d.container:RemoveFromParent() end)
            end
            d.onSubmit = nil
        end
        function UI.Destroy()
            local prev = UI._data; UI._data = nil; detach(prev)
        end
        function UI.Tick(dt)
            local d = UI._data
            if not d or not d.visible or not valid(d.container) then return false end
            local t = tonumber(dt) or (1/60)
            t = math.max(0, math.min(t, 0.1))
            d.animClock = ((d.animClock or 0) + t) % 6.283185307
            local pulse = (math.sin(d.animClock * 1.4) + 1) * 0.5
            local ok = pcall(function()
                if valid(d.halo) then
                    d.halo:SetBrushColor(color(0.49, 0.23, 0.93, 0.05 + pulse * 0.08))
                end
                if valid(d.buttonGlow) then
                    d.buttonGlow:SetBrushColor(color(0.49, 0.23, 0.93, 0.15 + pulse * 0.18))
                end
                if valid(d.adPulse) then
                    d.adPulse:SetBrushColor(color(0.49, 0.23, 0.93, 0.25 + pulse * 0.55))
                end
                if d.scanSlot then
                    local travel = (d.animClock % 3.2) / 3.2
                    local scanX = 14 + travel * math.max(1, d.width - 80)
                    d.scanSlot:SetPosition(vector(scanX * (d.scale or 1), 60 * (d.scale or 1)))
                    if valid(d.scan) then
                        d.scan:SetBrushColor(color(0.49, 0.23, 0.93, 0.05 + pulse * 0.07))
                    end
                end
            end)
            return ok
        end
        function UI.Hide()
            local d = UI._data
            if not d or d.hiddenApplied then return true end
            d.visible = false
            local ok = pcall(function()
                if valid(d.input) then d.input:SetText("") end
                if valid(d.container) then visibility(d.container, d.hidden) end
            end)
            if ok then d.hiddenApplied = true end
            return ok
        end
        function UI.SetStatus(msg)
            UI._status = type(msg) == "string" and msg:sub(1, 160) or "Enter your key to sign in"
            local d = UI._data
            if d and d.deliveredStatus == UI._status then return true end
            if d and valid(d.status) then
                local ok = pcall(function() d.status:SetText(UI._status) end)
                if ok then d.deliveredStatus = UI._status end
                return ok
            end
            return false
        end
        function UI.SetBusy(busy)
            UI._busy = busy == true
            local d = UI._data
            if d then
                if d.deliveredBusy == UI._busy then return true end
                local bOK = pcall(function() d.button:SetIsEnabled(not UI._busy) end)
                local iOK = pcall(function() d.input:SetIsEnabled(not UI._busy) end)
                if bOK and iOK then d.deliveredBusy = UI._busy; return true end
            end
            return false
        end
        local function fitScale(parent)
            local r = 1
            pcall(function()
                local sz = parent:GetCachedGeometry():GetLocalSize()
                local w, h = sz.X, sz.Y
                if type(w) == "number" and type(h) == "number" and w > 24 and h > 24 then
                    r = math.min(1, (w - 24) / 540, (h - 24) / 310)
                end
            end)
            return r
        end
        function UI.Show(onSubmit)
            if type(onSubmit) ~= "function" then return false, "UI_SUBMIT_REQUIRED" end
            local d = UI._data
            if d and valid(d.parent)
                and math.abs(fitScale(d.parent) - (d.scale or 1)) > 0.001 then
                UI.Destroy(); d = nil
            end
            if d and valid(d.container) and valid(d.parent) then
                local ok = d.visible or pcall(function()
                    visibility(d.container, d.visibleEnum)
                end)
                if ok then
                    d.onSubmit, d.visible, d.hiddenApplied = onSubmit, true, false
                    UI.SetStatus(UI._status); UI.SetBusy(UI._busy); return true
                end
            end
            UI.Destroy()
            local okT, uiT = pcall(require, "GameLua.Mod.BaseMod.Common.UI.InGameUITools")
            local getRoot = okT and member(uiT, "GetMainControlBaseUI")
            if type(getRoot) ~= "function" then return false, "UI_NOT_READY" end
            local okR, root = pcall(getRoot)
            if not okR or not valid(root) then return false, "UI_NOT_READY" end
            local parent = member(root, "CanvasPanel_0")
            if not valid(parent) then parent = member(root, "CanvasPanel_42") end
            if not valid(parent) then return false, "UI_NOT_READY" end
            local game = global("CGame")
            if type(member(game, "NewObjectFromPath")) ~= "function" then
                return false, "UI_FACTORY_UNAVAILABLE"
            end
            local enums = member(global("UEnums"), "ESlateVisibility")
            local visibleEnum = member(enums, "Visible")
            local hidden      = member(enums, "Collapsed")
            local passive     = member(enums, "SelfHitTestInvisible")
            if visibleEnum == nil or hidden == nil or passive == nil then
                return false, "UI_ENUM_UNAVAILABLE"
            end
            UI._scale = fitScale(parent)
            d = {parent=parent, visible=false, onSubmit=onSubmit,
                 visibleEnum=visibleEnum, hidden=hidden, scale=UI._scale}
            local okBuild = pcall(function()
                local function make(cls, outer)
                    local w = game:NewObjectFromPath("/Script/UMG." .. cls, outer)
                    assert(valid(w), "UI_WIDGET_UNAVAILABLE"); return w
                end
                local function add(w, x, y, ww, hh, z)
                    local slot = d.container:AddChildToCanvas(w)
                    slot:SetAutoSize(false)
                    slot:SetPosition(vector(x * UI._scale, y * UI._scale))
                    slot:SetSize(vector(ww * UI._scale, hh * UI._scale))
                    slot:SetZOrder(z); return slot
                end

                -- ══════════════════════════════════════════════════════
                --  CARD: 540 × 310   dark #0D0D14, purple accent #7C3AED
                -- ══════════════════════════════════════════════════════
                local W, H = 540, 310
                d.width = W
                d.container = make("CanvasPanel", parent)

                -- Outer glow halo (animated)
                local halo = make("Border", d.container)
                d.halo = halo
                halo:SetBrushColor(color(0.49, 0.23, 0.93, 0.07))
                visibility(halo, passive)
                add(halo, -4, -4, W+8, H+8, 0)

                -- Main bg
                local bg = make("Border", d.container)
                bg:SetBrushColor(color(0.051, 0.051, 0.078, 0.97))
                visibility(bg, visibleEnum)
                add(bg, 0, 0, W, H, 1)

                -- Top accent bar (purple)
                local topBar = make("Border", d.container)
                topBar:SetBrushColor(color(0.49, 0.23, 0.93, 1.0))
                visibility(topBar, passive)
                add(topBar, 0, 0, W, 2, 3)

                -- Bottom accent bar (cyan tint)
                local botBar = make("Border", d.container)
                botBar:SetBrushColor(color(0.02, 0.72, 0.84, 1.0))
                visibility(botBar, passive)
                add(botBar, 0, H-2, W, 2, 3)

                -- Header divider
                local div = make("Border", d.container)
                div:SetBrushColor(color(0.49, 0.23, 0.93, 0.28))
                visibility(div, passive)
                add(div, 20, 58, W-40, 1, 3)

                -- Scan shimmer
                d.scan = make("Border", d.container)
                d.scan:SetBrushColor(color(0.49, 0.23, 0.93, 0.06))
                visibility(d.scan, passive)
                d.scanSlot = add(d.scan, 14, 60, 60, 1, 2)

                -- Icon box bg
                local iconBg = make("Border", d.container)
                iconBg:SetBrushColor(color(0.49, 0.23, 0.93, 1.0))
                visibility(iconBg, passive)
                add(iconBg, 20, 12, 32, 32, 5)

                -- Icon symbol
                local iconMark = make("TextBlock", d.container)
                iconMark:SetText("*")
                setTextStyle(iconMark, 16, color(1.0, 1.0, 1.0, 1.0))
                visibility(iconMark, passive)
                add(iconMark, 28, 18, 18, 18, 6)

                -- Title "LOGIN YOUR KEY"
                local title = make("TextBlock", d.container)
                title:SetText("LOGIN YOUR KEY")
                setTextStyle(title, 17, color(0.95, 0.94, 1.0, 1.0))
                visibility(title, passive)
                add(title, 60, 14, 320, 24, 5)

                -- Subtitle
                local sub = make("TextBlock", d.container)
                sub:SetText("Hamse Cheats  —  Online License Server")
                setTextStyle(sub, 10, color(0.42, 0.42, 0.50, 1.0))
                visibility(sub, passive)
                add(sub, 61, 38, 320, 16, 5)

                -- Close button
                d.closeButton = make("Button", d.container)
                pcall(function() d.closeButton:SetBackgroundColor(color(0.07, 0.07, 0.11, 1.0)) end)
                visibility(d.closeButton, visibleEnum)
                local cLbl = make("TextBlock", d.closeButton)
                cLbl:SetText("x")
                setTextStyle(cLbl, 13, color(0.42, 0.42, 0.50, 1.0))
                visibility(cLbl, passive)
                d.closeButton:AddChild(cLbl)
                add(d.closeButton, W-36, 10, 24, 24, 8)
                d.closeEvent = d.closeButton.OnClicked
                d.closeEventHandle = d.closeEvent:Add(function()
                    if UI._data == d and d.visible then UI.Hide() end
                end)

                -- Label
                local lbl = make("TextBlock", d.container)
                lbl:SetText("License key")
                setTextStyle(lbl, 11, color(0.55, 0.54, 0.62, 1.0))
                visibility(lbl, passive)
                add(lbl, 24, 70, W-48, 15, 5)

                -- Input outer glow
                local iGlow = make("Border", d.container)
                iGlow:SetBrushColor(color(0.49, 0.23, 0.93, 0.18))
                visibility(iGlow, passive)
                add(iGlow, 22, 88, W-44, 42, 4)

                -- Input border
                local iBorder = make("Border", d.container)
                iBorder:SetBrushColor(color(0.49, 0.23, 0.93, 0.50))
                visibility(iBorder, passive)
                add(iBorder, 23, 89, W-46, 40, 5)

                -- Input bg
                local iBg = make("Border", d.container)
                iBg:SetBrushColor(color(0.047, 0.047, 0.072, 0.99))
                visibility(iBg, passive)
                add(iBg, 24, 90, W-48, 38, 6)

                -- Input field (shows typed key as-is, supports backspace natively)
                d.input = make("EditableTextBox", d.container)
                d.input:SetText("")
                setTextStyle(d.input, 13, color(0.91, 0.91, 0.97, 1.0))
                pcall(function() d.input:SetHintText("") end)
                visibility(d.input, visibleEnum)
                -- leave right margin so clear button does not overlap text
                add(d.input, 32, 93, W-80, 32, 7)

                -- Clear button (x) inside input
                d.clrBtn = make("Button", d.container)
                pcall(function() d.clrBtn:SetBackgroundColor(color(0.0, 0.0, 0.0, 0.0)) end)
                visibility(d.clrBtn, visibleEnum)
                local clrLbl = make("TextBlock", d.clrBtn)
                clrLbl:SetText("x")
                setTextStyle(clrLbl, 13, color(0.42, 0.42, 0.52, 1.0))
                visibility(clrLbl, passive)
                d.clrBtn:AddChild(clrLbl)
                add(d.clrBtn, W-54, 93, 26, 32, 8)
                d.clrEvent = d.clrBtn.OnClicked
                d.clrHandle = d.clrEvent:Add(function()
                    if UI._data ~= d or not d.visible or UI._busy then return end
                    pcall(function() d.input:SetText("") end)
                    UI.SetStatus("Enter your key to sign in")
                end)

                -- Status text
                d.status = make("TextBlock", d.container)
                d.status:SetText(UI._status)
                d.deliveredStatus = UI._status
                setTextStyle(d.status, 11, color(0.55, 0.54, 0.62, 1.0))
                visibility(d.status, passive)
                pcall(function() d.status:SetAutoWrapText(true) end)
                add(d.status, 24, 138, W-48, 18, 5)

                -- Auth button glow
                local btnW, btnH = 310, 42
                local btnX = (W - btnW) / 2
                local btnY = 162
                d.buttonGlow = make("Border", d.container)
                d.buttonGlow:SetBrushColor(color(0.49, 0.23, 0.93, 0.18))
                visibility(d.buttonGlow, passive)
                add(d.buttonGlow, btnX-3, btnY-2, btnW+6, btnH+4, 5)

                -- Auth button
                d.button = make("Button", d.container)
                pcall(function() d.button:SetBackgroundColor(color(0.49, 0.23, 0.93, 1.0)) end)
                visibility(d.button, visibleEnum)
                local bLbl = make("TextBlock", d.button)
                bLbl:SetText("Authenticate")
                setTextStyle(bLbl, 14, color(0.98, 0.98, 1.0, 1.0))
                visibility(bLbl, passive)
                d.button:AddChild(bLbl)
                add(d.button, btnX, btnY, btnW, btnH, 6)

                -- ── AD BANNER ───────────────────────────────────
                local adBg = make("Border", d.container)
                adBg:SetBrushColor(color(0.038, 0.038, 0.058, 0.97))
                visibility(adBg, passive)
                add(adBg, 24, 214, W-48, 50, 4)

                local adBorder = make("Border", d.container)
                adBorder:SetBrushColor(color(0.12, 0.12, 0.18, 1.0))
                visibility(adBorder, passive)
                add(adBorder, 24, 214, W-48, 50, 5)

                -- Left color stripe
                local adStripe = make("Border", d.container)
                adStripe:SetBrushColor(color(0.49, 0.23, 0.93, 1.0))
                visibility(adStripe, passive)
                add(adStripe, 24, 214, 4, 50, 6)

                -- Ad tag line
                local adTag = make("TextBlock", d.container)
                adTag:SetText("OFFICIAL CHANNEL")
                setTextStyle(adTag, 9, color(0.30, 0.30, 0.38, 1.0))
                visibility(adTag, passive)
                add(adTag, 36, 218, W-80, 12, 7)

                -- Ad title
                local adTitle = make("TextBlock", d.container)
                adTitle:SetText("HAMSE CHEATS 4.7.0 ")
                setTextStyle(adTitle, 12, color(0.77, 0.76, 0.88, 1.0))
                visibility(adTitle, passive)
                add(adTitle, 36, 231, W-80, 16, 7)

                -- Ad sub
                local adSub = make("TextBlock", d.container)
                adSub:SetText("Owner: @hamsecheatsvip  Online pybass Updates  Support")
                setTextStyle(adSub, 9, color(0.35, 0.35, 0.45, 1.0))
                visibility(adSub, passive)
                add(adSub, 36, 248, W-80, 13, 7)

                -- Animated pulse dot on ad
                d.adPulse = make("Border", d.container)
                d.adPulse:SetBrushColor(color(0.49, 0.23, 0.93, 0.5))
                visibility(d.adPulse, passive)
                add(d.adPulse, W-40, 220, 6, 6, 8)

                -- Footer row
                local foot = make("TextBlock", d.container)
                foot:SetText("Encrypted   |   Instant verify   |   24/7 Support")
                setTextStyle(foot, 9, color(0.24, 0.24, 0.32, 1.0))
                visibility(foot, passive)
                add(foot, 24, 274, W-48, 14, 5)

                -- ── BUTTON HANDLER ───────────────────────────────
                d.event = d.button.OnClicked
                d.eventHandle = d.event:Add(function()
                    if UI._data ~= d or not d.visible or UI._busy then return end
                    local rOK, key = pcall(function() return d.input:GetText() end)
                    if not rOK or type(key) ~= "string" then
                        UI.SetStatus("Cannot read key — try again"); return
                    end
                    key = key:match("^%s*(.-)%s*$")
                    if key == "" then
                        UI.SetStatus("Key field cannot be empty"); return
                    end
                    if #key > 512 then
                        UI.SetStatus("Key is too long"); return
                    end
                    local sOK, accepted = pcall(d.onSubmit, key)
                    if not sOK or accepted ~= true then
                        UI.SetBusy(false)
                        UI.SetStatus("Login could not start — wait for game ready, then retry")
                    end
                end)

                local slot = parent:AddChildToCanvas(d.container)
                slot:SetAutoSize(false)
                slot:SetSize(vector(W * UI._scale, H * UI._scale))
                slot:SetZOrder(9000)
                local anchors = slot:GetAnchors()
                anchors.Minimum, anchors.Maximum = vector(0.5, 0.5), vector(0.5, 0.5)
                slot:SetAnchors(anchors)
                slot:SetAlignment(vector(0.5, 0.5))
                slot:SetPosition(vector(0, 0))
                visibility(d.container, passive)
            end)

            if not okBuild then detach(d); return false, "UI_BUILD_UNAVAILABLE" end
            d.visible = true; UI._data = d; UI.SetBusy(UI._busy)
            pcall(function() visibility(d.container, d.visibleEnum) end)
            return true
        end
        function UI.ShowNotice(message)
            local shown, reason = UI.Show(function() return false end)
            if not shown then return false, reason end
            UI.SetStatus(message); UI.SetBusy(true); return true
        end
        return UI
    end
    return Module
end)()


-- ============================================================================
-- 3. WELCOME UI REMOVED

-- 4. LICENSE RUNTIME
-- ============================================================================
local MasterLicenseRuntime = (function()
    local Runtime = {}
    Runtime.__index = Runtime
    local function finite(n)
        return type(n) == 'number' and n == n and n >= 0 and n < math.huge
    end
    local function read(o, k)
        if o == nil then return nil end
        local ok, v = pcall(function() return o[k] end)
        if ok then return v end
    end
    local function static(o, k, ...)
        local fn = read(o, k)
        if type(fn) ~= 'function' then return nil end
        local ok, v = pcall(fn, ...); if ok then return v end
    end
    local function call(o, k, ...)
        local fn = read(o, k)
        if type(fn) ~= 'function' then return nil end
        local ok, v = pcall(fn, o, ...); if ok then return v end
    end
    local function validConfig(c)
        return type(c) == 'table' and type(c.url) == 'string' and c.url:match('^https://') ~= nil
            and type(c.game) == 'string' and #c.game > 0
            and type(c.secret) == 'string' and #c.secret > 0
            and finite(c.timeout) and c.timeout > 0 and finite(c.clockSkew)
    end
    function Runtime.new(env, config, Core, LoginUI)
        local self = setmetatable({
            env = env or _G, reason = 'login_required', active = false,
            ready = false, disposed = false, uiRetryAt = 0, uiFailures = 0
        }, Runtime)
        if not validConfig(config) or type(Core) ~= 'table' or type(Core.new) ~= 'function'
            or type(Core.Primitives) ~= 'table' then
            self.reason = 'license_dependencies_unavailable'; return self
        end
        local cfg = {}
        for k, v in pairs(config) do cfg[k] = v end
        self.timeout = cfg.timeout
        if type(LoginUI) == 'table' and type(LoginUI.new) == 'function' then
            local ok, ui = pcall(LoginUI.new, self.env)
            if ok and type(ui) == 'table' then self.ui = ui end
        end
        self.submit = function(key) return self:login(key) end
        local ok, auth = pcall(Core.new, cfg, {
            clock = function() return self:_clock() end,
            wall = function()
                local value = static(read(self.env, 'os'), 'time')
                if finite(value) and value > 0 then return value end
            end,
            serial = function(key)
                local client = read(self.env, 'Client')
                local value = static(client, 'GetPhoneDeviceID')
                assert(type(value) == 'string' and #value > 0 and #value <= 512,
                    'DEVICE_ID_UNAVAILABLE')
                return Core.Primitives.name_uuid('MASTER-LUA-V1\0' .. key .. '\0' .. value)
            end,
            decode = function(raw)
                local json = self:_module('json', nil, 'common.json_util', 'decode')
                assert(json, 'JSON_UNAVAILABLE')
                return json.decode(raw)
            end,
            post = function(url, headers, body, callback, timeout)
                local manager = read(self.env, 'ModuleManager')
                local config = read(manager, 'CommonModuleConfig')
                local getter = read(manager, 'GetModule')
                assert(type(getter) == 'function' and config, 'HTTP_MANAGER_UNAVAILABLE')
                local http = getter(read(config, 'http_manager'))
                local post = read(http, 'Post')
                assert(type(post) == 'function', 'HTTP_POST_UNAVAILABLE')
                return post(http, url, headers, body, nil, callback, timeout)
            end,
            status = function(message, phase)
                self.active = false
                self.reason = phase == 'active' and 'waiting_maintenance' or 'login_required'
                self:_ui('SetStatus', message)
                self:_ui('SetBusy', phase == 'pending')
                if phase == 'active' then self:_ui('Hide') end
            end,
        })
        if ok and type(auth) == 'table' then self.auth = auth
        else self.reason = 'license_initialization_unavailable' end
        return self
    end
    function Runtime:_module(cache, globalName, path, method)
        local found = globalName and read(self.env, globalName)
        if type(read(found, method)) == 'function' then return found end
        found = self[cache]
        if type(read(found, method)) == 'function' then return found end
        local loader = read(self.env, 'require')
        if type(loader) == 'function' then
            local ok, value = pcall(loader, path)
            if ok and type(read(value, method)) == 'function' then
                self[cache] = value; return value
            end
        end
    end
    function Runtime:_valid(object)
        if object == nil then return false end
        if static(read(self.env, 'slua'), 'isValid', object) == true then return true end
        return call(read(self.env, 'Game'), 'IsValid', object) == true
    end
    function Runtime:_clock()
        local world = static(read(self.env, 'slua'), 'getWorld')
        if world == nil then return nil end
        local statics = read(self.env, 'GameplayStatics') or self.statics
        if type(read(statics, 'GetRealTimeSeconds')) ~= 'function' then
            local loader = read(self.env, 'import')
            if type(loader) == 'function' then
                local ok, value = pcall(loader, 'GameplayStatics')
                if ok then statics = value end
            end
        end
        if type(read(statics, 'GetRealTimeSeconds')) ~= 'function' then return nil end
        self.statics = statics
        local now = static(statics, 'GetRealTimeSeconds', world)
        if finite(now) then return now, world end
    end
    function Runtime:_readGameplay(world)
        local data = read(self.env, 'GameplayData') or self.gameplayData
        if data == nil then
            local loader = read(self.env, 'require')
            if type(loader) == 'function' then
                local ok, value = pcall(loader, 'GameLua.GameCore.Data.GameplayData')
                if ok and value ~= nil then self.gameplayData = value; data = value end
            end
        end
        local pc = static(data, 'GetPlayerController')
        if not self:_valid(pc) and not self:_valid(read(pc, 'Object')) then
            pc = call(read(self.env, 'slua_GameFrontendHUD'), 'GetPlayerController')
        end
        if not self:_valid(pc) and not self:_valid(read(pc, 'Object')) then
            return nil, 'waiting_controller'
        end
        local pawn = static(data, 'GetPlayerCharacter')
        if not self:_valid(pawn) then pawn = static(data, 'GetLocalCharacter') end
        for _, method in ipairs({'GetPlayerCharacterSafety', 'GetCurPawn', 'GetPawn'}) do
            if not self:_valid(pawn) then pawn = call(pc, method) end
            if not self:_valid(pawn) then pawn = call(read(pc, 'Object'), method) end
        end
        if not self:_valid(pawn) then return nil, 'waiting_pawn' end
        local tools = self:_module('tools', nil,
            'GameLua.Mod.BaseMod.Common.UI.InGameUITools', 'GetMainControlBaseUI')
        local root = static(tools, 'GetMainControlBaseUI')
        if not self:_valid(root) then return nil, 'waiting_control_ui' end
        local status = self:_module('gameStatus', 'GameStatus',
            'client.common.game_status', 'IsInFightingStatus')
        local loading = self:_module('loading', nil,
            'client.slua.logic.loading.logic_loading', 'IsShowing')
        if not status or not loading then return nil, 'readiness_services_unavailable' end
        if static(status, 'IsInFightingStatus') ~= true then return nil, 'waiting_gameplay' end
        if static(loading, 'IsShowing') ~= false then return nil, 'waiting_loading' end
        return {world = world, controller = pc, pawn = pawn, root = root}
    end
    local function same(a, b)
        return a and b and a.world == b.world and a.controller == b.controller
            and a.pawn == b.pawn and a.root == b.root
    end
    function Runtime:_ui(method, ...)
        local fn = read(self.ui, method)
        if type(fn) ~= 'function' then return false, 'UI_UNAVAILABLE' end
        local ok, value, reason = pcall(fn, ...)
        if not ok then return false, 'UI_TEMPORARILY_UNAVAILABLE' end
        return value, reason
    end
    function Runtime:_clearReadiness(reason)
        self.active, self.ready = false, false
        self.identity, self.readySince, self.maintenanceAt, self.maintenanceWorld = nil, nil, nil, nil
        self.reason = reason
        self:_ui('Hide')
    end
    function Runtime:_showPanel(now, state, blocked)
        if now < self.uiRetryAt then return false end
        local shown, uiReason
        if blocked then shown, uiReason = self:_ui('ShowNotice', state.message)
        else shown, uiReason = self:_ui('Show', self.submit) end
        if shown then
            self.uiFailures, self.uiError = 0, nil
            self:_ui('SetStatus', state.message)
            self:_ui('SetBusy', blocked or state.pending)
        else
            self.uiFailures = self.uiFailures + 1
            self.uiRetryAt = now + (self.uiFailures >= 10 and 5 or 1)
            self.uiError = type(uiReason) == 'string' and uiReason:match('^UI_[A-Z_]+$')
                or 'UI_UNAVAILABLE'
        end
        return shown == true
    end
    function Runtime:update()
        if self.disposed then self.reason = 'disposed'; return false end
        if not self.auth then return false end
        local tickOK = pcall(self.auth.Tick)
        if not tickOK then
            self.auth.FailClosed('License maintenance unavailable.')
            self:_clearReadiness('license_maintenance_unavailable'); return false
        end
        local now, world = self:_clock()
        if not now then self:_clearReadiness('clock_unavailable'); return false end
        local ready, reason = self:_readGameplay(world)
        if not ready then self:_clearReadiness(reason); return false end
        if not same(self.identity, ready) or not self.readySince or now < self.readySince then
            self.identity, self.readySince = ready, now
        end
        self.ready = now - self.readySince >= 0.5
        self.maintenanceAt, self.maintenanceWorld = now, world
        self.active = self.ready and self.auth.IsAuthorized()
        if not self.ready then
            self.reason = 'waiting_stable_gameplay'; self:_ui('Hide'); return false
        end
        local state = self.auth.GetState()
        if self.active then
            self.reason = 'active'
            self:_ui('Hide')
            return true
        end
        self.reason = 'login_required'
        if state.restartRequired or state.phase == 'expired' or state.phase == 'tampered' then
            self.reason = state.restartRequired and 'restart_required' or state.phase
            self:_showPanel(now, state, true); return false
        end
        if not self:_showPanel(now, state, false) and self.uiError then
            self.reason = 'login_ui_unavailable'
        end
        return false
    end
    function Runtime:isActive()
        if self.disposed or not self.auth or not self.active or not self.ready then return false end
        if not self.auth.IsAuthorized() then self.active = false; return false end
        local now, world = self:_clock()
        if not now or world ~= self.maintenanceWorld or not self.maintenanceAt
            or now < self.maintenanceAt or now - self.maintenanceAt >= 0.5 then
            self.active = false; self.reason = 'maintenance_stale'; return false
        end
        return true
    end
    function Runtime:login(key)
        if self.disposed or not self.auth then return false end
        if self.auth.IsAuthorized() then return true end
        local now, world = self:_clock()
        if not self.ready or not now or world ~= self.maintenanceWorld
            or not self.maintenanceAt or now < self.maintenanceAt
            or now - self.maintenanceAt >= 0.5 then return false end
        local identity = self:_readGameplay(world)
        if not same(identity, self.identity) then
            self:_clearReadiness('waiting_stable_gameplay'); return false
        end
        local ok, accepted = pcall(self.auth.Login, key)
        if not ok then self.auth.FailClosed('Login could not start.'); return false end
        return accepted == true
    end
    function Runtime:getStatus()
        local active = self:isActive()
        local state = self.auth and self.auth.GetState() or {}
        return {
            authorized = active, sessionAuthorized = state.authorized == true,
            phase = state.phase or 'locked',
            message = state.message or 'License dependencies unavailable.',
            reason = self.reason, pending = state.pending == true,
            gameplayReady = self.ready, expiresAt = state.expiresAt,
            accessPolicy = 'game_session', expiryCheckPolicy = 'login_only',
            clockProtection = 'login_only', periodicRecheck = false,
            loginDelaySeconds = 0.5, restartRequired = state.restartRequired == true,
            uiError = self.uiError,
            lastRequestLatencyMs = state.lastRequestLatencyMs,
            latencyScope = 'license_http_round_trip', disposed = self.disposed
        }
    end
    function Runtime:logout()
        self.active = false
        if self.auth then self.auth.Logout() end
        self.reason = 'login_required'; return true
    end
    function Runtime:dispose()
        if self.disposed then return true end
        self:logout(); self.disposed = true; self.ready = false
        self:_ui('Destroy'); self.reason = 'disposed'
        self.submit = nil
        return true
    end
    return Runtime
end)()

-- ============================================================================
-- LICENSE INSTANCE / GLOBAL GATE
-- ============================================================================
local masterBRLicenseInstance = nil

local function BREnsureOnlineLicense()
    if masterBRLicenseInstance then return masterBRLicenseInstance end

    local host = setmetatable({
        GameplayData = GameplayData,
    }, {__index = _ENV})

    local ok, instance = pcall(function()
        return MasterLicenseRuntime.new(
            host,
            MasterLicenseConfig,
            MasterLicenseCore,
            MasterLoginUI
        )
    end)

    if ok and type(instance) == "table" then
        masterBRLicenseInstance = instance
    end
    return masterBRLicenseInstance
end

local function BRLicenseActive()
    local inst = BREnsureOnlineLicense()
    local active = false
    if inst then
        pcall(function()
            active = inst:isActive() == true
        end)
    end

    -- Compatibility state for existing feature code.
    _G.IsAuthValid = active
    _G.IsGracePeriod = false
    _G.IS_MOD_AUTHORIZED = active
    _G.KEY_VALIDATED = active
    _G.LicenseIsLocked = not active

    return active
end

local function BRLicenseMaintenance()
    local inst = BREnsureOnlineLicense()
    if inst then
        pcall(function() inst:update() end)
    end
    BRLicenseActive()
end

-- Expose the same practical login/status surface used by .
function _G.MasterLicenseLogin(key)
    local inst = BREnsureOnlineLicense()
    if not inst then return false, "license_unavailable" end
    local ok, result = pcall(inst.login, inst, key)
    if not ok then return false, "license_unavailable" end
    return result
end

function _G.MasterLicenseLogout()
    local inst = BREnsureOnlineLicense()
    if not inst then return false end
    local ok, result = pcall(inst.logout, inst)
    BRLicenseActive()
    return ok and result or false
end

function _G.MasterLicenseStatus()
    local inst = BREnsureOnlineLicense()
    if not inst then
        return {
            authorized = false,
            phase = "locked",
            message = "license_unavailable"
        }
    end

    local ok, value = pcall(inst.getStatus, inst)
    if ok and type(value) == "table" then
        value.authorized = BRLicenseActive()
        return value
    end

    return {authorized = false, phase = "locked"}
end

-- Class-facing compatibility helpers.
function BRPlayerCharacterBase:SubmitESPKey(key)
    return _G.MasterLicenseLogin(key)
end

function BRPlayerCharacterBase:LogoutESP()
    return _G.MasterLicenseLogout()
end

function BRPlayerCharacterBase:GetESPStatus()
    return {
        state = BRLicenseActive() and "active" or "locked",
        license = _G.MasterLicenseStatus()
    }
end

-- Create the instance immediately, but do not activate any gameplay feature.
BREnsureOnlineLicense()
BRLicenseActive()


-- Keep the notification helper used by the rest of the source.
local function Notify(msg)
    local s = "[HAMSECHEATS] " .. tostring(msg)
    pcall(function()
        if _G.GTLMODNotify then
            _G.GTLMODNotify(s)
        end
    end)
    pcall(function()
        local sh = import("ScriptHelperClient")
        if sh and sh.AddOnScreenDebugMessage then
            sh.AddOnScreenDebugMessage(
                s, -1, 3.0,
                {R=1, G=1, B=0, A=1},
                {X=1.2, Y=1.2}
            )
        end
    end)
    print(s)
end

-- Legacy compatibility flag retained for existing feature code.
local isExpired = false


BRPlayerCharacterBase.ServerRPC.RPC_Server_ReportSimulateCharacterLocation = { Reliable = true, Params = {} }
BRPlayerCharacterBase.ClientRPC.RPC_Client_ShootVertifyRes = { Reliable = true, Params = {} }
BRPlayerCharacterBase.ClientRPC.RPC_ClientCoronaLab = { Reliable = true, Params = {} }
BRPlayerCharacterBase.ServerRPC.RPC_Server_ReportPlayerKillFlow = { Reliable = true, Params = {} }
BRPlayerCharacterBase.ServerRPC.RPC_Server_ClientSecMrpcsFlow = { Reliable = true, Params = {} }
BRPlayerCharacterBase.ServerRPC.RPC_Server_Heartbeat = { Reliable = true, Params = {} }
BRPlayerCharacterBase.ServerRPC.RPC_Server_SwiftHawk = { Reliable = true, Params = {} }
BRPlayerCharacterBase.ServerRPC.RPC_Server_ClientSwiftHawkWithParams = { Reliable = true, Params = {} }
local ENetRole = import("ENetRole")
local EPawnState = import("EPawnState")
local GameplayData = require("GameLua.GameCore.Data.GameplayData")
local GamePlayTools = require("GameLua.Mod.BaseMod.Common.GamePlayTools")

function BRPlayerCharacterBase:ctor()
end

function BRPlayerCharacterBase:_PostConstruct()
  BRPlayerCharacterBase.__super._PostConstruct(self)
  self:InitAddSpecialMoveInfo()
  self.bCanNearDeathGiveup = true
  print(bWriteLog and "BRPlayerCharacterBase:_PostConstruct bCanNearDeathGiveup true")
end

function BRPlayerCharacterBase:ReceiveBeginPlay()
  BRPlayerCharacterBase.__super.ReceiveBeginPlay(self)
  self:AddControlEvent(self, "MovementModeChangedDelegate", self.HandleOnMovementModeChangedNew, self)
  if self:HasAuthority() and self:CheckAddCheckFallingDistanceComponent() then
    local CheckFallingDistanceComponent_C = import("CheckFallingDistanceComponent")
    if slua.isValid(CheckFallingDistanceComponent_C) and not slua.isValid(self:GetComponentByClass(CheckFallingDistanceComponent_C)) then
      print(bWriteLog and "BRPlayerCharacterBase:ReceiveBeginPlay Add CheckFallingDistanceComponent")
      Game:AddComponent(CheckFallingDistanceComponent_C, self, "CheckFallingDistanceComponent")
    end
  end
  if slua.isValid(self.STCharacterMovement) then
    self.STCharacterMovement.bPositiveBlowUp = true
  end
  if self.Role == ENetRole.ROLE_AutonomousProxy then
    self:AddControlEvent(self, "OnPawnStateDisabled", self.OnPawnStateChange, self)
    self:AddControlEvent(self, "OnPawnStateEnabled", self.OnPawnStateChange, self)
    self:AddControlEventConditionOnly(self, "OnAttrChangeEventDelegate", {
      AttrName = {
        "bCanSelfRescue"
      }
    }, self.CharacterAttrChangeEvent, self)
  end
  if Client then
    printf(bWriteLog and "BRPlayerCharacterBase:ReceiveBeginPlay, PlayerKey:%u ", self.PlayerKey)
    GameplayData.AddCharacter(self.Object)
    self:AddControlEvent(self, "OnAttachedToVehicle", self.HandleOnAttachedToVehicle, self)
    self:AddControlEvent(self, "OnDetachedFromVehicle", self.HandleOnDetachedFromVehicle, self)
  else
    self:AddCommonEventWithConditions(EVENTTYPE_INGAME_NORMAL, EVENTID_GAME_MODE_STATE_CHANGE, {
      [1] = "FinishedState"
    }, self.HandleFinishedState, self)
  end
end

function BRPlayerCharacterBase:HandleOnAttachedToVehicle(uVehicle)
  if not slua.isValid(uVehicle) then
    return
  end
  print(bWriteLog and string.format("BRPlayerCharacterBase:HandleOnAttachedToVehicle", Game:GetObjName(uVehicle)))
  if self.Role == ENetRole.ROLE_SimulatedProxy then
    self:ClearAttachToVehicleTimer()
    self.nUpdatePlayerAttachToVehicleCount = 0
    self.nUpdatePlayerAttachToVehicleTimer = self:AddGameTimer(5, true, 
function()
      if slua.isValid(self.Object) and slua.isValid(uVehicle) then
        self:UpdatePlayerAttachToVehicle(uVehicle)
      end
    end)
    self.nFixMeshContainerTimer = self:AddGameTimer(3, true, 
function()
      if slua.isValid(self.Object) and slua.isValid(uVehicle) then
        self:FixMeshContainerOffsetIfNeeded(uVehicle)
      end
    end)
  end
end

function BRPlayerCharacterBase:HandleOnDetachedFromVehicle(uLastVehicle)
  if not slua.isValid(uLastVehicle) then
    return
  end
  print(bWriteLog and "BRPlayerCharacterBase:HandleOnDetachedFromVehicle", uLastVehicle)
  if self.Role == ENetRole.ROLE_SimulatedProxy then
    self:ClearAttachToVehicleTimer()
    self.nUpdatePlayerAttachToVehicleCount = 0
  end
end

function BRPlayerCharacterBase:UpdatePlayerAttachToVehicle(uVehicle)
  if not slua.isValid(self.Object) or not slua.isValid(uVehicle) then
    return
  end
  if not slua.isValid(self.CapsuleComponent) or not slua.isValid(self.Mesh) or not slua.isValid(self.MeshContainer) then
    return
  end
  if not slua.isValid(self:GetCurrentVehicle()) then
    return
  end
  if Game:IsDriver(self.Object) then
    return
  end
  if not self.nUpdatePlayerAttachToVehicleCount then
    self.nUpdatePlayerAttachToVehicleCount = 0
  end
  local ESTEPoseState = import("ESTEPoseState")
  local bStand = self.PoseState == ESTEPoseState.Stand
  local uActorRelativeLocation = self.CapsuleComponent:GetRelativeTransform():GetLocation()
  local uMeshRelativeLocation = self.Mesh:GetRelativeTransform():GetLocation()
  local uMeshContainerRelativeLocationZ = self.MeshContainer:GetRelativeTransform():GetLocation().Z
  local nCapsuleRadius = self.CapsuleComponent:GetScaledCapsuleRadius()
  local nCapsuleHalfHeight = self.CapsuleComponent:GetScaledCapsuleHalfHeight()
  local uMeshContainerExpectedZ = -1 * self.StandHalfHeight
  local nExpectedCapsuleRadius = self.StandRadius
  local nExpectedCapsuleHalfHeight = self.StandHalfHeight
  local uMeshExpectedRL = FVector(0, 0, 0)
  local uActorExpectedRL = FVector(0, 0, self.StandHalfHeight)
  local nTolerance = 1.0
  local bCapsuleRLCorrect = uActorRelativeLocation:Equals(uActorExpectedRL, nTolerance)
  local bMeshRLCorrect = uMeshRelativeLocation:Equals(uMeshExpectedRL, nTolerance)
  local bMeshContainerRLCorrect = nTolerance > math.abs(uMeshContainerRelativeLocationZ - uMeshContainerExpectedZ)
  local bCapsuleRadiusCorrect = nTolerance > math.abs(nCapsuleRadius - nExpectedCapsuleRadius)
  local bCapsuleHalfHeightCorrect = nTolerance > math.abs(nCapsuleHalfHeight - nExpectedCapsuleHalfHeight)
  local bAllCorrect = bStand and bCapsuleRLCorrect and bMeshRLCorrect and bMeshContainerRLCorrect and bCapsuleRadiusCorrect and bCapsuleHalfHeightCorrect
  if not bAllCorrect then
    self.nUpdatePlayerAttachToVehicleCount = self.nUpdatePlayerAttachToVehicleCount + 1
  else
    self.nUpdatePlayerAttachToVehicleCount = 0
  end
  print(bWriteLog and string.format("BRPlayerCharacterBase:UpdatePlayerAttachToVehicle PlayerKey:%s. bAllCorrect=%s Check Result:%d %d %d %d %d %d, Count:%d", tostring(self.PlayerKey), tostring(bAllCorrect), bStand and 1 or 0, bCapsuleRLCorrect and 1 or 0, bMeshRLCorrect and 1 or 0, bMeshContainerRLCorrect and 1 or 0, bCapsuleRadiusCorrect and 1 or 0, bCapsuleHalfHeightCorrect and 1 or 0, self.nUpdatePlayerAttachToVehicleCount))
  if self.nUpdatePlayerAttachToVehicleCount >= 3 and not bAllCorrect then
    local GameplayData = require("GameLua.GameCore.Data.GameplayData")
    local uPlayerController = GameplayData.GetPlayerController()
    if uPlayerController.ReportCrashKitFeature and uPlayerController.ReportCrashKitFeature.ReportCharacterAttachedOnVehicleException then
      local sReportInfo = string.format("VehicleShapeType:%s PlayerKey:%s. Check Result:%d %d %d %d %d %d. Capsule.RelativeLoc:%s Capsule.Radius:%s Capsule.HalfHeight:%s Mesh.RelativeLoc:%s MeshContainer.RelativeLocZ:%s", tostring(uVehicle.VehicleShapeType), tostring(self.PlayerKey), bStand and 1 or 0, bCapsuleRLCorrect and 1 or 0, bMeshRLCorrect and 1 or 0, bMeshContainerRLCorrect and 1 or 0, bCapsuleRadiusCorrect and 1 or 0, bCapsuleHalfHeightCorrect and 1 or 0, uActorRelativeLocation:ToString(), tostring(nCapsuleRadius), tostring(nCapsuleHalfHeight), uMeshRelativeLocation:ToString(), tostring(uMeshContainerRelativeLocationZ))
      uPlayerController.ReportCrashKitFeature:ReportCharacterAttachedOnVehicleException(sReportInfo)
    end
    self.nUpdatePlayerAttachToVehicleCount = 0
  end
end

function BRPlayerCharacterBase:FixMeshContainerOffsetIfNeeded(uVehicle)
  if not slua.isValid(self.Object) or not slua.isValid(uVehicle) then
    return
  end
  if not slua.isValid(self.MeshContainer) then
    return
  end
  if not slua.isValid(self:GetCurrentVehicle()) then
    return
  end
  if Game:IsDriver(self.Object) then
    return
  end
  local nTolerance = 1.0
  local uMeshContainerExpectedZ = -1 * self.StandHalfHeight
  local uMeshContainerRelativeLocationZ = self.MeshContainer:GetRelativeTransform():GetLocation().Z
  if nTolerance <= math.abs(uMeshContainerRelativeLocationZ - uMeshContainerExpectedZ) then
    print(bWriteLog and string.format("BRPlayerCharacterBase:FixMeshContainerOffsetIfNeeded PlayerKey:%s. SetMeshContainerOffsetZ from:%s to:%s", tostring(uMeshContainerExpectedZ), tostring(uMeshContainerExpectedZ)))
    self:SetMeshContainerOffsetZ(uMeshContainerExpectedZ)
  end
end

function BRPlayerCharacterBase:ClearAttachToVehicleTimer()
  if self.nUpdatePlayerAttachToVehicleTimer then
    self:RemoveGameTimer(self.nUpdatePlayerAttachToVehicleTimer)
    self.nUpdatePlayerAttachToVehicleTimer = nil
  end
  if self.nFixMeshContainerTimer then
    self:RemoveGameTimer(self.nFixMeshContainerTimer)
    self.nFixMeshContainerTimer = nil
  end
end

function BRPlayerCharacterBase:CharacterAttrChangeEvent(uPawn, AttrName, AttrVal)
  BRPlayerCharacterBase.__super.CharacterAttrChangeEvent(self, uPawn, AttrName, AttrVal)
  if self.Object ~= uPawn then
    return
  end
  if self.Role == ENetRole.ROLE_AutonomousProxy and AttrName == "bCanSelfRescue" then
    local uPlayerController = self:GetPlayerControllerSafety()
    if slua.isValid(uPlayerController) then
      uPlayerController:BroadcastUIMessage("UIMsg_CanSelfRescue", 0, "", "")
    end
  end
end

function BRPlayerCharacterBase:OnPawnStateChange(PawnState)
  print("BRPlayerCharacterBase:OnPawnStateChange:", PawnState)
  local EPawnState = import("EPawnState")
  if PawnState == EPawnState.SwitchPP then
    local uPlayerController = self:GetPlayerControllerSafety()
    if slua.isValid(uPlayerController) then
      uPlayerController:BroadcastUIMessage("UIMsg_FPPModeChange", 0, "", "")
    end
  end
end

function BRPlayerCharacterBase:HandleFinishedState()
  print(bWriteLog and "BRPlayerCharacterBase:HandleFinishedState", self.STCharacterMovement)
  if slua.isValid(self.STCharacterMovement) and self.STCharacterMovement.SetDynamicSimpleQueryConfig then
    self.STCharacterMovement:SetDynamicSimpleQueryConfig(false)
  end
end

function BRPlayerCharacterBase:CheckAddCheckFallingDistanceComponent()
  if CGameMode and CGameMode.GameModeType and CGameState and CGameState.GameModeID then
    local EGameModeType = import("EGameModeType")
    local MatchModeIds = require("GameLua.Mod.BaseMod.GamePlay.Config.MatchModeIdsConfig")
    local GameModeType = CGameMode.GameModeType
    local GameModeID = tonumber(CGameState.GameModeID)
    local bModeTypeSatisfy = GameModeType == EGameModeType.ETypicalGameMode or GameModeType == EGameModeType.EFourInOneGameMode or GameModeType == EGameModeType.EHeavyWeaponGameMode
    local bModeIDSatisfy = not MatchModeIds[GameModeID]
    print(bWriteLog and "BRPlayerCharacterBase:CheckAddCheckFallingDistanceComponent:", GameModeType, GameModeID, bModeTypeSatisfy, bModeIDSatisfy)
    return bModeTypeSatisfy and bModeIDSatisfy
  end
  return false
end

function BRPlayerCharacterBase:LuaHandleParachuteStateChanged(LastParachuteState, NewParachuteState)
  BRPlayerCharacterBase.__super.LuaHandleParachuteStateChanged(self, LastParachuteState, NewParachuteState)
  local EParachuteState = import("EParachuteState")
  if not Client then
    local uCurrentPlayerControl = self:GetPlayerControllerSafety()
    if slua.isValid(uCurrentPlayerControl) and uCurrentPlayerControl.CheckParachuteOpenFeature then
      if NewParachuteState == EParachuteState.PS_Opening then
        if uCurrentPlayerControl.CheckParachuteOpenFeature.SatrtCheckShowParachuteCloseUI then
          uCurrentPlayerControl.CheckParachuteOpenFeature:SatrtCheckShowParachuteCloseUI()
        end
      elseif NewParachuteState == EParachuteState.PS_None then
        if uCurrentPlayerControl.CheckParachuteOpenFeature.RecoverParachuteOpenParam then
          uCurrentPlayerControl.CheckParachuteOpenFeature:RecoverParachuteOpenParam()
        end
        if uCurrentPlayerControl.CheckParachuteOpenFeature.ClearTimerAndState then
          uCurrentPlayerControl.CheckParachuteOpenFeature:ClearTimerAndState()
        end
      end
    end
  end
end

function BRPlayerCharacterBase:OnLanded()
  printf("BRPlayerCharacterBase:OnLanded PlayerKey:%d", self.PlayerKey)
  if self.HandleOnLanded then
    self:HandleOnLanded(-1)
  end
  if not Client then
    local uCurrentPlayerControl = self:GetPlayerControllerSafety()
    if slua.isValid(uCurrentPlayerControl) and uCurrentPlayerControl.CheckParachuteOpenFeature then
      if uCurrentPlayerControl.CheckParachuteOpenFeature.ClearTimerAndState then
        uCurrentPlayerControl.CheckParachuteOpenFeature:ClearTimerAndState()
      end
      if uCurrentPlayerControl.CheckParachuteOpenFeature.ResetCheckShowUI then
        uCurrentPlayerControl.CheckParachuteOpenFeature:ResetCheckShowUI()
      end
    end
  end
end

function BRPlayerCharacterBase:ReceiveEndPlay(EndPlayReason)
  BRPlayerCharacterBase.__super.ReceiveEndPlay(self, EndPlayReason)
  if Client then
    GameplayData.RemoveCharacter(self.Object)
  end
end

function BRPlayerCharacterBase:IsWarGameMode()
  local GameplayData = require("GameLua.GameCore.Data.GameplayData")
  local uGameState = GameplayData:GetGameState()
  local STExtraGameStateBase = import("STExtraGameStateBase")
  if slua.isValid(uGameState) and Game:IsClassOf(uGameState, STExtraGameStateBase) then
    local EGameModeType = import("EGameModeType")
    return uGameState.GameModeType == EGameModeType.EWarGameMode
  else
    return false
  end
end

function BRPlayerCharacterBase:BPOnRecycled()
  print(bWriteLog and string.format("%s BPOnRecycled()", Game:GetPlainName(self.Object)))
  if Client then
    self:ResetMeshRelativeLocationAndRotation()
  end
end

function BRPlayerCharacterBase:BPOnRespawned()
  print(bWriteLog and string.format("%s BPOnRespawned()", Game:GetPlainName(self.Object)))
  if Client then
    self:ResetMeshRelativeLocationAndRotation()
  end
end

function BRPlayerCharacterBase:ReceiveOnRecycle()
  print(bWriteLog and string.format("%s IReusable:ReceiveOnRecycle()", Game:GetPlainName(self.Object)))
  if Client then
    self:ResetMeshRelativeLocationAndRotation()
    GameplayData.RemoveCharacter(self.Object)
  end
end

function BRPlayerCharacterBase:ReceiveOnSpawn()
  print(bWriteLog and string.format("%s IReusable:ReceiveOnSpawn()", Game:GetPlainName(self.Object)))
  -- FIX: _PostConstruct is not called again after object-pool recycle,
  -- so bCanNearDeathGiveup stays stale. Reset it here every spawn.
  self.bCanNearDeathGiveup = true
  if Client then
    self:ResetMeshRelativeLocationAndRotation()
    GameplayData.AddCharacter(self.Object)
  end
end

function BRPlayerCharacterBase:ResetMeshRelativeLocationAndRotation()
  if Game:IsValid(self.Object) and Game:IsValid(self.Mesh) then
    local uDefaultMeshRot = FRotator(0, -90, 0)
    local uDefaultMeshRelativeLoc = FVector(0, 0, 0)
    if self.Mesh.K2_SetRelativeRotation then
      self.Mesh:K2_SetRelativeRotation(uDefaultMeshRot, false, nil, false)
    end
    self:CacheInitialMeshOffset(uDefaultMeshRelativeLoc, uDefaultMeshRot)
    local vRelativeRot = self.Mesh.RelativeRotation
    local vBaseRotationOffset = self.BaseRotationOffset
    local vBaseRotation = Game:QuatToRotator(vBaseRotationOffset)
    print(bWriteLog and string.format("%s ResetMeshRelativeLocationAndRotation() Mesh.RelativeRotation: %s %s %s   Pawn.BaseRotationOffset:%s %s %s ", Game:GetPlainName(self.Object), tostring(vRelativeRot.Pitch), tostring(vRelativeRot.Yaw), tostring(vRelativeRot.Roll), tostring(vBaseRotation.Pitch), tostring(vBaseRotation.Yaw), tostring(vBaseRotation.Roll)))
  end
end

function BRPlayerCharacterBase:HandleOnMovementModeChangedNew()
  print(bWriteLog and "BRPlayerCharacterBase:HandleOnMovementModeChanged11")
  local EMovementMode = import("EMovementMode")
  if Game:IsValid(self.STCharacterMovement) and self.STCharacterMovement.MovementMode == EMovementMode.MOVE_Swimming and self:CheckBaseIsMoveable() then
    print(bWriteLog and "BRPlayerCharacterBase:HandleOnMovementModeChanged22")
    self.CharacterMovement:SetBase(nil, "", true)
  end
  if self.Role == ENetRole.ROLE_AutonomousProxy and Game:IsValid(self.STCharacterMovement) and self.STCharacterMovement.MovementMode == EMovementMode.MOVE_Walking and UIManager.UI_Config_InGame.ParachuteOpenUI then
    print(bWriteLog and "BRPlayerCharacterBase:HandleOnMovementModeChangedNew CloseUI")
    UIManager.CloseUI(UIManager.UI_Config_InGame.ParachuteOpenUI)
  end
end

function BRPlayerCharacterBase:BPOnMissPlayerDamageRecord()
end

function BRPlayerCharacterBase:PreAttachedToVehicle()
  local UKismetSystemLibrary = import("KismetSystemLibrary")
  local IsDS = UKismetSystemLibrary.IsDedicatedServer(self)
  if not IsDS then
    return
  end
  local MainPlayerController = self:GetPlayerControllerSafety()
  if not slua.isValid(MainPlayerController) then
    return
  end
  local CharacterAvatarComp2_BP = self.CharacterAvatarComp2_BP
  if not slua.isValid(CharacterAvatarComp2_BP) then
    return
  end
  local CommerAvatarDataUtil = require("GameLua.Activity.Commercialize.GamePlay.CommerAvatarDataUtil")
  local changedVehicleId = CommerAvatarDataUtil:ChangeVehicleSkinByClothes(MainPlayerController, CharacterAvatarComp2_BP)
  local ESTExtraVehicleShapeType = import("ESTExtraVehicleShapeType")
  if changedVehicleId then
    local UAvatarUtils = import("AvatarUtils")
    if UAvatarUtils.GetVehicleShapeBySkinID(changedVehicleId) == ESTExtraVehicleShapeType.VST_Horse then
      local uCurPlayerState = self:GetPlayerStateSafety()
      if slua.isValid(uCurPlayerState) then
        print(bWriteLog and "BRPlayerCharacterBase:PreAttachedToVehicle. changedVehicleId: " .. tostring(changedVehicleId))
        uCurPlayerState:AddGeneralCount(468, 1, false)
      end
    end
  end
end
BRPlayerCharacterBase.ClientRPC.ClientRPC_TriggerHighlightMoment = {
  Reliable = true,
  Params = {
    UEnums.EPropertyClass.UInt32,
    UEnums.EPropertyClass.UInt32  }
}

function BRPlayerCharacterBase:ClientRPC_TriggerHighlightMoment(Type, Param)
  print(bWriteLog and string.format("BRPlayerCharacterBase:ClientRPC_TriggerHighlightMoment Type = %d, Param = %s", Type, Param))
  EventSystem:postEvent(EVENTTYPE_INGAME, EVENTID_INGAME_TRIGGER_HIGHLIGHT_MOMENT, Type, Param)
end

function BRPlayerCharacterBase:ParachuteJump()
  local uPlayerController = self:GetControllerSafety()
  if slua.isValid(uPlayerController) then
    if not self:GetEnsure() then
      local EStateType = import("EStateType")
      if uPlayerController:GetCurrentStateType() ~= EStateType.State_ParachuteJump and uPlayerController:GetCurrentStateType() ~= EStateType.State_ParachuteOpen then
        local ESTEPoseState = import("ESTEPoseState")
        self:SwitchPoseState(ESTEPoseState.Stand, true, true, true, false)
        uPlayerController:ReInitParachuteItem()
        uPlayerController:ServerChangeStatePC(EStateType.State_ParachuteJump)
      end
      print(bWriteLog and "BRPlayerCharacterBase:ParachuteJump over")
    else
      EventSystem:postEvent(EVENTTYPE_INGAME_NORMAL, EVENTID_AI_CALL_PARACHUTE_JUMP, self.Object)
      print(bWriteLog and "BRPlayerCharacterBase:ParachuteJump AI JUMP over, Loc=", tostring(self:K2_GetActorLocation():ToString()))
    end
  end
end

function BRPlayerCharacterBase:OnMovementBaseChangedEvent(uCharacter, uNewMovementBase, uOldMovementBase)
  if uCharacter ~= self.Object then
    return
  end
  print(bWriteLog and string.format("BRPlayerCharacterBase:OnMovementBaseChangedEvent %s, Base: %s -> %s", uCharacter, uOldMovementBase, uNewMovementBase))
  local MedievalCrane = self:GetMedievalCraneFromBase(uNewMovementBase)
  if MedievalCrane and MedievalCrane.AddCharacter then
    MedievalCrane:AddCharacter(self.Object)
  else
    MedievalCrane = self:GetMedievalCraneFromBase(uOldMovementBase)
    if MedievalCrane and MedievalCrane.RemoveCharacter then
      MedievalCrane:RemoveCharacter(self.Object)
    end
  end
end

function BRPlayerCharacterBase:GetMedievalCraneFromBase(Base)
  if not slua.isValid(Base) or not Base.GetOwner then
    return
  end
  local Lifter = Base:GetOwner()
  if not slua.isValid(Lifter) then
    return
  end
  if not Lifter.AddCharacter then
    return
  end
  return Lifter
end

function BRPlayerCharacterBase:CheckForbidFlaregun()
  local uPlayerState = self:GetPlayerStateSafety()
  if not slua.isValid(uPlayerState) then
    return false
  end
  if uPlayerState.CanUseFlaregun == false and self:IsLocallyControlled() then
    local uPlayerController = self:GetPlayerControllerSafety()
    if slua.isValid(uPlayerController) then
      uPlayerController:DisplayGameTipWithMsgID(48532)
    end
  end
  return not uPlayerState.CanUseFlaregun
end

function BRPlayerCharacterBase:ServerRPC_NearDeathGiveupRescue()
  if self.Super and self.Super.ServerRPC_NearDeathGiveupRescue then
    return self.Super:ServerRPC_NearDeathGiveupRescue()
  end
  if self.Super and self.Super.HandleNearDeathGiveupRescue then
    return self.Super:HandleNearDeathGiveupRescue()
  end
end

function BRPlayerCharacterBase:HandleNearDeathGiveupRescue()
  if self.Super and self.Super.HandleNearDeathGiveupRescue then
    return self.Super:HandleNearDeathGiveupRescue()
  end
end

function BRPlayerCharacterBase:RPC_Server_GmPlayAction(actionId)
  log(bWriteLog and "BRPlayerCharacterBase:RPC_Server_GmPlayAction. actionId: " .. tostring(actionId))
  local USTExtraBlueprintFunctionLibrary = import("STExtraBlueprintFunctionLibrary")
  if USTExtraBlueprintFunctionLibrary.IsDevelopment() then
    log(bWriteLog and "BRPlayerCharacterBase:RPC_Server_GmPlayAction. IsDevelopment actionId: " .. tostring(actionId))
    self:MulticastRPC_GmPlayAction(actionId)
  end
end

function BRPlayerCharacterBase:MulticastRPC_GmPlayAction(actionId)
  if not Client then
    return
  end
  log(bWriteLog and "BRPlayerCharacterBase:MulticastRPC_GmPlayAction. actionId: " .. tostring(actionId))
  local uPlayEmoteComp = self:GetPlayEmoteComponent()
  if not slua.isValid(uPlayEmoteComp) then
    return
  end
  local LogFilter = require("common.log_filter")
  LogFilter.SetLogTreeEnable(true)
  local animCfg = CDataTable.GetTableData("EmoteBPTable", actionId)
  if not animCfg then
    return
  end
  local handlePath = animCfg.Path
  local EmoteHandleAsset = slua.loadObject(handlePath)
  local assetsArray = slua.Array(UEnums.EPropertyClass.Struct, import("/Script/CoreUObject.SoftObjectPath"))
  local handle = EmoteHandleAsset()
  uPlayEmoteComp:OnLoadEmoteAssetBegin(handle, actionId, assetsArray, "")
  log(bWriteLog and "BRPlayerCharacterBase:MulticastRPC_GmPlayAction. assetsArray:Num(): " .. tostring(assetsArray:Num()))
  local tb = FuncUtil.LuaArrayToTable(assetsArray)
  local asset_util = require("common.asset_util")
  local loadLater = function()
    uPlayEmoteComp:OnLoadEmoteAssetEnd(handle, actionId, 0)
  end
  asset_util.GetAssetsArrayAsyncParallel(tb, loadLater)
end

function BRPlayerCharacterBase:RPC_Client_SetShouldCheckPassWall(bServerSyncShouldCheckPassWall)
  print(bWriteLog and "BRPlayerCharacterBase:RPC_Client_SetShouldCheckPassWall " .. tostring(bServerSyncShouldCheckPassWall))
  if slua.isValid(self.ParachuteComponent) then
    self.ParachuteComponent.bServerSyncShouldCheckPassWall = bServerSyncShouldCheckPassWall
  end
end

function BRPlayerCharacterBase:OnPlayerEnterCarryBoxState()
  self.Super:OnPlayerEnterCarryBoxState()
  local CharName = self:GetPlayerNameSafety()
  print(bWriteLog and string.format("DeadBoxLog BRPlayerCharacterBase:OnPlayerEnterCarryBoxState Role:%s PlayerKey:%s Name:%s", tostring(self.Role), tostring(self.PlayerKey), tostring(CharName)))
  if self.CarryDeadBoxFeature then
    self.CarryDeadBoxFeature:OnPlayerEnterCarryBoxState()
  end
end

function BRPlayerCharacterBase:OnPlayerLeaveCarryBoxState(bInIsInterrupt)
  self.Super:OnPlayerLeaveCarryBoxState(bInIsInterrupt)
  local CharName = self:GetPlayerNameSafety()
  print(bWriteLog and string.format("DeadBoxLog BRPlayerCharacterBase:OnPlayerLeaveCarryBoxState Role:%s PlayerKey:%s Name:%s bInIsInterrupt:%s", tostring(self.Role), tostring(self.PlayerKey), tostring(CharName), tostring(bInIsInterrupt)))
  if self.CarryDeadBoxFeature then
    self.CarryDeadBoxFeature:OnPlayerLeaveCarryBoxState(bInIsInterrupt)
  end
end

function BRPlayerCharacterBase:ServerRPC_CarryDeadBox(uInDeadBox)
  if slua.isValid(uInDeadBox) and Game:IsClassOf(uInDeadBox, import("/Script/ShadowTrackerExtra.PlayerTombBox")) and self.CarryDeadBoxFeature then
    self.CarryDeadBoxFeature:CarryDeadBox(uInDeadBox)
  end
end

function BRPlayerCharacterBase:SetAreaID(AreaID)
  self:SetAttrValue("AreaID", AreaID, -1)
end

function BRPlayerCharacterBase:GetAreaID()
  return math.floor(self:GetAttrValue("AreaID") + 0.5)
end

function BRPlayerCharacterBase:CannotChangeIntoPetSpectator()
  print(bWriteLog and "BRPlayerCharacterBase:CannotChangeIntoPetSpectator")
  return self.bCannotChangeIntoPetSpectator
end

function BRPlayerCharacterBase:DoModChangeToBT()
  print(bWriteLog and string.format("BRPlayerCharacterBase:DoModChangeToBT, PlayerKey=%s", tostring(self.PlayerKey)))
  if self:HasState(EPawnState.SpecialSuit) then
    self:TriggerEntrySkillWithID(4301101, true)
    print(bWriteLog and string.format("BRPlayerCharacterBase:DoModChangeToBT, PlayerKey=%s, HasState(EPawnState.SpecialSuit)", tostring(self.PlayerKey)))
  end
end

function BRPlayerCharacterBase:SwitchCameraToParachuteOpening()
  print(bWriteLog and "BRPlayerCharacterBase:SwitchCameraToParachuteOpening")
  self.Super:SwitchCameraToParachuteOpening()
  if self.ParachuteFormation and self.ParachuteFormation.ShouldApplyFormationCamera and self.ParachuteFormation:ShouldApplyFormationCamera() then
    self.ParachuteFormation:OverlayFormationCameraParams()
    print(bWriteLog and "BRPlayerCharacterBase:SwitchCameraToParachuteOpening - Formation camera overlaid")
  end
end

function BRPlayerCharacterBase:SwitchCameraToParachuteFalling()
  print(bWriteLog and "BRPlayerCharacterBase:SwitchCameraToParachuteFalling")
  self.Super:SwitchCameraToParachuteFalling()
  if self.ParachuteFormation and self.ParachuteFormation.ShouldApplyFormationCamera and self.ParachuteFormation:ShouldApplyFormationCamera() then
    self.ParachuteFormation:OverlayFormationCameraParams()
    print(bWriteLog and "BRPlayerCharacterBase:SwitchCameraToParachuteFalling - Formation camera overlaid")
  end
end

function BRPlayerCharacterBase:SwitchCameraToNormal()
  print(bWriteLog and "BRPlayerCharacterBase:SwitchCameraToNormal")
  self.Super:SwitchCameraToNormal()
  if self.ParachuteFormation and self.ParachuteFormation.OnLandingClearFormationCamera then
    self.ParachuteFormation:OnLandingClearFormationCamera()
  end
end

function BRPlayerCharacterBase:SwitchWeaponCheck(Slot, IgnoreState)
  if self:HasState(EPawnState.AttachToOther) then
    local Weapon = self:GetWeaponBySlot(Slot)
    if slua.isValid(Weapon) then
      local WeaponID = Weapon:GetWeaponID()
      local AttachToOtherConfig = GamePlayTools.GetCurrentConfig("AttachToOtherConfig")
      if AttachToOtherConfig and AttachToOtherConfig.CheckIsWeaponInBlackList and AttachToOtherConfig.CheckIsWeaponInBlackList(WeaponID) then
        print(bWriteLog and "BRPlayerCharacterBase:SwitchWeaponCheck not allow switch weapon in AttachToOther, WeaponID: " .. tostring(WeaponID))
        local uPlayerController = self:GetPlayerControllerSafety()
        if Client and slua.isValid(uPlayerController) and uPlayerController.Role == ENetRole.ROLE_AutonomousProxy then
          uPlayerController:DisplayGameTipWithMsgID(47306)
        end
        return false
      end
    end
  end
  return self.Super:SwitchWeaponCheck(Slot, IgnoreState)
end

-- ==========================================
-- ⚠️ MOD LOGIC - ONLY RUNS IF AUTHORIZED ⚠️
-- ==========================================

local function IsModAuthorized()
    return true
end

local function NotifyMod(msg) 
    if not IsModAuthorized() then return end
    local s = "[HAMSECHEATS VIP] " .. tostring(msg)
    pcall(function() if _G.GTLMODNotify then _G.GTLMODNotify(s) end end)
    pcall(function() 
        local sh = import("ScriptHelperClient") 
        if sh and sh.AddOnScreenDebugMessage then
            sh.AddOnScreenDebugMessage(s, -1, 3.0, {R=1, G=1, B=0, A=1}, {X=1.2, Y=1.2}) 
        end 
    end) 
    print(s) 
end

local _slua = rawget(_G, "slua")

local function Valid(obj) 
    if not obj then return false end 
    if _slua and _slua.isValid then 
        local ok, v = pcall(_slua.isValid, obj) 
        if not ok or not v then return false end 
    end 
    return true 
end

-- ========================================== 
-- STATIC VARIABLES & GLOBAL CACHE
-- ========================================== 
local C_GREEN = {R=0, G=255, B=0, A=255}
local C_RED = {R=255, G=0, B=0, A=255}
local C_CYAN = {R=0, G=255, B=255, A=255}
local C_YELLOW = {R=255, G=255, B=0, A=255}
local C_WHITE = {R=255, G=255, B=255, A=255}
local C_BLUE_TEXT = {R=0, G=200, B=255, A=255}
local SCALE_COLOR_V2 = {R=3, G=3, B=0, A=0}

local GLOBAL_BONE_LIST = {
    "head", "neck_01", "pelvis",
    "upperarm_r", "lowerarm_r", "hand_r",
    "upperarm_l", "lowerarm_l", "hand_l",
    "thigh_l", "calf_l", "foot_l",
    "thigh_r", "calf_r", "foot_r"
}

local GLOBAL_CONNECTIONS = {
    {"neck_01", "pelvis", C_YELLOW},
    {"neck_01", "upperarm_l", C_CYAN}, {"upperarm_l", "lowerarm_l", C_CYAN}, {"lowerarm_l", "hand_l", C_CYAN},
    {"neck_01", "upperarm_r", C_CYAN}, {"upperarm_r", "lowerarm_r", C_CYAN}, {"lowerarm_r", "hand_r", C_CYAN},
    {"pelvis", "thigh_l", C_CYAN}, {"thigh_l", "calf_l", C_CYAN}, {"calf_l", "foot_l", C_CYAN},
    {"pelvis", "thigh_r", C_CYAN}, {"thigh_r", "calf_r", C_CYAN}, {"calf_r", "foot_r", C_CYAN}
}

-- ========================================== 
-- GTLMOD CORE + FULL FEATURES VIP CONFIGURATION 
-- ========================================== 
_G.GTLMODConfig = _G.GTLMODConfig or { 
    AutoHead = false, 
    EspVip = false, 
    EspDistance = true, 
    EspVipPro = false, 
    EspRadar = false, 
    Esp5 = false, 
    Esp6 = false, 
    Esp7 = true,
    Esp8 = false,
    EspAntenna = false, 
    EspName = false,
    EspOutline = false, 
    OutlineThickness = 10, 
    UnlockFPS = false, 
    IpadView = false, 
    CustomAimbot = false, 
    CustomAimbotClose = false, 
    CustomHRecoil = false,  
    CustomVRecoil = false,  
    LessShake = false, 
    RemoveGrass = false, 
    RemoveFog = false, 
    WhiteBody = false, 
    ColorBodyV2 = false,    
    wallhackng = false, 
    Accuracy = false,
    BlackSky = false,
    
    AimTouchEnable = false,
    AimTouchHipIgKnock = true,
    AimTouchHipIgBot = true,
    AimTouchSGIgKnock = true,
    AimTouchSGIgBot = true,
    AimTouchHipVisCheck = true,
    AimTouchSGVisCheck = true,
    AimTouchHipfire = false,
    AimTouchSG = false,
    AimTouchSGAutoFire = false,
    AimTouchScopeAll = false,
    AimTouchScopeIgKnock = true,
    AimTouchScopeIgBot = true,
    AimTouchScopeVisCheck = true,
    AimTouchScopeSniper = false,
    AimTouchSniperIgKnock = true,
    AimTouchSniperIgBot = true,
    AimTouchSniperVisCheck = true,

    ModSkin = false,
}

_G.GTLMODState = _G.GTLMODState or { 
    LoopToken = 0, 
    AimbotLoopToken = 0,
    NativeESPReady = false,
    GraphicsUnlocked = false, 
    MenuStep = 0, 
    LastCmdTime = 0,
    TrackedMarks = {},
    EnemyMarks = {},
    LastAimbotCheckTime = 0, 
    CustomTextData = nil,     
    LastAimbotConfigString = "",
    PrevGraphicsState = {},
    SkinWasApplied = false,
}

-- Removed duplicate placeholder MainLoop/FastTick timer.
-- The actual runtime loop is initialized once in the main loop section below.

local function SafeAddMark(id, pos, z, str, size, actor)
    local mark = nil
    pcall(function()
        local InGameMarkTools = require("GameLua.Mod.BaseMod.Common.InGameMarkTools")
        if InGameMarkTools and InGameMarkTools.ClientAddMapMark then
            mark = InGameMarkTools.ClientAddMapMark(id, pos, z, str, size, actor)
            if mark then _G.GTLMODState.TrackedMarks[mark] = true end
        end
    end)
    return mark
end

local function SafeRemoveMark(mark)
    if not mark then return end
    pcall(function()
        local InGameMarkTools = require("GameLua.Mod.BaseMod.Common.InGameMarkTools")
        if InGameMarkTools and InGameMarkTools.HideMapMark then
            InGameMarkTools.HideMapMark(mark)
        end
        if InGameMarkTools and InGameMarkTools.RemoveMapMark then
            InGameMarkTools.RemoveMapMark(mark)
        end
    end)
    _G.GTLMODState.TrackedMarks[mark] = nil
end

local function GetSafeEnemyKey(enemy)
    if Valid(enemy) then
        if enemy.PlayerKey then return tostring(enemy.PlayerKey) end
        if type(enemy.GetUniqueID) == "function" then return tostring(enemy:GetUniqueID()) end
    end
    return tostring(enemy)
end

local function CheckIsAI(pawn, markData)
    if markData.AK_IS_BOT ~= nil then return markData.AK_IS_BOT, true end
    
    local isAI = false
    local hasChecked = false
    pcall(function()
        if pawn.bIsAI == true or pawn.IsAI == true then isAI = true; hasChecked = true end
        if type(pawn.IsBot) == "function" and pawn:IsBot() then isAI = true; hasChecked = true end
        
        local pState = pawn.PlayerState or (type(pawn.GetPlayerState) == "function" and pawn:GetPlayerState())
        if Valid(pState) then
            hasChecked = true
            if pState.bIsABot == true or pState.bIsBot == true then isAI = true end
            if type(pState.IsBot) == "function" and pState:IsBot() then isAI = true end
        end
        
        if not isAI then
            local name = pawn.PlayerName or (type(pawn.GetPlayerName) == "function" and pawn:GetPlayerName()) or ""
            if name ~= "" and (name:find("Cobra") or name:find("Target") or name:find("bot_") or name:find("b_")) then
                isAI = true
                hasChecked = true
            end
        end
    end)
    if hasChecked then markData.AK_IS_BOT = isAI end
    return isAI, hasChecked
end

function _G.InitializeAutoHeadHooks()
    pcall(function()
        local EAvatarDamagePosition = import("EAvatarDamagePosition")
        if not EAvatarDamagePosition then return end

        local modulesToHook = {
            "GameLua.Mod.BaseMod.Common.Weapon.ShootWeaponEntity",
            "GameLua.Logic.Weapon.ShootWeaponEntity"
        }
        
        for _, path in ipairs(modulesToHook) do
            local hitLogic = package.loaded[path]
            if hitLogic then
                local original_GetHitBodyType = hitLogic.GetHitBodyType
                hitLogic.GetHitBodyType = function(self, ImpactResult, InImpactVec)
                    if _G.GTLMODConfig.AutoHead then return EAvatarDamagePosition.BigHead end
                    if original_GetHitBodyType then return original_GetHitBodyType(self, ImpactResult, InImpactVec) end
                end

                local original_GetHitBodyTypeByHitPos = hitLogic.GetHitBodyTypeByHitPos
                hitLogic.GetHitBodyTypeByHitPos = function(self, InImpactVec)
                    if _G.GTLMODConfig.AutoHead then return EAvatarDamagePosition.BigHead end
                    if original_GetHitBodyTypeByHitPos then return original_GetHitBodyTypeByHitPos(self, InImpactVec) end
                end
            end
        end
    end)
end

local function GetConfigPaths(fileName)
    local paths = {
        currentGamePaths.saved .. fileName,
        currentGamePaths.base .. fileName,
        currentGamePaths.sdcard .. fileName,
        "//storage/emulated/0/Android/data/com.tencent.ig/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/Paks/" .. fileName,
        "//storage/emulated/0/Android/data/com.vng.pubgmobile/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/Paks/" .. fileName,
        "//storage/emulated/0/Android/data/com.pubg.krmobile/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/Paks/" .. fileName,
        "//storage/emulated/0/Android/data/com.rekoo.pubgm/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/Paks/" .. fileName,
        "//storage/emulated/0/Android/data/com.pubg.imobile/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/Paks/" .. fileName,
        "//storage/emulated/0/Android/data/com.garena.game.kgtw/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/Paks/" .. fileName,
        "//storage/emulated/0/Android/data/com.pubg.jpmobile/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/Paks/" .. fileName,
        "/Documents/ShadowTrackerExtra/Saved/Paks/" .. fileName,
        "/Documents/ShadowTrackerExtra/Saved/Paks/puffer_temp/" .. fileName,
        "/com.tencent.ig/Documents/ShadowTrackerExtra/Saved/Paks/" .. fileName,
        "/com.vng.pubgmobile/Documents/ShadowTrackerExtra/Saved/Paks/" .. fileName,
        "/com.pubg.krmobile/Documents/ShadowTrackerExtra/Saved/Paks/" .. fileName,
        "/com.rekoo.pubgm/Documents/ShadowTrackerExtra/Saved/Paks/" .. fileName,
        "/com.pubg.imobile/Documents/ShadowTrackerExtra/Saved/Paks/" .. fileName,
        "/com.garena.game.kgtw/Documents/ShadowTrackerExtra/Saved/Paks/" .. fileName,
        "/com.pubg.jpmobile/Documents/ShadowTrackerExtra/Saved/Paks/" .. fileName,
        "ShadowTrackerExtra/Saved/Paks/" .. fileName,
        "../../ShadowTrackerExtra/Saved/Paks/" .. fileName,
        "../../../ShadowTrackerExtra/Saved/Paks/" .. fileName,
        "../../../../ShadowTrackerExtra/Saved/Paks/" .. fileName,
        fileName
    }
    pcall(function()
        if os and os.getenv then
            local homeDir = os.getenv("HOME")
            if homeDir and homeDir ~= "" then
                table.insert(paths, 1, homeDir .. "/Documents/ShadowTrackerExtra/Saved/Paks/" .. fileName)
                table.insert(paths, 2, homeDir .. "/Documents/ShadowTrackerExtra/Saved/Paks/puffer_temp/" .. fileName)
            end
        end
    end)
    return paths
end

local ConfigFileName = "HAMSECHEATS_setting.txt"
_G.LastConfigSaveStr = ""

local function SerializeConfigValue(value)
    local valueType = type(value)
    if valueType == "boolean" or valueType == "number" then
        if valueType == "number" and (value ~= value or value == math.huge or value == -math.huge) then
            return nil
        end
        return tostring(value)
    end
    if valueType == "string" then return string.format("%q", value) end
    return nil
end

_G.SaveModSettings = function()
    local ok, saved = pcall(function()
        local lines = {"return {", "GTLMODConfig = {"}
        for k, v in pairs(_G.GTLMODConfig or {}) do
            local key = string.format("%q", tostring(k))
            local value = SerializeConfigValue(v)
            if value then lines[#lines + 1] = "  [" .. key .. "] = " .. value .. "," end
        end
        lines[#lines + 1] = "},"
        lines[#lines + 1] = "CustomTextData = {"
        local custom = (_G.GTLMODState and _G.GTLMODState.CustomTextData) or {}
        for k, v in pairs(custom) do
            local key = string.format("%q", tostring(k))
            local value = SerializeConfigValue(v)
            if value then lines[#lines + 1] = "  [" .. key .. "] = " .. value .. "," end
        end
        lines[#lines + 1] = "}", "}"
        local data = table.concat(lines, "\n")
        if data == _G.LastConfigSaveStr then return true end
        local paths = GetConfigPaths(ConfigFileName)
        for _, path in ipairs(paths) do
            local file = io.open(path, "w")
            if file then
                local writeOK = file:write(data)
                local closeOK = file:close()
                if writeOK and closeOK ~= nil then
                    _G.LastConfigSaveStr = data
                    return true
                end
            end
        end
        return false
    end)
    return ok and saved == true
end

_G.LoadModSettings = function()
    local ok, loaded = pcall(function()
        local content
        for _, path in ipairs(GetConfigPaths(ConfigFileName)) do
            local file = io.open(path, "r")
            if file then
                content = file:read("*a")
                file:close()
                if type(content) == "string" and #content > 0 then break end
                content = nil
            end
        end
        if not content then return false end

        -- The settings file is data only: execute its table constructor in an empty environment.
        local chunk, loadError
        if type(loadstring) == "function" then
            chunk, loadError = loadstring(content, "@" .. ConfigFileName)
            if chunk and type(setfenv) == "function" then setfenv(chunk, {}) end
        else
            chunk, loadError = load(content, "@" .. ConfigFileName, "t", {})
        end
        if not chunk then return false end
        local runOK, savedData = pcall(chunk)
        if not runOK or type(savedData) ~= "table" then return false end

        local allowedConfig = _G.GTLMODConfig or {}
        if type(savedData.GTLMODConfig) == "table" then
            for k, v in pairs(savedData.GTLMODConfig) do
                if type(k) == "string" and type(v) == "boolean" then
                    allowedConfig[k] = v
                elseif type(k) == "string" and type(v) == "number"
                    and v == v and v ~= math.huge and v ~= -math.huge then
                    allowedConfig[k] = v
                end
            end
        end
        _G.GTLMODConfig = allowedConfig
        if type(savedData.CustomTextData) == "table" then
            _G.GTLMODState = _G.GTLMODState or {}
            _G.GTLMODState.CustomTextData = _G.GTLMODState.CustomTextData or {}
            for k, v in pairs(savedData.CustomTextData) do
                if type(k) == "string" and (type(v) == "boolean" or type(v) == "number") then
                    _G.GTLMODState.CustomTextData[k] = v
                elseif type(k) == "string" and type(v) == "string" then
                    _G.GTLMODState.CustomTextData[k] = v
                end
            end
        end
        _G.LastConfigSaveStr = content
        return true
    end)
    if not ok or not loaded then return false end
    return true
end

local function AutoSaveLoop()
    pcall(function() if _G.SaveModSettings then _G.SaveModSettings() end end)
    pcall(function()
        local okTicker, ticker = pcall(require, "common.time_ticker") 
        if okTicker and ticker and ticker.AddTimerOnce then 
            ticker.AddTimerOnce(3.0, AutoSaveLoop)
        end
    end)
end

if not _G.ModConfigLoaded then
    _G.LoadModSettings()
    AutoSaveLoop()
    _G.ModConfigLoaded = true
end

_G.ReadLiveConfig = function()
    if _G.SaveModSettings then _G.SaveModSettings() end
end

-- ==============================================================================
-- ================= DATA & LOGIC MOD SKIN ======================================
-- ==============================================================================
_G.VIP_Attachments = {
    [1101004236]={1010042307,1010042306,1010042308,1010042304,1010042300,1010042305,1010042299,1010042298,1010042297,1010042296,1010042295,1010042294,0,1010042314,1010042309,1010042316,1010042317,1010042318,1010042310,1010042315,1010042319,0},
    [1101001116]={1010011106,1010011107,1010011108,0,1010011109,1010011112,1010011105,1010011104,1010011103,0,1010011102,0,0,0,0,0,0,0,0,0,0,0},
    [1101001128]={1010011232,1010011233,1010011234,1010011228,1010011227,1010011229,1010011226,1010011225,1010011224,1010011223,1010011222,0,0,0,0,0,0,0,0,0,0,0},
    [1101001154]={1010011487,1010011488,1010011489,1010011493,1010011490,1010011494,1010011486,1010011485,1010011484,1010011483,1010011482,1010011497,0,0,0,0,0,0,0,0,1010011498,0},
    [1101001174]={1010011667,1010011668,1010011669,1010011673,1010011670,1010011674,1010011666,1010011665,1010011664,1010011663,1010011662,0,0,0,0,0,0,0,0,0,0,0},
    [1101001213]={1010012067,1010012068,1010012069,1010012072,1010012070,1010012073,1010012066,1010012065,1010012064,1010012063,1010012062,0,0,0,0,0,0,0,0,0,1010012074,0},
    [1101001231]={1010012267,1010012268,1010012269,1010012273,1010012272,1010012274,1010012266,1010012265,1010012264,1010012263,1010012262,1010012075,0,0,0,0,0,0,0,0,1010012275,0},
    [1101001242]={1010012357,1010012358,1010012359,1010012363,1010012362,1010012364,1010012356,1010012355,1010012354,1010012353,1010012352,1010012276,0,0,0,0,0,0,0,0,1010012365,0},
    [1101001249]={1010012437,1010012438,1010012439,1010012443,1010012442,1010012444,1010012436,1010012435,1010012434,1010012433,1010012432,1010012366,0,0,0,0,0,0,0,0,1010012445,0},
    [1101001256]={1010012588,1010012589,1010012590,1010012593,1010012592,1010012594,1010012587,1010012586,1010012585,1010012584,1010012583,1010012582,0,0,0,0,0,0,0,0,1010012595,0},
    [1101001265]={1010012698,1010012699,1010012700,1010012703,1010012702,1010012704,1010012697,1010012696,1010012695,1010012694,1010012693,1010012692,0,0,0,0,0,0,0,0,1010012705,0},
    [1101001276]={1010012698,1010012699,1010012700,1010012703,1010012702,1010012704,1010012697,1010012696,1010012695,1010012694,1010012693,1010012692,0,0,0,0,0,0,0,0,1010012705,0},
    [1101002029]={1010020249,1010020250,1010020255,1010020247,1010020246,1010020248,1010020240,1010020239,1010020238,1010020237,1010020236,1010020235,0,0,0,0,0,0,0,1010020257,1010020256,1010020258},
    [1101002056]={1010020519,0,0,1010020517,1010020516,1010020518,1010020500,1010020509,1010020508,1010020507,1010020506,1010020505,0,0,0,0,0,0,0,0,0,0},
    [1101002081]={1010020768,1010020769,1010020770,1010020766,1010020760,1010020767,1010020759,1010020758,1010020757,1010020756,1010020755,1010020776,0,0,0,0,0,0,0,1010020775,1010020777,1010020778},
    [1101003070]={1010030654,1010030653,1010030655,1010030649,1010030648,1010030650,1010030647,1010030646,1010030645,1010030644,1010030643,1010030642,0,1010030658,1010030656,1010030660,1010030662,1010030659,1010030657,0,1010030663,0},
    [1101003080]={1010030754,1010030753,1010030755,1010030749,1010030748,1010030750,1010030747,1010030746,1010030745,1010030744,1010030743,1010030742,0,1010030758,1010030756,1010030760,1010030762,1010030759,1010030757,0,1010030763,0},
    [1101003099]={1010030943,1010030944,1010030945,1010030939,1010030938,1010030942,1010030937,1010030936,1010030935,1010030934,1010030933,1010030932,0,1010030947,1010030946,1010030948,1010030949,1010030953,1010030952,0,1010030955,0},
    [1101003119]={1010031139,1010031140,1010031142,1010031138,1010031137,1010031146,1010031136,1010031135,1010031134,1010031133,1010031132,0,0,1010031144,1010031143,0,0,0,1010031145,0,0,0},
    [1101003146]={1010031229,1010031230,1010031237,1010031228,1010031227,1010031242,1010031226,1010031225,1010031224,1010031223,1010031222,0,0,1010031239,1010031238,0,0,0,1010031240,0,0,0},
    [1101003167]={1010031609,1010031610,1010031613,1010031608,1010031607,1010031617,1010031606,1010031605,1010031604,1010031603,1010031602,1010031618,0,1010031615,1010031614,1010031620,1010031622,1010031619,1010031616,0,1010031623,0},
    [1101003181]={1010031765,1010031764,1010031766,1010031759,1010031758,1010031763,1010031757,1010031756,1010031755,1010031754,1010031753,1010031752,0,1010031769,1010031767,1010031773,1010031774,1010031772,1010031768,0,1010031775,0},
    [1101003195]={1010031912,1010031911,1010031913,1010031908,1010031907,1010031909,1010031906,1010031905,1010031904,1010031903,1010031902,1010031901,0,1010031916,1010031914,1010031918,1010031919,1010031917,1010031915,0,1010031921,0},
    [1101003208]={1010032034,1010032033,1010032045,1010032029,1010032028,1010032032,1010032027,1010032026,1010032025,1010032024,1010032023,1010032022,0,1010032038,1010032036,1010032042,1010032043,1010032039,1010032037,0,1010032044,0},
    [1101004046]={1010040474,1010040475,1010040476,1010040472,1010040471,1010040473,1010040470,1010040469,1010040468,1010040467,1010040466,1010040481,0,1010040479,1010040477,1010040482,1010040483,1010040484,1010040478,1010040480,1010040485,0},
    [1101004062]={1010040578,1010040577,1010040579,1010040575,1010040570,1010040576,1010040569,1010040568,1010040567,1010040566,1010040565,1010040564,0,1010040585,1010040580,1010040587,1010040588,1010040589,1010040584,1010040586,1010040590,1010040594},
    [1101004098]={1010040924,1010040926,1010040925,0,1010040937,1010040938,1010040935,1010040934,1010040929,1010040928,1010040927,0,0,1010040939,1010040945,0,0,0,1010040944,1010040936,0,0},
    [1101004138]={1010041136,1010041137,1010041138,1010041134,1010041129,1010041135,1010041128,1010041127,1010041126,1010041125,1010041124,0,0,1010041145,1010041139,0,0,0,1010041144,1010041146,0,0},
    [1101004163]={1010041570,1010041574,1010041575,1010041568,1010041567,1010041569,1010041566,1010041565,1010041564,1010041560,1010041554,0,0,1010041578,1010041576,0,0,0,1010041577,1010041579,0,0},
    [1101004201]={1010041956,1010041957,1010041958,1010041950,1010041949,1010041955,1010041948,1010041947,1010041946,1010041945,1010041944,1010041967,0,1010041965,1010041959,0,0,0,1010041960,1010041966,0,0},
    [1101004209]={1010042038,1010042037,1010042039,1010042035,1010042034,1010042036,1010042029,1010042028,1010042027,1010042026,1010042025,1010042024,0,1010042046,1010042044,1010042048,1010042049,1010042054,1010042045,1010042047,1010042055,0},
    [1101004218]={1010042128,1010042127,1010042129,1010042125,1010042124,1010042126,1010042119,1010042118,1010042117,1010042116,1010042115,1010042114,0,1010042136,1010042134,1010042138,1010042139,1010042144,1010042135,1010042137,1010042145,0},
    [1101004226]={1010042238,1010042237,1010042239,1010042235,1010042234,1010042236,1010042233,1010042232,1010042231,1010042219,1010042218,1010042217,0,1010042243,1010042241,1010042245,1010042246,1010042247,1010042242,1010042244,1010042248,0},
    [1101004246]={1010042406,1010042407,1010042408,1010042404,1010042400,1010042405,1010042399,1010042398,1010042397,1010042396,1010042395,1010042394,0,1010042414,1010042409,1010042416,1010042417,1010042418,1010042410,1010042415,1010042419,1010042420},
    [1101005038]={0,0,1010050327,1010050329,1010050328,1010050330,1010050326,1010050325,1010050324,1010050323,1010050322,1010050334,0,0,0,0,0,0,0,0,0,0},
    [1101005052]={0,0,1010050467,1010050469,1010050468,1010050470,1010050466,1010050465,1010050464,1010050463,1010050462,1010050473,0,0,0,0,0,0,0,0,0,0},
    [1101005098]={0,0,1010050928,1010050930,1010050929,1010050932,1010050927,1010050926,1010050925,1010050924,1010050923,1010050922,0,0,0,0,0,0,0,0,0,0},
    [1101006062]={1010060573,1010060572,1010060574,1010060564,1010060563,1010060571,1010060562,1010060561,1010060554,1010060553,1010060552,1010060551,0,1010060583,1010060581,1010060591,1010060592,1010060584,1010060582,0,1010060593,0},
    [1101006075]={1010060702,1010060701,1010060703,1010060698,1010060697,1010060699,1010060696,1010060695,1010060694,1010060693,1010060692,1010060691,0,1010060706,1010060704,1010060708,1010060709,1010060707,1010060705,0,1010060711,0},
    [1101006085]={1010060796,1010060795,1010060797,1010060793,1010060789,1010060794,1010060788,1010060787,1010060786,1010060785,1010060784,1010060783,0,1010060800,1010060798,1010060804,1010060805,1010060803,1010060799,0,1010060806,0},
    [1101007046]={1010070410,1010070413,1010070414,1010070408,1010070407,1010070409,1010070406,1010070405,1010070404,1010070403,1010070402,1010070418,0,1010070417,1010070415,1010070420,1010070422,1010070419,1010070416,0,1010070423,0},
    [1101007062]={1010070579,1010070578,1010070581,1010070576,1010070575,1010070577,1010070574,1010070573,1010070572,1010070571,1010070569,1010070568,0,1010070584,1010070582,1010070585,1010070586,1010070587,1010070583,0,1010070588,0},
    [1101007071]={1010070663,1010070662,1010070664,1010070659,1010070658,1010070660,1010070657,1010070656,1010070655,1010070654,1010070653,1010070652,0,1010070667,1010070665,1010070668,1010070669,1010070670,1010070666,0,1010070672,0},
    [1101008051]={1010080463,1010080464,1010080465,1010080459,1010080458,1010080462,1010080457,1010080456,1010080455,1010080454,1010080453,1010080452,0,1010080467,1010080466,1010080468,1010080469,1010080473,1010080472,0,1010080475,0},
    [1101008061]={1010080563,1010080564,1010080565,1010080559,1010080558,1010080562,1010080557,1010080556,1010080555,1010080554,1010080553,0,0,1010080567,1010080566,0,0,0,1010080572,0,0,0},
    [1101008070]={1010080609,1010080612,1010080613,1010080608,1010080607,1010080617,1010080606,1010080605,1010080604,1010080603,1010080602,0,0,1010080615,1010080614,0,0,0,1010080616,0,0,0},
    [1101008081]={1010080740,1010080743,1010080745,1010080738,1010080737,1010080739,1010080736,1010080735,1010080734,1010080733,1010080732,1010080748,0,1010080747,1010080746,1010080750,1010080752,1010080749,1010080744,0,1010080753,0},
    [1101008104]={1010080980,1010080982,1010080984,1010080978,1010080977,1010080979,1010080976,1010080975,1010080974,1010080973,1010080972,1010080992,0,1010080986,1010080985,1010080989,1010080987,1010080993,1010080983,0,1010080988,0},
    [1101008116]={1010081110,1010081112,1010081114,1010081108,1010081107,1010081109,1010081106,1010081105,1010081104,1010081103,1010081102,0,0,1010081116,1010081115,0,0,0,1010081113,0,0,0},
    [1101008126]={1010081210,1010081225,1010081226,1010081208,1010081207,1010081209,1010081206,1010081205,1010081204,1010081203,1010081202,1010081218,0,1010081217,1010081216,1010081219,1010081220,1010081222,1010081214,1010081228,1010081227,1010081229},
    [1101008136]={1010081314,1010081315,1010081316,1010081312,1010081308,1010081313,1010081307,1010081306,1010081305,1010081304,1010081303,1010081302,0,1010081318,1010081317,1010081322,1010081323,1010081325,1010081324,0,1010081326,0},
    [1101008146]={1010081401,1010081402,1010081403,1010081398,1010081397,1010081399,1010081396,1010081395,1010081394,1010081393,1010081392,1010081391,0,1010081405,1010081404,1010081406,1010081407,1010081409,1010081408,0,1010081411,0},
    [1101008154]={1010081531,1010081532,1010081533,1010081528,1010081527,1010081529,1010081526,1010081525,1010081524,1010081523,1010081522,1010081521,0,1010081541,1010081534,1010081542,1010081543,1010081545,1010081544,0,1010081546,0},
    [1101008163]={1010081582,1010081583,1010081584,1010081579,1010081578,1010081580,1010081577,1010081576,1010081575,1010081574,1010081573,1010081572,0,1010081586,1010081585,1010081587,1010081588,1010081590,1010081589,0,1010081592,0},
    [1101012033]={1010120284,1010120285,1010120286,1010120280,1010120279,1010120283,1010120278,1010120277,1010120276,1010120275,1010120274,1010120273,0,0,0,0,0,0,0,0,1010120287,0},
    [1101100012]={1011000066,1011000067,1011000068,0,0,0,1011000058,1011000057,1011000056,1011000055,1011000054,1011000053,0,0,0,0,0,0,0,0,1011000073,0},
    [1101102007]={1011010025,1011010024,1011010026,1011010020,1011010019,1011010023,1011010018,1011010017,1011010016,1011010015,1011010014,1011010013,0,0,0,0,0,0,0,0,1011010027,0},
    [1101102017]={1011020027,1011020028,1011020029,1011020025,1011020024,1011020026,1011020019,1011020018,1011020017,1011020016,1011020015,1011020014,0,1011020036,1011020034,1011020038,1011020039,1011020044,1011020035,1011020037,1011020045,1011020047},
    [1101102025]={1011020127,1011020128,1011020129,1011020125,1011020124,1011020126,1011020119,1011020118,1011020117,1011020116,1011020115,1011020114,0,1011020136,1011020134,1011020138,1011020139,1011020144,1011020135,1011020137,1011020145,0},
    [1101102041]={1011020214,1011020215,1011020216,1011020212,1011020211,1011020213,1011020209,1011020208,1011020207,1011020206,1011020205,1011020204,0,1011020219,1011020217,1011020222,1011020223,1011020224,1011020218,1011020221,1011020225,1011020229},
    [1101102049]={1011020356,1011020357,1011020358,1011020354,1011020350,1011020355,1011020349,1011020348,1011020347,1011020346,1011020345,1011020344,0,1011020364,1011020359,1011020366,1011020367,1011020368,1011020360,1011020365,1011020369,1011020370},
    [1101101007]={1011020436,1011020437,1011020438,1011020434,1011020430,1011020435,1011020429,1011020428,1011020427,1011020426,1011020425,1011020424,0,1011020444,1011020439,1011020446,1011020447,1011020448,1011020440,1011020445,1011020449,1011020450},
    [1102001120]={1020011137,1020011138,1020011139,1020011135,1020011134,1020011136,1020011133,1020011132,0,0,0,0,0,0,0,0,0,0,0,1020011142,0,0},
    [1102001130]={1020011247,1020011248,1020011249,1020011245,1020011244,1020011246,1020011243,1020011242,0,0,0,0,0,0,0,0,0,0,0,1020011250,0,0},
    [1102002043]={1020020372,1020020374,1020020373,1020020383,1020020380,1020020384,1020020379,1020020378,1020020377,1020020376,1020020375,1020020388,0,1020020385,1020020387,0,0,0,1020020386,0,0,0},
    [1102002061]={1020020552,1020020554,1020020553,1020020563,1020020562,1020020564,1020020559,1020020558,1020020557,1020020556,1020020555,1020020578,0,1020020565,1020020567,1020020573,1020020574,1020020572,1020020566,0,1020020569,0},
    [1102002136]={1020021314,1020021313,1020021315,1020021309,1020021308,1020021312,1020021307,1020021306,1020021305,1020021304,1020021303,1020021302,0,1020021318,1020021316,1020021323,1020021324,1020021322,1020021317,0,1020021325,0},
    [1102002424]={1020024193,1020024192,1020024194,1020024189,1020024188,1020024190,1020024187,1020024186,1020024185,1020024184,1020024183,1020024182,0,1020024197,1020024195,1020024199,1020024200,1020024198,1020024196,0,1020024202,0},
    [1102003080]={1020030755,1020030756,1020030758,0,1020030749,1020030754,1020030748,1020030747,1020030746,1020030745,1020030744,1020030764,0,1020030760,0,1020030759,1020030757,0,0,1020030765,0,0},
    [1102003100]={1020030956,1020030957,1020030958,1020030954,1020030950,1020030955,1020030949,1020030948,1020030947,1020030946,1020030945,1020030944,0,1020030964,0,1020030960,1020030959,1020030965,0,1020030967,1020030966,1020030968},
    [1102005064]={1020050588,1020050589,1020050590,0,0,0,1020050587,1020050586,1020050585,1020050584,1020050583,1020050582,0,0,0,0,0,0,0,0,1020050592,0},
    [1103001101]={1030010954,1030010955,1030010956,0,0,0,0,0,0,0,1030010953,1030010952,1030010951,0,0,0,0,0,0,1030010957,0,1030010958},
    [1103001146]={1030011344,1030011345,1030011346,0,0,0,0,0,0,0,1030011343,1030011342,1030011341,0,0,0,0,0,0,1030011347,0,1030011348},
    [1103001154]={1030011484,1030011485,1030011486,0,0,0,0,0,0,0,1030011483,1030011482,1030011481,0,0,0,0,0,0,1030011487,0,1030011488},
    [1103001179]={1030011738,1030011739,1030011741,0,0,0,1030011737,1030011736,1030011735,1030011734,1030011733,1030011732,1030011731,0,0,0,0,0,0,1030011742,1030011743,1030011744},
    [1103001191]={1030011858,1030011859,1030011861,0,0,0,1030011857,1030011856,1030011855,1030011854,1030011853,1030011852,1030011851,0,0,0,0,0,0,1030011862,1030011863,1030011864},
    [1103001202]={1030011948,1030011949,1030011950,0,0,0,1030011947,1030011946,1030011945,1030011944,1030011943,1030011942,1030011941,0,0,0,0,0,0,1030011951,1030011952,1030011953},
    [1103002030]={1030020245,1030020246,1030020247,1030020252,1030020249,1030020253,1030020258,1030020257,1030020256,1030020255,1030020244,1030020243,1030020242,0,0,0,0,0,0,1030020248,0,0},
    [1103002059]={1030020544,1030020545,1030020546,1030020542,1030020539,1030020543,1030020538,1030020537,1030020536,1030020535,1030020534,1030020533,1030020532,0,0,0,0,0,0,1030020547,1030020548,0},
    [1103002087]={1030020824,1030020825,1030020826,0,0,0,1030020818,1030020817,1030020816,1030020815,1030020814,1030020813,1030020812,0,0,0,0,0,0,1030020827,1030020828,0},
    [1103002106]={1030021009,1030021010,1030021012,1030021015,1030021014,1030021016,1030021008,1030021007,1030021006,1030021005,1030021004,1030021003,1030021002,0,0,0,0,0,0,1030021013,1030021017,0},
    [1103002113]={1030021079,1030021080,1030021082,1030021085,1030021084,1030021086,1030021078,1030021077,1030021076,1030021075,1030021074,1030021073,1030021072,0,0,0,0,0,0,1030021083,1030021087,0},
    [1103003022]={1030030165,1030030166,1030030167,1030030172,1030030169,1030030173,0,0,0,0,1030030164,1030030163,1030030162,0,0,0,0,0,0,0,0,0},
    [1103003030]={1030030256,1030030257,1030030258,1030030254,1030030253,1030030255,1030030248,1030030247,1030030246,1030030245,1030030244,1030030243,1030030242,0,0,0,0,0,0,1030030259,1030030249,0},
    [1103003042]={1030030374,1030030375,1030030376,1030030372,1030030369,1030030373,0,0,0,0,1030030364,1030030363,1030030362,0,0,0,0,0,0,1030030377,0,0},
    [1103003051]={1030030458,1030030459,1030030460,1030030456,1030030455,1030030457,0,0,0,0,1030030454,1030030453,1030030452,0,0,0,0,0,0,1030030463,0,0},
    [1103003062]={1030030568,1030030569,1030030570,1030030566,1030030565,1030030567,0,0,0,0,1030030564,1030030563,1030030562,0,0,0,0,0,0,1030030572,0,0},
    [1103003079]={1030030744,1030030745,1030030746,1030030742,1030030740,1030030743,1030030738,1030030737,1030030736,1030030735,1030030734,1030030733,1030030732,0,0,0,0,0,0,1030030747,1030030739,0},
    [1103003087]={1030030825,1030030826,1030030827,1030030823,1030030824,1030030824,1030030818,1030030817,1030030816,1030030815,1030030814,1030030813,1030030812,0,0,0,0,0,0,1030030828,1030030819,0},
    [1103004037]={1030040315,1030040316,1030040317,1030040325,1030040324,1030040323,0,0,0,0,1030040314,1030040313,1030040312,1030040327,1030040326,0,0,0,1030040328,1030040329,0,0},
    [1103006030]={1030060245,1030060246,1030060247,0,1030060253,1030060252,0,0,0,0,1030060244,1030060243,1030060242,0,0,0,0,0,0,0,0,0},
    [1103007028]={1030070233,1030070234,1030070235,1030070226,1030070225,1030070227,1030070218,1030070217,1030070216,1030070215,1030070214,1030070213,1030070212,0,0,0,0,0,0,1030070236,1030070219,0},
    [1103012010]={0,0,0,0,0,0,1030120038,1030120037,1030120036,1030120035,1030120034,1030120033,1030120032,0,0,0,0,0,0,0,0,0},
    [1103012019]={0,0,0,0,0,0,1030120138,1030120137,1030120136,1030120135,1030120134,1030120133,1030120132,0,0,0,0,0,0,0,0,0},
    [1103012031]={0,0,0,0,0,0,1030120258,1030120257,1030120256,1030120255,1030120254,1030120253,1030120252,0,0,0,0,0,0,0,0,0},
    [1103012039]={0,0,0,0,0,0,1030120339,1030120338,1030120337,1030120336,1030120335,1030120334,1030120333,0,0,0,0,0,0,0,0,0},
    [1103102007]={1031020026,1031020027,1031020028,1031020024,1031020023,1031020025,1031020019,1031020018,1031020017,1031020016,1031020015,1031020014,1031020013,0,0,0,0,0,0,1031020029,0,0},
    [1105001034]={0,0,0,0,1050010287,1050010289,1050010286,1050010285,1050010284,1050010283,1050010282,0,0,0,0,0,0,0,0,1050010292,0,0},
    [1105001048]={0,0,0,1050010429,1050010428,1050010434,1050010427,1050010426,1050010425,1050010424,1050010423,0,0,0,0,0,0,0,0,1050010435,0,1050010436},
    [1105001069]={0,0,0,1050010639,1050010638,1050010640,1050010637,1050010636,1050010635,1050010634,1050010633,1050010645,0,0,0,0,0,0,0,1050010643,1050010646,1050010644},
    [1105002091]={0,0,0,0,0,0,1050020847,1050020846,1050020845,1050020844,1050020843,1050020842,0,0,0,0,0,0,0,0,0,1050020848},
    [1105010019]={0,0,0,0,0,0,1050100144,1050100143,1050100142,1050100141,1050100139,1050100138,0,0,0,0,0,0,0,0,0,0}
}

_G.BaseAttachToIndex = {
    [201010]=1, [201005]=1, [201004]=1, [201009]=2, [201003]=2, [201002]=2, 
    [201011]=3, [201007]=3, [201006]=3, [204012]=4, [204005]=4, [204008]=4, 
    [204011]=5, [204004]=5, [204007]=5, [204013]=6, [204006]=6, [204009]=6, 
    [203001]=7, [203002]=8, [203003]=9, [203014]=10, [203004]=11, [203015]=12, [203005]=13, 
    [202002]=14, [202001]=15, [202004]=16, [202005]=17, [202007]=18, [202006]=19, 
    [205002]=20, [205003]=20, [205001]=20, [203018]=21, [204014]=22 
}

_G.VipAttachToIndex = {}
for skinId, attachList in pairs(_G.VIP_Attachments) do
    for index, attachId in ipairs(attachList) do
        if attachId > 0 then
            _G.VipAttachToIndex[attachId] = index
        end
    end
end

_G.WeaponSkinMap = _G.WeaponSkinMap or {}
_G.VehicleSkinMap = _G.VehicleSkinMap or {}
_G.OutfitMap = _G.OutfitMap or {}
_G.skinIdCache = _G.skinIdCache or {}
_G.skinIdCache2 = _G.skinIdCache2 or {}

_G.OutfitSkins = {
    Suit = {403003,1407916,1406469,1405870,1407140,1407141,1407142,1407550,1406638,1406872,1406971,1407103,1407512,1407391,1407366,1407330,1407329,1407286,1407285,1407277,1407276,1407275,1407225,1407224,1407259,1407161,1407160,1407107,1407106,1407079,1407048,1406977,1406976,1406898,1400569,1404000,1404049,1400119,1400117,1406060,1406891,1400687,1405160,1405145,1405436,1405435,1407385,1406389,1406388,1406387,1400782,1407990,1408038,1408045,1407392,1407318,1407317,1407404,1407402,1407401,1407387,1404434,1404437,1404440,1404448,1400324,1400708,1404043,1404048,1405953,1400101,1404153,1407440,1407441,1405192,1406064, 1405041,1400702,1406897,1407631,1407522,1407558,1407572,1407920,1407961,1407962,1407963,1407964,1407965,1407966,1407967,1407968,1407969,1407970,1407971,1407993,1405192,1408021,1407675,1407676},
    Bag = {
    {501001, 501002, 501003}, {1501001174, 1501002174, 1501003174}, {1501001220, 1501002220, 1501003220},
    {1501001051, 1501002051, 1501003051}, {1501001443, 1501002443, 1501003443}, {1501001265, 1501002265, 1501003265},
    {1501001321, 1501002321, 1501003321}, {1501001277, 1501002277, 1501003277}, {1501001550, 1501002550, 1501003550},
    {1501001592, 1501002592, 1501003592}, {1501001608, 1501002608, 1501003608}, {1501001024, 1501002024, 1501003024},
    {1501001019, 1501002019, 1501003019}, {1501001179, 1501002179, 1501003179}, {1501001194, 1501002194, 1501003194},
    {1501001346, 1501002346, 1501003346},
    {1501001742, 1501002742, 1501003742},
    {1501001023, 1501002023, 1501003023},
    {1501001022, 1501002022, 1501003022},
    {1501001043, 1501002043, 1501003043},
    {1501001045, 1501002045, 1501003045},
    {1501001053, 1501002053, 1501003053},
    {1501001104, 1501002104, 1501003104},
    {1501001054, 1501002054, 1501003054},
    -- NEW BACKPACK SKINS
    {1501001026, 1501002026, 1501003026},
    {1501001058, 1501002058, 1501003058},
    {1501001659, 1501002659, 1501003659},
    {1501001081, 1501002081, 1501003081},
    {1501001085, 1501002085, 1501003085}
},
    Helmet = {
        {502001, 502002, 502003}, {1502001014, 1502002014, 1502003014}, {1502001349, 1502002349, 1502003349},
        {1502001012, 1502002012, 1502003012}, {1502001009, 1502002009, 1502003009}, {1502001397, 1502002397, 1502003397},
        {1502001390, 1502002390, 1502003390}, {1502001381, 1502002381, 1502003381}, {1502001358, 1502002358, 1502003358},
        {1502001350, 1502002350, 1502003350}, {1502001342, 1502002342, 1502003342},
        {1502001439, 1502002439, 1502003439},
        {1502001023, 1502002023, 1502003023},
        {1502001090, 1502002090, 1502003090},
        {1502001069, 1502002069, 1502003069},
        {1502001036, 1502002036, 1502003036},
        {1502001039, 1502002039, 1502003039},
        {1502001080, 1502002080, 1502003080}
    },
    Pet = {50000,50001,50002,50003,50004,50005,50006,50021,50022,50038,50039,50040}
}

_G.skinIdMappings = {
    [101004]={101004, 1101004246,1101004226,1101004236,1101004062,1101004078,1101004086,1101004201,1101004218, 1101004046, 1101004209, 1101004163},
    [101001]={101001,1101001276,1101001089,1101001213,1101001172,1101001127,1101001230,1101001241},
    [101003]={101003,1101003227,1103003208,1101003195,1101003187,1101003098,1101003166,1101003218},
    [102002]={102002,1102002136,1102002043,1102002061,1102002424},
    [101008]={101008,1101008146,1101008154,1101008079,1101008126,1101008104,1101008146,1101008061,1101008116},
    [101006]={101006,1101006085,1101006061,1101006074,1101006043,1101006032,1101006084, 1101006106, 1101006098},
    [101007]={101007,1101007062,1101007071},
    [102001]={102001, 1102001120, 1102001130},
    [101005]={101005, 1101005098},
    [104003]={104003, 1104003037},
    [104004]={104004, 1104004035, 1104004041},
    -- Sniper Rifles
    [103001]={103001, 1103001101, 1103001146, 1103001154},
    [103002]={103002, 1103002030, 1103002059},
    [103003]={103003, 1103003022, 1103003030, 1103003042, 1103003051},
    [103012]={103012, 1103012010, 1103012019, 1103012031},
    -- SMG (Butter Gun)
    [102003]={102003, 1102003080, 1102003100},
    [102004]={102004, 1102004041},
    [101102]={101102, 1101102025, 1101102017, 1101102007}, -- ACE32
}

_G.VehicleSkins = { 
    [1961001] = { 1961007, 1961010, 1961012, 1961013, 1961014, 1961015, 1961016, 1961017, 1961018, 1961020, 1961021, 1961024, 1961025, 1961029, 1961030, 1961031, 1961032, 1961033, 1961034, 1961035, 1961036, 1961037, 1961038, 1961039, 1961040, 1961041, 1961042, 1961043, 1961044, 1961045, 1961046, 1961047, 1961048, 1961049, 1961050, 1961051, 1961052, 1961053, 1961054, 1961055, 1961056, 1961057, 1961058, 1961059, 1961060, 1961061, 1961062, 1961063, 1961064, 1961065, 1961066, 1961067, 1961068, 1961069, 1961070, 1961071, 1961072, 1961136, 1961137, 1961138, 1961139, 1961140, 1961141, 1961142, 1961143, 1961144, 1961145, 1961147, 1961148, 1961149, 1961150, 1961151, 1961152, 1961153 },
    [1903001] = { 1903005, 1903006, 1903007, 1903008, 1903011, 1903012, 1903013, 1903014, 1903015, 1903016, 1903017, 1903018, 1903019, 1903020, 1903021, 1903022, 1903023, 1903024, 1903029, 1903030, 1903031, 1903032, 1903033, 1903034, 1903035, 1903036, 1903037, 1903039, 1903040, 1903041, 1903042, 1903043, 1903044, 1903045, 1903046, 1903051, 1903052, 1903053, 1903054, 1903055, 1903056, 1903057, 1903058, 1903059, 1903060, 1903061, 1903062, 1903063, 1903066, 1903067, 1903068, 1903069, 1903070, 1903071, 1903072, 1903073, 1903074, 1903075, 1903076, 1903079, 1903080, 1903081, 1903082, 1903084, 1903085, 1903086, 1903087, 1903088, 1903089, 1903090, 1903189, 1903190, 1903191, 1903192, 1903193, 1903194, 1903195, 1903196, 1903197, 1903198, 1903199, 1903200, 1903201, 1903202, 1903203, 1903204, 1903205, 1903206, 1903207, 1903208, 1903209, 1903210, 1903211, 1903212, 1903213, 1903214, 1903215, 1903216, 1903217, 1903218, 1903219, 1903220, 1903221, 1903222, 1903223, 1903225, 1903226, 1903227, 1903228 }, 
    [1915001] = { 1915002, 1915003, 1915004, 1915005, 1915006, 1915007, 1915008, 1915009, 1915010, 1915011, 1915012, 1915013, 1915014, 1915015, 1915016, 1915017, 1915018, 1915019, 1915020, 1915021, 1915022, 1915023, 1915024, 1915025, 1915026, 1915099 },          
    [1908001] = { 1908002, 1908003, 1908005, 1908006, 1908007, 1908008, 1908009, 1908010, 1908011, 1908012, 1908013, 1908015, 1908016, 1908017, 1908018, 1908019, 1908021, 1908023, 1908030, 1908031, 1908032, 1908033, 1908034, 1908035, 1908036, 1908037, 1908039, 1908040, 1908041, 1908043, 1908047, 1908049, 1908050, 1908051, 1908052, 1908053, 1908054, 1908055, 1908056, 1908057, 1908059, 1908060, 1908061, 1908062, 1908063, 1908064, 1908066, 1908067, 1908068, 1908069, 1908070, 1908075, 1908076, 1908077, 1908078, 1908080, 1908081, 1908082, 1908083, 1908084, 1908085, 1908086, 1908087, 1908088, 1908089, 1908091, 1908094, 1908095, 1908096, 1908097, 1908098, 1908099, 1908100, 1908101, 1908102, 1908104, 1908105, 1908106, 1908107, 1908108, 1908109, 1908110, 1908111, 1908112, 1908188, 1908189 },   
    [1907001] = { 1907007, 1907008, 1907010, 1907011, 1907012, 1907013, 1907014, 1907016, 1907018, 1907019, 1907021, 1907022, 1907023, 1907025, 1907026, 1907027, 1907028, 1907029, 1907030, 1907032, 1907033, 1907034, 1907035, 1907036, 1907037, 1907038, 1907040, 1907041, 1907043, 1907044, 1907045, 1907046, 1907047, 1907048, 1907049, 1907050, 1907051, 1907052, 1907053, 1907054, 1907055, 1907056, 1907058, 1907059, 1907060, 1907061, 1907062, 1907063, 1907064, 1907065, 1907066, 1907067, 1907068, 1907069, 1907070, 1907071, 1907072, 1907073, 1907074 }
}
_G.CustSlotType = { ClothesEquipemtSlot=5, BackpackEquipemtSlot=8, HelmetEquipemtSlot=9, ParachuteEquipemtSlot=11, GlideEquipemtSlot=15 }

local function DownloadGameItem(id)
    local puffer_manager = require('client.slua.logic.download.puffer.puffer_manager')
    local puffer_const = require('client.slua.logic.download.puffer_const')
    if puffer_manager and puffer_const and puffer_manager.GetState(puffer_const.ENUM_DownloadType.ODPTD, {id}) ~= puffer_const.ENUM_DownloadState.Done then
        puffer_manager.Download(puffer_const.ENUM_DownloadType.ODPTD, {id})
    end
end
_G.download_item = DownloadGameItem

_G.get_skin_id = function(weaponID)
    if not weaponID then return nil end
    local targetSkinId = _G.WeaponSkinMap and _G.WeaponSkinMap[weaponID]
    if targetSkinId and targetSkinId > 0 then
        if not _G.skinIdCache2[targetSkinId] then
            if _G.download_item then pcall(_G.download_item, targetSkinId) end
            _G.skinIdCache2[targetSkinId] = true
        end
        return targetSkinId
    end
    return weaponID
end

_G.equip_character_avatar = function(Character)
    if not Character or not slua.isValid(Character) or not Character.AvatarComponent2 then return end
    local BackpackUtils = import("BackpackUtils")
    local SlotSyncData = Character.AvatarComponent2.NetAvatarData and Character.AvatarComponent2.NetAvatarData.SlotSyncData
    if not SlotSyncData or not slua.isValid(SlotSyncData) or not BackpackUtils then return end
    
    local function EquipAvatar(ApplyDataIdx, mappedSkin, ApplyEquipSlot, isLevelDependent, levelFunc)
        if not mappedSkin or mappedSkin == 0 then return end
        local slotData = SlotSyncData:Get(ApplyDataIdx)
        if slotData and slotData.SlotID == ApplyEquipSlot then
            local applyItemId = mappedSkin
            if isLevelDependent and type(mappedSkin) == "table" then
                local level = levelFunc(slotData.AdditionalItemID) or 1
                if level < 1 then level = 1 end
                if level > 3 then level = 3 end
                applyItemId = mappedSkin[level] or mappedSkin[1]
            end

            if not applyItemId or applyItemId == 0 or slotData.ItemId == applyItemId then return end

            if not _G.skinIdCache[applyItemId] then
                if _G.download_item then pcall(_G.download_item, applyItemId) end
                _G.skinIdCache[applyItemId] = true
            end

            slotData.ItemId = applyItemId
            SlotSyncData:Set(ApplyDataIdx, slotData)
            Character.AvatarComponent2:OnRep_BodySlotStateChanged()
        end
    end

    local hasGliderSlot = false
    for i = 0, SlotSyncData:Num() - 1 do
        local slotData = SlotSyncData:Get(i)
        if slotData and slotData.SlotID == _G.CustSlotType.GlideEquipemtSlot then 
            hasGliderSlot = true
            break 
        end
    end
    if not hasGliderSlot then SlotSyncData:Add({ SlotID = _G.CustSlotType.GlideEquipemtSlot, ItemId = 0 }) end

    for i = 0, SlotSyncData:Num() - 1 do
        EquipAvatar(i, _G.OutfitMap.Suit or 0, _G.CustSlotType.ClothesEquipemtSlot, false)
        EquipAvatar(i, _G.OutfitMap.Bag, _G.CustSlotType.BackpackEquipemtSlot, true, BackpackUtils.GetEquipmentBagLevel)
        EquipAvatar(i, _G.OutfitMap.Helmet, _G.CustSlotType.HelmetEquipemtSlot, true, BackpackUtils.GetEquipmentHelmetLevel)
        EquipAvatar(i, _G.OutfitMap.Parachute or 0, _G.CustSlotType.ParachuteEquipemtSlot, false)
    end
end

_G.ApplyWeaponSkins = function(PlayerCharacter)
    pcall(function()
        local WeaponManager = PlayerCharacter:GetWeaponManager()
        if not slua.isValid(WeaponManager) then return end
        
        for slot = 1, 3 do
            local Weapon = WeaponManager:GetInventoryWeaponByPropSlot(slot)
            if slua.isValid(Weapon) and slua.isValid(Weapon.synData) then
                local WeaponID = Weapon:GetWeaponID()
                local SkinID = _G.get_skin_id(WeaponID) or WeaponID
                local isModified = false
                
                local SkinData = Weapon.synData:Get(7) 
                if SkinData and SkinData.defineID and SkinData.defineID.TypeSpecificID ~= SkinID then
                    SkinData.defineID.TypeSpecificID = SkinID
                    Weapon.synData:Set(7, SkinData)
                    if Weapon.SetWeaponAvatarID then pcall(function() Weapon:SetWeaponAvatarID(SkinID) end) end
                    if not _G.skinIdCache[SkinID] then 
                        _G.download_item(SkinID)
                        _G.skinIdCache[SkinID] = true 
                    end
                    isModified = true
                end
                
                if SkinID >= 10000000 and _G.VIP_Attachments and _G.VIP_Attachments[SkinID] then
                    for AttachIdx = 0, 5 do 
                        local attachData = Weapon.synData:Get(AttachIdx)
                        if attachData then
                            local defineIDRef = slua.IndexReference(attachData, "defineID")
                            if defineIDRef then
                                local attachmentId = defineIDRef.TypeSpecificID
                                if attachmentId and attachmentId > 0 then
                                    local mapIndex = _G.BaseAttachToIndex[attachmentId] or _G.VipAttachToIndex[attachmentId]
                                    if mapIndex and _G.VIP_Attachments[SkinID][mapIndex] and _G.VIP_Attachments[SkinID][mapIndex] > 0 then
                                        local targetAttachId = _G.VIP_Attachments[SkinID][mapIndex]
                                        if targetAttachId ~= attachmentId then
                                            attachData.defineID.TypeSpecificID = targetAttachId
                                            Weapon.synData:Set(AttachIdx, attachData)
                                            if not _G.skinIdCache2[targetAttachId] then 
                                                if _G.download_item then pcall(_G.download_item, targetAttachId) end
                                                _G.skinIdCache2[targetAttachId] = true 
                                            end
                                            isModified = true
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                
                if isModified then
                    if Weapon.DelayHandleAvatarMeshChanged then pcall(function() Weapon:DelayHandleAvatarMeshChanged() end) end
                    if Weapon.OnRep_synData then pcall(function() Weapon:OnRep_synData() end) end
                end
            end
        end
    end)
end

_G.ApplyVehicleSkins = function(PlayerCharacter)
    pcall(function()
        local Vehicle = PlayerCharacter:GetCurrentVehicle()
        if not slua.isValid(Vehicle) then 
            _G.LastVehicleEntity = nil
            return 
        end
        
        local VehicleAvatar = Vehicle.VehicleAvatar or Vehicle.VehicleAvatarComponent_BP or Vehicle:GetAvatarComponent()
        if not slua.isValid(VehicleAvatar) then return end

        local defId = tostring(VehicleAvatar:GetDefaultAvatarID() or Vehicle.VehicleID or "")
        local currentId = tostring(Vehicle:GetAvatarId() or "")
        local applySkinId = 0
        
        for baseMapId, targetSkin in pairs(_G.VehicleSkinMap) do
            if defId:find(tostring(baseMapId)) or currentId:find(tostring(baseMapId)) then 
                applySkinId = targetSkin
                break 
            end
        end

        if applySkinId and applySkinId > 0 and currentId ~= tostring(applySkinId) then
            _G.skinIdCache = _G.skinIdCache or {}
            if not _G.skinIdCache[applySkinId] then 
                if _G.download_item then pcall(_G.download_item, applySkinId) end
                _G.skinIdCache[applySkinId] = true 
            end

            VehicleAvatar.curSwitchEffectId = 7303001
            if VehicleAvatar.ChangeItemAvatar then VehicleAvatar:ChangeItemAvatar(applySkinId, true) end
            
            _G.CurrentEquipVehicleID = applySkinId
            _G.LastVehicleEntity = Vehicle
        end
    end)
end

_G.HandlePetLogic = function()
    pcall(function()
        local petSkin = _G.OutfitMap.Pet
        if not petSkin or petSkin == 0 or petSkin == 50000 or petSkin == _G.LastAppliedPet then return end
        
        _G.skinIdCache = _G.skinIdCache or {}
        if not _G.skinIdCache[petSkin] then 
            if _G.download_item then pcall(_G.download_item, petSkin) end
            _G.skinIdCache[petSkin] = true 
        end
        
        local ModuleManager = require("client.module_framework.ModuleManager")
        if ModuleManager then
            local logic_pet = ModuleManager.GetModule(ModuleManager.CommonModuleConfig.logic_pet)
            if logic_pet then
                if logic_pet.SetCurPetID then logic_pet:SetCurPetID(petSkin) end
                if logic_pet.EquipPet then logic_pet:EquipPet(petSkin) end
            end
        end
        _G.LastAppliedPet = petSkin
    end)
end

_G.ForceRefreshSkinMaps = function()
    pcall(function()
        if not _G.GTLMODState or not _G.GTLMODState.CustomTextData then return end
        local cData = _G.GTLMODState.CustomTextData

        if _G.OutfitSkins then
            if cData.SkinSuit and _G.OutfitSkins.Suit[cData.SkinSuit] then _G.OutfitMap.Suit = _G.OutfitSkins.Suit[cData.SkinSuit] end
            if cData.SkinBag and _G.OutfitSkins.Bag[cData.SkinBag] then _G.OutfitMap.Bag = _G.OutfitSkins.Bag[cData.SkinBag] end
            if cData.SkinHelmet and _G.OutfitSkins.Helmet[cData.SkinHelmet] then _G.OutfitMap.Helmet = _G.OutfitSkins.Helmet[cData.SkinHelmet] end
        end

        if _G.skinIdMappings then
            if cData.SkinM416 and _G.skinIdMappings[101004] and _G.skinIdMappings[101004][cData.SkinM416] then _G.WeaponSkinMap[101004] = _G.skinIdMappings[101004][cData.SkinM416] end
            if cData.SkinAKM and _G.skinIdMappings[101001] and _G.skinIdMappings[101001][cData.SkinAKM] then _G.WeaponSkinMap[101001] = _G.skinIdMappings[101001][cData.SkinAKM] end
            if cData.SkinSCAR and _G.skinIdMappings[101003] and _G.skinIdMappings[101003][cData.SkinSCAR] then _G.WeaponSkinMap[101003] = _G.skinIdMappings[101003][cData.SkinSCAR] end
            if cData.SkinM762 and _G.skinIdMappings[101008] and _G.skinIdMappings[101008][cData.SkinM762] then _G.WeaponSkinMap[101008] = _G.skinIdMappings[101008][cData.SkinM762] end
            if cData.SkinAUG and _G.skinIdMappings[101006] and _G.skinIdMappings[101006][cData.SkinAUG] then _G.WeaponSkinMap[101006] = _G.skinIdMappings[101006][cData.SkinAUG] end
            if cData.SkinUMP and _G.skinIdMappings[102002] and _G.skinIdMappings[102002][cData.SkinUMP] then _G.WeaponSkinMap[102002] = _G.skinIdMappings[102002][cData.SkinUMP] end
            
            if cData.SkinUZI and _G.skinIdMappings[102001] and _G.skinIdMappings[102001][cData.SkinUZI] then _G.WeaponSkinMap[102001] = _G.skinIdMappings[102001][cData.SkinUZI] end
            if cData.SkinGroza and _G.skinIdMappings[101005] and _G.skinIdMappings[101005][cData.SkinGroza] then _G.WeaponSkinMap[101005] = _G.skinIdMappings[101005][cData.SkinGroza] end
            if cData.SkinS12K and _G.skinIdMappings[104003] and _G.skinIdMappings[104003][cData.SkinS12K] then _G.WeaponSkinMap[104003] = _G.skinIdMappings[104003][cData.SkinS12K] end
            if cData.SkinDBS and _G.skinIdMappings[104004] and _G.skinIdMappings[104004][cData.SkinDBS] then _G.WeaponSkinMap[104004] = _G.skinIdMappings[104004][cData.SkinDBS] end
        end

        if _G.VehicleSkins then
            if cData.SkinDacia and _G.VehicleSkins[1903001] and _G.VehicleSkins[1903001][cData.SkinDacia] then _G.VehicleSkinMap[1903001] = _G.VehicleSkins[1903001][cData.SkinDacia] end
            if cData.SkinUAZ and _G.VehicleSkins[1908001] and _G.VehicleSkins[1908001][cData.SkinUAZ] then _G.VehicleSkinMap[1908001] = _G.VehicleSkins[1908001][cData.SkinUAZ] end
            if cData.SkinCoupe and _G.VehicleSkins[1961001] and _G.VehicleSkins[1961001][cData.SkinCoupe] then _G.VehicleSkinMap[1961001] = _G.VehicleSkins[1961001][cData.SkinCoupe] end
            if cData.SkinBuggy and _G.VehicleSkins[1907001] and _G.VehicleSkins[1907001][cData.SkinBuggy] then _G.VehicleSkinMap[1907001] = _G.VehicleSkins[1907001][cData.SkinBuggy] end
            if cData.SkinMirado and _G.VehicleSkins[1915001] and _G.VehicleSkins[1915001][cData.SkinMirado] then _G.VehicleSkinMap[1915001] = _G.VehicleSkins[1915001][cData.SkinMirado] end
        end
    end)
end

local cached_GameplayStatics = nil
local cached_PlayerTombBox = nil
local cached_ActorClass = nil
_G.NeedCheckDeadBoxTimer = 0

_G.DeadBox_TemperRequest = function(PlayerController)
    if _G.NeedCheckDeadBoxTimer <= 0 then return end
    _G.NeedCheckDeadBoxTimer = _G.NeedCheckDeadBoxTimer - 1

    local PlayerCharacter = PlayerController:GetPlayerCharacterSafety()
    if not slua.isValid(PlayerCharacter) then return end
    
    if not cached_GameplayStatics then
        cached_GameplayStatics = import("GameplayStatics")
        cached_ActorClass = import("Actor")
        cached_PlayerTombBox = import("PlayerTombBox")
    end
    
    local UI_Util = require("client.common.ui_util")
    local GameInstance = UI_Util and UI_Util.GetGameInstance()
    if not GameInstance or not cached_GameplayStatics then return end

    local deadBoxes = cached_GameplayStatics.GetAllActorsOfClass(GameInstance, cached_PlayerTombBox, slua.Array(UEnums.EPropertyClass.Object, cached_ActorClass))
    
    for _, deadBoxActor in pairs(deadBoxes) do
        if slua.isValid(deadBoxActor) and not deadBoxActor.bIsTDSkinApplied then
            local damageCauser = deadBoxActor.DamageCauser
            if damageCauser and damageCauser.PlayerKey == PlayerController.PlayerKey then
                local DeadBoxAvatarComponent = deadBoxActor.DeadBoxAvatarComponent_BP
                if slua.isValid(DeadBoxAvatarComponent) then
                    local currentBoxSkinId = 0
                    if PlayerCharacter.CurrentVehicle and _G.CurrentEquipVehicleID and _G.CurrentEquipVehicleID ~= 0 then
                        currentBoxSkinId = tonumber(tostring(_G.CurrentEquipVehicleID) .. "1") or 0
                    else
                        local currentWeapon = PlayerCharacter:GetCurrentWeapon()
                        if slua.isValid(currentWeapon) and currentWeapon.synData then
                            local weaponSkinData = currentWeapon.synData:Get(7)
                            if weaponSkinData and weaponSkinData.defineID then
                                currentBoxSkinId = weaponSkinData.defineID.TypeSpecificID
                            end
                        end
                    end
                    
                    if currentBoxSkinId ~= 0 then
                        pcall(function()
                            DeadBoxAvatarComponent:ResetItemAvatar()
                            DeadBoxAvatarComponent:PreChangeItemAvatar(currentBoxSkinId)
                            DeadBoxAvatarComponent:SyncChangeItemAvatar(currentBoxSkinId)
                        end)
                    end
                    deadBoxActor.bIsTDSkinApplied = true
                end
            end
        end
    end
end

_G.TDFTDeKillCounts = _G.TDFTDeKillCounts or {}
local CACHED_LinearColor = import("LinearColor")
local CACHED_GoldColor = CACHED_LinearColor and CACHED_LinearColor(1.0, 0.8, 0.0, 1.0) or nil
local CACHED_UI_Manager = nil

_G.ForceEnableKillCounterUI = function()
    pcall(function()
        local KillCounterUISubsystem = package.loaded["GameLua.Mod.BaseMod.Client.KillCounter.KillCounterUISubsystem"] or require("GameLua.Mod.BaseMod.Client.KillCounter.KillCounterUISubsystem")
        if KillCounterUISubsystem and KillCounterUISubsystem.__inner_impl and not _G.KCUISystemHacked2 then
            local kcImpl = KillCounterUISubsystem.__inner_impl
            kcImpl.CheckSupportKCUI = function() return true end
            kcImpl.CheckNeedMainKillCounterUI = function(self, PlayerWeapon, PlayerID)
                if slua.isValid(PlayerWeapon) then
                    local WeaponID = PlayerWeapon:GetWeaponID()
                    self:UpdateMainKillCounterUI(true, WeaponID, _G.get_skin_id(WeaponID) or WeaponID)
                else self:UpdateMainKillCounterUI(false) end
            end
            local originalUpdateMainKillCounterUI = kcImpl.UpdateMainKillCounterUI
            kcImpl.UpdateMainKillCounterUI = function(self, bShow, WeaponID, AvatarID)
                if bShow then AvatarID = _G.get_skin_id(WeaponID) or AvatarID end
                if originalUpdateMainKillCounterUI then originalUpdateMainKillCounterUI(self, bShow, WeaponID, AvatarID) end
            end
            _G.KCUISystemHacked2 = true
        end

        local ModuleManager = require("client.module_framework.ModuleManager")
        if ModuleManager and not _G.KCLogicHacked2 then
            local LogicKillCounter = ModuleManager.GetModule(ModuleManager.CommonModuleConfig.LogicKillCounter)
            if LogicKillCounter then
                LogicKillCounter.CheckSupportKC = function() return true end
                LogicKillCounter.CheckSupportKillCounterAvatar = function() return true end
                LogicKillCounter.CheckHasWeaponKillCounter = function() return true end
                LogicKillCounter.GetBaseKillCounterIdByWeaponId = function() return 2100004 end
                LogicKillCounter.GetEquipedKillCounterId = function() return 2100004 end
                LogicKillCounter.GetMyEquipedKillCounterId = function() return 2100004 end
                LogicKillCounter.GetOneWeaponKillCountInBattle = function(self, uid, weaponId) return _G.TDFTDeKillCounts[weaponId] or 0 end
                LogicKillCounter.GetWeaponKillCountByUid = function(self, uid, weaponId) return _G.TDFTDeKillCounts[weaponId] or 0 end
                _G.KCLogicHacked2 = true
            end
        end

        local killInfoPath = "GameLua.Mod.BaseMod.Client.KillInfoTips.KillInfo"
        local KillInfo = package.loaded[killInfoPath] or require(killInfoPath)
        
        if KillInfo and KillInfo.__inner_impl and not _G.KillInfoCounterHacked then
            local originalFileItem = KillInfo.__inner_impl.FileItem
            KillInfo.__inner_impl.FileItem = function(self, DamageRecordData)
                pcall(function()
                    local LocalPlayer = require("GameLua.GameCore.Data.GameplayData").GetPlayerCharacter()
                    if slua.isValid(LocalPlayer) and DamageRecordData.Causer == LocalPlayer:GetPlayerNameSafety() then 
                        local currentWeapon = LocalPlayer:GetCurrentWeapon()
                        if slua.isValid(currentWeapon) then
                            local weaponID = currentWeapon:GetWeaponID()
                            local skinID = _G.get_skin_id(weaponID)
                            if skinID then DamageRecordData.CauserWeaponAvatarID = skinID end
                            if _G.OutfitMap.Suit and _G.OutfitMap.Suit ~= 0 then DamageRecordData.CauserClothAvatarID = _G.OutfitMap.Suit end
                            
                            if CACHED_GoldColor then
                                DamageRecordData.IsUseColor, DamageRecordData.UseColor = true, CACHED_GoldColor
                            end
                            
                            if DamageRecordData.ResultHealthStatus == 2 then
                                _G.TDFTDeKillCounts[weaponID] = (_G.TDFTDeKillCounts[weaponID] or 0) + 1
                                _G.NeedCheckDeadBoxTimer = 50 
                                
                                if not CACHED_UI_Manager then CACHED_UI_Manager = require("client.slua_ui_framework.manager") end
                                local uiMainKillCounter = CACHED_UI_Manager.GetUI(CACHED_UI_Manager.UI_Config_InGame.MainKillCounter)
                                
                                if uiMainKillCounter and uiMainKillCounter.UpdateWeaponID then
                                    local mainAvatarID = skinID or currentWeapon:GetWeaponMainAvatarID()
                                    uiMainKillCounter:UpdateWeaponID(weaponID, mainAvatarID)
                                    local kcModule = ModuleManager.GetModule(ModuleManager.CommonModuleConfig.LogicKillCounter)
                                    local kcItemID = kcModule:GetEquipedKillCounterId(0, mainAvatarID)
                                    uiMainKillCounter:SetKillCounterItemShowWithNum(kcItemID, _G.TDFTDeKillCounts[weaponID], mainAvatarID)
                                end
                            end
                        end
                    end
                end)
                if originalFileItem then return originalFileItem(self, DamageRecordData) end
            end
            _G.KillInfoCounterHacked = true
        end

        local SwitchWeaponSlotMode2 = package.loaded["GameLua.Mod.BaseMod.Client.MainControlUI.SwitchWeaponSlotMode2"] or require("GameLua.Mod.BaseMod.Client.MainControlUI.SwitchWeaponSlotMode2")
        if SwitchWeaponSlotMode2 and SwitchWeaponSlotMode2.__inner_impl and not _G.SlotBaseHacked then
            SwitchWeaponSlotMode2.__inner_impl.CheckShowKCIcon = function(self)
                if slua.isValid(self.KillCounterImg) then 
                    self.KillCounterImg:SetVisibility(import("ESlateVisibility").SelfHitTestInvisible) 
                end
            end
            _G.SlotBaseHacked = true
        end
    end)
end

function _G.InitializeSkinModSystem()
    pcall(function()
        local LobbyAvatar = package.loaded["client.logic.avatar.LobbyAvatar"] or require("client.logic.avatar.LobbyAvatar")
        if LobbyAvatar and not _G.LobbyBypassHacked then
            local originalPutonEquipment = LobbyAvatar.PutonEquipment
            LobbyAvatar.PutonEquipment = function(self, itemID, tAvatarCustom, tExtraData)
                local attachIndex = _G.BaseAttachToIndex and _G.BaseAttachToIndex[itemID]
                if attachIndex then
                    local holdingWeaponSkinID = self.GetCurHoldingWeaponSkinID and self:GetCurHoldingWeaponSkinID()
                    if holdingWeaponSkinID and holdingWeaponSkinID >= 10000000 and _G.VIP_Attachments and _G.VIP_Attachments[holdingWeaponSkinID] then
                        local vipAttachID = _G.VIP_Attachments[holdingWeaponSkinID][attachIndex]
                        if vipAttachID and vipAttachID > 0 then
                            if self.HandleDownload then self:HandleDownload(vipAttachID, nil, nil, false) end
                            itemID = vipAttachID
                        end
                    end
                end
                if originalPutonEquipment then return originalPutonEquipment(self, itemID, tAvatarCustom, tExtraData) end
            end

            local originalCharEquipWeaponByResId = LobbyAvatar.CharEquipWeaponByResId
            LobbyAvatar.CharEquipWeaponByResId = function(self, resID, isUse, isAsync, SocketName)
                local retValue = originalCharEquipWeaponByResId and originalCharEquipWeaponByResId(self, resID, isUse, isAsync, SocketName) or nil
                if isUse and self.GetEquipments then
                    local equipments = self:GetEquipments()
                    for _, equip in ipairs(equipments) do
                        if _G.BaseAttachToIndex and _G.BaseAttachToIndex[equip.itemID] then
                            self:PutonEquipment(equip.itemID, equip.CustomInfo, {bIsUse = false})
                        end
                    end
                end
                return retValue
            end
            _G.LobbyBypassHacked = true
        end
    end)
    
    pcall(function()
        local Common_Items_UIBP = package.loaded["client.slua.component.item.ItemChildren.Common_Items_UIBP"] or require("client.slua.component.item.ItemChildren.Common_Items_UIBP")
        if Common_Items_UIBP and not _G.IconBaloHacked then
        local originalInitView = Common_Items_UIBP.InitView
            Common_Items_UIBP.InitView = function(self, nItemId, nCount, nValidTime, tExtraData)
                tExtraData = tExtraData or {}
                local displayResId = nil
                
                if _G.get_skin_id then
                    local skinID = _G.get_skin_id(nItemId)
                    if skinID and skinID ~= nItemId then displayResId = skinID end
                end
                
                local attachIndex = _G.BaseAttachToIndex and _G.BaseAttachToIndex[nItemId]
                if not displayResId and attachIndex then
                    local GameplayData = require("GameLua.GameCore.Data.GameplayData")
                    local LocalPlayer = GameplayData and GameplayData.GetPlayerCharacter()
                    if slua.isValid(LocalPlayer) then
                        local currentWeapon = LocalPlayer:GetCurrentWeapon()
                        if slua.isValid(currentWeapon) then
                            local weaponID = currentWeapon:GetWeaponID()
                            local finalSkinID = _G.get_skin_id(weaponID) or weaponID
                            if finalSkinID >= 10000000 and _G.VIP_Attachments and _G.VIP_Attachments[finalSkinID] then
                                local vipAttachID = _G.VIP_Attachments[finalSkinID][attachIndex]
                                if vipAttachID and vipAttachID > 0 then displayResId = vipAttachID end
                            end
                        end
                    end
                end
                
                if displayResId then
                    tExtraData.displayResId = displayResId
                    if not _G.skinIdCache2[displayResId] then
                        if _G.download_item then pcall(_G.download_item, displayResId) end
                        _G.skinIdCache2[displayResId] = true
                    end
                end
                if originalInitView then return originalInitView(self, nItemId, nCount, nValidTime, tExtraData) end
            end
            _G.IconBaloHacked = true
        end
    end)
end

-- ========================================== 
-- KILL COUNTER & KILL MESSAGE EFFECT + DEADBOX SKIN
-- ==========================================
_G.TDFTDeKillCounts = _G.TDFTDeKillCounts or {}
local CACHED_LinearColor = import("LinearColor")
local CACHED_GoldColor = CACHED_LinearColor and CACHED_LinearColor(1.0, 0.8, 0.0, 1.0) or nil
local CACHED_UI_Manager = nil
_G.NeedCheckDeadBoxTimer = 0
_G.LastCheckDeadBoxTime = 0

_G.ForceEnableKillCounterUI = function()
    pcall(function()
        local KillCounterUISubsystem = package.loaded["GameLua.Mod.BaseMod.Client.KillCounter.KillCounterUISubsystem"] or require("GameLua.Mod.BaseMod.Client.KillCounter.KillCounterUISubsystem")
        if KillCounterUISubsystem and KillCounterUISubsystem.__inner_impl and not _G.KCUISystemHacked2 then
            local kcImpl = KillCounterUISubsystem.__inner_impl
            kcImpl.CheckSupportKCUI = function() return true end
            kcImpl.CheckNeedMainKillCounterUI = function(self, PlayerWeapon, PlayerID)
                if slua.isValid(PlayerWeapon) then
                    local WeaponID = PlayerWeapon:GetWeaponID()
                    self:UpdateMainKillCounterUI(true, WeaponID, _G.get_skin_id(WeaponID) or WeaponID)
                else self:UpdateMainKillCounterUI(false) end
            end
            local originalUpdateMainKillCounterUI = kcImpl.UpdateMainKillCounterUI
            kcImpl.UpdateMainKillCounterUI = function(self, bShow, WeaponID, AvatarID)
                if bShow then AvatarID = _G.get_skin_id(WeaponID) or AvatarID end
                if originalUpdateMainKillCounterUI then originalUpdateMainKillCounterUI(self, bShow, WeaponID, AvatarID) end
            end
            _G.KCUISystemHacked2 = true
        end

        local ModuleManager = require("client.module_framework.ModuleManager")
        if ModuleManager and not _G.KCLogicHacked2 then
            local LogicKillCounter = ModuleManager.GetModule(ModuleManager.CommonModuleConfig.LogicKillCounter)
            if LogicKillCounter then
                LogicKillCounter.CheckSupportKC = function() return true end
                LogicKillCounter.CheckSupportKillCounterAvatar = function() return true end
                LogicKillCounter.CheckHasWeaponKillCounter = function() return true end
                LogicKillCounter.GetBaseKillCounterIdByWeaponId = function() return 2100004 end
                LogicKillCounter.GetEquipedKillCounterId = function() return 2100004 end
                LogicKillCounter.GetMyEquipedKillCounterId = function() return 2100004 end
                LogicKillCounter.GetOneWeaponKillCountInBattle = function(self, uid, weaponId) return _G.TDFTDeKillCounts[weaponId] or 0 end
                LogicKillCounter.GetWeaponKillCountByUid = function(self, uid, weaponId) return _G.TDFTDeKillCounts[weaponId] or 0 end
                _G.KCLogicHacked2 = true
            end
        end

        local killInfoPath = "GameLua.Mod.BaseMod.Client.KillInfoTips.KillInfo"
        local KillInfo = package.loaded[killInfoPath] or require(killInfoPath)
        
        if KillInfo and KillInfo.__inner_impl and not _G.KillInfoCounterHacked then
            local originalFileItem = KillInfo.__inner_impl.FileItem
            KillInfo.__inner_impl.FileItem = function(self, DamageRecordData)
                pcall(function()
                    local LocalPlayer = require("GameLua.GameCore.Data.GameplayData").GetPlayerCharacter()
                    if slua.isValid(LocalPlayer) and DamageRecordData.Causer == LocalPlayer:GetPlayerNameSafety() then 
                        local currentWeapon = LocalPlayer:GetCurrentWeapon()
                        if slua.isValid(currentWeapon) then
                            local weaponID = currentWeapon:GetWeaponID()
                            local skinID = _G.get_skin_id(weaponID)
                            if skinID then DamageRecordData.CauserWeaponAvatarID = skinID end
                            if _G.OutfitMap.Suit and _G.OutfitMap.Suit ~= 0 then DamageRecordData.CauserClothAvatarID = _G.OutfitMap.Suit end
                            
                            if CACHED_GoldColor then
                                DamageRecordData.IsUseColor, DamageRecordData.UseColor = true, CACHED_GoldColor
                            end
                            
                            if DamageRecordData.ResultHealthStatus == 2 then
                                _G.TDFTDeKillCounts[weaponID] = (_G.TDFTDeKillCounts[weaponID] or 0) + 1
                                _G.NeedCheckDeadBoxTimer = 50 
                                
                                if not CACHED_UI_Manager then CACHED_UI_Manager = require("client.slua_ui_framework.manager") end
                                local uiMainKillCounter = CACHED_UI_Manager.GetUI(CACHED_UI_Manager.UI_Config_InGame.MainKillCounter)
                                
                                if uiMainKillCounter and uiMainKillCounter.UpdateWeaponID then
                                    local mainAvatarID = skinID or currentWeapon:GetWeaponMainAvatarID()
                                    uiMainKillCounter:UpdateWeaponID(weaponID, mainAvatarID)
                                    local kcModule = ModuleManager.GetModule(ModuleManager.CommonModuleConfig.LogicKillCounter)
                                    local kcItemID = kcModule:GetEquipedKillCounterId(0, mainAvatarID)
                                    uiMainKillCounter:SetKillCounterItemShowWithNum(kcItemID, _G.TDFTDeKillCounts[weaponID], mainAvatarID)
                                end
                            end
                        end
                    end
                end)
                if originalFileItem then return originalFileItem(self, DamageRecordData) end
            end
            _G.KillInfoCounterHacked = true
        end

        local SwitchWeaponSlotMode2 = package.loaded["GameLua.Mod.BaseMod.Client.MainControlUI.SwitchWeaponSlotMode2"] or require("GameLua.Mod.BaseMod.Client.MainControlUI.SwitchWeaponSlotMode2")
        if SwitchWeaponSlotMode2 and SwitchWeaponSlotMode2.__inner_impl and not _G.SlotBaseHacked then
            SwitchWeaponSlotMode2.__inner_impl.CheckShowKCIcon = function(self)
                if slua.isValid(self.KillCounterImg) then 
                    self.KillCounterImg:SetVisibility(import("ESlateVisibility").SelfHitTestInvisible) 
                end
            end
            _G.SlotBaseHacked = true
        end
    end)
end

-- ========================================== 
-- DEADBOX SKIN (temper request)
-- ==========================================
local cached_GameplayStatics = nil
local cached_PlayerTombBox = nil
local cached_ActorClass = nil
_G.DeadBox_TemperRequest = function(PlayerController)
    if _G.NeedCheckDeadBoxTimer <= 0 then return end
    
    local curTime = os.clock()
    if _G.LastCheckDeadBoxTime and (curTime - _G.LastCheckDeadBoxTime) < 2.0 then return end
    _G.LastCheckDeadBoxTime = curTime
    
    _G.NeedCheckDeadBoxTimer = _G.NeedCheckDeadBoxTimer - 1

    local PlayerCharacter = PlayerController:GetPlayerCharacterSafety()
    if not slua.isValid(PlayerCharacter) then return end
    
    if not cached_GameplayStatics then
        cached_GameplayStatics = import("GameplayStatics")
        cached_ActorClass = import("Actor")
        cached_PlayerTombBox = import("PlayerTombBox")
    end
    
    if not _G.CachedActorArray then
        _G.CachedActorArray = slua.Array(UEnums.EPropertyClass.Object, cached_ActorClass)
    end
    
    local UI_Util = require("client.common.ui_util")
    local GameInstance = UI_Util and UI_Util.GetGameInstance()
    if not GameInstance or not cached_GameplayStatics then return end

    local deadBoxes = cached_GameplayStatics.GetAllActorsOfClass(GameInstance, cached_PlayerTombBox, _G.CachedActorArray)
    
    for _, deadBoxActor in pairs(deadBoxes) do
        if slua.isValid(deadBoxActor) and not deadBoxActor.bIsTDSkinApplied then
            local damageCauser = deadBoxActor.DamageCauser
            if damageCauser and damageCauser.PlayerKey == PlayerController.PlayerKey then
                local DeadBoxAvatarComponent = deadBoxActor.DeadBoxAvatarComponent_BP
                if slua.isValid(DeadBoxAvatarComponent) then
                    local currentBoxSkinId = 0
                    if PlayerCharacter.CurrentVehicle and _G.CurrentEquipVehicleID and _G.CurrentEquipVehicleID ~= 0 then
                        currentBoxSkinId = tonumber(tostring(_G.CurrentEquipVehicleID) .. "1") or 0
                    else
                        local currentWeapon = PlayerCharacter:GetCurrentWeapon()
                        if slua.isValid(currentWeapon) and currentWeapon.synData then
                            local weaponSkinData = currentWeapon.synData:Get(7)
                            if weaponSkinData and weaponSkinData.defineID then
                                currentBoxSkinId = weaponSkinData.defineID.TypeSpecificID
                            end
                        end
                    end
                    
                    if currentBoxSkinId ~= 0 then
                        pcall(function()
                            DeadBoxAvatarComponent:ResetItemAvatar()
                            DeadBoxAvatarComponent:PreChangeItemAvatar(currentBoxSkinId)
                            DeadBoxAvatarComponent:SyncChangeItemAvatar(currentBoxSkinId)
                        end)
                    end
                    deadBoxActor.bIsTDSkinApplied = true
                end
            end
        end
    end
end

-- ========================================== 
-- VIP NATIVE MENU SYSTEM (RUNS DIRECTLY FROM GAME SETTINGS)
-- ========================================== 

function _G.InitModMenuTab()
    if _G.ModMenuInitialized then return end
    _G.ModMenuInitialized = true

    _G.GTLMODState.CustomTextData = _G.GTLMODState.CustomTextData or {
        OuterSpeed = 10, InnerSpeed = 10, OuterRecoil = 0, HRecoil = 0.3, VRecoil = 0.3, IpadViewFOV = 120,
        AimTouchHipPrio = 1, AimTouchHipBone = 1, AimTouchHipCond = 1, AimTouchHipSpeed = 50, AimTouchHipFOV = 30, AimTouchHipDist = 250,
        AimTouchSGPrio = 1, AimTouchSGBone = 2, AimTouchSGCond = 1, AimTouchSGSpeed = 80, AimTouchSGFOV = 40, AimTouchSGDist = 30,
        AimTouchScopePrio = 1, AimTouchScopeBone = 2, AimTouchScopeCond = 1, AimTouchScopeSpeed = 40, AimTouchScopeFOV = 20, AimTouchScopeDist = 300, AimTouchScopePred = 0, AimTouchScopeRecoil = 0,
        AimTouchSniperPrio = 1, AimTouchSniperBone = 1, AimTouchSniperCond = 2, AimTouchSniperSpeed = 30, AimTouchSniperFOV = 20, AimTouchSniperDist = 400, AimTouchSniperPred = 0,
        -- Skin
        SkinSuit = 0, SkinBag = 0, SkinHelmet = 0,
        SkinM416 = 0, SkinAKM = 0, SkinSCAR = 0, SkinM762 = 0, SkinAUG = 0, SkinHoney =0, SkinQBZ = 0, SkinASM = 2, SkinACE32 = 0, SkinUMP = 6,
        SkinUZI = 0, SkinVector = 0, SkinGroza = 0, SkinKar98K = 0, SkinAWM = 2, SkinAMR = 0, SkinS12K = 0, SkinDBS = 0,
        SkinDacia = 0, SkinUAZ = 0, SkinCoupe = 0, SkinBuggy = 0, SkinMirado = 0,
    }

    local LocUtil = _G.LocUtil
    if not LocUtil and package.loaded["client.common.LocUtil"] then
        LocUtil = require("client.common.LocUtil")
    end
    
    if LocUtil and not LocUtil._IsModMenuHooked then
        local old_get = LocUtil.GetLocalizeResStr
        LocUtil.GetLocalizeResStr = function(id)
            if type(id) == "string" and not tonumber(id) then
                return id
            end
            return old_get(id)
        end
        LocUtil._IsModMenuHooked = true
    end

    local SettingPageDefine = require("client.logic.NewSetting.SettingPageDefine")
    local SettingCatalog = require("client.logic.NewSetting.SettingCatalog")
    
    if not SettingPageDefine.ModMenu then
        local AliasMap = require("client.slua.umg.NewSetting.Item.AliasMap")
        
        -- ==================== ESP VISUAL (SECTION 1 - FIRST) ====================
        local StackESPVisual = {
            { Key = "ModMenu_ESP1", UI = AliasMap.Switcher, Text = "ESP SKELETON BOX", GetFunc = function() return _G.GTLMODConfig.EspVip end, SetFunc = function(c,v) _G.GTLMODConfig.EspVip = v return true end },
            { Key = "ModMenu_ESP7", UI = AliasMap.Switcher, Text = "ESP REAL ENEMY/BOT", GetFunc = function() return _G.GTLMODConfig.Esp7 end, SetFunc = function(c,v) _G.GTLMODConfig.Esp7 = v return true end },
            { Key = "ModMenu_ESP2", UI = AliasMap.Switcher, Text = "ESP ENEMY DISTANCE", GetFunc = function() return _G.GTLMODConfig.EspDistance end, SetFunc = function(c,v) _G.GTLMODConfig.EspDistance = v return true end },
            { Key = "ModMenu_ESP4", UI = AliasMap.Switcher, Text = "ESP HIT MARK", GetFunc = function() return _G.GTLMODConfig.EspRadar end, SetFunc = function(c,v) _G.GTLMODConfig.EspRadar = v return true end },
            { Key = "ModMenu_ESP5", UI = AliasMap.Switcher, Text = "ESP BOX", GetFunc = function() return _G.GTLMODConfig.Esp5 end, SetFunc = function(c,v) _G.GTLMODConfig.Esp5 = v return true end },
            { Key = "ModMenu_ESPAntenna", UI = AliasMap.Switcher, Text = "ESP GREEN ANTENNA", GetFunc = function() return _G.GTLMODConfig.EspAntenna end, SetFunc = function(c,v) _G.GTLMODConfig.EspAntenna = v return true end },
            { Key = "ModMenu_ESPName", UI = AliasMap.Switcher, Text = "ESP NAME (VISIBLE)", GetFunc = function() return _G.GTLMODConfig.EspName end, SetFunc = function(c,v) _G.GTLMODConfig.EspName = v return true end },
            { Key = "ModMenu_ESPOutline_Ex", UI = AliasMap.TitleSwitcher, Text = "ESP ENEMY (RED AURA)", ExpandIndex = 0, GetFunc = function() return _G.GTLMODConfig.EspOutline end, SetFunc = function(c,v) _G.GTLMODConfig.EspOutline = v return true end },
            { Key = "ModMenu_ESPOutline_Thickness", UI = AliasMap.Slider, Text = "   COLOR SIZE (1-20)", ExpandHandle = "ModMenu_ESPOutline_Ex", MinValue = 1, MaxValue = 20, min = 1, max = 20, GetFunc = function() return _G.GTLMODConfig.OutlineThickness end, SetFunc = function(c,v) _G.GTLMODConfig.OutlineThickness = v return true end }
        }

        -- ==================== AIMBOT FORCE (SECTION 2) ====================
        local StackAimbotForce = {
            { Key = "ModMenu_AT_Ex", UI = AliasMap.TitleSwitcher, Text = "CUSTOM AIMBOT SETTING", ExpandIndex = 0, GetFunc = function() return _G.GTLMODConfig.AimTouchEnable end, SetFunc = function(c,v) _G.GTLMODConfig.AimTouchEnable = v return true end },
            
            -- HIPFIRE
            { Key = "ModMenu_AT_Hip_Ex", UI = AliasMap.TitleSwitcher, Text = "   AIMBOT ONLY [ALL WEAPON]", ExpandHandle = "ModMenu_AT_Ex", ExpandIndex = 0, GetFunc = function() return _G.GTLMODConfig.AimTouchHipfire end, SetFunc = function(c,v) _G.GTLMODConfig.AimTouchHipfire = v return true end },
            { Key = "ModMenu_AT_Hip_IgKnock", UI = AliasMap.Switcher, Text = "      Ignore Knocked", ExpandHandle = "ModMenu_AT_Hip_Ex", GetFunc = function() return _G.GTLMODConfig.AimTouchHipIgKnock end, SetFunc = function(c,v) _G.GTLMODConfig.AimTouchHipIgKnock = v return true end },
            { Key = "ModMenu_AT_Hip_IgBot", UI = AliasMap.Switcher, Text = "      Ignore Bots", ExpandHandle = "ModMenu_AT_Hip_Ex", GetFunc = function() return _G.GTLMODConfig.AimTouchHipIgBot end, SetFunc = function(c,v) _G.GTLMODConfig.AimTouchHipIgBot = v return true end },
            { Key = "ModMenu_AT_Hip_Vis", UI = AliasMap.Switcher, Text = "      Visibility Check", ExpandHandle = "ModMenu_AT_Hip_Ex", GetFunc = function() return _G.GTLMODConfig.AimTouchHipVisCheck end, SetFunc = function(c,v) _G.GTLMODConfig.AimTouchHipVisCheck = v return true end },
         --   { Key = "ModMenu_AT_Hip_Prio", UI = AliasMap.Slider, Text = "      Priority (1-4)", ExpandHandle = "ModMenu_AT_Hip_Ex", MinValue = 1, MaxValue = 4, min = 1, max = 4, Min = 1, Max = 4, GetFunc = function() return _G.GTLMODState.CustomTextData.AimTouchHipPrio or 1 end, SetFunc = function(c,v) local val = math.floor(v+0.5); if val < 1 then val = 1 end; if val > 4 then val = 4 end; _G.GTLMODState.CustomTextData.AimTouchHipPrio = val return true end },
           { Key = "ModMenu_AT_Hip_Bone", UI = AliasMap.Slider, Text = "      Bone Target (1-4)", ExpandHandle = "ModMenu_AT_Hip_Ex", MinValue = 1, MaxValue = 4, min = 1, max = 4, Min = 1, Max = 4, GetFunc = function() return _G.GTLMODState.CustomTextData.AimTouchHipBone or 1 end, SetFunc = function(c,v) local val = math.floor(v+0.5); if val < 1 then val = 1 end; if val > 4 then val = 4 end; _G.GTLMODState.CustomTextData.AimTouchHipBone = val return true end },
          --  { Key = "ModMenu_AT_Hip_Cond", UI = AliasMap.Slider, Text = "      Condition (1-2)", ExpandHandle = "ModMenu_AT_Hip_Ex", MinValue = 1, MaxValue = 2, min = 1, max = 2, Min = 1, Max = 2, GetFunc = function() return _G.GTLMODState.CustomTextData.AimTouchHipCond or 1 end, SetFunc = function(c,v) local val = math.floor(v+0.5); if val < 1 then val = 1 end; if val > 2 then val = 2 end; _G.GTLMODState.CustomTextData.AimTouchHipCond = val return true end },
            { Key = "ModMenu_AT_Hip_Spd", UI = AliasMap.Slider, Text = "      Aim Speed [ 40-50 ]", ExpandHandle = "ModMenu_AT_Hip_Ex", MinValue = 1, MaxValue = 100, min = 1, max = 100, GetFunc = function() return _G.GTLMODState.CustomTextData.AimTouchHipSpeed or 50 end, SetFunc = function(c,v) _G.GTLMODState.CustomTextData.AimTouchHipSpeed = v return true end },
            { Key = "ModMenu_AT_Hip_FOV", UI = AliasMap.Slider, Text = "      FOV Range [20-30]", ExpandHandle = "ModMenu_AT_Hip_Ex", MinValue = 1, MaxValue = 100, min = 1, max = 100, GetFunc = function() return _G.GTLMODState.CustomTextData.AimTouchHipFOV or 30 end, SetFunc = function(c,v) _G.GTLMODState.CustomTextData.AimTouchHipFOV = v return true end },
            { Key = "ModMenu_AT_Hip_Dist", UI = AliasMap.Slider, Text = "      Distance [ 60-70 ]", ExpandHandle = "ModMenu_AT_Hip_Ex", MinValue = 1, MaxValue = 100, min = 1, max = 100, GetFunc = function() return math.floor((_G.GTLMODState.CustomTextData.AimTouchHipDist or 250) / 5) end, SetFunc = function(c,v) _G.GTLMODState.CustomTextData.AimTouchHipDist = v * 5 return true end },
            
            -- SCOPE ALL
            { Key = "ModMenu_AT_ScopeAll_Ex", UI = AliasMap.TitleSwitcher, Text = "   SCOPE AIMBOT [ALL WEAPON]", ExpandHandle = "ModMenu_AT_Ex", ExpandIndex = 0, GetFunc = function() return _G.GTLMODConfig.AimTouchScopeAll end, SetFunc = function(c,v) _G.GTLMODConfig.AimTouchScopeAll = v return true end },
            { Key = "ModMenu_AT_ScopeAll_IgKnock", UI = AliasMap.Switcher, Text = "      Ignore Knocked", ExpandHandle = "ModMenu_AT_ScopeAll_Ex", GetFunc = function() return _G.GTLMODConfig.AimTouchScopeIgKnock end, SetFunc = function(c,v) _G.GTLMODConfig.AimTouchScopeIgKnock = v return true end },
           -- { Key = "ModMenu_AT_ScopeAll_IgBot", UI = AliasMap.Switcher, Text = "      Ignore Bots", ExpandHandle = "ModMenu_AT_ScopeAll_Ex", GetFunc = function() return _G.GTLMODConfig.AimTouchScopeIgBot end, SetFunc = function(c,v) _G.GTLMODConfig.AimTouchScopeIgBot = v return true end },
           -- { Key = "ModMenu_AT_ScopeAll_Vis", UI = AliasMap.Switcher, Text = "      Visibility Check", ExpandHandle = "ModMenu_AT_ScopeAll_Ex", GetFunc = function() return _G.GTLMODConfig.AimTouchScopeVisCheck end, SetFunc = function(c,v) _G.GTLMODConfig.AimTouchScopeVisCheck = v return true end },
         --   { Key = "ModMenu_AT_ScopeAll_Prio", UI = AliasMap.Slider, Text = "      Priority (1-4)", ExpandHandle = "ModMenu_AT_ScopeAll_Ex", MinValue = 1, MaxValue = 4, min = 1, max = 4, Min = 1, Max = 4, GetFunc = function() return _G.GTLMODState.CustomTextData.AimTouchScopePrio or 1 end, SetFunc = function(c,v) local val = math.floor(v+0.5); if val < 1 then val = 1 end; if val > 4 then val = 4 end; _G.GTLMODState.CustomTextData.AimTouchScopePrio = val return true end },
            { Key = "ModMenu_AT_ScopeAll_Bone", UI = AliasMap.Slider, Text = "      Bone Target (1-4)", ExpandHandle = "ModMenu_AT_ScopeAll_Ex", MinValue = 1, MaxValue = 4, min = 1, max = 4, Min = 1, Max = 4, GetFunc = function() return _G.GTLMODState.CustomTextData.AimTouchScopeBone or 2 end, SetFunc = function(c,v) local val = math.floor(v+0.5); if val < 1 then val = 1 end; if val > 4 then val = 4 end; _G.GTLMODState.CustomTextData.AimTouchScopeBone = val return true end },
          --  { Key = "ModMenu_AT_ScopeAll_Cond", UI = AliasMap.Slider, Text = "      Condition (1-2)", ExpandHandle = "ModMenu_AT_ScopeAll_Ex", MinValue = 1, MaxValue = 2, min = 1, max = 2, Min = 1, Max = 2, GetFunc = function() return _G.GTLMODState.CustomTextData.AimTouchScopeCond or 1 end, SetFunc = function(c,v) local val = math.floor(v+0.5); if val < 1 then val = 1 end; if val > 2 then val = 2 end; _G.GTLMODState.CustomTextData.AimTouchScopeCond = val return true end },
            { Key = "ModMenu_AT_ScopeAll_Spd", UI = AliasMap.Slider, Text = "      Speed (40-50)", ExpandHandle = "ModMenu_AT_ScopeAll_Ex", MinValue = 1, MaxValue = 100, min = 1, max = 100, GetFunc = function() return _G.GTLMODState.CustomTextData.AimTouchScopeSpeed or 40 end, SetFunc = function(c,v) _G.GTLMODState.CustomTextData.AimTouchScopeSpeed = v return true end },
            { Key = "ModMenu_AT_ScopeAll_FOV", UI = AliasMap.Slider, Text = "      FOV Range [20-30]", ExpandHandle = "ModMenu_AT_ScopeAll_Ex", MinValue = 1, MaxValue = 100, min = 1, max = 100, GetFunc = function() return _G.GTLMODState.CustomTextData.AimTouchScopeFOV or 20 end, SetFunc = function(c,v) _G.GTLMODState.CustomTextData.AimTouchScopeFOV = v return true end },
            { Key = "ModMenu_AT_ScopeAll_Dist", UI = AliasMap.Slider, Text = "      Distance [ 60-70", ExpandHandle = "ModMenu_AT_ScopeAll_Ex", MinValue = 1, MaxValue = 100, min = 1, max = 100, GetFunc = function() return math.floor((_G.GTLMODState.CustomTextData.AimTouchScopeDist or 300) / 5) end, SetFunc = function(c,v) _G.GTLMODState.CustomTextData.AimTouchScopeDist = v * 5 return true end },
           { Key = "ModMenu_AT_ScopeAll_Pred", UI = AliasMap.Slider, Text = "      Movement Prediction (0-100)", ExpandHandle = "ModMenu_AT_ScopeAll_Ex", MinValue = 0, MaxValue = 100, min = 0, max = 100, GetFunc = function() return _G.GTLMODState.CustomTextData.AimTouchScopePred or 0 end, SetFunc = function(c,v) _G.GTLMODState.CustomTextData.AimTouchScopePred = v return true end },
            { Key = "ModMenu_AT_ScopeAll_Recoil", UI = AliasMap.Slider, Text = "      Recoil Kick Ads (5 to 10)", ExpandHandle = "ModMenu_AT_ScopeAll_Ex", MinValue = 0, MaxValue = 50, min = 0, max = 50, GetFunc = function() return _G.GTLMODState.CustomTextData.AimTouchScopeRecoil or 0 end, SetFunc = function(c,v) _G.GTLMODState.CustomTextData.AimTouchScopeRecoil = v return true end },

            -- AIMBOT SHOTGUN
            { Key = "ModMenu_AT_SG_Ex", UI = AliasMap.TitleSwitcher, Text = "   ALL SHOTGUN AIMBOT", ExpandHandle = "ModMenu_AT_Ex", ExpandIndex = 0, GetFunc = function() return _G.GTLMODConfig.AimTouchSG end, SetFunc = function(c,v) _G.GTLMODConfig.AimTouchSG = v return true end },
           -- { Key = "ModMenu_AT_SG_AutoFire", UI = AliasMap.Switcher, Text = "      Auto Fire", ExpandHandle = "ModMenu_AT_SG_Ex", GetFunc = function() return _G.GTLMODConfig.AimTouchSGAutoFire end, SetFunc = function(c,v) _G.GTLMODConfig.AimTouchSGAutoFire = v return true end },
            { Key = "ModMenu_AT_SG_IgKnock", UI = AliasMap.Switcher, Text = "      Ignore Knocked", ExpandHandle = "ModMenu_AT_SG_Ex", GetFunc = function() return _G.GTLMODConfig.AimTouchSGIgKnock end, SetFunc = function(c,v) _G.GTLMODConfig.AimTouchSGIgKnock = v return true end },
          --  { Key = "ModMenu_AT_SG_IgBot", UI = AliasMap.Switcher, Text = "      Ignore Bots", ExpandHandle = "ModMenu_AT_SG_Ex", GetFunc = function() return _G.GTLMODConfig.AimTouchSGIgBot end, SetFunc = function(c,v) _G.GTLMODConfig.AimTouchSGIgBot = v return true end },
            { Key = "ModMenu_AT_SG_Vis", UI = AliasMap.Switcher, Text = "      Visibility Check", ExpandHandle = "ModMenu_AT_SG_Ex", GetFunc = function() return _G.GTLMODConfig.AimTouchSGVisCheck end, SetFunc = function(c,v) _G.GTLMODConfig.AimTouchSGVisCheck = v return true end },
          --  { Key = "ModMenu_AT_SG_Prio", UI = AliasMap.Slider, Text = "      Priority (1-4)", ExpandHandle = "ModMenu_AT_SG_Ex", MinValue = 1, MaxValue = 4, min = 1, max = 4, Min = 1, Max = 4, GetFunc = function() return _G.GTLMODState.CustomTextData.AimTouchSGPrio or 1 end, SetFunc = function(c,v) local val = math.floor(v+0.5); if val < 1 then val = 1 end; if val > 4 then val = 4 end; _G.GTLMODState.CustomTextData.AimTouchSGPrio = val return true end },
           -- { Key = "ModMenu_AT_SG_Bone", UI = AliasMap.Slider, Text = "      Bone Target (1-4)", ExpandHandle = "ModMenu_AT_SG_Ex", MinValue = 1, MaxValue = 4, min = 1, max = 4, Min = 1, Max = 4, GetFunc = function() return _G.GTLMODState.CustomTextData.AimTouchSGBone or 2 end, SetFunc = function(c,v) local val = math.floor(v+0.5); if val < 1 then val = 1 end; if val > 4 then val = 4 end; _G.GTLMODState.CustomTextData.AimTouchSGBone = val return true end },
            { Key = "ModMenu_AT_SG_Cond", UI = AliasMap.Slider, Text = "      Condition (1-2)", ExpandHandle = "ModMenu_AT_SG_Ex", MinValue = 1, MaxValue = 2, min = 1, max = 2, Min = 1, Max = 2, GetFunc = function() return _G.GTLMODState.CustomTextData.AimTouchSGCond or 1 end, SetFunc = function(c,v) local val = math.floor(v+0.5); if val < 1 then val = 1 end; if val > 2 then val = 2 end; _G.GTLMODState.CustomTextData.AimTouchSGCond = val return true end },
            { Key = "ModMenu_AT_SG_Spd", UI = AliasMap.Slider, Text = "      Speed Aim [100-Max]", ExpandHandle = "ModMenu_AT_SG_Ex", MinValue = 1, MaxValue = 100, min = 1, max = 100, GetFunc = function() return _G.GTLMODState.CustomTextData.AimTouchSGSpeed or 80 end, SetFunc = function(c,v) _G.GTLMODState.CustomTextData.AimTouchSGSpeed = v return true end },
            { Key = "ModMenu_AT_SG_FOV", UI = AliasMap.Slider, Text = "      FOV Range [ 50-60]", ExpandHandle = "ModMenu_AT_SG_Ex", MinValue = 1, MaxValue = 100, min = 1, max = 100, GetFunc = function() return _G.GTLMODState.CustomTextData.AimTouchSGFOV or 40 end, SetFunc = function(c,v) _G.GTLMODState.CustomTextData.AimTouchSGFOV = v return true end },
            { Key = "ModMenu_AT_SG_Dist", UI = AliasMap.Slider, Text = "      Distance [100-Max]", ExpandHandle = "ModMenu_AT_SG_Ex", MinValue = 1, MaxValue = 100, min = 1, max = 100, GetFunc = function() return _G.GTLMODState.CustomTextData.AimTouchSGDist or 30 end, SetFunc = function(c,v) _G.GTLMODState.CustomTextData.AimTouchSGDist = v return true end },
            
            -- SCOPE SNIPER
            { Key = "ModMenu_AT_Sniper_Ex", UI = AliasMap.TitleSwitcher, Text = "   SCOPE AIMBOT (SNIPER ONLY)", ExpandHandle = "ModMenu_AT_Ex", ExpandIndex = 0, GetFunc = function() return _G.GTLMODConfig.AimTouchScopeSniper end, SetFunc = function(c,v) _G.GTLMODConfig.AimTouchScopeSniper = v return true end },
            { Key = "ModMenu_AT_Sniper_IgKnock", UI = AliasMap.Switcher, Text = "      Ignore Knocked", ExpandHandle = "ModMenu_AT_Sniper_Ex", GetFunc = function() return _G.GTLMODConfig.AimTouchSniperIgKnock end, SetFunc = function(c,v) _G.GTLMODConfig.AimTouchSniperIgKnock = v return true end },
         --   { Key = "ModMenu_AT_Sniper_IgBot", UI = AliasMap.Switcher, Text = "      Ignore Bots", ExpandHandle = "ModMenu_AT_Sniper_Ex", GetFunc = function() return _G.GTLMODConfig.AimTouchSniperIgBot end, SetFunc = function(c,v) _G.GTLMODConfig.AimTouchSniperIgBot = v return true end },
         --   { Key = "ModMenu_AT_Sniper_Vis", UI = AliasMap.Switcher, Text = "      Visibility Check", ExpandHandle = "ModMenu_AT_Sniper_Ex", GetFunc = function() return _G.GTLMODConfig.AimTouchSniperVisCheck end, SetFunc = function(c,v) _G.GTLMODConfig.AimTouchSniperVisCheck = v return true end },
         --   { Key = "ModMenu_AT_Sniper_Prio", UI = AliasMap.Slider, Text = "      Priority (1-4)", ExpandHandle = "ModMenu_AT_Sniper_Ex", MinValue = 1, MaxValue = 4, min = 1, max = 4, Min = 1, Max = 4, GetFunc = function() return _G.GTLMODState.CustomTextData.AimTouchSniperPrio or 1 end, SetFunc = function(c,v) local val = math.floor(v+0.5); if val < 1 then val = 1 end; if val > 4 then val = 4 end; _G.GTLMODState.CustomTextData.AimTouchSniperPrio = val return true end },
        --    { Key = "ModMenu_AT_Sniper_Bone", UI = AliasMap.Slider, Text = "      Bone Target (1-4)", ExpandHandle = "ModMenu_AT_Sniper_Ex", MinValue = 1, MaxValue = 4, min = 1, max = 4, Min = 1, Max = 4, GetFunc = function() return _G.GTLMODState.CustomTextData.AimTouchSniperBone or 1 end, SetFunc = function(c,v) local val = math.floor(v+0.5); if val < 1 then val = 1 end; if val > 4 then val = 4 end; _G.GTLMODState.CustomTextData.AimTouchSniperBone = val return true end },
            { Key = "ModMenu_AT_Sniper_Cond", UI = AliasMap.Slider, Text = "      Condition (1-2)", ExpandHandle = "ModMenu_AT_Sniper_Ex", MinValue = 1, MaxValue = 2, min = 1, max = 2, Min = 1, Max = 2, GetFunc = function() return _G.GTLMODState.CustomTextData.AimTouchSniperCond or 2 end, SetFunc = function(c,v) local val = math.floor(v+0.5); if val < 1 then val = 1 end; if val > 2 then val = 2 end; _G.GTLMODState.CustomTextData.AimTouchSniperCond = val return true end },
            { Key = "ModMenu_AT_Sniper_Spd", UI = AliasMap.Slider, Text = "      Speed Scope [100-Max]", ExpandHandle = "ModMenu_AT_Sniper_Ex", MinValue = 1, MaxValue = 100, min = 1, max = 100, GetFunc = function() return _G.GTLMODState.CustomTextData.AimTouchSniperSpeed or 30 end, SetFunc = function(c,v) _G.GTLMODState.CustomTextData.AimTouchSniperSpeed = v return true end },
            { Key = "ModMenu_AT_Sniper_FOV", UI = AliasMap.Slider, Text = "      FOV Range [60-70]", ExpandHandle = "ModMenu_AT_Sniper_Ex", MinValue = 1, MaxValue = 100, min = 1, max = 100, GetFunc = function() return _G.GTLMODState.CustomTextData.AimTouchSniperFOV or 20 end, SetFunc = function(c,v) _G.GTLMODState.CustomTextData.AimTouchSniperFOV = v return true end },
            { Key = "ModMenu_AT_Sniper_Dist", UI = AliasMap.Slider, Text = "      Distance [100-Max]", ExpandHandle = "ModMenu_AT_Sniper_Ex", MinValue = 1, MaxValue = 100, min = 1, max = 100, GetFunc = function() return math.floor((_G.GTLMODState.CustomTextData.AimTouchSniperDist or 400) / 5) end, SetFunc = function(c,v) _G.GTLMODState.CustomTextData.AimTouchSniperDist = v * 5 return true end },
            { Key = "ModMenu_AT_Sniper_Pred", UI = AliasMap.Slider, Text = "      Movement Prediction (0-100)", ExpandHandle = "ModMenu_AT_Sniper_Ex", MinValue = 0, MaxValue = 100, min = 0, max = 100, GetFunc = function() return _G.GTLMODState.CustomTextData.AimTouchSniperPred or 0 end, SetFunc = function(c,v) _G.GTLMODState.CustomTextData.AimTouchSniperPred = v return true end }
        }

        -- ==================== COMBAT GRAPHIC (SECTION 3) ====================
        local StackCombatGraphic = {
            { Key = "ModMenu_Ipad_Ex", UI = AliasMap.TitleSwitcher, Text = "CUSTOM IPAD VIEW", ExpandIndex = 0, GetFunc = function() return _G.GTLMODConfig.IpadView end, SetFunc = function(c,v) _G.GTLMODConfig.IpadView = v return true end },
            { Key = "ModMenu_Ipad_FOV", UI = AliasMap.Slider, Text = "   IPAD FOV (1-100)", ExpandHandle = "ModMenu_Ipad_Ex", MinValue = 1, MaxValue = 100, min = 1, max = 100, GetFunc = function() return (_G.GTLMODState.CustomTextData.IpadViewFOV or 120) - 80 end, SetFunc = function(c,v) _G.GTLMODState.CustomTextData.IpadViewFOV = 80 + v return true end },
            { Key = "ModMenu_165FPS", UI = AliasMap.Switcher, Text = "165 REAL FPS", GetFunc = function() return _G.GTLMODConfig.UnlockFPS end, SetFunc = function(c,v) _G.GTLMODConfig.UnlockFPS = v; if v then _G.GTLMODState.GraphicsUnlocked = false end return true end },
            { Key = "ModMenu_WallColor", UI = AliasMap.Switcher, Text = "WALLHACK + COLOR", GetFunc = function() return _G.GTLMODConfig.wallhackng end, SetFunc = function(c,v) _G.GTLMODConfig.wallhackng = v; _G.GTLMODConfig.ColorBodyV2 = v return true end },
            { Key = "ModMenu_BlackSky", UI = AliasMap.Switcher, Text = "BLACK SKY", GetFunc = function() return _G.GTLMODConfig.BlackSky end, SetFunc = function(c,v) _G.GTLMODConfig.BlackSky = v return true end },
            { Key = "ModMenu_RemoveFog", UI = AliasMap.Switcher, Text = "REMOVE FOG", GetFunc = function() return _G.GTLMODConfig.RemoveFog end, SetFunc = function(c,v) _G.GTLMODConfig.RemoveFog = v return true end },
            
        }

        -- ==================== SKIN MOD (SECTION 4) ====================
        local StackSkinMod = {
            { Key = "ModMenu_Skin_Ex", UI = AliasMap.TitleSwitcher, Text = "VIP MOD SKINS ACTIVATED", ExpandIndex = 0, GetFunc = function() return _G.GTLMODConfig.ModSkin end, SetFunc = function(c,v) _G.GTLMODConfig.ModSkin = v return true end },
            { Key = "ModMenu_Skin_Suit", UI = AliasMap.Slider, Text = "   ALL X SUITS ", ExpandHandle = "ModMenu_Skin_Ex", MinValue = 1, MaxValue = 80, GetFunc = function() return _G.GTLMODState.CustomTextData.SkinSuit or 1 end, SetFunc = function(c,v) _G.GTLMODState.CustomTextData.SkinSuit = v; if _G.OutfitSkins and _G.OutfitSkins.Suit[v] then _G.OutfitMap.Suit = _G.OutfitSkins.Suit[v] end return true end },
            { Key = "ModMenu_Skin_Bag", UI = AliasMap.Slider, Text = "   ALL BAG SKINS (1-16)", ExpandHandle = "ModMenu_Skin_Ex", MinValue = 1, MaxValue = 16, GetFunc = function() return _G.GTLMODState.CustomTextData.SkinBag or 1 end, SetFunc = function(c,v) _G.GTLMODState.CustomTextData.SkinBag = v; if _G.OutfitSkins and _G.OutfitSkins.Bag[v] then _G.OutfitMap.Bag = _G.OutfitSkins.Bag[v] end return true end },
            { Key = "ModMenu_Skin_Helmet", UI = AliasMap.Slider, Text = "   ALL HELMET SKINS (1-12)", ExpandHandle = "ModMenu_Skin_Ex", MinValue = 1, MaxValue = 12, GetFunc = function() return _G.GTLMODState.CustomTextData.SkinHelmet or 1 end, SetFunc = function(c,v) _G.GTLMODState.CustomTextData.SkinHelmet = v; if _G.OutfitSkins and _G.OutfitSkins.Helmet[v] then _G.OutfitMap.Helmet = _G.OutfitSkins.Helmet[v] end return true end },
            { Key = "ModMenu_Skin_M416", UI = AliasMap.Slider, Text = "   M416 (1-9)", ExpandHandle = "ModMenu_Skin_Ex", MinValue = 1, MaxValue = 9, GetFunc = function() return _G.GTLMODState.CustomTextData.SkinM416 or 1 end, SetFunc = function(c,v) _G.GTLMODState.CustomTextData.SkinM416 = v; if _G.skinIdMappings[101004] and _G.skinIdMappings[101004][v] then _G.WeaponSkinMap[101004] = _G.skinIdMappings[101004][v] end return true end },
            { Key = "ModMenu_Skin_AKM", UI = AliasMap.Slider, Text = "   AKM (1-8)", ExpandHandle = "ModMenu_Skin_Ex", MinValue = 1, MaxValue = 8, GetFunc = function() return _G.GTLMODState.CustomTextData.SkinAKM or 1 end, SetFunc = function(c,v) _G.GTLMODState.CustomTextData.SkinAKM = v; if _G.skinIdMappings[101001] and _G.skinIdMappings[101001][v] then _G.WeaponSkinMap[101001] = _G.skinIdMappings[101001][v] end return true end },
            { Key = "ModMenu_Skin_SCAR", UI = AliasMap.Slider, Text = "   SCAR-L (1-8)", ExpandHandle = "ModMenu_Skin_Ex", MinValue = 1, MaxValue = 8, GetFunc = function() return _G.GTLMODState.CustomTextData.SkinSCAR or 1 end, SetFunc = function(c,v) _G.GTLMODState.CustomTextData.SkinSCAR = v; if _G.skinIdMappings[101003] and _G.skinIdMappings[101003][v] then _G.WeaponSkinMap[101003] = _G.skinIdMappings[101003][v] end return true end },
            { Key = "ModMenu_Skin_M762", UI = AliasMap.Slider, Text = "   M762 (1-8)", ExpandHandle = "ModMenu_Skin_Ex", MinValue = 1, MaxValue = 8, GetFunc = function() return _G.GTLMODState.CustomTextData.SkinM762 or 1 end, SetFunc = function(c,v) _G.GTLMODState.CustomTextData.SkinM762 = v; if _G.skinIdMappings[101008] and _G.skinIdMappings[101008][v] then _G.WeaponSkinMap[101008] = _G.skinIdMappings[101008][v] end return true end },
            { Key = "ModMenu_Skin_AUG", UI = AliasMap.Slider, Text = "   AUG (1-7)", ExpandHandle = "ModMenu_Skin_Ex", MinValue = 1, MaxValue = 7, GetFunc = function() return _G.GTLMODState.CustomTextData.SkinAUG or 1 end, SetFunc = function(c,v) _G.GTLMODState.CustomTextData.SkinAUG = v; if _G.skinIdMappings[101006] and _G.skinIdMappings[101006][v] then _G.WeaponSkinMap[101006] = _G.skinIdMappings[101006][v] end return true end },
            { Key = "ModMenu_Skin_UMP", UI = AliasMap.Slider, Text = "   UMP45 (1-6)", ExpandHandle = "ModMenu_Skin_Ex", MinValue = 1, MaxValue = 6, GetFunc = function() return _G.GTLMODState.CustomTextData.SkinUMP or 1 end, SetFunc = function(c,v) _G.GTLMODState.CustomTextData.SkinUMP = v; if _G.skinIdMappings[102002] and _G.skinIdMappings[102002][v] then _G.WeaponSkinMap[102002] = _G.skinIdMappings[102002][v] end return true end },
            { Key = "ModMenu_Skin_UZI", UI = AliasMap.Slider, Text = "   UZI (1-2)", ExpandHandle = "ModMenu_Skin_Ex", MinValue = 1, MaxValue = 2, GetFunc = function() return _G.GTLMODState.CustomTextData.SkinUZI or 1 end, SetFunc = function(c,v) _G.GTLMODState.CustomTextData.SkinUZI = v; if _G.skinIdMappings[102001] and _G.skinIdMappings[102001][v] then _G.WeaponSkinMap[102001] = _G.skinIdMappings[102001][v] end return true end },
            { Key = "ModMenu_Skin_Groza", UI = AliasMap.Slider, Text = "   GROZA (1-2)", ExpandHandle = "ModMenu_Skin_Ex", MinValue = 1, MaxValue = 2, GetFunc = function() return _G.GTLMODState.CustomTextData.SkinGroza or 1 end, SetFunc = function(c,v) _G.GTLMODState.CustomTextData.SkinGroza = v; if _G.skinIdMappings[101005] and _G.skinIdMappings[101005][v] then _G.WeaponSkinMap[101005] = _G.skinIdMappings[101005][v] end return true end },
            { Key = "ModMenu_Skin_Kar98K", UI = AliasMap.Slider, Text = "   Kar98K (1-3)", ExpandHandle = "ModMenu_Skin_Ex", MinValue = 1, MaxValue = 3, GetFunc = function() return _G.GTLMODState.CustomTextData.SkinKar98K or 1 end, SetFunc = function(c,v) _G.GTLMODState.CustomTextData.SkinKar98K = v; if _G.skinIdMappings[103001] and _G.skinIdMappings[103001][v] then _G.WeaponSkinMap[103001] = _G.skinIdMappings[103001][v] end return true end },
            { Key = "ModMenu_Skin_AWM", UI = AliasMap.Slider, Text = "   AWM (1-4)", ExpandHandle = "ModMenu_Skin_Ex", MinValue = 1, MaxValue = 4, GetFunc = function() return _G.GTLMODState.CustomTextData.SkinAWM or 1 end, SetFunc = function(c,v) _G.GTLMODState.CustomTextData.SkinAWM = v; if _G.skinIdMappings[103003] and _G.skinIdMappings[103003][v] then _G.WeaponSkinMap[103003] = _G.skinIdMappings[103003][v] end return true end },
            { Key = "ModMenu_Skin_AMR", UI = AliasMap.Slider, Text = "   AMR (1-3)", ExpandHandle = "ModMenu_Skin_Ex", MinValue = 1, MaxValue = 3, GetFunc = function() return _G.GTLMODState.CustomTextData.SkinAMR or 1 end, SetFunc = function(c,v) _G.GTLMODState.CustomTextData.SkinAMR = v; if _G.skinIdMappings[103012] and _G.skinIdMappings[103012][v] then _G.WeaponSkinMap[103012] = _G.skinIdMappings[103012][v] end return true end },
            { Key = "ModMenu_Skin_S12K", UI = AliasMap.Slider, Text = "   S12K (1-2)", ExpandHandle = "ModMenu_Skin_Ex", MinValue = 1, MaxValue = 2, GetFunc = function() return _G.GTLMODState.CustomTextData.SkinS12K or 1 end, SetFunc = function(c,v) _G.GTLMODState.CustomTextData.SkinS12K = v; if _G.skinIdMappings[104003] and _G.skinIdMappings[104003][v] then _G.WeaponSkinMap[104003] = _G.skinIdMappings[104003][v] end return true end },
            { Key = "ModMenu_Skin_DBS", UI = AliasMap.Slider, Text = "   DBS (1-3)", ExpandHandle = "ModMenu_Skin_Ex", MinValue = 1, MaxValue = 3, GetFunc = function() return _G.GTLMODState.CustomTextData.SkinDBS or 1 end, SetFunc = function(c,v) _G.GTLMODState.CustomTextData.SkinDBS = v; if _G.skinIdMappings[104004] and _G.skinIdMappings[104004][v] then _G.WeaponSkinMap[104004] = _G.skinIdMappings[104004][v] end return true end },
            { Key = "ModMenu_Skin_Dacia", UI = AliasMap.Slider, Text = "   DACIA (1-90)", ExpandHandle = "ModMenu_Skin_Ex", MinValue = 1, MaxValue = 90, GetFunc = function() return _G.GTLMODState.CustomTextData.SkinDacia or 1 end, SetFunc = function(c,v) _G.GTLMODState.CustomTextData.SkinDacia = v; if _G.VehicleSkins[1903001] and _G.VehicleSkins[1903001][v] then _G.VehicleSkinMap[1903001] = _G.VehicleSkins[1903001][v] end return true end },
            { Key = "ModMenu_Skin_UAZ", UI = AliasMap.Slider, Text = "   UAZ (1-90)", ExpandHandle = "ModMenu_Skin_Ex", MinValue = 1, MaxValue = 90, GetFunc = function() return _G.GTLMODState.CustomTextData.SkinUAZ or 1 end, SetFunc = function(c,v) _G.GTLMODState.CustomTextData.SkinUAZ = v; if _G.VehicleSkins[1908001] and _G.VehicleSkins[1908001][v] then _G.VehicleSkinMap[1908001] = _G.VehicleSkins[1908001][v] end return true end },
            { Key = "ModMenu_Skin_Coupe", UI = AliasMap.Slider, Text = "   COUPE RB (1-70)", ExpandHandle = "ModMenu_Skin_Ex", MinValue = 1, MaxValue = 70, GetFunc = function() return _G.GTLMODState.CustomTextData.SkinCoupe or 1 end, SetFunc = function(c,v) _G.GTLMODState.CustomTextData.SkinCoupe = v; if _G.VehicleSkins[1961001] and _G.VehicleSkins[1961001][v] then _G.VehicleSkinMap[1961001] = _G.VehicleSkins[1961001][v] end return true end },
            { Key = "ModMenu_Skin_Buggy", UI = AliasMap.Slider, Text = "   BUGGY (1-50)", ExpandHandle = "ModMenu_Skin_Ex", MinValue = 1, MaxValue = 50, GetFunc = function() return _G.GTLMODState.CustomTextData.SkinBuggy or 1 end, SetFunc = function(c,v) _G.GTLMODState.CustomTextData.SkinBuggy = v; if _G.VehicleSkins[1907001] and _G.VehicleSkins[1907001][v] then _G.VehicleSkinMap[1907001] = _G.VehicleSkins[1907001][v] end return true end },
            { Key = "ModMenu_Skin_Mirado", UI = AliasMap.Slider, Text = "   MIRADO (1-27)", ExpandHandle = "ModMenu_Skin_Ex", MinValue = 1, MaxValue = 27, GetFunc = function() return _G.GTLMODState.CustomTextData.SkinMirado or 1 end, SetFunc = function(c,v) _G.GTLMODState.CustomTextData.SkinMirado = v; if _G.VehicleSkins[1915001] and _G.VehicleSkins[1915001][v] then _G.VehicleSkinMap[1915001] = _G.VehicleSkins[1915001][v] end return true end }
        }

        -- ==================== DEFINE MENU PAGE (ORDER: ESP → AIMBOT → COMBAT → SKIN) ====================
        SettingPageDefine.ModMenu = {
            Key = "ModMenu",
            Text= "♛ VIP MENU ♛ @HAMSECHEATS",
            UIKey = "Setting_Page_Privacy", 
            Category = {
                { Key = "Cat_ESP_Visual", Text= "♛ ESP ♛", Stack = StackESPVisual },
                { Key = "Cat_Aimbot_Force", Text= "♛AIMBOT♛", Stack = StackAimbotForce },
                { Key = "Cat_Combat_Graphic", Text= "♛EXTRA COMBO♛", Stack = StackCombatGraphic },
                { Key = "Cat_SkinMod", Text= "♛ALL SKIN♛", Stack = StackSkinMod }
            }
        }
        
        table.insert(SettingCatalog, SettingPageDefine.ModMenu)
    end

    local UIManager = _G.UIManager
    if UIManager and not UIManager._IsModMenuHooked then
        local old_ShowUI = UIManager.ShowUI
        UIManager.ShowUI = function(config, ...)
            local args = {...}
            local n = select('#', ...) 
            
            if config and config.keyName and (string.find(string.lower(config.keyName), "setting_main") or string.find(string.lower(config.keyName), "setting")) then
                local catalog = args[1]
                if type(catalog) == "table" then
                    local hasModMenu = false
                    for _, page in ipairs(catalog) do
                        if type(page) == "table" and page.Key == "ModMenu" then
                            hasModMenu = true
                            break
                        end
                    end
                    if not hasModMenu then
                        table.insert(catalog, SettingPageDefine.ModMenu)
                    end
                end
            end
            local table_unpack = table.unpack or unpack
            return old_ShowUI(config, table_unpack(args, 1, n))
        end
        UIManager._IsModMenuHooked = true
    end
end

local function ShowGTLMODVIPMenu() 
    if _G.GTLMODMenuAlreadyShown then return end
    if _G.GTLMODState.MenuStep ~= 0 then return end

    pcall(function()
        local Msg = require("client.slua.logic.common.logic_common_msg_box")
        if not Msg or not Msg.Show then return end

        local function Step_ScamAlert()
            Msg.Show(1, "♛VIP MOD PAK @HAMSECHEATS♛", "➜ WELCOME TO @HAMSECHEATS VIP MOD PAK FILE\n\nMANUAL SUPPORT ONLY - NO AUTO FEEDBACK\n\n➜ CONTACT: @HAMSECHEATS", function() local Web = require("client.slua.logic.url.logic_webview_sdk"); if Web and Web.OpenURL then Web:OpenURL("https://t.me/HAMSECHEATS") end end, function() end, "JOIN", "CLOSE")
            _G.GTLMODState.MenuStep = 99
            _G.GTLMODMenuAlreadyShown = true
        end

        local function Step_Welcome()
            Msg.Show(1, "♛WELCOME @HAMSECHEATS♛", "➜WELCOME TO @HAMSECHEATS VIP MOD PAK FILE\n\n♛ACTIVATION SUCCESSFUL!\n\nENJOY YOUR VIP ACCESS.\nTHE REAL OWNER IS @HAMSECHEATS\n\nCONTACT: @HAMSECHEATS",
            function() 
                _G.InitModMenuTab()
                Notify("VIP MOD PAK BY @HAMSECHEATS - TOGGLE FEATURES!")
                Step_ScamAlert()
            end, 
            function() end, "OK", "CLOSE")
        end

        _G.GTLMODState.MenuStep = 1
        Step_Welcome() 
    end)
end

-- ========================================== 
-- LOGIC 165 FPS IPAD VIEW 
-- ========================================== 
local function InitializeGraphicsUnlock() 
    if isExpired then return end
    if _G.GTLMODState.GraphicsUnlocked then return end

    pcall(function()
        local SettingCfg = require("client.logic.setting.setting_config")
        local GraphicSettingDB = require("client.slua.umg.NewSetting.GraphicsNew.GraphicSettingDB")
        if SettingCfg then
            if SettingCfg.TpViewValue then SettingCfg.TpViewValue.max = 160 end
            if SettingCfg.FpViewValue then SettingCfg.FpViewValue.max = 160 end
        end
        if GraphicSettingDB then
            if GraphicSettingDB.TpViewValue then GraphicSettingDB.TpViewValue.max = 160 end
        end
    end)

    pcall(function()
        local logic_setting_graphics = require("client.slua.logic.setting.logic_setting_graphics")
        local GSC_FPS = require("client.slua.umg.NewSetting.GraphicsNew.Comps.GSC_FPS")
        local GSC_FPSFT = require("client.slua.umg.NewSetting.GraphicsNew.Comps.GSC_FPSFT")
        local GraphicSettingDB = require("client.slua.umg.NewSetting.GraphicsNew.GraphicSettingDB")
        
        local KismetMathLibrary = import("KismetMathLibrary") or _G.KismetMathLibrary
        local FLinearColor = import("LinearColor") or _G.FLinearColor

        if logic_setting_graphics then
            local old_SetFPS = logic_setting_graphics.SetFPS
            function logic_setting_graphics.SetFPS(gameInstance, FPSLevel)
                if old_SetFPS then old_SetFPS(gameInstance, FPSLevel) end
                if FPSLevel == 8 then 
                    gameInstance:ExecuteCMD("t.MaxFPS", "165")
                    gameInstance:ExecuteCMD("r.FrameRateLimit", "165")
                end
            end
        end

        if GSC_FPS and GSC_FPS.__inner_impl then
            local fps_impl = GSC_FPS.__inner_impl
            function fps_impl:GetMaxFPSLevel() return 8, 8 end
            function fps_impl:InitRealSupportFPS()
                local RealSupportFPS = {}
                for i = 1, 8 do RealSupportFPS[i] = {true, true} end
                if GraphicSettingDB then GraphicSettingDB:UpdateUIData(GraphicSettingDB.RealSupportFPS, RealSupportFPS, false) end
                return RealSupportFPS
            end
            function fps_impl:UpdateSelectedFPSState(selectedLevel)
                if not slua.isValid(self.UIRoot) then return end
                for level = 2, 8 do
                    local name = "NodeFps" .. (({[2]=20,[3]=25,[4]=30,[5]=40,[6]=60,[7]=90,[8]=120})[level] or 120)
                    local widget = self.UIRoot[name]
                    if slua.isValid(widget) then
                        widget:SetIsEnabled(true) 
                        pcall(function() widget:SetRenderOpacity(1.0) end)
                        local switcher = self.UIRoot["WidgetSwitcher_" .. level]
                        if slua.isValid(switcher) then 
                            switcher:SetActiveWidgetIndex(level == selectedLevel and 0 or 1) 
                        end
                    end
                end
            end
        end

        if GSC_FPSFT and GSC_FPSFT.__inner_impl then
            local ft_impl = GSC_FPSFT.__inner_impl
            local NMinFPS, NStep = 90, 5
            local function clamp(value, min, max)
                if value < min then return min end
                if max < value then return max end
                return value
            end
            local function lerp(a, b, t) return a + (b - a) * t end
            local function _getColorByPercent(start, finish, percent)
                if not FLinearColor then return nil end
                return FLinearColor(lerp(start.R, finish.R, percent), lerp(start.G, finish.G, percent), lerp(start.B, finish.B, percent), lerp(start.A, finish.A, percent))
            end
            
            ft_impl.ShowOrHide = function(self)
                self:SelfHitTestInvisible()
                if self.InitFPSFTSwitch then self:InitFPSFTSwitch() end
            end

            ft_impl.InitFPSFTSwitch = function(self)
                local FPSFineTuneSwitch = GraphicSettingDB:GetUIData(GraphicSettingDB.FPSFineTuneSwitch)
                if self.UIRoot.Setting_Switch then self.UIRoot.Setting_Switch:SetSwitcherEnable2(FPSFineTuneSwitch, true) end
                if self.UIRoot.CanvasPanel_8 then self:SetWidgetVisible(self.UIRoot.CanvasPanel_8, FPSFineTuneSwitch) end
                if self.UIRoot.WidgetSwitcher_0 then self.UIRoot.WidgetSwitcher_0:SetActiveWidgetIndex(2) end
                if self.InitFPSFTValue165 then self:InitFPSFTValue165() end
            end

            ft_impl.InitFPSFTValue165 = function(self)
                local itemRoot = self.UIRoot
                local FPSFineTuneSwitch = GraphicSettingDB:GetUIData(GraphicSettingDB.FPSFineTuneSwitch)
                local FPSFineTuneNum = 165
                if FPSFineTuneSwitch then
                    FPSFineTuneNum = GraphicSettingDB:GetUIData(GraphicSettingDB.FPSFineTuneNum) or 165
                    itemRoot.Slider_screen3:SetLocked(false)
                    if FLinearColor then
                        itemRoot.ProgressBar_screen3:SetFillColorAndOpacity(FLinearColor(1.0, 1.0, 1.0, 1.0))
                        itemRoot.Slider_screen3:SetSliderHandleColor(FLinearColor(1.0, 1.0, 1.0, 1.0))
                    end
                else
                    itemRoot.Slider_screen3:SetLocked(true)
                    if FLinearColor then
                        itemRoot.ProgressBar_screen3:SetFillColorAndOpacity(FLinearColor(1.0, 0.625, 0.6, 1))
                        itemRoot.Slider_screen3:SetSliderHandleColor(FLinearColor(1.0, 0.625, 0.6, 1.0))
                    end
                end
                local FPSFineTunePer = (FPSFineTuneNum - NMinFPS) / (165 - NMinFPS)
                
                itemRoot.Veihclescreen3:SetText(tostring(FPSFineTuneNum))
                itemRoot.Slider_screen3:SetValue(FPSFineTunePer)
                itemRoot.ProgressBar_screen3:SetPercent(FPSFineTunePer)
                
                if FLinearColor then
                    local startColor = FLinearColor(1.0, 1.0, 1.0, 1.0)
                    local midColor = FLinearColor(1.0, 0.54, 0.11, 1.0)
                    local endColor = FLinearColor(1.0, 0.23, 0.15, 1.0)
                    local sliderColor = FPSFineTunePer < 0.4 and startColor or _getColorByPercent(midColor, endColor, (FPSFineTunePer - 0.4) / 0.6)
                    itemRoot.Slider_screen3:SetSliderHandleColor(sliderColor)
                end
            end

            ft_impl.OnFPSFTValueChange3 = function(self, FPSFineTuneNum)
                GraphicSettingDB:UpdateUIData(GraphicSettingDB.FPSFineTuneNum, FPSFineTuneNum)
                if self.InitFPSFTValue165 then self:InitFPSFTValue165() end
                if self:GetParentUI() then self:GetParentUI():SetDirty(true) end
                local gameInstance = GraphicSettingDB.GetGameInstance and GraphicSettingDB.GetGameInstance()
                if gameInstance then
                    gameInstance:ExecuteCMD("t.MaxFPS", tostring(FPSFineTuneNum))
                    gameInstance:ExecuteCMD("r.FrameRateLimit", tostring(FPSFineTuneNum))
                end
            end

            ft_impl.OnFPSFTSliderValueChange3 = function(self, value)
                if GraphicSettingDB:GetUIData(GraphicSettingDB.FPSFineTuneSwitch) and KismetMathLibrary then
                    local FPSFineTuneNum = KismetMathLibrary.FCeil(value * (165 - NMinFPS) / NStep) * NStep + NMinFPS
                    self:OnFPSFTValueChange3(clamp(FPSFineTuneNum, NMinFPS, 165))
                end
            end
            
            ft_impl.OnFPSFTAdd = ft_impl.OnFPSFTAdd3
            ft_impl.OnFPSFTMinus = ft_impl.OnFPSFTMinus3
            ft_impl.OnFPSFTAdd2 = ft_impl.OnFPSFTAdd3
            ft_impl.OnFPSFTMinus2 = ft_impl.OnFPSFTMinus3
            ft_impl.OnFPSFTSliderValueChange = ft_impl.OnFPSFTSliderValueChange3
            ft_impl.OnFPSFTSliderValueChange2 = ft_impl.OnFPSFTSliderValueChange3
        end
    end)
    _G.GTLMODState.GraphicsUnlocked = true
    Notify("Graphics & FPS 165Hz Unlocked")
end

-- ==========================================
-- AK_GetVal: Maps ESP keys to GTLMODConfig
-- ==========================================
_G.AK_GetVal = function(key)
    local cfg = _G.GTLMODConfig
    if not cfg then return 0 end
    if key == "ESP_BOX"        then return cfg.Esp5 and 1 or 0 end
    if key == "ESP_NAME"       then return cfg.EspName and 1 or 0 end
    if key == "ESP_HEALTH"     then return cfg.EspVip and 1 or 0 end
    if key == "ESP_HEALTH_POS" then return 1 end  -- bottom position
    if key == "ESP_DISTANCE"   then return cfg.EspDistance and 1 or 0 end
    if key == "ESP_LINE"       then return cfg.Esp6 and 1 or 0 end
    if key == "ESP_FULL_INFO"  then return cfg.EspVipPro and 1 or 0 end
    if key == "ESP_TEAMID"     then return cfg.Esp7 and 1 or 0 end
    if key == "ESP_WEAPON"     then return cfg.Esp8 and 1 or 0 end
    if key == "ESP_COUNT_BOX"  then return cfg.EspRadar and 1 or 0 end
    if key == "ESP_CAR"        then return 0 end
    if key == "ESP_BOMB"       then return 0 end
    if key == "ESP_ITEM"       then return 0 end
    return 0
end

-- ==========================================
-- AK ESP VIP SYSTEM (NEW)
-- ==========================================
function _G.InitAKESPVIP()
    if _G.AK_ESP_VIP_Init then return end
    _G.AK_ESP_VIP_Init = true

    if _G.AK_PlayerMapMarker and type(_G.AK_PlayerMapMarker.Stop) == "function" then
        pcall(function() _G.AK_PlayerMapMarker.Stop() end)
        pcall(function() _G.AK_PlayerMapMarker.ClearAllMarks() end)
        _G.AK_PlayerMapMarker.bActive = false
    end
    if _G.AK_RedBoxOverlay and type(_G.AK_RedBoxOverlay.Stop) == "function" then
        pcall(function() _G.AK_RedBoxOverlay.Stop() end)
    end
    
    local AK_PlayerMapMarker = {}

    local AK_RedBoxOverlay = {
        bActive = false,
        MainContainer = nil,
        WidgetSlot = nil,
        TextBlock = nil,
        Width = 300,
        Height = 23,           
        OffsetY = 10,          
        PlayerCount = 0,
        BotCount = 0,
        NearCount = 0,
        FontSize = 16,          
        TextScaleValue = 0.8,   
        NumLayers = 50,
        Red = 1.0,
        Green = 0.0,
        Blue = 0.0,
        LayerAlpha = 0.038,
        _CachedText = "",
        _CachedPosVec = nil
    }

    function AK_RedBoxOverlay.Create()
        if AK_RedBoxOverlay.MainContainer and slua.isValid(AK_RedBoxOverlay.MainContainer) then return true end

        local ParentCanvas = AK_PlayerMapMarker.ESPCanvas
        if not ParentCanvas or not slua.isValid(ParentCanvas) then 
            if not AK_PlayerMapMarker.InitESPCanvas() then return false end
            ParentCanvas = AK_PlayerMapMarker.ESPCanvas
        end

        local Container = nil
        pcall(function() Container = CGame:NewObjectFromPath("/Script/UMG.CanvasPanel", ParentCanvas) end)
        if not Container or not slua.isValid(Container) then return false end

        local FLinearColor = import("LinearColor") or _G.FLinearColor
        local FVector2D = import("Vector2D") or _G.FVector2D
        local color = FLinearColor(AK_RedBoxOverlay.Red, AK_RedBoxOverlay.Green, AK_RedBoxOverlay.Blue, AK_RedBoxOverlay.LayerAlpha)

        local numLayers = AK_RedBoxOverlay.NumLayers
        local totalWidth = AK_RedBoxOverlay.Width

        for i = 1, numLayers do
            local progress = (i / numLayers) ^ 1.15
            local layerWidth = progress * totalWidth
            local layerX = (totalWidth - layerWidth) / 2.0

            local border = nil
            pcall(function() border = CGame:NewObjectFromPath("/Script/UMG.Border", Container) end)
            if border and slua.isValid(border) then
                pcall(function() border:SetBrushColor(color); border:SetWidgetVisibility(UEnums.ESlateVisibility.SelfHitTestInvisible) end)
                local slot = Container:AddChildToCanvas(border)
                if slot then slot:SetPosition(FVector2D(layerX, 0)); slot:SetSize(FVector2D(layerWidth, AK_RedBoxOverlay.Height)) end
            end
        end

        local txtWidget = nil
        pcall(function() txtWidget = CGame:NewObjectFromPath("/Script/UMG.TextBlock", Container) end)

        if txtWidget and slua.isValid(txtWidget) then
            pcall(function()
                local strText = "PLAYER: " .. tostring(AK_RedBoxOverlay.PlayerCount) .. "   BOT: " .. tostring(AK_RedBoxOverlay.BotCount) .. "   400M: " .. tostring(AK_RedBoxOverlay.NearCount)
                txtWidget:SetText(strText)
                AK_RedBoxOverlay._CachedText = strText
                local FSlateColor = import("SlateColor") or import("/Script/SlateCore.SlateColor")
                if FSlateColor then txtWidget:SetColorAndOpacity(FSlateColor(FLinearColor(1, 1, 1, 1))) else txtWidget:SetColorAndOpacity(FLinearColor(1, 1, 1, 1)) end
                if txtWidget.Font then local font = txtWidget.Font; font.Size = AK_RedBoxOverlay.FontSize; txtWidget.Font = font end
                txtWidget:SetRenderScale(FVector2D(AK_RedBoxOverlay.TextScaleValue, AK_RedBoxOverlay.TextScaleValue))
                txtWidget:SetRenderTransformPivot(FVector2D(0.5, 0.5))
                txtWidget:SetWidgetVisibility(UEnums.ESlateVisibility.SelfHitTestInvisible)
            end)
            local txtSlot = Container:AddChildToCanvas(txtWidget)
            if txtSlot then
                pcall(function() txtSlot:SetAutoSize(true); txtSlot:SetAlignment(FVector2D(0.5, 0.5)); txtSlot:SetPosition(FVector2D(totalWidth * 0.5, AK_RedBoxOverlay.Height * 0.5)); txtSlot:SetZOrder(1000) end)
            end
            AK_RedBoxOverlay.TextBlock = txtWidget
        end

        local MainSlot = nil
        pcall(function() MainSlot = ParentCanvas:AddChildToCanvas(Container) end)
        if not MainSlot then return false end

        AK_RedBoxOverlay.MainContainer = Container
        AK_RedBoxOverlay.WidgetSlot = MainSlot
        
        pcall(function() MainSlot:SetAutoSize(false); MainSlot:SetZOrder(999); MainSlot:SetAlignment(FVector2D(0.5, 0.0)); MainSlot:SetSize(FVector2D(AK_RedBoxOverlay.Width, AK_RedBoxOverlay.Height)) end)
        AK_RedBoxOverlay.UpdatePosition()
        return true
    end

    function AK_RedBoxOverlay.SetCounts(players, bots, near400)
        if AK_RedBoxOverlay.PlayerCount == players and AK_RedBoxOverlay.BotCount == bots and AK_RedBoxOverlay.NearCount == near400 then
            return
        end
        AK_RedBoxOverlay.PlayerCount = players or 0
        AK_RedBoxOverlay.BotCount = bots or 0
        AK_RedBoxOverlay.NearCount = near400 or 0
        
        if AK_RedBoxOverlay.TextBlock and slua.isValid(AK_RedBoxOverlay.TextBlock) then
            pcall(function()
                local strText = "PLAYER: " .. tostring(AK_RedBoxOverlay.PlayerCount) .. "   BOT: " .. tostring(AK_RedBoxOverlay.BotCount) .. "   400M: " .. tostring(AK_RedBoxOverlay.NearCount)
                if AK_RedBoxOverlay._CachedText ~= strText then
                    AK_RedBoxOverlay.TextBlock:SetText(strText)
                    AK_RedBoxOverlay._CachedText = strText
                end
            end)
        end
    end

    function AK_RedBoxOverlay.UpdatePosition()
        local Slot = AK_RedBoxOverlay.WidgetSlot
        if not Slot or not slua.isValid(Slot) then return end

        local PC = AK_PlayerMapMarker.GetMyPlayerController()
        if not slua.isValid(PC) then return end

        local fromX, fromY = AK_PlayerMapMarker.GetSnapLineStartPos(PC)

        pcall(function()
            if not AK_RedBoxOverlay._CachedPosVec then
                AK_RedBoxOverlay._CachedPosVec = import("Vector2D")(fromX, fromY)
            else
                AK_RedBoxOverlay._CachedPosVec.X = fromX
                AK_RedBoxOverlay._CachedPosVec.Y = fromY
            end
            Slot:SetPosition(AK_RedBoxOverlay._CachedPosVec)
        end)
    end

    function AK_RedBoxOverlay.Start()
        if AK_RedBoxOverlay.bActive and AK_RedBoxOverlay.MainContainer and slua.isValid(AK_RedBoxOverlay.MainContainer) then return end
        if AK_RedBoxOverlay.Create() then
            AK_RedBoxOverlay.bActive = true
            pcall(function()
                AK_RedBoxOverlay.MainContainer:SetWidgetVisibility(UEnums.ESlateVisibility.SelfHitTestInvisible)
            end)
        end
    end

    function AK_RedBoxOverlay.Stop()
        AK_RedBoxOverlay.bActive = false
        if AK_RedBoxOverlay.MainContainer and slua.isValid(AK_RedBoxOverlay.MainContainer) then
            pcall(function()
                AK_RedBoxOverlay.MainContainer:RemoveFromParent()
                AK_RedBoxOverlay.MainContainer:ConditionalBeginDestroy()
            end)
        end
        AK_RedBoxOverlay.MainContainer = nil
        AK_RedBoxOverlay.WidgetSlot = nil
        AK_RedBoxOverlay.TextBlock = nil
        AK_RedBoxOverlay._CachedPosVec = nil
    end

    _G.AK_RedBoxOverlay = AK_RedBoxOverlay

    local InGameMarkTools = require("GameLua.Mod.BaseMod.Common.InGameMarkTools")

    local SlateBlueprintLibrary = nil
    local WidgetLayoutLibrary = nil
    local KismetMathLibrary = nil
    local KismetSystemLibrary = nil

    pcall(function() SlateBlueprintLibrary = import("SlateBlueprintLibrary") or import("/Script/UMG.SlateBlueprintLibrary") end)
    pcall(function() WidgetLayoutLibrary = import("WidgetLayoutLibrary") or import("/Script/UMG.WidgetLayoutLibrary") end)
    pcall(function() KismetMathLibrary = import("KismetMathLibrary") end)
    pcall(function() KismetSystemLibrary = import("KismetSystemLibrary") end)

    AK_PlayerMapMarker.MarkTypeID = 1007
    AK_PlayerMapMarker.bUseScreenESP = true
    AK_PlayerMapMarker.bUseScreenMark = false
    AK_PlayerMapMarker.bUseQuickSign = false
    AK_PlayerMapMarker.bUseNavigator = false
    AK_PlayerMapMarker.bUseWidgetComponent = false
    AK_PlayerMapMarker.QuickSignConfigKey = "C_MarkPos"

    AK_PlayerMapMarker.WidgetCompUIPath = "/Game/BluePrints/ControlInput/NewbieItem/NewbieTips_ConsumeTips.NewbieTips_ConsumeTips"
    AK_PlayerMapMarker.WidgetCompBoneName = "head"
    AK_PlayerMapMarker.WidgetCompOffset = FVector(0, 0, 80)
    AK_PlayerMapMarker.WidgetCompDrawSize = FVector2D(300, 50)

    AK_PlayerMapMarker.ESPBoneName = "head"
    AK_PlayerMapMarker.ESPWorldOffsetZ = 0
    AK_PlayerMapMarker.ESPScreenOffsetY = 0

    AK_PlayerMapMarker.ESPAnchorOffsetX = 50
    AK_PlayerMapMarker.ESPAnchorOffsetY = 0
    AK_PlayerMapMarker.ESPTextOffsetX = 0
    AK_PlayerMapMarker.ESPTextOffsetY = 0

    AK_PlayerMapMarker.ESPWidgetAlignment = FVector2D(0.5, 1.0)
    AK_PlayerMapMarker.ESPWidgetSize = FVector2D(100, 30)
    AK_PlayerMapMarker.ESPWidgetAutoSize = true
    AK_PlayerMapMarker.ESPWidgetZOrder = 2

    AK_PlayerMapMarker.bShowDistance = true
    AK_PlayerMapMarker.DistanceUnit = "m"

    AK_PlayerMapMarker.WeaponIconBrushW = 138
    AK_PlayerMapMarker.WeaponIconBrushH = 69
    AK_PlayerMapMarker.HPWidgetSwitcherTypeIndex = 0
    AK_PlayerMapMarker.HPWidgetSwitcherType2Index = 0
    AK_PlayerMapMarker.bForceSwitcherIndexEveryUpdate = true

    AK_PlayerMapMarker.bUseSnapLines = true
    AK_PlayerMapMarker.SnapLineThickness = 1
    AK_PlayerMapMarker.SnapLineOriginY = 50
    AK_PlayerMapMarker.SnapLineOriginOffsetX = 0
    AK_PlayerMapMarker.SnapLineHeadOffsetX = 0
    AK_PlayerMapMarker.SnapLineHeadOffsetY = -20
    AK_PlayerMapMarker.SnapLineColor = nil
    AK_PlayerMapMarker.SnapLineOpacity = 0.7

    AK_PlayerMapMarker.MapAddedFlag = 4
    AK_PlayerMapMarker.nUpdateInterval = 0.5

    AK_PlayerMapMarker.bUseFrameTick = false
    AK_PlayerMapMarker.nHeavyScanFrameInterval = 15
    AK_PlayerMapMarker.nDistanceUpdateFrameInterval = 5

    AK_PlayerMapMarker.bIncludeMe = false
    AK_PlayerMapMarker.bIncludeAI = true
    AK_PlayerMapMarker.bUseServerMarks = false

    AK_PlayerMapMarker.bActive = false
    AK_PlayerMapMarker.MarkMap = {}
    AK_PlayerMapMarker.PlayerInfo = {}

    AK_PlayerMapMarker.ESPCanvas = nil
    AK_PlayerMapMarker.ESPWidgets = {}
    AK_PlayerMapMarker.ESPWidgetPtrs = {}
    AK_PlayerMapMarker.SnapLineWidgets = {}

    AK_PlayerMapMarker.BoxWidgets = {}
    AK_PlayerMapMarker.HealthWidgets = {}
    AK_PlayerMapMarker.CustomTextWidgets = {}

    function AK_PlayerMapMarker.CreateBoxLine()
        if not AK_PlayerMapMarker.ESPCanvas or not Game:IsValid(AK_PlayerMapMarker.ESPCanvas) then return nil end
        local Border = nil
        pcall(function() Border = CGame:NewObjectFromPath("/Script/UMG.Border", AK_PlayerMapMarker.ESPCanvas) end)
        if not Border or not slua.isValid(Border) then return nil end
        pcall(function() Border:SetWidgetVisibility(UEnums.ESlateVisibility.Collapsed) end)
        pcall(function() Border.RenderTransformPivot = FVector2D(0.0, 0.0) end)
        pcall(function() Border:SetRenderTransformPivot(FVector2D(0.0, 0.0)) end)
        local Slot = nil
        pcall(function()
            Slot = AK_PlayerMapMarker.ESPCanvas:AddChildToCanvas(Border)
            if Slot then
                Slot:SetAutoSize(false)
                Slot:SetZOrder(1)
            end
        end)
        return { Widget = Border, Slot = Slot, _vis = 2 }
    end

    function AK_PlayerMapMarker.Update2DBox(KeyStr, topPos, bottomPos, color, isVisible)
        AK_PlayerMapMarker.BoxWidgets = AK_PlayerMapMarker.BoxWidgets or {}
        local box = AK_PlayerMapMarker.BoxWidgets[KeyStr]

        if not isVisible then
            if box then
                for i = 1, 4 do
                    local line = box[i]
                    if line and line.Widget and slua.isValid(line.Widget) and line._vis ~= 2 then
                        pcall(function() line.Widget:SetWidgetVisibility(UEnums.ESlateVisibility.Collapsed) end)
                        line._vis = 2
                    end
                end
            end
            return
        end

        if not box then
            box = { AK_PlayerMapMarker.CreateBoxLine(), AK_PlayerMapMarker.CreateBoxLine(), AK_PlayerMapMarker.CreateBoxLine(), AK_PlayerMapMarker.CreateBoxLine() }
            AK_PlayerMapMarker.BoxWidgets[KeyStr] = box
        end

        local height = bottomPos.Y - topPos.Y
        local width = height * 0.55
        local centerX = bottomPos.X 
        
        local tX = centerX - (width / 2)
        local tY = topPos.Y
        local bX = centerX - (width / 2)
        local bY = bottomPos.Y
        local thick = 1.3

        local lines = {
            { x = tX, y = tY, w = width, h = thick },  
            { x = bX, y = bY, w = width, h = thick },  
            { x = tX, y = tY, w = thick, h = height },  
            { x = tX + width, y = tY, w = thick, h = height + thick }  
        }

        for i = 1, 4 do
            local line = box[i]
            if line and line.Widget and line.Slot then
                if line._vis ~= 0 then
                    pcall(function() line.Widget:SetWidgetVisibility(UEnums.ESlateVisibility.SelfHitTestInvisible) end)
                    line._vis = 0
                end
                
                pcall(function() line.Widget:SetBrushColor(color) end)
                
                local nx, ny = lines[i].x, lines[i].y
                local nw, nh = lines[i].w, lines[i].h
                
                if not line._CachedPos or math.abs(line._CachedPos.X - nx) > 0.5 or math.abs(line._CachedPos.Y - ny) > 0.5 or
                   not line._CachedSize or math.abs(line._CachedSize.X - nw) > 0.5 or math.abs(line._CachedSize.Y - nh) > 0.5 then
                   
                    line._CachedPos = line._CachedPos or FVector2D(nx, ny)
                    line._CachedSize = line._CachedSize or FVector2D(nw, nh)
                    line._CachedPos.X, line._CachedPos.Y = nx, ny
                    line._CachedSize.X, line._CachedSize.Y = nw, nh
                    
                    pcall(function()
                        line.Slot:SetPosition(line._CachedPos)
                        line.Slot:SetSize(line._CachedSize)
                    end)
                end
            end
        end
    end

    function AK_PlayerMapMarker.Update2DHealthBar(KeyStr, topPos, bottomPos, pct, isVisible)
        AK_PlayerMapMarker.HealthWidgets = AK_PlayerMapMarker.HealthWidgets or {}
        local hpBox = AK_PlayerMapMarker.HealthWidgets[KeyStr]

        if not isVisible then
            if hpBox then
                if hpBox.bg and hpBox.bg.Widget and slua.isValid(hpBox.bg.Widget) and hpBox.bg._vis ~= 2 then 
                    pcall(function() hpBox.bg.Widget:SetWidgetVisibility(UEnums.ESlateVisibility.Collapsed) end); hpBox.bg._vis = 2 
                end
                if hpBox.fg and hpBox.fg.Widget and slua.isValid(hpBox.fg.Widget) and hpBox.fg._vis ~= 2 then 
                    pcall(function() hpBox.fg.Widget:SetWidgetVisibility(UEnums.ESlateVisibility.Collapsed) end); hpBox.fg._vis = 2 
                end
            end
            return
        end

        if not hpBox then
            hpBox = { bg = AK_PlayerMapMarker.CreateBoxLine(), fg = AK_PlayerMapMarker.CreateBoxLine() }
            AK_PlayerMapMarker.HealthWidgets[KeyStr] = hpBox
        end

        local barTopY = topPos.Y - 14
        local barBottomY = bottomPos.Y + 14
        local barHeight = barBottomY - barTopY

        local boxHeight = bottomPos.Y - topPos.Y
        local boxWidth = boxHeight * 0.55
        local barWidth = 4.0
        local padding = 5.0
        local centerX = bottomPos.X

        local mode = _G.AK_GetVal("ESP_HEALTH_POS") or 1
        local bgX, bgY, bgW, bgH
        local fgX, fgY, fgW, fgH

        if mode == 2 then 
            bgX = centerX + (boxWidth / 2) + padding
            bgY = barTopY
            bgW = barWidth
            bgH = barHeight
            
            fgX = bgX
            fgH = barHeight * pct
            fgY = barBottomY - fgH
            fgW = barWidth

        elseif mode == 3 then
            bgX = centerX - (barHeight / 2)
            bgY = topPos.Y - 11
            bgW = barHeight
            bgH = barWidth
            
            fgX = bgX
            fgY = bgY
            fgW = barHeight * pct
            fgH = barWidth

        elseif mode == 4 then
            bgX = centerX - (barHeight / 2)
            bgY = bottomPos.Y + 7
            bgW = barHeight
            bgH = barWidth
            
            fgX = bgX
            fgY = bgY
            fgW = barHeight * pct
            fgH = barWidth

        else
            bgX = centerX - (boxWidth / 2) - padding - barWidth
            bgY = barTopY
            bgW = barWidth
            bgH = barHeight
            
            fgX = bgX
            fgH = barHeight * pct
            fgY = barBottomY - fgH
            fgW = barWidth
        end

        local hpColor = FLinearColor(0, 1, 0, 1)  
        if pct < 0.25 then 
            hpColor = FLinearColor(1, 0, 0, 1)  
        elseif pct < 0.60 then 
            hpColor = FLinearColor(1, 1, 0, 1) 
        end
        local bgColor = FLinearColor(0, 0, 0, 0.7)

        local drawLine = function(lineData, x, y, w, h, col)
            if lineData and lineData.Widget and lineData.Slot then
                if lineData._vis ~= 0 then
                    pcall(function() lineData.Widget:SetWidgetVisibility(UEnums.ESlateVisibility.SelfHitTestInvisible) end)
                    lineData._vis = 0
                end
                
                pcall(function() lineData.Widget:SetBrushColor(col) end)
                
                if not lineData._CachedPos or math.abs(lineData._CachedPos.X - x) > 0.01 or math.abs(lineData._CachedPos.Y - y) > 0.01 or
                   not lineData._CachedSize or math.abs(lineData._CachedSize.X - w) > 0.01 or math.abs(lineData._CachedSize.Y - h) > 0.01 then
                   
                    lineData._CachedPos = lineData._CachedPos or FVector2D(x, y)
                    lineData._CachedSize = lineData._CachedSize or FVector2D(w, h)
                    lineData._CachedPos.X, lineData._CachedPos.Y = x, y
                    lineData._CachedSize.X, lineData._CachedSize.Y = w, h
                    
                    pcall(function()
                        lineData.Slot:SetPosition(lineData._CachedPos)
                        lineData.Slot:SetSize(lineData._CachedSize)
                    end)
                end
            end
        end

        drawLine(hpBox.bg, bgX, bgY, bgW, bgH, bgColor)
        drawLine(hpBox.fg, fgX, fgY, fgW, fgH, hpColor)
    end

    function AK_PlayerMapMarker.CreateTextLine()
        if not AK_PlayerMapMarker.ESPCanvas or not Game:IsValid(AK_PlayerMapMarker.ESPCanvas) then return nil end
        local TxtWidget = nil
        pcall(function() TxtWidget = CGame:NewObjectFromPath("/Script/UMG.TextBlock", AK_PlayerMapMarker.ESPCanvas) end)
        if not TxtWidget or not slua.isValid(TxtWidget) then return nil end
        
        pcall(function() TxtWidget:SetWidgetVisibility(UEnums.ESlateVisibility.Collapsed) end)
        pcall(function() TxtWidget.RenderTransformPivot = FVector2D(0.5, 0.5) end)
        pcall(function() TxtWidget:SetRenderTransformPivot(FVector2D(0.5, 0.5)) end)
        pcall(function() TxtWidget:SetJustification(1) end)

        local Slot = nil
        pcall(function()
            Slot = AK_PlayerMapMarker.ESPCanvas:AddChildToCanvas(TxtWidget)
            if Slot then Slot:SetAutoSize(true); Slot:SetAlignment(FVector2D(0.5, 0.5)); Slot:SetZOrder(3) end
        end)
        return { Widget = TxtWidget, Slot = Slot, _vis = 2 }
    end

    function AK_PlayerMapMarker.Update2DTextData(KeyStr, topPos, bottomPos, nameStr, distStr, teamIDStr, isVisible, espColor)
        AK_PlayerMapMarker.CustomTextWidgets = AK_PlayerMapMarker.CustomTextWidgets or {}
        local tBox = AK_PlayerMapMarker.CustomTextWidgets[KeyStr]

        if not isVisible then
            if tBox then
                if tBox.nameTxt and tBox.nameTxt.Widget and slua.isValid(tBox.nameTxt.Widget) and tBox.nameTxt._vis ~= 2 then 
                    pcall(function() tBox.nameTxt.Widget:SetWidgetVisibility(UEnums.ESlateVisibility.Collapsed) end); tBox.nameTxt._vis = 2 
                end
                if tBox.distTxt and tBox.distTxt.Widget and slua.isValid(tBox.distTxt.Widget) and tBox.distTxt._vis ~= 2 then 
                    pcall(function() tBox.distTxt.Widget:SetWidgetVisibility(UEnums.ESlateVisibility.Collapsed) end); tBox.distTxt._vis = 2 
                end
                if tBox.botTxt and tBox.botTxt.Widget and slua.isValid(tBox.botTxt.Widget) and tBox.botTxt._vis ~= 2 then 
                    pcall(function() tBox.botTxt.Widget:SetWidgetVisibility(UEnums.ESlateVisibility.Collapsed) end); tBox.botTxt._vis = 2 
                end
            end
            return
        end

        if not tBox then
            tBox = { 
                nameTxt = AK_PlayerMapMarker.CreateTextLine(), 
                distTxt = AK_PlayerMapMarker.CreateTextLine(), 
                botTxt = AK_PlayerMapMarker.CreateTextLine() 
            }
            AK_PlayerMapMarker.CustomTextWidgets[KeyStr] = tBox
        end
        
        if not tBox.nameTxt then tBox.nameTxt = tBox.topTxt or AK_PlayerMapMarker.CreateTextLine() end
        if not tBox.distTxt then tBox.distTxt = AK_PlayerMapMarker.CreateTextLine() end

        local centerX = bottomPos.X

        local applyText = function(lineData, x, y, textStr, col, fontSize)
            if lineData and lineData.Widget and lineData.Slot then
                if lineData._vis ~= 0 then
                    pcall(function() lineData.Widget:SetWidgetVisibility(UEnums.ESlateVisibility.SelfHitTestInvisible) end)
                    lineData._vis = 0
                end
                
                if lineData._lastTxt ~= textStr then
                    pcall(function() lineData.Widget:SetText(textStr) end)
                    lineData._lastTxt = textStr
                end
                
                pcall(function()
                    local FSlateColor = import("SlateColor") or import("/Script/SlateCore.SlateColor")
                    if FSlateColor then lineData.Widget:SetColorAndOpacity(FSlateColor(col)) 
                    else lineData.Widget:SetColorAndOpacity(col) end
                end)

                if not lineData._fontInit then
                    pcall(function()
                        if lineData.Widget.Font then 
                            local font = lineData.Widget.Font
                            font.Size = fontSize
                            font.OutlineSettings.OutlineSize = 1
                            font.OutlineSettings.OutlineColor = FLinearColor(0,0,0,1)
                            lineData.Widget:SetFont(font) 
                        end
                    end)
                    lineData._fontInit = true
                end

                if not lineData._CachedPos or math.abs(lineData._CachedPos.X - x) > 0.01 or math.abs(lineData._CachedPos.Y - y) > 0.01 then
                    lineData._CachedPos = lineData._CachedPos or FVector2D(x, y)
                    lineData._CachedPos.X, lineData._CachedPos.Y = x, y
                    pcall(function() lineData.Slot:SetPosition(lineData._CachedPos) end)
                end
            end
        end

        local hpMode = _G.AK_GetVal("ESP_HEALTH_POS") or 1
        local isShowHp = _G.AK_GetVal("ESP_HEALTH") == 1
        
        local yOffsetName = -26
        local yOffsetDist = -14
        local yOffsetTeam = 14
        
        if isShowHp then
            if hpMode == 3 then 
                yOffsetName = -35
                yOffsetDist = -23
            elseif hpMode == 4 then 
                yOffsetTeam = 23
            end
        end

        if nameStr ~= "" then
            applyText(tBox.nameTxt, centerX, topPos.Y + yOffsetName, nameStr, FLinearColor(1, 1, 1, 1), 10)
        else
            if tBox.nameTxt and tBox.nameTxt.Widget and slua.isValid(tBox.nameTxt.Widget) and tBox.nameTxt._vis ~= 2 then 
                pcall(function() tBox.nameTxt.Widget:SetWidgetVisibility(UEnums.ESlateVisibility.Collapsed) end); tBox.nameTxt._vis = 2 
            end
        end

        if distStr ~= "" then
            applyText(tBox.distTxt, centerX, topPos.Y + yOffsetDist, "[" .. distStr .. "]", FLinearColor(0, 1, 0, 1), 10)
        else
            if tBox.distTxt and tBox.distTxt.Widget and slua.isValid(tBox.distTxt.Widget) and tBox.distTxt._vis ~= 2 then 
                pcall(function() tBox.distTxt.Widget:SetWidgetVisibility(UEnums.ESlateVisibility.Collapsed) end); tBox.distTxt._vis = 2 
            end
        end

        if teamIDStr and teamIDStr ~= "" then
            local txtColor = espColor
            local numID = tonumber(teamIDStr)
            if numID then
                local specificColor = AK_PlayerMapMarker.GetTeamColor(numID)
                if specificColor then txtColor = specificColor end
            end
            
            applyText(tBox.botTxt, centerX, bottomPos.Y + yOffsetTeam, tostring(teamIDStr), txtColor, 10)
        else
            if tBox.botTxt and tBox.botTxt.Widget and slua.isValid(tBox.botTxt.Widget) and tBox.botTxt._vis ~= 2 then 
                pcall(function() tBox.botTxt.Widget:SetWidgetVisibility(UEnums.ESlateVisibility.Collapsed) end); tBox.botTxt._vis = 2
            end
        end
    end

    function AK_PlayerMapMarker.Remove2DBox(KeyStr)
        local box = AK_PlayerMapMarker.BoxWidgets[KeyStr]
        if box then
            for i = 1, 4 do
                if box[i] and box[i].Widget and slua.isValid(box[i].Widget) then
                    pcall(function()
                        box[i].Widget:RemoveFromParent()
                        box[i].Widget:ConditionalBeginDestroy()
                    end)
                end
            end
            AK_PlayerMapMarker.BoxWidgets[KeyStr] = nil
        end
        
        local hpBox = AK_PlayerMapMarker.HealthWidgets[KeyStr]
        if hpBox then
            if hpBox.bg and slua.isValid(hpBox.bg.Widget) then pcall(function() hpBox.bg.Widget:RemoveFromParent(); hpBox.bg.Widget:ConditionalBeginDestroy() end) end
            if hpBox.fg and slua.isValid(hpBox.fg.Widget) then pcall(function() hpBox.fg.Widget:RemoveFromParent(); hpBox.fg.Widget:ConditionalBeginDestroy() end) end
            AK_PlayerMapMarker.HealthWidgets[KeyStr] = nil
        end

        local tBox = AK_PlayerMapMarker.CustomTextWidgets[KeyStr]
        if tBox then
            if tBox.topTxt and slua.isValid(tBox.topTxt.Widget) then pcall(function() tBox.topTxt.Widget:RemoveFromParent(); tBox.topTxt.Widget:ConditionalBeginDestroy() end) end
            if tBox.nameTxt and slua.isValid(tBox.nameTxt.Widget) then pcall(function() tBox.nameTxt.Widget:RemoveFromParent(); tBox.nameTxt.Widget:ConditionalBeginDestroy() end) end
            if tBox.distTxt and slua.isValid(tBox.distTxt.Widget) then pcall(function() tBox.distTxt.Widget:RemoveFromParent(); tBox.distTxt.Widget:ConditionalBeginDestroy() end) end
            if tBox.botTxt and slua.isValid(tBox.botTxt.Widget) then pcall(function() tBox.botTxt.Widget:RemoveFromParent(); tBox.botTxt.Widget:ConditionalBeginDestroy() end) end
            AK_PlayerMapMarker.CustomTextWidgets[KeyStr] = nil
        end
    end

    AK_PlayerMapMarker._cachedViewportW = 1920
    AK_PlayerMapMarker._cachedViewportH = 1080

    AK_PlayerMapMarker._FrameCount = 0
    AK_PlayerMapMarker._bTickRegistered = false
    AK_PlayerMapMarker._CachedAllChars = nil
    AK_PlayerMapMarker._CachedMyLoc = nil
    AK_PlayerMapMarker._CachedMyKey = nil

    AK_PlayerMapMarker.WidgetComps = {}
    AK_PlayerMapMarker._bAllPathsFailed = false

    AK_PlayerMapMarker._bLightUpdateScheduled = false
    AK_PlayerMapMarker._LightUpdateInterval = 0.02

    AK_PlayerMapMarker._bDistanceUpdateScheduled = false
    AK_PlayerMapMarker._DistanceUpdateInterval = 0.1

    local function AK_IsValid(obj)
        if obj == nil then return false end
        if slua and slua.isValid then return slua.isValid(obj) end
        return obj ~= nil
    end

    local function AK_SafeStr(val)
        if val == nil then return "nil" end
        return tostring(val)
    end

    local function AK_GetFVector(X, Y, Z)
        local VT = FVector
        if not VT then
            pcall(function() VT = import("/Script/CoreUObject.Vector") end)
        end
        if VT then
            local ok, vec = pcall(function() return VT(X or 0, Y or 0, Z or 0) end)
            if ok and vec then return vec end
        end
        return nil
    end

    local function AK_GetMapAddedFlag()
        if AK_PlayerMapMarker.MapAddedFlag ~= nil then
            return AK_PlayerMapMarker.MapAddedFlag
        end
        if UEnums and UEnums.EAddMarkFlag and UEnums.EAddMarkFlag.EAMF_Both then
            return UEnums.EAddMarkFlag.EAMF_Both
        end
        return 3
    end

    AK_PlayerMapMarker._bScreenMarkConfigSetup = false

    function AK_PlayerMapMarker.SetupScreenMarkConfig()
        if AK_PlayerMapMarker._bScreenMarkConfigSetup then return true end
        local bOK = false
        pcall(function()
            local GamePlayTools = require("GameLua.Mod.BaseMod.Common.GamePlayTools")
            local ScreenMarkConfig = GamePlayTools.GetCurrentConfig("ScreenMarkConfig")
            if ScreenMarkConfig then
                ScreenMarkConfig[1007] = {
                    UIPathName = "/Game/BluePrints/UI/OBUI/Item/OB_PlayerHeadHPItem_UIBP.OB_PlayerHeadHPItem_UIBP_C",
                    MaxWidgetNum = 100,
                    MaxShowDistance = 6000000,
                    bBindOutScreen = false,
                    bBindBlocked = true,
                    bNeedPreLoad = true,
                    bIsBindingActor = true,
                    BindSocketName = "HelmetSocket",
                    WorldPositionOffset = FVector(0, 0, 80)
                }
                AK_PlayerMapMarker._bScreenMarkConfigSetup = true
                bOK = true
            end
        end)
        return bOK
    end

    function AK_PlayerMapMarker.GetGameplayData()
        if AK_PlayerMapMarker._CachedGameplayData then
            return AK_PlayerMapMarker._CachedGameplayData
        end
        local ok, GDP = pcall(function()
            return require("GameLua.GameCore.Data.GameplayData")
        end)
        if ok and GDP then
            AK_PlayerMapMarker._CachedGameplayData = GDP
            return GDP
        end
        return nil
    end

    function AK_PlayerMapMarker.GetMyPlayerController()
        local PC = AK_PlayerMapMarker._CachedPC
        if PC and AK_IsValid(PC) then
            return PC
        end
        local GDP = AK_PlayerMapMarker.GetGameplayData()
        if not GDP then return nil end
        pcall(function() PC = GDP.GetPlayerController and GDP.GetPlayerController() end)
        if PC and AK_IsValid(PC) then
            AK_PlayerMapMarker._CachedPC = PC
            return PC
        end
        return nil
    end

    function AK_PlayerMapMarker.GetCGameState()
        if CGameState and AK_IsValid(CGameState) then
            return CGameState
        end
        if AK_PlayerMapMarker._CachedCGameState and AK_IsValid(AK_PlayerMapMarker._CachedCGameState) then
            return AK_PlayerMapMarker._CachedCGameState
        end
        local ok, GS = pcall(function()
            return require("GameLua.GameCore.Data.CGameState")
        end)
        if ok and GS then
            AK_PlayerMapMarker._CachedCGameState = GS
            return GS
        end
        return nil
    end

    function AK_PlayerMapMarker.GetAllCharacters()
        local AllChars = {}
        pcall(function()
            local Pawns = Game:GetAllPlayerPawns()
            if Pawns then
                for _, Pawn in pairs(Pawns) do
                    if Pawn and slua.isValid(Pawn) then
                        local pKey = nil
                        if Pawn.GetPlayerKey then
                            pKey = Pawn:GetPlayerKey()
                        end
                        if not pKey and Pawn.PlayerKey then
                            pKey = Pawn.PlayerKey
                        end
                        if not pKey and Pawn.PlayerState and Pawn.PlayerState.PlayerKey then
                            pKey = Pawn.PlayerState.PlayerKey
                        end
                        if pKey then
                            AllChars[pKey] = Pawn
                        end
                    end
                end
            end
        end)
        
        if not next(AllChars) then
            local GS = AK_PlayerMapMarker.GetCGameState()
            if GS and GS.GetAllCharacters then
                pcall(function() AllChars = GS:GetAllCharacters() end)
            end
        end
        
        return AllChars
    end

    function AK_PlayerMapMarker.GetMyPlayerKey()
        local PC = AK_PlayerMapMarker.GetMyPlayerController()
        if not AK_IsValid(PC) then return nil end
        local MyKey = nil
        pcall(function()
            if PC.GetPlayerKey then
                MyKey = PC:GetPlayerKey()
            elseif PC.PlayerState and PC.PlayerState.PlayerKey then
                MyKey = PC.PlayerState.PlayerKey
            end
        end)
        return MyKey
    end

    function AK_PlayerMapMarker.IsMe(Character, PlayerKey, MyKey)
        local bIsMe = false
        pcall(function()
            local GDP = AK_PlayerMapMarker.GetGameplayData()
            if GDP and GDP.GetLocalCharacter then
                local MyChar = GDP.GetLocalCharacter()
                if MyChar and Character == MyChar then
                    bIsMe = true
                    return
                end
            end
            local PC = AK_PlayerMapMarker.GetMyPlayerController()
            if PC and PC.GetPawn then
                local Pawn = PC:GetPawn()
                if Pawn and Character == Pawn then
                    bIsMe = true
                    return
                end
            end
        end)
        if not bIsMe and MyKey ~= nil and PlayerKey ~= nil then
            bIsMe = (tostring(PlayerKey) == tostring(MyKey))
        end
        return bIsMe
    end

    function AK_PlayerMapMarker.GetCharacterLocation(Character)
        if not AK_IsValid(Character) then return nil end
        local Loc = nil
        pcall(function()
            if Character.K2_GetActorLocation then
                Loc = Character:K2_GetActorLocation()
            end
        end)
        if not Loc then
            pcall(function()
                if Game and Game.GetActorLocation then
                    Loc = Game:GetActorLocation(Character)
                end
            end)
        end
        return Loc
    end

    function AK_PlayerMapMarker.CalcDistance(Loc1, Loc2)
        if not Loc1 or not Loc2 then return nil end
        local Dist = nil
        pcall(function()
            if FVector and FVector.Dist2D then
                Dist = FVector.Dist2D(Loc1, Loc2)
            end
        end)
        if not Dist then
            pcall(function()
                local DX = (Loc1.X or 0) - (Loc2.X or 0)
                local DY = (Loc1.Y or 0) - (Loc2.Y or 0)
                Dist = math.sqrt(DX * DX + DY * DY)
            end)
        end
        return Dist
    end

    function AK_PlayerMapMarker.GetDistanceString(MyLoc, TargetLoc)
        if not AK_PlayerMapMarker.bShowDistance then return "" end
        if not MyLoc or not TargetLoc then return "" end
        local Dist = AK_PlayerMapMarker.CalcDistance(MyLoc, TargetLoc)
        if not Dist then return "" end
        local Meters = Dist / 100
        
        if Meters < 1000 then
            return tostring(math.floor(Meters)) .. "m"
        else
            local kmFloor = math.floor((Meters / 1000) * 10) / 10
            return tostring(kmFloor) .. "km"
        end
    end

    function AK_PlayerMapMarker.GetMyLocation()
        local GDP = AK_PlayerMapMarker.GetGameplayData()
        if not GDP then return nil end
        local MyChar = nil
        pcall(function() MyChar = GDP.GetLocalCharacter and GDP.GetLocalCharacter() end)
        if not AK_IsValid(MyChar) then
            local PC = AK_PlayerMapMarker.GetMyPlayerController()
            if AK_IsValid(PC) then
                pcall(function()
                    if PC.GetPawn then
                        local Pawn = PC:GetPawn()
                        if AK_IsValid(Pawn) and Pawn.K2_GetActorLocation then
                            return Pawn:K2_GetActorLocation()
                        end
                    end
                end)
            end
            return nil
        end
        return AK_PlayerMapMarker.GetCharacterLocation(MyChar)
    end

    function AK_PlayerMapMarker.GetPlayerName(Character)
        if not AK_IsValid(Character) then return "Unknown" end
        local Name = nil
        pcall(function()
            if Character.GetPlayerNameSafety then
                Name = Character:GetPlayerNameSafety()
            end
        end)
        if not Name then
            pcall(function()
                local PS = nil
                if Character.GetPlayerStateSafety then
                    PS = Character:GetPlayerStateSafety()
                elseif Character.GetPlayerState then
                    PS = Character:GetPlayerState()
                end
                if AK_IsValid(PS) and PS.GetPlayerName then
                    Name = PS:GetPlayerName()
                end
            end)
        end
        return Name or "Unknown"
    end

    function AK_PlayerMapMarker.IsAI(Character)
        local bAI = false
        pcall(function()
            if Game and Game.IsAI then
                bAI = Game:IsAI(Character)
            end
        end)
        return bAI
    end

    function AK_PlayerMapMarker.IsAlive(Character)
        local bAlive = true
        pcall(function()
            if Character.IsAlive then
                bAlive = Character:IsAlive()
            end
        end)
        return bAlive
    end

    function AK_PlayerMapMarker.GetQuickSignComponent()
        local PC = AK_PlayerMapMarker.GetMyPlayerController()
        if not AK_IsValid(PC) then return nil end
        local QSC = nil
        pcall(function()
            if PC.GetQuickSignComponent then
                QSC = PC:GetQuickSignComponent()
            end
        end)
        if not AK_IsValid(QSC) then
            pcall(function()
                local STExtraBlueprintFunctionLibrary = import("STExtraBlueprintFunctionLibrary")
                if STExtraBlueprintFunctionLibrary and STExtraBlueprintFunctionLibrary.GetQuickSignComponentFromController then
                    QSC = STExtraBlueprintFunctionLibrary.GetQuickSignComponentFromController(PC)
                end
            end)
        end
        return QSC
    end

    function AK_PlayerMapMarker.CreateQuickSignMark(Location)
        if not Location then return nil end
        local QSC = AK_PlayerMapMarker.GetQuickSignComponent()
        if not AK_IsValid(QSC) then return nil end
        local MsgID = nil
        pcall(function()
            if QSC.MakeCustomMark then
                MsgID = QSC:MakeCustomMark(Location, AK_PlayerMapMarker.QuickSignConfigKey)
            end
        end)
        return MsgID
    end

    function AK_PlayerMapMarker.RemoveQuickSignMark(MsgID)
        if not MsgID then return end
        local QSC = AK_PlayerMapMarker.GetQuickSignComponent()
        if not AK_IsValid(QSC) then return end
        pcall(function()
            if QSC.DealWithDelMsg then
                QSC:DealWithDelMsg(MsgID, false)
            end
        end)
    end

    AK_PlayerMapMarker._NavInstIDCounter = 1000
    AK_PlayerMapMarker.NavigatorUIPath = "/Game/BluePrints/UI/OBUI/Item/OB_PlayerHeadHPItem_UIBP.OB_PlayerHeadHPItem_UIBP_C"
    AK_PlayerMapMarker.NavigatorbIsIcon = true

    function AK_PlayerMapMarker.CreateNavigatorMark(Location)
        if not Location then return nil end
        local InstID = AK_PlayerMapMarker._NavInstIDCounter
        AK_PlayerMapMarker._NavInstIDCounter = AK_PlayerMapMarker._NavInstIDCounter + 1
        local NavWidget = nil
        pcall(function()
            if UIManager and UIManager.UI_Config_InGame and UIManager.UI_Config_InGame.NavigatorPanel then
                NavWidget = UIManager.GetUI(UIManager.UI_Config_InGame.NavigatorPanel)
            end
        end)
        if not NavWidget then return nil end
        local Result = nil
        pcall(function()
            Result = InGameMarkTools.ClientAddMarkToNavigator(
                AK_PlayerMapMarker.NavigatorUIPath,
                Location,
                true,
                AK_PlayerMapMarker.NavigatorbIsIcon,
                nil,
                InstID
            )
        end)
        return InstID
    end

    function AK_PlayerMapMarker.UpdateNavigatorMark(InstID, Location)
        if not InstID or not Location then return end
        pcall(function()
            if not UIManager.UI_Config_InGame.NavigatorPanel then return end
            local NavigatorWidget = UIManager.GetUI(UIManager.UI_Config_InGame.NavigatorPanel)
            if not NavigatorWidget then return end
            if NavigatorWidget.UpdateCustomMarkLocation then
                NavigatorWidget:UpdateCustomMarkLocation(InstID, Location)
            end
        end)
    end

    function AK_PlayerMapMarker.RemoveNavigatorMark(InstID)
        if not InstID then return end
        pcall(function()
            InGameMarkTools.ClientDestroyMarkToNavigator(InstID)
        end)
    end

    function AK_PlayerMapMarker.IsOurESPWidget(w)
        if not w or not slua.isValid(w) then return false end
        local bIsOurs = false
        pcall(function()
            local wstr = tostring(w)
            for KeyStr, ESPData in pairs(AK_PlayerMapMarker.ESPWidgets) do
                if ESPData and ESPData.Widget and ESPData.Widget.Container then
                    local cstr = tostring(ESPData.Widget.Container)
                    if cstr == wstr then
                        bIsOurs = true
                        return
                    end
                end
            end
        end)
        if bIsOurs then return true end
        pcall(function()
            if w.GetChildrenCount then
                local n = w:GetChildrenCount()
                for i = 0, n - 1 do
                    local child = w:GetChildAt(i)
                    if child and slua.isValid(child) then
                        local cstr = tostring(child)
                        if string.find(cstr, "Border") then
                            bIsOurs = true
                            break
                        end
                    end
                end
            end
        end)
        if not bIsOurs then
            pcall(function()
                local slot = w.Slot
                if slot and slot.GetPosition then
                    local pos = slot:GetPosition()
                    if pos and (math.abs(pos.X or 0) > 1 or math.abs(pos.Y or 0) > 1) then
                        bIsOurs = true
                    end
                end
            end)
        end
        if not bIsOurs then
            pcall(function()
                local function checkForDist(w2, depth)
                    if not w2 or not slua.isValid(w2) or depth > 5 then return false end
                    if w2.GetText then
                        local txt = nil
                        pcall(function() txt = w2:GetText() end)
                        if txt then
                            local s = tostring(txt)
                            if string.find(s, "%[%d+m%]") or string.find(s, "Dist=") then
                                return true
                            end
                        end
                    end
                    local n = 0
                    pcall(function() if w2.GetChildrenCount then n = w2:GetChildrenCount() end end)
                    for j = 0, n - 1 do
                        local c = nil
                        pcall(function() c = w2:GetChildAt(j) end)
                        if c and checkForDist(c, depth + 1) then return true end
                    end
                    return false
                end
                bIsOurs = checkForDist(w, 0)
            end)
        end
        return bIsOurs
    end

    function AK_PlayerMapMarker.ApplyAnchorBasedPosition(Slot, ScreenPos, Canvas)
        if not Slot or not ScreenPos then return false end
        local sx = ScreenPos.X or 0
        local sy = ScreenPos.Y or 0
        local sz = AK_PlayerMapMarker.ESPWidgetSize or FVector2D(100, 30)
        local align = AK_PlayerMapMarker.ESPWidgetAlignment or FVector2D(0.5, 1.0)

        local canvasW, canvasH = 0, 0
        if AK_PlayerMapMarker._cachedViewportW and AK_PlayerMapMarker._cachedViewportW > 200 then
            canvasW = AK_PlayerMapMarker._cachedViewportW
            canvasH = AK_PlayerMapMarker._cachedViewportH
        end

        if canvasW < 200 then
            pcall(function()
                local PC = AK_PlayerMapMarker.GetMyPlayerController()
                if AK_IsValid(PC) and PC.GetViewportSize then
                    local VS = FVector2D(0, 0)
                    PC:GetViewportSize(VS)
                    if VS and VS.X and VS.X > 200 then
                        canvasW = VS.X
                        canvasH = VS.Y
                        AK_PlayerMapMarker._cachedViewportW = canvasW
                        AK_PlayerMapMarker._cachedViewportH = canvasH
                    end
                end
            end)
        end

        if canvasW < 200 and Canvas then
            pcall(function()
                local current = Canvas
                local depth = 0
                while current and depth < 20 do
                    local w, h = 0, 0
                    pcall(function()
                        if current.GetCachedGeometry then
                            local cg = current:GetCachedGeometry()
                            if cg then
                                if cg.GetAbsoluteSize then
                                    local cs = cg:GetAbsoluteSize()
                                    if cs then
                                        w = cs.X or 0
                                        h = cs.Y or 0
                                    end
                                end
                            end
                        end
                    end)
                    if w >= 200 and h >= 200 then
                        canvasW = w
                        canvasH = h
                        AK_PlayerMapMarker._cachedViewportW = w
                        AK_PlayerMapMarker._cachedViewportH = h
                        break
                    end
                    local parent = nil
                    pcall(function() if current.GetParent then parent = current:GetParent() end end)
                    if not parent then break end
                    current = parent
                    depth = depth + 1
                end
            end)
        end

        if canvasW > 200 and canvasH > 200 then
            local anchorX = (sx + (AK_PlayerMapMarker.ESPAnchorOffsetX or 0)) / canvasW
            local anchorY = (sy + (AK_PlayerMapMarker.ESPAnchorOffsetY or 0)) / canvasH
            anchorX = math.max(0, math.min(1, anchorX))
            anchorY = math.max(0, math.min(1, anchorY))

            local bSuccess = false
            pcall(function()
                if Slot.SetAnchors and FAnchors then
                    local anchors = FAnchors(anchorX, anchorY, anchorX, anchorY)
                    if anchors then
                        Slot:SetAnchors(anchors)
                        Slot:SetPosition(FVector2D(0, 0))
                        bSuccess = true
                    end
                end
            end)
            if not bSuccess then
                pcall(function()
                    if Slot.SetAnchors then
                        Slot:SetAnchors(anchorX, anchorY, anchorX, anchorY)
                        Slot:SetPosition(FVector2D(0, 0))
                        bSuccess = true
                    end
                end)
            end
            if bSuccess then
                pcall(function()
                    if Slot.SetOffsets and FMargin then
                        Slot:SetOffsets(FMargin(0, 0, sz.X, sz.Y))
                    end
                end)
                pcall(function() Slot:SetSize(sz) end)
                pcall(function() Slot:SetAlignment(align) end)
                pcall(function() if Slot.SetAutoSize then Slot:SetAutoSize(AK_PlayerMapMarker.ESPWidgetAutoSize or true) end end)
                pcall(function() if Slot.SetZOrder then Slot:SetZOrder(AK_PlayerMapMarker.ESPWidgetZOrder or 2) end end)
                return true
            end
        end

        pcall(function()
            Slot:SetPosition(FVector2D(sx, sy))
            pcall(function() Slot:SetSize(sz) end)
            pcall(function() Slot:SetAlignment(align) end)
            pcall(function() if Slot.SetAutoSize then Slot:SetAutoSize(AK_PlayerMapMarker.ESPWidgetAutoSize or true) end end)
            pcall(function() if Slot.SetZOrder then Slot:SetZOrder(AK_PlayerMapMarker.ESPWidgetZOrder or 2) end end)
        end)
        return false
    end

    function AK_PlayerMapMarker.InitESPCanvas()
        if AK_PlayerMapMarker.ESPCanvas and Game:IsValid(AK_PlayerMapMarker.ESPCanvas) then
            return true
        end

        local InGameUITools = nil
        pcall(function() InGameUITools = require("GameLua.Mod.BaseMod.Common.UI.InGameUITools") end)
        if not InGameUITools then
            return false
        end

        local MainControlBaseUI = nil
        pcall(function() MainControlBaseUI = InGameUITools.GetMainControlBaseUI() end)
        if not MainControlBaseUI or not Game:IsValid(MainControlBaseUI) then
            return false
        end

        local ParentCanvas = nil
        pcall(function()
            if MainControlBaseUI.CanvasPanel_0 and Game:IsValid(MainControlBaseUI.CanvasPanel_0) then
                ParentCanvas = MainControlBaseUI.CanvasPanel_0
            elseif MainControlBaseUI.CanvasPanel_42 and Game:IsValid(MainControlBaseUI.CanvasPanel_42) then
                ParentCanvas = MainControlBaseUI.CanvasPanel_42
            end
        end)

        if not ParentCanvas then
            return false
        end

        AK_PlayerMapMarker.ESPCanvas = ParentCanvas

        pcall(function()
            local nChildren = ParentCanvas:GetChildrenCount()
            for i = nChildren - 1, 0, -1 do
                local child = ParentCanvas:GetChildAt(i)
                if child and slua.isValid(child) then
                    if AK_PlayerMapMarker.IsOurESPWidget(child) then
                        pcall(function() ParentCanvas:RemoveChild(child) end)
                    end
                end
            end
        end)

        return true
    end

    function AK_PlayerMapMarker.FindProgressBarInWidget(WidgetObj, Depth, MaxDepth)
        if not WidgetObj or not slua.isValid(WidgetObj) then return nil end
        Depth = Depth or 0
        MaxDepth = MaxDepth or 5
        if Depth > MaxDepth then return nil end

        local bIsPB = false
        pcall(function()
            if WidgetObj.SetPercent and WidgetObj.SetFillColorAndOpacity then
                bIsPB = true
            end
        end)
        if bIsPB then return WidgetObj end

        local nChildren = 0
        pcall(function()
            if WidgetObj.GetChildrenCount then nChildren = WidgetObj:GetChildrenCount() end
        end)

        for i = 0, math.max(nChildren - 1, 0) do
            local child = nil
            pcall(function() child = WidgetObj:GetChildAt(i) end)
            if child and slua.isValid(child) then
                local result = AK_PlayerMapMarker.FindProgressBarInWidget(child, Depth + 1, MaxDepth)
                if result then return result end
            end
        end

        return nil
    end

    function AK_PlayerMapMarker.GetTeamID(Character)
        if not AK_IsValid(Character) then return nil end
        local TeamID = nil
        pcall(function()
            if Character.GetTeamID then TeamID = Character:GetTeamID() end
        end)
        if not TeamID then
            pcall(function()
                local PS = nil
                if Character.GetPlayerStateSafety then
                    PS = Character:GetPlayerStateSafety()
                elseif Character.GetPlayerState then
                    PS = Character:GetPlayerState()
                end
                if AK_IsValid(PS) and PS.GetTeamID then
                    TeamID = PS:GetTeamID()
                elseif AK_IsValid(PS) and PS.TeamID then
                    TeamID = PS.TeamID
                end
            end)
        end
        if not TeamID then
            pcall(function()
                if Character.TeamID then TeamID = Character.TeamID end
            end)
        end
        return TeamID
    end

    function AK_PlayerMapMarker.GetTeamColor(TeamID)
        if TeamID == nil then return nil end
        local TeamColors = {
            [1] = FLinearColor(1.0, 0.2, 0.2, 1.0),
            [2] = FLinearColor(0.2, 0.4, 1.0, 1.0),
            [3] = FLinearColor(0.2, 0.9, 0.3, 1.0),
            [4] = FLinearColor(1.0, 0.9, 0.2, 1.0),
            [5] = FLinearColor(0.8, 0.3, 1.0, 1.0),
            [6] = FLinearColor(0.2, 0.9, 0.9, 1.0),
            [7] = FLinearColor(1.0, 0.5, 0.2, 1.0),
            [8] = FLinearColor(1.0, 0.4, 0.7, 1.0),
        }
        local color = TeamColors[TeamID]
        if color then return color end
        if TeamID == 1 then
            return FLinearColor(1.0, 0.2, 0.2, 1.0)
        else
            return FLinearColor(0.2, 0.4, 1.0, 1.0)
        end
    end

    local _WhiteTexture = nil
    local _bWhiteTextureFailed = false

    local function GetWhiteTexture()
        if _WhiteTexture then return _WhiteTexture end
        if _bWhiteTextureFailed then return nil end
        pcall(function()
            local paths = {
                "/Game/BluePrints/UI/Textures/White.White",
                "/Game/BluePrints/UI/Textures/Common/White.White",
                "/Engine/EngineResources/WhiteSquareTexture.WhiteSquareTexture",
                "/Engine/EngineMaterials/DefaultWhiteGrid.DefaultWhiteGrid",
            }
            for _, path in ipairs(paths) do
                pcall(function()
                    local tex = import(path)
                    if tex and slua.isValid(tex) then
                        _WhiteTexture = tex
                        return
                    end
                end)
                if _WhiteTexture then break end
            end
        end)
        if not _WhiteTexture then
            _bWhiteTextureFailed = true
        end
        return _WhiteTexture
    end

    local function SetImageColor(Image, color)
        if not Image or not slua.isValid(Image) then return false end
        local bOK = false
        pcall(function()
            if Image.SetBrushTintColor then
                Image:SetBrushTintColor(color)
                bOK = true
            end
        end)
        pcall(function()
            if Image.SetBrushColor then
                Image:SetBrushColor(color)
                bOK = true
            end
        end)
        pcall(function()
            if Image.SetColorAndOpacity then
                Image:SetColorAndOpacity(color)
                bOK = true
            end
        end)
        pcall(function()
            if Image.SetTintColorAndOpacity then
                Image:SetTintColorAndOpacity(color)
                bOK = true
            end
        end)
        pcall(function()
            if Image.SetBrushFromTexture then
                local whiteTex = GetWhiteTexture()
                if whiteTex then
                    Image:SetBrushFromTexture(whiteTex, false)
                    if Image.SetColorAndOpacity then
                        Image:SetColorAndOpacity(color)
                    end
                    if Image.SetBrushTintColor then
                        Image:SetBrushTintColor(color)
                    end
                    bOK = true
                end
            end
        end)
        pcall(function()
            if Image.SetBrushFromAsset and not bOK then
                Image:SetBrushFromAsset("/Engine/EngineResources/WhiteSquareTexture.WhiteSquareTexture", false)
                if Image.SetColorAndOpacity then
                    Image:SetColorAndOpacity(color)
                end
                bOK = true
            end
        end)
        pcall(function() Image:SetWidgetVisibility(UEnums.ESlateVisibility.SelfHitTestInvisible) end)
        pcall(function() Image:SetRenderOpacity(1.0) end)
        return bOK
    end

    function AK_PlayerMapMarker._GetWidgetRoot(WidgetObj)
        if not WidgetObj or not slua.isValid(WidgetObj) then return nil end
        local Root = nil
        pcall(function()
            if WidgetObj.GetRootWidget then
                Root = WidgetObj:GetRootWidget()
            end
        end)
        if Root and slua.isValid(Root) then return Root end
        pcall(function()
            if WidgetObj.WidgetTree and WidgetObj.WidgetTree.RootWidget then
                Root = WidgetObj.WidgetTree.RootWidget
            end
        end)
        if Root and slua.isValid(Root) then return Root end
        pcall(function()
            if WidgetObj.RootWidget and slua.isValid(WidgetObj.RootWidget) then
                Root = WidgetObj.RootWidget
            end
        end)
        return Root
    end

    function AK_PlayerMapMarker._FindNamedWidgetInTree(WidgetObj, TargetName, MaxDepth)
        if not WidgetObj or not slua.isValid(WidgetObj) then return nil end
        MaxDepth = MaxDepth or 8

        local wname = nil
        pcall(function()
            if WidgetObj.GetName then wname = WidgetObj:GetName() end
        end)
        if wname and wname == TargetName then return WidgetObj end

        local wstr = tostring(WidgetObj)
        if wstr and string.find(wstr, TargetName, 1, true) then
            if wname and wname == TargetName then
                return WidgetObj
            elseif not wname or wname == "" then
                local _, endPos = string.find(wstr, TargetName, 1, true)
                if endPos then
                    local nextChar = string.sub(wstr, endPos + 1, endPos + 1)
                    if nextChar ~= "_" and nextChar ~= "" then
                        return WidgetObj
                    end
                end
            end
        end

        local nChildren = 0
        pcall(function()
            if WidgetObj.GetChildrenCount then nChildren = WidgetObj:GetChildrenCount() end
        end)

        if nChildren > 0 then
            for i = 0, nChildren - 1 do
                local child = nil
                pcall(function() child = WidgetObj:GetChildAt(i) end)
                if child and slua.isValid(child) then
                    local found = AK_PlayerMapMarker._FindNamedWidgetInTree(child, TargetName, MaxDepth - 1)
                    if found then return found end
                end
            end
        else
            local Root = AK_PlayerMapMarker._GetWidgetRoot(WidgetObj)
            if Root and slua.isValid(Root) and Root ~= WidgetObj then
                local found = AK_PlayerMapMarker._FindNamedWidgetInTree(Root, TargetName, MaxDepth - 1)
                if found then return found end
            end
        end

        return nil
    end

    function AK_PlayerMapMarker.ApplyTeamColor(Widget, TeamID)
        if not Widget or not Widget.Container then return end
        local color = AK_PlayerMapMarker.GetTeamColor(TeamID)
        if not color then return end

        pcall(function()
            local W = Widget.Container
            if not W or not slua.isValid(W) then return end

            if W.SetTeamColor then
                pcall(function() W:SetTeamColor(TeamID) end)
            end
            if W.SetTeamID then
                pcall(function() W:SetTeamID(TeamID) end)
            end
        end)
    end

    function AK_PlayerMapMarker.GetCharacterMesh(Character)
        if not AK_IsValid(Character) then return nil end
        local Mesh = nil
        pcall(function()
            if Character.Mesh and Game:IsValid(Character.Mesh) then
                Mesh = Character.Mesh
            end
        end)
        if not Mesh then
            pcall(function()
                local SkeletalMeshCompClass = import("/Script/Engine.SkeletalMeshComponent")
                Mesh = Character:GetComponentByClass(SkeletalMeshCompClass)
            end)
        end
        return Mesh
    end

    function AK_PlayerMapMarker.GetBoneLocation(Character, BoneName)
        if not AK_IsValid(Character) or not BoneName then return nil end
        local Mesh = AK_PlayerMapMarker.GetCharacterMesh(Character)
        if not Mesh or not Game:IsValid(Mesh) then return nil end
        local Loc = nil
        pcall(function()
            if Mesh.GetSocketLocation then
                Loc = Mesh:GetSocketLocation(BoneName)
            end
        end)
        if not Loc then
            pcall(function()
                if Mesh.GetBoneLocation then
                    Loc = Mesh:GetBoneLocation(BoneName)
                end
            end)
        end
        return Loc
    end

    function AK_PlayerMapMarker.ApplyWorldOffset(Loc, OffsetZ)
        if not Loc then return nil end
        if not OffsetZ or OffsetZ == 0 then return Loc end
        
        local ok = pcall(function()
            Loc.Z = Loc.Z + OffsetZ
        end)
        if ok then
            return Loc
        end

        local result = nil
        pcall(function()
            local X = Loc.X or 0
            local Y = Loc.Y or 0
            local Z = (Loc.Z or 0) + OffsetZ
            if FVector then
                result = FVector(X, Y, Z)
            end
        end)
        return result or Loc
    end

    function AK_PlayerMapMarker.GetESPLocation(Character)
        if not AK_IsValid(Character) then return nil end
        
        local BoneLoc = AK_PlayerMapMarker.GetCharacterLocation(Character)
        if BoneLoc then
            local heightOffset = 65
            pcall(function()
                if Character.bIsCrouched then heightOffset = 40 end
                if Character.IsProne and Character:IsProne() then heightOffset = 15 end
            end)
            BoneLoc = AK_PlayerMapMarker.ApplyWorldOffset(BoneLoc, heightOffset + (AK_PlayerMapMarker.ESPWorldOffsetZ or 0))
        end
        
        return BoneLoc
    end

    function AK_PlayerMapMarker.GetCharacterWeaponInfo(Character)
        if not AK_IsValid(Character) then return nil end

        local WeaponID = nil
        local WeaponName = nil
        local WeaponIconPath = nil
        local WeaponIconTexture = nil
        local CurrentWeapon = nil

        pcall(function()
            if Character.GetCurrentWeapon then
                CurrentWeapon = Character:GetCurrentWeapon()
            end
        end)
        
        if not CurrentWeapon then
            pcall(function()
                CurrentWeapon = Character.CurrentWeapon
            end)
        end

        if not CurrentWeapon then
            pcall(function()
                if Character.GetWeaponManager then
                    local WM = Character:GetWeaponManager()
                    if WM and WM.GetCurrentWeapon then
                        CurrentWeapon = WM:GetCurrentWeapon()
                    end
                end
            end)
        end

        if not CurrentWeapon then
            pcall(function()
                if Character.GetInventoryComponent then
                    local IC = Character:GetInventoryComponent()
                    if IC and IC.GetCurrentWeapon then
                        CurrentWeapon = IC:GetCurrentWeapon()
                    end
                end
            end)
        end

        if CurrentWeapon and AK_IsValid(CurrentWeapon) then
            pcall(function()
                if CurrentWeapon.GetWeaponID then
                    WeaponID = CurrentWeapon:GetWeaponID()
                end
            end)
            if not WeaponID then
                pcall(function()
                    WeaponID = CurrentWeapon.WeaponID
                end)
            end
            if not WeaponID then
                pcall(function()
                    if CurrentWeapon.GetItemID then
                        WeaponID = CurrentWeapon:GetItemID()
                    end
                end)
            end
            
            pcall(function()
                if CurrentWeapon.GetWeaponName then
                    WeaponName = CurrentWeapon:GetWeaponName()
                end
            end)
            if not WeaponName then
                pcall(function()
                    WeaponName = CurrentWeapon.WeaponName
                end)
            end
            
            pcall(function()
                if CurrentWeapon.GetWeaponIconPath then
                    WeaponIconPath = CurrentWeapon:GetWeaponIconPath()
                end
            end)
            if not WeaponIconPath then
                pcall(function()
                    WeaponIconPath = CurrentWeapon.IconPath
                end)
            end
            
            pcall(function()
                if CurrentWeapon.GetWeaponIcon then
                    WeaponIconTexture = CurrentWeapon:GetWeaponIcon()
                end
            end)
            if not WeaponIconTexture then
                pcall(function()
                    WeaponIconTexture = CurrentWeapon.IconTexture
                end)
            end
        end

        if not WeaponID then
            pcall(function()
                local PS = nil
                if Character.GetPlayerStateSafety then
                    PS = Character:GetPlayerStateSafety()
                elseif Character.GetPlayerState then
                    PS = Character:GetPlayerState()
                end
                if PS and AK_IsValid(PS) then
                    if PS.GetCurrentWeaponID then WeaponID = PS:GetCurrentWeaponID() end
                    if not WeaponID and PS.CurrentWeaponID then WeaponID = PS.CurrentWeaponID end
                    if not WeaponID and PS.WeaponID then WeaponID = PS.WeaponID end
                    if not WeaponID and PS.HoldWeaponID then WeaponID = PS.HoldWeaponID end
                    if not WeaponID and PS.CurWeaponID then WeaponID = PS.CurWeaponID end
                    if not WeaponID and PS.EquipWeaponID then WeaponID = PS.EquipWeaponID end
                end
            end)
        end
        
        if not WeaponID then
            pcall(function()
                if Character.WeaponID then WeaponID = Character.WeaponID end
                if not WeaponID and Character.CurrentWeaponID then WeaponID = Character.CurrentWeaponID end
                if not WeaponID and Character.HoldWeaponID then WeaponID = Character.HoldWeaponID end
                if not WeaponID and Character.CurWeaponID then WeaponID = Character.CurWeaponID end
                if not WeaponID and Character.EquipWeaponID then WeaponID = Character.EquipWeaponID end
                if not WeaponID and Character.WeaponManagerComponent then
                    local WMC = Character.WeaponManagerComponent
                    if WMC.CurrentWeaponID then WeaponID = WMC.CurrentWeaponID end
                    if not WeaponID and WMC.WeaponID then WeaponID = WMC.WeaponID end
                    if not WeaponID and WMC.HoldWeaponID then WeaponID = WMC.HoldWeaponID end
                    if not WeaponID and WMC.CurWeaponID then WeaponID = WMC.CurWeaponID end
                end
            end)
        end

        return {
            WeaponID = WeaponID,
            WeaponName = WeaponName,
            WeaponIconPath = WeaponIconPath,
            WeaponIconTexture = WeaponIconTexture,
            CurrentWeapon = CurrentWeapon,
        }
    end

    function AK_PlayerMapMarker.FindWeaponIconInWidget(WidgetObj, Depth, MaxDepth)
        if not WidgetObj or not slua.isValid(WidgetObj) then return nil end
        Depth = Depth or 0
        MaxDepth = MaxDepth or 8

        local propNames = {
            "Image_Weapon", "Image_WeaponIcon", "Image_Gun", "Image_Icon",
            "WeaponIcon", "WeaponImage", "WeaponIconImage",
            "Image_Equip", "Image_WeaponIcon_2", "Image_WeaponIcon2",
        }
        
        for _, pname in ipairs(propNames) do
            pcall(function()
                local prop = WidgetObj[pname]
                if prop and slua.isValid(prop) then
                    local hasBrush = false
                    pcall(function() if prop.Brush then hasBrush = true end end)
                    if hasBrush then
                        return prop
                    end
                end
            end)
        end

        if Depth >= MaxDepth then
            return nil
        end

        local nChildren = 0
        pcall(function()
            if WidgetObj.GetChildrenCount then nChildren = WidgetObj:GetChildrenCount() end
        end)

        for i = 0, math.max(nChildren - 1, 0) do
            local child = nil
            pcall(function() child = WidgetObj:GetChildAt(i) end)
            if child and slua.isValid(child) then
                local result = AK_PlayerMapMarker.FindWeaponIconInWidget(child, Depth + 1, MaxDepth)
                if result then return result end
            end
        end

        if nChildren == 0 then
            local Root = AK_PlayerMapMarker._GetWidgetRoot(WidgetObj)
            if Root and slua.isValid(Root) and Root ~= WidgetObj then
                local result = AK_PlayerMapMarker.FindWeaponIconInWidget(Root, Depth + 1, MaxDepth)
                if result then return result end
            end
        end

        return nil
    end

    function AK_PlayerMapMarker.FixWeaponIconBrushSize(ImageWidget, DefaultW, DefaultH)
        if not ImageWidget or not slua.isValid(ImageWidget) then return end
        
        DefaultW = DefaultW or 138
        DefaultH = DefaultH or 69
        
        pcall(function()
            local brush = ImageWidget.Brush
            if brush then
                brush.ImageSize = FVector2D(DefaultW, DefaultH)
                brush.DrawAs = 3
                brush.TintColor = FLinearColor(1.0, 1.0, 1.0, 1.0)
                if ImageWidget.SetBrush then
                    ImageWidget:SetBrush(brush)
                end
            end
            
            if ImageWidget.SetDesiredSizeOverride then
                ImageWidget:SetDesiredSizeOverride(FVector2D(DefaultW, DefaultH))
            end
            
            local slot = ImageWidget.Slot
            if slot and slot.SetSize then
                slot:SetSize(FVector2D(DefaultW, DefaultH))
            end
            
            ImageWidget:SetWidgetVisibility(UEnums.ESlateVisibility.SelfHitTestInvisible)
            ImageWidget:SetRenderOpacity(1.0)
            ImageWidget:SetColorAndOpacity(FLinearColor(1.0, 1.0, 1.0, 1.0))
        end)
    end

    function AK_PlayerMapMarker.ApplyWeaponIconFullOpacity(Container, ourWeaponIcon)
        local fullIcon = FLinearColor(1.0, 1.0, 1.0, 1.0)

        if not ourWeaponIcon or not slua.isValid(ourWeaponIcon) then return end

        pcall(function()
            if ourWeaponIcon.SetRenderOpacity then ourWeaponIcon:SetRenderOpacity(1.0) end
        end)
        pcall(function()
            if ourWeaponIcon.SetColorAndOpacity then ourWeaponIcon:SetColorAndOpacity(fullIcon) end
        end)
        pcall(function()
            if ourWeaponIcon.SetBrushTintColor then ourWeaponIcon:SetBrushTintColor(fullIcon) end
        end)
        pcall(function()
            if ourWeaponIcon.SetTintColorAndOpacity then ourWeaponIcon:SetTintColorAndOpacity(fullIcon) end
        end)
        
        pcall(function()
            local brush = ourWeaponIcon.Brush
            if brush then
                pcall(function() brush.TintColor = fullIcon end)
                if ourWeaponIcon.SetBrush then ourWeaponIcon:SetBrush(brush) end
            end
        end)

        local chainNames = {"Border_WeaponColor", "Border_Weapon", "Border_WeaponIcon",
            "SizeBox_Weapon", "ScaleBox_Weapon", "Switcher_WeaponIcon"}
        for _, pname in ipairs(chainNames) do
            pcall(function()
                local node = Container and Container[pname]
                if node and slua.isValid(node) and node.SetRenderOpacity then
                    node:SetRenderOpacity(1.0)
                end
                if node and slua.isValid(node) and node.SetColorAndOpacity then
                    node:SetColorAndOpacity(fullIcon)
                end
            end)
        end
    end

    function AK_PlayerMapMarker.ApplyWeaponIconToImage(ImageWidget, winfo)
        if not ImageWidget or not slua.isValid(ImageWidget) then
            return false, "no_widget"
        end
        if not winfo or not winfo.WeaponID then
            return false, "no_weapon_id"
        end

        local iconPath = nil
        local method = "none"
        local bHasAddKnownMissing = false
        local defaultW = 138
        local defaultH = 69

        pcall(function()
            local itemRecord = CDataTable.GetTableData("Item", winfo.WeaponID)
            if itemRecord and itemRecord.KillWhiteIcon and itemRecord.KillWhiteIcon ~= "" then
                iconPath = itemRecord.KillWhiteIcon
                method = "KillWhiteIcon"
            end

            if (not iconPath or iconPath == "") and winfo.WeaponIconPath and winfo.WeaponIconPath ~= "" then
                iconPath = winfo.WeaponIconPath
                method = "WeaponIconPath"
            end

            if (not iconPath or iconPath == "") and winfo.WeaponIconTexture and slua.isValid(winfo.WeaponIconTexture) then
                if ImageWidget.SetBrushFromTexture then
                    ImageWidget:SetBrushFromTexture(winfo.WeaponIconTexture, true)
                    method = "WeaponIconTexture"
                    return
                end
            end

            if not iconPath or iconPath == "" then
                local UIUtil = require("client.common.ui_util")
                iconPath, bHasAddKnownMissing = UIUtil.GetItemBigIcon(winfo.WeaponID, ImageWidget)
                if iconPath and iconPath ~= "" then
                    method = "GetItemBigIcon"
                end
            end

            if not iconPath or iconPath == "" then
                local UIUtil = require("client.common.ui_util")
                iconPath = UIUtil.GetItemSmallIcon(winfo.WeaponID, ImageWidget, bHasAddKnownMissing)
                if iconPath and iconPath ~= "" then
                    method = "GetItemSmallIcon"
                end
            end
        end)

        if method == "WeaponIconTexture" then
            AK_PlayerMapMarker.FixWeaponIconBrushSize(ImageWidget, defaultW, defaultH)
            return true, method
        end
        
        if not iconPath or iconPath == "" then
            return false, "no_path"
        end

        local bOK = false
        pcall(function()
            if ImageWidget.SetBrushResourceFromPathSync then
                ImageWidget:SetBrushResourceFromPathSync(iconPath, true)
                bOK = true
            end
            
            if not bOK then
                local util = require("client.slua_ui_framework.util")
                local result = util.SetTexture(ImageWidget, iconPath, {
                    sync = true,
                    bMatchSize = true,
                    bIsInCombatState = true,
                    bHasAddKnownMissing = bHasAddKnownMissing,
                })
                bOK = result ~= nil
            end
            
            if not bOK then
                local tex = import(iconPath)
                if tex and slua.isValid(tex) and ImageWidget.SetBrushFromTexture then
                    ImageWidget:SetBrushFromTexture(tex, true)
                    bOK = true
                end
            end
            
            if not bOK then
                local LoadObject = import("LoadObject")
                if LoadObject then
                    local tex = LoadObject(iconPath)
                    if tex and slua.isValid(tex) and ImageWidget.SetBrushFromTexture then
                        ImageWidget:SetBrushFromTexture(tex, true)
                        bOK = true
                    end
                end
            end
        end)

        if bOK then
            AK_PlayerMapMarker.FixWeaponIconBrushSize(ImageWidget, defaultW, defaultH)
        end

        return bOK, method .. ":" .. tostring(iconPath)
    end

    function AK_PlayerMapMarker.CopyWeaponIconBrushFromNative(ourWeaponIcon, nativeWeaponIcon)
        if not ourWeaponIcon or not slua.isValid(ourWeaponIcon) then return false end
        if not nativeWeaponIcon or not slua.isValid(nativeWeaponIcon) then return false end

        local bCopied = false
        
        pcall(function()
            local nBrush = nativeWeaponIcon.Brush
            if nBrush then
                local resObj = nil
                pcall(function() resObj = nBrush.ResourceObject end)
                if resObj and slua.isValid(resObj) and ourWeaponIcon.SetBrushFromTexture then
                    ourWeaponIcon:SetBrushFromTexture(resObj, true)
                    bCopied = true
                end
                
                if bCopied then
                    local imgSize = nil
                    pcall(function() imgSize = nBrush.ImageSize end)
                    if imgSize then
                        local oBrush = ourWeaponIcon.Brush
                        if oBrush then
                            oBrush.ImageSize = imgSize
                            if ourWeaponIcon.SetBrush then
                                ourWeaponIcon:SetBrush(oBrush)
                            end
                        end
                    end
                end
            end
        end)

        return bCopied
    end

    function AK_PlayerMapMarker.AddWeaponIconToESP(WidgetData, Character)
        if not WidgetData or not WidgetData.Container then return end
        local Container = WidgetData.Container
        if not slua.isValid(Container) then return end

        if _G.AK_GetVal and _G.AK_GetVal("ESP_WEAPON") ~= 1 then
            local names = {"WeaponIcon", "Image_Weapon", "Border_Weapon", "Switcher_WeaponIcon", "SizeBox_Weapon"}
            for _, n in ipairs(names) do
                if Container[n] and slua.isValid(Container[n]) then
                    pcall(function() Container[n]:SetWidgetVisibility(UEnums.ESlateVisibility.Collapsed) end)
                end
            end
            return
        end

        pcall(function()
            local eWeapon = Character:GetCurrentWeapon()
            local wepID = 0
            if slua.isValid(eWeapon) then
                local def = eWeapon:GetItemDefineID()
                wepID = def and def.TypeSpecificID or 0
            end

            if wepID == 0 then
                local names = {"WeaponIcon", "Image_Weapon", "Border_Weapon", "Switcher_WeaponIcon", "SizeBox_Weapon"}
                for _, n in ipairs(names) do
                    if Container[n] and slua.isValid(Container[n]) then
                        pcall(function() Container[n]:SetWidgetVisibility(UEnums.ESlateVisibility.Collapsed) end)
                    end
                end
                return
            end

            pcall(function() if Container.UpdateWeapon then Container:UpdateWeapon(wepID) end end)
            pcall(function() if Container.SetWeaponID then Container:SetWeaponID(wepID) end end)

            local iconWidget = Container.WeaponIcon or Container.Image_Weapon or Container.Image_Gun
            if not iconWidget or not slua.isValid(iconWidget) then
                iconWidget = AK_PlayerMapMarker.FindWeaponIconInWidget(Container, 0, 6)
            end

            if slua.isValid(iconWidget) then
                local ItemData = CDataTable.GetTableData("Item", wepID)
                if ItemData and ItemData.ItemWhiteIcon and ItemData.ItemWhiteIcon ~= "" then
                    
                    iconWidget:SetWidgetVisibility(UEnums.ESlateVisibility.SelfHitTestInvisible)
                    iconWidget:SetBrushFromPathAsync(ItemData.ItemWhiteIcon, false)
                    pcall(function() iconWidget:SetColorAndOpacity(import("LinearColor")(1,1,1,1)) end)
                    pcall(function() iconWidget:SetRenderOpacity(1.0) end)
                    
                    local brush = slua.IndexReference(iconWidget, "Brush")
                    if brush then
                        brush.ImageSize = import("Vector2D")(128, 64)
                        if iconWidget.SetBrush then iconWidget:SetBrush(brush) end
                    end

                    local parent = iconWidget
                    for i = 1, 7 do
                        if not parent or not slua.isValid(parent) then break end
                        pcall(function()
                            if parent.GetParent then
                                local p = parent:GetParent()
                                if slua.isValid(p) then
                                    p:SetWidgetVisibility(UEnums.ESlateVisibility.SelfHitTestInvisible)
                                    pcall(function() p:SetRenderOpacity(1.0) end)
                                    
                                    if string.find(tostring(p), "WidgetSwitcher") then
                                        local count = p:GetChildrenCount()
                                        for j = 0, count - 1 do
                                            local child = p:GetChildAt(j)
                                            if child == parent or tostring(child) == tostring(parent) then
                                                p:SetActiveWidgetIndex(j)
                                                break
                                            end
                                        end
                                    end
                                    parent = p
                                else
                                    parent = nil
                                end
                            else
                                parent = nil
                            end
                        end)
                    end
                end
            end
        end)
    end

    AK_PlayerMapMarker._OBHeadWidgetClass = nil
    AK_PlayerMapMarker._OBHeadWidgetLoadFailed = false
    AK_PlayerMapMarker._bDumpedWidgetChildren = false

    function AK_PlayerMapMarker.CreateESPWidget()
        if not AK_PlayerMapMarker.ESPCanvas or not Game:IsValid(AK_PlayerMapMarker.ESPCanvas) then
            return nil
        end

        if AK_PlayerMapMarker._OBHeadWidgetLoadFailed then
            return nil
        end

        if not AK_PlayerMapMarker._OBHeadWidgetClass then
            pcall(function()
                local Path = "/Game/BluePrints/UI/OBUI/Item/OB_PlayerHeadHPItem_UIBP.OB_PlayerHeadHPItem_UIBP"
                local uClass = slua.loadClass(Path)
                if uClass then
                    AK_PlayerMapMarker._OBHeadWidgetClass = uClass
                end
            end)
            if not AK_PlayerMapMarker._OBHeadWidgetClass then
                AK_PlayerMapMarker._OBHeadWidgetLoadFailed = true
                return nil
            end
        else
            local bValid = false
            pcall(function() bValid = slua.isValid(AK_PlayerMapMarker._OBHeadWidgetClass) end)
            if not bValid then
                AK_PlayerMapMarker._OBHeadWidgetLoadFailed = true
                AK_PlayerMapMarker._OBHeadWidgetClass = nil
                return nil
            end
        end

        local Widget = nil
        pcall(function()
            local STExtraBlueprintFunctionLibrary = import("STExtraBlueprintFunctionLibrary")
            local PC = AK_PlayerMapMarker.GetMyPlayerController()
            local OuterObj = AK_IsValid(PC) and PC.Object or AK_PlayerMapMarker.ESPCanvas
            Widget = STExtraBlueprintFunctionLibrary.CreateWidgetByClass(AK_PlayerMapMarker._OBHeadWidgetClass, OuterObj)
        end)

        if not Widget then
            return nil
        end

        pcall(function() Widget:SetWidgetVisibility(UEnums.ESlateVisibility.SelfHitTestInvisible) end)
        pcall(function() Widget:SetRenderOpacity(1.0) end)
        Widget._vis = 0

        local NameText = nil
        local HealthFill = nil
        local bIsOriginalProgressBar = false

        pcall(function()
            NameText = Widget.TextBlock_TeamName
            if NameText and slua.isValid(NameText) then
                pcall(function() NameText:SetWidgetVisibility(UEnums.ESlateVisibility.SelfHitTestInvisible) end)
            end
            if Widget.TextBlock_PlayerName and slua.isValid(Widget.TextBlock_PlayerName) then
                pcall(function() Widget.TextBlock_PlayerName:SetWidgetVisibility(UEnums.ESlateVisibility.SelfHitTestInvisible) end)
            end

            local WS_Type = Widget.WidgetSwitcher_Type
            local WS_Type2 = Widget.WidgetSwitcher_Type2
            if WS_Type and slua.isValid(WS_Type) then
                pcall(function()
                    if WS_Type.SetActiveWidgetIndex then
                        WS_Type:SetActiveWidgetIndex(AK_PlayerMapMarker.HPWidgetSwitcherTypeIndex)
                    end
                end)
            end
            if WS_Type2 and slua.isValid(WS_Type2) then
                pcall(function()
                    if WS_Type2.SetActiveWidgetIndex then
                        WS_Type2:SetActiveWidgetIndex(AK_PlayerMapMarker.HPWidgetSwitcherType2Index)
                    end
                end)
            end

            local SizeBox_HP = Widget.SizeBox_HP
            if SizeBox_HP and slua.isValid(SizeBox_HP) then
                pcall(function() SizeBox_HP:SetWidgetVisibility(UEnums.ESlateVisibility.SelfHitTestInvisible) end)
                pcall(function() SizeBox_HP:SetHeightOverride(6) end)
                pcall(function() SizeBox_HP:SetWidthOverride(100) end)

                local ExistingChild = nil
                pcall(function()
                    if SizeBox_HP.GetContent then
                        ExistingChild = SizeBox_HP:GetContent()
                    end
                end)
                if not ExistingChild then
                    pcall(function()
                        if SizeBox_HP.GetChildAt then
                            ExistingChild = SizeBox_HP:GetChildAt(0)
                        end
                    end)
                end

                if ExistingChild and slua.isValid(ExistingChild) then
                    pcall(function() ExistingChild:SetWidgetVisibility(UEnums.ESlateVisibility.SelfHitTestInvisible) end)
                    pcall(function() ExistingChild:SetRenderOpacity(1.0) end)

                    local FoundPB = AK_PlayerMapMarker.FindProgressBarInWidget(ExistingChild, 0, 5)
                    if FoundPB and slua.isValid(FoundPB) then
                        HealthFill = FoundPB
                        bIsOriginalProgressBar = true
                        pcall(function() FoundPB:SetWidgetVisibility(UEnums.ESlateVisibility.SelfHitTestInvisible) end)
                        pcall(function() FoundPB:SetRenderOpacity(1.0) end)
                    else
                        local PB = CGame:NewObjectFromPath("/Script/UMG.ProgressBar", ExistingChild)
                        if PB then
                            pcall(function() PB:SetFillColorAndOpacity(FLinearColor(0, 1, 0, 1)) end)
                            pcall(function() PB:SetPercent(1.0) end)
                            pcall(function() PB:SetWidgetVisibility(UEnums.ESlateVisibility.SelfHitTestInvisible) end)
                            pcall(function() PB:SetRenderOpacity(1.0) end)
                            pcall(function() PB:SetDesiredSizeOverride(FVector2D(100, 6)) end)
                            pcall(function() ExistingChild:AddChild(PB) end)
                            HealthFill = PB
                        end
                    end
                else
                    local PB = CGame:NewObjectFromPath("/Script/UMG.ProgressBar", SizeBox_HP)
                    if PB then
                        pcall(function() PB:SetFillColorAndOpacity(FLinearColor(0, 1, 0, 1)) end)
                        pcall(function() PB:SetPercent(1.0) end)
                        pcall(function() PB:SetWidgetVisibility(UEnums.ESlateVisibility.SelfHitTestInvisible) end)
                        pcall(function() PB:SetRenderOpacity(1.0) end)
                        pcall(function() PB:SetDesiredSizeOverride(FVector2D(100, 6)) end)

                        local bUsedSetContent = false
                        pcall(function()
                            if SizeBox_HP.SetContent then
                                SizeBox_HP:SetContent(PB)
                                bUsedSetContent = true
                            end
                        end)
                        if not bUsedSetContent then
                            pcall(function() SizeBox_HP:AddChild(PB) end)
                        end
                        HealthFill = PB
                    end
                end
            end
        end)

        local WidgetData = {
            Container = Widget,
            NameText = NameText,
            HealthFill = HealthFill,
            IsGameWidget = true,
            IsOriginalProgressBar = bIsOriginalProgressBar,
            HasChildren = (NameText ~= nil)
        }
        return WidgetData
    end

    AK_PlayerMapMarker._CanvasScaleX = 1.0
    AK_PlayerMapMarker._CanvasScaleY = 1.0
    AK_PlayerMapMarker._CanvasOffsetX = 0.0
    AK_PlayerMapMarker._CanvasOffsetY = 0.0

    function AK_PlayerMapMarker.UpdateCanvasTransform(PC)
        if not AK_PlayerMapMarker.ESPCanvas or not Game:IsValid(AK_PlayerMapMarker.ESPCanvas) then
            return
        end

        local success = false

        pcall(function()
            local SBL = SlateBlueprintLibrary
            if SBL and SBL.AbsoluteToLocal then
                local cg = AK_PlayerMapMarker.ESPCanvas:GetCachedGeometry()
                if cg then
                    local pt0 = SBL.AbsoluteToLocal(cg, FVector2D(0, 0))
                    local pt1 = SBL.AbsoluteToLocal(cg, FVector2D(100, 100))
                    if pt0 and pt1 then
                        AK_PlayerMapMarker._CanvasScaleX = (pt1.X - pt0.X) / 100
                        AK_PlayerMapMarker._CanvasScaleY = (pt1.Y - pt0.Y) / 100
                        AK_PlayerMapMarker._CanvasOffsetX = pt0.X
                        AK_PlayerMapMarker._CanvasOffsetY = pt0.Y
                        success = true
                    end
                end
            end
        end)

        if not success then
            pcall(function()
                local WLL = WidgetLayoutLibrary
                if WLL and WLL.ScreenToWidgetLocal then
                    local cg = AK_PlayerMapMarker.ESPCanvas:GetCachedGeometry()
                    if cg then
                        local pt0 = FVector2D(0, 0)
                        local pt1 = FVector2D(0, 0)
                        WLL.ScreenToWidgetLocal(PC, cg, FVector2D(0, 0), pt0)
                        WLL.ScreenToWidgetLocal(PC, cg, FVector2D(100, 100), pt1)
                        AK_PlayerMapMarker._CanvasScaleX = (pt1.X - pt0.X) / 100
                        AK_PlayerMapMarker._CanvasScaleY = (pt1.Y - pt0.Y) / 100
                        AK_PlayerMapMarker._CanvasOffsetX = pt0.X
                        AK_PlayerMapMarker._CanvasOffsetY = pt0.Y
                        success = true
                    end
                end
            end)
        end

        if not success then
            local scale = 1.0
            local WLL = WidgetLayoutLibrary
            if WLL and WLL.GetViewportScale then
                scale = WLL.GetViewportScale(PC) or 1.0
            end
            AK_PlayerMapMarker._CanvasScaleX = 1.0 / scale
            AK_PlayerMapMarker._CanvasScaleY = 1.0 / scale
            AK_PlayerMapMarker._CanvasOffsetX = 0
            AK_PlayerMapMarker._CanvasOffsetY = 0
        end
    end

    function AK_PlayerMapMarker.ScreenPixelToCanvasLocal(PC, ScreenPixelPos)
        if not ScreenPixelPos then return FVector2D(0, 0) end
        local scaleX = AK_PlayerMapMarker._CanvasScaleX or 1.0
        local scaleY = AK_PlayerMapMarker._CanvasScaleY or 1.0
        local offsetX = AK_PlayerMapMarker._CanvasOffsetX or 0
        local offsetY = AK_PlayerMapMarker._CanvasOffsetY or 0
        return FVector2D(ScreenPixelPos.X * scaleX + offsetX, ScreenPixelPos.Y * scaleY + offsetY)
    end

    function AK_PlayerMapMarker.ProjectWorldToCanvasLocal(PC, WorldLoc)
        if not AK_IsValid(PC) or not WorldLoc then return false, FVector2D(0, 0) end
        
        local ScreenPixelPos = FVector2D(0, 0)
        local bOK = false

        pcall(function()
            local res = PC:ProjectWorldLocationToScreen(WorldLoc, ScreenPixelPos, true)
            if res == true or res == 1 or (ScreenPixelPos and (ScreenPixelPos.X ~= 0 or ScreenPixelPos.Y ~= 0)) then
                bOK = true
            end
        end)

        if not bOK or not ScreenPixelPos or (ScreenPixelPos.X == 0 and ScreenPixelPos.Y == 0) then
            return false, FVector2D(0, 0)
        end

        local CanvasLocalPos = AK_PlayerMapMarker.ScreenPixelToCanvasLocal(PC, ScreenPixelPos)
        return true, CanvasLocalPos
    end

    function AK_PlayerMapMarker.GetDynamicViewportSize(PC)
        local width, height = 0, 0
        
        if AK_PlayerMapMarker.ESPCanvas and Game:IsValid(AK_PlayerMapMarker.ESPCanvas) then
            pcall(function()
                local cg = AK_PlayerMapMarker.ESPCanvas:GetCachedGeometry()
                if cg and cg.GetLocalSize then
                    local sz = cg:GetLocalSize()
                    if sz and sz.X and sz.X > 200 then
                        width = sz.X
                        height = sz.Y
                    end
                end
            end)
        end

        if width > 200 then return width, height end

        pcall(function()
            local WLL = WidgetLayoutLibrary
            if WLL and WLL.GetViewportSize then
                local sz = WLL.GetViewportSize(PC or AK_PlayerMapMarker.GetMyPlayerController())
                if sz and sz.X and sz.X > 200 then
                    width = sz.X
                    height = sz.Y
                end
            end
        end)

        if width > 200 then
            pcall(function()
                local WLL = WidgetLayoutLibrary
                if WLL and WLL.GetViewportScale then
                    local scale = WLL.GetViewportScale(PC or AK_PlayerMapMarker.GetMyPlayerController())
                    if scale and type(scale) == "number" and scale > 0 and scale ~= 1.0 then
                        width = width / scale
                        height = height / scale
                    end
                end
            end)
            return width, height
        end

        return AK_PlayerMapMarker._cachedViewportW or 1920, AK_PlayerMapMarker._cachedViewportH or 1080
    end

    function AK_PlayerMapMarker.UpdateESPPositionWithPC(Widget, WorldLoc, PC, CanvasPos)
        if not Widget or not AK_IsValid(PC) then return false end
        local Container = Widget.Container or Widget

        local bOnScreen = true
        if not CanvasPos then
            if not WorldLoc then return false end
            bOnScreen, CanvasPos = AK_PlayerMapMarker.ProjectWorldToCanvasLocal(PC, WorldLoc)
        end

        if not bOnScreen then
            if Container._vis ~= 2 then
                pcall(function() Container:SetWidgetVisibility(UEnums.ESlateVisibility.Collapsed) end)
                Container._vis = 2
            end
            return false
        end

        pcall(function()
            if AK_PlayerMapMarker.ESPCanvas and Game:IsValid(AK_PlayerMapMarker.ESPCanvas) then
                local ptr = tostring(Container)
                local Slot = AK_PlayerMapMarker.ESPWidgetPtrs[ptr]

                if not Slot or not slua.isValid(Slot) or type(Slot) == "boolean" then
                    local addedSlot = AK_PlayerMapMarker.ESPCanvas:AddChildToCanvas(Container)
                    if addedSlot and slua.isValid(addedSlot) then
                        Slot = addedSlot
                        AK_PlayerMapMarker.ESPWidgetPtrs[ptr] = addedSlot
                        if type(Widget) == "table" then
                            Widget.Slot = addedSlot
                        end
                        
                        pcall(function() Slot:SetAutoSize(true) end)
                        pcall(function() Slot.bAutoSize = true end)
                        local align = FVector2D(0.5, 1.0)
                        pcall(function() Slot.Alignment = align end)
                        pcall(function() Slot:SetAlignment(align) end)
                        pcall(function() Slot:SetAlignment(0.5, 1.0) end)
                        pcall(function() Slot:SetZOrder(AK_PlayerMapMarker.ESPWidgetZOrder or 20) end)
                    end
                end

                if Container._vis ~= 0 then
                    Container:SetWidgetVisibility(UEnums.ESlateVisibility.SelfHitTestInvisible)
                    Container._vis = 0
                end
                
                if not Widget._OffsetResetDone then
                    pcall(function() Container:SetRenderTranslation(FVector2D(0.0, 0.0)) end)
                    if Widget and type(Widget) == "table" then
                        if Widget.NameText and slua.isValid(Widget.NameText) then
                            pcall(function() Widget.NameText:SetRenderTranslation(FVector2D(0.0, 0.0)) end)
                        end
                        if Widget.HealthFill and slua.isValid(Widget.HealthFill) then
                            pcall(function() Widget.HealthFill:SetRenderTranslation(FVector2D(0.0, 0.0)) end)
                        end
                    end
                    
                    pcall(function() Container.RenderTransformPivot = FVector2D(0.5, 1.0) end)
                    pcall(function() Container:SetRenderTransformPivot(FVector2D(0.5, 1.0)) end)
                    Widget._OffsetResetDone = true
                end

                if not Slot or not slua.isValid(Slot) or Slot == AK_PlayerMapMarker.ESPCanvas then
                    if Widget and type(Widget) == "table" and Widget.Slot and slua.isValid(Widget.Slot) then
                        Slot = Widget.Slot
                    elseif Container.Slot and slua.isValid(Container.Slot) then
                        Slot = Container.Slot
                    end
                end

                if Slot and slua.isValid(Slot) and Slot ~= AK_PlayerMapMarker.ESPCanvas then
                    local finalX = CanvasPos.X + (AK_PlayerMapMarker.ESPAnchorOffsetX or 0) - 25  
                    local finalY = CanvasPos.Y + (AK_PlayerMapMarker.ESPAnchorOffsetY or 0)
                    if Widget and type(Widget) == "table" then
                        if not Widget._CachedPosVec or math.abs(Widget._CachedPosVec.X - finalX) > 0.5 or math.abs(Widget._CachedPosVec.Y - finalY) > 0.5 then
                            Widget._CachedPosVec = Widget._CachedPosVec or FVector2D(finalX, finalY)
                            Widget._CachedPosVec.X = finalX
                            Widget._CachedPosVec.Y = finalY
                            pcall(function() Slot:SetPosition(Widget._CachedPosVec) end)
                        end
                    else
                        pcall(function() Slot:SetPosition(FVector2D(finalX, finalY)) end)
                    end
                end
            end
        end)
        return true
    end

    function AK_PlayerMapMarker.UpdateESPText(Widget, Text)
    end

    function AK_PlayerMapMarker.UpdateESPHealth(Widget, pct)
    end

    function AK_PlayerMapMarker.RemoveESPWidget(Widget)
        if not Widget then return end
        local Container = Widget.Container or Widget
        pcall(function()
            local ptr = tostring(Container)
            AK_PlayerMapMarker.ESPWidgetPtrs[ptr] = nil
            Container:RemoveFromParent()
            Container:ConditionalBeginDestroy()
        end)
    end

    function AK_PlayerMapMarker.CreateSnapLine()
        if not AK_PlayerMapMarker.ESPCanvas or not Game:IsValid(AK_PlayerMapMarker.ESPCanvas) then return nil end

        local Border = nil
        pcall(function()
            Border = CGame:NewObjectFromPath("/Script/UMG.Border", AK_PlayerMapMarker.ESPCanvas)
        end)
        if not Border or not slua.isValid(Border) then return nil end

        local color = AK_PlayerMapMarker.SnapLineColor or FLinearColor(1.0, 1.0, 1.0, AK_PlayerMapMarker.SnapLineOpacity or 0.7)
        pcall(function() Border:SetBrushColor(color) end)
        pcall(function() Border:SetWidgetVisibility(UEnums.ESlateVisibility.Collapsed) end)
        
        pcall(function() Border.RenderTransformPivot = FVector2D(0.0, 0.5) end)
        pcall(function() Border:SetRenderTransformPivot(FVector2D(0.0, 0.5)) end)

        local Slot = nil
        pcall(function()
            Slot = AK_PlayerMapMarker.ESPCanvas:AddChildToCanvas(Border)
            if Slot then
                Slot:SetAutoSize(false)
                Slot:SetZOrder(1)
            end
        end)

        return { Widget = Border, Slot = Slot, _vis = 2 }
    end

    function AK_PlayerMapMarker.GetSnapLineStartPos(PC)
        local screenPixelW, screenPixelH = 0, 0
        local scale = 1.0

        pcall(function()
            if PC and PC.GetViewportSize then
                local vs = FVector2D(0, 0)
                PC:GetViewportSize(vs)
                if vs and vs.X and vs.X > 200 then
                    screenPixelW = vs.X
                    screenPixelH = vs.Y
                end
            end
        end)

        if screenPixelW <= 200 then
            pcall(function()
                local WLL = WidgetLayoutLibrary
                if WLL and WLL.GetViewportSize then
                    local vs = WLL.GetViewportSize(PC)
                    if vs and vs.X and vs.X > 200 then
                        screenPixelW = vs.X
                        screenPixelH = vs.Y
                    end
                end
            end)
        end

        pcall(function()
            local WLL = WidgetLayoutLibrary
            if WLL and WLL.GetViewportScale then
                local s = WLL.GetViewportScale(PC)
                if s and type(s) == "number" and s > 0 then scale = s end
            end
        end)

        if screenPixelW <= 200 then
            screenPixelW = (AK_PlayerMapMarker._cachedViewportW or 1920) * scale
            screenPixelH = (AK_PlayerMapMarker._cachedViewportH or 1080) * scale
        end

        if not AK_PlayerMapMarker._CachedTopCenterPixel then
            AK_PlayerMapMarker._CachedTopCenterPixel = FVector2D(0, 0)
        end
        AK_PlayerMapMarker._CachedTopCenterPixel.X = screenPixelW / 2.0
        AK_PlayerMapMarker._CachedTopCenterPixel.Y = (AK_PlayerMapMarker.SnapLineOriginY or 50) * scale

        local fromCanvasPos = AK_PlayerMapMarker.ScreenPixelToCanvasLocal(PC, AK_PlayerMapMarker._CachedTopCenterPixel)
        local fromX = fromCanvasPos.X + (AK_PlayerMapMarker.SnapLineOriginOffsetX or 0)
        local fromY = fromCanvasPos.Y

        return fromX, fromY
    end

    function AK_PlayerMapMarker.UpdateSnapLine(KeyStr, CanvasPos, bOnScreen, fromX, fromY, color)
        if not AK_PlayerMapMarker.bUseSnapLines then return end
        if not AK_PlayerMapMarker.ESPCanvas or not Game:IsValid(AK_PlayerMapMarker.ESPCanvas) then return end

        local LineData = AK_PlayerMapMarker.SnapLineWidgets[KeyStr]

        if not bOnScreen or not CanvasPos then
            if LineData and LineData.Widget and slua.isValid(LineData.Widget) and LineData._vis ~= 2 then
                pcall(function() LineData.Widget:SetWidgetVisibility(UEnums.ESlateVisibility.Collapsed) end)
                LineData._vis = 2
            end
            return
        end

        local bIsNew = false
        if not LineData then
            LineData = AK_PlayerMapMarker.CreateSnapLine()
            if not LineData or not LineData.Widget or not LineData.Slot then return end
            AK_PlayerMapMarker.SnapLineWidgets[KeyStr] = LineData
            bIsNew = true
        end

        local Widget = LineData.Widget
        local Slot = LineData.Slot

        if LineData._vis ~= 0 then
            pcall(function() Widget:SetWidgetVisibility(UEnums.ESlateVisibility.SelfHitTestInvisible) end)
            LineData._vis = 0
        end
        
        if color then
            pcall(function() Widget:SetBrushColor(color) end)
        end
        
        if not LineData._PivotSet then
            pcall(function() Widget.RenderTransformPivot = FVector2D(0.0, 0.5) end)
            pcall(function() Widget:SetRenderTransformPivot(FVector2D(0.0, 0.5)) end)
            LineData._PivotSet = true
        end

        local toX = CanvasPos.X + (AK_PlayerMapMarker.SnapLineHeadOffsetX or 0)
        local toY = CanvasPos.Y + (AK_PlayerMapMarker.SnapLineHeadOffsetY or 0)

        local dx = toX - fromX
        local dy = toY - fromY
        local length = math.sqrt(dx * dx + dy * dy)
        local thickness = AK_PlayerMapMarker.SnapLineThickness or 1.5

        local angle_rad = 0
        if math.atan2 then angle_rad = math.atan2(dy, dx) else angle_rad = math.atan(dy, dx) end
        local angle = angle_rad * (180.0 / math.pi)

        if not LineData._CachedPosVec then
            LineData._CachedPosVec = FVector2D(fromX, fromY - thickness / 2.0)
            LineData._CachedSizeVec = FVector2D(length, thickness)
        else
            LineData._CachedPosVec.X = fromX
            LineData._CachedPosVec.Y = fromY - thickness / 2.0
            LineData._CachedSizeVec.X = length
            LineData._CachedSizeVec.Y = thickness
        end

        pcall(function() 
            Slot:SetPosition(LineData._CachedPosVec) 
            Slot:SetSize(LineData._CachedSizeVec)
            if bIsNew then Slot:SetZOrder(1) end
        end)
        pcall(function() Widget:SetRenderAngle(angle) end)
    end

    function AK_PlayerMapMarker.RemoveSnapLine(KeyStr)
        local LineData = AK_PlayerMapMarker.SnapLineWidgets[KeyStr]
        if LineData and LineData.Widget and slua.isValid(LineData.Widget) then
            pcall(function()
                LineData.Widget:RemoveFromParent()
                LineData.Widget:ConditionalBeginDestroy()
            end)
            AK_PlayerMapMarker.SnapLineWidgets[KeyStr] = nil
        end
    end

    function AK_PlayerMapMarker.ClearAllSnapLines()
        for KeyStr, LineData in pairs(AK_PlayerMapMarker.SnapLineWidgets) do
            if LineData and LineData.Widget and slua.isValid(LineData.Widget) then
                pcall(function()
                    LineData.Widget:RemoveFromParent()
                    LineData.Widget:ConditionalBeginDestroy()
                end)
            end
        end
        AK_PlayerMapMarker.SnapLineWidgets = {}
    end

    function AK_PlayerMapMarker.ClearAllESP()
        AK_RedBoxOverlay.Stop()

        for KeyStr, Data in pairs(AK_PlayerMapMarker.ESPWidgets) do
            AK_PlayerMapMarker.RemoveESPWidget(Data.Widget)
        end
        AK_PlayerMapMarker.ESPWidgets = {}
        AK_PlayerMapMarker.ESPWidgetPtrs = {}
        AK_PlayerMapMarker.ClearAllSnapLines()
        
        for KeyStr, box in pairs(AK_PlayerMapMarker.BoxWidgets or {}) do
            AK_PlayerMapMarker.Remove2DBox(KeyStr)
        end
        AK_PlayerMapMarker.BoxWidgets = {}

        for KeyStr, hpBox in pairs(AK_PlayerMapMarker.HealthWidgets or {}) do
            if hpBox.bg and slua.isValid(hpBox.bg.Widget) then pcall(function() hpBox.bg.Widget:RemoveFromParent(); hpBox.bg.Widget:ConditionalBeginDestroy() end) end
            if hpBox.fg and slua.isValid(hpBox.fg.Widget) then pcall(function() hpBox.fg.Widget:RemoveFromParent(); hpBox.fg.Widget:ConditionalBeginDestroy() end) end
        end
        AK_PlayerMapMarker.HealthWidgets = {}

        for KeyStr, tBox in pairs(AK_PlayerMapMarker.CustomTextWidgets or {}) do
            if tBox.topTxt and slua.isValid(tBox.topTxt.Widget) then pcall(function() tBox.topTxt.Widget:RemoveFromParent(); tBox.topTxt.Widget:ConditionalBeginDestroy() end) end
            if tBox.nameTxt and slua.isValid(tBox.nameTxt.Widget) then pcall(function() tBox.nameTxt.Widget:RemoveFromParent(); tBox.nameTxt.Widget:ConditionalBeginDestroy() end) end
            if tBox.distTxt and slua.isValid(tBox.distTxt.Widget) then pcall(function() tBox.distTxt.Widget:RemoveFromParent(); tBox.distTxt.Widget:ConditionalBeginDestroy() end) end
            if tBox.botTxt and slua.isValid(tBox.botTxt.Widget) then pcall(function() tBox.botTxt.Widget:RemoveFromParent(); tBox.botTxt.Widget:ConditionalBeginDestroy() end) end
        end
        AK_PlayerMapMarker.CustomTextWidgets = {}
        
        for _, lineData in pairs(AK_PlayerMapMarker.SkeletonWidgets or {}) do pcall(function() lineData.Widget:RemoveFromParent() end) end
        AK_PlayerMapMarker.SkeletonWidgets = {}
        
        if AK_PlayerMapMarker.ESPCanvas and Game:IsValid(AK_PlayerMapMarker.ESPCanvas) then
            pcall(function()
                local n = AK_PlayerMapMarker.ESPCanvas:GetChildrenCount()
                for i = n - 1, 0, -1 do
                    local child = AK_PlayerMapMarker.ESPCanvas:GetChildAt(i)
                    if child and slua.isValid(child) then
                        if AK_PlayerMapMarker.IsOurESPWidget(child) then
                            AK_PlayerMapMarker.ESPCanvas:RemoveChild(child)
                        end
                    end
                end
            end)
        end
        
        if _G.AK_EnvWidgets then
            for k, wData in pairs(_G.AK_EnvWidgets) do
                if wData and slua.isValid(wData.Widget) then
                    pcall(function() wData.Widget:RemoveFromParent(); wData.Widget:ConditionalBeginDestroy() end)
                end
            end
            _G.AK_EnvWidgets = {}
        end

        AK_PlayerMapMarker.ESPCanvas = nil
        AK_PlayerMapMarker._OBHeadWidgetClass = nil
        AK_PlayerMapMarker._OBHeadWidgetLoadFailed = false
        AK_PlayerMapMarker._bDumpedWidgetChildren = false
        AK_PlayerMapMarker._cachedViewportW = 1920
        AK_PlayerMapMarker._cachedViewportH = 1080
    end

    function AK_PlayerMapMarker.ScanAndUpdate()
        if _G.AK_GetVal and _G.AK_GetVal("ESP_FULL_INFO") ~= 1 then
            AK_PlayerMapMarker.ClearAllESP()
            return 0
        end

        local AllChars = AK_PlayerMapMarker.GetAllCharacters()
        if not AllChars then
            AK_RedBoxOverlay.SetCounts(0, 0, 0)
            return 0
        end

        local MyKey = AK_PlayerMapMarker.GetMyPlayerKey()
        local MyLoc = AK_PlayerMapMarker.GetMyLocation()

        local MyChar = nil
        pcall(function()
            local GDP = AK_PlayerMapMarker.GetGameplayData()
            if GDP and GDP.GetLocalCharacter then MyChar = GDP.GetLocalCharacter()
            else local PC = AK_PlayerMapMarker.GetMyPlayerController(); if PC and PC.GetPawn then MyChar = PC:GetPawn() end end
        end)
        local MyTeamID = AK_PlayerMapMarker.GetTeamID(MyChar)

        local realPlayers = 0
        local botPlayers = 0
        local near400 = 0 

        for PlayerKey, Character in pairs(AllChars) do
            if AK_IsValid(Character) then
                local bIsMe = AK_PlayerMapMarker.IsMe(Character, PlayerKey, MyKey)
                local bIsAlive = AK_PlayerMapMarker.IsAlive(Character)

                if bIsAlive and not bIsMe then
                    local bIsMyTeam = false
                    if MyTeamID ~= nil then
                        if AK_PlayerMapMarker.GetTeamID(Character) == MyTeamID then bIsMyTeam = true end
                    end
                    
                    if not bIsMyTeam then
                        local isNormalBot, isMLBot = false, false
                        if _G.AK_CheckIsBot then isNormalBot, isMLBot = _G.AK_CheckIsBot(Character) end
                        
                        if isNormalBot or isMLBot then botPlayers = botPlayers + 1 else realPlayers = realPlayers + 1 end
                        
                        local Loc = AK_PlayerMapMarker.GetCharacterLocation(Character)
                        if Loc and MyLoc then
                            local d = AK_PlayerMapMarker.CalcDistance(MyLoc, Loc) / 100.0
                            if d <= 400.0 then near400 = near400 + 1 end
                        end
                    end
                end
            end
        end

        if _G.AK_GetVal and _G.AK_GetVal("ESP_COUNT_BOX") == 1 then
            if AK_RedBoxOverlay.bActive then AK_RedBoxOverlay.SetCounts(realPlayers, botPlayers, near400)
            else AK_RedBoxOverlay.Start() end
        else
            AK_RedBoxOverlay.Stop()
        end

        if AK_PlayerMapMarker.bUseScreenMark then
            AK_PlayerMapMarker.SetupScreenMarkConfig()
        end

        if AK_PlayerMapMarker.bUseScreenESP then
            AK_PlayerMapMarker.UpdateESP(AllChars, MyLoc)
            return 0
        end

        if AK_PlayerMapMarker.bUseWidgetComponent then
            AK_PlayerMapMarker.UpdateWidgetComps(AllChars, MyLoc)
            return 0
        end

        local nCount = 0
        local nMarked = 0
        local nNewMarks = 0
        local nUpdated = 0
        local SeenKeys = {}

        for PlayerKey, Character in pairs(AllChars) do
            if AK_IsValid(Character) then
                local bIsMe = AK_PlayerMapMarker.IsMe(Character, PlayerKey, MyKey)
                local bIsAI = AK_PlayerMapMarker.IsAI(Character)
                local bIsAlive = AK_PlayerMapMarker.IsAlive(Character)
                local KeyStr = tostring(PlayerKey)
                local Name = AK_PlayerMapMarker.GetPlayerName(Character)
                local Loc = AK_PlayerMapMarker.GetCharacterLocation(Character)

                local DistStr = ""
                if _G.AK_GetVal and _G.AK_GetVal("ESP_DISTANCE") == 1 then
                    AK_PlayerMapMarker.bShowDistance = true
                else
                    AK_PlayerMapMarker.bShowDistance = false
                end

                if AK_PlayerMapMarker.bShowDistance and MyLoc and Loc then
                    DistStr = AK_PlayerMapMarker.GetDistanceString(MyLoc, Loc)
                end

                local MarkText = Name
                if DistStr and DistStr ~= "" then
                    MarkText = Name .. " [" .. DistStr .. "]"
                end

                nCount = nCount + 1
                SeenKeys[KeyStr] = true

                local bSkip = false
                if bIsMe and not AK_PlayerMapMarker.bIncludeMe then bSkip = true end
                if bIsAI and not AK_PlayerMapMarker.bIncludeAI then bSkip = true end

                if not bSkip and Loc then
                    local ExistingMark = AK_PlayerMapMarker.MarkMap[KeyStr]

                    if AK_PlayerMapMarker.bUseQuickSign then
                        if ExistingMark then
                            AK_PlayerMapMarker.RemoveQuickSignMark(ExistingMark)
                        end
                        local MsgID = AK_PlayerMapMarker.CreateQuickSignMark(Loc)
                        if MsgID then
                            AK_PlayerMapMarker.MarkMap[KeyStr] = MsgID
                            AK_PlayerMapMarker.PlayerInfo[KeyStr] = {
                                Name = Name, bIsAlive = bIsAlive, bIsAI = bIsAI, bIsMe = bIsMe, LastDistStr = DistStr,
                            }
                            nMarked = nMarked + 1
                            if not ExistingMark then nNewMarks = nNewMarks + 1 else nUpdated = nUpdated + 1 end
                        end
                    elseif AK_PlayerMapMarker.bUseNavigator then
                        if not ExistingMark then
                            local NavInstID = AK_PlayerMapMarker.CreateNavigatorMark(Loc)
                            if NavInstID then
                                AK_PlayerMapMarker.MarkMap[KeyStr] = NavInstID
                                AK_PlayerMapMarker.PlayerInfo[KeyStr] = {
                                    Name = Name, bIsAlive = bIsAlive, bIsAI = bIsAI, bIsMe = bIsMe, LastDistStr = DistStr,
                                }
                                nMarked = nMarked + 1
                                nNewMarks = nNewMarks + 1
                            end
                        else
                            AK_PlayerMapMarker.UpdateNavigatorMark(ExistingMark, Loc)
                            nMarked = nMarked + 1
                            nUpdated = nUpdated + 1
                            local OldInfo = AK_PlayerMapMarker.PlayerInfo[KeyStr]
                            if OldInfo then
                                OldInfo.Name = Name
                                OldInfo.bIsAlive = bIsAlive
                                OldInfo.LastDistStr = DistStr
                            end
                        end
                    else
                        if not ExistingMark then
                            local InstID = AK_PlayerMapMarker.CreateMark(Loc, MarkText, Character)
                            if InstID then
                                AK_PlayerMapMarker.MarkMap[KeyStr] = InstID
                                AK_PlayerMapMarker.ShowMark(InstID)
                                AK_PlayerMapMarker.PlayerInfo[KeyStr] = {
                                    Name = Name, bIsAlive = bIsAlive, bIsAI = bIsAI, bIsMe = bIsMe, LastDistStr = DistStr,
                                }
                                nMarked = nMarked + 1
                                nNewMarks = nNewMarks + 1
                            end
                        else
                            if not AK_PlayerMapMarker.bUseScreenMark then
                                AK_PlayerMapMarker.UpdateMarkLocation(ExistingMark, Loc)
                            end
                            AK_PlayerMapMarker.UpdateMarkString(ExistingMark, MarkText)
                            nMarked = nMarked + 1
                            nUpdated = nUpdated + 1
                            local OldInfo = AK_PlayerMapMarker.PlayerInfo[KeyStr]
                            if OldInfo then
                                OldInfo.Name = Name
                                OldInfo.bIsAlive = bIsAlive
                                OldInfo.LastDistStr = DistStr
                            end
                        end
                    end
                elseif bSkip and AK_PlayerMapMarker.MarkMap[KeyStr] then
                    if AK_PlayerMapMarker.bUseQuickSign then
                        AK_PlayerMapMarker.RemoveQuickSignMark(AK_PlayerMapMarker.MarkMap[KeyStr])
                    elseif AK_PlayerMapMarker.bUseNavigator then
                        AK_PlayerMapMarker.RemoveNavigatorMark(AK_PlayerMapMarker.MarkMap[KeyStr])
                    else
                        AK_PlayerMapMarker.HideMark(AK_PlayerMapMarker.MarkMap[KeyStr])
                    end
                    AK_PlayerMapMarker.MarkMap[KeyStr] = nil
                    AK_PlayerMapMarker.PlayerInfo[KeyStr] = nil
                end
            end
        end

        for KeyStr, MarkID in pairs(AK_PlayerMapMarker.MarkMap) do
            if not SeenKeys[KeyStr] then
                if AK_PlayerMapMarker.bUseQuickSign then
                    AK_PlayerMapMarker.RemoveQuickSignMark(MarkID)
                elseif AK_PlayerMapMarker.bUseNavigator then
                    AK_PlayerMapMarker.RemoveNavigatorMark(MarkID)
                else
                    AK_PlayerMapMarker.HideMark(MarkID)
                end
                AK_PlayerMapMarker.MarkMap[KeyStr] = nil
                AK_PlayerMapMarker.PlayerInfo[KeyStr] = nil
            end
        end

        return nCount
    end

    function AK_PlayerMapMarker.UpdateESP(AllPlayers, MyLoc)
        if not AK_PlayerMapMarker.bUseScreenESP then return end

        if not AK_PlayerMapMarker.InitESPCanvas() then
            return
        end

        if AK_PlayerMapMarker._OBHeadWidgetLoadFailed then return end

        local PC = AK_PlayerMapMarker.GetMyPlayerController()
        if AK_IsValid(PC) then
            AK_PlayerMapMarker.UpdateCanvasTransform(PC)
        end

        AK_PlayerMapMarker.bUseSnapLines = (_G.AK_GetVal and _G.AK_GetVal("ESP_LINE") == 1)

        local fromX, fromY = 0, 0
        if AK_PlayerMapMarker.bUseSnapLines and AK_IsValid(PC) then
            fromX, fromY = AK_PlayerMapMarker.GetSnapLineStartPos(PC)
        end

        local MyKey = AK_PlayerMapMarker.GetMyPlayerKey()
        local SeenKeys = {}
        
        local MyChar = nil
        pcall(function()
            local GDP = AK_PlayerMapMarker.GetGameplayData()
            if GDP and GDP.GetLocalCharacter then
                MyChar = GDP.GetLocalCharacter()
            else
                if PC and PC.GetPawn then MyChar = PC:GetPawn() end
            end
        end)
        local MyTeamID = AK_PlayerMapMarker.GetTeamID(MyChar)

        for PlayerKey, Character in pairs(AllPlayers) do
            if AK_IsValid(Character) then
                local bIsMe = AK_PlayerMapMarker.IsMe(Character, PlayerKey, MyKey)
                local bIsAI = AK_PlayerMapMarker.IsAI(Character)
                local KeyStr = tostring(PlayerKey)
                local isNormalBot, isMLBot = false, false
                if _G.AK_CheckIsBot then isNormalBot, isMLBot = _G.AK_CheckIsBot(Character) end
                
                local Name = "BOT"
                if not (isNormalBot or isMLBot) then
                    Name = AK_PlayerMapMarker.GetPlayerName(Character)
                end

                local Loc = AK_PlayerMapMarker.GetESPLocation(Character)

                local DistStr = ""
                if _G.AK_GetVal and _G.AK_GetVal("ESP_DISTANCE") == 1 then
                    AK_PlayerMapMarker.bShowDistance = true
                else
                    AK_PlayerMapMarker.bShowDistance = false
                end

                if MyLoc and Loc and AK_PlayerMapMarker.bShowDistance then
                    DistStr = AK_PlayerMapMarker.GetDistanceString(MyLoc, Loc)
                end

                local bSkip = false
                if bIsMe and not AK_PlayerMapMarker.bIncludeMe then bSkip = true end
                if bIsAI and not AK_PlayerMapMarker.bIncludeAI then bSkip = true end
                
                local TeamID = AK_PlayerMapMarker.GetTeamID(Character)
                if MyTeamID ~= nil and TeamID == MyTeamID and not bIsMe then
                    bSkip = true
                end

                local bIsAlive = AK_PlayerMapMarker.IsAlive(Character)

                if not bSkip and Loc then
                    SeenKeys[KeyStr] = true
                    local ESPData = AK_PlayerMapMarker.ESPWidgets[KeyStr]

                    local TeamID = ESPData and ESPData.TeamID or AK_PlayerMapMarker.GetTeamID(Character)
                    local Text = ""
                    if _G.AK_GetVal and _G.AK_GetVal("ESP_TEAMID") == 1 and TeamID then
                        Text = tostring(TeamID) .. "  " .. Name
                    else
                        Text = Name
                    end
                    if DistStr and DistStr ~= "" then
                        Text = Text .. "  [" .. DistStr .. "]"
                    end

                    if not ESPData then
                        local Widget = AK_PlayerMapMarker.CreateESPWidget()
                        if Widget then
                            AK_PlayerMapMarker.ESPWidgets[KeyStr] = {
                                Widget = Widget,
                                Character = Character,
                                Name = Name,
                                LastDistStr = DistStr,
                                TeamID = TeamID,
                            }
                            if bIsAlive then
                                AK_PlayerMapMarker.ApplyTeamColor(Widget, TeamID)
                            else
                                local Container = Widget.Container or Widget
                                pcall(function() Container:SetWidgetVisibility(UEnums.ESlateVisibility.Collapsed) end)
                                Container._vis = 2
                            end
                        end
                    else
                        ESPData.Character = Character
                        ESPData.Name = Name
                        ESPData.LastDistStr = DistStr
                        if bIsAlive then
                            if TeamID ~= ESPData.TeamID then
                                ESPData.TeamID = TeamID
                                AK_PlayerMapMarker.ApplyTeamColor(ESPData.Widget, TeamID)
                            end
                        else
                            local Container = ESPData.Widget.Container or ESPData.Widget
                            if Container._vis ~= 2 then
                                pcall(function() Container:SetWidgetVisibility(UEnums.ESlateVisibility.Collapsed) end)
                                Container._vis = 2
                            end
                        end
                    end
                end
            end
        end

        for KeyStr, Data in pairs(AK_PlayerMapMarker.ESPWidgets) do
            if not SeenKeys[KeyStr] then
                AK_PlayerMapMarker.RemoveESPWidget(Data.Widget)
                AK_PlayerMapMarker.ESPWidgets[KeyStr] = nil
                
                AK_PlayerMapMarker.RemoveSnapLine(KeyStr)
                AK_PlayerMapMarker.Remove2DBox(KeyStr)
            end
        end
    end
    
  
    function AK_PlayerMapMarker.UpdateEnvESPLight()
        if _G.AK_GetVal and _G.AK_GetVal("ESP_FULL_INFO") ~= 1 then return end
        local pc = AK_PlayerMapMarker.GetMyPlayerController()
        local myLoc = AK_PlayerMapMarker.GetMyLocation()
        local canvas = AK_PlayerMapMarker.ESPCanvas
        if not AK_IsValid(pc) or not myLoc or not slua.isValid(canvas) then return end

        local seenWidgets = {}

        local function DrawEnvUMG(key, actor, textStr, r, g, b, scale, zOffset)
            _G.AK_EnvWidgets = _G.AK_EnvWidgets or {}
            local wData = _G.AK_EnvWidgets[key]
            
            local bOnScreen, screenPos = false, import("Vector2D")(0,0)
            pcall(function()
                local loc = actor:K2_GetActorLocation()
                loc.Z = loc.Z + zOffset
                local res = pc:ProjectWorldLocationToScreen(loc, screenPos, true)
                if res == true or res == 1 then bOnScreen = true end
            end)

            if not bOnScreen then
                if wData and slua.isValid(wData.Widget) and wData._vis ~= 2 then 
                    pcall(function() wData.Widget:SetWidgetVisibility(UEnums.ESlateVisibility.Collapsed) end); wData._vis = 2
                end
                return
            end

            seenWidgets[key] = true

            if not wData then
                local txt = nil
                pcall(function() txt = CGame:NewObjectFromPath("/Script/UMG.TextBlock", canvas) end)
                if txt and slua.isValid(txt) then
                    pcall(function() txt.RenderTransformPivot = import("Vector2D")(0.5, 0.5) end)
                    local slot = canvas:AddChildToCanvas(txt)
                    if slot then
                        slot:SetAutoSize(true); slot:SetAlignment(import("Vector2D")(0.5, 0.5)); slot:SetZOrder(1)
                        wData = { Widget = txt, Slot = slot, _vis = 0 }
                        _G.AK_EnvWidgets[key] = wData
                    end
                end
            end

            if wData and slua.isValid(wData.Widget) then
                if wData._vis ~= 0 then pcall(function() wData.Widget:SetWidgetVisibility(UEnums.ESlateVisibility.SelfHitTestInvisible) end); wData._vis = 0 end
                
                if wData._lastTxt ~= textStr then
                    pcall(function() wData.Widget:SetText(textStr); wData.Widget:SetJustification(1) end)
                    wData._lastTxt = textStr
                end

                pcall(function()
                    local col = import("LinearColor")(r/255.0, g/255.0, b/255.0, 1.0)
                    local FSlateColor = import("SlateColor") or import("/Script/SlateCore.SlateColor")
                    if FSlateColor then wData.Widget:SetColorAndOpacity(FSlateColor(col)) else wData.Widget:SetColorAndOpacity(col) end
                    
                    if not wData._fInit then
                        local f = wData.Widget.Font
                        f.Size = 11; f.OutlineSettings.OutlineSize = 1; f.OutlineSettings.OutlineColor = import("LinearColor")(0,0,0,1)
                        wData.Widget:SetFont(f); wData._fInit = true
                    end
                    wData.Widget:SetRenderScale(import("Vector2D")(scale, scale))
                end)

                local cvsPos = AK_PlayerMapMarker.ScreenPixelToCanvasLocal(pc, screenPos)
                if not wData._cPos or math.abs(wData._cPos.X - cvsPos.X) > 0.05 or math.abs(wData._cPos.Y - cvsPos.Y) > 0.05 then
                    wData._cPos = cvsPos
                    pcall(function() wData.Slot:SetPosition(cvsPos) end)
                end
            end
        end

        if _G.AK_GetVal("ESP_CAR") == 1 and _G.AK_CachedCars then
            for _, veh in ipairs(_G.AK_CachedCars) do
                if slua.isValid(veh) then
                    local dist = AK_PlayerMapMarker.CalcDistance(myLoc, veh:K2_GetActorLocation()) / 100.0
                    if dist <= 400 then
                        local dynamicScale = math.max(0.6, 1.0 - (dist / 400))
                        local vehName = "PHƯƠNG TIỆN"; local r,g,b = 200,200,200
                        pcall(function()
                            local className = import("KismetSystemLibrary").GetClassDisplayName(veh:GetClass())
                            if string.find(className, "MotorcycleCart") or string.find(className, "SideCar") then vehName = "MOTOR 3 BÁNH"; r,g,b = 255,215,0
                            elseif string.find(className, "Glider") then vehName = "TÀU LƯỢN"; r,g,b = 255,250,205
                            elseif string.find(className, "Motorcycle") or string.find(className, "Motor") then vehName = "MOTOR 2 BÁNH"; r,g,b = 255,255,0
                            elseif string.find(className, "CoupeRB") or string.find(className, "SportsCar") then vehName = "COUPE RB"; r,g,b = 0,250,154
                            elseif string.find(className, "UAZ") then vehName = "UAZ"; r,g,b = 0,255,0
                            elseif string.find(className, "Dacia") then vehName = "DACIA"; r,g,b = 0,191,255
                            elseif string.find(className, "Buggy") then vehName = "BUGGY"; r,g,b = 255,20,147
                            elseif string.find(className, "Mirado") then vehName = "MIRADO"; r,g,b = 255,140,0
                            elseif string.find(className, "Scooter") then vehName = "SCOOTER"; r,g,b = 135,206,235
                            elseif string.find(className, "Boat") or string.find(className, "PG117") then vehName = "CA NÔ"; r,g,b = 0,0,255
                            end
                        end)
                        local infoStr = vehName .. "\n[" .. tostring(math.floor(dist)) .. "m]"
                        DrawEnvUMG("CAR_"..tostring(veh), veh, infoStr, r, g, b, dynamicScale, 100)
                    end
                end
            end
        end
        
        if _G.AK_GetVal("ESP_BOMB") == 1 and _G.AK_CachedBombs then
            local gameTime = 0.0
            pcall(function() gameTime = AK_PlayerMapMarker.GetCGameState():GetServerWorldTimeSeconds() end)
            if not _G.AK_BombTimers then _G.AK_BombTimers = {} end

            for _, bomb in ipairs(_G.AK_CachedBombs) do
                if slua.isValid(bomb) and not bomb.bExploded and not (bomb.bHidden or (bomb.Mesh and bomb.Mesh.bHidden)) then
                    local dist = AK_PlayerMapMarker.CalcDistance(myLoc, bomb:K2_GetActorLocation()) / 100.0
                    if dist <= 100 then
                        local itemID = 0
                        pcall(function()
                            local className = import("KismetSystemLibrary").GetClassDisplayName(bomb:GetClass())
                            if string.find(className, "Smoke") then itemID = 602002 
                            elseif string.find(className, "Burn") or string.find(className, "Molotov") then itemID = 602003 
                            elseif string.find(className, "Grenade") then itemID = 602004 end
                        end)

                        if itemID > 0 then
                            local dynamicScale = math.max(0.6, 1.0 - (dist / 100))
                            local infoStr = ""; local r,g,b = 255,255,255
                            local addr = tostring(bomb)

                            if itemID == 602004 then
                                if not _G.AK_BombTimers[addr] then _G.AK_BombTimers[addr] = gameTime end
                                local timeLeft = 7.0 - (gameTime - _G.AK_BombTimers[addr])
                                if timeLeft < 0 then timeLeft = 0.0 end
                                if timeLeft <= 2.0 then r,g,b = 255,0,0 else r,g,b = 255,165,0 end
                                infoStr = "[BOM NỔ]\n[" .. tostring(math.floor(timeLeft * 10) / 10) .. "s]\n[" .. tostring(math.floor(dist)) .. "m]"
                            elseif itemID == 602003 then
                                r,g,b = 255,69,0; infoStr = "[BOM LỬA]\n[" .. tostring(math.floor(dist)) .. "m]"
                            elseif itemID == 602002 then
                                r,g,b = 0,255,0; infoStr = "[BOM KHÓI]\n[" .. tostring(math.floor(dist)) .. "m]"
                            end

                            DrawEnvUMG("BOMB_"..addr, bomb, infoStr, r, g, b, dynamicScale * 1.2, 50)
                        end
                    end
                end
            end
        end

        if _G.AK_GetVal("ESP_ITEM") == 1 and _G.AK_CachedItems then
            if not _G.AK_LootedItems then _G.AK_LootedItems = {} end

            for _, data in ipairs(_G.AK_CachedItems) do
                local item = data.actor
                if slua.isValid(item) then
                    local isGhost = false
                    local addr = tostring(item)
                    
                    pcall(function() if item:IsPendingKill() then isGhost = true end end)
                    
                    if not isGhost then
                        local itemLoc = item:K2_GetActorLocation()
                        if (itemLoc.X == 0 and itemLoc.Y == 0) or itemLoc.Z < -5000 then
                            isGhost = true
                        end
                        
                        local dist = AK_PlayerMapMarker.CalcDistance(myLoc, itemLoc) / 100.0
                        
                        local isHidden = false
                        pcall(function()
                            isHidden = item.bHidden or item.bIsHidden
                            if not isHidden and item.Mesh then isHidden = item.Mesh.bHidden or false end
                            if not isHidden and type(item.IsHidden) == "function" then isHidden = item:IsHidden() end
                        end)
                        
                        if not data.isDrop then
                            if not isHidden then
                                _G.AK_LootedItems[addr] = nil
                            else
                                if dist < 12.0 then
                                    _G.AK_LootedItems[addr] = true
                                end
                            end
                            if _G.AK_LootedItems[addr] then isGhost = true end
                        else
                            if isHidden then isGhost = true end
                        end
                        
                        if not isGhost and dist > 0.1 and dist <= 150 then
                            local scaleDist = dist > 150 and 150 or dist
                            local dynamicScale = math.max(0.6, 1.0 - (scaleDist / 150))
                            local infoStr = "[" .. data.name .. "]\n[" .. tostring(math.floor(dist)) .. "m]"
                            DrawEnvUMG("ITEM_"..addr, item, infoStr, data.r, data.g, data.b, dynamicScale, 30)
                            seenWidgets["ITEM_"..addr] = true
                        end
                    end
                end
            end
        end

        if _G.AK_EnvWidgets then
            for k, wData in pairs(_G.AK_EnvWidgets) do
                if not seenWidgets[k] then
                    if wData and slua.isValid(wData.Widget) then
                        pcall(function() wData.Widget:RemoveFromParent(); wData.Widget:ConditionalBeginDestroy() end)
                    end
                    _G.AK_EnvWidgets[k] = nil
                end
            end
        end
    end
    

    function AK_PlayerMapMarker.UpdateESPLight()
        if _G.AK_GetVal and _G.AK_GetVal("ESP_FULL_INFO") ~= 1 then return end

        if AK_RedBoxOverlay.bActive then
            AK_RedBoxOverlay.UpdatePosition()
        end

        if not AK_PlayerMapMarker.bUseScreenESP then return end
        if not AK_PlayerMapMarker.ESPCanvas or not Game:IsValid(AK_PlayerMapMarker.ESPCanvas) then return end

        local PC = AK_PlayerMapMarker.GetMyPlayerController()
        if not AK_IsValid(PC) then return end

        AK_PlayerMapMarker.UpdateCanvasTransform(PC)

        AK_PlayerMapMarker.bUseSnapLines = (_G.AK_GetVal and _G.AK_GetVal("ESP_LINE") == 1)
        local fromX, fromY = 0, 0
        if AK_PlayerMapMarker.bUseSnapLines then
            fromX, fromY = AK_PlayerMapMarker.GetSnapLineStartPos(PC)
        end

        local MyLoc = AK_PlayerMapMarker.GetMyLocation()

        for KeyStr, ESPData in pairs(AK_PlayerMapMarker.ESPWidgets) do
            local Widget = ESPData.Widget
            local Character = ESPData.Character
            local Container = Widget and (Widget.Container or Widget)
            local bWidgetValid = false
            pcall(function() bWidgetValid = Container and slua.isValid(Container) end)

            if Widget and bWidgetValid and Character and AK_IsValid(Character) then
                local bIsAlive = AK_PlayerMapMarker.IsAlive(Character)

                if not bIsAlive then
                    if Container._vis ~= 2 then
                        pcall(function() Container:SetWidgetVisibility(UEnums.ESlateVisibility.Collapsed) end)
                        Container._vis = 2
                    end
                    AK_PlayerMapMarker.RemoveSnapLine(KeyStr)
                    AK_PlayerMapMarker.Remove2DBox(KeyStr)
                else
                    local rootLoc = AK_PlayerMapMarker.GetCharacterLocation(Character)
                    local topLoc = AK_PlayerMapMarker.GetESPLocation(Character)
                    
                    if rootLoc and topLoc then
                        local dist2D = 0
                        if MyLoc then
                            dist2D = AK_PlayerMapMarker.CalcDistance(MyLoc, rootLoc) / 100.0
                        end

                        rootLoc.Z = rootLoc.Z - 90
                        topLoc.Z = topLoc.Z + 15
                        
                        local bOnBot, botPos = AK_PlayerMapMarker.ProjectWorldToCanvasLocal(PC, rootLoc)
                        local bOnTop, topPos = AK_PlayerMapMarker.ProjectWorldToCanvasLocal(PC, topLoc)
                        
                        local isVisible = (bOnBot or bOnTop)
                        
                        if isVisible then
                            local estHeight = 18000 / math.max(dist2D, 1)
                            if estHeight > 3000 then estHeight = 3000 elseif estHeight < 15 then estHeight = 15 end
                            
                            if bOnBot and not bOnTop then
                                topPos = import("Vector2D")(botPos.X, botPos.Y - estHeight)
                            elseif bOnTop and not bOnBot then
                                botPos = import("Vector2D")(topPos.X, topPos.Y + estHeight)
                            end
                            
                            if botPos.Y < topPos.Y then
                                local tempY = botPos.Y
                                botPos.Y = topPos.Y
                                topPos.Y = tempY
                            end
                            
                            local height = botPos.Y - topPos.Y
                            
                            if height > 3000 then
                                botPos.Y = topPos.Y + 3000
                            end
                            
                            if dist2D > 650 then
                                isVisible = false
                            end
                        end

                        if isVisible then

                            if Container._vis ~= 0 then
                                pcall(function() Container:SetWidgetVisibility(UEnums.ESlateVisibility.SelfHitTestInvisible) end)
                                Container._vis = 0
                            end
                            
                            AK_PlayerMapMarker.UpdateESPPositionWithPC(Widget, topLoc, PC, topPos)
                            
                            if not ESPData.bCleanedUpUMG then
                                local hideNames = {"TextBlock_TeamID", "TextBlock_PlayerTeamID", "Text_TeamID", "TextBlock_Team", "Image_TeamBG", "Image_TeamLogoBG", "TeamBgBorder", "Image_RingBG", "Image_TeamBG_2", "SizeBox_HP"}
                                for _, name in ipairs(hideNames) do
                                    local w = Container[name]
                                    if w and slua.isValid(w) then pcall(function() w:SetWidgetVisibility(UEnums.ESlateVisibility.Collapsed) end) end
                                end
                                if Widget.NameText and slua.isValid(Widget.NameText) then pcall(function() Widget.NameText:SetWidgetVisibility(UEnums.ESlateVisibility.Collapsed) end) end
                                if Container.TextBlock_PlayerName and slua.isValid(Container.TextBlock_PlayerName) then pcall(function() Container.TextBlock_PlayerName:SetWidgetVisibility(UEnums.ESlateVisibility.Collapsed) end) end
                                if Container.TextBlock_TeamName and slua.isValid(Container.TextBlock_TeamName) then pcall(function() Container.TextBlock_TeamName:SetWidgetVisibility(UEnums.ESlateVisibility.Collapsed) end) end
                                ESPData.bCleanedUpUMG = true
                            end
                            
                            local bShowBox      = (_G.AK_GetVal("ESP_BOX") == 1)
                            local bShowHealth   = (_G.AK_GetVal("ESP_HEALTH") == 1)
                            local bShowName     = (_G.AK_GetVal("ESP_NAME") == 1)
                            local bShowDistance = (_G.AK_GetVal("ESP_DISTANCE") == 1)
                            local bShowTeam     = (_G.AK_GetVal("ESP_TEAMID") == 1)
                            local bShowLine     = (_G.AK_GetVal("ESP_LINE") == 1)

                            local isNormalBot, isMLBot = false, false
                            if _G.AK_CheckIsBot then isNormalBot, isMLBot = _G.AK_CheckIsBot(Character) end
                            local isBot = isNormalBot or isMLBot
                            local espColor = isBot and import("LinearColor")(1, 1, 1, 1) or import("LinearColor")(1, 0, 0, 1)

                            if bShowLine then
                                AK_PlayerMapMarker.UpdateSnapLine(KeyStr, topPos, isVisible, fromX, fromY, espColor)
                            else
                                AK_PlayerMapMarker.RemoveSnapLine(KeyStr)
                            end

                            AK_PlayerMapMarker.Update2DBox(KeyStr, topPos, botPos, espColor, isVisible and bShowBox)

                            local HP, MaxHP = 100, 100
                            pcall(function()
                                HP = type(Character.GetHealth) == "function" and Character:GetHealth() or Character.Health or 0
                                MaxHP = type(Character.GetHealthMax) == "function" and Character:GetHealthMax() or Character.MaxHealth or 100
                            end)
                            local pct = (HP > 0 and MaxHP > 0) and (HP / MaxHP) or 0
                            if pct > 1 then pct = 1 elseif pct < 0 then pct = 0 end
                            
                            AK_PlayerMapMarker.Update2DHealthBar(KeyStr, topPos, botPos, pct, isVisible and bShowHealth)

                          
                            local distStr   = bShowDistance and (ESPData.LastDistStr or "") or ""
                            local nameStr   = bShowName and (ESPData.Name or "Unknown") or ""
                            local teamIDStr = bShowTeam and (ESPData.TeamID and tostring(ESPData.TeamID) or "") or ""
                            
                            AK_PlayerMapMarker.Update2DTextData(KeyStr, topPos, botPos, nameStr, distStr, teamIDStr, isVisible, espColor)

 
                            AK_PlayerMapMarker.AddWeaponIconToESP(Widget, Character)

                        else

                            if Container._vis ~= 2 then
                                pcall(function() Container:SetWidgetVisibility(UEnums.ESlateVisibility.Collapsed) end)
                                Container._vis = 2
                            end
                            AK_PlayerMapMarker.RemoveSnapLine(KeyStr)
                            AK_PlayerMapMarker.Update2DBox(KeyStr, nil, nil, nil, false)
                            AK_PlayerMapMarker.Update2DHealthBar(KeyStr, nil, nil, 0, false)
                            AK_PlayerMapMarker.Update2DTextData(KeyStr, nil, nil, "", "", "", false, nil)
                        end
                    else
                        if Container._vis ~= 2 then
                            pcall(function() Container:SetWidgetVisibility(UEnums.ESlateVisibility.Collapsed) end)
                            Container._vis = 2
                        end
                        AK_PlayerMapMarker.RemoveSnapLine(KeyStr)
                        AK_PlayerMapMarker.Update2DBox(KeyStr, nil, nil, nil, false)
                        AK_PlayerMapMarker.Update2DHealthBar(KeyStr, nil, nil, 0, false)
                        AK_PlayerMapMarker.Update2DTextData(KeyStr, nil, nil, "", "", "", false, nil)
                    end
                end
            end
        end
    end

    function AK_PlayerMapMarker.UpdateESPDistances()
        if _G.AK_GetVal and _G.AK_GetVal("ESP_DISTANCE") ~= 1 then return end
        if not AK_PlayerMapMarker.bUseScreenESP then return end

        local MyLoc = AK_PlayerMapMarker.GetMyLocation()
        if not MyLoc then return end

        local PC = AK_PlayerMapMarker.GetMyPlayerController()
        if not AK_IsValid(PC) then return end

        AK_PlayerMapMarker.UpdateCanvasTransform(PC)

        for KeyStr, ESPData in pairs(AK_PlayerMapMarker.ESPWidgets) do
            local Character = ESPData.Character
            local Widget = ESPData.Widget
            local Container = Widget and (Widget.Container or Widget)
            local bWidgetValid = false
            pcall(function() bWidgetValid = Container and slua.isValid(Container) end)
            if Character and AK_IsValid(Character) and Widget and bWidgetValid then
                local Loc = AK_PlayerMapMarker.GetESPLocation(Character)
                if Loc then
                    local Dist = AK_PlayerMapMarker.CalcDistance(MyLoc, Loc)
                    ESPData.LastDistance = Dist

                    if AK_PlayerMapMarker.bShowDistance then
                        local DistStr = ""
                        local Meters = 0
                        if Dist then
                            Meters = Dist / 100
                            if Meters < 1000 then
                                DistStr = tostring(math.floor(Meters)) .. "m"
                            else
                                local kmFloor = math.floor((Meters / 1000) * 10) / 10
                                DistStr = tostring(kmFloor) .. "km"
                            end
                        end

                        ESPData.LastDistStr = DistStr
                    end
                end
            end
        end
    end

    function AK_PlayerMapMarker.OnTick(deltaTime)
        if not AK_PlayerMapMarker.bActive then return end

        pcall(function()
            local currentPC = AK_PlayerMapMarker.GetMyPlayerController()
            if AK_PlayerMapMarker._LastPC ~= currentPC then
                AK_PlayerMapMarker.ClearAllESP()
                AK_PlayerMapMarker._LastPC = currentPC
                AK_PlayerMapMarker.ESPCanvas = nil
            end

            AK_PlayerMapMarker._FrameCount = AK_PlayerMapMarker._FrameCount + 1
            local frame = AK_PlayerMapMarker._FrameCount

            if frame % AK_PlayerMapMarker.nHeavyScanFrameInterval == 0 then
                local AllChars = AK_PlayerMapMarker.GetAllCharacters()
                if AllChars then
                    local MyLoc = AK_PlayerMapMarker.GetMyLocation()
                    AK_PlayerMapMarker._CachedAllChars = AllChars
                    AK_PlayerMapMarker._CachedMyLoc = MyLoc
                    AK_PlayerMapMarker.UpdateESP(AllChars, MyLoc)
                end
            end

            if frame % AK_PlayerMapMarker.nDistanceUpdateFrameInterval == 0 then
                AK_PlayerMapMarker.UpdateESPDistances()
            end

            AK_PlayerMapMarker.UpdateESPLight()
        end)
    end

    AK_PlayerMapMarker._WorkingWidgetPath = nil
    AK_PlayerMapMarker._FailedWidgetPaths = {}

    AK_PlayerMapMarker.WidgetCompUIPaths = {
        "/Game/BluePrints/ControlInput/NewbieItem/NewbieTips_ConsumeTips.NewbieTips_ConsumeTips_C",
        "/Game/BluePrints/ControlInput/IngameUI/TipsItem/ChangeSight_Item01_UIBP.ChangeSight_Item01_UIBP_C",
        "/Game/Mod/PlanBT/BluePrints/UI/Fusion/FusionTitle_UIBP.FusionTitle_UIBP_C",
        "/Game/BluePrints/ControlInput/NewbieItem/NewbieTips_ConsumeTips.NewbieTips_ConsumeTips",
    }

    function AK_PlayerMapMarker.CreateWidgetCompForPlayer(Character, Text)
        if not AK_IsValid(Character) then return nil end
        local Mesh = AK_PlayerMapMarker.GetCharacterMesh(Character)
        if not Mesh or not Game:IsValid(Mesh) then return nil end

        if AK_PlayerMapMarker._bAllPathsFailed then return nil end

        local PathsToTry = {}
        if AK_PlayerMapMarker._WorkingWidgetPath then
            table.insert(PathsToTry, AK_PlayerMapMarker._WorkingWidgetPath)
        else
            for _, path in ipairs(AK_PlayerMapMarker.WidgetCompUIPaths) do
                if not AK_PlayerMapMarker._FailedWidgetPaths[path] then
                    table.insert(PathsToTry, path)
                end
            end
        end

        if #PathsToTry == 0 then
            AK_PlayerMapMarker._bAllPathsFailed = true
            return nil
        end

        local STExtraBlueprintFunctionLibrary = nil
        pcall(function() STExtraBlueprintFunctionLibrary = import("STExtraBlueprintFunctionLibrary") end)
        if not STExtraBlueprintFunctionLibrary then return nil end

        local Widget = nil
        local UsedPath = nil
        for _, path in ipairs(PathsToTry) do
            local ok = false
            pcall(function()
                Widget = STExtraBlueprintFunctionLibrary.CreateWidgetByPathName(path, Character)
                if Widget and slua.isValid(Widget) then ok = true end
            end)
            if ok and Widget then
                UsedPath = path
                AK_PlayerMapMarker._WorkingWidgetPath = path
                break
            else
                Widget = nil
                AK_PlayerMapMarker._FailedWidgetPaths[path] = true
            end
        end

        if not Widget then
            if not AK_PlayerMapMarker._WorkingWidgetPath then
                AK_PlayerMapMarker._bAllPathsFailed = true
            end
            return nil
        end

        local WidgetComp = nil
        pcall(function()
            local UWidgetComponent = import("WidgetComponent")
            WidgetComp = Game:AddComponent(UWidgetComponent, Character, "PlayerMapMarkerWidget")

            if WidgetComp and Game:IsValid(WidgetComp) then
                WidgetComp.AlwaysLoadOnClient = true
                WidgetComp.AlwaysLoadOnServer = false
                WidgetComp:SetOwnerNoSee(false)
                WidgetComp.bGenerateOverlapEvents = false
                WidgetComp.bCanEverAffectNavigation = false
                WidgetComp.bUseAttachParentBound = true
                WidgetComp.Space = 1

                pcall(function() WidgetComp:SetHiddenInGame(false) end)
                pcall(function() WidgetComp:SetVisibility(true) end)
                pcall(function() WidgetComp:SetComponentTickEnabled(true) end)

                pcall(function() WidgetComp:SetDrawSize(AK_PlayerMapMarker.WidgetCompDrawSize) end)
                WidgetComp:SetWidget(Widget)
                WidgetComp:RequestRedraw()

                WidgetComp:K2_AttachToComponent(
                    Mesh,
                    AK_PlayerMapMarker.WidgetCompBoneName,
                    UEnums.EAttachmentRule.SnapToTarget,
                    UEnums.EAttachmentRule.SnapToTarget,
                    UEnums.EAttachmentRule.KeepWorld,
                    false
                )

                local KismetMathLibrary = import("KismetMathLibrary")
                local Transform = KismetMathLibrary.MakeTransform(
                    AK_PlayerMapMarker.WidgetCompOffset,
                    FRotator(0, 180, 0),
                    FVector(1, 1, 1)
                )
                WidgetComp:K2_SetRelativeTransform(Transform, false, nil, false)

                local UserWidget = WidgetComp:GetUserWidgetObject()
                if UserWidget and Game:IsValid(UserWidget) then
                    pcall(function()
                        if UserWidget.PlayerName then
                            UserWidget.PlayerName:SetText(Text or "")
                        elseif UserWidget.TextTitle then
                            UserWidget.TextTitle:SetText(Text or "")
                        elseif UserWidget.UTRichTextBlock_Tips22_Text1 then
                            UserWidget.UTRichTextBlock_Tips22_Text1:SetText(Text or "")
                        end
                    end)
                end

                CGame:RegisterComponent(WidgetComp)
                pcall(function() WidgetComp:RequestRedraw() end)
            end
        end)

        if not WidgetComp or not Game:IsValid(WidgetComp) then
            if WidgetComp and Game:IsValid(WidgetComp) then
                pcall(function() WidgetComp:DestroyComponent() end)
            end
            return nil
        end

        return WidgetComp
    end

    function AK_PlayerMapMarker.UpdateWidgetCompText(WidgetComp, Text)
        if not WidgetComp or not Game:IsValid(WidgetComp) then return end
        pcall(function()
            local UserWidget = WidgetComp:GetUserWidgetObject()
            if UserWidget and Game:IsValid(UserWidget) then
                if UserWidget.PlayerName then
                    UserWidget.PlayerName:SetText(Text or "")
                elseif UserWidget.TextTitle then
                    UserWidget.TextTitle:SetText(Text or "")
                elseif UserWidget.UTRichTextBlock_Tips22_Text1 then
                    UserWidget.UTRichTextBlock_Tips22_Text1:SetText(Text or "")
                end
            end
        end)
    end

    function AK_PlayerMapMarker.RemoveWidgetComp(WidgetComp)
        if not WidgetComp then return end
        pcall(function()
            if Game:IsValid(WidgetComp) then
                WidgetComp:K2_DetachFromComponent(2, false)
                local UserWidget = WidgetComp:GetUserWidgetObject()
                if UserWidget and Game:IsValid(UserWidget) then
                    UserWidget:RemoveFromViewport()
                    UserWidget:ConditionalBeginDestroy()
                end
                WidgetComp:DestroyComponent()
            end
        end)
    end

    function AK_PlayerMapMarker.ClearAllWidgetComps()
        for KeyStr, WidgetComp in pairs(AK_PlayerMapMarker.WidgetComps) do
            AK_PlayerMapMarker.RemoveWidgetComp(WidgetComp)
        end
        AK_PlayerMapMarker.WidgetComps = {}
    end

    function AK_PlayerMapMarker.UpdateWidgetComps(AllPlayers, MyLoc)
        if not AK_PlayerMapMarker.bUseWidgetComponent then return end
        if AK_PlayerMapMarker._bAllPathsFailed then return end

        local MyKey = AK_PlayerMapMarker.GetMyPlayerKey()
        local SeenKeys = {}

        for PlayerKey, Character in pairs(AllPlayers) do
            if AK_IsValid(Character) then
                local bIsMe = AK_PlayerMapMarker.IsMe(Character, PlayerKey, MyKey)
                local bIsAI = AK_PlayerMapMarker.IsAI(Character)
                local KeyStr = tostring(PlayerKey)
                local Name = AK_PlayerMapMarker.GetPlayerName(Character)
                local Loc = AK_PlayerMapMarker.GetCharacterLocation(Character)

                local DistStr = ""
                if MyLoc and Loc then
                    DistStr = AK_PlayerMapMarker.GetDistanceString(MyLoc, Loc)
                end

                local bSkip = false
                if bIsMe and not AK_PlayerMapMarker.bIncludeMe then bSkip = true end
                if bIsAI and not AK_PlayerMapMarker.bIncludeAI then bSkip = true end

                if not bSkip then
                    SeenKeys[KeyStr] = true
                    local Text = Name
                    if DistStr and DistStr ~= "" then
                        Text = Name .. " [" .. DistStr .. "]"
                    end

                    local ExistingComp = AK_PlayerMapMarker.WidgetComps[KeyStr]
                    if not ExistingComp or not Game:IsValid(ExistingComp) then
                        local WidgetComp = AK_PlayerMapMarker.CreateWidgetCompForPlayer(Character, Text)
                        if WidgetComp then
                            AK_PlayerMapMarker.WidgetComps[KeyStr] = WidgetComp
                        end
                    else
                        AK_PlayerMapMarker.UpdateWidgetCompText(ExistingComp, Text)
                    end
                end
            end
        end

        for KeyStr, WidgetComp in pairs(AK_PlayerMapMarker.WidgetComps) do
            if not SeenKeys[KeyStr] then
                AK_PlayerMapMarker.RemoveWidgetComp(WidgetComp)
                AK_PlayerMapMarker.WidgetComps[KeyStr] = nil
            end
        end
    end

    function AK_PlayerMapMarker.CreateMark(Location, CustomString, Actor)
        if not AK_PlayerMapMarker.bUseScreenMark and not Location then return nil end

        local InstID = nil
        local Flag = AK_GetMapAddedFlag()

        local MarkPos = Location
        if AK_PlayerMapMarker.bUseScreenMark then
            MarkPos = nil
        end

        if AK_PlayerMapMarker.bUseServerMarks then
            pcall(function()
                InstID = InGameMarkTools.ServerAddMapMark(
                    AK_PlayerMapMarker.MarkTypeID,
                    MarkPos,
                    nil,
                    nil,
                    nil,
                    UEnums.EMarkDispatchRange.EMAMDT_ALL,
                    nil,
                    Actor
                )
            end)
        else
            pcall(function()
                local actorObj = Actor and (Actor.Object or Actor) or nil
                InstID = InGameMarkTools.ClientAddMapMark(
                    AK_PlayerMapMarker.MarkTypeID,
                    MarkPos,
                    0,
                    CustomString or "",
                    Flag,
                    actorObj,
                    0,
                    nil
                )
            end)
        end

        return InstID
    end

    function AK_PlayerMapMarker.UpdateMarkLocation(InstID, Location)
        if not InstID or not Location then return end
        pcall(function()
            InGameMarkTools.UpdateMapMarkLocation(InstID, Location)
        end)
    end

    function AK_PlayerMapMarker.HideMark(InstID)
        if not InstID then return end
        pcall(function()
            InGameMarkTools.HideMapMark(InstID)
        end)
    end

    function AK_PlayerMapMarker.ShowMark(InstID)
        if not InstID then return end
        pcall(function()
            InGameMarkTools.ShowMapMark(InstID)
        end)
    end

    function AK_PlayerMapMarker.UpdateMarkString(InstID, sName)
        if not InstID or not sName then return end
        pcall(function()
            InGameMarkTools.UpdateMapMarkCustomString(InstID, sName)
        end)
    end

    function AK_PlayerMapMarker.ClearAllMarks()
        for KeyStr, MarkID in pairs(AK_PlayerMapMarker.MarkMap) do
            if AK_PlayerMapMarker.bUseQuickSign then
                AK_PlayerMapMarker.RemoveQuickSignMark(MarkID)
            elseif AK_PlayerMapMarker.bUseNavigator then
                AK_PlayerMapMarker.RemoveNavigatorMark(MarkID)
            else
                AK_PlayerMapMarker.HideMark(MarkID)
            end
        end
        AK_PlayerMapMarker.MarkMap = {}
        AK_PlayerMapMarker.PlayerInfo = {}
        AK_PlayerMapMarker.ClearAllWidgetComps()
        AK_PlayerMapMarker.ClearAllESP()
    end

    function AK_PlayerMapMarker.AttachTimers()
        local ticker = package.loaded["common.time_ticker"] or require("common.time_ticker")
        if not ticker or not ticker.AddTimerLoop then return end

         
        if AK_PlayerMapMarker.MasterTimerHandle then 
            ticker.RemoveTimer(AK_PlayerMapMarker.MasterTimerHandle) 
            AK_PlayerMapMarker.MasterTimerHandle = nil
        end

        local frameCount = 0

 
        AK_PlayerMapMarker.MasterTimerHandle = ticker.AddTimerLoop(0, function()
            if not AK_PlayerMapMarker.bActive then return end

            pcall(function()
                frameCount = frameCount + 1
 
                AK_PlayerMapMarker.UpdateESPLight()
                AK_PlayerMapMarker.UpdateEnvESPLight()

 
                if frameCount % 6 == 0 then
                    if AK_PlayerMapMarker.bUseScreenESP and AK_PlayerMapMarker.bShowDistance then
                        AK_PlayerMapMarker.UpdateESPDistances()
                    end
                end

 
                if frameCount >= 30 then
                    local currentPC = AK_PlayerMapMarker.GetMyPlayerController()
                    if currentPC and AK_PlayerMapMarker._LastPC ~= currentPC then
                        AK_PlayerMapMarker.ClearAllESP()
                        AK_PlayerMapMarker._LastPC = currentPC
                        AK_PlayerMapMarker.ESPCanvas = nil
                    end

                    AK_PlayerMapMarker.ScanAndUpdate()
                    
                    frameCount = 0 
                end
            end)
        end, -1, 0.016)
    end

    function AK_PlayerMapMarker.Start()
        if AK_PlayerMapMarker.bActive then
            return
        end

        AK_PlayerMapMarker.bActive = true
        AK_PlayerMapMarker._FrameCount = 0

        AK_PlayerMapMarker.ScanAndUpdate()
        AK_PlayerMapMarker.AttachTimers()
    end

    function AK_PlayerMapMarker.Stop()
        AK_PlayerMapMarker.bActive = false
        AK_PlayerMapMarker._FrameCount = 0

        local ticker = package.loaded["common.time_ticker"] or require("common.time_ticker")
        if ticker then

            if AK_PlayerMapMarker.MasterTimerHandle then 
                ticker.RemoveTimer(AK_PlayerMapMarker.MasterTimerHandle)
                AK_PlayerMapMarker.MasterTimerHandle = nil 
            end
        end

        AK_PlayerMapMarker.ClearAllMarks()
    end

    function AK_PlayerMapMarker.Reset()
        AK_PlayerMapMarker.ClearAllMarks()
    end

    function AK_PlayerMapMarker.ManualScan()
        return AK_PlayerMapMarker.ScanAndUpdate()
    end

    _G.AK_PlayerMapMarker = AK_PlayerMapMarker
    AK_PlayerMapMarker.Start()
end

-- ==========================================
-- MAIN LOOP: EXTREMELY POWERFUL OPTIMIZED
-- ==========================================
local function MainLoop() 
    if isExpired then return end
    if not BRLicenseActive() then return end

    if _G.GTLMODState.CustomTextData == nil then 
        _G.GTLMODState.CustomTextData = {OuterSpeed = 10, InnerSpeed = 10, HRecoil = 0.3, VRecoil = 0.3, IpadViewFOV = 120, AimTouchHipPrio = 1, AimTouchHipBone = 1, AimTouchHipCond = 1, AimTouchHipSpeed = 50, AimTouchHipFOV = 30, AimTouchHipDist = 250, AimTouchSGPrio = 1, AimTouchSGBone = 2, AimTouchSGCond = 1, AimTouchSGSpeed = 80, AimTouchSGFOV = 40, AimTouchSGDist = 30, AimTouchScopePrio = 1, AimTouchScopeBone = 2, AimTouchScopeCond = 1, AimTouchScopeSpeed = 40, AimTouchScopeFOV = 20, AimTouchScopeDist = 300, AimTouchSniperPrio = 1, AimTouchSniperBone = 1, AimTouchSniperCond = 2, AimTouchSniperSpeed = 30, AimTouchSniperFOV = 20, AimTouchSniperDist = 400}
    end

    local okData, GameplayData = pcall(require, "GameLua.GameCore.Data.GameplayData") 
    if not okData or not GameplayData then return end 
    local pc = GameplayData.GetPlayerController() 
    local localPlayer = nil
    if Valid(pc) then localPlayer = pc:GetPlayerCharacterSafety() end 

    if not Valid(localPlayer) then 
        if _G.GTLMODState.TrackedMarks then
            for markId, _ in pairs(_G.GTLMODState.TrackedMarks) do
                SafeRemoveMark(markId)
            end
        end
        _G.GTLMODState.TrackedMarks = {} 
        
        for key, data in pairs(_G.GTLMODState.EnemyMarks) do
            if data and data.MIDs then
                for meshStr, midTable in pairs(data.MIDs) do
                    for k, _ in pairs(midTable) do midTable[k] = nil end
                end
                data.MIDs = nil
            end
        end
        
        _G.GTLMODState.EnemyMarks = {}
        _G.AK_OrigHitboxes = {}
        _G.AK_ModdedPhysAssets = {}
        _G.GTLMODState.PrevGraphicsState = {}
        return 
    end

    local Cached_PPM = nil
    pcall(function() Cached_PPM = import("PostProcessManager").GetInstance() end)
    local Cached_SecurityCommonUtils = nil
    pcall(function() Cached_SecurityCommonUtils = require("GameLua.Mod.BaseMod.Common.Security.SecurityCommonUtils") end)
    local Cached_MyHUD = pc and pc.MyHUD or nil

    if _G.GTLMODConfig.UnlockFPS then InitializeGraphicsUnlock() end
    _G.AK_ESP_VIP_Init = nil
    _G.InitAKESPVIP()
    ShowGTLMODVIPMenu()
    
    if _G.GTLMODConfig.IpadView and _G.GTLMODState.CustomTextData then
        pcall(function()
            local targetTPP = _G.GTLMODState.CustomTextData.IpadViewFOV or 120
            local uTPPCam = localPlayer.ThirdPersonCameraComponent
            if Valid(uTPPCam) and not localPlayer.bIsWeaponAiming then
                if uTPPCam.FieldOfView ~= targetTPP then uTPPCam.FieldOfView = targetTPP end
            end
        end)
    else
        pcall(function()
            local uTPPCam = localPlayer.ThirdPersonCameraComponent
            if Valid(uTPPCam) and not localPlayer.bIsWeaponAiming then
                if uTPPCam.FieldOfView ~= 80 then uTPPCam.FieldOfView = 80 end
            end
        end)
    end

    -- ========================================== 
    -- SKIN MOD LOOP - ULTIMATE FIX FOR 32-BIT
    -- (Suit, Weapon, Bag, Helmet, Vehicle, Pet - ALL SKINS WORK)
    -- ========================================== 
    if _G.GTLMODConfig.ModSkin then
        if not _G.TDSkinLoopStarted then
            if _G.InitializeSkinModSystem then _G.InitializeSkinModSystem() end
            if _G.ForceRefreshSkinMaps then _G.ForceRefreshSkinMaps() end
            _G.TDSkinLoopStarted = true
            if not _G.KillInfoCounterHacked and _G.ForceEnableKillCounterUI then _G.ForceEnableKillCounterUI() end
        end
        
        _G.GTLMODState.SkinWasApplied = true
        
        -- READ CONFIG (every 2 seconds)
        local curTime = os.clock()
        if not _G.LastSkinConfigRead or (curTime - _G.LastSkinConfigRead) > 2.0 then
            _G.LastSkinConfigRead = curTime
            if _G.ReadLiveConfig then _G.ReadLiveConfig() end
        end
        
        -- FORCE APPLY ALL SKINS (every frame)
        pcall(function()
            local isAlive = type(localPlayer.IsAlive) == "function" and localPlayer:IsAlive() or true
            if isAlive then
                if _G.equip_character_avatar then 
                    _G.equip_character_avatar(localPlayer) 
                end
                if _G.ApplyWeaponSkins then 
                    _G.ApplyWeaponSkins(localPlayer) 
                end
                if _G.ApplyVehicleSkins then 
                    _G.ApplyVehicleSkins(localPlayer) 
                end
                if _G.HandlePetLogic then 
                    _G.HandlePetLogic() 
                end
                if _G.DeadBox_TemperRequest and _G.NeedCheckDeadBoxTimer > 0 then 
                    _G.DeadBox_TemperRequest(pc) 
                end
                if localPlayer.AvatarComponent2 and type(localPlayer.AvatarComponent2.OnRep_BodySlotStateChanged) == "function" then
                    pcall(function()
                        localPlayer.AvatarComponent2:OnRep_BodySlotStateChanged()
                    end)
                end
            end
        end)
    else
        -- SKIN MOD OFF - RESTORE ORIGINAL SKINS
        if _G.GTLMODState.SkinWasApplied then
            _G.OutfitMap = {}
            _G.WeaponSkinMap = {}
            _G.VehicleSkinMap = {}
            pcall(function()
                local WeaponManager = localPlayer:GetWeaponManager()
                if Valid(WeaponManager) then
                    for slot = 1, 3 do
                        local Weapon = WeaponManager:GetInventoryWeaponByPropSlot(slot)
                        if Valid(Weapon) and Valid(Weapon.synData) then
                            local WeaponID = Weapon:GetWeaponID()
                            local SkinData = Weapon.synData:Get(7)
                            if SkinData and SkinData.defineID then
                                SkinData.defineID.TypeSpecificID = WeaponID
                                Weapon.synData:Set(7, SkinData)
                                if Weapon.SetWeaponAvatarID then pcall(function() Weapon:SetWeaponAvatarID(WeaponID) end) end
                                if Weapon.DelayHandleAvatarMeshChanged then pcall(function() Weapon:DelayHandleAvatarMeshChanged() end) end
                            end
                        end
                    end
                end
                local Vehicle = localPlayer:GetCurrentVehicle()
                if Valid(Vehicle) then
                    local VehicleAvatar = Vehicle.VehicleAvatar or Vehicle.VehicleAvatarComponent_BP or Vehicle:GetAvatarComponent()
                    if Valid(VehicleAvatar) and type(VehicleAvatar.GetDefaultAvatarID) == "function" then
                        local defId = VehicleAvatar:GetDefaultAvatarID()
                        if VehicleAvatar.ChangeItemAvatar then VehicleAvatar:ChangeItemAvatar(defId, true) end
                    end
                end
                if localPlayer.AvatarComponent2 and type(localPlayer.AvatarComponent2.OnRep_BodySlotStateChanged) == "function" then
                    localPlayer.AvatarComponent2:OnRep_BodySlotStateChanged()
                end
            end)
            _G.GTLMODState.SkinWasApplied = false
        end
        _G.TDSkinLoopStarted = false
    end

    -- ========================================== 
    -- Aimbot Force (Moved to separate loop)
    -- ========================================== 

    pcall(function()
        if _G.GTLMODConfig.CustomAimbot and localPlayer.bIsWeaponFiring and localPlayer.bIsGunADS then
            local outerRecoilVal = _G.GTLMODState.CustomTextData.OuterRecoil or 0
            if outerRecoilVal > 0 then
                local curTime = os.clock()
                
                if not _G.RecoilTargetCacheTime or (curTime - _G.RecoilTargetCacheTime) > 0.2 then
                    _G.RecoilTargetCacheTime = curTime
                    _G.HasRecoilTargetCached = false
                    
                    local ui_util = require("client.common.ui_util")
                    if ui_util then
                        local viewportSize = ui_util.GetViewportSize()
                        if viewportSize then
                            local centerX = viewportSize.X * 0.5
                            local centerY = viewportSize.Y * 0.5
                            local FOV_RADIUS = (6 / 100.0) * (viewportSize.X / 2.0) 
                            
                            local enemies = _G.GetEnemyTargetsFromActors(40000) 
                            if enemies and #enemies > 0 then
                                local FVector2D = import("Vector2D")
                                for _, target in ipairs(enemies) do
                                    if slua.isValid(target) and target.HealthStatus ~= 1 then 
                                        local tPos = type(target.K2_GetActorLocation) == "function" and target:K2_GetActorLocation() or nil
                                        if tPos then
                                            local screen = FVector2D()
                                            if pc:ProjectWorldLocationToScreen(tPos, screen, false) and screen.X > 0 and screen.Y > 0 then
                                                local dx = screen.X - centerX
                                                local dy = screen.Y - centerY
                                                if math.sqrt(dx*dx + dy*dy) <= FOV_RADIUS then
                                                    _G.HasRecoilTargetCached = true
                                                    break 
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end

                if _G.HasRecoilTargetCached then
                    local currentRot = pc:GetControlRotation()
                    if currentRot then
                        local pullDownForce = (outerRecoilVal / 50.0) * 1.5
                        currentRot.Pitch = currentRot.Pitch - pullDownForce
                        pc:SetControlRotation(currentRot, "CustomAimbotRecoil")
                    end
                end
            end
        else
            _G.HasRecoilTargetCached = false
        end
    end)

    pcall(function()
        if Valid(pc) then
            if pc.HiggsBoson then pc.HiggsBoson.bMHActive = false; pc.HiggsBoson.bCallPreReplication = false end
            if pc.HiggsBosonComponent then pc.HiggsBosonComponent.bMHActive = false; pc.HiggsBosonComponent.bCallPreReplication = false end
        end
    end)

    pcall(function()
        local autoComp = localPlayer.AutoAimComp
        if Valid(autoComp) then
            if not _G.GTLMODState.OrigAutoAimCompCached then
                _G.GTLMODState.OrigAutoAimCompCached = {
                    bOnlyHitHead = autoComp.bOnlyHitHead,
                    HeadBoneName = autoComp.HeadBoneName,
                    Bones = autoComp.Bones,
                    ChestBoneName = autoComp.ChestBoneName,
                    PelvisBoneName = autoComp.PelvisBoneName,
                    HeadPriority = autoComp.AimAssistConfig and autoComp.AimAssistConfig.HeadPriority,
                    ChestPriority = autoComp.AimAssistConfig and autoComp.AimAssistConfig.ChestPriority,
                    PelvisPriority = autoComp.AimAssistConfig and autoComp.AimAssistConfig.PelvisPriority
                }
            end
            
            if _G.GTLMODConfig.AutoHead then
                autoComp.bOnlyHitHead = true
                autoComp.HeadBoneName = "Head"
                pcall(function() autoComp.Bones = {"Head"} end)
                autoComp.ChestBoneName = "Head"
                autoComp.PelvisBoneName = "Head"
                if autoComp.AimAssistConfig then
                    autoComp.AimAssistConfig.HeadPriority = 100
                    autoComp.AimAssistConfig.ChestPriority = 100
                    autoComp.AimAssistConfig.PelvisPriority = 100
                end
            else
                local orig = _G.GTLMODState.OrigAutoAimCompCached
                autoComp.bOnlyHitHead = orig.bOnlyHitHead
                autoComp.HeadBoneName = orig.HeadBoneName
                pcall(function() autoComp.Bones = orig.Bones or {"Spine_01", "Pelvis", "Head"} end)
                autoComp.ChestBoneName = orig.ChestBoneName
                autoComp.PelvisBoneName = orig.PelvisBoneName
                if autoComp.AimAssistConfig then
                    autoComp.AimAssistConfig.HeadPriority = orig.HeadPriority or 1
                    autoComp.AimAssistConfig.ChestPriority = orig.ChestPriority or 1
                    autoComp.AimAssistConfig.PelvisPriority = orig.PelvisPriority or 1
                end
            end
        end
    end)

    -- ========================================== 
    -- REMOVED WALL CLIMB AND FAST CAR LOGIC 
    -- ==========================================

    local now = os.clock()
    pcall(function()
        local lsg = require("client.slua.logic.setting.logic_setting_graphics")
        local gi = lsg.GetGameInstance()
        if gi then
            if _G.GTLMODConfig.RemoveGrass and not _G.GTLMODState.PrevGraphicsState.RemoveGrass then
                gi:ExecuteCMD("grass.DensityScale", "0")
                gi:ExecuteCMD("grass.DiscardDataOnLoad", "1")
                _G.GTLMODState.PrevGraphicsState.RemoveGrass = true
            elseif not _G.GTLMODConfig.RemoveGrass and _G.GTLMODState.PrevGraphicsState.RemoveGrass then
                gi:ExecuteCMD("grass.DensityScale", "1")
                gi:ExecuteCMD("grass.DiscardDataOnLoad", "0")
                _G.GTLMODState.PrevGraphicsState.RemoveGrass = false
            end
            
            if _G.GTLMODConfig.RemoveFog and not _G.GTLMODState.PrevGraphicsState.RemoveFog then
                gi:ExecuteCMD("r.SkyAtmosphere", "1") 
                gi:ExecuteCMD("r.Fog", "0")           
                gi:ExecuteCMD("r.VolumetricFog", "0") 
                _G.GTLMODState.PrevGraphicsState.RemoveFog = true
            elseif not _G.GTLMODConfig.RemoveFog and _G.GTLMODState.PrevGraphicsState.RemoveFog then
                gi:ExecuteCMD("r.SkyAtmosphere", "1") 
                gi:ExecuteCMD("r.Fog", "1")           
                gi:ExecuteCMD("r.VolumetricFog", "1") 
                _G.GTLMODState.PrevGraphicsState.RemoveFog = false
            end
            
            if _G.GTLMODConfig.WhiteBody and not _G.GTLMODState.PrevGraphicsState.WhiteBody then
                gi:ExecuteCMD("r.CharacterDiffuseOffset", "2")
                gi:ExecuteCMD("r.CharacterDiffusePower", "5")
                gi:ExecuteCMD("r.CharacterMinShadowFactor", "100")
                _G.GTLMODState.PrevGraphicsState.WhiteBody = true
            elseif not _G.GTLMODConfig.WhiteBody and _G.GTLMODState.PrevGraphicsState.WhiteBody then
                gi:ExecuteCMD("r.CharacterDiffuseOffset", "0")
                gi:ExecuteCMD("r.CharacterDiffusePower", "1")
                gi:ExecuteCMD("r.CharacterMinShadowFactor", "1")
                _G.GTLMODState.PrevGraphicsState.WhiteBody = false
            end
            
            if _G.GTLMODConfig.ColorBodyV2 and not _G.GTLMODState.PrevGraphicsState.ColorBodyV2 then
                gi:ExecuteCMD("r.CharacterMinShadowFactor", "4")
                gi:ExecuteCMD("r.CharacterDiffuseOffset", "200")
                gi:ExecuteCMD("r.CharacterDiffusePower", "200")
                _G.GTLMODState.PrevGraphicsState.ColorBodyV2 = true
            elseif not _G.GTLMODConfig.ColorBodyV2 and _G.GTLMODState.PrevGraphicsState.ColorBodyV2 then
                gi:ExecuteCMD("r.CharacterMinShadowFactor", "1")
                gi:ExecuteCMD("r.CharacterDiffuseOffset", "0")
                gi:ExecuteCMD("r.CharacterDiffusePower", "1")
                _G.GTLMODState.PrevGraphicsState.ColorBodyV2 = false
            end
            
            if _G.GTLMODConfig.BlackSky and not _G.GTLMODState.PrevGraphicsState.BlackSky then
                gi:ExecuteCMD("r.CylinderMaxDrawHeight", "9999")
                _G.GTLMODState.PrevGraphicsState.BlackSky = true
            elseif not _G.GTLMODConfig.BlackSky and _G.GTLMODState.PrevGraphicsState.BlackSky then
                gi:ExecuteCMD("r.CylinderMaxDrawHeight", "0000")
                _G.GTLMODState.PrevGraphicsState.BlackSky = false
            end
        end
    end)

    pcall(function()
        local weapon = nil
        pcall(function()
            local weaponManager = localPlayer.WeaponManagerComponent
            if Valid(weaponManager) and type(weaponManager.GetCurrentWeapon) == "function" then
                weapon = weaponManager:GetCurrentWeapon()
            end
        end)
        if not Valid(weapon) then
            if type(localPlayer.GetCurrentShootWeapon) == "function" then weapon = localPlayer:GetCurrentShootWeapon()
            elseif type(localPlayer.GetCurrentWeapon) == "function" then weapon = localPlayer:GetCurrentWeapon() end
        end

        if Valid(weapon) then
            local entities = {}
            if Valid(weapon.ShootWeaponEntity_GEN_VARIABLE) then table.insert(entities, weapon.ShootWeaponEntity_GEN_VARIABLE) end
            if Valid(weapon.ShootWeaponEntity) then table.insert(entities, weapon.ShootWeaponEntity) end
            if Valid(weapon.ShootWeaponComponent) and Valid(weapon.ShootWeaponComponent.ShootWeaponEntityComponent) then 
                table.insert(entities, weapon.ShootWeaponComponent.ShootWeaponEntityComponent) 
            end

            for _, entity in ipairs(entities) do
                local anyWeaponModOn = _G.GTLMODConfig.CustomHRecoil or _G.GTLMODConfig.CustomVRecoil or _G.GTLMODConfig.LessShake or _G.GTLMODConfig.Accuracy or _G.GTLMODConfig.AutoHead or _G.GTLMODConfig.CustomAimbot or _G.GTLMODConfig.CustomAimbotClose

                if anyWeaponModOn then
                    if not entity.OriginalStatsCached then
                        entity.OriginalStatsCached = {
                            GameDeviationFactor = entity.GameDeviationFactor,
                            GameDeviationAccuracy = entity.GameDeviationAccuracy,
                            BulletFireSpeed = entity.BulletFireSpeed,
                            ShootInterval = entity.ShootInterval,
                            BaseDamage = entity.BaseDamage,
                            AccessoriesHRecoilFactor = entity.AccessoriesHRecoilFactor,
                            AccessoriesVRecoilFactor = entity.AccessoriesVRecoilFactor,
                            RecoilKick = entity.RecoilKick,
                            RecoilKickADS = entity.RecoilKickADS,
                            AnimationKick = entity.AnimationKick
                        }
                    end
                    
                    if _G.GTLMODConfig.CustomHRecoil then entity.AccessoriesHRecoilFactor = _G.GTLMODState.CustomTextData.HRecoil or 0.33
                    elseif _G.GTLMODConfig.LessRecoil then entity.AccessoriesHRecoilFactor = 0.34 end
                    
                    if _G.GTLMODConfig.CustomVRecoil then entity.AccessoriesVRecoilFactor = _G.GTLMODState.CustomTextData.VRecoil or 0.33
                    elseif _G.GTLMODConfig.VerticalRecoil then entity.AccessoriesVRecoilFactor = 0.33 end
                    
                    if _G.GTLMODConfig.LessShake then entity.RecoilKickADS = 0.11; entity.RecoilKickADS = 0.0; entity.RecoilKickADS = 0.11 end

                    
                    if entity.AutoAimingConfig then
                        if not entity.OriginalAutoAimCached then
                            entity.OriginalAutoAimCached = {
                                OuterSpeed = entity.AutoAimingConfig.OuterRange and entity.AutoAimingConfig.OuterRange.Speed,
                                InnerSpeed = entity.AutoAimingConfig.InnerRange and entity.AutoAimingConfig.InnerRange.Speed
                            }
                        end
                        
                        if _G.GTLMODConfig.AutoHead then
                            pcall(function() entity.AutoAimingConfig.Bones = { "Head", "Head", "Head" } end)
                        end
                        
                        if _G.GTLMODConfig.CustomAimbot then
                            local speed = _G.GTLMODState.CustomTextData.OuterSpeed or 10
                            if entity.AutoAimingConfig.OuterRange then
                                entity.AutoAimingConfig.OuterRange.Speed = speed
                                entity.AutoAimingConfig.OuterRange.RangeRate = 4.5
                                entity.AutoAimingConfig.OuterRange.SpeedRate = 1.3
                                entity.AutoAimingConfig.OuterRange.RangeRateSight = 1.8
                                entity.AutoAimingConfig.OuterRange.SpeedRateSight = 2.2
                                entity.AutoAimingConfig.OuterRange.CrouchRate = 1.1
                                entity.AutoAimingConfig.OuterRange.ProneRate = 1.0
                                entity.AutoAimingConfig.OuterRange.DyingRate = 0.0
                            end
                            if entity.AutoAimingConfig.InnerRange then
                                entity.AutoAimingConfig.InnerRange.Speed = speed
                                entity.AutoAimingConfig.InnerRange.RangeRate = 4.5
                                entity.AutoAimingConfig.InnerRange.SpeedRate = 1.3
                                entity.AutoAimingConfig.InnerRange.RangeRateSight = 1.8
                                entity.AutoAimingConfig.InnerRange.SpeedRateSight = 2.2
                                entity.AutoAimingConfig.InnerRange.CrouchRate = 1.1
                                entity.AutoAimingConfig.InnerRange.ProneRate = 1.0
                                entity.AutoAimingConfig.InnerRange.DyingRate = 0.0
                            end
                        elseif _G.GTLMODConfig.CustomAimbotClose then
                            local speed = _G.GTLMODState.CustomTextData.InnerSpeed or 10
                            if entity.AutoAimingConfig.OuterRange then
                                entity.AutoAimingConfig.OuterRange.Speed = speed
                                entity.AutoAimingConfig.OuterRange.DyingRate = 0.0
                            end
                            if entity.AutoAimingConfig.InnerRange then
                                entity.AutoAimingConfig.InnerRange.Speed = speed
                                entity.AutoAimingConfig.InnerRange.DyingRate = 0.0
                            end
                        end
                    end
                    
                    entity.GTLMODWeaponModsActive = true

                elseif entity.GTLMODWeaponModsActive then
                    if entity.OriginalStatsCached then
                        local orig = entity.OriginalStatsCached
                        entity.GameDeviationFactor = orig.GameDeviationFactor
                        entity.GameDeviationAccuracy = orig.GameDeviationAccuracy
                        entity.BulletFireSpeed = orig.BulletFireSpeed
                        entity.ShootInterval = orig.ShootInterval
                        entity.BaseDamage = orig.BaseDamage
                        entity.AccessoriesHRecoilFactor = orig.AccessoriesHRecoilFactor
                        entity.AccessoriesVRecoilFactor = orig.AccessoriesVRecoilFactor
                        entity.RecoilKick = orig.RecoilKick
                        entity.RecoilKickADS = orig.RecoilKickADS
                        entity.AnimationKick = orig.AnimationKick
                    end
                    if entity.AutoAimingConfig and entity.OriginalAutoAimCached then
                        pcall(function() entity.AutoAimingConfig.Bones = { "Spine_01", "Pelvis", "Head" } end)
                        if entity.AutoAimingConfig.OuterRange and entity.OriginalAutoAimCached.OuterSpeed then
                            entity.AutoAimingConfig.OuterRange.Speed = entity.OriginalAutoAimCached.OuterSpeed
                        end
                        if entity.AutoAimingConfig.InnerRange and entity.OriginalAutoAimCached.InnerSpeed then
                            entity.AutoAimingConfig.InnerRange.Speed = entity.OriginalAutoAimCached.InnerSpeed
                        end
                    end
                    entity.GTLMODWeaponModsActive = false
                end
            end
        end
    end)

end


_G.GTLMODState.LoopToken = (_G.GTLMODState.LoopToken or 0) + 1 
local myToken = _G.GTLMODState.LoopToken

-- ========================================== 
-- MAIN LOOP (ESP & OTHER FEATURES) WITH 0.2 SEC
-- ========================================== 
local function FastTick() 
    if isExpired then 
        if not _G.GTLMODNotifiedExpire then
            Notify("MOD HAS EXPIRED! PLEASE CONTACT OWNER TO RENEW!\nTelegram @HAMSECHEATS")
            _G.GTLMODNotifiedExpire = true
        end
        return 
    end

    if myToken ~= _G.GTLMODState.LoopToken then return end
    pcall(MainLoop) 
    local okTicker, ticker = pcall(require, "common.time_ticker") 
    if okTicker and ticker and ticker.AddTimerOnce then 
        ticker.AddTimerOnce(0.4, FastTick) 
    end 
end

-- ========================================== 
-- AIMBOT LOOP WITH 0.016 SEC (~60 FPS)
-- ========================================== 
local aimbotToken = 0
local function FastAimbotTick()
    if isExpired then 
        return 
    end

    if aimbotToken ~= _G.GTLMODState.AimbotLoopToken then 
        return 
    end

    pcall(function()
        if _G.GTLMODConfig.AimTouchEnable then
            _G.AimTouch()
        end
    end)

    local okTicker, ticker = pcall(require, "common.time_ticker")
    if okTicker and ticker and ticker.AddTimerOnce then
        ticker.AddTimerOnce(0.016, FastAimbotTick)
    end
end


-- ============================================================================
-- ONLINE LICENSE MAINTENANCE
-- Keeps the same fail-closed online session behavior as .
-- ============================================================================
local function StartBRLicenseMaintenance()
    local owner = nil
    pcall(function()
        if GameplayData and GameplayData.GetPlayerController then
            owner = GameplayData.GetPlayerController()
        end
    end)

    if not slua.isValid(owner) then
        pcall(function()
            if slua_GameFrontendHUD then
                owner = slua_GameFrontendHUD:GetPlayerController()
            end
        end)
    end

    if slua.isValid(owner) and type(owner.AddGameTimer) == "function" then
        pcall(function()
            owner:AddGameTimer(0.25, true, BRLicenseMaintenance)
        end)
        pcall(BRLicenseMaintenance)
        return true
    end
    return false
end

pcall(function()
    local ticker = require("common.time_ticker")
    if ticker and ticker.AddTimerOnce then
        ticker.AddTimerOnce(0.5, function()
            if not StartBRLicenseMaintenance() then
                ticker.AddTimerOnce(0.5, StartBRLicenseMaintenance)
            end
        end)
    end
end)

-- ========================================== 
-- IGNITE BOTH LOOPS
-- ========================================== 
if not isExpired then
    FastTick()
    if BRLicenseActive() then
        _G.GTLMODState.AimbotLoopToken = (_G.GTLMODState.AimbotLoopToken or 0) + 1
    else
        _G.GTLMODState.AimbotLoopToken = (_G.GTLMODState.AimbotLoopToken or 0) + 1
    end
    aimbotToken = _G.GTLMODState.AimbotLoopToken
    local okTicker, ticker = pcall(require, "common.time_ticker")
    if okTicker and ticker and ticker.AddTimerOnce then
        ticker.AddTimerOnce(0.1, FastAimbotTick)
    end
    Notify(BRLicenseActive()
        and "Online key verified. VIP Mod unlocked."
        or "Online key required. VIP features are locked.")
else
    FastTick() 
end

-- ===================================================================================
-- SYSTEM HOOKS
-- ===================================================================================
local function InitAllModSystems()
    if isExpired then return end
    if not BRLicenseActive() then return end

    pcall(function()
        if _G.InitializeAutoHeadHooks then _G.InitializeAutoHeadHooks() end
    end)

    local GameplayData = package.loaded["GameLua.GameCore.Data.GameplayData"] or require("GameLua.GameCore.Data.GameplayData")
    if not GameplayData then return end

    pcall(function()
        local LocalPlayer = GameplayData.GetPlayerCharacter and GameplayData.GetPlayerCharacter()
        if slua.isValid(LocalPlayer) then
            if LocalPlayer.bHasShownDevNotice == nil then
                LocalPlayer.bHasShownDevNotice = false 
                LocalPlayer.bHasShownExpiredNotice = false 
                LocalPlayer.bIsDeadFlag = false
            end
        end
    end)
end

if not isExpired then
    pcall(function() 
        require("common.time_ticker").AddTimerOnce(0.5, InitAllModSystems) 
    end)
end
-- Automatic feedback, screenshot capture, external uploads, and UI hooks removed.
-- No gameplay screenshots or match statistics are collected or transmitted.

-- ==============================================================================
-- ================== THE RETURN SECTION RETAINS THE ORIGINAL CODE. ===================
-- ==============================================================================
local class = require("class")
local CCharacterBase = require("GameLua.GameCore.Framework.CharacterBase")
local CBRPlayerCharacterBase = class(CCharacterBase, nil, BRPlayerCharacterBase)
return require("combine_class").DeclareFeature(CBRPlayerCharacterBase, {
  {
    SkyTransition = "GameLua.Mod.BaseMod.Gameplay.Feature.SkyControl.PlayerCharacterSkyTransitionFeature"
  },
  {
    CarryDeadBoxFeature = "GameLua.Mod.Library.GamePlay.Feature.CarryDeadBoxFeature"
  },
  {
    SpecialSuitFeature = "GameLua.Mod.Library.GamePlay.Feature.SpecialSuitFeature"
  },
  {
    TeleportPawnFeature = "GameLua.Mod.Library.GamePlay.Feature.TeleportPawnFeature"
  },
  {
    LifterControl = "GameLua.Mod.BaseMod.Gameplay.Feature.Player.CharacterLifterControlFeature"
  },
  {
    FinalKillEffect = "GameLua.Mod.BaseMod.Gameplay.Feature.Player.PlayerCharacterFinalKillEffectFeature"
  },
  {
    CampFeature = "GameLua.Mod.BaseMod.GamePlay.Feature.Camp.PlayerCharacterCampFeature"
  },
  {
    BuildSkateFeature = "GameLua.Mod.BaseMod.GamePlay.Feature.PlayerCharacterBuildVehicleFeature"
  },
  {
    CommonBornlandTransformFeature = "GameLua.Mod.BaseMod.GamePlay.Feature.HeroPropFeature.CommonBornlandTransformFeature"
  },
  {
    ParachuteFormation = "GameLua.Mod.BaseMod.GamePlay.Feature.ParachuteFormationFeature"
  }
}, "BRPlayerCharacterBase")

-- ============================================================================
-- THIS LUA IS ENCRYPTED BY @HAMSECHEATS
-- YOU CAN JOIN MY CHANNEL :- ASSET_FINDER
-- ============================================================================
