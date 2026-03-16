package filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Locale;

/**
 * Language Filter
 * Intercepts every request and sets the locale in session for JSTL fmt tags.
 *
 * How it works:
 *  - Reads "language" from session (default: "vi")
 *  - If request has ?lang=en or ?lang=vi, updates session
 *  - Sets jakarta.servlet.jsp.jstl.fmt.locale.session so JSTL <fmt:message> works
 *  - Sets request attribute "currentLanguage" for use in JSP conditionals
 */
@WebFilter(filterName = "LanguageFilter", urlPatterns = {"/*"})
public class LanguageFilter implements Filter {

    public static final String DEFAULT_LANGUAGE = "vi";
    public static final String SESSION_LANG_KEY = "language";
    // JSTL Config key for locale stored in session
    private static final String JSTL_LOCALE_KEY = "jakarta.servlet.jsp.jstl.fmt.locale.session";

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpSession session = httpRequest.getSession(true);

        // Check if language switch is requested
        String langParam = httpRequest.getParameter("lang");
        if (langParam != null && (langParam.equals("vi") || langParam.equals("en"))) {
            session.setAttribute(SESSION_LANG_KEY, langParam);
        }

        // Get current language (default to Vietnamese)
        String lang = (String) session.getAttribute(SESSION_LANG_KEY);
        if (lang == null) {
            lang = DEFAULT_LANGUAGE;
            session.setAttribute(SESSION_LANG_KEY, lang);
        }

        // Set JSTL locale in session so <fmt:message> picks it up automatically
        Locale locale = new Locale(lang);
        session.setAttribute(JSTL_LOCALE_KEY, locale);

        // Expose to JSP as request attribute for conditionals / switcher UI
        httpRequest.setAttribute("currentLanguage", lang);
        httpRequest.setAttribute("isVietnamese", "vi".equals(lang));

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}
