local HttpService = game:GetService("HttpService")

local InterfaceManager = {} do
	InterfaceManager.Folder = "HighlightHub"
    InterfaceManager.Settings = {
        Theme = "Darker",
        Acrylic = false,
        Transparency = false,
		ToggleUiButton = true,
		AutoMinimize = false,
        MenuKeybind = "LeftControl"
    }

    function InterfaceManager:SetFolder(folder)
		self.Folder = folder;
		self:BuildFolderTree()
	end

    function InterfaceManager:SetLibrary(library)
		self.Library = library
	end

    function InterfaceManager:BuildFolderTree()
		local paths = {}

		local parts = self.Folder:split("/")
		for idx = 1, #parts do
			paths[#paths + 1] = table.concat(parts, "/", 1, idx)
		end

		table.insert(paths, self.Folder)
		table.insert(paths, self.Folder .. "/settings")

		for i = 1, #paths do
			local str = paths[i]
			if not isfolder(str) then
				makefolder(str)
			end
		end
	end

    function InterfaceManager:SaveSettings()
        writefile(self.Folder .. "/options.json", HttpService:JSONEncode(InterfaceManager.Settings))
    end

    function InterfaceManager:LoadSettings()
        local path = self.Folder .. "/options.json"
        if isfile(path) then
            local data = readfile(path)
            local success, decoded = pcall(HttpService.JSONDecode, HttpService, data)

            if success then
                for i, v in next, decoded do
                    InterfaceManager.Settings[i] = v
                end
            end
        end
    end

    function InterfaceManager:BuildInterfaceSection(tab)
        assert(self.Library, "Must set InterfaceManager.Library")
		local Library = self.Library
        local Settings = InterfaceManager.Settings

		local ToggleUI = nil
		function ToggleUi(toggle)
			if toggle then
				ToggleUI = Instance.new("ScreenGui")
				ToggleUI.Name = "HL Toggle"
				ToggleUI.Parent = game:GetService("CoreGui")
			
				local Button = Instance.new("TextButton")
				Button.TextTransparency = 1
				Button.BorderSizePixel = 0
				Button.Position = UDim2.new(0, 0, 0, 0)
				Button.Size = UDim2.new(0.031, 0, 0.06, 0)
				Button.Parent = ToggleUI
			
				local ImageLabel = Instance.new("ImageLabel")
				ImageLabel.Name = "ImageLabel"
				ImageLabel.BackgroundTransparency = 1
				ImageLabel.Size = UDim2.new(1, 0, 1, 0)
				ImageLabel.Image = "rbxassetid://14529410392"
				ImageLabel.Parent = Button
			
				local UICorner = Instance.new("UICorner")
				UICorner.CornerRadius = UDim.new(1, 0)
				UICorner.Parent = Button
				UICorner:Clone().Parent = ImageLabel
			
				local dragging
				local dragInput
				local dragStart
				local startPos
			
				local function update(input)
					local delta = input.Position - dragStart
					Button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
				end
			
				local Toggle = false
				Button.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = true
						dragStart = input.Position
						startPos = Button.Position
						input.Changed:Connect(function()
							if input.UserInputState == Enum.UserInputState.End then
								dragging = false
							end
						end)
					end
				end)
			
				Button.InputChanged:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
						dragInput = input
					end
				end)
			
				game:GetService("UserInputService").InputChanged:Connect(function(input)
					if input == dragInput and dragging then
						update(input)
					end
				end)
			
				Button.MouseButton1Click:Connect(function()
					Toggle = not Toggle
					if Toggle then
						print("Minimize")
						Library.Window:Minimize()
						Toggle = false
					end
				end)
			else
				if ToggleUI then
					ToggleUI:Destroy()
				end
			end
		end

        InterfaceManager:LoadSettings()

		local section = tab:AddSection("Interface")

		local InterfaceTheme = section:AddDropdown("InterfaceTheme", {
			Title = "Theme",
			Values = Library.Themes,
			Default = Settings.Theme,
			Callback = function(Value)
				Library:SetTheme(Value)
                Settings.Theme = Value
                InterfaceManager:SaveSettings()
			end
		})

        InterfaceTheme:SetValue(Settings.Theme)
	
		if Library.UseAcrylic then
			section:AddToggle("AcrylicToggle", {
				Title = "Acrylic",
				Description = "The blurred background requires graphic quality 8+",
				Default = Settings.Acrylic,
				Callback = function(Value)
					Library:ToggleAcrylic(Value)
                    Settings.Acrylic = Value
                    InterfaceManager:SaveSettings()
				end
			})
		end
	
		section:AddToggle("TransparentToggle", {
			Title = "Transparency",
			Description = "Makes the interface transparent.",
			Default = Settings.Transparency,
			Callback = function(Value)
				Library:ToggleTransparency(Value)
				Settings.Transparency = Value
                InterfaceManager:SaveSettings()
			end
		})

		section:AddToggle("ToggleUiButtonToggle", {
			Title = "Toggle Ui Button",
			Default = Settings.ToggleUiButton,
			Callback = function(Value)
				Settings.ToggleUiButton = Value
				ToggleUi(Settings.ToggleUiButton)
                InterfaceManager:SaveSettings()
			end
		})

		section:AddToggle("AutoMinimizeToggle", {
			Title = "Auto Minimize",
			Description = "Minimize the ui after loading it.",
			Default = Settings.AutoMinimize,
			Callback = function(Value)
				Settings.AutoMinimize = Value
                InterfaceManager:SaveSettings()
			end
		})

		if Settings.AutoMinimize then
			Library.Window:Minimize()
		end
	
		local MenuKeybind = section:AddKeybind("MenuKeybind", { Title = "Minimize Bind", Default = Settings.MenuKeybind })
		MenuKeybind:OnChanged(function()
            if not MenuKeybind.Value or MenuKeybind.Value == "Unknown" then
                return
            end
			Settings.MenuKeybind = MenuKeybind.Value
            InterfaceManager:SaveSettings()
		end)
		Library.MinimizeKeybind = MenuKeybind
    end
end

return InterfaceManager
