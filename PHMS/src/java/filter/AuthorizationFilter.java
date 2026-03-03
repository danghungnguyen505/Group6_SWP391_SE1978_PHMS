<<<<<<< Updated upstream
package filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

/**
 * Authorization Filter
 * Checks user role and blocks unauthorized access
 */
@WebFilter(filterName = "AuthorizationFilter", urlPatterns = {
    "/admin/*",
    "/veterinarian/*",
    "/nurse/*",
    "/receptionist/*",
    "/pet/*",
    "/myPetOwner",
    "/myAppointment",
    "/my-medical-records",
    "/my-medical-records/*",
    "/appointment-action",
    "/booking",
    "/save-appointment",
    "/profile",
    "/change-password"
})
public class AuthorizationFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization if needed
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());
        
        // Allow access to login and register pages
        if (path.equals("/login") || path.equals("/register") || path.equals("/forgot-password")) {
            chain.doFilter(request, response);
            return;
        }
        
        // Check if user is logged in
        if (session == null || session.getAttribute("account") == null) {
            httpResponse.sendRedirect(contextPath + "/login");
            return;
        }
        
        User account = (User) session.getAttribute("account");
        String role = account.getRole();
        
        // Role-based authorization
        if (path.startsWith("/admin/")) {
            if (!"ClinicManager".equalsIgnoreCase(role) && !"Admin".equalsIgnoreCase(role)) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied. Admin role required.");
                return;
            }
        } else if (path.startsWith("/veterinarian/")) {
            if (!"Veterinarian".equalsIgnoreCase(role)) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied. Veterinarian role required.");
                return;
            }
        } else if (path.startsWith("/nurse/")) {
            if (!"Nurse".equalsIgnoreCase(role)) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied. Nurse role required.");
                return;
            }
        } else if (path.startsWith("/receptionist/")) {
            if (!"Receptionist".equalsIgnoreCase(role)) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied. Receptionist role required.");
                return;
            }
        } else if (path.startsWith("/pet/") || path.equals("/myPetOwner") 
                || path.equals("/myAppointment") || path.startsWith("/my-medical-records")
                || path.equals("/appointment-action") || path.equals("/booking")
                || path.equals("/save-appointment")) {
            // PetOwner only features
            if (!"PetOwner".equalsIgnoreCase(role)) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied. PetOwner role required.");
                return;
            }
        }
        
        // Continue with the request
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        // Cleanup if needed
    }
}
=======
package filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

/**
 * Authorization Filter
 * Checks user role and blocks unauthorized access
 */
@WebFilter(filterName = "AuthorizationFilter", urlPatterns = {
    "/admin/*",
    "/veterinarian/*",
    "/nurse/*",
    "/receptionist/*",
    "/pet/*",
    "/myPetOwner",
    "/myAppointment",
    "/my-medical-records",
    "/my-medical-records/*",
    "/appointment-action",
    "/booking",
    "/save-appointment",
    "/profile",
    "/change-password"
})
public class AuthorizationFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization if needed
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());
        
        // Allow access to login and register pages
        if (path.equals("/login") || path.equals("/register") || path.equals("/forgot-password")) {
            chain.doFilter(request, response);
            return;
        }
        
        // Check if user is logged in
        if (session == null || session.getAttribute("account") == null) {
            httpResponse.sendRedirect(contextPath + "/login");
            return;
        }
        
        User account = (User) session.getAttribute("account");
        String role = account.getRole();
        
        // Role-based authorization
        if (path.startsWith("/admin/")) {
            if (!"ClinicManager".equalsIgnoreCase(role) && !"Admin".equalsIgnoreCase(role)) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied. Admin role required.");
                return;
            }
        } else if (path.startsWith("/veterinarian/")) {
            if (!"Veterinarian".equalsIgnoreCase(role)) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied. Veterinarian role required.");
                return;
            }
        } else if (path.startsWith("/nurse/")) {
            if (!"Nurse".equalsIgnoreCase(role)) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied. Nurse role required.");
                return;
            }
        } else if (path.startsWith("/receptionist/")) {
            if (!"Receptionist".equalsIgnoreCase(role)) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied. Receptionist role required.");
                return;
            }
        } else if (path.startsWith("/pet/") || path.equals("/myPetOwner") 
                || path.equals("/myAppointment") || path.startsWith("/my-medical-records")
                || path.equals("/appointment-action") || path.equals("/booking")
                || path.equals("/save-appointment")) {
            // PetOwner only features
            if (!"PetOwner".equalsIgnoreCase(role)) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied. PetOwner role required.");
                return;
            }
        }
        
        // Continue with the request
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        // Cleanup if needed
    }
}
>>>>>>> Stashed changes
