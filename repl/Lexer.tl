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
        candidate, chars = buildQuoteString(chars)
    elseif isApostrophe(first) then
        candidate, chars = buildApostropheCandidate(chars)
    elseif isPrintableNonDelimiter(first) then
        candidate, chars = buildRegularCandidate(chars)
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

--[[local function buildQuoteString(char: string): string, string
end

local function buildQuoteString(char: string): string, string
end

local function buildRegularCandidate(chars: string): string, string
end--]]

global function ___enable_testing_Lexer(): boolean
    global _t_peekLeadingChar   = peekLeadingChar
    global _t_stillHasChars     = stillHasChars
    global _t_isQuotationMark   = isQuotationMark
    global _t_isApostrophe      = isApostrophe
    global _t_isPrintable       = isPrintable
    global _t_isDelimiter       = isDelimiter
    return true
end