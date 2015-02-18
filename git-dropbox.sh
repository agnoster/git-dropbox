#!/bin/sh
# See https://github.com/agnoster/git-dropbox for more information about this project.

FOLDER=$(git config dropbox.folder)

if [ ! "$FOLDER" ] || [ ! -d "$FOLDER" ]; then
  FOLDER=""
  echo "# git-dropbox: initial setup"
  # Running for the first time
  if [ -d "$HOME/Dropbox" ]; then
    DEFAULT="$HOME/Dropbox/git"
  else
    printf "Where is your dropbox folder, relative to $HOME? "
    read DROPBOX
    if [ -d "$HOME/$DROPBOX" ]; then
      DEFAULT="$HOME/$DROPBOX/git"
    else
      echo "'$HOME/$DROPBOX' could not be found. Make sure you have the right folder" \
           "name and run git-dropbox again."
      exit 1
    fi
  fi
  while [ ! "$FOLDER" ]; do
    printf "Where should git repositories be saved? [$DEFAULT] "
    read FOLDER
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


PROJECT_DIR=$(git rev-parse --show-toplevel 2>/dev/null)
if [ ! "$PROJECT_DIR" ]; then
  echo "Run 'git dropbox' in a git repository to mirror it to $FOLDER/[repo-name].git/"
  exit
fi

DROPBOX_REPO=$(git config --local dropbox.repo 2>/dev/null)
if [ ! "$DROPBOX_REPO" ]; then
  PROJECT_NAME=$(basename "$PROJECT_DIR")
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

function usage()
{
    echo "dropbox.sh - simplifies setting up git with dropbox."
    echo ""
    echo "./git-dropbox.sh"
    echo "  -h --help"
    echo "  --remote-add -- git remote add origin $DROPBOX_REPO"
    echo ""
}

RA=false
while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        -h | --help)
            usage
            exit
            ;;
        --remote-add)
            RA=true
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            exit 1
            ;;
    esac
    shift
done

git push "$DROPBOX_REPO" --mirror

if $RA ; then
  git remote add origin "$DROPBOX_REPO"
fi
