# Enterprise Data Quality & Exception Auditing Layer (Pure SQL)

## 📌 Project Overview
Upstream data corruption—such as missing transaction IDs, negative financial entries, or malformed strings—frequently breaks production pipelines and distorts executive dashboards. This project designs a robust, production-grade **Data Quality & Exception Auditing Layer** built entirely in ANSI/PostgreSQL SQL. 

Instead of allowing corrupted records to pollute downstream analytics, this architecture programmatically flags, diagnostic-logs, and quarantines anomalies into an audit layer. This ensures that executive BI tools (Tableau/Power BI) query a pristine, guaranteed data layer.

### 🚀 Business Impact & Key Results
* **Dashboard Trust Assurance:** Guaranteed 100% data integrity for downstream reporting by enforcing strict relational schema rules and structural validation.
* **Proactive Risk Mitigation:** Engineered conditional auditing logic to isolate invalid negative financial transactions, protecting revenue reporting accuracy.
* **Operational SLA Tracking:** Built an automated automated exception view to isolate logistics logs with corrupted date strings for data engineering review.

---

## 🛠️ Tech Stack & Database Concepts
* **Language:** SQL (PostgreSQL / ANSI SQL)
* **Core Concepts:** Data Quality Validation Rules, Conditional Log Aggregation (`CASE WHEN`), Common Table Expressions (CTEs), Subqueries, and Automated Exception View Logging.

---

## 📋 Data Quality Audit Checklist (Before vs. After)

| Ingested Anomaly | Detection Logic | Quarantine & Resolution Action |
| :--- | :--- | :--- |
| **Null Transaction IDs** | `IS NULL` Check | Isolated in Exception Log; blocked from production BI |
| **Negative Revenue** | `revenue <= 0` Validation | Quarantining corrupt financial adjustments for audit |
| **Malformed Dates** | Like-Pattern String Parsing | Filtered out to protect time-series seasonality charts |
| **Text Whitespace** | String Truncation (`TRIM`) | Cleaned programmatically and forced to uniform uppercase |

---

## 📂 Repository File Directory
* `data_quality_audit.sql`: The primary core database script containing table DDL, mock raw data inserts, the Exception Audit View, and the Clean Production View.
