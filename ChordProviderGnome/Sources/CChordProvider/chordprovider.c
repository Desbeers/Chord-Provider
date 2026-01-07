#include "chordprovider.h"

#include <stdlib.h>
#include <string.h>

/* ============================================================
   GTK helpers
   ============================================================ */

#include <gtk/gtk.h>

void
add_css_from_string(const char *css)
{
    static GtkCssProvider *current_provider = NULL;

    if (css == NULL) {
        return;
    }

    // Remove old provider if exists
    if (current_provider) {
        GdkDisplay *display = gdk_display_get_default();
        if (display) {
            gtk_style_context_remove_provider_for_display(
                display,
                GTK_STYLE_PROVIDER(current_provider)
            );
        }
        g_object_unref(current_provider);
        current_provider = NULL;
    }

    // Create new provider
    GtkCssProvider *provider = gtk_css_provider_new();
    gtk_css_provider_load_from_string(provider, css);

    // Attach to default display
    GdkDisplay *display = gdk_display_get_default();
    if (display) {
        gtk_style_context_add_provider_for_display(
            display,
            GTK_STYLE_PROVIDER(provider),
            GTK_STYLE_PROVIDER_PRIORITY_APPLICATION
        );
    }

    // Keep provider for next call
    current_provider = provider;
}

void
set_style(stylestate *state)
{
    GtkSettings *settings = gtk_settings_get_default();

    // Initial sync
    update_style(
        G_OBJECT(settings),
        NULL,
        state
    );

    // Listen for changes
    g_signal_connect(
        settings,
        "notify::gtk-application-prefer-dark-theme",
        G_CALLBACK(update_style),
        state
    );
}


gboolean
app_prefers_dark_theme(void) {
    GtkSettings *settings = gtk_settings_get_default();
    gboolean prefers_dark = FALSE;

    if (settings) {
        g_object_get(
            settings,
            "gtk-application-prefer-dark-theme",
            &prefers_dark,
            NULL
        );
    }

    return prefers_dark;
}

/* ============================================================
   Drawing callbacks
   ============================================================ */

void
draw_chord(GtkDrawingArea *area,
           cairo_t *cr,
           int width,
           int height,
           gpointer user_data) {
    draw_chord_swift(
        cr,
        width,
        height,
        user_data,
        app_prefers_dark_theme()
    );
}

void
draw_arrow(GtkDrawingArea *area,
           cairo_t *cr,
           int width,
           int height,
           gpointer user_data) {
    draw_arrow_swift(
        cr,
        width,
        height,
        user_data,
        app_prefers_dark_theme()
    );
}

/* ============================================================
   Chord lifecycle
   ============================================================ */

cchord *
cchord_new(int strings) {
    if (strings <= 0 || strings > MAX_STRINGS)
        strings = MAX_STRINGS;

    cchord *c = calloc(1, sizeof *c);
    if (!c)
        return NULL;

    c->strings = strings;
    c->base_fret = 1;
    c->show_notes = false;

    return c;
}

void
cchord_free(cchord *c) {
    if (!c)
        return;

    for (int i = 0; i < MAX_STRINGS; i++) {
        free(c->notes[i]);
        c->notes[i] = NULL;
    }

    free(c);
}

/* ============================================================
   Properties
   ============================================================ */

void
cchord_set_strings(cchord *c, int strings) {
    if (!c)
        return;

    if (strings <= 0 || strings > MAX_STRINGS)
        strings = MAX_STRINGS;

    c->strings = strings;
}

int
cchord_get_strings(const cchord *c) {
    return c ? c->strings : 0;
}

void
cchord_set_base_fret(cchord *c, int base_fret) {
    if (!c)
        return;

    c->base_fret = base_fret;
}

int
cchord_get_base_fret(const cchord *c) {
    return c ? c->base_fret : 0;
}

void
cchord_set_show_notes(cchord *c, bool show) {
    if (!c)
        return;

    c->show_notes = show;
}

bool
cchord_get_show_notes(const cchord *c) {
    return c ? c->show_notes : false;
}

/* ============================================================
   Frets & fingers
   ============================================================ */

void
cchord_set_fret(cchord *c, int string, int fret) {
    if (!c || string < 0 || string >= c->strings)
        return;

    c->frets[string] = fret;
}

int
cchord_get_fret(const cchord *c, int string) {
    if (!c || string < 0 || string >= c->strings)
        return 0;

    return c->frets[string];
}

void
cchord_set_finger(cchord *c, int string, int finger) {
    if (!c || string < 0 || string >= c->strings)
        return;

    c->fingers[string] = finger;
}

int
cchord_get_finger(const cchord *c, int string) {
    if (!c || string < 0 || string >= c->strings)
        return 0;

    return c->fingers[string];
}

/* ============================================================
   Barre
   ============================================================ */

void
cchord_set_barre(cchord *c,
                 int index,
                 int finger,
                 int fret,
                 int start_string,
                 int end_string) {
    if (!c || index < 0 || index >= MAX_BARRES)
        return;

    c->barres[index].finger = finger;
    c->barres[index].fret   = fret;
    c->barres[index].start  = start_string;
    c->barres[index].end    = end_string;
}

void
cchord_clear_barre(cchord *c, int index) {
    if (!c || index < 0 || index >= MAX_BARRES)
        return;

    memset(&c->barres[index], 0, sizeof(cbarre));
}

cbarre
cchord_get_barre(const cchord *c, int index) {
    cbarre empty = {0};

    if (!c || index < 0 || index >= MAX_BARRES)
        return empty;

    return c->barres[index];
}

/* ============================================================
   Notes
   ============================================================ */

void
cchord_set_note(cchord *c, int string, const char *note) {
    if (!c || string < 0 || string >= c->strings)
        return;

    free(c->notes[string]);
    c->notes[string] = note ? strdup(note) : NULL;
}

const char *
cchord_get_note(const cchord *c, int string) {
    if (!c || string < 0 || string >= c->strings)
        return NULL;

    return c->notes[string];
}
