# Pharmaceutical Inventory and Supply Chain Management System

A PostgreSQL database system for managing pharmaceutical inventory, suppliers, warehouses, and stock movements.

## Overview

This project implements a relational database for tracking pharmaceutical products from suppliers through warehouses. It handles batch tracking with expiry dates, purchase orders, and inventory movements.

**Course:** Database Systems  
**Database:** PostgreSQL

## Features

- Supplier and product management
- Batch tracking with manufacture and expiry dates
- Multi-warehouse inventory management
- Purchase order tracking
- Stock movement history (IN/OUT transactions)
- Reorder level alerts
- Expiring batch reports

## Database Schema

The database consists of 6 tables:

| Table | Description |
|-------|-------------|
| `suppliers` | Pharmaceutical suppliers/manufacturers |
| `products` | Medicines and drugs with pricing |
| `warehouses` | Storage facilities |
| `batches` | Product batches with expiry tracking |
| `purchase_orders` | Orders placed with suppliers |
| `inventory_movements` | Stock transactions (IN/OUT) |

### ER Diagram

<img width="2550" height="3300" alt="er_diagram (2)" src="https://github.com/user-attachments/assets/f22320dd-2483-4cea-ba2f-d36b55da9c66" />



### Relationships

```
suppliers ──(1:N)──> products
suppliers ──(1:N)──> purchase_orders
products  ──(1:N)──> batches
batches   ──(1:N)──> inventory_movements
warehouses──(1:N)──> inventory_movements
```

## Project Files

```
├── documentation/
│   └── project_documentation.docx    # Full project documentation
├── diagrams/
│   └── er_diagram.pdf                # Entity-Relationship Diagram
├── sql/
│   ├── pharma_inventory_v1_progress.sql    # Version 1: 4 tables, basic query
│   ├── pharma_inventory_v2_progress.sql    # Version 2: 6 tables, 4 queries
│   └── pharmaceutical_inventory_system.sql # Final: complete system
```

## Installation

1. Install PostgreSQL
2. Create a new database:
   ```sql
   CREATE DATABASE pharma_inventory;
   ```
3. Connect to the database:
   ```bash
   psql -d pharma_inventory
   ```
4. Run the SQL script:
   ```bash
   \i sql/pharmaceutical_inventory_system.sql
   ```

## Sample Queries

### 1. Products with Supplier Info
```sql
SELECT p.product_name, p.category, p.unit_price, s.supplier_name
FROM products p
JOIN suppliers s ON p.supplier_id = s.supplier_id;
```

### 2. Current Inventory by Warehouse
```sql
SELECT w.warehouse_name, p.product_name,
       SUM(CASE WHEN im.movement_type = 'IN' THEN im.quantity ELSE -im.quantity END) AS current_stock
FROM inventory_movements im
JOIN batches b ON im.batch_id = b.batch_id
JOIN products p ON b.product_id = p.product_id
JOIN warehouses w ON im.warehouse_id = w.warehouse_id
GROUP BY w.warehouse_name, p.product_name;
```

### 3. Expiring Batches (Next 6 Months)
```sql
SELECT b.batch_number, p.product_name, b.expiry_date
FROM batches b
JOIN products p ON b.product_id = p.product_id
WHERE b.expiry_date <= CURRENT_DATE + INTERVAL '6 months'
ORDER BY b.expiry_date;
```

## Queries Included

| # | Query | SQL Concepts |
|---|-------|--------------|
| 1 | Product Catalog | INNER JOIN |
| 2 | Current Inventory | Multiple JOINs, CASE WHEN, SUM |
| 3 | Expiring Batches | DATE filtering, INTERVAL |
| 4 | Supplier Order History | LEFT JOIN, COUNT, AVG, GROUP BY |
| 5 | Reorder Alerts | Subquery, COALESCE |
| 6 | Warehouse Utilization | Calculated fields, ROUND |
| 7 | Monthly Movement Summary | TO_CHAR, GROUP BY |

## Constraints

- `PRIMARY KEY` on all ID columns (auto-incrementing)
- `FOREIGN KEY` constraints for referential integrity
- `UNIQUE` constraint on batch_number
- `NOT NULL` on required fields
- `CHECK` constraint: expiry_date > manufacture_date
- `CHECK` constraint: status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled')
- `CHECK` constraint: movement_type IN ('IN', 'OUT')

## Technologies

- PostgreSQL
- SQL (DDL, DML, JOINs, Aggregations, Subqueries)

## DEMO VIDEO
https://drive.google.com/file/d/1q5Y_pH4BA7vhDCAf8DiJ-9fWCkATARpH/view?usp=drive_link

## Peer Feedback:
https://drive.google.com/file/d/15ZKpdSlsuS2KUWNeIQXAQAoRCaXY03MN/view?usp=drive_link

## License

This project is for educational purposes.
