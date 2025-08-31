#include <gtksourceview/gtksource.h>

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
