//
//  editor.h
//  GtkSourceView
//
//  Created by Nick Berendsen on 28/12/2025.
//

//#ifndef Header_h
//#define Header_h
//
//
//#endif /* Header_h */

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

void codeeditor_connect_delta_signals(
    GtkTextBuffer *buffer,
    CodeEditorInsertCB insert_cb,
    CodeEditorDeleteCB delete_cb,
    gpointer user_data
);

//#include "codeeditor.h"

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
codeeditor_connect_delta_signals(GtkTextBuffer *buffer,
                                 CodeEditorInsertCB insert_cb,
                                 CodeEditorDeleteCB delete_cb,
                                 gpointer user_data)
{
    g_object_set_data(G_OBJECT(buffer), "insert_cb", insert_cb);
    g_object_set_data(G_OBJECT(buffer), "delete_cb", delete_cb);
    g_object_set_data(G_OBJECT(buffer), "user_data", user_data);

    g_signal_connect(buffer, "insert-text", G_CALLBACK(on_insert_text), user_data);
    g_signal_connect(buffer, "delete-range", G_CALLBACK(on_delete_range), user_data);
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
