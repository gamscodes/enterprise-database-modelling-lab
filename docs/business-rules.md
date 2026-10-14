# Business Rules

> **Portfolio Project:** These rules define the requirements for the fictional Citizen Licensing & Permit Management Platform. They distinguish implemented database integrity controls from business workflow requirements that may require application-level enforcement or future enhancements.

## 1. Citizen Management Rules

### BR-01 - Unique Citizen
Each citizen must have a unique system-generated identifier.

### BR-02 - Required Citizen Information
Required citizen information must be provided when a citizen record is created. Database constraints shall enforce applicable required fields.

### BR-03 - Citizen Applications
A citizen may submit multiple licence or permit applications. Each application must reference one existing citizen.

### BR-04 - Citizen Deletion
A citizen with associated application records must not be deleted in a way that creates orphaned application records. Referential integrity shall be maintained through appropriate foreign key constraints and deletion rules.

## 2. Application Rules

### BR-05 - Application Ownership
Every application must be associated with exactly one citizen.

### BR-06 - Application Type
Every application must reference an existing licence or permit type.

### BR-07 - Application Status
Every application must have a nonblank current status. The application workflow should restrict statuses to approved business values.

### BR-08 - Application Submission
An application must satisfy the information requirements defined for its application type before it can be considered submitted. This validation may require application-level logic in addition to database constraints.

### BR-09 - Application History
An application may have multiple historical status records. Each status history record must reference an existing application.

### BR-10 - Historical Status Preservation
Previous application status changes must be retained in the status history rather than being overwritten when the current application status changes. The application workflow is responsible for recording each relevant status transition.

## 3. Document Management Rules

### BR-11 - Application Documents
An application may be associated with multiple supporting documents.

### BR-12 - Document Association
Every application-document relationship must reference valid application and document records. Database foreign keys shall enforce these relationships.

### BR-13 - Document Metadata
Each document record must contain the required metadata to identify its document type, file name, and status. The database stores document metadata and relationships; actual file contents may be stored in a separate file storage service or repository.

## 4. Review and Approval Rules

### BR-14 - Authorized Review
Only authorized users should perform application review activities. Enforcement requires appropriate authentication, authorization, and application or database access controls.

### BR-15 - Approval Decision
Every approval decision must reference an existing application.

### BR-16 - Decision Maker
Every approval decision must identify the user responsible for the decision.

### BR-17 - Decision Date
Every approval decision must record the date and time of the decision.

### BR-18 - Decision Integrity
An application should not have conflicting final decisions for the same decision stage. The application workflow must validate decision consistency. Additional database constraints may be introduced if required by the finalized business process.

## 5. Payment Rules

### BR-19 - Application Payment
Every payment must be associated with an existing application.

### BR-20 - Non-Negative Payment
A payment amount must be greater than or equal to zero. The database shall enforce the applicable amount constraint.

### BR-21 - Payment Status
Every payment must have a nonblank payment status. The application workflow should restrict payment statuses to approved values, such as `PENDING`, `PAID`, `FAILED`, or `REFUNDED`. Database-level validation should enforce the approved list when the permitted values have been finalized.

### BR-22 - Payment Reference
Each payment must have a unique reference that allows the transaction to be identified and reconciled. Database uniqueness constraints shall enforce the reference's uniqueness.

## 6. User and Role Rules

### BR-23 - Unique User
Each system user must have a unique system-generated identifier.

### BR-24 - User Roles
A user may have one or more assigned roles. The database shall support user-to-role relationships.

### BR-25 - Role Assignment
Each role assignment must reference an existing user and an existing role. Database foreign keys shall enforce these relationships.

### BR-26 - Access Control
Access to protected functions should be determined by assigned roles. Actual access enforcement requires appropriate application or database security configuration.

### BR-27 - Least Privilege
Users should receive only the permissions necessary to perform their responsibilities. Permission design and enforcement are security and governance responsibilities.

## 7. Audit Rules

### BR-28 - Auditable Actions
Important application, approval, payment, administrative, and security-related actions should be recorded in the audit log where applicable.

### BR-29 - Audit Actor
Where applicable, each audit record should identify the user or system process responsible for the action.

### BR-30 - Audit Timestamp
Each audit record must record the date and time of the event.

### BR-31 - Audit Record Integrity
Audit information should be protected from unauthorized modification or deletion through appropriate permissions, access controls, and operational procedures. Stronger audit immutability controls may be implemented as a future security enhancement.

## 8. Data Integrity Rules

### BR-32 - Referential Integrity
Foreign key relationships must prevent records from referencing entities that do not exist. The database shall enforce the foreign key constraints defined in the schema.

### BR-33 - Required Values
Required business attributes must not allow `NULL` values. Database `NOT NULL` constraints shall enforce applicable requirements.

### BR-34 - Valid Values
Attributes with restricted business values must use appropriate validation mechanisms. The database currently enforces defined check constraints; additional value restrictions may be introduced as business requirements are finalized.

### BR-35 - Uniqueness
Attributes that represent unique business identifiers must have appropriate uniqueness controls, including primary keys and unique constraints where applicable.

## 9. Data Quality Rules

### BR-36 - Valid Dates
Dates and timestamps must use appropriate database data types and represent valid values. Business rules governing date ranges must be enforced through database constraints or application-level validation as appropriate.

### BR-37 - Consistent Status Values
Application and payment statuses should use controlled values rather than unrestricted free text. Where controlled values are not yet fully enforced by database constraints, the application workflow should validate them.

### BR-38 - Consistent Identifiers
Database identifiers should follow documented naming and generation standards. Primary keys and business identifiers should be used consistently across related records.

### BR-39 - Historical Accuracy
Historical records, including status changes, approval decisions, payments, and audit events, should preserve the information and timestamps associated with the original events. Changes to current records should not silently rewrite historical events.
