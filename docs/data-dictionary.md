# Data Dictionary

## Enterprise Data Modelling & Schema Governance Lab

## 1. Purpose

This document describes the tables, columns, data types, constraints, defaults, and relationships in the fictional Ontario Citizen Licensing & Permit Management Platform.

It provides technical reference information for database development, maintenance, data integrity, and governance.

The PostgreSQL schema in `sql/01_create_schema.sql` is the authoritative source for implemented database definitions.

## 2. Conventions

- **PK:** Primary key.
- **FK:** Foreign key referencing another table.
- **UNIQUE:** Prevents duplicate values or combinations.
- **NOT NULL:** Requires a value.
- **NULL:** A value may be absent.
- **IDENTITY:** The database generates the identifier automatically.
- **DEFAULT:** The database supplies a value when an insert omits that column.
- **CHECK:** Enforces a specified condition on a column or record.

Unless otherwise stated, timestamps use PostgreSQL `TIMESTAMP` without time zone. Timestamp defaults initialize values when records are inserted; they do not automatically update an existing record when its contents change.

## 3. Table Definitions

### 3.1 `citizens`

**Purpose:** Stores the core identifying information for individuals who submit applications.

| Column | Data type | Rules | Description |
|---|---|---|---|
| `citizen_id` | BIGINT | PK, identity | Unique citizen identifier. |
| `first_name` | VARCHAR(100) | NOT NULL | Citizen's first name. |
| `last_name` | VARCHAR(100) | NOT NULL | Citizen's last name. |
| `date_of_birth` | DATE | NOT NULL | Citizen's date of birth. |
| `created_at` | TIMESTAMP | NOT NULL, default CURRENT_TIMESTAMP | Record creation timestamp. |
| `updated_at` | TIMESTAMP | NOT NULL, default CURRENT_TIMESTAMP | Timestamp initialized at creation; updated explicitly when the record changes. |

### 3.2 `citizen_profiles`

**Purpose:** Stores contact and address details separately from core citizen identification information.

| Column | Data type | Rules | Description |
|---|---|---|---|
| `citizen_id` | BIGINT | PK, FK | Links the profile to `citizens.citizen_id`; supports a one-to-one relationship. |
| `email_address` | VARCHAR(255) | Nullable | Citizen's email address. |
| `phone_number` | VARCHAR(30) | Nullable | Citizen's contact number. |
| `address_line_1` | VARCHAR(200) | Nullable | Primary street address. |
| `address_line_2` | VARCHAR(200) | Nullable | Additional address information. |
| `city` | VARCHAR(100) | Nullable | City or municipality. |
| `province_code` | VARCHAR(2) | Nullable | Province or territory code. |
| `postal_code` | VARCHAR(10) | Nullable | Postal code. |
| `created_at` | TIMESTAMP | NOT NULL, default CURRENT_TIMESTAMP | Profile creation timestamp. |
| `updated_at` | TIMESTAMP | NOT NULL, default CURRENT_TIMESTAMP | Timestamp initialized at creation; updated explicitly when the profile changes. |

### 3.3 `application_types`

**Purpose:** Defines the licence and permit application categories available in the platform.

| Column | Data type | Rules | Description |
|---|---|---|---|
| `application_type_id` | BIGINT | PK, identity | Unique application type identifier. |
| `type_code` | VARCHAR(30) | NOT NULL, UNIQUE | Stable code identifying the application type. |
| `type_name` | VARCHAR(150) | NOT NULL | Display name of the application type. |
| `description` | TEXT | Nullable | Explanation of the application type. |
| `application_fee` | NUMERIC(12,2) | NOT NULL, default 0.00 | Fee associated with the application type. |
| `is_active` | BOOLEAN | NOT NULL, default TRUE | Indicates whether the type is active. |
| `created_at` | TIMESTAMP | NOT NULL, default CURRENT_TIMESTAMP | Record creation timestamp. |
| `updated_at` | TIMESTAMP | NOT NULL, default CURRENT_TIMESTAMP | Timestamp initialized at creation; updated explicitly when the record changes. |

### 3.4 `users`

**Purpose:** Stores accounts for staff and other authorized platform users.

| Column | Data type | Rules | Description |
|---|---|---|---|
| `user_id` | BIGINT | PK, identity | Unique user identifier. |
| `username` | VARCHAR(100) | NOT NULL, UNIQUE | Login or account name. |
| `first_name` | VARCHAR(100) | NOT NULL | User's first name. |
| `last_name` | VARCHAR(100) | NOT NULL | User's last name. |
| `email_address` | VARCHAR(255) | NOT NULL, UNIQUE | User's email address. |
| `is_active` | BOOLEAN | NOT NULL, default TRUE | Indicates whether the account is active. |
| `created_at` | TIMESTAMP | NOT NULL, default CURRENT_TIMESTAMP | Account creation timestamp. |
| `updated_at` | TIMESTAMP | NOT NULL, default CURRENT_TIMESTAMP | Timestamp initialized at creation; updated explicitly when the account changes. |

### 3.5 `roles`

**Purpose:** Defines the roles that can be assigned to platform users.

| Column | Data type | Rules | Description |
|---|---|---|---|
| `role_id` | BIGINT | PK, identity | Unique role identifier. |
| `role_code` | VARCHAR(50) | NOT NULL, UNIQUE | Unique code identifying the role. |
| `role_name` | VARCHAR(100) | NOT NULL | Human-readable role name. |
| `description` | TEXT | Nullable | Purpose and responsibilities of the role. |
| `is_active` | BOOLEAN | NOT NULL, default TRUE | Indicates whether the role is active. |

### 3.6 `applications`

**Purpose:** Stores citizen applications and their current status.

| Column | Data type | Rules | Description |
|---|---|---|---|
| `application_id` | BIGINT | PK, identity | Unique application identifier. |
| `citizen_id` | BIGINT | NOT NULL, FK | References the citizen who submitted the application. |
| `application_type_id` | BIGINT | NOT NULL, FK | References the application type. |
| `application_number` | VARCHAR(50) | NOT NULL, UNIQUE | Business-facing application reference. |
| `current_status` | VARCHAR(50) | NOT NULL | Current application status. |
| `submitted_at` | TIMESTAMP | Nullable | Submission date and time; may be NULL for a draft application. |
| `created_at` | TIMESTAMP | NOT NULL, default CURRENT_TIMESTAMP | Record creation timestamp. |
| `updated_at` | TIMESTAMP | NOT NULL, default CURRENT_TIMESTAMP | Timestamp initialized at creation; updated explicitly when the record changes. |

### 3.7 `application_status_history`

**Purpose:** Maintains historical application status records for traceability.

| Column | Data type | Rules | Description |
|---|---|---|---|
| `status_history_id` | BIGINT | PK, identity | Unique status history identifier. |
| `application_id` | BIGINT | NOT NULL, FK | References the application whose status is recorded. |
| `status_code` | VARCHAR(50) | NOT NULL | Status recorded in the history entry. |
| `changed_by_user_id` | BIGINT | Nullable, FK | References the user associated with the status change, when recorded. |
| `changed_at` | TIMESTAMP | NOT NULL, default CURRENT_TIMESTAMP | Timestamp of the recorded status change. |
| `reason` | TEXT | Nullable | Reason for the status change. |
| `comments` | TEXT | Nullable | Additional explanatory notes. |

### 3.8 `documents`

**Purpose:** Stores metadata and references for documents associated with applications.

| Column | Data type | Rules | Description |
|---|---|---|---|
| `document_id` | BIGINT | PK, identity | Unique document identifier. |
| `document_type` | VARCHAR(100) | NOT NULL | Classification of the document. |
| `file_name` | VARCHAR(255) | NOT NULL | Original or displayed file name. |
| `file_reference` | VARCHAR(500) | NOT NULL | Reference or location identifier for the stored file. |
| `uploaded_at` | TIMESTAMP | NOT NULL, default CURRENT_TIMESTAMP | Upload timestamp. |
| `document_status` | VARCHAR(50) | NOT NULL | Current document status. |
| `created_at` | TIMESTAMP | NOT NULL, default CURRENT_TIMESTAMP | Metadata record creation timestamp. |

**Design note:** The database
