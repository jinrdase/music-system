package com.music.musicsystem.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.music.musicsystem.common.exception.BusinessException;
import com.music.musicsystem.entity.AdminAuditLog;
import com.music.musicsystem.service.AdminAuditLogService;
import jakarta.servlet.http.HttpServletRequest;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.mock.web.MockHttpServletRequest;

import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class AdminAuditLogControllerTest {
    @Mock
    private AdminAuditLogService auditLogService;

    @InjectMocks
    private AdminAuditLogController controller;

    @Test
    void rejectsNonAdminAndInvalidTimeRangeBeforeQuerying() {
        MockHttpServletRequest request = new MockHttpServletRequest();
        request.setAttribute("role", "user");
        assertThrows(BusinessException.class, () -> controller.list(1, 20, null,
                null, null, null, null, request));

        request.setAttribute("role", "admin");
        LocalDateTime from = LocalDateTime.parse("2026-11-02T00:00:00");
        LocalDateTime to = from.minusDays(1);
        assertThrows(BusinessException.class, () -> controller.list(1, 20, null,
                null, null, from, to, request));
        verifyNoInteractions(auditLogService);
    }

    @Test
    void permitsAdminAndPassesDateAndSearchFiltersToService() {
        HttpServletRequest request = new MockHttpServletRequest();
        request.setAttribute("role", "super_admin");
        LocalDateTime from = LocalDateTime.parse("2026-11-01T00:00:00");
        LocalDateTime to = LocalDateTime.parse("2026-11-01T23:59:59");
        Page<AdminAuditLog> page = new Page<>(2, 10, 0);
        when(auditLogService.search(2, 10, 99L, "POST", "/api/admin/albums", from, to))
                .thenReturn(page);

        var result = controller.list(2, 10, 99L, "POST", "/api/admin/albums",
                from, to, request);

        assertEquals(200, result.getCode());
        assertEquals(page, result.getData());
        verify(auditLogService).search(2, 10, 99L, "POST", "/api/admin/albums", from, to);
    }
}
