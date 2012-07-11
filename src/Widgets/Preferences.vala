
using Gtk;
using LxLauncher.Config;

namespace LxLauncher.Widgets {
    public class PreferencesBox : Box {
        public ListStore pos_model;
        
        public void add_positions () {
            string[] positions = {"Top", "Right", "Bottom", "Left"};
            foreach (string name in positions) {
                TreeIter iter;
                pos_model.append(out iter);
                pos_model.set(iter, 0, name);
            }
        }
        
        public void changed_launchers (ComboBox widget) {
            settings_manager.set_integer("Interface", "favourites-bar-position", widget.get_active());
            settings_manager.save_changes();
            //Frontend.move_favourites(); see FavouriteLauncher
        }
        
        public PreferencesBox () {
            set_border_width(5);
            set_orientation(Orientation.VERTICAL);
            CellRendererText pos_cell = new CellRendererText();
            pos_model = new ListStore(1, typeof(string));
            add_positions();
            ComboBox bar_pos = new ComboBox.with_model(pos_model);
            bar_pos.pack_start(pos_cell, false);
            bar_pos.add_attribute(pos_cell, "text", 0);
            bar_pos.set_active(settings_manager.favourites_pos);
            bar_pos.changed.connect(changed_launchers);
            Box bar_pos_box = new Box(Orientation.HORIZONTAL, 5);
            bar_pos_box.pack_start(new Label("Favourites bar position"), false, false, 0);
            bar_pos_box.pack_end(bar_pos, false, false, 0);
            pack_start(bar_pos_box, false, false, 0);
        }
    }
}