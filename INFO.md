# Custom Keybindings Location
``/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/``

- Create a new folder in here has the following keys:
``binding:'<Control><Alt>Delete'``
``command:'flatpak run io.missioncenter.MissionCenter'``
``name:'Launch Task Manager'``

``/org/gnome/settings-daemon/plugins/media-keys``
- Each subdir in here represents a different section in the settings menu for the shortcuts

- Custom Shortcut Launch Task Manager
``'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/binding' '<Control><Alt>Delete'``
``'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/command' 'flatpak run io.missioncenter.MissionCenter'``
``'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/name' 'Launch Task Manager'``

- Launch Filebrowser
``/org/gnome/settings-daemon/plugins/media-keys/home '['<Super>e']'``

- Launch Settings
``/org/gnome/settings-daemon/plugins/media-keys/control-center '['<Super>i']'``

- Launch Calculator
``'/org/gnome/settings-daemon/plugins/media-keys/calculator' '['<Super>c']'``

- Proper Alt-Tab
``'/org/gnome/desktop/wm/keybindings/switch-applications' '[]'``
``'/org/gnome/desktop/wm/keybindings/switch-applications-backward' '[]'``

``'/org/gnome/desktop/wm/keybindings/switch-windows' '['<Alt>Tab']'``
``'/org/gnome/desktop/wm/keybindings/switch-windows-backward' '['<Shift><Alt>Tab']'``

- Proper Screenshot
``'/org/gnome/shell/keybindings/show-screenshot-ui' '['<Shift><Super>s']'``

- Disable Logout Shortcut
``'/org/gnome/settings-daemon/plugins/media-keys/logout' '[]'``

- Run Dialogue
``'/org/gnome/desktop/wm/keybindings/panel-run-dialog' '['<Super>r']'``