-- 授权状态显示界面
local Players = game:GetService("Players")
local AnalyticsService = game:GetService("RbxAnalyticsService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 获取 HWID
local hwid = AnalyticsService:GetClientId()

-- 授权检查函数
local function checkAuthorization()
    local authUrl = "https://raw.githubusercontent.com/ljxttkx1228/Jupiter/refs/heads/main/auth.json"
    
    local ok, resp = pcall(game.HttpGet, game, authUrl)
    if not ok then
        return false, "无法连接授权服务器", nil
    end
    
    local decode_ok, data = pcall(HttpService.JSONDecode, HttpService, resp)
    if not decode_ok or type(data) ~= "table" or not data.authorized_users then
        return false, "授权文件解析失败", nil
    end
    
    for _, user in ipairs(data.authorized_users) do
        if tostring(user.hwid) == tostring(hwid) then
            return true, "已授权", user.expiry_date
        end
    end
    
    return false, "未授权", nil
end

-- 创建 UI
local authUI = Instance.new("ScreenGui")
authUI.Name = "AuthorizationStatus"
authUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
authUI.Parent = playerGui

-- 主窗口
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 280)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -140)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = authUI

-- 圆角效果
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = mainFrame

-- 阴影效果
local uiShadow = Instance.new("UIStroke")
uiShadow.Color = Color3.fromRGB(0, 0, 0)
uiShadow.Thickness = 2
uiShadow.Transparency = 0.8
uiShadow.Parent = mainFrame

-- 标题栏
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🔐 授权状态"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 18
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- 关闭按钮
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 32, 0, 32)
closeButton.Position = UDim2.new(1, -37, 0, 6)
closeButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
closeButton.BorderSizePixel = 0
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 20
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

-- 内容区域
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -30, 1, -65)
contentFrame.Position = UDim2.new(0, 15, 0, 55)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- HWID 显示卡片
local hwidCard = Instance.new("Frame")
hwidCard.Size = UDim2.new(1, 0, 0, 80)
hwidCard.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
hwidCard.BorderSizePixel = 0
hwidCard.Parent = contentFrame

local hwidCardCorner = Instance.new("UICorner")
hwidCardCorner.CornerRadius = UDim.new(0, 8)
hwidCardCorner.Parent = hwidCard

local hwidTitle = Instance.new("TextLabel")
hwidTitle.Size = UDim2.new(1, -20, 0, 25)
hwidTitle.Position = UDim2.new(0, 15, 0, 10)
hwidTitle.BackgroundTransparency = 1
hwidTitle.Text = "🖥️ 设备 HWID"
hwidTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
hwidTitle.TextSize = 14
hwidTitle.Font = Enum.Font.Gotham
hwidTitle.TextXAlignment = Enum.TextXAlignment.Left
hwidTitle.Parent = hwidCard

local hwidValue = Instance.new("TextLabel")
hwidValue.Size = UDim2.new(1, -20, 0, 35)
hwidValue.Position = UDim2.new(0, 15, 0, 35)
hwidValue.BackgroundTransparency = 1
hwidValue.Text = hwid
hwidValue.TextColor3 = Color3.fromRGB(255, 255, 255)
hwidValue.TextSize = 13
hwidValue.Font = Enum.Font.Gotham
hwidValue.TextXAlignment = Enum.TextXAlignment.Left
hwidValue.TextYAlignment = Enum.TextYAlignment.Top
hwidValue.TextWrapped = true
hwidValue.Parent = hwidCard

-- 授权状态卡片
local authCard = Instance.new("Frame")
authCard.Size = UDim2.new(1, 0, 0, 100)
authCard.Position = UDim2.new(0, 0, 0, 90)
authCard.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
authCard.BorderSizePixel = 0
authCard.Parent = contentFrame

local authCardCorner = Instance.new("UICorner")
authCardCorner.CornerRadius = UDim.new(0, 8)
authCardCorner.Parent = authCard

local authTitle = Instance.new("TextLabel")
authTitle.Size = UDim2.new(1, -20, 0, 25)
authTitle.Position = UDim2.new(0, 15, 0, 10)
authTitle.BackgroundTransparency = 1
authTitle.Text = "🔍 授权状态"
authTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
authTitle.TextSize = 14
authTitle.Font = Enum.Font.Gotham
authTitle.TextXAlignment = Enum.TextXAlignment.Left
authTitle.Parent = authCard

-- 授权状态显示
local authStatus = Instance.new("TextLabel")
authStatus.Size = UDim2.new(1, -20, 0, 30)
authStatus.Position = UDim2.new(0, 15, 0, 35)
authStatus.BackgroundTransparency = 1
authStatus.Text = "检查中..."
authStatus.TextColor3 = Color3.fromRGB(255, 255, 100)
authStatus.TextSize = 16
authStatus.Font = Enum.Font.GothamBold
authStatus.TextXAlignment = Enum.TextXAlignment.Left
authStatus.Parent = authCard

-- 到期时间显示
local expiryLabel = Instance.new("TextLabel")
expiryLabel.Size = UDim2.new(1, -20, 0, 30)
expiryLabel.Position = UDim2.new(0, 15, 0, 65)
expiryLabel.BackgroundTransparency = 1
expiryLabel.Text = "到期时间: --"
expiryLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
expiryLabel.TextSize = 14
expiryLabel.Font = Enum.Font.Gotham
expiryLabel.TextXAlignment = Enum.TextXAlignment.Left
expiryLabel.Parent = authCard

-- 复制按钮
local copyButton = Instance.new("TextButton")
copyButton.Size = UDim2.new(0, 100, 0, 35)
copyButton.Position = UDim2.new(0.5, -50, 1, -45)
copyButton.BackgroundColor3 = Color3.fromRGB(60, 120, 220)
copyButton.BorderSizePixel = 0
copyButton.Text = "复制 HWID"
copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
copyButton.TextSize = 14
copyButton.Font = Enum.Font.GothamBold
copyButton.Parent = contentFrame

local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(0, 8)
copyCorner.Parent = copyButton

-- 拖动功能
local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- 关闭按钮功能
closeButton.MouseButton1Click:Connect(function()
    authUI:Destroy()
end)

-- 复制按钮功能
copyButton.MouseButton1Click:Connect(function()
    setclipboard(hwid)
    
    local originalText = copyButton.Text
    local originalColor = copyButton.BackgroundColor3
    
    copyButton.Text = "已复制!"
    copyButton.BackgroundColor3 = Color3.fromRGB(60, 180, 80)
    
    wait(1.5)
    
    copyButton.Text = originalText
    copyButton.BackgroundColor3 = originalColor
end)

-- 执行授权检查
spawn(function()
    local isAuthorized, statusMessage, expiryDate = checkAuthorization()
    
    if isAuthorized then
        authStatus.Text = "✅ " .. statusMessage
        authStatus.TextColor3 = Color3.fromRGB(80, 200, 120)
        
        if expiryDate then
            expiryLabel.Text = "到期时间: " .. expiryDate
            expiryLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
        else
            expiryLabel.Text = "到期时间: 永久"
            expiryLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
        end
    else
        authStatus.Text = "❌ " .. statusMessage
        authStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
        expiryLabel.Text = "到期时间: --"
        expiryLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    end
end)

-- 动画效果
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

local openTween = TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 400, 0, 280),
    Position = UDim2.new(0.5, -200, 0.5, -140)
})
openTween:Play()

print("[授权状态] 界面已打开")
