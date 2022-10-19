#!/usr/bin/env zsh

# Pull npm package names and pipe them into the npm CLI to get GitHub URLs, then query the GitHub API to see who's doing Hacktoberfest

# TODO: check if any of these are on GitLab

UA='ad-hoc script by GitHub user @strugee alex@strugee.net'

if ! test -f package-lock.json; then
    echo no package-lock.json present 1>&2
    exit 1
fi

if [ -z "$GH_ACCESS_PAIR" ]; then
	echo GH_ACCESS_PAIR not present in the environment \(should be \"USER:ACCESS_TOKEN\"\) 2>&1
	exit 2
fi

# Most of this is normalizing. Some highlights:
#  * We search for GitHub projects (github.io is accepted because GitHub Pages URLs will be normalized to repo URLs)
#  * We do the just-mentioned GitHub Pages normalization
#  * We slice github.com

# IMPORTANT: this expects moreutils parallel, NOT GNU Parallel!
for j in $(
			  <package-lock.json jq -r '.packages | keys[]' | sed 's;.*node_modules/;;' | xargs -- parallel -j 20 -i npm info {} repository.url -- \
			  | egrep 'github.(com|io)' | sort | uniq | sed -Ee 's;^[[:alpha:]+]+://(git@)?github.com/;;i' | cut -d/ -f1,2 | sed 's/\.git$//g'
		  ); do
#set -x
	if curl -u $GH_ACCESS_PAIR -H 'Accept: application/vnd.github.mercy-preview+json' -sLA $UA https://api.github.com/repos/$j/topics | jq '.names[]' | grep -q '"hacktoberfest"'; then
		echo https://github.com/$j
	fi
done
