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
   return #char == 1 and (char == ' ' or char == '\t' or char == '\n')
end

local function buildCandidateFromQuotationString(chars)




   local candidate = '"'
   chars = chars:sub(2)
   local endedWithQuotationMark = false
   local stillChars, ignoreNextChar = false, false
   local currentChar

   if #chars < 1 then error('Malform token encountered - single quote token.') end

   repeat
      stillChars, currentChar = stillHasChars(chars)
      if not stillChars then error('Malformed token encountered -  unclosed string token.') end
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



















local function buildCandidate(chars)

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

function ___enable_testing_Lexer()
   _t_peekLeadingChar = peekLeadingChar
   _t_stillHasChars = stillHasChars
   _t_isQuotationMark = isQuotationMark
   _t_isApostrophe = isApostrophe
   _t_isPrintable = isPrintable
   _t_isDelimiter = isDelimiter
   _t_buildCandidateFromQuotationString = buildCandidateFromQuotationString

   _t_buildCandidate = buildCandidate
   return true
end
