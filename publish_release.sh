#!/bin/sh

VERSION=$( head -n 1 VERSION )

echo "Publishing release ${VERSION}"

echo 'RELEASE_NOTES.md:'
echo '------------------------------------------------------------------------------'

cat RELEASE_NOTES.md

echo '------------------------------------------------------------------------------'

echo 'Did you update the RELEASE_NOTES.md file? '
read -r ANSWER
if [ "${ANSWER}" = "y" ] ; then
    
    make
    gh release create "v${VERSION}" --title "check_letsdebug-${VERSION}" --notes-file RELEASE_NOTES.md "check_letsdebug-${VERSION}.tar.gz" "check_letsdebug-${VERSION}.tar.bz2"

fi
