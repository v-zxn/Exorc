-- ==============================================================================
-- ORC TITAN FRAMEWORK v8.1 (PURE MINIMAL MONOCHROME)
-- #000000 / #FFFFFF • PRECISION TYPOGRAPHY • ZERO CLUTTER
-- ==============================================================================

-- ==========================================
-- [1] ASSET & ICON CONFIGURATION (TREE HUB CLI REGISTRY)
-- ==========================================
local ASSETS = {
    -- Sidebar dock icons (Exact Tree Hub CLI assets)
    ICON_EXECUTOR = "rbxassetid://137645011895167", -- code-2-bold
    ICON_SAVED    = "rbxassetid://76034753816998",  -- folder-2-bold
    ICON_SEARCH   = "rbxassetid://104777342222451", -- card-search-bold
    ICON_CONSOLE  = "rbxassetid://70615504226457",  -- chat-square-code-bold
    ICON_SETTINGS = "rbxassetid://79820790543002",  -- colour-tuneing-bold
    ICON_CLOSE    = "rbxassetid://117747448917698", -- close-square-bold
    
    -- Fallback image for game thumbnails in Search
    FALLBACK_THUMB = "rbxassetid://104777342222451"
}

-- ==========================================
-- [2] SERVICES & INITIALIZATION
-- ==========================================
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LogService = game:GetService("LogService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local targetParent = CoreGui
pcall(function()
    if not pcall(function() return CoreGui.Name end) then
        targetParent = player:WaitForChild("PlayerGui", 5)
    end
end)

local existingUI = targetParent:FindFirstChild("ORC_TITAN_DELTA_FRAMEWORK")
if existingUI then existingUI:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ORC_TITAN_DELTA_FRAMEWORK"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 999999
screenGui.IgnoreGuiInset = true
screenGui.Parent = targetParent

-- ==========================================
-- [3] PURE MONOCHROME PALETTE & FONTS
-- ==========================================
local C_BLACK   = Color3.fromRGB(0, 0, 0)
local C_DARK    = Color3.fromRGB(6, 6, 8)
local C_PANEL   = Color3.fromRGB(12, 12, 15)
local C_CARD    = Color3.fromRGB(18, 18, 22)
local C_BORDER  = Color3.fromRGB(34, 34, 42)
local C_WHITE   = Color3.fromRGB(255, 255, 255)
local C_MUTED   = Color3.fromRGB(160, 160, 170)
local C_SUBTLE  = Color3.fromRGB(90, 90, 105)

local FONT_TITLE = Enum.Font.GothamBold
local FONT_TEXT  = Enum.Font.Gotham
local FONT_CODE  = Enum.Font.RobotoMono

-- ==========================================
-- [4] STORAGE & CLIPBOARD
-- ==========================================
local SCRIPTS_DIR = "scripts"
local WORKSPACE_DIR = "workspace"
local AUTOEXEC_DIR = "autoexec"
local SETTINGS_DIR = "settings"
local LOGS_DIR = "logs"
local CLIPBOARD_FILE = "workspace/clipboard.txt"

pcall(function()
    if makefolder then
        makefolder(SCRIPTS_DIR)
        makefolder(WORKSPACE_DIR)
        makefolder(AUTOEXEC_DIR)
        makefolder(SETTINGS_DIR)
        makefolder(LOGS_DIR)
    end
end)

local function readSystemClipboard()
    local text = ""
    pcall(function()
        if getclipboard then text = getclipboard() end
    end)
    if (not text or #text == 0) and isfile and readfile then
        pcall(function()
            if isfile(CLIPBOARD_FILE) then text = readfile(CLIPBOARD_FILE) end
        end)
    end
    return text or ""
end

local function writeSystemClipboard(text)
    pcall(function()
        if setclipboard then setclipboard(text) end
        if writefile then writefile(CLIPBOARD_FILE, text) end
    end)
end

-- ==========================================
-- [5] ROOT CONTAINER & BACKDROP
-- ==========================================
local container = Instance.new("Frame")
container.Name = "Container"
container.Size = UDim2.new(1, 0, 1, 0)
container.BackgroundTransparency = 1
container.Parent = screenGui

local fullBackdrop = Instance.new("TextButton")
fullBackdrop.Name = "FullBackdrop"
fullBackdrop.Size = UDim2.new(1, 0, 1, 0)
fullBackdrop.BackgroundColor3 = C_BLACK
fullBackdrop.BackgroundTransparency = 0.40
fullBackdrop.AutoButtonColor = false
fullBackdrop.Text = ""
fullBackdrop.Active = false
fullBackdrop.BorderSizePixel = 0
fullBackdrop.Parent = container

local backdropGradient = Instance.new("UIGradient")
backdropGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.0, Color3.fromRGB(4, 4, 6)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(8, 8, 12))
})
backdropGradient.Rotation = 45
backdropGradient.Parent = fullBackdrop

-- ==========================================
-- [6] RIGHT DOCK: COMPACT, SPACIOUS & NO CLUTTER
-- ==========================================
local rightDock = Instance.new("Frame")
rightDock.Name = "RightDock"
rightDock.Size = UDim2.new(0, 52, 1, 0)
rightDock.Position = UDim2.new(1, -52, 0, 0)
rightDock.BackgroundColor3 = C_PANEL
rightDock.BorderSizePixel = 0
rightDock.Active = true
rightDock.Parent = container

local dockBorder = Instance.new("Frame")
dockBorder.Size = UDim2.new(0, 1, 1, 0)
dockBorder.BackgroundColor3 = C_BORDER
dockBorder.BorderSizePixel = 0
dockBorder.Parent = rightDock

local dockButtonsContainer = Instance.new("Frame")
dockButtonsContainer.Name = "DockButtons"
dockButtonsContainer.Size = UDim2.new(1, 0, 1, -80)
dockButtonsContainer.Position = UDim2.new(0, 0, 0, 16)
dockButtonsContainer.BackgroundTransparency = 1
dockButtonsContainer.Parent = rightDock

-- Sliding Active Pill
local activePill = Instance.new("Frame")
activePill.Name = "ActivePill"
activePill.Size = UDim2.new(0, 3, 0, 32)
activePill.Position = UDim2.new(1, -3, 0, 4)
activePill.BackgroundColor3 = C_WHITE
activePill.BorderSizePixel = 0
activePill.Parent = dockButtonsContainer

local pillCorner = Instance.new("UICorner")
pillCorner.CornerRadius = UDim.new(0, 3)
pillCorner.Parent = activePill

local dockButtons = {}

local function makeDockButton(name, iconAsset, yOffset)
    local btn = Instance.new("ImageButton")
    btn.Name = "Btn_" .. name
    btn.Size = UDim2.new(0, 38, 0, 38)
    btn.Position = UDim2.new(0.5, -19, 0, yOffset)
    btn.BackgroundColor3 = C_CARD
    btn.Image = iconAsset
    btn.ImageColor3 = C_MUTED
    btn.ScaleType = Enum.ScaleType.Fit
    btn.AutoButtonColor = false
    btn.Parent = dockButtonsContainer

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = C_BORDER
    stroke.Thickness = 1
    stroke.Parent = btn

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 9)
    pad.PaddingBottom = UDim.new(0, 9)
    pad.PaddingLeft = UDim.new(0, 9)
    pad.PaddingRight = UDim.new(0, 9)
    pad.Parent = btn

    dockButtons[name] = btn
    return btn
end

-- 5 Buttons with comfortable vertical spacing (46px interval)
local btnExecutor = makeDockButton("Executor", ASSETS.ICON_EXECUTOR, 4)
local btnSaved    = makeDockButton("Saved", ASSETS.ICON_SAVED, 50)
local btnSearch   = makeDockButton("Search", ASSETS.ICON_SEARCH, 96)
local btnConsole  = makeDockButton("Console", ASSETS.ICON_CONSOLE, 142)
local btnSettings = makeDockButton("Settings", ASSETS.ICON_SETTINGS, 188)

-- Close Button (Well separated at bottom)
local btnClose = Instance.new("ImageButton")
btnClose.Name = "Btn_Close"
btnClose.Size = UDim2.new(0, 38, 0, 38)
btnClose.Position = UDim2.new(0.5, -19, 1, -48)
btnClose.BackgroundColor3 = C_CARD
btnClose.Image = ASSETS.ICON_CLOSE
btnClose.ImageColor3 = C_WHITE
btnClose.ScaleType = Enum.ScaleType.Fit
btnClose.AutoButtonColor = false
btnClose.Parent = rightDock

local bcCorner = Instance.new("UICorner")
bcCorner.CornerRadius = UDim.new(0, 8)
bcCorner.Parent = btnClose

local bcStroke = Instance.new("UIStroke")
bcStroke.Color = C_BORDER
bcStroke.Thickness = 1
bcStroke.Parent = btnClose

local bcPad = Instance.new("UIPadding")
bcPad.PaddingTop = UDim.new(0, 10)
bcPad.PaddingBottom = UDim.new(0, 10)
bcPad.PaddingLeft = UDim.new(0, 10)
bcPad.PaddingRight = UDim.new(0, 10)
bcPad.Parent = btnClose
dockButtons["Close"] = btnClose

-- Floating Restore Bubble
local floatingBubble = Instance.new("TextButton")
floatingBubble.Name = "ORC_FloatingBubble"
floatingBubble.Size = UDim2.new(0, 44, 0, 44)
floatingBubble.Position = UDim2.new(1, -56, 0.45, 0)
floatingBubble.BackgroundColor3 = C_BLACK
floatingBubble.TextColor3 = C_WHITE
floatingBubble.Text = "ORC"
floatingBubble.Font = FONT_TITLE
floatingBubble.TextSize = 13
floatingBubble.Visible = false
floatingBubble.Active = true
floatingBubble.Draggable = true
floatingBubble.Parent = screenGui

local fbCorner = Instance.new("UICorner")
fbCorner.CornerRadius = UDim.new(1, 0)
fbCorner.Parent = floatingBubble

local fbStroke = Instance.new("UIStroke")
fbStroke.Color = C_WHITE
fbStroke.Thickness = 1.4
fbStroke.Parent = floatingBubble

-- ==========================================
-- [7] EXPANDED FLOATING WINDOW (0.80 x 0.90)
-- ==========================================
local floatingWindow = Instance.new("Frame")
floatingWindow.Name = "FloatingWindow"
floatingWindow.Size = UDim2.new(0.80, 0, 0.90, 0)
floatingWindow.Position = UDim2.new(0.065, 0, 0.05, 0)
floatingWindow.BackgroundColor3 = C_PANEL
floatingWindow.BorderSizePixel = 0
floatingWindow.Active = true
floatingWindow.Parent = container

local fwCorner = Instance.new("UICorner")
fwCorner.CornerRadius = UDim.new(0, 10)
fwCorner.Parent = floatingWindow

local fwStroke = Instance.new("UIStroke")
fwStroke.Color = C_BORDER
fwStroke.Thickness = 1.2
fwStroke.Parent = floatingWindow

local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 38)
header.BackgroundColor3 = C_DARK
header.BorderSizePixel = 0
header.Parent = floatingWindow

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 14)
headerCorner.Parent = header

local headerBottomBorder = Instance.new("Frame")
headerBottomBorder.Size = UDim2.new(1, 0, 0, 1)
headerBottomBorder.Position = UDim2.new(0, 0, 1, -1)
headerBottomBorder.BackgroundColor3 = C_BORDER
headerBottomBorder.BorderSizePixel = 0
headerBottomBorder.Parent = header

local headerTitle = Instance.new("TextLabel")
headerTitle.Size = UDim2.new(0.6, 0, 1, 0)
headerTitle.Position = UDim2.new(0, 16, 0, 0)
headerTitle.BackgroundTransparency = 1
headerTitle.Text = "EXECUTOR"
headerTitle.TextColor3 = C_WHITE
headerTitle.Font = FONT_TITLE
headerTitle.TextSize = 13
headerTitle.TextXAlignment = Enum.TextXAlignment.Left
headerTitle.Parent = header

local headerStatus = Instance.new("TextLabel")
headerStatus.Size = UDim2.new(0.4, -16, 1, 0)
headerStatus.Position = UDim2.new(0.6, 0, 0, 0)
headerStatus.BackgroundTransparency = 1
headerStatus.Text = "READY"
headerStatus.TextColor3 = C_SUBTLE
headerStatus.Font = FONT_CODE
headerStatus.TextSize = 10
headerStatus.TextXAlignment = Enum.TextXAlignment.Right
headerStatus.Parent = header

local viewport = Instance.new("Frame")
viewport.Name = "Viewport"
viewport.Size = UDim2.new(1, -24, 1, -54)
viewport.Position = UDim2.new(0, 12, 0, 46)
viewport.BackgroundTransparency = 1
viewport.Parent = floatingWindow

local pages = {}
local switchTab = nil

-- ==========================================
-- [8] TAB 1: ADVANCED TERMINAL EXECUTOR
-- ==========================================
local pageExecutor = Instance.new("Frame")
pageExecutor.Name = "Page_Executor"
pageExecutor.Size = UDim2.new(1, 0, 1, 0)
pageExecutor.BackgroundTransparency = 1
pageExecutor.Parent = viewport
pages["Executor"] = pageExecutor

local editorScroll = Instance.new("ScrollingFrame")
editorScroll.Name = "EditorScroll"
editorScroll.Size = UDim2.new(1, 0, 1, -44)
editorScroll.BackgroundColor3 = C_BLACK
editorScroll.BorderSizePixel = 0
editorScroll.ScrollBarThickness = 4
editorScroll.ScrollBarImageColor3 = C_WHITE
editorScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
editorScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
editorScroll.Parent = pageExecutor

local edCorner = Instance.new("UICorner")
edCorner.CornerRadius = UDim.new(0, 8)
edCorner.Parent = editorScroll

local edStroke = Instance.new("UIStroke")
edStroke.Color = C_BORDER
edStroke.Thickness = 1
edStroke.Parent = editorScroll

local editorBox = Instance.new("TextBox")
editorBox.Name = "CodeEditor"
editorBox.Size = UDim2.new(1, 0, 1, 0)
editorBox.AutomaticSize = Enum.AutomaticSize.Y
editorBox.BackgroundTransparency = 1
editorBox.TextColor3 = C_WHITE
editorBox.PlaceholderText = "-- Type or paste Luau code here..."
editorBox.PlaceholderColor3 = C_SUBTLE
editorBox.Font = FONT_CODE
editorBox.TextSize = 13
editorBox.TextXAlignment = Enum.TextXAlignment.Left
editorBox.TextYAlignment = Enum.TextYAlignment.Top
editorBox.ClearTextOnFocus = false
editorBox.MultiLine = true
editorBox.Text = ""
editorBox.Parent = editorScroll

local edPad = Instance.new("UIPadding")
edPad.PaddingLeft = UDim.new(0, 12)
edPad.PaddingTop = UDim.new(0, 12)
edPad.PaddingRight = UDim.new(0, 12)
edPad.PaddingBottom = UDim.new(0, 12)
edPad.Parent = editorBox

-- Bottom Action Toolbar
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

local function makeActionBtn(text, bgCol, textCol, width)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, width or 80, 1, 0)
    b.BackgroundColor3 = bgCol
    b.TextColor3 = textCol
    b.Font = FONT_TITLE
    b.TextSize = 11
    b.Text = text
    b.AutoButtonColor = false
    b.Parent = btnRow

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = b

    local s = Instance.new("UIStroke")
    s.Color = C_BORDER
    s.Thickness = 1
    s.Parent = b
    return b
end

local btnSaveAs   = makeActionBtn("SAVE", C_CARD, C_WHITE, 70)
local btnSyncClip = makeActionBtn("PASTE", C_CARD, C_WHITE, 70)
local btnCopy     = makeActionBtn("COPY", C_CARD, C_WHITE, 65)
local btnClear    = makeActionBtn("CLEAR", C_CARD, C_WHITE, 65)
local btnExecute  = makeActionBtn("EXECUTE", C_WHITE, C_BLACK, 95)

btnClear.MouseButton1Click:Connect(function()
    editorBox.Text = ""
end)

btnSyncClip.MouseButton1Click:Connect(function()
    local text = readSystemClipboard()
    if text and #text > 0 then
        editorBox.Text = text
        headerStatus.Text = "PASTED " .. tostring(#text) .. " BYTES"
    end
end)

btnCopy.MouseButton1Click:Connect(function()
    if #editorBox.Text > 0 then
        writeSystemClipboard(editorBox.Text)
        headerStatus.Text = "COPIED TO CLIPBOARD"
    end
end)

btnExecute.MouseButton1Click:Connect(function()
    local src = editorBox.Text
    if src and #src > 0 then
        local fn, err = loadstring(src)
        if fn then
            task.spawn(fn)
            headerStatus.Text = "EXECUTED"
        else
            warn("[Compile Error]: " .. tostring(err))
            headerStatus.Text = "COMPILE ERROR"
        end
    end
end)

-- ==========================================
-- [9] TAB 2: SAVED SCRIPTS (WITH TWO-FIELD ADD MODAL)
-- ==========================================
local pageSaved = Instance.new("Frame")
pageSaved.Name = "Page_Saved"
pageSaved.Size = UDim2.new(1, 0, 1, 0)
pageSaved.BackgroundTransparency = 1
pageSaved.Visible = false
pageSaved.Parent = viewport
pages["Saved"] = pageSaved

local savedTopBar = Instance.new("Frame")
savedTopBar.Size = UDim2.new(1, 0, 0, 36)
savedTopBar.BackgroundTransparency = 1
savedTopBar.Parent = pageSaved

local btnOpenAddModal = Instance.new("TextButton")
btnOpenAddModal.Size = UDim2.new(0, 110, 1, 0)
btnOpenAddModal.BackgroundColor3 = C_WHITE
btnOpenAddModal.TextColor3 = C_BLACK
btnOpenAddModal.Font = FONT_TITLE
btnOpenAddModal.TextSize = 11
btnOpenAddModal.Text = "+ ADD SCRIPT"
btnOpenAddModal.Parent = savedTopBar

local boamCorner = Instance.new("UICorner")
boamCorner.CornerRadius = UDim.new(0, 8)
boamCorner.Parent = btnOpenAddModal

local btnRefreshSaved = Instance.new("TextButton")
btnRefreshSaved.Size = UDim2.new(0, 80, 1, 0)
btnRefreshSaved.Position = UDim2.new(0, 118, 0, 0)
btnRefreshSaved.BackgroundColor3 = C_CARD
btnRefreshSaved.TextColor3 = C_WHITE
btnRefreshSaved.Font = FONT_TITLE
btnRefreshSaved.TextSize = 11
btnRefreshSaved.Text = "REFRESH"
btnRefreshSaved.Parent = savedTopBar

local brsCorner = Instance.new("UICorner")
brsCorner.CornerRadius = UDim.new(0, 8)
brsCorner.Parent = btnRefreshSaved

local savedScroll = Instance.new("ScrollingFrame")
savedScroll.Size = UDim2.new(1, 0, 1, -44)
savedScroll.Position = UDim2.new(0, 0, 0, 44)
savedScroll.BackgroundTransparency = 1
savedScroll.BorderSizePixel = 0
savedScroll.ScrollBarThickness = 4
savedScroll.ScrollBarImageColor3 = C_WHITE
savedScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
savedScroll.Parent = pageSaved

local savedLayout = Instance.new("UIListLayout")
savedLayout.Padding = UDim.new(0, 8)
savedLayout.Parent = savedScroll

-- ADD SCRIPT MODAL (Two-Field: Script Name + Script Code)
local addScriptModal = Instance.new("Frame")
addScriptModal.Name = "AddScriptModal"
addScriptModal.Size = UDim2.new(0.85, 0, 0.85, 0)
addScriptModal.Position = UDim2.new(0.075, 0, 0.075, 0)
addScriptModal.BackgroundColor3 = C_DARK
addScriptModal.BorderSizePixel = 0
addScriptModal.Visible = false
addScriptModal.ZIndex = 200
addScriptModal.Parent = floatingWindow

local asmCorner = Instance.new("UICorner")
asmCorner.CornerRadius = UDim.new(0, 12)
asmCorner.Parent = addScriptModal

local asmStroke = Instance.new("UIStroke")
asmStroke.Color = C_WHITE
asmStroke.Thickness = 1.4
asmStroke.Parent = addScriptModal

local asmHeader = Instance.new("TextLabel")
asmHeader.Size = UDim2.new(1, -60, 0, 26)
asmHeader.Position = UDim2.new(0, 14, 0, 10)
asmHeader.BackgroundTransparency = 1
asmHeader.Text = "CREATE NEW SCRIPT"
asmHeader.TextColor3 = C_WHITE
asmHeader.Font = FONT_TITLE
asmHeader.TextSize = 13
asmHeader.TextXAlignment = Enum.TextXAlignment.Left
asmHeader.ZIndex = 201
asmHeader.Parent = addScriptModal

local asmClose = Instance.new("TextButton")
asmClose.Size = UDim2.new(0, 28, 0, 28)
asmClose.Position = UDim2.new(1, -36, 0, 10)
asmClose.BackgroundTransparency = 1
asmClose.Text = "✕"
asmClose.TextColor3 = C_MUTED
asmClose.Font = FONT_TITLE
asmClose.TextSize = 13
asmClose.ZIndex = 202
asmClose.Parent = addScriptModal

-- Field 1: Script Name
local inputScriptName = Instance.new("TextBox")
inputScriptName.Size = UDim2.new(1, -28, 0, 34)
inputScriptName.Position = UDim2.new(0, 14, 0, 44)
inputScriptName.BackgroundColor3 = C_BLACK
inputScriptName.TextColor3 = C_WHITE
inputScriptName.PlaceholderText = "Enter script name (e.g. MySuperFarm)..."
inputScriptName.PlaceholderColor3 = C_SUBTLE
inputScriptName.Font = FONT_CODE
inputScriptName.TextSize = 12
inputScriptName.ClearTextOnFocus = false
inputScriptName.Text = ""
inputScriptName.ZIndex = 201
inputScriptName.Parent = addScriptModal

local isnCorner = Instance.new("UICorner")
isnCorner.CornerRadius = UDim.new(0, 8)
isnCorner.Parent = inputScriptName

local isnPad = Instance.new("UIPadding")
isnPad.PaddingLeft = UDim.new(0, 10)
isnPad.Parent = inputScriptName

local isnStroke = Instance.new("UIStroke")
isnStroke.Color = C_BORDER
isnStroke.Thickness = 1
isnStroke.Parent = inputScriptName

-- Field 2: Script Code
local inputCodeScroll = Instance.new("ScrollingFrame")
inputCodeScroll.Size = UDim2.new(1, -28, 1, -135)
inputCodeScroll.Position = UDim2.new(0, 14, 0, 86)
inputCodeScroll.BackgroundColor3 = C_BLACK
inputCodeScroll.BorderSizePixel = 0
inputCodeScroll.ScrollBarThickness = 4
inputCodeScroll.ScrollBarImageColor3 = C_WHITE
inputCodeScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
inputCodeScroll.ZIndex = 201
inputCodeScroll.Parent = addScriptModal

local icsCorner = Instance.new("UICorner")
icsCorner.CornerRadius = UDim.new(0, 8)
icsCorner.Parent = inputCodeScroll

local icsStroke = Instance.new("UIStroke")
icsStroke.Color = C_BORDER
icsStroke.Thickness = 1
icsStroke.Parent = inputCodeScroll

local inputScriptCode = Instance.new("TextBox")
inputScriptCode.Size = UDim2.new(1, 0, 1, 0)
inputScriptCode.AutomaticSize = Enum.AutomaticSize.Y
inputScriptCode.BackgroundTransparency = 1
inputScriptCode.TextColor3 = C_WHITE
inputScriptCode.PlaceholderText = "-- Paste or write your Luau script here..."
inputScriptCode.PlaceholderColor3 = C_SUBTLE
inputScriptCode.Font = FONT_CODE
inputScriptCode.TextSize = 12
inputScriptCode.TextXAlignment = Enum.TextXAlignment.Left
inputScriptCode.TextYAlignment = Enum.TextYAlignment.Top
inputScriptCode.ClearTextOnFocus = false
inputScriptCode.MultiLine = true
inputScriptCode.Text = ""
inputScriptCode.ZIndex = 202
inputScriptCode.Parent = inputCodeScroll

local iscPad = Instance.new("UIPadding")
iscPad.PaddingLeft = UDim.new(0, 10)
iscPad.PaddingTop = UDim.new(0, 10)
iscPad.PaddingRight = UDim.new(0, 10)
iscPad.PaddingBottom = UDim.new(0, 10)
iscPad.Parent = inputScriptCode

-- Save Button inside Modal
local btnModalSave = Instance.new("TextButton")
btnModalSave.Size = UDim2.new(1, -28, 0, 36)
btnModalSave.Position = UDim2.new(0, 14, 1, -44)
btnModalSave.BackgroundColor3 = C_WHITE
btnModalSave.TextColor3 = C_BLACK
btnModalSave.Font = FONT_TITLE
btnModalSave.TextSize = 12
btnModalSave.Text = "SAVE SCRIPT"
btnModalSave.ZIndex = 203
btnModalSave.Parent = addScriptModal

local bmsCorner = Instance.new("UICorner")
bmsCorner.CornerRadius = UDim.new(0, 8)
bmsCorner.Parent = btnModalSave

asmClose.MouseButton1Click:Connect(function()
    addScriptModal.Visible = false
end)

btnOpenAddModal.MouseButton1Click:Connect(function()
    inputScriptName.Text = ""
    inputScriptCode.Text = editorBox.Text
    addScriptModal.Visible = true
end)

local function refreshSavedList()
    for _, ch in ipairs(savedScroll:GetChildren()) do
        if ch:IsA("Frame") then ch:Destroy() end
    end

    local fileList = {}
    pcall(function()
        if listfiles then
            local raw = listfiles(SCRIPTS_DIR) or {}
            for _, p in ipairs(raw) do
                table.insert(fileList, p)
            end
            -- Also check root or relative paths if listfiles returns workspace-relative
            if #fileList == 0 then
                local rootList = listfiles("") or {}
                for _, p in ipairs(rootList) do
                    if string.find(p, "^scripts/") or string.find(p, "^scripts\\") then
                        table.insert(fileList, p)
                    end
                end
            end
        end
    end)

    if #fileList == 0 then
        local emptyLbl = Instance.new("TextLabel")
        emptyLbl.Size = UDim2.new(1, 0, 0, 60)
        emptyLbl.BackgroundTransparency = 1
        emptyLbl.Text = "No scripts found.\nClick '+ ADD SCRIPT' above to create one."
        emptyLbl.TextColor3 = C_MUTED
        emptyLbl.Font = FONT_CODE
        emptyLbl.TextSize = 11
        emptyLbl.Parent = savedScroll
        return
    end

    for _, rawPath in ipairs(fileList) do
        -- Normalize path separators
        local normPath = string.gsub(rawPath, "\\", "/")
        local fileName = string.gsub(normPath, "^.*/", "")
        -- Ensure relative path format required by sandbox
        local relPath = string.find(normPath, "^" .. SCRIPTS_DIR) and normPath or (SCRIPTS_DIR .. "/" .. fileName)

        if fileName ~= "README.txt" and not string.find(fileName, "^%.") then
            local card = Instance.new("Frame")
            card.Size = UDim2.new(1, -4, 0, 48)
            card.BackgroundColor3 = C_BLACK
            card.Parent = savedScroll

            local cCorner = Instance.new("UICorner")
            cCorner.CornerRadius = UDim.new(0, 8)
            cCorner.Parent = card

            local cStroke = Instance.new("UIStroke")
            cStroke.Color = C_BORDER
            cStroke.Thickness = 1
            cStroke.Parent = card

            local nameLbl = Instance.new("TextLabel")
            nameLbl.Size = UDim2.new(1, -210, 1, 0)
            nameLbl.Position = UDim2.new(0, 12, 0, 0)
            nameLbl.BackgroundTransparency = 1
            nameLbl.Text = fileName
            nameLbl.TextColor3 = C_WHITE
            nameLbl.Font = FONT_TITLE
            nameLbl.TextSize = 12
            nameLbl.TextXAlignment = Enum.TextXAlignment.Left
            nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
            nameLbl.Parent = card

            local loadBtn = Instance.new("TextButton")
            loadBtn.Size = UDim2.new(0, 60, 0, 30)
            loadBtn.Position = UDim2.new(1, -196, 0.5, -15)
            loadBtn.BackgroundColor3 = C_CARD
            loadBtn.TextColor3 = C_WHITE
            loadBtn.Font = FONT_TITLE
            loadBtn.TextSize = 11
            loadBtn.Text = "LOAD"
            loadBtn.Parent = card

            local lbCorner = Instance.new("UICorner")
            lbCorner.CornerRadius = UDim.new(0, 6)
            lbCorner.Parent = loadBtn

            local runBtn = Instance.new("TextButton")
            runBtn.Size = UDim2.new(0, 60, 0, 30)
            runBtn.Position = UDim2.new(1, -130, 0.5, -15)
            runBtn.BackgroundColor3 = C_WHITE
            runBtn.TextColor3 = C_BLACK
            runBtn.Font = FONT_TITLE
            runBtn.TextSize = 11
            runBtn.Text = "RUN"
            runBtn.Parent = card

            local rbCorner = Instance.new("UICorner")
            rbCorner.CornerRadius = UDim.new(0, 6)
            rbCorner.Parent = runBtn

            local delBtn = Instance.new("TextButton")
            delBtn.Size = UDim2.new(0, 60, 0, 30)
            delBtn.Position = UDim2.new(1, -64, 0.5, -15)
            delBtn.BackgroundColor3 = C_CARD
            delBtn.TextColor3 = C_MUTED
            delBtn.Font = FONT_TITLE
            delBtn.TextSize = 11
            delBtn.Text = "DEL"
            delBtn.Parent = card

            local dbCorner = Instance.new("UICorner")
            dbCorner.CornerRadius = UDim.new(0, 6)
            dbCorner.Parent = delBtn

            local function tryReadFile()
                if not readfile then return nil end
                local ok, content = pcall(readfile, relPath)
                if ok and content then return content end
                ok, content = pcall(readfile, rawPath)
                if ok and content then return content end
                ok, content = pcall(readfile, fileName)
                if ok and content then return content end
                return nil
            end

            loadBtn.MouseButton1Click:Connect(function()
                local content = tryReadFile()
                if content then
                    editorBox.Text = content
                    if switchTab then switchTab("Executor") end
                    headerStatus.Text = "LOADED: " .. fileName
                else
                    headerStatus.Text = "READ FAILED: " .. fileName
                end
            end)

            runBtn.MouseButton1Click:Connect(function()
                local content = tryReadFile()
                if content then
                    local fn, err = loadstring(content)
                    if fn then
                        task.spawn(fn)
                        headerStatus.Text = "RUNNING: " .. fileName
                    else
                        headerStatus.Text = "EXEC ERROR: " .. fileName
                    end
                else
                    headerStatus.Text = "READ FAILED: " .. fileName
                end
            end)

            delBtn.MouseButton1Click:Connect(function()
                local deleted = false
                if delfile then
                    -- Attempt standard relative paths allowed by the C++ path_arg sandbox
                    local candidates = { relPath, rawPath, SCRIPTS_DIR .. "/" .. fileName, fileName }
                    for _, cand in ipairs(candidates) do
                        local ok, res = pcall(delfile, cand)
                        if ok and res ~= false then
                            deleted = true
                            break
                        end
                    end
                end

                if deleted then
                    card:Destroy()
                    headerStatus.Text = "DELETED: " .. fileName
                else
                    -- Fallback: truncate file if delfile is restricted
                    pcall(function()
                        if writefile then
                            writefile(relPath, "")
                            card:Destroy()
                            headerStatus.Text = "CLEARED: " .. fileName
                        end
                    end)
                end
            end)
        end
    end
end

btnRefreshSaved.MouseButton1Click:Connect(refreshSavedList)

btnModalSave.MouseButton1Click:Connect(function()
    local name = inputScriptName.Text
    if not name or #name == 0 then
        name = "Script_" .. tostring(os.time())
    end
    if not string.find(name, "%.luau$") and not string.find(name, "%.lua$") then
        name = name .. ".luau"
    end
    local targetPath = SCRIPTS_DIR .. "/" .. name
    pcall(function()
        if writefile then
            writefile(targetPath, inputScriptCode.Text)
            addScriptModal.Visible = false
            refreshSavedList()
            headerStatus.Text = "SAVED: " .. name
        end
    end)
end)

btnSaveAs.MouseButton1Click:Connect(function()
    inputScriptName.Text = ""
    inputScriptCode.Text = editorBox.Text
    if switchTab then switchTab("Saved") end
    addScriptModal.Visible = true
end)

-- ==========================================
-- [10] TAB 3: SCRIPTBLOX DISCOVERY GRID
-- ==========================================
local pageSearch = Instance.new("Frame")
pageSearch.Name = "Page_Search"
pageSearch.Size = UDim2.new(1, 0, 1, 0)
pageSearch.BackgroundTransparency = 1
pageSearch.Visible = false
pageSearch.Parent = viewport
pages["Search"] = pageSearch

local searchHeaderBar = Instance.new("Frame")
searchHeaderBar.Size = UDim2.new(1, 0, 0, 36)
searchHeaderBar.BackgroundTransparency = 1
searchHeaderBar.Parent = pageSearch

local searchBar = Instance.new("TextBox")
searchBar.Size = UDim2.new(1, -95, 1, 0)
searchBar.BackgroundColor3 = C_BLACK
searchBar.TextColor3 = C_WHITE
searchBar.PlaceholderText = "Search community scripts..."
searchBar.PlaceholderColor3 = C_SUBTLE
searchBar.Font = FONT_CODE
searchBar.TextSize = 12
searchBar.Text = ""
searchBar.ClearTextOnFocus = false
searchBar.Parent = searchHeaderBar

local sbCorner = Instance.new("UICorner")
sbCorner.CornerRadius = UDim.new(0, 8)
sbCorner.Parent = searchBar

local sbPad = Instance.new("UIPadding")
sbPad.PaddingLeft = UDim.new(0, 10)
sbPad.Parent = searchBar

local sbStroke = Instance.new("UIStroke")
sbStroke.Color = C_BORDER
sbStroke.Thickness = 1
sbStroke.Parent = searchBar

local searchBtn = Instance.new("TextButton")
searchBtn.Size = UDim2.new(0, 88, 1, 0)
searchBtn.Position = UDim2.new(1, -88, 0, 0)
searchBtn.BackgroundColor3 = C_WHITE
searchBtn.TextColor3 = C_BLACK
searchBtn.Font = FONT_TITLE
searchBtn.TextSize = 11
searchBtn.Text = "SEARCH"
searchBtn.Parent = searchHeaderBar

local searchBtnCorner = Instance.new("UICorner")
searchBtnCorner.CornerRadius = UDim.new(0, 8)
searchBtnCorner.Parent = searchBtn

local searchGridScroll = Instance.new("ScrollingFrame")
searchGridScroll.Size = UDim2.new(1, 0, 1, -44)
searchGridScroll.Position = UDim2.new(0, 0, 0, 44)
searchGridScroll.BackgroundTransparency = 1
searchGridScroll.BorderSizePixel = 0
searchGridScroll.ScrollBarThickness = 4
searchGridScroll.ScrollBarImageColor3 = C_WHITE
searchGridScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
searchGridScroll.Parent = pageSearch

local searchGridLayout = Instance.new("UIGridLayout")
searchGridLayout.CellSize = UDim2.new(0.315, 0, 0, 145)
searchGridLayout.CellPadding = UDim2.new(0, 10, 0, 10)
searchGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
searchGridLayout.Parent = searchGridScroll

-- Action Modal
local actionModal = Instance.new("Frame")
actionModal.Name = "ActionModal"
actionModal.Size = UDim2.new(0, 260, 0, 130)
actionModal.Position = UDim2.new(0.5, -130, 0.5, -65)
actionModal.BackgroundColor3 = C_DARK
actionModal.BorderSizePixel = 0
actionModal.Visible = false
actionModal.ZIndex = 100
actionModal.Parent = floatingWindow

local amCorner = Instance.new("UICorner")
amCorner.CornerRadius = UDim.new(0, 12)
amCorner.Parent = actionModal

local amStroke = Instance.new("UIStroke")
amStroke.Color = C_WHITE
amStroke.Thickness = 1.2
amStroke.Parent = actionModal

local amTitle = Instance.new("TextLabel")
amTitle.Size = UDim2.new(1, -20, 0, 24)
amTitle.Position = UDim2.new(0, 10, 0, 10)
amTitle.BackgroundTransparency = 1
amTitle.Text = "Select Action"
amTitle.TextColor3 = C_WHITE
amTitle.Font = FONT_TITLE
amTitle.TextSize = 12
amTitle.TextTruncate = Enum.TextTruncate.AtEnd
amTitle.ZIndex = 101
amTitle.Parent = actionModal

local amClose = Instance.new("TextButton")
amClose.Size = UDim2.new(0, 24, 0, 24)
amClose.Position = UDim2.new(1, -28, 0, 6)
amClose.BackgroundTransparency = 1
amClose.Text = "✕"
amClose.TextColor3 = C_MUTED
amClose.Font = FONT_TITLE
amClose.TextSize = 12
amClose.ZIndex = 102
amClose.Parent = actionModal

local amBtnLoad = Instance.new("TextButton")
amBtnLoad.Size = UDim2.new(0.44, 0, 0, 34)
amBtnLoad.Position = UDim2.new(0.04, 0, 0, 45)
amBtnLoad.BackgroundColor3 = C_CARD
amBtnLoad.TextColor3 = C_WHITE
amBtnLoad.Font = FONT_TITLE
amBtnLoad.TextSize = 11
amBtnLoad.Text = "LOAD"
amBtnLoad.ZIndex = 101
amBtnLoad.Parent = actionModal

local amblCorner = Instance.new("UICorner")
amblCorner.CornerRadius = UDim.new(0, 6)
amblCorner.Parent = amBtnLoad

local amBtnRun = Instance.new("TextButton")
amBtnRun.Size = UDim2.new(0.44, 0, 0, 34)
amBtnRun.Position = UDim2.new(0.52, 0, 0, 45)
amBtnRun.BackgroundColor3 = C_WHITE
amBtnRun.TextColor3 = C_BLACK
amBtnRun.Font = FONT_TITLE
amBtnRun.TextSize = 11
amBtnRun.Text = "RUN"
amBtnRun.ZIndex = 101
amBtnRun.Parent = actionModal

local ambrCorner = Instance.new("UICorner")
ambrCorner.CornerRadius = UDim.new(0, 6)
ambrCorner.Parent = amBtnRun

local amBtnSave = Instance.new("TextButton")
amBtnSave.Size = UDim2.new(0.92, 0, 0, 30)
amBtnSave.Position = UDim2.new(0.04, 0, 0, 88)
amBtnSave.BackgroundColor3 = C_BLACK
amBtnSave.TextColor3 = C_WHITE
amBtnSave.Font = FONT_TITLE
amBtnSave.TextSize = 11
amBtnSave.Text = "SAVE TO LOCAL SCRIPTS"
amBtnSave.ZIndex = 101
amBtnSave.Parent = actionModal

local ambsCorner = Instance.new("UICorner")
ambsCorner.CornerRadius = UDim.new(0, 6)
ambsCorner.Parent = amBtnSave

local ambsStroke = Instance.new("UIStroke")
ambsStroke.Color = C_BORDER
ambsStroke.Thickness = 1
ambsStroke.Parent = amBtnSave

local selectedCommunityScript = nil

amClose.MouseButton1Click:Connect(function()
    actionModal.Visible = false
    selectedCommunityScript = nil
end)

amBtnLoad.MouseButton1Click:Connect(function()
    if selectedCommunityScript and selectedCommunityScript.script then
        editorBox.Text = selectedCommunityScript.script
        actionModal.Visible = false
        if switchTab then switchTab("Executor") end
        headerStatus.Text = "LOADED TO EDITOR"
    end
end)

amBtnRun.MouseButton1Click:Connect(function()
    if selectedCommunityScript and selectedCommunityScript.script then
        actionModal.Visible = false
        local fn = loadstring(selectedCommunityScript.script)
        if fn then task.spawn(fn) end
        headerStatus.Text = "EXECUTED"
    end
end)

amBtnSave.MouseButton1Click:Connect(function()
    if selectedCommunityScript and selectedCommunityScript.script then
        local safeName = string.gsub(selectedCommunityScript.title or "Script", "[%p%s]", "_") .. ".luau"
        pcall(function()
            if writefile then
                writefile(SCRIPTS_DIR .. "/" .. safeName, selectedCommunityScript.script)
                headerStatus.Text = "SAVED: " .. safeName
            end
        end)
        actionModal.Visible = false
    end
end)

local function performScriptBloxSearch(query)
    for _, ch in ipairs(searchGridScroll:GetChildren()) do
        if ch:IsA("Frame") then ch:Destroy() end
    end
    headerStatus.Text = "SEARCHING SCRIPTBLOX..."

    task.spawn(function()
        local cleanQuery = HttpService:UrlEncode(query)
        local endpoints = {
            "https://scriptblox.com/api/script/search?q=" .. cleanQuery .. "&mode=free",
            "https://scriptblox-api-proxy.vercel.app/api/script/search?q=" .. cleanQuery .. "&mode=free"
        }

        local rawData = nil
        for _, url in ipairs(endpoints) do
            pcall(function()
                if game.HttpGet then
                    rawData = game:HttpGet(url, true)
                elseif request then
                    local res = request({ Url = url, Method = "GET" })
                    if res and (res.StatusCode == 200 or res.Body) then rawData = res.Body end
                end
            end)
            if rawData and #rawData > 30 then break end
        end

        if rawData then
            local ok, parsed = pcall(function() return HttpService:JSONDecode(rawData) end)
            if ok and parsed and parsed.result and parsed.result.scripts then
                local scriptsList = parsed.result.scripts
                if #scriptsList == 0 then
                    headerStatus.Text = "NO SCRIPTS FOUND"
                    return
                end

                for _, item in ipairs(scriptsList) do
                    local card = Instance.new("Frame")
                    card.BackgroundColor3 = C_BLACK
                    card.BorderSizePixel = 0
                    card.Parent = searchGridScroll

                    local cc = Instance.new("UICorner")
                    cc.CornerRadius = UDim.new(0, 10)
                    cc.Parent = card

                    local cs = Instance.new("UIStroke")
                    cs.Color = C_BORDER
                    cs.Thickness = 1
                    cs.Parent = card

                    local img = Instance.new("ImageLabel")
                    img.Size = UDim2.new(1, -12, 0, 72)
                    img.Position = UDim2.new(0, 6, 0, 6)
                    img.BackgroundColor3 = C_CARD
                    img.ScaleType = Enum.ScaleType.Crop
                    img.Parent = card

                    local ic = Instance.new("UICorner")
                    ic.CornerRadius = UDim.new(0, 8)
                    ic.Parent = img

                    if item.game and item.game.imageUrl then
                        local imageUrl = item.game.imageUrl
                        if string.find(imageUrl, "^/") then
                            imageUrl = "https://scriptblox.com" .. imageUrl
                        end
                        img.Image = imageUrl
                    else
                        img.Image = ASSETS.FALLBACK_THUMB
                    end

                    local titleLbl = Instance.new("TextLabel")
                    titleLbl.Size = UDim2.new(1, -12, 0, 32)
                    titleLbl.Position = UDim2.new(0, 6, 0, 82)
                    titleLbl.BackgroundTransparency = 1
                    titleLbl.Text = item.title or "Script"
                    titleLbl.TextColor3 = C_WHITE
                    titleLbl.Font = FONT_TITLE
                    titleLbl.TextSize = 11
                    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
                    titleLbl.TextYAlignment = Enum.TextYAlignment.Top
                    titleLbl.TextWrapped = true
                    titleLbl.Parent = card

                    local gameLbl = Instance.new("TextLabel")
                    gameLbl.Size = UDim2.new(1, -12, 0, 16)
                    gameLbl.Position = UDim2.new(0, 6, 1, -22)
                    gameLbl.BackgroundTransparency = 1
                    gameLbl.Text = (item.game and item.game.name) or "Universal"
                    gameLbl.TextColor3 = C_MUTED
                    gameLbl.Font = FONT_CODE
                    gameLbl.TextSize = 9
                    gameLbl.TextXAlignment = Enum.TextXAlignment.Left
                    gameLbl.TextTruncate = Enum.TextTruncate.AtEnd
                    gameLbl.Parent = card

                    local clickBtn = Instance.new("TextButton")
                    clickBtn.Size = UDim2.new(1, 0, 1, 0)
                    clickBtn.BackgroundTransparency = 1
                    clickBtn.Text = ""
                    clickBtn.Parent = card

                    clickBtn.MouseButton1Click:Connect(function()
                        selectedCommunityScript = item
                        amTitle.Text = item.title or "Select Action"
                        actionModal.Visible = true
                    end)
                end
                headerStatus.Text = "LOADED " .. tostring(#scriptsList) .. " SCRIPTS"
                return
            end
        end
        headerStatus.Text = "SEARCH TIMEOUT"
    end)
end

searchBtn.MouseButton1Click:Connect(function()
    if #searchBar.Text > 0 then
        performScriptBloxSearch(searchBar.Text)
    end
end)

searchBar.FocusLost:Connect(function(enterPressed)
    if enterPressed and #searchBar.Text > 0 then
        performScriptBloxSearch(searchBar.Text)
    end
end)

-- ==========================================
-- [11] TAB 4: REAL-TIME DUAL CONSOLE (FIXED OUTPUT & AUTO-SCROLL)
-- ==========================================
local pageConsole = Instance.new("Frame")
pageConsole.Name = "Page_Console"
pageConsole.Size = UDim2.new(1, 0, 1, 0)
pageConsole.BackgroundTransparency = 1
pageConsole.Visible = false
pageConsole.Parent = viewport
pages["Console"] = pageConsole

local consoleBody = Instance.new("Frame")
consoleBody.Size = UDim2.new(1, 0, 1, -38)
consoleBody.BackgroundTransparency = 1
consoleBody.Parent = pageConsole

local split = Instance.new("UIListLayout")
split.FillDirection = Enum.FillDirection.Horizontal
split.Padding = UDim.new(0, 10)
split.Parent = consoleBody

local function makeConsolePane(title)
    local pane = Instance.new("Frame")
    pane.Size = UDim2.new(0.5, -5, 1, 0)
    pane.BackgroundColor3 = C_BLACK
    pane.Parent = consoleBody

    local pCorner = Instance.new("UICorner")
    pCorner.CornerRadius = UDim.new(0, 10)
    pCorner.Parent = pane

    local pStroke = Instance.new("UIStroke")
    pStroke.Color = C_BORDER
    pStroke.Thickness = 1
    pStroke.Parent = pane

    local pHeader = Instance.new("Frame")
    pHeader.Size = UDim2.new(1, 0, 0, 28)
    pHeader.BackgroundColor3 = C_CARD
    pHeader.BorderSizePixel = 0
    pHeader.Parent = pane

    local phCorner = Instance.new("UICorner")
    phCorner.CornerRadius = UDim.new(0, 10)
    phCorner.Parent = pHeader

    local pTitle = Instance.new("TextLabel")
    pTitle.Size = UDim2.new(1, -12, 1, 0)
    pTitle.Position = UDim2.new(0, 10, 0, 0)
    pTitle.BackgroundTransparency = 1
    pTitle.Text = title
    pTitle.TextColor3 = C_WHITE
    pTitle.Font = FONT_TITLE
    pTitle.TextSize = 10
    pTitle.TextXAlignment = Enum.TextXAlignment.Left
    pTitle.Parent = pHeader

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -12, 1, -34)
    scroll.Position = UDim2.new(0, 6, 0, 30)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 3
    scroll.ScrollBarImageColor3 = C_WHITE
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.ScrollingEnabled = false
    scroll.Parent = pane

    local sLayout = Instance.new("UIListLayout")
    sLayout.Padding = UDim.new(0, 3)
    sLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sLayout.Parent = scroll

    return scroll
end

local orcPane = makeConsolePane("ORC RUNTIME (ERRORS ONLY)")
local rbxPane = makeConsolePane("ROBLOX ENGINE (ALL OUTPUTS)")

-- Bottom Unified Clear Bar
local consoleBottomBar = Instance.new("Frame")
consoleBottomBar.Size = UDim2.new(1, 0, 0, 32)
consoleBottomBar.Position = UDim2.new(0, 0, 1, -32)
consoleBottomBar.BackgroundTransparency = 1
consoleBottomBar.Parent = pageConsole

local cbLayout = Instance.new("UIListLayout")
cbLayout.FillDirection = Enum.FillDirection.Horizontal
cbLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
cbLayout.Padding = UDim.new(0, 8)
cbLayout.Parent = consoleBottomBar

local btnClearOrc = Instance.new("TextButton")
btnClearOrc.Size = UDim2.new(0, 95, 1, 0)
btnClearOrc.BackgroundColor3 = C_CARD
btnClearOrc.TextColor3 = C_WHITE
btnClearOrc.Font = FONT_TITLE
btnClearOrc.TextSize = 10
btnClearOrc.Text = "CLEAR ORC"
btnClearOrc.Parent = consoleBottomBar

local bcoCorner = Instance.new("UICorner")
bcoCorner.CornerRadius = UDim.new(0, 6)
bcoCorner.Parent = btnClearOrc

local btnClearRbx = Instance.new("TextButton")
btnClearRbx.Size = UDim2.new(0, 95, 1, 0)
btnClearRbx.BackgroundColor3 = C_CARD
btnClearRbx.TextColor3 = C_WHITE
btnClearRbx.Font = FONT_TITLE
btnClearRbx.TextSize = 10
btnClearRbx.Text = "CLEAR ROBLOX"
btnClearRbx.Parent = consoleBottomBar

local bcrCorner = Instance.new("UICorner")
bcrCorner.CornerRadius = UDim.new(0, 6)
bcrCorner.Parent = btnClearRbx

local btnClearAll = Instance.new("TextButton")
btnClearAll.Size = UDim2.new(0, 95, 1, 0)
btnClearAll.BackgroundColor3 = C_WHITE
btnClearAll.TextColor3 = C_BLACK
btnClearAll.Font = FONT_TITLE
btnClearAll.TextSize = 10
btnClearAll.Text = "CLEAR ALL"
btnClearAll.Parent = consoleBottomBar

local bcaCorner = Instance.new("UICorner")
bcaCorner.CornerRadius = UDim.new(0, 6)
bcaCorner.Parent = btnClearAll

btnClearOrc.MouseButton1Click:Connect(function()
    for _, ch in ipairs(orcPane:GetChildren()) do
        if ch:IsA("Frame") then ch:Destroy() end
    end
end)

btnClearRbx.MouseButton1Click:Connect(function()
    for _, ch in ipairs(rbxPane:GetChildren()) do
        if ch:IsA("Frame") then ch:Destroy() end
    end
end)

btnClearAll.MouseButton1Click:Connect(function()
    for _, ch in ipairs(orcPane:GetChildren()) do
        if ch:IsA("Frame") then ch:Destroy() end
    end
    for _, ch in ipairs(rbxPane:GetChildren()) do
        if ch:IsA("Frame") then ch:Destroy() end
    end
end)

local logOrder = 0
local function addLogEntry(scrollFrame, text, tag)
    logOrder = logOrder + 1
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 0)
    row.AutomaticSize = Enum.AutomaticSize.Y
    row.BackgroundTransparency = 1
    row.LayoutOrder = logOrder
    row.Parent = scrollFrame

    local tagLabel = Instance.new("TextLabel")
    tagLabel.Size = UDim2.new(0, 36, 0, 16)
    tagLabel.BackgroundTransparency = 1
    tagLabel.Text = tag or "ERR"
    tagLabel.TextColor3 = C_WHITE
    tagLabel.Font = FONT_CODE
    tagLabel.TextSize = 10
    tagLabel.TextXAlignment = Enum.TextXAlignment.Left
    tagLabel.Parent = row

    local msgLabel = Instance.new("TextLabel")
    msgLabel.Size = UDim2.new(1, -40, 0, 0)
    msgLabel.Position = UDim2.new(0, 40, 0, 0)
    msgLabel.AutomaticSize = Enum.AutomaticSize.Y
    msgLabel.BackgroundTransparency = 1
    msgLabel.Text = tostring(text)
    msgLabel.TextColor3 = C_WHITE
    msgLabel.Font = FONT_CODE
    msgLabel.TextSize = 10
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.TextWrapped = true
    msgLabel.Parent = row

    task.defer(function()
        scrollFrame.CanvasPosition = Vector2.new(0, 999999)
    end)
end

-- Hook LogService: Roblox Console logs all messages; ORC logs errors only
LogService.MessageOut:Connect(function(message, messageType)
    local tag = "OUT"
    if messageType == Enum.MessageType.MessageError then
        tag = "ERR"
        addLogEntry(orcPane, message, "ERR")
    elseif messageType == Enum.MessageType.MessageWarning then
        tag = "WARN"
    elseif messageType == Enum.MessageType.MessageInfo then
        tag = "INFO"
    end
    addLogEntry(rbxPane, message, tag)
end)

pcall(function()
    local history = LogService:GetLogHistory()
    for _, item in ipairs(history) do
        local tag = "OUT"
        if item.messageType == Enum.MessageType.MessageError then
            tag = "ERR"
            addLogEntry(orcPane, item.message, "ERR")
        elseif item.messageType == Enum.MessageType.MessageWarning then
            tag = "WARN"
        end
        addLogEntry(rbxPane, item.message, tag)
    end
end)

addLogEntry(orcPane, "ORC Kernel active.", "INIT")
addLogEntry(rbxPane, "Roblox Engine Console active.", "INIT")

-- ==========================================
-- [12] TAB 5: ADVANCED EXECUTOR SETTINGS
-- ==========================================
local pageSettings = Instance.new("ScrollingFrame")
pageSettings.Name = "Page_Settings"
pageSettings.Size = UDim2.new(1, 0, 1, 0)
pageSettings.BackgroundTransparency = 1
pageSettings.BorderSizePixel = 0
pageSettings.ScrollBarThickness = 4
pageSettings.ScrollBarImageColor3 = C_WHITE
pageSettings.AutomaticCanvasSize = Enum.AutomaticSize.Y
pageSettings.Visible = false
pageSettings.Parent = viewport
pages["Settings"] = pageSettings

local settsLayout = Instance.new("UIListLayout")
settsLayout.Padding = UDim.new(0, 8)
settsLayout.Parent = pageSettings

local function makeSettingToggle(title, desc, defaultState, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -4, 0, 48)
    card.BackgroundColor3 = C_BLACK
    card.Parent = pageSettings

    local cc = Instance.new("UICorner")
    cc.CornerRadius = UDim.new(0, 8)
    cc.Parent = card

    local cs = Instance.new("UIStroke")
    cs.Color = C_BORDER
    cs.Thickness = 1
    cs.Parent = card

    local tLbl = Instance.new("TextLabel")
    tLbl.Size = UDim2.new(0.7, 0, 0, 20)
    tLbl.Position = UDim2.new(0, 10, 0, 5)
    tLbl.BackgroundTransparency = 1
    tLbl.Text = title
    tLbl.TextColor3 = C_WHITE
    tLbl.Font = FONT_TITLE
    tLbl.TextSize = 12
    tLbl.TextXAlignment = Enum.TextXAlignment.Left
    tLbl.Parent = card

    local dLbl = Instance.new("TextLabel")
    dLbl.Size = UDim2.new(0.7, 0, 0, 16)
    dLbl.Position = UDim2.new(0, 10, 0, 25)
    dLbl.BackgroundTransparency = 1
    dLbl.Text = desc
    dLbl.TextColor3 = C_MUTED
    dLbl.Font = FONT_CODE
    dLbl.TextSize = 10
    dLbl.TextXAlignment = Enum.TextXAlignment.Left
    dLbl.Parent = card

    local tglBtn = Instance.new("TextButton")
    tglBtn.Size = UDim2.new(0, 64, 0, 28)
    tglBtn.Position = UDim2.new(1, -72, 0.5, -14)
    tglBtn.BackgroundColor3 = defaultState and C_WHITE or C_CARD
    tglBtn.TextColor3 = defaultState and C_BLACK or C_MUTED
    tglBtn.Font = FONT_TITLE
    tglBtn.TextSize = 11
    tglBtn.Text = defaultState and "ON" or "OFF"
    tglBtn.Parent = card

    local tbCorner = Instance.new("UICorner")
    tbCorner.CornerRadius = UDim.new(0, 6)
    tbCorner.Parent = tglBtn

    local state = defaultState
    tglBtn.MouseButton1Click:Connect(function()
        state = not state
        tglBtn.BackgroundColor3 = state and C_WHITE or C_CARD
        tglBtn.TextColor3 = state and C_BLACK or C_MUTED
        tglBtn.Text = state and "ON" or "OFF"
        callback(state)
    end)
end

local function makeSettingInput(title, desc, placeholder, onApplied)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -4, 0, 48)
    card.BackgroundColor3 = C_BLACK
    card.Parent = pageSettings

    local cc = Instance.new("UICorner")
    cc.CornerRadius = UDim.new(0, 8)
    cc.Parent = card

    local cs = Instance.new("UIStroke")
    cs.Color = C_BORDER
    cs.Thickness = 1
    cs.Parent = card

    local tLbl = Instance.new("TextLabel")
    tLbl.Size = UDim2.new(0.55, 0, 0, 20)
    tLbl.Position = UDim2.new(0, 10, 0, 5)
    tLbl.BackgroundTransparency = 1
    tLbl.Text = title
    tLbl.TextColor3 = C_WHITE
    tLbl.Font = FONT_TITLE
    tLbl.TextSize = 12
    tLbl.TextXAlignment = Enum.TextXAlignment.Left
    tLbl.Parent = card

    local dLbl = Instance.new("TextLabel")
    dLbl.Size = UDim2.new(0.55, 0, 0, 16)
    dLbl.Position = UDim2.new(0, 10, 0, 25)
    dLbl.BackgroundTransparency = 1
    dLbl.Text = desc
    dLbl.TextColor3 = C_MUTED
    dLbl.Font = FONT_CODE
    dLbl.TextSize = 10
    dLbl.TextXAlignment = Enum.TextXAlignment.Left
    dLbl.Parent = card

    local inBox = Instance.new("TextBox")
    inBox.Size = UDim2.new(0.38, 0, 0, 28)
    inBox.Position = UDim2.new(0.60, 0, 0.5, -14)
    inBox.BackgroundColor3 = C_CARD
    inBox.TextColor3 = C_WHITE
    inBox.PlaceholderText = placeholder
    inBox.PlaceholderColor3 = C_SUBTLE
    inBox.Font = FONT_CODE
    inBox.TextSize = 11
    inBox.ClearTextOnFocus = false
    inBox.Parent = card

    local ibCorner = Instance.new("UICorner")
    ibCorner.CornerRadius = UDim.new(0, 6)
    ibCorner.Parent = inBox

    local ibStroke = Instance.new("UIStroke")
    ibStroke.Color = C_BORDER
    ibStroke.Thickness = 1
    ibStroke.Parent = inBox

    inBox.FocusLost:Connect(function(enterPressed)
        if enterPressed and #inBox.Text > 0 then
            onApplied(inBox.Text)
        end
    end)
end

-- Settings Controls
makeSettingInput("Spoof Title", "Override header window text", "Custom title...", function(val)
    headerTitle.Text = string.upper(val)
end)

makeSettingInput("Floating Bubble Text", "Change text on minimized bubble", "Text...", function(val)
    floatingBubble.Text = val
end)

makeSettingToggle("Anti-AFK Protection", "Prevent 20min inactivity kick", true, function(enabled)
    if enabled then
        player.Idled:Connect(function()
            VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
    end
end)

makeSettingToggle("FPS Unlocker (240 FPS)", "Bypass 60 FPS mobile limit", true, function(enabled)
    pcall(function()
        if setfpscap then setfpscap(enabled and 240 or 60) end
    end)
end)

local speedConn = nil
makeSettingToggle("Speed Hack (WalkSpeed 50)", "Constant movement speed modifier", false, function(enabled)
    if speedConn then speedConn:Disconnect() speedConn = nil end
    if enabled then
        speedConn = RunService.Stepped:Connect(function()
            pcall(function()
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    player.Character.Humanoid.WalkSpeed = 50
                end
            end)
        end)
    else
        pcall(function()
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = 16
            end
        end)
    end
end)

local infJumpConn = nil
makeSettingToggle("Infinite Jump", "Jump infinitely in air", false, function(enabled)
    if infJumpConn then infJumpConn:Disconnect() infJumpConn = nil end
    if enabled then
        infJumpConn = UserInputService.JumpRequest:Connect(function()
            pcall(function()
                if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                    player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
                end
            end)
        end)
    end
end)

local noclipConn = nil
makeSettingToggle("Noclip Collision Ghost", "Walk through map barriers", false, function(enabled)
    if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    if enabled then
        noclipConn = RunService.Stepped:Connect(function()
            pcall(function()
                if player.Character then
                    for _, part in ipairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end)
    end
end)

-- ==========================================
-- [13] TAB SWITCHING ENGINE
-- ==========================================
local currentTab = "Executor"
local isTransitioning = false

function switchTab(tabName)
    if isTransitioning or currentTab == tabName then return end
    isTransitioning = true

    headerTitle.Text = string.upper(tabName)

    if tabName == "Saved" then
        refreshSavedList()
    end

    local targetBtn = dockButtons[tabName]
    if targetBtn then
        TweenService:Create(activePill, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = UDim2.new(1, -3, 0, targetBtn.Position.Y.Offset + 3)
        }):Play()

        for name, btn in pairs(dockButtons) do
            if name ~= "Close" then
                if name == tabName then
                    TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundColor3 = C_WHITE, ImageColor3 = C_BLACK }):Play()
                else
                    TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundColor3 = C_CARD, ImageColor3 = C_MUTED }):Play()
                end
            end
        end
    end

    local oldPage = pages[currentTab]
    local newPage = pages[tabName]

    if oldPage then
        local fadeOut = TweenService:Create(oldPage, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, -8, 0, 0)
        })
        fadeOut:Play()
        fadeOut.Completed:Connect(function()
            oldPage.Visible = false
            oldPage.Position = UDim2.new(0, 0, 0, 0)

            if newPage then
                newPage.Position = UDim2.new(0, 8, 0, 0)
                newPage.Visible = true
                local fadeIn = TweenService:Create(newPage, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0, 0, 0, 0)
                })
                fadeIn:Play()
                fadeIn.Completed:Connect(function()
                    currentTab = tabName
                    isTransitioning = false
                end)
            else
                currentTab = tabName
                isTransitioning = false
            end
        end)
    else
        if newPage then newPage.Visible = true end
        currentTab = tabName
        isTransitioning = false
    end
end

btnExecutor.MouseButton1Click:Connect(function() switchTab("Executor") end)
btnSaved.MouseButton1Click:Connect(function() switchTab("Saved") end)
btnSearch.MouseButton1Click:Connect(function() switchTab("Search") end)
btnConsole.MouseButton1Click:Connect(function() switchTab("Console") end)
btnSettings.MouseButton1Click:Connect(function() switchTab("Settings") end)

task.defer(function()
    pages["Executor"].Visible = true
    if dockButtons["Executor"] then
        dockButtons["Executor"].BackgroundColor3 = C_WHITE
        dockButtons["Executor"].ImageColor3 = C_BLACK
    end
end)

-- Minimize & Restore Floating Bubble
btnClose.MouseButton1Click:Connect(function()
    container.Visible = false
    floatingBubble.Visible = true
end)

floatingBubble.MouseButton1Click:Connect(function()
    floatingBubble.Visible = false
    container.Visible = true
end)

print("[ORC] Titan Framework v8.0 Active.")
