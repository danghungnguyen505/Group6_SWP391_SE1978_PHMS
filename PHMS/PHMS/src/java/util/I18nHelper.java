package util;

import jakarta.servlet.jsp.JspException;
import jakarta.servlet.jsp.JspWriter;
import jakarta.servlet.jsp.tagext.TagSupport;
import java.io.IOException;
import java.util.ResourceBundle;
import java.util.Locale;

/**
 * Custom JSP Tag for i18n
 *
 * Usage in JSP:
 *  <%@ taglib prefix="i18n" uri="http://PHMS.com/tags/i18n" %>
 *  <i18n:message key="common.login" />
 *
 * Or use the getTag:
 *  ${i18n:get('common.login')}
 */
public class I18nHelper extends TagSupport {

    private String key;
    private String defaultValue;

    public void setKey(String key) {
        this.key = key;
    }

    public void setDefaultValue(String defaultValue) {
        this.defaultValue = defaultValue;
    }

    @Override
    public int doStartTag() throws JspException {
        try {
            String message = getMessage(key, defaultValue);
            JspWriter out = pageContext.getOut();
            out.print(message);
        } catch (IOException e) {
            throw new JspException(e);
        }
        return SKIP_BODY;
    }

    @Override
    public int doEndTag() throws JspException {
        return EVAL_PAGE;
    }

    private String getMessage(String key, String defaultValue) {
        try {
            // Get language from session attribute
            jakarta.servlet.http.HttpSession session = pageContext.getSession();
            String lang = (String) session.getAttribute("language");
            if (lang == null) {
                lang = "vi";
            }

            Locale locale = new Locale(lang);
            ResourceBundle bundle = ResourceBundle.getBundle("util.messages", locale);
            return bundle.getString(key);
        } catch (Exception e) {
            return defaultValue != null ? defaultValue : key;
        }
    }
}
