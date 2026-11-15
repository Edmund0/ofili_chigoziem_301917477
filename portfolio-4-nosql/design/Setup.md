# MongoDB Environment Setup

Author: Chigoziem Edmund Ofili (301917477)

## 1. Open the terminal

In GitHub codespaces and on the repository root, confirm the operating system and architecture:

```bash
cat /etc/os-release
dpkg --print-architecture
```

The supplied package source uses Ubuntu 24.04 (noble), amd64. If these differ, use the matching package source from the installation guide below.

## 2. Install MongoDB

If MongoDB and mongosh are not installed, run:

```bash
sudo apt-get update
sudo apt-get install -y curl gnupg
```

Add the MongoDB signing key:

```bash
curl -fsSL https://pgp.mongodb.com/server-8.0.asc | sudo gpg --dearmor --yes -o /usr/share/keyrings/mongodb-server-8.0.gpg
```

Add the package source and install MongoDB:

```bash
sudo cp portfolio-4-nosql/db/code/MongoDBSource.list /etc/apt/sources.list.d/mongodb-org-8.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org
```

## 3. Start MongoDB

If the server is not already running, start mongodb in Terminal A:

```bash
mkdir -p "$HOME/mongodb-data"
mongod --dbpath "$HOME/mongodb-data" --bind_ip 127.0.0.1
```

Keep Terminal A running. The server saves the data in the mongodb-data folder and accepts local connections.

## 4. Open mongosh

Open Terminal B at the repository root and connect to MongoDB:

```bash
mongosh "mongodb://127.0.0.1:27017"
```

## 5. Check the connection

Run each command separately inside mongosh:

```javascript
db.adminCommand({ ping: 1 })
db.version()
db = db.getSiblingDB("pos_events")
db.getName()
db.inventory_events.countDocuments()
```

Check for `ok: 1`, the server version, the database name pos_events and a document count of 0. Selecting the database does not add any records.

If records already exist, check the previous run before loading the test script again.

Evidence: [Setup results](../db/outputs/MongoDBSetup.png).

## References

1. [MongoDB 8.0 installation on Ubuntu](https://www.mongodb.com/docs/v8.0/tutorial/install-mongodb-on-ubuntu/).
2. [MongoDB server options](https://www.mongodb.com/docs/manual/reference/program/mongod/).
