--!strict



----------------------------------------------------------------------------------
-- EMBEDDED: UI library (vendored, Library.lua by @joestar._3 / sametexe001/sametlibs).
-- ESPPreview/TargetIndicator/RadarWidget/ModeratorList stripped before vendoring.
-- Trailing top-level `return Library` removed (see CLAUDE.md for why).
----------------------------------------------------------------------------------
--[[
    2/22/2026
    Library.lua
    Purpose:
        NH ui library

    Author: @joestar._3
    Dependencies:
        None
]]

-- hi guys

if getgenv().MisanthropyLandryUI and getgenv().MisanthropyLandryUI.Exit then
    getgenv().MisanthropyLandryUI:Exit()
end

-- Bad executor support (atleast by a bit)
cloneref = cloneref or function(Object) return Object end

--#region Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local ContextActionService = game:GetService("ContextActionService")
local CoreGui = cloneref(game:GetService("CoreGui"))
local GuiService = game:GetService("GuiService")
--#endregion

gethui = gethui or function() return CoreGui end

--#region Variables
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = cloneref(LocalPlayer:GetMouse())
local GuiInset = GuiService:GetGuiInset().Y
local BlockedWindowInputs = {
    Enum.KeyCode.W,
    Enum.KeyCode.A,
    Enum.KeyCode.S,
    Enum.KeyCode.D,
    Enum.KeyCode.Space,
    Enum.KeyCode.LeftShift,
    Enum.KeyCode.RightShift,
    Enum.KeyCode.LeftControl,
    Enum.KeyCode.RightControl,
    Enum.KeyCode.LeftAlt,
    Enum.KeyCode.RightAlt,
    Enum.KeyCode.Up,
    Enum.KeyCode.Down,
    Enum.KeyCode.Left,
    Enum.KeyCode.Right,
    Enum.KeyCode.Return,
    Enum.KeyCode.KeypadEnter,
    Enum.KeyCode.Slash,
    Enum.KeyCode.Backquote,
    Enum.KeyCode.Tab,
    Enum.KeyCode.E,
    Enum.KeyCode.Q,
    Enum.KeyCode.R,
    Enum.KeyCode.F,
    Enum.KeyCode.C,
    Enum.KeyCode.Z,
    Enum.KeyCode.X,
    Enum.KeyCode.One,
    Enum.KeyCode.Two,
    Enum.KeyCode.Three,
    Enum.KeyCode.Four,
    Enum.KeyCode.Five,
    Enum.KeyCode.Six,
    Enum.KeyCode.Seven,
    Enum.KeyCode.Eight,
    Enum.KeyCode.Nine,
    Enum.KeyCode.Zero
}
--#endregion

local Library = {
    Flags = {},
    MenuKeybind = tostring(Enum.KeyCode.X),

    Directory = "niggahack",
    Folders = {
        Assets = "/Assets",
        Configs = "/Configs"
    },

    FontSize = 9,

    Animation = {
        Time = 0.3,
        Style = "Quint",
        Direction = "Out"
    },

    Theme = nil,

    -- Ignore below
    Threads = {},
    Connections = {},
    Notifications = {},
    SetFlags = {},

    ThemingStuff = {},
    ThemeMap = {},

    OpenFrames = {},
    WindowVisibilityBindings = {},
    WindowOpenState = true,
    InputBlockAction = "NH_UI_INPUT_BLOCK",
    BackgroundEffects = nil,
    BackgroundBlurEnabled = true,
    BackgroundSnowEnabled = true,
    CopiedColor = nil,
    LayoutRegistry = {},
    SettingsWidgets = {},
    ActiveConfirmDialog = nil,
    MouseCursor = nil,
    MouseStateBeforeOpen = nil,

    Holder = nil,
    UnusedHolder = nil,

    Font = nil
}
do
    Library.__index = Library

    local Flags = Library.Flags
    local SetFlags = Library.SetFlags

    local Keys = {
        ["Unknown"]          = "Unknown",
        ["Backspace"]        = "Back",
        ["Tab"]              = "Tab",
        ["Clear"]            = "Clear",
        ["Return"]           = "Return",
        ["Pause"]            = "Pause",
        ["Escape"]           = "Escape",
        ["Space"]            = "Space",
        ["QuotedDouble"]     = '"',
        ["Hash"]             = "#",
        ["Dollar"]           = "$",
        ["Percent"]          = "%",
        ["Ampersand"]        = "&",
        ["Quote"]            = "'",
        ["LeftParenthesis"]  = "(",
        ["RightParenthesis"] = " )",
        ["Asterisk"]         = "*",
        ["Plus"]             = "+",
        ["Comma"]            = ",",
        ["Minus"]            = "-",
        ["Period"]           = ".",
        ["Slash"]            = "`",
        ["Three"]            = "3",
        ["Seven"]            = "7",
        ["Eight"]            = "8",
        ["Colon"]            = ":",
        ["Semicolon"]        = ";",
        ["LessThan"]         = "<",
        ["GreaterThan"]      = ">",
        ["Question"]         = "?",
        ["Equals"]           = "=",
        ["At"]               = "@",
        ["LeftBracket"]      = "LeftBracket",
        ["RightBracket"]     = "RightBracked",
        ["BackSlash"]        = "BackSlash",
        ["Caret"]            = "^",
        ["Underscore"]       = "_",
        ["Backquote"]        = "`",
        ["LeftCurly"]        = "{",
        ["Pipe"]             = "|",
        ["RightCurly"]       = "}",
        ["Tilde"]            = "~",
        ["Delete"]           = "Delete",
        ["End"]              = "End",
        ["KeypadZero"]       = "Keypad0",
        ["KeypadOne"]        = "Keypad1",
        ["KeypadTwo"]        = "Keypad2",
        ["KeypadThree"]      = "Keypad3",
        ["KeypadFour"]       = "Keypad4",
        ["KeypadFive"]       = "Keypad5",
        ["KeypadSix"]        = "Keypad6",
        ["KeypadSeven"]      = "Keypad7",
        ["KeypadEight"]      = "Keypad8",
        ["KeypadNine"]       = "Keypad9",
        ["KeypadPeriod"]     = "KeypadP",
        ["KeypadDivide"]     = "KeypadD",
        ["KeypadMultiply"]   = "KeypadM",
        ["KeypadMinus"]      = "KeypadM",
        ["KeypadPlus"]       = "KeypadP",
        ["KeypadEnter"]      = "KeypadE",
        ["KeypadEquals"]     = "KeypadE",
        ["Insert"]           = "Insert",
        ["Home"]             = "Home",
        ["PageUp"]           = "PageUp",
        ["PageDown"]         = "PageDown",
        ["RightShift"]       = "RightShift",
        ["LeftShift"]        = "LeftShift",
        ["RightControl"]     = "RightControl",
        ["LeftControl"]      = "LeftControl",
        ["LeftAlt"]          = "LeftAlt",
        ["RightAlt"]         = "RightAlt"
    }

    -- Folders
    if not isfolder(Library.Directory) then
        makefolder(Library.Directory)
    end

    for _, Folder in Library.Folders do
        if not isfolder(Library.Directory .. Folder) then
            makefolder(Library.Directory .. Folder)
        end
    end

    local Themes = {
        ["Preset"] = {
            ["Background"] = Color3.fromRGB(16, 17, 20),
            ["Outline"] = Color3.fromRGB(36, 38, 45),
            ["Border"] = Color3.fromRGB(7, 8, 10),
            ["Accent"] = Color3.fromRGB(255, 255, 255),
            ["Risky"] = Color3.fromRGB(255, 50, 50),
            ["Light Border"] = Color3.fromRGB(12, 8, 12),
            ["Border 2"] = Color3.fromRGB(5, 10, 14),
            ["Text"] = Color3.fromRGB(180, 180, 180),
            ["Section"] = Color3.fromRGB(20, 21, 25),
            ["Element"] = Color3.fromRGB(28, 29, 35),
            ["Hovered Element"] = Color3.fromRGB(36, 38, 45),
            ["Inactive Text"] = Color3.fromRGB(100, 100, 100)
        }
    }

    Library.Theme = Themes.Preset

    -- Custom Font
    local CustomFont = {}
    do
        function CustomFont:New(Name, Weight, Style, Data)
            if not isfile(Data.Id) then
                writefile(Data.Id, game:HttpGet(Data.Url))
            end

            local Data = {
                name = Name,
                faces = {
                    {
                        name = Name,
                        weight = Weight,
                        style = Style,
                        assetId = getcustomasset(Data.Id)
                    }
                }
            }

            writefile(`{Library.Directory .. Library.Folders.Assets}/{Name}.font`, HttpService:JSONEncode(Data))
            return Font.new(getcustomasset(`{Library.Directory .. Library.Folders.Assets}/{Name}.font`))
        end

        Library.Font = CustomFont:New("SmallestPixel7", 400, "Regular", {
            Id = "SmallestPixel7",
            Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/smallest_pixel-7.ttf"
        })
    end

    Library.Exit = function(Self)
        Self:ApplyWindowInputState(false)

        if Self.BackgroundEffects then
            Self.BackgroundEffects.IsSnowing = false

            if Self.BackgroundEffects.BlurEffect and Self.BackgroundEffects.BlurEffect.Parent then
                Self.BackgroundEffects.BlurEffect:Destroy()
            end

            if Self.BackgroundEffects.Background and Self.BackgroundEffects.Background.Parent then
                Self.BackgroundEffects.Background:Destroy()
            end
        end

        for _, Connection in Library.Connections do
            Connection:Disconnect()
        end

        for _, Thread in Library.Threads do
            coroutine.close(Thread)
        end

        if Self.Holder then
            Self.Holder.Instance:Destroy()
        end

        if Self.UnusedHolder then
            Self.UnusedHolder.Instance:Destroy()
        end

        Library = nil
        getgenv().MisanthropyLandryUI = nil
    end

    Library.Create = function(Self, Class, Properties)
        local Data = {
            Class = Class,
            Properties = Properties,
            Instance = Instance.new(Class)
        }

        for Index, Property in Properties do
            if Property == "FontFace" then
                Data.Instance[Property] = Library.Font
                continue
            end

            if Property == "TextSize" then
                Data.Instance[Property] = Library.FontSize
                continue
            end

            if Property == "Name" then
                Data.Instance[Property] = "\0"
                continue
            end

            if Class == "TextButton" then
                if Property == "AutoButtonColor" then
                    Data.Instance[Property] = false
                    continue
                end

                if Property == "Text" then
                    Data.Instance[Property] = ""
                    continue
                end
            end

            Data.Instance[Index] = Property
        end

        return setmetatable(Data, Library)
    end

    Library.Thread = function(Self, Function)
        local NewThread = coroutine.create(Function)

        coroutine.wrap(function()
            coroutine.resume(NewThread)
        end)()

        table.insert(Library.Threads, NewThread)
        return NewThread
    end

    Library.Connect = function(Self, Signal, Callback)
        local Connection

        if Self.Instance then
            if Self.Instance[Signal] then
                Connection = Self.Instance[Signal]:Connect(Callback)
            else
                Connection = Signal:Connect(Callback)
            end
        else
            Connection = Signal:Connect(Callback)
        end

        table.insert(Library.Connections, Connection)
        return Connection
    end

    Library.Tween = function(Self, Properties, Info, IsRawItem)
        local Object = Self.Instance or IsRawItem
        Info = Info or
            TweenInfo.new(Library.Animation.Time, Enum.EasingStyle[Library.Animation.Style],
                Enum.EasingDirection[Library.Animation.Direction])

        if not Object then
            return
        end

        local NewTween = TweenService:Create(Object, Info, Properties)
        NewTween:Play()

        return NewTween
    end

    Library.GetTweenProperty = function(Self, IsRawItem)
        local Object = Self.Instance or IsRawItem

        if not Object then
            return {}
        end

        if Object:IsA("Frame") then
            return { "BackgroundTransparency" }
        elseif Object:IsA("TextLabel") or Object:IsA("TextButton") then
            return { "TextTransparency", "BackgroundTransparency" }
        elseif Object:IsA("ImageLabel") or Object:IsA("ImageButton") then
            return { "BackgroundTransparency", "ImageTransparency" }
        elseif Object:IsA("ScrollingFrame") then
            return { "BackgroundTransparency", "ScrollBarImageTransparency" }
        elseif Object:IsA("TextBox") then
            return { "TextTransparency", "BackgroundTransparency" }
        elseif Object:IsA("UIStroke") then
            return { "Transparency" }
        end
    end

    Library.Fade = function(Self, Property, Visibility, IsRawItem)
        local Object = Self.Instance or IsRawItem

        if not Object then
            return
        end

        local OldTransparency = Object[Property]
        Object[Property] = Visibility and 1 or OldTransparency

        local NewTween = Library:Tween({
            [Property] = Visibility and OldTransparency or 1
        }, nil, Object)

        Library:Connect(NewTween.Completed, function()
            if not Visibility then
                task.wait()
                Object[Property] = OldTransparency
            end
        end)

        return NewTween
    end

    Library.FadeDescendants = function(Self, Visibility, Callback)
        if Visibility then
            Self.Instance.Visible = true
        end

        local NewTween

        local Children = Self.Instance:GetDescendants()
        table.insert(Children, Self.Instance)

        for _, Child in Children do
            local TransparencyProperty = Library:GetTweenProperty(Child)

            if not TransparencyProperty then
                continue
            end

            if type(TransparencyProperty) == "table" then
                for _, Property in TransparencyProperty do
                    NewTween = Library:Fade(Property, Visibility, Child)
                end
            else
                NewTween = Library:Fade(TransparencyProperty, Visibility, Child)
            end
        end

        Library:Connect(NewTween.Completed, function()
            if Callback and type(Callback) == "function" then
                Callback()
            end

            Self.Instance.Visible = Visibility
        end)
    end

    Library.MakeDraggable = function(Self)
        if not Self.Instance then
            return
        end

        local Gui = Self.Instance
        local Dragging = false
        local DragStart
        local StartPosition

        local Set = function(Input)
            local DragDelta = Input.Position - DragStart
            local NewX = StartPosition.X.Offset + DragDelta.X
            local NewY = StartPosition.Y.Offset + DragDelta.Y

            local ScreenSize = Gui.Parent.AbsoluteSize
            local GuiSize = Gui.AbsoluteSize

            NewX = math.clamp(NewX, 0, ScreenSize.X - GuiSize.X)
            NewY = math.clamp(NewY, 0, ScreenSize.Y - GuiSize.Y)

            local MainWindow = Library.MainWindowFrame
            if Gui ~= MainWindow
                and Library.WindowOpenState
                and MainWindow
                and MainWindow.Parent == Gui.Parent
                and MainWindow.Visible
            then
                local PanelPosition = MainWindow.AbsolutePosition
                local PanelSize = MainWindow.AbsoluteSize
                local PanelLeft = PanelPosition.X
                local PanelTop = PanelPosition.Y
                local PanelRight = PanelLeft + PanelSize.X
                local PanelBottom = PanelTop + PanelSize.Y

                local OverlapsX = (NewX < PanelRight) and ((NewX + GuiSize.X) > PanelLeft)
                local OverlapsY = (NewY < PanelBottom) and ((NewY + GuiSize.Y) > PanelTop)

                if OverlapsX and OverlapsY then
                    local LeftGap = math.abs((NewX + GuiSize.X) - PanelLeft)
                    local RightGap = math.abs(NewX - PanelRight)
                    local TopGap = math.abs((NewY + GuiSize.Y) - PanelTop)
                    local BottomGap = math.abs(NewY - PanelBottom)
                    local MinGap = math.min(LeftGap, RightGap, TopGap, BottomGap)

                    if MinGap == LeftGap then
                        NewX = PanelLeft - GuiSize.X
                    elseif MinGap == RightGap then
                        NewX = PanelRight
                    elseif MinGap == TopGap then
                        NewY = PanelTop - GuiSize.Y
                    else
                        NewY = PanelBottom
                    end
                end
            end

            Gui.Position = UDim2.new(0, math.floor(NewX + 0.5), 0, math.floor(NewY + 0.5))
        end

        local InputChanged

        Self:Connect("InputBegan", function(Input)
            if not Library.WindowOpenState then
                return
            end

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
                if Dragging and not Library.WindowOpenState then
                    Dragging = false
                    return
                end

                if Dragging then
                    Set(Input)
                end
            end
        end)

        return Dragging
    end

    Library.MakeResizeable = function(Self, Minimum)
        if not Self.Instance then
            return
        end

        local Gui = Self.Instance

        local Resizing = false
        local CurrentSide = nil

        local StartMouse = nil
        local StartPosition = nil
        local StartSize = nil

        local EdgeThickness = 2

        local MakeEdge = function(Name, Position, Size)
            local Button = Library:Create("TextButton", {
                Name = "\0",
                Size = Size,
                Position = Position,
                BackgroundColor3 = Color3.fromRGB(166, 147, 243),
                BackgroundTransparency = 1,
                Text = "",
                BorderSizePixel = 0,
                AutoButtonColor = false,
                Parent = Gui,
                ZIndex = 99999,
            })
            Button:AddToTheme({ BackgroundColor3 = "Accent" })

            return Button
        end

        local Edges = {
            {
                Button = MakeEdge(
                    "Left",
                    UDim2.new(0, 0, 0, 0),
                    UDim2.new(0, EdgeThickness, 1, 0)),
                Side = "L"
            },

            {
                Button = MakeEdge(
                    "Right",
                    UDim2.new(1, -EdgeThickness, 0, 0),
                    UDim2.new(0, EdgeThickness, 1, 0)),
                Side = "R"
            },

            {
                Button = MakeEdge(
                    "Top", UDim2.new(0, 0, 0, 0),
                    UDim2.new(1, 0, 0, EdgeThickness)),
                Side = "T"
            },

            {
                Button = MakeEdge(
                    "Bottom",
                    UDim2.new(0, 0, 1, -EdgeThickness),
                    UDim2.new(1, 0, 0, EdgeThickness)),
                Side = "B"
            },
        }

        local BeginResizing = function(Side)
            Resizing = true
            CurrentSide = Side

            StartMouse = UserInputService:GetMouseLocation()

            StartPosition = Vector2.new(Gui.Position.X.Offset, Gui.Position.Y.Offset)
            StartSize = Vector2.new(Gui.Size.X.Offset, Gui.Size.Y.Offset)

            for Index, Value in Edges do
                Value.Button.Instance.BackgroundTransparency = (Value.Side == Side) and 0 or 1
            end
        end

        local EndResizing = function()
            Resizing = false
            CurrentSide = nil

            for Index, Value in Edges do
                Value.Button.Instance.BackgroundTransparency = 1
            end
        end

        for Index, Value in Edges do
            Value.Button:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    BeginResizing(Value.Side)
                end
            end)
        end

        Library:Connect(UserInputService.InputEnded, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                if Resizing then
                    EndResizing()
                end
            end
        end)

        Library:Connect(RunService.RenderStepped, function()
            if not Resizing or not CurrentSide then
                return
            end

            local MouseLocation = UserInputService:GetMouseLocation()
            local dx = MouseLocation.X - StartMouse.X
            local dy = MouseLocation.Y - StartMouse.Y

            local x, y = StartPosition.X, StartPosition.Y
            local w, h = StartSize.X, StartSize.Y

            if CurrentSide == "L" then
                x = StartPosition.X + dx
                w = StartSize.X - dx
            elseif CurrentSide == "R" then
                w = StartSize.X + dx
            elseif CurrentSide == "T" then
                y = StartPosition.Y + dy
                h = StartSize.Y - dy
            elseif CurrentSide == "B" then
                h = StartSize.Y + dy
            end

            if w < Minimum.X then
                if CurrentSide == "L" then
                    x = x - (Minimum.X - w)
                end
                w = Minimum.X
            end
            if h < Minimum.Y then
                if CurrentSide == "T" then
                    y = y - (Minimum.Y - h)
                end
                h = Minimum.Y
            end

            Self:Tween({ Position = UDim2.fromOffset(x, y) },
                TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
            Self:Tween({ Size = UDim2.fromOffset(w, h) },
                TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
        end)
    end

    Library.IsMouseOverFrame = function(Self)
        if not Self.Instance then
            return
        end

        local Object = Self.Instance

        local MousePosition = Vector2.new(Mouse.X, Mouse.Y)

        return MousePosition.X >= Object.AbsolutePosition.X and
            MousePosition.X <= Object.AbsolutePosition.X + Object.AbsoluteSize.X
            and MousePosition.Y >= Object.AbsolutePosition.Y and
            MousePosition.Y <= Object.AbsolutePosition.Y + Object.AbsoluteSize.Y
    end

    Library.CompareVectors = function(Self, PointA, PointB)
        return (PointA.X < PointB.X) or (PointA.Y < PointB.Y)
    end

    Library.IsClipped = function(Self, Column)
        if not Self.Instance then
            return
        end

        local Parent = Column
        local Object = Self.Instance

        local BoundryTop = Parent.AbsolutePosition
        local BoundryBottom = BoundryTop + Parent.AbsoluteSize

        local Top = Object.AbsolutePosition
        local Bottom = Top + Object.AbsoluteSize

        return Library:CompareVectors(Top, BoundryTop) or Library:CompareVectors(BoundryBottom, Bottom)
    end

    Library.SafeCall = function(Self, Function, ...)
        local Arguements = { ... }
        local Success, Result = pcall(Function, table.unpack(Arguements))

        if not Success then
            warn(Result)
            return false
        end

        return Success, Result
    end

    Library.BindToWindowVisibility = function(Self, Callback)
        if type(Callback) ~= "function" then
            return
        end

        table.insert(Library.WindowVisibilityBindings, Callback)
        Library:SafeCall(Callback, Library.WindowOpenState)
    end

    Library.ApplyWindowInputState = function(Self, Bool)
        if Self.InputBlocker and Self.InputBlocker.Instance then
            Self.InputBlocker.Instance.Visible = Bool and true or false
        end

        if Bool then
            ContextActionService:BindActionAtPriority(Self.InputBlockAction, function(_, State, Input)
                    if State ~= Enum.UserInputState.Begin and State ~= Enum.UserInputState.Change then
                        return Enum.ContextActionResult.Pass
                    end

                    if not Self.WindowOpenState or UserInputService:GetFocusedTextBox() then
                        return Enum.ContextActionResult.Pass
                    end

                    if Input and (tostring(Input.KeyCode) == Self.MenuKeybind or tostring(Input.UserInputType) == Self.MenuKeybind) then
                        return Enum.ContextActionResult.Pass
                    end

                    return Enum.ContextActionResult.Sink
                end, false, 5000,
                Enum.UserInputType.Gamepad1,
                Enum.UserInputType.Gamepad2,
                Enum.UserInputType.Gamepad3,
                Enum.UserInputType.Gamepad4,
                Enum.UserInputType.Gamepad5,
                Enum.UserInputType.Gamepad6,
                Enum.UserInputType.Gamepad7,
                Enum.UserInputType.Gamepad8,
                Enum.UserInputType.MouseWheel,
                Enum.UserInputType.MouseButton2,
                Enum.UserInputType.MouseButton3
            )

            ContextActionService:BindActionAtPriority(Self.InputBlockAction .. "_KEYS", function(_, State)
                if State ~= Enum.UserInputState.Begin and State ~= Enum.UserInputState.Change then
                    return Enum.ContextActionResult.Pass
                end

                if not Self.WindowOpenState or UserInputService:GetFocusedTextBox() then
                    return Enum.ContextActionResult.Pass
                end

                return Enum.ContextActionResult.Sink
            end, false, 5000, table.unpack(BlockedWindowInputs))
            return
        end

        ContextActionService:UnbindAction(Self.InputBlockAction)
        ContextActionService:UnbindAction(Self.InputBlockAction .. "_KEYS")
    end

    Library.SetWindowVisibilityState = function(Self, Bool)
        Library.WindowOpenState = Bool and true or false
        Library:ApplyWindowInputState(Library.WindowOpenState)

        if Library.WindowOpenState then
            Library.MouseStateBeforeOpen = {
                MouseBehavior = UserInputService.MouseBehavior,
                MouseIconEnabled = UserInputService.MouseIconEnabled,
            }
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            UserInputService.MouseIconEnabled = false
        elseif Library.MouseStateBeforeOpen then
            UserInputService.MouseBehavior = Library.MouseStateBeforeOpen.MouseBehavior or Enum.MouseBehavior.Default
            UserInputService.MouseIconEnabled = Library.MouseStateBeforeOpen.MouseIconEnabled ~= false
            Library.MouseStateBeforeOpen = nil
        else
            UserInputService.MouseIconEnabled = true
        end

        if Library.MouseCursor and Library.MouseCursor.Instance then
            Library.MouseCursor.Instance.Visible = Library.WindowOpenState
        end

        if not Library.WindowOpenState then
            for _, OpenFrame in Library.OpenFrames do
                if OpenFrame and OpenFrame.IsOpen and OpenFrame.SetOpen then
                    OpenFrame:SetOpen(false)
                end
            end
        end

        for _, Callback in Library.WindowVisibilityBindings do
            Library:SafeCall(Callback, Library.WindowOpenState)
        end
    end

    Library.RegisterSettingsWidget = function(Self, Data)
        if type(Data) ~= "table" then
            return
        end

        local Name = Data.Name or Data.name
        local Callback = Data.Callback or Data.callback
        if type(Name) ~= "string" or type(Callback) ~= "function" then
            return
        end

        table.insert(Library.SettingsWidgets, {
            Name = Name,
            Flag = Data.Flag or Data.flag or ("UIWidget" .. Name:gsub("%s+", "")),
            Default = Data.Default ~= false,
            Callback = Callback,
            Settings = Data.Settings or Data.settings
        })
    end

    Library.SetupBackgroundEffects = function(Self)
        if Library.BackgroundEffects then
            return
        end

        local Background = Library:Create("Frame", {
            Name = "\0",
            Parent = Library.Holder.Instance,
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false,
            ZIndex = 0
        })

        local SnowHolder = Library:Create("Frame", {
            Name = "\0",
            Parent = Background.Instance,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 0
        })

        local BlurEffect = Instance.new("BlurEffect")
        BlurEffect.Size = 0
        BlurEffect.Parent = Camera

        Library.BackgroundEffects = {
            Background = Background.Instance,
            SnowHolder = SnowHolder.Instance,
            BlurEffect = BlurEffect,
            SnowAsset = "http://www.roblox.com/asset/?id=6871196088",
            IsSnowing = false
        }

        Library:Thread(function()
            while Library and Library.BackgroundEffects do
                local Effects = Library.BackgroundEffects

                if not Effects.IsSnowing then
                    task.wait(0.1)
                    continue
                end

                local Holder = Effects.SnowHolder
                if not Holder or not Holder.Parent then
                    task.wait(0.1)
                    continue
                end

                local Width = Holder.AbsoluteSize.X
                local Height = Holder.AbsoluteSize.Y
                if Width <= 0 or Height <= 0 then
                    task.wait(0.1)
                    continue
                end

                local Image = Instance.new("ImageLabel")
                Image.Name = "\0"
                Image.Parent = Holder
                Image.BackgroundTransparency = 1
                Image.Image = Effects.SnowAsset
                Image.ZIndex = 0

                local RandomSize = math.random(5, 8)
                local SpawnX = math.random(0, math.max(0, Width - RandomSize))

                Image.Size = UDim2.new(0, RandomSize, 0, RandomSize)
                Image.Position = UDim2.new(0, SpawnX, 0, -10)

                local FallDuration = math.random(20, 40) / 10
                local SwayX = math.random(-18, 18)
                local GoalPosition = UDim2.new(0, SpawnX + SwayX, 0, Height + 10)

                local FallTween = TweenService:Create(Image,
                    TweenInfo.new(FallDuration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
                        Position = GoalPosition,
                        ImageTransparency = 1
                    })

                FallTween:Play()
                Library:Connect(FallTween.Completed, function()
                    if Image and Image.Parent then
                        Image:Destroy()
                    end
                end)

                task.wait(0.1)
            end
        end)
    end

    Library.SetBackgroundEffectsVisible = function(Self, Bool, Instant)
        local Effects = Library.BackgroundEffects
        if not Effects then
            return
        end

        local HasAnyEffect = Library.BackgroundBlurEnabled or Library.BackgroundSnowEnabled
        local IsVisible = Bool and true or false
        Effects.IsSnowing = IsVisible and Library.BackgroundSnowEnabled

        local TargetTransparency = (IsVisible and HasAnyEffect) and 0.5 or 1
        local TargetBlur = (IsVisible and Library.BackgroundBlurEnabled) and 20 or 0

        if IsVisible and HasAnyEffect then
            Effects.Background.Visible = true
        end

        if Instant then
            Effects.Background.BackgroundTransparency = TargetTransparency
            Effects.BlurEffect.Size = TargetBlur
        else
            local FadeTween = TweenService:Create(Effects.Background,
                TweenInfo.new(0.33, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                    BackgroundTransparency = TargetTransparency
                })

            local BlurTween = TweenService:Create(Effects.BlurEffect,
                TweenInfo.new(0.33, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                    Size = TargetBlur
                })

            FadeTween:Play()
            BlurTween:Play()
        end

        if (not IsVisible) or (not HasAnyEffect) then
            task.delay(0.35, function()
                if not Library or not Library.BackgroundEffects then
                    return
                end

                local CurrentEffects = Library.BackgroundEffects
                if CurrentEffects.IsSnowing then
                    return
                end

                CurrentEffects.Background.Visible = false

                for _, Child in CurrentEffects.SnowHolder:GetChildren() do
                    if Child:IsA("ImageLabel") then
                        Child:Destroy()
                    end
                end
            end)
        end
    end

    Library.SetBackgroundBlurEnabled = function(Self, Bool)
        Library.BackgroundBlurEnabled = Bool and true or false
        Library:SetBackgroundEffectsVisible(Library.WindowOpenState, true)
    end

    Library.SetBackgroundSnowEnabled = function(Self, Bool)
        Library.BackgroundSnowEnabled = Bool and true or false
        Library:SetBackgroundEffectsVisible(Library.WindowOpenState, true)
    end

    Library.Round = function(Self, Number, Float)
        -- Decimals=0 is truthy in Lua; treat it as omitted to avoid 1/0 = NaN.
        local Multiplier = 1 / ((Float and Float ~= 0) and Float or 1)
        return math.floor(Number * Multiplier) / Multiplier
    end

    Library.RegisterLayout = function(Self, Id, Data)
        if type(Id) ~= "string" or Id == "" or type(Data) ~= "table" or not Data.Instance then
            return
        end

        Library.LayoutRegistry[Id] = Data
        return Data
    end

    Library.GetLayoutConfig = function(Self)
        local Layout = {}

        for Id, Data in Library.LayoutRegistry do
            local Instance = Data and Data.Instance
            if not Instance or not Instance.Parent then
                continue
            end

            local Entry = {}
            local Position = Instance.Position

            if Data.SavePosition ~= false then
                Entry.Position = {
                    X = math.floor((tonumber(Position.X.Offset) or 0) + 0.5),
                    Y = math.floor((tonumber(Position.Y.Offset) or 0) + 0.5)
                }
            end

            if Data.SaveSize == true then
                local Size = Instance.Size
                Entry.Size = {
                    X = math.floor((tonumber(Size.X.Offset) or 0) + 0.5),
                    Y = math.floor((tonumber(Size.Y.Offset) or 0) + 0.5)
                }
            end

            if next(Entry) ~= nil then
                Layout[Id] = Entry
            end
        end

        return Layout
    end

    Library.ApplyLayoutConfig = function(Self, Layout)
        if type(Layout) ~= "table" then
            return
        end

        for Id, State in Layout do
            local Data = Library.LayoutRegistry[Id]
            local Instance = Data and Data.Instance
            if not Instance or not Instance.Parent or type(State) ~= "table" then
                continue
            end

            local ParentSize = Instance.Parent.AbsoluteSize
            local MinimumSize = Data.MinimumSize or Vector2.new(0, 0)
            local MaximumSize = Data.MaximumSize

            if Data.SaveSize == true and type(State.Size) == "table" then
                local MaxWidth = math.max(ParentSize.X, MinimumSize.X)
                local MaxHeight = math.max(ParentSize.Y, MinimumSize.Y)

                if typeof(MaximumSize) == "Vector2" then
                    MaxWidth = math.min(MaxWidth, MaximumSize.X)
                    MaxHeight = math.min(MaxHeight, MaximumSize.Y)
                end

                local Width = math.clamp(
                    tonumber(State.Size.X) or Instance.AbsoluteSize.X,
                    math.min(MinimumSize.X, MaxWidth),
                    MaxWidth
                )
                local Height = math.clamp(
                    tonumber(State.Size.Y) or Instance.AbsoluteSize.Y,
                    math.min(MinimumSize.Y, MaxHeight),
                    MaxHeight
                )

                Instance.Size = UDim2.fromOffset(
                    math.floor(Width + 0.5),
                    math.floor(Height + 0.5)
                )
            end

            if Data.SavePosition ~= false and type(State.Position) == "table" then
                local CurrentSize = Instance.AbsoluteSize
                local Width = CurrentSize.X > 0 and CurrentSize.X or (tonumber(Instance.Size.X.Offset) or 0)
                local Height = CurrentSize.Y > 0 and CurrentSize.Y or (tonumber(Instance.Size.Y.Offset) or 0)
                local X = tonumber(State.Position.X) or Instance.Position.X.Offset
                local Y = tonumber(State.Position.Y) or Instance.Position.Y.Offset

                Instance.AnchorPoint = Vector2.new(0, 0)
                Instance.Position = UDim2.fromOffset(
                    math.clamp(math.floor(X + 0.5), 0, math.max(ParentSize.X - Width, 0)),
                    math.clamp(math.floor(Y + 0.5), 0, math.max(ParentSize.Y - Height, 0))
                )
            end
        end
    end

    Library.GetConfig = function(Self)
        local Config = {}

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Library.Flags do
                if type(Value) == "table" and Value.Key then
                    Config[Index] = { Key = tostring(Value.Key), Mode = Value.Mode, Toggled = Value.Toggled }
                elseif type(Value) == "table" and Value.Color then
                    Config[Index] = { Color = "#" .. Value.HexValue, Alpha = Value.Alpha }
                else
                    Config[Index] = Value
                end
            end
        end)

        if not Success then
            warn("Failed to get config:\n" .. Result)
            return
        end

        return HttpService:JSONEncode({
            Flags = Config,
            Layout = Library:GetLayoutConfig()
        })
    end

    Library.LoadConfig = function(Self, Config)
        local Decoded = HttpService:JSONDecode(Config)
        local FlagData = type(Decoded) == "table" and Decoded.Flags or Decoded
        local LayoutData = type(Decoded) == "table" and Decoded.Layout

        local Success, Result = Library:SafeCall(function()
            for Index, Value in FlagData do
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

            for Index, Value in FlagData do
                if type(Value) ~= "table" or not Value.Key then
                    continue
                end

                local SetFunction = Library.SetFlags[Index]
                if not SetFunction then
                    continue
                end

                SetFunction(Value)
            end
        end)

        if Success and type(LayoutData) == "table" then
            task.defer(function()
                task.wait()
                Library:ApplyLayoutConfig(LayoutData)
            end)
        end

        return Success, Result
    end

    Library.GetConfigsList = function(Self, Element)
        local List = {}
        local ReturnList = {}

        List = listfiles(Library.Directory .. Library.Folders.Configs)

        for Index = 1, #List do
            local File = List[Index]

            if File:sub(-5) == ".json" then
                local Position = File:find(".json", 1, true)
                local StartPosition = Position

                local Character = File:sub(Position, Position)
                while Character ~= "/" and Character ~= "\\" and Character ~= "" do
                    Position = Position - 1
                    Character = File:sub(Position, Position)
                end

                if Character == "/" or Character == "\\" then
                    table.insert(ReturnList, File:sub(Position + 1, StartPosition - 1))
                end
            end
        end

        Element:Refresh(ReturnList)
    end

    Library.AddToTheme = function(Self, Properties)
        local Object = Self.Instance

        local ThemeData = {
            Item = Object,
            Properties = Properties,
        }

        for Property, Value in ThemeData.Properties do
            if type(Value) == "string" then
                if not Library.Theme[Value] then
                    Object[Property] = Value
                end

                Object[Property] = Library.Theme[Value]
            else
                Object[Property] = Value()
            end
        end

        table.insert(Library.ThemingStuff, ThemeData)
        Library.ThemeMap[Object] = ThemeData
        return Self
    end

    Library.ChangeItemTheme = function(Self, Properties)
        local Object = Self.Instance

        if not Library.ThemingStuff[Object] then
            return
        end

        Library.ThemingStuff[Object].Properties = Properties
        Library.ThemingStuff[Object] = Library.ThemeMap[Object]
    end

    Library.ChangeTheme = function(Self, Theme, Color)
        Library.Theme[Theme] = Color

        for _, Item in Library.ThemingStuff do
            for Property, Value in Item.Properties do
                if type(Value) == "string" and Value == Theme then
                    Item.Item[Property] = Color
                elseif type(Value) == "function" then
                    Item.Item[Property] = Value()
                end
            end
        end
    end

    Library.OnHover = function(Self, OnHoverEnter, OnHoverLeave)
        local Object = Self.Instance

        if not Object then
            return
        end

        Library:Connect(Object.MouseEnter, OnHoverEnter)
        Library:Connect(Object.MouseLeave, OnHoverLeave)
    end

    Library.GlobalUpdateOpenFrames = function(Self)
        local StaleEntries = {}

        for Key, Item in Library.OpenFrames do
            if not Item then
                table.insert(StaleEntries, Key)
                continue
            end

            local IsOpen = Item.IsOpen
            local AttachedButton = Item.AttachedButton
            local Frame = Item.Frame

            local CanUpdateNow = Item.CanUpdateNow

            if not IsOpen then
                table.insert(StaleEntries, Key)
                continue
            end

            if not CanUpdateNow then
                continue
            end

            if not AttachedButton or not AttachedButton.Parent or not Frame or not Frame.Parent then
                table.insert(StaleEntries, Key)
                continue
            end

            if CanUpdateNow and IsOpen then
                local ParentSize = Frame.Parent.AbsoluteSize
                local FrameSize = Frame.AbsoluteSize
                local X = AttachedButton.AbsolutePosition.X
                local Y = AttachedButton.AbsolutePosition.Y + AttachedButton.AbsoluteSize.Y + 10 + GuiInset

                if ParentSize.X > 0 and FrameSize.X > 0 then
                    X = math.clamp(X, 0, math.max(ParentSize.X - FrameSize.X, 0))
                end

                if ParentSize.Y > 0 and FrameSize.Y > 0 then
                    Y = math.clamp(Y, 0, math.max(ParentSize.Y - FrameSize.Y, 0))
                end

                Frame.Position = UDim2.fromOffset(X, Y)
            end
        end

        for _, Key in StaleEntries do
            Library.OpenFrames[Key] = nil
        end
    end

    Library.Holder = Library:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        IgnoreGuiInset = true,
        ResetOnSpawn = false
    })

    Library.InputBlocker = Library:Create("TextButton", {
        Parent = Library.Holder.Instance,
        Name = "\0",
        Visible = false,
        Modal = true,
        AutoButtonColor = false,
        Active = true,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 0
    })

    Library.MouseCursor = Library:Create("ImageLabel", {
        Parent = Library.Holder.Instance,
        Name = "\0",
        Visible = false,
        BackgroundTransparency = 1,
        Image = "http://www.roblox.com/asset/?id=5545698398",
        Size = UDim2.new(0, 36, 0, 36),
        ZIndex = 10000
    })

    Library.UnusedHolder = Library:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        Enabled = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        ResetOnSpawn = false
    })

    Library:SetupBackgroundEffects()
    Library:SetBackgroundEffectsVisible(false, true)

    Library.NotifHolder = Library:Create("Frame", {
        Name = "\0",
        Parent = Library.Holder.Instance,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 10 + GuiInset),
        Size = UDim2.new(0, 0, 1, 0),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X
    })

    Library:Create("UIListLayout", {
        Name = "\0",
        Parent = Library.NotifHolder.Instance,
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        Padding = UDim.new(0, 6)
    })

    Library:Create("UIPadding", {
        Name = "\0",
        Parent = Library.NotifHolder.Instance,
        PaddingTop = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 8)
    })

    Library:Connect(RunService.RenderStepped, function()
        local MouseCursor = Library.MouseCursor
        if not (MouseCursor and MouseCursor.Instance and Library.WindowOpenState) then
            return
        end

        local MouseLocation = UserInputService:GetMouseLocation()
        MouseCursor.Instance.Position = UDim2.new(0, MouseLocation.X - 18, 0, MouseLocation.Y - 18)
    end)

    do
        Library.CreateColorpicker = function(Self, Data)
            local Colorpicker = {
                Hue = 0,
                Saturation = 0,
                Value = 0,

                Alpha = 0,

                Color = Color3.fromRGB(255, 255, 255),
                HexValue = "#FFFFFF",

                Flag = Data.Flag,
                IsOpen = false,

                Items = {}
            }

            local Items = {}
            do
                Items["ColorpickerButton"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Data.Parent.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2.new(0, 22, 0, 12),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(158, 255, 252)
                })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["ColorpickerButton"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"]
                }):AddToTheme({ Color = 'Border' })

                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["ColorpickerButton"].Instance,
                    Rotation = -90,
                    Color = ColorSequence.new {
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(172, 172, 172))
                    }
                })

                Items["ColorpickerWindow"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Library.UnusedHolder.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 1056, 0, 203),
                    Size = UDim2.new(0, 230, 0, 205),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({ BackgroundColor3 = 'Background' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["ColorpickerWindow"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = 'Outline' })

                Items["AccentLiner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["ColorpickerWindow"].Instance,
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({ BackgroundColor3 = 'Accent' })

                Items["Shadow"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["ColorpickerWindow"].Instance,
                    ImageColor3 = Color3.fromRGB(103, 164, 255),
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = 0.699999988079071,
                    Size = UDim2.new(1, 25, 1, 25),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Image = "http://www.roblox.com/asset/?id=18245826428",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    ZIndex = -1,
                    BorderSizePixel = 0,
                    SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79))
                })

                Items["Palette"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["ColorpickerWindow"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 10, 0, 12),
                    Size = UDim2.new(1, -46, 1, -48),
                    BorderSizePixel = 0,
                })

                Items["Saturation"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Palette"].Instance,
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0
                })

                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Saturation"].Instance,
                    Transparency = NumberSequence.new {
                        NumberSequenceKeypoint.new(0, 1),
                        NumberSequenceKeypoint.new(1, 0)
                    }
                })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Palette"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"]
                }):AddToTheme({ Color = 'Border' })

                Items["Value"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Palette"].Instance,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                })

                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Value"].Instance,
                    Rotation = 90,
                    Transparency = NumberSequence.new {
                        NumberSequenceKeypoint.new(0, 1),
                        NumberSequenceKeypoint.new(1, 0)
                    }
                })

                Items["PaletteDragger"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Palette"].Instance,
                    Size = UDim2.new(0, 1, 0, 1),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0
                })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["PaletteDragger"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"]
                }):AddToTheme({ Color = 'Border' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["ColorpickerWindow"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = 'Border' })

                Items["Hue"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["ColorpickerWindow"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Position = UDim2.new(1, -10, 0, 12),
                    Size = UDim2.new(0, 15, 1, -20),
                    BorderSizePixel = 0
                })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Hue"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"]
                }):AddToTheme({ Color = 'Border' })

                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Hue"].Instance,
                    Rotation = 90,
                    Color = ColorSequence.new {
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                        ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                        ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                    }
                })

                Items["HueDragger"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Hue"].Instance,
                    Size = UDim2.new(1, 0, 0, 1),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0
                })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["HueDragger"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"]
                }):AddToTheme({ Color = 'Border' })

                Items["Alpha"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = Items["ColorpickerWindow"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 10, 1, -10),
                    Size = UDim2.new(1, -46, 0, 15),
                    BorderSizePixel = 0
                })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Alpha"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"]
                }):AddToTheme({ Color = 'Border' })

                Items["AlphaColor"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Alpha"].Instance,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(158, 255, 252)
                })

                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["AlphaColor"].Instance,
                    Transparency = NumberSequence.new {
                        NumberSequenceKeypoint.new(0, 1),
                        NumberSequenceKeypoint.new(1, 0)
                    }
                })

                Items["AlphaDragger"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Alpha"].Instance,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Size = UDim2.new(0, 1, 1, 0),
                    BorderSizePixel = 0
                })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["AlphaDragger"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"]
                }):AddToTheme({ Color = 'Border' })

                Items["CopyPasteWindow"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Library.UnusedHolder.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 1056, 0, 203),
                    Size = UDim2.new(0, 96, 0, 44),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"],
                    Visible = false
                }):AddToTheme({ BackgroundColor3 = "Background" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["CopyPasteWindow"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = "Outline" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["CopyPasteWindow"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = "Border" })

                Items["CopyButton"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["CopyPasteWindow"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = "Copy",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 4, 0, 4),
                    Size = UDim2.new(1, -8, 0, 16),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({
                    BackgroundColor3 = "Element",
                    TextColor3 = "Text"
                })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["CopyButton"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = "Border" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["CopyButton"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = "Outline" })

                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["CopyButton"].Instance,
                    Rotation = -90,
                    Color = ColorSequence.new {
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(172, 172, 172))
                    }
                })

                Items["PasteButton"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["CopyPasteWindow"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = "Paste",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 4, 0, 24),
                    Size = UDim2.new(1, -8, 0, 16),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({
                    BackgroundColor3 = "Element",
                    TextColor3 = "Text"
                })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["PasteButton"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = "Border" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["PasteButton"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = "Outline" })

                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["PasteButton"].Instance,
                    Rotation = -90,
                    Color = ColorSequence.new {
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(172, 172, 172))
                    }
                })

                Colorpicker.Items = Items
            end

            function Colorpicker:SetVisibility(Bool)
                Items["ColorpickerButton"].Instance.Visible = Bool
            end

            function Colorpicker:Update(IsFromAlpha)
                local Hue, Saturation, Value = Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value
                Colorpicker.Color = Color3.fromHSV(Hue, Saturation, Value)
                Colorpicker.HexValue = Colorpicker.Color:ToHex()

                Items["ColorpickerButton"]:Tween({ BackgroundColor3 = Colorpicker.Color })
                Items["Palette"]:Tween({ BackgroundColor3 = Color3.fromHSV(Hue, 1, 1) })

                Flags[Colorpicker.Flag] = {
                    Alpha = Colorpicker.Alpha,
                    Color = Colorpicker.Color,
                    HexValue = Colorpicker.HexValue,
                    Transparency = 1 - Colorpicker.Alpha
                }

                if not IsFromAlpha then
                    Items["AlphaColor"]:Tween({ BackgroundColor3 = Colorpicker.Color })
                end

                if Data.Callback then
                    Library:SafeCall(Data.Callback, Colorpicker.Color, Colorpicker.Alpha)
                end
            end

            local Debounce = false
            local RenderStepped
            local ColorpickerWindow = Items["ColorpickerWindow"].Instance
            local ColorpickerButton = Items["ColorpickerButton"].Instance
            local CopyPasteDebounce = false
            local CopyPasteWindow = Items["CopyPasteWindow"].Instance
            local CopyToClipboard = setclipboard or toclipboard

            Colorpicker.AttachedButton = ColorpickerButton
            Colorpicker.CanUpdateNow = false
            Colorpicker.Frame = ColorpickerWindow

            local function ResolveAttachedFramePosition(Frame)
                local Parent = Frame and Frame.Parent
                local ParentSize = Parent and Parent.AbsoluteSize or Vector2.new(0, 0)
                local FrameSize = Frame and Frame.AbsoluteSize or Vector2.new(0, 0)
                local X = ColorpickerButton.AbsolutePosition.X
                local Y = ColorpickerButton.AbsolutePosition.Y + ColorpickerButton.AbsoluteSize.Y + 10 + GuiInset

                if ParentSize.X > 0 and FrameSize.X > 0 then
                    X = math.clamp(X, 0, math.max(ParentSize.X - FrameSize.X, 0))
                end

                if ParentSize.Y > 0 and FrameSize.Y > 0 then
                    Y = math.clamp(Y, 0, math.max(ParentSize.Y - FrameSize.Y, 0))
                end

                return UDim2.fromOffset(X, Y)
            end

            local CopyPasteMenu = {
                IsOpen = false,
                AttachedButton = ColorpickerButton,
                CanUpdateNow = false,
                Frame = CopyPasteWindow
            }

            function CopyPasteMenu:SetOpen(Bool)
                if CopyPasteDebounce then
                    return
                end

                CopyPasteMenu.IsOpen = Bool and true or false
                CopyPasteDebounce = true

                if CopyPasteMenu.IsOpen then
                    if Colorpicker.IsOpen then
                        Colorpicker:SetOpen(false)
                    end

                    CopyPasteWindow.Parent = Library.Holder.Instance
                    CopyPasteWindow.Position = ResolveAttachedFramePosition(CopyPasteWindow)
                    CopyPasteWindow.Visible = true

                    Items["CopyPasteWindow"]:Tween({
                        Position = ResolveAttachedFramePosition(CopyPasteWindow)
                    })

                    Items["CopyPasteWindow"]:FadeDescendants(true, function()
                        CopyPasteMenu.CanUpdateNow = true
                        CopyPasteDebounce = false
                    end)

                    for _, Value in Library.OpenFrames do
                        if not Data.Section.IsSettings and Value ~= CopyPasteMenu then
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[CopyPasteMenu] = CopyPasteMenu
                else
                    Items["CopyPasteWindow"]:Tween({
                        Position = ResolveAttachedFramePosition(CopyPasteWindow)
                    })

                    Items["CopyPasteWindow"]:FadeDescendants(false, function()
                        CopyPasteWindow.Parent = Library.UnusedHolder.Instance
                        CopyPasteMenu.CanUpdateNow = false
                        CopyPasteDebounce = false
                    end)

                    if Library.OpenFrames[CopyPasteMenu] then
                        Library.OpenFrames[CopyPasteMenu] = nil
                    end
                end

                local Descendants = CopyPasteWindow:GetDescendants()
                table.insert(Descendants, CopyPasteWindow)

                for _, Value in Descendants do
                    if Value.ClassName:find("UI") then
                        continue
                    end

                    Value.ZIndex = CopyPasteMenu.IsOpen and 4 or 1
                end
            end

            function Colorpicker:SetOpen(Bool)
                if Debounce then
                    return
                end

                Colorpicker.IsOpen = Bool

                Debounce = true

                if Colorpicker.IsOpen then
                    ColorpickerWindow.Parent = Library.Holder.Instance
                    ColorpickerWindow.Position = ResolveAttachedFramePosition(ColorpickerWindow)
                    ColorpickerWindow.Visible = true
                    Items["ColorpickerWindow"]:Tween({
                        Position = ResolveAttachedFramePosition(ColorpickerWindow)
                    })

                    Items["ColorpickerWindow"]:FadeDescendants(true, function()
                        Colorpicker.CanUpdateNow = true
                        Debounce = false
                    end)

                    for Index, Value in Library.OpenFrames do
                        if not Data.Section.IsSettings then
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Colorpicker] = Colorpicker
                else
                    Items["ColorpickerWindow"]:Tween({
                        Position = ResolveAttachedFramePosition(ColorpickerWindow)
                    })
                    Items["ColorpickerWindow"]:FadeDescendants(false, function()
                        ColorpickerWindow.Parent = Library.UnusedHolder.Instance
                        Colorpicker.CanUpdateNow = false
                        Debounce = false
                    end)

                    if Library.OpenFrames[Colorpicker] then
                        Library.OpenFrames[Colorpicker] = nil
                    end

                    if RenderStepped then
                        RenderStepped:Disconnect()
                        RenderStepped = nil
                    end
                end

                local Descendants = ColorpickerWindow:GetDescendants()
                table.insert(Descendants, ColorpickerWindow)

                for Index, Value in Descendants do
                    if Value.ClassName:find("UI") then
                        continue
                    end

                    Value.ZIndex = Colorpicker.IsOpen and 4 or 1
                end

                Items["PaletteDragger"].Instance.ZIndex = 5
                Items["HueDragger"].Instance.ZIndex = 5
                Items["AlphaDragger"].Instance.ZIndex = 5
                Items["Shadow"].Instance.ZIndex = 3
            end

            local SlidingPalette = false
            local PaletteChanged

            function Colorpicker:SlidePalette(Input)
                if not Input or not SlidingPalette then
                    return
                end

                local ValueX = math.clamp(
                    1 -
                    (Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) /
                    Items["Palette"].Instance.AbsoluteSize.X, 0, 1)
                local ValueY = math.clamp(
                    1 -
                    (Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) /
                    Items["Palette"].Instance.AbsoluteSize.Y, 0, 1)

                Colorpicker.Saturation = ValueX
                Colorpicker.Value = ValueY

                local SlideX = math.clamp(
                    (Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) /
                    Items["Palette"].Instance.AbsoluteSize.X, 0, 1)
                local SlideY = math.clamp(
                    (Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) /
                    Items["Palette"].Instance.AbsoluteSize.Y, 0, 1)

                Items["PaletteDragger"]:Tween({ Position = UDim2.new(SlideX, 0, SlideY, 0) },
                    TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Colorpicker:Update()
            end

            local SlidingHue = false
            local HueChanged

            function Colorpicker:SlideHue(Input)
                if not Input or not SlidingHue then
                    return
                end

                local ValueY = math.clamp(
                    (Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y,
                    0,
                    1)

                Colorpicker.Hue = ValueY

                local SlideY = math.clamp(
                    (Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y,
                    0,
                    1)

                Items["HueDragger"]:Tween({ Position = UDim2.new(0, 0, SlideY, 0) },
                    TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Colorpicker:Update()
            end

            local SlidingAlpha = false
            local AlphaChanged

            function Colorpicker:SlideAlpha(Input)
                if not Input or not SlidingAlpha then
                    return
                end

                local ValueX = math.clamp(
                    (Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) /
                    Items["Alpha"].Instance.AbsoluteSize.X,
                    0, 1)

                Colorpicker.Alpha = ValueX

                local SlideX = math.clamp(
                    (Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) /
                    Items["Alpha"].Instance.AbsoluteSize.X,
                    0, 1)

                Items["AlphaDragger"]:Tween({ Position = UDim2.new(SlideX, 0, 0, 0) },
                    TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Colorpicker:Update(true)
            end

            function Colorpicker:Set(Color, Alpha)
                if type(Color) == "table" then
                    Color = Color3.fromRGB(Color[1], Color[2], Color[3])
                elseif type(Color) == "string" then
                    Color = Color3.fromHex(Color)
                else
                    Color = Color -- lul
                end

                Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value = Color:ToHSV()
                Colorpicker.Alpha = Alpha or 0

                local PaletteValueX = math.clamp(1 - Colorpicker.Saturation, 0, 1)
                local PaletteValueY = math.clamp(1 - Colorpicker.Value, 0, 1)

                local AlphaPositionX = math.clamp(Colorpicker.Alpha, 0, 1)

                local HuePositionY = math.clamp(Colorpicker.Hue, 0, 1)

                Items["PaletteDragger"]:Tween({ Position = UDim2.new(PaletteValueX, 0, PaletteValueY, 0) },
                    TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Items["HueDragger"]:Tween({ Position = UDim2.new(0, 0, HuePositionY, 0) },
                    TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Items["AlphaDragger"]:Tween({ Position = UDim2.new(AlphaPositionX, 0, 0, 0) },
                    TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Colorpicker:Update()
            end

            Items["ColorpickerButton"]:Connect("MouseButton1Down", function()
                if CopyPasteMenu.IsOpen then
                    CopyPasteMenu:SetOpen(false)
                end

                Colorpicker:SetOpen(not Colorpicker.IsOpen)
            end)

            Items["ColorpickerButton"]:Connect("MouseButton2Down", function()
                CopyPasteMenu:SetOpen(not CopyPasteMenu.IsOpen)
            end)

            Items["CopyButton"]:Connect("MouseButton1Down", function()
                Library.CopiedColor = Colorpicker.Color

                if CopyToClipboard then
                    pcall(CopyToClipboard, "#" .. Colorpicker.HexValue)
                end

                CopyPasteMenu:SetOpen(false)
            end)

            Items["PasteButton"]:Connect("MouseButton1Down", function()
                if Library.CopiedColor then
                    Colorpicker:Set(Library.CopiedColor, Colorpicker.Alpha)
                end

                CopyPasteMenu:SetOpen(false)
            end)

            Items["Palette"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    SlidingPalette = true

                    Colorpicker:SlidePalette(Input)

                    if PaletteChanged then
                        return
                    end

                    PaletteChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            SlidingPalette = false

                            PaletteChanged:Disconnect()
                            PaletteChanged = nil
                        end
                    end)
                end
            end)

            Items["Hue"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    SlidingHue = true

                    Colorpicker:SlideHue(Input)

                    if HueChanged then
                        return
                    end

                    HueChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            SlidingHue = false

                            HueChanged:Disconnect()
                            HueChanged = nil
                        end
                    end)
                end
            end)

            Items["Alpha"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    SlidingAlpha = true

                    Colorpicker:SlideAlpha(Input)

                    if AlphaChanged then
                        return
                    end

                    AlphaChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            SlidingAlpha = false

                            AlphaChanged:Disconnect()
                            AlphaChanged = nil
                        end
                    end)
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if SlidingPalette then
                        Colorpicker:SlidePalette(Input)
                    end

                    if SlidingHue then
                        Colorpicker:SlideHue(Input)
                    end

                    if SlidingAlpha then
                        Colorpicker:SlideAlpha(Input)
                    end
                end
            end)

            Library:Connect(UserInputService.InputBegan, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    if not Colorpicker.IsOpen then
                        if CopyPasteMenu.IsOpen and not Items["CopyPasteWindow"]:IsMouseOverFrame() then
                            CopyPasteMenu:SetOpen(false)
                        end

                        return
                    end

                    if Items["ColorpickerWindow"]:IsMouseOverFrame() then
                        return
                    end

                    Colorpicker:SetOpen(false)
                end
            end)

            if Data.Default then
                Colorpicker:Set(Data.Default, Data.Alpha)
            end

            SetFlags[Colorpicker.Flag] = function(Value, Alpha)
                Colorpicker:Set(Value, Alpha)
            end

            return Colorpicker, Items
        end

        Library.CreateKeybind = function(Self, Data)
            local Keybind = {
                Flag = Data.Flag,
                IsOpen = false,

                Key = "",
                Mode = "",
                Value = "",

                Toggled = false,
                Picking = false,

                Items = {}
            }

            local Items = {}
            do
                Items["KeyButton"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Data.Parent.Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = "[...]",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({ TextColor3 = 'Text' })

                Items["KeybindWindow"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Library.UnusedHolder.Instance,
                    Visible = false,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0.7021276354789734, 0, 0.4859813153743744, 0),
                    Size = UDim2.new(0, 200, 0, 82),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({ BackgroundColor3 = 'Background' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["KeybindWindow"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = 'Border' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["KeybindWindow"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = 'Outline' })

                Items["AccentLiner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["KeybindWindow"].Instance,
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({ BackgroundColor3 = 'Accent' })

                Keybind.Items = Items
            end

            local KeybindObject

            if Library.KeyList then
                KeybindObject = Library.KeyList:Add("", "", "")
            end

            local Update = function()
                if KeybindObject then
                    KeybindObject:SetStatus(Keybind.Toggled)
                    KeybindObject:Set(Keybind.Value, Data.Name, Keybind.Mode)
                end
            end

            local Debounce = false
            local RenderStepped
            local KeybindWindow = Items["KeybindWindow"].Instance
            local KeyButton = Items["KeyButton"].Instance

            Keybind.AttachedButton = KeyButton
            Keybind.CanUpdateNow = false
            Keybind.Frame = KeybindWindow

            local ModeDropdown = Library:Dropdown({
                Name = "Mode",
                Flag = Data.Flag .. "Mode",
                Parent = Items["KeybindWindow"],
                Items = { "Toggle", "Hold", "Always" },
                Default = "Toggle",
                Callback = function(Value)
                    Keybind.Mode = Value
                    if Value == "Always" then
                        Keybind.Toggled = true
                    end

                    Flags[Keybind.Flag] = {
                        Mode = Keybind.Mode,
                        Key = Keybind.Key,
                        Toggled = Keybind.Toggled
                    }

                    if Data.Callback then
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end

                    Update()
                end
            })

            local ShowInKeybindsList = Library:Toggle({
                Name = "Show in keybinds list",
                Flag = Data.Flag .. "ShowInKeybindsList",
                Parent = Items["KeybindWindow"],
                Default = true,
                Callback = function(Value)
                    if KeybindObject then
                        KeybindObject:SetVis(Value)
                        Update()
                    end
                end
            })

            ShowInKeybindsList.Items.Toggle.Instance.Position = UDim2.new(0, 8, 1, -8)
            ShowInKeybindsList.Items.Toggle.Instance.Size = UDim2.new(1, -16, 0, 12)
            ShowInKeybindsList.Items.Toggle.Instance.AnchorPoint = Vector2.new(0, 1)
            ShowInKeybindsList.Items.Indicator.Instance.Position = UDim2.new(0, 0, 0.5, 0)
            ShowInKeybindsList.Items.Text.Instance.Position = UDim2.new(0, 15, 0.5, -1)

            ModeDropdown.Items.Dropdown.Instance.Position = UDim2.new(0, 8, 0, 8)
            ModeDropdown.Items.Dropdown.Instance.Size = UDim2.new(1, -16, 0, 40)

            function Keybind:SetOpen(Bool)
                if Debounce then
                    return
                end

                Keybind.IsOpen = Bool

                Debounce = true

                if Keybind.IsOpen then
                    KeybindWindow.Position = UDim2.new(0, KeyButton.AbsolutePosition.X, 0,
                        KeyButton.AbsolutePosition.Y + KeyButton.AbsoluteSize.Y + GuiInset)

                    KeybindWindow.Parent = Library.Holder.Instance
                    KeybindWindow.Visible = true
                    Items["KeybindWindow"]:Tween({
                        Position = UDim2.new(0, KeyButton.AbsolutePosition.X, 0,
                            KeyButton.AbsolutePosition.Y + KeyButton.AbsoluteSize.Y + 10 + GuiInset)
                    })

                    Items["KeybindWindow"]:FadeDescendants(true, function()
                        Debounce = false
                        Keybind.CanUpdateNow = true
                    end)

                    for Index, Value in Library.OpenFrames do
                        if not Data.Section.IsSettings then
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Keybind] = Keybind
                else
                    Items["KeybindWindow"]:Tween({
                        Position = UDim2.new(0, KeyButton.AbsolutePosition.X, 0,
                            KeyButton.AbsolutePosition.Y + KeyButton.AbsoluteSize.Y - 10 + GuiInset)
                    })
                    Items["KeybindWindow"]:FadeDescendants(false, function()
                        Items["KeybindWindow"].Instance.Parent = Library.UnusedHolder.Instance
                        Debounce = false
                        Keybind.CanUpdateNow = false
                    end)

                    if Library.OpenFrames[Keybind] then
                        Library.OpenFrames[Keybind] = nil
                    end

                    if RenderStepped then
                        RenderStepped:Disconnect()
                        RenderStepped = nil
                    end
                end

                local Descendants = KeybindWindow:GetDescendants()
                table.insert(Descendants, KeybindWindow)

                for Index, Value in Descendants do
                    if Value.ClassName:find("UI") then
                        continue
                    end

                    Value.ZIndex = Keybind.IsOpen and 4 or 1
                end
            end

            function Keybind:SetMode(Mode)
                ModeDropdown:Set(Mode)
                if Mode == "Always" then
                    Keybind.Toggled = true
                end

                Flags[Keybind.Flag] = {
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

                Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled
                }

                if Data.Callback then
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end

                Update()
            end

            function Keybind:Set(Key)
                if string.find(tostring(Key), "Enum") then
                    Keybind.Key = tostring(Key)

                    Key = Key.Name == "Backspace" and "None" or Key.Name

                    local KeyString = Keys[Keybind.Key] or string.gsub(Key, "Enum.", "") or "None"
                    local TextToDisplay = string.gsub(string.gsub(KeyString, "KeyCode.", ""), "UserInputType.", "") or
                        "None"

                    Keybind.Value = TextToDisplay
                    Items["KeyButton"].Instance.Text = "[" .. TextToDisplay .. "]"

                    Flags[Keybind.Flag] = {
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

                    local KeyString = Keys[Keybind.Key] or string.gsub(tostring(RealKey), "Enum.", "") or RealKey
                    local TextToDisplay = KeyString and
                        string.gsub(string.gsub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"

                    TextToDisplay = string.gsub(string.gsub(KeyString, "KeyCode.", ""), "UserInputType.", "")

                    Keybind.Value = TextToDisplay
                    Items["KeyButton"].Instance.Text = "[" .. TextToDisplay .. "]"
                    if Keybind.Mode == "Always" then
                        Keybind.Toggled = true
                    elseif type(Key.Toggled) == "boolean" then
                        Keybind.Toggled = Key.Toggled
                    end

                    Flags[Keybind.Flag] = {
                        Mode = Keybind.Mode,
                        Key = Keybind.Key,
                        Toggled = Keybind.Toggled
                    }

                    if Data.Callback then
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end

                    Update()
                elseif table.find({ "Toggle", "Hold", "Always" }, Key) then
                    Keybind.Mode = Key
                    Keybind:SetMode(Key)

                    if Data.Callback then
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end

                    Update()
                end

                Keybind.Picking = false
            end

            Items["KeyButton"]:Connect("MouseButton1Click", function()
                if Keybind.Disabled then
                    return
                end

                Keybind.Picking = true

                Items["KeyButton"].Instance.Text = "press a key"

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

            Library:Connect(UserInputService.InputBegan, function(Input, GPE)
                if Keybind.Value == "None" then
                    return
                end

                if not GPE then
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
                end

                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    if not Keybind.IsOpen then
                        return
                    end

                    if Items["KeybindWindow"]:IsMouseOverFrame() or ModeDropdown.Items.OptionHolder:IsMouseOverFrame() then
                        return
                    end

                    Keybind:SetOpen(false)
                end
            end)

            Library:Connect(UserInputService.InputEnded, function(Input, GPE)
                if GPE then
                    return
                end

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

            Items["KeyButton"]:Connect("MouseButton2Down", function()
                Keybind:SetOpen(not Keybind.IsOpen)
            end)

            if Data.Default then
                Keybind:Set({
                    Mode = Data.Mode or "Toggle",
                    Key = Data.Default,
                })
            end

            SetFlags[Keybind.Flag] = function(Value)
                Keybind:Set(Value)
            end

            return Keybind, Items
        end

        Library.Watermark = function(Self, Params)
            local Watermark = {}
            local PrefixText = tostring((Params and Params.Name) or "niggahack")
            local WatermarkTick = tick()
            local WatermarkFps = 0
            local WatermarkDisplayedFps = 0
            local WatermarkStatsText = ""
            local DynamicTextProvider = nil
            local DynamicText = PrefixText
            local DynamicTextTick = 0
            local WatermarkLastShimmerTime = tick()
            local WatermarkShimmerPhase = 0

            local Items = {}
            do
                Items["Watermark"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    AnchorPoint = Vector2.new(0.5, 0),
                    Position = UDim2.new(0.5, 0, 0, 42),
                    Size = UDim2.new(0, 0, 0, 25),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({ BackgroundColor3 = 'Background' })

                Items["Watermark"]:MakeDraggable()

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = 'Outline' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = 'Border' })

                Items["DarkLiner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    Position = UDim2.new(0, -8, 0, 1),
                    Size = UDim2.new(1, 16, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Light Border"]
                }):AddToTheme({ BackgroundColor3 = 'Light Border' })

                Items["AccentLiner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    Position = UDim2.new(0, -8, 0, 0),
                    Size = UDim2.new(1, 16, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({ BackgroundColor3 = 'Accent' })

                Items["AccentGradient"] = Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["AccentLiner"].Instance,
                    Offset = Vector2.new(0, 0),
                    Transparency = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 0),
                        NumberSequenceKeypoint.new(0.5, 1),
                        NumberSequenceKeypoint.new(1, 0),
                    })
                })

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Watermark"].Instance,
                    RichText = true,
                    TextColor3 = Library.Theme["Text"],
                    Text = PrefixText,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Size = UDim2.new(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({ TextColor3 = 'Text' })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    PaddingRight = UDim.new(0, 8),
                    PaddingLeft = UDim.new(0, 8)
                })
            end

            function Watermark:SetVisibility(Bool)
                Items["Watermark"].Instance.Visible = Bool
            end

            function Watermark:Center()
                local AbsPos = Items["Watermark"].Instance.AbsolutePosition
                Items["Watermark"].Instance.AnchorPoint = Vector2.new(0, 0)
                task.wait()
                Items["Watermark"].Instance.Position = UDim2.new(0, AbsPos.X, 0, AbsPos.Y + GuiInset)
            end

            function Watermark:SetText(Text)
                DynamicTextProvider = nil
                PrefixText = tostring(Text or "")
                DynamicText = PrefixText
                Items["Text"].Instance.Text = PrefixText
            end

            function Watermark:SetDynamicTextProvider(Callback)
                DynamicTextProvider = type(Callback) == "function" and Callback or nil
                DynamicTextTick = 0
                DynamicText = PrefixText
            end

            function Watermark:SetName(Text)
                self:SetText(Text)
            end

            function Watermark:GetBounds()
                local Instance = Items["Watermark"].Instance
                return Instance.AbsolutePosition, Instance.AbsoluteSize
            end

            Library:RegisterLayout("Watermark", {
                Instance = Items["Watermark"].Instance
            })

            Library:Connect(RunService.RenderStepped, function()
                if not Items["Watermark"].Instance.Visible then
                    return
                end

                local CurrentTick = tick()
                WatermarkFps += 1

                if CurrentTick - WatermarkLastShimmerTime >= (1 / 30) then
                    WatermarkShimmerPhase = (WatermarkShimmerPhase + (CurrentTick - WatermarkLastShimmerTime) * (1 / 1.2)) %
                        1
                    WatermarkLastShimmerTime = CurrentTick
                    if DynamicTextProvider and (CurrentTick - DynamicTextTick) >= 0.25 then
                        DynamicTextTick = CurrentTick
                        DynamicText = tostring(DynamicTextProvider(WatermarkDisplayedFps) or "")
                    end
                    local PlainText = DynamicTextProvider and DynamicText or (PrefixText .. WatermarkStatsText)
                    local ShineWidth = 6
                    local ShinePos = WatermarkShimmerPhase * (#PlainText + ShineWidth)
                    local Rich = {}
                    for Index = 1, #PlainText do
                        local Distance = math.abs(Index - ShinePos)
                        local Alpha = math.clamp(1 - (Distance / ShineWidth), 0, 1)
                        local Color = Library.Theme["Text"]:Lerp(Library.Theme["Accent"], Alpha)
                        Rich[#Rich + 1] = string.format(
                            '<font color="rgb(%d,%d,%d)">%s</font>',
                            math.floor(Color.R * 255),
                            math.floor(Color.G * 255),
                            math.floor(Color.B * 255),
                            PlainText:sub(Index, Index)
                        )
                    end

                    Items["AccentGradient"].Instance.Offset = Vector2.new((WatermarkShimmerPhase * 2) - 1, 0)
                    Items["Text"].Instance.Text = table.concat(Rich)
                end

                if CurrentTick - WatermarkTick >= 1 then
                    WatermarkTick = CurrentTick
                    WatermarkDisplayedFps = WatermarkFps
                    if not DynamicTextProvider then
                        WatermarkStatsText = string.format(
                            ' / %s / %sfps',
                            os.date("%a %b %d %X %Y"),
                            WatermarkDisplayedFps
                        )
                    else
                        WatermarkStatsText = ""
                    end
                    WatermarkFps = 0
                end
            end)

            Watermark:Center()

            return Watermark
        end

        Library.KeybindList = function(Self, Params)
            local KeybindList = {}
            Library.KeyList = KeybindList

            local Items = {}
            do
                Items["KeybindList"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 10, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({ BackgroundColor3 = 'Background' })

                Items["KeybindList"]:MakeDraggable()

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["KeybindList"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = 'Outline' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["KeybindList"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = 'Border' })

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["KeybindList"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Params.Name,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({ TextColor3 = 'Text' })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["KeybindList"].Instance,
                    PaddingTop = UDim.new(0, 4),
                    PaddingBottom = UDim.new(0, 4),
                    PaddingRight = UDim.new(0, 8),
                    PaddingLeft = UDim.new(0, 8)
                })

                Items["AccentLiner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["KeybindList"].Instance,
                    Position = UDim2.new(0, -2, 0, 20),
                    Size = UDim2.new(1, 4, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({ BackgroundColor3 = 'Accent' })

                Items["Content"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["KeybindList"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 25),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    Padding = UDim.new(0, 2),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["KeybindList"].Instance,
                    PaddingTop = UDim.new(0, 4),
                    PaddingBottom = UDim.new(0, 4),
                    PaddingRight = UDim.new(0, 8),
                    PaddingLeft = UDim.new(0, 8)
                })
            end

            function KeybindList:SetVisibility(Bool)
                Items["KeybindList"].Instance.Visible = Bool
            end

            function KeybindList:Center()
                local AbsPos = Items["KeybindList"].Instance.AbsolutePosition
                Items["KeybindList"].Instance.AnchorPoint = Vector2.new(0, 0)
                task.wait()
                Items["KeybindList"].Instance.Position = UDim2.new(0, AbsPos.X, 0, AbsPos.Y + GuiInset)
            end

            function KeybindList:SetText(Text)
                Items["KeybindList"].Instance.Text = Text
            end

            function KeybindList:Add(Key, Name, Mode)
                local CanShowInKeybindsList = true

                local NewKey = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Content"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Key .. " - " .. Name .. " - " .. Mode,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({ TextColor3 = 'Text' })

                function NewKey:Set(Key, Name, Mode)
                    NewKey.Instance.Text = Key .. " - " .. Name .. " - " .. Mode
                end

                function NewKey:SetStatus(Bool)
                    if not CanShowInKeybindsList then
                        Bool = false
                    end

                    NewKey.Instance.Visible = Bool
                end

                function NewKey:SetVis(Bool)
                    CanShowInKeybindsList = Bool
                end

                return NewKey
            end

            KeybindList.Items = Items

            Library:RegisterLayout("KeybindList", {
                Instance = Items["KeybindList"].Instance
            })

            return KeybindList
        end

        Library.Notification = function(Self, Name, Duration, Color)
            local Items = {}
            do
                Items["Notification"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.NotifHolder.Instance,
                    Size = UDim2.new(0, 0, 0, 20),
                    Position = UDim2.new(0, 471, 0, 678),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme["Section"]
                }):AddToTheme({ BackgroundColor3 = 'Section' })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Notification"].Instance,
                    PaddingRight = UDim.new(0, 8),
                    PaddingLeft = UDim.new(0, 8)
                })

                Items["Stroke"] = Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Notification"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = 'Border' })

                Items["Stroke1"] = Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Notification"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = 'Outline' })

                Items["AccentLiner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Notification"].Instance,
                    Position = UDim2.new(0, -8, 0, 0),
                    Size = UDim2.new(0, 1, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color
                })

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Notification"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Name,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Size = UDim2.new(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 2, 0.5, -1),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({ TextColor3 = 'Text' })
            end

            for Index, Value in Items do
                if Value.Instance:IsA("Frame") then
                    Value.Instance.BackgroundTransparency = 1
                elseif Value.Instance:IsA("TextLabel") then
                    Value.Instance.TextTransparency = 1
                elseif Value.Instance:IsA("UIStroke") then
                    Value.Instance.Transparency = 1
                end
            end

            local GetSize = function()
                local AbsSize = Items["Notification"].Instance.AbsoluteSize
                Items["Notification"].Instance.AutomaticSize = Enum.AutomaticSize.None
                task.wait()
                Items["Notification"].Instance.Size = UDim2.new(0, AbsSize.X, 0, AbsSize.Y)
                return AbsSize
            end

            local Size = GetSize()
            task.wait()
            Items["Notification"].Instance.Size = UDim2.new(0, 0, 0, Size.Y)

            local Info = TweenInfo.new(0.85, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false, 0)

            Library:Thread(function()
                for Index, Value in Items do
                    if Value.Instance:IsA("Frame") then
                        Value:Tween({ BackgroundTransparency = 0 }, Info)
                    elseif Value.Instance:IsA("TextLabel") then
                        Value:Tween({ TextTransparency = 0 }, Info)
                    elseif Value.Instance:IsA("UIStroke") then
                        Value:Tween({ Transparency = 0 }, Info)
                    end
                end

                Items["Notification"]:Tween({ Size = UDim2.new(0, Size.X, 0, Size.Y) }, Info)

                task.delay(Duration + 0.1, function()
                    for Index, Value in Items do
                        if Value.Instance:IsA("Frame") then
                            Value:Tween({ BackgroundTransparency = 1 })
                        elseif Value.Instance:IsA("TextLabel") then
                            Value:Tween({ TextTransparency = 1 })
                        elseif Value.Instance:IsA("UIStroke") then
                            Value:Tween({ Transparency = 1 })
                        end
                    end

                    Items["Notification"]:Tween({ Size = UDim2.new(0, 0, 0, Size.Y) }, Info)
                    task.wait(0.5)
                    Items["Notification"].Instance:Destroy()
                end)
            end)
        end

        Library.ConsoleLogger = function(Self, Params)
            local Logger = {}
            local CommandCallback = Params.Callback or Params.callback or function() end

            local AlignLoggerToWindow = function(Frame)
                local MainWindow = Library.MainWindowFrame

                if not MainWindow then
                    return
                end

                local MainPos = MainWindow.Position
                local MainSize = MainWindow.AbsoluteSize

                -- Match main window width, keep logger shorter, and place it clearly below the main window.
                Frame.Size = UDim2.new(0, MainSize.X, 0, 220)
                Frame.Position = UDim2.new(0, MainPos.X.Offset, 0, MainPos.Y.Offset + MainSize.Y + 10)
            end

            local Items = {}
            do
                Items["CallLogger"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    Visible = true,
                    Position = UDim2.new(0, 860, 0, 132),
                    Size = UDim2.new(0, 474, 0, 262),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({ BackgroundColor3 = 'Background' })

                Items["CallLogger"]:MakeDraggable()

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["CallLogger"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = 'Border' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["CallLogger"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = 'Outline' })

                Items["AccentLiner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["CallLogger"].Instance,
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({ BackgroundColor3 = 'Accent' })

                Items["DarkLiner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["CallLogger"].Instance,
                    Position = UDim2.new(0, 0, 0, 1),
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Light Border"]
                }):AddToTheme({ BackgroundColor3 = 'Light Border' })

                Items["Title"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["CallLogger"].Instance,
                    TextColor3 = Library.Theme["Accent"],
                    Text = Params.Name,
                    Size = UDim2.new(0, 0, 0, 15),
                    Position = UDim2.new(0, 10, 0, 6),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({ TextColor3 = 'Accent' })

                Items["Background"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["CallLogger"].Instance,
                    Position = UDim2.new(0, 10, 0, 30),
                    Size = UDim2.new(1, -20, 1, -82),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Section"]
                }):AddToTheme({ BackgroundColor3 = 'Section' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = 'Outline' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = 'Border' })

                Items["Holder"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    ScrollBarImageColor3 = Library.Theme["Accent"],
                    MidImage = "rbxassetid://129030709932941",
                    ScrollBarThickness = 1,
                    Size = UDim2.new(1, -16, 1, -8),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 8, 0, 4),
                    BottomImage = "rbxassetid://129030709932941",
                    TopImage = "rbxassetid://129030709932941"
                }):AddToTheme({ ScrollBarImageColor3 = 'Accent' })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Holder"].Instance,
                    PaddingRight = UDim.new(0, 8)
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Holder"].Instance,
                    Padding = UDim.new(0, 0),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["InputBackground"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["CallLogger"].Instance,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 10, 1, -10),
                    Size = UDim2.new(1, -20, 0, 18),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({ BackgroundColor3 = 'Element' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["InputBackground"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = 'Border' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["InputBackground"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = 'Outline' })

                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["InputBackground"].Instance,
                    Rotation = -90,
                    Color = ColorSequence.new {
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(172, 172, 172))
                    }
                })

                Items["Input"] = Library:Create("TextBox", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["InputBackground"].Instance,
                    PlaceholderColor3 = Library.Theme["Inactive Text"],
                    PlaceholderText = "type command and press enter",
                    TextColor3 = Library.Theme["Text"],
                    Text = "",
                    Size = UDim2.new(1, -12, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 6, 0.5, -7),
                    ClearTextOnFocus = false,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    CursorPosition = -1
                }):AddToTheme({ TextColor3 = 'Text' })
            end

            AlignLoggerToWindow(Items["CallLogger"].Instance)

            local IsVisible = true
            local ApplyVisibility = function(IsWindowOpen)
                Items["CallLogger"].Instance.Visible = IsVisible and IsWindowOpen
            end

            Library:BindToWindowVisibility(ApplyVisibility)

            function Logger:SetVisibility(Bool)
                IsVisible = Bool
                ApplyVisibility(Library.WindowOpenState)
            end

            function Logger:Center()
                local AbsPos = Items["CallLogger"].Instance.AbsolutePosition
                Items["CallLogger"].Instance.AnchorPoint = Vector2.new(0, 0)
                task.wait()
                Items["CallLogger"].Instance.Position = UDim2.new(0, AbsPos.X, 0, AbsPos.Y + GuiInset)
            end

            function Logger:SetText(Text)
                Items["Title"].Instance.Text = Text
            end

            function Logger:SetCommandCallback(Callback)
                CommandCallback = Callback or function() end
            end

            function Logger:AddError(Text)
                return Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Holder"].Instance,
                    TextColor3 = Color3.fromRGB(255, 41, 45),
                    Text = Text,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1, 0, 0, 15),
                    BorderSizePixel = 0
                })
            end

            function Logger:AddWarning(Text)
                return Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Holder"].Instance,
                    TextColor3 = Color3.fromRGB(255, 222, 32),
                    Text = Text,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1, 0, 0, 15),
                    BorderSizePixel = 0
                })
            end

            function Logger:AddOutput(Text)
                return Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Holder"].Instance,
                    TextColor3 = Color3.fromRGB(255, 222, 32),
                    Text = Text,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1, 0, 0, 15),
                    BorderSizePixel = 0
                }):AddToTheme({ TextColor3 = 'Text' })
            end

            function Logger:Clear()
                Items["InputBackground"]:ChangeItemTheme({ BackgroundColor3 = "Accent" })
                Items["InputBackground"]:Tween({ BackgroundColor3 = Library.Theme.Accent })
                task.wait(0.1)
                Items["InputBackground"]:ChangeItemTheme({ BackgroundColor3 = "Element" })
                Items["InputBackground"]:Tween({ BackgroundColor3 = Library.Theme.Element })

                for Index, Value in Items["Holder"].Instance:GetChildren() do
                    if Value:IsA("TextLabel") then
                        Value:Destroy()
                    end
                end
            end

            Items["Input"]:Connect("FocusLost", function(PressedEnter)
                if not PressedEnter then
                    return
                end

                local Text = Items["Input"].Instance.Text
                Items["Input"].Instance.Text = ""

                if Text == "" then
                    return
                end

                Library:SafeCall(CommandCallback, Text, Logger)
            end)

            Library:RegisterLayout("CallLogger", {
                Instance = Items["CallLogger"].Instance
            })

            return Logger
        end

        Library.ChargeShotWidget = function(Self, Params)
            local Widget = {
                Visible = false,
                Minimum = 1,
                Maximum = 30,
            }

            local Items = {}
            do
                Items["ChargeShotWidget"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    Visible = false,
                    Position = UDim2.new(0.4242021143436432, 40, 0.7932242751121521, 82),
                    Size = UDim2.new(0, 176, 0, 44),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({ BackgroundColor3 = "Background" })

                Items["ChargeShotWidget"]:MakeDraggable()

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["ChargeShotWidget"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = "Outline" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["ChargeShotWidget"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = "Border" })

                Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["ChargeShotWidget"].Instance,
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({ BackgroundColor3 = "Accent" })

                Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["ChargeShotWidget"].Instance,
                    Position = UDim2.new(0, 0, 0, 1),
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Light Border"]
                }):AddToTheme({ BackgroundColor3 = "Light Border" })

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["ChargeShotWidget"].Instance,
                    TextColor3 = Library.Theme["Accent"],
                    Text = Params and Params.Name or "Charge Shot",
                    Size = UDim2.new(0, 0, 0, 15),
                    Position = UDim2.new(0, 9, 0, 6),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({ TextColor3 = "Accent" })

                Items["Value"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["ChargeShotWidget"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = "x1",
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, -9, 0, 6),
                    Size = UDim2.new(0, 32, 0, 15),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    BorderSizePixel = 0
                }):AddToTheme({ TextColor3 = "Text" })

                Items["Bar"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["ChargeShotWidget"].Instance,
                    Position = UDim2.new(0, 10, 0, 26),
                    Size = UDim2.new(0, 154, 0, 8),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Section"]
                }):AddToTheme({ BackgroundColor3 = "Section" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Bar"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = "Outline" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Bar"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = "Border" })

                Items["Fill"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Bar"].Instance,
                    Size = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 45, 45)
                })
            end

            local function UpdateValueText(Value)
                Items["Value"].Instance.Text = ("x%d"):format(math.floor(Value + 0.5))
            end

            function Widget:SetVisibility(Bool)
                Widget.Visible = Bool and true or false
                Items["ChargeShotWidget"].Instance.Visible = Widget.Visible
            end

            function Widget:Center()
                local AbsPos = Items["ChargeShotWidget"].Instance.AbsolutePosition
                Items["ChargeShotWidget"].Instance.AnchorPoint = Vector2.new(0, 0)
                task.wait()
                Items["ChargeShotWidget"].Instance.Position = UDim2.new(0, AbsPos.X, 0, AbsPos.Y + GuiInset)
            end

            function Widget:SetText(Text)
                Items["Text"].Instance.Text = Text
            end

            function Widget:SetPosition(Position)
                Items["ChargeShotWidget"].Instance.AnchorPoint = Vector2.new(0, 0)
                Items["ChargeShotWidget"].Instance.Position = Position
            end

            function Widget:SetRange(Minimum, Maximum)
                Widget.Minimum = tonumber(Minimum) or 1
                Widget.Maximum = math.max(tonumber(Maximum) or 30, Widget.Minimum)
                return Widget
            end

            function Widget:SetValue(Value)
                local Min = Widget.Minimum
                local Max = Widget.Maximum
                local SafeValue = math.clamp(tonumber(Value) or Min, Min, Max)
                local Alpha = Max > Min and ((SafeValue - Min) / (Max - Min)) or 1

                Items["Fill"].Instance.Size = UDim2.new(Alpha, 0, 1, 0)
                UpdateValueText(SafeValue)
            end

            function Widget:SetAlpha(Alpha)
                local SafeAlpha = math.clamp(tonumber(Alpha) or 0, 0, 1)
                local Min = Widget.Minimum
                local Max = Widget.Maximum
                local Value = Min + ((Max - Min) * SafeAlpha)

                Items["Fill"].Instance.Size = UDim2.new(SafeAlpha, 0, 1, 0)
                UpdateValueText(Value)
            end

            function Widget:SetFillColor(Color)
                if typeof(Color) == "Color3" then
                    Items["Fill"].Instance.BackgroundColor3 = Color
                end
            end

            Widget.Items = Items

            Library:RegisterLayout("ChargeShotWidget", {
                Instance = Items["ChargeShotWidget"].Instance
            })

            Widget:Center()
            Widget:SetValue(Widget.Minimum)

            return Widget
        end

        Library.StatListWidget = function(Self, Params)
            local Widget = {
                Visible = true,
                MinimumSize = Vector2.new(208, 102),
            }

            local Items = {}
            do
                Items["StatListWidget"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    Visible = true,
                    Position = UDim2.new(0, 860, 0, 916),
                    Size = UDim2.fromOffset(Widget.MinimumSize.X, Widget.MinimumSize.Y),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({ BackgroundColor3 = "Background" })

                Items["StatListWidget"]:MakeDraggable()

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["StatListWidget"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = "Outline" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["StatListWidget"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = "Border" })

                Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["StatListWidget"].Instance,
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({ BackgroundColor3 = "Accent" })

                Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["StatListWidget"].Instance,
                    Position = UDim2.new(0, 0, 0, 1),
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Light Border"]
                }):AddToTheme({ BackgroundColor3 = "Light Border" })

                Items["Title"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["StatListWidget"].Instance,
                    TextColor3 = Library.Theme["Accent"],
                    Text = Params and Params.Name or "Stats",
                    Position = UDim2.new(0, 9, 0, 6),
                    Size = UDim2.new(1, -18, 0, 15),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0
                }):AddToTheme({ TextColor3 = "Accent" })

                Items["Content"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["StatListWidget"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = "",
                    Position = UDim2.new(0, 9, 0, 24),
                    Size = UDim2.new(1, -18, 1, -30),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Top,
                    TextWrapped = false,
                    BorderSizePixel = 0
                }):AddToTheme({ TextColor3 = "Text" })
            end

            local function ApplyVisibility()
                Items["StatListWidget"].Instance.Visible = Widget.Visible
            end

            Library:BindToWindowVisibility(ApplyVisibility)

            function Widget:SetVisibility(Bool)
                Widget.Visible = Bool and true or false
                ApplyVisibility()
            end

            function Widget:Center()
                local AbsPos = Items["StatListWidget"].Instance.AbsolutePosition
                Items["StatListWidget"].Instance.AnchorPoint = Vector2.new(0, 0)
                task.wait()
                Items["StatListWidget"].Instance.Position = UDim2.new(0, AbsPos.X, 0, AbsPos.Y + GuiInset)
            end

            function Widget:SetText(Text)
                Items["Title"].Instance.Text = tostring(Text or "")
            end

            function Widget:SetPosition(Position)
                Items["StatListWidget"].Instance.AnchorPoint = Vector2.new(0, 0)
                Items["StatListWidget"].Instance.Position = Position
            end

            function Widget:SetLines(Lines)
                if type(Lines) == "table" then
                    Items["Content"].Instance.Text = table.concat(Lines, "\n")
                else
                    Items["Content"].Instance.Text = tostring(Lines or "")
                end
            end

            function Widget:GetBounds()
                local Instance = Items["StatListWidget"].Instance
                return Instance.AbsolutePosition, Instance.AbsoluteSize
            end

            Widget.Items = Items

            Library:RegisterLayout("StatListWidget", {
                Instance = Items["StatListWidget"].Instance
            })

            Widget:Center()
            Widget:SetLines({})

            return Widget
        end

        Library.InventoryViewer = function(Self, Params)
            local Viewer = {
                Visible = true,
                Entries = {},
                Sections = {},
                Columns = 4,
                MinimumSize = Vector2.new(336, 140),
                MaximumWidth = 420,
                MaximumHeight = 460,
                CellSize = Vector2.new(62, 70),
                CellPadding = 4,
                HeaderHeight = 48,
                ScrollBarThickness = 2,
                MinimumVisibleRows = 1,
                SectionSpacing = 4,
                SectionHeaderHeight = 14,
            }

            local Items = {}
            do
                Items["InventoryViewer"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    Visible = true,
                    Position = UDim2.new(0, 860, 0, 776),
                    Size = UDim2.new(0, Viewer.MinimumSize.X, 0, Viewer.MinimumSize.Y),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({ BackgroundColor3 = "Background" })

                Items["InventoryViewer"]:MakeDraggable()
                Items["InventoryViewer"]:MakeResizeable(Viewer.MinimumSize)

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["InventoryViewer"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = "Outline" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["InventoryViewer"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = "Border" })

                Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["InventoryViewer"].Instance,
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({ BackgroundColor3 = "Accent" })

                Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["InventoryViewer"].Instance,
                    Position = UDim2.new(0, 0, 0, 1),
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Light Border"]
                }):AddToTheme({ BackgroundColor3 = "Light Border" })

                Items["Title"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["InventoryViewer"].Instance,
                    TextColor3 = Library.Theme["Accent"],
                    Text = Params and Params.Name or "Inventory Viewer",
                    Position = UDim2.new(0, 9, 0, 6),
                    Size = UDim2.new(1, -18, 0, 15),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0
                }):AddToTheme({ TextColor3 = "Accent" })

                Items["Summary"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["InventoryViewer"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = "0 items, $0",
                    Position = UDim2.new(0, 9, 0, 20),
                    Size = UDim2.new(1, -18, 0, 14),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0
                }):AddToTheme({ TextColor3 = "Text" })

                Items["Target"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["InventoryViewer"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = "No target selected",
                    Position = UDim2.new(0, 9, 0, 22),
                    Size = UDim2.new(1, -18, 0, 14),
                    BackgroundTransparency = 1,
                    TextTransparency = 0.35,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0
                }):AddToTheme({ TextColor3 = "Text" })

                Items["Background"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["InventoryViewer"].Instance,
                    Position = UDim2.new(0, 9, 0, Viewer.HeaderHeight),
                    Size = UDim2.new(1, -18, 1, -(Viewer.HeaderHeight + 9)),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Section"]
                }):AddToTheme({ BackgroundColor3 = "Section" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = "Outline" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = "Border" })

                Items["Holder"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.None,
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    ScrollBarImageColor3 = Library.Theme["Accent"],
                    ScrollBarThickness = Viewer.ScrollBarThickness,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 8, 0, 6),
                    Size = UDim2.new(1, -18, 1, -12),
                    ScrollingDirection = Enum.ScrollingDirection.Y
                }):AddToTheme({ ScrollBarImageColor3 = "Accent" })

                Items["Content"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Holder"].Instance,
                    AnchorPoint = Vector2.new(0.5, 0),
                    Position = UDim2.new(0.5, 0, 0, 0),
                    Size = UDim2.fromOffset(0, 0),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0
                })

                Items["ContentList"] = Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    Padding = UDim.new(0, Viewer.SectionSpacing),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
            end

            local function ApplyVisibility()
                Items["InventoryViewer"].Instance.Visible = Viewer.Visible
            end

            local function RecalculateLayout()
                local Holder = Items["Holder"].Instance
                local Columns = math.max(math.floor(Viewer.Columns or 4), 1)
                local CellWidth = Viewer.CellSize.X
                local CellHeight = Viewer.CellSize.Y
                local Padding = Viewer.CellPadding
                local Frame = Items["InventoryViewer"].Instance
                local UsedWidth = (Columns * CellWidth) + (math.max(Columns - 1, 0) * Padding)
                local SectionWidth = UsedWidth + 12
                local ContentHeight = 0
                local VisibleSectionCount = 0

                for _, Section in ipairs(Viewer.Sections) do
                    local EntryCount = #(Section.Entries or {})
                    local Rows = EntryCount > 0 and math.max(math.ceil(EntryCount / Columns), 1) or 0
                    local GridHeight = Rows > 0 and ((Rows * CellHeight) + (math.max(Rows - 1, 0) * Padding)) or 0
                    local SectionHeight = Viewer.SectionHeaderHeight + 4

                    if Section.EmptyLabel and Section.EmptyLabel.Instance then
                        Section.EmptyLabel.Instance.Visible = EntryCount == 0
                    end
                    if Section.Content and Section.Content.Instance then
                        Section.Content.Instance.Visible = EntryCount > 0
                        Section.Content.Instance.Size = UDim2.fromOffset(UsedWidth, GridHeight)
                    end
                    if Section.Grid and Section.Grid.Instance then
                        Section.Grid.Instance.FillDirectionMaxCells = Columns
                    end
                    if Section.Title and Section.Title.Instance then
                        if EntryCount > 0 then
                            Section.Title.Instance.Text = ("%s (%d)"):format(Section.Name or "Section", EntryCount)
                        else
                            Section.Title.Instance.Text = tostring(Section.Name or "Section")
                        end
                    end

                    if EntryCount > 0 then
                        SectionHeight = SectionHeight + GridHeight + 2
                    elseif Section.EmptyLabel and Section.EmptyLabel.Instance then
                        SectionHeight = SectionHeight + 14
                    end

                    if Section.Frame and Section.Frame.Instance then
                        Section.Frame.Instance.Size = UDim2.fromOffset(SectionWidth, SectionHeight)
                    end

                    ContentHeight = ContentHeight + SectionHeight
                    VisibleSectionCount = VisibleSectionCount + 1
                end

                if VisibleSectionCount > 1 then
                    ContentHeight = ContentHeight + ((VisibleSectionCount - 1) * Viewer.SectionSpacing)
                end

                local FramePaddingX = 36
                local FramePaddingY = 21
                local AvailableHeight = math.max(Frame.AbsoluteSize.Y - Viewer.HeaderHeight - FramePaddingY, 0)
                local NeedsScrollbar = ContentHeight > (AvailableHeight + 1)
                local DesiredWidth = math.clamp(
                    SectionWidth + FramePaddingX + (NeedsScrollbar and Viewer.ScrollBarThickness or 0),
                    Viewer.MinimumSize.X,
                    Viewer.MaximumWidth
                )
                local DesiredHeight = math.clamp(ContentHeight + Viewer.HeaderHeight + FramePaddingY,
                    Viewer.MinimumSize.Y,
                    Viewer.MaximumHeight)

                Items["Content"].Instance.Size = UDim2.fromOffset(SectionWidth, ContentHeight)
                Items["Content"].Instance.Position = UDim2.new(0.5, 0, 0, 0)
                Holder.CanvasSize = UDim2.new(0, 0, 0, ContentHeight)
                Holder.ScrollBarThickness = NeedsScrollbar and Viewer.ScrollBarThickness or 0

                if math.abs(Frame.AbsoluteSize.X - DesiredWidth) > 1
                    or math.abs(Frame.AbsoluteSize.Y - DesiredHeight) > 1
                then
                    Items["InventoryViewer"]:Tween(
                        { Size = UDim2.fromOffset(DesiredWidth, DesiredHeight) },
                        TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
                    )
                end
            end

            local function ClearEntries()
                for _, Section in ipairs(Viewer.Sections) do
                    if Section and Section.Frame and Section.Frame.Instance then
                        Section.Frame.Instance:Destroy()
                    end
                end
                table.clear(Viewer.Entries)
                table.clear(Viewer.Sections)
            end

            local function CreateEntry(Section, Data)
                local Entry = {}
                local Amount = tonumber(Data.Amount) or 1
                local AmountText = Amount > 1 and ("x" .. tostring(math.floor(Amount + 0.5))) or ""

                Entry.Frame = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Section.Content.Instance,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({ BackgroundColor3 = "Element" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Entry.Frame.Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = "Outline" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Entry.Frame.Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = "Border" })

                Entry.Image = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Entry.Frame.Instance,
                    Image = Data.Image or "rbxasset://textures/ui/GuiImagePlaceholder.png",
                    AnchorPoint = Vector2.new(0.5, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0, 6),
                    Size = UDim2.new(1, -14, 1, -30),
                    BorderSizePixel = 0
                })

                Entry.Image.Instance.ScaleType = Enum.ScaleType.Fit

                Entry.Name = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = math.max(Library.FontSize - 2, 9),
                    Parent = Entry.Frame.Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = tostring(Data.DisplayName or Data.Name or ""),
                    Position = UDim2.new(0, 4, 1, -22),
                    Size = UDim2.new(1, -8, 0, 12),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    TextTruncate = Enum.TextTruncate.AtEnd
                }):AddToTheme({ TextColor3 = "Text" })

                Entry.Amount = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = math.max(Library.FontSize - 2, 9),
                    Parent = Entry.Frame.Instance,
                    TextColor3 = Library.Theme["Accent"],
                    Text = AmountText,
                    AnchorPoint = Vector2.new(1, 1),
                    Position = UDim2.new(1, -4, 1, -4),
                    Size = UDim2.new(1, -8, 0, 12),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    BorderSizePixel = 0
                }):AddToTheme({ TextColor3 = "Accent" })

                Viewer.Entries[#Viewer.Entries + 1] = Entry
                Section.Entries[#Section.Entries + 1] = Entry
                return Entry
            end

            local function CreateSection(Data)
                local Section = {
                    Name = tostring(Data.Name or "Section"),
                    Entries = {},
                }

                Section.Frame = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.fromOffset(0, 0),
                    BorderSizePixel = 0
                })

                Section.Title = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = 9,
                    Parent = Section.Frame.Instance,
                    TextColor3 = Library.Theme["Accent"],
                    Text = Section.Name,
                    Position = UDim2.new(0, 2, 0, 0),
                    Size = UDim2.new(1, -4, 0, Viewer.SectionHeaderHeight),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0
                }):AddToTheme({ TextColor3 = "Accent" })

                Section.Divider = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Section.Frame.Instance,
                    Position = UDim2.new(0, 0, 0, Viewer.SectionHeaderHeight),
                    Size = UDim2.new(1, 0, 0, 1),
                    BackgroundColor3 = Library.Theme["Light Border"],
                    BorderSizePixel = 0
                }):AddToTheme({ BackgroundColor3 = "Light Border" })

                Section.Content = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Section.Frame.Instance,
                    Position = UDim2.new(0.5, 0, 0, Viewer.SectionHeaderHeight + 4),
                    AnchorPoint = Vector2.new(0.5, 0),
                    Size = UDim2.fromOffset(0, 0),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0
                })

                Section.Grid = Library:Create("UIGridLayout", {
                    Name = "\0",
                    Parent = Section.Content.Instance,
                    CellSize = UDim2.fromOffset(Viewer.CellSize.X, Viewer.CellSize.Y),
                    CellPadding = UDim2.fromOffset(Viewer.CellPadding, Viewer.CellPadding),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Section.EmptyLabel = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = math.max(Library.FontSize - 1, 10),
                    Parent = Section.Frame.Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = "None",
                    Position = UDim2.new(0, 2, 0, Viewer.SectionHeaderHeight + 5),
                    Size = UDim2.new(1, -4, 0, 12),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    Visible = false
                }):AddToTheme({ TextColor3 = "Inactive Text" })

                Viewer.Sections[#Viewer.Sections + 1] = Section
                return Section
            end

            Library:BindToWindowVisibility(ApplyVisibility)

            Items["InventoryViewer"].Instance:GetPropertyChangedSignal("AbsoluteSize"):Connect(RecalculateLayout)
            Items["ContentList"].Instance:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(RecalculateLayout)
            Library:Connect(UserInputService.InputBegan, function(Input, Processed)
                if Processed or not Viewer.Visible then
                    return
                end

                if UserInputService:GetFocusedTextBox() then
                    return
                end

                local Holder = Items["Holder"].Instance
                local MaxScroll = math.max(Holder.CanvasSize.Y.Offset - Holder.AbsoluteWindowSize.Y, 0)
                if MaxScroll <= 0 then
                    return
                end

                local Step = Viewer.CellSize.Y + Viewer.CellPadding
                if Input.KeyCode == Enum.KeyCode.Up then
                    Holder.CanvasPosition = Vector2.new(0, math.max(Holder.CanvasPosition.Y - Step, 0))
                elseif Input.KeyCode == Enum.KeyCode.Down then
                    Holder.CanvasPosition = Vector2.new(0, math.min(Holder.CanvasPosition.Y + Step, MaxScroll))
                end
            end)

            function Viewer:SetVisibility(Bool)
                Viewer.Visible = Bool and true or false
                ApplyVisibility()
            end

            function Viewer:Center()
                local AbsPos = Items["InventoryViewer"].Instance.AbsolutePosition
                Items["InventoryViewer"].Instance.AnchorPoint = Vector2.new(0, 0)
                task.wait()
                Items["InventoryViewer"].Instance.Position = UDim2.new(0, AbsPos.X, 0, AbsPos.Y + GuiInset)
            end

            function Viewer:SetPosition(Position)
                Items["InventoryViewer"].Instance.AnchorPoint = Vector2.new(0, 0)
                Items["InventoryViewer"].Instance.Position = Position
            end

            function Viewer:GetBounds()
                local Instance = Items["InventoryViewer"].Instance
                return Instance.AbsolutePosition, Instance.AbsoluteSize
            end

            function Viewer:SetText(Text)
                Items["Title"].Instance.Text = tostring(Text or "")
            end

            function Viewer:SetSummary(Text)
                local SummaryText = tostring(Text or "")
                local ShowSummary = SummaryText ~= ""

                Items["Summary"].Instance.Visible = ShowSummary
                Items["Summary"].Instance.Text = SummaryText
                Items["Target"].Instance.Position = ShowSummary and UDim2.new(0, 9, 0, 34) or UDim2.new(0, 9, 0, 22)
                Viewer.HeaderHeight = ShowSummary and 60 or 48
                Items["Background"].Instance.Position = UDim2.new(0, 9, 0, Viewer.HeaderHeight)
                Items["Background"].Instance.Size = UDim2.new(1, -18, 1, -(Viewer.HeaderHeight + 9))
                RecalculateLayout()
            end

            function Viewer:SetTarget(Text)
                Items["Target"].Instance.Text = tostring(Text or "")
            end

            function Viewer:Clear()
                ClearEntries()
                RecalculateLayout()
            end

            function Viewer:SetSections(List)
                ClearEntries()

                for _, SectionData in ipairs(List or {}) do
                    local Section = CreateSection(SectionData)
                    for _, Data in ipairs(SectionData.Entries or {}) do
                        CreateEntry(Section, Data)
                    end
                end

                RecalculateLayout()
            end

            function Viewer:SetItems(List)
                Viewer:SetSections({
                    {
                        Name = "Items",
                        Entries = List or {},
                    }
                })
            end

            Viewer.Items = Items

            Library:RegisterLayout("InventoryViewer", {
                Instance = Items["InventoryViewer"].Instance
            })

            Viewer:Center()
            RecalculateLayout()

            return Viewer
        end

        Library.SpotifyPlayer = function(Self)
            local Spotify = {}

            local Request = request
                or http_request
                or (syn and syn.request)
                or (getgenv and getgenv().http and getgenv().http.request)
            local GetCustomAsset = getcustomasset or getsynasset

            local SpotifyFolder = Library.Directory .. "/Spotify"
            local CacheFolder = SpotifyFolder .. "/Cache"
            local TokenPath = Library.Directory .. "/token.txt"
            local PlaceholderImage = "rbxasset://textures/ui/GuiImagePlaceholder.png"
            local PollInterval = 1

            if not isfolder(SpotifyFolder) then
                makefolder(SpotifyFolder)
            end

            if not isfolder(CacheFolder) then
                makefolder(CacheFolder)
            end

            local function ReadToken()
                if not isfile(TokenPath) then
                    writefile(TokenPath, "")
                    return ""
                end

                return (readfile(TokenPath):gsub("^%s*(.-)%s*$", "%1"))
            end

            local function DecodeTokenConfig(RawToken)
                local CleanToken = (RawToken or ""):gsub("^%s*(.-)%s*$", "%1")
                if CleanToken == "" then
                    return {
                        Raw = "",
                        AccessToken = "",
                        RefreshToken = "",
                        ClientId = "",
                        ClientSecret = "",
                        ExpiresAt = 0,
                        LyricsApi = "",
                        LyricsFormat = "raw"
                    }
                end

                if CleanToken:sub(1, 1) ~= "{" then
                    return {
                        Raw = CleanToken,
                        AccessToken = CleanToken,
                        RefreshToken = "",
                        ClientId = "",
                        ClientSecret = "",
                        ExpiresAt = math.huge,
                        LyricsApi = "",
                        LyricsFormat = "raw"
                    }
                end

                local DecodeSuccess, Parsed = pcall(HttpService.JSONDecode, HttpService, CleanToken)
                if not DecodeSuccess or type(Parsed) ~= "table" then
                    return {
                        Raw = CleanToken,
                        AccessToken = "",
                        RefreshToken = "",
                        ClientId = "",
                        ClientSecret = "",
                        ExpiresAt = 0,
                        LyricsApi = "",
                        LyricsFormat = "raw",
                        ParseFailed = true
                    }
                end

                return {
                    Raw = CleanToken,
                    AccessToken = tostring(Parsed.access_token or Parsed.token or ""):gsub("^%s*(.-)%s*$", "%1"),
                    RefreshToken = tostring(Parsed.refresh_token or ""):gsub("^%s*(.-)%s*$", "%1"),
                    ClientId = tostring(Parsed.client_id or ""):gsub("^%s*(.-)%s*$", "%1"),
                    ClientSecret = tostring(Parsed.client_secret or ""):gsub("^%s*(.-)%s*$", "%1"),
                    ExpiresAt = tonumber(Parsed.expires_at) or 0,
                    LyricsApi = tostring(Parsed.lyrics_api or ""):gsub("^%s*(.-)%s*$", "%1"),
                    LyricsFormat = tostring(Parsed.lyrics_format or "raw"):gsub("^%s*(.-)%s*$", "%1")
                }
            end

            local function EncodeTokenConfig(Config)
                if not Config then
                    return ""
                end

                if (Config.RefreshToken or "") == "" then
                    return Config.AccessToken or ""
                end

                local EncodeSuccess, Encoded = pcall(HttpService.JSONEncode, HttpService, {
                    access_token = Config.AccessToken or "",
                    refresh_token = Config.RefreshToken or "",
                    client_id = Config.ClientId or "",
                    client_secret = Config.ClientSecret or "",
                    expires_at = math.floor(tonumber(Config.ExpiresAt) or 0),
                    lyrics_api = Config.LyricsApi or "",
                    lyrics_format = Config.LyricsFormat or "raw"
                })

                return EncodeSuccess and Encoded or ""
            end

            local function WriteToken(ConfigOrToken)
                if type(ConfigOrToken) == "table" then
                    writefile(TokenPath, EncodeTokenConfig(ConfigOrToken))
                    return
                end

                writefile(TokenPath, ConfigOrToken or "")
            end

            local TokenConfig = DecodeTokenConfig(ReadToken())
            local Token = TokenConfig.AccessToken

            local CollapsedSize = UDim2.new(0, 248, 0, 88)
            local ExpandedSize = UDim2.new(0, 540, 0, 250)
            local ResultButtons = {}
            local SearchResults = {}
            local SearchTrackResults = {}
            local SearchAlbumBrowse = nil
            local CurrentTrack
            local IsExpanded = false
            local Seeking = false
            local SearchRequestId = 0
            local SearchDelay = 0.25
            local UpdateQueueCanvas

            local Items = {}
            do
                local function CreateControlButton(Key, Parent, Image, FrameSize, IconSize, IconOffsetY)
                    Items[Key] = Library:Create("TextButton", {
                        Name = "\0",
                        Parent = Parent,
                        Size = UDim2.new(0, FrameSize, 0, 20),
                        BorderSizePixel = 0,
                        AutoButtonColor = false,
                        BackgroundTransparency = 1,
                        Text = ""
                    })

                    Items[Key].Icon = Library:Create("ImageLabel", {
                        Name = "\0",
                        Parent = Items[Key].Instance,
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.new(0.5, 0, 0.5, IconOffsetY or 0),
                        Size = UDim2.new(0, IconSize, 0, IconSize),
                        BorderSizePixel = 0,
                        BackgroundTransparency = 1,
                        Image = Image,
                        ImageColor3 = Library.Theme["Text"]
                    }):AddToTheme({ ImageColor3 = "Text" })
                end

                Items["SpotifyPlayer"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    Position = UDim2.new(0, 30, 0, 240),
                    Size = CollapsedSize,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"],
                    ClipsDescendants = true
                }):AddToTheme({ BackgroundColor3 = "Background" })

                Items["SpotifyPlayer"]:MakeDraggable()

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["SpotifyPlayer"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = "Outline" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["SpotifyPlayer"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = "Border" })

                Items["AccentLiner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["SpotifyPlayer"].Instance,
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({ BackgroundColor3 = "Accent" })

                Items["SearchBackground"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["SpotifyPlayer"].Instance,
                    Position = UDim2.new(0, 10, 0, -40),
                    Size = UDim2.new(0, 250, 0, 24),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({ BackgroundColor3 = "Element" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["SearchBackground"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = "Outline" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["SearchBackground"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = "Border" })

                Items["SearchInput"] = Library:Create("TextBox", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["SearchBackground"].Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    PlaceholderColor3 = Library.Theme["Inactive Text"],
                    PlaceholderText = "Search songs, artists, albums",
                    Size = UDim2.new(1, -12, 0, 15),
                    TextColor3 = Library.Theme["Text"],
                    Text = "",
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 6, 0.5, -1),
                    ClearTextOnFocus = false,
                    BorderSizePixel = 0
                }):AddToTheme({ TextColor3 = "Text" })

                Items["SearchResults"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["SpotifyPlayer"].Instance,
                    Position = UDim2.new(0, 10, 0, -170),
                    Size = UDim2.new(0, 250, 0, 114),
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(),
                    ScrollBarThickness = 0,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Library.Theme["Section"]
                }):AddToTheme({ BackgroundColor3 = "Section" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["SearchResults"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = "Outline" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["SearchResults"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = "Border" })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["SearchResults"].Instance,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 4)
                })

                for Index = 1, 8 do
                    local Row = {}

                    Row.Frame = Library:Create("Frame", {
                        Name = "\0",
                        Parent = Items["SearchResults"].Instance,
                        Size = UDim2.new(1, -8, 0, 36),
                        BorderSizePixel = 0,
                        BackgroundTransparency = 1,
                        BackgroundColor3 = Library.Theme["Element"],
                        Visible = false
                    })

                    Row.Divider = Library:Create("Frame", {
                        Name = "\0",
                        Parent = Row.Frame.Instance,
                        AnchorPoint = Vector2.new(0.5, 1),
                        Position = UDim2.new(0.5, 0, 1, -1),
                        Size = UDim2.new(1, -22, 0, 1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Outline"]
                    }):AddToTheme({ BackgroundColor3 = "Outline" })

                    Row.Cover = Library:Create("ImageLabel", {
                        Name = "\0",
                        Parent = Row.Frame.Instance,
                        Image = PlaceholderImage,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, 30, 0, 30),
                        Position = UDim2.new(0, 3, 0, 3),
                        BorderSizePixel = 0
                    })

                    Row.Title = Library:Create("TextLabel", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize,
                        Parent = Row.Frame.Instance,
                        TextColor3 = Library.Theme["Text"],
                        Text = "",
                        BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.new(0, 40, 0, 2),
                        Size = UDim2.new(1, -44, 0, 15),
                        BorderSizePixel = 0,
                        TextTruncate = Enum.TextTruncate.AtEnd
                    }):AddToTheme({ TextColor3 = "Text" })

                    Row.Album = Library:Create("TextLabel", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize,
                        Parent = Row.Frame.Instance,
                        TextColor3 = Library.Theme["Inactive Text"],
                        Text = "",
                        BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.new(0, 40, 0, 17),
                        Size = UDim2.new(1, -44, 0, 14),
                        BorderSizePixel = 0,
                        TextTruncate = Enum.TextTruncate.AtEnd
                    }):AddToTheme({ TextColor3 = "Inactive Text" })

                    Row.Button = Library:Create("TextButton", {
                        Name = "\0",
                        Parent = Row.Frame.Instance,
                        Size = UDim2.new(1, 0, 1, 0),
                        BorderSizePixel = 0,
                        BackgroundTransparency = 1,
                        Text = ""
                    })

                    ResultButtons[Index] = Row
                end

                Items["LyricsFrame"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["SpotifyPlayer"].Instance,
                    Position = UDim2.new(1, 10, 0, 10),
                    Size = UDim2.new(0, 260, 0, 146),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Section"]
                }):AddToTheme({ BackgroundColor3 = "Section" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["LyricsFrame"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = "Outline" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["LyricsFrame"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = "Border" })

                Items["QueueLabel"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["LyricsFrame"].Instance,
                    TextColor3 = Library.Theme["Accent"],
                    Text = "Queue",
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 8, 0, 6),
                    Size = UDim2.new(1, -16, 0, 14),
                    BorderSizePixel = 0
                }):AddToTheme({ TextColor3 = "Accent" })

                Items["QueueScroll"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["LyricsFrame"].Instance,
                    Position = UDim2.new(0, 8, 0, 24),
                    Size = UDim2.new(1, -16, 1, -32),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    CanvasSize = UDim2.new(),
                    AutomaticCanvasSize = Enum.AutomaticSize.None,
                    ScrollBarThickness = 1,
                    ScrollBarImageColor3 = Library.Theme["Border"],
                    MidImage = "rbxassetid://129030709932941",
                    BottomImage = "rbxassetid://129030709932941",
                    TopImage = "rbxassetid://129030709932941"
                }):AddToTheme({ ScrollBarImageColor3 = "Border" })

                Items["QueueText"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["QueueScroll"].Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = "Nothing is currently playing.",
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Top,
                    Size = UDim2.new(1, -8, 0, 0),
                    BorderSizePixel = 0,
                    TextWrapped = true,
                    RichText = true
                }):AddToTheme({ TextColor3 = "Inactive Text" })

                Library:Connect(Items["QueueScroll"].Instance:GetPropertyChangedSignal("AbsoluteSize"), function()
                    UpdateQueueCanvas()
                end)

                Items["PlayerArea"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["SpotifyPlayer"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 10),
                    Size = UDim2.new(1, -20, 0, 68),
                    BorderSizePixel = 0
                })

                Items["CoverFrame"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["PlayerArea"].Instance,
                    Position = UDim2.new(0, 0, 0, 2),
                    Size = UDim2.new(0, 50, 0, 50),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Section"]
                }):AddToTheme({ BackgroundColor3 = "Section" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["CoverFrame"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = "Outline" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["CoverFrame"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = "Border" })

                Items["Cover"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["CoverFrame"].Instance,
                    Image = PlaceholderImage,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0
                })

                Items["Info"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["PlayerArea"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 60, 0, 2),
                    Size = UDim2.new(1, -176, 0, 38),
                    BorderSizePixel = 0
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Info"].Instance,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 1)
                })

                Items["Title"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Info"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = "Spotify",
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1, 0, 0, 14),
                    BorderSizePixel = 0,
                    TextTruncate = Enum.TextTruncate.AtEnd
                }):AddToTheme({ TextColor3 = "Text" })

                Items["Artist"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Info"].Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = "No track detected",
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1, 0, 0, 13),
                    BorderSizePixel = 0,
                    TextTruncate = Enum.TextTruncate.AtEnd
                }):AddToTheme({ TextColor3 = "Inactive Text" })

                Items["Album"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Info"].Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = "Waiting for Spotify",
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1, 0, 0, 13),
                    BorderSizePixel = 0,
                    TextTruncate = Enum.TextTruncate.AtEnd
                }):AddToTheme({ TextColor3 = "Inactive Text" })

                Items["ProgressFrame"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["SpotifyPlayer"].Instance,
                    Position = UDim2.new(0, 0, 1, -3),
                    Size = UDim2.new(1, 0, 0, 3),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Section"]
                }):AddToTheme({ BackgroundColor3 = "Section" })

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["ProgressFrame"].Instance,
                    CornerRadius = UDim.new(1, 0)
                })

                Items["ProgressFill"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["ProgressFrame"].Instance,
                    Size = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({ BackgroundColor3 = "Accent" })

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["ProgressFill"].Instance,
                    CornerRadius = UDim.new(1, 0)
                })

                Items["ProgressHitbox"] = Library:Create("TextButton", {
                    Name = "\0",
                    Parent = Items["SpotifyPlayer"].Instance,
                    Position = UDim2.new(0, 0, 1, -14),
                    Size = UDim2.new(1, 0, 0, 14),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Text = ""
                })

                Items["Time"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["PlayerArea"].Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = "0:00 / 0:00",
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 60, 0, 40),
                    Size = UDim2.new(0, 90, 0, 15),
                    BorderSizePixel = 0
                }):AddToTheme({ TextColor3 = "Inactive Text" })

                Items["Controls"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["PlayerArea"].Instance,
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -18, 0.5, 12),
                    Size = UDim2.new(0, 96, 0, 24),
                    BorderSizePixel = 0
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Controls"].Instance,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 4)
                })

                CreateControlButton("Shuffle", Items["Controls"].Instance, "rbxassetid://9607545176", 12, 12, 0)
                CreateControlButton("PlayPause", Items["Controls"].Instance, "rbxassetid://9622475855", 20, 20, 0)
                CreateControlButton("Repeat", Items["Controls"].Instance, "rbxassetid://9607545605", 12, 12, 0)

                Items["ExpandButton"] = Library:Create("ImageButton", {
                    Name = "\0",
                    Parent = Items["SpotifyPlayer"].Instance,
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, -8, 0, 8),
                    Size = UDim2.new(0, 14, 0, 14),
                    BorderSizePixel = 0,
                    AutoButtonColor = false,
                    Image = "rbxassetid://9607545497",
                    Rotation = 0,
                    ImageColor3 = Library.Theme["Text"],
                    BackgroundTransparency = 1
                }):AddToTheme({ ImageColor3 = "Text" })
            end

            local function FormatTime(Milliseconds)
                local TotalSeconds = math.max(math.floor((Milliseconds or 0) / 1000), 0)
                local Minutes = math.floor(TotalSeconds / 60)
                local Seconds = TotalSeconds % 60

                return string.format("%d:%02d", Minutes, Seconds)
            end

            local function SetProgress(Current, Total, Instant)
                local SafeTotal = math.max(Total or 0, 1)
                local Alpha = math.clamp((Current or 0) / SafeTotal, 0, 1)
                if Instant then
                    Items["ProgressFill"].Instance.Size = UDim2.new(Alpha, 0, 1, 0)
                else
                    Items["ProgressFill"]:Tween({ Size = UDim2.new(Alpha, 0, 1, 0) })
                end

                Items["Time"].Instance.Text = FormatTime(Current) .. " / " .. FormatTime(Total)
            end

            local function SetControlState(Data)
                local ShuffleEnabled = Data and Data.Shuffle
                local RepeatEnabled = Data and Data.RepeatState and Data.RepeatState ~= "off"

                Items["Shuffle"].Icon.Instance.ImageColor3 = ShuffleEnabled and Library.Theme["Accent"] or
                    Library.Theme["Text"]
                Items["Repeat"].Icon.Instance.ImageColor3 = RepeatEnabled and Library.Theme["Accent"] or
                    Library.Theme["Text"]
                Items["PlayPause"].Icon.Instance.Image = Data and Data.IsPlaying and "rbxassetid://9607545382" or
                    "rbxassetid://9622475855"
            end

            UpdateQueueCanvas = function()
                local QueueLabel = Items["QueueText"].Instance
                local QueueScroll = Items["QueueScroll"].Instance
                local Width = math.max(QueueScroll.AbsoluteSize.X - 8, 1)
                local Height = math.max(QueueLabel.TextBounds.Y + 4, QueueScroll.AbsoluteSize.Y)

                QueueLabel.Size = UDim2.new(0, Width, 0, Height)
                QueueScroll.CanvasSize = UDim2.new(0, 0, 0, Height)
            end

            local function SetQueueDisplay(Current, Tracks, EmptyText)
                if not Current and (type(Tracks) ~= "table" or #Tracks == 0) then
                    Items["QueueText"].Instance.Text = EmptyText or "No upcoming tracks."
                    UpdateQueueCanvas()
                    Items["QueueScroll"].Instance.CanvasPosition = Vector2.new()
                    return
                end

                local Buffer = {}
                if Current then
                    Buffer[#Buffer + 1] = string.format("<font color=\"#%02X%02X%02X\">Now playing</font>\n%s\n%s",
                        math.floor(Library.Theme["Accent"].R * 255),
                        math.floor(Library.Theme["Accent"].G * 255),
                        math.floor(Library.Theme["Accent"].B * 255),
                        Current.Title or "Unknown track",
                        Current.Artist or "Unknown artist")
                end

                if type(Tracks) == "table" and #Tracks > 0 then
                    if #Buffer > 0 then
                        Buffer[#Buffer + 1] = ""
                    end

                    Buffer[#Buffer + 1] = "Next up"
                end

                for Index, Track in Tracks do
                    if Index > 6 then
                        break
                    end

                    Buffer[#Buffer + 1] = string.format("%d. %s\n%s", Index, Track.Title or "Unknown track",
                        Track.Artist or "Unknown artist")
                end

                Items["QueueText"].Instance.Text = table.concat(Buffer, "\n\n")
                UpdateQueueCanvas()
                Items["QueueScroll"].Instance.CanvasPosition = Vector2.new()
            end

            local function SetDisplay(Data, EmptyText)
                if not Data then
                    CurrentTrack = nil
                    Items["Title"].Instance.Text = "Spotify"
                    Items["Artist"].Instance.Text = "No track detected"
                    Items["Album"].Instance.Text = EmptyText or "Nothing is currently playing"
                    Items["Cover"].Instance.Image = PlaceholderImage
                    SetControlState(nil)
                    SetQueueDisplay(nil, nil, "Nothing is currently playing.")
                    SetProgress(0, 0, true)
                    return
                end

                CurrentTrack = Data
                Items["Title"].Instance.Text = Data.Title
                Items["Artist"].Instance.Text = Data.Artist
                Items["Album"].Instance.Text = Data.Album
                Items["Cover"].Instance.Image = Data.Cover or PlaceholderImage
                SetControlState(Data)

                if not Seeking then
                    SetProgress(Data.Progress, Data.Duration, true)
                end
            end

            local function RefreshAccessToken()
                if not Request or TokenConfig.RefreshToken == "" then
                    return false
                end

                if TokenConfig.ClientId == "" or TokenConfig.ClientSecret == "" then
                    return false
                end

                local Body = table.concat({
                    "grant_type=refresh_token",
                    "refresh_token=" .. HttpService:UrlEncode(TokenConfig.RefreshToken),
                    "client_id=" .. HttpService:UrlEncode(TokenConfig.ClientId),
                    "client_secret=" .. HttpService:UrlEncode(TokenConfig.ClientSecret)
                }, "&")

                local Success, Response = pcall(Request, {
                    Url = "https://accounts.spotify.com/api/token",
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/x-www-form-urlencoded"
                    },
                    Body = Body
                })

                if not Success or not Response or Response.StatusCode ~= 200 or not Response.Body or Response.Body == "" then
                    return false
                end

                local DecodeSuccess, Payload = pcall(HttpService.JSONDecode, HttpService, Response.Body)
                if not DecodeSuccess or type(Payload) ~= "table" or not Payload.access_token then
                    return false
                end

                TokenConfig.AccessToken = tostring(Payload.access_token)
                TokenConfig.ExpiresAt = tick() + math.max((tonumber(Payload.expires_in) or 3600) - 30, 0)

                if Payload.refresh_token and Payload.refresh_token ~= "" then
                    TokenConfig.RefreshToken = tostring(Payload.refresh_token)
                end

                Token = TokenConfig.AccessToken
                WriteToken(TokenConfig)
                return true
            end

            local function EnsureAccessToken()
                if TokenConfig.RefreshToken == "" then
                    Token = TokenConfig.AccessToken
                    return Token ~= ""
                end

                if TokenConfig.AccessToken ~= "" and tick() < (TokenConfig.ExpiresAt or 0) then
                    Token = TokenConfig.AccessToken
                    return true
                end

                return RefreshAccessToken()
            end

            local function MakeRequest(Url, Method, RetryOnAuthFailure, Body)
                if not Request or not EnsureAccessToken() or Token == "" then
                    return nil
                end

                local RequestBody = Body
                if type(Body) == "table" then
                    local EncodeSuccess, EncodedBody = pcall(HttpService.JSONEncode, HttpService, Body)
                    if not EncodeSuccess then
                        return nil
                    end

                    RequestBody = EncodedBody
                end

                local Success, Response = pcall(Request, {
                    Url = "https://api.spotify.com/v1/" .. Url,
                    Method = Method or "GET",
                    Headers = {
                        ["Authorization"] = "Bearer " .. Token,
                        ["Content-Type"] = "application/json"
                    },
                    Body = RequestBody
                })

                if not Success or not Response then
                    return nil
                end

                if Response.StatusCode == 401 and RetryOnAuthFailure ~= false and TokenConfig.RefreshToken ~= "" and RefreshAccessToken() then
                    return MakeRequest(Url, Method, false, Body)
                end

                if Response.StatusCode < 200 or Response.StatusCode >= 300 then
                    return nil
                end

                if not Response.Body or Response.Body == "" then
                    return true
                end

                local DecodedSuccess, Body = pcall(HttpService.JSONDecode, HttpService, Response.Body)
                return DecodedSuccess and Body or nil
            end

            local function CacheImage(Id, Url)
                if not GetCustomAsset or not Id or not Url or Url == "" then
                    return PlaceholderImage
                end

                local SafeId = tostring(Id):gsub("[^%w_%-]", "_")
                local Path = CacheFolder .. "/" .. SafeId .. ".png"

                if not isfile(Path) then
                    pcall(function()
                        writefile(Path, game:HttpGet(Url))
                    end)
                end

                if isfile(Path) then
                    local AssetSuccess, Asset = pcall(GetCustomAsset, Path)
                    if AssetSuccess then
                        return Asset
                    end
                end

                return PlaceholderImage
            end

            local function ValidateToken()
                local Data = MakeRequest("me")
                return Data and Data.display_name
            end

            local function GetCurrentTrack()
                local Data = MakeRequest("me/player")
                if not Data or not Data.item then
                    return nil
                end

                local Artists = {}
                local ArtistList = Data.item.artists or {}
                for _, Artist in ArtistList do
                    table.insert(Artists, Artist.name)
                end

                local CoverUrl = Data.item.album and Data.item.album.images and Data.item.album.images[2] and
                    Data.item.album.images[2].url

                return {
                    Title = Data.item.name or "Unknown track",
                    Artist = #Artists > 0 and table.concat(Artists, ", ") or "Unknown artist",
                    Album = Data.item.album and Data.item.album.name or "Unknown album",
                    TrackId = Data.item.id or "",
                    Progress = Data.progress_ms or 0,
                    Duration = Data.item.duration_ms or 0,
                    Cover = CacheImage(Data.item.album and Data.item.album.id or Data.item.id, CoverUrl),
                    Device = Data.device and Data.device.name or "none",
                    IsPlaying = Data.is_playing == true,
                    Shuffle = Data.shuffle_state == true,
                    RepeatState = tostring(Data.repeat_state or "off"),
                    Uri = Data.item.uri or "",
                    UpdatedAt = tick()
                }
            end

            local function GetQueue()
                local Data = MakeRequest("me/player/queue")
                local Results = {}

                if not Data or type(Data.queue) ~= "table" then
                    return Results
                end

                for _, Track in Data.queue do
                    local Artists = {}

                    for _, Artist in Track.artists or {} do
                        table.insert(Artists, Artist.name)
                    end

                    table.insert(Results, {
                        Title = Track.name or "Unknown track",
                        Artist = #Artists > 0 and table.concat(Artists, ", ") or "Unknown artist"
                    })
                end

                return Results
            end

            local function SearchTracks(Query)
                local Data = MakeRequest("search?type=track&limit=8&q=" .. HttpService:UrlEncode(Query))
                local Results = {}

                if not Data or not Data.tracks or not Data.tracks.items then
                    return Results
                end

                for _, Track in Data.tracks.items do
                    local Artists = {}
                    local CoverUrl = Track.album and Track.album.images and Track.album.images[3] and
                        Track.album.images[3].url or
                        Track.album and Track.album.images and Track.album.images[2] and Track.album.images[2].url

                    for _, Artist in Track.artists or {} do
                        table.insert(Artists, Artist.name)
                    end

                    table.insert(Results, {
                        Title = Track.name or "Unknown track",
                        Artist = #Artists > 0 and table.concat(Artists, ", ") or "Unknown artist",
                        Album = Track.album and Track.album.name or "Unknown album",
                        AlbumId = Track.album and Track.album.id or "",
                        Uri = Track.uri or "",
                        Cover = CacheImage(Track.album and Track.album.id or Track.id, CoverUrl)
                    })
                end

                return Results
            end

            local function GetAlbumTracks(AlbumId)
                local Results = {}
                if not AlbumId or AlbumId == "" then
                    return Results
                end

                local Data = MakeRequest("albums/" .. AlbumId)
                if not Data or type(Data) ~= "table" or type(Data.tracks) ~= "table" or type(Data.tracks.items) ~= "table" then
                    return Results
                end

                local CoverUrl = Data.images and Data.images[3] and Data.images[3].url or
                    Data.images and Data.images[2] and Data.images[2].url or
                    Data.images and Data.images[1] and Data.images[1].url

                for _, Track in Data.tracks.items do
                    local Artists = {}

                    for _, Artist in Track.artists or {} do
                        table.insert(Artists, Artist.name)
                    end

                    table.insert(Results, {
                        Title = Track.name or "Unknown track",
                        Artist = #Artists > 0 and table.concat(Artists, ", ") or "Unknown artist",
                        Album = Data.name or "Unknown album",
                        AlbumId = AlbumId,
                        Uri = Track.uri or "",
                        Cover = CacheImage(AlbumId, CoverUrl),
                        IsAlbumTrack = true
                    })
                end

                return Results
            end

            local function Previous()
                return MakeRequest("me/player/previous", "POST")
            end

            local function Next()
                return MakeRequest("me/player/next", "POST")
            end

            local function Resume()
                return MakeRequest("me/player/play", "PUT")
            end

            local function Pause()
                return MakeRequest("me/player/pause", "PUT")
            end

            local function Shuffle(Enabled)
                return MakeRequest("me/player/shuffle?state=" .. tostring(Enabled), "PUT")
            end

            local function Repeat(Enabled)
                return MakeRequest("me/player/repeat?state=" .. (Enabled and "context" or "off"), "PUT")
            end

            local function Seek(Milliseconds)
                return MakeRequest("me/player/seek?position_ms=" .. math.max(math.floor(Milliseconds or 0), 0), "PUT")
            end

            local function PlayUri(Uri)
                if not Uri or Uri == "" then
                    return nil
                end

                return MakeRequest("me/player/play", "PUT", true, {
                    uris = { Uri }
                })
            end

            local function UpdateResults()
                for Index, Button in ResultButtons do
                    local Result = SearchResults[Index]

                    if Result then
                        Button.Frame.Instance.Visible = true
                        Button.Cover.Instance.Image = Result.Cover or PlaceholderImage
                        Button.Title.Instance.Text = Result.Title
                        if Result.IsBack then
                            Button.Album.Instance.Text = Result.Album or "Return to search results"
                        elseif Result.IsAlbumTrack then
                            Button.Album.Instance.Text = Result.Artist
                        else
                            Button.Album.Instance.Text = Result.Album
                        end
                    else
                        Button.Frame.Instance.Visible = false
                        Button.Cover.Instance.Image = PlaceholderImage
                        Button.Title.Instance.Text = ""
                        Button.Album.Instance.Text = ""
                    end
                end
            end

            local IsVisible = true
            local LastEmptyTokenNotification = 0
            local CustomPosition = nil

            local function NotifyEmptyToken()
                if Token ~= "" or TokenConfig.RefreshToken ~= "" then
                    return
                end

                local Now = tick()
                if Now - LastEmptyTokenNotification < 1 then
                    return
                end

                LastEmptyTokenNotification = Now
                Library:Notification("Empty Spotify Token", 3, Library.Theme["Risky"])
            end

            local function ApplyVisibility()
                Items["SpotifyPlayer"].Instance.Visible = IsVisible
                if Items["SpotifyPlayer"].Instance.Visible then
                    NotifyEmptyToken()
                end
            end

            local function AlignAboveKeybindList()
                local KeyList = Library.KeyList
                local KeyListFrame = KeyList and KeyList.Items and KeyList.Items["KeybindList"] and
                    KeyList.Items["KeybindList"].Instance
                if not KeyListFrame then
                    return
                end

                local KeybindPosition = KeyListFrame.AbsolutePosition
                local SpotifyHeight = Items["SpotifyPlayer"].Instance.AbsoluteSize.Y
                Items["SpotifyPlayer"].Instance.AnchorPoint = Vector2.new(0, 0)
                Items["SpotifyPlayer"].Instance.Position = UDim2.new(0, KeybindPosition.X, 0,
                    KeybindPosition.Y - SpotifyHeight - 5)
            end

            local function SetExpanded(Bool, Instant)
                IsExpanded = Bool

                local Player = Items["SpotifyPlayer"]
                local TweenInfoValue = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
                local PlayerAreaPosition = Bool and UDim2.new(0, 10, 1, -78) or UDim2.new(0, 10, 0, 10)
                local PlayerAreaSize = Bool and UDim2.new(1, -20, 0, 68) or UDim2.new(1, -20, 0, 68)
                local SearchPosition = Bool and UDim2.new(0, 10, 0, 10) or UDim2.new(0, 10, 0, -40)
                local ResultsPosition = Bool and UDim2.new(0, 10, 0, 42) or UDim2.new(0, 10, 0, -170)
                local LyricsPosition = Bool and UDim2.new(0, 270, 0, 10) or UDim2.new(1, 10, 0, 10)
                local ExpandRotation = Bool and 90 or 0

                if Instant then
                    Player.Instance.Size = Bool and ExpandedSize or CollapsedSize
                    Items["PlayerArea"].Instance.Position = PlayerAreaPosition
                    Items["PlayerArea"].Instance.Size = PlayerAreaSize
                    Items["SearchBackground"].Instance.Position = SearchPosition
                    Items["SearchResults"].Instance.Position = ResultsPosition
                    Items["LyricsFrame"].Instance.Position = LyricsPosition
                    Items["ExpandButton"].Instance.Rotation = ExpandRotation
                else
                    Player:Tween({
                        Size = Bool and ExpandedSize or CollapsedSize
                    }, TweenInfoValue)

                    Items["PlayerArea"]:Tween({ Position = PlayerAreaPosition }, TweenInfoValue)
                    Items["PlayerArea"]:Tween({ Size = PlayerAreaSize }, TweenInfoValue)
                    Items["SearchBackground"]:Tween({ Position = SearchPosition }, TweenInfoValue)
                    Items["SearchResults"]:Tween({ Position = ResultsPosition }, TweenInfoValue)
                    Items["LyricsFrame"]:Tween({ Position = LyricsPosition }, TweenInfoValue)
                    Items["ExpandButton"]:Tween({ Rotation = ExpandRotation }, TweenInfoValue)
                end

                Spotify:Center()
            end

            local function RunSearch(Query)
                local Trimmed = (Query or ""):gsub("^%s*(.-)%s*$", "%1")
                SearchAlbumBrowse = nil

                if Trimmed == "" then
                    SearchTrackResults = {}
                    SearchResults = {}
                    UpdateResults()
                    return
                end

                SearchTrackResults = SearchTracks(Trimmed)
                SearchResults = SearchTrackResults
                UpdateResults()
            end

            local function QueueSearch(Query)
                SearchRequestId += 1
                local RequestId = SearchRequestId

                task.delay(SearchDelay, function()
                    if RequestId ~= SearchRequestId then
                        return
                    end

                    RunSearch(Query)
                end)
            end

            local function RefreshSoon()
                task.delay(0.2, function()
                    if Library and Items["SpotifyPlayer"] and Items["SpotifyPlayer"].Instance.Parent then
                        Spotify:Refresh()
                    end
                end)
            end

            local function SetSeekingFromInput(Input)
                if not CurrentTrack or not CurrentTrack.Duration or CurrentTrack.Duration <= 0 then
                    return
                end

                local Bar = Items["ProgressFrame"].Instance
                local PositionX = Input.Position and Input.Position.X or UserInputService:GetMouseLocation().X
                local Alpha = math.clamp((PositionX - Bar.AbsolutePosition.X) / math.max(Bar.AbsoluteSize.X, 1), 0,
                    1)
                local Position = math.floor(CurrentTrack.Duration * Alpha)

                CurrentTrack.Progress = Position
                CurrentTrack.UpdatedAt = tick()
                SetProgress(Position, CurrentTrack.Duration, true)
            end

            Library:BindToWindowVisibility(ApplyVisibility)

            Items["SpotifyPlayer"]:Connect("InputEnded", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    CustomPosition = Items["SpotifyPlayer"].Instance.Position
                end
            end)

            function Spotify:SetVisibility(Bool)
                IsVisible = Bool
                ApplyVisibility()
            end

            function Spotify:Center()
                task.wait()
                if CustomPosition then
                    Items["SpotifyPlayer"].Instance.AnchorPoint = Vector2.new(0, 0)
                    Items["SpotifyPlayer"].Instance.Position = CustomPosition
                    return
                end
                AlignAboveKeybindList()
            end

            function Spotify:SetPosition(Position)
                CustomPosition = Position
                Items["SpotifyPlayer"].Instance.AnchorPoint = Vector2.new(0, 0)
                Items["SpotifyPlayer"].Instance.Position = Position
            end

            function Spotify:GetBounds()
                local Instance = Items["SpotifyPlayer"].Instance
                return Instance.AbsolutePosition, Instance.AbsoluteSize
            end

            function Spotify:SetToken(NewToken)
                TokenConfig = DecodeTokenConfig(NewToken)
                Token = TokenConfig.AccessToken
                WriteToken(TokenConfig)
                Spotify:Refresh()
            end

            function Spotify:Refresh()
                if not Request then
                    SetDisplay(nil, "Executor request API unavailable")
                    return false
                end

                if Token == "" and TokenConfig.RefreshToken == "" then
                    SetDisplay(nil, "Add a token or refresh config to niggahack/token.txt")
                    return false
                end

                if TokenConfig.RefreshToken ~= "" and (TokenConfig.ClientId == "" or TokenConfig.ClientSecret == "") then
                    SetDisplay(nil, "token.txt needs client_id and client_secret")
                    return false
                end

                if not EnsureAccessToken() then
                    SetDisplay(nil, "Could not refresh Spotify token")
                    return false
                end

                if not ValidateToken() then
                    SetDisplay(nil, "Invalid token in niggahack/token.txt")
                    return false
                end

                local Track = GetCurrentTrack()
                SetDisplay(Track, "Nothing is currently playing")
                SetQueueDisplay(Track, GetQueue(), "No upcoming tracks.")
                return Track ~= nil
            end

            for Index, Button in ResultButtons do
                Button.Button:Connect("MouseButton1Click", function()
                    local Result = SearchResults[Index]
                    if not Result then
                        return
                    end

                    if Result.IsBack then
                        SearchAlbumBrowse = nil
                        SearchResults = SearchTrackResults
                        UpdateResults()
                        return
                    end

                    if Result.IsAlbumTrack then
                        PlayUri(Result.Uri)
                        RefreshSoon()
                        return
                    end

                    SearchAlbumBrowse = Result.AlbumId
                    SearchResults = GetAlbumTracks(Result.AlbumId)

                    if #SearchResults > 0 then
                        table.insert(SearchResults, 1, {
                            Title = "< Back",
                            Album = Result.Album or "Back to results",
                            Cover = Result.Cover,
                            IsBack = true
                        })
                    end

                    UpdateResults()
                end)
            end

            Items["SearchInput"]:Connect("FocusLost", function(PressedEnter)
                if PressedEnter then
                    SearchRequestId += 1
                    RunSearch(Items["SearchInput"].Instance.Text)
                end
            end)

            Library:Connect(Items["SearchInput"].Instance:GetPropertyChangedSignal("Text"), function()
                QueueSearch(Items["SearchInput"].Instance.Text)
            end)

            Items["ExpandButton"]:Connect("MouseButton1Click", function()
                SetExpanded(not IsExpanded)
            end)

            Items["PlayPause"]:Connect("MouseButton1Click", function()
                if CurrentTrack and CurrentTrack.IsPlaying then
                    Pause()
                else
                    Resume()
                end

                RefreshSoon()
            end)

            Items["Shuffle"]:Connect("MouseButton1Click", function()
                Shuffle(not (CurrentTrack and CurrentTrack.Shuffle))
                RefreshSoon()
            end)

            Items["Repeat"]:Connect("MouseButton1Click", function()
                local RepeatEnabled = CurrentTrack and CurrentTrack.RepeatState and CurrentTrack.RepeatState ~= "off"
                Repeat(not RepeatEnabled)
                RefreshSoon()
            end)

            Items["ProgressHitbox"]:Connect("InputBegan", function(Input)
                if Input.UserInputType ~= Enum.UserInputType.MouseButton1 and Input.UserInputType ~= Enum.UserInputType.Touch then
                    return
                end

                Seeking = true
                SetSeekingFromInput(Input)
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if not Seeking then
                    return
                end

                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    SetSeekingFromInput(Input)
                end
            end)

            Library:Connect(UserInputService.InputEnded, function(Input)
                if not Seeking then
                    return
                end

                if Input.UserInputType ~= Enum.UserInputType.MouseButton1 and Input.UserInputType ~= Enum.UserInputType.Touch then
                    return
                end

                Seeking = false

                if CurrentTrack then
                    Seek(CurrentTrack.Progress)
                    RefreshSoon()
                end
            end)

            Library:Thread(function()
                while Library and Items["SpotifyPlayer"] and Items["SpotifyPlayer"].Instance.Parent do
                    Spotify:Refresh()
                    task.wait(PollInterval)
                end
            end)

            Library:Thread(function()
                while Library and Items["SpotifyPlayer"] and Items["SpotifyPlayer"].Instance.Parent do
                    if Seeking and CurrentTrack then
                        SetSeekingFromInput({
                            Position = UserInputService:GetMouseLocation()
                        })
                    end

                    if CurrentTrack and CurrentTrack.IsPlaying and not Seeking then
                        local Progress = math.min(CurrentTrack.Progress + ((tick() - CurrentTrack.UpdatedAt) * 1000),
                            CurrentTrack.Duration)
                        SetProgress(Progress, CurrentTrack.Duration, true)
                    end

                    task.wait(0.1)
                end
            end)

            Library:RegisterLayout("SpotifyPlayer", {
                Instance = Items["SpotifyPlayer"].Instance
            })

            UpdateResults()
            SetExpanded(false, true)
            Spotify:Center()
            return Spotify
        end

        Library.Playerlist = function(Self, Params)
            local Playerlist = {
                Items = {},
                IsSettings = true,
                Players = {},
                Selected = nil,
            }

            local Items = {}
            do
                Items["Playerlist"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    Size = UDim2.new(0, 461, 0, 403),
                    Position = UDim2.new(0, 828, 0, 99),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({ BackgroundColor3 = 'Background' })

                Items["Playerlist"]:MakeDraggable()

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Playerlist"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = 'Border' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Playerlist"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = 'Outline' })

                Items["AccentLiner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Playerlist"].Instance,
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({ BackgroundColor3 = 'Accent' })

                Items["DarkLiner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Playerlist"].Instance,
                    Position = UDim2.new(0, 0, 0, 1),
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Light Border"]
                }):AddToTheme({ BackgroundColor3 = 'Light Border' })

                Items["Background"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Playerlist"].Instance,
                    Position = UDim2.new(0, 10, 0, 30),
                    Size = UDim2.new(1, -20, 1, -90),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Section"]
                }):AddToTheme({ BackgroundColor3 = 'Section' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = 'Outline' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = 'Border' })

                Items["Holder"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    ScrollBarImageColor3 = Library.Theme["Accent"],
                    MidImage = "rbxassetid://129030709932941",
                    ScrollBarThickness = 1,
                    Size = UDim2.new(1, -16, 1, -16),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 8, 0, 8),
                    BottomImage = "rbxassetid://129030709932941",
                    TopImage = "rbxassetid://129030709932941"
                }):AddToTheme({ ScrollBarImageColor3 = 'Accent' })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Holder"].Instance,
                    PaddingTop = UDim.new(0, -4),
                    PaddingRight = UDim.new(0, 8)
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Holder"].Instance,
                    Padding = UDim.new(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["Content"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Playerlist"].Instance,
                    AnchorPoint = Vector2.new(0, 1),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 1, 0),
                    Size = UDim2.new(1, -20, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    Padding = UDim.new(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    PaddingBottom = UDim.new(0, 10)
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Playerlist"].Instance
                })

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Playerlist"].Instance,
                    TextColor3 = Library.Theme["Accent"],
                    Text = Params.Name,
                    Size = UDim2.new(0, 0, 0, 15),
                    Position = UDim2.new(0, 10, 0, 6),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({ TextColor3 = 'Accent' })

                Playerlist.Items = Items
            end

            function Playerlist:Add(Player)
                local PlayerName = Player.Name
                local PlayerDisplay = Player.DisplayName or PlayerName
                local PlayerUserID = Player.UserId

                local PlayerItems = {}
                do
                    PlayerItems["NewPlayer"] = Library:Create("TextButton", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize,
                        Parent = Items["Holder"].Instance,
                        TextColor3 = Color3.fromRGB(0, 0, 0),
                        Text = "",
                        AutoButtonColor = false,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 20),
                        BorderSizePixel = 0
                    })

                    PlayerItems["Username"] = Library:Create("TextLabel", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize,
                        Parent = PlayerItems["NewPlayer"].Instance,
                        TextWrapped = true,
                        TextColor3 = Library.Theme["Text"],
                        Text = PlayerDisplay .. " (" .. PlayerName .. ")",
                        Size = UDim2.new(0, 0, 0, 15),
                        AnchorPoint = Vector2.new(0, 0.5),
                        BorderSizePixel = 0,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 0, 0.5, 0),
                        AutomaticSize = Enum.AutomaticSize.X
                    }):AddToTheme({ TextColor3 = 'Text' })

                    PlayerItems["UserID"] = Library:Create("TextLabel", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize,
                        Parent = PlayerItems["NewPlayer"].Instance,
                        TextWrapped = true,
                        TextColor3 = Library.Theme["Text"],
                        Text = tostring(PlayerUserID),
                        Size = UDim2.new(0, 0, 0, 15),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        BorderSizePixel = 0,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                        AutomaticSize = Enum.AutomaticSize.X
                    }):AddToTheme({ TextColor3 = 'Text' })

                    PlayerItems["Status"] = Library:Create("TextLabel", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize,
                        Parent = PlayerItems["NewPlayer"].Instance,
                        TextWrapped = true,
                        TextColor3 = Library.Theme["Text"],
                        Text = "Neutral",
                        Size = UDim2.new(0, 0, 0, 15),
                        AnchorPoint = Vector2.new(1, 0.5),
                        BorderSizePixel = 0,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(1, 0, 0.5, 0),
                        AutomaticSize = Enum.AutomaticSize.X
                    }):AddToTheme({ TextColor3 = 'Text' })
                end


                local PlayerData = {
                    Name = PlayerName,
                    Display = PlayerDisplay,
                    Player = Player,
                    Items = PlayerItems,
                    Status = "Neutral",
                    IsSelected = false,
                }

                function PlayerData:ToggleState(Status)
                    if Status == "Active" then
                        PlayerItems["Username"]:ChangeItemTheme({ TextColor3 = "Accent" })
                        PlayerItems["Username"]:Tween({ TextColor3 = Library.Theme.Accent })
                    else
                        PlayerItems["Username"]:ChangeItemTheme({ TextColor3 = "Text" })
                        PlayerItems["Username"]:Tween({ TextColor3 = Library.Theme.Text })
                    end
                end

                function PlayerData:Set()
                    PlayerData.IsSelected = not PlayerData.IsSelected

                    if PlayerData.IsSelected then
                        Playerlist.Selected = PlayerData

                        PlayerData.IsSelected = true
                        PlayerData:ToggleState("Active")

                        for Index, Value in Playerlist.Players do
                            if Value ~= PlayerData then
                                Value.IsSelected = false
                                Value:ToggleState("Inactive")
                            end
                        end
                    else
                        Playerlist.Selected = nil

                        PlayerData.IsSelected = false
                        PlayerData:ToggleState("Inactive")
                    end

                    Library:SafeCall(Playerlist.Callback, Playerlist.Selected)
                end

                PlayerData.Items.NewPlayer:Connect("MouseButton1Down", function()
                    PlayerData:Set()
                end)

                Playerlist.Players[PlayerData.Name] = PlayerData
                return PlayerData
            end

            function Playerlist:Remove(Player)
                if Playerlist.Players[Player.Name] then
                    Playerlist.Players[Player.Name].Items.NewPlayer.Instance:Destroy()
                end
            end

            function Playerlist:SetVisibility(Bool)
                Playerlist.Visible = Bool
                Items["Playerlist"].Instance.Visible = Bool and Library.WindowOpenState
            end

            function Playerlist:Center()
                local AbsPos = Items["Playerlist"].Instance.AbsolutePosition
                Items["Playerlist"].Instance.AnchorPoint = Vector2.new(0, 0)
                task.wait()
                Items["Playerlist"].Instance.Position = UDim2.new(0, AbsPos.X, 0, AbsPos.Y + GuiInset)
            end

            function Playerlist:SetText(Text)
                Items["Text"].Instance.Text = Text
            end

            local StatusDropdown = Library:Dropdown({
                Name = "Status",
                Flag = "PlayerlistStatus",
                Items = { "Neutral", "Enemy", "Friendly" },
                Parent = Items["Playerlist"],
                Callback = function(Value)
                    if Playerlist.Selected then
                        local PlayerItems = Playerlist.Selected.Items

                        if PlayerItems then
                            local NeutralColor = Library.Theme.Text
                            local EnemyColor = Color3.fromRGB(255, 0, 0)
                            local FriendlyColor = Color3.fromRGB(0, 255, 0)

                            PlayerItems["Status"]:Tween({
                                TextColor3 = Value == "Enemy" and EnemyColor or Value == "Friendly" and FriendlyColor or
                                    NeutralColor
                            })

                            PlayerItems["Status"].Instance.Text = Value
                            Playerlist.Selected.Status = Value
                        end
                    end
                end
            })

            StatusDropdown.Items.Dropdown.Instance.Position = UDim2.new(0, 10, 1, -10)
            StatusDropdown.Items.Dropdown.Instance.AnchorPoint = Vector2.new(0, 1)
            StatusDropdown.Items.Dropdown.Instance.Size = UDim2.new(1, -20, 0, 40)

            for Index, Value in Players:GetPlayers() do
                Playerlist:Add(Value)
            end

            Playerlist.Visible = true
            Library:BindToWindowVisibility(function(IsWindowOpen)
                Items["Playerlist"].Instance.Visible = Playerlist.Visible and IsWindowOpen
            end)

            Library:Connect(Items["Content"].Instance.ChildAdded, function()
                task.wait()
                Items["Content"].Instance.Position = UDim2.new(0, 10, 1, Items["Content"].Instance.AbsoluteSize.Y)
            end)

            Library:Connect(Players.PlayerAdded, function(Player)
                Playerlist:Add(Player)
            end)

            Library:Connect(Players.PlayerRemoving, function(Player)
                Playerlist:Remove(Player)
            end)

            Library:RegisterLayout("Playerlist", {
                Instance = Items["Playerlist"].Instance
            })

            Playerlist:Center()

            return setmetatable(Playerlist, Library)
        end

        Library.Tooltip = function(Self, Text)
            local Object = Self.Instance

            if not Object or Text == nil then
                return
            end

            if type(Text) == "string" then
                Text = {
                    Title = "",
                    Description = Text
                }
            end

            local TitleThemeKey = Text.ColorThemeKey or Text.colorThemeKey or (Text.Risky and "Risky") or "Accent"
            local TitleText = tostring(Text.Title or "")
            local DescriptionText = tostring(Text.Description or "")
            local ShowTitle = TitleText ~= ""
            local TooltipFrame = nil
            local RenderStepped = nil

            local function DestroyTooltip()
                if RenderStepped then
                    RenderStepped:Disconnect()
                    RenderStepped = nil
                end

                if TooltipFrame then
                    TooltipFrame:Destroy()
                    TooltipFrame = nil
                end
            end

            local function CreateTooltip()
                DestroyTooltip()

                local Items = {}
                Items["Tooltip"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    Position = UDim2.new(0, 873, 0, 10),
                    BorderSizePixel = 0,
                    ZIndex = 50,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({ BackgroundColor3 = "Element" })
                TooltipFrame = Items["Tooltip"].Instance

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = TooltipFrame,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = "Border" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = TooltipFrame,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = "Outline" })

                local TitleLabel = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = TooltipFrame,
                    ZIndex = 51,
                    TextColor3 = Library.Theme[TitleThemeKey] or Library.Theme["Accent"],
                    Text = TitleText,
                    Size = UDim2.new(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    Visible = ShowTitle
                }):AddToTheme({ TextColor3 = TitleThemeKey })
                TitleLabel.Instance.Text = TitleText
                TitleLabel.Instance.Visible = ShowTitle

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = TooltipFrame,
                    PaddingTop = UDim.new(0, 4),
                    PaddingBottom = UDim.new(0, 4),
                    PaddingRight = UDim.new(0, 8),
                    PaddingLeft = UDim.new(0, 8)
                })

                local DescriptionLabel = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = TooltipFrame,
                    ZIndex = 51,
                    TextColor3 = Library.Theme["Text"],
                    Text = DescriptionText,
                    Size = UDim2.new(0, 0, 0, 15),
                    Position = ShowTitle and UDim2.new(0, 0, 0, 18) or UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({ TextColor3 = "Text" })
                DescriptionLabel.Instance.Text = DescriptionText

                local MouseLocation = UserInputService:GetMouseLocation()
                TooltipFrame.Position = UDim2.new(0, MouseLocation.X + 20, 0, MouseLocation.Y + 20)

                RenderStepped = RunService.RenderStepped:Connect(function()
                    if not TooltipFrame then
                        return
                    end

                    local UpdatedLocation = UserInputService:GetMouseLocation()
                    TooltipFrame.Position = UDim2.new(0, UpdatedLocation.X + 20, 0, UpdatedLocation.Y + 20)
                end)
            end

            Self:OnHover(CreateTooltip, DestroyTooltip)
            Library:Connect(Object.AncestryChanged, function(_, Parent)
                if Parent == nil then
                    DestroyTooltip()
                end
            end)
        end

        Library.Window = function(Self, Params)
            Params = Params or {}

            local Window = {
                IsOpen = true,
                Title = tostring(Params.Title or Params.title or Params.Name or Params.name or "Panel"),
                DockButtonText = tostring(Params.ButtonName or Params.buttonName or "Main UI"),
                Pages = {},
                Items = {}
            }

            local Items = {}
            do
                Items["MainFrame"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Size = UDim2.new(0, 552, 0, 451),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({ BackgroundColor3 = 'Background' })

                Items["MainFrame"]:MakeDraggable()
                Items["MainFrame"]:MakeResizeable(Vector2.new(Items["MainFrame"].Instance.AbsoluteSize.X,
                    Items["MainFrame"].Instance.AbsoluteSize.Y))

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["MainFrame"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = 'Outline' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["MainFrame"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = 'Border' })

                Items["AccentLiner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["MainFrame"].Instance,
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({ BackgroundColor3 = 'Accent' })

                Items["DarkLiner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["MainFrame"].Instance,
                    Position = UDim2.new(0, 0, 0, 1),
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Light Border"]
                }):AddToTheme({ BackgroundColor3 = 'Light Border' })


                Items["Shadow"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["MainFrame"].Instance,
                    ImageColor3 = Color3.fromRGB(103, 164, 255),
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = 0.699999988079071,
                    Size = UDim2.new(1, 25, 1, 25),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Image = "http://www.roblox.com/asset/?id=18245826428",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    ZIndex = -1,
                    BorderSizePixel = 0,
                    SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79))
                }):AddToTheme({ ImageColor3 = 'Accent' })

                Items["Header"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Visible = true,
                    Position = UDim2.new(0, 0, 0, 0),
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                })

                Items["HeaderFirstInline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Header"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 6, 0, 26),
                    Size = UDim2.new(1, -12, 1, -36),
                    BorderSizePixel = 0,
                    ZIndex = 2,
                    BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["HeaderFirstInline"].Instance,
                    Color = Color3.fromRGB(40, 40, 45),
                    LineJoinMode = Enum.LineJoinMode.Miter
                }):AddToTheme({ Color = function() return Library.Theme["Border"] end })

                Items["HeaderSecondInline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["HeaderFirstInline"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    ZIndex = 2,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["HeaderSecondInline"].Instance,
                    Color = Color3.fromRGB(10, 10, 15),
                    LineJoinMode = Enum.LineJoinMode.Miter
                }):AddToTheme({ Color = function() return Library.Theme["Outline"] end })

                Items["HeaderAccent"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["HeaderSecondInline"].Instance,
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(19, 128, 225)
                }):AddToTheme({ BackgroundColor3 = "Accent" })

                Items["HeaderThirdInline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["HeaderSecondInline"].Instance,
                    Position = UDim2.new(0, 0, 0, 1),
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(46, 46, 46)
                }):AddToTheme({ BackgroundColor3 = function() return Library.Theme["Outline"] end })

                Items["HeaderOutline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["HeaderSecondInline"].Instance,
                    Position = UDim2.new(0, 0, 0, 2),
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(10, 10, 15)
                }):AddToTheme({ BackgroundColor3 = function() return Library.Theme["Border"] end })

                Items["HeaderInnerOutline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Header"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 6, 0, 26),
                    Size = UDim2.new(1, -12, 1, -36),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["HeaderInnerOutline"].Instance,
                    Color = Color3.fromRGB(15, 15, 20),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Thickness = 10000
                }):AddToTheme({ Color = function() return Library.Theme["Background"] end })

                Items["HeaderTitle"] = Library:Create("TextLabel", {
                    Name = "\0",
                    Parent = Items["HeaderInnerOutline"].Instance,
                    FontFace = Library.Font,
                    TextColor3 = Color3.fromRGB(235, 235, 235),
                    TextStrokeColor3 = Color3.fromRGB(255, 255, 255),
                    Text = Window.Title,
                    AnchorPoint = Vector2.new(0, 1),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, -1, 0, -8),
                    AutomaticSize = Enum.AutomaticSize.XY,
                    TextSize = 9,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                }):AddToTheme({ TextColor3 = "Text" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["HeaderTitle"].Instance,
                    LineJoinMode = Enum.LineJoinMode.Miter
                })

                Items["HeaderButtonHolder"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["HeaderInnerOutline"].Instance,
                    AnchorPoint = Vector2.new(1, 1),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 1, 0, -6),
                    Size = UDim2.new(0, 0, 0, 16),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["HeaderButtonHolder"].Instance,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    Padding = UDim.new(0, 7),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["DockOutline"] = Library:Create("TextButton", {
                    Name = "\0",
                    Parent = Items["HeaderButtonHolder"].Instance,
                    AutoButtonColor = false,
                    Active = false,
                    Selectable = false,
                    Text = "",
                    Size = UDim2.new(0, 0, 0, 16),
                    AutomaticSize = Enum.AutomaticSize.X,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(46, 46, 46)
                }):AddToTheme({ BackgroundColor3 = function() return Library.Theme["Outline"] end })

                Items["DockInline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["DockOutline"].Instance,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    AutomaticSize = Enum.AutomaticSize.X,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(10, 10, 15)
                }):AddToTheme({ BackgroundColor3 = function() return Library.Theme["Border"] end })

                Items["Dock"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["DockInline"].Instance,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    AutomaticSize = Enum.AutomaticSize.X,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                }):AddToTheme({ BackgroundColor3 = function() return Library.Theme["Section"] end })

                Items["DockText"] = Library:Create("TextLabel", {
                    Name = "\0",
                    Parent = Items["DockOutline"].Instance,
                    FontFace = Library.Font,
                    TextSize = 9,
                    Text = Window.DockButtonText,
                    TextColor3 = Color3.fromRGB(145, 145, 145),
                    TextStrokeColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 0, 0.5, 0),
                    ZIndex = 2,
                    Size = UDim2.new(0, 0, 0, 15),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                }):AddToTheme({
                    TextColor3 = function()
                        return Window.IsOpen and Library.Theme["Text"] or Library.Theme["Inactive Text"]
                    end
                })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["DockText"].Instance,
                    LineJoinMode = Enum.LineJoinMode.Miter
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["DockText"].Instance,
                    PaddingLeft = UDim.new(0, 7),
                    PaddingRight = UDim.new(0, 5)
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["DockInline"].Instance,
                    PaddingRight = UDim.new(0, 2)
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["DockOutline"].Instance,
                    PaddingRight = UDim.new(0, 2)
                })

                Items["Header"].Instance.Visible = Window.IsOpen

                Items["PagesOutline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["MainFrame"].Instance,
                    Position = UDim2.new(0, 10, 0, 11),
                    Size = UDim2.new(1, -20, 0, 30),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Border 2"]
                }):AddToTheme({ BackgroundColor3 = 'Border 2' })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["PagesOutline"].Instance,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDim.new(0, 1),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["PagesOutline"].Instance,
                    PaddingTop = UDim.new(0, 1),
                    PaddingBottom = UDim.new(0, 1),
                    PaddingRight = UDim.new(0, 1),
                    PaddingLeft = UDim.new(0, 1)
                })

                Items["ContentOutline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["MainFrame"].Instance,
                    Position = UDim2.new(0, 10, 0, 42),
                    Size = UDim2.new(1, -20, 1, -52),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Border 2"]
                }):AddToTheme({ BackgroundColor3 = 'Border 2' })

                Items["Content"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["ContentOutline"].Instance,
                    Position = UDim2.new(0, 2, 0, 2),
                    Size = UDim2.new(1, -4, 1, -4),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({ BackgroundColor3 = 'Background' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = 'Outline' })

                Window.Items = Items
                Library.MainWindowFrame = Items["MainFrame"].Instance
            end

            local Debounce = false

            local function CreateHeaderButton(Text, DefaultActive)
                local ButtonData = {
                    Active = DefaultActive == true
                }

                local ButtonItems = {}

                ButtonItems["Outline"] = Library:Create("TextButton", {
                    Name = "\0",
                    Parent = Items["HeaderButtonHolder"].Instance,
                    AutoButtonColor = false,
                    Active = false,
                    Selectable = false,
                    Text = "",
                    Size = UDim2.new(0, 0, 0, 16),
                    AutomaticSize = Enum.AutomaticSize.X,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({ BackgroundColor3 = function() return Library.Theme["Outline"] end })

                ButtonItems["Inline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = ButtonItems["Outline"].Instance,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    AutomaticSize = Enum.AutomaticSize.X,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Border"]
                }):AddToTheme({ BackgroundColor3 = function() return Library.Theme["Border"] end })

                ButtonItems["Background"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = ButtonItems["Inline"].Instance,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    AutomaticSize = Enum.AutomaticSize.X,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Section"]
                }):AddToTheme({ BackgroundColor3 = function() return Library.Theme["Section"] end })

                ButtonItems["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    Parent = ButtonItems["Outline"].Instance,
                    FontFace = Library.Font,
                    TextSize = 9,
                    Text = tostring(Text or ""),
                    TextColor3 = ButtonData.Active and Library.Theme["Text"] or Library.Theme["Inactive Text"],
                    TextStrokeColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 0, 0.5, 0),
                    ZIndex = 2,
                    Size = UDim2.new(0, 0, 0, 15),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                }):AddToTheme({
                    TextColor3 = function()
                        return ButtonData.Active and Library.Theme["Text"] or Library.Theme["Inactive Text"]
                    end
                })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = ButtonItems["Text"].Instance,
                    LineJoinMode = Enum.LineJoinMode.Miter
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = ButtonItems["Text"].Instance,
                    PaddingLeft = UDim.new(0, 7),
                    PaddingRight = UDim.new(0, 5)
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = ButtonItems["Inline"].Instance,
                    PaddingRight = UDim.new(0, 2)
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = ButtonItems["Outline"].Instance,
                    PaddingRight = UDim.new(0, 2)
                })

                function ButtonData:SetText(Value)
                    ButtonItems["Text"].Instance.Text = tostring(Value or "")
                end

                function ButtonData:SetActive(Value)
                    ButtonData.Active = Value == true
                    ButtonItems["Text"]:Tween({
                        TextColor3 = ButtonData.Active and Library.Theme["Text"] or Library.Theme["Inactive Text"]
                    })
                end

                function ButtonData:SetVisible(Value)
                    ButtonItems["Outline"].Instance.Visible = Value == true
                end

                function ButtonData:SetCallback(Callback)
                    ButtonData.Callback = Callback
                end

                ButtonItems["Outline"]:Connect("MouseButton1Down", function()
                    if type(ButtonData.Callback) == "function" then
                        ButtonData.Callback(ButtonData)
                    end
                end)

                ButtonData.Items = ButtonItems
                return ButtonData
            end

            local function UpdateDockState()
                Items["DockText"]:Tween({
                    TextColor3 = Window.IsOpen and Library.Theme["Text"] or Library.Theme["Inactive Text"]
                })
            end

            function Window:SetOpen(Bool)
                if Debounce then
                    return
                end

                Debounce = true

                Window.IsOpen = Bool
                Items["Header"].Instance.Visible = Bool
                Library:SetWindowVisibilityState(Bool)
                Library:SetBackgroundEffectsVisible(Bool)
                UpdateDockState()

                Items["MainFrame"]:FadeDescendants(Bool, function()
                    Debounce = false
                end)
            end

            function Window:Center()
                local AbsPos = Items["MainFrame"].Instance.AbsolutePosition
                Items["MainFrame"].Instance.AnchorPoint = Vector2.new(0, 0)
                task.wait()
                Items["MainFrame"].Instance.Position = UDim2.new(0, AbsPos.X, 0, AbsPos.Y)
            end

            function Window:SetTitle(Text)
                Window.Title = tostring(Text or "Panel")
                Items["HeaderTitle"].Instance.Text = Window.Title
            end

            function Window:SetDockText(Text)
                Window.DockButtonText = tostring(Text or "Main UI")
                Items["DockText"].Instance.Text = Window.DockButtonText
            end

            function Window:AddHeaderButton(Params)
                Params = Params or {}

                local Button = CreateHeaderButton(Params.Text or Params.Name or "Button", Params.Active)
                if type(Params.Callback) == "function" then
                    Button:SetCallback(Params.Callback)
                end

                return Button
            end

            Items["DockOutline"]:Connect("MouseButton1Down", function()
                Window:SetOpen(not Window.IsOpen)
            end)

            Library:Connect(UserInputService.InputBegan, function(Input)
                if tostring(Input.KeyCode) == Library.MenuKeybind or tostring(Input.UserInputType) == Library.MenuKeybind then
                    Window:SetOpen(not Window.IsOpen)
                end
            end)

            Library:Connect(RunService.RenderStepped, function()
                if Window.IsOpen then
                    Library:GlobalUpdateOpenFrames()
                end
            end)

            Library:RegisterLayout("MainWindow", {
                Instance = Items["MainFrame"].Instance,
                SaveSize = true,
                MinimumSize = Vector2.new(552, 451)
            })

            Library:RegisterLayout("MainWindowDock", {
                Instance = Items["DockOutline"].Instance
            })

            UpdateDockState()
            Window:Center()
            return setmetatable(Window, Library)
        end

        Library.Page = function(Self, Params)
            Params = Params or {}

            local Page = {
                Name = Params.Name or Params.name or "Page",

                Window = Self,
                Items = {},
                Pages = {},
                Active = false
            }

            local Items = {}
            do
                Items["Inactive"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Page.Window.Items["PagesOutline"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({ BackgroundColor3 = 'Outline' })

                Items["InactiveInline"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Inactive"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({ BackgroundColor3 = 'Outline' })

                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["InactiveInline"].Instance,
                    Rotation = -90,
                    Color = ColorSequence.new {
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(172, 172, 172))
                    }
                })

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["InactiveInline"].Instance,
                    TextWrapped = true,
                    TextColor3 = Library.Theme["Text"],
                    Text = Page.Name,
                    Size = UDim2.new(0, 0, 0, 15),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({ TextColor3 = 'Text' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Inactive"].Instance,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border 2"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = 'Border 2' })

                Items["Page"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.UnusedHolder.Instance,
                    BackgroundTransparency = 1,
                    Visible = false,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0
                })

                Items["Columns"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Page"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 10),
                    Size = UDim2.new(1, 0, 1, -10),
                    BorderSizePixel = 0
                })

                Items["SubPages"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Page"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 14, 0, 0),
                    Size = UDim2.new(1, 0, 0, 20),
                    BorderSizePixel = 0
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["SubPages"].Instance,
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(0, 15),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["SubPages"].Instance,
                    PaddingTop = UDim.new(0, 3)
                })

                Page.Items = Items
            end

            local Debounce = false

            function Page:Turn(Bool)
                if Debounce then
                    return
                end

                Debounce = true

                Page.Active = Bool

                if Bool then
                    Items["Text"]:ChangeItemTheme({ TextColor3 = "Accent" })
                    Items["Text"]:Tween({ TextColor3 = Library.Theme.Accent })
                else
                    Items["Text"]:ChangeItemTheme({ TextColor3 = "Text" })
                    Items["Text"]:Tween({ TextColor3 = Library.Theme.Text })
                end

                Items["Page"]:FadeDescendants(Bool, function()
                    Debounce = false

                    if Items["Page"].Instance.Visible then
                        Items["Page"].Instance.Parent = Page.Window.Items["Content"].Instance
                    else
                        Items["Page"].Instance.Parent = Library.UnusedHolder.Instance
                    end
                end)
            end

            Items["InactiveInline"]:Connect("MouseButton1Down", function()
                for Index, Value in Page.Window.Pages do
                    Value:Turn(Value == Page)
                end
            end)

            if #Page.Window.Pages == 0 then
                Page:Turn(true)
            end

            table.insert(Page.Window.Pages, Page)
            return setmetatable(Page, Library)
        end

        Library.SubPage = function(Self, Params)
            Params = Params or {}

            local Page = {
                Name = Params.Name or Params.name or "Page",

                Window = Self.Window,
                Page = Self,
                ColumnsData = {},
                Items = {},
                Active = false
            }

            local Items = {}
            do
                Items["Inactive"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Page.Page.Items["SubPages"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Page.Name,
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({ TextColor3 = 'Text' })

                Items["Page"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.UnusedHolder.Instance,
                    BackgroundTransparency = 1,
                    Visible = false,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Page"].Instance,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDim.new(0, 12),
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    VerticalFlex = Enum.UIFlexAlignment.Fill
                })

                Items["LeftColumn"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["Page"].Instance,
                    ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ScrollBarThickness = 0,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 100, 0, 100),
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0)
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["LeftColumn"].Instance,
                    PaddingTop = UDim.new(0, 14),
                    PaddingLeft = UDim.new(0, 14),
                    PaddingBottom = UDim.new(0, 14)
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["LeftColumn"].Instance,
                    Padding = UDim.new(0, 14),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["RightColumn"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["Page"].Instance,
                    ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ScrollBarThickness = 0,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 100, 0, 100),
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0)
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["RightColumn"].Instance,
                    PaddingTop = UDim.new(0, 14),
                    PaddingRight = UDim.new(0, 14),
                    PaddingBottom = UDim.new(0, 14)
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["RightColumn"].Instance,
                    Padding = UDim.new(0, 14),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Page.ColumnsData[1] = Items["LeftColumn"]
                Page.ColumnsData[2] = Items["RightColumn"]

                Page.Items = Items
            end

            local Debounce = false

            function Page:Turn(Bool)
                if Debounce then
                    return
                end

                Page.Active = Bool

                Debounce = true

                if Bool then
                    Items["Inactive"]:ChangeItemTheme({ TextColor3 = "Accent" })
                    Items["Inactive"]:Tween({ TextColor3 = Library.Theme.Accent })
                else
                    Items["Inactive"]:ChangeItemTheme({ TextColor3 = "Text" })
                    Items["Inactive"]:Tween({ TextColor3 = Library.Theme.Text })
                end

                Items["Page"]:FadeDescendants(Bool, function()
                    Debounce = false

                    if Items["Page"].Instance.Visible then
                        Items["Page"].Instance.Parent = Page.Page.Items["Columns"].Instance
                    else
                        Items["Page"].Instance.Parent = Library.UnusedHolder.Instance
                    end
                end)
            end

            Items["Inactive"]:Connect("MouseButton1Down", function()
                for Index, Value in Page.Page.Pages do
                    Value:Turn(Value == Page)
                end
            end)

            if #Page.Page.Pages == 0 then
                Page:Turn(true)
            end

            table.insert(Page.Page.Pages, Page)
            return setmetatable(Page, Library)
        end

        Library.Section = function(Self, Params)
            Params = Params or {}

            local Section = {
                Name = Params.Name or Params.name or "Section",
                Side = Params.Side or Params.side or 1,

                Window = Self.Window,
                Page = Self,
                Items = {},
            }

            local Items = {}
            do
                Items["SectionOutline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Section.Page.ColumnsData[Section.Side].Instance,
                    Size = UDim2.new(1, 0, 0, 20),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({ BackgroundColor3 = 'Outline' })

                Items["Section"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["SectionOutline"].Instance,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Section"]
                }):AddToTheme({ BackgroundColor3 = 'Section' })

                Items["Content"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Section"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 36, 0, 15),
                    Size = UDim2.new(1, -72, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    Padding = UDim.new(0, 7),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    PaddingBottom = UDim.new(0, 20)
                })

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["SectionOutline"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Section.Name,
                    Size = UDim2.new(0, 0, 0, 4),
                    Position = UDim2.new(0, 6, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme["Section"]
                }):AddToTheme({ BackgroundColor3 = 'Section' })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Text"].Instance,
                    PaddingRight = UDim.new(0, 4),
                    PaddingLeft = UDim.new(0, 4)
                })

                Section.Items = Items
            end

            return setmetatable(Section, Library)
        end

        Library.Toggle = function(Self, Params)
            Params = Params or {}

            local Toggle = {
                Name = Params.Name or Params.name or "Toggle",
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or false,
                Risky = Params.Risky or Params.risky or false,
                Tooltip = Params.Tooltip or Params.tooltip or nil,
                Callback = Params.Callback or Params.callback or function() end,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Value = false,
                Items = {}
            }

            local Parent

            if Params.Parent then
                Parent = Params.Parent
            else
                Parent = Toggle.Section.Items["Content"]
            end

            local Items = {}
            local ToggleButtonOffset = Toggle.Section.IsSettings and 0 or 20
            local ToggleTextOffset = Toggle.Section.IsSettings and 14 or 20
            do
                Items["Toggle"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Parent.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, -ToggleButtonOffset, 0, 0),
                    Size = UDim2.new(1, ToggleButtonOffset, 0, 12),
                    BorderSizePixel = 0
                })

                local TooltipData = Toggle.Tooltip
                if Toggle.Risky and typeof(Toggle.Tooltip) == "table" then
                    TooltipData = table.clone(Toggle.Tooltip)
                    TooltipData.Risky = true
                end
                Items["Toggle"]:Tooltip(TooltipData)

                Items["Indicator"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Toggle"].Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 0, 0.5, 0),
                    Size = UDim2.new(0, 8, 0, 8),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({ BackgroundColor3 = 'Element' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Indicator"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"]
                }):AddToTheme({ Color = 'Border' })

                Items["Inline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Indicator"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({ BackgroundColor3 = 'Accent' })

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Toggle"].Instance,
                    TextColor3 = Color3.fromRGB(100, 100, 100),
                    Text = Toggle.Name,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Size = UDim2.new(0, 0, 0, 12),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, ToggleTextOffset, 0.5, -2),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({ TextColor3 = 'Inactive Text' })

                if Toggle.Risky then
                    Items["Text"]:ChangeItemTheme({ TextColor3 = "Risky" })
                    Items["Text"].Instance.TextColor3 = Library.Theme["Risky"]
                end

                Items["SubElements"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Toggle"].Instance,
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 0, 0, 0),
                    Size = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["SubElements"].Instance,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    Padding = UDim.new(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["Toggle"]:OnHover(function()
                    Items["Indicator"]:Tween({ BackgroundColor3 = Library.Theme["Hovered Element"] })
                end, function()
                    Items["Indicator"]:Tween({ BackgroundColor3 = Library.Theme["Element"] })
                end)

                Toggle.Items = Items
            end

            function Toggle:Set(Bool)
                Toggle.Value = Bool

                if Bool then
                    Items["Inline"]:Tween({ BackgroundTransparency = 0, Size = UDim2.new(1, 0, 1, 0) })
                    if not Toggle.Risky then
                        Items["Text"]:ChangeItemTheme({ TextColor3 = "Text" })
                        Items["Text"]:Tween({ TextColor3 = Library.Theme.Text })
                    end
                else
                    Items["Inline"]:Tween({ BackgroundTransparency = 1, Size = UDim2.new(0, 0, 0, 0) })
                    if not Toggle.Risky then
                        Items["Text"]:ChangeItemTheme({ TextColor3 = "Inactive Text" })
                        Items["Text"]:Tween({ TextColor3 = Library.Theme["Inactive Text"] })
                    end
                end

                Flags[Toggle.Flag] = Bool
                Library:SafeCall(Toggle.Callback, Bool)
            end

            function Toggle:SetVisibility(Bool)
                Items["Toggle"].Instance.Visible = Bool
            end

            function Toggle:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            function Toggle:Settings()
                local Settingss = {
                    IsSettings = true
                }

                Items["SettingsButton"] = Library:Create("ImageButton", {
                    Name = "\0",
                    Parent = Items["SubElements"].Instance,
                    ImageColor3 = Library.Theme["Text"],
                    AutoButtonColor = false,
                    Image = "rbxassetid://124244905334583",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 12, 0, 12),
                    BorderSizePixel = 0
                }):AddToTheme({ ImageColor3 = 'Text' })

                local SettingsItems = {
                    IsOpen = false,
                    Items = {},
                }
                do
                    SettingsItems["ToggleSettings"] = Library:Create("Frame", {
                        Name = "\0",
                        Parent = Library.UnusedHolder.Instance,
                        Position = UDim2.new(0.5156353712081909, 0, 0.08411215990781784, 0),
                        Visible = false,
                        Size = UDim2.new(0, 254, 0, 242),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Background"]
                    }):AddToTheme({ BackgroundColor3 = 'Background' })

                    Library:Create("UIStroke", {
                        Name = "\0",
                        Parent = SettingsItems["ToggleSettings"].Instance,
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                        LineJoinMode = Enum.LineJoinMode.Miter,
                        Color = Library.Theme["Outline"]
                    }):AddToTheme({ Color = 'Outline' })

                    Library:Create("UIStroke", {
                        Name = "\0",
                        Parent = SettingsItems["ToggleSettings"].Instance,
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                        LineJoinMode = Enum.LineJoinMode.Miter,
                        Color = Library.Theme["Border"],
                        BorderOffset = UDim.new(0, 1)
                    }):AddToTheme({ Color = 'Border' })

                    SettingsItems["Text"] = Library:Create("TextLabel", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize,
                        Parent = SettingsItems["ToggleSettings"].Instance,
                        TextColor3 = Library.Theme["Text"],
                        Text = Toggle.Name,
                        Size = UDim2.new(0, 0, 0, 12),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 28, 0, 9),
                        BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.X
                    }):AddToTheme({ TextColor3 = 'Text' })

                    SettingsItems["Content"] = Library:Create("ScrollingFrame", {
                        Name = "\0",
                        Parent = SettingsItems["ToggleSettings"].Instance,
                        AutomaticCanvasSize = Enum.AutomaticSize.Y,
                        BorderSizePixel = 0,
                        CanvasSize = UDim2.new(0, 0, 0, 0),
                        MidImage = "rbxassetid://86870199131153",
                        ClipsDescendants = true,
                        ScrollBarThickness = 2,
                        Size = UDim2.new(1, 0, 1, -30),
                        Selectable = false,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 0, 0, 30),
                        BottomImage = "rbxassetid://86870199131153",
                        TopImage = "rbxassetid://86870199131153"
                    })

                    Library:Create("UIPadding", {
                        Name = "\0",
                        Parent = SettingsItems["Content"].Instance,
                        PaddingTop = UDim.new(0, 5),
                        PaddingBottom = UDim.new(0, 5),
                        PaddingRight = UDim.new(0, 10),
                        PaddingLeft = UDim.new(0, 10)
                    })

                    Library:Create("UIListLayout", {
                        Name = "\0",
                        Parent = SettingsItems["Content"].Instance,
                        Padding = UDim.new(0, 5),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    })

                    SettingsItems["SettingsButton"] = Library:Create("ImageButton", {
                        Name = "\0",
                        Parent = SettingsItems["ToggleSettings"].Instance,
                        ImageColor3 = Library.Theme["Text"],
                        AutoButtonColor = false,
                        Image = "rbxassetid://124244905334583",
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 10, 0, 10),
                        Size = UDim2.new(0, 12, 0, 12),
                        BorderSizePixel = 0
                    }):AddToTheme({ ImageColor3 = 'Text' })

                    Settingss.Items = SettingsItems
                end

                local Debounce = false
                local RenderStepped
                local SettingsHolder = SettingsItems["ToggleSettings"].Instance
                local SettingsButton = Items["SettingsButton"].Instance

                Settingss.AttachedButton = SettingsButton
                Settingss.CanUpdateNow = false
                Settingss.Frame = SettingsHolder

                function Settingss:SetOpen(Bool)
                    if Debounce then
                        return
                    end

                    Settingss.IsOpen = Bool

                    Debounce = true

                    if Settingss.IsOpen then
                        SettingsHolder.Position = UDim2.new(0, SettingsButton.AbsolutePosition.X, 0,
                            SettingsButton.AbsolutePosition.Y + SettingsButton.AbsoluteSize.Y + GuiInset)

                        SettingsHolder.Parent = Library.Holder.Instance
                        SettingsHolder.Visible = true
                        SettingsItems["ToggleSettings"]:Tween({
                            Position = UDim2.new(0, SettingsButton.AbsolutePosition
                                .X, 0, SettingsButton.AbsolutePosition.Y + SettingsButton.AbsoluteSize.Y + 10 + GuiInset)
                        })

                        SettingsItems["ToggleSettings"]:FadeDescendants(true, function()
                            Debounce = false
                            Settingss.CanUpdateNow = true
                        end)

                        for Index, Value in Library.OpenFrames do
                            Value:SetOpen(false)
                        end

                        Library.OpenFrames[Settingss] = Settingss
                    else
                        for _, OpenFrame in Library.OpenFrames do
                            if OpenFrame
                                and OpenFrame ~= Settingss
                                and OpenFrame.IsOpen
                                and OpenFrame.SetOpen
                                and OpenFrame.AttachedButton
                                and OpenFrame.AttachedButton:IsDescendantOf(SettingsHolder)
                            then
                                OpenFrame:SetOpen(false)
                            end
                        end

                        for _, OpenFrame in Library.OpenFrames do
                            if OpenFrame and OpenFrame ~= Settingss and OpenFrame.IsOpen and OpenFrame.SetOpen then
                                OpenFrame:SetOpen(false)
                            end
                        end

                        SettingsItems["ToggleSettings"]:Tween({
                            Position = UDim2.new(0, SettingsButton.AbsolutePosition
                                .X, 0, SettingsButton.AbsolutePosition.Y + SettingsButton.AbsoluteSize.Y - 10 + GuiInset)
                        })
                        SettingsItems["ToggleSettings"]:FadeDescendants(false, function()
                            SettingsHolder.Parent = Library.UnusedHolder.Instance
                            Debounce = false
                            Settingss.CanUpdateNow = false
                        end)

                        if Library.OpenFrames[Settingss] then
                            Library.OpenFrames[Settingss] = nil
                        end

                        if RenderStepped then
                            RenderStepped:Disconnect()
                            RenderStepped = nil
                        end
                    end

                    local Descendants = SettingsHolder:GetDescendants()
                    table.insert(Descendants, SettingsHolder)

                    for Index, Value in Descendants do
                        if Value.ClassName:find("UI") then
                            continue
                        end

                        Value.ZIndex = Settingss.IsOpen and 2 or 1
                    end
                end

                Items["SettingsButton"]:Connect("MouseButton1Down", function()
                    Settingss:SetOpen(not Settingss.IsOpen)
                end)

                Library:Connect(UserInputService.InputBegan, function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        if Settingss.IsOpen then
                            if SettingsItems["ToggleSettings"]:IsMouseOverFrame() then
                                return
                            end

                            for _, OpenFrame in Library.OpenFrames do
                                if OpenFrame
                                    and OpenFrame ~= Settingss
                                    and OpenFrame.IsOpen
                                    and OpenFrame.Frame
                                    and OpenFrame.Frame:IsMouseOverFrame()
                                then
                                    return
                                end
                            end

                            Settingss:SetOpen(false)
                        end
                    end
                end)

                return setmetatable(Settingss, Library)
            end

            function Toggle:Colorpicker(Data)
                Data = Data or {}

                local Colorpicker = {
                    Flag = Data.Flag or Data.flag or (Data.Name or Data.name or Toggle.Name),
                    Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                    Callback = Data.Callback or Data.callback or function() end,
                    Alpha = Data.Alpha or Data.alpha or 0,

                    Window = Toggle.Window,
                    Page = Toggle.Page,
                    Section = Toggle.Section,
                }

                local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
                    Parent = Items["SubElements"],
                    Page = Colorpicker.Page,
                    Section = Colorpicker.Section,
                    Flag = Colorpicker.Flag,
                    Default = Colorpicker.Default,
                    Callback = Colorpicker.Callback,
                    Alpha = Colorpicker.Alpha
                })

                return NewColorpicker
            end

            function Toggle:Keybind(Data)
                Data = Data or {}

                local Keybind = {
                    Name = Data.Name or Data.name or Toggle.Name,
                    Flag = Data.Flag or Data.flag or (Data.Name or Data.name or Toggle.Name),
                    Default = Data.Default or Data.default,
                    Callback = Data.Callback or Data.callback or function() end,
                    Mode = Data.Mode or Data.mode or "Toggle",

                    Window = Toggle.Window,
                    Page = Toggle.Page,
                    Section = Toggle.Section,
                }

                local NewKeybind, KeybindItems = Library:CreateKeybind({
                    Parent = Items["SubElements"],
                    Name = Keybind.Name,
                    Page = Keybind.Page,
                    Section = Keybind.Section,
                    Flag = Keybind.Flag,
                    Default = Keybind.Default,
                    Mode = Keybind.Mode,
                    Callback = Keybind.Callback
                })

                return NewKeybind
            end

            Items["Toggle"]:Connect("MouseButton1Down", function()
                Toggle:Set(not Toggle.Value)
            end)

            Toggle:Set(Toggle.Default)

            SetFlags[Toggle.Flag] = function(Value)
                Toggle:Set(Value)
            end

            return setmetatable(Toggle, Library)
        end

        Library.Button = function(Self, Params)
            Params = Params or {}

            local Button = {
                Name = Params.Name or Params.name or "Button",
                Callback = Params.Callback or Params.callback or function() end,
                Tooltip = Params.Tooltip or Params.tooltip or nil,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,
                Items = {}
            }

            local Items = {}
            do
                Items["Button"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Button.Section.Items["Content"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2.new(1, 0, 0, 18),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({ BackgroundColor3 = 'Element' })

                Items["Button"]:Tooltip(Button.Tooltip)

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Button"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = 'Border' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Button"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = 'Outline' })

                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Button"].Instance,
                    Rotation = -90,
                    Color = ColorSequence.new {
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(172, 172, 172))
                    }
                })

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Button"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Button.Name,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Size = UDim2.new(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, -1),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({ TextColor3 = 'Text' })

                Items["Button"]:OnHover(function()
                    Items["Button"]:Tween({ BackgroundColor3 = Library.Theme["Hovered Element"] })
                end, function()
                    Items["Button"]:Tween({ BackgroundColor3 = Library.Theme["Element"] })
                end)

                Button.Items = Items
            end

            function Button:Press()
                Items["Button"]:ChangeItemTheme({ BackgroundColor3 = "Accent" })
                Items["Button"]:Tween({ BackgroundColor3 = Library.Theme.Accent })
                task.wait(0.1)
                Items["Button"]:ChangeItemTheme({ BackgroundColor3 = "Element" })
                Items["Button"]:Tween({ BackgroundColor3 = Library.Theme.Element })

                Library:SafeCall(Button.Callback)
            end

            function Button:SetVisibility(Bool)
                Items["Button"].Instance.Visible = Bool
            end

            function Button:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            Items["Button"]:Connect("MouseButton1Down", function()
                Button:Press()
            end)

            return setmetatable(Button, Library)
        end

        Library.Slider = function(Self, Params)
            Params = Params or {}

            local Slider = {
                Name = Params.Name or Params.name or "Slider",
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or 0,
                Min = Params.Min or Params.min or 0,
                Tooltip = Params.Tooltip or Params.tooltip or nil,
                Max = Params.Max or Params.max or 100,
                Callback = Params.Callback or Params.callback or function() end,
                Decimals = Params.Decimals or Params.decimals or 0,
                Suffix = Params.Suffix or Params.suffix or "",

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Value = 0,
                Sliding = false,
                Items = {}
            }

            local Items = {}
            do
                Items["Slider"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Slider.Section.Items["Content"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 25),
                    BorderSizePixel = 0
                })

                Items["Slider"]:Tooltip(Slider.Tooltip)

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Slider"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Slider.Name,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 0, 12),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({ TextColor3 = 'Text' })

                Items["RealSlider"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Slider"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, 6),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({ BackgroundColor3 = 'Element' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["RealSlider"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"]
                }):AddToTheme({ Color = 'Border' })

                Items["Accent"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["RealSlider"].Instance,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({ BackgroundColor3 = 'Accent' })

                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Accent"].Instance,
                    Rotation = -90,
                    Color = ColorSequence.new {
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(172, 172, 172))
                    }
                })

                Items["Value"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Accent"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = "100%",
                    AnchorPoint = Vector2.new(1, 0),
                    Size = UDim2.new(0, 0, 0, 12),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({ TextColor3 = 'Text' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Value"].Instance,
                    LineJoinMode = Enum.LineJoinMode.Miter
                })

                Items["RealSlider"]:OnHover(function()
                    Items["RealSlider"]:Tween({ BackgroundColor3 = Library.Theme["Hovered Element"] })
                end, function()
                    Items["RealSlider"]:Tween({ BackgroundColor3 = Library.Theme["Element"] })
                end)

                Slider.Items = Items
            end

            function Slider:Set(Value)
                Slider.Value = Library:Round(math.clamp(Value, Slider.Min, Slider.Max), Slider.Decimals)

                Items["Accent"]:Tween(
                    { Size = UDim2.new((Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 1, 0) },
                    TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Items["Value"].Instance.Text = string.format("%s%s", Slider.Value, Slider.Suffix)

                Flags[Slider.Flag] = Slider.Value
                Library:SafeCall(Slider.Callback, Slider.Value)
            end

            function Slider:SetVisibility(Bool)
                Items["Slider"].Instance.Visible = Bool
            end

            function Slider:GetSize(Input)
                local SizeX = (Input.Position.X - Items["RealSlider"].Instance.AbsolutePosition.X) /
                    Items["RealSlider"].Instance.AbsoluteSize.X
                local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

                return Value
            end

            function Slider:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            local InputChanged

            Items["RealSlider"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Slider.Sliding = true

                    local Value = Slider:GetSize(Input)

                    Slider:Set(Value)

                    if InputChanged then
                        return
                    end

                    InputChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Slider.Sliding = false

                            InputChanged:Disconnect()
                            InputChanged = nil
                        end
                    end)
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Slider.Sliding then
                        local Value = Slider:GetSize(Input)

                        Slider:Set(Value)
                    end
                end
            end)

            Slider:Set(Slider.Default)

            SetFlags[Slider.Flag] = function(Value)
                Slider:Set(Value)
            end

            return setmetatable(Slider, Library)
        end

        Library.Dropdown = function(Self, Params)
            Params = Params or {}

            local Dropdown = {
                Name = Params.Name or Params.name or "Dropdown",
                OptionItems = Params.Items or Params.items or {},
                Tooltip = Params.Tooltip or Params.tooltip or nil,
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or "",
                Callback = Params.Callback or Params.callback or function() end,
                Multi = Params.Multi or Params.multi or false,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Value = {},
                Options = {},
                IsOpen = false,
                Items = {}
            }

            local Parent

            if Params.Parent then
                Parent = Params.Parent
            else
                Parent = Dropdown.Section.Items["Content"]
            end

            local Items = {}
            do
                Items["Dropdown"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Parent.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 40),
                    BorderSizePixel = 0
                })

                Items["Dropdown"]:Tooltip(Dropdown.Tooltip)

                Items["RealDropdown"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Dropdown"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, 20),
                    ClipsDescendants = true,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({ BackgroundColor3 = 'Element' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["RealDropdown"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = 'Border' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["RealDropdown"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = 'Outline' })

                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["RealDropdown"].Instance,
                    Rotation = -90,
                    Color = ColorSequence.new {
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(172, 172, 172))
                    }
                })

                Items["Value"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["RealDropdown"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = "...",
                    AnchorPoint = Vector2.new(0, 0.5),
                    Size = UDim2.new(1, -24, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 8, 0.5, -1),
                    BorderSizePixel = 0,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd
                }):AddToTheme({ TextColor3 = 'Text' })

                Items["Icon"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["RealDropdown"].Instance,
                    ImageColor3 = Library.Theme["Text"],
                    AnchorPoint = Vector2.new(1, 0.5),
                    Image = "rbxassetid://88550711858254",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -4, 0.5, 0),
                    Size = UDim2.new(0, 14, 0, 14),
                    BorderSizePixel = 0
                }):AddToTheme({ ImageColor3 = 'Text' })

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Dropdown"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Dropdown.Name,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 0, 12),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({ TextColor3 = 'Text' })

                Items["OptionHolder"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Library.UnusedHolder.Instance,
                    Visible = false,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2.new(0, 210, 0, 50),
                    Position = UDim2.new(0, 1056, 0, 521),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({ BackgroundColor3 = 'Background' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["OptionHolder"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = 'Outline' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["OptionHolder"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = 'Border' })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["OptionHolder"].Instance,
                    Padding = UDim.new(0, 3),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["OptionHolder"].Instance,
                    PaddingTop = UDim.new(0, 4),
                    PaddingLeft = UDim.new(0, 8),
                    PaddingBottom = UDim.new(0, 6)
                })

                Items["RealDropdown"]:OnHover(function()
                    Items["RealDropdown"]:Tween({ BackgroundColor3 = Library.Theme["Hovered Element"] })
                end, function()
                    Items["RealDropdown"]:Tween({ BackgroundColor3 = Library.Theme["Element"] })
                end)

                Dropdown.Items = Items
            end

            function Dropdown:Set(Value)
                if Dropdown.Multi then
                    if type(Value) ~= "table" then
                        return
                    end

                    Dropdown.Value = Value

                    for Index, Value in Value do
                        local OptionData = Dropdown.Options[Value]

                        if not OptionData then
                            continue
                        end

                        OptionData.IsSelected = true
                        OptionData:ToggleState("Active")
                    end

                    Flags[Dropdown.Flag] = Value
                    Items["Value"].Instance.Text = table.concat(Value, ", ")
                else
                    if not Dropdown.Options[Value] then
                        return
                    end

                    local OptionData = Dropdown.Options[Value]

                    Dropdown.Value = Value

                    for Index, Value in Dropdown.Options do
                        if Value ~= OptionData then
                            Value.IsSelected = false
                            Value:ToggleState("Inactive")
                        else
                            Value.Selected = true
                            Value:ToggleState("Active")
                        end
                    end

                    Flags[Dropdown.Flag] = Value
                    Items["Value"].Instance.Text = Value
                end

                Library:SafeCall(Dropdown.Callback, Dropdown.Value)
            end

            function Dropdown:Add(Value)
                local OptionButton = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["OptionHolder"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Value,
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({ TextColor3 = 'Text' })

                local OptionData = {
                    Button = OptionButton,
                    Name = Value,
                    IsSelected = false
                }

                function OptionData:ToggleState(Value)
                    if Value == "Active" then
                        OptionData.Button:ChangeItemTheme({ TextColor3 = "Accent" })
                        OptionData.Button:Tween({ TextColor3 = Library.Theme.Accent })
                    else
                        OptionData.Button:ChangeItemTheme({ TextColor3 = "Text" })
                        OptionData.Button:Tween({ TextColor3 = Library.Theme.Text })
                    end
                end

                function OptionData:Set()
                    OptionData.IsSelected = not OptionData.IsSelected

                    if Dropdown.Multi then
                        local Index = table.find(Dropdown.Value, OptionData.Name)

                        if Index then
                            table.remove(Dropdown.Value, Index)
                        else
                            table.insert(Dropdown.Value, OptionData.Name)
                        end

                        OptionData:ToggleState(Index and "Inactive" or "Active")

                        Flags[Dropdown.Flag] = Dropdown.Value

                        local TextFormat = #Dropdown.Value > 0 and table.concat(Dropdown.Value, ", ") or ""
                        Items["Value"].Instance.Text = TextFormat
                    else
                        if OptionData.IsSelected then
                            Dropdown.Value = OptionData.Name
                            Flags[Dropdown.Flag] = OptionData.Name

                            OptionData.IsSelected = true
                            OptionData:ToggleState("Active")

                            for Index, Value in Dropdown.Options do
                                if Value ~= OptionData then
                                    Value.IsSelected = false
                                    Value:ToggleState("Inactive")
                                end
                            end

                            Items["Value"].Instance.Text = OptionData.Name
                        else
                            Dropdown.Value = nil
                            Flags[Dropdown.Flag] = nil

                            OptionData.IsSelected = false
                            OptionData:ToggleState("Inactive")

                            Items["Value"].Instance.Text = "..."
                        end
                    end

                    Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                end

                OptionData.Button:Connect("MouseButton1Down", function()
                    OptionData:Set()
                end)

                Dropdown.Options[OptionData.Name] = OptionData
                return OptionData
            end

            function Dropdown:Remove(Option)
                if Dropdown.Options[Option] then
                    Dropdown.Options[Option].Button.Instance:Destroy()
                    Dropdown.Options[Option] = nil
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

            function Dropdown:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            function Dropdown:SetVisibility(Bool)
                Items["Dropdown"].Instance.Visible = Bool
            end

            local Debounce = false
            local RenderStepped
            local OptionHolder = Items["OptionHolder"].Instance
            local RealDropdown = Items["RealDropdown"].Instance

            Dropdown.AttachedButton = RealDropdown
            Dropdown.CanUpdateNow = false
            Dropdown.Frame = OptionHolder

            function Dropdown:SetOpen(Bool)
                if Debounce then
                    return
                end

                Dropdown.IsOpen = Bool

                Debounce = true

                if Dropdown.IsOpen then
                    Items["Icon"]:Tween({ Rotation = -90 })
                    OptionHolder.Position = UDim2.new(0, RealDropdown.AbsolutePosition.X, 0,
                        RealDropdown.AbsolutePosition.Y + RealDropdown.AbsoluteSize.Y + GuiInset)
                    OptionHolder.Size = UDim2.new(0, RealDropdown.AbsoluteSize.X, 0, Dropdown.MaxSize)

                    OptionHolder.Parent = Library.Holder.Instance
                    OptionHolder.Visible = true
                    Items["OptionHolder"]:Tween({
                        Position = UDim2.new(0, RealDropdown.AbsolutePosition.X, 0,
                            RealDropdown.AbsolutePosition.Y + RealDropdown.AbsoluteSize.Y + 10 + GuiInset)
                    })

                    Items["OptionHolder"]:FadeDescendants(true, function()
                        Debounce = false
                        Dropdown.CanUpdateNow = true
                    end)

                    for Index, Value in Library.OpenFrames do
                        if not Params.Parent and not Dropdown.Section.IsSettings then
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Dropdown] = Dropdown
                else
                    Items["Icon"]:Tween({ Rotation = 0 })
                    Items["OptionHolder"]:Tween({
                        Position = UDim2.new(0, RealDropdown.AbsolutePosition.X, 0,
                            RealDropdown.AbsolutePosition.Y + RealDropdown.AbsoluteSize.Y - 10 + GuiInset)
                    })
                    Items["OptionHolder"]:FadeDescendants(false, function()
                        OptionHolder.Parent = Library.UnusedHolder.Instance
                        Debounce = false
                        Dropdown.CanUpdateNow = false
                    end)

                    if Library.OpenFrames[Dropdown] then
                        Library.OpenFrames[Dropdown] = nil
                    end

                    if RenderStepped then
                        RenderStepped:Disconnect()
                        RenderStepped = nil
                    end
                end

                local Descendants = OptionHolder:GetDescendants()
                table.insert(Descendants, OptionHolder)

                for Index, Value in Descendants do
                    if Value.ClassName:find("UI") then
                        continue
                    end

                    if not Params.Parent then
                        Value.ZIndex = Dropdown.IsOpen and 3 or 1
                    else
                        Value.ZIndex = Dropdown.IsOpen and 6 or 1
                    end
                end
            end

            Items["RealDropdown"]:Connect("MouseButton1Down", function()
                Dropdown:SetOpen(not Dropdown.IsOpen)
            end)

            Library:Connect(UserInputService.InputBegan, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    if Dropdown.IsOpen then
                        if Items["OptionHolder"]:IsMouseOverFrame() then
                            return
                        end

                        Dropdown:SetOpen(false)
                    end
                end
            end)

            Items["RealDropdown"]:Connect("Changed", function(Property)
                if Property == "AbsolutePosition" and Dropdown.IsOpen then
                    local Section = Dropdown.Section
                    local SectionItem = Section and Section.Items and Section.Items["Section"]
                    local SectionInstance = SectionItem and SectionItem.Instance
                    local SectionParent = SectionInstance and SectionInstance.Parent

                    if SectionParent then
                        Dropdown.IsOpen = not Items["OptionHolder"]:IsClipped(SectionParent)
                    else
                        Dropdown.IsOpen = false
                    end
                    Items["OptionHolder"].Instance.Visible = Dropdown.IsOpen
                end
            end)

            for Index, Value in Dropdown.OptionItems do
                Dropdown:Add(Value)
            end

            Dropdown:Set(Dropdown.Default)

            SetFlags[Dropdown.Flag] = function(Value)
                Dropdown:Set(Value)
            end

            return setmetatable(Dropdown, Library)
        end

        Library.Label = function(Self, Params)
            Params = Params or {}

            local Label = {
                Name = Params.Name or Params.name or "Label",
                Tooltip = Params.Tooltip or Params.tooltip or nil,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Items = {}
            }

            local Items = {}
            do
                Items["Label"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Label.Section.Items["Content"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 12),
                    BorderSizePixel = 0
                })

                Items["Label"]:Tooltip(Label.Tooltip)

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Label"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Label.Name,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Size = UDim2.new(0, 0, 0, 12),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({ TextColor3 = 'Text' })

                Items["SubElements"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Label"].Instance,
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 0, 0, 0),
                    Size = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["SubElements"].Instance,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    Padding = UDim.new(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Label.Items = Items
            end

            function Label:SetVisibility(Bool)
                Items["Label"].Instance.Visible = Bool
            end

            function Label:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            function Label:Colorpicker(Data)
                Data = Data or {}

                local Colorpicker = {
                    Flag = Data.Flag or Data.flag or (Data.Name or Data.name or Label.Name),
                    Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                    Callback = Data.Callback or Data.callback or function() end,
                    Alpha = Data.Alpha or Data.alpha or 0,

                    Window = Label.Window,
                    Page = Label.Page,
                    Section = Label.Section,
                }

                local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
                    Parent = Items["SubElements"],
                    Page = Colorpicker.Page,
                    Section = Colorpicker.Section,
                    Flag = Colorpicker.Flag,
                    Default = Colorpicker.Default,
                    Callback = Colorpicker.Callback,
                    Alpha = Colorpicker.Alpha
                })

                return NewColorpicker
            end

            function Label:Keybind(Data)
                Data = Data or {}

                local Keybind = {
                    Name = Data.Name or Data.name or Label.Name,
                    Flag = Data.Flag or Data.flag or (Data.Name or Data.name or Label.Name),
                    Default = Data.Default or Data.default,
                    Callback = Data.Callback or Data.callback or function() end,
                    Mode = Data.Mode or Data.mode or "Toggle",

                    Window = Label.Window,
                    Page = Label.Page,
                    Section = Label.Section,
                }

                local NewKeybind, KeybindItems = Library:CreateKeybind({
                    Parent = Items["SubElements"],
                    Name = Keybind.Name,
                    Page = Keybind.Page,
                    Section = Keybind.Section,
                    Flag = Keybind.Flag,
                    Default = Keybind.Default,
                    Mode = Keybind.Mode,
                    Callback = Keybind.Callback
                })

                return NewKeybind
            end

            Label:SetText(Label.Name)

            return setmetatable(Label, Library)
        end

        Library.Textbox = function(Self, Params)
            Params = Params or {}

            local Textbox = {
                Name = Params.Name or Params.name or "Textbox",
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or "",
                Callback = Params.Callback or Params.callback or function() end,
                Tooltip = Params.Tooltip or Params.tooltip or nil,
                Finished = Params.Finished or Params.finished or false,
                Numeric = Params.Numeric or Params.numeric or false,
                Placeholder = Params.Placeholder or Params.placeholder or "...",

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,
                Value = "",

                Items = {},
            }

            local Items = {}
            do
                Items["Textbox"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Textbox.Section.Items["Content"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 20),
                    BorderSizePixel = 0
                })

                Items["Textbox"]:Tooltip(Textbox.Tooltip)

                Items["Background"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Textbox"].Instance,
                    ClipsDescendants = true,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({ BackgroundColor3 = 'Element' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = 'Outline' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = 'Border' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, -1)
                }):AddToTheme({ Color = 'Border' })

                Items["Input"] = Library:Create("TextBox", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Background"].Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    PlaceholderColor3 = Library.Theme["Inactive Text"],
                    PlaceholderText = Textbox.Placeholder,
                    Size = UDim2.new(1, -16, 0, 15),
                    TextColor3 = Library.Theme["Text"],
                    Text = "",
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 8, 0.5, -1),
                    ClearTextOnFocus = false,
                    BorderSizePixel = 0
                }):AddToTheme({ TextColor3 = 'Text' })

                Textbox.Items = Items
            end

            function Textbox:SetVisibility(Bool)
                Items["Textbox"].Instance.Visible = Bool
            end

            function Textbox:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            function Textbox:Set(Value)
                if Textbox.Numeric then
                    if (not tonumber(Value)) and string.len(tostring(Value)) > 0 then
                        Value = Textbox.Value
                    end
                end

                Textbox.Value = Value
                Items["Input"].Instance.Text = Value
                Flags[Textbox.Flag] = Value

                Library:SafeCall(Textbox.Callback, Value)
            end

            if Textbox.Finished then
                Items["Input"]:Connect("FocusLost", function(PressedEnterQuestionMark)
                    if PressedEnterQuestionMark then
                        Textbox:Set(Items["Input"].Instance.Text)
                    end
                end)
            else
                Library:Connect(Items["Input"].Instance:GetPropertyChangedSignal("Text"), function()
                    Textbox:Set(Items["Input"].Instance.Text)
                end)
            end

            Textbox:Set(Textbox.Default)

            SetFlags[Textbox.Flag] = function(Value)
                Textbox:Set(Value)
            end

            return setmetatable(Textbox, Library)
        end

        Library.Searchbox = function(Self, Params) -- just the dropdown func with diff items
            Params = Params or {}

            local Dropdown = {
                OptionItems = Params.Items or Params.items or {},
                Tooltip = Params.Tooltip or Params.tooltip or nil,
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or "",
                Callback = Params.Callback or Params.callback or function() end,
                Multi = Params.Multi or Params.multi or false,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Value = {},
                Options = {},
                Items = {}
            }

            local Items = {}
            do
                Items["Searchbox"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Dropdown.Section.Items["Content"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 173),
                    BorderSizePixel = 0
                })

                Items["Search"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Searchbox"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 20),
                    BorderSizePixel = 0
                })

                Items["SearchBackground"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Search"].Instance,
                    ClipsDescendants = true,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({ BackgroundColor3 = 'Element' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["SearchBackground"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = 'Outline' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["SearchBackground"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = 'Border' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["SearchBackground"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, -1)
                }):AddToTheme({ Color = 'Border' })

                Items["Input"] = Library:Create("TextBox", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["SearchBackground"].Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    PlaceholderColor3 = Library.Theme["Inactive Text"],
                    PlaceholderText = "Search",
                    Size = UDim2.new(1, -16, 0, 15),
                    TextColor3 = Library.Theme["Text"],
                    Text = "",
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 8, 0.5, 0),
                    ClearTextOnFocus = false,
                    BorderSizePixel = 0
                }):AddToTheme({ TextColor3 = 'Text', PlaceholderColor3 = 'Inactive Text' })

                Items["RealSearchbox"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Searchbox"].Instance,
                    Position = UDim2.new(0, 0, 0, 25),
                    Size = UDim2.new(1, 0, 1, -25),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({ BackgroundColor3 = 'Element' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["RealSearchbox"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = 'Border' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["RealSearchbox"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = 'Outline' })

                Items["Holder"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["RealSearchbox"].Instance,
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    ScrollBarImageColor3 = Library.Theme["Accent"],
                    MidImage = "rbxassetid://129030709932941",
                    ScrollBarThickness = 1,
                    Size = UDim2.new(1, -8, 1, -8),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 4, 0, 4),
                    BottomImage = "rbxassetid://129030709932941",
                    TopImage = "rbxassetid://129030709932941"
                }):AddToTheme({ ScrollBarImageColor3 = 'Accent' })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Holder"].Instance,
                    Padding = UDim.new(0, 3),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Holder"].Instance,
                    PaddingBottom = UDim.new(0, 6),
                    PaddingLeft = UDim.new(0, 6)
                })

                Dropdown.Items = Items
            end

            function Dropdown:Set(Value)
                if Dropdown.Multi then
                    if type(Value) ~= "table" then
                        return
                    end

                    Dropdown.Value = Value

                    for Index, Value in Value do
                        local OptionData = Dropdown.Options[Value]

                        if not OptionData then
                            continue
                        end

                        OptionData.IsSelected = true
                        OptionData:ToggleState("Active")
                    end

                    Flags[Dropdown.Flag] = Value
                else
                    if not Dropdown.Options[Value] then
                        return
                    end

                    local OptionData = Dropdown.Options[Value]

                    Dropdown.Value = Value

                    for Index, Value in Dropdown.Options do
                        if Value ~= OptionData then
                            Value.IsSelected = false
                            Value:ToggleState("Inactive")
                        else
                            Value.Selected = true
                            Value:ToggleState("Active")
                        end
                    end

                    Flags[Dropdown.Flag] = Value
                end

                Library:SafeCall(Dropdown.Callback, Dropdown.Value)
            end

            function Dropdown:Add(Value)
                local OptionButton = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Holder"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Value,
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({ TextColor3 = 'Text' })

                local OptionData = {
                    Button = OptionButton,
                    Name = Value,
                    IsSelected = false
                }

                function OptionData:ToggleState(Value)
                    if Value == "Active" then
                        OptionData.Button:ChangeItemTheme({ TextColor3 = "Accent" })
                        OptionData.Button:Tween({ TextColor3 = Library.Theme.Accent })
                    else
                        OptionData.Button:ChangeItemTheme({ TextColor3 = "Text" })
                        OptionData.Button:Tween({ TextColor3 = Library.Theme.Text })
                    end
                end

                function OptionData:Set()
                    OptionData.IsSelected = not OptionData.IsSelected

                    if Dropdown.Multi then
                        local Index = table.find(Dropdown.Value, OptionData.Name)

                        if Index then
                            table.remove(Dropdown.Value, Index)
                        else
                            table.insert(Dropdown.Value, OptionData.Name)
                        end

                        OptionData:ToggleState(Index and "Inactive" or "Active")

                        Flags[Dropdown.Flag] = Dropdown.Value
                    else
                        if OptionData.IsSelected then
                            Dropdown.Value = OptionData.Name
                            Flags[Dropdown.Flag] = OptionData.Name

                            OptionData.IsSelected = true
                            OptionData:ToggleState("Active")

                            for Index, Value in Dropdown.Options do
                                if Value ~= OptionData then
                                    Value.IsSelected = false
                                    Value:ToggleState("Inactive")
                                end
                            end
                        else
                            Dropdown.Value = nil
                            Flags[Dropdown.Flag] = nil

                            OptionData.IsSelected = false
                            OptionData:ToggleState("Inactive")
                        end
                    end

                    Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                end

                OptionData.Button:Connect("MouseButton1Down", function()
                    OptionData:Set()
                end)

                Dropdown.Options[OptionData.Name] = OptionData
                return OptionData
            end

            function Dropdown:Remove(Option)
                if Dropdown.Options[Option] then
                    Dropdown.Options[Option].Button.Instance:Destroy()
                    Dropdown.Options[Option] = nil
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

            function Dropdown:SetVisibility(Bool)
                Items["Searchbox"].Instance.Visible = Bool
            end

            Library:Connect(Items["Input"].Instance:GetPropertyChangedSignal("Text"), function()
                for Index, Value in Dropdown.Options do
                    if string.lower(Value.Name):find(string.lower(Items["Input"].Instance.Text)) then
                        Value.Button.Instance.Visible = true
                    else
                        Value.Button.Instance.Visible = false
                    end
                end
            end)

            for Index, Value in Dropdown.OptionItems do
                Dropdown:Add(Value)
            end

            Dropdown:Set(Dropdown.Default)

            SetFlags[Dropdown.Flag] = function(Value)
                Dropdown:Set(Value)
            end

            return setmetatable(Dropdown, Library)
        end

        Library.OpenConfirmDialog = function(Self, Config)
            Config = Config or {}

            local Title = tostring(Config.Title or "Confirm")
            local Message = tostring(Config.Message or "Are you sure you want to continue?")
            local ConfirmText = tostring(Config.ConfirmText or "Confirm")
            local CancelText = tostring(Config.CancelText or "Cancel")
            local AccentColor = Config.AccentColor or Color3.fromRGB(255, 95, 95)
            local Callback = Config.Callback or function() end

            if Self.ActiveConfirmDialog and Self.ActiveConfirmDialog.Close then
                Self.ActiveConfirmDialog:Close(false, true)
            end

            local Items = {}
            local Connections = {}
            local IsClosed = false

            local function AddConnection(Connection)
                table.insert(Connections, Connection)
                return Connection
            end

            local function DisconnectConnections()
                for _, Connection in Connections do
                    if Connection and Connection.Connected then
                        Connection:Disconnect()
                    end
                end
            end

            local function CreateModalButton(Name, Position, Width, TextColor, BackgroundTheme)
                local ButtonItems = {}

                ButtonItems["Button"] = Library:Create("TextButton", {
                    Name = "\0",
                    Parent = Items["Panel"].Instance,
                    Position = Position,
                    Size = UDim2.new(Width, 0, 0, 18),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme[BackgroundTheme]
                }):AddToTheme({ BackgroundColor3 = BackgroundTheme })

                ButtonItems["OuterStroke"] = Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = ButtonItems["Button"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = "Border" })

                ButtonItems["InnerStroke"] = Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = ButtonItems["Button"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = "Outline" })

                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = ButtonItems["Button"].Instance,
                    Rotation = -90,
                    Color = ColorSequence.new {
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(172, 172, 172))
                    }
                })

                ButtonItems["Label"] = Library:Create("TextLabel", {
                    Name = "\0",
                    Parent = ButtonItems["Button"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, -1),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Size = UDim2.new(0, 0, 0, 15),
                    AutomaticSize = Enum.AutomaticSize.X,
                    BorderSizePixel = 0,
                    Text = Name,
                    TextColor3 = TextColor,
                    FontFace = Library.Font,
                    TextSize = Library.FontSize
                })

                ButtonItems["Button"]:OnHover(function()
                    ButtonItems["Button"]:Tween({ BackgroundColor3 = Library.Theme["Hovered Element"] })
                end, function()
                    ButtonItems["Button"]:Tween({ BackgroundColor3 = Library.Theme[BackgroundTheme] })
                end)

                return ButtonItems
            end

            do
                Items["Overlay"] = Library:Create("TextButton", {
                    Name = "\0",
                    Parent = Self.Holder.Instance,
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = Color3.new(0, 0, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                    AutoButtonColor = false,
                    BorderSizePixel = 0,
                    ZIndex = 9000
                })

                Items["PanelOutline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Overlay"].Instance,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 10),
                    Size = UDim2.new(0, 264, 0, 124),
                    BackgroundColor3 = Library.Theme["Outline"],
                    BorderSizePixel = 0,
                    ZIndex = 9001
                }):AddToTheme({ BackgroundColor3 = "Outline" })

                Items["PanelScale"] = Library:Create("UIScale", {
                    Name = "\0",
                    Parent = Items["PanelOutline"].Instance,
                    Scale = 0.94
                })

                Items["Panel"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["PanelOutline"].Instance,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BackgroundColor3 = Library.Theme["Section"],
                    BorderSizePixel = 0,
                    ZIndex = 9002
                }):AddToTheme({ BackgroundColor3 = "Section" })

                Items["AccentLine"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Panel"].Instance,
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = AccentColor,
                    ZIndex = 9003
                })

                Items["Title"] = Library:Create("TextLabel", {
                    Name = "\0",
                    Parent = Items["Panel"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 12, 0, 10),
                    Size = UDim2.new(1, -24, 0, 12),
                    BorderSizePixel = 0,
                    Text = Title,
                    TextColor3 = Library.Theme["Text"],
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 9003
                }):AddToTheme({ TextColor3 = "Text" })

                Items["Message"] = Library:Create("TextLabel", {
                    Name = "\0",
                    Parent = Items["Panel"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 12, 0, 29),
                    Size = UDim2.new(1, -24, 0, 50),
                    BorderSizePixel = 0,
                    Text = Message,
                    TextColor3 = Library.Theme["Text"],
                    TextTransparency = 0.25,
                    TextWrapped = true,
                    TextYAlignment = Enum.TextYAlignment.Top,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    ZIndex = 9003
                }):AddToTheme({
                    TextColor3 = function()
                        return Library.Theme["Text"]:Lerp(Color3.new(0, 0, 0), 0.25)
                    end
                })

                Items["Hint"] = Library:Create("TextLabel", {
                    Name = "\0",
                    Parent = Items["Panel"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 12, 1, -49),
                    Size = UDim2.new(1, -24, 0, 10),
                    BorderSizePixel = 0,
                    Text = "Click off this window to cancel\nHit enter to confirm",
                    TextColor3 = Library.Theme["Text"],
                    TextTransparency = 0.45,
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 9003
                }):AddToTheme({
                    TextColor3 = function()
                        return Library.Theme["Text"]:Lerp(Color3.new(0, 0, 0), 0.45)
                    end
                })

                Items["CancelButton"] = CreateModalButton(CancelText, UDim2.new(0, 12, 1, -30), 0.45,
                    Library.Theme["Text"], "Element")
                Items["ConfirmButton"] = CreateModalButton(ConfirmText, UDim2.new(0.55, 0, 1, -30), 0.45,
                    AccentColor, "Element")
            end

            local FadeItems = {
                Items["Overlay"],
                Items["PanelOutline"],
                Items["Panel"],
                Items["AccentLine"],
                Items["Title"],
                Items["Message"],
                Items["Hint"],
                Items["CancelButton"]["OuterStroke"],
                Items["CancelButton"]["InnerStroke"],
                Items["CancelButton"]["Label"],
                Items["CancelButton"]["Button"],
                Items["ConfirmButton"]["OuterStroke"],
                Items["ConfirmButton"]["InnerStroke"],
                Items["ConfirmButton"]["Label"],
                Items["ConfirmButton"]["Button"]
            }

            for _, Item in FadeItems do
                if Item.Instance:IsA("Frame") then
                    Item.Instance.BackgroundTransparency = 1
                elseif Item.Instance:IsA("TextLabel") then
                    Item.Instance.TextTransparency = 1
                elseif Item.Instance:IsA("UIStroke") then
                    Item.Instance.Transparency = 1
                elseif Item.Instance:IsA("TextButton") then
                    Item.Instance.BackgroundTransparency = 1
                end
            end

            local OpenInfo = TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            local CloseInfo = TweenInfo.new(0.16, Enum.EasingStyle.Quint, Enum.EasingDirection.In)

            local Dialog = {}

            function Dialog:Close(Confirmed, SkipCallback)
                if IsClosed then
                    return
                end

                IsClosed = true
                Self.ActiveConfirmDialog = nil

                Items["Overlay"]:Tween({ BackgroundTransparency = 1 }, CloseInfo)
                Items["PanelOutline"]:Tween({ BackgroundTransparency = 1, Position = UDim2.new(0.5, 0, 0.5, 6) },
                    CloseInfo)
                Items["Panel"]:Tween({ BackgroundTransparency = 1 }, CloseInfo)
                Items["AccentLine"]:Tween({ BackgroundTransparency = 1 }, CloseInfo)
                Items["Title"]:Tween({ TextTransparency = 1 }, CloseInfo)
                Items["Message"]:Tween({ TextTransparency = 1 }, CloseInfo)
                Items["Hint"]:Tween({ TextTransparency = 1 }, CloseInfo)
                Items["CancelButton"]["Button"]:Tween({ BackgroundTransparency = 1 }, CloseInfo)
                Items["CancelButton"]["OuterStroke"]:Tween({ Transparency = 1 }, CloseInfo)
                Items["CancelButton"]["InnerStroke"]:Tween({ Transparency = 1 }, CloseInfo)
                Items["CancelButton"]["Label"]:Tween({ TextTransparency = 1 }, CloseInfo)
                Items["ConfirmButton"]["Button"]:Tween({ BackgroundTransparency = 1 }, CloseInfo)
                Items["ConfirmButton"]["OuterStroke"]:Tween({ Transparency = 1 }, CloseInfo)
                Items["ConfirmButton"]["InnerStroke"]:Tween({ Transparency = 1 }, CloseInfo)
                Items["ConfirmButton"]["Label"]:Tween({ TextTransparency = 1 }, CloseInfo)
                Items["PanelScale"]:Tween({ Scale = 0.97 }, CloseInfo)

                task.delay(CloseInfo.Time + 0.03, function()
                    DisconnectConnections()

                    if Items["Overlay"] and Items["Overlay"].Instance.Parent then
                        Items["Overlay"].Instance:Destroy()
                    end
                end)

                if not SkipCallback then
                    task.defer(function()
                        Library:SafeCall(Callback, Confirmed)
                    end)
                end
            end

            Self.ActiveConfirmDialog = Dialog

            Items["Overlay"]:Tween({ BackgroundTransparency = 0.35 }, OpenInfo)
            Items["PanelOutline"]:Tween({ BackgroundTransparency = 0, Position = UDim2.new(0.5, 0, 0.5, 0) }, OpenInfo)
            Items["Panel"]:Tween({ BackgroundTransparency = 0 }, OpenInfo)
            Items["AccentLine"]:Tween({ BackgroundTransparency = 0 }, OpenInfo)
            Items["Title"]:Tween({ TextTransparency = 0 }, OpenInfo)
            Items["Message"]:Tween({ TextTransparency = 0.25 }, OpenInfo)
            Items["Hint"]:Tween({ TextTransparency = 0.45 }, OpenInfo)
            Items["CancelButton"]["Button"]:Tween({ BackgroundTransparency = 0 }, OpenInfo)
            Items["CancelButton"]["OuterStroke"]:Tween({ Transparency = 0 }, OpenInfo)
            Items["CancelButton"]["InnerStroke"]:Tween({ Transparency = 0 }, OpenInfo)
            Items["CancelButton"]["Label"]:Tween({ TextTransparency = 0 }, OpenInfo)
            Items["ConfirmButton"]["Button"]:Tween({ BackgroundTransparency = 0 }, OpenInfo)
            Items["ConfirmButton"]["OuterStroke"]:Tween({ Transparency = 0 }, OpenInfo)
            Items["ConfirmButton"]["InnerStroke"]:Tween({ Transparency = 0 }, OpenInfo)
            Items["ConfirmButton"]["Label"]:Tween({ TextTransparency = 0 }, OpenInfo)
            Items["PanelScale"]:Tween({ Scale = 1 }, OpenInfo)

            AddConnection(Items["Overlay"].Instance.MouseButton1Click:Connect(function()
                Dialog:Close(false)
            end))

            AddConnection(Items["CancelButton"]["Button"].Instance.MouseButton1Click:Connect(function()
                Dialog:Close(false)
            end))

            AddConnection(Items["ConfirmButton"]["Button"].Instance.MouseButton1Click:Connect(function()
                Dialog:Close(true)
            end))

            AddConnection(UserInputService.InputBegan:Connect(function(Input, Processed)
                if Processed or IsClosed then
                    return
                end

                if Input.KeyCode == Enum.KeyCode.Escape then
                    Dialog:Close(false)
                elseif Input.KeyCode == Enum.KeyCode.Return or Input.KeyCode == Enum.KeyCode.KeypadEnter then
                    Dialog:Close(true)
                end
            end))

            return Dialog
        end

        Library.CreateSettingsPage = function(Self)
            local Page = Self:Page({ Name = "Settings", Icon = "rbxassetid://0" })

            local ConfigsSubPage = Page:SubPage({ Name = "Configs" })
            local OtherSubPage = Page:SubPage({ Name = "Other" })

            do
                local ConfigName
                local ConfigSelected
                local ConfigsFolder = Library.Directory .. Library.Folders.Configs .. "/"

                local ConfigsSection = ConfigsSubPage:Section({ Name = "Configs", Side = 1 })
                do
                    local ConfigName
                    local ConfigSelected
                    local ConfigsFolder = Library.Directory .. Library.Folders.Configs .. "/"

                    local ConfigsDropdown = ConfigsSection:Dropdown({
                        Name = "Configs",
                        Flag = "ConfigsDropdown",
                        Items = {},
                        Multi = false,
                        Callback = function(Value)
                            ConfigSelected = Value
                        end
                    })

                    ConfigsSection:Textbox({
                        Name = "Config name",
                        Flag = "ConfigName",
                        Placeholder = "Config name",
                        Callback = function(Value)
                            ConfigName = Value
                        end
                    })

                    ConfigsSection:Button({
                        Name = "Create",
                        Callback = function()
                            if ConfigName then
                                if ConfigName == "" then
                                    return
                                end

                                writefile(ConfigsFolder .. ConfigName .. ".json", Library:GetConfig())
                                Library:GetConfigsList(ConfigsDropdown)
                                Library:Notification("Succesfully created config", 3, Color3.fromRGB(0, 255, 0))
                            end
                        end
                    })

                    ConfigsSection:Button({
                        Name = "Delete",
                        Callback = function()
                            if ConfigSelected then
                                if isfile(ConfigsFolder .. ConfigSelected .. ".json") then
                                    local SelectedConfig = ConfigSelected

                                    Library:OpenConfirmDialog({
                                        Title = "Delete config",
                                        Message = string.format(
                                            'Delete "%s"? This permanently removes the file from your config folder.',
                                            SelectedConfig),
                                        ConfirmText = "Delete",
                                        CancelText = "Keep",
                                        AccentColor = Color3.fromRGB(255, 95, 95),
                                        Callback = function(Confirmed)
                                            if not Confirmed then
                                                return
                                            end

                                            if not isfile(ConfigsFolder .. SelectedConfig .. ".json") then
                                                Library:Notification("Config no longer exists", 3,
                                                    Color3.fromRGB(255, 0, 0))
                                                return
                                            end

                                            delfile(ConfigsFolder .. SelectedConfig .. ".json")
                                            ConfigSelected = nil
                                            Library:GetConfigsList(ConfigsDropdown)
                                            Library:Notification("Succesfully deleted config", 3,
                                                Color3.fromRGB(0, 255, 0))
                                        end
                                    })
                                end
                            end
                        end
                    })

                    ConfigsSection:Button({
                        Name = "Load",
                        Callback = function()
                            if ConfigSelected then
                                if isfile(ConfigsFolder .. ConfigSelected .. ".json") then
                                    local ConfigContent = readfile(ConfigsFolder .. ConfigSelected .. ".json")
                                    local Success, Error = Library:LoadConfig(ConfigContent)

                                    if Success then
                                        Library:Notification("Succesfully loaded config", 3, Color3.fromRGB(0, 255, 0))
                                    else
                                        Library:Notification("Failed to load config: \n" .. Error, 3,
                                            Color3.fromRGB(255, 0, 0))
                                    end
                                end
                            else
                                Library:Notification("No config selected", 3, Color3.fromRGB(255, 0, 0))
                            end
                        end
                    })

                    ConfigsSection:Button({
                        Name = "Save",
                        Callback = function()
                            if ConfigSelected then
                                if isfile(ConfigsFolder .. ConfigSelected .. ".json") then
                                    local Success, Error = pcall(function()
                                        writefile(ConfigsFolder .. ConfigSelected .. ".json", Library:GetConfig())
                                    end)

                                    if Success then
                                        Library:Notification("Succesfully saved config", 3, Color3.fromRGB(0, 255, 0))
                                    else
                                        Library:Notification("Failed to save config: \n" .. Error, 3,
                                            Color3.fromRGB(255, 0, 0))
                                    end
                                end
                            end
                        end
                    })

                    Library:GetConfigsList(ConfigsDropdown)
                end
            end

            do
                local ThemingSection = OtherSubPage:Section({ Name = "Theming", Side = 1 })
                do
                    for Index, Value in Library.Theme do
                        ThemingSection:Label({ Name = Index }):Colorpicker({
                            Flag = Index .. "Theme",
                            Default = Value,
                            Callback = function(Value)
                                Library.Theme[Index] = Value
                                Library:ChangeTheme(Index, Value)
                            end
                        })
                    end
                end

                local SettingsSection = OtherSubPage:Section({ Name = "Settings", Side = 2 })
                do
                    SettingsSection:Label({ Name = "UI Bind" }):Keybind({
                        Flag = "UIBind",
                        Mode = "Toggle",
                        Default = Enum.KeyCode.RightShift,
                        Callback = function(Value)
                            Library.MenuKeybind = Flags["UIBind"].Key
                        end
                    })

                    SettingsSection:Toggle({
                        Name = "Background Blur",
                        Flag = "UIBackgroundBlur",
                        Default = Library.BackgroundBlurEnabled,
                        Callback = function(Value)
                            Library:SetBackgroundBlurEnabled(Value)
                        end
                    })

                    SettingsSection:Toggle({
                        Name = "Background Snow",
                        Flag = "UIBackgroundSnow",
                        Default = Library.BackgroundSnowEnabled,
                        Callback = function(Value)
                            Library:SetBackgroundSnowEnabled(Value)
                        end
                    })

                    SettingsSection:Button({
                        Name = "Unload",
                        Callback = function()
                            Library:Exit()
                        end
                    })

                    SettingsSection:Slider({
                        Name = "Animation Speed",
                        Flag = "AnimationSpeed",
                        Default = Library.Animation.Time,
                        Min = 0,
                        Max = 1.5,
                        Decimals = .01,
                        Callback = function(Value)
                            Library.Animation.Time = Value
                        end
                    })
                end

                local WidgetsSection = OtherSubPage:Section({ Name = "Widgets", Side = 2 })
                do
                    for _, WidgetData in Library.SettingsWidgets do
                        local WidgetToggle = WidgetsSection:Toggle({
                            Name = WidgetData.Name,
                            Flag = WidgetData.Flag,
                            Default = WidgetData.Default,
                            Callback = WidgetData.Callback
                        })

                        if type(WidgetData.Settings) == "function" then
                            local WidgetSettings = WidgetToggle:Settings()
                            WidgetData.Settings(WidgetSettings, WidgetToggle)
                        end
                    end
                end
            end
        end
    end
end

_G.MisanthropyLandryUI = Library
getgenv().MisanthropyLandryUI = Library

----------------------------------------------------------------------------------
-- END EMBEDDED library
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

-- Generic :Get() shim - Toggle/Slider/Dropdown/Textbox/Button all share the
-- Library metatable. Colorpicker is handled separately in newColorpicker.
Library.Get = function(self)
	return self.Value
end

Library.Holder.Instance.DisplayOrder = 9999
Library.BackgroundBlurEnabled = false
Library.BackgroundSnowEnabled = false

local Window = Library:Window({ Title = "misanthropy.lua", ButtonName = "misanthropy.lua" })

-- Disable MainFrame's own outer border UIStrokes (not exposed by name).
for _, child in Window.Items["MainFrame"].Instance:GetChildren() do
	if child:IsA("UIStroke") then
		child.Enabled = false
	end
end

Library.MenuKeybind = "None" -- single source of truth: the nhack toggle/keybind below

local nhack = getgenv().Nhack
local uiToggleSec
if nhack and type(nhack.AddTab) == "function" then
	local NhackTab = nhack:AddTab("misanthropy")
	uiToggleSec = NhackTab:Section("misanthropy UI")
else
	local uiPage = Window:Page({ Name = "Settings" }):SubPage({ Name = "Settings" })
	uiToggleSec = uiPage:Section({ Name = "misanthropy UI", Side = 1 })
end
local uiToggle = uiToggleSec:Toggle({
	Name = "Show UI",
	Default = true,
	Flag = "misanthropy_show_ui",
	Callback = function(v: boolean)
		Window:SetOpen(v)
	end,
})

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

local function newPage(name: string): any
	local page = Window:Page({ Name = name })
	return page:SubPage({ Name = name })
end
local pgCharacter = newPage("Character FX")
local pgWorld = newPage("World FX")
local pgPlayer = newPage("Player")
local pgConfigs = newPage("Configs")
local pgUtility = newPage("Utility")

local sectionSideCounts = {}
local function newSection(page: any, name: string): any
	local n = (sectionSideCounts[page] or 0) + 1
	sectionSideCounts[page] = n
	local side = (n % 2 == 1) and 1 or 2
	return page:Section({ Name = name, Side = side })
end

local function settingsOf(section: any, toggle: any): any
	return toggle:Settings()
end

local function notify(title: string, text: string)
	pcall(function() Library:Notification(title .. ": " .. text, 4, Library.Theme["Accent"]) end)
end

local cleanups: { () -> () } = {}
local CFG = { toggles = {}, sliders = {}, dropdowns = {}, colors = {} }

-- The vendored UI only cleans its own connections. Run feature cleanups too so
-- re-executing the file does not leave old effects or RenderStepped loops alive.
do
	local baseExit = Library.Exit
	Library.Exit = function(self)
		for i = #cleanups, 1, -1 do
			pcall(cleanups[i])
		end
		table.clear(cleanups)
		if screen then screen:Destroy() end
		baseExit(self)
	end
end

local function newColorpicker(parent: any, opts: any): any
	local picker = parent:Label({ Name = opts.Name }):Colorpicker({
		Flag = opts.Flag or opts.Name,
		Default = opts.Default or Color3.new(1, 1, 1),
		Alpha = 0,
		Callback = opts.Callback,
	})
	function picker:Get()
		return picker.Color, picker.Alpha
	end
	return picker
end

local function newTextInput(parent: any, opts: any): any
	parent:Label({ Name = opts.Name })
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
local trColor   = newColorpicker(trSec, { Name = "Color 1", Default = Color3.fromRGB(190, 120, 255), Alpha = 1, Flag = "tr_color" })
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
local paColor   = newColorpicker(paSec, { Name = "Color 1", Default = Color3.fromRGB(120, 170, 255), Alpha = 1, Flag = "pa_color" })
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
	local adColor   = newColorpicker(adSec, { Name = "Color 1", Default = Color3.fromRGB(120, 170, 255), Alpha = 1, Flag = "ad_color" })
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
	imgSettings:Label({ Name = "Image URL" })
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
	local fsShockwave = fsSettings:Toggle({ Name = "Shockwave", Default = false, Flag = "fs_shockwave" })
	local fsShockSize = fsSettings:Slider({ Name = "Shockwave size", Min = 5, Max = 60, Step = 5, Default = 20, Flag = "fs_shocksize" })

	local fsFolder = Instance.new("Folder")
	fsFolder.Name = "MisanthropyFootsteps"
	fsFolder.Parent = Workspace
	table.insert(cleanups, function() if fsFolder then fsFolder:Destroy() end end)

	-- Cylinder rotated 90 about Z so its circular face points up/down, tweened wider + more transparent.
	local FsTweenService = game:GetService("TweenService")
	local function spawnFootShockwave(pos: Vector3, col: Color3)
		local ring = Instance.new("Part")
		ring.Name = "FootShockwave"
		ring.Shape = Enum.PartType.Cylinder
		ring.Material = Enum.Material.Neon
		ring.Color = col
		ring.Size = Vector3.new(0.05, 0.4, 0.4)
		ring.CFrame = CFrame.new(pos) * CFrame.Angles(0, 0, math.rad(90))
		ring.Transparency = 0.2
		ring.Anchored = true
		ring.CanCollide = false; ring.CanQuery = false; ring.CanTouch = false; ring.CastShadow = false
		ring.Parent = fsFolder
		local maxSize = fsShockSize:Get() / 10
		local tween = FsTweenService:Create(ring, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = Vector3.new(0.05, maxSize, maxSize),
			Transparency = 1,
		})
		tween:Play()
		tween.Completed:Connect(function() ring:Destroy() end)
	end

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
				if fsShockwave:Get() then
					spawnFootShockwave(stepPos, col)
				end
			end
		end
	end)
	table.insert(cleanups, function() rs5:Disconnect() end)

	CFG.toggles.fs_enabled = fsEnabled; CFG.toggles.fs_rainbow = fsRainbow; CFG.toggles.fs_walls = fsWalls
	CFG.toggles.fs_light = fsLight; CFG.toggles.fs_shockwave = fsShockwave
	CFG.sliders.fs_size = fsSize; CFG.sliders.fs_fade = fsFade
	CFG.sliders.fs_spacing = fsSpacing; CFG.sliders.fs_width = fsWidth
	CFG.sliders.fs_rbspeed = fsRbSpeed; CFG.sliders.fs_shocksize = fsShockSize
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

	emSec:Label({ Name = "Animation / Emote ID" })
	local emId       = emSec:Textbox({ Default = "", Placeholder = "e.g. 507770239", Flag = "em_id" })
	local nowPlayingLabel = emSec:Label({ Name = "Now playing: (nothing)" })
	local emLoop     = emSec:Toggle({ Name = "Loop", Default = true, Flag = "em_loop" })

	local emSettings = settingsOf(emSec, emLoop)
	local emSpeed    = emSettings:Slider({ Name = "Speed", Min = 10, Max = 300, Step = 5, Default = 100, Suffix = "%", Flag = "em_speed" })
	local emPriority = emSettings:Dropdown({ Name = "Priority", Items = PRIORITIES, Default = "Action (full body)", Flag = "em_priority" })

	local EMOTE_BURST_STYLES = { "Confetti", "Petals", "Sparkles" }
	local emBurstOn = emSec:Toggle({ Name = "Burst on play", Default = false, Flag = "em_burst_on" })
	local emBurstColor = newColorpicker(emSec, { Name = "Burst color", Default = Color3.fromRGB(255, 200, 80), Alpha = 1, Flag = "em_burst_color" })
	local emBurstSettings = settingsOf(emSec, emBurstOn)
	local emBurstStyle  = emBurstSettings:Dropdown({ Name = "Burst style", Items = EMOTE_BURST_STYLES, Default = "Confetti", Flag = "em_burst_style" })
	local emBurstAmount = emBurstSettings:Slider({ Name = "Burst amount", Min = 10, Max = 100, Step = 5, Default = 40, Flag = "em_burst_amount" })

	local emBurstFolder = Instance.new("Folder")
	emBurstFolder.Name = "MisanthropyEmoteBurst"
	emBurstFolder.Parent = Workspace
	table.insert(cleanups, function() if emBurstFolder then emBurstFolder:Destroy() end end)

	local function spawnEmoteBurst(root: BasePart)
		local anchor = Instance.new("Part")
		anchor.Name = "EmoteBurstAnchor"
		anchor.Anchored = true
		anchor.CanCollide = false; anchor.CanQuery = false; anchor.CanTouch = false; anchor.CastShadow = false
		anchor.Transparency = 1
		anchor.Size = Vector3.new(0.1, 0.1, 0.1)
		anchor.CFrame = root.CFrame * CFrame.new(0, 2, 0)
		anchor.Parent = emBurstFolder

		local emitter = Instance.new("ParticleEmitter")
		emitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
		emitter.Enabled = false
		emitter.LightInfluence = 0

		local style = emBurstStyle:Get()
		local col = emBurstColor:Get()
		if style == "Confetti" then
			emitter.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromHSV(math.random(), 0.85, 1)),
				ColorSequenceKeypoint.new(0.5, Color3.fromHSV(math.random(), 0.85, 1)),
				ColorSequenceKeypoint.new(1, Color3.fromHSV(math.random(), 0.85, 1)),
			})
			emitter.Size = NumberSequence.new(0.15, 0.05)
			emitter.Lifetime = NumberRange.new(0.8, 1.4)
			emitter.Speed = NumberRange.new(8, 16)
			emitter.SpreadAngle = Vector2.new(180, 180)
			emitter.RotSpeed = NumberRange.new(-360, 360)
			emitter.Acceleration = Vector3.new(0, -20, 0)
			emitter.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) })
		elseif style == "Petals" then
			emitter.Color = ColorSequence.new(col)
			emitter.Size = NumberSequence.new(0.25, 0.1)
			emitter.Lifetime = NumberRange.new(1.2, 2)
			emitter.Speed = NumberRange.new(3, 7)
			emitter.SpreadAngle = Vector2.new(120, 120)
			emitter.RotSpeed = NumberRange.new(-90, 90)
			emitter.Acceleration = Vector3.new(0, -4, 0)
			emitter.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.1), NumberSequenceKeypoint.new(1, 1) })
		else -- Sparkles
			emitter.Color = ColorSequence.new(col)
			emitter.Size = NumberSequence.new(0.12, 0)
			emitter.Lifetime = NumberRange.new(0.4, 0.8)
			emitter.Speed = NumberRange.new(10, 20)
			emitter.SpreadAngle = Vector2.new(180, 180)
			emitter.Acceleration = Vector3.new(0, 6, 0)
			emitter.LightEmission = 1
			emitter.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) })
		end
		emitter.Parent = anchor
		emitter:Emit(math.floor(emBurstAmount:Get()))
		task.delay(2.5, function() if anchor.Parent then anchor:Destroy() end end)
	end

	local currentTrack: AnimationTrack? = nil
	local animInstance: Animation? = nil

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

		if emBurstOn:Get() then
			local burstRoot = getRootPart()
			if burstRoot then spawnEmoteBurst(burstRoot) end
		end

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

	CFG.toggles.em_loop = emLoop; CFG.toggles.em_burst_on = emBurstOn
	CFG.sliders.em_speed = emSpeed; CFG.sliders.em_burst_amount = emBurstAmount
	CFG.dropdowns.em_priority = emPriority; CFG.dropdowns.em_burst_style = emBurstStyle
	CFG.colors.em_burst_color = emBurstColor
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

	-- Live mesh/texture preview: ViewportFrame + Camera, own floating window on Library.Holder.
	local previewWindow = Library:Create("Frame", {
		Name = "\0",
		Parent = Library.Holder.Instance,
		Position = UDim2.new(0, 30, 0, 400),
		Size = UDim2.new(0, 220, 0, 170),
		BorderSizePixel = 0,
		BackgroundColor3 = Library.Theme["Background"],
	}):AddToTheme({ BackgroundColor3 = "Background" })
	previewWindow:MakeDraggable()

	Library:Create("UIStroke", {
		Name = "\0",
		Parent = previewWindow.Instance,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		LineJoinMode = Enum.LineJoinMode.Miter,
		Color = Library.Theme["Outline"],
	}):AddToTheme({ Color = "Outline" })

	Library:Create("TextLabel", {
		Name = "\0",
		FontFace = Library.Font,
		TextSize = Library.FontSize,
		Parent = previewWindow.Instance,
		TextColor3 = Library.Theme["Text"],
		Text = "Mesh Preview",
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1, -12, 0, 16),
		Position = UDim2.new(0, 6, 0, 4),
		BorderSizePixel = 0,
	}):AddToTheme({ TextColor3 = "Text" })

	local previewFrame = Instance.new("ViewportFrame")
	previewFrame.Name = "MeshPreview"
	previewFrame.Size = UDim2.new(1, -12, 1, -28)
	previewFrame.Position = UDim2.new(0, 6, 0, 22)
	previewFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	previewFrame.BorderSizePixel = 0
	previewFrame.Ambient = Color3.fromRGB(140, 140, 140)
	previewFrame.LightColor = Color3.fromRGB(255, 255, 255)
	previewFrame.LightDirection = Vector3.new(-1, -1, -1)
	previewFrame.Parent = previewWindow.Instance

	local previewCamera = Instance.new("Camera")
	previewCamera.Parent = previewFrame
	previewFrame.CurrentCamera = previewCamera

	-- Wrapped in a Model since GetBoundingBox() is a Model method, not a BasePart one.
	local previewModel = Instance.new("Model")
	previewModel.Name = "PreviewModel"
	previewModel.Parent = previewFrame

	local previewPart = Instance.new("Part")
	previewPart.Name = "PreviewMesh"
	previewPart.Anchored = true
	previewPart.CanCollide = false; previewPart.CanQuery = false; previewPart.CanTouch = false
	previewPart.Size = Vector3.new(1, 1, 1)
	previewPart.Transparency = 1
	previewPart.CastShadow = false
	previewPart.Parent = previewModel
	previewModel.PrimaryPart = previewPart

	local previewMesh = Instance.new("SpecialMesh")
	previewMesh.MeshType = Enum.MeshType.FileMesh
	previewMesh.Parent = previewPart

	local lastPreviewMesh = ""
	local lastPreviewTex = ""
	local previewSpin = 0

	local rsPreview = RunService.RenderStepped:Connect(function(dt: number)
		local want = idToAsset(msMeshId:Get()) or localMeshId or ""
		if want ~= lastPreviewMesh then
			lastPreviewMesh = want
			previewMesh.MeshId = want
			previewPart.Transparency = (want == "") and 1 or 0
		end
		local tex = idToAsset(msTexId:Get()) or ""
		if tex ~= lastPreviewTex then
			lastPreviewTex = tex
			previewMesh.TextureId = tex
		end

		if previewPart.Transparency < 1 then
			previewSpin = (previewSpin + dt * 0.6) % (2 * math.pi)
			previewPart.CFrame = CFrame.Angles(0, previewSpin, 0)
			local ok, _, size = pcall(function() return previewModel:GetBoundingBox() end)
			local radius = (ok and size) and math.max(size.X, size.Y, size.Z, 0.1) or 2
			local dist = radius * 1.8 + 1
			previewCamera.CFrame = CFrame.new(Vector3.new(0, radius * 0.3, dist), Vector3.new(0, 0, 0))
		end
	end)
	table.insert(cleanups, function()
		rsPreview:Disconnect()
		previewWindow.Instance:Destroy()
	end)

	local msPreviewShow = msSec:Toggle({
		Name = "Show mesh preview",
		Default = true,
		Flag = "ms_preview_show",
		Callback = function(v: boolean)
			previewWindow.Instance.Visible = v
		end,
	})

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
	CFG.toggles.ms_spin_on = msSpinOn; CFG.toggles.ms_preview_show = msPreviewShow
	CFG.sliders.ms_bodytrans = msBodyTrans; CFG.sliders.ms_scale = msScale
	CFG.sliders.ms_xoff = msXOff; CFG.sliders.ms_yoff = msYOff; CFG.sliders.ms_zoff = msZOff
	CFG.sliders.ms_pitch = msPitch; CFG.sliders.ms_yaw = msYaw; CFG.sliders.ms_roll = msRoll
	CFG.sliders.ms_spin_speed = msSpinSpeed
	CFG.dropdowns.ms_material = msMaterial; CFG.dropdowns.ms_overlay_type = msOverlayType
	CFG.dropdowns.ms_spin_axis = msSpinAxis
	CFG.colors.ms_matcolor = msMatColor
end

----------------------------------------------------------------------------------
-- SECTION 5h: Tung
----------------------------------------------------------------------------------
do
	local tungSec = newSection(pgCharacter, "Tung")
	local tungEnabled = tungSec:Toggle({
		Name = "Enabled",
		Default = false,
		Flag = "tung_enabled",
	})

	local TUNG_BUNDLE_ID = 169035278976453
	local AssetService = game:GetService("AssetService")
	local cachedTungDescription: HumanoidDescription? = nil
	local tungProxy: Model? = nil
	local tungCharacter: Model? = nil
	local tungBusy = false
	local tungFailureCharacter: Model? = nil
	local tungMotors: { [string]: Motor6D | AnimationConstraint } = {}
	local tungParts: { BasePart } = {}
	local savedTungTransparency: { [BasePart]: { transparency: number, localTransparency: number } } = {}
	local BODY_PART_NAMES = {
		Head = true,
		UpperTorso = true, LowerTorso = true,
		LeftUpperArm = true, LeftLowerArm = true, LeftHand = true,
		RightUpperArm = true, RightLowerArm = true, RightHand = true,
		LeftUpperLeg = true, LeftLowerLeg = true, LeftFoot = true,
		RightUpperLeg = true, RightLowerLeg = true, RightFoot = true,
	}

	local function getTungDescription(): HumanoidDescription
		if cachedTungDescription then
			return cachedTungDescription:Clone()
		end

		local details = AssetService:GetBundleDetailsAsync(TUNG_BUNDLE_ID)
		local outfitId: number? = nil
		for _, item in ipairs(details.Items) do
			if item.Type == "UserOutfit" then
				outfitId = item.Id
				break
			end
		end
		if not outfitId then
			error("bundle contains no UserOutfit")
		end

		local description = Players:GetHumanoidDescriptionFromOutfitIdAsync(outfitId)
		cachedTungDescription = description:Clone()
		return description
	end

	local function hideTungPart(part: BasePart)
		if savedTungTransparency[part] == nil then
			savedTungTransparency[part] = {
				transparency = part.Transparency,
				localTransparency = part.LocalTransparencyModifier,
			}
		end
		part.Transparency = 1
		part.LocalTransparencyModifier = 1
	end

	local function hideOriginalAvatar(character: Model)
		for name in pairs(BODY_PART_NAMES) do
			local part = character:FindFirstChild(name)
			if part and part:IsA("BasePart") then hideTungPart(part) end
		end

		for _, child in ipairs(character:GetChildren()) do
			if child:IsA("Accessory") then
				for _, descendant in ipairs(child:GetDescendants()) do
					if descendant:IsA("BasePart") then hideTungPart(descendant) end
				end
			end
		end

		-- Project Delta welds its equipped shirt/pants meshes into Models named
		-- after the inventory values referenced by Character.Clothing.
		local clothing = character:FindFirstChild("Clothing")
		if clothing then
			for _, slot in ipairs(clothing:GetChildren()) do
				if slot:IsA("ObjectValue") and slot.Value then
					local visual = character:FindFirstChild(slot.Value.Name)
					if visual then
						for _, descendant in ipairs(visual:GetDescendants()) do
							if descendant:IsA("BasePart") then hideTungPart(descendant) end
						end
					end
				end
			end
		end
	end

	local function destroyTung()
		for part, state in pairs(savedTungTransparency) do
			if part.Parent then
				part.Transparency = state.transparency
				part.LocalTransparencyModifier = state.localTransparency
			end
		end
		table.clear(savedTungTransparency)
		if tungProxy then tungProxy:Destroy() end
		tungProxy = nil
		tungCharacter = nil
		table.clear(tungMotors)
		table.clear(tungParts)
	end

	local function applyTung(character: Model)
		if tungBusy then return end
		tungBusy = true
		tungFailureCharacter = nil

		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if not humanoid then
			tungBusy = false
			return
		end
		if humanoid.RigType ~= Enum.HumanoidRigType.R15 then
			notify("Tung", "Triple T requires an R15 character.")
			tungFailureCharacter = character
			tungBusy = false
			return
		end

		local ok, descriptionOrError = pcall(getTungDescription)
		if not ok then
			notify("Tung", "Could not load bundle: " .. tostring(descriptionOrError))
			tungFailureCharacter = character
			tungBusy = false
			return
		end

		if not tungEnabled:Get() or character ~= getCharacter() then
			(descriptionOrError :: HumanoidDescription):Destroy()
			tungBusy = false
			return
		end

		local description = descriptionOrError :: HumanoidDescription
		local created, proxyOrError = pcall(function()
			return Players:CreateHumanoidModelFromDescriptionAsync(
				description,
				Enum.HumanoidRigType.R15,
				Enum.AssetTypeVerification.Always
			)
		end)
		description:Destroy()
		if not created then
			notify("Tung", "Could not create bundle rig: " .. tostring(proxyOrError))
			tungFailureCharacter = character
			tungBusy = false
			return
		end

		local proxy = proxyOrError :: Model
		if not tungEnabled:Get() or character ~= getCharacter() then
			proxy:Destroy()
			tungBusy = false
			return
		end

		proxy.Name = "TungProxy"
		for _, descendant in ipairs(proxy:GetDescendants()) do
			if descendant:IsA("Script") or descendant:IsA("LocalScript") or descendant:IsA("ModuleScript") then
				descendant:Destroy()
			elseif descendant:IsA("BasePart") then
				table.insert(tungParts, descendant)
				descendant.Anchored = descendant.Name == "HumanoidRootPart"
				descendant.CanCollide = false
				descendant.CanQuery = false
				descendant.CanTouch = false
				descendant.Massless = true
				if descendant.Name == "HumanoidRootPart" then descendant.Transparency = 1 end
			elseif descendant:IsA("Motor6D") or descendant:IsA("AnimationConstraint") then
				tungMotors[descendant.Name] = descendant
			end
		end

		local proxyHumanoid = proxy:FindFirstChildOfClass("Humanoid")
		if proxyHumanoid then
			proxyHumanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
			proxyHumanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
			proxyHumanoid.NameDisplayDistance = 0
			proxyHumanoid.EvaluateStateMachine = false
		end

		local sourceRoot = character:FindFirstChild("HumanoidRootPart")
		if sourceRoot and sourceRoot:IsA("BasePart") then proxy:PivotTo(sourceRoot.CFrame) end
		proxy.Parent = Workspace
		tungProxy = proxy
		tungCharacter = character
		hideOriginalAvatar(character)
		tungBusy = false

		if not tungEnabled:Get() or character ~= getCharacter() then
			destroyTung()
		end
	end

	local rsTung = RunService.RenderStepped:Connect(function()
		if not tungEnabled:Get() then
			tungFailureCharacter = nil
			if tungCharacter and not tungBusy then
				tungBusy = true
				destroyTung()
				tungBusy = false
			end
			return
		end

		local character = getCharacter()
		if character and character ~= tungCharacter and character ~= tungFailureCharacter and not tungBusy then
			task.spawn(applyTung, character)
		elseif character and tungProxy then
			for _, part in ipairs(tungParts) do
				part.CanCollide = false
				part.CanQuery = false
				part.CanTouch = false
			end
			local sourceRoot = character:FindFirstChild("HumanoidRootPart")
			if sourceRoot and sourceRoot:IsA("BasePart") then
				tungProxy:PivotTo(sourceRoot.CFrame)
			end
			for _, descendant in ipairs(character:GetDescendants()) do
				if descendant:IsA("Motor6D") or descendant:IsA("AnimationConstraint") then
					local target = tungMotors[descendant.Name]
					if target then target.Transform = descendant.Transform end
				end
			end
			hideOriginalAvatar(character)
		end
	end)
	table.insert(cleanups, function()
		rsTung:Disconnect()
		if not tungBusy then destroyTung() end
		if cachedTungDescription then cachedTungDescription:Destroy() end
	end)

	CFG.toggles.tung_enabled = tungEnabled
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
-- SECTION 5s: Leaves Fall / Cherry Blossoms / Falling Feathers / Falling Confetti
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

	buildFallingDebris("Falling Feathers", "MisanthropyFeathers", "Feather", Vector3.new(1, 0.1, 2), {
		Color3.fromRGB(255, 255, 255), Color3.fromRGB(235, 235, 240), Color3.fromRGB(220, 225, 235),
		Color3.fromRGB(245, 245, 250),
	}, { prefix = "fh", maxCount = 70, fallSpeed = 22, radius = 50, windX = 18, windZ = 12, lifetime = 15 })

	buildFallingDebris("Falling Confetti", "MisanthropyConfetti", "Confetti", Vector3.new(0.5, 0.05, 0.5), {
		Color3.fromRGB(255, 60, 90), Color3.fromRGB(255, 210, 40), Color3.fromRGB(60, 180, 255),
		Color3.fromRGB(80, 230, 120), Color3.fromRGB(200, 90, 255), Color3.fromRGB(255, 140, 40),
	}, { prefix = "cf", maxCount = 110, fallSpeed = 35, radius = 55, windX = 22, windZ = 18, lifetime = 12 })
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
-- SECTION 5w2: Aurora
----------------------------------------------------------------------------------
do
	local auSec = newSection(pgWorld, "Aurora")
	local auEnabled = auSec:Toggle({ Name = "Enabled", Default = false, Flag = "au_enabled" })
	local auColor1 = newColorpicker(auSec, { Name = "Color 1", Default = Color3.fromRGB(60, 220, 140), Alpha = 1, Flag = "au_color1" })
	local auColor2 = newColorpicker(auSec, { Name = "Color 2", Default = Color3.fromRGB(120, 90, 255), Alpha = 1, Flag = "au_color2" })
	local auSettings = settingsOf(auSec, auEnabled)
	local auHeight = auSettings:Slider({ Name = "Height", Min = 60, Max = 300, Step = 10, Default = 140, Flag = "au_height" })
	local auSpeed  = auSettings:Slider({ Name = "Flow speed", Min = 5, Max = 100, Step = 5, Default = 30, Suffix = "%", Flag = "au_speed" })
	local auBands  = auSettings:Slider({ Name = "Band count", Min = 2, Max = 8, Step = 1, Default = 5, Flag = "au_bands" })

	local auFolder = Instance.new("Folder")
	auFolder.Name = "MisanthropyAurora"
	auFolder.Parent = Workspace
	table.insert(cleanups, function() if auFolder then auFolder:Destroy() end end)

	type Band = { inst: BasePart, phase: number, seed: number }
	local bands: { Band } = {}

	local function destroyBands()
		for _, b in ipairs(bands) do b.inst:Destroy() end
		table.clear(bands)
	end

	local function buildBands(n: number)
		destroyBands()
		for i = 1, n do
			local p = Instance.new("Part")
			p.Name = "AuroraBand"
			p.Size = Vector3.new(260, 0.4, 26 + math.random(0, 20))
			p.Material = Enum.Material.Neon
			p.Anchored = true
			p.CanCollide = false; p.CanQuery = false; p.CanTouch = false; p.CastShadow = false
			p.Transparency = 0.55
			p.Parent = auFolder
			table.insert(bands, { inst = p, phase = (i / n) * math.pi * 2, seed = math.random() * 1000 })
		end
	end

	local lastBandCount = 0
	local rsAu = RunService.Heartbeat:Connect(function(dt: number)
		if not auEnabled:Get() then
			if #bands > 0 then destroyBands() end
			return
		end
		local root = getRootPart()
		if not root then return end
		local n = math.floor(auBands:Get())
		if n ~= lastBandCount or #bands == 0 then
			lastBandCount = n
			buildBands(n)
		end
		local t = os.clock() * (auSpeed:Get() / 100)
		local baseHeight = auHeight:Get()
		local c1, c2 = auColor1:Get(), auColor2:Get()
		for i, b in ipairs(bands) do
			local wave = math.sin(t * 0.3 + b.phase)
			local bob = math.sin(t * 0.5 + b.seed) * 6
			local blend = (math.sin(t * 0.25 + b.phase) + 1) / 2
			b.inst.Color = c1:Lerp(c2, blend)
			b.inst.CFrame = CFrame.new(root.Position + Vector3.new(0, baseHeight + bob + i * 4, 0))
				* CFrame.Angles(0, t * 0.05 + b.phase, math.rad(wave * 4))
			b.inst.Transparency = 0.45 + math.sin(t * 0.4 + b.seed) * 0.15
		end
	end)
	table.insert(cleanups, function()
		rsAu:Disconnect()
		destroyBands()
	end)

	CFG.toggles.au_enabled = auEnabled
	CFG.sliders.au_height = auHeight; CFG.sliders.au_speed = auSpeed; CFG.sliders.au_bands = auBands
	CFG.colors.au_color1 = auColor1; CFG.colors.au_color2 = auColor2
end

----------------------------------------------------------------------------------
-- SECTION 5w4: Embers / Bubbles (shared buildRisingAmbient builder)
----------------------------------------------------------------------------------
do
	local function buildRisingAmbient(sectionName: string, folderName: string, partName: string, cfg: any)
		local sec = newSection(pgWorld, sectionName)
		local enabled = sec:Toggle({ Name = "Enabled", Default = false, Flag = cfg.prefix .. "_enabled" })
		local color = newColorpicker(sec, { Name = "Color", Default = cfg.color, Alpha = 1, Flag = cfg.prefix .. "_color" })
		local settings = settingsOf(sec, enabled)
		local count     = settings:Slider({ Name = "Max count", Min = 5, Max = 150, Step = 5, Default = cfg.maxCount, Flag = cfg.prefix .. "_count" })
		local riseSpeed = settings:Slider({ Name = "Rise speed", Min = 5, Max = 100, Step = 5, Default = cfg.riseSpeed, Suffix = "ds", Flag = cfg.prefix .. "_risespeed" })
		local radius    = settings:Slider({ Name = "Spawn radius", Min = 10, Max = 80, Step = 5, Default = cfg.radius, Flag = cfg.prefix .. "_radius" })
		local maxHeight = settings:Slider({ Name = "Max height", Min = 5, Max = 60, Step = 5, Default = cfg.maxHeight, Flag = cfg.prefix .. "_maxheight" })

		local folder = Instance.new("Folder")
		folder.Name = folderName
		folder.Parent = Workspace
		table.insert(cleanups, function() if folder then folder:Destroy() end end)

		type Piece = {
			inst: BasePart, basePos: Vector3, age: number, lifetime: number,
			swayPhase: number, swaySpeed: number, swayWidth: number,
		}
		local active: { Piece } = {}

		local function spawnPiece(root: BasePart)
			if #active >= count:Get() then return end
			local p = Instance.new("Part")
			p.Name = partName
			p.Shape = Enum.PartType.Ball
			local sz = cfg.minSize + math.random() * (cfg.maxSize - cfg.minSize)
			p.Size = Vector3.new(sz, sz, sz)
			p.Material = cfg.material
			p.Color = color:Get()
			p.Transparency = cfg.baseTransparency
			p.Anchored = true; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false; p.CastShadow = false
			p.Parent = folder
			if cfg.glow then
				local light = Instance.new("PointLight")
				light.Color = color:Get(); light.Brightness = cfg.glowBrightness; light.Range = cfg.glowRange; light.Shadows = false
				light.Parent = p
			end
			local r = radius:Get()
			local angle = math.random() * math.pi * 2
			local dist = math.random() * r
			local startPos = root.Position + Vector3.new(math.cos(angle) * dist, math.random(-20, 20) / 10, math.sin(angle) * dist)
			p.Position = startPos
			table.insert(active, {
				inst = p, basePos = startPos, age = 0, lifetime = cfg.lifetime + math.random(-20, 20) / 10,
				swayPhase = math.random(0, 628) / 100, swaySpeed = math.random(5, 15) / 10, swayWidth = math.random(3, 10) / 10,
			})
		end

		local function destroyAll()
			for _, d in ipairs(active) do d.inst:Destroy() end
			table.clear(active)
		end

		local function updatePieces(dt: number)
			local rise = riseSpeed:Get() / 10
			local capHeight = maxHeight:Get()
			for i = #active, 1, -1 do
				local d = active[i]
				local inst = d.inst
				if not inst.Parent then table.remove(active, i); continue end
				d.age += dt
				local risen = d.age * rise
				local heightFrac = math.clamp(risen / capHeight, 0, 1)
				local fadeIn = math.min(d.age / 0.6, 1)
				local lifeFrac = d.age / d.lifetime
				local fadeOut = 1 - math.max(heightFrac, math.clamp((lifeFrac - 0.7) / 0.3, 0, 1))
				if heightFrac >= 1 or d.age >= d.lifetime or fadeOut <= 0 then
					inst:Destroy(); table.remove(active, i); continue
				end
				inst.Transparency = 1 - (math.min(fadeIn, fadeOut) * (1 - cfg.baseTransparency))
				local sway = math.sin(d.age * d.swaySpeed + d.swayPhase) * d.swayWidth
				local swayZ = math.cos(d.age * d.swaySpeed * 0.7 + d.swayPhase) * d.swayWidth
				inst.Position = d.basePos + Vector3.new(sway, risen, swayZ)
				local light = inst:FindFirstChildOfClass("PointLight")
				if light then light.Color = color:Get() end
			end
		end

		local lastSpawn = 0
		local rs = RunService.Heartbeat:Connect(function(dt: number)
			if not enabled:Get() then
				if #active > 0 then destroyAll() end
				return
			end
			local root = getRootPart()
			if not root then return end
			lastSpawn += dt
			if lastSpawn >= cfg.spawnInterval then
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
		CFG.sliders[cfg.prefix .. "_risespeed"] = riseSpeed
		CFG.sliders[cfg.prefix .. "_radius"] = radius
		CFG.sliders[cfg.prefix .. "_maxheight"] = maxHeight
		CFG.colors[cfg.prefix .. "_color"] = color
	end

	buildRisingAmbient("Embers", "MisanthropyEmbers", "Ember", {
		prefix = "eb", color = Color3.fromRGB(255, 140, 40), maxCount = 60, riseSpeed = 25, radius = 30, maxHeight = 20,
		minSize = 0.08, maxSize = 0.22, material = Enum.Material.Neon, baseTransparency = 0.1, lifetime = 6,
		glow = true, glowBrightness = 1.2, glowRange = 4, spawnInterval = 0.08,
	})

	buildRisingAmbient("Bubbles", "MisanthropyBubbles", "Bubble", {
		prefix = "bb", color = Color3.fromRGB(180, 220, 255), maxCount = 50, riseSpeed = 15, radius = 25, maxHeight = 18,
		minSize = 0.15, maxSize = 0.4, material = Enum.Material.Glass, baseTransparency = 0.5, lifetime = 8,
		glow = false, glowBrightness = 0, glowRange = 0, spawnInterval = 0.12,
	})
end

----------------------------------------------------------------------------------
-- SECTION 5w5: Meteor Shower
----------------------------------------------------------------------------------
do
	local mtSec = newSection(pgWorld, "Meteor Shower")
	local mtEnabled = mtSec:Toggle({ Name = "Enabled", Default = false, Flag = "mt_enabled" })
	local mtColor = newColorpicker(mtSec, { Name = "Color", Default = Color3.fromRGB(255, 220, 150), Alpha = 1, Flag = "mt_color" })
	local mtSettings = settingsOf(mtSec, mtEnabled)
	local mtFrequency = mtSettings:Slider({ Name = "Frequency", Min = 2, Max = 30, Step = 1, Default = 8, Suffix = "ds", Flag = "mt_frequency" })
	local mtSize      = mtSettings:Slider({ Name = "Size", Min = 50, Max = 300, Step = 10, Default = 120, Suffix = "%", Flag = "mt_size" })
	local mtSpeed     = mtSettings:Slider({ Name = "Speed", Min = 20, Max = 200, Step = 10, Default = 80, Suffix = "%", Flag = "mt_speed" })

	local mtFolder = Instance.new("Folder")
	mtFolder.Name = "MisanthropyMeteorShower"
	mtFolder.Parent = Workspace
	table.insert(cleanups, function() if mtFolder then mtFolder:Destroy() end end)

	type Meteor = { inst: BasePart, vel: Vector3, age: number }
	local meteors: { Meteor } = {}

	local function destroyMeteors()
		for _, m in ipairs(meteors) do m.inst:Destroy() end
		table.clear(meteors)
	end

	local function spawnMeteor(root: BasePart)
		local p = Instance.new("Part")
		p.Name = "Meteor"; p.Shape = Enum.PartType.Ball; p.Material = Enum.Material.Neon
		local sz = 0.6 * (mtSize:Get() / 100)
		p.Size = Vector3.new(sz, sz, sz)
		p.Color = mtColor:Get()
		p.Anchored = true; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false; p.CastShadow = false
		p.Parent = mtFolder
		local a0 = Instance.new("Attachment"); a0.Position = Vector3.new(0, sz * 0.5, 0); a0.Parent = p
		local a1 = Instance.new("Attachment"); a1.Position = Vector3.new(0, -sz * 0.5, 0); a1.Parent = p
		local trail = Instance.new("Trail")
		trail.Attachment0 = a0; trail.Attachment1 = a1
		trail.Color = ColorSequence.new(mtColor:Get())
		trail.Lifetime = 0.6
		trail.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.1), NumberSequenceKeypoint.new(1, 1) })
		trail.WidthScale = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) })
		trail.Parent = p

		local angle = math.random() * math.pi * 2
		local dist = math.random(60, 120)
		local startPos = root.Position + Vector3.new(math.cos(angle) * dist, 100 + math.random(0, 40), math.sin(angle) * dist)
		p.Position = startPos
		local dir = (root.Position - startPos + Vector3.new(math.random(-20, 20), -40, math.random(-20, 20))).Unit
		table.insert(meteors, { inst = p, vel = dir * (60 * (mtSpeed:Get() / 100)), age = 0 })
	end

	local lastMeteor = 0
	local rsMt = RunService.Heartbeat:Connect(function(dt: number)
		if not mtEnabled:Get() then
			if #meteors > 0 then destroyMeteors() end
			return
		end
		local root = getRootPart()
		if not root then return end
		local now = os.clock()
		if now - lastMeteor >= mtFrequency:Get() then
			lastMeteor = now
			spawnMeteor(root)
		end
		for i = #meteors, 1, -1 do
			local m = meteors[i]
			if not m.inst.Parent then table.remove(meteors, i); continue end
			m.age += dt
			if m.age > 4 or m.inst.Position.Y < root.Position.Y - 5 then
				m.inst:Destroy(); table.remove(meteors, i); continue
			end
			m.inst.Position += m.vel * dt
		end
	end)
	table.insert(cleanups, function()
		rsMt:Disconnect()
		destroyMeteors()
	end)

	CFG.toggles.mt_enabled = mtEnabled
	CFG.sliders.mt_frequency = mtFrequency; CFG.sliders.mt_size = mtSize; CFG.sliders.mt_speed = mtSpeed
	CFG.colors.mt_color = mtColor
end

----------------------------------------------------------------------------------
-- SECTION 5w7: Distant Storm
----------------------------------------------------------------------------------
do
	local dsSec = newSection(pgWorld, "Distant Storm")
	local dsEnabled = dsSec:Toggle({ Name = "Enabled", Default = false, Flag = "ds_enabled" })
	local dsColor = newColorpicker(dsSec, { Name = "Color", Default = Color3.fromRGB(210, 220, 255), Alpha = 1, Flag = "ds_color" })
	local dsSettings = settingsOf(dsSec, dsEnabled)
	local dsFrequency = dsSettings:Slider({ Name = "Frequency", Min = 3, Max = 40, Step = 1, Default = 10, Suffix = "ds", Flag = "ds_frequency" })
	local dsDistance  = dsSettings:Slider({ Name = "Distance", Min = 150, Max = 500, Step = 10, Default = 300, Flag = "ds_distance" })

	local dsFolder = Instance.new("Folder")
	dsFolder.Name = "MisanthropyDistantStorm"
	dsFolder.Parent = Workspace
	table.insert(cleanups, function() if dsFolder then dsFolder:Destroy() end end)

	local dsPanel = Instance.new("Part")
	dsPanel.Name = "StormFlash"; dsPanel.Material = Enum.Material.Neon
	dsPanel.Size = Vector3.new(120, 80, 0.5)
	dsPanel.Anchored = true; dsPanel.CanCollide = false; dsPanel.CanQuery = false; dsPanel.CanTouch = false; dsPanel.CastShadow = false
	dsPanel.Transparency = 1
	dsPanel.Parent = dsFolder

	local DsTweenService = game:GetService("TweenService")
	local dsLastFlash = 0
	local rsDs = RunService.Heartbeat:Connect(function()
		if not dsEnabled:Get() then
			if dsPanel.Transparency ~= 1 then dsPanel.Transparency = 1 end
			return
		end
		local root = getRootPart()
		if not root then return end
		local now = os.clock()
		if now - dsLastFlash >= dsFrequency:Get() then
			dsLastFlash = now
			local angle = math.random() * math.pi * 2
			local dist = dsDistance:Get()
			local pos = root.Position + Vector3.new(math.cos(angle) * dist, math.random(20, 60), math.sin(angle) * dist)
			dsPanel.Color = dsColor:Get()
			dsPanel.CFrame = CFrame.new(pos, root.Position)
			dsPanel.Transparency = 1
			local flashIn = DsTweenService:Create(dsPanel, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Transparency = 0.55 })
			flashIn:Play()
			flashIn.Completed:Connect(function()
				local flashOut = DsTweenService:Create(dsPanel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Transparency = 1 })
				flashOut:Play()
			end)
		end
	end)
	table.insert(cleanups, function() rsDs:Disconnect() end)

	CFG.toggles.ds_enabled = dsEnabled
	CFG.sliders.ds_frequency = dsFrequency; CFG.sliders.ds_distance = dsDistance
	CFG.colors.ds_color = dsColor
end

----------------------------------------------------------------------------------
-- SECTION 5w10: Blizzard
----------------------------------------------------------------------------------
do
	-- Wind-dominated drift, upwind spawn; bespoke builder (not buildFallingDebris).
	local bzSec = newSection(pgWorld, "Blizzard")
	local bzEnabled = bzSec:Toggle({ Name = "Enabled", Default = false, Flag = "bz_enabled" })
	local bzColor = newColorpicker(bzSec, { Name = "Color", Default = Color3.fromRGB(235, 240, 250), Alpha = 1, Flag = "bz_color" })
	local bzSettings = settingsOf(bzSec, bzEnabled)
	local bzIntensity = bzSettings:Slider({ Name = "Intensity", Min = 20, Max = 300, Step = 10, Default = 150, Flag = "bz_intensity" })
	local bzWind      = bzSettings:Slider({ Name = "Wind speed", Min = 20, Max = 150, Step = 5, Default = 70, Suffix = "ds", Flag = "bz_wind" })
	local bzRadius    = bzSettings:Slider({ Name = "Radius", Min = 20, Max = 100, Step = 5, Default = 55, Flag = "bz_radius" })

	local bzFolder = Instance.new("Folder")
	bzFolder.Name = "MisanthropyBlizzard"
	bzFolder.Parent = Workspace
	table.insert(cleanups, function() if bzFolder then bzFolder:Destroy() end end)

	type Flake = { inst: BasePart, pos: Vector3 }
	local flakes: { Flake } = {}

	local function destroyFlakes()
		for _, f in ipairs(flakes) do f.inst:Destroy() end
		table.clear(flakes)
	end

	local function spawnFlake(root: BasePart, radius: number)
		if #flakes >= math.floor(bzIntensity:Get()) then return end
		local p = Instance.new("Part")
		p.Name = "BlizzardFlake"; p.Shape = Enum.PartType.Ball; p.Material = Enum.Material.SmoothPlastic
		local sz = math.random(6, 14) / 100
		p.Size = Vector3.new(sz, sz, sz)
		p.Anchored = true; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false; p.CastShadow = false
		p.Parent = bzFolder
		local upwindOffset = Vector3.new(-radius, math.random(-5, 25), math.random(-radius, radius))
		local startPos = root.Position + upwindOffset
		p.Position = startPos
		table.insert(flakes, { inst = p, pos = startPos })
	end

	local lastSpawn = 0
	local rsBz = RunService.Heartbeat:Connect(function(dt: number)
		if not bzEnabled:Get() then
			if #flakes > 0 then destroyFlakes() end
			return
		end
		local root = getRootPart()
		if not root then return end
		local radius = bzRadius:Get()
		local windSpeed = bzWind:Get() / 10
		local col = bzColor:Get()

		lastSpawn += dt
		if lastSpawn >= 0.02 then
			lastSpawn = 0
			spawnFlake(root, radius)
		end

		local rootPos = root.Position
		for i = #flakes, 1, -1 do
			local f = flakes[i]
			if not f.inst.Parent then table.remove(flakes, i); continue end
			f.pos += Vector3.new(windSpeed, -2, math.sin(os.clock() * 3 + i) * 1.5) * dt
			f.inst.Position = f.pos
			f.inst.Color = col
			local rel = f.pos - rootPos
			if rel.X > radius or rel.Magnitude > radius * 2.2 then
				f.inst:Destroy()
				table.remove(flakes, i)
			end
		end
	end)
	table.insert(cleanups, function()
		rsBz:Disconnect()
		destroyFlakes()
	end)

	CFG.toggles.bz_enabled = bzEnabled
	CFG.sliders.bz_intensity = bzIntensity; CFG.sliders.bz_wind = bzWind; CFG.sliders.bz_radius = bzRadius
	CFG.colors.bz_color = bzColor
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
-- SECTION 5x5: Constellation
----------------------------------------------------------------------------------
do
	local csSec = newSection(pgCharacter, "Constellation")
	local csEnabled = csSec:Toggle({ Name = "Enabled", Default = false, Flag = "cs_enabled" })
	local csColor = newColorpicker(csSec, { Name = "Color", Default = Color3.fromRGB(255, 255, 255), Alpha = 1, Flag = "cs_color" })
	local csSettings = settingsOf(csSec, csEnabled)
	local csCount  = csSettings:Slider({ Name = "Star count", Min = 3, Max = 20, Step = 1, Default = 8, Flag = "cs_count" })
	local csRadius = csSettings:Slider({ Name = "Radius", Min = 2, Max = 10, Step = 1, Default = 4, Flag = "cs_radius" })

	local csFolder = Instance.new("Folder")
	csFolder.Name = "MisanthropyConstellation"
	csFolder.Parent = Workspace
	table.insert(cleanups, function() if csFolder then csFolder:Destroy() end end)

	type Star = { inst: BasePart, seed: number, phase: number, incline: number }
	local stars: { Star } = {}

	local function destroyStars()
		for _, s in ipairs(stars) do s.inst:Destroy() end
		table.clear(stars)
	end

	local function buildStars(n: number)
		destroyStars()
		for i = 1, n do
			local p = Instance.new("Part")
			p.Name = "Star"; p.Shape = Enum.PartType.Ball; p.Material = Enum.Material.Neon
			p.Anchored = true; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false; p.CastShadow = false
			p.Parent = csFolder
			table.insert(stars, { inst = p, seed = math.random() * 1000, phase = (i / n) * math.pi * 2, incline = math.random() * math.pi })
		end
	end

	local lastCsCount = 0
	local rsCs = RunService.Heartbeat:Connect(function()
		if not csEnabled:Get() then
			if #stars > 0 then destroyStars() end
			return
		end
		local root = getRootPart()
		if not root then return end
		local n = math.floor(csCount:Get())
		if n ~= lastCsCount or #stars == 0 then
			lastCsCount = n
			buildStars(n)
		end
		local t = os.clock()
		local radius = csRadius:Get()
		local col = csColor:Get()
		local headPos = root.Position + Vector3.new(0, 3, 0)
		for _, s in ipairs(stars) do
			local a = t * 0.4 + s.phase
			local x = math.cos(a) * radius
			local z = math.sin(a) * radius * math.cos(s.incline)
			local y = math.sin(a) * radius * math.sin(s.incline) * 0.6
			s.inst.Position = headPos + Vector3.new(x, y, z)
			local twinkle = 0.5 + math.noise(t * 1.5 + s.seed, 0) * 0.5
			local sz = 0.08 + twinkle * 0.08
			s.inst.Size = Vector3.new(sz, sz, sz)
			s.inst.Color = col
			s.inst.Transparency = 0.2 + (1 - twinkle) * 0.5
		end
	end)
	table.insert(cleanups, function()
		rsCs:Disconnect()
		destroyStars()
	end)

	CFG.toggles.cs_enabled = csEnabled
	CFG.sliders.cs_count = csCount; CFG.sliders.cs_radius = csRadius
	CFG.colors.cs_color = csColor
end

----------------------------------------------------------------------------------
-- SECTION 5x8: Frost Aura
----------------------------------------------------------------------------------
do
	local faSec = newSection(pgCharacter, "Frost Aura")
	local faEnabled = faSec:Toggle({ Name = "Enabled", Default = false, Flag = "fa_enabled" })
	local faColor = newColorpicker(faSec, { Name = "Color", Default = Color3.fromRGB(200, 235, 255), Alpha = 1, Flag = "fa_color" })
	local faSettings = settingsOf(faSec, faEnabled)
	local faDensity = faSettings:Slider({ Name = "Density", Min = 5, Max = 60, Step = 5, Default = 20, Flag = "fa_density" })
	local faRadius  = faSettings:Slider({ Name = "Radius", Min = 1, Max = 6, Step = 1, Default = 2, Flag = "fa_radius" })

	local faFolder = Instance.new("Folder")
	faFolder.Name = "MisanthropyFrostAura"
	faFolder.Parent = Workspace
	table.insert(cleanups, function() if faFolder then faFolder:Destroy() end end)

	local faPart = Instance.new("Part")
	faPart.Name = "FrostSource"
	faPart.Anchored = true; faPart.CanCollide = false; faPart.CanQuery = false; faPart.CanTouch = false; faPart.CastShadow = false
	faPart.Transparency = 1; faPart.Size = Vector3.new(3, 5, 3)
	faPart.Parent = faFolder

	local mist = Instance.new("ParticleEmitter")
	mist.Texture = "rbxasset://textures/particles/smoke_main.dds"
	mist.Enabled = false
	mist.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.8), NumberSequenceKeypoint.new(1, 1.6) })
	mist.Lifetime = NumberRange.new(0.8, 1.4)
	mist.Speed = NumberRange.new(0.1, 0.4)
	mist.SpreadAngle = Vector2.new(180, 180)
	mist.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.75), NumberSequenceKeypoint.new(1, 1) })
	mist.LightInfluence = 1
	mist.Parent = faPart

	local glints = Instance.new("ParticleEmitter")
	glints.Texture = "rbxasset://textures/particles/sparkles_main.dds"
	glints.Enabled = false
	glints.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.12), NumberSequenceKeypoint.new(1, 0) })
	glints.Lifetime = NumberRange.new(0.5, 1)
	glints.Speed = NumberRange.new(0.2, 0.6)
	glints.SpreadAngle = Vector2.new(180, 180)
	glints.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.1), NumberSequenceKeypoint.new(1, 1) })
	glints.LightEmission = 1
	glints.Parent = faPart

	local rsFa = RunService.Heartbeat:Connect(function()
		local root = getRootPart()
		if not faEnabled:Get() or not root then
			mist.Enabled = false; glints.Enabled = false
			return
		end
		local col = faColor:Get()
		local radius = faRadius:Get()
		faPart.Size = Vector3.new(radius * 2, 5, radius * 2)
		faPart.CFrame = root.CFrame
		mist.Color = ColorSequence.new(col)
		glints.Color = ColorSequence.new(col)
		mist.Rate = faDensity:Get()
		glints.Rate = math.max(faDensity:Get() / 6, 1)
		mist.Enabled = true; glints.Enabled = true
	end)
	table.insert(cleanups, function() rsFa:Disconnect() end)

	CFG.toggles.fa_enabled = faEnabled
	CFG.sliders.fa_density = faDensity; CFG.sliders.fa_radius = faRadius
	CFG.colors.fa_color = faColor
end

----------------------------------------------------------------------------------
-- SECTION 5x12: Aura Wisps
----------------------------------------------------------------------------------
do
	-- Bursty motion: dash toward a random nearby point with ease-in, pause, retarget.
	local awSec = newSection(pgCharacter, "Aura Wisps")
	local awEnabled = awSec:Toggle({ Name = "Enabled", Default = false, Flag = "aw_enabled" })
	local awColor = newColorpicker(awSec, { Name = "Color", Default = Color3.fromRGB(255, 80, 180), Alpha = 1, Flag = "aw_color" })
	local awSettings = settingsOf(awSec, awEnabled)
	local awCount      = awSettings:Slider({ Name = "Count", Min = 2, Max = 12, Step = 1, Default = 5, Flag = "aw_count" })
	local awRadius     = awSettings:Slider({ Name = "Radius", Min = 3, Max = 20, Step = 1, Default = 8, Flag = "aw_radius" })
	local awDartSpeed  = awSettings:Slider({ Name = "Dart speed", Min = 20, Max = 200, Step = 10, Default = 100, Suffix = "%", Flag = "aw_dartspeed" })

	local awFolder = Instance.new("Folder")
	awFolder.Name = "MisanthropyAuraWisps"
	awFolder.Parent = Workspace
	table.insert(cleanups, function() if awFolder then awFolder:Destroy() end end)

	type Wisp = { inst: BasePart, pos: Vector3, target: Vector3, waitUntil: number, seed: number }
	local wisps: { Wisp } = {}

	local function randomTarget(radius: number): Vector3
		return Vector3.new(
			math.random(-100, 100) / 100 * radius,
			math.random(-50, 150) / 100 * radius * 0.5,
			math.random(-100, 100) / 100 * radius
		)
	end

	local function destroyWisps()
		for _, w in ipairs(wisps) do w.inst:Destroy() end
		table.clear(wisps)
	end

	local function buildWisps(n: number, radius: number)
		destroyWisps()
		for _ = 1, n do
			local p = Instance.new("Part")
			p.Name = "Wisp"; p.Shape = Enum.PartType.Ball; p.Material = Enum.Material.Neon
			p.Size = Vector3.new(0.35, 0.35, 0.35)
			p.Anchored = true; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false; p.CastShadow = false
			p.Parent = awFolder
			local a0 = Instance.new("Attachment"); a0.Position = Vector3.new(0, 0.17, 0); a0.Parent = p
			local a1 = Instance.new("Attachment"); a1.Position = Vector3.new(0, -0.17, 0); a1.Parent = p
			local trail = Instance.new("Trail")
			trail.Attachment0 = a0; trail.Attachment1 = a1
			trail.Lifetime = 0.35
			trail.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.2), NumberSequenceKeypoint.new(1, 1) })
			trail.WidthScale = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) })
			trail.Parent = p
			local start = randomTarget(radius)
			table.insert(wisps, { inst = p, pos = start, target = randomTarget(radius), waitUntil = 0, seed = math.random() * 1000 })
		end
	end

	local lastAwCount = 0
	local rsAw = RunService.Heartbeat:Connect(function(dt: number)
		if not awEnabled:Get() then
			if #wisps > 0 then destroyWisps() end
			return
		end
		local root = getRootPart()
		if not root then return end
		local n = math.floor(awCount:Get())
		local radius = awRadius:Get()
		if n ~= lastAwCount or #wisps == 0 then
			lastAwCount = n
			buildWisps(n, radius)
		end
		local col = awColor:Get()
		local dartSpeed = awDartSpeed:Get() / 100 * 18
		local now = os.clock()
		local rootPos = root.Position
		for _, w in ipairs(wisps) do
			if now >= w.waitUntil then
				local toTarget = w.target - w.pos
				local dist = toTarget.Magnitude
				if dist < 0.5 then
					w.target = randomTarget(radius)
					w.waitUntil = now + math.random(2, 8) / 10
				else
					w.pos = w.pos:Lerp(w.target, 1 - math.exp(-dartSpeed * 0.15 * dt))
				end
			end
			w.inst.Position = rootPos + w.pos
			w.inst.Color = col
			local pulse = 0.85 + math.sin(now * 6 + w.seed) * 0.15
			w.inst.Size = Vector3.new(0.35 * pulse, 0.35 * pulse, 0.35 * pulse)
			local trail = w.inst:FindFirstChildOfClass("Trail")
			if trail then trail.Color = ColorSequence.new(col) end
		end
	end)
	table.insert(cleanups, function()
		rsAw:Disconnect()
		destroyWisps()
	end)

	CFG.toggles.aw_enabled = awEnabled
	CFG.sliders.aw_count = awCount; CFG.sliders.aw_radius = awRadius; CFG.sliders.aw_dartspeed = awDartSpeed
	CFG.colors.aw_color = awColor
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

	vsSec:Label({ Name = "Sorts your own vault by category, cost, durability, skin and amount." })
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

		-- re-baseline per respawn: a fresh Humanoid may not carry the old value
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
-- SECTION 5z3: Ambient Vignette
----------------------------------------------------------------------------------
do
	-- Four gradient-faded edge frames approximate a vignette (UIGradient is linear-only).
	local avSec = newSection(pgPlayer, "Ambient Vignette")
	local avEnabled = avSec:Toggle({ Name = "Enabled", Default = false, Flag = "av_enabled" })
	local avColor = newColorpicker(avSec, { Name = "Color", Default = Color3.fromRGB(0, 0, 0), Alpha = 1, Flag = "av_color" })
	local avSettings = settingsOf(avSec, avEnabled)
	local avIntensity = avSettings:Slider({ Name = "Intensity", Min = 5, Max = 100, Step = 5, Default = 40, Suffix = "%", Flag = "av_intensity" })

	local function makeEdge()
		local f = Instance.new("Frame")
		f.BorderSizePixel = 0
		f.BackgroundColor3 = Color3.new(0, 0, 0)
		f.Visible = false
		local grad = Instance.new("UIGradient")
		grad.Parent = f
		f.Parent = screen
		return f, grad
	end
	local topF, topG = makeEdge()
	local botF, botG = makeEdge()
	local leftF, leftG = makeEdge()
	local rightF, rightG = makeEdge()

	topF.Size = UDim2.new(1, 0, 0.22, 0); topF.Position = UDim2.new(0, 0, 0, 0)
	topG.Rotation = 90
	botF.Size = UDim2.new(1, 0, 0.22, 0); botF.Position = UDim2.new(0, 0, 1, 0); botF.AnchorPoint = Vector2.new(0, 1)
	botG.Rotation = -90
	leftF.Size = UDim2.new(0.16, 0, 1, 0); leftF.Position = UDim2.new(0, 0, 0, 0)
	leftG.Rotation = 0
	rightF.Size = UDim2.new(0.16, 0, 1, 0); rightF.Position = UDim2.new(1, 0, 0, 0); rightF.AnchorPoint = Vector2.new(1, 0)
	rightG.Rotation = 180

	table.insert(cleanups, function()
		topF:Destroy(); botF:Destroy(); leftF:Destroy(); rightF:Destroy()
	end)

	local rsAv = RunService.Heartbeat:Connect(function()
		local on = avEnabled:Get()
		topF.Visible = on; botF.Visible = on; leftF.Visible = on; rightF.Visible = on
		if not on then return end
		local col = avColor:Get()
		local intensity = avIntensity:Get() / 100
		local edgePairs = { { topF, topG }, { botF, botG }, { leftF, leftG }, { rightF, rightG } }
		for _, pair in ipairs(edgePairs) do
			local f, g = pair[1], pair[2]
			f.BackgroundColor3 = col
			g.Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1 - intensity),
				NumberSequenceKeypoint.new(1, 1),
			})
		end
	end)
	table.insert(cleanups, function() rsAv:Disconnect() end)

	CFG.toggles.av_enabled = avEnabled
	CFG.sliders.av_intensity = avIntensity
	CFG.colors.av_color = avColor
end

----------------------------------------------------------------------------------
-- SECTION 5z4: Idle Sparkles
----------------------------------------------------------------------------------
do
	local isSec = newSection(pgPlayer, "Idle Sparkles")
	local isEnabled = isSec:Toggle({ Name = "Enabled", Default = false, Flag = "is_enabled" })
	local isColor = newColorpicker(isSec, { Name = "Color", Default = Color3.fromRGB(255, 240, 180), Alpha = 1, Flag = "is_color" })
	local isSettings = settingsOf(isSec, isEnabled)
	local isDelay = isSettings:Slider({ Name = "Idle delay", Min = 1, Max = 20, Step = 1, Default = 3, Suffix = "ds", Flag = "is_delay" })
	local isRate  = isSettings:Slider({ Name = "Rate", Min = 1, Max = 20, Step = 1, Default = 4, Flag = "is_rate" })

	local isFolder = Instance.new("Folder")
	isFolder.Name = "MisanthropyIdleSparkles"
	isFolder.Parent = Workspace
	table.insert(cleanups, function() if isFolder then isFolder:Destroy() end end)

	local isPart = Instance.new("Part")
	isPart.Name = "IdleSparkleSource"
	isPart.Anchored = true; isPart.CanCollide = false; isPart.CanQuery = false; isPart.CanTouch = false; isPart.CastShadow = false
	isPart.Transparency = 1; isPart.Size = Vector3.new(2, 4, 2)
	isPart.Parent = isFolder

	local isEmitter = Instance.new("ParticleEmitter")
	isEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
	isEmitter.Enabled = false
	isEmitter.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.15), NumberSequenceKeypoint.new(1, 0) })
	isEmitter.Lifetime = NumberRange.new(0.6, 1.2)
	isEmitter.Speed = NumberRange.new(0.2, 0.8)
	isEmitter.SpreadAngle = Vector2.new(180, 180)
	isEmitter.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.1), NumberSequenceKeypoint.new(1, 1) })
	isEmitter.LightEmission = 1
	isEmitter.Parent = isPart

	local isStationary = 0
	local isLastPos: Vector3? = nil
	local rsIs = RunService.Heartbeat:Connect(function(dt: number)
		local root = getRootPart()
		if not isEnabled:Get() or not root then
			isEmitter.Enabled = false
			isStationary = 0; isLastPos = nil
			return
		end
		local pos = root.Position
		local moving = isLastPos and (pos - isLastPos).Magnitude > 0.03
		isLastPos = pos
		if moving then isStationary = 0 else isStationary += dt end
		isPart.CFrame = CFrame.new(pos)
		local delay = isDelay:Get() / 10
		local active = isStationary >= delay
		isEmitter.Enabled = active
		if active then
			isEmitter.Rate = isRate:Get()
			isEmitter.Color = ColorSequence.new(isColor:Get())
		end
	end)
	table.insert(cleanups, function() rsIs:Disconnect() end)

	CFG.toggles.is_enabled = isEnabled
	CFG.sliders.is_delay = isDelay; CFG.sliders.is_rate = isRate
	CFG.colors.is_color = isColor
end

----------------------------------------------------------------------------------
-- SECTION 5z6: Camera Breathing
----------------------------------------------------------------------------------
do
	local cmSec = newSection(pgPlayer, "Camera Breathing")
	local cmEnabled = cmSec:Toggle({ Name = "Enabled", Default = false, Flag = "cm_enabled" })
	local cmSettings = settingsOf(cmSec, cmEnabled)
	local cmIntensity = cmSettings:Slider({ Name = "Intensity", Min = 1, Max = 20, Step = 1, Default = 4, Flag = "cm_intensity" })
	local cmSpeed     = cmSettings:Slider({ Name = "Speed", Min = 5, Max = 100, Step = 5, Default = 25, Suffix = "%", Flag = "cm_speed" })

	local cmBaseFov: number? = nil
	local rsCm = RunService.RenderStepped:Connect(function()
		local cam = Workspace.CurrentCamera
		if not cmEnabled:Get() or not cam then
			if cmBaseFov and cam then cam.FieldOfView = cmBaseFov end
			cmBaseFov = nil
			return
		end
		if not cmBaseFov then cmBaseFov = cam.FieldOfView end
		local t = os.clock() * (cmSpeed:Get() / 100)
		cam.FieldOfView = (cmBaseFov :: number) + math.sin(t) * (cmIntensity:Get() / 10)
	end)
	table.insert(cleanups, function()
		rsCm:Disconnect()
		local cam = Workspace.CurrentCamera
		if cmBaseFov and cam then cam.FieldOfView = cmBaseFov end
	end)

	CFG.toggles.cm_enabled = cmEnabled
	CFG.sliders.cm_intensity = cmIntensity; CFG.sliders.cm_speed = cmSpeed
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
-- SECTION 6b: Watermark
----------------------------------------------------------------------------------
do
	-- Never call watermark:SetText() - it clears the provider and re-enables the broken os.date default.
	local wmSec = newSection(pgConfigs, "Watermark")
	local watermark = Library:Watermark({ Name = "misanthropy.lua" })

	local wmEnabled = wmSec:Toggle({
		Name = "Show watermark",
		Default = true,
		Flag = "wm_enabled",
		Callback = function(v: boolean)
			pcall(function() watermark:SetVisibility(v) end)
		end,
	})

	local wmSettings = settingsOf(wmSec, wmEnabled)
	local wmText = newTextInput(wmSettings, {
		Name = "Watermark text",
		Default = "misanthropy.lua",
		Placeholder = "misanthropy.lua",
		Flag = "wm_text",
	})
	local wmShowFps = wmSettings:Toggle({ Name = "Show FPS", Default = false, Flag = "wm_fps" })

	pcall(function()
		watermark:SetDynamicTextProvider(function(fps: number)
			local text = wmText:Get()
			if type(text) ~= "string" or text == "" then
				text = "misanthropy.lua"
			end
			if wmShowFps:Get() then
				return text .. " / " .. tostring(fps) .. "fps"
			end
			return text
		end)
	end)

	table.insert(cleanups, function()
		pcall(function() watermark:SetVisibility(false) end)
	end)

	CFG.toggles.wm_enabled = wmEnabled
	CFG.toggles.wm_fps = wmShowFps
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
