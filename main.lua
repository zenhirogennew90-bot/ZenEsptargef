--[[ ==========================================================
     TARGET PLAYER ESP — Chams + Distance (v2)
     NEW: cari pakai DisplayName atau Username
========================================================== ]]

local Players   = game:GetService("Players")
local RunService= game:GetService("RunService")
local LP        = Players.LocalPlayer
local Camera    = workspace.CurrentCamera

-- ===== CONFIG =====
local Config = {
    enabled     = true,
    targets     = {},                       -- [username] = true
    chamsColor  = Color3.fromRGB(255, 70, 70),
    textSize    = 16,
    showChams   = true,
    showDistance= true,
}

if _G.__TargetESPConn then _G.__TargetESPConn:Disconnect() end
local parentGui = (gethui and gethui()) or game:GetService("CoreGui")
local old = parentGui:FindFirstChild("TargetESP_Panel")
if old then old:Destroy() end

-- ===== GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "TargetESP_Panel"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
pcall(function() gui.Parent = parentGui end)
if not gui.Parent then gui.Parent = LP:WaitForChild("PlayerGui") end

-- Toggle Button
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.fromOffset(110, 34)
toggle.Position = UDim2.new(0, 20, 0, 20)
toggle.BackgroundColor3 = Color3.fromRGB(25,25,30)
toggle.TextColor3 = Color3.fromRGB(0,255,170)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 13
toggle.Text = "ESP TARGET"
toggle.BorderSizePixel = 0
toggle.Parent = gui
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 8)
local ts = Instance.new("UIStroke", toggle)
ts.Color = Color3.fromRGB(0,255,170); ts.Thickness = 1

-- Panel
local panel = Instance.new("Frame")
panel.Size = UDim2.fromOffset(300, 420)
panel.Position = UDim2.new(0.5, -150, 0.5, -210)
panel.BackgroundColor3 = Color3.fromRGB(20,20,25)
panel.BorderSizePixel = 0
panel.Visible = false
panel.Parent = gui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 12)
local ps = Instance.new("UIStroke", panel)
ps.Color = Color3.fromRGB(0,255,170); ps.Thickness = 1.5

-- Header
local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(0,255,170)
header.BackgroundTransparency = 0.85
header.Text = "TARGET PLAYER ESP"
header.TextColor3 = Color3.fromRGB(0,255,170)
header.Font = Enum.Font.GothamBold
header.TextSize = 14
header.Parent = panel
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)

-- Input
local input = Instance.new("TextBox")
input.Size = UDim2.new(1, -20, 0, 34)
input.Position = UDim2.new(0, 10, 0, 50)
input.BackgroundColor3 = Color3.fromRGB(35,35,42)
input.TextColor3 = Color3.fromRGB(240,240,240)
input.PlaceholderText = "Username / Display Name... (Enter)"
input.PlaceholderColor3 = Color3.fromRGB(130,130,140)
input.Font = Enum.Font.Gotham
input.TextSize = 12
input.Text = ""
input.ClearTextOnFocus = false
input.Parent = panel
Instance.new("UICorner", input).CornerRadius = UDim.new(0, 6)
local is = Instance.new("UIStroke", input)
is.Color = Color3.fromRGB(0,255,170); is.Transparency = 0.6

-- Tombol Tambah
local addBtn = Instance.new("TextButton")
addBtn.Size = UDim2.new(1, -20, 0, 30)
addBtn.Position = UDim2.new(0, 10, 0, 90)
addBtn.BackgroundColor3 = Color3.fromRGB(0,200,140)
addBtn.TextColor3 = Color3.fromRGB(15,15,20)
addBtn.Font = Enum.Font.GothamBold
addBtn.TextSize = 13
addBtn.Text = "+ Cari & Toggle Target"
addBtn.Parent = panel
Instance.new("UICorner", addBtn).CornerRadius = UDim.new(0,6)

-- Judul list
local listTitle = Instance.new("TextLabel")
listTitle.Size = UDim2.new(1, -20, 0, 22)
listTitle.Position = UDim2.new(0, 10, 0, 128)
listTitle.BackgroundTransparency = 1
listTitle.Text = "Pilih Manual:"
listTitle.TextColor3 = Color3.fromRGB(200,200,210)
listTitle.Font = Enum.Font.GothamBold
listTitle.TextSize = 12
listTitle.TextXAlignment = Enum.TextXAlignment.Left
listTitle.Parent = panel

-- Scroll list
local list = Instance.new("ScrollingFrame")
list.Size = UDim2.new(1, -20, 1, -206)
list.Position = UDim2.new(0, 10, 0, 154)
list.BackgroundColor3 = Color3.fromRGB(28,28,34)
list.BorderSizePixel = 0
list.CanvasSize = UDim2.new(0,0,0,0)
list.ScrollBarThickness = 4
list.AutomaticCanvasSize = Enum.AutomaticSize.Y
list.Parent = panel
Instance.new("UICorner", list).CornerRadius = UDim.new(0,6)
local ll = Instance.new("UIListLayout", list)
ll.Padding = UDim.new(0,4); ll.SortOrder = Enum.SortOrder.LayoutOrder

-- Clear
local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(1, -20, 0, 30)
clearBtn.Position = UDim2.new(0, 10, 1, -40)
clearBtn.BackgroundColor3 = Color3.fromRGB(220,60,60)
clearBtn.TextColor3 = Color3.fromRGB(255,255,255)
clearBtn.Font = Enum.Font.GothamBold
clearBtn.TextSize = 12
clearBtn.Text = "Clear Semua Target"
clearBtn.Parent = panel
Instance.new("UICorner", clearBtn).CornerRadius = UDim.new(0,6)

-- Draggable
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
-- Label yang ditampilkan di list: "DisplayName (@Username)"
local function makeLabel(p)
    if p.DisplayName and p.DisplayName ~= "" and p.DisplayName ~= p.Name then
        return p.DisplayName .. " (@" .. p.Name .. ")"
    end
    return p.Name
end

-- ===== REFRESH LIST =====
local function refreshList()
    for _, c in ipairs(list:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end

    local entries = {}   -- {key = username, label = string, online = bool}
    local seen = {}

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then
            seen[p.Name] = true
            entries[#entries+1] = {
                key = p.Name,
                label = makeLabel(p),
                online = true,
            }
        end
    end

    -- Target yang tersimpan tapi player-nya sudah keluar
    for name in pairs(Config.targets) do
        if not seen[name] then
            entries[#entries+1] = {
                key = name,
                label = name .. "  (offline)",
                online = false,
            }
        end
    end

    table.sort(entries, function(a,b) return a.label:lower() < b.label:lower() end)

    for i, e in ipairs(entries) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -8, 0, 30)
        btn.LayoutOrder = i
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 12
        btn.TextTruncate = Enum.TextTruncate.AtEnd
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Text = "  " .. e.label
        local active = Config.targets[e.key]
        btn.BackgroundColor3 = active and Color3.fromRGB(0,180,130) or Color3.fromRGB(40,40,48)
        btn.TextColor3     = active and Color3.fromRGB(10,10,10) or Color3.fromRGB(220,220,230)
        btn.Parent = list
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,5)
        btn.MouseButton1Click:Connect(function()
            if Config.targets[e.key] then Config.targets[e.key] = nil
            else Config.targets[e.key] = true end
            refreshList()
        end)
    end
end

-- ===== ADD / SEARCH (DisplayName atau Username) =====
local function addByName()
    local raw = (input.Text or "")
    local txt = raw:gsub("^%s+", ""):gsub("%s+$", "")
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

    -- prioritas: exact username > exact display name > partial
    local picked = exactUser or exactDisp or partial
    -- key = username kalau ketemu, kalau tidak ada match simpan raw text (buat future join)
    local key = picked and picked.Name or txt

    if Config.targets[key] then
        Config.targets[key] = nil
    else
        Config.targets[key] = true
    end

    input.Text = ""
    refreshList()
end

toggle.MouseButton1Click:Connect(function() panel.Visible = not panel.Visible end)
addBtn.MouseButton1Click:Connect(addByName)
input.FocusLost:Connect(function(enter) if enter then addByName() end end)
clearBtn.MouseButton1Click:Connect(function()
    for k in pairs(Config.targets) do Config.targets[k] = nil end
    refreshList()
end)
Players.PlayerAdded:Connect(refreshList)
Players.PlayerRemoving:Connect(refreshList)

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
                    -- CHAMS
                    if Config.showChams then
                        local hl = char:FindFirstChild("TargetESP_Highlight")
                        if not hl then
                            hl = Instance.new("Highlight")
                            hl.Name = "TargetESP_Highlight"
                            hl.FillTransparency = 0.55
                            hl.OutlineTransparency = 0
                            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            hl.Parent = char
                        end
                        hl.Adornee     = char
                        hl.FillColor   = Config.chamsColor
                        hl.OutlineColor= Color3.fromRGB(255,255,255)
                    else
                        local hl = char:FindFirstChild("TargetESP_Highlight")
                        if hl then hl:Destroy() end
                    end

                    -- JARAK
                    local head = char:FindFirstChild("Head")
                    if head then
                        if Config.showDistance then
                            local bb = head:FindFirstChild("TargetESP_Dist")
                            if not bb then
                                bb = Instance.new("BillboardGui")
                                bb.Name = "TargetESP_Dist"
                                bb.Size = UDim2.fromOffset(90, 26)
                                bb.StudsOffset = Vector3.new(0, 2.5, 0)
                                bb.AlwaysOnTop = true
                                bb.MaxDistance = 1500
                                local lbl = Instance.new("TextLabel")
                                lbl.Name = "Label"
                                lbl.Size = UDim2.fromScale(1, 1)
                                lbl.BackgroundTransparency = 1
                                lbl.Font = Enum.Font.GothamBold
                                lbl.TextSize = Config.textSize
                                lbl.TextColor3 = Color3.fromRGB(255,255,255)
                                lbl.TextStrokeTransparency = 0.2
                                lbl.TextStrokeColor3 = Color3.fromRGB(0,0,0)
                                lbl.Text = ""
                                lbl.Parent = bb
                                bb.Parent = head
                            end
                            local lbl = bb:FindFirstChild("Label")
                            if lbl and Camera then
                                local dist = (Camera.CFrame.Position - char.HumanoidRootPart.Position).Magnitude
                                lbl.Text = string.format("[%d m]", math.floor(dist))
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
print("[TargetESP v2] Loaded — search by DisplayName / Username.")
