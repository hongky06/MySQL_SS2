DROP DATABASE IF EXISTS VPBankEduPay;
CREATE DATABASE VPBankEduPay;
USE VPBankEduPay;

-- =========================
-- 1. CUSTOMER
-- =========================
CREATE TABLE Customer (
    customer_id VARCHAR(20) PRIMARY KEY,
    fullname VARCHAR(100) NOT NULL,
    cccd VARCHAR(20) NOT NULL UNIQUE,
    phone VARCHAR(15) NOT NULL UNIQUE,
    email VARCHAR(100)
);


-- =========================
-- 2. ACCOUNT
-- =========================
CREATE TABLE Account (
    account_no VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    balance DECIMAL(18,2) DEFAULT 0,
    
    CONSTRAINT chk_balance CHECK (balance >= 0),
    
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);


-- =========================
-- 3. PARTNER (Rikkei + mở rộng tương lai)
-- =========================
CREATE TABLE Partner (
    partner_id VARCHAR(20) PRIMARY KEY,
    partner_name VARCHAR(100) NOT NULL UNIQUE,
    tax_code VARCHAR(30) UNIQUE
);


-- =========================
-- 4. TUITION BILL (HÓA ĐƠN HỌC PHÍ)
-- =========================
CREATE TABLE TuitionBill (
    bill_id VARCHAR(30) PRIMARY KEY,
    partner_id VARCHAR(20) NOT NULL,
    student_code VARCHAR(30) NOT NULL,
    amount DECIMAL(18,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'UNPAID',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_amount CHECK (amount > 0),
    
    FOREIGN KEY (partner_id) REFERENCES Partner(partner_id)
);


-- =========================
-- 5. TRANSACTION (LỊCH SỬ THANH TOÁN)
-- =========================
CREATE TABLE BankTransaction (
    trans_id VARCHAR(30) PRIMARY KEY,
    account_no VARCHAR(20) NOT NULL,
    bill_id VARCHAR(30) NOT NULL,
    amount DECIMAL(18,2) NOT NULL,
    
    status VARCHAR(20) DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_trans_amount CHECK (amount > 0),

    FOREIGN KEY (account_no) REFERENCES Account(account_no),
    FOREIGN KEY (bill_id) REFERENCES TuitionBill(bill_id),

    -- Một hóa đơn chỉ được thanh toán thành công 1 lần
    UNIQUE (bill_id)
);
