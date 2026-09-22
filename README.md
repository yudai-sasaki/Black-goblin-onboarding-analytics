# Black-goblin-onboarding-analytics
Privacy-first product analytics & onboarding optimization framework for a deep-tech SaaS.
> *Note on Data Privacy: To preserve corporate data confidentiality, some figures presented in this repository have been generalized, normalized, or expressed in relative proportions.*

---
### 📌 Key Impact
Established an event-driven telemetry pipeline, isolated an **over 60% onboarding drop-off**, and formulated a privacy-first product strategy (pre-loaded sample assets & Wasm architecture) to drive the 24-hour Activation Rate toward the **30% PMF target**.

---
## 📌 Executive Summary
Black Goblin Audio (an AI-audio startup) launched its Open Beta for Thol—an AI tool automating visual-event logging and cue-sheet generation for film/TV sound designers. Despite initial user acquisition, the 24-hour Activation Rate stagnated around 10%. As a Part-time Data Scientist, I built a privacy-first telemetry architecture under GDPR constraints, diagnosed the root cause of user churn using quantitative models and domain analysis, and delivered a 3-phase roadmap to remove onboarding friction.

---
## 🔍 Problem Statement
* Lack of Visibility: The startup had no product analytics or telemetry, operating blindly without knowing why 89% of registered users failed to activate.
* Capital Risk: Feature iteration relied on internal intuition rather than empirical data.
* Goal: Elevate the 24-hour Activation Rate from around 10% to 30% (the threshold required for Product-Market Fit).

---
## 🛠️ Data Infrastructure & Methodology

### 1. Privacy-First Data Pipeline (GDPR-Compliant)
Built an event-driven pipeline connecting internal servers, PostHog, and BigQuery by casting user identifiers (`person_id`). This allowed tracking in-app behavioral events without exposing PII.

### 2. Data Integrity Audit & Feature Engineering
* Disproved Credit Shortage: Audited the billing schema and proved users received ~68.5 promotional minutes/month; credit access was not the bottleneck.
* Handling Multicollinearity & Data Leakage: Removed collinear features ($r = 1.00$ between upload & analysis start) and future-leakage variables ($r = 0.78$ cumulative lifetime downloads).
* Time-to-Value (TTV) Correlation: Found a strong negative correlation ($r = -0.71$) between activation status and time-to-first-download, proving that value must be delivered within the first session.

---
## 📊 Key Findings & Analytics Insights

### 1. The Onboarding Bottleneck (Quantitative Funnel)
Quantitative funnel tracking revealed that **over 60% of all new users dropped off at the very first step: Initial Video Upload**. System logs confirmed high algorithmic performance (98.2% job success, <15s processing time) and 80% of drop-offs were "silent exits"—ruling out software crashes or speed issues.

### 2. Statistical Factor Estimation
* Fisher’s Exact Test: Confirmed that completing a video upload within 24h is statistically overwhelming ($p = 3.97 \times 10^{-6}).
* Odds Ratio (Haldane-Anscombe Correction): Uploading a video increases the odds of product activation by **59.40x** (Class-Weighted Balanced Logistic Regression: **23.62x**).

### 3. Mixed-Methods Triangulation (Domain & Privacy Barrier)
Qualitative inquiry into film industry security standards (TPN / MPA guidelines) revealed the true friction:
> Sound designers work under strict NDAs. Forcing users to upload unreleased, confidential film footage to a 3rd-party cloud server during a trial session created an insurmountable security and legal anxiety (digital video piracy costs the industry $29B+ annually).

---
## 🚀 Strategic Recommendations & Implementation Roadmap
Rather than spending engineering bandwidth on building more AI features (the "Tech-First Trap"), I proposed a 3-phase privacy-first product strategy:

1. **Phase 1 (Immediate UX - Month 1): Pre-loaded Sample Video Assets**
   * Added a *"Try with Sample Video"* option using public-domain open-source clips.
   * Impact: Zero privacy risk, will reduce TTV from hours to 60 seconds, capturing the over 60% hesitant drop-off cohort.
2. **Phase 2 (Medium-Term Arch - Months 2–3): Client-Side WebAssembly (Wasm)**
   * Transitioned computer vision inference from cloud servers to local browsers via Wasm/WebGPU.
   * Impact: Guaranteed media privacy and significantly reduced cloud GPU server costs.
3. **Phase 3 (Long-Term Scalability - Months 4–6): Local-First Desktop App (Tauri / Electron)**
   * Deployed an air-gapped native desktop app satisfying TPN security audits for major Hollywood studios.

---
## 🛠️ Tech Stack & Skills Used
* Languages & Analytics: Python (Pandas, Scikit-learn, Statsmodels), SQL (PostgreSQL, CTEs)
* Statistical Modeling: Logistic Regression, Fisher’s Exact Test, Haldane-Anscombe Corrections, Odds Ratio Analysis
* Product & Telemetry Tools: PostHog, Supabase, BigQuery
* Domain Knowledge: SaaS Product-Led Growth (PLG), Funnel & Cohort Analysis, GDPR Privacy Constraints
