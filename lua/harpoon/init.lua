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

	-- Check if the buffer is already assigned to another mark
	local current_index
	for i, name in pairs(marks) do
		if name == buf_name then
			current_index = i
			break
		end
	end

	if current_index then
		if current_index == index then
			-- No action if the buffer is already at the target mark
			vim.notify("Buffer is already assigned to mark " .. index, vim.log.levels.INFO)
			return
		end
		-- Swap marks if the buffer is already assigned
		marks[current_index] = marks[index]
		marks[index] = buf_name
		vim.notify("Swapped marks: " .. current_index .. " <-> " .. index)
	else
		-- Simply assign the buffer to the new mark if no swap is needed
		marks[index] = buf_name
		vim.notify("Mark " .. index .. " set to: " .. buf_name)
	end
end

-- Function to navigate to a specific mark
M.goto_mark = function(index)
	local target = marks[index] -- Retrieve the mark at the given index
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
	vim.keymap.set("n", "<leader><C-j>", function()
		M.add_mark(1)
	end, keymap_opts)
	vim.keymap.set("n", "<leader><C-k>", function()
		M.add_mark(2)
	end, keymap_opts)
	vim.keymap.set("n", "<leader><C-l>", function()
		M.add_mark(3)
	end, keymap_opts)
	vim.keymap.set("n", "<leader><C-;>", function()
		M.add_mark(4)
	end, keymap_opts)

	-- Navigate to marks with <ctrl>+h/t/n/s for marks 1-4
	vim.keymap.set("n", "<C-j>", function()
		M.goto_mark(1)
	end, keymap_opts)
	vim.keymap.set("n", "<C-k>", function()
		M.goto_mark(2)
	end, keymap_opts)
	vim.keymap.set("n", "<C-l>", function()
		M.goto_mark(3)
	end, keymap_opts)
	vim.keymap.set("n", "<C-;>", function()
		M.goto_mark(4)
	end, keymap_opts)

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
