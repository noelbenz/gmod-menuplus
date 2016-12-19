
local PANEL = {}

function PANEL:Init()

	local pnl = vgui.Create("MPScrollPanel", self)
	pnl:Dock(FILL)

	for i=1, 100 do
		local item = vgui.Create("DLabel")
		item:SetText("Hola "..i)
		pnl:AddItem(item)
		item:Dock(TOP)
	end
end

vgui.Register("MPServerBrowser", PANEL, "MPFadeFrame")




local pnlBrowser

local function queryServerList()
	local data = {}

	data.Callback = function(ping, name, desc, map, players, maxplayers,
	                         botplayers, pass, lastplayed, address,
	                         gamemode, workshopid)
		print(ping, name, desc, map)
		return false
	end
	data.Finished = function()
		print("done")
	end
	data.Type = "internet"
	data.AppID = 4000
	data.GameDir = "garrysmod"

	serverlist.Query(data)
end

concommand.Add("menu_browser", function()

	if IsValid(pnlBrowser) then
		if pnlBrowser:IsVisible() then
			pnlBrowser:SetVisible(false)
		else
			pnlBrowser:SetVisible(true)
		end
	end

	local pnl = vgui.Create("MPServerBrowser")
	pnl:SetSize(500, 500)
	pnl:SetPos(300, 300)
	pnl:MakePopup()
	pnl:MoveToFront()
	pnl:SetKeyBoardInputEnabled(true)

	pnlBrowser = pnl

	queryServerList()
end)

