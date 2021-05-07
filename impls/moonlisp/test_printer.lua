local t = require("types")
local lu = require("luaunit")
local p = require("printer")

function make_test(input, expected)
  return function()
    local actual = p.pr_str(input)
    lu.assertEquals(actual, expected)
  end
end

test_empty = make_test(nil, "")
test_nil = make_test(t.Nil(), "nil")
test_true = make_test(t.Boolean(true), "true")
test_false = make_test(t.Boolean(false), "false")
test_symbol = make_test(t.Symbol("abc"), "abc")
test_string_empty = make_test(t.String(''), '""')
test_string = make_test(t.String('abc'), '"abc"')
test_list_empty = make_test(t.List({}), "()")
test_list_atom = make_test(
  t.List({
    t.Number(1),
    t.Symbol("abc"),
    t.Boolean(false),
    t.String('hello world')}),
  "(1 abc false \"hello world\")")

os.exit(lu.LuaUnit.run())
