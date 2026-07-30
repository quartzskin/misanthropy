-- Project Delta — Ruble Tools (Split + Trade Dupe)
-- RightAlt = toggle GUI

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

local InventoryMove = RS:WaitForChild("Remotes"):WaitForChild("InventoryMove")
local Trade = RS:WaitForChild("Remotes"):WaitForChild("Trade")
local playerData = RS:WaitForChild("Players"):WaitForChild(LP.Name)
local playerInventory = playerData:WaitForChild("Inventory")

-- ===== config =====
local CFG = {
	SplitDelay = 0.03,
	ConfirmTimeout = 0.35,
	MaxMoves = 500,
	DupeSlots = 6,
	PreferContainer = "", -- e.g. GorkaShirt / SpecopsBackpack (empty = auto)
	PreferItem = "", -- set by selecting from inventory list
	ToggleKey = Enum.KeyCode.RightAlt,
}

----------------------------------------------------------------
-- shared helpers
----------------------------------------------------------------
local function getAmount(obj)
	return tonumber(obj:GetAttribute("Amount")) or 1
end

local function nameMatch(inst, prefer)
	if type(prefer) ~= "string" or prefer == "" then
		return true
	end
	return string.find(string.lower(inst.Name), string.lower(prefer), 1, true) ~= nil
end

-- empty/nil filter = match any item
-- exact=true → ObjectValue.Name or Value.Name must equal filter
local function matchesItem(obj, filter, exact)
	if not obj then
		return false
	end
	if filter == nil or filter == "" then
		return true
	end
	if exact then
		if obj.Name == filter then
			return true
		end
		if obj:IsA("ObjectValue") and obj.Value and obj.Value.Name == filter then
			return true
		end
		return false
	end
	if nameMatch(obj, filter) then
		return true
	end
	if obj:IsA("ObjectValue") and obj.Value and nameMatch(obj.Value, filter) then
		return true
	end
	return false
end

local function slotPrefix(slot)
	if type(slot) ~= "string" then
		return nil
	end
	local p = string.gsub(slot, "%d+", "")
	return p ~= "" and p or nil
end

----------------------------------------------------------------
-- SPLIT
----------------------------------------------------------------
local CLOTHING_SLOTS = {
	"ClothingBackpack",
	"ClothingShirt",
	"ClothingPants",
	"ClothingChestRig",
}

local PREFIX_FOR_EQUIP = {
	ClothingBackpack = "Backpack",
	ClothingShirt = "Shirt",
	ClothingPants = "Pants",
	ClothingChestRig = "ChestRig",
}

local DEFAULT_CAP = {
	Backpack = 35,
	Shirt = 8,
	Pants = 6,
	ChestRig = 10,
	Material = 12,
	Container = 40,
}

local function occupiedMap(inventory)
	local occupied = {}
	for _, obj in ipairs(inventory:GetChildren()) do
		local slot = obj:GetAttribute("Slot")
		if type(slot) == "string" then
			occupied[slot] = true
		end
	end
	return occupied
end

local function getClothingInventory(equipSlotName)
	for _, obj in ipairs(playerInventory:GetChildren()) do
		if obj:GetAttribute("Slot") == equipSlotName then
			local inv = obj:FindFirstChild("Inventory")
			if inv then
				return inv
			end
		end
	end
	return nil
end

local function collectStorageInventories()
	local list, seen = {}, {}

	local function add(inv, label, defaultPrefix)
		if inv and not seen[inv] then
			seen[inv] = true
			table.insert(list, { inv = inv, label = label, prefix = defaultPrefix })
		end
	end

	for _, equip in ipairs(CLOTHING_SLOTS) do
		add(getClothingInventory(equip), equip, PREFIX_FOR_EQUIP[equip])
	end

	for _, obj in ipairs(playerInventory:GetChildren()) do
		local inv = obj:FindFirstChild("Inventory")
		if inv then
			local equipSlot = obj:GetAttribute("Slot")
			local prefix = PREFIX_FOR_EQUIP[equipSlot] or slotPrefix(equipSlot) or "Backpack"
			prefix = string.gsub(prefix, "^Clothing", "")
			if prefix == "" then
				prefix = "Backpack"
			end
			add(inv, tostring(equipSlot or obj.Name), prefix)
		end
	end

	add(playerInventory, "Root", "Material")
	return list
end

local function findBiggestStack(storageList, itemFilter, exact)
	local best, bestAmt = nil, 0
	local scanned = {}

	local function scan(inv)
		if not inv or scanned[inv] then
			return
		end
		scanned[inv] = true
		for _, obj in ipairs(inv:GetChildren()) do
			if matchesItem(obj, itemFilter, exact) and obj:GetAttribute("Slot") then
				local amt = getAmount(obj)
				if amt > bestAmt then
					bestAmt = amt
					best = obj
				end
			end
			local sub = obj:FindFirstChild("Inventory")
			if sub then
				scan(sub)
			end
		end
	end

	for _, entry in ipairs(storageList) do
		scan(entry.inv)
	end
	return best, bestAmt
end

local function capacityFor(inv, prefix)
	local cap = tonumber(inv:GetAttribute(prefix))
	if cap and cap > 0 then
		return math.floor(cap)
	end
	local maxIdx = 0
	for _, obj in ipairs(inv:GetChildren()) do
		local slot = obj:GetAttribute("Slot")
		if type(slot) == "string" and slotPrefix(slot) == prefix then
			local n = tonumber(string.match(slot, "%d+"))
			if n and n > maxIdx then
				maxIdx = n
			end
		end
	end
	local fallback = DEFAULT_CAP[prefix] or 0
	if maxIdx > 0 then
		return math.max(maxIdx, fallback)
	end
	return fallback
end

local function prefixForEntry(entry, fromInv, fromSlot)
	if entry.inv == fromInv then
		return slotPrefix(fromSlot) or entry.prefix
	end
	return entry.prefix
end

local function buildFreeQueue(fromInv, fromSlot, storageList, rejected)
	local queue = {}
	rejected = rejected or {}

	local function addFrom(entry)
		local prefix = prefixForEntry(entry, fromInv, fromSlot)
		if not prefix then
			return
		end
		local cap = capacityFor(entry.inv, prefix)
		if cap <= 0 then
			return
		end
		local occupied = occupiedMap(entry.inv)
		for i = 1, cap do
			local name = prefix .. i
			local key = tostring(entry.inv) .. ":" .. name
			if not occupied[name]
				and not rejected[key]
				and not (entry.inv == fromInv and name == fromSlot)
			then
				table.insert(queue, { inv = entry.inv, slot = name, key = key })
			end
		end
	end

	for _, entry in ipairs(storageList) do
		if entry.inv == fromInv then
			addFrom(entry)
		end
	end
	for _, entry in ipairs(storageList) do
		if entry.inv ~= fromInv and entry.label ~= "Root" then
			addFrom(entry)
		end
	end
	return queue
end

local function waitAmountDrop(stack, prevAmount)
	if not stack or not stack.Parent then
		return true
	end
	if getAmount(stack) < prevAmount then
		return true
	end

	local done = false
	local conn = stack:GetAttributeChangedSignal("Amount"):Connect(function()
		if getAmount(stack) < prevAmount then
			done = true
		end
	end)

	local t0 = tick()
	while not done and stack.Parent and (tick() - t0) < CFG.ConfirmTimeout do
		if getAmount(stack) < prevAmount then
			done = true
			break
		end
		task.wait()
	end

	conn:Disconnect()
	return done
end

----------------------------------------------------------------
-- DUPE (trade Update + Confirm)
----------------------------------------------------------------
local function isContainerLike(inst)
	if not inst or inst.Name == "Inventory" then
		return false
	end
	return inst:FindFirstChild("Inventory") ~= nil
end

local function collectContainers(rootInv)
	local list, seen = {}, {}
	local function add(inst)
		if inst and isContainerLike(inst) and not seen[inst] then
			seen[inst] = true
			table.insert(list, inst)
		end
	end
	for _, child in ipairs(rootInv:GetChildren()) do
		add(child)
		local nested = child:FindFirstChild("Inventory")
		if nested then
			for _, inner in ipairs(nested:GetChildren()) do
				add(inner)
			end
		end
	end
	return list
end

local function collectStoredItems(container)
	local nested = container:FindFirstChild("Inventory")
	local items = {}
	if not nested then
		return items
	end
	for _, child in ipairs(nested:GetChildren()) do
		if child.Name ~= "Inventory" and child.Name ~= "ItemProperties" and child.Name ~= "Attachments" then
			table.insert(items, child)
		end
	end
	return items
end

-- Selected inventory item for split/dupe (exact name)
local selectedItemName = nil
local selectedExact = true

local function pickDupeItem(itemFilterOverride, exact)
	local preferContainer = CFG.PreferContainer
	local preferItem = itemFilterOverride
	if preferItem == nil then
		preferItem = CFG.PreferItem
	end
	if exact == nil then
		exact = selectedExact and preferItem ~= nil and preferItem ~= ""
	end

	local containers = collectContainers(playerInventory)
	if #containers == 0 then
		return nil, "No bag/shirt storage found"
	end

	local best, bestContainer, bestAmt = nil, nil, -1

	local function scan(respectBagFilter)
		for _, container in ipairs(containers) do
			if respectBagFilter and preferContainer ~= "" and not nameMatch(container, preferContainer) then
				-- skip
			else
				for _, it in ipairs(collectStoredItems(container)) do
					if matchesItem(it, preferItem, exact) then
						local amt = getAmount(it)
						if amt > bestAmt then
							bestAmt = amt
							best = it
							bestContainer = container
						end
					end
				end
			end
		end
	end

	scan(true)
	if not best and preferContainer ~= "" then
		scan(false)
	end

	if not best then
		local label = (preferItem ~= "" and preferItem) or "item"
		return nil, "No " .. label .. " in bag/shirt storage"
	end
	return best, nil, bestContainer, bestAmt
end

----------------------------------------------------------------
-- GUI
----------------------------------------------------------------
pcall(function()
	for _, name in ipairs({ "RubleToolsGui", "SplitRublesGui" }) do
		local old = LP.PlayerGui:FindFirstChild(name)
		if old then
			old:Destroy()
		end
		if gethui then
			local h = gethui():FindFirstChild(name)
			if h then
				h:Destroy()
			end
		end
	end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "RubleToolsGui"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function()
	gui.Parent = gethui and gethui() or LP:WaitForChild("PlayerGui")
end)
if not gui.Parent then
	gui.Parent = LP:WaitForChild("PlayerGui")
end

local function corner(parent, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r or 6)
	c.Parent = parent
	return c
end

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(320, 0)
main.AutomaticSize = Enum.AutomaticSize.Y
main.Position = UDim2.new(0, 24, 0.25, 0)
main.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
main.BorderSizePixel = 0
main.Active = true
main.Parent = gui
corner(main, 10)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(60, 60, 68)
stroke.Thickness = 1
stroke.Parent = main

local pad = Instance.new("UIPadding")
pad.PaddingTop = UDim.new(0, 10)
pad.PaddingBottom = UDim.new(0, 10)
pad.PaddingLeft = UDim.new(0, 12)
pad.PaddingRight = UDim.new(0, 12)
pad.Parent = main

local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 8)
layout.Parent = main

local function mkLabel(text, order, size, bold)
	local l = Instance.new("TextLabel")
	l.BackgroundTransparency = 1
	l.Size = UDim2.new(1, 0, 0, size or 18)
	l.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
	l.TextSize = bold and 15 or 12
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.TextColor3 = bold and Color3.fromRGB(235, 235, 240) or Color3.fromRGB(160, 160, 170)
	l.Text = text
	l.LayoutOrder = order
	l.Parent = main
	return l
end

local function mkButton(text, order, color)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, 0, 0, 32)
	b.BackgroundColor3 = color
	b.BorderSizePixel = 0
	b.Font = Enum.Font.GothamBold
	b.TextSize = 13
	b.TextColor3 = Color3.new(1, 1, 1)
	b.Text = text
	b.AutoButtonColor = true
	b.LayoutOrder = order
	b.Parent = main
	corner(b, 6)
	return b
end

local function mkRow(order)
	local row = Instance.new("Frame")
	row.BackgroundTransparency = 1
	row.Size = UDim2.new(1, 0, 0, 28)
	row.LayoutOrder = order
	row.Parent = main
	local lay = Instance.new("UIListLayout")
	lay.FillDirection = Enum.FillDirection.Horizontal
	lay.Padding = UDim.new(0, 6)
	lay.VerticalAlignment = Enum.VerticalAlignment.Center
	lay.Parent = row
	return row
end

local function mkField(parent, placeholder, widthScale)
	local box = Instance.new("TextBox")
	box.Size = UDim2.new(widthScale or 1, 0, 1, 0)
	box.BackgroundColor3 = Color3.fromRGB(32, 32, 36)
	box.BorderSizePixel = 0
	box.ClearTextOnFocus = false
	box.Font = Enum.Font.Gotham
	box.TextSize = 12
	box.TextColor3 = Color3.fromRGB(230, 230, 230)
	box.PlaceholderColor3 = Color3.fromRGB(110, 110, 120)
	box.PlaceholderText = placeholder
	box.Text = ""
	box.Parent = parent
	corner(box, 5)
	return box
end

local title = mkLabel("Ruble Tools", 1, 20, true)
mkLabel("RightAlt to hide  ·  drag to move", 2, 14, false)

local status = mkLabel("Ready", 3, 32, false)
status.TextWrapped = true
status.TextColor3 = Color3.fromRGB(200, 200, 210)

local function setStatus(t)
	status.Text = t
	print("[RubleTools]", t)
end

local allActionBtns = {}

-- Selected item (exact inventory name) — state lives above pickDupeItem

local function displayItemName(obj)
	if obj:IsA("ObjectValue") and obj.Value then
		return obj.Value.Name
	end
	return obj.Name
end

local function isStackableLive(obj)
	if not obj or not obj:GetAttribute("Slot") then
		return false
	end
	return obj:GetAttribute("Amount") ~= nil
end

-- Aggregate stackable stacks by item name
local function scanInventoryStacks()
	local byName = {} -- name -> { name, total, biggest, stacks }
	local scanned = {}

	local function consider(obj)
		if not isStackableLive(obj) then
			return
		end
		local amt = getAmount(obj)
		if amt < 1 then
			return
		end
		local name = displayItemName(obj)
		local entry = byName[name]
		if not entry then
			entry = { name = name, total = 0, biggest = 0, stacks = 0 }
			byName[name] = entry
		end
		entry.total = entry.total + amt
		entry.stacks = entry.stacks + 1
		if amt > entry.biggest then
			entry.biggest = amt
		end
	end

	local function scan(inv)
		if not inv or scanned[inv] then
			return
		end
		scanned[inv] = true
		for _, obj in ipairs(inv:GetChildren()) do
			consider(obj)
			local sub = obj:FindFirstChild("Inventory")
			if sub then
				scan(sub)
			end
		end
	end

	for _, entry in ipairs(collectStorageInventories()) do
		scan(entry.inv)
	end

	local list = {}
	for _, entry in pairs(byName) do
		table.insert(list, entry)
	end
	table.sort(list, function(a, b)
		if a.biggest ~= b.biggest then
			return a.biggest > b.biggest
		end
		return a.name < b.name
	end)
	return list
end

local nextOrder = 4
mkLabel("INVENTORY (select item)", nextOrder, 16, true)
nextOrder = nextOrder + 1

local selectedLbl = mkLabel("Selected: (none)", nextOrder, 16, false)
selectedLbl.TextColor3 = Color3.fromRGB(220, 190, 120)
nextOrder = nextOrder + 1

local listFrame = Instance.new("ScrollingFrame")
listFrame.Name = "ItemList"
listFrame.Size = UDim2.new(1, 0, 0, 160)
listFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
listFrame.BorderSizePixel = 0
listFrame.ScrollBarThickness = 4
listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
listFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
listFrame.LayoutOrder = nextOrder
listFrame.Parent = main
corner(listFrame, 6)
nextOrder = nextOrder + 1

local listPad = Instance.new("UIPadding")
listPad.PaddingTop = UDim.new(0, 4)
listPad.PaddingBottom = UDim.new(0, 4)
listPad.PaddingLeft = UDim.new(0, 4)
listPad.PaddingRight = UDim.new(0, 4)
listPad.Parent = listFrame

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 3)
listLayout.Parent = listFrame

local itemRowBtns = {} -- for busy lock

local function setSelected(name)
	selectedItemName = name
	if name then
		selectedLbl.Text = "Selected: " .. name
		CFG.PreferItem = name
		if itemBox then
			itemBox.Text = name
		end
	else
		selectedLbl.Text = "Selected: (none)"
	end
	for _, row in ipairs(itemRowBtns) do
		if row.name == name then
			row.btn.BackgroundColor3 = Color3.fromRGB(70, 110, 70)
		else
			row.btn.BackgroundColor3 = Color3.fromRGB(40, 40, 46)
		end
	end
end

local function refreshItemList()
	for _, child in ipairs(listFrame:GetChildren()) do
		if child:IsA("TextButton") or child:IsA("TextLabel") then
			child:Destroy()
		end
	end
	itemRowBtns = {}

	local stacks = scanInventoryStacks()
	if #stacks == 0 then
		local empty = Instance.new("TextLabel")
		empty.BackgroundTransparency = 1
		empty.Size = UDim2.new(1, 0, 0, 28)
		empty.Font = Enum.Font.Gotham
		empty.TextSize = 12
		empty.TextColor3 = Color3.fromRGB(140, 140, 150)
		empty.Text = "No stackable items found"
		empty.LayoutOrder = 1
		empty.Parent = listFrame
		if selectedItemName then
			-- keep selection even if empty momentarily
		end
		return
	end

	local stillThere = false
	for i, entry in ipairs(stacks) do
		if entry.name == selectedItemName then
			stillThere = true
		end
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, 0, 0, 26)
		btn.BackgroundColor3 = (entry.name == selectedItemName)
			and Color3.fromRGB(70, 110, 70)
			or Color3.fromRGB(40, 40, 46)
		btn.BorderSizePixel = 0
		btn.Font = Enum.Font.Gotham
		btn.TextSize = 12
		btn.TextColor3 = Color3.fromRGB(230, 230, 235)
		btn.TextXAlignment = Enum.TextXAlignment.Left
		btn.Text = string.format("  %s   ·  x%d  (%d stack%s)",
			entry.name,
			entry.biggest,
			entry.stacks,
			entry.stacks == 1 and "" or "s"
		)
		btn.AutoButtonColor = true
		btn.LayoutOrder = i
		btn.Parent = listFrame
		corner(btn, 4)

		local name = entry.name
		btn.MouseButton1Click:Connect(function()
			setSelected(name)
			setStatus("Selected " .. name)
		end)
		table.insert(itemRowBtns, { btn = btn, name = name })
	end

	if selectedItemName and not stillThere then
		-- keep name so split/dupe can still try; highlight clears
	elseif not selectedItemName and #stacks > 0 then
		-- don't auto-select; user picks
	end
end

local rowActions = mkRow(nextOrder)
rowActions.Size = UDim2.new(1, 0, 0, 30)
nextOrder = nextOrder + 1

local refreshBtn = Instance.new("TextButton")
refreshBtn.Size = UDim2.new(0.32, -2, 1, 0)
refreshBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 62)
refreshBtn.BorderSizePixel = 0
refreshBtn.Font = Enum.Font.GothamBold
refreshBtn.TextSize = 11
refreshBtn.TextColor3 = Color3.new(1, 1, 1)
refreshBtn.Text = "REFRESH"
refreshBtn.Parent = rowActions
corner(refreshBtn, 6)

local splitBtn = Instance.new("TextButton")
splitBtn.Size = UDim2.new(0.68, -2, 1, 0)
splitBtn.BackgroundColor3 = Color3.fromRGB(150, 45, 45)
splitBtn.BorderSizePixel = 0
splitBtn.Font = Enum.Font.GothamBold
splitBtn.TextSize = 12
splitBtn.TextColor3 = Color3.new(1, 1, 1)
splitBtn.Text = "SPLIT SELECTED → 1s"
splitBtn.Parent = rowActions
corner(splitBtn, 6)

table.insert(allActionBtns, refreshBtn)
table.insert(allActionBtns, splitBtn)

-- Dupe section
mkLabel("TRADE DUPE", nextOrder, 16, true)
nextOrder = nextOrder + 1

local row1 = mkRow(nextOrder)
nextOrder = nextOrder + 1
local slotsBox = mkField(row1, "Slots (6)", 0.32)
slotsBox.Text = tostring(CFG.DupeSlots)
local itemBox = mkField(row1, "Item (or select above)", 0.68)
itemBox.Text = CFG.PreferItem

local row2 = mkRow(nextOrder)
nextOrder = nextOrder + 1
local bagBox = mkField(row2, "Bag/shirt filter (optional)", 1)
bagBox.Text = CFG.PreferContainer

local dupeBtn = mkButton("DUPE SELECTED / FILTER", nextOrder, Color3.fromRGB(45, 95, 150))
nextOrder = nextOrder + 1

local comboBtn = mkButton("SPLIT THEN DUPE SELECTED", nextOrder, Color3.fromRGB(90, 55, 130))

table.insert(allActionBtns, dupeBtn)
table.insert(allActionBtns, comboBtn)

refreshBtn.MouseButton1Click:Connect(function()
	refreshItemList()
	setStatus("Inventory refreshed")
end)

-- initial scan after itemBox exists
refreshItemList()

----------------------------------------------------------------
-- drag
----------------------------------------------------------------
do
	local dragging, dragStart, startPos
	title.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
		then
			dragging = true
			dragStart = input.Position
			startPos = main.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch)
		then
			local d = input.Position - dragStart
			main.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + d.X,
				startPos.Y.Scale,
				startPos.Y.Offset + d.Y
			)
		end
	end)
end

UIS.InputBegan:Connect(function(input, gpe)
	if gpe then
		return
	end
	if input.KeyCode == CFG.ToggleKey then
		main.Visible = not main.Visible
		if main.Visible then
			refreshItemList()
		end
	end
end)

----------------------------------------------------------------
-- actions
----------------------------------------------------------------
local busy = false

local function syncCfg()
	CFG.DupeSlots = math.clamp(tonumber(slotsBox.Text) or 6, 1, 12)
	CFG.PreferItem = itemBox.Text or ""
	CFG.PreferContainer = bagBox.Text or ""
end

local function setBusy(on)
	busy = on
	for _, b in ipairs(allActionBtns) do
		if b and b.Parent then
			b.Active = not on
			b.AutoButtonColor = not on
		end
	end
	for _, row in ipairs(itemRowBtns) do
		if row.btn and row.btn.Parent then
			row.btn.Active = not on
			row.btn.AutoButtonColor = not on
		end
	end
end

local function resolveSplitFilter(itemFilter)
	if itemFilter and itemFilter ~= "" then
		return itemFilter, true
	end
	if selectedItemName and selectedItemName ~= "" then
		return selectedItemName, true
	end
	syncCfg()
	local fromBox = CFG.PreferItem
	if fromBox and fromBox ~= "" then
		-- typed filter = substring match
		return fromBox, false
	end
	return nil, true
end

local function runSplit(itemFilter)
	local filter, exact = resolveSplitFilter(itemFilter)
	if not filter or filter == "" then
		setStatus("Select an item from the list first")
		return false
	end

	local storage = collectStorageInventories()
	local stack, amt = findBiggestStack(storage, filter, exact)
	if not stack or amt <= 1 then
		setStatus(amt and amt > 0 and (filter .. " already split") or ("No " .. filter .. " found"))
		return false
	end

	local fromSlot = stack:GetAttribute("Slot")
	local fromInv = stack.Parent
	if type(fromSlot) ~= "string" or not fromInv then
		setStatus("Stack missing Slot")
		return false
	end

	local rejected = {}
	local queue = buildFreeQueue(fromInv, fromSlot, storage, rejected)
	local qIndex = 1
	setStatus(string.format("Split %s: %d → %d empty", filter, amt, #queue))

	local moved, failed = 0, 0
	local tStart = tick()

	while moved < CFG.MaxMoves do
		if not stack.Parent then
			storage = collectStorageInventories()
			stack, amt = findBiggestStack(storage, filter, exact)
			if not stack or amt <= 1 then
				break
			end
			fromSlot = stack:GetAttribute("Slot")
			fromInv = stack.Parent
			queue = buildFreeQueue(fromInv, fromSlot, storage, rejected)
			qIndex = 1
		end

		local cur = getAmount(stack)
		if cur <= 1 then
			storage = collectStorageInventories()
			stack, amt = findBiggestStack(storage, filter, exact)
			if not stack or amt <= 1 then
				break
			end
			fromSlot = stack:GetAttribute("Slot")
			fromInv = stack.Parent
			queue = buildFreeQueue(fromInv, fromSlot, storage, rejected)
			qIndex = 1
			cur = getAmount(stack)
		end

		local dest = queue[qIndex]
		qIndex = qIndex + 1
		if not dest then
			storage = collectStorageInventories()
			queue = buildFreeQueue(fromInv, fromSlot, storage, rejected)
			qIndex = 1
			dest = queue[qIndex]
			qIndex = qIndex + 1
			if not dest then
				setStatus(string.format("No empty slots. Moves=%d", moved))
				return moved > 0
			end
		end

		local prev = cur
		local ok, err = pcall(function()
			InventoryMove:FireServer(fromSlot, dest.slot, fromInv, dest.inv, 1)
		end)

		if not ok then
			failed = failed + 1
			rejected[dest.key] = true
			if failed >= 5 then
				setStatus("FireServer failed: " .. tostring(err))
				return false
			end
		elseif waitAmountDrop(stack, prev) then
			moved = moved + 1
			failed = 0
			if moved % 5 == 0 then
				local rate = moved / math.max(tick() - tStart, 0.001)
				setStatus(string.format("Moved %d  (%.0f/s)  left~%d", moved, rate, getAmount(stack)))
			end
		else
			rejected[dest.key] = true
			failed = failed + 1
			if failed >= 20 then
				setStatus(string.format("Stuck after %d moves", moved))
				return moved > 0
			end
			task.wait(0.05)
		end

		if CFG.SplitDelay > 0 then
			task.wait(CFG.SplitDelay)
		end
	end

	setStatus(string.format("Split %s done. Moves=%d in %.1fs", filter, moved, tick() - tStart))
	refreshItemList()
	return moved > 0
end

local function runDupeItem(item, container, stackAmt)
	if not item or not item.Parent then
		setStatus("Item gone")
		return false
	end
	syncCfg()
	local slots = CFG.DupeSlots
	local tradeList = {}
	for _ = 1, slots do
		table.insert(tradeList, item)
	end

	setStatus(string.format(
		"Dupe %s (stack %d) x%d%s",
		item.Name,
		stackAmt or getAmount(item),
		slots,
		container and (" from " .. container.Name) or ""
	))

	local ok1, e1 = pcall(function()
		Trade:InvokeServer({
			Action = "Update",
			TradeList = tradeList,
		})
	end)
	if not ok1 then
		setStatus("Update failed: " .. tostring(e1))
		return false
	end

	local ok2, e2 = pcall(function()
		Trade:InvokeServer({
			Action = "Confirm",
		})
	end)
	if not ok2 then
		setStatus("Confirm failed: " .. tostring(e2))
		return false
	end

	setStatus(string.format("Dupe sent: %s x%d", item.Name, slots))
	return true
end

local function runDupe(itemFilterOverride)
	syncCfg()
	local filter = itemFilterOverride
	local exact = false
	if filter == nil or filter == "" then
		filter = selectedItemName
		exact = true
	end
	if filter == nil or filter == "" then
		filter = CFG.PreferItem
		exact = false
	end
	if not filter or filter == "" then
		setStatus("Select an item (or type a filter)")
		return false
	end
	local item, err, container, stackAmt = pickDupeItem(filter, exact)
	if not item then
		setStatus(err or "No item")
		return false
	end
	return runDupeItem(item, container, stackAmt)
end

splitBtn.MouseButton1Click:Connect(function()
	if busy then
		return
	end
	setBusy(true)
	task.spawn(function()
		runSplit(selectedItemName)
		setBusy(false)
	end)
end)

dupeBtn.MouseButton1Click:Connect(function()
	if busy then
		return
	end
	setBusy(true)
	task.spawn(function()
		runDupe(selectedItemName)
		setBusy(false)
	end)
end)

comboBtn.MouseButton1Click:Connect(function()
	if busy then
		return
	end
	local name = selectedItemName or (itemBox.Text ~= "" and itemBox.Text) or nil
	if not name or name == "" then
		setStatus("Select an item first")
		return
	end
	setBusy(true)
	task.spawn(function()
		setStatus("Split → then dupe " .. name .. "…")
		runSplit(name)
		task.wait(0.15)
		runDupe(name)
		setBusy(false)
	end)
end)

----------------------------------------------------------------
-- Right-click inventory menu: inject "Dupe" button
----------------------------------------------------------------
local contextItem = nil

local function setupContextDupe()
	local pg = LP:WaitForChild("PlayerGui", 30)
	if not pg then
		return
	end
	local mainGui = pg:WaitForChild("MainGui", 30)
	if not mainGui then
		warn("[RubleTools] MainGui missing — context Dupe not hooked")
		return
	end

	local modules = mainGui:WaitForChild("Modules", 10)
	local invMod = modules and modules:FindFirstChild("InventoryFunctions")
	if not invMod then
		warn("[RubleTools] InventoryFunctions missing")
		return
	end

	local ok, InvFuncs = pcall(require, invMod)
	if not ok or type(InvFuncs) ~= "table" or type(InvFuncs.MakeInteractionList) ~= "function" then
		warn("[RubleTools] Could not hook MakeInteractionList")
		return
	end

	local interactionFrame = mainGui:WaitForChild("MainFrame"):WaitForChild("InteractionFrame")
	local list = interactionFrame:WaitForChild("InteractionListInventory")
	local drop = list:WaitForChild("Drop")

	local dupeCtx = list:FindFirstChild("Dupe")
	if dupeCtx then
		dupeCtx:Destroy()
	end
	dupeCtx = drop:Clone()
	dupeCtx.Name = "Dupe"
	dupeCtx.LayoutOrder = 0
	dupeCtx.Visible = false
	dupeCtx.Parent = list

	-- Game puts the label on Decor (TextLabel); TextButton.Text stays empty.
	-- Writing on TextButton stacks a second font over Decor and looks wrong.
	local tb = dupeCtx:FindFirstChild("TextButton")
	if tb and tb:IsA("TextButton") then
		tb.Text = ""
	end
	local decor = dupeCtx:FindFirstChild("Decor")
	if decor and decor:IsA("TextLabel") then
		decor.Text = "Dupe"
		-- Match Inspect/Drop sizing; avoid bold/condensed fallback looking harsh
		pcall(function()
			decor.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.SemiBold)
		end)
		decor.TextSize = 14
	else
		for _, d in ipairs(dupeCtx:GetDescendants()) do
			if d:IsA("TextLabel") and (d.Text == "Drop" or d.Name == "Decor") then
				d.Text = "Dupe"
			end
		end
	end

	local connected = false
	local function bindClick()
		if connected then
			return
		end
		local btn = dupeCtx:FindFirstChild("TextButton")
		if not btn then
			return
		end
		connected = true
		btn.MouseButton1Down:Connect(function()
			list.Visible = false
			local item = contextItem
			if not item or not item.Parent then
				setStatus("No item selected")
				return
			end
			if busy then
				return
			end
			setBusy(true)
			task.spawn(function()
				runDupeItem(item, item.Parent and item.Parent.Parent, getAmount(item))
				setBusy(false)
			end)
		end)
	end
	bindClick()

	local oldMake = InvFuncs.MakeInteractionList
	InvFuncs.MakeInteractionList = function(self, item, ...)
		-- Called as InventoryFunctions:MakeInteractionList(item)
		contextItem = item
		local results = table.pack(oldMake(self, item, ...))
		if dupeCtx and dupeCtx.Parent then
			dupeCtx.Visible = true
			dupeCtx.Size = UDim2.fromScale(1, 0.1)
			bindClick()
		end
		return table.unpack(results, 1, results.n)
	end

	print("[RubleTools] Right-click Dupe button hooked")
end

task.spawn(setupContextDupe)

setStatus("Ready — pick item from list · split / trade-dupe")
print("[RubleTools] Loaded. RightAlt toggles GUI.")
