;; tests/parser.fnl

(local fennel/view (. (require :fennel) :view))
(fn pp [printable]
  (print (fennel/view printable) "\n"))

(local lexer (require :stakkelina/lexer))
(local tokenizer (require :stakkelina/tokenizer))
(local parser (require :stakkelina/parser))

(fn *parse-one []
  (let [parse-one parser.parse-one
        new-token #{:token-type $1 :representation $2}
        show-token #(let [{:node-type n :sub-type s :value v} $] (print n s v))]
    (show-token (parse-one (new-token :number 86.75)))
    (show-token (parse-one (new-token :symbol "butterfly")))))

(fn *node-iterator []
  (let [code (.. "  anchorage      bois   coolidge      dallas    "
                 " 98.7     -501      \"endoplasm\"    0.574245   "
                 " 8239.       \"\"       eritrea                 ")
        lexeme-stream (lexer.lexeme-iterator code)
        token-stream (tokenizer.token-iterator lexeme-stream)
        node-stream (parser.node-iterator token-stream)]
    (for [i 1 15]
      (pp (node-stream)))))

(fn *parse-token-vector []
  (let [code "alex barry charles david eric frank"
        token-vector (tokenizer.tokenize-all code)]
    (pp code)
    (pp token-vector)
    (pp (parser.parse-token-vector token-vector))))

(fn *parse-token-iterator []
  (let [code "alex brittany christine danielle erica francine"
        lexeme-iterator (lexer.lexeme-iterator code)
        token-iterator (tokenizer.token-iterator lexeme-iterator)]
    (pp code)
    (pp (parser.parse-token-iterator token-iterator))))

(fn *parse-all []
  (let [code "albany boise chicago detroit eugene fresno gary"
        token-vector (tokenizer.tokenize-all code)
        lexeme-factory (lexer.lexeme-iterator code)
        token-factory (tokenizer.token-iterator lexeme-factory)]
    (print "Code:" code)
    (print "Token vector:" token-vector)
    (print "Token factory: " token-factory)
    (print "\nCalled with code:") (pp (parser.parse-all code))
    (print "\nCalled with token vector:") (pp (parser.parse-all token-vector))
    (print "\nCalled with token factory:") (pp (parser.parse-all token-factory))))

(fn run []
  (print "\n**tests/parser")
  (print "\n*parse-one") (*parse-one)
  (print "\n*node-iterator") (*node-iterator)
  (print "\n*parse-token-vector") (*parse-token-vector)
  (print "\n*parse-token-iterator") (*parse-token-iterator)
  (print "\n*parse-all") (*parse-all))

{: run}
