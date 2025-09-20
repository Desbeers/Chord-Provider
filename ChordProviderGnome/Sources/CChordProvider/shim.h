#include <gtk/gtk.h>

#define NUM_STRINGS 6
#define NUM_FRETS 5

struct cchord {
    int strings;
    int base_fret;
    int frets[6];
    int fingers[6];
};
typedef struct cchord cchord;



static void
draw_chord(GtkDrawingArea *area, cairo_t *cr, int width, int height, gpointer user_data)
{
    cchord *data = user_data;

    char finger[3];

    int margin = 20;
    double fret_spacing = (height - 2 * margin) / (double)NUM_FRETS;
    double string_spacing = (width - 2 * margin) / (double)(data->strings - 1);

    cairo_select_font_face(cr, "monospace",
          CAIRO_FONT_SLANT_NORMAL,
          CAIRO_FONT_WEIGHT_NORMAL);

      cairo_set_font_size(cr, 9);

    // Draw strings
    cairo_set_source_rgb(cr, 0, 0, 0);
    cairo_set_line_width(cr, 0.2);
    for (int i = 0; i < data->strings; ++i) {
        double x = margin + i * string_spacing;
        cairo_move_to(cr, x, margin);
        cairo_line_to(cr, x, height - margin);
    }
    cairo_stroke(cr);

    // Draw top bar or base fret
    if (data->base_fret == 1) {
        cairo_set_source_rgb(cr, 0, 0, 0);
        cairo_set_line_width(cr, 2);
        cairo_move_to(cr, margin - 1, margin);
        cairo_line_to(cr, width - margin + 1, margin);
        cairo_stroke(cr);
        cairo_set_line_width(cr, 0.2);
    } else {
        cairo_set_source_rgb(cr, 0, 0, 0);
        cairo_move_to(cr, margin - 15, margin + fret_spacing / 1.5);
        sprintf(finger, "%d", data->base_fret);
        cairo_show_text(cr, finger);
    }

    // Draw frets
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
            cairo_move_to(cr, x-3, margin-11);
            cairo_line_to(cr, x+3, margin-5);
            cairo_move_to(cr, x+3, margin-11);
            cairo_line_to(cr, x-3, margin-5);
            cairo_set_line_width(cr, 1);
            cairo_stroke(cr);
        } else if (data->frets[i] == 0) {
            // Open string: draw open circle
            cairo_set_source_rgb(cr, 0.552, 0.551, 0.551);
            cairo_arc(cr, x, margin-8, 3, 0, 2 * G_PI);
            cairo_set_line_width(cr, 1);
            cairo_stroke(cr);
        } else if (data->frets[i] > 0) {
            // Finger position: draw filled circle
            double y = margin + data->frets[i] * fret_spacing - fret_spacing / 2;
            cairo_set_source_rgb(cr, 0.552, 0.551, 0.551);
            cairo_arc(cr, x, y, 6, 0, 2 * G_PI);
            cairo_fill(cr);
            if (data->fingers[i] > 0) {
                sprintf(finger, "%d", data->fingers[i]);
                cairo_move_to(cr, x - 2.5, y + 3);
                cairo_set_source_rgb(cr, 1, 1, 1);
                cairo_show_text(cr, finger);
                cairo_new_path(cr);
            }
        }
    }
}
