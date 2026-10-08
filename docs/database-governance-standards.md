# Database Governance & Standards Guide

> **Portfolio Project:** Enterprise Citizen Licensing & Permit Management Platform
> **Database Platform:** PostgreSQL
> **Document Purpose:** Define database design, development, security, integrity, naming, and performance standards for the platform.

---

## 1. Purpose

This document establishes the database standards that will be followed when designing, implementing, maintaining, and extending the Citizen Licensing & Permit Management Platform.

The standards are intended to provide:

* Consistent database structures
* Reliable data integrity
* Maintainable SQL development
* Secure access to data
* Predictable application performance
* Easier troubleshooting and support
* Consistent development practices across application teams

The standards apply to tables, columns, keys, relationships, constraints, indexes, queries, and database security.

---

# 2. Database Platform

The project uses **PostgreSQL** as the target relational database management system.

PostgreSQL was selected because it provides:

* Strong relational database capabilities
* Foreign key and constraint enforcement
* Advanced indexing
* Transaction support
* Common Table Expressions
* Query execution analysis
* Role-based access control
* Table partitioning
* Strong support for enterprise application workloads

The physical implementation will use PostgreSQL-compatible SQL.

---

# 3. Naming Standards

## 3.1 General Naming Convention

All database objects use lowercase `snake_case`.

Example:

```text
application_status_history
```

instead of:

```text
ApplicationStatusHistory
```

or:

```text
applicationStatusHistory
```

This provides a consistent naming standard and avoids unnecessary quoting of identifiers in PostgreSQL.

---

## 3.2 Table Names

Table names must:

* Use lowercase letters.
* Use `snake_case`.
* Use descriptive business names.
* Use plural nouns for entity tables.

Examples:

```text
citizens
applications
application_reviews
audit_logs
```

Avoid:

```text
tblCitizens
ApplicationTable
data1
temp_table
```

---

## 3.3 Column Names

Column names must use lowercase `snake_case`.

Examples:

```text
application_id
application_type_id
created_at
updated_at
payment_reference
```

Column names should describe the data they contain.

Avoid ambiguous names such as:

```text
data
value
info
desc
flag
```

unless the meaning is unambiguous within the specific table.

---

# 4. Primary Key Standards

Every major entity must have a primary key.

Primary key naming follows:

```text
<table_name_singular>_id
```

Examples:

```text
citizen_id
application_id
document_id
payment_id
user_id
```

Primary keys must:

* Uniquely identify a record.
* Never be reused for another record.
* Not contain business meaning that could change.
* Be indexed automatically through the primary key constraint.

PostgreSQL identity columns will be used where automatic identifier generation is appropriate.

---

# 5. Foreign Key Standards

Relationships between entities must be enforced using foreign keys.

Example:

```text
applications.citizen_id
        ↓
citizens.citizen_id
```

Foreign keys provide database-level referential integrity.

They prevent dependent records from referencing nonexistent parent records.

Foreign key columns should use the same data type as the referenced primary key.

Foreign key names should follow:

```text
fk_<child_table>_<parent_table>
```

Example:

```text
fk_applications_citizens
```

---

# 6. Constraint Standards

Business-critical data rules should be enforced at the database level whenever practical.

## 6.1 NOT NULL

Use `NOT NULL` when a value is required for a valid record.

Example:

```text
application_id
citizen_id
application_type_id
application_number
```

---

## 6.2 UNIQUE

Use `UNIQUE` when duplicate values would violate business rules.

Examples:

```text
application_number
payment_reference
username
email_address
role_code
type_code
```

---

## 6.3 CHECK Constraints

Use `CHECK` constraints for basic data validation.

Examples include:

```text
payment amount >= 0
application fee >= 0
```

Controlled business values should also be restricted where appropriate.

For example, approval decisions should only allow:

```text
APPROVED
REJECTED
RETURNED
```

Database constraints provide an additional layer of protection even if an application incorrectly submits invalid data.

---

# 7. Data Type Standards

Data types must accurately represent the data being stored.

### Identifiers

Use:

```text
bigint
```

or an appropriate integer-based identity type.

### Text

Use:

```text
varchar
text
```

depending on whether a meaningful maximum length is required.

### Monetary Values

Use:

```text
numeric(12,2)
```

or another appropriate exact numeric precision.

Floating-point types should not be used for financial amounts because rounding behaviour can introduce inaccuracies.

### Dates

Use:

```text
date
```

when only a calendar date is required.

### Timestamps

Use:

```text
timestamp with time zone
```

for system events where the time zone context should be preserved.

---

# 8. Timestamp Standards

Operational tables should use timestamps where record creation or modification needs to be tracked.

Common columns include:

```text
created_at
updated_at
```

Historical and event-based tables should use descriptive timestamps.

Examples:

```text
submitted_at
reviewed_at
decision_at
uploaded_at
event_timestamp
```

Timestamps should be generated consistently by the database or application service rather than relying on manually entered values.

---

# 9. Normalization Standards

The database should follow normalized relational design principles.

The design should generally target at least **Third Normal Form (3NF)** unless a documented performance requirement justifies controlled denormalization.

Normalization should be used to reduce:

* Duplicate data
* Update anomalies
* Insert anomalies
* Delete anomalies
* Inconsistent reference information

For example, application type information is stored in:

```text
application_types
```

rather than repeatedly storing the type name and fee inside every application record.

---

# 10. Reference Data Standards

Controlled reference information should be stored in dedicated reference entities where appropriate.

Examples include:

```text
application_types
roles
```

Reference data should not be repeatedly hard-coded throughout transactional tables.

This allows reference values to be centrally managed and consistently applied.

Inactive reference records should generally be retained rather than physically deleted when historical transactions depend on them.

---

# 11. Many-to-Many Relationship Standards

Many-to-many relationships must be implemented using association tables.

Example:

```text
users
   ↕
user_roles
   ↕
roles
```

Another example:

```text
applications
      ↕
application_documents
      ↕
documents
```

Association tables should contain foreign keys to both related entities.

Where appropriate, a unique constraint should prevent duplicate relationships.

---

# 12. Indexing Strategy

Indexes will be created based on expected access patterns rather than automatically indexing every column.

Indexes improve query performance but also introduce:

* Additional storage requirements
* Additional write overhead
* Additional maintenance requirements

Therefore, indexes should be created when they support meaningful query patterns.

## 12.1 Primary Keys

Primary keys are automatically indexed through PostgreSQL primary key constraints.

---

## 12.2 Foreign Keys

Foreign key columns should be evaluated for indexing because they are commonly used in:

* Joins
* Filtering
* Relationship lookups

Examples include:

```text
applications.citizen_id
applications.application_type_id
payments.application_id
application_reviews.application_id
```

---

## 12.3 Search Columns

Frequently searched business identifiers may require indexes.

Examples:

```text
application_number
payment_reference
username
email_address
```

---

## 12.4 Time-Based Queries

Timestamp columns may require indexes when the application frequently retrieves records by date range.

Examples include:

```text
submitted_at
changed_at
event_timestamp
```

The final indexing strategy will be validated using PostgreSQL query execution plans.

---

# 13. Query Performance Standards

Database queries should be designed to minimize unnecessary processing.

Development teams should:

* Select only required columns.
* Use appropriate filtering.
* Avoid unnecessary nested queries.
* Use indexed columns for common lookup patterns.
* Avoid functions on indexed columns when they prevent index usage.
* Avoid unnecessary wildcard searches.
* Review execution plans for expensive queries.

For performance investigation, PostgreSQL will use:

```sql
EXPLAIN
```

and where appropriate:

```sql
EXPLAIN (ANALYZE, BUFFERS)
```

Execution plans will be reviewed for:

* Sequential scans
* Index scans
* Join strategies
* Estimated versus actual rows
* Execution time
* Buffer reads
* Sort operations
* Expensive operators

---

# 14. Referential Integrity Standards

Foreign keys must be used to enforce valid relationships between parent and child records.

Delete and update behaviours must be selected based on business requirements.

Possible actions include:

```text
RESTRICT
CASCADE
SET NULL
```

`CASCADE` should not be used by default.

Cascading deletes must be justified because deleting a parent record may unintentionally remove large amounts of dependent data.

For historical and audit records, deletion should generally be restricted.

---

# 15. Historical Data Standards

Important historical information must not be overwritten when doing so would remove required business history.

For example:

```text
application_status_history
```

stores individual application status changes.

The current status is maintained separately in:

```text
applications.current_status
```

This provides efficient access to the current state while preserving historical events.

---

# 16. Audit Standards

Significant system activity should be auditable.

The audit model records:

* User
* Action
* Entity
* Record
* Timestamp
* Additional details

Audit information should be protected from unauthorized modification.

Audit records should not be casually deleted as part of normal transactional cleanup.

---

# 17. Security Standards

Database access should follow the **principle of least privilege**.

Users and services should receive only the permissions required to perform their responsibilities.

Access should be separated between:

* Application services
* Developers
* Analysts
* Administrators

Application accounts should not automatically receive unrestricted database privileges.

The database security implementation will be demonstrated separately in the security and cost optimization project.

---

# 18. Environment Separation

Development, testing, and production environments should be logically separated.

Production data should not be copied into development environments without appropriate authorization and data protection controls.

Where realistic test data is required, synthetic or anonymized data should be used.

---

# 19. Change Management

Database changes should be:

1. Documented.
2. Reviewed.
3. Tested.
4. Version controlled.
5. Applied through repeatable scripts.

Schema changes should not rely on manually modifying production tables without a documented migration process.

SQL scripts in this project are stored in GitHub so database changes can be reviewed and tracked.

---

# 20. Documentation Standards

Database changes should be documented when they affect:

* Entity relationships
* Business rules
* Constraints
* Indexing
* Security
* Performance
* Data retention
* Application behaviour

Technical documentation should be understandable to both database specialists and application development teams.

---

# 21. Governance Principles

The database design follows these governance principles:

1. **Integrity** — Invalid relationships and invalid values should be prevented at the database level.
2. **Consistency** — Database objects follow consistent naming and implementation standards.
3. **Security** — Access is restricted according to job responsibilities.
4. **Traceability** — Important changes and activities can be investigated.
5. **Performance** — Query and indexing decisions are based on measurable workload requirements.
6. **Maintainability** — Database structures should remain understandable and support future development.
7. **Scalability** — Design decisions should support increasing transaction and data volumes.
8. **Cost Awareness** — Storage, indexing, and infrastructure resources should be used efficiently.
9. **Change Control** — Database modifications should be version controlled and repeatable.
10. **Standards Compliance** — Database implementations should follow approved organizational and technology standards.

---

# 22. Implementation Roadmap

The standards defined in this document will be implemented through the following project components:

| Standard            | Implementation                    |
| ------------------- | --------------------------------- |
| Naming conventions  | PostgreSQL schema                 |
| Primary keys        | PostgreSQL constraints            |
| Foreign keys        | PostgreSQL relationships          |
| Data integrity      | `NOT NULL`, `UNIQUE`, `CHECK`     |
| Indexing            | Query-specific indexes            |
| Performance         | `EXPLAIN (ANALYZE, BUFFERS)`      |
| Historical tracking | Status history tables             |
| Auditability        | Audit log table                   |
| Security            | PostgreSQL roles and privileges   |
| Cost optimization   | Partitioning and storage strategy |
| Change management   | Git version control               |

---

## 23. Review and Maintenance

This document should be reviewed whenever significant changes are made to the database architecture, application requirements, security model, or performance strategy.

All future database changes should remain consistent with these standards unless a documented exception is approved.

