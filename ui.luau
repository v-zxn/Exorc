--[[
    EnforX UI - Mobile Optimized • Multi-Language • Multi-Theme
    Version: 1.1.0
    By M4X • EVA • AMAL • JANA
]]

local Players           = game:GetService("Players")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local RunService        = game:GetService("RunService")
local CoreGui           = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

--// ==================== LOCALIZATION ====================
local Languages = {
    en = {
        Title           = "EnforX",
        Executor        = "Executor",
        Scripts         = "Scripts",
        Misc            = "Misc",
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
        ShowFPS         = "Show FPS",
        AutoRejoin      = "Auto Rejoin on Kick",
        PlaceholderCode = "-- Write your code here\nprint(\"Hello from EnforX\")",
        SavedScripts    = "Saved Scripts",
        NoClipboard     = "Clipboard not available",
        UILoaded        = "UI Loaded Successfully",
        Ready           = "Interface Ready",
        Minimize        = "─",
    },
    ar = {
        Title           = "إنفور إكس",
        Executor        = "المنفذ",
        Scripts         = "السكريبتات",
        Misc            = "متنوع",
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
        ShowFPS         = "إظهار الفريم",
        AutoRejoin      = "إعادة الدخول عند الطرد",
        PlaceholderCode = "-- اكتب الكود هنا\nprint(\"مرحباً من إنفور إكس\")",
        SavedScripts    = "السكريبتات المحفوظة",
        NoClipboard     = "الحافظة غير متاحة",
        UILoaded        = "تم تحميل الواجهة بنجاح",
        Ready           = "الواجهة جاهزة",
        Minimize        = "─",
    },
    ru = {
        Title           = "EnforX",
        Executor        = "Исполнитель",
        Scripts         = "Скрипты",
        Misc            = "Разное",
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
        ShowFPS         = "Показать FPS",
        AutoRejoin      = "Автореjoin при кике",
        PlaceholderCode = "-- Напишите код здесь\nprint(\"Привет от EnforX\")",
        SavedScripts    = "Сохранённые скрипты",
        NoClipboard     = "Буфер обмена недоступен",
        UILoaded        = "Интерфейс успешно загружен",
        Ready           = "Интерфейс готов",
        Minimize        = "─",
    },
}

local CurrentLang = "en"
local function L(key)
    return (Languages[CurrentLang] and Languages[CurrentLang][key]) or Languages.en[key] or key
end

--// ==================== THEMES ====================
local Themes = {
    Dark = {
        Accent      = Color3.fromRGB(59, 130, 246),
        AccentHover = Color3.fromRGB(96, 165, 250),
        Bg          = Color3.fromRGB(10, 10, 12),
        BgSecondary = Color3.fromRGB(16, 16, 20),
        BgTertiary  = Color3.fromRGB(26, 26, 32),
        Text        = Color3.fromRGB(245, 245, 245),
        TextDim     = Color3.fromRGB(150, 150, 160),
        Border      = Color3.fromRGB(40, 40, 48),
        Success     = Color3.fromRGB(34, 197, 94),
        Warning     = Color3.fromRGB(234, 179, 8),
        Error       = Color3.fromRGB(239, 68, 68),
        Info        = Color3.fromRGB(59, 130, 246),
    },
    Midnight = {
        Accent      = Color3.fromRGB(139, 92, 246),
        AccentHover = Color3.fromRGB(167, 139, 250),
        Bg          = Color3.fromRGB(8, 8, 14),
        BgSecondary = Color3.fromRGB(14, 14, 22),
        BgTertiary  = Color3.fromRGB(24, 24, 36),
        Text        = Color3.fromRGB(240, 240, 255),
        TextDim     = Color3.fromRGB(140, 140, 170),
        Border      = Color3.fromRGB(40, 40, 60),
        Success     = Color3.fromRGB(52, 211, 153),
        Warning     = Color3.fromRGB(251, 191, 36),
        Error       = Color3.fromRGB(248, 113, 113),
        Info        = Color3.fromRGB(139, 92, 246),
    },
    Ocean = {
        Accent      = Color3.fromRGB(14, 165, 233),
        AccentHover = Color3.fromRGB(56, 189, 248),
        Bg          = Color3.fromRGB(8, 12, 16),
        BgSecondary = Color3.fromRGB(12, 18, 24),
        BgTertiary  = Color3.fromRGB(20, 30, 40),
        Text        = Color3.fromRGB(240, 250, 255),
        TextDim     = Color3.fromRGB(130, 160, 180),
        Border      = Color3.fromRGB(30, 50, 65),
        Success     = Color3.fromRGB(45, 212, 191),
        Warning     = Color3.fromRGB(250, 204, 21),
        Error       = Color3.fromRGB(248, 113, 113),
        Info        = Color3.fromRGB(14, 165, 233),
    },
    Light = {
        Accent      = Color3.fromRGB(37, 99, 235),
        AccentHover = Color3.fromRGB(59, 130, 246),
        Bg          = Color3.fromRGB(245, 245, 247),
        BgSecondary = Color3.fromRGB(255, 255, 255),
        BgTertiary  = Color3.fromRGB(230, 230, 235),
        Text        = Color3.fromRGB(20, 20, 25),
        TextDim     = Color3.fromRGB(100, 100, 110),
        Border      = Color3.fromRGB(210, 210, 220),
        Success     = Color3.fromRGB(22, 163, 74),
        Warning     = Color3.fromRGB(202, 138, 4),
        Error       = Color3.fromRGB(220, 38, 38),
        Info        = Color3.fromRGB(37, 99, 235),
    },
}

local CurrentThemeName = "Dark"
local Config = Themes.Dark

--// ==================== UTILITIES ====================
local function Create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then
            inst[k] = v
        end
    end
    if props and props.Parent then
        inst.Parent = props.Parent
    end
    return inst
end

local function Tween(obj, props, duration)
    local t = TweenService:Create(obj, TweenInfo.new(duration or 0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local function Corner(parent, radius)
    return Create("UICorner", {CornerRadius = UDim.new(0, radius or 10), Parent = parent})
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

--// ==================== PROTECTION ====================
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

--// ==================== CREATE UI ROOT ====================
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

-- ==================== MAIN WINDOW (Phone Size) ====================
local Main = Create("Frame", {
    Name = "Main",
    Size = UDim2.new(0, 340, 0, 560),
    Position = UDim2.new(0.5, -170, 0.5, -280),
    BackgroundColor3 = Config.Bg,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Parent = ScreenGui,
})
Corner(Main, 16)
local MainStroke = Stroke(Main, Config.Border, 1)

-- Soft shadow
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
    Size = UDim2.new(1, 0, 0, 44),
    BackgroundColor3 = Config.BgSecondary,
    BorderSizePixel = 0,
    Parent = Main,
})
Corner(TitleBar, 16)
Create("Frame", {
    Size = UDim2.new(1, 0, 0, 16),
    Position = UDim2.new(0, 0, 1, -16),
    BackgroundColor3 = Config.BgSecondary,
    BorderSizePixel = 0,
    Parent = TitleBar,
})

local TitleLabel = Create("TextLabel", {
    Name = "Title",
    Size = UDim2.new(1, -90, 1, 0),
    Position = UDim2.new(0, 14, 0, 0),
    BackgroundTransparency = 1,
    Text = L("Title") .. "  •  v1.1",
    TextColor3 = Config.Text,
    TextSize = 15,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = TitleBar,
})

local MinBtn = Create("TextButton", {
    Name = "Minimize",
    Size = UDim2.new(0, 32, 0, 32),
    Position = UDim2.new(1, -40, 0.5, -16),
    BackgroundColor3 = Config.BgTertiary,
    Text = "─",
    TextColor3 = Config.Text,
    TextSize = 15,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
    Parent = TitleBar,
})
Corner(MinBtn, 9)

MinBtn.MouseEnter:Connect(function() Tween(MinBtn, {BackgroundColor3 = Config.Accent}, 0.15) end)
MinBtn.MouseLeave:Connect(function() Tween(MinBtn, {BackgroundColor3 = Config.BgTertiary}, 0.15) end)

MakeDraggable(Main, TitleBar)

-- ==================== SIDEBAR ====================
local Sidebar = Create("Frame", {
    Name = "Sidebar",
    Size = UDim2.new(0, 58, 1, -44),
    Position = UDim2.new(0, 0, 0, 44),
    BackgroundColor3 = Config.BgSecondary,
    BorderSizePixel = 0,
    Parent = Main,
})

local SideLayout = Create("UIListLayout", {
    Padding = UDim.new(0, 6),
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = Sidebar,
})
Padding(Sidebar, 10, 10, 0, 0)

local Content = Create("Frame", {
    Name = "Content",
    Size = UDim2.new(1, -58, 1, -44),
    Position = UDim2.new(0, 58, 0, 44),
    BackgroundColor3 = Config.Bg,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Parent = Main,
})

-- ==================== TABS DATA ====================
local TabData = {
    {Key = "Executor", Icon = "⌨️"},
    {Key = "Scripts",  Icon = "📁"},
    {Key = "Misc",     Icon = "⚡"},
    {Key = "Console",  Icon = "📟"},
    {Key = "Settings", Icon = "⚙️"},
}

local Pages = {}
local TabButtons = {}
local CurrentTab = 1
local UIElements = {} -- for live theme / language updates

local function SwitchTab(index)
    if CurrentTab == index then return end
    CurrentTab = index
    for i, page in pairs(Pages) do
        page.Visible = (i == index)
    end
    for i, btn in pairs(TabButtons) do
        if i == index then
            Tween(btn, {BackgroundColor3 = Config.Accent}, 0.18)
            btn.TextColor3 = Color3.new(1, 1, 1)
        else
            Tween(btn, {BackgroundColor3 = Config.BgTertiary}, 0.18)
            btn.TextColor3 = Config.TextDim
        end
    end
end

for i, tab in ipairs(TabData) do
    local btn = Create("TextButton", {
        Name = tab.Key,
        Size = UDim2.new(0, 44, 0, 44),
        BackgroundColor3 = (i == 1) and Config.Accent or Config.BgTertiary,
        Text = tab.Icon,
        TextColor3 = (i == 1) and Color3.new(1, 1, 1) or Config.TextDim,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        LayoutOrder = i,
        Parent = Sidebar,
    })
    Corner(btn, 11)

    btn.MouseEnter:Connect(function()
        if CurrentTab ~= i then
            Tween(btn, {BackgroundColor3 = Color3.fromRGB(50, 50, 60)}, 0.12)
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

-- ==================== HELPER: Action Button ====================
local function CreateActionButton(text, color, size, parent)
    local b = Create("TextButton", {
        Size = size or UDim2.new(0, 90, 0, 34),
        BackgroundColor3 = color,
        Text = text,
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        Parent = parent,
    })
    Corner(b, 8)
    b.MouseEnter:Connect(function()
        Tween(b, {BackgroundColor3 = color:Lerp(Color3.new(1,1,1), 0.12)}, 0.12)
    end)
    b.MouseLeave:Connect(function()
        Tween(b, {BackgroundColor3 = color}, 0.12)
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
    Size = UDim2.new(1, -16, 0, 28),
    Position = UDim2.new(0, 10, 0, 8),
    BackgroundTransparency = 1,
    Text = L("Executor"),
    TextColor3 = Config.Text,
    TextSize = 15,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = ExecutorPage,
})
UIElements.ExecTitle = ExecTitle

local CodeBox = Create("TextBox", {
    Name = "Code",
    Size = UDim2.new(1, -16, 1, -100),
    Position = UDim2.new(0, 8, 0, 38),
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
Corner(CodeBox, 10)
Padding(CodeBox, 10, 10, 10, 10)
local CodeStroke = Stroke(CodeBox, Config.Border, 1)
UIElements.CodeBox = CodeBox

local ExecBtnHolder = Create("Frame", {
    Size = UDim2.new(1, -16, 0, 40),
    Position = UDim2.new(0, 8, 1, -48),
    BackgroundTransparency = 1,
    Parent = ExecutorPage,
})

local RunBtn   = CreateActionButton(L("Run"),   Config.Accent,     UDim2.new(0, 72, 0, 34), ExecBtnHolder)
local ClearBtn = CreateActionButton(L("Clear"), Config.BgTertiary, UDim2.new(0, 72, 0, 34), ExecBtnHolder)
local PasteBtn = CreateActionButton(L("Paste"), Config.BgTertiary, UDim2.new(0, 72, 0, 34), ExecBtnHolder)
local CopyBtn  = CreateActionButton(L("Copy"),  Config.BgTertiary, UDim2.new(0, 72, 0, 34), ExecBtnHolder)

RunBtn.Position   = UDim2.new(0, 0, 0, 0)
ClearBtn.Position = UDim2.new(0, 78, 0, 0)
PasteBtn.Position = UDim2.new(0, 156, 0, 0)
CopyBtn.Position  = UDim2.new(0, 234, 0, 0)

UIElements.RunBtn = RunBtn
UIElements.ClearBtn = ClearBtn
UIElements.PasteBtn = PasteBtn
UIElements.CopyBtn = CopyBtn

RunBtn.MouseButton1Click:Connect(function()
    local src = CodeBox.Text
    if src and #src > 0 then
        local fn, err = loadstring(src)
        if fn then
            task.spawn(function()
                local ok, result = pcall(fn)
                if not ok then
                    warn("[EnforX] " .. tostring(result))
                end
            end)
        else
            warn("[EnforX] " .. tostring(err))
        end
    end
end)

ClearBtn.MouseButton1Click:Connect(function()
    CodeBox.Text = ""
end)

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
    Size = UDim2.new(1, -16, 0, 28),
    Position = UDim2.new(0, 10, 0, 8),
    BackgroundTransparency = 1,
    Text = L("SavedScripts"),
    TextColor3 = Config.Text,
    TextSize = 15,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = ScriptsPage,
})
UIElements.ScriptsTitle = ScriptsTitle

local ScriptsList = Create("ScrollingFrame", {
    Size = UDim2.new(1, -16, 1, -90),
    Position = UDim2.new(0, 8, 0, 40),
    BackgroundColor3 = Config.BgSecondary,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = Config.Accent,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    Parent = ScriptsPage,
})
Corner(ScriptsList, 10)
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
            Size = UDim2.new(1, -4, 0, 40),
            BackgroundColor3 = Config.BgTertiary,
            BorderSizePixel = 0,
            LayoutOrder = i,
            Parent = ScriptsList,
        })
        Corner(item, 8)

        Create("TextLabel", {
            Size = UDim2.new(1, -120, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text = data.name,
            TextColor3 = Config.Text,
            TextSize = 13,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Parent = item,
        })

        local loadB = Create("TextButton", {
            Size = UDim2.new(0, 50, 0, 26),
            Position = UDim2.new(1, -108, 0.5, -13),
            BackgroundColor3 = Config.Accent,
            Text = L("Load"),
            TextColor3 = Color3.new(1,1,1),
            TextSize = 11,
            Font = Enum.Font.GothamBold,
            AutoButtonColor = false,
            Parent = item,
        })
        Corner(loadB, 6)

        local delB = Create("TextButton", {
            Size = UDim2.new(0, 50, 0, 26),
            Position = UDim2.new(1, -52, 0.5, -13),
            BackgroundColor3 = Config.Error,
            Text = L("Delete"),
            TextColor3 = Color3.new(1,1,1),
            TextSize = 11,
            Font = Enum.Font.GothamBold,
            AutoButtonColor = false,
            Parent = item,
        })
        Corner(delB, 6)

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

local SaveBtn = CreateActionButton(L("SaveCurrent"), Config.Accent, UDim2.new(0, 130, 0, 34), ScriptsPage)
SaveBtn.Position = UDim2.new(0, 8, 1, -48)
UIElements.SaveBtn = SaveBtn

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
    TextSize = 14,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Center,
    TextYAlignment = Enum.TextYAlignment.Center,
    Parent = MiscPage,
})
UIElements.MiscLabel = MiscLabel

-- ==================== PAGE 4: CONSOLE ====================
local ConsolePage = Create("Frame", {
    Name = "Console",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Visible = false,
    Parent = Content,
})
Pages[4] = ConsolePage

-- ORC (Top half on mobile for better space)
local OrcFrame = Create("Frame", {
    Size = UDim2.new(1, -16, 0.5, -10),
    Position = UDim2.new(0, 8, 0, 8),
    BackgroundColor3 = Config.BgSecondary,
    BorderSizePixel = 0,
    Parent = ConsolePage,
})
Corner(OrcFrame, 10)
Stroke(OrcFrame, Config.Border, 1)

local OrcTitle = Create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 28),
    BackgroundColor3 = Config.BgTertiary,
    Text = "  " .. L("OrcConsole"),
    TextColor3 = Config.Text,
    TextSize = 12,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    BorderSizePixel = 0,
    Parent = OrcFrame,
})
Corner(OrcTitle, 10)
UIElements.OrcTitle = OrcTitle

local OrcScroll = Create("ScrollingFrame", {
    Size = UDim2.new(1, -8, 1, -34),
    Position = UDim2.new(0, 4, 0, 30),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = Config.Accent,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    Parent = OrcFrame,
})
Create("UIListLayout", {Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder, Parent = OrcScroll})

-- Roblox Console
local RbxFrame = Create("Frame", {
    Size = UDim2.new(1, -16, 0.5, -10),
    Position = UDim2.new(0, 8, 0.5, 2),
    BackgroundColor3 = Config.BgSecondary,
    BorderSizePixel = 0,
    Parent = ConsolePage,
})
Corner(RbxFrame, 10)
Stroke(RbxFrame, Config.Border, 1)

local RbxTitle = Create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 28),
    BackgroundColor3 = Config.BgTertiary,
    Text = "  " .. L("RobloxConsole"),
    TextColor3 = Config.Text,
    TextSize = 12,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    BorderSizePixel = 0,
    Parent = RbxFrame,
})
Corner(RbxTitle, 10)
UIElements.RbxTitle = RbxTitle

local RbxScroll = Create("ScrollingFrame", {
    Size = UDim2.new(1, -8, 1, -34),
    Position = UDim2.new(0, 4, 0, 30),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = Config.Accent,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    Parent = RbxFrame,
})
Create("UIListLayout", {Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder, Parent = RbxScroll})

local function AddLog(scroll, text, color)
    local lbl = Create("TextLabel", {
        Size = UDim2.new(1, -4, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Text = tostring(text),
        TextColor3 = color or Config.Text,
        TextSize = 11,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        RichText = true,
        Parent = scroll,
    })
    local count = 0
    for _, c in ipairs(scroll:GetChildren()) do
        if c:IsA("TextLabel") then count += 1 end
    end
    if count > 150 then
        for _, c in ipairs(scroll:GetChildren()) do
            if c:IsA("TextLabel") then c:Destroy() break end
        end
    end
    task.defer(function()
        scroll.CanvasPosition = Vector2.new(0, 99999)
    end)
end

getgenv().EnforX_ORCLog = function(msg, level)
    local color = Config.Text
    if level == "warn" then color = Config.Warning
    elseif level == "error" then color = Config.Error
    elseif level == "info" then color = Config.Info end
    AddLog(OrcScroll, msg, color)
end

local oldPrint, oldWarn = print, warn
print = function(...)
    local t = {}
    for i = 1, select("#", ...) do t[i] = tostring(select(i, ...)) end
    AddLog(RbxScroll, table.concat(t, "  "), Config.Text)
    return oldPrint(...)
end
warn = function(...)
    local t = {}
    for i = 1, select("#", ...) do t[i] = tostring(select(i, ...)) end
    AddLog(RbxScroll, "[WARN] " .. table.concat(t, "  "), Config.Warning)
    return oldWarn(...)
end

local function AddClear(parent, scroll)
    local btn = Create("TextButton", {
        Size = UDim2.new(0, 46, 0, 20),
        Position = UDim2.new(1, -52, 0, 4),
        BackgroundColor3 = Config.Bg,
        Text = L("Clear"),
        TextColor3 = Config.TextDim,
        TextSize = 10,
        Font = Enum.Font.Gotham,
        AutoButtonColor = false,
        Parent = parent,
    })
    Corner(btn, 5)
    btn.MouseButton1Click:Connect(function()
        for _, c in ipairs(scroll:GetChildren()) do
            if c:IsA("TextLabel") then c:Destroy() end
        end
    end)
end
AddClear(OrcFrame, OrcScroll)
AddClear(RbxFrame, RbxScroll)

AddLog(OrcScroll, "[ORC] " .. L("Ready"), Config.Info)
AddLog(RbxScroll, "[Roblox] Console hooked", Config.Success)

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
    Size = UDim2.new(1, -16, 0, 28),
    Position = UDim2.new(0, 10, 0, 8),
    BackgroundTransparency = 1,
    Text = L("Settings"),
    TextColor3 = Config.Text,
    TextSize = 15,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = SettingsPage,
})
UIElements.SettingsTitle = SettingsTitle

local SettingsScroll = Create("ScrollingFrame", {
    Size = UDim2.new(1, -16, 1, -44),
    Position = UDim2.new(0, 8, 0, 40),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = Config.Accent,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    Parent = SettingsPage,
})
local SettingsLayout = Create("UIListLayout", {
    Padding = UDim.new(0, 10),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = SettingsScroll,
})
Padding(SettingsScroll, 4, 20, 0, 0)

-- Language Section
local LangSection = Create("Frame", {
    Size = UDim2.new(1, 0, 0, 90),
    BackgroundColor3 = Config.BgSecondary,
    BorderSizePixel = 0,
    LayoutOrder = 1,
    Parent = SettingsScroll,
})
Corner(LangSection, 10)

local LangLabel = Create("TextLabel", {
    Size = UDim2.new(1, -16, 0, 26),
    Position = UDim2.new(0, 12, 0, 8),
    BackgroundTransparency = 1,
    Text = L("Language"),
    TextColor3 = Config.Text,
    TextSize = 13,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = LangSection,
})
UIElements.LangLabel = LangLabel

local LangHolder = Create("Frame", {
    Size = UDim2.new(1, -20, 0, 36),
    Position = UDim2.new(0, 10, 0, 40),
    BackgroundTransparency = 1,
    Parent = LangSection,
})

local LangButtons = {}
local function CreateLangBtn(code, label, x)
    local b = Create("TextButton", {
        Size = UDim2.new(0, 90, 0, 32),
        Position = UDim2.new(0, x, 0, 0),
        BackgroundColor3 = (CurrentLang == code) and Config.Accent or Config.BgTertiary,
        Text = label,
        TextColor3 = Color3.new(1,1,1),
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        Parent = LangHolder,
    })
    Corner(b, 8)
    LangButtons[code] = b
    return b
end

local EnBtn = CreateLangBtn("en", "English", 0)
local ArBtn = CreateLangBtn("ar", "عربي", 96)
local RuBtn = CreateLangBtn("ru", "Русский", 192)

-- Theme Section
local ThemeSection = Create("Frame", {
    Size = UDim2.new(1, 0, 0, 130),
    BackgroundColor3 = Config.BgSecondary,
    BorderSizePixel = 0,
    LayoutOrder = 2,
    Parent = SettingsScroll,
})
Corner(ThemeSection, 10)

local ThemeLabel = Create("TextLabel", {
    Size = UDim2.new(1, -16, 0, 26),
    Position = UDim2.new(0, 12, 0, 8),
    BackgroundTransparency = 1,
    Text = L("Theme"),
    TextColor3 = Config.Text,
    TextSize = 13,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = ThemeSection,
})
UIElements.ThemeLabel = ThemeLabel

local ThemeHolder = Create("Frame", {
    Size = UDim2.new(1, -16, 0, 80),
    Position = UDim2.new(0, 8, 0, 38),
    BackgroundTransparency = 1,
    Parent = ThemeSection,
})

local ThemeButtons = {}
local ThemeOrder = {"Dark", "Midnight", "Ocean", "Light"}
local ThemeDisplay = {Dark = "Dark", Midnight = "Midnight", Ocean = "Ocean", Light = "Light"}

local function CreateThemeBtn(name, index)
    local col = Themes[name].Accent
    local b = Create("TextButton", {
        Size = UDim2.new(0, 68, 0, 32),
        Position = UDim2.new(0, (index-1) * 74, 0, 0),
        BackgroundColor3 = (CurrentThemeName == name) and col or Config.BgTertiary,
        Text = ThemeDisplay[name],
        TextColor3 = Color3.new(1,1,1),
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        Parent = ThemeHolder,
    })
    Corner(b, 8)
    ThemeButtons[name] = b
    return b
end

for i, name in ipairs(ThemeOrder) do
    CreateThemeBtn(name, i)
end

-- Apply Theme Function
local function ApplyTheme(name)
    if not Themes[name] then return end
    CurrentThemeName = name
    Config = Themes[name]

    -- Update core colors
    Main.BackgroundColor3 = Config.Bg
    TitleBar.BackgroundColor3 = Config.BgSecondary
    TitleBar:FindFirstChildOfClass("Frame").BackgroundColor3 = Config.BgSecondary
    Sidebar.BackgroundColor3 = Config.BgSecondary
    Content.BackgroundColor3 = Config.Bg
    TitleLabel.TextColor3 = Config.Text
    MinBtn.BackgroundColor3 = Config.BgTertiary
    MinBtn.TextColor3 = Config.Text
    MainStroke.Color = Config.Border

    CodeBox.BackgroundColor3 = Config.BgSecondary
    CodeBox.TextColor3 = Config.Text
    CodeStroke.Color = Config.Border

    ScriptsList.BackgroundColor3 = Config.BgSecondary
    ScriptsList.ScrollBarImageColor3 = Config.Accent

    OrcFrame.BackgroundColor3 = Config.BgSecondary
    RbxFrame.BackgroundColor3 = Config.BgSecondary
    OrcTitle.BackgroundColor3 = Config.BgTertiary
    RbxTitle.BackgroundColor3 = Config.BgTertiary
    OrcTitle.TextColor3 = Config.Text
    RbxTitle.TextColor3 = Config.Text

    LangSection.BackgroundColor3 = Config.BgSecondary
    ThemeSection.BackgroundColor3 = Config.BgSecondary

    -- Buttons
    for i, btn in pairs(TabButtons) do
        if i == CurrentTab then
            btn.BackgroundColor3 = Config.Accent
            btn.TextColor3 = Color3.new(1,1,1)
        else
            btn.BackgroundColor3 = Config.BgTertiary
            btn.TextColor3 = Config.TextDim
        end
    end

    RunBtn.BackgroundColor3 = Config.Accent
    ClearBtn.BackgroundColor3 = Config.BgTertiary
    PasteBtn.BackgroundColor3 = Config.BgTertiary
    CopyBtn.BackgroundColor3 = Config.BgTertiary
    SaveBtn.BackgroundColor3 = Config.Accent

    for code, b in pairs(LangButtons) do
        b.BackgroundColor3 = (CurrentLang == code) and Config.Accent or Config.BgTertiary
    end
    for tname, b in pairs(ThemeButtons) do
        b.BackgroundColor3 = (CurrentThemeName == tname) and Themes[tname].Accent or Config.BgTertiary
    end

    -- Text colors
    ExecTitle.TextColor3 = Config.Text
    ScriptsTitle.TextColor3 = Config.Text
    SettingsTitle.TextColor3 = Config.Text
    MiscLabel.TextColor3 = Config.TextDim
    LangLabel.TextColor3 = Config.Text
    ThemeLabel.TextColor3 = Config.Text
end

-- Apply Language Function
local function ApplyLanguage(code)
    if not Languages[code] then return end
    CurrentLang = code

    TitleLabel.Text = L("Title") .. "  •  v1.1"
    ExecTitle.Text = L("Executor")
    ScriptsTitle.Text = L("SavedScripts")
    SettingsTitle.Text = L("Settings")
    MiscLabel.Text = L("ComingSoon")
    OrcTitle.Text = "  " .. L("OrcConsole")
    RbxTitle.Text = "  " .. L("RobloxConsole")
    LangLabel.Text = L("Language")
    ThemeLabel.Text = L("Theme")

    RunBtn.Text   = L("Run")
    ClearBtn.Text = L("Clear")
    PasteBtn.Text = L("Paste")
    CopyBtn.Text  = L("Copy")
    SaveBtn.Text  = L("SaveCurrent")

    for c, b in pairs(LangButtons) do
        b.BackgroundColor3 = (CurrentLang == c) and Config.Accent or Config.BgTertiary
    end

    RefreshScriptsList()
end

-- Connect language buttons
EnBtn.MouseButton1Click:Connect(function() ApplyLanguage("en") end)
ArBtn.MouseButton1Click:Connect(function() ApplyLanguage("ar") end)
RuBtn.MouseButton1Click:Connect(function() ApplyLanguage("ru") end)

-- Connect theme buttons
for name, btn in pairs(ThemeButtons) do
    btn.MouseButton1Click:Connect(function()
        ApplyTheme(name)
    end)
end

-- ==================== FLOATING BUTTON ====================
local FloatingBtn = Create("TextButton", {
    Name = "FloatingReopen",
    Size = UDim2.new(0, 50, 0, 50),
    Position = UDim2.new(1, -70, 0.55, -25),
    BackgroundColor3 = Config.Accent,
    Text = "EX",
    TextColor3 = Color3.new(1, 1, 1),
    TextSize = 15,
    Font = Enum.Font.GothamBlack,
    AutoButtonColor = false,
    Visible = false,
    ZIndex = 50,
    Parent = ScreenGui,
})
Corner(FloatingBtn, 25)
Stroke(FloatingBtn, Color3.fromRGB(255,255,255), 1.5)

Create("ImageLabel", {
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 28, 1, 28),
    Position = UDim2.new(0, -14, 0, -14),
    Image = "rbxassetid://6014266941",
    ImageColor3 = Config.Accent,
    ImageTransparency = 0.55,
    ScaleType = Enum.ScaleType.Slice,
    SliceCenter = Rect.new(49, 49, 450, 450),
    ZIndex = 49,
    Parent = FloatingBtn,
})

MakeDraggable(FloatingBtn)

FloatingBtn.MouseEnter:Connect(function()
    Tween(FloatingBtn, {Size = UDim2.new(0, 56, 0, 56)}, 0.15)
end)
FloatingBtn.MouseLeave:Connect(function()
    Tween(FloatingBtn, {Size = UDim2.new(0, 50, 0, 50)}, 0.15)
end)

local function HideMain()
    Main.Visible = false
    FloatingBtn.Visible = true
    FloatingBtn.BackgroundColor3 = Config.Accent
end

local function ShowMain()
    FloatingBtn.Visible = false
    Main.Visible = true
end

MinBtn.MouseButton1Click:Connect(HideMain)
FloatingBtn.MouseButton1Click:Connect(ShowMain)

-- ==================== FINAL ====================
print("[EnforX] " .. L("UILoaded"))
EnforX_ORCLog("EnforX v1.1 • " .. L("Ready"), "info")

return {
    ScreenGui = ScreenGui,
    SwitchTab = SwitchTab,
    ApplyTheme = ApplyTheme,
    ApplyLanguage = ApplyLanguage,
    ORCLog = getgenv().EnforX_ORCLog,
}
