-- =======================================================
-- Phegon Bank - Local MySQL Initialization Script
-- =======================================================
-- Run this script using MySQL Command Line or MySQL Workbench:
-- mysql -u root -p < init-local-db.sql

CREATE DATABASE IF NOT EXISTS bank;
USE bank;

-- Roles table
CREATE TABLE IF NOT EXISTS roles (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE
);

-- Pre-seed default roles if not present
INSERT IGNORE INTO roles (id, name) VALUES (1, 'ADMIN'), (2, 'CUSTOMER'), (3, 'AUDITOR');

-- Users table
CREATE TABLE IF NOT EXISTS users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    phone_number VARCHAR(255),
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    profile_picture_url VARCHAR(255),
    active BOOLEAN DEFAULT TRUE,
    created_at DATETIME(6),
    updated_at DATETIME(6)
);

-- Users-Roles relationship table
CREATE TABLE IF NOT EXISTS users_roles (
    user_id BIGINT NOT NULL,
    role_id BIGINT NOT NULL,
    PRIMARY KEY (user_id, role_id),
    CONSTRAINT fk_users_roles_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_users_roles_role FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE
);

-- Accounts table
CREATE TABLE IF NOT EXISTS accounts (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    account_number VARCHAR(255) NOT NULL UNIQUE,
    balance DECIMAL(38, 2) NOT NULL,
    account_type VARCHAR(255) NOT NULL,
    status VARCHAR(255) NOT NULL,
    currency VARCHAR(255) NOT NULL,
    created_at DATETIME(6),
    update_at DATETIME(6),
    close_at DATETIME(6),
    user_id BIGINT,
    CONSTRAINT fk_accounts_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Transactions table
CREATE TABLE IF NOT EXISTS transactions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    amount DECIMAL(38, 2) NOT NULL,
    transaction_type VARCHAR(255) NOT NULL,
    status VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    source_account VARCHAR(255),
    destination_account VARCHAR(255),
    transaction_date DATETIME(6),
    account_id BIGINT,
    CONSTRAINT fk_transactions_account FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE
);

-- Password reset code table
CREATE TABLE IF NOT EXISTS password_reset_code (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(255) NOT NULL UNIQUE,
    expiry_date DATETIME(6) NOT NULL,
    used BOOLEAN DEFAULT FALSE,
    user_id BIGINT NOT NULL,
    CONSTRAINT fk_reset_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Notifications table
CREATE TABLE IF NOT EXISTS notification (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    subject VARCHAR(255),
    recipient VARCHAR(255),
    body TEXT,
    type VARCHAR(255),
    created_at DATETIME(6),
    user_id BIGINT,
    CONSTRAINT fk_notifications_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
