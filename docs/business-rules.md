# Business Rules

> **Portfolio Project:** These rules define the requirements for the fictional Citizen Licensing & Permit Management Platform used in this portfolio project.

## 1. Citizen Management Rules

### BR-01 — Unique Citizen

Each citizen must have a unique system-generated identifier.

### BR-02 — Required Citizen Information

Required citizen information must be provided when a citizen record is created.

### BR-03 — Citizen Applications

A citizen may submit multiple licence or permit applications.

### BR-04 — Citizen Deletion

A citizen with associated application records should not be deleted in a way that would create orphaned application records.

---

## 2. Application Rules

### BR-05 — Application Ownership

Every application must be associated with exactly one citizen.

### BR-06 — Application Type

Every application must reference a valid licence or permit type.

### BR-07 — Application Status

Every application must have a valid current status.

### BR-08 — Application Submission

An application cannot be considered submitted without the required information defined for its application type.

### BR-09 — Application History

An application may have multiple historical status records.

### BR-10 — Historical Status Preservation

Previous application statuses must be retained in the status history and must not be overwritten when the current application status changes.

---

## 3. Document Management Rules

### BR-11 — Application Documents

An application may have multiple supporting documents.

### BR-12 — Document Association

Every application-document relationship must reference valid application and document records.

### BR-13 — Document Metadata

Each document record must contain sufficient metadata to identify its document type and submission information.

---

## 4. Review and Approval Rules

### BR-14 — Authorized Review

Only authorized users may perform application review activities.

### BR-15 — Approval Decision

An approval or rejection decision must reference an existing application.

### BR-16 — Decision Maker

Every approval decision must identify the authorized user who made the decision.

### BR-17 — Decision Date

Every approval decision must record the date and time the decision was made.

### BR-18 — Decision Integrity

An application should not have multiple conflicting final approval decisions for the same decision stage.

---

## 5. Payment Rules

### BR-19 — Application Payment

Every payment must be associated with an existing application.

### BR-20 — Non-Negative Payment

A payment amount must be greater than or equal to zero.

### BR-21 — Payment Status

Every payment must have a valid payment status.

### BR-22 — Payment Reference

Each payment should have a reference that allows the transaction to be identified and reconciled.

---

## 6. User and Role Rules

### BR-23 — Unique User

Each system user must have a unique identifier.

### BR-24 — User Roles

A user may have one or more assigned roles.

### BR-25 — Role Assignment

A role assignment must reference both a valid user and a valid role.

### BR-26 — Access Control

Access to protected functions should be determined by the user's assigned roles.

### BR-27 — Least Privilege

Users should receive only the access required to perform their responsibilities.

---

## 7. Audit Rules

### BR-28 — Auditable Actions

Important application, approval, payment, administrative, and security-related actions must be auditable.

### BR-29 — Audit Actor

Where applicable, an audit record must identify the user or system process responsible for the action.

### BR-30 — Audit Timestamp

Each audit record must contain the date and time at which the event occurred.

### BR-31 — Audit Record Integrity

Audit information should be protected from unauthorized modification or deletion.

---

## 8. Data Integrity Rules

### BR-32 — Referential Integrity

Foreign key relationships must prevent records from referencing entities that do not exist.

### BR-33 — Required Values

Required business attributes must not allow NULL values.

### BR-34 — Valid Values

Attributes with restricted business values must use appropriate validation mechanisms.

### BR-35 — Uniqueness

Attributes that represent unique business identifiers must have appropriate uniqueness controls.

---

## 9. Data Quality Rules

### BR-36 — Valid Dates

Dates stored by the system must represent valid dates and should follow consistent timestamp standards.

### BR-37 — Consistent Status Values

Application and payment statuses must use controlled values rather than unrestricted free-text values where appropriate.

### BR-38 — Consistent Identifiers

Database identifiers should follow documented naming and generation standards.

### BR-39 — Historical Accuracy

Historical records such as status changes, approvals, payments, and audit events should preserve the original event information and timestamps.

