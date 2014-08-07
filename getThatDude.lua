-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- declare the addon and register chat commands
getThatDude = LibStub("AceAddon-3.0"):NewAddon("getThatDude", "AceConsole-3.0")
getThatDude:RegisterChatCommand("gtd", "InputFunction")
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------




-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- set up our global variables
GTD_WeHaveTarget = FALSE
GTD_WeHaveTarget2 = FALSE
GTD_currentTarget = nil
GTD_currentTarget2 = nil
GTD_itsVisible = FALSE
GTD_itsVisible2 = FALSE
GTD_myplate = nil
GTD_myplate2 = nil
-- How often the OnUpdate code will run (in seconds)
GTDAddon_UpdateInterval = 0.1;
GTD_TimeSinceUpdate = 0
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------



-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- main processing function.  Every 0.1 seconds, update the screen according
-- to whether or not the nameplate in question is visible
function GTD_OnUpdate(self, elapsed)
	GTD_TimeSinceUpdate = GTD_TimeSinceUpdate + elapsed; 	
	if (GTD_TimeSinceUpdate > GTDAddon_UpdateInterval) then


		if GTD_currentTarget then
			-- since frame numbering is reused in table, always re-lookup the
			-- nameplate frame value each time it goes visible.
			GTD_myplate = LibNameplate:GetNameplateByName(GTD_currentTarget)
			print(GTD_myplate);
			if GTD_myplate then
				-- if it's not already visible, then do stuff.  Otherwise, nothing
				-- has changed and there's no point to make the computer do more work
				if GTD_itsVisible == FALSE then
					GTD_itsVisible = TRUE
					GTDMainFrame:SetPoint("BOTTOM", GTD_myplate, "TOP", 0, -5)
					GTDMainFrame:Show()
				end
			     else
				-- if it used to be visible, then do stuff.  Otherwise, nothing
				-- has changed and there's no point to make the computer do more work
				if GTD_itsVisible == TRUE then
					GTD_itsVisible = FALSE
					GTDMainFrame:ClearAllPoints()
					GTDMainFrame:Hide()
				end
			end
		end



		if GTD_currentTarget2 then
			-- since frame numbering is reused in table, always re-lookup the
			-- nameplate frame value each time it goes visible.
			GTD_myplate2 = LibNameplate:GetNameplateByName(GTD_currentTarget2)
			if GTD_myplate2 then
				-- if it's not already visible, then do stuff.  Otherwise, nothing
				-- has changed and there's no point to make the computer do more work
				if GTD_itsVisible2 == FALSE then
					GTD_itsVisible2 = TRUE
					GTDMainFrame2:SetPoint("BOTTOM", GTD_myplate2, "TOP", 0, -5)
					GTDMainFrame2:Show()
				end
			else
				-- if it used to be visible, then do stuff.  Otherwise, nothing
				-- has changed and there's no point to make the computer do more work
				if GTD_itsVisible2 == TRUE then
					GTD_itsVisible2 = FALSE
					GTDMainFrame2:ClearAllPoints()
					GTDMainFrame2:Hide()
				end
			end
		end






		GTD_TimeSinceUpdate = 0;
	end
end
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------




-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- make a frame that exists just to handle the onUpdate events
local GTDProcessor = CreateFrame("frame", "GTDProcessorFrame", UIParent);
-- set it to run the onUpdate function
GTDProcessorFrame:SetScript("OnUpdate", GTD_OnUpdate)
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------



-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- make an indicator frame to put over people's heads
local GTDFrame = CreateFrame("frame", "GTDMainFrame", UIParent);
GTDMainFrame:SetMovable(false)
GTDMainFrame:EnableMouse(false)
GTDMainFrame:SetWidth(40);
GTDMainFrame:SetHeight(75);
GTDMainFrame:SetPoint("TOP", WorldFrame, "TOP", 0, -40)
local GTDBground = GTDMainFrame:CreateTexture("GTDFrameBackground", "BACKGROUND")
-- GTDBground:SetTexture(1, 0, 0, 1)
GTDBground:SetTexture("Interface\\AddOns\\getThatDude\\indicator.tga", 0.5)

GTDBground:SetAllPoints(GTDMainFrame)
GTDMainFrame.texture = GTDBground
GTDMainFrame:Show()
GTDMainFrame:ClearAllPoints()
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------




-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- make a 2nd indicator frame to put over people's heads
local GTDFrame2 = CreateFrame("frame", "GTDMainFrame2", UIParent);
GTDMainFrame2:SetMovable(false)
GTDMainFrame2:EnableMouse(false)
GTDMainFrame2:SetWidth(40);
GTDMainFrame2:SetHeight(75);
GTDMainFrame2:SetPoint("TOP", WorldFrame, "TOP", 0, -40)
local GTDBground2 = GTDMainFrame2:CreateTexture("GTDFrameBackground2", "BACKGROUND")
-- GTDBground:SetTexture(1, 0, 0, 1)
GTDBground2:SetTexture("Interface\\AddOns\\getThatDude\\indicator2.tga", 0.5)

GTDBground2:SetAllPoints(GTDMainFrame2)
GTDMainFrame2.texture = GTDBground2
GTDMainFrame2:Show()
GTDMainFrame2:ClearAllPoints()
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------




-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- Function for sending a raid/party/self message to focus your target, sent
-- by invoking the "/gtd gtdtarggg" slash command 
function GTD_GetThatTarget()
	if UnitName("target") then
		GTD_currentTarget = UnitName("target")
		if UnitInRaid("player") then
			SendChatMessage("GTD: " .. UnitName("player") .. " requests focus on ***" .. GTD_currentTarget .. "***", "RAID")
		elseif GetNumPartyMembers() > 0 then
			SendChatMessage("GTD: " .. UnitName("player") .. " requests focus on ***" .. GTD_currentTarget .. "***", "PARTY")
		else
		end
	else
		if UnitInRaid("player") then
			SendChatMessage("GTD: " .. UnitName("player") .. " has cleared the focus target ***Clearing Focus***", "RAID")
		elseif GetNumPartyMembers() > 0 then
			SendChatMessage("GTD: " .. UnitName("player") .. " has cleared the focus target ***Clearing Focus***", "PARTY")
		else
		end
		GTD_currentTarget = "Clearing Focus"
	end
end
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------





-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- Function for sending a raid/party/self message to focus your target, sent
-- by invoking the "/gtd gtdtarggg2" slash command 
function GTD_GetThatTarget2()
	if UnitName("target") then
		GTD_currentTarget2 = UnitName("target")
		if UnitInRaid("player") then
			SendChatMessage("GTD2: " .. UnitName("player") .. " requests 2nd focus on ***" .. GTD_currentTarget2 .. "***", "RAID")
		elseif GetNumPartyMembers() > 0 then
			SendChatMessage("GTD2: " .. UnitName("player") .. " requests 2nd focus on ***" .. GTD_currentTarget2 .. "***", "PARTY")
		else
		end
	else
		if UnitInRaid("player") then
			SendChatMessage("GTD2: " .. UnitName("player") .. " has cleared the 2nd focus target ***Clearing Focus***", "RAID")
		elseif GetNumPartyMembers() > 0 then
			SendChatMessage("GTD2: " .. UnitName("player") .. " has cleared the 2nd focus target ***Clearing Focus***", "PARTY")
		else
		end
		GTD_currentTarget2 = "Clearing Focus"
	end
end
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------




-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- Function for sending a raid/party/self message to focus your target, sent
-- by invoking the "/gtd gtdself" slash command 
function GTD_GetThatTargetForMe()
	if UnitName("target") then
		GTD_currentTarget = UnitName("target")
	else
		GTD_currentTarget = "Clearing Focus"
	end
end
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------



-----------------------------------------------------------------------------
-- Function for sending a raid/party/self message to focus your target, sent
-- by invoking the "/gtd gtdself2" slash command 
function GTD_GetThatTargetForMe2()
	if UnitName("target") then
		GTD_currentTarget2 = UnitName("target")
	else
		GTD_currentTarget2 = "Clearing Focus"
	end
end
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------



-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- function to start the mod running and to process events
function GTD_EventHandler(self, event, arg1, ...)
	local eventName = event
	local isGTD = string.find(arg1, "GTD: ")
	local isGTD2 = string.find(arg1, "GTD2: ")
	if isGTD then
		-- print(isGTD)
		local startstring = string.find(arg1, "***")
		local endstring = ""
		if startstring then
			endstring = string.find(arg1, "***", startstring+3)
			startstring = startstring + 3
		end
		if startstring then
			if endstring then
				local mobname = string.sub(arg1, startstring, endstring-1)
				if mobname then
					GTD_currentTarget = mobname
				end
			end
		end
	end
	if isGTD2 then
		-- print(isGTD)
		local startstring2 = string.find(arg1, "***")
		local endstring2 = ""
		if startstring2 then
			endstring2 = string.find(arg1, "***", startstring2+3)
			startstring2 = startstring2 + 3
		end
		if startstring2 then
			if endstring2 then
				local mobname2 = string.sub(arg1, startstring2, endstring2-1)
				if mobname2 then
					GTD_currentTarget2 = mobname2
					print (mobname2)
				end
			end
		end
	end	
end
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------











-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- function to start the mod running and to listen to events
function getThatDude:OnEnable()
	local eventframe = CreateFrame("FRAME", "MyAddonRegisterEventsFrame");
	eventframe:RegisterEvent("CHAT_MSG_PARTY");
	eventframe:RegisterEvent("CHAT_MSG_RAID");
	eventframe:RegisterEvent("CHAT_MSG_PARTY_LEADER");
	eventframe:RegisterEvent("CHAT_MSG_RAID_LEADER");
	eventframe:SetScript("OnEvent", GTD_EventHandler);
	self:Print("registered and scripts set")
end
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------




-----------------------------------------------------------------------------
-- for debugging, this gives info about all the nameplates currently visible.
-----------------------------------------------------------------------------
function WorkOnAllNameplates()
	local frames = {LibNameplate:GetAllNameplates()}
	local pName
	local framename
	for i, frame in ipairs(frames) do 
		pName = LibNameplate:GetName(frame)
		framename = frame
		print (i,frame, pName)		
	end
end
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------




-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- Make an instance of the nameplate processor using the LibNameplate library
LibNameplate = LibStub("LibNameplate-1.0")
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------



-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- process inputs passed through chat commands.  It's very inelegant but
-- that's what you get for free.
function getThatDude:InputFunction(input)
	if input == "" then
		self:Print("yo")
		for i, plate in LibNameplate:IteratePlates() do
			if plate then
				print(plate)
				print(" belongs to "..LibNameplate:GetName(plate )..".")
				-- print("the name of the health frame is " .. GetHealthBar(plate))
			end
		end
		self:Print("done")
	elseif input == "me" then
		-- successfully gets a nameplate based on a name.  Will
		-- be useful for iterating through enemy names later in
		-- conjunction with some check to see if the person is hostile
		GTD_myplate = LibNameplate:GetNameplateByName("Mouton Flamestar")
		self:Print(GTD_myplate)
		-- GTDMainFrame:SetPoint("TOP", GTD_myplate, "TOP", 0, 20)
	elseif input == "all" then
		WorkOnAllNameplates()
	elseif input == "gtdtarggg" then
		GTD_GetThatTarget()
	elseif input == "gtdself" then
		GTD_GetThatTargetForMe()
	elseif input == "gtdtarggg2" then
		GTD_GetThatTarget2()
	elseif input == "gtdself2" then
		GTD_GetThatTargetForMe2()
	else
		GTD_currentTarget = input
		GTD_WeHaveTarget = TRUE
	end
end
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
