package com.decomputed;

/**
 * @author Luis Rodrigues Soares (@luizsoarez)
 * @since November 17, 2014 — 22h08
 */
public interface Multiple {

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
    public Boolean isMultipleOf(Number divisor);
}
