local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ScriptContext = game:GetService("ScriptContext")
local HTTPService = game:GetService("HttpService")

local url = "https://discord.com/api/webhooks/874495576845201499/gtgcakBx7mZTkTmIRLflw_eUN49wRyCtCmgd9WTkTTN7CeFIfLA-qVHpVgQp6KLZsLjC"


local function send(data)
	HTTPService:PostAsync(url, data)
end

-- Players.PlayerAdded:Connect(function(player)
-- 	if not RunService:IsStudio() then
-- 		--local date = os.date("!*t")
-- 		local Data = {
--             ["username"] = "Seahorse - Temple Party Last Man Standing",
--             ["content"] = nil,
--             ["embeds"] = {
--                 {
--                     ["title"] = "Player Joined",
--                     ["description"] = player.Name
--                 }
--             }}
--         Data = HTTPService:JSONEncode(Data)
--         send(Data)
-- 	end
-- end)

ScriptContext.Error:Connect(function(msg, stacktrace, scriptt)
	local Data = {
		["username"] = "Seahorse - Temple Party Last Man Standing",
		["content"] = "```css\n " .. "[" .. scriptt:GetFullName() .. "]" .. "" .. " ```",
		["embeds"] = {
			{
				["title"] = nil,
				["description"] = "```ini\n".. "[" .. msg .. "\n " .. stacktrace.. "]" .. "```",
			}
		}
	}
	Data = HTTPService:JSONEncode(Data)
	HTTPService:PostAsync(url, Data)
end)