-- Assign a customer ID when customer enters site
	-- Have to make a dummy address ID and dummy cardnum to add a customer ID because the customer info table uses them as foreign keys
	-- address ID = 0
	-- cardnum = 0
	INSERT INTO customer_info (cust_id, cust_name, cust_email, cardnum, address_id)
	SELECT CONCAT('C', MAX(CAST(SUBSTRING_INDEX(cust_id,'C',-1) AS UNSIGNED)) + 1),'','','0','0' 
	FROM customer_info 
	ORDER BY LENGTH (cust_id), cust_id;
	
-- Delete a customer ID if customer leaves site or logs in as an employee 	
-- Assumption is the customerID in the current session is the most recent customer ID added to the table
	
	DELETE FROM customer_info WHERE cust_id = (SELECT cust_id FROM (SELECT cust_id
	FROM  customer_info
	ORDER BY CAST(SUBSTRING(cust_id,LOCATE('C',cust_id)+1) AS UNSIGNED) DESC LIMIT 1) AS derived);
		
-- Retrieve availible essential oils and colour schemes respectively
	SELECT essential_oil_name
	FROM essential_oils_stock
	WHERE essential_oil_stock > 0;
		
	SELECT colour_scheme_name
	FROM colour_scheme
	WHERE colour_scheme_stock > 0;
		
-- Update stock in tables when bathbomb items are selected and added to cart
	UPDATE essential_oils_stock
	SET essential_oil_stock = essential_oil_stock - 1
	WHERE essential_oil_name = (SELECT essential_oil_name
							FROM bb_specs
							WHERE cust_id = (SELECT cust_id
	FROM  customer_info
	ORDER BY CAST(SUBSTRING(cust_id,LOCATE('C',cust_id)+1) AS UNSIGNED) DESC LIMIT 1));
		
	UPDATE colour_scheme
	SET colour_scheme_stock = colour_scheme_stock - 1
	WHERE colour_scheme_name = (SELECT colour_scheme_name
							FROM bb_specs
							WHERE cust_id = (SELECT cust_id
	FROM  customer_info
	ORDER BY CAST(SUBSTRING(cust_id,LOCATE('C',cust_id)+1) AS UNSIGNED) DESC LIMIT 1));
		
-- Update stock in tables when bathbomb items are in cart but the cart is abandoned or the items returned from cart 
	UPDATE essential_oils_stock
	SET essential_oil_stock = essential_oil_stock + 1
	WHERE essential_oil_name = (SELECT essential_oil_name
							FROM bb_specs
							WHERE cust_id = (SELECT cust_id
	FROM  customer_info
	ORDER BY CAST(SUBSTRING(cust_id,LOCATE('C',cust_id)+1) AS UNSIGNED) DESC LIMIT 1));
		
	UPDATE colour_scheme
	SET colour_scheme_stock = colour_scheme_stock + 1
	WHERE colour_scheme_name = (SELECT colour_scheme_name
							FROM bb_specs
							WHERE cust_id = (SELECT cust_id
	FROM  customer_info
	ORDER BY CAST(SUBSTRING(cust_id,LOCATE('C',cust_id)+1) AS UNSIGNED) DESC LIMIT 1));
		
-- Update stock in product table when product added to cart
	UPDATE products
	SET product_stock = product_stock - 1
	WHERE product_id = (SELECT product_id
						FROM products_selected
						WHERE cust_id = (SELECT cust_id
	FROM  customer_info
	ORDER BY CAST(SUBSTRING(cust_id,LOCATE('C',cust_id)+1) AS UNSIGNED) DESC LIMIT 1));
		
-- Update stock in product table when cart abandoned or product removed from cart
	UPDATE products
	SET product_stock = product_stock + 1
	WHERE product_id = (SELECT product_id
						FROM products_selected
						WHERE cust_id = (SELECT cust_id
	FROM  customer_info
	ORDER BY CAST(SUBSTRING(cust_id,LOCATE('C',cust_id)+1) AS UNSIGNED) DESC LIMIT 1));
		
-- Retrieve matching shade of image uploaded
	SELECT lush_shade_name 
	FROM skin_shade_match match, customer_skin_shade customer
	WHERE match.skin_shade_hex = customer.skind_shade_hex;

-- Retrieve closely matching shades of image uploaded
	SELECT lush_shade_name, shade_group
	FROM range_group, skin_shade_match match, customer_skin_shade customer
	WHERE (match.skin_shade_hex > customer.skin_shade_hex AND match.skin_shade_hex < customer.skin_shade_hex + 10)
	OR (match.skin_shade_hex < customer.skin_shade_hex AND match.skin_shade_hex > customer.skin_shade_hex - 10)
	AND match.lush_shade_name = range_group.lush_shade_name;

-- Retrieve products suggested for shade


-- Check if employee login value entered matches value in employee table
	SELECT COUNT(employee_id)
	FROM employee_login
	WHERE employee.id = <employee ID entered by user>
	AND password = <password entered by user>

-- Update address info when customer is about to make a purchase	
	-- Make new address id
	INSERT INTO address (address_id)
	SELECT CONCAT('A', MAX(CAST(SUBSTRING_INDEX(address_id,'A',-1) AS UNSIGNED)) + 1)
	FROM customer_info 
	ORDER BY LENGTH (address_id), address_id;
	-- Map address ID of current customer to new addressID added
	UPDATE customer_info
	SET address_id = (SELECT address_id
	FROM  address
	ORDER BY CAST(SUBSTRING(address_id,LOCATE('A',address_id)+1) AS UNSIGNED) DESC LIMIT 1))
	WHERE cust_id = (SELECT cust_id
	FROM  customer_info
	ORDER BY CAST(SUBSTRING(cust_id,LOCATE('C',cust_id)+1) AS UNSIGNED) DESC LIMIT 1));
	-- Update address with rest of details
	UPDATE customer_info
	SET city = <city entered by user>, province = <province entered by user>, address_line_1 = <value entered by user>, address_line_2 = <value entered by user>, country = <country entered by user>, postal_code = <postal code entered by user>
	-- Delete New Address ID if cart is abandoned while checking out; First, must delete customer, then address
	DELETE FROM customer_info WHERE cust_id = (SELECT cust_id FROM (SELECT cust_id
	FROM  customer_info
	ORDER BY CAST(SUBSTRING(cust_id,LOCATE('C',cust_id)+1) AS UNSIGNED) DESC LIMIT 1) AS derived);
	
	DELETE FROM address WHERE address_id = (SELECT address_id FROM (SELECT address_id
	FROM  address
	ORDER BY CAST(SUBSTRING(address_id,LOCATE('A',address_id)+1) AS UNSIGNED) DESC LIMIT 1) AS derived);
	
-- Update credit card info when customer makes a purchase
	UPDATE customer_info 
	SET cardnum = <value entered by user>
	WHERE cust_id = (SELECT cust_id
	FROM  customer_info
	ORDER BY CAST(SUBSTRING(cust_id,LOCATE('C',cust_id)+1) AS UNSIGNED) DESC LIMIT 1));
	
-- ADD PO when order is placed
	INSERT INTO purchase_order (cust_id, po_status, order_date)
	VALUES (<corresponding values entered by user>)
	
-- Show all PO's to employee
	SELECT cust_id, po_status, order_date
	FROM purchase_order;
	
-- Show all open PO's to employee
	SELECT cust_id, po_status, order_date
	FROM purchase_order
	WHERE po_status = 'OPEN';

-- Show all closed PO's to employee
	SELECT cust_id, po_status, order_date
	FROM purchase_order
	WHERE po_status = 'CLOSED';
	
-- Employee update stock -- update product, colour_scheme, 
	UPDATE products
	SET product_stock = product_stock + <value entered by employee>
	WHERE product_id = <product_id entered by employee>
	
	UPDATE colour_schememe
	SET colour_scheme_stock = colour_scheme_stock + <value entered by employee>
	WHERE colour_scheme_name = <colour scheme name entered by employee>
	
	UPDATE essential_oils_stock
	SET essential_oil_stock = essential_oil_stock + <value entered by employee>
	WHERE essential_oil_name = <essential oil name entered by employee>
	
	