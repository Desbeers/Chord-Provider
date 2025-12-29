#include <gtk/gtk.h>
#include <gtksourceview/gtksource.h>
#include "editor.h"

#define MIN_CHARS_AFTER_BRACE 2

static void update_theme_on_settings_change(GObject *settings,
                                            GParamSpec *pspec,
                                            gpointer user_data) {
  GtkSourceBuffer *source_buffer = GTK_SOURCE_BUFFER(user_data);
  g_assert_nonnull(source_buffer);

  gboolean is_dark_mode = FALSE;
  g_object_get(G_OBJECT(settings), "gtk-application-prefer-dark-theme",
               &is_dark_mode, NULL);

  const char *theme_name = is_dark_mode ? "Adwaita-dark" : "Adwaita";

  GtkSourceStyleSchemeManager *scheme_manager =
      gtk_source_style_scheme_manager_get_default();
  GtkSourceStyleScheme *style_scheme =
      gtk_source_style_scheme_manager_get_scheme(scheme_manager, theme_name);
  gtk_source_buffer_set_style_scheme(source_buffer, style_scheme);
}

static void codeeditor_buffer_set_theme_adaptive(GtkSourceBuffer *buffer) {
  GtkSourceBuffer *source_buffer = GTK_SOURCE_BUFFER(buffer);

  GtkSettings *settings = gtk_settings_get_default();
  gboolean is_dark_mode = FALSE;
  g_object_get(G_OBJECT(settings), "gtk-application-prefer-dark-theme",
               &is_dark_mode, NULL);

  const char *theme_name = is_dark_mode ? "Adwaita-dark" : "Adwaita";

  GtkSourceStyleSchemeManager *scheme_manager =
      gtk_source_style_scheme_manager_get_default();
  GtkSourceStyleScheme *style_scheme =
      gtk_source_style_scheme_manager_get_scheme(scheme_manager, theme_name);
  gtk_source_buffer_set_style_scheme(source_buffer, style_scheme);

  g_signal_connect(settings, "notify::gtk-application-prefer-dark-theme",
                   G_CALLBACK(update_theme_on_settings_change), source_buffer);
}

static void print_language_id(gpointer data, gpointer user_data) {
  const gchar *language_id = (const gchar *)data;
  g_print("%s\n", language_id);
}

static void codeeditor_snippets(const char *msg)
{
  GtkSourceSnippetManager *manager;
  char **search_path;
  gsize len;

  manager = gtk_source_snippet_manager_get_default ();

  search_path = g_strdupv ((char **)gtk_source_snippet_manager_get_search_path (manager));
  len = g_strv_length (search_path);
  search_path = g_realloc_n (search_path, len + 2, sizeof (char **));
  search_path[len++] = g_strdup (msg);
  search_path[len] = NULL;

  gtk_source_snippet_manager_set_search_path (manager,
                                              (const char * const *)search_path);

  g_strfreev (search_path);
}

static gboolean
bracket_condition_met(GtkSourceView *view)
{
    GtkTextBuffer *buffer = gtk_text_view_get_buffer(GTK_TEXT_VIEW(view));

    GtkTextIter iter;
    gtk_text_buffer_get_iter_at_mark(
        buffer,
        &iter,
        gtk_text_buffer_get_insert(buffer));

    // Get start of the line
    GtkTextIter lineStart = iter;
    gtk_text_iter_set_line_offset(&lineStart, 0);

    // Scan forward from line start to cursor
    GtkTextIter scan = lineStart;
    while (gtk_text_iter_compare(&scan, &iter) < 0) {
        gunichar c = gtk_text_iter_get_char(&scan);

        // Skip whitespace
        if (!g_unichar_isspace(c)) {
            // First non-whitespace must be '{'
            return c == '{';
        }

        gtk_text_iter_forward_char(&scan);
    }

    // No non-whitespace character found before cursor
    return FALSE;
}
