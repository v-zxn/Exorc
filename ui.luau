-- ==============================================================================
-- ORC TITAN FRAMEWORK v9.0 (PURE MONOCHROME • TABBED MULTI-TERMINAL)
-- #000000 / #FFFFFF • iOS SWITCHES • SCRIPTBLOX MODAL • FILE TREE
-- ==============================================================================

-- ==========================================
-- [1] ASSET & ICON CONFIGURATION
-- ==========================================
local ASSETS = {
    -- Sidebar dock icons (Clean linear / bold style)
    ICON_EXECUTOR = "rbxassetid://137645011895167", -- code-2-bold
    ICON_SAVED    = "rbxassetid://76034753816998",  -- folder-2-bold
    ICON_SEARCH   = "rbxassetid://104777342222451", -- card-search-bold
    ICON_CONSOLE  = "rbxassetid://70615504226457",  -- chat-square-code-bold
    ICON_SETTINGS = "rbxassetid://79820790543002",  -- colour-tuneing-bold
    ICON_CLOSE    = "rbxassetid://117747448917698", -- close-square-bold
    
    PROJECT_LOGO  = "https://raw.githubusercontent.com/v-zxn/Exorc/main/logo.png",
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
if not player then
    pcall(function()
        player = Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    end)
    if not player then
        player = Players.LocalPlayer
    end
end

local targetParent = CoreGui
pcall(function()
    if not pcall(function() return CoreGui.Name end) then
        if player then
            targetParent = player:WaitForChild("PlayerGui", 5) or CoreGui
        end
    end
end)

pcall(function()
    local existingUI = targetParent:FindFirstChild("ORC_TITAN_DELTA_FRAMEWORK")
    if existingUI then existingUI:Destroy() end
    local existingCore = CoreGui:FindFirstChild("ORC_TITAN_DELTA_FRAMEWORK")
    if existingCore then existingCore:Destroy() end
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ORC_TITAN_DELTA_FRAMEWORK"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 999999
screenGui.IgnoreGuiInset = true
screenGui.Parent = targetParent

-- Cleanup UI on teleport to prevent stale thread crashes
pcall(function()
    if player then
        player.OnTeleport:Connect(function()
            pcall(function() screenGui:Destroy() end)
        end)
    end
    TeleportService.TeleportInitFailed:Connect(function()
        -- Teleport failed, keep alive
    end)
end)

-- ==========================================
-- [3] PURE MONOCHROME PALETTE & FONTS
-- ==========================================
local C_BLACK   = Color3.fromRGB(0, 0, 0)
local C_DARK    = Color3.fromRGB(8, 8, 10)
local C_PANEL   = Color3.fromRGB(14, 14, 16)
local C_CARD    = Color3.fromRGB(22, 22, 26)
local C_BORDER  = Color3.fromRGB(36, 36, 44)
local C_WHITE   = Color3.fromRGB(255, 255, 255)
local C_MUTED   = Color3.fromRGB(160, 160, 170)
local C_SUBTLE  = Color3.fromRGB(90, 90, 100)
local C_BLUE    = C_WHITE                      -- accent (monochrome: white)
local C_BLUE_BG = Color3.fromRGB(38, 38, 46)   -- active/selected fill

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
-- [6] FLOATING CYBERPUNK DOCK (COMPACT ICONS & SLEEK DESIGN)
-- ==========================================
local rightDock = Instance.new("Frame")
rightDock.Name = "RightDock"
rightDock.Size = UDim2.new(0, 48, 1, -24)
rightDock.Position = UDim2.new(1, -56, 0, 12)
rightDock.BackgroundColor3 = C_PANEL
rightDock.BackgroundTransparency = 0.15
rightDock.BorderSizePixel = 0
rightDock.Active = true
rightDock.Parent = container

local rdCorner = Instance.new("UICorner")
rdCorner.CornerRadius = UDim.new(0, 16)
rdCorner.Parent = rightDock

local rdStroke = Instance.new("UIStroke")
rdStroke.Color = C_BORDER
rdStroke.Thickness = 1.2
rdStroke.Parent = rightDock

local dockButtonsContainer = Instance.new("Frame")
dockButtonsContainer.Name = "DockButtons"
dockButtonsContainer.Size = UDim2.new(1, 0, 1, -70)
dockButtonsContainer.Position = UDim2.new(0, 0, 0, 10)
dockButtonsContainer.BackgroundTransparency = 1
dockButtonsContainer.Parent = rightDock

-- Sliding Active Pill
local activePill = Instance.new("Frame")
activePill.Name = "ActivePill"
activePill.Size = UDim2.new(0, 3, 0, 22)
activePill.Position = UDim2.new(0, 2, 0, 8)
activePill.BackgroundColor3 = C_BLUE
activePill.BorderSizePixel = 0
activePill.Parent = dockButtonsContainer

local pillCorner = Instance.new("UICorner")
pillCorner.CornerRadius = UDim.new(0, 3)
pillCorner.Parent = activePill

local dockButtons = {}

local function makeDockButton(name, iconAsset, yOffset)
    local btn = Instance.new("ImageButton")
    btn.Name = "Btn_" .. name
    btn.Size = UDim2.new(0, 32, 0, 32)
    btn.Position = UDim2.new(0.5, -16, 0, yOffset)
    btn.BackgroundColor3 = C_CARD
    btn.BackgroundTransparency = 0.2
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
    pad.PaddingTop = UDim.new(0, 7)
    pad.PaddingBottom = UDim.new(0, 7)
    pad.PaddingLeft = UDim.new(0, 7)
    pad.PaddingRight = UDim.new(0, 7)
    pad.Parent = btn

    dockButtons[name] = btn
    return btn
end

-- 5 Buttons with comfortable compact spacing (42px interval)
local btnExecutor = makeDockButton("Executor", ASSETS.ICON_EXECUTOR, 4)
local btnSaved    = makeDockButton("Saved", ASSETS.ICON_SAVED, 46)
local btnSearch   = makeDockButton("Search", ASSETS.ICON_SEARCH, 88)
local btnConsole  = makeDockButton("Console", ASSETS.ICON_CONSOLE, 130)
local btnSettings = makeDockButton("Settings", ASSETS.ICON_SETTINGS, 172)

-- Close Button
local btnClose = Instance.new("ImageButton")
btnClose.Name = "Btn_Close"
btnClose.Size = UDim2.new(0, 32, 0, 32)
btnClose.Position = UDim2.new(0.5, -16, 1, -42)
btnClose.BackgroundColor3 = C_CARD
btnClose.BackgroundTransparency = 0.2
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
bcPad.PaddingTop = UDim.new(0, 8)
bcPad.PaddingBottom = UDim.new(0, 8)
bcPad.PaddingLeft = UDim.new(0, 8)
bcPad.PaddingRight = UDim.new(0, 8)
bcPad.Parent = btnClose
dockButtons["Close"] = btnClose

-- Floating Restore Bubble with Custom Project Logo
local floatingBubble = Instance.new("ImageButton")
floatingBubble.Name = "ORC_FloatingBubble"
floatingBubble.Size = UDim2.new(0, 48, 0, 48)
floatingBubble.Position = UDim2.new(1, -64, 0.45, 0)
floatingBubble.BackgroundColor3 = C_DARK
floatingBubble.BackgroundTransparency = 0.1
floatingBubble.Image = ""
floatingBubble.ScaleType = Enum.ScaleType.Fit
floatingBubble.Visible = false
floatingBubble.Active = true
floatingBubble.Draggable = true
floatingBubble.Parent = screenGui

local fbCorner = Instance.new("UICorner")
fbCorner.CornerRadius = UDim.new(1, 0)
fbCorner.Parent = floatingBubble

local fbStroke = Instance.new("UIStroke")
fbStroke.Color = C_BLUE
fbStroke.Thickness = 1.8
fbStroke.Parent = floatingBubble

local fbPad = Instance.new("UIPadding")
fbPad.PaddingTop = UDim.new(0, 6)
fbPad.PaddingBottom = UDim.new(0, 6)
fbPad.PaddingLeft = UDim.new(0, 6)
fbPad.PaddingRight = UDim.new(0, 6)
fbPad.Parent = floatingBubble

local fbFallbackText = Instance.new("TextLabel")
fbFallbackText.Size = UDim2.new(1, 0, 1, 0)
fbFallbackText.BackgroundTransparency = 1
fbFallbackText.Text = "ORC"
fbFallbackText.TextColor3 = C_WHITE
fbFallbackText.Font = FONT_TITLE
fbFallbackText.TextSize = 13
fbFallbackText.Parent = floatingBubble

task.spawn(function()
    local cachedLogoPath = "workspace/enforx_icon.png"
    pcall(function()
        if isfile and isfile(cachedLogoPath) and getcustomasset then
            floatingBubble.Image = getcustomasset(cachedLogoPath)
            fbFallbackText.Visible = false
        else
            -- Direct download using HttpGet or request
            local logoData = nil
            if game.HttpGet then
                pcall(function() logoData = game:HttpGet(ASSETS.PROJECT_LOGO, true) end)
            end
            if (not logoData or #logoData == 0) and request then
                pcall(function()
                    local res = request({ Url = ASSETS.PROJECT_LOGO, Method = "GET" })
                    if res and (res.StatusCode == 200 or res.Body) then logoData = res.Body end
                end)
            end
            if logoData and #logoData > 100 and writefile and getcustomasset then
                writefile(cachedLogoPath, logoData)
                floatingBubble.Image = getcustomasset(cachedLogoPath)
                fbFallbackText.Visible = false
            end
        end
    end)
end)

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
-- [8] TAB 1: ADVANCED MULTI-TAB TERMINAL EXECUTOR
-- ==========================================
local pageExecutor = Instance.new("Frame")
pageExecutor.Name = "Page_Executor"
pageExecutor.Size = UDim2.new(1, 0, 1, 0)
pageExecutor.BackgroundTransparency = 1
pageExecutor.Parent = viewport
pages["Executor"] = pageExecutor

-- Tab Bar for Multi-Terminal
local terminalTabBar = Instance.new("Frame")
terminalTabBar.Size = UDim2.new(1, 0, 0, 30)
terminalTabBar.BackgroundColor3 = C_DARK
terminalTabBar.BorderSizePixel = 0
terminalTabBar.Parent = pageExecutor

local ttbCorner = Instance.new("UICorner")
ttbCorner.CornerRadius = UDim.new(0, 6)
ttbCorner.Parent = terminalTabBar

local ttbLayout = Instance.new("UIListLayout")
ttbLayout.FillDirection = Enum.FillDirection.Horizontal
ttbLayout.Padding = UDim.new(0, 6)
ttbLayout.Parent = terminalTabBar

local btnNewTerminal = Instance.new("TextButton")
btnNewTerminal.Size = UDim2.new(0, 26, 0, 24)
btnNewTerminal.Position = UDim2.new(0, 4, 0, 3)
btnNewTerminal.BackgroundColor3 = C_CARD
btnNewTerminal.TextColor3 = C_WHITE
btnNewTerminal.Font = FONT_TITLE
btnNewTerminal.TextSize = 13
btnNewTerminal.Text = "+"
btnNewTerminal.Parent = terminalTabBar

local bntCorner = Instance.new("UICorner")
bntCorner.CornerRadius = UDim.new(0, 5)
bntCorner.Parent = btnNewTerminal

local terminals = {}
local activeTerminalIndex = 1
local tabsContainer = terminalTabBar

local function makeTerminalTab(index, title)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0, 85, 0, 24)
    tabBtn.BackgroundColor3 = (index == activeTerminalIndex) and C_WHITE or C_CARD
    tabBtn.TextColor3 = (index == activeTerminalIndex) and C_BLACK or C_MUTED
    tabBtn.Font = FONT_TITLE
    tabBtn.TextSize = 10
    tabBtn.Text = title or ("Tab " .. tostring(index))
    tabBtn.Parent = tabsContainer

    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(0, 5)
    tc.Parent = tabBtn

    return tabBtn
end

local function switchTerminal(index)
    activeTerminalIndex = index
    for i, t in ipairs(terminals) do
        t.Scroll.Visible = (i == index)
        if t.TabBtn then
            t.TabBtn.BackgroundColor3 = (i == index) and C_WHITE or C_CARD
            t.TabBtn.TextColor3 = (i == index) and C_BLACK or C_MUTED
        end
    end
end

local function createTerminal(title, defaultText)
    local index = #terminals + 1
    local tabBtn = makeTerminalTab(index, title)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Name = "EditorScroll_" .. tostring(index)
    scroll.Size = UDim2.new(1, 0, 1, -74)
    scroll.Position = UDim2.new(0, 0, 0, 36)
    scroll.BackgroundColor3 = C_BLACK
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = C_WHITE
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.Visible = (index == activeTerminalIndex)
    scroll.Parent = pageExecutor

    local scCorner = Instance.new("UICorner")
    scCorner.CornerRadius = UDim.new(0, 8)
    scCorner.Parent = scroll

    local scStroke = Instance.new("UIStroke")
    scStroke.Color = C_BORDER
    scStroke.Thickness = 1
    scStroke.Parent = scroll

    local box = Instance.new("TextBox")
    box.Name = "CodeBox"
    box.Size = UDim2.new(1, 0, 1, 0)
    box.AutomaticSize = Enum.AutomaticSize.Y
    box.BackgroundTransparency = 1
    box.TextColor3 = C_WHITE
    box.PlaceholderText = "-- Type or paste Luau code here..."
    box.PlaceholderColor3 = C_SUBTLE
    box.Font = FONT_CODE
    box.TextSize = 12
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.TextYAlignment = Enum.TextYAlignment.Top
    box.ClearTextOnFocus = false
    box.MultiLine = true
    box.Text = defaultText or ""
    box.Parent = scroll

    local bPad = Instance.new("UIPadding")
    bPad.PaddingLeft = UDim.new(0, 12)
    bPad.PaddingTop = UDim.new(0, 10)
    bPad.PaddingRight = UDim.new(0, 12)
    bPad.PaddingBottom = UDim.new(0, 10)
    bPad.Parent = box

    tabBtn.MouseButton1Click:Connect(function()
        switchTerminal(index)
    end)

    terminals[index] = { Scroll = scroll, Box = box, TabBtn = tabBtn }
    return terminals[index]
end

createTerminal("Main Tab", "")
btnNewTerminal.MouseButton1Click:Connect(function()
    if #terminals < 6 then
        createTerminal("Tab " .. tostring(#terminals + 1), "")
        switchTerminal(#terminals)
    end
end)

local function getActiveEditor()
    return terminals[activeTerminalIndex] and terminals[activeTerminalIndex].Box
end

-- Bottom Action Toolbar
local btnRow = Instance.new("Frame")
btnRow.Size = UDim2.new(1, 0, 0, 34)
btnRow.Position = UDim2.new(0, 0, 1, -34)
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
    c.CornerRadius = UDim.new(0, 7)
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
    local ed = getActiveEditor()
    if ed then ed.Text = "" end
end)

btnSyncClip.MouseButton1Click:Connect(function()
    local text = readSystemClipboard()
    local ed = getActiveEditor()
    if text and #text > 0 and ed then
        ed.Text = text
        headerStatus.Text = "PASTED " .. tostring(#text) .. " BYTES"
    end
end)

btnCopy.MouseButton1Click:Connect(function()
    local ed = getActiveEditor()
    if ed and #ed.Text > 0 then
        writeSystemClipboard(ed.Text)
        headerStatus.Text = "COPIED TO CLIPBOARD"
    end
end)

btnExecute.MouseButton1Click:Connect(function()
    local ed = getActiveEditor()
    local src = ed and ed.Text
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

-- Field 1: Script Name (with prominent stylish border)
local inputNameContainer = Instance.new("Frame")
inputNameContainer.Size = UDim2.new(1, -28, 0, 36)
inputNameContainer.Position = UDim2.new(0, 14, 0, 44)
inputNameContainer.BackgroundColor3 = C_BLACK
inputNameContainer.BorderSizePixel = 0
inputNameContainer.ZIndex = 201
inputNameContainer.Parent = addScriptModal

local incCorner = Instance.new("UICorner")
incCorner.CornerRadius = UDim.new(0, 8)
incCorner.Parent = inputNameContainer

local incStroke = Instance.new("UIStroke")
incStroke.Color = C_BLUE
incStroke.Thickness = 1.6
incStroke.Parent = inputNameContainer

local inputScriptName = Instance.new("TextBox")
inputScriptName.Size = UDim2.new(1, 0, 1, 0)
inputScriptName.BackgroundTransparency = 1
inputScriptName.TextColor3 = C_WHITE
inputScriptName.PlaceholderText = "Enter script name (e.g. MySuperFarm)..."
inputScriptName.PlaceholderColor3 = C_SUBTLE
inputScriptName.Font = FONT_CODE
inputScriptName.TextSize = 12
inputScriptName.ClearTextOnFocus = false
inputScriptName.Text = ""
inputScriptName.ZIndex = 202
inputScriptName.Parent = inputNameContainer

local isnPad = Instance.new("UIPadding")
isnPad.PaddingLeft = UDim.new(0, 10)
isnPad.PaddingRight = UDim.new(0, 10)
isnPad.Parent = inputScriptName

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
    local ed = getActiveEditor()
    inputScriptCode.Text = ed and ed.Text or ""
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

        -- Filter out internal scripts from Saved tab
        local isExcluded = (fileName == "README.txt") or 
                           (fileName == "target_ui.luau") or 
                           (fileName == "trigger_ui.lua") or 
                           (fileName == "trigger_ui.luau") or 
                           string.find(fileName, "^target_ui") or 
                           string.find(fileName, "^%.")

        if not isExcluded then
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
                    local ed = getActiveEditor()
                    if ed then ed.Text = content end
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
    local ed = getActiveEditor()
    inputScriptCode.Text = ed and ed.Text or ""
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

-- Expanded Script Action Modal
local actionModal = Instance.new("Frame")
actionModal.Name = "ActionModal"
actionModal.Size = UDim2.new(0.85, 0, 0.85, 0)
actionModal.Position = UDim2.new(0.075, 0, 0.075, 0)
actionModal.BackgroundColor3 = C_DARK
actionModal.BorderSizePixel = 0
actionModal.Visible = false
actionModal.ZIndex = 150
actionModal.Parent = floatingWindow

local amCorner = Instance.new("UICorner")
amCorner.CornerRadius = UDim.new(0, 12)
amCorner.Parent = actionModal

local amStroke = Instance.new("UIStroke")
amStroke.Color = C_WHITE
amStroke.Thickness = 1.4
amStroke.Parent = actionModal

local amImg = Instance.new("ImageLabel")
amImg.Size = UDim2.new(0, 110, 0, 110)
amImg.Position = UDim2.new(0, 14, 0, 14)
amImg.BackgroundColor3 = C_BLACK
amImg.ScaleType = Enum.ScaleType.Crop
amImg.ZIndex = 151
amImg.Parent = actionModal

local amImgCorner = Instance.new("UICorner")
amImgCorner.CornerRadius = UDim.new(0, 8)
amImgCorner.Parent = amImg

local amImgStroke = Instance.new("UIStroke")
amImgStroke.Color = C_BORDER
amImgStroke.Thickness = 1
amImgStroke.Parent = amImg

local amTitle = Instance.new("TextLabel")
amTitle.Size = UDim2.new(1, -170, 0, 28)
amTitle.Position = UDim2.new(0, 134, 0, 14)
amTitle.BackgroundTransparency = 1
amTitle.Text = "Script Details"
amTitle.TextColor3 = C_WHITE
amTitle.Font = FONT_TITLE
amTitle.TextSize = 13
amTitle.TextXAlignment = Enum.TextXAlignment.Left
amTitle.TextTruncate = Enum.TextTruncate.AtEnd
amTitle.ZIndex = 151
amTitle.Parent = actionModal

local amAuthor = Instance.new("TextLabel")
amAuthor.Size = UDim2.new(1, -170, 0, 20)
amAuthor.Position = UDim2.new(0, 134, 0, 44)
amAuthor.BackgroundTransparency = 1
amAuthor.Text = "Author: Unknown"
amAuthor.TextColor3 = C_MUTED
amAuthor.Font = FONT_CODE
amAuthor.TextSize = 11
amAuthor.TextXAlignment = Enum.TextXAlignment.Left
amAuthor.ZIndex = 151
amAuthor.Parent = actionModal

local amGame = Instance.new("TextLabel")
amGame.Size = UDim2.new(1, -170, 0, 20)
amGame.Position = UDim2.new(0, 134, 0, 66)
amGame.BackgroundTransparency = 1
amGame.Text = "Game: Universal"
amGame.TextColor3 = C_MUTED
amGame.Font = FONT_CODE
amGame.TextSize = 11
amGame.TextXAlignment = Enum.TextXAlignment.Left
amGame.ZIndex = 151
amGame.Parent = actionModal

local amClose = Instance.new("TextButton")
amClose.Size = UDim2.new(0, 26, 0, 26)
amClose.Position = UDim2.new(1, -34, 0, 10)
amClose.BackgroundTransparency = 1
amClose.Text = "✕"
amClose.TextColor3 = C_MUTED
amClose.Font = FONT_TITLE
amClose.TextSize = 13
amClose.ZIndex = 152
amClose.Parent = actionModal

local amBtnRow = Instance.new("Frame")
amBtnRow.Size = UDim2.new(1, -28, 0, 36)
amBtnRow.Position = UDim2.new(0, 14, 1, -48)
amBtnRow.BackgroundTransparency = 1
amBtnRow.ZIndex = 151
amBtnRow.Parent = actionModal

local amBtnRowLayout = Instance.new("UIListLayout")
amBtnRowLayout.FillDirection = Enum.FillDirection.Horizontal
amBtnRowLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
amBtnRowLayout.Padding = UDim.new(0, 8)
amBtnRowLayout.Parent = amBtnRow

local function makeModalActionBtn(text, bgCol, textCol, width)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, width or 80, 1, 0)
    b.BackgroundColor3 = bgCol
    b.TextColor3 = textCol
    b.Font = FONT_TITLE
    b.TextSize = 11
    b.Text = text
    b.ZIndex = 152
    b.Parent = amBtnRow

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = b

    local s = Instance.new("UIStroke")
    s.Color = C_BORDER
    s.Thickness = 1
    s.Parent = b
    return b
end

local amBtnSave = makeModalActionBtn("SAVE TO LOCAL", C_BLACK, C_WHITE, 120)
local amBtnLoad = makeModalActionBtn("LOAD", C_CARD, C_WHITE, 70)
local amBtnRun  = makeModalActionBtn("RUN", C_WHITE, C_BLACK, 70)

local selectedCommunityScript = nil

amClose.MouseButton1Click:Connect(function()
    actionModal.Visible = false
    selectedCommunityScript = nil
end)

amBtnLoad.MouseButton1Click:Connect(function()
    if selectedCommunityScript and selectedCommunityScript.script then
        local ed = getActiveEditor()
        if ed then ed.Text = selectedCommunityScript.script end
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

                        -- Fetch and cache ScriptBlox image locally for fast Roblox asset rendering
                        task.spawn(function()
                            local hashName = "workspace/.sb_" .. string.gsub(item._id or tostring(math.random(1000, 9999)), "%W", "") .. ".png"
                            pcall(function()
                                if isfile and isfile(hashName) and getcustomasset then
                                    img.Image = getcustomasset(hashName)
                                else
                                    local imgBytes = nil
                                    if game.HttpGet then
                                        imgBytes = game:HttpGet(imageUrl, true)
                                    elseif request then
                                        local res = request({ Url = imageUrl, Method = "GET" })
                                        if res and (res.StatusCode == 200 or res.Body) then imgBytes = res.Body end
                                    end
                                    if imgBytes and #imgBytes > 100 and writefile and getcustomasset then
                                        writefile(hashName, imgBytes)
                                        img.Image = getcustomasset(hashName)
                                    else
                                        img.Image = imageUrl
                                    end
                                end
                            end)
                        end)
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
                        amTitle.Text = item.title or "Script Details"
                        amAuthor.Text = "Author: " .. (item.owner and item.owner.username or "Community")
                        amGame.Text = "Game: " .. ((item.game and item.game.name) or "Universal")
                        amImg.Image = img.Image
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
    scroll.ScrollBarImageColor3 = C_BLUE
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.ScrollingEnabled = true
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.Parent = pane

    local sLayout = Instance.new("UIListLayout")
    sLayout.Padding = UDim.new(0, 3)
    sLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sLayout.Parent = scroll

    return scroll
end

local orcPane = makeConsolePane("ORC RUNTIME")
local rbxPane = makeConsolePane("ROBLOX CONSOLE")

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
local function addLogEntry(scrollFrame, text, level)
    logOrder = logOrder + 1
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 0)
    row.AutomaticSize = Enum.AutomaticSize.Y
    row.BackgroundTransparency = 1
    row.LayoutOrder = logOrder
    row.Parent = scrollFrame

    -- Color syntax based on severity: Red for Error, Yellow for Warning, Blue for Info, White for Output
    local entryColor = C_WHITE
    if level == "ERR" then
        entryColor = Color3.fromRGB(255, 75, 75)   -- Sharp Red
    elseif level == "WARN" then
        entryColor = Color3.fromRGB(255, 205, 50)  -- Golden Yellow
    elseif level == "INFO" then
        entryColor = Color3.fromRGB(80, 170, 255)  -- Neon Blue
    end

    local msgLabel = Instance.new("TextLabel")
    msgLabel.Size = UDim2.new(1, -10, 0, 0)
    msgLabel.Position = UDim2.new(0, 5, 0, 0)
    msgLabel.AutomaticSize = Enum.AutomaticSize.Y
    msgLabel.BackgroundTransparency = 1
    msgLabel.Text = tostring(text)
    msgLabel.TextColor3 = entryColor
    msgLabel.Font = FONT_CODE
    msgLabel.TextSize = 11
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.TextWrapped = true
    msgLabel.Parent = row

    task.defer(function()
        scrollFrame.CanvasPosition = Vector2.new(0, 999999)
    end)
end

-- Hook LogService: Clean log streaming with color highlights and zero tag clutter
LogService.MessageOut:Connect(function(message, messageType)
    local level = "OUT"
    if messageType == Enum.MessageType.MessageError then
        level = "ERR"
        addLogEntry(orcPane, message, "ERR")
    elseif messageType == Enum.MessageType.MessageWarning then
        level = "WARN"
    elseif messageType == Enum.MessageType.MessageInfo then
        level = "INFO"
    end
    addLogEntry(rbxPane, message, level)
end)

pcall(function()
    local history = LogService:GetLogHistory()
    for _, item in ipairs(history) do
        local level = "OUT"
        if item.messageType == Enum.MessageType.MessageError then
            level = "ERR"
            addLogEntry(orcPane, item.message, "ERR")
        elseif item.messageType == Enum.MessageType.MessageWarning then
            level = "WARN"
        elseif item.messageType == Enum.MessageType.MessageInfo then
            level = "INFO"
        end
        addLogEntry(rbxPane, item.message, level)
    end
end)

addLogEntry(orcPane, "ORC Kernel active.", "INFO")
addLogEntry(rbxPane, "Roblox Engine Console active.", "INFO")

-- ==========================================
-- [12] TAB 5: ADVANCED SYSTEM & EXECUTOR SETTINGS
-- ==========================================
local pageSettings = Instance.new("ScrollingFrame")
pageSettings.Name = "Page_Settings"
pageSettings.Size = UDim2.new(1, 0, 1, 0)
pageSettings.BackgroundTransparency = 1
pageSettings.BorderSizePixel = 0
pageSettings.ScrollBarThickness = 4
pageSettings.ScrollBarImageColor3 = C_BLUE
pageSettings.AutomaticCanvasSize = Enum.AutomaticSize.Y
pageSettings.Visible = false
pageSettings.Parent = viewport
pages["Settings"] = pageSettings

local settsLayout = Instance.new("UIListLayout")
settsLayout.Padding = UDim.new(0, 10)
settsLayout.Parent = pageSettings

local function makeSectionHeader(title)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 24)
    lbl.BackgroundTransparency = 1
    lbl.Text = ":: " .. string.upper(title)
    lbl.TextColor3 = C_WHITE
    lbl.Font = FONT_TITLE
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = pageSettings
end

local function makeSettingCard(title, desc, rightElement)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -4, 0, 52)
    card.BackgroundColor3 = C_CARD
    card.BackgroundTransparency = 0.2
    card.Parent = pageSettings

    local cc = Instance.new("UICorner")
    cc.CornerRadius = UDim.new(0, 8)
    cc.Parent = card

    local cs = Instance.new("UIStroke")
    cs.Color = C_BORDER
    cs.Thickness = 1
    cs.Parent = card

    local tLbl = Instance.new("TextLabel")
    tLbl.Size = UDim2.new(0.60, 0, 0, 20)
    tLbl.Position = UDim2.new(0, 12, 0, 6)
    tLbl.BackgroundTransparency = 1
    tLbl.Text = title
    tLbl.TextColor3 = C_WHITE
    tLbl.Font = FONT_TITLE
    tLbl.TextSize = 12
    tLbl.TextXAlignment = Enum.TextXAlignment.Left
    tLbl.Parent = card

    local dLbl = Instance.new("TextLabel")
    dLbl.Size = UDim2.new(0.60, 0, 0, 16)
    dLbl.Position = UDim2.new(0, 12, 0, 27)
    dLbl.BackgroundTransparency = 1
    dLbl.Text = desc
    dLbl.TextColor3 = C_MUTED
    dLbl.Font = FONT_CODE
    dLbl.TextSize = 10
    dLbl.TextXAlignment = Enum.TextXAlignment.Left
    dLbl.Parent = card

    if rightElement then
        rightElement.Position = UDim2.new(1, -rightElement.Size.X.Offset - 12, 0.5, -rightElement.Size.Y.Offset / 2)
        rightElement.Parent = card
    end

    return card
end

-- iOS Style Smooth Pill Switch
local function makeSettingToggle(title, desc, defaultState, callback)
    local switchTrack = Instance.new("TextButton")
    switchTrack.Size = UDim2.new(0, 48, 0, 26)
    switchTrack.BackgroundColor3 = defaultState and C_WHITE or C_BLACK
    switchTrack.BorderSizePixel = 0
    switchTrack.Text = ""
    switchTrack.AutoButtonColor = false

    local stCorner = Instance.new("UICorner")
    stCorner.CornerRadius = UDim.new(1, 0)
    stCorner.Parent = switchTrack

    local stStroke = Instance.new("UIStroke")
    stStroke.Color = C_BORDER
    stStroke.Thickness = 1
    stStroke.Parent = switchTrack

    local thumb = Instance.new("Frame")
    thumb.Size = UDim2.new(0, 20, 0, 20)
    thumb.Position = defaultState and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
    thumb.BackgroundColor3 = defaultState and C_BLACK or C_MUTED
    thumb.BorderSizePixel = 0
    thumb.Parent = switchTrack

    local thCorner = Instance.new("UICorner")
    thCorner.CornerRadius = UDim.new(1, 0)
    thCorner.Parent = thumb

    local state = defaultState
    switchTrack.MouseButton1Click:Connect(function()
        state = not state
        local targetPos = state and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
        local targetTrackCol = state and C_WHITE or C_BLACK
        local targetThumbCol = state and C_BLACK or C_MUTED

        TweenService:Create(thumb, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = targetPos,
            BackgroundColor3 = targetThumbCol
        }):Play()

        TweenService:Create(switchTrack, TweenInfo.new(0.2), {
            BackgroundColor3 = targetTrackCol
        }):Play()

        callback(state)
    end)

    makeSettingCard(title, desc, switchTrack)
end

local function makeSettingInput(title, desc, placeholder, onApplied)
    local inBox = Instance.new("TextBox")
    inBox.Size = UDim2.new(0, 130, 0, 30)
    inBox.BackgroundColor3 = C_DARK
    inBox.TextColor3 = C_WHITE
    inBox.PlaceholderText = placeholder
    inBox.PlaceholderColor3 = C_SUBTLE
    inBox.Font = FONT_CODE
    inBox.TextSize = 11
    inBox.ClearTextOnFocus = false

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

    makeSettingCard(title, desc, inBox)
end

local function makeSettingAction(title, desc, btnText, onTrigger)
    local actBtn = Instance.new("TextButton")
    actBtn.Size = UDim2.new(0, 90, 0, 28)
    actBtn.BackgroundColor3 = C_BLUE_BG
    actBtn.TextColor3 = C_BLUE
    actBtn.Font = FONT_TITLE
    actBtn.TextSize = 10
    actBtn.Text = btnText

    local acCorner = Instance.new("UICorner")
    acCorner.CornerRadius = UDim.new(0, 6)
    acCorner.Parent = actBtn

    local acStroke = Instance.new("UIStroke")
    acStroke.Color = C_BLUE
    acStroke.Thickness = 1
    acStroke.Parent = actBtn

    actBtn.MouseButton1Click:Connect(onTrigger)
    makeSettingCard(title, desc, actBtn)
end

-- ==========================================
-- SETTINGS SECTIONS: APP & SYSTEM CONTROLS
-- ==========================================
makeSectionHeader("Application & Appearance")

makeSettingInput("Floating Logo Size", "Set bubble size (e.g. 40, 52, 64)", "Default: 48", function(val)
    local num = tonumber(val)
    if num and num >= 30 and num <= 100 then
        floatingBubble.Size = UDim2.new(0, num, 0, num)
        headerStatus.Text = "BUBBLE RESIZED: " .. tostring(num) .. "px"
    end
end)

makeSettingInput("Custom Logo URL", "Fetch external icon to floating bubble", "PNG URL...", function(url)
    task.spawn(function()
        pcall(function()
            local imgData = nil
            if game.HttpGet then imgData = game:HttpGet(url, true) end
            if imgData and writefile and getcustomasset then
                writefile("workspace/custom_icon.png", imgData)
                floatingBubble.Image = getcustomasset("workspace/custom_icon.png")
                fbFallbackText.Visible = false
                headerStatus.Text = "LOGO UPDATED"
            end
        end)
    end)
end)

makeSettingInput("Header App Name", "Override UI identity title", "Custom Title...", function(name)
    headerTitle.Text = string.upper(name)
    headerStatus.Text = "TITLE UPDATED"
end)

makeSectionHeader("Engine & Sandbox Automation")

makeSettingToggle("Auto-Save on Execute", "Save running scripts to workspace automatically", true, function(enabled)
    getgenv().ORC_AutoSave = enabled
end)

makeSettingToggle("FPS Unlocker (240 FPS)", "Bypass 60 FPS mobile refresh limits", true, function(enabled)
    pcall(function()
        if setfpscap then setfpscap(enabled and 240 or 60) end
    end)
end)

makeSettingToggle("Anti-Idle Inactivity Guard", "Bypass 20-minute server disconnect timer", true, function(enabled)
    if enabled then
        player.Idled:Connect(function()
            VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
    end
end)

makeSectionHeader("Workspace & Storage Management")

makeSettingAction("Purge Logs Cache", "Clear all diagnostics from /sdcard/ORC/logs", "PURGE", function()
    pcall(function()
        if delfolder and makefolder then
            delfolder("logs")
            makefolder("logs")
            headerStatus.Text = "LOGS PURGED"
        end
    end)
end)

makeSettingAction("Re-index Storage", "Scan & refresh all workspace directory trees", "REINDEX", function()
    refreshSavedList()
    headerStatus.Text = "STORAGE RE-INDEXED"
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
            Position = UDim2.new(0, 3, 0, targetBtn.Position.Y.Offset + 7)
        }):Play()

        for name, btn in pairs(dockButtons) do
            if name ~= "Close" then
                if name == tabName then
                    TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundColor3 = C_BLUE_BG, ImageColor3 = C_WHITE }):Play()
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
        dockButtons["Executor"].BackgroundColor3 = C_BLUE_BG
        dockButtons["Executor"].ImageColor3 = C_WHITE
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

-- ==========================================
-- [12] STYLE PASS (polish layer: animations, hover, drag, layout fixes)
-- ==========================================
xpcall(function()
    local HOVER_STROKE = Color3.fromRGB(120, 120, 136)

    local function tween(obj, t, props, style, dir)
        local tw = TweenService:Create(obj, TweenInfo.new(t, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props)
        tw:Play()
        return tw
    end

    -- Window: soft vertical gradient + gradient border
    local wg = Instance.new("UIGradient")
    wg.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(196, 196, 202))
    wg.Rotation = 90
    wg.Parent = floatingWindow

    fwStroke.Color = Color3.fromRGB(96, 96, 110)
    fwStroke.Thickness = 1.2
    local fwg = Instance.new("UIGradient")
    fwg.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(70, 70, 78))
    fwg.Rotation = 120
    fwg.Parent = fwStroke

    rdStroke.Color = Color3.fromRGB(70, 70, 82)
    local dg = Instance.new("UIGradient")
    dg.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(190, 190, 196))
    dg.Rotation = 90
    dg.Parent = rightDock

    -- Header: fix mismatched corners (rounded top only) + faded divider
    header.Active = true
    header.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    header:FindFirstChildOfClass("UICorner").CornerRadius = UDim.new(0, 10)
    local fill = Instance.new("Frame")
    fill.Name = "HeaderFill"
    fill.Size = UDim2.new(1, 0, 0, 10)
    fill.Position = UDim2.new(0, 0, 1, -10)
    fill.BackgroundColor3 = header.BackgroundColor3
    fill.BorderSizePixel = 0
    fill.ZIndex = 1
    fill.Parent = header
    headerBottomBorder.ZIndex = 2
    headerBottomBorder.BackgroundColor3 = Color3.fromRGB(80, 80, 94)
    local dvg = Instance.new("UIGradient")
    dvg.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.1),
        NumberSequenceKeypoint.new(1, 1),
    })
    dvg.Parent = headerBottomBorder

    -- Terminal tab bar: the UIListLayout was overriding the "+" button position
    ttbLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ttbLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    local ttbPad = Instance.new("UIPadding")
    ttbPad.PaddingLeft = UDim.new(0, 4)
    ttbPad.Parent = terminalTabBar
    btnNewTerminal.LayoutOrder = 1000
    local tabOrder = 0

    -- Draggable window (header)
    local dragging, dragStart, startPos = false, nil, nil
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = floatingWindow.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            floatingWindow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)

    -- Open animation
    local winScale = Instance.new("UIScale")
    winScale.Parent = floatingWindow
    local function popIn()
        winScale.Scale = 0.94
        tween(winScale, 0.28, { Scale = 1 }, Enum.EasingStyle.Back)
    end
    container:GetPropertyChangedSignal("Visible"):Connect(function()
        if container.Visible then popIn() end
    end)
    popIn()

    -- Status text: flash then auto-reset to READY
    local statusToken = 0
    headerStatus:GetPropertyChangedSignal("Text"):Connect(function()
        if headerStatus.Text == "READY" then return end
        statusToken = statusToken + 1
        local mine = statusToken
        headerStatus.TextColor3 = C_WHITE
        tween(headerStatus, 2.5, { TextColor3 = C_SUBTLE })
        task.delay(3.5, function()
            if mine == statusToken then headerStatus.Text = "READY" end
        end)
    end)

    -- Buttons: hover (border lights up), press (shrink), no default roblox tint
    local function findStroke(b)
        local s = b:FindFirstChildOfClass("UIStroke")
        if s then return s end
        if b.BackgroundTransparency >= 1 and b.Parent then
            return b.Parent:FindFirstChildOfClass("UIStroke")
        end
        return nil
    end

    local function styleButton(btn)
        if btn.Name == "FullBackdrop" or btn:GetAttribute("OrcStyled") then return end
        btn:SetAttribute("OrcStyled", true)
        btn.AutoButtonColor = false

        if btn.Parent == terminalTabBar and btn ~= btnNewTerminal then
            tabOrder = tabOrder + 1
            btn.LayoutOrder = tabOrder
        end

        local sc
        if btn.BackgroundTransparency < 1 then
            sc = Instance.new("UIScale")
            sc.Parent = btn
        end
        local hovering, baseStroke, baseText, strokeObj = false, nil, nil, nil

        btn.MouseEnter:Connect(function()
            hovering = true
            strokeObj = findStroke(btn)
            if strokeObj then
                baseStroke = strokeObj.Color
                tween(strokeObj, 0.15, { Color = HOVER_STROKE })
            elseif btn:IsA("TextButton") and btn.BackgroundTransparency >= 1 then
                baseText = btn.TextColor3
                tween(btn, 0.15, { TextColor3 = C_WHITE })
            end
            if sc then tween(sc, 0.15, { Scale = 1.04 }) end
        end)
        btn.MouseLeave:Connect(function()
            hovering = false
            if strokeObj and baseStroke then tween(strokeObj, 0.2, { Color = baseStroke }) end
            if baseText and btn:IsA("TextButton") then tween(btn, 0.2, { TextColor3 = baseText }) end
            baseStroke, baseText = nil, nil
            if sc then tween(sc, 0.2, { Scale = 1 }) end
        end)
        btn.MouseButton1Down:Connect(function()
            if sc then tween(sc, 0.08, { Scale = 0.95 }) end
        end)
        btn.MouseButton1Up:Connect(function()
            if sc then tween(sc, 0.12, { Scale = hovering and 1.04 or 1 }, Enum.EasingStyle.Back) end
        end)
    end

    -- Text boxes: border lights up on focus, long code wraps instead of clipping
    local function styleBox(tb)
        if tb:GetAttribute("OrcStyled") then return end
        tb:SetAttribute("OrcStyled", true)
        if tb.MultiLine then tb.TextWrapped = true end
        local base, st
        tb.Focused:Connect(function()
            st = tb:FindFirstChildOfClass("UIStroke") or (tb.Parent and tb.Parent:FindFirstChildOfClass("UIStroke"))
            if st then
                base = st.Color
                tween(st, 0.15, { Color = C_WHITE })
            end
        end)
        tb.FocusLost:Connect(function()
            if st and base then tween(st, 0.2, { Color = base }) end
        end)
    end

    local function styleScroll(sf)
        sf.ScrollBarThickness = 3
        sf.ScrollBarImageTransparency = 0.55
    end

    local function apply(obj)
        if obj:IsA("TextButton") or obj:IsA("ImageButton") then
            styleButton(obj)
        elseif obj:IsA("TextBox") then
            styleBox(obj)
        elseif obj:IsA("ScrollingFrame") then
            styleScroll(obj)
        end
    end

    for _, d in ipairs(screenGui:GetDescendants()) do apply(d) end
    screenGui.DescendantAdded:Connect(function(d) task.defer(apply, d) end)
end, function(e)
    warn("[ORC] Style pass error: " .. tostring(e))
end)

print("[ORC] Titan Framework v9.0 Active.")
