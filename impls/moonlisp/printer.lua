
function pr_str(ast)
  if ast == nil then
    return ""
  end

  if ast.kind ~= "list" then
    return tostring(ast.value)
  end

  local xs = {}
  for i, node in pairs(ast.value) do
    xs[#xs + 1] = pr_str(node)
  end
  return string.format('(%s)', table.concat(xs, ' '))
end

return {
    pr_str = pr_str,
}
