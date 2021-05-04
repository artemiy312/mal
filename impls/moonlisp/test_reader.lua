local lu = require('luaunit')
local reader = require('reader')
local t = require('types')

function make_test(input, expected)
    return function()
        local actual = reader.read_str(input)
        lu.assertEquals(actual, expected)
    end
end

test_spaces = make_test(" ,\f\n\r\t\v", nil)
test_number_1 = make_test("1", t.Number(1))
test_number_2 = make_test("123", t.Number(123))
test_nil = make_test("nil", t.Nil())
test_false = make_test("false", t.Boolean(false))
test_true = make_test("true", t.Boolean(true))

test_list_empty = make_test("()", t.List())
test_list_one = make_test("(1)", t.List(t.Number(1)))
test_list_atom = make_test(
    "(true false 123 nil)",
    t.List(
        t.Boolean(true),
        t.Boolean(false),
        t.Number(123),
        t.Nil()))

os.exit(lu.LuaUnit.run())
