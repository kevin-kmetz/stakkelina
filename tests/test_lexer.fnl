;; tests/lexer.fnl

(local fennel/view (. (require :fennel) :view))

(fn pp [printable]
  (print (fennel/view printable) "\n"))

(fn *lex-one []
  (let [lexer (require :stakkelina/lexer)
        code (.. "   aardvark    bison  camel   dinosaur"
                 " elephant fox   giraffe")
        lex-one-and-print (lambda [lex-state]
                            (let [next-state (lexer.lex-one lex-state)]
                              (pp next-state)
                              next-state))]
    (-> code
        lexer.initialize-lexer
        lex-one-and-print
        lex-one-and-print
        lex-one-and-print
        lex-one-and-print
        lex-one-and-print
        lex-one-and-print
        lex-one-and-print
        lex-one-and-print
        lex-one-and-print
        lex-one-and-print)))

(fn *lexeme-iterator []
  (let [lexer (require :stakkelina/lexer)
        code (.. "alpha     beta            gamma        delta   "
                 "   epsilon   theta eta                         ")
        lexeme-generator (lexer.lexeme-iterator code)]
    (for [i 1 10]
      (print (lexeme-generator)))))

(fn run []
  (print "\n**tests/lexer")
  (print "\n*lex-one") (*lex-one)
  (print "\n*lexeme-iterator") (*lexeme-iterator))

{: run}
