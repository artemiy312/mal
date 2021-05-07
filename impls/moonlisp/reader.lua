local lpeg = require('lpeg')
local t = require('types')

local S = lpeg.S
local V = lpeg.V
local C = lpeg.C
local P = lpeg.P
local R = lpeg.R
local B = lpeg.B
local Ct = lpeg.Ct
local Cmt = lpeg.Cmt

local grammar = {
    [1] = V('forms')^1,

    forms =
        V('spaces')
        + V('nil')
        + V('number')
        + V('boolean')
        + V('string')
        + V('comment')
        + V('splice-unquote')
        + V('symbol')
        + V('list')
        + V('sink'),

    escape = S(" \f\n\r\t\v[]{}()'\"`,;"),
    spaces = S('\f\n\r\t\v, '),

    list =
        P('(')
        * Ct(V("forms")^0)
        / t.List
       * (
            P(')')
            + function(match)
                error(t.Error(string.format(
                    "Missed RPAREN: %s. EOF",
                    match)))
            end),

    symbol =
        C((P(1) - V('escape'))^1)
        / t.Symbol,

   ["nil"] =
        C('nil')
        / t.Nil,

    number =
        C(R('09')^1)
        / function(token)
            local number = tonumber(token)
            return t.Number(number)
        end,

    boolean =
        (C('false') + C('true'))
        / function(token)
            bool = false
            if token == 'true' then
                bool = true
            end
            return t.Boolean(bool)
        end,

    string =
        P('"')
        * Ct((
            Cmt('\\"', function()
                return true, '\\"'
            end)
            + Cmt('\\\\', function(s, p)
                return true, '\\\\'
            end)
            + C(1 - P('"'))
        )^0)
        / function(tokens)
            return t.String(table.concat(tokens, ''))
        end
        * (
            P('"')
            + function(match)
                error(t.Error(string.format(
                    "Missed doublequote: %s. EOF",
                    match)))
            end),

    comment =
        P(';')
        * C(P(1)^0 - P('\n')^-1)
        / function(token)
            return nil
        end,

    ['splice-unquote'] =
        C('~@')
        / function()
            -- TODO
            return nil
        end,

    sink =
        -- TODO
        C(S('\'`~^@'))
        / function(token)
            return nil
        end,

}

function read_str(line)
    local _, matched = pcall(lpeg.match, grammar, line)
    if type(matched) ~= 'table' then
        return nil
    end
    return matched
end

return {
    read_str = read_str,
}

