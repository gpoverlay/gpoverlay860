# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for app-crypt/gnupg-pkcs11-scd"

ACCT_USER_GROUPS=( "gnupg-pkcs11-scd-proxy" "gnupg-pkcs11" )
ACCT_USER_ID="281"

acct-user_add_deps