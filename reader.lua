local lpeg = require('lpeg')
local t = require('types')

local S = lpeg.S
local V = lpeg.V
local C = lpeg.C
local P = lpeg.P
local R = lpeg.R
local Ct = lpeg.Ct

function cmt_error(subj, pos, capture, msg)
    local msg = string.format(
        ((msg or '')
        .. '\nParse error.'
        .. '\nCan\'t parse: \'%s\' from \'%s\''
        .. 'at position: %s'),
        capture, subj, pos)
    error(msg)
end

local grammar = {
    [1] = V('forms')^1,

    forms =
        V('spaces')
        + V('nil')
        + V('number')
        + V('boolean')
        + V('symbol')
        + V('string')
        + V('list')
        + V('comment')
        + V('splice-unquote')
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
                error(string.format(
                    "There are missed RPAREN: %s",
                    match))
            end),

    symbol =
        C((P(1) - V('escape'))^1)
        / t.Symbol,

   ["nil"] =
        C('nil')
        / t.Nil,
--        / function()
--            return t.Nil()
--        end,

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
        -- TODO
        P('"')
        * C(1)^0
        / function(token)
            return nil
        end
        * P('"'),

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
    local matched = lpeg.match(grammar, line)
    if type(matched) == "number" then
        return nil
    end
    return matched
end

return {
    read_str = read_str,
}

