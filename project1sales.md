# Project 1: Sales Data Pipeline

A real-time pipeline streaming 185K electronics sales records from Neon (PostgreSQL) → Streamkap (CDC) → MotherDuck (DuckDB) → Power BI dashboards.

---

## Architecture

```
Neon (source OLTP)  ──CDC──>  Streamkap  ──JDBC──>  MotherDuck (OLAP)  ──PG──>  Power BI
```

---

## Neon (Source Database)

| Item | Detail |
|------|--------|
| Host (pooled) | `ep-delicate-flower-ao94c4u7-pooler.c-2.ap-southeast-1.aws.neon.tech` |
| Host (unpooled) | `ep-delicate-flower-ao94c4u7.c-2.ap-southeast-1.aws.neon.tech` |
| Database | `neondb` |
| Owner | `neondb_owner` |
| Replication user | `streamkap_user` / `Str30mk@p_2024!` |
| Publication | `streamkap_pub` FOR TABLE sales |
| Tables | `sales` (185,950 rows), `BIGSERIAL` primary key |

### Sales Table Columns
`id`, `order_id`, `product`, `quantity_ordered`, `price_each`, `order_date`, `purchase_address`

### CSV Source
`neon/data/all_data.csv` — 19 electronics products, Jan-Dec 2019. 355 duplicate header rows filtered during import.

---

## Streamkap (CDC Engine)

- **Source Connector**: `neon-sales-source` — captures changes from Neon via logical replication
- **Destination Connector**: `motherduck-sales-destination` — writes to MotherDuck via JDBC
- **Pipeline**: streams in real-time with upsert mode, schema evolution enabled

---

## MotherDuck (Analytics Destination)

- **Database**: `sales_analytics`
- **Schemas**: `streamkap` (raw data), `analytics` (aggregated views)

### Analytics Views
| View | Description |
|------|-------------|
| `v_monthly_sales` | Revenue, orders, and quantity grouped by month |
| `v_top_products` | Products ranked by total revenue |
| `v_daily_sales` | Daily order count, quantity, and revenue |
| `v_sales_by_city` | Revenue and orders by city and state |

---

## Power BI Connection

| Field | Value |
|-------|-------|
| Connector | PostgreSQL database |
| Server | Get from MotherDuck Settings → Postgres endpoint |
| Database | `sales_analytics` |
| Username | `postgres` |
| Password | MotherDuck access token (`md_...`) |
| Schema | `analytics` (select all 4 views) |
| Mode | DirectQuery (live) or Import (snapshot) |

---

## Key Notes
- Neon logical replication must be enabled in **Project Settings → Logical Replication**
- Streamkap requires the **unpooled** Neon host (no `-pooler`)
- CSV had multi-product orders (same `order_id` for different products) — fixed by using `BIGSERIAL` auto-increment ID
- 355 duplicate CSV header rows were removed during import
