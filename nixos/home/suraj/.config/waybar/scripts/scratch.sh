#!/usr/bin/env bash

count=$(swaymsg -t get_tree | jq '.. | select(.name? == "__i3_scratch") | ((.nodes // []) + (.floating_nodes // [])) | length')

if [[ "$count" -eq 0 ]]; then
  class="none"
elif [[ "$count" -eq 1 ]]; then
  class="one"
elif [[ "$count" -gt 1 ]]; then
  class="many"
else
  class="unknown"
fi

printf '{"text":"%s", "class":"%s", "alt":"%s", "tooltip":"%s"}\n' "$count" "$class" "$class" "$count"

