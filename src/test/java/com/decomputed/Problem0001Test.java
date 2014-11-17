package com.decomputed;


import org.junit.Test;

import static org.junit.Assert.assertTrue;

/**
 * If we list all the natural numbers below 10 that are multiples of 3 or 5, we get 3, 5, 6 and 9. The sum of these multiples is 23.
 * <p/>
 * Find the sum of all the multiples of 3 or 5 below 1000.
 */
public class Problem0001Test {

    @Test
    public void testConfirmation() {

        assertTrue(Runner.sumFor(10, 3, 5) == 23);
        assertTrue(Runner.sumFor(20, 3, 5) == 78);
        assertTrue(Runner.sumFor(1000, 3, 5) == 233168);
    }

}
