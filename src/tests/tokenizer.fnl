;; tests/tokenizer.fnl

(local fennel/view (. (require :fennel) :view))

(fn pp [printable]
  (print (fennel/view printable) "\n"))

(fn print-token [token]
  (if (= token nil)
    nil
    (print (.. "{:token-type :" (. token :token-type)
               " :representation \"" (. token :representation)
               "\"}"))))

(fn *tokenize-one []
  (let [tokenizer (require :stakkelina/tokenizer)
        tokenize-one tokenizer.tokenize-one]
    (pp (tokenize-one "anchovy"))))

(fn *token-iterator []
  (let [lexer (require :stakkelina/lexer)
        tokenizer (require :stakkelina/tokenizer)
        code (.. "  apple      :banana     ;coconut         @durian    "
                 " 24.982      -321        \"ectoplasm\"    0.28499    "
                 " 8239.       -324.234       -582.                    ")
        lexeme-stream (lexer.lexeme-iterator code)
        token-stream (tokenizer.token-iterator lexeme-stream)]
    (for [i 1 15]
      (pp (token-stream)))))

(fn *tokenize-lexeme-vector []
  (let [lexer (require :stakkelina/lexer)
        tokenizer (require :stakkelina/tokenizer)
        code "alex barry charles david eric frank"
        lexeme-vector (lexer.lex-all code)]
    (pp code)
    (pp lexeme-vector)
    (pp (tokenizer.tokenize-lexeme-vector lexeme-vector))))

(fn *tokenize-lexeme-iterator []
  nil)

(fn *tokenize-all []
  nil)

(fn run []
  (print "\n**tests/tokenizer")
  (print "\n*tokenize-one") (*tokenize-one)
  (print "\n*token-iterator") (*token-iterator)
  (print "\n*tokenize-lexeme-vector") (*tokenize-lexeme-vector)
  (print "\n*tokenize-lexeme-iterator") (*tokenize-lexeme-iterator)
  (print "\n*tokenize-all") (*tokenize-all))

{: run}
