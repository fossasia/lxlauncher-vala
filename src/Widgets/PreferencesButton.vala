
using Gtk;
using Pango;
using LxLauncher.Backend;

namespace LxLauncher.Widgets {
    public class PreferencesButton : RadioButton {
        public string icon;
       
       // public int number;
        
        public PreferencesButton (string icon) {
            this.icon = icon;            
            //can_focus = false;
            name = "preferencesbutton";
            Box child_box = new Box(Orientation.HORIZONTAL, 2);
            Image icon_widget = new Image.from_icon_name(icon, IconSize.LARGE_TOOLBAR);
            Label label_widget = new Label("Preferences");
            label_widget.set_ellipsize(EllipsizeMode.END);
            //join_group(parent);
            set_mode(false);
            child_box.pack_start(icon_widget, false, false, 0);
            child_box.pack_start(label_widget, false, false, 0);
            relief = ReliefStyle.NONE;
            add(child_box);
        }
    }
}
