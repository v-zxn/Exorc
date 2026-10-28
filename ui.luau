--[[
    NEO UI MOBILE / UI WORKSPACE
    Version: 2.0 UI
    Palette: monochrome black / white / neutral gray.

    Design goals:
      * Touch-friendly mobile layout and draggable floating launcher.
      * Reusable visual components and independent pages.
      * Local in-session text drafts and UI preference controls.
      * Hub search/results are presentation and browsing UI only.
      * Execute, Run Clipboard, and Hub Execute are visual placeholders.

    Safety / implementation boundary:
      * This file intentionally contains no script execution implementation.
      * The execution buttons do not call an executor or run editor text.
      * Drafts are stored in memory for this UI session only; they are not
        persisted to disk or to a remote service.
      * Hub data availability depends on the user's runtime HTTP permissions.
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LogService = game:GetService("LogService")
local HttpService = game:GetService("HttpService")

-- ========= Config =========
local CONFIG = {
	Title = "NEO",
	IconAsset = "", -- rbxassetid://... (optional)
	BannerAsset = "", -- rbxassetid://... (optional)
	IconURL = "https://raw.githubusercontent.com/MITTO-m4x/Neo_EVADE/main/EVADE/scr/Photo/Icon.png",
	BannerURL = "https://raw.githubusercontent.com/MITTO-m4x/Neo_EVADE/main/EVADE/scr/Photo/Icon2.png",
	SearchAPI = "https://scriptblox.com/api/script/search?q=",
	MaxLogLines = 200,
}

local C = {
	BG = Color3.fromRGB(8, 8, 8),
	Panel = Color3.fromRGB(16, 16, 16),
	Panel2 = Color3.fromRGB(26, 26, 26),
	Stroke = Color3.fromRGB(55, 55, 55),
	White = Color3.fromRGB(245, 245, 245),
	Gray = Color3.fromRGB(150, 150, 150),
	Black = Color3.fromRGB(0, 0, 0),
}

-- ========= UI state (intentionally no script execution functions) =========
local UI = {ClearAfterExecute = false}
local APP = {
	Version = "2.0 UI",
	ActiveTab = "Dashboard",
	Notifications = {},
	Drafts = {},
	SearchHistory = {},
	Preferences = {FontSize = 12, WordWrap = true, ShowLineNumbers = false, Compact = false},
	Stats = {Opened = os.time(), Searches = 0, DraftsCreated = 0},
}

-- ========= Helpers =========
local function make(class, props, parent)
	local o = Instance.new(class)
	for k, v in pairs(props) do o[k] = v end
	if parent then o.Parent = parent end
	return o
end
local function corner(o, r) return make("UICorner", {CornerRadius = UDim.new(0, r or 6)}, o) end
local function stroke(o) return make("UIStroke", {Color = C.Stroke, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, o) end
local function hover(b, n, h)
	b.MouseEnter:Connect(function() TweenService:Create(b, TweenInfo.new(0.1), {BackgroundColor3 = h}):Play() end)
	b.MouseLeave:Connect(function() TweenService:Create(b, TweenInfo.new(0.1), {BackgroundColor3 = n}):Play() end)
end
local function button(parent, text, size, pos, primary, ts)
	local bg = primary and C.White or C.Panel2
	local b = make("TextButton", {
		Size = size, Position = pos or UDim2.new(), BackgroundColor3 = bg, Text = text,
		TextColor3 = primary and C.Black or C.White, Font = Enum.Font.GothamBold,
		TextSize = ts or 11, AutoButtonColor = false,
	}, parent)
	corner(b, 6)
	if not primary then stroke(b) end
	hover(b, bg, primary and Color3.fromRGB(210, 210, 210) or C.Stroke)
	return b
end

local function remoteImage(url, name)
	local ok, res = pcall(function()
		if not (writefile and getcustomasset and (request or http_request)) then return nil end
		local r = (request or http_request)({Url = url, Method = "GET"})
		if r and r.Body then writefile(name, r.Body) return getcustomasset(name) end
	end)
	return ok and res or nil
end

local function httpGet(url)
	local req = request or http_request
	if req then
		local r = req({Url = url, Method = "GET"})
		return r.Body
	elseif game.HttpGet then
		return game:HttpGet(url)
	end
	return HttpService:GetAsync(url)
end

-- ========= ScreenGui / Window =========
local parentGui = (gethui and gethui()) or Players.LocalPlayer:WaitForChild("PlayerGui")
local old = parentGui:FindFirstChild("NeoUI")
if old then old:Destroy() end
local gui = make("ScreenGui", {Name = "NeoUI", ResetOnSpawn = false, IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling}, parentGui)

local camera = workspace.CurrentCamera
local viewport = camera and camera.ViewportSize or Vector2.new(800, 600)
local W, H = math.max(280, math.min(440, viewport.X - 20)), math.max(220, math.min(300, viewport.Y - 70))
local win = make("Frame", {
	Size = UDim2.fromOffset(W, H), Position = UDim2.new(0.5, -W / 2, 0.5, -H / 2),
	BackgroundColor3 = C.BG, BorderSizePixel = 0,
}, gui)
corner(win, 8); stroke(win)

-- Top bar
local top = make("Frame", {Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = C.Panel, BorderSizePixel = 0}, win)
corner(top, 8)
make("Frame", {Size = UDim2.new(1, 0, 0, 8), Position = UDim2.new(0, 0, 1, -8), BackgroundColor3 = C.Panel, BorderSizePixel = 0}, top)

local icon = make("ImageLabel", {
	Size = UDim2.fromOffset(20, 20), Position = UDim2.fromOffset(6, 4), BackgroundTransparency = 1,
	Image = CONFIG.IconAsset, ScaleType = Enum.ScaleType.Fit,
}, top)
make("TextLabel", {
	Size = UDim2.new(0, 120, 1, 0), Position = UDim2.fromOffset(32, 0), BackgroundTransparency = 1,
	Text = CONFIG.Title, TextColor3 = C.White, Font = Enum.Font.GothamBlack, TextSize = 14,
	TextXAlignment = Enum.TextXAlignment.Left,
}, top)

local closeBtn = button(top, "X", UDim2.fromOffset(22, 22), UDim2.new(1, -26, 0, 3), false, 11)
local minBtn = button(top, "−", UDim2.fromOffset(22, 22), UDim2.new(1, -52, 0, 3), false, 12)

-- Floating launcher: independent of the script execution handlers.
local makeDraggable
local floatGui = make("ScreenGui", {Name = "NeoUI_FloatingLauncher", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 20}, parentGui)
local floatSize = 46
local floatButton = make("TextButton", {
	Name = "NeoFloatingButton", Size = UDim2.fromOffset(floatSize, floatSize),
	Position = UDim2.new(1, -floatSize - 18, 0.55, 0), BackgroundColor3 = C.Black,
	Text = "N", TextColor3 = C.White, Font = Enum.Font.GothamBlack, TextSize = 19,
	AutoButtonColor = false, Visible = false, Active = true,
}, floatGui)
corner(floatButton, 14)
local floatStroke = stroke(floatButton)
floatStroke.Thickness = 2
floatStroke.Color = C.White
floatButton.MouseButton1Click:Connect(function()
	if gui.Parent then
		win.Visible = true
		floatButton.Visible = false
		TweenService:Create(win, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.fromOffset(W, H),
		}):Play()
	end
end)

makeDraggable = function(handle, target)
	local dragging, dragInput, startInput, startPos
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging, dragInput, startInput, startPos = true, input, input.Position, target.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	handle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if dragging and (input == dragInput or input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
			local delta = input.Position - startInput
			target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end
makeDraggable(top, win)
makeDraggable(floatButton, floatButton)

-- Sidebar (5 buttons: Settings pinned at the bottom)
local side = make("Frame", {Size = UDim2.new(0, 56, 1, -34), Position = UDim2.fromOffset(4, 31), BackgroundColor3 = C.Panel, BorderSizePixel = 0}, win)
corner(side, 6); stroke(side)
local tabTop = make("Frame", {Size = UDim2.new(1, -8, 1, -46), Position = UDim2.fromOffset(4, 4), BackgroundTransparency = 1}, side)
make("UIListLayout", {Padding = UDim.new(0, 4)}, tabTop)

local content = make("Frame", {Size = UDim2.new(1, -68, 1, -34), Position = UDim2.fromOffset(64, 31), BackgroundTransparency = 1}, win)

local pages, tabs = {}, {}
local function newPage(name)
	local p = make("Frame", {Name = name, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false}, content)
	pages[name] = p
	return p
end
local function selectTab(name)
	for n, p in pairs(pages) do p.Visible = (n == name) end
	for n, b in pairs(tabs) do
		local a = (n == name)
		b.BackgroundColor3 = a and C.White or C.Panel2
		b.TextColor3 = a and C.Black or C.White
	end
end
local function newTab(name, label, bottom)
	local b = make("TextButton", {
		Size = bottom and UDim2.new(1, -8, 0, 32) or UDim2.new(1, 0, 0, 32),
		Position = bottom and UDim2.new(0, 4, 1, -36) or UDim2.new(),
		BackgroundColor3 = C.Panel2, Text = label, TextColor3 = C.White,
		Font = Enum.Font.GothamMedium, TextSize = 10, AutoButtonColor = false,
	}, bottom and side or tabTop)
	corner(b, 5)
	b.MouseButton1Click:Connect(function() selectTab(name) end)
	tabs[name] = b
end

-- Reusable log view (used by Console and ORC)
local function makeLog(parent)
	local box = make("Frame", {Size = UDim2.new(1, 0, 1, -30), BackgroundColor3 = C.Panel, BorderSizePixel = 0}, parent)
	corner(box, 6); stroke(box)
	local sc = make("ScrollingFrame", {
		Size = UDim2.new(1, -8, 1, -8), Position = UDim2.fromOffset(4, 4), BackgroundTransparency = 1,
		BorderSizePixel = 0, ScrollBarThickness = 2, ScrollBarImageColor3 = C.Gray,
		CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
	}, box)
	make("UIListLayout", {Padding = UDim.new(0, 1)}, sc)
	local clear = button(parent, "Clear", UDim2.new(1, 0, 0, 24), UDim2.new(0, 0, 1, -24), false, 11)
	local log = {Count = 0}
	function log.Add(text, dim)
		log.Count += 1
		make("TextLabel", {
			Size = UDim2.new(1, -4, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
			Text = tostring(text), TextColor3 = dim and C.Gray or C.White, Font = Enum.Font.Code, TextSize = 11,
			TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = log.Count,
		}, sc)
		local kids = {}
		for _, k in ipairs(sc:GetChildren()) do if k:IsA("TextLabel") then kids[#kids + 1] = k end end
		if #kids > CONFIG.MaxLogLines then kids[1]:Destroy() end
		task.defer(function() sc.CanvasPosition = Vector2.new(0, sc.AbsoluteCanvasSize.Y) end)
	end
	function log.Clear()
		for _, k in ipairs(sc:GetChildren()) do if k:IsA("TextLabel") then k:Destroy() end end
	end
	clear.MouseButton1Click:Connect(log.Clear)
	return log
end

-- ======================= Page: Dashboard =======================
local dashboardPage = newPage("Dashboard")
newTab("Dashboard", "Home")
local dashTitle = make("TextLabel", {
	Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1, Text = "NEO UI / MOBILE",
	TextColor3 = C.White, Font = Enum.Font.GothamBlack, TextSize = 16,
	TextXAlignment = Enum.TextXAlignment.Left,
}, dashboardPage)
local dashSubtitle = make("TextLabel", {
	Size = UDim2.new(1, 0, 0, 22), Position = UDim2.fromOffset(0, 27), BackgroundTransparency = 1,
	Text = "A monochrome interface workspace", TextColor3 = C.Gray, Font = Enum.Font.Gotham, TextSize = 10,
	TextXAlignment = Enum.TextXAlignment.Left,
}, dashboardPage)
local dashCards = make("Frame", {Size = UDim2.new(1, 0, 0, 82), Position = UDim2.fromOffset(0, 54), BackgroundTransparency = 1}, dashboardPage)
make("UIGridLayout", {CellSize = UDim2.new(0.5, -4, 0, 38), CellPadding = UDim2.fromOffset(6, 6), SortOrder = Enum.SortOrder.LayoutOrder}, dashCards)
local function statCard(parent, titleText, valueText, order)
	local f = make("Frame", {BackgroundColor3 = C.Panel, BorderSizePixel = 0, LayoutOrder = order or 1}, parent)
	corner(f, 6); stroke(f)
	make("TextLabel", {Size = UDim2.new(1, -12, 0, 14), Position = UDim2.fromOffset(6, 4), BackgroundTransparency = 1,
		Text = titleText, TextColor3 = C.Gray, Font = Enum.Font.Gotham, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left}, f)
	local val = make("TextLabel", {Size = UDim2.new(1, -12, 0, 18), Position = UDim2.fromOffset(6, 18), BackgroundTransparency = 1,
		Text = valueText, TextColor3 = C.White, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left}, f)
	return val
end
local draftStat = statCard(dashCards, "WORKSPACE", "No draft", 1)
local searchStat = statCard(dashCards, "HUB SEARCHES", "0", 2)
local dashSection = make("Frame", {Size = UDim2.new(1, 0, 1, -148), Position = UDim2.fromOffset(0, 144), BackgroundColor3 = C.Panel, BorderSizePixel = 0}, dashboardPage)
corner(dashSection, 7); stroke(dashSection)
make("TextLabel", {Size = UDim2.new(1, -16, 0, 22), Position = UDim2.fromOffset(8, 5), BackgroundTransparency = 1,
	Text = "QUICK ACTIONS", TextColor3 = C.White, Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left}, dashSection)
local dashActionBox = make("Frame", {Size = UDim2.new(1, -16, 0, 92), Position = UDim2.fromOffset(8, 31), BackgroundTransparency = 1}, dashSection)
make("UIGridLayout", {CellSize = UDim2.new(0.5, -4, 0, 28), CellPadding = UDim2.fromOffset(6, 6)}, dashActionBox)
local dashEditorBtn = button(dashActionBox, "Open Editor", UDim2.new(1, 0, 1, 0), nil, true, 10)
local dashHubBtn = button(dashActionBox, "Open Hub", UDim2.new(1, 0, 1, 0), nil, false, 10)
local dashConsoleBtn = button(dashActionBox, "Open Console", UDim2.new(1, 0, 1, 0), nil, false, 10)
local dashSettingsBtn = button(dashActionBox, "Settings", UDim2.new(1, 0, 1, 0), nil, false, 10)
make("TextLabel", {Size = UDim2.new(1, -16, 0, 44), Position = UDim2.new(0, 8, 1, -50), BackgroundTransparency = 1,
	Text = "Interface demo mode: execution buttons are visual placeholders. Editor text, tabs, search results and UI preferences are handled separately.",
	TextColor3 = C.Gray, Font = Enum.Font.Gotham, TextSize = 10, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Top}, dashSection)
dashEditorBtn.MouseButton1Click:Connect(function() selectTab("Editor") end)
dashHubBtn.MouseButton1Click:Connect(function() selectTab("Hub") end)
dashConsoleBtn.MouseButton1Click:Connect(function() selectTab("Console") end)
dashSettingsBtn.MouseButton1Click:Connect(function() selectTab("Settings") end)

-- ======================= Page: Editor =======================
local editorPage = newPage("Editor")
newTab("Editor", "Editor")

local ebox = make("Frame", {Size = UDim2.new(1, 0, 1, -84), BackgroundColor3 = C.Panel, BorderSizePixel = 0}, editorPage)
corner(ebox, 6); stroke(ebox)
local escroll = make("ScrollingFrame", {
	Size = UDim2.new(1, -8, 1, -8), Position = UDim2.fromOffset(4, 4), BackgroundTransparency = 1,
	BorderSizePixel = 0, ScrollBarThickness = 2, ScrollBarImageColor3 = C.Gray,
	CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, ebox)
local editor = make("TextBox", {
	Size = UDim2.new(1, -4, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
	Text = "", PlaceholderText = "-- write your script here...", PlaceholderColor3 = C.Gray,
	TextColor3 = C.White, Font = Enum.Font.Code, TextSize = 12, TextWrapped = true,
	TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
	ClearTextOnFocus = false, MultiLine = true,
}, escroll)

local refreshDrafts

-- Editor utility toolbar: local text operations only; no execution functionality.
local editorTools = make("Frame", {Size = UDim2.new(1, 0, 0, 24), Position = UDim2.new(0, 0, 1, -82), BackgroundTransparency = 1}, editorPage)
make("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder}, editorTools)
local function toolButton(label, width)
	return button(editorTools, label, UDim2.new(width or 0.25, -3, 1, 0), nil, false, 9)
end
local selectAllBtn = toolButton("Select All", 0.25)
local copyTextBtn = toolButton("Copy Text", 0.25)
local draftBtn = toolButton("Save Draft", 0.25)
local statsBtn = toolButton("Text Stats", 0.25)
selectAllBtn.MouseButton1Click:Connect(function() editor:CaptureFocus(); editor.CursorPosition = #editor.Text + 1; editor.SelectionStart = 1; UI.Notify("All editor text selected") end)
copyTextBtn.MouseButton1Click:Connect(function()
	if setclipboard then
		local ok = pcall(setclipboard, editor.Text)
		UI.Notify(ok and "Editor text copied" or "Clipboard copy unavailable")
	else UI.Notify("Clipboard copy unavailable in this environment") end
end)
draftBtn.MouseButton1Click:Connect(function()
	local name = "Draft " .. tostring(#APP.Drafts + 1)
	APP.Drafts[#APP.Drafts + 1] = {Name = name, Text = editor.Text, SavedAt = os.time()}
	APP.Stats.DraftsCreated += 1
	draftStat.Text = name
	if refreshDrafts then refreshDrafts() end
	UI.Notify("Saved locally for this UI session: " .. name)
	UI.Toast("Draft saved for this session")
end)
statsBtn.MouseButton1Click:Connect(function()
	local text = editor.Text
	local words = 0
	for _ in string.gmatch(text, "%S+") do words += 1 end
	local lines = 0
	for _ in string.gmatch(text .. "\n", "(.-)\n") do lines += 1 end
	UI.Notify(string.format("Chars: %d | Words: %d | Lines: %d", #text, words, lines))
end)

local status = make("TextLabel", {
	Size = UDim2.new(1, 0, 0, 14), Position = UDim2.new(0, 0, 1, -56), BackgroundTransparency = 1,
	Text = "Ready", TextColor3 = C.Gray, Font = Enum.Font.Gotham, TextSize = 10,
	TextXAlignment = Enum.TextXAlignment.Left,
}, editorPage)
function UI.Notify(msg) status.Text = tostring(msg) end

-- Lightweight in-app toast; purely visual and safe to call from any UI control.
local toast = make("TextLabel", {
	Name = "NeoToast", Size = UDim2.new(1, -24, 0, 30), Position = UDim2.new(0, 12, 0, 34),
	BackgroundColor3 = C.White, BackgroundTransparency = 0.04, Text = "", TextColor3 = C.Black,
	Font = Enum.Font.GothamBold, TextSize = 11, TextWrapped = true, Visible = false, ZIndex = 50,
}, win)
corner(toast, 7)
local toastStroke = stroke(toast); toastStroke.Color = C.White
local toastSerial = 0
function UI.Toast(message)
	toastSerial += 1
	local serial = toastSerial
	toast.Text = tostring(message)
	toast.Visible = true
	toast.TextTransparency = 0
	toast.BackgroundTransparency = 0.04
	task.delay(2.2, function()
		if toast.Parent and serial == toastSerial then
			TweenService:Create(toast, TweenInfo.new(0.18), {TextTransparency = 1, BackgroundTransparency = 1}):Play()
			task.delay(0.2, function() if toast.Parent and serial == toastSerial then toast.Visible = false end end)
		end
	end)
end

local row = make("Frame", {Size = UDim2.new(1, 0, 0, 30), Position = UDim2.new(0, 0, 1, -30), BackgroundTransparency = 1}, editorPage)
make("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 5)}, row)
local third = UDim2.new(1 / 3, -4, 1, 0)
local runClip = button(row, "Run Clipboard", third, nil, false, 10)
local runBtn = button(row, "Execute", third, nil, true, 11)
local clearBtn = button(row, "Clear", third, nil, false, 10)

runClip.MouseButton1Click:Connect(function()
	UI.Notify("Run Clipboard is a UI placeholder — no execution is connected")
	UI.Toast("UI-only control; nothing was executed")
end)
runBtn.MouseButton1Click:Connect(function()
	UI.Notify("Execute is a UI placeholder — no execution is connected")
	UI.Toast("UI-only control; nothing was executed")
end)
clearBtn.MouseButton1Click:Connect(function() editor.Text = ""; UI.Notify("Editor cleared") end)

-- ======================= Page: Drafts =======================
local draftsPage = newPage("Drafts")
newTab("Drafts", "Drafts")
local draftsHeading = make("TextLabel", {Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1,
	Text = "SESSION DRAFTS", TextColor3 = C.White, Font = Enum.Font.GothamBlack, TextSize = 13,
	TextXAlignment = Enum.TextXAlignment.Left}, draftsPage)
local draftsHint = make("TextLabel", {Size = UDim2.new(1, 0, 0, 28), Position = UDim2.fromOffset(0, 23), BackgroundTransparency = 1,
	Text = "Drafts remain in memory only and disappear when this UI session ends.", TextColor3 = C.Gray,
	Font = Enum.Font.Gotham, TextSize = 10, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Top}, draftsPage)
local draftsList = make("ScrollingFrame", {Name = "DraftList", Size = UDim2.new(1, 0, 1, -58), Position = UDim2.fromOffset(0, 54),
	BackgroundColor3 = C.Panel, BorderSizePixel = 0, ScrollBarThickness = 2, ScrollBarImageColor3 = C.Gray,
	CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y}, draftsPage)
corner(draftsList, 6); stroke(draftsList)
make("UIListLayout", {Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder}, draftsList)
make("UIPadding", {PaddingTop = UDim.new(0, 5), PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5), PaddingBottom = UDim.new(0, 5)}, draftsList)
refreshDrafts = function()
	for _, child in ipairs(draftsList:GetChildren()) do
		if child:IsA("Frame") then child:Destroy() end
	end
	if #APP.Drafts == 0 then
		local empty = make("TextLabel", {Size = UDim2.new(1, -8, 0, 40), BackgroundTransparency = 1,
			Text = "No drafts yet. Open Editor and press Save Draft.", TextColor3 = C.Gray,
			Font = Enum.Font.Gotham, TextSize = 10, TextWrapped = true}, draftsList)
		return
	end
	for index = #APP.Drafts, 1, -1 do
		local draft = APP.Drafts[index]
		local rowFrame = make("Frame", {Size = UDim2.new(1, -2, 0, 48), BackgroundColor3 = C.Panel2,
			BorderSizePixel = 0, LayoutOrder = #APP.Drafts - index + 1}, draftsList)
		corner(rowFrame, 5); stroke(rowFrame)
		make("TextLabel", {Size = UDim2.new(1, -116, 0, 18), Position = UDim2.fromOffset(7, 4), BackgroundTransparency = 1,
			Text = draft.Name, TextColor3 = C.White, Font = Enum.Font.GothamBold, TextSize = 10,
			TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd}, rowFrame)
		local count = #draft.Text
		make("TextLabel", {Size = UDim2.new(1, -116, 0, 16), Position = UDim2.fromOffset(7, 23), BackgroundTransparency = 1,
			Text = tostring(count) .. " characters", TextColor3 = C.Gray, Font = Enum.Font.Gotham, TextSize = 9,
			TextXAlignment = Enum.TextXAlignment.Left}, rowFrame)
		local load = button(rowFrame, "Load", UDim2.fromOffset(44, 26), UDim2.new(1, -98, 0.5, -13), true, 9)
		local delete = button(rowFrame, "Delete", UDim2.fromOffset(46, 26), UDim2.new(1, -49, 0.5, -13), false, 9)
		load.MouseButton1Click:Connect(function()
			editor.Text = draft.Text
			selectTab("Editor")
			UI.Notify("Loaded " .. draft.Name)
		end)
		delete.MouseButton1Click:Connect(function()
			table.remove(APP.Drafts, index)
			refreshDrafts()
			draftStat.Text = APP.Drafts[#APP.Drafts] and APP.Drafts[#APP.Drafts].Name or "No draft"
			UI.Notify("Draft removed")
		end)
	end
end

-- ======================= Page: UI Kit =======================
local kitPage = newPage("UIKit")
newTab("UIKit", "UI Kit")
local kitTitle = make("TextLabel", {Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1,
	Text = "COMPONENT GALLERY", TextColor3 = C.White, Font = Enum.Font.GothamBlack, TextSize = 13,
	TextXAlignment = Enum.TextXAlignment.Left}, kitPage)
local kitDescription = make("TextLabel", {Size = UDim2.new(1, 0, 0, 24), Position = UDim2.fromOffset(0, 22), BackgroundTransparency = 1,
	Text = "Preview reusable monochrome controls and states.", TextColor3 = C.Gray, Font = Enum.Font.Gotham, TextSize = 10,
	TextXAlignment = Enum.TextXAlignment.Left}, kitPage)
local kitScroll = make("ScrollingFrame", {Size = UDim2.new(1, 0, 1, -50), Position = UDim2.fromOffset(0, 48),
	BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2, ScrollBarImageColor3 = C.Gray,
	CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y}, kitPage)
make("UIListLayout", {Padding = UDim.new(0, 7), SortOrder = Enum.SortOrder.LayoutOrder}, kitScroll)
local function kitSection(titleText, order)
	local frame = make("Frame", {Size = UDim2.new(1, -4, 0, 82), BackgroundColor3 = C.Panel,
		BorderSizePixel = 0, LayoutOrder = order}, kitScroll)
	corner(frame, 6); stroke(frame)
	make("TextLabel", {Size = UDim2.new(1, -12, 0, 18), Position = UDim2.fromOffset(6, 3), BackgroundTransparency = 1,
		Text = titleText, TextColor3 = C.White, Font = Enum.Font.GothamBold, TextSize = 10,
		TextXAlignment = Enum.TextXAlignment.Left}, frame)
	return frame
end
local kitButtons = kitSection("BUTTON STATES", 1)
local kitPrimary = button(kitButtons, "Primary", UDim2.new(0.32, -4, 0, 26), UDim2.fromOffset(6, 31), true, 9)
local kitSecondary = button(kitButtons, "Secondary", UDim2.new(0.32, -4, 0, 26), UDim2.new(0.34, 0, 0, 31), false, 9)
local kitDisabled = button(kitButtons, "Disabled", UDim2.new(0.32, -4, 0, 26), UDim2.new(0.68, -2, 0, 31), false, 9)
kitDisabled.Active = false; kitDisabled.TextColor3 = C.Gray; kitDisabled.BackgroundTransparency = 0.35
kitPrimary.MouseButton1Click:Connect(function() UI.Toast("Primary button preview") end)
kitSecondary.MouseButton1Click:Connect(function() UI.Toast("Secondary button preview") end)
local kitFields = kitSection("TEXT FIELD", 2)
local kitInput = make("TextBox", {Size = UDim2.new(1, -14, 0, 28), Position = UDim2.fromOffset(7, 34),
	BackgroundColor3 = C.Black, Text = "", PlaceholderText = "Type to preview a field...", PlaceholderColor3 = C.Gray,
	TextColor3 = C.White, Font = Enum.Font.Gotham, TextSize = 10, ClearTextOnFocus = false,
	TextXAlignment = Enum.TextXAlignment.Left}, kitFields)
corner(kitInput, 5); stroke(kitInput); make("UIPadding", {PaddingLeft = UDim.new(0, 7)}, kitInput)
local kitState = kitSection("INTERACTIVE STATE", 3)
local kitStateLabel = make("TextLabel", {Size = UDim2.new(1, -100, 0, 24), Position = UDim2.fromOffset(7, 35), BackgroundTransparency = 1,
	Text = "Preview switch is OFF", TextColor3 = C.Gray, Font = Enum.Font.Gotham, TextSize = 10,
	TextXAlignment = Enum.TextXAlignment.Left}, kitState)
local kitSwitch = button(kitState, "OFF", UDim2.fromOffset(62, 26), UDim2.new(1, -69, 0, 34), false, 9)
local kitOn = false
kitSwitch.MouseButton1Click:Connect(function()
	kitOn = not kitOn
	kitSwitch.Text = kitOn and "ON" or "OFF"
	kitSwitch.BackgroundColor3 = kitOn and C.White or C.Panel2
	kitSwitch.TextColor3 = kitOn and C.Black or C.White
	kitStateLabel.Text = "Preview switch is " .. (kitOn and "ON" or "OFF")
end)

-- ======================= Page: About =======================
local aboutPage = newPage("About")
newTab("About", "About")
local aboutCard = make("Frame", {Size = UDim2.new(1, 0, 0, 154), BackgroundColor3 = C.Panel, BorderSizePixel = 0}, aboutPage)
corner(aboutCard, 8); stroke(aboutCard)
make("TextLabel", {Size = UDim2.new(1, -18, 0, 30), Position = UDim2.fromOffset(9, 7), BackgroundTransparency = 1,
	Text = "NEO UI MOBILE", TextColor3 = C.White, Font = Enum.Font.GothamBlack, TextSize = 16,
	TextXAlignment = Enum.TextXAlignment.Left}, aboutCard)
make("TextLabel", {Size = UDim2.new(1, -18, 1, -44), Position = UDim2.fromOffset(9, 39), BackgroundTransparency = 1,
	Text = "Version: " .. APP.Version .. "\nStyle: monochrome black and white\nLayout: touch-friendly, draggable launcher\nDrafts: session-only local memory\nExecution: intentionally not implemented\nHub: search UI depends on HTTP availability",
	TextColor3 = C.Gray, Font = Enum.Font.Gotham, TextSize = 10, TextWrapped = true,
	TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top}, aboutCard)
local aboutCredits = make("TextLabel", {Size = UDim2.new(1, 0, 0, 42), Position = UDim2.fromOffset(0, 162), BackgroundTransparency = 1,
	Text = "NEO is an independent interface project. The reference file was used to understand the requested scope, not copied line-for-line.",
	TextColor3 = C.Gray, Font = Enum.Font.Gotham, TextSize = 10, TextWrapped = true,
	TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top}, aboutPage)

-- ======================= Page: Hub (search) =======================
-- Same wiring as the example: SearchBox.FocusLost -> HTTP -> JSONDecode -> Add(card) -> click -> popup
local hubPage = newPage("Hub")
newTab("Hub", "Hub")

local search = make("TextBox", {
	Size = UDim2.new(1, 0, 0, 26), BackgroundColor3 = C.Panel, Text = "", PlaceholderText = "Search scripts + Enter",
	PlaceholderColor3 = C.Gray, TextColor3 = C.White, Font = Enum.Font.Gotham, TextSize = 11,
	ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Left,
}, hubPage)
corner(search, 6); stroke(search)
make("UIPadding", {PaddingLeft = UDim.new(0, 8)}, search)

local holder = make("ScrollingFrame", {
	Name = "Holder", Size = UDim2.new(1, 0, 1, -32), Position = UDim2.fromOffset(0, 32), BackgroundTransparency = 1,
	BorderSizePixel = 0, ScrollBarThickness = 2, ScrollBarImageColor3 = C.Gray,
	CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, hubPage)
make("UIGridLayout", {CellSize = UDim2.new(0.5, -4, 0, 54), CellPadding = UDim2.fromOffset(4, 4), SortOrder = Enum.SortOrder.LayoutOrder}, holder)

local hubMsg = make("TextLabel", {
	Size = UDim2.new(1, 0, 0, 20), Position = UDim2.fromOffset(0, 40), BackgroundTransparency = 1,
	Text = "Type a keyword and press Enter", TextColor3 = C.Gray, Font = Enum.Font.Gotham, TextSize = 11,
}, hubPage)

-- Hidden template (cloned for each result)
local reserved = make("Folder", {Name = "Reserved"}, holder)
local template = make("TextButton", {
	Name = "Template", BackgroundColor3 = C.Panel, Text = "", AutoButtonColor = false, Visible = false,
}, reserved)
corner(template, 6); stroke(template)
make("TextLabel", {
	Name = "Title", Size = UDim2.new(1, -10, 0, 18), Position = UDim2.fromOffset(6, 4), BackgroundTransparency = 1,
	Text = "", TextColor3 = C.White, Font = Enum.Font.GothamBold, TextSize = 11, TextTruncate = Enum.TextTruncate.AtEnd,
	TextXAlignment = Enum.TextXAlignment.Left,
}, template)
make("TextLabel", {
	Name = "Game", Size = UDim2.new(1, -10, 0, 14), Position = UDim2.fromOffset(6, 22), BackgroundTransparency = 1,
	Text = "", TextColor3 = C.Gray, Font = Enum.Font.Gotham, TextSize = 10, TextTruncate = Enum.TextTruncate.AtEnd,
	TextXAlignment = Enum.TextXAlignment.Left,
}, template)
make("TextLabel", {
	Name = "Views", Size = UDim2.new(1, -10, 0, 12), Position = UDim2.fromOffset(6, 38), BackgroundTransparency = 1,
	Text = "", TextColor3 = C.Gray, Font = Enum.Font.Gotham, TextSize = 9,
	TextXAlignment = Enum.TextXAlignment.Left,
}, template)

-- Popup (Execute / Open in Editor / Copy / Close)
local selected = {title = "", source = ""}
local popup = make("Frame", {
	Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = C.Black, BackgroundTransparency = 0.25,
	Visible = false, ZIndex = 10, Active = true,
}, hubPage)
local card = make("Frame", {
	Size = UDim2.fromOffset(200, 128), Position = UDim2.new(0.5, -100, 0.5, -64),
	BackgroundColor3 = C.Panel, ZIndex = 11,
}, popup)
corner(card, 8); stroke(card)
local popTitle = make("TextLabel", {
	Size = UDim2.new(1, -12, 0, 22), Position = UDim2.fromOffset(6, 4), BackgroundTransparency = 1,
	Text = "", TextColor3 = C.White, Font = Enum.Font.GothamBold, TextSize = 11, ZIndex = 12,
	TextTruncate = Enum.TextTruncate.AtEnd,
}, card)
local function popBtn(text, y, primary)
	local b = button(card, text, UDim2.new(1, -16, 0, 22), UDim2.fromOffset(8, y), primary, 10)
	b.ZIndex = 12
	return b
end
local pExec = popBtn("Execute", 28, true)
local pEdit = popBtn("Open in Editor", 52, false)
local pCopy = popBtn("Copy", 76, false)
local pClose = popBtn("Close", 100, false)

pClose.MouseButton1Click:Connect(function() popup.Visible = false end)
pExec.MouseButton1Click:Connect(function() popup.Visible = false; UI.Notify("Hub Execute is a UI placeholder — no execution is connected"); UI.Toast("UI-only control; nothing was executed") end)
pEdit.MouseButton1Click:Connect(function()
	editor.Text = selected.source
	popup.Visible = false
	selectTab("Editor")
	UI.Notify("Opened in editor — execution is not connected")
end)
pCopy.MouseButton1Click:Connect(function()
	if setclipboard then setclipboard(selected.source); UI.Notify("Copied") end
	popup.Visible = false
end)

local hub = {}
function hub.Add(title, gameName, source, verified, views)
	local c = template:Clone()
	c.Visible = true
	c.Title.Text = (verified and "[V] " or "") .. tostring(title)
	c.Game.Text = tostring(gameName)
	c.Views.Text = tostring(views) .. " views"
	c.Parent = holder
	c.MouseButton1Click:Connect(function()
		selected = {title = title, source = source}
		popTitle.Text = tostring(title)
		popup.Visible = true
	end)
end

search.FocusLost:Connect(function()
	local q = search.Text
	if q == "" then return end
	APP.Stats.Searches += 1
	searchStat.Text = tostring(APP.Stats.Searches)
	APP.SearchHistory[#APP.SearchHistory + 1] = q
	if #APP.SearchHistory > 12 then table.remove(APP.SearchHistory, 1) end
	for _, v in ipairs(holder:GetChildren()) do if v:IsA("TextButton") and v.Name ~= "Template" then v:Destroy() end end
	hubMsg.Text = "Searching..."; hubMsg.Visible = true
	task.spawn(function()
		local ok, decoded = pcall(function()
			return HttpService:JSONDecode(httpGet(CONFIG.SearchAPI .. HttpService:UrlEncode(q)))
		end)
		if not ok or not decoded or not decoded.result then
			hubMsg.Text = "Search failed (HTTP not available?)"
			return
		end
		local n = 0
		for _, s in ipairs(decoded.result.scripts or {}) do
			if s.scriptType == "free" and s.isPatched == false then
				hub.Add(s.title, (s.game and s.game.name) or "Universal", s.script, s.verified, s.views or 0)
				n += 1
			end
		end
		hubMsg.Visible = (n == 0)
		if n == 0 then hubMsg.Text = "No results" end
	end)
end)

-- ======================= Page: ORC (to be wired later) =======================
local orcPage = newPage("ORC")
newTab("ORC", "ORC")
local orcLog = makeLog(orcPage)
orcLog.Add("ORC console ready. Not connected yet.", true)
UI.ORC = orcLog -- later: UI.ORC.Add("text")

-- ======================= Page: Console (game output) =======================
local consolePage = newPage("Console")
newTab("Console", "Console")
local conLog = makeLog(consolePage)

local function typeTag(t)
	if t == Enum.MessageType.MessageError then return "[ERR] " end
	if t == Enum.MessageType.MessageWarning then return "[WARN] " end
	if t == Enum.MessageType.MessageInfo then return "[INFO] " end
	return ""
end
for _, m in ipairs(LogService:GetLogHistory()) do
	conLog.Add(typeTag(m.messageType) .. m.message, m.messageType == Enum.MessageType.MessageInfo)
end
LogService.MessageOut:Connect(function(msg, t)
	conLog.Add(typeTag(t) .. msg, t == Enum.MessageType.MessageInfo)
end)

-- ======================= Page: Settings (last) =======================
local setPage = newPage("Settings")
newTab("Settings", "Settings", true)

local banner = make("ImageLabel", {
	Size = UDim2.new(1, 0, 0, 56), BackgroundColor3 = C.Black, Image = CONFIG.BannerAsset,
	ScaleType = Enum.ScaleType.Fit,
}, setPage)
corner(banner, 6); stroke(banner)

local function toggle(label, y, default, cb)
	local r = make("Frame", {Size = UDim2.new(1, 0, 0, 30), Position = UDim2.fromOffset(0, y), BackgroundColor3 = C.Panel}, setPage)
	corner(r, 6); stroke(r)
	make("TextLabel", {
		Size = UDim2.new(1, -60, 1, 0), Position = UDim2.fromOffset(8, 0), BackgroundTransparency = 1,
		Text = label, TextColor3 = C.White, Font = Enum.Font.GothamMedium, TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, r)
	local state = default
	local sw = make("TextButton", {
		Size = UDim2.fromOffset(36, 18), Position = UDim2.new(1, -44, 0.5, -9),
		BackgroundColor3 = state and C.White or C.Stroke, Text = "", AutoButtonColor = false,
	}, r)
	corner(sw, 9)
	local knob = make("Frame", {
		Size = UDim2.fromOffset(14, 14), Position = state and UDim2.fromOffset(20, 2) or UDim2.fromOffset(2, 2),
		BackgroundColor3 = state and C.Black or C.White, BorderSizePixel = 0,
	}, sw)
	corner(knob, 7)
	sw.MouseButton1Click:Connect(function()
		state = not state
		TweenService:Create(sw, TweenInfo.new(0.15), {BackgroundColor3 = state and C.White or C.Stroke}):Play()
		TweenService:Create(knob, TweenInfo.new(0.15), {
			Position = state and UDim2.fromOffset(20, 2) or UDim2.fromOffset(2, 2),
			BackgroundColor3 = state and C.Black or C.White,
		}):Play()
		cb(state)
	end)
end
toggle("Clear after execute", 62, false, function(v) UI.ClearAfterExecute = v end)
toggle("Show Console tab", 96, true, function(v) tabs.Console.Visible = v end)

local settingsScroll = make("ScrollingFrame", {
	Name = "LauncherSettings", Size = UDim2.new(1, 0, 1, -138), Position = UDim2.fromOffset(0, 134),
	BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2,
	ScrollBarImageColor3 = C.Gray, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, setPage)
make("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder}, settingsScroll)
local function settingLabel(text)
	return make("TextLabel", {Size = UDim2.new(1, -4, 0, 18), BackgroundTransparency = 1,
		Text = text, TextColor3 = C.White, Font = Enum.Font.GothamMedium, TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 0}, settingsScroll)
end
local function optionRow(labelText, options, initial, callback)
	local rowFrame = make("Frame", {Size = UDim2.new(1, -4, 0, 34), BackgroundColor3 = C.Panel,
		BorderSizePixel = 0, LayoutOrder = 1}, settingsScroll)
	corner(rowFrame, 6); stroke(rowFrame)
	make("TextLabel", {Size = UDim2.new(0.34, 0, 1, 0), Position = UDim2.fromOffset(8, 0),
		BackgroundTransparency = 1, Text = labelText, TextColor3 = C.White,
		Font = Enum.Font.GothamMedium, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left}, rowFrame)
	local chosen = initial
	local optionWidth = 0.64 / #options
	for index, value in ipairs(options) do
		local b = make("TextButton", {Size = UDim2.new(optionWidth, -3, 0, 24),
			Position = UDim2.new(0.35 + (index - 1) * optionWidth, 0, 0.5, -12),
			BackgroundColor3 = value == chosen and C.White or C.Panel2,
			Text = value, TextColor3 = value == chosen and C.Black or C.White,
			Font = Enum.Font.GothamBold, TextSize = 9, AutoButtonColor = false}, rowFrame)
		corner(b, 5)
		b.MouseButton1Click:Connect(function()
			chosen = value
			for _, sibling in ipairs(rowFrame:GetChildren()) do
				if sibling:IsA("TextButton") then
					local active = sibling.Text == chosen
					sibling.BackgroundColor3 = active and C.White or C.Panel2
					sibling.TextColor3 = active and C.Black or C.White
				end
			end
			callback(value)
		end)
	end
end
settingLabel("Floating launcher")
optionRow("Size", {"Small", "Medium", "Large"}, "Medium", function(value)
	floatSize = ({Small = 34, Medium = 46, Large = 58})[value]
	floatButton.Size = UDim2.fromOffset(floatSize, floatSize)
	floatButton.TextSize = value == "Small" and 15 or (value == "Large" and 23 or 19)
end)
optionRow("Shape", {"Circle", "Round", "Square"}, "Round", function(value)
	local radius = value == "Circle" and UDim.new(0.5, 0) or (value == "Square" and UDim.new(0, 3) or UDim.new(0, 14))
	floatButton:FindFirstChildOfClass("UICorner").CornerRadius = radius
end)
settingLabel("Editor preferences")
optionRow("Font size", {"Small", "Medium", "Large"}, "Medium", function(value)
	local sizes = {Small = 10, Medium = 12, Large = 14}
	APP.Preferences.FontSize = sizes[value]
	editor.TextSize = sizes[value]
	UI.Notify("Editor font size: " .. value)
end)
optionRow("Text wrap", {"On", "Off"}, "On", function(value)
	APP.Preferences.WordWrap = value == "On"
	editor.TextWrapped = APP.Preferences.WordWrap
	UI.Notify("Text wrap " .. string.lower(value))
end)
settingLabel("Interface information")
local infoCard = make("Frame", {Size = UDim2.new(1, -4, 0, 64), BackgroundColor3 = C.Panel, BorderSizePixel = 0, LayoutOrder = 1}, settingsScroll)
corner(infoCard, 6); stroke(infoCard)
make("TextLabel", {Size = UDim2.new(1, -12, 1, -8), Position = UDim2.fromOffset(6, 4), BackgroundTransparency = 1,
	Text = "NEO UI " .. APP.Version .. "\nMonochrome mobile layout\nExecution controls intentionally have no execution implementation.",
	TextColor3 = C.Gray, Font = Enum.Font.Gotham, TextSize = 10, TextWrapped = true,
	TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top}, infoCard)
make("TextLabel", {Size = UDim2.new(1, -4, 0, 30), BackgroundTransparency = 1,
	Text = "Launcher settings apply immediately. Script execution remains unconnected.",
	TextColor3 = C.Gray, Font = Enum.Font.Gotham, TextSize = 10, TextWrapped = true,
	TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 2}, settingsScroll)

-- ======================= Close / Minimize =======================
closeBtn.MouseButton1Click:Connect(function()
	-- Close the window but keep a launcher so it can be reopened.
	win.Visible = false
	floatButton.Visible = true
end)
minBtn.MouseButton1Click:Connect(function()
	win.Visible = false
	floatButton.Visible = true
end)

-- Images
task.spawn(function()
	if CONFIG.IconAsset == "" then
		local i = remoteImage(CONFIG.IconURL, "neo_icon.png")
		if i then icon.Image = i end
	end
	if CONFIG.BannerAsset == "" then
		local i = remoteImage(CONFIG.BannerURL, "neo_banner.png")
		if i then banner.Image = i end
	end
end)

-- Keyboard helpers and responsive viewport bounds.
UIS.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.KeyCode == Enum.KeyCode.Escape and popup and popup.Visible then
		popup.Visible = false
	elseif input.KeyCode == Enum.KeyCode.Escape and win.Visible then
		win.Visible = false
		floatButton.Visible = true
	end
end)
local function updateViewport()
	local cam = workspace.CurrentCamera
	if not cam or not win.Parent then return end
	local size = cam.ViewportSize
	local newW = math.max(280, math.min(440, size.X - 20))
	local newH = math.max(220, math.min(420, size.Y - 50))
	W, H = newW, newH
	if win.Visible then win.Size = UDim2.fromOffset(W, H) end
end
if workspace.CurrentCamera then
	workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateViewport)
end

refreshDrafts()
selectTab("Dashboard")
UI.Notify("Ready — UI-only mode; execution controls are placeholders")
