local Roact = require(script.Parent.Parent.Lib.Roact)
local t = require(script.Parent.Parent.Lib.t)
local Config = require(script.Parent.Parent.Config)
local Styles = require(script.Parent.Parent.Styles)
local Messages = require(script.Parent.Parent.Messages)
local Types = require(script.Parent.Parent.Types)
local Avatar = require(script.Parent.Avatar)
local MessageMeta = require(script.Parent.MessageMeta)
local MessageBody = require(script.Parent.MessageBody)
local Padding = require(script.Parent.Padding)
local CameraDistanceProvider = require(script.Parent.CameraDistanceProvider)
local StudioThemeAccessor = require(script.Parent.StudioThemeAccessor)

local Props = t.interface({
	message = Types.IMessage
})

local function getScaleFromDistance(distance)
	-- (distance, scale) pairs
	local d1, s1 = 20, 1.2
	local d2, s2 = 80, 0.05

	local slope = (s2-s1)/(d2-d1)

	-- slope-point form
	local scale = slope*(distance-d1) + s1

	return math.clamp(scale, s2, s1)
end

local function BillboardMessage(props)
	assert(Props(props))

	return StudioThemeAccessor.withTheme(function(theme)
		local messagePart = Messages.getMessagePartById(props.message.id)

		return Roact.createElement(CameraDistanceProvider, {
			origin = messagePart.Position,
			render = function(distance)
				return Roact.createElement("BillboardGui", {
					MaxDistance = Config.BILLBOARD_MAX_DISTANCE,
					Size = UDim2.new(0, 450, 0, 200),
					LightInfluence = 0,
					Adornee = messagePart
				}, {
					Container = Roact.createElement("Frame", {
						BackgroundColor3 = theme:GetColor("MainBackground"),
						Size = UDim2.new(1, 0, 1, 0),
						BorderSizePixel = 0,

						-- This makes it so when the scale is changed, the billboard remains
						-- at the center.
						AnchorPoint = Vector2.new(.5, .5),
						Position = UDim2.new(.5, 0, .5, 0),
					}, {
						Scale = Roact.createElement("UIScale", {
							Scale = getScaleFromDistance(distance)
						}),

						Padding = Roact.createElement(Padding),

						Layout = Roact.createElement("UIListLayout", {
							SortOrder = Enum.SortOrder.LayoutOrder,
							FillDirection = Enum.FillDirection.Horizontal
						}),

						Sidebar = Roact.createElement("Frame", {
							Size = UDim2.new(1/5, 0, 1, 0),
							BackgroundTransparency = 1,
							LayoutOrder = 1,
						}, {
							Avatar = Roact.createElement(Avatar, {
								userId = props.message.authorId,
								maskColor = theme:GetColor("MainBackground")
							})
						}),

						Main = Roact.createElement("Frame", {
							Size = UDim2.new(4/5, -Styles.Padding, 1, 0),
							BackgroundTransparency = 1,
							LayoutOrder = 2,
						}, {
							Layout = Roact.createElement("UIListLayout", {
								SortOrder = Enum.SortOrder.LayoutOrder,
								Padding = UDim.new(0, Styles.Padding)
							}),

							Padding = Roact.createElement("UIPadding", {
								PaddingLeft = UDim.new(0, Styles.Padding)
							}),

							Meta = Roact.createElement(MessageMeta, {
								message = props.message,
								size = UDim2.new(1, 0, 0, 22),
								layoutOrder = 1,
							}),

							Body = Roact.createElement(MessageBody, {
								message = props.message,
								size = UDim2.new(1, 0, 0.85, 0),
								layoutOrder = 2,
							})
						})
					})
				})
			end
		})

	end)
end

return BillboardMessage
