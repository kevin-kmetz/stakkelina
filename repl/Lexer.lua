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

global function lex(chars: string): string|nil

    chars = reduceUntilValid(chars)
    local candidate: string

    candidate, chars = buildCandidate(chars)

    return nil

end

local function buildCandidate(chars: string): string, string

    local first = getChar(chars)
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

end

local function isQuotationMark(char: string): boolean
end

local function isApostrophe(char: string): boolean
end

local function isPrintableNonDelimiter(char: string): boolean
end

local function buildQuoteString(char: string): string, string
end

local function buildQuoteString(char: string): string, string
end

local function buildRegularCandidate(chars: string): string, string
end