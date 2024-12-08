;; repl/parser.fnl
;;
;; The functions needed to convert Stakkelina code into
;; an abstract syntax tree.

(local builtins (require :stakkelina/builtins))
(local built-in?* builtins.built-in?*)

(local lexer (require :stakkelina/lexer))
(local tokenizer (require :stakkelina/tokenizer))

(fn token-type [token] (. token :token-type))
(fn representation [token] (. token :representation))

(fn create-node [node-type sub-type value]
  {:node-type node-type
   :sub-type  sub-type
   :value     value})

(fn parse-number [number-token]
  (create-node :literal :number (tonumber (representation number-token))))

(fn parse-created-symbol [symbol-token]
  (create-node :symbol :created (representation symbol-token)))

(fn parse-builtin-symbol [symbol-token]
  (create-node :symbol :built-in (. symbol-token :representation)))

(fn parse-symbol [symbol-token]
  (case (built-in?* symbol-token)
    false       (parse-created-symbol symbol-token)
    [true func] (parse-builtin-symbol symbol-token)))

(fn parse-string [string-token]
  (create-node :literal :string (representation string-token)))

(fn parse-one [token]
  "Takes a token and returns the equivalent abstract
   syntax tree node."
  (case (token-type token)
    :number (parse-number token)
    :symbol (parse-symbol token)
    :string (parse-string token)
    _       (error "Unhandled exception in function 'parse-token' - unrecognized token type.")))

(fn node-iterator [token-iterator]
  "Returns a closure that iteratively provides AST nodes from a token
   iterator until either all tokens have been exhausted or an error has
   been encountered."
  (lambda []
    (let [token (token-iterator)]
      (if (lexer.nil? token)
        nil
        (parse-one token)))))

(fn parse-token-vector [token-vector]
  "Takes a vector of tokens and returns a vector of AST nodes."
  (icollect [index token (ipairs token-vector)]
    (parse-one token)))

(fn parse-token-iterator [token-iterator]
  "Takes a token-iterator/factory, and eagerly collects all
   of the AST nodes generated from it into a node vector."
  (let [collected-nodes []
        node-factory (node-iterator token-iterator)]
    (var current-node (node-factory))
    (while (not= nil current-node)
      (set (. collected-nodes
              (+ 1 (length collected-nodes)))
           current-node)
      (set current-node (node-factory)))
    collected-nodes))

(fn parse-all [tokens]
  "Takes either raw code (as a string), a vector of tokens, or a
   token-iterator/factory, and returns a vector of AST nodes."
  (case (type tokens)
    :string (parse-token-vector (tokenizer.tokenize-all tokens))
    :table (parse-token-vector tokens)
    :function (parse-token-iterator tokens)
    _  (error "Unhandled exception in function 'parse-all'.")))

{
  : parse-one
  : node-iterator
  : parse-token-vector
  : parse-token-iterator
  : parse-all
}
