PREFIX=/usr/local/bin

install: uninstall
	install git-dropbox.sh $(PREFIX)/git-dropbox

link: uninstall
	ln -sf $(PWD)/git-dropbox.sh $(PREFIX)/git-dropbox

uninstall:
	rm -f $(PREFIX)/git-dropbox

.PHONY: install uninstall link
