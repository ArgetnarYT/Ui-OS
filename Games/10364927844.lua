-- Var
getgenv().Config = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = game.Players.LocalPlayer

function Teleport(Part)
    local Char = Player.Character
    local Hum = Char:FindFirstChild("HumanoidRootPart")

    if Char and Hum then
        Hum.CFrame = Part
    end
end

function GetArea()
    local tbl = {}

    for i, v in pairs(require(ReplicatedStorage.Modules.AreasData)) do
        table.insert(tbl, {Area = i, Cost = v})
    end

    table.sort(tbl, function(a,b)
        return a.Cost < b.Cost
    end)

    return tbl
end

function GetEggs()
    local tbl = {}

    for i, v in pairs(require(ReplicatedStorage.Modules.EggsData)) do
        table.insert(tbl, i)
    end
    return tbl
end

function GetMagnitude(Pos)
    if Player.Character and Pos then
        return Player:DistanceFromCharacter(Pos)
    end
    return math.huge
end

function GetClosestEnemy()
    local Close, Dist = nil, math.huge
    
    for i, v in pairs(workspace.Colletions:GetChildren()) do
        local Part = v:FindFirstChild("Main")
        local Mag = GetMagnitude(Part.Position)

        if Mag < Dist then
            Dist = Mag
            Close = v
        end
    end

    for i, v in pairs(workspace.Dungeons:GetChildren()) do
        for i2, v2 in pairs(v.NPCs:GetChildren()) do
            local Part = v2:FindFirstChild("HumanoidRootPart")
            local Mag = GetMagnitude(Part.Position)

            if Part and Mag < Dist then
                Dist = Mag
                Close = v2
            end
        end
    end
    return Close
end

function GetClosestEgg()
    local Close, Dist = nil, math.huge

    for i, v in pairs(workspace.Eggs:GetChildren()) do
        local Mag = GetMagnitude(v.Position)

        if Mag < Dist then
            Dist = Mag
            Close = v.Name
        end
    end
    return Close
end

function AutoFarm()
    task.spawn(function()
        while task.wait() do
            if not Config.AutoFarm then return end
            pcall(function()
                local Enemy = GetClosestEnemy()
                local Mag = GetMagnitude(Enemy.Main.Position)

                ReplicatedStorage.Remotes.ChangeTarget:InvokeServer(Enemy)

                for i, v in pairs(Player.BackpackFolder:GetChildren()) do
                    local CanCast = ReplicatedStorage.Remotes.CanCast:InvokeServer(v.Value)
                    
                    if CanCast then
                        ReplicatedStorage.Remotes.Damage:InvokeServer(v.Value)
                        task.wait(.3)
                    end
                end
            end)
        end
    end)
end

function AutoCollectDrops()
    task.spawn(function()
        while task.wait() do
            if not Config.AutoCollectDrops then return end
            for i, v in pairs(workspace.Client_VFX:GetChildren()) do
                if v.Name:match("0Soul") or v.Name:match("0Gem") then
                    ReplicatedStorage.Remotes.RewardsDropper:FireServer(v.Name)
                    v:Destroy()
                end
            end
        end
    end)
end

function AutoOpenChest()
    task.spawn(function()
        while task.wait() do
            if not Config.AutoOpenChest then return end
            ReplicatedStorage.Remotes.BuyEgg:FireServer(GetClosestEgg())
        end
    end)
end

-- function DeleteSpells()
--     for i, v in pairs(Player.PlayerGui.ScreenGui.InventoryFrame.Sells:GetChildren()) do
--         if v:FindFirstChild("Equipped") and not v.Equipped.Visible then
--             task.spawn(function()
--                 ReplicatedStorage.Remotes.DeletePets:FireServer({v.Name})
--             end)
--         end
--     end
-- end

-- Hook
if not HookLoaded then
    getgenv().HookLoaded = true

    local old; old = hookmetamethod(game, "__namecall", function(self, ...)
        local args = {...}
        local method = getnamecallmethod()

        if method == "FireServer" and self.Name == "DamageMe" then
            return
        elseif method == "FireServer" and self.Name == "Dungeons" and args[1] == "DoDamage" then
            return
        end
        return old(self,...)
    end)
end

--lib
local ArgetnarLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/ArgetnarYT/Library/main/ArgetnarLibrary.lua"))()
local win = ArgetnarLib:Window("Argetnar Hub")

ArgetnarLib:Notify("Script", "Loading.....")
local TabFarm = win:Tab("Autofarm")

TabFarm:Label("Elemental Fighting")
TabFarm:Toggle("AutoFarm", function(v)
    Config.AutoFarm = v

    AutoFarm()
end)

TabFarm:Toggle("Auto Collect", function(v)
    Config.AutoCollectDrops = v

    AutoCollectDrops()
end)
TabFarm:Toggle("Auto Open Chest", function(Bool)
    Config.AutoOpenChest = v
        
    AutoOpenChest()
end)
local TabTele = win:Tab("Teleports")
for i, v in pairs(GetArea()) do
TabTele:Button(v.Area, function()
        ReplicatedStorage.Remotes.AreaChange:FireServer(v.Area)
        Teleport(workspace.SpawnPoints[v.Area].CFrame)
end)
end
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

ArgetnarLib:Notify("Script", "Was Loaded!")
