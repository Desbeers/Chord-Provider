#include <gtk/gtk.h>
#include <gtksourceview/gtksource.h>

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

gboolean
bracket_condition_met(GtkSourceView *view)
{

    GtkTextBuffer *buffer = gtk_text_view_get_buffer(GTK_TEXT_VIEW(view));

    GtkTextIter iter;
    GtkTextIter line_start;
    GtkTextIter line_end;

    gtk_text_buffer_get_iter_at_mark(
        buffer,
        &iter,
        gtk_text_buffer_get_insert(buffer)
    );

    /* Get line boundaries */
    line_start = iter;
    gtk_text_iter_set_line_offset(&line_start, 0);

    line_end = line_start;
    gtk_text_iter_forward_to_line_end(&line_end);

    /* Get full line text */
    gchar *line = gtk_text_buffer_get_text(
        buffer,
        &line_start,
        &line_end,
        FALSE
    );

    if (!line) {
        return FALSE;
    }

    /* Skip leading whitespace */
    gchar *p = line;
    while (*p == ' ' || *p == '\t') {
        p++;
    }

    /* Condition 1: line starts with '{' */
    if (*p != '{') {
        g_free(line);
        return FALSE;
    }

    /* Condition 2: line does NOT contain '}' */
    if (strchr(p, '}') != NULL) {
        g_free(line);
        return FALSE;
    }

    g_free(line);
    return TRUE;
}

//
//  editor.h
//  GtkSourceView
//
//  Created by Nick Berendsen on 28/12/2025.
//

typedef void (*CodeEditorInsertCB)(
    gint offset,
    const gchar *text,
    gpointer user_data
);

typedef void (*CodeEditorDeleteCB)(
    gint start,
    gint end,
    gpointer user_data
);

typedef void (*CodeEditorCursorCB)(
    gpointer user_data
);


typedef void (*CodeEditorCompletionShowCB)(
    gpointer user_data
);

typedef void (*CodeEditorCompletionHideCB)(
    gpointer user_data
);



//static void
//on_completion_show(
//    GObject    *object,
//    GParamSpec *pspec,
//    gpointer    user_data
//) {
//    printf("SHOW!!!");
//    CodeEditorCursorCB cb =
//        g_object_get_data(object, "show_cb");
//    if (!cb) return;
//
//    cb(user_data);
//}
//
//static void
//on_completion_hide(
//    GObject    *object,
//    GParamSpec *pspec,
//    gpointer    user_data
//) {
//    CodeEditorCursorCB cb =
//        g_object_get_data(object, "hide_cb");
//    if (!cb) return;
//
//    cb(user_data);
//}



static void
on_cursor_position_notify(
    GObject    *object,
    GParamSpec *pspec,
    gpointer    user_data
) {
    CodeEditorCursorCB cb =
        g_object_get_data(object, "cursor_cb");
    if (!cb) return;

    cb(user_data);
}

static void
on_insert_text(GtkTextBuffer *buffer,
               GtkTextIter *location,
               gchar *text,
               gint len,
               gpointer user_data)
{
    CodeEditorInsertCB cb = g_object_get_data(G_OBJECT(buffer), "insert_cb");
    if (!cb) return;

    gint offset = gtk_text_iter_get_offset(location);
    cb(offset, text, user_data);
}

static void
on_delete_range(GtkTextBuffer *buffer,
                GtkTextIter *start,
                GtkTextIter *end,
                gpointer user_data)
{
    CodeEditorDeleteCB cb = g_object_get_data(G_OBJECT(buffer), "delete_cb");
    if (!cb) return;

    gint s = gtk_text_iter_get_offset(start);
    gint e = gtk_text_iter_get_offset(end);
    cb(s, e, user_data);
}

void
codeeditor_connect_buffer_signals(
                                  GtkTextBuffer *buffer,
                                  CodeEditorInsertCB insert_cb,
                                  CodeEditorDeleteCB delete_cb,
                                  CodeEditorCursorCB cursor_cb,
                                  gpointer user_data)
{
    g_object_set_data(G_OBJECT(buffer), "insert_cb", insert_cb);
    g_object_set_data(G_OBJECT(buffer), "delete_cb", delete_cb);
    g_object_set_data(G_OBJECT(buffer), "cursor_cb", cursor_cb);
    g_object_set_data(G_OBJECT(buffer), "user_data", user_data);

    g_signal_connect(
                     buffer,
                     "insert-text",
                     G_CALLBACK(on_insert_text),
                     user_data
                     );
    g_signal_connect(
                     buffer,
                     "delete-range",
                     G_CALLBACK(on_delete_range),
                     user_data
                     );
    g_signal_connect(
                     buffer,
                     "notify::cursor-position",
                     G_CALLBACK(on_cursor_position_notify),
                     user_data
                     );
    printf("Connected..");
}

typedef void (*CodeEditorTimeoutCB)(gpointer user_data);

typedef struct {
    CodeEditorTimeoutCB cb;
    gpointer user_data;
} CodeEditorTimeoutPayload;

static gboolean
codeeditor_timeout_trampoline(gpointer data)
{
    CodeEditorTimeoutPayload *payload = data;
    payload->cb(payload->user_data);
    g_free(payload);
    return G_SOURCE_REMOVE;
}

guint
codeeditor_timeout_add(
    guint timeout_ms,
    CodeEditorTimeoutCB cb,
    gpointer user_data
) {
    CodeEditorTimeoutPayload *payload = g_malloc(sizeof *payload);
    payload->cb = cb;
    payload->user_data = user_data;

    return g_timeout_add_full(
        G_PRIORITY_DEFAULT,
        timeout_ms,
        codeeditor_timeout_trampoline,
        payload,
        NULL
    );
}
