{ pkgs, config, lib, ... }:

let
  modifier = "ALT";
in
{
  xdg.configFile."hypr/hyprland.conf".text = ''
                    	$SUPER = ${modifier}

                   		bind = $SUPER, Return, exec, foot
           			bind = $SUPER, Q, killactive
           			bind = $SUPER, M, exit

        			bind = $SUPER, 1, workspace, 1
        			bind = $SUPER, 2, workspace, 2
        			bind = $SUPER SHIFT, 1, movetoworkspace, 1
        			bind = $SUPER SHIFT, 2, movetoworkspace, 2

        			exec-once=waybar
        			layerrule=blur, waybar 

                		monitor=Virtual-1,1920x1080,0x0,1

    			input {
    				kb_layout = de
    			}
  '';
}
