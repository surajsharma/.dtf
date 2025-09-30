#!/usr/bin/env bash
# /etc/nixos/ultimate-resilient-update-v2.sh

sudo nix-channel --update
sudo nix flake update /etc/nixos

set -e

# Configuration
MAX_RETRIES=999
RETRY_DELAY=30
NETWORK_CHECK_INTERVAL=10
NETWORK_TIMEOUT=300

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Cache directory for CUDA files
CACHE_DIR="/tmp/nix-cuda-cache"
mkdir -p "$CACHE_DIR"

echo -e "${BLUE}=== Ultimate Resilient NixOS Update V2 ===${NC}"

# Ensure aria2 is available
if ! command -v aria2c &>/dev/null; then
  echo "Installing aria2..."
  nix-env -iA nixos.aria2
fi

# Function to check network connectivity
check_network() {
  for host in "8.8.8.8" "1.1.1.1" "cache.nixos.org"; do
    if ping -c 1 -W 2 "$host" &>/dev/null; then
      return 0
    fi
  done
  return 1
}

# Function to wait for network
wait_for_network() {
  local wait_time=0
  echo -e "${YELLOW}Network down. Waiting for connection...${NC}"

  while ! check_network; do
    echo -ne "\rWaiting for network... ${wait_time}s"
    sleep $NETWORK_CHECK_INTERVAL
    wait_time=$((wait_time + NETWORK_CHECK_INTERVAL))

    if [ $wait_time -ge $NETWORK_TIMEOUT ]; then
      echo -e "\n${RED}Network timeout after ${NETWORK_TIMEOUT}s${NC}"
      return 1
    fi
  done

  echo -e "\n${GREEN}Network restored!${NC}"
  return 0
}

# Function to download with aria2
download_with_aria2() {
  local url="$1"
  local output="$2"

  echo -e "${YELLOW}Downloading: $(basename "$url")${NC}"

  aria2c \
    -x 16 -s 16 -k 1M \
    --retry-wait=10 \
    --max-tries=0 \
    --timeout=60 \
    --connect-timeout=60 \
    --continue=true \
    --allow-overwrite=true \
    --auto-file-renaming=false \
    --console-log-level=warn \
    --summary-interval=30 \
    --max-connection-per-server=16 \
    --min-split-size=1M \
    --piece-length=1M \
    --lowest-speed-limit=1K \
    --disk-cache=64M \
    --conditional-get=true \
    --remote-time=true \
    -o "$(basename "$output")" \
    -d "$(dirname "$output")" \
    "$url"
}

# Get all CUDA URLs from derivations
get_cuda_urls() {
  echo -e "${BLUE}Scanning for CUDA dependencies...${NC}"

  # Try to get URLs from dry-build
  local DRY_BUILD_OUTPUT=$(mktemp)
  nixos-rebuild dry-build --flake /etc/nixos#nixos 2>&1 | tee "$DRY_BUILD_OUTPUT" || true

  # Extract CUDA URLs from various sources
  local URLS=""

  # From dry-build output
  URLS+=$(grep -oP 'https://developer\.download\.nvidia\.com/[^"'\''[:space:]]+\.(tar\.xz|run)' "$DRY_BUILD_OUTPUT" 2>/dev/null || true)
  URLS+="\n"

  # From derivations
  local DRVS=$(grep -oP '/nix/store/[a-z0-9]+-.*\.drv' "$DRY_BUILD_OUTPUT" | sort -u || true)

  for drv in $DRVS; do
    if [[ "$drv" =~ cuda|nvidia ]]; then
      nix show-derivation "$drv" 2>/dev/null |
        grep -oP '"https://developer\.download\.nvidia\.com/[^"]+\.(tar\.xz|run)"' |
        tr -d '"' >>/tmp/cuda-urls.txt || true
    fi
  done

  # Add known CUDA URLs including the failing ones
  cat >>/tmp/cuda-urls.txt <<'EOF'
https://developer.download.nvidia.com/compute/cuda/redist/cuda_gdb/linux-x86_64/cuda_gdb-linux-x86_64-12.8.90-archive.tar.xz
https://developer.download.nvidia.com/compute/cuda/redist/cuda_nvrtc/linux-x86_64/cuda_nvrtc-linux-x86_64-12.8.93-archive.tar.xz
https://developer.download.nvidia.com/compute/cuda/redist/libcublas/linux-x86_64/libcublas-linux-x86_64-12.8.4.1-archive.tar.xz
https://developer.download.nvidia.com/compute/cuda/redist/cuda_cudart/linux-x86_64/cuda_cudart-linux-x86_64-12.8.93-archive.tar.xz
https://developer.download.nvidia.com/compute/cuda/redist/cuda_cuobjdump/linux-x86_64/cuda_cuobjdump-linux-x86_64-12.8.93-archive.tar.xz
https://developer.download.nvidia.com/compute/cuda/redist/cuda_nvcc/linux-x86_64/cuda_nvcc-linux-x86_64-12.8.93-archive.tar.xz
https://developer.download.nvidia.com/compute/cuda/redist/cuda_nvdisasm/linux-x86_64/cuda_nvdisasm-linux-x86_64-12.8.93-archive.tar.xz
https://developer.download.nvidia.com/compute/cuda/redist/cuda_cuxxfilt/linux-x86_64/cuda_cuxxfilt-linux-x86_64-12.8.93-archive.tar.xz
https://developer.download.nvidia.com/compute/cuda/redist/libnvjitlink/linux-x86_64/libnvjitlink-linux-x86_64-12.8.93-archive.tar.xz
EOF

  # Also check for NVIDIA driver URLs
  echo "$URLS" | grep -oP 'https://[^/]+/[^"'\''[:space:]]+NVIDIA[^"'\''[:space:]]+\.run' >>/tmp/cuda-urls.txt || true

  # Remove duplicates
  sort -u /tmp/cuda-urls.txt >/tmp/cuda-urls-unique.txt

  rm -f "$DRY_BUILD_OUTPUT"
}

# Pre-download all CUDA files
pre_download_cuda() {
  echo -e "${BLUE}Pre-downloading CUDA and NVIDIA files...${NC}"

  get_cuda_urls

  local total=$(wc -l </tmp/cuda-urls-unique.txt)
  local count=0

  while IFS= read -r url; do
    [ -z "$url" ] && continue
    count=$((count + 1))

    local filename=$(basename "$url")
    echo -e "${BLUE}[$count/$total] Processing: $filename${NC}"

    if [ -f "$CACHE_DIR/$filename" ]; then
      echo -e "${GREEN}Already cached: $filename${NC}"
    else
      if download_with_aria2 "$url" "$CACHE_DIR/$filename"; then
        echo -e "${GREEN}Downloaded: $filename${NC}"
      else
        echo -e "${RED}Failed to download: $filename${NC}"
      fi
    fi

    # Add to Nix store
    if [ -f "$CACHE_DIR/$filename" ]; then
      echo "Adding to Nix store..."
      nix-store --add-fixed sha256 "$CACHE_DIR/$filename" 2>/dev/null || true
      nix-prefetch-url "file://$CACHE_DIR/$filename" 2>/dev/null || true
    fi
  done </tmp/cuda-urls-unique.txt
}

# Create a local binary cache
setup_local_cache() {
  echo -e "${BLUE}Setting up local binary cache...${NC}"

  # Create cache directory
  LOCAL_CACHE="/tmp/nix-binary-cache"
  mkdir -p "$LOCAL_CACHE"

  # Start a simple HTTP server for the cache
  if ! pgrep -f "python.*SimpleHTTPServer.*8888" >/dev/null; then
    cd "$LOCAL_CACHE"
    python3 -m http.server 8888 &>/dev/null &
    HTTP_PID=$!
    cd - >/dev/null
    echo "Started local cache server (PID: $HTTP_PID)"
  fi
}

# Update channels with retry
update_channels() {
  local retry=0
  while [ $retry -lt 5 ]; do
    echo -e "${BLUE}Updating channels (attempt $((retry + 1)))...${NC}"

    if ! check_network; then
      wait_for_network || return 1
    fi

    if sudo nix-channel --update; then
      echo -e "${GREEN}Channels updated successfully${NC}"
      return 0
    fi

    retry=$((retry + 1))
    sleep 10
  done

  echo -e "${YELLOW}Channel update failed, continuing anyway...${NC}"
  return 0
}

# Update flake with retry
update_flake() {
  local retry=0
  while [ $retry -lt 5 ]; do
    echo -e "${BLUE}Updating flake (attempt $((retry + 1)))...${NC}"

    if ! check_network; then
      wait_for_network || return 1
    fi

    if sudo nix flake update /etc/nixos; then
      echo -e "${GREEN}Flake updated successfully${NC}"
      return 0
    fi

    retry=$((retry + 1))
    sleep 10
  done

  echo -e "${YELLOW}Flake update failed, continuing anyway...${NC}"
  return 0
}

# Main execution
main() {
  # Step 1: Update channels
  update_channels

  # Step 2: Update flake
  update_flake

  # Step 3: Setup local cache
  setup_local_cache

  # Step 4: Pre-download CUDA files
  pre_download_cuda

  # Step 5: Create override configuration
  echo -e "${BLUE}Creating override configuration...${NC}"

  cat >/tmp/cuda-override.nix <<'EOF'
{ config, pkgs, lib, ... }:
{
  nixpkgs.overlays = [(self: super: {
    fetchurl = args:
      let
        url = if builtins.isList args.url then builtins.head args.url else args.url;
        filename = baseNameOf url;
        cachedPath = "/tmp/nix-cuda-cache/${filename}";
      in
        if (builtins.match ".*developer\.download\.nvidia\.com.*" url) != null && builtins.pathExists cachedPath
        then 
          builtins.trace "Using cached file: ${filename}" cachedPath
        else 
          super.fetchurl args;
  })];
}
EOF

  # Step 6: Main rebuild loop
  attempt=0
  while [ $attempt -lt $MAX_RETRIES ]; do
    attempt=$((attempt + 1))
    echo -e "${GREEN}=== NixOS Rebuild Attempt $attempt of $MAX_RETRIES ===${NC}"

    # Check network before starting
    if ! check_network; then
      wait_for_network || {
        echo -e "${RED}No network connection. Waiting ${RETRY_DELAY}s before retry...${NC}"
        sleep $RETRY_DELAY
        continue
      }
    fi

    # Create a temporary log file
    LOG_FILE="/tmp/nixos-rebuild-$(date +%Y%m%d-%H%M%S).log"

    # Run nixos-rebuild with override
    if sudo nixos-rebuild switch \
      --flake /etc/nixos#nixos \
      --option download-attempts 100 \
      --option connect-timeout 120 \
      --option stalled-download-timeout 600 \
      --option narinfo-cache-negative-ttl 0 \
      --option http2 false \
      --option http-connections 128 \
      --option substituters "http://localhost:8888 https://cache.nixos.org https://nix-community.cachix.org" \
      --option fallback true \
      --option keep-going true \
      --option max-silent-time 7200 \
      --option extra-substituters "file://$CACHE_DIR" \
      --option trusted-substituters "file://$CACHE_DIR" \
      --option require-sigs false \
      --impure \
      -I nixos-config=/tmp/cuda-override.nix \
      "$@" 2>&1 | tee "$LOG_FILE"; then

      echo -e "${GREEN}=== NixOS Rebuild Successful! ===${NC}"

      # Cleanup
      [ -n "$HTTP_PID" ] && kill $HTTP_PID 2>/dev/null || true
      echo "Cache preserved at: $CACHE_DIR"
      exit 0
    else
      EXIT_CODE=${PIPESTATUS[0]}
      echo -e "${RED}=== NixOS Rebuild Failed (exit code: $EXIT_CODE) ===${NC}"

      # Extract and download any new failing CUDA URLs
      if grep -q "developer.download.nvidia.com" "$LOG_FILE"; then
        echo -e "${YELLOW}Extracting failed downloads...${NC}"

        FAILED_URLS=$(grep -oP 'trying https://developer\.download\.nvidia\.com/[^"'\''[:space:]]+\.(tar\.xz|run)' "$LOG_FILE" |
          sed 's/^trying //' | sort -u)

        for url in $FAILED_URLS; do
          filename=$(basename "$url")
          if [ ! -f "$CACHE_DIR/$filename" ]; then
            echo -e "${YELLOW}Attempting to download: $filename${NC}"
            download_with_aria2 "$url" "$CACHE_DIR/$filename" &&
              nix-store --add-fixed sha256 "$CACHE_DIR/$filename" 2>/dev/null || true
          fi
        done
      fi

      if [ $attempt -lt $MAX_RETRIES ]; then
        echo -e "${YELLOW}Waiting ${RETRY_DELAY}s before retry...${NC}"
        sleep $RETRY_DELAY
      fi
    fi
  done

  echo -e "${RED}=== Failed after $MAX_RETRIES attempts ===${NC}"
  [ -n "$HTTP_PID" ] && kill $HTTP_PID 2>/dev/null || true
  exit 1
}

# Run main function
main "$@"
