-- ============================================================
-- Enterprise Citizen Licensing & Permit Management Platform
-- Database Schema
-- PostgreSQL
-- ============================================================

-- Purpose:
-- This script defines the relational database structure for
-- the Citizen Licensing & Permit Management Platform.
--
-- Design principles:
--   1. Consistent snake_case naming
--   2. Explicit primary and foreign keys
--   3. Strong data integrity constraints
--   4. Appropriate PostgreSQL data types
--   5. Normalized relational design
-- ============================================================


-- ============================================================
-- 1. Citizens
-- ============================================================

CREATE TABLE citizens (
    citizen_id BIGINT GENERATED ALWAYS AS IDENTITY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_citizens
        PRIMARY KEY (citizen_id),

    CONSTRAINT chk_citizens_first_name
        CHECK (TRIM(first_name) <> ''),

    CONSTRAINT chk_citizens_last_name
        CHECK (TRIM(last_name) <> ''),

    CONSTRAINT chk_citizens_date_of_birth
        CHECK (date_of_birth <= CURRENT_DATE)
);


-- ============================================================
-- 2. Citizen Profiles
-- ============================================================

CREATE TABLE citizen_profiles (
    citizen_id BIGINT NOT NULL,
    email_address VARCHAR(255),
    phone_number VARCHAR(30),
    address_line_1 VARCHAR(200),
    address_line_2 VARCHAR(200),
    city VARCHAR(100),
    province_code VARCHAR(2),
    postal_code VARCHAR(10),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_citizen_profiles
        PRIMARY KEY (citizen_id),

    CONSTRAINT fk_citizen_profiles_citizen
        FOREIGN KEY (citizen_id)
        REFERENCES citizens (citizen_id),

    CONSTRAINT chk_citizen_profiles_province
        CHECK (
            province_code IS NULL
            OR LENGTH(province_code) = 2
        )
);


-- ============================================================
-- 3. Application Types
-- ============================================================

CREATE TABLE application_types (
    application_type_id BIGINT GENERATED ALWAYS AS IDENTITY,
    type_code VARCHAR(30) NOT NULL,
    type_name VARCHAR(150) NOT NULL,
    description TEXT,
    application_fee NUMERIC(12,2) NOT NULL DEFAULT 0.00,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_application_types
        PRIMARY KEY (application_type_id),

    CONSTRAINT uq_application_types_code
        UNIQUE (type_code),

    CONSTRAINT chk_application_types_fee
        CHECK (application_fee >= 0),

    CONSTRAINT chk_application_types_name
        CHECK (TRIM(type_name) <> '')
);


-- ============================================================
-- 4. Users
-- ============================================================

CREATE TABLE users (
    user_id BIGINT GENERATED ALWAYS AS IDENTITY,
    username VARCHAR(100) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email_address VARCHAR(255) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_users
        PRIMARY KEY (user_id),

    CONSTRAINT uq_users_username
        UNIQUE (username),

    CONSTRAINT uq_users_email
        UNIQUE (email_address),

    CONSTRAINT chk_users_username
        CHECK (TRIM(username) <> ''),

    CONSTRAINT chk_users_first_name
        CHECK (TRIM(first_name) <> ''),

    CONSTRAINT chk_users_last_name
        CHECK (TRIM(last_name) <> '')
);


-- ============================================================
-- 5. Roles
-- ============================================================

CREATE TABLE roles (
    role_id BIGINT GENERATED ALWAYS AS IDENTITY,
    role_code VARCHAR(50) NOT NULL,
    role_name VARCHAR(100) NOT NULL,
    description TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT pk_roles
        PRIMARY KEY (role_id),

    CONSTRAINT uq_roles_code
        UNIQUE (role_code),

    CONSTRAINT chk_roles_name
        CHECK (TRIM(role_name) <> '')
);


-- ============================================================
-- 6. Applications
-- ============================================================

CREATE TABLE applications (
    application_id BIGINT GENERATED ALWAYS AS IDENTITY,
    citizen_id BIGINT NOT NULL,
    application_type_id BIGINT NOT NULL,
    application_number VARCHAR(50) NOT NULL,
    current_status VARCHAR(50) NOT NULL,
    submitted_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_applications
        PRIMARY KEY (application_id),

    CONSTRAINT uq_applications_number
        UNIQUE (application_number),

    CONSTRAINT fk_applications_citizen
        FOREIGN KEY (citizen_id)
        REFERENCES citizens (citizen_id),

    CONSTRAINT fk_applications_type
        FOREIGN KEY (application_type_id)
        REFERENCES application_types (application_type_id),

    CONSTRAINT chk_applications_number
        CHECK (TRIM(application_number) <> ''),

    CONSTRAINT chk_applications_status
        CHECK (TRIM(current_status) <> '')
);


-- ============================================================
-- 7. Application Status History
-- ============================================================

CREATE TABLE application_status_history (
    status_history_id BIGINT GENERATED ALWAYS AS IDENTITY,
    application_id BIGINT NOT NULL,
    status_code VARCHAR(50) NOT NULL,
    changed_by_user_id BIGINT,
    changed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    reason TEXT,
    comments TEXT,

    CONSTRAINT pk_application_status_history
        PRIMARY KEY (status_history_id),

    CONSTRAINT fk_status_history_application
        FOREIGN KEY (application_id)
        REFERENCES applications (application_id),

    CONSTRAINT fk_status_history_user
        FOREIGN KEY (changed_by_user_id)
        REFERENCES users (user_id),

    CONSTRAINT chk_status_history_status
        CHECK (TRIM(status_code) <> '')
);


-- ============================================================
-- 8. Documents
-- ============================================================

CREATE TABLE documents (
    document_id BIGINT GENERATED ALWAYS AS IDENTITY,
    document_type VARCHAR(100) NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_reference VARCHAR(500) NOT NULL,
    uploaded_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    document_status VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_documents
        PRIMARY KEY (document_id),

    CONSTRAINT chk_documents_type
        CHECK (TRIM(document_type) <> ''),

    CONSTRAINT chk_documents_file_name
        CHECK (TRIM(file_name) <> ''),

    CONSTRAINT chk_documents_status
        CHECK (TRIM(document_status) <> '')
);


-- ============================================================
-- 9. Application Documents
-- ============================================================

CREATE TABLE application_documents (
    application_document_id BIGINT GENERATED ALWAYS AS IDENTITY,
    application_id BIGINT NOT NULL,
    document_id BIGINT NOT NULL,
    document_purpose VARCHAR(150),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_application_documents
        PRIMARY KEY (application_document_id),

    CONSTRAINT fk_application_documents_application
        FOREIGN KEY (application_id)
        REFERENCES applications (application_id),

    CONSTRAINT fk_application_documents_document
        FOREIGN KEY (document_id)
        REFERENCES documents (document_id),

    CONSTRAINT uq_application_documents
        UNIQUE (application_id, document_id)
);


-- ============================================================
-- 10. Application Reviews
-- ============================================================

CREATE TABLE application_reviews (
    review_id BIGINT GENERATED ALWAYS AS IDENTITY,
    application_id BIGINT NOT NULL,
    reviewer_user_id BIGINT NOT NULL,
    review_status VARCHAR(50) NOT NULL,
    reviewed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    comments TEXT,

    CONSTRAINT pk_application_reviews
        PRIMARY KEY (review_id),

    CONSTRAINT fk_application_reviews_application
        FOREIGN KEY (application_id)
        REFERENCES applications (application_id),

    CONSTRAINT fk_application_reviews_user
        FOREIGN KEY (reviewer_user_id)
        REFERENCES users (user_id),

    CONSTRAINT chk_application_reviews_status
        CHECK (TRIM(review_status) <> '')
);


-- ============================================================
-- 11. Application Approvals
-- ============================================================

CREATE TABLE application_approvals (
    approval_id BIGINT GENERATED ALWAYS AS IDENTITY,
    application_id BIGINT NOT NULL,
    approver_user_id BIGINT NOT NULL,
    decision VARCHAR(30) NOT NULL,
    decision_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    comments TEXT,

    CONSTRAINT pk_application_approvals
        PRIMARY KEY (approval_id),

    CONSTRAINT fk_application_approvals_application
        FOREIGN KEY (application_id)
        REFERENCES applications (application_id),

    CONSTRAINT fk_application_approvals_user
        FOREIGN KEY (approver_user_id)
        REFERENCES users (user_id),

    CONSTRAINT chk_application_approvals_decision
        CHECK (decision IN ('APPROVED', 'REJECTED', 'RETURNED'))
);


-- ============================================================
-- 12. Payments
-- ============================================================

CREATE TABLE payments (
    payment_id BIGINT GENERATED ALWAYS AS IDENTITY,
    application_id BIGINT NOT NULL,
    payment_reference VARCHAR(100) NOT NULL,
    amount NUMERIC(12,2) NOT NULL,
    payment_status VARCHAR(50) NOT NULL,
    paid_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_payments
        PRIMARY KEY (payment_id),

    CONSTRAINT uq_payments_reference
        UNIQUE (payment_reference),

    CONSTRAINT fk_payments_application
        FOREIGN KEY (application_id)
        REFERENCES applications (application_id),

    CONSTRAINT chk_payments_amount
        CHECK (amount >= 0),

    CONSTRAINT chk_payments_status
        CHECK (TRIM(payment_status) <> '')
);


-- ============================================================
-- 13. User Roles
-- ============================================================

CREATE TABLE user_roles (
    user_role_id BIGINT GENERATED ALWAYS AS IDENTITY,
    user_id BIGINT NOT NULL,
    role_id BIGINT NOT NULL,
    assigned_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    assigned_by_user_id BIGINT,

    CONSTRAINT pk_user_roles
        PRIMARY KEY (user_role_id),

    CONSTRAINT fk_user_roles_user
        FOREIGN KEY (user_id)
        REFERENCES users (user_id),

    CONSTRAINT fk_user_roles_role
        FOREIGN KEY (role_id)
        REFERENCES roles (role_id),

    CONSTRAINT fk_user_roles_assigned_by
        FOREIGN KEY (assigned_by_user_id)
        REFERENCES users (user_id),

    CONSTRAINT uq_user_roles
        UNIQUE (user_id, role_id)
);


-- ============================================================
-- 14. Audit Logs
-- ============================================================

CREATE TABLE audit_logs (
    audit_log_id BIGINT GENERATED ALWAYS AS IDENTITY,
    user_id BIGINT,
    action_type VARCHAR(100) NOT NULL,
    entity_name VARCHAR(100) NOT NULL,
    record_id BIGINT,
    event_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    details TEXT,

    CONSTRAINT pk_audit_logs
        PRIMARY KEY (audit_log_id),

    CONSTRAINT fk_audit_logs_user
        FOREIGN KEY (user_id)
        REFERENCES users (user_id),

    CONSTRAINT chk_audit_logs_action
        CHECK (TRIM(action_type) <> ''),

    CONSTRAINT chk_audit_logs_entity
        CHECK (TRIM(entity_name) <> '')
);


-- ============================================================
-- 15. Performance Indexes
-- ============================================================

CREATE INDEX idx_applications_citizen_id
    ON applications (citizen_id);

CREATE INDEX idx_applications_application_type_id
    ON applications (application_type_id);

CREATE INDEX idx_applications_current_status
    ON applications (current_status);

CREATE INDEX idx_status_history_application_id
    ON application_status_history (application_id);

CREATE INDEX idx_status_history_changed_at
    ON application_status_history (changed_at);

CREATE INDEX idx_application_documents_document_id
    ON application_documents (document_id);

CREATE INDEX idx_application_reviews_application_id
    ON application_reviews (application_id);

CREATE INDEX idx_application_reviews_reviewer_user_id
    ON application_reviews (reviewer_user_id);

CREATE INDEX idx_application_approvals_application_id
    ON application_approvals (application_id);

CREATE INDEX idx_application_approvals_approver_user_id
    ON application_approvals (approver_user_id);

CREATE INDEX idx_payments_application_id
    ON payments (application_id);

CREATE INDEX idx_payments_payment_status
    ON payments (payment_status);

CREATE INDEX idx_user_roles_role_id
    ON user_roles (role_id);

CREATE INDEX idx_audit_logs_user_id
    ON audit_logs (user_id);

CREATE INDEX idx_audit_logs_event_timestamp
    ON audit_logs (event_timestamp);


-- ============================================================
-- End of schema definition
-- ============================================================
