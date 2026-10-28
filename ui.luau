-- ==============================================================================
-- ORC Mobile Dynamic Multi-Panel In-Game Architecture (Delta-Style UI)
-- Pure Monochrome (#000000 / #FFFFFF) - Mobile Responsive - Touch Optimized
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

-- Remove any prior instance
local existingUI = targetParent:FindFirstChild("ORC_DELTA_FRAMEWORK")
if existingUI then existingUI:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ORC_DELTA_FRAMEWORK"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 999999
screenGui.Parent = targetParent

-- Colors
local C_BLACK = Color3.fromRGB(10, 10, 12)
local C_PANEL = Color3.fromRGB(16, 16, 20)
local C_BORDER = Color3.fromRGB(45, 45, 52)
local C_WHITE = Color3.fromRGB(255, 255, 255)
local C_MUTED = Color3.fromRGB(160, 160, 170)
local C_DARK_ACCENT = Color3.fromRGB(26, 26, 32)

-- ------------------------------------------------------------------------------
-- 1. FLOATING BUBBLE (When minimized)
-- ------------------------------------------------------------------------------
local floatingBubble = Instance.new("ImageButton")
floatingBubble.Name = "FloatingBubble"
floatingBubble.Size = UDim2.new(0, 48, 0, 48)
floatingBubble.Position = UDim2.new(0, 16, 0.45, 0)
floatingBubble.BackgroundColor3 = C_BLACK
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
bubbleStroke.Thickness = 1.8
bubbleStroke.Parent = floatingBubble

local bubbleIcon = Instance.new("TextLabel")
bubbleIcon.Size = UDim2.new(1, 0, 1, 0)
bubbleIcon.BackgroundTransparency = 1
bubbleIcon.Text = "O"
bubbleIcon.TextColor3 = C_WHITE
bubbleIcon.Font = Enum.Font.GothamBold
bubbleIcon.TextSize = 22
bubbleIcon.Parent = floatingBubble

-- ------------------------------------------------------------------------------
-- 2. MAIN CONTAINER & SIDEBAR (Delta Style)
-- ------------------------------------------------------------------------------
local mainContainer = Instance.new("Frame")
mainContainer.Name = "MainContainer"
mainContainer.Size = UDim2.new(0.85, 0, 0.78, 0)
mainContainer.Position = UDim2.new(0.075, 0, 0.11, 0)
mainContainer.BackgroundTransparency = 1
mainContainer.Parent = screenGui

-- Left Icon Sidebar (Floating Bar with 6 Action Buttons)
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 52, 1, 0)
sidebar.Position = UDim2.new(0, 0, 0, 0)
sidebar.BackgroundColor3 = C_BLACK
sidebar.BorderSizePixel = 0
sidebar.Parent = mainContainer

local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, 14)
sidebarCorner.Parent = sidebar

local sidebarStroke = Instance.new("UIStroke")
sidebarStroke.Color = C_BORDER
sidebarStroke.Thickness = 1.2
sidebarStroke.Parent = sidebar

local sidebarLayout = Instance.new("UIListLayout")
sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
sidebarLayout.Padding = UDim.new(0, 10)
sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
sidebarLayout.VerticalAlignment = Enum.VerticalAlignment.Center
sidebarLayout.Parent = sidebar

local sidebarPadding = Instance.new("UIPadding")
sidebarPadding.PaddingTop = UDim.new(0, 12)
sidebarPadding.PaddingBottom = UDim.new(0, 12)
sidebarPadding.Parent = sidebar

-- Content Flyout Window
local contentWindow = Instance.new("Frame")
contentWindow.Name = "ContentWindow"
contentWindow.Size = UDim2.new(1, -64, 1, 0)
contentWindow.Position = UDim2.new(0, 64, 0, 0)
contentWindow.BackgroundColor3 = C_PANEL
contentWindow.BorderSizePixel = 0
contentWindow.Parent = mainContainer

local windowCorner = Instance.new("UICorner")
windowCorner.CornerRadius = UDim.new(0, 14)
windowCorner.Parent = contentWindow

local windowStroke = Instance.new("UIStroke")
windowStroke.Color = C_BORDER
windowStroke.Thickness = 1.2
windowStroke.Parent = contentWindow

-- Header inside Content Window
local windowHeader = Instance.new("Frame")
windowHeader.Name = "WindowHeader"
windowHeader.Size = UDim2.new(1, 0, 0, 42)
windowHeader.BackgroundTransparency = 1
windowHeader.Parent = contentWindow

local headerTitle = Instance.new("TextLabel")
headerTitle.Name = "HeaderTitle"
headerTitle.Size = UDim2.new(1, -30, 1, 0)
headerTitle.Position = UDim2.new(0, 20, 0, 0)
headerTitle.BackgroundTransparency = 1
headerTitle.Text = "ORC // TERMINAL"
headerTitle.TextColor3 = C_WHITE
headerTitle.Font = Enum.Font.GothamBold
headerTitle.TextSize = 14
headerTitle.TextXAlignment = Enum.TextXAlignment.Left
headerTitle.Parent = windowHeader

local headerSep = Instance.new("Frame")
headerSep.Size = UDim2.new(1, -40, 0, 1)
headerSep.Position = UDim2.new(0, 20, 1, -1)
headerSep.BackgroundColor3 = C_BORDER
headerSep.BorderSizePixel = 0
headerSep.Parent = windowHeader

-- Viewport Body
local viewportBody = Instance.new("Frame")
viewportBody.Name = "ViewportBody"
viewportBody.Size = UDim2.new(1, -40, 1, -54)
viewportBody.Position = UDim2.new(0, 20, 0, 48)
viewportBody.BackgroundTransparency = 1
viewportBody.Parent = contentWindow

-- ------------------------------------------------------------------------------
-- 3. SIDEBAR BUTTON CREATION
-- ------------------------------------------------------------------------------
local activeTab = nil
local tabButtons = {}
local tabPages = {}

local function createSidebarButton(name, iconText, layoutOrder, isExit)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, 40, 0, 40)
    btn.BackgroundColor3 = isExit and C_BLACK or C_DARK_ACCENT
    btn.AutoButtonColor = false
    btn.LayoutOrder = layoutOrder
    btn.Text = iconText
    btn.TextColor3 = isExit and Color3.fromRGB(255, 90, 90) or C_MUTED
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.Parent = sidebar

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = C_BORDER
    btnStroke.Thickness = 1
    btnStroke.Parent = btn

    tabButtons[name] = btn
    return btn
end

-- 1: Terminal / Code Executor
local btnTerminal = createSidebarButton("Terminal", ">_", 1)
-- 2: Saved Scripts
local btnScripts = createSidebarButton("Scripts", "★", 2)
-- 3: Search Database
local btnSearch = createSidebarButton("Search", "🔍", 3)
-- 4: Dual Console (ORC Left, Roblox Right)
local btnConsole = createSidebarButton("Console", "≡", 4)
-- 5: Settings
local btnSettings = createSidebarButton("Settings", "⚙", 5)
-- 6: Exit / Minimize (At the very bottom)
local btnMinimize = createSidebarButton("Minimize", "✕", 6, true)

-- ------------------------------------------------------------------------------
-- 4. PAGE 1: TERMINAL (CODE EXECUTOR & SCRIPT INPUT)
-- ------------------------------------------------------------------------------
local pageTerminal = Instance.new("Frame")
pageTerminal.Name = "Page_Terminal"
pageTerminal.Size = UDim2.new(1, 0, 1, 0)
pageTerminal.BackgroundTransparency = 1
pageTerminal.Visible = false
pageTerminal.Parent = viewportBody
tabPages["Terminal"] = pageTerminal

local editorBox = Instance.new("TextBox")
editorBox.Name = "CodeEditor"
editorBox.Size = UDim2.new(1, 0, 1, -48)
editorBox.BackgroundColor3 = C_BLACK
editorBox.TextColor3 = C_WHITE
editorBox.PlaceholderText = "-- Enter Luau script here or load from repository..."
editorBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 110)
editorBox.Font = Enum.Font.Code
editorBox.TextSize = 13
editorBox.TextXAlignment = Enum.TextXAlignment.Left
editorBox.TextYAlignment = Enum.TextYAlignment.Top
editorBox.ClearTextOnFocus = false
editorBox.MultiLine = true
editorBox.Text = ""
editorBox.Parent = pageTerminal

local edCorner = Instance.new("UICorner")
edCorner.CornerRadius = UDim.new(0, 10)
edCorner.Parent = editorBox

local edPad = Instance.new("UIPadding")
edPad.PaddingLeft = UDim.new(0, 12)
edPad.PaddingTop = UDim.new(0, 12)
edPad.PaddingRight = UDim.new(0, 12)
edPad.PaddingBottom = UDim.new(0, 12)
edPad.Parent = editorBox

local edStroke = Instance.new("UIStroke")
edStroke.Color = C_BORDER
edStroke.Thickness = 1
edStroke.Parent = editorBox

local actionsRow = Instance.new("Frame")
actionsRow.Size = UDim2.new(1, 0, 0, 40)
actionsRow.Position = UDim2.new(0, 0, 1, -40)
actionsRow.BackgroundTransparency = 1
actionsRow.Parent = pageTerminal

local actionsLayout = Instance.new("UIListLayout")
actionsLayout.FillDirection = Enum.FillDirection.Horizontal
actionsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
actionsLayout.Padding = UDim.new(0, 10)
actionsLayout.Parent = actionsRow

local function createTerminalButton(text, bgCol, textCol)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 100, 1, 0)
    b.BackgroundColor3 = bgCol
    b.TextColor3 = textCol
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    b.Text = text
    b.AutoButtonColor = false
    b.Parent = actionsRow

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = b
    return b
end

local btnClear = createTerminalButton("CLEAR", C_DARK_ACCENT, C_WHITE)
local btnExecute = createTerminalButton("EXECUTE", C_WHITE, C_BLACK)

btnClear.MouseButton1Click:Connect(function()
    editorBox.Text = ""
end)

btnExecute.MouseButton1Click:Connect(function()
    local src = editorBox.Text
    if src and #src > 0 then
        local fn, err = loadstring(src)
        if fn then
            task.spawn(fn)
        else
            warn("[ORC Runtime] Compile Error: ", tostring(err))
        end
    end
end)

-- ------------------------------------------------------------------------------
-- 5. PAGE 2: SAVED SCRIPTS
-- ------------------------------------------------------------------------------
local pageScripts = Instance.new("ScrollingFrame")
pageScripts.Name = "Page_Scripts"
pageScripts.Size = UDim2.new(1, 0, 1, 0)
pageScripts.BackgroundTransparency = 1
pageScripts.BorderSizePixel = 0
pageScripts.ScrollBarThickness = 4
pageScripts.ScrollBarImageColor3 = C_WHITE
pageScripts.Visible = false
pageScripts.Parent = viewportBody
tabPages["Scripts"] = pageScripts

local scriptsLayout = Instance.new("UIListLayout")
scriptsLayout.Padding = UDim.new(0, 10)
scriptsLayout.SortOrder = Enum.SortOrder.LayoutOrder
scriptsLayout.Parent = pageScripts

local sampleScripts = {
    { title = "Universal ESP & Visuals", code = "loadstring(game:HttpGet('https://raw.githubusercontent.com/v-zxn/Exorc/refs/heads/main/fats.luau', true))()" },
    { title = "Hyper Evade Suite", code = "loadstring(game:HttpGet('https://raw.githubusercontent.com/MITTO-m4x/Hyper_M4X_EVA/refs/heads/main/Hyper_EVADE.lua', true))()" },
    { title = "Blade Ball Auto-Parry", code = "loadstring(game:HttpGet('https://raw.githubusercontent.com/v-zxn/Exorc/refs/heads/main/bladeball.luau', true))()" }
}

for i, scriptItem in ipairs(sampleScripts) do
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 54)
    card.BackgroundColor3 = C_BLACK
    card.Parent = pageScripts

    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(0, 10)
    cCorner.Parent = card

    local cStroke = Instance.new("UIStroke")
    cStroke.Color = C_BORDER
    cStroke.Thickness = 1
    cStroke.Parent = card

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.65, 0, 1, 0)
    lbl.Position = UDim2.new(0, 16, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = scriptItem.title
    lbl.TextColor3 = C_WHITE
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = card

    local loadBtn = Instance.new("TextButton")
    loadBtn.Size = UDim2.new(0, 80, 0, 32)
    loadBtn.Position = UDim2.new(1, -96, 0.5, -16)
    loadBtn.BackgroundColor3 = C_WHITE
    loadBtn.TextColor3 = C_BLACK
    loadBtn.Font = Enum.Font.GothamBold
    loadBtn.TextSize = 11
    loadBtn.Text = "RUN"
    loadBtn.Parent = card

    local lbCorner = Instance.new("UICorner")
    lbCorner.CornerRadius = UDim.new(0, 8)
    lbCorner.Parent = loadBtn

    loadBtn.MouseButton1Click:Connect(function()
        local fn = loadstring(scriptItem.code)
        if fn then task.spawn(fn) end
    end)
end

-- ------------------------------------------------------------------------------
-- 6. PAGE 3: SCRIPT DATABASE SEARCH (Placeholder for Cloud API)
-- ------------------------------------------------------------------------------
local pageSearch = Instance.new("Frame")
pageSearch.Name = "Page_Search"
pageSearch.Size = UDim2.new(1, 0, 1, 0)
pageSearch.BackgroundTransparency = 1
pageSearch.Visible = false
pageSearch.Parent = viewportBody
tabPages["Search"] = pageSearch

local searchInfo = Instance.new("TextLabel")
searchInfo.Size = UDim2.new(1, 0, 1, 0)
searchInfo.BackgroundTransparency = 1
searchInfo.Text = "// CLOUD SCRIPT DATABASE //\nIndex search engine will connect in future update."
searchInfo.TextColor3 = C_MUTED
searchInfo.Font = Enum.Font.Code
searchInfo.TextSize = 14
searchInfo.Parent = pageSearch

-- ------------------------------------------------------------------------------
-- 7. PAGE 4: DUAL CONSOLE (Left: ORC Logger, Right: Roblox Native Output)
-- ------------------------------------------------------------------------------
local pageConsole = Instance.new("Frame")
pageConsole.Name = "Page_Console"
pageConsole.Size = UDim2.new(1, 0, 1, 0)
pageConsole.BackgroundTransparency = 1
pageConsole.Visible = false
pageConsole.Parent = viewportBody
tabPages["Console"] = pageConsole

local consoleSplitLayout = Instance.new("UIListLayout")
consoleSplitLayout.FillDirection = Enum.FillDirection.Horizontal
consoleSplitLayout.Padding = UDim.new(0, 12)
consoleSplitLayout.Parent = pageConsole

local function createConsolePane(title, isRight)
    local pane = Instance.new("Frame")
    pane.Size = UDim2.new(0.5, -6, 1, 0)
    pane.BackgroundColor3 = C_BLACK
    pane.Parent = pageConsole

    local pCorner = Instance.new("UICorner")
    pCorner.CornerRadius = UDim.new(0, 10)
    pCorner.Parent = pane

    local pStroke = Instance.new("UIStroke")
    pStroke.Color = C_BORDER
    pStroke.Thickness = 1
    pStroke.Parent = pane

    local pHeader = Instance.new("TextLabel")
    pHeader.Size = UDim2.new(1, -20, 0, 32)
    pHeader.Position = UDim2.new(0, 12, 0, 0)
    pHeader.BackgroundTransparency = 1
    pHeader.Text = title
    pHeader.TextColor3 = C_MUTED
    pHeader.Font = Enum.Font.Code
    pHeader.TextSize = 11
    pHeader.TextXAlignment = Enum.TextXAlignment.Left
    pHeader.Parent = pane

    local pScroll = Instance.new("ScrollingFrame")
    pScroll.Size = UDim2.new(1, -24, 1, -40)
    pScroll.Position = UDim2.new(0, 12, 0, 34)
    pScroll.BackgroundTransparency = 1
    pScroll.BorderSizePixel = 0
    pScroll.ScrollBarThickness = 3
    pScroll.ScrollBarImageColor3 = C_WHITE
    pScroll.Parent = pane

    local pList = Instance.new("UIListLayout")
    pList.Padding = UDim.new(0, 4)
    pList.SortOrder = Enum.SortOrder.LayoutOrder
    pList.Parent = pScroll

    return pScroll
end

local orcLogScroll = createConsolePane("// [LEFT] ORC EXECUTOR LOG", false)
local rbxLogScroll = createConsolePane("// [RIGHT] ROBLOX CONSOLE", true)

-- Hook LogService for Roblox console output
LogService.MessageOut:Connect(function(message, messageType)
    local msgLabel = Instance.new("TextLabel")
    msgLabel.Size = UDim2.new(1, 0, 0, 18)
    msgLabel.BackgroundTransparency = 1
    msgLabel.Text = message
    msgLabel.Font = Enum.Font.Code
    msgLabel.TextSize = 10
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left

    if messageType == Enum.MessageType.MessageError then
        msgLabel.TextColor3 = Color3.fromRGB(255, 90, 90)
    elseif messageType == Enum.MessageType.MessageWarning then
        msgLabel.TextColor3 = Color3.fromRGB(240, 200, 80)
    else
        msgLabel.TextColor3 = C_MUTED
    end
    msgLabel.Parent = rbxLogScroll
    rbxLogScroll.CanvasPosition = Vector2.new(0, 99999)
end)

-- Sample initial ORC system log
local function addOrcLog(text, color)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 0, 18)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = color or C_WHITE
    l.Font = Enum.Font.Code
    l.TextSize = 10
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = orcLogScroll
end

addOrcLog("[ORC] Engine Hooked successfully.", Color3.fromRGB(120, 255, 140))
addOrcLog("[ORC] Standalone Workspace sandboxed to /sdcard/ORC/workspace", C_MUTED)
addOrcLog("[ORC] Memory Protection Layer active.", C_MUTED)

-- ------------------------------------------------------------------------------
-- 8. PAGE 5: SETTINGS
-- ------------------------------------------------------------------------------
local pageSettings = Instance.new("Frame")
pageSettings.Name = "Page_Settings"
pageSettings.Size = UDim2.new(1, 0, 1, 0)
pageSettings.BackgroundTransparency = 1
pageSettings.Visible = false
pageSettings.Parent = viewportBody
tabPages["Settings"] = pageSettings

local settingsLabel = Instance.new("TextLabel")
settingsLabel.Size = UDim2.new(1, 0, 1, 0)
settingsLabel.BackgroundTransparency = 1
settingsLabel.Text = "ORC STUDIO // HARDWARE ACCELERATED EXECUTION\nMonochrome UI v1.0.0\nProtected Sandbox Mode: Enabled"
settingsLabel.TextColor3 = C_MUTED
settingsLabel.Font = Enum.Font.Code
settingsLabel.TextSize = 12
settingsLabel.Parent = pageSettings

-- ------------------------------------------------------------------------------
-- 9. TAB SWITCHING LOGIC & ANIMATIONS
-- ------------------------------------------------------------------------------
local function switchTab(tabName)
    activeTab = tabName
    headerTitle.Text = "ORC // " .. string.upper(tabName)

    for name, page in pairs(tabPages) do
        page.Visible = (name == tabName)
    end

    for name, btn in pairs(tabButtons) do
        if name ~= "Minimize" then
            if name == tabName then
                btn.BackgroundColor3 = C_WHITE
                btn.TextColor3 = C_BLACK
            else
                btn.BackgroundColor3 = C_DARK_ACCENT
                btn.TextColor3 = C_MUTED
            end
        end
    end
end

btnTerminal.MouseButton1Click:Connect(function() switchTab("Terminal") end)
btnScripts.MouseButton1Click:Connect(function() switchTab("Scripts") end)
btnSearch.MouseButton1Click:Connect(function() switchTab("Search") end)
btnConsole.MouseButton1Click:Connect(function() switchTab("Console") end)
btnSettings.MouseButton1Click:Connect(function() switchTab("Settings") end)

-- Default initial tab
switchTab("Terminal")

-- ------------------------------------------------------------------------------
-- 10. MINIMIZE & RESTORE CONTROLLER
-- ------------------------------------------------------------------------------
btnMinimize.MouseButton1Click:Connect(function()
    mainContainer.Visible = false
    floatingBubble.Visible = true
end)

floatingBubble.MouseButton1Click:Connect(function()
    floatingBubble.Visible = false
    mainContainer.Visible = true
end)

print("[ORC] Delta-Style Monochrome In-Game UI loaded successfully.")
