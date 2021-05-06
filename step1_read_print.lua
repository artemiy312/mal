local rl = require('readline')

local r = require("reader")
local p = require("printer")

function READ(line)
    return r.read_str(line)
end

function EVAL(line)
    return line
end

function PRINT(line)
    return p.pr_str(line)
end

function rep(line)
    return PRINT(EVAL(READ(line)))
end

while true do
    local line = rl.readline('user> ')
    if line == nil then
        break
    end

    print(rep(line))
end
