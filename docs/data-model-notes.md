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

## 3. Entity Definition

### 3.1 `citizens`

**Purpose**

The `citizens` entity stores the core identity information for each citizen using the simulated platform.

**Why it is needed**

The business requirements state that the platform must maintain citizen records and allow citizens to submit licence and permit applications.

Because a citizen can submit multiple applications, the citizen must exist as a separate entity rather than being repeated inside every application record.

**Business Requirements Supported**

* FR-01 — Citizen Management
* FR-04 — Application Submission
* FR-14 — Application Search and Filtering

**Business Rules Supported**

* BR-01 — Unique Citizen
* BR-02 — Required Citizen Information
* BR-03 — Citizen Applications

**Initial Attributes**

The entity is expected to contain:

| Attribute       | Purpose                                    |
| --------------- | ------------------------------------------ |
| `citizen_id`    | Unique identifier for the citizen          |
| `first_name`    | Citizen's first name                       |
| `last_name`     | Citizen's last name                        |
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
