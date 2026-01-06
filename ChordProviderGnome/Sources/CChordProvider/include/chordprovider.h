#pragma once

#include <gtk/gtk.h>
#include <cairo.h>

G_BEGIN_DECLS

/* Theme */
gboolean app_prefers_dark_theme(void);

/* GTK draw callbacks */
void draw_chord(
    GtkDrawingArea *area,
    cairo_t *cr,
    int width,
    int height,
    gpointer user_data
);

void draw_arrow(
    GtkDrawingArea *area,
    cairo_t *cr,
    int width,
    int height,
    gpointer user_data
);

#define MAX_STRINGS 6
#define MAX_BARRES  5

/* Swift draw callbacks */
void draw_chord_swift(
    cairo_t *cr,
    int width,
    int height,
    gpointer user_data,
    gboolean dark_mode
);

void draw_arrow_swift(
    cairo_t *cr,
    int width,
    int height,
    gpointer user_data,
    gboolean dark_mode
);

/* Data structures */

typedef struct {
    bool down;
    bool dash;
    int  length;
} cstrum;

typedef struct {
    int finger;
    int fret;
    int start;
    int end;
} cbarre;

typedef struct {
    int strings;
    int base_fret;
    int frets[MAX_STRINGS];
    int fingers[MAX_STRINGS];
    cbarre barres[MAX_BARRES];
    char *notes[MAX_STRINGS];
    bool show_notes;
} cchord;

/* Lifecycle */
cchord *cchord_new(int strings);
void    cchord_free(cchord *c);

/* Properties */
void cchord_set_strings(cchord *c, int strings);
int  cchord_get_strings(const cchord *c);

void cchord_set_base_fret(cchord *c, int base_fret);
int  cchord_get_base_fret(const cchord *c);

void cchord_set_show_notes(cchord *c, bool show);
bool cchord_get_show_notes(const cchord *c);

/* Frets & fingers */
void cchord_set_fret(cchord *c, int string, int fret);
int  cchord_get_fret(const cchord *c, int string);

void cchord_set_finger(cchord *c, int string, int finger);
int  cchord_get_finger(const cchord *c, int string);

/* Barres */
void   cchord_set_barre(cchord *c, int index, int finger, int fret, int start, int end);
void   cchord_clear_barre(cchord *c, int index);
cbarre cchord_get_barre(const cchord *c, int index);

/* Notes */
void        cchord_set_note(cchord *c, int string, const char *note);
const char *cchord_get_note(const cchord *c, int string);

G_END_DECLS
