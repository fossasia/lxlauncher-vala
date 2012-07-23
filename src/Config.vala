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

using Gdk;
using LxLauncher.Misc;

namespace LxLauncher.Config {
    public SettingsManager settings_manager;
    
    public class SettingsManager : Object {
        private KeyFile config;
        private File file;
        //private File css;
        public string menu_path = "";
        public int icon_size { get; private set; }
        public int columns { get; private set; }
        public int favourites_pos { get; private set; }
        public int screen_width { get; private set; }
        public int screen_height { get; private set; }
        /// public string css_path;
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
				stderr.printf("Error "+e.message);
				}
				return "";
		}
		private string load_bgtab(){
			try{
				return config.get_string("CSS","bg-color");				
				}catch(Error e){
				stderr.printf("Error "+e.message);
				}
				return "";
			}
		
		private string load_font_family(){
			try{
				return config.get_string("CSS","font");
				}catch(Error e){stderr.printf("Error "+e.message);}
				return "";
			}
		
		private string load_font_color(){
			try{
				return config.get_string("CSS","font-color");
				}catch(Error e){stderr.printf("Error "+e.message);}
				return "";
			}
		private string init_css_style(){
			string tmp;
			tmp ="";
			background = load_background();
			font_family = load_font_family();
			//font_size = load_font_size();
			font_color = load_font_color();
			tab_bgcolor = load_bgtab();
			if (background != "") 
				{
					//if (bg_option == 0) {
						tmp += "GtkWindow#lxlauncher {background:url('"+background+"'); }\n";
						//}
					//else if (bg_option == 1) tmp+="GtkWindow#lxlauncher {background:url('"+background+"') no-repeat;\nbackground-position:center;}\n";
					//else tmp+="GtkWindow#lxlauncher {background:url('"+background+"') no-repeat ;background-size:100% 100%;}\n";
				}
			else tmp+="GtkWindow#lxlauncher {background-image:none;}\n";
			if (font_family != "") tmp+="GtkWindow#lxlauncher {font:"+font_family+";}\n";
			//if (font_size != "") tmp+="GtkWindow#lxlauncher {font-size:"+font_size+";}\n";
			if (font_color != "") tmp+="GtkWidget {color:"+font_color+";}\n";
			
			if (tab_bgcolor != "") tmp+="GtkWindow#lxlauncher {background-color:"+tab_bgcolor+";}\n";
			//tmp+="\nGtkScrolledWindow, GtkViewport{background:url('/home/x-mario/bg.png') repeat;}";
			tmp+="\nGtkViewport{background-color:rgba(255,255,255,0);}";
			return tmp;
			}
        private string[] load_favourites_launchers () {
            try {
                return config.get_keys("Favourites");
            } catch (Error err) {
                stdout.printf("%s\n", err.message);
            }
            return {};
        }
        
        private string load_menu_path () {
            try {
                return config.get_string("General", "menu");
            } catch (Error err) {
                stdout.printf("%s\n", err.message);
            }
            return "";
        }
       /* private string load_css_path(){
			try{
				return Environment.get_home_dir()+"/.config/lxlauncher/"+config.get_string("CSS","css");
				}catch(Error e){stderr.printf("Error "+e.message);
			}
			return "";
		}
		/* Remove support resize icon */
        /*private int load_icon_size () {
            try {
                return config.get_integer("Interface", "icon-size");
            } catch (Error err) {
                stdout.printf("%s\n", err.message);
            }
            return 6;
        }*/
        
        private int load_n_column () {
            try {
                return config.get_integer("Interface", "columns");
            } catch (Error err) {
                stdout.printf("%s\n", err.message);
            }
            return 6;
        }
        private int load_option_view () {
            try {
                return config.get_integer("Interface", "view");
            } catch (Error err) {
                stdout.printf("%s\n", err.message);
            }
            return 2;
        }
        private int load_bg_option(){
			try {
                return config.get_integer("CSS", "bg_option");
            } catch (Error err) {
                stdout.printf("%s\n", err.message);
            }
            return 2;
			}
        
        /*private int load_favourites_pos () {
            try {
                return config.get_integer("Interface", "favourites-bar-position");
            } catch (Error err) {
                stdout.printf("%s\n", err.message);
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
            config.set_string("Favourites", "pcmanfm", "pcmanfm.desktop");
            if (background != "") config.set_string("CSS","background",background);
            if (font_family != "") config.set_string("CSS","font",font_family);
            //if (font_size != "") config.set_string("CSS","font-size",font_size);
            if (font_color != "") config.set_string("CSS","font-color",font_color);
            if (tab_bgcolor != "") config.set_string("CSS","bg-color",tab_bgcolor);
            if (bg_option == -1 ) config.set_integer("CSS","bg_option",2);else config.set_integer("CSS","bg_option",bg_option);
            return config.to_data();
        }
        
        private void fill_file (File file) {
			try{
            file.create(0, null);
            print_debug("Created new profile in ~/.config/lxlauncher/"+profile+".ini");
            string default_content = "[General]\n[Interface]\n[Favourites]\n[CSS]\n";
            FileUtils.set_contents(file.get_path(), default_content, default_content.length);
            config.load_from_file(file.get_path(), 0);
            default_content = init_file();
            FileUtils.set_contents(file.get_path(), default_content, default_content.length);
		}catch(Error e){stderr.printf("Error "+e.message);}
        }     
        /*private string init_css(){
			string bg = Environment.get_home_dir()+"/.config/lxlauncher/background.png";
			return "GtkWindow#lxlauncher {"+
				"background-image:url('"+bg+"');"+
				"}\n";
			}
        private void fill_css(File file){
			try{
				file.create(0,null);
				//config.load_from_file(file.get_path(), 0);
				string content = init_css();
				FileUtils.set_contents(file.get_path(),content,content.length);
				}
				catch(Error e){stderr.printf("Error "+e.message);
			}
		}*/
			
        private void load_keys () {
            menu_path = load_menu_path();
            icon_size = 6;//load_icon_size();
            columns = load_n_column();
            option_view_tabs = load_option_view();
            //bg_option = load_bg_option();
            //favourites_pos = load_favourites_pos();
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
                catch(Error e){stderr.printf("Error "+e.message);}
              }
        }
        
        public void remove_key (string group, string key) {
            try{config.remove_key(group, key);}catch(Error e){stderr.printf("Error "+e.message);}
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
		}catch(Error e){stderr.printf("Error "+e.message);}
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
            Screen screen = Screen.get_default();
            screen_height = screen.get_height();
            screen_width = screen.get_width();
            background = load_background();
            //stdout.printf(background);
            background = "/etc/xdg/lxlauncher/background.png";
            option_view_tabs = load_option_view();
            //bg_option = load_bg_option();
            font_family = "";            
            font_color = "";            
            config = new KeyFile();
            File dir = File.new_for_path(Environment.get_home_dir()+"/.config/"+"lxlauncher");            
            if (dir.query_exists() == false) { dir.make_directory_with_parents(); }
            file = File.new_for_path(dir.get_path()+"/"+profile+".conf");
            //css = File.new_for_path(dir.get_path()+"/lxlauncher.css");
            if (file.query_exists() == false) {
                fill_file(file);
                config.load_from_file(file.get_path(), 0);
            } else {
                print_debug("Using "+profile+" profile");
                config.load_from_file(file.get_path(), 0);
            }
           /* if (css.query_exists() == false){
				fill_css(css);
				//config.load_from_file(css.get_path(), 0);
				}*/
            if (! compare_arrays(config.get_groups(), groups)) {
                file.delete();
                fill_file(file);
                config.load_from_file(file.get_path(), 0);
            }
            load_keys();
		}catch(Error e){
			stderr.printf("Error "+e.message);			
			};
        }
    }
    
    public void init () {
        settings_manager = new SettingsManager(profile);
    }
}
