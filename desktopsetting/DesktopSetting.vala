using Posix;
using Gtk;
using Gdk;
public SettingsManager settings_manager;
public class DesktopSetting: Gtk.Window
		{						
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
            settings_manager.background =  file_chooser.get_filename ();        
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
	public void reset_config(){
		file_link.set_text("/etc/xdg/lxlauncher/background.png");
		settings_manager.background = "/etc/xdg/lxlauncher/background.png";
		save_config();
		}
	public void save_config(){		
		settings_manager.update();
		system("killall lxlauncher");
		system("./lxlauncher &");
		}
	public void cancel_config(){		
		exit(0);
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
			background.pack_start(bg1,true,false);
			background.pack_start(button,true,false);
			bg.show_all();
			background.show_all();
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
			tabs_text = new RadioButton.with_label(null,"Text");
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
			save.clicked.connect(save_config);			
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
		/*public void save_favourite(){
			if (show_favourite.get_active()){
				settings_manager.favourites_pos = 1;
				}else settings_manager.favourites_pos = 0;
				save_config();
			}
		public void favourite_setup(){
			Box bg = new Box (Orientation.HORIZONTAL,5);
			show_favourite = new CheckButton.with_label("Show Favourite bar in Home tab");
			if (settings_manager.favourites_pos != 0) show_favourite.set_active(true);
			destroy.connect(Gtk.main_quit);
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
			}*/
		public void setui(){
			background = new Box(Orientation.VERTICAL, 5);			
			tabs = new Box(Orientation.VERTICAL, 5);
			favourite = new Box(Orientation.VERTICAL, 5);
			main = new Notebook();
			main.show_tabs = true;
			main.append_page(background,new Label("Background"));
			main.append_page(tabs,new Label("Tabs"));
			//main.append_page(favourite,new Label("Favourites"));
			background_setup();
			tabs_setup();
			//favourite_setup();
			main.show_all();
			this.add(main);
			}
				
		public DesktopSetting(){
					set_title("Desktop Settings");					
					settings_manager = new SettingsManager(profile);							            				
					//set_default_size(300,300);            
					set_resizable(false);            
					setui();
					set_modal(true);
					//set_application(app);
					set_position(WindowPosition.CENTER);  
					decorated = true;  									
	 }
		}	
    
    public class SettingsManager : Object {
        private KeyFile config;
        private File file;
        public string menu_path = "";
        public int icon_size { get; private set; }
        public int columns { get; private set; }
        public int favourites_pos;
        public int screen_width { get; private set; }
        public int screen_height { get; private set; }
        public int option_view_tabs;
        public string[] favourites { get; private set; }
        public string css_style { get; private set; }
        public string background ;
        public int bg_option;
        public string font_family;              
        public string font_color;
        public string tab_bgcolor;
        private string load_background(){
			try{
				return config.get_string("CSS","background");				
				}catch(Error e){				
				}
				return "";
		}
		private string load_bgtab(){
			try{
				return config.get_string("CSS","bg-color");				
				}catch(Error e){				
				}
				return "";
			}
		
		private string load_font_family(){
			try{
				return config.get_string("CSS","font");
				}catch(Error e){}
				return "";
			}
		
		private string load_font_color(){
			try{
				return config.get_string("CSS","font-color");
				}catch(Error e){}
				return "";
			}
		private string init_css_style(){
			string tmp;
			tmp ="";
			background = load_background();
			font_family = load_font_family();			
			font_color = load_font_color();
			tab_bgcolor = load_bgtab();
			if (background != "") 
				{					
					tmp += "GtkViewport {background:url('"+background+"'); }\n";					
				}
			else tmp+="GtkViewport {background-image:none;}\n";
			if (font_family != "") tmp+="GtkWindow#lxlauncher {font:"+font_family+";}\n";			
			if (font_color != "") tmp+="GtkWidget {color:"+font_color+";}\n";
			if (tab_bgcolor != "") tmp+="GtkViewport {background-color:"+tab_bgcolor+";}\n";			
			tmp+="\nGtkTreeView{background-color:rgba(0,0,0,0);}";		
			return tmp;
			}
        private string[] load_favourites_launchers () {
            try {
                return config.get_keys("Favourites");
            } catch (Error err) {
                
            }
            return {};
        }
        
        private string load_menu_path () {
            try {
                return config.get_string("General", "menu");
            } catch (Error err) {
               
            }
            return "";
        }
    
        
        private int load_n_column () {
            try {
                return config.get_integer("Interface", "columns");
            } catch (Error err) {
               
            }
            return 6;
        }
        private int load_option_view () {
            try {
                return config.get_integer("Interface", "view");
            } catch (Error err) {
                
            }
            return 2;
        }
        private int load_favourites_pos () {
            try {
                return config.get_integer("Favourites", "position");
            } catch (Error err) {
                
            }
            return -1;
        }
        /*private int load_bg_option(){
			try {
                return config.get_integer("CSS", "bg_option");
            } catch (Error err) {
              
            }
            return 2;
			}*/
 
        private bool compare_arrays (string[] first, string[] second) {
            int x;
            for (x = 0; x <= first.length; x++) {
                if (first[x] != second[x]) {
                    return false;
                }
            }
            return true;
        }        
        private string init_file () {
			if (menu_path == "")  config.set_string("General", "menu", "/etc/xdg/lubuntu/menus/lxgames-applications.menu");  else
				config.set_string("General", "menu", menu_path);
            config.set_integer("Interface", "columns", 9);            
            if (option_view_tabs == -1) config.set_integer("Interface","view",2);else config.set_integer("Interface","view",option_view_tabs);
            if (favourites_pos != -1) config.set_integer("Favourites","position",favourites_pos);
            config.set_string("Favourites", "pcmanfm", "pcmanfm.desktop");
            if (background != "") config.set_string("CSS","background",background);
            if (font_family != "") config.set_string("CSS","font",font_family);            
            if (font_color != "") config.set_string("CSS","font-color",font_color);
            if (tab_bgcolor != "") config.set_string("CSS","bg-color",tab_bgcolor);
            if (bg_option == -1 ) config.set_integer("CSS","bg_option",2);else config.set_integer("CSS","bg_option",bg_option);
            return config.to_data();
        }
        
        private void fill_file (File file) {
			try{
            file.create(0, null);          
            string default_content = "[General]\n[Interface]\n[Favourites]\n[CSS]\n";
            FileUtils.set_contents(file.get_path(), default_content, default_content.length);
            config.load_from_file(file.get_path(), 0);
            default_content = init_file();
            FileUtils.set_contents(file.get_path(), default_content, default_content.length);
		}catch(Error e){}
        }            			
        private void load_keys () {
            menu_path = load_menu_path();
            icon_size = 6;//load_icon_size();
            columns = load_n_column();
            option_view_tabs = load_option_view();           
            css_style = init_css_style();//"GtkWindow#lxlauncher {background-image:url('/home/honnguyen/.config/lxlauncher/background.png');}";            
            string[] raw_launchers = load_favourites_launchers();
            if (raw_launchers.length > 0 && raw_launchers.length != favourites.length) {
                try{string favourites_tmp = config.get_string("Favourites", raw_launchers[0]);
                for (int x = 1; x <= raw_launchers.length; x++) {
                    if (raw_launchers[x] != null) {
                        favourites_tmp = string.joinv("|", {favourites_tmp, config.get_string("Favourites", raw_launchers[x])});
                    }
                }
                favourites = favourites_tmp.split("|");            
            }
                catch(Error e){}
              }
        }
        
        public void remove_key (string group, string key) {
            try{config.remove_key(group, key);}catch(Error e){}
        }
        
        public void set_string (string group, string key, string val) {
            config.set_string(group, key, val);
        }
        
        public void set_integer (string group, string key, int val) {
            config.set_integer(group, key, val);
        }
        
        public void save_changes () {
			try{
            string content = config.to_data();
            FileUtils.set_contents(file.get_path(), content, content.length);
            config.load_from_file(file.get_path(), 0);
            load_keys();
		}catch(Error e){}
        }
        public void update(){
			try{
			file.delete();
            fill_file(file);
            config.load_from_file(file.get_path(), 0);
            load_keys();
		}catch(Error e){}
		}
        public SettingsManager (string profile) {
			try{
            string[] groups = {"General", "Interface", "Favourites","CSS"};            
            background = load_background();          
            option_view_tabs = load_option_view();
            favourites_pos = load_favourites_pos();          
            font_family = "";            
            font_color = "";            
            config = new KeyFile();
            File dir = File.new_for_path(Environment.get_home_dir()+"/.config/"+"lxlauncher");            
            if (dir.query_exists() == false) { dir.make_directory_with_parents(); }
            file = File.new_for_path(dir.get_path()+"/"+profile+".conf");            
            if (file.query_exists() == false) {
                fill_file(file);
                config.load_from_file(file.get_path(), 0);
            } else {
              
                config.load_from_file(file.get_path(), 0);
            }          
            if (! compare_arrays(config.get_groups(), groups)) {
                file.delete();
                fill_file(file);
                config.load_from_file(file.get_path(), 0);
            }
            load_keys();
		}catch(Error e){				
			};
        }
    }
static string profile;
			static bool verbose = false;
			const OptionEntry entries[] = {
				{"profile", 'p', 0, OptionArg.FILENAME, out profile, "Use a custom profile"},
				{"verbose", 'v', 0, OptionArg.NONE, out verbose, "Verbose output"},
				{null}
			};      
int main(string[] args){
	Gtk.init(ref args);
	var argparse = new OptionContext("");
	argparse.add_main_entries(entries, null);
	argparse.add_group(Gtk.get_option_group(true));	
	if (profile == null) { profile = "default"; }
		try {
			argparse.parse(ref args);
			} catch (Error e) {			
					return 1;
				}
	DesktopSetting desktop = new DesktopSetting();
	desktop.show_all();
	Gtk.main();
	return 0;
	}

