package com.music.musicsystem.common.constant;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class ProductTypeTest {
    @Test
    void recognizesSupportedProductTypesWithoutCaseSensitivity() {
        assertTrue(ProductType.isPhysical("physical"));
        assertTrue(ProductType.isDigital("DIGITAL"));
        assertFalse(ProductType.isPhysical("DIGITAL"));
        assertFalse(ProductType.isDigital(null));
    }
}
