package com.decomputed;

import static java.lang.Math.abs;

public class Number  {

    /**
     * In mathematics, a multiple is the product of any quantity and an integer.
     *
     * In other words, for the quantities a and b, we say that b is a multiple of a if b = na for some integer n, which is called the multiplier
     * or coefficient.
     *
     * If a is not zero, this is equivalent to saying that b/a is an integer with no remainder.
     *
     * If a and b are both integers, and b is a multiple of a, then a is called a divisor of b.
     *
     * @param divisor the divisor of this.
     * @return true if this is multiple of divisor
     */
    public static boolean isMultipleOf(int multiple, int divisor) {

        return (multiple % divisor == 0) && (abs(multiple) >= abs(multiple));
    }
}
