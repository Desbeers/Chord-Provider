#pragma once

#include <gtksourceview/gtksource.h>

/* ============================================================
   Signal callbacks
   ============================================================ */

typedef void (*SourceEditorInsertCB)(
    gint offset,
    const gchar *text,
    gpointer user_data
);

typedef void (*SourceEditorDeleteCB)(
    gint start,
    gint end,
    gpointer user_data
);

typedef void (*SourceEditorClickCB)(
    gint click,
    gpointer user_data
);

typedef void (*SourceEditorCursorCB)(
    gpointer user_data
);

typedef gboolean (*SourceEditorKeyCB)(
    guint keyval,
    guint keycode,
    GdkModifierType state,
    gpointer user_data
);

void
sourceview_connect_signals(
    GtkSourceView *view,
    SourceEditorInsertCB insert_cb,
    SourceEditorDeleteCB delete_cb,
    SourceEditorClickCB click_cb,
    SourceEditorKeyCB key_cb,
    gpointer user_data
);
