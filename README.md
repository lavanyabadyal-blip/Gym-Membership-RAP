# Gym Membership Management System — SAP ABAP RAP

A cloud ABAP application for managing gym memberships, built on the **ABAP RESTful Application Programming Model (RAP)** on the SAP BTP ABAP Environment. It covers master data, the full subscription lifecycle, and reporting — surfaced through **SAP Fiori Elements**.

> Course: SAP ABAP & Cloud — Project Work (Heidelberg) · Managed, draft-enabled RAP Business Object

---

## Overview

The application digitises how a gym manages memberships. Staff maintain members, plans, trainers and locations, then create and track membership subscriptions. Business rules (no overlapping memberships, no past start dates) and automatic field derivation (end date, fee, status, running number) are enforced in the RAP behaviour layer. A separate read-only report highlights expiring and overdue memberships.

## Key Features

- **Two RAP Business Objects** — Membership Subscription (managed, draft-enabled) and Member (managed master-data maintenance)
- **3 determinations** — auto-calculate end date & amount from the plan, assign a running membership number, derive ACTIVE/EXPIRED status
- **3 validations** — start date required and not in the past, referenced member/plan must exist, no overlapping active membership per member
- **SAP Fiori Elements UI** — list report + object page, value helps, hidden administrative fields, text display (names instead of raw IDs)
- **Read-only report** — expiring / overdue memberships, colour-coded by criticality
- **Demo data generator** — seeds members, plans, trainers, locations and a spread of subscriptions

## Architecture (layered RAP stack)

```
UI / Service   : Fiori Elements · OData V4 UI service bindings · metadata extensions
Business Object: projection views · behaviour definitions (managed, draft) · behaviour pool classes
Data / CDS     : interface CDS views · associations · value helps
Database       : ZGM_MEMBER · ZGM_PLAN · ZGM_TRAINER · ZGM_LOCATION · ZGM_SUBSCR
```

## Data Model

| Table | Type | Key | Purpose |
|-------|------|-----|---------|
| `ZGM_MEMBER` | Master | member_id | Member master data |
| `ZGM_PLAN` | Master | plan_id | Membership plans (duration, price) |
| `ZGM_TRAINER` | Master | trainer_id | Trainers |
| `ZGM_LOCATION` | Master | location_id | Gym branches |
| `ZGM_SUBSCR` | Transactional | subscription_uuid | Membership subscriptions (the RAP BO) |

Each master entity relates 1 : N to Subscription.

## Object Inventory

- **5 database tables** + 1 generated draft table (`ZGM_SUBSCR_D`)
- **Interface CDS views:** `ZI_GM_Member`, `ZI_GM_Plan`, `ZI_GM_Trainer`, `ZI_GM_Location`, `ZI_GM_Subscription`
- **Projections:** `ZC_GM_Subscription`, `ZC_GM_Member`, `ZC_GM_ExpiringMembership`
- **Behaviour definitions + classes:** `ZI_GM_Subscription` / `zbp_i_gm_subscription`, `ZI_GM_Member` / `zbp_i_gm_member`
- **Metadata extensions:** `ZC_GM_Subscription`, `ZC_GM_Member`
- **Service definitions + OData V4 UI bindings:** `ZUI_GM_Subscription` / `_O4`, `ZUI_GM_Member` / `_O4`, `ZUI_GM_ExpMembership` / `_O4`
- **Data generator class:** `zcl_gm_data_generator`

## Technology Stack

- SAP BTP, ABAP Environment (Steampunk)
- ABAP RESTful Application Programming Model (RAP)
- Core Data Services (CDS) · Behaviour Definition Language (BDL)
- OData V4 · SAP Fiori Elements
- Eclipse ABAP Development Tools (ADT) · abapGit

## Setup / Deployment

1. Clone or pull this repository into package `ZGM_GYM` using **abapGit** in ADT.
2. Activate all objects (bottom-up: tables → CDS → behaviour → classes → projections → services).
3. After activating the Subscription behaviour definition, generate the draft table `ZGM_SUBSCR_D`.
4. Create an **OData V4 – UI** service binding for each service definition and **Publish** it.
5. Run `zcl_gm_data_generator` (F9) to load demo data.
6. Launch the Fiori Elements preview from the Subscription binding.

## Demo Flow

1. Open the Subscription app → create a membership → end date, amount, number and status auto-fill (determinations).
2. Create a second overlapping membership for the same member → blocked with a validation message.
3. Try a past start date → blocked.
4. Open the Expiring Memberships report → overdue / expiring rows, colour-coded.
5. Open the Member app → create or delete a member (second BO).

## Repository Structure

```
/src   — all ABAP objects serialized by abapGit
         (.tabl.xml, .ddls.asddls, .bdef, .clas.abap, .srvd.srvdsrv, .ddlx.asddlxs)
```

## Team

- Lavanya Badyal
- Sudanshu Singh Sindhu

Instructor: Andre Fischer (SAP SE)

## License

Academic project — for educational use.
