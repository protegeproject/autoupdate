autoupdate
==========

Repository to house update files and binaries for Protege Desktop plug-ins, made available through the autoupdate mechanism.  

The recommended format is to create a separate directory for each plug-in.  Top-level directories should contain update files, and binaries should go in subdirectories that mimic the plug-in version number, e.g.:

```
snap-sparql-query/update.properties
snap-sparql-query/readme.html
snap-sparql-query/1.0.0/org.protege.sparql.snap.jar
snap-sparql-query/1.0.1/org.protege.sparql.snap.jar
```

If you're a developer looking to enable autoupdate for your Protege Desktop plug-in, please refer to the following instructions on the Stanford hosted Protege wiki:

http://protegewiki.stanford.edu/wiki/EnablePluginAutoUpdate
