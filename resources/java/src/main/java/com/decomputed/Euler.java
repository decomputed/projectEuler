package com.decomputed;


import java.util.LinkedList;
import java.util.function.BiPredicate;

import static java.lang.Math.sqrt;

public class Euler {

    /**
     * In mathematics, a multiple is the product of any quantity and an integer.
     * <p>
     * In other words, for the quantities a and b, we say that b is a multiple of a if b = na for some integer n, which is called the multiplier
     * or coefficient.
     * <p>
     * If a is not zero, this is equivalent to saying that b/a is an integer with no remainder.
     * <p>
     * If a and b are both integers, and b is a multiple of a, then a is called a divisor of b.
     */
    public static BiPredicate<Integer, Integer> isMultipleOf = (multiple, divisor) -> (multiple % divisor == 0);

    /**
     * Checks whether a number belongs to the Fibonacci sequence by using Binet's Formula.
     *
     * @param number The number we want to test
     * @return true if one of 5x^2+4 or 5x^2-4 are perfect squares
     */
    public static boolean isFibonacciNumber(Long number) {

        Long squared = 5 * number * number;
        Double squaredPlus4 = sqrt(squared + 4);

        if (squaredPlus4 == squaredPlus4.intValue()) {

            return true;

        } else {

            Double squaredMinus4 = sqrt(squared - 4);
            return squaredMinus4 == squaredMinus4.intValue();
        }
    }


    public static LinkedList<Long> primeFactorsOf(Long number) {

        LinkedList<Long> factors = new LinkedList<>();
        Long denominator = 2L;
        Double numerator = Double.valueOf(number);
        Double quotient;

        do {

            quotient = numerator / denominator;

            if (quotient == quotient.longValue()) {

                numerator = quotient;
                factors.add(denominator);

            } else {

                denominator = Prime.nextPrime(denominator);
            }
        } while (quotient > 1);

        return factors;
    }
}
