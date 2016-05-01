#!/usr/bin/env bash

# Skip conditions
if [ "${CIRCLE_BRANCH}" == 'master' ]; then
  exit 0
fi

# Install gems
gem i --quiet --no-document \
  checkstyle_filter-git \
  saddler \
  saddler-reporter-github \
  rubocop \
  rubocop-checkstyle_formatter \
  reek

# Set reporter
if [ -z "${CI_PULL_REQUEST}" ]; then
  REPORTER=Saddler::Reporter::Github::CommitReviewComment
else
  REPORTER=Saddler::Reporter::Github::PullRequestReviewComment
fi

echo "******************************"
echo "*          RuboCop           *"
echo "******************************"

rubocop --require `gem which rubocop/formatter/checkstyle_formatter` \
        --format RuboCop::Formatter::CheckstyleFormatter \
        --out rubocop.xml

cat rubocop.xml | \
    checkstyle_filter-git diff origin/master | \
    saddler report --require saddler/reporter/github --reporter $REPORTER

cp -v 'rubocop.xml' "$CIRCLE_ARTIFACTS/"

echo "******************************"
echo "*            Reek            *"
echo "******************************"

reek app --format xml > reek.xml

cat reek.xml | \
    checkstyle_filter-git diff origin/master | \
    saddler report --require saddler/reporter/github --reporter $REPORTER

cp -v 'reek.xml' "$CIRCLE_ARTIFACTS/"
