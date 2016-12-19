
local PANEL = {}

function PANEL:Paint(w, h)

	local desired = 100

	if self.mouseInside then
		desired = 255
	end

	self.alpha = math.Approach(self.alpha or desired, desired, FrameTime()*1200)
	self:SetAlpha(self.alpha)

	draw.RoundedBox(8, 0, 0, w, h, Color(0, 0, 0, 210))
end

function PANEL:Think()
	local x, y = self:CursorPos()
	self.mouseInside = x > 0 and y > 0 and x < self:GetWide() and y < self:GetTall()
end

vgui.Register("MPFadePanel", PANEL)
