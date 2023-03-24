{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.khaneliman.suites.music;
in
{
  options.khaneliman.suites.music = with types; {
    enable = mkBoolOpt false "Whether or not to enable music configuration.";
  };

  config = mkIf cfg.enable {
    khaneliman = {
      apps = {
        ardour = enabled;
        bottles = enabled;
        yt-music = enabled;
      };
    };
  };
}
