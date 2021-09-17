_G.GLoaded = false
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local PhysicsService = game:GetService("PhysicsService")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SharedModules = ReplicatedStorage:WaitForChild("SharedModules")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

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
local previousCollisionGroups = {}

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

function _G.CreateCollisionGroup(GroupName)
	PhysicsService:CreateCollisionGroup(GroupName)
end

function _G.CollisionGroupSetCollidable(Group1,Group2,CanCollide)
	PhysicsService:CollisionGroupSetCollidable(Group1, Group2, CanCollide)
end

function _G.GetCollisionGroupName(GroupName) do
	for i,v in pairs(PhysicsService:GetCollisionGroups()) do
		print(i,v)
	end
end
end

function _G.setCollisionGroup(object,GroupName)
	if object:IsA("BasePart") then
	  previousCollisionGroups[object] = object.CollisionGroupId
	  PhysicsService:SetPartCollisionGroup(object, GroupName)
	end
end
   
function _G.setCollisionGroupRecursive(object,GroupName)
	_G.setCollisionGroup(object,GroupName)
	for _, child in ipairs(object:GetChildren()) do
	  _G.setCollisionGroupRecursive(child,GroupName)
	end
end
   
function _G.resetCollisionGroup(object)
	local previousCollisionGroupId = previousCollisionGroups[object]
	if not previousCollisionGroupId then return end 
	local previousCollisionGroupName = PhysicsService:GetCollisionGroupName(previousCollisionGroupId)
	if not previousCollisionGroupName then return end
	previousCollisionGroups[object] = nil
	PhysicsService:SetPartCollisionGroup(object, previousCollisionGroupName)
end

function _G.GetPlayerAppearance(UserId)
	local PlayersModel = Players:GetCharacterAppearanceInfoAsync(UserId)
	print(PlayersModel)
	PlayersModel.Parent = workspace
	wait()
	for i,v in pairs(PlayersModel:GetChildren()) do
		v.Parent = workspace
		wait()
	end
end

function _G.CreateOfflineCharacter(UserID, Dummy)
    local Appearance = Players:GetHumanoidDescriptionFromUserId(UserID)
    Dummy.Humanoid:ApplyDescription(Appearance)
end

function _G.CheckForDecimal(Number)
	local pattern = "%p%d+"
	Number = tostring(Number)
	local str = string.match(Number, pattern)
	if str == nil then
		return nil
	else
		return tonumber(str)
	end
end

local MetaPlayerWait = 0 -- usually only gets to 2
_G.GetMetaPlayer = function(Player)
	MetaPlayerWait = MetaPlayerWait + 1
	for i,MetaPlayer in pairs (_G.MetaPlayers) do
        if MetaPlayer.Player == Player then
			--warn("Found MetaPlayer")
            return MetaPlayer
        end
    end
	if MetaPlayerWait <= 31 then
		MetaPlayerWait = 1
		wait(.3)
		return _G.GetMetaPlayer(Player)
	end
    if #_G.MetaPlayers ~= 0 then
        repeat wait(.15)
        until #_G.MetaPlayers ~= 0
    end
	for i,MetaPlayer in pairs (_G.MetaPlayers) do
        if MetaPlayer.Player == Player then
			--warn("Found MetaPlayer")
            return MetaPlayer
        end
    end
	warn("MetaPlayer Not Found For : " .. Player.Name)
	wait(.3)
	return _G.GetMetaPlayer(Player)
end

_G.RequestMetaPlayers = function(...)
	local Args = {...}
	local Player = Args[1]
	local Type = Args[2]
	if Type == "RequestMetaPlayers" then
		return _G.MetaPlayers
	elseif Type == "RequestMetaPlayer" then
		return _G.GetMetaPlayer(Player)
	end
end

local RequestMetaPlayersBindable = Remotes:WaitForChild("RequestMetaPlayers")
RequestMetaPlayersBindable.Parent = Remotes
RequestMetaPlayersBindable.OnServerInvoke = _G.RequestMetaPlayers

wait()
_G.GLoaded = true