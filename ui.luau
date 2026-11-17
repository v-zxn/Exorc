--[[
    EXORC STANDALONE MOBILE UI & EXECUTOR ENVIRONMENT
    Target: Mobile Touchscreen + Cross-Platform Roblox Luau
    Design: Dark Modern Glassmorphism + Mobile Draggable/Collapsible Toggle + Tabbed Runner
]]

-- 0. Executor Compatibility & Compatibility Layer Setup
local function initCompatibilityLayer()
    local G = (getgenv and getgenv()) or _G or shared

    -- identifyexecutor
    if not G.identifyexecutor then
        G.identifyexecutor = function()
            return "Exorc", "v2.0-Alpha"
        end
    end
    if not G.getexecutorname then
        G.getexecutorname = G.identifyexecutor
    end

    -- HttpGet compatibility
    if not G.HttpGet and G.httpget then
        G.HttpGet = G.httpget
    elseif not G.httpget and G.HttpGet then
        G.httpget = G.HttpGet
    end

    -- Hook game:HttpGet if missing on game instance
    pcall(function()
        local mt = getrawmetatable and getrawmetatable(game)
        if mt and not mt.HttpGet then
            local oldIndex = mt.__index
            if setreadonly then setreadonly(mt, false) end
            mt.HttpGet = function(self, url)
                if G.httpget then return G.httpget(url) end
                if G.HttpGet then return G.HttpGet(url) end
                if request then
                    local res = request({Url = url, Method = "GET"})
                    return res and (res.Body or res.body)
                end
                error("No HTTP provider available")
            end
            mt.HttpGetAsync = mt.HttpGet
            if setreadonly then setreadonly(mt, true) end
        end
    end)

    -- setclipboard polyfill
    if not G.setclipboard and not G.toclipboard then
        G.setclipboard = function(txt)
            -- fallback
        end
        G.toclipboard = G.setclipboard
    end
end

initCompatibilityLayer()

-- 1. Safe Parent Detection (Prioritizing CoreGui / gethui / PlayerGui)
local function getSafeParent()
    local success, hui = pcall(function()
        return gethui and gethui()
    end)
    if success and hui then return hui end

    local coreSuccess, coreGui = pcall(function()
        return game:GetService("CoreGui")
    end)
    if coreSuccess and coreGui then return coreGui end

    local players = game:GetService("Players")
    local lp = players.LocalPlayer
    if lp then
        return lp:FindFirstChildOfClass("PlayerGui")
    end
    return nil
end

local targetParent = getSafeParent()
if not targetParent then
    warn("[EXORC UI Error]: No valid Gui parent found.")
    return
end

-- Cleanup prior instances
local oldUI = targetParent:FindFirstChild("ExorcMobileUI")
if oldUI then
    pcall(function() oldUI:Destroy() end)
end

-- 2. GUI Structure Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ExorcMobileUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(screenGui)
    elseif protectgui then
        protectgui(screenGui)
    end
end)
screenGui.Parent = targetParent

-- Helper function to round corners
local function addCorner(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = instance
    return corner
end

-- Helper function to add stroke
local function addStroke(instance, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(60, 60, 75)
    stroke.Thickness = thickness or 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = instance
    return stroke
end

-- 3. Floating Mobile Toggle Icon (Always Accessible on Touch Screen)
local toggleIcon = Instance.new("TextButton")
toggleIcon.Name = "ExorcFloatingToggle"
toggleIcon.Size = UDim2.new(0, 48, 0, 48)
toggleIcon.Position = UDim2.new(0, 15, 0.4, 0)
toggleIcon.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
toggleIcon.BorderSizePixel = 0
toggleIcon.Text = "⚡"
toggleIcon.TextColor3 = Color3.fromRGB(255, 180, 50)
toggleIcon.TextSize = 22
toggleIcon.Font = Enum.Font.SourceSansBold
toggleIcon.Active = true
toggleIcon.Draggable = true
toggleIcon.AutoButtonColor = true
addCorner(toggleIcon, 24) -- Circle
addStroke(toggleIcon, Color3.fromRGB(255, 180, 50), 1.5)
toggleIcon.Parent = screenGui

-- 4. Main Window (Sized for Mobile & Desktop)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 450, 0, 280)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -140)
mainFrame.BackgroundColor3 = Color3.fromRGB(16, 17, 22)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true
addCorner(mainFrame, 10)
addStroke(mainFrame, Color3.fromRGB(45, 45, 60), 1.5)
mainFrame.Parent = screenGui

-- Header Bar
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 36)
header.BackgroundColor3 = Color3.fromRGB(22, 23, 30)
header.BorderSizePixel = 0
header.Parent = mainFrame
addCorner(header, 10)

-- Fill bottom corners of header so it merges cleanly with mainFrame
local headerBottomCover = Instance.new("Frame")
headerBottomCover.Size = UDim2.new(1, 0, 0, 10)
headerBottomCover.Position = UDim2.new(0, 0, 1, -10)
headerBottomCover.BackgroundColor3 = Color3.fromRGB(22, 23, 30)
headerBottomCover.BorderSizePixel = 0
headerBottomCover.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 200, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "EXORC // EXECUTOR"
title.TextColor3 = Color3.fromRGB(240, 240, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = header

-- Minimize / Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -32, 0, 4)
closeBtn.BackgroundColor3 = Color3.fromRGB(35, 36, 45)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
addCorner(closeBtn, 6)
closeBtn.Parent = header

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

toggleIcon.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- Code Editor Box Container
local editorContainer = Instance.new("Frame")
editorContainer.Size = UDim2.new(1, -20, 1, -95)
editorContainer.Position = UDim2.new(0, 10, 0, 44)
editorContainer.BackgroundColor3 = Color3.fromRGB(23, 24, 32)
editorContainer.BorderSizePixel = 0
addCorner(editorContainer, 8)
addStroke(editorContainer, Color3.fromRGB(38, 40, 52), 1)
editorContainer.Parent = mainFrame

local codeBox = Instance.new("TextBox")
codeBox.Size = UDim2.new(1, -16, 1, -16)
codeBox.Position = UDim2.new(0, 8, 0, 8)
codeBox.BackgroundTransparency = 1
codeBox.TextColor3 = Color3.fromRGB(225, 230, 245)
codeBox.PlaceholderText = "-- Type or paste Luau script here..."
codeBox.PlaceholderColor3 = Color3.fromRGB(110, 115, 135)
codeBox.Text = ""
codeBox.TextXAlignment = Enum.TextXAlignment.Left
codeBox.TextYAlignment = Enum.TextYAlignment.Top
codeBox.ClearTextOnFocus = false
codeBox.MultiLine = true
codeBox.TextWrapped = true
codeBox.Font = Enum.Font.Code
codeBox.TextSize = 13
codeBox.Parent = editorContainer

-- Action Controls Container
local controls = Instance.new("Frame")
controls.Size = UDim2.new(1, -20, 0, 36)
controls.Position = UDim2.new(0, 10, 1, -44)
controls.BackgroundTransparency = 1
controls.Parent = mainFrame

local uilist = Instance.new("UIListLayout")
uilist.FillDirection = Enum.FillDirection.Horizontal
uilist.HorizontalAlignment = Enum.HorizontalAlignment.Left
uilist.VerticalAlignment = Enum.VerticalAlignment.Center
uilist.Padding = UDim.new(0, 8)
uilist.Parent = controls

local function makeButton(name, text, bgCol, txtCol)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0.31, -5, 1, 0)
    btn.BackgroundColor3 = bgCol
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = txtCol or Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 13
    btn.AutoButtonColor = true
    addCorner(btn, 6)
    btn.Parent = controls
    return btn
end

local execBtn = makeButton("ExecBtn", "Execute", Color3.fromRGB(40, 167, 69))
local clearBtn = makeButton("ClearBtn", "Clear", Color3.fromRGB(60, 64, 80))
local testBtn = makeButton("TestBtn", "UNC Test", Color3.fromRGB(0, 122, 255))

-- 5. Execution Handler
local function safeExecute(sourceCode)
    if type(sourceCode) ~= "string" or sourceCode == "" then return end

    local compiler = loadstring or load
    if not compiler then
        warn("[EXORC Error]: loadstring/load is not available.")
        return
    end

    local fn, syntaxErr = compiler(sourceCode)
    if not fn then
        warn("[EXORC Syntax Error]: " .. tostring(syntaxErr))
        return
    end

    local runner = (task and task.spawn) or coroutine.wrap
    runner(function()
        local ok, runtimeErr = pcall(fn)
        if not ok then
            warn("[EXORC Runtime Error]: " .. tostring(runtimeErr))
        end
    end)()
end

execBtn.MouseButton1Click:Connect(function()
    safeExecute(codeBox.Text)
end)

clearBtn.MouseButton1Click:Connect(function()
    codeBox.Text = ""
end)

testBtn.MouseButton1Click:Connect(function()
    -- Quick environment verification
    local testScript = [[
        print("--- [EXORC ENVIRONMENT DIAGNOSTIC] ---")
        print("Executor:", identifyexecutor and identifyexecutor() or "Unknown")
        print("loadstring:", type(loadstring))
        print("HttpGet:", type(game.HttpGet))
        print("request:", type(request or http_request or (syn and syn.request)))
        print("getgenv:", type(getgenv))
        print("getrenv:", type(getrenv))
        print("getrawmetatable:", type(getrawmetatable))
        print("hookfunction:", type(hookfunction))
        print("---------------------------------------")
    ]]
    safeExecute(testScript)
end)
