;; repl/parser.fnl
;;
;; The functions needed to convert Stakkelina code into
;; an abstract syntax tree.

(local builtins (require :stakkelina/builtins))
(local built-in?* builtins.built-in?*)

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

(fn parse-token [token]
  "Takes a token and returns the equivalent abstract
   syntax tree node."
  (case (token-type token)
    :number (parse-number token)
    :symbol (parse-symbol token)
    :string (parse-string token)
    _       (error "Unhandled exception in function 'parse-token' - unrecognized token type.")))

{: parse-token}
