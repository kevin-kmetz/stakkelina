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
  (let [lexer (require :stakkelina/lexer)
        tokenizer (require :stakkelina/tokenizer)
        code "alex brittany christine danielle erica francine"
        lexeme-iterator (lexer.lexeme-iterator code)]
    (pp code)
    (pp (tokenizer.tokenize-lexeme-iterator lexeme-iterator))))

(fn *tokenize-all []
  (let [lexer (require :stakkelina/lexer)
        tokenizer (require :stakkelina/tokenizer)
        code "albany boise chicago detroit eugene fresno gary"
        lexeme-vector (lexer.lex-all code)
        lexeme-factory (lexer.lexeme-iterator code)]
    (print "Code:" code)
    (print "Vector:" lexeme-vector)
    (print "Factory: " lexeme-factory)
    (print "\nCalled with code:") (pp (tokenizer.tokenize-all code))
    (print "\nCalled with vector:") (pp (tokenizer.tokenize-all lexeme-vector))
    (print "\nCalled with factory:") (pp (tokenizer.tokenize-all lexeme-factory))))

(fn run []
  (print "\n**tests/tokenizer")
  (print "\n*tokenize-one") (*tokenize-one)
  (print "\n*token-iterator") (*token-iterator)
  (print "\n*tokenize-lexeme-vector") (*tokenize-lexeme-vector)
  (print "\n*tokenize-lexeme-iterator") (*tokenize-lexeme-iterator)
  (print "\n*tokenize-all") (*tokenize-all))

{: run}
