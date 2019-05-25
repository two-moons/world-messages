local t = require(script.Parent.Lib.t)

local types = {}

types.IMessage = t.interface({
	id = t.string,
	authorId = t.string,
	body = t.string,
	time = t.number,
})

return types
