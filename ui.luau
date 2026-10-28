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

local C_BLACK = Color3.fromRGB(0, 0, 0)
local C_DARK = Color3.fromRGB(6, 6, 8)
local C_PANEL = Color3.fromRGB(10, 10, 12)
local C_CARD = Color3.fromRGB(16, 16, 20)
local C_CARD_HOVER = Color3.fromRGB(24, 24, 30)
local C_BORDER = Color3.fromRGB(34, 34, 40)
local C_WHITE = Color3.fromRGB(255, 255, 255)
local C_MUTED = Color3.fromRGB(150, 150, 160)
local C_SUBTLE = Color3.fromRGB(80, 80, 90)

local SCRIPTS_DIR = "scripts"
local WORKSPACE_DIR = "workspace"
local AUTOEXEC_DIR = "autoexec"
local SETTINGS_DIR = "settings"
local LOGS_DIR = "logs"
local CLIPBOARD_FILE = "workspace/clipboard.txt"
local IPC_AUTH_TOKEN_FILE = "settings/.ipc_token.bin"
local IPC_COMMAND_INBOX = "workspace/.orc_cmd_inbox.json"

local sessionAuthToken = ""

local function verifyAndRestoreStorage()
    pcall(function()
        if makefolder then
            makefolder(SCRIPTS_DIR)
            makefolder(WORKSPACE_DIR)
            makefolder(AUTOEXEC_DIR)
            makefolder(SETTINGS_DIR)
            makefolder(LOGS_DIR)
        end
        if isfile and isfile(IPC_AUTH_TOKEN_FILE) and readfile then
            sessionAuthToken = readfile(IPC_AUTH_TOKEN_FILE)
        else
            sessionAuthToken = string.format("ORC-%08x-%08x", os.time(), math.random(0x10000000, 0x7FFFFFFF))
            if writefile then
                writefile(IPC_AUTH_TOKEN_FILE, sessionAuthToken)
            end
        end
    end)
end
task.spawn(verifyAndRestoreStorage)

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

local fullBackdrop = Instance.new("TextButton")
fullBackdrop.Name = "FullBackdrop"
fullBackdrop.Size = UDim2.new(1, 0, 1, 0)
fullBackdrop.Position = UDim2.new(0, 0, 0, 0)
fullBackdrop.BackgroundColor3 = C_BLACK
fullBackdrop.BackgroundTransparency = 0.35
fullBackdrop.AutoButtonColor = false
fullBackdrop.Text = ""
fullBackdrop.Active = true
fullBackdrop.BorderSizePixel = 0
fullBackdrop.Parent = screenGui

local backdropGradient = Instance.new("UIGradient")
backdropGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.0, Color3.fromRGB(4, 4, 6)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(8, 8, 12))
})
backdropGradient.Rotation = 45
backdropGradient.Parent = fullBackdrop

local rightDock = Instance.new("Frame")
rightDock.Name = "RightDock"
rightDock.Size = UDim2.new(0, 56, 1, 0)
rightDock.Position = UDim2.new(1, -56, 0, 0)
rightDock.BackgroundColor3 = C_PANEL
rightDock.BorderSizePixel = 0
rightDock.Parent = fullBackdrop

local dockLeftBorder = Instance.new("Frame")
dockLeftBorder.Size = UDim2.new(0, 1, 1, 0)
dockLeftBorder.Position = UDim2.new(0, 0, 0, 0)
dockLeftBorder.BackgroundColor3 = C_BORDER
dockLeftBorder.BorderSizePixel = 0
dockLeftBorder.Parent = rightDock

local logoFrame = Instance.new("Frame")
logoFrame.Size = UDim2.new(0, 42, 0, 42)
logoFrame.Position = UDim2.new(0.5, -21, 0, 8)
logoFrame.BackgroundColor3 = C_CARD
logoFrame.BorderSizePixel = 0
logoFrame.Parent = rightDock

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0, 10)
logoCorner.Parent = logoFrame

local logoStroke = Instance.new("UIStroke")
logoStroke.Color = C_BORDER
logoStroke.Thickness = 1
logoStroke.Parent = logoFrame

local logoImage = Instance.new("ImageLabel")
logoImage.Size = UDim2.new(1, -4, 1, -4)
logoImage.Position = UDim2.new(0, 2, 0, 2)
logoImage.BackgroundTransparency = 1
logoImage.Image = "https://raw.githubusercontent.com/v-zxn/Exorc/refs/heads/main/logo.png"
logoImage.ScaleType = Enum.ScaleType.Fit
logoImage.Parent = logoFrame

local logoFallback = Instance.new("TextLabel")
logoFallback.Size = UDim2.new(1, 0, 1, 0)
logoFallback.BackgroundTransparency = 1
logoFallback.Text = "ORC"
logoFallback.TextColor3 = C_WHITE
logoFallback.Font = Enum.Font.GothamBold
logoFallback.TextSize = 12
logoFallback.Parent = logoFrame

logoImage.Changed:Connect(function()
    if logoImage.IsLoaded then
        logoFallback.Visible = false
    end
end)

local dockButtonsContainer = Instance.new("Frame")
dockButtonsContainer.Name = "DockButtons"
dockButtonsContainer.Size = UDim2.new(1, 0, 1, -120)
dockButtonsContainer.Position = UDim2.new(0, 0, 0, 58)
dockButtonsContainer.BackgroundTransparency = 1
dockButtonsContainer.Parent = rightDock

local activePill = Instance.new("Frame")
activePill.Name = "ActivePill"
activePill.Size = UDim2.new(0, 4, 0, 36)
activePill.Position = UDim2.new(1, -4, 0, 6)
activePill.BackgroundColor3 = C_WHITE
activePill.BorderSizePixel = 0
activePill.Parent = dockButtonsContainer

local pillCorner = Instance.new("UICorner")
pillCorner.CornerRadius = UDim.new(0, 4)
pillCorner.Parent = activePill

local dockButtons = {}

local function makeDockButton(name, iconAsset, yOffset)
    local btn = Instance.new("ImageButton")
    btn.Name = "Btn_" .. name
    btn.Size = UDim2.new(0, 40, 0, 40)
    btn.Position = UDim2.new(0.5, -20, 0, yOffset)
    btn.BackgroundColor3 = C_CARD
    btn.Image = iconAsset
    btn.ImageColor3 = C_MUTED
    btn.ScaleType = Enum.ScaleType.Fit
    btn.AutoButtonColor = false
    btn.Parent = dockButtonsContainer

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
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

local ICONS = {
    Executor = "rbxassetid://10734950309",
    Saved = "rbxassetid://10709791437",
    Search = "rbxassetid://10734883502",
    Console = "rbxassetid://10734952047",
    Utils = "rbxassetid://10734953966",
    Close = "rbxassetid://10747384394"
}

local btnExecutor = makeDockButton("Executor", ICONS.Executor, 4)
local btnSaved = makeDockButton("Saved", ICONS.Saved, 52)
local btnSearch = makeDockButton("Search", ICONS.Search, 100)
local btnConsole = makeDockButton("Console", ICONS.Console, 148)
local btnUtils = makeDockButton("Utils", ICONS.Utils, 196)

local btnClose = Instance.new("ImageButton")
btnClose.Name = "Btn_Close"
btnClose.Size = UDim2.new(0, 40, 0, 40)
btnClose.Position = UDim2.new(0.5, -20, 1, -48)
btnClose.BackgroundColor3 = C_CARD
btnClose.Image = ICONS.Close
btnClose.ImageColor3 = C_WHITE
btnClose.ScaleType = Enum.ScaleType.Fit
btnClose.AutoButtonColor = false
btnClose.Parent = rightDock

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
closeCorner.Parent = btnClose

local closeStroke = Instance.new("UIStroke")
closeStroke.Color = C_BORDER
closeStroke.Thickness = 1
closeStroke.Parent = btnClose

local closePad = Instance.new("UIPadding")
closePad.PaddingTop = UDim.new(0, 10)
closePad.PaddingBottom = UDim.new(0, 10)
closePad.PaddingLeft = UDim.new(0, 10)
closePad.PaddingRight = UDim.new(0, 10)
closePad.Parent = btnClose
dockButtons["Close"] = btnClose

local floatingBubble = Instance.new("ImageButton")
floatingBubble.Name = "ORC_FloatingBubble"
floatingBubble.Size = UDim2.new(0, 46, 0, 46)
floatingBubble.Position = UDim2.new(1, -58, 0.45, 0)
floatingBubble.BackgroundColor3 = C_BLACK
floatingBubble.Image = "https://raw.githubusercontent.com/v-zxn/Exorc/refs/heads/main/logo.png"
floatingBubble.ScaleType = Enum.ScaleType.Fit
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

local mainWindow = Instance.new("Frame")
mainWindow.Name = "MainWindow"
mainWindow.Size = UDim2.new(1, -56, 1, 0)
mainWindow.Position = UDim2.new(0, 0, 0, 0)
mainWindow.BackgroundColor3 = C_PANEL
mainWindow.BorderSizePixel = 0
mainWindow.Parent = fullBackdrop

local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = C_DARK
header.BorderSizePixel = 0
header.Parent = mainWindow

local headerBottomBorder = Instance.new("Frame")
headerBottomBorder.Size = UDim2.new(1, 0, 0, 1)
headerBottomBorder.Position = UDim2.new(0, 0, 1, -1)
headerBottomBorder.BackgroundColor3 = C_BORDER
headerBottomBorder.BorderSizePixel = 0
headerBottomBorder.Parent = header

local headerTitle = Instance.new("TextLabel")
headerTitle.Size = UDim2.new(0.5, 0, 1, 0)
headerTitle.Position = UDim2.new(0, 16, 0, 0)
headerTitle.BackgroundTransparency = 1
headerTitle.Text = "ORC TITAN EXECUTOR"
headerTitle.TextColor3 = C_WHITE
headerTitle.Font = Enum.Font.GothamBold
headerTitle.TextSize = 13
headerTitle.TextXAlignment = Enum.TextXAlignment.Left
headerTitle.Parent = header

local headerStatus = Instance.new("TextLabel")
headerStatus.Size = UDim2.new(0.5, -16, 1, 0)
headerStatus.Position = UDim2.new(0.5, 0, 0, 0)
headerStatus.BackgroundTransparency = 1
headerStatus.Text = "READY"
headerStatus.TextColor3 = C_SUBTLE
headerStatus.Font = Enum.Font.Code
headerStatus.TextSize = 10
headerStatus.TextXAlignment = Enum.TextXAlignment.Right
headerStatus.Parent = header

local viewport = Instance.new("Frame")
viewport.Name = "Viewport"
viewport.Size = UDim2.new(1, -20, 1, -52)
viewport.Position = UDim2.new(0, 10, 0, 46)
viewport.BackgroundTransparency = 1
viewport.Parent = mainWindow

local pages = {}
local switchTab = nil

local pageExecutor = Instance.new("Frame")
pageExecutor.Name = "Page_Executor"
pageExecutor.Size = UDim2.new(1, 0, 1, 0)
pageExecutor.BackgroundTransparency = 1
pageExecutor.Parent = viewport
pages["Executor"] = pageExecutor

local editorScroll = Instance.new("ScrollingFrame")
editorScroll.Name = "EditorScroll"
editorScroll.Size = UDim2.new(1, 0, 1, -44)
editorScroll.Position = UDim2.new(0, 0, 0, 0)
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
editorBox.PlaceholderText = "-- Type or paste Luau script here..."
editorBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 110)
editorBox.Font = Enum.Font.Code
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
    b.Size = UDim2.new(0, width or 85, 1, 0)
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

    local s = Instance.new("UIStroke")
    s.Color = C_BORDER
    s.Thickness = 1
    s.Parent = b
    return b
end

local btnSaveAs = makeActionBtn("SAVE", C_CARD, C_WHITE, 70)
local btnSyncClip = makeActionBtn("PASTE", C_CARD, C_WHITE, 75)
local btnCopy = makeActionBtn("COPY", C_CARD, C_WHITE, 65)
local btnClear = makeActionBtn("CLEAR", C_CARD, C_WHITE, 65)
local btnExecute = makeActionBtn("EXECUTE", C_WHITE, C_BLACK, 95)

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
            headerStatus.Text = "ERROR"
        end
    end
end)

local pageSaved = Instance.new("Frame")
pageSaved.Name = "Page_Saved"
pageSaved.Size = UDim2.new(1, 0, 1, 0)
pageSaved.BackgroundTransparency = 1
pageSaved.Visible = false
pageSaved.Parent = viewport
pages["Saved"] = pageSaved

local savedTopBar = Instance.new("Frame")
savedTopBar.Size = UDim2.new(1, 0, 0, 36)
savedTopBar.Position = UDim2.new(0, 0, 0, 0)
savedTopBar.BackgroundTransparency = 1
savedTopBar.Parent = pageSaved

local newScriptName = Instance.new("TextBox")
newScriptName.Size = UDim2.new(1, -190, 1, 0)
newScriptName.BackgroundColor3 = C_BLACK
newScriptName.TextColor3 = C_WHITE
newScriptName.PlaceholderText = "Script name..."
newScriptName.PlaceholderColor3 = C_SUBTLE
newScriptName.Font = Enum.Font.Code
newScriptName.TextSize = 12
newScriptName.ClearTextOnFocus = false
newScriptName.Text = ""
newScriptName.Parent = savedTopBar

local nsnCorner = Instance.new("UICorner")
nsnCorner.CornerRadius = UDim.new(0, 8)
nsnCorner.Parent = newScriptName

local nsnPad = Instance.new("UIPadding")
nsnPad.PaddingLeft = UDim.new(0, 10)
nsnPad.Parent = newScriptName

local nsnStroke = Instance.new("UIStroke")
nsnStroke.Color = C_BORDER
nsnStroke.Thickness = 1
nsnStroke.Parent = newScriptName

local btnCreateScript = Instance.new("TextButton")
btnCreateScript.Size = UDim2.new(0, 95, 1, 0)
btnCreateScript.Position = UDim2.new(1, -182, 0, 0)
btnCreateScript.BackgroundColor3 = C_WHITE
btnCreateScript.TextColor3 = C_BLACK
btnCreateScript.Font = Enum.Font.GothamBold
btnCreateScript.TextSize = 11
btnCreateScript.Text = "SAVE EDITOR"
btnCreateScript.Parent = savedTopBar

local bcsCorner = Instance.new("UICorner")
bcsCorner.CornerRadius = UDim.new(0, 8)
bcsCorner.Parent = btnCreateScript

local btnRefreshSaved = Instance.new("TextButton")
btnRefreshSaved.Size = UDim2.new(0, 80, 1, 0)
btnRefreshSaved.Position = UDim2.new(1, -80, 0, 0)
btnRefreshSaved.BackgroundColor3 = C_CARD
btnRefreshSaved.TextColor3 = C_WHITE
btnRefreshSaved.Font = Enum.Font.GothamBold
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

local function refreshSavedList()
    for _, ch in ipairs(savedScroll:GetChildren()) do
        if ch:IsA("Frame") then ch:Destroy() end
    end

    local fileList = {}
    pcall(function()
        if listfiles then
            fileList = listfiles(SCRIPTS_DIR) or {}
        end
    end)

    if #fileList == 0 then
        local emptyLbl = Instance.new("TextLabel")
        emptyLbl.Size = UDim2.new(1, 0, 0, 60)
        emptyLbl.BackgroundTransparency = 1
        emptyLbl.Text = "No scripts saved in /sdcard/ORC/scripts/\nType code in Executor, name it above, and click SAVE EDITOR."
        emptyLbl.TextColor3 = C_MUTED
        emptyLbl.Font = Enum.Font.Code
        emptyLbl.TextSize = 11
        emptyLbl.Parent = savedScroll
        return
    end

    for _, filePath in ipairs(fileList) do
        local fileName = string.gsub(filePath, "^.*/", "")
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
            nameLbl.Font = Enum.Font.GothamBold
            nameLbl.TextSize = 12
            nameLbl.TextXAlignment = Enum.TextXAlignment.Left
            nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
            nameLbl.Parent = card

            local loadBtn = Instance.new("TextButton")
            loadBtn.Size = UDim2.new(0, 60, 0, 30)
            loadBtn.Position = UDim2.new(1, -196, 0.5, -15)
            loadBtn.BackgroundColor3 = C_CARD
            loadBtn.TextColor3 = C_WHITE
            loadBtn.Font = Enum.Font.GothamBold
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
            runBtn.Font = Enum.Font.GothamBold
            runBtn.TextSize = 11
            runBtn.Text = "RUN"
            runBtn.Parent = card

            local rbCorner = Instance.new("UICorner")
            rbCorner.CornerRadius = UDim.new(0, 6)
            rbCorner.Parent = runBtn

            local delBtn = Instance.new("TextButton")
            delBtn.Size = UDim2.new(0, 60, 0, 30)
            delBtn.Position = UDim2.new(1, -64, 0.5, -15)
            delBtn.BackgroundColor3 = Color3.fromRGB(40, 16, 16)
            delBtn.TextColor3 = Color3.fromRGB(255, 120, 120)
            delBtn.Font = Enum.Font.GothamBold
            delBtn.TextSize = 11
            delBtn.Text = "DEL"
            delBtn.Parent = card

            local dbCorner = Instance.new("UICorner")
            dbCorner.CornerRadius = UDim.new(0, 6)
            dbCorner.Parent = delBtn

            loadBtn.MouseButton1Click:Connect(function()
                pcall(function()
                    if readfile then
                        editorBox.Text = readfile(filePath)
                        if switchTab then switchTab("Executor") end
                        headerStatus.Text = "LOADED: " .. fileName
                    end
                end)
            end)

            runBtn.MouseButton1Click:Connect(function()
                pcall(function()
                    if readfile then
                        local code = readfile(filePath)
                        local fn = loadstring(code)
                        if fn then task.spawn(fn) end
                        headerStatus.Text = "RUNNING: " .. fileName
                    end
                end)
            end)

            delBtn.MouseButton1Click:Connect(function()
                pcall(function()
                    if delfile then
                        delfile(filePath)
                        card:Destroy()
                        headerStatus.Text = "DELETED: " .. fileName
                    end
                end)
            end)
        end
    end
end

btnRefreshSaved.MouseButton1Click:Connect(refreshSavedList)

btnCreateScript.MouseButton1Click:Connect(function()
    local name = newScriptName.Text
    if not name or #name == 0 then
        name = "Script_" .. tostring(os.time())
    end
    if not string.find(name, "%.luau$") and not string.find(name, "%.lua$") then
        name = name .. ".luau"
    end
    local targetPath = SCRIPTS_DIR .. "/" .. name
    pcall(function()
        if writefile then
            writefile(targetPath, editorBox.Text)
            newScriptName.Text = ""
            refreshSavedList()
            headerStatus.Text = "SAVED: " .. name
        end
    end)
end)

btnSaveAs.MouseButton1Click:Connect(function()
    if switchTab then switchTab("Saved") end
end)

local pageSearch = Instance.new("Frame")
pageSearch.Name = "Page_Search"
pageSearch.Size = UDim2.new(1, 0, 1, 0)
pageSearch.BackgroundTransparency = 1
pageSearch.Visible = false
pageSearch.Parent = viewport
pages["Search"] = pageSearch

local searchHeaderBar = Instance.new("Frame")
searchHeaderBar.Size = UDim2.new(1, 0, 0, 36)
searchHeaderBar.Position = UDim2.new(0, 0, 0, 0)
searchHeaderBar.BackgroundTransparency = 1
searchHeaderBar.Parent = pageSearch

local searchBar = Instance.new("TextBox")
searchBar.Size = UDim2.new(1, -100, 1, 0)
searchBar.Position = UDim2.new(0, 0, 0, 0)
searchBar.BackgroundColor3 = C_BLACK
searchBar.TextColor3 = C_WHITE
searchBar.PlaceholderText = "Search ScriptBlox by title or game..."
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
sbPad.PaddingLeft = UDim.new(0, 12)
sbPad.Parent = searchBar

local sbStroke = Instance.new("UIStroke")
sbStroke.Color = C_BORDER
sbStroke.Thickness = 1
sbStroke.Parent = searchBar

local searchBtn = Instance.new("TextButton")
searchBtn.Size = UDim2.new(0, 92, 1, 0)
searchBtn.Position = UDim2.new(1, -92, 0, 0)
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
searchScroll.Size = UDim2.new(1, 0, 1, -44)
searchScroll.Position = UDim2.new(0, 0, 0, 44)
searchScroll.BackgroundTransparency = 1
searchScroll.BorderSizePixel = 0
searchScroll.ScrollBarThickness = 4
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
                    card.Size = UDim2.new(1, -4, 0, 68)
                    card.BackgroundColor3 = C_BLACK
                    card.Parent = searchScroll

                    local cc = Instance.new("UICorner")
                    cc.CornerRadius = UDim.new(0, 8)
                    cc.Parent = card

                    local cs = Instance.new("UIStroke")
                    cs.Color = C_BORDER
                    cs.Thickness = 1
                    cs.Parent = card

                    local img = Instance.new("ImageLabel")
                    img.Size = UDim2.new(0, 52, 0, 52)
                    img.Position = UDim2.new(0, 8, 0.5, -26)
                    img.BackgroundColor3 = C_CARD
                    img.ScaleType = Enum.ScaleType.Crop
                    img.Parent = card

                    local ic = Instance.new("UICorner")
                    ic.CornerRadius = UDim.new(0, 6)
                    ic.Parent = img

                    if item.game and item.game.imageUrl then
                        local imageUrl = item.game.imageUrl
                        if string.find(imageUrl, "^/") then
                            imageUrl = "https://scriptblox.com" .. imageUrl
                        end
                        img.Image = imageUrl
                    else
                        img.Image = "rbxassetid://10734883502"
                    end

                    local titleLbl = Instance.new("TextLabel")
                    titleLbl.Size = UDim2.new(1, -210, 0, 22)
                    titleLbl.Position = UDim2.new(0, 68, 0, 10)
                    titleLbl.BackgroundTransparency = 1
                    titleLbl.Text = item.title or "Script"
                    titleLbl.TextColor3 = C_WHITE
                    titleLbl.Font = Enum.Font.GothamBold
                    titleLbl.TextSize = 12
                    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
                    titleLbl.TextTruncate = Enum.TextTruncate.AtEnd
                    titleLbl.Parent = card

                    local gameLbl = Instance.new("TextLabel")
                    gameLbl.Size = UDim2.new(1, -210, 0, 18)
                    gameLbl.Position = UDim2.new(0, 68, 0, 34)
                    gameLbl.BackgroundTransparency = 1
                    gameLbl.Text = (item.game and item.game.name) or "Universal"
                    gameLbl.TextColor3 = C_MUTED
                    gameLbl.Font = Enum.Font.Code
                    gameLbl.TextSize = 10
                    gameLbl.TextXAlignment = Enum.TextXAlignment.Left
                    gameLbl.TextTruncate = Enum.TextTruncate.AtEnd
                    gameLbl.Parent = card

                    local loadBtn = Instance.new("TextButton")
                    loadBtn.Size = UDim2.new(0, 62, 0, 32)
                    loadBtn.Position = UDim2.new(1, -140, 0.5, -16)
                    loadBtn.BackgroundColor3 = C_CARD
                    loadBtn.TextColor3 = C_WHITE
                    loadBtn.Font = Enum.Font.GothamBold
                    loadBtn.TextSize = 11
                    loadBtn.Text = "LOAD"
                    loadBtn.Parent = card

                    local lbC = Instance.new("UICorner")
                    lbC.CornerRadius = UDim.new(0, 6)
                    lbC.Parent = loadBtn

                    local execBtn = Instance.new("TextButton")
                    execBtn.Size = UDim2.new(0, 66, 0, 32)
                    execBtn.Position = UDim2.new(1, -72, 0.5, -16)
                    execBtn.BackgroundColor3 = C_WHITE
                    execBtn.TextColor3 = C_BLACK
                    execBtn.Font = Enum.Font.GothamBold
                    execBtn.TextSize = 11
                    execBtn.Text = "RUN"
                    execBtn.Parent = card

                    local ebC = Instance.new("UICorner")
                    ebC.CornerRadius = UDim.new(0, 6)
                    ebC.Parent = execBtn

                    loadBtn.MouseButton1Click:Connect(function()
                        if item.script then
                            editorBox.Text = item.script
                            if switchTab then switchTab("Executor") end
                            headerStatus.Text = "LOADED FROM SCRIPTBLOX"
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
                headerStatus.Text = "FOUND " .. tostring(#scriptsList) .. " SCRIPTS"
                return
            end
        end
        headerStatus.Text = "SEARCH COMPLETED"
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

local pageConsole = Instance.new("Frame")
pageConsole.Name = "Page_Console"
pageConsole.Size = UDim2.new(1, 0, 1, 0)
pageConsole.BackgroundTransparency = 1
pageConsole.Visible = false
pageConsole.Parent = viewport
pages["Console"] = pageConsole

local consoleTopBar = Instance.new("Frame")
consoleTopBar.Size = UDim2.new(1, 0, 0, 30)
consoleTopBar.Position = UDim2.new(0, 0, 0, 0)
consoleTopBar.BackgroundTransparency = 1
consoleTopBar.Parent = pageConsole

local btnClearBoth = Instance.new("TextButton")
btnClearBoth.Size = UDim2.new(0, 100, 1, 0)
btnClearBoth.Position = UDim2.new(1, -100, 0, 0)
btnClearBoth.BackgroundColor3 = C_CARD
btnClearBoth.TextColor3 = C_WHITE
btnClearBoth.Font = Enum.Font.GothamBold
btnClearBoth.TextSize = 11
btnClearBoth.Text = "CLEAR ALL"
btnClearBoth.Parent = consoleTopBar

local bcCorner = Instance.new("UICorner")
bcCorner.CornerRadius = UDim.new(0, 6)
bcCorner.Parent = btnClearBoth

local consoleBody = Instance.new("Frame")
consoleBody.Size = UDim2.new(1, 0, 1, -34)
consoleBody.Position = UDim2.new(0, 0, 0, 34)
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
    pCorner.CornerRadius = UDim.new(0, 8)
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
    phCorner.CornerRadius = UDim.new(0, 8)
    phCorner.Parent = pHeader

    local pTitle = Instance.new("TextLabel")
    pTitle.Size = UDim2.new(1, -80, 1, 0)
    pTitle.Position = UDim2.new(0, 10, 0, 0)
    pTitle.BackgroundTransparency = 1
    pTitle.Text = title
    pTitle.TextColor3 = C_WHITE
    pTitle.Font = Enum.Font.GothamBold
    pTitle.TextSize = 11
    pTitle.TextXAlignment = Enum.TextXAlignment.Left
    pTitle.Parent = pHeader

    local paneClearBtn = Instance.new("TextButton")
    paneClearBtn.Size = UDim2.new(0, 50, 0, 20)
    paneClearBtn.Position = UDim2.new(1, -56, 0.5, -10)
    paneClearBtn.BackgroundColor3 = C_BLACK
    paneClearBtn.TextColor3 = C_MUTED
    paneClearBtn.Font = Enum.Font.GothamBold
    paneClearBtn.TextSize = 9
    paneClearBtn.Text = "CLEAR"
    paneClearBtn.Parent = pHeader

    local pcbCorner = Instance.new("UICorner")
    pcbCorner.CornerRadius = UDim.new(0, 4)
    pcbCorner.Parent = paneClearBtn

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -12, 1, -36)
    scroll.Position = UDim2.new(0, 6, 0, 32)
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

    paneClearBtn.MouseButton1Click:Connect(function()
        for _, ch in ipairs(scroll:GetChildren()) do
            if ch:IsA("Frame") then ch:Destroy() end
        end
    end)

    return scroll
end

local orcPane = makeConsolePane("ORC CORE LOG")
local rbxPane = makeConsolePane("ROBLOX ERRORS ONLY")

btnClearBoth.MouseButton1Click:Connect(function()
    for _, ch in ipairs(orcPane:GetChildren()) do
        if ch:IsA("Frame") then ch:Destroy() end
    end
    for _, ch in ipairs(rbxPane:GetChildren()) do
        if ch:IsA("Frame") then ch:Destroy() end
    end
end)

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
    tagLabel.Size = UDim2.new(0, 36, 0, 16)
    tagLabel.BackgroundTransparency = 1
    tagLabel.Text = tag or "ERR"
    tagLabel.TextColor3 = col
    tagLabel.Font = Enum.Font.Code
    tagLabel.TextSize = 10
    tagLabel.TextXAlignment = Enum.TextXAlignment.Left
    tagLabel.Parent = row

    local msgLabel = Instance.new("TextLabel")
    msgLabel.Size = UDim2.new(1, -40, 0, 0)
    msgLabel.Position = UDim2.new(0, 40, 0, 0)
    msgLabel.AutomaticSize = Enum.AutomaticSize.Y
    msgLabel.BackgroundTransparency = 1
    msgLabel.Text = tostring(text)
    msgLabel.TextColor3 = col
    msgLabel.Font = Enum.Font.Code
    msgLabel.TextSize = 10
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.TextWrapped = true
    msgLabel.Parent = row

    task.defer(function()
        scrollFrame.CanvasPosition = Vector2.new(0, 999999)
    end)
end

LogService.MessageOut:Connect(function(message, messageType)
    if messageType == Enum.MessageType.MessageError then
        addLogMessage(rbxPane, message, Color3.fromRGB(255, 75, 75), "ERR")
    end
end)

pcall(function()
    local history = LogService:GetLogHistory()
    for _, item in ipairs(history) do
        if item.messageType == Enum.MessageType.MessageError then
            addLogMessage(rbxPane, item.message, Color3.fromRGB(255, 75, 75), "ERR")
        end
    end
end)

addLogMessage(orcPane, "ORC Engine attached.", Color3.fromRGB(75, 255, 120), "INIT")
addLogMessage(orcPane, "Error filter applied.", Color3.fromRGB(75, 175, 255), "FILTER")

local pageUtils = Instance.new("ScrollingFrame")
pageUtils.Name = "Page_Utils"
pageUtils.Size = UDim2.new(1, 0, 1, 0)
pageUtils.BackgroundTransparency = 1
pageUtils.BorderSizePixel = 0
pageUtils.ScrollBarThickness = 4
pageUtils.ScrollBarImageColor3 = C_WHITE
pageUtils.AutomaticCanvasSize = Enum.AutomaticSize.Y
pageUtils.Visible = false
pageUtils.Parent = viewport
pages["Utils"] = pageUtils

local utilsLayout = Instance.new("UIListLayout")
utilsLayout.Padding = UDim.new(0, 8)
utilsLayout.Parent = pageUtils

local function makeUtilToggle(title, desc, defaultState, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -4, 0, 52)
    card.BackgroundColor3 = C_BLACK
    card.Parent = pageUtils

    local cc = Instance.new("UICorner")
    cc.CornerRadius = UDim.new(0, 8)
    cc.Parent = card

    local cs = Instance.new("UIStroke")
    cs.Color = C_BORDER
    cs.Thickness = 1
    cs.Parent = card

    local tLbl = Instance.new("TextLabel")
    tLbl.Size = UDim2.new(0.7, 0, 0, 22)
    tLbl.Position = UDim2.new(0, 12, 0, 6)
    tLbl.BackgroundTransparency = 1
    tLbl.Text = title
    tLbl.TextColor3 = C_WHITE
    tLbl.Font = Enum.Font.GothamBold
    tLbl.TextSize = 12
    tLbl.TextXAlignment = Enum.TextXAlignment.Left
    tLbl.Parent = card

    local dLbl = Instance.new("TextLabel")
    dLbl.Size = UDim2.new(0.7, 0, 0, 18)
    dLbl.Position = UDim2.new(0, 12, 0, 28)
    dLbl.BackgroundTransparency = 1
    dLbl.Text = desc
    dLbl.TextColor3 = C_MUTED
    dLbl.Font = Enum.Font.Code
    dLbl.TextSize = 10
    dLbl.TextXAlignment = Enum.TextXAlignment.Left
    dLbl.Parent = card

    local tglBtn = Instance.new("TextButton")
    tglBtn.Size = UDim2.new(0, 68, 0, 30)
    tglBtn.Position = UDim2.new(1, -76, 0.5, -15)
    tglBtn.BackgroundColor3 = defaultState and C_WHITE or C_CARD
    tglBtn.TextColor3 = defaultState and C_BLACK or C_MUTED
    tglBtn.Font = Enum.Font.GothamBold
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

local function makeUtilAction(title, desc, btnText, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -4, 0, 52)
    card.BackgroundColor3 = C_BLACK
    card.Parent = pageUtils

    local cc = Instance.new("UICorner")
    cc.CornerRadius = UDim.new(0, 8)
    cc.Parent = card

    local cs = Instance.new("UIStroke")
    cs.Color = C_BORDER
    cs.Thickness = 1
    cs.Parent = card

    local tLbl = Instance.new("TextLabel")
    tLbl.Size = UDim2.new(0.7, 0, 0, 22)
    tLbl.Position = UDim2.new(0, 12, 0, 6)
    tLbl.BackgroundTransparency = 1
    tLbl.Text = title
    tLbl.TextColor3 = C_WHITE
    tLbl.Font = Enum.Font.GothamBold
    tLbl.TextSize = 12
    tLbl.TextXAlignment = Enum.TextXAlignment.Left
    tLbl.Parent = card

    local dLbl = Instance.new("TextLabel")
    dLbl.Size = UDim2.new(0.7, 0, 0, 18)
    dLbl.Position = UDim2.new(0, 12, 0, 28)
    dLbl.BackgroundTransparency = 1
    dLbl.Text = desc
    dLbl.TextColor3 = C_MUTED
    dLbl.Font = Enum.Font.Code
    dLbl.TextSize = 10
    dLbl.TextXAlignment = Enum.TextXAlignment.Left
    dLbl.Parent = card

    local actBtn = Instance.new("TextButton")
    actBtn.Size = UDim2.new(0, 76, 0, 30)
    actBtn.Position = UDim2.new(1, -84, 0.5, -15)
    actBtn.BackgroundColor3 = C_WHITE
    actBtn.TextColor3 = C_BLACK
    actBtn.Font = Enum.Font.GothamBold
    actBtn.TextSize = 11
    actBtn.Text = btnText
    actBtn.Parent = card

    local acCorner = Instance.new("UICorner")
    acCorner.CornerRadius = UDim.new(0, 6)
    acCorner.Parent = actBtn

    actBtn.MouseButton1Click:Connect(callback)
end

makeUtilToggle("Anti-AFK Protection", "Prevents disconnection after 20 minutes of inactivity", true, function(enabled)
    if enabled then
        player.Idled:Connect(function()
            VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
    end
end)

local speedConn = nil
makeUtilToggle("Super Speed (WalkSpeed 50)", "Overrides WalkSpeed with continuous enforcement", false, function(enabled)
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
makeUtilToggle("Infinite Jump", "Jump repeatedly mid-air to scale sky structures", false, function(enabled)
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
makeUtilToggle("Noclip Ghost Mode", "Walk through walls and obstacles", false, function(enabled)
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

makeUtilAction("Server Rejoin", "Reconnects character to this game instance", "REJOIN", function()
    TeleportService:Teleport(game.PlaceId, player)
end)

makeUtilAction("Server Hop", "Migrates your session to an alternate server", "HOP", function()
    headerStatus.Text = "HOPPING SERVER..."
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

local currentTab = "Executor"
local isTransitioning = false

function switchTab(tabName)
    if isTransitioning or currentTab == tabName then return end
    isTransitioning = true

    headerTitle.Text = "ORC TITAN EXECUTOR // " .. string.upper(tabName)

    local oldPage = pages[currentTab]
    local newPage = pages[tabName]

    if tabName == "Saved" then
        refreshSavedList()
    end

    local targetBtn = dockButtons[tabName]
    if targetBtn then
        TweenService:Create(activePill, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = UDim2.new(1, -4, 0, targetBtn.AbsolutePosition.Y - dockButtonsContainer.AbsolutePosition.Y + 2)
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

    if oldPage then
        local fadeOut = TweenService:Create(oldPage, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, -10, 0, 0)
        })
        fadeOut:Play()
        fadeOut.Completed:Connect(function()
            oldPage.Visible = false
            oldPage.Position = UDim2.new(0, 0, 0, 0)

            if newPage then
                newPage.Position = UDim2.new(0, 10, 0, 0)
                newPage.Visible = true
                local fadeIn = TweenService:Create(newPage, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
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
btnSearch.MouseButton1Connect = btnSearch.MouseButton1Click:Connect(function() switchTab("Search") end)
btnConsole.MouseButton1Click:Connect(function() switchTab("Console") end)
btnUtils.MouseButton1Click:Connect(function() switchTab("Utils") end)

task.defer(function()
    pages["Executor"].Visible = true
    if dockButtons["Executor"] then
        dockButtons["Executor"].BackgroundColor3 = C_WHITE
        dockButtons["Executor"].ImageColor3 = C_BLACK
    end
end)

btnClose.MouseButton1Click:Connect(function()
    fullBackdrop.Visible = false
    floatingBubble.Visible = true
end)

floatingBubble.MouseButton1Click:Connect(function()
    floatingBubble.Visible = false
    fullBackdrop.Visible = true
end)

print("[ORC] Complete Titan Suite Initialized.")
