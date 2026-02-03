package util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Simple client for Google Gemini API (Generative Language).
 * Reads configuration from Gemini.properties (apiKey, model, endpoint).
 */
public class GeminiClient {

    private static final Logger LOGGER = Logger.getLogger(GeminiClient.class.getName());

    private static final String API_KEY;
    private static final String MODEL;
    private static final String ENDPOINT;

    static {
        Properties props = new Properties();
        String key = "";
        String model = "gemini-1.5-flash";
        String endpoint = "https://generativelanguage.googleapis.com/v1beta/models/%s:generateContent?key=%s";
        try {
            InputStream in = GeminiClient.class.getClassLoader().getResourceAsStream("Gemini.properties");
            if (in != null) {
                props.load(in);
                in.close();
                key = props.getProperty("apiKey", "");
                model = props.getProperty("model", model);
                String ep = props.getProperty("endpoint", endpoint);
                endpoint = ep;
            }
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error loading Gemini.properties", e);
        }
        API_KEY = key;
        MODEL = model;
        ENDPOINT = endpoint;
    }

    public static boolean isConfigured() {
        return API_KEY != null && !API_KEY.isEmpty();
    }

    /**
     * Call Gemini API with a simple text prompt and return the text response.
     */
    public static String chat(String prompt) throws IOException {
        if (!isConfigured()) {
            throw new IOException("Gemini API key is not configured.");
        }

        String urlStr = String.format(ENDPOINT, MODEL, API_KEY);
        URL url = new URL(urlStr);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
        conn.setDoOutput(true);

        // Build minimal JSON request body manually to avoid extra JSON libraries
        StringBuilder jsonBody = new StringBuilder();
        jsonBody.append("{\"contents\":[{\"parts\":[{\"text\":");
        jsonBody.append("\"").append(escapeJson(prompt)).append("\"");
        jsonBody.append("}]}]}");

        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = jsonBody.toString().getBytes(StandardCharsets.UTF_8);
            os.write(input);
        }

        int status = conn.getResponseCode();
        InputStream is = (status >= 200 && status < 300) ? conn.getInputStream() : conn.getErrorStream();
        StringBuilder resp = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
            String line;
            while ((line = br.readLine()) != null) {
                resp.append(line);
            }
        }

        if (status < 200 || status >= 300) {
            LOGGER.log(Level.WARNING, "Gemini API error: HTTP " + status + " - " + resp);
            throw new IOException("Gemini API error: " + resp);
        }

        // Very simple JSON parsing: try to extract the first "text":"..." value
        return extractFirstTextField(resp.toString());
    }

    private static String escapeJson(String s) {
        if (s == null) return "";
        StringBuilder sb = new StringBuilder();
        for (char c : s.toCharArray()) {
            switch (c) {
                case '"':
                    sb.append("\\\"");
                    break;
                case '\\':
                    sb.append("\\\\");
                    break;
                case '\b':
                    sb.append("\\b");
                    break;
                case '\f':
                    sb.append("\\f");
                    break;
                case '\n':
                    sb.append("\\n");
                    break;
                case '\r':
                    sb.append("\\r");
                    break;
                case '\t':
                    sb.append("\\t");
                    break;
                default:
                    if (c < 0x20) {
                        sb.append(String.format("\\u%04x", (int) c));
                    } else {
                        sb.append(c);
                    }
            }
        }
        return sb.toString();
    }

    /**
     * Naive JSON parser to get the first occurrence of "text":"...".
     */
    private static String extractFirstTextField(String json) {
        if (json == null) return "";
        String key = "\"text\":\"";
        int idx = json.indexOf(key);
        if (idx < 0) return "";
        int start = idx + key.length();
        StringBuilder sb = new StringBuilder();
        boolean escape = false;
        for (int i = start; i < json.length(); i++) {
            char c = json.charAt(i);
            if (escape) {
                // handle a few common escapes
                switch (c) {
                    case '"':
                        sb.append('"');
                        break;
                    case '\\':
                        sb.append('\\');
                        break;
                    case 'n':
                        sb.append('\n');
                        break;
                    case 'r':
                        sb.append('\r');
                        break;
                    case 't':
                        sb.append('\t');
                        break;
                    default:
                        sb.append(c);
                }
                escape = false;
            } else if (c == '\\') {
                escape = true;
            } else if (c == '"') {
                break;
            } else {
                sb.append(c);
            }
        }
        return sb.toString().trim();
    }
}

