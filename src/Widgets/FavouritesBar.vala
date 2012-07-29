using Gtk;
using Gdk;
using LxLauncher.Backend;

namespace LxLauncher.Widgets {
    public class FavouriteBar : Box {
        public FavouriteLauncher launcher;
        
        public void add_favourite (App app) {
            launcher = new FavouriteLauncher(app);
            pack_start(launcher, false, false, 0);
            launcher.show_all();
        }
        
        public FavouriteBar () {
            orientation = Orientation.VERTICAL;
        }
    }
}
