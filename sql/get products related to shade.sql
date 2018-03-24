-- get different products that are assoicated with a shade name
-- get lipstick products in shade group associated with given lush shade name
	SELECT product_name
	FROM products 
	WHERE product_category = 'LIPSTICK'
    AND shade_group_reccommendation = (SELECT shade_group FROM shade_range_group WHERE lush_shade_name = <given shade name>);
	

-- get foundation products in shade group associated with given lush shade name
	SELECT product_name, shade_group_reccommendation
	FROM products 
	WHERE product_category = 'FOUNDATION'
    AND shade_group_reccommendation = (SELECT shade_group FROM shade_range_group WHERE lush_shade_name = <given shade name>);

-- get palettes products in shade group associated with given lush shade name
	SELECT product_name
	FROM products 
	WHERE product_category = 'PALETTES'
    AND shade_group_reccommendation = (SELECT shade_group FROM shade_range_group WHERE lush_shade_name = <given shade name>);

-- get blush products in shade group associated with given lush shade name
	SELECT product_name
	FROM products 
	WHERE product_category = 'BLUSH'
    AND shade_group_reccommendation = (SELECT shade_group FROM shade_range_group WHERE lush_shade_name = <given shade name>);
	