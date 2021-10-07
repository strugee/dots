#!/usr/bin/env zsh

# Pull pipenv package names and pipe them into PyPI to get GitHub URLs, then query the GitHub API to see who's doing Hacktoberfest

# Note that GitLab is participating in Hacktoberfest too but the project I was doing this for has no dependencies that originate from GitLab

UA='ad-hoc script by GitHub user @strugee alex@strugee.net'

if ! test -f Pipfile; then
    echo no Pipfile present 1>&2
    exit 1
fi

if [ -z "$GH_ACCESS_PAIR" ]; then
	echo GH_ACCESS_PAIR not present in the environment (should be \"USER:ACCESS_TOKEN\") 2>&1
	exit 2
fi

# Most of this is normalizing. Some highlights:
#  * We search for GitHub projects (github.io is accepted because GitHub Pages URLs will be normalized to repo URLs)
#  * We do the just-mentioned GitHub Pages normalization
#  * We slice github.com
#
# Also, the second uniq here is because a lot of these URLs are /issues, /pulls, etc. on the same repo, so when we slice those parts off they become dupes

for j in $(
		  for i in $(pipenv lock -dr | grep '==' | cut -d= -f1 | sed 's/\[.*]//g'); do
		  curl -sLA $UA https://pypi.org/pypi/$i/json | jq -r '.info.home_page, .info.project_urls[]?, (.info.description | [ scan("https?://github.com/[^\\s>)]+]") ][]?)'
		  done | egrep 'github.(com|io)/.+' | sort | uniq | sed -Ee 's;https?://([^.]+).github.(:?com|io)/([^/]+);https://github.com/\1/\3;i' -e 's;^https?://github.com/;;i' | cut -d/ -f1,2 | grep -v '^sponsors' | sed 's/\.git$//g' | uniq | grep -v MacHu-GWU/
	  ); do
	#set -x
	if curl -u $GH_ACCESS_PAIR -H 'Accept: application/vnd.github.mercy-preview+json' -sLA $UA https://api.github.com/repos/$j/topics | jq '.names[]' | grep -q '"hacktoberfest"'; then
	echo https://github.com/$j
	fi
done
