#!/usr/bin/env bash

set -euo pipefail

registry="update-info/6.0.0/plugins.repository"
registry_base="https://raw.githubusercontent.com/protegeproject/autoupdate/master/"
temp_dir="$(mktemp -d)"
trap 'rm -rf "$temp_dir"' EXIT

descriptor_urls="$temp_dir/descriptor-urls"
sed -e 's/^[[:space:]]*//' \
    -e 's/[[:space:]]*$//' \
    -e '/^$/d' \
    -e '/^\/\//d' \
    "$registry" > "$descriptor_urls"

if [ "$(sort "$descriptor_urls" | uniq -d | wc -l | tr -d ' ')" -ne 0 ]; then
    echo "The registry contains duplicate entries." >&2
    exit 1
fi

descriptor_count=0
for descriptor in update-info/6.0.0/*.properties; do
    descriptor_count=$((descriptor_count + 1))
    descriptor_url="${registry_base}${descriptor}"
    if ! grep -Fxq "$descriptor_url" "$descriptor_urls"; then
        echo "$descriptor is not listed in $registry." >&2
        exit 1
    fi

    id="$(sed -n 's/^id=//p' "$descriptor")"
    version="$(sed -n 's/^version=//p' "$descriptor")"
    download="$(sed -n 's/^download=//p' "$descriptor")"

    if [ -z "$id" ] || [ -z "$version" ] || [ -z "$download" ]; then
        echo "$descriptor is missing id, version, or download." >&2
        exit 1
    fi

    jar="$temp_dir/${id}-${version}.jar"
    echo "Checking $id $version"
    curl --fail --location --silent --show-error "$download" --output "$jar"

    manifest="$temp_dir/${id}.manifest"
    unzip -p "$jar" META-INF/MANIFEST.MF | tr -d '\r' > "$manifest"
    bundle_id="$(sed -n 's/^Bundle-SymbolicName: //p' "$manifest" | sed 's/;.*//' | head -1)"
    bundle_version="$(sed -n 's/^Bundle-Version: //p' "$manifest" | head -1)"

    if [ "$bundle_id" != "$id" ]; then
        echo "$descriptor declares $id but the bundle declares $bundle_id." >&2
        exit 1
    fi
    if [ "$bundle_version" != "$version" ]; then
        echo "$descriptor declares $version but the bundle declares $bundle_version." >&2
        exit 1
    fi
done

registry_count="$(wc -l < "$descriptor_urls" | tr -d ' ')"
if [ "$registry_count" -ne "$descriptor_count" ]; then
    echo "$registry lists $registry_count entries but contains $descriptor_count descriptors." >&2
    exit 1
fi

echo "Validated $descriptor_count Protégé 6 plugins."
