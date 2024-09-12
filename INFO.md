# Custom Keybindings Location
``/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/``

- Create a new folder in here has the following keys:
``binding:'<Control><Alt>Delete'``
``command:'flatpak run io.missioncenter.MissionCenter'``
``name:'Launch Task Manager'``

``/org/gnome/settings-daemon/plugins/media-keys``
- Each subdir in here represents a different section in the settings menu for the shortcuts


- Custom Shortcut Launch Task Manager
`` dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/binding "<Control><Alt>Delete" ``
`` dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/command "flatpak run io.missioncenter.MissionCenter" ``
`` dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/name "Launch Task Manager" ``

- Launch Filebrowser
`` dconf write /org/gnome/settings-daemon/plugins/media-keys/home "['<Super>e']" ``

- Launch Settings
`` dconf write /org/gnome/settings-daemon/plugins/media-keys/control-center "['<Super>i']" ``

- Launch Calculator
`` dconf write /org/gnome/settings-daemon/plugins/media-keys/calculator "['<Super>c']" ``

- Proper Alt-Tab
`` dconf write /org/gnome/desktop/wm/keybindings/switch-applications "['']" ``
`` dconf write /org/gnome/desktop/wm/keybindings/switch-applications-backward "['']" ``

`` dconf write /org/gnome/desktop/wm/keybindings/switch-windows "['<Alt>Tab']" ``
`` dconf write /org/gnome/desktop/wm/keybindings/switch-windows-backward "['<Shift><Alt>Tab']" ``

- Proper Screenshot
`` dconf write /org/gnome/shell/keybindings/show-screenshot-ui "['<Shift><Super>s']" ``

- Disable Logout Shortcut
`` dconf write /org/gnome/settings-daemon/plugins/media-keys/logout "['']" ``

- Run Dialogue
`` dconf write /org/gnome/desktop/wm/keybindings/panel-run-dialog "['<Super>r']" ``


# KDE
- Install theme
- Install cursors
- Apply all
- 
- Apply this rule to pip window https://preview.redd.it/bnx33qcy5qd71.png?width=625&format=png&auto=webp&s=d2947e2f41a509d4467f50afa6a0680f3eff94dd 
- https://www.reddit.com/r/kde/comments/osjt3p/firefox_wayland_pip_workaround_or_how_i_learned/