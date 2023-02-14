------------- SlowQueue ---------

--SQ Frame Setup
local sqFrame = CreateFrame("Frame", "SlowQueueFrame", UIParent, "UIPanelDialogTemplate")
sqFrame:Hide()
sqFrame:SetHeight(150)
sqFrame:SetWidth(300)
sqFrame:SetPoint("CENTER", UIParent, "TOP", 0, -1 * GetScreenHeight() / 4)
sqFrame:EnableKeyboard(false)
sqFrame.Title:SetText("SlowQueue")
sqFrame:SetMovable(true)
sqFrame:SetScript("OnShow", function(self) self.edit:SetFocus() end)
sqFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)
sqFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
sqFrame:RegisterForDrag("LeftButton")
sqFrame:EnableMouse(true)
sqFrame:SetToplevel(true)

-- scroll frame
local scrollFrame = CreateFrame("ScrollFrame", "SlowQueueScrollFrame", sqFrame, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("LEFT", 16, 0)
scrollFrame:SetPoint("RIGHT", -32, 0)
scrollFrame:SetPoint("TOP", 0, -32)
scrollFrame:SetPoint("BOTTOM", 0, 16)

-- edit box
local editBox = CreateFrame("EditBox", "SlowQueueEditBox", scrollFrame)
editBox:SetSize(scrollFrame:GetSize())
editBox:SetMultiLine(true)
editBox:SetAutoFocus(true)
editBox:SetFontObject("ChatFontNormal")
editBox:SetScript("OnEnterPressed", function(self) sqFrame:Hide() end)
editBox:SetScript("OnEscapePressed", function(self) sqFrame:Hide() end)
editBox:SetScript("OnSpacePressed", function(self) sqFrame:Hide() end)
editBox:SetScript("OnEditFocusLost", function(self) sqFrame:Hide() end)
editBox:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
editBox:SetScript("OnUpdate", function(self) self:HighlightText() end)
scrollFrame:SetScrollChild(editBox)

sqFrame.edit = editBox

-- get all player names inside the game
function GetPlayerNames()
	local realmName = GetRealmName()
	local playerNames = ""
	for i=1, GetNumBattlefieldScores() do
		local name = GetBattlefieldScore(i)
		
		if not string.find(name, "-") then
			name = name .. '-' .. realmName
		end
		playerNames = playerNames .. ';' .. name
	  end
  return playerNames:sub(2) -- remove first character
end

-- available slash commands
SLASH_SLOWQUEUE1 = "/slowqueue"
SLASH_SLOWQUEUE2 = "/sq"
SLASH_SLOWQUEUE3 = "/slowq"
SLASH_SLOWQUEUE4 = "/squeue"

-- on command used
SlashCmdList["SLOWQUEUE"] = function(msg)
	local playerNames = GetPlayerNames()
   
	if(playerNames == "") then
		print("SlowQueue: No Players Found")
	else
		editBox:SetText(playerNames)
		sqFrame:Show();
	end
end