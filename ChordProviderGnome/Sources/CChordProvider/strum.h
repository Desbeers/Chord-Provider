//
//  diagram.h
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

/* Structures */

struct cstrum {
    bool down;
    bool dash;
    int length;
};

typedef struct cstrum cstrum;

/* Swift bridge */

extern void
draw_arrow_swift(cairo_t *cr, int width, int height, gpointer user_data, gboolean dark_mode);
