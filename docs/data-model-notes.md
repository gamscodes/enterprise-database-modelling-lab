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
