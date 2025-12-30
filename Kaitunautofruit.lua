-- ================= DELTA-SAFE AUTO FRUIT + STORE + AUTO JOIN =================

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local TS = game:GetService("TeleportService")
local LP = Players.LocalPlayer

-- ===== CONFIG =====
getgenv().Team = "Marines"      -- tự động join team
local SpeedTween = 200           -- tốc độ bay tới fruit
local PICK_DELAY = 1.2
local HOP_DELAY = 25

-- ===== WAIT FOR CHAR =====
repeat task.wait() until LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
local HRP = LP.Character.HumanoidRootPart

-- ===== AUTO JOIN TEAM =====
task.spawn(function()
    pcall(function()
        for _,r in pairs(RS:GetDescendants()) do
            if r:IsA("RemoteEvent") and r.Name:lower():find("team") then
                r:FireServer(getgenv().Team)
            end
        end
    end)
end)

-- ===== AUTO FRUIT PICK =====
local function GetFruit()
    for _,v in pairs(WS:GetChildren()) do
        if v:IsA("Tool") and v:FindFirstChild("Handle") then return v end
    end
end

-- ===== AUTO STORE =====
local function StoreFruit()
    for _,r in pairs(RS:GetDescendants()) do
        if r:IsA("RemoteEvent") and r.Name:lower():find("store") then
            for _,t in pairs(LP.Backpack:GetChildren()) do
                pcall(function() r:FireServer(t.Name) end)
            end
        end
    end
end

-- ===== MAIN LOOP =====
task.spawn(function()
    while task.wait(PICK_DELAY) do
        local fruit = GetFruit()
        if fruit and fruit:FindFirstChild("Handle") then
            pcall(function()
                HRP.CFrame = fruit.Handle.CFrame * CFrame.new(0,2,0)
            end)
            task.wait(0.8)
            StoreFruit()        -- auto store ngay khi nhặt
        end
    end
end)

-- ===== AUTO HOP =====
task.spawn(function()
    while task.wait(HOP_DELAY) do
        if not GetFruit() then
            TS:Teleport(game.PlaceId, LP)
            task.wait(8)
        end
    end
end)

print("✅ Delta Auto Fruit + Store + Auto Join Marines Loaded")
