(ns project-euler.core
  (:require 
   [pythagoras.core :as p]))

(def problem-1
  "If we list all the natural numbers below 10 that are multiples of 3 or 5, we get 3, 5, 6 and 9. The sum of these multiples is 23. Find the sum of all the multiples of 3 or 5 below 1000."
  (reduce +
          (filter
           (fn [x] (or (p/multiple? x 5) (p/multiple? x 3)))
           (range 1 1000))))
