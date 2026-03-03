<<<<<<< Updated upstream
package util;

import java.io.InputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Properties;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

/**
 * VNPay configuration & helper methods.
 * Values are loaded from VNPay.properties if present on classpath.
 */
public class VNPayConfig {

    public static final String VNP_TMNCODE;
    public static final String VNP_HASH_SECRET;
    public static final String VNP_PAY_URL;
    public static final String VNP_RETURN_URL;

    static {
        Properties props = new Properties();
        String tmn = "";
        String secret = "";
        String url = "";
        String returnUrl = "";
        try {
            InputStream in = VNPayConfig.class.getClassLoader().getResourceAsStream("VNPay.properties");
            if (in != null) {
                props.load(in);
                in.close();
                tmn = props.getProperty("vnp_TmnCode", "");
                secret = props.getProperty("vnp_HashSecret", "");
                url = props.getProperty("vnp_Url", "");
                returnUrl = props.getProperty("vnp_ReturnUrl", "");
            }
        } catch (Exception e) {
            System.out.println("Error loading VNPay.properties: " + e.getMessage());
        }
        VNP_TMNCODE = tmn;
        VNP_HASH_SECRET = secret;
        VNP_PAY_URL = url;
        VNP_RETURN_URL = returnUrl;
    }

    public static String hmacSHA512(String key, String data) {
        try {
            Mac hmac = Mac.getInstance("HmacSHA512");
            SecretKeySpec secretKey = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA512");
            hmac.init(secretKey);
            byte[] bytes = hmac.doFinal(data.getBytes(StandardCharsets.UTF_8));
            StringBuilder hash = new StringBuilder();
            for (byte b : bytes) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hash.append('0');
                hash.append(hex);
            }
            return hash.toString();
        } catch (Exception e) {
            return "";
        }
    }

    public static String urlEncode(String value) {
        return URLEncoder.encode(value, StandardCharsets.UTF_8);
    }
}

=======
package util;

import java.io.InputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Properties;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

/**
 * VNPay configuration & helper methods.
 * Values are loaded from VNPay.properties if present on classpath.
 */
public class VNPayConfig {

    public static final String VNP_TMNCODE;
    public static final String VNP_HASH_SECRET;
    public static final String VNP_PAY_URL;
    public static final String VNP_RETURN_URL;

    static {
        Properties props = new Properties();
        String tmn = "";
        String secret = "";
        String url = "";
        String returnUrl = "";
        try {
            InputStream in = VNPayConfig.class.getClassLoader().getResourceAsStream("VNPay.properties");
            if (in != null) {
                props.load(in);
                in.close();
                tmn = props.getProperty("vnp_TmnCode", "");
                secret = props.getProperty("vnp_HashSecret", "");
                url = props.getProperty("vnp_Url", "");
                returnUrl = props.getProperty("vnp_ReturnUrl", "");
            }
        } catch (Exception e) {
            System.out.println("Error loading VNPay.properties: " + e.getMessage());
        }
        VNP_TMNCODE = tmn;
        VNP_HASH_SECRET = secret;
        VNP_PAY_URL = url;
        VNP_RETURN_URL = returnUrl;
    }

    public static String hmacSHA512(String key, String data) {
        try {
            Mac hmac = Mac.getInstance("HmacSHA512");
            SecretKeySpec secretKey = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA512");
            hmac.init(secretKey);
            byte[] bytes = hmac.doFinal(data.getBytes(StandardCharsets.UTF_8));
            StringBuilder hash = new StringBuilder();
            for (byte b : bytes) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hash.append('0');
                hash.append(hex);
            }
            return hash.toString();
        } catch (Exception e) {
            return "";
        }
    }

    public static String urlEncode(String value) {
        return URLEncoder.encode(value, StandardCharsets.UTF_8);
    }
}

>>>>>>> Stashed changes
