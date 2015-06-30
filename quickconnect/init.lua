
local pnl_quickconnect

local current_address = ""

local mat_glow = Material("icons/glow64.png")

local mat_icon_edit    = Material("icons/edit16.png")
local mat_icon_remove  = Material("icons/remove16.png")
local mat_icon_add     = Material("icons/add16.png")
local mat_icon_minus   = Material("icons/minus16.png")
local mat_icon_finish  = Material("icons/check16.png")
local mat_icon_connect = Material("icons/arrow_right16.png")
local mat_icon_refresh = Material("icons/refresh16.png")
local mat_corner       = Material("icons/corner_rounded_outline4.png")

surface.CreateFont("quickconnect_font", {
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

surface.CreateFont("quickconnect_font2", {
	font       = "Arial",
	size       = 16,
	weight     = 500,
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

local servers = {}

if file.Exists("favorite_servers.txt", "DATA") then
	servers = util.KeyValuesToTable(file.Read("favorite_servers.txt"))
end

for _,server in pairs(servers) do
	server[1] = server[1] or ""
	server[2] = server[2] or "27015"
	server[3] = server[3] or ""
end

----------------------------------------------------------------------------------------------------

-- Can't get host ip, so we'll store the ip ourselves.
-- The flaw here is this won't work if you join through steam or anything external.
_JoinServer = _JoinServer or JoinServer
function JoinServer(address, ...)
	current_address = address
	_JoinServer(address, ...)
end

----------------------------------------------------------------------------------------------------

local function save()
	file.Write("favorite_servers.txt", util.TableToKeyValues(servers))
end

local function add_server(ip, port, password, custom_name)
	table.insert(servers, {ip, port, password, custom_name})
	save()
end

local function remove_server(id)
	table.remove(servers, id)
	save()
end

local function set_server(id, ip, port, password, custom_name)
	servers[id][1] = ip
	servers[id][2] = port
	servers[id][3] = password
	servers[id][4] = custom_name
	save()
end

----------------------------------------------------------------------------------------------------

local function hook_event(pnl, child_index, func_index)
	local callback_index = child_index.."_"..func_index
	child_index = "pnl_"..child_index:lower()
	
	local child = pnl[child_index]
	
	child[func_index] = function(_, ...)
		return pnl[callback_index](pnl, ...)
	end
end

----------------------------------------------------------------------------------------------------

local PANEL = {}

AccessorFunc(PANEL, "id", "ID")

function PANEL:Init()
	
	self:DockPadding(8, 8, 8, 8)
	
	local pnl_header = vgui.Create("Panel", self)
	pnl_header:Dock(TOP)
	pnl_header:SetTall(16)
	pnl_header:DockMargin(0, 0, 0, 4)
	
	local pnl_close = vgui.Create("nice_button", pnl_header)
	self.pnl_close = pnl_close
	pnl_close:Dock(RIGHT)
	pnl_close:SetWide(16)
	pnl_close:SetMaterial(mat_icon_remove)
	hook_event(self, "Close", "DoClick")
	
	local pnl_label_title = vgui.Create("DLabel", pnl_header)
	self.pnl_label_title = pnl_label_title
	pnl_label_title:Dock(FILL)
	pnl_label_title:SetFont("quickconnect_font")
	pnl_label_title:SetTextColor(Color(255, 255, 255, 180))
	pnl_label_title:SetText("Edit Server")
	
	local pnl_address_holder = vgui.Create("Panel", self)
	pnl_address_holder:Dock(TOP)
	pnl_address_holder:SetTall(24)
	pnl_address_holder:DockMargin(0, 0, 0, 4)
	
	local pnl_label_address = vgui.Create("DLabel", pnl_address_holder)
	self.pnl_label_address = pnl_label_address
	pnl_label_address:Dock(LEFT)
	pnl_label_address:SetFont("quickconnect_font")
	pnl_label_address:SetTextColor(Color(255, 255, 255, 180))
	pnl_label_address:SetText("IP Address: ")
	
	local pnl_address = vgui.Create("DTextEntry", pnl_address_holder)
	self.pnl_address = pnl_address
	pnl_address:Dock(FILL)
	pnl_address:SetCursorColor(Color(255, 255, 255, 180))
	pnl_address:SetTextColor(Color(255, 255, 255, 180))
	pnl_address:SetFont("quickconnect_font2")
	pnl_address:SetDrawBackground(false)
	pnl_address._Paint = pnl_address.Paint
	hook_event(self, "Address", "Paint")
	
	local pnl_port_holder = vgui.Create("Panel", self)
	pnl_port_holder:Dock(TOP)
	pnl_port_holder:SetTall(24)
	pnl_port_holder:DockMargin(0, 0, 0, 4)
	
	local pnl_label_port = vgui.Create("DLabel", pnl_port_holder)
	self.pnl_label_port = pnl_label_port
	pnl_label_port:Dock(LEFT)
	pnl_label_port:SetFont("quickconnect_font")
	pnl_label_port:SetTextColor(Color(255, 255, 255, 180))
	pnl_label_port:SetText("Port: ")
	
	local pnl_port = vgui.Create("DTextEntry", pnl_port_holder)
	self.pnl_port = pnl_port
	pnl_port:Dock(FILL)
	pnl_port:SetCursorColor(Color(255, 255, 255, 180))
	pnl_port:SetTextColor(Color(255, 255, 255, 180))
	pnl_port:SetFont("quickconnect_font2")
	pnl_port:SetDrawBackground(false)
	pnl_port._Paint = pnl_port.Paint
	hook_event(self, "Port", "Paint")
	
	local pnl_password_holder = vgui.Create("Panel", self)
	pnl_password_holder:Dock(TOP)
	pnl_password_holder:SetTall(24)
	pnl_password_holder:DockMargin(0, 0, 0, 4)
	
	local pnl_label_password = vgui.Create("DLabel", pnl_password_holder)
	self.pnl_label_password = pnl_label_password
	pnl_label_password:Dock(LEFT)
	pnl_label_password:SetFont("quickconnect_font")
	pnl_label_password:SetTextColor(Color(255, 255, 255, 180))
	pnl_label_password:SetText("Password: ")
	
	local pnl_password = vgui.Create("DTextEntry", pnl_password_holder)
	self.pnl_password = pnl_password
	pnl_password:Dock(FILL)
	pnl_password:SetCursorColor(Color(255, 255, 255, 180))
	pnl_password:SetTextColor(Color(255, 255, 255, 180))
	pnl_password:SetFont("quickconnect_font2")
	pnl_password:SetDrawBackground(false)
	pnl_password._Paint = pnl_password.Paint
	hook_event(self, "Password", "Paint")
	
	local pnl_custom_name_holder = vgui.Create("Panel", self)
	pnl_custom_name_holder:Dock(TOP)
	pnl_custom_name_holder:SetTall(24)
	pnl_custom_name_holder:DockMargin(0, 0, 0, 4)
	
	local pnl_label_custom_name = vgui.Create("DLabel", pnl_custom_name_holder)
	self.pnl_label_custom_name = pnl_label_custom_name
	pnl_label_custom_name:Dock(LEFT)
	pnl_label_custom_name:SetFont("quickconnect_font")
	pnl_label_custom_name:SetTextColor(Color(255, 255, 255, 180))
	pnl_label_custom_name:SetText("Custom Name: ")
	
	local pnl_custom_name = vgui.Create("DTextEntry", pnl_custom_name_holder)
	self.pnl_custom_name = pnl_custom_name
	pnl_custom_name:Dock(FILL)
	pnl_custom_name:SetCursorColor(Color(255, 255, 255, 180))
	pnl_custom_name:SetTextColor(Color(255, 255, 255, 180))
	pnl_custom_name:SetFont("quickconnect_font2")
	pnl_custom_name:SetDrawBackground(false)
	pnl_custom_name._Paint = pnl_custom_name.Paint
	hook_event(self, "Custom_Name", "Paint")
	
	local pnl_footer = vgui.Create("Panel", self)
	pnl_footer:Dock(TOP)
	pnl_footer:SetTall(16)
	
	local pnl_finish = vgui.Create("nice_button", pnl_footer)
	self.pnl_finish = pnl_finish
	pnl_finish:Dock(RIGHT)
	pnl_finish:SetWide(16)
	pnl_finish:SetMaterial(mat_icon_finish)
	hook_event(self, "Finish", "DoClick")
	
	pnl_port:SetText("27015")
	
	if game.GetMap() != "menu" and current_address then
		-- Default to server's IP...
		-- That is, if there even was a way to get the server ip
		-- this is your local ip, not the server your connected to..
		--pnl_address:SetText(GetConVarString("ip"))
		
		-- So a "workaround"
		addr, port = current_address:match("(.-):(.-)")
		pnl_address:SetText(addr)
		pnl_port:SetText(port)
	end
end

function PANEL:Close_DoClick()
	self:Remove()
end

function PANEL:Finish_DoClick()
	local ip = self.pnl_address:GetValue():Trim()
	local port = self.pnl_port:GetValue():Trim()
	local password = self.pnl_password:GetValue()
	local custom_name = self.pnl_custom_name:GetValue()
	
	if ip == "" then return end
	if port == "" then return end
	
	if custom_name == "" then
		custom_name = nil
	end
	
	if not self:GetID() then
		add_server(ip, port, password, custom_name)
	else
		set_server(self:GetID(), ip, port, password, custom_name)
	end
	
	pnl_quickconnect:Rebuild()
	self:Remove()
end

local function paint_rounded_outline(r, x, y, w, h)
	surface.DrawLine(x+r  , y     , x+w-r, y      )
	surface.DrawLine(x+r  , y+h-1 , x+w-r, y+h-1  )
	surface.DrawLine(x    , y+r   , x      , y+h-r)
	surface.DrawLine(x+w-1, y+r   , x+w-1  , y+h-r)
	
	local a = r/2
	surface.SetMaterial(mat_corner)
	surface.DrawTexturedRectRotated(a, a, r, r, 0)
	surface.DrawTexturedRectRotated(a, y+h-a, r, r, 90)
	surface.DrawTexturedRectRotated(x+w-a, y+h-a, r, r, 180)
	surface.DrawTexturedRectRotated(x+w-a, a, r, r, 270)
end

local function paint_text_entry(pnl, w, h)
	draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 200))
	surface.SetDrawColor(0, 0, 0, 200)
	paint_rounded_outline(4, 0, 0, w, h)
	pnl:_Paint(w, h)
end

function PANEL:Address_Paint(w, h)
	paint_text_entry(self.pnl_address, w, h)
end
function PANEL:Port_Paint(w, h)
	paint_text_entry(self.pnl_port, w, h)
end
function PANEL:Password_Paint(w, h)
	paint_text_entry(self.pnl_password, w, h)
end
function PANEL:Custom_Name_Paint(w, h)
	paint_text_entry(self.pnl_custom_name, w, h)
end

function PANEL:SetIP(ip)
	self.pnl_address:SetText(ip or "")
end

function PANEL:SetPort(port)
	self.pnl_port:SetText(port or "")
end

function PANEL:SetPassword(password)
	self.pnl_password:SetText(password or "")
end

function PANEL:SetCustomName(custom_name)
	self.pnl_custom_name:SetText(custom_name or "")
end

function PANEL:PerformLayout()
	self.pnl_label_address:SetWide(self:GetWide()/4)
	self.pnl_label_port:SetWide(self:GetWide()/4)
	self.pnl_label_password:SetWide(self:GetWide()/4)
	self.pnl_label_custom_name:SetWide(self:GetWide()/4)
	
	self:SizeToChildren(false, true)
end

function PANEL:Paint(w, h)
	
	local desired = 100
	
	if self.mouse_inside then
		desired = 255
	end
	
	self.alpha = math.Approach(self.alpha or desired, desired, FrameTime()*1200)
	self:SetAlpha(self.alpha)
	
	draw.RoundedBox(8, 0, 0, w, h, Color(0, 0, 0, 210))
end

local nextupdate = 0
function PANEL:Think()
	local x, y = self:CursorPos()
	self.mouse_inside = x > 0 and y > 0 and x < self:GetWide() and y < self:GetTall()
end

vgui.Register("server_editor", PANEL, "EditablePanel")

----------------------------------------------------------------------------------------------------

local function open_editor(id)
	local pnl_editor = vgui.Create("server_editor")
	pnl_editor:SetSize(400, 10)
	pnl_editor:Center()
	
	pnl_editor:MakePopup()
	pnl_editor:MoveToFront()
	pnl_editor:SetKeyBoardInputEnabled(true)
	
	return pnl_editor
end

----------------------------------------------------------------------------------------------------

local PANEL = {}

AccessorFunc(PANEL, "color", "Color")

function PANEL:DoClick() end

function PANEL:Init()
	self:SetColor(Color(255, 255, 255, 255))
end

function PANEL:SetMaterial(mat)
	self.material = mat
end

function PANEL:Paint(w, h)
	
	if not self.material then return end
	
	local desired_alpha = 0
	
	if self.mouse_inside then
		desired_alpha = 180
	end
	
	self.glow_alpha = self.glow_alpha or 0
	self.glow_alpha = math.Approach(self.glow_alpha, desired_alpha, FrameTime()*1500)
	
	local r = self.color.r
	local g = self.color.g
	local b = self.color.b
	local a = self.color.a
	
	if self.glow_alpha > 0 then
		surface.SetMaterial(mat_glow)
		surface.SetDrawColor(r, g, b, self.glow_alpha)
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
	self.mouse_inside = x > 0 and y > 0 and x < self:GetWide() and y < self:GetWide()
end

vgui.Register("nice_button", PANEL)

----------------------------------------------------------------------------------------------------

local PANEL = {}

AccessorFunc(PANEL, "spacing", "Spacing")

function PANEL:OnCanvasHeightChange(height) end

function PANEL:Init()
	
	self.panels = {}
	
	self:SetSpacing(4)
	
	local pnl_canvas = vgui.Create("Panel", self)
	self.pnl_canvas = pnl_canvas
end

function PANEL:SetCanvasPercentage(percent)
	self:SetCanvasY(self:GetCanvasYMax() * percentage)
end

function PANEL:SetCanvasY(y)
	if self:GetCanvasHeight() < self:GetTall() then
		self.pnl_canvas.y = 0
		return
	end
	self.pnl_canvas.y = -math.Clamp(y, 0, self:GetCanvasYMax())
end

function PANEL:GetCanvasY()
	return -self.pnl_canvas.y
end

function PANEL:GetCanvasYMax()
	return self:GetCanvasHeight()-self:GetTall()
end

function PANEL:AddCanvasY(y)
	self:SetCanvasY(self:GetCanvasY() + y)
end

function PANEL:GetCanvasHeight()
	return self.pnl_canvas:GetTall()
end

function PANEL:AddItem(pnl)
	table.insert(self.panels, pnl)
	pnl:SetParent(self.pnl_canvas)
	
	self:Rebuild()
end

function PANEL:GetItems()
	return self.panels
end

function PANEL:Clean()
	local new_panels = {}
	for k,pnl in ipairs(self.panels) do
		if pnl:IsValid() and pnl:GetParent() == self.pnl_canvas then
			table.insert(new_panels, pnl)
		end
	end
	self.panels = new_panels
end

function PANEL:Clear()
	self:Clean()
	for _,pnl in pairs(self.panels) do
		pnl:Remove()
	end
	self.panels = {}
end

function PANEL:Rebuild()
	local pnl_canvas = self.pnl_canvas
	self:Clean()
	
	local x = self.spacing
	local y = self.spacing
	for _,pnl in ipairs(self.panels) do
		pnl:SetWide(self:GetWide() - self.spacing*2)
		pnl:SetPos(x, y)
		y = y + pnl:GetTall() + self.spacing
	end
	
	pnl_canvas:SetWide(self:GetWide())
	pnl_canvas:SetTall(y)
	self:OnCanvasHeightChange(y)
end

function PANEL:PerformLayout()
	self:Rebuild()
end

function PANEL:OnMouseWheeled(delta)
	self:AddCanvasY(-delta*10)
end

vgui.Register("panel_list", PANEL)

----------------------------------------------------------------------------------------------------

local PANEL = {}


function PANEL:OnChange(value) end
function PANEL:GetValue() return 0 end
function PANEL:GetMaxValue() return 1 end
function PANEL:GetViewHeight() return self:GetTall() end

function PANEL:Init()
	self:SetValue(0)
	
end

function PANEL:SetPercentage(percentage)
	self:SetValue(self:GetMaxValue()*percentage)
end

function PANEL:SetValue(value)
	self:OnChange(value)
end
function PANEL:SetBarY(bary)
	local percent = bary / (self:GetTall()-self.barh)
	local y = self:GetMaxValue()*percent
	
	self:SetValue(y)
end

function PANEL:Update()
	local percent = self:GetValue()/self:GetMaxValue()
	
	self.barw = self:GetWide()
	self.barh = math.Clamp(self:GetMaxValue()/self:GetViewHeight(), 8, self:GetTall())
	
	local y_room = self:GetTall()-self.barh
	
	self.barx = (self:GetWide()-self.barw)/2
	self.bary = y_room*percent
end

function PANEL:OnMousePressed()
	local x, y = self:CursorPos()
	
	self.mouse_down = true
	
	if x > self.barx and y > self.bary and x < self.barx+self.barw and y < self.bary+self.barh then
		self.drag_offset = y-self.bary
	end
end
function PANEL:Think()
	local x, y = self:CursorPos()
	
	self.mouse_down = self.mouse_down and input.IsMouseDown(MOUSE_LEFT)
	
	if not self.mouse_down then return end
	
	if self.drag_offset then
		self:SetBarY(y-self.drag_offset)
	else
		self:SetBarY(y-self.barh/2)
	end
end

function PANEL:Paint()
	self:Update()
	draw.RoundedBox(4, self.barx, self.bary, self.barw, self.barh, Color(255, 255, 255, 100))
end

vgui.Register("scrollbar", PANEL)

----------------------------------------------------------------------------------------------------

local PANEL = {}

AccessorFunc(PANEL, "id", "ID")
AccessorFunc(PANEL, "ip", "IP")
AccessorFunc(PANEL, "port", "Port")
AccessorFunc(PANEL, "password", "Password")
AccessorFunc(PANEL, "custom_name", "CustomName")

function PANEL:Init()
	self:SetPort("27015")
	self:SetPassword("")
	
	local pnl_remove = vgui.Create("nice_button", self)
	self.pnl_remove = pnl_remove
	pnl_remove:Dock(RIGHT)
	pnl_remove:SetMaterial(mat_icon_remove)
	hook_event(self, "Remove", "DoClick")
	
	local pnl_edit = vgui.Create("nice_button", self)
	self.pnl_edit = pnl_edit
	pnl_edit:Dock(RIGHT)
	pnl_edit:SetMaterial(mat_icon_edit)
	hook_event(self, "Edit", "DoClick")
	
	local pnl_connect = vgui.Create("nice_button", self)
	self.pnl_connect = pnl_connect
	pnl_connect:Dock(RIGHT)
	pnl_connect:SetMaterial(mat_icon_connect)
	hook_event(self, "Connect", "DoClick")
end

function PANEL:Remove_DoClick()
	remove_server(self.id)
	pnl_quickconnect:Rebuild()
end

function PANEL:Edit_DoClick()
	local pnl = open_editor()
	pnl:SetID(self:GetID())
	pnl:SetIP(self:GetIP())
	pnl:SetPort(self:GetPort())
	pnl:SetPassword(self:GetPassword())
	pnl:SetCustomName(self:GetCustomName())
end

function PANEL:Connect_DoClick()
	RunConsoleCommand("password", self:GetPassword() or "")
	JoinServer(self.ip..":"..self.port)
end

function PANEL:PerformLayout()
	self.pnl_edit:SetWide(self.pnl_edit:GetTall())
	self.pnl_remove:SetWide(self.pnl_remove:GetTall())
	self.pnl_connect:SetWide(self.pnl_connect:GetTall())
end

local match_name = "Name:.-<b>(.-)</b>"
local match_status = "<span class=\"item_color_title\">Status:</span>%s*<span class=\".-\">%s*(.-)%s*</span>"
local match_players = "<span id=\"HTML_num_players\">(.-)</span>.-<span id=\"HTML_max_players\">(.-)</span>"

local function parse_html_text(text)
	if not text then return nil end
	text = text:gsub("&#(%d+);", function(num) return string.char(tonumber(num)) end)
	text = text:gsub("&lt;", "<")
	text = text:gsub("&gt;", ">")
	return text
end

local nextupdate = 0
function PANEL:GetInfo()
	if self.name then return end
	
	if CurTime() < nextupdate then return end
	nextupdate = CurTime()+0.2
	
	self.name = self.custom_name or tostring(self.ip)
	self.name_adjusted = nil
	self.alive = true
	self.players = -1
	self.players_max = -1
	
	local url = Format("http://www.gametracker.com/server_info/%s:%s", self.ip, self.port)
	http.Fetch(url, function(body, length, headers, code)
			
			if not IsValid(self) then return end
			
			local name = body:match(match_name)
			local status = body:match(match_status)
			local players, players_max = body:match(match_players)
			
			if name then
				self.name = self.custom_name or parse_html_text(name)
				self.name_adjusted = nil
				self.alive = status == "Alive"
				self.players = tonumber(players or "") or -1
				self.players_max = tonumber(players_max or "") or -1
				
				if self.alive then
					self.pnl_connect:SetColor(Color(255, 255, 255, 255))
				else
					self.pnl_connect:SetColor(Color(255, 160, 160, 255))
				end
			end
		end,
		function(error)
			
		end)
	
	serverlist.PlayerList(Format("%s:%s", self.ip, self.port), function(tbl)
		if tbl and self.players == -1 then
			self.players = table.Count(tbl)
		end
		end)
end

function PANEL:FitText(str, width)
	local tw, th = surface.GetTextSize(str)
	
	if tw > width then
		while tw > width and #str > 0 do
			str = str:sub(1, #str-1)
			tw, th = surface.GetTextSize(str.."...")
		end
		return str.."..."
	else
		return str
	end
end

function PANEL:Paint(w, h)
	
	surface.SetFont("quickconnect_font")
	
	if not self.name then
		local tw, th = surface.GetTextSize(tostring(self.ip)..":"..tostring(self.port))
		surface.SetTextPos(4, h/2-th/2)
		surface.SetTextColor(255, 255, 255, 180)
		surface.DrawText(tostring(self.ip))
	else
		
		if not self.name_adjusted then
			self.name_adjusted = self:FitText(self.name, self:GetWide()*0.75-16)
		end
		
		local text = self.name_adjusted
		local tw, th = surface.GetTextSize(text)
		surface.SetTextPos(4, h/2-th/2)
		surface.SetTextColor(255, 255, 255, 180)
		surface.DrawText(text)
		
		text = tostring(self.players >= 0 and self.players or "?")
		local tw, th = surface.GetTextSize(text)
		surface.SetTextPos(self:GetWide()*0.75+20-tw, h/2-th/2)
		surface.DrawText(text)
		
		text = " / "
		local tw, th = surface.GetTextSize(text)
		surface.SetTextPos(self:GetWide()*0.75+20, h/2-th/2)
		surface.DrawText(text)
		
		text = tostring(self.players_max >= 0 and self.players_max or "?")
		surface.SetTextPos(self:GetWide()*0.75+20+tw, h/2-th/2)
		surface.DrawText(text)
	end
end

vgui.Register("server_line", PANEL)

----------------------------------------------------------------------------------------------------

local PANEL = {}

function PANEL:Init()
	
	self:DockPadding(8, 8, 8, 8)
	
	local pnl_right = vgui.Create("Panel", self)
	pnl_right:Dock(RIGHT)
	pnl_right:SetWide(16)
	
	local pnl_add = vgui.Create("nice_button", pnl_right)
	self.pnl_add = pnl_add
	pnl_add:SetTall(16)
	pnl_add:Dock(BOTTOM)
	pnl_add:SetMaterial(mat_icon_add)
	hook_event(self, "Add", "DoClick")
	
	local pnl_refresh = vgui.Create("nice_button", pnl_right)
	self.pnl_refresh = pnl_refresh
	pnl_refresh:SetTall(16)
	pnl_refresh:Dock(BOTTOM)
	pnl_refresh:SetMaterial(mat_icon_refresh)
	hook_event(self, "Refresh", "DoClick")
	
	local pnl_hide = vgui.Create("nice_button", pnl_right)
	self.pnl_hide = pnl_hide
	pnl_hide:SetTall(16)
	pnl_hide:Dock(TOP)
	pnl_hide:SetMaterial(mat_icon_minus)
	hook_event(self, "Hide", "DoClick")
	
	local pnl_bar = vgui.Create("scrollbar", pnl_right)
	self.pnl_bar = pnl_bar
	pnl_bar:Dock(FILL)
	hook_event(self, "Bar", "OnChange")
	hook_event(self, "Bar", "GetValue")
	hook_event(self, "Bar", "GetMaxValue")
	
	local pnl_list = vgui.Create("panel_list", self)
	self.pnl_list = pnl_list
	pnl_list:Dock(FILL)
	
	self:Rebuild()
end

function PANEL:Bar_OnChange(y)
	self.pnl_list:SetCanvasY(y)
end
function PANEL:Bar_GetValue()
	return self.pnl_list:GetCanvasY()
end
function PANEL:Bar_GetMaxValue()
	return self.pnl_list:GetCanvasYMax()
end

function PANEL:Refresh_DoClick()
	self:Rebuild()
end

function PANEL:Add_DoClick()
	open_editor()
end

function PANEL:Hide_DoClick()
	self:SetVisible(false)
end

function PANEL:Rebuild()
	self.pnl_list:Clear()
	for id,tbl in ipairs(servers) do
		local pnl = vgui.Create("server_line")
		pnl:SetTall(16)
		pnl:SetID(id)
		pnl:SetIP(tbl[1])
		pnl:SetPort(tbl[2])
		pnl:SetPassword(tbl[3])
		pnl:SetCustomName(tbl[4])
		self.pnl_list:AddItem(pnl)
	end
end

function PANEL:PerformLayout()
end

function PANEL:Paint(w, h)
	
	local desired = 100
	
	if self.mouse_inside then
		desired = 255
	end
	
	self.alpha = math.Approach(self.alpha or desired, desired, FrameTime()*1200)
	self:SetAlpha(self.alpha)
	
	draw.RoundedBox(8, 0, 0, w, h, Color(0, 0, 0, 210))
end

local nextupdate = 0
function PANEL:Think()
	local x, y = self:CursorPos()
	self.mouse_inside = x > 0 and y > 0 and x < self:GetWide() and y < self:GetTall()
	
	if CurTime() < nextupdate then return end
	nextupdate = CurTime()+0.2
	
	for _,pnl in pairs(self.pnl_list:GetItems()) do
		pnl:GetInfo()
	end
end

vgui.Register("quick_connect", PANEL)

----------------------------------------------------------------------------------------------------

timer.Simple(1, function()
	local pnl = vgui.Create("quick_connect")
	pnl:SetSize(600, 200)
	pnl:AlignBottom(50)
	pnl:AlignRight(50)
	
	pnl:MakePopup()
	pnl:MoveToFront()
	
	pnl_quickconnect = pnl
end)

concommand.Add("menu_quickconnect", function()
	pnl_quickconnect:SetVisible(true)
end)

concommand.Add("openserverbrowser", function()
	RunGameUICommand("OpenServerBrowser")
end)

concommand.Add("lua_run_menu", function(_, _, _, raw)
	RunStringEx(raw, "lua_run_menu")
end)

concommand.Add("lua_openscript_menu", function(_, _, args)
	if #args <= 0 then print("File not specified") return end
	include(args[1])
end)
