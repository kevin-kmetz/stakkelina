;; stakkelina/common.fnl

(fn nil? [value]
  (if (= (type value) :nil)
    true
    false))

{
  : nil?
}
