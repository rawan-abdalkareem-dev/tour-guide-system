# Web SQLite support change

Change ID: `web-sqlite-support-2026-09-23`

This file records the isolated changes added to make the existing SQLite data
layer start on Flutter Web. It exists so the change can be removed later
without reverting unrelated work.

## Files owned by this change

- `lib/core/storage/sqlite_service.dart`
  - Imports `kIsWeb` and `sqflite_common_ffi_web`.
  - Selects `databaseFactoryFfiWebNoWebWorker` before opening the database on Web.
- `pubspec.yaml`
  - Adds `sqflite_common_ffi_web: ^1.1.1`.
- `pubspec.lock`
  - Contains the dependency resolution produced by `flutter pub add`.
- `web/sqlite3.wasm`
  - SQLite WASM binary for `sqlite3` 3.1.2.

The existing pins for `sqflite: 2.4.2+1` and
`cached_network_image: 3.4.1` predate this change and must be preserved when
undoing it.

## Undo scope

To undo only this change, remove the two added imports and the `kIsWeb` block
from `SQLiteService.init`, remove `sqflite_common_ffi_web` from dependencies,
refresh the lockfile, delete `web/sqlite3.wasm`, then delete this record.
