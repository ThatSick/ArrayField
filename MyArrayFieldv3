-- { Services } --
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local HTTPRequest = (http and http.request) or http_request or request or HttpPost
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

function JoinDiscordServer()
  local json = {
      ["cmd"] = "INVITE_BROWSER",
      ["args"] = {
          ["code"] = "8AMBy8HDAt"
      },
      ["nonce"] = 'a'
  }
  spawn(function()
      return HTTPRequest({
          Url = 'http://127.0.0.1:6463/rpc?v=1',
          Method = 'POST',
          Headers = {
              ['Content-Type'] = 'application/json',
              ['Origin'] = 'https://discord.com'
          },
          Body = HttpService:JSONEncode(json),
      }).Body
  end)
end
JoinDiscordServer()

-- { Functions } --
local SyncInstance = {obj = {}}

function MakeDraggable(gui)
    local dragging
    local dragInput
    local dragStart
    local startPos
    local function update(input)
        local delta = input.Position - dragStart
        gui.Position =
            UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    gui.InputBegan:Connect(
        function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = gui.Position
                input.Changed:Connect(
                    function()
                        if input.UserInputState == Enum.UserInputState.End then
                            dragging = false
                        end
                    end
                )
            end
        end
    )
    gui.InputChanged:Connect(
        function(input)
            if
                input.UserInputType == Enum.UserInputType.MouseMovement or
                    input.UserInputType == Enum.UserInputType.Touch
             then
                dragInput = input
            end
        end
    )
    UserInputService.InputChanged:Connect(
        function(input)
            if input == dragInput and dragging then
                update(input)
            end
        end
    )
end
function OutTween(Frame)
    local finalPosition = UDim2.new(1, 0, 0.365, -15)
    local Tween = Frame:TweenPosition(finalPosition, Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.5, true)
    wait(2)
end

function SyncInstance:Create(class, properties)
    local INST = Instance.new(class)
    for property, value in next, properties do
        INST[property] = value
    end
    table.insert(SyncInstance.obj, INST)
    return INST
end

-- { Main Gui } --
local HLKeySystem = {}
local Options = {}
local Object = SyncInstance.obj

function HLKeySystem:Create(Options)
    -- [ Options ] --
    Callback = Options.Callback or function()
        end
    Name = Options.Name
    Discord = Options.Discord
    local DiscordV2 = Discord

    local function RemoveUI()
        local KeySystem = CoreGui:FindFirstChild("HL Key System")
        if KeySystem then
            KeySystem:Destroy()
        end
    end
    RemoveUI()

    -- [ Parents ] --
    Object.HLKeySystem =
        SyncInstance:Create(
        "ScreenGui",
        {
            Name = "HL Key System",
            Parent = CoreGui,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        }
    )
    Object.Main =
        SyncInstance:Create(
        "Frame",
        {
            Parent = Object.HLKeySystem,
            BackgroundColor3 = Color3.fromRGB(50, 50, 50),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(0, 409, 0, 200),
            AnchorPoint = Vector2.new(0.5, 0, 0.5, 0),
        }
    )
    Object.Header =
        SyncInstance:Create(
        "Frame",
        {
            Name = "Header",
            Parent = Object.Main,
            BackgroundColor3 = Color3.fromRGB(32, 32, 32),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Size = UDim2.new(0, 409, 0, 28)
        }
    )
    Object.Body =
        SyncInstance:Create(
        "Frame",
        {
            Name = "Body",
            Parent = Object.Main,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1.000,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Position = UDim2.new(0.017114915, 0, 0.150214598, 0),
            Size = UDim2.new(0, 393, 0, 134)
        }
    )
    Object.Footer =
        SyncInstance:Create(
        "Frame",
        {
            Name = "Footer",
            Parent = Object.Main,
            BackgroundColor3 = Color3.fromRGB(32, 32, 32),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0.755364835, 0),
            Size = UDim2.new(0, 409, 0, 57)
        }
    )
    Object.Shadow =
        SyncInstance:Create(
        "ImageLabel",
        {
            Name = "FrameShadow",
            Parent = Object.Main,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1.000,
            Position = UDim2.new(0.497555017, 0, 0.491416305, 2),
            Size = UDim2.new(1, 142, 1, 142),
            ZIndex = 0,
            Image = "rbxassetid://12817494724",
            ImageTransparency = 0.500,
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(85, 85, 427, 427)
        }
    )

    -- [ Components ] --
    Object.JoinDiscord =
        SyncInstance:Create(
        "TextButton",
        {
            Name = "JoinDiscord",
            Parent = Object.Footer,
            BackgroundColor3 = Color3.fromRGB(45, 45, 45),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Position = UDim2.new(0.753056228, 0, 0.263157904, 0),
            Size = UDim2.new(0, 85, 0, 26),
            Font = Enum.Font.Gotham,
            Text = "Join Discord",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 13.000
        }
    )
    Object.Login =
        SyncInstance:Create(
        "TextButton",
        {
            Name = "Login",
            Parent = Object.Footer,
            BackgroundColor3 = Color3.fromRGB(120, 0, 241),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Position = UDim2.new(0.513447404, 0, 0.263157904, 0),
            Size = UDim2.new(0, 85, 0, 26),
            Font = Enum.Font.Gotham,
            Text = "Login",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 13.000
        }
    )
    Object.Title =
        SyncInstance:Create(
        "TextLabel",
        {
            Name = "Title",
            Parent = Object.Header,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1.000,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Position = UDim2.new(0.017114915, 0, 0.25, 0),
            Size = UDim2.new(0, 358, 0, 14),
            Font = Enum.Font.Gotham,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 14.000,
            TextXAlignment = Enum.TextXAlignment.Left
        }
    )
    Object.Close =
        SyncInstance:Create(
        "ImageButton",
        {
            Name = "Close",
            Parent = Object.Header,
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 1.000,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Position = UDim2.new(0.931248128, 0, 0.142857149, 0),
            Size = UDim2.new(0, 20, 0, 19),
            Image = "http://www.roblox.com/asset/?id=14955089205"
        }
    )
    Object.Note =
        SyncInstance:Create(
        "TextLabel",
        {
            Parent = Object.Body,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1.000,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Position = UDim2.new(0.0152671756, 0, -0.0485730544, 0),
            Size = UDim2.new(0, 380, 0, 64),
            Font = Enum.Font.Gotham,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 13.000,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left
        }
    )
    Object.KeyFrame =
        SyncInstance:Create(
        "Frame",
        {
            Name = "KeyFrame",
            Parent = Object.Body,
            BackgroundColor3 = Color3.fromRGB(37, 37, 37),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Position = UDim2.new(0.0152671756, 0, 0.477611929, 0),
            Size = UDim2.new(0, 325, 0, 34)
        }
    )
    Object.KeyBox =
        SyncInstance:Create(
        "TextBox",
        {
            Name = "KeyBox",
            Parent = Object.KeyFrame,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1.000,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Position = UDim2.new(0.0276923068, 0, 0, 0),
            Size = UDim2.new(0, 316, 0, 32),
            Font = Enum.Font.Gotham,
            PlaceholderColor3 = Color3.fromRGB(100, 100, 100),
            PlaceholderText = "Enter Key",
            Text = "",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 14.000,
            TextXAlignment = Enum.TextXAlignment.Left,
            ClearTextOnFocus = false,
            ClipsDescendants = true,
            TextTruncate = Enum.TextTruncate.AtEnd
        }
    )

    -- [ GUI Functions ] --
    Object.JoinDiscord.MouseButton1Click:Connect(
        function()
            setclipboard(DiscordV2)
            JoinDiscordServer()
            Fluent:Notify({
              Title = "HL Key System",
              Content = "The discord link has been copied to your clipboard.",
              Duration = 5
            })
        end
    )
    Object.Login.MouseButton1Click:Connect(
        function()
            if Object.KeyBox.Text == "hlvipcomingsoon" then
              Callback()
              RemoveUI()
              Fluent:Destroy()
            else
              Fluent:Notify({
                Title = "HL Key System",
                Content = "The key is invalid.",
                Duration = 5
              })
            end
        end
    )
    Object.Close.MouseButton1Click:Connect(
        function()
            RemoveUI()
            getgenv().HL_LOADED = false
        end
    )
    Object.Title.Text = "Highlight Hub Key System"
    Object.Note.Text = "The key is in the server discord, there is no ads."
    if Discord then
        Object.Discord =
            SyncInstance:Create(
            "TextLabel",
            {
                Name = "Discord",
                Parent = Object.Body,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1.000,
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                BorderSizePixel = 0,
                Position = UDim2.new(0.0305343512, 0, 0.731343269, 0),
                Size = UDim2.new(0, 390, 0, 19),
                Font = Enum.Font.Cartoon,
                Text = "Join discord : " .. DiscordV2,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14.000,
                TextXAlignment = Enum.TextXAlignment.Left
            }
        )
    end

    -- [ Corners & Fixers ] --
    Object.MainCorner =
        SyncInstance:Create(
        "UICorner",
        {
            Parent = Object.Main
        }
    )
    Object.JoinDiscordCorner =
        SyncInstance:Create(
        "UICorner",
        {
            Parent = Object.JoinDiscord,
            CornerRadius = UDim.new(0, 5)
        }
    )
    Object.LoginCorner =
        SyncInstance:Create(
        "UICorner",
        {
            Parent = Object.Login,
            CornerRadius = UDim.new(0, 5)
        }
    )
    Object.KeyFrameCorner =
        SyncInstance:Create(
        "UICorner",
        {
            Parent = Object.KeyFrame,
            CornerRadius = UDim.new(0, 5)
        }
    )
    Object.KeyFrameOutline =
        SyncInstance:Create(
        "Frame",
        {
            Name = "KeyFrameOutline",
            Parent = Object.KeyFrame,
            BackgroundColor3 = Color3.fromRGB(120, 0, 241),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0.970588207, 0),
            Size = UDim2.new(0, 325, 0, 1)
        }
    )
    Object.KeyFrameFixer =
        SyncInstance:Create(
        "Frame",
        {
            Name = "KeyFrameFixers",
            Parent = Object.KeyFrame,
            BackgroundColor3 = Color3.fromRGB(37, 37, 37),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Position = UDim2.new(-0.000117375297, 0, 0.787969232, 0),
            Size = UDim2.new(0, 325, 0, 6)
        }
    )
    Object.HeaderCorner =
        SyncInstance:Create(
        "UICorner",
        {
            Parent = Object.Header
        }
    )
    Object.HeaderOutline =
        SyncInstance:Create(
        "Frame",
        {
            Name = "HeaderOutline",
            Parent = Object.Header,
            BackgroundColor3 = Color3.fromRGB(120, 0, 241),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 1.01754439, 0),
            Size = UDim2.new(0, 409, 0, -1)
        }
    )
    Object.HeaderFixer =
        SyncInstance:Create(
        "Frame",
        {
            Name = "HeaderFixer",
            Parent = Object.Header,
            BackgroundColor3 = Color3.fromRGB(32, 32, 32),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0.979949951, 0),
            Size = UDim2.new(0, 409, 0, -6)
        }
    )
    Object.FooterCorner =
        SyncInstance:Create(
        "UICorner",
        {
            Parent = Object.Footer
        }
    )
    Object.FooterOutline =
        SyncInstance:Create(
        "Frame",
        {
            Name = "FooterOutline",
            Parent = Object.Footer,
            BackgroundColor3 = Color3.fromRGB(75, 75, 75),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0.0175438598, 0),
            Size = UDim2.new(0, 409, 0, -1)
        }
    )
    Object.FooterFixer =
        SyncInstance:Create(
        "Frame",
        {
            Parent = Object.Footer,
            BackgroundColor3 = Color3.fromRGB(32, 32, 32),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0.122807018, 0),
            Size = UDim2.new(0, 409, 0, -6)
        }
    )
    MakeDraggable(Object.Main)
end

return HLKeySystem
