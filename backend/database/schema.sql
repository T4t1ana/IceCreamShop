DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS customs_ice_cream_toppings CASCADE;
DROP TABLE IF EXISTS customs_ice_cream_flavors CASCADE;
DROP TABLE IF EXISTS customs_ice_creams CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS branches CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS roles CASCADE;

CREATE TYPE container_type_enum AS ENUM('cone', 'cup');

CREATE TYPE order_status_enum AS ENUM(
    'pending_pay',
    'paid',
    'in_preparation',
    'ready_for_pickup',
    'completed',
    'cancelled'
);

CREATE TYPE payment_status_enum AS ENUM('pending', 'completed', 'failed');

--TABLES
CREATE TABLE roles(
    id SERIAL PRIMARY KEY,
    name VARCHAR(30) UNIQUE NOT NULL
);

CREATE TABLE users(
    id SERIAL PRIMARY KEY,
    role_id INT NOT NULL DEFAULT 3,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(120) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(25),
    is_verified BOOLEAN DEFAULT FALSE,
    verification_token VARCHAR(255),
    reset_password_token VARCHAR(255),
    reset_password_expires TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_user_role FOREING KEY(role_id)
        REFERENCES role(id) ON DELETE RESTRICT
);

CREATE TABLE branches(
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    adress TEXT NOT NULL,
    phone VARCHAR(50),
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE categories(
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description VARCHAR TEXT 
);

CREATE TABLE products(
    id SERIAL PRIMARY KEY,
    category_id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    description TEXT,
    price NUMERIC(10,2) NOT NULL CHECK (price >=0),
    image_url TEXT,
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_product_category FOREING KEY (category_id)
        REFERENCES categories(id) ON DELETE RESTRICT
)

CREATE TABLE customs_ice_creams(
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    container_type container_type_enum NOT NULL,
    scoop_count INT NOT NULL CHECK(scoop_count>0 AND scoop_count<=5),
    total_price NUMERIC(10,2) NOT NULL CHECK (total_price>=0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_custom_user FOREING KEY (user_id)
        REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE customs_ice_cream_flavors(
    id SERIAL PRIMARY KEY,
    customs_ice_cream_id INT NOT NULL,
    product_id INT NOT NULL,
    CONSTRAINT fk_cicf_custom FOREING KEY (customs_ice_cream_id)
        REFERENCES customs_ice_creams(id) ON DELETE CASCADE,
    CONSTRAINT fk_cicf_products FOREING KEY (product_id)
        REFERENCES products(id) ON DELETE CASCADE RESTRICT 
);

CREATE TABLE customs_ice_cream_toppings(
    id SERIAL PRIMARY KEY,
    customs_ice_cream_id INT NOT NULL,
    product_id INT NOT NULL,
    CONSTRAINT fk_cict_custom FOREING KEY (customs_ice_cream_id)
        REFERENCES customs_ice_creams(id) ON DELETE CASCADE,
    CONSTRAINT fk_cict_products FOREING KEY (product_id)
        REFERENCES products(id) ON DELETE CASCADE RESTRICT
);


CREATE TABLE orders(
    id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    branch_id INT NOT NULL,
    scheduled_pickup_time TIMESTAMP NOT NULL,
    total_amount NUMERIC(10,2) NOT NULL CHECK (>=0),
    payment_status payment_status_enum DEFAULT 'pending',
    order_status order_status_enum DEFAULT 'pending_payment',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_order_customer FOREING KEY (customer_id)
        REFERENCES users(id) ON DELETE RESTRICT,
    CONSTRAINT fk_order_branch FOREING KEY (branch_id) 
        REFERENCES branches(id) ON DELETE RESTRICT
);

CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NULL,           -- NULL if it's a custom ice cream
    custom_ice_cream_id INT NULL,  -- NULL if it's a standard product
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(10, 2) NOT NULL CHECK (unit_price >= 0),
    subtotal NUMERIC(10, 2) NOT NULL CHECK (subtotal >= 0),
    CONSTRAINT fk_item_order FOREIGN KEY (order_id) 
        REFERENCES orders(id) ON DELETE CASCADE,
    CONSTRAINT fk_item_product FOREIGN KEY (product_id) 
        REFERENCES products(id) ON DELETE RESTRICT,
    CONSTRAINT fk_item_custom FOREIGN KEY (custom_ice_cream_id) 
        REFERENCES custom_ice_creams(id) ON DELETE CASCADE,
    -- Guarantee that item is either a product OR a custom ice cream, not both or neither
    CONSTRAINT chk_item_type CHECK (
        (product_id IS NOT NULL AND custom_ice_cream_id IS NULL) OR
        (product_id IS NULL AND custom_ice_cream_id IS NOT NULL)
    )
);


CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_products_category ON products(categorie_id);
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_branch ON orders(branch_id);
CREATE INDEX idx_orders_status ON orders(order_status);