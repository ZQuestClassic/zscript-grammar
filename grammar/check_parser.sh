#!/usr/bin/env bash

shopt -s globstar
set -e

if [ ! -x ./build/parser ]; then
	echo 'ERROR: ./build/parser: not found.'
	echo 'ERROR: you need to run `make` first.'
	exit 1
fi

ZSCRIPT=${ZSCRIPT:-zscript}
$ZSCRIPT -version

if [ $# -eq 0 ]; then
	FILES=($PWD/tests/**/*.zs $PWD/tests/**/*.zh)
else
	FILES=("$@")
fi

echo "running ${#FILES[@]} tests..."

set +e

ANY_FAILURE=
for FILE in "${FILES[@]}"; do
	zscriptout=$($ZSCRIPT -input "$FILE" -unlinked -delay_cassert -parse-only 2>&1)
	zscriptret=$?
	error=$(./build/parser < "$FILE" 2>&1)
	parserret=$?

	if [ "$zscriptret" -ne "0" ]; then
		zscriptret=1
	fi

	if [ "$zscriptret" -ne "$parserret" ]; then
		echo "FAIL: ${FILE}: zscript: $zscriptret, grammar: $parserret"
		if [ "$zscriptret" -eq 1 ]; then
		    echo "zscript: $zscriptout"
		fi
		if [ "$parserret" -eq 1 ]; then
		    echo "grammar: $error"
		fi
		ANY_FAILURE=1
	fi
done

if [ -z "$ANY_FAILURE" ]; then
	echo 'all tests passed'
else
	exit 1
fi
