local _tl_compat; if (tonumber((_VERSION or ''):match('[%d.]*$')) or 0) < 5.3 then local p, m = pcall(require, 'compat53.module'); if p then _tl_compat = m end end; local assert = _tl_compat and _tl_compat.assert or assert; local io = _tl_compat and _tl_compat.io or io; require('Lexer')

local test_run
local test_peekLeadingChar
local test_stillHasChars





test_run = function()
   print('Enabling testing: ' .. tostring(___enable_testing_Lexer()))
   print('Starting test of Lexer...')

   local failureCount = 0
   failureCount = failureCount + test_peekLeadingChar()
   test_stillHasChars()

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

return test_run()
