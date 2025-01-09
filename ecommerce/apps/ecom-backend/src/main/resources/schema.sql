-- Create sequences
CREATE SEQUENCE user_sequence START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE product_category_sequence START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE product_sequence START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE product_picture_sequence START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE order_sequence START WITH 1 INCREMENT BY 1;

-- Create ecommerce_user table
CREATE TABLE ecommerce_user (
    id BIGINT PRIMARY KEY,
    public_id UUID NOT NULL UNIQUE,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(255) UNIQUE,
    address_street VARCHAR(255),
    address_zip_code VARCHAR(255),
    address_city VARCHAR(255),
    address_country VARCHAR(255),
    image_url VARCHAR(256),
    last_seen TIMESTAMP NOT NULL,
    created_date TIMESTAMP,
    last_modified_date TIMESTAMP
);

-- Create authority table
CREATE TABLE authority (
    name VARCHAR(50) PRIMARY KEY
);

-- Create user_authority table
CREATE TABLE user_authority (
    user_id BIGINT NOT NULL,
    authority_name VARCHAR(50) NOT NULL,
    PRIMARY KEY (user_id, authority_name),
    CONSTRAINT fk_authority_name FOREIGN KEY (authority_name) REFERENCES authority(name),
    CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES ecommerce_user(id)
);

-- Load initial authority data
INSERT INTO authority (name) VALUES ('ROLE_ADMIN');
INSERT INTO authority (name) VALUES ('ROLE_USER');

-- Create product_category table
CREATE TABLE product_category (
    id BIGINT PRIMARY KEY,
    public_id UUID NOT NULL UNIQUE,
    name VARCHAR(256) NOT NULL,
    created_date TIMESTAMP,
    last_modified_date TIMESTAMP
);

-- Create product table
CREATE TABLE product (
    id BIGINT PRIMARY KEY,
    public_id UUID NOT NULL UNIQUE,
    name VARCHAR(256) NOT NULL,
    price FLOAT,
    size VARCHAR(256),
    color VARCHAR(256),
    brand VARCHAR(256),
    description VARCHAR(2000),
    featured BOOLEAN,
    nb_in_stock INT,
    created_date TIMESTAMP,
    last_modified_date TIMESTAMP,
    category_fk BIGINT,
    CONSTRAINT fk_category_product_constraint FOREIGN KEY (category_fk) REFERENCES product_category(id)
);

-- Create product_picture table
CREATE TABLE product_picture (
    id BIGINT PRIMARY KEY,
    file BLOB NOT NULL,
    file_content_type VARCHAR(255) NOT NULL,
    created_date TIMESTAMP,
    last_modified_date TIMESTAMP,
    product_fk BIGINT NOT NULL,
    CONSTRAINT fk_product_picture_constraint FOREIGN KEY (product_fk) REFERENCES product(id) ON DELETE CASCADE
);

-- Create order table
CREATE TABLE `order` (
    id BIGINT PRIMARY KEY,
    public_id UUID NOT NULL UNIQUE,
    status VARCHAR(256) NOT NULL,
    fk_customer BIGINT NOT NULL,
    stripe_session_id VARCHAR(256) NOT NULL,
    created_date TIMESTAMP,
    last_modified_date TIMESTAMP,
    CONSTRAINT fk_user_order_id FOREIGN KEY (fk_customer) REFERENCES ecommerce_user(id)
);

-- Create ordered_product table
CREATE TABLE ordered_product (
    fk_order BIGINT NOT NULL,
    fk_product UUID NOT NULL,
    quantity BIGINT NOT NULL,
    price FLOAT NOT NULL,
    product_name VARCHAR(256) NOT NULL,
    PRIMARY KEY (fk_order, fk_product),
    CONSTRAINT fk_ordered_product_constraint FOREIGN KEY (fk_product) REFERENCES product(public_id),
    CONSTRAINT fk_ordered_order_constraint FOREIGN KEY (fk_order) REFERENCES `order`(id)
);