#!/bin/sh
set -u
dir=${1:-public}
base=https://blog.bl4ko.com
status=0

require() {
  if ! grep -qE "$2" "$dir/${1}index.html"; then
    echo "/$1: missing $2" >&2
    status=1
  fi
}

for route in "" posts/github-rebase-issue/ tags/git/ tags/github/ tags/rebase/; do
  require "$route" "<link rel=\"canonical\" href=\"$base/$route\" />"
  require "$route" "<meta property=\"og:url\" content=\"$base/$route\" />"
  require "$route" "<meta property=\"og:image\" content=\"$base/img/theme-colors/profile.png\">"
  require "$route" "<meta name=\"description\" content=\"[^\"]+\" />"
  require "$route" "<meta property=\"og:description\" content=\"[^\"]+\" />"
done

for tag in Git Github Rebase; do
  route=tags/$(echo "$tag" | tr '[:upper:]' '[:lower:]')/
  require "$route" "<meta name=\"description\" content=\"Posts tagged $tag on "
done

exit $status
