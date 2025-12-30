local c=getgenv().Cfg
local P=game.Players.LocalPlayer
local RS=game.ReplicatedStorage
local TS=game.TeleportService
local W=workspace
local UIS=game:GetService("UserInputService")

-- random delay
local function waitR()
 task.wait(math.random(c.Delay[1]*10,c.Delay[2]*10)/10)
end

-- check player gần
local function Near()
 for _,v in pairs(game.Players:GetPlayers()) do
  if v~=P and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
   if (v.Character.HumanoidRootPart.Position-
      P.Character.HumanoidRootPart.Position).Magnitude<80 then
    return true
   end
  end
 end
end

-- Auto nhặt trái (an toàn)
if c.Pick then task.spawn(function()
 while task.wait(1) do
  if c.PlayerCheck and Near() then continue end
  for _,v in pairs(W:GetChildren()) do
   if v:IsA("Tool") and v:FindFirstChild("Handle") then
    P.Character.HumanoidRootPart.CFrame=
     P.Character.HumanoidRootPart.CFrame:Lerp(v.Handle.CFrame,0.3)
    waitR()
   end
  end
 end
end) end

-- Auto store
if c.Store then task.spawn(function()
 while task.wait(5) do
  for _,r in pairs(RS:GetDescendants()) do
   if r:IsA("RemoteEvent") and r.Name:lower():find("store") then
    for _,t in pairs(P.Backpack:GetChildren()) do
     r:FireServer(t.Name); waitR()
    end
   end
  end
 end
end) end

-- Auto random
if c.Random then task.spawn(function()
 while task.wait(30) do
  for _,r in pairs(RS:GetDescendants()) do
   if r:IsA("RemoteEvent") and r.Name:lower():find("random") then
    r:FireServer(); waitR()
   end
  end
 end
end) end

-- Auto hop
if c.Hop then task.spawn(function()
 while task.wait(60) do
  TS:Teleport(game.PlaceId,P)
 end
end) end
