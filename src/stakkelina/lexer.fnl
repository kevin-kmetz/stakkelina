;; stakkelina/lexer.fnl
;;
;; A lexer for the Stakkelina language.
;;
;; The process is as follows:
;;   lexer -> tokenizer -> parser -> (interpreter) -> (repl | compiler)

;; Char possibilities:
;;
;;   \t\r\n {space}         -> whitespace
;;   digit                  -> number
;;   apostrophe             -> datum
;;   colon                  -> keyword
;;   quotation mark         -> string
;;   hyphen                 -> number
;;   semicolon              -> comment
;;   asperand               -> annotation | metadata

(fn has-chars? [cursor char-stream]
  (>= (length char-stream) cursor))

(fn eof [char-stream]
  (+ 1 (length char-stream)))

(fn eof? [cursor char-stream]
  (not (has-chars? cursor char-stream)))

(fn char-at [index string_]
  (if (and (>= index 1)
           (<= index (length string_)))
    (string.sub string_ index index)
    nil))

(fn inc [number]
  (+ 1 number))

(fn dec [number]
  (- number 1))

(fn nil? [value]
  (= nil value))

(fn whitespace? [char]
  (case char
    "\n" true
    "\t" true
    "\r" true
    " "  true
    _    false))

(fn digit? [char]
  (if (string.match char "%d")
    true
    false))

(fn apostrophe? [char]
  (= "'" char))

(fn colon? [char]
  (= ":" char))

(fn quotation-mark? [char]
  (= "\"" char))

(fn hyphen? [char]
  (= "-" char))

(fn asperand? [char]
  (= "@" char))

(fn semicolon? [char]
  (= ";" char))

(fn peek-char [char-stream]
  (char-at 1 char-stream))

;; Essentially, look for the next index of a whitespace char followed
;; by a non-whitespace char, plus one. Can be done with string patterns
;; but nah.
;;
;; The function assumes the cursor is pointing at an index beyond the most
;; recenty lexed segment.
;;
;; Yeeeeeehaaaaaw! Tail call optimization/recursion!
(fn next-lexeme-index [cursor char-stream]
  (case (char-at cursor char-stream)
    (where c (whitespace? c)) (let [next-pos (inc cursor)]
                                (if (not (whitespace? (char-at next-pos char-stream)))
                                  next-pos
                                  (next-lexeme-index next-pos char-stream)))
    (where _ (not (has-chars? cursor char-stream))) (eof char-stream)
    _ cursor))

(fn lexeme-at [cursor char-stream cur-pos]
  "Returns the portion of the lexeme from the specified index to whitespace or EOF.
   Returns nil if no lexeme is present at the index."
  (let [position (if (nil? cur-pos)
                   cursor
                   cur-pos)
        cur-char (char-at position char-stream)]
    (if (or (eof? position char-stream)
            (whitespace? cur-char char-stream))
      (if (= cursor position)
        nil
        (string.sub char-stream
                    cursor
                    (dec position)))
      (lexeme-at cursor char-stream (inc position)))))

(fn lexeme-iterator [char-stream]
  "Returns a closure that iteratively provides lexemes from a character
   stream until either all lexemes have been exhausted or an error has
   been encountered."
  (var cursor (next-lexeme-index 1 char-stream))
  (lambda []
    (if (not (eof? cursor char-stream))
      (let [lexeme (lexeme-at cursor char-stream)
            lexeme-length (length lexeme)]
        (set cursor (next-lexeme-index (+ cursor lexeme-length) char-stream))
        lexeme)
      nil)))

{
  : has-chars?
  : eof
  : eof?
  : char-at
  : inc
  : dec
  : nil?
  : whitespace?
  : digit?
  : apostrophe?
  : colon?
  : quotation-mark?
  : hyphen?
  : asperand?
  : semicolon?
  : peek-char
  : next-lexeme-index
  : lexeme-at
  : lexeme-iterator
}
