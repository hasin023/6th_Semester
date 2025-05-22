package test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import main.Combination;

public class CombinationTest {

    private Combination combination;

    @BeforeEach
    public void setUp() {
        combination = new Combination();
    }

    @Test
    public void TestCombinationIfValid() {
        assertEquals(10, combination.calculate(5, 2));
        assertEquals(66, combination.calculate(12, 10));
        assertEquals(1, combination.calculate(6, 6));
        assertEquals(105, combination.calculate(15, 2));
        assertEquals(15, combination.calculate(15, 14));
        assertEquals(1, combination.calculate(3, 0));
    }

    @Test
    public void TestZeroInput() {
        assertThrows(IllegalArgumentException.class, () -> combination.calculate(0, 0));
    }

    @Test
    public void TestNegativeInput() {
        assertThrows(IllegalArgumentException.class, () -> combination.calculate(-14, 2));
    }

    @Test
    public void TestTooLargeInput() {
        assertThrows(IllegalArgumentException.class, () -> combination.calculate(1000, 1));
    }

    @Test
    public void TestRGreaterThanN() {
        assertThrows(IllegalArgumentException.class, () -> combination.calculate(5, 6));
    }

    @Test
    public void TestFloatCastSimulatesBadInput() {
        int badN = (int) 2.5; // becomes 2
        assertEquals(1, combination.calculate(badN, 2)); // Not throwing, but for demonstration
    }
}
