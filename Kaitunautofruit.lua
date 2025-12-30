-- ================= INTRO LOGO =================
pcall(function()
    local Tween=game:GetService("TweenService")
    local gui=Instance.new("ScreenGui",game.CoreGui)
    gui.Name="ShopIntro"
    local img=Instance.new("ImageLabel",gui)
    img.AnchorPoint=Vector2.new(0.5,0.5)
    img.Position=UDim2.fromScale(0.5,0.4)
    img.Size=UDim2.fromScale(0.01,0.01)
    img.BackgroundTransparency=1
    img.Image="https://i.imgur.com/DwzRZ7Z.jpeg"
    img.ImageTransparency=1
    Tween:Create(img,TweenInfo.new(0.6,Enum.EasingStyle.Quad),{Size=UDim2.fromScale(0.28,0.28),ImageTransparency=0}):Play()
    task.wait(3)
    Tween:Create(img,TweenInfo.new(0.5,Enum.EasingStyle.Quad),{Size=UDim2.fromScale(0.01,0.01),ImageTransparency=1}):Play()
    task.wait(0.6)
    gui:Destroy()
end)

-- ================= CONFIG =================
getgenv().SpeedTween=200
getgenv().RandomFruit=true
getgenv().EspFruit=false
getgenv().Team="Marines"
getgenv().WebhookUrl=''

local P=game.Players.LocalPlayer
local RS=game:GetService("ReplicatedStorage")
local W=workspace
local TS=game:GetService("TeleportService")
local HttpService=game:GetService("HttpService")
local TeamsService=game:GetService("Teams")

repeat task.wait() until P.Character and P.Character:FindFirstChild("HumanoidRootPart")
local HRP=P.Character.HumanoidRootPart

pcall(function() if P.Team~=TeamsService[getgenv().Team] then P.Team=TeamsService[getgenv().Team] end end)

local function waitR() task.wait(math.random(18,32)/10) end
local function NearPlayer() for _,v in pairs(game.Players:GetPlayers()) do if v~=P and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then if (v.Character.HumanoidRootPart.Position-HRP.Position).Magnitude<80 then return true end end end end

task.spawn(function() while task.wait(1) do if NearPlayer() then continue end for _,v in pairs(W:GetChildren()) do if v:IsA("Tool") and v:FindFirstChild("Handle") then pcall(function() HRP.CFrame=HRP.CFrame:Lerp(v.Handle.CFrame,getgenv().SpeedTween/1000) waitR() end) end end end end)
task.spawn(function() while task.wait(3) do for _,r in pairs(RS:GetDescendants()) do if r:IsA("RemoteEvent") and r.Name:lower():find("store") then for _,t in pairs(P.Backpack:GetChildren()) do pcall(function() r:FireServer(t.Name) end) waitR() end end end end end)
if getgenv().RandomFruit then task.spawn(function() while task.wait(5) do for _,r in pairs(RS:GetDescendants()) do if r:IsA("RemoteEvent") and r.Name:lower():find("random") then pcall(function() r:FireServer() end) waitR() end end end end) end

local Visited={}
local function HopServer()
    local Servers={}
    local PlaceId=game.PlaceId
    local success,data=pcall(function() return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100")) end)
    if success and data and data.data then
        for _,s in pairs(data.data) do if s.id~=game.JobId and s.playing<s.maxPlayers and not Visited[s.id] then table.insert(Servers,s.id) end end
        if #Servers>0 then local sid=Servers[math.random(1,#Servers)] table.insert(Visited,game.JobId) TS:TeleportToPlaceInstance(PlaceId,sid,P) end
    end
end
task.spawn(function() while task.wait(10) do if #P.Backpack:GetChildren()==0 then HopServer() end end end)

pcall(function() loadstring(game:HttpGet('https://raw.githubusercontent.com/phattuanbao-blip/Kaitunfruittuan.lua/refs/heads/main/Kaitunautofruit.lua'))() end)
