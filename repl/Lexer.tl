-- Lexical analysis process:
--
--      (character stream) --> Segmenter --> (candidate stream)
--      (candidate stream) --> Validator --> (lexeme stream)
--      (lexeme stream) --> Tokenizer --> (token stream)
--
--      --> Segmenter --> Lexical Validator --> Tokenizer
--           (candidate [lexeme]) -> ([validated] lexeme) -> (token)

-- global type Candidate = string|nil
-- global type TokenType = string|nil

--[[global function lex(chars: string): string|nil

    chars = reduceUntilValid(chars)
    local candidate: string

    candidate, chars = buildCandidate(chars)

    return nil

end

local function buildCandidate(chars: string): string, string

    local first = peekLeadingChar(chars)
    local candidate: string

    if isQuotationMark(first) then
        candidate, chars = buildCandidateFromQuotationString(chars)
    elseif isApostrophe(first) then
        candidate, chars = buildCandidateFromApostropheString(chars)
    elseif isPrintableNonDelimiter(first) then
        candidate, chars = builCandidate(chars)
    else
        -- error!
    end

end--]]

local function peekLeadingChar(chars: string|nil): string|nil
    local leadingChar: string|nil = nil
    if chars ~= nil and chars is string and #chars > 0 then leadingChar = chars:sub(1, 1) end
    return leadingChar
end

local function stillHasChars(chars: string|nil): boolean, string|nil
    local leadingChar = peekLeadingChar(chars)
    return leadingChar ~= nil and #leadingChar == 1, leadingChar
end

local function isQuotationMark(char: string): boolean
    return char == '"' and true or false 
end

local function isApostrophe(char: string): boolean
    return char == "'" and true or false
end

local function isPrintable(char: string): boolean
    local asciiValue = string.byte(char)
    return asciiValue >= 33 and asciiValue <= 126
end

-- The lexeme delimiters and legal whitespace happen to coincide exactly.
local function isDelimiter(char: string): boolean
    return #char == 1 and (char == ' ' or char == '\t' or char == '\n')
end

local function buildCandidate(chars: string): string, string

    local candidate = ''
    local keepScanning, currentChar = stillHasChars(chars)
    if isQuotationMark(currentChar) or isApostrophe(currentChar) or not isPrintable(currentChar) then error('Malformed token passed in.') end

    while keepScanning do
        candidate = candidate .. currentChar
        chars = chars:sub(2)

        keepScanning, currentChar = stillHasChars(chars)
        if isQuotationMark(currentChar) or isApostrophe(currentChar) then error('Malformed token encountered - incorrectly placed apostrophe or quotation mark.') end

        if isDelimiter(currentChar) then
            chars = chars:sub(2)
            break
        end
    end

    return candidate, chars

end

local function buildCandidateFromQuotationString(chars: string): string, string

    -- This functions relies on the first character of the string being passed in to
    -- already have been accurately determined to a quotation mark, thus no need to check here.
    --
    local candidate = '"'
    chars = chars:sub(2)
    local endedWithQuotationMark = false
    local stillChars, ignoreNextChar = false, false
    local currentChar: string

    if #chars < 1 then error('Malform token encountered - single quote token.') end

    repeat
        stillChars, currentChar = stillHasChars(chars)
        if not stillChars then error ('Malformed token encountered -  unclosed string token.') end
        if not (isPrintable(currentChar) or isDelimiter(currentChar)) then error('Malformed token encountered - invalid character.') end

        candidate = candidate .. currentChar
        chars = chars:sub(2)

        if isQuotationMark(currentChar) and not ignoreNextChar then
            endedWithQuotationMark = true
            break
        end

        if currentChar == '\\' and not ignoreNextChar then
            ignoreNextChar = true
        else ignoreNextChar = false end

    until not stillChars

    if not endedWithQuotationMark then error('Malformed token encountered - unclosed string.') end

    stillChars, currentChar = stillHasChars(chars)

    if stillChars then
        if not isDelimiter(currentChar) then error('Malformed token encounter - trailing characters after string closed.') end
        chars = chars:sub(2)
    end

    return candidate, chars

end

local function buildCandidateFromApostropheString(chars: string): string, string

    -- This functions relies on the first character of the string being passed in to
    -- already have been accurately determined to an apostrophe mark, thus no need to check here.
    --
    local candidate = "'"
    chars = chars:sub(2)
    local endedWithApostrophe = false
    local stillChars, ignoreNextChar = false, false
    local currentChar: string

    if #chars < 1 then error('Malform token encountered - single apostrophe token.') end

    repeat
        stillChars, currentChar = stillHasChars(chars)
        if not stillChars then error ('Malformed token encountered -  unclosed string token.') end
        if not (isPrintable(currentChar) or isDelimiter(currentChar)) then error('Malformed token encountered - invalid character.') end

        candidate = candidate .. currentChar
        chars = chars:sub(2)

        if isApostrophe(currentChar) and not ignoreNextChar then
            endedWithApostrophe = true
            break
        end

        if currentChar == '\\' and not ignoreNextChar then
            ignoreNextChar = true
        else ignoreNextChar = false end

    until not stillChars

    if not endedWithApostrophe then error('Malformed token encountered - unclosed string.') end

    stillChars, currentChar = stillHasChars(chars)

    if stillChars then
        if not isDelimiter(currentChar) then error('Malformed token encounter - trailing characters after string closed.') end
        chars = chars:sub(2)
    end

    return candidate, chars

end

global function ___enable_testing_Lexer(): boolean
    global _t_peekLeadingChar                    = peekLeadingChar
    global _t_stillHasChars                      = stillHasChars
    global _t_isQuotationMark                    = isQuotationMark
    global _t_isApostrophe                       = isApostrophe
    global _t_isPrintable                        = isPrintable
    global _t_isDelimiter                        = isDelimiter
    global _t_buildCandidate                     = buildCandidate
    global _t_buildCandidateFromQuotationString  = buildCandidateFromQuotationString
    global _t_buildCandidateFromApostropheString = buildCandidateFromApostropheString
    return true
end