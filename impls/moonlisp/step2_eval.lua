local rl = require('readline')

local r = require("reader")
local p = require("printer")
local t = require("types")

function reducer(fn)
    return function(xs)
        local res = 0
        if #xs >= 1 then
            res = xs[1].value
        end
        for i = 2, #xs do
            res = fn(res, xs[i].value)
        end
        return res
    end
end

function compo(fn1, fn2)
    return function(xs)
        return fn2(fn1(xs))
    end
end

local dummy_env = {
    ['+'] = compo(reducer(function(acc, x) return acc + x end), t.Number),
    ['-'] = compo(reducer(function(acc, x) return acc - x end), t.Number),
    ['*'] = compo(reducer(function(acc, x) return acc * x end), t.Number),
    ['/'] = compo(reducer(function(acc, x) return acc / x end), t.Number),
}

function eval_ast(ast, env)
    if ast.kind == 'symbol' then
        local symbol = env[ast.value]
        if symbol == nil then
            error(string.format(
                "Symbol `%s` is not found",
                ast.value))
        end
        return symbol
    elseif ast.kind == 'list' then
        local result = {}
        for _, node in pairs(ast.value) do
            result[#result + 1] = EVAL(node, env)
        end
        return result
    else
        return ast
    end
end

function apply(xs)
    fn = xs[1]
    return fn(table.pack(table.unpack(xs, 2)))
end

function READ(line)
    return r.read_str(line)
end

function EVAL(ast, env)
    if ast.kind ~= 'list' then
        return eval_ast(ast, env)
    end
    if #ast.value == 0 then
        return ast
    end

    local ok, ast = pcall(eval_ast, ast, env)
    if not ok then
        return t.Error(ast)
    end
    return apply(ast)
end

function PRINT(ast)
    return p.pr_str(ast)
end

function rep(line)
    return PRINT(EVAL(READ(line), dummy_env))
end

while true do
    local line = rl.readline('user> ')
    if line == nil then
        break
    end

    ok, res = pcall(rep, line)
    if not ok then
        print("Error: " .. tostring(res))
    else
        print(res)
    end
end
