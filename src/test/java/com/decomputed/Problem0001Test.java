package com.decomputed;


import org.junit.Test;

import static com.decomputed.Number.isMultipleOf;
import static java.util.stream.IntStream.range;
import static org.junit.Assert.assertEquals;

/**
 * If we list all the natural numbers below 10 that are multiples of 3 or 5, we get 3, 5, 6 and 9. The sum of these multiples is 23.
 * <p>
 * Find the sum of all the multiples of 3 or 5 below 1000.
 */
public class Problem0001Test {

    @Test
    public void testConfirmation() {

        assertEquals(
                range(1, 1000)
                        .filter(n -> isMultipleOf(n, 3) || isMultipleOf(n, 5))
                        .sum(),
                233168);
    }
}
