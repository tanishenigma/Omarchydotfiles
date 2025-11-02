# #! /bin/bash

# bar="▁▂▃▄▅▆▇█"
# dict="s/;//g;"

# # creating "dictionary" to replace char with bar
# i=0
# while [ $i -lt ${#bar} ]
# do
#     dict="${dict}s/$i/${bar:$i:1}/g;"
#     i=$((i=i+1))
# done
# #!/usr/bin/env bash

# set -u

# Unicode bars for visualizing levels (0..7)
BAR_CHARS=( "" ▂ ▃ ▄ ▅ ▆ ▇ █)

# Find cava binary
CAVA_BIN="$(command -v cava || true)"
if [ -z "$CAVA_BIN" ]; then
    >&2 echo "cava: binary not found in PATH"
    exit 1
fi

# Create a temporary cava config
CONFIG_FILE="$(mktemp /tmp/waybar_cava_config.XXXXXX)"
cleanup() {
    rm -f "$CONFIG_FILE"
}
trap cleanup EXIT

cat > "$CONFIG_FILE" <<EOF
[general]
bars = 20

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
EOF

# Run cava with the temp config. It emits ascii digits 0..7 per frame.
# We map those digits to Unicode bar glyphs and print a single horizontal string.

"$CAVA_BIN" -p "$CONFIG_FILE" | while IFS= read -r line || [ -n "$line" ]; do
    # Remove semicolons and spaces, then map each character
    line="${line//;/}"
    line="${line// /}"
    out=""
    MAX_LEN=20
    for ((i=0; i<${#line} && ${#out}<MAX_LEN; i++)); do
        idx="${line:i:1}"
        if [[ "$idx" =~ [0-7] ]]; then
            out+="${BAR_CHARS[$idx]}"
        else
            out+="$idx"
        fi
    done
    printf "%s\n" "$out"
done