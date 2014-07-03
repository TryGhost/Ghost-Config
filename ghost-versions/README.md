# Ghost DB Version debugging kit

This set of files is here to help developers debug issues with migrations, imports and exports between versions of Ghost, and more specifically, between the DB versions.

There is a table displaying a list of Ghost versions, their release data and their respective database versions over on the [Ghost wiki](https://github.com/TryGhost/Ghost/wiki/Version-Info), the short version is:

| DB Version | Introduced In |
|-----------:|--------------:|
| 003 | 0.5.0 |
| 002 | [0.4.1](0.4.1) |
| 001 | [0.4.0](0.4.0) |
| 000 | [0.3.0](0.3.0) |

Each folder contains the relevant files for each Ghost version, including `ghost.db`, which is a blank DB (no user) generated on startup, the migrations or schema file (`000.js` or `schema.js` depending on which version of Ghost it is), and the `default-settings.json` file.

There is also a `README` in each folder, which I hope to update to contain information on the changes between each version.
