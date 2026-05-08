-- ============================================================
-- PHARMACEUTICAL INVENTORY AND SUPPLY CHAIN MANAGEMENT SYSTEM
-- Database: PostgreSQL
-- Author: Drac (AUCA Database Course)
-- ============================================================

-- ============================================================
-- SECTION 1: TABLE CREATION (Schema Definition)
-- ============================================================

-- Drop tables if they exist (for clean re-runs)
DROP TABLE IF EXISTS inventory_movements CASCADE;
DROP TABLE IF EXISTS purchase_orders CASCADE;
DROP TABLE IF EXISTS batches CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS warehouses CASCADE;
DROP TABLE IF EXISTS suppliers CASCADE;

-- 1. SUPPLIERS TABLE
-- Stores information about pharmaceutical suppliers/manufacturers
CREATE TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    contact_person VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    address TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- 2. PRODUCTS TABLE
-- Stores pharmaceutical product information
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    generic_name VARCHAR(150),
    category VARCHAR(50),
    unit_price DECIMAL(10,2) NOT NULL,
    reorder_level INTEGER DEFAULT 50,
    supplier_id INTEGER REFERENCES suppliers(supplier_id) ON DELETE SET NULL
);

-- 3. WAREHOUSES TABLE
-- Stores warehouse/storage facility information
CREATE TABLE warehouses (
    warehouse_id SERIAL PRIMARY KEY,
    warehouse_name VARCHAR(100) NOT NULL,
    location VARCHAR(150),
    capacity INTEGER,
    manager_name VARCHAR(100)
);

-- 4. BATCHES TABLE
-- Tracks individual product batches with expiry dates
CREATE TABLE batches (
    batch_id SERIAL PRIMARY KEY,
    batch_number VARCHAR(50) UNIQUE NOT NULL,
    product_id INTEGER REFERENCES products(product_id) ON DELETE CASCADE,
    manufacture_date DATE NOT NULL,
    expiry_date DATE NOT NULL,
    quantity_received INTEGER NOT NULL,
    CONSTRAINT valid_dates CHECK (expiry_date > manufacture_date)
);

-- 5. PURCHASE_ORDERS TABLE
-- Tracks orders placed with suppliers
CREATE TABLE purchase_orders (
    order_id SERIAL PRIMARY KEY,
    supplier_id INTEGER REFERENCES suppliers(supplier_id) ON DELETE SET NULL,
    order_date DATE DEFAULT CURRENT_DATE,
    expected_delivery DATE,
    status VARCHAR(20) DEFAULT 'Pending' 
        CHECK (status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled')),
    total_amount DECIMAL(12,2)
);

-- 6. INVENTORY_MOVEMENTS TABLE
-- Tracks all inventory transactions (stock in/out)
CREATE TABLE inventory_movements (
    movement_id SERIAL PRIMARY KEY,
    batch_id INTEGER REFERENCES batches(batch_id) ON DELETE CASCADE,
    warehouse_id INTEGER REFERENCES warehouses(warehouse_id) ON DELETE CASCADE,
    movement_type VARCHAR(10) NOT NULL CHECK (movement_type IN ('IN', 'OUT')),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    movement_date TIMESTAMP DEFAULT NOW(),
    reference_note TEXT
);


-- ============================================================
-- SECTION 2: SAMPLE DATA (INSERT Statements)
-- ============================================================

-- Insert Suppliers (8 records)
INSERT INTO suppliers (supplier_name, contact_person, email, phone, address) VALUES
('PharmaCorp International', 'John Smith', 'jsmith@pharmacorp.com', '+1-555-0101', '123 Pharma Ave, New York, NY 10001'),
('MediSupply Ltd', 'Sarah Johnson', 'sarah.j@medisupply.com', '+1-555-0102', '456 Medical Blvd, Boston, MA 02101'),
('Global Generics Inc', 'Michael Chen', 'mchen@globalgenerics.com', '+1-555-0103', '789 Generic Way, Chicago, IL 60601'),
('BioHealth Solutions', 'Emma Williams', 'ewilliams@biohealth.com', '+1-555-0104', '321 Bio Park, San Francisco, CA 94102'),
('Alpine Pharmaceuticals', 'Hans Mueller', 'hmueller@alpinepharma.ch', '+41-22-555-0105', '45 Alpine Strasse, Zurich, Switzerland'),
('Eastern Medicines Co', 'Wei Zhang', 'wzhang@easternmed.cn', '+86-21-5550106', '888 Health Road, Shanghai, China'),
('Nordic Pharma AS', 'Erik Lindberg', 'erik@nordicpharma.no', '+47-555-0107', '12 Nordic Gate, Oslo, Norway'),
('Sunshine Generics', 'Priya Patel', 'ppatel@sunshinegen.in', '+91-22-5550108', '100 Pharma City, Mumbai, India');

-- Insert Warehouses (5 records)
INSERT INTO warehouses (warehouse_name, location, capacity, manager_name) VALUES
('Central Distribution Hub', 'Newark, NJ', 50000, 'Robert Taylor'),
('West Coast Facility', 'Los Angeles, CA', 35000, 'Maria Garcia'),
('Midwest Storage Center', 'Chicago, IL', 40000, 'James Wilson'),
('Southern Distribution', 'Houston, TX', 30000, 'Patricia Brown'),
('Cold Storage Facility', 'Denver, CO', 15000, 'David Lee');

-- Insert Products (10 records)
INSERT INTO products (product_name, generic_name, category, unit_price, reorder_level, supplier_id) VALUES
('Amoxicillin 500mg', 'Amoxicillin', 'Antibiotic', 0.45, 100, 1),
('Lisinopril 10mg', 'Lisinopril', 'Cardiovascular', 0.25, 80, 2),
('Metformin 850mg', 'Metformin Hydrochloride', 'Antidiabetic', 0.15, 120, 3),
('Omeprazole 20mg', 'Omeprazole', 'Gastrointestinal', 0.35, 90, 1),
('Atorvastatin 20mg', 'Atorvastatin Calcium', 'Cholesterol', 0.55, 75, 4),
('Ibuprofen 400mg', 'Ibuprofen', 'Painkiller', 0.12, 150, 3),
('Cetirizine 10mg', 'Cetirizine Hydrochloride', 'Antihistamine', 0.18, 100, 5),
('Salbutamol Inhaler', 'Salbutamol Sulfate', 'Respiratory', 8.50, 40, 4),
('Insulin Glargine', 'Insulin Glargine', 'Antidiabetic', 45.00, 30, 6),
('Paracetamol 500mg', 'Acetaminophen', 'Painkiller', 0.08, 200, 8);

-- Insert Batches (10 records)
INSERT INTO batches (batch_number, product_id, manufacture_date, expiry_date, quantity_received) VALUES
('BTH-2024-0001', 1, '2024-01-15', '2026-01-15', 5000),
('BTH-2024-0002', 2, '2024-02-20', '2026-02-20', 3000),
('BTH-2024-0003', 3, '2024-03-10', '2026-03-10', 8000),
('BTH-2024-0004', 4, '2024-01-25', '2025-07-25', 4000),
('BTH-2024-0005', 5, '2024-04-05', '2026-04-05', 2500),
('BTH-2024-0006', 6, '2024-05-12', '2026-05-12', 10000),
('BTH-2024-0007', 7, '2024-02-28', '2025-08-28', 6000),
('BTH-2024-0008', 8, '2024-03-20', '2025-09-20', 500),
('BTH-2024-0009', 9, '2024-04-18', '2025-04-18', 200),
('BTH-2024-0010', 10, '2024-06-01', '2026-06-01', 15000);

-- Insert Purchase Orders (8 records)
INSERT INTO purchase_orders (supplier_id, order_date, expected_delivery, status, total_amount) VALUES
(1, '2024-01-10', '2024-01-20', 'Delivered', 2250.00),
(2, '2024-02-15', '2024-02-25', 'Delivered', 750.00),
(3, '2024-03-05', '2024-03-15', 'Delivered', 2400.00),
(4, '2024-04-01', '2024-04-12', 'Delivered', 5625.00),
(5, '2024-05-10', '2024-05-22', 'Shipped', 1080.00),
(6, '2024-06-01', '2024-06-15', 'Pending', 9000.00),
(8, '2024-06-05', '2024-06-18', 'Pending', 1200.00),
(1, '2024-06-10', '2024-06-22', 'Pending', 1575.00);

-- Insert Inventory Movements (15 records)
INSERT INTO inventory_movements (batch_id, warehouse_id, movement_type, quantity, movement_date, reference_note) VALUES
(1, 1, 'IN', 5000, '2024-01-20 09:00:00', 'Initial stock from PO#1'),
(2, 1, 'IN', 3000, '2024-02-25 10:30:00', 'Initial stock from PO#2'),
(3, 2, 'IN', 8000, '2024-03-15 14:00:00', 'Initial stock from PO#3'),
(4, 1, 'IN', 4000, '2024-01-28 11:00:00', 'Initial stock received'),
(5, 3, 'IN', 2500, '2024-04-12 09:45:00', 'Initial stock from PO#4'),
(6, 2, 'IN', 10000, '2024-05-15 13:00:00', 'Initial stock received'),
(1, 1, 'OUT', 500, '2024-02-10 08:30:00', 'Shipment to pharmacy network'),
(2, 1, 'OUT', 200, '2024-03-05 16:00:00', 'Hospital order fulfillment'),
(3, 2, 'OUT', 1500, '2024-04-01 10:00:00', 'Distributor shipment'),
(4, 1, 'OUT', 800, '2024-03-15 14:30:00', 'Retail pharmacy order'),
(6, 2, 'OUT', 2000, '2024-06-01 09:00:00', 'Bulk order - regional'),
(7, 4, 'IN', 6000, '2024-03-02 11:00:00', 'Initial stock received'),
(8, 5, 'IN', 500, '2024-03-25 10:00:00', 'Cold storage - respiratory'),
(9, 5, 'IN', 200, '2024-04-20 08:00:00', 'Cold storage - insulin'),
(10, 3, 'IN', 15000, '2024-06-05 15:00:00', 'Bulk paracetamol stock');


-- ============================================================
-- SECTION 3: QUERIES (Joins, Aggregations, Reports)
-- ============================================================

-- QUERY 1: Product Catalog with Supplier Information
-- Shows all products with their supplier details (INNER JOIN)
SELECT 
    p.product_id,
    p.product_name,
    p.generic_name,
    p.category,
    p.unit_price,
    s.supplier_name,
    s.contact_person,
    s.phone
FROM products p
INNER JOIN suppliers s ON p.supplier_id = s.supplier_id
ORDER BY p.category, p.product_name;


-- QUERY 2: Current Inventory Levels by Warehouse
-- Calculates stock levels per product per warehouse (Multiple JOINs + Aggregation)
SELECT 
    w.warehouse_name,
    p.product_name,
    SUM(CASE WHEN im.movement_type = 'IN' THEN im.quantity ELSE 0 END) AS total_in,
    SUM(CASE WHEN im.movement_type = 'OUT' THEN im.quantity ELSE 0 END) AS total_out,
    SUM(CASE WHEN im.movement_type = 'IN' THEN im.quantity ELSE -im.quantity END) AS current_stock
FROM inventory_movements im
JOIN batches b ON im.batch_id = b.batch_id
JOIN products p ON b.product_id = p.product_id
JOIN warehouses w ON im.warehouse_id = w.warehouse_id
GROUP BY w.warehouse_name, p.product_name
ORDER BY w.warehouse_name, p.product_name;


-- QUERY 3: Expiring Batches Alert (Within 6 Months)
-- Identifies batches expiring soon for quality control (Date filtering + JOIN)
SELECT 
    b.batch_number,
    p.product_name,
    p.category,
    b.expiry_date,
    (b.expiry_date - CURRENT_DATE) AS days_until_expiry,
    b.quantity_received
FROM batches b
JOIN products p ON b.product_id = p.product_id
WHERE b.expiry_date <= CURRENT_DATE + INTERVAL '6 months'
ORDER BY b.expiry_date ASC;


-- QUERY 4: Supplier Order History Summary
-- Shows total orders and spending per supplier (Aggregation + GROUP BY)
SELECT 
    s.supplier_name,
    COUNT(po.order_id) AS total_orders,
    SUM(po.total_amount) AS total_spent,
    ROUND(AVG(po.total_amount), 2) AS avg_order_value,
    MAX(po.order_date) AS last_order_date
FROM suppliers s
LEFT JOIN purchase_orders po ON s.supplier_id = po.supplier_id
GROUP BY s.supplier_id, s.supplier_name
ORDER BY total_spent DESC NULLS LAST;


-- QUERY 5: Products Below Reorder Level
-- Identifies products that need restocking (Subquery + Aggregation)
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    p.reorder_level,
    COALESCE(inv.current_stock, 0) AS current_stock,
    p.reorder_level - COALESCE(inv.current_stock, 0) AS units_to_order,
    s.supplier_name
FROM products p
LEFT JOIN (
    SELECT 
        b.product_id,
        SUM(CASE WHEN im.movement_type = 'IN' THEN im.quantity ELSE -im.quantity END) AS current_stock
    FROM inventory_movements im
    JOIN batches b ON im.batch_id = b.batch_id
    GROUP BY b.product_id
) inv ON p.product_id = inv.product_id
JOIN suppliers s ON p.supplier_id = s.supplier_id
WHERE COALESCE(inv.current_stock, 0) < p.reorder_level
ORDER BY (p.reorder_level - COALESCE(inv.current_stock, 0)) DESC;


-- QUERY 6: Warehouse Utilization Report
-- Shows capacity usage per warehouse (Aggregation + Calculation)
SELECT 
    w.warehouse_name,
    w.location,
    w.capacity AS max_capacity,
    COALESCE(SUM(
        CASE WHEN im.movement_type = 'IN' THEN im.quantity ELSE -im.quantity END
    ), 0) AS current_units,
    ROUND(
        COALESCE(SUM(
            CASE WHEN im.movement_type = 'IN' THEN im.quantity ELSE -im.quantity END
        ), 0) * 100.0 / w.capacity, 
    2) AS utilization_percent,
    w.manager_name
FROM warehouses w
LEFT JOIN inventory_movements im ON w.warehouse_id = im.warehouse_id
GROUP BY w.warehouse_id, w.warehouse_name, w.location, w.capacity, w.manager_name
ORDER BY utilization_percent DESC;


-- QUERY 7: Monthly Inventory Movement Summary
-- Tracks inventory flow trends over time (Date functions + Aggregation)
SELECT 
    TO_CHAR(movement_date, 'YYYY-MM') AS month,
    movement_type,
    COUNT(*) AS transaction_count,
    SUM(quantity) AS total_units
FROM inventory_movements
GROUP BY TO_CHAR(movement_date, 'YYYY-MM'), movement_type
ORDER BY month, movement_type;


-- ============================================================
-- END OF SCRIPT
-- ============================================================
