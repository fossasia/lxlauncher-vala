
using Gtk;
using Gdk;

namespace LxLauncher.Widgets {
    public class SearchEntry : Entry {
        public void check_if_icon (Editable ed) {
            if (get_text().length > 0) {
                set_icon_from_stock(EntryIconPosition.SECONDARY, Stock.CLEAR);
            } else {
                set_icon_from_stock(EntryIconPosition.SECONDARY, null);
            }
        }
        
        public void on_icon_press (Entry widg, EntryIconPosition pos, Event ev) {
            if (pos == EntryIconPosition.SECONDARY) {
                set_text("");
            }
        }
        
        public SearchEntry (string hint_text) {
            set_placeholder_text(hint_text);
            changed.connect(check_if_icon);
            icon_press.connect(on_icon_press);
        }
    }
}