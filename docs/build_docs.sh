#!/bin/bash
#set -e
shopt -s extglob
git config user.name "adibrastegarnia"
git config user.email "arastega@purdue.edu"
#git remote add gh-token "https://${GH_TOKEN}@github.com/multirepo-docs/root-docs-jekyl#l.git";
#git fetch gh-token && git fetch gh-token gh-pages:gh-pages;
CURRENT_PATH=$PWD
cd docs 
git submodule add https://github.com/multirepo-docs/repo-docs-1.git
cd repo-docs-1 && rm -rf !(docs)
cd ..
git submodule add https://github.com/multirepo-docs/repo-docs-2.git
cd repo-docs-2 && rm -rf !(docs)
cd ..
git submodule add https://github.com/multirepo-docs/repo-docs-3.git
cd repo-docs-3 && rm -rf !(docs)
cd $CURRENT_PATH

# enable error reporting to the console
set -e

# cleanup "_site"
rm -rf _site
mkdir _site

# clone remote repo to "_site"
git clone https://${GH_TOKEN}@github.com/multirepo-docs/root-docs-jekyl.git" --branch gh-pages _site


bundle exec jekyll build
bundle exec htmlproofer ./_site
# push
cd _site
git add --all
git commit -a -m "Travis #$TRAVIS_BUILD_NUMBER"
git push --force origin gh-pages
