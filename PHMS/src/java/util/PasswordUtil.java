<<<<<<< Updated upstream
package util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Utility class for password hashing and verification using BCrypt
 */
public class PasswordUtil {
    
    /**
     * Hash a password using BCrypt
     * @param plainPassword The plain text password
     * @return The hashed password
     */
    public static String hashPassword(String plainPassword) {
        if (plainPassword == null || plainPassword.isEmpty()) {
            throw new IllegalArgumentException("Password cannot be null or empty");
        }
        // Generate salt and hash password (BCrypt automatically handles salt)
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt());
    }
    
    /**
     * Verify a password against a hash
     * @param plainPassword The plain text password to verify
     * @param hashedPassword The hashed password from database
     * @return true if password matches, false otherwise
     */
    public static boolean verifyPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) {
            return false;
        }
        try {
            return BCrypt.checkpw(plainPassword, hashedPassword);
        } catch (Exception e) {
            // If hash format is invalid or BCrypt fails, return false
            return false;
        }
    }
    
    /**
     * Check if a password hash is a valid BCrypt hash
     * @param hash The hash to check
     * @return true if it's a valid BCrypt hash, false otherwise
     */
    public static boolean isValidHash(String hash) {
        if (hash == null || hash.length() < 10) {
            return false;
        }
        // BCrypt hashes start with $2a$, $2b$, or $2y$
        return hash.startsWith("$2a$") || hash.startsWith("$2b$") || hash.startsWith("$2y$");
    }
}
=======
package util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Utility class for password hashing and verification using BCrypt
 */
public class PasswordUtil {
    
    /**
     * Hash a password using BCrypt
     * @param plainPassword The plain text password
     * @return The hashed password
     */
    public static String hashPassword(String plainPassword) {
        if (plainPassword == null || plainPassword.isEmpty()) {
            throw new IllegalArgumentException("Password cannot be null or empty");
        }
        // Generate salt and hash password (BCrypt automatically handles salt)
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt());
    }
    
    /**
     * Verify a password against a hash
     * @param plainPassword The plain text password to verify
     * @param hashedPassword The hashed password from database
     * @return true if password matches, false otherwise
     */
    public static boolean verifyPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) {
            return false;
        }
        try {
            return BCrypt.checkpw(plainPassword, hashedPassword);
        } catch (Exception e) {
            // If hash format is invalid or BCrypt fails, return false
            return false;
        }
    }
    
    /**
     * Check if a password hash is a valid BCrypt hash
     * @param hash The hash to check
     * @return true if it's a valid BCrypt hash, false otherwise
     */
    public static boolean isValidHash(String hash) {
        if (hash == null || hash.length() < 10) {
            return false;
        }
        // BCrypt hashes start with $2a$, $2b$, or $2y$
        return hash.startsWith("$2a$") || hash.startsWith("$2b$") || hash.startsWith("$2y$");
    }
}
>>>>>>> Stashed changes
