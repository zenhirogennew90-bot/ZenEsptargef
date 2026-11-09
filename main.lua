--[[ ============================================================
     TARGET PLAYER ESP — ELEGANT EDITION
     Minimalist · Square · Gold accents · Refined UI
============================================================ ]]

local Players      = game:GetService("Players")
local RunService   = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UIS          = game:GetService("UserInputService")
local LP           = Players.LocalPlayer
local Camera       = workspace.CurrentCamera

-- ===== THEME PALETTE =====
local T = {
    bg        = Color3.fromRGB(10, 10, 13),
    panel     = Color3.fromRGB(18, 18, 22),
    surface   = Color3.fromRGB(26, 26, 32),
    surfaceHi = Color3.fromRGB(34, 34, 42),
    gold      = Color3.fromRGB(201, 169, 97),
    goldHi    = Color3.fromRGB(232, 202, 130),
    goldDim   = Color3.fromRGB(120, 100, 62),
    text      = Color3.fromRGB(232, 227, 216),
    textDim   = Color3.fromRGB(138, 132, 118),
    danger    = Color3.fromRGB(160, 62, 62),
    dangerHi  = Color3.fromRGB(200, 82, 82),
    accentBg  = Color3.fromRGB(38, 32, 22),
}

local Config = {
    enabled      = true,
    targets      = {},
    chamsColor   = T.gold,
    textSize     = 16,
    showChams    = true,
    showDistance = true,
}

-- ===== CLEANUP =====
if _G.__TargetESPConn then _G.__TargetESPConn:Disconnect() end
local parentGui = (gethui and gethui()) or game:GetService("CoreGui")
local old = parentGui:FindFirstChild("TargetESP_Panel")
if old then old:Destroy() end

-- ===== GUI ROOT =====
local gui = Instance.new("ScreenGui")
gui.Name = "TargetESP_Panel"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
pcall(function() gui.Parent = parentGui end)
if not gui.Parent then gui.Parent = LP:WaitForChild("PlayerGui") end

-- ===== UTILS =====
local function addCorner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 2)
    c.Parent = p
    return c
end

local function addStroke(p, color, thick, trans)
    local s = Instance.new("UIStroke")
    s.Color = color or T.gold
    s.Thickness = thick or 1
    s.Transparency = trans or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = p
    return s
end

local function tw(inst, props, dur, style)
    local info = TweenInfo.new(dur or 0.16, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local t = TweenService:Create(inst, info, props)
    t:Play()
    return t
end

-- ===== TOGGLE BUTTON (kotak minimalis) =====
local toggle = Instance.new("TextButton")
toggle.Name = "Toggle"
toggle.Size = UDim2.fromOffset(46, 46)
toggle.Position = UDim2.fromOffset(24, 24)
toggle.BackgroundColor3 = T.panel
toggle.Text = ""
toggle.AutoButtonColor = false
toggle.BorderSizePixel = 0
toggle.Parent = gui
addCorner(toggle, 2)
local toggleStroke = addStroke(toggle, T.gold, 1, 0.15)

local icon = Instance.new("TextLabel")
icon.BackgroundTransparency = 1
icon.Size = UDim2.fromScale(1, 1)
icon.Text = "◆"
icon.Font = Enum.Font.GothamBold
icon.TextSize = 16
icon.TextColor3 = T.gold
icon.Parent = toggle

local badge = Instance.new("TextLabel")
badge.BackgroundColor3 = T.gold
badge.Size = UDim2.fromOffset(18, 18)
badge.Position = UDim2.new(1, -9, 0, -9)
badge.Text = "0"
badge.Font = Enum.Font.GothamBold
badge.TextSize = 10
badge.TextColor3 = T.bg
badge.Visible = false
badge.Parent = toggle
addCorner(badge, 9)

-- ===== PANEL =====
local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.Size = UDim2.fromOffset(320, 470)
panel.Position = UDim2.new(0.5, -160, 0.5, -235)
panel.BackgroundColor3 = T.panel
panel.BorderSizePixel = 0
panel.Visible = false
panel.Parent = gui
addCorner(panel, 3)
addStroke(panel, T.goldDim, 1, 0.25)

-- garis emas halus di bawah header
local topLine = Instance.new("Frame")
topLine.BackgroundColor3 = T.gold
topLine.Size = UDim2.new(1, -40, 0, 1)
topLine.Position = UDim2.new(0, 20, 0, 54)
topLine.BorderSizePixel = 0
topLine.BackgroundTransparency = 0.4
topLine.Parent = panel

-- ===== HEADER =====
local header = Instance.new("Frame")
header.BackgroundTransparency = 1
header.Size = UDim2.new(1, 0, 0, 54)
header.Parent = panel

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Text = "T A R G E T   E S P"
title.Font = Enum.Font.Garamond
title.TextSize = 20
title.TextColor3 = T.text
title.Position = UDim2.fromOffset(20, 14)
title.Size = UDim2.new(1, -60, 0, 24)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local subtitle = Instance.new("TextLabel")
subtitle.BackgroundTransparency = 1
subtitle.Text = "E L E G A N T   ·   E D I T I O N"
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 9
subtitle.TextColor3 = T.textDim
subtitle.Position = UDim2.fromOffset(20, 36)
subtitle.Size = UDim2.new(1, -60, 0, 12)
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = header

-- CLOSE ×
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.fromOffset(28, 28)
closeBtn.Position = UDim2.new(1, -38, 0, 13)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "×"
closeBtn.Font = Enum.Font.Gotham
closeBtn.TextSize = 22
closeBtn.TextColor3 = T.textDim
closeBtn.AutoButtonColor = false
closeBtn.Parent = header
closeBtn.MouseEnter:Connect(function() tw(closeBtn, {TextColor3 = T.gold}, 0.15) end)
closeBtn.MouseLeave:Connect(function() tw(closeBtn, {TextColor3 = T.textDim}, 0.15) end)
closeBtn.MouseButton1Click:Connect(function() panel.Visible = false end)

-- ===== INPUT =====
local inputWrap = Instance.new("Frame")
inputWrap.BackgroundColor3 = T.surface
inputWrap.BorderSizePixel = 0
inputWrap.Position = UDim2.fromOffset(20, 70)
inputWrap.Size = UDim2.new(1, -40, 0, 38)
inputWrap.Parent = panel
addCorner(inputWrap, 2)
local inputStroke = addStroke(inputWrap, T.goldDim, 1, 0.55)

local input = Instance.new("TextBox")
input.BackgroundTransparency = 1
input.Size = UDim2.new(1, -20, 1, 0)
input.Position = UDim2.fromOffset(12, 0)
input.Font = Enum.Font.Gotham
input.TextSize = 12
input.TextColor3 = T.text
input.PlaceholderText = "Search by username or display name..."
input.PlaceholderColor3 = T.textDim
input.Text = ""
input.ClearTextOnFocus = false
input.TextXAlignment = Enum.TextXAlignment.Left
input.Parent = inputWrap

input.Focused:Connect(function()
    tw(inputStroke, {Color = T.gold, Transparency = 0}, 0.15)
end)
input.FocusLost:Connect(function()
    tw(inputStroke, {Color = T.goldDim, Transparency = 0.55}, 0.15)
end)

-- ===== ADD BUTTON =====
local addBtn = Instance.new("TextButton")
addBtn.BackgroundColor3 = T.surface
addBtn.Text = "+   A D D   T A R G E T"
addBtn.Font = Enum.Font.GothamSemibold
addBtn.TextSize = 11
addBtn.TextColor3 = T.gold
addBtn.AutoButtonColor = false
addBtn.BorderSizePixel = 0
addBtn.Position = UDim2.fromOffset(20, 116)
addBtn.Size = UDim2.new(1, -40, 0, 34)
addBtn.Parent = panel
addCorner(addBtn, 2)
local addStroke = addStroke(addBtn, T.goldDim, 1, 0.25)

addBtn.MouseEnter:Connect(function()
    tw(addBtn, {BackgroundColor3 = T.gold}, 0.16)
    tw(addBtn, {TextColor3 = T.bg}, 0.16)
    tw(addStroke, {Transparency = 0}, 0.16)
end)
addBtn.MouseLeave:Connect(function()
    tw(addBtn, {BackgroundColor3 = T.surface}, 0.16)
    tw(addBtn, {TextColor3 = T.gold}, 0.16)
    tw(addStroke, {Transparency = 0.25}, 0.16)
end)

-- ===== SECTION LABEL =====
local sectionLbl = Instance.new("TextLabel")
sectionLbl.BackgroundTransparency = 1
sectionLbl.Text = "S E L E C T E D   T A R G E T S"
sectionLbl.Font = Enum.Font.Gotham
sectionLbl.TextSize = 9
sectionLbl.TextColor3 = T.textDim
sectionLbl.Position = UDim2.fromOffset(20, 160)
sectionLbl.Size = UDim2.new(1, -40, 0, 14)
sectionLbl.TextXAlignment = Enum.TextXAlignment.Left
sectionLbl.Parent = panel

local sectionBar = Instance.new("Frame")
sectionBar.BackgroundColor3 = T.gold
sectionBar.Size = UDim2.fromOffset(14, 1)
sectionBar.Position = UDim2.new(1, -34, 0, 166)
sectionBar.BorderSizePixel = 0
sectionBar.Parent = panel

-- ===== LIST =====
local list = Instance.new("ScrollingFrame")
list.BackgroundColor3 = T.surface
list.BorderSizePixel = 0
list.Position = UDim2.fromOffset(20, 184)
list.Size = UDim2.new(1, -40, 1, -236)
list.CanvasSize = UDim2.new()
list.ScrollBarThickness = 3
list.ScrollBarImageColor3 = T.goldDim
list.AutomaticCanvasSize = Enum.AutomaticSize.Y
list.Parent = panel
addCorner(list, 2)
addStroke(list, T.surfaceHi, 1, 0.4)

local listPad = Instance.new("UIPadding")
listPad.PaddingTop = UDim.new(0, 6)
listPad.PaddingBottom = UDim.new(0, 6)
listPad.PaddingLeft = UDim.new(0, 6)
listPad.PaddingRight = UDim.new(0, 6)
listPad.Parent = list

local ll = Instance.new("UIListLayout")
ll.Padding = UDim.new(0, 4)
ll.SortOrder = Enum.SortOrder.LayoutOrder
ll.Parent = list

-- ===== CLEAR BUTTON =====
local clearBtn = Instance.new("TextButton")
clearBtn.BackgroundColor3 = T.surface
clearBtn.Text = "C L E A R   A L L"
clearBtn.Font = Enum.Font.GothamSemibold
clearBtn.TextSize = 10
clearBtn.TextColor3 = T.dangerHi
clearBtn.AutoButtonColor = false
clearBtn.BorderSizePixel = 0
clearBtn.Position = UDim2.new(0, 20, 1, -44)
clearBtn.Size = UDim2.new(1, -40, 0, 28)
clearBtn.Parent = panel
addCorner(clearBtn, 2)
local clearStroke = addStroke(clearBtn, T.danger, 1, 0.5)

clearBtn.MouseEnter:Connect(function()
    tw(clearBtn, {BackgroundColor3 = T.danger}, 0.16)
    tw(clearBtn, {TextColor3 = T.text}, 0.16)
    tw(clearStroke, {Transparency = 0}, 0.16)
end)
clearBtn.MouseLeave:Connect(function()
    tw(clearBtn, {BackgroundColor3 = T.surface}, 0.16)
    tw(clearBtn, {TextColor3 = T.dangerHi}, 0.16)
    tw(clearStroke, {Transparency = 0.5}, 0.16)
end)

-- ===== FOOTER =====
local footer = Instance.new("TextLabel")
footer.BackgroundTransparency = 1
footer.Text = "drag header to move  ·  esc to close"
footer.Font = Enum.Font.Gotham
footer.TextSize = 9
footer.TextColor3 = T.textDim
footer.Position = UDim2.new(0, 0, 1, -14)
footer.Size = UDim2.new(1, 0, 0, 14)
footer.Parent = panel

-- ===== DRAGGABLE =====
do
    local dragging, startPos, startInput
    header.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true; startInput = i.Position; startPos = panel.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    header.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - startInput
            panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

-- ===== HELPERS =====
local function makeLabel(p)
    if p.DisplayName and p.DisplayName ~= "" and p.DisplayName ~= p.Name then
        return p.DisplayName .. "  ·  @" .. p.Name
    end
    return p.Name
end

local function updateBadge()
    local n = 0
    for _ in pairs(Config.targets) do n = n + 1 end
    badge.Text = tostring(n)
    badge.Visible = n > 0
end

-- ===== REFRESH LIST =====
local function refreshList()
    for _, c in ipairs(list:GetChildren()) do
        if c:IsA("TextButton") or c:IsA("TextLabel") then c:Destroy() end
    end

    local entries, seen = {}, {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then
            seen[p.Name] = true
            entries[#entries+1] = { key = p.Name, label = makeLabel(p), online = true }
        end
    end
    for name in pairs(Config.targets) do
        if not seen[name] then
            entries[#entries+1] = { key = name, label = name .. "   (offline)", online = false }
        end
    end
    table.sort(entries, function(a,b) return a.label:lower() < b.label:lower() end)

    if #entries == 0 then
        local empty = Instance.new("TextLabel")
        empty.BackgroundTransparency = 1
        empty.Size = UDim2.new(1, 0, 0, 40)
        empty.Text = "no players in server"
        empty.Font = Enum.Font.Gotham
        empty.TextSize = 11
        empty.TextColor3 = T.textDim
        empty.LayoutOrder = 1
        empty.Parent = list
        updateBadge()
        return
    end

    for i, e in ipairs(entries) do
        local active = Config.targets[e.key]
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 32)
        btn.LayoutOrder = i
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 11
        btn.TextTruncate = Enum.TextTruncate.AtEnd
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Text = "    " .. e.label
        btn.AutoButtonColor = false
        btn.BorderSizePixel = 0
        btn.BackgroundColor3 = active and T.accentBg or T.surface
        btn.TextColor3 = active and T.goldHi or T.text
        btn.Parent = list
        addCorner(btn, 1)

        -- accent bar kiri saat terpilih
        if active then
            local bar = Instance.new("Frame")
            bar.BackgroundColor3 = T.gold
            bar.Size = UDim2.new(0, 2, 1, -10)
            bar.Position = UDim2.new(0, 0, 0, 5)
            bar.BorderSizePixel = 0
            bar.Parent = btn
        end

        -- diamond indicator
        local check = Instance.new("TextLabel")
        check.BackgroundTransparency = 1
        check.Size = UDim2.fromOffset(16, 16)
        check.Position = UDim2.new(1, -22, 0.5, -8)
        check.Text = active and "◆" or "◇"
        check.Font = Enum.Font.Gotham
        check.TextSize = 12
        check.TextColor3 = active and T.gold or T.textDim
        check.Parent = btn

        btn.MouseEnter:Connect(function()
            if not Config.targets[e.key] then
                tw(btn, {BackgroundColor3 = T.surfaceHi}, 0.14)
            end
        end)
        btn.MouseLeave:Connect(function()
            if not Config.targets[e.key] then
                tw(btn, {BackgroundColor3 = T.surface}, 0.14)
            end
        end)
        btn.MouseButton1Click:Connect(function()
            if Config.targets[e.key] then Config.targets[e.key] = nil
            else Config.targets[e.key] = true end
            refreshList()
        end)
    end

    updateBadge()
end

-- ===== ADD BY NAME =====
local function addByName()
    local txt = (input.Text or ""):gsub("^%s+",""):gsub("%s+$","")
    if txt == "" then return end
    local q = txt:lower()
    local exactUser, exactDisp, partial
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then
            local un = p.Name:lower()
            local dn = (p.DisplayName or ""):lower()
            if un == q then exactUser = p end
            if dn == q and not exactDisp then exactDisp = p end
            if not partial and (un:find(q, 1, true) or dn:find(q, 1, true)) then
                partial = p
            end
        end
    end
    local picked = exactUser or exactDisp or partial
    local key = picked and picked.Name or txt
    if Config.targets[key] then Config.targets[key] = nil
    else Config.targets[key] = true end
    input.Text = ""
    refreshList()
end

-- ===== WIRING =====
toggle.MouseButton1Click:Connect(function()
    panel.Visible = not panel.Visible
    tw(toggleStroke, {Transparency = panel.Visible and 0 or 0.15}, 0.15)
end)
addBtn.MouseButton1Click:Connect(addByName)
input.FocusLost:Connect(function(enter) if enter then addByName() end end)
clearBtn.MouseButton1Click:Connect(function()
    for k in pairs(Config.targets) do Config.targets[k] = nil end
    refreshList()
end)
Players.PlayerAdded:Connect(refreshList)
Players.PlayerRemoving:Connect(refreshList)

-- ESC menutup panel
UIS.InputBegan:Connect(function(obj, gp)
    if gp then return end
    if obj.KeyCode == Enum.KeyCode.Escape and panel.Visible then
        panel.Visible = false
        tw(toggleStroke, {Transparency = 0.15}, 0.15)
    end
end)

-- ===== ESP LOOP =====
local function clearESP(char)
    local hl = char:FindFirstChild("TargetESP_Highlight"); if hl then hl:Destroy() end
    local head = char:FindFirstChild("Head")
    if head then
        local bb = head:FindFirstChild("TargetESP_Dist"); if bb then bb:Destroy() end
    end
end

_G.__TargetESPConn = RunService.RenderStepped:Connect(function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP then
            local char = plr.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local targeted = Config.enabled and Config.targets[plr.Name]
                if targeted then
                    if Config.showChams then
                        local hl = char:FindFirstChild("TargetESP_Highlight")
                        if not hl then
                            hl = Instance.new("Highlight")
                            hl.Name = "TargetESP_Highlight"
                            hl.FillTransparency = 0.6
                            hl.OutlineTransparency = 0.15
                            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            hl.Parent = char
                        end
                        hl.Adornee = char
                        hl.FillColor = Config.chamsColor
                        hl.OutlineColor = T.goldHi
                    else
                        local hl = char:FindFirstChild("TargetESP_Highlight")
                        if hl then hl:Destroy() end
                    end

                    local head = char:FindFirstChild("Head")
                    if head then
                        if Config.showDistance then
                            local bb = head:FindFirstChild("TargetESP_Dist")
                            if not bb then
                                bb = Instance.new("BillboardGui")
                                bb.Name = "TargetESP_Dist"
                                bb.Size = UDim2.fromOffset(110, 26)
                                bb.StudsOffset = Vector3.new(0, 2.5, 0)
                                bb.AlwaysOnTop = true
                                bb.MaxDistance = 1500
                                local lbl = Instance.new("TextLabel")
                                lbl.Name = "Label"
                                lbl.Size = UDim2.fromScale(1, 1)
                                lbl.BackgroundTransparency = 1
                                lbl.Font = Enum.Font.Garamond
                                lbl.TextSize = Config.textSize
                                lbl.TextColor3 = T.goldHi
                                lbl.TextStrokeTransparency = 0.35
                                lbl.TextStrokeColor3 = Color3.fromRGB(0,0,0)
                                lbl.Text = ""
                                lbl.Parent = bb
                                bb.Parent = head
                            end
                            local lbl = bb:FindFirstChild("Label")
                            if lbl and Camera then
                                local dist = (Camera.CFrame.Position - char.HumanoidRootPart.Position).Magnitude
                                lbl.Text = string.format("◆  %d m", math.floor(dist))
                                lbl.TextColor3 = Config.chamsColor
                                lbl.TextSize = Config.textSize
                            end
                        else
                            local bb = head:FindFirstChild("TargetESP_Dist")
                            if bb then bb:Destroy() end
                        end
                    end
                else
                    clearESP(char)
                end
            end
        end
    end
end)

refreshList()
print("[TargetESP · Elegant Edition] Loaded — minimal, square, refined.")
