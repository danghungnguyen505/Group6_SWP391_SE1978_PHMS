package util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.util.Locale;
import java.util.MissingResourceException;
import java.util.ResourceBundle;

/**
 * I18n Helper Utility
 * Provides easy access to translated messages in JSP and Servlets
 *
 * Usage in JSP:
 *  <%@ taglib prefix="i18n" uri="/WEB-INF/tlds/i18n.tld" %>
 *  OR simply use:
 *  ${i18n:get('common.login')}
 *
 * Usage in Servlet:
 *  String loginText = I18nUtil.get(request, "common.login");
 */
public class I18nUtil {

    private static final String BASE_NAME = "util.messages";
    private static final String DEFAULT_LANG = "vi";

    /**
     * Get translated message by key
     * @param request HTTP request
     * @param key message key (e.g., "common.login")
     * @return translated message or key if not found
     */
    public static String get(HttpServletRequest request, String key) {
        return get(request, key, key);
    }

    /**
     * Get translated message with default fallback
     * @param request HTTP request
     * @param key message key
     * @param defaultValue fallback message if key not found
     * @return translated message or defaultValue
     */
    public static String get(HttpServletRequest request, String key, String defaultValue) {
        String lang = getCurrentLanguage(request);
        return getMessage(key, defaultValue, lang);
    }

    /**
     * Get translated message for specific language
     * @param key message key
     * @param lang language code ("vi" or "en")
     * @return translated message or key
     */
    public static String get(String key, String lang) {
        return getMessage(key, key, lang);
    }

    /**
     * Get current language from session
     */
    public static String getCurrentLanguage(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            String lang = (String) session.getAttribute("language");
            if (lang != null) {
                return lang;
            }
        }
        // Check request parameter
        String langParam = request.getParameter("lang");
        if (langParam != null && (langParam.equals("vi") || langParam.equals("en"))) {
            return langParam;
        }
        return DEFAULT_LANG;
    }

    /**
     * Get message from resource bundle
     */
    private static String getMessage(String key, String defaultValue, String lang) {
        try {
            Locale locale = new Locale(lang);
            ResourceBundle bundle = ResourceBundle.getBundle(BASE_NAME, locale);
            return bundle.getString(key);
        } catch (MissingResourceException e) {
            // Try default language
            if (!DEFAULT_LANG.equals(lang)) {
                try {
                    ResourceBundle defaultBundle = ResourceBundle.getBundle(BASE_NAME, new Locale(DEFAULT_LANG));
                    return defaultBundle.getString(key);
                } catch (MissingResourceException ex) {
                    return defaultValue;
                }
            }
            return defaultValue;
        }
    }

    /**
     * Check if current language is Vietnamese
     */
    public static boolean isVietnamese(HttpServletRequest request) {
        return "vi".equals(getCurrentLanguage(request));
    }

    /**
     * Check if current language is English
     */
    public static boolean isEnglish(HttpServletRequest request) {
        return "en".equals(getCurrentLanguage(request));
    }
}
