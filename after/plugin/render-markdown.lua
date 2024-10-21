

require('render-markdown').setup({
	bullet = {
		-- Turn on / off list bullet rendering
		enabled = true,
		-- Replaces '-'|'+'|'*' of 'list_item'
		-- How deeply nested the list is determines the 'level'
		-- The 'level' is used to index into the list using a cycle
		-- If the item is a 'checkbox' a conceal is used to hide the bullet instead
		icons = { '●', '○', '◆', '◇' },
		-- Padding to add to the left of bullet point
		left_pad = 0,
		-- Padding to add to the right of bullet point
		right_pad = 0,
		-- Highlight for the bullet icon
		highlight = 'RenderMarkdownBullet',
	},
	pipe_table = {
		-- Turn on / off pipe table rendering
		enabled = true,
		-- Pre configured settings largely for setting table border easier
		--  heavy:  use thicker border characters
		--  double: use double line border characters
		--  round:  use round border corners
		--  none:   does nothing
		preset = 'none',
		-- Determines how the table as a whole is rendered:
		--  none:   disables all rendering
		--  normal: applies the 'cell' style rendering to each row of the table
		--  full:   normal + a top & bottom line that fill out the table when lengths match
		style = 'full',
		-- Determines how individual cells of a table are rendered:
		--  overlay: writes completely over the table, removing conceal behavior and highlights
		--  raw:     replaces only the '|' characters in each row, leaving the cells unmodified
		--  padded:  raw + cells are padded to maximum visual width for each column
		--  trimmed: padded except empty space is subtracted from visual width calculation
		cell = 'padded',
		-- Minimum column width to use for padded or trimmed cell
		min_width = 0,
		-- Characters used to replace table border
		-- Correspond to top(3), delimiter(3), bottom(3), vertical, & horizontal
		-- stylua: ignore
		border = {
			'┌', '┬', '┐',
			'├', '┼', '┤',
			'└', '┴', '┘',
			'│', '─',
		},
		-- Gets placed in delimiter row for each column, position is based on alignmnet
		alignment_indicator = '━',
		-- Highlight for table heading, delimiter, and the line above
		head = 'RenderMarkdownTableHead',
		-- Highlight for everything else, main table rows and the line below
		row = 'RenderMarkdownTableRow',
		-- Highlight for inline padding used to add back concealed space
		filler = 'RenderMarkdownTableFill',
	},
	paragraph = {
		-- Turn on / off paragraph rendering
		enabled = true,
		-- Amount of margin to add to the left of paragraphs
		-- If a floating point value < 1 is provided it is treated as a percentage of the available window space
		left_margin = 0,
		-- Minimum width to use for paragraphs
		min_width = 0,
	},
})
