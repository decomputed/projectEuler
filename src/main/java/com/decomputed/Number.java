package com.decomputed;

import static java.lang.Math.abs;

public class Number implements Multiple {

    private final Integer value;

    public Number(Integer value) {
        this.value = value;
    }

    public Boolean isMultipleOf(Number divisor) {

        return ((getValue() % divisor.getValue()) == 0) && (abs(getValue()) >= abs(divisor.getValue()));
    }

    public Integer getValue() {
        return value;
    }
}
