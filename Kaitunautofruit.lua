local Config = {
    WebhookUrl = "https://discord.com/api/webhooks/1450138527344885946/aSxkvxkEsMQfNkkIEcfATyvUO1hI1XAOqZrfaUh17W6W9_ep8Ua-09tSV61DbDljneMX",
    DelayTime = 600,
    PingEveryone = true,
    LogFile = "log.txt"
}
local MythicalFruits = {["Kitsune"]=true,["Dragon"]=true,["Leopard"]=true,["Dough"]=true,["T-Rex"]=true,["Mammoth"]=true,["Spirit"]=true,["Venom"]=true,["Control"]=true,["Shadow"]=true}
local LegendaryFruits = {["Buddha"]=true,["Portal"]=true,["Rumble"]=true,["Blizzard"]=true,["Phoenix"]=true,["Sound"]=true,["Spider"]=true,["Love"]=true,["Pain"]=true,["Gravity"]=true}
local CommonFruits = {["Rocket"]=true,["Spin"]=true,["Chop"]=true,["Spring"]=true,["Bomb"]=true,["Smoke"]=true,["Spike"]=true,["Flame"]=true,["Falcon"]=true,["Ice"]=true,["Sand"]=true,["Dark"]=true,["Diamond"]=true}
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local Client = Players.LocalPlayer
local request = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
local function getLevel() if Client:FindFirstChild("Data") and Client.Data:FindFirstChild("Level") then return Client.Data.Level.Value end return "Unknown" end
local function getInventory()
    local inventory, foundRed, redList = {}, false, {}
    local function scan(container)
        for _, item in pairs(container:GetChildren()) do
            if item:IsA("Tool") and (string.find(item.Name, "Fruit") or item.ToolTip == "Blox Fruit") then
                local name = item.Name
                table.insert(inventory, name)
                for k,_ in pairs(MythicalFruits) do
                    if string.find(name, k) then
                        foundRed, table.insert(redList, name)
                        break
                    end
                end
            end
        end
    end
    if Client:FindFirstChild("Backpack") then scan(Client.Backpack) end
    if Client.Character then scan(Client.Character) end
    return inventory, foundRed, redList
end
local function logMessage(msg)
    print(msg)
    if Config.LogFile then
        local file = io.open(Config.LogFile, "a")
        if file then
            file:write(os.date("%Y-%m-%d %H:%M:%S") .. " | " .. msg .. "\n")
            file:close()
        end
    end
end
local function displayAccountInfo() logMessage("Account: " .. Client.Name .. " (Lv " .. getLevel() .. ")") end
local function sendDiscordWebhook(items, isRed, redItems)
    local timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    local playerName = Client.Name
    local level = getLevel()
    local avatarUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. Client.UserId .. "&width=420&height=420&format=png"
    local embedColor = isRed and 15548997 or 3447003
    local title = isRed and ("🚨 " .. playerName .. " ĐÃ TÌM THẤY TRÁI XỊN!") or ("👤 " .. playerName .. " | Báo Cáo Định Kỳ")
    local statusDesc = isRed and ("🔥 **PHÁT HIỆN:** " .. table.concat(redItems, ", ")) or "✅ Trạng thái: Bình thường"
    local listStr = ""
    if #items > 0 then
        for _, v in pairs(items) do
            local special = false
            for k,_ in pairs(MythicalFruits) do
                if string.find(v, k) then special = true break end
            end
            listStr = listStr .. (special and "**🔥 " .. v .. "**\n" or "• " .. v .. "\n")
        end
    else
        listStr = "(Không có trái nào)"
    end
    local payload = {
        content = isRed and Config.PingEveryone and ("@everyone ⚠️ **" .. playerName .. "** (Lv. " .. level .. ") vừa nhặt được đồ ngon!") or "",
        embeds = {{
            title = title,
            description = statusDesc,
            color = embedColor,
            thumbnail = {url = avatarUrl},
            fields = {{
                name = "👤 Tài khoản",
                value = "**Name:** " .. playerName .. "\n**Level:** " .. level,
                inline = false
            }, {
                name = "📦 Inventory",
                value = listStr,
                inline = false
            }},
            footer = {text = "Blox Fruits Auto-Check | JobID: " .. game.JobId},
            timestamp = timestamp
        }}
    }
    local success, err = pcall(function()
        request({
            Url = Config.WebhookUrl,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(payload)
        })
    end)
    if success then
        logMessage("✅ Đã gửi báo cáo cho acc " .. playerName .. (isRed and " (Trái Xịn!)" or ""))
    else
        logMessage("❌ Lỗi gửi Webhook: " .. tostring(err))
    end
end
print("=== SCRIPT STARTED ===")
displayAccountInfo()
task.spawn(function()
    while true do
        local items, isRed, redItems = getInventory()
        sendDiscordWebhook(items, isRed, redItems)
        displayAccountInfo()
        logMessage("⏳ Đang chờ " .. Config.DelayTime .. " giây...")
        task.wait(Config.DelayTime)
    end
end)
