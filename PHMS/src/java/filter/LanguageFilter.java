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

/**
 * Exposes the current language to all requests so every JSP can use ${L}.
 */
@WebFilter(filterName = "LanguageFilter", urlPatterns = {"/*"})
public class LanguageFilter implements Filter {

    private static final String DEFAULT_LANG = "vi";

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // No-op
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        // Ensure all request parameters are decoded as UTF-8
        request.setCharacterEncoding("UTF-8");

        if (request instanceof HttpServletRequest) {
            HttpServletRequest httpRequest = (HttpServletRequest) request;
            HttpSession session = httpRequest.getSession();

            Object rawLang = session.getAttribute("lang");
            String lang = rawLang == null ? DEFAULT_LANG : rawLang.toString().toLowerCase();
            if (!"vi".equals(lang) && !"en".equals(lang)) {
                lang = DEFAULT_LANG;
            }

            session.setAttribute("lang", lang);
            request.setAttribute("L", lang);
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // No-op
    }
}
