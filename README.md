# Purpose

This is just a small example to show that Beam can do auto-migrations.

# To Run

`nix-build` and run the binary. Then `sqlite3 test.sqlite3` and examine the schema with `.schema` in the SQLite REPL.

If you uncomment and the commented column and re-run, it should get added to the schema.
