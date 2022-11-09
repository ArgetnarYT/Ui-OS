local ArgetnarLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/ArgetnarYT/Library/main/ArgetnarLibrary.lua"))()
local win = ArgetnarLib:Window("Argetnar Hub")
ArgetnarLib:Notify("Script", "Loading...........")
local TabFarm = win:Tab("Autofarm")
TabFarm:Toggle("killaura", function(Farm)
    --// Variables
local Client = game.Players.LocalPlayer
local ClientRemoteEvent = require(game.ReplicatedStorage.ClientData).ClientRemoteEvent
local ConfigData = require(game.ReplicatedStorage.DataConfig.GetConfigData)
local ClientDinosaur = Client:GetAttribute("DinosaurName")
local attackId = ConfigData:GetDinosaurDataTable(ClientDinosaur).Attack
local Event = ClientRemoteEvent.FireServer
local RunService = game:GetService("RunService")

--// TOGGLE
getgenv().Enabled = Farm --// Change this to false to disable the script

local function closest() --// We don't talk about the getdescendants, their folders are built weird
	local list = {}
	for _, v in next, workspace.Monsters:GetDescendants() do
		if v.Name == "FoodHp" and v.Value > 0 then
			local part = v.Parent.RootPart
			if not part then
				continue
			end
			table.insert(list, { mob = v.Parent, distance = Client:DistanceFromCharacter(part.Position) })
		end
	end
	table.sort(list, function(t0, t1)
		return t0.distance < t1.distance
	end)
	if list[1] then
		return list[1].mob
	end
	return nil
end

RunService.Heartbeat:Connect(function()
	if Enabled then
		Event("AttackRemoteEvent", "AttackStaticFood", closest(), attackId, ClientDinosaur)
	end
end)
end)
TabFarm:TextBox("Enter the amount of Gold", function(Value)
local Monsters1 = {
workspace.Monsters.Monster_01.Monster.ScaledModel,
workspace.Monsters.Monster_01.Monster.Rabbit,
workspace.Monsters.Monster_01.Monster.Frog,
workspace.Monsters.Monster_01.Monster.Frogs,
workspace.Monsters.Monster_01.Monster.Turtle,
workspace.Monsters.Monster_01.Monster.Rat,
workspace.Monsters.Monster_01.Monster.Boar,
workspace.Monsters.Monster_01.Monster.Crocodile,
workspace.Monsters.Monster_01.Monster.Turtle,
workspace.Monsters.Monster_01.Food.Watermelos,
workspace.Monsters.Monster_01.Food.Apples,
workspace.Monsters.Monster_01.Food.Watermelon,
workspace.Monsters.Monster_01.Food.Apple,
workspace.Monsters.Monster_04.BOSS.Boss1,
workspace.Monsters.Monster_05.BOSS.Boss2,}
for i,v in pairs(Monsters1) do
local dielan = {
[1] = "AttackStaticFood",
[2] = v,
[3] = Value, -- amount of coins u get when collect, change this if u want more or less, math.huge wont give u any so dont change to it 
[4] = "Dinosaur1_3_1"}
game:GetService("ReplicatedStorage").RemoteEvents.AttackRemoteEvent:FireServer(unpack(dielan))
end
end)
TabFarm:Label("After you have entered the number, go to the first arena (spawn)")
TabFarm:Label("and collect coins") 
local TabMisc = win:Tab("Misc")
TabMisc:Slider("Walk Speed", 16, 500, 50, function(Value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
end)
TabMisc:Button("Destroy", function()
    game.CoreGui.MangoHub:Destroy()
end)
TabMisc:Button("Rejoin", function()
local ts = game:GetService("TeleportService")

local p = game:GetService("Players").LocalPlayer

ts:TeleportToPlaceInstance(game.PlaceId, game.JobId, p)
end)
TabMisc:Button("Tp Mecha Dino", function()
    local plr = game:service"Players".LocalPlayer;
local tween_s = game:service"TweenService";
local info = TweenInfo.new(1,Enum.EasingStyle.Quad); -- Change the number to lower to speed it up and higher to slow it down.
function tp(...)
local tic_k = tick();
local params = {...};
local cframe = CFrame.new(params[1],params[2],params[3]);
local tween,err = pcall(function()
local tween = tween_s:Create(plr.Character["HumanoidRootPart"],info,{CFrame=cframe});
      tween:Play();
end)
   if not tween then return err end
end
tp(321.015, 27.1714, -127.514);
end)
TabMisc:Button("Tp Last Boss(Bone)", function()
    local plr = game:service"Players".LocalPlayer;
local tween_s = game:service"TweenService";
local info = TweenInfo.new(1,Enum.EasingStyle.Quad); -- Change the number to lower to speed it up and higher to slow it down.
function tp(...)
local tic_k = tick();
local params = {...};
local cframe = CFrame.new(params[1],params[2],params[3]);
local tween,err = pcall(function()
local tween = tween_s:Create(plr.Character["HumanoidRootPart"],info,{CFrame=cframe});
      tween:Play();
end)
   if not tween then return err end
end
tp(274.477, 90.0895, -690.018); -- Change x,y,z to the coordinates you got
end)
local TabCredit = win:Tab("Credits")
TabCredit:Label("Hub by Argetnar & Doku & Brinen")
local LabelRef = TabCredit:Label("v1")
wait(10)
LabelRef:Refresh("v2")
ArgetnarLib:Notify("Script", "The script has been loaded")
