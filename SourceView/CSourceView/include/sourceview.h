#pragma once

#include <gtk/gtk.h>
#include <gtksourceview/gtksource.h>

/* ============================================================
   Signal callbacks
   ============================================================ */

typedef void (*SourceViewInsertCB)(
    gint offset,
    const gchar *text,
    gpointer user_data
);

typedef void (*SourceViewDeleteCB)(
    gint start,
    gint end,
    gpointer user_data
);

typedef void (*SourceViewClickCB)(
    gint click,
    gpointer user_data
);

typedef void (*SourceViewCursorCB)(
    gpointer user_data
);

typedef gboolean (*SourceViewKeyCB)(
    guint keyval,
    guint keycode,
    GdkModifierType state,
    gpointer user_data
);

void
sourceview_connect_signals(
    GtkSourceView *view,
    SourceViewInsertCB insert_cb,
    SourceViewDeleteCB delete_cb,
    SourceViewClickCB click_cb,
    SourceViewKeyCB key_cb,
    gpointer user_data
);
