# git-dropbox

A recent [stackoverflow answer] got me thinking: what's the easiest way to use Dropbox for your git repos?

How about just typing this:

    git dropbox

And your repo gets mirrored to a bare repo in your Dropbox! Sound like a good time? Read on!

## Usage

To install:

    curl -o /usr/local/bin/git-dropbox https://github.com/agnoster/git-dropbox/raw/master/git-dropbox.sh
    chmod +x /usr/local/bin/git-dropbox

Now, in any git project, run the following:

    git dropbox

- If you haven't run it before, it will prompt you for a location to create git repos.
  - Default: `$HOME/Dropbox/git`
  - Saves this to `git config --global dropbox.folder`
- Creates that folder if it doesn't exist
- Creates a new bare repo matching the name of your git project's directory
  - So, for `my_project`, the default location would be `$HOME/Dropbox/git/my_project.git`
- Does a `git push $NEW_BARE_REPO --mirror`

Simple. Now, whenever you do a `git dropbox` it will re-mirror to the same directory.

## FAQ

**Q**: Why doesn't it just add a remote and let you push?
**A**: Coming. But right now I want it as simple as possible. `git dropbox` and you're done. Also, if you add it as a remote it ends up pushing tracking branches for itself when you mirror, which just seems weird.

**Q**: What if I want to push a single project to a different place? (Like maybe a toplevel directory for sharing?)
**A**: First off: if you *are* sharing, I highly recommend you don't have multiple people push to one repo. Better to each have a dropbox repo and pull from each other when need be. But you can in fact set the location of the mirror bare repo with a simple config variable:

    git config dropbox.repo /path/to/dropbox/repo

[stackoverflow answer]: http://stackoverflow.com/questions/1960799/using-gitdropbox-together-effectively/1961515#1961515
