# Portfolio 5 Distributed and Cloud Databases

Author: Chigoziem Edmund Ofili (301917477)

The retail point-of-sale (POS) and inventory system could be hosted on the cloud.

## Proposed Deployment

The proposed system would link the two checkout terminals to a PostgreSQL database hosted in the cloud. A primary server would process sales, update inventory records, and manage shift operations. A standby server located in a separate availability zone would maintain a replicated copy of the database to support disaster recovery in the event of a server failure.

**Pro**: This arrangement would remove the need to maintain a database server within the supermarket and reduce the associated maintenance responsibilities.

**Cons**: However, this set up would depend on a stable internet connection. If the connection were interrupted, the checkout terminals would be unable to complete operations requiring database access until connectivity was restored. Offline sales processing is not included in the proposed deployment.

## Data Replication and Server Availability

Database replication would maintain a second copy of the database on a standby server. PostgreSQL streaming replication would be used to keep the standby system updated with changes made the primary.

**Synchronous Replication**: Data loss would be minimised via synchronous replication. Under this arrangement, the primary would not commit a transaction until the standby server acknowledged it. This would add latency but would improve the realiability of data recovery. However, the drawback of this setup would be that if the standby server were unavailable, commits could wait rather than continue without that protection.

**Availability**: In the event that the primary server fails, a disaster recovery mechanism would allow the standby server to take over database operations. The primary server must be prevented from accepting new writes to avoid conflicting records, while the POS terminals would reconnect to the active server. This process would involve a temporary interruption, so continuous availability cannot be guaranteed.

**Backups**: Regular database backups would also be maintained independently of replication. Since replication copies changes between servers, accidental deletions or incorrect updates could affect both databases. Backups would therefore remain necessary to restore data when replication alone cannot resolve the problem.

Reference: [PostgreSQL standby servers and replication](https://www.postgresql.org/docs/16/warm-standby.html).

## Data Consistency

To maintain data consistency, each completed sale would be processed as a single database transaction. If any part of the transaction failed, all changes would be rolled back to prevent incorrect stock records.

**Database Locks**: Database locks would be used to prevent the same item from being sold beyond its actual availability due to simultaenous transactions.

Reference: [PostgreSQL transaction isolation](https://www.postgresql.org/docs/16/transaction-iso.html).

## Limitations CAP Theorem

The CAP theorem states that during a network partition, a distributed system cannot guarantee both consistency and availability. The proposed synchronous replication configuration would prioritize data consistency and durability. If the required standby acknowledgement became unavailable, transactions could be delayed or blocked rather than committed without the intended protection.

Reference: [CAP Theorem](https://www.devcon5.ch/en/blog/2024/02/02/cap_db/)

## System Security and Performance

**Security**: For security, database connections would require encryption, while access would be restricted via authentication and role-based access controls (RBAC). Only authorized application services and administrators would be permitted to connect.

**Performance**: Hosting the database in the cloud would introduce network latency compared with a local database. The system must undergo testing to ensure that transactions can be completed within an acceptable time especially during peak store operations.

## Infrastructure Scalability

Scaling is currently unnecessary for our current single-store design. However, should the business expand to many branches and require subtantially more users, vertical and horizontal scaling could be considered.

**Vertical Scaling**: The cloud application could scaled vertically by increasing the database server's CPI, memory, or storage capacity. This process would be simpler than distributing data across multiple servers. Horizontal scaling could be considered if future business growth exceeds the capacity of a single database server.

**Horizontal Scaling**: Sharding distributes database records across multiple servers through horizontal partitioning. Unlike replication, each server holds different data. The risk of this method is that it would introduce additional complexity and make consistency a challenge to maintain.

Reference: [Microsoft sharding pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/sharding).
