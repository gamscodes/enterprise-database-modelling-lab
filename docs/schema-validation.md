# Schema Validation

> **Portfolio Project:** Citizen Licensing & Permit Management Platform
> **Database:** PostgreSQL

## 1. Validation Objective

The purpose of this validation is to confirm that the physical database schema correctly implements the logical data model and enforces the required data integrity rules.

The schema is designed to support:

* Relational database design
* Data normalization
* Referential integrity
* Required-field validation
* Unique business identifiers
* Business-rule validation
* Performance-oriented indexing
* Auditability

---

## 2. Primary Key Validation

Each major entity contains a primary key.

| Table                        | Primary Key               |
| ---------------------------- | ------------------------- |
| `citizens`                   | `citizen_id`              |
| `citizen_profiles`           | `citizen_id`              |
| `application_types`          | `application_type_id`     |
| `users`                      | `user_id`                 |
| `roles`                      | `role_id`                 |
| `applications`               | `application_id`          |
| `application_status_history` | `status_history_id`       |
| `documents`                  | `document_id`             |
| `application_documents`      | `application_document_id` |
| `application_reviews`        | `review_id`               |
| `application_approvals`      | `approval_id`             |
| `payments`                   | `payment_id`              |
| `user_roles`                 | `user_role_id`            |
| `audit_logs`                 | `audit_log_id`            |

Primary keys uniquely identify records and provide stable references for relationships between entities.

---

## 3. Foreign Key Validation

Foreign keys are used to enforce relationships between dependent entities and their parent entities.

Examples include:

```text
applications.citizen_id
        ↓
citizens.citizen_id
```

```text
applications.application_type_id
        ↓
application_types.application_type_id
```

```text
payments.application_id
        ↓
applications.application_id
```

```text
application_reviews.reviewer_user_id
        ↓
users.user_id
```

Foreign key constraints prevent dependent records from referencing nonexistent parent records.

---

## 4. Required-Field Validation

Important business attributes are defined using `NOT NULL`.

Examples include:

* Citizen names
* Application type
* Application owner
* Application number
* Payment amount
* Review status
* Approval decision
* Audit action

This prevents incomplete records from entering the database where the business process requires the information.

---

## 5. Uniqueness Validation

Unique constraints are used where duplicate values would create data integrity problems.

Examples include:

```text
users.username
users.email_address
roles.role_code
application_types.type_code
applications.application_number
payments.payment_reference
```

The `user_roles` table also prevents duplicate assignment of the same role to the same user through a composite uniqueness constraint.

---

## 6. Check Constraint Validation

Check constraints enforce basic business rules directly within the database.

Examples include:

```text
application_fee >= 0
payment amount >= 0
approval decision must be APPROVED, REJECTED, or RETURNED
```

Name fields and other required text fields also use checks to prevent blank values.

This approach moves important data-quality rules into the database layer rather than relying entirely on application code.

---

## 7. Naming Convention Validation

The schema follows a consistent `snake_case` naming convention.

Examples:

```text
citizen_id
application_type_id
payment_reference
created_at
updated_at
```

Constraint names also follow a predictable convention:

```text
pk_<table>
fk_<table>_<reference>
uq_<table>_<column>
chk_<table>_<rule>
```

Indexes follow:

```text
idx_<table>_<column>
```

Consistent naming improves maintainability and makes the schema easier for development and database administration teams to understand.

---

## 8. Indexing Strategy

Indexes are created primarily on foreign-key columns and frequently queried operational attributes.

Examples include:

```text
applications.citizen_id
applications.application_type_id
applications.current_status
application_status_history.application_id
application_reviews.application_id
application_approvals.application_id
payments.application_id
audit_logs.event_timestamp
```

The objective is to improve lookup and join performance without indiscriminately indexing every column.

Indexes will be reviewed and adjusted after query-performance testing using PostgreSQL execution plans.

---

## 9. Normalization Validation

The schema separates major business concepts into independent entities.

Examples include:

* Citizens and applications
* Application types and applications
* Applications and status history
* Applications and documents
* Applications and reviews
* Applications and approvals
* Applications and payments
* Users and roles

This reduces repeating data and supports a normalized relational design.

Many-to-many relationships are resolved through association tables such as:

```text
application_documents
user_roles
```

---

## 10. Validation Status

| Area                 | Status      |
| -------------------- | ----------- |
| Primary keys         | Implemented |
| Foreign keys         | Implemented |
| NOT NULL constraints | Implemented |
| UNIQUE constraints   | Implemented |
| CHECK constraints    | Implemented |
| Naming conventions   | Implemented |
| Initial indexes      | Implemented |
| Normalization review | Completed   |
| Runtime SQL testing  | Pending     |

---

## 11. Next Validation Stage

The next stage is to execute the schema against PostgreSQL and verify that:

1. All tables are created successfully.
2. All constraints are accepted.
3. Foreign-key relationships behave as expected.
4. Invalid data is rejected.
5. Valid data can be inserted successfully.
6. Indexes are created successfully.

Runtime testing will be documented separately as part of the database implementation validation.
