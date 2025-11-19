#!/opt/homebrew/bin/bash
sleepx() {
local x=$1
(sleep "$x"
wait $!
echo "Slept for $x seconds"
) &
}

