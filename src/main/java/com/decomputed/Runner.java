package com.decomputed;

/**
 * @author Luis Rodrigues Soares (@luizsoarez)
 * @since November 17, 2014 — 22h38
 */
public class Runner {

    public static Integer sumFor(Integer upperLimit, Integer...divisors) {

        int sum = 0;

        while (upperLimit > 1) {

            upperLimit--;
            sum = sum + isMultipleOf(new Number(upperLimit), divisors);
        }

        return sum;
    }

    private static int isMultipleOf(Number number, Integer[] divisors) {

        int multiple = 0;

        for (Integer divisor : divisors) {

            if (number.isMultipleOf(new Number(divisor))) {

                multiple += number.getValue();
                break;
            }
        }

        return multiple;
    }
}
