
include("quickconnect/init.lua")

----------------------------------------------------------------------------------------------------

local backgrounds = {}

local function loadBackgrounds()
	local files,folders = file.Find("backgrounds/*.jpg", "MOD")
	
	for k,f in pairs(files) do
		backgrounds[k] = "backgrounds/"..f, "nocull smooth"
	end
end
loadBackgrounds()

----------------------------------------------------------------------------------------------------

local PANEL = {}

AccessorFunc(PANEL, "changeDelay", "ChangeDelay")
AccessorFunc(PANEL, "transitionDuration", "TransitionDuration")

function PANEL:Init()
	-- TODO W/H Ratio
	self:SetChangeDelay(20)
	self:SetTransitionDuration(2)
end

function PANEL:Think()
	
	if #backgrounds > 0 then
		if not self.nextChange or CurTime() > self.nextChange then
				
			if self.cycle == nil or #self.cycle == 0 then
				self.cycle = table.Copy(backgrounds)
			end
			
			local i = math.random(1, #self.cycle)
			local mat = Material(table.remove(self.cycle, i))
			
			self.lastBackground = self.background
			self.lastRatio = self.ratio
			self.background = mat
			self.ratio = mat:GetInt("$realwidth")/mat:GetInt("$realheight")
			
			self.nextChange = CurTime() + self.changeDelay
		end
	end
end

local function drawImage(mat, ratio)
	local scrRatio = ScrW() / ScrH()
	
	surface.SetMaterial(mat)
	if ratio >= scrRatio then
		local w, h = ScrH()*ratio, ScrH()
		surface.DrawTexturedRect(ScrW()/2-w/2, 0, w, h)
	else
		local w, h = ScrW(), ScrW()/ratio
		surface.DrawTexturedRect(0, ScrH()/2-h/2, w, h)
	end
end

function PANEL:Paint()
	if IsInGame() then return end
	
	
	if self.background then
		surface.SetDrawColor(255, 255, 255, 255)
		drawImage(self.background, self.ratio)
	end
	if self.lastBackground then
		local timeSince = self.changeDelay - (self.nextChange - CurTime())
		local scale = math.Clamp((self.transitionDuration - timeSince) / self.transitionDuration, 0, 1)
		surface.SetDrawColor(255, 255, 255, 255*scale)
		drawImage(self.lastBackground, self.lastRatio)
	end
end

vgui.Register("MenuBackground", PANEL)

----------------------------------------------------------------------------------------------------

local menubg = vgui.Create("MenuBackground")
menubg:Dock(FILL)

