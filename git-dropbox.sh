#!/bin/sh
# See https://github.com/agnoster/git-dropbox for more information about this project.

FOLDER=`git config dropbox.folder`

if [ ! "$FOLDER" -o ! -d "$FOLDER" ]; then
  FOLDER=""
  echo "# git-dropbox: initial setup"
  # Running for the first time
  if [ -d "$HOME/Dropbox" ]; then
    DEFAULT="$HOME/Dropbox/git"
  else
    read -p "Where is your dropbox folder, relative to $HOME? " -e DROPBOX
    if [ -d "$HOME/$DROPBOX" ]; then
      DEFAULT="$HOME/$DROPBOX/git"
    else
      echo "'$HOME/$DROPBOX' could not be found. Make sure you have the right folder" \
           "name and run git-dropbox again."
      exit 1
    fi
  fi
  while [ ! "$FOLDER" ]; do
    read -p "Where should git repositories be saved? [$DEFAULT] " -e FOLDER
    if [ ! "$FOLDER" ]; then
      FOLDER="$DEFAULT"
      echo "Choosing default: $FOLDER"
    fi
  done

  mkdir -p "$FOLDER"
  if [ ! "$FOLDER" ]; then
    echo "$FOLDER does not exist. Check that you have permissions to create it."
    exit 1
  fi

  git config --global dropbox.folder "$FOLDER"
  echo "Set $FOLDER as the location for your dropbox git clones"
fi


PROJECT_DIR=`git rev-parse --show-toplevel 2>/dev/null`
if [ ! "$PROJECT_DIR" ]; then
  echo "Run 'git dropbox' in a git repository to mirror it to $FOLDER/[repo-name].git/"
  exit
fi

DROPBOX_REPO=`git config --local dropbox.repo 2>/dev/null`
if [ ! "$DROPBOX_REPO" ]; then
  PROJECT_NAME=`basename "$PROJECT_DIR"`
  DROPBOX_REPO="$FOLDER/$PROJECT_NAME.git"
fi

if [ ! -d "$DROPBOX_REPO" ]; then
  mkdir -p "$DROPBOX_REPO"
  (cd "$DROPBOX_REPO"; git init --bare)
fi

if [ ! -d "$DROPBOX_REPO" ]; then
  echo "Could not create $DROPBOX_REPO. Check that you have permissions to create it."
  exit 1
fi

git push "$DROPBOX_REPO" --mirror
