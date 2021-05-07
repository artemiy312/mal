
function pr_str(ast)
  if ast == nil then
    return ""
  end

  if ast.kind == "list" then
    local xs = {}
    for i, node in pairs(ast.value) do
        xs[#xs + 1] = pr_str(node)
    end
    return string.format('(%s)', table.concat(xs, ' '))
  end

  if ast.kind == "string" then
    return string.format('"%s"', ast.value)
  end

  return tostring(ast.value)
end

return {
    pr_str = pr_str,
}
