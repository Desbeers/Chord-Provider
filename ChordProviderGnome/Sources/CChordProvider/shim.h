#include <gtk/gtk.h>

struct cbarre {
    /// The finger for the barre
    int finger;
    /// the fret for the barre
    int fret;
    /// The first string to barre
    int start_index;
    /// The last string to barre
    int end_index;
};
typedef struct cbarre cbarre;

struct cnote {
    /// The note of the string
    char * note
};
typedef struct cnote cnote;

struct cchord {
    int strings;
    int base_fret;
    int frets[6];
    int fingers[6];
    cbarre barre[5];
    cnote note[6];
    bool show_notes;
};
typedef struct cchord cchord;

struct cstrum {
    bool down;
    bool dash;
    int length;
};
typedef struct cstrum cstrum;

// Returns TRUE if the application prefers dark theme, FALSE otherwise
static gboolean
app_prefers_dark_theme(void) {
    GtkSettings *settings = gtk_settings_get_default();
    gboolean prefers_dark = FALSE;
    g_object_get(settings, "gtk-application-prefer-dark-theme", &prefers_dark, NULL);
    return prefers_dark;
}

extern void draw_chord_swift(cairo_t *cr, int width, int height, gpointer user_data, gboolean dark_mode);

static void
draw_chord(GtkDrawingArea *area, cairo_t *cr, int width, int height, gpointer user_data)
{
    draw_chord_swift(cr, width, height, user_data, app_prefers_dark_theme());
}

extern void draw_arrow_swift(cairo_t *cr, int width, int height, gpointer user_data, gboolean dark_mode);

static void
draw_arrow(GtkDrawingArea *area, cairo_t *cr, int width, int height, gpointer user_data)
{
    draw_arrow_swift(cr, width, height, user_data, app_prefers_dark_theme());
}
