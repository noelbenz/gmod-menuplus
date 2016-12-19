
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

function PANEL:Init()
	-- full left
	self.gradientH = Material("gui/gradient")
	-- full top
	self.gradientV = Material("gui/gradient_down")
end

function PANEL:Paint(w, h)
	if IsInGame() then return end

	-- Black background.
	local colorm = Color(0, 0, 0, 255)
	-- Time by a factor of 10 to speed it up.
	local t = CurTime()*10
	-- How much the color differs between sides.
	local spread = 30
	-- Color progression in a clock-wise manner.
	local colorl = HSVToColor((t+spread*0)%360, 1, 1)
	local colort = HSVToColor((t+spread*1)%360, 1, 1)
	local colorr = HSVToColor((t+spread*2)%360, 1, 1)
	local colorb = HSVToColor((t+spread*3)%360, 1, 1)

	-- Lower the alpha of each gradient to 50
	-- so that when they layer over eachother they
	-- won't be too bright.
	local a = 50
	colorl.a = a
	colorr.a = a
	colort.a = a
	colorb.a = a

	-- Clear the background.
	surface.SetDrawColor(colorm)
	surface.DrawRect(0, 0, w, h)

	-- Draw left gradient.
	surface.SetDrawColor(colorl)
	surface.SetMaterial(self.gradientH)
	surface.DrawTexturedRect(0, 0, w, h)

	-- Draw right gradient.
	surface.SetDrawColor(colorr)
	surface.SetMaterial(self.gradientH)
	surface.DrawTexturedRectUV(0, 0, w, h, 1, 0, 0, 1)

	-- Draw top gradient.
	surface.SetDrawColor(colort)
	surface.SetMaterial(self.gradientV)
	surface.DrawTexturedRect(0, 0, w, h)

	-- Draw bottom gradient.
	surface.SetDrawColor(colorb)
	surface.SetMaterial(self.gradientV)
	surface.DrawTexturedRectUV(0, 0, w, h, 0, 1, 1, 0)


	local border = 70
	local borderColor = Color(0, 0, 0, 130)

	-- Draw left gradient.
	surface.SetDrawColor(borderColor)
	surface.SetMaterial(self.gradientH)
	surface.DrawTexturedRect(0, 0, border, h)

	-- Draw right gradient.
	surface.SetDrawColor(borderColor)
	surface.SetMaterial(self.gradientH)
	surface.DrawTexturedRectUV(w-border, 0, border, h, 1, 0, 0, 1)

	-- Draw top gradient.
	surface.SetDrawColor(borderColor)
	surface.SetMaterial(self.gradientV)
	surface.DrawTexturedRect(0, 0, w, border)

	-- Draw bottom gradient.
	surface.SetDrawColor(borderColor)
	surface.SetMaterial(self.gradientV)
	surface.DrawTexturedRectUV(0, h-border, w, border, 0, 1, 1, 0)

end

vgui.Register("MenuBackgroundGradient", PANEL)

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

vgui.Register("MenuBackgroundImages", PANEL)
