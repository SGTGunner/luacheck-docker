#!/bin/sh

GITHUB_TOKEN=${PLUGIN_GITHUBTOKEN}
GITHUB_API=https://api.github.com
GITHUB_STATUS_ENDPOINT=$GITHUB_API/repos/$REPO/statuses/$SHA
CI_CONTEXT="stylechecker/luacheck"

# Notify GitHub stylechecking has started
echo 'Starting Luacheck...'
curl "$GITHUB_API/repos/$CI_REPO/statuses/$CI_COMMIT?access_token=$GITHUB_TOKEN" \
  -s \
  -H "Content-Type: application/json" \
  -X POST \
  -d "{\"state\": \"pending\", \"description\": \"The luacheck style checking is in progress\", \"target_url\": \"$CI_BUILD_URL\", \"context\": \"$CI_CONTEXT\"}" \
  > /dev/null

# Run Luacheck
# cd `dirname $0`
# npm run lint
"/usr/local/bin/luacheck", "--config", ${PLUGIN_LUACHECKRC}, "/lua"
EXIT_CODE=$?

# Notify GitHub according to Luacheck exit code
if [[ $EXIT_CODE == 0 ]]
then
  export STATUS="success"
  export DESCRIPTION="No style issues"
  echo $DESCRIPTION
else
  export STATUS="failure"
  export DESCRIPTION="Luacheck found style issues"
  echo $DESCRIPTION
fi

curl "$GITHUB_API/repos/$CI_REPO/statuses/$CI_COMMIT?access_token=$GITHUB_TOKEN" \
  -s \
  -H "Content-Type: application/json" \
  -X POST \
  -d "{\"state\": \"$STATUS\", \"description\": \"$DESCRIPTION\", \"target_url\": \"$CI_BUILD_URL\", \"context\": \"$CI_CONTEXT\"}" \
  > /dev/null

exit 0 # don't make the build fail, just notify GitHub