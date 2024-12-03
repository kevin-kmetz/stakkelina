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
  (string.sub char-stream 1 1))

(fn peek-token [char-stream]
  nil)

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

(fn get-token [char-stream]
  nil)

{:whitespace?     whitespace?
 :digit?          digit?
 :apostrophe?     apostrophe?
 :colon?          colon?
 :quotation-mark? quotation-mark?
 :hyphen?         hyphen?
 :asperand?       asperand?
 :semicolon?      semicolon?
 :peek-char       peek-char
 :peek-token      peek-token
 :token-type      token-type
 :get-token       get-token}
