local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local M = {}

local function createButton(name: string, text: string)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Text = text
	btn.Size = UDim2.new(0.45, 0, 1, 0)
	btn.BackgroundColor3 = Color3.fromRGB(20, 0, 40)
	btn.Transparency = 0.2
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextSize = 14
	btn.Font = Enum.Font.GothamSemibold
	btn.AutoButtonColor = false
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

	local neonStroke = Instance.new("UIStroke")
	neonStroke.Parent = btn
	neonStroke.Thickness = 1.2
	neonStroke.Color = Color3.fromRGB(191, 64, 255)
	neonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	local g = Instance.new("UIGradient", neonStroke)
	g.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(170, 0, 255)),
	}
	g.Rotation = 45

	return btn
end

export type MountOpts = {
	onVerify: (key: string, setStatus: (text: string)->(), destroy: ()->()) -> (),
	onGetKey: (() -> ())?,
	getKeyText: string?,
	logoAssetId: string?,
	titleText: string?,
}

function M.mount(opts: MountOpts)
	assert(typeof(opts) == "table" and typeof(opts.onVerify) == "function", "onVerify required")

	local gui = Instance.new("ScreenGui")
	gui.Name = "HighlightKeyUI"
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.DisplayOrder = 1000
	gui.ResetOnSpawn = false
	gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

	local frame = Instance.new("Frame")
	frame.Name = "KeyFrame"
	frame.Size = UDim2.new(0, 280, 0, 175)
	frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.BackgroundColor3 = Color3.fromRGB(10, 0, 20)
	frame.BackgroundTransparency = 1
	frame.Parent = gui
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

	local stroke = Instance.new("UIStroke", frame)
	stroke.Color = Color3.fromRGB(191, 64, 255)
	stroke.Thickness = 1.2
	local gradient = Instance.new("UIGradient", stroke)
	gradient.Rotation = 45
	gradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(170, 0, 255)),
	}

	TweenService:Create(frame, TweenInfo.new(0.35), { BackgroundTransparency = 0.1 }):Play()

	local closeBtn = Instance.new("TextButton")
	closeBtn.Size = UDim2.new(0, 24, 0, 24)
	closeBtn.Position = UDim2.new(1, -28, 0, 4)
	closeBtn.BackgroundColor3 = Color3.fromRGB(10, 0, 20)
	closeBtn.Text = "X"
	closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.TextSize = 14
	closeBtn.BackgroundTransparency = 0.1
	closeBtn.AutoButtonColor = false
	closeBtn.Parent = frame
	Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

	local function destroy()
		if gui and gui.Parent then gui:Destroy() end
	end
	closeBtn.MouseButton1Click:Connect(destroy)

	local logo = Instance.new("ImageLabel")
	logo.Size = UDim2.new(0, 30, 0, 30)
	logo.Position = UDim2.new(0, 8, 0, 8)
	logo.BackgroundTransparency = 1
	logo.Image = ("rbxassetid://%s"):format((opts.logoAssetId or "14529410392"):gsub("rbxassetid://",""))
	logo.ImageTransparency = 0.1
	logo.Parent = frame

	local title = Instance.new("TextLabel")
	title.Text = opts.titleText or "Highlight Hub - Key System"
	title.Position = UDim2.new(0, 45, 0, 10)
	title.Size = UDim2.new(1, -50, 0, 22)
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.GothamBold
	title.TextSize = 13
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = frame

	local input = Instance.new("TextBox")
	input.PlaceholderText = "Enter your key here..."
	input.Size = UDim2.new(0.9, 0, 0, 38)
	input.Position = UDim2.new(0.05, 0, 0.35, 0)
	input.TextColor3 = Color3.fromRGB(255, 255, 255)
	input.BackgroundColor3 = Color3.fromRGB(20, 0, 50)
	input.Transparency = 0.2
	input.ClearTextOnFocus = false
	input.TextSize = 13
	input.Font = Enum.Font.Gotham
	input.Text = ""
	input.Parent = frame
	Instance.new("UICorner", input).CornerRadius = UDim.new(0, 6)

	local inputStroke = Instance.new("UIStroke", input)
	inputStroke.Color = Color3.fromRGB(191, 64, 255)
	inputStroke.Thickness = 1.1
	inputStroke.Transparency = 0.2
	inputStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	local inputGradient = Instance.new("UIGradient", inputStroke)
	inputGradient.Rotation = 45
	inputGradient.Color = gradient.Color

	local statusText = Instance.new("TextLabel")
	statusText.Size = UDim2.new(1, 0, 0, 18)
	statusText.Position = UDim2.new(0, 0, 0.6, 0)
	statusText.BackgroundTransparency = 1
	statusText.TextColor3 = Color3.fromRGB(255, 255, 255)
	statusText.Text = ""
	statusText.TextSize = 12
	statusText.Font = Enum.Font.Gotham
	statusText.TextXAlignment = Enum.TextXAlignment.Center
	statusText.Parent = frame

	local btnContainer = Instance.new("Frame")
	btnContainer.Size = UDim2.new(1, 0, 0, 38)
	btnContainer.Position = UDim2.new(0, 0, 0.73, 0)
	btnContainer.BackgroundTransparency = 1
	btnContainer.Parent = frame

	local verifyBtn = createButton("VerifyBtn", "Verify")
	verifyBtn.Position = UDim2.new(0.05, 0, 0, 0)
	verifyBtn.Parent = btnContainer

	local getKeyBtn = createButton("GetKeyBtn", "Get Key")
	getKeyBtn.Position = UDim2.new(0.5, 6, 0, 0)
	getKeyBtn.Parent = btnContainer

	local function setStatus(text: string) statusText.Text = text or "" end
	local function setKey(k: string) input.Text = k or "" end

	local dragging = false
	local offset
	local startPos
	frame.InputBegan:Connect(function(io)
		if io.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			offset = io.Position
			startPos = frame.Position
		end
	end)
	UIS.InputEnded:Connect(function(io)
		if io.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
	UIS.InputChanged:Connect(function(io)
		if dragging and io.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = io.Position - offset
			local goal = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			TweenService:Create(frame, TweenInfo.new(0.07), { Position = goal }):Play()
		end
	end)

	verifyBtn.MouseButton1Click:Connect(function()
		local key = input.Text or ""
		task.spawn(function() opts.onVerify(key, setStatus, destroy) end)
	end)

	getKeyBtn.MouseButton1Click:Connect(function()
		if typeof(opts.onGetKey) == "function" then
			opts.onGetKey()
			return
		end
		local text = opts.getKeyText or "Get your key on the website."
		if setclipboard then
			setclipboard(text)
			getKeyBtn.Text = "Copied!"
			setStatus(text)
			task.delay(1.2, function() getKeyBtn.Text = "Get Key" end)
		else
			setStatus(text)
		end
	end)

	return { destroy = destroy, setStatus = setStatus, setKey = setKey }
end

return M
