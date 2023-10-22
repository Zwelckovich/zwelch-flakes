{ pkgs, config, lib, ... }:

let
  modifier = "ALT";
in
{
  xdg.configFile."hypr/hyprland.conf".text = ''
	$SUPER = ${modifier}

	bind = $SUPER, Return, exec, kitty
	bind = $SUPER, Q, killactive
	bind = $SUPER, M, exit

	bind = $SUPER, 1, workspace, 1
	bind = $SUPER, 2, workspace, 2
	bind = $SUPER, 3, workspace, 3
	bind = $SUPER, 4, workspace, 4
	bind = $SUPER, 5, workspace, 5
	bind = $SUPER, 6, workspace, 6
	bind = $SUPER, 7, workspace, 7
	bind = $SUPER, 8, workspace, 8
	bind = $SUPER, 9, workspace, 9

	bind = $SUPER SHIFT, 1, movetoworkspace, 1
	bind = $SUPER SHIFT, 2, movetoworkspace, 2
	bind = $SUPER SHIFT, 3, movetoworkspace, 3
	bind = $SUPER SHIFT, 4, movetoworkspace, 4
	bind = $SUPER SHIFT, 5, movetoworkspace, 5
	bind = $SUPER SHIFT, 6, movetoworkspace, 6
	bind = $SUPER SHIFT, 7, movetoworkspace, 7
	bind = $SUPER SHIFT, 8, movetoworkspace, 8
	bind = $SUPER SHIFT, 9, movetoworkspace, 9

	exec-once=waybar
	layerrule=blur, waybar 

	monitor=Virtual-1,2560x1440,0x0,1

	input {
		kb_layout = de
	}
  '';
}
