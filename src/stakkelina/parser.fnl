;; repl/parser.fnl
;;
;; The functions needed to convert Stakkelina code into
;; an abstract syntax tree.

(local builtins (require :stakkelina/builtins))

(fn token-type [token] (. token :token-type))
(fn representation [token] (. token :representation))

(fn parse-token [token]
  "Takes a token and returns the equivalent abstract
   syntax tree node."
  (case (token-type token)
    :number {:node-type :literal
             :sub-type  :number
             :value     (tonumber (representation token))}
    :symbol (case (builtins.built-in?* token)
              false {:node-type :symbol
                     :sub-type  :created
                     :value     (representation token)}
              [true func] {:node-type :symbol
                           :sub-type  :built-in
                           :value     func})
    :string {:node-type :literal
             :sub-type  :string
             :value     (representation token)}
    _ nil))

{: parse-token}
