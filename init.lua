
include("background.lua")
include("quickconnect/init.lua")

----------------------------------------------------------------------------------------------------

local PANEL = {}

AccessorFunc(PANEL, "text", "Text")
AccessorFunc(PANEL, "font", "Font")
AccessorFunc(PANEL, "color", "Color")
AccessorFunc(PANEL, "slideLength", "SlideLength")

function PANEL:Init()
	self:SetFont("default")
	self:SetText("Menu Button")
	self:SetColor(Color(255, 255, 255, 200))
	self:SetSlideLength(100)
	
	self:UpdateSize()
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
	
	surface.SetTextPos(w*scale-tw*scale, 4)
	surface.DrawText(text)
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
end

function PANEL:Think()
	if not self:IsHovered() and self.down then
		self.down = false
	end
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
	for _,child in pairs(self.panels) do
		w = math.max(w, child.x + child:GetWide())
		h = math.max(h, child.y + child:GetTall())
	end
	
	self:SetSize(w, h)
	
	local x, y = 0, 0
	for _,pnl in ipairs(self.panels) do
		pnl:SetPos(x, y)
		y = y + pnl:GetTall()
	end
	
end

function PANEL:AddSpace(space)
	local pnl = vgui.Create("Panel", self)
	pnl:SetTall(space)
	table.insert(self.panels, pnl)
end

function PANEL:AddButton(text, func)
	local btn = vgui.Create("MenuButton", self)
	btn:SetTall(24)
	btn:SetText(text)
	btn.DoClick = func
	table.insert(self.panels, btn)
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(255, 0, 0, 255)
	surface.DrawRect(0, 0, w, h)
end

vgui.Register("MenuButtons", PANEL, "DPanel")

----------------------------------------------------------------------------------------------------

local menubg = vgui.Create("MenuBackground")
menubg:Dock(FILL)

local menubtns = vgui.Create("MenuButtons", menubg)
menubtns:AddButton("Hello, World", function() print("Hi") end)
menubtns:AddButton("Hello, World", function() print("Hi") end)
menubtns:AddButton("Hello, World", function() print("Hi") end)
menubtns:AddButton("Hello, World a bit longer", function() print("Hi") end)

function menubg:PerformLayout()
	local w, h = self:GetSize()
	local pw, ph = menubtns:GetSize()
	menubtns:SetPos(50, h/2-ph/2)
end
