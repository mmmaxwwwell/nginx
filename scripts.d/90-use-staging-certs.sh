#!/bin/bash

set -e

use_staging_certs() {
  local output_dir="${NGINX_ENVSUBST_OUTPUT_DIR:-/etc/nginx/conf.d}"
  local certRegex="^\s*?ssl_certificate\s*?(\/\S*?);$"
  local keyRegex="^\s*?ssl_certificate_key\s*?(\/\S*?);$"
  local trustedRegex="^\s*?ssl_trusted_certificate\s*?(\/\S*?);$"
  local stagingCertPath="/etc/nginx/staging/privkey.pem"
  local stagingFullchainPath="/etc/nginx/staging/fullchain.pem"
  [ -d "$output_dir" ] || return 0

  find "$output_dir" -follow -type f -name "*.conf" -print | while read -r configPath; do
    echo "checking $configPath"
    if [ -f "$configPath" ]; then
      # echo "$configPath exists"

      local cert_path="$(grep -oEi "$certRegex" $configPath | awk '{print $2}' | tr -d ';')"
      # echo "cert_path=$cert_path"
      
      local key_path="$(grep -oEi "$keyRegex" $configPath | awk '{print $2}' | tr -d ';')"
      # echo "key_path=$key_path"

      local trusted_path="$(grep -oEi "$trustedRegex" $configPath | awk '{print $2}' | tr -d ';')"
      # echo "trusted_path=$trusted_path"

      if [ ! -z "$cert_path" ]; then
        # echo "cert_path found in $configPath"
        if [ ! -f "$cert_path" ]; then
          echo "cert_path $cert_path does not exist, replacing path with staging cert"
          cat $configPath | sed --expression="s/${cert_path////\\/}/${stagingFullchainPath////\\/}/g" > /tmp/tmp.conf
          cat /tmp/tmp.conf > $configPath
          rm /tmp/tmp.conf
        fi
      fi

      if [ ! -z "$key_path" ]; then
        #echo "key_path found in $configPath"
        if [ ! -f "$key_path" ]; then
          echo "key_path $key_path does not exist, replacing path with staging cert"
          cat $configPath | sed --expression="s/${key_path////\\/}/${stagingCertPath////\\/}/g" > /tmp/tmp.conf
          cat /tmp/tmp.conf > $configPath
          rm /tmp/tmp.conf
        fi
      fi
    fi
  done
}

use_staging_certs

exit 0
