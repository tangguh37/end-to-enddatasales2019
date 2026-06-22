# Power BI + MotherDuck Connection

## Method: PostgreSQL Endpoint (Recommended)

MotherDuck exposes a PostgreSQL-compatible endpoint -- no ODBC driver needed.

### Prerequisites

- Power BI Desktop (Windows)
- A MotherDuck access token ([create one here](https://app.motherduck.com/settings/tokens))
- Your MotherDuck Postgres host ([find it here](https://app.motherduck.com/settings/postgres))

### Steps

1. **Open Power BI Desktop** -> **Get Data** -> **PostgreSQL database**

2. **Fill in connection details:**

   | Field | Value |
   |-------|-------|
   | Server | `pg.<region>.motherduck.com` (e.g. `pg.us-east-1-aws.motherduck.com`) |
   | Database | `sales_analytics` |

3. **Select data connectivity mode:**

   - **DirectQuery** -- queries run live against MotherDuck (real-time)
   - **Import** -- loads a snapshot into Power BI for faster local interactions

4. **Enter credentials:**

   | Field | Value |
   |-------|-------|
   | User name | `postgres` |
   | Password | Your MotherDuck access token |

5. **Click Connect** -> In Navigator, expand the `analytics` schema -> select views:

   - `v_monthly_sales`
   - `v_top_products`
   - `v_daily_sales`
   - `v_sales_by_city`

6. **Click Load** -- data is now in Power BI.

### Suggested Dashboards

| Tab | Visuals |
|-----|---------|
| Monthly Overview | Line chart (revenue over time), card (total revenue), table (monthly breakdown) |
| Product Performance | Bar chart (top products by revenue), scatter (qty vs price) |
| Geographic | Map chart (sales by city/state) |
| Daily Trends | Area chart (daily revenue), slicer for date range |

### Power BI Service (Cloud Publishing)

1. Set up an **On-Premises Data Gateway** (Standard mode) on a Windows machine
2. Add a PostgreSQL data source in the gateway pointing to MotherDuck Postgres endpoint
3. Publish the `.pbix` report -> **Settings** -> map the dataset to the gateway data source
4. Set up **scheduled refresh** for Import mode, or use DirectQuery for live data

### References

- https://motherduck.com/docs/integrations/bi-tools/powerbi/powerbi-desktop/
- https://motherduck.com/docs/integrations/bi-tools/powerbi/powerbi-service/
