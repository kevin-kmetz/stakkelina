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

end--]]

local peekLeadingChar:          function (chars: string): string|nil
local stillHasChars:            function (chars: string): boolean, string|nil
local isQuotationMark:          function (chars: string): boolean 
local isApostrophe:             function (chars: string): boolean
local isPrintable:              function (chars: string): boolean
local isDelimiter:              function (chars: string): boolean
local isWhitespace:             function (chars: string): boolean
local isIllegal:                function (chars: string): boolean
local buildCandidate:           function (chars: string): string, string 
local buildCandidateFromString: function (chars: string, delimiter: string): string, string
local removeLeadingWhitespace:  function (chars: string): string
local segmentIntoCandidates:    function (chars: string): {string}

--local segmentIntoCandidate = function (chars:string): string string
segmentIntoCandidates = function (chars: string): {string}

    local leadChar: string
    if not (#leadChar > 0) then error('Malformed candidate stream - no characters.') end
    local candidates: {string} = {}
    local candidate: string
    local stillChars: boolean

    chars = removeLeadingWhitespace(chars)
    stillChars, leadChar = stillHasChars(chars)

    repeat
        if not stillChars then break end

        if isQuotationMark(leadChar) then
            candidate, chars = buildCandidateFromString(chars, '"')
        elseif isApostrophe(leadChar) then
            candidate, chars = buildCandidateFromString(chars, "'")
        elseif isPrintable(leadChar) then
            candidate, chars = buildCandidate(chars)
        else
            error('Malformed candidate stream - either illegal character or exceptional condition.')
        end

        table.insert(candidates, candidate)
        chars = removeLeadingWhitespace(chars)
        stillChars, leadChar = stillHasChars(chars)
    until not stillChars

    return candidates

end

peekLeadingChar = function (chars: string|nil): string|nil
    local leadingChar: string|nil = nil
    if chars ~= nil and chars is string and #chars > 0 then leadingChar = chars:sub(1, 1) end
    return leadingChar
end

stillHasChars = function (chars: string|nil): boolean, string|nil
    local leadingChar = peekLeadingChar(chars)
    return leadingChar ~= nil and #leadingChar == 1, leadingChar
end

isQuotationMark = function (char: string): boolean
    return char == '"' and true or false 
end

isApostrophe = function (char: string): boolean
    return char == "'" and true or false
end

isPrintable = function (char: string): boolean
    local asciiValue = string.byte(char)
    return asciiValue >= 33 and asciiValue <= 126
end

-- The lexeme delimiters and legal whitespace happen to coincide exactly.
-- They are thus synonyms, as show below, where isWhiteSpace aliases isDelimiter.
isDelimiter = function (char: string): boolean
    return #char == 1 and (char == ' ' or char == '\t' or char == '\n')
end

isWhitespace = isDelimiter

isIllegal = function (char: string): boolean
    -- All nonprintable except space, newline, tab are illegal.
    -- 33 is start of printable, 127 is ASCII for delete, 128 and above is Extend ASCII, which isn't desired.
    if (string.byte(char) < 33 and not (char == ' ' or char == '\n' or char == '\t')) or char.byte(char) >= 127 then return true end
    return false
end

removeLeadingWhitespace = function (chars: string): string
    -- removeLeadingWhitespace assumes there is a string passed in correctly, even if it is empty.
    -- Thus a length, even if zero, is guaranteed.
    while #chars > 0 and isWhitespace(peekLeadingChar(chars)) do chars = chars:sub(2) end
    return chars
end

buildCandidate = function (chars: string): string, string

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

buildCandidateFromString = function (chars: string, delimiter: string): string, string

    -- First character is guaranteed to be valid, so it can be added without concern.
    local candidate = '' .. delimiter
    chars = chars:sub(2)
    local isStringDelimiter: function(string): boolean

    if isQuotationMark(delimiter) then
        isStringDelimiter = isQuotationMark
    elseif isApostrophe(delimiter) then
        isStringDelimiter = isApostrophe
    else
        error('Malformed token encountered - an invalid delimiter.')
    end

    local endedWithStringDelimiter, stillChars, ignoreNextChar = false, false, false
    local currentChar: string

    if #chars < 1 then error('Malformed token encountered - single quote token.') end

    repeat
        stillChars, currentChar = stillHasChars(chars)
        if not stillChars then error ('Malformed token encountered -  unclosed string token.') end
        if not (isPrintable(currentChar) or isDelimiter(currentChar)) then error('Malformed token encountered - invalid character.') end

        candidate = candidate .. currentChar
        chars = chars:sub(2)

        if isStringDelimiter(currentChar) and not ignoreNextChar then
            endedWithStringDelimiter = true
            break
        end

        if currentChar == '\\' and not ignoreNextChar then
            ignoreNextChar = true
        else ignoreNextChar = false end
    until not stillChars

    if not endedWithStringDelimiter then error('Malformed token encountered - unclosed string.') end

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
    global _t_isWhitespace                       = isWhitespace
    global _t_isIllegal                          = isIllegal
    global _t_buildCandidate                     = buildCandidate
    global _t_buildCandidateFromString           = buildCandidateFromString
    global _t_removeLeadingWhitespace            = removeLeadingWhitespace
    return true
end