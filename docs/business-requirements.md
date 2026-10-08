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
