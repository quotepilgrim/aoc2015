return function(data)
	for _, row in ipairs(data) do
		if type(row) == "table" then
			print("{" .. table.concat(row, ", ") .. "}")
		else
			print(row)
		end
	end
end
