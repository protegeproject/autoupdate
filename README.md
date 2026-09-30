# Protégé plugin auto-update registries

This repository contains plugin registries and update descriptors used by the
Protégé Desktop auto-update mechanism.

## Protégé 6 registry

The Protégé 6 registry is
[`update-info/6.0.0/plugins.repository`](update-info/6.0.0/plugins.repository).
It contains only plugin versions that have been released and tested with
Protégé 6. Do not copy entries from an earlier registry without completing
that compatibility check.

Each entry points to an update descriptor containing the plugin's OSGi bundle
symbolic name, version, and download URL. Run the validator before submitting a
change:

```shell
./scripts/validate-protege-6-registry.sh
```

The validator downloads every listed plugin and checks that its bundle symbolic
name and version match its update descriptor. The same check runs in GitHub
Actions when the Protégé 6 registry changes.

## Older plugins

The recommended format is to create a separate directory for each plug-in.  Top-level directories should contain update files, and binaries should go in subdirectories that mimic the plug-in version number, e.g.:

```
snap-sparql-query/update.properties
snap-sparql-query/readme.html
snap-sparql-query/1.0.0/org.protege.sparql.snap.jar
snap-sparql-query/1.0.1/org.protege.sparql.snap.jar
```

If you're a developer looking to enable autoupdate for your Protégé Desktop plug-in, please refer to the following instructions on the Stanford hosted Protégé wiki:

http://protegewiki.stanford.edu/wiki/EnablePluginAutoUpdate
