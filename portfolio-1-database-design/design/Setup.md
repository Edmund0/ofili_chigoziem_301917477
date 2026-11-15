# PostgreSQL Environment Setup

Author: Chigoziem Edmund Ofili (301917477)

The PostgreSQL installation, startup, and connection used in this project.

## 1. Open the terminal

- Open the repo in Codespaces. 
- Open a new terminal. 
- Work from the repository root.
- If the terminal ends in `postgres=#`, enter `\q` to leave psql first.

## 2. Install PostgreSQL

Check if PostgreSQL is installed:

```bash
psql --version
```

If PostgreSQL is not installed, run:

```bash
sudo apt-get update
sudo apt-get install -y postgresql
```

## 3. Start PostgreSQL

To start PostgreSQL, run:

```bash
sudo service postgresql start
```

When running to a stopped codespace, re-run this command.

## 4. Open psql

To open the PostgreSQL client, run:

```bash
sudo runuser -u postgres -- psql
```

Ensure the prompt ends in `postgres=#` which indicates a database connection. 


```text
\pset pager off
```

This keeps query results in the terminal instead of opening a separate scrolling view.

## 5. Check the connection

To check the connection, run:

```sql
SELECT current_database(), current_user, version();
```

Check the server version and environment. 

- `psql --version` reports the client version.
- `version()` reports the connected server version.

## 6. Exit psql

To exit psql:

```text
\q
```

## References

1.  [PostgreSQL installation on Ubuntu](https://www.postgresql.org/download/linux/ubuntu/).

2. [PostgreSQL psql commands](https://www.postgresql.org/docs/16/app-psql.html).
