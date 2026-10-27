--[[
  NEO HYPER - Key UI Source (Junkie)
  Paste into Junkie Dashboard -> Script -> UI Source

  Step 1 (tiny): script name + Free / Premium only
  Step 2 (larger): enter key
  Prefix rules stay internal (NEO-FREE / NEO-PRM) — never shown on UI
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LP = Players.LocalPlayer

getgenv().SCRIPT_KEY = nil
getgenv().UI_CLOSED = false
getgenv().NEO_KEY_OK = false
getgenv().NEO_VERSION = nil

local SERVICE_NAME = "Hyper v1.0"
local OWNER_IDENTIFIER = "1068884"
local PROVIDER_NAME = "Hyper"

local DISCORD_LINK = "https://discord.gg/YbDMqpAr3a"
local WEBSITE_LINK = "https://neo-website-87k.pages.dev/"

local KEY_FOLDER = "Neo-EVADE"
local KEY_FILE = KEY_FOLDER .. "/key_cache.txt"
local VER_FILE = KEY_FOLDER .. "/version_cache.txt"

-- internal only — never printed on UI
local PREFIX_FREE = "NEO-FREE"
local PREFIX_PREMIUM = "NEO-PRM"

local white = Color3.fromRGB(255, 255, 255)
local black = Color3.fromRGB(0, 0, 0)
local fieldBg = Color3.fromRGB(14, 14, 14)
local mutedText = Color3.fromRGB(150, 150, 150)
local redText = Color3.fromRGB(235, 70, 70)

local parentGui = nil
pcall(function()
	parentGui = game:GetService("CoreGui")
end)
if not parentGui then
	pcall(function()
		parentGui = LP:WaitForChild("PlayerGui", 5)
	end)
end

local Junkie = nil
do
	local ok, lib = pcall(function()
		return loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
	end)
	if ok and type(lib) == "table" then
		Junkie = lib
		Junkie.service = SERVICE_NAME
		Junkie.identifier = OWNER_IDENTIFIER
		Junkie.provider = PROVIDER_NAME
	end
end

local function ensureFolder()
	pcall(function()
		if type(makefolder) == "function" then
			if type(isfolder) ~= "function" or not isfolder(KEY_FOLDER) then
				makefolder(KEY_FOLDER)
			end
		end
	end)
end

local function loadCachedKey()
	ensureFolder()
	local key = nil
	pcall(function()
		if type(readfile) ~= "function" then return end
		if type(isfile) == "function" and not isfile(KEY_FILE) then return end
		local raw = string.gsub(tostring(readfile(KEY_FILE) or ""), "%s+", "")
		if #raw > 0 then key = raw end
	end)
	return key
end

local function loadCachedVersion()
	ensureFolder()
	local ver = nil
	pcall(function()
		if type(readfile) ~= "function" then return end
		if type(isfile) == "function" and not isfile(VER_FILE) then return end
		local raw = string.upper(string.gsub(tostring(readfile(VER_FILE) or ""), "%s+", ""))
		if raw == "FREE" or raw == "PREMIUM" then ver = raw end
	end)
	return ver
end

local function saveCachedKey(key)
	pcall(function()
		ensureFolder()
		if type(writefile) == "function" then writefile(KEY_FILE, tostring(key)) end
	end)
end

local function saveCachedVersion(ver)
	pcall(function()
		ensureFolder()
		if type(writefile) == "function" then writefile(VER_FILE, tostring(ver)) end
	end)
end

local function clearCachedKey()
	pcall(function()
		ensureFolder()
		if type(writefile) == "function" then writefile(KEY_FILE, "") end
	end)
end

local function copyText(text)
	pcall(function()
		if type(setclipboard) == "function" then setclipboard(text)
		elseif type(toclipboard) == "function" then toclipboard(text) end
	end)
end

local function startsWith(str, prefix)
	str = string.upper(tostring(str or ""))
	prefix = string.upper(tostring(prefix or ""))
	return string.sub(str, 1, #prefix) == prefix
end

local function showToast(line2)
	task.spawn(function()
		pcall(function()
			if not parentGui then return end
			local old = parentGui:FindFirstChild("NeoHyperToast")
			if old then old:Destroy() end
			local tg = Instance.new("ScreenGui")
			tg.Name = "NeoHyperToast"
			tg.ResetOnSpawn = false
			tg.IgnoreGuiInset = true
			tg.DisplayOrder = 999999
			tg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			tg.Parent = parentGui
			local outer = Instance.new("Frame")
			outer.AnchorPoint = Vector2.new(0.5, 0)
			outer.Position = UDim2.new(0.5, 0, 0, -70)
			outer.Size = UDim2.fromOffset(240, 54)
			outer.BackgroundColor3 = white
			outer.BorderSizePixel = 0
			outer.Parent = tg
			Instance.new("UICorner", outer).CornerRadius = UDim.new(0, 12)
			local inner = Instance.new("Frame")
			inner.AnchorPoint = Vector2.new(0.5, 0.5)
			inner.Position = UDim2.fromScale(0.5, 0.5)
			inner.Size = UDim2.new(1, -2, 1, -2)
			inner.BackgroundColor3 = black
			inner.BorderSizePixel = 0
			inner.Parent = outer
			Instance.new("UICorner", inner).CornerRadius = UDim.new(0, 11)
			local l1 = Instance.new("TextLabel")
			l1.BackgroundTransparency = 1
			l1.Position = UDim2.fromOffset(0, 8)
			l1.Size = UDim2.new(1, 0, 0, 18)
			l1.Font = Enum.Font.GothamBold
			l1.TextSize = 14
			l1.TextColor3 = white
			l1.Text = "Loading script..."
			l1.Parent = inner
			local l2 = Instance.new("TextLabel")
			l2.BackgroundTransparency = 1
			l2.Position = UDim2.fromOffset(0, 28)
			l2.Size = UDim2.new(1, 0, 0, 16)
			l2.Font = Enum.Font.Gotham
			l2.TextSize = 12
			l2.TextColor3 = mutedText
			l2.Text = tostring(line2 or "Thanks for using Neo")
			l2.Parent = inner
			TweenService:Create(outer, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Position = UDim2.new(0.5, 0, 0, 18),
			}):Play()
			task.wait(1.6)
			TweenService:Create(outer, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Position = UDim2.new(0.5, 0, 0, -70),
			}):Play()
			task.wait(0.22)
			tg:Destroy()
		end)
	end)
end

local URL_FREE = "https://api.jnkie.com/api/v1/luascripts/public/2d260aa3dccc9311613ea8eb118dc5e5af560ee599415808d61d68fd391022ee/download"
local URL_PREMIUM = "https://api.jnkie.com/api/v1/luascripts/public/568c637a8bf344668ee9f107c51917ae22457eb3a251d7e973561429f8211a0d/download"
local URL_KEYLESS = "https://raw.githubusercontent.com/v-zxn/III-V/refs/heads/main/HI"

local protectedScriptStarted = false
local function runProtectedScript()
	if protectedScriptStarted then return end
	protectedScriptStarted = true
	task.spawn(function()
		local key = tostring(getgenv().SCRIPT_KEY or "")
		local ver = string.upper(tostring(getgenv().NEO_VERSION or ""))
		local url = (key == "KEYLESS") and URL_KEYLESS
			or ((ver == "PREMIUM") and URL_PREMIUM or URL_FREE)
		local ok, err = pcall(function()
			local source = game:HttpGet(url)
			local chunk, compileErr = loadstring(source)
			if not chunk then error(compileErr or "Could not compile script") end
			chunk()
		end)
		if not ok then warn("[Neo Hyper] Protected script failed:", err) end
	end)
end

-- Internal prefix + Junkie. UI never shows prefixes.
local function verifyKey(key, version)
	key = string.gsub(tostring(key or ""), "%s+", "")
	version = string.upper(tostring(version or ""))
	if key == "" then return false, "Enter a key", false end
	-- Explicit KEYLESS route: load the configured external script instead of Junkie FREE.
	if key == "KEYLESS" then
		if version ~= "FREE" then return false, "Wrong key", true end
		getgenv().SCRIPT_KEY = "KEYLESS"
		getgenv().NEO_VERSION = "FREE"
		return true, "OK", false
	end
	if version == "FREE" then
		if not startsWith(key, PREFIX_FREE) then return false, "Wrong key", true end
	elseif version == "PREMIUM" then
		if not startsWith(key, PREFIX_PREMIUM) then return false, "Wrong key", true end
	else
		return false, "Pick a version first", false
	end
	if not Junkie or type(Junkie.check_key) ~= "function" then
		return false, "Key service unavailable", false
	end
	local callOk, result = pcall(Junkie.check_key, key)
	if not callOk then return false, "Could not reach the key service", false end
	if type(result) ~= "table" then return false, "Invalid response", false end
	if not result.valid then return false, "Wrong key", true end
	if result.message == "KEYLESS" or result.is_keyless == true then
		if version ~= "FREE" then return false, "Wrong key", true end
		getgenv().SCRIPT_KEY = "KEYLESS"
		getgenv().NEO_VERSION = "FREE"
		return true, "OK", false
	end
	getgenv().SCRIPT_KEY = key
	getgenv().NEO_VERSION = version
	return true, "OK", false
end

local function copyKeyLink()
	if not Junkie or type(Junkie.get_key_link) ~= "function" then
		return false, "Link unavailable"
	end
	local link, err = nil, nil
	local callOk = pcall(function() link, err = Junkie.get_key_link() end)
	if not callOk then return false, "Could not reach service" end
	if type(link) == "string" and #link > 0 then
		copyText(link)
		return true, "Link copied"
	end
	if err == "RATE_LIMITTED" then return false, "Wait a moment" end
	return false, tostring(err or "Could not get link")
end

do
	local cached = loadCachedKey()
	local cachedVer = loadCachedVersion()
	if cached and cachedVer then
		local okV, _, isInvalid = verifyKey(cached, cachedVer)
		if okV then
			getgenv().NEO_KEY_OK = true
			getgenv().NEO_VERSION = cachedVer
			showToast(cachedVer == "PREMIUM" and "Premium" or "Free")
			runProtectedScript()
			return
		end
		if isInvalid then clearCachedKey() end
	end
end

-- ========================= UI =========================
local done = false
local selectedKey = nil
local selectedVersion = nil
local connections = {}
local starConn = nil

local function bind(c)
	table.insert(connections, c)
	return c
end

pcall(function()
	if parentGui then
		local old = parentGui:FindFirstChild("NeoHyperKeyGate")
		if old then old:Destroy() end
	end
end)

-- sizes
local W1, H1 = 260, 150 -- step 1 tiny
local W2, H2 = 340, 300 -- step 2 key
local PAD = 16

local gui = Instance.new("ScreenGui")
gui.Name = "NeoHyperKeyGate"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
if parentGui then gui.Parent = parentGui end

-- Full-screen star field background
local starLayer = Instance.new("Frame")
starLayer.Name = "Stars"
starLayer.Size = UDim2.fromScale(1, 1)
starLayer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
starLayer.BackgroundTransparency = 0.15
starLayer.BorderSizePixel = 0
starLayer.ZIndex = 1
starLayer.Parent = gui

local stars = {}
local STAR_COUNT = 48
for i = 1, STAR_COUNT do
	local s = Instance.new("Frame")
	s.BorderSizePixel = 0
	s.BackgroundColor3 = white
	s.AnchorPoint = Vector2.new(0.5, 0.5)
	local sz = math.random(1, 3)
	s.Size = UDim2.fromOffset(sz, sz)
	s.Position = UDim2.fromScale(math.random(), math.random())
	s.BackgroundTransparency = math.random(0, 40) / 100
	s.ZIndex = 1
	s.Parent = starLayer
	Instance.new("UICorner", s).CornerRadius = UDim.new(1, 0)
	stars[i] = {
		f = s,
		speed = 0.35 + math.random() * 1.1, -- fast drift
		x = s.Position.X.Scale,
		y = s.Position.Y.Scale,
		tw = math.random() * math.pi * 2,
	}
end

starConn = RunService.RenderStepped:Connect(function(dt)
	dt = math.clamp(dt, 0, 0.05)
	for i = 1, #stars do
		local st = stars[i]
		-- race downward-left (shooting feel)
		st.y = st.y + st.speed * dt * 0.55
		st.x = st.x - st.speed * dt * 0.22
		if st.y > 1.05 or st.x < -0.05 then
			st.y = -math.random() * 0.08
			st.x = math.random() * 1.05
			st.speed = 0.4 + math.random() * 1.2
		end
		st.tw = st.tw + dt * 6
		st.f.Position = UDim2.fromScale(st.x, st.y)
		st.f.BackgroundTransparency = 0.15 + 0.35 * (0.5 + 0.5 * math.sin(st.tw))
	end
end)
table.insert(connections, starConn)

local shade = Instance.new("Frame")
shade.Size = UDim2.fromScale(1, 1)
shade.BackgroundTransparency = 1
shade.BorderSizePixel = 0
shade.ZIndex = 2
shade.Parent = gui

local shell = Instance.new("Frame")
shell.Name = "Shell"
shell.AnchorPoint = Vector2.new(0.5, 0.5)
shell.Position = UDim2.fromScale(0.5, 0.5)
shell.Size = UDim2.fromOffset(0, 0)
shell.BackgroundTransparency = 1
shell.BorderSizePixel = 0
shell.ZIndex = 3
shell.Parent = shade

local border = Instance.new("Frame")
border.Size = UDim2.fromScale(1, 1)
border.BackgroundColor3 = white
border.BorderSizePixel = 0
border.Parent = shell
Instance.new("UICorner", border).CornerRadius = UDim.new(0, 14)

local panel = Instance.new("Frame")
panel.AnchorPoint = Vector2.new(0.5, 0.5)
panel.Position = UDim2.fromScale(0.5, 0.5)
panel.Size = UDim2.new(1, -2, 1, -2)
panel.BackgroundColor3 = black
panel.BorderSizePixel = 0
panel.ClipsDescendants = true
panel.Parent = border
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 13)

-- drag
local dragBar = Instance.new("TextButton")
dragBar.Size = UDim2.new(1, 0, 0, 40)
dragBar.BackgroundTransparency = 1
dragBar.Text = ""
dragBar.ZIndex = 5
dragBar.Parent = panel
local dragging, dragStart, startPos = false, nil, nil
bind(dragBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = shell.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end))
bind(UserInputService.InputChanged:Connect(function(input)
	if not dragging or not dragStart or not startPos then return end
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		local d = input.Position - dragStart
		shell.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
	end
end))

local titleL = Instance.new("TextLabel")
titleL.BackgroundTransparency = 1
titleL.Position = UDim2.fromOffset(0, 12)
titleL.Size = UDim2.new(1, 0, 0, 26)
titleL.Font = Enum.Font.GothamBold
titleL.TextSize = 20
titleL.TextColor3 = white
titleL.Text = "Neo Hyper"
titleL.Parent = panel

-- ===== STEP 1: only two buttons =====
local freeBtn = Instance.new("TextButton")
freeBtn.Name = "Free"
freeBtn.Position = UDim2.fromOffset(PAD, 52)
freeBtn.Size = UDim2.new(0.5, -PAD - 4, 0, 40)
freeBtn.BackgroundColor3 = fieldBg
freeBtn.BorderSizePixel = 0
freeBtn.Font = Enum.Font.GothamBold
freeBtn.TextSize = 14
freeBtn.TextColor3 = white
freeBtn.Text = "Free"
freeBtn.AutoButtonColor = false
freeBtn.Parent = panel
Instance.new("UICorner", freeBtn).CornerRadius = UDim.new(0, 10)

local premBtn = Instance.new("TextButton")
premBtn.Name = "Premium"
premBtn.AnchorPoint = Vector2.new(1, 0)
premBtn.Position = UDim2.new(1, -PAD, 0, 52)
premBtn.Size = UDim2.new(0.5, -PAD - 4, 0, 40)
premBtn.BackgroundColor3 = white
premBtn.BorderSizePixel = 0
premBtn.Font = Enum.Font.GothamBold
premBtn.TextSize = 14
premBtn.TextColor3 = black
premBtn.Text = "Premium"
premBtn.AutoButtonColor = false
premBtn.Parent = panel
Instance.new("UICorner", premBtn).CornerRadius = UDim.new(0, 10)

freeBtn.MouseEnter:Connect(function()
	TweenService:Create(freeBtn, TweenInfo.new(0.1), { BackgroundColor3 = Color3.fromRGB(32, 32, 32) }):Play()
end)
freeBtn.MouseLeave:Connect(function()
	TweenService:Create(freeBtn, TweenInfo.new(0.1), { BackgroundColor3 = fieldBg }):Play()
end)
premBtn.MouseEnter:Connect(function()
	TweenService:Create(premBtn, TweenInfo.new(0.1), { BackgroundColor3 = Color3.fromRGB(220, 220, 220) }):Play()
end)
premBtn.MouseLeave:Connect(function()
	TweenService:Create(premBtn, TweenInfo.new(0.1), { BackgroundColor3 = white }):Play()
end)

local exitBtn = Instance.new("TextButton")
exitBtn.BackgroundTransparency = 1
exitBtn.AnchorPoint = Vector2.new(0.5, 1)
exitBtn.Position = UDim2.new(0.5, 0, 1, -10)
exitBtn.Size = UDim2.fromOffset(60, 18)
exitBtn.Font = Enum.Font.Gotham
exitBtn.TextSize = 12
exitBtn.TextColor3 = Color3.fromRGB(100, 100, 100)
exitBtn.Text = "Exit"
exitBtn.AutoButtonColor = false
exitBtn.Parent = panel

-- ===== STEP 2 elements (hidden) =====
local hintL = Instance.new("TextLabel")
hintL.BackgroundTransparency = 1
hintL.Position = UDim2.fromOffset(PAD, 42)
hintL.Size = UDim2.new(1, -PAD * 2, 0, 18)
hintL.Font = Enum.Font.Gotham
hintL.TextSize = 12
hintL.TextColor3 = mutedText
hintL.Text = "Enter your key"
hintL.Visible = false
hintL.Parent = panel

local box = Instance.new("TextBox")
box.Position = UDim2.fromOffset(PAD, 68)
box.Size = UDim2.new(1, -PAD * 2, 0, 40)
box.BackgroundColor3 = fieldBg
box.BorderSizePixel = 0
box.Font = Enum.Font.GothamMedium
box.TextSize = 14
box.TextColor3 = white
box.PlaceholderText = "Key"
box.PlaceholderColor3 = Color3.fromRGB(90, 90, 90)
box.Text = ""
box.ClearTextOnFocus = false
box.TextXAlignment = Enum.TextXAlignment.Center
box.Visible = false
box.Parent = panel
Instance.new("UICorner", box).CornerRadius = UDim.new(0, 10)

local status = Instance.new("TextLabel")
status.BackgroundTransparency = 1
status.Position = UDim2.fromOffset(PAD, 114)
status.Size = UDim2.new(1, -PAD * 2, 0, 16)
status.Font = Enum.Font.Gotham
status.TextSize = 12
status.TextColor3 = redText
status.TextXAlignment = Enum.TextXAlignment.Left
status.Text = ""
status.Visible = false
status.Parent = panel

local function makeSmallBtn(name, xScale, y, primary)
	local b = Instance.new("TextButton")
	b.Name = name
	b.AnchorPoint = Vector2.new(xScale, 0)
	b.Position = UDim2.new(xScale, xScale == 0 and PAD or -PAD, 0, y)
	b.Size = UDim2.new(0.5, -PAD - 4, 0, 36)
	b.BorderSizePixel = 0
	b.Font = Enum.Font.GothamBold
	b.TextSize = 13
	b.Text = name
	b.AutoButtonColor = false
	b.Visible = false
	b.Parent = panel
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
	if primary then
		b.BackgroundColor3 = white
		b.TextColor3 = black
	else
		b.BackgroundColor3 = fieldBg
		b.TextColor3 = white
	end
	return b
end

local linkBtn = makeSmallBtn("Get Key", 0, 140, false)
local checkBtn = makeSmallBtn("Submit", 1, 140, true)
local discordBtn = makeSmallBtn("Discord", 0, 186, false)
local websiteBtn = makeSmallBtn("Website", 1, 186, false)

local backBtn = Instance.new("TextButton")
backBtn.BackgroundTransparency = 1
backBtn.Position = UDim2.fromOffset(PAD, 0)
backBtn.Size = UDim2.fromOffset(50, 18)
backBtn.AnchorPoint = Vector2.new(0, 1)
backBtn.Position = UDim2.new(0, PAD, 1, -10)
backBtn.Font = Enum.Font.Gotham
backBtn.TextSize = 12
backBtn.TextColor3 = Color3.fromRGB(100, 100, 100)
backBtn.Text = "← Back"
backBtn.Visible = false
backBtn.AutoButtonColor = false
backBtn.Parent = panel

local function setStatus(msg, isError)
	status.Text = tostring(msg or "")
	status.TextColor3 = isError and redText or mutedText
end

local function tweenSize(w, h)
	TweenService:Create(shell, TweenInfo.new(0.32, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.fromOffset(w, h),
	}):Play()
end

local function showStep1()
	selectedVersion = nil
	titleL.Text = "Neo Hyper"
	titleL.TextSize = 20
	titleL.Position = UDim2.fromOffset(0, 12)
	freeBtn.Visible = true
	premBtn.Visible = true
	hintL.Visible = false
	box.Visible = false
	status.Visible = false
	linkBtn.Visible = false
	checkBtn.Visible = false
	discordBtn.Visible = false
	websiteBtn.Visible = false
	backBtn.Visible = false
	exitBtn.Visible = true
	exitBtn.AnchorPoint = Vector2.new(0.5, 1)
	exitBtn.Position = UDim2.new(0.5, 0, 1, -10)
	tweenSize(W1, H1)
end

local function showStep2(version)
	selectedVersion = version
	getgenv().NEO_VERSION = version
	titleL.Text = version == "PREMIUM" and "Premium" or "Free"
	titleL.TextSize = 18
	titleL.Position = UDim2.fromOffset(0, 10)
	freeBtn.Visible = false
	premBtn.Visible = false
	hintL.Visible = true
	hintL.Text = "Enter your key to continue"
	box.Visible = true
	box.Text = ""
	status.Visible = true
	setStatus("", false)
	linkBtn.Visible = true
	checkBtn.Visible = true
	discordBtn.Visible = true
	websiteBtn.Visible = true
	backBtn.Visible = true
	exitBtn.Visible = true
	exitBtn.AnchorPoint = Vector2.new(1, 1)
	exitBtn.Position = UDim2.new(1, -PAD, 1, -10)
	tweenSize(W2, H2)
end

-- open as tiny step 1
TweenService:Create(shell, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
	Size = UDim2.fromOffset(W1, H1),
}):Play()

local checking, linking = false, false

local function cleanup()
	for i = 1, #connections do
		pcall(function() connections[i]:Disconnect() end)
	end
	pcall(function() if gui then gui:Destroy() end end)
end

local function finishSuccess()
	selectedKey = getgenv().SCRIPT_KEY
	getgenv().NEO_KEY_OK = true
	done = true
	TweenService:Create(shell, TweenInfo.new(0.18), { Size = UDim2.fromOffset(0, 0) }):Play()
	TweenService:Create(starLayer, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
end

local function submit()
	if checking or done or not selectedVersion then return end
	checking = true
	setStatus("Checking...", false)
	task.spawn(function()
		local okV, msg = verifyKey(box.Text, selectedVersion)
		if okV then
			local clean = string.gsub(tostring(box.Text or ""), "%s+", "")
			if getgenv().SCRIPT_KEY ~= "KEYLESS" and #clean > 0 then
				saveCachedKey(clean)
			end
			saveCachedVersion(selectedVersion)
			setStatus("OK", false)
			finishSuccess()
		else
			setStatus(msg, true)
			local origin = shell.Position
			for i = 1, 4 do
				shell.Position = origin + UDim2.fromOffset((i % 2 ~= 0) and -3 or 3, 0)
				task.wait(0.03)
			end
			shell.Position = origin
		end
		checking = false
	end)
end

freeBtn.MouseButton1Click:Connect(function()
	if done then return end
	showStep2("FREE")
end)
premBtn.MouseButton1Click:Connect(function()
	if done then return end
	showStep2("PREMIUM")
end)
backBtn.MouseButton1Click:Connect(function()
	if done or checking then return end
	showStep1()
end)
checkBtn.MouseButton1Click:Connect(submit)
linkBtn.MouseButton1Click:Connect(function()
	if linking then return end
	linking = true
	setStatus("Getting link...", false)
	task.spawn(function()
		local okL, msg = copyKeyLink()
		setStatus(msg, not okL)
		linking = false
	end)
end)
discordBtn.MouseButton1Click:Connect(function()
	copyText(DISCORD_LINK)
	setStatus("Discord copied", false)
end)
websiteBtn.MouseButton1Click:Connect(function()
	copyText(WEBSITE_LINK)
	setStatus("Website copied", false)
end)
exitBtn.MouseButton1Click:Connect(function()
	if done then return end
	done = true
	selectedKey = nil
	getgenv().SCRIPT_KEY = nil
	getgenv().NEO_KEY_OK = false
	getgenv().NEO_VERSION = nil
	getgenv().UI_CLOSED = true
	TweenService:Create(shell, TweenInfo.new(0.16), { Size = UDim2.fromOffset(0, 0) }):Play()
	TweenService:Create(starLayer, TweenInfo.new(0.18), { BackgroundTransparency = 1 }):Play()
end)
box.FocusLost:Connect(function(enter)
	if enter then submit() end
end)

repeat task.wait() until done
cleanup()

if not selectedKey then
	getgenv().UI_CLOSED = true
	getgenv().SCRIPT_KEY = nil
	getgenv().NEO_KEY_OK = false
	getgenv().NEO_VERSION = nil
	return
end

getgenv().SCRIPT_KEY = selectedKey
getgenv().NEO_KEY_OK = true
showToast(getgenv().NEO_VERSION == "PREMIUM" and "Premium" or "Free")
runProtectedScript()
