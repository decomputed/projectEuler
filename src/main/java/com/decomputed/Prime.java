package com.decomputed;

import java.util.HashSet;
import java.util.Set;
import java.util.function.Predicate;

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

    public static HashSet<Double> generateSieve(Long limit) {

        Set<String> generated = new HashSet<>();
        HashSet<Double> sieve = new HashSet<>(0);
        Long i, j;

        for (i = 1L; i <= limit; i++) {

            Long jLimit = (limit + i) / ((2 * i) + 1);

            for (j = i; j <= jLimit; j++) {

                if (!generated.contains(i + "-" + j)) {

                    sieve.add((double) (i + j + (2 * i * j)));
                    generated.add(i + "-" + j);
                    generated.add(j + "-" + i);
                }
            }
        }

        return sieve;
    }

}
