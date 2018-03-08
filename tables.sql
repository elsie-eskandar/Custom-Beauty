DROP TABLE IF EXISTS shape_molds;
DROP TABLE IF EXISTS colour_scheme;
DROP TABLE IF EXISTS essential_oils_stock;
DROP TABLE IF EXISTS employee_login;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS credit_card_info;
DROP TABLE IF EXISTS address;
DROP TABLE IF EXISTS customer_info;
DROP TABLE IF EXISTS products_selected;
DROP TABLE IF EXISTS bb_specs;
DROP TABLE IF EXISTS purchase_order;
DROP TABLE IF EXISTS shade_range_group;
DROP TABLE IF EXISTS skin_shade_match;
DROP TABLE IF EXISTS customer_skin_shade;

CREATE TABLE shape_molds (
shape VARCHAR (50) PRIMARY KEY,
size VARCHAR (50) PRIMARY KEY);

CREATE TABLE colour_scheme (
colour_scheme_name VARCHAR (50) PRIMARY KEY,
colour_scheme_stock INT NOT NULL);

CREATE TABLE essential_oils_stock (
essential_oil_name VARCHAR (50) PRIMARY KEY,
essential_oil_stock INT NOT NULL);

CREATE TABLE employee_login (
employee_id VARCHAR (50) PRIMARY KEY,
password VARCHAR (256) NOT NULL ); -- password has a large field size for encryption using sha2

CREATE TABLE products (
product_id VARCHAR (20) PRIMARY KEY,
product_category VARCHAR (50) NOT NULL,
product_name VARCHAR (50 NOT NULL

CREATE TABLE credit_card_info (
cardnum VARCHAR (20) PRIMARY KEY,
cardname VARCHAR (50) NOT NULL,
cvc VARCHAR (256) NOT NULL, -- cvc has a large field size for encryption using sha2
expiry_date DATE) NOT NULL;

CREATE TABLE address (
address_id VARCHAR (20) PRIMARY KEY,
city VARCHAR (50) NOT NULL,
province VARCHAR (50 )NOT NULL,
address_line_1 VARCHAR (50) NOT NULL,
address_line_2 VARCHAR (50) NOT NULL,
country VARCHAR (50) NOT NULL,
postal_code VARCHAR (10) NOT NULL);

CREATE TABLE customer_info (
cust_id VARCHAR (20) PRIMARY KEY,
cust_name VARCHAR (50) NOT NULL,
cust_email VARCHAR (50) NOT NULL,
cardnum VARCHAR (100) NOT NULL,
address_id VARCHAR (20) NOT NULL,
FOREIGN KEY (cardnum) REFERENCES credit_card_info (cardnum),
FOREIGN KEY (address_id) REFERENCES address (address_id));

CREATE TABLE products_selected (
cust_id VARCHAR (20) PRIMARY KEY,
product_id VARCHAR (20) PRIMARY KEY,
quantity INT NOT NULL,
FOREIGN KEY (cust_id) REFERENCES customer_info (cust_id),
FOREIGN KEY (product_id) REFERENCES products (product_id) 
);

CREATE TABLE bb_specs (
bb_num VARCHAR (20) PRIMARY KEY,
cust_id VARCHAR (20) PRIMARY KEY,
shape VARCHAR (50) NOT NULL,
size VARCHAR (50) NOT NULL,
colour_scheme_name VARCHAR (50) NOT NULL,
essential_oil VARCHAR (50) NOT NULL,
FOREIGN KEY (cust_id) REFERENCES customer_info (cust_id),
FOREIGN KEY (shape) REFERENCES shape_molds (shape)
FOREIGN KEY (size) REFERENCES shape_molds (size)
FOREIGN KEY (colour_scheme_name) REFERENCES colour_scheme (colour_scheme_name),
FOREIGN KEY (essential_oil) REFERENCES essential_oils_stock (essential_oil));

CREATE TABLE purchase_order (
cust_id VARCHAR(20) PRIMARY KEY,
PO_status VARCHAR (20) NOT NULL,
order_date DATE NOT NULL,
FOREIGN KEY (cust_id) REFERENCES customer_info (cust_id));

CREATE TABLE shade_range_group(
lush_shade_name VARCHAR(20) PRIMARY KEY,
shade_group VARCHAR (50) NOT NULL);

CREATE TABLE skin_shade_match (
skin_shade_hex INT PRIMARY KEY,
lush_shade_name VARCHAR (50) NOT NULL,
FOREIGN KEY (lush_shade_name) REFERENCES shade_range_group(lush_shade_name));

CREATE TABLE customer_skin_shade(
skin_shade_hex INT PRIMARY KEY,
cust_id VARCHAR (20) PRIMARY KEY,
FOREIGN KEY (skin_shade_hex) REFERENCES skin_shade_match(skin_shade_hex),
FOREIGN KEY (cust_id) REFERENCES customer_info(cust_id));