-- DELTA SAFE | AUTO FRUIT PICK (Blox Fruits)

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LP = Players.LocalPlayer

-- ====== CONFIG ======
local PICK_DELAY = 1.2
local HOP_DELAY  = 25

-- ====== WAIT CHAR ======
repeat task.wait() until LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
local HRP = LP.Character.HumanoidRootPart

-- ====== FIND FRUIT ======
local function GetFruit()
    for _,v in pairs(Workspace:GetChildren()) do
        if v:IsA("Tool") and v:FindFirstChild("Handle") then
            return v
        end
    end
end

-- ====== AUTO STORE ======
local function StoreFruit()
    for _,r in pairs(ReplicatedStorage:GetDescendants()) do
        if r:IsA("RemoteEvent") and r.Name:lower():find("store") then
            for _,t in pairs(LP.Backpack:GetChildren()) do
                pcall(function()
                    r:FireServer(t.Name)
                end)
            end
        end
    end
end

-- ====== MAIN LOOP ======
task.spawn(function()
    while task.wait(PICK_DELAY) do
        local fruit = GetFruit()
        if fruit and fruit:FindFirstChild("Handle") then
            pcall(function()
                HRP.CFrame = fruit.Handle.CFrame * CFrame.new(0,2,0)
            end)
            task.wait(0.8)
            StoreFruit()
        end
    end
end)

-- ====== AUTO HOP ======
task.spawn(function()
    while task.wait(HOP_DELAY) do
        if not GetFruit() then
            TeleportService:Teleport(game.PlaceId, LP)
            task.wait(8)
        end
    end
end)

print("✅ Delta Auto Fruit Loaded")
