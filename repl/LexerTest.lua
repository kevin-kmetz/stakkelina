local _tl_compat; if (tonumber((_VERSION or ''):match('[%d.]*$')) or 0) < 5.3 then local p, m = pcall(require, 'compat53.module'); if p then _tl_compat = m end end; local assert = _tl_compat and _tl_compat.assert or assert; local io = _tl_compat and _tl_compat.io or io; require('Lexer')

local test_run
local test_peekLeadingChar

test_run = function()
   print('Enabling testing: ' .. tostring(___enable_testing_Lexer()))
   print('Starting test of Lexer...')

   local failureCount = 0
   failureCount = failureCount + test_peekLeadingChar()
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

return test_run()
