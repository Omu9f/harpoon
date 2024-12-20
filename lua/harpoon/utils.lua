local Utils = {}

Utils.is_marked = function(buf_name, marks)
  for _, mark in ipairs(marks) do
    if mark == buf_name then
      return true
    end
  end
  return false
end

return Utils
