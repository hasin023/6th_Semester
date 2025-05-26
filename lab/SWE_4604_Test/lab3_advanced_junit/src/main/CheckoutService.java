package main;

public class CheckoutService {
    private final PaymentProcessor processor;

    public CheckoutService(PaymentProcessor processor) {
        this.processor = processor;
    }

    public String checkout(String userId, double totalAmount) {
        return processor.processPayment(userId, totalAmount);
    }
}
