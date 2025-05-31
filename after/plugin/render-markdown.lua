local util = require('theprimeagen.utils');

local stat = util.safe_require("render-markdown");

if not stat then
	return nil;
end

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
		-- Pre configured settings largely for setting table border easier --  heavy:  use thicker border characters --  double: use double line border characters --  round:  use round border corners
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
	code = {
		-- Turn on / off code block & inline code rendering.
		enabled = false,
		-- Additional modes to render code blocks.
		render_modes = false,
		-- Turn on / off any sign column related rendering.
		sign = true,
		-- Determines how code blocks & inline code are rendered.
		-- | none     | disables all rendering                                                    |
		-- | normal   | highlight group to code blocks & inline code, adds padding to code blocks |
		-- | language | language icon to sign column if enabled and icon + name above code blocks |
		-- | full     | normal + language                                                         |
		style = 'full',
		-- Determines where language icon is rendered.
		-- | right | right side of code block |
		-- | left  | left side of code block  |
		position = 'left',
		-- Amount of padding to add around the language.
		-- If a float < 1 is provided it is treated as a percentage of available window space.
		language_pad = 0,
		-- Whether to include the language icon above code blocks.
		language_icon = true,
		-- Whether to include the language name above code blocks.
		language_name = true,
		-- A list of language names for which background highlighting will be disabled.
		-- Likely because that language has background highlights itself.
		-- Use a boolean to make behavior apply to all languages.
		-- Borders above & below blocks will continue to be rendered.
		disable_background = { 'diff' },
		-- Width of the code block background.
		-- | block | width of the code block  |
		-- | full  | full width of the window |
		width = 'full',
		-- Amount of margin to add to the left of code blocks.
		-- If a float < 1 is provided it is treated as a percentage of available window space.
		-- Margin available space is computed after accounting for padding.
		left_margin = 0,
		-- Amount of padding to add to the left of code blocks.
		-- If a float < 1 is provided it is treated as a percentage of available window space.
		left_pad = 0,
		-- Amount of padding to add to the right of code blocks when width is 'block'.
		-- If a float < 1 is provided it is treated as a percentage of available window space.
		right_pad = 0,
		-- Minimum width to use for code blocks when width is 'block'.
		min_width = 0,
		-- Determines how the top / bottom of code block are rendered.
		-- | none  | do not render a border                               |
		-- | thick | use the same highlight as the code body              |
		-- | thin  | when lines are empty overlay the above & below icons |
		-- | hide  | conceal lines unless language name or icon is added  |
		border = 'hide',
		-- Used above code blocks for thin border.
		above = '▄',
		-- Used below code blocks for thin border.
		below = '▀',
		-- Icon to add to the left of inline code.
		inline_left = '',
		-- Icon to add to the right of inline code.
		inline_right = '',
		-- Padding to add to the left & right of inline code.
		inline_pad = 0,
		-- Highlight for code blocks.
		highlight = 'RenderMarkdownCode',
		-- Highlight for language, overrides icon provider value.
		highlight_language = nil,
		-- Highlight for border, use false to add no highlight.
		highlight_border = 'RenderMarkdownCodeBorder',
		-- Highlight for language, used if icon provider does not have a value.
		highlight_fallback = 'RenderMarkdownCodeFallback',
		-- Highlight for inline code.
		highlight_inline = 'RenderMarkdownCodeInline',
	},
})
