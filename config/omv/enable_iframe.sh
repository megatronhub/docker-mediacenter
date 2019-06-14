#!/bin/bash
set -e
. /etc/default/openmediavault
. /usr/share/openmediavault/scripts/helper-functions
omv_set_default OMV_NGINX_SITE_WEBGUI_SECURITY_CSP_ENABLE 0
omv_set_default OMV_NGINX_SITE_WEBGUI_SECURITY_XFRAMEOPTIONS_ENABLE false
omv-mkconf nginx
invoke-rc.d nginx restart
omv_purge_internal_cache