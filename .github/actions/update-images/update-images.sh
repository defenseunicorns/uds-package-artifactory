#!/bin/bash

# set -x

update() {
  IMG_YAML="$(zarf dev find-images --no-progress | grep -v '#')"
  COMPONENT_UPDATES="$(echo "$IMG_YAML" | yq '.components[].name')"
  FLAVOR="$1"
  FLAVOR_CHECK=""

  if ! [ -z "$FLAVOR" ]; then
    FLAVOR_CHECK="| select(.only.flavor == \"$FLAVOR\")"
  fi

  for component in $COMPONENT_UPDATES; do
    NEW_IMAGES=$(echo "$IMG_YAML" | yq ".components[] | select(.name == \"$component\") | .images | .. style=\"double\" | . style=\"flow\"")
    echo $NEW_IMAGES
    cat zarf.yaml | yq "(.components[] | select(.name == \"$component\") ${FLAVOR_CHECK} | .images) |= $NEW_IMAGES" > zarf.yaml.tmp
    mv zarf.yaml.tmp zarf.yaml
  done
}

parse_flavors() {
  FLAVORS="$(yq '.components[].only.flavor' zarf.yaml | grep -v null)"
  if [ -z "$FLAVORS" ]; then
    echo "No flavors found in zarf.yaml"
    update
  else
    echo "Flavors found in zarf.yaml: $FLAVORS"
    for flavor in $FLAVORS; do
      export ZARF_CONFIG="zarf-config-ci.yaml"
      yq --null-input ".package.create.flavor = \"$flavor\"" > $ZARF_CONFIG
      update $flavor
    done
    rm -f $ZARF_CONFIG
    export ZARF_CONFIG=""
  fi
}

ZARF_PKGS="$(find . -type f -name "zarf.yaml" -exec dirname {} \;)"

for pkgDir in $ZARF_PKGS; do
  pushd $pkgDir
  parse_flavors
  popd
done
