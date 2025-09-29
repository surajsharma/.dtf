# collect flake garbage
nix-collect-garbage

#Delete all generations except the current one
sudo nix-collect-garbage -d

# Or more specifically for NixOS generations
sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations old

nix profile wipe-history

sudo docker system prune -a

nixos-rebuild list-generations
