set shell := ["bash", "-uc"]

os := os()
ax52 := 'ax52'
runner-host := 'bench-seed-root'

[private]
default:
    just --list

# Build configuration without deploying
[group('test')]
build type=ax52:
    nixos-rebuild build --flake .#{{type}} --show-trace

# Build VM for testing
[group('test')]
build-vm type=ax52:
    nixos-rebuild build-vm --flake .#{{type}} --show-trace

# Show what would change without building
[group('test')]
dry-run type=ax52:
    nixos-rebuild dry-run --flake .#{{type}} --show-trace

# Deploy a seed node to a machine
[group('live')]
deploy type=ax52 host=runner-host:
    nixos-anywhere --flake .#{{type}} {{host}}

# Rebuild a seed node on a machine
[group('live')]
rebuild type=ax52 host=runner-host:
    nixos-rebuild switch --flake .#{{type}} --target-host {{host}} --impure

# Copy flake to remote for local building
[group('live')]
sync host=runner-host:
    rsync -av --exclude=result* --exclude=*.dat --exclude=.git . {{host}}:/etc/nixos-config/
    ssh {{host}} "chown -R root:root /etc/nixos-config"

