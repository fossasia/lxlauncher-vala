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
using LxLauncher.Misc;

namespace LxLauncher.Backend {
    public class App : Object {
        public string name { get; private set; }
        public string comment { get; private set; }
        public string icon { get; private set; }
        public string exec { get; private set; }
        public string desktop_id { get; private set; }
        
        public void launch () {
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
        
        public App (CacheItem item) {
            name = item.get_name();
            comment = item.get_comment() ?? name;
            icon = item.get_icon() ?? "system-execute";
            exec = ((CacheApp) item).get_exec();
            desktop_id = item.get_file_basename();
        }
    }
}