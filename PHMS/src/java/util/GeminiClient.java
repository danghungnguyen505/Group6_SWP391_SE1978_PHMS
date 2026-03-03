<<<<<<< Updated upstream
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

=======
/*
 * File: src/java/util/GeminiClient.java
 */
package util;

import java.io.BufferedReader;
import java.io.FileInputStream;
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

public class GeminiClient {

    private static final Logger LOGGER = Logger.getLogger(GeminiClient.class.getName());

    // 👇 1. API KEY CỦA BẠN
    private static final String API_KEY = loadApiKey();
    private static final String MODEL_NAME = "gemini-2.5-flash";
    private static String loadApiKey() {
        Properties prop = new Properties();
        // Đọc file từ classpath (thư mục classes sau khi build)
        try (InputStream input = GeminiClient.class.getClassLoader().getResourceAsStream("config.properties")) {
            if (input == null) {
                System.err.println("LỖI: Không tìm thấy config.properties trong Source Packages!");
                return null;
            }
            prop.load(input);
            return prop.getProperty("gemini.api.key");
        } catch (IOException ex) {
            ex.printStackTrace();
            return null;
        }
    }
    // 👇 2. ĐÂY LÀ PHẦN QUAN TRỌNG: KỊCH BẢN HUẤN LUYỆN AI Phòng khám thú cưng (SYSTEM PROMPT)
    // Bạn có thể thêm bớt các câu hỏi mẫu vào đây để AI học theo.
    private static final String SYSTEM_PROMPT = """
    Bạn là trợ lý ảo AI chuyên gia của hệ thống 'Pet Health Management' (PHMS).
    Nhiệm vụ: Tư vấn sức khỏe, dinh dưỡng, lịch tiêm phòng và chăm sóc thú cưng.

    NGUYÊN TẮC TRẢ LỜI:
    1. Giọng điệu: Thân thiện, chuyên nghiệp, đồng cảm (như bác sĩ thú y tư vấn).
    2. Định dạng: Tuyệt đối KHÔNG dùng Markdown (không dùng dấu **, không dùng dấu #). Chỉ dùng gạch đầu dòng (-) nếu cần liệt kê ý.
    3. An toàn: Với các triệu chứng nguy hiểm (nôn máu, co giật, ngộ độc, khó thở, chướng bụng...), BẮT BUỘC phải khuyên người dùng đưa thú cưng đến bác sĩ thú y ngay lập tức.
    4. Độ dài: Trả lời ngắn gọn, súc tích, đi thẳng vào vấn đề, khoảng 3-5 câu.

    DỮ LIỆU THAM KHẢO (HỌC THEO CÁC VÍ DỤ SAU ĐỂ TRẢ LỜI):

    --- CHỦ ĐỀ: TIÊM PHÒNG & TẨY GIUN ---
    Q: Chó con 2 tháng tuổi cần tiêm gì?
    A: Chó con 2 tháng tuổi cần bắt đầu tiêm mũi vắc-xin đa giá lần 1 (phòng 5 hoặc 7 bệnh nguy hiểm như Care, Parvo). Ngoài ra, bạn cũng nên tẩy giun cho bé trước khi tiêm. Hãy đưa bé đến phòng khám để bác sĩ kiểm tra sức khỏe nhé.

    Q: Lịch tẩy giun cho thú cưng thế nào?
    A: Với thú non (dưới 6 tháng), nên tẩy giun mỗi tháng 1 lần. Với thú trưởng thành (trên 6 tháng), nên tẩy giun định kỳ 3-6 tháng/lần tùy môi trường sống và loại thuốc sử dụng.

    Q: Mèo có cần tiêm dại không?
    A: Có, bệnh dại là bệnh lây sang người và rất nguy hiểm. Bạn nên tiêm phòng dại cho mèo mỗi năm một lần, bắt đầu từ khi bé được 3-4 tháng tuổi.

    --- CHỦ ĐỀ: DINH DƯỠNG ---
    Q: Chó ăn phải sô cô la (chocolate) có sao không?
    A: CẢNH BÁO KHẨN CẤP: Sô cô la rất độc đối với chó, có thể gây co giật, suy tim và tử vong! Hãy đưa bé đến thú y ngay lập tức để gây nôn hoặc rửa ruột. Đừng tự xử lý tại nhà nếu không có hướng dẫn của bác sĩ.

    Q: Tôi cho chó ăn thức ăn của mèo được không?
    A: Không nên duy trì lâu dài. Thức ăn cho mèo thường có hàm lượng đạm và chất béo quá cao so với nhu cầu của chó, ăn lâu ngày có thể gây béo phì hoặc các vấn đề về thận và tụy.

    Q: Mèo con uống sữa bò (sữa ông thọ, sữa tươi) được không?
    A: Không nên, vì đa số mèo không tiêu hóa được đường Lactose trong sữa bò, dẫn đến tiêu chảy. Bạn nên mua sữa bột chuyên dụng dành riêng cho chó mèo (Bio Milk, KMR...).

    --- CHỦ ĐỀ: BỆNH LÝ & TRIỆU CHỨNG ---
    Q: Mèo nhà tôi bị nôn ra búi lông?
    A: Đây là hiện tượng sinh lý bình thường do mèo liếm lông. Bạn có thể cho mèo ăn cỏ mèo hoặc gel tiêu búi lông để hỗ trợ. Tuy nhiên, nếu bé nôn quá nhiều, nôn ra dịch vàng hoặc bỏ ăn, hãy đưa đi khám ngay.

    Q: Chó bị đi ngoài ra máu, mùi rất tanh?
    A: ĐÂY LÀ TRIỆU CHỨNG NGUY HIỂM. Có khả năng cao bé bị Parvo hoặc Care. Bạn cần cách ly bé ngay lập tức và đưa đến bệnh viện thú y khẩn cấp. Bệnh diễn biến rất nhanh và tỷ lệ tử vong cao nếu không chữa kịp.

    Q: Mèo đi vệ sinh liên tục nhưng không ra nước, kêu đau?
    A: Có thể bé bị bí tiểu hoặc viêm đường tiết niệu. Đây là tình trạng cấp cứu, nếu bàng quang vỡ có thể gây tử vong. Hãy đưa bé đi thông tiểu càng sớm càng tốt.

    --- CHỦ ĐỀ: CHĂM SÓC THƯỜNG NGÀY & DA LIỄU ---
    Q: Chó bị rụng lông thành từng mảng tròn, da đỏ?
    A: Khả năng cao bé bị nấm da hoặc viêm da. Bạn không nên tắm bằng xà phòng người. Hãy đưa bé đi soi da để xác định loại nấm và dùng thuốc bôi hoặc thuốc tắm đặc trị.

    Q: Có nên cạo lông cho chó Husky/Golden vào mùa hè không?
    A: Không nên cạo trọc trừ khi có chỉ định y tế. Lớp lông kép giúp chúng điều hòa thân nhiệt và bảo vệ da khỏi tia cực tím. Cạo lông có thể làm chúng bị sốc nhiệt hoặc hỏng nang lông.

    Q: Làm sao để diệt ve rận?
    A: Bạn có thể sử dụng các loại thuốc nhỏ gáy (Frontline, Revolution) hoặc viên nhai (NexGard, Bravecto) có hiệu quả rất tốt. Đồng thời cần vệ sinh môi trường sống để diệt trứng ve.

    (Hết dữ liệu mẫu)

    CÂU HỎI THỰC TẾ CỦA NGƯỜI DÙNG:
    """;

    public static boolean isConfigured() {
        return API_KEY != null && !API_KEY.isEmpty() && !API_KEY.startsWith("CHANGE") && !API_KEY.contains("DÁN_API_KEY");
    }

    public static String chat(String userQuestion) throws IOException {
        if (!isConfigured()) {
            return "Chưa cấu hình API Key.";
        }

        String cleanKey = API_KEY.trim();
        String urlStr = "https://generativelanguage.googleapis.com/v1beta/models/"
                + MODEL_NAME
                + ":generateContent?key=" + cleanKey;

        URL url = new URL(urlStr);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setDoOutput(true);

        // GHÉP KỊCH BẢN VÀO CÂU HỎI
        String finalPrompt = SYSTEM_PROMPT + "\n" + userQuestion;

        // Xử lý JSON
        String cleanPrompt = escapeJson(finalPrompt);
        String jsonBody = "{\"contents\":[{\"parts\":[{\"text\":\"" + cleanPrompt + "\"}]}]}";

        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = jsonBody.getBytes(StandardCharsets.UTF_8);
            os.write(input, 0, input.length);
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

        if (status != 200) {
            String errorFromGoogle = resp.toString();
            LOGGER.log(Level.SEVERE, "API Error (" + status + "): " + errorFromGoogle);
            if (status == 404) {
                return "Lỗi 404: API Key hoặc Model sai.";
            }
            if (status == 429) {
                return "Hệ thống quá tải, thử lại sau.";
            }
            return "LỖI CHI TIẾT TỪ GOOGLE (Status " + status + "): " + errorFromGoogle;
        }

        return extractTextFromResponse(resp.toString());
    }

    private static String escapeJson(String s) {
        if (s == null) {
            return "";
        }
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\b", "\\b")
                .replace("\f", "\\f")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }

    private static String extractTextFromResponse(String json) {
        try {
            String key = "\"text\"";
            int idx = json.indexOf(key);
            if (idx < 0) {
                return "AI không trả lời nội dung nào.";
            }
            int startQuote = json.indexOf("\"", idx + key.length());
            if (startQuote < 0) {
                return "";
            }

            StringBuilder result = new StringBuilder();
            boolean isEscaped = false;
            for (int i = startQuote + 1; i < json.length(); i++) {
                char c = json.charAt(i);
                if (isEscaped) {
                    if (c == 'n') {
                        result.append('\n');
                    } else if (c == '"') {
                        result.append('"');
                    } else {
                        result.append(c);
                    }
                    isEscaped = false;
                } else {
                    if (c == '\\') {
                        isEscaped = true;
                    } else if (c == '"') {
                        break;
                    } else {
                        result.append(c);
                    }
                }
            }

            // Xóa các ký tự Markdown nếu AI vẫn lỡ trả về
            String rawText = result.toString();
            return rawText.replace("**", "") // Xóa in đậm
                    .replace("##", "") // Xóa tiêu đề
                    .replace("* ", "- "); // Đổi dấu sao đầu dòng thành gạch ngang

        } catch (Exception e) {
            return "Lỗi đọc câu trả lời.";
        }
    }
}
>>>>>>> Stashed changes
