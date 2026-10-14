
-- Project: Enterprise Data Modelling & Schema Governance Lab
-- Database: Ontario Citizen Licensing & Permit Management Platform
-- File: 03_reporting_queries.sql
-- Purpose: Application, payment, and review/approval reporting

-- =========================================================
-- REPORT 1: Application summary
-- Aggregate payments and documents separately to avoid
-- multiplying rows when an application has multiple records.
-- =========================================================

WITH payment_summary AS (
    SELECT
        application_id,
        SUM(amount) FILTER (
            WHERE payment_status = 'PAID'
        ) AS total_paid
    FROM payments
    GROUP BY application_id
),
document_summary AS (
    SELECT
        application_id,
        COUNT(DISTINCT document_id) AS document_count
    FROM application_documents
    GROUP BY application_id
)
SELECT
    a.application_number,
    c.first_name || ' ' || c.last_name AS citizen_name,
    at.type_name AS application_type,
    a.current_status,
    a.submitted_at,
    COALESCE(ps.total_paid, 0) AS total_paid,
    COALESCE(ds.document_count, 0) AS document_count
FROM applications a
JOIN citizens c
    ON c.citizen_id = a.citizen_id
JOIN application_types at
    ON at.application_type_id = a.application_type_id
LEFT JOIN payment_summary ps
    ON ps.application_id = a.application_id
LEFT JOIN document_summary ds
    ON ds.application_id = a.application_id
ORDER BY a.application_number;

-- =========================================================
-- REPORT 2: Payment details and reconciliation
-- =========================================================

SELECT
    a.application_number,
    at.type_name AS application_type,
    p.payment_reference,
    p.amount,
    p.payment_status,
    CASE
        WHEN p.payment_status = 'PAID' THEN p.amount
        ELSE 0
    END AS amount_paid,
    CASE
        WHEN p.payment_status = 'PENDING' THEN p.amount
        ELSE 0
    END AS amount_pending
FROM payments p
JOIN applications a
    ON a.application_id = p.application_id
JOIN application_types at
    ON at.application_type_id = a.application_type_id
ORDER BY a.application_number;


-- =========================================================
-- REPORT 3: Review and approval activity
-- =========================================================

SELECT
    a.application_number,
    a.current_status,
    r.review_status,
    reviewer.first_name || ' ' || reviewer.last_name
        AS reviewer_name,
    ap.decision AS approval_decision,
    approver.first_name || ' ' || approver.last_name
        AS approver_name
FROM applications a
LEFT JOIN application_reviews r
    ON r.application_id = a.application_id
LEFT JOIN users reviewer
    ON reviewer.user_id = r.reviewer_user_id
LEFT JOIN application_approvals ap
    ON ap.application_id = a.application_id
LEFT JOIN users approver
    ON approver.user_id = ap.approver_user_id
ORDER BY a.application_number;
