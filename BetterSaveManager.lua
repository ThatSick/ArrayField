local httpService = game:GetService("HttpService")

local SaveManager = {} do
	SaveManager.Folder = "HighlightHub"
	SaveManager.AutoSavePath = SaveManager.Folder .. "/AutoSaveEnabled.txt"
	SaveManager.Ignore = {}
	SaveManager.AutoSaveEnabled = true
	SaveManager.Parser = {
		Toggle = {
			Save = function(idx, object) 
				return { type = "Toggle", idx = idx, value = object.Value } 
			end,
			Load = function(idx, data)
				if SaveManager.Options[idx] then 
					SaveManager.Options[idx]:SetValue(data.value)
				end
			end,
		},
		Slider = {
			Save = function(idx, object)
				return { type = "Slider", idx = idx, value = tostring(object.Value) }
			end,
			Load = function(idx, data)
				if SaveManager.Options[idx] then 
					SaveManager.Options[idx]:SetValue(data.value)
				end
			end,
		},
		Dropdown = {
			Save = function(idx, object)
				return { type = "Dropdown", idx = idx, value = object.Value, mutli = object.Multi }
			end,
			Load = function(idx, data)
				if SaveManager.Options[idx] then 
					SaveManager.Options[idx]:SetValue(data.value)
				end
			end,
		},
		Colorpicker = {
			Save = function(idx, object)
				return { type = "Colorpicker", idx = idx, value = object.Value:ToHex(), transparency = object.Transparency }
			end,
			Load = function(idx, data)
				if SaveManager.Options[idx] then 
					SaveManager.Options[idx]:SetValueRGB(Color3.fromHex(data.value), data.transparency)
				end
			end,
		},
		Keybind = {
			Save = function(idx, object)
				return { type = "Keybind", idx = idx, mode = object.Mode, key = object.Value }
			end,
			Load = function(idx, data)
				if SaveManager.Options[idx] then 
					SaveManager.Options[idx]:SetValue(data.key, data.mode)
				end
			end,
		},

		Input = {
			Save = function(idx, object)
				return { type = "Input", idx = idx, text = object.Value }
			end,
			Load = function(idx, data)
				if SaveManager.Options[idx] and type(data.text) == "string" then
					SaveManager.Options[idx]:SetValue(data.text)
				end
			end,
		},
	}

	function SaveManager:SetIgnoreIndexes(list)
		for _, key in next, list do
			self.Ignore[key] = true
		end
	end

	function SaveManager:SetFolder(folder)
		self.Folder = folder;
		self:BuildFolderTree()
		self:CreateDefaultIfNeeded()
	end

	function SaveManager:Save(name)
		if (not name) then
			return false, "no config file is selected"
		end

		local fullPath = self.Folder .. "/settings/" .. name .. ".json"

		local data = {
			objects = {}
		}

		for idx, option in next, SaveManager.Options do
			if not self.Parser[option.Type] then continue end
			if self.Ignore[idx] then continue end

			table.insert(data.objects, self.Parser[option.Type].Save(idx, option))
		end	

		local success, encoded = pcall(httpService.JSONEncode, httpService, data)
		if not success then
			return false, "failed to encode data"
		end

		writefile(fullPath, encoded)
		return true
	end

	function SaveManager:AutoSave()
		if not SaveManager.AutoSaveEnabled then
			return
		end
	
		if SaveManager.Options and SaveManager.Options.SaveManager_ConfigList then
			local name = SaveManager.Options.SaveManager_ConfigList.Value
			if name and name ~= "" then
				local success, err = self:Save(name)
				if not success then
					warn("Auto-save failed: " .. tostring(err))
				end
			end
		end
	end	

	function SaveManager:Load(name)
		if not name then
			return false, "no config file is selected"
		end

		local previousAutoSave = SaveManager.AutoSaveEnabled
		SaveManager.AutoSaveEnabled = false
	
		local file = self.Folder .. "/settings/" .. name .. ".json"
		if not isfile(file) then 
			SaveManager.AutoSaveEnabled = previousAutoSave
			return false, "invalid file"
		end
	
		local success, decoded = pcall(httpService.JSONDecode, httpService, readfile(file))
		if not success then
			SaveManager.AutoSaveEnabled = previousAutoSave
			return false, "decode error"
		end
	
		for _, option in next, decoded.objects do
			if self.Parser[option.type] then
				task.spawn(function() 
					self.Parser[option.type].Load(option.idx, option) 
				end)
			end
		end

		SaveManager.AutoSaveEnabled = previousAutoSave
		return true
	end	

	function SaveManager:IgnoreThemeSettings()
		self:SetIgnoreIndexes({ 
			"InterfaceTheme", "AcrylicToggle", "TransparentToggle", "MenuKeybind"
		})
	end

    function SaveManager:BuildFolderTree()
        local paths = {
            self.Folder,
            self.Folder .. "/settings"
        }
    
        for i = 1, #paths do
            local str = paths[i]
            if not isfolder(str) then
                makefolder(str)
            end
        end
        
        if isfile(SaveManager.AutoSavePath) then
            SaveManager.AutoSaveEnabled = readfile(SaveManager.AutoSavePath) == "true"
        else
            SaveManager.AutoSaveEnabled = true
            writefile(SaveManager.AutoSavePath, "true")
        end
    end    

	function SaveManager:CreateDefaultIfNeeded()
		local defaultConfigPath = self.Folder .. "/settings/Default.json"
		local autoloadPath = self.Folder .. "/settings/autoload.txt"
	
		if not isfile(defaultConfigPath) then
			self:Save("Default")
		end
	
		if not isfile(autoloadPath) then
			writefile(autoloadPath, "Default")
		end
	end

	function SaveManager:RefreshConfigList()
		local list = listfiles(self.Folder .. "/settings")

		local out = {}
		for i = 1, #list do
			local file = list[i]
			if file:sub(-5) == ".json" then
				local pos = file:find(".json", 1, true)
				local start = pos

				local char = file:sub(pos, pos)
				while char ~= "/" and char ~= "\\" and char ~= "" do
					pos = pos - 1
					char = file:sub(pos, pos)
				end

				if char == "/" or char == "\\" then
					local name = file:sub(pos + 1, start - 1)
					if name ~= "UiSettings" then
						table.insert(out, name)
					end
				end
			end
		end
		
		return out
	end

	function SaveManager:SetLibrary(library)
		self.Library = library
		self.Options = library.Options
	end

	function SaveManager:LoadAutoloadConfig()
		if isfile(self.Folder .. "/settings/autoload.txt") then
			local name = readfile(self.Folder .. "/settings/autoload.txt")

			local success, err = self:Load(name)
			if not success then
				return self.Library:Notify({
					Title = "Configuration",
					Content = "Failed to load autoload config: " .. err,
					Duration = 5
				})
			end

			self.Library:Notify({
				Title = "Configuration",
				Content = string.format("Auto loaded config %q", name),
				Duration = 5
			})
		end
	end

	function SaveManager:BuildConfigSection(tab)
		assert(self.Library, "Must set SaveManager.Library")

		local lastSelectedConfig = "Default"
		local lastSelectedPath = self.Folder .. "/settings/LastSelectedConfig.txt"
		
		if isfile(lastSelectedPath) then
			lastSelectedConfig = readfile(lastSelectedPath)
		end
		
		local section = tab:AddSection("Configuration")
		
		-- [1] Config Selection
		local ConfigListDropdown = section:AddDropdown("SaveManager_ConfigList", {
			Title = "Config List",
			Values = self:RefreshConfigList(),
			Default = lastSelectedConfig,
			AllowNull = true,
			Callback = function(selected)
				if selected then
					writefile(lastSelectedPath, selected)
				end
			end
		})
		
		section:AddButton({Title = "Refresh Config List", Callback = function()
			SaveManager.Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
			--SaveManager.Options.SaveManager_ConfigList:SetValue(nil)
		end})
		
		-- [2] Config Creation
		section:AddInput("SaveManager_ConfigName", { Title = "Config Name" })
		
		section:AddButton({
			Title = "Create New Config",
			Callback = function()
				local name = SaveManager.Options.SaveManager_ConfigName.Value
				if name:gsub(" ", "") == "" then 
					return self.Library:Notify({
						Title = "Configuration",
						Content = "Invalid config name (empty)",
						Duration = 5
					})
				end
				local success, err = self:Save(name)
				if not success then
					return self.Library:Notify({
						Title = "Configuration",
						Content = "Failed to save config: " .. err,
						Duration = 5
					})
				end
				self.Library:Notify({
					Title = "Configuration",
					Content = string.format("Created config %q", name),
					Duration = 5
				})
				SaveManager.Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
				-- SaveManager.Options.SaveManager_ConfigList:SetValue(name) -- Uncomment if you want to auto-select new config
			end
		})
		
		-- [3] Config Loading / Saving
		section:AddButton({Title = "Load Selected Config", Callback = function()
			local name = SaveManager.Options.SaveManager_ConfigList.Value
			local success, err = self:Load(name)
			if not success then
				return self.Library:Notify({
					Title = "Configuration",
					Content = "Failed to load config: " .. err,
					Duration = 5
				})
			end
			self.Library:Notify({
				Title = "Configuration",
				Content = string.format("Loaded config %q", name),
				Duration = 5
			})
		end})
		
		section:AddButton({Title = "Save Selected Config", Callback = function()
			local name = SaveManager.Options.SaveManager_ConfigList.Value
			local success, err = self:Save(name)
			if not success then
				return self.Library:Notify({
					Title = "Configuration",
					Content = "Failed to save config: " .. err,
					Duration = 5
				})
			end
			self.Library:Notify({
				Title = "Configuration",
				Content = string.format("Saved config %q", name),
				Duration = 5
			})
		end})
		
		-- [4] Auto Save Toggle
		section:AddToggle("SaveManager_AutoSaveToggle", {
			Title = "Auto Save Config",
			Description = "Automatically saves the current config when you change an option.",
			Default = SaveManager.AutoSaveEnabled,
			Callback = function(Value)
				SaveManager.AutoSaveEnabled = Value
				if Value then
					writefile(SaveManager.AutoSavePath, "true")
					SaveManager:AutoSave()
				else
					writefile(SaveManager.AutoSavePath, "false")
				end
			end
		})			
		
		-- [5] Autoload Settings
		local AutoloadButton
		AutoloadButton = section:AddButton({Title = "Set as Autoload Config", Description = "Current autoload config: none", Callback = function()
			local name = SaveManager.Options.SaveManager_ConfigList.Value
			if name then
				writefile(self.Folder .. "/settings/autoload.txt", name)
				AutoloadButton:SetDesc("Current autoload config: " .. name)
				self.Library:Notify({
					Title = "Configuration",
					Content = string.format("Set %q to auto load", name),
					Duration = 5
				})
			else
				delfile(self.Folder .. "/settings/autoload.txt")
				AutoloadButton:SetDesc("Current autoload config: none")
				self.Library:Notify({
					Title = "Configuration",
					Content = "Set none to auto load",
					Duration = 5
				})
			end
		end})
		
		if isfile(self.Folder .. "/settings/autoload.txt") then
			local name = readfile(self.Folder .. "/settings/autoload.txt")
			AutoloadButton:SetDesc("Current autoload config: " .. name)
		end
		
		section:AddButton({Title = "Delete Selected Config", Callback = function()
			local name = SaveManager.Options.SaveManager_ConfigList.Value
			if not name then
				return
			end
			delfile(self.Folder .. "/settings/" .. name .. ".json")
			SaveManager.Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
			SaveManager.Options.SaveManager_ConfigList:SetValue(nil)
			self.Library:Notify({
				Title = "Configuration",
				Content = string.format("Deleted config %q", name),
				Duration = 5
			})
			
			if isfile(self.Folder .. "/settings/autoload.txt") then
				if readfile(self.Folder .. "/settings/autoload.txt") == name then
					delfile(self.Folder .. "/settings/autoload.txt")
					AutoloadButton:SetDesc("Current autoload config: none")
					self.Library:Notify({
						Title = "Configuration",
						Content = "Autoload cleared because config was deleted",
						Duration = 5
					})
				end
			end
		end})		

		if isfile(self.Folder .. "/settings/autoload.txt") then
			local name = readfile(self.Folder .. "/settings/autoload.txt")
			AutoloadButton:SetDesc("Current autoload config: " .. name)
		end

		SaveManager:SetIgnoreIndexes({ "SaveManager_ConfigList", "SaveManager_CreateConfigInput" })
	end

	SaveManager:BuildFolderTree()
end

print("BetterSaveManager Loaded")
return SaveManager
