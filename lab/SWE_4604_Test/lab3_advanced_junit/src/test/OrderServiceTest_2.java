package test;

import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;

import static org.junit.jupiter.api.Assertions.assertEquals;

import main.OrderService;

public class OrderServiceTest_2 {

    private final OrderService orderService = new OrderService();

    @ParameterizedTest
    @CsvSource({ "100, 10, 90", "100, 5, 95" })
    public void testApplyDiscountParameterized(double total, double discountPercent, double expected) {
        double result = orderService.applyDiscount(total, discountPercent);
        System.out.printf("Actual %.2f, Discount Perc. %.2f) => %.2f\n", total, discountPercent, result);
        assertEquals(expected, result, 0.001);
    }

}
