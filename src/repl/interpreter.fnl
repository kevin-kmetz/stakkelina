;; repl/interpreter.fnl
;;
;; A preliminary interpreter for the Stakkelina language.

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

(fn token-type [char-stream]
  (if (> (length char-stream) 0)
    (case (peek-char char-stream)
      (where c (whitespace? c))     :whitespace
      (where c (digit? c))          :number
      (where c (apostrophe? c))     :datum
      (where c (colon? c))          :keyword
      (where c (quotation-mark? c)) :string
      (where c (hyphen? c))         :number
      (where c (asperand? c))       :annotation
      (where c (semicolon? c))      :comment
      _                             :symbol)
  nil))

;; Essentially, look for the next index of a whitespace char followed
;; by a non-whitespace char, plus one. Can be done with string patterns
;; but nah.
;;
;; The function assumes the cursor is pointing at an index beyond the most
;; recenty lexed segment.
;;
;; Yeeeeeehaaaaaw! Tail call optimization/recursion!
(fn next-token-index [cursor char-stream]
  (case (char-at cursor char-stream)
    (where c (whitespace? c)) (let [next-pos (inc cursor)]
                                (if (not (whitespace? (char-at next-pos char-stream)))
                                  next-pos
                                  (next-token-index next-pos char-stream)))
    (where _ (not (has-chars? cursor char-stream))) nil
    _ cursor))

(fn token-at [cursor char-stream cur-pos]
 "Returns the portion of the token from the specified index to whitespace or EOF.
  Returns nil if no token is present at the index."
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
      (token-at cursor char-stream (inc position)))))

{:has-chars?       has-chars?
 :eof?             eof?
 :char-at          char-at
 :inc              inc
 :dec              dec
 :nil?             nil?
 :whitespace?      whitespace?
 :digit?           digit?
 :apostrophe?      apostrophe?
 :colon?           colon?
 :quotation-mark?  quotation-mark?
 :hyphen?          hyphen?
 :asperand?        asperand?
 :semicolon?       semicolon?
 :peek-char        peek-char
 :token-type       token-type
 :next-token-index next-token-index
 :token-at         token-at}
