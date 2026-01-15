local day
local part
local filename = "inputs/test.txt"

while #arg > 0 do
	local a = table.remove(arg, 1)
	if string.sub(a, 1, 2) == "-d" then
		day = require(a:sub(2, #a))
	elseif string.sub(a, 1, 2) == "-p" then
		part = a:sub(3, #a)
	elseif a == "-f" then
		filename = table.remove(arg, 1)
	end
end

function love.load()
	love.graphics.setFont(love.graphics.newFont(24))
	local result = day.load(part or "1", filename)

	if result then
		love.system.setClipboardText(result)
	end
end

love.draw = day.draw
love.update = day.update

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
	if day.keypressed then
		return day.keypressed(key)
	end
end
