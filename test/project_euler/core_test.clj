(ns project-euler.core-test
  (:require [clojure.test :refer :all]
            [project-euler.core :as e]))

(deftest Multiples

  (testing "Problem 1"
    (is (= e/problem-1 233168))))
