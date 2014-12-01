package com.decomputed;

/**
 * @author Luis (luis@decomputed.com)
 * @since December 01, 2014 - 20h27
 */
public class Prime {

    public static Boolean isPrime(Long number) {

        if (number < 2) {
            return false;
        }

        if (number > 2 && number % 2 == 0) {
            return false;
        }

        for (long x = number - 1; x > 1; x--) {
            if (number % x == 0) {
                return false;
            }
        }

        return true;
    }

    public static Long nextPrime(Long top) {

        long next = top;
        do {
            next++;
        } while (!isPrime(next));

        return next;
    }
}
