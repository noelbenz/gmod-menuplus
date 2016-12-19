
local PANEL = {}

AccessorFunc(PANEL, "color", "Color")

local matGlow = Material("icons/glow64.png")

function PANEL:DoClick() end

function PANEL:Init()
	self:SetColor(Color(255, 255, 255, 255))
	self:SetCursor("hand")
end

function PANEL:SetMaterial(mat)
	self.material = mat
end

function PANEL:Paint(w, h)

	if not self.material then return end

	local desiredAlpha = 0

	if self.mouseInside then
		desiredAlpha = 120
	end

	self.glowAlpha = self.glowAlpha or 0
	self.glowAlpha = math.Approach(self.glowAlpha, desiredAlpha, FrameTime()*1500)

	local r = self.color.r
	local g = self.color.g
	local b = self.color.b
	local a = self.color.a

	if self.glowAlpha > 0 then
		surface.SetMaterial(matGlow)
		surface.SetDrawColor(r, g, b, self.glowAlpha)
		surface.DrawTexturedRect(0, 0, w, h)
	end

	surface.SetMaterial(self.material)
	surface.SetDrawColor(r, g, b, a)
	surface.DrawTexturedRect(0, 0, w, h)
end

function PANEL:OnMousePressed()
	self:DoClick()
end

function PANEL:Think()
	local x, y = self:CursorPos()
	self.mouseInside = x > 0 and y > 0 and x < self:GetWide() and y < self:GetTall()
end

vgui.Register("MPNiceButton", PANEL)
