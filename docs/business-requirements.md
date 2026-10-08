# Business Requirements

> **Portfolio Project:** This project is a fictional enterprise database simulation created to demonstrate database design, data modelling, governance, and technical problem-solving skills. It is not an actual Ontario government system.

## 1. Business Problem

This portfolio project simulates a centralized **Citizen Licensing & Permit Management Platform** for an Ontario government context.

The simulated platform is designed to manage citizen licence and permit applications throughout their complete lifecycle.

The platform must support multiple business processes, including citizen information management, application submission, supporting document management, application review, approval decisions, payment processing, user access management, and audit activities.

The proposed database will provide a centralized relational data model to support these processes and provide a consistent source of information for application processing and operational reporting.

## 2. Business Objective

The objective of this portfolio project is to design a reliable, maintainable, and scalable enterprise database that supports the simulated application lifecycle while demonstrating:

* Data integrity
* Security considerations
* Auditability
* Performance considerations
* Maintainability
* Consistent data management practices
* Database governance

The database will provide a structured foundation for a hypothetical application development team, operational reporting, and future system integrations.

## 3. Project Goal

The project demonstrates how business requirements can be translated into an enterprise relational database design using:

* Requirements analysis
* Data modelling
* Relational database design
* Normalization
* Primary and foreign keys
* Data integrity constraints
* Database standards and governance
* Indexing and performance considerations
* Technical documentation

## 4. Scope

The simulated database will support the following business areas:

1. Citizen management
2. Citizen profile management
3. Licence and permit type management
4. Application submission and tracking
5. Application status history
6. Supporting document management
7. Application review and approval
8. Payment tracking
9. User and role management
10. Audit logging
11. Operational reporting

## 5. Stakeholders

### 5.1 Citizens

Citizens are the primary external users of the simulated platform. They require the ability to:

* Maintain their personal and contact information
* Submit licence and permit applications
* Upload supporting documents
* View application status
* Respond to requests for additional information
* View payment requirements and payment status

### 5.2 Application Reviewers

Application reviewers are simulated government employees responsible for reviewing submitted applications and supporting documentation. They require the ability to:

* Access applications assigned for review
* Review application information and supporting documents
* Request additional information
* Record review outcomes
* View application history

### 5.3 Approvers

Approvers are simulated authorized government employees responsible for making application decisions. They require the ability to:

* Review application information and recommendations
* Approve or reject applications
* Record decision comments
* View the history of previous application activity

### 5.4 System Administrators

System administrators are responsible for managing simulated system users and access. They require the ability to:

* Create and maintain system user accounts
* Assign roles
* Manage user access
* Support administrative functions
* Review relevant audit information

### 5.5 Application Development Team

The simulated application development team uses the database as the data foundation for citizen-facing and internal applications. They require:

* Consistent database structures
* Clearly defined relationships
* Reliable data integrity
* Documented database standards
* Predictable query interfaces
* Technical guidance for database usage

### 5.6 Database Administration Team

The simulated database administration team is responsible for the technical operation and governance of the database. They require:

* Well-defined database structures
* Consistent naming standards
* Appropriate constraints and indexes
* Database documentation
* Auditable database activity
* Maintainable database objects
* Design practices that support performance, security, availability, and future scalability

### 5.7 Management and Reporting Users

Management and reporting users require access to reliable information to support simulated operational monitoring and decision-making.

They may require reports relating to:

* Application volumes
* Application status
* Processing times
* Approval and rejection rates
* Reviewer workloads
* Payment activity

## 6. Functional Requirements

The following functional requirements define what the simulated platform must be able to support.

### FR-01 — Citizen Management

The system shall maintain a unique record for each citizen.

The citizen record should contain the information required to identify and contact the citizen within the scope of the simulated platform.

### FR-02 — Citizen Profile Management

The system shall allow citizen profile information to be maintained separately from core citizen identification information where appropriate.

Profile information may include contact and address information.

### FR-03 — Licence and Permit Types

The system shall maintain a controlled list of available licence and permit types.

Each type should include information such as its name, description, applicable fee, and active/inactive status.

### FR-04 — Application Submission

The system shall allow a citizen to submit multiple licence or permit applications.

Each application shall be associated with:

* One citizen
* One application type
* A submission date
* A current application status

### FR-05 — Application Status Management

The system shall maintain the current status of each application.

Example statuses may include:

* Draft
* Submitted
* Under Review
* Additional Information Required
* Approved
* Rejected
* Withdrawn
* Completed

### FR-06 — Application Status History

The system shall retain the historical status changes for each application.

Each status history record should identify:

* The application
* The status
* When the status changed
* The user or system process responsible for the change
* An optional reason or comment

The system shall retain historical status information rather than overwriting previous status changes.

### FR-07 — Supporting Document Management

The system shall allow applications to have supporting documents.

The system should maintain document metadata such as:

* Document type
* File name
* Upload date
* Document status
* Application association

### FR-08 — Application Review

The system shall support the review of submitted applications by authorized users.

Review activities should allow reviewers to:

* Access application information
* Review supporting documents
* Record review information
* Request additional information
* Record review outcomes

### FR-09 — Approval Decisions

The system shall support approval and rejection decisions for applications.

Each decision should record:

* Application
* Decision-maker
* Decision
* Decision date
* Comments

### FR-10 — Payment Management

The system shall support payment records for applications where a fee is required.

Payment information should include:

* Application
* Payment amount
* Payment date
* Payment status
* Payment reference

### FR-11 — User Management

The system shall maintain authorized users who interact with the simulated platform.

User records should support identification and account status information.

### FR-12 — Role Management

The system shall support role-based access concepts.

Users may be assigned one or more roles, such as:

* Application Reviewer
* Approver
* System Administrator
* Reporting User

### FR-13 — Audit Logging

The system shall maintain audit records for important system activities.

Audit records should allow authorized users to determine:

* Who performed an action
* What action was performed
* Which record was affected
* When the action occurred

### FR-14 — Application Search and Filtering

The system shall support common application search and filtering requirements.

Users should be able to locate applications using criteria such as:

* Application ID
* Citizen
* Application type
* Application status
* Submission date
* Assigned reviewer

### FR-15 — Operational Reporting

The database shall support information required for operational and management reporting.

Examples include:

* Application volumes
* Applications by status
* Applications by licence or permit type
* Processing times
* Reviewer workload
* Approval and rejection rates
* Payment activity

## 7. Non-Functional Requirements

The following non-functional requirements define the expected technical qualities of the simulated database environment.

### NFR-01 — Data Integrity

The database shall maintain accurate and consistent data through appropriate database constraints and validation rules.

The design shall use:

* Primary keys
* Foreign keys
* NOT NULL constraints
* UNIQUE constraints
* CHECK constraints
* Appropriate data types

Business rules that can be reliably enforced at the database level should not depend solely on application-level validation.

### NFR-02 — Performance

The database shall support efficient execution of frequently used application and reporting queries.

The design shall consider:

* Appropriate indexing
* Query access patterns
* Join performance
* Filtering and sorting requirements
* Index maintenance overhead
* Growth in data volume

Indexes shall be created based on documented query and workload requirements rather than being added indiscriminately.

### NFR-03 — Scalability

The database design shall support growth in:

* Citizens
* Applications
* Documents
* Payments
* Status history records
* Audit records

The logical model should allow the platform to scale without requiring fundamental changes to core business relationships.

### NFR-04 — Security

Database access shall follow the principle of least privilege.

The design shall consider:

* Role-based access
* Separation of responsibilities
* Controlled access to sensitive information
* Authentication and authorization
* Service account usage
* Auditability of privileged activities

Detailed role-based access control implementation will be addressed in a future portfolio project.

### NFR-05 — Availability and Reliability

The database should be designed with reliability and operational continuity in mind.

The architecture should support future implementation of:

* Backup strategies
* Recovery procedures
* Disaster recovery
* Monitoring
* Availability controls

Detailed backup and recovery implementation will be addressed in a future portfolio project.

### NFR-06 — Maintainability

Database objects shall follow consistent and documented standards.

The database shall use:

* Consistent naming conventions
* Clearly defined relationships
* Documented constraints
* Documented indexes
* Structured SQL scripts
* Version-controlled database changes

### NFR-07 — Auditability

Important business and administrative activities shall be traceable.

The database shall support the ability to determine:

* Who performed an action
* What action occurred
* Which record was affected
* When the action occurred

### NFR-08 — Governance

Database structures and changes shall follow documented technical standards.

Governance shall address:

* Naming conventions
* Data types
* Primary and foreign key standards
* Constraint standards
* Indexing standards
* Documentation requirements
* Change management
* Data integrity practices

### NFR-09 — Compatibility

The database design shall use standard relational database concepts and PostgreSQL-supported functionality.

The design should avoid unnecessary vendor-specific complexity unless there is a documented technical reason for its use.

### NFR-10 — Observability

The database environment should provide sufficient information to support troubleshooting and operational analysis.

Future implementations should consider:

* Database performance metrics
* Query execution analysis
* Audit information
* Error monitoring
* Resource utilization
* Operational logging

### NFR-11 — Extensibility

The database design should allow additional licence and permit types, application statuses, document types, roles, and reporting requirements to be introduced without unnecessary structural changes.

Reference and configuration data should be separated from transactional data where appropriate.

### NFR-12 — Documentation

The database design shall be documented sufficiently for application developers, database administrators, and technical stakeholders to understand:

* Business entities
* Relationships
* Data definitions
* Constraints
* Indexes
* Design decisions
* Governance standards
* Usage considerations
