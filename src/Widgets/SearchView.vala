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
using LxLauncher.Backend;
using LxLauncher.Config;
using LxLauncher.Misc;

namespace LxLauncher.Widgets {
    public class SearchView : ScrolledWindow {
        private ListStore model;
        private TreeIter iter;
        public Gee.ArrayList<string> added_items { get; private set; }
        
        public void clear () {
            added_items.clear();
            model.clear();
        }
        
        public void launch (string exec) {
            string command;
            if ("%" in exec) {
                command = exec.split("%")[0].strip();
            } else {
                command = exec;
            }
            stdout.printf("Launching '%s'\n", command);
            try {
                Process.spawn_async(null, command.split(" "), null, SpawnFlags.SEARCH_PATH, null, null);
            } catch (Error e) {
                print_debug(e.message);
            }
        }
        
        public void on_row_activated (TreeView view, TreePath path, TreeViewColumn col) {
            model.get_iter(out iter, path);
            Value exec;
            model.get_value(iter, 3, out exec);
            launch(exec.get_string());
        }
        
        public void append_app (App app) {
            model.append(out iter);
            model.set(iter, 0, string.joinv("\n", {app.name, app.comment}), 1, app.icon, 2, settings_manager.icon_size, 3, app.exec);
            added_items.add(app.desktop_id);
        }
        
        public SearchView () {
            added_items = new Gee.ArrayList<string>();
            model = new ListStore(4, typeof(string), typeof(string), typeof(int), typeof(string));
            TreeView view = new TreeView.with_model(model);            
            view.headers_visible = false;
            view.insert_column_with_attributes(-1, "Icon", new CellRendererPixbuf(), "icon-name", 1, "stock-size", 2);
            view.insert_column_with_attributes(-1, "Name", new CellRendererText(), "text", 0);
            view.row_activated.connect(on_row_activated);
            add(view);
        }
    }
}
