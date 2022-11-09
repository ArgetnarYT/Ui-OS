--vig
local player = game:GetService("Players").LocalPlayer
local HumanoidRootPart = player.Character.HumanoidRootPart
local name = nil
local description = nil

--lib
local ArgetnarLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/ArgetnarYT/Library/main/ArgetnarLibrary.lua"))()
local win = ArgetnarLib:Window("Argetnar Hub")

ArgetnarLib:Notify("Script", "Loading.....")
local TabFarm = win:Tab("Main")

TabFarm:Dropdown("Change Team", {"Freshman","Sophomore","Junior","Senior","Teacher","Cheerleader","Athlete","Police","Principal"}, function(String)
    game:GetService("ReplicatedStorage").Remotes.ChangeTeam:InvokeServer(String)
end)
TabFarm:TextBox("Change Name", function(text)
    name = text
end)
TabFarm:TextBox("Change Description", function(text)
    description = text
end)
TabFarm:Button("Change", function()
    game:GetService("ReplicatedStorage").AvatarEditorConnections.UpdateRPName:InvokeServer(name,description)
end)

TabFarm:Button("Hit good shots", function()
        
        ArgetnarLib:Notify("Script!", "Femboyy did this function")
        
    while true do
local args = {
    [1] = "Shoot",
    [2] = "Good"
}

game:GetService("ReplicatedStorage").Activities.Events.Basketball:FireServer(unpack(args))
wait()
end
end)


























local TabMisc = win:Tab("Misc")
TabMisc:Button("Rejoin", function()
local ts = game:GetService("TeleportService")

local p = game:GetService("Players").LocalPlayer

ts:TeleportToPlaceInstance(game.PlaceId, game.JobId, p)
end)
TabMisc:Slider("Walk Speed", 16, 500, 50, function(Value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
end)
TabMisc:Button("Destroy", function()
    game.CoreGui.MangoHub:Destroy();
end)
local TabCredit = win:Tab("Credits")
TabCredit:Label("Hub by Argetnar & Doku & Brinen & Femboyy")
local LabelRef = TabCredit:Label("v1")
wait(10)
LabelRef:Refresh("v2")
ArgetnarLib:Notify("Script", "Was Loaded!")
