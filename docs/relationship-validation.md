# Relationship Validation

> **Portfolio Project:** Citizen Licensing & Permit Management Platform  
> **Database:** PostgreSQL  
> **Validation Environment:** `licensing_permit_test`

## 1. Purpose

This document describes and validates the relationships in the Citizen Licensing & Permit Management Platform. It explains the business purpose of each relationship, its implementation in the relational schema, and the integrity considerations relevant to database design.

The model separates major business entities to reduce unnecessary duplication, maintain referential integrity, support reporting, and provide a foundation for future workflow and governance requirements.

The project contains 14 tables:

- `citizens`
- `citizen_profiles`
- `application_types`
- `applications`
- `application_status_history`
- `documents`
- `application_documents`
- `application_reviews`
- `application_approvals`
- `payments`
- `users`
- `roles`
- `user_roles`
- `audit_logs`

The physical schema has been created and tested in a separate PostgreSQL test database. The relationship checks described in this document cover selected foreign-key relationships and returned zero orphan records for the tested sample dataset.

## 2. Relationship Validation

### 2.1 Citizens and Citizen Profiles

**Relationship:** One-to-one, with an optional profile for a citizen.

```text
citizens (1) ───────── (0..1) citizen_profiles
```

**Business purpose**

A citizen may have a separate profile containing additional contact or address information. Separating profile information from the core citizen record keeps the data model organized.

**Implementation**

`citizen_profiles.citizen_id` references `citizens.citizen_id`. The profile's citizen reference is unique, preventing multiple profile records from referencing the same citizen.

**Integrity considerations**

- A profile must reference an existing citizen.
- A citizen may exist without a profile.
- The database prevents multiple profiles from referencing the same citizen.

The one-to-one relationship is enforced through the foreign key and uniqueness constraint on the profile's citizen reference.

### 2.2 Citizens and Applications

**Relationship:** One-to-many.

```text
citizens (1) ───────── (many) applications
```

**Business purpose**

A citizen may submit multiple applications, while each application belongs to one citizen.

**Implementation**

`applications.citizen_id` references `citizens.citizen_id`.

**Integrity considerations**

- Each application must reference an existing citizen.
- Citizen information is stored once in the citizen record rather than duplicated across applications.
- The foreign key enforces referential integrity.

This design reduces duplication and supports consistent reporting across applications belonging to the same citizen.

### 2.3 Application Types and Applications

**Relationship:** One-to-many.

```text
application_types (1) ───────── (many) applications
```

**Business purpose**

The platform supports different licence and permit application types. One application type may be referenced by many applications, while each application references one type.

**Implementation**

`applications.application_type_id` references `application_types.application_type_id`. The application type's `type_code` has a uniqueness requirement.

**Integrity considerations**

- Each application must reference an existing application type.
- Unique type codes support consistent identification of application types.
- Storing type information separately reduces repeated descriptive data.

The relationship supports consistent classification and reporting without relying on free-text application type values in every application record.

### 2.4 Applications and Application Status History

**Relationship:** One-to-many.

```text
applications (1) ───────── (many) application_status_history
```

**Business purpose**

An application may pass through multiple lifecycle stages. Retaining status history makes it possible to examine recorded transitions rather than relying only on the current status.

**Implementation**

`application_status_history.application_id` references `applications.application_id`.

Status history records include the status and the associated change information, including a timestamp and an actor reference where applicable.

**Integrity considerations**

- Each status history record must reference an existing application.
- Status history is stored separately from the application's current status.
- The history supports traceability of recorded status changes.

A separate history table does not, by itself, guarantee that every application status update creates a corresponding history record. Complete and consistent history capture requires appropriate application workflow or database-side enforcement.

### 2.5 Applications and Documents

**Relationship:** Many-to-many, implemented through an association table.

```text
applications (1) ── (many) application_documents (many) ── (1) documents
```

**Business purpose**

An application may require multiple supporting documents. The association model also allows a document record to be linked to more than one application if the business process permits it.

**Implementation**

The `application_documents` table links applications and documents through:

- `application_id`
- `document_id`
- `document_purpose`

The application reference points to `applications.application_id`, and the document reference points to `documents.document_id`.

**Integrity considerations**

- Each association must reference an existing application.
- Each association must reference an existing document.
- Relationship-specific information, such as document purpose, belongs in the association table.

The model stores document metadata and a file reference in the database. Storage of the actual binary document content is outside the scope of this schema.

### 2.6 Applications and Reviews

**Relationship:** One-to-many.

```text
applications (1) ───────── (many) application_reviews
```

**Business purpose**

An application may have multiple review activities, potentially involving different reviewers at different stages.

**Implementation**

- `application_reviews.application_id` references `applications.application_id`.
- `application_reviews.reviewer_user_id` references `users.user_id`.

**Integrity considerations**

- Each review must reference an existing application.
- Each review's reviewer reference must identify an existing user.
- Review information is maintained separately from the application record.

Keeping review records separate supports review history and reporting. The foreign keys establish valid references but do not independently verify that a reviewer is authorized to review a particular application.

### 2.7 Applications and Approval Decisions

**Relationship:** One-to-many.

```text
applications (1) ───────── (many) application_approvals
```

**Business purpose**

Formal approval decisions are distinct from review activities. The model supports approval, rejection, and return decisions and can accommodate multiple approval records where the workflow requires them.

**Implementation**

- `application_approvals.application_id` references `applications.application_id`.
- `application_approvals.approver_user_id` references `users.user_id`.
- The decision column has a check constraint permitting `APPROVED`, `REJECTED`, and `RETURNED`.

**Integrity considerations**

- Each approval record must reference an existing application.
- The approver reference must identify an existing user.
- The decision must satisfy the implemented check constraint.

The foreign keys and decision constraint enforce structural integrity. Workflow requirements such as approver authorization, approval sequencing, and whether multiple decisions are permitted for a particular application require additional business-process enforcement.

### 2.8 Applications and Payments

**Relationship:** One-to-many.

```text
applications (1) ───────── (many) payments
```

**Business purpose**

An application may be associated with one or more payment-related transactions. Keeping payment records separate supports transaction-level reporting and preserves payment information independently of the application record.

**Implementation**

`payments.application_id` references `applications.application_id`.

The payment amount has a non-negative check constraint. The payment status field has a nonblank-value check, but the schema does not currently enforce a complete list of permitted payment status values.

**Integrity considerations**

- Each payment must reference an existing application.
- Payment amounts must satisfy the implemented non-negative constraint.
- `paid_at` may be null, including for a payment that has not yet been paid.
- Payment status values should be governed by a defined set of permitted values in a future schema or application enhancement.

A non-negative amount constraint does not validate whether a charge, refund, adjustment, or payment is financially correct. Those rules require additional business validation.

### 2.9 Users and Roles

**Relationship:** Many-to-many, implemented through an association table.

```text
users (1) ───────── (many) user_roles (many) ───────── (1) roles
```

**Business purpose**

A user may have multiple responsibilities, and each role may be assigned to multiple users.

**Implementation**

The `user_roles` table connects users and roles through `user_id` and `role_id`. The association also records assignment-related information.

**Integrity considerations**

- Each user-role association must reference an existing user.
- Each user-role association must reference an existing role.
- A composite uniqueness constraint on `(user_id, role_id)` prevents the same role from being assigned to the same user more than once.

The `users`, `roles`, and `user_roles` tables provide a data model for application-level role assignments. They are not equivalent to PostgreSQL database roles or database privilege grants.

### 2.10 Users and Application Reviews

**Relationship:** One-to-many.

```text
users (1) ───────── (many) application_reviews
```

**Business purpose**

A user may perform multiple reviews, and each review identifies its reviewer.

**Implementation**

`application_reviews.reviewer_user_id` references `users.user_id`.

**Integrity considerations**

The foreign key prevents a review from referencing a user record that does not exist. It does not, on its own, establish that the user has the appropriate role or permissions to perform the review.

### 2.11 Users and Application Approvals

**Relationship:** One-to-many.

```text
users (1) ───────── (many) application_approvals
```

**Business purpose**

A user may make approval decisions for multiple applications. Each approval record identifies the associated approver.

**Implementation**

`application_approvals.approver_user_id` references `users.user_id`.

**Integrity considerations**

The foreign key supports accountability by maintaining a reference to the user associated with each approval. Authorization and approval-workflow rules require additional enforcement.

### 2.12 Users and Status History

**Relationship:** One-to-many, where the status change is attributed to a user.

```text
users (1) ───────── (many) application_status_history
```

**Business purpose**

A user may be responsible for multiple application status changes. Recording the actor supports operational traceability.

**Implementation**

`application_status_history.changed_by_user_id` references `users.user_id` where the change is attributable to a user.

**Integrity considerations**

The user reference must satisfy the schema's foreign-key and nullability rules. System-generated changes and changes without an identified individual must be handled according to the implemented column definition and application workflow.

### 2.13 Users and Audit Logs

**Relationship:** One-to-many.

```text
users (1) ───────── (many) audit_logs
```

**Business purpose**

A user may be associated with multiple auditable events. Audit records support troubleshooting, accountability, and investigation.

**Implementation**

`audit_logs.user_id` references `users.user_id`.

**Integrity considerations**

The foreign key maintains referential integrity for recorded user references. The existence of an audit table does not by itself guarantee comprehensive event capture, tamper resistance, or complete security monitoring.

## 3. Relationship Summary

| Parent entity | Child entity | Relationship | Implementation |
|---|---|---|---|
| `citizens` | `citizen_profiles` | 1:0..1 | Foreign key and unique constraint |
| `citizens` | `applications` | 1:M | Foreign key |
| `application_types` | `applications` | 1:M | Foreign key and unique type code |
| `applications` | `application_status_history` | 1:M | Foreign key |
| `applications` | `application_documents` | 1:M | Foreign key |
| `documents` | `application_documents` | 1:M | Foreign key |
| `applications` | `application_reviews` | 1:M | Foreign key |
| `users` | `application_reviews` | 1:M | Foreign key |
| `applications` | `application_approvals` | 1:M | Foreign key |
| `users` | `application_approvals` | 1:M | Foreign key |
| `applications` | `payments` | 1:M | Foreign key |
| `users` | `user_roles` | 1:M | Foreign key |
| `roles` | `user_roles` | 1:M | Foreign key |
| `users` | `application_status_history` | 1:M | Foreign key |
| `users` | `audit_logs` | 1:M | Foreign key |

The many-to-many relationships between applications and documents, and between users and roles, are implemented using their respective association tables.

## 4. Normalization Assessment

The model separates major business concepts into distinct tables and avoids storing repeating groups or unrelated transactional attributes together.

Examples include:

- Citizens are separated from applications.
- Applications reference application types rather than duplicating type details.
- Application status history is separated from the current application record.
- Application-document associations are maintained through a junction table.
- Reviews are separated from formal approval decisions.
- Payments are maintained independently of applications.
- User-role assignments are maintained through a junction table.
- Audit records are separated from operational records.

These design decisions support a normalized relational structure and reduce unnecessary duplication. The final quality of normalization also depends on the functional dependencies and business rules applicable to the data.

Normalization does not replace the need for primary keys, foreign keys, uniqueness constraints, check constraints, appropriate data types, and indexes.

## 5. Relationship Validation Results

The schema and sample data were tested in the separate PostgreSQL database `licensing_permit_test`.

The following integrity checks were run against the tested sample dataset:

| Validation check | Expected result | Observed result |
|---|---|---|
| Citizen profiles without matching citizens | 0 orphan records | 0 |
| Applications without matching citizens | 0 orphan records | 0 |
| Applications without matching application types | 0 orphan records | 0 |
| Payments without matching applications | 0 orphan records | 0 |
| Application-document associations without matching applications | 0 orphan records | 0 |
| Application-document associations without matching documents | 0 orphan records | 0 |

**Validation outcome:** All six tested relationship checks returned zero orphan records.

These results confirm referential consistency for the tested relationships and sample dataset. They do not independently prove that every business rule, workflow, authorization requirement, or possible production data condition has been validated.

## 6. Limitations and Future Enhancements

The following items may require additional implementation as the platform evolves:

- **Status history:** Ensure each relevant status change is consistently recorded through application logic or database-side enforcement.
- **Payment statuses:** Define and enforce the complete set of permitted payment status values.
- **Review and approval authorization:** Validate that users have the appropriate permissions before performing restricted actions.
- **Audit coverage:** Define which events must be captured and how audit records will be protected and retained.
- **Workflow rules:** Define approval sequencing, repeated decisions, and status-transition requirements.
- **Document storage:** Define secure storage, access, retention, and retrieval
