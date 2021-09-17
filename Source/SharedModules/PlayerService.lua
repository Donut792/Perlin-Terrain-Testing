local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContextActionService = game:GetService("ContextActionService")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
if RunService:IsServer() then
    local UI = ReplicatedStorage:WaitForChild("UI")
end
local SharedModules = ReplicatedStorage:WaitForChild("SharedModules")
--local ParticleFolder = ReplicatedStorage:WaitForChild("Particles")

local RequestMetaPlayers = Remotes:WaitForChild("RequestMetaPlayers")

local Janitor = require(SharedModules.Utils:WaitForChild("Janitor"))

local PlayerService = {}
PlayerService.__index = PlayerService

function PlayerService.new(Player)
    local MetaPlayer = {}
    setmetatable(MetaPlayer, PlayerService)
    MetaPlayer.Player = Player
    MetaPlayer._janitor = Janitor.new()
    table.insert(_G.MetaPlayers,MetaPlayer)
    MetaPlayer.PlayerGui = Player:WaitForChild("PlayerGui")
    MetaPlayer.PlayerHUD = MetaPlayer.PlayerGui:WaitForChild("HUD")
    MetaPlayer.OwnedItems = MetaPlayer.Player:WaitForChild("OwnedItems")
    MetaPlayer.PurchaseItems = MetaPlayer.Player:WaitForChild("PurchaseItems")
    MetaPlayer.Settings = MetaPlayer.Player:WaitForChild("Settings")
    MetaPlayer.Currency = MetaPlayer.Player:WaitForChild("Currency")
    MetaPlayer.PlayerStats = MetaPlayer.Player:WaitForChild("PlayerStats")
    MetaPlayer.Coins = MetaPlayer.Currency:WaitForChild("Coins")
    MetaPlayer.GoldenBananas = MetaPlayer.Currency:WaitForChild("GoldenBananas")
    MetaPlayer.Bananas = MetaPlayer.GoldenBananas
	MetaPlayer.Level = MetaPlayer.PlayerStats:WaitForChild("Level")
	MetaPlayer.Xp = MetaPlayer.PlayerStats:WaitForChild("Xp")
	MetaPlayer.XpRequired = MetaPlayer.PlayerStats:WaitForChild("XpRequired")
    MetaPlayer.LevelFactor = MetaPlayer.PlayerStats:WaitForChild("LevelFactor")
    MetaPlayer.BanReason = MetaPlayer.PlayerStats:WaitForChild("BanReason")
	MetaPlayer.Clothing = MetaPlayer.PlayerStats:WaitForChild("Clothing")
    MetaPlayer.Face = MetaPlayer.PlayerStats:WaitForChild("Face")
    MetaPlayer.FirstJoin = MetaPlayer.PlayerStats:WaitForChild("FirstJoin")
    MetaPlayer.Gender = MetaPlayer.PlayerStats:WaitForChild("Gender")
	MetaPlayer.Hair = MetaPlayer.PlayerStats:WaitForChild("Hair")
	MetaPlayer.Hat = MetaPlayer.PlayerStats:WaitForChild("Hat")
	MetaPlayer.IsCheater = MetaPlayer.PlayerStats:WaitForChild("IsCheater")
	MetaPlayer.Skin = MetaPlayer.PlayerStats:WaitForChild("Skin")
    MetaPlayer.Wins = MetaPlayer.PlayerStats:WaitForChild("Wins")
    MetaPlayer.FruitPack = MetaPlayer.PurchaseItems:WaitForChild("FruitPack")
    MetaPlayer.StarterPack = MetaPlayer.PurchaseItems:WaitForChild("StarterPack")
    MetaPlayer.PremiumBattlepass = MetaPlayer.PurchaseItems:WaitForChild("PremiumBattlepass")
    MetaPlayer.Backpack = Instance.new("Folder")
    MetaPlayer.Backpack.Name = "RealBackpack"
    MetaPlayer.Backpack.Parent = MetaPlayer.Player
    MetaPlayer.BackpackReady = false
    MetaPlayer.CurrentWeapon = nil
    if RunService:IsClient() then
        _G.MetaPlayers = RequestMetaPlayers:Invoke("RequestMetaPlayers")
    end
    return MetaPlayer
end

function ProfileServiceLoaded()
    if not _G.ProfileServiceLoaded then
        repeat wait(.3)  
        until _G.ProfileServiceLoaded == true
        return true
    end
end

function PlayerService:Destroy()
    self._janitor:Destroy()
    setmetatable(self,nil)
end

function PlayerService:Give(...)
    local Args = {...}
   
end

function PlayerService:Take(...)
    local Args = {...}
    
end

function PlayerService:GetStat(StatName)
    for i,Stat in pairs(self) do
        if i == StatName then
            return Stat
        end
    end
end

function PlayerService:SetStat(StatName,Value)
    for i,Stat in pairs(self) do
        if i == StatName then
            Stat.Value = Value
        end
    end
end

function PlayerService:IncrementStat(StatName,Value)
    for i,Stat in pairs(self) do
        if i == StatName then
            Stat.Value = Stat.Value + Value
        end
    end
end

function PlayerService:DecrementStat(StatName,Value)
    for i,Stat in pairs(self) do
        if i == StatName then
            Stat.Value = Stat.Value - Value
        end
    end
end

function PlayerService:TeleportTo(Spot)
    if typeof(Spot) == Vector3 then
        Spot = CFrame.new(Spot)
    end
    self.Player.Character:SetPrimaryPartCFrame(Spot)
end

function PlayerService:LevelUp()
    print("Leveling Up")
end

return PlayerService