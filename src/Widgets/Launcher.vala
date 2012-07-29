
using Gtk;
using Gdk;
using Pango;
using LxLauncher.Backend;
using LxLauncher.Config;

namespace LxLauncher.Widgets {
    public class Launcher : Button {
        public Button button;
        public Gtk.Menu menu;
        public ImageMenuItem add_item;
        public new string label;
        public string icon;
        public string comment;
        public string exec;
        public string desktop_id;
        
        public void popup_error (string error, string error_body) {
            MessageDialog error_dialog = new MessageDialog(null, DialogFlags.DESTROY_WITH_PARENT, MessageType.ERROR, ButtonsType.CLOSE, error, error_body);
            error_dialog.format_secondary_text(error_body);
            error_dialog.run();
            error_dialog.destroy();
        }
        
        public bool pop_menu (Widget but, EventButton event) {
            if (desktop_id in settings_manager.favourites) {
                add_item.set_sensitive(false);
                add_item.label = "Already in favourites";
            } else {
                add_item.set_sensitive(true);
                add_item.label = "Add to favourites";
            }
            if (event.button != 1) {
                menu.popup(null, null, null, event.button, event.time);
                return true;
            }
            return false;
        }
        
        public void add_to_favourites (Gtk.MenuItem widg) {
            settings_manager.set_string("Favourites", desktop_id.split(".")[0], desktop_id);
            settings_manager.save_changes();
           // main_page.append_favourites(); //see FavouriteLauncher
        }
        
        public Launcher (App app, bool hide_label = false, bool preferred = false) {
            Box child_box = new Box(Orientation.VERTICAL, 5);
            child_box.set_border_width(5);
            label = app.name;
            icon = app.icon;
            comment = app.comment;
            exec = app.exec;
            desktop_id = app.desktop_id;
            name = "launcher";
            Label label_widget = new Label(label);
            label_widget.halign = Align.CENTER;
            label_widget.ellipsize = EllipsizeMode.END;
            Image icon_widget;
            int width, height;
            IconTheme theme = IconTheme.get_default();
            icon_size_lookup((IconSize) settings_manager.icon_size, out width, out height);
            if (FileUtils.test(icon, FileTest.EXISTS)) {
                theme.append_search_path(Path.get_dirname(icon));
                icon = Path.get_basename(icon);
            }
            if ("." in icon) {
                icon = icon.split(".")[0];
            }
            icon_widget = new Image.from_icon_name(icon, (IconSize) settings_manager.icon_size);
            icon_widget.pixel_size = height;
            button_press_event.connect(pop_menu);
            clicked.connect(() => { app.launch(); });
            relief = ReliefStyle.NONE;
            can_focus = false;
            tooltip_text = comment;
            menu = new Gtk.Menu();
            add_item = new ImageMenuItem.with_label("Add to favourites");
            add_item.image = new Image.from_stock(Stock.ADD, IconSize.MENU);
            add_item.activate.connect(add_to_favourites);
            add_item.show();
            menu.append(add_item);
            child_box.pack_start(icon_widget, false, false, 0);
            if (! hide_label) {
                child_box.pack_start(label_widget, false, false, 0);
            }
            add(child_box);
        }
    }
}
