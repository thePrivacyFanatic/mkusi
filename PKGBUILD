pkgname=mkusi-git
pkgver=1.0
pkgrel=1
pkgdesc="a couple utilities used for creating simple USIs"
arch=('x86_64')
url=https://github.com/thePrivacyFanatic/mkusi
license=("gpl-3.0-or-later")
depends=('squashfs-tools' 'util-linux' 'cpio' 'ukify')
optdepends=('ncurses: better log formatting')
makedepends=('git')
source=("git+$url")
b2sums=("SKIP")
build() {
  cd $srcdir/mkusi
  make PREFIX=/usr/share/ CC=gcc all
}

package() {
  cd $srcdir/mkusi
  make PREFIX=/usr/share DESTDIR=$pkgdir install
}
