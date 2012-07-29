using Gtk;
using Pango;
using LxLauncher.Backend;
using LxLauncher.Config;

namespace LxLauncher.Widgets {
    public class TabButton : RadioButton {
        public new string label;
        public string icon;
        public string comment;
        public string id;
        public int number;
        public Image icon_widget;
        public Label label_widget;
        
        private void complete (bool tool) {
            can_focus = false;
            name = "tabbutton";
            Box child_box = new Box(Orientation.HORIZONTAL, 0);                        
            Image icon_widget = new Image.from_icon_name(icon, IconSize.LARGE_TOOLBAR);
            Label label_widget = new Label(label);
            label_widget.set_ellipsize(EllipsizeMode.END);
            set_tooltip_text(comment);
            set_mode(false);            
            // Support icon + label Hon Nguyen           
			if (settings_manager.option_view_tabs == 0) child_box.pack_start(label_widget, false, false, 0);	
				else if (settings_manager.option_view_tabs == 1) child_box.pack_start(icon_widget, false, false, 0);
					else {
					child_box.pack_start(icon_widget, false, false, 0);
					child_box.pack_start(label_widget, false, false, 0);						
					}
            
            if (tool) {
                relief = ReliefStyle.NONE;
            }
            add(child_box);
        }
        public TabButton.custom(TabButton? parent = null, string icon, string name, string comment, int number, bool tool = true){
			label = name;
			this.icon = icon;			
			this.comment = comment;;
			id = icon;
			this.number = number;
			join_group(parent);
			complete(tool);
			}
        public TabButton.with_icon (TabButton? parent = null, string icon, int number, bool tool = true) {
            label = "";
            this.icon = icon;
            comment = "";
            id = icon;
            this.number = number;
            join_group(parent);
            complete(tool);
        }
        
        public TabButton (TabButton? parent = null, Category item, int number, bool tool = true) {
            label = item.name;
            icon = item.icon;            
            comment = item.comment;
            id = item.id;
            this.number = number;
            join_group(parent);
            complete(tool);
        }
    }
}
