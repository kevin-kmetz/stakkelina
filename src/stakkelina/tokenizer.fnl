;; stakkelina/tokenizer.fnl
;;
;; A tokenizer for the Stakkelina programming language.

(local lexer (require :stakkelina/lexer))

(fn create-token [token-type representation]
  {:token-type token-type
   :representation representation})

;; These are very incomplete definitions that are just serving
;; as prototyping placeholders for now. I should of course just
;; use LPEG, but I'm considering rolling my own recursive descent
;; backtracking pattern matcher in vanilla Fennel so that I have
;; the option of porting it to other languages.
(local token-type-patterns
  {:number "^%-?%d*%.?%d+$"
   :keyword "^%:%w[%w%!%:%^%&%*%?%/%-%+%<%>%|%%]*$"
   :string "^%\".*%\"$"
   :comment "^%;.*$"
   :annotation "^%@%w+$"
   :symbol "^[%w%_][%w%_%!%%%^%&%*%?%<%>%.%-%+%:%|]*$"})

(fn valid-token-of? [token-type candidate]
  (if (string.match candidate (. token-type-patterns token-type))
    true
    false))

(fn anticipated-token-type [lexeme]
  (case (lexer.peek-char lexeme)
    (where c (lexer.whitespace? c))     :whitespace
    (where c (lexer.digit? c))          :number
    (where c (lexer.apostrophe? c))     :datum
    (where c (lexer.colon? c))          :keyword
    (where c (lexer.quotation-mark? c)) :string
    (where c (lexer.hyphen? c))         :number
    (where c (lexer.asperand? c))       :annotation
    (where c (lexer.semicolon? c))      :comment
    _                                   :symbol))

(fn tokenize [lexeme]
  (let [anticipated-type (anticipated-token-type lexeme)]
    (if (valid-token-of? anticipated-type lexeme)
      (create-token anticipated-type lexeme)
      '[:invalid])))

{
  : create-token
  : valid-token-of?
  : anticipated-token-type
  : tokenize
}
