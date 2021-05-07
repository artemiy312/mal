function make_type(kind)
    return function(obj)
        obj.kind = kind
        return obj
    end
end

local kinds = {
    Nil = {kind = 'nil'},
    Symbol = {kind = 'symbol'},
    Number = {kind = 'number'},
    Boolean = {kind = 'boolean'},
    List = {kind = 'list'},
    String = {kind = 'string'},
    Error = {kind = 'error'},
}

local types = {}
for k, v in pairs(kinds) do
    types[k] = make_type(v.kind)
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

return {
    Nil = const(types.Nil, {}),
    Symbol = arg1(types.Symbol),
    Number = arg1(types.Number),
    Boolean = arg1(types.Boolean),
    List = arg1(types.List),
    String = arg1(types.String),
    Error = arg1(types.Error),
}

