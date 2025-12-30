-- ================= INTRO LOGO =================
pcall(function()
 local Tween=game:GetService("TweenService")
 local P=game:GetService("Players").LocalPlayer
 local gui=Instance.new("ScreenGui",P:WaitForChild("PlayerGui"))
 gui.ResetOnSpawn=false

 local img=Instance.new("ImageLabel",gui)
 img.AnchorPoint=Vector2.new(0.5,0.5)
 img.Position=UDim2.fromScale(0.5,0.4)
 img.Size=UDim2.fromScale(0.01,0.01)
 img.BackgroundTransparency=1
 img.Image="https://i.imgur.com/DwzRZ7Z.jpeg"
 img.ImageTransparency=1

 local btn=Instance.new("TextButton",gui)
 btn.Size=UDim2.fromScale(0.12,0.05)
 btn.Position=UDim2.fromScale(0.5,0.62)
 btn.AnchorPoint=Vector2.new(0.5,0.5)
 btn.Text="✖ TẮT"
 btn.BackgroundColor3=Color3.fromRGB(20,20,20)
 btn.TextColor3=Color3.new(1,1,1)
 btn.BackgroundTransparency=0.3
 btn.MouseButton1Click:Connect(function() gui:Destroy() end)

 Tween:Create(img,TweenInfo.new(0.6),{Size=UDim2.fromScale(0.28,0.28),ImageTransparency=0}):Play()
 task.wait(3)
 gui:Destroy()
end)

-- ================= CONFIG =================
getgenv().Cfg={
 Pick=true, Store=true, Random=true, Hop=true,
 Delay={1.5,3}, PlayerCheck=true,
 WorkTime=math.random(600,900), RestTime=math.random(60,300)
}

local c=getgenv().Cfg
local Players=game:GetService("Players")
local P=Players.LocalPlayer
local RS=game:GetService("ReplicatedStorage")
local TS=game:GetService("TeleportService")
local UIS=game:GetService("UserInputService")
local Cam=workspace.CurrentCamera
local W=workspace

-- ================= UTILS =================
local function waitR() task.wait(math.random(c.Delay[1]*10,c.Delay[2]*10)/10) end
local function NearPlayer()
 for _,v in pairs(Players:GetPlayers()) do
  if v~=P and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
   if (v.Character.HumanoidRootPart.Position-P.Character.HumanoidRootPart.Position).Magnitude<80 then return true end
  end
 end
end
local function NoFruit()
 for _,v in pairs(W:GetChildren()) do
  if v:IsA("Tool") and v:FindFirstChild("Handle") then return false end
 end
 return true
end

-- ================= ANTI ADMIN =================
local AdminKeys={"admin","mod","owner","dev"}
Players.PlayerAdded:Connect(function(plr)
 for _,k in ipairs(AdminKeys) do
  if plr.Name:lower():find(k) then TS:Teleport(game.PlaceId,P) end
 end
end)

-- ================= FAKE PLAYER =================
task.spawn(function()
 local keys={Enum.KeyCode.W,Enum.KeyCode.A,Enum.KeyCode.S,Enum.KeyCode.D}
 while task.wait(math.random(15,30)) do
  if P.Character and P.Character:FindFirstChild("Humanoid") then
   pcall(function()
    local k=keys[math.random(#keys)]
    UIS:SetKeyDown(k); task.wait(math.random(0.3,1)); UIS:SetKeyUp(k)
    Cam.CFrame=Cam.CFrame*CFrame.Angles(0,math.rad(math.random(-15,15)),0)
    P.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
   end)
  end
 end
end)

-- ================= REST MODE =================
task.spawn(function()
 while task.wait(c.WorkTime) do task.wait(c.RestTime) end
end)

-- ================= AUTO PICK =================
if c.Pick then task.spawn(function()
 while task.wait(1) do
  if c.PlayerCheck and NearPlayer() then continue end
  for _,v in pairs(W:GetChildren()) do
   if v:IsA("Tool") and v:FindFirstChild("Handle") then
    if P.Character and P.Character:FindFirstChild("HumanoidRootPart") then
     pcall(function() P.Character.HumanoidRootPart.CFrame=P.Character.HumanoidRootPart.CFrame:Lerp(v.Handle.CFrame,0.35); waitR() end)
    end
   end
  end
 end
end) end

-- ================= AUTO STORE =================
if c.Store then task.spawn(function()
 while task.wait(5) do
  for _,r in pairs(RS:GetDescendants()) do
   if r:IsA("RemoteEvent") and r.Name:lower():find("store") then
    for _,t in pairs(P.Backpack:GetChildren()) do r:FireServer(t.Name); waitR() end
   end
  end
 end
end) end

-- ================= AUTO RANDOM =================
if c.Random then task.spawn(function()
 while task.wait(30) do
  for _,r in pairs(RS:GetDescendants()) do
   if r:IsA("RemoteEvent") and r.Name:lower():find("random") then r:FireServer(); waitR() end
  end
 end
end) end

-- ================= AUTO HOP =================
if c.Hop then task.spawn(function()
 while task.wait(10) do if NoFruit() then TS:Teleport(game.PlaceId,P) end end
end) end
