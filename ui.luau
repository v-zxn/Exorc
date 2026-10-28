-- ==============================================================================
-- ORC Mobile Modern Delta Architecture UI v3.0
-- Pure Monochrome (#000000 / #FFFFFF) - Isolated Right Dock - Floating Windows
-- Full Color-Coded Dual Console Engine (Error / Warn / Info / Script)
-- ==============================================================================

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LogService = game:GetService("LogService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local targetParent = CoreGui
pcall(function()
    if not pcall(function() return CoreGui.Name end) then
        targetParent = player:WaitForChild("PlayerGui", 5)
    end
end)

local existingUI = targetParent:FindFirstChild("ORC_DELTA_REAL_UI")
if existingUI then existingUI:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ORC_DELTA_REAL_UI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 999999
screenGui.Parent = targetParent

-- Palette (Monochrome Sharp Aesthetic)
local C_BG = Color3.fromRGB(12, 12, 14)
local C_BAR = Color3.fromRGB(18, 18, 22)
local C_BORDER = Color3.fromRGB(38, 38, 44)
local C_WHITE = Color3.fromRGB(255, 255, 255)
local C_MUTED = Color3.fromRGB(150, 150, 160)
local C_ACTIVE_GLOW = Color3.fromRGB(255, 255, 255)

-- ------------------------------------------------------------------------------
-- 1. FLOATING DRAGGABLE TOGGLE BUBBLE (Bottom / Screen edge)
-- ------------------------------------------------------------------------------
local floatingBubble = Instance.new("ImageButton")
floatingBubble.Name = "FloatingBubble"
floatingBubble.Size = UDim2.new(0, 46, 0, 46)
floatingBubble.Position = UDim2.new(1, -60, 0.45, 0)
floatingBubble.BackgroundColor3 = C_BG
floatingBubble.AutoButtonColor = false
floatingBubble.Visible = false
floatingBubble.Active = true
floatingBubble.Draggable = true
floatingBubble.Parent = screenGui

local bubbleCorner = Instance.new("UICorner")
bubbleCorner.CornerRadius = UDim.new(1, 0)
bubbleCorner.Parent = floatingBubble

local bubbleStroke = Instance.new("UIStroke")
bubbleStroke.Color = C_WHITE
bubbleStroke.Thickness = 1.5
bubbleStroke.Parent = floatingBubble

local bubbleLabel = Instance.new("TextLabel")
bubbleLabel.Size = UDim2.new(1, 0, 1, 0)
bubbleLabel.BackgroundTransparency = 1
bubbleLabel.Text = "O"
bubbleLabel.TextColor3 = C_WHITE
bubbleLabel.Font = Enum.Font.GothamBold
bubbleLabel.TextSize = 20
bubbleLabel.Parent = floatingBubble

-- ------------------------------------------------------------------------------
-- 2. DEDICATED INDEPENDENT RIGHT-SIDE DOCK (Delta Style)
-- ------------------------------------------------------------------------------
local rightDock = Instance.new("Frame")
rightDock.Name = "RightDock"
rightDock.Size = UDim2.new(0, 48, 0, 310)
rightDock.Position = UDim2.new(1, -58, 0.5, -155)
rightDock.BackgroundColor3 = C_BAR
rightDock.BorderSizePixel = 0
rightDock.Parent = screenGui

local dockCorner = Instance.new("UICorner")
dockCorner.CornerRadius = UDim.new(0, 16)
dockCorner.Parent = rightDock

local dockStroke = Instance.new("UIStroke")
dockStroke.Color = C_BORDER
dockStroke.Thickness = 1.2
dockStroke.Parent = rightDock

local dockLayout = Instance.new("UIListLayout")
dockLayout.SortOrder = Enum.SortOrder.LayoutOrder
dockLayout.Padding = UDim.new(0, 8)
dockLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
dockLayout.VerticalAlignment = Enum.VerticalAlignment.Center
dockLayout.Parent = rightDock

local dockPadding = Instance.new("UIPadding")
dockPadding.PaddingTop = UDim.new(0, 10)
dockPadding.PaddingBottom = UDim.new(0, 10)
dockPadding.Parent = rightDock

-- ------------------------------------------------------------------------------
-- 3. FLOATING MAIN WINDOW (Center/Left from the Dock)
-- ------------------------------------------------------------------------------
local mainWindow = Instance.new("Frame")
mainWindow.Name = "MainWindow"
mainWindow.Size = UDim2.new(0, 520, 0, 290)
mainWindow.Position = UDim2.new(0.5, -290, 0.5, -145)
mainWindow.BackgroundColor3 = C_BG
mainWindow.BorderSizePixel = 0
mainWindow.Active = true
mainWindow.Draggable = true
mainWindow.Parent = screenGui

local windowCorner = Instance.new("UICorner")
windowCorner.CornerRadius = UDim.new(0, 14)
windowCorner.Parent = mainWindow

local windowStroke = Instance.new("UIStroke")
windowStroke.Color = C_BORDER
windowStroke.Thickness = 1.2
windowStroke.Parent = mainWindow

-- Window Header
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 38)
header.BackgroundTransparency = 1
header.Parent = mainWindow

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -24, 1, 0)
titleLabel.Position = UDim2.new(0, 16, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "ORC STUDIO // EXECUTOR"
titleLabel.TextColor3 = C_WHITE
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 13
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = header

local headerDivider = Instance.new("Frame")
headerDivider.Size = UDim2.new(1, -32, 0, 1)
headerDivider.Position = UDim2.new(0, 16, 1, -1)
headerDivider.BackgroundColor3 = C_BORDER
headerDivider.BorderSizePixel = 0
headerDivider.Parent = header

-- Viewport Container
local viewport = Instance.new("Frame")
viewport.Name = "Viewport"
viewport.Size = UDim2.new(1, -32, 1, -48)
viewport.Position = UDim2.new(0, 16, 0, 44)
viewport.BackgroundTransparency = 1
viewport.Parent = mainWindow

-- ------------------------------------------------------------------------------
-- 4. DOCK BUTTON GENERATOR
-- ------------------------------------------------------------------------------
local pages = {}
local buttons = {}
local activeTab = nil

local function createDockButton(name, iconText, order, isClose)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, 36, 0, 36)
    btn.BackgroundColor3 = isClose and Color3.fromRGB(30, 18, 20) or Color3.fromRGB(24, 24, 30)
    btn.AutoButtonColor = false
    btn.LayoutOrder = order
    btn.Text = iconText
    btn.TextColor3 = isClose and Color3.fromRGB(255, 90, 90) or C_MUTED
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    btn.Parent = rightDock

    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 10)
    bCorner.Parent = btn

    local bStroke = Instance.new("UIStroke")
    bStroke.Color = C_BORDER
    bStroke.Thickness = 1
    bStroke.Parent = btn

    buttons[name] = btn
    return btn
end

local btnExecutor = createDockButton("Executor", ">_", 1)
local btnSaved = createDockButton("Saved", "★", 2)
local btnSearch = createDockButton("Search", "🔍", 3)
local btnConsole = createDockButton("Console", "≡", 4)
local btnSettings = createDockButton("Settings", "⚙", 5)
local btnClose = createDockButton("Close", "✕", 6, true)

-- ------------------------------------------------------------------------------
-- 5. TAB 1: CODE EXECUTOR & TERMINAL
-- ------------------------------------------------------------------------------
local pageExecutor = Instance.new("Frame")
pageExecutor.Name = "Page_Executor"
pageExecutor.Size = UDim2.new(1, 0, 1, 0)
pageExecutor.BackgroundTransparency = 1
pageExecutor.Visible = false
pageExecutor.Parent = viewport
pages["Executor"] = pageExecutor

local editorBox = Instance.new("TextBox")
editorBox.Name = "CodeBox"
editorBox.Size = UDim2.new(1, 0, 1, -44)
editorBox.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
editorBox.TextColor3 = C_WHITE
editorBox.PlaceholderText = "-- Type or paste Luau code here..."
editorBox.PlaceholderColor3 = Color3.fromRGB(110, 110, 120)
editorBox.Font = Enum.Font.Code
editorBox.TextSize = 12
editorBox.TextXAlignment = Enum.TextXAlignment.Left
editorBox.TextYAlignment = Enum.TextYAlignment.Top
editorBox.ClearTextOnFocus = false
editorBox.MultiLine = true
editorBox.Text = ""
editorBox.Parent = pageExecutor

local edCorner = Instance.new("UICorner")
edCorner.CornerRadius = UDim.new(0, 10)
edCorner.Parent = editorBox

local edPad = Instance.new("UIPadding")
edPad.PaddingLeft = UDim.new(0, 10)
edPad.PaddingTop = UDim.new(0, 10)
edPad.PaddingRight = UDim.new(0, 10)
edPad.PaddingBottom = UDim.new(0, 10)
edPad.Parent = editorBox

local edStroke = Instance.new("UIStroke")
edStroke.Color = C_BORDER
edStroke.Thickness = 1
edStroke.Parent = editorBox

local btnRow = Instance.new("Frame")
btnRow.Size = UDim2.new(1, 0, 0, 36)
btnRow.Position = UDim2.new(0, 0, 1, -36)
btnRow.BackgroundTransparency = 1
btnRow.Parent = pageExecutor

local btnRowLayout = Instance.new("UIListLayout")
btnRowLayout.FillDirection = Enum.FillDirection.Horizontal
btnRowLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
btnRowLayout.Padding = UDim.new(0, 8)
btnRowLayout.Parent = btnRow

local function makeBtn(text, bgCol, textCol)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 95, 1, 0)
    b.BackgroundColor3 = bgCol
    b.TextColor3 = textCol
    b.Font = Enum.Font.GothamBold
    b.TextSize = 11
    b.Text = text
    b.AutoButtonColor = false
    b.Parent = btnRow

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = b
    return b
end

local btnPaste = makeBtn("PASTE", Color3.fromRGB(24, 24, 30), C_WHITE)
local btnClear = makeBtn("CLEAR", Color3.fromRGB(24, 24, 30), C_WHITE)
local btnExecute = makeBtn("EXECUTE", C_WHITE, Color3.fromRGB(10, 10, 12))

btnClear.MouseButton1Click:Connect(function()
    editorBox.Text = ""
end)

btnPaste.MouseButton1Click:Connect(function()
    pcall(function()
        if getclipboard then
            editorBox.Text = getclipboard()
        end
    end)
end)

btnExecute.MouseButton1Click:Connect(function()
    local src = editorBox.Text
    if src and #src > 0 then
        local fn, err = loadstring(src)
        if fn then
            task.spawn(fn)
        else
            warn("[ORC Runtime] Compile Error: " .. tostring(err))
        end
    end
end)

-- ------------------------------------------------------------------------------
-- 6. TAB 2: SAVED SCRIPTS
-- ------------------------------------------------------------------------------
local pageSaved = Instance.new("ScrollingFrame")
pageSaved.Name = "Page_Saved"
pageSaved.Size = UDim2.new(1, 0, 1, 0)
pageSaved.BackgroundTransparency = 1
pageSaved.BorderSizePixel = 0
pageSaved.ScrollBarThickness = 3
pageSaved.ScrollBarImageColor3 = C_WHITE
pageSaved.Visible = false
pageSaved.Parent = viewport
pages["Saved"] = pageSaved

local savedLayout = Instance.new("UIListLayout")
savedLayout.Padding = UDim.new(0, 8)
savedLayout.Parent = pageSaved

local defaultSaved = {
    { title = "Universal ESP & Tracers", code = "loadstring(game:HttpGet('https://raw.githubusercontent.com/v-zxn/Exorc/refs/heads/main/fats.luau', true))()" },
    { title = "Hyper Evade Suite", code = "loadstring(game:HttpGet('https://raw.githubusercontent.com/MITTO-m4x/Hyper_M4X_EVA/refs/heads/main/Hyper_EVADE.lua', true))()" },
    { title = "Blade Ball Ultra Parry", code = "loadstring(game:HttpGet('https://raw.githubusercontent.com/v-zxn/Exorc/refs/heads/main/bladeball.luau', true))()" }
}

for _, item in ipairs(defaultSaved) do
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -6, 0, 46)
    card.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    card.Parent = pageSaved

    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(0, 8)
    cCorner.Parent = card

    local cStroke = Instance.new("UIStroke")
    cStroke.Color = C_BORDER
    cStroke.Thickness = 1
    cStroke.Parent = card

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.7, 0, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = item.title
    lbl.TextColor3 = C_WHITE
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = card

    local runBtn = Instance.new("TextButton")
    runBtn.Size = UDim2.new(0, 68, 0, 28)
    runBtn.Position = UDim2.new(1, -78, 0.5, -14)
    runBtn.BackgroundColor3 = C_WHITE
    runBtn.TextColor3 = Color3.fromRGB(10, 10, 12)
    runBtn.Font = Enum.Font.GothamBold
    runBtn.TextSize = 10
    runBtn.Text = "RUN"
    runBtn.Parent = card

    local rbCorner = Instance.new("UICorner")
    rbCorner.CornerRadius = UDim.new(0, 6)
    rbCorner.Parent = runBtn

    runBtn.MouseButton1Click:Connect(function()
        local fn = loadstring(item.code)
        if fn then task.spawn(fn) end
    end)
end

-- ------------------------------------------------------------------------------
-- 7. TAB 3: SEARCH SCRIPTS
-- ------------------------------------------------------------------------------
local pageSearch = Instance.new("Frame")
pageSearch.Name = "Page_Search"
pageSearch.Size = UDim2.new(1, 0, 1, 0)
pageSearch.BackgroundTransparency = 1
pageSearch.Visible = false
pageSearch.Parent = viewport
pages["Search"] = pageSearch

local sInfo = Instance.new("TextLabel")
sInfo.Size = UDim2.new(1, 0, 1, 0)
sInfo.BackgroundTransparency = 1
sInfo.Text = "// CLOUD SCRIPT REPOSITORY //\nSearch interface will fetch from cloud database."
sInfo.TextColor3 = C_MUTED
sInfo.Font = Enum.Font.Code
sInfo.TextSize = 13
sInfo.Parent = pageSearch

-- ------------------------------------------------------------------------------
-- 8. TAB 4: DUAL CONSOLE (LEFT: ORC EXECUTOR, RIGHT: ROBLOX NATIVE)
-- Full Color Support: Red (Error), Yellow (Warning), Blue (Info), White (Normal)
-- ------------------------------------------------------------------------------
local pageConsole = Instance.new("Frame")
pageConsole.Name = "Page_Console"
pageConsole.Size = UDim2.new(1, 0, 1, 0)
pageConsole.BackgroundTransparency = 1
pageConsole.Visible = false
pageConsole.Parent = viewport
pages["Console"] = pageConsole

local split = Instance.new("UIListLayout")
split.FillDirection = Enum.FillDirection.Horizontal
split.Padding = UDim.new(0, 10)
split.Parent = pageConsole

local function makeConsolePane(title)
    local pane = Instance.new("Frame")
    pane.Size = UDim2.new(0.5, -5, 1, 0)
    pane.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
    pane.Parent = pageConsole

    local pCorner = Instance.new("UICorner")
    pCorner.CornerRadius = UDim.new(0, 10)
    pCorner.Parent = pane

    local pStroke = Instance.new("UIStroke")
    pStroke.Color = C_BORDER
    pStroke.Thickness = 1
    pStroke.Parent = pane

    local pHeader = Instance.new("TextLabel")
    pHeader.Size = UDim2.new(1, -16, 0, 26)
    pHeader.Position = UDim2.new(0, 10, 0, 2)
    pHeader.BackgroundTransparency = 1
    pHeader.Text = title
    pHeader.TextColor3 = C_MUTED
    pHeader.Font = Enum.Font.Code
    pHeader.TextSize = 10
    pHeader.TextXAlignment = Enum.TextXAlignment.Left
    pHeader.Parent = pane

    local pScroll = Instance.new("ScrollingFrame")
    pScroll.Size = UDim2.new(1, -16, 1, -34)
    pScroll.Position = UDim2.new(0, 8, 0, 28)
    pScroll.BackgroundTransparency = 1
    pScroll.BorderSizePixel = 0
    pScroll.ScrollBarThickness = 2
    pScroll.ScrollBarImageColor3 = C_WHITE
    pScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    pScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    pScroll.Parent = pane

    local pList = Instance.new("UIListLayout")
    pList.Padding = UDim.new(0, 3)
    pList.SortOrder = Enum.SortOrder.LayoutOrder
    pList.Parent = pScroll

    return pScroll
end

local orcPane = makeConsolePane("// [LEFT] ORC EXECUTOR LOG")
local rbxPane = makeConsolePane("// [RIGHT] ROBLOX CONSOLE")

-- Helper to add structured log entry with precise coloring
local function addLogMessage(scrollFrame, text, col, tag)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 16)
    row.BackgroundTransparency = 1
    row.Parent = scrollFrame

    local tagLabel = Instance.new("TextLabel")
    tagLabel.Size = UDim2.new(0, 48, 1, 0)
    tagLabel.BackgroundTransparency = 1
    tagLabel.Text = tag or "[LOG]"
    tagLabel.TextColor3 = col
    tagLabel.Font = Enum.Font.Code
    tagLabel.TextSize = 9
    tagLabel.TextXAlignment = Enum.TextXAlignment.Left
    tagLabel.Parent = row

    local msgLabel = Instance.new("TextLabel")
    msgLabel.Size = UDim2.new(1, -52, 1, 0)
    msgLabel.Position = UDim2.new(0, 52, 0, 0)
    msgLabel.BackgroundTransparency = 1
    msgLabel.Text = tostring(text)
    msgLabel.TextColor3 = col
    msgLabel.Font = Enum.Font.Code
    msgLabel.TextSize = 9
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.TextTruncate = Enum.TextTruncate.AtEnd
    msgLabel.Parent = row

    scrollFrame.CanvasPosition = Vector2.new(0, 99999)
end

-- Hook LogService: Real-Time Full Roblox Engine Message Extraction
LogService.MessageOut:Connect(function(message, messageType)
    local targetColor = C_WHITE
    local targetTag = "[INFO]"

    if messageType == Enum.MessageType.MessageError then
        targetColor = Color3.fromRGB(255, 75, 75) -- RED
        targetTag = "[ERROR]"
    elseif messageType == Enum.MessageType.MessageWarning then
        targetColor = Color3.fromRGB(255, 205, 60) -- YELLOW
        targetTag = "[WARN]"
    elseif messageType == Enum.MessageType.MessageInfo then
        targetColor = Color3.fromRGB(75, 175, 255) -- BLUE
        targetTag = "[INFO]"
    else
        targetColor = Color3.fromRGB(210, 210, 215) -- NORMAL
        targetTag = "[OUTPUT]"
    end

    addLogMessage(rbxPane, message, targetColor, targetTag)
end)

-- Seed Existing Output History (So it never shows empty!)
pcall(function()
    local history = LogService:GetLogHistory()
    for _, item in ipairs(history) do
        local col = C_WHITE
        local tag = "[INFO]"
        if item.messageType == Enum.MessageType.MessageError then
            col = Color3.fromRGB(255, 75, 75)
            tag = "[ERROR]"
        elseif item.messageType == Enum.MessageType.MessageWarning then
            col = Color3.fromRGB(255, 205, 60)
            tag = "[WARN]"
        elseif item.messageType == Enum.MessageType.MessageInfo then
            col = Color3.fromRGB(75, 175, 255)
            tag = "[INFO]"
        end
        addLogMessage(rbxPane, item.message, col, tag)
    end
end)

-- Initial ORC System Logging
addLogMessage(orcPane, "ORC Kernel attached.", Color3.fromRGB(75, 255, 120), "[SYSTEM]")
addLogMessage(orcPane, "Sandbox Path: /sdcard/ORC/workspace", Color3.fromRGB(75, 175, 255), "[SANDBOX]")
addLogMessage(orcPane, "Execution Engine Ready.", Color3.fromRGB(210, 210, 215), "[READY]")

-- ------------------------------------------------------------------------------
-- 9. TAB 5: SETTINGS
-- ------------------------------------------------------------------------------
local pageSettings = Instance.new("Frame")
pageSettings.Name = "Page_Settings"
pageSettings.Size = UDim2.new(1, 0, 1, 0)
pageSettings.BackgroundTransparency = 1
pageSettings.Visible = false
pageSettings.Parent = viewport
pages["Settings"] = pageSettings

local setInfo = Instance.new("TextLabel")
setInfo.Size = UDim2.new(1, 0, 1, 0)
setInfo.BackgroundTransparency = 1
setInfo.Text = "ORC MOBILE ENGINE // CONFIGURATION\nBuild Profile: arm64-v8a Standalone\nHardware Canvas Rendering: Active"
setInfo.TextColor3 = C_MUTED
setInfo.Font = Enum.Font.Code
setInfo.TextSize = 12
setInfo.Parent = pageSettings

-- ------------------------------------------------------------------------------
-- 10. TAB NAVIGATION CONTROLLER
-- ------------------------------------------------------------------------------
local function switchTab(tabName)
    activeTab = tabName
    titleLabel.Text = "ORC STUDIO // " .. string.upper(tabName)

    for name, page in pairs(pages) do
        page.Visible = (name == tabName)
    end

    for name, btn in pairs(buttons) do
        if name ~= "Close" then
            if name == tabName then
                btn.BackgroundColor3 = C_WHITE
                btn.TextColor3 = Color3.fromRGB(12, 12, 14)
            else
                btn.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
                btn.TextColor3 = C_MUTED
            end
        end
    end
end

btnExecutor.MouseButton1Click:Connect(function() switchTab("Executor") end)
btnSaved.MouseButton1Click:Connect(function() switchTab("Saved") end)
btnSearch.MouseButton1Click:Connect(function() switchTab("Search") end)
btnConsole.MouseButton1Click:Connect(function() switchTab("Console") end)
btnSettings.MouseButton1Click:Connect(function() switchTab("Settings") end)

-- Initial Active Tab
switchTab("Executor")

-- ------------------------------------------------------------------------------
-- 11. MINIMIZE & RESTORE CONTROLLER (Delta Logic)
-- ------------------------------------------------------------------------------
btnClose.MouseButton1Click:Connect(function()
    mainWindow.Visible = false
    rightDock.Visible = false
    floatingBubble.Visible = true
end)

floatingBubble.MouseButton1Click:Connect(function()
    floatingBubble.Visible = false
    rightDock.Visible = true
    mainWindow.Visible = true
end)

print("[ORC] Modern Delta-Architecture UI Initialized.")
