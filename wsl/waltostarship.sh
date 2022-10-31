#!/bin/bash
i=0
while IFS= read -r line; do
    line=${line//$'\r'/}
    sed -i -e 's,color'$i'="#.*,color'$i'="'$line'",g' ~/.config/starship.toml
    i=$((i+1))
done < ~/.cache/wal/colors
