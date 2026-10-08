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
