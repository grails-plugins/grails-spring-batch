#!/usr/bin/env bash
set -e

export EXIT_STATUS=0

echo "TRAVIS_TAG          : $TRAVIS_TAG"
echo "TRAVIS_BRANCH       : $TRAVIS_BRANCH"
echo "TRAVIS_PULL_REQUEST : $TRAVIS_PULL_REQUEST"
echo "Publishing archives for branch $TRAVIS_BRANCH"
rm -rf build

./gradlew --stop

./gradlew clean check assemble || EXIT_STATUS=$?


if [[ ${EXIT_STATUS} -ne 0 ]]; then
    echo "Check failed"
    exit ${EXIT_STATUS}
fi


if [[ -n ${TRAVIS_TAG} ]] || [[ ${TRAVIS_BRANCH} == 'master' && ${TRAVIS_PULL_REQUEST} == 'false' ]]; then
    echo "Publishing archives for branch $TRAVIS_BRANCH"

    if [[ -n ${TRAVIS_TAG} ]]; then
        echo "Pushing build to Bintray"
        ./gradlew :spring-batch:bintrayUpload || EXIT_STATUS=$?
    else
        echo "Publishing snapshot..."
        ./gradlew :spring-batch:publish || EXIT_STATUS=$?
    fi

#    ./publish-docs.sh
fi

exit ${EXIT_STATUS}

EXIT_STATUS=0
