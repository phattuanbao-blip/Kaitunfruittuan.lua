-- ================= CONFIG =================
getgenv().Team = "Marines" -- "Pirates" hoặc "Marines"

-- ================= LOGO NHẸ =================
pcall(function()
    local Tween = game:GetService("TweenService")
    local gui = Instance.new("ScreenGui", game.CoreGui)
    gui.Name = "ScriptIntro"
    local img = Instance.new("ImageLabel", gui)
    img.AnchorPoint = Vector2.new(0.5, 0.5)
    img.Position = UDim2.fromScale(0.5, 0.4)
    img.Size = UDim2.fromScale(0.01, 0.01)
    img.BackgroundTransparency = 1
    img.Image = "https://i.imgur.com/DwzRZ7Z.jpeg"
    img.ImageTransparency = 1
    Tween:Create(img, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {Size = UDim2.fromScale(0.28, 0.28), ImageTransparency = 0}):Play()
    task.wait(3)
    Tween:Create(img, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {Size = UDim2.fromScale(0.01, 0.01), ImageTransparency = 1}):Play()
    task.wait(0.6)
    gui:Destroy()
end)

-- ================= AUTO CHOOSE TEAM =================
if game.PlaceId == 2753915549 or game.PlaceId == 4442272183 or game.PlaceId == 7449423635 then
    task.wait()
    local Players = game:GetService("Players")
    local P = Players.LocalPlayer
    local guiMain = P.PlayerGui:WaitForChild("Main"):WaitForChild("ChooseTeam")
    if guiMain then
        local function pressButton(frame)
            for _,v in pairs(getconnections(frame.Activated)) do
                v.Function()
            end
        end
        if string.find(tostring(getgenv().Team), "Pirate") then
            pressButton(guiMain.Container.Pirates.Frame.TextButton)
        elseif string.find(tostring(getgenv().Team), "Marine") then
            pressButton(guiMain.Container.Marines.Frame.TextButton)
        else
            pressButton(guiMain.Container.Pirates.Frame.TextButton)
        end
    end

    -- ================= QUEUE TELEPORT =================
    local queueteleport = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport
    if queueteleport then
        queueteleport([[loadstring(game:HttpGet('https://raw.githubusercontent.com/phattuanbao-blip/Kaitunfruittuan.lua/refs/heads/main/Kaitunautofruit.lua'))()]])
    end

    -- ================= LOAD SCRIPT =================
    loadstring(game:HttpGet('https://raw.githubusercontent.com/phattuanbao-blip/Kaitunfruittuan.lua/refs/heads/main/Kaitunautofruit.lua'))()
end
