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

struct cchord {
    int strings;
    int base_fret;
    int frets[6];
    int fingers[6];
    cbarre barre[5];
};
typedef struct cchord cchord;

extern void draw_chord_swift(cairo_t *cr, int width, int height, gpointer user_data, gboolean dark_mode);

static void
draw_chord(GtkDrawingArea *area, cairo_t *cr, int width, int height, gpointer user_data)
{


    cchord *data = user_data;
    // Set light or dark mode
    GtkSettings *settings = gtk_settings_get_default();
    gboolean is_dark_mode = FALSE;
    g_object_get(G_OBJECT(settings), "gtk-application-prefer-dark-theme",
                 &is_dark_mode, NULL);

    draw_chord_swift(cr, width, height, user_data, is_dark_mode);

}
