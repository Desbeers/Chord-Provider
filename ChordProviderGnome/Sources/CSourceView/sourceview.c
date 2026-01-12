#include "sourceview.h"

#include <string.h>

/* ============================================================
   Theme helpers (private)
   ============================================================ */

static void
update_theme_on_settings_change(GObject *settings,
                                GParamSpec *pspec,
                                gpointer user_data)
{
    GtkSourceBuffer *buffer = GTK_SOURCE_BUFFER(user_data);
    gboolean dark = FALSE;

    g_object_get(settings,
                 "gtk-application-prefer-dark-theme",
                 &dark,
                 NULL);

    const char *scheme_name = dark ? "Adwaita-dark" : "Adwaita";

    GtkSourceStyleSchemeManager *mgr =
        gtk_source_style_scheme_manager_get_default();

    GtkSourceStyleScheme *scheme =
        gtk_source_style_scheme_manager_get_scheme(mgr, scheme_name);

    gtk_source_buffer_set_style_scheme(buffer, scheme);
}

void
sourceview_set_theme(GtkSourceBuffer *buffer)
{
    GtkSettings *settings = gtk_settings_get_default();
    update_theme_on_settings_change(G_OBJECT(settings), NULL, buffer);

    g_signal_connect(settings,
                     "notify::gtk-application-prefer-dark-theme",
                     G_CALLBACK(update_theme_on_settings_change),
                     buffer);
}

/* ============================================================
   Snippets
   ============================================================ */

void
sourceview_add_snippets_path(const char *msg)
{
    GtkSourceSnippetManager *manager =
        gtk_source_snippet_manager_get_default();

    char **search_path = g_strdupv(
        (char **)gtk_source_snippet_manager_get_search_path(manager));
    gsize len = g_strv_length(search_path);

    search_path = g_realloc_n(search_path, len + 2, sizeof(char *));
    search_path[len++] = g_strdup(msg);
    search_path[len] = NULL;

    gtk_source_snippet_manager_set_search_path(
        manager,
        (const char * const *)search_path
    );

    g_strfreev(search_path);
}

/* ============================================================
   Brackets check
   ============================================================ */

gboolean
sourceview_check_for_brackets(GtkSourceView *view)
{
    GtkTextBuffer *buffer = gtk_text_view_get_buffer(GTK_TEXT_VIEW(view));

    GtkTextIter iter, start, end;
    gtk_text_buffer_get_iter_at_mark(GTK_TEXT_BUFFER(buffer), &iter,
                                     gtk_text_buffer_get_insert(GTK_TEXT_BUFFER(buffer)));

    start = iter;
    gtk_text_iter_set_line_offset(&start, 0);

    end = start;
    gtk_text_iter_forward_to_line_end(&end);

    gchar *line = gtk_text_buffer_get_text(GTK_TEXT_BUFFER(buffer), &start, &end, FALSE);
    if (!line) return FALSE;

    gchar *p = line;
    while (*p == ' ' || *p == '\t') p++;

    gboolean result = (*p == '{') && (strchr(p, '}') == NULL);

    g_free(line);
    return result;
}

/* ============================================================
   Buffer signals (private trampolines)
   ============================================================ */

static void
on_cursor_notify(GObject *object,
                 GParamSpec *pspec,
                 gpointer user_data)
{
    SourceViewCursorCB cb =
        g_object_get_data(object, "cursor_cb");
    if (cb) cb(user_data);
}

static void
on_insert_text(GtkTextBuffer *buffer,
               GtkTextIter *location,
               gchar *text,
               gint len,
               gpointer user_data)
{
    SourceViewInsertCB cb =
        g_object_get_data(G_OBJECT(buffer), "insert_cb");
    if (!cb) return;

    cb(gtk_text_iter_get_offset(location), text, user_data);
}

static void
on_delete_range(GtkTextBuffer *buffer,
                GtkTextIter *start,
                GtkTextIter *end,
                gpointer user_data)
{
    SourceViewDeleteCB cb =
        g_object_get_data(G_OBJECT(buffer), "delete_cb");
    if (!cb) return;

    cb(gtk_text_iter_get_offset(start),
       gtk_text_iter_get_offset(end),
       user_data);
}

static void
on_click(
    GtkGestureClick *gesture,
    int click,
    double x,
    double y,
    gpointer user_data
) {
    SourceViewClickCB cb =
        g_object_get_data(G_OBJECT(gesture), "click_cb");
    if (!cb) return;

    cb(click, user_data);
}

void
sourceview_connect_signals(GtkSourceView *view,
                           SourceViewInsertCB insert_cb,
                           SourceViewDeleteCB delete_cb,
                           SourceViewCursorCB cursor_cb,
                           SourceViewClickCB click_cb,
                           gpointer user_data)
{

    GtkGesture *gesture = gtk_gesture_click_new();
    gtk_gesture_single_set_button(GTK_GESTURE_SINGLE(gesture), GDK_BUTTON_PRIMARY);

    gtk_widget_add_controller(
        GTK_WIDGET(view),
        GTK_EVENT_CONTROLLER(gesture)
    );

    g_object_set_data(G_OBJECT(gesture), "click_cb", click_cb);

    g_signal_connect(gesture, "pressed",
                     G_CALLBACK(on_click), user_data);

    GtkTextBuffer *buffer =
        gtk_text_view_get_buffer(GTK_TEXT_VIEW(view));

    g_object_set_data(G_OBJECT(buffer), "insert_cb", insert_cb);
    g_object_set_data(G_OBJECT(buffer), "delete_cb", delete_cb);
    g_object_set_data(G_OBJECT(buffer), "cursor_cb", cursor_cb);

    g_signal_connect(buffer, "insert-text",
                     G_CALLBACK(on_insert_text), user_data);
    g_signal_connect(buffer, "delete-range",
                     G_CALLBACK(on_delete_range), user_data);
    g_signal_connect(buffer, "notify::cursor-position",
                     G_CALLBACK(on_cursor_notify), user_data);
}

/* ============================================================
   Timeout helper
   ============================================================ */

typedef struct {
    SourceViewTimeoutCB cb;
    gpointer user_data;
} TimeoutPayload;

static gboolean
timeout_trampoline(gpointer data)
{
    TimeoutPayload *p = data;
    p->cb(p->user_data);
    g_free(p);
    return G_SOURCE_REMOVE;
}

guint
sourceview_add_schedule(guint timeout_ms,
                        SourceViewTimeoutCB cb,
                        gpointer user_data)
{
    TimeoutPayload *p = g_malloc(sizeof *p);
    p->cb = cb;
    p->user_data = user_data;

    return g_timeout_add_full(
        G_PRIORITY_DEFAULT,
        timeout_ms,
        timeout_trampoline,
        p,
        NULL
    );
}

/* ============================================================
   Marks
   ============================================================ */

void
sourceview_install_marks(GtkSourceView *view,
                         const gchar *category)
{
    GtkSourceMarkAttributes *attrs =
        gtk_source_mark_attributes_new();

    GdkRGBA bg = { 1, 0, 0, 0.025 };
    gtk_source_mark_attributes_set_background(attrs, &bg);
    gtk_source_mark_attributes_set_icon_name(
        attrs,
        "emblem-important-symbolic"
    );

    gtk_source_view_set_mark_attributes(view, category, attrs, 1);
    gtk_source_view_set_show_line_marks(view, TRUE);

    g_object_unref(attrs);
}

void
sourceview_add_mark(GtkSourceBuffer *buffer,
                    gint line,
                    const gchar *category)
{
    GtkTextIter iter;
    gtk_text_buffer_get_iter_at_line(GTK_TEXT_BUFFER(buffer), &iter, line - 1);

    gtk_source_buffer_create_source_mark(buffer, NULL, category, &iter);
}

void
sourceview_clear_marks(GtkSourceBuffer *buffer, const gchar *category)
{
    GtkTextIter start, end;

    gtk_text_buffer_get_start_iter(GTK_TEXT_BUFFER(buffer), &start);
    gtk_text_buffer_get_end_iter(GTK_TEXT_BUFFER(buffer), &end);

    gtk_source_buffer_remove_source_marks(buffer, &start, &end, category);
}
