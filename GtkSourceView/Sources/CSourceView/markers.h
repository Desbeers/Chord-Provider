//
//  markers.h
//  GTKSourceView
//
//  © 2025 Nick Berendsen
//

void
codeeditor_install_bookmark_renderer(GtkSourceView *view, const gchar *category) {
    GtkSourceMarkAttributes *attrs = gtk_source_mark_attributes_new();
    /// Background color for the line
    GdkRGBA green = {1, 0, 0, 0.025};
    gtk_source_mark_attributes_set_background(attrs, &green);
    /// Icon in the gutter
    gtk_source_mark_attributes_set_icon_name(attrs, "emblem-important-symbolic");
    /// Set the attributes
    gtk_source_view_set_mark_attributes(view, category, attrs, 1);
    g_object_unref(attrs);
    /// Make sure marks are shown
    gtk_source_view_set_show_line_marks(view, TRUE);
}

void
codeeditor_add_line_mark(
    GtkSourceBuffer *buffer,
    gint line,
    const gchar *category
) {
    GtkTextIter iter;
    gtk_text_buffer_get_iter_at_line(
        GTK_TEXT_BUFFER(buffer),
        &iter,
        line - 1
    );

    gtk_source_buffer_create_source_mark(
        buffer,
        NULL,
        category,
        &iter
    );
}

void
codeeditor_remove_line_marks(
    GtkSourceBuffer *buffer,
    gint line,
    const gchar *category
) {
    GtkTextIter start, end;

    gtk_text_buffer_get_iter_at_line(
        GTK_TEXT_BUFFER(buffer),
        &start,
        line - 1
    );
    end = start;
    gtk_text_iter_forward_to_line_end(&end);

    gtk_source_buffer_remove_source_marks(
        buffer,
        &start,
        &end,
        category
    );
}

void
codeeditor_clear_marks(
    GtkSourceBuffer *buffer,
    const gchar *category
) {
    GtkTextIter start, end;

    gtk_text_buffer_get_start_iter(
        GTK_TEXT_BUFFER(buffer),
        &start
    );
    gtk_text_buffer_get_end_iter(
        GTK_TEXT_BUFFER(buffer),
        &end
    );

    gtk_source_buffer_remove_source_marks(
        buffer,
        &start,
        &end,
        category
    );
}


