--[[ NEO UI - واجهة بس (أبيض وأسود)
     حطه LocalScript جوه StarterGui (أو شغله من الإكسكيوتر)
     كل الأزرار متوصلة بـ Handlers تحت، تكتب فيها اللوجيك بعدين ]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- ========= الإعدادات =========
local CONFIG = {
	Title = "NEO",
	-- لو رفعت الصور على روبلوكس حط الـ ID هنا (rbxassetid://123)
	IconAsset = "",
	BannerAsset = "",
	IconURL = "https://raw.githubusercontent.com/MITTO-m4x/Neo_EVADE/main/EVADE/scr/Photo/Icon.png",
	BannerURL = "https://raw.githubusercontent.com/MITTO-m4x/Neo_EVADE/main/EVADE/scr/Photo/Icon2.png",
}

local C = {
	BG = Color3.fromRGB(8, 8, 8),
	Panel = Color3.fromRGB(16, 16, 16),
	Panel2 = Color3.fromRGB(24, 24, 24),
	Stroke = Color3.fromRGB(55, 55, 55),
	White = Color3.fromRGB(245, 245, 245),
	Gray = Color3.fromRGB(150, 150, 150),
	Black = Color3.fromRGB(0, 0, 0),
}

-- ========= Handlers (هنا هتكتب اللوجيك بعدين) =========
local UI = {}
local Handlers = {
	ExecuteClipboard = function(text) UI.Notify("Execute Clipboard: not connected yet") end,
	ExecuteEditor = function(text) UI.Notify("Execute: not connected yet") end,
	LoadScript = function(entry) UI.Notify("Load: " .. entry.name .. " (not connected yet)") end,
}

-- ========= أدوات =========
local function make(class, props, parent)
	local o = Instance.new(class)
	for k, v in pairs(props) do o[k] = v end
	if parent then o.Parent = parent end
	return o
end

local function corner(o, r) return make("UICorner", {CornerRadius = UDim.new(0, r or 6)}, o) end
local function stroke(o, col) return make("UIStroke", {Color = col or C.Stroke, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, o) end

local function hover(btn, normal, over)
	btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = over}):Play() end)
	btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = normal}):Play() end)
end

-- تحميل صورة من رابط (بيشتغل في الإكسكيوتر اللي فيه writefile/getcustomasset)
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

-- ========= ScreenGui =========
local parentGui = (gethui and gethui()) or Players.LocalPlayer:WaitForChild("PlayerGui")
local old = parentGui:FindFirstChild("NeoUI")
if old then old:Destroy() end

local gui = make("ScreenGui", {Name = "NeoUI", ResetOnSpawn = false, IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling}, parentGui)

local win = make("Frame", {
	Size = UDim2.fromOffset(640, 400), Position = UDim2.new(0.5, -320, 0.5, -200),
	BackgroundColor3 = C.BG, BorderSizePixel = 0,
}, gui)
corner(win, 10); stroke(win)

-- ========= Top bar =========
local top = make("Frame", {Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = C.Panel, BorderSizePixel = 0}, win)
corner(top, 10)
make("Frame", {Size = UDim2.new(1, 0, 0, 10), Position = UDim2.new(0, 0, 1, -10), BackgroundColor3 = C.Panel, BorderSizePixel = 0}, top)

local icon = make("ImageLabel", {
	Size = UDim2.fromOffset(26, 26), Position = UDim2.fromOffset(10, 7),
	BackgroundTransparency = 1, Image = CONFIG.IconAsset, ScaleType = Enum.ScaleType.Fit,
}, top)

make("TextLabel", {
	Size = UDim2.new(0, 200, 1, 0), Position = UDim2.fromOffset(44, 0), BackgroundTransparency = 1,
	Text = CONFIG.Title, TextColor3 = C.White, Font = Enum.Font.GothamBlack, TextSize = 18,
	TextXAlignment = Enum.TextXAlignment.Left,
}, top)

local function topBtn(text, xOff)
	local b = make("TextButton", {
		Size = UDim2.fromOffset(28, 28), Position = UDim2.new(1, xOff, 0, 6),
		BackgroundColor3 = C.Panel2, Text = text, TextColor3 = C.White,
		Font = Enum.Font.GothamBold, TextSize = 14, AutoButtonColor = false,
	}, top)
	corner(b, 6); hover(b, C.Panel2, C.Stroke)
	return b
end
local closeBtn = topBtn("X", -36)
local minBtn = topBtn("-", -70)

-- سحب النافذة (ماوس + لمس)
do
	local dragging, startPos, startInput
	top.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging, startPos, startInput = true, win.Position, i.Position
			i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dragging = false end end)
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local d = i.Position - startInput
			win.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)
end

-- ========= Sidebar =========
local side = make("Frame", {Size = UDim2.new(0, 150, 1, -48), Position = UDim2.fromOffset(8, 44), BackgroundColor3 = C.Panel, BorderSizePixel = 0}, win)
corner(side, 8); stroke(side)

local banner = make("ImageLabel", {
	Size = UDim2.new(1, -16, 0, 60), Position = UDim2.fromOffset(8, 8),
	BackgroundColor3 = C.Black, Image = CONFIG.BannerAsset, ScaleType = Enum.ScaleType.Fit,
}, side)
corner(banner, 6); stroke(banner)

local tabHolder = make("Frame", {Size = UDim2.new(1, -16, 1, -84), Position = UDim2.fromOffset(8, 76), BackgroundTransparency = 1}, side)
make("UIListLayout", {Padding = UDim.new(0, 6)}, tabHolder)

-- ========= Content =========
local content = make("Frame", {Size = UDim2.new(1, -174, 1, -48), Position = UDim2.fromOffset(166, 44), BackgroundTransparency = 1}, win)

local pages, tabs = {}, {}
local function newPage(name)
	local p = make("Frame", {Name = name, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false}, content)
	pages[name] = p
	return p
end

local function selectTab(name)
	for n, p in pairs(pages) do p.Visible = (n == name) end
	for n, b in pairs(tabs) do
		local active = (n == name)
		b.BackgroundColor3 = active and C.White or C.Panel2
		b.TextColor3 = active and C.Black or C.White
	end
end

local function newTab(name, label)
	local b = make("TextButton", {
		Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = C.Panel2, Text = label,
		TextColor3 = C.White, Font = Enum.Font.GothamMedium, TextSize = 13, AutoButtonColor = false,
	}, tabHolder)
	corner(b, 6)
	b.MouseButton1Click:Connect(function() selectTab(name) end)
	tabs[name] = b
end

-- ===== Page: Editor =====
local editorPage = newPage("Editor")
newTab("Editor", "Editor")

local editorBox = make("Frame", {Size = UDim2.new(1, 0, 1, -88), BackgroundColor3 = C.Panel, BorderSizePixel = 0}, editorPage)
corner(editorBox, 8); stroke(editorBox)

local scroll = make("ScrollingFrame", {
	Size = UDim2.new(1, -12, 1, -12), Position = UDim2.fromOffset(6, 6), BackgroundTransparency = 1,
	BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = C.Gray,
	CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, editorBox)

local editor = make("TextBox", {
	Size = UDim2.new(1, -4, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
	Text = "", PlaceholderText = "-- اكتب السكريبت هنا...", PlaceholderColor3 = C.Gray,
	TextColor3 = C.White, Font = Enum.Font.Code, TextSize = 14, TextWrapped = true,
	TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
	ClearTextOnFocus = false, MultiLine = true,
}, scroll)

local status = make("TextLabel", {
	Size = UDim2.new(1, 0, 0, 18), Position = UDim2.new(0, 0, 1, -84), BackgroundTransparency = 1,
	Text = "Ready", TextColor3 = C.Gray, Font = Enum.Font.Gotham, TextSize = 12,
	TextXAlignment = Enum.TextXAlignment.Left,
}, editorPage)

function UI.Notify(msg)
	status.Text = msg
end

-- الأزرار التلاتة
local btnRow = make("Frame", {Size = UDim2.new(1, 0, 0, 40), Position = UDim2.new(0, 0, 1, -40), BackgroundTransparency = 1}, editorPage)
make("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8)}, btnRow)

local function bigBtn(text, primary)
	local bg = primary and C.White or C.Panel2
	local b = make("TextButton", {
		Size = UDim2.new(1/3, -6, 1, 0), BackgroundColor3 = bg, Text = text,
		TextColor3 = primary and C.Black or C.White, Font = Enum.Font.GothamBold, TextSize = 13, AutoButtonColor = false,
	}, btnRow)
	corner(b, 8)
	if not primary then stroke(b) end
	hover(b, bg, primary and Color3.fromRGB(210, 210, 210) or C.Stroke)
	return b
end

local execClipBtn = bigBtn("Execute Clipboard", false)
local execBtn = bigBtn("Execute", true)
local clearBtn = bigBtn("Clear", false)

execClipBtn.MouseButton1Click:Connect(function()
	local text = (getclipboard and getclipboard()) or ""
	if text == "" then UI.Notify("الكليب بورد فاضي أو مش مدعوم") return end
	Handlers.ExecuteClipboard(text)
end)
execBtn.MouseButton1Click:Connect(function() Handlers.ExecuteEditor(editor.Text) end)
clearBtn.MouseButton1Click:Connect(function() editor.Text = ""; UI.Notify("Cleared") end)

-- ===== Page: Scripts (بحث) =====
local scriptsPage = newPage("Scripts")
newTab("Scripts", "Scripts")

local search = make("TextBox", {
	Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = C.Panel, Text = "", PlaceholderText = "ابحث عن سكريبت...",
	PlaceholderColor3 = C.Gray, TextColor3 = C.White, Font = Enum.Font.Gotham, TextSize = 13,
	ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Left,
}, scriptsPage)
corner(search, 8); stroke(search)
make("UIPadding", {PaddingLeft = UDim.new(0, 10)}, search)

local list = make("ScrollingFrame", {
	Size = UDim2.new(1, 0, 1, -42), Position = UDim2.fromOffset(0, 42), BackgroundTransparency = 1,
	BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = C.Gray,
	CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, scriptsPage)
make("UIListLayout", {Padding = UDim.new(0, 6)}, list)

-- ضيف سكريبتاتك هنا بعدين
local SCRIPTS = {
	{name = "NEO HYPER EVADE", desc = "Evade script"},
	{name = "Neo Blade Ball", desc = "Blade Ball script"},
	{name = "Neo FATS", desc = "FATS script"},
	{name = "Neo Universal", desc = "Universal script"},
}

local rows = {}
for _, entry in ipairs(SCRIPTS) do
	local row = make("Frame", {Size = UDim2.new(1, -4, 0, 48), BackgroundColor3 = C.Panel}, list)
	corner(row, 8); stroke(row)
	make("TextLabel", {
		Size = UDim2.new(1, -90, 0, 22), Position = UDim2.fromOffset(10, 4), BackgroundTransparency = 1,
		Text = entry.name, TextColor3 = C.White, Font = Enum.Font.GothamBold, TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, row)
	make("TextLabel", {
		Size = UDim2.new(1, -90, 0, 16), Position = UDim2.fromOffset(10, 26), BackgroundTransparency = 1,
		Text = entry.desc, TextColor3 = C.Gray, Font = Enum.Font.Gotham, TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, row)
	local load = make("TextButton", {
		Size = UDim2.fromOffset(64, 28), Position = UDim2.new(1, -74, 0.5, -14), BackgroundColor3 = C.White,
		Text = "Load", TextColor3 = C.Black, Font = Enum.Font.GothamBold, TextSize = 12, AutoButtonColor = false,
	}, row)
	corner(load, 6)
	load.MouseButton1Click:Connect(function() Handlers.LoadScript(entry) end)
	rows[#rows + 1] = {frame = row, name = entry.name:lower()}
end

search:GetPropertyChangedSignal("Text"):Connect(function()
	local q = search.Text:lower()
	for _, r in ipairs(rows) do r.frame.Visible = (q == "" or r.name:find(q, 1, true) ~= nil) end
end)

-- ===== Page: Settings =====
local settingsPage = newPage("Settings")
newTab("Settings", "Settings")

local function toggle(label, y, default, cb)
	local row = make("Frame", {Size = UDim2.new(1, 0, 0, 40), Position = UDim2.fromOffset(0, y), BackgroundColor3 = C.Panel}, settingsPage)
	corner(row, 8); stroke(row)
	make("TextLabel", {
		Size = UDim2.new(1, -70, 1, 0), Position = UDim2.fromOffset(12, 0), BackgroundTransparency = 1,
		Text = label, TextColor3 = C.White, Font = Enum.Font.GothamMedium, TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, row)
	local state = default
	local sw = make("TextButton", {
		Size = UDim2.fromOffset(46, 22), Position = UDim2.new(1, -58, 0.5, -11),
		BackgroundColor3 = state and C.White or C.Stroke, Text = "", AutoButtonColor = false,
	}, row)
	corner(sw, 11)
	local knob = make("Frame", {
		Size = UDim2.fromOffset(18, 18), Position = state and UDim2.fromOffset(26, 2) or UDim2.fromOffset(2, 2),
		BackgroundColor3 = state and C.Black or C.White, BorderSizePixel = 0,
	}, sw)
	corner(knob, 9)
	sw.MouseButton1Click:Connect(function()
		state = not state
		TweenService:Create(sw, TweenInfo.new(0.15), {BackgroundColor3 = state and C.White or C.Stroke}):Play()
		TweenService:Create(knob, TweenInfo.new(0.15), {
			Position = state and UDim2.fromOffset(26, 2) or UDim2.fromOffset(2, 2),
			BackgroundColor3 = state and C.Black or C.White,
		}):Play()
		cb(state)
	end)
end

toggle("Clear after execute", 0, false, function(v) UI.ClearAfterExecute = v end)
toggle("Auto-scroll terminal", 48, true, function(v) UI.AutoScroll = v end)

-- ===== إغلاق / تصغير =====
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)
local minimized = false
minBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	side.Visible = not minimized
	content.Visible = not minimized
	TweenService:Create(win, TweenInfo.new(0.2), {Size = minimized and UDim2.fromOffset(640, 40) or UDim2.fromOffset(640, 400)}):Play()
end)

-- ===== الصور =====
task.spawn(function()
	if CONFIG.IconAsset == "" then
		local img = remoteImage(CONFIG.IconURL, "neo_icon.png")
		if img then icon.Image = img end
	end
	if CONFIG.BannerAsset == "" then
		local img = remoteImage(CONFIG.BannerURL, "neo_banner.png")
		if img then banner.Image = img end
	end
end)

selectTab("Editor")
