package com.music.musicsystem.controller;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class AdminMediaControllerTest {
    private final AdminMediaController controller = new AdminMediaController();

    @Test
    void acceptsKnownImageAndAudioSignatures() {
        assertTrue(controller.hasExpectedSignature(new byte[]{(byte) 0x89, 0x50, 0x4e, 0x47,
                0x0d, 0x0a, 0x1a, 0x0a}, "png"));
        assertTrue(controller.hasExpectedSignature(new byte[]{'I', 'D', '3'}, "mp3"));
    }

    @Test
    void rejectsExtensionContentMismatch() {
        assertFalse(controller.hasExpectedSignature(new byte[]{'I', 'D', '3'}, "png"));
        assertFalse(controller.hasExpectedSignature(new byte[]{'R', 'I', 'F', 'F', 0, 0, 0, 0,
                'W', 'A', 'V', 'E'}, "webp"));
    }
}
