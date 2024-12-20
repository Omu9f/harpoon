local M = {}

-- Table to store marks (supports up to 4 marks)
local marks = {}

-- Function to add a mark at a specific index
M.add_mark = function(index)
  local buf_name = vim.api.nvim_buf_get_name(0) -- Get the current buffer name
  if buf_name == "" then
    vim.notify("Cannot mark unnamed buffer", vim.log.levels.WARN)
    return
  end
  marks[index] = buf_name -- Store the buffer name in the marks table
  vim.notify("Mark " .. index .. " set to: " .. buf_name)
end

-- Function to navigate to a specific mark
M.goto_mark = function(index)
  local target = marks[index]  -- Retrieve the mark at the given index
  if target then
    vim.cmd("edit " .. target) -- Open the marked file
    vim.notify("Navigated to mark " .. index .. ": " .. target)
  else
    vim.notify("No mark set for index " .. index, vim.log.levels.WARN)
  end
end

-- Function to remove a mark at a specific index
M.remove_mark = function(index)
  if marks[index] then
    vim.notify("Mark " .. index .. " removed: " .. marks[index])
    marks[index] = nil -- Clear the mark
  else
    vim.notify("No mark set for index " .. index, vim.log.levels.WARN)
  end
end

-- Setup function to define keybindings
M.setup = function()
  -- Keymap options
  local keymap_opts = { noremap = true, silent = true }

  -- Add marks with <leader>+<ctrl>+h/t/n/s for marks 1-4
  vim.keymap.set("n", "<leader><C-h>", function() M.add_mark(1) end, keymap_opts)
  vim.keymap.set("n", "<leader><C-t>", function() M.add_mark(2) end, keymap_opts)
  vim.keymap.set("n", "<leader><C-n>", function() M.add_mark(3) end, keymap_opts)
  vim.keymap.set("n", "<leader><C-s>", function() M.add_mark(4) end, keymap_opts)

  -- Navigate to marks with <ctrl>+h/t/n/s for marks 1-4
  vim.keymap.set("n", "<C-h>", function() M.goto_mark(1) end, keymap_opts)
  vim.keymap.set("n", "<C-t>", function() M.goto_mark(2) end, keymap_opts)
  vim.keymap.set("n", "<C-n>", function() M.goto_mark(3) end, keymap_opts)
  vim.keymap.set("n", "<C-s>", function() M.goto_mark(4) end, keymap_opts)

  -- Remove marks with <leader>+<ctrl>+r for marks 1-4
  vim.keymap.set("n", "<leader><C-r>", function()
    local index = vim.fn.input("Remove mark (1-4): ")
    index = tonumber(index)
    if index and index >= 1 and index <= 4 then
      M.remove_mark(index)
    else
      vim.notify("Invalid mark index", vim.log.levels.ERROR)
    end
  end, keymap_opts)
end

return M
