# Data Dictionary
## Enterprise Data Modelling & Schema Governance Lab

### 1. Purpose

This document defines the tables and columns used by the fictional Ontario Citizen Licensing & Permit Management Platform. It describes their business purpose, data types, nullability, defaults, and relationships to support database development, maintenance, and governance.

The PostgreSQL schema (`sql/01_create_schema.sql`) is the authoritative source for database definitions.

### 2. Conventions

- **PK:** Primary key.
- **FK:** Foreign key referencing another table.
- **Unique:** Duplicate values are prohibited by a unique constraint or index.
- **Not null:** A value is required.
- **Nullable:** A value may be absent (`NULL`).
- **Identity:** The database generates the identifier automatically.
- **Default:** The database supplies a value when an insert does not specify one.

Unless otherwise stated, timestamp defaults and nullability should be confirmed against the SQL schema.

---

### 3. Table Definitions

#### 3.1 `citizens`

**Purpose:** Stores the core identifying information for individuals who submit applications.

| Column | Data type | Rules | Description |
|---|---|---|---|
| `citizen_id` | BIGINT | PK, identity | Unique identifier for each citizen. |
| `first_name` | VARCHAR(100) | NOT NULL | Citizen's first name. |
| `last_name` | VARCHAR(100) | NOT NULL | Citizen's last name. |
| `date_of_birth` | DATE | NOT NULL | Citizen's date of birth. |
| `created_at` | TIMESTAMP | NOT NULL, default current timestamp | Date and time the record was created. |
| `updated_at` | TIMESTAMP | NOT NULL, default current timestamp | Date and time the record was last updated. |

#### 3.2 `citizen_profiles`

**Purpose:** Stores contact and address details separately from core citizen identity data.

| Column | Data type | Rules | Description |
|---|---|---|---|
| `citizen_id` | BIGINT | PK, FK | Links the profile to `citizens.citizen_id`; supports a one-to-one profile relationship. |
| `email_address` | VARCHAR(255) | Nullable | Citizen's email address. |
| `phone_number` | VARCHAR(30) | Nullable | Citizen's contact number. |
| `address_line_1` | VARCHAR(200) | Nullable | Primary street address. |
| `address_line_2` | VARCHAR(200) | Nullable | Additional address information. |
| `city` | VARCHAR(100) | Nullable | City or municipality. |
| `province_code` | VARCHAR(2) | Nullable | Province or territory code. |
| `postal_code` | VARCHAR(10) | Nullable | Postal code. |
| `created_at` | TIMESTAMP | NOT NULL, default current timestamp | Profile creation timestamp. |
| `updated_at` | TIMESTAMP | NOT NULL, default current timestamp | Last profile update timestamp. |

#### 3.3 `application_types`

**Purpose:** Defines the categories of applications available in the platform.

| Column | Data type | Rules | Description |
|---|---|---|---|
| `application_type_id` | BIGINT | PK, identity | Unique application type identifier. |
| `type_code` | VARCHAR(30) | NOT NULL, unique | Stable code identifying the application type. |
| `type_name` | VARCHAR(150) | NOT NULL | Display name of the application type. |
| `description` | TEXT | Nullable | Explanation of the application type. |
| `application_fee` | NUMERIC(12,2) | NOT NULL, default 0.00 | Fee associated with the application type. |
| `is_active` | BOOLEAN | NOT NULL, default TRUE | Indicates whether the type is available for use. |
| `created_at` | TIMESTAMP | NOT NULL, default current timestamp | Record creation timestamp. |
| `updated_at` | TIMESTAMP | NOT NULL, default current timestamp | Last record update timestamp. |

#### 3.4 `users`

**Purpose:** Stores accounts for staff and other authorized platform users.

| Column | Data type | Rules | Description |
|---|---|---|---|
| `user_id` | BIGINT | PK, identity | Unique user identifier. |
| `username` | VARCHAR(100) | NOT NULL, unique | Login or account name. |
| `first_name` | VARCHAR(100) | NOT NULL | User's first name. |
| `last_name` | VARCHAR(100) | NOT NULL | User's last name. |
| `email_address` | VARCHAR(255) | NOT NULL, unique | User's email address. |
| `is_active` | BOOLEAN | NOT NULL, default TRUE | Indicates whether the account is active. |
| `created_at` | TIMESTAMP | NOT NULL, default current timestamp | Account creation timestamp. |
| `updated_at` | TIMESTAMP | NOT NULL, default current timestamp | Last account update timestamp. |

#### 3.5 `roles`

**Purpose:** Defines the roles that can be assigned to users.

| Column | Data type | Rules | Description |
|---|---|---|---|
| `role_id` | BIGINT | PK, identity | Unique role identifier. |
| `role_code` | VARCHAR(50) | NOT NULL, unique | Unique code for the role. |
| `role_name` | VARCHAR(100) | NOT NULL | Human-readable role name. |
| `description` | TEXT | Nullable | Purpose and responsibilities of the role. |
| `is_active` | BOOLEAN | NOT NULL, default TRUE | Indicates whether the role is active. |

#### 3.6 `applications`

**Purpose:** Stores applications submitted by citizens and tracks their current status.

| Column | Data type | Rules | Description |
|---|---|---|---|
| `application_id` | BIGINT | PK, identity | Unique application identifier. |
| `citizen_id` | BIGINT | NOT NULL, FK | Citizen who submitted the application. |
| `application_type_id` | BIGINT | NOT NULL, FK | Type of application submitted. |
| `application_number` | VARCHAR(50) | NOT NULL, unique | Business-facing application reference. |
| `current_status` | VARCHAR(50) | NOT NULL | Current application status. |
| `submitted_at` | TIMESTAMP | Nullable | Date and time the application was submitted. |
| `created_at` | TIMESTAMP | NOT NULL, default current timestamp | Record creation timestamp. |
| `updated_at` | TIMESTAMP | NOT NULL, default current timestamp | Last record update timestamp. |

#### 3.7 `application_status_history`

**Purpose:** Maintains a history of application status changes for traceability.

| Column | Data type | Rules | Description |
|---|---|---|---|
| `status_history_id` | BIGINT | PK, identity | Unique status history record identifier. |
| `application_id` | BIGINT | NOT NULL, FK | Application whose status changed. |
| `status_code` | VARCHAR(50) | NOT NULL | Status recorded in this history entry. |
| `changed_by_user_id` | BIGINT | Nullable, FK | User associated with the status change, when recorded. |
| `changed_at` | TIMESTAMP | NOT NULL, default current timestamp | Date and time of the status change record. |
| `reason` | TEXT | Nullable | Reason for the change. |
| `comments` | TEXT | Nullable | Additional explanatory notes. |

#### 3.8 `documents`

**Purpose:** Stores metadata and references for documents associated with applications.

| Column | Data type | Rules | Description |
|---|---|---|---|
| `document_id` | BIGINT | PK, identity | Unique document identifier. |
| `document_type` | VARCHAR(100) | NOT NULL | Classification of the document. |
| `file_name` | VARCHAR(255) | NOT NULL | Original or displayed file name. |
| `file_reference` | VARCHAR(500) | NOT NULL | Reference or location identifier for the stored file. |
| `uploaded_at` | TIMESTAMP | NOT NULL, default current timestamp | Upload timestamp. |
| `document_status` | VARCHAR(50) | NOT NULL | Current document status. |
| `created_at` | TIMESTAMP | NOT NULL, default current timestamp | Metadata record creation timestamp. |

#### 3.9 `application_documents`

**Purpose:** Links applications to their supporting documents.

| Column | Data type | Rules | Description |
|---|---|---|---|
| `application_document_id` | BIGINT | PK, identity | Unique application-document link identifier. |
| `application_id` | BIGINT | NOT NULL, FK | Related application. |
| `document_id` | BIGINT | NOT NULL, FK | Related document. |
| `document_purpose` | VARCHAR(150) | Nullable | Purpose of the document for the application. |
| `created_at` | TIMESTAMP | NOT NULL, default current timestamp | Date and time the link was created. |

**Integrity rule:** The combination of `application_id` and `document_id` must be unique.

#### 3.10 `application_reviews`

**Purpose:** Records reviews of applications by authorized users.

| Column | Data type | Rules | Description |
|---|---|---|---|
| `review_id` | BIGINT | PK, identity | Unique review identifier. |
| `application_id` | BIGINT | NOT NULL, FK | Application being reviewed. |
| `reviewer_user_id` | BIGINT | NOT NULL, FK | User who performed the review. |
| `review_status` | VARCHAR(50) | NOT NULL | Outcome or status of the review. |
| `reviewed_at` | TIMESTAMP | NOT NULL, default current timestamp | Date and time of the review record. |
| `comments` | TEXT | Nullable | Review notes. |

#### 3.11 `application_approvals`

**Purpose:** Records formal approval decisions for applications.

| Column | Data type | Rules | Description |
|---|---|---|---|
| `approval_id` | BIGINT | PK, identity | Unique approval record identifier. |
| `application_id` | BIGINT | NOT NULL, FK | Application being considered for approval. |
| `approver_user_id` | BIGINT | NOT NULL, FK | User responsible for the decision. |
| `decision` | VARCHAR(30) | NOT NULL | Approval decision. |
| `decision_at` | TIMESTAMP | NOT NULL, default current timestamp | Date and time the decision was recorded. |
| `comments` | TEXT | Nullable | Explanation or notes about the decision. |

#### 3.12 `payments`

**Purpose:** Tracks payment records associated with applications.

| Column | Data type | Rules | Description |
|---|---|---|---|
| `payment_id` | BIGINT | PK, identity | Unique payment identifier. |
| `application_id` | BIGINT | NOT NULL, FK | Application associated with the payment. |
| `payment_reference` | VARCHAR(100) | NOT NULL, unique | Unique payment reference. |
| `amount` | NUMERIC(12,2) | NOT NULL | Monetary amount of the payment. |
| `payment_status` | VARCHAR(50) | NOT NULL | Payment status, such as PAID or PENDING. |
| `paid_at` | TIMESTAMP | Nullable | Date and time payment was completed; NULL when not yet recorded. |
| `created_at` | TIMESTAMP | NOT NULL, default current timestamp | Payment record creation timestamp. |

#### 3.13 `user_roles`

**Purpose:** Implements the many-to-many relationship between users and roles.

| Column | Data type | Rules | Description |
|---|---|---|---|
| `user_role_id` | BIGINT | PK, identity | Unique user-role assignment identifier. |
| `user_id` | BIGINT | NOT NULL, FK | User receiving the role. |
| `role_id` | BIGINT | NOT NULL, FK | Role assigned to the user. |
| `assigned_at` | TIMESTAMP | NOT NULL, default current timestamp | Date and time the assignment was recorded. |
| `assigned_by_user_id` | BIGINT | Nullable, FK | User who made the assignment, when recorded. |

**Integrity rule:** A user-role combination must be unique to prevent duplicate assignments.

#### 3.14 `audit_logs`

**Purpose:** Records system activity for accountability, troubleshooting, and audit review.

| Column | Data type | Rules | Description |
|---|---|---|---|
| `audit_log_id` | BIGINT | PK, identity | Unique audit event identifier. |
| `user_id` | BIGINT | Nullable, FK | User associated with the event, when known. |
| `action_type` | VARCHAR(100) | NOT NULL | Type of action recorded. |
| `entity_name` | VARCHAR(100) | NOT NULL | Name of the affected entity or table. |
| `record_id` | BIGINT | Nullable | Identifier of the affected record, when applicable. |
| `event_timestamp` | TIMESTAMP | NOT NULL, default current timestamp | Date and time the event was recorded. |
| `details` | TEXT | Nullable | Additional event information. |

---

### 4. Relationship Summary

| Parent table | Related table | Relationship |
|---|---|---|
| `citizens` | `citizen_profiles` | One-to-one |
| `citizens` | `applications` | One-to-many |
| `application_types` | `applications` | One-to-many |
| `applications` | `application_status_history` | One-to-many |
| `users` | `application_status_history` | One-to-many, optional user reference |
| `applications` | `application_documents` | One-to-many |
| `documents` | `application_documents` | One-to-many |
| `applications` | `application_reviews` | One-to-many |
| `users` | `application_reviews` | One-to-many |
| `applications` | `application_approvals` | One-to-many |
| `users` | `application_approvals` | One-to-many |
| `applications` | `payments` | One-to-many |
| `users` | `user_roles` | One-to-many |
| `roles` | `user_roles` | One-to-many |
| `users` | `audit_logs` | One-to-many, optional user reference |

### 5. Data Integrity and Governance

The database schema enforces data integrity through primary keys, foreign keys, unique constraints, not-null requirements, default values, check constraints, and indexes.

Key governance considerations include:

- Use stable identifiers and unique business references.
- Maintain application status history to support traceability.
- Restrict access according to user responsibilities and assigned roles.
- Protect citizen contact information and avoid exposing unnecessary personal data.
- Preserve audit records and establish appropriate retention and access policies.
- Validate data changes through controlled schema changes and testing.
- Review query performance and indexes as data volumes and usage patterns grow.

### 6. Maintenance

Update this dictionary whenever a table, column, constraint, default, or relationship changes. Review it alongside `sql/01_create_schema.sql` and the ERD to keep the documentation consistent with the implemented database.

**Document status:** Initial portfolio version. Verify definitions against the deployed PostgreSQL schema before treating this document as authoritative.

