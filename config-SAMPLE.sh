#! /bin/bash

# ----------------------------------------------------------

# For the building process only:
# the first 3 numbers of the network address (e.g. 100.50.25)
# IP range for private networks: 172.16.0.0 - 172.31.255.255
CFG_MKINST_DOCK_NET_PREFIX="172.30.19"

# ----------------------------------------------------------

# may be "true" or "false":
CFG_MKINST_DEBUG_DONT_EXPORT_FINAL_IMG=false

# may be "true" or "false":
CFG_MKINST_DEBUG_PWGENFNC=false

# may be "true" or "false":
CFG_MKINST_DEBUG_DISABLE_CLAMAV=false

# may be "true" or "false":
CFG_MKINST_DEBUG_DISABLE_OPENDKIM=false
