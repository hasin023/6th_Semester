package test;

import org.junit.jupiter.api.*;
import org.junit.jupiter.api.MethodOrderer.OrderAnnotation;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import org.mockito.Mock;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.when;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import main.CheckoutService;
import main.OrderService;

@TestMethodOrder(OrderAnnotation.class)
public class OrderServiceTest {

    private static OrderService orderService;
    private static boolean isCartValid;
    private static double discountedTotal;

    @Mock
    CheckoutService checkoutService;

    @BeforeAll
    public static void setUp() {
        orderService = new OrderService();
    }

    // Scenario 01
    @Test
    @Order(1)
    public void test_1_validateCart() {
        List<String> cartItems = Arrays.asList("LEGO", "Nerf");
        // isCartValid = false;
        isCartValid = orderService.validateCart(cartItems);
        System.out.println("test_1_validateCart, isCartValid = " + isCartValid);
        Assertions.assertTrue(isCartValid, "Cart should be valid with items.");
    }

    @Test
    @Order(2)
    public void test_2_applyDiscount() {
        Assertions.assertTrue(isCartValid, "Previous step failed.");
        double total = 100.0;
        double discountPercent = 10.0;
        discountedTotal = orderService.applyDiscount(total, discountPercent);
        System.out.println("test_2_applyDiscount, discountedTotal = " + discountedTotal);
        Assertions.assertEquals(90.0, discountedTotal, 0.001);
    }

    @Test
    @Order(3)
    public void test_3_calculateTotalAfterDiscount() {
        List<Double> itemPrices = new ArrayList<>(Arrays.asList(30.0, 30.0, 30.0)); // Sum = 90
        double calculatedTotal = orderService.calculateTotal(itemPrices);
        System.out.println("test_3_calculateTotalAfterDiscount, calculatedTotal = " + calculatedTotal);
        Assertions.assertEquals(discountedTotal, calculatedTotal, 0.001);
    }

    // Scenario 02
    @ParameterizedTest
    @CsvSource({ "100, 10, 90", "100, 5, 95", "100, 100, 0", "100, 0, 100", "100, 101, -1", "100, -1, 101" })
    public void testApplyValidDiscountParameterized(double actualPrize, double discountPercent, double expected) {

        if (discountPercent < 0 || discountPercent > 100) {
            System.out.printf("Invalid discount value %.2f%%.\n", discountPercent);
            assertEquals(expected, 0, 0.001, "Invalid discount should not produce expected value");
        }

        double result = orderService.applyDiscount(actualPrize, discountPercent);
        System.out.printf("Actual %.2f, Discount Perc. %.2f) => %.2f\n", actualPrize, discountPercent, result);
        assertEquals(expected, result, 0.001);
    }

    // Scenario 03

}
