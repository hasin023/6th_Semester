package main;

public interface PaymentProcessor {
    String processPayment(String userId, double amount);
}
