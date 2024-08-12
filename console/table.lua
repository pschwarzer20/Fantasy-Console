
table = table or {}

function table.Merge(dest, source)
	for k, v in pairs(source) do
		dest[k] = v
	end

	return dest
end

function table.GetKeys( tab )

	local keys = {}
	local id = 1

	for k, v in pairs( tab ) do
		keys[ id ] = k
		id = id + 1
	end

	return keys

end

function table.RemoveByValue( tbl, val )
	local newTable = {}

    for k, v in pairs(tbl) do
		if (not v == val) then
			newTable[k] = v
		end
	end

	tbl = newTable
end

function table.Print( t, indent, done )
	local Msg = Msg

	done = done or {}
	indent = indent or 0
	local keys = table.GetKeys( t )

	table.sort( keys, function( a, b )
		if ( isnumber( a ) and isnumber( b ) ) then return a < b end
		return tostring( a ) < tostring( b )
	end )

	done[ t ] = true

	for i = 1, #keys do
		local key = keys[ i ]
		local value = t[ key ]
		key = ( type( key ) == "string" ) and tostring( key )

		if  ( istable( value ) and not done[ value ] ) then

			done[ value ] = true
			print( key )
			table.Print( value, indent + 2, done )
			done[ value ] = nil

		else

			print( key, "\t=\t", value)

		end

	end

	print("")

end
