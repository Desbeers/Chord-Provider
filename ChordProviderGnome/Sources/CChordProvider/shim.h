#include <gtk/gtk.h>
#include <cairo.h>

#define NUM_STRINGS 6
#define NUM_FRETS 5

struct ChordInC {
    int strings;
    int frets[6];
};
typedef struct ChordInC ChordInC;

static void
draw_chord(GtkDrawingArea *area, cairo_t *cr, int width, int height, gpointer user_data)
{
    ChordInC *data = user_data;

    // printf(data->frets[0]);

    int margin = 20;
    double fret_spacing = (height - 2 * margin) / (double)NUM_FRETS;
    double string_spacing = (width - 2 * margin) / (double)(data->strings - 1);

    // Draw strings
    cairo_set_source_rgb(cr, 0, 0, 0);
    cairo_set_line_width(cr, 0.5);
    for (int i = 0; i < data->strings; ++i) {
        double x = margin + i * string_spacing;
        cairo_move_to(cr, x, margin);
        cairo_line_to(cr, x, height - margin);
    }
    cairo_stroke(cr);

    // Draw frets
    cairo_set_line_width(cr, 1);
    for (int i = 0; i <= NUM_FRETS; ++i) {
        double y = margin + i * fret_spacing;
        cairo_move_to(cr, margin, y);
        cairo_line_to(cr, width - margin, y);
    }
    cairo_stroke(cr);

    // Draw finger positions
    for (int i = 0; i < data->strings; ++i) {
        double x = margin + i * string_spacing;
        if (data->frets[i] == -1) {
            // Muted string: draw X
            cairo_set_source_rgb(cr, 0.552, 0.551, 0.551);
            cairo_move_to(cr, x-6, margin-12);
            cairo_line_to(cr, x+6, margin-2);
            cairo_move_to(cr, x+6, margin-12);
            cairo_line_to(cr, x-6, margin-2);
            cairo_set_line_width(cr, 1);
            cairo_stroke(cr);
        } else if (data->frets[i] == 0) {
            // Open string: draw open circle
            cairo_set_source_rgb(cr, 0.552, 0.551, 0.551);
            cairo_arc(cr, x, margin-7, 6, 0, 2 * G_PI);
            cairo_set_line_width(cr, 1);
            cairo_stroke(cr);
        } else if (data->frets[i] > 0) {
            // Finger position: draw filled circle
            double y = margin + data->frets[i] * fret_spacing - fret_spacing / 2;
            cairo_set_source_rgb(cr, 0.552, 0.551, 0.551);
            cairo_arc(cr, x, y, 8, 0, 2 * G_PI);
            cairo_fill(cr);
        }
    }
}
