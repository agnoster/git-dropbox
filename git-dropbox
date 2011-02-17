#!/bin/sh

FOLDER=`git config dropbox.folder`

if [ ! "$FOLDER" -o ! -d "$FOLDER" ]; then
  FOLDER=""
  # Running for the first time
  if [ -d "$HOME/Dropbox" ]; then
    DEFAULT="$HOME/Dropbox/git"
  fi
  echo "# git-dropbox: initial setup"
  while [ ! "$FOLDER" ]; do
    read -p "Where should git repositories be saved? [$DEFAULT] " -e FOLDER
    if [ ! "$FOLDER" ]; then
      FOLDER="$DEFAULT"
      echo "Choosing default: $FOLDER"
    fi
  done

  mkdir -p $FOLDER
  if [ ! "$FOLDER" ]; then
    echo "$FOLDER does not exist. Check that you have permissions to create it."
    exit 1
  fi

  git config --global dropbox.folder "$FOLDER"
  echo "Set $FOLDER as the location for your dropbox git clones"
fi


PROJECT_DIR=`git rev-parse --show-toplevel`
PROJECT_NAME=`basename "$PROJECT_DIR"`

DROPBOX_REPO="$FOLDER/$PROJECT_NAME.git"

if [ ! -d "$DROPBOX_REPO" ]; then
  mkdir -p $DROPBOX_REPO
  (cd $DROPBOX_REPO; git init --bare)
fi

git push "$DROPBOX_REPO" --mirror
