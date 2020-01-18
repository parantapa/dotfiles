#!/usr/bin/env python
"""Drop all indexes in a sqlite3 file."""

import sqlite3
import click


@click.command()
@click.option(
    "-f",
    "--file",
    "fname",
    type=click.Path(exists=True),
    required=True,
    help="Path of the sqlite3 file",
)
def main(fname):
    """Drop all indexes in a sqlite3 file."""
    con = sqlite3.connect(fname)
    sql = "SELECT name FROM sqlite_master WHERE type == 'index'"
    cur = con.execute(sql)
    indexes = [i for i, in cur]

    sql = "DROP INDEX %s"
    for index in indexes:
        print(sql % index)
        con.execute(sql % index)

    sql = "VACUUM"
    con.execute(sql)

if __name__ == "__main__":
    main()
