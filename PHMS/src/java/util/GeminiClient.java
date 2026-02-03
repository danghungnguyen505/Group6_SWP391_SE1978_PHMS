/*
 * File: src/java/util/GeminiClient.java
 */
package util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.logging.Level;
import java.util.logging.Logger;

public class GeminiClient {

    private static final Logger LOGGER = Logger.getLogger(GeminiClient.class.getName());

    // 👇 1. API KEY CỦA BẠN
    private static final String API_KEY = "AIzaSyD8qfH6VB-mmH9QGxAD8U2l8YClMlnTZZg";

    private static final String MODEL_NAME = "gemini-2.5-flash";

    // 👇 2. ĐÂY LÀ PHẦN QUAN TRỌNG: KỊCH BẢN HUẤN LUYỆN AI (SYSTEM PROMPT)
    // Bạn có thể thêm bớt các câu hỏi mẫu vào đây để AI học theo.
    private static final String SYSTEM_PROMPT = """
    Bạn là trợ lý ảo AI chuyên gia của hệ thống 'Pet Health Management' (PHMS).
    Nhiệm vụ: Tư vấn sức khỏe, dinh dưỡng, lịch tiêm phòng và chăm sóc thú cưng.
    
    NGUYÊN TẮC TRẢ LỜI:
    1. Giọng điệu: Thân thiện, chuyên nghiệp, đồng cảm.
    2. Định dạng: Tuyệt đối KHÔNG dùng Markdown (không dùng dấu **, không dùng dấu #). Dùng gạch đầu dòng (-) nếu cần liệt kê.
    3. An toàn: Với các triệu chứng nguy hiểm (nôn máu, co giật, ngộ độc, khó thở...), BẮT BUỘC phải khuyên người dùng đưa thú cưng đến bác sĩ thú y ngay lập tức.
    4. Độ dài: Trả lời ngắn gọn, đi thẳng vào vấn đề, khoảng 3-5 câu.

    DỮ LIỆU THAM KHẢO (HỌC THEO CÁC VÍ DỤ SAU):
    
    Q: Chó con 2 tháng tuổi cần tiêm gì?
    A: Chó con 2 tháng tuổi cần bắt đầu tiêm mũi vắc-xin đa giá lần 1 (phòng 5 hoặc 7 bệnh nguy hiểm như Care, Parvo). Ngoài ra, bạn cũng nên tẩy giun cho bé trước khi tiêm. Hãy đưa bé đến phòng khám để bác sĩ kiểm tra sức khỏe nhé.

    Q: Mèo nhà tôi bị nôn ra búi lông?
    A: Đây là hiện tượng sinh lý bình thường do mèo liếm lông. Bạn có thể cho mèo ăn cỏ mèo hoặc gel tiêu búi lông để hỗ trợ tiêu hóa. Tuy nhiên, nếu bé nôn quá nhiều kèm bỏ ăn hoặc mệt mỏi, hãy đưa đi khám ngay.

    Q: Chó ăn phải sô cô la (chocolate) có sao không?
    A: CẢNH BÁO: Sô cô la rất độc đối với chó, có thể gây co giật và tử vong! Hãy đưa bé đến thú y ngay lập tức để gây nôn hoặc rửa ruột. Đừng tự xử lý tại nhà nếu không có hướng dẫn của bác sĩ.

    Q: Lịch tẩy giun cho thú cưng thế nào?
    A: Với thú non (dưới 6 tháng), nên tẩy giun mỗi tháng 1 lần. Với thú trưởng thành (trên 6 tháng), nên tẩy giun định kỳ 3-6 tháng/lần tùy môi trường sống.

    Q: Mèo đi vệ sinh không đúng chỗ?
    A: Có thể do khay cát bị bẩn, thay đổi loại cát, hoặc bé đang bị stress/viêm đường tiết niệu. Hãy thử làm sạch khay cát và quan sát. Nếu bé đi tiểu rắt hoặc kêu đau, cần đi khám bác sĩ.

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
            String errorMsg = resp.toString();
            LOGGER.log(Level.WARNING, "API Error (" + status + "): " + errorMsg);
            if (status == 404) {
                return "Lỗi 404: API Key hoặc Model sai.";
            }
            if (status == 429) {
                return "Hệ thống quá tải, thử lại sau.";
            }
            return "Lỗi kết nối AI (" + status + ").";
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
