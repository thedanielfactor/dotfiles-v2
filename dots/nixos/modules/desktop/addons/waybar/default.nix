{ options
, config
, lib
, pkgs
, inputs
, ...
}:
with lib;
with lib.internal; let
  cfg = config.khanelinix.desktop.addons.waybar;
in
{
  options.khanelinix.desktop.addons.waybar = with types; {
    enable =
      mkBoolOpt false "Whether to enable Waybar in the desktop environment.";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      waybar-hyprland
    ];

    khanelinix.home.configFile = mkMerge [
      (mkIf config.khanelinix.desktop.sway.enable {
        "waybar/config".source = ./sway/config;
        "waybar/style.css".source = ./sway/style.css;
      })
      (mkIf config.khanelinix.desktop.hyprland.enable {
        "waybar/scripts".source = inputs.dotfiles.outPath + "/dots/linux/hyprland/home/.config/waybar/scripts";
        "waybar/default-modules.jsonc".source = ./hyprland/default-modules.jsonc;
        "waybar/config.jsonc".source = ./hyprland/config.jsonc;
        "waybar/macchiato.css".source = inputs.dotfiles.outPath + "/dots/linux/hyprland/home/.config/waybar/macchiato.css";
        "waybar/style.css".source = inputs.dotfiles.outPath + "/dots/linux/hyprland/home/.config/waybar/style.css";
      })
    ];

    khanelinix.home.file = {
      # "weather_config.json".source = inputs.dotfiles.outPath + "/dots/shared/home/weather_config.json";
    };
  };
}
