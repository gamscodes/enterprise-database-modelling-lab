# Data Model Notes

> **Portfolio Project:** This document defines the logical data model for the fictional Citizen Licensing & Permit Management Platform.

## 1. Entity Identification

The entities below were identified by analyzing the business requirements and business rules documented for the simulated platform.

The entities represent the major business objects that must be stored and managed by the system.

### 1.1 Citizen Management

* `citizens`
* `citizen_profiles`

### 1.2 Application Management

* `application_types`
* `applications`
* `application_status_history`

### 1.3 Document Management

* `documents`
* `application_documents`

### 1.4 Review and Approval

* `application_reviews`
* `application_approvals`

### 1.5 Financial Management

* `payments`

### 1.6 Security and Access Management

* `users`
* `roles`
* `user_roles`

### 1.7 Audit

* `audit_logs`

## 2. Initial Entity Count

The initial logical model contains **14 entities**.

These entities will be reviewed during the relationship, normalization, and physical database design stages before the final PostgreSQL schema is implemented.

## 3. Entity Definitions

### 3.1 `citizens`

**Purpose**

Stores the core identity information for each citizen using the simulated platform.

**Why it is needed**

A citizen may submit multiple applications. Storing citizens as a separate entity prevents citizen information from being repeatedly stored within each application.

**Business Requirements Supported**

* FR-01 — Citizen Management
* FR-04 — Application Submission
* FR-14 — Application Search and Filtering

**Business Rules Supported**

* BR-01 — Unique Citizen
* BR-02 — Required Citizen Information
* BR-03 — Citizen Applications

**Initial Attributes**

| Attribute       | Purpose                           |
| --------------- | --------------------------------- |
| `citizen_id`    | Unique identifier for the citizen |
| `first_name`    | Citizen's first name              |
| `last_name`     | Citizen's last name               |
| `date_of_birth` | Citizen's date of birth           |
| `created_at`    | Record creation timestamp         |
| `updated_at`    | Record modification timestamp     |

**Key Design Decision**

`citizen_id` will be the primary key.

**Relationship**

One citizen may submit many applications.

`citizens` **1 → many** `applications`

---

### 3.2 `citizen_profiles`

**Purpose**

Stores additional profile and contact information associated with a citizen.

**Why it is needed**

Core identity information is separated from additional profile and contact information to maintain a clear logical structure and support future expansion.

**Business Requirements Supported**

* FR-01 — Citizen Management
* FR-02 — Citizen Profile Management

**Initial Attributes**

| Attribute        | Purpose                        |
| ---------------- | ------------------------------ |
| `citizen_id`     | Associated citizen             |
| `email_address`  | Email address                  |
| `phone_number`   | Primary phone number           |
| `address_line_1` | Primary address                |
| `address_line_2` | Additional address information |
| `city`           | City                           |
| `province_code`  | Province or territory          |
| `postal_code`    | Postal code                    |
| `created_at`     | Profile creation timestamp     |
| `updated_at`     | Profile modification timestamp |

**Key Design Decision**

`citizen_id` will be both the primary key and a foreign key to `citizens`.

This creates a one-to-one relationship.

`citizens` **1 → 1** `citizen_profiles`

---

### 3.3 `application_types`

**Purpose**

Stores the controlled list of licence and permit types available through the simulated platform.

**Why it is needed**

Application types should not be stored as unrestricted text in the `applications` table. A reference entity provides consistent values and allows application types to be maintained independently.

**Business Requirements Supported**

* FR-03 — Licence and Permit Types
* FR-04 — Application Submission

**Initial Attributes**

| Attribute             | Purpose                                           |
| --------------------- | ------------------------------------------------- |
| `application_type_id` | Unique application type identifier                |
| `type_code`           | Short business code                               |
| `type_name`           | Licence or permit name                            |
| `description`         | Description of the type                           |
| `application_fee`     | Applicable fee                                    |
| `is_active`           | Indicates whether the type is currently available |
| `created_at`          | Creation timestamp                                |
| `updated_at`          | Modification timestamp                            |

**Key Design Decision**

`application_type_id` will be the primary key.

`type_code` should be unique.

**Relationship**

One application type may be associated with many applications.

`application_types` **1 → many** `applications`

---

### 3.4 `applications`

**Purpose**

Stores licence and permit applications submitted by citizens.

**Why it is needed**

Applications are the primary transactional entity within the simulated platform.

**Business Requirements Supported**

* FR-04 — Application Submission
* FR-05 — Application Status Management
* FR-14 — Application Search and Filtering
* FR-15 — Operational Reporting

**Business Rules Supported**

* BR-05 — Application Ownership
* BR-06 — Application Type
* BR-07 — Application Status
* BR-09 — Application History

**Initial Attributes**

| Attribute             | Purpose                            |
| --------------------- | ---------------------------------- |
| `application_id`      | Unique application identifier      |
| `citizen_id`          | Citizen submitting the application |
| `application_type_id` | Licence or permit type             |
| `application_number`  | Human-readable business identifier |
| `current_status`      | Current application status         |
| `submitted_at`        | Application submission timestamp   |
| `created_at`          | Record creation timestamp          |
| `updated_at`          | Record modification timestamp      |

**Key Design Decision**

`application_id` will be the primary key.

`citizen_id` will reference `citizens`.

`application_type_id` will reference `application_types`.

**Relationship**

One citizen may have many applications.

One application type may be used by many applications.

---

### 3.5 `application_status_history`

**Purpose**

Stores the historical status changes for applications.

**Why it is needed**

The current status alone does not provide a history of how an application progressed. A separate history entity preserves the application lifecycle.

**Business Requirements Supported**

* FR-05 — Application Status Management
* FR-06 — Application Status History
* FR-15 — Operational Reporting

**Business Rules Supported**

* BR-09 — Application History
* BR-10 — Historical Status Preservation

**Initial Attributes**

| Attribute            | Purpose                            |
| -------------------- | ---------------------------------- |
| `status_history_id`  | Unique history record              |
| `application_id`     | Associated application             |
| `status_code`        | Status assigned to the application |
| `changed_by_user_id` | User or process responsible        |
| `changed_at`         | Status change timestamp            |
| `reason`             | Optional reason                    |
| `comments`           | Optional comments                  |

**Key Design Decision**

Each status change will create a new record rather than overwriting historical information.

**Relationship**

One application may have many status history records.

`applications` **1 → many** `application_status_history`

---

### 3.6 `documents`

**Purpose**

Stores metadata describing supporting documents submitted through the platform.

**Why it is needed**

Document metadata should be managed separately from application records so that document information is not duplicated.

**Business Requirements Supported**

* FR-07 — Supporting Document Management

**Initial Attributes**

| Attribute         | Purpose                      |
| ----------------- | ---------------------------- |
| `document_id`     | Unique document identifier   |
| `document_type`   | Type of document             |
| `file_name`       | Original file name           |
| `file_reference`  | Reference to stored document |
| `uploaded_at`     | Upload timestamp             |
| `document_status` | Current document status      |
| `created_at`      | Creation timestamp           |

**Key Design Decision**

The database will store document metadata and a reference to the document location rather than storing the actual file content directly in the initial relational design.

---

### 3.7 `application_documents`

**Purpose**

Associates supporting documents with applications.

**Why it is needed**

An application may contain multiple documents, and a document may potentially be associated with more than one business record or application context. A separate association entity provides flexibility and avoids repeating document attributes.

**Business Requirements Supported**

* FR-07 — Supporting Document Management

**Initial Attributes**

| Attribute                 | Purpose                           |
| ------------------------- | --------------------------------- |
| `application_document_id` | Unique relationship identifier    |
| `application_id`          | Associated application            |
| `document_id`             | Associated document               |
| `document_purpose`        | Reason the document was submitted |
| `created_at`              | Association timestamp             |

**Key Design Decision**

This entity represents the relationship between applications and documents.

It will use foreign keys to both `applications` and `documents`.

---

### 3.8 `application_reviews`

**Purpose**

Stores review activities performed on applications by authorized users.

**Why it is needed**

Application review is a distinct business activity from the final approval decision. Separating the two allows the database to preserve the review process independently.

**Business Requirements Supported**

* FR-08 — Application Review

**Business Rules Supported**

* BR-14 — Authorized Review

**Initial Attributes**

| Attribute          | Purpose                    |
| ------------------ | -------------------------- |
| `review_id`        | Unique review identifier   |
| `application_id`   | Application being reviewed |
| `reviewer_user_id` | User performing the review |
| `review_status`    | Review outcome/status      |
| `reviewed_at`      | Review timestamp           |
| `comments`         | Review comments            |

**Relationship**

One application may have multiple review records.

One user may perform reviews for many applications.

---

### 3.9 `application_approvals`

**Purpose**

Stores formal approval or rejection decisions.

**Why it is needed**

A review does not necessarily represent the final business decision. Approval decisions therefore require a separate entity.

**Business Requirements Supported**

* FR-09 — Approval Decisions

**Business Rules Supported**

* BR-15 — Approval Decision
* BR-16 — Decision Maker
* BR-17 — Decision Date
* BR-18 — Decision Integrity

**Initial Attributes**

| Attribute          | Purpose                    |
| ------------------ | -------------------------- |
| `approval_id`      | Unique approval identifier |
| `application_id`   | Application being decided  |
| `approver_user_id` | User making the decision   |
| `decision`         | Approval or rejection      |
| `decision_at`      | Decision timestamp         |
| `comments`         | Decision comments          |

**Relationship**

An application may have one or more approval records depending on the defined approval workflow.

---

### 3.10 `payments`

**Purpose**

Stores payment transactions associated with applications.

**Why it is needed**

Payment information represents a separate financial transaction and should not be embedded directly within the application record.

**Business Requirements Supported**

* FR-10 — Payment Management
* FR-15 — Operational Reporting

**Business Rules Supported**

* BR-19 — Application Payment
* BR-20 — Non-Negative Payment
* BR-21 — Payment Status
* BR-22 — Payment Reference

**Initial Attributes**

| Attribute           | Purpose                       |
| ------------------- | ----------------------------- |
| `payment_id`        | Unique payment identifier     |
| `application_id`    | Associated application        |
| `payment_reference` | Payment transaction reference |
| `amount`            | Payment amount                |
| `payment_status`    | Payment status                |
| `paid_at`           | Payment timestamp             |
| `created_at`        | Record creation timestamp     |

**Key Design Decision**

Payment amounts will be represented using a suitable exact numeric data type rather than floating-point storage.

**Relationship**

One application may have multiple payment records.

`applications` **1 → many** `payments`

---

### 3.11 `users`

**Purpose**

Stores users who interact with the simulated platform.

**Why it is needed**

Users are referenced by application reviews, approvals, status changes, and audit records. A centralized user entity avoids repeating user information throughout the database.

**Business Requirements Supported**

* FR-11 — User Management
* FR-12 — Role Management

**Initial Attributes**

| Attribute       | Purpose                         |
| --------------- | ------------------------------- |
| `user_id`       | Unique user identifier          |
| `username`      | User login or system identifier |
| `first_name`    | User first name                 |
| `last_name`     | User last name                  |
| `email_address` | User email                      |
| `is_active`     | Account status                  |
| `created_at`    | Account creation timestamp      |
| `updated_at`    | Account modification timestamp  |

**Key Design Decision**

`user_id` will be the primary key.

`username` and `email_address` will be evaluated for uniqueness requirements during physical design.

---

### 3.12 `roles`

**Purpose**

Stores roles used to control access to functionality.

**Why it is needed**

Roles provide a structured way to group permissions and support the principle of least privilege.

**Business Requirements Supported**

* FR-12 — Role Management

**Business Rules Supported**

* BR-24 — User Roles
* BR-26 — Access Control
* BR-27 — Least Privilege

**Initial Attributes**

| Attribute   | Purpose                |
| ----------- | ---------------------- |
| `role_id`   | Unique role identifier |
| `role_code` | Short role identifier  |
|             |                        |

| `date_of_birth` | Citizen's date of birth                    |
| `created_at`    | Date and time the record was created       |
| `updated_at`    | Date and time the record was last modified |

**Key Design Decision**

`citizen_id` will be the primary key of the `citizens` table.

The identifier will uniquely distinguish each citizen and will be referenced by other entities that need to associate records with a citizen.

**Relationship**

One citizen may submit many applications.

Therefore:

`citizens` **1 → many** `applications`

The foreign key implementation will be defined during the physical database design stage.
