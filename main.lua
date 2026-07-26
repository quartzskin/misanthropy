--!strict


----------------------------------------------------------------------------------
-- EMBEDDED: chudvision UI library (vendored from chudvision.lua, by samet)
-- Everything below through the matching banner is chudvision's library code,
-- verbatim except its own demo Window/Page/Section calls are excluded --
-- misanthropy builds its own Window/Pages below instead.
----------------------------------------------------------------------------------
--[[
    Chudvision
    Made by samet

    Example is at bottom
    Assign different flags to each element to prevent configs from overlapping

    Documentation:

    function Library:Window(Data: table
        Name/name: string
    )

    function Library:ModuleList(void)
    function Library:Indicator(void)

    function Indicator:Add(Name: string, Icon: string)
    function Indicator:ClearAllItems(void)

    function Window:Page(Data: table
        Name/name: string,
        Columns/columns: number
    )

    function Page:Section(Data: table
        Name/name: string,
        Side/side: number
    )

    function Page:MultiSection(Data: table
        Side/side: number
    )

    function MultiSection:New(Name: string)

    function Section:Toggle(Data: table
        Name/name: string,
        Default/default: boolean,
        Flag/flag: string,
        Callback/callback: function
    )

    function Toggle:Colorpicker(Data: table
        Flag/flag: string,
        Default/default: Color3,
        Alpha/alpha: number,
        Callback/callback: function
    )

    function Toggle:Keybind(Data: table
        Name/name: string,
        Flag/flag: string,
        Default/default: Enum.KeyCode,
        Mode/mode: string,
        Callback/callback: function
    )

    function Section:Slider(Data: table
        Name/name: string,
        Flag/flag: string,
        Min/min: number,
        Max/max: number,
        Suffix/suffix: string,
        Default/default: number,
        Decimals/decimals: number,
        Callback/callback: function
    )

    function Section:Dropdown(Data: table
        Name/name: string,
        Flag/flag: string,
        Default/default: string,
        Multi/multi: boolean,
        Items/items: table,
        Callback/callback: function
    )

    function Section:Textbox(Data: table
        Flag/flag: string,
        Default/default: string,
        Placeholder/placeholder: string,
        Numeric/numeric: boolean,
        Finished/finished: boolean,
        Callback/callback: function
    )
    
    function Section:Label(Name: string)

    function Label:Colorpicker(Data: table
        Flag/flag: string,
        Default/default: Color3,
        Alpha/alpha: number,
        Callback/callback: function
    )

    function Label:Keybind(Data: table
        Name/name: string,
        Flag/flag: string,
        Default/default: Enum.KeyCode,
        Mode/mode: string,
        Callback/callback: function
    )

    function Section:Listbox(Data: table
        Flag/flag: string,
        Size/size: number,
        Default/default: string,
        Multi/multi: boolean,
        Items/items: table,
        Callback/callback: function
    )
]]

-- NOTE: nhack already publishes its own API as a global called `Library`.
-- chudvision (upstream) claims that exact same global name for itself, which
-- would clobber nhack's handle to itself the moment this loads, and worse,
-- would call :Unload() on whatever `Library` already means at this point
-- (i.e. nhack's, since nhack loads first) - that's what was tearing down the
-- entire nhack UI. This embedded copy is deliberately namespaced under
-- `getgenv().MisanthropyChudvision` instead so it never touches nhack's
-- global at all.
if getgenv().MisanthropyChudvision then
    getgenv().MisanthropyChudvision:Unload()
end

local Library do
    local Workspace = game:GetService("Workspace")
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local HttpService = game:GetService("HttpService")
    local RunService = game:GetService("RunService")
    local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
    local TweenService = game:GetService("TweenService")
    local Lighting = game:GetService("Lighting")

    gethui = gethui or function()
        return CoreGui
    end

    local LocalPlayer = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera
    local Mouse = LocalPlayer:GetMouse()

    local FromRGB = Color3.fromRGB
    local FromHSV = Color3.fromHSV
    local FromHex = Color3.fromHex

    local RGBSequence = ColorSequence.new
    local RGBSequenceKeypoint = ColorSequenceKeypoint.new
    local NumSequence = NumberSequence.new
    local NumSequenceKeypoint = NumberSequenceKeypoint.new

    local UDim2New = UDim2.new
    local UDimNew = UDim.new
    local Vector2New = Vector2.new
    local Vector3New = Vector3.new

    local MathClamp = math.clamp
    local MathFloor = math.floor
    local MathAbs = math.abs
    local MathSin = math.sin

    local TableInsert = table.insert
    local TableFind = table.find
    local TableRemove = table.remove
    local TableConcat = table.concat
    local TableClone = table.clone
    local TableUnpack = table.unpack

    local StringFormat = string.format
    local StringFind = string.find
    local StringGSub = string.gsub
    local StringLower = string.lower
    local StringLen = string.len

    local InstanceNew = Instance.new

    local RectNew = Rect.new

    Library = {
        Theme =  { },

        MenuKeybind = tostring(Enum.KeyCode.RightControl), 

        Flags = { },

        Tween = {
            Time = 0.15,
            Style = Enum.EasingStyle.Sine,
            Direction = Enum.EasingDirection.Out
        },

        FadeSpeed = 0.2,

        Folders = {
            Directory = "Chudding",
            Configs = "Chudding/Configs",
            Assets = "Chudding/Assets",
        },

        -- Ignore below
        Pages = { },
        Sections = { },

        Connections = { },
        Threads = { },

        ThemeMap = { },
        ThemeItems = { },

        OpenFrames = { },

        SetFlags = { },

        UnnamedConnections = 0,
        UnnamedFlags = 0,

        Holder = nil,
        NotifHolder = nil,
        UnusedHolder = nil,
        RealModuleList = nil,

        Font = nil,
        BoldFont = nil,
        SmallFont = nil
    }

    Library.__index = Library
    Library.Sections.__index = Library.Sections
    Library.Pages.__index = Library.Pages

    local Keys = {
        ["Unknown"]           = "Unknown",
        ["Backspace"]         = "Back",
        ["Tab"]               = "Tab",
        ["Clear"]             = "Clear",
        ["Return"]            = "Return",
        ["Pause"]             = "Pause",
        ["Escape"]            = "Escape",
        ["Space"]             = "Space",
        ["QuotedDouble"]      = '"',
        ["Hash"]              = "#",
        ["Dollar"]            = "$",
        ["Percent"]           = "%",
        ["Ampersand"]         = "&",
        ["Quote"]             = "'",
        ["LeftParenthesis"]   = "(",
        ["RightParenthesis"]  = " )",
        ["Asterisk"]          = "*",
        ["Plus"]              = "+",
        ["Comma"]             = ",",
        ["Minus"]             = "-",
        ["Period"]            = ".",
        ["Slash"]             = "`",
        ["Three"]             = "3",
        ["Seven"]             = "7",
        ["Eight"]             = "8",
        ["Colon"]             = ":",
        ["Semicolon"]         = ";",
        ["LessThan"]          = "<",
        ["GreaterThan"]       = ">",
        ["Question"]          = "?",
        ["Equals"]            = "=",
        ["At"]                = "@",
        ["LeftBracket"]       = "LeftBracket",
        ["RightBracket"]      = "RightBracked",
        ["BackSlash"]         = "BackSlash",
        ["Caret"]             = "^",
        ["Underscore"]        = "_",
        ["Backquote"]         = "`",
        ["LeftCurly"]         = "{",
        ["Pipe"]              = "|",
        ["RightCurly"]        = "}",
        ["Tilde"]             = "~",
        ["Delete"]            = "Del",
        ["End"]               = "End",
        ["KeypadZero"]        = "Keypad0",
        ["KeypadOne"]         = "Keypad1",
        ["KeypadTwo"]         = "Keypad2",
        ["KeypadThree"]       = "Keypad3",
        ["KeypadFour"]        = "Keypad4",
        ["KeypadFive"]        = "Keypad5",
        ["KeypadSix"]         = "Keypad6",
        ["KeypadSeven"]       = "Keypad7",
        ["KeypadEight"]       = "Keypad8",
        ["KeypadNine"]        = "Keypad9",
        ["KeypadPeriod"]      = "KeypadP",
        ["KeypadDivide"]      = "KeypadD",
        ["KeypadMultiply"]    = "KeypadM",
        ["KeypadMinus"]       = "KeypadM",
        ["KeypadPlus"]        = "KeypadP",
        ["KeypadEnter"]       = "KeypadE",
        ["KeypadEquals"]      = "KeypadE",
        ["Insert"]            = "Insert",
        ["Home"]              = "Home",
        ["PageUp"]            = "PageUp",
        ["PageDown"]          = "PageDown",
        ["RightShift"]        = "RS",
        ["LeftShift"]         = "LS",
        ["RightControl"]      = "RCtrl",
        ["LeftControl"]       = "LCtrl",
        ["LeftAlt"]           = "LAlt",
        ["RightAlt"]          = "RAlt",
        ["MouseButton2"]      = "M2",
        ["MouseButton1"]      = "M1",
        ["MouseButton3"]      = "M3",
    }

    local Themes = {
        ["Preset"] = {
            ["Accent"] = FromRGB(235, 235, 235),
        }
    }

    Library.Theme = TableClone(Themes["Preset"])

    -- Folders
    for Index, Value in Library.Folders do 
        if not isfolder(Value) then
            makefolder(Value)
        end
    end

    -- Tweening
    local Tween = { } do
        Tween.__index = Tween

        Tween.Create = function(self, Item, Info, Goal, IsRawItem)
            Item = IsRawItem and Item or Item.Instance
            Info = Info or TweenInfo.new(Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction)

            local NewTween = {
                Tween = TweenService:Create(Item, Info, Goal),
                Info = Info,
                Goal = Goal,
                Item = Item
            }

            NewTween.Tween:Play()

            setmetatable(NewTween, Tween)

            return NewTween
        end

        Tween.GetProperty = function(self, Item)
            Item = Item or self.Item 

            if Item:IsA("Frame") then
                return { "BackgroundTransparency" }
            elseif Item:IsA("TextLabel") or Item:IsA("TextButton") then
                return { "TextTransparency", "BackgroundTransparency" }
            elseif Item:IsA("ImageLabel") or Item:IsA("ImageButton") then
                return { "BackgroundTransparency", "ImageTransparency" }
            elseif Item:IsA("ScrollingFrame") then
                return { "BackgroundTransparency", "ScrollBarImageTransparency" }
            elseif Item:IsA("TextBox") then
                return { "TextTransparency", "BackgroundTransparency" }
            elseif Item:IsA("UIStroke") then 
                return { "Transparency" }
            end
        end

        Tween.FadeItem = function(self, Item, Property, Visibility, Speed)
            local Item = Item or self.Item 

            local OldTransparency = Item[Property]
            Item[Property] = Visibility and 1 or OldTransparency

            local NewTween = Tween:Create(Item, TweenInfo.new(Speed or Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction), {
                [Property] = Visibility and OldTransparency or 1
            }, true)

            Library:Connect(NewTween.Tween.Completed, function()
                if not Visibility then 
                    task.wait()
                    Item[Property] = OldTransparency
                end
            end)

            return NewTween
        end

        Tween.Get = function(self)
            if not self.Tween then 
                return
            end

            return self.Tween, self.Info, self.Goal
        end

        Tween.Pause = function(self)
            if not self.Tween then 
                return
            end

            self.Tween:Pause()
        end

        Tween.Play = function(self)
            if not self.Tween then 
                return
            end

            self.Tween:Play()
        end

        Tween.Clean = function(self)
            if not self.Tween then 
                return
            end

            Tween:Pause()
            self = nil
        end
    end

    -- Instances
    local Instances = { } do
        Instances.__index = Instances

        Instances.Create = function(self, Class, Properties)
            local NewItem = {
                Instance = InstanceNew(Class),
                Properties = Properties,
                Class = Class
            }

            setmetatable(NewItem, Instances)

            for Property, Value in NewItem.Properties do
                NewItem.Instance[Property] = Value
            end

            return NewItem
        end

        Instances.FadeItem = function(self, Visibility, Speed)
            local Item = self.Instance

            if Visibility == true then 
                Item.Visible = true
            end

            local Descendants = Item:GetDescendants()
            TableInsert(Descendants, Item)

            local NewTween

            for Index, Value in Descendants do 
                local TransparencyProperty = Tween:GetProperty(Value)

                if not TransparencyProperty then 
                    continue
                end

                if type(TransparencyProperty) == "table" then 
                    for _, Property in TransparencyProperty do 
                        NewTween = Tween:FadeItem(Value, Property, not Visibility, Speed)
                    end
                else
                    NewTween = Tween:FadeItem(Value, TransparencyProperty, not Visibility, Speed)
                end
            end
        end

        Instances.AddToTheme = function(self, Properties)
            if not self.Instance then 
                return
            end

            Library:AddToTheme(self, Properties)
        end

        Instances.ChangeItemTheme = function(self, Properties)
            if not self.Instance then 
                return
            end

            Library:ChangeItemTheme(self, Properties)
        end

        Instances.Connect = function(self, Event, Callback, Name)
            if not self.Instance then 
                return
            end

            if not self.Instance[Event] then 
                return
            end

            return Library:Connect(self.Instance[Event], Callback, Name)
        end

        Instances.Tween = function(self, Info, Goal)
            if not self.Instance then 
                return
            end

            return Tween:Create(self, Info, Goal)
        end

        Instances.Disconnect = function(self, Name)
            if not self.Instance then 
                return
            end

            return Library:Disconnect(Name)
        end

        Instances.Clean = function(self)
            if not self.Instance then 
                return
            end

            self.Instance:Destroy()
            self = nil
        end

        Instances.MakeDraggable = function(self)
            if not self.Instance then 
                return
            end

            local Gui = self.Instance

            local Dragging = false 
            local DragStart
            local StartPosition 

            local Set = function(Input)
                local DragDelta = Input.Position - DragStart
                self:Tween(TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(StartPosition.X.Scale, StartPosition.X.Offset + DragDelta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + DragDelta.Y)})
            end

            local InputChanged

            self:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true

                    DragStart = Input.Position
                    StartPosition = Gui.Position

                    if InputChanged then 
                        return
                    end

                    InputChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Dragging = false

                            InputChanged:Disconnect()
                            InputChanged = nil
                        end
                    end)
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Dragging then
                        Set(Input)
                    end
                end
            end)

            return Dragging
        end

        Instances.MakeResizeable = function(self, Minimum, Maximum)
            if not self.Instance then 
                return
            end

            local Gui = self.Instance

            local Resizing = false 
            local Start = UDim2New()
            local Delta = UDim2New()
            local ResizeMax = Gui.Parent.AbsoluteSize - Gui.AbsoluteSize

            local ResizeButton = Instances:Create("ImageButton", {
				Parent = Gui,
                Image = "rbxassetid://",
				AnchorPoint = Vector2New(1, 1),
				BorderColor3 = FromRGB(0, 0, 0),
				Size = UDim2New(0, 8, 0, 8),
				Position = UDim2New(1, -4, 1, -4),
                Name = "\0",
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
                ZIndex = 5,
				AutoButtonColor = false,
                Visible = true,
			})  ResizeButton:AddToTheme({ImageColor3 = "Accent"})

            local InputChanged

            ResizeButton:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then

                    Resizing = true

                    Start = Gui.Size - UDim2New(0, Input.Position.X, 0, Input.Position.Y)

                    if InputChanged then 
                        return
                    end

                    InputChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Resizing = false

                            InputChanged:Disconnect()
                            InputChanged = nil
                        end
                    end)
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Resizing then
                        ResizeMax = Maximum or Gui.Parent.AbsoluteSize - Gui.AbsoluteSize

                        Delta = Start + UDim2New(0, Input.Position.X, 0, Input.Position.Y)
                        Delta = UDim2New(0, math.clamp(Delta.X.Offset, Minimum.X, ResizeMax.X), 0, math.clamp(Delta.Y.Offset, Minimum.Y, ResizeMax.Y))

                        Tween:Create(Gui, TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = Delta}, true)
                    end
                end
            end)

            return Resizing
        end

        Instances.OnHover = function(self, Function)
            if not self.Instance then 
                return
            end
            
            return Library:Connect(self.Instance.MouseEnter, Function)
        end

        Instances.OnHoverLeave = function(self, Function)
            if not self.Instance then 
                return
            end
            
            return Library:Connect(self.Instance.MouseLeave, Function)
        end
    end

    -- Custom font
    local CustomFont = { } do
        function CustomFont:New(Name, Weight, Style, Data)
            if isfile(Library.Folders.Assets .. "/" .. Name .. ".json") then
                return Font.new(getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".json"))
            end

            if not isfile(Library.Folders.Assets .. "/" .. Name .. ".ttf") then 
                writefile(Library.Folders.Assets .. "/" .. Name .. ".ttf", game:HttpGet(Data.Url))
            end

            local FontData = {
                name = Name,
                faces = { {
                    name = "Regular",
                    weight = Weight,
                    style = Style,
                    assetId = getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".ttf")
                } }
            }

            writefile(Library.Folders.Assets .. "/" .. Name .. ".json", HttpService:JSONEncode(FontData))
            return Font.new(getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".json"))
        end

        function CustomFont:Get(Name)
            if isfile(Library.Folders.Assets .. "/" .. Name .. ".json") then
                return Font.new(getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".json"))
            end
        end

        CustomFont:New("TahomaXP", 400, "Regular", {
            Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/windows-xp-tahoma.ttf"
        })

        CustomFont:New("TahomaBold", 400, "Regular", {
            Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/TAHOMA-8PT-BOLD-WINDOWS-XP.TTF"
        })

        CustomFont:New("SmallestPixel", 400, "Regular", {
            Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/smallest_pixel-7.ttf"
        })

        Library.Font = CustomFont:Get("TahomaXP")
        Library.BoldFont = CustomFont:Get("TahomaBold")
        Library.SmallFont = CustomFont:Get("SmallestPixel")
    end

    Library.Holder = Instances:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        DisplayOrder = 2,
        ResetOnSpawn = false
    })

    Library.UnusedHolder = Instances:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        Enabled = false,
        ResetOnSpawn = false
    })

    Library.Unload = function(self)
        for Index, Value in self.Connections do 
            Value.Connection:Disconnect()
        end

        for Index, Value in self.Threads do 
            coroutine.close(Value)
        end

        if self.Holder then 
            self.Holder:Clean()
        end

        Library = nil
        getgenv().MisanthropyChudvision = nil
    end

    Library.GetImage = function(self, Image)
        local ImageData = self.Images[Image]

        if not ImageData then 
            return
        end

        return getcustomasset(self.Folders.Assets .. "/" .. ImageData[1])
    end

    Library.Round = function(self, Number, Float)
        -- upstream bug: `Float or 1` treats 0 as truthy (Lua/Luau only
        -- falls through on nil/false), so Decimals = 0 - the default for
        -- every Slider that doesn't pass Decimals explicitly - produced
        -- Multiplier = 1/0 = inf and Value = inf/inf = NaN on every slider.
        local SafeFloat = (Float and Float ~= 0) and Float or 1
        local Multiplier = 1 / SafeFloat
        return MathFloor(Number * Multiplier) / Multiplier
    end

    Library.Thread = function(self, Function)
        local NewThread = coroutine.create(Function)
        
        coroutine.wrap(function()
            coroutine.resume(NewThread)
        end)()

        TableInsert(self.Threads, NewThread)
        return NewThread
    end
    
    Library.SafeCall = function(self, Function, ...)
        local Arguements = { ... }
        local Success, Result = pcall(Function, TableUnpack(Arguements))

        if not Success then
            warn(Result)
            return false
        end

        return Success
    end

    Library.Connect = function(self, Event, Callback, Name)
        Name = Name or StringFormat("connection_number_%s_%s", self.UnnamedConnections + 1, HttpService:GenerateGUID(false))

        local NewConnection = {
            Event = Event,
            Callback = Callback,
            Name = Name,
            Connection = nil
        }

        Library:Thread(function()
            NewConnection.Connection = Event:Connect(Callback)
        end)

        TableInsert(self.Connections, NewConnection)
        return NewConnection
    end

    Library.Disconnect = function(self, Name)
        for _, Connection in self.Connections do 
            if Connection.Name == Name then
                Connection.Connection:Disconnect()
                break
            end
        end
    end

    Library.NextFlag = function(self)
        local FlagNumber = self.UnnamedFlags + 1
        return StringFormat("flag_number_%s_%s", FlagNumber, HttpService:GenerateGUID(false))
    end

    Library.AddToTheme = function(self, Item, Properties)
        Item = Item.Instance or Item 

        local ThemeData = {
            Item = Item,
            Properties = Properties,
        }

        for Property, Value in ThemeData.Properties do
            if type(Value) == "string" then
                Item[Property] = self.Theme[Value]
            else
                Item[Property] = Value()
            end
        end

        TableInsert(self.ThemeItems, ThemeData)
        self.ThemeMap[Item] = ThemeData
    end

    Library.GetConfig = function(self)
        local Config = { } 

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Library.Flags do 
                if type(Value) == "table" and Value.Key then
                    Config[Index] = {Key = tostring(Value.Key), Mode = Value.Mode}
                elseif type(Value) == "table" and Value.Color then
                    Config[Index] = {Color = "#" .. Value.Color, Alpha = Value.Alpha}
                else
                    Config[Index] = Value
                end
            end
        end)

        return HttpService:JSONEncode(Config)
    end

    Library.LoadConfig = function(self, Config)
        local Decoded = HttpService:JSONDecode(Config)

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Decoded do 
                local SetFunction = Library.SetFlags[Index]

                if not SetFunction then
                    continue
                end

                if type(Value) == "table" and Value.Key then 
                    SetFunction(Value)
                elseif type(Value) == "table" and Value.Color then
                    SetFunction(Value.Color, Value.Alpha)
                else
                    SetFunction(Value)
                end
            end
        end)

        return Success, Result
    end

    Library.DeleteConfig = function(self, Config)
        if isfile(Library.Folders.Configs .. "/" .. Config) then 
            delfile(Library.Folders.Configs .. "/" .. Config)
        end
    end

    Library.RefreshConfigsList = function(self, Element)
        local CurrentList = { }
        local List = { }

        local ConfigFolderName = StringGSub(Library.Folders.Configs, Library.Folders.Directory .. "/", "")

        for Index, Value in listfiles(Library.Folders.Configs) do
            local FileName = StringGSub(Value, Library.Folders.Directory .. "\\" .. ConfigFolderName .. "\\", "")
            List[Index] = FileName
        end

        local IsNew = #List ~= CurrentList

        if not IsNew then
            for Index = 1, #List do
                if List[Index] ~= CurrentList[Index] then
                    IsNew = true
                    break
                end
            end
        else
            CurrentList = List
            Element:Refresh(CurrentList)
        end
    end

    Library.ChangeItemTheme = function(self, Item, Properties)
        Item = Item.Instance or Item

        if not self.ThemeMap[Item] then 
            return
        end

        self.ThemeMap[Item].Properties = Properties
        self.ThemeMap[Item] = self.ThemeMap[Item]
    end

    Library.ChangeTheme = function(self, Theme, Color)
        self.Theme[Theme] = Color

        for _, Item in self.ThemeItems do
            for Property, Value in Item.Properties do
                if type(Value) == "string" and Value == Theme then
                    Item.Item[Property] = Color
                elseif type(Value) == "function" then
                    Item.Item[Property] = Value()
                end
            end
        end
    end

    Library.IsMouseOverFrame = function(self, Frame)
        Frame = Frame.Instance

        local MousePosition = Vector2New(Mouse.X, Mouse.Y)

        return MousePosition.X >= Frame.AbsolutePosition.X and MousePosition.X <= Frame.AbsolutePosition.X + Frame.AbsoluteSize.X 
        and MousePosition.Y >= Frame.AbsolutePosition.Y and MousePosition.Y <= Frame.AbsolutePosition.Y + Frame.AbsoluteSize.Y
    end

    Library.Lerp = function(self, Start, Finish, Time)
        return Start + (Finish - Start) * Time
    end

    do 
        Library.CreateColorpicker = function(self, Data)
            local Colorpicker = {
                IsOpen = false,

                Hue = 0,
                Value = 0,
                Saturation = 0,

                Color = FromRGB(255, 255, 255),
                HexValue = "#ffffff",

                Alpha = 0,

                Flag = Data.Flag
            }

            local Items = { } do
                Items["ColorpickerButton"] = Instances:Create("TextButton", {
                    Parent = Data.Parent.Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BorderSizePixel = 0,
                    Size = UDim2New(0, 16, 0, 10),
                    ZIndex = 2,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(175, 238, 255)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["ColorpickerButton"].Instance,
                    Name = "\0",
                    Color = FromRGB(75, 75, 75),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })

                Items["ColorpickerWindowOutline"] = Instances:Create("Frame", {
                    Parent = Library.UnusedHolder.Instance,
                    Name = "\0",
                    Active = true,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Position = UDim2New(0, 8, 0, 8),
                    Size = UDim2New(0, 222, 0, 226),
                    ZIndex = 2,
                    Visible = false,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(75, 75, 75)
                })

                Items["StrokeHolder"] = Instances:Create("Frame", {
                    Parent = Items["ColorpickerWindowOutline"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 1, 0, 1),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -1, 1, -1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["StrokeHolder"].Instance,
                    Name = "\0",
                    LineJoinMode = Enum.LineJoinMode.Miter
                })

                Items["Inline"] = Instances:Create("Frame", {
                    Parent = Items["ColorpickerWindowOutline"].Instance,
                    Name = "\0",
                    Size = UDim2New(1, -1, 1, -1),
                    Position = UDim2New(0, 1, 0, 1),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(22, 22, 22)
                })

                Items["Palette"] = Instances:Create("TextButton", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BorderSizePixel = 0,
                    Position = UDim2New(0, 8, 0, 8),
                    Size = UDim2New(1, -42, 1, -70),
                    ZIndex = 2,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(175, 238, 255)
                })

                Items["Saturation"] = Instances:Create("Frame", {
                    Parent = Items["Palette"].Instance,
                    Name = "\0",
                    Size = UDim2New(1, 0, 1, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIGradient", {
                    Parent = Items["Saturation"].Instance,
                    Name = "\0",
                    Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(1, 0)}
                })

                Items["Value"] = Instances:Create("Frame", {
                    Parent = Items["Palette"].Instance,
                    Name = "\0",
                    Size = UDim2New(1, 0, 1, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(0, 0, 0)
                })

                Instances:Create("UIGradient", {
                    Parent = Items["Value"].Instance,
                    Name = "\0",
                    Rotation = 90,
                    Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(1, 0)}
                })

                Instances:Create("UIStroke", {
                    Parent = Items["Palette"].Instance,
                    Name = "\0",
                    Color = FromRGB(75, 75, 75),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })

                Items["PaletteDragger"] = Instances:Create("Frame", {
                    Parent = Items["Palette"].Instance,
                    Name = "\0",
                    Size = UDim2New(0, 3, 0, 3),
                    Position = UDim2New(0, 4, 0, 4),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["PaletteDragger"].Instance,
                    Name = "\0",
                    Color = FromRGB(75, 75, 75),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })

                Items["Hue"] = Instances:Create("TextButton", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2New(1, 0),
                    BorderSizePixel = 0,
                    Position = UDim2New(1, -8, 0, 8),
                    Size = UDim2New(0, 15, 1, -70),
                    ZIndex = 2,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["Hue"].Instance,
                    Name = "\0",
                    Color = FromRGB(75, 75, 75),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })

                Items["HueInline"] = Instances:Create("TextButton", {
                    Parent = Items["Hue"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BorderSizePixel = 0,
                    Size = UDim2New(1, 0, 1, 0),
                    ZIndex = 2,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIGradient", {
                    Parent = Items["HueInline"].Instance,
                    Name = "\0",
                    Rotation = 90,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 0, 0)), RGBSequenceKeypoint(0.17, FromRGB(255, 255, 0)), RGBSequenceKeypoint(0.33, FromRGB(0, 255, 0)), RGBSequenceKeypoint(0.5, FromRGB(0, 255, 255)), RGBSequenceKeypoint(0.67, FromRGB(0, 0, 255)), RGBSequenceKeypoint(0.83, FromRGB(255, 0, 255)), RGBSequenceKeypoint(1, FromRGB(255, 0, 0))}
                })

                Items["HueDragger"] = Instances:Create("Frame", {
                    Parent = Items["Hue"].Instance,
                    Name = "\0",
                    Size = UDim2New(1, 0, 0, 1),
                    Position = UDim2New(0, 0, 0, 80),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["HueDragger"].Instance,
                    Name = "\0",
                    Color = FromRGB(75, 75, 75),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })

                Items["Alpha"] = Instances:Create("TextButton", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2New(0, 1),
                    BorderSizePixel = 0,
                    Position = UDim2New(0, 8, 1, -35),
                    Size = UDim2New(1, -16, 0, 15),
                    ZIndex = 2,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(175, 238, 255)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["Alpha"].Instance,
                    Name = "\0",
                    Color = FromRGB(75, 75, 75),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })

                Items["Checkers"] = Instances:Create("ImageLabel", {
                    Parent = Items["Alpha"].Instance,
                    Name = "\0",
                    ScaleType = Enum.ScaleType.Tile,
                    BorderColor3 = FromRGB(0, 0, 0),
                    TileSize = UDim2New(0, 6, 0, 6),
                    Image = "http://www.roblox.com/asset/?id=18274452449",
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 1, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIGradient", {
                    Parent = Items["Checkers"].Instance,
                    Name = "\0",
                    Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(0.37, 0.5), NumSequenceKeypoint(1, 0)}
                })

                Items["AlphaDragger"] = Instances:Create("Frame", {
                    Parent = Items["Alpha"].Instance,
                    Name = "\0",
                    Size = UDim2New(0, 1, 1, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["AlphaDragger"].Instance,
                    Name = "\0",
                    Color = FromRGB(75, 75, 75),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })

                Items["RGBInputBackground"] = Instances:Create("ImageLabel", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    ScaleType = Enum.ScaleType.Slice,
                    BorderColor3 = FromRGB(0, 0, 0),
                    BackgroundColor3 = FromRGB(255, 255, 255),
                    ResampleMode = Enum.ResamplerMode.Pixelated,
                    Size = UDim2New(1, -16, 0, 20),
                    AnchorPoint = Vector2New(0, 1),
                    Image = "rbxassetid://118318078814280",
                    Position = UDim2New(0, 8, 1, -8),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    SliceCenter = RectNew(Vector2New(2, 2), Vector2New(3, 3))
                })

                Items["Input"] = Instances:Create("TextBox", {
                    Parent = Items["RGBInputBackground"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    AnchorPoint = Vector2New(0.5, 0.5),
                    PlaceholderColor3 = FromRGB(185, 185, 185),
                    ZIndex = 2,
                    TextSize = 12,
                    Size = UDim2New(0, 0, 0, 15),
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "175, 238, 255",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    ClearTextOnFocus = false,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
            end

            function Colorpicker:Get()
                return Colorpicker.Color, Colorpicker.Alpha
            end

            local SlidingPalette = false
            local SlidingHue = false
            local SlidingAlpha = false

            local Debounce = false
            local RenderStepped  

            function Colorpicker:SetOpen(Bool)
                if Debounce then 
                    return
                end

                Colorpicker.IsOpen = Bool

                Debounce = true 

                if Colorpicker.IsOpen then 
                    Items["ColorpickerWindowOutline"].Instance.Visible = true
                    Items["ColorpickerWindowOutline"].Instance.Parent = Library.Holder.Instance
                    
                    RenderStepped = RunService.RenderStepped:Connect(function()
                        Items["ColorpickerWindowOutline"].Instance.Position = UDim2New(0, Items["ColorpickerButton"].Instance.AbsolutePosition.X, 0, Items["ColorpickerButton"].Instance.AbsolutePosition.Y + Items["ColorpickerButton"].Instance.AbsoluteSize.Y + 5)
                    end)

                    if not Data.Debounce then
                        for Index, Value in Library.OpenFrames do 
                            if Value ~= Colorpicker then 
                                Value:SetOpen(false)
                            end
                        end

                        Library.OpenFrames[Colorpicker] = Colorpicker 
                    end
                else
                    if not Data.Debounce then 
                        if Library.OpenFrames[Colorpicker] then 
                            Library.OpenFrames[Colorpicker] = nil
                        end
                    end

                    if RenderStepped then 
                        RenderStepped:Disconnect()
                        RenderStepped = nil
                    end
                end

                local Descendants = Items["ColorpickerWindowOutline"].Instance:GetDescendants()
                TableInsert(Descendants, Items["ColorpickerWindowOutline"].Instance)

                local NewTween

                for Index, Value in Descendants do 
                    local TransparencyProperty = Tween:GetProperty(Value)

                    if not TransparencyProperty then
                        continue 
                    end

                    if type(TransparencyProperty) == "table" then 
                        for _, Property in TransparencyProperty do 
                            NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                        end
                    else
                        NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                    end
                end
                
                NewTween.Tween.Completed:Connect(function()
                    Debounce = false 
                    Items["ColorpickerWindowOutline"].Instance.Visible = Colorpicker.IsOpen
                    task.wait(0.2)
                    Items["ColorpickerWindowOutline"].Instance.Parent = not Colorpicker.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
                end)
            end

            Items["ColorpickerButton"]:Connect("MouseButton1Down", function()
                Colorpicker:SetOpen(not Colorpicker.IsOpen)
            end)
            
            function Colorpicker:SlidePalette(Input)
                if not Input or not SlidingPalette then
                    return
                end

                local ValueX = MathClamp(1 - (Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 1)
                local ValueY = MathClamp(1 - (Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 1)

                Colorpicker.Saturation = ValueX
                Colorpicker.Value = ValueY

                local SlideX = MathClamp((Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 0.99)
                local SlideY = MathClamp((Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 0.99)

                Items["PaletteDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(SlideX, 0, SlideY, 0)})
                Colorpicker:Update()
            end

            function Colorpicker:SlideHue(Input)
                if not Input or not SlidingHue then
                    return
                end
                
                local ValueY = MathClamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 1)

                Colorpicker.Hue = ValueY

                local SlideY = MathClamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 0.995)

                Items["HueDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(0, 0, SlideY, 0)})
                Colorpicker:Update()
            end

            function Colorpicker:SlideAlpha(Input)
                if not Input or not SlidingAlpha then
                    return
                end

                local ValueX = MathClamp((Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X, 0, 1)

                Colorpicker.Alpha = ValueX

                local SlideX = MathClamp((Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X, 0, 0.995)

                Items["AlphaDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(SlideX, 0, 0, 0)})
                Colorpicker:Update(true)
            end

            function Colorpicker:Update(IsFromAlpha, DBC)
                local Hue, Saturation, Value = Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value
                Colorpicker.Color = FromHSV(Hue, Saturation, Value)
                Colorpicker.HexValue = Colorpicker.Color:ToHex()

                Library.Flags[Colorpicker.Flag] = {
                    Alpha = Colorpicker.Alpha,
                    Color = Colorpicker.HexValue
                }

                Items["ColorpickerButton"]:Tween(nil, {BackgroundColor3 = Colorpicker.Color})
                Items["Palette"]:Tween(nil, {BackgroundColor3 = FromHSV(Hue, 1, 1)})
                
                if not DBC then
                    local Red = MathFloor(Colorpicker.Color.R * 255)
                    local Green = MathFloor(Colorpicker.Color.G * 255)
                    local Blue = MathFloor(Colorpicker.Color.B * 255)
                    local RedGreenBlue = tostring(Red) .. ", " .. tostring(Green) .. ", " .. tostring(Blue)

                    Items["Input"].Instance.Text = RedGreenBlue
                end

                if not IsFromAlpha then 
                    Items["Alpha"]:Tween(nil, {BackgroundColor3 = Colorpicker.Color})
                end

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Colorpicker.Color, Colorpicker.Alpha)
                end
            end

            function Colorpicker:Set(Color, Alpha, DBC)
                if type(Color) == "table" then
                    Color = FromRGB(Color[1], Color[2], Color[3])
                elseif type(Color) == "string" then
                    Color = FromHex(Color)
                end 

                Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value = Color:ToHSV()
                Colorpicker.Alpha = Alpha or 0  

                local PaletteValueX = MathClamp(1 - Colorpicker.Saturation, 0, 0.99)
                local PaletteValueY = MathClamp(1 - Colorpicker.Value, 0, 0.99)

                local AlphaPositionX = MathClamp(Colorpicker.Alpha, 0, 0.995)
                    
                local HuePositionY = MathClamp(Colorpicker.Hue, 0, 0.995)

                Items["PaletteDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(PaletteValueX, 0, PaletteValueY, 0)})
                Items["HueDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(0, 0, HuePositionY, 0)})
                Items["AlphaDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(AlphaPositionX, 0, 0, 0)})
                Colorpicker:Update(false, DBC)
            end

            Items["Palette"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    SlidingPalette = true
                    Colorpicker:SlidePalette(Input)
                end
            end)
            
            Items["Palette"]:Connect("InputEnded", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    SlidingPalette = false
                end
            end)

            Items["HueInline"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    SlidingHue = true
                    Colorpicker:SlideHue(Input)
                end
            end)
            
            Items["HueInline"]:Connect("InputEnded", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    SlidingHue = false
                end
            end)

            Items["Alpha"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    SlidingAlpha = true
                    Colorpicker:SlideAlpha(Input)
                end
            end)
            
            Items["Alpha"]:Connect("InputEnded", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    SlidingAlpha = false
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement then
                    if SlidingPalette then
                        Colorpicker:SlidePalette(Input)
                    elseif SlidingHue then
                        Colorpicker:SlideHue(Input)
                    elseif SlidingAlpha then
                        Colorpicker:SlideAlpha(Input)
                    end
                end
            end)

            Library:Connect(UserInputService.InputBegan, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if not Colorpicker.IsOpen then
                        return
                    end

                    if Library:IsMouseOverFrame(Items["ColorpickerWindowOutline"]) then
                        return
                    end

                    Colorpicker:SetOpen(false)
                end
            end)

            local RGBStepped

            Items["Input"]:Connect("Focused", function()
                RGBStepped = RunService.RenderStepped:Connect(function()
                    local RgbText = Items["Input"].Instance.Text
                    local Red, Green, Blue = RgbText:match("(%d+),%s*(%d+),%s*(%d+)")
                    Red, Green, Blue = tonumber(Red), tonumber(Green), tonumber(Blue)

                    Colorpicker:Set({Red, Green, Blue, Colorpicker.Alpha}, Colorpicker.Alpha, true)
                end)
            end)

            Items["Input"]:Connect("FocusLost", function()
                if RGBStepped then 
                    RGBStepped:Disconnect()
                    RGBStepped = nil
                end
            end)

            if Data.Default then 
                Colorpicker:Set(Data.Default, Data.Alpha)
            end

            Library.SetFlags[Colorpicker.Flag] = function(Color, Alpha)
                Colorpicker:Set(Color, Alpha)
            end

            return Colorpicker, Items
        end

        Library.CreateKeybind = function(self, Data)
            local Keybind = { 
                IsOpen = false,

                Key = "",
                Value = "",

                Mode = "",

                Flag = Data.Flag,

                Toggled = false,
                Picking = false
            }

            local KeyListItem 

            if Library.RealModuleList then
                KeyListItem = Library.RealModuleList:Add(Data.Name, "None", "None")
            end

            local Items = { } do
                Items["KeyButton"] = Instances:Create("ImageButton", {
                    Parent = Data.Parent.Instance,
                    Name = "\0",
                    ScaleType = Enum.ScaleType.Slice,
                    BorderColor3 = FromRGB(0, 0, 0),
                    BackgroundColor3 = FromRGB(255, 255, 255),
                    AutoButtonColor = false,
                    Size = UDim2New(0, 28, 1, 0),
                    Image = "rbxassetid://80527488568185",
                    BackgroundTransparency = 1,
                    ResampleMode = Enum.ResamplerMode.Pixelated,
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    SliceCenter = RectNew(Vector2New(2, 2), Vector2New(3, 3))
                })

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["KeyButton"].Instance,
                    Name = "\0",
                    FontFace = Library.SmallFont,
                    TextColor3 = FromRGB(145, 145, 145),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "NONE",
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2New(0.5, 0),
                    Position = UDim2New(0.5, 0, 0, -1),
                    Size = UDim2New(0, 0, 0, 15),
                    ZIndex = 2,
                    TextSize = 9,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["KeybindWindow"] = Instances:Create("Frame", {
                    Parent = Library.UnusedHolder.Instance,
                    Name = "\0",
                    Size = UDim2New(0, 44, 0, 56),
                    Position = UDim2New(0, 244, 0, 176),
                    Visible = false,
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(75, 75, 75)
                })

                Items["StrokeHolder"] = Instances:Create("Frame", {
                    Parent = Items["KeybindWindow"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 1, 0, 1),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -1, 1, -1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["StrokeHolder"].Instance,
                    Name = "\0",
                    LineJoinMode = Enum.LineJoinMode.Miter
                })

                Items["Inline"] = Instances:Create("Frame", {
                    Parent = Items["KeybindWindow"].Instance,
                    Name = "\0",
                    Size = UDim2New(1, -1, 1, -1),
                    Position = UDim2New(0, 1, 0, 1),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(22, 22, 22)
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 3),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["Toggle"] = Instances:Create("TextButton", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(226, 94, 18),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "Toggle",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Size = UDim2New(1, 0, 0, 15),
                    ZIndex = 2,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Toggle"]:AddToTheme({TextColor3 = function()
                        return FromRGB(255, 255, 255)
                    end
                })

                Items["Hold"] = Instances:Create("TextButton", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "Hold",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Size = UDim2New(1, 0, 0, 15),
                    ZIndex = 2,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Hold"]:AddToTheme({TextColor3 = function()
                        return FromRGB(255, 255, 255)
                    end
                })

                Items["Always"] = Instances:Create("TextButton", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "Always",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Size = UDim2New(1, 0, 0, 15),
                    ZIndex = 2,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Always"]:AddToTheme({TextColor3 = function()
                        return FromRGB(255, 255, 255)
                    end
                })
            end

            local Modes = {
                ["Toggle"] = Items["Toggle"],
                ["Hold"] = Items["Hold"],
                ["Always"] = Items["Always"]
            }

            local Update = function()
                if KeyListItem then
                    KeyListItem:Set(Data.Name, Keybind.Value, Keybind.Mode)
                    KeyListItem:SetStatus(Keybind.Toggled)
                end
            end

            function Keybind:Get()
                return Keybind.Key, Keybind.Mode, Keybind.Toggled
            end

            function Keybind:Set(Key)
                if StringFind(tostring(Key), "Enum") then 
                    Keybind.Key = tostring(Key)

                    Key = Key.Name == "Backspace" and "None" or Key.Name

                    local KeyString = Keys[Keybind.Key] or StringGSub(Key, "Enum.", "") or "None"
                    local TextToDisplay = StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"

                    Keybind.Value = TextToDisplay
                    Items["Text"].Instance.Text = TextToDisplay

                    Library.Flags[Keybind.Flag] = {
                        Mode = Keybind.Mode,
                        Key = Keybind.Key,
                        Toggled = Keybind.Toggled
                    }

                    if Data.Callback then 
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end

                    Update()
                elseif type(Key) == "table" then
                    local RealKey = Key.Key == "Backspace" and "None" or Key.Key
                    Keybind.Key = tostring(Key.Key)

                    if Key.Mode then
                        Keybind.Mode = Key.Mode
                        Keybind:SetMode(Key.Mode)
                    else
                        Keybind.Mode = "Toggle"
                        Keybind:SetMode("Toggle")
                    end

                    local KeyString = Keys[Keybind.Key] or StringGSub(tostring(RealKey), "Enum.", "") or RealKey
                    local TextToDisplay = KeyString and StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"

                    TextToDisplay = StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "")

                    Keybind.Value = TextToDisplay
                    Items["Text"].Instance.Text = TextToDisplay

                    if Data.Callback then 
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end

                    Update()
                elseif TableFind({"Toggle", "Hold", "Always"}, Key) then
                    Keybind.Mode = Key
                    Keybind:SetMode(Keybind.Mode)

                    if Data.Callback then 
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end

                    Update()
                end

                Keybind.Picking = false
                Items["KeyButton"].Instance.Size = UDim2New(0, Items["Text"].Instance.TextBounds.X + 10, 1, 0)
            end

            local Debounce = false
            local RenderStepped  

            function Keybind:SetOpen(Bool)
                if Debounce then 
                    return
                end

                Keybind.IsOpen = Bool

                Debounce = true 

                if Keybind.IsOpen then 
                    Items["KeybindWindow"].Instance.Visible = true
                    Items["KeybindWindow"].Instance.Parent = Library.Holder.Instance
                    
                    RenderStepped = RunService.RenderStepped:Connect(function()
                        Items["KeybindWindow"].Instance.Position = UDim2New(0, Items["KeyButton"].Instance.AbsolutePosition.X, 0, Items["KeyButton"].Instance.AbsolutePosition.Y + Items["KeyButton"].Instance.AbsoluteSize.Y + 5)
                    end)

                    if not Debounce then 
                        for Index, Value in Library.OpenFrames do 
                            if Value ~= Keybind then 
                                Value:SetOpen(false)
                            end
                        end

                        Library.OpenFrames[Keybind] = Keybind 
                    end
                else
                    if not Debounce then 
                        if Library.OpenFrames[Keybind] then 
                            Library.OpenFrames[Keybind] = nil
                        end
                    end

                    if RenderStepped then 
                        RenderStepped:Disconnect()
                        RenderStepped = nil
                    end
                end

                local Descendants = Items["KeybindWindow"].Instance:GetDescendants()
                TableInsert(Descendants, Items["KeybindWindow"].Instance)

                local NewTween

                for Index, Value in Descendants do 
                    local TransparencyProperty = Tween:GetProperty(Value)

                    if not TransparencyProperty then
                        continue 
                    end

                    if type(TransparencyProperty) == "table" then 
                        for _, Property in TransparencyProperty do 
                            NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                        end
                    else
                        NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                    end
                end
                
                NewTween.Tween.Completed:Connect(function()
                    Debounce = false 
                    Items["KeybindWindow"].Instance.Visible = Keybind.IsOpen
                    task.wait(0.2)
                    Items["KeybindWindow"].Instance.Parent = not Keybind.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
                end)
            end

            function Keybind:SetMode(Mode)
                for Index, Value in Modes do 
                    if Index == Mode then
                        Value:ChangeItemTheme({TextColor3 = "Accent"})
                        Value:Tween(nil, {TextColor3 = Library.Theme.Accent})
                    else
                        Value:ChangeItemTheme({TextColor3 = function()
                            return FromRGB(255, 255, 255)
                        end})
                        Value:Tween(nil, {TextColor3 = FromRGB(255, 255, 255)})
                    end
                end

                Library.Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled
                }

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end

                Update()
            end

            function Keybind:Press(Bool)
                if Keybind.Mode == "Toggle" then 
                    Keybind.Toggled = not Keybind.Toggled
                elseif Keybind.Mode == "Hold" then 
                    Keybind.Toggled = Bool
                elseif Keybind.Mode == "Always" then 
                    Keybind.Toggled = true
                end

                Library.Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled
                }

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end

                Update()
            end

            Items["KeyButton"]:Connect("MouseButton1Click", function()
                Keybind.Picking = true 

                Items["Text"].Instance.Text = "."
                Library:Thread(function()
                    local Count = 1

                    while true do 
                        if not Keybind.Picking then 
                            break
                        end

                        if Count == 4 then
                            Count = 1
                        end

                        Items["KeyButton"].Instance.Text = Count == 1 and "." or Count == 2 and ".." or Count == 3 and "..."
                        Count += 1
                        task.wait(0.5)
                    end
                end)

                local InputBegan
                InputBegan = UserInputService.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.Keyboard then 
                        Keybind:Set(Input.KeyCode)
                    else
                        Keybind:Set(Input.UserInputType)
                    end

                    InputBegan:Disconnect()
                    InputBegan = nil
                end)
            end)

            Items["KeyButton"]:Connect("MouseButton2Down", function()
                Keybind:SetOpen(not Keybind.IsOpen)
            end)

            Library:Connect(UserInputService.InputBegan, function(Input)
                if Keybind.Value == "None" then
                    return
                end

                if tostring(Input.KeyCode) == Keybind.Key then
                    if Keybind.Mode == "Toggle" then 
                        Keybind:Press()
                    elseif Keybind.Mode == "Hold" then 
                        Keybind:Press(true)
                    elseif Keybind.Mode == "Always" then 
                        Keybind:Press(true)
                    end
                elseif tostring(Input.UserInputType) == Keybind.Key then
                    if Keybind.Mode == "Toggle" then 
                        Keybind:Press()
                    elseif Keybind.Mode == "Hold" then 
                        Keybind:Press(true)
                    elseif Keybind.Mode == "Always" then 
                        Keybind:Press(true)
                    end
                end

                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if not Keybind.IsOpen then
                        return
                    end

                    if Library:IsMouseOverFrame(Items["KeybindWindow"]) then
                        return
                    end

                    Keybind:SetOpen(false)
                end
            end)

            Library:Connect(UserInputService.InputEnded, function(Input)
                if Keybind.Value == "None" then
                    return
                end

                if tostring(Input.KeyCode) == Keybind.Key then
                    if Keybind.Mode == "Hold" then 
                        Keybind:Press(false)
                    elseif Keybind.Mode == "Always" then 
                        Keybind:Press(true)
                    end
                elseif tostring(Input.UserInputType) == Keybind.Key then
                    if Keybind.Mode == "Hold" then 
                        Keybind:Press(false)
                    elseif Keybind.Mode == "Always" then 
                        Keybind:Press(true)
                    end
                end
            end)

            Items["Toggle"]:Connect("MouseButton1Down", function()
                Keybind.Mode = "Toggle"
                Keybind:SetMode("Toggle")
            end)

            Items["Hold"]:Connect("MouseButton1Down", function()
                Keybind.Mode = "Hold"
                Keybind:SetMode("Hold")
            end)

            Items["Always"]:Connect("MouseButton1Down", function()
                Keybind.Mode = "Always"
                Keybind:SetMode("Always")
            end)

            if Data.Default then
                Keybind:Set({Key = Data.Default, Mode = Data.Mode or "Toggle"})
            end

            Library.SetFlags[Keybind.Flag] = function(Value)
                Keybind:Set(Value)
            end

            return Keybind, Items 
        end

        Library.ModuleList = function(self)
            local ModuleList = { }
            Library.RealModuleList = ModuleList

            local Items = { } do
                Items["ModuleList"] = Instances:Create("Frame", {
                    Parent = Library.Holder.Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(255, 255, 255),
                    AnchorPoint = Vector2New(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, 0, 0, 0),
                    Size = UDim2New(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UIListLayout", {
                    Parent = Items["ModuleList"].Instance,
                    Name = "\0",
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    Padding = UDimNew(0, 4)
                })

                Instances:Create("UIPadding", {
                    Parent = Items["ModuleList"].Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 5),
                    PaddingBottom = UDimNew(0, 5),
                    PaddingRight = UDimNew(0, 5),
                    PaddingLeft = UDimNew(0, 5)
                })
            end

            function ModuleList:Add(Name, Key, Mode)
                local NewModule = Instances:Create("TextLabel", {
                    Parent = Items["ModuleList"].Instance,
                    Name = "\0",
                    FontFace = Library.BoldFont,
                    TextColor3 = FromRGB(255, 0, 4),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Name .. " ("..Key.." "..Mode..")",
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIStroke", {
                    Parent = NewModule.Instance,
                    Name = "\0",
                    LineJoinMode = Enum.LineJoinMode.Miter
                })

                function NewModule:SetStatus(Bool)
                    NewModule:Tween(nil, {TextColor3 = Bool and FromRGB(103, 255, 8) or FromRGB(255, 0, 4)})
                end

                function NewModule:Set(Name, Key, Mode)
                    NewModule.Instance.Text = Name .. " ("..Key.." "..Mode..")"
                end

                return NewModule
            end
            
            function ModuleList:SetVisibility(Bool)
                Items["ModuleList"].Instance.Visible = Bool
            end

            return ModuleList
        end

        Library.Indicator = function(self)
            local Indicator = {
                Items = { }
            }

            local Items = { } do
                Items["IndicatorOutline"] = Instances:Create("Frame", {
                    Parent = Library.Holder.Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 139, 0, 54),
                    Position = UDim2New(0.0058670141734182835, 0, 0.33084577322006226, 0),
                    BorderSizePixel = 0,
                    ZIndex = 2,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    BackgroundColor3 = FromRGB(75, 75, 75)
                }) 

                Items["IndicatorOutline"]:MakeDraggable()

                Items["StrokeHolder"] = Instances:Create("Frame", {
                    Parent = Items["IndicatorOutline"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 1, 0, 1),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -1, 1, -1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["StrokeHolder"].Instance,
                    Name = "\0",
                    LineJoinMode = Enum.LineJoinMode.Miter
                })

                Items["Inline"] = Instances:Create("Frame", {
                    Parent = Items["IndicatorOutline"].Instance,
                    Name = "\0",
                    Size = UDim2New(1, -1, 1, -1),
                    Position = UDim2New(0, 1, 0, 1),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(22, 22, 22)
                })

                Instances:Create("UIPadding", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 8),
                    PaddingBottom = UDimNew(0, 8),
                    PaddingRight = UDimNew(0, 8),
                    PaddingLeft = UDimNew(0, 8)
                })

                Items["Title"] = Instances:Create("TextLabel", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    FontFace = Library.BoldFont,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "None",
                    AutomaticSize = Enum.AutomaticSize.X,
                    Size = UDim2New(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0, -2),
                    RichText = true,
                    ZIndex = 2,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["Title"].Instance,
                    Name = "\0",
                    Color = FromRGB(1, 1, 1),
                    LineJoinMode = Enum.LineJoinMode.Miter
                })

                Items["Content"] = Instances:Create("Frame", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    BorderSizePixel = 0,
                    Position = UDim2New(0, 0, 0, 23),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    BackgroundColor3 = FromRGB(32, 32, 32)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["Content"].Instance,
                    Name = "\0",
                    Color = FromRGB(9, 9, 9),
                    LineJoinMode = Enum.LineJoinMode.Miter
                })

                Instances:Create("UIPadding", {
                    Parent = Items["Content"].Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 8),
                    PaddingBottom = UDimNew(0, 4),
                    PaddingRight = UDimNew(0, 8),
                    PaddingLeft = UDimNew(0, 8)
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["Content"].Instance,
                    Name = "\0",
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
            end

            function Indicator:Add(Name, Icon)
                local NewItem = { }

                local NewItems = { } do
                    NewItems["Item"] = Instances:Create("Frame", {
                        Parent = Items["Content"].Instance,
                        Name = "\0",
                        BorderColor3 = FromRGB(0, 0, 0),
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        Size = UDim2New(0, 0, 0, 20),
                        ZIndex = 2,
                        AutomaticSize = Enum.AutomaticSize.X,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })

                    if Icon then
                        NewItems["Image"] = Instances:Create("ImageLabel", {
                            Parent = NewItems["Item"].Instance,
                            Name = "\0",
                            BorderColor3 = FromRGB(0, 0, 0),
                            Image = "rbxassetid://"..Icon,
                            BackgroundTransparency = 1,
                            Size = UDim2New(0, 16, 0, 16),
                            ZIndex = 2,
                            BorderSizePixel = 0,
                            BackgroundColor3 = FromRGB(255, 255, 255)
                        })
                    end

                    NewItems["Text"] = Instances:Create("TextLabel", {
                        Parent = NewItems["Item"].Instance,
                        Name = "\0",
                        FontFace = Library.Font,
                        TextColor3 = FromRGB(255, 255, 255),
                        BorderColor3 = FromRGB(0, 0, 0),
                        Text = Name,
                        AutomaticSize = Enum.AutomaticSize.X,
                        Size = UDim2New(0, 0, 0, 15),
                        BackgroundTransparency = 1,
                        Position = UDim2New(0, Icon and 24 or 0, 0, 0),
                        BorderSizePixel = 0,
                        ZIndex = 2,
                        TextSize = 12,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })
                end

                function NewItem:Remove()
                    NewItems["Item"].Instance:Destroy()
                    Indicator.Items[Name] = nil
                end 

                Indicator.Items[Name] = NewItem
                return NewItem
            end

            function Indicator:SetTitle(Text)
                Text = tostring(Text)
                Items["Title"].Instance.Text = Text
            end

            function Indicator:ClearAllItems()
                for Index, Value in Indicator.Items do
                    Value:Remove()
                end
            end

            function Indicator:SetVisibility(Bool)
                Items["IndicatorOutline"].Instance.Visible = Bool
            end

            return Indicator
        end

        Library.Window = function(self, Data)
            Data = Data or { }

            local Window = {
                Name = Data.Name or Data.name or "Window",
                
                Pages = { },
                Items = { },
                IsOpen = false
            }

            local Items = { } do
                Items["Outline"] = Instances:Create("Frame", {
                    Parent = Library.Holder.Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    Size = UDim2New(0, 600, 0, 498),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(75, 75, 75)
                })

                Items["Outline"]:MakeDraggable()
                Items["Outline"]:MakeResizeable(Vector2New(600, 498), Vector2New(9999, 9999))

                Items["StrokeHolder"] = Instances:Create("Frame", {
                    Parent = Items["Outline"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 1, 0, 1),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -1, 1, -1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["StrokeHolder"].Instance,
                    Name = "\0",
                    LineJoinMode = Enum.LineJoinMode.Miter
                })

                Items["Inline"] = Instances:Create("Frame", {
                    Parent = Items["Outline"].Instance,
                    Name = "\0",
                    Size = UDim2New(1, -1, 1, -1),
                    Position = UDim2New(0, 1, 0, 1),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(22, 22, 22)
                })

                Items["Title"] = Instances:Create("TextLabel", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    FontFace = Library.BoldFont,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Window.Name,
                    AutomaticSize = Enum.AutomaticSize.X,
                    Size = UDim2New(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 6, 0, 7),
                    RichText = true,
                    ZIndex = 2,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["Title"].Instance,
                    Name = "\0",
                    Color = FromRGB(1, 1, 1),
                    LineJoinMode = Enum.LineJoinMode.Miter
                })

                Items["PagesOutline"] = Instances:Create("Frame", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 5, 0, 35),
                    Size = UDim2New(1, -10, 0, 24),
                    ZIndex = 3,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(75, 75, 75)
                })

                Items["ContentOutline"] = Instances:Create("Frame", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    Size = UDim2New(1, -10, 1, -62),
                    Position = UDim2New(0, 5, 0, 57),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(75, 75, 75)
                })

                Items["ContentStrokeHolder"] = Instances:Create("Frame", {
                    Parent = Items["ContentOutline"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 1, 0, 1),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -1, 1, -1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["ContentStrokeHolder"].Instance,
                    Name = "\0"
                })

                Items["ContentInline"] = Instances:Create("Frame", {
                    Parent = Items["ContentOutline"].Instance,
                    Name = "\0",
                    Size = UDim2New(1, -1, 1, -1),
                    Position = UDim2New(0, 1, 0, 1),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(32, 32, 32)
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["PagesOutline"].Instance,
                    Name = "\0",
                    VerticalAlignment = Enum.VerticalAlignment.Bottom,
                    FillDirection = Enum.FillDirection.Horizontal,
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                
                Items["MainFrame"] = Items["Outline"]
                Window.Items = Items
            end
            
            local Debounce = false

            function Window:SetCenter()
                local CenterPosition = Items["MainFrame"].Instance.AbsolutePosition
                task.wait()
                Items["MainFrame"].Instance.AnchorPoint = Vector2New(0, 0)

                Items["MainFrame"].Instance.Position = UDim2New(0, CenterPosition.X, 0, CenterPosition.Y)
            end

            function Window:SetOpen(Bool)
                if Debounce then 
                    return
                end

                Window.IsOpen = Bool

                Debounce = true 

                if Window.IsOpen then 
                    Items["MainFrame"].Instance.Visible = true 
                end

                local Descendants = Items["MainFrame"].Instance:GetDescendants()
                TableInsert(Descendants, Items["MainFrame"].Instance)

                local NewTween

                for Index, Value in Descendants do 
                    local TransparencyProperty = Tween:GetProperty(Value)

                    if not TransparencyProperty then
                        continue 
                    end

                    if type(TransparencyProperty) == "table" then 
                        for _, Property in TransparencyProperty do 
                            NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                        end
                    else
                        NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                    end
                end
                
                NewTween.Tween.Completed:Connect(function()
                    Debounce = false 
                    Items["MainFrame"].Instance.Visible = Window.IsOpen
                end)
            end

            Library:Connect(UserInputService.InputBegan, function(Input)
                if tostring(Input.KeyCode) == Library.MenuKeybind or tostring(Input.UserInputType) == Library.MenuKeybind then
                    Window:SetOpen(not Window.IsOpen)
                end
            end)

            Window:SetCenter()
            task.wait()
            Window:SetOpen(true)
            return setmetatable(Window, Library)
        end

        Library.Page = function(self, Data)
            Data = Data or { }

            local Page = {
                Window = self,

                Name = Data.Name or Data.name or "Page",
                Columns = Data.Columns or Data.columns or 2,

                Items = { },
                ColumnsData = { },
                Active = false
            }

            local Items = { } do
                Items["InactiveOutline"] = Instances:Create("TextButton", {
                    Parent = Page.Window.Items["PagesOutline"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BorderSizePixel = 0,
                    Size = UDim2New(0, 34, 0, 26),
                    ClipsDescendants = true,
                    ZIndex = 2,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(75, 75, 75)
                })

                Instances:Create("UICorner", {
                    Parent = Items["InactiveOutline"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 4)
                })

                Items["Inline"] = Instances:Create("Frame", {
                    Parent = Items["InactiveOutline"].Instance,
                    Name = "\0",
                    Size = UDim2New(1, -2, 1, -1),
                    Position = UDim2New(0, 1, 0, 1),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(32, 32, 32)
                })

                Instances:Create("UICorner", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 4)
                })

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Page.Name,
                    AutomaticSize = Enum.AutomaticSize.X,
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, -2),
                    BorderSizePixel = 0,
                    ZIndex = 3,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Text"]:AddToTheme({TextColor3 = function()
                    return FromRGB(255, 255, 255)
                end})

                Items["Shadow"] = Instances:Create("TextLabel", {
                    Parent = Items["Text"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(1, 1, 1),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Page.Name,
                    AutomaticSize = Enum.AutomaticSize.X,
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 2, 0, 1),
                    BorderSizePixel = 0,
                    ZIndex = 2,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["Liner"] = Instances:Create("Frame", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 1, 0, -4),
                    Size = UDim2New(1, -2, 0, 6),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(226, 94, 18)
                })  Items["Liner"]:AddToTheme({BackgroundColor3 = "Accent"})

                Instances:Create("UICorner", {
                    Parent = Items["Liner"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 4)
                })

                Items["Lines"] = Instances:Create("Frame", {
                    Parent = Items["InactiveOutline"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(1, 0),
                    Position = UDim2New(1, 0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 3, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["Line1"] = Instances:Create("Frame", {
                    Parent = Items["Lines"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New(0, 2, 1, 0),
                    Size = UDim2New(0, 1, 1, -2),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(12, 12, 12)
                })

                Items["Line2"] = Instances:Create("Frame", {
                    Parent = Items["Lines"].Instance,
                    Name = "\0",
                    Size = UDim2New(0, 2, 0, 2),
                    Position = UDim2New(0, 1, 0, 1),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(12, 12, 12)
                })

                Items["Hide"] = Instances:Create("Frame", {
                    Parent = Items["InactiveOutline"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 1),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 1, 1, 0),
                    Size = UDim2New(1, 0, 0, 2),
                    ZIndex = 5,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(32, 32, 32)
                })

                Items["Page"] = Instances:Create("Frame", {
                    Parent = Library.UnusedHolder.Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 1, 0),
                    Visible = false,
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["Page"].Instance,
                    Name = "\0",
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    VerticalFlex = Enum.UIFlexAlignment.Fill
                })

                for Index = 1, Page.Columns do 
                    local NewColumn = Instances:Create("ScrollingFrame", {
                        Parent = Items["Page"].Instance,
                        Name = "\0",
                        ScrollBarImageColor3 = FromRGB(0, 0, 0),
                        Active = true,
                        AutomaticCanvasSize = Enum.AutomaticSize.Y,
                        ScrollBarThickness = 0,
                        BorderColor3 = FromRGB(0, 0, 0),
                        BackgroundTransparency = 1,
                        Size = UDim2New(0, 100, 0, 100),
                        BackgroundColor3 = FromRGB(255, 255, 255),
                        ZIndex = 2,
                        BorderSizePixel = 0,
                        CanvasSize = UDim2New(0, 0, 0, 0)
                    })

                    Instances:Create("UIPadding", {
                        Parent = NewColumn.Instance,
                        Name = "\0",
                        PaddingTop = UDimNew(0, 14),
                        PaddingBottom = UDimNew(0, 8),
                        PaddingRight = UDimNew(0, 8),
                        PaddingLeft = UDimNew(0, 8)
                    })

                    Instances:Create("UIListLayout", {
                        Parent = NewColumn.Instance,
                        Name = "\0",
                        Padding = UDimNew(0, 16),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    })

                    Page.ColumnsData[Index] = NewColumn
                end
                
                Page.Items = Items
            end

            Items["InactiveOutline"].Instance.Size = UDim2New(0, Items["Text"].Instance.TextBounds.X + 16, 0, 26)

            local Debounce = false

            function Page:Turn(Bool)
                if Debounce then 
                    return 
                end

                Page.Active = Bool 
                
                Debounce = true
                Items["Page"].Instance.Visible = Bool 
                Items["Page"].Instance.Parent = Bool and Page.Window.Items["ContentInline"].Instance or Library.UnusedHolder.Instance

                if Page.Active then
                    Items["Text"]:ChangeItemTheme({TextColor3 = "Accent"})

                    Items["Liner"]:Tween(nil, {BackgroundTransparency = 0})
                    Items["Hide"]:Tween(nil, {BackgroundTransparency = 0})
                    Items["Text"]:Tween(nil, {TextColor3 = Library.Theme.Accent})
                    Items["InactiveOutline"]:Tween(nil, {Size = UDim2New(0, Items["Text"].Instance.TextBounds.X + 16, 0, 28)})
                else
                    Items["Text"]:ChangeItemTheme({TextColor3 = function()
                        return FromRGB(255, 255, 255)
                    end})

                    Items["Liner"]:Tween(nil, {BackgroundTransparency = 1})
                    Items["Hide"]:Tween(nil, {BackgroundTransparency = 1})
                    Items["Text"]:Tween(nil, {TextColor3 = FromRGB(255, 255, 255)})
                    Items["InactiveOutline"]:Tween(nil, {Size = UDim2New(0, Items["Text"].Instance.TextBounds.X + 16, 0, 26)})
                end

                Debounce = false
            end

            Items["InactiveOutline"]:Connect("MouseButton1Down", function()
                for Index, Value in Page.Window.Pages do 
                    if Value == Page and Page.Active then
                        return
                    end

                    Value:Turn(Value == Page)
                end
            end)

            if #Page.Window.Pages == 0 then 
                Page:Turn(true)
            end

            TableInsert(Page.Window.Pages, Page)
            return setmetatable(Page, Library.Pages)
        end

        Library.Pages.Section = function(self, Data)
            Data = Data or { }

            local Section = {
                Window = self.Window,
                Page = self,

                Name = Data.Name or Data.name or "Section",
                Side = Data.Side or Data.side or 1,

                Items = { }
            }

            local Items = { } do
                Items["SectionOutline"] = Instances:Create("Frame", {
                    Parent = Section.Page.ColumnsData[Section.Side].Instance,
                    Name = "\0",
                    BorderSizePixel = 0,
                    Size = UDim2New(1, 0, 0, 25),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = FromRGB(75, 75, 75)
                })

                Items["StrokeHolder"] = Instances:Create("Frame", {
                    Parent = Items["SectionOutline"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 1, 0, 1),
                    Size = UDim2New(1, -3, 1, -2),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["StrokeHolder"].Instance,
                    Name = "\0",
                    LineJoinMode = Enum.LineJoinMode.Miter
                })

                Items["Inline"] = Instances:Create("Frame", {
                    Parent = Items["SectionOutline"].Instance,
                    Name = "\0",
                    Size = UDim2New(1, -4, 1, -4),
                    Position = UDim2New(0, 2, 0, 2),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(32, 32, 32)
                })

                Items["Content"] = Instances:Create("Frame", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 8, 0, 8),
                    Size = UDim2New(1, -16, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["Content"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 4),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Instances:Create("UIPadding", {
                    Parent = Items["Content"].Instance,
                    Name = "\0",
                    PaddingBottom = UDimNew(0, 8)
                })

                Items["Hide"] = Instances:Create("Frame", {
                    Parent = Items["SectionOutline"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 0, 0, 15),
                    Position = UDim2New(0, 7, 0, -11),
                    BorderSizePixel = 0,
                    ZIndex = 2,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = FromRGB(32, 32, 32)
                })

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Hide"].Instance,
                    Name = "\0",
                    FontFace = Library.BoldFont,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Section.Name,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    ZIndex = 4,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(32, 32, 32)
                })

                Instances:Create("UIPadding", {
                    Parent = Items["Text"].Instance,
                    Name = "\0",
                    PaddingRight = UDimNew(0, 3),
                    PaddingLeft = UDimNew(0, 5)
                })

                Items["Shadow"] = Instances:Create("TextLabel", {
                    Parent = Items["Hide"].Instance,
                    Name = "\0",
                    FontFace = Library.BoldFont,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Section.Name,
                    Size = UDim2New(0, 0, 0, 15),
                    AutomaticSize = Enum.AutomaticSize.X,
                    Position = UDim2New(0, 1, 0, 2),
                    BorderSizePixel = 0,
                    ZIndex = 3,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(32, 32, 32)
                })

                Instances:Create("UIPadding", {
                    Parent = Items["Shadow"].Instance,
                    Name = "\0",
                    PaddingRight = UDimNew(0, 3),
                    PaddingLeft = UDimNew(0, 5)
                })

                Section.Items = Items
            end

            return setmetatable(Section, Library.Sections)
        end

        Library.Pages.MultiSection = function(self, Data)
            local MultiSection = {
                Window = self.Window,
                Page = self,

                Side = Data.Side or Data.side or 1,
                Sections = { },

                Items = { }
            }

            local Items = { } do
                Items["MultiSection"] = Instances:Create("Frame", {
                    Parent = MultiSection.Page.ColumnsData[MultiSection.Side].Instance,
                    Name = "\0",
                    BorderSizePixel = 0,
                    Size = UDim2New(1, 0, 0, 25),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = FromRGB(32, 32, 32)
                })

                Instances:Create("UIPadding", {
                    Parent = Items["MultiSection"].Instance,
                    Name = "\0",
                    PaddingBottom = UDimNew(0, 8)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["MultiSection"].Instance,
                    Name = "\0",
                    Color = FromRGB(75, 75, 75),
                    LineJoinMode = Enum.LineJoinMode.Miter
                })

                Items["Inline"] = Instances:Create("Frame", {
                    Parent = Items["MultiSection"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 1, 0, 1),
                    Size = UDim2New(1, -1, 1, 8),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    Color = FromRGB(9, 9, 9),
                    LineJoinMode = Enum.LineJoinMode.Miter
                })

                Items["Content"] = Instances:Create("Frame", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 8, 0, 35),
                    Size = UDim2New(1, -16, 0, 0),
                    ZIndex = 2,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["Content"].Instance,
                    Name = "\0",
                    Color = FromRGB(75, 75, 75),
                    LineJoinMode = Enum.LineJoinMode.Miter
                })

                Items["ContentInline"] = Instances:Create("Frame", {
                    Parent = Items["Content"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 1, 0, 1),
                    Size = UDim2New(1, -1, 1, -1),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["ContentInline"].Instance,
                    Name = "\0",
                    Color = FromRGB(9, 9, 9),
                    LineJoinMode = Enum.LineJoinMode.Miter
                })

                Items["Sections"] = Instances:Create("Frame", {
                    Parent = Items["MultiSection"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 8, 0, 12),
                    Size = UDim2New(1, -16, 0, 25),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["Sections"].Instance,
                    Name = "\0",
                    VerticalAlignment = Enum.VerticalAlignment.Bottom,
                    FillDirection = Enum.FillDirection.Horizontal,
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
            end

            function MultiSection:New(Name)
                local NewSection = {
                    Section = self, 

                    Name = Name or "Section",
                    Items = { },
                    Active = false
                }

                local NewItems = { } do
                    NewItems["InactiveOutline"] = Instances:Create("TextButton", {
                        Parent = Items["Sections"].Instance,
                        Name = "\0",
                        FontFace = Library.Font,
                        TextColor3 = FromRGB(0, 0, 0),
                        BorderColor3 = FromRGB(0, 0, 0),
                        Text = "",
                        AutoButtonColor = false,
                        BorderSizePixel = 0,
                        Size = UDim2New(0, 34, 0, 26),
                        ClipsDescendants = true,
                        ZIndex = 2,
                        TextSize = 14,
                        BackgroundColor3 = FromRGB(75, 75, 75)
                    })

                    Instances:Create("UICorner", {
                        Parent = NewItems["InactiveOutline"].Instance,
                        Name = "\0",
                        CornerRadius = UDimNew(0, 4)
                    })

                    NewItems["Inline"] = Instances:Create("Frame", {
                        Parent = NewItems["InactiveOutline"].Instance,
                        Name = "\0",
                        Size = UDim2New(1, -2, 1, -1),
                        Position = UDim2New(0, 1, 0, 1),
                        BorderColor3 = FromRGB(0, 0, 0),
                        ZIndex = 2,
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(32, 32, 32)
                    })

                    Instances:Create("UICorner", {
                        Parent = Items["Inline"].Instance,
                        Name = "\0",
                        CornerRadius = UDimNew(0, 4)
                    })

                    NewItems["Text"] = Instances:Create("TextLabel", {
                        Parent = NewItems["Inline"].Instance,
                        Name = "\0",
                        FontFace = Library.Font,
                        TextColor3 = FromRGB(255, 255, 255),
                        BorderColor3 = FromRGB(0, 0, 0),
                        Text = NewSection.Name,
                        AutomaticSize = Enum.AutomaticSize.X,
                        AnchorPoint = Vector2New(0.5, 0.5),
                        Size = UDim2New(0, 0, 0, 15),
                        BackgroundTransparency = 1,
                        Position = UDim2New(0.5, 0, 0.5, -2),
                        BorderSizePixel = 0,
                        ZIndex = 3,
                        TextSize = 12,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })  NewItems["Text"]:AddToTheme({TextColor3 = function()
                        return FromRGB(255, 255, 255)
                    end})

                    NewItems["Shadow"] = Instances:Create("TextLabel", {
                        Parent = NewItems["Text"].Instance,
                        Name = "\0",
                        FontFace = Library.Font,
                        TextColor3 = FromRGB(1, 1, 1),
                        BorderColor3 = FromRGB(0, 0, 0),
                        Text = NewSection.Name,
                        AutomaticSize = Enum.AutomaticSize.X,
                        Size = UDim2New(0, 0, 0, 15),
                        BackgroundTransparency = 1,
                        Position = UDim2New(0, 2, 0, 1),
                        BorderSizePixel = 0,
                        ZIndex = 2,
                        TextSize = 12,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })

                    NewItems["Liner"] = Instances:Create("Frame", {
                        Parent = NewItems["Inline"].Instance,
                        Name = "\0",
                        BorderColor3 = FromRGB(0, 0, 0),
                        BackgroundTransparency = 1,
                        Position = UDim2New(0, 1, 0, -4),
                        Size = UDim2New(1, -2, 0, 6),
                        ZIndex = 2,
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(226, 94, 18)
                    })  NewItems["Liner"]:AddToTheme({BackgroundColor3 = "Accent"})

                    Instances:Create("UICorner", {
                        Parent = NewItems["Liner"].Instance,
                        Name = "\0",
                        CornerRadius = UDimNew(0, 4)
                    })

                    NewItems["Lines"] = Instances:Create("Frame", {
                        Parent = NewItems["InactiveOutline"].Instance,
                        Name = "\0",
                        AnchorPoint = Vector2New(1, 0),
                        Position = UDim2New(1, 0, 0, 0),
                        BorderColor3 = FromRGB(0, 0, 0),
                        Size = UDim2New(0, 3, 1, 0),
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })

                    NewItems["Line1"] = Instances:Create("Frame", {
                        Parent = NewItems["Lines"].Instance,
                        Name = "\0",
                        BorderColor3 = FromRGB(0, 0, 0),
                        AnchorPoint = Vector2New(0, 1),
                        Position = UDim2New(0, 2, 1, 0),
                        Size = UDim2New(0, 1, 1, -2),
                        ZIndex = 2,
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(12, 12, 12)
                    })

                    NewItems["Line2"] = Instances:Create("Frame", {
                        Parent = NewItems["Lines"].Instance,
                        Name = "\0",
                        Size = UDim2New(0, 2, 0, 2),
                        Position = UDim2New(0, 1, 0, 1),
                        BorderColor3 = FromRGB(0, 0, 0),
                        ZIndex = 2,
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(12, 12, 12)
                    })

                    NewItems["Hide"] = Instances:Create("Frame", {
                        Parent = NewItems["InactiveOutline"].Instance,
                        Name = "\0",
                        BorderColor3 = FromRGB(0, 0, 0),
                        AnchorPoint = Vector2New(0, 1),
                        BackgroundTransparency = 1,
                        Position = UDim2New(0, 1, 1, 0),
                        Size = UDim2New(1, 0, 0, 2),
                        ZIndex = 5,
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(32, 32, 32)
                    })

                    NewItems["Content"] = Instances:Create("Frame", {
                        Parent = Library.UnusedHolder.Instance,
                        Name = "\0",
                        BorderColor3 = FromRGB(0, 0, 0),
                        BackgroundTransparency = 1,
                        Visible = false,
                        BorderSizePixel = 0,
                        Size = UDim2New(1, 0, 0, 0),
                        ZIndex = 2,
                        AutomaticSize = Enum.AutomaticSize.Y,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })

                    Instances:Create("UIPadding", {
                        Parent = NewItems["Content"].Instance,
                        Name = "\0",
                        PaddingBottom = UDimNew(0, 8),
                        PaddingRight = UDimNew(0, 8),
                        PaddingLeft = UDimNew(0, 8)
                    })

                    Instances:Create("UIListLayout", {
                        Parent = NewItems["Content"].Instance,
                        Name = "\0",
                        Padding = UDimNew(0, 4),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    })

                    NewSection.Items = NewItems
                end

                NewItems["InactiveOutline"].Instance.Size = UDim2New(0, NewItems["Text"].Instance.TextBounds.X + 16, 0, 26)

                local Debounce = false

                function NewSection:Turn(Bool)
                    if Debounce then 
                        return 
                    end

                    NewSection.Active = Bool 
                    
                    Debounce = true
                    NewItems["Content"].Instance.Visible = Bool 
                    NewItems["Content"].Instance.Parent = Bool and Items["ContentInline"].Instance or Library.UnusedHolder.Instance

                    if NewSection.Active then
                        NewItems["Text"]:ChangeItemTheme({TextColor3 = "Accent"})

                        NewItems["Liner"]:Tween(nil, {BackgroundTransparency = 0})
                        NewItems["Hide"]:Tween(nil, {BackgroundTransparency = 0})
                        NewItems["Text"]:Tween(nil, {TextColor3 = Library.Theme.Accent})
                        NewItems["InactiveOutline"]:Tween(nil, {Size = UDim2New(0, NewItems["Text"].Instance.TextBounds.X + 16, 0, 28)})
                    else
                        NewItems["Text"]:ChangeItemTheme({TextColor3 = function()
                            return FromRGB(255, 255, 255)
                        end})

                        NewItems["Liner"]:Tween(nil, {BackgroundTransparency = 1})
                        NewItems["Hide"]:Tween(nil, {BackgroundTransparency = 1})
                        NewItems["Text"]:Tween(nil, {TextColor3 = FromRGB(255, 255, 255)})
                        NewItems["InactiveOutline"]:Tween(nil, {Size = UDim2New(0, NewItems["Text"].Instance.TextBounds.X + 16, 0, 26)})
                    end

                    Debounce = false
                end

                NewItems["InactiveOutline"]:Connect("MouseButton1Down", function()
                    for Index, Value in MultiSection.Sections do 
                        if Value == NewSection and NewSection.Active then
                            return
                        end

                        Value:Turn(Value == NewSection)
                    end
                end)

                if #MultiSection.Sections == 0 then 
                    NewSection:Turn(true)
                end

                TableInsert(MultiSection.Sections, NewSection)
                return setmetatable(NewSection, Library.Sections)
            end

            return MultiSection
        end

        Library.Sections.Toggle = function(self, Data)
            Data = Data or { }

            local Toggle = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Toggle",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or false,
                Callback = Data.Callback or Data.callback or function() end,

                Value = false
            }

            local Items = { } do 
                Items["Toggle"] = Instances:Create("TextButton", {
                    Parent = Toggle.Section.Items["Content"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Size = UDim2New(1, 0, 0, 15),
                    ZIndex = 2,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["Indicator"] = Instances:Create("ImageLabel", {
                    Parent = Items["Toggle"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 13, 0, 13),
                    AnchorPoint = Vector2New(0, 0.5),
                    Image = "rbxassetid://75605666806450",
                    Position = UDim2New(0, 0, 0.5, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(24, 24, 24)
                })

                Items["CheckImage"] = Instances:Create("ImageLabel", {
                    Parent = Items["Indicator"].Instance,
                    Name = "\0",
                    ImageColor3 = FromRGB(226, 94, 18),
                    ImageTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 7, 0, 7),
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Image = "rbxassetid://120535220351173",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["CheckImage"]:AddToTheme({ImageColor3 = "Accent"})

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Toggle"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Toggle.Name,
                    AutomaticSize = Enum.AutomaticSize.X,
                    AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 20, 0.5, -2),
                    BorderSizePixel = 0,
                    ZIndex = 2,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["SubElements"] = Instances:Create("Frame", {
                    Parent = Items["Toggle"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(1, 0),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, -1, 0, 0),
                    Size = UDim2New(0, 0, 1, 0),
                    ZIndex = 2,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["SubElements"].Instance,
                    Name = "\0",
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    Padding = UDimNew(0, 4),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
            end

            function Toggle:Get()
                return Toggle.Value 
            end

            function Toggle:Set(Value)
                Toggle.Value = Value 
                Library.Flags[Toggle.Flag] = Value 

                if Toggle.Value then 
                    Items["CheckImage"]:Tween(nil, {ImageTransparency = 0})
                else
                    Items["CheckImage"]:Tween(nil, {ImageTransparency = 1})
                end

                if Toggle.Callback then 
                    Library:SafeCall(Toggle.Callback, Toggle.Value)
                end
            end

            function Toggle:SetVisibility(Bool)
                Items["Toggle"].Instance.Visible = Bool 
            end

            function Toggle:Colorpicker(Data)
                Data = Data or { }

                local Colorpicker = {
                    Window = self.Window,
                    Page = self.Page,
                    Section = self,

                    Flag = Data.Flag or Data.flag or "Colorpicker",
                    Default = Data.Default or Data.default or FromRGB(255, 255, 255),
                    Callback = Data.Callback or Data.callback or function() end,
                    Alpha = Data.Alpha or Data.alpha or false
                }

                local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
                    Flag = Colorpicker.Flag,
                    Default = Colorpicker.Default,
                    Alpha = Colorpicker.Alpha,
                    Callback = Colorpicker.Callback,
                    Parent = Items["SubElements"]
                })

                return NewColorpicker
            end

            function Toggle:Keybind(Data)
                Data = Data or { }

                local Keybind = {
                    Window = self.Window,
                    Page = self.Page,
                    Section = self.Section,

                    Name = Data.Name or Data.name or "Keybind",
                    Flag = Data.Flag or Data.flag or "Keybind",
                    Default = Data.Default or Data.default or Enum.KeyCode.E,
                    Callback = Data.Callback or Data.callback or function() end,
                    Mode = Data.Mode or Data.mode or "Toggle"
                }

                local NewKeybind, KeybindItems = Library:CreateKeybind({
                    Flag = Keybind.Flag,
                    Name = Keybind.Name,
                    Default = Keybind.Default,
                    Mode = Keybind.Mode,
                    Callback = Keybind.Callback,
                    Parent = Items["SubElements"]
                })

                return NewKeybind
            end

            Items["Toggle"]:Connect("MouseButton1Down", function()
                Toggle:Set(not Toggle.Value)
            end)

            Toggle:Set(Toggle.Default)

            Library.SetFlags[Toggle.Flag] = function(Value)
                Toggle:Set(Value)
            end

            return Toggle 
        end

        Library.Sections.Button = function(self, Data)
            Data = Data or { }

            local Button = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Button",
                Callback = Data.Callback or Data.callback or function() end
            }

            local Items = { } do 
                Items["Button"] = Instances:Create("TextButton", {
                    Parent = Button.Section.Items["Content"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BorderSizePixel = 0,
                    Size = UDim2New(1, 0, 0, 20),
                    ZIndex = 2,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(24, 24, 24)
                })

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Button"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Button.Name,
                    AnchorPoint = Vector2New(0.5, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, -1),
                    Size = UDim2New(0, 0, 0, 15),
                    ZIndex = 3,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["Indicator"] = Instances:Create("ImageLabel", {
                    Parent = Items["Button"].Instance,
                    Name = "\0",
                    ScaleType = Enum.ScaleType.Slice,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 1, 0),
                    BackgroundColor3 = FromRGB(255, 255, 255),
                    ResampleMode = Enum.ResamplerMode.Pixelated,
                    Image = "rbxassetid://118318078814280",
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    SliceCenter = RectNew(Vector2New(2, 2), Vector2New(3, 3))
                })
            end

            function Button:SetVisibility(Bool)
                Items["Button"].Instance.Visible = Bool
            end

            function Button:Press()
                Items["Text"]:Tween(nil, {TextColor3 = Library.Theme.Accent})
                Library:SafeCall(Button.Callback)
                task.wait(0.1)
                Items["Text"]:Tween(nil, {TextColor3 = FromRGB(255, 255, 255)})
            end

            Items["Button"]:Connect("MouseButton1Down", function()
                Button:Press()
            end)

            return Button
        end

        Library.Sections.Slider = function(self, Data)
            Data = Data or { }

            local Slider = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Slider",
                Min = Data.Min or Data.min or 0,
                Max = Data.Max or Data.max or 100,
                Callback = Data.Callback or Data.callback or function() end,
                Default = Data.Default or Data.default or 0,
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Decimals = Data.Decimals or Data.decimals or 0,
                Suffix = Data.Suffix or Data.suffix or "",

                Value = 0,
                Sliding = false
            }

            local Items = { } do
                Items["Slider"] = Instances:Create("Frame", {
                    Parent = Slider.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 0, 28),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Slider"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Slider.Name,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    ZIndex = 2,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["RealSlider"] = Instances:Create("ImageButton", {
                    Parent = Items["Slider"].Instance,
                    AutoButtonColor = false,
                    Name = "\0",
                    ScaleType = Enum.ScaleType.Slice,
                    BorderColor3 = FromRGB(0, 0, 0),
                    BackgroundColor3 = FromRGB(255, 255, 255),
                    ResampleMode = Enum.ResamplerMode.Pixelated,
                    Size = UDim2New(1, 0, 0, 8),
                    AnchorPoint = Vector2New(0, 1),
                    Image = "rbxassetid://118318078814280",
                    Position = UDim2New(0, 0, 1, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    SliceCenter = RectNew(Vector2New(2, 2), Vector2New(3, 3))
                })

                Items["Accent"] = Instances:Create("Frame", {
                    Parent = Items["RealSlider"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 0.5),
                    Position = UDim2New(0, 2, 0.5, 0),
                    Size = UDim2New(0.4000000059604645, 0, 0, 2),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(226, 94, 18)
                })  Items["Accent"]:AddToTheme({BackgroundColor3 = "Accent"})

                Items["Dragger"] = Instances:Create("ImageLabel", {
                    Parent = Items["Accent"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 6, 0, 13),
                    AnchorPoint = Vector2New(1, 0.5),
                    Image = "rbxassetid://116476501088869",
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, 0, 0.5, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["Value"] = Instances:Create("TextLabel", {
                    Parent = Items["Slider"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "200%",
                    AutomaticSize = Enum.AutomaticSize.X,
                    AnchorPoint = Vector2New(1, 0),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, 0, 0, 0),
                    BorderSizePixel = 0,
                    ZIndex = 2,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
            end

            function Slider:Get()
                return Slider.Value
            end

            function Slider:Set(Value)
                Slider.Value = MathClamp(Library:Round(Value, Slider.Decimals), Slider.Min, Slider.Max)
                Library.Flags[Slider.Flag] = Slider.Value

                Items["Accent"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2New((Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 0, 2)})
                Items["Value"].Instance.Text = StringFormat("%s%s", tostring(Slider.Value), Slider.Suffix)

                if Slider.Callback then 
                    Library:SafeCall(Slider.Callback, Slider.Value)
                end
            end

            function Slider:SetVisibility(Bool)
                Items["Slider"].Instance.Visible = Bool
            end

            Items["RealSlider"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Slider.Sliding = true

                    local SizeX = (Input.Position.X - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
                    local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

                    Slider:Set(Value)
                end
            end)

            Items["RealSlider"]:Connect("InputEnded", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Slider.Sliding = false
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement then
                    if Slider.Sliding then
                        local SizeX = (Input.Position.X - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
                        local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

                        Slider:Set(Value)
                    end
                end
            end)

            if Slider.Default then
                Slider:Set(Slider.Default)
            end

            Library.SetFlags[Slider.Flag] = function(Value)
                Slider:Set(Value)
            end

            return Slider
        end

        Library.Sections.Dropdown = function(self, Data)
            Data = Data or { }

            local Dropdown = { 
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Dropdown",
                Items = Data.Items or Data.items or { },
                Default = Data.Default or Data.default or nil,
                Callback = Data.Callback or Data.callback or function() end,
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Multi = Data.Multi or Data.multi or false,

                Value = { },
                IsOpen = false,
                OptionCount = 1,
                Options = { }
            }

            local Items = { } do
                Items["Dropdown"] = Instances:Create("Frame", {
                    Parent = Dropdown.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 0, 44),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Dropdown"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Dropdown.Name,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    ZIndex = 2,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["RealDropdown"] = Instances:Create("ImageButton", {
                    Parent = Items["Dropdown"].Instance,
                    AutoButtonColor = false,
                    Name = "\0",
                    ScaleType = Enum.ScaleType.Slice,
                    BorderColor3 = FromRGB(0, 0, 0),
                    ResampleMode = Enum.ResamplerMode.Pixelated,
                    Size = UDim2New(1, 0, 0, 24),
                    BackgroundColor3 = FromRGB(255, 255, 255),
                    AnchorPoint = Vector2New(0, 1),
                    Image = "rbxassetid://118318078814280",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 1, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    SliceCenter = RectNew(Vector2New(2, 2), Vector2New(3, 3))
                })

                Items["Value"] = Instances:Create("TextLabel", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "Value",
                    AutomaticSize = Enum.AutomaticSize.X,
                    AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 6, 0.5, -1),
                    BorderSizePixel = 0,
                    ZIndex = 2,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["ArrowIcon"] = Instances:Create("ImageLabel", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    ImageColor3 = FromRGB(226, 94, 18),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 16, 0, 16),
                    AnchorPoint = Vector2New(1, 0.5),
                    Image = "rbxassetid://83867936142391",
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, -6, 0.5, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["ArrowIcon"]:AddToTheme({ImageColor3 = "Accent"})

                Items["OptionHolder"] = Instances:Create("TextButton", {
                    Parent = Library.UnusedHolder.Instance,
                    Name = "\0",
                    Active = false,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2New(1, 0, 0, 100),
                    BorderSizePixel = 0,
                    Position = UDim2New(0, 0, 1, 5),
                    Selectable = false,
                    Visible = false,
                    ZIndex = 4,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = FromRGB(75, 75, 75)
                })

                Items["StrokeHolder"] = Instances:Create("Frame", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 1, 0, 1),
                    Size = UDim2New(1, -1, 1, -1),
                    ZIndex = 3,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["StrokeHolder"].Instance,
                    Name = "\0",
                    LineJoinMode = Enum.LineJoinMode.Miter
                })

                Items["Inline"] = Instances:Create("Frame", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    Size = UDim2New(1, -1, 1, -1),
                    Position = UDim2New(0, 1, 0, 1),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 4,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(32, 32, 32)
                })

                Items["Holder"] = Instances:Create("Frame", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    ClipsDescendants = true,
                    BorderColor3 = FromRGB(0, 0, 0),
                    SelectionGroup = true,
                    Active = true,
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 1, 0),
                    Selectable = true,
                    ZIndex = 4,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["Holder"].Instance,
                    Name = "\0",
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Instances:Create("UIPadding", {
                    Parent = Items["Holder"].Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 2),
                    PaddingLeft = UDimNew(0, 2)
                })
            end

            function Dropdown:Get()
                return Dropdown.Value
            end

            function Dropdown:SetVisibility(Bool)
                Items["Dropdown"].Instance.Visible = Bool
            end

            function Dropdown:Set(Option)
                if Dropdown.Multi then 
                    if type(Option) ~= "table" then 
                        return
                    end

                    Dropdown.Value = Option
                    Library.Flags[Dropdown.Flag] = Option

                    for Index, Value in Option do
                        local OptionData = Dropdown.Options[Value]
                        
                        if not OptionData then
                            continue
                        end

                        OptionData.Selected = true 
                        OptionData:Toggle("Active")
                    end

                    Items["Value"].Instance.Text = TableConcat(Option, ", ")
                else
                    if not Dropdown.Options[Option] then
                        return
                    end

                    local OptionData = Dropdown.Options[Option]

                    Dropdown.Value = Option
                    Library.Flags[Dropdown.Flag] = Option

                    for Index, Value in Dropdown.Options do
                        if Value ~= OptionData then
                            Value.Selected = false 
                            Value:Toggle("Inactive")
                        else
                            Value.Selected = true 
                            Value:Toggle("Active")
                        end
                    end

                    Items["Value"].Instance.Text = Option
                end

                if Dropdown.Callback then   
                    Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                end
            end

            function Dropdown:Add(Option)
                local IsOptionEven = Dropdown.OptionCount % 2 == 0

                local OptionButton = Instances:Create("TextButton", {
                    Parent = Items["Holder"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Option,
                    AutoButtonColor = false,
                    BorderSizePixel = 0,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2New(1, 0, 0, 20),
                    ZIndex = 4,
                    TextSize = 12,
                    BackgroundColor3 = not IsOptionEven and FromRGB(24, 24, 24) or FromRGB(36, 36, 36)
                })  OptionButton:AddToTheme({TextColor3 = function()
                    return FromRGB(255, 255, 255)
                end})

                Instances:Create("UIPadding", {
                    Parent = OptionButton.Instance,
                    Name = "\0",
                    PaddingLeft = UDimNew(0, 8)
                })

                local OptionData = {
                    Button = OptionButton,
                    Name = Option,
                    Selected = false
                }

                function OptionData:Toggle(Status)
                    if Status == "Active" then 
                        OptionData.Button:ChangeItemTheme({TextColor3 = "Accent"})
                        OptionData.Button:Tween(nil, {TextColor3 = Library.Theme.Accent})
                    else
                        OptionData.Button:ChangeItemTheme({TextColor3 = function()
                            return FromRGB(255, 255, 255)
                        end})
                        OptionData.Button:Tween(nil, {TextColor3 = FromRGB(255, 255, 255)})
                    end
                end

                function OptionData:Set()
                    OptionData.Selected = not OptionData.Selected

                    if Dropdown.Multi then 
                        local Index = TableFind(Dropdown.Value, OptionData.Name)

                        if Index then 
                            TableRemove(Dropdown.Value, Index)
                        else
                            TableInsert(Dropdown.Value, OptionData.Name)
                        end

                        OptionData:Toggle(Index and "Inactive" or "Active")

                        Library.Flags[Dropdown.Flag] = Dropdown.Value

                        local TextFormat = #Dropdown.Value > 0 and TableConcat(Dropdown.Value, ", ") or "--"
                        Items["Value"].Instance.Text = TextFormat
                    else
                        if OptionData.Selected then 
                            Dropdown.Value = OptionData.Name
                            Library.Flags[Dropdown.Flag] = OptionData.Name

                            OptionData.Selected = true
                            OptionData:Toggle("Active")

                            for Index, Value in Dropdown.Options do 
                                if Value ~= OptionData then
                                    Value.Selected = false 
                                    Value:Toggle("Inactive")
                                end
                            end

                            Items["Value"].Instance.Text = OptionData.Name
                        else
                            Dropdown.Value = nil
                            Library.Flags[Dropdown.Flag] = nil

                            OptionData.Selected = false
                            OptionData:Toggle("Inactive")

                            Items["Value"].Instance.Text = "--"
                        end
                    end

                    if Dropdown.Callback then
                        Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                    end
                end

                OptionData.Button:Connect("MouseButton1Down", function()
                    OptionData:Set()
                end)

                Dropdown.Options[OptionData.Name] = OptionData
                Dropdown.OptionCount += 1
                return OptionData
            end

            local Debounce = false
            local RenderStepped = false

            function Dropdown:SetOpen(Bool)
                if Debounce then 
                    return
                end

                Dropdown.IsOpen = Bool

                Debounce = true 

                if Dropdown.IsOpen then 
                    Items["OptionHolder"].Instance.Visible = true
                    Items["OptionHolder"].Instance.Parent = Library.Holder.Instance
                    Items["ArrowIcon"]:Tween(nil, {Rotation = -90})
                    
                    RenderStepped = RunService.RenderStepped:Connect(function()
                        Items["OptionHolder"].Instance.Position = UDim2New(0, Items["RealDropdown"].Instance.AbsolutePosition.X, 0, Items["RealDropdown"].Instance.AbsolutePosition.Y + Items["RealDropdown"].Instance.AbsoluteSize.Y + 5)
                        Items["OptionHolder"].Instance.Size = UDim2New(0, Items["RealDropdown"].Instance.AbsoluteSize.X, 0, 0)
                    end)

                    if not Debounce then 
                        for Index, Value in Library.OpenFrames do 
                            if Value ~= Dropdown then 
                                Value:SetOpen(false)
                            end
                        end

                        Library.OpenFrames[Dropdown] = Dropdown 
                    end
                else
                    if not Debounce then 
                        if Library.OpenFrames[Dropdown] then 
                            Library.OpenFrames[Dropdown] = nil
                        end
                    end

                    if RenderStepped then 
                        RenderStepped:Disconnect()
                        RenderStepped = nil
                    end

                    Items["ArrowIcon"]:Tween(nil, {Rotation = 0})
                end

                local Descendants = Items["OptionHolder"].Instance:GetDescendants()
                TableInsert(Descendants, Items["OptionHolder"].Instance)

                local NewTween

                for Index, Value in Descendants do 
                    local TransparencyProperty = Tween:GetProperty(Value)

                    if not TransparencyProperty then
                        continue 
                    end

                    if type(TransparencyProperty) == "table" then 
                        for _, Property in TransparencyProperty do 
                            NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                        end
                    else
                        NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                    end
                end
                
                NewTween.Tween.Completed:Connect(function()
                    Debounce = false 
                    Items["OptionHolder"].Instance.Visible = Dropdown.IsOpen
                    task.wait(0.2)
                    Items["OptionHolder"].Instance.Parent = not Dropdown.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
                end)
            end
            
            function Dropdown:Remove(Option)
                if Dropdown.Options[Option] then 
                    Dropdown.Options[Option].Button:Clean()
                    Dropdown.Options[Option] = nil
                    Dropdown.OptionCount -= 1
                end
            end

            function Dropdown:Refresh(List)
                for Index, Value in Dropdown.Options do
                    Dropdown:Remove(Value.Name)
                end

                for Index, Value in List do 
                    Dropdown:Add(Value)
                end
            end

            Items["RealDropdown"]:Connect("MouseButton1Down", function()
                Dropdown:SetOpen(not Dropdown.IsOpen)
            end)

            Library:Connect(UserInputService.InputBegan, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if not Dropdown.IsOpen then
                        return
                    end

                    if Library:IsMouseOverFrame(Items["OptionHolder"]) then
                        return
                    end

                    Dropdown:SetOpen(false)
                end
            end)

            for Index, Value in Dropdown.Items do 
                Dropdown:Add(Value)
            end

            if Dropdown.Default then
                Dropdown:Set(Dropdown.Default)
            end

            Library.SetFlags[Dropdown.Flag] = function(Value)
                Dropdown:Set(Value)
            end

            return Dropdown
        end

        Library.Sections.Label = function(self, Name)
            local Label = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Name or "Label"
            }

            local Items = { } do
                Items["Label"] = Instances:Create("Frame", {
                    Parent = Label.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 0, 15),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Label"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Label.Name,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    ZIndex = 2,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["SubElements"] = Instances:Create("Frame", {
                    Parent = Items["Label"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(1, 0),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, -1, 0, 0),
                    Size = UDim2New(0, 0, 1, 0),
                    ZIndex = 2,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["SubElements"].Instance,
                    Name = "\0",
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    Padding = UDimNew(0, 4),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
            end

            function Label:SetText(Value)
                Value = tostring(Value)
                Items["Text"].Instance.Text = Value
            end

            function Label:SetVisibility(Bool)
                Items["Label"].Instance.Visible = Bool
            end

            function Label:Colorpicker(Data)
                Data = Data or { }

                local Colorpicker = {
                    Window = self.Window,
                    Page = self.Page,
                    Section = self.Section,

                    Flag = Data.Flag or Data.flag or "Colorpicker",
                    Default = Data.Default or Data.default or FromRGB(255, 255, 255),
                    Callback = Data.Callback or Data.callback or function() end,
                    Alpha = Data.Alpha or Data.alpha or false
                }

                local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
                    Flag = Colorpicker.Flag,
                    Default = Colorpicker.Default,
                    Alpha = Colorpicker.Alpha,
                    Callback = Colorpicker.Callback,
                    Parent = Items["SubElements"]
                })

                return NewColorpicker
            end

            function Label:Keybind(Data)
                Data = Data or { }

                local Keybind = {
                    Window = self.Window,
                    Page = self.Page,
                    Section = self.Section,

                    Name = Data.Name or Data.name or "Keybind",
                    Flag = Data.Flag or Data.flag or "Keybind",
                    Default = Data.Default or Data.default or Enum.KeyCode.E,
                    Callback = Data.Callback or Data.callback or function() end,
                    Mode = Data.Mode or Data.mode or "Toggle"
                }

                local NewKeybind, KeybindItems = Library:CreateKeybind({
                    Flag = Keybind.Flag,
                    Name = Keybind.Name,
                    Default = Keybind.Default,
                    Mode = Keybind.Mode,
                    Callback = Keybind.Callback,
                    Parent = Items["SubElements"]
                })

                return NewKeybind
            end

            return Label
        end

        Library.Sections.Textbox = function(self, Data)
            Data = Data or { }

            local Textbox = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or "",
                Numeric = Data.Numeric or Data.numeric or false,
                Finished = Data.Finished or Data.finished or false,
                Placeholder = Data.Placeholder or Data.placeholder or "...",
                Callback = Data.Callback or Data.callback or function() end,

                Value = ""
            }

            local Items = { } do
                Items["Textbox"] = Instances:Create("ImageLabel", {
                    Parent = Textbox.Section.Items["Content"].Instance,
                    Name = "\0",
                    ScaleType = Enum.ScaleType.Slice,
                    BorderColor3 = FromRGB(0, 0, 0),
                    BackgroundColor3 = FromRGB(255, 255, 255),
                    ResampleMode = Enum.ResamplerMode.Pixelated,
                    Size = UDim2New(1, 0, 0, 24),
                    AnchorPoint = Vector2New(0, 1),
                    Image = "rbxassetid://118318078814280",
                    Position = UDim2New(0, 8, 1, -8),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    SliceCenter = RectNew(Vector2New(2, 2), Vector2New(3, 3))
                })

                Items["Input"] = Instances:Create("TextBox", {
                    Parent = Items["Textbox"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    AnchorPoint = Vector2New(0, 0.5),
                    PlaceholderColor3 = FromRGB(145, 145, 145),
                    PlaceholderText = Textbox.Placeholder,
                    TextSize = 12,
                    Size = UDim2New(1, -16, 0, 15),
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    ZIndex = 2,
                    Position = UDim2New(0, 8, 0.5, 0),
                    ClipsDescendants = true,
                    CursorPosition = -1,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    ClearTextOnFocus = false,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIPadding", {
                    Parent = Items["Input"].Instance,
                    Name = "\0",
                    PaddingBottom = UDimNew(0, 2)
                })
            end

            function Textbox:Get()
                return Textbox.Value
            end

            function Textbox:SetVisibility(Bool)
                Items["Textbox"].Instance.Visible = Bool
            end

            function Textbox:Set(Value)
                if Textbox.Numeric then
                    if (not tonumber(Value)) and StringLen(tostring(Value)) > 0 then
                        Value = Textbox.Value
                    end
                end

                Textbox.Value = Value
                Items["Input"].Instance.Text = Value
                Library.Flags[Textbox.Flag] = Value

                if Textbox.Callback then
                    Library:SafeCall(Textbox.Callback, Value)
                end
            end
            
            if Textbox.Finished then 
                Items["Input"]:Connect("FocusLost", function(PressedEnterQuestionMark)
                    if PressedEnterQuestionMark then
                        Textbox:Set(Items["Input"].Instance.Text)
                    end
                end)
            else
                Items["Input"].Instance:GetPropertyChangedSignal("Text"):Connect(function()
                    Textbox:Set(Items["Input"].Instance.Text)
                end)
            end

            if Textbox.Default then
                Textbox:Set(Textbox.Default)
            end

            Library.SetFlags[Textbox.Flag] = function(Value)
                Textbox:Set(Value)
            end

            return Textbox
        end

        Library.Sections.Listbox = function(self, Data) -- just pasted the entire dropdown functionality, cant be asked to write all of it again
            Data = Data or { }

            local Dropdown = { 
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Items = Data.Items or Data.items or { },
                Default = Data.Default or Data.default or nil,
                Callback = Data.Callback or Data.callback or function() end,
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Multi = Data.Multi or Data.multi or false,
                Size = Data.Size or Data.size or 178,

                Value = { },
                OptionCount = 1,
                Options = { }
            }

            local Items = { } do
                Items["Listbox"] = Instances:Create("ImageLabel", {
                    Parent = Dropdown.Section.Items["Content"].Instance,
                    Name = "\0",
                    ScaleType = Enum.ScaleType.Slice,
                    BorderColor3 = FromRGB(0, 0, 0),
                    ResampleMode = Enum.ResamplerMode.Pixelated,
                    Size = UDim2New(1, 0, 0, Dropdown.Size),
                    Image = "rbxassetid://118318078814280",
                    BackgroundTransparency = 1,
                    BackgroundColor3 = FromRGB(255, 255, 255),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    SliceCenter = RectNew(Vector2New(2, 2), Vector2New(3, 3))
                })

                Items["Holder"] = Instances:Create("ScrollingFrame", {
                    Parent = Items["Listbox"].Instance,
                    Name = "\0",
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    CanvasSize = UDim2New(0, 0, 0, 0),
                    ScrollBarImageColor3 = FromRGB(226, 94, 18),
                    MidImage = "rbxassetid://75112813677651",
                    BorderColor3 = FromRGB(0, 0, 0),
                    ScrollBarThickness = 2,
                    Size = UDim2New(1, -4, 1, -8),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0, 4),
                    BottomImage = "rbxassetid://75112813677651",
                    TopImage = "rbxassetid://75112813677651",
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Holder"]:AddToTheme({ScrollBarImageColor3 = "Accent"})

                Instances:Create("UIListLayout", {
                    Parent = Items["Holder"].Instance,
                    Name = "\0",
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Instances:Create("UIPadding", {
                    Parent = Items["Holder"].Instance,
                    Name = "\0",
                    PaddingBottom = UDimNew(0, 5),
                    PaddingTop = UDimNew(0, -1),
                    PaddingLeft = UDimNew(0, 2)
                })
            end

            function Dropdown:Get()
                return Dropdown.Value
            end

            function Dropdown:SetVisibility(Bool)
                Items["Dropdown"].Instance.Visible = Bool
            end

            function Dropdown:Set(Option)
                if Dropdown.Multi then 
                    if type(Option) ~= "table" then 
                        return
                    end

                    Dropdown.Value = Option
                    Library.Flags[Dropdown.Flag] = Option

                    for Index, Value in Option do
                        local OptionData = Dropdown.Options[Value]
                        
                        if not OptionData then
                            continue
                        end

                        OptionData.Selected = true 
                        OptionData:Toggle("Active")
                    end
                else
                    if not Dropdown.Options[Option] then
                        return
                    end

                    local OptionData = Dropdown.Options[Option]

                    Dropdown.Value = Option
                    Library.Flags[Dropdown.Flag] = Option

                    for Index, Value in Dropdown.Options do
                        if Value ~= OptionData then
                            Value.Selected = false 
                            Value:Toggle("Inactive")
                        else
                            Value.Selected = true 
                            Value:Toggle("Active")
                        end
                    end
                end

                if Dropdown.Callback then   
                    Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                end
            end

            function Dropdown:Add(Option)
                local IsOptionEven = Dropdown.OptionCount % 2 == 0

                local OptionButton = Instances:Create("TextButton", {
                    Parent = Items["Holder"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BorderSizePixel = 0,
                    Size = UDim2New(1, 0, 0, 20),
                    ZIndex = 2,
                    TextSize = 14,
                    BackgroundColor3 = not IsOptionEven and FromRGB(28, 28, 28) or FromRGB(36, 36, 36)
                })

                local OptionIndicator = Instances:Create("ImageLabel", {
                    Parent = OptionButton.Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 13, 0, 13),
                    AnchorPoint = Vector2New(0, 0.5),
                    Image = "rbxassetid://75605666806450",
                    Position = UDim2New(0, 6, 0.5, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(24, 24, 24)
                })

                local CheckImage = Instances:Create("ImageLabel", {
                    Parent = OptionIndicator.Instance,
                    Name = "\0",
                    ImageColor3 = FromRGB(226, 94, 18),
                    ImageTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 7, 0, 7),
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Image = "rbxassetid://120535220351173",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  CheckImage:AddToTheme({ImageColor3 = "Accent"})

                local OptionText = Instances:Create("TextLabel", {
                    Parent = OptionButton.Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Option,
                    AutomaticSize = Enum.AutomaticSize.X,
                    AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 26, 0.5, -1),
                    BorderSizePixel = 0,
                    ZIndex = 2,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  OptionText:AddToTheme({TextColor3 = function()
                    return FromRGB(255, 255, 255)
                end})

                local OptionData = {
                    Button = OptionButton,
                    Text = OptionText,
                    Check = CheckImage,
                    Name = Option,
                    Selected = false
                }

                function OptionData:Toggle(Status)
                    if Status == "Active" then 
                        OptionData.Text:ChangeItemTheme({TextColor3 = "Accent"})
                        OptionData.Text:Tween(nil, {TextColor3 = Library.Theme.Accent})
                        OptionData.Check:Tween(nil, {ImageTransparency = 0})
                    else
                        OptionData.Text:ChangeItemTheme({TextColor3 = function()
                            return FromRGB(255, 255, 255)
                        end})
                        OptionData.Text:Tween(nil, {TextColor3 = FromRGB(255, 255, 255)})
                        OptionData.Check:Tween(nil, {ImageTransparency = 1})
                    end
                end

                function OptionData:Set()
                    OptionData.Selected = not OptionData.Selected

                    if Dropdown.Multi then 
                        local Index = TableFind(Dropdown.Value, OptionData.Name)

                        if Index then 
                            TableRemove(Dropdown.Value, Index)
                        else
                            TableInsert(Dropdown.Value, OptionData.Name)
                        end

                        OptionData:Toggle(Index and "Inactive" or "Active")

                        Library.Flags[Dropdown.Flag] = Dropdown.Value
                    else
                        if OptionData.Selected then 
                            Dropdown.Value = OptionData.Name
                            Library.Flags[Dropdown.Flag] = OptionData.Name

                            OptionData.Selected = true
                            OptionData:Toggle("Active")

                            for Index, Value in Dropdown.Options do 
                                if Value ~= OptionData then
                                    Value.Selected = false 
                                    Value:Toggle("Inactive")
                                end
                            end
                        else
                            Dropdown.Value = nil
                            Library.Flags[Dropdown.Flag] = nil

                            OptionData.Selected = false
                            OptionData:Toggle("Inactive")
                        end
                    end

                    if Dropdown.Callback then
                        Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                    end
                end

                OptionData.Button:Connect("MouseButton1Down", function()
                    OptionData:Set()
                end)

                Dropdown.Options[OptionData.Name] = OptionData
                Dropdown.OptionCount += 1
                return OptionData
            end

            local Debounce = false
            local RenderStepped = false
            
            function Dropdown:Remove(Option)
                if Dropdown.Options[Option] then 
                    Dropdown.Options[Option].Button:Clean()
                    Dropdown.Options[Option] = nil
                    Dropdown.OptionCount -= 1
                end
            end

            function Dropdown:Refresh(List)
                for Index, Value in Dropdown.Options do
                    Dropdown:Remove(Value.Name)
                end

                for Index, Value in List do 
                    Dropdown:Add(Value)
                end
            end

            for Index, Value in Dropdown.Items do 
                Dropdown:Add(Value)
            end

            if Dropdown.Default then
                Dropdown:Set(Dropdown.Default)
            end

            Library.SetFlags[Dropdown.Flag] = function(Value)
                Dropdown:Set(Value)
            end

            return Dropdown
        end
    end

    Library.CreateSettingsPage = function(self, Window, ModuleList, Indicator)
        local SettingsPage = Window:Page({
            Name = "Settings",
            Columns = 2
        }) do
            local ConfigsSection = SettingsPage:Section({
                Name = "Configs",
                Side = 1
            })

            do
                local ConfigName = ""
                local ConfigSelected

                local ConfigsList = ConfigsSection:Listbox({
                    Name = "Configs", 
                    Flag = "ConfigsList", 
                    Items = { }, 
                    Multi = false,
                    Size = 150,
                    Callback = function(Value)
                        ConfigSelected = Value
                    end
                })

                ConfigsSection:Textbox({ 
                    Default = "", 
                    Flag = "ConfigName", 
                    Placeholder = "Config name", 
                    Callback = function(Value)
                        ConfigName = Value
                    end
                })

                ConfigsSection:Button({
                    Name = "Create",
                    Callback = function()
                    if ConfigName and ConfigName ~= "" then
                        if not isfile(Library.Folders.Configs .. "/" .. ConfigName .. ".json") then
                            writefile(Library.Folders.Configs .. "/" .. ConfigName .. ".json", Library:GetConfig())
                            Library:Notification("Succesfully created config", "80210124197799", 5)
                            Library:RefreshConfigsList(ConfigsList)
                        else
                            return
                        end
                    end
                end})

                ConfigsSection:Button({
                    Name = "Delete", 
                    Callback = function()
                    if ConfigSelected then
                        Library:DeleteConfig(ConfigSelected)
                        Library:RefreshConfigsList(ConfigsList)
                    end
                end})

                ConfigsSection:Button({
                    Name = "Load", 
                    Callback = function()
                    if ConfigSelected then
                        Library:LoadConfig(readfile(Library.Folders.Configs .. "/" .. ConfigSelected))
                    end
                end})

                ConfigsSection:Button({
                    Name = "Save", 
                    Callback = function()
                    if ConfigName and ConfigName ~= "" then
                        writefile(Library.Folders.Configs .. "/" .. ConfigName .. ".json", Library:GetConfig())
                        Library:RefreshConfigsList(ConfigsList)
                    end
                end})

                ConfigsSection:Button({
                    Name = "Refresh", 
                    Callback = function()
                    Library:RefreshConfigsList(ConfigsList)
                end})

                Library:RefreshConfigsList(ConfigsList)
            end

            local SettingsSection = SettingsPage:Section({
                Name = "Settings",
                Side = 2
            })

            do
                SettingsSection:Button({
                    Name = "Unload",
                    Callback = function()
                        Library:Unload()
                    end
                })

                SettingsSection:Toggle({
                    Name = "Module List",
                    Flag = "Module list",
                    Default = true,
                    Callback = function(Value)
                        ModuleList:SetVisibility(Value)
                    end
                })

                SettingsSection:Toggle({
                    Name = "Indicator",
                    Flag = "Indicator",
                    Default = true,
                    Callback = function(Value)
                        Indicator:SetVisibility(Value)
                    end
                })

                SettingsSection:Label("Menu Keybind"):Keybind({
                    Name = "Menu Keybind",
                    Flag = "MenuKeybind",
                    Default = Library.MenuKeybind,
                    Mode = "Toggle",
                    Callback = function()
                        Library.MenuKeybind = Library.Flags["MenuKeybind"].Key
                    end
                })

                SettingsSection:Slider({
                    Name = "Tween Speed",
                    Default = 0.2,
                    Flag = "Tween Speed",
                    Decimals = 0.01,
                    Suffix = "s",
                    Max = 10,
                    Min = 0,
                    Callback = function(Value)
                        Library.Tween.Time = Value
                    end
                })

                SettingsSection:Dropdown({
                    Name = "Tween Style",
                    Flag = "Tween style",
                    Items = { "Linear", "Quad", "Quart", "Back", "Bounce", "Circular", "Cubic", "Elastic", "Exponential", "Sine", "Quint" },
                    Default = "Sine",
                    Callback = function(Value)
                        if not Value then Value = "Sine" end
                        Library.Tween.Style = Enum.EasingStyle[Value]
                    end
                })

                SettingsSection:Dropdown({
                    Name = "Tween Direction",
                    Flag = "Tween direction",
                    Items = { "In", "Out", "InOut" },
                    Default = "Out",
                    Callback = function(Value)
                        if not Value then Value = "Out" end
                        Library.Tween.Direction = Enum.EasingDirection[Value]
                    end
                })

                SettingsSection:Label("UI Color"):Colorpicker({
                    Flag = "AccentColor",
                    Default = Library.Theme.Accent,
                    Alpha = 0,
                    Callback = function(Color, Alpha)
                        Library.Theme.Accent = Color
                        Library:ChangeTheme("Accent", Color)
                    end
                })
            end
        end

        return SettingsPage
    end
end

getgenv().MisanthropyChudvision = Library
----------------------------------------------------------------------------------
-- END EMBEDDED chudvision
----------------------------------------------------------------------------------
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

local guiParent: Instance
do
	local ok, hui = pcall(function() return (gethui :: any)() end)
	guiParent = (ok and hui) or game:GetService("CoreGui")
end

local GH = "https://raw.githubusercontent.com/ywozia/volt-assets/main/"
local ROOT = "misanthropy_assets"
local _writefile = (writefile :: any)
local _readfile = (readfile :: any)
local _isfile = (isfile :: any)
local _isfolder = (isfolder :: any)
local _makefolder = (makefolder :: any)
local _getasset = (getcustomasset or getsynasset or (syn and syn.getcustomasset)) :: any
local _req = ((syn and syn.request) or (http and http.request) or http_request or request or (fluxus and fluxus.request)) :: any
local CAN_DL = _writefile ~= nil and _isfile ~= nil and _getasset ~= nil

local function httpGetBinary(url: string): string?
	if _req then
		local ok, res = pcall(_req, { Url = url, Method = "GET" })
		if ok and res and res.Body and #res.Body > 0 then return res.Body end
	end
	local ok, body = pcall(function() return game:HttpGetAsync(url) end)
	if ok and body and #body > 0 then return body end
	return nil
end
local function ensureDir(dir: string)
	if not _isfolder or not _makefolder then return end
	local cur = ""
	for _, p in ipairs(string.split(dir, "/")) do
		cur = (cur == "") and p or (cur .. "/" .. p)
		if not _isfolder(cur) then pcall(_makefolder, cur) end
	end
end
local function resolveRepoAsset(relPath: string): string?
	if not CAN_DL then return nil end
	local full = ROOT .. "/" .. relPath
	if not _isfile(full) then
		local data = httpGetBinary(GH .. relPath)
		if not data then return nil end
		local dir = string.match(full, "^(.*)/[^/]+$"); if dir then ensureDir(dir) end
		if not pcall(_writefile, full, data) then return nil end
	end
	local ok, id = pcall(_getasset, full)
	return ok and id or nil
end
local function saveString(name: string, value: string)
	if not (_writefile and _isfolder and _makefolder) then return end
	if not _isfolder(ROOT) then pcall(_makefolder, ROOT) end
	pcall(_writefile, ROOT .. "/" .. name, value)
end
local function loadString(name: string): string?
	if not (_readfile and _isfile) then return nil end
	local p = ROOT .. "/" .. name
	if _isfile(p) then local ok, v = pcall(_readfile, p); if ok then return v end end
	return nil
end
local _delfile = delfile :: any

local screen = Instance.new("ScreenGui")
screen.Name = "misanthropy_visuals"
screen.ResetOnSpawn = false
screen.IgnoreGuiInset = true
screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screen.DisplayOrder = 9999
screen.Parent = guiParent

-- Every feature below is hosted in its own chudvision window instead of
-- nhack's Lua tab. nhack keeps a "misanthropy" tab (still under its own
-- AddTab, since nhack owns the default Lua tab and exposes no rename API
-- for it), but that tab now holds nothing except a toggle for the
-- chudvision window's visibility.
local Window = Library:Window({ Name = "misanthropy.lua" })

-- chudvision ships its own hardcoded "RightControl toggles the window"
-- shortcut (Library.MenuKeybind). That's a second, unsynced path to the
-- same Window:SetOpen state as the toggle/keybind below, so it's disabled
-- here - visibility is meant to be controlled from exactly one place.
Library.MenuKeybind = "None"

local NhackTab = getgenv().Nhack:AddTab("misanthropy")
local uiToggleSec = NhackTab:Section("chudvision UI")
local uiToggle = uiToggleSec:Toggle({
	Name = "Show UI",
	Default = true,
	Flag = "misanthropy_show_ui",
	Callback = function(v: boolean)
		Window:SetOpen(v)
	end,
})

-- nhack's Toggle is expected to mirror chudvision's Toggle:Keybind(Data)
-- (same shared library lineage as the rest of nhack's API), which draws a
-- rebindable keybind row inline next to the toggle. If this particular
-- nhack build doesn't have it, fall back to a plain hotkey so "toggle UI"
-- still has a keybind either way. The callback uses the boolean the
-- keybind itself hands back rather than flipping uiToggle:Get() - if
-- nhack's Keybind also syncs the parent Toggle on its own (undocumented,
-- can't verify without nhack's source), a relative flip could double-apply
-- and get stuck; setting the delivered value directly can't compound.
if type(uiToggle.Keybind) == "function" then
	uiToggle:Keybind({
		Name = "Show UI Keybind",
		Flag = "misanthropy_show_ui_key",
		Default = Enum.KeyCode.RightAlt,
		Mode = "Toggle",
		Callback = function(toggled: boolean)
			uiToggle:Set(toggled)
		end,
	})
else
	UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessed: boolean)
		if gameProcessed then return end
		if input.KeyCode == Enum.KeyCode.RightAlt then
			uiToggle:Set(not uiToggle:Get())
		end
	end)
end

-- Every feature section below lands on one of these pages.
local pgCharacter = Window:Page({ Name = "Character FX", Columns = 2 })
local pgWorld = Window:Page({ Name = "World FX", Columns = 2 })
local pgPlayer = Window:Page({ Name = "Player", Columns = 2 })
local pgConfigs = Window:Page({ Name = "Configs", Columns = 1 })
local pgUtility = Window:Page({ Name = "Utility", Columns = 1 })

local sectionSideCounts = {}
local function newSection(page: any, name: string): any
	local n = (sectionSideCounts[page] or 0) + 1
	sectionSideCounts[page] = n
	local side = (n % 2 == 1) and 1 or 2
	return page:Section({ Name = name, Side = side })
end

-- chudvision has no Toggle:Settings() sub-panel like nhack did. This
-- reproduces the same "hide/show these controls together with the parent
-- toggle" behavior using every element's native SetVisibility, driven off
-- the toggle's own Callback (Toggle:Set re-reads Toggle.Callback on every
-- call, so replacing it after construction is safe).
local function settingsOf(section: any, toggle: any): any
	local members = {}
	local rowVisible = true

	local function effectiveVisible(): boolean
		return rowVisible and toggle:Get()
	end
	local function applyAll()
		local v = effectiveVisible()
		for _, m in ipairs(members) do
			pcall(function() m:SetVisibility(v) end)
		end
	end
	local function register(elem: any): any
		table.insert(members, elem)
		pcall(function() elem:SetVisibility(effectiveVisible()) end)
		return elem
	end

	local userCallback = toggle.Callback
	toggle.Callback = function(v: boolean)
		applyAll()
		if userCallback then userCallback(v) end
	end

	-- Some toggles (e.g. Model Skin's "Spin") are themselves members of an
	-- outer settingsOf group. When that outer group hides this toggle's
	-- row, our own members need to hide too, regardless of this toggle's
	-- own value - otherwise a sub-slider can stay visibly orphaned after
	-- its parent toggle row has disappeared. Wrapping SetVisibility (not
	-- just Callback) makes that cascade work at any nesting depth.
	local baseSetVisibility = toggle.SetVisibility
	toggle.SetVisibility = function(self: any, v: boolean)
		baseSetVisibility(self, v)
		rowVisible = v
		applyAll()
	end

	local group = {}
	function group:Toggle(d: any): any return register(section:Toggle(d)) end
	function group:Slider(d: any): any return register(section:Slider(d)) end
	function group:Dropdown(d: any): any return register(section:Dropdown(d)) end
	function group:Button(d: any): any return register(section:Button(d)) end
	function group:Textbox(d: any): any return register(section:Textbox(d)) end
	function group:Label(name: string): any return register(section:Label(name)) end
	return group
end

-- chudvision has no toast/notification API, but nhack's own Library
-- (getgenv().Library, untouched by the chudvision embed above - see the
-- MisanthropyChudvision rename) does expose Library:Notify({Text, Lifetime}).
-- Route through that when it's there; otherwise fall back to print so
-- nothing throws.
local function notify(title: string, text: string)
	local NhackLibrary = getgenv().Library
	if NhackLibrary and NhackLibrary.Notify then
		pcall(function() NhackLibrary:Notify({ Text = title .. ": " .. text, Lifetime = 6 }) end)
	else
		print("[" .. title .. "] " .. text)
	end
end

local cleanups: { () -> () } = {}
local CFG = { toggles = {}, sliders = {}, dropdowns = {}, colors = {} }

-- Colorpicker only ever hangs off a Toggle or a Label in chudvision, and
-- its Get()/Set() already return/accept (Color3, alpha) same as nhack's
-- did, so this is now a thin pass-through onto a real, working colorpicker
-- instead of the old RGB-slider workaround for nhack's broken popup.
local function newColorpicker(parent: any, opts: any): any
	return parent:Label(opts.Name):Colorpicker({
		Flag = opts.Flag or opts.Name,
		Default = opts.Default or Color3.new(1, 1, 1),
		Alpha = 0,
		Callback = opts.Callback,
	})
end

-- chudvision's Textbox actually renders (nhack's didn't), so this is now a
-- thin pass-through instead of the old console-input-button workaround.
-- The Label call preserves the field's caption, which chudvision's Textbox
-- doesn't draw on its own.
local function newTextInput(parent: any, opts: any): any
	parent:Label(opts.Name)
	return parent:Textbox(opts)
end

local LocalPlayer = game:GetService("Players").LocalPlayer

local function getCharacter(): Model?
	return LocalPlayer.Character
end

local function getRootPart(): BasePart?
	local char = getCharacter()
	return char and (char:FindFirstChild("HumanoidRootPart") :: BasePart?)
end

local function getHorizontalSpeed(root: BasePart): number
	local vel = root.AssemblyLinearVelocity
	return Vector3.new(vel.X, 0, vel.Z).Magnitude
end

----------------------------------------------------------------------------------
-- SECTION 2: Trail
----------------------------------------------------------------------------------
local trSec = newSection(pgCharacter, "Trail")
local TR_STYLES = { "Solid", "Taper", "Comet", "Ribbon" }

local trEnabled = trSec:Toggle({ Name = "Enabled", Default = false, Flag = "tr_enabled" })
local trStyle   = trSec:Dropdown({ Name = "Style", Items = TR_STYLES, Default = "Taper", Flag = "tr_style" })
local trColor   = newColorpicker(trSec, { Name = "Color",   Default = Color3.fromRGB(190, 120, 255), Alpha = 1, Flag = "tr_color" })
local trColor2  = newColorpicker(trSec, { Name = "Color 2", Default = Color3.fromRGB(120, 170, 255), Alpha = 1, Flag = "tr_color2" })

local trSettings = settingsOf(trSec, trEnabled)
local trWidth   = trSettings:Slider({ Name = "Width", Min = 20, Max = 400, Step = 10, Default = 100, Suffix = "%", Flag = "tr_width" })
local trLen     = trSettings:Slider({ Name = "Length", Min = 5, Max = 100, Step = 5, Default = 50, Suffix = "%", Flag = "tr_len" })
local trPos     = trSettings:Slider({ Name = "Position (toes to head)", Min = 0, Max = 100, Step = 5, Default = 50, Suffix = "%", Flag = "tr_pos" })
local trTrans   = trSettings:Slider({ Name = "Transparency", Min = 0, Max = 90, Step = 5, Default = 0, Suffix = "%", Flag = "tr_trans" })
local trGlow    = trSettings:Slider({ Name = "Glow", Min = 0, Max = 100, Step = 5, Default = 0, Suffix = "%", Flag = "tr_glow" })
local trRainbow = trSettings:Toggle({ Name = "Rainbow", Default = false, Flag = "tr_rainbow" })
local trRbSpeed = trSettings:Slider({ Name = "Rainbow speed", Min = 5, Max = 200, Step = 5, Default = 50, Suffix = "%", Flag = "tr_rbspeed" })
local trReactive = trSettings:Toggle({ Name = "React to speed", Default = false, Flag = "tr_reactive" })
local trReactAmt = trSettings:Slider({ Name = "Reactivity", Min = 0, Max = 200, Step = 10, Default = 100, Suffix = "%", Flag = "tr_react_amt" })

local trail: Trail? = nil
local att0: Attachment?, att1: Attachment? = nil, nil

local trailFolder = Instance.new("Folder")
trailFolder.Name = "MisanthropyTrail"
trailFolder.Parent = Workspace

local trailFollower = Instance.new("Part")
trailFollower.Name = "TrailFollower"
trailFollower.Anchored = true
trailFollower.CanCollide = false
trailFollower.CanQuery = false
trailFollower.CanTouch = false
trailFollower.Massless = true
trailFollower.Transparency = 1
trailFollower.Size = Vector3.new(0.1, 0.1, 0.1)
trailFollower.Parent = trailFolder

local forceTrailRestyle = false

local function buildTrail()
	if trail then trail:Destroy() end
	if att0 then att0:Destroy() end
	if att1 then att1:Destroy() end
	att0 = Instance.new("Attachment"); att0.Name = "MisT0"; att0.Parent = trailFollower
	att1 = Instance.new("Attachment"); att1.Name = "MisT1"; att1.Parent = trailFollower
	trail = Instance.new("Trail")
	trail.Name = "MisTrail"
	trail.Attachment0 = att0
	trail.Attachment1 = att1
	trail.Enabled = false
	trail.Lifetime = 0.5
	trail.FaceCamera = true
	trail.Parent = trailFollower
end
buildTrail()

trailFollower.ChildRemoved:Connect(function()
	task.defer(function()
		if not (trail and trail.Parent) then
			buildTrail()
			forceTrailRestyle = true
		end
	end)
end)

----------------------------------------------------------------------------------
-- SECTION 3: Particle Aura
----------------------------------------------------------------------------------
local paSec = newSection(pgCharacter, "Particle Aura")

local SPARK = "rbxasset://textures/particles/sparkles_main.dds"
local SMOKE = "rbxasset://textures/particles/smoke_main.dds"
local FIRE  = "rbxasset://textures/particles/fire_main.dds"
local BLANK = ""

type Preset = { tex: string, accel: Vector3, spread: number, light: number, rot: number, sizeMul: number, drag: number }
local PA_PRESETS: { [string]: Preset } = {
	Glow      = { tex = SMOKE, accel = Vector3.zero,          spread = 180, light = 1.0, rot = 5,   sizeMul = 1.4, drag = 1 },
	Sparkles  = { tex = SPARK, accel = Vector3.zero,          spread = 180, light = 1.0, rot = 30,  sizeMul = 0.5, drag = 0 },
	Smoke     = { tex = SMOKE, accel = Vector3.new(0, 4, 0),  spread = 60,  light = 0.1, rot = 10,  sizeMul = 1.8, drag = 2 },
	Stars     = { tex = SPARK, accel = Vector3.zero,          spread = 180, light = 0.8, rot = 40,  sizeMul = 0.8, drag = 0 },
	Fire      = { tex = FIRE,  accel = Vector3.new(0, 10, 0), spread = 25,  light = 1.0, rot = 0,   sizeMul = 1.2, drag = 0 },
	Embers    = { tex = FIRE,  accel = Vector3.new(0, 6, 0),  spread = 50,  light = 1.0, rot = 60,  sizeMul = 0.4, drag = 1 },
	Snow      = { tex = SPARK, accel = Vector3.new(0, -3, 0), spread = 180, light = 0.5, rot = 20,  sizeMul = 0.6, drag = 3 },
	Magic     = { tex = SPARK, accel = Vector3.zero,          spread = 180, light = 1.0, rot = 120, sizeMul = 0.7, drag = 0 },
	Bubbles   = { tex = SMOKE, accel = Vector3.new(0, 5, 0),  spread = 120, light = 0.6, rot = 0,   sizeMul = 1.0, drag = 2 },
	Confetti  = { tex = BLANK, accel = Vector3.new(0, -6, 0), spread = 180, light = 0.2, rot = 200, sizeMul = 0.5, drag = 1 },
	Nebula    = { tex = SMOKE, accel = Vector3.zero,          spread = 180, light = 0.9, rot = 8,   sizeMul = 2.4, drag = 3 },
	Inferno   = { tex = FIRE,  accel = Vector3.new(0, 14, 0), spread = 15,  light = 1.0, rot = 0,   sizeMul = 1.6, drag = 0 },
	Stardust  = { tex = SPARK, accel = Vector3.zero,          spread = 180, light = 1.0, rot = 90,  sizeMul = 0.35,drag = 0 },
	Halo      = { tex = SMOKE, accel = Vector3.zero,          spread = 0,   light = 1.0, rot = 60,  sizeMul = 1.2, drag = 0 },
	Storm     = { tex = SMOKE, accel = Vector3.new(0, 2, 0),  spread = 140, light = 0.3, rot = 30,  sizeMul = 2.0, drag = 1 },
	Pixels    = { tex = BLANK, accel = Vector3.zero,          spread = 180, light = 0.9, rot = 45,  sizeMul = 0.6, drag = 1 },
	Dot       = { tex = SMOKE, accel = Vector3.zero,          spread = 0,   light = 0.2, rot = 0,   sizeMul = 0.5, drag = 0 },
	NeutralDot= { tex = SMOKE, accel = Vector3.zero,          spread = 0,   light = 0.0, rot = 0,   sizeMul = 0.4, drag = 5 },
}
local PA_ORDER = {
	"Dot", "NeutralDot", "Glow", "Sparkles", "Smoke", "Stars", "Fire", "Embers", "Snow",
	"Magic", "Bubbles", "Confetti", "Nebula", "Inferno", "Stardust", "Halo", "Storm", "Pixels",
}
local PA_MOTION = { "Off", "Orbit", "Spiral Up", "Spiral Down", "Helix", "Wave", "Fountain", "DNA" }

local paEnabled = paSec:Toggle({ Name = "Enabled", Default = false, Flag = "pa_enabled" })
local paPreset  = paSec:Dropdown({ Name = "Preset", Items = PA_ORDER, Default = "Glow", Flag = "pa_preset" })
local paMotion  = paSec:Dropdown({ Name = "Motion", Items = PA_MOTION, Default = "Orbit", Flag = "pa_motion" })
local paColor   = newColorpicker(paSec, { Name = "Color",   Default = Color3.fromRGB(120, 170, 255), Alpha = 1, Flag = "pa_color" })
local paColor2  = newColorpicker(paSec, { Name = "Color 2", Default = Color3.fromRGB(190, 120, 255), Alpha = 1, Flag = "pa_color2" })

local paSettings = settingsOf(paSec, paEnabled)
local paRate    = paSettings:Slider({ Name = "Rate", Min = 1, Max = 300, Step = 1, Default = 40, Suffix = "/s", Flag = "pa_rate" })
local paSize    = paSettings:Slider({ Name = "Size", Min = 10, Max = 400, Step = 10, Default = 100, Suffix = "%", Flag = "pa_size" })
local paSpeed   = paSettings:Slider({ Name = "Speed", Min = 0, Max = 100, Step = 5, Default = 30, Suffix = "%", Flag = "pa_speed" })
local paSpin    = paSettings:Slider({ Name = "Spin", Min = 0, Max = 300, Step = 10, Default = 100, Suffix = "%", Flag = "pa_spin" })
local paLife    = paSettings:Slider({ Name = "Lifetime", Min = 20, Max = 400, Step = 10, Default = 100, Suffix = "cs", Flag = "pa_life" })
local paGlow    = paSettings:Toggle({ Name = "Glow", Default = true, Flag = "pa_glow" })
local paLocked  = paSettings:Toggle({ Name = "Glue to you (no gravity drift)", Default = true, Flag = "pa_locked" })
local paRadius  = paSettings:Slider({ Name = "Motion radius", Min = 0, Max = 200, Step = 5, Default = 50, Suffix = "%", Flag = "pa_radius" })
local paOrbit   = paSettings:Slider({ Name = "Motion speed", Min = -200, Max = 200, Step = 5, Default = 40, Suffix = "%", Flag = "pa_orbit" })
local paSpan    = paSettings:Slider({ Name = "Pattern height", Min = 0, Max = 250, Step = 5, Default = 60, Suffix = "%", Flag = "pa_span" })
local paHeight  = paSettings:Slider({ Name = "Height", Min = -100, Max = 100, Step = 5, Default = 0, Suffix = "%", Flag = "pa_height" })
local paReactive = paSettings:Toggle({ Name = "React to speed", Default = false, Flag = "pa_reactive" })
local paReactAmt = paSettings:Slider({ Name = "Reactivity", Min = 0, Max = 200, Step = 10, Default = 100, Suffix = "%", Flag = "pa_react_amt" })

local RING_N = 10
local loadedPreset = ""
local curPreset: Preset = PA_PRESETS.Glow
local lastPaSig = ""
local lastTrailSig = ""
local paSpeedMul = 1

local function presetFor(name: string): (Preset, string)
	if PA_PRESETS[name] then return PA_PRESETS[name], PA_PRESETS[name].tex end
	local base = string.gsub(name, " %(web%)$", "")
	local id = resolveRepoAsset("auras/" .. base .. ".png")
	local p = table.clone(PA_PRESETS.Glow)
	p.tex = id or PA_PRESETS.Glow.tex
	return p, p.tex
end

local auraFolder = Instance.new("Folder")
auraFolder.Name = "MisanthropyAura"
auraFolder.Parent = Workspace

local auraFollower = Instance.new("Part")
auraFollower.Name = "AuraFollower"
auraFollower.Anchored = true
auraFollower.CanCollide = false
auraFollower.CanQuery = false
auraFollower.CanTouch = false
auraFollower.Massless = true
auraFollower.Transparency = 1
auraFollower.Size = Vector3.new(0.1, 0.1, 0.1)
auraFollower.Parent = auraFolder

local function newEmitter(parent: Attachment): ParticleEmitter
	local e = Instance.new("ParticleEmitter")
	e.Name = "MisanthropyAura"; e.Enabled = false; e.LightInfluence = 0; e.Parent = parent
	return e
end

local paCenterAtt: Attachment
local paCenterEmitter: ParticleEmitter
local paRing: { { att: Attachment, emitter: ParticleEmitter } } = {}
local forcePaRestyle = false

local function buildAura()
	if paCenterEmitter then paCenterEmitter:Destroy() end
	if paCenterAtt then paCenterAtt:Destroy() end
	for _, r in ipairs(paRing) do r.emitter:Destroy(); r.att:Destroy() end
	table.clear(paRing)

	paCenterAtt = Instance.new("Attachment"); paCenterAtt.Name = "MisAuraAtt"; paCenterAtt.Parent = auraFollower
	paCenterEmitter = newEmitter(paCenterAtt)

	for i = 1, RING_N do
		local a = Instance.new("Attachment"); a.Name = "MisRing" .. i; a.Parent = auraFollower
		paRing[i] = { att = a, emitter = newEmitter(a) }
	end
end
buildAura()

auraFollower.ChildRemoved:Connect(function()
	task.defer(function()
		if not (paCenterEmitter and paCenterEmitter.Parent) then
			buildAura()
			forcePaRestyle = true
		end
	end)
end)

local function styleEmitter(e: ParticleEmitter)
	local p = curPreset
	e.Texture = p.tex
	e.SpreadAngle = Vector2.new(p.spread, p.spread)
	e.LockedToPart = paLocked:Get()
	e.Acceleration = paLocked:Get() and Vector3.zero or p.accel
	e.Drag = p.drag
	local pc1 = paColor:Get()
	local pc2 = paColor2:Get()
	e.Color = ColorSequence.new(pc1, pc2)
	e.Rate = paRate:Get() * paSpeedMul
	e.LightEmission = paGlow:Get() and p.light or 0
	local s = (paSize:Get() / 100) * p.sizeMul * paSpeedMul
	e.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, s * 0.5),
		NumberSequenceKeypoint.new(0.4, s),
		NumberSequenceKeypoint.new(1, s * 0.2),
	})
	local sp = paSpeed:Get() / 100 * 10
	e.Speed = NumberRange.new(sp * 0.4, sp)
	local rs = p.rot * (paSpin:Get() / 100)
	e.RotSpeed = NumberRange.new(-rs, rs)
	e.Rotation = NumberRange.new(0, 360)
	e.Lifetime = NumberRange.new(paLife:Get() / 100)
	e.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.2, 0.1),
		NumberSequenceKeypoint.new(1, 1),
	})
end

local TWO_PI = math.pi * 2
local function patternPos(mode: string, i: number, n: number, t: number, radius: number, span: number, baseY: number): Vector3
	local frac = (i - 1) / n
	if mode == "Orbit" then
		local a = frac * TWO_PI + t
		return Vector3.new(math.cos(a) * radius, baseY, math.sin(a) * radius)
	elseif mode == "Spiral Up" or mode == "Spiral Down" then
		local prog = (frac + t * 0.15) % 1
		local a = prog * TWO_PI * 3
		local y = (prog - 0.5) * span
		if mode == "Spiral Down" then y = -y end
		return Vector3.new(math.cos(a) * radius, baseY + y, math.sin(a) * radius)
	elseif mode == "Helix" then
		local a = frac * TWO_PI + t
		local y = math.sin(frac * TWO_PI * 2 + t) * span * 0.5
		return Vector3.new(math.cos(a) * radius, baseY + y, math.sin(a) * radius)
	elseif mode == "Wave" then
		local a = frac * TWO_PI
		local y = math.sin(a * 3 + t) * span * 0.5
		return Vector3.new(math.cos(a) * radius, baseY + y, math.sin(a) * radius)
	elseif mode == "Fountain" then
		local a = frac * TWO_PI
		local y = ((frac + t * 0.3) % 1) * span - span * 0.5
		return Vector3.new(math.cos(a) * radius * 0.25, baseY + y, math.sin(a) * radius * 0.25)
	elseif mode == "DNA" then
		local strand = (i % 2 == 0) and math.pi or 0
		local prog = (frac + t * 0.15) % 1
		local a = prog * TWO_PI * 3 + strand
		local y = (prog - 0.5) * span
		return Vector3.new(math.cos(a) * radius, baseY + y, math.sin(a) * radius)
	end
	return Vector3.new(0, baseY, 0)
end

local acc = 0
local orbitAngle = 0
local rs2 = RunService.RenderStepped:Connect(function(dt: number)
	local root = getRootPart()
	local trSpeedMul = 1
	if trReactive:Get() and root then
		trSpeedMul = 1 + (getHorizontalSpeed(root) / 16) * (trReactAmt:Get() / 100)
	end
	if trail and att0 and att1 then
		if root and trEnabled:Get() then
			local center = (trPos:Get() / 100) * 5 - 2.5
			trailFollower.CFrame = root.CFrame
			att0.Position = Vector3.new(0, center + 0.6, 0)
			att1.Position = Vector3.new(0, center - 0.6, 0)
			trail.Enabled = true

			if trRainbow:Get() then
				local hue = ((os.clock() * (trRbSpeed:Get() / 100) * 0.15)) % 1
				local c = Color3.fromHSV(hue, 0.9, 1)
				trail.Color = ColorSequence.new(c, Color3.fromHSV((hue + 0.1) % 1, 0.9, 1))
			end
		else
			trail.Enabled = false
		end
	end

	if trail then
		local trStyleV = trStyle:Get()
		local trC1 = trColor:Get()
		local trC2 = trColor2:Get()
		local trSig = table.concat({
			trC1:ToHex(), trC2:ToHex(), trWidth:Get(), trLen:Get(),
			trStyleV, trTrans:Get(), trGlow:Get(), tostring(trRainbow:Get()),
			math.floor(trSpeedMul * 20),
		}, "|")
		if trSig ~= lastTrailSig or forceTrailRestyle then
			lastTrailSig = trSig
			forceTrailRestyle = false
			local w = (trWidth:Get() / 100) * trSpeedMul
			local startT = trTrans:Get() / 100
			if trStyleV == "Solid" or trStyleV == "Ribbon" then
				trail.WidthScale = NumberSequence.new(w)
			else
				trail.WidthScale = NumberSequence.new({
					NumberSequenceKeypoint.new(0, w),
					NumberSequenceKeypoint.new(1, 0),
				})
			end
			local endT = (trStyleV == "Solid") and startT or 1
			if trStyleV == "Comet" then endT = 1; startT = math.max(startT, 0.05) end
			trail.Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, startT),
				NumberSequenceKeypoint.new(1, endT),
			})
			trail.Lifetime = 0.2 + (trLen:Get() / 100) * 1.5
			trail.LightEmission = trGlow:Get() / 100
			trail.LightInfluence = (trStyleV == "Ribbon") and 1 or 0
			trail.FaceCamera = trStyleV ~= "Ribbon"
			if not trRainbow:Get() then
				trail.Color = ColorSequence.new(trC1, trC2)
			end
		end
	end

	if not (paCenterEmitter and paCenterEmitter.Parent) then return end

	local on = paEnabled:Get() and root ~= nil
	local motion = paMotion:Get()
	local moving = motion ~= "Off"
	local heightOff = paHeight:Get() / 100 * 3
	paSpeedMul = 1
	if paReactive:Get() and root then
		paSpeedMul = 1 + (getHorizontalSpeed(root) / 16) * (paReactAmt:Get() / 100)
	end

	if root then
		auraFollower.CFrame = root.CFrame
	end

	orbitAngle += dt * (paOrbit:Get() / 100 * 3)

	if not on then
		paCenterEmitter.Enabled = false
		for _, r in ipairs(paRing) do r.emitter.Enabled = false end
	elseif moving then
		paCenterEmitter.Enabled = false
		local radius = paRadius:Get() / 100 * 6
		local span = paSpan:Get() / 100 * 6
		for i, r in ipairs(paRing) do
			r.att.Position = patternPos(motion, i, RING_N, orbitAngle, radius, span, heightOff)
			r.emitter.Enabled = true
		end
	else
		for _, r in ipairs(paRing) do r.emitter.Enabled = false end
		paCenterAtt.Position = Vector3.new(0, heightOff, 0)
		paCenterEmitter.Enabled = true
	end

	acc += dt
	if acc < 0.066 then return end
	acc = 0

	if not on then return end
	local name = paPreset:Get()
	if name ~= loadedPreset then loadedPreset = name; curPreset = presetFor(name) end

	local pc1 = paColor:Get()
	local pc2 = paColor2:Get()
	local paSig = table.concat({
		motion, name, pc1:ToHex(), pc2:ToHex(),
		paRate:Get(), paSize:Get(), paSpeed:Get(), paSpin:Get(),
		paLife:Get(), tostring(paGlow:Get()), tostring(paLocked:Get()),
		math.floor(paSpeedMul * 20),
	}, "|")
	if paSig ~= lastPaSig or forcePaRestyle then
		lastPaSig = paSig
		forcePaRestyle = false
		if moving then
			for _, r in ipairs(paRing) do styleEmitter(r.emitter) end
		else
			styleEmitter(paCenterEmitter)
		end
	end
end)
table.insert(cleanups, function() rs2:Disconnect() end)
table.insert(cleanups, function() if trailFolder then trailFolder:Destroy() end end)
table.insert(cleanups, function() if auraFolder then auraFolder:Destroy() end end)

CFG.toggles.tr_enabled = trEnabled; CFG.toggles.tr_rainbow = trRainbow; CFG.toggles.tr_reactive = trReactive
CFG.toggles.pa_enabled = paEnabled; CFG.toggles.pa_glow = paGlow; CFG.toggles.pa_locked = paLocked
CFG.toggles.pa_reactive = paReactive
CFG.sliders.tr_width = trWidth; CFG.sliders.tr_len = trLen; CFG.sliders.tr_pos = trPos
CFG.sliders.tr_trans = trTrans; CFG.sliders.tr_glow = trGlow; CFG.sliders.tr_rbspeed = trRbSpeed
CFG.sliders.tr_react_amt = trReactAmt
CFG.sliders.pa_rate = paRate; CFG.sliders.pa_size = paSize; CFG.sliders.pa_speed = paSpeed
CFG.sliders.pa_spin = paSpin; CFG.sliders.pa_height = paHeight; CFG.sliders.pa_life = paLife
CFG.sliders.pa_radius = paRadius; CFG.sliders.pa_orbit = paOrbit; CFG.sliders.pa_span = paSpan
CFG.sliders.pa_react_amt = paReactAmt
CFG.dropdowns.tr_style = trStyle; CFG.dropdowns.pa_preset = paPreset; CFG.dropdowns.pa_motion = paMotion
CFG.colors.tr_color = trColor; CFG.colors.tr_color2 = trColor2
CFG.colors.pa_color = paColor; CFG.colors.pa_color2 = paColor2

----------------------------------------------------------------------------------
-- SECTION 4: Aura Dots
----------------------------------------------------------------------------------
do
	local adSec = newSection(pgCharacter, "Aura Dots")
	local AD_STYLES = { "Orbit", "Helix", "Pulse", "Static", "Spiral", "Wave", "Bounce", "Vertical",
		"DNA", "Figure8", "Sphere", "Vortex", "Tornado", "Atom", "Rain", "Comet", "Scatter" }
	local AD_SHAPES = { "Ball", "Block", "Diamond", "Cylinder" }
	local AD_MATS   = { "Neon", "ForceField", "Glass", "Plastic" }
	local AD_LINKS  = { "Loop", "Chain", "Star", "Web" }

	local adEnabled = adSec:Toggle({ Name = "Enabled", Default = false, Flag = "ad_enabled" })
	local adStyle   = adSec:Dropdown({ Name = "Style", Items = AD_STYLES, Default = "Orbit", Flag = "ad_style" })
	local adColor   = newColorpicker(adSec, { Name = "Color",   Default = Color3.fromRGB(120, 170, 255), Alpha = 1, Flag = "ad_color" })
	local adColor2  = newColorpicker(adSec, { Name = "Color 2", Default = Color3.fromRGB(190, 120, 255), Alpha = 1, Flag = "ad_color2" })

	local adSettings = settingsOf(adSec, adEnabled)
	local adShape   = adSettings:Dropdown({ Name = "Shape", Items = AD_SHAPES, Default = "Ball", Flag = "ad_shape" })
	local adMat     = adSettings:Dropdown({ Name = "Material", Items = AD_MATS, Default = "Neon", Flag = "ad_mat" })
	local adCount   = adSettings:Slider({ Name = "Count", Min = 1, Max = 24, Step = 1, Default = 6, Flag = "ad_count" })
	local adSize    = adSettings:Slider({ Name = "Size", Min = 5, Max = 200, Step = 5, Default = 40, Suffix = "%", Flag = "ad_size" })
	local adDist    = adSettings:Slider({ Name = "Distance", Min = 0, Max = 250, Step = 5, Default = 50, Suffix = "%", Flag = "ad_dist" })
	local adSpan    = adSettings:Slider({ Name = "Vertical span", Min = 0, Max = 250, Step = 5, Default = 60, Suffix = "%", Flag = "ad_span" })
	local adHeight  = adSettings:Slider({ Name = "Height", Min = -150, Max = 150, Step = 5, Default = 0, Suffix = "%", Flag = "ad_height" })
	local adSpeed   = adSettings:Slider({ Name = "Speed", Min = -300, Max = 300, Step = 5, Default = 50, Suffix = "%", Flag = "ad_speed" })
	local adSpin    = adSettings:Slider({ Name = "Self-spin", Min = 0, Max = 300, Step = 10, Default = 0, Suffix = "%", Flag = "ad_spin" })
	local adTilt    = adSettings:Slider({ Name = "Tilt", Min = -90, Max = 90, Step = 5, Default = 0, Suffix = "°", Flag = "ad_tilt" })
	local adWobble  = adSettings:Slider({ Name = "Wobble", Min = 0, Max = 100, Step = 5, Default = 0, Suffix = "%", Flag = "ad_wobble" })
	local adRainbow = adSettings:Toggle({ Name = "Rainbow", Default = false, Flag = "ad_rainbow" })
	local adRbSpeed = adSettings:Slider({ Name = "Rainbow speed", Min = 5, Max = 200, Step = 5, Default = 50, Suffix = "%", Flag = "ad_rbspeed" })
	local adBreathe = adSettings:Toggle({ Name = "Breathe (pulse size)", Default = false, Flag = "ad_breathe" })
	local adLight   = adSettings:Toggle({ Name = "Glow light", Default = false, Flag = "ad_light" })
	local adTrail   = adSettings:Toggle({ Name = "Orb trails", Default = false, Flag = "ad_trail" })
	local adTrailLen= adSettings:Slider({ Name = "Trail length", Min = 5, Max = 100, Step = 5, Default = 40, Suffix = "%", Flag = "ad_trail_len" })
	local adConnect   = adSettings:Toggle({ Name = "Connect dots (beams)", Default = false, Flag = "ad_connect" })
	local adLinkMode  = adSettings:Dropdown({ Name = "Link mode", Items = AD_LINKS, Default = "Loop", Flag = "ad_link_mode" })
	local adBeamWidth = adSettings:Slider({ Name = "Beam width", Min = 5, Max = 200, Step = 5, Default = 30, Suffix = "%", Flag = "ad_beam_w" })
	local adBeamTrans = adSettings:Slider({ Name = "Beam transparency", Min = 0, Max = 90, Step = 5, Default = 0, Suffix = "%", Flag = "ad_beam_t" })
	local adBeamCurve = adSettings:Slider({ Name = "Beam curve", Min = -100, Max = 100, Step = 5, Default = 0, Suffix = "%", Flag = "ad_beam_c" })
	local adBeamGlow  = adSettings:Slider({ Name = "Beam glow", Min = 0, Max = 100, Step = 5, Default = 50, Suffix = "%", Flag = "ad_beam_g" })
	local adBeamMax   = adSettings:Slider({ Name = "Max link length (0 = infinite)", Min = 0, Max = 100, Step = 5, Default = 50, Suffix = "%", Flag = "ad_beam_max" })
	local adBeamColor = newColorpicker(adSettings, { Name = "Beam color", Default = Color3.fromRGB(255, 255, 255), Alpha = 1, Flag = "ad_beam_col" })
	local adBeamMatch = adSettings:Toggle({ Name = "Beam uses orb colors", Default = true, Flag = "ad_beam_match" })

	local AD_MAX = 24
	local AD_TAU = math.pi * 2
	local dotsFolder = Instance.new("Folder"); dotsFolder.Name = "MisanthropyAuraDots"; dotsFolder.Parent = Workspace

	type Dot = { part: Part, center: Attachment, trail: Trail, light: PointLight }
	local dots: { Dot } = {}
	local beams: { Beam } = {}
	for _ = 1, AD_MAX do
		local p = Instance.new("Part")
		p.Shape = Enum.PartType.Ball; p.Material = Enum.Material.Neon
		p.Anchored = true; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false; p.Massless = true
		p.Size = Vector3.one; p.Transparency = 1; p.Parent = dotsFolder
		local center = Instance.new("Attachment"); center.Name = "C"; center.Parent = p
		local ta0 = Instance.new("Attachment"); ta0.Position = Vector3.new(0, 0.2, 0); ta0.Parent = p
		local ta1 = Instance.new("Attachment"); ta1.Position = Vector3.new(0, -0.2, 0); ta1.Parent = p
		local tr = Instance.new("Trail"); tr.Attachment0 = ta0; tr.Attachment1 = ta1
		tr.Enabled = false; tr.Lifetime = 0.4; tr.FaceCamera = true; tr.Parent = p
		local lt = Instance.new("PointLight"); lt.Enabled = false; lt.Range = 8; lt.Brightness = 2; lt.Parent = p
		table.insert(dots, { part = p, center = center, trail = tr, light = lt })
	end
	local AD_BEAMS = AD_MAX * 2
	for _ = 1, AD_BEAMS do
		local b = Instance.new("Beam"); b.Enabled = false; b.FaceCamera = true; b.Segments = 6
		b.Width0 = 0.1; b.Width1 = 0.1; b.Parent = dotsFolder
		table.insert(beams, b)
	end

	local hubPart = Instance.new("Part")
	hubPart.Anchored = true; hubPart.CanCollide = false; hubPart.CanQuery = false; hubPart.CanTouch = false
	hubPart.Transparency = 1; hubPart.Size = Vector3.one * 0.1; hubPart.Parent = dotsFolder
	local hubAtt = Instance.new("Attachment"); hubAtt.Name = "Hub"; hubAtt.Parent = hubPart

	local SHAPE_MAP = { Ball = Enum.PartType.Ball, Block = Enum.PartType.Block, Diamond = Enum.PartType.Block, Cylinder = Enum.PartType.Cylinder }
	local MAT_MAP = { Neon = Enum.Material.Neon, ForceField = Enum.Material.ForceField, Glass = Enum.Material.Glass, Plastic = Enum.Material.SmoothPlastic }

	local function hash01(n: number): number
		local x = math.sin(n * 127.1) * 43758.5453
		return x - math.floor(x)
	end

	local function dotOffset(style: string, i: number, count: number, t: number, r: number, span: number): Vector3
		local frac = count > 1 and (i - 1) / count or 0
		local a = frac * AD_TAU
		if style == "Helix" then
			a += t; return Vector3.new(math.cos(a) * r, math.sin(frac * AD_TAU * 2 + t) * span * 0.5, math.sin(a) * r)
		elseif style == "Pulse" then
			a += t; local rr = r * (0.6 + 0.4 * math.sin(t * 2)); return Vector3.new(math.cos(a) * rr, 0, math.sin(a) * rr)
		elseif style == "Static" then
			return Vector3.new(math.cos(a) * r, 0, math.sin(a) * r)
		elseif style == "Spiral" then
			local prog = (frac + t * 0.1) % 1; local aa = prog * AD_TAU * 2; local y = (prog - 0.5) * span * 2
			return Vector3.new(math.cos(aa) * r, y, math.sin(aa) * r)
		elseif style == "Wave" then
			local y = math.sin(a * 3 + t) * span * 0.5; return Vector3.new(math.cos(a) * r, y, math.sin(a) * r)
		elseif style == "Bounce" then
			a += t; local y = math.abs(math.sin(t)) * span; return Vector3.new(math.cos(a) * r, y, math.sin(a) * r)
		elseif style == "Vertical" then
			local y = (frac - 0.5) * span * 2; return Vector3.new(math.cos(t) * r * 0.3, y, math.sin(t) * r * 0.3)
		elseif style == "DNA" then
			local strand = (i % 2 == 0) and math.pi or 0; local prog = (frac + t * 0.1) % 1
			local aa = prog * AD_TAU * 2 + strand; local y = (prog - 0.5) * span * 2
			return Vector3.new(math.cos(aa) * r, y, math.sin(aa) * r)
		elseif style == "Figure8" then
			local aa = a + t; return Vector3.new(math.cos(aa) * r, math.sin(aa * 2) * span * 0.5, math.sin(aa * 2) * r * 0.5)
		elseif style == "Sphere" then
			local k = (i - 0.5) / count; local phi = math.acos(1 - 2 * k); local theta = AD_TAU * 1.618 * i + t
			return Vector3.new(math.sin(phi) * math.cos(theta) * r, math.cos(phi) * r, math.sin(phi) * math.sin(theta) * r)
		elseif style == "Vortex" then
			local aa = frac * AD_TAU * 2 + t; local rr = r * (0.25 + 0.75 * frac); local y = (frac - 0.5) * span
			return Vector3.new(math.cos(aa) * rr, y, math.sin(aa) * rr)
		elseif style == "Tornado" then
			local aa = frac * AD_TAU * 3 + t * 1.5; local rr = r * (0.15 + 0.85 * frac); local y = (frac - 0.5) * span * 2
			return Vector3.new(math.cos(aa) * rr, y, math.sin(aa) * rr)
		elseif style == "Atom" then
			local plane = i % 3; local aa = frac * AD_TAU * 2 + t
			local v = Vector3.new(math.cos(aa) * r, math.sin(aa) * r, 0)
			if plane == 1 then v = CFrame.Angles(0, math.rad(60), 0):VectorToWorldSpace(v)
			elseif plane == 2 then v = CFrame.Angles(math.rad(60), 0, 0):VectorToWorldSpace(v) end
			return v
		elseif style == "Rain" then
			local fall = (frac - t * 0.25) % 1
			local ax = (hash01(i) - 0.5) * 2 * r
			local az = (hash01(i + 99) - 0.5) * 2 * r
			return Vector3.new(ax, (fall - 0.5) * span * 2, az)
		elseif style == "Comet" then
			local aa = t - frac * 0.5
			return Vector3.new(math.cos(aa) * r, math.sin(frac * 2) * span * 0.2, math.sin(aa) * r)
		elseif style == "Scatter" then
			local theta = hash01(i) * AD_TAU + t * 0.2
			local phi = math.acos(2 * hash01(i + 50) - 1)
			local rr = r * (0.6 + 0.4 * hash01(i + 7))
			return Vector3.new(math.sin(phi) * math.cos(theta) * rr, math.cos(phi) * rr, math.sin(phi) * math.sin(theta) * rr)
		end
		a += t; return Vector3.new(math.cos(a) * r, 0, math.sin(a) * r)
	end

	local adAngle = 0
	local adAcc = 0
	local lastAdSig = ""
	local function fadeTo(p: Part, target: number, alpha: number)
		p.Transparency = p.Transparency + (target - p.Transparency) * alpha
	end
	local rs3 = RunService.RenderStepped:Connect(function(dt: number)
		local fadeA = math.min(dt * 14, 1)
		local root = adEnabled:Get() and getRootPart() or nil
		if not root then
			for _, d in ipairs(dots) do
				fadeTo(d.part, 1, fadeA)
				if d.part.Transparency > 0.95 then d.trail.Enabled = false; d.light.Enabled = false end
			end
			for _, b in ipairs(beams) do b.Enabled = false end
			return
		end

		local count = math.floor(adCount:Get())
		local r = adDist:Get() / 100 * 6
		local span = adSpan:Get() / 100 * 6
		local style = adStyle:Get()
		local spin = adSpin:Get() / 100
		local connect = adConnect:Get()
		local trailsOn = adTrail:Get()
		local lightsOn = adLight:Get()
		local rainbow = adRainbow:Get()
		local breathe = adBreathe:Get()
		local tilt = adTilt:Get()
		local wob = adWobble:Get() / 100 * 2
		adAngle += dt * (adSpeed:Get() / 100 * 2)
		local base = root.Position + Vector3.new(0, adHeight:Get() / 100 * 4, 0)
		local tiltCF = tilt ~= 0 and CFrame.Angles(math.rad(tilt), 0, 0) or nil

		local clock = os.clock()
		local sBase = adSize:Get() / 100
		local diamond = adShape:Get() == "Diamond"
		local breatheMul = breathe and (1 + 0.25 * math.sin(clock * 4)) or 1

		for i, d in ipairs(dots) do
			if i > count then
				fadeTo(d.part, 1, fadeA)
				if d.part.Transparency > 0.95 then d.trail.Enabled = false; d.light.Enabled = false end
			else
				local frac = count > 1 and (i - 1) / count or 0
				local off = dotOffset(style, i, count, adAngle, r, span)
				if wob > 0 then off += Vector3.new(0, math.sin(adAngle * 2 + frac * AD_TAU) * wob, 0) end
				if tiltCF then off = tiltCF:VectorToWorldSpace(off) end
				local cf = CFrame.new(base + off)
				if spin > 0 then cf = cf * CFrame.Angles(adAngle * spin, adAngle * spin, 0) end
				d.part.CFrame = cf
				fadeTo(d.part, 0, fadeA)
				d.trail.Enabled = trailsOn
				d.light.Enabled = lightsOn

				if rainbow then
					local hue = ((clock * (adRbSpeed:Get() / 100) * 0.15) + frac) % 1
					local col = Color3.fromHSV(hue, 0.9, 1)
					d.part.Color = col; d.light.Color = col; d.trail.Color = ColorSequence.new(col)
				end
				if breathe then
					local s = sBase * breatheMul
					d.part.Size = diamond and Vector3.new(s, s * 1.6, s) or Vector3.one * s
				end
			end
		end

		local linkMode = adLinkMode:Get()
		hubPart.Position = base
		local used = 0
		if connect and count >= 2 then
			local maxV = adBeamMax:Get()
			local maxStud = maxV > 0 and (maxV / 100 * 30) or math.huge
			local function link(aAtt: Attachment, bAtt: Attachment)
				if (aAtt.WorldPosition - bAtt.WorldPosition).Magnitude > maxStud then return end
				used += 1
				local b = beams[used]
				if b then b.Attachment0 = aAtt; b.Attachment1 = bAtt; b.Enabled = true end
			end
			if linkMode == "Chain" then
				for i = 1, count - 1 do link(dots[i].center, dots[i + 1].center) end
			elseif linkMode == "Star" then
				for i = 1, count do link(hubAtt, dots[i].center) end
			elseif linkMode == "Web" then
				for i = 1, count do
					link(dots[i].center, dots[(i % count) + 1].center)
					if used < #beams then link(dots[i].center, dots[((i + 1) % count) + 1].center) end
				end
			else
				for i = 1, count do link(dots[i].center, dots[(i % count) + 1].center) end
			end
		end
		for i = used + 1, #beams do beams[i].Enabled = false end

		adAcc += dt
		if adAcc < 0.1 then return end
		adAcc = 0
		local adC1 = adColor:Get()
		local adC2 = adColor2:Get()
		local adBc = adBeamColor:Get()
		local adSig = table.concat({
			count, adSize:Get(), adShape:Get(), adMat:Get(),
			adC1:ToHex(), adC2:ToHex(),
			tostring(rainbow), tostring(breathe), tostring(lightsOn), adTrailLen:Get(),
			adBeamWidth:Get(), adBeamTrans:Get(), adBeamCurve:Get(), adBeamGlow:Get(),
			adBc:ToHex(), tostring(adBeamMatch:Get()),
		}, "|")
		if adSig == lastAdSig then return end
		lastAdSig = adSig
		local s = sBase
		local c1, c2 = adC1, adC2
		local shape = SHAPE_MAP[adShape:Get()] or Enum.PartType.Ball
		local mat = MAT_MAP[adMat:Get()] or Enum.Material.Neon
		local trLife = 0.1 + adTrailLen:Get() / 100 * 1.2
		for i, d in ipairs(dots) do
			if i <= count then
				local col = c1:Lerp(c2, count > 1 and (i - 1) / (count - 1) or 0)
				local p = d.part
				p.Shape = shape
				p.Material = mat
				if not breathe then p.Size = diamond and Vector3.new(s, s * 1.6, s) or Vector3.one * s end
				if not rainbow then
					p.Color = col; d.light.Color = col; d.trail.Color = ColorSequence.new(col)
				end
				d.trail.Lifetime = trLife
				d.trail.WidthScale = NumberSequence.new(1)
				d.light.Range = 6 + s * 4; d.light.Brightness = 2.5
			end
		end
		local bw = adBeamWidth:Get() / 100
		local bt = adBeamTrans:Get() / 100
		local bc = adBeamCurve:Get() / 100 * 4
		local bg = adBeamGlow:Get() / 100
		local beamMatch = adBeamMatch:Get()
		for i, b in ipairs(beams) do
			if beamMatch then
				local col = c1:Lerp(c2, #beams > 1 and (i - 1) / (#beams - 1) or 0)
				b.Color = ColorSequence.new(col)
			else
				b.Color = ColorSequence.new(adBc)
			end
			b.Width0 = bw; b.Width1 = bw
			b.Transparency = NumberSequence.new(bt)
			b.CurveSize0 = bc; b.CurveSize1 = -bc
			b.LightEmission = bg
		end
	end)
	table.insert(cleanups, function() rs3:Disconnect() end)

	CFG.toggles.ad_enabled = adEnabled; CFG.toggles.ad_trail = adTrail; CFG.toggles.ad_connect = adConnect
	CFG.toggles.ad_rainbow = adRainbow; CFG.toggles.ad_breathe = adBreathe; CFG.toggles.ad_light = adLight
	CFG.toggles.ad_beam_match = adBeamMatch
	CFG.sliders.ad_count = adCount; CFG.sliders.ad_size = adSize; CFG.sliders.ad_dist = adDist
	CFG.sliders.ad_span = adSpan; CFG.sliders.ad_height = adHeight; CFG.sliders.ad_speed = adSpeed
	CFG.sliders.ad_spin = adSpin; CFG.sliders.ad_tilt = adTilt; CFG.sliders.ad_wobble = adWobble
	CFG.sliders.ad_rbspeed = adRbSpeed; CFG.sliders.ad_trail_len = adTrailLen
	CFG.sliders.ad_beam_w = adBeamWidth; CFG.sliders.ad_beam_t = adBeamTrans; CFG.sliders.ad_beam_c = adBeamCurve
	CFG.sliders.ad_beam_g = adBeamGlow; CFG.sliders.ad_beam_max = adBeamMax
	CFG.dropdowns.ad_style = adStyle; CFG.dropdowns.ad_shape = adShape; CFG.dropdowns.ad_mat = adMat
	CFG.dropdowns.ad_link_mode = adLinkMode
	CFG.colors.ad_color = adColor; CFG.colors.ad_color2 = adColor2; CFG.colors.ad_beam_col = adBeamColor
	table.insert(cleanups, function() if dotsFolder then dotsFolder:Destroy() end end)
end

----------------------------------------------------------------------------------
-- SECTION 5: Image
----------------------------------------------------------------------------------
local imageLabel: ImageLabel
local clipText: () -> string?
local loadImageURL: (url: string?) -> ()

do
	local imgSec = newSection(pgPlayer, "Image")
	local IMG_SHOW    = { "Always", "When menu open" }
	local IMG_CORNERS = { "Top Left", "Top Right", "Bottom Left", "Bottom Right" }

	local imgEnabled = imgSec:Toggle({ Name = "Enabled", Default = false, Flag = "img_enabled" })
	local imgSettings = settingsOf(imgSec, imgEnabled)
	local imgShow    = imgSettings:Dropdown({ Name = "Show", Items = IMG_SHOW, Default = "When menu open", Flag = "img_show" })
	local imgCorner  = imgSettings:Dropdown({ Name = "Corner", Items = IMG_CORNERS, Default = "Bottom Right", Flag = "img_corner" })
	local imgSize    = imgSettings:Slider({ Name = "Size", Min = 40, Max = 500, Step = 10, Default = 150, Suffix = "px", Flag = "img_size" })
	local imgTrans   = imgSettings:Slider({ Name = "Transparency", Min = 0, Max = 90, Step = 5, Default = 0, Suffix = "%", Flag = "img_trans" })
	local imgDrag    = imgSettings:Toggle({ Name = "Draggable", Default = false, Flag = "img_drag" })
	local imgRound   = imgSettings:Toggle({ Name = "Rounded corners", Default = true, Flag = "img_round" })
	local imgBorder  = imgSettings:Toggle({ Name = "Border", Default = true, Flag = "img_border" })
	local imgRainbow = imgSettings:Toggle({ Name = "Rainbow border", Default = false, Flag = "img_rainbow" })
	local imgBorderC = newColorpicker(imgSettings, { Name = "Border color", Default = Color3.fromRGB(120, 170, 255), Alpha = 1, Flag = "img_border_col" })
	local imgShadow  = imgSettings:Toggle({ Name = "Drop shadow", Default = true, Flag = "img_shadow" })
	local imgBob     = imgSettings:Toggle({ Name = "Float (bob)", Default = false, Flag = "img_bob" })
	local imgSpin    = imgSettings:Toggle({ Name = "Spin", Default = false, Flag = "img_spin" })
	local imgPulse   = imgSettings:Toggle({ Name = "Pulse", Default = false, Flag = "img_pulse" })
	local imgAnimSpd = imgSettings:Slider({ Name = "Anim speed", Min = 5, Max = 200, Step = 5, Default = 50, Suffix = "%", Flag = "img_anim_spd" })
	imgSettings:Label("Image URL")
	local imgUrlBox = imgSettings:Textbox({ Default = "", Placeholder = "https://...", Flag = "img_url" })
	imgSettings:Button({ Name = "Load typed URL", Callback = function() loadImageURL(imgUrlBox:Get()) end })
	imgSettings:Button({ Name = "Load URL from clipboard", Callback = function() loadImageURL(clipText()) end })
	imgSettings:Button({ Name = "Clear image", Callback = function() imageLabel.Image = "" end })

	local imgHolder = Instance.new("Frame")
	imgHolder.Name = "CustomImage"; imgHolder.BackgroundTransparency = 1; imgHolder.Visible = false
	imgHolder.Size = UDim2.fromOffset(150, 150); imgHolder.Parent = screen
	local imgShadowFrame = Instance.new("Frame")
	imgShadowFrame.Name = "Shadow"; imgShadowFrame.BackgroundColor3 = Color3.new(0, 0, 0)
	imgShadowFrame.BackgroundTransparency = 0.5; imgShadowFrame.BorderSizePixel = 0
	imgShadowFrame.Position = UDim2.fromOffset(5, 6); imgShadowFrame.Size = UDim2.fromScale(1, 1)
	imgShadowFrame.ZIndex = 1; imgShadowFrame.Parent = imgHolder
	local imgShadowCorner = Instance.new("UICorner"); imgShadowCorner.Parent = imgShadowFrame
	imageLabel = Instance.new("ImageLabel")
	imageLabel.Name = "Img"; imageLabel.BackgroundTransparency = 1; imageLabel.Size = UDim2.fromScale(1, 1)
	imageLabel.ScaleType = Enum.ScaleType.Fit; imageLabel.ZIndex = 2; imageLabel.Parent = imgHolder
	local imgCornerUI = Instance.new("UICorner"); imgCornerUI.Parent = imageLabel
	local imgStroke = Instance.new("UIStroke"); imgStroke.Thickness = 2; imgStroke.Parent = imageLabel
	local imgStrokeGrad = Instance.new("UIGradient"); imgStrokeGrad.Parent = imgStroke
	imageLabel.Active = true; imgHolder.Active = true

	local imgPosX, imgPosY = 120, 120
	do
		local s = loadString("img_pos.txt")
		if s then local x, y = string.match(s, "^(-?%d+),(-?%d+)$"); if x then imgPosX = tonumber(x) :: number; imgPosY = tonumber(y) :: number end end
	end
	do
		local dragging, sx, sy, ox, oy = false, 0, 0, 0, 0
		local c1 = imageLabel.InputBegan:Connect(function(input)
			if not imgDrag:Get() then return end
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true; sx = input.Position.X; sy = input.Position.Y; ox = imgPosX; oy = imgPosY
			end
		end)
		local c2 = UserInputService.InputChanged:Connect(function(input)
			if not dragging then return end
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				imgPosX = ox + (input.Position.X - sx); imgPosY = oy + (input.Position.Y - sy)
			end
		end)
		local c3 = UserInputService.InputEnded:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
				dragging = false; saveString("img_pos.txt", string.format("%d,%d", imgPosX, imgPosY))
			end
		end)
		table.insert(cleanups, function() c1:Disconnect(); c2:Disconnect(); c3:Disconnect() end)
	end

	local _getclip = (getclipboard or get_clipboard or (Clipboard and Clipboard.get) or readclipboard) :: any
	clipText = function(): string?
		if not _getclip then return nil end
		local ok, v = pcall(_getclip)
		return ok and v or nil
	end
	local function hashStr(s: string): number
		local h = 5381
		for i = 1, #s do h = (h * 33 + string.byte(s, i)) % 2147483647 end
		return h
	end
	loadImageURL = function(url: string?)
		if not url or not string.match(url, "^https?://") then
			notify("Image", "No http(s) URL on clipboard."); return
		end
		if not CAN_DL then notify("Image", "Executor has no file API."); return end
		task.spawn(function()
			local path = ROOT .. "/images/img_" .. hashStr(url) .. ".png"
			if not _isfile(path) then
				local data = httpGetBinary(url)
				if not data then notify("Image", "Download failed."); return end
				ensureDir(ROOT .. "/images")
				if not pcall(_writefile, path, data) then notify("Image", "Save failed."); return end
			end
			local ok, id = pcall(_getasset, path)
			if ok and id then
				imageLabel.Image = id
				saveString("image_url.txt", url)
			else
				notify("Image", "Could not load asset.")
			end
		end)
	end

	do
		local saved = loadString("image_url.txt")
		if saved then loadImageURL(saved) end
	end

	local CORNER_ANCHOR = {
		["Top Left"] = { anchor = Vector2.new(0, 0), pos = function() return UDim2.fromOffset(16, 16) end },
		["Top Right"] = { anchor = Vector2.new(1, 0), pos = function() local vp = Workspace.CurrentCamera.ViewportSize; return UDim2.fromOffset(vp.X - 16, 16) end },
		["Bottom Left"] = { anchor = Vector2.new(0, 1), pos = function() local vp = Workspace.CurrentCamera.ViewportSize; return UDim2.fromOffset(16, vp.Y - 16) end },
		["Bottom Right"] = { anchor = Vector2.new(1, 1), pos = function() local vp = Workspace.CurrentCamera.ViewportSize; return UDim2.fromOffset(vp.X - 16, vp.Y - 16) end },
	}

	local imgClock = 0
	local rs4 = RunService.RenderStepped:Connect(function(dt: number)
		local on = imgEnabled:Get() and imageLabel.Image ~= ""
		imgHolder.Visible = on
		if not on then return end

		imgClock += dt * (imgAnimSpd:Get() / 100)
		local size = imgSize:Get()
		imgHolder.Size = UDim2.fromOffset(size, size)

		if imgDrag:Get() then
			imgHolder.AnchorPoint = Vector2.zero
			imgHolder.Position = UDim2.fromOffset(imgPosX, imgPosY)
		else
			local corner = CORNER_ANCHOR[imgCorner:Get()] or CORNER_ANCHOR["Bottom Right"]
			imgHolder.AnchorPoint = corner.anchor
			imgHolder.Position = corner.pos()
		end

		if imgBob:Get() then
			imgHolder.Position = imgHolder.Position + UDim2.fromOffset(0, math.sin(imgClock * 2) * 6)
		end
		if imgSpin:Get() then
			imageLabel.Rotation = (imgClock * 40) % 360
		else
			imageLabel.Rotation = 0
		end
		local pulseScale = imgPulse:Get() and (1 + 0.06 * math.sin(imgClock * 3)) or 1

		imageLabel.ImageTransparency = imgTrans:Get() / 100
		imgShadowFrame.Visible = imgShadow:Get()
		imgCornerUI.CornerRadius = imgRound:Get() and UDim.new(0, 10) or UDim.new(0, 0)
		imgShadowCorner.CornerRadius = imgCornerUI.CornerRadius

		imgStroke.Enabled = imgBorder:Get()
		if imgRainbow:Get() then
			imgStrokeGrad.Enabled = true
			local hue = (imgClock * 0.15) % 1
			imgStrokeGrad.Color = ColorSequence.new(Color3.fromHSV(hue, 0.9, 1), Color3.fromHSV((hue + 0.3) % 1, 0.9, 1))
		else
			imgStrokeGrad.Enabled = false
			imgStroke.Color = imgBorderC:Get()
		end

		imageLabel.Size = UDim2.fromScale(pulseScale, pulseScale)
	end)
	table.insert(cleanups, function() rs4:Disconnect() end)

	CFG.toggles.img_enabled = imgEnabled; CFG.toggles.img_drag = imgDrag; CFG.toggles.img_round = imgRound
	CFG.toggles.img_border = imgBorder; CFG.toggles.img_rainbow = imgRainbow; CFG.toggles.img_shadow = imgShadow
	CFG.toggles.img_bob = imgBob; CFG.toggles.img_spin = imgSpin; CFG.toggles.img_pulse = imgPulse
	CFG.sliders.img_size = imgSize; CFG.sliders.img_trans = imgTrans; CFG.sliders.img_anim_spd = imgAnimSpd
	CFG.dropdowns.img_show = imgShow; CFG.dropdowns.img_corner = imgCorner
	CFG.colors.img_border_col = imgBorderC
end

----------------------------------------------------------------------------------
-- SECTION 5b: Footsteps (client-side footstep visualizer for your own character)
----------------------------------------------------------------------------------
do
	local fsSec = newSection(pgPlayer, "Footsteps")

	local FS_SHAPES = { "Square", "Solid Square", "Circle", "Triangle", "Star", "Diamond", "Chevron" }

	local fsEnabled = fsSec:Toggle({ Name = "Enabled", Default = false, Flag = "fs_enabled" })
	local fsShape   = fsSec:Dropdown({ Name = "Shape", Items = FS_SHAPES, Default = "Square", Flag = "fs_shape" })
	local fsColor   = newColorpicker(fsSec, { Name = "Color", Default = Color3.fromRGB(120, 170, 255), Alpha = 1, Flag = "fs_color" })

	local fsSettings = settingsOf(fsSec, fsEnabled)
	local fsSize    = fsSettings:Slider({ Name = "Size", Min = 20, Max = 300, Step = 5, Default = 100, Suffix = "%", Flag = "fs_size" })
	local fsFade    = fsSettings:Slider({ Name = "Fade time", Min = 5, Max = 100, Step = 5, Default = 30, Suffix = "ds", Flag = "fs_fade" })
	local fsSpacing = fsSettings:Slider({ Name = "Step spacing", Min = 10, Max = 100, Step = 5, Default = 35, Suffix = "ds", Flag = "fs_spacing" })
	local fsWidth   = fsSettings:Slider({ Name = "Stance width", Min = 0, Max = 30, Step = 1, Default = 8, Suffix = "ds", Flag = "fs_width" })
	local fsWalls   = fsSettings:Toggle({ Name = "Visible through walls", Default = true, Flag = "fs_walls" })
	local fsLight   = fsSettings:Toggle({ Name = "Glow light (matches color)", Default = false, Flag = "fs_light" })
	local fsRainbow = fsSettings:Toggle({ Name = "Rainbow", Default = false, Flag = "fs_rainbow" })
	local fsRbSpeed = fsSettings:Slider({ Name = "Rainbow speed", Min = 5, Max = 200, Step = 5, Default = 50, Suffix = "%", Flag = "fs_rbspeed" })

	local fsFolder = Instance.new("Folder")
	fsFolder.Name = "MisanthropyFootsteps"
	fsFolder.Parent = Workspace
	table.insert(cleanups, function() if fsFolder then fsFolder:Destroy() end end)

	local function loopSegs(points: { { number } }): { { number } }
		local segs = {}
		for i = 1, #points do
			local a = points[i]
			local b = points[(i % #points) + 1]
			table.insert(segs, { a[1], a[2], b[1], b[2] })
		end
		return segs
	end
	local function ngon(n: number, r: number): { { number } }
		local pts = {}
		for i = 0, n - 1 do
			local a = (i / n) * math.pi * 2
			table.insert(pts, { math.sin(a) * r, -math.cos(a) * r })
		end
		return pts
	end
	local function starPts(): { { number } }
		local pts = {}
		for i = 0, 9 do
			local a = (i / 10) * math.pi * 2
			local r = (i % 2 == 0) and 0.58 or 0.24
			table.insert(pts, { math.sin(a) * r, -math.cos(a) * r })
		end
		return pts
	end
	local FS_SHAPE_DEFS: { [string]: { segs: { { number } }?, solid: boolean? } } = {
		["Square"]       = { segs = loopSegs({ {-0.5,-0.5}, {0.5,-0.5}, {0.5,0.5}, {-0.5,0.5} }) },
		["Solid Square"] = { solid = true },
		["Circle"]       = { segs = loopSegs(ngon(10, 0.55)) },
		["Triangle"]     = { segs = loopSegs({ {0,-0.6}, {0.52,0.42}, {-0.52,0.42} }) },
		["Star"]         = { segs = loopSegs(starPts()) },
		["Diamond"]      = { segs = loopSegs({ {0,-0.6}, {0.45,0}, {0,0.6}, {-0.45,0} }) },
		["Chevron"]      = { segs = { {0,-0.5, 0.42,0.32}, {0,-0.5, -0.42,0.32} } },
	}

	local FS_MAX = 24
	local MAX_SEG = 10
	local ANIM_TIME = 0.28

	type Seg = { part: Part, adorn: BoxHandleAdornment }
	type Step = {
		segs: { Seg },
		light: PointLight,
		born: number,
		active: boolean,
		laidOut: boolean,
		base: CFrame,
		shape: string,
		scale: number,
	}
	local steps: { Step } = {}

	for _ = 1, FS_MAX do
		local segs: { Seg } = {}
		for j = 1, MAX_SEG do
			local p = Instance.new("Part")
			p.Anchored = true
			p.CanCollide = false; p.CanQuery = false; p.CanTouch = false; p.Massless = true
			p.Material = Enum.Material.Neon
			p.CastShadow = false
			p.Transparency = 1
			p.Size = Vector3.new(0.1, 0.05, 0.1)
			p.Parent = fsFolder
			local a = Instance.new("BoxHandleAdornment")
			a.Adornee = p
			a.AlwaysOnTop = true
			a.ZIndex = 1
			a.Transparency = 1
			a.Visible = false
			a.Parent = p
			table.insert(segs, { part = p, adorn = a })
		end
		local light = Instance.new("PointLight")
		light.Enabled = false
		light.Brightness = 2
		light.Range = 8
		light.Parent = segs[1].part
		table.insert(steps, {
			segs = segs, light = light, born = 0, active = false, laidOut = false,
			base = CFrame.new(), shape = "Square", scale = 1,
		})
	end

	local function easeOutBack(t: number): number
		local c1 = 1.70158
		local c3 = c1 + 1
		return 1 + c3 * (t - 1) ^ 3 + c1 * (t - 1) ^ 2
	end

	local function layoutStep(s: Step, animScale: number)
		local def = FS_SHAPE_DEFS[s.shape] or FS_SHAPE_DEFS["Square"]
		local S = 1.4 * s.scale * animScale
		local thickness = math.max(0.08 * s.scale, 0.06)

		if def.solid then
			local seg = s.segs[1]
			seg.part.Size = Vector3.new(math.max(S, 0.05), 0.05, math.max(S, 0.05))
			seg.part.CFrame = s.base
			seg.adorn.Size = seg.part.Size
			for i = 2, MAX_SEG do
				s.segs[i].part.Transparency = 1
				s.segs[i].adorn.Visible = false
			end
			return
		end

		local defs = def.segs :: { { number } }
		for i = 1, MAX_SEG do
			local seg = s.segs[i]
			local d = defs[i]
			if d then
				local x1, z1, x2, z2 = d[1] * S, d[2] * S, d[3] * S, d[4] * S
				local dx, dz = x2 - x1, z2 - z1
				local len = math.sqrt(dx * dx + dz * dz)
				local ang = math.atan2(dx, dz)
				seg.part.Size = Vector3.new(thickness, 0.05, math.max(len + thickness * 0.5, 0.05))
				seg.part.CFrame = s.base
					* CFrame.new((x1 + x2) * 0.5, 0, (z1 + z2) * 0.5)
					* CFrame.Angles(0, ang, 0)
				seg.adorn.Size = seg.part.Size
			else
				seg.part.Transparency = 1
				seg.adorn.Visible = false
			end
		end
	end

	local function segCount(shape: string): number
		local def = FS_SHAPE_DEFS[shape] or FS_SHAPE_DEFS["Square"]
		if def.solid then return 1 end
		return #(def.segs :: { { number } })
	end

	local nextStep = 1
	local function spawnStep(base: CFrame, col: Color3, scale: number, shape: string, onTop: boolean, lightOn: boolean)
		local s = steps[nextStep]
		nextStep = (nextStep % FS_MAX) + 1
		s.active = true
		s.laidOut = false
		s.born = os.clock()
		s.base = base
		s.shape = shape
		s.scale = scale
		local used = segCount(shape)
		for i, seg in ipairs(s.segs) do
			seg.part.Color = col
			seg.part.Transparency = (i <= used) and 0 or 1
			seg.adorn.Color3 = col
			seg.adorn.Transparency = 0
			seg.adorn.Visible = onTop and (i <= used)
		end
		s.light.Color = col
		s.light.Range = 5 + 4 * scale
		s.light.Enabled = lightOn
		layoutStep(s, 0.01)
	end

	local distSinceStep = 0
	local lastPos: Vector3? = nil
	local leftFoot = false

	local rs5 = RunService.RenderStepped:Connect(function(dt: number)
		local now = os.clock()
		local fadeTime = fsFade:Get() / 10

		for _, s in ipairs(steps) do
			if s.active then
				local age = now - s.born
				if age >= fadeTime then
					s.active = false
					s.light.Enabled = false
					for _, seg in ipairs(s.segs) do
						seg.part.Transparency = 1
						seg.adorn.Visible = false
						seg.adorn.Transparency = 1
					end
				else
					if age < ANIM_TIME then
						layoutStep(s, easeOutBack(age / ANIM_TIME))
					elseif not s.laidOut then
						s.laidOut = true
						layoutStep(s, 1)
					end
					local trans = age / fadeTime
					local used = segCount(s.shape)
					for i, seg in ipairs(s.segs) do
						if i <= used then
							seg.part.Transparency = trans
							seg.adorn.Transparency = trans
						end
					end
					s.light.Brightness = 2 * (1 - trans)
				end
			end
		end

		local root = getRootPart()
		if not (fsEnabled:Get() and root) then
			lastPos = nil
			return
		end

		local char = getCharacter()
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		local grounded = hum and hum.FloorMaterial ~= Enum.Material.Air

		local pos = root.Position
		if lastPos then
			local delta = (pos - lastPos) * Vector3.new(1, 0, 1)
			if grounded then
				distSinceStep += delta.Magnitude
			end
		end
		lastPos = pos

		local spacing = fsSpacing:Get() / 10
		if grounded and distSinceStep >= spacing then
			distSinceStep = 0
			leftFoot = not leftFoot

			local rayParams = RaycastParams.new()
			rayParams.FilterType = Enum.RaycastFilterType.Exclude
			rayParams.FilterDescendantsInstances = { char :: Instance, fsFolder, trailFolder, auraFolder }
			local result = Workspace:Raycast(pos, Vector3.new(0, -10, 0), rayParams)
			if result then
				local look = root.CFrame.LookVector * Vector3.new(1, 0, 1)
				local yaw = 0
				if look.Magnitude > 0.001 then
					look = look.Unit
					yaw = math.atan2(-look.X, -look.Z)
				end

				local rightVec = root.CFrame.RightVector * Vector3.new(1, 0, 1)
				local side = (fsWidth:Get() / 10) * 0.5 * (leftFoot and -1 or 1)
				local stepPos = result.Position + rightVec.Unit * side + Vector3.new(0, 0.08, 0)
				local base = CFrame.new(stepPos) * CFrame.Angles(0, yaw, 0)

				local col: Color3
				if fsRainbow:Get() then
					col = Color3.fromHSV((now * (fsRbSpeed:Get() / 100) * 0.15) % 1, 0.9, 1)
				else
					col = fsColor:Get()
				end

				spawnStep(base, col, fsSize:Get() / 100, fsShape:Get(), fsWalls:Get(), fsLight:Get())
			end
		end
	end)
	table.insert(cleanups, function() rs5:Disconnect() end)

	CFG.toggles.fs_enabled = fsEnabled; CFG.toggles.fs_rainbow = fsRainbow; CFG.toggles.fs_walls = fsWalls
	CFG.toggles.fs_light = fsLight
	CFG.sliders.fs_size = fsSize; CFG.sliders.fs_fade = fsFade
	CFG.sliders.fs_spacing = fsSpacing; CFG.sliders.fs_width = fsWidth
	CFG.sliders.fs_rbspeed = fsRbSpeed
	CFG.dropdowns.fs_shape = fsShape
	CFG.colors.fs_color = fsColor
end

----------------------------------------------------------------------------------
-- SECTION 5d: Aspect Ratio
----------------------------------------------------------------------------------
do
	local arSec = newSection(pgPlayer, "Aspect Ratio")

	local arEnabled = arSec:Toggle({ Name = "Enabled", Default = false, Flag = "ar_enabled" })
	local arSettings = settingsOf(arSec, arEnabled)
	local arHoriz = arSettings:Slider({ Name = "Horizontal stretch", Min = 30, Max = 200, Step = 1, Default = 100, Suffix = "%", Flag = "ar_horiz" })
	local arVert  = arSettings:Slider({ Name = "Vertical stretch", Min = 30, Max = 200, Step = 1, Default = 100, Suffix = "%", Flag = "ar_vert" })
	local arSpeed = arSettings:Slider({ Name = "Animation speed", Min = 1, Max = 20, Step = 1, Default = 6, Flag = "ar_speed" })

	local curH, curV = 1, 1
	local lastApplied: CFrame? = nil

	local rs7 = RunService.RenderStepped:Connect(function(dt: number)
		local cam = Workspace.CurrentCamera
		if not cam then return end

		local on = arEnabled:Get()

		local targetH = on and (arHoriz:Get() / 100) or 1
		local targetV = on and (arVert:Get() / 100) or 1

		local alpha = math.min(dt * arSpeed:Get(), 1)
		curH = curH + (targetH - curH) * alpha
		curV = curV + (targetV - curV) * alpha

		if not on and math.abs(curH - 1) < 0.002 and math.abs(curV - 1) < 0.002 then
			curH, curV = 1, 1
			lastApplied = nil
			return
		end

		local currentCFrame = cam.CFrame
		if lastApplied and currentCFrame == lastApplied then return end

		local X, Y, Z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = currentCFrame:GetComponents()
		local stretched = CFrame.new(
			X, Y, Z,
			R00 * curH, R01 * curV, R02,
			R10,        R11 * curV, R12,
			R20 * curH, R21 * curV, R22
		)
		cam.CFrame = stretched
		lastApplied = stretched
	end)
	table.insert(cleanups, function()
		rs7:Disconnect()
	end)

	CFG.toggles.ar_enabled = arEnabled
	CFG.sliders.ar_horiz = arHoriz; CFG.sliders.ar_vert = arVert
	CFG.sliders.ar_speed = arSpeed
end

----------------------------------------------------------------------------------
-- SECTION 5e: Psuedo State Spoofer
----------------------------------------------------------------------------------
do
	local emSec = newSection(pgPlayer, "Emotes")

	local PRIORITIES = { "Action (full body)", "Movement (layer)", "Idle (layer)", "Core (takeover)" }
	local PRIORITY_MAP = {
		["Action (full body)"] = Enum.AnimationPriority.Action,
		["Movement (layer)"]   = Enum.AnimationPriority.Movement,
		["Idle (layer)"]       = Enum.AnimationPriority.Idle,
		["Core (takeover)"]    = Enum.AnimationPriority.Core,
	}

	emSec:Label("Animation / Emote ID")
	local emId       = emSec:Textbox({ Default = "", Placeholder = "e.g. 507770239", Flag = "em_id" })
	local nowPlayingLabel = emSec:Label("Now playing: (nothing)")
	local emLoop     = emSec:Toggle({ Name = "Loop", Default = true, Flag = "em_loop" })

	local emSettings = settingsOf(emSec, emLoop)
	local emSpeed    = emSettings:Slider({ Name = "Speed", Min = 10, Max = 300, Step = 5, Default = 100, Suffix = "%", Flag = "em_speed" })
	local emPriority = emSettings:Dropdown({ Name = "Priority", Items = PRIORITIES, Default = "Action (full body)", Flag = "em_priority" })

	local currentTrack: AnimationTrack? = nil
	local animInstance: Animation? = nil

	-- populated by "Scan game animations" below; playEmote() consults this
	-- so the "now playing" readout can show a real name, not just the ID.
	local foundAnims: { { label: string, id: string } } = {}
	local pickIndex = 0

	local function labelForId(id: string): string
		for _, a in ipairs(foundAnims) do
			if a.id == id then return a.label end
		end
		return "Custom"
	end

	local function updateNowPlaying(name: string?, id: string?)
		if id then
			nowPlayingLabel:SetText(("Now playing: %s  (%s)"):format(name or "Custom", id))
		else
			nowPlayingLabel:SetText("Now playing: (nothing)")
		end
	end

	local function getAnimator(): Animator?
		local char = getCharacter()
		if not char then return nil end
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not hum then return nil end
		local animator = hum:FindFirstChildOfClass("Animator")
		return animator
	end

	local function stopEmote()
		if currentTrack then
			pcall(function() currentTrack:Stop(0.2) end)
			currentTrack = nil
		end
		updateNowPlaying(nil, nil)
	end

	local function playEmote()
		stopEmote()

		local idText = emId:Get()
		if type(idText) ~= "string" then
			notify("Emotes", "Enter an animation ID first"); return
		end
		local id = idText:match("%d+")
		if not id then
			notify("Emotes", "Invalid ID - enter a numeric animation/emote ID"); return
		end

		local animator = getAnimator()
		if not animator then
			notify("Emotes", "No Animator found on your character"); return
		end

		if not animInstance then
			animInstance = Instance.new("Animation")
		end
		animInstance.AnimationId = "rbxassetid://" .. id

		local ok, track = pcall(function()
			return animator:LoadAnimation(animInstance)
		end)
		if not ok or not track then
			notify("Emotes", "Failed to load animation (ID may be invalid or private)"); return
		end

		currentTrack = track
		track.Priority = PRIORITY_MAP[emPriority:Get()] or Enum.AnimationPriority.Action
		track.Looped = emLoop:Get()
		track:Play(0.15)
		track:AdjustSpeed(emSpeed:Get() / 100)

		local name = labelForId(id)
		updateNowPlaying(name, id)
		notify("Emotes", "Playing " .. id)

		track.Stopped:Connect(function()
			if currentTrack == track then
				currentTrack = nil
				updateNowPlaying(nil, nil)
			end
		end)
	end

	emSec:Button({ Name = "Play", Callback = playEmote })
	emSec:Button({ Name = "Stop", Callback = stopEmote })

	local function scanGameAnims()
		table.clear(foundAnims)
		pickIndex = 0
		local char = getCharacter()
		local animate = char and char:FindFirstChild("Animate")
		if not animate then
			notify("Emotes", "No Animate script found on your character")
			return
		end
		for _, category in ipairs(animate:GetChildren()) do
			for _, anim in ipairs(category:GetChildren()) do
				if anim:IsA("Animation") then
					local id = anim.AnimationId:match("%d+")
					if id then
						table.insert(foundAnims, { label = category.Name, id = id })
					end
				end
			end
		end
		if #foundAnims == 0 then
			notify("Emotes", "No animation IDs found on the Animate script")
			return
		end
		local names = {}
		for _, a in ipairs(foundAnims) do table.insert(names, a.label) end
		notify("Emotes", "Found " .. #foundAnims .. ": " .. table.concat(names, ", "))
	end

	emSec:Button({ Name = "Scan game animations", Callback = scanGameAnims })
	emSec:Button({ Name = "Next game animation ->", Callback = function()
		if #foundAnims == 0 then
			notify("Emotes", "Scan first")
			return
		end
		pickIndex = (pickIndex % #foundAnims) + 1
		local a = foundAnims[pickIndex]
		pcall(function() emId:Set(a.id) end)
		notify("Emotes", string.format("[%d/%d] %s (%s)", pickIndex, #foundAnims, a.label, a.id))
		playEmote()
	end })

	local rs8 = RunService.Heartbeat:Connect(function()
		if currentTrack and currentTrack.IsPlaying then
			currentTrack:AdjustSpeed(emSpeed:Get() / 100)
			currentTrack.Looped = emLoop:Get()
		end
	end)
	table.insert(cleanups, function()
		rs8:Disconnect()
		stopEmote()
	end)

	CFG.toggles.em_loop = emLoop
	CFG.sliders.em_speed = emSpeed
	CFG.dropdowns.em_priority = emPriority
end

----------------------------------------------------------------------------------
-- SECTION 5g: Model Skin (local material override + static mesh overlay)
----------------------------------------------------------------------------------
do
	local msSec = newSection(pgCharacter, "Model Skin")

	local MS_MATERIALS = { "Default", "ForceField", "Neon", "Glass", "Plastic", "SmoothPlastic", "Metal", "Wood", "Slate", "Ice" }
	local MS_MAT_MAP = {
		ForceField = Enum.Material.ForceField, Neon = Enum.Material.Neon, Glass = Enum.Material.Glass,
		Plastic = Enum.Material.Plastic, SmoothPlastic = Enum.Material.SmoothPlastic, Metal = Enum.Material.Metal,
		Wood = Enum.Material.Wood, Slate = Enum.Material.Slate, Ice = Enum.Material.Ice,
	}

	local msMatEnabled = msSec:Toggle({ Name = "Override my material", Default = false, Flag = "ms_mat_enabled" })
	local msMaterial   = msSec:Dropdown({ Name = "Material", Items = MS_MATERIALS, Default = "ForceField", Flag = "ms_material" })
	local msMatColor   = newColorpicker(msSec, { Name = "Body color", Default = Color3.fromRGB(120, 170, 255), Alpha = 1, Flag = "ms_matcolor" })
	local msMatSettings = settingsOf(msSec, msMatEnabled)
	local msTint       = msMatSettings:Toggle({ Name = "Apply body color", Default = false, Flag = "ms_tint" })
	local msBodyTrans  = msMatSettings:Slider({ Name = "Body transparency", Min = 0, Max = 100, Step = 5, Default = 0, Suffix = "%", Flag = "ms_bodytrans" })

	local savedMat: { [BasePart]: any } = {}
	local savedColor: { [BasePart]: Color3 } = {}
	local savedTrans: { [BasePart]: number } = {}

	local function restoreMaterial()
		for part in pairs(savedTrans) do
			if part and part.Parent then
				part.LocalTransparencyModifier = savedTrans[part] or 0
				if savedMat[part] then part.Material = savedMat[part] end
				if savedColor[part] then part.Color = savedColor[part] end
			end
		end
		table.clear(savedMat); table.clear(savedColor); table.clear(savedTrans)
	end

	local msHideReal  = msSec:Toggle({ Name = "Hide my real body", Default = false, Flag = "ms_hidereal" })

	local msOverlayOn = msSec:Toggle({ Name = "Mesh overlay", Default = false, Flag = "ms_overlay_on" })
	local msOverlayType = msSec:Dropdown({ Name = "Overlay type", Items = { "Single Mesh", "Full Model" }, Default = "Single Mesh", Flag = "ms_overlay_type" })
	local msMeshId    = newTextInput(msSec, { Name = "Mesh asset ID", Default = "", Placeholder = "rbxassetid or number", Flag = "ms_meshid" })
	local msOvSettings = settingsOf(msSec, msOverlayOn)
	local msScale     = msOvSettings:Slider({ Name = "Scale", Min = 10, Max = 500, Step = 5, Default = 100, Suffix = "%", Flag = "ms_scale" })
	local msXOff      = msOvSettings:Slider({ Name = "X offset", Min = -50, Max = 50, Step = 1, Default = 0, Suffix = "ds", Flag = "ms_xoff" })
	local msYOff      = msOvSettings:Slider({ Name = "Y offset", Min = -50, Max = 50, Step = 1, Default = 0, Suffix = "ds", Flag = "ms_yoff" })
	local msZOff      = msOvSettings:Slider({ Name = "Z offset", Min = -50, Max = 50, Step = 1, Default = 0, Suffix = "ds", Flag = "ms_zoff" })
	local msPitch     = msOvSettings:Slider({ Name = "Pitch", Min = 0, Max = 360, Step = 5, Default = 0, Suffix = "°", Flag = "ms_pitch" })
	local msYaw       = msOvSettings:Slider({ Name = "Yaw", Min = 0, Max = 360, Step = 5, Default = 0, Suffix = "°", Flag = "ms_yaw" })
	local msRoll      = msOvSettings:Slider({ Name = "Roll", Min = 0, Max = 360, Step = 5, Default = 0, Suffix = "°", Flag = "ms_roll" })
	local msSpinOn    = msOvSettings:Toggle({ Name = "Spin", Default = false, Flag = "ms_spin_on" })
	local msSpinSettings = settingsOf(msSec, msSpinOn)
	local msSpinAxis  = msSpinSettings:Dropdown({ Name = "Spin axis", Items = { "Yaw", "Pitch", "Roll" }, Default = "Yaw", Flag = "ms_spin_axis" })
	local msSpinSpeed = msSpinSettings:Slider({ Name = "Spin speed", Min = 5, Max = 400, Step = 5, Default = 100, Suffix = "%", Flag = "ms_spin_speed" })
	local msTexId     = newTextInput(msOvSettings, { Name = "Texture ID (optional)", Default = "", Placeholder = "rbxassetid or number", Flag = "ms_texid" })
	local msModelId   = newTextInput(msOvSettings, { Name = "Model asset ID (Full Model mode)", Default = "", Placeholder = "rbxassetid or number, must be uploaded to Roblox", Flag = "ms_modelid" })

	local msFolder = Instance.new("Folder")
	msFolder.Name = "MisanthropyModelSkin"
	msFolder.Parent = Workspace
	table.insert(cleanups, function() if msFolder then msFolder:Destroy() end end)

	local ovPart = Instance.new("Part")
	ovPart.Name = "MeshOverlay"
	ovPart.Anchored = true
	ovPart.CanCollide = false; ovPart.CanQuery = false; ovPart.CanTouch = false; ovPart.Massless = true
	ovPart.Transparency = 1
	ovPart.Size = Vector3.new(1, 1, 1)
	ovPart.CastShadow = false
	ovPart.Parent = msFolder
	local ovMesh = Instance.new("SpecialMesh")
	ovMesh.MeshType = Enum.MeshType.FileMesh
	ovMesh.Parent = ovPart

	local localMeshId: string? = nil
	if _isfile and _getasset and _isfile(ROOT .. "/overlay.mesh") then
		local ok, id = pcall(_getasset, ROOT .. "/overlay.mesh")
		if ok then localMeshId = id end
	end

	local function idToAsset(text: string?): string?
		if type(text) ~= "string" then return nil end
		local n = text:match("%d+")
		if n then return "rbxassetid://" .. n end
		return nil
	end

	local lastMeshApplied = ""
	local lastTexApplied = ""

	local function refreshMesh()
		local want = idToAsset(msMeshId:Get()) or localMeshId or ""
		if want ~= lastMeshApplied then
			lastMeshApplied = want
			ovMesh.MeshId = want
			ovPart.Transparency = (want == "") and 1 or 0
		end
		local tex = idToAsset(msTexId:Get()) or ""
		if tex ~= lastTexApplied then
			lastTexApplied = tex
			ovMesh.TextureId = tex
		end
	end

	local modelOverlay: Model? = nil
	local modelParts: { BasePart } = {}
	local modelVisible = false
	local lastModelScale = 1

	local function setModelVisible(v: boolean)
		if v == modelVisible then return end
		modelVisible = v
		for _, p in ipairs(modelParts) do
			p.Transparency = v and 0 or 1
		end
	end

	local function destroyModelOverlay()
		if modelOverlay then modelOverlay:Destroy() end
		modelOverlay = nil
		modelParts = {}
		modelVisible = false
	end

	local function sanitizeModel(inst: Instance)
		for _, d in ipairs(inst:GetDescendants()) do
			if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("ModuleScript") then
				d:Destroy()
			elseif d:IsA("BasePart") then
				d.Anchored = true
				d.CanCollide = false; d.CanQuery = false; d.CanTouch = false; d.Massless = true
				d.CastShadow = false
			end
		end
	end

	local function loadModelOverlay()
		local id = msModelId:Get():match("%d+")
		if not id then
			notify("misanthropy", "Enter a numeric model asset ID first.")
			return
		end
		task.spawn(function()
			local ok, objs = pcall(function() return (game :: any):GetObjects("rbxassetid://" .. id) end)
			if not ok or not objs or #objs == 0 then
				notify("misanthropy", "Failed to load model asset " .. id)
				return
			end
			local top = objs[1] :: Instance
			if not (top:IsA("Model") or top:IsA("BasePart") or top:IsA("Folder")) then
				notify("misanthropy", "Asset " .. id .. " has no usable model.")
				return
			end
			destroyModelOverlay()
			local m: Model
			if top:IsA("Model") then
				m = top :: Model
			else
				m = Instance.new("Model")
				top.Parent = m
			end
			sanitizeModel(m)
			local parts: { BasePart } = {}
			for _, d in ipairs(m:GetDescendants()) do
				if d:IsA("BasePart") then table.insert(parts, d) end
			end
			if #parts == 0 then
				notify("misanthropy", "Model " .. id .. " has no parts.")
				m:Destroy()
				return
			end
			if not m.PrimaryPart then m.PrimaryPart = parts[1] end
			for _, p in ipairs(parts) do p.Transparency = 1 end
			m.Name = "MeshOverlayModel"
			m.Parent = msFolder
			modelOverlay = m
			modelParts = parts
			modelVisible = false
			lastModelScale = 1
			notify("misanthropy", "Model " .. id .. " loaded (" .. #parts .. " parts).")
		end)
	end
	msOvSettings:Button({ Name = "Load model", Callback = loadModelOverlay })

	local rs10 = RunService.RenderStepped:Connect(function()
		local char = getCharacter()
		local root = char and (char:FindFirstChild("HumanoidRootPart") :: BasePart?)

		if msMatEnabled:Get() and char then
			local matName = msMaterial:Get()
			local mat = MS_MAT_MAP[matName]
			local tintOn = msTint:Get()
			local col = msMatColor:Get()
			local bodyTrans = msBodyTrans:Get() / 100
			for _, d in ipairs(char:GetDescendants()) do
				if d:IsA("BasePart") and d.Name ~= "HumanoidRootPart" then
					if savedMat[d] == nil then
						savedMat[d] = d.Material
						savedColor[d] = d.Color
						savedTrans[d] = d.LocalTransparencyModifier
					end
					if matName == "Default" then
						d.Material = savedMat[d]
					elseif mat then
						d.Material = mat
					end
					if tintOn then d.Color = col else d.Color = savedColor[d] or d.Color end
					d.LocalTransparencyModifier = bodyTrans
				end
			end
		else
			if next(savedMat) then restoreMaterial() end
		end

		if msHideReal:Get() and char then
			for _, d in ipairs(char:GetDescendants()) do
				if d:IsA("BasePart") and d.Name ~= "HumanoidRootPart" then
					if savedTrans[d] == nil then savedTrans[d] = d.LocalTransparencyModifier end
					d.LocalTransparencyModifier = 1
				end
			end
		elseif not msMatEnabled:Get() and next(savedTrans) then
			restoreMaterial()
		end

		if modelOverlay and not modelOverlay.Parent then
			modelOverlay = nil
			modelParts = {}
			modelVisible = false
		end

		local overlayOn = msOverlayOn:Get() and root ~= nil
		local useModel = overlayOn and msOverlayType:Get() == "Full Model" and modelOverlay ~= nil
		if overlayOn then
			local xoff = msXOff:Get() / 10
			local yoff = msYOff:Get() / 10
			local zoff = msZOff:Get() / 10
			local pitch = math.rad(msPitch:Get())
			local yaw = math.rad(msYaw:Get())
			local roll = math.rad(msRoll:Get())
			if msSpinOn:Get() then
				local spin = (os.clock() * (msSpinSpeed:Get() / 100) * 2) % (2 * math.pi)
				local axis = msSpinAxis:Get()
				if axis == "Pitch" then
					pitch += spin
				elseif axis == "Roll" then
					roll += spin
				else
					yaw += spin
				end
			end
			local targetCFrame = root.CFrame * CFrame.new(xoff, yoff, zoff) * CFrame.Angles(pitch, yaw, roll)

			if useModel then
				local mdl = modelOverlay :: Model
				ovPart.Transparency = 1
				setModelVisible(true)
				local s = msScale:Get() / 100
				if s ~= lastModelScale then
					lastModelScale = s
					pcall(function() mdl:ScaleTo(s) end)
				end
				mdl:PivotTo(targetCFrame)
			else
				setModelVisible(false)
				refreshMesh()
				local s = msScale:Get() / 100 * 2
				ovMesh.Scale = Vector3.new(s, s, s)
				ovPart.CFrame = targetCFrame
				ovPart.Transparency = (ovMesh.MeshId == "") and 1 or 0
			end
		else
			ovPart.Transparency = 1
			setModelVisible(false)
		end
	end)
	table.insert(cleanups, function()
		rs10:Disconnect()
		restoreMaterial()
	end)

	CFG.toggles.ms_mat_enabled = msMatEnabled; CFG.toggles.ms_tint = msTint
	CFG.toggles.ms_overlay_on = msOverlayOn; CFG.toggles.ms_hidereal = msHideReal
	CFG.toggles.ms_spin_on = msSpinOn
	CFG.sliders.ms_bodytrans = msBodyTrans; CFG.sliders.ms_scale = msScale
	CFG.sliders.ms_xoff = msXOff; CFG.sliders.ms_yoff = msYOff; CFG.sliders.ms_zoff = msZOff
	CFG.sliders.ms_pitch = msPitch; CFG.sliders.ms_yaw = msYaw; CFG.sliders.ms_roll = msRoll
	CFG.sliders.ms_spin_speed = msSpinSpeed
	CFG.dropdowns.ms_material = msMaterial; CFG.dropdowns.ms_overlay_type = msOverlayType
	CFG.dropdowns.ms_spin_axis = msSpinAxis
	CFG.colors.ms_matcolor = msMatColor
end

----------------------------------------------------------------------------------
-- SECTION 5h: HP Vignette Flash (full-screen flash reacting to your own health)
----------------------------------------------------------------------------------
do
	local hvSec = newSection(pgWorld, "HP Vignette Flash")
	local hvEnabled = hvSec:Toggle({ Name = "Enabled", Default = false, Flag = "hv_enabled" })
	local hvDamageColor = newColorpicker(hvSec, { Name = "Damage color", Default = Color3.fromRGB(200, 30, 30), Alpha = 1, Flag = "hv_dmgcolor" })
	local hvSettings = settingsOf(hvSec, hvEnabled)
	local hvHealFlash = hvSettings:Toggle({ Name = "Also flash on healing", Default = false, Flag = "hv_healflash" })
	local hvHealColor = newColorpicker(hvSettings, { Name = "Heal color", Default = Color3.fromRGB(30, 200, 90), Alpha = 1, Flag = "hv_healcolor" })
	local hvIntensity = hvSettings:Slider({ Name = "Intensity", Min = 10, Max = 100, Step = 5, Default = 55, Suffix = "%", Flag = "hv_intensity" })
	local hvFadeTime  = hvSettings:Slider({ Name = "Fade time", Min = 100, Max = 2000, Step = 100, Default = 500, Suffix = "ms", Flag = "hv_fadetime" })
	local hvMinChange = hvSettings:Slider({ Name = "Min change", Min = 1, Max = 50, Step = 1, Default = 3, Suffix = "%", Flag = "hv_minchange" })

	local TweenService = game:GetService("TweenService")

	local vgFrame = Instance.new("Frame")
	vgFrame.Name = "MisanthropyHPFlash"
	vgFrame.Size = UDim2.fromScale(1, 1)
	vgFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	vgFrame.BackgroundTransparency = 1
	vgFrame.BorderSizePixel = 0
	vgFrame.ZIndex = 9990
	vgFrame.Parent = screen
	table.insert(cleanups, function() vgFrame:Destroy() end)

	local currentTween: Tween? = nil
	local function flash(col: Color3)
		if currentTween then currentTween:Cancel() end
		vgFrame.BackgroundColor3 = col
		vgFrame.BackgroundTransparency = 1 - (hvIntensity:Get() / 100)
		currentTween = TweenService:Create(
			vgFrame,
			TweenInfo.new(hvFadeTime:Get() / 1000, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ BackgroundTransparency = 1 }
		)
		currentTween:Play()
	end

	local lastHealth: number? = nil
	local healthConn: RBXScriptConnection? = nil
	local function hookHumanoid(char: Model)
		local h = char:FindFirstChildOfClass("Humanoid")
		if not h then return end
		lastHealth = h.Health
		if healthConn then healthConn:Disconnect() end
		healthConn = h.HealthChanged:Connect(function(newHealth)
			local prev = lastHealth or newHealth
			lastHealth = newHealth
			if not hvEnabled:Get() then return end
			local maxH = h.MaxHealth
			if maxH <= 0 then return end
			local deltaPct = (newHealth - prev) / maxH * 100
			if deltaPct <= -hvMinChange:Get() then
				flash(hvDamageColor:Get())
			elseif hvHealFlash:Get() and deltaPct >= hvMinChange:Get() then
				flash(hvHealColor:Get())
			end
		end)
	end

	do
		local char = getCharacter()
		if char then hookHumanoid(char) end
	end
	local charConn = LocalPlayer.CharacterAdded:Connect(function(char)
		task.wait(0.1)
		hookHumanoid(char)
	end)
	table.insert(cleanups, function()
		charConn:Disconnect()
		if healthConn then healthConn:Disconnect() end
	end)

	CFG.toggles.hv_enabled = hvEnabled; CFG.toggles.hv_healflash = hvHealFlash
	CFG.sliders.hv_intensity = hvIntensity; CFG.sliders.hv_fadetime = hvFadeTime; CFG.sliders.hv_minchange = hvMinChange
	CFG.colors.hv_dmgcolor = hvDamageColor; CFG.colors.hv_healcolor = hvHealColor
end

----------------------------------------------------------------------------------
-- SECTION 5i: Night Mode
----------------------------------------------------------------------------------
do
	local nmSec = newSection(pgWorld, "Night Mode")
	local nmEnabled = nmSec:Toggle({ Name = "Enabled", Default = false, Flag = "nm_enabled" })

	local NmLighting = game:GetService("Lighting")
	local savedLight: { [string]: any } = {}
	local nmAtmosphere: Atmosphere? = nil

	local function applyNightMode()
		savedLight.Ambient = NmLighting.Ambient
		savedLight.Brightness = NmLighting.Brightness
		savedLight.OutdoorAmbient = NmLighting.OutdoorAmbient
		savedLight.ClockTime = NmLighting.ClockTime
		savedLight.FogColor = NmLighting.FogColor
		savedLight.FogEnd = NmLighting.FogEnd
		savedLight.ColorShift_Top = NmLighting.ColorShift_Top
		savedLight.ColorShift_Bottom = NmLighting.ColorShift_Bottom
		savedLight.GlobalShadows = NmLighting.GlobalShadows
		NmLighting.Ambient = Color3.new(0.3, 0.3, 0.4)
		NmLighting.Brightness = 1.2
		NmLighting.OutdoorAmbient = Color3.new(0.3, 0.3, 0.4)
		NmLighting.ClockTime = 0
		NmLighting.FogColor = Color3.new(0.2, 0.2, 0.3)
		NmLighting.FogEnd = 1000
		NmLighting.ColorShift_Top = Color3.new(0.3, 0.3, 0.5)
		NmLighting.ColorShift_Bottom = Color3.new(0.1, 0.1, 0.2)
		NmLighting.GlobalShadows = true
		nmAtmosphere = Instance.new("Atmosphere")
		nmAtmosphere.Density = 0.2
		nmAtmosphere.Offset = 0.4
		nmAtmosphere.Color = Color3.new(0.2, 0.2, 0.3)
		nmAtmosphere.Decay = Color3.new(0.4, 0.4, 0.6)
		nmAtmosphere.Glare = 0.1
		nmAtmosphere.Parent = NmLighting
	end

	local function restoreNightMode()
		if not savedLight.Ambient then return end
		NmLighting.Ambient = savedLight.Ambient
		NmLighting.Brightness = savedLight.Brightness
		NmLighting.OutdoorAmbient = savedLight.OutdoorAmbient
		NmLighting.ClockTime = savedLight.ClockTime
		NmLighting.FogColor = savedLight.FogColor
		NmLighting.FogEnd = savedLight.FogEnd
		NmLighting.ColorShift_Top = savedLight.ColorShift_Top
		NmLighting.ColorShift_Bottom = savedLight.ColorShift_Bottom
		NmLighting.GlobalShadows = savedLight.GlobalShadows
		table.clear(savedLight)
		if nmAtmosphere then nmAtmosphere:Destroy(); nmAtmosphere = nil end
	end

	local nmWasOn = false
	local rsNm = RunService.Heartbeat:Connect(function()
		local on = nmEnabled:Get()
		if on and not nmWasOn then applyNightMode() end
		if not on and nmWasOn then restoreNightMode() end
		nmWasOn = on
	end)
	table.insert(cleanups, function()
		rsNm:Disconnect()
		restoreNightMode()
	end)

	CFG.toggles.nm_enabled = nmEnabled
end

----------------------------------------------------------------------------------
-- SECTION 5j: Atmospheric Fog
----------------------------------------------------------------------------------
do
	local afSec = newSection(pgWorld, "Atmospheric Fog")
	local afEnabled = afSec:Toggle({ Name = "Enabled", Default = false, Flag = "af_enabled" })
	local afColor   = newColorpicker(afSec, { Name = "Color", Default = Color3.fromRGB(185, 195, 210), Alpha = 1, Flag = "af_color" })
	local afSettings = settingsOf(afSec, afEnabled)
	local afDensity = afSettings:Slider({ Name = "Density", Min = 5, Max = 100, Step = 5, Default = 42, Suffix = "%", Flag = "af_density" })
	local afHaze    = afSettings:Slider({ Name = "Haze", Min = 0, Max = 100, Step = 5, Default = 35, Suffix = "%", Flag = "af_haze" })

	local AfLighting = game:GetService("Lighting")
	local afSaved: { [string]: any } = {}
	local afAtmosphere: Atmosphere? = nil

	local function applyFog()
		afSaved.FogColor = AfLighting.FogColor
		afSaved.FogStart = AfLighting.FogStart
		afSaved.FogEnd = AfLighting.FogEnd
		local col = afColor:Get()
		afAtmosphere = Instance.new("Atmosphere")
		afAtmosphere.Color = col
		afAtmosphere.Decay = col
		afAtmosphere.Density = afDensity:Get() / 100
		afAtmosphere.Haze = afHaze:Get() / 10
		afAtmosphere.Glare = 0.5
		afAtmosphere.Parent = AfLighting
		AfLighting.FogColor = col
		AfLighting.FogStart = 50
		AfLighting.FogEnd = 900
	end

	local function restoreFog()
		if not afSaved.FogColor then return end
		AfLighting.FogColor = afSaved.FogColor
		AfLighting.FogStart = afSaved.FogStart
		AfLighting.FogEnd = afSaved.FogEnd
		table.clear(afSaved)
		if afAtmosphere then afAtmosphere:Destroy(); afAtmosphere = nil end
	end

	local afWasOn = false
	local rsAf = RunService.Heartbeat:Connect(function()
		local on = afEnabled:Get()
		if on and afAtmosphere then
			local col = afColor:Get()
			afAtmosphere.Color = col
			afAtmosphere.Decay = col
			afAtmosphere.Density = afDensity:Get() / 100
			afAtmosphere.Haze = afHaze:Get() / 10
		end
		if on and not afWasOn then applyFog() end
		if not on and afWasOn then restoreFog() end
		afWasOn = on
	end)
	table.insert(cleanups, function()
		rsAf:Disconnect()
		restoreFog()
	end)

	CFG.toggles.af_enabled = afEnabled
	CFG.sliders.af_density = afDensity; CFG.sliders.af_haze = afHaze
	CFG.colors.af_color = afColor
end

----------------------------------------------------------------------------------
-- SECTION 5k: Orbit
----------------------------------------------------------------------------------
do
	local obSec = newSection(pgCharacter, "Orbit")
	local obEnabled = obSec:Toggle({ Name = "Enabled", Default = false, Flag = "ob_enabled" })
	local obSettings = settingsOf(obSec, obEnabled)
	local obCount  = obSettings:Slider({ Name = "Count", Min = 2, Max = 16, Step = 1, Default = 6, Flag = "ob_count" })
	local obRadius = obSettings:Slider({ Name = "Radius", Min = 3, Max = 30, Step = 1, Default = 10, Flag = "ob_radius" })
	local obSpeed  = obSettings:Slider({ Name = "Speed", Min = 5, Max = 100, Step = 5, Default = 30, Suffix = "%", Flag = "ob_speed" })
	local obSize   = obSettings:Slider({ Name = "Ball size", Min = 5, Max = 30, Step = 1, Default = 10, Suffix = "ds", Flag = "ob_size" })

	local obFolder = Instance.new("Folder")
	obFolder.Name = "MisanthropyOrbit"
	obFolder.Parent = Workspace
	table.insert(cleanups, function() if obFolder then obFolder:Destroy() end end)

	local spheres: { BasePart } = {}

	local function destroySpheres()
		for _, s in ipairs(spheres) do s:Destroy() end
		table.clear(spheres)
	end

	local function buildSpheres(n: number)
		destroySpheres()
		for _ = 1, n do
			local p = Instance.new("Part")
			p.Shape = Enum.PartType.Ball
			p.Material = Enum.Material.Neon
			p.Color = Color3.fromRGB(0, 255, 255)
			p.Anchored = true
			p.CanCollide = false; p.CanQuery = false; p.CanTouch = false; p.CastShadow = false
			p.Parent = obFolder
			local a0 = Instance.new("Attachment"); a0.Position = Vector3.new(0, 0.5, 0); a0.Parent = p
			local a1 = Instance.new("Attachment"); a1.Position = Vector3.new(0, -0.5, 0); a1.Parent = p
			local trail = Instance.new("Trail")
			trail.Attachment0 = a0; trail.Attachment1 = a1
			trail.Lifetime = 0.6
			trail.Transparency = NumberSequence.new(0.1, 0.8)
			trail.WidthScale = NumberSequence.new(1.2, 0)
			trail.LightEmission = 0.8
			trail.Parent = p
			local glow = Instance.new("PointLight")
			glow.Brightness = 1.5; glow.Range = 6; glow.Shadows = false
			glow.Parent = p
			local dust = Instance.new("ParticleEmitter")
			dust.Texture = "rbxasset://textures/particles/sparkles_main.dds"
			dust.Size = NumberSequence.new(0.05, 0)
			dust.Lifetime = NumberRange.new(0.4, 0.8)
			dust.Rate = 6
			dust.Speed = NumberRange.new(0.1, 0.3)
			dust.Transparency = NumberSequence.new(0.2, 1)
			dust.LightEmission = 1; dust.LightInfluence = 0
			dust.Parent = p
			table.insert(spheres, p)
		end
	end

	local lastObCount = 0
	local rsOb = RunService.Heartbeat:Connect(function()
		if not obEnabled:Get() then
			if #spheres > 0 then destroySpheres() end
			return
		end
		local root = getRootPart()
		if not root then return end
		local n = math.floor(obCount:Get())
		if n ~= lastObCount or #spheres == 0 then
			lastObCount = n
			buildSpheres(n)
		end
		local t = os.clock()
		local radius = obRadius:Get()
		local speed = obSpeed:Get() / 100 * 3
		local sz = obSize:Get() / 10
		for i, p in ipairs(spheres) do
			local angle = t * speed + (i * (math.pi * 2 / n))
			local offset = Vector3.new(math.cos(angle) * radius, math.sin(t * 2 + i) * 1.5 + 2, math.sin(angle) * radius)
			p.Position = p.Position:Lerp(root.Position + offset, 0.15)
			p.Size = Vector3.new(sz, sz, sz)
			local col = Color3.fromHSV((t * 0.08 + i / n) % 1, 0.9, 1)
			p.Color = col
			local glow = p:FindFirstChildOfClass("PointLight")
			if glow then glow.Color = col end
			local dust = p:FindFirstChildOfClass("ParticleEmitter")
			if dust then dust.Color = ColorSequence.new(col) end
		end
	end)
	table.insert(cleanups, function()
		rsOb:Disconnect()
		destroySpheres()
	end)

	CFG.toggles.ob_enabled = obEnabled
	CFG.sliders.ob_count = obCount; CFG.sliders.ob_radius = obRadius
	CFG.sliders.ob_speed = obSpeed; CFG.sliders.ob_size = obSize
end

----------------------------------------------------------------------------------
-- SECTION 5l: Paradox Engine
----------------------------------------------------------------------------------
do
	local peSec = newSection(pgCharacter, "Paradox Engine")
	local peEnabled = peSec:Toggle({ Name = "Enabled", Default = false, Flag = "pe_enabled" })
	local peSettings = settingsOf(peSec, peEnabled)
	local peCount  = peSettings:Slider({ Name = "Particle count", Min = 10, Max = 80, Step = 5, Default = 40, Flag = "pe_count" })
	local peRadius = peSettings:Slider({ Name = "Radius", Min = 2, Max = 20, Step = 1, Default = 6, Flag = "pe_radius" })

	local peFolder = Instance.new("Folder")
	peFolder.Name = "MisanthropyParadoxEngine"
	peFolder.Parent = Workspace
	table.insert(cleanups, function() if peFolder then peFolder:Destroy() end end)

	type ParadoxData = { kind: number, speed: number, offset: number }
	local particles: { BasePart } = {}
	local particleData: { ParadoxData } = {}

	local function destroyParticles()
		for _, p in ipairs(particles) do p:Destroy() end
		table.clear(particles)
		table.clear(particleData)
	end

	local function buildParticles(n: number)
		destroyParticles()
		for i = 1, n do
			local p = Instance.new("Part")
			local sz = 0.3 + math.random() * 0.2
			p.Size = Vector3.new(sz, sz, sz)
			p.Shape = Enum.PartType.Ball
			p.Material = Enum.Material.Neon
			p.Color = Color3.fromRGB(0, 255, 255)
			p.Anchored = true
			p.CanCollide = false; p.CanQuery = false; p.CanTouch = false; p.CastShadow = false
			p.Parent = peFolder
			local a0 = Instance.new("Attachment"); a0.Position = Vector3.new(0, 0.2, 0); a0.Parent = p
			local a1 = Instance.new("Attachment"); a1.Position = Vector3.new(0, -0.2, 0); a1.Parent = p
			local trail = Instance.new("Trail")
			trail.Attachment0 = a0; trail.Attachment1 = a1
			trail.Lifetime = 0.4
			trail.Transparency = NumberSequence.new(0.3, 0.9)
			trail.WidthScale = NumberSequence.new(1.2, 0)
			trail.Color = ColorSequence.new(Color3.fromRGB(0, 255, 255), Color3.fromRGB(170, 0, 255))
			trail.Parent = p
			table.insert(particles, p)
			table.insert(particleData, {
				kind = math.random(1, 3),
				speed = math.random(15, 25) / 10,
				offset = i * (math.pi * 2 / n),
			})
		end
	end

	local lastPeCount = 0
	local rsPe = RunService.Heartbeat:Connect(function()
		if not peEnabled:Get() then
			if #particles > 0 then destroyParticles() end
			return
		end
		local root = getRootPart()
		if not root then return end
		local n = math.floor(peCount:Get())
		if n ~= lastPeCount or #particles == 0 then
			lastPeCount = n
			buildParticles(n)
		end
		local t = os.clock()
		local radius = peRadius:Get()
		for i, p in ipairs(particles) do
			local data = particleData[i]
			local mt = t * data.speed + data.offset
			local target: Vector3
			if data.kind == 1 then
				target = Vector3.new(math.sin(mt) * radius, math.cos(mt * 0.5) * 2 + math.sin(t * 1.5 + i) * 0.3, math.cos(mt) * radius)
			elseif data.kind == 2 then
				target = Vector3.new(math.sin(mt) * 2 + math.cos(t * 0.7 + i) * 0.5, math.sin(mt) * radius, math.cos(mt) * radius)
			else
				target = Vector3.new(math.cos(mt) * radius, math.sin(mt) * (radius / 2) + math.sin(t * 1.2 + i) * 0.5, math.sin(mt) * radius)
			end
			p.Position = p.Position:Lerp(root.Position + target + Vector3.new(0, 1, 0), 0.12)
			p.Color = Color3.fromHSV((t * 0.08 + i / n) % 1, 0.8, 1)
		end
	end)
	table.insert(cleanups, function()
		rsPe:Disconnect()
		destroyParticles()
	end)

	CFG.toggles.pe_enabled = peEnabled
	CFG.sliders.pe_count = peCount; CFG.sliders.pe_radius = peRadius
end

----------------------------------------------------------------------------------
-- SECTION 5m: Neon Trail
----------------------------------------------------------------------------------
do
	local ntSec = newSection(pgCharacter, "Neon Trail")
	local ntEnabled = ntSec:Toggle({ Name = "Enabled", Default = false, Flag = "nt_enabled" })
	local ntSettings = settingsOf(ntSec, ntEnabled)
	local ntFadeTime = ntSettings:Slider({ Name = "Fade time", Min = 500, Max = 3000, Step = 100, Default = 1800, Suffix = "ms", Flag = "nt_fadetime" })
	local ntInterval = ntSettings:Slider({ Name = "Spawn interval", Min = 20, Max = 300, Step = 10, Default = 50, Suffix = "ms", Flag = "nt_interval" })

	local ntFolder = Instance.new("Folder")
	ntFolder.Name = "MisanthropyNeonTrail"
	ntFolder.Parent = Workspace
	table.insert(cleanups, function() if ntFolder then ntFolder:Destroy() end end)

	local NtTweenService = game:GetService("TweenService")

	local function spawnOrb(pos: Vector3, color: Color3, fadeTime: number)
		local part = Instance.new("Part")
		local sz = 0.5 + math.random() * 0.4
		part.Name = "NeonTrail"
		part.Size = Vector3.new(sz, sz, sz)
		part.Shape = Enum.PartType.Ball
		part.CFrame = CFrame.new(pos)
		part.Anchored = true
		part.CanCollide = false; part.CanQuery = false; part.CanTouch = false; part.CastShadow = false
		part.Material = Enum.Material.Neon
		part.Color = color
		part.Transparency = 0.15
		part.Parent = ntFolder
		local sparkle = Instance.new("ParticleEmitter")
		sparkle.Texture = "rbxasset://textures/particles/sparkles_main.dds"
		sparkle.Size = NumberSequence.new(0.04, 0)
		sparkle.Lifetime = NumberRange.new(0.3, 0.6)
		sparkle.Rate = 5
		sparkle.Speed = NumberRange.new(0.2, 0.5)
		sparkle.Transparency = NumberSequence.new(0.3, 1)
		sparkle.Color = ColorSequence.new(color)
		sparkle.LightEmission = 1; sparkle.LightInfluence = 0
		sparkle.Parent = part
		local tween = NtTweenService:Create(part, TweenInfo.new(fadeTime / 1000), { Transparency = 1, Size = Vector3.new(0, 0, 0) })
		tween:Play()
		tween.Completed:Connect(function() part:Destroy() end)
	end

	local lastNtSpawn = 0
	local rsNt = RunService.Heartbeat:Connect(function()
		if not ntEnabled:Get() then return end
		local root = getRootPart()
		if not root then return end
		local now = os.clock()
		if (now - lastNtSpawn) < (ntInterval:Get() / 1000) then return end
		lastNtSpawn = now
		local color = Color3.fromHSV((now % 3) / 3, 1, 1)
		spawnOrb(root.Position, color, ntFadeTime:Get())
	end)
	table.insert(cleanups, function() rsNt:Disconnect() end)

	CFG.toggles.nt_enabled = ntEnabled
	CFG.sliders.nt_fadetime = ntFadeTime; CFG.sliders.nt_interval = ntInterval
end

----------------------------------------------------------------------------------
-- SECTION 5n: Rain
----------------------------------------------------------------------------------
do
	local rnSec = newSection(pgWorld, "Rain")
	local rnEnabled = rnSec:Toggle({ Name = "Enabled", Default = false, Flag = "rn_enabled" })
	local rnSettings = settingsOf(rnSec, rnEnabled)
	local rnCount  = rnSettings:Slider({ Name = "Drop count", Min = 50, Max = 500, Step = 10, Default = 250, Flag = "rn_count" })
	local rnRadius = rnSettings:Slider({ Name = "Radius", Min = 15, Max = 80, Step = 5, Default = 45, Flag = "rn_radius" })
	local rnSpeed  = rnSettings:Slider({ Name = "Fall speed", Min = 20, Max = 150, Step = 5, Default = 82, Flag = "rn_speed" })
	local rnWind   = rnSettings:Slider({ Name = "Wind", Min = -50, Max = 50, Step = 5, Default = 25, Suffix = "ds", Flag = "rn_wind" })

	local rnFolder = Instance.new("Folder")
	rnFolder.Name = "MisanthropyRain"
	rnFolder.Parent = Workspace
	table.insert(cleanups, function() if rnFolder then rnFolder:Destroy() end end)

	local RAIN_HEIGHT = 35
	local SPLASH_POOL = 60
	local MIST_COUNT = 20
	local rnRayParams = RaycastParams.new()
	rnRayParams.FilterType = Enum.RaycastFilterType.Exclude

	type Drop = { part: Part, x: number, y: number, z: number, speed: number, groundY: number, rayTimer: number, len: number }
	local drops: { Drop } = {}
	local splashPool: { Part } = {}
	local splashIndex = 0
	local activeSplashes: { [Part]: number } = {}
	local mistParts: { Part } = {}

	local function getGroundY(pos: Vector3): number
		local result = Workspace:Raycast(pos, Vector3.new(0, -150, 0), rnRayParams)
		return result and result.Position.Y or (pos.Y - 150)
	end

	local function playSplash(pos: Vector3)
		if #splashPool == 0 then return end
		splashIndex = (splashIndex % #splashPool) + 1
		local s = splashPool[splashIndex]
		s.Size = Vector3.new(0.1, 0.03, 0.1)
		s.Position = Vector3.new(pos.X, pos.Y + 0.06, pos.Z)
		s.Transparency = 0.2
		activeSplashes[s] = 0
		local pe = s:FindFirstChildOfClass("ParticleEmitter")
		if pe then pe:Emit(4) end
	end

	local function destroyRain()
		for _, d in ipairs(drops) do d.part:Destroy() end
		table.clear(drops)
		for _, s in ipairs(splashPool) do s:Destroy() end
		table.clear(splashPool)
		table.clear(activeSplashes)
		for _, m in ipairs(mistParts) do m:Destroy() end
		table.clear(mistParts)
	end

	local function buildRain(n: number, root: BasePart)
		destroyRain()
		rnRayParams.FilterDescendantsInstances = { rnFolder }
		for _ = 1, SPLASH_POOL do
			local s = Instance.new("Part")
			s.Size = Vector3.new(0.12, 0.03, 0.12)
			s.Material = Enum.Material.Glass
			s.Color = Color3.fromRGB(200, 225, 255)
			s.Transparency = 0.4
			s.Anchored = true; s.CanCollide = false; s.CastShadow = false
			s.Parent = rnFolder
			local pe = Instance.new("ParticleEmitter")
			pe.Texture = "rbxasset://textures/particles/sparkles_main.dds"
			pe.Size = NumberSequence.new(0.06, 0)
			pe.Lifetime = NumberRange.new(0.15, 0.3)
			pe.Rate = 0
			pe.Speed = NumberRange.new(0.5, 1.5)
			pe.Transparency = NumberSequence.new(0.2, 1)
			pe.Color = ColorSequence.new(Color3.fromRGB(180, 210, 255))
			pe.Parent = s
			table.insert(splashPool, s)
		end
		local rootPos = root.Position
		for _ = 1, n do
			local angle = math.random() * math.pi * 2
			local radius = math.sqrt(math.random()) * rnRadius:Get()
			local drop = Instance.new("Part")
			local len = 1.8 + math.random() * 1.2
			drop.Size = Vector3.new(0.04, len, 0.04)
			drop.Material = Enum.Material.Glass
			drop.Color = Color3.fromRGB(190, 220, 255)
			drop.Transparency = 0.3 + math.random() * 0.2
			drop.CanCollide = false; drop.Anchored = true; drop.CastShadow = false
			drop.Parent = rnFolder
			local spawnX = rootPos.X + math.cos(angle) * radius
			local spawnY = rootPos.Y + math.random(5, RAIN_HEIGHT)
			local spawnZ = rootPos.Z + math.sin(angle) * radius
			table.insert(drops, {
				part = drop, x = spawnX, y = spawnY, z = spawnZ,
				speed = rnSpeed:Get() + math.random(-18, 18),
				groundY = spawnY - 100, rayTimer = math.random(1, 8), len = len,
			})
		end
		for _ = 1, MIST_COUNT do
			local mist = Instance.new("Part")
			mist.Size = Vector3.new(2 + math.random() * 3, 0.3 + math.random() * 0.5, 2 + math.random() * 3)
			mist.Shape = Enum.PartType.Ball
			mist.Material = Enum.Material.Glass
			mist.Color = Color3.fromRGB(180, 200, 220)
			mist.Transparency = 0.7
			mist.Anchored = true; mist.CanCollide = false; mist.CastShadow = false
			mist.Parent = rnFolder
			table.insert(mistParts, mist)
		end
	end

	local rnFrame = 0
	local rsRn = RunService.Heartbeat:Connect(function(dt: number)
		if not rnEnabled:Get() then
			if #drops > 0 then destroyRain() end
			return
		end
		local root = getRootPart()
		if not root then return end
		local n = math.floor(rnCount:Get())
		if #drops ~= n then buildRain(n, root) end
		dt = math.min(dt, 0.05)
		rnFrame += 1
		local rootPos = root.Position
		local windX = rnWind:Get() / 10
		for i, mist in ipairs(mistParts) do
			local mAngle = (i / MIST_COUNT) * math.pi * 2 + rnFrame * 0.002
			local mDist = 15 + math.sin(rnFrame * 0.003 + i) * 10
			local mY = rootPos.Y + math.sin(rnFrame * 0.01 + i) * 2 - 1.5
			mist.Position = rootPos + Vector3.new(math.cos(mAngle) * mDist + windX * rnFrame * 0.01, mY, math.sin(mAngle) * mDist)
			mist.Transparency = 0.65 + math.sin(rnFrame * 0.02 + i) * 0.15
		end
		for s, timer in pairs(activeSplashes) do
			timer += dt
			local t = math.min(timer / 0.28, 1)
			local ease = 1 - (1 - t) * (1 - t)
			s.Size = Vector3.new(0.1 + 0.8 * ease, 0.03, 0.1 + 0.8 * ease)
			s.Transparency = 0.2 + 0.8 * ease
			if t >= 1 then activeSplashes[s] = nil else activeSplashes[s] = timer end
		end
		for _, d in ipairs(drops) do
			d.x += windX * dt
			d.y -= d.speed * dt
			d.rayTimer += 1
			if d.rayTimer >= 8 then
				d.rayTimer = 0
				d.groundY = getGroundY(Vector3.new(d.x, d.y + 5, d.z))
			end
			if d.y <= d.groundY + 1.1 then
				playSplash(Vector3.new(d.x, d.groundY, d.z))
				local angle = math.random() * math.pi * 2
				local radius = math.sqrt(math.random()) * rnRadius:Get()
				d.x = rootPos.X + math.cos(angle) * radius
				d.y = rootPos.Y + RAIN_HEIGHT
				d.z = rootPos.Z + math.sin(angle) * radius
				d.groundY = d.y - 100
				d.rayTimer = 0
				d.len = 1.8 + math.random() * 1.2
			end
			d.part.Size = Vector3.new(0.04, d.len, 0.04)
			d.part.CFrame = CFrame.new(d.x, d.y, d.z) * CFrame.Angles(math.rad(windX * 3), 0, 0)
		end
	end)
	table.insert(cleanups, function()
		rsRn:Disconnect()
		destroyRain()
	end)

	CFG.toggles.rn_enabled = rnEnabled
	CFG.sliders.rn_count = rnCount; CFG.sliders.rn_radius = rnRadius
	CFG.sliders.rn_speed = rnSpeed; CFG.sliders.rn_wind = rnWind
end

----------------------------------------------------------------------------------
-- SECTION 5o: Fireflies
----------------------------------------------------------------------------------
do
	local ffSec = newSection(pgWorld, "Fireflies")
	local ffEnabled = ffSec:Toggle({ Name = "Enabled", Default = false, Flag = "ff_enabled" })
	local ffSettings = settingsOf(ffSec, ffEnabled)
	local ffCount   = ffSettings:Slider({ Name = "Count", Min = 5, Max = 60, Step = 5, Default = 35, Flag = "ff_count" })
	local ffMinDist = ffSettings:Slider({ Name = "Min distance", Min = 10, Max = 60, Step = 5, Default = 35, Flag = "ff_mindist" })
	local ffMaxDist = ffSettings:Slider({ Name = "Max distance", Min = 20, Max = 100, Step = 5, Default = 65, Flag = "ff_maxdist" })

	local ffFolder = Instance.new("Folder")
	ffFolder.Name = "MisanthropyFireflies"
	ffFolder.Parent = Workspace
	table.insert(cleanups, function() if ffFolder then ffFolder:Destroy() end end)

	local FF_MIN_HEIGHT, FF_MAX_HEIGHT = 5, 20

	type Firefly = {
		part: BasePart, light: PointLight, baseSize: number,
		rawPos: Vector3, pos: Vector3, targetOffset: Vector3, velocity: Vector3,
		maxSpeed: number, maxForce: number, flutterStrength: number, flutterSpeed: number,
		seedX: number, seedY: number, seedZ: number, pulseSpeed: number, phase: number,
	}
	local fireflies: { Firefly } = {}

	local function ffRandomOffset(minDist: number, maxDist: number): Vector3
		local angle = math.random() * math.pi * 2
		local dist = math.random(minDist, maxDist)
		local height = math.random(FF_MIN_HEIGHT, FF_MAX_HEIGHT)
		return Vector3.new(math.cos(angle) * dist, height, math.sin(angle) * dist)
	end

	local function destroyFireflies()
		for _, f in ipairs(fireflies) do f.part:Destroy() end
		table.clear(fireflies)
	end

	local function buildFireflies(n: number, root: BasePart)
		destroyFireflies()
		local minDist, maxDist = ffMinDist:Get(), ffMaxDist:Get()
		for _ = 1, n do
			local hue = math.random(65, 88) / 360
			local color = Color3.fromHSV(hue, 0.9, 1)
			local part = Instance.new("Part")
			part.Shape = Enum.PartType.Ball
			local baseSize = (math.random(80, 140) / 100) / 1.56
			part.Size = Vector3.new(baseSize, baseSize, baseSize)
			part.Material = Enum.Material.Neon
			part.Color = color
			part.Anchored = true
			part.CanCollide = false; part.CanQuery = false; part.CanTouch = false; part.CastShadow = false
			part.Parent = ffFolder
			local light = Instance.new("PointLight")
			light.Color = color; light.Range = math.random(9, 14); light.Brightness = 2.2
			light.Parent = part
			local pollen = Instance.new("ParticleEmitter")
			pollen.Texture = "rbxasset://textures/particles/sparkles_main.dds"
			pollen.Color = ColorSequence.new(color)
			pollen.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.3), NumberSequenceKeypoint.new(1, 0) })
			pollen.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.05), NumberSequenceKeypoint.new(0.8, 0.5), NumberSequenceKeypoint.new(1, 1) })
			pollen.Lifetime = NumberRange.new(0.8, 1.6)
			pollen.Rate = 10
			pollen.Speed = NumberRange.new(0.05, 0.4)
			pollen.SpreadAngle = Vector2.new(360, 360)
			pollen.LightEmission = 1; pollen.LightInfluence = 0
			pollen.Parent = part
			local startOffset = ffRandomOffset(minDist, maxDist)
			part.CFrame = CFrame.new(root.Position + startOffset)
			table.insert(fireflies, {
				part = part, light = light, baseSize = baseSize,
				rawPos = startOffset, pos = startOffset, targetOffset = ffRandomOffset(minDist, maxDist), velocity = Vector3.zero,
				maxSpeed = math.random(35, 70) / 10, maxForce = math.random(20, 40) / 10,
				flutterStrength = math.random(10, 22) / 10, flutterSpeed = math.random(5, 10) / 10,
				seedX = math.random() * 50000, seedY = math.random() * 50000, seedZ = math.random() * 50000,
				pulseSpeed = math.random(2, 4), phase = math.random() * math.pi * 2,
			})
		end
	end

	local lastFfCount = 0
	local rsFf = RunService.RenderStepped:Connect(function(dt: number)
		if not ffEnabled:Get() then
			if #fireflies > 0 then destroyFireflies() end
			return
		end
		local root = getRootPart()
		if not root then return end
		local n = math.floor(ffCount:Get())
		if n ~= lastFfCount or #fireflies == 0 then
			lastFfCount = n
			buildFireflies(n, root)
		end
		local rootPos = root.Position
		local gameTime = os.clock()
		local minDist, maxDist = ffMinDist:Get(), ffMaxDist:Get()
		for _, f in ipairs(fireflies) do
			local toTarget = f.targetOffset - f.rawPos
			if toTarget.Magnitude < 5 then f.targetOffset = ffRandomOffset(minDist, maxDist) end
			local desired = toTarget.Unit * f.maxSpeed
			local steer = desired - f.velocity
			if steer.Magnitude > f.maxForce then steer = steer.Unit * f.maxForce end
			local tt = gameTime * f.flutterSpeed
			local flutter = Vector3.new(math.noise(tt, f.seedX), math.noise(tt, f.seedY), math.noise(tt, f.seedZ)) * f.flutterStrength
			f.velocity += (steer + flutter) * dt
			if f.velocity.Magnitude > f.maxSpeed then f.velocity = f.velocity.Unit * f.maxSpeed end
			f.rawPos += f.velocity * dt
			local relY = math.clamp(f.rawPos.Y, FF_MIN_HEIGHT, FF_MAX_HEIGHT)
			local hVec = Vector2.new(f.rawPos.X, f.rawPos.Z)
			local hDist = hVec.Magnitude
			if hDist < minDist or hDist > maxDist then
				local dir = hDist == 0 and Vector2.new(1, 0) or hVec.Unit
				hVec = dir * math.clamp(hDist, minDist, maxDist)
			end
			f.rawPos = Vector3.new(hVec.X, relY, hVec.Y)
			f.pos = f.pos:Lerp(f.rawPos, 1 - math.exp(-6 * dt))
			f.part.CFrame = CFrame.new(rootPos + f.pos)
			local pulse = math.sin(gameTime * f.pulseSpeed + f.phase)
			local glowPulse = 0.6 + math.sin(gameTime * f.pulseSpeed * 0.7 + f.phase) * 0.4
			f.light.Brightness = 1.5 + pulse * 0.8
			f.light.Range = 8 + glowPulse * 5
			local scale = f.baseSize + (pulse * f.baseSize * 0.15)
			f.part.Size = Vector3.new(scale, scale, scale)
			f.part.Color = Color3.fromHSV((65 + glowPulse * 20) / 360, 0.9, 0.8 + glowPulse * 0.2)
		end
	end)
	table.insert(cleanups, function()
		rsFf:Disconnect()
		destroyFireflies()
	end)

	CFG.toggles.ff_enabled = ffEnabled
	CFG.sliders.ff_count = ffCount; CFG.sliders.ff_mindist = ffMinDist; CFG.sliders.ff_maxdist = ffMaxDist
end

----------------------------------------------------------------------------------
-- SECTION 5p: Snowfall
----------------------------------------------------------------------------------
do
	local snSec = newSection(pgWorld, "Snowfall")
	local snEnabled = snSec:Toggle({ Name = "Enabled", Default = false, Flag = "sn_enabled" })
	local snSettings = settingsOf(snSec, snEnabled)
	local snIntensity = snSettings:Slider({ Name = "Intensity", Min = 10, Max = 300, Step = 10, Default = 110, Flag = "sn_intensity" })
	local snHeight    = snSettings:Slider({ Name = "Height", Min = 20, Max = 150, Step = 5, Default = 80, Flag = "sn_height" })
	local snRadius    = snSettings:Slider({ Name = "Radius", Min = 15, Max = 100, Step = 5, Default = 60, Flag = "sn_radius" })
	local snFallSpeed = snSettings:Slider({ Name = "Fall speed", Min = 5, Max = 60, Step = 5, Default = 30, Suffix = "ds", Flag = "sn_fallspeed" })
	local snWind      = snSettings:Slider({ Name = "Wind", Min = 0, Max = 50, Step = 5, Default = 15, Suffix = "ds", Flag = "sn_wind" })

	local SnTweenService = game:GetService("TweenService")
	local snFolder = Instance.new("Folder")
	snFolder.Name = "MisanthropySnow"
	snFolder.Parent = Workspace
	table.insert(cleanups, function() if snFolder then snFolder:Destroy() end end)

	local SNOW_POOL_SIZE = 350
	local snowPool: { Part } = {}
	local snowPoolReady = false

	local function initSnowPool()
		if snowPoolReady then return end
		snowPoolReady = true
		for _ = 1, SNOW_POOL_SIZE do
			local flake = Instance.new("Part")
			flake.Shape = Enum.PartType.Ball
			flake.Size = Vector3.new(0.2, 0.2, 0.2)
			flake.Material = Enum.Material.Snow
			flake.Color = Color3.new(1, 1, 1)
			flake.CanCollide = false; flake.Anchored = true; flake.CastShadow = false
			flake.Parent = nil
			table.insert(snowPool, flake)
		end
	end

	local function getFlake(): Part?
		if #snowPool > 0 then return table.remove(snowPool) end
		return nil
	end

	local function returnFlake(flake: Part)
		flake.Parent = nil
		if #snowPool < SNOW_POOL_SIZE then table.insert(snowPool, flake) else flake:Destroy() end
	end

	local function spawnFlake(root: BasePart)
		local flake = getFlake()
		if not flake then return end
		local height = snHeight:Get()
		local radius = snRadius:Get()
		local spawnPos = root.Position + Vector3.new(0, height, 0)
		local rx = math.random(-radius * 10, radius * 10) / 10
		local rz = math.random(-radius * 10, radius * 10) / 10
		local startPos = spawnPos + Vector3.new(rx, 0, rz)
		local fallTime = (snFallSpeed:Get() / 10) + math.random() * 0.6
		local wind = Vector3.new(snWind:Get() / 10, 0, 0) * fallTime
		flake.Position = startPos
		flake.Transparency = 0.2
		flake.Parent = snFolder
		local endPos = startPos - Vector3.new(0, height + 30, 0) + wind
		local sway = Vector3.new(math.random(-8, 8), 0, math.random(-8, 8))
		local tween = SnTweenService:Create(flake, TweenInfo.new(fallTime, Enum.EasingStyle.Linear), { Position = endPos + sway, Transparency = 1 })
		tween.Completed:Connect(function() returnFlake(flake) end)
		tween:Play()
	end

	local lastSnSpawn = 0
	local rsSn = RunService.Heartbeat:Connect(function(dt: number)
		if not snEnabled:Get() then return end
		local root = getRootPart()
		if not root then return end
		initSnowPool()
		lastSnSpawn += dt
		if lastSnSpawn >= 0.05 then
			lastSnSpawn = 0
			local count = math.clamp(math.floor(snIntensity:Get() / 20), 1, 10)
			for _ = 1, count do spawnFlake(root) end
		end
	end)
	table.insert(cleanups, function()
		rsSn:Disconnect()
		for _, f in ipairs(snowPool) do f:Destroy() end
		table.clear(snowPool)
	end)

	CFG.toggles.sn_enabled = snEnabled
	CFG.sliders.sn_intensity = snIntensity; CFG.sliders.sn_height = snHeight; CFG.sliders.sn_radius = snRadius
	CFG.sliders.sn_fallspeed = snFallSpeed; CFG.sliders.sn_wind = snWind
end

----------------------------------------------------------------------------------
-- SECTION 5q: StarFall
----------------------------------------------------------------------------------
do
	local sfSec = newSection(pgWorld, "StarFall")
	local sfEnabled = sfSec:Toggle({ Name = "Enabled", Default = false, Flag = "sf_enabled" })
	local sfColor   = newColorpicker(sfSec, { Name = "Color", Default = Color3.fromRGB(255, 230, 150), Alpha = 1, Flag = "sf_color" })
	local sfSettings = settingsOf(sfSec, sfEnabled)
	local sfMaxStars = sfSettings:Slider({ Name = "Max active", Min = 5, Max = 60, Step = 5, Default = 35, Flag = "sf_maxstars" })
	local sfInterval = sfSettings:Slider({ Name = "Spawn interval", Min = 50, Max = 500, Step = 10, Default = 100, Suffix = "ms", Flag = "sf_interval" })
	local sfSpeed    = sfSettings:Slider({ Name = "Speed", Min = 40, Max = 250, Step = 10, Default = 125, Flag = "sf_speed" })
	local sfRadius   = sfSettings:Slider({ Name = "Radius", Min = 20, Max = 200, Step = 10, Default = 100, Flag = "sf_radius" })

	local sfFolder = Instance.new("Folder")
	sfFolder.Name = "MisanthropyStarFall"
	sfFolder.Parent = Workspace
	table.insert(cleanups, function() if sfFolder then sfFolder:Destroy() end end)

	local SfTweenService = game:GetService("TweenService")
	local sfRayParams = RaycastParams.new()
	sfRayParams.FilterType = Enum.RaycastFilterType.Exclude

	type Star = { part: BasePart, pos: Vector3, dir: Vector3, speed: number, spawnTime: number, dying: boolean }
	local stars: { Star } = {}

	local function impactExplosion(pos: Vector3, normal: Vector3, color: Color3)
		local flash = Instance.new("Part")
		flash.Shape = Enum.PartType.Ball
		flash.Size = Vector3.new(0.5, 0.5, 0.5)
		flash.Material = Enum.Material.Neon
		flash.Color = Color3.new(1, 1, 1)
		flash.Transparency = 0.3
		flash.Anchored = true; flash.CanCollide = false; flash.CanQuery = false
		flash.Position = pos
		flash.Parent = sfFolder
		SfTweenService:Create(flash, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = Vector3.new(4, 4, 4), Transparency = 1 }):Play()
		task.delay(0.3, function() flash:Destroy() end)

		local ring = Instance.new("Part")
		ring.Shape = Enum.PartType.Cylinder
		ring.Size = Vector3.new(0.05, 0.1, 0.1)
		ring.Material = Enum.Material.Neon
		ring.Color = color
		ring.Transparency = 0.15
		ring.Anchored = true; ring.CanCollide = false; ring.CanQuery = false
		ring.CFrame = CFrame.lookAt(pos, pos + normal) * CFrame.Angles(math.rad(90), 0, 0)
		ring.Parent = sfFolder
		SfTweenService:Create(ring, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = Vector3.new(0.05, 10, 10), Transparency = 1 }):Play()
		task.delay(0.4, function() ring:Destroy() end)

		local sparkPart = Instance.new("Part")
		sparkPart.Size = Vector3.new(0.1, 0.1, 0.1)
		sparkPart.Transparency = 1
		sparkPart.Anchored = true; sparkPart.CanCollide = false
		sparkPart.Position = pos
		sparkPart.Parent = sfFolder
		local emitter = Instance.new("ParticleEmitter")
		emitter.Color = ColorSequence.new(color)
		emitter.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.45), NumberSequenceKeypoint.new(0.3, 0.3), NumberSequenceKeypoint.new(1, 0) })
		emitter.Lifetime = NumberRange.new(0.35, 0.8)
		emitter.Speed = NumberRange.new(15, 35)
		emitter.SpreadAngle = Vector2.new(-180, 180)
		emitter.Acceleration = Vector3.new(0, -25, 0)
		emitter.Drag = 2
		emitter.LightEmission = 1.5
		emitter.Rate = 0
		emitter.Parent = sparkPart
		emitter:Emit(30)
		task.delay(1, function() sparkPart:Destroy() end)
	end

	local function killStar(star: Star)
		if star.dying then return end
		star.dying = true
		SfTweenService:Create(star.part, TweenInfo.new(0.25), { Size = Vector3.new(0, 0, 0), Transparency = 1 }):Play()
		task.delay(0.6, function() star.part:Destroy() end)
		local idx = table.find(stars, star)
		if idx then table.remove(stars, idx) end
	end

	local function spawnStar(root: BasePart)
		if #stars >= sfMaxStars:Get() then killStar(stars[1]) end
		local center = root.Position
		local angle = math.random() * math.pi * 2
		local distance = math.random(20, sfRadius:Get())
		local targetPos = center + Vector3.new(math.cos(angle) * distance, 0, math.sin(angle) * distance)
		local slowRot = os.clock() * 0.05
		local baseDir = Vector3.new(math.cos(slowRot) * 0.75, -1, math.sin(slowRot) * 0.75).Unit
		local wobble = Vector3.new((math.random() - 0.5) * 0.15, 0, (math.random() - 0.5) * 0.15)
		local dir = (baseDir + wobble).Unit
		local spawnPos = targetPos - (dir * (125 / -dir.Y))
		local color = sfColor:Get()

		local star = Instance.new("Part")
		star.Name = "ShootingStar"
		star.Size = Vector3.new(1.8, 1.8, 1.8)
		star.Shape = Enum.PartType.Ball
		star.Color = color
		star.Material = Enum.Material.Neon
		star.Anchored = true; star.CanCollide = false; star.CanQuery = false; star.CanTouch = false; star.CastShadow = false
		star.Position = spawnPos
		star.Parent = sfFolder
		local glow = Instance.new("PointLight")
		glow.Color = color; glow.Brightness = 4; glow.Range = 12; glow.Shadows = false
		glow.Parent = star
		local a0 = Instance.new("Attachment"); a0.Position = Vector3.new(0, 0.9, 0); a0.Parent = star
		local a1 = Instance.new("Attachment"); a1.Position = Vector3.new(0, -0.9, 0); a1.Parent = star
		local trail = Instance.new("Trail")
		trail.Attachment0 = a0; trail.Attachment1 = a1
		trail.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, color), ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0)) })
		trail.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.5, 0.2), NumberSequenceKeypoint.new(1, 0.9) })
		trail.Lifetime = 0.55
		trail.LightEmission = 1.5; trail.LightInfluence = 0
		trail.WidthScale = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1.6), NumberSequenceKeypoint.new(1, 0) })
		trail.Parent = star

		table.insert(stars, { part = star, pos = spawnPos, dir = dir, speed = sfSpeed:Get() * (0.85 + math.random() * 0.3), spawnTime = os.clock(), dying = false })
	end

	local lastSfSpawn = 0
	local rsSf = RunService.RenderStepped:Connect(function(dt: number)
		if not sfEnabled:Get() then
			if #stars > 0 then
				for _, s in ipairs(stars) do s.part:Destroy() end
				table.clear(stars)
			end
			return
		end
		local root = getRootPart()
		if not root then return end
		sfRayParams.FilterDescendantsInstances = { sfFolder }

		local now = os.clock()
		if (now - lastSfSpawn) >= (sfInterval:Get() / 1000) then
			lastSfSpawn = now
			spawnStar(root)
		end

		for i = #stars, 1, -1 do
			local star = stars[i]
			if star.dying then continue end
			if now - star.spawnTime >= 4.5 then
				killStar(star)
				continue
			end
			star.pos += star.dir * star.speed * dt
			star.part.Position = star.pos
			local ray = Workspace:Raycast(star.pos, star.dir * (star.speed * dt * 2.5), sfRayParams)
			if ray then
				impactExplosion(ray.Position, ray.Normal, sfColor:Get())
				killStar(star)
			end
		end
	end)
	table.insert(cleanups, function()
		rsSf:Disconnect()
		for _, s in ipairs(stars) do s.part:Destroy() end
		table.clear(stars)
	end)

	CFG.toggles.sf_enabled = sfEnabled
	CFG.sliders.sf_maxstars = sfMaxStars; CFG.sliders.sf_interval = sfInterval
	CFG.sliders.sf_speed = sfSpeed; CFG.sliders.sf_radius = sfRadius
	CFG.colors.sf_color = sfColor
end

----------------------------------------------------------------------------------
-- SECTION 5r: Thunder
----------------------------------------------------------------------------------
do
	local thSec = newSection(pgWorld, "Thunder")
	local thEnabled = thSec:Toggle({ Name = "Enabled", Default = false, Flag = "th_enabled" })
	local thColor   = newColorpicker(thSec, { Name = "Color", Default = Color3.fromRGB(190, 225, 255), Alpha = 1, Flag = "th_color" })
	local thSettings = settingsOf(thSec, thEnabled)
	local thMinInterval = thSettings:Slider({ Name = "Min interval", Min = 5, Max = 100, Step = 5, Default = 20, Suffix = "ds", Flag = "th_mininterval" })
	local thMaxInterval = thSettings:Slider({ Name = "Max interval", Min = 10, Max = 200, Step = 5, Default = 50, Suffix = "ds", Flag = "th_maxinterval" })
	local thRadius       = thSettings:Slider({ Name = "Strike radius", Min = 20, Max = 200, Step = 10, Default = 100, Flag = "th_radius" })

	local thFolder = Instance.new("Folder")
	thFolder.Name = "MisanthropyThunder"
	thFolder.Parent = Workspace
	table.insert(cleanups, function() if thFolder then thFolder:Destroy() end end)

	local ThTweenService = game:GetService("TweenService")
	local ThLighting = game:GetService("Lighting")
	local thRayParams = RaycastParams.new()
	thRayParams.FilterType = Enum.RaycastFilterType.Exclude

	local function drawSegment(p1: Vector3, p2: Vector3, thickness: number, color: Color3): Part
		local distance = (p1 - p2).Magnitude
		local part = Instance.new("Part")
		part.Size = Vector3.new(thickness, thickness, distance)
		part.CFrame = CFrame.lookAt((p1 + p2) / 2, p2)
		part.Color = color
		part.Material = Enum.Material.Neon
		part.Anchored = true; part.CanCollide = false; part.CanQuery = false; part.CanTouch = false; part.CastShadow = false
		part.Transparency = 1
		part.Parent = thFolder
		task.delay(2.5, function() part:Destroy() end)
		return part
	end

	local function safeTween(obj: Instance, info: TweenInfo, props: any): Tween?
		local ok, tw = pcall(function() return ThTweenService:Create(obj, info, props) end)
		if ok and tw then tw:Play(); return tw end
		return nil
	end

	local function generateBranch(startPos: Vector3, endPos: Vector3, segments: number, displacement: number, thickness: number, isBranch: boolean, color: Color3, mainParts: { Part }, branchParts: { Part })
		local points = { startPos }
		for i = 2, segments do
			local t = (i - 1) / (segments - 1)
			local basePos = startPos:Lerp(endPos, t)
			if i < segments then
				local offset = Vector3.new(math.random(-displacement, displacement), math.random(-displacement * 0.3, displacement * 0.3), math.random(-displacement, displacement))
				points[i] = basePos + offset
			else
				points[i] = endPos
			end
		end
		for i = 1, #points - 1 do
			local p1, p2 = points[i], points[i + 1]
			local curThickness = isBranch and (thickness * 0.5) or thickness
			local part = drawSegment(p1, p2, curThickness, color)
			table.insert(isBranch and branchParts or mainParts, part)
			if not isBranch and i > 2 and i < #points - 1 and math.random() < 0.25 then
				local branchDir = ((p2 - p1).Unit + Vector3.new(math.random(-10, 10) / 10, -0.4, math.random(-10, 10) / 10)).Unit
				local branchLength = (endPos - startPos).Magnitude * 0.35
				generateBranch(p2, p2 + branchDir * branchLength, 5, displacement * 0.5, thickness, true, color, mainParts, branchParts)
			end
		end
	end

	local function animateLightning(mainParts: { Part }, branchParts: { Part })
		for _, part in ipairs(mainParts) do
			if part.Parent then safeTween(part, TweenInfo.new(0.04, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Transparency = 0 }) end
			task.wait(0.015)
		end
		task.wait(0.06)
		for _, part in ipairs(branchParts) do
			if part.Parent then safeTween(part, TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Transparency = 0.1 }) end
		end
		task.wait(0.06)
		for _, t in ipairs({ 0.2, 0, 0.25, 0 }) do
			for _, part in ipairs(mainParts) do
				if part.Parent then safeTween(part, TweenInfo.new(0.04, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Transparency = t }) end
			end
			task.wait(0.04)
		end
		task.wait(0.2)
		local allParts = {}
		for _, p in ipairs(mainParts) do table.insert(allParts, p) end
		for _, p in ipairs(branchParts) do table.insert(allParts, p) end
		for _, part in ipairs(allParts) do
			if part.Parent then
				local tw = safeTween(part, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Transparency = 1 })
				if tw then tw.Completed:Connect(function() if part.Parent then part:Destroy() end end) end
			end
		end
	end

	local function groundImpact(pos: Vector3, normal: Vector3, color: Color3)
		local lightPart = Instance.new("Part")
		lightPart.Shape = Enum.PartType.Ball
		lightPart.Size = Vector3.new(0.1, 0.1, 0.1)
		lightPart.Color = Color3.new(1, 1, 1)
		lightPart.Material = Enum.Material.Neon
		lightPart.Position = pos
		lightPart.Anchored = true; lightPart.CanCollide = false; lightPart.Transparency = 1
		lightPart.Parent = thFolder
		local pointLight = Instance.new("PointLight")
		pointLight.Color = color; pointLight.Brightness = 0; pointLight.Range = 21
		pointLight.Parent = lightPart
		safeTween(pointLight, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Brightness = 10 })
		safeTween(lightPart, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = Vector3.new(14, 14, 14) })
		task.delay(0.12, function()
			if lightPart.Parent then
				safeTween(pointLight, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Brightness = 0 })
				safeTween(lightPart, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Size = Vector3.new(0.1, 0.1, 0.1), Transparency = 1 })
				task.delay(0.4, function() lightPart:Destroy() end)
			end
		end)
		local ring = Instance.new("Part")
		ring.Shape = Enum.PartType.Cylinder
		ring.Size = Vector3.new(0.05, 1, 1)
		ring.Color = color
		ring.Material = Enum.Material.Neon
		ring.Transparency = 0.3
		ring.Anchored = true; ring.CanCollide = false
		ring.CFrame = CFrame.lookAt(pos, pos + normal) * CFrame.Angles(math.rad(90), 0, 0)
		ring.Parent = thFolder
		safeTween(ring, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = Vector3.new(0.05, 28, 28), Transparency = 1 })
		task.delay(0.5, function() ring:Destroy() end)
		pcall(function()
			ThLighting.Brightness += 1
			task.delay(0.1, function() pcall(function() ThLighting.Brightness -= 1 end) end)
		end)
	end

	local function triggerStrike(root: BasePart)
		local center = root.Position
		local angle = math.random() * math.pi * 2
		local distance = math.random(20, thRadius:Get())
		local targetXZ = center + Vector3.new(math.cos(angle) * distance, 0, math.sin(angle) * distance)
		thRayParams.FilterDescendantsInstances = { thFolder }
		local rayResult = Workspace:Raycast(targetXZ + Vector3.new(0, 400, 0), Vector3.new(0, -800, 0), thRayParams)
		local endPos = rayResult and rayResult.Position or targetXZ
		local normal = rayResult and rayResult.Normal or Vector3.new(0, 1, 0)
		local startPos = endPos + Vector3.new(math.random(-40, 40), 300, math.random(-40, 40))
		local color = thColor:Get()
		local mainParts, branchParts = {}, {}
		generateBranch(startPos, endPos, 11, 13, 1.2, false, color, mainParts, branchParts)
		groundImpact(endPos, normal, color)
		task.spawn(animateLightning, mainParts, branchParts)
	end

	local thLoopThread: thread? = nil
	local rsTh = RunService.Heartbeat:Connect(function()
		if thEnabled:Get() and not thLoopThread then
			thLoopThread = task.spawn(function()
				while thEnabled:Get() do
					local waitTime = math.random(thMinInterval:Get(), thMaxInterval:Get()) / 10
					task.wait(waitTime)
					if not thEnabled:Get() then break end
					local root = getRootPart()
					if root then pcall(triggerStrike, root) end
				end
				thLoopThread = nil
			end)
		end
	end)
	table.insert(cleanups, function()
		rsTh:Disconnect()
		if thLoopThread then task.cancel(thLoopThread); thLoopThread = nil end
	end)

	CFG.toggles.th_enabled = thEnabled
	CFG.sliders.th_mininterval = thMinInterval; CFG.sliders.th_maxinterval = thMaxInterval
	CFG.sliders.th_radius = thRadius
	CFG.colors.th_color = thColor
end

----------------------------------------------------------------------------------
-- SECTION 5s: Leaves Fall / Cherry Blossoms
----------------------------------------------------------------------------------
-- shared helper: leaves and blossoms use identical fall/wind/fade logic, just different visuals
do
	local function buildFallingDebris(sectionName: string, folderName: string, partName: string, meshScale: Vector3, colors: { Color3 }, cfg: any)
		local sec = newSection(pgWorld, sectionName)
		local enabled = sec:Toggle({ Name = "Enabled", Default = false, Flag = cfg.prefix .. "_enabled" })
		local settings = settingsOf(sec, enabled)
		local count     = settings:Slider({ Name = "Max count", Min = 10, Max = 200, Step = 10, Default = cfg.maxCount, Flag = cfg.prefix .. "_count" })
		local fallSpeed = settings:Slider({ Name = "Fall speed", Min = 5, Max = 100, Step = 5, Default = cfg.fallSpeed, Suffix = "ds", Flag = cfg.prefix .. "_fallspeed" })
		local radius    = settings:Slider({ Name = "Spawn radius", Min = 15, Max = 100, Step = 5, Default = cfg.radius, Flag = cfg.prefix .. "_radius" })
		local windX     = settings:Slider({ Name = "Wind X", Min = -50, Max = 50, Step = 5, Default = cfg.windX, Suffix = "ds", Flag = cfg.prefix .. "_windx" })
		local windZ     = settings:Slider({ Name = "Wind Z", Min = -50, Max = 50, Step = 5, Default = cfg.windZ, Suffix = "ds", Flag = cfg.prefix .. "_windz" })

		local folder = Instance.new("Folder")
		folder.Name = folderName
		folder.Parent = Workspace
		table.insert(cleanups, function() if folder then folder:Destroy() end end)

		type Piece = {
			inst: BasePart, pos: Vector3, age: number, lifetime: number,
			swaySpeed: number, swayWidth: number, rotSpeed: Vector3,
			spiralRadius: number, spiralSpeed: number, spiralPhase: number, turbPhase: number,
			grounded: boolean, groundTime: number, groundY: number,
		}
		local active: { Piece } = {}
		local windGust = Vector3.zero
		local windTime = 0

		local function spawnPiece(root: BasePart)
			if #active >= count:Get() then return end
			local piece = Instance.new("Part")
			piece.Name = partName
			piece.Size = Vector3.new(0.5, 0.05, 0.8)
			piece.Material = Enum.Material.SmoothPlastic
			piece.CanCollide = false; piece.CanTouch = false; piece.CastShadow = false; piece.Anchored = true
			piece.Reflectance = 0.12
			piece.Transparency = 1
			piece.Parent = folder
			local mesh = Instance.new("SpecialMesh")
			mesh.MeshType = Enum.MeshType.Sphere
			mesh.Scale = meshScale * (0.5 + math.random() * 1.1)
			mesh.Parent = piece
			local baseColor = colors[math.random(1, #colors)]
			local brightness = 0.75 + math.random() * 0.5
			piece.Color = Color3.new(
				math.clamp(baseColor.R * brightness, 0, 1),
				math.clamp(baseColor.G * brightness, 0, 1),
				math.clamp(baseColor.B * brightness, 0, 1)
			)
			if math.random() < 0.28 then
				local gl = Instance.new("PointLight")
				gl.Color = piece.Color; gl.Brightness = 0.35; gl.Range = 3; gl.Shadows = false
				gl.Parent = piece
			end
			local r = radius:Get()
			local rootPos = root.Position
			local offset = Vector3.new(math.random(-r, r), r * 0.9 + math.random(-8, 12), math.random(-r, r))
			piece.Position = rootPos + offset
			piece.Rotation = Vector3.new(math.random(0, 360), math.random(0, 360), math.random(0, 360))
			table.insert(active, {
				inst = piece, pos = piece.Position, age = 0, lifetime = cfg.lifetime + math.random(-3, 4),
				swaySpeed = math.random(8, 30) / 10, swayWidth = math.random(6, 25) / 10,
				rotSpeed = Vector3.new(math.random(-150, 150), math.random(-80, 80), math.random(-150, 150)),
				spiralRadius = math.random(8, 60) / 10, spiralSpeed = math.random(4, 22) / 10, spiralPhase = math.random(0, 628) / 100,
				turbPhase = math.random(0, 628) / 100,
				grounded = false, groundTime = 0, groundY = rootPos.Y - 3 - math.random(0, 30) / 10,
			})
		end

		local function updatePieces(dt: number)
			local fs = fallSpeed:Get() / 10
			local wind = Vector3.new(windX:Get() / 10, 0, windZ:Get() / 10)
			for i = #active, 1, -1 do
				local d = active[i]
				local inst = d.inst
				if not inst.Parent then table.remove(active, i); continue end
				d.age += dt
				local fadeIn = math.min(d.age / 0.8, 1); fadeIn = fadeIn * fadeIn * (3 - 2 * fadeIn)
				local fadeOut = 1
				if d.grounded then
					fadeOut = math.max(1 - d.groundTime / 3.5, 0); fadeOut = fadeOut * fadeOut
				elseif d.age > d.lifetime - 2 then
					local t = (d.age - (d.lifetime - 2)) / 2
					fadeOut = math.max(1 - t * t, 0)
				end
				inst.Transparency = 1 - (fadeIn * fadeOut)
				if d.grounded then
					d.groundTime += dt
					local sink = math.min(d.groundTime / 3.5, 1)
					inst.Position = Vector3.new(d.pos.X, d.groundY - sink * 0.3, d.pos.Z)
					if d.groundTime >= 3.5 then inst:Destroy(); table.remove(active, i) end
					continue
				end
				if d.age >= d.lifetime then inst:Destroy(); table.remove(active, i); continue end
				local turbX = math.sin(d.age * 2.3 + d.turbPhase) * 0.5 + math.sin(d.age * 5.7 + d.turbPhase * 1.3) * 0.2
				local turbZ = math.cos(d.age * 1.9 + d.turbPhase * 0.7) * 0.4 + math.cos(d.age * 4.2 + d.turbPhase * 1.7) * 0.15
				local spiralAngle = d.age * d.spiralSpeed + d.spiralPhase
				local spiralX, spiralZ = math.cos(spiralAngle) * d.spiralRadius, math.sin(spiralAngle) * d.spiralRadius
				local swayX = math.sin(d.age * d.swaySpeed) * d.swayWidth
				local swayZ = math.cos(d.age * d.swaySpeed * 0.65) * d.swayWidth
				local fallVector = Vector3.new(0, -fs, 0)
				local driftVector = wind + windGust + Vector3.new(swayX + spiralX * 0.3 + turbX, 0, swayZ + spiralZ * 0.3 + turbZ)
				d.pos += (fallVector + driftVector) * dt
				if d.pos.Y <= d.groundY then
					d.pos = Vector3.new(d.pos.X, d.groundY, d.pos.Z)
					d.grounded = true
					inst.CFrame = CFrame.new(d.pos) * CFrame.Angles(math.rad(math.random(-20, 20)), math.random() * 6.28, math.rad(math.random(-20, 20)))
					continue
				end
				inst.Position = d.pos
				local tumble = 1 + math.sin(d.age * 3) * 0.3
				inst.CFrame = CFrame.new(d.pos) * CFrame.Angles(
					math.rad(d.rotSpeed.X * d.age * 0.6 * tumble),
					math.rad(d.rotSpeed.Y * d.age * 0.25 * tumble),
					math.rad(d.rotSpeed.Z * d.age * 0.6 * tumble)
				)
			end
		end

		local function destroyAll()
			for _, d in ipairs(active) do d.inst:Destroy() end
			table.clear(active)
		end

		local lastSpawn = 0
		local rs = RunService.Heartbeat:Connect(function(dt: number)
			windTime += dt
			windGust = Vector3.new(
				math.sin(windTime * 0.5) * 3.5 + math.sin(windTime * 1.4) * 2,
				0,
				math.cos(windTime * 0.4) * 3 + math.sin(windTime * 1.8) * 1.5
			)
			if not enabled:Get() then
				if #active > 0 then destroyAll() end
				return
			end
			local root = getRootPart()
			if not root then return end
			lastSpawn += dt
			if lastSpawn >= 0.05 then
				lastSpawn = 0
				spawnPiece(root)
			end
			updatePieces(dt)
		end)
		table.insert(cleanups, function()
			rs:Disconnect()
			destroyAll()
		end)

		CFG.toggles[cfg.prefix .. "_enabled"] = enabled
		CFG.sliders[cfg.prefix .. "_count"] = count
		CFG.sliders[cfg.prefix .. "_fallspeed"] = fallSpeed
		CFG.sliders[cfg.prefix .. "_radius"] = radius
		CFG.sliders[cfg.prefix .. "_windx"] = windX
		CFG.sliders[cfg.prefix .. "_windz"] = windZ
	end

	buildFallingDebris("Leaves Fall", "MisanthropyLeaves", "AutumnLeaf", Vector3.new(1, 0.22, 1.6), {
		Color3.fromRGB(210, 85, 25), Color3.fromRGB(225, 165, 30), Color3.fromRGB(170, 50, 30),
		Color3.fromRGB(190, 120, 45), Color3.fromRGB(130, 80, 35), Color3.fromRGB(235, 180, 20),
	}, { prefix = "lf", maxCount = 95, fallSpeed = 55, radius = 55, windX = 15, windZ = 10, lifetime = 14 })

	buildFallingDebris("Cherry Blossoms", "MisanthropyPetals", "SakuraPetal", Vector3.new(1, 0.15, 1.8), {
		Color3.fromRGB(255, 200, 220), Color3.fromRGB(255, 180, 210), Color3.fromRGB(255, 220, 235),
		Color3.fromRGB(255, 160, 190), Color3.fromRGB(255, 210, 225), Color3.fromRGB(250, 190, 215),
	}, { prefix = "cb", maxCount = 85, fallSpeed = 18, radius = 50, windX = 20, windZ = 15, lifetime = 16 })
end

----------------------------------------------------------------------------------
-- SECTION 5t: Floating Lamps
----------------------------------------------------------------------------------
do
	local flSec = newSection(pgWorld, "Floating Lamps")
	local flEnabled = flSec:Toggle({ Name = "Enabled", Default = false, Flag = "fl_enabled" })
	local flSettings = settingsOf(flSec, flEnabled)
	local flCount  = flSettings:Slider({ Name = "Count", Min = 1, Max = 20, Step = 1, Default = 7, Flag = "fl_count" })
	local flRadius = flSettings:Slider({ Name = "Radius", Min = 15, Max = 80, Step = 5, Default = 40, Flag = "fl_radius" })
	local flHeight = flSettings:Slider({ Name = "Height", Min = 5, Max = 40, Step = 1, Default = 18, Flag = "fl_height" })

	local flFolder = Instance.new("Folder")
	flFolder.Name = "MisanthropyLamps"
	flFolder.Parent = Workspace
	table.insert(cleanups, function() if flFolder then flFolder:Destroy() end end)

	type Lamp = {
		cap: BasePart, body: BasePart, gold: BasePart, bottom: BasePart, fringes: { BasePart }, tassel: BasePart,
		flame: BasePart, hook: BasePart, chain: BasePart, light: PointLight,
		angle: number, radius: number, baseHeight: number,
		bobPhase: number, bobSpeed: number, bobAmp: number, orbitSpeed: number, orbitDir: number,
		swayPhase: number, flamePhase: number, fringePhase: number,
		targetPos: Vector3, currentPos: Vector3, velocity: Vector3,
	}
	local lamps: { Lamp } = {}

	local function makeLampPart(size: Vector3, color: Color3, material: Enum.Material): Part
		local p = Instance.new("Part")
		p.Size = size; p.Color = color; p.Material = material
		p.Anchored = true; p.CanCollide = false; p.CastShadow = false
		p.Parent = flFolder
		return p
	end

	local function destroyLamps()
		for _, l in ipairs(lamps) do
			l.cap:Destroy(); l.body:Destroy(); l.gold:Destroy(); l.bottom:Destroy()
			for _, fr in ipairs(l.fringes) do fr:Destroy() end
			l.tassel:Destroy(); l.flame:Destroy(); l.hook:Destroy(); l.chain:Destroy()
		end
		table.clear(lamps)
	end

	local function buildLamps(n: number, root: BasePart)
		destroyLamps()
		for i = 1, n do
			local cap = makeLampPart(Vector3.new(1.4, 0.2, 1.4), Color3.fromRGB(200, 45, 45), Enum.Material.SmoothPlastic)
			local body = makeLampPart(Vector3.new(1.2, 1.8, 1.2), Color3.fromRGB(255, 220, 150), Enum.Material.Neon)
			body.Transparency = 0.25
			local gold = makeLampPart(Vector3.new(1.3, 0.12, 1.3), Color3.fromRGB(220, 170, 50), Enum.Material.Metal)
			local bottom = makeLampPart(Vector3.new(1.4, 0.2, 1.4), Color3.fromRGB(200, 45, 45), Enum.Material.SmoothPlastic)
			local fringes: { BasePart } = {}
			for _ = 1, 6 do
				table.insert(fringes, makeLampPart(Vector3.new(0.06, 0.7, 0.06), Color3.fromRGB(220, 60, 60), Enum.Material.Fabric))
			end
			local tassel = makeLampPart(Vector3.new(0.1, 0.9, 0.1), Color3.fromRGB(200, 50, 50), Enum.Material.Fabric)
			local flame = makeLampPart(Vector3.new(0.35, 0.45, 0.35), Color3.fromRGB(255, 240, 180), Enum.Material.Neon)
			local hook = makeLampPart(Vector3.new(0.08, 0.4, 0.08), Color3.fromRGB(180, 140, 40), Enum.Material.Metal)
			local chain = makeLampPart(Vector3.new(0.05, 1.5, 0.05), Color3.fromRGB(160, 120, 40), Enum.Material.Metal)

			local embers = Instance.new("ParticleEmitter")
			embers.Texture = "rbxasset://textures/particles/fire_main.dds"
			embers.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 200, 80)), ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 80, 20)) })
			embers.Size = NumberSequence.new(0.04, 0)
			embers.Lifetime = NumberRange.new(0.4, 1)
			embers.Rate = 8
			embers.Speed = NumberRange.new(0.3, 0.8)
			embers.SpreadAngle = Vector2.new(10, 10)
			embers.Acceleration = Vector3.new(0, 1, 0)
			embers.LightEmission = 1; embers.LightInfluence = 0
			embers.Parent = flame

			local light = Instance.new("PointLight")
			light.Color = Color3.fromRGB(255, 200, 100); light.Brightness = 5; light.Range = 16; light.Shadows = false
			light.Parent = flame

			local a0 = Instance.new("Attachment"); a0.Position = Vector3.new(0, 0.3, 0); a0.Parent = flame
			local a1 = Instance.new("Attachment"); a1.Position = Vector3.new(0, -0.3, 0); a1.Parent = flame
			local trail = Instance.new("Trail")
			trail.Attachment0 = a0; trail.Attachment1 = a1
			trail.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 120)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 180, 60)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 140, 30)) })
			trail.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.2), NumberSequenceKeypoint.new(1, 1) })
			trail.Lifetime = 0.8
			trail.WidthScale = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.15), NumberSequenceKeypoint.new(1, 0) })
			trail.LightEmission = 0.6
			trail.Parent = flame

			local angle = (i / n) * math.pi * 2
			local radius = flRadius:Get() + math.random(0, 150) / 10
			local height = flHeight:Get() + math.random(0, 100) / 10
			local startPos = root.Position + Vector3.new(math.cos(angle) * radius, height, math.sin(angle) * radius)

			hook.CFrame = CFrame.new(startPos + Vector3.new(0, 2.2, 0))
			chain.CFrame = CFrame.new(startPos + Vector3.new(0, 1.2, 0))
			cap.CFrame = CFrame.new(startPos + Vector3.new(0, 0.9, 0))
			body.CFrame = CFrame.new(startPos)
			gold.CFrame = CFrame.new(startPos)
			bottom.CFrame = CFrame.new(startPos - Vector3.new(0, 0.9, 0))
			flame.CFrame = CFrame.new(startPos + Vector3.new(0, 0.1, 0))
			tassel.CFrame = CFrame.new(startPos - Vector3.new(0, 1.4, 0))
			for fi, fringe in ipairs(fringes) do
				local a = (fi - 1) * math.pi / 3
				fringe.CFrame = CFrame.new(startPos - Vector3.new(0, 1.1, 0) + Vector3.new(math.cos(a) * 0.5, 0, math.sin(a) * 0.5))
			end

			table.insert(lamps, {
				cap = cap, body = body, gold = gold, bottom = bottom, fringes = fringes, tassel = tassel,
				flame = flame, hook = hook, chain = chain, light = light,
				angle = angle, radius = radius, baseHeight = height,
				bobPhase = math.random(0, 1000) / 100, bobSpeed = math.random(15, 35) / 100, bobAmp = math.random(60, 120) / 100,
				orbitSpeed = math.random(6, 15) / 100, orbitDir = math.random() > 0.5 and 1 or -1,
				swayPhase = math.random(0, 1000) / 100, flamePhase = math.random(0, 1000) / 100, fringePhase = math.random(0, 1000) / 100,
				targetPos = startPos, currentPos = startPos, velocity = Vector3.zero,
			})
		end
	end

	local lastFlCount = 0
	local rsFl = RunService.RenderStepped:Connect(function(dt: number)
		if not flEnabled:Get() then
			if #lamps > 0 then destroyLamps() end
			return
		end
		local root = getRootPart()
		if not root then return end
		local n = math.floor(flCount:Get())
		if n ~= lastFlCount or #lamps == 0 then
			lastFlCount = n
			buildLamps(n, root)
		end
		local t = os.clock()
		local playerPos = root.Position
		for _, l in ipairs(lamps) do
			l.angle += dt * l.orbitSpeed * l.orbitDir
			local roseT = t * 0.12 + l.swayPhase
			local roseX = math.sin(roseT * 2) * math.cos(roseT * 0.6) * 1.5
			local roseZ = math.sin(roseT * 2) * math.sin(roseT * 0.6) * 1.5
			local bob = math.sin(t * l.bobSpeed + l.bobPhase) * l.bobAmp
			local drift = math.sin(t * 0.1 + l.swayPhase) * 0.5
			local targetX = playerPos.X + math.cos(l.angle) * l.radius + roseX
			local targetZ = playerPos.Z + math.sin(l.angle) * l.radius + roseZ
			local targetY = playerPos.Y + l.baseHeight + bob + drift
			l.targetPos = Vector3.new(targetX, targetY, targetZ)

			local diff = l.targetPos - l.currentPos
			local omega, zeta = 2.0, 0.9
			local accel = diff * (omega * omega) - l.velocity * (zeta * omega * 2)
			l.velocity += accel * dt
			l.currentPos += l.velocity * dt
			local dist = (l.currentPos - playerPos).Magnitude
			if dist > 55 then
				l.currentPos = playerPos + (l.currentPos - playerPos).Unit * 55
				l.velocity *= 0.3
			end

			local pos = l.currentPos
			local tiltX = math.clamp(l.velocity.Z * 5, -6, 6)
			local tiltZ = math.clamp(-l.velocity.X * 5, -6, 6)
			local swayTilt = math.sin(t * 0.35 + l.swayPhase) * 1.5
			local flameJump = math.sin(t * 1.8 + l.flamePhase) * 0.1
			local flameSway = math.sin(t * 2.8 + l.flamePhase * 1.2) * 0.05
			local flicker = 1 + math.sin(t * 5 + l.flamePhase) * 0.07 + math.sin(t * 9) * 0.03
			local fringeSwing = math.sin(t * 2 + l.fringePhase) * 8

			local cf = CFrame.new(pos) * CFrame.Angles(math.rad(tiltX + swayTilt), 0, math.rad(tiltZ))
			l.hook.CFrame = cf * CFrame.new(0, 2.2, 0)
			l.chain.CFrame = cf * CFrame.new(0, 1.2, 0)
			l.cap.CFrame = cf * CFrame.new(0, 0.9, 0)
			l.body.CFrame = cf
			l.gold.CFrame = cf
			l.bottom.CFrame = cf * CFrame.new(0, -0.9, 0)
			l.flame.CFrame = cf * CFrame.new(flameSway, 0.1 + flameJump, 0) * CFrame.Angles(0, t, 0)
			l.tassel.CFrame = cf * CFrame.new(0, -1.4, 0) * CFrame.Angles(math.rad(fringeSwing * 0.5), 0, 0)
			for fi, fringe in ipairs(l.fringes) do
				local a = (fi - 1) * math.pi / 3 + l.angle * 0.1
				local swing = math.sin(t * 2.5 + l.fringePhase + fi) * 12
				fringe.CFrame = cf * CFrame.new(math.cos(a) * 0.5, -1.1, math.sin(a) * 0.5) * CFrame.Angles(math.rad(swing), 0, 0)
			end

			l.light.Brightness = 5 * flicker
			l.light.Range = 16 + math.sin(t) * 2
			local warmth = math.sin(t * 0.5 + l.swayPhase) * 10
			l.light.Color = Color3.fromRGB(255, math.clamp(200 + warmth, 190, 215), math.clamp(100 + warmth * 0.3, 92, 110))
			l.flame.Color = Color3.fromRGB(255, math.clamp(240 + warmth * 0.1, 235, 248), math.clamp(180 + warmth * 0.1, 175, 190))
			l.body.Color = Color3.fromRGB(255, math.clamp(220 + warmth * 0.2, 212, 230), math.clamp(150 + warmth * 0.3, 142, 162))
		end
	end)
	table.insert(cleanups, function()
		rsFl:Disconnect()
		destroyLamps()
	end)

	CFG.toggles.fl_enabled = flEnabled
	CFG.sliders.fl_count = flCount; CFG.sliders.fl_radius = flRadius; CFG.sliders.fl_height = flHeight
end

----------------------------------------------------------------------------------
-- SECTION 5u: Butterflies
----------------------------------------------------------------------------------
do
	local buSec = newSection(pgWorld, "Butterflies")
	local buEnabled = buSec:Toggle({ Name = "Enabled", Default = false, Flag = "bu_enabled" })
	local buSettings = settingsOf(buSec, buEnabled)
	local buCount  = buSettings:Slider({ Name = "Count", Min = 3, Max = 40, Step = 1, Default = 17, Flag = "bu_count" })
	local buMinRadius = buSettings:Slider({ Name = "Min radius", Min = 10, Max = 60, Step = 2, Default = 26, Flag = "bu_minradius" })
	local buMaxRadius = buSettings:Slider({ Name = "Max radius", Min = 15, Max = 80, Step = 2, Default = 34, Flag = "bu_maxradius" })

	local buFolder = Instance.new("Folder")
	buFolder.Name = "MisanthropyButterflies"
	buFolder.Parent = Workspace
	table.insert(cleanups, function() if buFolder then buFolder:Destroy() end end)

	local BU_MIN_HEIGHT, BU_MAX_HEIGHT = 8, 14
	local BU_FORE_SIZE = Vector3.new(0.42, 0.024, 0.6)
	local BU_HIND_SIZE = Vector3.new(0.36, 0.018, 0.42)
	local BU_BODY_SIZE = Vector3.new(0.14, 0.14, 0.72)

	type WingParts = { Base: BasePart, Inner: BasePart, Tip: BasePart, Edge: BasePart }
	type Butterfly = {
		Group: Model, Body: BasePart, BodySegment1: BasePart, BodySegment2: BasePart,
		Glow: BasePart, Light: PointLight, Trail: Trail, Pollen: ParticleEmitter,
		LeftForeWing: WingParts, LeftHindWing: WingParts, RightForeWing: WingParts, RightHindWing: WingParts,
		LeftForeSpot1: BasePart, LeftForeSpot2: BasePart, LeftHindSpot1: BasePart,
		RightForeSpot1: BasePart, RightForeSpot2: BasePart, RightHindSpot1: BasePart,
		LeftAntenna: BasePart, LeftAntennaTip: BasePart, RightAntenna: BasePart, RightAntennaTip: BasePart,
		InnerOffset: number, HindOffset: number, ForeZShift: number, HindZShift: number, Scale: number,
		ContrastColor: Color3,
		Angle: number, Speed: number, Radius: number, HeightOffset: number,
		State: string, TargetLeader: Butterfly?, StateTimer: number,
		SeedX: number, SeedY: number, SeedZ: number, TimeAccumulator: number, TimeOffset: number,
		FlapSpeed: number, GlideSpeed: number,
		LastPosition: Vector3, CurrentPosition: Vector3, SmoothedDirection: Vector3, CurrentCFrame: CFrame,
	}
	local butterflies: { Butterfly } = {}

	local function destroyButterflies()
		for _, b in ipairs(butterflies) do b.Group:Destroy() end
		table.clear(butterflies)
	end

	local function createButterfly(minRadius: number, maxRadius: number): Butterfly
		local group = Instance.new("Model")
		group.Name = "BendingButterfly"
		group.Parent = buFolder
		local scale = 0.6 + math.random() * 0.8
		local startColor = Color3.fromHSV(math.random(), 0.85, 1)
		local contrastColor = Color3.fromHSV((math.random() + 0.5) % 1, 0.9, 1)
		local darkColor = Color3.fromHSV(math.random(), 0.95, 0.4)

		local function mkPart(name: string, size: Vector3, color: Color3, mat: Enum.Material?): BasePart
			local p = Instance.new("Part")
			p.Name = name; p.Size = size; p.Color = color
			p.Material = mat or Enum.Material.SmoothPlastic
			p.CanCollide = false; p.Anchored = true; p.CastShadow = false
			p.Parent = group
			return p
		end

		local body = mkPart("Body", BU_BODY_SIZE * scale, Color3.fromRGB(25, 25, 25))
		local bodySegment1 = mkPart("BodySegment1", Vector3.new(0.08, 0.08, 0.25) * scale, Color3.fromRGB(35, 35, 35))
		local bodySegment2 = mkPart("BodySegment2", Vector3.new(0.06, 0.06, 0.18) * scale, Color3.fromRGB(30, 30, 30))

		local function createDetailedWing(side: string, wingType: string, baseSize: Vector3): WingParts
			local prefix = side == "L" and "Left" or "Right"
			local base = mkPart(prefix .. wingType .. "Base", baseSize * scale, startColor, Enum.Material.Neon)
			local inner = mkPart(prefix .. wingType .. "Inner", Vector3.new(baseSize.X * 0.85, baseSize.Y * 1.5, baseSize.Z * 0.7) * scale, startColor, Enum.Material.Neon)
			local tip = mkPart(prefix .. wingType .. "Tip", Vector3.new(baseSize.X * 0.5, baseSize.Y * 2, baseSize.Z * 0.4) * scale, startColor, Enum.Material.Neon)
			local edge = mkPart(prefix .. wingType .. "Edge", Vector3.new(baseSize.X * 0.3, baseSize.Y * 1.8, baseSize.Z * 0.25) * scale, darkColor, Enum.Material.Neon)
			return { Base = base, Inner = inner, Tip = tip, Edge = edge }
		end
		local leftForeWing = createDetailedWing("L", "ForeWing", BU_FORE_SIZE)
		local leftHindWing = createDetailedWing("L", "HindWing", BU_HIND_SIZE)
		local rightForeWing = createDetailedWing("R", "ForeWing", BU_FORE_SIZE)
		local rightHindWing = createDetailedWing("R", "HindWing", BU_HIND_SIZE)

		local function createWingVein(side: string, name: string, veinLength: number): BasePart
			local prefix = side == "L" and "Left" or "Right"
			return mkPart(prefix .. name, Vector3.new(0.008, veinLength, 0.008) * scale, darkColor)
		end
		createWingVein("L", "ForeWingVein1", 0.35); createWingVein("L", "ForeWingVein2", 0.28); createWingVein("L", "HindWingVein1", 0.25)
		createWingVein("R", "ForeWingVein1", 0.35); createWingVein("R", "ForeWingVein2", 0.28); createWingVein("R", "HindWingVein1", 0.25)

		local function createWingSpot(side: string, wingType: string, spotSize: number): BasePart
			local prefix = side == "L" and "Left" or "Right"
			local spot = Instance.new("Part")
			spot.Name = prefix .. wingType .. "Spot"
			spot.Size = Vector3.new(spotSize, 0.006, spotSize) * scale
			spot.Shape = Enum.PartType.Cylinder
			spot.Material = Enum.Material.Neon
			spot.Color = contrastColor
			spot.CanCollide = false; spot.Anchored = true; spot.CastShadow = false
			spot.Parent = group
			return spot
		end
		local leftForeSpot1 = createWingSpot("L", "Fore", 0.12)
		local leftForeSpot2 = createWingSpot("L", "Fore", 0.08)
		local leftHindSpot1 = createWingSpot("L", "Hind", 0.1)
		local rightForeSpot1 = createWingSpot("R", "Fore", 0.12)
		local rightForeSpot2 = createWingSpot("R", "Fore", 0.08)
		local rightHindSpot1 = createWingSpot("R", "Hind", 0.1)

		local leftAntenna = mkPart("LeftAntenna", Vector3.new(0.015, 0.3, 0.015) * scale, Color3.fromRGB(30, 30, 30))
		local leftAntennaTip = mkPart("LeftAntennaTip", Vector3.new(0.04, 0.04, 0.04) * scale, startColor, Enum.Material.Neon)
		leftAntennaTip.Shape = Enum.PartType.Ball
		local rightAntenna = mkPart("RightAntenna", Vector3.new(0.015, 0.3, 0.015) * scale, Color3.fromRGB(30, 30, 30))
		local rightAntennaTip = mkPart("RightAntennaTip", Vector3.new(0.04, 0.04, 0.04) * scale, startColor, Enum.Material.Neon)
		rightAntennaTip.Shape = Enum.PartType.Ball

		local light = Instance.new("PointLight")
		light.Color = startColor; light.Brightness = 1.5 * scale; light.Range = 8 * scale; light.Shadows = false
		light.Parent = body

		local glow = Instance.new("Part")
		glow.Name = "BodyGlow"
		glow.Size = Vector3.new(0.2, 0.2, 0.9) * scale
		glow.Shape = Enum.PartType.Ball
		glow.Material = Enum.Material.Neon
		glow.Color = startColor
		glow.Transparency = 0.7
		glow.CanCollide = false; glow.Anchored = true; glow.CastShadow = false
		glow.Parent = group

		local pollen = Instance.new("ParticleEmitter")
		pollen.Name = "Pollen"
		pollen.Rate = 5
		pollen.Lifetime = NumberRange.new(1.5, 2.5)
		pollen.Speed = NumberRange.new(0.15, 0.5)
		pollen.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.15 * scale), NumberSequenceKeypoint.new(0.5, 0.1 * scale), NumberSequenceKeypoint.new(1, 0) })
		pollen.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.05), NumberSequenceKeypoint.new(0.7, 0.3), NumberSequenceKeypoint.new(1, 1) })
		pollen.LightEmission = 1.0; pollen.LightInfluence = 0
		pollen.Color = ColorSequence.new(startColor)
		pollen.Acceleration = Vector3.new(0, -0.2, 0)
		pollen.SpreadAngle = Vector2.new(20, 20)
		pollen.Parent = body

		local sparkle = Instance.new("ParticleEmitter")
		sparkle.Name = "Sparkles"
		sparkle.Rate = 4
		sparkle.Lifetime = NumberRange.new(0.8, 1.5)
		sparkle.Speed = NumberRange.new(0.3, 0.8)
		sparkle.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.08 * scale), NumberSequenceKeypoint.new(0.5, 0.05 * scale), NumberSequenceKeypoint.new(1, 0) })
		sparkle.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.2), NumberSequenceKeypoint.new(1, 1) })
		sparkle.LightEmission = 1.5; sparkle.LightInfluence = 0
		sparkle.Color = ColorSequence.new(contrastColor)
		sparkle.Acceleration = Vector3.new(0, 0.5, 0)
		sparkle.SpreadAngle = Vector2.new(360, 360)
		sparkle.Parent = glow

		local a0 = Instance.new("Attachment", body); a0.Position = Vector3.new(0, 0, -(BU_BODY_SIZE.Z * scale) / 2)
		local a1 = Instance.new("Attachment", body); a1.Position = Vector3.new(0, 0, (BU_BODY_SIZE.Z * scale) / 2)
		local trail = Instance.new("Trail", body)
		trail.Attachment0 = a0; trail.Attachment1 = a1
		trail.Color = ColorSequence.new(startColor)
		trail.Lifetime = 0.9
		trail.Transparency = NumberSequence.new(0.05, 0.7)
		trail.WidthScale = NumberSequence.new(0.8 * scale, 0)
		trail.LightEmission = 1.5; trail.LightInfluence = 0

		return {
			Group = group, Body = body, BodySegment1 = bodySegment1, BodySegment2 = bodySegment2,
			Glow = glow, Light = light, Trail = trail, Pollen = pollen,
			LeftForeWing = leftForeWing, LeftHindWing = leftHindWing, RightForeWing = rightForeWing, RightHindWing = rightHindWing,
			LeftForeSpot1 = leftForeSpot1, LeftForeSpot2 = leftForeSpot2, LeftHindSpot1 = leftHindSpot1,
			RightForeSpot1 = rightForeSpot1, RightForeSpot2 = rightForeSpot2, RightHindSpot1 = rightHindSpot1,
			LeftAntenna = leftAntenna, LeftAntennaTip = leftAntennaTip, RightAntenna = rightAntenna, RightAntennaTip = rightAntennaTip,
			InnerOffset = (BU_FORE_SIZE.X * scale) / 2, HindOffset = (BU_HIND_SIZE.X * scale) / 2,
			ForeZShift = -0.12 * scale, HindZShift = 0.18 * scale, Scale = scale,
			ContrastColor = contrastColor,
			Angle = math.random() * math.pi * 2, Speed = 0.08 + math.random() * 0.12,
			Radius = minRadius + (math.random() * (maxRadius - minRadius)),
			HeightOffset = BU_MIN_HEIGHT + (math.random() * (BU_MAX_HEIGHT - BU_MIN_HEIGHT)),
			State = "Orbit", TargetLeader = nil, StateTimer = math.random(5, 15),
			SeedX = math.random(1, 100000), SeedY = math.random(1, 100000), SeedZ = math.random(1, 100000),
			TimeAccumulator = math.random() * 100, TimeOffset = math.random() * 40,
			FlapSpeed = 8 + math.random() * 5, GlideSpeed = 0.15 + math.random() * 0.20,
			LastPosition = Vector3.zero, CurrentPosition = Vector3.zero, SmoothedDirection = Vector3.new(0, 0, -1), CurrentCFrame = CFrame.new(),
		}
	end

	local function buildButterflies(n: number, root: BasePart, minRadius: number, maxRadius: number)
		destroyButterflies()
		local hrpPos = root.Position
		for _ = 1, n do
			local b = createButterfly(minRadius, maxRadius)
			local startX = math.cos(b.Angle) * b.Radius
			local startZ = math.sin(b.Angle) * b.Radius
			local startPos = hrpPos + Vector3.new(startX, b.HeightOffset, startZ)
			b.LastPosition = startPos
			b.CurrentPosition = startPos
			b.CurrentCFrame = CFrame.new(startPos)
			table.insert(butterflies, b)
		end
	end

	local function applyWingTransform(wingTable: WingParts, baseCF: CFrame, isLeft: boolean, offset: number, flapAngle: number)
		local s = isLeft and -1 or 1
		local angle = isLeft and flapAngle or -flapAngle
		wingTable.Base.CFrame = baseCF * CFrame.new(s * offset * 0.5, 0, 0) * CFrame.Angles(0, 0, angle * 0.3)
		wingTable.Inner.CFrame = baseCF * CFrame.new(s * offset, 0, 0) * CFrame.Angles(0, 0, angle)
		wingTable.Tip.CFrame = baseCF * CFrame.new(s * offset * 1.8, 0, 0) * CFrame.Angles(0, 0, angle * 1.3)
		wingTable.Edge.CFrame = baseCF * CFrame.new(s * offset * 2.2, 0, 0) * CFrame.Angles(0, 0, angle * 1.6)
	end

	local function applyHindWingTransform(wingTable: WingParts, baseCF: CFrame, isLeft: boolean, offset: number, zShift: number, flapAngle: number)
		local s = isLeft and -1 or 1
		local angle = isLeft and flapAngle or -flapAngle
		wingTable.Base.CFrame = baseCF * CFrame.new(s * offset * 0.4, 0, zShift * 0.5) * CFrame.Angles(0, 0, angle * 0.5)
		wingTable.Inner.CFrame = baseCF * CFrame.new(s * offset * 0.8, 0, zShift * 0.8) * CFrame.Angles(0, 0, angle * 0.8)
		wingTable.Tip.CFrame = baseCF * CFrame.new(s * offset, 0, zShift) * CFrame.Angles(0, 0, angle)
		wingTable.Edge.CFrame = baseCF * CFrame.new(s * offset * 1.3, 0, zShift * 1.2) * CFrame.Angles(0, 0, angle * 1.3)
	end

	local function applySpotTransform(spot: BasePart, parentCF: CFrame, offset: number, isLeft: boolean)
		local s = isLeft and -1 or 1
		spot.CFrame = parentCF * CFrame.new(s * offset, 0.01, 0) * CFrame.Angles(math.rad(90), 0, 0)
	end

	local lastBuCount = 0
	local rsBu = RunService.RenderStepped:Connect(function(dt: number)
		if not buEnabled:Get() then
			if #butterflies > 0 then destroyButterflies() end
			return
		end
		local root = getRootPart()
		if not root then return end
		local minRadius, maxRadius = buMinRadius:Get(), buMaxRadius:Get()
		local n = math.floor(buCount:Get())
		if n ~= lastBuCount or #butterflies == 0 then
			lastBuCount = n
			buildButterflies(n, root, minRadius, maxRadius)
		end
		local hrpPos = root.Position

		for _, b in ipairs(butterflies) do
			b.TimeAccumulator += dt
			local localTime = b.TimeAccumulator
			b.StateTimer -= dt
			if b.StateTimer <= 0 then
				if b.State == "Orbit" then
					if math.random() < 0.30 and #butterflies > 1 then
						local candidates: { Butterfly } = {}
						for _, other in ipairs(butterflies) do
							if other ~= b and other.State == "Orbit" then table.insert(candidates, other) end
						end
						if #candidates > 0 then
							b.State = "Chase"
							b.TargetLeader = candidates[math.random(#candidates)]
							b.StateTimer = 4 + math.random() * 6
						else
							b.StateTimer = 4 + math.random() * 8
						end
					else
						b.StateTimer = 4 + math.random() * 8
					end
				else
					b.State = "Orbit"; b.TargetLeader = nil; b.StateTimer = 5 + math.random() * 10
				end
			end

			local targetPos: Vector3
			b.Angle += b.Speed * dt
			local noiseX = math.noise(localTime * 0.30, b.SeedX) * 5.5
			local noiseY = math.noise(localTime * 0.20, b.SeedY) * 3.5
			local noiseZ = math.noise(localTime * 0.30, b.SeedZ) * 5.5

			if b.State == "Chase" and b.TargetLeader and b.TargetLeader.Group.Parent then
				local leaderPos = b.TargetLeader.CurrentPosition
				local chaseRadius = 4.0 * b.Scale
				local tX = math.cos(b.Angle * 1.6) * chaseRadius
				local tZ = math.sin(b.Angle * 1.6) * chaseRadius
				local tY = math.sin(localTime * 2.0 + b.TimeOffset) * (1.8 * b.Scale)
				targetPos = leaderPos + Vector3.new(tX, tY, tZ)
			else
				if b.State == "Chase" then b.State = "Orbit"; b.TargetLeader = nil; b.StateTimer = 5 end
				local targetX = math.cos(b.Angle) * b.Radius + noiseX
				local targetZ = math.sin(b.Angle) * b.Radius + noiseZ
				local targetY = b.HeightOffset + noiseY
				targetPos = hrpPos + Vector3.new(targetX, targetY, targetZ)
			end

			local posAlpha = 1 - math.exp(-1.0 * dt)
			b.CurrentPosition = b.CurrentPosition:Lerp(targetPos, posAlpha)
			local rawDirection = b.CurrentPosition - b.LastPosition
			if rawDirection.Magnitude > 0.0005 then
				local dirAlpha = 1 - math.exp(-3.5 * dt)
				b.SmoothedDirection = b.SmoothedDirection:Lerp(rawDirection.Unit, dirAlpha)
				local rawCF = CFrame.lookAt(b.CurrentPosition, b.CurrentPosition + b.SmoothedDirection)
				local roll = math.sin(localTime * 1.5 + b.TimeOffset) * math.rad(15)
				local pitch = math.cos(localTime * 1.0 + b.TimeOffset) * math.rad(8)
				local targetCF = rawCF * CFrame.Angles(pitch, 0, roll)
				local rotAlpha = 1 - math.exp(-2.0 * dt)
				b.CurrentCFrame = b.CurrentCFrame:Lerp(targetCF, rotAlpha)
				b.Body.CFrame = b.CurrentCFrame

				local hue = (localTime * 0.03 + b.TimeOffset * 0.05) % 1
				local dynamicColor = Color3.fromHSV(hue, 0.85, 1)
				local contrastColor = Color3.fromHSV((hue + 0.5) % 1, 0.95, 1)
				local function setWingColor(wingTable: WingParts, color: Color3)
					wingTable.Base.Color = color
					wingTable.Inner.Color = color
					wingTable.Tip.Color = color
					wingTable.Edge.Color = b.ContrastColor
				end
				setWingColor(b.LeftForeWing, dynamicColor); setWingColor(b.LeftHindWing, dynamicColor)
				setWingColor(b.RightForeWing, dynamicColor); setWingColor(b.RightHindWing, dynamicColor)
				b.LeftForeSpot1.Color = contrastColor; b.LeftForeSpot2.Color = contrastColor; b.LeftHindSpot1.Color = contrastColor
				b.RightForeSpot1.Color = contrastColor; b.RightForeSpot2.Color = contrastColor; b.RightHindSpot1.Color = contrastColor
				b.Light.Color = dynamicColor
				b.Glow.Color = dynamicColor
				b.Trail.Color = ColorSequence.new(dynamicColor)
				b.Pollen.Color = ColorSequence.new(dynamicColor)
				b.LeftAntennaTip.Color = dynamicColor; b.RightAntennaTip.Color = dynamicColor

				local indTime = localTime + b.TimeOffset
				local glideEnvelope = math.clamp(math.sin(indTime * b.GlideSpeed) * 0.75 + 0.6, 0.12, 1.0)
				local flapAngle = math.sin(indTime * b.FlapSpeed) * math.rad(42) * glideEnvelope
				local hindFlapAngle = flapAngle * 0.75

				local foreBaseCF = b.CurrentCFrame * CFrame.new(0, 0, b.ForeZShift)
				applyWingTransform(b.LeftForeWing, foreBaseCF, true, b.InnerOffset, flapAngle)
				applyWingTransform(b.RightForeWing, foreBaseCF, false, b.InnerOffset, flapAngle)
				applySpotTransform(b.LeftForeSpot1, b.LeftForeWing.Tip.CFrame, 0.05, true)
				applySpotTransform(b.LeftForeSpot2, b.LeftForeWing.Edge.CFrame, 0.03, true)
				applySpotTransform(b.RightForeSpot1, b.RightForeWing.Tip.CFrame, 0.05, false)
				applySpotTransform(b.RightForeSpot2, b.RightForeWing.Edge.CFrame, 0.03, false)

				local hindBaseCF = b.CurrentCFrame * CFrame.new(0, 0, b.HindZShift)
				applyHindWingTransform(b.LeftHindWing, hindBaseCF, true, b.HindOffset, b.HindZShift, hindFlapAngle)
				applyHindWingTransform(b.RightHindWing, hindBaseCF, false, b.HindOffset, b.HindZShift, hindFlapAngle)
				applySpotTransform(b.LeftHindSpot1, b.LeftHindWing.Tip.CFrame, 0.04, true)
				applySpotTransform(b.RightHindSpot1, b.RightHindWing.Tip.CFrame, 0.04, false)

				local antennaBaseL = b.CurrentCFrame * CFrame.new(-0.05 * b.Scale, 0.25 * b.Scale, -0.35 * b.Scale)
				b.LeftAntenna.CFrame = antennaBaseL * CFrame.Angles(math.sin(localTime * 2 + b.TimeOffset) * 0.2, 0, 0.3)
				b.LeftAntennaTip.CFrame = b.LeftAntenna.CFrame * CFrame.new(0, 0.15 * b.Scale, 0)
				local antennaBaseR = b.CurrentCFrame * CFrame.new(0.05 * b.Scale, 0.25 * b.Scale, -0.35 * b.Scale)
				b.RightAntenna.CFrame = antennaBaseR * CFrame.Angles(math.sin(localTime * 2.5 + b.TimeOffset) * 0.2, 0, -0.3)
				b.RightAntennaTip.CFrame = b.RightAntenna.CFrame * CFrame.new(0, 0.15 * b.Scale, 0)

				b.BodySegment1.CFrame = b.CurrentCFrame * CFrame.new(0, 0.02 * b.Scale, -0.2 * b.Scale) * CFrame.Angles(0, 0, math.sin(localTime * 1.5) * 0.05)
				b.BodySegment2.CFrame = b.CurrentCFrame * CFrame.new(0, -0.01 * b.Scale, -0.32 * b.Scale) * CFrame.Angles(0, 0, math.sin(localTime * 2) * 0.03)
				b.Glow.CFrame = b.CurrentCFrame
			end
			b.LastPosition = b.CurrentPosition
		end
	end)
	table.insert(cleanups, function()
		rsBu:Disconnect()
		destroyButterflies()
	end)

	CFG.toggles.bu_enabled = buEnabled
	CFG.sliders.bu_count = buCount; CFG.sliders.bu_minradius = buMinRadius; CFG.sliders.bu_maxradius = buMaxRadius
end

----------------------------------------------------------------------------------
-- SECTION 5v: Birds
----------------------------------------------------------------------------------
do
	local bdSec = newSection(pgWorld, "Birds")
	local bdEnabled = bdSec:Toggle({ Name = "Enabled", Default = false, Flag = "bd_enabled" })
	local bdSettings = settingsOf(bdSec, bdEnabled)
	local bdCount  = bdSettings:Slider({ Name = "Count", Min = 1, Max = 20, Step = 1, Default = 6, Flag = "bd_count" })
	local bdScale  = bdSettings:Slider({ Name = "Scale", Min = 10, Max = 60, Step = 5, Default = 25, Suffix = "ds", Flag = "bd_scale" })
	local bdPoop   = bdSettings:Toggle({ Name = "Poop", Default = true, Flag = "bd_poop" })

	local bdFolder = Instance.new("Folder")
	bdFolder.Name = "MisanthropyBirds"
	bdFolder.Parent = Workspace
	table.insert(cleanups, function() if bdFolder then bdFolder:Destroy() end end)

	local BdTweenService = game:GetService("TweenService")
	local BD_TYPES = { "Flapper", "Glider", "Diver" }

	local function bdLerp(a: number, b: number, t: number): number
		return a + (b - a) * t
	end

	type BirdParts = {
		Model: Model, Body: BasePart, Belly: BasePart, Back: BasePart, Chest: BasePart, Neck: BasePart,
		Head: BasePart, Crest: BasePart, EyeL: BasePart, EyeR: BasePart, PupilL: BasePart, PupilR: BasePart,
		BeakU: BasePart, BeakL: BasePart, BeakTip: BasePart, Nostril: BasePart,
		ThighL: BasePart, ShinL: BasePart, ThighR: BasePart, ShinR: BasePart,
		TailC: BasePart, TailL: BasePart, TailR: BasePart, TailLL: BasePart, TailRR: BasePart,
		LW: { [string]: BasePart }, RW: { [string]: BasePart },
	}
	type BirdData = {
		parts: BirdParts, birdType: string,
		currentRadius: number, targetRadius: number, currentHeight: number, targetHeight: number,
		angleSpeed: number, phase: number, wingSpeed: number, flapAmplitude: number,
		state: string, behaviorTimer: number, behaviorDuration: number, flapIntensity: number,
		innerAngle: number, midAngle: number, outerAngle: number, outerTipAngle: number, poopTimer: number,
	}

	local birdData: { BirdData } = {}
	local activePoops: { { part: BasePart, velocity: Vector3 } } = {}
	local activeSplats: { { part: BasePart, spawnTime: number, duration: number } } = {}

	local function selectBehavior(data: BirdData)
		local pool: { string }
		if data.birdType == "Glider" then
			pool = { "Soaring", "Soaring", "Flapping" }
		elseif data.birdType == "Diver" then
			pool = { "Swooping", "Swooping", "Flapping" }
		else
			pool = { "Flapping", "Flapping", "Soaring", "Swooping" }
		end
		data.state = pool[math.random(#pool)]
		local dur = math.random(10, 22)
		data.behaviorTimer = dur
		data.behaviorDuration = dur
		data.targetRadius = math.random(75, 125)
		data.targetHeight = math.random(50, 90)
	end

	local function bdMakePart(model: Model, name: string, size: Vector3, color: Color3, mat: Enum.Material?, scale: number): BasePart
		local p = Instance.new("Part")
		p.Name = name
		p.Size = size * scale
		p.Color = color
		p.Material = mat or Enum.Material.SmoothPlastic
		p.Anchored = true; p.CanCollide = false; p.CanTouch = false; p.CanQuery = false
		p.Parent = model
		return p
	end

	local function createBird(birdType: string, scale: number): BirdParts
		local m = Instance.new("Model")
		m.Name = "Bird_" .. birdType
		local palette: { [string]: { [string]: Color3 } } = {
			Flapper = { body = Color3.fromRGB(248, 248, 248), mid = Color3.fromRGB(195, 195, 195), dark = Color3.fromRGB(60, 60, 60), beak = Color3.fromRGB(255, 120, 0), eye = Color3.fromRGB(15, 15, 15) },
			Glider  = { body = Color3.fromRGB(210, 230, 255), mid = Color3.fromRGB(140, 170, 210), dark = Color3.fromRGB(40, 70, 130), beak = Color3.fromRGB(255, 200, 0), eye = Color3.fromRGB(10, 10, 10) },
			Diver   = { body = Color3.fromRGB(30, 30, 30), mid = Color3.fromRGB(80, 80, 80), dark = Color3.fromRGB(200, 200, 200), beak = Color3.fromRGB(255, 80, 0), eye = Color3.fromRGB(200, 0, 0) },
		}
		local c = palette[birdType]
		local function P(n: string, sz: Vector3, col: Color3, mat: Enum.Material?): BasePart
			return bdMakePart(m, n, sz, col, mat, scale)
		end
		local body = P("Body", Vector3.new(0.65, 0.50, 2.0), c.body)
		local belly = P("Belly", Vector3.new(0.70, 0.40, 1.2), Color3.fromRGB(255, 255, 245))
		local back = P("Back", Vector3.new(0.60, 0.18, 1.6), c.mid)
		local chest = P("Chest", Vector3.new(0.75, 0.60, 1.0), c.body)
		local neck = P("Neck", Vector3.new(0.35, 0.35, 0.60), c.body)
		local head = P("Head", Vector3.new(0.48, 0.48, 0.48), c.body)
		local crest = P("Crest", Vector3.new(0.10, 0.24, 0.48), c.mid)
		local eyeL = P("EyeL", Vector3.new(0.09, 0.09, 0.09), c.eye, Enum.Material.Glass)
		local eyeR = P("EyeR", Vector3.new(0.09, 0.09, 0.09), c.eye, Enum.Material.Glass)
		local pupilL = P("PupilL", Vector3.new(0.04, 0.04, 0.04), Color3.fromRGB(255, 255, 255), Enum.Material.Neon)
		local pupilR = P("PupilR", Vector3.new(0.04, 0.04, 0.04), Color3.fromRGB(255, 255, 255), Enum.Material.Neon)
		local beakU = P("BeakU", Vector3.new(0.18, 0.13, 0.52), c.beak)
		local beakL = P("BeakL", Vector3.new(0.14, 0.07, 0.46), c.beak)
		local beakTip = P("BeakTip", Vector3.new(0.10, 0.08, 0.20), Color3.fromRGB(200, 80, 0))
		local nostril = P("Nostril", Vector3.new(0.06, 0.04, 0.16), Color3.fromRGB(180, 60, 0))
		local thighL = P("ThighL", Vector3.new(0.14, 0.28, 0.14), c.beak)
		local shinL = P("ShinL", Vector3.new(0.10, 0.22, 0.10), c.beak)
		local thighR = P("ThighR", Vector3.new(0.14, 0.28, 0.14), c.beak)
		local shinR = P("ShinR", Vector3.new(0.10, 0.22, 0.10), c.beak)
		local tailC = P("TailC", Vector3.new(0.50, 0.03, 1.30), c.mid)
		local tailL = P("TailL", Vector3.new(0.40, 0.03, 1.20), c.mid)
		local tailR = P("TailR", Vector3.new(0.40, 0.03, 1.20), c.mid)
		local tailLL = P("TailLL", Vector3.new(0.28, 0.02, 1.00), c.dark)
		local tailRR = P("TailRR", Vector3.new(0.28, 0.02, 1.00), c.dark)
		local function makeWing(side: string): { [string]: BasePart }
			local prefix = side == "L" and "Left" or "Right"
			return {
				Inner = P(prefix .. "Inner", Vector3.new(0.85, 0.06, 0.72), c.body),
				Mid = P(prefix .. "Mid", Vector3.new(1.05, 0.05, 0.62), c.mid),
				Outer = P(prefix .. "Outer", Vector3.new(0.92, 0.04, 0.52), c.dark),
				Tip = P(prefix .. "Tip", Vector3.new(0.55, 0.03, 0.40), c.dark),
				Feat1 = P(prefix .. "Feat1", Vector3.new(0.16, 0.02, 0.85), c.dark),
				Feat2 = P(prefix .. "Feat2", Vector3.new(0.16, 0.02, 0.75), c.dark),
				Feat3 = P(prefix .. "Feat3", Vector3.new(0.14, 0.02, 0.65), c.mid),
				Covert = P(prefix .. "Covert", Vector3.new(0.70, 0.03, 0.35), c.mid),
			}
		end
		local LW = makeWing("L")
		local RW = makeWing("R")
		m.PrimaryPart = body
		m.Parent = bdFolder
		return {
			Model = m, Body = body, Belly = belly, Back = back, Chest = chest, Neck = neck, Head = head, Crest = crest,
			EyeL = eyeL, EyeR = eyeR, PupilL = pupilL, PupilR = pupilR, BeakU = beakU, BeakL = beakL, BeakTip = beakTip, Nostril = nostril,
			ThighL = thighL, ShinL = shinL, ThighR = thighR, ShinR = shinR,
			TailC = tailC, TailL = tailL, TailR = tailR, TailLL = tailLL, TailRR = tailRR,
			LW = LW, RW = RW,
		}
	end

	local function createSplat(pos: Vector3, normal: Vector3, scale: number)
		local s = Instance.new("Part")
		s.Name = "BirdPoopSplat"
		s.Size = Vector3.new(0.8, 0.01, 0.8) * scale * 0.4
		s.Color = Color3.fromRGB(242, 242, 242)
		s.Material = Enum.Material.SmoothPlastic
		s.Anchored = true; s.CanCollide = false; s.CanTouch = false; s.CanQuery = false
		s.CFrame = CFrame.lookAt(pos, pos + normal) * CFrame.Angles(math.rad(90), 0, 0)
		s.Parent = bdFolder
		table.insert(activeSplats, { part = s, spawnTime = os.clock(), duration = 15 })
	end

	local function applyWing(parts: BirdParts, bodyCF: CFrame, side: string, innerA: number, midA: number, outerA: number, tipA: number, sweep: number, scale: number)
		local s = side == "L" and -1 or 1
		local W = side == "L" and parts.LW or parts.RW
		local innerCF = bodyCF * CFrame.new(s * 0.32 * scale, 0.1 * scale, 0) * CFrame.Angles(sweep, 0, s * innerA) * CFrame.new(s * 0.42 * scale, 0, 0)
		W.Inner.CFrame = innerCF
		W.Covert.CFrame = bodyCF * CFrame.new(s * 0.28 * scale, 0.14 * scale, -0.1 * scale) * CFrame.Angles(sweep * 0.5, 0, s * innerA * 0.6) * CFrame.new(s * 0.35 * scale, 0, 0)
		local midCF = innerCF * CFrame.new(s * 0.42 * scale, 0, 0) * CFrame.Angles(sweep * 0.6, 0, s * midA) * CFrame.new(s * 0.52 * scale, 0, 0)
		W.Mid.CFrame = midCF
		local outerCF = midCF * CFrame.new(s * 0.50 * scale, 0, 0) * CFrame.Angles(sweep * 0.3, 0, s * outerA) * CFrame.new(s * 0.46 * scale, 0, 0)
		W.Outer.CFrame = outerCF
		local tipCF = outerCF * CFrame.new(s * 0.46 * scale, 0, 0) * CFrame.Angles(0, 0, s * tipA) * CFrame.new(s * 0.28 * scale, 0, 0)
		W.Tip.CFrame = tipCF
		for idx, feat in ipairs({ W.Feat1, W.Feat2, W.Feat3 }) do
			feat.CFrame = outerCF * CFrame.new(s * 0.46 * scale, 0, 0) * CFrame.Angles(0, s * math.rad(-15 * idx), 0) * CFrame.new(s * (0.42 - idx * 0.04) * scale, 0, 0)
		end
	end

	local function destroyBirds()
		for _, d in ipairs(birdData) do d.parts.Model:Destroy() end
		table.clear(birdData)
		for _, p in ipairs(activePoops) do p.part:Destroy() end
		table.clear(activePoops)
		for _, s in ipairs(activeSplats) do s.part:Destroy() end
		table.clear(activeSplats)
	end

	local function buildBirds(n: number, scale: number)
		destroyBirds()
		for i = 1, n do
			local bType = BD_TYPES[((i - 1) % #BD_TYPES) + 1]
			local r = math.random(80, 110)
			local h = math.random(55, 80)
			local data: BirdData = {
				parts = createBird(bType, scale), birdType = bType,
				currentRadius = r, targetRadius = r, currentHeight = h, targetHeight = h,
				angleSpeed = (math.random(32, 58) / 100) * (math.random(0, 1) == 0 and 1 or -1),
				phase = (i / n) * math.pi * 2 + math.random() * 0.5,
				wingSpeed = math.random(8, 12), flapAmplitude = math.random(22, 34),
				state = "Flapping", behaviorTimer = 0, behaviorDuration = 1, flapIntensity = 1.0,
				innerAngle = 0, midAngle = 0, outerAngle = 0, outerTipAngle = 0,
				poopTimer = math.random(15, 35),
			}
			selectBehavior(data)
			table.insert(birdData, data)
		end
	end

	local lastBdCount = 0
	local lastBdScale = 0
	local rsBd = RunService.RenderStepped:Connect(function(dt: number)
		if not bdEnabled:Get() then
			if #birdData > 0 then destroyBirds() end
			return
		end
		local root = getRootPart()
		if not root then return end
		dt = math.min(dt, 0.1)
		local scale = bdScale:Get() / 10
		local n = math.floor(bdCount:Get())
		if n ~= lastBdCount or scale ~= lastBdScale or #birdData == 0 then
			lastBdCount = n; lastBdScale = scale
			buildBirds(n, scale)
		end
		local center = root.Position
		local t = os.clock()
		local tf = 1 - math.exp(-2.2 * dt)
		local tff = 1 - math.exp(-3.8 * dt)

		for i = #activePoops, 1, -1 do
			local p = activePoops[i]
			p.velocity += Vector3.new(0, -Workspace.Gravity * dt, 0)
			local disp = p.velocity * dt
			local rp = RaycastParams.new()
			rp.FilterType = Enum.RaycastFilterType.Exclude
			rp.FilterDescendantsInstances = { bdFolder }
			local ray = Workspace:Raycast(p.part.Position, disp, rp)
			if ray then
				createSplat(ray.Position, ray.Normal, scale)
				p.part:Destroy()
				table.remove(activePoops, i)
			else
				p.part.Position += disp
				if p.part.Position.Y < center.Y - 400 then
					p.part:Destroy()
					table.remove(activePoops, i)
				end
			end
		end
		for i = #activeSplats, 1, -1 do
			local s = activeSplats[i]
			local age = t - s.spawnTime
			if age > s.duration then
				s.part:Destroy()
				table.remove(activeSplats, i)
			elseif s.duration - age < 3 then
				s.part.Transparency = 1 - (s.duration - age) / 3
			end
		end

		for _, data in ipairs(birdData) do
			data.behaviorTimer -= dt
			if data.behaviorTimer <= 0 then selectBehavior(data) end
			if bdPoop:Get() then
				data.poopTimer -= dt
				if data.poopTimer <= 0 then
					data.poopTimer = math.random(15, 35)
					if math.random() < 0.4 then
						local pp = Instance.new("Part")
						pp.Shape = Enum.PartType.Ball
						pp.Size = Vector3.new(0.25, 0.25, 0.25) * scale
						pp.Color = Color3.fromRGB(240, 240, 240)
						pp.Material = Enum.Material.SmoothPlastic
						pp.Anchored = true; pp.CanCollide = false; pp.CanTouch = false; pp.CanQuery = false
						pp.Position = data.parts.TailC.Position
						pp.Parent = bdFolder
						local spm = data.state == "Swooping" and 1.65 or (data.state == "Soaring" and 0.75 or 1.0)
						local ang = (t * data.angleSpeed * spm) + data.phase
						local rX = data.currentRadius + math.sin(t * 0.18 + data.phase) * 12
						local rZ = data.currentRadius * 0.8 + math.cos(t * 0.25 - data.phase) * 12
						local tv = Vector3.new(-math.sin(ang) * rX, 0, math.cos(ang) * rZ).Unit * (math.abs(data.angleSpeed) * spm * data.currentRadius)
						table.insert(activePoops, { part = pp, velocity = tv + Vector3.new(0, -3, 0) })
					end
				end
			end

			data.currentRadius = bdLerp(data.currentRadius, data.targetRadius, tf)
			data.currentHeight = bdLerp(data.currentHeight, data.targetHeight, tf)
			local spm, tfi, swoopY, sweep, chirp = 1.0, 1.0, 0, 0, 0
			local tIn, tMid, tOut, tTip = 0, 0, 0, 0
			local tailPitch, tailSpread = math.rad(-5), math.rad(6)
			local flapT = t * data.wingSpeed

			if data.state == "Soaring" then
				tfi = 0.04; spm = 0.75
				tIn = math.rad(6); tMid = math.rad(-4); tOut = math.rad(-2); tTip = math.rad(-1)
			elseif data.state == "Flapping" then
				local intensityMod = data.birdType == "Glider" and 0.6 or (data.birdType == "Diver" and 0.9 or 1.0)
				tfi = (0.7 + math.sin(t * 1.2) * 0.3) * intensityMod
				spm = 1.0
				chirp = math.clamp(math.sin(t * 4.5 + data.phase), 0, 1) * math.rad(15)
				local up = math.max(0, math.cos(flapT))
				tIn = math.sin(flapT) * math.rad(data.flapAmplitude) * data.flapIntensity
				tMid = math.sin(flapT - 0.5) * math.rad(data.flapAmplitude * 0.95) * data.flapIntensity + up * math.rad(32) * data.flapIntensity
				tOut = math.sin(flapT - 1.0) * math.rad(data.flapAmplitude * 0.80) * data.flapIntensity + up * math.rad(48) * data.flapIntensity
				tTip = math.sin(flapT - 1.5) * math.rad(data.flapAmplitude * 0.60) * data.flapIntensity + up * math.rad(58) * data.flapIntensity
			elseif data.state == "Swooping" then
				tfi = 0.04; spm = 1.65
				local prog = math.clamp((data.behaviorDuration - data.behaviorTimer) / data.behaviorDuration, 0, 1)
				swoopY = -math.sin(prog * math.pi) * 35
				sweep = math.rad(-16) * math.sin(prog * math.pi)
				local f = math.sin(prog * math.pi)
				tIn = bdLerp(0, math.rad(-15), f)
				tMid = bdLerp(0, math.rad(65), f)
				tOut = bdLerp(0, math.rad(-50), f)
				tTip = bdLerp(0, math.rad(-70), f)
				if prog > 0.45 then
					tailPitch = math.rad(-5) + math.sin(prog * math.pi) * math.rad(-20)
					tailSpread = math.rad(6) + math.sin(prog * math.pi) * math.rad(22)
				end
			end

			data.flapIntensity = bdLerp(data.flapIntensity, tfi, tff)
			data.innerAngle = bdLerp(data.innerAngle, tIn, tff)
			data.midAngle = bdLerp(data.midAngle, tMid, tff)
			data.outerAngle = bdLerp(data.outerAngle, tOut, tff)
			data.outerTipAngle = bdLerp(data.outerTipAngle, tTip, tff)

			local wX = math.sin(t * 1.5 + data.phase) * 0.8
			local wY = math.cos(t * 1.1) * 0.5
			local wZ = math.sin(t * 1.3 + data.phase) * 0.8
			local angle = (t * data.angleSpeed * spm) + data.phase
			local rX = data.currentRadius + math.sin(t * 0.18 + data.phase) * 12 + wX
			local rZ = data.currentRadius * 0.8 + math.cos(t * 0.25 - data.phase) * 12 + wZ
			local birdPos = center + Vector3.new(math.cos(angle) * rX, data.currentHeight + math.sin(t * 0.32 + data.phase * 2) * 6 + wY + swoopY, math.sin(angle) * rZ)
			local dm = data.angleSpeed > 0 and 1 or -1
			local tangent = Vector3.new(-math.sin(angle) * rX, 0, math.cos(angle) * rZ).Unit * dm
			local dy = math.cos(t + data.phase) * 0.08
			if data.state == "Swooping" then
				local prog = math.clamp((data.behaviorDuration - data.behaviorTimer) / data.behaviorDuration, 0, 1)
				dy = -math.cos(prog * math.pi) * 0.45
			end
			local lookDir = (tangent + Vector3.new(0, dy, 0)).Unit
			local roll = -0.35 * (data.angleSpeed * spm)
			local bodyCF = CFrame.lookAt(birdPos, birdPos + lookDir) * CFrame.Angles(0, 0, roll)

			local p = data.parts
			p.Body.CFrame = bodyCF
			p.Belly.CFrame = bodyCF * CFrame.new(0, -0.18 * scale, -0.1 * scale)
			p.Back.CFrame = bodyCF * CFrame.new(0, 0.16 * scale, 0.1 * scale)
			p.Chest.CFrame = bodyCF * CFrame.new(0, 0.05 * scale, -0.3 * scale)
			local neckCF = bodyCF * CFrame.new(0, 0.2 * scale, -1.0 * scale) * CFrame.Angles(math.rad(15), 0, 0)
			p.Neck.CFrame = neckCF
			local headCF = neckCF * CFrame.new(0, 0.1 * scale, -0.35 * scale) * CFrame.Angles(0, 0, -roll * 0.65)
			p.Head.CFrame = headCF
			p.Crest.CFrame = headCF * CFrame.new(0, 0.30 * scale, 0.15 * scale) * CFrame.Angles(math.rad(-18), 0, 0)
			p.EyeL.CFrame = headCF * CFrame.new(-0.22 * scale, 0.09 * scale, -0.10 * scale)
			p.EyeR.CFrame = headCF * CFrame.new(0.22 * scale, 0.09 * scale, -0.10 * scale)
			p.PupilL.CFrame = headCF * CFrame.new(-0.23 * scale, 0.09 * scale, -0.13 * scale)
			p.PupilR.CFrame = headCF * CFrame.new(0.23 * scale, 0.09 * scale, -0.13 * scale)
			p.BeakU.CFrame = headCF * CFrame.new(0, -0.05 * scale, -0.44 * scale)
			p.BeakL.CFrame = headCF * CFrame.new(0, -0.13 * scale, -0.40 * scale) * CFrame.Angles(-chirp, 0, 0)
			p.BeakTip.CFrame = headCF * CFrame.new(0, -0.07 * scale, -0.65 * scale)
			p.Nostril.CFrame = headCF * CFrame.new(0, 0.00 * scale, -0.35 * scale)
			local legPitch = data.state == "Swooping" and math.rad(65) or math.rad(35)
			for _, side in ipairs({ { p.ThighL, p.ShinL, -1 }, { p.ThighR, p.ShinR, 1 } }) do
				local thigh, shin = side[1] :: BasePart, side[2] :: BasePart
				local sx = side[3] :: number
				thigh.CFrame = bodyCF * CFrame.new(sx * 0.20 * scale, -0.22 * scale, 0.28 * scale) * CFrame.Angles(legPitch * 0.6, 0, 0)
				shin.CFrame = thigh.CFrame * CFrame.new(0, -0.20 * scale, 0) * CFrame.Angles(legPitch * 0.5, 0, 0)
			end
			p.TailC.CFrame = bodyCF * CFrame.new(0, -0.05 * scale, 1.35 * scale) * CFrame.Angles(tailPitch, 0, 0)
			p.TailL.CFrame = bodyCF * CFrame.new(-0.15 * scale, -0.05 * scale, 1.30 * scale) * CFrame.Angles(tailPitch, -tailSpread, 0)
			p.TailR.CFrame = bodyCF * CFrame.new(0.15 * scale, -0.05 * scale, 1.30 * scale) * CFrame.Angles(tailPitch, tailSpread, 0)
			p.TailLL.CFrame = bodyCF * CFrame.new(-0.30 * scale, -0.05 * scale, 1.20 * scale) * CFrame.Angles(tailPitch, -tailSpread * 1.6, 0)
			p.TailRR.CFrame = bodyCF * CFrame.new(0.30 * scale, -0.05 * scale, 1.20 * scale) * CFrame.Angles(tailPitch, tailSpread * 1.6, 0)

			local foreBaseCF = bodyCF
			applyWing(p, foreBaseCF, "L", data.innerAngle, data.midAngle, data.outerAngle, data.outerTipAngle, sweep, scale)
			applyWing(p, foreBaseCF, "R", data.innerAngle, data.midAngle, data.outerAngle, data.outerTipAngle, sweep, scale)
		end
	end)
	table.insert(cleanups, function()
		rsBd:Disconnect()
		destroyBirds()
	end)

	CFG.toggles.bd_enabled = bdEnabled; CFG.toggles.bd_poop = bdPoop
	CFG.sliders.bd_scale = bdScale; CFG.sliders.bd_count = bdCount
end

----------------------------------------------------------------------------------
-- SECTION 5w: Wind
----------------------------------------------------------------------------------
do
	local wdSec = newSection(pgWorld, "Wind")
	local wdEnabled = wdSec:Toggle({ Name = "Enabled", Default = false, Flag = "wd_enabled" })
	local wdSettings = settingsOf(wdSec, wdEnabled)
	local wdMaxLines = wdSettings:Slider({ Name = "Max lines", Min = 4, Max = 40, Step = 2, Default = 18, Flag = "wd_maxlines" })
	local wdSpeed    = wdSettings:Slider({ Name = "Speed", Min = 10, Max = 100, Step = 5, Default = 40, Flag = "wd_speed" })

	local wdFolder = Instance.new("Folder")
	wdFolder.Name = "MisanthropyWind"
	wdFolder.Parent = Workspace
	table.insert(cleanups, function() if wdFolder then wdFolder:Destroy() end end)

	type WindLine = { part: BasePart, spawnTime: number, basePos: Vector3, dir: Vector3, speed: number, perp1: Vector3, perp2: Vector3, phase: number }
	local windLines: { WindLine } = {}

	local function getPerp(dir: Vector3): (Vector3, Vector3)
		local perp1 = dir:Cross(Vector3.new(0, 1, 0))
		if perp1.Magnitude < 0.01 then perp1 = dir:Cross(Vector3.new(1, 0, 0)) end
		perp1 = perp1.Unit
		local perp2 = dir:Cross(perp1).Unit
		return perp1, perp2
	end

	local function spawnWindLine(dir: Vector3, speed: number)
		local cam = Workspace.CurrentCamera
		if not cam or #windLines >= wdMaxLines:Get() then return end
		local camPos = cam.CFrame.Position
		local centerPos = camPos + cam.CFrame.LookVector * 45
		local scatter = cam.CFrame.RightVector * math.random(-55, 55) + cam.CFrame.UpVector * math.random(-30, 30)
		local startPos = centerPos - dir * (speed * 0.8) + scatter
		local perp1, perp2 = getPerp(dir)
		local part = Instance.new("Part")
		part.Size = Vector3.new(0.01, 0.01, 0.01)
		part.Transparency = 1
		part.CanCollide = false; part.CanQuery = false; part.CanTouch = false; part.Anchored = true
		part.Position = startPos
		part.Parent = wdFolder
		local a0 = Instance.new("Attachment", part)
		local a1 = Instance.new("Attachment", part)
		local trail = Instance.new("Trail")
		trail.Attachment0 = a0; trail.Attachment1 = a1
		trail.FaceCamera = true
		trail.Lifetime = 0.2
		trail.Color = ColorSequence.new(Color3.fromRGB(235, 245, 255))
		trail.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.12, 0.45), NumberSequenceKeypoint.new(0.85, 0.45), NumberSequenceKeypoint.new(1, 1) })
		trail.WidthScale = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.12, 1), NumberSequenceKeypoint.new(0.88, 0.6), NumberSequenceKeypoint.new(1, 0) })
		trail.Parent = part
		table.insert(windLines, {
			part = part, spawnTime = os.clock(),
			basePos = startPos, dir = dir, speed = speed, perp1 = perp1, perp2 = perp2, phase = math.random() * math.pi * 2,
		})
	end

	local lastWdSpawn = 0
	local rsWd = RunService.Heartbeat:Connect(function(dt: number)
		if not wdEnabled:Get() then
			if #windLines > 0 then
				for _, l in ipairs(windLines) do l.part:Destroy() end
				table.clear(windLines)
				pcall(function() Workspace.GlobalWind = Vector3.zero end)
			end
			return
		end
		local t = os.clock()
		local angleNoise = math.noise(t * 0.05, 2, 2) * math.pi * 2
		local pitchNoise = math.noise(2, t * 0.03, 2) * 0.08
		local dir = Vector3.new(math.cos(angleNoise), pitchNoise, math.sin(angleNoise)).Unit
		local speed = wdSpeed:Get()
		pcall(function() Workspace.GlobalWind = dir * (speed * 0.08) end)

		for i = #windLines, 1, -1 do
			local l = windLines[i]
			local age = t - l.spawnTime
			if age >= 1.2 or not l.part.Parent then
				l.part:Destroy()
				table.remove(windLines, i)
			else
				l.basePos += l.dir * l.speed * dt
				local wave = l.perp1 * math.sin(age * 4 + l.phase) * 2.5 + l.perp2 * math.cos(age * 4.4 + l.phase) * 1.8
				l.part.Position = l.basePos + wave
			end
		end
		lastWdSpawn += dt
		if lastWdSpawn >= 0.09 then
			lastWdSpawn = 0
			spawnWindLine(dir, speed)
		end
	end)
	table.insert(cleanups, function()
		rsWd:Disconnect()
		for _, l in ipairs(windLines) do l.part:Destroy() end
		table.clear(windLines)
		pcall(function() Workspace.GlobalWind = Vector3.zero end)
	end)

	CFG.toggles.wd_enabled = wdEnabled
	CFG.sliders.wd_maxlines = wdMaxLines; CFG.sliders.wd_speed = wdSpeed
end

----------------------------------------------------------------------------------
-- SECTION 5x: Aura Pulse
----------------------------------------------------------------------------------
do
	local apSec = newSection(pgCharacter, "Aura Pulse")
	local apEnabled = apSec:Toggle({ Name = "Enabled", Default = false, Flag = "ap_enabled" })
	local apColor1 = newColorpicker(apSec, { Name = "Color 1", Default = Color3.fromRGB(160, 32, 240), Alpha = 1, Flag = "ap_color1" })
	local apColor2 = newColorpicker(apSec, { Name = "Color 2", Default = Color3.fromRGB(0, 140, 255), Alpha = 1, Flag = "ap_color2" })
	local apSettings = settingsOf(apSec, apEnabled)
	local apOrbitRadius = apSettings:Slider({ Name = "Orbit radius", Min = 10, Max = 80, Step = 5, Default = 36, Suffix = "ds", Flag = "ap_orbitradius" })
	local apOrbitSpeed  = apSettings:Slider({ Name = "Orbit speed", Min = 10, Max = 200, Step = 10, Default = 100, Suffix = "%", Flag = "ap_orbitspeed" })
	local apPulseEvery  = apSettings:Slider({ Name = "Pulse interval", Min = 5, Max = 50, Step = 5, Default = 16, Suffix = "ds", Flag = "ap_pulseevery" })
	local apMaxSize     = apSettings:Slider({ Name = "Pulse max size", Min = 5, Max = 40, Step = 1, Default = 18, Flag = "ap_maxsize" })

	local ApTweenService = game:GetService("TweenService")
	local apFolder = Instance.new("Folder")
	apFolder.Name = "MisanthropyAuraPulse"
	apFolder.Parent = Workspace
	table.insert(cleanups, function() if apFolder then apFolder:Destroy() end end)

	local function createCometOrb(color: Color3): (BasePart, Trail)
		local orb = Instance.new("Part")
		orb.Shape = Enum.PartType.Ball
		orb.Size = Vector3.new(0.5, 0.5, 0.5)
		orb.Material = Enum.Material.Neon
		orb.Color = color
		orb.Anchored = true; orb.CanCollide = false; orb.CanQuery = false; orb.CanTouch = false; orb.CastShadow = false
		orb.Parent = apFolder
		local a0 = Instance.new("Attachment"); a0.Position = Vector3.new(0, 0.25, 0); a0.Parent = orb
		local a1 = Instance.new("Attachment"); a1.Position = Vector3.new(0, -0.25, 0); a1.Parent = orb
		local trail = Instance.new("Trail")
		trail.Attachment0 = a0; trail.Attachment1 = a1
		trail.Color = ColorSequence.new(color)
		trail.Lifetime = 0.7
		trail.Transparency = NumberSequence.new(0.3)
		trail.WidthScale = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1.2), NumberSequenceKeypoint.new(1, 0) })
		trail.Parent = orb
		local sparks = Instance.new("ParticleEmitter")
		sparks.Texture = "rbxasset://textures/particles/sparkles_main.dds"
		sparks.Size = NumberSequence.new(0.15, 0)
		sparks.Lifetime = NumberRange.new(0.3, 0.6)
		sparks.Rate = 10
		sparks.Speed = NumberRange.new(0.5, 1.5)
		sparks.Transparency = NumberSequence.new(0, 1)
		sparks.Color = ColorSequence.new(color)
		sparks.Parent = orb
		return orb, trail
	end

	local orb1, trail1 = createCometOrb(apColor1:Get())
	local orb2, trail2 = createCometOrb(apColor2:Get())

	local ambientLight = Instance.new("PointLight")
	ambientLight.Range = 10; ambientLight.Brightness = 1.2
	ambientLight.Parent = orb1

	local function triggerPulse(root: BasePart, startColor: Color3)
		local pulse = Instance.new("Part")
		pulse.Shape = Enum.PartType.Ball
		pulse.Material = Enum.Material.Neon
		pulse.Color = startColor
		pulse.Size = Vector3.new(0.1, 0.1, 0.1)
		pulse.Transparency = 0.3
		pulse.Anchored = true; pulse.CanCollide = false; pulse.CanQuery = false; pulse.CanTouch = false; pulse.CastShadow = false
		pulse.Position = root.Position
		pulse.Parent = apFolder
		local maxSize = apMaxSize:Get()
		local tween = ApTweenService:Create(pulse, TweenInfo.new(1.1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
			Size = Vector3.new(maxSize, maxSize, maxSize), Transparency = 1,
		})
		tween:Play()
		tween.Completed:Connect(function() pulse:Destroy() end)
		ApTweenService:Create(ambientLight, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Brightness = 4.5, Range = 20 }):Play()
		task.delay(0.18, function()
			if ambientLight.Parent then
				ApTweenService:Create(ambientLight, TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Brightness = 1.2, Range = 10 }):Play()
			end
		end)
	end

	local pulseCounter = 0
	local lastPulse = 0
	local apAngle = 0
	local rsAp = RunService.Heartbeat:Connect(function(dt: number)
		if not apEnabled:Get() then
			orb1.Transparency = 1; orb2.Transparency = 1
			trail1.Enabled = false; trail2.Enabled = false
			return
		end
		trail1.Enabled = true; trail2.Enabled = true
		local root = getRootPart()
		if not root then return end
		local radius = apOrbitRadius:Get() / 10
		local speed = apOrbitSpeed:Get() / 100 * 2.8
		apAngle += dt * speed
		local rootPos = root.Position
		local breathing = 0.5 + math.sin(apAngle * 3) * 0.12
		orb1.Size = Vector3.new(breathing, breathing, breathing)
		orb2.Size = Vector3.new(breathing, breathing, breathing)
		orb1.Transparency = 0; orb2.Transparency = 0
		orb1.Color = apColor1:Get(); orb2.Color = apColor2:Get()
		local p1 = rootPos + Vector3.new(math.cos(apAngle) * radius, math.sin(apAngle * 2) * 0.5, math.sin(apAngle) * radius)
		local p2 = rootPos + Vector3.new(math.cos(apAngle + math.pi) * radius, math.sin((apAngle + math.pi) * 2) * 0.5, math.sin(apAngle + math.pi) * radius)
		orb1.Position = orb1.Position:Lerp(p1, 1 - math.exp(-14 * dt))
		orb2.Position = orb2.Position:Lerp(p2, 1 - math.exp(-14 * dt))

		local now = os.clock()
		if (now - lastPulse) >= (apPulseEvery:Get() / 10) then
			lastPulse = now
			pulseCounter = (pulseCounter % 2) + 1
			triggerPulse(root, pulseCounter == 1 and apColor1:Get() or apColor2:Get())
		end
	end)
	table.insert(cleanups, function() rsAp:Disconnect() end)

	CFG.toggles.ap_enabled = apEnabled
	CFG.sliders.ap_orbitradius = apOrbitRadius; CFG.sliders.ap_orbitspeed = apOrbitSpeed
	CFG.sliders.ap_pulseevery = apPulseEvery; CFG.sliders.ap_maxsize = apMaxSize
	CFG.colors.ap_color1 = apColor1; CFG.colors.ap_color2 = apColor2
end

----------------------------------------------------------------------------------
-- SECTION 5y: Vault Sorter
----------------------------------------------------------------------------------
do
	local vsSec = newSection(pgUtility, "Vault Sorter")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")

	local VS_TRASH_THRESHOLD = 1000
	local VS_MOVE_DELAY = 0.05

	local VS_CATEGORY_ORDER = {
		"Keys", "Weapons", "Attachments", "Ammo", "Magazines", "Armor", "Clothing",
		"Backpacks", "Fabrics", "Utility", "Medical", "Treasure", "Trash", "Rubles",
	}

	local function vsGetRank(cat: string): number
		for i, v in ipairs(VS_CATEGORY_ORDER) do
			if v == cat then return i end
		end
		return 999
	end

	local function vsGetItemProperties(itemName: string): { ItemType: string, SlotType: string, Cost: number }?
		local itemsList = ReplicatedStorage:FindFirstChild("ItemsList")
		if not itemsList then return nil end
		local entry = itemsList:FindFirstChild(itemName)
		if not entry then return nil end
		local props = entry:FindFirstChild("ItemProperties")
		if not props then return nil end
		local itemType = props:GetAttribute("ItemType") or (props:FindFirstChild("ItemType") and props.ItemType.Value) or ""
		local slotType = props:GetAttribute("SlotType") or (props:FindFirstChild("SlotType") and props.SlotType.Value) or ""
		local cost = props:GetAttribute("Cost") or props:GetAttribute("Price") or (props:FindFirstChild("Cost") and props.Cost.Value) or (props:FindFirstChild("Price") and props.Price.Value)
		cost = tonumber(cost) or 0
		return { ItemType = itemType, SlotType = slotType, Cost = cost }
	end

	local function vsGetCategory(name: string, props: { ItemType: string, SlotType: string, Cost: number }?): string
		if not props then return "Trash" end
		local t, s, c = props.ItemType, props.SlotType, props.Cost
		if t == "Material" and name == "Rubles" then return "Rubles"
		elseif t == "Key" or t == "Keycard" then return "Keys"
		elseif t == "Ammo" then return "Ammo"
		elseif t == "Magazine" then return "Magazines"
		elseif (t == "RangedWeapon" and s ~= "FlareGun") or t == "Grenade" then return "Weapons"
		elseif t == "Handle" or t == "Stock" or t == "Front" or t == "Muzzle" or t == "Sight" or t == "Extra" then return "Attachments"
		elseif (t == "Clothing" and (s == "ClothingChestRig" or s == "ClothingHeadware" or s == "ClothingLegArmor")) or t == "Visor" or t == "HelmetMask" then return "Armor"
		elseif (t == "Clothing" and (s == "ClothingMask" or s == "ClothingShirt" or s == "ClothingPants" or s == "ClothingGloves")) or t == "Filter" then return "Clothing"
		elseif t == "Clothing" and s == "ClothingBackpack" then return "Backpacks"
		elseif t == "Barter" and string.find(name, "Fabric") then return "Fabrics"
		elseif t == "Medical" then return "Medical"
		elseif t == "Equipment" or t == "Buildable" or t == "RepairKit" then return "Utility"
		else return (c > VS_TRASH_THRESHOLD) and "Treasure" or "Trash" end
	end

	local function vsGetMaxUISlot(): number
		local maxSlot = 0
		pcall(function()
			local gui = LocalPlayer.PlayerGui:WaitForChild("MainGui")
			local mainFrame = gui:WaitForChild("MainFrame")
			local backpackFrame = mainFrame:WaitForChild("BackpackFrame")
			local loot = backpackFrame:WaitForChild("Loot")
			local inventoryFrame = loot:WaitForChild("Inventory")
			local scrollingFrame = inventoryFrame:WaitForChild("ScrollingFrame")
			local containerFrame = scrollingFrame:WaitForChild("Container")
			local frame = containerFrame:WaitForChild("Frame")
			for _, child in ipairs(frame:GetChildren()) do
				if child.Name:match("Container%d+") and child.Visible then
					local num = tonumber(child.Name:sub(10))
					if num and num > maxSlot then maxSlot = num end
				end
			end
		end)
		return maxSlot
	end

	local function sortVault()
		local vault = ReplicatedStorage:FindFirstChild("Players")
			and ReplicatedStorage.Players:FindFirstChild(LocalPlayer.Name)
			and ReplicatedStorage.Players[LocalPlayer.Name]:FindFirstChild("VaultStorage")
		if not vault then notify("Vault Sorter", "No vault found."); return end

		local inventory = vault:FindFirstChild("Inventory")
		if not inventory then notify("Vault Sorter", "Vault has no inventory."); return end

		local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("InventoryMove")
		if not remote then notify("Vault Sorter", "InventoryMove remote not found."); return end

		local maxSlot = vsGetMaxUISlot()
		if maxSlot == 0 then notify("Vault Sorter", "Couldn't read vault UI (open your vault first)."); return end

		local items = {}
		local slotToItem = {}
		local itemToSlot = {}

		for _, obj in ipairs(inventory:GetChildren()) do
			local slot = obj:GetAttribute("Slot")
			if slot then
				local num = tonumber(slot:match("Container(%d+)"))
				if num and num <= maxSlot then
					table.insert(items, obj)
					slotToItem[slot] = obj
					itemToSlot[obj] = slot
				end
			end
		end

		local enriched = {}
		for _, obj in ipairs(items) do
			local props = vsGetItemProperties(obj.Name)
			local cat = vsGetCategory(obj.Name, props)
			local cost = props and props.Cost or 0
			local durability = obj:GetAttribute("Durability") or 0
			local rawSkin = obj:GetAttribute("Skin") or ""
			local skin = rawSkin
			if skin == "" or skin == "None" or skin == "Default" or skin == "Normal" then
				skin = ""
			end
			local loadedAmmo = obj:GetAttribute("LoadedAmmo") or 0
			local amount = obj:GetAttribute("Amount") or 1
			table.insert(enriched, {
				obj = obj, name = obj.Name, slot = itemToSlot[obj], cost = cost, cat = cat,
				durability = durability, skin = skin, loadedAmmo = loadedAmmo, amount = amount,
			})
		end

		local nonRubles, rubles = {}, {}
		for _, item in ipairs(enriched) do
			if item.cat == "Rubles" then table.insert(rubles, item) else table.insert(nonRubles, item) end
		end

		table.sort(nonRubles, function(a, b)
			if a.cat ~= b.cat then return vsGetRank(a.cat) < vsGetRank(b.cat) end
			if a.cat == "Treasure" and a.cost ~= b.cost then return a.cost > b.cost end
			local groupA, groupB = a.name .. "|" .. a.skin, b.name .. "|" .. b.skin
			if groupA ~= groupB then return groupA < groupB end
			if a.durability ~= b.durability then return a.durability > b.durability end
			if a.loadedAmmo ~= b.loadedAmmo then return a.loadedAmmo > b.loadedAmmo end
			if a.amount ~= b.amount then return a.amount > b.amount end
			return false
		end)

		table.sort(rubles, function(a, b) return a.amount > b.amount end)

		local finalOrder = {}
		for _, item in ipairs(nonRubles) do finalOrder[#finalOrder + 1] = item.obj end
		for _, item in ipairs(rubles) do finalOrder[#finalOrder + 1] = item.obj end

		local targetSlotMap = {}
		for i = 1, #nonRubles do targetSlotMap[nonRubles[i].obj] = "Container" .. i end
		local rublesStart = maxSlot - #rubles + 1
		for i = 1, #rubles do targetSlotMap[rubles[i].obj] = "Container" .. (rublesStart + i - 1) end

		for _, obj in ipairs(finalOrder) do
			local target = targetSlotMap[obj]
			if not target then continue end
			local currentSlot = itemToSlot[obj]
			if currentSlot == target then continue end
			local currentOccupant = slotToItem[target]
			if currentOccupant == obj then continue end
			if currentOccupant then
				remote:FireServer(currentSlot, target, inventory, inventory, nil)
				task.wait(VS_MOVE_DELAY)
				slotToItem[target] = obj
				slotToItem[currentSlot] = currentOccupant
				itemToSlot[obj] = target
				itemToSlot[currentOccupant] = currentSlot
			else
				remote:FireServer(currentSlot, target, inventory, inventory, nil)
				task.wait(VS_MOVE_DELAY)
				slotToItem[target] = obj
				slotToItem[currentSlot] = nil
				itemToSlot[obj] = target
			end
		end

		notify("Vault Sorter", "Vault sorted.")
	end

	vsSec:Label("Sorts your own vault by category, cost, durability, skin and amount.")
	vsSec:Button({ Name = "Sort Vault", Callback = function()
		task.spawn(sortVault)
	end })
end

----------------------------------------------------------------------------------
-- SECTION 5z: Movement
----------------------------------------------------------------------------------
do
	local msaSec = newSection(pgPlayer, "Movement")
	local msaEnabled = msaSec:Toggle({
		Name = "Max Slope Angle (stops getting stuck on debris/geometry)",
		Default = false,
		Flag = "msa_enabled",
	})

	local MSA_VALUE = 89
	local msaChar: Model? = nil
	local msaOriginal: number? = nil

	local function applyMaxSlope()
		local char = getCharacter()
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if not char or not hum then return end

		-- re-baseline on every respawn: a fresh Humanoid may not carry the
		-- same MaxSlopeAngle the last one had, so always capture what this
		-- specific character actually started at before we touch it.
		if char ~= msaChar then
			msaChar = char
			msaOriginal = hum.MaxSlopeAngle
		end

		local target = msaEnabled:Get() and MSA_VALUE or (msaOriginal :: number)
		if hum.MaxSlopeAngle ~= target then
			hum.MaxSlopeAngle = target
		end
	end

	local rsMsa = RunService.Heartbeat:Connect(applyMaxSlope)
	table.insert(cleanups, function()
		rsMsa:Disconnect()
		local char = getCharacter()
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if hum and msaOriginal ~= nil then
			hum.MaxSlopeAngle = msaOriginal
		end
	end)

	CFG.toggles.msa_enabled = msaEnabled
end

----------------------------------------------------------------------------------
-- SECTION 6: Configs
----------------------------------------------------------------------------------
do
	local function gatherConfig(): { [string]: any }
		local data: any = { toggles = {}, sliders = {}, dropdowns = {}, colors = {} }
		for k, c in pairs(CFG.toggles) do data.toggles[k] = c:Get() end
		for k, c in pairs(CFG.sliders) do data.sliders[k] = c:Get() end
		for k, c in pairs(CFG.dropdowns) do data.dropdowns[k] = c:Get() end
		for k, c in pairs(CFG.colors) do
			local col, alpha = c:Get()
			data.colors[k] = { hex = col:ToHex(), t = alpha or 0 }
		end
		return data
	end

	local function applyConfig(data: any)
		if type(data) ~= "table" then return end
		if data.toggles then for k, c in pairs(CFG.toggles) do
			local v = data.toggles[k]; if v ~= nil then pcall(function() c:Set(v) end) end
		end end
		if data.sliders then for k, c in pairs(CFG.sliders) do
			local v = data.sliders[k]; if v ~= nil then pcall(function() c:Set(v) end) end
		end end
		if data.dropdowns then for k, c in pairs(CFG.dropdowns) do
			local v = data.dropdowns[k]; if v ~= nil then pcall(function() c:Set(v) end) end
		end end
		if data.colors then for k, c in pairs(CFG.colors) do
			local v = data.colors[k]
			if v and v.hex then
				pcall(function() c:Set(Color3.fromHex(v.hex), v.t or 0) end)
			end
		end end
	end

	local function slotPath(slot: string): string
		return "configs/" .. (string.gsub(slot, "%s+", "_")) .. ".json"
	end

	local function saveConfig(slot: string)
		if not _writefile then notify("Configs", "No file API on this executor."); return end
		local ok, json = pcall(function() return HttpService:JSONEncode(gatherConfig()) end)
		if not ok then notify("Configs", "Encode failed."); return end
		ensureDir(ROOT .. "/configs")
		if not pcall(_writefile, ROOT .. "/" .. slotPath(slot), json) then notify("Configs", "Save failed.") end
	end

	local function loadConfig(slot: string)
		local raw = loadString(slotPath(slot))
		if not raw then return end
		local ok, data = pcall(function() return HttpService:JSONDecode(raw) end)
		if ok then applyConfig(data) else notify("Configs", "Corrupt config.") end
	end

	local cfgSec = newSection(pgConfigs, "Configs")
	local CFG_SLOTS = { "Slot 1", "Slot 2", "Slot 3", "Slot 4", "Slot 5" }
	local cfgSlot   = cfgSec:Dropdown({ Name = "Config slot", Items = CFG_SLOTS, Default = "Slot 1", Flag = "cfg_slot" })
	cfgSec:Button({ Name = "Save config", Callback = function() saveConfig(cfgSlot:Get()) end })
	cfgSec:Button({ Name = "Load config", Callback = function() loadConfig(cfgSlot:Get()) end })
	cfgSec:Button({ Name = "Delete config", Callback = function()
		local p = ROOT .. "/" .. slotPath(cfgSlot:Get())
		if _delfile and _isfile and _isfile(p) then pcall(_delfile, p) end
	end })
end

----------------------------------------------------------------------------------
-- LOAD SPLASH
----------------------------------------------------------------------------------
do
	local TweenService = game:GetService("TweenService")
	local SoundService = game:GetService("SoundService")

	local logoId: string? = nil
	local soundId: string? = nil
	if _isfile and _getasset then
		if _isfile(ROOT .. "/logo.png") then
			local ok, id = pcall(_getasset, ROOT .. "/logo.png")
			if ok then logoId = id end
		end
		if _isfile(ROOT .. "/splash.mp3") then
			local ok, id = pcall(_getasset, ROOT .. "/splash.mp3")
			if ok then soundId = id end
		end
	end
	if not logoId then notify("Splash", "logo.png not found in " .. ROOT .. "/") end
	if not soundId then notify("Splash", "splash.mp3 not found in " .. ROOT .. "/") end

	local blackout = Instance.new("Frame")
	blackout.Name = "MisanthropyBlackout"
	blackout.Size = UDim2.fromScale(1, 1)
	blackout.BackgroundColor3 = Color3.new(0, 0, 0)
	blackout.BackgroundTransparency = 1
	blackout.BorderSizePixel = 0
	blackout.ZIndex = 9998
	blackout.Parent = screen

	local logo = Instance.new("ImageLabel")
	logo.Name = "MisanthropyLogo"
	logo.BackgroundTransparency = 1
	logo.AnchorPoint = Vector2.new(0.5, 0.5)
	logo.Position = UDim2.fromScale(0.5, 0.5)
	logo.Size = UDim2.fromOffset(400, 400)
	logo.Image = logoId or ""
	logo.ImageTransparency = 1
	logo.ScaleType = Enum.ScaleType.Fit
	logo.ZIndex = 9999
	logo.Parent = screen

	task.spawn(function()
		TweenService:Create(blackout, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 0 }):Play()
		task.wait(0.6)

		if soundId then
			pcall(function()
				local snd = Instance.new("Sound")
				snd.SoundId = soundId
				snd.Volume = 0.6
				snd.Parent = SoundService
				SoundService:PlayLocalSound(snd)
				task.delay(10, function() snd:Destroy() end)
			end)
		end
		TweenService:Create(logo, TweenInfo.new(1.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { ImageTransparency = 0.15 }):Play()
		task.wait(2.6)

		local vp = Workspace.CurrentCamera and Workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
		local dockPos = UDim2.fromOffset(vp.X - 12 - 48, vp.Y - 12 - 48)
		TweenService:Create(blackout, TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { BackgroundTransparency = 1 }):Play()
		TweenService:Create(logo, TweenInfo.new(1.1, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {
			Position = dockPos,
			Size = UDim2.fromOffset(96, 96),
			ImageTransparency = 0.35,
		}):Play()

		task.wait(1.2)
		blackout:Destroy()

		local rsWm = RunService.RenderStepped:Connect(function()
			local vps = Workspace.CurrentCamera and Workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
			logo.Position = UDim2.fromOffset(vps.X - 12 - 48, vps.Y - 12 - 48)
		end)
		table.insert(cleanups, function() rsWm:Disconnect() end)
	end)
end
