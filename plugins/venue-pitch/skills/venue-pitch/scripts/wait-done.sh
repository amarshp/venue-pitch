#!/usr/bin/env bash
# Exits when every listed arm has fully finished (times.txt is written only after claude exits), or after 6 hours.
# A run that waits on its own background agents emits several result events, so a result event alone is not "done".
# Usage: bash wait-done.sh <slug> <tag> <arm,arm,...>   (run in the background; you are notified when it exits)
slug=$1; tag=$2; arms=$3
here=$(dirname "$0")
root=${VP_ROOT:-C:/vp}
n_arms=$(echo "${arms//,/ }" | wc -w)
for i in $(seq 1 360); do
  n=0
  for a in ${arms//,/ }; do [ -s "$root/$slug/runs/$tag-$a/times.txt" ] && n=$((n+1)); done
  [ "$n" -eq "$n_arms" ] && { echo "all done"; python "$here/status.py" "$slug" "$tag" "$arms"; exit 0; }
  sleep 60
done
echo "timeout after 6h"; python "$here/status.py" "$slug" "$tag" "$arms"
