require('Lexer')

local test_run: function(): integer
local test_peekLeadingChar: function():integer

test_run = function (): integer
    print('Enabling testing: ' .. tostring(___enable_testing_Lexer()))
    print('Starting test of Lexer...')

    local failureCount = 0
    failureCount = failureCount + test_peekLeadingChar()
    return failureCount
end

test_peekLeadingChar = function (): integer

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

-- function peekLeadingChar(chars: string|nil): string|nil
-- function stillHasChars(chars: string|nil): boolean, string|nil
-- function isQuotationMark(char: string): boolean
-- function isApostrophe(char: string): boolean
-- function isPrintable(char: string): boolean
-- function isDelimiter(char: string): boolean