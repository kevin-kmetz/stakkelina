local _tl_compat; if (tonumber((_VERSION or ''):match('[%d.]*$')) or 0) < 5.3 then local p, m = pcall(require, 'compat53.module'); if p then _tl_compat = m end end; local assert = _tl_compat and _tl_compat.assert or assert; local io = _tl_compat and _tl_compat.io or io; local pcall = _tl_compat and _tl_compat.pcall or pcall; local string = _tl_compat and _tl_compat.string or string; require('Lexer')

local test_run
local test_peekLeadingChar
local test_stillHasChars
local test_isQuotationMark
local test_isApostrophe
local test_isPrintable
local test_isDelimiter
local test_buildCandidateFromQuotationString
local test_buildCandidateFromApostropheString
local test_buildCandidate

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


   test_buildCandidate()

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

return test_run()