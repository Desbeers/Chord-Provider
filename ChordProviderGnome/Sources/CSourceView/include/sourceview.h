#pragma once

#include <gtk/gtk.h>
#include <gtksourceview/gtksource.h>

/* ============================================================
   Snippets
   ============================================================ */

void
sourceview_add_snippets_path(const char *msg);

/* ============================================================
   Brackets check
   ============================================================ */

gboolean
sourceview_check_for_brackets(GtkSourceView *view);

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

void
sourceview_connect_signals(
    GtkSourceView *view,
    SourceViewInsertCB insert_cb,
    SourceViewDeleteCB delete_cb,
    SourceViewClickCB click_cb,
    gpointer user_data
);

/* ============================================================
   Marks
   ============================================================ */

void
sourceview_install_marks(
    GtkSourceView *view,
    const gchar *category
);

void
sourceview_add_mark(
    GtkSourceBuffer *buffer,
    gint line,
    const gchar *category
);

void
sourceview_clear_marks(
    GtkSourceBuffer *buffer,
    const gchar *category
);
