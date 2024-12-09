;; stakkelina/stack.fnl

(fn deep-copy-vector [vector]
  "Returns a deep copy of a vector, but does not traverse
   the insides of elements that are vectors/tables themselves."
  (icollect [index element (ipairs vector) &into []]
    element))

(fn create-stack [vector]
  "Initializes and returns a stack, optionally accepting a vector
   of elements of any type. Deep copies elements, but does not traverse
   table elements."
  (case (not= nil vector)
    true  (if (not= 0 (length vector))
            (deep-copy-vector vector)
            [])
    false []))

(fn push [element vector]
  (set (. vector (+ 1 (length vector))) element)
  true)

(fn pop [vector]
  (let [vec-length (length vector)
        popped (. vector vec-length)]
    (set (. vector vec-length) nil)
    popped))

(fn peek [vector]
  (. vector (length vector)))

{
  : deep-copy-vector
  : create-stack
  : push
  : pop
  : peek
}
