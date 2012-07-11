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

namespace LxLauncher.Backend {
    public class Category : Object {
        public string name { get; private set; }
        public string comment { get; private set; }
        public string icon { get; private set; }
        public string id { get; private set; }
        
        public Category (CacheItem item) {
            name = item.get_name();
            comment = item.get_comment() ?? "";
            icon = item.get_icon() ?? "application-default-icon";
            id = item.get_file_basename();
        }
    }
}
