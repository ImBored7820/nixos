{config,lib, pkgs, inputs, stable, hyprland, ... }:
{
  home.username = "musa";
  home.homeDirectory = "/home/musa";
  home.stateVersion = "25.11";
  
  # Packages
  home.packages = with pkgs; [
    # Main
    discord
    spotify
    brave
    nautilus
    jetbrains.idea-ultimate
    pkgs.jdk25
    waybar
    dunst
    hyprpaper
    hyprcursor
    hyprlauncher
    hyprlock
    hypridle
    hyprpicker
    hyprsunset
    hyprsysteminfo
    hyprpolkitagent
    hyprland-protocols
    hyprland-qtutils
    #hyprqt6engine
  ];

  # Program Settings

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "ImBored7820";
	email = "mohammedmusaali549@gmail.com";
      };
    };
  };

  home.sessionVariables = {
    _JAVA_AWT_WM_NONREPARENTING = "1";
    "-Dwayland.enabled" = "true";
    GDK_SCALE = "1.5";
    "_JAVA_OPTIONS" = "-Dsun.java2d.uiScale=1.5";
  };

  programs.kitty = {
    enable = true;
    settings = {
      # Shell and Cursor
      shell_integration = "no-rc";
      cursor_shape = "beam";

      # Tab Bar Configuration
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      tab_bar_min_tabs = 1;

      # Miscellaneous
      editor = "neovim";
    };

    keybindings = {
      "ctrl+t" = "new_tab_with_cwd";
      "ctrl+w" = "close_tab"; 
    };  
  };

      programs.waybar = {
        enable = true;
        settings = {
          mainBar = {
            layer = "top";
            position = "top";
            height = 24;
            spacing = 8;
            margin-top = 4;
            margin-left = 8;
            margin-right = 8;
            
            modules-left = ["hyprland/workspaces" "tray"];
            modules-center = ["clock"];
            modules-right = ["bluetooth" "pulseaudio" "network" "battery"];

            "hyprland/workspaces" = {
              disable-scroll = true;
              all-outputs = true;
              format = "{icon}";
              format-icons = {
                "1" = "󰲠";
                "2" = "󰲢";
                "3" = "󰲤";
                "4" = "󰲦";
                "5" = "󰲨";
                "6" = "󰲪";
                "7" = "󰲬";
                "8" = "󰲮";
                "9" = "󰲰";
                active = "󰿟";
                default = "";
              };
            };

            tray = {
              icon-size = 14;
              spacing = 8;
            };

            clock = {
              format = " {:%I:%M %p}";
              format-alt = " {:%a %b %d}";
              tooltip-format = "<tt><small>{calendar}</small></tt>";
            };

            bluetooth = {
              format = "󰂯 {status}";
              format-disabled = "󰂲";
              format-connected = "󰂱 {device_alias}";
              format-connected-battery = "󰂱 {device_alias} {device_battery_percentage}%";
              tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
              tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
              tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
              tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
              on-click = "blueman-manager";
            };

            battery = {
              states = {
                warning = 30;
                critical = 15;
              };
              format = "{icon} {capacity}%";
              format-charging = "󰂄 {capacity}%";
              format-plugged = "󰚥 {capacity}%";
              format-alt = "{icon} {time}";
              format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
            };

            network = {
              format-wifi = "󰖩 ";
              format-ethernet = "󰈀";
              tooltip-format = "󰖩 {essid}\n󰩠 {ipaddr}/{cidr}\n{signalStrength}%";
              format-linked = "󰈀 No IP";
              format-disconnected = "󰖪";
              format-alt = "󰩠 {ipaddr}";
            };

            pulseaudio = {
              format = "{icon} {volume}%";
              format-bluetooth = "󰂰 {volume}%";
              format-bluetooth-muted = "󰂲";
              format-muted = "󰝟";
              format-icons = {
                headphone = "󰋋";
                hands-free = "󰋎";
                headset = "󰋎";
                phone = "󰄜";
                portable = "󰦧";
                car = "󰄋";
                default = ["󰕿" "󰖀" "󰕾"];
              };
              on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
              on-click-right = "pwvucontrol";
              on-scroll-up = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
              on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
            };
          };
        };

        style = ''
          * {
            border: none;
            border-radius: 12px;
            font-family: "JetBrainsMono Nerd Font";
            font-size: 12px;
            font-weight: 500;
            min-height: 0;
          }

          window#waybar {
            background-color: #000000;
            color: #ffffff;
            transition-property: background-color;
            transition-duration: 0.3s;
            border-radius: 12px;
            margin: 4px;
          }

          window#waybar.hidden {
            opacity: 0.2;
          }

          #workspaces {
            background-color: #111111;
            border-radius: 12px;
            padding: 2px 8px;
            margin: 2px 4px;
          }

          #workspaces button {
            padding: 0 6px;
            background-color: transparent;
            color: #666666;
            border-radius: 8px;
            margin: 0 2px;
            transition: all 0.2s ease;
          }

          #workspaces button:hover {
            color: #ffffff;
            background-color: #222222;
          }

          #workspaces button.active {
            color: #4ade80;
            background-color: #1a2e1a;
            font-weight: 600;
          }

          #workspaces button.urgent {
            color: #ff6b6b;
            background-color: #2d1b1b;
          }

          #tray {
            background-color: #111111;
            border-radius: 12px;
            padding: 4px 8px;
            margin: 2px 4px;
          }

          #tray > .passive {
            -gtk-icon-effect: dim;
          }

          #tray > .needs-attention {
            -gtk-icon-effect: highlight;
            background-color: #222222;
            border-radius: 8px;
          }

          #clock {
            background-color: #111111;
            color: #ffffff;
            padding: 4px 12px;
            border-radius: 12px;
            margin: 2px 4px;
            font-weight: 600;
          }

          #bluetooth,
          #battery,
          #network,
          #pulseaudio {
            background-color: #111111;
            color: #ffffff;
            padding: 4px 10px;
            margin: 2px 2px;
            border-radius: 12px;
            transition: background-color 0.2s ease;
          }

          #bluetooth:hover,
          #battery:hover,
          #network:hover,
          #pulseaudio:hover {
            background-color: #222222;
          }

          #bluetooth {
            color: #60a5fa;
          }

          #bluetooth.disabled {
            color: #666666;
          }

          #bluetooth.connected {
            color: #4ade80;
          }

          #battery.charging {
            color: #4ade80;
          }

          #battery.critical:not(.charging) {
            color: #ff6b6b;
            animation-name: blink;
            animation-duration: 1s;
            animation-timing-function: ease-in-out;
            animation-iteration-count: infinite;
            animation-direction: alternate;
          }

          @keyframes blink {
            to {
              background-color: #2d1b1b;
            }
          }

          #network.disconnected {
            color: #ff6b6b;
          }

          #pulseaudio.muted {
            color: #666666;
          }

          tooltip {
            background-color: #000000;
            border: 1px solid #333333;
            border-radius: 8px;
            color: #ffffff;
          }

          tooltip label {
            color: #ffffff;
          }
        '';
      };

  # Service Settings

  services.hyprpaper = {
    enable = true;
    settings = {
      splash = true;

      preload = [
        "/home/musa/Pictures/Wallpapers/wp7427278-2256x1504-wallpapers.jpg"
      ];   

      wallpaper = [
        "eDP-1,/home/musa/Pictures/Wallpapers/wp7427278-2256x1504-wallpapers.jpg"
      ];
    };  
  };


}
