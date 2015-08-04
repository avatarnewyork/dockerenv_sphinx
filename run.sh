#!/bin/bash

# Replace variables in the varnish config file

replace_vars() {
  OUTPUT=$(echo $1 | sed -e 's/.source//');
  SOURCE=$1

  eval "cat <<EOF
  $(<$SOURCE)
EOF
  " > $OUTPUT
}

replace_vars '/etc/sphinx/sphinx.conf.source'

#mkdir -p /var/lib/sphinx/


/usr/bin/indexer --config /etc/sphinx/sphinx.conf --rotate --all

# Starts indexer and search
/usr/bin/indexer -c $SPHINX_FILE --all; searchd -c /etc/sphinx/sphinx.conf --nodetach "$@"
