#!/bin/bash

main()
{
  declare s="${1:-.}"

  # We copy everything into another folder
  declare d="$( mktemp -d )/gh-pages"
  mkdir -p "${d}"
  cp -a "${s}/." "${d}"
  cd "${d}"

  # We configure git
  git init
  git config user.name "Travis CI"
  git config user.email "none@none.no"

  # And we push everything to the right branch
  git add .
  git commit -m "Deploy to GitHub Pages"
  git push --force "https://radium226:${GITHUB_TOKEN}@github.com/radium226/talks.git" "master:gh-pages"
}

main "${@}"
