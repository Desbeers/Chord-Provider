//
//  shim.h
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

#include <gtk/gtk.h>
#include "diagram.h"
#include "strum.h"

// Returns TRUE if the application prefers dark theme, FALSE otherwise
static gboolean
app_prefers_dark_theme(void) {
    GtkSettings *settings = gtk_settings_get_default();
    gboolean prefers_dark = FALSE;
    g_object_get(settings, "gtk-application-prefer-dark-theme", &prefers_dark, NULL);
    return prefers_dark;
}

/* Draw function for chord */

static void
draw_chord(
           GtkDrawingArea *area,
           cairo_t *cr,
           int width,
           int height,
           gpointer user_data
           ) {
    draw_chord_swift(cr, width, height, user_data, app_prefers_dark_theme());
}

/* Draw function for arrow */

static void
draw_arrow(
           GtkDrawingArea *area,
           cairo_t *cr,
           int width,
           int height,
           gpointer user_data
           ) {
    draw_arrow_swift(cr, width, height, user_data, app_prefers_dark_theme());
}
