package com.decomputed;

import org.junit.Test;

import java.util.LinkedList;

/**
 * The prime factors of 13195 are 5, 7, 13 and 29.
 * <p>
 * What is the largest prime factor of the number 600851475143 ?
 *
 * @author Luis (luis@decomputed.com)
 * @since December 1, 2014 - 21h49
 */
public class Problem0003Test {


    @Test
    public void primeFactors() {

        LinkedList<Long> factors = Euler.primeFactorsOf(600851475143L);
        System.out.println("-----> " + factors.getLast());
    }
}
