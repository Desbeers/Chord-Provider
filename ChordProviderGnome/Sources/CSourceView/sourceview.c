#include "sourceview.h"
#include <string.h>

/* ============================================================
   Buffer signals (private trampolines)
   ============================================================ */

static gboolean
on_key_pressed(GtkEventControllerKey *controller,
               guint keyval,
               guint keycode,
               GdkModifierType state,
               gpointer user_data)
{
    SourceViewKeyCB cb =
        g_object_get_data(G_OBJECT(controller), "key_cb");

    if (!cb) return FALSE;

    return cb(keyval, keycode, state, user_data);
}

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

/* ============================================================
   Connect signals
   ============================================================ */

void
sourceview_connect_signals(GtkSourceView *view,
                           SourceViewInsertCB insert_cb,
                           SourceViewDeleteCB delete_cb,
                           SourceViewClickCB click_cb,
                           SourceViewKeyCB key_cb,
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
    g_signal_connect(buffer, "insert-text",
                     G_CALLBACK(on_insert_text), user_data);
    g_signal_connect(buffer, "delete-range",
                     G_CALLBACK(on_delete_range), user_data);

    GtkEventController *key =
        gtk_event_controller_key_new();

    gtk_event_controller_set_propagation_phase(
        key,
        GTK_PHASE_CAPTURE
    );

    gtk_widget_add_controller(
        GTK_WIDGET(view),
        key
    );

    g_object_set_data(G_OBJECT(key), "key_cb", key_cb);

    g_signal_connect(key,
                    "key-pressed",
                    G_CALLBACK(on_key_pressed),
                    user_data);
}
