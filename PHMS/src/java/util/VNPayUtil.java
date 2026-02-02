package util;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.*;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

public class VNPayUtil {

  public static String buildQuery(Map<String, String> params, String secretKey) {
    try {
        List<String> fieldNames = new ArrayList<>(params.keySet());
        Collections.sort(fieldNames);

        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();

        for (String fieldName : fieldNames) {
            String value = params.get(fieldName);
            if (value != null && value.length() > 0) {

                // ❌ DO NOT encode in hashData
                hashData.append(fieldName).append("=").append(value).append("&");

                // ✅ Encode ONLY in query string
                query.append(URLEncoder.encode(fieldName, StandardCharsets.UTF_8.toString()))
                     .append("=")
                     .append(URLEncoder.encode(value, StandardCharsets.UTF_8.toString()))
                     .append("&");
            }
        }

        // remove trailing &
        hashData.setLength(hashData.length() - 1);
        query.setLength(query.length() - 1);

        System.out.println("VNPay HASH DATA = " + hashData);

        String secureHash = hmacSHA512(secretKey, hashData.toString());

        return query.toString()
                + "&vnp_SecureHashType=HmacSHA512"
                + "&vnp_SecureHash=" + secureHash;

    } catch (Exception e) {
        throw new RuntimeException(e);
    }
}




    public static String hmacSHA512(String key, String data) throws Exception {
    Mac hmac512 = Mac.getInstance("HmacSHA512");
    SecretKeySpec secretKey = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA512");
    hmac512.init(secretKey);
    byte[] bytes = hmac512.doFinal(data.getBytes(StandardCharsets.UTF_8));

    StringBuilder hash = new StringBuilder();
    for (byte b : bytes) {
        hash.append(String.format("%02x", b));
    }
    return hash.toString();
}

}
