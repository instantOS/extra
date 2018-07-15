# Maintainer: Philip Müller <philm[at]manjaro[dog]org>
# Contributor: artoo <artoo@manjaro.org>
# Contributor: anex <assassin.anex[@]gmail.com>
# Contributor: Stefano Capitani <stefano@manjaro.org>
# Contributor: Matti Hyttinen <matti@manjaro.org> 


pkgbase=grub-theme-live
pkgname=('grub-theme-live-common' 'grub-theme-live-manjaro' 'grub-theme-live-sonar' 'grub-theme-manjaro')
pkgver=17.1.1
pkgrel=3
_branch=17.0
pkgdesc='Manjaro Linux grub theme'
arch=('any')
url="https://gitlab.manjaro.org/artwork/branding/grub-theme"
license=('GPL')
makedepends=('git')
source=("git+$url.git#branch=$_branch")
sha256sums=('SKIP')

package_grub-theme-live-common() {
    depends=('grub')
    conflicts=('grub-theme-live')
    replaces=('grub-theme-live')

    cd grub-theme
    make PREFIX=/usr DESTDIR=${pkgdir} install_common
}
package_grub-theme-live-manjaro() {
    depends=('grub-theme-live-common')

    cd grub-theme
    make PREFIX=/usr DESTDIR=${pkgdir} install_manjaro
}
package_grub-theme-live-sonar() {
    depends=('grub-theme-live-common')

    cd grub-theme
    make PREFIX=/usr DESTDIR=${pkgdir} install_sonar
}

package_grub-theme-manjaro() {
	depends=('grub')
	install=manjaro-theme.install
    
    cd grub-theme/manjaro-live
    sed -i -e 's,.*text = "Welcome to Manjaro".*,#text = "Welcome to Manjaro",' theme.txt #remove welcome message
    find . -type f -exec install -D -m644 {} ${pkgdir}/usr/share/grub/themes/manjaro/{} \;
}



