;; stakkelina/tokenizer.fnl
;;
;; A tokenizer for the Stakkelina programming language.

(local lexer (require :stakkelina/lexer))

(fn create-token [token-type representation]
  {:token-type token-type
   :representation representation})

(fn valid-number? [candidate]
  (if (string.match candidate "%--%d*(.%d+)-")
    true
    false))

(fn anticipated-token-type [lexeme]
  (case (lexer.peek-char lexeme)
    (where c (lexeme.whitespace? c))     :whitespace
    (where c (lexeme.digit? c))          :number
    (where c (lexeme.apostrophe? c))     :datum
    (where c (lexeme.colon? c))          :keyword
    (where c (lexeme.quotation-mark? c)) :string
    (where c (lexeme.hyphen? c))         :number
    (where c (lexeme.asperand? c))       :annotation
    (where c (lexeme.semicolon? c))      :comment
    _                                    :symbol))

{
  :create-token           create-token
  :valid-number?          valid-number?
  :anticipated-token-type anticipated-token-type
}
