-- 1. تحديد أنسب مكان لعرض الواجهة بدون الاعتماد على PlayerGui
local function getSafeParent()
    local success, hui = pcall(function()
        return gethui and gethui()
    end)
    if success and hui then
        return hui
    end

    local coreSuccess, coreGui = pcall(function()
        return game:GetService("CoreGui")
    end)
    if coreSuccess and coreGui then
        return coreGui
    end

    -- كحل أخير لو مفيش غير PlayerGui
    local players = game:GetService("Players")
    local lp = players.LocalPlayer
    return lp and lp:FindFirstChildOfClass("PlayerGui")
end

local targetParent = getSafeParent()
if not targetParent then
    warn("[UI Error]: مفيش مكان متاح لعرض الواجهة حالياً.")
    return
end

-- تنظيف أي نسخة قديمة بنفس الاسم عشان ما تتكررش
local oldUI = targetParent:FindFirstChild("StandaloneRunnerUI")
if oldUI then
    pcall(function() oldUI:Destroy() end)
end

-- 2. إنشاء عناصر الواجهة
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StandaloneRunnerUI"
screenGui.ResetOnSpawn = false
pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(screenGui)
    elseif protectgui then
        protectgui(screenGui)
    end
end)
screenGui.Parent = targetParent

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 420, 0, 260)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -130)
mainFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
titleLabel.BorderSizePixel = 0
titleLabel.Text = "  Standalone Runner"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 15
titleLabel.Parent = mainFrame

local codeBox = Instance.new("TextBox")
codeBox.Size = UDim2.new(1, -20, 1, -85)
codeBox.Position = UDim2.new(0, 10, 0, 40)
codeBox.BackgroundColor3 = Color3.fromRGB(38, 38, 44)
codeBox.BorderSizePixel = 0
codeBox.TextColor3 = Color3.fromRGB(235, 235, 235)
codeBox.PlaceholderText = "-- اكتب الكود هنا..."
codeBox.Text = ""
codeBox.TextXAlignment = Enum.TextXAlignment.Left
codeBox.TextYAlignment = Enum.TextYAlignment.Top
codeBox.ClearTextOnFocus = false
codeBox.MultiLine = true
codeBox.TextWrapped = true
codeBox.Font = Enum.Font.Code
codeBox.TextSize = 14
codeBox.Parent = mainFrame

local execButton = Instance.new("TextButton")
execButton.Size = UDim2.new(0.48, -10, 0, 32)
execButton.Position = UDim2.new(0, 10, 1, -38)
execButton.BackgroundColor3 = Color3.fromRGB(46, 160, 67)
execButton.BorderSizePixel = 0
execButton.Text = "Execute"
execButton.TextColor3 = Color3.fromRGB(255, 255, 255)
execButton.Font = Enum.Font.SourceSansBold
execButton.TextSize = 15
execButton.Parent = mainFrame

local clearButton = Instance.new("TextButton")
clearButton.Size = UDim2.new(0.48, -10, 0, 32)
clearButton.Position = UDim2.new(0.52, 0, 1, -38)
clearButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
clearButton.BorderSizePixel = 0
clearButton.Text = "Clear"
clearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
clearButton.Font = Enum.Font.SourceSansBold
clearButton.TextSize = 15
clearButton.Parent = mainFrame

-- 3. دالة تشغيل آمنة ببدائل متعددة
local function safeExecute(sourceCode)
    if type(sourceCode) ~= "string" or sourceCode == "" then return end

    local compiler = loadstring or load
    if not compiler then
        warn("[Error]: دالة loadstring أو load غير متوفرة في البيئة الحالية.")
        return
    end

    local fn, syntaxErr = compiler(sourceCode)
    if not fn then
        warn("[Syntax Error]: " .. tostring(syntaxErr))
        return
    end

    local runner = (task and task.spawn) or coroutine.wrap
    runner(function()
        local ok, runtimeErr = pcall(fn)
        if not ok then
            warn("[Runtime Error]: " .. tostring(runtimeErr))
        end
    end)()
end

execButton.MouseButton1Click:Connect(function()
    safeExecute(codeBox.Text)
end)

clearButton.MouseButton1Click:Connect(function()
    codeBox.Text = ""
end)
