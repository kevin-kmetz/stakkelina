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
  {:number "^%-?%d+%.?%d*$"
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

(fn tokenize-one [lexeme]
  "Tokenizes a single lexeme."
  (let [anticipated-type (anticipated-token-type lexeme)]
    (if (valid-token-of? anticipated-type lexeme)
      (create-token anticipated-type lexeme)
      [:invalid])))

(fn token-iterator [lexeme-iterator]
  "Returns a closure that iteratively provides tokens from a lexeme
   stream until either all lexemes have been exhausted or an error has
   been encountered."
  (lambda []
    (let [lexeme (lexeme-iterator)]
      (if (lexer.nil? lexeme)
        nil
        (tokenize-one lexeme)))))

(fn tokenize-lexeme-vector [lexeme-vector]
  "Takes a vector of lexemes and returns a vector of tokens."
  (collect [index lexeme (ipairs lexeme-vector)]
    (tokenize-one lexeme)))

(fn tokenize-lexeme-iterator [lexeme-iterator]
  "Takes a lexeme-iterator/factory, and eagerly collects all
   of the tokens generated from it into a token vector."
  (let [collected-tokens []
        token-factory (token-iterator lexeme-iterator)]
    (var current-token (token-factory))
    (while (not= nil current-token)
      (set (. collected-tokens
              (+ 1 (length collected-tokens)))
           (current-token))
      (set current-token (token-factory)))
    collected-tokens))

(fn tokenize-all [lexemes]
  "Takes either raw code (as a string), a vector of lexemes, or a
   lexeme-iterator/factory, and returns a vector of tokens."
  (case (type lexemes)
    :string (tokenize-lexeme-vector (lexer.lex-all lexemes))
    :table (tokenize-lexeme-vector lexemes)
    :function (tokenize-lexeme-iterator lexemes)
    _  (error "Unhandled exception in function 'tokenize-all'.")))

{
  : create-token
  : valid-token-of?
  : anticipated-token-type
  : tokenize-one
  : token-iterator
  : tokenize-lexeme-vector
  : tokenize-lexeme-iterator
  : tokenize-all
}
