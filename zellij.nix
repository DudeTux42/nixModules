{ pkgs, ... }: {
  programs.zellij = {
    enable = true;
  };

  xdg.configFile."zellij/config.kdl".text = ''

    // Zellij Configuration
    
    // Default shell
    default_shell "bash"
    
    // Theme
    theme "catppuccin"
    
    // Copy behavior
    copy_on_select false
    copy_command "wl-copy"  // For Wayland, use "xclip -selection clipboard" for X11
    
    // Mouse behavior
    mouse_mode true
    scroll_buffer_size 10000
    
    // Pane behavior
    pane_frames true
    auto_layout true
    
    // Session behavior
    session_serialization false
    
    // Keybindings
    keybinds {
        normal {
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
            
            // New tab
            bind "Alt o" { NewTab; }
            
            // Rename tab
            bind "Alt r" { SwitchToMode "RenameTab"; TabNameInput 0; }
            
            // Enter search mode
            bind "Alt /" { SwitchToMode "Search"; }
            
            // Enter scroll mode
            bind "Alt s" { SwitchToMode "Scroll"; }
        }
        
        scroll {
            bind "Ctrl c" { SwitchToMode "Normal"; }
            bind "j" "Down" { ScrollDown; }
            bind "k" "Up" { ScrollUp; }
            bind "d" { HalfPageScrollDown; }
            bind "u" { HalfPageScrollUp; }
        }
        
        search {
            bind "Ctrl c" { SwitchToMode "Normal"; }
            bind "n" { Search "down"; }
            bind "p" { Search "up"; }
        }
        
        renametab {
            bind "Ctrl c" { SwitchToMode "Normal"; }
            bind "Esc" { UndoRenameTab; SwitchToMode "Normal"; }
        }
    }
    
    // UI configuration
    ui {
        pane_frames {
            rounded_corners true
            hide_session_name false
        }
    }
    
    // Plugins
    plugins {
        tab-bar { path "tab-bar"; }
        status-bar { path "status-bar"; }
        strider { path "strider"; }
        compact-bar { path "compact-bar"; }
    }
    
    // Layout
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
