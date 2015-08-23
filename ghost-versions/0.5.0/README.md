# Ghost Version 0.5.0

Database version: **003**

Please see the [main README](https://github.com/TryGhost/Ghost-Config/tree/master/ghost-versions#ghost-db-version-debugging-kit) or the Ghost wiki [Version Info](https://github.com/TryGhost/Ghost/wiki/Version-Info) page for more information.

Alternatively, check the release page for [Ghost 0.5.0](https://github.com/TryGhost/Ghost/releases/tag/0.5.0)

## Changelog:

This was the change from single to multi user

- Moved unique from user name to slug (bug fix)
- Removed sessions table
- Added clients, accesstokens & refreshtokens tables
- Added permissions_apps, apps, app_settings & app_fields tables
- Added image & hidden fields to tags
- Validations: type fix for booleans to include numeric vs string forms
- Validations: isURL -> isEmptyOrUrl
