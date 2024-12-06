;; tests/lexer.fnl

(fn *lexeme-iterator []
  (let [lexer (require :stakkelina/lexer)
        code (.. "alpha     beta            gamma        delta   "
                 "   epsilon   theta eta                         ")
        lexeme-generator (lexer.lexeme-iterator code)]
    (for [i 1 10]
      (print (lexeme-generator)))))

(fn run []
  (print "\n**tests/lexer")
  (print "\n*lexeme-iterator") (*lexeme-iterator))

{: run}
