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
  };

  outputs = { self, nixpkgs, home-manager, disko }: {
    nixosConfiguration.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./system/configuration.nix
        disko.nixosModules.disko
        home-manager.nixosModules.home-manager
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


