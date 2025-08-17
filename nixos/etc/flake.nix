{
  description = "NixOS with Sway + swww via flake input";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    swww.url = "github:LGFae/swww";
  };

  outputs = {
    self,
    nixpkgs,
    swww,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;

      # pass flake inputs to modules if you need them
      specialArgs = {inherit swww;};

      modules = [
        # your existing config
        ./configuration.nix

        # tiny inline module: install swww from the flake input
        ({pkgs, ...}: {
          environment.systemPackages = [
            swww.packages.${pkgs.system}.swww
          ];
        })
      ];
    };
  };
}
