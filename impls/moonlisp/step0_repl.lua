rl = require('readline')

function READ(line)
    return line
end

function EVAL(line)
    return line
end

function PRINT(line)
    return line
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
