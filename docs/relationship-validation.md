# Relationship Validation

> **Portfolio Project:** Citizen Licensing & Permit Management Platform

This document validates the relationships identified during the logical database modelling stage. Each relationship is evaluated against the business requirements and business rules to ensure that the proposed data model supports data integrity, minimizes unnecessary duplication, and follows relational database design principles.

## 1. Citizens and Applications

### Relationship

**One-to-many**

```text
citizens (1) ───────── (many) applications
```

### Business Reason

A citizen may submit multiple licence or permit applications.

Each application belongs to one citizen.

### Database Design

The `applications` entity will contain:

```text
citizen_id
```

This will reference:

```text
citizens.citizen_id
```

through a foreign key.

### Normalization Rationale

Citizen information should not be duplicated within every application.

For example, if one citizen submits five applications, the database should contain:

```text
1 citizen record
5 application records
```

rather than storing the citizen's name, date of birth, and other identifying information five times.

Separating the entities reduces unnecessary duplication and allows citizen information to be maintained independently from application transactions.

### Integrity Rule

An application must not reference a citizen that does not exist.

The physical database implementation will enforce this relationship using a foreign key constraint.

