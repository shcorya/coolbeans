#!/bin/bash
set -e

# read parameters starting with COOLBEANS
readarray -t COOLBEANS_ENV < <(printenv | grep ^COOLBEANS)

# parameters will be passed as a string
COOLBEANS_PARAMETERS=" $COOLBEANS_MODE "

# convert env vars to flags
for i in "${!COOLBEANS_ENV[@]}"
do
  # split by equals sign
  VAR=${COOLBEANS_ENV[i]%=*}
  # remove prefix
  VAR=${VAR#"COOLBEANS_"}
  # skip mode (already set)
  if [[ "$VAR" != "MODE" ]]
  then
    # convert to lowercase
    FLAG=$(echo $VAR | tr '[:upper:]' '[:lower:]')
    # replace _ with -
    FLAG=${FLAG//_/-}
    # value passed to parameter
    VALUE=${COOLBEANS_ENV[i]##*=}
    # convert flags and values to cli options
    COOLBEANS_PARAMETERS="$COOLBEANS_PARAMETERS --$FLAG $VALUE"
  fi
done

echo $COOLBEANS_PARAMETERS $@

#exec coolbeans $COOLBEANS_PARAMETERS $@
