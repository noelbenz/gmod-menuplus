
surface.CreateFont("Arial16Bold", {
	font       = "Arial",
	size       = 16,
	weight     = 700,
	blursize   = 0,
	scanlines  = 0,
	antialias  = true,
	underline  = false,
	italic     = false,
	strikeout  = false,
	symbol     = false,
	rotary     = false,
	shadow     = false,
	additive   = false,
	outline    = false,
})

local PANEL = {}

AccessorFunc(PANEL, "draggable", "Draggable")
AccessorFunc(PANEL, "sizable", "Sizable")
AccessorFunc(PANEL, "minWidth", "MinWidth")
AccessorFunc(PANEL, "minHeight", "MinHeight")
AccessorFunc(PANEL, "removeOnClose", "RemoveOnClose")

local matIconRemove  = Material("icons/remove16.png")

function PANEL:Init()

	self:SetDraggable(true)
	self:SetSizable(false)
	self:SetMinWidth(100)
	self:SetMinHeight(8+16+8)

	local pnlTitleBar = vgui.Create("Panel", self)
	pnlTitleBar:SetTall(16)
	pnlTitleBar.OnMousePressed = function(_, ...) self:OnMousePressed(...) end
	pnlTitleBar:SetCursor("sizeall")
	self.pnlTitleBar = pnlTitleBar

	local pnlClose = vgui.Create("MPNiceButton", pnlTitleBar)
	pnlClose:SetSize(16, 16)
	pnlClose:Dock(RIGHT)
	pnlClose:DockMargin(8, 0, 0, 0)
	pnlClose:SetMaterial(matIconRemove)
	pnlClose:SetMouseInputEnabled(true)
	pnlClose.DoClick = function(_, ...) self:Close() end
	self.pnlClose = pnlClose

	local pnlTitle = vgui.Create("DLabel", pnlTitleBar)
	pnlTitle:SetText("No title")
	pnlTitle:SetFont("Arial16Bold")
	pnlTitle:Dock(FILL)
	self.pnlTitle = pnlTitle

	self:DockPadding(8, 8+16+8, 8, 8)
end

function PANEL:Close()
	if self:GetRemoveOnClose() then
		self:Remove()
	else
		self:SetVisible(false)
	end
end

function PANEL:SetTitle(title)
	self.pnlTitle:SetText(title)
end

function PANEL:Paint(w, h)

	local desired = 100

	if self.mouseInside then
		desired = 255
	end

	self.alpha = math.Approach(self.alpha or desired, desired, FrameTime()*1200)
	self:SetAlpha(self.alpha)

	draw.RoundedBox(8, 0, 0, w, h, Color(0, 0, 0, 210))
end

function PANEL:IsActionDrag(x, y)
	return (y < 8 + 16 + 8) and self.draggable
end

function PANEL:Think()
	local x, y = self:CursorPos()
	self.mouseInside = x > 0 and y > 0 and x < self:GetWide() and y < self:GetTall()

	if self:IsActionDrag(x, y) then
		self:SetCursor("sizeall")
	else
		self.action = nil
		self:SetCursor("arrow")
	end
end

function PANEL:OnMousePressed(btn)
	if btn ~= MOUSE_LEFT then return end

	local x, y = self:CursorPos()

	if self:IsActionDrag(x, y) then
		self.dragOffset = Vector(x, y)
		self:MouseCapture(true)
	end
end

function PANEL:OnMouseReleased(btn)
	if btn ~= MOUSE_LEFT then return end

	self.dragOffset = false
	self:MouseCapture(false)
end

function PANEL:OnCursorMoved(x, y)
	if self.dragOffset then
		local curX, curY = self:GetPos()
		self:SetPos(curX + (x - self.dragOffset.x),
		            curY + (y - self.dragOffset.y))
	end
end

function PANEL:PerformLayout()
	self.pnlTitleBar:SetPos(8, 8)
	self.pnlTitleBar:SetSize(self:GetWide()-8*2, 16)
end

vgui.Register("MPFadeFrame", PANEL, "DPanel")
