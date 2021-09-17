_G.GLoaded = false
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local SharedModules = ReplicatedStorage:WaitForChild("SharedModules")

local PlayerService = require(SharedModules:WaitForChild("PlayerService"))

_G.MetaPlayers = {}
_G.LoadedPlayers = {}
_G.LongWait = 3
_G.MediumWait = 2
_G.NormalWait = 1
_G.FastWait = .75
_G.FasterWait = .5
_G.FastestWait = .15
_G.ThirtyFPSWait = .3
_G.SixtyFPSWait =.6
_G.ProfileServiceLoaded = false
_G.RequestMetaPlayers = function(...)
	local Args = {...}
	local Player = Args[1]
	local Type = Args[2]
	if Type == "UpdateMetaPlayers" then
		_G.MetaPlayers = Args[2]
	end
end
_G.GiveProfileLoaded = function(...)
	local Args = {...}
	local Type = Args[1]
	if Type == "GetProfileLoaded" then
		_G.ProfileServiceLoaded = true
	end
end

local RequestMetaPlayersBindable = Remotes:WaitForChild("RequestMetaPlayers")
RequestMetaPlayersBindable.OnClientInvoke = _G.RequestMetaPlayers
local GiveProfileLoaded = Remotes:WaitForChild("GiveProfileLoaded")
GiveProfileLoaded.OnClientEvent:Connect(_G.GiveProfileLoaded)

_G.GetMetaPlayer = function(Player)
	return RequestMetaPlayersBindable:InvokeServer("RequestMetaPlayer",Player)
end

function _G.playAnimationFromServer(character, animation)
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		local animator = humanoid:FindFirstChildOfClass("Animator")
		if animator then
			local animationTrack = animator:LoadAnimation(animation)
			animationTrack:Play()
			return animationTrack
		else
			local dance = humanoid:LoadAnimation(animation)
			dance:Play()
		end
	end
end

function _G.getModelMass(model)
	local root = assert(model.PrimaryPart,"No Model Mass")
	local mass = 0
	for _, part in ipairs(root:GetConnectedParts(true)) do
		mass = mass + part:GetMass()
	end
	return mass
end

function _G.IsPlayerAlive(Player)
    local char = Player.Character
    if not char or not char:IsDescendantOf(workspace) or not char:FindFirstChild "Humanoid" or char.Humanoid:GetState() == Enum.HumanoidStateType.Dead then
        return
    end
    return true
end

function _G.searchFor(item,dictionary)
	for i, dict in pairs(dictionary) do
		--print(dict.Name, item)
		if dict.Name == item then return true end;
	end
	return false;
end

function _G.searchForObject(item,dictionary)
	for i, dict in pairs(dictionary) do
		--print(dict.Name, item)
		if dict.Name == item or dict == item then return dict end;
	end
	return false;
end

wait()
_G.GLoaded = true