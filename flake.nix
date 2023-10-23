{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    #home-manager.url = "github:nix-community/home-manager";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-unstable
    , home-manager
    , ...
    }:
    let 
        system = "x86_64-linux";
        pkgs = import nixpkgs {inherit system;};
        unstable = import nixpkgs-unstable {inherit system;};
    in
    {
      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        # FIXME replace with your hostname
        zwelchnix = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit unstable; };
          # > Our main nixos configuration file <
          modules = [ ./. ];
        };
      };
    };
}
