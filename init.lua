
----------------------------------------------------------------------------------------------------


include("gui/fade_panel.lua")
include("gui/fade_frame.lua")
include("gui/nice_button.lua")
include("gui/scroll_panel.lua")

include("background.lua")
include("quickconnect/init.lua")
include("browser/init.lua")

----------------------------------------------------------------------------------------------------

surface.CreateFont("MenuButton", {
	font       = "Verdana",
	size       = 32,
	weight     = 700,
	blursize   = 0,
	scanlines  = 0,
	antialias  = true,
	underline  = false,
	italic     = false,
	strikeout  = false,
	symbol     = false,
	rotary     = false,
	shadow     = true,
	additive   = false,
	outline    = false,
})

local PANEL = {}

AccessorFunc(PANEL, "text", "Text")
AccessorFunc(PANEL, "font", "Font")
AccessorFunc(PANEL, "color", "Color")
AccessorFunc(PANEL, "slideLength", "SlideLength")

function PANEL:Init()
	self:SetFont("MenuButton")
	self:SetText("Menu Button")
	self:SetColor(Color(255, 255, 255, 200))
	self:SetSlideLength(50)

	self:UpdateSize()
end

local function drawLift(x, y, diff)
	if diff < 1 then return end

	if diff <= 11 then
		surface.DrawRect(x, y-9, diff, 19)

	elseif diff <= 13 then
		surface.DrawRect(x, y-9, 8, 19)

		surface.DrawRect(x+8, y-7, diff-11, 1)
		surface.DrawRect(x+8, y-5, diff-11, 1)
		surface.DrawRect(x+8, y-3, diff-11, 1)
		surface.DrawRect(x+8, y-1, diff-11, 3)
		surface.DrawRect(x+8, y+3, diff-11, 1)
		surface.DrawRect(x+8, y+5, diff-11, 1)
		surface.DrawRect(x+8, y+7, diff-11, 1)

		surface.DrawRect(x+diff-3, y-9, 3, 19)
	elseif diff <= 22 then
		surface.DrawRect(x+0, y-9, 3, 19)

		surface.DrawRect(x+3, y-7, diff-13, 1)
		surface.DrawRect(x+3, y-4, diff-13, 1)
		surface.DrawRect(x+3, y-1, diff-13, 3)
		surface.DrawRect(x+3, y+4, diff-13, 1)
		surface.DrawRect(x+3, y+7, diff-13, 1)

		if diff - 13 >= 2 then
			surface.DrawRect(x+4, y-7, 1, 15)
		end
		if diff - 13 >= 4 then
			surface.DrawRect(x+6, y-7, 1, 15)
		end
		if diff - 13 >= 6 then
			surface.DrawRect(x+8, y-7, 1, 15)
		end
		if diff - 13 >= 8 then
			surface.DrawRect(x+10, y-7, 1, 15)
		end

		surface.DrawRect(x+diff-10, y-9, 5, 19)

		surface.DrawRect(x+diff-5, y-7, 2, 1)
		surface.DrawRect(x+diff-5, y-5, 2, 1)
		surface.DrawRect(x+diff-5, y-3, 2, 1)
		surface.DrawRect(x+diff-5, y-1, 2, 3)
		surface.DrawRect(x+diff-5, y+3, 2, 1)
		surface.DrawRect(x+diff-5, y+5, 2, 1)
		surface.DrawRect(x+diff-5, y+7, 2, 1)

		surface.DrawRect(x+diff-3, y-9, 3, 19)
	else

		surface.DrawRect(0, y-9, 3, 19)

		surface.DrawRect(x+3, y-7, 9, 1)
		surface.DrawRect(x+3, y-4, 9, 1)
		surface.DrawRect(x+3, y-1, 9, 3)
		surface.DrawRect(x+3, y+4, 9, 1)
		surface.DrawRect(x+3, y+7, 9, 1)

		surface.DrawRect(x+4, y-7, 1, 15)
		surface.DrawRect(x+6, y-7, 1, 15)
		surface.DrawRect(x+8, y-7, 1, 15)
		surface.DrawRect(x+10, y-7, 1, 15)

		surface.DrawRect(x+12, y-9, 3, 19)

		surface.DrawRect(x+15, y-4, diff-22, 1)
		surface.DrawRect(x+15, y-1, diff-22, 3)
		surface.DrawRect(x+15, y+4, diff-22, 1)

		if diff - 22 >= 6 then
			surface.DrawRect(x+20, y-7, 2, 15)
		end
		if diff - 22 >= 13 then
			surface.DrawRect(x+27, y-7, 2, 15)
		end
		if diff - 22 >= 21 then
			surface.DrawRect(x+34, y-7, 2, 15)
		end

		surface.DrawRect(x+diff-7, y-9, 2, 19)

		surface.DrawRect(x+diff-5, y-7, 2, 1)
		surface.DrawRect(x+diff-5, y-5, 2, 1)
		surface.DrawRect(x+diff-5, y-3, 2, 1)
		surface.DrawRect(x+diff-5, y-1, 2, 3)
		surface.DrawRect(x+diff-5, y+3, 2, 1)
		surface.DrawRect(x+diff-5, y+5, 2, 1)
		surface.DrawRect(x+diff-5, y+7, 2, 1)

		surface.DrawRect(x+diff-3, y-9, 3, 19)
	end
end

function PANEL:Paint(w, h)
	surface.SetFont(self.font)
	surface.SetTextColor(self.color)
	local text = self.text
	local tw, th = surface.GetTextSize(text)

	local scale = self.slideScale or 0
	local ft = FrameTime()
	if self:IsHovered() then
		scale = scale + (1-scale)*ft*4 + ft*0.2
	else
		scale = scale - scale*ft*4 - ft*0.2
	end
	scale = math.Clamp(scale, 0, 1)
	self.slideScale = scale

	surface.SetTextPos(w*scale-tw*scale, h/2-th/2)
	surface.DrawText(text)

	surface.SetDrawColor(self.color)
	local diff = w*scale-tw*scale-2
	local y = math.ceil(th/2)

	local a = math.min(diff, 8)/8

	surface.SetDrawColor(0, 0, 0, 150*a)
	drawLift(1, y+1, diff)
	surface.SetDrawColor(self.color.r, self.color.g, self.color.b, 200*a)
	drawLift(0, y, diff)
end

local func = PANEL.SetText
PANEL.SetText = function(self, ...) func(self, ...) self:UpdateSize() end
local func = PANEL.SetFont
PANEL.SetFont = function(self, ...) func(self, ...) self:UpdateSize() end
local func = PANEL.SetSlideLength
PANEL.SetSlideLength = function(self, ...) func(self, ...) self:UpdateSize() end
function PANEL:UpdateSize()
	if not self.font then return end
	if not self.text then return end
	if not self.slideLength then return end
	surface.SetFont(self.font)
	local tw, th = surface.GetTextSize(self.text)
	self:SetWide(tw + self.slideLength)
	self:SetTall(th)
end

function PANEL:Think()
	if not self:IsHovered() and self.down then
		self.down = false
	end
end

function PANEL:OnCursorEntered()
	surface.PlaySound("ui/buttonrollover.wav")
end

function PANEL:OnMousePressed(mouseCode)
	if mouseCode ~= MOUSE_LEFT then return end
	self.down = true
end
function PANEL:OnMouseReleased(mouseCode)
	if mouseCode ~= MOUSE_LEFT then return end

	if self.down then
		self:DoClick()
	end

	self.down = false
end

function PANEL:DoClick() end

vgui.Register("MenuButton", PANEL, "DPanel")

----------------------------------------------------------------------------------------------------

local PANEL = {}

function PANEL:Init()
	self.panels = {}
end

function PANEL:PerformLayout()
	local w, h = 0, 0
	for _,pnl in pairs(self.panels) do
		if pnl.funcShow and not pnl.funcShow() then
			pnl:SetVisible(false)
			continue
		end
		pnl:SetVisible(true)
		w = math.max(w, pnl.x + pnl:GetWide())
		h = math.max(h, pnl.y + pnl:GetTall())
	end

	self:SetSize(w, h)

	local x, y = 0, 0
	for _,pnl in ipairs(self.panels) do
		if pnl.funcShow and not pnl.funcShow() then continue end
		pnl:SetPos(x, y)
		y = y + pnl:GetTall()
	end

end

function PANEL:Think()
	for _,pnl in pairs(self.panels) do
		if pnl.funcShow and (pnl.funcShow() != pnl:IsVisible()) then
			self:InvalidateLayout()
		end
	end
end

function PANEL:AddSpace(space, funcShow)
	local pnl = vgui.Create("Panel", self)
	pnl:SetTall(space)
	pnl.funcShow = funcShow
	table.insert(self.panels, pnl)
end

function PANEL:AddButton(text, func, funcShow)
	local btn = vgui.Create("MenuButton", self)
	btn:SetTall(24)
	btn:SetText(text)
	btn.DoClick = func
	btn.funcShow = funcShow
	table.insert(self.panels, btn)
end

function PANEL:Paint(w, h)
	-- for debugging
	-- surface.SetDrawColor(255, 0, 0, 255)
	-- surface.DrawRect(0, 0, w, h)
end

vgui.Register("MenuButtons", PANEL, "DPanel")

----------------------------------------------------------------------------------------------------

timer.Simple(0, function()
	local menubg = vgui.Create("MenuBackgroundGradient")
	menubg:Dock(FILL)

	local menubtns = vgui.Create("MenuButtons", menubg)
	menubtns:AddButton("Create Game", function()
		RunConsoleCommand("gamemode", "dayz")
		RunConsoleCommand("maxplayers", 8)
		RunConsoleCommand("map", "rp_stalker_new")
	end)
	menubtns:AddSpace(8)
	menubtns:AddButton("Search Multiplayer", function() RunConsoleCommand("menu_browser") end)
	menubtns:AddSpace(8)
	menubtns:AddButton("Quick Connect", function() RunConsoleCommand("menu_quickconnect") end)
	menubtns:AddSpace(38)
	menubtns:AddButton("Options", function() RunGameUICommand("openoptionsdialog") end)
	menubtns:AddSpace(8, IsInGame)
	menubtns:AddButton("Disconnect", function() RunGameUICommand("disconnect") end, IsInGame)
	menubtns:AddSpace(38)
	menubtns:AddButton("Exit", function() RunGameUICommand("quitnoconfirm") end)

	function menubg:PerformLayout()
		local w, h = self:GetSize()
		local pw, ph = menubtns:GetSize()
		menubtns:SetPos(50, 50)
	end
end)
