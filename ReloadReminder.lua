-- [[ local variables ]]--
local MEDIA_DIR = "Interface\\AddOns\\ReloadReminder\\Media\\"
local AceGUI = LibStub("AceGUI-3.0")
local IsLoaded = false

--[[ Global saved variables ]]--
ReloadReminder_Settings = {
	alert_frequency = 30, -- 30 mins default
	chat_alerts = true,
	sound_alerts = true
}

-- [[ Addon main ui]]
ReloadReminder = CreateFrame("Frame")
ReloadReminder.name = "ReloadReminder"

--[[ Startup ]]--
function ReloadReminder:Startup()
	-- event handling helper
	self:SetScript("OnEvent", function(self, event, ...)
		self[event](self, ...)
	end)

	self:SetupAddonOptions()

	-- register events
	-- self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("ADDON_LOADED")
end

--[[ Events ]]--
function ReloadReminder:ADDON_LOADED()
	if IsLoaded == false then
		IsLoaded = true;
		print("|cFFFF0000RELOAD REMINDER:|r Will remind you to /reload in " .. ReloadReminder_Settings.alert_frequency .. " minute(s). Change how often in the settings.")
	end

	-- initiate timer, uses seconds
	C_Timer.NewTicker(ReloadReminder_Settings.alert_frequency * 60, function()
		if ReloadReminder_Settings.sound_alerts then
			self:SoundAlert()
		end

		if ReloadReminder_Settings.chat_alerts then
			self:ChatAlert()
		end
	end)
end

function ReloadReminder:SoundAlert()
	PlaySoundFile(MEDIA_DIR .. 'alert.ogg', "SFX")
end

function ReloadReminder:ChatAlert()
	print("|cFFFF0000RELOAD REMINDER:|r It's been " .. ReloadReminder_Settings.alert_frequency .." minute(s) since last /reload; Best do it now to save your progress!")
	print("|cFFFF0000RELOAD REMINDER:|r It's been " .. ReloadReminder_Settings.alert_frequency .." minute(s) since last /reload; Best do it now to save your progress!")
	print("|cFFFF0000RELOAD REMINDER:|r It's been " .. ReloadReminder_Settings.alert_frequency .." minute(s) since last /reload; Best do it now to save your progress!")
	print("|cFFFF0000RELOAD REMINDER:|r It's been " .. ReloadReminder_Settings.alert_frequency .." minute(s) since last /reload; Best do it now to save your progress!")
end

function ReloadReminder:ShowOptions()
	local frame = AceGUI:Create("Frame")
	frame:SetTitle("ReloadReminder")
	frame:SetStatusText("Changes will take affect after next /reload.")
	frame:SetCallback("OnClose", function(widget)
		AceGUI:Release(widget)
	end)
	frame:SetLayout("List")

	local interval = AceGUI:Create("EditBox")
	interval:SetLabel("How often do you want to be reminded (in minutes)?")
	interval:SetWidth(300)
	interval:SetText(tostring(ReloadReminder_Settings.alert_frequency))
	interval:SetCallback("OnEnterPressed", function(widget, event, text)
		local minutes = tonumber(text);

		if minutes <= 0 then
			minutes = 1
		end

		ReloadReminder_Settings.alert_frequency = minutes
	end)
	frame:AddChild(interval)

	local chatAlerts = AceGUI:Create("CheckBox")
	chatAlerts:SetLabel("Enable chat notification spam?")
	chatAlerts:SetValue(ReloadReminder_Settings.chat_alerts)
	chatAlerts:SetWidth(300)
	chatAlerts:SetCallback("OnValueChanged", function(widget, event, enabled)
		ReloadReminder_Settings.chat_alerts = enabled;
	end)
	frame:AddChild(chatAlerts)

	local testChatAlert = AceGUI:Create("Button")
	testChatAlert:SetText("Test Chat Alert")
	testChatAlert:SetCallback("OnClick", function(widget, event, enabled)
		if ReloadReminder_Settings.chat_alerts then
			self:ChatAlert()
		end
	end)
	frame:AddChild(testChatAlert)

	local soundAlert = AceGUI:Create("CheckBox")
	soundAlert:SetLabel("Enable sound notification")
	soundAlert:SetWidth(450)
	soundAlert:SetValue(ReloadReminder_Settings.sound_alerts)
	soundAlert:SetCallback("OnValueChanged", function(widget, event, enabled)
		ReloadReminder_Settings.sound_alerts = enabled;
	end)
	frame:AddChild(soundAlert)

	local testSoundAlert = AceGUI:Create("Button")
	testSoundAlert:SetText("Test Sound Alert")
	testSoundAlert:SetCallback("OnClick", function(widget, event, enabled)
		if ReloadReminder_Settings.sound_alerts then
			self:SoundAlert()
		end
	end)
	frame:AddChild(testSoundAlert)
end

function ReloadReminder:SetupAddonOptions()
	-- [[ Addon main ui]]
	local optionFrame = CreateFrame("Frame")
	optionFrame.name = "ReloadReminder"

	local btn = CreateFrame("Button", nil, optionFrame, "UIPanelButtonTemplate")
	btn:SetWidth(105)
	btn:SetPoint("Center", 0, "Center")
	btn:SetText("Open Settings")
	btn:SetScript("OnClick", function()
		self:ShowOptions()
	end)

	InterfaceOptions_AddCategory(optionFrame) -- add interfance addons settings
end

--[[ Start Addon ]]--
ReloadReminder:Startup()