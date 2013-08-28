PREFIX=/usr/local
bindir=$(PREFIX)/bin


install: uninstall
	install git-dropbox.sh $(bindir)/git-dropbox

link: uninstall
	ln -sf $(PWD)/git-dropbox.sh $(bindir)/git-dropbox

uninstall:
	rm -f $(PREFIX)/git-dropbox

.PHONY: install uninstall link
