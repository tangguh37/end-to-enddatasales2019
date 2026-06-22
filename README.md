# RowDB -> ELT/CDC -> Column DB -> BI

**Real-time sales analytics pipeline** using Neon (PostgreSQL) -> Streamkap (CDC) -> MotherDuck (DuckDB) -> Power BI.

```
+----------------+     +----------------+     +----------------+     +----------------+
|    Neon        | --> |  Streamkap     | --> |  MotherDuck    | --> |   Power BI     |
|   (OLTP DB)    | CDC | (CDC Engine)   | JDBC| (OLAP Cloud)   |  PG |(Visualization) |
|   sales table  |     | source+dest    |     | sales_*_view   |  EP |  dashboards    |
+----------------+     +----------------+     +----------------+     +----------------+
```

## Dataset

**186K rows** of 2019 electronics store sales from Kaggle "Sales Analysis Datasets".
Columns: `order_id`, `product`, `quantity_ordered`, `price_each`, `order_date`, `purchase_address`.

## Quick Start

### 1. Neon - Source Database

```bash
psql $NEON_DATABASE_URL -f neon/schema.sql
psql $NEON_DATABASE_URL -f neon/seed.sql
psql $NEON_DATABASE_URL -f neon/replication-setup.sql
```

### 2. Streamkap - CDC Pipeline

- **Source**: Create Neon connector from `streamkap/source-neon.json` (use **unpooled** hostname)
- **Destination**: Create MotherDuck connector from `streamkap/destination-motherduck.json`
- **Pipeline**: Link source -> destination in Streamkap UI

### 3. MotherDuck - Analytics

```sql
-- Run in MotherDuck SQL editor
motherduck/setup.sql
motherduck/analytics-views.sql
```

### 4. Power BI - Dashboards

Follow `powerbi/README.md` to connect via MotherDuck's PostgreSQL endpoint.

## Project Structure

```
.
+-- neon/
|   +-- data/all_data.csv              # Source dataset (186K rows)
|   +-- schema.sql                     # OLTP table definition
|   +-- seed.sql                       # CSV import script
|   +-- replication-setup.sql          # CDC publication + replication user
+-- streamkap/
|   +-- source-neon.json               # Streamkap Neon source connector
|   +-- destination-motherduck.json    # Streamkap MotherDuck destination
+-- motherduck/
|   +-- setup.sql                      # Database/schema creation
|   +-- analytics-views.sql            # Power BI-friendly views
+-- powerbi/
|   +-- README.md                      # Connection guide for Power BI
+-- .env.example                       # Credential template
+-- README.md                          # This file
```

## Important Notes

- **Neon connections**: Streamkap requires **unpooled** connections (remove `-pooler` from hostname). PgBouncer does not support PostgreSQL replication protocol.
- **MotherDuck -> Power BI**: Use the **PostgreSQL endpoint** (not legacy ODBC connector) -- no drivers needed.
- **Power BI mode**: **DirectQuery** for live data; **Import** for faster dashboards with scheduled refresh.
