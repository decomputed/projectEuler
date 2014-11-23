package com.decomputed.api;

import com.decomputed.Number;
import org.junit.Test;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

public class MultipleTest {

    @Test
    public void testIsMultipleOf() throws Exception {

        int a = 15;
        int b = 3;

        assertTrue(Number.isMultipleOf(a, b));
        assertTrue(Number.isMultipleOf(a, -b));

        assertFalse(Number.isMultipleOf(b, a));
    }
}
