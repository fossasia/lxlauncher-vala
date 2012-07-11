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

using MenuCache;
using Gee;

namespace LxLauncher.Backend {
    public class AppDatabase : Object {
        private string path;
        public Cache cache;
        private unowned CacheDir cache_dir;
        private SList<CacheItem> cache_apps;
        private Category category_temp;
        private App app_temp;
        private ArrayList<App> apps_owned_by_category;
        public ArrayList<Category> categories; // Needed to get the proper categories sorting
        public HashMap<Category, ArrayList<App>> apps_by_category;
        
        void add_app_2 (CacheItem cache_item) {
            MenuCache.Type item_type = cache_item.get_type ();
            
            if (item_type != MenuCache.Type.SEP ) {
                if (item_type == MenuCache.Type.DIR) {
                    category_temp = new Category(cache_item);
                    categories.add(category_temp);
                    apps_owned_by_category = new ArrayList<App>();
                    apps_by_category[category_temp] = apps_owned_by_category;
                } else {
                    app_temp = new App(cache_item);
                    apps_owned_by_category.add(app_temp);
                }
            }
        }
    
        public void add_app (CacheDir cache_dir) {
            unowned SList<CacheItem?> item_list = cache_dir.get_children ();
        
            while (item_list != null) {
                
                CacheItem cache_item = item_list.data;
                MenuCache.Type item_type = cache_item.get_type();
                
                if ((item_type == MenuCache.Type.APP) && ((CacheApp) cache_item).get_is_visible (MenuCache.Show.IN_LXDE) == false) {
                    item_list = item_list.next;
                    continue;
                }
                
                add_app_2(cache_item);
                
                if (item_type == MenuCache.Type.DIR) {
                    add_app ((CacheDir) cache_item);
                }
                
                item_list = item_list.next;
            }
        }
        
        public void get_applications () {
            categories.clear();
            apps_by_category.clear();
            cache_apps = new SList<CacheItem>();
            cache = Cache.lookup_sync (path);
            cache_dir = cache.get_root_dir ();
            
            add_app(cache_dir);
        }
        
        public AppDatabase (string pathname) {
            path = pathname;
            categories = new ArrayList<Category>();
            apps_by_category = new HashMap<Category, ArrayList<App>>();
        }
    }
}
