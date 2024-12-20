local _tl_compat; if (tonumber((_VERSION or ''):match('[%d.]*$')) or 0) < 5.3 then local p, m = pcall(require, 'compat53.module'); if p then _tl_compat = m end end; local assert = _tl_compat and _tl_compat.assert or assert; local io = _tl_compat and _tl_compat.io or io; local pcall = _tl_compat and _tl_compat.pcall or pcall; local string = _tl_compat and _tl_compat.string or string; require('Lexer')

local test_run
local test_peekLeadingChar
local test_stillHasChars
local test_isQuotationMark
local test_isApostrophe
local test_isPrintable
local test_isDelimiter
local test_isIllegal
local test_buildCandidate
local test_buildCandidateFromQuotationString
local test_buildCandidateFromApostropheString
local test_removeLeadingWhitespace
local test_segmentIntoCandidates

test_run = function()

   print('Enabling testing: ' .. tostring(___enable_testing_Lexer()))
   print('Starting test of Lexer...')
   local failureCount = 0

   test_peekLeadingChar()
   test_stillHasChars()
   test_isQuotationMark()
   test_isApostrophe()
   test_isPrintable()
   test_isDelimiter()
   test_isIllegal()
   test_buildCandidate()
   test_buildCandidateFromQuotationString()
   test_buildCandidateFromApostropheString()
   test_removeLeadingWhitespace()
   test_segmentIntoCandidates()

   print('Test of Lexer complete.')
   return failureCount

end

test_peekLeadingChar = function()

   io.write('Now running test_peekLeadingChar...')
   local t = _t_peekLeadingChar

   local s_1 = 'A regular string'
   local s_2 = 'X'
   local s_3 = ''
   local s_4 = nil
   local s_5 = 'Four score and seven years ago'

   assert(t(s_1) == 'A')
   assert(#t(s_1) == 1)

   assert(t(s_2) == 'X')
   assert(#t(s_2) == 1)

   assert(t(s_3) == nil)
   assert(t(s_4) == nil)
   assert(t(s_5) == 'F')
   assert(#t(s_5) == 1)

   io.write(' passed!\n')
   return 0

end

test_stillHasChars = function()

   io.write('Now running test_stillHasChars...')
   local t = _t_stillHasChars

   local s_1 = 'A regular string'
   local r_11, r_12 = t(s_1)
   local s_2 = 'X'
   local r_21, r_22 = t(s_2)
   local s_3 = ''
   local r_31, r_32 = t(s_3)
   local s_4 = nil
   local r_41, r_42 = t(s_4)
   local s_5 = 'Four score and seven years ago'
   local r_51, r_52 = t(s_5)

   assert(r_11 == true)
   assert(r_12 == 'A')

   assert(r_21 == true)
   assert(r_22 == 'X')

   assert(r_31 == false)
   assert(r_32 == nil)

   assert(r_41 == false)
   assert(r_42 == nil)

   assert(r_51 == true)
   assert(r_52 == 'F')

   io.write(' passed!\n')
   return 0

end

test_isQuotationMark = function()

   io.write('Now running test_isQuotationMark...')
   local t = _t_isQuotationMark

   assert(t('"') == true)
   assert(t("'") == false)
   assert(t(" ") == false)
   assert(t('\'') == false)
   assert(t('x') == false)
   assert(t('"') == true)

   io.write(' passed!\n')

end

test_isApostrophe = function()

   io.write('Now running test_isApostrophe...')
   local t = _t_isApostrophe

   assert(t('"') == false)
   assert(t("'") == true)
   assert(t(" ") == false)
   assert(t('\'') == true)
   assert(t('x') == false)
   assert(t('`') == false)

   io.write(' passed!\n')

end

test_isPrintable = function()

   io.write('Now running test_isPrintable...')
   local t = _t_isPrintable

   assert(t('P') == true)
   assert(t("q") == true)
   assert(t('\'') == true)
   assert(t('8') == true)
   assert(t('_') == true)
   assert(t(';') == true)

   assert(t(" ") == false)
   assert(t('\t') == false)
   assert(t('\n') == false)
   assert(t(string.char(5)) == false)
   assert(t(string.char(255)) == false)
   assert(t(string.char(127)) == false)
   assert(t(string.char(5)) == false)

   io.write(' passed!\n')

end

test_isDelimiter = function()

   io.write('Now running test_isDelimiter...')
   local t = _t_isDelimiter
   local s = _t_isWhitespace

   assert(t(' ') == true)
   assert(t("\n") == true)
   assert(t('\t') == true)

   assert(t("g") == false)
   assert(t('5') == false)
   assert(t('') == false)
   assert(t(string.char(5)) == false)
   assert(t(string.char(255)) == false)
   assert(t(string.char(127)) == false)
   assert(t(string.char(5)) == false)

   assert(s(' ') == true)
   assert(s("\n") == true)
   assert(s('\t') == true)

   assert(s("g") == false)
   assert(s('5') == false)
   assert(s('') == false)
   assert(s(string.char(5)) == false)
   assert(s(string.char(255)) == false)
   assert(s(string.char(127)) == false)
   assert(s(string.char(5)) == false)

   io.write(' passed!\n')

end

test_isIllegal = function()

   io.write('Now running test_isIllegal...')
   local t = _t_isIllegal

   assert(t(string.char(22)) == true)
   assert(t(string.char(6)) == true)
   assert(t(string.char(127)) == true)
   assert(t(string.char(180)) == true)
   assert(t(string.char(255)) == true)

   assert(t("g") == false)
   assert(t('5') == false)
   assert(t('X') == false)
   assert(t('\n') == false)
   assert(t('\t') == false)
   assert(t(' ') == false)
   assert(t('}') == false)

   io.write(' passed!\n')

end

test_buildCandidate = function()

   io.write('Now running test_buildCandidate...')
   local t = _t_buildCandidate

   local r_11, r_12 = t('thisisatoken thisshouldnotbe')
   local r_21, r_22 = t('alpha5 beta gamma delta')
   local r_31, r_32 = t('__Snowfall beauford')

   assert(r_11 == 'thisisatoken')
   assert(r_12 == 'thisshouldnotbe')
   assert(r_21 == 'alpha5')
   assert(r_22 == 'beta gamma delta')
   assert(r_31 == '__Snowfall')
   assert(r_32 == 'beauford')

   local r_41, r_42 = t('iknowthisisfine x')
   local r_51, r_52 = t('howaboutthisone\tz')
   local r_61, r_62 = t('arooga\nf')
   local r_71, r_72 = t('nootnoot ')

   assert(r_41 == 'iknowthisisfine')
   assert(r_42 == 'x')
   assert(r_51 == 'howaboutthisone')
   assert(r_52 == 'z')
   assert(r_61 == 'arooga')
   assert(r_62 == 'f')
   assert(r_71 == 'nootnoot')
   assert(r_72 == '')

   assert(pcall(t, ' noleadingspaces') == false)
   assert(pcall(t, string.char(8) .. 'also no leading junk') == false)
   assert(pcall(t, "\tThat would include tables") == false)

   assert(pcall(t, "alsothisshouldn't as well") == false)
   assert(pcall(t, '"quoted shouldnt exist"') == false)
   assert(pcall(t, 'Greatgoogly"moogly') == false)

   io.write(' passed!\n')

end

test_buildCandidateFromQuotationString = function()

   io.write('Now running test_buildCandidateFromQuotationString...')
   local t = function(chars)
      return _t_buildCandidateFromString(chars, '"')
   end

   local r_11, r_12 = t('"Example 1 here" and some more stuff')
   local r_21, r_22 = t('"        this one too" Did it work?')
   local r_31, r_32 = t('""')

   assert(r_11 == '"Example 1 here"')
   assert(r_12 == 'and some more stuff')
   assert(r_21 == '"        this one too"')
   assert(r_22 == 'Did it work?')
   assert(r_31 == '""')
   assert(r_32 == '')

   local r_41, r_42 = t('"This one has \\" in it" and should have worked')
   local r_51, r_52 = t('"This one has a \' as well" isnt that weird')
   local r_61, r_62 = t('"\'\'\'\'\'\'\'" Thats allotta apostrophes')
   local r_71, r_72 = t('"  multiple \\"\\" quotes\\"in it" are they showing?')

   assert(r_41 == '"This one has \\" in it"')
   assert(r_42 == 'and should have worked')
   assert(r_51 == '"This one has a \' as well"')
   assert(r_52 == 'isnt that weird')
   assert(r_61 == '"\'\'\'\'\'\'\'"')
   assert(r_62 == 'Thats allotta apostrophes')
   assert(r_71 == '"  multiple \\"\\" quotes\\"in it"')
   assert(r_72 == 'are they showing?')

   local r_81, r_82 = t('"\\"Beginning escape" ?????')
   local r_91, r_92 = t('"An ending escape\\"" It should show.')

   assert(r_81 == '"\\"Beginning escape"')
   assert(r_82 == '?????')
   assert(r_91 == '"An ending escape\\""')
   assert(r_92 == 'It should show.')

   local r_101, r_102 = t('"Escaping \\ irrelevant characters" nyahaha')
   local r_111, r_112 = t('"An irrelevant at the end \\;" bloop bloop')
   local r_121, r_122 = t('"An unterminated escape at end\\\\" anyway, my dude')

   assert(r_101 == '"Escaping \\ irrelevant characters"')
   assert(r_102 == 'nyahaha')
   assert(r_111 == '"An irrelevant at the end \\;"')
   assert(r_112 == 'bloop bloop')
   assert(r_121 == '"An unterminated escape at end\\\\"')
   assert(r_122 == 'anyway, my dude')

   assert(pcall(t, 'needs to start with a quotation mark') == false)
   assert(pcall(t, '"needs to end with one too') == false)
   assert(pcall(t, '"And do so ignoring a tail escape\\"') == false)

   assert(pcall(t, '"Bad chars' .. string.char(17) .. ' still should flag"') == false)

   local r_131, r_132 = t('"Finally, how about one ending on a quotation mark?"')

   assert(r_131 == '"Finally, how about one ending on a quotation mark?"')
   assert(r_132 == '')

   io.write(' passed!\n')

end

test_buildCandidateFromApostropheString = function()

   io.write('Now running test_buildCandidateFromApostropheString...')
   local t = function(chars)
      return _t_buildCandidateFromString(chars, "'")
   end

   local r_11, r_12 = t("'Example 1 here' and some more stuff")
   local r_21, r_22 = t("'        this one too' Did it work?")
   local r_31, r_32 = t("''")

   assert(r_11 == "'Example 1 here'")
   assert(r_12 == "and some more stuff")
   assert(r_21 == "'        this one too'")
   assert(r_22 == "Did it work?")
   assert(r_31 == "''")
   assert(r_32 == "")

   local r_41, r_42 = t("'This one has \\' in it' and should have worked")
   local r_51, r_52 = t("'This one has a \" as well' isnt that weird")
   local r_61, r_62 = t("'\"\"\"\"\"\"\"' Thats allotta apostrophes")
   local r_71, r_72 = t("'  multiple \\'\\' quotes\\'in it' are they showing?")

   assert(r_41 == "'This one has \\' in it'")
   assert(r_42 == "and should have worked")
   assert(r_51 == "'This one has a \" as well'")
   assert(r_52 == "isnt that weird")
   assert(r_61 == "'\"\"\"\"\"\"\"'")
   assert(r_62 == "Thats allotta apostrophes")
   assert(r_71 == "'  multiple \\'\\' quotes\\'in it'")
   assert(r_72 == "are they showing?")

   local r_81, r_82 = t("'\\'Beginning escape' ?????")
   local r_91, r_92 = t("'An ending escape\\'' It should show.")

   assert(r_81 == "'\\'Beginning escape'")
   assert(r_82 == "?????")
   assert(r_91 == "'An ending escape\\''")
   assert(r_92 == "It should show.")

   local r_101, r_102 = t("'Escaping \\ irrelevant characters' nyahaha")
   local r_111, r_112 = t("'An irrelevant at the end \\;' bloop bloop")
   local r_121, r_122 = t("'An unterminated escape at end\\\\' anyway, my dude")

   assert(r_101 == "'Escaping \\ irrelevant characters'")
   assert(r_102 == "nyahaha")
   assert(r_111 == "'An irrelevant at the end \\;'")
   assert(r_112 == "bloop bloop")
   assert(r_121 == "'An unterminated escape at end\\\\'")
   assert(r_122 == "anyway, my dude")

   assert(pcall(t, "needs to start with a quotation mark") == false)
   assert(pcall(t, "'needs to end with one too") == false)
   assert(pcall(t, "'And do so ignoring a tail escape\\'") == false)

   assert(pcall(t, "'Bad chars" .. string.char(17) .. " still should flag'") == false)

   local r_131, r_132 = t("'Finally, how about one ending on a quotation mark?'")

   assert(r_131 == "'Finally, how about one ending on a quotation mark?'")
   assert(r_132 == "")

   io.write(' passed!\n')

end

test_removeLeadingWhitespace = function()
   io.write('Now running test_removeLeadingWhitespace...')
   local t = _t_removeLeadingWhitespace

   assert(t('      Gobble gobble gobble') == 'Gobble gobble gobble')
   assert(t('\n   like zoinks Scoob') == 'like zoinks Scoob')
   assert(t('\tElephant') == 'Elephant')
   assert(t('          ') == '')

   assert(t('Shouldn\'t do anything') == 'Shouldn\'t do anything')
   assert(t('') == '')
   assert(t(' ') == '')
   assert(t('sunny day') == 'sunny day')

   io.write(' passed!\n')
   return 0
end

test_segmentIntoCandidates = function()
   io.write('Now running test_segmentIntoCandidates...')

   local t = function(charStream, properOutput)
      local candidates = _t_segmentIntoCandidates(charStream)
      assert(#candidates == #properOutput)

      local function tablesAreEqual(tblA, tblB)
         for i = 1, #tblA do
            assert(tblA[i] == tblB[i])
         end
         return true
      end

      assert(tablesAreEqual(candidates, properOutput))
   end

   local s_1 = 'This is a sample string of tokens'
   local s_2 = '      How about this one?'
   local s_3 = '     And    this      one?'

   local r_1 = { 'This', 'is', 'a', 'sample', 'string', 'of', 'tokens' }
   local r_2 = { 'How', 'about', 'this', 'one?' }
   local r_3 = { 'And', 'this', 'one?' }

   t(s_1, r_1)
   t(s_2, r_2)
   t(s_3, r_3)

   local s_4 = '\tNow we\t   have tabs'
   local s_5 = '\nWhat\nabout\nnewlines???'
   local s_6 = 'trailing whitespace, is it an issue?     '
   local s_7 = '\t\t\t\n\n   \nLets really jank this up'

   local r_4 = { 'Now', 'we', 'have', 'tabs' }
   local r_5 = { 'What', 'about', 'newlines???' }
   local r_6 = { 'trailing', 'whitespace,', 'is', 'it', 'an', 'issue?' }
   local r_7 = { 'Lets', 'really', 'jank', 'this', 'up' }

   t(s_4, r_4)
   t(s_5, r_5)
   t(s_6, r_6)
   t(s_7, r_7)

   local s_8 = 'What about "a quoted string" hmmm?'
   local s_9 = "an 'apostrophe string' should also work"
   local s_10 = 'Lets "mix them" up now \'just like this\' mwahaha'

   local r_8 = { 'What', 'about', '"a quoted string"', 'hmmm?' }
   local r_9 = { 'an', "'apostrophe string'", 'should', 'also', 'work' }
   local r_10 = { 'Lets', '"mix them"', 'up', 'now', '\'just like this\'', 'mwahaha' }

   t(s_8, r_8)
   t(s_9, r_9)
   t(s_10, r_10)

   local s_11 = '"Starting with a quote" and not ending on one'
   local s_12 = 'Not starting with one but "ending on a quote"'

   local r_11 = { '"Starting with a quote"', 'and', 'not', 'ending', 'on', 'one' }
   local r_12 = { 'Not', 'starting', 'with', 'one', 'but', '"ending on a quote"' }

   t(s_11, r_11)
   t(s_12, r_12)

   local s_13 = 'Lets see what an ' .. string.char(22) .. ' does here'
   local s_14 = 'How about an un"finished quote'
   local s_15 = 'What about if the quote is in last position"'
   local s_16 = "What if an apo'strophe is unclosed?"
   local s_17 = "Let's try 'two of' apo'strophed"

   assert(pcall(_t_segmentIntoCandidates, s_13) == false)
   assert(pcall(_t_segmentIntoCandidates, s_14) == false)
   assert(pcall(_t_segmentIntoCandidates, s_15) == false)
   assert(pcall(_t_segmentIntoCandidates, s_16) == false)
   assert(pcall(_t_segmentIntoCandidates, s_17) == false)

   local s_18 = 'Lets try one with an "escaped\\ space" now'
   local s_19 = 'And an escape "new\\\nline" huh huh?'
   local s_20 = 'And an "esca\\\tped" tab wow wow'

   local r_18 = { 'Lets', 'try', 'one', 'with', 'an', '"escaped\\ space"', 'now' }
   local r_19 = { 'And', 'an', 'escape', '"new\\\nline"', 'huh', 'huh?' }
   local r_20 = { 'And', 'an', '"esca\\\tped"', 'tab', 'wow', 'wow' }

   t(s_18, r_18)
   t(s_19, r_19)
   t(s_20, r_20)

   io.write(' passed!\n')
   return 0
end

return test_run()
