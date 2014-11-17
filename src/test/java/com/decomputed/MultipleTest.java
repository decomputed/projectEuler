package com.decomputed;

import org.junit.Test;

public class MultipleTest {

    @Test
    public void testIsMultipleOf() throws Exception {

        Number a = new Number(15);
        Number b = new Number(3);

        assert (a.isMultipleOf(b));
        assert (!b.isMultipleOf(a));
    }
}
