module vteterminal;

import gtkc.glibtypes;
import gtk.Widget;
import gtkc.gtktypes;

import gtkc.gtk;
import glib.ConstructionException;
import gobject.ObjectG;

import gobject.Signals;
import gtkc.gdktypes;

import glib.Str;
import gtk.Menu;
import pango.PgAttributeList;
import pango.PgLayout;

import gtk.Misc;

enum VtePtyFlags {
  VTE_PTY_NO_LASTLOG  = 1 << 0,
  VTE_PTY_NO_UTMP     = 1 << 1,
  VTE_PTY_NO_WTMP     = 1 << 2,
  VTE_PTY_NO_HELPER   = 1 << 3,
  VTE_PTY_NO_FALLBACK = 1 << 4,
  VTE_PTY_DEFAULT     = 0
}

enum VtePtyError {
  VTE_PTY_ERROR_PTY_HELPER_FAILED = 0,
  VTE_PTY_ERROR_PTY98_FAILED
}


enum VteTerminalCursorBlinkMode {
        VTE_CURSOR_BLINK_SYSTEM,
        VTE_CURSOR_BLINK_ON,
        VTE_CURSOR_BLINK_OFF
}

/**
 * VteTerminalCursorShape:
 * @VTE_CURSOR_SHAPE_BLOCK: Draw a block cursor.  This is the default.
 * @VTE_CURSOR_SHAPE_IBEAM: Draw a vertical bar on the left side of character.
 * This is similar to the default cursor for other GTK+ widgets.
 * @VTE_CURSOR_SHAPE_UNDERLINE: Draw a horizontal bar below the character.
 *
 * An enumerated type which can be used to indicate what should the terminal
 * draw at the cursor position.
 */
enum VteTerminalCursorShape {
        VTE_CURSOR_SHAPE_BLOCK,
        VTE_CURSOR_SHAPE_IBEAM,
        VTE_CURSOR_SHAPE_UNDERLINE
}

enum VteTerminalWriteFlags {
  VTE_TERMINAL_WRITE_DEFAULT = 0
}


enum VteTerminalAntiAlias {
	VTE_ANTI_ALIAS_USE_DEFAULT,
	VTE_ANTI_ALIAS_FORCE_ENABLE,
	VTE_ANTI_ALIAS_FORCE_DISABLE
}

struct VtePty {}

enum VteTerminalEraseBinding {
	VTE_ERASE_AUTO,
	VTE_ERASE_ASCII_BACKSPACE,
	VTE_ERASE_ASCII_DELETE,
	VTE_ERASE_DELETE_SEQUENCE,
	VTE_ERASE_TTY
}

alias gboolean function(VteTerminal *terminal, glong column, glong row, gpointer data) VteSelectionFunc;

struct VteTerminal {
	GtkWidget widget;
        /*< private >*/
	GtkAdjustment *adjustment;	/* Scrolling adjustment. */

	/* Metric and sizing data. */
	glong char_width, char_height;	/* dimensions of character cells */
	glong char_ascent, char_descent; /* important font metrics */
	glong row_count, column_count;	/* dimensions of the window */

	/* Titles. */
	char *window_title;
	char *icon_title;

	/*< private >*/
	void *pvt;
}

extern(C) {
GtkWidget * vte_terminal_new ();

void vte_terminal_im_append_menuitems (VteTerminal *terminal, GtkMenuShell *menushell);
void vte_terminal_feed (VteTerminal *terminal, const char *data, glong length);
void vte_terminal_feed_child (VteTerminal *terminal, const char *text, glong length);
void vte_terminal_feed_child_binary (VteTerminal *terminal, const char *data, glong length);
int vte_terminal_get_child_exit_status (VteTerminal *terminal);
void vte_terminal_select_all (VteTerminal *terminal);
void vte_terminal_select_none (VteTerminal *terminal);
void vte_terminal_copy_clipboard (VteTerminal *terminal);
void vte_terminal_paste_clipboard (VteTerminal *terminal);
void vte_terminal_copy_primary (VteTerminal *terminal);
void vte_terminal_paste_primary (VteTerminal *terminal);
void vte_terminal_set_size (VteTerminal *terminal, glong columns, glong rows);
void vte_terminal_set_audible_bell (VteTerminal *terminal, bool is_audible);
bool vte_terminal_get_audible_bell (VteTerminal *terminal);
void vte_terminal_set_visible_bell (VteTerminal *terminal, bool is_visible);
bool vte_terminal_get_visible_bell (VteTerminal *terminal);
void vte_terminal_set_allow_bold (VteTerminal *terminal, bool allow_bold);
bool vte_terminal_get_allow_bold (VteTerminal *terminal);
void vte_terminal_set_scroll_on_output (VteTerminal *terminal, bool scroll);
void vte_terminal_set_scroll_on_keystroke (VteTerminal *terminal, bool scroll);
void vte_terminal_set_color_bold (VteTerminal *terminal, const GdkColor *bold);
void vte_terminal_set_color_bold_rgba (VteTerminal *terminal, const GdkRGBA *bold);
void vte_terminal_set_color_foreground (VteTerminal *terminal, const GdkColor *foreground);
void vte_terminal_set_color_foreground_rgba (VteTerminal *terminal, const GdkRGBA *foreground);
void vte_terminal_set_color_background (VteTerminal *terminal, const GdkColor *background);
void vte_terminal_set_color_background_rgba (VteTerminal *terminal, const GdkRGBA *background);
void vte_terminal_set_color_dim (VteTerminal *terminal, const GdkColor *dim);
void vte_terminal_set_color_dim_rgba (VteTerminal *terminal, const GdkRGBA *dim);
void vte_terminal_set_color_cursor (VteTerminal *terminal, const GdkColor *cursor_background);
void vte_terminal_set_color_cursor_rgba (VteTerminal *terminal, const GdkRGBA *cursor_background);
void vte_terminal_set_color_highlight (VteTerminal *terminal, const GdkColor *highlight_background);
void vte_terminal_set_color_highlight_rgba (VteTerminal *terminal, const GdkRGBA *highlight_background);
void vte_terminal_set_colors (VteTerminal *terminal, const GdkColor *foreground, const GdkColor *background, const GdkColor *palette, glong palette_size);
void vte_terminal_set_colors_rgba (VteTerminal *terminal, const GdkRGBA *foreground, const GdkRGBA *background, const GdkRGBA *palette, gsize palette_size);
void vte_terminal_set_default_colors (VteTerminal *terminal);
void vte_terminal_set_opacity (VteTerminal *terminal, guint16 opacity);
void vte_terminal_set_background_image (VteTerminal *terminal, GdkPixbuf *image);
void vte_terminal_set_background_image_file (VteTerminal *terminal, const char *path);
void vte_terminal_set_background_saturation (VteTerminal *terminal, double saturation);
void vte_terminal_set_background_transparent (VteTerminal *terminal, bool transparent);
void vte_terminal_set_background_tint_color (VteTerminal *terminal, const GdkColor *color);
void vte_terminal_set_scroll_background (VteTerminal *terminal, bool scroll);
void vte_terminal_set_cursor_shape (VteTerminal *terminal, VteTerminalCursorShape shape);
VteTerminalCursorShape vte_terminal_get_cursor_shape (VteTerminal *terminal);
void vte_terminal_set_cursor_blinks (VteTerminal *terminal, bool blink);
VteTerminalCursorBlinkMode vte_terminal_get_cursor_blink_mode (VteTerminal *terminal);
void vte_terminal_set_cursor_blink_mode (VteTerminal *terminal, VteTerminalCursorBlinkMode mode);
void vte_terminal_set_scrollback_lines (VteTerminal *terminal, glong lines);
void vte_terminal_set_font (VteTerminal *terminal, const PangoFontDescription *font_desc);
void vte_terminal_set_font_from_string (VteTerminal *terminal, const char *name);
void vte_terminal_set_font_from_string_full (VteTerminal *terminal, const char *name, VteTerminalAntiAlias antialias);
void vte_terminal_set_font_full (VteTerminal *terminal, const PangoFontDescription *font_desc, VteTerminalAntiAlias antialias);
const PangoFontDescription * vte_terminal_get_font (VteTerminal *terminal);
bool vte_terminal_get_using_xft (VteTerminal *terminal);
bool vte_terminal_get_has_selection (VteTerminal *terminal);
void vte_terminal_set_word_chars (VteTerminal *terminal, const char *spec);
bool vte_terminal_is_word_char (VteTerminal *terminal, gunichar c);
void vte_terminal_set_backspace_binding (VteTerminal *terminal, VteTerminalEraseBinding binding);
void vte_terminal_set_delete_binding (VteTerminal *terminal, VteTerminalEraseBinding binding);
void vte_terminal_set_mouse_autohide (VteTerminal *terminal, bool setting);
bool vte_terminal_get_mouse_autohide (VteTerminal *terminal);
void vte_terminal_reset (VteTerminal *terminal, bool clear_tabstops, bool clear_history);
char * vte_terminal_get_text (VteTerminal *terminal, VteSelectionFunc is_selected, gpointer user_data, GArray *attributes);
char * vte_terminal_get_text_include_trailing_spaces (VteTerminal *terminal, VteSelectionFunc is_selected, gpointer user_data, GArray *attributes);
char * vte_terminal_get_text_range (VteTerminal *terminal, glong start_row, glong start_col, glong end_row, glong end_col, VteSelectionFunc is_selected, gpointer user_data, GArray *attributes);
void vte_terminal_get_cursor_position (VteTerminal *terminal, glong *column, glong *row);
void vte_terminal_match_clear_all (VteTerminal *terminal);
int vte_terminal_match_add (VteTerminal *terminal, const char *match);
int vte_terminal_match_add_gregex (VteTerminal *terminal, GRegex *regex, GRegexMatchFlags flags);
void vte_terminal_match_remove (VteTerminal *terminal, int tag);
char * vte_terminal_match_check (VteTerminal *terminal, glong column, glong row, int *tag);
void vte_terminal_match_set_cursor (VteTerminal *terminal, int tag, GdkCursor *cursor);
void vte_terminal_match_set_cursor_type (VteTerminal *terminal, int tag, GdkCursorType cursor_type);
void vte_terminal_match_set_cursor_name (VteTerminal *terminal, int tag, const char *cursor_name);
void vte_terminal_set_emulation (VteTerminal *terminal, const char *emulation);
const char * vte_terminal_get_emulation (VteTerminal *terminal);
const char * vte_terminal_get_default_emulation (VteTerminal *terminal);
void vte_terminal_set_encoding (VteTerminal *terminal, const char *codeset);
const char * vte_terminal_get_encoding (VteTerminal *terminal);
const char * vte_terminal_get_status_line (VteTerminal *terminal);
void vte_terminal_get_padding (VteTerminal *terminal, int *xpad, int *ypad);
bool vte_terminal_write_contents (VteTerminal *terminal, GOutputStream *stream, VteTerminalWriteFlags flags, GCancellable *cancellable, GError **error);
bool vte_terminal_search_find_next (VteTerminal *terminal);
bool vte_terminal_search_find_previous (VteTerminal *terminal);
GRegex * vte_terminal_search_get_gregex (VteTerminal *terminal);
bool vte_terminal_search_get_wrap_around (VteTerminal *terminal);
void vte_terminal_search_set_gregex (VteTerminal *terminal, GRegex *regex);
void vte_terminal_search_set_wrap_around (VteTerminal *terminal, bool wrap_around);

char * vte_get_user_shell ();

pid_t vte_terminal_fork_command (VteTerminal *terminal, const char *command, char **argv, char **envv, const char *working_directory, bool lastlog, bool utmp, bool wtmp);
bool vte_terminal_fork_command_full (VteTerminal *terminal, VtePtyFlags pty_flags, const char *working_directory, char **argv, char **envv, GSpawnFlags spawn_flags, GSpawnChildSetupFunc child_setup, gpointer child_setup_data, GPid *child_pid, GError **error);
pid_t vte_terminal_forkpty (VteTerminal *terminal, char **envv, const char *working_directory, bool lastlog, bool utmp, bool wtmp);
int vte_terminal_get_pty (VteTerminal *terminal);
VtePty * vte_terminal_get_pty_object (VteTerminal *terminal);
VtePty * vte_terminal_pty_new (VteTerminal *terminal, VtePtyFlags flags, GError **error);
void vte_terminal_set_pty (VteTerminal *terminal, int pty_master);
void vte_terminal_set_pty_object (VteTerminal *terminal, VtePty *pty);
void vte_terminal_watch_child (VteTerminal *terminal, GPid child_pid);


GtkAdjustment * vte_terminal_get_adjustment (VteTerminal *terminal);
glong vte_terminal_get_char_ascent (VteTerminal *terminal);
glong vte_terminal_get_char_descent (VteTerminal *terminal);
glong vte_terminal_get_char_height (VteTerminal *terminal);
glong vte_terminal_get_char_width (VteTerminal *terminal);
glong vte_terminal_get_column_count (VteTerminal *terminal);
const char * vte_terminal_get_icon_title (VteTerminal *terminal);
glong vte_terminal_get_row_count (VteTerminal *terminal);
const char * vte_terminal_get_window_title (VteTerminal *terminal);
const char * vte_terminal_get_current_directory_uri (VteTerminal *terminal);
const char * vte_terminal_get_current_file_uri (VteTerminal *terminal);
}

public class Terminal : Misc {
	protected VteTerminal* vteTerminal;
	
	public VteTerminal* getLabelStruct()
	{
		return vteTerminal;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)vteTerminal;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (VteTerminal* vteTerminal)
	{
		super(cast(GtkMisc*)vteTerminal);
		this.vteTerminal = vteTerminal;
	}
	
	protected override void setStruct(GObject* obj)
	{
		super.setStruct(obj);
		vteTerminal = cast(VteTerminal*)obj;
	}
}
