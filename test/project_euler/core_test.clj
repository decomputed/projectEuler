(ns project-euler.core-test
  (:require [clojure.test :refer :all]
            [project-euler.core :refer :all]))

(deftest Multiples
  (testing "multiple? works"
    (is (multiple? 14 7))
    (is (multiple? 14 -7))
    (is (not (multiple? 14 8)))
    (is (not (multiple? 14 -8)))
    (is (multiple? 0 7)))

  (testing "Problem 1"
    (is (= 233168 (reduce + (filter (fn [x] (or (multiple? x 5) (multiple? x 3))) (range 1 1000)))))))
