# Database Governance & Standards Guide

> **Portfolio Project:** Enterprise Citizen Licensing & Permit Management Platform  
> **Database Platform:** PostgreSQL  
> **Document Purpose:** Establish database design, development, integrity, security, performance, and change-management standards for the portfolio project.

## 1. Purpose and Scope

This document defines the standards used to design, implement, document, and maintain the simulated Citizen Licensing & Permit Management Platform database.

The standards aim to promote:

- Consistent database structures and naming conventions.
- Reliable data integrity and referential integrity.
- Maintainable and reviewable SQL scripts.
- Secure access to database objects and data.
- Appropriate indexing and query performance.
- Traceability of database changes.
- Clear technical documentation and governance practices.

These standards apply to tables, columns, keys, constraints, indexes, queries, relationships, access controls, and database changes.

This is a portfolio-level governance guide. Recommendations concerning production security, deployment, monitoring, and operational controls are not represented as implemented unless explicitly validated in the project.

## 2. Database Platform

The project uses PostgreSQL as its relational database management system.

PostgreSQL provides capabilities relevant to this project, including:

- Primary key, foreign key, unique, and check constraints.
- Transaction management.
- Identity columns and default values.
- Common Table Expressions (CTEs).
- Indexing and query execution plans.
- Database roles and privileges.
- Views and other relational database features.
- Table partitioning for suitable workloads.

The physical implementation uses PostgreSQL-compatible SQL. The schema, sample data, and reporting queries are maintained as version-controlled project scripts.

## 3. Naming Standards

### 3.1 General conventions

Database object names use lowercase `snake_case`.

Example:

```text
application_status_history
```

Avoid inconsistent naming such as:

```text
ApplicationStatusHistory
applicationStatusHistory
```

Consistent naming reduces ambiguity and avoids unnecessary identifier quoting in PostgreSQL.

### 3.2 Table names

Table names should:

- Use lowercase letters and underscores.
- Use descriptive business terms.
- Generally use plural nouns for entity tables.
- Avoid unexplained abbreviations and temporary names in permanent schemas.

Examples:

```text
citizens
applications
application_reviews
audit_logs
```

### 3.3 Column names

Column names should use lowercase `snake_case` and describe the stored information clearly.

Examples:

```text
application_id
application_type_id
created_at
updated_at
payment_reference
```

Names such as `data`, `value`, `info`, and `flag` should be avoided when a more descriptive name is practical.

### 3.4 Constraint and index names

Constraint and index names should identify their purpose and related table.

Recommended patterns include:

```text
pk_<table_name>
fk_<child_table>_<parent_table>
uq_<table_name>_<column_or_combination>
ck_<table_name>_<rule>
idx_<table_name>_<column_or_combination>
```

For example:

```text
idx_applications_citizen_id
```

Names must remain unique within the relevant PostgreSQL naming scope. Existing project object names should be retained or changed through a documented schema update rather than inconsistently renamed across files.

## 4. Primary Key Standards

Every entity table must have a primary key that uniquely identifies each record.

The project generally follows this naming pattern:

```text
<table_name_singular>_id
```

Examples include:

```text
citizen_id
application_id
document_id
payment_id
user_id
```

Primary keys should:

- Uniquely identify records.
- Be stable throughout the record's lifecycle.
- Avoid encoding business information that may change.
- Use an appropriate data type for the expected workload.
- Be referenced by foreign keys where relationships require it.

PostgreSQL identity columns are used where automatic identifier generation is appropriate.

The `citizen_profiles` table uses `citizen_id` as both its primary key and its foreign key to `citizens`, supporting a one-to-one profile design.

## 5. Foreign Key Standards

Relationships between tables should be enforced using foreign keys wherever appropriate.

Example:

```text
applications.citizen_id
    → citizens.citizen_id
```

Foreign keys prevent dependent records from referencing nonexistent parent records.

Standards include:

- Use compatible data types for related key columns.
- Document the purpose of each relationship.
- Select deletion and update behaviours based on business requirements.
- Evaluate foreign-key indexes based on query patterns and workload.
- Avoid removing or bypassing constraints without a documented reason.

Foreign keys provide referential integrity but do not automatically enforce every business workflow rule.

## 6. Constraint and Data Integrity Standards

Business-critical data rules should be enforced in the database whenever practical.

### 6.1 `NOT NULL`

Use `NOT NULL` when a value is mandatory for a valid record.

Examples include required application identifiers, ownership references, payment amounts, and approval decisions.

Nullability should reflect the business lifecycle. For example, `applications.submitted_at` may be `NULL` before submission, and `payments.paid_at` may be `NULL` before payment completion.

### 6.2 `PRIMARY KEY`

Use primary keys to ensure each row has a unique, non-null identifier.

### 6.3 `UNIQUE`

Use unique constraints when duplicate values would violate a business rule.

Project examples include:

- `applications.application_number`
- `payments.payment_reference`
- `users.username`
- `users.email_address`
- `roles.role_code`
- `application_types.type_code`

Unique constraints may also apply to combinations of columns, such as `(application_id, document_id)` in `application_documents`.

### 6.4 `CHECK`

Use check constraints for rules that can be validated against a row.

Examples implemented in the project include:

- Payment amounts cannot be negative.
- Application fees cannot be negative.
- Approval decisions must be one of the permitted values.
- Selected required text fields cannot contain only whitespace.

The approval decision values currently permitted by the schema are:

```text
APPROVED
REJECTED
RETURNED
```

### 6.5 Application-level rules

Some rules require coordination across multiple records or depend on the user's permissions and workflow.

Examples include:

- Whether a status transition is permitted.
- Whether a user is authorized to approve a particular application.
- Whether a payment status is consistent with its timestamp.
- Whether conflicting approval decisions are permitted.
- Whether every required audit event has been recorded.

Such rules require application logic, database procedures, triggers, or other controls where appropriate. They should not be assumed to be enforced by a constraint unless that constraint exists in the schema.

## 7. Data Type Standards

Data types should represent the stored information accurately and support the intended operations.

### 7.1 Identifiers

Use appropriate integer-based identity columns for generated identifiers. The selected type should account for expected data volume.

### 7.2 Text

Use `varchar(n)` when a meaningful maximum length should be enforced, and `text` when a fixed maximum is not required.

Length limits should reflect documented business requirements rather than being chosen arbitrarily.

### 7.3 Monetary values

Use an exact numeric type such as:

```sql
numeric(12,2)
```

Floating-point types should generally be avoided for monetary amounts because their approximate representation can introduce rounding differences.

### 7.4 Dates

Use `date` when only a calendar date is required, such as a date of birth.

### 7.5 Timestamps

Select timestamp types according to the application's time-handling requirements.

PostgreSQL supports both:

```sql
timestamp
```

and:

```sql
timestamp with time zone
```

The current project uses `TIMESTAMP` columns without time-zone information. A production implementation should establish a consistent time-zone policy, particularly for events generated across multiple regions or systems.

## 8. Timestamp Standards

Timestamp columns should communicate the event or lifecycle point they represent.

Common examples include:

```text
created_at
updated_at
submitted_at
reviewed_at
decision_at
uploaded_at
event_timestamp
```

Standards include:

- Use consistent naming for equivalent events.
- Avoid manually entering timestamps when a trusted database or application mechanism can generate them.
- Document the meaning of each timestamp.
- Distinguish record creation from business-event timestamps.
- Define a consistent time-zone policy for production use.

**Important implementation detail:** A PostgreSQL `DEFAULT CURRENT_TIMESTAMP` initializes a column when a row is inserted without an explicit value. It does not automatically update an `updated_at` column when the row changes.

Automatic modification tracking requires an additional mechanism, such as a trigger or application logic. The current project's default values should not be described as automatic update tracking.

## 9. Normalization Standards

The database should follow normalized relational design principles.

The design generally targets Third Normal Form (3NF), unless a documented requirement justifies a different approach.

Normalization helps reduce:

- Duplicate data.
- Update anomalies.
- Insert anomalies.
- Delete anomalies.
- Inconsistent reference information.

Examples from the project include:

- Application types are stored in `application_types`, rather than repeatedly storing their definitions in application records.
- Current application status is separated from status history.
- Document metadata is separated from application-document associations.
- Reviews are separated from approval decisions.
- User-role assignments are stored in a junction table.

A claim that every table satisfies a particular normal form should be supported by a formal review of candidate keys and functional dependencies.

## 10. Reference Data Standards

Controlled reference information should be maintained in dedicated reference tables where appropriate.

Examples include:

```text
application_types
roles
```

Reference tables support consistent values and centralized maintenance.

Where historical records depend on a reference value, deactivation is generally preferable to physical deletion. Changes to reference data should be reviewed for their effects on existing records and reports.

## 11. Many-to-Many Relationship Standards

Many-to-many relationships should be implemented using association tables.

The project includes:

```text
applications
    ↕
application_documents
    ↕
documents
```

and:

```text
users
    ↕
user_roles
    ↕
roles
```

Association tables should contain foreign keys to the related entities. Unique constraints should prevent duplicate associations when duplicate relationships are not permitted by the business model.

## 12. Indexing Standards

Indexes should support identified query patterns rather than being added indiscriminately.

Indexes can improve reads but also introduce storage requirements, write overhead, and maintenance costs.

### 12.1 Primary keys and unique constraints

PostgreSQL automatically creates indexes to enforce primary key and unique constraints.

Additional indexes should be evaluated separately to avoid unnecessary duplication.

### 12.2 Foreign keys

Foreign-key columns should be evaluated for indexing when they are used frequently in joins, filtering, or relationship lookups.

Examples include:

```text
applications.citizen_id
applications.application_type_id
payments.application_id
application_reviews.application_id
```

A foreign key does not automatically create an index on the referencing column in PostgreSQL.

### 12.3 Search and filtering

Frequently searched business identifiers and status columns may benefit from indexes, depending on actual query patterns and selectivity.

Examples include:

```text
application_number
payment_reference
username
email_address
current_status
payment_status
```

Unique constraints already create supporting indexes for several of these columns.

### 12.4 Time-based queries

Timestamp indexes may be appropriate when queries frequently filter or sort by event time.

Examples include:

```text
submitted_at
changed_at
event_timestamp
```

### 12.5 Validation

Indexing decisions should be reviewed against representative queries and execution plans. The existence of an index does not guarantee that PostgreSQL will use it or that it improves every workload.

## 13. Query Performance Standards

Queries should be designed to minimize unnecessary work while remaining readable and maintainable.

Recommended practices include:

- Select only the columns required by the task.
- Apply appropriate filters.
- Use joins that reflect the intended relationships.
- Avoid unnecessary nested queries and repeated calculations.
- Review indexes against actual query patterns.
- Avoid applying functions to indexed columns in ways that prevent useful index access, unless an appropriate expression index or alternative design is justified.
- Measure performance before making optimization claims.

PostgreSQL provides tools for reviewing query plans:

```sql
EXPLAIN
SELECT *
FROM applications
WHERE current_status = 'APPROVED';
```

For suitable test queries, execution can be measured using:

```sql
EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM applications
WHERE current_status = 'APPROVED';
```

`EXPLAIN ANALYZE` executes the query. Use it carefully for statements that modify data, and prefer a safe test environment for performance experiments.

Execution plans can be reviewed for:

- Sequential scans and index scans.
- Join strategies.
- Estimated versus actual row counts.
- Execution time.
- Buffer activity.
- Sort operations.
- Expensive plan nodes.

The portfolio includes reporting queries and a documented indexing strategy. Performance improvements should only be claimed when supported by measured results.

## 14. Referential Integrity and Delete Behaviour

Foreign keys should enforce valid parent-child relationships.

Delete and update behaviours must be chosen according to the business rules. PostgreSQL supports actions such as:

```text
RESTRICT
CASCADE
SET NULL
```

`CASCADE` should not be the default choice for every relationship. Deleting a parent can otherwise remove dependent records unexpectedly.

For historical, financial, and audit-related records, retention requirements should be considered before allowing deletion. The selected behaviour should be documented and tested.

## 15. Historical Data Standards

Historical information should be retained when overwriting it would remove important business history.

For example:

- `applications.current_status` stores the current status.
- `application_status_history` stores status-change records.

This design supports current-state queries and historical analysis.

The application workflow should ensure that relevant changes are recorded consistently. The schema's ability to store history does not, by itself, guarantee that every status change is captured.

## 16. Audit Standards

Significant system activities should be auditable when required by the business and security model.

The `audit_logs` table can record:

- Associated user.
- Action type.
- Affected entity.
- Affected record identifier.
- Event timestamp.
- Additional details.

Audit data should be protected against unauthorized modification and deletion. Retention, access restrictions, completeness, and monitoring should be defined as part of a production governance plan.

The current project implements an audit-log table and sample records; it does not claim to implement comprehensive audit capture or production-grade tamper protection.

## 17. Security and Access Standards

Database access should follow the principle of least privilege.

Users and services should receive only the permissions needed for their responsibilities.

A production access model should distinguish, where applicable, between:

- Application service accounts.
- Developers.
- Analysts and reporting users.
- Database administrators.
- Deployment and maintenance accounts.

Additional standards include:

- Avoid granting unrestricted privileges to application accounts.
- Protect credentials and secrets.
- Restrict access to sensitive information.
- Review role assignments periodically.
- Separate development, testing, and production access.
- Document administrative privileges and access changes.

The project includes `users`, `roles`, and `user_roles` as application data entities. These tables are not equivalent to PostgreSQL database roles and privileges, and they do not independently enforce database-level access control.

## 18. Environment Separation and Test Data

Development, testing, and production environments should be logically separated.

Production data should not be copied into development environments without authorization and appropriate privacy safeguards. Synthetic or properly anonymized data should be used for development and testing where possible.

For this portfolio, a separate PostgreSQL test database was used to validate schema creation, sample-data insertion, reporting queries, and selected relationship checks.

The test database is separate from the original project database, reducing the risk of duplicate seed-data errors during fresh validation.

## 19. Change Management

Database changes should be:

1. Documented.
2. Reviewed.
3. Tested.
4. Version controlled.
5. Applied using repeatable SQL scripts or a migration process.

Changes should not rely solely on undocumented manual modifications to a live database.

Project schema creation, sample-data insertion, and reporting queries are maintained in GitHub. Future schema changes should update the SQL scripts, data model, data dictionary, business rules, and related documentation as applicable.

A production deployment process would additionally require approved migration procedures, rollback or recovery planning, and appropriate release controls.

## 20. Documentation Standards

Documentation should be updated when changes affect:

- Tables, columns, or relationships.
- Keys and constraints.
- Indexing and query performance.
- Business rules and data validation.
- Security and permissions.
- Historical data and audit requirements.
- Deployment and maintenance processes.

Technical documentation should be understandable to database specialists, application developers, and other relevant stakeholders.

Documentation should distinguish between implemented controls, design recommendations, and future enhancements.

## 21. Governance Principles

The project follows these governance principles:

1. **Integrity:** Enforce valid relationships and data rules at the database level where practical.
2. **Consistency:** Use repeatable naming and implementation conventions.
3. **Security:** Limit access according to responsibilities.
4. **Traceability:** Maintain documentation and appropriate historical records.
5. **Performance:** Base optimization decisions on query patterns and measured evidence.
6. **Maintainability:** Keep database structures understandable and documented.
7. **Scalability:** Consider expected data volume and workload when making design decisions.
8. **Cost awareness:** Balance performance benefits against storage and maintenance overhead.
9. **Change control:** Keep changes version controlled and repeatable.
10. **Transparency:** Clearly identify which controls are implemented and which remain recommendations.

## 22. Standards and Project Implementation

| Standard | Project implementation or current status |
|---|---|
| Naming conventions | Applied across the PostgreSQL schema and project documentation |
| Primary keys | Implemented through PostgreSQL primary key constraints |
| Foreign keys | Implemented for documented entity relationships |
| Data integrity | Implemented using `NOT NULL`, `UNIQUE`, and `CHECK` constraints where defined |
| Indexing | Schema indexes are defined; workload-specific effectiveness requires further measurement |
| Query performance | Reporting queries have been executed; broader performance benchmarking is future work |
| Historical tracking | Application status history table is implemented |
| Auditability | Audit-log table and sample records are implemented; comprehensive event capture is not established |
| Security | Application user and role entities are modelled; production database privileges require separate configuration |
| Environment separation | A separate test database was used for fresh validation |
| Change management | SQL scripts and documentation are maintained in GitHub |
| Cost optimization | Design considerations are documented; infrastructure cost optimization has not been benchmarked |

## 23. Review and Maintenance

This guide should be reviewed when database requirements, architecture, security expectations, or performance needs change.

Changes to the schema should be reflected in the associated SQL scripts, ERD, data dictionary, business rules, and other relevant documentation.

Exceptions to these standards should have a documented rationale. Standards should evolve with the project while preserving data integrity, maintainability, and clarity about implementation status.

**Document Status:** Governance standards documented for the portfolio project. The PostgreSQL schema and sample dataset have been tested in a separate test database. Security hardening, production deployment controls, and comprehensive performance benchmarking remain outside the scope of the validation completed to date.
