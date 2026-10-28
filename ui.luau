--[[
    EnforX UI  •  Delta-Style (No Key System)
    Version: 2.0
    Theme: Pure Black & White
    By M4X • EVA • AMAL • JANA
]]

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local GuiService       = game:GetService("GuiService")
local HttpService      = game:GetService("HttpService")
local CoreGui          = game:GetService("CoreGui")
local LogService       = game:GetService("LogService")

local LocalPlayer = Players.LocalPlayer

-- ==================== CONFIG ====================
local Config = {
    Title     = "EnforX",
    Version   = "2.0",
    IconURL   = "https://raw.githubusercontent.com/MITTO-m4x/Neo_EVADE/main/EVADE/scr/Photo/Icon.png",
    BannerURL = "https://raw.githubusercontent.com/MITTO-m4x/Neo_EVADE/main/EVADE/scr/Photo/Icon2.png",
    SearchAPI = "https://scriptblox.com/api/script/search?q=",
    MaxLogs   = 180,
}

local C = {
    BG      = Color3.fromRGB(8, 8, 8),
    Panel   = Color3.fromRGB(16, 16, 16),
    Panel2  = Color3.fromRGB(26, 26, 26),
    Hover   = Color3.fromRGB(40, 40, 40),
    Stroke  = Color3.fromRGB(55, 55, 55),
    White   = Color3.fromRGB(245, 245, 245),
    Gray    = Color3.fromRGB(150, 150, 150),
    Black   = Color3.fromRGB(0, 0, 0),
    Success = Color3.fromRGB(80, 200, 120),
    Warning = Color3.fromRGB(230, 180, 40),
    Error   = Color3.fromRGB(230, 70, 70),
    Info    = Color3.fromRGB(100, 160, 255),
}

-- ==================== HELPERS ====================
local function make(class, props, parent)
    local o = Instance.new(class)
    for k, v in pairs(props or {}) do o[k] = v end
    if parent then o.Parent = parent end
    return o
end

local function corner(o, r)
    return make("UICorner", {CornerRadius = UDim.new(0, r or 8)}, o)
end

local function stroke(o, color, thick)
    return make("UIStroke", {
        Color = color or C.Stroke,
        Thickness = thick or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }, o)
end

local function pad(o, t, b, l, r)
    return make("UIPadding", {
        PaddingTop = UDim.new(0, t or 0),
        PaddingBottom = UDim.new(0, b or 0),
        PaddingLeft = UDim.new(0, l or 0),
        PaddingRight = UDim.new(0, r or 0),
    }, o)
end

local function tween(obj, props, time)
    local t = TweenService:Create(obj, TweenInfo.new(time or 0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local function hover(btn, normal, hov)
    btn.MouseEnter:Connect(function() tween(btn, {BackgroundColor3 = hov}, 0.12) end)
    btn.MouseLeave:Connect(function() tween(btn, {BackgroundColor3 = normal}, 0.12) end)
end

local function btn(parent, text, size, pos, primary, textSize)
    local bg = primary and C.White or C.Panel2
    local fg = primary and C.Black or C.White
    local b = make("TextButton", {
        Size = size,
        Position = pos or UDim2.new(),
        BackgroundColor3 = bg,
        Text = text,
        TextColor3 = fg,
        Font = Enum.Font.GothamBold,
        TextSize = textSize or 12,
        AutoButtonColor = false,
        BorderSizePixel = 0,
    }, parent)
    corner(b, 7)
    if not primary then stroke(b) end
    hover(b, bg, primary and Color3.fromRGB(210,210,210) or C.Hover)
    return b
end

local function makeDraggable(handle, target)
    local dragging, startPos, startInput
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startPos = target.Position
            startInput = input.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - startInput
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local function httpGet(url)
    local req = request or http_request
    if req then
        local r = req({Url = url, Method = "GET"})
        return r and r.Body
    end
    local ok, res = pcall(function() return game:HttpGet(url) end)
    return ok and res or nil
end

local function remoteImage(url, name)
    local ok, res = pcall(function()
        if not (writefile and getcustomasset and (request or http_request)) then return nil end
        local r = (request or http_request)({Url = url, Method = "GET"})
        if r and r.Body then
            writefile(name, r.Body)
            return getcustomasset(name)
        end
    end)
    return ok and res or nil
end

local function protect(gui)
    pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(gui) end
        if protect_gui then protect_gui(gui) end
    end)
    task.spawn(function()
        while task.wait(2) do
            if not gui or not gui.Parent then
                pcall(function() gui.Parent = (gethui and gethui()) or CoreGui end)
            end
        end
    end)
end

-- ==================== ROOT ====================
local parentGui = (gethui and gethui()) or CoreGui
pcall(function()
    local old = parentGui:FindFirstChild("EnforX_UI")
    if old then old:Destroy() end
end)

local gui = make("ScreenGui", {
    Name = "EnforX_UI",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 50,
}, parentGui)
protect(gui)

-- ==================== FLOATING ICON ====================
local floatGui = make("ScreenGui", {
    Name = "EnforX_Float",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    DisplayOrder = 60,
}, parentGui)

local floatSize = 46
local floatBtn = make("TextButton", {
    Name = "Float",
    Size = UDim2.fromOffset(floatSize, floatSize),
    Position = UDim2.new(1, -floatSize - 18, 0.55, 0),
    BackgroundColor3 = C.Black,
    Text = "EX",
    TextColor3 = C.White,
    Font = Enum.Font.GothamBlack,
    TextSize = 16,
    AutoButtonColor = false,
    Visible = false,
    Active = true,
}, floatGui)
corner(floatBtn, 14)
local floatStroke = stroke(floatBtn, C.White, 2)
makeDraggable(floatBtn, floatBtn)

-- ==================== MAIN WINDOW ====================
local cam = workspace.CurrentCamera
local vp = cam and cam.ViewportSize or Vector2.new(800, 600)
-- Delta-like proportions (wider, balanced height)
local W = math.clamp(math.floor(vp.X * 0.92), 320, 520)
local H = math.clamp(math.floor(vp.Y * 0.72), 280, 420)

local win = make("Frame", {
    Size = UDim2.fromOffset(W, H),
    Position = UDim2.new(0.5, -W/2, 0.5, -H/2),
    BackgroundColor3 = C.BG,
    BorderSizePixel = 0,
    ClipsDescendants = true,
}, gui)
corner(win, 10)
stroke(win)

-- Title Bar
local top = make("Frame", {
    Size = UDim2.new(1, 0, 0, 32),
    BackgroundColor3 = C.Panel,
    BorderSizePixel = 0,
}, win)
corner(top, 10)
make("Frame", {
    Size = UDim2.new(1, 0, 0, 12),
    Position = UDim2.new(0, 0, 1, -12),
    BackgroundColor3 = C.Panel,
    BorderSizePixel = 0,
}, top)

local titleIcon = make("ImageLabel", {
    Size = UDim2.fromOffset(20, 20),
    Position = UDim2.fromOffset(8, 6),
    BackgroundTransparency = 1,
    Image = "",
    ScaleType = Enum.ScaleType.Fit,
}, top)

local titleLbl = make("TextLabel", {
    Size = UDim2.new(0, 140, 1, 0),
    Position = UDim2.fromOffset(34, 0),
    BackgroundTransparency = 1,
    Text = Config.Title .. "  v" .. Config.Version,
    TextColor3 = C.White,
    Font = Enum.Font.GothamBold,
    TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left,
}, top)

local minBtn = btn(top, "─", UDim2.fromOffset(26, 22), UDim2.new(1, -60, 0, 5), false, 12)
local closeBtn = btn(top, "×", UDim2.fromOffset(26, 22), UDim2.new(1, -30, 0, 5), false, 14)

makeDraggable(top, win)

-- Sidebar
local side = make("Frame", {
    Size = UDim2.new(0, 58, 1, -40),
    Position = UDim2.fromOffset(4, 36),
    BackgroundColor3 = C.Panel,
    BorderSizePixel = 0,
}, win)
corner(side, 8)
stroke(side)

local tabHolder = make("Frame", {
    Size = UDim2.new(1, -8, 1, -44),
    Position = UDim2.fromOffset(4, 4),
    BackgroundTransparency = 1,
}, side)
make("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder}, tabHolder)

local content = make("Frame", {
    Size = UDim2.new(1, -70, 1, -40),
    Position = UDim2.fromOffset(66, 36),
    BackgroundTransparency = 1,
    ClipsDescendants = true,
}, win)

-- ==================== TABS ====================
local pages, tabs = {}, {}
local currentTab = nil

local function selectTab(name)
    currentTab = name
    for n, p in pairs(pages) do p.Visible = (n == name) end
    for n, b in pairs(tabs) do
        local active = (n == name)
        b.BackgroundColor3 = active and C.White or C.Panel2
        b.TextColor3 = active and C.Black or C.White
    end
end

local function newPage(name)
    local p = make("Frame", {
        Name = name,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Visible = false,
    }, content)
    pages[name] = p
    return p
end

local function newTab(name, icon, bottom)
    local b = make("TextButton", {
        Size = bottom and UDim2.new(1, -8, 0, 34) or UDim2.new(1, 0, 0, 34),
        Position = bottom and UDim2.new(0, 4, 1, -38) or UDim2.new(),
        BackgroundColor3 = C.Panel2,
        Text = icon,
        TextColor3 = C.White,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        AutoButtonColor = false,
        BorderSizePixel = 0,
        LayoutOrder = bottom and 99 or nil,
    }, bottom and side or tabHolder)
    corner(b, 7)
    b.MouseButton1Click:Connect(function() selectTab(name) end)
    tabs[name] = b
    return b
end

-- ==================== PAGE: HOME (Saved Scripts) ====================
local homePage = newPage("Home")
newTab("Home", "⌂")

make("TextLabel", {
    Size = UDim2.new(1, 0, 0, 22),
    BackgroundTransparency = 1,
    Text = "Saved Scripts",
    TextColor3 = C.White,
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
}, homePage)

local homeSearch = make("TextBox", {
    Size = UDim2.new(1, -70, 0, 28),
    Position = UDim2.fromOffset(0, 26),
    BackgroundColor3 = C.Panel,
    Text = "",
    PlaceholderText = "Filter scripts...",
    PlaceholderColor3 = C.Gray,
    TextColor3 = C.White,
    Font = Enum.Font.Gotham,
    TextSize = 12,
    ClearTextOnFocus = false,
    TextXAlignment = Enum.TextXAlignment.Left,
    BorderSizePixel = 0,
}, homePage)
corner(homeSearch, 6)
stroke(homeSearch)
pad(homeSearch, 0, 0, 8, 8)

local addScriptBtn = btn(homePage, "+", UDim2.fromOffset(28, 28), UDim2.new(1, -28, 0, 26), true, 16)

local homeHolder = make("ScrollingFrame", {
    Size = UDim2.new(1, 0, 1, -62),
    Position = UDim2.fromOffset(0, 60),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = C.Gray,
    CanvasSize = UDim2.new(),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, homePage)
make("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder}, homeHolder)

local SavedScripts = {}

local function refreshHome()
    for _, c in ipairs(homeHolder:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end
    for i, data in ipairs(SavedScripts) do
        local card = make("Frame", {
            Size = UDim2.new(1, -4, 0, 44),
            BackgroundColor3 = C.Panel,
            BorderSizePixel = 0,
            LayoutOrder = i,
        }, homeHolder)
        corner(card, 7)
        stroke(card)

        make("TextLabel", {
            Size = UDim2.new(1, -110, 1, 0),
            Position = UDim2.fromOffset(10, 0),
            BackgroundTransparency = 1,
            Text = data.name,
            TextColor3 = C.White,
            Font = Enum.Font.GothamMedium,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
        }, card)

        local runB = btn(card, "Run", UDim2.fromOffset(42, 24), UDim2.new(1, -96, 0.5, -12), true, 10)
        local delB = btn(card, "Del", UDim2.fromOffset(42, 24), UDim2.new(1, -48, 0.5, -12), false, 10)

        runB.MouseButton1Click:Connect(function()
            local fn, err = loadstring(data.source)
            if fn then
                task.spawn(function()
                    local ok, res = pcall(fn)
                    if not ok then warn("[EnforX] " .. tostring(res)) end
                end)
            else
                warn("[EnforX] " .. tostring(err))
            end
        end)
        delB.MouseButton1Click:Connect(function()
            table.remove(SavedScripts, i)
            refreshHome()
        end)
    end
end

addScriptBtn.MouseButton1Click:Connect(function()
    if pages.Executor and pages.Executor:FindFirstChild("Code") then
        local src = pages.Executor.Code.Text
        if src and #src > 5 then
            table.insert(SavedScripts, {name = "Script_" .. (#SavedScripts + 1), source = src})
            refreshHome()
        end
    end
end)

homeSearch:GetPropertyChangedSignal("Text"):Connect(function()
    local q = string.lower(homeSearch.Text)
    for _, c in ipairs(homeHolder:GetChildren()) do
        if c:IsA("Frame") then
            local lbl = c:FindFirstChildOfClass("TextLabel")
            if lbl then
                c.Visible = (q == "" or string.find(string.lower(lbl.Text), q, 1, true))
            end
        end
    end
end)

-- ==================== PAGE: EXECUTOR ====================
local execPage = newPage("Executor")
newTab("Executor", "</>")

local codeBox = make("TextBox", {
    Name = "Code",
    Size = UDim2.new(1, 0, 1, -42),
    BackgroundColor3 = C.Panel,
    Text = "-- EnforX Executor\nprint(\"Hello\")",
    PlaceholderText = "-- write code here...",
    PlaceholderColor3 = C.Gray,
    TextColor3 = C.White,
    Font = Enum.Font.Code,
    TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    MultiLine = true,
    ClearTextOnFocus = false,
    TextWrapped = true,
    BorderSizePixel = 0,
}, execPage)
corner(codeBox, 8)
stroke(codeBox)
pad(codeBox, 8, 8, 8, 8)

local execBar = make("Frame", {
    Size = UDim2.new(1, 0, 0, 34),
    Position = UDim2.new(0, 0, 1, -34),
    BackgroundTransparency = 1,
}, execPage)

local runBtn   = btn(execBar, "Run",   UDim2.new(0.23, -4, 1, 0), UDim2.new(0, 0, 0, 0), true, 12)
local clearBtn = btn(execBar, "Clear", UDim2.new(0.23, -4, 1, 0), UDim2.new(0.25, 0, 0, 0), false, 12)
local pasteBtn = btn(execBar, "Paste", UDim2.new(0.23, -4, 1, 0), UDim2.new(0.5, 0, 0, 0), false, 12)
local copyBtn  = btn(execBar, "Copy",  UDim2.new(0.23, -4, 1, 0), UDim2.new(0.75, 0, 0, 0), false, 12)

runBtn.MouseButton1Click:Connect(function()
    local src = codeBox.Text
    if src and #src > 0 then
        local fn, err = loadstring(src)
        if fn then
            task.spawn(function()
                local ok, res = pcall(fn)
                if not ok then warn("[EnforX] " .. tostring(res)) end
            end)
        else
            warn("[EnforX] " .. tostring(err))
        end
    end
end)
clearBtn.MouseButton1Click:Connect(function() codeBox.Text = "" end)
pasteBtn.MouseButton1Click:Connect(function()
    local ok, clip = pcall(function()
        if getclipboard then return getclipboard() end
        if syn and syn.clipboard then return syn.clipboard end
    end)
    if ok and type(clip) == "string" then codeBox.Text = clip end
end)
copyBtn.MouseButton1Click:Connect(function()
    pcall(function()
        if setclipboard then setclipboard(codeBox.Text)
        elseif toclipboard then toclipboard(codeBox.Text) end
    end)
end)

-- ==================== PAGE: HUB ====================
local hubPage = newPage("Hub")
newTab("Hub", "⌕")

local hubSearch = make("TextBox", {
    Size = UDim2.new(1, 0, 0, 30),
    BackgroundColor3 = C.Panel,
    Text = "",
    PlaceholderText = "Search scripts + Enter...",
    PlaceholderColor3 = C.Gray,
    TextColor3 = C.White,
    Font = Enum.Font.Gotham,
    TextSize = 12,
    ClearTextOnFocus = false,
    TextXAlignment = Enum.TextXAlignment.Left,
    BorderSizePixel = 0,
}, hubPage)
corner(hubSearch, 7)
stroke(hubSearch)
pad(hubSearch, 0, 0, 8, 8)

local hubMsg = make("TextLabel", {
    Size = UDim2.new(1, 0, 0, 18),
    Position = UDim2.fromOffset(0, 34),
    BackgroundTransparency = 1,
    Text = "Type a keyword and press Enter",
    TextColor3 = C.Gray,
    Font = Enum.Font.Gotham,
    TextSize = 11,
}, hubPage)

local hubHolder = make("ScrollingFrame", {
    Size = UDim2.new(1, 0, 1, -56),
    Position = UDim2.fromOffset(0, 54),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = C.Gray,
    CanvasSize = UDim2.new(),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, hubPage)
make("UIGridLayout", {
    CellSize = UDim2.new(0.5, -4, 0, 54),
    CellPadding = UDim2.fromOffset(6, 6),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, hubHolder)

local hubPopup = make("Frame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = C.Black,
    BackgroundTransparency = 0.4,
    Visible = false,
    ZIndex = 30,
    Active = true,
}, hubPage)

local hubCard = make("Frame", {
    Size = UDim2.fromOffset(210, 148),
    Position = UDim2.new(0.5, -105, 0.5, -74),
    BackgroundColor3 = C.Panel,
    ZIndex = 31,
}, hubPopup)
corner(hubCard, 10)
stroke(hubCard)

local popTitle = make("TextLabel", {
    Size = UDim2.new(1, -12, 0, 26),
    Position = UDim2.fromOffset(6, 4),
    BackgroundTransparency = 1,
    Text = "",
    TextColor3 = C.White,
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    TextTruncate = Enum.TextTruncate.AtEnd,
    ZIndex = 32,
}, hubCard)

local function popBtn(txt, y, primary)
    local b = btn(hubCard, txt, UDim2.new(1, -16, 0, 26), UDim2.fromOffset(8, y), primary, 11)
    b.ZIndex = 32
    return b
end

local pExec  = popBtn("Execute", 34, true)
local pEdit  = popBtn("Open in Executor", 64, false)
local pCopy  = popBtn("Copy", 94, false)
local pClose = popBtn("Close", 124, false)

local selected = {title = "", source = ""}

pClose.MouseButton1Click:Connect(function() hubPopup.Visible = false end)
pExec.MouseButton1Click:Connect(function()
    hubPopup.Visible = false
    if selected.source and #selected.source > 0 then
        local fn, err = loadstring(selected.source)
        if fn then task.spawn(function() local ok, r = pcall(fn) if not ok then warn(tostring(r)) end end)
        else warn(tostring(err)) end
    end
end)
pEdit.MouseButton1Click:Connect(function()
    codeBox.Text = selected.source or ""
    hubPopup.Visible = false
    selectTab("Executor")
end)
pCopy.MouseButton1Click:Connect(function()
    pcall(function()
        if setclipboard then setclipboard(selected.source) end
    end)
    hubPopup.Visible = false
end)

local function addHubResult(title, gameName, source, verified, views)
    local card = make("TextButton", {
        BackgroundColor3 = C.Panel,
        Text = "",
        AutoButtonColor = false,
        BorderSizePixel = 0,
    }, hubHolder)
    corner(card, 7)
    stroke(card)

    make("TextLabel", {
        Size = UDim2.new(1, -10, 0, 18),
        Position = UDim2.fromOffset(6, 4),
        BackgroundTransparency = 1,
        Text = (verified and "[V] " or "") .. tostring(title),
        TextColor3 = C.White,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, card)
    make("TextLabel", {
        Size = UDim2.new(1, -10, 0, 14),
        Position = UDim2.fromOffset(6, 22),
        BackgroundTransparency = 1,
        Text = tostring(gameName),
        TextColor3 = C.Gray,
        Font = Enum.Font.Gotham,
        TextSize = 10,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, card)
    make("TextLabel", {
        Size = UDim2.new(1, -10, 0, 12),
        Position = UDim2.fromOffset(6, 38),
        BackgroundTransparency = 1,
        Text = tostring(views) .. " views",
        TextColor3 = C.Gray,
        Font = Enum.Font.Gotham,
        TextSize = 9,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, card)

    card.MouseButton1Click:Connect(function()
        selected = {title = title, source = source}
        popTitle.Text = tostring(title)
        hubPopup.Visible = true
    end)
end

hubSearch.FocusLost:Connect(function(enter)
    if not enter then return end
    local q = hubSearch.Text
    if q == "" then return end
    for _, c in ipairs(hubHolder:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    hubMsg.Text = "Searching..."
    hubMsg.Visible = true
    task.spawn(function()
        local ok, decoded = pcall(function()
            local body = httpGet(Config.SearchAPI .. HttpService:UrlEncode(q))
            if not body then return nil end
            return HttpService:JSONDecode(body)
        end)
        if not ok or not decoded or not decoded.result then
            hubMsg.Text = "Search failed"
            return
        end
        local n = 0
        for _, s in ipairs(decoded.result.scripts or {}) do
            if s.scriptType == "free" and not s.isPatched then
                addHubResult(s.title, (s.game and s.game.name) or "Universal", s.script, s.verified, s.views or 0)
                n = n + 1
            end
        end
        hubMsg.Visible = (n == 0)
        hubMsg.Text = n == 0 and "No results" or (n .. " results")
    end)
end)

-- ==================== PAGE: CONSOLE ====================
local consolePage = newPage("Console")
newTab("Console", ">")

local function makeLog(parent)
    local box = make("Frame", {
        Size = UDim2.new(1, 0, 1, -30),
        BackgroundColor3 = C.Panel,
        BorderSizePixel = 0,
    }, parent)
    corner(box, 7)
    stroke(box)

    local sc = make("ScrollingFrame", {
        Size = UDim2.new(1, -8, 1, -8),
        Position = UDim2.fromOffset(4, 4),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = C.Gray,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
    }, box)
    make("UIListLayout", {Padding = UDim.new(0, 1)}, sc)

    local clear = btn(parent, "Clear", UDim2.new(1, 0, 0, 26), UDim2.new(0, 0, 1, -26), false, 11)

    local log = {count = 0}
    function log.add(text, color)
        log.count = log.count + 1
        make("TextLabel", {
            Size = UDim2.new(1, -4, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Text = tostring(text),
            TextColor3 = color or C.White,
            Font = Enum.Font.Code,
            TextSize = 11,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            LayoutOrder = log.count,
        }, sc)
        local kids = {}
        for _, k in ipairs(sc:GetChildren()) do if k:IsA("TextLabel") then kids[#kids+1] = k end end
        if #kids > Config.MaxLogs then kids[1]:Destroy() end
        task.defer(function() sc.CanvasPosition = Vector2.new(0, 99999) end)
    end
    function log.clear()
        for _, k in ipairs(sc:GetChildren()) do if k:IsA("TextLabel") then k:Destroy() end end
    end
    clear.MouseButton1Click:Connect(log.clear)
    return log
end

local conLog = makeLog(consolePage)

local function typeTag(t)
    if t == Enum.MessageType.MessageError then return "[ERR] ", C.Error end
    if t == Enum.MessageType.MessageWarning then return "[WARN] ", C.Warning end
    if t == Enum.MessageType.MessageInfo then return "[INFO] ", C.Info end
    return "", C.White
end

pcall(function()
    for _, m in ipairs(LogService:GetLogHistory()) do
        local tag, col = typeTag(m.messageType)
        conLog.add(tag .. m.message, col)
    end
    LogService.MessageOut:Connect(function(msg, t)
        local tag, col = typeTag(t)
        conLog.add(tag .. msg, col)
    end)
end)

-- ==================== PAGE: SETTINGS ====================
local setPage = newPage("Settings")
newTab("Settings", "⚙", true)

make("TextLabel", {
    Size = UDim2.new(1, 0, 0, 22),
    BackgroundTransparency = 1,
    Text = "Settings",
    TextColor3 = C.White,
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
}, setPage)

local setScroll = make("ScrollingFrame", {
    Size = UDim2.new(1, 0, 1, -28),
    Position = UDim2.fromOffset(0, 26),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = C.Gray,
    CanvasSize = UDim2.new(),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, setPage)
make("UIListLayout", {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder}, setScroll)

local function section(title)
    local f = make("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = C.Panel,
        BorderSizePixel = 0,
        LayoutOrder = 1,
    }, setScroll)
    corner(f, 8)
    stroke(f)
    pad(f, 8, 8, 8, 8)
    make("TextLabel", {
        Size = UDim2.new(1, 0, 0, 18),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = C.White,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, f)
    return f
end

local function optionRow(parent, label, options, initial, cb)
    local row = make("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        LayoutOrder = 2,
    }, parent)
    make("TextLabel", {
        Size = UDim2.new(0.35, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = C.Gray,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, row)
    local chosen = initial
    local w = 0.62 / #options
    for i, opt in ipairs(options) do
        local b = make("TextButton", {
            Size = UDim2.new(w, -3, 0, 24),
            Position = UDim2.new(0.36 + (i-1)*w, 0, 0.5, -12),
            BackgroundColor3 = (opt == chosen) and C.White or C.Panel2,
            Text = opt,
            TextColor3 = (opt == chosen) and C.Black or C.White,
            Font = Enum.Font.GothamBold,
            TextSize = 10,
            AutoButtonColor = false,
            BorderSizePixel = 0,
        }, row)
        corner(b, 5)
        b.MouseButton1Click:Connect(function()
            chosen = opt
            for _, s in ipairs(row:GetChildren()) do
                if s:IsA("TextButton") then
                    local on = s.Text == chosen
                    s.BackgroundColor3 = on and C.White or C.Panel2
                    s.TextColor3 = on and C.Black or C.White
                end
            end
            cb(opt)
        end)
    end
end

local floatSec = section("Floating Icon")
optionRow(floatSec, "Size", {"Small", "Medium", "Large"}, "Medium", function(v)
    floatSize = ({Small=34, Medium=46, Large=58})[v]
    floatBtn.Size = UDim2.fromOffset(floatSize, floatSize)
    floatBtn.TextSize = v == "Small" and 13 or (v == "Large" and 20 or 16)
end)
optionRow(floatSec, "Shape", {"Circle", "Round", "Square"}, "Round", function(v)
    local r = v == "Circle" and UDim.new(0.5, 0) or (v == "Square" and UDim.new(0, 3) or UDim.new(0, 14))
    floatBtn:FindFirstChildOfClass("UICorner").CornerRadius = r
end)

local infoSec = section("About")
make("TextLabel", {
    Size = UDim2.new(1, 0, 0, 50),
    BackgroundTransparency = 1,
    Text = "EnforX v" .. Config.Version .. "\nBlack & White • No Key System\nInspired by Delta layout",
    TextColor3 = C.Gray,
    Font = Enum.Font.Gotham,
    TextSize = 11,
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    LayoutOrder = 3,
}, infoSec)

-- ==================== CLOSE / MINIMIZE ====================
local function hideWin()
    win.Visible = false
    floatBtn.Visible = true
end
local function showWin()
    floatBtn.Visible = false
    win.Visible = true
end

minBtn.MouseButton1Click:Connect(hideWin)
closeBtn.MouseButton1Click:Connect(hideWin)
floatBtn.MouseButton1Click:Connect(showWin)

-- ==================== LOAD ICON ====================
task.spawn(function()
    local img = remoteImage(Config.IconURL, "enforx_icon.png")
    if img then titleIcon.Image = img end
end)

-- ==================== RESPONSIVE ====================
if cam then
    cam:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        local size = cam.ViewportSize
        W = math.clamp(math.floor(size.X * 0.92), 320, 520)
        H = math.clamp(math.floor(size.Y * 0.72), 280, 420)
        if win.Visible then
            win.Size = UDim2.fromOffset(W, H)
            win.Position = UDim2.new(0.5, -W/2, 0.5, -H/2)
        end
    end)
end

-- ==================== START ====================
selectTab("Home")
print("[EnforX] UI Loaded v" .. Config.Version)

return gui
