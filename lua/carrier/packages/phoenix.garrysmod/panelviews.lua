PanelViews = {}
PanelViews.Map = setmetatable ({}, { __mode = "k" })

function PanelViews.GetView (panel)
	local view = PanelViews.Map [panel]
	if view then return view end
	
	view = ExternalView (panel)
	PanelViews.Register (panel, view)
	
	return view
end

function PanelViews.Register (panel, view)
	PanelViews.Map [panel] = view
end

function PanelViews.Unregister (panel, view)
	PanelViews.Map [panel] = nil
end
