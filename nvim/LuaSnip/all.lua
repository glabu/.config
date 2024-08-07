local helpers = require("personal/luasnip-helper-funcs")
local get_date = helpers.get_ISO_8601_date
local get_visual = helpers.get_visual

-- Un OR lógico de `line_begin` y de regTrig '[^%a]trig'
function line_begin_or_non_letter(line_to_cursor, matched_trigger)
	local line_begin = line_to_cursor:sub(1, -(#matched_trigger + 1)):match("^%s*$")
	local non_letter = line_to_cursor:sub(-(#matched_trigger + 1), -(#matched_trigger + 1)):match('[ :`=%{%(%["]')
	return line_begin or non_letter
end

return {
	-- Pareja de paréntesis
	s({ trig = "(", wordTrig = false, snippetType = "autosnippet" }, {
		t("("),
		d(1, get_visual),
		t(")"),
	}),
	-- Pareja de llaves
	s({ trig = "{", wordTrig = false, snippetType = "autosnippet" }, {
		t("{"),
		d(1, get_visual),
		t("}"),
	}),
	-- Pareja de corchetes
	s({ trig = "[", wordTrig = false, snippetType = "autosnippet" }, {
		t("["),
		d(1, get_visual),
		t("]"),
	}),
	-- Pareja de comillas invertidas
	s({ trig = "sd", snippetType = "autosnippet" }, {
		f(function(_, snip)
			return snip.captures[1]
		end),
		t("`"),
		d(1, get_visual),
		t("`"),
	}),
	-- Pareja de comillas dobles
	s(
		{ trig = '"', wordTrig = false, snippetType = "autosnippet", priority = 2000 },
		fmta('"<>"', {
			d(1, get_visual),
		}),
		{ condition = line_begin_or_non_letter }
	),
	-- Pareja de comillas simples
	s(
		{ trig = "'", wordTrig = false, snippetType = "autosnippet", priority = 2000 },
		fmta("'<>'", {
			d(1, get_visual),
		}),
		{ condition = line_begin_or_non_letter }
	),
	-- Guión largo
	s(
		{ trig = "---", wordTrig = false, snippetType = "autosnippet", priority = 2000 },
		fmta("---<>---", {
			d(1, get_visual),
		}),
		{ condition = line_begin_or_non_letter }
	),
	-- La fecha de hoy en formato YYYY-MM-DD (ISO 8601)
	s(
		{ trig = "iso" },
		{ f(get_date) }
		-- {f(get_ISO_8601_date)}
	),
	-- Llaves
	s(
		{ trig = "df", snippetType = "autosnippet" },
		fmta(
			[[
        {
          <>
        }
        ]],
			{ d(1, get_visual) }
		)
	),
	-- Corchetes
	s(
		{ trig = "dg", snippetType = "autosnippet" },
		fmta(
			[[
        [
          <>
        ]
        ]],
			{ d(1, get_visual) }
		)
	),
	-- Lorem ipsum
	s(
		{ trig = "lipsum" },
		fmta(
			[[
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        ]],
			{}
		)
	),
}
