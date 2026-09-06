{
  description = "Just a Nix that comply";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf.url = "github:notashelf/nvf";
  };

  outputs = { self, nixpkgs, home-manager, disko, nvf, ... }: {
    packages."x86_64-linux".default =
      (nvf.lib.neovimConfiguration {
	pkgs = nixpkgs.legacyPackages."x86_64-linux";
	modules = [ ./system/neovim/neovim-config.nix ];
      }).neovim;

    nixosConfigurations.phuckpad = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./system/configuration.nix
        disko.nixosModules.disko
        home-manager.nixosModules.home-manager
	nvf.nixosModules.default
        {
  	  home-manager = {
	    useGlobalPkgs = true;
	    useUserPackages = true;
            backupFileExtension = "backup";
            users.pbmine = import ./system/users/pbmine.nix;
	  };
         }
       ];
     };
   };
}


