//   Copyright Stephen Smally 2012
//
//      This program is free software; you can redistribute it and/or modify
//      it under the terms of the GNU General Public License as published by
//      the Free Software Foundation; either version 2 of the License, or
//      (at your option) any later version.
//      
//      This program is distributed in the hope that it will be useful,
//      but WITHOUT ANY WARRANTY; without even the implied warranty of
//      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//      GNU General Public License for more details.
//      
//      You should have received a copy of the GNU General Public License
//      along with this program; if not, write to the Free Software
//      Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
//      MA 02110-1301, USA.
//      

using Gtk;
using Gdk;
using Posix;
using LxLauncher.Backend;
using LxLauncher.Widgets;
using LxLauncher.Config;
using LxLauncher.Misc;

namespace LxLauncher.Main {
	public 	 Frontend main_page;    
    public class Frontend : Gtk.Window {
        public AppDatabase apps_db;
        public Box main;
        public Box main_2;
        public Notebook button_table;
        public SearchView searchview;
        public PreferencesBox preferences_box;
        public TabButton category_button;
        public Box tab_box;
        public Box home_box;
        public ScrolledWindow fav_scroll;        
        public LauncherGrid table;
        public FavouriteBar favourite_box;
        public SearchEntry searchentry;
        public string filter;
        public int tabs;
        public int x; // multi purpose iterator
        public int page_nth;
        public Pixbuf pixbuf;
        public Widget widget;      
        public StyleContext stylecontext;        
		public CssProvider css_style;	
		public Screen scr;  
		
        public void setup_ui () {
            main = new Box(Orientation.VERTICAL, 5);
            //main.set_border_width(40);                                               
            
            //main.set_margin_bottom(40);
            //main.set_margin_left(50);
            //main.set_margin_right(50);
            
            main_2 = new Box(Orientation.VERTICAL, 5);                      
            //Box favourite_box_center = new Box(Orientation.VERTICAL, 0);
            
            searchentry = new SearchEntry("Search Applications...");
            searchentry.changed.connect(on_search);
            
            Box tab_box_vertical = new Box(Orientation.VERTICAL, 0);
            
            Box tab_box_2 = new Box(Orientation.HORIZONTAL, 5);
            
            tab_box = new Box(Orientation.HORIZONTAL, 5);
            
            button_table = new Notebook();
            button_table.show_tabs = false;
            button_table.show_border = false;          
            //searchview = new SearchView();                    
            
            ;               
            //tab_box_2.pack_start(searchentry, false, false, 0);            
            tab_box_vertical.pack_start(tab_box, true, true, 0);                                
            tab_box_2.pack_start(tab_box_vertical, true, true, 0);
            
            
            //favourite_box_center.pack_start(favourite_box, true, false, 0);            
            			
            //main_2.pack_start(favourite_box, false, false, 0); 
            
            main_2.pack_start(button_table, true, true, 0);            
            //main_2.pack_start(searchview, true, true, 0);
           
            
            
            //main.pack_start(se,false,false,0);
            main.set_homogeneous(false);
            main.pack_start(tab_box_2, false, false, 0);                          
            main.pack_start(main_2, true, true, 0);            
            add(main);
            category_button = null;
            tabs = 0;          
        }
		public void on_search (Editable ed) {
            filter = searchentry.get_text();
            searchview.clear();
            if (filter == "") {
                tab_box.set_sensitive(true);
                searchview.set_visible(false);
                //button_table.set_visible(true);
                favourite_box.set_visible(true);
            } else {
                tab_box.set_sensitive(false);
                searchview.set_visible(true);
                favourite_box.set_visible(false);
               // button_table.set_visible(false);
                foreach (Category categ in apps_db.categories) {
                    foreach (App app in apps_db.apps_by_category[categ]) {
                        if ((filter in app.name || filter in app.comment || filter in app.exec) && ! (app.desktop_id in searchview.added_items)) {
                            searchview.append_app(app);
                        }
                    }
                }
            }
        }          
        
        public void append_favourite (App favourite) {
            favourite_box.add_favourite(favourite);
        }
        
        public void append_favourites () {
            foreach (Gee.ArrayList<App> array in apps_db.apps_by_category.values) {
                foreach (App app in array) {
                    if (app.desktop_id in settings_manager.favourites) {
                        append_favourite(app);
                    }
                }
            }
        }
        
        public void change_page (Button widget) {
            int ind = ((TabButton)widget).number;  
            //stderr.printf("%d",ind);                      
            button_table.set_current_page(ind);
        }
        
        public void foreach_category (Category item) {
            print_debug("Parsing category "+item.id);
            
            table = new LauncherGrid(settings_manager.columns);
            
            foreach (App app in apps_db.apps_by_category[item]) {
                if (app.desktop_id in settings_manager.favourites) {
                    append_favourite(app);                    
                }
                table.append_launcher(app);
                print_debug("Appending "+app.name);
            }
            table.complete_grid();            
            Box table_box = new Box(Orientation.VERTICAL, 0);
            var scroll = new ScrolledWindow(null,null);         
            scroll.set_placement(Gtk.CornerType.TOP_LEFT);
            scroll.add_with_viewport(table);            
            table_box.pack_start(scroll, true, true, 0);
           
            //table_box.pack_start(table, false, false, 0);
            
            button_table.append_page(table_box, null);
            table_box.show_all();
            
            category_button = new TabButton(category_button, item, tabs);
                                    
            (Button) category_button.clicked.connect(change_page);
            Separator se = new Separator(Orientation.VERTICAL);
            tab_box.pack_start(se,false,false,0);
            tab_box.pack_start(category_button, false, false, 0);
            category_button.show_all();
            tabs++;
        }
        
        public void clear_all () {
            x = 0;
            page_nth = button_table.get_n_pages();
            while (x != page_nth) {
                button_table.remove_page(0);
                x++;
            }
            tabs = 0;
            tab_box.foreach((widget) => {
                widget.destroy();
            });
            category_button = null;
            favourite_box.foreach((widget) => {
                widget.destroy();
            });
        }       
        public void setup_launchers () {
            clear_all();
            apps_db.get_applications();
            //home_table = new LauncherGrid(settings_manager.columns);                                   
            Box home_table_box = new Box(Orientation.VERTICAL, 0);
            home_box = new Box (Orientation.VERTICAL,0);                    
            home_table_box.expand = true;           
            var scroll = new ScrolledWindow(null,null);    
            searchentry.set_margin_left(20);
            searchentry.set_margin_right(20);
            searchentry.set_margin_top(10);
            home_table_box.pack_start(searchentry,false,false,0);
            home_table_box.pack_start(home_box,true,true,0);
            favourite_box = new FavouriteBar();             
            favourite_box.set_orientation(Orientation.HORIZONTAL);                       
            home_box.pack_start(favourite_box, false, false, 0);
            //if (settings_manager.favourites_pos == 0) favourite_box.set_visible(false);  else favourite_box.set_visible(true);
            searchview = new SearchView();    
            searchview.set_margin_top(10);                     
            searchview.set_margin_bottom(10);   
            searchview.set_margin_right(20);
            searchview.set_margin_left(20);
            searchview.set_size_request(searchview.width_request,button_table.height_request);
            home_box.pack_start(searchview,true,true,0);  
            scroll.add_with_viewport(home_table_box);                                
            button_table.append_page(scroll, null);
            home_table_box.show_all();            
            category_button = new TabButton.custom(category_button,"folder-home","Home","Home Tab",0);   
            Separator se = new Separator(Orientation.VERTICAL);
            tab_box.pack_start(se,false,false,0);         
            tab_box.pack_start(category_button,false,false,0);
            (Button) category_button.clicked.connect(change_page);
            category_button.show_all();
            tabs++;                     
            foreach (Category categ in apps_db.categories) {
                foreach_category(categ);
            }
            Viewport utils_port = new Viewport(null,null);
            Box utils_box = new Box(Orientation.HORIZONTAL,0);
            utils_port.name = "utils";
            Button wifi = new Button(); 
            wifi.set_image(new Image.from_icon_name("gtk-network",IconSize.LARGE_TOOLBAR));
            wifi.clicked.connect(()=>{
				system("wicd-client -n");
				});
            Button shutdown = new Button();
            shutdown.set_image(new Image.from_icon_name("system-shutdown",IconSize.LARGE_TOOLBAR));
            shutdown.clicked.connect(() => {
				system("lxsession-logout --banner '/etc/xdg/lxlauncher/logout-banner.png' --side=top");
				});
            VolumeButton volume = new VolumeButton();
            volume.set_value(0.5);                        
            volume.value_changed.connect(()=>{
				string command = "amixer set Master "+ (volume.get_value()*100).to_string();			
				system(command +"% ");
				});
            utils_box.pack_start(wifi,false,false,0);
            utils_box.pack_start(volume,false,false,0);
            utils_box.pack_start(shutdown,false,false,0);
            utils_port.add(utils_box);
            tab_box.pack_start(utils_port,true,false,0);
        }         
        
        public void settings_changed_manager (ParamSpec param) { 						
                    favourite_box.foreach((widget) => {
                        widget.destroy();
                    });
                    append_favourites();                             
        }
        public void load_style(){
			stylecontext.reset_widgets(scr);
			stylecontext.add_provider_for_screen(scr,css_style, 800);			
			try{css_style.load_from_data(settings_manager.css_style,-1);	}catch(Error e){}
			}       
        public Frontend () {			
            apps_db = new AppDatabase(settings_manager.menu_path);
            set_title("LxLauncher");                       
            set_position(WindowPosition.CENTER);            
            name = "lxlauncher";
            css_style = new CssProvider();  			                    
            stylecontext = new StyleContext();	
			scr = Screen.get_default();			
            set_default_size(settings_manager.screen_width, settings_manager.screen_height);           
            set_keep_below(true);             	
            decorated = false;
            skip_taskbar_hint = true;
            skip_pager_hint = true;
            setup_ui();
            maximize();
            stick();
            //show_all();
            setup_launchers();
            load_style();
			searchview.set_visible(false);                              
            settings_manager.notify.connect(settings_changed_manager);
            apps_db.cache.add_reload_notify((Func) setup_launchers);
          
        }        
    }
    public void init(){
			main_page = new Frontend();			
			}
}

static string profile;
static bool verbose = false;

const OptionEntry entries[] = {
    {"profile", 'p', 0, OptionArg.FILENAME, out profile, "Use a custom profile"},
    {"verbose", 'v', 0, OptionArg.NONE, out verbose, "Verbose output"},
    {null}
};

int main (string[] args) {
    Gtk.init(ref args);
    var argparse = new OptionContext("");
    argparse.add_main_entries(entries, null);
    argparse.add_group(Gtk.get_option_group(true));
    if (profile == null) { profile = "default"; }
    try {
        argparse.parse(ref args);
    } catch (Error e) {
        //stderr.printf("%s\n", e.message);
        return 1;
    }
    LxLauncher.Config.init();    
    //system("killall lxpanel");    
    //system("lxpanel &");
    LxLauncher.Main.init();
    LxLauncher.Main.main_page.show_all();
    LxLauncher.Main.main_page.searchview.set_visible(false);    
    Gtk.main();
    return 0;
}
