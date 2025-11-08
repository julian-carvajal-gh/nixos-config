default:
    just --list

# Update flake.lock
flake-up:
    nix flake update

# Build the config
check:
    sudo nixos-rebuild build --flake .

# Apply updates
apply:
    sudo nixos-rebuild switch --flake .

# Update flake.lock and apply updates
up: flake-up
    sudo nixos-rebuild switch --flake .

# Format Nix code
fmt:
    alejandra .

# Garbage collect all unused nix store entries
gc:
  sudo nix-collect-garbage --delete-old
