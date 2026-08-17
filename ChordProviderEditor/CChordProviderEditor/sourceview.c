#include "sourceview.h"

typedef struct {
    SourceViewInsertCB insert_cb;
    SourceViewDeleteCB delete_cb;
    SourceViewClickCB  click_cb;
    SourceViewKeyCB    key_cb;
    gpointer           user_data;
} SourceViewSignals;

/* ============================================================
   Signal handlers
   ============================================================ */

static gboolean
on_key_pressed(GtkEventControllerKey *controller,
               guint keyval,
               guint keycode,
               GdkModifierType state,
               gpointer data)
{
    SourceViewSignals *signals = data;

    if (!signals->key_cb)
        return FALSE;

    return signals->key_cb(
        keyval,
        keycode,
        state,
        signals->user_data
    );
}

static void
on_insert_text(GtkTextBuffer *buffer,
               GtkTextIter *location,
               gchar *text,
               gint len,
               gpointer data)
{
    SourceViewSignals *signals = data;

    if (!signals->insert_cb)
        return;

    signals->insert_cb(
        gtk_text_iter_get_offset(location),
        text,
        signals->user_data
    );
}

static void
on_delete_range(GtkTextBuffer *buffer,
                GtkTextIter *start,
                GtkTextIter *end,
                gpointer data)
{
    SourceViewSignals *signals = data;

    if (!signals->delete_cb)
        return;

    signals->delete_cb(
        gtk_text_iter_get_offset(start),
        gtk_text_iter_get_offset(end),
        signals->user_data
    );
}

static void
on_click(GtkGestureClick *gesture,
         int click,
         double x,
         double y,
         gpointer data)
{
    SourceViewSignals *signals = data;

    if (!signals->click_cb)
        return;

    signals->click_cb(click, signals->user_data);
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
    SourceViewSignals *signals =
        g_new0(SourceViewSignals, 1);

    signals->insert_cb = insert_cb;
    signals->delete_cb = delete_cb;
    signals->click_cb  = click_cb;
    signals->key_cb    = key_cb;
    signals->user_data = user_data;

    /* Click gesture */

    GtkGesture *gesture = gtk_gesture_click_new();

    gtk_gesture_single_set_button(
        GTK_GESTURE_SINGLE(gesture),
        GDK_BUTTON_PRIMARY
    );

    gtk_widget_add_controller(
        GTK_WIDGET(view),
        GTK_EVENT_CONTROLLER(gesture)
    );

    g_signal_connect_data(
        gesture,
        "pressed",
        G_CALLBACK(on_click),
        signals,
        (GClosureNotify)g_free,
        0
    );

    /* Buffer signals */

    GtkTextBuffer *buffer =
        gtk_text_view_get_buffer(GTK_TEXT_VIEW(view));

    g_signal_connect(
        buffer,
        "insert-text",
        G_CALLBACK(on_insert_text),
        signals
    );

    g_signal_connect(
        buffer,
        "delete-range",
        G_CALLBACK(on_delete_range),
        signals
    );

    /* Key controller */

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

    g_signal_connect(
        key,
        "key-pressed",
        G_CALLBACK(on_key_pressed),
        signals
    );
}
