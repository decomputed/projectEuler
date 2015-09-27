(ns project-euler.core)

(defn multiple?
  "Tests if a number is a multiple of another"
  [number divisor]
  (zero? (rem number divisor)))
