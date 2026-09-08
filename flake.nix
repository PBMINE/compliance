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

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, disko, nvf, ... }: {
    nixosConfigurations.phuckpad = nixpkgs.lib.nixosSystem {
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
            extraSpecialArgs = { inherit nvf; };
            users.pbmine = {
              imports = [
                nvf.homeManagerModules.default
                ./system/users/pbmine.nix 
              ];
            };
	  };
         }
       ];
     };
   };
}


