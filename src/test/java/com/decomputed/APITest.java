package com.decomputed;

import org.junit.Ignore;
import org.junit.Test;

import java.util.LinkedList;

import static java.lang.Long.MAX_VALUE;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

public class APITest {

    @Test
    public void testIsMultipleOf() {

        int a = 15;
        int b = 3;

        assertTrue(Euler.isMultipleOf.test(a, b));
        assertTrue(Euler.isMultipleOf.test(a, -b));

        assertFalse(Euler.isMultipleOf.test(b, a));
    }

    @Test
    public void testIsPrime() {

        assertTrue(Prime.isPrime(2L));
        assertTrue(Prime.isPrime(3L));
        assertTrue(Prime.isPrime(5L));
        assertTrue(Prime.isPrime(7L));
        assertTrue(Prime.isPrime(11L));
        assertTrue(Prime.isPrime(15487469L));
        assertTrue(Prime.isPrime(179425859L));

        assertTrue(!Prime.isPrime(4L));
        assertTrue(!Prime.isPrime(1000L));
        assertTrue(!Prime.isPrime(32416190072L));
    }

    @Test
    public void testPrimeFactors() {

        LinkedList<Long> factors = Euler.primeFactorsOf(13195L);

        assertFalse(factors.isEmpty());
        assertTrue(factors.size() == 4);
        assertTrue(factors.contains(5L));
        assertTrue(factors.contains(7L));
        assertTrue(factors.contains(13L));
        assertTrue(factors.contains(29L));
    }

    @Ignore
    public void theBiggestMotherFucker() {
        System.out.println("-------------");
        System.out.println(Prime.isPrime(MAX_VALUE));
        System.out.println("-------------");
    }
}
