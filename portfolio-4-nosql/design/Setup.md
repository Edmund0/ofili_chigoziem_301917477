# MongoDB Setup

Author: Chigoziem Edmund Ofili (301917477)

## 1. Check the Codespace

Open a Codespaces terminal at the repository root. Run:

```bash
cat /etc/os-release
dpkg --print-architecture
```

The supplied package source is for Ubuntu 24.04 (noble), amd64. If these differ, use the matching repository entry in the MongoDB installation guide before continuing.

## 2. Install MongoDB

Skip this section if MongoDB and mongosh are already installed. Run each command in the Codespaces terminal:

```bash
sudo apt-get update
sudo apt-get install -y curl gnupg
```

Import the signing key:

```bash
curl -fsSL https://pgp.mongodb.com/server-8.0.asc | sudo gpg --dearmor --yes -o /usr/share/keyrings/mongodb-server-8.0.gpg
```

Copy the package source and install MongoDB:

```bash
sudo cp portfolio-4-nosql/db/code/MongoDBSource.list /etc/apt/sources.list.d/mongodb-org-8.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org
```

## 3. Start the server

Skip this section if a MongoDB server is already running locally. In Terminal A:

```bash
mkdir -p "$HOME/mongodb-data"
mongod --dbpath "$HOME/mongodb-data" --bind_ip 127.0.0.1
```

Keep Terminal A running. This stores the practice data in mongodb-data inside the Codespaces user's home directory and accepts local connections only.

## 4. Connect and check

Open Terminal B at the repository root:

```bash
mongosh "mongodb://127.0.0.1:27017"
```

Run each of the following commands separately inside mongosh, pressing Enter after each:

```javascript
db.adminCommand({ ping: 1 })
db.version()
db = db.getSiblingDB("pos_events")
db.getName()
db.inventory_events.countDocuments()
```

Check for `ok: 1`, the server version, the database name pos_events and an initial document count of zero. Selecting the database does not populate it; the test script creates the collection when it inserts the events.

If documents already exist, inspect the previous run before loading the sample again.

Save the connection-check output as evidence and record the actual MongoDB version and environment in [Test.md](../db/Test.md).

## 5. Run the tests

Continue with the command tests in the [Portfolio 4 tests](../db/Test.md#steps). Run them in Terminal B, leaving the MongoDB server running in Terminal A.

## References

Reference: [MongoDB 8.0 installation on Ubuntu](https://www.mongodb.com/docs/v8.0/tutorial/install-mongodb-on-ubuntu/).

Reference: [MongoDB server options](https://www.mongodb.com/docs/manual/reference/program/mongod/).
