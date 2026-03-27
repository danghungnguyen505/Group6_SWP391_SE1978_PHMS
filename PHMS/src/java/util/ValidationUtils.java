package util;

import java.util.regex.Pattern;

/**
 * Utility class for input validation
 * Provides methods to validate common input types
 */
public class ValidationUtils {
    
    // Email pattern
    private static final Pattern EMAIL_PATTERN = Pattern.compile(
        "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
    );
    
    // Vietnamese phone number pattern: exactly 10 digits, starts with 0
    private static final Pattern PHONE_PATTERN = Pattern.compile(
        "^0\\d{9}$"
    );
    
    // Username pattern: alphanumeric, underscore, 3-50 characters
    private static final Pattern USERNAME_PATTERN = Pattern.compile(
        "^[a-zA-Z0-9_]{3,50}$"
    );
    
    /**
     * Validate email format
     */
    public static boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        return EMAIL_PATTERN.matcher(email.trim()).matches();
    }
    
    /**
     * Validate phone number format (Vietnamese)
     */
    public static boolean isValidPhone(String phone) {
        if (phone == null || phone.trim().isEmpty()) {
            return false;
        }
        // Remove spaces and dashes
        String cleaned = phone.replaceAll("[\\s-]", "");
        return PHONE_PATTERN.matcher(cleaned).matches();
    }
    
    /**
     * Validate username format
     */
    public static boolean isValidUsername(String username) {
        if (username == null || username.trim().isEmpty()) {
            return false;
        }
        return USERNAME_PATTERN.matcher(username.trim()).matches();
    }
    
    /**
     * Validate password strength
     * Minimum 6 characters
     */
    public static boolean isValidPassword(String password) {
        if (password == null || password.isEmpty()) {
            return false;
        }
        return password.length() >= 6;
    }
    
    /**
     * Check if string is not null and not empty (after trim)
     */
    public static boolean isNotEmpty(String str) {
        return str != null && !str.trim().isEmpty();
    }
    
    /**
     * Check if string length is within range
     */
    public static boolean isLengthValid(String str, int minLength, int maxLength) {
        if (str == null) {
            return minLength == 0;
        }
        int length = str.trim().length();
        return length >= minLength && length <= maxLength;
    }
    
    /**
     * Validate positive number
     */
    public static boolean isPositiveNumber(String str) {
        if (str == null || str.trim().isEmpty()) {
            return false;
        }
        try {
            double num = Double.parseDouble(str.trim());
            return num > 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }
    
    /**
     * Validate integer in range
     */
    public static boolean isIntegerInRange(String str, int min, int max) {
        if (str == null || str.trim().isEmpty()) {
            return false;
        }
        try {
            int num = Integer.parseInt(str.trim());
            return num >= min && num <= max;
        } catch (NumberFormatException e) {
            return false;
        }
    }
    
    /**
     * Sanitize string input (remove leading/trailing whitespace)
     */
    public static String sanitize(String str) {
        if (str == null) {
            return "";
        }
        return str.trim();
    }
}
