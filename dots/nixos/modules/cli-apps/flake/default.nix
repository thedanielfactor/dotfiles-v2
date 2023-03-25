inputs@{ options, config, lib, pkgs, ... }:

with lib;
with lib.internal;
let
  cfg = config.khanelinix.cli-apps.flake;
in
{
  options.khanelinix.cli-apps.flake = with types; {
    enable = mkBoolOpt false "Whether or not to enable flake.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      snowfallorg.flake
    ];
  };
}
