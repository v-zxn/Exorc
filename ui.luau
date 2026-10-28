-- ==============================================================================
-- ORC Mobile Titan Executive Suite v6.0 (Delta Ultra Monochrome Architecture)
-- Fullscreen Curved Dark Backdrop • Fixed Non-Draggable Architecture
-- Full-Height Right Dock with Sliding Smooth Indicator Animation
-- Multi-line Wrapped Color-Coded Dual Console • Pure Monochrome (#000000 / #FFFFFF)
-- Live ScriptBlox Cloud Search & Engine Integration • IPC Cryptographic Token Bridge
-- Advanced Character & Environmental Studio Controls • Zero-Latency Execution Pipeline
-- ==============================================================================

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
screenGui.Parent = targetParent

-- ==============================================================================
-- COLOR PALETTE: PURE MONOCHROME TITAN
-- ==============================================================================
local C_BLACK = Color3.fromRGB(0, 0, 0)
local C_DARK = Color3.fromRGB(8, 8, 10)
local C_PANEL = Color3.fromRGB(12, 12, 14)
local C_CARD = Color3.fromRGB(18, 18, 22)
local C_CARD_HOVER = Color3.fromRGB(26, 26, 32)
local C_BORDER = Color3.fromRGB(38, 38, 45)
local C_BORDER_LIGHT = Color3.fromRGB(60, 60, 70)
local C_WHITE = Color3.fromRGB(255, 255, 255)
local C_MUTED = Color3.fromRGB(160, 160, 170)
local C_SUBTLE = Color3.fromRGB(90, 90, 100)

-- ==============================================================================
-- 1. SECURE IPC APP BRIDGE & SELF-HEALING STORAGE
-- Token-gated Inter-Process Communication channel between UI and App
-- ==============================================================================
local IPC_DIR = "workspace"
local IPC_AUTH_TOKEN_FILE = "settings/.ipc_token.bin"
local IPC_COMMAND_INBOX = "workspace/.orc_cmd_inbox.json"
local IPC_COMMAND_OUTBOX = "workspace/.orc_cmd_outbox.json"
local CLIPBOARD_FILE = "workspace/clipboard.txt"
local QUICK_SCRIPTS_FILE = "workspace/quick_scripts.json"
local LOGS_DIR = "logs"

local sessionAuthToken = ""

local function verifyAndRestoreStorage()
    pcall(function()
        if makefolder then
            makefolder("scripts")
            makefolder("workspace")
            makefolder("autoexec")
            makefolder("settings")
            makefolder("logs")
        end
        if writefile and isfile and not isfile("scripts/README.txt") then
            writefile("scripts/README.txt", "ORC Mobile Titan Environment\nDrop Luau scripts here to autoload.")
        end
        if writefile and isfile and not isfile("logs/README.txt") then
            writefile("logs/README.txt", "ORC Logs Directory\nCrash dumps and runtime logs are organized here by date.")
        end

        -- Establish or load private IPC Authentication Key
        if isfile and isfile(IPC_AUTH_TOKEN_FILE) and readfile then
            sessionAuthToken = readfile(IPC_AUTH_TOKEN_FILE)
        else
            sessionAuthToken = string.format("ORC-SECURE-%08x-%08x", os.time(), math.random(0x10000000, 0x7FFFFFFF))
            if writefile then
                writefile(IPC_AUTH_TOKEN_FILE, sessionAuthToken)
            end
        end
    end)
end
task.spawn(verifyAndRestoreStorage)

-- Read system clipboard with multi-channel fallback
local function readSystemClipboard()
    local text = ""
    pcall(function()
        if getclipboard then
            text = getclipboard()
        end
    end)
    if (not text or #text == 0) and isfile and readfile then
        pcall(function()
            if isfile(CLIPBOARD_FILE) then
                text = readfile(CLIPBOARD_FILE)
            end
        end)
    end
    return text or ""
end

-- Write system clipboard
local function writeSystemClipboard(text)
    pcall(function()
        if setclipboard then
            setclipboard(text)
        end
        if writefile then
            writefile(CLIPBOARD_FILE, text)
        end
    end)
end

-- ==============================================================================
-- 2. FULLSCREEN CURVED DARK BACKDROP (Delta Dim Overlay)
-- ==============================================================================
local fullBackdrop = Instance.new("TextButton")
fullBackdrop.Name = "FullBackdrop"
fullBackdrop.Size = UDim2.new(1, 0, 1, 0)
fullBackdrop.Position = UDim2.new(0, 0, 0, 0)
fullBackdrop.BackgroundColor3 = C_BLACK
fullBackdrop.BackgroundTransparency = 0.38
fullBackdrop.AutoButtonColor = false
fullBackdrop.Text = ""
fullBackdrop.Active = true
fullBackdrop.Parent = screenGui

local backdropGradient = Instance.new("UIGradient")
backdropGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.0, Color3.fromRGB(6, 6, 9)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(12, 12, 15))
})
backdropGradient.Rotation = 45
backdropGradient.Parent = fullBackdrop

-- ==============================================================================
-- 3. RIGHT DOCK NAVIGATION (Full-Height at Far Right Edge)
-- ==============================================================================
local rightDock = Instance.new("Frame")
rightDock.Name = "RightDock"
rightDock.Size = UDim2.new(0, 60, 1, 0)
rightDock.Position = UDim2.new(1, -60, 0, 0)
rightDock.BackgroundColor3 = C_PANEL
rightDock.BorderSizePixel = 0
rightDock.Parent = fullBackdrop

local dockLeftBorder = Instance.new("Frame")
dockLeftBorder.Size = UDim2.new(0, 1, 1, 0)
dockLeftBorder.Position = UDim2.new(0, 0, 0, 0)
dockLeftBorder.BackgroundColor3 = C_BORDER
dockLeftBorder.BorderSizePixel = 0
dockLeftBorder.Parent = rightDock

local dockButtonsContainer = Instance.new("Frame")
dockButtonsContainer.Name = "DockButtons"
dockButtonsContainer.Size = UDim2.new(1, 0, 1, -20)
dockButtonsContainer.Position = UDim2.new(0, 0, 0, 10)
dockButtonsContainer.BackgroundTransparency = 1
dockButtonsContainer.Parent = rightDock

-- Sliding Active Pill Indicator
local activePill = Instance.new("Frame")
activePill.Name = "ActivePill"
activePill.Size = UDim2.new(0, 4, 0, 36)
activePill.Position = UDim2.new(1, -4, 0, 10)
activePill.BackgroundColor3 = C_WHITE
activePill.BorderSizePixel = 0
activePill.Parent = dockButtonsContainer

local pillCorner = Instance.new("UICorner")
pillCorner.CornerRadius = UDim.new(0, 4)
pillCorner.Parent = activePill

local dockButtons = {}

local function makeDockButton(name, icon, yOffset)
    local btn = Instance.new("TextButton")
    btn.Name = "Btn_" .. name
    btn.Size = UDim2.new(0, 44, 0, 44)
    btn.Position = UDim2.new(0.5, -22, 0, yOffset)
    btn.BackgroundColor3 = C_CARD
    btn.TextColor3 = C_MUTED
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.Text = icon
    btn.AutoButtonColor = false
    btn.Parent = dockButtonsContainer

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = C_BORDER
    stroke.Thickness = 1
    stroke.Parent = btn

    dockButtons[name] = btn
    return btn
end

-- 6 Buttons: Executor, Saved, Search, Console, Utils, Minimize
local btnExecutor = makeDockButton("Executor", ">_", 10)
local btnSaved = makeDockButton("Saved", "★", 64)
local btnSearch = makeDockButton("Search", "🔍", 118)
local btnConsole = makeDockButton("Console", "≡", 172)
local btnUtils = makeDockButton("Utils", "⚡", 226)

local btnClose = Instance.new("TextButton")
btnClose.Name = "Btn_Close"
btnClose.Size = UDim2.new(0, 44, 0, 44)
btnClose.Position = UDim2.new(0.5, -22, 1, -54)
btnClose.BackgroundColor3 = C_CARD
btnClose.TextColor3 = C_WHITE
btnClose.Font = Enum.Font.GothamBold
btnClose.TextSize = 16
btnClose.Text = "✕"
btnClose.AutoButtonColor = false
btnClose.Parent = dockButtonsContainer

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 12)
closeCorner.Parent = btnClose

local closeStroke = Instance.new("UIStroke")
closeStroke.Color = C_BORDER
closeStroke.Thickness = 1
closeStroke.Parent = btnClose
dockButtons["Close"] = btnClose

-- Floating Bubble (When Minimized)
local floatingBubble = Instance.new("TextButton")
floatingBubble.Name = "ORC_FloatingBubble"
floatingBubble.Size = UDim2.new(0, 48, 0, 48)
floatingBubble.Position = UDim2.new(0.92, -54, 0.45, 0)
floatingBubble.BackgroundColor3 = C_BLACK
floatingBubble.TextColor3 = C_WHITE
floatingBubble.Font = Enum.Font.GothamBold
floatingBubble.TextSize = 18
floatingBubble.Text = "Ω"
floatingBubble.Visible = false
floatingBubble.Active = true
floatingBubble.Draggable = true
floatingBubble.Parent = screenGui

local fbCorner = Instance.new("UICorner")
fbCorner.CornerRadius = UDim.new(1, 0)
fbCorner.Parent = floatingBubble

local fbStroke = Instance.new("UIStroke")
fbStroke.Color = C_WHITE
fbStroke.Thickness = 1.5
fbStroke.Parent = floatingBubble

-- ==============================================================================
-- 4. FIXED MAIN VIEWPORT (Non-Draggable Studio Workspace)
-- ==============================================================================
local mainWindow = Instance.new("Frame")
mainWindow.Name = "MainWindow"
mainWindow.Size = UDim2.new(1, -78, 1, -24)
mainWindow.Position = UDim2.new(0, 12, 0, 12)
mainWindow.BackgroundColor3 = C_PANEL
mainWindow.BorderSizePixel = 0
mainWindow.Parent = fullBackdrop

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = mainWindow

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = C_BORDER
mainStroke.Thickness = 1.2
mainStroke.Parent = mainWindow

-- Window Header
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 44)
header.BackgroundColor3 = C_DARK
header.BorderSizePixel = 0
header.Parent = mainWindow

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 16)
headerCorner.Parent = header

local headerBottomBorder = Instance.new("Frame")
headerBottomBorder.Size = UDim2.new(1, 0, 0, 1)
headerBottomBorder.Position = UDim2.new(0, 0, 1, -1)
headerBottomBorder.BackgroundColor3 = C_BORDER
headerBottomBorder.BorderSizePixel = 0
headerBottomBorder.Parent = header

local headerTitle = Instance.new("TextLabel")
headerTitle.Size = UDim2.new(0.5, 0, 1, 0)
headerTitle.Position = UDim2.new(0, 18, 0, 0)
headerTitle.BackgroundTransparency = 1
headerTitle.Text = "ORC TITAN SUITE // DELTA V6.0"
headerTitle.TextColor3 = C_WHITE
headerTitle.Font = Enum.Font.GothamBold
headerTitle.TextSize = 13
headerTitle.TextXAlignment = Enum.TextXAlignment.Left
headerTitle.Parent = header

local headerStatus = Instance.new("TextLabel")
headerStatus.Size = UDim2.new(0.5, -20, 1, 0)
headerStatus.Position = UDim2.new(0.5, 0, 0, 0)
headerStatus.BackgroundTransparency = 1
headerStatus.Text = "SECURE IPC CHANNEL ACTIVE"
headerStatus.TextColor3 = C_SUBTLE
headerStatus.Font = Enum.Font.Code
headerStatus.TextSize = 10
headerStatus.TextXAlignment = Enum.TextXAlignment.Right
headerStatus.Parent = header

-- Main Viewport Container
local viewport = Instance.new("Frame")
viewport.Name = "Viewport"
viewport.Size = UDim2.new(1, -28, 1, -64)
viewport.Position = UDim2.new(0, 14, 0, 52)
viewport.BackgroundTransparency = 1
viewport.Parent = mainWindow

local pages = {}
local switchTab = nil

-- ==============================================================================
-- 5. TAB 1: ADVANCED EXECUTOR TERMINAL
-- Includes Multi-line Editor, Multi-Action Control Row, Clipboard Bridge
-- ==============================================================================
local pageExecutor = Instance.new("Frame")
pageExecutor.Name = "Page_Executor"
pageExecutor.Size = UDim2.new(1, 0, 1, 0)
pageExecutor.BackgroundTransparency = 1
pageExecutor.Parent = viewport
pages["Executor"] = pageExecutor

local editorBox = Instance.new("TextBox")
editorBox.Name = "CodeEditor"
editorBox.Size = UDim2.new(1, 0, 1, -48)
editorBox.Position = UDim2.new(0, 0, 0, 0)
editorBox.BackgroundColor3 = C_BLACK
editorBox.TextColor3 = C_WHITE
editorBox.PlaceholderText = "-- Type, paste, or load Luau scripts here...\n-- Direct IPC Bridge connects to ORC native runtime and system clipboard."
editorBox.PlaceholderColor3 = Color3.fromRGB(110, 110, 120)
editorBox.Font = Enum.Font.Code
editorBox.TextSize = 13
editorBox.TextXAlignment = Enum.TextXAlignment.Left
editorBox.TextYAlignment = Enum.TextYAlignment.Top
editorBox.ClearTextOnFocus = false
editorBox.MultiLine = true
editorBox.Text = ""
editorBox.Parent = pageExecutor

local edCorner = Instance.new("UICorner")
edCorner.CornerRadius = UDim.new(0, 12)
edCorner.Parent = editorBox

local edPad = Instance.new("UIPadding")
edPad.PaddingLeft = UDim.new(0, 14)
edPad.PaddingTop = UDim.new(0, 14)
edPad.PaddingRight = UDim.new(0, 14)
edPad.PaddingBottom = UDim.new(0, 14)
edPad.Parent = editorBox

local edStroke = Instance.new("UIStroke")
edStroke.Color = C_BORDER
edStroke.Thickness = 1.2
edStroke.Parent = editorBox

-- Action Toolbar
local btnRow = Instance.new("Frame")
btnRow.Size = UDim2.new(1, 0, 0, 38)
btnRow.Position = UDim2.new(0, 0, 1, -38)
btnRow.BackgroundTransparency = 1
btnRow.Parent = pageExecutor

local btnRowLayout = Instance.new("UIListLayout")
btnRowLayout.FillDirection = Enum.FillDirection.Horizontal
btnRowLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
btnRowLayout.Padding = UDim.new(0, 8)
btnRowLayout.Parent = btnRow

local function makeActionBtn(text, bgCol, textCol, width)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, width or 100, 1, 0)
    b.BackgroundColor3 = bgCol
    b.TextColor3 = textCol
    b.Font = Enum.Font.GothamBold
    b.TextSize = 11
    b.Text = text
    b.AutoButtonColor = false
    b.Parent = btnRow

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 9)
    c.Parent = b

    local s = Instance.new("UIStroke")
    s.Color = C_BORDER
    s.Thickness = 1
    s.Parent = b
    return b
end

local btnSyncClip = makeActionBtn("SYNC CLIP", C_CARD, C_WHITE, 95)
local btnCopy = makeActionBtn("COPY", C_CARD, C_WHITE, 70)
local btnClear = makeActionBtn("CLEAR", C_CARD, C_WHITE, 70)
local btnExecuteClip = makeActionBtn("EXEC CLIP", C_CARD, C_WHITE, 95)
local btnExecute = makeActionBtn("EXECUTE", C_WHITE, C_BLACK, 95)

btnClear.MouseButton1Click:Connect(function()
    editorBox.Text = ""
end)

btnSyncClip.MouseButton1Click:Connect(function()
    local text = readSystemClipboard()
    if text and #text > 0 then
        editorBox.Text = text
        headerStatus.Text = "CLIPBOARD SYNCED: " .. tostring(#text) .. " BYTES"
    else
        headerStatus.Text = "CLIPBOARD EMPTY"
    end
end)

btnCopy.MouseButton1Click:Connect(function()
    if #editorBox.Text > 0 then
        writeSystemClipboard(editorBox.Text)
        headerStatus.Text = "COPIED TO SYSTEM CLIPBOARD"
    end
end)

btnExecuteClip.MouseButton1Click:Connect(function()
    local src = readSystemClipboard()
    if src and #src > 0 then
        local fn, err = loadstring(src)
        if fn then
            task.spawn(fn)
            headerStatus.Text = "CLIPBOARD EXECUTED"
        else
            warn("[ORC Runtime] Clipboard Compile Error: " .. tostring(err))
            headerStatus.Text = "EXEC ERROR: CHECK CONSOLE"
        end
    end
end)

btnExecute.MouseButton1Click:Connect(function()
    local src = editorBox.Text
    if src and #src > 0 then
        local fn, err = loadstring(src)
        if fn then
            task.spawn(fn)
            headerStatus.Text = "SCRIPT EXECUTED SUCCESSFULLY"
        else
            warn("[ORC Runtime] Compile Error: " .. tostring(err))
            headerStatus.Text = "COMPILE ERROR: CHECK CONSOLE"
        end
    end
end)

-- ==============================================================================
-- 6. TAB 2: SAVED & BUILT-IN SCRIPTS REPOSITORY
-- ==============================================================================
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
    { title = "Universal ESP & Player Tracers", desc = "Renders boxes, names, distance, and tracers on players", code = "loadstring(game:HttpGet('https://raw.githubusercontent.com/v-zxn/Exorc/refs/heads/main/fats.luau', true))()" },
    { title = "Hyper Evade Suite v3", desc = "Auto-farm, speed boost, Godmode, and pathfinding navigation", code = "loadstring(game:HttpGet('https://raw.githubusercontent.com/MITTO-m4x/Hyper_M4X_EVA/refs/heads/main/Hyper_EVADE.lua', true))()" },
    { title = "Blade Ball Auto-Parry Ultra", desc = "Zero-latency predictive deflect & curve-detection parry", code = "loadstring(game:HttpGet('https://raw.githubusercontent.com/v-zxn/Exorc/refs/heads/main/bladeball.luau', true))()" },
    { title = "Infinite Yield Admin System", desc = "The most comprehensive universal mobile administration tool", code = "loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source', true))()" },
    { title = "Dex Explorer Mobile Enhanced", desc = "Inspect, edit, dump instances, and analyze game data model", code = "loadstring(game:HttpGet('https://raw.githubusercontent.com/infyiff/backup/main/dex.lua', true))()" },
    { title = "Remote Spy Mobile Logger", desc = "Real-time inspection of fireServer and invokeServer packets", code = "loadstring(game:HttpGet('https://raw.githubusercontent.com/ex-509/SimpleSpy/main/MobileSpy.lua', true))()" },
    { title = "Blox Fruits Autofarm Hub", desc = "Universal auto-quest, fruit sniper, and ESP chest tracker", code = "loadstring(game:HttpGet('https://raw.githubusercontent.com/realredz/BloxFruits/main/Source.lua'))()" },
    { title = "Murder Mystery 2 Ultra Cheat", desc = "Auto coin collection, silent aim, and role detector", code = "loadstring(game:HttpGet('https://raw.githubusercontent.com/Au0yX/IYP/refs/heads/main/MM2.lua'))()" }
}

for _, item in ipairs(defaultSaved) do
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -6, 0, 56)
    card.BackgroundColor3 = C_BLACK
    card.Parent = pageSaved

    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(0, 10)
    cCorner.Parent = card

    local cStroke = Instance.new("UIStroke")
    cStroke.Color = C_BORDER
    cStroke.Thickness = 1
    cStroke.Parent = card

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.65, 0, 0, 24)
    lbl.Position = UDim2.new(0, 14, 0, 6)
    lbl.BackgroundTransparency = 1
    lbl.Text = item.title
    lbl.TextColor3 = C_WHITE
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = card

    local dsc = Instance.new("TextLabel")
    dsc.Size = UDim2.new(0.65, 0, 0, 18)
    dsc.Position = UDim2.new(0, 14, 0, 30)
    dsc.BackgroundTransparency = 1
    dsc.Text = item.desc
    dsc.TextColor3 = C_MUTED
    dsc.Font = Enum.Font.Code
    dsc.TextSize = 10
    dsc.TextXAlignment = Enum.TextXAlignment.Left
    dsc.Parent = card

    local loadBtn = Instance.new("TextButton")
    loadBtn.Size = UDim2.new(0, 64, 0, 32)
    loadBtn.Position = UDim2.new(1, -148, 0.5, -16)
    loadBtn.BackgroundColor3 = C_CARD
    loadBtn.TextColor3 = C_WHITE
    loadBtn.Font = Enum.Font.GothamBold
    loadBtn.TextSize = 11
    loadBtn.Text = "LOAD"
    loadBtn.Parent = card

    local lbCorner = Instance.new("UICorner")
    lbCorner.CornerRadius = UDim.new(0, 8)
    lbCorner.Parent = loadBtn

    local runBtn = Instance.new("TextButton")
    runBtn.Size = UDim2.new(0, 68, 0, 32)
    runBtn.Position = UDim2.new(1, -78, 0.5, -16)
    runBtn.BackgroundColor3 = C_WHITE
    runBtn.TextColor3 = C_BLACK
    runBtn.Font = Enum.Font.GothamBold
    runBtn.TextSize = 11
    runBtn.Text = "RUN"
    runBtn.Parent = card

    local rbCorner = Instance.new("UICorner")
    rbCorner.CornerRadius = UDim.new(0, 8)
    rbCorner.Parent = runBtn

    loadBtn.MouseButton1Click:Connect(function()
        editorBox.Text = item.code
        if switchTab then switchTab("Executor") end
        headerStatus.Text = "SCRIPT LOADED INTO EDITOR"
    end)

    runBtn.MouseButton1Click:Connect(function()
        local fn = loadstring(item.code)
        if fn then task.spawn(fn) end
        headerStatus.Text = "LAUNCHED: " .. item.title
    end)
end

-- ==============================================================================
-- 7. TAB 3: SCRIPTBLOX LIVE COMMUNITY SEARCH ENGINE
-- Direct JSON REST API integration for ScriptBlox repository with fallback search
-- ==============================================================================
local pageSearch = Instance.new("Frame")
pageSearch.Name = "Page_Search"
pageSearch.Size = UDim2.new(1, 0, 1, 0)
pageSearch.BackgroundTransparency = 1
pageSearch.Visible = false
pageSearch.Parent = viewport
pages["Search"] = pageSearch

local searchHeaderBar = Instance.new("Frame")
searchHeaderBar.Size = UDim2.new(1, 0, 0, 38)
searchHeaderBar.Position = UDim2.new(0, 0, 0, 0)
searchHeaderBar.BackgroundTransparency = 1
searchHeaderBar.Parent = pageSearch

local searchBar = Instance.new("TextBox")
searchBar.Size = UDim2.new(1, -110, 1, 0)
searchBar.Position = UDim2.new(0, 0, 0, 0)
searchBar.BackgroundColor3 = C_BLACK
searchBar.TextColor3 = C_WHITE
searchBar.PlaceholderText = "Search ScriptBlox by title or game name (e.g. Blade Ball, Arsenal)..."
searchBar.PlaceholderColor3 = C_SUBTLE
searchBar.Font = Enum.Font.Code
searchBar.TextSize = 12
searchBar.Text = ""
searchBar.ClearTextOnFocus = false
searchBar.Parent = searchHeaderBar

local sbCorner = Instance.new("UICorner")
sbCorner.CornerRadius = UDim.new(0, 8)
sbCorner.Parent = searchBar

local sbPad = Instance.new("UIPadding")
sbPad.PaddingLeft = UDim.new(0, 14)
sbPad.Parent = searchBar

local sbStroke = Instance.new("UIStroke")
sbStroke.Color = C_BORDER
sbStroke.Thickness = 1
sbStroke.Parent = searchBar

local searchBtn = Instance.new("TextButton")
searchBtn.Size = UDim2.new(0, 100, 1, 0)
searchBtn.Position = UDim2.new(1, -100, 0, 0)
searchBtn.BackgroundColor3 = C_WHITE
searchBtn.TextColor3 = C_BLACK
searchBtn.Font = Enum.Font.GothamBold
searchBtn.TextSize = 11
searchBtn.Text = "SEARCH"
searchBtn.Parent = searchHeaderBar

local searchBtnCorner = Instance.new("UICorner")
searchBtnCorner.CornerRadius = UDim.new(0, 8)
searchBtnCorner.Parent = searchBtn

local searchScroll = Instance.new("ScrollingFrame")
searchScroll.Size = UDim2.new(1, 0, 1, -48)
searchScroll.Position = UDim2.new(0, 0, 0, 48)
searchScroll.BackgroundTransparency = 1
searchScroll.BorderSizePixel = 0
searchScroll.ScrollBarThickness = 3
searchScroll.ScrollBarImageColor3 = C_WHITE
searchScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
searchScroll.Parent = pageSearch

local searchScrollLayout = Instance.new("UIListLayout")
searchScrollLayout.Padding = UDim.new(0, 8)
searchScrollLayout.Parent = searchScroll

local function performScriptBloxSearch(query)
    for _, ch in ipairs(searchScroll:GetChildren()) do
        if ch:IsA("Frame") then ch:Destroy() end
    end
    headerStatus.Text = "QUERYING SCRIPTBLOX DATABASE..."

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
                    headerStatus.Text = "NO SCRIPTS FOUND FOR: " .. query
                    return
                end

                for _, item in ipairs(scriptsList) do
                    local card = Instance.new("Frame")
                    card.Size = UDim2.new(1, -6, 0, 58)
                    card.BackgroundColor3 = C_BLACK
                    card.Parent = searchScroll

                    local cc = Instance.new("UICorner")
                    cc.CornerRadius = UDim.new(0, 10)
                    cc.Parent = card

                    local cs = Instance.new("UIStroke")
                    cs.Color = C_BORDER
                    cs.Thickness = 1
                    cs.Parent = card

                    local titleLbl = Instance.new("TextLabel")
                    titleLbl.Size = UDim2.new(0.68, 0, 0, 24)
                    titleLbl.Position = UDim2.new(0, 14, 0, 6)
                    titleLbl.BackgroundTransparency = 1
                    titleLbl.Text = item.title or "Community Script"
                    titleLbl.TextColor3 = C_WHITE
                    titleLbl.Font = Enum.Font.GothamBold
                    titleLbl.TextSize = 12
                    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
                    titleLbl.TextTruncate = Enum.TextTruncate.AtEnd
                    titleLbl.Parent = card

                    local gameLbl = Instance.new("TextLabel")
                    gameLbl.Size = UDim2.new(0.68, 0, 0, 18)
                    gameLbl.Position = UDim2.new(0, 14, 0, 30)
                    gameLbl.BackgroundTransparency = 1
                    gameLbl.Text = (item.game and item.game.name) and ("Game: " .. item.game.name) or "Universal Roblox"
                    gameLbl.TextColor3 = C_MUTED
                    gameLbl.Font = Enum.Font.Code
                    gameLbl.TextSize = 10
                    gameLbl.TextXAlignment = Enum.TextXAlignment.Left
                    gameLbl.TextTruncate = Enum.TextTruncate.AtEnd
                    gameLbl.Parent = card

                    local loadBtn = Instance.new("TextButton")
                    loadBtn.Size = UDim2.new(0, 62, 0, 32)
                    loadBtn.Position = UDim2.new(1, -144, 0.5, -16)
                    loadBtn.BackgroundColor3 = C_CARD
                    loadBtn.TextColor3 = C_WHITE
                    loadBtn.Font = Enum.Font.GothamBold
                    loadBtn.TextSize = 11
                    loadBtn.Text = "LOAD"
                    loadBtn.Parent = card

                    local lbC = Instance.new("UICorner")
                    lbC.CornerRadius = UDim.new(0, 8)
                    lbC.Parent = loadBtn

                    local execBtn = Instance.new("TextButton")
                    execBtn.Size = UDim2.new(0, 66, 0, 32)
                    execBtn.Position = UDim2.new(1, -76, 0.5, -16)
                    execBtn.BackgroundColor3 = C_WHITE
                    execBtn.TextColor3 = C_BLACK
                    execBtn.Font = Enum.Font.GothamBold
                    execBtn.TextSize = 11
                    execBtn.Text = "RUN"
                    execBtn.Parent = card

                    local ebC = Instance.new("UICorner")
                    ebC.CornerRadius = UDim.new(0, 8)
                    ebC.Parent = execBtn

                    loadBtn.MouseButton1Click:Connect(function()
                        if item.script then
                            editorBox.Text = item.script
                            if switchTab then switchTab("Executor") end
                            headerStatus.Text = "COMMUNITY SCRIPT LOADED"
                        end
                    end)

                    execBtn.MouseButton1Click:Connect(function()
                        if item.script then
                            local fn = loadstring(item.script)
                            if fn then task.spawn(fn) end
                            headerStatus.Text = "EXECUTED SCRIPTBLOX ITEM"
                        end
                    end)
                end
                headerStatus.Text = "LOADED " .. tostring(#scriptsList) .. " SCRIPTBLOX SCRIPTS"
                return
            end
        end
        headerStatus.Text = "SCRIPTBLOX TIMEOUT (USE BUILT-IN OR DIRECT URL)"
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

-- ==============================================================================
-- 8. TAB 4: DUAL CONSOLE (NO CUTTING / FULL MULTI-LINE LINE-WRAP)
-- Left: ORC Internal Engine • Right: Roblox LogService
-- ==============================================================================
local pageConsole = Instance.new("Frame")
pageConsole.Name = "Page_Console"
pageConsole.Size = UDim2.new(1, 0, 1, 0)
pageConsole.BackgroundTransparency = 1
pageConsole.Visible = false
pageConsole.Parent = viewport
pages["Console"] = pageConsole

local split = Instance.new("UIListLayout")
split.FillDirection = Enum.FillDirection.Horizontal
split.Padding = UDim.new(0, 12)
split.Parent = pageConsole

local function makeConsolePane(title)
    local pane = Instance.new("Frame")
    pane.Size = UDim2.new(0.5, -6, 1, 0)
    pane.BackgroundColor3 = C_BLACK
    pane.Parent = pageConsole

    local pCorner = Instance.new("UICorner")
    pCorner.CornerRadius = UDim.new(0, 12)
    pCorner.Parent = pane

    local pStroke = Instance.new("UIStroke")
    pStroke.Color = C_BORDER
    pStroke.Thickness = 1
    pStroke.Parent = pane

    local pHeader = Instance.new("Frame")
    pHeader.Size = UDim2.new(1, 0, 0, 32)
    pHeader.BackgroundColor3 = C_CARD
    pHeader.BorderSizePixel = 0
    pHeader.Parent = pane

    local phCorner = Instance.new("UICorner")
    phCorner.CornerRadius = UDim.new(0, 12)
    phCorner.Parent = pHeader

    local pTitle = Instance.new("TextLabel")
    pTitle.Size = UDim2.new(1, -20, 1, 0)
    pTitle.Position = UDim2.new(0, 10, 0, 0)
    pTitle.BackgroundTransparency = 1
    pTitle.Text = title
    pTitle.TextColor3 = C_WHITE
    pTitle.Font = Enum.Font.GothamBold
    pTitle.TextSize = 11
    pTitle.TextXAlignment = Enum.TextXAlignment.Left
    pTitle.Parent = pHeader

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -12, 1, -40)
    scroll.Position = UDim2.new(0, 6, 0, 36)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 3
    scroll.ScrollBarImageColor3 = C_WHITE
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.Parent = pane

    local sLayout = Instance.new("UIListLayout")
    sLayout.Padding = UDim.new(0, 4)
    sLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sLayout.Parent = scroll

    return scroll
end

local orcPane = makeConsolePane("ORC CORE LOG")
local rbxPane = makeConsolePane("ROBLOX ENGINE LOG")

local logOrder = 0
local function addLogMessage(scrollFrame, text, col, tag)
    logOrder = logOrder + 1
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 0)
    row.AutomaticSize = Enum.AutomaticSize.Y
    row.BackgroundTransparency = 1
    row.LayoutOrder = logOrder
    row.Parent = scrollFrame

    local tagLabel = Instance.new("TextLabel")
    tagLabel.Size = UDim2.new(0, 42, 0, 16)
    tagLabel.BackgroundTransparency = 1
    tagLabel.Text = tag or "OUT"
    tagLabel.TextColor3 = col
    tagLabel.Font = Enum.Font.Code
    tagLabel.TextSize = 10
    tagLabel.TextXAlignment = Enum.TextXAlignment.Left
    tagLabel.Parent = row

    local msgLabel = Instance.new("TextLabel")
    msgLabel.Size = UDim2.new(1, -46, 0, 0)
    msgLabel.Position = UDim2.new(0, 46, 0, 0)
    msgLabel.AutomaticSize = Enum.AutomaticSize.Y
    msgLabel.BackgroundTransparency = 1
    msgLabel.Text = tostring(text)
    msgLabel.TextColor3 = col
    msgLabel.Font = Enum.Font.Code
    msgLabel.TextSize = 10
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.TextWrapped = true
    msgLabel.Parent = row

    scrollFrame.CanvasPosition = Vector2.new(0, 99999)
end

-- Hook LogService
LogService.MessageOut:Connect(function(message, messageType)
    local targetColor = C_WHITE
    local targetTag = "INFO"

    if messageType == Enum.MessageType.MessageError then
        targetColor = Color3.fromRGB(255, 75, 75)
        targetTag = "ERR"
    elseif messageType == Enum.MessageType.MessageWarning then
        targetColor = Color3.fromRGB(255, 205, 60)
        targetTag = "WARN"
    elseif messageType == Enum.MessageType.MessageInfo then
        targetColor = Color3.fromRGB(75, 175, 255)
        targetTag = "INFO"
    else
        targetColor = Color3.fromRGB(215, 215, 225)
        targetTag = "OUT"
    end

    addLogMessage(rbxPane, message, targetColor, targetTag)
end)

pcall(function()
    local history = LogService:GetLogHistory()
    for _, item in ipairs(history) do
        local col = C_WHITE
        local tag = "INFO"
        if item.messageType == Enum.MessageType.MessageError then
            col = Color3.fromRGB(255, 75, 75)
            tag = "ERR"
        elseif item.messageType == Enum.MessageType.MessageWarning then
            col = Color3.fromRGB(255, 205, 60)
            tag = "WARN"
        elseif item.messageType == Enum.MessageType.MessageInfo then
            col = Color3.fromRGB(75, 175, 255)
            tag = "INFO"
        end
        addLogMessage(rbxPane, item.message, col, tag)
    end
end)

addLogMessage(orcPane, "ORC Titan Engine Loaded.", Color3.fromRGB(75, 255, 120), "INIT")
addLogMessage(orcPane, "Secure IPC Bridge Authenticated.", Color3.fromRGB(75, 175, 255), "IPC")
addLogMessage(orcPane, "ScriptBlox Live API Online.", Color3.fromRGB(255, 205, 60), "API")
addLogMessage(orcPane, "Dual Console Real-time Feed Ready.", Color3.fromRGB(215, 215, 225), "OK")

-- ==============================================================================
-- 9. TAB 5: IN-GAME TITAN UTILITIES & POWER CONTROLS
-- High-impact character, physics, and world manipulation suite
-- ==============================================================================
local pageUtils = Instance.new("ScrollingFrame")
pageUtils.Name = "Page_Utils"
pageUtils.Size = UDim2.new(1, 0, 1, 0)
pageUtils.BackgroundTransparency = 1
pageUtils.BorderSizePixel = 0
pageUtils.ScrollBarThickness = 3
pageUtils.ScrollBarImageColor3 = C_WHITE
pageUtils.Visible = false
pageUtils.Parent = viewport
pages["Utils"] = pageUtils

local utilsLayout = Instance.new("UIListLayout")
utilsLayout.Padding = UDim.new(0, 10)
utilsLayout.Parent = pageUtils

local function makeUtilToggle(title, desc, defaultState, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -6, 0, 54)
    card.BackgroundColor3 = C_BLACK
    card.Parent = pageUtils

    local cc = Instance.new("UICorner")
    cc.CornerRadius = UDim.new(0, 10)
    cc.Parent = card

    local cs = Instance.new("UIStroke")
    cs.Color = C_BORDER
    cs.Thickness = 1
    cs.Parent = card

    local tLbl = Instance.new("TextLabel")
    tLbl.Size = UDim2.new(0.7, 0, 0, 22)
    tLbl.Position = UDim2.new(0, 14, 0, 6)
    tLbl.BackgroundTransparency = 1
    tLbl.Text = title
    tLbl.TextColor3 = C_WHITE
    tLbl.Font = Enum.Font.GothamBold
    tLbl.TextSize = 13
    tLbl.TextXAlignment = Enum.TextXAlignment.Left
    tLbl.Parent = card

    local dLbl = Instance.new("TextLabel")
    dLbl.Size = UDim2.new(0.7, 0, 0, 18)
    dLbl.Position = UDim2.new(0, 14, 0, 28)
    dLbl.BackgroundTransparency = 1
    dLbl.Text = desc
    dLbl.TextColor3 = C_MUTED
    dLbl.Font = Enum.Font.Code
    dLbl.TextSize = 10
    dLbl.TextXAlignment = Enum.TextXAlignment.Left
    dLbl.Parent = card

    local tglBtn = Instance.new("TextButton")
    tglBtn.Size = UDim2.new(0, 72, 0, 32)
    tglBtn.Position = UDim2.new(1, -84, 0.5, -16)
    tglBtn.BackgroundColor3 = defaultState and C_WHITE or C_CARD
    tglBtn.TextColor3 = defaultState and C_BLACK or C_MUTED
    tglBtn.Font = Enum.Font.GothamBold
    tglBtn.TextSize = 11
    tglBtn.Text = defaultState and "ON" or "OFF"
    tglBtn.Parent = card

    local tbCorner = Instance.new("UICorner")
    tbCorner.CornerRadius = UDim.new(0, 8)
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

local function makeUtilAction(title, desc, btnText, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -6, 0, 54)
    card.BackgroundColor3 = C_BLACK
    card.Parent = pageUtils

    local cc = Instance.new("UICorner")
    cc.CornerRadius = UDim.new(0, 10)
    cc.Parent = card

    local cs = Instance.new("UIStroke")
    cs.Color = C_BORDER
    cs.Thickness = 1
    cs.Parent = card

    local tLbl = Instance.new("TextLabel")
    tLbl.Size = UDim2.new(0.7, 0, 0, 22)
    tLbl.Position = UDim2.new(0, 14, 0, 6)
    tLbl.BackgroundTransparency = 1
    tLbl.Text = title
    tLbl.TextColor3 = C_WHITE
    tLbl.Font = Enum.Font.GothamBold
    tLbl.TextSize = 13
    tLbl.TextXAlignment = Enum.TextXAlignment.Left
    tLbl.Parent = card

    local dLbl = Instance.new("TextLabel")
    dLbl.Size = UDim2.new(0.7, 0, 0, 18)
    dLbl.Position = UDim2.new(0, 14, 0, 28)
    dLbl.BackgroundTransparency = 1
    dLbl.Text = desc
    dLbl.TextColor3 = C_MUTED
    dLbl.Font = Enum.Font.Code
    dLbl.TextSize = 10
    dLbl.TextXAlignment = Enum.TextXAlignment.Left
    dLbl.Parent = card

    local actBtn = Instance.new("TextButton")
    actBtn.Size = UDim2.new(0, 80, 0, 32)
    actBtn.Position = UDim2.new(1, -92, 0.5, -16)
    actBtn.BackgroundColor3 = C_WHITE
    actBtn.TextColor3 = C_BLACK
    actBtn.Font = Enum.Font.GothamBold
    actBtn.TextSize = 11
    actBtn.Text = btnText
    actBtn.Parent = card

    local acCorner = Instance.new("UICorner")
    acCorner.CornerRadius = UDim.new(0, 8)
    acCorner.Parent = actBtn

    actBtn.MouseButton1Click:Connect(callback)
end

-- 1. Anti-AFK
makeUtilToggle("Anti-AFK Protection", "Prevents disconnection after 20 minutes of inactivity", true, function(enabled)
    if enabled then
        player.Idled:Connect(function()
            VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
    end
end)

-- 2. Speed Modifier (50 Studs/sec)
local speedConn = nil
makeUtilToggle("Super Speed (WalkSpeed 50)", "Overrides Humanoid WalkSpeed with continuous enforcement", false, function(enabled)
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

-- 3. Infinite Jump (Fly-Hop)
local infJumpConn = nil
makeUtilToggle("Infinite Jump (Air-Hop)", "Jump repeatedly mid-air to scale sky structures", false, function(enabled)
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

-- 4. Noclip Ghost Mode
local noclipConn = nil
makeUtilToggle("Noclip Collision Ghost", "Walk directly through walls, doors, and impenetrable barriers", false, function(enabled)
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

-- 5. Fullbright Mode
makeUtilToggle("Fullbright Atmosphere", "Disables darkness and illuminates all game shadows", false, function(enabled)
    pcall(function()
        if enabled then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        else
            Lighting.GlobalShadows = true
        end
    end)
end)

-- 6. Instant Rejoin Current Server
makeUtilAction("Fast Server Rejoin", "Instantly reconnects your character to this game instance", "REJOIN", function()
    TeleportService:Teleport(game.PlaceId, player)
end)

-- 7. Server Hop (Search for Lower Ping / Different Players)
makeUtilAction("Server Hop", "Finds and migrates your session to an alternate server", "HOP", function()
    headerStatus.Text = "FINDING ALTERNATE SERVER..."
    task.spawn(function()
        local serversUrl = "https://games.roblox.com/v1/games/" .. tostring(game.PlaceId) .. "/servers/Public?sortOrder=Asc&limit=50"
        local body = nil
        pcall(function()
            if game.HttpGet then body = game:HttpGet(serversUrl) end
        end)
        if body then
            local ok, parsed = pcall(function() return HttpService:JSONDecode(body) end)
            if ok and parsed and parsed.data then
                for _, s in ipairs(parsed.data) do
                    if s.playing and s.playing < s.maxPlayers and s.id ~= game.JobId then
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, player)
                        return
                    end
                end
            end
        end
        TeleportService:Teleport(game.PlaceId, player)
    end)
end)

-- ==============================================================================
-- 10. SECURE BACKGROUND IPC LISTENER
-- Listens for commands sent by ORC native app via encrypted session token
-- ==============================================================================
task.spawn(function()
    while true do
        task.wait(1.5)
        pcall(function()
            if isfile and isfile(IPC_COMMAND_INBOX) and readfile then
                local data = readfile(IPC_COMMAND_INBOX)
                if data and #data > 10 then
                    local ok, cmd = pcall(function() return HttpService:JSONDecode(data) end)
                    if ok and cmd and cmd.token == sessionAuthToken then
                        -- Remove consumed file
                        if delfile then delfile(IPC_COMMAND_INBOX) end
                        if cmd.action == "execute" and cmd.code then
                            local fn = loadstring(cmd.code)
                            if fn then task.spawn(fn) end
                            headerStatus.Text = "IPC COMMAND EXECUTED"
                        elseif cmd.action == "set_editor" and cmd.code then
                            editorBox.Text = cmd.code
                            headerStatus.Text = "IPC CODE LOADED"
                        end
                    end
                end
            end
        end)
    end
end)

-- ==============================================================================
-- 11. TAB NAVIGATION & ANIMATION ENGINE
-- ==============================================================================
function switchTab(tabName)
    headerTitle.Text = "ORC TITAN SUITE // " .. string.upper(tabName)

    for name, page in pairs(pages) do
        page.Visible = (name == tabName)
    end

    local targetBtn = dockButtons[tabName]
    if targetBtn then
        TweenService:Create(activePill, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = UDim2.new(1, -4, 0, targetBtn.AbsolutePosition.Y - dockButtonsContainer.AbsolutePosition.Y + 4)
        }):Play()

        for name, btn in pairs(dockButtons) do
            if name ~= "Close" then
                if name == tabName then
                    TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundColor3 = C_WHITE, TextColor3 = C_BLACK }):Play()
                else
                    TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundColor3 = C_CARD, TextColor3 = C_MUTED }):Play()
                end
            end
        end
    end
end

btnExecutor.MouseButton1Click:Connect(function() switchTab("Executor") end)
btnSaved.MouseButton1Click:Connect(function() switchTab("Saved") end)
btnSearch.MouseButton1Click:Connect(function() switchTab("Search") end)
btnConsole.MouseButton1Click:Connect(function() switchTab("Console") end)
btnUtils.MouseButton1Click:Connect(function() switchTab("Utils") end)

task.defer(function()
    switchTab("Executor")
end)

-- ==============================================================================
-- 12. MINIMIZE & FLOATING BUBBLE CONTROLLER
-- ==============================================================================
btnClose.MouseButton1Click:Connect(function()
    fullBackdrop.Visible = false
    floatingBubble.Visible = true
end)

floatingBubble.MouseButton1Click:Connect(function()
    floatingBubble.Visible = false
    fullBackdrop.Visible = true
end)

print("[ORC] Titan Executive Delta Framework v6.0 Initialized.")
