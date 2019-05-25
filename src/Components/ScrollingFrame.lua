local Roact = require(script.Parent.Parent.Lib.Roact)
local StudioThemeAccessor = require(script.Parent.StudioThemeAccessor)

local function ScrollingFrame(props)
	local children = {}

	if props.List then
		local newProps = {}
		newProps[Roact.Ref] = function(rbx)
			if not rbx then return end
			local function update()
				if not rbx.Parent then return end
				local cs = rbx.AbsoluteContentSize
				rbx.Parent.CanvasSize = UDim2.new(0, 0, 0, cs.y)
			end
			rbx:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(update)
			update()
		end
		newProps.SortOrder = Enum.SortOrder.LayoutOrder
		for key,value in pairs(props.List == true and {} or props.List) do
			newProps[key] = value
		end
		children.UIListLayout = Roact.createElement("UIListLayout", newProps)
	end

	for key, value in pairs(props[Roact.Children]) do
		children[key] = value
	end

	return StudioThemeAccessor.withTheme(function(theme, themeEnum)
		return Roact.createElement("Frame", {
			Size = props.Size or UDim2.new(1, 0, 1, 0),
			Position = props.Position,
			AnchorPoint = props.AnchorPoint,
			BorderSizePixel = props.ShowBorder and 1 or 0,
			BackgroundColor3 = theme:GetColor("MainBackground"),
			BorderColor3 = theme:GetColor("Border"),
			LayoutOrder = props.LayoutOrder,
			ZIndex = props.ZIndex,
			Visible = props.Visible,
			ClipsDescendants = true,
			[Roact.Ref] = props[Roact.Ref],
		}, {
			BarBackground = Roact.createElement("Frame", {
				BackgroundColor3 = theme:GetColor("ScrollBarBackground"),
				Size = UDim2.new(0, 12, 1, 0),
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, 0, 0, 0),
				BorderSizePixel = 0,
			}),
			ScrollingFrame = Roact.createElement("ScrollingFrame", {
				Size = UDim2.new(1, -2, 1, 0),
				VerticalScrollBarInset = Enum.ScrollBarInset.Always,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ScrollBarThickness = 8,
				TopImage = "rbxasset://textures/StudioToolbox/ScrollBarTop.png",
				MidImage = "rbxasset://textures/StudioToolbox/ScrollBarMiddle.png",
				BottomImage = "rbxasset://textures/StudioToolbox/ScrollBarBottom.png",
				ScrollBarImageColor3 = themeEnum == Enum.UITheme.Dark and Color3.fromRGB(85, 85, 85) or Color3.fromRGB(245, 245, 245),--theme:GetColor("ScrollBar"),
			}, children)
		})
	end)
end

return ScrollingFrame
