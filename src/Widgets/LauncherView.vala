
using Gtk;
using LxLauncher.Backend;

namespace LxLauncher.Widgets {
    public class LauncherGrid : Box {
        public Launcher launcher_child;
        private Box chil;
        private int n_rows;
        private int n_columns;
        public int children { get; private set; }
        
        public void append_launcher (App item) {            
            if (children == n_columns) {
                children = 0;
                chil = new Box(Orientation.HORIZONTAL, 5);
                chil.homogeneous = true;
                pack_start(chil, false, false, 0);
                n_rows++;
            }
            
            launcher_child = new Launcher(item, false, false);
            
            chil.pack_start(launcher_child, true, true, 0);
            launcher_child.show_all();
            children++;
        }
        
        public void complete_grid () {
            while (children != n_columns) {
                Image placeholder = new Image();
                chil.pack_start(placeholder, true, true, 0);
                placeholder.show();
                children++;
            }
        }
        
        public LauncherGrid (int columns) {
            orientation = Orientation.VERTICAL;
            spacing = 5;
            homogeneous = true;
            n_columns = columns;
            n_rows = 1;
            children = 0;
            chil = new Box(Orientation.HORIZONTAL, 5);
            chil.homogeneous = true;
            pack_start(chil, false, false, 0);
        }
    }
}
