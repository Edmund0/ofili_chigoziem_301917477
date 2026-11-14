# Portfolio 5 Distributed and Cloud Databases

Author: Chigoziem Edmund Ofili (301917477)

## Proposed Deployment

GoodNaija's POS and inventory system could be hosted on the cloud to deliver even more values to their customers. The proposed system would link the two checkout terminals to a PostgreSQL database hosted on the cloud. The system would require two servers: 
- The **primary server** would process sales and update records.
- The **standby server** in a separate availability zone would maintain a replica of the database to support disaster recovery efforts in the event of a server failure.

**Pro**: This arrangement would eliminate the need for GoodNaija to maintain their own database server within the supermarket. This would reduce the associated risk and cost whilst providing flexibility for future expansion.

**Cons**: This set up requires stable internet connection to maintain uninterrupted service. If the connection were ever offline, the supermarket would be unable to continue operations that require database access. Offline sales processing would not be inlcuded in this proposed deployment. However, it serves as a solution to this problem.

## Part 1: Data Replication, Data Backups, and Server Availability

The proposed system would use database replication to maintain a second copy of the database on a standby server. PostgreSQL streaming replication would be used to keep the standby system updated with changes made the primary. The  

**Synchronous Replication**: The risk of data lose would be minimized with the use of synchronous replication. Under this arrangement, the primary server would not commit a transaction until the standby server acknowledged it. This setup would add latency but would support data integrity and improve the realiability of data recovery. However, the drawback of this setup would be that if the standby server, were unavailable, commits could wait rather than continue without that protection.

**Backups**: Regular database backups would also be maintained independently of synchronous replication. Since replication copies changes between servers, accidental deletions or incorrect updates could affect both databases. Backups would therefore remain necessary to restore data when replication alone cannot resolve the problem.

**Availability**: In the event that the primary servers were to fail, the POS system would be switched over to the standby server. The proposed system would use a disaster recovery mechanism to allow the standby server to take over database operations. To avoid conflicting records, the primary server must be prevented from accepting new writes to avoid conflicting records. This process may involve temporary interruption, so continuous availability cannot be guaranteed.

Reference: [PostgreSQL standby servers and replication](https://www.postgresql.org/docs/16/warm-standby.html).

## Part 2: Data Consistency

To maintain data consistency, each completed sale must be processed as a single database transaction. If any part of the transaction failed, all changes would be rolled back to prevent incorrect stock records.

**Database Locks**: Database locks would be used to prevent the same item from being sold beyond its actual availability due to simultaneous transactions.

Reference: [PostgreSQL transaction isolation](https://www.postgresql.org/docs/16/transaction-iso.html).

## Part 3: Limitations CAP Theorem

The CAP theorem states that during a network partition, a distributed system cannot guarantee both consistency and availability. The proposed synchronous replication configuration prioritizes data consistency and durability. If the required standby acknowledgement became unavailable, transactions could be delayed or blocked rather than committed without the intended protection. This means our design is a CP system.

Reference: [CAP Theorem](https://www.devcon5.ch/en/blog/2024/02/02/cap_db/)

## Part 4: System Security and Performance

**Security**: For security, database connections would require encryption, while access would be restricted via authentication and role-based access controls (RBAC). Only authorized application services and administrators would be permitted to connect.

**Performance**: Compared with a local solution, hosting the servers in the cloud would introduct network latency. The system must undergo testing to ensure that transactions can be completed within an acceptable time, especially during peak store operations.

## Part 4: Infrastructure Scalability

Scaling is currently unnecessary for our current single-store design. However, should the business expand to many branches and require subtantially more users, vertical and horizontal scaling could be considered.

**Vertical Scaling**: The proposed cloud system could be scaled vertically by increasing the database server's CPI, memory, or storage capacity. This process would be simpler than distributing data across multiple servers as with horizontal scaling. 

**Horizontal Scaling**: Sharding distributes database records across multiple servers through horizontal partitioning. Unlike replication, each server holds different data. The risk of this method is that it would introduce additional complexity and make data consistency challenging to maintain.

Reference: [Microsoft sharding pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/sharding).
