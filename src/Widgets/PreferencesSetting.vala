
using Gtk;
using Gdk;
using Posix;

using LxLauncher.Config;
using LxLauncher.Main;
namespace LxLauncher.Widgets {
	public PreferencesSetting preferences;
    public class PreferencesSetting : Gtk.Window {
	private Gtk.Application app;
	private Notebook main;
	private Box background;
	private Box tabs;
	private Box favourite;
	
	private Entry file_link;	
	private Entry color;
	private Entry f_color;
	private Entry font;
	private RadioButton tabs_text;	
	private RadioButton tabs_icon;
	private RadioButton tabs_all;
	private CheckButton show_favourite;
	
	private string str;	
	private void open_file(){
		 var file_chooser = new FileChooserDialog ("Open File", this,  
		 FileChooserAction.OPEN,Stock.CANCEL, 
		 ResponseType.CANCEL,Stock.OPEN, ResponseType.ACCEPT);
		 var filter = new Gtk.FileFilter();
		 filter.set_name("Images");
		 filter.add_mime_type("image/png");
		 filter.add_mime_type("image/jpeg");
		 filter.add_mime_type("image/gif");
		 filter.add_pattern("*.png");
		 filter.add_pattern("*.jpg");
		 filter.add_pattern("*.gif");		 
		 file_chooser.add_filter(filter);
        if (file_chooser.run () == ResponseType.ACCEPT) {
            file_link.set_text(file_chooser.get_filename ());
            settings_manager.background = file_chooser.get_filename ();
            color.set_text("");
        }        
        file_chooser.destroy ();
		}
	private void choose_color(){
		var color_choose = new ColorSelectionDialog("Choose color");
		if (color_choose.run() == ResponseType.OK){			
			ColorSelection colorsl = (ColorSelection)color_choose.get_color_selection();
			Color co;
			colorsl.get_current_color(out co);
			float r;
			float g;
			float b;
			r = co.red;
			g = co.green;
			b = co.blue;
			settings_manager.tab_bgcolor = "#%02x%02x%02x".printf((int) r >> 8,(int) g >> 8,(int) b >> 8);
			color.set_text(settings_manager.tab_bgcolor);			
			file_link.set_text("");
			settings_manager.background = "";
			}			
			color_choose.destroy();
		}
	private void font_choose(){
		var font_choose = new FontSelectionDialog("Choose color");
		if (font_choose.run() == ResponseType.OK){			
			FontSelection fontsl = (FontSelection)font_choose.get_font_selection();					
			settings_manager.font_family = fontsl.get_font_name();
			font.set_text(fontsl.get_font_name());
			}			
			font_choose.destroy();
		}
	private void choose_color_font(){
		var color_choose = new ColorSelectionDialog("Choose color");
		if (color_choose.run() == ResponseType.OK){			
			ColorSelection colorsl = (ColorSelection)color_choose.get_color_selection();
			Color co;
			colorsl.get_current_color(out co);
			float r;
			float g;
			float b;
			r = co.red;
			g = co.green;
			b = co.blue;
			settings_manager.font_color = "#%02x%02x%02x".printf((int) r >> 8,(int) g >> 8,(int) b >> 8);
			f_color.set_text(settings_manager.font_color);			
			
			}			
			color_choose.destroy();
		}
	public void save_config(){					
		settings_manager.update();
		if (file_link.get_text() != "") {system("pcmanfm --set-wallpaper="+file_link.get_text()+" --wallpaper-mode=stretch");
			var file = File.new_for_path(Environment.get_home_dir()+"/.config/lxpanel/default/panels/panel");
			if (file.query_exists() == true){
			file.delete();
			file.create(0,null);
			string content = "# lxpanel <profile> config file. Manually editing is not recommended."+
				"# Use preference dialog in lxpanel to adjust config when you can."+
					"\nGlobal {\n"+
						"edge=top\n"+
						"allign=center\n"+
						"margin=0\n"+
						"widthtype=percent\n"+
						"width=8\n"+
						"height=26\n"+
						"transparent=1\n"+
						"tintcolor=#000000"+
						"\nalpha=0\n"+
						"autohide=0\n"+
						"heightwhenhidden=2\n"+
						"setdocktype=1\n"+
						"setpartialstrut=0\n"+
						"usefontcolor=1\n"+
						"fontsize=10\n"+
						"fontcolor=#000000\n"+
						"usefontsize=0\n"+
						"background=0\n"+
						"backgroundfile=/usr/share/lxpanel/images/background.png\n"+
						"iconsize=24\n"+
					"}\n\nPlugin {\n	\ntype = tray\n	}\nPlugin {\ntype = volumealsa\n}\nPlugin {\ntype = launchbar \nConfig {\nButton {\nid=lubuntu-logout.desktop\n}\n}\n}";
				FileUtils.set_contents(file.get_path(), content, content.length);
				system("killall lxpanel");
				system("lxpanel &");}
			}
		if (color.get_text() != ""){
			var file = File.new_for_path(Environment.get_home_dir()+"/.config/lxpanel/default/panels/panel");
			if (file.query_exists() == true){
			file.delete();
			file.create(0,null);
			string content = "# lxpanel <profile> config file. Manually editing is not recommended."+
				"# Use preference dialog in lxpanel to adjust config when you can."+
					"\nGlobal {\n"+
						"edge=top\n"+
						"allign=center\n"+
						"margin=0\n"+
						"widthtype=percent\n"+
						"width=8\n"+
						"height=26\n"+
						"transparent=1\n"+
						"tintcolor="+color.get_text()+
						"\nalpha=255\n"+
						"autohide=0\n"+
						"heightwhenhidden=2\n"+
						"setdocktype=1\n"+
						"setpartialstrut=0\n"+
						"usefontcolor=1\n"+
						"fontsize=10\n"+
						"fontcolor=#000000\n"+
						"usefontsize=0\n"+
						"background=0\n"+
						"backgroundfile=/usr/share/lxpanel/images/background.png\n"+
						"iconsize=24\n"+
					"}\n\nPlugin {\n	\ntype = tray\n	}\nPlugin {\ntype = volumealsa\n}\nPlugin {\ntype = launchbar \nConfig {\nButton {\nid=lubuntu-logout.desktop\n}\n}\n}";
				FileUtils.set_contents(file.get_path(), content, content.length);
				system("killall lxpanel");
				system("lxpanel &");	}
			}
		main_page.load_style();		
		//main_page.load_style();
		}
	public void reset_config(){
		file_link.set_text("/etc/xdg/lxlauncher/background.png");
		settings_manager.background = "/etc/xdg/lxlauncher/background.png";
		save_config();
		}
	public void cancel_config(){
		hide_on_delete();
		}
	public void background_setup(){
			Box bg = new Box(Orientation.HORIZONTAL,5);	
			bg.set_homogeneous(true);							
			Box bg1 = new Box(Orientation.HORIZONTAL,5);				
			bg1.set_homogeneous(true);			
			file_link = new Entry();			
			file_link.set_text(settings_manager.background);			
			ToolButton open = new ToolButton.from_stock(Stock.OPEN);
			open.clicked.connect(open_file);
			//file_link.set_size_request(200,-1);			
			bg.pack_start(new Label("Desktop Image: "),true,false);
			bg.pack_start(file_link,true,false);
			//CheckButton t1 = new CheckButton.with_label("");
			/*Box bgo = new Box(Orientation.HORIZONTAL,5);
			RadioButton tiles = new RadioButton.with_label_from_widget(null,"Tiles");
			if (settings_manager.bg_option == 0) tiles.set_active(true);			
			bgo.pack_start(tiles,true,false);
			tiles.toggled.connect(radio_select2);
			RadioButton stretch = new RadioButton.from_widget(tiles);
			stretch.set_label("Stretch");
			stretch.toggled.connect(radio_select2);
			bgo.pack_start(stretch,true,false);
			if (settings_manager.bg_option == 2) stretch.set_active(true);
			RadioButton center = new RadioButton.from_widget(tiles);
			center.set_label("Center");
			center.toggled.connect(radio_select2);
			if (settings_manager.bg_option == 1) center.set_active(true);
			bgo.pack_start(center,true,false);
			bgo.show_all();*/
			bg1.pack_start(new Label("Background Color: "),true,false);
			bg.pack_start(open,true,false);
			color = new Entry();			
			//color.set_size_request(200,-1);
			ToolButton color_picker = new ToolButton.from_stock(Stock.COLOR_PICKER);
			bg1.pack_start(color,true,false);
			bg1.pack_start(color_picker,true,false);
			color_picker.clicked.connect(choose_color);			
			//bg.set_spacing(25);
			bg.set_margin_left(15);
			//bg1.set_spacing(10);
			bg1.set_margin_left(20);
			Box button = new Box(Orientation.HORIZONTAL,5);
			Button reset = new Button.with_label("Reset");
			reset.clicked.connect(reset_config);
			Button cancel = new Button.from_stock(Stock.CANCEL);
			cancel.clicked.connect(cancel_config);
			Button save = new Button.from_stock(Stock.SAVE);			
			save.clicked.connect(save_config);
			button.pack_end(reset,true,false);
			button.pack_end(cancel,true,false);
			button.pack_end(save,true,false);
			button.show_all();
			bg1.show_all();			
			background.set_margin_top(15);
			background.set_margin_bottom(15);
			background.pack_start(bg,true,false);
			//background.pack_start(bgo,true,false);
			background.pack_start(bg1,true,false);
			background.pack_start(button,true,false);
			bg.show_all();
			background.show_all();
			}
		public static void radio_select(ToggleButton button){				
			var name = button.get_label();
			if(button.get_active())
			{
					if(name == "Text") settings_manager.option_view_tabs = 0;
					if(name == "Icons") settings_manager.option_view_tabs = 1;
					if(name == "Text + Icons") settings_manager.option_view_tabs = 2;
			}			
			}	
		/*public static void radio_select2(ToggleButton button){				
			var name = button.get_label();
			if(button.get_active())
			{
					if(name == "Tiles") settings_manager.bg_option = 0;
					if(name == "Center") settings_manager.bg_option = 1;
					if(name == "Stretch") settings_manager.bg_option = 2;
			}			
			}*/	
		public void save_view(){
			//save_config();
			settings_manager.update();			
			main_page.destroy();			
			LxLauncher.Main.init();			
			main_page.show_all();
			LxLauncher.Main.main_page.searchview.set_visible(false);
			//main_page.tab_box.set_visible(false);
			//main_page.clear_all();
			}	
		public void tabs_setup(){
			Box bg = new Box(Orientation.HORIZONTAL,5);
			bg.set_homogeneous(true);
			bg.pack_start(new Label("Font Color: "),true,false);
			f_color = new Entry();
			ToolButton color_picker = new ToolButton.from_stock(Stock.COLOR_PICKER);
			bg.pack_start(f_color,true,false);
			bg.pack_start(color_picker,true,false);
			color_picker.clicked.connect(choose_color_font);			
			Box font_box = new Box(Orientation.HORIZONTAL,5);						
			//font_box.set_spacing(20);
			font_box.set_homogeneous(true);
			font_box.pack_start(new Label("Font            "),true, false);
			font = new Entry();
			font_box.pack_start(font,true,false);
			ToolButton font_dialog = new ToolButton.from_stock(Stock.SELECT_FONT);
			font_dialog.clicked.connect(font_choose);
			font_box.pack_start(font_dialog,true,false);
			font_box.show_all();
			Box option_tab = new Box(Orientation.HORIZONTAL,5);
			Label ss = new Label("Show on tabs");
			option_tab.pack_start(ss,true,false);					
			option_tab.set_homogeneous(true);
			Box option_tab1 = new Box(Orientation.VERTICAL,5);			
			tabs_text = new RadioButton.with_label_from_widget(null,"Text");
			tabs_text.toggled.connect(radio_select);
			if (settings_manager.option_view_tabs == 0) tabs_text.set_active(true);
			tabs_icon = new RadioButton.from_widget(tabs_text);
			tabs_icon.set_label("Icons");
			tabs_icon.toggled.connect(radio_select);
			if (settings_manager.option_view_tabs == 1) tabs_icon.set_active(true);
			tabs_all = new RadioButton.from_widget(tabs_text);
			tabs_all.set_label("Text + Icons");
			tabs_all.toggled.connect(radio_select);
			if (settings_manager.option_view_tabs == 2) tabs_all.set_active(true);
			option_tab1.pack_start(tabs_text,true,false);
			option_tab1.pack_start(tabs_icon,true,false);
			option_tab1.pack_start(tabs_all,true,false);
			option_tab1.show_all();
			option_tab1.set_margin_right(30);
			option_tab.pack_start(option_tab1,true,false);
			option_tab.show_all();
			Box button = new Box(Orientation.HORIZONTAL,5);						
			Button cancel = new Button.from_stock(Stock.CANCEL);
			cancel.clicked.connect(cancel_config);
			Button save = new Button.from_stock(Stock.SAVE);			
			save.clicked.connect(save_view);			
			button.pack_end(cancel,true,false);
			button.pack_end(save,true,false);
			button.show_all();
			tabs.set_margin_top(20);
			tabs.set_margin_bottom(20);
			tabs.pack_start(bg,true,false);	
			tabs.pack_start(font_box,true,false);	
			tabs.pack_start(option_tab,true,false);	
			tabs.pack_start(button,true,false);
			bg.show_all();	
			tabs.show_all();
			}
		public void save_favourite(){
			if (show_favourite.get_active()){
				main_page.favourite_box.set_visible(true);
				}else main_page.favourite_box.set_visible(false);
			}
		public void favourite_setup(){
			Box bg = new Box (Orientation.HORIZONTAL,5);
			show_favourite = new CheckButton.with_label("Show Favourite bar in Home tab");
			if (main_page.favourite_box.get_visible()) show_favourite.set_active(true); else show_favourite.set_active(false);
			bg.pack_start(show_favourite,true,false);
			bg.show_all();
			Box button = new Box(Orientation.HORIZONTAL,5);
			Button save = new Button.from_stock(Stock.SAVE);
			save.clicked.connect(save_favourite);
			button.pack_start(save,true,false);
			Button cancel = new Button.from_stock(Stock.CANCEL);
			cancel.clicked.connect(cancel_config);
			button.pack_start(cancel,true,false);
			button.show_all();			
			favourite.pack_start(bg,true,false);
			favourite.pack_start(button,true,false);
			favourite.show_all();
			}
		public void setui(){
			background = new Box(Orientation.VERTICAL, 5);			
			tabs = new Box(Orientation.VERTICAL, 5);
			favourite = new Box(Orientation.VERTICAL, 5);
			main = new Notebook();
			main.show_tabs = true;
			main.append_page(background,new Label("Background"));
			main.append_page(tabs,new Label("Tabs"));
			main.append_page(favourite,new Label("Favourites"));
			background_setup();
			tabs_setup();
			favourite_setup();
			main.show_all();
			this.add(main);
			}
		
		public PreferencesSetting(){					
			//app = new Gtk.Application("lxlauncher_setting",GLib.ApplicationFlags.IS_LAUNCHER);			
			set_title("Preferences Settings");			 			            
            hide_on_delete();                     
            //set_default_size(300,300);            
            set_resizable(false);            
            setui();
            set_modal(true);
            //set_application(app);
            set_position(WindowPosition.CENTER);  
            decorated = true;  
                			
            //stick();  	                    
			}
    }
}
