# Maintainer: Stæld Lakorv <staeld@illumine.ch>
pkgname=lua-curl-git
pkgver=$(date +%Y%m%d)
pkgrel=1
pkgdesc="Aiming for a full-fledged libcurl binding"
arch=('i686' 'x86_64')
url="http://curl.haxx.se/libcurl/lua/"
license=('GPL')
depends=('lua' 'curl')
makedepends=('git')
provides=('lua-curl')
conflicts=('lua-curl')
options=(!libtools)
source=()
noextract=()
md5sums=() #generate with 'makepkg -g'

_gitroot="git://github.com/msva/lua-curl.git"
_gitname="lua-curl"

build() {
  cd "$srcdir"
  msg "Connecting to GIT server...."

  if [[ -d "$_gitname" ]]; then
    cd "$_gitname" && git pull origin
    msg "The local files are updated."
  else
    git clone "$_gitroot" "$_gitname"
  fi

  msg "GIT checkout done or server timeout"
  msg "Starting build..."

  rm -rf "$srcdir/$_gitname-build"
  git clone "$srcdir/$_gitname" "$srcdir/$_gitname-build"
  cd "$srcdir/$_gitname-build"

  ./configure --prefix=/usr
  make
}

package() {
  cd "$srcdir/$_gitname-build"
  make DESTDIR="$pkgdir/" install
}

