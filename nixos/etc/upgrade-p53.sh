sudo nix-channel --update

# Update flake inputs first (smaller operation)
sudo nix flake update /etc/nixos

# Then rebuild with memory limits
sudo nixos-rebuild switch --flake /etc/nixos#nixos --max-jobs 1 --cores 1
