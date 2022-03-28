function split (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

function slice (tbl, s, e)
        local pos, new = 1, {}
        
        for i = s, e do
            new[pos] = tbl[i]
            pos = pos + 1
        end
        
        return new
    end

return {split = split,slice = slice}