{ pkgs, ... }: {
  programs.zellij = {
    enable = true;
  };

  xdg.configFile."zellij/config.kdl".text = ''
    // --- Zellij Configuration ---
    
    default_shell "zsh"
    theme "catppuccin"
    copy_on_select true
    copy_command "wl-copy"
    mouse_mode true
    scroll_buffer_size 10000
    pane_frames true
    auto_layout true
    session_serialization false
    show_startup_tips false
    // --- Keybindings ---
    keybinds {
        // Dieser Modus reicht ALLES an Neovim weiter (SUPER wichtig!)
        locked {
            bind "Alt g" { SwitchToMode "Normal"; }
        }

        // Dein normaler Modus für Zellij-Aktionen
        normal {
            bind "Alt g" { SwitchToMode "Locked"; }
            
            // Movement between panes
            bind "Alt h" { MoveFocus "Left"; }
            bind "Alt l" { MoveFocus "Right"; }
            bind "Alt j" { MoveFocus "Down"; }
            bind "Alt k" { MoveFocus "Up"; }
            
            // Create new panes
            bind "Alt n" { NewPane "Right"; }
            bind "Alt m" { NewPane "Down"; }
            
            // Close pane
            bind "Alt q" { CloseFocus; }
            
            // Resize panes
            bind "Alt +" { Resize "Increase"; }
            bind "Alt -" { Resize "Decrease"; }
            
            // Switch tabs
            bind "Alt 1" { GoToTab 1; }
            bind "Alt 2" { GoToTab 2; }
            bind "Alt 3" { GoToTab 3; }
            bind "Alt 4" { GoToTab 4; }
            bind "Alt 5" { GoToTab 5; }
            
            // Tab Management
            bind "Alt o" { NewTab; }
            bind "Alt r" { SwitchToMode "RenameTab"; TabNameInput 0; }
            
            // Modes
            bind "Alt /" { SwitchToMode "Search"; }
            bind "Alt s" { SwitchToMode "Scroll"; }
        }

        scroll {
            bind "Ctrl c" "Esc" { SwitchToMode "Normal"; }
            bind "j" "Down" { ScrollDown; }
            bind "k" "Up" { ScrollUp; }
            bind "d" { HalfPageScrollDown; }
            bind "u" { HalfPageScrollUp; }
        }
        
        search {
            bind "Ctrl c" "Esc" { SwitchToMode "Normal"; }
            bind "n" { Search "down"; }
            bind "p" { Search "up"; }
        }
        
        renametab {
            bind "Ctrl c" "Enter" { SwitchToMode "Normal"; }
            bind "Esc" { UndoRenameTab; SwitchToMode "Normal"; }
        }

        shared_except "locked" {
            bind "Alt g" { SwitchToMode "Locked"; }
        }
    }
    
    // --- UI Configuration ---
    ui {
        pane_frames {
            rounded_corners true
            hide_session_name false
        }
    }
    
    // --- Plugins ---
    plugins {
        tab-bar { path "tab-bar"; }
        status-bar { path "status-bar"; }
        strider { path "strider"; }
        compact-bar { path "compact-bar"; }
    }
    
    // --- Layouts ---
    layouts {
        default {
            tab name="main" {
                pane size=1 borderless=true {
                    plugin location="zellij:tab-bar"
                }
                pane
                pane size=2 borderless=true {
                    plugin location="zellij:status-bar"
                }
            }
        }
    }
  '';
}
