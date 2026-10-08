# Relationship Validation

> **Portfolio Project:** Citizen Licensing & Permit Management Platform

This document validates the relationships identified during the logical database modelling stage. The relationships are evaluated against the business requirements and business rules to support data integrity, minimize unnecessary duplication, and establish a maintainable relational database design.

---

## 1. Citizens and Citizen Profiles

### Relationship

**One-to-one**

```text
citizens (1) ───────── (1) citizen_profiles
```

### Business Reason

Each citizen may have one profile containing additional contact and address information.

### Database Design

`citizen_profiles.citizen_id` will reference `citizens.citizen_id`.

The profile identifier will also be unique to ensure that a citizen cannot have multiple active profile records.

### Design Rationale

Core identity information is separated from additional profile information.

This keeps the primary citizen entity focused and provides a clear boundary between identity and contact information.

---

## 2. Citizens and Applications

### Relationship

**One-to-many**

```text
citizens (1) ───────── (many) applications
```

### Business Reason

A citizen may submit multiple applications, while each application belongs to one citizen.

### Database Design

`applications.citizen_id` will reference `citizens.citizen_id`.

### Normalization Rationale

Citizen information should not be duplicated within every application.

If one citizen submits five applications, the database should maintain one citizen record and five application records referencing that citizen.

This reduces duplication and supports maintainability.

### Integrity Rule

An application must not reference a citizen that does not exist.

A foreign key will enforce this relationship.

---

## 3. Application Types and Applications

### Relationship

**One-to-many**

```text
application_types (1) ───────── (many) applications
```

### Business Reason

The platform supports multiple licence and permit types.

One application type may be used by many applications, while each application must reference one valid application type.

### Database Design

`applications.application_type_id` will reference `application_types.application_type_id`.

### Normalization Rationale

Application type information should be stored once in `application_types` rather than repeatedly as free-text values in `applications`.

This provides:

* Consistent application type values
* Reduced duplication
* Easier maintenance
* Better reporting
* Referential integrity

### Integrity Rule

Every application must reference an existing application type.

`application_types.type_code` should also be unique.

---

## 4. Applications and Application Status History

### Relationship

**One-to-many**

```text
applications (1) ───────── (many) application_status_history
```

### Business Reason

An application can move through multiple stages during its lifecycle.

For example:

```text
Submitted
    ↓
Under Review
    ↓
Additional Information Required
    ↓
Under Review
    ↓
Approved
```

Each transition should be retained.

### Database Design

`application_status_history.application_id` will reference `applications.application_id`.

### Design Rationale

The current application status alone is insufficient to reconstruct the application's history.

A separate history table preserves every status change as an individual event.

### Integrity Rule

A status history record must belong to an existing application.

### Auditability

Each status history record should identify:

* The status
* The timestamp
* The user or process responsible
* Optional comments or reason

---

## 5. Applications and Documents

### Relationship

**Many-to-many**

```text
applications (many) ───────── (many) documents
                 │
                 │
                 └── application_documents
```

### Business Reason

An application may require multiple supporting documents.

A document relationship may also need to support reuse or association with different application records depending on future business requirements.

### Database Design

The many-to-many relationship will be implemented through:

```text
application_documents
```

This association entity will contain:

* `application_id`
* `document_id`
* `document_purpose`

### Design Rationale

Using an association entity prevents document information from being duplicated within application records.

It also provides a place to store attributes that belong specifically to the relationship between an application and a document.

---

## 6. Applications and Reviews

### Relationship

**One-to-many**

```text
applications (1) ───────── (many) application_reviews
```

### Business Reason

An application may require multiple review activities during its lifecycle.

Different reviewers may participate in reviewing the same application.

### Database Design

`application_reviews.application_id` will reference `applications.application_id`.

`application_reviews.reviewer_user_id` will reference `users.user_id`.

### Design Rationale

Review activity is kept separate from the application itself because review events contain their own:

* Reviewer
* Status
* Timestamp
* Comments

This allows the system to maintain a history of review activity.

---

## 7. Applications and Approval Decisions

### Relationship

**One-to-many**

```text
applications (1) ───────── (many) application_approvals
```

### Business Reason

The platform must support formal approval and rejection decisions.

The design allows multiple approval records if a future workflow introduces multiple approval stages.

### Database Design

`application_approvals.application_id` will reference `applications.application_id`.

`application_approvals.approver_user_id` will reference `users.user_id`.

### Design Rationale

A review is not necessarily the same as a formal approval decision.

Separating reviews from approvals allows the database to distinguish:

**Review activity**

from:

**Formal business decision**

This improves auditability and supports future workflow expansion.

---

## 8. Applications and Payments

### Relationship

**One-to-many**

```text
applications (1) ───────── (many) payments
```

### Business Reason

An application may require a payment and may potentially have multiple payment-related transactions, such as an initial payment, adjustment, refund, or correction.

### Database Design

`payments.application_id` will reference `applications.application_id`.

### Design Rationale

Payment information represents a financial transaction and should not be embedded directly into the application record.

Separating payments allows the database to maintain transaction history independently.

### Integrity Rules

A payment must reference an existing application.

Payment amounts must satisfy the defined business validation rules.

Payment status values should be controlled.

---

## 9. Users and Roles

### Relationship

**Many-to-many**

```text
users (many) ───────── (many) roles
             │
             │
             └── user_roles
```

### Business Reason

A user may have multiple responsibilities.

For example, one employee could potentially be both:

* Application Reviewer
* Reporting User

At the same time, a role may be assigned to many users.

### Database Design

The many-to-many relationship will be implemented through:

```text
user_roles
```

The association will contain:

* `user_id`
* `role_id`
* `assigned_at`
* `assigned_by_user_id`

### Design Rationale

Using a junction table avoids storing multiple roles in a single user record and provides a scalable foundation for role-based access control.

### Integrity Rule

The same role should not be assigned to the same user more than once.

A composite uniqueness rule will be considered for:

```text
user_id + role_id
```

---

## 10. Users and Application Reviews

### Relationship

**One-to-many**

```text
users (1) ───────── (many) application_reviews
```

### Business Reason

One authorized user may review many applications.

Each review should identify the user who performed the review.

### Database Design

`application_reviews.reviewer_user_id` will reference `users.user_id`.

### Design Rationale

Referencing the user rather than storing the reviewer's name directly prevents duplication and preserves a consistent relationship to the system user.

---

## 11. Users and Application Approvals

### Relationship

**One-to-many**

```text
users (1) ───────── (many) application_approvals
```

### Business Reason

An authorized user may make approval decisions for multiple applications.

### Database Design

`application_approvals.approver_user_id` will reference `users.user_id`.

### Design Rationale

The approval record identifies the user responsible for the decision, supporting accountability and auditability.

---

## 12. Users and Status History

### Relationship

**One-to-many**

```text
users (1) ───────── (many) application_status_history
```

### Business Reason

A user or authorized system process may perform multiple application status changes.

### Database Design

`application_status_history.changed_by_user_id` will reference `users.user_id` where the change is attributable to a user.

### Design Rationale

Recording the actor responsible for a status change supports operational traceability and audit requirements.

---

## 13. Users and Audit Logs

### Relationship

**One-to-many**

```text
users (1) ───────── (many) audit_logs
```

### Business Reason

A user may perform many auditable actions.

Each applicable audit event should identify the user responsible.

### Database Design

`audit_logs.user_id` will reference `users.user_id`.

The design should also allow system-generated events where no individual user is responsible.

### Design Rationale

Audit logging supports accountability, troubleshooting, security monitoring, and investigation.

---

# 14. Relationship Summary

| Parent Entity       | Child Entity                 | Relationship | Implementation                  |
| ------------------- | ---------------------------- | ------------ | ------------------------------- |
| `citizens`          | `citizen_profiles`           | 1:1          | Foreign key + unique constraint |
| `citizens`          | `applications`               | 1:M          | Foreign key                     |
| `application_types` | `applications`               | 1:M          | Foreign key                     |
| `applications`      | `application_status_history` | 1:M          | Foreign key                     |
| `applications`      | `application_documents`      | 1:M          | Foreign key                     |
| `documents`         | `application_documents`      | 1:M          | Foreign key                     |
| `applications`      | `application_reviews`        | 1:M          | Foreign key                     |
| `applications`      | `application_approvals`      | 1:M          | Foreign key                     |
| `applications`      | `payments`                   | 1:M          | Foreign key                     |
| `users`             | `user_roles`                 | 1:M          | Foreign key                     |
| `roles`             | `user_roles`                 | 1:M          | Foreign key                     |
| `users`             | `application_reviews`        | 1:M          | Foreign key                     |
| `users`             | `application_approvals`      | 1:M          | Foreign key                     |
| `users`             | `application_status_history` | 1:M          | Foreign key                     |
| `users`             | `audit_logs`                 | 1:M          | Foreign key                     |

---

# 15. Overall Normalization Assessment

The current logical model separates major business concepts into distinct entities and avoids storing repeating groups or unrelated attributes within transactional records.

The design specifically separates:

* Citizens from applications
* Applications from application types
* Current application state from status history
* Applications from supporting documents
* Review activities from approval decisions
* Applications from financial transactions
* Users from roles
* Operational records from audit records

These design choices provide a foundation for a normalized relational model and reduce unnecessary data duplication.

The model will be reviewed again during physical schema design to identify additional normalization opportunities and determine appropriate primary keys, foreign keys, constraints, indexes, and data types.

# 16. Design Review Status

**Logical relationship review:** Complete

**Normalization review:** Initial assessment complete

**Physical database implementation:** Not yet started

**ERD:** To be created after logical relationship validation
