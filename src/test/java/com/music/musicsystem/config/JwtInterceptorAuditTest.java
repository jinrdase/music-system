package com.music.musicsystem.config;

import com.music.musicsystem.service.AdminAuditLogService;
import jakarta.servlet.http.HttpServletResponse;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;

import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;

@ExtendWith(MockitoExtension.class)
class JwtInterceptorAuditTest {
    @Mock
    private AdminAuditLogService auditLogService;

    @InjectMocks
    private JwtInterceptor interceptor;

    @Test
    void recordsAdminShipmentAndRefundReviewOutsideAdminPrefix() {
        record("/api/order/ship/ORD-QA", "admin");
        verify(auditLogService).record(42L, "admin", "PUT",
                "/api/order/ship/ORD-QA", HttpServletResponse.SC_OK, "127.0.0.1");

        record("/api/refund/admin/7/review", "super_admin");
        verify(auditLogService).record(42L, "super_admin", "PUT",
                "/api/refund/admin/7/review", HttpServletResponse.SC_OK, "127.0.0.1");
    }

    @Test
    void doesNotRecordAuditQueriesOrNonAdminRequests() {
        record("/api/admin/audit-logs", "admin");
        record("/api/order/ship/ORD-QA", "user");
        verifyNoInteractions(auditLogService);
    }

    private void record(String path, String role) {
        MockHttpServletRequest request = new MockHttpServletRequest("PUT", path);
        request.setRemoteAddr("127.0.0.1");
        request.setAttribute("userId", 42L);
        request.setAttribute("role", role);
        MockHttpServletResponse response = new MockHttpServletResponse();
        interceptor.afterCompletion(request, response, new Object(), null);
    }
}
