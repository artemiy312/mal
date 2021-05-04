local lu = require('luaunit')
local reader = require('reader')
local t = require('types')

function make_test(input, expected)
    return function()
        local actual = reader.read_str(input)
        lu.assertEquals(actual, expected)
    end
end

test_empty = make_test("()", t.List())
test_spaces = make_test("( ,\f\n\r\t\v)", t.List())
test_number = make_test(
    "(1)",
    t.List(t.Number(1)))
test_nil = make_test(
    "(nil)",
    t.List(t.Nil()))
test_false = make_test(
    "(false)",
    t.List(t.Boolean(false)))
test_true = make_test(
    "(true)",
    t.List(t.Boolean(true)))

test_3_list = make_test(
    '(0 1 2)',
    t.List(t.Number(0), t.Number(1), t.Number(2)))

test_list = make_test(
    "(true false 123 nil)",
    t.List(
        t.Boolean(true),
        t.Boolean(false),
        t.Number(123),
        t.Nil()))

os.exit(lu.LuaUnit.run())
