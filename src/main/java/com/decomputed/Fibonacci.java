package com.decomputed;

import java.util.function.LongSupplier;

import static java.lang.Math.sqrt;

/**
 * @author Luis (luis@decomputed.com)
 * @since November 23, 2014 - 13h57
 */
public class Fibonacci {

    /**
     *
     * @param number
     * @return
     */
    public static boolean isFibonacciNumber(Long number) {

        long val = 5 * number * number;
        double val1 = sqrt(val + 4), val2 = sqrt(val - 4);

        return (val1 == (int) val1) || (val2 == (int) val2);
    }
}
