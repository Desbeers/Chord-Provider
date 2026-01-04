typedef struct {
    GtkSourceAnnotationProvider *provider;
} CodeEditorAnnotations;

/* --- Hover async callback --- */
static void
codeeditor_annotation_provider_populate_hover_async(
    GtkSourceAnnotationProvider  *self,
    GtkSourceAnnotation          *annotation,
    GtkSourceHoverDisplay        *display,
    GCancellable                 *cancellable,
    GAsyncReadyCallback           callback,
    gpointer                      user_data)
{
    GTask *task = g_task_new(self, cancellable, callback, user_data);
    g_task_set_source_tag(task, codeeditor_annotation_provider_populate_hover_async);

    /* Use the annotation's description as hover text */
    const char *desc = gtk_source_annotation_get_description(annotation);
    GtkWidget *label = gtk_label_new(desc ? desc : "");

    gtk_widget_set_halign(label, GTK_ALIGN_START);
    gtk_widget_set_valign(label, GTK_ALIGN_START);

    gtk_source_hover_display_append(display, label);

    g_task_return_boolean(task, TRUE);
    g_object_unref(task);
}

static gboolean
codeeditor_annotation_provider_populate_hover_finish(
    GtkSourceAnnotationProvider *self,
    GAsyncResult                *result,
    GError                     **error)
{
    return g_task_propagate_boolean(G_TASK(result), error);
}

/* --- Enable annotations on a GtkSourceView --- */
void
codeeditor_enable_annotations(GtkSourceView *view, CodeEditorAnnotations *state)
{
    GtkSourceAnnotations *annotations;

    if (!state->provider)
    {
        state->provider = GTK_SOURCE_ANNOTATION_PROVIDER(
            g_object_new(GTK_SOURCE_TYPE_ANNOTATION_PROVIDER, NULL)
        );

        /* Override the hover functions */
        GtkSourceAnnotationProviderClass *klass =
            GTK_SOURCE_ANNOTATION_PROVIDER_GET_CLASS(state->provider);
        klass->populate_hover_async = codeeditor_annotation_provider_populate_hover_async;
        klass->populate_hover_finish = codeeditor_annotation_provider_populate_hover_finish;
    }

    annotations = gtk_source_view_get_annotations(view);
    gtk_source_annotations_add_provider(annotations, state->provider);
}

/* --- Add an annotation --- */
void
codeeditor_add_annotation(GtkSourceView *view,
                          CodeEditorAnnotations *state,
                          gint line, /* 1-based */
                          const gchar *text)
{
    g_return_if_fail(state->provider != NULL);

    GtkSourceAnnotation *annotation = gtk_source_annotation_new(
        text,
        g_icon_new_for_string("dialog-warning-symbolic", NULL),
        line - 1, /* GtkSourceView uses 0-based lines */
        GTK_SOURCE_ANNOTATION_STYLE_WARNING
    );

    gtk_source_annotation_provider_add_annotation(state->provider, annotation);
    g_object_unref(annotation);
}

/* --- Remove all annotations --- */
void
codeeditor_clear_annotations(CodeEditorAnnotations *state)
{
    if (!state->provider)
        return;

    gtk_source_annotation_provider_remove_all(state->provider);
}
