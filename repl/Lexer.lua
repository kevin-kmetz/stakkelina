local _tl_compat; if (tonumber((_VERSION or ''):match('[%d.]*$')) or 0) < 5.3 then local p, m = pcall(require, 'compat53.module'); if p then _tl_compat = m end end; local string = _tl_compat and _tl_compat.string or string







































local function peekLeadingChar(chars)
   local leadingChar = nil
   if chars ~= nil and type(chars) == "string" and #chars > 0 then leadingChar = chars:sub(1, 1) end
   return leadingChar
end

local function stillHasChars(chars)
   local leadingChar = peekLeadingChar(chars)
   return leadingChar ~= nil and #leadingChar == 1, leadingChar
end

local function isQuotationMark(char)
   return char == '"' and true or false
end

local function isApostrophe(char)
   return char == "'" and true or false
end

local function isPrintable(char)
   local asciiValue = string.byte(char)
   return asciiValue >= 33 and asciiValue <= 126
end


local function isDelimiter(char)
   return #char == 1 and (char == ' ' or char == '\t')
end










function ___enable_testing_Lexer()
   _t_peekLeadingChar = peekLeadingChar
   _t_stillHasChars = stillHasChars
   return true
end
