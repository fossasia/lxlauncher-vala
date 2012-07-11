
using Gtk;
using Gdk;
using Pango;
using LxLauncher.Config;
using LxLauncher.Backend;

namespace LxLauncher.Widgets {
    public class FavouriteLauncher : Box {
        public Button button;
        public Gtk.Menu menu;
        public string label;
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
            if (event.button != 1) {
                menu.popup(null, null, null, event.button, event.time);
                return true;
            }
            return false;
        }
        
        public void remove_to_favourites (Gtk.MenuItem widg) {
            settings_manager.remove_key("Favourites", desktop_id.split(".")[0]);
            settings_manager.save_changes();
            //Frontend.append_favourites(); should be replace by a notify signal
        }
        
        public FavouriteLauncher (App app, bool hide_label = true) {
            set_orientation(Orientation.VERTICAL);
            set_spacing(5);
            set_border_width(5);
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
            icon_widget.set_pixel_size(height);
            button = new Button();
            ((Widget)button).button_press_event.connect(pop_menu);
            button.clicked.connect(() => { app.launch(); });
            button.set_relief(ReliefStyle.NONE);
            button.set_can_focus(false);
            button.set_tooltip_text(comment);
            button.set_image(icon_widget);
            button.halign = Align.CENTER;
            menu = new Gtk.Menu();
            ImageMenuItem remove_item = new ImageMenuItem.with_label("Remove to favourites");
            remove_item.set_image(new Image.from_stock(Stock.ADD, IconSize.MENU));
            remove_item.activate.connect(remove_to_favourites);
            remove_item.show();
            menu.append(remove_item);
            pack_start(button, false, false, 0);
            if (! hide_label) {
                pack_start(label_widget, false, false, 0);
            }
        }
    }
}
