package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Language Controller
 * Handles language switching via POST or GET requests.
 *
 * URL: /language
 *
 * Parameters:
 *  - lang: "vi" or "en"
 *  - redirect: optional URL to redirect after switching (default: referer or home)
 *
 * Usage in JSP:
 *  - Form: <form action="${pageContext.contextPath}/language" method="post">
 *            <input type="hidden" name="lang" value="en">
 *            <button type="submit">English</button>
 *          </form>
 *  - Link: <a href="${pageContext.contextPath}/language?lang=en">English</a>
 */
@WebServlet(name = "LanguageController", urlPatterns = {"/language"})
public class LanguageController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleRequest(request, response);
    }

    private void handleRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Get the language parameter
        String lang = request.getParameter("lang");

        // Validate language
        if (lang != null && (lang.equals("vi") || lang.equals("en"))) {
            session.setAttribute("language", lang);
            // Also set JSTL locale
            session.setAttribute("jakarta.servlet.jsp.jstl.fmt.locale.session", new java.util.Locale(lang));
        }

        // Get the redirect URL (prevent open redirect vulnerability)
        String redirectUrl = request.getParameter("redirect");

        if (redirectUrl != null && !redirectUrl.isEmpty()) {
            // Only allow relative redirects to prevent open redirect attacks
            if (redirectUrl.startsWith("/") && !redirectUrl.startsWith("//")
                    && !redirectUrl.toLowerCase().startsWith("http")) {
                response.sendRedirect(request.getContextPath() + redirectUrl);
            } else {
                // Default to home if redirect is suspicious
                response.sendRedirect(request.getContextPath() + "/home");
            }
        } else {
            // Default: redirect back to the previous page (referer)
            String referer = request.getHeader("Referer");
            if (referer != null && referer.contains(request.getContextPath())) {
                response.sendRedirect(referer);
            } else {
                response.sendRedirect(request.getContextPath() + "/home");
            }
        }
    }

    /**
     * Utility method to get current language from session
     */
    public static String getCurrentLanguage(HttpSession session) {
        String lang = (String) session.getAttribute("language");
        return (lang != null) ? lang : "vi";
    }

    /**
     * Utility method to check if current language is Vietnamese
     */
    public static boolean isVietnamese(HttpSession session) {
        return "vi".equals(getCurrentLanguage(session));
    }
}
