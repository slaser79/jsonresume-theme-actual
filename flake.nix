{
  description = "jsonresume-theme-actual";
  nixConfig.bash-prompt = "\[nix-jsonresume-actual\]$ ";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    resume-cli.url = "github:slaser79/resume-cli";
  };

  outputs = { self, nixpkgs,... }@inputs:
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
      pkgs = forAllSystems ( system:
                               import nixpkgs {
                                   inherit system;
                               }
                           );
    in
        {
          devShell   = forAllSystems (system: import ./devshell.nix { pkgs = pkgs.${system}; 
                                                                      resume-cli = inputs.resume-cli.defaultPackage.${system};
                                                                    });
          nixpkgs    = pkgs;
        };
}
