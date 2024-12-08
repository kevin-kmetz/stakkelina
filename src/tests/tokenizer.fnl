;; tests/tokenizer.fnl

(fn print-token [token]
  (if (= token nil)
    nil
    (print (.. "{:token-type :" (. token :token-type)
               " :representation \"" (. token :representation)
               "\"}"))))

(fn *tokenize-one []
  (let [tokenizer (require :stakkelina/tokenizer)
        tokenize-one tokenizer.tokenize-one]
    (print-token (tokenize-one "anchovy"))))

(fn *token-iterator []
  (let [lexer (require :stakkelina/lexer)
        tokenizer (require :stakkelina/tokenizer)
        code (.. "  apple      :banana     ;coconut         @durian    "
                 " 24.982      -321        \"ectoplasm\"    0.28499    "
                 " 8239.       -324.234       -582.                    ")
        lexeme-stream (lexer.lexeme-iterator code)
        token-stream (tokenizer.token-iterator lexeme-stream)]
    (for [i 1 15]
      (print-token (token-stream)))))

(fn run []
  (print "\n**tests/tokenizer")
  (print "\n*tokenize-one") (*tokenize-one)
  (print "\n*token-iterator") (*token-iterator))

{: run}
