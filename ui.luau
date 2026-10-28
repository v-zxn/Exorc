--[[ NEO UI - Mobile (black & white, English)
     Tabs (top -> bottom): Editor / Hub / ORC / Console / Settings
     Execution is NOT wired yet: everything goes through Handlers below. ]]

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

-- ========= Handlers (wire logic here later) =========
local UI = {}
local Handlers = {
	ExecuteClipboard = function(text) UI.Notify("Run Clipboard: not connected") end,
	ExecuteEditor = function(text) UI.Notify("Execute: not connected") end,
	ExecuteHubScript = function(entry) UI.Notify("Hub execute: not connected") end,
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

local W, H = 440, 250
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
local minBtn = button(top, "-", UDim2.fromOffset(22, 22), UDim2.new(1, -52, 0, 3), false, 12)

do -- drag (mouse + touch)
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

-- ======================= Page: Editor =======================
local editorPage = newPage("Editor")
newTab("Editor", "Editor")

local ebox = make("Frame", {Size = UDim2.new(1, 0, 1, -58), BackgroundColor3 = C.Panel, BorderSizePixel = 0}, editorPage)
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

local status = make("TextLabel", {
	Size = UDim2.new(1, 0, 0, 14), Position = UDim2.new(0, 0, 1, -56), BackgroundTransparency = 1,
	Text = "Ready", TextColor3 = C.Gray, Font = Enum.Font.Gotham, TextSize = 10,
	TextXAlignment = Enum.TextXAlignment.Left,
}, editorPage)
function UI.Notify(msg) status.Text = msg end

local row = make("Frame", {Size = UDim2.new(1, 0, 0, 30), Position = UDim2.new(0, 0, 1, -30), BackgroundTransparency = 1}, editorPage)
make("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 5)}, row)
local third = UDim2.new(1 / 3, -4, 1, 0)
local runClip = button(row, "Run Clipboard", third, nil, false, 10)
local runBtn = button(row, "Execute", third, nil, true, 11)
local clearBtn = button(row, "Clear", third, nil, false, 10)

runClip.MouseButton1Click:Connect(function()
	local t = (getclipboard and getclipboard()) or ""
	if t == "" then UI.Notify("Clipboard empty / unsupported") return end
	Handlers.ExecuteClipboard(t)
end)
runBtn.MouseButton1Click:Connect(function() Handlers.ExecuteEditor(editor.Text) end)
clearBtn.MouseButton1Click:Connect(function() editor.Text = ""; UI.Notify("Cleared") end)

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
pExec.MouseButton1Click:Connect(function() popup.Visible = false; Handlers.ExecuteHubScript(selected) end)
pEdit.MouseButton1Click:Connect(function()
	editor.Text = selected.source
	popup.Visible = false
	selectTab("Editor")
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
	for _, v in ipairs(holder:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
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

-- ======================= Close / Minimize =======================
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)
local minimized = false
minBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	side.Visible = not minimized
	content.Visible = not minimized
	TweenService:Create(win, TweenInfo.new(0.2), {Size = minimized and UDim2.fromOffset(W, 28) or UDim2.fromOffset(W, H)}):Play()
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

selectTab("Editor")
