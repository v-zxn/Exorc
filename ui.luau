--[[
    EnforX UI - Wide • Pure Black & White • Clean Icons
    Version: 1.2.0
    By M4X • EVA • AMAL • JANA
]]

local Players           = game:GetService("Players")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local CoreGui           = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

--// ==================== LOCALIZATION ====================
local Languages = {
    en = {
        Title           = "EnforX",
        Executor        = "Executor",
        Scripts         = "Scripts",
        Misc            = "Misc",
        Hub             = "Hub",
        Console         = "Console",
        Settings        = "Settings",
        Run             = "Run",
        Clear           = "Clear",
        Paste           = "Paste",
        Copy            = "Copy",
        SaveCurrent     = "Save Current",
        Load            = "Load",
        Delete          = "Delete",
        ComingSoon      = "Coming Soon...\n\nThis tab is reserved for future features.",
        OrcConsole      = "ORC Console",
        RobloxConsole   = "Roblox Console",
        Language        = "Language",
        Theme           = "Theme",
        PlaceholderCode = "-- Write your code here\nprint(\"Hello from EnforX\")",
        SavedScripts    = "Saved Scripts",
        NoClipboard     = "Clipboard not available",
        UILoaded        = "UI Loaded Successfully",
        Ready           = "Interface Ready",
    },
    ar = {
        Title           = "إنفور إكس",
        Executor        = "المنفذ",
        Scripts         = "السكريبتات",
        Misc            = "متنوع",
        Hub             = "البحث",
        Console         = "الكونسول",
        Settings        = "الإعدادات",
        Run             = "تشغيل",
        Clear           = "مسح",
        Paste           = "لصق",
        Copy            = "نسخ",
        SaveCurrent     = "حفظ الحالي",
        Load            = "تحميل",
        Delete          = "حذف",
        ComingSoon      = "قريباً...\n\nهذا التاب محجوز لمميزات مستقبلية.",
        OrcConsole      = "كونسول ORC",
        RobloxConsole   = "كونسول روبلوكس",
        Language        = "اللغة",
        Theme           = "السمة",
        PlaceholderCode = "-- اكتب الكود هنا\nprint(\"مرحباً من إنفور إكس\")",
        SavedScripts    = "السكريبتات المحفوظة",
        NoClipboard     = "الحافظة غير متاحة",
        UILoaded        = "تم تحميل الواجهة بنجاح",
        Ready           = "الواجهة جاهزة",
    },
    ru = {
        Title           = "EnforX",
        Executor        = "Исполнитель",
        Scripts         = "Скрипты",
        Misc            = "Разное",
        Hub             = "Поиск",
        Console         = "Консоль",
        Settings        = "Настройки",
        Run             = "Запуск",
        Clear           = "Очистить",
        Paste           = "Вставить",
        Copy            = "Копировать",
        SaveCurrent     = "Сохранить",
        Load            = "Загрузить",
        Delete          = "Удалить",
        ComingSoon      = "Скоро...\n\nЭта вкладка зарезервирована.",
        OrcConsole      = "ORC Консоль",
        RobloxConsole   = "Roblox Консоль",
        Language        = "Язык",
        Theme           = "Тема",
        PlaceholderCode = "-- Напишите код здесь\nprint(\"Привет от EnforX\")",
        SavedScripts    = "Сохранённые скрипты",
        NoClipboard     = "Буфер обмена недоступен",
        UILoaded        = "Интерфейс успешно загружен",
        Ready           = "Интерфейс готов",
    },
}

local CurrentLang = "en"
local function L(key)
    return (Languages[CurrentLang] and Languages[CurrentLang][key]) or Languages.en[key] or key
end

--// ==================== PURE B&W CONFIG ====================
local Config = {
    Bg          = Color3.fromRGB(12, 12, 12),
    BgSecondary = Color3.fromRGB(20, 20, 20),
    BgTertiary  = Color3.fromRGB(32, 32, 32),
    BgHover     = Color3.fromRGB(42, 42, 42),
    Text        = Color3.fromRGB(245, 245, 245),
    TextDim     = Color3.fromRGB(140, 140, 140),
    Border      = Color3.fromRGB(50, 50, 50),
    Accent      = Color3.fromRGB(255, 255, 255), -- white accent
    -- Console only colors
    Success     = Color3.fromRGB(80, 200, 120),
    Warning     = Color3.fromRGB(230, 180, 40),
    Error       = Color3.fromRGB(230, 70, 70),
    Info        = Color3.fromRGB(100, 160, 255),
}

local IconURL   = "https://raw.githubusercontent.com/MITTO-m4x/Neo_EVADE/main/EVADE/scr/Photo/Icon.png"
local BannerURL = "https://raw.githubusercontent.com/MITTO-m4x/Neo_EVADE/main/EVADE/scr/Photo/Icon2.png"
local SearchAPI = "https://scriptblox.com/api/script/search?q="


--// ==================== UTILITIES ====================
local function Create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then inst[k] = v end
    end
    if props and props.Parent then inst.Parent = props.Parent end
    return inst
end

local function Tween(obj, props, duration)
    local t = TweenService:Create(obj, TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local function Corner(parent, radius)
    return Create("UICorner", {CornerRadius = UDim.new(0, radius or 8), Parent = parent})
end

local function Stroke(parent, color, thickness)
    return Create("UIStroke", {
        Color = color or Config.Border,
        Thickness = thickness or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = parent
    })
end

local function Padding(parent, t, b, l, r)
    return Create("UIPadding", {
        PaddingTop = UDim.new(0, t or 0),
        PaddingBottom = UDim.new(0, b or 0),
        PaddingLeft = UDim.new(0, l or 0),
        PaddingRight = UDim.new(0, r or 0),
        Parent = parent
    })
end

local function MakeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragStart, startPos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local function ProtectGui(gui)
    pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(gui) end
        if protect_gui then protect_gui(gui) end
    end)
    task.spawn(function()
        while task.wait(1.5) do
            if not gui or not gui.Parent then
                pcall(function()
                    gui.Parent = (gethui and gethui()) or CoreGui
                end)
            end
        end
    end)
end

--// ==================== ROOT ====================
local ScreenGui = Create("ScreenGui", {
    Name = "EnforX_UI_" .. math.random(10000, 99999),
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 999,
    IgnoreGuiInset = true,
})

pcall(function()
    ScreenGui.Parent = (gethui and gethui()) or CoreGui
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end
ProtectGui(ScreenGui)

local function httpGet(url)
    local req = request or http_request
    if req then
        local r = req({Url = url, Method = "GET"})
        return r and r.Body
    elseif game.HttpGet then
        return game:HttpGet(url)
    end
    local ok, res = pcall(function() return game:GetService("HttpService"):GetAsync(url) end)
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

-- ==================== MAIN (Wider) ====================
local Main = Create("Frame", {
    Name = "Main",
    Size = UDim2.new(0, 460, 0, 360),
    Position = UDim2.new(0.5, -230, 0.5, -180),
    BackgroundColor3 = Config.Bg,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Parent = ScreenGui,
})
Corner(Main, 14)
local MainStroke = Stroke(Main, Config.Border, 1)

Create("ImageLabel", {
    Name = "Shadow",
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 50, 1, 50),
    Position = UDim2.new(0, -25, 0, -25),
    Image = "rbxassetid://6014266941",
    ImageColor3 = Color3.fromRGB(0, 0, 0),
    ImageTransparency = 0.5,
    ScaleType = Enum.ScaleType.Slice,
    SliceCenter = Rect.new(49, 49, 450, 450),
    ZIndex = 0,
    Parent = Main,
})

-- Title Bar
local TitleBar = Create("Frame", {
    Name = "TitleBar",
    Size = UDim2.new(1, 0, 0, 42),
    BackgroundColor3 = Config.BgSecondary,
    BorderSizePixel = 0,
    Parent = Main,
})
Corner(TitleBar, 14)
Create("Frame", {
    Size = UDim2.new(1, 0, 0, 14),
    Position = UDim2.new(0, 0, 1, -14),
    BackgroundColor3 = Config.BgSecondary,
    BorderSizePixel = 0,
    Parent = TitleBar,
})

local TitleIcon = Create("ImageLabel", {
    Name = "Icon",
    Size = UDim2.new(0, 22, 0, 22),
    Position = UDim2.new(0, 10, 0.5, -11),
    BackgroundTransparency = 1,
    Image = "",
    ScaleType = Enum.ScaleType.Fit,
    Parent = TitleBar,
})

local TitleLabel = Create("TextLabel", {
    Name = "Title",
    Size = UDim2.new(1, -100, 1, 0),
    Position = UDim2.new(0, 38, 0, 0),
    BackgroundTransparency = 1,
    Text = L("Title") .. "  •  v1.2",
    TextColor3 = Config.Text,
    TextSize = 14,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = TitleBar,
})

task.spawn(function()
    local img = remoteImage(IconURL, "enforx_icon.png")
    if img then TitleIcon.Image = img end
end)

local MinBtn = Create("TextButton", {
    Name = "Minimize",
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(1, -38, 0.5, -15),
    BackgroundColor3 = Config.BgTertiary,
    Text = "─",
    TextColor3 = Config.Text,
    TextSize = 14,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
    Parent = TitleBar,
})
Corner(MinBtn, 8)

MinBtn.MouseEnter:Connect(function() Tween(MinBtn, {BackgroundColor3 = Config.BgHover}, 0.15) end)
MinBtn.MouseLeave:Connect(function() Tween(MinBtn, {BackgroundColor3 = Config.BgTertiary}, 0.15) end)

MakeDraggable(Main, TitleBar)

-- ==================== SIDEBAR ====================
local Sidebar = Create("Frame", {
    Name = "Sidebar",
    Size = UDim2.new(0, 56, 1, -42),
    Position = UDim2.new(0, 0, 0, 42),
    BackgroundColor3 = Config.BgSecondary,
    BorderSizePixel = 0,
    Parent = Main,
})

Create("UIListLayout", {
    Padding = UDim.new(0, 5),
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = Sidebar,
})
Padding(Sidebar, 10, 10, 0, 0)

local Content = Create("Frame", {
    Name = "Content",
    Size = UDim2.new(1, -56, 1, -42),
    Position = UDim2.new(0, 56, 0, 42),
    BackgroundColor3 = Config.Bg,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Parent = Main,
})

-- Clean icons (Lucide / WindUI style - text based, no colorful emoji)
local TabData = {
    {Key = "Executor", Icon = "</>" },
    {Key = "Scripts",  Icon = "≡"  },
    {Key = "Misc",     Icon = "◆"  },
    {Key = "Hub",      Icon = "⌕"  },
    {Key = "Settings", Icon = "⚙"  },
}

local Pages = {}
local TabButtons = {}
local CurrentTab = 1

local function SwitchTab(index)
    if CurrentTab == index then return end
    CurrentTab = index
    for i, page in pairs(Pages) do
        page.Visible = (i == index)
    end
    for i, btn in pairs(TabButtons) do
        if i == index then
            Tween(btn, {BackgroundColor3 = Config.Accent}, 0.18)
            btn.TextColor3 = Config.Bg
        else
            Tween(btn, {BackgroundColor3 = Config.BgTertiary}, 0.18)
            btn.TextColor3 = Config.TextDim
        end
    end
end

for i, tab in ipairs(TabData) do
    local btn = Create("TextButton", {
        Name = tab.Key,
        Size = UDim2.new(0, 42, 0, 42),
        BackgroundColor3 = (i == 1) and Config.Accent or Config.BgTertiary,
        Text = tab.Icon,
        TextColor3 = (i == 1) and Config.Bg or Config.TextDim,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        LayoutOrder = i,
        Parent = Sidebar,
    })
    Corner(btn, 10)

    btn.MouseEnter:Connect(function()
        if CurrentTab ~= i then
            Tween(btn, {BackgroundColor3 = Config.BgHover}, 0.12)
        end
    end)
    btn.MouseLeave:Connect(function()
        if CurrentTab ~= i then
            Tween(btn, {BackgroundColor3 = Config.BgTertiary}, 0.12)
        end
    end)
    btn.MouseButton1Click:Connect(function()
        SwitchTab(i)
    end)

    TabButtons[i] = btn
end

-- ==================== ACTION BUTTON ====================
local function CreateActionButton(text, isPrimary, size, parent)
    local bg = isPrimary and Config.Accent or Config.BgTertiary
    local fg = isPrimary and Config.Bg or Config.Text

    local b = Create("TextButton", {
        Size = size or UDim2.new(0, 80, 0, 32),
        BackgroundColor3 = bg,
        Text = text,
        TextColor3 = fg,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        Parent = parent,
    })
    Corner(b, 7)

    b.MouseEnter:Connect(function()
        if isPrimary then
            Tween(b, {BackgroundColor3 = Color3.fromRGB(220, 220, 220)}, 0.12)
        else
            Tween(b, {BackgroundColor3 = Config.BgHover}, 0.12)
        end
    end)
    b.MouseLeave:Connect(function()
        Tween(b, {BackgroundColor3 = bg}, 0.12)
    end)
    return b
end

-- ==================== PAGE 1: EXECUTOR ====================
local ExecutorPage = Create("Frame", {
    Name = "Executor",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Visible = true,
    Parent = Content,
})
Pages[1] = ExecutorPage

local ExecTitle = Create("TextLabel", {
    Size = UDim2.new(1, -16, 0, 26),
    Position = UDim2.new(0, 10, 0, 8),
    BackgroundTransparency = 1,
    Text = L("Executor"),
    TextColor3 = Config.Text,
    TextSize = 14,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = ExecutorPage,
})

local CodeBox = Create("TextBox", {
    Name = "Code",
    Size = UDim2.new(1, -16, 1, -92),
    Position = UDim2.new(0, 8, 0, 36),
    BackgroundColor3 = Config.BgSecondary,
    Text = L("PlaceholderCode"),
    TextColor3 = Config.Text,
    PlaceholderText = "...",
    PlaceholderColor3 = Config.TextDim,
    TextSize = 13,
    Font = Enum.Font.Code,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    MultiLine = true,
    ClearTextOnFocus = false,
    TextWrapped = true,
    BorderSizePixel = 0,
    Parent = ExecutorPage,
})
Corner(CodeBox, 9)
Padding(CodeBox, 10, 10, 10, 10)
Stroke(CodeBox, Config.Border, 1)

local ExecBtnHolder = Create("Frame", {
    Size = UDim2.new(1, -16, 0, 36),
    Position = UDim2.new(0, 8, 1, -44),
    BackgroundTransparency = 1,
    Parent = ExecutorPage,
})

local RunBtn   = CreateActionButton(L("Run"),   true,  UDim2.new(0, 78, 0, 32), ExecBtnHolder)
local ClearBtn = CreateActionButton(L("Clear"), false, UDim2.new(0, 78, 0, 32), ExecBtnHolder)
local PasteBtn = CreateActionButton(L("Paste"), false, UDim2.new(0, 78, 0, 32), ExecBtnHolder)
local CopyBtn  = CreateActionButton(L("Copy"),  false, UDim2.new(0, 78, 0, 32), ExecBtnHolder)

RunBtn.Position   = UDim2.new(0, 0, 0, 0)
ClearBtn.Position = UDim2.new(0, 84, 0, 0)
PasteBtn.Position = UDim2.new(0, 168, 0, 0)
CopyBtn.Position  = UDim2.new(0, 252, 0, 0)

RunBtn.MouseButton1Click:Connect(function()
    local src = CodeBox.Text
    if src and #src > 0 then
        local fn, err = loadstring(src)
        if fn then
            task.spawn(function()
                local ok, result = pcall(fn)
                if not ok then warn("[EnforX] " .. tostring(result)) end
            end)
        else
            warn("[EnforX] " .. tostring(err))
        end
    end
end)

ClearBtn.MouseButton1Click:Connect(function() CodeBox.Text = "" end)

PasteBtn.MouseButton1Click:Connect(function()
    local ok, clip = pcall(function()
        if getclipboard then return getclipboard() end
        if syn and syn.clipboard then return syn.clipboard end
        return nil
    end)
    if ok and type(clip) == "string" then
        CodeBox.Text = clip
    else
        warn("[EnforX] " .. L("NoClipboard"))
    end
end)

CopyBtn.MouseButton1Click:Connect(function()
    pcall(function()
        if setclipboard then setclipboard(CodeBox.Text)
        elseif toclipboard then toclipboard(CodeBox.Text)
        elseif syn and syn.write_clipboard then syn.write_clipboard(CodeBox.Text) end
    end)
end)

-- ==================== PAGE 2: SCRIPTS ====================
local ScriptsPage = Create("Frame", {
    Name = "Scripts",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Visible = false,
    Parent = Content,
})
Pages[2] = ScriptsPage

local ScriptsTitle = Create("TextLabel", {
    Size = UDim2.new(1, -16, 0, 26),
    Position = UDim2.new(0, 10, 0, 8),
    BackgroundTransparency = 1,
    Text = L("SavedScripts"),
    TextColor3 = Config.Text,
    TextSize = 14,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = ScriptsPage,
})

local ScriptsList = Create("ScrollingFrame", {
    Size = UDim2.new(1, -16, 1, -86),
    Position = UDim2.new(0, 8, 0, 38),
    BackgroundColor3 = Config.BgSecondary,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = Color3.fromRGB(180, 180, 180),
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    Parent = ScriptsPage,
})
Corner(ScriptsList, 9)
Padding(ScriptsList, 8, 8, 8, 8)
Create("UIListLayout", {
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = ScriptsList,
})

local SavedScripts = {}

local function RefreshScriptsList()
    for _, child in ipairs(ScriptsList:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    for i, data in ipairs(SavedScripts) do
        local item = Create("Frame", {
            Size = UDim2.new(1, -4, 0, 38),
            BackgroundColor3 = Config.BgTertiary,
            BorderSizePixel = 0,
            LayoutOrder = i,
            Parent = ScriptsList,
        })
        Corner(item, 7)

        Create("TextLabel", {
            Size = UDim2.new(1, -118, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text = data.name,
            TextColor3 = Config.Text,
            TextSize = 12,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Parent = item,
        })

        local loadB = Create("TextButton", {
            Size = UDim2.new(0, 48, 0, 24),
            Position = UDim2.new(1, -104, 0.5, -12),
            BackgroundColor3 = Config.Accent,
            Text = L("Load"),
            TextColor3 = Config.Bg,
            TextSize = 11,
            Font = Enum.Font.GothamBold,
            AutoButtonColor = false,
            Parent = item,
        })
        Corner(loadB, 5)

        local delB = Create("TextButton", {
            Size = UDim2.new(0, 48, 0, 24),
            Position = UDim2.new(1, -50, 0.5, -12),
            BackgroundColor3 = Config.BgHover,
            Text = L("Delete"),
            TextColor3 = Config.Text,
            TextSize = 11,
            Font = Enum.Font.GothamBold,
            AutoButtonColor = false,
            Parent = item,
        })
        Corner(delB, 5)

        loadB.MouseButton1Click:Connect(function()
            CodeBox.Text = data.source
            SwitchTab(1)
        end)
        delB.MouseButton1Click:Connect(function()
            table.remove(SavedScripts, i)
            RefreshScriptsList()
        end)
    end
end

local SaveBtn = CreateActionButton(L("SaveCurrent"), true, UDim2.new(0, 120, 0, 32), ScriptsPage)
SaveBtn.Position = UDim2.new(0, 8, 1, -44)

SaveBtn.MouseButton1Click:Connect(function()
    table.insert(SavedScripts, {
        name = "Script_" .. (#SavedScripts + 1),
        source = CodeBox.Text
    })
    RefreshScriptsList()
end)

-- ==================== PAGE 3: MISC ====================
local MiscPage = Create("Frame", {
    Name = "Misc",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Visible = false,
    Parent = Content,
})
Pages[3] = MiscPage

local MiscLabel = Create("TextLabel", {
    Size = UDim2.new(1, -20, 1, -20),
    Position = UDim2.new(0, 10, 0, 10),
    BackgroundTransparency = 1,
    Text = L("ComingSoon"),
    TextColor3 = Config.TextDim,
    TextSize = 13,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Center,
    TextYAlignment = Enum.TextYAlignment.Center,
    Parent = MiscPage,
})

-- ==================== PAGE 4: HUB (Script Search) ====================
local HubPage = Create("Frame", {
    Name = "Hub",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Visible = false,
    Parent = Content,
})
Pages[4] = HubPage

local HubSearch = Create("TextBox", {
    Size = UDim2.new(1, -16, 0, 32),
    Position = UDim2.new(0, 8, 0, 8),
    BackgroundColor3 = Config.BgSecondary,
    Text = "",
    PlaceholderText = "Search scripts + Enter...",
    PlaceholderColor3 = Config.TextDim,
    TextColor3 = Config.Text,
    TextSize = 12,
    Font = Enum.Font.Gotham,
    ClearTextOnFocus = false,
    TextXAlignment = Enum.TextXAlignment.Left,
    BorderSizePixel = 0,
    Parent = HubPage,
})
Corner(HubSearch, 8)
Stroke(HubSearch, Config.Border, 1)
Padding(HubSearch, 0, 0, 10, 10)

local HubMsg = Create("TextLabel", {
    Size = UDim2.new(1, -16, 0, 20),
    Position = UDim2.new(0, 8, 0, 44),
    BackgroundTransparency = 1,
    Text = "Type a keyword and press Enter",
    TextColor3 = Config.TextDim,
    TextSize = 11,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = HubPage,
})

local HubHolder = Create("ScrollingFrame", {
    Size = UDim2.new(1, -16, 1, -72),
    Position = UDim2.new(0, 8, 0, 66),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = Color3.fromRGB(160, 160, 160),
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    Parent = HubPage,
})
Create("UIGridLayout", {
    CellSize = UDim2.new(0.5, -6, 0, 56),
    CellPadding = UDim2.new(0, 6, 0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = HubHolder,
})

-- Popup for selected script
local HubPopup = Create("Frame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    BackgroundTransparency = 0.35,
    Visible = false,
    ZIndex = 20,
    Active = true,
    Parent = HubPage,
})

local HubCard = Create("Frame", {
    Size = UDim2.new(0, 220, 0, 150),
    Position = UDim2.new(0.5, -110, 0.5, -75),
    BackgroundColor3 = Config.BgSecondary,
    BorderSizePixel = 0,
    ZIndex = 21,
    Parent = HubPopup,
})
Corner(HubCard, 10)
Stroke(HubCard, Config.Border, 1)

local PopTitle = Create("TextLabel", {
    Size = UDim2.new(1, -16, 0, 28),
    Position = UDim2.new(0, 8, 0, 6),
    BackgroundTransparency = 1,
    Text = "",
    TextColor3 = Config.Text,
    TextSize = 13,
    Font = Enum.Font.GothamBold,
    TextTruncate = Enum.TextTruncate.AtEnd,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 22,
    Parent = HubCard,
})

local function PopBtn(text, y, primary)
    local bg = primary and Config.Accent or Config.BgTertiary
    local fg = primary and Config.Bg or Config.Text
    local b = Create("TextButton", {
        Size = UDim2.new(1, -16, 0, 28),
        Position = UDim2.new(0, 8, 0, y),
        BackgroundColor3 = bg,
        Text = text,
        TextColor3 = fg,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        ZIndex = 22,
        Parent = HubCard,
    })
    Corner(b, 7)
    return b
end

local PExec  = PopBtn("Execute", 40, true)
local PEdit  = PopBtn("Open in Executor", 72, false)
local PCopy  = PopBtn("Copy", 104, false)
local PClose = PopBtn("Close", 136, false)

local SelectedScript = {title = "", source = ""}

PClose.MouseButton1Click:Connect(function() HubPopup.Visible = false end)

PExec.MouseButton1Click:Connect(function()
    HubPopup.Visible = false
    if SelectedScript.source and #SelectedScript.source > 0 then
        local fn, err = loadstring(SelectedScript.source)
        if fn then
            task.spawn(function()
                local ok, result = pcall(fn)
                if not ok then warn("[EnforX] " .. tostring(result)) end
            end)
        else
            warn("[EnforX] " .. tostring(err))
        end
    end
end)

PEdit.MouseButton1Click:Connect(function()
    if SelectedScript.source then
        CodeBox.Text = SelectedScript.source
    end
    HubPopup.Visible = false
    SwitchTab(1)
end)

PCopy.MouseButton1Click:Connect(function()
    pcall(function()
        if setclipboard then setclipboard(SelectedScript.source)
        elseif toclipboard then toclipboard(SelectedScript.source) end
    end)
    HubPopup.Visible = false
end)

local function AddHubResult(title, gameName, source, verified, views)
    local card = Create("TextButton", {
        BackgroundColor3 = Config.BgSecondary,
        Text = "",
        AutoButtonColor = false,
        BorderSizePixel = 0,
        Parent = HubHolder,
    })
    Corner(card, 8)
    Stroke(card, Config.Border, 1)

    Create("TextLabel", {
        Size = UDim2.new(1, -12, 0, 18),
        Position = UDim2.new(0, 8, 0, 6),
        BackgroundTransparency = 1,
        Text = (verified and "[V] " or "") .. tostring(title),
        TextColor3 = Config.Text,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = card,
    })
    Create("TextLabel", {
        Size = UDim2.new(1, -12, 0, 14),
        Position = UDim2.new(0, 8, 0, 24),
        BackgroundTransparency = 1,
        Text = tostring(gameName),
        TextColor3 = Config.TextDim,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = card,
    })
    Create("TextLabel", {
        Size = UDim2.new(1, -12, 0, 12),
        Position = UDim2.new(0, 8, 0, 40),
        BackgroundTransparency = 1,
        Text = tostring(views) .. " views",
        TextColor3 = Config.TextDim,
        TextSize = 10,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = card,
    })

    card.MouseButton1Click:Connect(function()
        SelectedScript = {title = title, source = source}
        PopTitle.Text = tostring(title)
        HubPopup.Visible = true
    end)
end

HubSearch.FocusLost:Connect(function(enter)
    if not enter then return end
    local q = HubSearch.Text
    if q == "" then return end

    for _, child in ipairs(HubHolder:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    HubMsg.Text = "Searching..."
    HubMsg.Visible = true

    task.spawn(function()
        local ok, decoded = pcall(function()
            local body = httpGet(SearchAPI .. game:GetService("HttpService"):UrlEncode(q))
            if not body then return nil end
            return game:GetService("HttpService"):JSONDecode(body)
        end)

        if not ok or not decoded or not decoded.result then
            HubMsg.Text = "Search failed (HTTP not available?)"
            return
        end

        local n = 0
        for _, s in ipairs(decoded.result.scripts or {}) do
            if s.scriptType == "free" and s.isPatched == false then
                AddHubResult(s.title, (s.game and s.game.name) or "Universal", s.script, s.verified, s.views or 0)
                n = n + 1
            end
        end
        HubMsg.Visible = (n == 0)
        if n == 0 then HubMsg.Text = "No results" else HubMsg.Text = n .. " results" end
    end)
end)

-- ==================== PAGE 5: SETTINGS ====================
local SettingsPage = Create("Frame", {
    Name = "Settings",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Visible = false,
    Parent = Content,
})
Pages[5] = SettingsPage

local SettingsTitle = Create("TextLabel", {
    Size = UDim2.new(1, -16, 0, 26),
    Position = UDim2.new(0, 10, 0, 8),
    BackgroundTransparency = 1,
    Text = L("Settings"),
    TextColor3 = Config.Text,
    TextSize = 14,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = SettingsPage,
})

local SettingsScroll = Create("ScrollingFrame", {
    Size = UDim2.new(1, -16, 1, -40),
    Position = UDim2.new(0, 8, 0, 36),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = Color3.fromRGB(160, 160, 160),
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    Parent = SettingsPage,
})
Create("UIListLayout", {
    Padding = UDim.new(0, 10),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = SettingsScroll,
})
Padding(SettingsScroll, 4, 16, 0, 0)

-- Language
local LangSection = Create("Frame", {
    Size = UDim2.new(1, 0, 0, 86),
    BackgroundColor3 = Config.BgSecondary,
    BorderSizePixel = 0,
    LayoutOrder = 1,
    Parent = SettingsScroll,
})
Corner(LangSection, 9)

local LangLabel = Create("TextLabel", {
    Size = UDim2.new(1, -16, 0, 24),
    Position = UDim2.new(0, 12, 0, 8),
    BackgroundTransparency = 1,
    Text = L("Language"),
    TextColor3 = Config.Text,
    TextSize = 13,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = LangSection,
})

local LangHolder = Create("Frame", {
    Size = UDim2.new(1, -20, 0, 34),
    Position = UDim2.new(0, 10, 0, 38),
    BackgroundTransparency = 1,
    Parent = LangSection,
})

local LangButtons = {}
local function CreateLangBtn(code, label, x)
    local isActive = (CurrentLang == code)
    local b = Create("TextButton", {
        Size = UDim2.new(0, 100, 0, 30),
        Position = UDim2.new(0, x, 0, 0),
        BackgroundColor3 = isActive and Config.Accent or Config.BgTertiary,
        Text = label,
        TextColor3 = isActive and Config.Bg or Config.Text,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        Parent = LangHolder,
    })
    Corner(b, 7)
    LangButtons[code] = b
    return b
end

local EnBtn = CreateLangBtn("en", "English", 0)
local ArBtn = CreateLangBtn("ar", "عربي", 108)
local RuBtn = CreateLangBtn("ru", "Русский", 216)

local function ApplyLanguage(code)
    if not Languages[code] then return end
    CurrentLang = code

    TitleLabel.Text     = L("Title") .. "  •  v1.2"
    ExecTitle.Text      = L("Executor")
    ScriptsTitle.Text   = L("SavedScripts")
    SettingsTitle.Text  = L("Settings")
    MiscLabel.Text      = L("ComingSoon")
    OrcTitle.Text       = "  " .. L("OrcConsole")
    RbxTitle.Text       = "  " .. L("RobloxConsole")
    LangLabel.Text      = L("Language")

    RunBtn.Text   = L("Run")
    ClearBtn.Text = L("Clear")
    PasteBtn.Text = L("Paste")
    CopyBtn.Text  = L("Copy")
    SaveBtn.Text  = L("SaveCurrent")

    for c, b in pairs(LangButtons) do
        local active = (CurrentLang == c)
        b.BackgroundColor3 = active and Config.Accent or Config.BgTertiary
        b.TextColor3 = active and Config.Bg or Config.Text
    end

    RefreshScriptsList()
end

EnBtn.MouseButton1Click:Connect(function() ApplyLanguage("en") end)
ArBtn.MouseButton1Click:Connect(function() ApplyLanguage("ar") end)
RuBtn.MouseButton1Click:Connect(function() ApplyLanguage("ru") end)

-- ==================== FLOATING BUTTON ====================
local FloatingBtn = Create("TextButton", {
    Name = "FloatingReopen",
    Size = UDim2.new(0, 48, 0, 48),
    Position = UDim2.new(1, -68, 0.55, -24),
    BackgroundColor3 = Config.Accent,
    Text = "EX",
    TextColor3 = Config.Bg,
    TextSize = 14,
    Font = Enum.Font.GothamBlack,
    AutoButtonColor = false,
    Visible = false,
    ZIndex = 50,
    Parent = ScreenGui,
})
Corner(FloatingBtn, 24)
Stroke(FloatingBtn, Color3.fromRGB(255, 255, 255), 1.2)

Create("ImageLabel", {
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 26, 1, 26),
    Position = UDim2.new(0, -13, 0, -13),
    Image = "rbxassetid://6014266941",
    ImageColor3 = Color3.fromRGB(255, 255, 255),
    ImageTransparency = 0.65,
    ScaleType = Enum.ScaleType.Slice,
    SliceCenter = Rect.new(49, 49, 450, 450),
    ZIndex = 49,
    Parent = FloatingBtn,
})

MakeDraggable(FloatingBtn)

FloatingBtn.MouseEnter:Connect(function()
    Tween(FloatingBtn, {Size = UDim2.new(0, 54, 0, 54)}, 0.15)
end)
FloatingBtn.MouseLeave:Connect(function()
    Tween(FloatingBtn, {Size = UDim2.new(0, 48, 0, 48)}, 0.15)
end)

MinBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    FloatingBtn.Visible = true
end)

FloatingBtn.MouseButton1Click:Connect(function()
    FloatingBtn.Visible = false
    Main.Visible = true
end)

-- ==================== FINAL ====================
getgenv().EnforX_ORCLog = function(msg, level) end

print("[EnforX] " .. L("UILoaded"))
-- EnforX_ORCLog("EnforX v1.2 • " .. L("Ready"), "info")

return {
    ScreenGui = ScreenGui,
    SwitchTab = SwitchTab,
    ApplyLanguage = ApplyLanguage,
    ORCLog = getgenv().EnforX_ORCLog,
}
