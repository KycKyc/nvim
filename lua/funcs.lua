_G.P = function(...)
	local n = select("#", ...)
	local p = { ... }
	for i = 1, n do
		p[i] = vim.inspect(p[i])
	end
	print(table.concat(p, ", "))
	return ...
end

_G.Pp = function(o)
	for key, value in pairs(o) do
		print("found member " .. key)
		print(value)
	end

	for key, value in pairs(getmetatable(o)) do
		print(key, value)
	end
end
