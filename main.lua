local day
local part
local filename
local result

while #arg > 0 do
	local a = table.remove(arg, 1)
	local v
	if #a > 2 and a:sub(1, 1) == "-" then
		v = a:sub(3, #a)
		a = a:sub(1, 2)
	end
	if a == "-d" then
		local d = "d" .. (v or table.remove(arg, 1))
		day = require(d)
		if not filename then
			filename = "inputs/" .. d:sub(1, #a) .. ".txt"
		end
	elseif a == "-p" then
		part = v or table.remove(arg, 1)
	elseif a == "-f" then
		filename = v or table.remove(arg, 1)
	end
end

function love.load()
	local file = assert(io.open(filename))
	love.graphics.setFont(love.graphics.newFont(24))

	result = day[part or "1"](file)

	if result then
		love.system.setClipboardText(result)
	end
end

if day.draw then
	love.draw = day.draw
else
	function love.draw()
		love.graphics.print(result or "", 16, 16)
	end
end

if day.update then
	love.update = day.update
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
	if day.keypressed then
		return day.keypressed(key)
	end
end
