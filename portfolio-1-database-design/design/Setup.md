# PostgreSQL Environment Setup

Author: Chigoziem Edmund Ofili (301917477)

PostgreSQL installation, startup and connection in GitHub Codespaces.

## 1. Open the terminal

Open the repository in Codespaces, then choose Terminal → New Terminal. Work from the repository root, where the five portfolio folders are visible.

The commands below go in the shell terminal. If the prompt ends in `=#`, enter `\q` to leave psql first.

## 2. Install PostgreSQL

Check whether the client is installed:

```bash
psql --version
```

If PostgreSQL is not installed, run:

```bash
sudo apt-get update
sudo apt-get install -y postgresql
```

Installation is needed once per Codespace environment.

## 3. Start PostgreSQL

```bash
sudo service postgresql start
```

Run this when returning to a stopped Codespace. Existing databases do not need to be recreated.

## 4. Open psql

```bash
sudo runuser -u postgres -- psql
```

A prompt such as `postgres=#` indicates a database connection. The remaining commands go inside psql.

```text
\pset pager off
```

This keeps query results in the terminal instead of opening a separate scrolling view.

## 5. Check the connection

```sql
SELECT current_database(), current_user, version();
```

Record the actual server version and environment. `psql --version` reports the client version; `version()` reports the connected server version.

## 6. Exit psql

To exit psql:

```text
\q
```

## References

Reference: [PostgreSQL installation on Ubuntu](https://www.postgresql.org/download/linux/ubuntu/).

Reference: [PostgreSQL psql commands](https://www.postgresql.org/docs/16/app-psql.html).
