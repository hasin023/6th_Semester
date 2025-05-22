package main;

public class Combination {
    public int calculate(int n, int r) {
        if (n <= 0 || r < 0 || n > 15 || r > 15 || r > n) {
            throw new IllegalArgumentException("Inputs must be in the range n = 1..15, r = 0..15, and r <= n.");
        }
        return (int) (factorial(n) / (factorial(r) * factorial(n - r)));
    }

    private long factorial(int num) {
        long result = 1;
        for (int i = 2; i <= num; i++) {
            result *= i;
        }
        return result;
    }
}
