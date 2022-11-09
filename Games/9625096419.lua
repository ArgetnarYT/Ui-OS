getgenv().Config = {
    SelectedEgg = "Forest Egg |",
    TotalPet = 5
}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local Modules = ReplicatedStorage.Modules
local Eggs = require(Modules.Information.Eggs).Eggs
local Zones = require(Modules.Information.Zones)
local Network = require(Modules.Utils.Network)
local Abbreviation = require(Modules.Utils.Abbreviation)

if game.PlaceVersion < 62 then Player:Kick("/n create a private server the script doesnt support place version: " .. game.PlaceVersion) end

function Teleport(Part)
    Player.Character.HumanoidRootPart.CFrame = Part
end

function GetEggs()
    local tbl1, tbl2 = {}, {}

    for i, v in pairs(Eggs) do
        if i:match("Robux") then continue end
        table.insert(tbl1, {Name = i, Price = v.Price})
    end

    table.sort(tbl1, function(a,b)
        return a.Price < b.Price
    end)

    for i, v in pairs(tbl1) do
        table.insert(tbl2, v.Name .. " | " .. Abbreviation:Abbreviate(v.Price))
    end
    return tbl2
end

function GetZones()
    local tbl1, tbl2 = {}, {}

    for i, v in pairs(Zones.GeneralInfo) do
        if i:match("Main") then continue end
        table.insert(tbl1, {Order = v.Order, Name = i})
    end

    table.sort(tbl1, function(a,b)
        return a.Order < b.Order
    end)
    
    for i, v in pairs(tbl1) do
        table.insert(tbl2, v.Name)
    end 
    return tbl2
end

function GetMaxRebirth()
    local ScreenGui = Player.PlayerGui.ScreenGui
    local RebirthCost = ScreenGui.Menus.Rebirths.Menu.Holder[1].Cost.Text:split(" Taps")[1]
    local MyClicks = ScreenGui.Currencies.Currency1.Amount.Text
    
    return Abbreviation:UnAbbreviate(MyClicks) / Abbreviation:UnAbbreviate(RebirthCost)
end

function GetPets()
    local PlayerController = require(Player.PlayerScripts.Client.ClientManager.PlayerController)
    local tbl = {}

    for i, v in pairs(PlayerController.Object.Data.PetsInfo.PetStorage) do
        if not tbl[v.Tier] then
            tbl[v.Tier] = {}
        end
    
        if not tbl[v.Tier][v.Name] then
            tbl[v.Tier][v.Name] = {}
        end
        table.insert(tbl[v.Tier][v.Name], v.UUID)
    end 
    return tbl
end

function UpgradePet(Type, RemoteName)
    local Pets = GetPets()

    for i, v in pairs(Pets) do
        if i == Type then
            for i2, v2 in pairs(v) do
                if #v2 >= Config.TotalPet then
                    local str, tbl1, tbl2 = "", {}, {}

                    for i3, v3 in pairs(v2) do
                        if #tbl1 < Config.TotalPet then
                            table.insert(tbl1, v3)
                            str = v3
                        end
                    end
                    
                    for i3, v3 in pairs(tbl1) do
                        tbl2[v3] = true
                    end

                    Network:FireServer(RemoteName, str, tbl2)
                end
            end     
        end
    end
end

function AutoClick()
    task.spawn(function()
        while task.wait() do
            if not Config.AutoClick then return end
            Network:FireServer("ClickDetect")
        end
    end)
end

function AutoHatch()
    task.spawn(function()
        while task.wait() do
            if not Config.AutoHatch then return end
            local Egg = Config.SelectedEgg:split(" |")[1]

            Network:FireServer("OpenCapsules", Egg, 3)
        end
    end)
end

function AutoRebirth()
    task.spawn(function()
        while task.wait(.3) do
            if not Config.AutoRebirth then return end
            local Num = GetMaxRebirth()

            Network:FireServer("Rebirth", Num)
        end
    end)
end

function AutoShiny()
    task.spawn(function()
        while task.wait(.3) do
            if not Config.AutoShiny then return end
            UpgradePet(1, "ShinyCrafting")
        end
    end)
end

function AutoRainbow()
    task.spawn(function()
        while task.wait(.3) do
            if not Config.AutoRainbow then return end
            UpgradePet(2, "RainbowCrafting")
        end
    end)
end

--lib
local ArgetnarLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/ArgetnarYT/Library/main/ArgetnarLibrary.lua"))()
local win = ArgetnarLib:Window("Argetnar Hub")

ArgetnarLib:Notify("Script", "Loading.....")
local TabFarm = win:Tab("Main")
TabFarm:Label("Tapper Simulator")

local TabPet = win:Tab("Pets")

local TabTele = win:Tab("Teleports")

TabFarm:Toggle("Auto Click", function(v)
    Config.AutoClick = v

    AutoClick()
end)

TabFarm:Toggle("Auto Rebirth", function(v)
    Config.AutoRebirth = v

    AutoRebirth()
end)

TabPet:Toggle("Auto Hatch", function(v)
    Config.AutoHatch = v

    AutoHatch()
end)

TabPet:Dropdown("Select Egg", GetEggs(), function(v)
    Config.SelectedEgg = v
end)

TabPet:TextBox("Total Pet To Use", function(v)
	Config.TotalPet = tonumber(v)
end)

TabPet:Toggle("Auto Shiny", function(v)
    Config.AutoShiny = v

    AutoShiny()
end)

TabPet:Toggle("Auto Rainbow", function(v)
    Config.AutoRainbow = v

    AutoRainbow()
end)

TabTele:Dropdown("Select Island", GetZones(), function(v)
    --Network:FireServer("LocationChanged", v)
    Teleport(workspace.GameAssets.Portals.Spawns[v].CFrame)
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

ArgetnarLib:Notify("Script", "Was Loaded!")
