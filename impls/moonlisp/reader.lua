local lpeg = require('lpeg')
local t = require('types')

local S = lpeg.S
local V = lpeg.V
local C = lpeg.C
local P = lpeg.P
local R = lpeg.R
local Cmt = lpeg.Cmt

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

    spaces = Cmt(
        S('\f\n\r\t\v, '),
        function()
            return true, nil
        end),

    list =
        P('(')
        * Cmt(
            V('forms')^0,
            function(subj, pos, ...)
                local n = select('#', ...)
                if n == 1 and select('1', ...) == "" then
                   return true, t.List()
                end
                return true, t.List(...)
             end)
        * (
            P(')')
            + function(match)
                error(string.format(
                    "There are missed RPAREN: %s",
                    match))
            end),

    symbol =
        Cmt(
            (P(1) - S(' \f\n\r\t\v[]{}()\'"`,;'))^1,
            function(subj, pos, capture)
                return true, t.Symbol(capture)
            end),

   ["nil"] = Cmt(
        P('nil'),
        function()
            return true, t.Nil()
        end),

    number = Cmt(
        R('09')^1,
        function(subj, pos, capture)
            local number = tonumber(capture)
            if number == nil then
                cmt_error(subj, pos, cature)
            end
            return true, t.Number(number)
        end),

    boolean = Cmt(
        P('false') + P('true'),
        function(subj, pos, capture)
            bool = false
            if capture == 'true' then
                bool = true
            end
            return true, t.Boolean(bool)
        end),

    string =
        P('"')
        * Cmt(
            (P(1) - P('"')) + P('\"'),
            function(subj, pos, capture)
                -- TODO
                return true, nil
            end
        )^0
        * P('"'),

    comment =
        P(';')
        * Cmt(
            P(1)^0 - P('\n'),
            function(subj, pos, capture)
                -- TODO
                return true, nil
            end),

    ['splice-unquote'] = Cmt(
        P('~@'),
        function()
            -- TODO
            return true, nil
        end),

    sink =
        Cmt(
            -- TODO
            S('\'`~^@'),
            function(subj, pos, capture)
                return true, nil
            end),

}

function read_str(line)
    return lpeg.match(grammar, line)
end

return {
    read_str = read_str,
}

