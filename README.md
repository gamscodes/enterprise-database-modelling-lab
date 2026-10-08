# Enterprise Database Modelling & Schema Governance Lab

[![Database](https://img.shields.io/badge/Database-PostgreSQL-336791?style=flat-square&logo=postgresql&logoColor=white)](#technology-stack)
[![Language](https://img.shields.io/badge/Language-SQL-003B57?style=flat-square&logo=sqlite&logoColor=white)](#technology-stack)
[![Modelling Tool](https://img.shields.io/badge/Modelling-dbdiagram.io-4A90E2?style=flat-square)](#technology-stack)
[![Platform](https://img.shields.io/badge/Platform-GitHub-181717?style=flat-square&logo=github&logoColor=white)](#technology-stack)

## Project Overview

This project demonstrates the end-to-end design and implementation of an enterprise relational database for a fictional **Ontario Citizen Licensing & Permit Management Platform**.

The platform supports the complete lifecycle of government licence and permit applications, including:

- Citizen management and profile administration
- Application submission and status tracking
- Document management and supporting artifact attachment
- Review and approval decisions by designated officials
- Payment tracking and financial records
- Access control and user role management
- Auditability and logging for compliance and oversight

---

## Project Objectives

This lab demonstrates practical experience across key database engineering and governance domains:

- Enterprise relational database design
- Data modelling and normalization up to 3NF/BCNF
- Database schema design and implementation
- Data integrity and validation rules
- Database standards and governance
- Indexing and performance considerations
- Technical documentation and data dictionary creation
- Developer consultation and database best practices
- Security, role access, and auditability considerations

---

## Technology Stack

| Component | Technology |
|---|---|
| Database Engine | PostgreSQL |
| Query Language | SQL (DDL, DML, DCL) |
| Data Modelling | dbdiagram.io |
| Version Control | GitHub |

---

## Business Scenario

The platform provides a centralized, single source of truth for managing citizen licence and permit applications throughout their lifecycle.

The architecture supports multiple operational personas:

- **Citizens** — Submit applications and check application status
- **Application Reviewers and Approvers** — Verify documentation and make determination decisions
- **System Administrators** — Manage roles, security, and reference data
- **Application Developers and DBAs** — Develop efficient queries, maintain schema integrity, and manage database performance

---

## Project Scope

The database supports the following core functional areas:

- Citizen and profile management
- Licence and permit management
- Application submission and lifecycle tracking
- Application status management
- Supporting document management
- Application review and approval workflows
- Payment and transaction tracking
- User and role-based access control
- Audit logging and compliance tracking
- Reference and lookup data management
- Database integrity and validation
- Query performance and indexing
- Database documentation and governance

---

## Project Structure

The project will be organized into the following areas:

```text
enterprise-database-lab/
│
├── README.md
│
├── docs/
│   ├── business-requirements.md
│   ├── data-dictionary.md
│   └── governance-standards.md
│
├── database/
│   ├── 01_schema/
│   ├── 02_tables/
│   ├── 03_constraints/
│   ├── 04_indexes/
│   ├── 05_seed_data/
│   └── 06_queries/
│
├── modelling/
│   └── erd/
│
└── tests/
    └── validation/
