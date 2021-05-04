function make_type(kind)
    return function(obj)
        return setmetatable(obj, kind)
    end
end

local kinds = {
    Nil = {kind = 'nil'},
    Number = {kind = 'number'},
    Boolean = {kind = 'boolean'},
    List = {kind = 'list'},
}

local types = {}
for k, v in pairs(kinds) do
    types[k] = make_type(v)
end

function const(t, x)
    return function()
        return t(x)
    end
end

function arg1(t)
    return function(x)
        return t({value = x})
    end 
end

function argn(t)
    return function(...)
        local value = {}
        local n = select('#', ...)
        for i = 1, n do
            value[#value + 1] = select(i, ...)
        end
        return t({value = value })
    end
end

return {
    Nil = const(types.Nil, {}),
    Number = arg1(types.Number),
    Boolean = arg1(types.Boolean),
    List = argn(types.List),
}

