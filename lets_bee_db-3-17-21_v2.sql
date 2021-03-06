toc.dat                                                                                             0000600 0004000 0002000 00000606034 14024343251 0014446 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        PGDMP       /        	            y            lets_bee     13.2 (Ubuntu 13.2-1.pgdg20.04+1)     13.2 (Ubuntu 13.2-1.pgdg20.04+1) ?    ?           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false         ?           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false         ?           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false         ?           1262    16384    lets_bee    DATABASE     Y   CREATE DATABASE lets_bee WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'C.UTF-8';
    DROP DATABASE lets_bee;
                postgres    false         ?           1247    19199    enum_carts_status    TYPE     l   CREATE TYPE public.enum_carts_status AS ENUM (
    'active',
    'ordered',
    'changed',
    'removed'
);
 $   DROP TYPE public.enum_carts_status;
       public          postgres    false                     1247    37840    enum_orders_contract_type    TYPE     e   CREATE TYPE public.enum_orders_contract_type AS ENUM (
    'commission',
    'markup',
    'half'
);
 ,   DROP TYPE public.enum_orders_contract_type;
       public          postgres    false                    1247    37823    enum_orders_status    TYPE     ?   CREATE TYPE public.enum_orders_status AS ENUM (
    'processing',
    'pending',
    'store-accepted',
    'store-declined',
    'rider-accepted',
    'rider-picked-up',
    'delivered',
    'cancelled'
);
 %   DROP TYPE public.enum_orders_status;
       public          postgres    false         5           1247    37927 %   enum_store_applications_business_type    TYPE     c   CREATE TYPE public.enum_store_applications_business_type AS ENUM (
    'mart',
    'restaurant'
);
 8   DROP TYPE public.enum_store_applications_business_type;
       public          postgres    false         8           1247    37932    enum_store_applications_status    TYPE     |   CREATE TYPE public.enum_store_applications_status AS ENUM (
    'approved',
    'pending',
    'rejected',
    'on-hold'
);
 1   DROP TYPE public.enum_store_applications_status;
       public          postgres    false                    1247    37731    enum_store_products_status    TYPE     r   CREATE TYPE public.enum_store_products_status AS ENUM (
    'available',
    'unavailable',
    'out-of-stock'
);
 -   DROP TYPE public.enum_store_products_status;
       public          postgres    false         ?           1247    37692    enum_stores_contract_type    TYPE     e   CREATE TYPE public.enum_stores_contract_type AS ENUM (
    'commission',
    'markup',
    'half'
);
 ,   DROP TYPE public.enum_stores_contract_type;
       public          postgres    false         ?           1247    37676    enum_stores_stature    TYPE     u   CREATE TYPE public.enum_stores_stature AS ENUM (
    'temporary-close',
    'closed',
    'suspended',
    'open'
);
 &   DROP TYPE public.enum_stores_stature;
       public          postgres    false         ?           1247    37668    enum_stores_status    TYPE     b   CREATE TYPE public.enum_stores_status AS ENUM (
    'active',
    'deactivated',
    'pending'
);
 %   DROP TYPE public.enum_stores_status;
       public          postgres    false         ?           1247    37686    enum_stores_type    TYPE     N   CREATE TYPE public.enum_stores_type AS ENUM (
    'restaurant',
    'mart'
);
 #   DROP TYPE public.enum_stores_type;
       public          postgres    false         ?           1247    37607    enum_users_provider    TYPE     k   CREATE TYPE public.enum_users_provider AS ENUM (
    'email',
    'facebook',
    'google',
    'kakao'
);
 &   DROP TYPE public.enum_users_provider;
       public          postgres    false         ?           1247    37616    enum_users_role    TYPE     {   CREATE TYPE public.enum_users_role AS ENUM (
    'customer',
    'partner',
    'rider',
    'admin',
    'super-admin'
);
 "   DROP TYPE public.enum_users_role;
       public          postgres    false         4           1255    38026 C   create_addon(integer, character varying, numeric, numeric, numeric)    FUNCTION     ?  CREATE FUNCTION public.create_addon(p_user_id integer, p_name character varying, p_price numeric, p_customer_price numeric, p_seller_price numeric) RETURNS TABLE(id integer, status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_addon_id INT := 0;
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Additional successfully created!';
BEGIN
  IF EXISTS (
    SELECT
      ao.id
    FROM public.additionals AS ao
    INNER JOIN public.stores AS s
      ON ao.store_id = s.id
    WHERE
      s.user_id = p_user_id
    AND
      ao.name = p_name
  ) THEN
    v_status := 'warning';
    v_message := CONCAT(p_name, ' already exists!');
    RETURN QUERY SELECT v_addon_id, v_status, v_message;
    RETURN;

  END IF;

  INSERT INTO public.additionals (
    store_id,
    "name",
    price,
    customer_price,
    seller_price,
    "status",
    "createdAt",
    "updatedAt"
  )
  SELECT
    s.id,
    p_name,
    p_price,
    p_customer_price,
    p_seller_price,
    true,
    now(),
    now()
  FROM public.stores AS s
  WHERE s.user_id = p_user_id
  RETURNING public.additionals.id INTO v_addon_id;

  RETURN QUERY
  SELECT v_addon_id, v_status, v_message;
END;
$$;
 ?   DROP FUNCTION public.create_addon(p_user_id integer, p_name character varying, p_price numeric, p_customer_price numeric, p_seller_price numeric);
       public          postgres    false                     1255    37974 ?  create_mart(character varying, character varying, character varying, character varying, character varying, character varying, numeric, numeric, character varying, public.enum_stores_contract_type, character varying, character varying, character varying, character varying, character varying, text, text, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone)    FUNCTION     K  CREATE FUNCTION public.create_mart(p_user_name character varying, p_email character varying, p_password character varying, p_cellphone_number character varying, p_store_name character varying, p_description character varying, p_latitude numeric, p_longitude numeric, p_location_name character varying, p_contract_type public.enum_stores_contract_type, p_category character varying, p_country character varying, p_state character varying, p_city character varying, p_barangay character varying, p_logo_url text, p_photo_url text, p_sunday boolean, p_sunday_opening_time time without time zone, p_sunday_closing_time time without time zone, p_monday boolean, p_monday_opening_time time without time zone, p_monday_closing_time time without time zone, p_tuesday boolean, p_tuesday_opening_time time without time zone, p_tuesday_closing_time time without time zone, p_wednesday boolean, p_wednesday_opening_time time without time zone, p_wednesday_closing_time time without time zone, p_thursday boolean, p_thursday_opening_time time without time zone, p_thursday_closing_time time without time zone, p_friday boolean, p_friday_opening_time time without time zone, p_friday_closing_time time without time zone, p_saturday boolean, p_saturday_opening_time time without time zone, p_saturday_closing_time time without time zone) RETURNS TABLE(mart_id integer, user_id integer, status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_mart_id INT := 0;
  v_user_id INT := 0;
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Mart successfully created!';
BEGIN
  IF EXISTS(SELECT 1 FROM public.users AS u WHERE u.email = p_email) THEN
    v_status := 'warning';
    v_message := 'The email address you entered for this mart already exists.';
    RETURN QUERY SELECT v_mart_id, v_user_id, v_status, v_message;
    RETURN;
  END IF;

  INSERT INTO public.users (name, email, password, role, cellphone_number, "createdAt", "updatedAt")
    VALUES (p_user_name, p_email, p_password, 'partner', p_cellphone_number, now(), now())
    RETURNING public.users.id INTO v_user_id;

  INSERT INTO public.stores (user_id, name, description, latitude, longitude, location_name, type, contract_type, category, country, state, city, barangay, logo_url, photo_url, sunday, sunday_opening_time, sunday_closing_time, monday, monday_opening_time, monday_closing_time, tuesday, tuesday_opening_time, tuesday_closing_time, wednesday, wednesday_opening_time, wednesday_closing_time, thursday, thursday_opening_time, thursday_closing_time, friday, friday_opening_time, friday_closing_time, saturday, saturday_opening_time, saturday_closing_time, "createdAt", "updatedAt")
    VALUES (v_user_id, p_store_name, p_description, p_latitude, p_longitude, p_location_name, 'mart', p_contract_type, p_category, p_country, p_state, p_city, p_barangay, p_logo_url, p_photo_url, p_sunday, p_sunday_opening_time, p_sunday_closing_time, p_monday, p_monday_opening_time, p_monday_closing_time, p_tuesday, p_tuesday_opening_time, p_tuesday_closing_time, p_wednesday, p_wednesday_opening_time, p_wednesday_closing_time, p_thursday, p_thursday_opening_time, p_thursday_closing_time, p_friday, p_friday_opening_time, p_friday_closing_time, p_saturday, p_saturday_opening_time, p_saturday_closing_time, now(), now());
  
  RETURN QUERY
    SELECT v_mart_id, v_user_id, v_status, v_message;
END;
$$;
 *  DROP FUNCTION public.create_mart(p_user_name character varying, p_email character varying, p_password character varying, p_cellphone_number character varying, p_store_name character varying, p_description character varying, p_latitude numeric, p_longitude numeric, p_location_name character varying, p_contract_type public.enum_stores_contract_type, p_category character varying, p_country character varying, p_state character varying, p_city character varying, p_barangay character varying, p_logo_url text, p_photo_url text, p_sunday boolean, p_sunday_opening_time time without time zone, p_sunday_closing_time time without time zone, p_monday boolean, p_monday_opening_time time without time zone, p_monday_closing_time time without time zone, p_tuesday boolean, p_tuesday_opening_time time without time zone, p_tuesday_closing_time time without time zone, p_wednesday boolean, p_wednesday_opening_time time without time zone, p_wednesday_closing_time time without time zone, p_thursday boolean, p_thursday_opening_time time without time zone, p_thursday_closing_time time without time zone, p_friday boolean, p_friday_opening_time time without time zone, p_friday_closing_time time without time zone, p_saturday boolean, p_saturday_opening_time time without time zone, p_saturday_closing_time time without time zone);
       public          postgres    false    754                    1255    37988    create_menu(integer, character varying, text, text, numeric, numeric, numeric, text, text, integer, integer, character varying)    FUNCTION     ?  CREATE FUNCTION public.create_menu(p_store_id integer, p_name character varying, p_description text, p_image text, p_price numeric, p_customer_price numeric, p_seller_price numeric, p_choices text, p_additionals text, p_quantity integer, p_max_order integer, p_category character varying) RETURNS TABLE(id integer, status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_menu_id INT := 0;
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Menu successfully created!';
BEGIN
  INSERT INTO public.store_products (
    store_id,
    name,
    description,
    image,
    price,
    customer_price,
    seller_price,
    choices,
    additionals,
    quantity,
    max_order,
    category,
    status,
    "createdAt",
    "updatedAt"
  ) VALUES (
    p_store_id,
    p_name,
    p_description,
    p_image,
    p_price,
    p_customer_price,
    p_seller_price,
    p_choices,
    p_additionals,
    p_quantity,
    p_max_order,
    p_category,
    'available',
    now(),
    now()
  ) RETURNING public.store_products.id INTO v_menu_id;

  RETURN QUERY
    SELECT v_menu_id, v_status, v_message;
END;
$$;
    DROP FUNCTION public.create_menu(p_store_id integer, p_name character varying, p_description text, p_image text, p_price numeric, p_customer_price numeric, p_seller_price numeric, p_choices text, p_additionals text, p_quantity integer, p_max_order integer, p_category character varying);
       public          postgres    false         8           1255    38030 ?   create_order(integer, integer, public.enum_orders_status, text, text, text, text, public.enum_orders_contract_type, text, text, text)    FUNCTION     ?  CREATE FUNCTION public.create_order(p_store_id integer, p_user_id integer, p_status public.enum_orders_status, p_products text, p_fee text, p_address text, p_payment text, p_contract_type public.enum_orders_contract_type, p_note text DEFAULT ''::text, p_timeframe text DEFAULT NULL::text, p_reason text DEFAULT ''::text) RETURNS TABLE(order_id integer)
    LANGUAGE plpgsql
    AS $$ 
DECLARE
  v_order_id INT := 0;
  v_so_id INT := 0;
BEGIN
  SELECT COUNT(*) AS count INTO v_so_id FROM public.orders as o WHERE o.store_id = p_store_id AND o."createdAt"::date = CURRENT_DATE;

  v_so_id = v_so_id + 1;

  INSERT INTO public.orders (so_id, store_id, user_id, status, products, fee, timeframe, address, payment, contract_type, reason, note, "createdAt", "updatedAt")
    VALUES (v_so_id, p_store_id, p_user_id, p_status, p_products, p_fee, p_timeframe, p_address, p_payment, p_contract_type, p_reason, p_note, now(), now())
    RETURNING public.orders.id INTO v_order_id;

  RETURN QUERY SELECT v_order_id;
END;
$$;
   DROP FUNCTION public.create_order(p_store_id integer, p_user_id integer, p_status public.enum_orders_status, p_products text, p_fee text, p_address text, p_payment text, p_contract_type public.enum_orders_contract_type, p_note text, p_timeframe text, p_reason text);
       public          postgres    false    800    797         (           1255    38014 ?   create_product(integer, character varying, text, text, numeric, numeric, numeric, text, text, integer, integer, character varying)    FUNCTION        CREATE FUNCTION public.create_product(p_user_id integer, p_name character varying, p_description text, p_image text, p_price numeric, p_customer_price numeric, p_seller_price numeric, p_variants text, p_additionals text, p_quantity integer, p_max_order integer, p_category character varying) RETURNS TABLE(id integer, status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_product_id INT := 0;
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Product successfully created!';
BEGIN
	IF EXISTS (
		SELECT
			sp.id
		FROM public.store_products AS sp
		INNER JOIN public.stores AS s
			ON sp.store_id = s.id
		WHERE
			sp.name = p_name
		AND
			s.user_id = p_user_id
	) THEN
		v_status := 'warning';
    v_message := CONCAT(p_name, ' already exists! Please enter a different name.');
    RETURN QUERY SELECT v_product_id, v_status, v_message;
		RETURN;
	END IF;

  INSERT INTO public.store_products (
		store_id,
		name,
		description,
		image,
		price,
		customer_price,
		seller_price,
		variants,
		additionals,
		quantity,
		max_order,
		category,
		status,
		"createdAt",
		"updatedAt"
	)
	SELECT
		s.id,
		p_name,
		p_description,
		p_image,
		p_price,
		p_customer_price,
		p_seller_price,
		p_variants,
		p_additionals,
		p_quantity,
		p_max_order,
		p_category,
		'available',
		now(),
		now()
	FROM public.stores AS s
	WHERE s.user_id = p_user_id RETURNING public.store_products.id INTO v_product_id;

  RETURN QUERY
    SELECT v_product_id, v_status, v_message;
END;
$$;
 #  DROP FUNCTION public.create_product(p_user_id integer, p_name character varying, p_description text, p_image text, p_price numeric, p_customer_price numeric, p_seller_price numeric, p_variants text, p_additionals text, p_quantity integer, p_max_order integer, p_category character varying);
       public          postgres    false                    1255    37981 ?  create_restaurant(character varying, character varying, character varying, character varying, character varying, character varying, numeric, numeric, character varying, public.enum_stores_contract_type, character varying, character varying, character varying, character varying, character varying, text, text, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone)    FUNCTION     {  CREATE FUNCTION public.create_restaurant(p_user_name character varying, p_email character varying, p_password character varying, p_cellphone_number character varying, p_store_name character varying, p_description character varying, p_latitude numeric, p_longitude numeric, p_location_name character varying, p_contract_type public.enum_stores_contract_type, p_category character varying, p_country character varying, p_state character varying, p_city character varying, p_barangay character varying, p_logo_url text, p_photo_url text, p_sunday boolean, p_sunday_opening_time time without time zone, p_sunday_closing_time time without time zone, p_monday boolean, p_monday_opening_time time without time zone, p_monday_closing_time time without time zone, p_tuesday boolean, p_tuesday_opening_time time without time zone, p_tuesday_closing_time time without time zone, p_wednesday boolean, p_wednesday_opening_time time without time zone, p_wednesday_closing_time time without time zone, p_thursday boolean, p_thursday_opening_time time without time zone, p_thursday_closing_time time without time zone, p_friday boolean, p_friday_opening_time time without time zone, p_friday_closing_time time without time zone, p_saturday boolean, p_saturday_opening_time time without time zone, p_saturday_closing_time time without time zone) RETURNS TABLE(restaurant_id integer, user_id integer, status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_restaurant_id INT := 0;
  v_user_id INT := 0;
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Restaurant successfully created!';
BEGIN
  IF EXISTS(SELECT 1 FROM public.users AS u WHERE u.email = p_email) THEN
    v_status := 'warning';
    v_message := 'The email address you entered for this restaurant already exists.';
    RETURN QUERY SELECT v_restaurant_id, v_user_id, v_status, v_message;
    RETURN;
  END IF;

  INSERT INTO public.users (name, email, password, role, cellphone_number, "createdAt", "updatedAt")
    VALUES (p_user_name, p_email, p_password, 'partner', p_cellphone_number, now(), now())
    RETURNING public.users.id INTO v_user_id;

  INSERT INTO public.stores (user_id, name, description, latitude, longitude, location_name, type, contract_type, category, country, state, city, barangay, logo_url, photo_url, sunday, sunday_opening_time, sunday_closing_time, monday, monday_opening_time, monday_closing_time, tuesday, tuesday_opening_time, tuesday_closing_time, wednesday, wednesday_opening_time, wednesday_closing_time, thursday, thursday_opening_time, thursday_closing_time, friday, friday_opening_time, friday_closing_time, saturday, saturday_opening_time, saturday_closing_time, "createdAt", "updatedAt")
    VALUES (v_user_id, p_store_name, p_description, p_latitude, p_longitude, p_location_name, 'restaurant', p_contract_type, p_category, p_country, p_state, p_city, p_barangay, p_logo_url, p_photo_url, p_sunday, p_sunday_opening_time, p_sunday_closing_time, p_monday, p_monday_opening_time, p_monday_closing_time, p_tuesday, p_tuesday_opening_time, p_tuesday_closing_time, p_wednesday, p_wednesday_opening_time, p_wednesday_closing_time, p_thursday, p_thursday_opening_time, p_thursday_closing_time, p_friday, p_friday_opening_time, p_friday_closing_time, p_saturday, p_saturday_opening_time, p_saturday_closing_time, now(), now());
  
  RETURN QUERY
    SELECT v_restaurant_id, v_user_id, v_status, v_message;
END;
$$;
 0  DROP FUNCTION public.create_restaurant(p_user_name character varying, p_email character varying, p_password character varying, p_cellphone_number character varying, p_store_name character varying, p_description character varying, p_latitude numeric, p_longitude numeric, p_location_name character varying, p_contract_type public.enum_stores_contract_type, p_category character varying, p_country character varying, p_state character varying, p_city character varying, p_barangay character varying, p_logo_url text, p_photo_url text, p_sunday boolean, p_sunday_opening_time time without time zone, p_sunday_closing_time time without time zone, p_monday boolean, p_monday_opening_time time without time zone, p_monday_closing_time time without time zone, p_tuesday boolean, p_tuesday_opening_time time without time zone, p_tuesday_closing_time time without time zone, p_wednesday boolean, p_wednesday_opening_time time without time zone, p_wednesday_closing_time time without time zone, p_thursday boolean, p_thursday_opening_time time without time zone, p_thursday_closing_time time without time zone, p_friday boolean, p_friday_opening_time time without time zone, p_friday_closing_time time without time zone, p_saturday boolean, p_saturday_opening_time time without time zone, p_saturday_closing_time time without time zone);
       public          postgres    false    754         ?            1255    37971 ^   create_rider(character varying, character varying, character varying, character varying, text)    FUNCTION     O  CREATE FUNCTION public.create_rider(p_name character varying, p_email character varying, p_password character varying, p_cellphone_number character varying, p_motorcycle_details text) RETURNS TABLE(id integer, status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_rider_id INT := 0;
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Rider account has been created';
BEGIN
  IF EXISTS(SELECT 1 FROM public.users AS u WHERE u.email = p_email) THEN
    v_status := 'warning';
    v_message := 'A rider with the same email address already exists';
    
    RETURN QUERY SELECT v_rider_id, v_status, v_message;
    RETURN;
  END IF;

  INSERT INTO public.users (name, email, password, cellphone_number, role, "createdAt", "updatedAt")
    VALUES (p_name, p_email, p_password, p_cellphone_number, 'rider', now(), now())
    RETURNING id INTO v_rider_id;

  INSERT INTO public.riders (user_id, motorcycle_details, "createdAt")
    VALUES (v_rider_id, p_motorcycle_details, now());
    
  RETURN QUERY
  SELECT v_rider_id, v_status, v_message;
END;
$$;
 ?   DROP FUNCTION public.create_rider(p_name character varying, p_email character varying, p_password character varying, p_cellphone_number character varying, p_motorcycle_details text);
       public          postgres    false         +           1255    38017 *   create_variant(integer, character varying)    FUNCTION       CREATE FUNCTION public.create_variant(p_user_id integer, p_type character varying) RETURNS TABLE(id integer, status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_variant_id INT := 0;
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Variant successfully created!';
BEGIN
  IF EXISTS (
    SELECT
      v.id
    FROM public.variants AS v
    INNER JOIN public.stores AS s
      ON v.store_id = s.id
    WHERE s.user_id = p_user_id
    AND v.type = p_type
  ) THEN
    v_status := 'warning';
    v_message := CONCAT(p_type, ' already exists!');
    RETURN QUERY SELECT v_variant_id, v_status, v_message;
    RETURN;
  END IF;

  INSERT INTO public.variants (
    store_id,
    "type",
    "status",
    "createdAt",
    "updatedAt"
  )
  SELECT
    s.id,
    p_type,
    true,
    now(),
    now()
  FROM public.stores AS s
  WHERE s.user_id = p_user_id
  RETURNING public.variants.id INTO v_variant_id;

  RETURN QUERY
  SELECT v_variant_id, v_status, v_message;
END;
$$;
 R   DROP FUNCTION public.create_variant(p_user_id integer, p_type character varying);
       public          postgres    false         /           1255    38021 L   create_variant_option(integer, character varying, numeric, numeric, numeric)    FUNCTION     ?  CREATE FUNCTION public.create_variant_option(p_variant_id integer, p_name character varying, p_price numeric, p_customer_price numeric, p_seller_price numeric) RETURNS TABLE(id integer, status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_variant_option_id INT := 0;
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Variant option successfully created!';
BEGIN
  IF EXISTS (
    SELECT
      vo.id
    FROM public.variant_options AS vo
    WHERE vo.name = p_name
    AND vo.variant_id = p_variant_id
  ) THEN
    v_status := 'warning';
    v_message := CONCAT(p_name, ' already exists! Please enter a different name');
    RETURN QUERY
      SELECT v_variant_option_id, v_status, v_message;
    RETURN;
  END IF;

  INSERT INTO public.variant_options (
    variant_id,
    "name",
    price,
    customer_price,
    seller_price,
    "status",
    "createdAt",
    "updatedAt"
  ) VALUES (
    p_variant_id,
    p_name,
    p_price,
    p_customer_price,
    p_seller_price,
    true,
    now(),
    now()
  )
  RETURNING public.variant_options.id INTO v_variant_option_id;

  RETURN QUERY
  SELECT v_variant_option_id, v_status, v_message;
END;
$$;
 ?   DROP FUNCTION public.create_variant_option(p_variant_id integer, p_name character varying, p_price numeric, p_customer_price numeric, p_seller_price numeric);
       public          postgres    false                    1255    37975    disable_mart(integer)    FUNCTION     ?  CREATE FUNCTION public.disable_mart(p_mart_id integer) RETURNS TABLE(status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'The mart has been disabled';
BEGIN
  IF NOT EXISTS (SELECT s.id FROM public.stores AS s WHERE id = p_mart_id) THEN
    v_status := 'warning';
    v_message := 'The mart you are trying to disable does not exist.';
    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  UPDATE public.stores
    SET
      status = 'deactivated',
      "updatedAt" = now()
    WHERE id = p_mart_id;

  RETURN QUERY SELECT v_status, v_message;
END;
$$;
 6   DROP FUNCTION public.disable_mart(p_mart_id integer);
       public          postgres    false                    1255    37989    disable_menu(integer)    FUNCTION     ?  CREATE FUNCTION public.disable_menu(p_id integer) RETURNS TABLE(status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Menu successfully disabled.';
BEGIN
  IF NOT EXISTS (SELECT m.id FROM public.store_products AS m WHERE m.id = p_id) THEN
    v_status := 'warning';
    v_message := 'The menu you are trying to disable does not exist.';
    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  UPDATE public.store_products
  SET
    status = 'unavailable',
    "updatedAt" = now()
  WHERE id = p_id;

  RETURN QUERY SELECT v_status, v_message;
END;
$$;
 1   DROP FUNCTION public.disable_menu(p_id integer);
       public          postgres    false                    1255    37982    disable_restaurant(integer)    FUNCTION     ?  CREATE FUNCTION public.disable_restaurant(p_restaurant_id integer) RETURNS TABLE(status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'The restaurant has been disabled';
BEGIN
  IF NOT EXISTS (SELECT s.id FROM public.stores AS s WHERE id = p_restaurant_id) THEN
    v_status := 'warning';
    v_message := 'The restaurant you are trying to delete does not exist.';
    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  UPDATE public.stores
    SET
      status = 'deactivated',
      "updatedAt" = now()
    WHERE id = p_restaurant_id;

  RETURN QUERY SELECT v_status, v_message;
END;
$$;
 B   DROP FUNCTION public.disable_restaurant(p_restaurant_id integer);
       public          postgres    false         ?            1255    37973 )   disable_rider(integer, character varying)    FUNCTION     ?  CREATE FUNCTION public.disable_rider(p_user_id integer, p_email_address character varying) RETURNS TABLE(status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'The rider has been disabled';
BEGIN
  IF NOT EXISTS (
    SELECT
      u.id
    FROM public.users AS u
    WHERE u.id = p_user_id
  ) THEN
    v_status := 'warning';
    v_message := 'Rider does not exist';

    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  IF EXISTS (
    SELECT
      u.id
    FROM public.users AS u
    WHERE u.email = p_email_address
    AND u.id <> p_user_id
  ) THEN
    v_status := 'warning';
    v_message := 'Email address and ID do not match';

    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  UPDATE public.users
  SET 
    status = false,
    "updatedAt" = now()
  WHERE id = p_user_id;
  
  RETURN QUERY SELECT v_status, v_message;
END;
$$;
 Z   DROP FUNCTION public.disable_rider(p_user_id integer, p_email_address character varying);
       public          postgres    false         5           1255    38027 "   find_addon_by_id(integer, integer)    FUNCTION       CREATE FUNCTION public.find_addon_by_id(p_user_id integer, p_addon_id integer) RETURNS TABLE(id integer, store_id integer, addon_name character varying, price numeric, customer_price numeric, seller_price numeric, addon_status boolean, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    ao.id AS id,
    ao.store_id AS store_id,
    ao.name AS addon_name,
    ao.price AS price,
    ao.customer_price AS customer_price,
    ao.seller_price AS seller_price,
    ao.status AS addon_status,
    ao."createdAt" AS "createdAt",
    ao."updatedAt" AS "updatedAt"
  FROM additionals AS ao
  INNER JOIN stores AS s
    ON ao.store_id = s.id
  WHERE
    s.user_id = p_user_id
  AND
    ao.id = p_addon_id;
END;
$$;
 N   DROP FUNCTION public.find_addon_by_id(p_user_id integer, p_addon_id integer);
       public          postgres    false                    1255    37976    find_mart_by_id(integer)    FUNCTION     H  CREATE FUNCTION public.find_mart_by_id(p_id integer) RETURNS TABLE(id integer, user_name character varying, cellphone_number character varying, email character varying, mart_name character varying, description text, latitude numeric, longitude numeric, location_name character varying, status public.enum_stores_status, stature public.enum_stores_stature, contract_type public.enum_stores_contract_type, category character varying, country character varying, state character varying, city character varying, barangay character varying, rating numeric, logo_url text, photo_url text, sunday boolean, sunday_opening_time time without time zone, sunday_closing_time time without time zone, monday boolean, monday_opening_time time without time zone, monday_closing_time time without time zone, tuesday boolean, tuesday_opening_time time without time zone, tuesday_closing_time time without time zone, wednesday boolean, wednesday_opening_time time without time zone, wednesday_closing_time time without time zone, thursday boolean, thursday_opening_time time without time zone, thursday_closing_time time without time zone, friday boolean, friday_opening_time time without time zone, friday_closing_time time without time zone, saturday boolean, saturday_opening_time time without time zone, saturday_closing_time time without time zone, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    s.id AS id,
    u.name AS user_name,
    u.cellphone_number AS cellphone_number,
    u.email AS email,
    s.name AS mart_name,
    s.description AS description,
    s.latitude AS latitude,
    s.longitude AS longitude,
    s.location_name AS location_name,
    s.status AS status,
    s.stature AS stature,
    s.contract_type AS contract_type,
    s.category AS category,
    s.country AS country,
    s.state AS state,
    s.city AS city,
    s.barangay AS barangay,
    s.rating AS rating,
    s.logo_url AS logo_url,
    s.photo_url AS photo_url,
    s.sunday AS sunday,
    s.sunday_opening_time AS sunday_opening_time,
    s.sunday_closing_time AS sunday_closing_time,
    s.monday AS monday,
    s.monday_opening_time AS monday_opening_time,
    s.monday_closing_time AS monday_closing_time,
    s.tuesday AS tuesday,
    s.tuesday_opening_time AS tuesday_opening_time,
    s.tuesday_closing_time AS tuesday_closing_time,
    s.wednesday AS wednesday,
    s.wednesday_opening_time AS wednesday_opening_time,
    s.wednesday_closing_time AS wednesday_closing_time,
    s.thursday AS thursday,
    s.thursday_opening_time AS thursday_opening_time,
    s.thursday_closing_time AS thursday_closing_time,
    s.friday AS friday,
    s.friday_opening_time AS friday_opening_time,
    s.friday_closing_time AS friday_closing_time,
    s.saturday AS saturday,
    s.saturday_opening_time AS saturday_opening_time,
    s.saturday_closing_time AS saturday_closing_time,
    s."createdAt" AS "createdAt",
    s."updatedAt" AS "updatedAt"
  FROM public.stores AS s
  INNER JOIN public.users AS u
    ON s.user_id = u.id
  WHERE s.type = 'mart'
  AND s.id = p_id;
END;
$$;
 4   DROP FUNCTION public.find_mart_by_id(p_id integer);
       public          postgres    false    748    754    745                    1255    37994 (   find_partner_by_email(character varying)    FUNCTION     ?  CREATE FUNCTION public.find_partner_by_email(p_email_address character varying) RETURNS TABLE(id integer, partner_name character varying, email character varying, hashed_password character varying, partner_status boolean, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    u.id as id,
    u.name as partner_name,
    u.email as email,
    u.password as hashed_password,
    u.status as partner_status,
    u."createdAt" as "createdAt",
    u."updatedAt" as "updatedAt"
  FROM
    public.users as u
  WHERE u.role = 'partner'
  AND u.email = p_email_address;
END;
$$;
 O   DROP FUNCTION public.find_partner_by_email(p_email_address character varying);
       public          postgres    false                    1255    37995    find_partner_by_id(integer)    FUNCTION     k  CREATE FUNCTION public.find_partner_by_id(p_id integer) RETURNS TABLE(id integer, partner_name character varying, email character varying, hashed_password character varying, partner_status boolean, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    u.id as id,
    u.name as partner_name,
    u.email as email,
    u.password as hashed_password,
    u.status as partner_status,
    u."createdAt" as "createdAt",
    u."updatedAt" as "updatedAt"
  FROM
    public.users as u
  WHERE u.role = 'partner'
  AND u.id = p_id;
END;
$$;
 7   DROP FUNCTION public.find_partner_by_id(p_id integer);
       public          postgres    false         '           1255    38013 $   find_product_by_id(integer, integer)    FUNCTION     -  CREATE FUNCTION public.find_product_by_id(p_user_id integer, p_product_id integer) RETURNS TABLE(id integer, product_name character varying, product_description text, product_image text, price numeric, customer_price numeric, seller_price numeric, variants json, additionals json, quantity integer, max_order integer, category character varying, product_status public.enum_store_products_status, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    sp.id AS id,
    sp.name AS product_name,
    sp.description AS product_description,
    sp.image AS product_image,
    sp.price AS price,
    sp.customer_price AS customer_price,
    sp.seller_price AS seller_price,
    (
      SELECT
        json_agg(
          json_build_object(
            'id', v.id,
            'type', v.type,
            'status', v.status,
            'options', tmp.variant_options
          )
        )
      FROM public.variants AS v
      LEFT JOIN (
        SELECT
          json_agg(vo.*) AS variant_options, vo.variant_id AS variant_id
        FROM public.variant_options AS vo
        GROUP BY vo.variant_id
      ) AS tmp ON tmp.variant_id = v.id
      WHERE v.id = ANY(
        REPLACE(
          REPLACE(
            sp.variants,
            '[',
            '{'
          ),
          ']',
          '}'
        )::int[]
      )
    ) AS variants,
    (
      SELECT json_agg(ad.*)
      FROM public.additionals AS ad
      WHERE ad.id = ANY(
          REPLACE(
            REPLACE(
              sp.additionals,
              '[',
              '{'
            ),
            ']',
            '}'
          )::int[]
        )
    ) AS additionals,
    sp.quantity AS quantity,
    sp.max_order AS max_order,
    sp.category AS category,
    sp.status AS product_status,
    sp."createdAt" AS "createdAt",
    sp."updatedAt" AS "updatedAt"
  FROM public.store_products AS sp
  INNER JOIN public.stores AS s
    ON sp.store_id = s.id
  WHERE s.user_id = p_user_id
  AND sp.id = p_product_id
  GROUP BY sp.id;
END;
$$;
 R   DROP FUNCTION public.find_product_by_id(p_user_id integer, p_product_id integer);
       public          postgres    false    770         	           1255    37983    find_restaurant_by_id(integer)    FUNCTION     `  CREATE FUNCTION public.find_restaurant_by_id(p_id integer) RETURNS TABLE(id integer, user_name character varying, cellphone_number character varying, email character varying, restaurant_name character varying, description text, latitude numeric, longitude numeric, location_name character varying, status public.enum_stores_status, stature public.enum_stores_stature, contract_type public.enum_stores_contract_type, category character varying, country character varying, state character varying, city character varying, barangay character varying, rating numeric, logo_url text, photo_url text, sunday boolean, sunday_opening_time time without time zone, sunday_closing_time time without time zone, monday boolean, monday_opening_time time without time zone, monday_closing_time time without time zone, tuesday boolean, tuesday_opening_time time without time zone, tuesday_closing_time time without time zone, wednesday boolean, wednesday_opening_time time without time zone, wednesday_closing_time time without time zone, thursday boolean, thursday_opening_time time without time zone, thursday_closing_time time without time zone, friday boolean, friday_opening_time time without time zone, friday_closing_time time without time zone, saturday boolean, saturday_opening_time time without time zone, saturday_closing_time time without time zone, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    s.id AS id,
    u.name AS user_name,
    u.cellphone_number AS cellphone_number,
    u.email AS email,
    s.name AS restaurant_name,
    s.description AS description,
    s.latitude AS latitude,
    s.longitude AS longitude,
    s.location_name AS location_name,
    s.status AS status,
    s.stature AS stature,
    s.contract_type AS contract_type,
    s.category AS category,
    s.country AS country,
    s.state AS state,
    s.city AS city,
    s.barangay AS barangay,
    s.rating AS rating,
    s.logo_url AS logo_url,
    s.photo_url AS photo_url,
    s.sunday AS sunday,
    s.sunday_opening_time AS sunday_opening_time,
    s.sunday_closing_time AS sunday_closing_time,
    s.monday AS monday,
    s.monday_opening_time AS monday_opening_time,
    s.monday_closing_time AS monday_closing_time,
    s.tuesday AS tuesday,
    s.tuesday_opening_time AS tuesday_opening_time,
    s.tuesday_closing_time AS tuesday_closing_time,
    s.wednesday AS wednesday,
    s.wednesday_opening_time AS wednesday_opening_time,
    s.wednesday_closing_time AS wednesday_closing_time,
    s.thursday AS thursday,
    s.thursday_opening_time AS thursday_opening_time,
    s.thursday_closing_time AS thursday_closing_time,
    s.friday AS friday,
    s.friday_opening_time AS friday_opening_time,
    s.friday_closing_time AS friday_closing_time,
    s.saturday AS saturday,
    s.saturday_opening_time AS saturday_opening_time,
    s.saturday_closing_time AS saturday_closing_time,
    s."createdAt" AS "createdAt",
    s."updatedAt" AS "updatedAt"
  FROM public.stores AS s
  INNER JOIN public.users AS u
    ON s.user_id = u.id
  WHERE s.type = 'restaurant'
  AND s.id = p_id;
END;
$$;
 :   DROP FUNCTION public.find_restaurant_by_id(p_id integer);
       public          postgres    false    754    748    745         ?            1255    37970 .   find_rider_by_email_address(character varying)    FUNCTION     "  CREATE FUNCTION public.find_rider_by_email_address(p_email_address character varying) RETURNS TABLE(id integer, rider_id integer, name character varying, email character varying, cellphone_number character varying, cellphone_status integer, status boolean, latitude numeric, longitude numeric, motorcycle_details text, createdat timestamp with time zone, updatedat timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    u.id,
    r.id,
    u.name,
    u.email,
    u.cellphone_number,
    u.cellphone_status,
    u.status,
    r.latitude,
    r.longitude,
    r.motorcycle_details,
    u."createdAt",
    u."updatedAt"
  FROM public.users as u
  LEFT JOIN public.riders as r
    ON r.user_id = u.id
  WHERE u.role = 'rider'
  AND u.email = p_email_address;
END;
$$;
 U   DROP FUNCTION public.find_rider_by_email_address(p_email_address character varying);
       public          postgres    false         ?            1255    37969    find_rider_by_id(integer)    FUNCTION     ?  CREATE FUNCTION public.find_rider_by_id(p_user_id integer) RETURNS TABLE(id integer, rider_id integer, name character varying, email character varying, cellphone_number character varying, cellphone_status integer, status boolean, latitude numeric, longitude numeric, motorcycle_details text, createdat timestamp with time zone, updatedat timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    u.id,
    r.id,
    u.name,
    u.email,
    u.cellphone_number,
    u.cellphone_status,
    u.status,
    r.latitude,
    r.longitude,
    r.motorcycle_details,
    u."createdAt",
    u."updatedAt"
  FROM public.users as u
  LEFT JOIN public.riders as r
    ON u.id = r.user_id
  WHERE u.role = 'rider'
  AND u.id = p_user_id;
END;
$$;
 :   DROP FUNCTION public.find_rider_by_id(p_user_id integer);
       public          postgres    false                    1255    38000    find_store_by_id(integer)    FUNCTION     >  CREATE FUNCTION public.find_store_by_id(p_user_id integer) RETURNS TABLE(id integer, user_name character varying, cellphone_number character varying, email character varying, store_name character varying, district json, description text, latitude numeric, longitude numeric, location_name character varying, status public.enum_stores_status, stature public.enum_stores_stature, contract_type public.enum_stores_contract_type, category character varying, country character varying, state character varying, city character varying, barangay character varying, rating numeric, logo_url text, photo_url text, sunday boolean, sunday_opening_time time without time zone, sunday_closing_time time without time zone, monday boolean, monday_opening_time time without time zone, monday_closing_time time without time zone, tuesday boolean, tuesday_opening_time time without time zone, tuesday_closing_time time without time zone, wednesday boolean, wednesday_opening_time time without time zone, wednesday_closing_time time without time zone, thursday boolean, thursday_opening_time time without time zone, thursday_closing_time time without time zone, friday boolean, friday_opening_time time without time zone, friday_closing_time time without time zone, saturday boolean, saturday_opening_time time without time zone, saturday_closing_time time without time zone, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    s.id AS id,
    u.name AS user_name,
    u.cellphone_number AS cellphone_number,
    u.email AS email,
    s.name AS store_name,
    (
      SELECT
        json_build_object(
          'district_id', d.id,
          'district_name', d.name,
          'zip_code', d.zip_code
        )
      FROM public.districts AS d
      WHERE d.id = s.district_id
    ) AS district,
    s.description AS description,
    s.latitude AS latitude,
    s.longitude AS longitude,
    s.location_name AS location_name,
    s.status AS status,
    s.stature AS stature,
    s.contract_type AS contract_type,
    s.category AS category,
    s.country AS country,
    s.state AS state,
    s.city AS city,
    s.barangay AS barangay,
    s.rating AS rating,
    s.logo_url AS logo_url,
    s.photo_url AS photo_url,
    s.sunday AS sunday,
    s.sunday_opening_time AS sunday_opening_time,
    s.sunday_closing_time AS sunday_closing_time,
    s.monday AS monday,
    s.monday_opening_time AS monday_opening_time,
    s.monday_closing_time AS monday_closing_time,
    s.tuesday AS tuesday,
    s.tuesday_opening_time AS tuesday_opening_time,
    s.tuesday_closing_time AS tuesday_closing_time,
    s.wednesday AS wednesday,
    s.wednesday_opening_time AS wednesday_opening_time,
    s.wednesday_closing_time AS wednesday_closing_time,
    s.thursday AS thursday,
    s.thursday_opening_time AS thursday_opening_time,
    s.thursday_closing_time AS thursday_closing_time,
    s.friday AS friday,
    s.friday_opening_time AS friday_opening_time,
    s.friday_closing_time AS friday_closing_time,
    s.saturday AS saturday,
    s.saturday_opening_time AS saturday_opening_time,
    s.saturday_closing_time AS saturday_closing_time,
    s."createdAt" AS "createdAt",
    s."updatedAt" AS "updatedAt"
  FROM public.stores AS s
  INNER JOIN public.users AS u
    ON s.user_id = u.id
  WHERE u.id = p_user_id;
END;
$$;
 :   DROP FUNCTION public.find_store_by_id(p_user_id integer);
       public          postgres    false    754    745    748         #           1255    38009 $   find_variant_by_id(integer, integer)    FUNCTION     %  CREATE FUNCTION public.find_variant_by_id(p_user_id integer, p_variant_id integer) RETURNS TABLE(id integer, store_id integer, variant_type character varying, variant_status boolean, variant_options json, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    v.id AS id,
    v.store_id AS store_id,
    v.type AS variant_type,
    v.status AS variant_status,
    (
      SELECT
        json_agg(vo.*)
      FROM public.variant_options AS vo
      WHERE vo.variant_id = v.id
    ) AS variant_options,
    v."createdAt" AS "createdAt",
    v."updatedAt" AS "updatedAt"
  FROM public.variants AS v
  INNER JOIN public.stores AS s
    ON v.store_id = s.id
  WHERE s.user_id = p_user_id
  AND v.id = p_variant_id;
END;
$$;
 R   DROP FUNCTION public.find_variant_by_id(p_user_id integer, p_variant_id integer);
       public          postgres    false         2           1255    38024 +   find_variant_option_by_id(integer, integer)    FUNCTION     ?  CREATE FUNCTION public.find_variant_option_by_id(p_user_id integer, p_variant_option_id integer) RETURNS TABLE(id integer, variant_id integer, variant_option_name character varying, price numeric, customer_price numeric, seller_price numeric, variant_option_status boolean, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    vo.id AS id,
    vo.variant_id AS variant_id,
    vo.name AS variant_option_name,
    vo.price AS price,
    vo.customer_price AS customer_price,
    vo.seller_price AS seller_price,
    vo.status AS variant_option_status,
    vo."createdAt" AS "createdAt",
    vo."updatedAt" AS "updatedAt"
  FROM public.variant_options AS vo
  INNER JOIN public.variants AS v
    ON vo.variant_id = v.id
  INNER JOIN public.stores AS s
    ON v.store_id = s.id
  WHERE
    s.user_id = p_user_id
  AND
    vo.id = p_variant_option_id;
END;
$$;
 `   DROP FUNCTION public.find_variant_option_by_id(p_user_id integer, p_variant_option_id integer);
       public          postgres    false         ?            1255    37959    get_all_history()    FUNCTION       CREATE FUNCTION public.get_all_history() RETURNS TABLE(order_id integer, customer_id integer, rider_id integer, rider_user_id integer, store_id integer, customer_name character varying, rider_name character varying, store_name character varying, order_status public.enum_orders_status, products json, fee json, timeframe json, order_address json, payment json, reason text, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    o.id as order_id,
    c.id as customer_id,
    r.id as rider_id,
    u.id as rider_user_id,
    s.id as store_id,
    c.name as customer_name,
    u.name as rider_name,
    s.name as store_name,
    o.status as order_status,
    JSON(o.products) as products,
    JSON(o.fee) as fee,
    JSON(o.timeframe) as timeframe,
    JSON(o.address) as order_address,
    JSON(o.payment) as payment,
    o.reason as reason,
    o."createdAt" as "createdAt",
    o."updatedAt" as "updatedAt"
  FROM public.orders as o
  INNER JOIN public.users as c
    ON o.user_id = c.id
  INNER JOIN public.riders as r
    ON o.rider_id = r.id
  INNER JOIN public.users as u
    ON r.user_id = u.id
  INNER JOIN public.stores as s
    ON o.store_id = s.id
  ORDER BY o."createdAt" DESC;
END;
$$;
 (   DROP FUNCTION public.get_all_history();
       public          postgres    false    797                    1255    37977    get_all_marts()    FUNCTION       CREATE FUNCTION public.get_all_marts() RETURNS TABLE(id integer, mart_name character varying, description text, latitude numeric, longitude numeric, location_name character varying, status integer, stature public.enum_stores_stature, contract_type public.enum_stores_contract_type, country character varying, state character varying, city character varying, barangay character varying, rating numeric, logo_url text, photo_url text, sunday boolean, sunday_opening_time timestamp with time zone, sunday_closing_time timestamp with time zone, monday boolean, monday_opening_time timestamp with time zone, monday_closing_time timestamp with time zone, tuesday boolean, tuesday_opening_time timestamp with time zone, tuesday_closing_time timestamp with time zone, wednesday boolean, wednesday_opening_time timestamp with time zone, wednesday_closing_time timestamp with time zone, thursday boolean, thursday_opening_time timestamp with time zone, thursday_closing_time timestamp with time zone, friday boolean, friday_opening_time timestamp with time zone, friday_closing_time timestamp with time zone, saturday boolean, saturday_opening_time timestamp with time zone, saturday_closing_time timestamp with time zone, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    s.id AS id,
    s.name AS mart_name,
    s.description AS description,
    s.latitude AS latitude,
    s.longitude AS longitude,
    s.location_name AS location_name,
    s.status AS status,
    s.stature AS stature,
    s.contract_type AS contract_type,
    s.country AS country,
    s.state AS state,
    s.city AS city,
    s.barangay AS barangay,
    s.rating AS rating,
    s.logo_url AS logo_url,
    s.photo_url AS photo_url,
    s.sunday AS sunday,
    s.sunday_opening_time AS sunday_opening_time,
    s.sunday_closing_time AS sunday_closing_time,
    s.monday AS monday,
    s.monday_opening_time AS monday_opening_time,
    s.monday_closing_time AS monday_closing_time,
    s.tuesday AS tuesday,
    s.tuesday_opening_time AS tuesday_opening_time,
    s.tuesday_closing_time AS tuesday_closing_time,
    s.wednesday AS wednesday,
    s.wednesday_opening_time AS wednesday_opening_time,
    s.wednesday_closing_time AS wednesday_closing_time,
    s.thursday AS thursday,
    s.thursday_opening_time AS thursday_opening_time,
    s.thursday_closing_time AS thursday_closing_time,
    s.friday AS friday,
    s.friday_opening_time AS friday_opening_time,
    s.friday_closing_time AS friday_closing_time,
    s.saturday AS saturday,
    s.saturday_opening_time AS saturday_opening_time,
    s.saturday_closing_time AS saturday_closing_time,
    s."createdAt" AS "createdAt",
    s."updatedAt" AS "updatedAt"
  FROM public.stores AS s
  WHERE s.type = 'mart';
END;
$$;
 &   DROP FUNCTION public.get_all_marts();
       public          postgres    false    748    754         
           1255    37984    get_all_restaurants()    FUNCTION     &  CREATE FUNCTION public.get_all_restaurants() RETURNS TABLE(id integer, restaurant_name character varying, description text, latitude numeric, longitude numeric, location_name character varying, status integer, stature public.enum_stores_stature, contract_type public.enum_stores_contract_type, country character varying, state character varying, city character varying, barangay character varying, rating numeric, logo_url text, photo_url text, sunday boolean, sunday_opening_time timestamp with time zone, sunday_closing_time timestamp with time zone, monday boolean, monday_opening_time timestamp with time zone, monday_closing_time timestamp with time zone, tuesday boolean, tuesday_opening_time timestamp with time zone, tuesday_closing_time timestamp with time zone, wednesday boolean, wednesday_opening_time timestamp with time zone, wednesday_closing_time timestamp with time zone, thursday boolean, thursday_opening_time timestamp with time zone, thursday_closing_time timestamp with time zone, friday boolean, friday_opening_time timestamp with time zone, friday_closing_time timestamp with time zone, saturday boolean, saturday_opening_time timestamp with time zone, saturday_closing_time timestamp with time zone, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    s.id AS id,
    s.name AS restaurant_name,
    s.description AS description,
    s.latitude AS latitude,
    s.longitude AS longitude,
    s.location_name AS location_name,
    s.status AS status,
    s.stature AS stature,
    s.contract_type AS contract_type,
    s.country AS country,
    s.state AS state,
    s.city AS city,
    s.barangay AS barangay,
    s.rating AS rating,
    s.logo_url AS logo_url,
    s.photo_url AS photo_url,
    s.sunday AS sunday,
    s.sunday_opening_time AS sunday_opening_time,
    s.sunday_closing_time AS sunday_closing_time,
    s.monday AS monday,
    s.monday_opening_time AS monday_opening_time,
    s.monday_closing_time AS monday_closing_time,
    s.tuesday AS tuesday,
    s.tuesday_opening_time AS tuesday_opening_time,
    s.tuesday_closing_time AS tuesday_closing_time,
    s.wednesday AS wednesday,
    s.wednesday_opening_time AS wednesday_opening_time,
    s.wednesday_closing_time AS wednesday_closing_time,
    s.thursday AS thursday,
    s.thursday_opening_time AS thursday_opening_time,
    s.thursday_closing_time AS thursday_closing_time,
    s.friday AS friday,
    s.friday_opening_time AS friday_opening_time,
    s.friday_closing_time AS friday_closing_time,
    s.saturday AS saturday,
    s.saturday_opening_time AS saturday_opening_time,
    s.saturday_closing_time AS saturday_closing_time,
    s."createdAt" AS "createdAt",
    s."updatedAt" AS "updatedAt"
  FROM public.stores AS s
  WHERE s.type = 'restaurant';
END;
$$;
 ,   DROP FUNCTION public.get_all_restaurants();
       public          postgres    false    754    748         ?            1255    37964    get_all_stats()    FUNCTION     '  CREATE FUNCTION public.get_all_stats() RETURNS TABLE(grand_subtotal numeric, delivery_total numeric, discount_total numeric, grand_total numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    COALESCE(SUM((JSON(fee) ->> 'sub_total')::decimal), 0) AS grand_subtotal,
    COALESCE(SUM((JSON(fee) ->> 'delivery')::decimal), 0) AS delivery_total,
    COALESCE(SUM((JSON(fee) ->> 'discount_price')::decimal), 0) AS discount_total,
    COALESCE(SUM((JSON(fee) ->> 'total')::decimal), 0) AS grand_total
  FROM public.orders AS o;
END;
$$;
 &   DROP FUNCTION public.get_all_stats();
       public          postgres    false         &           1255    38012 $   get_daily_stats(integer, date, date)    FUNCTION     ?  CREATE FUNCTION public.get_daily_stats(p_user_id integer, p_start_date date, p_end_date date) RETURNS TABLE(date_start timestamp without time zone, date_end timestamp without time zone, delivered_count bigint, cancelled_count bigint, sales numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    CONCAT(d::date, ' 00:00:00')::TIMESTAMP AS date_start,
    CONCAT(d::date, ' 23:59:59')::TIMESTAMP AS date_end,
    COUNT(o.id) FILTER (
      WHERE o.status = 'delivered'
      AND o."createdAt" >= CONCAT(d::date, ' 00:00:00')::TIMESTAMP
      AND o."createdAt" <= CONCAT(d::date, ' 23:59:59')::TIMESTAMP
    ) AS delivered_count,
    COUNT(o.id) FILTER (
      WHERE o.status = 'store-declined'
      AND o."createdAt" >= CONCAT(d::date, ' 00:00:00')::TIMESTAMP
      AND o."createdAt" <= CONCAT(d::date, ' 23:59:59')::TIMESTAMP
    ) AS cancelled_count,
    COALESCE (
      SUM((JSON(o.fee)->>'seller_total_price')::NUMERIC) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(d::date, ' 00:00:00')::TIMESTAMP
        AND o."createdAt" <= CONCAT(d::date, ' 23:59:59')::TIMESTAMP
      ),
      0
    ) AS sales
  FROM generate_series(
      p_start_date,
      p_end_date,
      '1 day'
  ) AS d
  LEFT JOIN public.orders AS o
    ON TRUE
  INNER JOIN public.stores AS s
    ON o.store_id = s.id
  WHERE s.user_id = p_user_id
  GROUP BY d.d
  ORDER BY date_start;
END;
$$;
 ]   DROP FUNCTION public.get_daily_stats(p_user_id integer, p_start_date date, p_end_date date);
       public          postgres    false         ?            1255    37960    get_history_by_id(integer)    FUNCTION     '  CREATE FUNCTION public.get_history_by_id(p_id integer) RETURNS TABLE(order_id integer, customer_id integer, rider_id integer, rider_user_id integer, store_id integer, customer_name character varying, rider_name character varying, store_name character varying, order_status public.enum_orders_status, products json, fee json, timeframe json, order_address json, payment json, reason text, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    o.id as order_id,
    c.id as customer_id,
    r.id as rider_id,
    u.id as rider_user_id,
    s.id as store_id,
    c.name as customer_name,
    u.name as rider_name,
    s.name as store_name,
    o.status as order_status,
    JSON(o.products) as products,
    JSON(o.fee) as fee,
    JSON(o.timeframe) as timeframe,
    JSON(o.address) as order_address,
    JSON(o.payment) as payment,
    o.reason as reason,
    o."createdAt" as "createdAt",
    o."updatedAt" as "updatedAt"
  FROM public.orders as o
  INNER JOIN public.users as c
    ON o.user_id = c.id
  INNER JOIN public.riders as r
    ON o.rider_id = r.id
  INNER JOIN public.users as u
    ON r.user_id = u.id
  INNER JOIN public.stores as s
    ON o.store_id = s.id
  WHERE o.id = p_id
  ORDER BY o."createdAt" DESC;
END;
$$;
 6   DROP FUNCTION public.get_history_by_id(p_id integer);
       public          postgres    false    797                    1255    37990    get_menu_by_id(integer)    FUNCTION     ?  CREATE FUNCTION public.get_menu_by_id(p_id integer) RETURNS TABLE(id integer, store_id integer, name character varying, description text, image text, price numeric, customer_price numeric, seller_price numeric, choices text, additionals text, quantity integer, max_order integer, category character varying, status public.enum_store_products_status, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    m.id AS id,
    m.store_id AS store_id,
    m.name AS name,
    m.description AS description,
    m.image AS image,
    m.price AS price,
    m.customer_price AS customer_price,
    m.seller_price AS seller_price,
    m.choices AS choices,
    m.additionals AS additionals,
    m.quantity AS quantity,
    m.max_order AS max_order,
    m.category AS category,
    m.status AS status,
    m."createdAt" AS "createdAt",
    m."updatedAt" AS "updatedAt"
  FROM
    public.store_products AS m
  WHERE m.id = p_id;
END;
$$;
 3   DROP FUNCTION public.get_menu_by_id(p_id integer);
       public          postgres    false    770                    1255    37996    get_order_stats(integer, date)    FUNCTION     ?  CREATE FUNCTION public.get_order_stats(p_user_id integer, p_today date) RETURNS TABLE(delivered_today bigint, delivered_yesterday bigint, cancelled_today bigint, cancelled_yesterday bigint, net_sales_today numeric, net_sales_yesterday numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    COUNT(o.id)
      FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_today, ' 00:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_today, ' 23:59:59')::TIMESTAMPTZ
      ) AS delivered_today,
    COUNT(o.id)
      FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_today, ' 00:00:00')::TIMESTAMPTZ - INTERVAL '1 DAY'
        AND o."createdAt" <= CONCAT(p_today, ' 23:59:59')::TIMESTAMPTZ - INTERVAL '1 DAY'
      ) AS delivered_yesterday,
    COUNT(o.id)
      FILTER (
        WHERE o.status = 'cancelled'
        AND o."createdAt" >= CONCAT(p_today, ' 00:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_today, ' 23:59:59')::TIMESTAMPTZ
      ) AS cancelled_today,
    COUNT(o.id)
      FILTER (
        WHERE o.status = 'cancelled'
        AND o."createdAt" >= CONCAT(p_today, ' 00:00:00')::TIMESTAMPTZ - INTERVAL '1 DAY'
        AND o."createdAt" <= CONCAT(p_today, ' 23:59:59')::TIMESTAMPTZ - INTERVAL '1 DAY'
      ) AS cancelled_yesterday,
    COALESCE(
      SUM((JSON(o.fee)->>'seller_total_price')::numeric)
        FILTER (
          WHERE o.status = 'delivered'
          AND o."createdAt" >= CONCAT(p_today, ' 00:00:00')::TIMESTAMPTZ
          AND o."createdAt" <= CONCAT(p_today, ' 23:59:59')::TIMESTAMPTZ
        ),
      0
    ) AS net_sales_today,
    COALESCE(
      SUM((JSON(o.fee)->>'seller_total_price')::numeric)
        FILTER (
          WHERE o.status = 'delivered'
          AND o."createdAt" >= CONCAT(p_today, ' 00:00:00')::TIMESTAMPTZ - INTERVAL '1 DAY'
          AND o."createdAt" <= CONCAT(p_today, ' 23:59:59')::TIMESTAMPTZ - INTERVAL '1 DAY'
        ),
      0
    ) AS net_sales_yesterday
  FROM public.orders AS o
  INNER JOIN public.stores AS s
    ON o.store_id = s.id
  INNER JOIN public.users AS u
    ON s.user_id = u.id
  WHERE u.id = p_user_id;
END;
$$;
 G   DROP FUNCTION public.get_order_stats(p_user_id integer, p_today date);
       public          postgres    false                    1255    38002 N   get_partner_stats(integer, timestamp with time zone, timestamp with time zone)    FUNCTION     ?  CREATE FUNCTION public.get_partner_stats(p_user_id integer, p_start_date timestamp with time zone, p_end_date timestamp with time zone) RETURNS TABLE(delivered bigint, cancelled bigint, net_sales numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    COUNT(o.id)
      FILTER (
        WHERE o.status = 'delivered'
      )
    AS delivered,
    COUNT(o.id)
      FILTER (
        WHERE o.status = 'cancelled'
      )
    AS cancelled,
    COALESCE (
      SUM((JSON(o.fee)->>'seller_total_price')::NUMERIC)
      FILTER (
        WHERE o.status = 'delivered'
      ),
      0
    )
    AS net_sales
  FROM public.orders AS o
  INNER JOIN public.stores AS s
    ON o.store_id = s.id
  INNER JOIN public.users AS u
    ON s.user_id = u.id
  WHERE u.id = p_user_id
  AND (
    p_start_date IS NULL
    OR o."createdAt" >= p_start_date
  ) AND (
    p_start_date IS NULL
    OR o."createdAt" <= p_end_date
  );
END;
$$;
 ?   DROP FUNCTION public.get_partner_stats(p_user_id integer, p_start_date timestamp with time zone, p_end_date timestamp with time zone);
       public          postgres    false                    1255    37997    get_peak_hours(integer, date)    FUNCTION     ;,  CREATE FUNCTION public.get_peak_hours(p_user_id integer, p_date date) RETURNS TABLE(hour time without time zone, orders bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    ph.hour AS hour,
    ph.orders AS orders
  FROM (
    SELECT
      '00:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 00:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 00:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '01:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 01:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 01:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '02:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 02:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 02:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '03:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 03:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 03:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '04:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 04:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 04:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '05:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 05:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 05:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '06:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 06:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 06:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '07:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 07:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 07:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '08:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 08:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 08:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '09:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 09:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 09:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '10:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 10:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 10:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '11:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 11:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 11:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '12:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 12:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 12:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '13:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 13:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 13:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '14:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 14:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 14:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '15:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 15:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 15:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '16:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 16:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 16:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '17:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 17:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 17:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '18:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 18:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 18:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '19:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 19:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 19:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '20:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 20:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 20:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '21:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 21:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 21:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '22:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 22:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 22:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '23:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 23:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 23:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
  ) AS ph
  ORDER BY ph.orders DESC LIMIT 1;
END;
$$;
 E   DROP FUNCTION public.get_peak_hours(p_user_id integer, p_date date);
       public          postgres    false                    1255    38003 &   get_pending_store_applications_count()    FUNCTION       CREATE FUNCTION public.get_pending_store_applications_count() RETURNS TABLE(total_count bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
    SELECT
      COUNT(a.id) AS total_count
    FROM public.store_applications AS a
    WHERE "status" = 'pending';
END;
$$;
 =   DROP FUNCTION public.get_pending_store_applications_count();
       public          postgres    false                    1255    37998 Q   get_popular_products(integer, timestamp with time zone, timestamp with time zone)    FUNCTION     ?  CREATE FUNCTION public.get_popular_products(p_user_id integer, p_start_date timestamp with time zone, p_end_date timestamp with time zone) RETURNS TABLE(product_name character varying, number_of_orders bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    sp.name AS product_name,
    COUNT(o.id) AS number_of_orders
  FROM public.store_products AS sp
  LEFT JOIN (
    SELECT *, json_array_elements((o.products)::JSON)->>'product_id' AS product_id FROM public.orders AS o
  ) AS o ON sp.id = o.product_id::int
  INNER JOIN public.stores AS s
    ON o.store_id = s.id
  INNER JOIN public.users AS u
    ON s.user_id = u.id
  WHERE u.id = p_user_id
  AND (
    p_start_date IS NULL
    OR o."createdAt" >= p_start_date
  )
  AND (
    p_end_date IS NULL
    OR o."createdAt" <= p_end_date
  )
  AND o.status = 'delivered'
  GROUP BY sp.id
  ORDER BY number_of_orders DESC;
END;
$$;
 ?   DROP FUNCTION public.get_popular_products(p_user_id integer, p_start_date timestamp with time zone, p_end_date timestamp with time zone);
       public          postgres    false         ?            1255    37967    get_riders()    FUNCTION     ?  CREATE FUNCTION public.get_riders() RETURNS TABLE(id integer, rider_id integer, name character varying, email character varying, cellphone_number character varying, cellphone_status integer, status boolean, latitude numeric, longitude numeric, motorcycle_details text, createdat timestamp with time zone, updatedat timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    u.id,
    r.id,
    u.name,
    u.email,
    u.cellphone_number,
    u.cellphone_status,
    u.status,
    r.latitude,
    r.longitude,
    r.motorcycle_details,
    u."createdAt",
    u."updatedAt"
  FROM public.users as u
  LEFT JOIN public.riders as r
    ON u.id = r.user_id
  WHERE u.role = 'rider'
  ORDER BY u.name ASC;
END;
$$;
 #   DROP FUNCTION public.get_riders();
       public          postgres    false                    1255    38004 $   get_store_application_by_id(integer)    FUNCTION     R  CREATE FUNCTION public.get_store_application_by_id(p_id integer) RETURNS TABLE(id integer, business_name character varying, business_type public.enum_store_applications_business_type, district_id integer, district_name character varying, contact_person character varying, email character varying, contact_number character varying, business_address character varying, status public.enum_store_applications_status, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
    SELECT
      a.id AS id,
      a.business_name AS business_name,
      a.business_type AS business_type,
      a.district_id AS district_id,
      d.name AS district_name,
      a.contact_person AS contact_person,
      a.email AS email,
      a.contact_number AS contact_number,
      a.business_address AS business_address,
      a.status AS status,
      a."createdAt" AS "createdAt",
      a."updatedAt" AS "updatedAt"
    FROM public.store_applications AS a
    LEFT JOIN public.districts AS d
      ON a.district_id = d.id
    WHERE a.id = p_id;
END;
$$;
 @   DROP FUNCTION public.get_store_application_by_id(p_id integer);
       public          postgres    false    821    824                    1255    37991    get_store_menus(integer)    FUNCTION       CREATE FUNCTION public.get_store_menus(p_store_id integer) RETURNS TABLE(id integer, store_id integer, name character varying, description text, image text, price numeric, customer_price numeric, seller_price numeric, choices text, additionals text, quantity integer, max_order integer, category character varying, status public.enum_store_products_status, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    m.id AS id,
    m.store_id AS store_id,
    m.name AS name,
    m.description AS description,
    m.image AS image,
    m.price AS price,
    m.customer_price AS customer_price,
    m.seller_price AS seller_price,
    m.choices AS choices,
    m.additionals AS additionals,
    m.quantity AS quantity,
    m.max_order AS max_order,
    m.category AS category,
    m.status AS status,
    m."createdAt" AS "createdAt",
    m."updatedAt" AS "updatedAt"
  FROM
    public.store_products AS m
  WHERE m.store_id = p_store_id;
END;
$$;
 :   DROP FUNCTION public.get_store_menus(p_store_id integer);
       public          postgres    false    770                    1255    37999    get_week_stats(integer, date)    FUNCTION     ?  CREATE FUNCTION public.get_week_stats(p_user_id integer, p_base_date date) RETURNS TABLE(monday numeric, tuesday numeric, wednesday numeric, thursday numeric, friday numeric, saturday numeric, sunday numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    COALESCE(
        SUM((JSON(o.fee)->>'seller_total_price')::numeric)
          FILTER (
            WHERE o.status = 'delivered'
            AND o."createdAt" >= CONCAT(p_base_date, ' 00:00:00')::TIMESTAMPTZ
            AND o."createdAt" <= CONCAT(p_base_date, ' 23:59:59')::TIMESTAMPTZ
          ),
        0
      ) AS monday,
    COALESCE(
        SUM((JSON(o.fee)->>'seller_total_price')::numeric)
          FILTER (
            WHERE o.status = 'delivered'
            AND o."createdAt" >= CONCAT(p_base_date, ' 00:00:00')::TIMESTAMPTZ + INTERVAL '1 DAY'
            AND o."createdAt" <= CONCAT(p_base_date, ' 23:59:59')::TIMESTAMPTZ + INTERVAL '1 DAY'
          ),
        0
      ) AS tuesday,
    COALESCE(
        SUM((JSON(o.fee)->>'seller_total_price')::numeric)
          FILTER (
            WHERE o.status = 'delivered'
            AND o."createdAt" >= CONCAT(p_base_date, ' 00:00:00')::TIMESTAMPTZ + INTERVAL '2 DAYS'
            AND o."createdAt" <= CONCAT(p_base_date, ' 23:59:59')::TIMESTAMPTZ + INTERVAL '2 DAYS'
          ),
        0
      ) AS wednesday,
    COALESCE(
        SUM((JSON(o.fee)->>'seller_total_price')::numeric)
          FILTER (
            WHERE o.status = 'delivered'
            AND o."createdAt" >= CONCAT(p_base_date, ' 00:00:00')::TIMESTAMPTZ + INTERVAL '3 DAYS'
            AND o."createdAt" <= CONCAT(p_base_date, ' 23:59:59')::TIMESTAMPTZ + INTERVAL '3 DAYS'
          ),
        0
      ) AS thursday,
    COALESCE(
        SUM((JSON(o.fee)->>'seller_total_price')::numeric)
          FILTER (
            WHERE o.status = 'delivered'
            AND o."createdAt" >= CONCAT(p_base_date, ' 00:00:00')::TIMESTAMPTZ + INTERVAL '4 DAYS'
            AND o."createdAt" <= CONCAT(p_base_date, ' 23:59:59')::TIMESTAMPTZ + INTERVAL '4 DAYS'
          ),
        0
      ) AS friday,
    COALESCE(
        SUM((JSON(o.fee)->>'seller_total_price')::numeric)
          FILTER (
            WHERE o.status = 'delivered'
            AND o."createdAt" >= CONCAT(p_base_date, ' 00:00:00')::TIMESTAMPTZ + INTERVAL '5 DAYS'
            AND o."createdAt" <= CONCAT(p_base_date, ' 23:59:59')::TIMESTAMPTZ + INTERVAL '5 DAYS'
          ),
        0
      ) AS saturday,
    COALESCE(
        SUM((JSON(o.fee)->>'seller_total_price')::numeric)
          FILTER (
            WHERE o.status = 'delivered'
            AND o."createdAt" >= CONCAT(p_base_date, ' 00:00:00')::TIMESTAMPTZ + INTERVAL '6 DAYS'
            AND o."createdAt" <= CONCAT(p_base_date, ' 23:59:59')::TIMESTAMPTZ + INTERVAL '6 DAYS'
          ),
        0
      ) AS sunday
  FROM public.orders AS o
  INNER JOIN public.stores AS s
    ON o.store_id = s.id
  INNER JOIN public.users AS u
    ON s.user_id = u.id
  WHERE u.id = p_user_id;
END;
$$;
 J   DROP FUNCTION public.get_week_stats(p_user_id integer, p_base_date date);
       public          postgres    false                    1255    38005 ?   register_store(character varying, public.enum_store_applications_business_type, integer, character varying, character varying, character varying, character varying, character varying)    FUNCTION     ?  CREATE FUNCTION public.register_store(p_business_name character varying, p_business_type public.enum_store_applications_business_type, p_district_id integer, p_contact_person character varying, p_email character varying, p_contact_number character varying, p_business_address character varying, p_tracking_number character varying) RETURNS TABLE(store_application_id integer, status character varying, message character varying, tracking_number character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_store_application_id INT := 0;
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Your application has been sent successfully!';
  v_tracking_number VARCHAR(255) := '';
BEGIN
  IF EXISTS (SELECT s.id FROM public.store_applications AS s WHERE s.email = p_email) THEN
    v_status := 'warning';
    v_message := 'The email address you entered is already registered.';
    RETURN QUERY SELECT v_store_application_id, v_status, v_message, v_tracking_number;
    RETURN;
  END IF;

  INSERT INTO public.store_applications (
    business_name,
    business_type,
    district_id,
    contact_person,
    email,
    contact_number,
    business_address,
    "status",
    tracking_number,
    "createdAt",
    "updatedAt"
  ) VALUES (
    p_business_name,
    p_business_type,
    p_district_id,
    p_contact_person,
    p_email,
    p_contact_number,
    p_business_address,
    'pending',
    p_tracking_number,
    now(),
    now()
  ) RETURNING public.store_applications.id INTO v_store_application_id;

  v_tracking_number := p_tracking_number;

  RETURN QUERY
    SELECT v_store_application_id, v_status, v_message, v_tracking_number;
END;
$$;
 K  DROP FUNCTION public.register_store(p_business_name character varying, p_business_type public.enum_store_applications_business_type, p_district_id integer, p_contact_person character varying, p_email character varying, p_contact_number character varying, p_business_address character varying, p_tracking_number character varying);
       public          postgres    false    821         3           1255    38025 ;   search_addons(integer, character varying, integer, integer)    FUNCTION     ?  CREATE FUNCTION public.search_addons(p_user_id integer, p_query character varying, p_limit integer, p_offset integer) RETURNS TABLE(id integer, store_id integer, addon_name character varying, price numeric, customer_price numeric, seller_price numeric, addon_status boolean, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone, total_count bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    ao.id AS id,
    ao.store_id AS store_id,
    ao.name AS addon_name,
    ao.price AS price,
    ao.customer_price AS customer_price,
    ao.seller_price AS seller_price,
    ao.status AS addon_status,
    ao."createdAt" AS "createdAt",
    ao."updatedAt" AS "updatedAt",
    COUNT(ao.id) OVER() AS total_count
  FROM additionals AS ao
  INNER JOIN stores AS s
    ON ao.store_id = s.id
  WHERE
    s.user_id = p_user_id
  AND (
    p_query IS NULL
    OR LOWER(ao.name) LIKE CONCAT('%', LOWER(p_query), '%')
  )
  ORDER BY ao.name
  LIMIT p_limit
  OFFSET p_offset;
END;
$$;
 u   DROP FUNCTION public.search_addons(p_user_id integer, p_query character varying, p_limit integer, p_offset integer);
       public          postgres    false         ?            1255    37961 f   search_customer_history(integer, timestamp with time zone, timestamp with time zone, integer, integer)    FUNCTION     e  CREATE FUNCTION public.search_customer_history(p_user_id integer, p_start timestamp with time zone, p_end timestamp with time zone, p_limit integer, p_offset integer) RETURNS TABLE(order_id integer, customer_id integer, rider_id integer, rider_user_id integer, restaurant_id integer, customer_name character varying, rider_name character varying, store_name character varying, order_status public.enum_orders_status, products text, fee text, order_address character varying, payment text, reason text, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    o.id as order_id,
    c.id as customer_id,
    r.id as rider_id,
    u.id as rider_user_id,
    s.id as store_id,
    c.name as customer_name,
    u.name as rider_name,
    s.name as store_name,
    o.status as order_status,
    o.products as products,
    o.fee as fee,
    o.timeframe as timeframe,
    o.address as order_address,
    o.payment as payment,
    o.reason as reason,
    o."createdAt" as "createdAt",
    o."updatedAt" as "updatedAt"
  FROM public.orders as o
  INNER JOIN public.users as c
    ON o.user_id = c.id
  INNER JOIN public.riders as r
    ON o.rider_id = r.id
  INNER JOIN public.users as u
    ON r.user_id = u.id
  INNER JOIN public.stores as s
    ON o.store_id = s.id
  WHERE (
    p_user_id IS NULL
    OR c.id = p_user_id
  ) AND (
    p_start IS NULL
    OR o."createdAt" >= p_start
  ) AND (
    p_end IS NULL
    OR o."createdAt" <= p_end
  ) AND o."status" IN ('delivered', 'cancelled')
  ORDER BY o."createdAt"
  LIMIT p_limit
  OFFSET p_offset;
END;
$$;
 ?   DROP FUNCTION public.search_customer_history(p_user_id integer, p_start timestamp with time zone, p_end timestamp with time zone, p_limit integer, p_offset integer);
       public          postgres    false    797                    1255    37978 1   search_marts(character varying, numeric, numeric)    FUNCTION     ?  CREATE FUNCTION public.search_marts(p_search_term character varying, p_customer_latitude numeric, p_customer_longitude numeric) RETURNS TABLE(id integer, user_name character varying, cellphone_number character varying, email character varying, name character varying, description text, latitude numeric, longitude numeric, location_name character varying, status public.enum_stores_status, stature public.enum_stores_stature, contract_type public.enum_stores_contract_type, category character varying, country character varying, state character varying, city character varying, barangay character varying, rating numeric, logo_url text, photo_url text, sunday boolean, sunday_opening_time time without time zone, sunday_closing_time time without time zone, monday boolean, monday_opening_time time without time zone, monday_closing_time time without time zone, tuesday boolean, tuesday_opening_time time without time zone, tuesday_closing_time time without time zone, wednesday boolean, wednesday_opening_time time without time zone, wednesday_closing_time time without time zone, thursday boolean, thursday_opening_time time without time zone, thursday_closing_time time without time zone, friday boolean, friday_opening_time time without time zone, friday_closing_time time without time zone, saturday boolean, saturday_opening_time time without time zone, saturday_closing_time time without time zone, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone, distance double precision)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT t.* FROM (
    SELECT
      s.id AS id,
      u.name AS user_name,
      u.cellphone_number AS cellphone_number,
      u.email AS email,
      s.name AS mart_name,
      s.description AS description,
      s.latitude AS latitude,
      s.longitude AS longitude,
      s.location_name AS location_name,
      s.status AS status,
      s.stature AS stature,
      s.contract_type AS contract_type,
      s.category AS category,
      s.country AS country,
      s.state AS state,
      s.city AS city,
      s.barangay AS barangay,
      s.rating AS rating,
      s.logo_url AS logo_url,
      s.photo_url AS photo_url,
      s.sunday AS sunday,
      s.sunday_opening_time AS sunday_opening_time,
      s.sunday_closing_time AS sunday_closing_time,
      s.monday AS monday,
      s.monday_opening_time AS monday_opening_time,
      s.monday_closing_time AS monday_closing_time,
      s.tuesday AS tuesday,
      s.tuesday_opening_time AS tuesday_opening_time,
      s.tuesday_closing_time AS tuesday_closing_time,
      s.wednesday AS wednesday,
      s.wednesday_opening_time AS wednesday_opening_time,
      s.wednesday_closing_time AS wednesday_closing_time,
      s.thursday AS thursday,
      s.thursday_opening_time AS thursday_opening_time,
      s.thursday_closing_time AS thursday_closing_time,
      s.friday AS friday,
      s.friday_opening_time AS friday_opening_time,
      s.friday_closing_time AS friday_closing_time,
      s.saturday AS saturday,
      s.saturday_opening_time AS saturday_opening_time,
      s.saturday_closing_time AS saturday_closing_time,
      s."createdAt" AS "createdAt",
      s."updatedAt" AS "updatedAt",
      (6371 * acos (cos ( radians(p_customer_latitude) ) * cos( radians( s.latitude ) ) * cos( radians( s.longitude ) - radians(p_customer_longitude) ) + sin ( radians(p_customer_latitude) ) * sin( radians( s.latitude ) ))) AS distance
    FROM public.stores AS s
    INNER JOIN public.users AS u
      ON s.user_id = u.id
    WHERE s.type = 'mart'
    AND (
      p_search_term IS NULL
      OR LOWER(s.name) LIKE CONCAT('%', LOWER(p_search_term), '%')
    ) ORDER BY s.name
  ) t WHERE t.distance <= 5 ;
END;
$$;
    DROP FUNCTION public.search_marts(p_search_term character varying, p_customer_latitude numeric, p_customer_longitude numeric);
       public          postgres    false    754    748    745                    1255    37992 (   search_menus(integer, character varying)    FUNCTION     g  CREATE FUNCTION public.search_menus(p_store_id integer, p_term character varying) RETURNS TABLE(id integer, store_id integer, name character varying, description text, image text, price numeric, customer_price numeric, seller_price numeric, choices text, additionals text, quantity integer, max_order integer, category character varying, status public.enum_store_products_status, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    m.id AS id,
    m.store_id AS store_id,
    m.name AS name,
    m.description AS description,
    m.image AS image,
    m.price AS price,
    m.customer_price AS customer_price,
    m.seller_price AS seller_price,
    m.choices AS choices,
    m.additionals AS additionals,
    m.quantity AS quantity,
    m.max_order AS max_order,
    m.category AS category,
    m.status AS status,
    m."createdAt" AS "createdAt",
    m."updatedAt" AS "updatedAt"
  FROM
    public.store_products AS m
  WHERE m.store_id = p_store_id
  AND (
    p_term IS NULL
    OR m.name LIKE CONCAT('%', p_term, '%')
  );
END;
$$;
 Q   DROP FUNCTION public.search_menus(p_store_id integer, p_term character varying);
       public          postgres    false    770         ?            1255    37962 x   search_partner_history(integer, timestamp with time zone, timestamp with time zone, character varying, integer, integer)    FUNCTION     ?  CREATE FUNCTION public.search_partner_history(p_store_id integer, p_start timestamp with time zone, p_end timestamp with time zone, p_query character varying, p_limit integer, p_offset integer) RETURNS TABLE(order_id integer, customer_id integer, rider_id integer, rider_user_id integer, store_id integer, customer_name character varying, rider_name character varying, store_name character varying, store_type public.enum_stores_type, order_status public.enum_orders_status, products json, fee json, timeframe json, order_address json, payment json, reason text, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    o.id as order_id,
    c.id as customer_id,
    r.id as rider_id,
    u.id as rider_user_id,
    s.id as store_id,
    c.name as customer_name,
    u.name as rider_name,
    s.name as store_name,
    s.type as store_type,
    o.status as order_status,
    JSON(o.products) as products,
    JSON(o.fee) as fee,
    JSON(o.timeframe) as timeframe,
    JSON(o.address) as order_address,
    JSON(o.payment) as payment,
    o.reason as reason,
    o."createdAt" as "createdAt",
    o."updatedAt" as "updatedAt"
  FROM public.orders as o
  INNER JOIN public.users as c
    ON o.user_id = c.id
  INNER JOIN public.riders as r
    ON o.rider_id = r.id
  INNER JOIN public.users as u
    ON r.user_id = u.id
  INNER JOIN public.stores as s
    ON o.store_id = s.id
  WHERE (
    p_store_id IS NULL
    OR s.id = p_store_id
  ) AND (
    p_start IS NULL
    OR o."createdAt" >= p_start
    OR o."updatedAt" >= p_start
  ) AND (
    p_end IS NULL
    OR o."createdAt" <= p_end
    OR o."updatedAt" <= p_end
  ) AND (
    o.status IN ('delivered', 'store-declined')
  ) AND (
    p_query IS NULL
    OR LOWER(c.name) LIKE CONCAT('%', LOWER(p_query), '%')
    OR LOWER(s.name) LIKE CONCAT('%', LOWER(p_query), '%')
    OR LOWER(u.name) LIKE CONCAT('%', LOWER(p_query), '%')
  )
  ORDER BY o."createdAt"
  LIMIT p_limit
  OFFSET p_offset;
END;
$$;
 ?   DROP FUNCTION public.search_partner_history(p_store_id integer, p_start timestamp with time zone, p_end timestamp with time zone, p_query character varying, p_limit integer, p_offset integer);
       public          postgres    false    751    797         ?            1255    37965 Q   search_partner_stats(integer, timestamp with time zone, timestamp with time zone)    FUNCTION     ?  CREATE FUNCTION public.search_partner_stats(p_store_id integer, p_start timestamp with time zone, p_end timestamp with time zone) RETURNS TABLE(total_sales numeric, total_delivery numeric, pending_count bigint, total_pending numeric, accepted_count bigint, total_accepted numeric, declined_count bigint, total_declined numeric, delivered_count bigint, total_delivered numeric, cancelled_count bigint, total_cancelled numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    COALESCE(SUM((JSON(fee) ->> 'seller_total_price')::decimal), 0) AS total_sales,
    COALESCE(SUM((JSON(fee) ->> 'delivery')::decimal), 0) AS total_delivery,
    COUNT(o.id) FILTER (where o.status = 'pending') AS pending_count,
    COALESCE(SUM(CASE WHEN o.status = 'pending' THEN (JSON(o.fee) ->> 'seller_total_price')::decimal ELSE 0 END), 0) AS total_pending,
    COUNT(o.id) FILTER (where o.status = 'store-accepted') AS accepted_count,
    COALESCE(SUM(CASE WHEN o.status = 'store-accepted' THEN (JSON(o.fee) ->> 'seller_total_price')::decimal ELSE 0 END), 0) AS total_accepted,
    COUNT(o.id) FILTER (where o.status = 'store-declined') AS declined_count,
    COALESCE(SUM(CASE WHEN o.status = 'store-declined' THEN (JSON(o.fee) ->> 'seller_total_price')::decimal ELSE 0 END), 0) AS total_declined,
    COUNT(o.id) FILTER (where o.status = 'delivered') AS delivered_count,
    COALESCE(SUM(CASE WHEN o.status = 'delivered' THEN (JSON(o.fee) ->> 'seller_total_price')::decimal ELSE 0 END), 0) AS total_delivered,
    COUNT(o.id) FILTER (where o.status = 'cancelled') AS cancelled_count,
    COALESCE(SUM(CASE WHEN o.status = 'cancelled' THEN (JSON(o.fee) ->> 'seller_total_price')::decimal ELSE 0 END), 0) AS total_cancelled
  FROM public.orders AS o
  WHERE (
    p_store_id IS NULL
    OR o.store_id = p_store_id
  ) AND (
    p_start IS NULL
    OR o."createdAt" >= p_start
  ) AND (
    p_end IS NULL
    OR o."createdAt" <= p_end
  );
END;
$$;
 ?   DROP FUNCTION public.search_partner_stats(p_store_id integer, p_start timestamp with time zone, p_end timestamp with time zone);
       public          postgres    false         $           1255    38010 5   search_product_categories(integer, character varying)    FUNCTION     ?  CREATE FUNCTION public.search_product_categories(p_user_id integer, p_query character varying) RETURNS TABLE(category character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    sp.category AS category
  FROM public.store_products AS sp
  INNER JOIN public.stores AS s
    ON sp.store_id = s.id
  WHERE s.user_id = p_user_id
  AND (
    p_query IS NULL
    OR LOWER(sp.category) LIKE CONCAT('%', LOWER(p_query), '%') 
  )
  GROUP BY sp.category
  ORDER BY sp.category;
END;
$$;
 ^   DROP FUNCTION public.search_product_categories(p_user_id integer, p_query character varying);
       public          postgres    false         %           1255    38011 =   search_products(integer, character varying, integer, integer)    FUNCTION     	  CREATE FUNCTION public.search_products(p_user_id integer, p_query character varying, p_limit integer, p_offset integer) RETURNS TABLE(id integer, product_name character varying, product_description text, product_image text, price numeric, customer_price numeric, seller_price numeric, variants json, additionals json, quantity integer, max_order integer, category character varying, product_status public.enum_store_products_status, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone, total_count bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    sp.id AS id,
    sp.name AS product_name,
    sp.description AS product_description,
    sp.image AS product_image,
    sp.price AS price,
    sp.customer_price AS customer_price,
    sp.seller_price AS seller_price,
    (
      SELECT
        json_agg(
          json_build_object(
            'id', v.id,
            'type', v.type,
            'status', v.status,
            'options', tmp.variant_options
          )
        )
      FROM public.variants AS v
      LEFT JOIN (
        SELECT
          json_agg(vo.*) AS variant_options, vo.variant_id AS variant_id
        FROM public.variant_options AS vo
        GROUP BY vo.variant_id
      ) AS tmp ON tmp.variant_id = v.id
      WHERE v.id = ANY(
        REPLACE(
          REPLACE(
            sp.variants,
            '[',
            '{'
          ),
          ']',
          '}'
        )::int[]
      )
    ) AS variants,
    (
      SELECT json_agg(ad.*)
      FROM public.additionals AS ad
      WHERE ad.id = ANY(
          REPLACE(
            REPLACE(
              sp.additionals,
              '[',
              '{'
            ),
            ']',
            '}'
          )::int[]
        )
    ) AS additionals,
    sp.quantity AS quantity,
    sp.max_order AS max_order,
    sp.category AS category,
    sp.status AS product_status,
    sp."createdAt" AS "createdAt",
    sp."updatedAt" AS "updatedAt",
  COUNT(sp.id) OVER() AS total_count
  FROM public.store_products AS sp
  INNER JOIN public.stores AS s
    ON sp.store_id = s.id
  WHERE s.user_id = p_user_id
  AND (
    p_query IS NULL
    OR LOWER(sp.name) LIKE CONCAT('%', LOWER(p_query), '%')
  )
  GROUP BY sp.id
  ORDER BY sp.name
  LIMIT p_limit
  OFFSET p_offset;
END;
$$;
 w   DROP FUNCTION public.search_products(p_user_id integer, p_query character varying, p_limit integer, p_offset integer);
       public          postgres    false    770                    1255    37985 7   search_restaurants(character varying, numeric, numeric)    FUNCTION     ?  CREATE FUNCTION public.search_restaurants(p_search_term character varying, p_customer_latitude numeric, p_customer_longitude numeric) RETURNS TABLE(id integer, user_name character varying, cellphone_number character varying, email character varying, name character varying, description text, latitude numeric, longitude numeric, location_name character varying, status public.enum_stores_status, stature public.enum_stores_stature, contract_type public.enum_stores_contract_type, category character varying, country character varying, state character varying, city character varying, barangay character varying, rating numeric, logo_url text, photo_url text, sunday boolean, sunday_opening_time time without time zone, sunday_closing_time time without time zone, monday boolean, monday_opening_time time without time zone, monday_closing_time time without time zone, tuesday boolean, tuesday_opening_time time without time zone, tuesday_closing_time time without time zone, wednesday boolean, wednesday_opening_time time without time zone, wednesday_closing_time time without time zone, thursday boolean, thursday_opening_time time without time zone, thursday_closing_time time without time zone, friday boolean, friday_opening_time time without time zone, friday_closing_time time without time zone, saturday boolean, saturday_opening_time time without time zone, saturday_closing_time time without time zone, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone, distance double precision)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT t.* FROM (
    SELECT
      s.id AS id,
      u.name AS user_name,
      u.cellphone_number AS cellphone_number,
      u.email AS email,
      s.name AS restaurant_name,
      s.description AS description,
      s.latitude AS latitude,
      s.longitude AS longitude,
      s.location_name AS location_name,
      s.status AS status,
      s.stature AS stature,
      s.contract_type AS contract_type,
      s.category AS category,
      s.country AS country,
      s.state AS state,
      s.city AS city,
      s.barangay AS barangay,
      s.rating AS rating,
      s.logo_url AS logo_url,
      s.photo_url AS photo_url,
      s.sunday AS sunday,
      s.sunday_opening_time AS sunday_opening_time,
      s.sunday_closing_time AS sunday_closing_time,
      s.monday AS monday,
      s.monday_opening_time AS monday_opening_time,
      s.monday_closing_time AS monday_closing_time,
      s.tuesday AS tuesday,
      s.tuesday_opening_time AS tuesday_opening_time,
      s.tuesday_closing_time AS tuesday_closing_time,
      s.wednesday AS wednesday,
      s.wednesday_opening_time AS wednesday_opening_time,
      s.wednesday_closing_time AS wednesday_closing_time,
      s.thursday AS thursday,
      s.thursday_opening_time AS thursday_opening_time,
      s.thursday_closing_time AS thursday_closing_time,
      s.friday AS friday,
      s.friday_opening_time AS friday_opening_time,
      s.friday_closing_time AS friday_closing_time,
      s.saturday AS saturday,
      s.saturday_opening_time AS saturday_opening_time,
      s.saturday_closing_time AS saturday_closing_time,
      s."createdAt" AS "createdAt",
      s."updatedAt" AS "updatedAt",
      (6371 * acos (cos ( radians(p_customer_latitude) ) * cos( radians( s.latitude ) ) * cos( radians( s.longitude ) - radians(p_customer_longitude) ) + sin ( radians(p_customer_latitude) ) * sin( radians( s.latitude ) ))) AS distance
    FROM public.stores AS s
    INNER JOIN public.users AS u
      ON s.user_id = u.id
    WHERE s.type = 'restaurant'
    AND (
      p_search_term IS NULL
      OR LOWER(s.name) LIKE CONCAT('%', p_search_term, '%')
    ) ORDER BY s.name
  ) t WHERE t.distance <= 5 ;
END;
$$;
 ?   DROP FUNCTION public.search_restaurants(p_search_term character varying, p_customer_latitude numeric, p_customer_longitude numeric);
       public          postgres    false    748    745    754         ?            1255    37968     search_riders(character varying)    FUNCTION       CREATE FUNCTION public.search_riders(p_query character varying) RETURNS TABLE(id integer, rider_id integer, name character varying, email character varying, cellphone_number character varying, cellphone_status integer, status boolean, latitude numeric, longitude numeric, motorcycle_details text, createdat timestamp with time zone, updatedat timestamp with time zone, total_count bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    u.id,
    r.id,
    u.name,
    u.email,
    u.cellphone_number,
    u.cellphone_status,
    u.status,
    r.latitude,
    r.longitude,
    r.motorcycle_details,
    u."createdAt",
    u."updatedAt",
    COUNT(*) OVER () AS total_count
  FROM public.users as u
  LEFT JOIN public.riders as r
    ON u.id = r.user_id
  WHERE 
    (
        p_query IS NULL 
        OR LOWER(u.name) LIKE CONCAT('%', p_query, '%')
        OR LOWER(u.email) LIKE CONCAT('%', p_query, '%')
        OR u.cellphone_number LIKE CONCAT('%', p_query, '%')
    )
    AND u.role = 'rider'
  ORDER BY
    u.name ASC;
END;
$$;
 ?   DROP FUNCTION public.search_riders(p_query character varying);
       public          postgres    false         ?            1255    37963 w   search_riders_history(integer, timestamp with time zone, timestamp with time zone, character varying, integer, integer)    FUNCTION     ?  CREATE FUNCTION public.search_riders_history(p_rider_id integer, p_start timestamp with time zone, p_end timestamp with time zone, p_query character varying, p_limit integer, p_offset integer) RETURNS TABLE(order_id integer, customer_id integer, rider_id integer, rider_user_id integer, store_id integer, customer_name character varying, rider_name character varying, store_name character varying, order_status public.enum_orders_status, products json, fee json, timeframe json, order_address json, payment json, reason text, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    o.id as order_id,
    c.id as customer_id,
    r.id as rider_id,
    u.id as rider_user_id,
    s.id as store_id,
    c.name as customer_name,
    u.name as rider_name,
    s.name as store_name,
    o.status as order_status,
    JSON(o.products) as products,
    JSON(o.fee) as fee,
    JSON(o.timeframe) as timeframe,
    JSON(o.address) as order_address,
    JSON(o.payment) as payment,
    o.reason as reason,
    o."createdAt" as "createdAt",
    o."updatedAt" as "updatedAt"
  FROM public.orders as o
  INNER JOIN public.users as c
    ON o.user_id = c.id
  INNER JOIN public.riders as r
    ON o.rider_id = r.id
  INNER JOIN public.users as u
    ON r.user_id = u.id
  INNER JOIN public.stores as s
    ON o.store_id = s.id
  WHERE (
    p_rider_id IS NULL
    OR r.id = p_rider_id
  ) AND (
    p_start IS NULL
    OR o."createdAt" >= p_start
    OR o."updatedAt" >= p_start
  ) AND (
    p_end IS NULL
    OR o."createdAt" <= p_end
    OR o."updatedAt" <= p_end
  ) AND (
    o.status = 'delivered'
  ) AND (
    p_query IS NULL
    OR LOWER(c.name) LIKE CONCAT('%', LOWER(p_query), '%')
    OR LOWER(s.name) LIKE CONCAT('%', LOWER(p_query), '%')
    OR LOWER(u.name) LIKE CONCAT('%', LOWER(p_query), '%')
  )
  ORDER BY o."createdAt"
  LIMIT p_limit
  OFFSET p_offset;
END;
$$;
 ?   DROP FUNCTION public.search_riders_history(p_rider_id integer, p_start timestamp with time zone, p_end timestamp with time zone, p_query character varying, p_limit integer, p_offset integer);
       public          postgres    false    797         ?            1255    37966 P   search_riders_stats(integer, timestamp with time zone, timestamp with time zone)    FUNCTION     ?  CREATE FUNCTION public.search_riders_stats(p_rider_id integer, p_start timestamp with time zone, p_end timestamp with time zone) RETURNS TABLE(total_count bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    COUNT(o.id) AS total_count
  FROM public.orders AS o
  WHERE (
    p_rider_id IS NULL
    OR o.rider_id = p_rider_id
  ) AND (
    p_start IS NULL
    OR o."createdAt" >= p_start
  ) AND (
    p_end IS NULL
    OR o."createdAt" <= p_end
  ) AND status = 'delivered';
END;
$$;
 ?   DROP FUNCTION public.search_riders_stats(p_rider_id integer, p_start timestamp with time zone, p_end timestamp with time zone);
       public          postgres    false                     1255    38006 ,   search_store_applications(character varying)    FUNCTION     X  CREATE FUNCTION public.search_store_applications(p_query character varying) RETURNS TABLE(id integer, business_name character varying, business_type public.enum_store_applications_business_type, district_id integer, district_name character varying, contact_person character varying, email character varying, contact_number character varying, business_address character varying, status public.enum_store_applications_status, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
    SELECT
      a.id AS id,
      a.business_name AS business_name,
      a.business_type AS business_type,
      a.district_id AS district_id,
      d.name AS district_name,
      a.contact_person AS contact_person,
      a.email AS email,
      a.contact_number AS contact_number,
      a.business_address AS business_address,
      a.status AS status,
      a."createdAt" AS "createdAt",
      a."updatedAt" AS "updatedAt"
    FROM public.store_applications AS a
    LEFT JOIN public.districts AS d
      ON a.district_id = d.id
    WHERE (
      p_query IS NULL
      OR LOWER(a.business_name) LIKE CONCAT('%', LOWER(p_query), '%')
      OR LOWER(a.business_type::text) LIKE CONCAT('%', LOWER(p_query), '%')
      OR LOWER(d.name) LIKE CONCAT('%', LOWER(p_query), '%')
      OR LOWER(a.contact_person) LIKE CONCAT('%', LOWER(p_query), '%')
      OR LOWER(a.email) LIKE CONCAT('%', LOWER(p_query), '%')
      OR a.contact_number LIKE CONCAT('%', p_query, '%')
      OR LOWER(a.status::text) LIKE CONCAT('%', LOWER(p_query), '%')
    ) ORDER BY a."createdAt";
END;
$$;
 K   DROP FUNCTION public.search_store_applications(p_query character varying);
       public          postgres    false    824    821         .           1255    38020 M   search_variant_options(integer, integer, character varying, integer, integer)    FUNCTION     ?  CREATE FUNCTION public.search_variant_options(p_user_id integer, p_variant_id integer, p_query character varying, p_limit integer, p_offset integer) RETURNS TABLE(id integer, variant_id integer, variant_option_name character varying, price numeric, customer_price numeric, seller_price numeric, variant_option_status boolean, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone, total_count bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    vo.id AS id,
    vo.variant_id AS variant_id,
    vo.name AS variant_option_name,
    vo.price AS price,
    vo.customer_price AS customer_price,
    vo.seller_price AS seller_price,
    vo.status AS variant_option_status,
    vo."createdAt" AS "createdAt",
    vo."updatedAt" AS "updatedAt",
    COUNT(vo.id) OVER() AS total_count
  FROM public.variant_options AS vo
  INNER JOIN public.variants AS v
    ON vo.variant_id = v.id
  INNER JOIN public.stores AS s
    ON v.store_id = s.id
  WHERE
    s.user_id = p_user_id
  AND
    vo.variant_id = p_variant_id
  AND (
    p_query IS NULL
    OR LOWER(vo.name) LIKE CONCAT('%', LOWER(p_query), '%')
  )
  ORDER BY vo.name
  LIMIT p_limit
  OFFSET p_offset;
END;
$$;
 ?   DROP FUNCTION public.search_variant_options(p_user_id integer, p_variant_id integer, p_query character varying, p_limit integer, p_offset integer);
       public          postgres    false         "           1255    38008 =   search_variants(integer, character varying, integer, integer)    FUNCTION     ?  CREATE FUNCTION public.search_variants(p_user_id integer, p_query character varying, p_limit integer, p_offset integer) RETURNS TABLE(id integer, store_id integer, variant_type character varying, variant_status boolean, variant_options json, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone, total_count bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    v.id AS id,
    v.store_id AS store_id,
    v.type AS variant_type,
    v.status AS variant_status,
    (
      SELECT
        json_agg(
          json_build_object(
            'id', vo.id,
            'variant_id', vo.variant_id,
            'variant_option_name', vo.name,
            'price', vo.price,
            'customer_price', vo.customer_price,
            'seller_price', vo.seller_price,
            'variant_option_status', vo.status,
            'createdAt', vo."createdAt",
            'updatedAt', vo."updatedAt"
		      )
        )
      FROM public.variant_options AS vo
      WHERE vo.variant_id = v.id
    ) AS variant_options,
    v."createdAt" AS "createdAt",
    v."updatedAt" AS "updatedAt",
    COUNT(v.id) OVER() AS total_count
  FROM public.variants AS v
  INNER JOIN public.stores AS s
    ON v.store_id = s.id
  WHERE s.user_id = p_user_id
  AND (
    p_query IS NULL
    OR LOWER(v.type) LIKE CONCAT('%', LOWER(p_query), '%')
  )
  ORDER BY v.type
  LIMIT p_limit
  OFFSET p_offset;
END;
$$;
 w   DROP FUNCTION public.search_variants(p_user_id integer, p_query character varying, p_limit integer, p_offset integer);
       public          postgres    false         6           1255    38028 U   update_addon(integer, integer, character varying, numeric, numeric, numeric, boolean)    FUNCTION     ?  CREATE FUNCTION public.update_addon(p_user_id integer, p_addon_id integer, p_name character varying, p_price numeric, p_customer_price numeric, p_seller_price numeric, p_status boolean) RETURNS TABLE(status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Additional successfully updated!';
BEGIN
  IF NOT EXISTS (
    SELECT
      ao.id
    FROM public.additionals AS ao
    INNER JOIN public.stores AS s
      ON ao.store_id = s.id
    WHERE
      ao.id = p_addon_id
    AND
      s.user_id = p_user_id
  ) THEN
    v_status := 'warning';
    v_message := 'The addon you are trying to update does not exist.';
    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  IF EXISTS (
    SELECT
      ao.id
    FROM public.additionals AS ao
    INNER JOIN public.stores AS s
      ON ao.store_id = s.id
    WHERE s.user_id = p_user_id
    AND ao.name = p_name
    AND ao.id != p_addon_id
  ) THEN
    v_status := 'warning';
    v_message := CONCAT(p_name, ' already exists!');
    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  UPDATE public.additionals AS ao
  SET
    "name" = p_name,
    price = p_price,
    customer_price = p_customer_price,
    seller_price = p_seller_price,
    "status" = p_status,
    "updatedAt" = now()
  WHERE ao.id = p_addon_id;

  RETURN QUERY
  SELECT v_status, v_message;
END;
$$;
 ?   DROP FUNCTION public.update_addon(p_user_id integer, p_addon_id integer, p_name character varying, p_price numeric, p_customer_price numeric, p_seller_price numeric, p_status boolean);
       public          postgres    false         7           1255    38029 .   update_addon_status(integer, integer, boolean)    FUNCTION     k  CREATE FUNCTION public.update_addon_status(p_user_id integer, p_addon_id integer, p_status boolean) RETURNS TABLE(status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Additional status successfully updated!';
BEGIN
  IF NOT EXISTS (
    SELECT
      ao.id
    FROM public.additionals AS ao
    INNER JOIN public.stores AS s
      ON ao.store_id = s.id
    WHERE
      ao.id = p_addon_id
    AND
      s.user_id = p_user_id
  ) THEN
    v_status := 'warning';
    v_message := 'The addon you are trying to update does not exist.';
    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  UPDATE public.additionals AS ao
  SET
    "status" = p_status,
    "updatedAt" = now()
  WHERE ao.id = p_addon_id;

  RETURN QUERY
  SELECT v_status, v_message;
END;
$$;
 c   DROP FUNCTION public.update_addon_status(p_user_id integer, p_addon_id integer, p_status boolean);
       public          postgres    false                    1255    37979 ?  update_mart(integer, character varying, character varying, character varying, character varying, character varying, numeric, numeric, character varying, public.enum_stores_contract_type, character varying, character varying, character varying, character varying, character varying, text, text, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone)    FUNCTION     >  CREATE FUNCTION public.update_mart(p_mart_id integer, p_user_name character varying, p_email character varying, p_cellphone_number character varying, p_store_name character varying, p_description character varying, p_latitude numeric, p_longitude numeric, p_location_name character varying, p_contract_type public.enum_stores_contract_type, p_category character varying, p_country character varying, p_state character varying, p_city character varying, p_barangay character varying, p_logo_url text, p_photo_url text, p_sunday boolean, p_sunday_opening_time time without time zone, p_sunday_closing_time time without time zone, p_monday boolean, p_monday_opening_time time without time zone, p_monday_closing_time time without time zone, p_tuesday boolean, p_tuesday_opening_time time without time zone, p_tuesday_closing_time time without time zone, p_wednesday boolean, p_wednesday_opening_time time without time zone, p_wednesday_closing_time time without time zone, p_thursday boolean, p_thursday_opening_time time without time zone, p_thursday_closing_time time without time zone, p_friday boolean, p_friday_opening_time time without time zone, p_friday_closing_time time without time zone, p_saturday boolean, p_saturday_opening_time time without time zone, p_saturday_closing_time time without time zone) RETURNS TABLE(mart_id integer, user_id integer, status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_mart_id INT := 0;
  v_user_id INT := 0;
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Mart successfully updated!';
BEGIN
  IF NOT EXISTS(SELECT s.id FROM public.stores AS s WHERE s.id = p_mart_id) THEN
    v_status := 'warning';
    v_message := 'This mart does not exist.';
    RETURN QUERY SELECT v_mart_id, v_user_id, v_status, v_message;
    RETURN;
  END IF;

  IF EXISTS(SELECT s.id FROM public.users AS u INNER JOIN public.stores AS s ON u.id = s.user_id WHERE u.email = p_email AND s.id != p_mart_id) THEN
    v_status := 'warning';
    v_message := 'The email address you entered for this mart already belongs another mart.';
    RETURN QUERY SELECT v_mart_id, v_user_id, v_status, v_message;
    RETURN;
  END IF;

  UPDATE public.users AS u
	SET
		name = p_user_name,
		email = p_email,
		cellphone_number = p_cellphone_number,
		"updatedAt" = now()
	FROM public.stores AS s
		WHERE u.id = s.user_id
		AND s.id = p_mart_id;

  UPDATE public.stores
    SET
      name = p_store_name,
      description = p_description,
      latitude = p_latitude,
      longitude = p_longitude,
      location_name = p_location_name,
      contract_type = p_contract_type,
      category = p_category,
      country = p_country,
      state = p_state,
      city = p_city,
      barangay = p_barangay,
      logo_url = p_logo_url,
      photo_url = p_photo_url,
      sunday = p_sunday,
      sunday_opening_time = p_sunday_opening_time,
      sunday_closing_time = p_sunday_closing_time,
      monday = p_monday,
      monday_opening_time = p_monday_opening_time,
      monday_closing_time = p_monday_closing_time,
      tuesday = p_tuesday,
      tuesday_opening_time = p_tuesday_opening_time,
      tuesday_closing_time = p_tuesday_closing_time,
      wednesday = p_wednesday,
      wednesday_opening_time = p_wednesday_opening_time,
      wednesday_closing_time = p_wednesday_closing_time,
      thursday = p_thursday,
      thursday_opening_time = p_thursday_opening_time,
      thursday_closing_time = p_thursday_closing_time,
      friday = p_friday,
      friday_opening_time = p_friday_opening_time,
      friday_closing_time = p_friday_closing_time,
      saturday = p_saturday,
      saturday_opening_time = p_saturday_opening_time,
      saturday_closing_time = p_saturday_closing_time,
      "updatedAt" = now()
    WHERE id = p_mart_id;
  
  RETURN QUERY
    SELECT v_mart_id, v_user_id, v_status, v_message;
END;
$$;
   DROP FUNCTION public.update_mart(p_mart_id integer, p_user_name character varying, p_email character varying, p_cellphone_number character varying, p_store_name character varying, p_description character varying, p_latitude numeric, p_longitude numeric, p_location_name character varying, p_contract_type public.enum_stores_contract_type, p_category character varying, p_country character varying, p_state character varying, p_city character varying, p_barangay character varying, p_logo_url text, p_photo_url text, p_sunday boolean, p_sunday_opening_time time without time zone, p_sunday_closing_time time without time zone, p_monday boolean, p_monday_opening_time time without time zone, p_monday_closing_time time without time zone, p_tuesday boolean, p_tuesday_opening_time time without time zone, p_tuesday_closing_time time without time zone, p_wednesday boolean, p_wednesday_opening_time time without time zone, p_wednesday_closing_time time without time zone, p_thursday boolean, p_thursday_opening_time time without time zone, p_thursday_closing_time time without time zone, p_friday boolean, p_friday_opening_time time without time zone, p_friday_closing_time time without time zone, p_saturday boolean, p_saturday_opening_time time without time zone, p_saturday_closing_time time without time zone);
       public          postgres    false    754                    1255    37980 8   update_mart_stature(integer, public.enum_stores_stature)    FUNCTION     ?  CREATE FUNCTION public.update_mart_stature(p_mart_id integer, p_stature public.enum_stores_stature) RETURNS TABLE(mart_id integer, status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_mart_id INT := 0;
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Mart status successfully updated';
BEGIN
  IF NOT EXISTS(SELECT s.id FROM public.stores AS s WHERE s.id = p_mart_id) THEN
    v_status := 'warning';
    v_message := 'This mart does not exist.';
    RETURN QUERY SELECT v_mart_id, v_status, v_message;
    RETURN;
  END IF;

  UPDATE public.stores AS s
  SET
    stature = p_stature
  WHERE
    s.id = p_mart_id;

  RETURN QUERY
    SELECT v_mart_id, v_status, v_message;
END;
$$;
 c   DROP FUNCTION public.update_mart_stature(p_mart_id integer, p_stature public.enum_stores_stature);
       public          postgres    false    748                    1255    37993 ?   update_menu(integer, integer, character varying, text, text, numeric, numeric, numeric, text, text, integer, integer, character varying, public.enum_store_products_status)    FUNCTION       CREATE FUNCTION public.update_menu(p_id integer, p_store_id integer, p_name character varying, p_description text, p_image text, p_price numeric, p_customer_price numeric, p_seller_price numeric, p_choices text, p_additionals text, p_quantity integer, p_max_order integer, p_category character varying, p_status public.enum_store_products_status) RETURNS TABLE(status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Menu successfully updated!';
BEGIN
  UPDATE public.store_products
  SET
    store_id = p_store_id,
    name = p_name,
    description = p_description,
    image = p_image,
    price = p_price,
    customer_price = p_customer_price,
    seller_price = p_seller_price,
    choices = p_choices,
    additionals = p_additionals,
    quantity = p_quantity,
    max_order = p_max_order,
    category = p_category,
    status = p_status,
    "updatedAt" = now()
  WHERE id = p_id;

  RETURN QUERY
    SELECT v_status, v_message;
END;
$$;
 Z  DROP FUNCTION public.update_menu(p_id integer, p_store_id integer, p_name character varying, p_description text, p_image text, p_price numeric, p_customer_price numeric, p_seller_price numeric, p_choices text, p_additionals text, p_quantity integer, p_max_order integer, p_category character varying, p_status public.enum_store_products_status);
       public          postgres    false    770         )           1255    38015 ?   update_product(integer, integer, character varying, text, text, numeric, numeric, numeric, text, text, integer, integer, character varying, public.enum_store_products_status)    FUNCTION     6  CREATE FUNCTION public.update_product(p_user_id integer, p_product_id integer, p_name character varying, p_description text, p_image text, p_price numeric, p_customer_price numeric, p_seller_price numeric, p_variants text, p_additionals text, p_quantity integer, p_max_order integer, p_category character varying, p_status public.enum_store_products_status) RETURNS TABLE(status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Product successfully updated!';
BEGIN
  IF NOT EXISTS (
    SELECT sp.id FROM public.store_products AS sp
    INNER JOIN public.stores AS s
      ON s.id = sp.store_id
    WHERE
      sp.id = p_product_id
    AND
      s.user_id = p_user_id
  ) THEN
    v_status := 'warning';
    v_message := 'The product you are trying to update does not exist.';
    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  IF EXISTS (
		SELECT
			sp.id
		FROM public.store_products AS sp
		INNER JOIN public.stores AS s
			ON sp.store_id = s.id
		WHERE
			sp.name = p_name
		AND
			s.user_id = p_user_id
    AND sp.id != p_product_id
	) THEN
		v_status := 'warning';
    v_message := CONCAT(p_name, ' already exists! Please enter a different name.');
    RETURN QUERY SELECT v_status, v_message;
		RETURN;
	END IF;

  UPDATE public.store_products AS sp
  SET
    name = p_name,
    description = p_description,
    image = COALESCE(p_image, image),
    price = p_price,
    customer_price = p_customer_price,
    seller_price = p_seller_price,
    variants = p_variants,
    additionals = p_additionals,
    quantity = p_quantity,
    max_order = p_max_order,
    category = p_category,
    status = p_status,
    "updatedAt" = now()
  WHERE sp.id = p_product_id;

  RETURN QUERY
  SELECT v_status, v_message;
END;
$$;
 e  DROP FUNCTION public.update_product(p_user_id integer, p_product_id integer, p_name character varying, p_description text, p_image text, p_price numeric, p_customer_price numeric, p_seller_price numeric, p_variants text, p_additionals text, p_quantity integer, p_max_order integer, p_category character varying, p_status public.enum_store_products_status);
       public          postgres    false    770         *           1255    38016 J   update_product_status(integer, integer, public.enum_store_products_status)    FUNCTION     ?  CREATE FUNCTION public.update_product_status(p_user_id integer, p_product_id integer, p_status public.enum_store_products_status) RETURNS TABLE(status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Product status successfully updated!';
BEGIN
  IF NOT EXISTS (
    SELECT sp.id FROM public.store_products AS sp
    INNER JOIN public.stores AS s
      ON s.id = sp.store_id
    WHERE
      sp.id = p_product_id
    AND
      s.user_id = p_user_id
  ) THEN
    v_status := 'warning';
    v_message := 'The product you are trying to update does not exist.';
    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  UPDATE public.store_products AS sp
  SET
    status = p_status,
    "updatedAt" = now()
  WHERE sp.id = p_product_id;

  RETURN QUERY
  SELECT v_status, v_message;
END;
$$;
 ?   DROP FUNCTION public.update_product_status(p_user_id integer, p_product_id integer, p_status public.enum_store_products_status);
       public          postgres    false    770                    1255    37986 ?  update_restaurant(integer, character varying, character varying, character varying, character varying, character varying, numeric, numeric, character varying, public.enum_stores_contract_type, character varying, character varying, character varying, character varying, character varying, text, text, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone)    FUNCTION     ?  CREATE FUNCTION public.update_restaurant(p_restaurant_id integer, p_user_name character varying, p_email character varying, p_cellphone_number character varying, p_store_name character varying, p_description character varying, p_latitude numeric, p_longitude numeric, p_location_name character varying, p_contract_type public.enum_stores_contract_type, p_category character varying, p_country character varying, p_state character varying, p_city character varying, p_barangay character varying, p_logo_url text, p_photo_url text, p_sunday boolean, p_sunday_opening_time time without time zone, p_sunday_closing_time time without time zone, p_monday boolean, p_monday_opening_time time without time zone, p_monday_closing_time time without time zone, p_tuesday boolean, p_tuesday_opening_time time without time zone, p_tuesday_closing_time time without time zone, p_wednesday boolean, p_wednesday_opening_time time without time zone, p_wednesday_closing_time time without time zone, p_thursday boolean, p_thursday_opening_time time without time zone, p_thursday_closing_time time without time zone, p_friday boolean, p_friday_opening_time time without time zone, p_friday_closing_time time without time zone, p_saturday boolean, p_saturday_opening_time time without time zone, p_saturday_closing_time time without time zone) RETURNS TABLE(restaurant_id integer, user_id integer, status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_restaurant_id INT := 0;
  v_user_id INT := 0;
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Restaurant successfully updated!';
BEGIN
  IF NOT EXISTS(SELECT s.id FROM public.stores AS s WHERE s.id = p_restaurant_id) THEN
    v_status := 'warning';
    v_message := 'This restaurant does not exist.';
    RETURN QUERY SELECT v_restaurant_id, v_user_id, v_status, v_message;
    RETURN;
  END IF;

  IF EXISTS(SELECT s.id FROM public.users AS u INNER JOIN public.stores AS s ON u.id = s.user_id WHERE u.email = p_email AND s.id != p_restaurant_id) THEN
    v_status := 'warning';
    v_message := 'The email address you entered for this restaurant already belongs another restaurant.';
    RETURN QUERY SELECT v_restaurant_id, v_user_id, v_status, v_message;
    RETURN;
  END IF;

  UPDATE public.users AS u
	SET
		name = p_user_name,
		email = p_email,
		cellphone_number = p_cellphone_number,
		"updatedAt" = now()
	FROM public.stores AS s
		WHERE u.id = s.user_id
		AND s.id = p_restaurant_id;

  UPDATE public.stores
    SET
      name = p_store_name,
      description = p_description,
      latitude = p_latitude,
      longitude = p_longitude,
      location_name = p_location_name,
      contract_type = p_contract_type,
      category = p_category,
      country = p_country,
      state = p_state,
      city = p_city,
      barangay = p_barangay,
      logo_url = p_logo_url,
      photo_url = p_photo_url,
      sunday = p_sunday,
      sunday_opening_time = p_sunday_opening_time,
      sunday_closing_time = p_sunday_closing_time,
      monday = p_monday,
      monday_opening_time = p_monday_opening_time,
      monday_closing_time = p_monday_closing_time,
      tuesday = p_tuesday,
      tuesday_opening_time = p_tuesday_opening_time,
      tuesday_closing_time = p_tuesday_closing_time,
      wednesday = p_wednesday,
      wednesday_opening_time = p_wednesday_opening_time,
      wednesday_closing_time = p_wednesday_closing_time,
      thursday = p_thursday,
      thursday_opening_time = p_thursday_opening_time,
      thursday_closing_time = p_thursday_closing_time,
      friday = p_friday,
      friday_opening_time = p_friday_opening_time,
      friday_closing_time = p_friday_closing_time,
      saturday = p_saturday,
      saturday_opening_time = p_saturday_opening_time,
      saturday_closing_time = p_saturday_closing_time,
      "updatedAt" = now()
    WHERE id = p_restaurant_id;
  
  RETURN QUERY
    SELECT v_restaurant_id, v_user_id, v_status, v_message;
END;
$$;
 +  DROP FUNCTION public.update_restaurant(p_restaurant_id integer, p_user_name character varying, p_email character varying, p_cellphone_number character varying, p_store_name character varying, p_description character varying, p_latitude numeric, p_longitude numeric, p_location_name character varying, p_contract_type public.enum_stores_contract_type, p_category character varying, p_country character varying, p_state character varying, p_city character varying, p_barangay character varying, p_logo_url text, p_photo_url text, p_sunday boolean, p_sunday_opening_time time without time zone, p_sunday_closing_time time without time zone, p_monday boolean, p_monday_opening_time time without time zone, p_monday_closing_time time without time zone, p_tuesday boolean, p_tuesday_opening_time time without time zone, p_tuesday_closing_time time without time zone, p_wednesday boolean, p_wednesday_opening_time time without time zone, p_wednesday_closing_time time without time zone, p_thursday boolean, p_thursday_opening_time time without time zone, p_thursday_closing_time time without time zone, p_friday boolean, p_friday_opening_time time without time zone, p_friday_closing_time time without time zone, p_saturday boolean, p_saturday_opening_time time without time zone, p_saturday_closing_time time without time zone);
       public          postgres    false    754                    1255    37987 >   update_restaurant_stature(integer, public.enum_stores_stature)    FUNCTION     !  CREATE FUNCTION public.update_restaurant_stature(p_restaurant_id integer, p_stature public.enum_stores_stature) RETURNS TABLE(restaurant_id integer, status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_restaurant_id INT := 0;
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Restaurant status successfully updated';
BEGIN
  IF NOT EXISTS(SELECT s.id FROM public.stores AS s WHERE s.id = p_restaurant_id) THEN
    v_status := 'warning';
    v_message := 'This restaurant does not exist.';
    RETURN QUERY SELECT v_restaurant_id, v_status, v_message;
    RETURN;
  END IF;

  UPDATE public.stores AS s
  SET
    stature = p_stature
  WHERE
    s.id = p_restaurant_id;

  RETURN QUERY
    SELECT v_restaurant_id, v_status, v_message;
END;
$$;
 o   DROP FUNCTION public.update_restaurant_stature(p_restaurant_id integer, p_stature public.enum_stores_stature);
       public          postgres    false    748         ?            1255    37972 T   update_rider(integer, character varying, character varying, character varying, text)    FUNCTION     ?  CREATE FUNCTION public.update_rider(p_id integer, p_name character varying, p_email character varying, p_cellphone_number character varying, p_motorcycle_details text) RETURNS TABLE(status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'The rider has been updated';
BEGIN
  IF NOT EXISTS (SELECT u.id FROM public.users AS u WHERE u.id = p_id) THEN
    v_status := 'warning';
    v_message := 'User does not exist';
    
    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  IF EXISTS (SELECT u.id FROM public.users AS u
      WHERE u.email = p_email AND u.id <> p_id) THEN
    v_status := 'warning';
    v_message := 'Email address already exists';

    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  UPDATE public.users
    SET 
      name = p_name,
      email = p_email,
      cellphone_number = p_cellphone_number,
      "updatedAt" = now()
    WHERE id = p_id;

  UPDATE public.riders
    SET
      motorcycle_details = p_motorcycle_details
    WHERE user_id = p_id;
  
  RETURN QUERY SELECT v_status, v_message;
END;
$$;
 ?   DROP FUNCTION public.update_rider(p_id integer, p_name character varying, p_email character varying, p_cellphone_number character varying, p_motorcycle_details text);
       public          postgres    false                    1255    38001 i  update_store(integer, integer, character varying, text, numeric, numeric, character varying, character varying, character varying, character varying, character varying, text, text, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, character varying, character varying)    FUNCTION     ?  CREATE FUNCTION public.update_store(p_store_id integer, p_user_id integer, p_store_name character varying, p_description text, p_latitude numeric, p_longitude numeric, p_category character varying, p_country character varying, p_state character varying, p_city character varying, p_barangay character varying, p_logo_url text, p_photo_url text, p_sunday boolean, p_sunday_opening_time time without time zone, p_sunday_closing_time time without time zone, p_monday boolean, p_monday_opening_time time without time zone, p_monday_closing_time time without time zone, p_tuesday boolean, p_tuesday_opening_time time without time zone, p_tuesday_closing_time time without time zone, p_wednesday boolean, p_wednesday_opening_time time without time zone, p_wednesday_closing_time time without time zone, p_thursday boolean, p_thursday_opening_time time without time zone, p_thursday_closing_time time without time zone, p_friday boolean, p_friday_opening_time time without time zone, p_friday_closing_time time without time zone, p_saturday boolean, p_saturday_opening_time time without time zone, p_saturday_closing_time time without time zone, p_user_name character varying, p_cellphone_number character varying) RETURNS TABLE(status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Store profile successfully updated!';
BEGIN
  UPDATE public.users AS u
    SET
      name = p_user_name,
      cellphone_number = p_cellphone_number,
      "updatedAt" = now()
    WHERE u.id = p_user_id;
  
  UPDATE public.stores AS s
    SET
      name = p_store_name,
      description = p_description,
      latitude = p_latitude,
      longitude = p_longitude,
      category = p_category,
      country = p_country,
      state = p_state,
      city = p_city,
      barangay = p_barangay,
      logo_url = COALESCE(p_logo_url, logo_url),
      photo_url = COALESCE(p_photo_url, photo_url),
      sunday = p_sunday,
      sunday_opening_time = p_sunday_opening_time,
      sunday_closing_time = p_sunday_closing_time,
      monday = p_monday,
      monday_opening_time = p_monday_opening_time,
      monday_closing_time = p_monday_closing_time,
      tuesday = p_tuesday,
      tuesday_opening_time = p_tuesday_opening_time,
      tuesday_closing_time = p_tuesday_closing_time,
      wednesday = p_wednesday,
      wednesday_opening_time = p_wednesday_opening_time,
      wednesday_closing_time = p_wednesday_closing_time,
      thursday = p_thursday,
      thursday_opening_time = p_thursday_opening_time,
      thursday_closing_time = p_thursday_closing_time,
      friday = p_friday,
      friday_opening_time = p_friday_opening_time,
      friday_closing_time = p_friday_closing_time,
      saturday = p_saturday,
      saturday_opening_time = p_saturday_opening_time,
      saturday_closing_time = p_saturday_closing_time,
      "updatedAt" = now()
    WHERE s.id = p_store_id;

    RETURN QUERY
    SELECT v_status, v_message;
END;
$$;
 ?  DROP FUNCTION public.update_store(p_store_id integer, p_user_id integer, p_store_name character varying, p_description text, p_latitude numeric, p_longitude numeric, p_category character varying, p_country character varying, p_state character varying, p_city character varying, p_barangay character varying, p_logo_url text, p_photo_url text, p_sunday boolean, p_sunday_opening_time time without time zone, p_sunday_closing_time time without time zone, p_monday boolean, p_monday_opening_time time without time zone, p_monday_closing_time time without time zone, p_tuesday boolean, p_tuesday_opening_time time without time zone, p_tuesday_closing_time time without time zone, p_wednesday boolean, p_wednesday_opening_time time without time zone, p_wednesday_closing_time time without time zone, p_thursday boolean, p_thursday_opening_time time without time zone, p_thursday_closing_time time without time zone, p_friday boolean, p_friday_opening_time time without time zone, p_friday_closing_time time without time zone, p_saturday boolean, p_saturday_opening_time time without time zone, p_saturday_closing_time time without time zone, p_user_name character varying, p_cellphone_number character varying);
       public          postgres    false         !           1255    38007 O   update_store_application_status(integer, public.enum_store_applications_status)    FUNCTION     s  CREATE FUNCTION public.update_store_application_status(p_id integer, p_status public.enum_store_applications_status) RETURNS TABLE(application_id integer, status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_application_id INT := 0;
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Store application status successfully updated!';
BEGIN
  IF NOT EXISTS(SELECT a.id FROM public.store_applications AS a WHERE a.id = p_id) THEN
    v_status := 'warning';
    v_message := 'The store application you are trying to approve/reject does not exist.';
    RETURN QUERY SELECT v_application_id, v_status, v_message;
    RETURN;
  END IF;

  UPDATE public.store_applications
    SET
      "status" = p_status,
      "updatedAt" = now()
    WHERE "id" = p_id;

  RETURN QUERY
    SELECT v_application_id, v_status, v_message;
END;
$$;
 t   DROP FUNCTION public.update_store_application_status(p_id integer, p_status public.enum_store_applications_status);
       public          postgres    false    824         9           1255    38031 9   update_store_stature(integer, public.enum_stores_stature)    FUNCTION     ?  CREATE FUNCTION public.update_store_stature(p_user_id integer, p_stature public.enum_stores_stature) RETURNS TABLE(status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Store stature successfully updated!';
BEGIN
  UPDATE public.stores AS s
    SET
      stature = p_stature
    WHERE s.user_id = p_user_id;

    RETURN QUERY
    SELECT v_status, v_message;
END;
$$;
 d   DROP FUNCTION public.update_store_stature(p_user_id integer, p_stature public.enum_stores_stature);
       public          postgres    false    748         ,           1255    38018 <   update_variant(integer, integer, character varying, boolean)    FUNCTION     ?  CREATE FUNCTION public.update_variant(p_user_id integer, p_variant_id integer, p_type character varying, p_status boolean) RETURNS TABLE(status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Variant successfully updated!';
BEGIN
  IF NOT EXISTS (
    SELECT
      v.id
    FROM public.variants AS v
    INNER JOIN public.stores AS s
      ON v.store_id = s.id
    WHERE
      v.id = p_variant_id
    AND
      s.user_id = p_user_id
  ) THEN
    v_status := 'warning';
    v_message := 'The variant you are trying to update does not exist.';
    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  IF EXISTS (
    SELECT
      v.id
    FROM public.variants AS v
    INNER JOIN public.stores AS s
      ON v.store_id = s.id
    WHERE s.user_id = p_user_id
    AND v.type = p_type
    AND v.id != p_variant_id
  ) THEN
    v_status := 'warning';
    v_message := CONCAT(p_type, ' already exists!');
    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  UPDATE public.variants AS v
  SET
    "type" = p_type,
    "status" = p_status,
    "updatedAt" = now()
  WHERE v.id = p_variant_id;

  RETURN QUERY
  SELECT v_status, v_message;
END;
$$;
 z   DROP FUNCTION public.update_variant(p_user_id integer, p_variant_id integer, p_type character varying, p_status boolean);
       public          postgres    false         1           1255    38023 ^   update_variant_option(integer, integer, character varying, numeric, numeric, numeric, boolean)    FUNCTION     (  CREATE FUNCTION public.update_variant_option(p_user_id integer, p_variant_option_id integer, p_name character varying, p_price numeric, p_customer_price numeric, p_seller_price numeric, p_status boolean) RETURNS TABLE(status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Variant status successfully updated!';
BEGIN
  IF NOT EXISTS (
    SELECT
      vo.id
    FROM public.variant_options AS vo
    INNER JOIN public.variants AS v
      ON vo.variant_id = v.id
    INNER JOIN public.stores AS s
      ON v.store_id = s.id
    WHERE
      vo.id = p_variant_option_id
    AND
      s.user_id = p_user_id
  ) THEN
    v_status := 'warning';
    v_message := CONCAT(p_variant_option_id, p_user_id, 'The variant you are trying to update does not exist.');
    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  IF EXISTS (
    SELECT
      vo.id
    FROM public.variant_options AS vo
    WHERE vo.name = p_name
    AND vo.id != p_variant_option_id
  ) THEN
    v_status := 'warning';
    v_message := CONCAT(p_name, ' already exists! Please enter a different name');
    RETURN QUERY
      SELECT v_variant_option_id, v_status, v_message;
    RETURN;
  END IF;

  UPDATE public.variant_options AS v
  SET
    "name" = p_name,
    price = p_price,
    customer_price = p_customer_price,
    seller_price = p_seller_price,
    "status" = p_status,
    "updatedAt" = now()
  WHERE v.id = p_variant_option_id;

  RETURN QUERY
  SELECT v_status, v_message;
END;
$$;
 ?   DROP FUNCTION public.update_variant_option(p_user_id integer, p_variant_option_id integer, p_name character varying, p_price numeric, p_customer_price numeric, p_seller_price numeric, p_status boolean);
       public          postgres    false         0           1255    38022 7   update_variant_option_status(integer, integer, boolean)    FUNCTION     ?  CREATE FUNCTION public.update_variant_option_status(p_user_id integer, p_variant_option_id integer, p_status boolean) RETURNS TABLE(status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Variant option status successfully updated!';
BEGIN
  IF NOT EXISTS (
    SELECT
      vo.id
    FROM public.variant_options AS vo
    INNER JOIN public.variants AS v
      ON vo.variant_id = v.id
    INNER JOIN public.stores AS s
      ON v.store_id = s.id
    WHERE
      vo.id = p_variant_option_id
    AND
      s.user_id = p_user_id
  ) THEN
    v_status := 'warning';
    v_message := 'The variant option you are trying to update does not exist.';
    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  UPDATE public.variant_options AS v
  SET
    "status" = p_status,
    "updatedAt" = now()
  WHERE v.id = p_variant_option_id;

  RETURN QUERY
  SELECT v_status, v_message;
END;
$$;
 u   DROP FUNCTION public.update_variant_option_status(p_user_id integer, p_variant_option_id integer, p_status boolean);
       public          postgres    false         -           1255    38019 0   update_variant_status(integer, integer, boolean)    FUNCTION     f  CREATE FUNCTION public.update_variant_status(p_user_id integer, p_variant_id integer, p_status boolean) RETURNS TABLE(status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Variant status successfully updated!';
BEGIN
  IF NOT EXISTS (
    SELECT
      v.id
    FROM public.variants AS v
    INNER JOIN public.stores AS s
      ON v.store_id = s.id
    WHERE
      v.id = p_variant_id
    AND
      s.user_id = p_user_id
  ) THEN
    v_status := 'warning';
    v_message := 'The variant you are trying to update does not exist.';
    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  UPDATE public.variants AS v
  SET
    "status" = p_status,
    "updatedAt" = now()
  WHERE v.id = p_variant_id;

  RETURN QUERY
  SELECT v_status, v_message;
END;
$$;
 g   DROP FUNCTION public.update_variant_status(p_user_id integer, p_variant_id integer, p_status boolean);
       public          postgres    false         ?            1259    37789    additionals    TABLE     q  CREATE TABLE public.additionals (
    id integer NOT NULL,
    store_id integer NOT NULL,
    name character varying(255) NOT NULL,
    price numeric NOT NULL,
    customer_price numeric NOT NULL,
    seller_price numeric NOT NULL,
    status boolean DEFAULT true,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);
    DROP TABLE public.additionals;
       public         heap    postgres    false         ?            1259    37787    additionals_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.additionals_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.additionals_id_seq;
       public          postgres    false    217         ?           0    0    additionals_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.additionals_id_seq OWNED BY public.additionals.id;
          public          postgres    false    216         ?            1259    19209    carts    TABLE     \  CREATE TABLE public.carts (
    id integer NOT NULL,
    store_id integer NOT NULL,
    user_id integer NOT NULL,
    store_product_id integer NOT NULL,
    product_details text NOT NULL,
    total_price numeric(10,2) NOT NULL,
    customer_total_price numeric(10,2) NOT NULL,
    seller_total_price numeric(10,2) NOT NULL,
    choices text,
    additionals text,
    quantity integer DEFAULT 1,
    note text,
    status public.enum_carts_status DEFAULT 'active'::public.enum_carts_status NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);
    DROP TABLE public.carts;
       public         heap    postgres    false    755    755         ?            1259    19207    carts_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.carts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.carts_id_seq;
       public          postgres    false    201         ?           0    0    carts_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.carts_id_seq OWNED BY public.carts.id;
          public          postgres    false    200         ?            1259    37876    chats    TABLE     ?   CREATE TABLE public.chats (
    id integer NOT NULL,
    user_id integer,
    order_id integer,
    message text,
    "createdAt" timestamp with time zone NOT NULL
);
    DROP TABLE public.chats;
       public         heap    postgres    false         ?            1259    37874    chats_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.chats_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.chats_id_seq;
       public          postgres    false    223         ?           0    0    chats_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.chats_id_seq OWNED BY public.chats.id;
          public          postgres    false    222         ?            1259    37661 	   districts    TABLE     ?   CREATE TABLE public.districts (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    zip_code integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);
    DROP TABLE public.districts;
       public         heap    postgres    false         ?            1259    37659    districts_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.districts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.districts_id_seq;
       public          postgres    false    207         ?           0    0    districts_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.districts_id_seq OWNED BY public.districts.id;
          public          postgres    false    206         ?            1259    37849    orders    TABLE     :  CREATE TABLE public.orders (
    id integer NOT NULL,
    so_id integer NOT NULL,
    store_id integer NOT NULL,
    user_id integer NOT NULL,
    rider_id integer,
    status public.enum_orders_status DEFAULT 'pending'::public.enum_orders_status NOT NULL,
    products text NOT NULL,
    fee text NOT NULL,
    timeframe text,
    address text NOT NULL,
    payment text NOT NULL,
    contract_type public.enum_orders_contract_type,
    note text,
    reason text,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);
    DROP TABLE public.orders;
       public         heap    postgres    false    797    797    800         ?            1259    37847    orders_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.orders_id_seq;
       public          postgres    false    221         ?           0    0    orders_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;
          public          postgres    false    220         ?            1259    37915 
   rider_logs    TABLE     ?   CREATE TABLE public.rider_logs (
    id integer NOT NULL,
    rider_id integer NOT NULL,
    status_from integer NOT NULL,
    status_to integer NOT NULL,
    "createdAt" timestamp with time zone NOT NULL
);
    DROP TABLE public.rider_logs;
       public         heap    postgres    false         ?            1259    37913    rider_logs_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.rider_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.rider_logs_id_seq;
       public          postgres    false    227         ?           0    0    rider_logs_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.rider_logs_id_seq OWNED BY public.rider_logs.id;
          public          postgres    false    226         ?            1259    37897    rider_tracks    TABLE     ?   CREATE TABLE public.rider_tracks (
    id integer NOT NULL,
    rider_id integer NOT NULL,
    order_id integer,
    location character varying(255) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL
);
     DROP TABLE public.rider_tracks;
       public         heap    postgres    false         ?            1259    37895    rider_tracks_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.rider_tracks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.rider_tracks_id_seq;
       public          postgres    false    225         ?           0    0    rider_tracks_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.rider_tracks_id_seq OWNED BY public.rider_tracks.id;
          public          postgres    false    224         ?            1259    37806    riders    TABLE     f  CREATE TABLE public.riders (
    id integer NOT NULL,
    user_id integer NOT NULL,
    photo text NOT NULL,
    status integer DEFAULT 3,
    latitude numeric(25,20),
    longitude numeric(25,20),
    motorcycle_details text DEFAULT '{"brand":"","model":"","plate_number":"","color":""}'::text NOT NULL,
    "createdAt" timestamp with time zone NOT NULL
);
    DROP TABLE public.riders;
       public         heap    postgres    false         ?            1259    37804    riders_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.riders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.riders_id_seq;
       public          postgres    false    219         ?           0    0    riders_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.riders_id_seq OWNED BY public.riders.id;
          public          postgres    false    218         ?            1259    37943    store_applications    TABLE     ?  CREATE TABLE public.store_applications (
    id integer NOT NULL,
    business_name character varying(255) NOT NULL,
    business_type public.enum_store_applications_business_type DEFAULT 'restaurant'::public.enum_store_applications_business_type NOT NULL,
    district_id integer NOT NULL,
    contact_person character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    contact_number character varying(255) NOT NULL,
    business_address character varying(255) NOT NULL,
    status public.enum_store_applications_status DEFAULT 'pending'::public.enum_store_applications_status NOT NULL,
    tracking_number character varying(255) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);
 &   DROP TABLE public.store_applications;
       public         heap    postgres    false    821    824    821    824         ?            1259    37941    store_applications_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.store_applications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.store_applications_id_seq;
       public          postgres    false    229         ?           0    0    store_applications_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.store_applications_id_seq OWNED BY public.store_applications.id;
          public          postgres    false    228         ?            1259    37739    store_products    TABLE     m  CREATE TABLE public.store_products (
    id integer NOT NULL,
    store_id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    image text,
    price numeric NOT NULL,
    customer_price numeric NOT NULL,
    seller_price numeric NOT NULL,
    variants text,
    additionals text,
    quantity integer DEFAULT 0,
    max_order integer DEFAULT 0,
    category character varying(255),
    status public.enum_store_products_status DEFAULT 'available'::public.enum_store_products_status,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);
 "   DROP TABLE public.store_products;
       public         heap    postgres    false    770    770         ?            1259    37737    store_products_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.store_products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.store_products_id_seq;
       public          postgres    false    211         ?           0    0    store_products_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.store_products_id_seq OWNED BY public.store_products.id;
          public          postgres    false    210         ?            1259    37701    stores    TABLE     y  CREATE TABLE public.stores (
    id integer NOT NULL,
    user_id integer,
    district_id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    latitude numeric(25,20) NOT NULL,
    longitude numeric(25,20) NOT NULL,
    location_name character varying(255),
    status public.enum_stores_status DEFAULT 'active'::public.enum_stores_status NOT NULL,
    stature public.enum_stores_stature DEFAULT 'open'::public.enum_stores_stature NOT NULL,
    type public.enum_stores_type NOT NULL,
    contract_type public.enum_stores_contract_type,
    category character varying(255),
    country character varying(255) NOT NULL,
    state character varying(255) NOT NULL,
    city character varying(255) NOT NULL,
    barangay character varying(255) NOT NULL,
    rating numeric(5,2) DEFAULT 0 NOT NULL,
    logo_url text NOT NULL,
    photo_url text,
    sunday boolean DEFAULT false,
    sunday_opening_time time without time zone,
    sunday_closing_time time without time zone,
    monday boolean DEFAULT false,
    monday_opening_time time without time zone,
    monday_closing_time time without time zone,
    tuesday boolean DEFAULT false,
    tuesday_opening_time time without time zone,
    tuesday_closing_time time without time zone,
    wednesday boolean DEFAULT false,
    wednesday_opening_time time without time zone,
    wednesday_closing_time time without time zone,
    thursday boolean DEFAULT false,
    thursday_opening_time time without time zone,
    thursday_closing_time time without time zone,
    friday boolean DEFAULT false,
    friday_opening_time time without time zone,
    friday_closing_time time without time zone,
    saturday boolean DEFAULT false,
    saturday_opening_time time without time zone,
    saturday_closing_time time without time zone,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);
    DROP TABLE public.stores;
       public         heap    postgres    false    745    748    748    745    751    754         ?            1259    37699    stores_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.stores_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.stores_id_seq;
       public          postgres    false    209         ?           0    0    stores_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.stores_id_seq OWNED BY public.stores.id;
          public          postgres    false    208         ?            1259    37645    user_addresses    TABLE     7  CREATE TABLE public.user_addresses (
    id integer NOT NULL,
    user_id integer NOT NULL,
    name character varying(255) NOT NULL,
    location character varying(255) NOT NULL,
    address character varying(255) NOT NULL,
    note character varying(255),
    "createdAt" timestamp with time zone NOT NULL
);
 "   DROP TABLE public.user_addresses;
       public         heap    postgres    false         ?            1259    37643    user_addresses_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.user_addresses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.user_addresses_id_seq;
       public          postgres    false    205         ?           0    0    user_addresses_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.user_addresses_id_seq OWNED BY public.user_addresses.id;
          public          postgres    false    204         ?            1259    37629    users    TABLE     ?  CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(255),
    provider public.enum_users_provider DEFAULT 'email'::public.enum_users_provider,
    provider_token text,
    token text,
    role public.enum_users_role DEFAULT 'customer'::public.enum_users_role NOT NULL,
    cellphone_number character varying(255) DEFAULT 0 NOT NULL,
    cellphone_status integer DEFAULT 0 NOT NULL,
    status boolean DEFAULT true NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);
    DROP TABLE public.users;
       public         heap    postgres    false    725    728    728    725         ?            1259    37627    users_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public          postgres    false    203         ?           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
          public          postgres    false    202         ?            1259    37772    variant_options    TABLE     w  CREATE TABLE public.variant_options (
    id integer NOT NULL,
    variant_id integer NOT NULL,
    name character varying(255) NOT NULL,
    price numeric NOT NULL,
    customer_price numeric NOT NULL,
    seller_price numeric NOT NULL,
    status boolean DEFAULT true,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);
 #   DROP TABLE public.variant_options;
       public         heap    postgres    false         ?            1259    37770    variant_options_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.variant_options_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.variant_options_id_seq;
       public          postgres    false    215         ?           0    0    variant_options_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.variant_options_id_seq OWNED BY public.variant_options.id;
          public          postgres    false    214         ?            1259    37758    variants    TABLE     
  CREATE TABLE public.variants (
    id integer NOT NULL,
    store_id integer NOT NULL,
    type character varying(255) NOT NULL,
    status boolean DEFAULT true,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);
    DROP TABLE public.variants;
       public         heap    postgres    false         ?            1259    37756    variants_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.variants_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.variants_id_seq;
       public          postgres    false    213         ?           0    0    variants_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.variants_id_seq OWNED BY public.variants.id;
          public          postgres    false    212         ?           2604    37792    additionals id    DEFAULT     p   ALTER TABLE ONLY public.additionals ALTER COLUMN id SET DEFAULT nextval('public.additionals_id_seq'::regclass);
 =   ALTER TABLE public.additionals ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    217    216    217         ?           2604    19212    carts id    DEFAULT     d   ALTER TABLE ONLY public.carts ALTER COLUMN id SET DEFAULT nextval('public.carts_id_seq'::regclass);
 7   ALTER TABLE public.carts ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    201    200    201         ?           2604    37879    chats id    DEFAULT     d   ALTER TABLE ONLY public.chats ALTER COLUMN id SET DEFAULT nextval('public.chats_id_seq'::regclass);
 7   ALTER TABLE public.chats ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    223    222    223         ?           2604    37664    districts id    DEFAULT     l   ALTER TABLE ONLY public.districts ALTER COLUMN id SET DEFAULT nextval('public.districts_id_seq'::regclass);
 ;   ALTER TABLE public.districts ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    207    206    207         ?           2604    37852 	   orders id    DEFAULT     f   ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);
 8   ALTER TABLE public.orders ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    220    221    221         ?           2604    37918    rider_logs id    DEFAULT     n   ALTER TABLE ONLY public.rider_logs ALTER COLUMN id SET DEFAULT nextval('public.rider_logs_id_seq'::regclass);
 <   ALTER TABLE public.rider_logs ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    227    226    227         ?           2604    37900    rider_tracks id    DEFAULT     r   ALTER TABLE ONLY public.rider_tracks ALTER COLUMN id SET DEFAULT nextval('public.rider_tracks_id_seq'::regclass);
 >   ALTER TABLE public.rider_tracks ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    225    224    225         ?           2604    37809 	   riders id    DEFAULT     f   ALTER TABLE ONLY public.riders ALTER COLUMN id SET DEFAULT nextval('public.riders_id_seq'::regclass);
 8   ALTER TABLE public.riders ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    218    219    219         ?           2604    37946    store_applications id    DEFAULT     ~   ALTER TABLE ONLY public.store_applications ALTER COLUMN id SET DEFAULT nextval('public.store_applications_id_seq'::regclass);
 D   ALTER TABLE public.store_applications ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    228    229    229         ?           2604    37742    store_products id    DEFAULT     v   ALTER TABLE ONLY public.store_products ALTER COLUMN id SET DEFAULT nextval('public.store_products_id_seq'::regclass);
 @   ALTER TABLE public.store_products ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    211    210    211         ?           2604    37704 	   stores id    DEFAULT     f   ALTER TABLE ONLY public.stores ALTER COLUMN id SET DEFAULT nextval('public.stores_id_seq'::regclass);
 8   ALTER TABLE public.stores ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    208    209    209         ?           2604    37648    user_addresses id    DEFAULT     v   ALTER TABLE ONLY public.user_addresses ALTER COLUMN id SET DEFAULT nextval('public.user_addresses_id_seq'::regclass);
 @   ALTER TABLE public.user_addresses ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    205    204    205         ?           2604    37632    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    203    202    203         ?           2604    37775    variant_options id    DEFAULT     x   ALTER TABLE ONLY public.variant_options ALTER COLUMN id SET DEFAULT nextval('public.variant_options_id_seq'::regclass);
 A   ALTER TABLE public.variant_options ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    215    214    215         ?           2604    37761    variants id    DEFAULT     j   ALTER TABLE ONLY public.variants ALTER COLUMN id SET DEFAULT nextval('public.variants_id_seq'::regclass);
 :   ALTER TABLE public.variants ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    212    213    213         ?          0    37789    additionals 
   TABLE DATA           ?   COPY public.additionals (id, store_id, name, price, customer_price, seller_price, status, "createdAt", "updatedAt") FROM stdin;
    public          postgres    false    217       3263.dat ?          0    19209    carts 
   TABLE DATA           ?   COPY public.carts (id, store_id, user_id, store_product_id, product_details, total_price, customer_total_price, seller_total_price, choices, additionals, quantity, note, status, "createdAt", "updatedAt") FROM stdin;
    public          postgres    false    201       3247.dat ?          0    37876    chats 
   TABLE DATA           L   COPY public.chats (id, user_id, order_id, message, "createdAt") FROM stdin;
    public          postgres    false    223       3269.dat ?          0    37661 	   districts 
   TABLE DATA           Q   COPY public.districts (id, name, zip_code, "createdAt", "updatedAt") FROM stdin;
    public          postgres    false    207       3253.dat ?          0    37849    orders 
   TABLE DATA           ?   COPY public.orders (id, so_id, store_id, user_id, rider_id, status, products, fee, timeframe, address, payment, contract_type, note, reason, "createdAt", "updatedAt") FROM stdin;
    public          postgres    false    221       3267.dat ?          0    37915 
   rider_logs 
   TABLE DATA           W   COPY public.rider_logs (id, rider_id, status_from, status_to, "createdAt") FROM stdin;
    public          postgres    false    227       3273.dat ?          0    37897    rider_tracks 
   TABLE DATA           U   COPY public.rider_tracks (id, rider_id, order_id, location, "createdAt") FROM stdin;
    public          postgres    false    225       3271.dat ?          0    37806    riders 
   TABLE DATA           r   COPY public.riders (id, user_id, photo, status, latitude, longitude, motorcycle_details, "createdAt") FROM stdin;
    public          postgres    false    219       3265.dat ?          0    37943    store_applications 
   TABLE DATA           ?   COPY public.store_applications (id, business_name, business_type, district_id, contact_person, email, contact_number, business_address, status, tracking_number, "createdAt", "updatedAt") FROM stdin;
    public          postgres    false    229       3275.dat ?          0    37739    store_products 
   TABLE DATA           ?   COPY public.store_products (id, store_id, name, description, image, price, customer_price, seller_price, variants, additionals, quantity, max_order, category, status, "createdAt", "updatedAt") FROM stdin;
    public          postgres    false    211       3257.dat ?          0    37701    stores 
   TABLE DATA           n  COPY public.stores (id, user_id, district_id, name, description, latitude, longitude, location_name, status, stature, type, contract_type, category, country, state, city, barangay, rating, logo_url, photo_url, sunday, sunday_opening_time, sunday_closing_time, monday, monday_opening_time, monday_closing_time, tuesday, tuesday_opening_time, tuesday_closing_time, wednesday, wednesday_opening_time, wednesday_closing_time, thursday, thursday_opening_time, thursday_closing_time, friday, friday_opening_time, friday_closing_time, saturday, saturday_opening_time, saturday_closing_time, "createdAt", "updatedAt") FROM stdin;
    public          postgres    false    209       3255.dat ?          0    37645    user_addresses 
   TABLE DATA           a   COPY public.user_addresses (id, user_id, name, location, address, note, "createdAt") FROM stdin;
    public          postgres    false    205       3251.dat ?          0    37629    users 
   TABLE DATA           ?   COPY public.users (id, name, email, password, provider, provider_token, token, role, cellphone_number, cellphone_status, status, "createdAt", "updatedAt") FROM stdin;
    public          postgres    false    203       3249.dat ?          0    37772    variant_options 
   TABLE DATA           ?   COPY public.variant_options (id, variant_id, name, price, customer_price, seller_price, status, "createdAt", "updatedAt") FROM stdin;
    public          postgres    false    215       3261.dat ?          0    37758    variants 
   TABLE DATA           X   COPY public.variants (id, store_id, type, status, "createdAt", "updatedAt") FROM stdin;
    public          postgres    false    213       3259.dat ?           0    0    additionals_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.additionals_id_seq', 33, true);
          public          postgres    false    216         ?           0    0    carts_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.carts_id_seq', 15, true);
          public          postgres    false    200         ?           0    0    chats_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.chats_id_seq', 98, true);
          public          postgres    false    222         ?           0    0    districts_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.districts_id_seq', 20, true);
          public          postgres    false    206         ?           0    0    orders_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.orders_id_seq', 55, true);
          public          postgres    false    220         ?           0    0    rider_logs_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.rider_logs_id_seq', 1, false);
          public          postgres    false    226         ?           0    0    rider_tracks_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.rider_tracks_id_seq', 5759, true);
          public          postgres    false    224         ?           0    0    riders_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.riders_id_seq', 10, true);
          public          postgres    false    218         ?           0    0    store_applications_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.store_applications_id_seq', 1, false);
          public          postgres    false    228         ?           0    0    store_products_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.store_products_id_seq', 40, true);
          public          postgres    false    210         ?           0    0    stores_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.stores_id_seq', 12, true);
          public          postgres    false    208         ?           0    0    user_addresses_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.user_addresses_id_seq', 6, true);
          public          postgres    false    204         ?           0    0    users_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.users_id_seq', 33, true);
          public          postgres    false    202         ?           0    0    variant_options_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.variant_options_id_seq', 72, true);
          public          postgres    false    214         ?           0    0    variants_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.variants_id_seq', 22, true);
          public          postgres    false    212                    2606    37798    additionals additionals_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.additionals
    ADD CONSTRAINT additionals_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.additionals DROP CONSTRAINT additionals_pkey;
       public            postgres    false    217         ?           2606    19219    carts carts_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.carts
    ADD CONSTRAINT carts_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.carts DROP CONSTRAINT carts_pkey;
       public            postgres    false    201                    2606    37884    chats chats_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.chats
    ADD CONSTRAINT chats_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.chats DROP CONSTRAINT chats_pkey;
       public            postgres    false    223                    2606    37666    districts districts_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.districts
    ADD CONSTRAINT districts_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.districts DROP CONSTRAINT districts_pkey;
       public            postgres    false    207                    2606    37858    orders orders_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_pkey;
       public            postgres    false    221                    2606    37920    rider_logs rider_logs_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.rider_logs
    ADD CONSTRAINT rider_logs_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.rider_logs DROP CONSTRAINT rider_logs_pkey;
       public            postgres    false    227                    2606    37902    rider_tracks rider_tracks_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.rider_tracks
    ADD CONSTRAINT rider_tracks_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.rider_tracks DROP CONSTRAINT rider_tracks_pkey;
       public            postgres    false    225                    2606    37816    riders riders_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.riders
    ADD CONSTRAINT riders_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.riders DROP CONSTRAINT riders_pkey;
       public            postgres    false    219                    2606    37953 *   store_applications store_applications_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.store_applications
    ADD CONSTRAINT store_applications_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.store_applications DROP CONSTRAINT store_applications_pkey;
       public            postgres    false    229                    2606    37750 "   store_products store_products_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.store_products
    ADD CONSTRAINT store_products_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.store_products DROP CONSTRAINT store_products_pkey;
       public            postgres    false    211                    2606    37719    stores stores_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.stores
    ADD CONSTRAINT stores_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.stores DROP CONSTRAINT stores_pkey;
       public            postgres    false    209                    2606    37653 "   user_addresses user_addresses_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.user_addresses
    ADD CONSTRAINT user_addresses_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.user_addresses DROP CONSTRAINT user_addresses_pkey;
       public            postgres    false    205                     2606    37642    users users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    203                    2606    37781 $   variant_options variant_options_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.variant_options
    ADD CONSTRAINT variant_options_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.variant_options DROP CONSTRAINT variant_options_pkey;
       public            postgres    false    215         
           2606    37764    variants variants_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.variants
    ADD CONSTRAINT variants_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.variants DROP CONSTRAINT variants_pkey;
       public            postgres    false    213         !           2606    37799 %   additionals additionals_store_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.additionals
    ADD CONSTRAINT additionals_store_id_fkey FOREIGN KEY (store_id) REFERENCES public.stores(id) ON UPDATE CASCADE ON DELETE CASCADE;
 O   ALTER TABLE ONLY public.additionals DROP CONSTRAINT additionals_store_id_fkey;
       public          postgres    false    209    217    3078         '           2606    37890    chats chats_order_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.chats
    ADD CONSTRAINT chats_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON UPDATE CASCADE ON DELETE CASCADE;
 C   ALTER TABLE ONLY public.chats DROP CONSTRAINT chats_order_id_fkey;
       public          postgres    false    223    3090    221         &           2606    37885    chats chats_user_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.chats
    ADD CONSTRAINT chats_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;
 B   ALTER TABLE ONLY public.chats DROP CONSTRAINT chats_user_id_fkey;
       public          postgres    false    223    3072    203         %           2606    37869    orders orders_rider_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_rider_id_fkey FOREIGN KEY (rider_id) REFERENCES public.riders(id) ON UPDATE CASCADE;
 E   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_rider_id_fkey;
       public          postgres    false    3088    219    221         #           2606    37859    orders orders_store_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_store_id_fkey FOREIGN KEY (store_id) REFERENCES public.stores(id) ON UPDATE CASCADE ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_store_id_fkey;
       public          postgres    false    221    3078    209         $           2606    37864    orders orders_user_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE;
 D   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_user_id_fkey;
       public          postgres    false    221    3072    203         *           2606    37921 #   rider_logs rider_logs_rider_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.rider_logs
    ADD CONSTRAINT rider_logs_rider_id_fkey FOREIGN KEY (rider_id) REFERENCES public.riders(id) ON UPDATE CASCADE ON DELETE CASCADE;
 M   ALTER TABLE ONLY public.rider_logs DROP CONSTRAINT rider_logs_rider_id_fkey;
       public          postgres    false    227    3088    219         )           2606    37908 '   rider_tracks rider_tracks_order_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.rider_tracks
    ADD CONSTRAINT rider_tracks_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON UPDATE CASCADE ON DELETE SET NULL;
 Q   ALTER TABLE ONLY public.rider_tracks DROP CONSTRAINT rider_tracks_order_id_fkey;
       public          postgres    false    225    221    3090         (           2606    37903 '   rider_tracks rider_tracks_rider_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.rider_tracks
    ADD CONSTRAINT rider_tracks_rider_id_fkey FOREIGN KEY (rider_id) REFERENCES public.riders(id) ON UPDATE CASCADE ON DELETE CASCADE;
 Q   ALTER TABLE ONLY public.rider_tracks DROP CONSTRAINT rider_tracks_rider_id_fkey;
       public          postgres    false    225    219    3088         "           2606    37817    riders riders_user_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.riders
    ADD CONSTRAINT riders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;
 D   ALTER TABLE ONLY public.riders DROP CONSTRAINT riders_user_id_fkey;
       public          postgres    false    203    3072    219         +           2606    37954 6   store_applications store_applications_district_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.store_applications
    ADD CONSTRAINT store_applications_district_id_fkey FOREIGN KEY (district_id) REFERENCES public.districts(id) ON UPDATE CASCADE;
 `   ALTER TABLE ONLY public.store_applications DROP CONSTRAINT store_applications_district_id_fkey;
       public          postgres    false    229    3076    207                    2606    37751 +   store_products store_products_store_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.store_products
    ADD CONSTRAINT store_products_store_id_fkey FOREIGN KEY (store_id) REFERENCES public.stores(id) ON UPDATE CASCADE ON DELETE CASCADE;
 U   ALTER TABLE ONLY public.store_products DROP CONSTRAINT store_products_store_id_fkey;
       public          postgres    false    209    211    3078                    2606    37725    stores stores_district_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.stores
    ADD CONSTRAINT stores_district_id_fkey FOREIGN KEY (district_id) REFERENCES public.districts(id) ON UPDATE CASCADE;
 H   ALTER TABLE ONLY public.stores DROP CONSTRAINT stores_district_id_fkey;
       public          postgres    false    3076    209    207                    2606    37720    stores stores_user_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.stores
    ADD CONSTRAINT stores_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;
 D   ALTER TABLE ONLY public.stores DROP CONSTRAINT stores_user_id_fkey;
       public          postgres    false    203    209    3072                    2606    37654 *   user_addresses user_addresses_user_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.user_addresses
    ADD CONSTRAINT user_addresses_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;
 T   ALTER TABLE ONLY public.user_addresses DROP CONSTRAINT user_addresses_user_id_fkey;
       public          postgres    false    203    3072    205                     2606    37782 /   variant_options variant_options_variant_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.variant_options
    ADD CONSTRAINT variant_options_variant_id_fkey FOREIGN KEY (variant_id) REFERENCES public.variants(id) ON UPDATE CASCADE ON DELETE CASCADE;
 Y   ALTER TABLE ONLY public.variant_options DROP CONSTRAINT variant_options_variant_id_fkey;
       public          postgres    false    213    3082    215                    2606    37765    variants variants_store_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.variants
    ADD CONSTRAINT variants_store_id_fkey FOREIGN KEY (store_id) REFERENCES public.stores(id) ON UPDATE CASCADE ON DELETE CASCADE;
 I   ALTER TABLE ONLY public.variants DROP CONSTRAINT variants_store_id_fkey;
       public          postgres    false    3078    213    209                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            3263.dat                                                                                            0000600 0004000 0002000 00000005412 14024343251 0014247 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	1	Extra Rice	15	15.00	13.95	t	2021-03-17 05:56:17.034+00	2021-03-17 05:56:17.034+00
2	1	Extra Kimchi	20	20.00	18.60	t	2021-03-17 05:56:17.037+00	2021-03-17 05:56:17.037+00
3	1	Egg	10	10.00	9.30	t	2021-03-17 05:56:17.04+00	2021-03-17 05:56:17.04+00
4	1	Extra Soup	30	30.00	27.90	t	2021-03-17 05:56:17.043+00	2021-03-17 05:56:17.043+00
5	1	Sausage	35	35.00	32.55	t	2021-03-17 05:56:17.047+00	2021-03-17 05:56:17.047+00
6	2	Whipped Cream	15	16.05	15.00	t	2021-03-17 05:56:17.11+00	2021-03-17 05:56:17.11+00
7	3	Whipped Cream	15	15.00	13.95	t	2021-03-17 05:56:17.171+00	2021-03-17 05:56:17.171+00
8	4	Extra Cheese	40	40.00	37.20	t	2021-03-17 05:56:17.227+00	2021-03-17 05:56:17.227+00
9	8	Extra Rice	15	15.00	13.95	t	2021-03-17 05:56:17.442+00	2021-03-17 05:56:17.442+00
10	8	Extra Kimchi	20	20.00	18.60	t	2021-03-17 05:56:17.445+00	2021-03-17 05:56:17.445+00
11	8	Egg	10	10.00	9.30	t	2021-03-17 05:56:17.448+00	2021-03-17 05:56:17.448+00
12	8	Extra Soup	30	30.00	27.90	t	2021-03-17 05:56:17.451+00	2021-03-17 05:56:17.451+00
13	8	Sausage	35	35.00	32.55	t	2021-03-17 05:56:17.454+00	2021-03-17 05:56:17.454+00
14	9	Extra Rice	15	15.00	13.95	t	2021-03-17 05:56:17.538+00	2021-03-17 05:56:17.538+00
15	9	Extra Kimchi	20	20.00	18.60	t	2021-03-17 05:56:17.541+00	2021-03-17 05:56:17.541+00
16	9	Egg	10	10.00	9.30	t	2021-03-17 05:56:17.544+00	2021-03-17 05:56:17.544+00
17	9	Extra Soup	30	30.00	27.90	t	2021-03-17 05:56:17.547+00	2021-03-17 05:56:17.547+00
18	9	Sausage	35	35.00	32.55	t	2021-03-17 05:56:17.55+00	2021-03-17 05:56:17.55+00
19	10	Extra Rice	15	15.00	13.95	t	2021-03-17 05:56:17.627+00	2021-03-17 05:56:17.627+00
20	10	Extra Kimchi	20	20.00	18.60	t	2021-03-17 05:56:17.636+00	2021-03-17 05:56:17.636+00
21	10	Egg	10	10.00	9.30	t	2021-03-17 05:56:17.64+00	2021-03-17 05:56:17.64+00
22	10	Extra Soup	30	30.00	27.90	t	2021-03-17 05:56:17.644+00	2021-03-17 05:56:17.644+00
23	10	Sausage	35	35.00	32.55	t	2021-03-17 05:56:17.648+00	2021-03-17 05:56:17.648+00
24	11	Extra Rice	15	15.00	13.95	t	2021-03-17 05:56:17.755+00	2021-03-17 05:56:17.755+00
25	11	Extra Kimchi	20	20.00	18.60	t	2021-03-17 05:56:17.759+00	2021-03-17 05:56:17.759+00
26	11	Egg	10	10.00	9.30	t	2021-03-17 05:56:17.762+00	2021-03-17 05:56:17.762+00
27	11	Extra Soup	30	30.00	27.90	t	2021-03-17 05:56:17.765+00	2021-03-17 05:56:17.765+00
28	11	Sausage	35	35.00	32.55	t	2021-03-17 05:56:17.772+00	2021-03-17 05:56:17.772+00
29	12	Extra Rice	15	15.00	13.95	t	2021-03-17 05:56:17.867+00	2021-03-17 05:56:17.867+00
30	12	Extra Kimchi	20	20.00	18.60	t	2021-03-17 05:56:17.87+00	2021-03-17 05:56:17.87+00
31	12	Egg	10	10.00	9.30	t	2021-03-17 05:56:17.873+00	2021-03-17 05:56:17.873+00
32	12	Extra Soup	30	30.00	27.90	t	2021-03-17 05:56:17.878+00	2021-03-17 05:56:17.878+00
33	12	Sausage	35	35.00	32.55	t	2021-03-17 05:56:17.882+00	2021-03-17 05:56:17.882+00
\.


                                                                                                                                                                                                                                                      3247.dat                                                                                            0000600 0004000 0002000 00000012020 14024343251 0014242 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	3	24	7	{"name":"Americano","price":"130.00","customer_price":"130.00","seller_price":"120.90","image":"http://18.166.234.218:8000/public/store/restaurants/3-1.png"}	495.00	495.00	460.35	[{"id":1,"pick_id":2,"name":"Size","price":"20.00","customer_price":"20.00","seller_price":"18.60","pick":"Medium"}]	[{"id":1,"name":"Whipped Cream","price":"15.00","customer_price":"15.00","seller_price":"13.95"}]	3	\N	ordered	2021-02-19 07:30:13.363+00	2021-02-19 07:44:41.706+00
2	3	24	7	{"name":"Americano","price":"130.00","customer_price":"130.00","seller_price":"120.90","image":"http://18.166.234.218:8000/public/store/restaurants/3-1.png"}	330.00	330.00	306.90	[{"id":1,"pick_id":2,"name":"Size","price":"20.00","customer_price":"20.00","seller_price":"18.60","pick":"Medium"}]	[{"id":1,"name":"Whipped Cream","price":"15.00","customer_price":"15.00","seller_price":"13.95"}]	2	\N	ordered	2021-02-19 07:31:17.563+00	2021-02-19 07:44:41.706+00
3	3	24	9	{"name":"Coldbrew","price":"60.00","customer_price":"60.00","seller_price":"55.80","image":"http://18.166.234.218:8000/public/store/restaurants/3-3.jpg"}	60.00	60.00	55.80	[]	[]	1	\N	ordered	2021-02-19 07:31:23.902+00	2021-02-19 07:44:41.706+00
6	3	24	9	{"name":"Coldbrew","price":"60.00","customer_price":"60.00","seller_price":"55.80","image":"http://18.166.234.218:8000/public/store/restaurants/3-3.jpg"}	60.00	60.00	55.80	[]	[]	1	\N	ordered	2021-02-19 07:33:49.846+00	2021-02-19 07:44:41.706+00
5	3	24	7	{"name":"Americano","price":"130.00","customer_price":"130.00","seller_price":"120.90","image":"http://18.166.234.218:8000/public/store/restaurants/3-1.png"}	330.00	330.00	306.90	[{"id":1,"pick_id":2,"name":"Size","price":"20.00","customer_price":"20.00","seller_price":"18.60","pick":"Medium"}]	[{"id":1,"name":"Whipped Cream","price":"15.00","customer_price":"15.00","seller_price":"13.95"}]	2	\N	ordered	2021-02-19 07:33:45.952+00	2021-02-19 07:44:41.706+00
7	3	24	9	{"name":"Coldbrew","price":"60.00","customer_price":"60.00","seller_price":"55.80","image":"http://18.166.234.218:8000/public/store/restaurants/3-3.jpg"}	60.00	60.00	55.80	[]	[]	1	\N	ordered	2021-02-19 07:36:10.024+00	2021-02-19 07:44:41.706+00
4	6	24	18	{"name":"Durian","price":"260.00","customer_price":"269.08","seller_price":"250.90","image":"http://18.166.234.218:8000/public/store/restaurants/6-3.png"}	260.00	269.09	250.90	[]	[]	1	\N	ordered	2021-02-19 07:32:31.346+00	2021-02-19 07:46:21.836+00
8	3	24	7	{"name":"Americano","price":"130.00","customer_price":"130.00","seller_price":"120.90","image":"http://18.166.234.218:8000/public/store/restaurants/3-1.png"}	330.00	330.00	306.90	[{"id":1,"pick_id":2,"name":"Size","price":"20.00","customer_price":"20.00","seller_price":"18.60","pick":"Medium"}]	[{"id":1,"name":"Whipped Cream","price":"15.00","customer_price":"15.00","seller_price":"13.95"}]	2	\N	ordered	2021-02-19 07:37:07.355+00	2021-02-19 07:44:41.706+00
9	3	24	9	{"name":"Coldbrew","price":"60.00","customer_price":"60.00","seller_price":"55.80","image":"http://18.166.234.218:8000/public/store/restaurants/3-3.jpg"}	60.00	60.00	55.80	[]	[]	1	\N	ordered	2021-02-19 07:37:19.416+00	2021-02-19 07:44:41.706+00
10	3	24	7	{"name":"Americano","price":"130.00","customer_price":"130.00","seller_price":"120.90","image":"http://18.166.234.218:8000/public/store/restaurants/3-1.png"}	330.00	330.00	306.90	[{"id":1,"pick_id":2,"name":"Size","price":"20.00","customer_price":"20.00","seller_price":"18.60","pick":"Medium"}]	[{"id":1,"name":"Whipped Cream","price":"15.00","customer_price":"15.00","seller_price":"13.95"}]	2	\N	ordered	2021-02-19 07:41:51.659+00	2021-02-19 07:44:41.706+00
11	3	24	9	{"name":"Coldbrew","price":"60.00","customer_price":"60.00","seller_price":"55.80","image":"http://18.166.234.218:8000/public/store/restaurants/3-3.jpg"}	60.00	60.00	55.80	[]	[]	1	\N	ordered	2021-02-19 07:41:56.258+00	2021-02-19 07:44:41.706+00
12	3	24	7	{"name":"Americano","price":"130.00","customer_price":"130.00","seller_price":"120.90","image":"http://18.166.234.218:8000/public/store/restaurants/3-1.png"}	330.00	330.00	306.90	[{"id":1,"pick_id":2,"name":"Size","price":"20.00","customer_price":"20.00","seller_price":"18.60","pick":"Medium"}]	[{"id":1,"name":"Whipped Cream","price":"15.00","customer_price":"15.00","seller_price":"13.95"}]	2	\N	ordered	2021-02-19 07:44:28.517+00	2021-02-19 07:44:41.706+00
13	3	24	9	{"name":"Coldbrew","price":"60.00","customer_price":"60.00","seller_price":"55.80","image":"http://18.166.234.218:8000/public/store/restaurants/3-3.jpg"}	60.00	60.00	55.80	[]	[]	1	\N	ordered	2021-02-19 07:44:33.314+00	2021-02-19 07:44:41.706+00
14	6	24	16	{"name":"Shabu Shabu Mix","price":"510.00","customer_price":"527.84","seller_price":"492.15","image":"http://18.166.234.218:8000/public/store/restaurants/6-1.png"}	510.00	527.84	492.15	[]	[]	1	\N	ordered	2021-02-19 07:46:06.747+00	2021-02-19 07:46:21.836+00
15	6	24	19	{"name":"Samanco","price":"30.00","customer_price":"31.04","seller_price":"28.95","image":"http://18.166.234.218:8000/public/store/restaurants/6-4.png"}	60.00	62.08	57.90	[]	[]	2	\N	ordered	2021-02-19 07:46:15.379+00	2021-02-19 07:46:21.836+00
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                3269.dat                                                                                            0000600 0004000 0002000 00000021306 14024343251 0014255 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	14	1	Hi, This is your driver John Carlos. I'm currently on the way to the store to pick up your order.	2021-03-17 06:24:16.332+00
2	14	1	Your order has been picked up by your Driver	2021-03-17 06:24:47.424+00
3	26	1	hi po	2021-03-17 06:25:18.771+00
4	15	7	Hi, This is your driver Carl Manahan. I'm currently on the way to the store to pick up your order.	2021-03-17 06:34:05.309+00
5	23	4	Hi, This is your driver Dave Dawne. I'm currently on the way to the store to pick up your order.	2021-03-17 06:34:58.207+00
6	22	5	Hi, This is your driver Ian Santos. I'm currently on the way to the store to pick up your order.	2021-03-17 06:35:04.78+00
7	21	6	Hi, This is your driver Matthew Dolores. I'm currently on the way to the store to pick up your order.	2021-03-17 06:35:10.744+00
8	30	4	Kuya, sa office lang ako	2021-03-17 06:35:19.787+00
9	14	15	Hi, This is your driver John Carlos. I'm currently on the way to the store to pick up your order.	2021-03-17 06:39:02.013+00
10	20	16	Hi, This is your driver Mark Dimagiba. I'm currently on the way to the store to pick up your order.	2021-03-17 06:40:27.315+00
11	29	16	hi	2021-03-17 06:40:46.94+00
12	17	23	Hi, This is your driver Nicolo Dizon. I'm currently on the way to the store to pick up your order.	2021-03-17 06:41:03.693+00
13	16	24	Hi, This is your driver Dexter Manahan. I'm currently on the way to the store to pick up your order.	2021-03-17 06:41:44.291+00
14	18	26	Hi, This is your driver Joed. I'm currently on the way to the store to pick up your order.	2021-03-17 06:42:23.893+00
15	19	29	Hi, This is your driver Aldrin Manalo. I'm currently on the way to the store to pick up your order.	2021-03-17 06:43:05.665+00
16	14	15	sir sino po ang tao dto sa one mart	2021-03-17 06:46:51.67+00
17	26	15	one mart emloyee po mismo	2021-03-17 06:47:25.935+00
18	14	15	Your order has been picked up by your Driver	2021-03-17 06:47:30.688+00
19	15	7	Your order has been picked up by your Driver	2021-03-17 06:47:31.867+00
20	19	29	Your order has been picked up by your Driver	2021-03-17 06:48:11.146+00
21	19	29	good afternoon on the way to deliver your order at seven eleven	2021-03-17 06:49:46.985+00
22	32	29	hello	2021-03-17 06:49:54.85+00
23	15	7	saan po sa santateresita po?	2021-03-17 06:50:19.563+00
24	17	23	Your order has been picked up by your Driver	2021-03-17 06:50:43.404+00
25	14	15	haha kala ko d kasali un haha	2021-03-17 06:51:59.581+00
26	17	23	sir s falg fall ka lng ba??	2021-03-17 06:53:04.811+00
27	32	23	opo	2021-03-17 06:53:09.304+00
28	32	23	see you	2021-03-17 06:53:14.999+00
29	17	23	ok coppy	2021-03-17 06:53:31.894+00
30	20	16	Your order has been picked up by your Driver	2021-03-17 06:53:33.782+00
31	16	24	Your order has been picked up by your Driver	2021-03-17 06:53:49.782+00
32	16	24	hello sir.. where drop point? 	2021-03-17 06:54:38.647+00
33	30	24	lets bee office lang kuya	2021-03-17 06:54:56.162+00
34	30	24	sa taas	2021-03-17 06:54:57.991+00
35	16	24	ok po.. on the way n. 	2021-03-17 06:55:17.767+00
36	30	24	sige kuya ingat	2021-03-17 06:55:35.331+00
37	22	5	Your order has been picked up by your Driver	2021-03-17 06:58:40.73+00
38	21	6	Your order has been picked up by your Driver	2021-03-17 06:58:46.499+00
39	18	26	Your order has been picked up by your Driver	2021-03-17 06:58:56.112+00
40	19	8	Hi, This is your driver Aldrin Manalo. I'm currently on the way to the store to pick up your order.	2021-03-17 06:59:10.652+00
41	23	4	Your order has been picked up by your Driver	2021-03-17 07:00:43.014+00
42	14	10	Hi, This is your driver John Carlos. I'm currently on the way to the store to pick up your order.	2021-03-17 07:01:59.117+00
43	20	3	Hi, This is your driver Mark Dimagiba. I'm currently on the way to the store to pick up your order.	2021-03-17 07:02:20.359+00
44	29	8	hi	2021-03-17 07:03:53.033+00
45	21	6	sir san banda po exact location nyo	2021-03-17 07:04:06.296+00
46	21	6	balibago po ba?	2021-03-17 07:04:15.756+00
47	22	5	sir good afternoon..this is letsbee delivery rider..where is your exact location ? thank you	2021-03-17 07:04:24.392+00
48	31	6	dito sa harap ng pagcor sa harap ng mga bangko dito sa diamond	2021-03-17 07:04:35.821+00
49	16	2	Hi, This is your driver Dexter Manahan. I'm currently on the way to the store to pick up your order.	2021-03-17 07:04:49.151+00
50	17	9	Hi, This is your driver Nicolo Dizon. I'm currently on the way to the store to pick up your order.	2021-03-17 07:04:51.238+00
51	31	5	sa mag harap ng pagcor sir, sa parking nga mga bangko sa side sa may diamond	2021-03-17 07:05:12.11+00
52	21	6	 ok sir	2021-03-17 07:05:24.935+00
53	15	14	Hi, This is your driver Carl Manahan. I'm currently on the way to the store to pick up your order.	2021-03-17 07:09:29.627+00
54	20	3	Your order has been picked up by your Driver	2021-03-17 07:12:27.255+00
55	14	10	Your order has been picked up by your Driver	2021-03-17 07:12:49.365+00
56	19	8	Your order has been picked up by your Driver	2021-03-17 07:15:16.448+00
57	19	8	hello sir on the way to deliver your order at bloomoing angel cafe	2021-03-17 07:16:20.996+00
58	29	8	Okay sir thanks	2021-03-17 07:16:31.907+00
59	16	2	Your order has been picked up by your Driver	2021-03-17 07:18:22.55+00
60	17	9	Your order has been picked up by your Driver	2021-03-17 07:18:42.53+00
61	16	2	good afternoon sir france	2021-03-17 07:18:43.351+00
62	16	2	where you	2021-03-17 07:19:03.131+00
63	18	19	Hi, This is your driver Joed. I'm currently on the way to the store to pick up your order.	2021-03-17 07:19:49.455+00
64	22	36	Hi, This is your driver Ian Santos. I'm currently on the way to the store to pick up your order.	2021-03-17 07:20:40.186+00
65	21	32	Hi, This is your driver Matthew Dolores. I'm currently on the way to the store to pick up your order.	2021-03-17 07:20:42.016+00
66	20	3	hello po... where are you po?	2021-03-17 07:23:49.036+00
67	14	44	Hi, This is your driver John Carlos. I'm currently on the way to the store to pick up your order.	2021-03-17 07:23:57.019+00
68	31	3	dito po sa harap ng metrobank at bpi balibago, harap din ng pagcor casino	2021-03-17 07:24:18.567+00
69	23	21	Hi, This is your driver Dave Dawne. I'm currently on the way to the store to pick up your order.	2021-03-17 07:24:31.751+00
70	15	14	Your order has been picked up by your Driver	2021-03-17 07:25:35.853+00
71	15	14	wer in yukon sir?	2021-03-17 07:26:12.385+00
72	15	14	lets bee office?	2021-03-17 07:26:19.357+00
73	30	14	opo	2021-03-17 07:26:44.768+00
74	30	14	sa office mismo	2021-03-17 07:26:51.984+00
75	14	44	Your order has been picked up by your Driver	2021-03-17 07:28:23.068+00
76	21	32	Your order has been picked up by your Driver	2021-03-17 07:28:27.142+00
77	22	36	Your order has been picked up by your Driver	2021-03-17 07:28:54.431+00
78	20	40	Hi, This is your driver Mark Dimagiba. I'm currently on the way to the store to pick up your order.	2021-03-17 07:30:18.793+00
79	17	35	Hi, This is your driver Nicolo Dizon. I'm currently on the way to the store to pick up your order.	2021-03-17 07:30:24.062+00
80	19	46	Hi, This is your driver Aldrin Manalo. I'm currently on the way to the store to pick up your order.	2021-03-17 07:30:31.154+00
81	14	41	Hi, This is your driver John Carlos. I'm currently on the way to the store to pick up your order.	2021-03-17 07:33:40.297+00
82	22	28	Hi, This is your driver Ian Santos. I'm currently on the way to the store to pick up your order.	2021-03-17 07:34:50.329+00
83	18	19	Your order has been picked up by your Driver	2021-03-17 07:35:36.337+00
84	21	52	Hi, This is your driver Matthew Dolores. I'm currently on the way to the store to pick up your order.	2021-03-17 07:35:45.642+00
85	19	46	Your order has been picked up by your Driver	2021-03-17 07:36:32.941+00
86	15	47	Hi, This is your driver Carl Manahan. I'm currently on the way to the store to pick up your order.	2021-03-17 07:37:49.952+00
87	21	52	Your order has been picked up by your Driver	2021-03-17 07:39:36.585+00
88	19	54	Hi, This is your driver Aldrin Manalo. I'm currently on the way to the store to pick up your order.	2021-03-17 07:42:29.912+00
89	23	21	Your order has been picked up by your Driver	2021-03-17 07:42:58.081+00
90	14	41	Your order has been picked up by your Driver	2021-03-17 07:45:06.662+00
91	22	28	Your order has been picked up by your Driver	2021-03-17 07:45:09.075+00
92	20	40	Your order has been picked up by your Driver	2021-03-17 07:46:28.886+00
93	17	35	Your order has been picked up by your Driver	2021-03-17 07:49:19.607+00
94	15	47	Your order has been picked up by your Driver	2021-03-17 07:52:58.616+00
95	19	54	Your order has been picked up by your Driver	2021-03-17 07:54:52.983+00
96	32	21	san po kayo	2021-03-17 07:55:18.647+00
97	21	31	Hi, This is your driver Matthew Dolores. I'm currently on the way to the store to pick up your order.	2021-03-17 08:17:53.008+00
98	21	31	Your order has been picked up by your Driver	2021-03-17 08:19:07.428+00
\.


                                                                                                                                                                                                                                                                                                                          3253.dat                                                                                            0000600 0004000 0002000 00000002545 14024343251 0014252 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	all	\N	2021-03-17 05:56:16.81+00	2021-03-17 05:56:16.81+00
2	Angeles City	2009	2021-03-17 05:56:16.82+00	2021-03-17 05:56:16.82+00
3	Mabalacat	2010	2021-03-17 05:56:16.823+00	2021-03-17 05:56:16.823+00
4	San Fernando	2000	2021-03-17 05:56:16.826+00	2021-03-17 05:56:16.826+00
5	Manila	\N	2021-03-17 05:56:16.831+00	2021-03-17 05:56:16.831+00
6	Caloocan	\N	2021-03-17 05:56:16.835+00	2021-03-17 05:56:16.835+00
7	Las Pinas	\N	2021-03-17 05:56:16.842+00	2021-03-17 05:56:16.842+00
8	Makati	\N	2021-03-17 05:56:16.85+00	2021-03-17 05:56:16.85+00
9	Malabon	\N	2021-03-17 05:56:16.854+00	2021-03-17 05:56:16.854+00
10	Mandaluyong	\N	2021-03-17 05:56:16.857+00	2021-03-17 05:56:16.857+00
11	Marikina	\N	2021-03-17 05:56:16.859+00	2021-03-17 05:56:16.859+00
12	Muntinlupa	\N	2021-03-17 05:56:16.862+00	2021-03-17 05:56:16.862+00
13	Navotas	\N	2021-03-17 05:56:16.865+00	2021-03-17 05:56:16.865+00
14	paranaque	\N	2021-03-17 05:56:16.868+00	2021-03-17 05:56:16.868+00
15	pasay	\N	2021-03-17 05:56:16.871+00	2021-03-17 05:56:16.871+00
16	pasig	\N	2021-03-17 05:56:16.874+00	2021-03-17 05:56:16.874+00
17	Quezon City	\N	2021-03-17 05:56:16.877+00	2021-03-17 05:56:16.877+00
18	San Juan	\N	2021-03-17 05:56:16.88+00	2021-03-17 05:56:16.88+00
19	Taguig	\N	2021-03-17 05:56:16.883+00	2021-03-17 05:56:16.883+00
20	Valenzuela City	\N	2021-03-17 05:56:16.886+00	2021-03-17 05:56:16.886+00
\.


                                                                                                                                                           3267.dat                                                                                            0000600 0004000 0002000 00000155237 14024343251 0014266 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        8	2	2	29	6	delivered	[{"product_id":6,"name":"Dalgona Latte","price":"180","customer_price":"192.60","seller_price":"180.00","quantity":3,"variants":[{"type":"Choice of Drink Size","price":"30.00","customer_price":"32.10","seller_price":"30.00","pick":"Large"}],"additionals":[],"note":"","removable":false}]	{"sub_total":"674.09","delivery":"40.00","discount_code":null,"discount_price":0,"total_price":"630.00","customer_total_price":"714.09","seller_total_price":"630.00"}	{"store_pick_time":"2021-03-17T06:49:02.788Z","store_estimated_time":"30 Minutes","rider_pick_time":"2021-03-17T06:59:10.644Z","rider_pick_up_time":"2021-03-17T07:15:16.440Z","rider_estimated_time":null,"delivered_time":"2021-03-17T07:27:35.659Z","is_near":false}	{"location":{"lat":15.1625661,"lng":120.55650179999998},"complete_address":"355 Yukon St , Angeles Central Luzon","note":""}	{"method":"cod","status":"pending","details":{}}	markup			2021-03-17 06:34:07.209087+00	2021-03-17 07:27:35.673+00
1	1	6	26	1	delivered	[{"product_id":18,"name":"Durian","price":"260","customer_price":"269.09","seller_price":"250.90","quantity":1,"variants":[],"additionals":[],"note":"","removable":false}]	{"sub_total":"269.08","delivery":"10.00","discount_code":null,"discount_price":0,"total_price":"260.00","customer_total_price":"279.08","seller_total_price":"250.90"}	{"store_pick_time":null,"store_estimated_time":null,"rider_pick_time":"2021-03-17T06:24:16.326Z","rider_pick_up_time":"2021-03-17T06:24:47.416Z","rider_estimated_time":null,"delivered_time":"2021-03-17T06:27:01.847Z","is_near":false}	{"location":{"lat":15.162788633889923,"lng":120.55652439594269},"complete_address":"355 Yukon St , Angeles Central Luzon","note":"Let's Bee Office"}	{"method":"cod","status":"pending","details":{}}	half			2021-03-17 06:24:13.583371+00	2021-03-17 06:27:01.863+00
5	2	4	31	9	delivered	[{"product_id":11,"name":"Bulgogi Pizza","price":"499","customer_price":"499.00","seller_price":"464.07","quantity":1,"variants":[{"type":"Choice of Size","price":"100.00","customer_price":"100.00","seller_price":"93.00","pick":"Large"}],"additionals":[],"note":"","removable":false},{"product_id":10,"name":"Combination Pizza","price":"399","customer_price":"399.00","seller_price":"371.07","quantity":1,"variants":[{"type":"Choice of Size","price":"0.00","customer_price":"0.00","seller_price":"0.00","pick":"Regular"}],"additionals":[],"note":"","removable":false}]	{"sub_total":"998.00","delivery":"40.00","discount_code":null,"discount_price":0,"total_price":"998.00","customer_total_price":"1038.00","seller_total_price":"928.13"}	{"store_pick_time":"2021-03-17T06:35:03.415Z","store_estimated_time":"20 Minutes","rider_pick_time":"2021-03-17T06:35:04.775Z","rider_pick_up_time":"2021-03-17T06:58:40.713Z","rider_estimated_time":null,"delivered_time":"2021-03-17T07:15:49.899Z","is_near":false}	{"location":{"lat":15.164003763477075,"lng":120.59075877070427},"complete_address":"McArthur Highway Santa Teresita, Angeles City Pampanga","note":"INFRONT OF CASINO"}	{"method":"cod","status":"pending","details":{}}	commission			2021-03-17 06:32:02.395844+00	2021-03-17 07:15:49.92+00
6	3	4	31	8	delivered	[{"product_id":12,"name":"Cheese Tteokbokki","price":"249","customer_price":"249.00","seller_price":"231.57","quantity":1,"variants":[],"additionals":[],"note":"","removable":false}]	{"sub_total":"249.00","delivery":"40.00","discount_code":null,"discount_price":0,"total_price":"249.00","customer_total_price":"289.00","seller_total_price":"231.57"}	{"store_pick_time":"2021-03-17T06:35:09.487Z","store_estimated_time":"30 Minutes","rider_pick_time":"2021-03-17T06:35:10.739Z","rider_pick_up_time":"2021-03-17T06:58:46.496Z","rider_estimated_time":null,"delivered_time":"2021-03-17T07:15:35.055Z","is_near":false}	{"location":{"lat":15.164003763477075,"lng":120.59075877070427},"complete_address":"McArthur Highway Santa Teresita, Angeles City Pampanga","note":"INFRONT OF CASINO"}	{"method":"cod","status":"pending","details":{}}	commission			2021-03-17 06:32:55.306142+00	2021-03-17 07:15:35.072+00
9	2	5	30	4	delivered	[{"product_id":14,"name":"Origangjeong","price":"280","customer_price":"280.00","seller_price":"260.40","quantity":1,"variants":[],"additionals":[],"note":"","removable":false}]	{"sub_total":"280.00","delivery":"10.00","discount_code":null,"discount_price":0,"total_price":"280.00","customer_total_price":"290.00","seller_total_price":"260.39"}	{"store_pick_time":"2021-03-17T06:47:09.779Z","store_estimated_time":"20 Minutes","rider_pick_time":"2021-03-17T07:04:51.233Z","rider_pick_up_time":"2021-03-17T07:18:42.525Z","rider_estimated_time":null,"delivered_time":"2021-03-17T07:28:55.941Z","is_near":false}	{"location":{"lat":15.162618094504847,"lng":120.55654216557741},"complete_address":"Yukon Street Margot, Angeles City Pampanga","note":"Pasok lang sa office kuya sa taas."}	{"method":"cod","status":"pending","details":{}}	commission			2021-03-17 06:34:13.088653+00	2021-03-17 07:28:55.95+00
2	1	2	31	3	delivered	[{"product_id":6,"name":"Dalgona Latte","price":"180","customer_price":"192.60","seller_price":"180.00","quantity":2,"variants":[{"type":"Choice of Drink Size","price":"20.00","customer_price":"21.40","seller_price":"20.00","pick":"Medium"}],"additionals":[],"note":"","removable":false}]	{"sub_total":"428.00","delivery":"70.00","discount_code":null,"discount_price":0,"total_price":"400.00","customer_total_price":"498.00","seller_total_price":"400.00"}	{"store_pick_time":"2021-03-17T06:48:54.627Z","store_estimated_time":"30 Minutes","rider_pick_time":"2021-03-17T07:04:49.146Z","rider_pick_up_time":"2021-03-17T07:18:22.541Z","rider_estimated_time":null,"delivered_time":"2021-03-17T07:35:02.694Z","is_near":false}	{"location":{"lat":15.164003763477075,"lng":120.59075877070427},"complete_address":"McArthur Highway Santa Teresita, Angeles City Pampanga","note":"INFRONT OF CASINO"}	{"method":"cod","status":"pending","details":{}}	markup			2021-03-17 06:30:08.937225+00	2021-03-17 07:35:02.699+00
38	2	12	29	\N	cancelled	[{"product_id":38,"name":"Fried Chicken","price":"500","customer_price":"500.00","seller_price":"465.00","quantity":4,"variants":[{"type":"Choice A","price":"20.00","customer_price":"20.00","seller_price":"18.60","pick":"c"},{"type":"Choice B","price":"0.00","customer_price":"0.00","seller_price":"0.00","pick":"c"}],"additionals":[],"note":"","removable":true}]	{"sub_total":"2080.00","delivery":"10.00","discount_code":null,"discount_price":0,"total_price":"2080.00","customer_total_price":"2090.00","seller_total_price":"1934.40"}	\N	{"location":{"lat":15.1625661,"lng":120.55650179999998},"complete_address":"355 Yukon St , Angeles Central Luzon","note":""}	{"method":"cod","status":"pending","details":{}}	commission			2021-03-17 06:46:13.045274+00	2021-03-17 08:07:46.641+00
15	3	6	26	1	delivered	[{"product_id":19,"name":"Samanco","price":"30","customer_price":"31.04","seller_price":"28.95","quantity":5,"variants":[],"additionals":[],"note":"","removable":false}]	{"sub_total":"155.19","delivery":"10.00","discount_code":null,"discount_price":0,"total_price":"150.00","customer_total_price":"165.20","seller_total_price":"144.75"}	{"store_pick_time":null,"store_estimated_time":null,"rider_pick_time":"2021-03-17T06:39:01.939Z","rider_pick_up_time":"2021-03-17T06:47:30.682Z","rider_estimated_time":null,"delivered_time":"2021-03-17T07:00:54.024Z","is_near":false}	{"location":{"lat":15.162788633889923,"lng":120.55652439594269},"complete_address":"355 Yukon St , Angeles Central Luzon","note":"Let's Bee Office"}	{"status":"paid","details":{"ref_code":"6051a3b1e9bd3e3ff99b2f6b","payment_url":"https://checkout-staging.xendit.co/web/6051a3b1e9bd3e3ff99b2f6b","link":"https://bux.ph/test/payment/79a6523ab6b64070978313ca9344ca5f/","fee":0}}	half	lets bee office nd floor		2021-03-17 06:37:36.175147+00	2021-03-17 07:00:54.037+00
11	1	11	29	\N	cancelled	[{"product_id":37,"name":"Octopus sasimi","price":"350","customer_price":"350.00","seller_price":"325.50","quantity":2,"variants":[{"type":"Choice B","price":"0.00","customer_price":"0.00","seller_price":"0.00","pick":"b"}],"additionals":[{"id":25,"name":"Extra Kimchi","price":"20.00","customer_price":"20.00","seller_price":"18.60"}],"note":"more kimchi","removable":false}]	{"sub_total":"740.00","delivery":"10.00","discount_code":null,"discount_price":0,"total_price":"740.00","customer_total_price":"750.00","seller_total_price":"688.20"}	\N	{"location":{"lat":15.1625661,"lng":120.55650179999998},"complete_address":"355 Yukon St , Angeles Central Luzon","note":""}	{"method":"cod","status":"pending","details":{}}	commission			2021-03-17 06:35:29.346615+00	2021-03-17 08:07:19.769+00
4	1	4	30	10	delivered	[{"product_id":11,"name":"Bulgogi Pizza","price":"499","customer_price":"499.00","seller_price":"464.07","quantity":5,"variants":[{"type":"Choice of Size","price":"100.00","customer_price":"100.00","seller_price":"93.00","pick":"Large"}],"additionals":[],"note":"Annyeong","removable":false}]	{"sub_total":"2995.00","delivery":"70.00","discount_code":null,"discount_price":0,"total_price":"2995.00","customer_total_price":"3065.00","seller_total_price":"2785.35"}	{"store_pick_time":"2021-03-17T06:34:56.885Z","store_estimated_time":"10 Minutes","rider_pick_time":"2021-03-17T06:34:58.201Z","rider_pick_up_time":"2021-03-17T07:00:43.005Z","rider_estimated_time":null,"delivered_time":"2021-03-17T07:23:45.215Z","is_near":false}	{"location":{"lat":15.162618094504847,"lng":120.55654216557741},"complete_address":"Yukon Street Margot, Angeles City Pampanga","note":"Pasok lang sa office kuya sa taas."}	{"method":"cod","status":"pending","details":{}}	commission			2021-03-17 06:31:34.225639+00	2021-03-17 07:23:45.228+00
13	1	3	29	\N	cancelled	[{"product_id":8,"name":"Caramel Macchiatto","price":"180","customer_price":"180.00","seller_price":"167.40","quantity":1,"variants":[{"type":"Choice of Drink Size","price":"20.00","customer_price":"20.00","seller_price":"18.60","pick":"Medium"}],"additionals":[],"note":"","removable":false}]	{"sub_total":"200.00","delivery":"10.00","discount_code":null,"discount_price":0,"total_price":"200.00","customer_total_price":"210.00","seller_total_price":"186.00"}	\N	{"location":{"lat":15.1625661,"lng":120.55650179999998},"complete_address":"355 Yukon St , Angeles Central Luzon","note":""}	{"method":"cod","status":"pending","details":{}}	commission			2021-03-17 06:36:31.225059+00	2021-03-17 08:07:23.765+00
20	1	12	31	\N	cancelled	[{"product_id":40,"name":"Canpung","price":"700","customer_price":"700.00","seller_price":"651.00","quantity":1,"variants":[{"type":"Choice B","price":"0.00","customer_price":"0.00","seller_price":"0.00","pick":"a"}],"additionals":[{"id":31,"name":"Egg","price":"10.00","customer_price":"10.00","seller_price":"9.30"}],"note":"","removable":false},{"product_id":39,"name":"Golbeng","price":"400","customer_price":"400.00","seller_price":"372.00","quantity":1,"variants":[{"type":"Choice A","price":"0.00","customer_price":"0.00","seller_price":"0.00","pick":"a"}],"additionals":[{"id":30,"name":"Extra Kimchi","price":"20.00","customer_price":"20.00","seller_price":"18.60"}],"note":"","removable":false}]	{"sub_total":"1130.00","delivery":"50.00","discount_code":null,"discount_price":0,"total_price":"1130.00","customer_total_price":"1180.00","seller_total_price":"1050.90"}	\N	{"location":{"lat":15.164003763477075,"lng":120.59075877070427},"complete_address":"McArthur Highway Santa Teresita, Angeles City Pampanga","note":"INFRONT OF CASINO"}	{"method":"cod","status":"pending","details":{}}	commission			2021-03-17 06:39:44.461955+00	2021-03-17 07:44:29.981+00
22	2	11	31	\N	cancelled	[{"product_id":37,"name":"Octopus sasimi","price":"350","customer_price":"350.00","seller_price":"325.50","quantity":1,"variants":[{"type":"Choice B","price":"0.00","customer_price":"0.00","seller_price":"0.00","pick":"a"}],"additionals":[{"id":26,"name":"Egg","price":"10.00","customer_price":"10.00","seller_price":"9.30"}],"note":"","removable":false}]	{"sub_total":"360.00","delivery":"50.00","discount_code":null,"discount_price":0,"total_price":"360.00","customer_total_price":"410.00","seller_total_price":"334.80"}	\N	{"location":{"lat":15.164003763477075,"lng":120.59075877070427},"complete_address":"McArthur Highway Santa Teresita, Angeles City Pampanga","note":"INFRONT OF CASINO"}	{"method":"cod","status":"pending","details":{}}	commission			2021-03-17 06:40:57.306593+00	2021-03-17 07:44:25.196+00
16	4	6	29	7	delivered	[{"product_id":18,"name":"Durian","price":"260","customer_price":"269.09","seller_price":"250.90","quantity":1,"variants":[],"additionals":[],"note":"","removable":true}]	{"sub_total":"269.08","delivery":"10.00","discount_code":null,"discount_price":0,"total_price":"260.00","customer_total_price":"279.08","seller_total_price":"250.90"}	{"store_pick_time":null,"store_estimated_time":null,"rider_pick_time":"2021-03-17T06:40:27.311Z","rider_pick_up_time":"2021-03-17T06:53:33.775Z","rider_estimated_time":null,"delivered_time":"2021-03-17T07:02:16.173Z","is_near":false}	{"location":{"lat":15.1625661,"lng":120.55650179999998},"complete_address":"355 Yukon St , Angeles Central Luzon","note":""}	{"status":"paid","details":{"ref_code":"6051a3fae9bd3e3ff99b2f6e","payment_url":"https://checkout-staging.xendit.co/web/6051a3fae9bd3e3ff99b2f6e","link":"https://bux.ph/test/payment/6e4dc1aa9d554f9dbccf3879a105cc75/","fee":0}}	half			2021-03-17 06:38:49.872066+00	2021-03-17 07:02:16.202+00
18	1	9	31	\N	cancelled	[{"product_id":29,"name":"Jjajangmyun","price":"300","customer_price":"300.00","seller_price":"279.00","quantity":1,"variants":[{"type":"Choice A","price":"0.00","customer_price":"0.00","seller_price":"0.00","pick":"a"},{"type":"Choice B","price":"0.00","customer_price":"0.00","seller_price":"0.00","pick":"a"},{"type":"Choice of Drinks","price":"0.00","customer_price":"0.00","seller_price":"0.00","pick":"Coke"}],"additionals":[],"note":"","removable":false}]	{"sub_total":"300.00","delivery":"50.00","discount_code":null,"discount_price":0,"total_price":"300.00","customer_total_price":"350.00","seller_total_price":"279.00"}	\N	{"location":{"lat":15.164003763477075,"lng":120.59075877070427},"complete_address":"McArthur Highway Santa Teresita, Angeles City Pampanga","note":"INFRONT OF CASINO"}	{"method":"cod","status":"pending","details":{}}	commission			2021-03-17 06:39:02.801332+00	2021-03-17 07:44:33.631+00
17	1	10	31	\N	cancelled	[{"product_id":34,"name":"Bibimbab","price":"300","customer_price":"300.00","seller_price":"279.00","quantity":1,"variants":[{"type":"Choice B","price":"0.00","customer_price":"0.00","seller_price":"0.00","pick":"a"}],"additionals":[{"id":21,"name":"Egg","price":"10.00","customer_price":"10.00","seller_price":"9.30"}],"note":"","removable":false}]	{"sub_total":"310.00","delivery":"50.00","discount_code":null,"discount_price":0,"total_price":"310.00","customer_total_price":"360.00","seller_total_price":"288.30"}	\N	{"location":{"lat":15.164003763477075,"lng":120.59075877070427},"complete_address":"McArthur Highway Santa Teresita, Angeles City Pampanga","note":"INFRONT OF CASINO"}	{"method":"cod","status":"pending","details":{}}	commission			2021-03-17 06:38:50.679475+00	2021-03-17 07:44:38.921+00
21	3	5	32	10	delivered	[{"product_id":14,"name":"Origangjeong","price":"280","customer_price":"280.00","seller_price":"260.40","quantity":3,"variants":[],"additionals":[],"note":"","removable":true}]	{"sub_total":"840.00","delivery":"60.00","discount_code":null,"discount_price":0,"total_price":"840.00","customer_total_price":"900.00","seller_total_price":"781.20"}	{"store_pick_time":"2021-03-17T06:47:14.582Z","store_estimated_time":"20 Minutes","rider_pick_time":"2021-03-17T07:24:31.743Z","rider_pick_up_time":"2021-03-17T07:42:58.070Z","rider_estimated_time":null,"delivered_time":"2021-03-17T07:57:26.823Z","is_near":false}	{"location":{"lat":15.1675411,"lng":120.5802923},"complete_address":"SM City Clark Bldg. Clark Freeport, Angeles Central Luzon","note":"flagpole"}	{"method":"cod","status":"pending","details":{}}	commission			2021-03-17 06:40:13.208126+00	2021-03-17 07:57:26.835+00
27	2	3	31	\N	cancelled	[{"product_id":7,"name":"Americano","price":"130","customer_price":"130.00","seller_price":"120.90","quantity":1,"variants":[{"type":"Choice of Drink Size","price":"30.00","customer_price":"30.00","seller_price":"27.90","pick":"Large"}],"additionals":[],"note":"","removable":false},{"product_id":9,"name":"Coldbrew","price":"60","customer_price":"60.00","seller_price":"55.80","quantity":1,"variants":[],"additionals":[{"id":7,"name":"Whipped Cream","price":"15.00","customer_price":"15.00","seller_price":"13.95"}],"note":"","removable":false}]	{"sub_total":"235.00","delivery":"50.00","discount_code":null,"discount_price":0,"total_price":"235.00","customer_total_price":"285.00","seller_total_price":"218.55"}	\N	{"location":{"lat":15.164003763477075,"lng":120.59075877070427},"complete_address":"McArthur Highway Santa Teresita, Angeles City Pampanga","note":"INFRONT OF CASINO"}	{"method":"cod","status":"pending","details":{}}	commission			2021-03-17 06:42:19.918911+00	2021-03-17 07:44:17.506+00
25	2	8	29	\N	cancelled	[{"product_id":28,"name":"Dwenjangjjigae","price":"300","customer_price":"300.00","seller_price":"279.00","quantity":2,"variants":[{"type":"Choice B","price":"0.00","customer_price":"0.00","seller_price":"0.00","pick":"b"}],"additionals":[{"id":10,"name":"Extra Kimchi","price":"20.00","customer_price":"20.00","seller_price":"18.60"},{"id":9,"name":"Extra Rice","price":"15.00","customer_price":"15.00","seller_price":"13.95"}],"note":"","removable":false}]	{"sub_total":"670.00","delivery":"10.00","discount_code":null,"discount_price":0,"total_price":"670.00","customer_total_price":"680.00","seller_total_price":"623.10"}	\N	{"location":{"lat":15.1625661,"lng":120.55650179999998},"complete_address":"355 Yukon St , Angeles Central Luzon","note":""}	{"method":"cod","status":"pending","details":{}}	commission			2021-03-17 06:41:53.408538+00	2021-03-17 08:07:28.688+00
3	1	5	31	7	delivered	[{"product_id":14,"name":"Origangjeong","price":"280","customer_price":"280.00","seller_price":"260.40","quantity":1,"variants":[],"additionals":[],"note":"","removable":false}]	{"sub_total":"280.00","delivery":"50.00","discount_code":null,"discount_price":0,"total_price":"280.00","customer_total_price":"330.00","seller_total_price":"260.39"}	{"store_pick_time":"2021-03-17T06:47:03.347Z","store_estimated_time":"10 Minutes","rider_pick_time":"2021-03-17T07:02:20.355Z","rider_pick_up_time":"2021-03-17T07:12:27.246Z","rider_estimated_time":null,"delivered_time":"2021-03-17T07:29:43.398Z","is_near":false}	{"location":{"lat":15.164003763477075,"lng":120.59075877070427},"complete_address":"McArthur Highway Santa Teresita, Angeles City Pampanga","note":"INFRONT OF CASINO"}	{"method":"cod","status":"pending","details":{}}	commission			2021-03-17 06:31:21.537949+00	2021-03-17 07:29:43.407+00
24	6	6	30	3	delivered	[{"product_id":18,"name":"Durian","price":"260","customer_price":"269.09","seller_price":"250.90","quantity":1,"variants":[],"additionals":[],"note":"","removable":false}]	{"sub_total":"269.08","delivery":"10.00","discount_code":null,"discount_price":0,"total_price":"260.00","customer_total_price":"279.08","seller_total_price":"250.90"}	{"store_pick_time":null,"store_estimated_time":null,"rider_pick_time":"2021-03-17T06:41:44.285Z","rider_pick_up_time":"2021-03-17T06:53:49.770Z","rider_estimated_time":null,"delivered_time":"2021-03-17T07:04:27.047Z","is_near":false}	{"location":{"lat":15.162618094504847,"lng":120.55654216557741},"complete_address":"Yukon Street Margot, Angeles City Pampanga","note":"Pasok lang sa office kuya sa taas."}	{"method":"cod","status":"pending","details":{}}	half	kuya		2021-03-17 06:41:43.640396+00	2021-03-17 07:04:27.057+00
39	3	8	31	\N	cancelled	[{"product_id":27,"name":"Kimchijjigae","price":"270","customer_price":"270.00","seller_price":"251.10","quantity":1,"variants":[{"type":"Choice A","price":"0.00","customer_price":"0.00","seller_price":"0.00","pick":"a"}],"additionals":[{"id":11,"name":"Egg","price":"10.00","customer_price":"10.00","seller_price":"9.30"},{"id":10,"name":"Extra Kimchi","price":"20.00","customer_price":"20.00","seller_price":"18.60"}],"note":"","removable":false}]	{"sub_total":"300.00","delivery":"50.00","discount_code":null,"discount_price":0,"total_price":"300.00","customer_total_price":"350.00","seller_total_price":"279.00"}	\N	{"location":{"lat":15.164003763477075,"lng":120.59075877070427},"complete_address":"McArthur Highway Santa Teresita, Angeles City Pampanga","note":"INFRONT OF CASINO"}	{"method":"cod","status":"pending","details":{}}	commission			2021-03-17 06:46:23.357788+00	2021-03-17 07:43:52.237+00
30	5	4	29	\N	store-declined	[{"product_id":10,"name":"Combination Pizza","price":"399","customer_price":"399.00","seller_price":"371.07","quantity":2,"variants":[{"type":"Choice of Size","price":"100.00","customer_price":"100.00","seller_price":"93.00","pick":"Large"}],"additionals":[{"id":8,"name":"Extra Cheese","price":"40.00","customer_price":"40.00","seller_price":"37.20"}],"note":"more cheese","removable":true}]	{"sub_total":"1078.00","delivery":"70.00","discount_code":null,"discount_price":0,"total_price":"1078.00","customer_total_price":"1148.00","seller_total_price":"1002.54"}	{"store_pick_time":"2021-03-17T06:43:42.113Z","store_estimated_time":null,"rider_pick_time":null,"rider_pick_up_time":null,"rider_estimated_time":null,"delivered_time":null,"is_near":false}	{"location":{"lat":15.1625661,"lng":120.55650179999998},"complete_address":"355 Yukon St , Angeles Central Luzon","note":""}	{"method":"cod","status":"pending","details":{}}	commission		Low in Man Power	2021-03-17 06:43:12.701179+00	2021-03-17 06:43:42.118+00
36	3	7	26	9	delivered	[{"product_id":20,"name":"Corona 6 pack","price":"240","customer_price":"240.00","seller_price":"223.20","quantity":2,"variants":[],"additionals":[],"note":"","removable":false}]	{"sub_total":"480.00","delivery":"10.00","discount_code":null,"discount_price":0,"total_price":"480.00","customer_total_price":"490.00","seller_total_price":"446.40"}	{"store_pick_time":null,"store_estimated_time":null,"rider_pick_time":"2021-03-17T07:20:40.169Z","rider_pick_up_time":"2021-03-17T07:28:54.422Z","rider_estimated_time":null,"delivered_time":"2021-03-17T07:33:15.044Z","is_near":false}	{"location":{"lat":15.162788633889923,"lng":120.55652439594269},"complete_address":"355 Yukon St , Angeles Central Luzon","note":"Let's Bee Office"}	{"method":"cod","status":"pending","details":{}}	commission	lets bee offce		2021-03-17 06:45:40.830732+00	2021-03-17 07:33:15.063+00
37	8	6	31	\N	cancelled	[{"product_id":17,"name":"Mango Powder","price":"250","customer_price":"258.75","seller_price":"241.25","quantity":1,"variants":[],"additionals":[],"note":"","removable":false}]	{"sub_total":"258.75","delivery":"50.00","discount_code":null,"discount_price":0,"total_price":"250.00","customer_total_price":"308.75","seller_total_price":"241.25"}	\N	{"location":{"lat":15.164003763477075,"lng":120.59075877070427},"complete_address":"McArthur Highway Santa Teresita, Angeles City Pampanga","note":"INFRONT OF CASINO"}	{"method":"cod","status":"pending","details":{}}	half			2021-03-17 06:45:43.758459+00	2021-03-17 07:43:57.642+00
32	2	7	30	8	delivered	[{"product_id":20,"name":"Corona 6 pack","price":"240","customer_price":"240.00","seller_price":"223.20","quantity":1,"variants":[],"additionals":[],"note":"","removable":false}]	{"sub_total":"240.00","delivery":"10.00","discount_code":null,"discount_price":0,"total_price":"240.00","customer_total_price":"250.00","seller_total_price":"223.20"}	{"store_pick_time":null,"store_estimated_time":null,"rider_pick_time":"2021-03-17T07:20:42.012Z","rider_pick_up_time":"2021-03-17T07:28:27.136Z","rider_estimated_time":null,"delivered_time":"2021-03-17T07:33:43.618Z","is_near":false}	{"location":{"lat":15.162618094504847,"lng":120.55654216557741},"complete_address":"Yukon Street Margot, Angeles City Pampanga","note":"Pasok lang sa office kuya sa taas."}	{"method":"cod","status":"pending","details":{}}	commission			2021-03-17 06:43:27.787605+00	2021-03-17 07:33:43.626+00
35	7	6	30	4	delivered	[{"product_id":17,"name":"Mango Powder","price":"250","customer_price":"258.75","seller_price":"241.25","quantity":1,"variants":[],"additionals":[],"note":"","removable":false}]	{"sub_total":"258.75","delivery":"10.00","discount_code":null,"discount_price":0,"total_price":"250.00","customer_total_price":"268.75","seller_total_price":"241.25"}	{"store_pick_time":null,"store_estimated_time":null,"rider_pick_time":"2021-03-17T07:30:24.051Z","rider_pick_up_time":"2021-03-17T07:49:19.598Z","rider_estimated_time":null,"delivered_time":"2021-03-17T07:58:54.618Z","is_near":false}	{"location":{"lat":15.162618094504847,"lng":120.55654216557741},"complete_address":"Yukon Street Margot, Angeles City Pampanga","note":"Pasok lang sa office kuya sa taas."}	{"method":"cod","status":"pending","details":{}}	half	Check nyo one mart employee		2021-03-17 06:44:43.535665+00	2021-03-17 07:58:54.637+00
29	1	7	32	6	delivered	[{"product_id":20,"name":"Corona 6 pack","price":"240","customer_price":"240.00","seller_price":"223.20","quantity":3,"variants":[],"additionals":[],"note":"","removable":true},{"product_id":23,"name":"Heineken 6 pack","price":"799","customer_price":"799.00","seller_price":"743.07","quantity":1,"variants":[],"additionals":[],"note":"","removable":true},{"product_id":25,"name":"Red Horse in Can 330ml","price":"50","customer_price":"50.00","seller_price":"46.50","quantity":2,"variants":[],"additionals":[],"note":"","removable":true},{"product_id":22,"name":"Tanduay Ice in Bottle 330ml","price":"43","customer_price":"43.00","seller_price":"39.99","quantity":4,"variants":[],"additionals":[],"note":"","removable":true}]	{"sub_total":"1791.00","delivery":"60.00","discount_code":null,"discount_price":0,"total_price":"1791.00","customer_total_price":"1851.00","seller_total_price":"1665.63"}	{"store_pick_time":null,"store_estimated_time":null,"rider_pick_time":"2021-03-17T06:43:05.659Z","rider_pick_up_time":"2021-03-17T06:48:11.140Z","rider_estimated_time":null,"delivered_time":"2021-03-17T06:58:49.916Z","is_near":false}	{"location":{"lat":15.1675411,"lng":120.5802923},"complete_address":"SM City Clark Bldg. Clark Freeport, Angeles Central Luzon","note":"flagpole"}	{"method":"cod","status":"pending","details":{}}	commission			2021-03-17 06:42:59.03404+00	2021-03-17 06:58:49.927+00
7	2	6	31	2	delivered	[{"product_id":18,"name":"Durian","price":"260","customer_price":"269.09","seller_price":"250.90","quantity":1,"variants":[],"additionals":[],"note":"","removable":false},{"product_id":19,"name":"Samanco","price":"30","customer_price":"31.04","seller_price":"28.95","quantity":1,"variants":[],"additionals":[],"note":"","removable":false},{"product_id":16,"name":"Shabu Shabu Mix","price":"510","customer_price":"527.84","seller_price":"492.15","quantity":1,"variants":[],"additionals":[],"note":"","removable":false}]	{"sub_total":"827.97","delivery":"50.00","discount_code":null,"discount_price":0,"total_price":"800.00","customer_total_price":"877.97","seller_total_price":"772.00"}	{"store_pick_time":null,"store_estimated_time":null,"rider_pick_time":"2021-03-17T06:34:05.302Z","rider_pick_up_time":"2021-03-17T06:47:31.863Z","rider_estimated_time":null,"delivered_time":"2021-03-17T07:08:28.592Z","is_near":false}	{"location":{"lat":15.164003763477075,"lng":120.59075877070427},"complete_address":"McArthur Highway Santa Teresita, Angeles City Pampanga","note":"INFRONT OF CASINO"}	{"method":"cod","status":"pending","details":{}}	half			2021-03-17 06:34:04.693383+00	2021-03-17 07:08:28.603+00
31	5	5	31	8	delivered	[{"product_id":15,"name":"Oritang","price":"249","customer_price":"249.00","seller_price":"231.57","quantity":1,"variants":[],"additionals":[],"note":"","removable":false}]	{"sub_total":"249.00","delivery":"50.00","discount_code":null,"discount_price":0,"total_price":"249.00","customer_total_price":"299.00","seller_total_price":"231.57"}	{"store_pick_time":"2021-03-17T06:47:29.162Z","store_estimated_time":"20 Minutes","rider_pick_time":"2021-03-17T08:17:52.984Z","rider_pick_up_time":"2021-03-17T08:19:07.415Z","rider_estimated_time":null,"delivered_time":"2021-03-17T08:19:09.497Z","is_near":false}	{"location":{"lat":15.164003763477075,"lng":120.59075877070427},"complete_address":"McArthur Highway Santa Teresita, Angeles City Pampanga","note":"INFRONT OF CASINO"}	{"method":"cod","status":"pending","details":{}}	commission			2021-03-17 06:43:18.48997+00	2021-03-17 08:19:09.508+00
41	7	5	30	1	delivered	[{"product_id":15,"name":"Oritang","price":"249","customer_price":"249.00","seller_price":"231.57","quantity":5,"variants":[],"additionals":[],"note":"","removable":false}]	{"sub_total":"1245.00","delivery":"10.00","discount_code":null,"discount_price":0,"total_price":"1245.00","customer_total_price":"1255.00","seller_total_price":"1157.84"}	{"store_pick_time":"2021-03-17T06:48:16.929Z","store_estimated_time":"20 Minutes","rider_pick_time":"2021-03-17T07:33:40.294Z","rider_pick_up_time":"2021-03-17T07:45:06.653Z","rider_estimated_time":null,"delivered_time":"2021-03-17T07:55:24.945Z","is_near":false}	{"location":{"lat":15.162618094504847,"lng":120.55654216557741},"complete_address":"Yukon Street Margot, Angeles City Pampanga","note":"Pasok lang sa office kuya sa taas."}	{"method":"cod","status":"pending","details":{}}	commission			2021-03-17 06:47:52.868634+00	2021-03-17 07:55:24.958+00
45	5	7	30	\N	processing	[{"product_id":23,"name":"Heineken 6 pack","price":"799","customer_price":"799.00","seller_price":"743.07","quantity":1,"variants":[],"additionals":[],"note":"","removable":false}]	{"sub_total":"799.00","delivery":"10.00","discount_code":null,"discount_price":0,"total_price":"799.00","customer_total_price":"809.00","seller_total_price":"743.07"}	\N	{"location":{"lat":15.162618094504847,"lng":120.55654216557741},"complete_address":"Yukon Street Margot, Angeles City Pampanga","note":"Pasok lang sa office kuya sa taas."}	{"status":"pending","details":{"ref_code":"6051a766e9bd3e3ff99b2f97","payment_url":"https://checkout-staging.xendit.co/web/6051a766e9bd3e3ff99b2f97","link":"https://bux.ph/test/payment/dc4d5c7e6a744f799d3945cce6ec875e/","fee":0}}	commission			2021-03-17 06:53:25.547001+00	2021-03-17 06:53:26.61+00
23	5	6	32	4	delivered	[{"product_id":18,"name":"Durian","price":"260","customer_price":"269.09","seller_price":"250.90","quantity":2,"variants":[],"additionals":[],"note":"","removable":true},{"product_id":16,"name":"Shabu Shabu Mix","price":"510","customer_price":"527.84","seller_price":"492.15","quantity":1,"variants":[],"additionals":[],"note":"","removable":false}]	{"sub_total":"1066.02","delivery":"60.00","discount_code":null,"discount_price":0,"total_price":"1030.00","customer_total_price":"1126.02","seller_total_price":"993.95"}	{"store_pick_time":null,"store_estimated_time":null,"rider_pick_time":"2021-03-17T06:41:03.688Z","rider_pick_up_time":"2021-03-17T06:50:43.399Z","rider_estimated_time":null,"delivered_time":"2021-03-17T07:03:04.062Z","is_near":false}	{"location":{"lat":15.1675411,"lng":120.5802923},"complete_address":"SM City Clark Bldg. Clark Freeport, Angeles Central Luzon","note":"flagpole"}	{"method":"cod","status":"pending","details":{}}	half			2021-03-17 06:41:02.8061+00	2021-03-17 07:03:04.076+00
40	6	5	29	7	delivered	[{"product_id":15,"name":"Oritang","price":"249","customer_price":"249.00","seller_price":"231.57","quantity":4,"variants":[],"additionals":[],"note":"","removable":false}]	{"sub_total":"996.00","delivery":"10.00","discount_code":null,"discount_price":0,"total_price":"996.00","customer_total_price":"1006.00","seller_total_price":"926.28"}	{"store_pick_time":"2021-03-17T06:49:29.421Z","store_estimated_time":"20 Minutes","rider_pick_time":"2021-03-17T07:30:18.787Z","rider_pick_up_time":"2021-03-17T07:46:28.878Z","rider_estimated_time":null,"delivered_time":"2021-03-17T07:55:48.745Z","is_near":false}	{"location":{"lat":15.1625661,"lng":120.55650179999998},"complete_address":"355 Yukon St , Angeles Central Luzon","note":""}	{"status":"paid","details":{"ref_code":"6051a619e9bd3e3ff99b2f84","payment_url":"https://checkout-staging.xendit.co/web/6051a619e9bd3e3ff99b2f84","link":"https://bux.ph/test/payment/b5f46dbfd2874d72978ba8563148fbec/","fee":0}}	commission			2021-03-17 06:47:52.732445+00	2021-03-17 07:55:48.792+00
43	3	9	29	\N	cancelled	[{"product_id":31,"name":"Tangsuyuk","price":"800","customer_price":"800.00","seller_price":"744.00","quantity":1,"variants":[{"type":"Choice B","price":"0.00","customer_price":"0.00","seller_price":"0.00","pick":"c"}],"additionals":[{"id":14,"name":"Extra Rice","price":"15.00","customer_price":"15.00","seller_price":"13.95"}],"note":"","removable":false}]	{"sub_total":"815.00","delivery":"10.00","discount_code":null,"discount_price":0,"total_price":"815.00","customer_total_price":"825.00","seller_total_price":"757.95"}	\N	{"location":{"lat":15.1625661,"lng":120.55650179999998},"complete_address":"355 Yukon St , Angeles Central Luzon","note":""}	{"method":"cod","status":"pending","details":{}}	commission			2021-03-17 06:50:44.184681+00	2021-03-17 08:07:39.13+00
46	6	7	30	6	delivered	[{"product_id":23,"name":"Heineken 6 pack","price":"799","customer_price":"799.00","seller_price":"743.07","quantity":1,"variants":[],"additionals":[],"note":"","removable":false}]	{"sub_total":"799.00","delivery":"10.00","discount_code":null,"discount_price":0,"total_price":"799.00","customer_total_price":"809.00","seller_total_price":"743.07"}	{"store_pick_time":null,"store_estimated_time":null,"rider_pick_time":"2021-03-17T07:30:31.147Z","rider_pick_up_time":"2021-03-17T07:36:32.934Z","rider_estimated_time":null,"delivered_time":"2021-03-17T07:42:12.552Z","is_near":false}	{"location":{"lat":15.162618094504847,"lng":120.55654216557741},"complete_address":"Yukon Street Margot, Angeles City Pampanga","note":"Pasok lang sa office kuya sa taas."}	{"method":"cod","status":"pending","details":{}}	commission			2021-03-17 06:54:06.36587+00	2021-03-17 07:42:12.56+00
42	3	12	32	\N	cancelled	[{"product_id":40,"name":"Canpung","price":"700","customer_price":"700.00","seller_price":"651.00","quantity":1,"variants":[{"type":"Choice B","price":"0.00","customer_price":"0.00","seller_price":"0.00","pick":"c"}],"additionals":[{"id":31,"name":"Egg","price":"10.00","customer_price":"10.00","seller_price":"9.30"},{"id":30,"name":"Extra Kimchi","price":"20.00","customer_price":"20.00","seller_price":"18.60"},{"id":33,"name":"Sausage","price":"35.00","customer_price":"35.00","seller_price":"32.54"}],"note":"","removable":false},{"product_id":38,"name":"Fried Chicken","price":"500","customer_price":"500.00","seller_price":"465.00","quantity":1,"variants":[{"type":"Choice B","price":"0.00","customer_price":"0.00","seller_price":"0.00","pick":"b"},{"type":"Choice A","price":"20.00","customer_price":"20.00","seller_price":"18.60","pick":"b"}],"additionals":[{"id":30,"name":"Extra Kimchi","price":"20.00","customer_price":"20.00","seller_price":"18.60"},{"id":29,"name":"Extra Rice","price":"15.00","customer_price":"15.00","seller_price":"13.95"},{"id":32,"name":"Extra Soup","price":"30.00","customer_price":"30.00","seller_price":"27.90"}],"note":"","removable":false},{"product_id":39,"name":"Golbeng","price":"400","customer_price":"400.00","seller_price":"372.00","quantity":1,"variants":[{"type":"Choice A","price":"0.00","customer_price":"0.00","seller_price":"0.00","pick":"a"}],"additionals":[],"note":"","removable":false}]	{"sub_total":"1750.00","delivery":"60.00","discount_code":null,"discount_price":0,"total_price":"1750.00","customer_total_price":"1810.00","seller_total_price":"1627.50"}	\N	{"location":{"lat":15.1675411,"lng":120.5802923},"complete_address":"SM City Clark Bldg. Clark Freeport, Angeles Central Luzon","note":"flagpole"}	{"method":"cod","status":"pending","details":{}}	commission		matagak	2021-03-17 06:49:05.255888+00	2021-03-17 06:54:21.114+00
48	3	3	32	\N	pending	[{"product_id":7,"name":"Americano","price":"130","customer_price":"130.00","seller_price":"120.90","quantity":2,"variants":[{"type":"Choice of Drink Size","price":"30.00","customer_price":"30.00","seller_price":"27.90","pick":"Large"}],"additionals":[],"note":"","removable":false}]	{"sub_total":"320.00","delivery":"60.00","discount_code":null,"discount_price":0,"total_price":"320.00","customer_total_price":"380.00","seller_total_price":"297.60"}	\N	{"location":{"lat":15.1675411,"lng":120.5802923},"complete_address":"SM City Clark Bldg. Clark Freeport, Angeles Central Luzon","note":"flagpole"}	{"method":"cod","status":"pending","details":{}}	commission			2021-03-17 06:55:05.29703+00	2021-03-17 06:55:05.29703+00
49	3	11	32	\N	pending	[{"product_id":36,"name":"Salmon Sasimi","price":"600","customer_price":"600.00","seller_price":"558.00","quantity":1,"variants":[{"type":"Choice A","price":"20.00","customer_price":"20.00","seller_price":"18.60","pick":"c"}],"additionals":[],"note":"","removable":false},{"product_id":35,"name":"Tuna sasimi","price":"500","customer_price":"500.00","seller_price":"465.00","quantity":4,"variants":[{"type":"Choice A","price":"20.00","customer_price":"20.00","seller_price":"18.60","pick":"b"},{"type":"Choice B","price":"0.00","customer_price":"0.00","seller_price":"0.00","pick":"a"}],"additionals":[{"id":26,"name":"Egg","price":"10.00","customer_price":"10.00","seller_price":"9.30"}],"note":"secret","removable":true}]	{"sub_total":"2740.00","delivery":"60.00","discount_code":null,"discount_price":0,"total_price":"2740.00","customer_total_price":"2800.00","seller_total_price":"2548.19"}	\N	{"location":{"lat":15.1675411,"lng":120.5802923},"complete_address":"SM City Clark Bldg. Clark Freeport, Angeles Central Luzon","note":"flagpole"}	{"method":"cod","status":"pending","details":{}}	commission			2021-03-17 06:56:46.9229+00	2021-03-17 06:56:46.9229+00
47	6	4	26	2	delivered	[{"product_id":12,"name":"Cheese Tteokbokki","price":"249","customer_price":"249.00","seller_price":"231.57","quantity":1,"variants":[],"additionals":[],"note":"","removable":true}]	{"sub_total":"249.00","delivery":"70.00","discount_code":null,"discount_price":0,"total_price":"249.00","customer_total_price":"319.00","seller_total_price":"231.57"}	{"store_pick_time":"2021-03-17T07:00:58.629Z","store_estimated_time":"1 Hour","rider_pick_time":"2021-03-17T07:37:49.945Z","rider_pick_up_time":"2021-03-17T07:52:58.611Z","rider_estimated_time":null,"delivered_time":"2021-03-17T08:09:26.765Z","is_near":false}	{"location":{"lat":15.162788633889923,"lng":120.55652439594269},"complete_address":"355 Yukon St , Angeles Central Luzon","note":"Let's Bee Office"}	{"method":"cod","status":"pending","details":{}}	commission			2021-03-17 06:54:55.269007+00	2021-03-17 08:09:26.796+00
51	4	8	32	\N	pending	[{"product_id":26,"name":"Galbitang","price":"480","customer_price":"480.00","seller_price":"446.40","quantity":2,"variants":[{"type":"Choice A","price":"20.00","customer_price":"20.00","seller_price":"18.60","pick":"b"},{"type":"Choice B","price":"0.00","customer_price":"0.00","seller_price":"0.00","pick":"a"}],"additionals":[{"id":10,"name":"Extra Kimchi","price":"20.00","customer_price":"20.00","seller_price":"18.60"}],"note":"","removable":false},{"product_id":26,"name":"Galbitang","price":"480","customer_price":"480.00","seller_price":"446.40","quantity":1,"variants":[{"type":"Choice A","price":"0.00","customer_price":"0.00","seller_price":"0.00","pick":"a"},{"type":"Choice B","price":"0.00","customer_price":"0.00","seller_price":"0.00","pick":"a"}],"additionals":[],"note":"","removable":false}]	{"sub_total":"1520.00","delivery":"60.00","discount_code":null,"discount_price":0,"total_price":"1520.00","customer_total_price":"1580.00","seller_total_price":"1413.60"}	\N	{"location":{"lat":15.1675411,"lng":120.5802923},"complete_address":"SM City Clark Bldg. Clark Freeport, Angeles Central Luzon","note":"flagpole"}	{"method":"cod","status":"pending","details":{}}	commission			2021-03-17 07:06:09.318311+00	2021-03-17 07:06:09.318311+00
50	7	7	31	\N	cancelled	[{"product_id":20,"name":"Corona 6 pack","price":"240","customer_price":"240.00","seller_price":"223.20","quantity":1,"variants":[],"additionals":[],"note":"","removable":false},{"product_id":23,"name":"Heineken 6 pack","price":"799","customer_price":"799.00","seller_price":"743.07","quantity":1,"variants":[],"additionals":[],"note":"","removable":false}]	{"sub_total":"1039.00","delivery":"60.00","discount_code":null,"discount_price":0,"total_price":"1039.00","customer_total_price":"1099.00","seller_total_price":"966.27"}	\N	{"location":{"lat":15.163856200842517,"lng":120.59085365384817},"complete_address":"Mon Tang Avenue Santa Teresita, Angeles City Pampanga","note":"INFRONT OF CASINO"}	{"method":"cod","status":"pending","details":{}}	commission			2021-03-17 07:03:07.005226+00	2021-03-17 07:43:46.005+00
53	3	10	32	\N	pending	[{"product_id":34,"name":"Bibimbab","price":"300","customer_price":"300.00","seller_price":"279.00","quantity":2,"variants":[{"type":"Choice B","price":"0.00","customer_price":"0.00","seller_price":"0.00","pick":"b"}],"additionals":[{"id":21,"name":"Egg","price":"10.00","customer_price":"10.00","seller_price":"9.30"},{"id":20,"name":"Extra Kimchi","price":"20.00","customer_price":"20.00","seller_price":"18.60"}],"note":"","removable":false}]	{"sub_total":"660.00","delivery":"60.00","discount_code":null,"discount_price":0,"total_price":"660.00","customer_total_price":"720.00","seller_total_price":"613.79"}	\N	{"location":{"lat":15.1675411,"lng":120.5802923},"complete_address":"SM City Clark Bldg. Clark Freeport, Angeles Central Luzon","note":"flagpole"}	{"method":"cod","status":"pending","details":{}}	commission			2021-03-17 07:14:55.798452+00	2021-03-17 07:14:55.798452+00
26	4	4	32	5	delivered	[{"product_id":10,"name":"Combination Pizza","price":"399","customer_price":"399.00","seller_price":"371.07","quantity":1,"variants":[{"type":"Choice of Size","price":"100.00","customer_price":"100.00","seller_price":"93.00","pick":"Large"}],"additionals":[{"id":8,"name":"Extra Cheese","price":"40.00","customer_price":"40.00","seller_price":"37.20"}],"note":"","removable":true},{"product_id":10,"name":"Combination Pizza","price":"399","customer_price":"399.00","seller_price":"371.07","quantity":1,"variants":[{"type":"Choice of Size","price":"50.00","customer_price":"50.00","seller_price":"46.50","pick":"Medium"}],"additionals":[{"id":8,"name":"Extra Cheese","price":"40.00","customer_price":"40.00","seller_price":"37.20"}],"note":"","removable":true},{"product_id":12,"name":"Cheese Tteokbokki","price":"249","customer_price":"249.00","seller_price":"231.57","quantity":1,"variants":[],"additionals":[],"note":"","removable":true}]	{"sub_total":"1277.00","delivery":"60.00","discount_code":null,"discount_price":0,"total_price":"1277.00","customer_total_price":"1337.00","seller_total_price":"1187.60"}	{"store_pick_time":"2021-03-17T06:42:20.072Z","store_estimated_time":"40 Minutes","rider_pick_time":"2021-03-17T06:42:23.888Z","rider_pick_up_time":"2021-03-17T06:58:56.108Z","rider_estimated_time":null,"delivered_time":"2021-03-17T07:18:48.464Z","is_near":false}	{"location":{"lat":15.1675411,"lng":120.5802923},"complete_address":"SM City Clark Bldg. Clark Freeport, Angeles Central Luzon","note":"flagpole"}	{"method":"cod","status":"pending","details":{}}	commission			2021-03-17 06:42:04.654639+00	2021-03-17 07:18:48.47+00
14	4	2	30	2	delivered	[{"product_id":6,"name":"Dalgona Latte","price":"180","customer_price":"192.60","seller_price":"180.00","quantity":1,"variants":[{"type":"Choice of Drink Size","price":"30.00","customer_price":"32.10","seller_price":"30.00","pick":"Large"}],"additionals":[],"note":"hello","removable":false}]	{"sub_total":"224.70","delivery":"40.00","discount_code":null,"discount_price":0,"total_price":"210.00","customer_total_price":"264.70","seller_total_price":"210.00"}	{"store_pick_time":"2021-03-17T06:49:10.408Z","store_estimated_time":"20 Minutes","rider_pick_time":"2021-03-17T07:09:29.619Z","rider_pick_up_time":"2021-03-17T07:25:35.835Z","rider_estimated_time":null,"delivered_time":"2021-03-17T07:35:32.953Z","is_near":false}	{"location":{"lat":15.162618094504847,"lng":120.55654216557741},"complete_address":"Yukon Street Margot, Angeles City Pampanga","note":"Pasok lang sa office kuya sa taas."}	{"method":"cod","status":"pending","details":{}}	markup			2021-03-17 06:36:32.28526+00	2021-03-17 07:35:32.963+00
52	8	7	32	8	delivered	[{"product_id":23,"name":"Heineken 6 pack","price":"799","customer_price":"799.00","seller_price":"743.07","quantity":1,"variants":[],"additionals":[],"note":"","removable":true}]	{"sub_total":"799.00","delivery":"60.00","discount_code":null,"discount_price":0,"total_price":"799.00","customer_total_price":"859.00","seller_total_price":"743.07"}	{"store_pick_time":null,"store_estimated_time":null,"rider_pick_time":"2021-03-17T07:35:45.637Z","rider_pick_up_time":"2021-03-17T07:39:36.575Z","rider_estimated_time":null,"delivered_time":"2021-03-17T07:46:02.240Z","is_near":false}	{"location":{"lat":15.1675411,"lng":120.5802923},"complete_address":"SM City Clark Bldg. Clark Freeport, Angeles Central Luzon","note":"flagpole"}	{"method":"cod","status":"pending","details":{}}	commission			2021-03-17 07:07:25.641127+00	2021-03-17 07:46:02.255+00
10	3	2	26	1	delivered	[{"product_id":5,"name":"Dan Pat Bbang","price":"60","customer_price":"60.00","seller_price":"55.80","quantity":2,"variants":[],"additionals":[{"id":6,"name":"Whipped Cream","price":"15.00","customer_price":"16.05","seller_price":"15.00"}],"note":"","removable":false},{"product_id":4,"name":"Ddung Macaron","price":"129","customer_price":"138.03","seller_price":"129.00","quantity":1,"variants":[{"type":"Choice of Drink Size","price":"30.00","customer_price":"32.10","seller_price":"30.00","pick":"Large"}],"additionals":[{"id":6,"name":"Whipped Cream","price":"15.00","customer_price":"16.05","seller_price":"15.00"}],"note":"","removable":true}]	{"sub_total":"338.28","delivery":"40.00","discount_code":null,"discount_price":0,"total_price":"324.00","customer_total_price":"378.28","seller_total_price":"315.60"}	{"store_pick_time":"2021-03-17T06:49:07.726Z","store_estimated_time":"30 Minutes","rider_pick_time":"2021-03-17T07:01:59.108Z","rider_pick_up_time":"2021-03-17T07:12:49.349Z","rider_estimated_time":null,"delivered_time":"2021-03-17T07:22:54.925Z","is_near":false}	{"location":{"lat":15.162788633889923,"lng":120.55652439594269},"complete_address":"355 Yukon St , Angeles Central Luzon","note":"Let's Bee Office"}	{"method":"cod","status":"pending","details":{}}	markup			2021-03-17 06:35:01.67762+00	2021-03-17 07:22:54.938+00
44	4	7	29	1	delivered	[{"product_id":21,"name":"San Miguel Apple Flavored Beer in Can 330ml","price":"56","customer_price":"56.00","seller_price":"52.08","quantity":5,"variants":[],"additionals":[],"note":"","removable":true}]	{"sub_total":"280.00","delivery":"10.00","discount_code":null,"discount_price":0,"total_price":"280.00","customer_total_price":"290.00","seller_total_price":"260.39"}	{"store_pick_time":null,"store_estimated_time":null,"rider_pick_time":"2021-03-17T07:23:57.014Z","rider_pick_up_time":"2021-03-17T07:28:23.056Z","rider_estimated_time":null,"delivered_time":"2021-03-17T07:33:16.805Z","is_near":false}	{"location":{"lat":15.1625661,"lng":120.55650179999998},"complete_address":"355 Yukon St , Angeles Central Luzon","note":""}	{"method":"cod","status":"pending","details":{}}	commission			2021-03-17 06:51:49.907502+00	2021-03-17 07:33:16.815+00
34	2	9	31	\N	cancelled	[{"product_id":30,"name":"Jjambbong","price":"350","customer_price":"350.00","seller_price":"325.50","quantity":1,"variants":[{"type":"Choice A","price":"0.00","customer_price":"0.00","seller_price":"0.00","pick":"a"}],"additionals":[{"id":16,"name":"Egg","price":"10.00","customer_price":"10.00","seller_price":"9.30"}],"note":"","removable":false},{"product_id":31,"name":"Tangsuyuk","price":"800","customer_price":"800.00","seller_price":"744.00","quantity":1,"variants":[{"type":"Choice B","price":"0.00","customer_price":"0.00","seller_price":"0.00","pick":"a"}],"additionals":[{"id":16,"name":"Egg","price":"10.00","customer_price":"10.00","seller_price":"9.30"}],"note":"","removable":false}]	{"sub_total":"1170.00","delivery":"50.00","discount_code":null,"discount_price":0,"total_price":"1170.00","customer_total_price":"1220.00","seller_total_price":"1088.09"}	\N	{"location":{"lat":15.164003763477075,"lng":120.59075877070427},"complete_address":"McArthur Highway Santa Teresita, Angeles City Pampanga","note":"INFRONT OF CASINO"}	{"method":"cod","status":"pending","details":{}}	commission			2021-03-17 06:44:25.812787+00	2021-03-17 07:44:02.536+00
28	4	5	26	9	delivered	[{"product_id":15,"name":"Oritang","price":"249","customer_price":"249.00","seller_price":"231.57","quantity":2,"variants":[],"additionals":[],"note":"","removable":false}]	{"sub_total":"498.00","delivery":"10.00","discount_code":null,"discount_price":0,"total_price":"498.00","customer_total_price":"508.00","seller_total_price":"463.14"}	{"store_pick_time":"2021-03-17T06:47:22.126Z","store_estimated_time":"10 Minutes","rider_pick_time":"2021-03-17T07:34:50.324Z","rider_pick_up_time":"2021-03-17T07:45:09.070Z","rider_estimated_time":null,"delivered_time":"2021-03-17T07:55:36.036Z","is_near":false}	{"location":{"lat":15.162788633889923,"lng":120.55652439594269},"complete_address":"355 Yukon St , Angeles Central Luzon","note":"Let's Bee Office"}	{"method":"cod","status":"pending","details":{}}	commission			2021-03-17 06:42:29.516147+00	2021-03-17 07:55:36.049+00
54	9	6	29	6	delivered	[{"product_id":18,"name":"Durian","price":"260","customer_price":"269.09","seller_price":"250.90","quantity":1,"variants":[],"additionals":[],"note":"","removable":false}]	{"sub_total":"269.08","delivery":"10.00","discount_code":null,"discount_price":0,"total_price":"260.00","customer_total_price":"279.08","seller_total_price":"250.90"}	{"store_pick_time":null,"store_estimated_time":null,"rider_pick_time":"2021-03-17T07:42:29.905Z","rider_pick_up_time":"2021-03-17T07:54:52.973Z","rider_estimated_time":null,"delivered_time":"2021-03-17T08:04:05.621Z","is_near":false}	{"location":{"lat":15.1625661,"lng":120.55650179999998},"complete_address":"355 Yukon St , Angeles Central Luzon","note":""}	{"method":"cod","status":"pending","details":{}}	half			2021-03-17 07:42:13.737047+00	2021-03-17 08:04:05.644+00
12	1	8	31	\N	cancelled	[{"product_id":28,"name":"Dwenjangjjigae","price":"300","customer_price":"300.00","seller_price":"279.00","quantity":1,"variants":[{"type":"Choice B","price":"0.00","customer_price":"0.00","seller_price":"0.00","pick":"a"}],"additionals":[{"id":11,"name":"Egg","price":"10.00","customer_price":"10.00","seller_price":"9.30"},{"id":9,"name":"Extra Rice","price":"15.00","customer_price":"15.00","seller_price":"13.95"}],"note":"","removable":false},{"product_id":27,"name":"Kimchijjigae","price":"270","customer_price":"270.00","seller_price":"251.10","quantity":1,"variants":[{"type":"Choice A","price":"0.00","customer_price":"0.00","seller_price":"0.00","pick":"a"}],"additionals":[{"id":11,"name":"Egg","price":"10.00","customer_price":"10.00","seller_price":"9.30"}],"note":"","removable":false},{"product_id":26,"name":"Galbitang","price":"480","customer_price":"480.00","seller_price":"446.40","quantity":1,"variants":[{"type":"Choice A","price":"20.00","customer_price":"20.00","seller_price":"18.60","pick":"b"},{"type":"Choice B","price":"0.00","customer_price":"0.00","seller_price":"0.00","pick":"a"}],"additionals":[],"note":"","removable":false}]	{"sub_total":"1105.00","delivery":"50.00","discount_code":null,"discount_price":0,"total_price":"1105.00","customer_total_price":"1155.00","seller_total_price":"1027.65"}	\N	{"location":{"lat":15.164003763477075,"lng":120.59075877070427},"complete_address":"McArthur Highway Santa Teresita, Angeles City Pampanga","note":"INFRONT OF CASINO"}	{"method":"cod","status":"pending","details":{}}	commission			2021-03-17 06:35:53.399511+00	2021-03-17 07:44:43.121+00
19	5	2	32	5	delivered	[{"product_id":6,"name":"Dalgona Latte","price":"180","customer_price":"192.60","seller_price":"180.00","quantity":1,"variants":[{"type":"Choice of Drink Size","price":"20.00","customer_price":"21.40","seller_price":"20.00","pick":"Medium"}],"additionals":[],"note":"","removable":true},{"product_id":5,"name":"Dan Pat Bbang","price":"60","customer_price":"60.00","seller_price":"55.80","quantity":1,"variants":[],"additionals":[{"id":6,"name":"Whipped Cream","price":"15.00","customer_price":"16.05","seller_price":"15.00"}],"note":"","removable":true},{"product_id":4,"name":"Ddung Macaron","price":"129","customer_price":"138.03","seller_price":"129.00","quantity":1,"variants":[{"type":"Choice of Drink Size","price":"0.00","customer_price":"0.00","seller_price":"0.00","pick":"Regular"}],"additionals":[],"note":"","removable":true}]	{"sub_total":"428.08","delivery":"90.00","discount_code":null,"discount_price":0,"total_price":"404.00","customer_total_price":"518.08","seller_total_price":"399.80"}	{"store_pick_time":"2021-03-17T06:49:10.446Z","store_estimated_time":"20 Minutes","rider_pick_time":"2021-03-17T07:19:49.444Z","rider_pick_up_time":"2021-03-17T07:35:36.332Z","rider_estimated_time":null,"delivered_time":"2021-03-17T07:47:56.619Z","is_near":false}	{"location":{"lat":15.1675411,"lng":120.5802923},"complete_address":"SM City Clark Bldg. Clark Freeport, Angeles Central Luzon","note":"flagpole"}	{"method":"cod","status":"pending","details":{}}	markup			2021-03-17 06:39:24.429975+00	2021-03-17 07:47:56.627+00
33	2	10	29	\N	cancelled	[{"product_id":33,"name":"Bulgogi","price":"600","customer_price":"600.00","seller_price":"558.00","quantity":5,"variants":[{"type":"Choice A","price":"20.00","customer_price":"20.00","seller_price":"18.60","pick":"b"}],"additionals":[{"id":20,"name":"Extra Kimchi","price":"20.00","customer_price":"20.00","seller_price":"18.60"}],"note":"","removable":false}]	{"sub_total":"3200.00","delivery":"10.00","discount_code":null,"discount_price":0,"total_price":"3200.00","customer_total_price":"3210.00","seller_total_price":"2976.00"}	\N	{"location":{"lat":15.1625661,"lng":120.55650179999998},"complete_address":"355 Yukon St , Angeles Central Luzon","note":""}	{"status":"paid","details":{"ref_code":"6051a533e9bd3e3ff99b2f7d","payment_url":"https://checkout-staging.xendit.co/web/6051a533e9bd3e3ff99b2f7d","link":"https://bux.ph/test/payment/5275f9b126084c349f98672b0790b82e/","fee":0}}	commission			2021-03-17 06:44:02.700902+00	2021-03-17 08:07:35.337+00
55	6	2	33	\N	cancelled	[{"product_id":4,"name":"Ddung Macaron","price":"129","customer_price":"138.03","seller_price":"129.00","quantity":1,"variants":[{"type":"Choice of Drink Size","price":"0.00","customer_price":"0.00","seller_price":"0.00","pick":"Regular"}],"additionals":[],"note":"","removable":false},{"product_id":4,"name":"Ddung Macaron","price":"129","customer_price":"138.03","seller_price":"129.00","quantity":1,"variants":[{"type":"Choice of Drink Size","price":"20.00","customer_price":"21.40","seller_price":"20.00","pick":"Medium"}],"additionals":[],"note":"","removable":false}]	{"sub_total":"297.46","delivery":"40.00","discount_code":null,"discount_price":0,"total_price":"278.00","customer_total_price":"337.46","seller_total_price":"278.00"}	\N	{"location":{"lat":15.1625562,"lng":120.5564923},"complete_address":"355 Yukon St , Angeles Central Luzon","note":""}	{"method":"cod","status":"pending","details":{}}	markup			2021-03-17 08:27:50.530625+00	2021-03-17 08:28:50.635+00
\.


                                                                                                                                                                                                                                                                                                                                                                 3273.dat                                                                                            0000600 0004000 0002000 00000000005 14024343251 0014241 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           3271.dat                                                                                            0000600 0004000 0002000 00001501534 14024343251 0014255 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	9	\N	{"lat":"15.1625688","lng":"120.5565145"}	2021-03-17 06:04:07.444+00
2	9	\N	{"lat":"15.1625688","lng":"120.5565145"}	2021-03-17 06:04:36.317+00
3	9	\N	{"lat":"15.1625688","lng":"120.5565145"}	2021-03-17 06:04:44.99+00
4	3	\N	{"lat":"15.1625635","lng":"120.5565031"}	2021-03-17 06:10:53.258+00
5	3	\N	{"lat":"15.1625594","lng":"120.556507"}	2021-03-17 06:10:59.387+00
6	3	\N	{"lat":"15.1625581","lng":"120.5565028"}	2021-03-17 06:11:16.568+00
7	3	\N	{"lat":"15.1625617","lng":"120.5565015"}	2021-03-17 06:11:23.89+00
8	3	\N	{"lat":"15.1625617","lng":"120.5565015"}	2021-03-17 06:11:24.586+00
9	3	\N	{"lat":"15.1625513","lng":"120.5565014"}	2021-03-17 06:11:26.661+00
10	3	\N	{"lat":"15.1625604","lng":"120.5565122"}	2021-03-17 06:11:29.379+00
11	3	\N	{"lat":"15.1625604","lng":"120.5565122"}	2021-03-17 06:11:34.698+00
12	3	\N	{"lat":"15.162565","lng":"120.5565074"}	2021-03-17 06:12:08.248+00
13	7	\N	{"lat":"15.1625551","lng":"120.5565106"}	2021-03-17 06:12:11.684+00
14	7	\N	{"lat":"15.1625621","lng":"120.556508"}	2021-03-17 06:12:15.997+00
15	3	\N	{"lat":"15.1625552","lng":"120.556515"}	2021-03-17 06:12:47.626+00
16	7	\N	{"lat":"15.1625621","lng":"120.556508"}	2021-03-17 06:12:48.325+00
17	7	\N	{"lat":"15.1625574","lng":"120.5565112"}	2021-03-17 06:13:06.927+00
18	7	\N	{"lat":"15.1625572","lng":"120.5565085"}	2021-03-17 06:13:13.034+00
19	7	\N	{"lat":"15.1625572","lng":"120.5565085"}	2021-03-17 06:13:13.497+00
20	7	\N	{"lat":"15.1625572","lng":"120.5565085"}	2021-03-17 06:13:14.39+00
21	2	\N	{"lat":"15.1625673","lng":"120.5565151"}	2021-03-17 06:13:29.645+00
22	2	\N	{"lat":"15.1625609","lng":"120.5565076"}	2021-03-17 06:13:33.974+00
23	2	\N	{"lat":"15.1625609","lng":"120.5565076"}	2021-03-17 06:13:34.086+00
24	2	\N	{"lat":"15.1625581","lng":"120.5565032"}	2021-03-17 06:13:38.177+00
25	3	\N	{"lat":"15.162562","lng":"120.5565018"}	2021-03-17 06:13:42.358+00
26	7	\N	{"lat":"15.1625572","lng":"120.5565085"}	2021-03-17 06:13:45.534+00
27	1	\N	{"lat":"15.1625602","lng":"120.5565121"}	2021-03-17 06:13:49.685+00
28	2	\N	{"lat":"15.1625583","lng":"120.5565039"}	2021-03-17 06:14:00.362+00
29	9	\N	{"lat":"15.1625562","lng":"120.556506"}	2021-03-17 06:14:00.564+00
30	3	\N	{"lat":"15.1625577","lng":"120.5565196"}	2021-03-17 06:14:01.87+00
31	1	\N	{"lat":"15.1625665","lng":"120.5565105"}	2021-03-17 06:14:04.722+00
32	2	\N	{"lat":"15.1625644","lng":"120.5565061"}	2021-03-17 06:14:21.049+00
33	2	\N	{"lat":"15.1625616","lng":"120.5565083"}	2021-03-17 06:14:25.36+00
34	1	\N	{"lat":"15.1625602","lng":"120.5565105"}	2021-03-17 06:14:30.059+00
35	1	\N	{"lat":"15.1625602","lng":"120.5565105"}	2021-03-17 06:14:30.296+00
36	1	\N	{"lat":"15.1625602","lng":"120.5565105"}	2021-03-17 06:14:31.568+00
37	3	\N	{"lat":"15.1625577","lng":"120.5565196"}	2021-03-17 06:14:32.372+00
38	1	\N	{"lat":"15.1625624","lng":"120.5565134"}	2021-03-17 06:14:37.874+00
39	9	\N	{"lat":"15.1625562","lng":"120.556506"}	2021-03-17 06:14:37.959+00
40	1	\N	{"lat":"15.1625624","lng":"120.5565134"}	2021-03-17 06:14:40.118+00
41	2	\N	{"lat":"15.162565","lng":"120.5565056"}	2021-03-17 06:14:42.357+00
42	10	\N	{"lat":"15.1625632","lng":"120.5565085"}	2021-03-17 06:14:42.749+00
43	5	\N	{"lat":"15.1625559","lng":"120.5565084"}	2021-03-17 06:14:46.528+00
44	1	\N	{"lat":"15.1625552","lng":"120.5564987"}	2021-03-17 06:14:48.151+00
45	5	\N	{"lat":"15.1625561","lng":"120.5564925"}	2021-03-17 06:14:50.939+00
46	10	\N	{"lat":"15.1625609","lng":"120.5565028"}	2021-03-17 06:14:54.259+00
47	10	\N	{"lat":"15.1625544","lng":"120.5565061"}	2021-03-17 06:14:56.936+00
48	1	\N	{"lat":"15.1625499","lng":"120.5565073"}	2021-03-17 06:14:57.346+00
49	2	\N	{"lat":"15.1625546","lng":"120.5565042"}	2021-03-17 06:15:02.542+00
50	1	\N	{"lat":"15.1625613","lng":"120.5565084"}	2021-03-17 06:15:04.995+00
51	10	\N	{"lat":"15.1625571","lng":"120.5565108"}	2021-03-17 06:15:10.176+00
52	5	\N	{"lat":"15.1625608","lng":"120.556488"}	2021-03-17 06:15:10.698+00
53	7	\N	{"lat":"15.1625572","lng":"120.5565085"}	2021-03-17 06:15:13.704+00
54	7	\N	{"lat":"15.1625484","lng":"120.5565062"}	2021-03-17 06:15:16.603+00
55	7	\N	{"lat":"15.1625484","lng":"120.5565062"}	2021-03-17 06:15:17.473+00
56	7	\N	{"lat":"15.1625484","lng":"120.5565062"}	2021-03-17 06:15:18.573+00
57	3	\N	{"lat":"15.1625552","lng":"120.5565087"}	2021-03-17 06:15:22.227+00
58	10	\N	{"lat":"15.1625568","lng":"120.5565134"}	2021-03-17 06:15:23.923+00
59	10	\N	{"lat":"15.1625568","lng":"120.5565045"}	2021-03-17 06:15:25.303+00
60	10	\N	{"lat":"15.1625578","lng":"120.5565093"}	2021-03-17 06:15:30.296+00
61	5	\N	{"lat":"15.1625595","lng":"120.5565047"}	2021-03-17 06:15:33.266+00
62	7	\N	{"lat":"15.1625593","lng":"120.5565089"}	2021-03-17 06:15:37.881+00
63	9	\N	{"lat":"15.1625562","lng":"120.556506"}	2021-03-17 06:15:38.064+00
64	5	\N	{"lat":"15.1625486","lng":"120.5565034"}	2021-03-17 06:15:43.065+00
65	2	\N	{"lat":"15.1625596","lng":"120.5565129"}	2021-03-17 06:15:43.209+00
66	7	\N	{"lat":"15.1625581","lng":"120.5565088"}	2021-03-17 06:15:43.632+00
67	10	\N	{"lat":"15.1625646","lng":"120.556507"}	2021-03-17 06:15:47.169+00
68	3	\N	{"lat":"15.1625552","lng":"120.5565087"}	2021-03-17 06:15:50.432+00
69	1	\N	{"lat":"15.162559","lng":"120.5565022"}	2021-03-17 06:15:50.977+00
70	2	\N	{"lat":"15.1625586","lng":"120.5565183"}	2021-03-17 06:15:51.243+00
71	2	\N	{"lat":"15.1625667","lng":"120.5565114"}	2021-03-17 06:15:55.516+00
72	2	\N	{"lat":"15.1625667","lng":"120.5565114"}	2021-03-17 06:15:58.049+00
73	8	\N	{"lat":"15.162556","lng":"120.556506"}	2021-03-17 06:16:09.793+00
74	8	\N	{"lat":"15.1625554","lng":"120.5565067"}	2021-03-17 06:16:12.329+00
75	8	\N	{"lat":"15.1625554","lng":"120.5565067"}	2021-03-17 06:16:12.834+00
76	8	\N	{"lat":"15.1625554","lng":"120.5565067"}	2021-03-17 06:16:12.9+00
77	5	\N	{"lat":"15.162559","lng":"120.5564925"}	2021-03-17 06:16:15.059+00
78	10	\N	{"lat":"15.1625646","lng":"120.556507"}	2021-03-17 06:16:19.262+00
79	1	\N	{"lat":"15.1625539","lng":"120.5565067"}	2021-03-17 06:16:22.285+00
80	4	\N	{"lat":"15.1625592","lng":"120.5565205"}	2021-03-17 06:16:24.442+00
81	1	\N	{"lat":"15.1625539","lng":"120.5565067"}	2021-03-17 06:16:26.216+00
82	4	\N	{"lat":"15.1625595","lng":"120.5564982"}	2021-03-17 06:16:38.608+00
83	1	\N	{"lat":"15.1625586","lng":"120.5565103"}	2021-03-17 06:16:42.529+00
84	5	\N	{"lat":"15.1625582","lng":"120.5565088"}	2021-03-17 06:16:43.614+00
85	8	\N	{"lat":"15.1625566","lng":"120.5565076"}	2021-03-17 06:16:47.098+00
86	8	\N	{"lat":"15.162557","lng":"120.5565062"}	2021-03-17 06:16:52.609+00
87	1	\N	{"lat":"15.162569","lng":"120.556516"}	2021-03-17 06:16:53.892+00
88	8	\N	{"lat":"15.1625628","lng":"120.5565087"}	2021-03-17 06:16:55.321+00
89	4	\N	{"lat":"15.1625606","lng":"120.5564999"}	2021-03-17 06:16:56.657+00
90	5	\N	{"lat":"15.1625567","lng":"120.5565031"}	2021-03-17 06:16:58.611+00
91	7	\N	{"lat":"15.1626189","lng":"120.5565293"}	2021-03-17 06:16:59.048+00
93	7	\N	{"lat":"15.1625643","lng":"120.556512"}	2021-03-17 06:17:02.392+00
94	4	\N	{"lat":"15.1625589","lng":"120.556505"}	2021-03-17 06:17:07.667+00
102	1	\N	{"lat":"15.1625554","lng":"120.5565087"}	2021-03-17 06:17:26.087+00
103	8	\N	{"lat":"15.1625554","lng":"120.5565093"}	2021-03-17 06:17:26.748+00
104	3	\N	{"lat":"15.1625552","lng":"120.5565087"}	2021-03-17 06:17:32.497+00
105	1	\N	{"lat":"15.1625561","lng":"120.556508"}	2021-03-17 06:17:38.177+00
106	7	\N	{"lat":"15.1625574","lng":"120.5565082"}	2021-03-17 06:17:41.944+00
1354	3	\N	{"lat":"15.1626883","lng":"120.5565501"}	2021-03-17 07:01:17.187+00
1767	3	24	{"lat":15.1626677,"lng":120.5565635}	2021-03-17 06:41:49.16+00
1768	3	24	{"lat":15.1626659,"lng":120.5565649}	2021-03-17 06:41:59.117+00
1769	3	24	{"lat":15.1626681,"lng":120.5565613}	2021-03-17 06:42:04.124+00
1770	3	24	{"lat":15.1626697,"lng":120.5565598}	2021-03-17 06:42:09.153+00
1771	3	24	{"lat":15.1626658,"lng":120.556562}	2021-03-17 06:42:19.162+00
1772	3	24	{"lat":15.1626615,"lng":120.5565615}	2021-03-17 06:42:24.161+00
1773	3	24	{"lat":15.1626683,"lng":120.5565607}	2021-03-17 06:42:29.109+00
1774	3	24	{"lat":15.1626665,"lng":120.5565611}	2021-03-17 06:42:34.128+00
1775	3	24	{"lat":15.1626684,"lng":120.556561}	2021-03-17 06:42:39.154+00
1776	3	24	{"lat":15.16267,"lng":120.5565647}	2021-03-17 06:42:49.14+00
1777	3	24	{"lat":15.1626675,"lng":120.5565617}	2021-03-17 06:42:54.138+00
1778	3	24	{"lat":15.1626675,"lng":120.5565617}	2021-03-17 06:42:58.322+00
1779	3	24	{"lat":15.1626675,"lng":120.5565617}	2021-03-17 06:43:03.336+00
1780	3	24	{"lat":15.1626675,"lng":120.5565617}	2021-03-17 06:43:08.334+00
1781	3	24	{"lat":15.1626697,"lng":120.5565627}	2021-03-17 06:43:19.042+00
1782	3	24	{"lat":15.1626739,"lng":120.5565614}	2021-03-17 06:43:24.104+00
1783	3	24	{"lat":15.1626705,"lng":120.5565628}	2021-03-17 06:43:29.117+00
1784	3	24	{"lat":15.162665,"lng":120.556562}	2021-03-17 06:43:34.149+00
1785	3	24	{"lat":15.1626653,"lng":120.5565601}	2021-03-17 06:43:39.068+00
1786	3	24	{"lat":15.1626678,"lng":120.5565561}	2021-03-17 06:43:49.09+00
1787	3	24	{"lat":15.1626663,"lng":120.5565593}	2021-03-17 06:43:54.127+00
1788	3	24	{"lat":15.1626663,"lng":120.5565593}	2021-03-17 06:43:58.321+00
1789	3	24	{"lat":15.1626663,"lng":120.5565593}	2021-03-17 06:44:03.334+00
1790	3	24	{"lat":15.1626686,"lng":120.5565602}	2021-03-17 06:45:12.603+00
1791	3	24	{"lat":15.1626734,"lng":120.5565623}	2021-03-17 06:45:18.401+00
1792	3	24	{"lat":15.1626709,"lng":120.5565644}	2021-03-17 06:45:23.353+00
1793	3	24	{"lat":15.1626608,"lng":120.5565607}	2021-03-17 06:45:33.42+00
1794	3	24	{"lat":15.1626678,"lng":120.5565583}	2021-03-17 06:45:38.357+00
1795	3	24	{"lat":15.1626678,"lng":120.5565583}	2021-03-17 06:45:42.657+00
1796	3	24	{"lat":15.1626678,"lng":120.5565583}	2021-03-17 06:45:47.636+00
1797	3	24	{"lat":15.1626678,"lng":120.5565583}	2021-03-17 06:45:52.651+00
1798	3	24	{"lat":15.1626678,"lng":120.5565583}	2021-03-17 06:47:00.556+00
1799	3	24	{"lat":15.1626692,"lng":120.5565581}	2021-03-17 06:47:10.599+00
1800	3	24	{"lat":15.1626692,"lng":120.5565581}	2021-03-17 06:47:15.597+00
1801	3	24	{"lat":15.1599455,"lng":120.5582168}	2021-03-17 06:47:21.456+00
1802	3	24	{"lat":15.159864,"lng":120.5582758}	2021-03-17 06:47:28.278+00
1803	3	24	{"lat":15.159957,"lng":120.5583524}	2021-03-17 06:47:31.993+00
1804	3	24	{"lat":15.159516,"lng":120.5584636}	2021-03-17 06:47:35.59+00
1805	3	24	{"lat":15.1591706,"lng":120.5585112}	2021-03-17 06:47:40.55+00
1806	3	24	{"lat":15.1591706,"lng":120.5585112}	2021-03-17 06:47:45.565+00
1807	3	24	{"lat":15.1591706,"lng":120.5585112}	2021-03-17 06:47:55.935+00
1808	3	24	{"lat":15.1591706,"lng":120.5585112}	2021-03-17 06:50:35.422+00
1809	3	24	{"lat":15.1591706,"lng":120.5585112}	2021-03-17 06:50:40.425+00
1810	3	24	{"lat":15.1591706,"lng":120.5585112}	2021-03-17 06:50:45.431+00
1811	3	24	{"lat":15.1591706,"lng":120.5585112}	2021-03-17 06:50:59.785+00
1812	3	24	{"lat":15.1591706,"lng":120.5585112}	2021-03-17 06:52:44.137+00
1813	3	24	{"lat":15.1383824,"lng":120.5640661}	2021-03-17 06:52:49.938+00
1814	3	24	{"lat":15.1383824,"lng":120.5640661}	2021-03-17 06:52:54.355+00
1815	3	24	{"lat":15.1387258,"lng":120.5626335}	2021-03-17 06:53:04.372+00
1816	3	24	{"lat":15.1387478,"lng":120.5627238}	2021-03-17 06:53:12.531+00
1817	3	24	{"lat":15.1387478,"lng":120.5627238}	2021-03-17 06:53:14.125+00
1818	3	24	{"lat":15.1387644,"lng":120.5627682}	2021-03-17 06:53:20.05+00
1819	3	24	{"lat":15.1387198,"lng":120.5627723}	2021-03-17 06:53:24.977+00
1820	3	24	{"lat":15.1386294,"lng":120.5627529}	2021-03-17 06:53:34.303+00
1821	3	24	{"lat":15.1386066,"lng":120.5627797}	2021-03-17 06:53:39.9+00
1822	3	24	{"lat":15.138643,"lng":120.5627913}	2021-03-17 06:53:44.92+00
1823	3	24	{"lat":15.1386171,"lng":120.5627733}	2021-03-17 06:53:49.964+00
1824	3	24	{"lat":15.1386146,"lng":120.562768}	2021-03-17 06:53:54.375+00
1825	3	24	{"lat":15.1386085,"lng":120.5627373}	2021-03-17 06:54:04.336+00
1826	3	24	{"lat":15.1386721,"lng":120.562786}	2021-03-17 06:54:10.003+00
1827	3	24	{"lat":15.138679,"lng":120.5627829}	2021-03-17 06:54:14.332+00
1828	3	24	{"lat":15.1386627,"lng":120.5627803}	2021-03-17 06:54:19.866+00
1829	3	24	{"lat":15.1386615,"lng":120.5627675}	2021-03-17 06:54:24.943+00
1830	3	24	{"lat":15.138673,"lng":120.562779}	2021-03-17 06:54:34.371+00
1831	3	24	{"lat":15.1386459,"lng":120.5627629}	2021-03-17 06:54:39.926+00
1832	3	24	{"lat":15.1386376,"lng":120.5627526}	2021-03-17 06:54:44.896+00
1833	3	24	{"lat":15.1386422,"lng":120.5629816}	2021-03-17 06:54:50.594+00
1834	3	24	{"lat":15.1386421,"lng":120.5629851}	2021-03-17 06:54:54.31+00
1835	3	24	{"lat":15.1386438,"lng":120.5627774}	2021-03-17 06:55:04.344+00
1836	3	24	{"lat":15.1387398,"lng":120.5626636}	2021-03-17 06:55:09.903+00
1837	3	24	{"lat":15.1386985,"lng":120.56299}	2021-03-17 06:55:15.573+00
1838	3	24	{"lat":15.1386943,"lng":120.5630074}	2021-03-17 06:55:19.944+00
1839	3	24	{"lat":15.1387394,"lng":120.5628427}	2021-03-17 06:55:25.017+00
1840	3	24	{"lat":15.1387267,"lng":120.5628934}	2021-03-17 06:55:35.61+00
1841	3	24	{"lat":15.1387253,"lng":120.5628996}	2021-03-17 06:55:39.937+00
1842	3	24	{"lat":15.1387259,"lng":120.562897}	2021-03-17 06:55:45.604+00
1843	3	24	{"lat":15.1387259,"lng":120.562897}	2021-03-17 06:55:49.909+00
1844	3	24	{"lat":15.1387259,"lng":120.562897}	2021-03-17 06:55:55.617+00
1845	3	24	{"lat":15.1387259,"lng":120.562897}	2021-03-17 06:56:04.129+00
1846	3	24	{"lat":15.1387233,"lng":120.5628973}	2021-03-17 06:56:09.128+00
1847	3	24	{"lat":15.1387233,"lng":120.5628973}	2021-03-17 06:56:14.131+00
92	1	\N	{"lat":"15.1625604","lng":"120.5565087"}	2021-03-17 06:16:59.944+00
100	10	\N	{"lat":"15.162562","lng":"120.5565006"}	2021-03-17 06:17:19.405+00
101	4	\N	{"lat":"15.1625592","lng":"120.5565101"}	2021-03-17 06:17:23.174+00
1355	1	\N	{"lat":"15.1443432","lng":"120.5595213"}	2021-03-17 07:01:22.853+00
1356	3	\N	{"lat":"15.1628101","lng":"120.5565185"}	2021-03-17 07:01:47.324+00
1848	3	24	{"lat":15.1387233,"lng":120.5628973}	2021-03-17 06:56:19.119+00
1849	3	24	{"lat":15.1387233,"lng":120.5628973}	2021-03-17 06:56:24.129+00
1850	3	24	{"lat":15.1387233,"lng":120.5628973}	2021-03-17 06:56:29.129+00
1851	3	24	{"lat":15.1387233,"lng":120.5628973}	2021-03-17 06:56:34.147+00
1852	3	24	{"lat":15.1387233,"lng":120.5628973}	2021-03-17 06:56:39.163+00
1853	3	24	{"lat":15.1387233,"lng":120.5628973}	2021-03-17 06:56:44.141+00
1854	3	24	{"lat":15.1387233,"lng":120.5628973}	2021-03-17 06:56:49.147+00
1855	3	24	{"lat":15.1387233,"lng":120.5628973}	2021-03-17 06:56:54.153+00
1856	3	24	{"lat":15.1387233,"lng":120.5628973}	2021-03-17 06:56:59.157+00
1857	3	24	{"lat":15.1387233,"lng":120.5628973}	2021-03-17 06:57:04.152+00
1858	3	24	{"lat":15.1427892,"lng":120.5603374}	2021-03-17 06:57:09.143+00
1859	3	24	{"lat":15.1427892,"lng":120.5603374}	2021-03-17 06:57:14.148+00
1860	3	24	{"lat":15.1427892,"lng":120.5603374}	2021-03-17 06:57:19.159+00
1861	3	24	{"lat":15.1427892,"lng":120.5603374}	2021-03-17 06:57:24.145+00
1862	3	24	{"lat":15.1427892,"lng":120.5603374}	2021-03-17 06:57:29.128+00
1863	3	24	{"lat":15.1427892,"lng":120.5603374}	2021-03-17 06:57:34.131+00
1864	3	24	{"lat":15.1427892,"lng":120.5603374}	2021-03-17 06:57:39.152+00
1865	3	24	{"lat":15.1448548,"lng":120.5594459}	2021-03-17 06:57:44.32+00
1866	3	24	{"lat":15.1461352,"lng":120.5595413}	2021-03-17 06:57:50.305+00
1867	3	24	{"lat":15.146942,"lng":120.5594111}	2021-03-17 06:57:55.596+00
1868	3	24	{"lat":15.1481413,"lng":120.5594461}	2021-03-17 06:58:04.953+00
1869	3	24	{"lat":15.1491563,"lng":120.559347}	2021-03-17 06:58:10.199+00
1870	3	24	{"lat":15.1491563,"lng":120.559347}	2021-03-17 06:58:14.141+00
1871	3	24	{"lat":15.1491563,"lng":120.559347}	2021-03-17 06:58:19.142+00
1872	3	24	{"lat":15.1599074,"lng":120.5582449}	2021-03-17 06:59:56.915+00
1873	3	24	{"lat":15.1603283,"lng":120.5580232}	2021-03-17 07:00:01.946+00
1874	3	24	{"lat":15.1605129,"lng":120.5580449}	2021-03-17 07:00:07.02+00
1875	3	24	{"lat":15.1613739,"lng":120.557796}	2021-03-17 07:00:13.878+00
1876	3	24	{"lat":15.1617103,"lng":120.5577362}	2021-03-17 07:00:21.053+00
1877	3	24	{"lat":15.1617103,"lng":120.5577362}	2021-03-17 07:00:26.072+00
1878	3	24	{"lat":15.1617103,"lng":120.5577362}	2021-03-17 07:00:31.077+00
1879	3	24	{"lat":15.1617103,"lng":120.5577362}	2021-03-17 07:00:36.075+00
1880	3	24	{"lat":15.1617103,"lng":120.5577362}	2021-03-17 07:00:41.068+00
1881	3	24	{"lat":15.1617103,"lng":120.5577362}	2021-03-17 07:00:46.057+00
1882	3	24	{"lat":15.1617103,"lng":120.5577362}	2021-03-17 07:00:51.095+00
1883	3	24	{"lat":15.1617103,"lng":120.5577362}	2021-03-17 07:00:56.075+00
1884	3	24	{"lat":15.1617103,"lng":120.5577362}	2021-03-17 07:01:01.059+00
1885	3	24	{"lat":15.1626328,"lng":120.5565429}	2021-03-17 07:01:06.051+00
1886	3	24	{"lat":15.1626328,"lng":120.5565429}	2021-03-17 07:01:11.08+00
1887	3	24	{"lat":15.1626883,"lng":120.5565501}	2021-03-17 07:01:16.069+00
1888	3	24	{"lat":15.1628028,"lng":120.5565219}	2021-03-17 07:01:21.079+00
1889	3	24	{"lat":15.1628098,"lng":120.5565187}	2021-03-17 07:01:26.084+00
1890	3	24	{"lat":15.1628101,"lng":120.5565185}	2021-03-17 07:01:31.075+00
1891	3	24	{"lat":15.1628101,"lng":120.5565185}	2021-03-17 07:01:36.07+00
1892	3	24	{"lat":15.1628101,"lng":120.5565185}	2021-03-17 07:01:41.078+00
1893	3	24	{"lat":15.1628101,"lng":120.5565185}	2021-03-17 07:01:46.179+00
1894	3	24	{"lat":15.1628101,"lng":120.5565185}	2021-03-17 07:01:51.894+00
1895	3	24	{"lat":15.1626933,"lng":120.5565539}	2021-03-17 07:01:56.779+00
1896	3	24	{"lat":15.1626615,"lng":120.5565651}	2021-03-17 07:02:01.903+00
1897	3	24	{"lat":15.1626663,"lng":120.5565643}	2021-03-17 07:02:06.883+00
1898	3	24	{"lat":15.1626698,"lng":120.5565615}	2021-03-17 07:02:11.942+00
1899	3	24	{"lat":15.1626698,"lng":120.5565615}	2021-03-17 07:02:21.079+00
1900	3	24	{"lat":15.1626698,"lng":120.5565615}	2021-03-17 07:02:26.087+00
1901	3	24	{"lat":15.1626698,"lng":120.5565615}	2021-03-17 07:02:58.167+00
1902	3	24	{"lat":15.1625606,"lng":120.556509}	2021-03-17 07:03:04.066+00
1903	3	24	{"lat":15.1625638,"lng":120.5565078}	2021-03-17 07:03:08.994+00
1904	3	24	{"lat":15.1625634,"lng":120.5564993}	2021-03-17 07:03:18.944+00
1905	3	24	{"lat":15.1625644,"lng":120.5564999}	2021-03-17 07:03:24.018+00
1906	3	24	{"lat":15.1625648,"lng":120.5565007}	2021-03-17 07:03:29.039+00
1907	3	24	{"lat":15.1625661,"lng":120.5565013}	2021-03-17 07:03:34.032+00
1908	3	24	{"lat":15.1625647,"lng":120.5565012}	2021-03-17 07:03:38.247+00
1909	3	24	{"lat":15.1625647,"lng":120.5565012}	2021-03-17 07:03:43.179+00
1910	3	24	{"lat":15.1625653,"lng":120.5565011}	2021-03-17 07:03:48.198+00
1911	3	24	{"lat":15.1625653,"lng":120.5565011}	2021-03-17 07:03:53.189+00
1912	3	24	{"lat":15.1625653,"lng":120.5565011}	2021-03-17 07:03:58.209+00
1913	3	24	{"lat":15.1625653,"lng":120.5565011}	2021-03-17 07:04:03.198+00
1914	3	24	{"lat":15.1625653,"lng":120.5565011}	2021-03-17 07:04:08.18+00
1915	3	24	{"lat":15.1625653,"lng":120.5565011}	2021-03-17 07:04:13.243+00
1916	3	24	{"lat":15.1625653,"lng":120.5565011}	2021-03-17 07:04:18.178+00
1917	3	24	{"lat":15.1625653,"lng":120.5565011}	2021-03-17 07:04:23.22+00
1918	3	\N	{"lat":"15.1625673","lng":"120.556495"}	2021-03-17 07:04:27.927+00
2070	2	\N	{"lat":"15.163815","lng":"120.5909894"}	2021-03-17 07:08:30.573+00
2073	8	6	{"lat":15.1626626,"lng":120.5565599}	2021-03-17 06:35:16.034+00
2074	8	6	{"lat":15.1626654,"lng":120.5565612}	2021-03-17 06:35:21.015+00
2075	8	6	{"lat":15.1626657,"lng":120.5565622}	2021-03-17 06:35:25.956+00
2076	8	6	{"lat":15.1626695,"lng":120.5565648}	2021-03-17 06:35:30.972+00
2077	8	6	{"lat":15.1626628,"lng":120.5565598}	2021-03-17 06:35:35.948+00
2078	8	6	{"lat":15.1626675,"lng":120.5565611}	2021-03-17 06:35:41.072+00
2079	8	6	{"lat":15.1626688,"lng":120.5565639}	2021-03-17 06:35:45.936+00
2080	8	6	{"lat":15.1626692,"lng":120.5565676}	2021-03-17 06:35:51.074+00
2081	8	6	{"lat":15.1626711,"lng":120.556563}	2021-03-17 06:35:56.068+00
2082	8	6	{"lat":15.1626713,"lng":120.5565612}	2021-03-17 06:36:01.076+00
2083	8	6	{"lat":15.1626718,"lng":120.5565623}	2021-03-17 06:36:06.05+00
2084	8	6	{"lat":15.1626693,"lng":120.556565}	2021-03-17 06:36:11.101+00
95	1	\N	{"lat":"15.1625574","lng":"120.5565036"}	2021-03-17 06:17:08.667+00
96	7	\N	{"lat":"15.1625647","lng":"120.5565093"}	2021-03-17 06:17:09.585+00
97	4	\N	{"lat":"15.1625627","lng":"120.5565072"}	2021-03-17 06:17:16.528+00
98	10	\N	{"lat":"15.1625574","lng":"120.5565034"}	2021-03-17 06:17:17.129+00
99	1	\N	{"lat":"15.1625606","lng":"120.5565102"}	2021-03-17 06:17:18.124+00
107	4	\N	{"lat":"15.1625585","lng":"120.5565106"}	2021-03-17 06:17:55.845+00
108	8	\N	{"lat":"15.1625555","lng":"120.5565071"}	2021-03-17 06:17:58.373+00
109	9	\N	{"lat":"15.1625562","lng":"120.556506"}	2021-03-17 06:18:04.342+00
110	1	\N	{"lat":"15.1625575","lng":"120.5565089"}	2021-03-17 06:18:10.248+00
111	4	\N	{"lat":"15.1625559","lng":"120.556512"}	2021-03-17 06:18:10.357+00
112	7	\N	{"lat":"15.162592","lng":"120.556522"}	2021-03-17 06:18:12.223+00
113	5	\N	{"lat":"15.1625567","lng":"120.5565031"}	2021-03-17 06:18:18.916+00
114	8	\N	{"lat":"15.1625596","lng":"120.5564994"}	2021-03-17 06:18:26.735+00
115	1	\N	{"lat":"15.1625497","lng":"120.5565005"}	2021-03-17 06:18:39.502+00
116	4	\N	{"lat":"15.1625587","lng":"120.5565094"}	2021-03-17 06:18:42.938+00
117	8	\N	{"lat":"15.1625529","lng":"120.556503"}	2021-03-17 06:18:59.637+00
118	1	\N	{"lat":"15.1625485","lng":"120.5565013"}	2021-03-17 06:19:09.498+00
119	10	\N	{"lat":"15.162556","lng":"120.5565118"}	2021-03-17 06:19:23.756+00
120	8	\N	{"lat":"15.1625561","lng":"120.5565058"}	2021-03-17 06:19:29.597+00
121	2	\N	{"lat":"15.1625608","lng":"120.5565116"}	2021-03-17 06:19:39.348+00
122	3	\N	{"lat":"15.1625552","lng":"120.5565087"}	2021-03-17 06:19:42.061+00
123	5	\N	{"lat":"15.162555","lng":"120.5565066"}	2021-03-17 06:19:49.577+00
124	10	\N	{"lat":"15.1625642","lng":"120.5564949"}	2021-03-17 06:19:51.067+00
125	3	\N	{"lat":"15.1625571","lng":"120.5565159"}	2021-03-17 06:19:51.897+00
126	9	\N	{"lat":"15.1625562","lng":"120.556506"}	2021-03-17 06:19:57.997+00
127	4	\N	{"lat":"15.1625588","lng":"120.556508"}	2021-03-17 06:19:58.862+00
128	9	\N	{"lat":"15.1625562","lng":"120.556506"}	2021-03-17 06:20:03.567+00
129	4	\N	{"lat":"15.1625612","lng":"120.5565004"}	2021-03-17 06:20:03.781+00
130	1	\N	{"lat":"15.1625672","lng":"120.5565137"}	2021-03-17 06:20:04.48+00
131	8	\N	{"lat":"15.1625638","lng":"120.5565192"}	2021-03-17 06:20:04.652+00
132	3	\N	{"lat":"15.1625571","lng":"120.5565159"}	2021-03-17 06:20:15.318+00
133	8	\N	{"lat":"15.1625638","lng":"120.5565086"}	2021-03-17 06:20:21.227+00
134	5	\N	{"lat":"15.1625471","lng":"120.5565099"}	2021-03-17 06:20:21.781+00
135	2	\N	{"lat":"15.1625536","lng":"120.5565056"}	2021-03-17 06:20:22.937+00
136	3	\N	{"lat":"15.1625604","lng":"120.5565077"}	2021-03-17 06:20:32.485+00
137	9	\N	{"lat":"15.1625562","lng":"120.556506"}	2021-03-17 06:20:34.724+00
138	1	\N	{"lat":"15.1625539","lng":"120.5565036"}	2021-03-17 06:20:35.746+00
139	4	\N	{"lat":"15.1625622","lng":"120.5565043"}	2021-03-17 06:20:36.537+00
140	1	\N	{"lat":"15.1625568","lng":"120.5565091"}	2021-03-17 06:20:50.693+00
141	2	\N	{"lat":"15.1625542","lng":"120.5565077"}	2021-03-17 06:20:57.523+00
142	8	\N	{"lat":"15.1625595","lng":"120.5565136"}	2021-03-17 06:21:00.807+00
143	9	\N	{"lat":"15.1625562","lng":"120.556506"}	2021-03-17 06:21:04.858+00
144	4	\N	{"lat":"15.1625592","lng":"120.5565128"}	2021-03-17 06:21:06.484+00
145	1	\N	{"lat":"15.1625578","lng":"120.556507"}	2021-03-17 06:21:22.976+00
146	8	\N	{"lat":"15.1625579","lng":"120.5565206"}	2021-03-17 06:21:32.184+00
147	9	\N	{"lat":"15.1625562","lng":"120.556506"}	2021-03-17 06:21:34.83+00
148	4	\N	{"lat":"15.1625569","lng":"120.5565103"}	2021-03-17 06:21:36.518+00
149	1	\N	{"lat":"15.1625563","lng":"120.5565"}	2021-03-17 06:21:54.833+00
150	8	\N	{"lat":"15.1625516","lng":"120.5565022"}	2021-03-17 06:22:03.036+00
151	9	\N	{"lat":"15.1625562","lng":"120.556506"}	2021-03-17 06:22:04.711+00
152	4	\N	{"lat":"15.1625644","lng":"120.5564947"}	2021-03-17 06:22:06.513+00
153	2	\N	{"lat":"15.1625552","lng":"120.5565017"}	2021-03-17 06:22:19.856+00
154	2	\N	{"lat":"15.1625552","lng":"120.5565017"}	2021-03-17 06:22:21.399+00
155	1	\N	{"lat":"15.1625578","lng":"120.5565099"}	2021-03-17 06:22:23.013+00
156	2	\N	{"lat":"15.1625601","lng":"120.5565087"}	2021-03-17 06:22:26.599+00
157	8	\N	{"lat":"15.1625569","lng":"120.556511"}	2021-03-17 06:22:27.996+00
158	2	\N	{"lat":"15.1625565","lng":"120.5565057"}	2021-03-17 06:22:28.491+00
159	9	\N	{"lat":"15.1625562","lng":"120.556506"}	2021-03-17 06:22:34.695+00
160	4	\N	{"lat":"15.1625556","lng":"120.5565176"}	2021-03-17 06:22:36.378+00
161	8	\N	{"lat":"15.1625533","lng":"120.5565066"}	2021-03-17 06:23:06.509+00
162	9	\N	{"lat":"15.1625562","lng":"120.556506"}	2021-03-17 06:23:06.684+00
163	1	\N	{"lat":"15.1625547","lng":"120.5565076"}	2021-03-17 06:23:08.827+00
164	4	\N	{"lat":"15.1625606","lng":"120.5565079"}	2021-03-17 06:23:09.509+00
165	1	\N	{"lat":"15.1625628","lng":"120.5565053"}	2021-03-17 06:23:22.843+00
166	4	\N	{"lat":"15.1625479","lng":"120.5565179"}	2021-03-17 06:23:37.241+00
167	9	\N	{"lat":"15.1625562","lng":"120.556506"}	2021-03-17 06:23:44.553+00
168	1	\N	{"lat":"15.1625558","lng":"120.5565133"}	2021-03-17 06:23:59.019+00
169	8	\N	{"lat":"15.1625586","lng":"120.5565066"}	2021-03-17 06:23:59.425+00
170	4	\N	{"lat":"15.1625624","lng":"120.5565076"}	2021-03-17 06:24:04.304+00
171	9	\N	{"lat":"15.1625562","lng":"120.556506"}	2021-03-17 06:24:04.718+00
172	4	\N	{"lat":"15.1625588","lng":"120.556505"}	2021-03-17 06:24:06.622+00
173	4	\N	{"lat":"15.1625588","lng":"120.556505"}	2021-03-17 06:24:08.585+00
174	8	\N	{"lat":"15.1625639","lng":"120.5565096"}	2021-03-17 06:24:32.319+00
175	9	\N	{"lat":"15.1625562","lng":"120.556506"}	2021-03-17 06:24:35.673+00
176	4	\N	{"lat":"15.1625569","lng":"120.5565038"}	2021-03-17 06:24:44.057+00
177	8	\N	{"lat":"15.1625578","lng":"120.5565076"}	2021-03-17 06:24:59.363+00
178	9	\N	{"lat":"15.1625562","lng":"120.556506"}	2021-03-17 06:25:04.737+00
179	4	\N	{"lat":"15.1625544","lng":"120.5565143"}	2021-03-17 06:25:11.252+00
180	8	\N	{"lat":"15.1625559","lng":"120.5565082"}	2021-03-17 06:25:30.171+00
181	9	\N	{"lat":"15.1625562","lng":"120.556506"}	2021-03-17 06:25:37.509+00
182	4	\N	{"lat":"15.1625544","lng":"120.5565075"}	2021-03-17 06:25:43.064+00
183	9	\N	{"lat":"15.1625562","lng":"120.556506"}	2021-03-17 06:26:04.812+00
184	8	\N	{"lat":"15.1625579","lng":"120.556506"}	2021-03-17 06:26:06.243+00
185	4	\N	{"lat":"15.1625553","lng":"120.5565173"}	2021-03-17 06:26:11.262+00
186	8	\N	{"lat":"15.1625566","lng":"120.5564976"}	2021-03-17 06:26:30.977+00
187	9	\N	{"lat":"15.1625562","lng":"120.556506"}	2021-03-17 06:26:35.48+00
188	4	\N	{"lat":"15.1625522","lng":"120.5565029"}	2021-03-17 06:26:42.279+00
189	1	1	{"lat":15.1625639,"lng":120.5565154}	2021-03-17 06:24:21.973+00
190	1	1	{"lat":15.1625574,"lng":120.5565087}	2021-03-17 06:24:31.931+00
191	1	1	{"lat":15.1625566,"lng":120.5565118}	2021-03-17 06:24:41.942+00
192	1	1	{"lat":15.1625518,"lng":120.5565068}	2021-03-17 06:24:51.924+00
193	1	1	{"lat":15.1625528,"lng":120.5565063}	2021-03-17 06:25:01.602+00
194	1	1	{"lat":15.1625633,"lng":120.5565122}	2021-03-17 06:25:05.975+00
195	1	1	{"lat":15.1625633,"lng":120.5565122}	2021-03-17 06:25:11.021+00
196	1	1	{"lat":15.1625597,"lng":120.5565118}	2021-03-17 06:25:16.898+00
197	1	1	{"lat":15.162563,"lng":120.5565151}	2021-03-17 06:25:21.947+00
198	1	1	{"lat":15.1625593,"lng":120.5564988}	2021-03-17 06:25:31.921+00
199	1	1	{"lat":15.1625581,"lng":120.556508}	2021-03-17 06:25:36.983+00
200	1	1	{"lat":15.1625606,"lng":120.5565154}	2021-03-17 06:25:46.944+00
201	1	1	{"lat":15.1625607,"lng":120.5565179}	2021-03-17 06:25:52.009+00
202	1	1	{"lat":15.1625571,"lng":120.5565092}	2021-03-17 06:26:01.964+00
203	1	1	{"lat":15.1625578,"lng":120.5565014}	2021-03-17 06:26:11.932+00
204	1	1	{"lat":15.1625624,"lng":120.5565018}	2021-03-17 06:26:17.009+00
205	1	1	{"lat":15.1625595,"lng":120.5565077}	2021-03-17 06:26:26.938+00
206	1	1	{"lat":15.1625554,"lng":120.5565087}	2021-03-17 06:26:36.944+00
207	1	1	{"lat":15.1625558,"lng":120.5564975}	2021-03-17 06:26:42.005+00
208	1	1	{"lat":15.1625554,"lng":120.5565003}	2021-03-17 06:26:51.928+00
209	1	1	{"lat":15.1625555,"lng":120.556508}	2021-03-17 06:26:59.086+00
210	1	1	{"lat":15.1625555,"lng":120.556508}	2021-03-17 06:27:00.981+00
211	8	\N	{"lat":"15.1625594","lng":"120.5565017"}	2021-03-17 06:27:10.222+00
212	1	\N	{"lat":"15.1625591","lng":"120.5564973"}	2021-03-17 06:27:11.163+00
213	8	\N	{"lat":"15.1625579","lng":"120.5565033"}	2021-03-17 06:27:14.171+00
214	4	\N	{"lat":"15.1625568","lng":"120.5565121"}	2021-03-17 06:27:14.44+00
215	2	\N	{"lat":"15.162551","lng":"120.5565051"}	2021-03-17 06:27:17.052+00
216	1	\N	{"lat":"15.1625495","lng":"120.5565051"}	2021-03-17 06:27:17.17+00
217	2	\N	{"lat":"15.1625544","lng":"120.5564932"}	2021-03-17 06:27:21.85+00
218	2	\N	{"lat":"15.1625547","lng":"120.5565135"}	2021-03-17 06:27:28.19+00
219	4	\N	{"lat":"15.1625572","lng":"120.5565174"}	2021-03-17 06:27:29.922+00
220	2	\N	{"lat":"15.1625572","lng":"120.556497"}	2021-03-17 06:27:31.398+00
221	4	\N	{"lat":"15.162562","lng":"120.5565129"}	2021-03-17 06:27:35.88+00
222	10	\N	{"lat":"15.162562","lng":"120.5565005"}	2021-03-17 06:27:37.176+00
223	8	\N	{"lat":"15.1625539","lng":"120.556511"}	2021-03-17 06:27:37.672+00
224	10	\N	{"lat":"15.1625581","lng":"120.5565095"}	2021-03-17 06:27:49.933+00
225	5	\N	{"lat":"15.1625581","lng":"120.556502"}	2021-03-17 06:27:50.039+00
226	1	\N	{"lat":"15.1625797","lng":"120.5565219"}	2021-03-17 06:27:52.324+00
227	10	\N	{"lat":"15.1625581","lng":"120.5565084"}	2021-03-17 06:28:05.774+00
228	10	\N	{"lat":"15.1625615","lng":"120.5565132"}	2021-03-17 06:28:09.196+00
229	4	\N	{"lat":"15.162561","lng":"120.5565048"}	2021-03-17 06:28:09.655+00
230	10	\N	{"lat":"15.1625615","lng":"120.5565132"}	2021-03-17 06:28:11.508+00
231	10	\N	{"lat":"15.162555","lng":"120.5565088"}	2021-03-17 06:28:13.787+00
232	5	\N	{"lat":"15.1626187","lng":"120.5565343"}	2021-03-17 06:28:16.438+00
233	5	\N	{"lat":"15.1626755","lng":"120.5565618"}	2021-03-17 06:28:20.274+00
234	8	\N	{"lat":"15.1626733","lng":"120.5565661"}	2021-03-17 06:28:23.707+00
235	9	\N	{"lat":"15.1625562","lng":"120.556506"}	2021-03-17 06:28:25.042+00
236	5	\N	{"lat":"15.162676","lng":"120.5565598"}	2021-03-17 06:28:33.762+00
237	4	\N	{"lat":"15.162561","lng":"120.5564986"}	2021-03-17 06:28:43.179+00
238	10	\N	{"lat":"15.1625641","lng":"120.5565089"}	2021-03-17 06:28:46.49+00
239	10	\N	{"lat":"15.1625562","lng":"120.5565095"}	2021-03-17 06:28:54.523+00
240	1	\N	{"lat":"15.1625797","lng":"120.5565219"}	2021-03-17 06:29:01.457+00
241	5	\N	{"lat":"15.1626669","lng":"120.5565602"}	2021-03-17 06:29:05.711+00
242	2	\N	{"lat":"15.1626693","lng":"120.5565642"}	2021-03-17 06:29:08.408+00
243	4	\N	{"lat":"15.1625597","lng":"120.5564989"}	2021-03-17 06:29:08.779+00
244	10	\N	{"lat":"15.1625654","lng":"120.5565172"}	2021-03-17 06:29:09.358+00
245	8	\N	{"lat":"15.1626722","lng":"120.5565599"}	2021-03-17 06:29:29.37+00
246	5	\N	{"lat":"15.1626603","lng":"120.5565603"}	2021-03-17 06:29:35.89+00
247	5	\N	{"lat":"15.1626603","lng":"120.5565603"}	2021-03-17 06:29:37.589+00
248	10	\N	{"lat":"15.1625573","lng":"120.5565058"}	2021-03-17 06:29:38.195+00
249	2	\N	{"lat":"15.1626667","lng":"120.5565595"}	2021-03-17 06:29:39.981+00
250	10	\N	{"lat":"15.1625637","lng":"120.5565068"}	2021-03-17 06:29:40.01+00
251	8	\N	{"lat":"15.162666","lng":"120.5565599"}	2021-03-17 06:29:40.159+00
252	5	\N	{"lat":"15.1626666","lng":"120.5565616"}	2021-03-17 06:29:40.654+00
253	8	\N	{"lat":"15.162666","lng":"120.5565599"}	2021-03-17 06:29:41.693+00
254	4	\N	{"lat":"15.1625593","lng":"120.5565055"}	2021-03-17 06:29:45.378+00
255	8	\N	{"lat":"15.1626678","lng":"120.5565623"}	2021-03-17 06:29:48.077+00
256	2	\N	{"lat":"15.1626684","lng":"120.5565597"}	2021-03-17 06:29:49.619+00
257	8	\N	{"lat":"15.1626691","lng":"120.5565632"}	2021-03-17 06:29:51.709+00
258	10	\N	{"lat":"15.1625621","lng":"120.5564978"}	2021-03-17 06:29:55.258+00
259	10	\N	{"lat":"15.1625597","lng":"120.5565103"}	2021-03-17 06:30:07.425+00
260	8	\N	{"lat":"15.1626675","lng":"120.5565619"}	2021-03-17 06:30:07.753+00
261	4	\N	{"lat":"15.1625521","lng":"120.5565091"}	2021-03-17 06:30:09.69+00
262	8	\N	{"lat":"15.1626671","lng":"120.556562"}	2021-03-17 06:30:12.19+00
263	5	\N	{"lat":"15.1626632","lng":"120.5565579"}	2021-03-17 06:30:12.641+00
264	10	\N	{"lat":"15.162555","lng":"120.5565098"}	2021-03-17 06:30:17.41+00
265	10	\N	{"lat":"15.1625528","lng":"120.5565076"}	2021-03-17 06:30:18.461+00
266	3	\N	{"lat":"15.1625604","lng":"120.5565077"}	2021-03-17 06:30:18.778+00
267	10	\N	{"lat":"15.1625528","lng":"120.5565076"}	2021-03-17 06:30:19.025+00
268	10	\N	{"lat":"15.1625622","lng":"120.5565013"}	2021-03-17 06:30:19.764+00
269	8	\N	{"lat":"15.1626641","lng":"120.5565612"}	2021-03-17 06:30:20.045+00
270	8	\N	{"lat":"15.1626641","lng":"120.5565612"}	2021-03-17 06:30:20.983+00
271	3	\N	{"lat":"15.1625604","lng":"120.5565077"}	2021-03-17 06:30:21.311+00
272	8	\N	{"lat":"15.1626648","lng":"120.5565605"}	2021-03-17 06:30:24.564+00
273	3	\N	{"lat":"15.1626673","lng":"120.5565599"}	2021-03-17 06:30:26.756+00
274	4	\N	{"lat":"15.1625814","lng":"120.5565223"}	2021-03-17 06:30:27.957+00
275	10	\N	{"lat":"15.162557","lng":"120.5565079"}	2021-03-17 06:30:29.065+00
276	8	\N	{"lat":"15.1626662","lng":"120.5565583"}	2021-03-17 06:30:30.05+00
277	8	\N	{"lat":"15.1626681","lng":"120.5565592"}	2021-03-17 06:30:36.011+00
278	9	\N	{"lat":"15.1625562","lng":"120.556506"}	2021-03-17 06:30:41.099+00
279	5	\N	{"lat":"15.1626619","lng":"120.5565588"}	2021-03-17 06:30:42.654+00
280	2	\N	{"lat":"15.1626743","lng":"120.5565608"}	2021-03-17 06:30:43.434+00
281	8	\N	{"lat":"15.1626663","lng":"120.5565625"}	2021-03-17 06:30:43.555+00
282	10	\N	{"lat":"15.1625579","lng":"120.5564992"}	2021-03-17 06:30:56.738+00
283	3	\N	{"lat":"15.1626673","lng":"120.5565599"}	2021-03-17 06:30:57.083+00
284	7	\N	{"lat":"15.1497168","lng":"120.5593147"}	2021-03-17 06:31:01.333+00
285	4	\N	{"lat":"15.1626422","lng":"120.5565497"}	2021-03-17 06:31:01.612+00
286	7	\N	{"lat":"15.1498888","lng":"120.5592851"}	2021-03-17 06:31:05.566+00
287	7	\N	{"lat":"15.1498888","lng":"120.5592851"}	2021-03-17 06:31:06.266+00
288	7	\N	{"lat":"15.1498888","lng":"120.5592851"}	2021-03-17 06:31:07.496+00
289	7	\N	{"lat":"15.1498675","lng":"120.5593124"}	2021-03-17 06:31:10.752+00
290	1	\N	{"lat":"15.162669","lng":"120.5565596"}	2021-03-17 06:31:11.248+00
291	2	\N	{"lat":"15.1626672","lng":"120.5565607"}	2021-03-17 06:31:11.983+00
292	5	\N	{"lat":"15.162669","lng":"120.5565591"}	2021-03-17 06:31:12.588+00
293	8	\N	{"lat":"15.1626664","lng":"120.5565614"}	2021-03-17 06:31:14.922+00
294	10	\N	{"lat":"15.1626798","lng":"120.5565616"}	2021-03-17 06:31:15.647+00
295	1	\N	{"lat":"15.1626663","lng":"120.5565606"}	2021-03-17 06:31:29.803+00
296	8	\N	{"lat":"15.1626625","lng":"120.55656"}	2021-03-17 06:31:30.225+00
297	2	\N	{"lat":"15.1626762","lng":"120.5565594"}	2021-03-17 06:31:31.127+00
298	1	\N	{"lat":"15.1626663","lng":"120.5565606"}	2021-03-17 06:31:31.516+00
299	10	\N	{"lat":"15.16267","lng":"120.5565656"}	2021-03-17 06:31:33.442+00
300	1	\N	{"lat":"15.1626641","lng":"120.5565605"}	2021-03-17 06:31:35.24+00
301	8	\N	{"lat":"15.1626681","lng":"120.556562"}	2021-03-17 06:31:39.664+00
302	5	\N	{"lat":"15.1626651","lng":"120.5565593"}	2021-03-17 06:31:42.691+00
303	7	\N	{"lat":"15.1501781","lng":"120.5594213"}	2021-03-17 06:31:43.042+00
304	8	\N	{"lat":"15.1626723","lng":"120.5565642"}	2021-03-17 06:31:45.935+00
305	8	\N	{"lat":"15.1626723","lng":"120.5565642"}	2021-03-17 06:31:47.517+00
306	8	\N	{"lat":"15.162668","lng":"120.5565644"}	2021-03-17 06:31:50.348+00
307	2	\N	{"lat":"15.1626768","lng":"120.5565586"}	2021-03-17 06:31:51.501+00
308	8	\N	{"lat":"15.162668","lng":"120.5565644"}	2021-03-17 06:31:51.962+00
309	2	\N	{"lat":"15.1626768","lng":"120.5565586"}	2021-03-17 06:31:52.026+00
310	2	\N	{"lat":"15.1626768","lng":"120.5565586"}	2021-03-17 06:31:53.168+00
311	2	\N	{"lat":"15.1626672","lng":"120.5565602"}	2021-03-17 06:32:04.84+00
312	8	\N	{"lat":"15.1626643","lng":"120.5565617"}	2021-03-17 06:32:05.094+00
313	2	\N	{"lat":"15.1626672","lng":"120.5565602"}	2021-03-17 06:32:05.576+00
314	8	\N	{"lat":"15.1626642","lng":"120.5565616"}	2021-03-17 06:32:06.868+00
315	2	\N	{"lat":"15.1626675","lng":"120.5565623"}	2021-03-17 06:32:09.789+00
316	2	\N	{"lat":"15.1626675","lng":"120.5565623"}	2021-03-17 06:32:11.685+00
317	3	\N	{"lat":"15.1626681","lng":"120.5565621"}	2021-03-17 06:32:12.317+00
318	5	\N	{"lat":"15.1626729","lng":"120.5565606"}	2021-03-17 06:32:12.584+00
319	7	\N	{"lat":"15.1528197","lng":"120.5598431"}	2021-03-17 06:32:12.972+00
320	8	\N	{"lat":"15.1626645","lng":"120.5565626"}	2021-03-17 06:32:13.509+00
321	10	\N	{"lat":"15.1626685","lng":"120.5565622"}	2021-03-17 06:32:16.928+00
322	10	\N	{"lat":"15.1626685","lng":"120.5565622"}	2021-03-17 06:32:18.147+00
323	2	\N	{"lat":"15.1626705","lng":"120.5565631"}	2021-03-17 06:32:20.056+00
324	5	\N	{"lat":"15.1626639","lng":"120.5565636"}	2021-03-17 06:32:20.341+00
325	3	\N	{"lat":"15.162668","lng":"120.5565638"}	2021-03-17 06:32:20.576+00
326	10	\N	{"lat":"15.1626679","lng":"120.5565643"}	2021-03-17 06:32:21.105+00
327	9	\N	{"lat":"15.1625562","lng":"120.556506"}	2021-03-17 06:32:21.496+00
328	3	\N	{"lat":"15.162668","lng":"120.5565638"}	2021-03-17 06:32:21.694+00
329	3	\N	{"lat":"15.162667","lng":"120.5565637"}	2021-03-17 06:32:23.773+00
330	3	\N	{"lat":"15.162667","lng":"120.5565637"}	2021-03-17 06:32:24.433+00
331	10	\N	{"lat":"15.1626645","lng":"120.5565605"}	2021-03-17 06:32:24.995+00
332	5	\N	{"lat":"15.1626675","lng":"120.5565657"}	2021-03-17 06:32:25.376+00
333	9	\N	{"lat":"15.1625562","lng":"120.556506"}	2021-03-17 06:32:26.518+00
334	8	\N	{"lat":"15.1626667","lng":"120.5565621"}	2021-03-17 06:32:26.71+00
335	5	\N	{"lat":"15.1626675","lng":"120.5565657"}	2021-03-17 06:32:27.316+00
336	9	\N	{"lat":"15.162671","lng":"120.5565617"}	2021-03-17 06:32:27.43+00
337	9	\N	{"lat":"15.162671","lng":"120.5565617"}	2021-03-17 06:32:28.289+00
338	10	\N	{"lat":"15.1626621","lng":"120.5565605"}	2021-03-17 06:32:28.401+00
339	8	\N	{"lat":"15.1626667","lng":"120.5565621"}	2021-03-17 06:32:28.63+00
340	2	\N	{"lat":"15.162669","lng":"120.5565619"}	2021-03-17 06:32:29.021+00
341	10	\N	{"lat":"15.1626621","lng":"120.5565605"}	2021-03-17 06:32:29.086+00
342	5	\N	{"lat":"15.162675","lng":"120.55656"}	2021-03-17 06:32:29.893+00
343	10	\N	{"lat":"15.1626682","lng":"120.55656"}	2021-03-17 06:32:31.717+00
344	8	\N	{"lat":"15.1626672","lng":"120.5565618"}	2021-03-17 06:32:31.741+00
345	2	\N	{"lat":"15.1626653","lng":"120.556562"}	2021-03-17 06:32:33.353+00
346	9	\N	{"lat":"15.1625562","lng":"120.556506"}	2021-03-17 06:32:33.692+00
347	10	\N	{"lat":"15.1626675","lng":"120.556564"}	2021-03-17 06:32:34.78+00
348	8	\N	{"lat":"15.1626681","lng":"120.5565618"}	2021-03-17 06:32:34.85+00
349	3	\N	{"lat":"15.1626663","lng":"120.55656"}	2021-03-17 06:32:35.791+00
350	9	\N	{"lat":"15.1625562","lng":"120.556506"}	2021-03-17 06:32:35.896+00
351	10	\N	{"lat":"15.1626675","lng":"120.556564"}	2021-03-17 06:32:36.339+00
352	3	\N	{"lat":"15.1626663","lng":"120.55656"}	2021-03-17 06:32:36.519+00
353	2	\N	{"lat":"15.1626634","lng":"120.5565616"}	2021-03-17 06:32:37.1+00
354	3	\N	{"lat":"15.1626663","lng":"120.55656"}	2021-03-17 06:32:37.732+00
355	10	\N	{"lat":"15.1626672","lng":"120.556561"}	2021-03-17 06:32:38.832+00
356	10	\N	{"lat":"15.1626672","lng":"120.556561"}	2021-03-17 06:32:38.978+00
357	3	\N	{"lat":"15.1626651","lng":"120.5565615"}	2021-03-17 06:32:39.82+00
358	10	\N	{"lat":"15.1626672","lng":"120.556561"}	2021-03-17 06:32:39.953+00
359	8	\N	{"lat":"15.1626663","lng":"120.5565625"}	2021-03-17 06:32:40.198+00
360	3	\N	{"lat":"15.1626651","lng":"120.5565615"}	2021-03-17 06:32:40.689+00
361	2	\N	{"lat":"15.1626627","lng":"120.5565607"}	2021-03-17 06:32:41.215+00
362	2	\N	{"lat":"15.1626627","lng":"120.5565607"}	2021-03-17 06:32:41.839+00
363	10	\N	{"lat":"15.1626669","lng":"120.5565613"}	2021-03-17 06:32:41.887+00
364	10	\N	{"lat":"15.1626669","lng":"120.5565613"}	2021-03-17 06:32:42.163+00
365	3	\N	{"lat":"15.1626669","lng":"120.5565627"}	2021-03-17 06:32:42.973+00
366	7	\N	{"lat":"15.1528202","lng":"120.5598435"}	2021-03-17 06:32:43.185+00
367	3	\N	{"lat":"15.1626669","lng":"120.5565627"}	2021-03-17 06:32:43.738+00
368	10	\N	{"lat":"15.1626707","lng":"120.5565628"}	2021-03-17 06:32:45.404+00
369	8	\N	{"lat":"15.1626657","lng":"120.5565614"}	2021-03-17 06:32:45.792+00
370	3	\N	{"lat":"15.1626704","lng":"120.5565617"}	2021-03-17 06:32:46.073+00
371	3	\N	{"lat":"15.1626704","lng":"120.5565617"}	2021-03-17 06:32:46.679+00
372	2	\N	{"lat":"15.1626601","lng":"120.5565592"}	2021-03-17 06:32:47.69+00
373	10	\N	{"lat":"15.1626657","lng":"120.556563"}	2021-03-17 06:32:48.653+00
374	10	\N	{"lat":"15.1626657","lng":"120.556563"}	2021-03-17 06:32:48.764+00
375	3	\N	{"lat":"15.1626694","lng":"120.5565612"}	2021-03-17 06:32:48.772+00
376	1	\N	{"lat":"15.1626612","lng":"120.5565615"}	2021-03-17 06:32:48.985+00
384	10	\N	{"lat":"15.1626676","lng":"120.5565618"}	2021-03-17 06:32:53.389+00
1357	1	\N	{"lat":"15.1443295","lng":"120.5594988"}	2021-03-17 07:01:57.485+00
1501	7	\N	{"lat":"15.1625526","lng":"120.5564946"}	2021-03-17 07:02:18.805+00
1919	4	\N	{"lat":"15.1669187","lng":"120.573778"}	2021-03-17 07:04:47.085+00
2071	2	\N	{"lat":"15.1637324","lng":"120.5909689"}	2021-03-17 07:08:41.627+00
2085	8	6	{"lat":15.1626729,"lng":120.5565623}	2021-03-17 06:36:16.043+00
2086	8	6	{"lat":15.1626742,"lng":120.556564}	2021-03-17 06:36:21.053+00
2087	8	6	{"lat":15.1626739,"lng":120.5565646}	2021-03-17 06:36:25.965+00
2088	8	6	{"lat":15.162667,"lng":120.5565643}	2021-03-17 06:36:30.974+00
2089	8	6	{"lat":15.1626656,"lng":120.5565619}	2021-03-17 06:36:36.069+00
2090	8	6	{"lat":15.162666,"lng":120.5565631}	2021-03-17 06:36:40.948+00
2091	8	6	{"lat":15.1626689,"lng":120.5565624}	2021-03-17 06:36:45.96+00
2092	8	6	{"lat":15.1626667,"lng":120.5565625}	2021-03-17 06:36:51.107+00
2093	8	6	{"lat":15.1626711,"lng":120.5565632}	2021-03-17 06:36:55.96+00
2094	8	6	{"lat":15.1626728,"lng":120.5565633}	2021-03-17 06:37:00.942+00
2095	8	6	{"lat":15.1626717,"lng":120.5565633}	2021-03-17 06:37:05.926+00
2096	8	6	{"lat":15.1626675,"lng":120.5565617}	2021-03-17 06:37:10.932+00
2097	8	6	{"lat":15.1626689,"lng":120.5565619}	2021-03-17 06:37:15.926+00
2098	8	6	{"lat":15.1626674,"lng":120.5565622}	2021-03-17 06:37:20.925+00
2099	8	6	{"lat":15.1626668,"lng":120.5565611}	2021-03-17 06:37:26.12+00
2100	8	6	{"lat":15.1626697,"lng":120.5565608}	2021-03-17 06:37:30.965+00
2101	8	6	{"lat":15.1626728,"lng":120.5565604}	2021-03-17 06:37:35.794+00
2102	8	6	{"lat":15.1626665,"lng":120.5565618}	2021-03-17 06:37:40.574+00
2103	8	6	{"lat":15.1626641,"lng":120.5565628}	2021-03-17 06:37:45.117+00
2104	8	6	{"lat":15.1626642,"lng":120.5565642}	2021-03-17 06:37:50.502+00
2105	8	6	{"lat":15.1626613,"lng":120.5565624}	2021-03-17 06:37:55.116+00
2106	8	6	{"lat":15.1626323,"lng":120.5565509}	2021-03-17 06:38:00.165+00
2107	8	6	{"lat":15.1626129,"lng":120.5565394}	2021-03-17 06:38:05.061+00
2108	8	6	{"lat":15.1625642,"lng":120.5565051}	2021-03-17 06:38:10.645+00
2109	8	6	{"lat":15.1625883,"lng":120.5565278}	2021-03-17 06:38:15.942+00
2110	8	6	{"lat":15.1625725,"lng":120.5565094}	2021-03-17 06:38:20.946+00
2111	8	6	{"lat":15.1625649,"lng":120.5564997}	2021-03-17 06:38:25.966+00
2112	8	6	{"lat":15.1625612,"lng":120.5564928}	2021-03-17 06:38:30.962+00
2113	8	6	{"lat":15.1625567,"lng":120.556503}	2021-03-17 06:38:35.942+00
2114	8	6	{"lat":15.1625534,"lng":120.5565111}	2021-03-17 06:38:40.966+00
2115	8	6	{"lat":15.1625539,"lng":120.5565111}	2021-03-17 06:38:45.962+00
2116	8	6	{"lat":15.1625759,"lng":120.5565189}	2021-03-17 06:38:50.92+00
2117	8	6	{"lat":15.1625942,"lng":120.556526}	2021-03-17 06:38:55.964+00
2118	8	6	{"lat":15.1625991,"lng":120.5565289}	2021-03-17 06:39:00.113+00
2119	8	6	{"lat":15.1626135,"lng":120.5565361}	2021-03-17 06:39:05.293+00
2120	8	6	{"lat":15.1626273,"lng":120.5565422}	2021-03-17 06:39:10.259+00
2121	8	6	{"lat":15.1626702,"lng":120.5565623}	2021-03-17 06:39:15.906+00
2122	8	6	{"lat":15.1626448,"lng":120.5565508}	2021-03-17 06:39:20.421+00
2123	8	6	{"lat":15.1626381,"lng":120.5565475}	2021-03-17 06:39:25.071+00
2124	8	6	{"lat":15.1626377,"lng":120.5565471}	2021-03-17 06:39:30.288+00
2125	8	6	{"lat":15.1626377,"lng":120.5565471}	2021-03-17 06:39:35.093+00
2126	8	6	{"lat":15.162651,"lng":120.5565543}	2021-03-17 06:39:40.808+00
2127	8	6	{"lat":15.1626688,"lng":120.5565604}	2021-03-17 06:39:45.933+00
2128	8	6	{"lat":15.1626716,"lng":120.5565618}	2021-03-17 06:39:50.93+00
2129	8	6	{"lat":15.1626713,"lng":120.556563}	2021-03-17 06:39:56.074+00
2130	8	6	{"lat":15.1626686,"lng":120.5565611}	2021-03-17 06:40:01.086+00
2131	8	6	{"lat":15.1626674,"lng":120.5565631}	2021-03-17 06:40:05.923+00
2132	8	6	{"lat":15.1626689,"lng":120.5565613}	2021-03-17 06:40:10.972+00
2133	8	6	{"lat":15.1626695,"lng":120.5565609}	2021-03-17 06:40:16.191+00
2134	8	6	{"lat":15.1626701,"lng":120.5565618}	2021-03-17 06:40:20.927+00
2135	8	6	{"lat":15.1626699,"lng":120.5565617}	2021-03-17 06:40:26.112+00
2136	8	6	{"lat":15.1626703,"lng":120.5565608}	2021-03-17 06:40:30.956+00
2137	8	6	{"lat":15.1626661,"lng":120.5565601}	2021-03-17 06:40:35.926+00
2138	8	6	{"lat":15.1626695,"lng":120.5565611}	2021-03-17 06:40:40.954+00
2139	8	6	{"lat":15.1626741,"lng":120.5565641}	2021-03-17 06:40:45.995+00
2140	8	6	{"lat":15.1626715,"lng":120.5565628}	2021-03-17 06:40:50.981+00
2141	8	6	{"lat":15.1626324,"lng":120.5565613}	2021-03-17 06:40:55.929+00
2142	8	6	{"lat":15.1626241,"lng":120.5565664}	2021-03-17 06:41:00.271+00
2143	8	6	{"lat":15.1626468,"lng":120.5565616}	2021-03-17 06:41:05.298+00
2144	8	6	{"lat":15.1627786,"lng":120.5567963}	2021-03-17 06:41:10.287+00
2145	8	6	{"lat":15.1629179,"lng":120.5570841}	2021-03-17 06:41:15.488+00
2146	8	6	{"lat":15.1628435,"lng":120.5572524}	2021-03-17 06:41:20.271+00
2147	8	6	{"lat":15.1625951,"lng":120.5573824}	2021-03-17 06:41:25.427+00
2148	8	6	{"lat":15.162187,"lng":120.5575318}	2021-03-17 06:41:31.299+00
2149	8	6	{"lat":15.1619779,"lng":120.5575984}	2021-03-17 06:41:35.344+00
2150	8	6	{"lat":15.1617675,"lng":120.5576577}	2021-03-17 06:41:40.322+00
2151	8	6	{"lat":15.1614828,"lng":120.5577509}	2021-03-17 06:41:45.249+00
2152	8	6	{"lat":15.1611136,"lng":120.5578732}	2021-03-17 06:41:50.242+00
2153	8	6	{"lat":15.1607105,"lng":120.5579976}	2021-03-17 06:41:55.274+00
2154	8	6	{"lat":15.1603301,"lng":120.5581231}	2021-03-17 06:42:00.538+00
2155	8	6	{"lat":15.1599025,"lng":120.5582649}	2021-03-17 06:42:05.277+00
2156	8	6	{"lat":15.1594649,"lng":120.5583912}	2021-03-17 06:42:10.299+00
2157	8	6	{"lat":15.1590525,"lng":120.5585249}	2021-03-17 06:42:15.242+00
2158	8	6	{"lat":15.1586992,"lng":120.558661}	2021-03-17 06:42:20.291+00
2159	8	6	{"lat":15.1583254,"lng":120.5587781}	2021-03-17 06:42:28.38+00
2160	8	6	{"lat":15.1582853,"lng":120.558789}	2021-03-17 06:42:33.284+00
2161	8	6	{"lat":15.1582287,"lng":120.5589863}	2021-03-17 06:42:38.385+00
2162	8	6	{"lat":15.1580319,"lng":120.559491}	2021-03-17 06:42:43.272+00
2163	8	6	{"lat":15.1576386,"lng":120.5597618}	2021-03-17 06:42:48.251+00
2164	8	6	{"lat":15.1570616,"lng":120.5598765}	2021-03-17 06:42:53.309+00
2165	8	6	{"lat":15.1563966,"lng":120.5599994}	2021-03-17 06:42:58.28+00
2166	8	6	{"lat":15.155769,"lng":120.5601224}	2021-03-17 06:43:03.258+00
377	2	\N	{"lat":"15.1626601","lng":"120.5565592"}	2021-03-17 06:32:49.361+00
397	3	\N	{"lat":"15.1626682","lng":"120.5565633"}	2021-03-17 06:33:00.136+00
413	5	\N	{"lat":"15.1626704","lng":"120.556562"}	2021-03-17 06:33:06.4+00
416	3	\N	{"lat":"15.1626658","lng":"120.5565623"}	2021-03-17 06:33:10.054+00
417	5	\N	{"lat":"15.1626703","lng":"120.5565622"}	2021-03-17 06:33:10.161+00
1358	7	16	{"lat":15.1626665,"lng":120.5565625}	2021-03-17 06:40:32.85+00
1359	7	16	{"lat":15.1626693,"lng":120.5565653}	2021-03-17 06:40:36.965+00
1360	7	16	{"lat":15.1626697,"lng":120.5565655}	2021-03-17 06:40:41.915+00
1361	7	16	{"lat":15.1626697,"lng":120.5565655}	2021-03-17 06:40:51.75+00
1362	7	16	{"lat":15.1626697,"lng":120.5565655}	2021-03-17 06:40:56.742+00
1363	7	16	{"lat":15.1626697,"lng":120.5565655}	2021-03-17 06:41:49.527+00
1364	7	16	{"lat":15.1626681,"lng":120.5565593}	2021-03-17 06:41:54.945+00
1365	7	16	{"lat":15.162673,"lng":120.5565609}	2021-03-17 06:42:01.555+00
1366	7	16	{"lat":15.1626728,"lng":120.5565615}	2021-03-17 06:42:06.566+00
1367	7	16	{"lat":15.162675,"lng":120.5565598}	2021-03-17 06:42:16.358+00
1368	7	16	{"lat":15.1626735,"lng":120.5565612}	2021-03-17 06:42:21.647+00
1369	7	16	{"lat":15.1626712,"lng":120.5565606}	2021-03-17 06:42:26.774+00
1370	7	16	{"lat":15.1626652,"lng":120.5565596}	2021-03-17 06:42:31.375+00
1371	7	16	{"lat":15.1626685,"lng":120.5565615}	2021-03-17 06:42:36.262+00
1372	7	16	{"lat":15.1626652,"lng":120.5565585}	2021-03-17 06:42:46.733+00
1373	7	16	{"lat":15.1626703,"lng":120.55656}	2021-03-17 06:42:51.516+00
1374	7	16	{"lat":15.1626709,"lng":120.5565626}	2021-03-17 06:42:56.337+00
1375	7	16	{"lat":15.1626671,"lng":120.5565605}	2021-03-17 06:43:01.263+00
1376	7	16	{"lat":15.1626675,"lng":120.5565622}	2021-03-17 06:43:06.755+00
1377	7	16	{"lat":15.1626668,"lng":120.556561}	2021-03-17 06:43:13.772+00
1378	7	16	{"lat":15.1626686,"lng":120.5565625}	2021-03-17 06:43:19.802+00
1379	7	16	{"lat":15.162666,"lng":120.5565618}	2021-03-17 06:43:26.647+00
1380	7	16	{"lat":15.1626644,"lng":120.5565596}	2021-03-17 06:43:31.451+00
1381	7	16	{"lat":15.1626677,"lng":120.55656}	2021-03-17 06:43:36.253+00
1382	7	16	{"lat":15.1626677,"lng":120.55656}	2021-03-17 06:43:38.804+00
1383	7	16	{"lat":15.1357125,"lng":120.5601091}	2021-03-17 06:52:08.904+00
1384	7	16	{"lat":15.1386117,"lng":120.5627602}	2021-03-17 06:52:28.23+00
1385	7	16	{"lat":15.1386117,"lng":120.5627602}	2021-03-17 06:52:29.397+00
1386	7	16	{"lat":15.1386255,"lng":120.5627546}	2021-03-17 06:52:36.469+00
1387	7	16	{"lat":15.138644,"lng":120.5627472}	2021-03-17 06:52:40.735+00
1388	7	16	{"lat":15.138637,"lng":120.5627493}	2021-03-17 06:52:45.887+00
1389	7	16	{"lat":15.1386271,"lng":120.5627512}	2021-03-17 06:52:49.535+00
1390	7	16	{"lat":15.1386404,"lng":120.5627529}	2021-03-17 06:52:54.537+00
1391	7	16	{"lat":15.138659,"lng":120.562786}	2021-03-17 06:53:01.542+00
1392	7	16	{"lat":15.1387192,"lng":120.5628313}	2021-03-17 06:53:05.93+00
1393	7	16	{"lat":15.1386877,"lng":120.5627933}	2021-03-17 06:53:10.904+00
1394	7	16	{"lat":15.1386821,"lng":120.5627629}	2021-03-17 06:53:15.926+00
1395	7	16	{"lat":15.1386937,"lng":120.5627489}	2021-03-17 06:53:19.745+00
1396	7	16	{"lat":15.1386281,"lng":120.562792}	2021-03-17 06:53:27.923+00
1397	7	16	{"lat":15.1386281,"lng":120.562792}	2021-03-17 06:53:29.436+00
1398	7	16	{"lat":15.1386837,"lng":120.5627779}	2021-03-17 06:53:36.226+00
1399	7	16	{"lat":15.1386666,"lng":120.562725}	2021-03-17 06:53:41.266+00
1400	7	16	{"lat":15.1386578,"lng":120.5627331}	2021-03-17 06:53:46.238+00
1401	7	16	{"lat":15.1386473,"lng":120.5627583}	2021-03-17 06:53:50.246+00
1402	7	16	{"lat":15.1386534,"lng":120.5627726}	2021-03-17 06:53:56.251+00
1403	7	16	{"lat":15.1386662,"lng":120.5627738}	2021-03-17 06:54:01.247+00
1404	7	16	{"lat":15.1386749,"lng":120.562777}	2021-03-17 06:54:06.241+00
1405	7	16	{"lat":15.1386753,"lng":120.5627773}	2021-03-17 06:54:09.834+00
1406	7	16	{"lat":15.1386901,"lng":120.5627979}	2021-03-17 06:54:16.254+00
1407	7	16	{"lat":15.1387411,"lng":120.5628413}	2021-03-17 06:54:20.254+00
1408	7	16	{"lat":15.1388149,"lng":120.5628147}	2021-03-17 06:54:26.241+00
1409	7	16	{"lat":15.1391345,"lng":120.5626175}	2021-03-17 06:54:31.24+00
1410	7	16	{"lat":15.1396698,"lng":120.5622679}	2021-03-17 06:54:36.237+00
1411	7	16	{"lat":15.1404014,"lng":120.5617397}	2021-03-17 06:54:41.251+00
1412	7	16	{"lat":15.1408939,"lng":120.5614722}	2021-03-17 06:54:46.253+00
1413	7	16	{"lat":15.1413348,"lng":120.5612082}	2021-03-17 06:54:50.256+00
1414	7	16	{"lat":15.1420095,"lng":120.5608008}	2021-03-17 06:54:56.241+00
1415	7	16	{"lat":15.1425548,"lng":120.5604449}	2021-03-17 06:55:01.235+00
1416	7	16	{"lat":15.1430832,"lng":120.5600911}	2021-03-17 06:55:06.261+00
1417	7	16	{"lat":15.1435564,"lng":120.5597023}	2021-03-17 06:55:11.241+00
1418	7	16	{"lat":15.1440004,"lng":120.5594641}	2021-03-17 06:55:16.219+00
1419	7	16	{"lat":15.1442839,"lng":120.5594658}	2021-03-17 06:55:20.245+00
1420	7	16	{"lat":15.1444522,"lng":120.559516}	2021-03-17 06:55:26.264+00
1421	7	16	{"lat":15.1444606,"lng":120.5595818}	2021-03-17 06:55:31.247+00
1422	7	16	{"lat":15.1445048,"lng":120.559631}	2021-03-17 06:55:36.262+00
1423	7	16	{"lat":15.1446499,"lng":120.5595276}	2021-03-17 06:55:41.257+00
1424	7	16	{"lat":15.1450442,"lng":120.5594745}	2021-03-17 06:55:46.256+00
1425	7	16	{"lat":15.1454552,"lng":120.5594478}	2021-03-17 06:55:50.245+00
1426	7	16	{"lat":15.1460956,"lng":120.5594161}	2021-03-17 06:55:56.258+00
1427	7	16	{"lat":15.1467103,"lng":120.559398}	2021-03-17 06:56:01.228+00
1428	7	16	{"lat":15.1473606,"lng":120.5594311}	2021-03-17 06:56:06.233+00
1429	7	16	{"lat":15.1479091,"lng":120.5594424}	2021-03-17 06:56:11.255+00
1430	7	16	{"lat":15.1484933,"lng":120.5594292}	2021-03-17 06:56:16.262+00
1431	7	16	{"lat":15.1489445,"lng":120.5593855}	2021-03-17 06:56:20.249+00
1432	7	16	{"lat":15.1497212,"lng":120.5593455}	2021-03-17 06:56:26.24+00
1433	7	16	{"lat":15.150372,"lng":120.5593305}	2021-03-17 06:56:31.22+00
1434	7	16	{"lat":15.150958,"lng":120.5593866}	2021-03-17 06:56:36.265+00
1435	7	16	{"lat":15.1515589,"lng":120.559413}	2021-03-17 06:56:41.253+00
1436	7	16	{"lat":15.1521248,"lng":120.5594564}	2021-03-17 06:56:46.26+00
1437	7	16	{"lat":15.152493,"lng":120.5595407}	2021-03-17 06:56:50.249+00
1438	7	16	{"lat":15.1530437,"lng":120.5599289}	2021-03-17 06:56:56.241+00
1439	7	16	{"lat":15.1535442,"lng":120.560272}	2021-03-17 06:57:01.236+00
1440	7	16	{"lat":15.1539727,"lng":120.560361}	2021-03-17 06:57:06.243+00
1441	7	16	{"lat":15.1544152,"lng":120.5603511}	2021-03-17 06:57:11.244+00
1442	7	16	{"lat":15.1548689,"lng":120.5603239}	2021-03-17 06:57:16.235+00
378	3	\N	{"lat":"15.1626694","lng":"120.5565612"}	2021-03-17 06:32:49.661+00
379	8	\N	{"lat":"15.1626667","lng":"120.5565609"}	2021-03-17 06:32:51.303+00
380	2	\N	{"lat":"15.1626601","lng":"120.5565578"}	2021-03-17 06:32:51.558+00
381	3	\N	{"lat":"15.1626656","lng":"120.5565626"}	2021-03-17 06:32:52.034+00
382	3	\N	{"lat":"15.1626656","lng":"120.5565626"}	2021-03-17 06:32:52.818+00
383	2	\N	{"lat":"15.1626601","lng":"120.5565578"}	2021-03-17 06:32:53.383+00
385	10	\N	{"lat":"15.1626676","lng":"120.5565618"}	2021-03-17 06:32:53.6+00
386	3	\N	{"lat":"15.1626656","lng":"120.5565626"}	2021-03-17 06:32:53.82+00
387	8	\N	{"lat":"15.1626667","lng":"120.5565613"}	2021-03-17 06:32:54.514+00
388	10	\N	{"lat":"15.1626676","lng":"120.5565618"}	2021-03-17 06:32:54.711+00
389	8	\N	{"lat":"15.1626667","lng":"120.5565613"}	2021-03-17 06:32:54.828+00
390	1	\N	{"lat":"15.1626713","lng":"120.5565617"}	2021-03-17 06:32:55.116+00
391	3	\N	{"lat":"15.1626671","lng":"120.556561"}	2021-03-17 06:32:55.758+00
392	2	\N	{"lat":"15.1626701","lng":"120.5565612"}	2021-03-17 06:32:57.229+00
393	10	\N	{"lat":"15.1626666","lng":"120.5565644"}	2021-03-17 06:32:57.705+00
394	2	\N	{"lat":"15.1626701","lng":"120.5565612"}	2021-03-17 06:32:58.124+00
395	7	\N	{"lat":"15.155498","lng":"120.5620427"}	2021-03-17 06:32:58.39+00
396	10	\N	{"lat":"15.1626666","lng":"120.5565644"}	2021-03-17 06:32:59.362+00
398	5	\N	{"lat":"15.1626638","lng":"120.5565634"}	2021-03-17 06:33:00.347+00
399	5	\N	{"lat":"15.1626638","lng":"120.5565634"}	2021-03-17 06:33:00.544+00
400	5	\N	{"lat":"15.1626638","lng":"120.5565634"}	2021-03-17 06:33:00.684+00
401	8	\N	{"lat":"15.1626711","lng":"120.5565667"}	2021-03-17 06:33:00.879+00
402	2	\N	{"lat":"15.1626676","lng":"120.556562"}	2021-03-17 06:33:02.076+00
403	10	\N	{"lat":"15.1626664","lng":"120.5565641"}	2021-03-17 06:33:02.247+00
404	5	\N	{"lat":"15.1626638","lng":"120.5565634"}	2021-03-17 06:33:02.352+00
405	2	\N	{"lat":"15.1626676","lng":"120.556562"}	2021-03-17 06:33:02.944+00
406	3	\N	{"lat":"15.1626695","lng":"120.5565637"}	2021-03-17 06:33:02.964+00
407	10	\N	{"lat":"15.1626664","lng":"120.5565641"}	2021-03-17 06:33:03.707+00
408	3	\N	{"lat":"15.1626695","lng":"120.5565637"}	2021-03-17 06:33:04.029+00
409	1	\N	{"lat":"15.1626667","lng":"120.5565602"}	2021-03-17 06:33:04.376+00
410	8	\N	{"lat":"15.1626674","lng":"120.5565612"}	2021-03-17 06:33:05.499+00
411	2	\N	{"lat":"15.1626701","lng":"120.5565615"}	2021-03-17 06:33:05.532+00
412	3	\N	{"lat":"15.1626646","lng":"120.5565637"}	2021-03-17 06:33:06.137+00
414	8	\N	{"lat":"15.1626674","lng":"120.5565612"}	2021-03-17 06:33:07.456+00
415	3	\N	{"lat":"15.1626646","lng":"120.5565637"}	2021-03-17 06:33:07.994+00
418	5	\N	{"lat":"15.1626703","lng":"120.5565622"}	2021-03-17 06:33:10.305+00
419	7	\N	{"lat":"15.1582198","lng":"120.5590125"}	2021-03-17 06:33:10.52+00
420	3	\N	{"lat":"15.1626658","lng":"120.5565623"}	2021-03-17 06:33:11.037+00
421	1	\N	{"lat":"15.1626719","lng":"120.5565598"}	2021-03-17 06:33:11.497+00
422	2	\N	{"lat":"15.1626711","lng":"120.5565607"}	2021-03-17 06:33:11.579+00
423	8	\N	{"lat":"15.162664","lng":"120.5565603"}	2021-03-17 06:33:12.25+00
424	3	\N	{"lat":"15.1626689","lng":"120.5565631"}	2021-03-17 06:33:13.432+00
425	3	\N	{"lat":"15.162668","lng":"120.556562"}	2021-03-17 06:33:16.495+00
426	2	\N	{"lat":"15.1626653","lng":"120.5565599"}	2021-03-17 06:33:16.537+00
427	3	\N	{"lat":"15.162668","lng":"120.556562"}	2021-03-17 06:33:17.188+00
428	8	\N	{"lat":"15.1626661","lng":"120.556562"}	2021-03-17 06:33:17.289+00
429	2	\N	{"lat":"15.1626653","lng":"120.5565599"}	2021-03-17 06:33:18.217+00
430	10	\N	{"lat":"15.1626674","lng":"120.5565627"}	2021-03-17 06:33:18.531+00
431	10	\N	{"lat":"15.1626674","lng":"120.5565627"}	2021-03-17 06:33:19.741+00
432	8	\N	{"lat":"15.1626676","lng":"120.5565622"}	2021-03-17 06:33:20.663+00
433	3	\N	{"lat":"15.1626698","lng":"120.5565621"}	2021-03-17 06:33:21.203+00
434	1	\N	{"lat":"15.1626604","lng":"120.5565612"}	2021-03-17 06:33:21.493+00
435	3	\N	{"lat":"15.1626698","lng":"120.5565621"}	2021-03-17 06:33:21.952+00
436	7	\N	{"lat":"15.1586152","lng":"120.5587511"}	2021-03-17 06:33:22.76+00
437	2	\N	{"lat":"15.1626631","lng":"120.5565592"}	2021-03-17 06:33:24.174+00
438	2	\N	{"lat":"15.1626631","lng":"120.5565592"}	2021-03-17 06:33:25.396+00
439	10	\N	{"lat":"15.1626681","lng":"120.5565664"}	2021-03-17 06:33:25.89+00
440	8	\N	{"lat":"15.1626683","lng":"120.5565627"}	2021-03-17 06:33:26.004+00
441	3	\N	{"lat":"15.1626702","lng":"120.5565614"}	2021-03-17 06:33:26.984+00
442	5	\N	{"lat":"15.1626722","lng":"120.556561"}	2021-03-17 06:33:28.679+00
443	2	\N	{"lat":"15.1626647","lng":"120.5565592"}	2021-03-17 06:33:29.146+00
444	8	\N	{"lat":"15.1626696","lng":"120.5565621"}	2021-03-17 06:33:29.159+00
445	7	\N	{"lat":"15.1591568","lng":"120.5582279"}	2021-03-17 06:33:29.916+00
446	5	\N	{"lat":"15.1626722","lng":"120.556561"}	2021-03-17 06:33:30.038+00
447	2	\N	{"lat":"15.1626647","lng":"120.5565592"}	2021-03-17 06:33:30.583+00
448	10	\N	{"lat":"15.1626703","lng":"120.5565626"}	2021-03-17 06:33:32.499+00
449	5	\N	{"lat":"15.1626638","lng":"120.5565603"}	2021-03-17 06:33:32.813+00
450	10	\N	{"lat":"15.1626703","lng":"120.5565626"}	2021-03-17 06:33:32.868+00
451	5	\N	{"lat":"15.1626638","lng":"120.5565603"}	2021-03-17 06:33:33.272+00
452	2	\N	{"lat":"15.1626678","lng":"120.5565615"}	2021-03-17 06:33:34.596+00
453	8	\N	{"lat":"15.162668","lng":"120.5565634"}	2021-03-17 06:33:35.216+00
454	2	\N	{"lat":"15.1626678","lng":"120.5565615"}	2021-03-17 06:33:35.435+00
455	10	\N	{"lat":"15.1626673","lng":"120.5565618"}	2021-03-17 06:33:35.511+00
456	10	\N	{"lat":"15.1626673","lng":"120.5565618"}	2021-03-17 06:33:35.637+00
457	3	\N	{"lat":"15.1626662","lng":"120.5565618"}	2021-03-17 06:33:36.044+00
458	10	\N	{"lat":"15.1626673","lng":"120.5565618"}	2021-03-17 06:33:37.282+00
459	2	\N	{"lat":"15.1626666","lng":"120.5565605"}	2021-03-17 06:33:39.594+00
460	5	\N	{"lat":"15.1626625","lng":"120.5565623"}	2021-03-17 06:33:40.081+00
461	8	\N	{"lat":"15.1626685","lng":"120.5565627"}	2021-03-17 06:33:40.186+00
462	5	\N	{"lat":"15.1626625","lng":"120.5565623"}	2021-03-17 06:33:40.551+00
463	2	\N	{"lat":"15.1626666","lng":"120.5565605"}	2021-03-17 06:33:40.629+00
464	10	\N	{"lat":"15.1626661","lng":"120.5565622"}	2021-03-17 06:33:40.688+00
465	5	\N	{"lat":"15.1626625","lng":"120.5565623"}	2021-03-17 06:33:41.179+00
466	4	\N	{"lat":"15.16267","lng":"120.5565624"}	2021-03-17 06:33:41.527+00
467	2	\N	{"lat":"15.1626672","lng":"120.5565607"}	2021-03-17 06:33:44.55+00
468	3	\N	{"lat":"15.1626668","lng":"120.5565613"}	2021-03-17 06:33:44.743+00
469	10	\N	{"lat":"15.162665","lng":"120.5565618"}	2021-03-17 06:33:45.403+00
470	8	\N	{"lat":"15.1626672","lng":"120.5565622"}	2021-03-17 06:33:45.67+00
471	3	\N	{"lat":"15.1626668","lng":"120.5565613"}	2021-03-17 06:33:46.204+00
472	2	\N	{"lat":"15.1626672","lng":"120.5565607"}	2021-03-17 06:33:46.4+00
473	8	\N	{"lat":"15.1626683","lng":"120.5565633"}	2021-03-17 06:33:50.524+00
474	2	\N	{"lat":"15.1626658","lng":"120.5565624"}	2021-03-17 06:33:51.576+00
475	3	\N	{"lat":"15.1626671","lng":"120.5565604"}	2021-03-17 06:33:52.31+00
476	1	\N	{"lat":"15.16267","lng":"120.5565606"}	2021-03-17 06:33:53.078+00
477	5	\N	{"lat":"15.1626624","lng":"120.5565631"}	2021-03-17 06:33:53.105+00
478	5	\N	{"lat":"15.1626624","lng":"120.5565631"}	2021-03-17 06:33:53.236+00
479	8	\N	{"lat":"15.1626696","lng":"120.556563"}	2021-03-17 06:33:55.758+00
480	5	\N	{"lat":"15.1626685","lng":"120.5565604"}	2021-03-17 06:33:57.521+00
481	5	\N	{"lat":"15.1626685","lng":"120.5565604"}	2021-03-17 06:33:57.625+00
482	2	\N	{"lat":"15.1626636","lng":"120.5565657"}	2021-03-17 06:33:58.198+00
483	10	\N	{"lat":"15.1626679","lng":"120.5565637"}	2021-03-17 06:33:59.298+00
484	10	\N	{"lat":"15.1626679","lng":"120.5565637"}	2021-03-17 06:33:59.432+00
485	9	\N	{"lat":"15.1626642","lng":"120.5565613"}	2021-03-17 06:34:02.151+00
486	2	\N	{"lat":"15.1626658","lng":"120.5565641"}	2021-03-17 06:34:02.273+00
487	5	\N	{"lat":"15.1626709","lng":"120.5565611"}	2021-03-17 06:34:02.54+00
488	9	\N	{"lat":"15.1626642","lng":"120.5565613"}	2021-03-17 06:34:02.647+00
489	7	\N	{"lat":"15.1618632","lng":"120.5576149"}	2021-03-17 06:34:02.983+00
490	5	\N	{"lat":"15.1626709","lng":"120.5565611"}	2021-03-17 06:34:03.115+00
491	10	\N	{"lat":"15.1626722","lng":"120.5565608"}	2021-03-17 06:34:03.706+00
492	9	\N	{"lat":"15.1626642","lng":"120.5565613"}	2021-03-17 06:34:04.981+00
493	10	\N	{"lat":"15.1626722","lng":"120.5565608"}	2021-03-17 06:34:05.644+00
497	4	\N	{"lat":"15.1626644","lng":"120.5565624"}	2021-03-17 06:34:14.054+00
498	9	\N	{"lat":"15.1626642","lng":"120.5565613"}	2021-03-17 06:34:14.128+00
499	5	\N	{"lat":"15.1626614","lng":"120.5565631"}	2021-03-17 06:34:14.238+00
500	3	\N	{"lat":"15.1626643","lng":"120.5565569"}	2021-03-17 06:34:14.73+00
501	7	\N	{"lat":"15.1624016","lng":"120.5573885"}	2021-03-17 06:34:15.709+00
502	9	\N	{"lat":"15.1626642","lng":"120.5565613"}	2021-03-17 06:34:15.775+00
503	10	\N	{"lat":"15.1626699","lng":"120.5565642"}	2021-03-17 06:34:16.245+00
504	9	\N	{"lat":"15.1626642","lng":"120.5565613"}	2021-03-17 06:34:17.91+00
505	3	\N	{"lat":"15.1626617","lng":"120.5565611"}	2021-03-17 06:34:20.056+00
506	10	\N	{"lat":"15.1626663","lng":"120.556561"}	2021-03-17 06:34:20.785+00
507	9	\N	{"lat":"15.1626642","lng":"120.5565613"}	2021-03-17 06:34:20.801+00
508	8	\N	{"lat":"15.1626644","lng":"120.5565608"}	2021-03-17 06:34:22.832+00
509	1	\N	{"lat":"15.1626664","lng":"120.5565646"}	2021-03-17 06:34:22.854+00
510	5	\N	{"lat":"15.1626644","lng":"120.5565623"}	2021-03-17 06:34:23.578+00
511	9	\N	{"lat":"15.1626642","lng":"120.5565613"}	2021-03-17 06:34:23.984+00
512	3	\N	{"lat":"15.1626622","lng":"120.5565601"}	2021-03-17 06:34:24.667+00
513	3	\N	{"lat":"15.1626622","lng":"120.5565601"}	2021-03-17 06:34:26.037+00
514	9	\N	{"lat":"15.1626642","lng":"120.5565613"}	2021-03-17 06:34:26.365+00
515	10	\N	{"lat":"15.1626658","lng":"120.5565624"}	2021-03-17 06:34:27.064+00
516	10	\N	{"lat":"15.1626658","lng":"120.5565624"}	2021-03-17 06:34:28.44+00
517	3	\N	{"lat":"15.1626661","lng":"120.5565617"}	2021-03-17 06:34:28.505+00
518	9	\N	{"lat":"15.1626642","lng":"120.5565613"}	2021-03-17 06:34:29.277+00
519	9	\N	{"lat":"15.1626642","lng":"120.5565613"}	2021-03-17 06:34:31.202+00
520	9	\N	{"lat":"15.1626642","lng":"120.5565613"}	2021-03-17 06:34:33.342+00
521	10	\N	{"lat":"15.1626665","lng":"120.5565631"}	2021-03-17 06:34:35.181+00
522	10	\N	{"lat":"15.1626665","lng":"120.5565631"}	2021-03-17 06:34:35.633+00
523	9	\N	{"lat":"15.1626642","lng":"120.5565613"}	2021-03-17 06:34:36.195+00
524	8	\N	{"lat":"15.1626675","lng":"120.5565611"}	2021-03-17 06:34:36.96+00
525	10	\N	{"lat":"15.1626656","lng":"120.55656"}	2021-03-17 06:34:39.237+00
526	10	\N	{"lat":"15.1626656","lng":"120.55656"}	2021-03-17 06:34:40.176+00
527	9	\N	{"lat":"15.1626642","lng":"120.5565613"}	2021-03-17 06:34:41.096+00
528	8	\N	{"lat":"15.1626675","lng":"120.5565608"}	2021-03-17 06:34:44.118+00
529	4	\N	{"lat":"15.1626622","lng":"120.5565588"}	2021-03-17 06:34:44.129+00
530	9	\N	{"lat":"15.1626642","lng":"120.5565613"}	2021-03-17 06:34:44.81+00
531	10	\N	{"lat":"15.1626667","lng":"120.5565644"}	2021-03-17 06:34:46.702+00
532	9	\N	{"lat":"15.1626642","lng":"120.5565613"}	2021-03-17 06:34:46.877+00
533	10	\N	{"lat":"15.1626667","lng":"120.5565644"}	2021-03-17 06:34:46.894+00
534	7	\N	{"lat":"15.1626748","lng":"120.5565623"}	2021-03-17 06:34:48.164+00
535	9	\N	{"lat":"15.1626642","lng":"120.5565613"}	2021-03-17 06:34:50.106+00
536	10	\N	{"lat":"15.1626699","lng":"120.5565633"}	2021-03-17 06:34:50.972+00
537	8	\N	{"lat":"15.162669","lng":"120.5565632"}	2021-03-17 06:34:51.055+00
538	10	\N	{"lat":"15.1626699","lng":"120.5565633"}	2021-03-17 06:34:51.217+00
539	9	\N	{"lat":"15.1626642","lng":"120.5565613"}	2021-03-17 06:34:52.014+00
540	1	\N	{"lat":"15.1626675","lng":"120.5565618"}	2021-03-17 06:34:52.875+00
541	9	\N	{"lat":"15.1626642","lng":"120.5565613"}	2021-03-17 06:34:55.257+00
542	5	\N	{"lat":"15.1626661","lng":"120.55656"}	2021-03-17 06:34:55.452+00
543	5	\N	{"lat":"15.1626661","lng":"120.55656"}	2021-03-17 06:34:55.815+00
544	10	\N	{"lat":"15.1626661","lng":"120.5565643"}	2021-03-17 06:34:55.923+00
545	10	\N	{"lat":"15.1626661","lng":"120.5565643"}	2021-03-17 06:34:56.691+00
546	5	\N	{"lat":"15.1626661","lng":"120.55656"}	2021-03-17 06:34:56.695+00
549	7	\N	{"lat":"15.162676","lng":"120.5565592"}	2021-03-17 06:34:57.734+00
555	9	\N	{"lat":"15.1626642","lng":"120.5565613"}	2021-03-17 06:35:03.243+00
1443	7	16	{"lat":15.1552367,"lng":120.5602868}	2021-03-17 06:57:20.24+00
1444	7	16	{"lat":15.1559223,"lng":120.560173}	2021-03-17 06:57:26.256+00
1445	7	16	{"lat":15.1565537,"lng":120.5600379}	2021-03-17 06:57:31.249+00
1446	7	16	{"lat":15.1570566,"lng":120.5599324}	2021-03-17 06:57:36.272+00
1447	7	16	{"lat":15.1576775,"lng":120.5598249}	2021-03-17 06:57:41.234+00
1448	7	16	{"lat":15.1580552,"lng":120.5596739}	2021-03-17 06:57:46.239+00
1449	7	16	{"lat":15.1582242,"lng":120.5594776}	2021-03-17 06:57:50.266+00
1450	7	16	{"lat":15.1583708,"lng":120.5591038}	2021-03-17 06:57:56.257+00
1451	7	16	{"lat":15.1584722,"lng":120.5588057}	2021-03-17 06:58:01.261+00
1452	7	16	{"lat":15.1585279,"lng":120.5587339}	2021-03-17 06:58:06.256+00
1453	7	16	{"lat":15.1590127,"lng":120.5585533}	2021-03-17 06:58:11.247+00
1454	7	16	{"lat":15.1596128,"lng":120.558378}	2021-03-17 06:58:16.235+00
1455	7	16	{"lat":15.1600372,"lng":120.5582301}	2021-03-17 06:58:20.251+00
1456	7	16	{"lat":15.1607227,"lng":120.557981}	2021-03-17 06:58:26.255+00
1457	7	16	{"lat":15.1611739,"lng":120.5578335}	2021-03-17 06:58:31.248+00
494	9	\N	{"lat":"15.1626642","lng":"120.5565613"}	2021-03-17 06:34:08.81+00
495	8	\N	{"lat":"15.1626712","lng":"120.5565632"}	2021-03-17 06:34:11.814+00
496	9	\N	{"lat":"15.1626642","lng":"120.5565613"}	2021-03-17 06:34:12.271+00
547	8	\N	{"lat":"15.1626686","lng":"120.5565629"}	2021-03-17 06:34:56.981+00
548	9	\N	{"lat":"15.1626642","lng":"120.5565613"}	2021-03-17 06:34:57.336+00
550	8	\N	{"lat":"15.1626686","lng":"120.5565629"}	2021-03-17 06:34:58.08+00
551	3	\N	{"lat":"15.1626661","lng":"120.5565617"}	2021-03-17 06:34:58.84+00
552	9	\N	{"lat":"15.1626642","lng":"120.5565613"}	2021-03-17 06:35:01.107+00
553	3	\N	{"lat":"15.162671","lng":"120.5565629"}	2021-03-17 06:35:01.894+00
554	8	\N	{"lat":"15.162669","lng":"120.5565637"}	2021-03-17 06:35:01.984+00
556	5	\N	{"lat":"15.162668","lng":"120.5565604"}	2021-03-17 06:35:04.997+00
557	7	\N	{"lat":"15.1626683","lng":"120.5565631"}	2021-03-17 06:35:11.216+00
558	5	\N	{"lat":"15.1626744","lng":"120.5565606"}	2021-03-17 06:35:11.539+00
559	4	\N	{"lat":"15.1626685","lng":"120.5565604"}	2021-03-17 06:35:14.054+00
560	3	\N	{"lat":"15.1626683","lng":"120.5565628"}	2021-03-17 06:35:16.124+00
561	5	\N	{"lat":"15.1626682","lng":"120.5565598"}	2021-03-17 06:35:16.864+00
562	5	\N	{"lat":"15.1626682","lng":"120.5565598"}	2021-03-17 06:35:17.712+00
563	4	\N	{"lat":"15.162666","lng":"120.55656"}	2021-03-17 06:35:18.485+00
564	7	\N	{"lat":"15.1626675","lng":"120.5565621"}	2021-03-17 06:35:19.279+00
565	3	\N	{"lat":"15.162671","lng":"120.5565613"}	2021-03-17 06:35:19.467+00
566	5	\N	{"lat":"15.1626657","lng":"120.556558"}	2021-03-17 06:35:21.448+00
567	3	\N	{"lat":"15.1626719","lng":"120.5565608"}	2021-03-17 06:35:21.502+00
568	1	\N	{"lat":"15.1626676","lng":"120.5565603"}	2021-03-17 06:35:21.861+00
569	4	\N	{"lat":"15.1626665","lng":"120.5565612"}	2021-03-17 06:35:23.726+00
570	5	\N	{"lat":"15.1626694","lng":"120.5565604"}	2021-03-17 06:35:25.102+00
571	5	\N	{"lat":"15.1626694","lng":"120.5565604"}	2021-03-17 06:35:26.034+00
572	3	\N	{"lat":"15.1626629","lng":"120.5565615"}	2021-03-17 06:35:27.434+00
573	3	\N	{"lat":"15.1626629","lng":"120.5565615"}	2021-03-17 06:35:28.306+00
574	7	\N	{"lat":"15.1626703","lng":"120.556563"}	2021-03-17 06:35:28.937+00
575	3	\N	{"lat":"15.1626634","lng":"120.5565606"}	2021-03-17 06:35:29.815+00
576	5	\N	{"lat":"15.1626657","lng":"120.55656"}	2021-03-17 06:35:30.045+00
577	5	\N	{"lat":"15.1626657","lng":"120.55656"}	2021-03-17 06:35:30.104+00
578	3	\N	{"lat":"15.1626643","lng":"120.5565605"}	2021-03-17 06:35:32.682+00
579	4	\N	{"lat":"15.1626666","lng":"120.5565616"}	2021-03-17 06:35:32.962+00
580	3	\N	{"lat":"15.1626643","lng":"120.5565605"}	2021-03-17 06:35:34.038+00
581	5	\N	{"lat":"15.1626666","lng":"120.5565585"}	2021-03-17 06:35:34.992+00
582	5	\N	{"lat":"15.1626666","lng":"120.5565585"}	2021-03-17 06:35:35.213+00
583	7	\N	{"lat":"15.1626741","lng":"120.556564"}	2021-03-17 06:35:36.068+00
584	3	\N	{"lat":"15.1626631","lng":"120.5565616"}	2021-03-17 06:35:37.145+00
585	5	\N	{"lat":"15.162663","lng":"120.5565587"}	2021-03-17 06:35:39.901+00
586	5	\N	{"lat":"15.1626629","lng":"120.5565594"}	2021-03-17 06:35:43.749+00
587	5	\N	{"lat":"15.1626629","lng":"120.5565594"}	2021-03-17 06:35:43.998+00
588	3	\N	{"lat":"15.1626621","lng":"120.5565616"}	2021-03-17 06:35:44.184+00
589	3	\N	{"lat":"15.1626621","lng":"120.5565616"}	2021-03-17 06:35:44.19+00
590	7	\N	{"lat":"15.162663","lng":"120.556559"}	2021-03-17 06:35:45.582+00
591	5	\N	{"lat":"15.1626683","lng":"120.5565599"}	2021-03-17 06:35:47.527+00
592	5	\N	{"lat":"15.1626683","lng":"120.5565599"}	2021-03-17 06:35:48.724+00
593	1	\N	{"lat":"15.1626676","lng":"120.5565591"}	2021-03-17 06:35:53.176+00
594	5	\N	{"lat":"15.1626664","lng":"120.5565591"}	2021-03-17 06:35:54.381+00
595	5	\N	{"lat":"15.1626695","lng":"120.5565595"}	2021-03-17 06:35:59.752+00
596	5	\N	{"lat":"15.1626695","lng":"120.5565595"}	2021-03-17 06:36:00.375+00
597	3	\N	{"lat":"15.1626633","lng":"120.5565619"}	2021-03-17 06:36:01.014+00
598	3	\N	{"lat":"15.1626614","lng":"120.556561"}	2021-03-17 06:36:03.25+00
599	4	\N	{"lat":"15.1626674","lng":"120.5565601"}	2021-03-17 06:36:05.969+00
600	3	\N	{"lat":"15.1626615","lng":"120.5565606"}	2021-03-17 06:36:06.508+00
601	3	\N	{"lat":"15.1626615","lng":"120.5565606"}	2021-03-17 06:36:07.301+00
602	3	\N	{"lat":"15.1626604","lng":"120.5565571"}	2021-03-17 06:36:10.707+00
603	1	\N	{"lat":"15.1626661","lng":"120.5565611"}	2021-03-17 06:36:10.723+00
604	3	\N	{"lat":"15.1626604","lng":"120.5565571"}	2021-03-17 06:36:11.414+00
605	7	\N	{"lat":"15.1626698","lng":"120.5565613"}	2021-03-17 06:36:12.886+00
606	5	\N	{"lat":"15.1626651","lng":"120.5565596"}	2021-03-17 06:36:14.175+00
607	3	\N	{"lat":"15.1626632","lng":"120.5565587"}	2021-03-17 06:36:14.206+00
608	3	\N	{"lat":"15.1626632","lng":"120.5565587"}	2021-03-17 06:36:15.445+00
609	3	\N	{"lat":"15.1626644","lng":"120.5565618"}	2021-03-17 06:36:19.15+00
610	5	\N	{"lat":"15.1626655","lng":"120.5565588"}	2021-03-17 06:36:19.197+00
611	3	\N	{"lat":"15.1626644","lng":"120.5565618"}	2021-03-17 06:36:19.772+00
612	5	\N	{"lat":"15.1626655","lng":"120.5565588"}	2021-03-17 06:36:19.825+00
613	3	\N	{"lat":"15.1626644","lng":"120.5565618"}	2021-03-17 06:36:20.956+00
614	3	\N	{"lat":"15.1626627","lng":"120.55656"}	2021-03-17 06:36:23.057+00
615	3	\N	{"lat":"15.1626627","lng":"120.55656"}	2021-03-17 06:36:23.974+00
616	7	\N	{"lat":"15.1626685","lng":"120.5565583"}	2021-03-17 06:36:25.069+00
617	3	\N	{"lat":"15.1626629","lng":"120.5565599"}	2021-03-17 06:36:26.046+00
618	6	\N	{"lat":"15.1625647","lng":"120.5564977"}	2021-03-17 06:36:26.458+00
619	3	\N	{"lat":"15.1626629","lng":"120.5565599"}	2021-03-17 06:36:26.941+00
620	1	\N	{"lat":"15.1626691","lng":"120.5565612"}	2021-03-17 06:36:27.268+00
621	5	\N	{"lat":"15.1626619","lng":"120.5565592"}	2021-03-17 06:36:28.8+00
622	4	\N	{"lat":"15.1626626","lng":"120.5565582"}	2021-03-17 06:36:32.504+00
623	4	\N	{"lat":"15.1626626","lng":"120.5565582"}	2021-03-17 06:36:33.262+00
624	5	\N	{"lat":"15.1626714","lng":"120.5565597"}	2021-03-17 06:36:33.788+00
625	4	\N	{"lat":"15.1626626","lng":"120.5565582"}	2021-03-17 06:36:34.302+00
626	4	\N	{"lat":"15.1626645","lng":"120.5565586"}	2021-03-17 06:36:37.912+00
627	5	\N	{"lat":"15.1626727","lng":"120.55656"}	2021-03-17 06:36:38.066+00
628	5	\N	{"lat":"15.1626727","lng":"120.55656"}	2021-03-17 06:36:40.001+00
629	5	\N	{"lat":"15.1626708","lng":"120.5565598"}	2021-03-17 06:36:42.413+00
630	1	\N	{"lat":"15.16267","lng":"120.5565617"}	2021-03-17 06:36:44.874+00
631	5	\N	{"lat":"15.1626722","lng":"120.5565604"}	2021-03-17 06:36:46.87+00
632	5	\N	{"lat":"15.1626722","lng":"120.5565604"}	2021-03-17 06:36:47.917+00
633	3	\N	{"lat":"15.1626709","lng":"120.5565613"}	2021-03-17 06:36:50.346+00
634	3	\N	{"lat":"15.1626709","lng":"120.5565613"}	2021-03-17 06:36:50.648+00
635	3	\N	{"lat":"15.1626709","lng":"120.5565613"}	2021-03-17 06:36:51.893+00
636	5	\N	{"lat":"15.1626724","lng":"120.5565609"}	2021-03-17 06:36:51.906+00
637	5	\N	{"lat":"15.1626724","lng":"120.5565609"}	2021-03-17 06:36:53.253+00
638	3	\N	{"lat":"15.1626725","lng":"120.5565594"}	2021-03-17 06:36:53.585+00
639	3	\N	{"lat":"15.1626725","lng":"120.5565594"}	2021-03-17 06:36:54.51+00
644	7	\N	{"lat":"15.1626713","lng":"120.5565635"}	2021-03-17 06:36:56.974+00
656	1	\N	{"lat":"15.1626711","lng":"120.5565651"}	2021-03-17 06:37:05.719+00
657	1	\N	{"lat":"15.1626711","lng":"120.5565651"}	2021-03-17 06:37:06.412+00
658	4	\N	{"lat":"15.1626607","lng":"120.5565606"}	2021-03-17 06:37:08.428+00
659	5	\N	{"lat":"15.1626633","lng":"120.5565595"}	2021-03-17 06:37:11.68+00
660	5	\N	{"lat":"15.1626633","lng":"120.5565595"}	2021-03-17 06:37:12.018+00
661	1	\N	{"lat":"15.1626721","lng":"120.5565638"}	2021-03-17 06:37:12.331+00
670	4	\N	{"lat":"15.1626629","lng":"120.5565607"}	2021-03-17 06:37:19.686+00
671	5	\N	{"lat":"15.1626659","lng":"120.5565596"}	2021-03-17 06:37:20.054+00
674	1	\N	{"lat":"15.1626724","lng":"120.5565604"}	2021-03-17 06:37:20.951+00
681	5	\N	{"lat":"15.1626606","lng":"120.5565606"}	2021-03-17 06:37:26.937+00
682	3	\N	{"lat":"15.1626633","lng":"120.5565603"}	2021-03-17 06:37:27.416+00
683	7	\N	{"lat":"15.1626703","lng":"120.5565618"}	2021-03-17 06:37:29.964+00
692	5	\N	{"lat":"15.1626706","lng":"120.5565621"}	2021-03-17 06:37:36.129+00
693	5	\N	{"lat":"15.1626706","lng":"120.5565621"}	2021-03-17 06:37:36.436+00
699	1	\N	{"lat":"15.1626629","lng":"120.5565627"}	2021-03-17 06:37:40.361+00
700	1	\N	{"lat":"15.1626629","lng":"120.5565627"}	2021-03-17 06:37:41.088+00
702	3	\N	{"lat":"15.1626609","lng":"120.5565581"}	2021-03-17 06:37:41.74+00
703	7	\N	{"lat":"15.1626656","lng":"120.556561"}	2021-03-17 06:37:42.318+00
712	5	\N	{"lat":"15.1626675","lng":"120.5565605"}	2021-03-17 06:37:50.327+00
1458	7	16	{"lat":15.1615705,"lng":120.5577214}	2021-03-17 06:58:36.239+00
1459	7	16	{"lat":15.1619572,"lng":120.5575749}	2021-03-17 06:58:41.248+00
1460	7	16	{"lat":15.1623386,"lng":120.5574253}	2021-03-17 06:58:46.274+00
1461	7	16	{"lat":15.1626177,"lng":120.5573207}	2021-03-17 06:58:50.257+00
1462	7	16	{"lat":15.1629671,"lng":120.5571639}	2021-03-17 06:58:56.27+00
1463	7	16	{"lat":15.1629131,"lng":120.5570115}	2021-03-17 06:59:01.263+00
1464	7	16	{"lat":15.1628699,"lng":120.5567459}	2021-03-17 06:59:06.251+00
1465	7	16	{"lat":15.1626338,"lng":120.5565251}	2021-03-17 06:59:11.254+00
1466	7	16	{"lat":15.1626721,"lng":120.5565849}	2021-03-17 06:59:16.223+00
1467	7	16	{"lat":15.162714,"lng":120.5565645}	2021-03-17 06:59:20.253+00
1468	7	16	{"lat":15.1627106,"lng":120.5565468}	2021-03-17 06:59:26.259+00
1469	7	16	{"lat":15.1627219,"lng":120.5565426}	2021-03-17 06:59:29.535+00
1470	7	16	{"lat":15.1626687,"lng":120.5565626}	2021-03-17 06:59:39.582+00
1471	7	16	{"lat":15.1626748,"lng":120.5565613}	2021-03-17 06:59:47.104+00
1472	7	16	{"lat":15.1626467,"lng":120.5565519}	2021-03-17 06:59:51.874+00
1473	7	16	{"lat":15.1626437,"lng":120.5565514}	2021-03-17 06:59:58.251+00
1474	7	16	{"lat":15.1626437,"lng":120.5565514}	2021-03-17 06:59:59.383+00
1475	7	16	{"lat":15.1626708,"lng":120.5565268}	2021-03-17 07:00:08.28+00
1476	7	16	{"lat":15.1626708,"lng":120.5565268}	2021-03-17 07:00:09.409+00
1477	7	16	{"lat":15.1626643,"lng":120.5565281}	2021-03-17 07:00:16.949+00
1478	7	16	{"lat":15.1625858,"lng":120.5565189}	2021-03-17 07:00:21.606+00
1479	7	16	{"lat":15.162569,"lng":120.5565121}	2021-03-17 07:00:27.005+00
1480	7	16	{"lat":15.1625551,"lng":120.556504}	2021-03-17 07:00:32.109+00
1481	7	16	{"lat":15.1625556,"lng":120.556508}	2021-03-17 07:00:36.952+00
1482	7	16	{"lat":15.1625506,"lng":120.5565061}	2021-03-17 07:00:41.864+00
1483	7	16	{"lat":15.1625582,"lng":120.5565098}	2021-03-17 07:00:46.015+00
1484	7	16	{"lat":15.1625663,"lng":120.5565116}	2021-03-17 07:00:49.403+00
1485	7	16	{"lat":15.1625533,"lng":120.556507}	2021-03-17 07:00:56.809+00
1486	7	16	{"lat":15.162552,"lng":120.5565055}	2021-03-17 07:01:01.102+00
1487	7	16	{"lat":15.162558,"lng":120.5565064}	2021-03-17 07:01:07.102+00
1488	7	16	{"lat":15.1625659,"lng":120.5565023}	2021-03-17 07:01:12.286+00
1489	7	16	{"lat":15.162564,"lng":120.5565009}	2021-03-17 07:01:16.962+00
1490	7	16	{"lat":15.1625607,"lng":120.5564992}	2021-03-17 07:01:20.035+00
1491	7	16	{"lat":15.1625609,"lng":120.5564999}	2021-03-17 07:01:24.543+00
1492	7	16	{"lat":15.162558,"lng":120.5564963}	2021-03-17 07:01:32.223+00
1493	7	16	{"lat":15.162562,"lng":120.5564951}	2021-03-17 07:01:37.234+00
1494	7	16	{"lat":15.1625595,"lng":120.5564968}	2021-03-17 07:01:41.936+00
1495	7	16	{"lat":15.1625628,"lng":120.5564982}	2021-03-17 07:01:46.878+00
1496	7	16	{"lat":15.1625617,"lng":120.5564996}	2021-03-17 07:01:51.569+00
1497	7	16	{"lat":15.1625582,"lng":120.556499}	2021-03-17 07:01:56.859+00
1498	7	16	{"lat":15.1625595,"lng":120.5564977}	2021-03-17 07:02:02.197+00
1499	7	16	{"lat":15.1625595,"lng":120.5564977}	2021-03-17 07:02:04.361+00
1500	7	16	{"lat":15.1625588,"lng":120.5564961}	2021-03-17 07:02:09.371+00
1920	2	7	{"lat":15.1406055,"lng":120.5622675}	2021-03-17 06:46:08.708+00
1921	2	7	{"lat":15.1387143,"lng":120.5628726}	2021-03-17 06:46:17.988+00
1922	2	7	{"lat":15.1387143,"lng":120.5628726}	2021-03-17 06:46:18.57+00
1923	2	7	{"lat":15.1387074,"lng":120.5628474}	2021-03-17 06:46:27.747+00
1924	2	7	{"lat":15.1387074,"lng":120.5628474}	2021-03-17 06:46:28.57+00
1925	2	7	{"lat":15.1387294,"lng":120.5627579}	2021-03-17 06:46:38.19+00
1926	2	7	{"lat":15.1387294,"lng":120.5627579}	2021-03-17 06:46:38.574+00
1927	2	7	{"lat":15.1387294,"lng":120.5627579}	2021-03-17 06:46:43.581+00
1928	2	7	{"lat":15.1386549,"lng":120.5627324}	2021-03-17 06:46:48.741+00
1929	2	7	{"lat":15.1386372,"lng":120.5627577}	2021-03-17 06:46:58.107+00
1930	2	7	{"lat":15.1386372,"lng":120.5627577}	2021-03-17 06:46:58.571+00
1931	2	7	{"lat":15.1386053,"lng":120.5627377}	2021-03-17 06:47:08.201+00
1932	2	7	{"lat":15.1386053,"lng":120.5627377}	2021-03-17 06:47:08.544+00
1933	2	7	{"lat":15.1385912,"lng":120.5627318}	2021-03-17 06:47:18.195+00
1934	2	7	{"lat":15.1385912,"lng":120.5627318}	2021-03-17 06:47:18.535+00
1935	2	7	{"lat":15.1386036,"lng":120.5627329}	2021-03-17 06:47:24.157+00
1936	2	7	{"lat":15.1385949,"lng":120.5627278}	2021-03-17 06:47:33.182+00
1937	2	7	{"lat":15.1385949,"lng":120.5627278}	2021-03-17 06:47:33.572+00
1938	2	7	{"lat":15.1386097,"lng":120.5627386}	2021-03-17 06:47:39.197+00
1939	2	7	{"lat":15.1385989,"lng":120.562741}	2021-03-17 06:47:48.129+00
1940	2	7	{"lat":15.1385989,"lng":120.562741}	2021-03-17 06:47:48.546+00
1941	2	7	{"lat":15.1386133,"lng":120.5627642}	2021-03-17 06:47:58.164+00
1942	2	7	{"lat":15.1386133,"lng":120.5627642}	2021-03-17 06:47:58.568+00
640	5	\N	{"lat":"15.1626691","lng":"120.5565591"}	2021-03-17 06:36:56.002+00
641	5	\N	{"lat":"15.1626691","lng":"120.5565591"}	2021-03-17 06:36:56.218+00
648	6	\N	{"lat":"15.1625551","lng":"120.5564989"}	2021-03-17 06:36:59.513+00
653	3	\N	{"lat":"15.1626632","lng":"120.5565611"}	2021-03-17 06:37:04.634+00
654	5	\N	{"lat":"15.1626687","lng":"120.556558"}	2021-03-17 06:37:05.193+00
655	5	\N	{"lat":"15.1626687","lng":"120.556558"}	2021-03-17 06:37:05.413+00
662	5	\N	{"lat":"15.1626633","lng":"120.5565595"}	2021-03-17 06:37:13.003+00
663	3	\N	{"lat":"15.1626632","lng":"120.5565592"}	2021-03-17 06:37:14.69+00
664	3	\N	{"lat":"15.1626632","lng":"120.5565592"}	2021-03-17 06:37:16.297+00
672	4	\N	{"lat":"15.1626629","lng":"120.5565607"}	2021-03-17 06:37:20.488+00
675	3	\N	{"lat":"15.1626601","lng":"120.5565588"}	2021-03-17 06:37:21.289+00
676	3	\N	{"lat":"15.1626601","lng":"120.5565588"}	2021-03-17 06:37:22.173+00
677	3	\N	{"lat":"15.1626623","lng":"120.5565615"}	2021-03-17 06:37:24.326+00
678	1	\N	{"lat":"15.1626635","lng":"120.5565612"}	2021-03-17 06:37:26.108+00
679	4	\N	{"lat":"15.1626688","lng":"120.5565613"}	2021-03-17 06:37:26.334+00
684	5	\N	{"lat":"15.1626649","lng":"120.5565578"}	2021-03-17 06:37:31.102+00
685	5	\N	{"lat":"15.1626649","lng":"120.5565578"}	2021-03-17 06:37:31.19+00
686	6	\N	{"lat":"15.1626482","lng":"120.5565527"}	2021-03-17 06:37:32.096+00
687	1	\N	{"lat":"15.1626721","lng":"120.5565615"}	2021-03-17 06:37:33.178+00
688	3	\N	{"lat":"15.1626644","lng":"120.5565599"}	2021-03-17 06:37:33.864+00
689	3	\N	{"lat":"15.1626644","lng":"120.5565599"}	2021-03-17 06:37:34.323+00
690	4	\N	{"lat":"15.1626673","lng":"120.556562"}	2021-03-17 06:37:35.314+00
691	3	\N	{"lat":"15.1626644","lng":"120.5565599"}	2021-03-17 06:37:35.613+00
1502	4	23	{"lat":15.162663,"lng":120.5565606}	2021-03-17 06:41:08.566+00
1503	4	23	{"lat":15.1626624,"lng":120.5565598}	2021-03-17 06:41:15.058+00
1504	4	23	{"lat":15.1626625,"lng":120.5565609}	2021-03-17 06:41:20.088+00
1505	4	23	{"lat":15.162665,"lng":120.5565613}	2021-03-17 06:41:25.225+00
1506	4	23	{"lat":15.1626678,"lng":120.5565604}	2021-03-17 06:41:30.139+00
1507	4	23	{"lat":15.1626687,"lng":120.5565598}	2021-03-17 06:41:35.138+00
1508	4	23	{"lat":15.1626677,"lng":120.55656}	2021-03-17 06:41:40.158+00
1509	4	23	{"lat":15.16267,"lng":120.556561}	2021-03-17 06:41:43.881+00
1510	4	23	{"lat":15.1626708,"lng":120.5565609}	2021-03-17 06:41:48.068+00
1511	4	23	{"lat":15.1626694,"lng":120.5565647}	2021-03-17 06:41:55.114+00
1512	4	23	{"lat":15.162671,"lng":120.5565638}	2021-03-17 06:42:00.128+00
1513	4	23	{"lat":15.1626736,"lng":120.5565667}	2021-03-17 06:42:05.158+00
1514	4	23	{"lat":15.16268,"lng":120.556563}	2021-03-17 06:42:10.316+00
1515	4	23	{"lat":15.1626744,"lng":120.5565646}	2021-03-17 06:42:15.32+00
1516	4	23	{"lat":15.1626733,"lng":120.5565517}	2021-03-17 06:42:22.688+00
1517	4	23	{"lat":15.1626733,"lng":120.5565517}	2021-03-17 06:42:22.891+00
1518	4	23	{"lat":15.1626726,"lng":120.5565423}	2021-03-17 06:42:30.172+00
1519	4	23	{"lat":15.1626665,"lng":120.5565274}	2021-03-17 06:42:35.167+00
1520	4	23	{"lat":15.1626727,"lng":120.5565557}	2021-03-17 06:42:40.147+00
1521	4	23	{"lat":15.1626702,"lng":120.5565682}	2021-03-17 06:42:45.189+00
1522	4	23	{"lat":15.1626748,"lng":120.5565642}	2021-03-17 06:42:50.212+00
1523	4	23	{"lat":15.1626729,"lng":120.5565619}	2021-03-17 06:42:55.14+00
1524	4	23	{"lat":15.1626722,"lng":120.5565576}	2021-03-17 06:43:00.124+00
1525	4	23	{"lat":15.1626761,"lng":120.5565597}	2021-03-17 06:43:05.172+00
1526	4	23	{"lat":15.1626766,"lng":120.5565601}	2021-03-17 06:43:10.196+00
1527	4	23	{"lat":15.1626787,"lng":120.5565619}	2021-03-17 06:43:15.218+00
1528	4	23	{"lat":15.1626752,"lng":120.5565622}	2021-03-17 06:43:20.103+00
1529	4	23	{"lat":15.1626756,"lng":120.5565615}	2021-03-17 06:43:25.172+00
1530	4	23	{"lat":15.162678,"lng":120.5565651}	2021-03-17 06:43:30.243+00
1531	4	23	{"lat":15.1626781,"lng":120.5565652}	2021-03-17 06:43:35.154+00
1532	4	23	{"lat":15.1626794,"lng":120.5565613}	2021-03-17 06:43:40.065+00
1533	4	23	{"lat":15.1626776,"lng":120.5565641}	2021-03-17 06:43:45.108+00
1534	4	23	{"lat":15.162676,"lng":120.5565664}	2021-03-17 06:43:50.104+00
1535	4	23	{"lat":15.1626804,"lng":120.5565667}	2021-03-17 06:43:55.255+00
1536	4	23	{"lat":15.1626753,"lng":120.556559}	2021-03-17 06:44:00.124+00
1537	4	23	{"lat":15.16267,"lng":120.5565568}	2021-03-17 06:44:05.163+00
1538	4	23	{"lat":15.16267,"lng":120.5565599}	2021-03-17 06:44:10.083+00
1539	4	23	{"lat":15.162671,"lng":120.5565619}	2021-03-17 06:44:15.097+00
1540	4	23	{"lat":15.1626711,"lng":120.5565616}	2021-03-17 06:44:19.119+00
1541	4	23	{"lat":15.1626702,"lng":120.556562}	2021-03-17 06:44:23.215+00
1542	4	23	{"lat":15.1627455,"lng":120.5567052}	2021-03-17 06:44:31.69+00
1543	4	23	{"lat":15.1627455,"lng":120.5567052}	2021-03-17 06:44:32.92+00
1544	4	23	{"lat":15.1628635,"lng":120.5571478}	2021-03-17 06:44:41.643+00
1545	4	23	{"lat":15.1628635,"lng":120.5571478}	2021-03-17 06:44:42.892+00
1546	4	23	{"lat":15.1620315,"lng":120.5575539}	2021-03-17 06:44:51.66+00
1547	4	23	{"lat":15.1620315,"lng":120.5575539}	2021-03-17 06:44:52.922+00
1548	4	23	{"lat":15.1612892,"lng":120.5579169}	2021-03-17 06:45:01.709+00
1549	4	23	{"lat":15.1612892,"lng":120.5579169}	2021-03-17 06:45:02.92+00
1550	4	23	{"lat":15.1605721,"lng":120.5581935}	2021-03-17 06:45:09.656+00
1551	4	23	{"lat":15.160349,"lng":120.558109}	2021-03-17 06:45:14.633+00
1552	4	23	{"lat":15.1625411,"lng":120.5572313}	2021-03-17 06:45:18.301+00
1553	4	23	{"lat":15.1585224,"lng":120.5579508}	2021-03-17 06:45:23.121+00
1554	4	23	{"lat":15.1589012,"lng":120.5575918}	2021-03-17 06:45:28.111+00
1555	4	23	{"lat":15.1588331,"lng":120.5576563}	2021-03-17 06:45:36.866+00
1556	4	23	{"lat":15.1588643,"lng":120.5576267}	2021-03-17 06:45:41.908+00
1557	4	23	{"lat":15.1583548,"lng":120.5587381}	2021-03-17 06:45:50.688+00
1558	4	23	{"lat":15.1583548,"lng":120.5587381}	2021-03-17 06:45:51.679+00
1559	4	23	{"lat":15.1583363,"lng":120.5587396}	2021-03-17 06:45:56.669+00
1560	4	23	{"lat":15.1580091,"lng":120.5593706}	2021-03-17 06:46:04.675+00
1561	4	23	{"lat":15.1572308,"lng":120.5598349}	2021-03-17 06:46:10.676+00
1562	4	23	{"lat":15.1572308,"lng":120.5598349}	2021-03-17 06:46:11.703+00
1563	4	23	{"lat":15.1560371,"lng":120.5600915}	2021-03-17 06:46:19.7+00
1564	4	23	{"lat":15.1560371,"lng":120.5600915}	2021-03-17 06:46:21.68+00
1565	4	23	{"lat":15.1548423,"lng":120.5603068}	2021-03-17 06:46:29.658+00
1566	4	23	{"lat":15.1542934,"lng":120.5602853}	2021-03-17 06:46:34.676+00
1567	4	23	{"lat":15.1536376,"lng":120.5602859}	2021-03-17 06:46:40.699+00
1568	4	23	{"lat":15.1536376,"lng":120.5602859}	2021-03-17 06:46:41.68+00
642	1	\N	{"lat":"15.1626642","lng":"120.556563"}	2021-03-17 06:36:56.315+00
643	3	\N	{"lat":"15.1626675","lng":"120.556562"}	2021-03-17 06:36:56.964+00
645	5	\N	{"lat":"15.1626691","lng":"120.5565591"}	2021-03-17 06:36:57.535+00
646	1	\N	{"lat":"15.1626642","lng":"120.556563"}	2021-03-17 06:36:57.572+00
647	3	\N	{"lat":"15.1626675","lng":"120.556562"}	2021-03-17 06:36:57.779+00
649	3	\N	{"lat":"15.1626638","lng":"120.5565621"}	2021-03-17 06:37:00.291+00
650	5	\N	{"lat":"15.1626694","lng":"120.5565604"}	2021-03-17 06:37:00.84+00
651	3	\N	{"lat":"15.1626638","lng":"120.5565621"}	2021-03-17 06:37:01.396+00
652	5	\N	{"lat":"15.1626694","lng":"120.5565604"}	2021-03-17 06:37:02.135+00
665	5	\N	{"lat":"15.1626661","lng":"120.5565609"}	2021-03-17 06:37:16.428+00
666	5	\N	{"lat":"15.1626661","lng":"120.5565609"}	2021-03-17 06:37:16.579+00
667	3	\N	{"lat":"15.1626658","lng":"120.5565603"}	2021-03-17 06:37:17.77+00
668	3	\N	{"lat":"15.1626658","lng":"120.5565603"}	2021-03-17 06:37:18.962+00
669	1	\N	{"lat":"15.1626724","lng":"120.5565604"}	2021-03-17 06:37:19.246+00
673	5	\N	{"lat":"15.1626659","lng":"120.5565596"}	2021-03-17 06:37:20.679+00
680	1	\N	{"lat":"15.1626635","lng":"120.5565612"}	2021-03-17 06:37:26.503+00
694	4	\N	{"lat":"15.1626673","lng":"120.556562"}	2021-03-17 06:37:36.809+00
695	3	\N	{"lat":"15.1626633","lng":"120.5565614"}	2021-03-17 06:37:37.486+00
696	5	\N	{"lat":"15.1626706","lng":"120.5565621"}	2021-03-17 06:37:38.086+00
697	3	\N	{"lat":"15.1626633","lng":"120.5565614"}	2021-03-17 06:37:38.132+00
698	5	\N	{"lat":"15.1626706","lng":"120.5565621"}	2021-03-17 06:37:38.268+00
701	5	\N	{"lat":"15.1626668","lng":"120.5565586"}	2021-03-17 06:37:41.563+00
704	3	\N	{"lat":"15.1626609","lng":"120.5565581"}	2021-03-17 06:37:42.473+00
705	4	\N	{"lat":"15.1626668","lng":"120.556562"}	2021-03-17 06:37:42.489+00
706	3	\N	{"lat":"15.1626605","lng":"120.5565589"}	2021-03-17 06:37:44.741+00
707	3	\N	{"lat":"15.1626605","lng":"120.5565589"}	2021-03-17 06:37:45.345+00
708	3	\N	{"lat":"15.1626605","lng":"120.5565589"}	2021-03-17 06:37:46.745+00
709	4	\N	{"lat":"15.1626645","lng":"120.5565621"}	2021-03-17 06:37:47.089+00
710	4	\N	{"lat":"15.1626645","lng":"120.5565621"}	2021-03-17 06:37:47.485+00
711	4	\N	{"lat":"15.1626645","lng":"120.5565621"}	2021-03-17 06:37:48.363+00
713	1	\N	{"lat":"15.162661","lng":"120.5565595"}	2021-03-17 06:37:50.422+00
714	5	\N	{"lat":"15.1626675","lng":"120.5565605"}	2021-03-17 06:37:50.432+00
715	1	\N	{"lat":"15.162661","lng":"120.5565595"}	2021-03-17 06:37:50.848+00
716	4	\N	{"lat":"15.1626636","lng":"120.5565599"}	2021-03-17 06:37:50.852+00
717	7	\N	{"lat":"15.1626616","lng":"120.5565615"}	2021-03-17 06:37:56.44+00
718	1	\N	{"lat":"15.1626591","lng":"120.5565601"}	2021-03-17 06:38:00.956+00
719	6	\N	{"lat":"15.1626674","lng":"120.5565603"}	2021-03-17 06:38:01.695+00
720	1	\N	{"lat":"15.1626591","lng":"120.5565601"}	2021-03-17 06:38:02.192+00
721	4	\N	{"lat":"15.1626638","lng":"120.5565633"}	2021-03-17 06:38:05.38+00
722	5	\N	{"lat":"15.1626606","lng":"120.5565613"}	2021-03-17 06:38:06.661+00
723	5	\N	{"lat":"15.1626606","lng":"120.5565613"}	2021-03-17 06:38:06.882+00
724	1	\N	{"lat":"15.1626625","lng":"120.5565607"}	2021-03-17 06:38:07.406+00
725	7	\N	{"lat":"15.1626663","lng":"120.5565613"}	2021-03-17 06:38:08.33+00
726	1	\N	{"lat":"15.1626625","lng":"120.5565607"}	2021-03-17 06:38:08.584+00
727	4	\N	{"lat":"15.1626698","lng":"120.5565673"}	2021-03-17 06:38:09.1+00
728	5	\N	{"lat":"15.162663","lng":"120.556559"}	2021-03-17 06:38:10.991+00
729	1	\N	{"lat":"15.1626622","lng":"120.556562"}	2021-03-17 06:38:14.322+00
730	5	\N	{"lat":"15.1626609","lng":"120.5565585"}	2021-03-17 06:38:14.939+00
731	7	\N	{"lat":"15.1626667","lng":"120.5565634"}	2021-03-17 06:38:15.721+00
732	1	\N	{"lat":"15.1626631","lng":"120.5565593"}	2021-03-17 06:38:19.468+00
733	5	\N	{"lat":"15.1626729","lng":"120.5565604"}	2021-03-17 06:38:21.574+00
734	5	\N	{"lat":"15.1626729","lng":"120.5565604"}	2021-03-17 06:38:22.439+00
735	5	\N	{"lat":"15.1626729","lng":"120.5565604"}	2021-03-17 06:38:23.313+00
736	5	\N	{"lat":"15.1626727","lng":"120.5565616"}	2021-03-17 06:38:25.808+00
737	5	\N	{"lat":"15.1626727","lng":"120.5565616"}	2021-03-17 06:38:25.937+00
738	1	\N	{"lat":"15.1626682","lng":"120.5565601"}	2021-03-17 06:38:28.616+00
739	6	\N	{"lat":"15.1626649","lng":"120.5565603"}	2021-03-17 06:38:30.018+00
740	5	\N	{"lat":"15.1626594","lng":"120.5565591"}	2021-03-17 06:38:33.999+00
741	5	\N	{"lat":"15.1626594","lng":"120.5565591"}	2021-03-17 06:38:35.1+00
742	4	\N	{"lat":"15.1626696","lng":"120.556562"}	2021-03-17 06:38:35.361+00
743	1	\N	{"lat":"15.1626667","lng":"120.5565642"}	2021-03-17 06:38:37.604+00
744	7	\N	{"lat":"15.162667","lng":"120.5565599"}	2021-03-17 06:38:39.554+00
745	7	\N	{"lat":"15.162667","lng":"120.5565599"}	2021-03-17 06:38:40.336+00
746	5	\N	{"lat":"15.1626659","lng":"120.5565583"}	2021-03-17 06:38:42.107+00
747	3	\N	{"lat":"15.1626644","lng":"120.5565593"}	2021-03-17 06:38:42.46+00
748	3	\N	{"lat":"15.1626644","lng":"120.5565593"}	2021-03-17 06:38:43.1+00
749	7	\N	{"lat":"15.1626658","lng":"120.5565601"}	2021-03-17 06:38:44.671+00
750	3	\N	{"lat":"15.1626643","lng":"120.5565601"}	2021-03-17 06:38:45.529+00
751	3	\N	{"lat":"15.1626643","lng":"120.5565601"}	2021-03-17 06:38:45.674+00
752	3	\N	{"lat":"15.1626643","lng":"120.5565601"}	2021-03-17 06:38:46.994+00
753	1	\N	{"lat":"15.1626716","lng":"120.5565646"}	2021-03-17 06:38:47.614+00
754	5	\N	{"lat":"15.1626666","lng":"120.5565585"}	2021-03-17 06:38:47.904+00
755	5	\N	{"lat":"15.1626666","lng":"120.5565585"}	2021-03-17 06:38:48.009+00
756	5	\N	{"lat":"15.1626666","lng":"120.5565585"}	2021-03-17 06:38:49.013+00
757	3	\N	{"lat":"15.1626656","lng":"120.5565614"}	2021-03-17 06:38:49.298+00
758	3	\N	{"lat":"15.1626656","lng":"120.5565614"}	2021-03-17 06:38:49.748+00
759	5	\N	{"lat":"15.1626666","lng":"120.5565585"}	2021-03-17 06:38:49.896+00
760	3	\N	{"lat":"15.1626656","lng":"120.5565614"}	2021-03-17 06:38:50.982+00
761	5	\N	{"lat":"15.162671","lng":"120.5565597"}	2021-03-17 06:38:52.479+00
762	3	\N	{"lat":"15.1626632","lng":"120.5565607"}	2021-03-17 06:38:53.168+00
763	3	\N	{"lat":"15.1626632","lng":"120.5565607"}	2021-03-17 06:38:53.578+00
764	3	\N	{"lat":"15.1626632","lng":"120.5565607"}	2021-03-17 06:38:54.966+00
765	3	\N	{"lat":"15.1626619","lng":"120.5565596"}	2021-03-17 06:38:57.266+00
766	5	\N	{"lat":"15.1626655","lng":"120.5565598"}	2021-03-17 06:38:57.494+00
767	3	\N	{"lat":"15.1626619","lng":"120.5565596"}	2021-03-17 06:38:57.898+00
768	5	\N	{"lat":"15.1626655","lng":"120.5565598"}	2021-03-17 06:38:58.139+00
769	1	\N	{"lat":"15.1626703","lng":"120.5565652"}	2021-03-17 06:38:58.656+00
770	5	\N	{"lat":"15.1626655","lng":"120.5565598"}	2021-03-17 06:38:59.022+00
771	3	\N	{"lat":"15.1626645","lng":"120.5565614"}	2021-03-17 06:39:00.432+00
772	3	\N	{"lat":"15.1626645","lng":"120.5565614"}	2021-03-17 06:39:00.926+00
773	5	\N	{"lat":"15.162665","lng":"120.5565584"}	2021-03-17 06:39:02.448+00
1569	4	23	{"lat":15.1526729,"lng":120.5597184}	2021-03-17 06:46:49.691+00
1570	4	23	{"lat":15.1526729,"lng":120.5597184}	2021-03-17 06:46:51.687+00
1571	4	23	{"lat":15.1519087,"lng":120.5591384}	2021-03-17 06:46:58.88+00
1572	4	23	{"lat":15.1514146,"lng":120.5587576}	2021-03-17 06:47:01.949+00
1573	4	23	{"lat":15.1509261,"lng":120.558388}	2021-03-17 06:47:06.851+00
1574	4	23	{"lat":15.1504454,"lng":120.5580349}	2021-03-17 06:47:11.928+00
1575	4	23	{"lat":15.152008,"lng":120.5601091}	2021-03-17 06:47:16.893+00
1576	4	23	{"lat":15.152008,"lng":120.5601091}	2021-03-17 06:47:21.927+00
1577	4	23	{"lat":15.1475288,"lng":120.5594924}	2021-03-17 06:47:28.521+00
1578	4	23	{"lat":15.1474996,"lng":120.5594974}	2021-03-17 06:47:33.487+00
1579	4	23	{"lat":15.1461466,"lng":120.5595652}	2021-03-17 06:47:38.53+00
1580	4	23	{"lat":15.1455366,"lng":120.5595494}	2021-03-17 06:47:41.947+00
1581	4	23	{"lat":15.1454975,"lng":120.5594011}	2021-03-17 06:47:48.425+00
1582	4	23	{"lat":15.1447841,"lng":120.5591515}	2021-03-17 06:47:53.234+00
1583	4	23	{"lat":15.1445406,"lng":120.5590671}	2021-03-17 06:47:57.016+00
1584	4	23	{"lat":15.1447163,"lng":120.5591255}	2021-03-17 06:48:01.872+00
1585	4	23	{"lat":15.1432569,"lng":120.5598082}	2021-03-17 06:48:10.123+00
1586	4	23	{"lat":15.1432569,"lng":120.5598082}	2021-03-17 06:48:11.681+00
1587	4	23	{"lat":15.1406191,"lng":120.5607196}	2021-03-17 06:48:18.949+00
1588	4	23	{"lat":15.1409052,"lng":120.5611343}	2021-03-17 06:48:23.494+00
1589	4	23	{"lat":15.1408821,"lng":120.5615396}	2021-03-17 06:48:29.657+00
1590	4	23	{"lat":15.1400871,"lng":120.561984}	2021-03-17 06:48:35.675+00
1591	4	23	{"lat":15.1400871,"lng":120.561984}	2021-03-17 06:48:36.678+00
1592	4	23	{"lat":15.1388804,"lng":120.5626766}	2021-03-17 06:48:45.681+00
1593	4	23	{"lat":15.1388804,"lng":120.5626766}	2021-03-17 06:48:46.65+00
1594	4	23	{"lat":15.1386536,"lng":120.5628898}	2021-03-17 06:48:54.192+00
1595	4	23	{"lat":15.1386797,"lng":120.5628361}	2021-03-17 06:48:58.156+00
1596	4	23	{"lat":15.1387079,"lng":120.5627446}	2021-03-17 06:49:03.191+00
1597	4	23	{"lat":15.138712,"lng":120.562723}	2021-03-17 06:49:08.133+00
1598	4	23	{"lat":15.1387082,"lng":120.5627283}	2021-03-17 06:49:13.149+00
1599	4	23	{"lat":15.1387077,"lng":120.5627281}	2021-03-17 06:49:18.138+00
1600	4	23	{"lat":15.138709,"lng":120.5627632}	2021-03-17 06:49:21.803+00
1601	4	23	{"lat":15.1387079,"lng":120.5627723}	2021-03-17 06:49:28.024+00
1602	4	23	{"lat":15.1387057,"lng":120.5627335}	2021-03-17 06:49:33.155+00
1603	4	23	{"lat":15.1387021,"lng":120.5627279}	2021-03-17 06:49:38.13+00
1604	4	23	{"lat":15.1387013,"lng":120.5627274}	2021-03-17 06:49:41.832+00
1605	4	23	{"lat":15.1386923,"lng":120.5627561}	2021-03-17 06:49:47.462+00
1606	4	23	{"lat":15.138691,"lng":120.5627604}	2021-03-17 06:49:53.445+00
1607	4	23	{"lat":15.1386903,"lng":120.5627646}	2021-03-17 06:49:58.403+00
1608	4	23	{"lat":15.1386708,"lng":120.5627843}	2021-03-17 06:50:03.392+00
1609	4	23	{"lat":15.1386481,"lng":120.5627955}	2021-03-17 06:50:08.39+00
1610	4	23	{"lat":15.1386911,"lng":120.5627425}	2021-03-17 06:50:13.161+00
1611	4	23	{"lat":15.1387055,"lng":120.5627221}	2021-03-17 06:50:18.408+00
1612	4	23	{"lat":15.1388228,"lng":120.5630376}	2021-03-17 06:50:23.41+00
1613	4	23	{"lat":15.1386739,"lng":120.5628474}	2021-03-17 06:50:28.392+00
1614	4	23	{"lat":15.1386788,"lng":120.5628151}	2021-03-17 06:50:35.092+00
1615	4	23	{"lat":15.1386788,"lng":120.5628151}	2021-03-17 06:50:36.682+00
1616	4	23	{"lat":15.1385759,"lng":120.5628282}	2021-03-17 06:50:43.379+00
1617	4	23	{"lat":15.1385967,"lng":120.5627927}	2021-03-17 06:50:48.389+00
1618	4	23	{"lat":15.138646,"lng":120.5627836}	2021-03-17 06:50:53.409+00
1619	4	23	{"lat":15.1387128,"lng":120.562831}	2021-03-17 06:50:58.397+00
1620	4	23	{"lat":15.1386762,"lng":120.5628053}	2021-03-17 06:51:03.436+00
1621	4	23	{"lat":15.1386319,"lng":120.5627603}	2021-03-17 06:51:08.364+00
1622	4	23	{"lat":15.1386522,"lng":120.5627597}	2021-03-17 06:51:13.439+00
1623	4	23	{"lat":15.1387024,"lng":120.5627846}	2021-03-17 06:51:18.145+00
1624	4	23	{"lat":15.1387021,"lng":120.5627676}	2021-03-17 06:51:23.155+00
1625	4	23	{"lat":15.1386969,"lng":120.5627686}	2021-03-17 06:51:28.162+00
1626	4	23	{"lat":15.1387015,"lng":120.5627648}	2021-03-17 06:51:33.16+00
1627	4	23	{"lat":15.1387006,"lng":120.5627603}	2021-03-17 06:51:38.139+00
1628	4	23	{"lat":15.1387084,"lng":120.5627622}	2021-03-17 06:51:43.155+00
1629	4	23	{"lat":15.1387092,"lng":120.5627628}	2021-03-17 06:51:48.121+00
1630	4	23	{"lat":15.1387079,"lng":120.562761}	2021-03-17 06:51:53.155+00
1631	4	23	{"lat":15.1387077,"lng":120.5627608}	2021-03-17 06:51:58.146+00
1632	4	23	{"lat":15.1387084,"lng":120.5627612}	2021-03-17 06:52:03.171+00
1633	4	23	{"lat":15.1387084,"lng":120.5627618}	2021-03-17 06:52:08.126+00
1634	4	23	{"lat":15.1387087,"lng":120.5627625}	2021-03-17 06:52:12.898+00
1635	4	23	{"lat":15.1387235,"lng":120.5627699}	2021-03-17 06:52:17.013+00
1636	4	23	{"lat":15.1387345,"lng":120.5627789}	2021-03-17 06:52:21.911+00
1637	4	23	{"lat":15.1387119,"lng":120.5627628}	2021-03-17 06:52:28.425+00
1638	4	23	{"lat":15.1387673,"lng":120.5627681}	2021-03-17 06:52:33.154+00
1639	4	23	{"lat":15.1387195,"lng":120.5627679}	2021-03-17 06:52:37.127+00
1640	4	23	{"lat":15.1387211,"lng":120.5627676}	2021-03-17 06:52:42.624+00
1641	4	23	{"lat":15.1387741,"lng":120.5627718}	2021-03-17 06:52:46.873+00
1642	4	23	{"lat":15.1387633,"lng":120.5627898}	2021-03-17 06:52:53.429+00
1643	4	23	{"lat":15.1387245,"lng":120.5627789}	2021-03-17 06:52:58.14+00
1644	4	23	{"lat":15.1387253,"lng":120.5627755}	2021-03-17 06:53:03.157+00
1645	4	23	{"lat":15.1387285,"lng":120.5627755}	2021-03-17 06:53:08.151+00
1646	4	23	{"lat":15.1388708,"lng":120.5627192}	2021-03-17 06:53:13.145+00
1647	4	23	{"lat":15.1393164,"lng":120.5624217}	2021-03-17 06:53:18.153+00
1648	4	23	{"lat":15.1399546,"lng":120.5621039}	2021-03-17 06:53:24.167+00
1649	4	23	{"lat":15.140383,"lng":120.561852}	2021-03-17 06:53:28.145+00
1650	4	23	{"lat":15.1408315,"lng":120.5615447}	2021-03-17 06:53:33.157+00
1651	4	23	{"lat":15.1412712,"lng":120.5612723}	2021-03-17 06:53:38.167+00
1652	4	23	{"lat":15.141673,"lng":120.5609942}	2021-03-17 06:53:43.139+00
1653	4	23	{"lat":15.1423203,"lng":120.5606024}	2021-03-17 06:53:48.164+00
1654	4	23	{"lat":15.1427802,"lng":120.5603292}	2021-03-17 06:53:53.17+00
1655	4	23	{"lat":15.1432355,"lng":120.5600135}	2021-03-17 06:53:58.155+00
1656	4	23	{"lat":15.1436858,"lng":120.5596417}	2021-03-17 06:54:03.168+00
1657	4	23	{"lat":15.1439168,"lng":120.5594165}	2021-03-17 06:54:08.193+00
774	5	\N	{"lat":"15.1626653","lng":"120.5565593"}	2021-03-17 06:39:07.398+00
775	4	\N	{"lat":"15.1626676","lng":"120.5565604"}	2021-03-17 06:39:08.228+00
777	3	\N	{"lat":"15.1626655","lng":"120.5565622"}	2021-03-17 06:39:08.992+00
778	3	\N	{"lat":"15.1626655","lng":"120.5565622"}	2021-03-17 06:39:09.312+00
779	3	\N	{"lat":"15.1626655","lng":"120.5565622"}	2021-03-17 06:39:10.769+00
780	6	\N	{"lat":"15.1626649","lng":"120.5565603"}	2021-03-17 06:39:11.773+00
781	5	\N	{"lat":"15.1626686","lng":"120.5565593"}	2021-03-17 06:39:13.059+00
782	4	\N	{"lat":"15.162665","lng":"120.5565586"}	2021-03-17 06:39:13.385+00
783	5	\N	{"lat":"15.1626686","lng":"120.5565593"}	2021-03-17 06:39:13.411+00
797	3	\N	{"lat":"15.1626635","lng":"120.5565599"}	2021-03-17 06:39:25.108+00
798	5	\N	{"lat":"15.162665","lng":"120.5565594"}	2021-03-17 06:39:25.558+00
800	7	\N	{"lat":"15.1626647","lng":"120.5565617"}	2021-03-17 06:39:26.807+00
801	7	\N	{"lat":"15.1626647","lng":"120.5565617"}	2021-03-17 06:39:27.678+00
802	4	\N	{"lat":"15.1626677","lng":"120.5565616"}	2021-03-17 06:39:28.766+00
803	3	\N	{"lat":"15.1626628","lng":"120.556563"}	2021-03-17 06:39:29.211+00
804	5	\N	{"lat":"15.1626705","lng":"120.5565593"}	2021-03-17 06:39:29.231+00
805	3	\N	{"lat":"15.1626628","lng":"120.556563"}	2021-03-17 06:39:29.599+00
806	4	\N	{"lat":"15.1626677","lng":"120.5565616"}	2021-03-17 06:39:30.178+00
807	7	\N	{"lat":"15.1626685","lng":"120.556562"}	2021-03-17 06:39:32.268+00
809	5	\N	{"lat":"15.1626736","lng":"120.5565601"}	2021-03-17 06:39:33.055+00
810	7	\N	{"lat":"15.1626685","lng":"120.556562"}	2021-03-17 06:39:34.066+00
811	3	\N	{"lat":"15.1626652","lng":"120.5565645"}	2021-03-17 06:39:34.243+00
812	5	\N	{"lat":"15.1626736","lng":"120.5565601"}	2021-03-17 06:39:34.345+00
813	4	\N	{"lat":"15.16267","lng":"120.5565633"}	2021-03-17 06:39:34.357+00
814	4	\N	{"lat":"15.16267","lng":"120.5565633"}	2021-03-17 06:39:34.933+00
815	3	\N	{"lat":"15.1626652","lng":"120.5565645"}	2021-03-17 06:39:35.013+00
816	4	\N	{"lat":"15.16267","lng":"120.5565633"}	2021-03-17 06:39:35.94+00
817	7	\N	{"lat":"15.1626656","lng":"120.5565639"}	2021-03-17 06:39:36.198+00
820	5	\N	{"lat":"15.1626671","lng":"120.5565595"}	2021-03-17 06:39:38.004+00
821	3	\N	{"lat":"15.1626633","lng":"120.556562"}	2021-03-17 06:39:38.221+00
822	5	\N	{"lat":"15.1626671","lng":"120.5565595"}	2021-03-17 06:39:38.486+00
823	7	\N	{"lat":"15.1626651","lng":"120.5565643"}	2021-03-17 06:39:38.908+00
824	3	\N	{"lat":"15.1626633","lng":"120.556562"}	2021-03-17 06:39:39.575+00
825	4	\N	{"lat":"15.162668","lng":"120.5565634"}	2021-03-17 06:39:39.663+00
826	4	\N	{"lat":"15.162668","lng":"120.5565634"}	2021-03-17 06:39:39.984+00
827	5	\N	{"lat":"15.1626605","lng":"120.5565583"}	2021-03-17 06:39:41.168+00
828	3	\N	{"lat":"15.1626645","lng":"120.556561"}	2021-03-17 06:39:41.674+00
829	3	\N	{"lat":"15.1626645","lng":"120.556561"}	2021-03-17 06:39:42.263+00
830	6	\N	{"lat":"15.1626693","lng":"120.5565641"}	2021-03-17 06:39:43.43+00
832	3	\N	{"lat":"15.1626636","lng":"120.5565593"}	2021-03-17 06:39:44.49+00
833	7	\N	{"lat":"15.1626692","lng":"120.5565618"}	2021-03-17 06:39:45.185+00
834	7	\N	{"lat":"15.1626692","lng":"120.5565618"}	2021-03-17 06:39:46.407+00
835	5	\N	{"lat":"15.1626639","lng":"120.5565596"}	2021-03-17 06:39:47.176+00
836	4	\N	{"lat":"15.1626701","lng":"120.5565617"}	2021-03-17 06:39:48.925+00
837	7	\N	{"lat":"15.1626705","lng":"120.5565602"}	2021-03-17 06:39:48.978+00
838	7	\N	{"lat":"15.1626705","lng":"120.5565602"}	2021-03-17 06:39:49.603+00
839	4	\N	{"lat":"15.1626701","lng":"120.5565617"}	2021-03-17 06:39:50.751+00
853	5	\N	{"lat":"15.1626734","lng":"120.5565627"}	2021-03-17 06:40:01.013+00
854	3	\N	{"lat":"15.1626724","lng":"120.5565621"}	2021-03-17 06:40:02.61+00
859	7	\N	{"lat":"15.162671","lng":"120.5565597"}	2021-03-17 06:40:05.916+00
1658	4	23	{"lat":15.1438949,"lng":120.5594078}	2021-03-17 06:54:13.164+00
1659	4	23	{"lat":15.1440319,"lng":120.5594005}	2021-03-17 06:54:18.163+00
1660	4	23	{"lat":15.14416,"lng":120.5593707}	2021-03-17 06:54:21.965+00
1661	4	23	{"lat":15.1440657,"lng":120.5594625}	2021-03-17 06:54:26.927+00
1662	4	23	{"lat":15.144622,"lng":120.5594655}	2021-03-17 06:54:33.174+00
1663	4	23	{"lat":15.146235,"lng":120.5594603}	2021-03-17 06:54:38.15+00
1664	4	23	{"lat":15.1467612,"lng":120.5594366}	2021-03-17 06:54:43.156+00
1665	4	23	{"lat":15.1474356,"lng":120.5594947}	2021-03-17 06:54:48.167+00
1666	4	23	{"lat":15.1480953,"lng":120.559459}	2021-03-17 06:54:53.157+00
1667	4	23	{"lat":15.1486695,"lng":120.5594294}	2021-03-17 06:54:58.152+00
1668	4	23	{"lat":15.1493446,"lng":120.5593934}	2021-03-17 06:55:03.185+00
1669	4	23	{"lat":15.149894,"lng":120.5593954}	2021-03-17 06:55:08.157+00
1670	4	23	{"lat":15.1503103,"lng":120.5593353}	2021-03-17 06:55:13.149+00
1671	4	23	{"lat":15.1508224,"lng":120.5593399}	2021-03-17 06:55:18.162+00
1672	4	23	{"lat":15.1514147,"lng":120.5593827}	2021-03-17 06:55:23.127+00
1673	4	23	{"lat":15.1521114,"lng":120.5594096}	2021-03-17 06:55:28.141+00
1674	4	23	{"lat":15.1526626,"lng":120.5596037}	2021-03-17 06:55:33.17+00
1675	4	23	{"lat":15.1532221,"lng":120.5600416}	2021-03-17 06:55:38.163+00
1676	4	23	{"lat":15.1538173,"lng":120.5603742}	2021-03-17 06:55:43.172+00
1677	4	23	{"lat":15.1543586,"lng":120.5603788}	2021-03-17 06:55:48.15+00
1678	4	23	{"lat":15.15503,"lng":120.5603643}	2021-03-17 06:55:53.153+00
1679	4	23	{"lat":15.1557348,"lng":120.5602168}	2021-03-17 06:55:58.168+00
1680	4	23	{"lat":15.1564346,"lng":120.5600678}	2021-03-17 06:56:03.175+00
1681	4	23	{"lat":15.1571925,"lng":120.5599323}	2021-03-17 06:56:08.17+00
1682	4	23	{"lat":15.1577985,"lng":120.5597986}	2021-03-17 06:56:13.159+00
1683	4	23	{"lat":15.1582166,"lng":120.5595655}	2021-03-17 06:56:18.15+00
1684	4	23	{"lat":15.1583548,"lng":120.5591517}	2021-03-17 06:56:23.125+00
1685	4	23	{"lat":15.1584537,"lng":120.5587451}	2021-03-17 06:56:28.173+00
1686	4	23	{"lat":15.1585633,"lng":120.5586845}	2021-03-17 06:56:33.163+00
1687	4	23	{"lat":15.1590209,"lng":120.5585033}	2021-03-17 06:56:38.156+00
1688	4	23	{"lat":15.1597571,"lng":120.558283}	2021-03-17 06:56:43.15+00
1689	4	23	{"lat":15.1603961,"lng":120.5581253}	2021-03-17 06:56:48.109+00
1690	4	23	{"lat":15.1609332,"lng":120.5579596}	2021-03-17 06:56:53.147+00
1691	4	23	{"lat":15.1615593,"lng":120.557761}	2021-03-17 06:56:59.18+00
1692	4	23	{"lat":15.1619426,"lng":120.5576225}	2021-03-17 06:57:03.168+00
1693	4	23	{"lat":15.1622744,"lng":120.5574535}	2021-03-17 06:57:08.153+00
1694	4	23	{"lat":15.1626005,"lng":120.5572644}	2021-03-17 06:57:13.15+00
1695	4	23	{"lat":15.162859,"lng":120.5571687}	2021-03-17 06:57:18.135+00
1696	4	23	{"lat":15.1632056,"lng":120.5570281}	2021-03-17 06:57:24.155+00
1697	4	23	{"lat":15.1636179,"lng":120.5568237}	2021-03-17 06:57:29.155+00
776	5	\N	{"lat":"15.1626653","lng":"120.5565593"}	2021-03-17 06:39:08.771+00
784	5	\N	{"lat":"15.1626686","lng":"120.5565593"}	2021-03-17 06:39:14.387+00
785	3	\N	{"lat":"15.1626693","lng":"120.5565614"}	2021-03-17 06:39:15.203+00
786	3	\N	{"lat":"15.1626693","lng":"120.5565614"}	2021-03-17 06:39:15.797+00
787	5	\N	{"lat":"15.1626745","lng":"120.5565591"}	2021-03-17 06:39:16.849+00
788	7	\N	{"lat":"15.1626676","lng":"120.556562"}	2021-03-17 06:39:17.414+00
789	7	\N	{"lat":"15.1626676","lng":"120.556562"}	2021-03-17 06:39:18.475+00
790	4	\N	{"lat":"15.162665","lng":"120.5565598"}	2021-03-17 06:39:19.324+00
791	3	\N	{"lat":"15.1626643","lng":"120.5565608"}	2021-03-17 06:39:19.344+00
792	3	\N	{"lat":"15.1626643","lng":"120.5565608"}	2021-03-17 06:39:19.882+00
793	4	\N	{"lat":"15.162665","lng":"120.5565598"}	2021-03-17 06:39:20.701+00
794	3	\N	{"lat":"15.1626631","lng":"120.5565599"}	2021-03-17 06:39:22.146+00
795	7	\N	{"lat":"15.1626678","lng":"120.5565626"}	2021-03-17 06:39:22.658+00
796	4	\N	{"lat":"15.1626674","lng":"120.5565624"}	2021-03-17 06:39:24.658+00
799	4	\N	{"lat":"15.1626674","lng":"120.5565624"}	2021-03-17 06:39:26.068+00
808	7	\N	{"lat":"15.1626685","lng":"120.556562"}	2021-03-17 06:39:32.365+00
818	7	\N	{"lat":"15.1626656","lng":"120.5565639"}	2021-03-17 06:39:37.33+00
819	3	\N	{"lat":"15.1626633","lng":"120.556562"}	2021-03-17 06:39:37.744+00
831	4	\N	{"lat":"15.1626671","lng":"120.5565617"}	2021-03-17 06:39:43.966+00
840	5	\N	{"lat":"15.1626666","lng":"120.5565589"}	2021-03-17 06:39:51.46+00
841	7	\N	{"lat":"15.1626726","lng":"120.5565569"}	2021-03-17 06:39:51.86+00
842	5	\N	{"lat":"15.1626666","lng":"120.5565589"}	2021-03-17 06:39:52.343+00
843	4	\N	{"lat":"15.1626712","lng":"120.5565635"}	2021-03-17 06:39:52.835+00
844	3	\N	{"lat":"15.1626699","lng":"120.5565607"}	2021-03-17 06:39:55.345+00
845	3	\N	{"lat":"15.1626699","lng":"120.5565607"}	2021-03-17 06:39:55.652+00
846	3	\N	{"lat":"15.1626699","lng":"120.5565607"}	2021-03-17 06:39:57.068+00
847	5	\N	{"lat":"15.1626785","lng":"120.5565597"}	2021-03-17 06:39:58.015+00
848	4	\N	{"lat":"15.1626685","lng":"120.5565634"}	2021-03-17 06:39:58.716+00
849	4	\N	{"lat":"15.1626685","lng":"120.5565634"}	2021-03-17 06:39:58.951+00
850	4	\N	{"lat":"15.1626685","lng":"120.5565634"}	2021-03-17 06:40:00.014+00
851	7	\N	{"lat":"15.1626681","lng":"120.5565617"}	2021-03-17 06:40:00.475+00
852	3	\N	{"lat":"15.1626724","lng":"120.5565621"}	2021-03-17 06:40:00.732+00
855	4	\N	{"lat":"15.162666","lng":"120.5565604"}	2021-03-17 06:40:02.917+00
856	4	\N	{"lat":"15.162666","lng":"120.5565604"}	2021-03-17 06:40:03.051+00
857	4	\N	{"lat":"15.162666","lng":"120.5565604"}	2021-03-17 06:40:04.067+00
858	3	\N	{"lat":"15.1626727","lng":"120.5565624"}	2021-03-17 06:40:05.542+00
860	5	\N	{"lat":"15.1626665","lng":"120.5565605"}	2021-03-17 06:40:06.03+00
861	7	\N	{"lat":"15.162671","lng":"120.5565597"}	2021-03-17 06:40:06.271+00
862	3	\N	{"lat":"15.1626727","lng":"120.5565624"}	2021-03-17 06:40:06.649+00
863	4	\N	{"lat":"15.1626671","lng":"120.5565614"}	2021-03-17 06:40:08.058+00
864	4	\N	{"lat":"15.1626671","lng":"120.5565614"}	2021-03-17 06:40:08.129+00
865	7	\N	{"lat":"15.162671","lng":"120.5565597"}	2021-03-17 06:40:08.749+00
866	4	\N	{"lat":"15.1626671","lng":"120.5565614"}	2021-03-17 06:40:09.564+00
867	7	\N	{"lat":"15.162671","lng":"120.5565597"}	2021-03-17 06:40:09.676+00
868	3	\N	{"lat":"15.1626686","lng":"120.5565623"}	2021-03-17 06:40:10.502+00
869	7	\N	{"lat":"15.1626708","lng":"120.5565595"}	2021-03-17 06:40:12.537+00
870	6	\N	{"lat":"15.1626674","lng":"120.5565605"}	2021-03-17 06:40:13.347+00
871	3	\N	{"lat":"15.1626649","lng":"120.5565616"}	2021-03-17 06:40:13.52+00
872	4	\N	{"lat":"15.1626685","lng":"120.5565661"}	2021-03-17 06:40:13.739+00
873	3	\N	{"lat":"15.1626649","lng":"120.5565616"}	2021-03-17 06:40:13.812+00
874	7	\N	{"lat":"15.1626708","lng":"120.5565595"}	2021-03-17 06:40:13.98+00
875	4	\N	{"lat":"15.1626685","lng":"120.5565661"}	2021-03-17 06:40:14.53+00
876	5	\N	{"lat":"15.1626626","lng":"120.5565582"}	2021-03-17 06:40:14.953+00
877	3	\N	{"lat":"15.1626647","lng":"120.556562"}	2021-03-17 06:40:18.301+00
878	7	\N	{"lat":"15.1626715","lng":"120.5565607"}	2021-03-17 06:40:18.724+00
879	3	\N	{"lat":"15.1626647","lng":"120.556562"}	2021-03-17 06:40:19.553+00
880	7	\N	{"lat":"15.1626715","lng":"120.5565607"}	2021-03-17 06:40:20.258+00
881	4	\N	{"lat":"15.1626669","lng":"120.5565589"}	2021-03-17 06:40:20.318+00
882	7	\N	{"lat":"15.1626687","lng":"120.556562"}	2021-03-17 06:40:22.68+00
883	7	\N	{"lat":"15.1626687","lng":"120.556562"}	2021-03-17 06:40:23.022+00
884	3	\N	{"lat":"15.1626627","lng":"120.5565613"}	2021-03-17 06:40:23.414+00
885	5	\N	{"lat":"15.1626662","lng":"120.5565594"}	2021-03-17 06:40:23.439+00
886	5	\N	{"lat":"15.1626662","lng":"120.5565594"}	2021-03-17 06:40:23.698+00
887	3	\N	{"lat":"15.1626627","lng":"120.5565613"}	2021-03-17 06:40:23.907+00
888	3	\N	{"lat":"15.1626602","lng":"120.5565591"}	2021-03-17 06:40:25.182+00
889	7	\N	{"lat":"15.1626659","lng":"120.5565657"}	2021-03-17 06:40:26.058+00
890	3	\N	{"lat":"15.1626602","lng":"120.5565591"}	2021-03-17 06:40:26.068+00
891	4	\N	{"lat":"15.1626679","lng":"120.556561"}	2021-03-17 06:40:26.581+00
892	7	\N	{"lat":"15.1626659","lng":"120.5565657"}	2021-03-17 06:40:27.556+00
893	4	\N	{"lat":"15.1626679","lng":"120.556561"}	2021-03-17 06:40:27.691+00
894	5	\N	{"lat":"15.1626652","lng":"120.5565604"}	2021-03-17 06:40:28.417+00
895	4	\N	{"lat":"15.162665","lng":"120.5565628"}	2021-03-17 06:40:31.657+00
896	4	\N	{"lat":"15.162665","lng":"120.5565628"}	2021-03-17 06:40:32.078+00
897	3	\N	{"lat":"15.1626666","lng":"120.556565"}	2021-03-17 06:40:33.276+00
898	3	\N	{"lat":"15.1626666","lng":"120.556565"}	2021-03-17 06:40:33.81+00
899	5	\N	{"lat":"15.1626689","lng":"120.556561"}	2021-03-17 06:40:34.075+00
900	3	\N	{"lat":"15.1626666","lng":"120.556565"}	2021-03-17 06:40:35.122+00
901	4	\N	{"lat":"15.162665","lng":"120.5565581"}	2021-03-17 06:40:36.196+00
902	3	\N	{"lat":"15.1626675","lng":"120.5565643"}	2021-03-17 06:40:37.371+00
903	3	\N	{"lat":"15.1626675","lng":"120.5565643"}	2021-03-17 06:40:37.986+00
904	3	\N	{"lat":"15.1626675","lng":"120.5565643"}	2021-03-17 06:40:39.29+00
905	5	\N	{"lat":"15.1626626","lng":"120.5565603"}	2021-03-17 06:40:40.626+00
906	4	\N	{"lat":"15.1626655","lng":"120.5565587"}	2021-03-17 06:40:41.16+00
907	3	\N	{"lat":"15.1626668","lng":"120.5565641"}	2021-03-17 06:40:41.417+00
908	3	\N	{"lat":"15.1626668","lng":"120.5565641"}	2021-03-17 06:40:41.781+00
909	3	\N	{"lat":"15.1626668","lng":"120.5565641"}	2021-03-17 06:40:43.208+00
910	6	\N	{"lat":"15.1626618","lng":"120.5565626"}	2021-03-17 06:40:43.767+00
911	3	\N	{"lat":"15.1626625","lng":"120.5565617"}	2021-03-17 06:40:45.538+00
912	5	\N	{"lat":"15.1626611","lng":"120.5565587"}	2021-03-17 06:40:45.625+00
913	3	\N	{"lat":"15.1626625","lng":"120.5565617"}	2021-03-17 06:40:45.911+00
914	4	\N	{"lat":"15.1626658","lng":"120.5565599"}	2021-03-17 06:40:46.401+00
915	4	\N	{"lat":"15.1626658","lng":"120.5565599"}	2021-03-17 06:40:46.65+00
917	3	\N	{"lat":"15.1626585","lng":"120.5565586"}	2021-03-17 06:40:48.524+00
918	5	\N	{"lat":"15.1626609","lng":"120.5565603"}	2021-03-17 06:40:49.94+00
921	3	\N	{"lat":"15.1626576","lng":"120.5565579"}	2021-03-17 06:40:52.386+00
922	3	\N	{"lat":"15.1626576","lng":"120.5565579"}	2021-03-17 06:40:53.108+00
925	4	\N	{"lat":"15.162668","lng":"120.5565599"}	2021-03-17 06:40:55.911+00
946	3	\N	{"lat":"15.1626659","lng":"120.5565626"}	2021-03-17 06:41:19.516+00
948	6	\N	{"lat":"15.1626725","lng":"120.556563"}	2021-03-17 06:41:20.421+00
954	5	\N	{"lat":"15.1626636","lng":"120.5565599"}	2021-03-17 06:41:28.708+00
955	5	\N	{"lat":"15.1626636","lng":"120.5565599"}	2021-03-17 06:41:29.568+00
956	5	\N	{"lat":"15.1626636","lng":"120.5565599"}	2021-03-17 06:41:30.512+00
965	6	\N	{"lat":"15.1626693","lng":"120.5565638"}	2021-03-17 06:41:46.399+00
966	6	\N	{"lat":"15.1626681","lng":"120.5565649"}	2021-03-17 06:41:48.596+00
967	5	\N	{"lat":"15.1626663","lng":"120.5565592"}	2021-03-17 06:41:52.866+00
1698	4	23	{"lat":15.1638971,"lng":120.5566776}	2021-03-17 06:57:33.163+00
1699	4	23	{"lat":15.1639459,"lng":120.5566846}	2021-03-17 06:57:39.155+00
1700	4	23	{"lat":15.1641572,"lng":120.5568584}	2021-03-17 06:57:43.152+00
1701	4	23	{"lat":15.1644483,"lng":120.5573964}	2021-03-17 06:57:48.161+00
1702	4	23	{"lat":15.1647464,"lng":120.5579163}	2021-03-17 06:57:53.164+00
1703	4	23	{"lat":15.1649911,"lng":120.5584327}	2021-03-17 06:57:58.161+00
1704	4	23	{"lat":15.1651301,"lng":120.5587418}	2021-03-17 06:58:03.152+00
1705	4	23	{"lat":15.1652178,"lng":120.558952}	2021-03-17 06:58:08.168+00
1706	4	23	{"lat":15.1653595,"lng":120.5592511}	2021-03-17 06:58:13.15+00
1707	4	23	{"lat":15.1654408,"lng":120.5594177}	2021-03-17 06:58:18.188+00
1708	4	23	{"lat":15.1654557,"lng":120.5594564}	2021-03-17 06:58:23.151+00
1709	4	23	{"lat":15.165595,"lng":120.5597992}	2021-03-17 06:58:28.179+00
1710	4	23	{"lat":15.1658433,"lng":120.560287}	2021-03-17 06:58:33.14+00
1711	4	23	{"lat":15.1660207,"lng":120.5606508}	2021-03-17 06:58:38.173+00
1712	4	23	{"lat":15.166114,"lng":120.5610875}	2021-03-17 06:58:43.156+00
1713	4	23	{"lat":15.1662764,"lng":120.5615211}	2021-03-17 06:58:48.157+00
1714	4	23	{"lat":15.1663404,"lng":120.5619263}	2021-03-17 06:58:53.152+00
1715	4	23	{"lat":15.1664011,"lng":120.562499}	2021-03-17 06:58:58.167+00
1716	4	23	{"lat":15.1664219,"lng":120.5627426}	2021-03-17 06:59:03.161+00
1717	4	23	{"lat":15.1664255,"lng":120.562969}	2021-03-17 06:59:08.167+00
1718	4	23	{"lat":15.1664259,"lng":120.5630372}	2021-03-17 06:59:13.166+00
1719	4	23	{"lat":15.1664709,"lng":120.5634359}	2021-03-17 06:59:18.17+00
1720	4	23	{"lat":15.1665753,"lng":120.5643258}	2021-03-17 06:59:23.152+00
1721	4	23	{"lat":15.1666378,"lng":120.5647141}	2021-03-17 06:59:28.169+00
1722	4	23	{"lat":15.1666438,"lng":120.5648643}	2021-03-17 06:59:33.175+00
1723	4	23	{"lat":15.1666144,"lng":120.5647857}	2021-03-17 06:59:38.455+00
1724	4	23	{"lat":15.1667504,"lng":120.5648872}	2021-03-17 06:59:43.156+00
1725	4	23	{"lat":15.1670274,"lng":120.5651073}	2021-03-17 06:59:48.15+00
1726	4	23	{"lat":15.1672518,"lng":120.5655076}	2021-03-17 06:59:53.168+00
1727	4	23	{"lat":15.1672729,"lng":120.5660321}	2021-03-17 06:59:58.154+00
1728	4	23	{"lat":15.1671678,"lng":120.5668292}	2021-03-17 07:00:03.148+00
1729	4	23	{"lat":15.1670038,"lng":120.5677127}	2021-03-17 07:00:08.143+00
1730	4	23	{"lat":15.1668569,"lng":120.5685205}	2021-03-17 07:00:13.145+00
1731	4	23	{"lat":15.1667053,"lng":120.5695697}	2021-03-17 07:00:18.147+00
1732	4	23	{"lat":15.1666089,"lng":120.5701547}	2021-03-17 07:00:23.156+00
1733	4	23	{"lat":15.1665193,"lng":120.5707741}	2021-03-17 07:00:28.166+00
1734	4	23	{"lat":15.166473,"lng":120.5713738}	2021-03-17 07:00:33.168+00
1735	4	23	{"lat":15.1663893,"lng":120.5720031}	2021-03-17 07:00:38.144+00
1736	4	23	{"lat":15.1661058,"lng":120.5734357}	2021-03-17 07:00:45.161+00
1737	4	23	{"lat":15.1660124,"lng":120.5739348}	2021-03-17 07:00:50.146+00
1738	4	23	{"lat":15.1659281,"lng":120.5746769}	2021-03-17 07:00:55.135+00
1739	4	23	{"lat":15.1657755,"lng":120.575462}	2021-03-17 07:01:01.177+00
1740	4	23	{"lat":15.1657677,"lng":120.5760023}	2021-03-17 07:01:06.156+00
1741	4	23	{"lat":15.1657686,"lng":120.5763194}	2021-03-17 07:01:10.144+00
1742	4	23	{"lat":15.1658835,"lng":120.5770853}	2021-03-17 07:01:16.161+00
1743	4	23	{"lat":15.1660028,"lng":120.5778439}	2021-03-17 07:01:21.123+00
1744	4	23	{"lat":15.1661949,"lng":120.5786355}	2021-03-17 07:01:26.157+00
1745	4	23	{"lat":15.1663275,"lng":120.5792322}	2021-03-17 07:01:30.144+00
1746	4	23	{"lat":15.1664975,"lng":120.5799608}	2021-03-17 07:01:35.154+00
1747	4	23	{"lat":15.1666293,"lng":120.580613}	2021-03-17 07:01:40.15+00
1748	4	23	{"lat":15.1667418,"lng":120.5808086}	2021-03-17 07:01:45.179+00
1749	4	23	{"lat":15.1667855,"lng":120.5806159}	2021-03-17 07:01:50.159+00
1750	4	23	{"lat":15.1666695,"lng":120.5800589}	2021-03-17 07:01:55.17+00
1751	4	23	{"lat":15.1665038,"lng":120.5793659}	2021-03-17 07:02:00.168+00
1752	4	23	{"lat":15.1665095,"lng":120.5790691}	2021-03-17 07:02:05.177+00
1753	4	23	{"lat":15.1665735,"lng":120.5791614}	2021-03-17 07:02:10.177+00
1754	4	23	{"lat":15.1667166,"lng":120.5794985}	2021-03-17 07:02:16.162+00
1755	4	23	{"lat":15.1667803,"lng":120.5799612}	2021-03-17 07:02:20.151+00
1756	4	23	{"lat":15.1668471,"lng":120.580314}	2021-03-17 07:02:25.164+00
1757	4	23	{"lat":15.1668722,"lng":120.5804522}	2021-03-17 07:02:30.154+00
1758	4	23	{"lat":15.1669449,"lng":120.5804413}	2021-03-17 07:02:34.929+00
1759	4	23	{"lat":15.1670188,"lng":120.5804628}	2021-03-17 07:02:39.044+00
1760	4	23	{"lat":15.1670318,"lng":120.5804059}	2021-03-17 07:02:45.415+00
1761	4	23	{"lat":15.1671973,"lng":120.580297}	2021-03-17 07:02:50.189+00
1762	4	23	{"lat":15.1673119,"lng":120.5801697}	2021-03-17 07:02:53.849+00
1763	4	23	{"lat":15.1673794,"lng":120.5799583}	2021-03-17 07:02:58.887+00
1943	2	7	{"lat":15.1386125,"lng":120.5627634}	2021-03-17 06:48:08.205+00
1944	2	7	{"lat":15.1386125,"lng":120.5627634}	2021-03-17 06:48:08.572+00
1945	2	7	{"lat":15.1385916,"lng":120.5627712}	2021-03-17 06:48:18.201+00
1946	2	7	{"lat":15.1385916,"lng":120.5627712}	2021-03-17 06:48:18.582+00
1947	2	7	{"lat":15.1386041,"lng":120.5627581}	2021-03-17 06:48:28.157+00
1948	2	7	{"lat":15.1386041,"lng":120.5627581}	2021-03-17 06:48:28.57+00
1949	2	7	{"lat":15.1385836,"lng":120.5627816}	2021-03-17 06:48:34.19+00
1950	2	7	{"lat":15.1385881,"lng":120.5627345}	2021-03-17 06:48:43.232+00
916	4	\N	{"lat":"15.1626658","lng":"120.5565599"}	2021-03-17 06:40:47.618+00
923	3	\N	{"lat":"15.1626576","lng":"120.5565579"}	2021-03-17 06:40:54.23+00
926	3	\N	{"lat":"15.1626623","lng":"120.5565628"}	2021-03-17 06:40:56.142+00
927	3	\N	{"lat":"15.1626623","lng":"120.5565628"}	2021-03-17 06:40:56.62+00
933	4	\N	{"lat":"15.1626664","lng":"120.5565604"}	2021-03-17 06:41:02.474+00
934	3	\N	{"lat":"15.1626634","lng":"120.5565634"}	2021-03-17 06:41:03.234+00
936	3	\N	{"lat":"15.1626699","lng":"120.5565629"}	2021-03-17 06:41:09.044+00
937	3	\N	{"lat":"15.1626699","lng":"120.5565629"}	2021-03-17 06:41:10.279+00
938	5	\N	{"lat":"15.1626668","lng":"120.5565569"}	2021-03-17 06:41:11.609+00
939	5	\N	{"lat":"15.1626668","lng":"120.5565569"}	2021-03-17 06:41:12.091+00
940	3	\N	{"lat":"15.162667","lng":"120.5565626"}	2021-03-17 06:41:12.467+00
941	5	\N	{"lat":"15.1626668","lng":"120.5565569"}	2021-03-17 06:41:13.031+00
942	3	\N	{"lat":"15.162667","lng":"120.5565626"}	2021-03-17 06:41:13.157+00
943	6	\N	{"lat":"15.1626684","lng":"120.5565652"}	2021-03-17 06:41:13.518+00
944	3	\N	{"lat":"15.1626668","lng":"120.556563"}	2021-03-17 06:41:15.448+00
947	6	\N	{"lat":"15.1626725","lng":"120.556563"}	2021-03-17 06:41:19.598+00
957	3	\N	{"lat":"15.1626646","lng":"120.5565633"}	2021-03-17 06:41:35.762+00
958	3	\N	{"lat":"15.1626646","lng":"120.5565633"}	2021-03-17 06:41:36.107+00
959	5	\N	{"lat":"15.1626623","lng":"120.5565594"}	2021-03-17 06:41:36.137+00
960	5	\N	{"lat":"15.1626623","lng":"120.5565594"}	2021-03-17 06:41:36.269+00
964	6	\N	{"lat":"15.1626693","lng":"120.5565638"}	2021-03-17 06:41:45.074+00
969	5	\N	{"lat":"15.1626663","lng":"120.5565592"}	2021-03-17 06:41:53.98+00
1764	3	\N	{"lat":"15.1625633","lng":"120.5565017"}	2021-03-17 07:03:15.783+00
1951	2	7	{"lat":15.1385881,"lng":120.5627345}	2021-03-17 06:48:43.539+00
1952	2	7	{"lat":15.1386167,"lng":120.5627538}	2021-03-17 06:48:53.123+00
1953	2	7	{"lat":15.1386167,"lng":120.5627538}	2021-03-17 06:48:53.524+00
1954	2	7	{"lat":15.1386074,"lng":120.5627578}	2021-03-17 06:49:03.169+00
1955	2	7	{"lat":15.1386074,"lng":120.5627578}	2021-03-17 06:49:03.565+00
1956	2	7	{"lat":15.1386291,"lng":120.5627558}	2021-03-17 06:49:13.195+00
1957	2	7	{"lat":15.1386291,"lng":120.5627558}	2021-03-17 06:49:13.532+00
1958	2	7	{"lat":15.1386454,"lng":120.5627632}	2021-03-17 06:49:18.633+00
1959	2	7	{"lat":15.1386333,"lng":120.5627853}	2021-03-17 06:49:23.572+00
1960	2	7	{"lat":15.1386289,"lng":120.5627645}	2021-03-17 06:49:28.569+00
1961	2	7	{"lat":15.138634,"lng":120.5627612}	2021-03-17 06:49:33.527+00
1962	2	7	{"lat":15.1386354,"lng":120.5627621}	2021-03-17 06:49:38.535+00
1963	2	7	{"lat":15.1386354,"lng":120.5627621}	2021-03-17 06:49:43.573+00
1964	2	7	{"lat":15.1386354,"lng":120.5627621}	2021-03-17 06:49:48.536+00
1965	2	7	{"lat":15.1386507,"lng":120.5627628}	2021-03-17 06:49:53.545+00
1966	2	7	{"lat":15.1386844,"lng":120.5627672}	2021-03-17 06:49:58.59+00
1967	2	7	{"lat":15.1387236,"lng":120.5627844}	2021-03-17 06:50:03.548+00
1968	2	7	{"lat":15.1387509,"lng":120.5627924}	2021-03-17 06:50:08.529+00
1969	2	7	{"lat":15.1387604,"lng":120.5627944}	2021-03-17 06:50:14.053+00
1970	2	7	{"lat":15.1387846,"lng":120.5627983}	2021-03-17 06:50:20.326+00
1971	2	7	{"lat":15.1387863,"lng":120.5627917}	2021-03-17 06:50:23.648+00
1972	2	7	{"lat":15.1388205,"lng":120.562703}	2021-03-17 06:50:31.6+00
1973	2	7	{"lat":15.1388338,"lng":120.5626709}	2021-03-17 06:50:33.654+00
1974	2	7	{"lat":15.1387563,"lng":120.562795}	2021-03-17 06:50:38.578+00
1975	2	7	{"lat":15.1387348,"lng":120.5627764}	2021-03-17 06:50:43.577+00
1976	2	7	{"lat":15.1387314,"lng":120.5627679}	2021-03-17 06:50:48.568+00
1977	2	7	{"lat":15.1387356,"lng":120.5627711}	2021-03-17 06:50:53.528+00
1978	2	7	{"lat":15.1387361,"lng":120.5627738}	2021-03-17 06:50:58.531+00
1979	2	7	{"lat":15.1387361,"lng":120.5627738}	2021-03-17 06:51:03.531+00
1980	2	7	{"lat":15.1387361,"lng":120.5627738}	2021-03-17 06:51:24.287+00
1981	2	7	{"lat":15.1387361,"lng":120.5627738}	2021-03-17 06:51:34.09+00
1982	2	7	{"lat":15.1387361,"lng":120.5627738}	2021-03-17 06:51:41.498+00
1983	2	7	{"lat":15.1387361,"lng":120.5627738}	2021-03-17 06:51:58.03+00
1984	2	7	{"lat":15.1388383,"lng":120.5628979}	2021-03-17 06:52:03.02+00
1985	2	7	{"lat":15.1388481,"lng":120.5627127}	2021-03-17 06:52:11.041+00
1986	2	7	{"lat":15.1388583,"lng":120.5627138}	2021-03-17 06:52:13.912+00
1987	2	7	{"lat":15.1388772,"lng":120.5627138}	2021-03-17 06:52:18.229+00
1988	2	7	{"lat":15.1388782,"lng":120.5627715}	2021-03-17 06:52:24.585+00
1989	2	7	{"lat":15.1388826,"lng":120.5628009}	2021-03-17 06:52:28.024+00
1990	2	7	{"lat":15.1388731,"lng":120.5627845}	2021-03-17 06:52:33.016+00
1991	2	7	{"lat":15.1388635,"lng":120.5627725}	2021-03-17 06:52:38.025+00
1992	2	7	{"lat":15.1388554,"lng":120.5627467}	2021-03-17 06:52:43.033+00
1993	2	7	{"lat":15.1388555,"lng":120.562746}	2021-03-17 06:52:48.044+00
1994	2	7	{"lat":15.1388555,"lng":120.562746}	2021-03-17 06:52:53.023+00
1995	2	7	{"lat":15.1388555,"lng":120.562746}	2021-03-17 06:52:58.022+00
1996	2	7	{"lat":15.1388555,"lng":120.562746}	2021-03-17 06:53:03.053+00
1997	2	7	{"lat":15.1388359,"lng":120.562812}	2021-03-17 06:53:10.067+00
1998	2	7	{"lat":15.1388359,"lng":120.562812}	2021-03-17 06:53:13.014+00
1999	2	7	{"lat":15.1388359,"lng":120.562812}	2021-03-17 06:53:18.057+00
2000	2	7	{"lat":15.1388359,"lng":120.562812}	2021-03-17 06:53:23.058+00
2001	2	7	{"lat":15.1388359,"lng":120.562812}	2021-03-17 06:53:50.628+00
2002	2	7	{"lat":15.1388359,"lng":120.562812}	2021-03-17 06:54:13.115+00
2003	2	7	{"lat":15.1388359,"lng":120.562812}	2021-03-17 06:54:26.35+00
2004	2	7	{"lat":15.1388359,"lng":120.562812}	2021-03-17 06:54:45.617+00
2005	2	7	{"lat":15.1388359,"lng":120.562812}	2021-03-17 06:55:02.315+00
2006	2	7	{"lat":15.1388359,"lng":120.562812}	2021-03-17 06:55:07.275+00
2007	2	7	{"lat":15.1446056,"lng":120.5613556}	2021-03-17 06:55:15.292+00
2008	2	7	{"lat":15.1446056,"lng":120.5613556}	2021-03-17 06:55:22.309+00
2009	2	7	{"lat":15.1446331,"lng":120.5613862}	2021-03-17 06:55:27.288+00
2010	2	7	{"lat":15.1446346,"lng":120.5613841}	2021-03-17 06:55:32.282+00
2011	2	7	{"lat":15.1446129,"lng":120.5613533}	2021-03-17 06:55:37.316+00
2012	2	7	{"lat":15.1446141,"lng":120.5613553}	2021-03-17 06:55:42.294+00
2013	2	7	{"lat":15.1446141,"lng":120.5613553}	2021-03-17 06:55:47.288+00
2014	2	7	{"lat":15.1446141,"lng":120.5613553}	2021-03-17 06:55:52.294+00
2015	2	7	{"lat":15.1446141,"lng":120.5613553}	2021-03-17 06:55:57.306+00
2016	2	7	{"lat":15.1445797,"lng":120.5612859}	2021-03-17 06:56:02.293+00
2017	2	7	{"lat":15.1445797,"lng":120.5612859}	2021-03-17 06:56:07.302+00
919	3	\N	{"lat":"15.1626585","lng":"120.5565586"}	2021-03-17 06:40:50.684+00
920	5	\N	{"lat":"15.1626609","lng":"120.5565603"}	2021-03-17 06:40:51.583+00
924	4	\N	{"lat":"15.162668","lng":"120.5565599"}	2021-03-17 06:40:54.413+00
928	7	\N	{"lat":"15.1626697","lng":"120.5565655"}	2021-03-17 06:40:58.024+00
929	3	\N	{"lat":"15.1626659","lng":"120.5565615"}	2021-03-17 06:40:59.94+00
930	4	\N	{"lat":"15.1626664","lng":"120.5565604"}	2021-03-17 06:41:00.443+00
931	3	\N	{"lat":"15.1626659","lng":"120.5565615"}	2021-03-17 06:41:00.575+00
932	4	\N	{"lat":"15.1626664","lng":"120.5565604"}	2021-03-17 06:41:00.693+00
935	3	\N	{"lat":"15.1626699","lng":"120.5565629"}	2021-03-17 06:41:08.165+00
945	3	\N	{"lat":"15.1626659","lng":"120.5565626"}	2021-03-17 06:41:19.172+00
949	3	\N	{"lat":"15.1626687","lng":"120.5565636"}	2021-03-17 06:41:22.411+00
950	3	\N	{"lat":"15.1626687","lng":"120.5565636"}	2021-03-17 06:41:23.673+00
951	5	\N	{"lat":"15.1626666","lng":"120.5565598"}	2021-03-17 06:41:24.347+00
952	5	\N	{"lat":"15.1626666","lng":"120.5565598"}	2021-03-17 06:41:25.556+00
953	5	\N	{"lat":"15.1626636","lng":"120.5565599"}	2021-03-17 06:41:28.597+00
961	5	\N	{"lat":"15.1626717","lng":"120.5565596"}	2021-03-17 06:41:39.838+00
962	3	\N	{"lat":"15.1626689","lng":"120.5565614"}	2021-03-17 06:41:43.026+00
963	3	\N	{"lat":"15.1626689","lng":"120.5565614"}	2021-03-17 06:41:44.515+00
968	5	\N	{"lat":"15.1626663","lng":"120.5565592"}	2021-03-17 06:41:53.095+00
970	5	\N	{"lat":"15.1626632","lng":"120.5565599"}	2021-03-17 06:42:03.797+00
971	5	\N	{"lat":"15.1626632","lng":"120.5565599"}	2021-03-17 06:42:04.983+00
972	5	\N	{"lat":"15.1626618","lng":"120.5565601"}	2021-03-17 06:42:07.462+00
973	7	\N	{"lat":"15.1626697","lng":"120.5565597"}	2021-03-17 06:42:12.461+00
974	3	\N	{"lat":"15.1626661","lng":"120.5565611"}	2021-03-17 06:42:15.435+00
975	6	\N	{"lat":"15.1626629","lng":"120.5565624"}	2021-03-17 06:42:15.651+00
976	6	\N	{"lat":"15.1626629","lng":"120.5565624"}	2021-03-17 06:42:15.935+00
977	5	\N	{"lat":"15.162658","lng":"120.5565596"}	2021-03-17 06:42:17.183+00
978	5	\N	{"lat":"15.162658","lng":"120.5565596"}	2021-03-17 06:42:18.909+00
979	5	\N	{"lat":"15.1626634","lng":"120.5565596"}	2021-03-17 06:42:22.188+00
980	5	\N	{"lat":"15.1626634","lng":"120.5565596"}	2021-03-17 06:42:23.328+00
981	7	\N	{"lat":"15.1626709","lng":"120.5565603"}	2021-03-17 06:42:42.489+00
982	3	\N	{"lat":"15.1626682","lng":"120.5565618"}	2021-03-17 06:42:45.472+00
983	6	\N	{"lat":"15.1626658","lng":"120.5565624"}	2021-03-17 06:42:48.102+00
984	6	\N	{"lat":"15.1626677","lng":"120.556564"}	2021-03-17 06:42:54.176+00
985	6	\N	{"lat":"15.1626677","lng":"120.556564"}	2021-03-17 06:42:55.603+00
986	6	\N	{"lat":"15.1626674","lng":"120.5565632"}	2021-03-17 06:42:57.845+00
987	7	\N	{"lat":"15.1626668","lng":"120.556561"}	2021-03-17 06:43:12.764+00
988	3	\N	{"lat":"15.162666","lng":"120.5565598"}	2021-03-17 06:43:15.507+00
989	7	\N	{"lat":"15.1626677","lng":"120.55656"}	2021-03-17 06:43:40.094+00
990	3	\N	{"lat":"15.1626641","lng":"120.5565607"}	2021-03-17 06:43:44.856+00
991	3	\N	{"lat":"15.1626686","lng":"120.5565602"}	2021-03-17 06:45:13.691+00
992	3	\N	{"lat":"15.1626656","lng":"120.5565609"}	2021-03-17 06:45:30.1+00
993	3	\N	{"lat":"15.1626692","lng":"120.5565581"}	2021-03-17 06:47:08.872+00
994	3	\N	{"lat":"15.159516","lng":"120.5584636"}	2021-03-17 06:47:39.718+00
995	3	\N	{"lat":"15.1591706","lng":"120.5585112"}	2021-03-17 06:50:33.065+00
996	3	\N	{"lat":"15.1591706","lng":"120.5585112"}	2021-03-17 06:50:41.467+00
997	7	\N	{"lat":"15.1392484","lng":"120.5626272"}	2021-03-17 06:52:20.013+00
998	3	\N	{"lat":"15.1591706","lng":"120.5585112"}	2021-03-17 06:52:43.729+00
999	3	\N	{"lat":"15.1388386","lng":"120.5630124"}	2021-03-17 06:53:01.382+00
1000	3	\N	{"lat":"15.1386785","lng":"120.5627646"}	2021-03-17 06:53:30.22+00
1001	3	\N	{"lat":"15.1386161","lng":"120.5627395"}	2021-03-17 06:54:00.719+00
1002	3	\N	{"lat":"15.1386622","lng":"120.5627676"}	2021-03-17 06:54:30.645+00
1003	3	\N	{"lat":"15.1386329","lng":"120.5627758"}	2021-03-17 06:55:00.651+00
1004	3	\N	{"lat":"15.1387511","lng":"120.5627845"}	2021-03-17 06:55:30.635+00
1005	3	\N	{"lat":"15.1387259","lng":"120.562897"}	2021-03-17 06:56:05.914+00
1006	3	\N	{"lat":"15.1387233","lng":"120.5628973"}	2021-03-17 06:56:30.035+00
1007	3	\N	{"lat":"15.1387233","lng":"120.5628973"}	2021-03-17 06:57:00.039+00
1008	3	\N	{"lat":"15.1427892","lng":"120.5603374"}	2021-03-17 06:57:30.08+00
1009	3	\N	{"lat":"15.1475499","lng":"120.5594111"}	2021-03-17 06:58:00.687+00
1010	6	29	{"lat":15.162663,"lng":120.5565604}	2021-03-17 06:43:28.734+00
1011	6	29	{"lat":15.1626702,"lng":120.5565605}	2021-03-17 06:43:36.966+00
1012	6	29	{"lat":15.1626702,"lng":120.5565605}	2021-03-17 06:43:38.628+00
1013	6	29	{"lat":15.1626639,"lng":120.5565641}	2021-03-17 06:43:45.312+00
1014	6	29	{"lat":15.1626661,"lng":120.5565637}	2021-03-17 06:43:50.642+00
1015	6	29	{"lat":15.162668,"lng":120.5565639}	2021-03-17 06:43:55.643+00
1016	6	29	{"lat":15.1626752,"lng":120.5565664}	2021-03-17 06:44:00.528+00
1017	6	29	{"lat":15.1626732,"lng":120.5565636}	2021-03-17 06:44:05.182+00
1018	6	29	{"lat":15.1626777,"lng":120.5565611}	2021-03-17 06:44:35.592+00
1019	6	29	{"lat":15.1626737,"lng":120.5565591}	2021-03-17 06:44:40.737+00
1020	6	29	{"lat":15.1626715,"lng":120.5565586}	2021-03-17 06:44:45.668+00
1021	6	29	{"lat":15.1626774,"lng":120.5565627}	2021-03-17 06:45:05.687+00
1022	6	29	{"lat":15.1626755,"lng":120.5565618}	2021-03-17 06:45:20.767+00
1023	6	29	{"lat":15.1626803,"lng":120.5565617}	2021-03-17 06:45:30.591+00
1024	6	29	{"lat":15.1625777,"lng":120.5562661}	2021-03-17 06:45:47.137+00
1025	6	29	{"lat":15.1625777,"lng":120.5562661}	2021-03-17 06:45:48.659+00
1026	6	29	{"lat":15.1625023,"lng":120.5560092}	2021-03-17 06:45:55.091+00
1027	6	29	{"lat":15.1623329,"lng":120.5561725}	2021-03-17 06:46:20.271+00
1028	6	29	{"lat":15.1613633,"lng":120.55619}	2021-03-17 06:46:29.206+00
1029	6	29	{"lat":15.1614429,"lng":120.5560054}	2021-03-17 06:46:35.192+00
1030	6	29	{"lat":15.1613529,"lng":120.5559437}	2021-03-17 06:46:40.107+00
1031	6	29	{"lat":15.1612394,"lng":120.5560632}	2021-03-17 06:46:45.143+00
1032	6	29	{"lat":15.1610468,"lng":120.5561342}	2021-03-17 06:47:01.823+00
1033	6	29	{"lat":15.1604633,"lng":120.5560883}	2021-03-17 06:47:08.796+00
1034	6	29	{"lat":15.1601649,"lng":120.556403}	2021-03-17 06:47:31.275+00
1035	6	29	{"lat":15.1601649,"lng":120.556403}	2021-03-17 06:47:31.386+00
1036	6	29	{"lat":15.1600383,"lng":120.5565733}	2021-03-17 06:47:40.913+00
1037	6	29	{"lat":15.1600383,"lng":120.5565733}	2021-03-17 06:47:41.384+00
1038	6	29	{"lat":15.1600381,"lng":120.556576}	2021-03-17 06:48:13.312+00
1039	6	29	{"lat":15.1600383,"lng":120.5565733}	2021-03-17 06:48:18.423+00
1040	6	29	{"lat":15.1600182,"lng":120.5565776}	2021-03-17 06:48:23.137+00
1041	6	29	{"lat":15.1600773,"lng":120.5565282}	2021-03-17 06:48:28.594+00
1042	6	29	{"lat":15.1600133,"lng":120.5565727}	2021-03-17 06:48:34.857+00
1043	6	29	{"lat":15.1600133,"lng":120.5565727}	2021-03-17 06:48:36.387+00
1044	6	29	{"lat":15.159995,"lng":120.55657}	2021-03-17 06:48:44.89+00
1045	6	29	{"lat":15.159995,"lng":120.55657}	2021-03-17 06:48:46.399+00
1046	6	29	{"lat":15.1600367,"lng":120.5565534}	2021-03-17 06:49:06.453+00
1047	6	29	{"lat":15.1600983,"lng":120.556625}	2021-03-17 06:49:25.28+00
1048	6	29	{"lat":15.1600983,"lng":120.556625}	2021-03-17 06:49:26.387+00
1049	6	29	{"lat":15.160095,"lng":120.5566217}	2021-03-17 06:49:32.754+00
1050	6	29	{"lat":15.1601033,"lng":120.5566217}	2021-03-17 06:49:39.84+00
1051	6	29	{"lat":15.1601033,"lng":120.5566217}	2021-03-17 06:49:41.361+00
1052	6	29	{"lat":15.1600674,"lng":120.5565664}	2021-03-17 06:50:01.852+00
1053	6	29	{"lat":15.160045,"lng":120.556435}	2021-03-17 06:50:08.845+00
1054	6	29	{"lat":15.1601871,"lng":120.5564069}	2021-03-17 06:50:13.852+00
1055	6	29	{"lat":15.1601883,"lng":120.5564067}	2021-03-17 06:50:48.665+00
1056	6	29	{"lat":15.163075,"lng":120.5549533}	2021-03-17 06:50:55.88+00
1057	6	29	{"lat":15.163075,"lng":120.5549533}	2021-03-17 06:50:56.42+00
1058	6	29	{"lat":15.163075,"lng":120.5549533}	2021-03-17 06:51:06.445+00
1059	6	29	{"lat":15.163075,"lng":120.5549533}	2021-03-17 06:51:11.436+00
1060	6	29	{"lat":15.163075,"lng":120.5549533}	2021-03-17 06:51:16.392+00
1061	6	29	{"lat":15.1636842,"lng":120.5560816}	2021-03-17 06:51:35.875+00
1062	6	29	{"lat":15.16488,"lng":120.5581333}	2021-03-17 06:51:43.409+00
1063	6	29	{"lat":15.1650525,"lng":120.5585864}	2021-03-17 06:51:56.954+00
1064	6	29	{"lat":15.1652283,"lng":120.5589857}	2021-03-17 06:52:03.847+00
1065	6	29	{"lat":15.1652283,"lng":120.5589857}	2021-03-17 06:52:05.33+00
1066	6	29	{"lat":15.1652564,"lng":120.5590082}	2021-03-17 06:52:12.858+00
1067	6	29	{"lat":15.1652649,"lng":120.5590248}	2021-03-17 06:52:16.801+00
1068	6	29	{"lat":15.1662783,"lng":120.5618017}	2021-03-17 06:52:32.824+00
1069	6	29	{"lat":15.1662817,"lng":120.56181}	2021-03-17 06:52:38.988+00
1070	6	29	{"lat":15.1662817,"lng":120.56181}	2021-03-17 06:52:40.305+00
1071	6	29	{"lat":15.1663558,"lng":120.5624295}	2021-03-17 06:53:07.457+00
1072	6	29	{"lat":15.1664569,"lng":120.5634128}	2021-03-17 06:53:11.729+00
1073	6	29	{"lat":15.1665467,"lng":120.5642783}	2021-03-17 06:53:15.334+00
1074	6	29	{"lat":15.1665876,"lng":120.5644684}	2021-03-17 06:53:20.27+00
1075	6	29	{"lat":15.1666509,"lng":120.5646232}	2021-03-17 06:53:25.269+00
1076	6	29	{"lat":15.1666491,"lng":120.5646458}	2021-03-17 06:53:30.261+00
1077	6	29	{"lat":15.1666918,"lng":120.5647767}	2021-03-17 06:53:35.255+00
1078	6	29	{"lat":15.1668259,"lng":120.5648734}	2021-03-17 06:53:40.262+00
1079	6	29	{"lat":15.1670074,"lng":120.5650379}	2021-03-17 06:53:45.259+00
1080	6	29	{"lat":15.1671544,"lng":120.5652861}	2021-03-17 06:53:50.267+00
1081	6	29	{"lat":15.1672127,"lng":120.5657751}	2021-03-17 06:53:55.255+00
1082	6	29	{"lat":15.1672022,"lng":120.5664194}	2021-03-17 06:54:00.264+00
1083	6	29	{"lat":15.1670941,"lng":120.5670207}	2021-03-17 06:54:05.269+00
1084	6	29	{"lat":15.1669961,"lng":120.5676828}	2021-03-17 06:54:10.26+00
1085	6	29	{"lat":15.166905,"lng":120.5683307}	2021-03-17 06:54:15.294+00
1086	6	29	{"lat":15.1668183,"lng":120.5689311}	2021-03-17 06:54:20.277+00
1087	6	29	{"lat":15.1667269,"lng":120.569523}	2021-03-17 06:54:25.277+00
1088	6	29	{"lat":15.1666261,"lng":120.5701787}	2021-03-17 06:54:30.263+00
1089	6	29	{"lat":15.1665463,"lng":120.5708636}	2021-03-17 06:54:35.269+00
1090	6	29	{"lat":15.166446,"lng":120.5715903}	2021-03-17 06:54:40.257+00
1091	6	29	{"lat":15.1662919,"lng":120.5723495}	2021-03-17 06:54:45.259+00
1092	6	29	{"lat":15.1661873,"lng":120.57304}	2021-03-17 06:54:50.27+00
1093	6	29	{"lat":15.1660717,"lng":120.5737091}	2021-03-17 06:54:55.26+00
1094	6	29	{"lat":15.1659553,"lng":120.5743683}	2021-03-17 06:55:00.261+00
1095	6	29	{"lat":15.1658492,"lng":120.5750285}	2021-03-17 06:55:05.252+00
1096	6	29	{"lat":15.165792,"lng":120.5756191}	2021-03-17 06:55:10.254+00
1097	6	29	{"lat":15.1657674,"lng":120.5760716}	2021-03-17 06:55:15.264+00
1098	6	29	{"lat":15.1657974,"lng":120.5766063}	2021-03-17 06:55:20.265+00
1099	6	29	{"lat":15.1658996,"lng":120.5772577}	2021-03-17 06:55:25.254+00
1100	6	29	{"lat":15.1661043,"lng":120.5779658}	2021-03-17 06:55:30.265+00
1101	6	29	{"lat":15.166196,"lng":120.5786565}	2021-03-17 06:55:35.254+00
1102	6	29	{"lat":15.1663215,"lng":120.5793299}	2021-03-17 06:55:40.264+00
1103	6	29	{"lat":15.1664466,"lng":120.5798987}	2021-03-17 06:55:45.261+00
1104	6	29	{"lat":15.166554,"lng":120.5804206}	2021-03-17 06:55:50.275+00
1105	6	29	{"lat":15.1666142,"lng":120.5807}	2021-03-17 06:55:55.271+00
1106	6	29	{"lat":15.1666229,"lng":120.5807625}	2021-03-17 06:56:00.253+00
1107	6	29	{"lat":15.1667329,"lng":120.5807099}	2021-03-17 06:56:05.271+00
1108	6	29	{"lat":15.1667272,"lng":120.580317}	2021-03-17 06:56:10.259+00
1109	6	29	{"lat":15.1666287,"lng":120.5799196}	2021-03-17 06:56:15.263+00
1110	6	29	{"lat":15.1665628,"lng":120.5795027}	2021-03-17 06:56:20.264+00
1111	6	29	{"lat":15.1665211,"lng":120.5792753}	2021-03-17 06:56:25.275+00
1112	6	29	{"lat":15.1665112,"lng":120.5791992}	2021-03-17 06:56:30.262+00
1113	6	29	{"lat":15.1665566,"lng":120.5791645}	2021-03-17 06:56:36.067+00
1114	6	29	{"lat":15.1666252,"lng":120.5794499}	2021-03-17 06:56:40.261+00
1115	6	29	{"lat":15.1667006,"lng":120.5798795}	2021-03-17 06:56:46.204+00
1116	6	29	{"lat":15.1668155,"lng":120.5802895}	2021-03-17 06:56:50.256+00
1117	6	29	{"lat":15.166958,"lng":120.5806576}	2021-03-17 06:56:55.257+00
1118	6	29	{"lat":15.1671345,"lng":120.5810801}	2021-03-17 06:57:00.257+00
1119	6	29	{"lat":15.1672905,"lng":120.5814624}	2021-03-17 06:57:05.261+00
1120	6	29	{"lat":15.1674229,"lng":120.5818141}	2021-03-17 06:57:10.251+00
1121	6	29	{"lat":15.1675149,"lng":120.5819721}	2021-03-17 06:57:15.252+00
1122	6	29	{"lat":15.1675135,"lng":120.5818479}	2021-03-17 06:57:20.27+00
1123	6	29	{"lat":15.1673913,"lng":120.5815691}	2021-03-17 06:57:25.285+00
1124	6	29	{"lat":15.1671915,"lng":120.5809985}	2021-03-17 06:57:30.553+00
1125	6	29	{"lat":15.166335,"lng":120.5800583}	2021-03-17 06:57:41.798+00
1126	6	29	{"lat":15.1664817,"lng":120.57865}	2021-03-17 06:57:48.828+00
1127	6	29	{"lat":15.1664817,"lng":120.57865}	2021-03-17 06:57:50.307+00
1128	6	29	{"lat":15.16669,"lng":120.5788967}	2021-03-17 06:57:57.843+00
1129	6	29	{"lat":15.1666366,"lng":120.579733}	2021-03-17 06:58:21.831+00
1130	6	29	{"lat":15.1664483,"lng":120.58055}	2021-03-17 06:58:29.826+00
1131	6	29	{"lat":15.1664483,"lng":120.58055}	2021-03-17 06:58:30.299+00
1132	6	\N	{"lat":"15.1667483","lng":"120.580305"}	2021-03-17 06:58:58.407+00
1133	7	\N	{"lat":"15.1626748","lng":"120.5565613"}	2021-03-17 06:59:50.107+00
1134	3	\N	{"lat":"15.1491563","lng":"120.559347"}	2021-03-17 06:59:52.514+00
1135	3	\N	{"lat":"15.1617103","lng":"120.5577362"}	2021-03-17 07:00:47.968+00
1136	7	\N	{"lat":"15.1625663","lng":"120.5565116"}	2021-03-17 07:00:50.318+00
1137	1	15	{"lat":15.162669,"lng":120.55656}	2021-03-17 06:39:07.64+00
1138	1	15	{"lat":15.1626623,"lng":120.5565581}	2021-03-17 06:39:17.533+00
1139	1	15	{"lat":15.1626651,"lng":120.5565607}	2021-03-17 06:39:22.581+00
1140	1	15	{"lat":15.1626706,"lng":120.5565605}	2021-03-17 06:39:32.559+00
1141	1	15	{"lat":15.1626706,"lng":120.5565605}	2021-03-17 06:39:36.496+00
1142	1	15	{"lat":15.1626706,"lng":120.5565605}	2021-03-17 06:39:41.601+00
1143	1	15	{"lat":15.1626706,"lng":120.5565605}	2021-03-17 06:40:11.71+00
1144	1	15	{"lat":15.1626706,"lng":120.5565605}	2021-03-17 06:40:23.721+00
1145	1	15	{"lat":15.1626706,"lng":120.5565605}	2021-03-17 06:40:52.484+00
1146	1	15	{"lat":15.1626552,"lng":120.5565086}	2021-03-17 06:40:58.578+00
1147	1	15	{"lat":15.162867,"lng":120.5568664}	2021-03-17 06:41:08.742+00
1148	1	15	{"lat":15.1629341,"lng":120.5570521}	2021-03-17 06:41:13.905+00
1149	1	15	{"lat":15.1626904,"lng":120.5572577}	2021-03-17 06:41:23.763+00
1150	1	15	{"lat":15.1621015,"lng":120.5574619}	2021-03-17 06:41:33.749+00
1151	1	15	{"lat":15.1618223,"lng":120.5575583}	2021-03-17 06:41:38.852+00
1152	1	15	{"lat":15.1612595,"lng":120.5578582}	2021-03-17 06:41:48.252+00
1153	1	15	{"lat":15.160757,"lng":120.5580031}	2021-03-17 06:41:55.105+00
1154	1	15	{"lat":15.1602439,"lng":120.5581534}	2021-03-17 06:42:00.578+00
1155	1	15	{"lat":15.1602439,"lng":120.5581534}	2021-03-17 06:42:02.49+00
1156	1	15	{"lat":15.1600532,"lng":120.5582094}	2021-03-17 06:42:07.605+00
1157	1	15	{"lat":15.1595255,"lng":120.5583722}	2021-03-17 06:42:13.764+00
1158	1	15	{"lat":15.1589306,"lng":120.5586583}	2021-03-17 06:42:20.262+00
1159	1	15	{"lat":15.1588258,"lng":120.5587491}	2021-03-17 06:42:25.126+00
1160	1	15	{"lat":15.1585879,"lng":120.5588497}	2021-03-17 06:42:29.839+00
1161	1	15	{"lat":15.1583216,"lng":120.5589169}	2021-03-17 06:42:35.146+00
1162	1	15	{"lat":15.1581087,"lng":120.5592764}	2021-03-17 06:42:40.139+00
1163	1	15	{"lat":15.1579428,"lng":120.5596594}	2021-03-17 06:42:44.077+00
1164	1	15	{"lat":15.1573902,"lng":120.559845}	2021-03-17 06:42:50.175+00
1165	1	15	{"lat":15.15676,"lng":120.5599632}	2021-03-17 06:42:55.163+00
1166	1	15	{"lat":15.1560869,"lng":120.5600914}	2021-03-17 06:43:00.119+00
1167	1	15	{"lat":15.1553915,"lng":120.5601984}	2021-03-17 06:43:05.082+00
1168	1	15	{"lat":15.1549612,"lng":120.5602001}	2021-03-17 06:43:10.138+00
1169	1	15	{"lat":15.1545651,"lng":120.5602671}	2021-03-17 06:43:15.132+00
1170	1	15	{"lat":15.1541085,"lng":120.5602835}	2021-03-17 06:43:20.152+00
1171	1	15	{"lat":15.1536577,"lng":120.5602413}	2021-03-17 06:43:25.178+00
1172	1	15	{"lat":15.1531692,"lng":120.5600538}	2021-03-17 06:43:30.139+00
1173	1	15	{"lat":15.1528294,"lng":120.5597609}	2021-03-17 06:43:34.567+00
1174	1	15	{"lat":15.1522985,"lng":120.5594208}	2021-03-17 06:43:40.233+00
1175	1	15	{"lat":15.1517664,"lng":120.5592455}	2021-03-17 06:43:45.111+00
1176	1	15	{"lat":15.1510562,"lng":120.5591189}	2021-03-17 06:43:50.13+00
1177	1	15	{"lat":15.1504528,"lng":120.5592586}	2021-03-17 06:43:55.202+00
1178	1	15	{"lat":15.1497673,"lng":120.5592553}	2021-03-17 06:44:00.145+00
1179	1	15	{"lat":15.1492794,"lng":120.5592869}	2021-03-17 06:44:05.977+00
1180	1	15	{"lat":15.1492794,"lng":120.5592869}	2021-03-17 06:44:07.488+00
1181	1	15	{"lat":15.1482563,"lng":120.5593858}	2021-03-17 06:44:15.19+00
1182	1	15	{"lat":15.1475341,"lng":120.5593719}	2021-03-17 06:44:20.216+00
1183	1	15	{"lat":15.1467974,"lng":120.5593213}	2021-03-17 06:44:24.072+00
1184	1	15	{"lat":15.1459275,"lng":120.5592938}	2021-03-17 06:44:30.184+00
1185	1	15	{"lat":15.1452702,"lng":120.559285}	2021-03-17 06:44:35.109+00
1186	1	15	{"lat":15.1445975,"lng":120.5592557}	2021-03-17 06:44:40.12+00
1187	1	15	{"lat":15.1442459,"lng":120.5592271}	2021-03-17 06:44:44.944+00
1188	1	15	{"lat":15.1440944,"lng":120.5591813}	2021-03-17 06:44:50.197+00
1189	1	15	{"lat":15.1439907,"lng":120.5591974}	2021-03-17 06:44:56.004+00
1190	1	15	{"lat":15.1439907,"lng":120.5591974}	2021-03-17 06:44:57.501+00
1191	1	15	{"lat":15.1435495,"lng":120.5593928}	2021-03-17 06:45:05.134+00
1192	1	15	{"lat":15.1429799,"lng":120.5600987}	2021-03-17 06:45:10.21+00
1193	1	15	{"lat":15.1423487,"lng":120.560529}	2021-03-17 06:45:15.206+00
1194	1	15	{"lat":15.1415939,"lng":120.5610185}	2021-03-17 06:45:20.158+00
1195	1	15	{"lat":15.1409781,"lng":120.5614244}	2021-03-17 06:45:25.178+00
1196	1	15	{"lat":15.1403342,"lng":120.5618161}	2021-03-17 06:45:30.217+00
1197	1	15	{"lat":15.139689,"lng":120.5621568}	2021-03-17 06:45:35.411+00
1198	1	15	{"lat":15.1391922,"lng":120.5624931}	2021-03-17 06:45:40.177+00
1199	1	15	{"lat":15.138767,"lng":120.5627662}	2021-03-17 06:45:44.058+00
1200	1	15	{"lat":15.1386502,"lng":120.5628499}	2021-03-17 06:45:50.162+00
1201	1	15	{"lat":15.1386956,"lng":120.5627878}	2021-03-17 06:45:55.141+00
1202	1	15	{"lat":15.1387585,"lng":120.5627948}	2021-03-17 06:46:00.158+00
1203	1	15	{"lat":15.1388111,"lng":120.5628095}	2021-03-17 06:46:04.897+00
1204	1	15	{"lat":15.1387895,"lng":120.5629189}	2021-03-17 06:46:09.889+00
1205	1	15	{"lat":15.1387069,"lng":120.5627347}	2021-03-17 06:46:15.186+00
1206	1	15	{"lat":15.1386838,"lng":120.5627138}	2021-03-17 06:46:20.666+00
1207	1	15	{"lat":15.1386838,"lng":120.5627138}	2021-03-17 06:46:22.489+00
1208	1	15	{"lat":15.1386635,"lng":120.5627597}	2021-03-17 06:46:32.616+00
1209	1	15	{"lat":15.1386374,"lng":120.5627572}	2021-03-17 06:46:38.785+00
1210	1	15	{"lat":15.138623,"lng":120.562748}	2021-03-17 06:46:48.74+00
1211	1	15	{"lat":15.1386289,"lng":120.5627505}	2021-03-17 06:46:53.84+00
1212	1	15	{"lat":15.1385882,"lng":120.5627462}	2021-03-17 06:47:03.784+00
1213	1	15	{"lat":15.1386396,"lng":120.562758}	2021-03-17 06:47:13.748+00
1214	1	15	{"lat":15.1386545,"lng":120.5627552}	2021-03-17 06:47:18.853+00
1215	1	15	{"lat":15.1385952,"lng":120.5627297}	2021-03-17 06:47:28.735+00
1216	1	15	{"lat":15.1386203,"lng":120.562731}	2021-03-17 06:47:33.8+00
1217	1	15	{"lat":15.138636,"lng":120.562758}	2021-03-17 06:47:43.78+00
1218	1	15	{"lat":15.138662,"lng":120.5627658}	2021-03-17 06:47:48.864+00
1219	1	15	{"lat":15.1386918,"lng":120.5628096}	2021-03-17 06:47:58.788+00
1220	1	15	{"lat":15.1386521,"lng":120.5627987}	2021-03-17 06:48:07.165+00
1221	1	15	{"lat":15.1386162,"lng":120.5629066}	2021-03-17 06:48:17.043+00
1222	1	15	{"lat":15.1386037,"lng":120.5629803}	2021-03-17 06:48:25.86+00
1223	1	15	{"lat":15.1386206,"lng":120.5627526}	2021-03-17 06:48:32.132+00
1224	1	15	{"lat":15.1386411,"lng":120.5627512}	2021-03-17 06:48:42.189+00
1225	1	15	{"lat":15.1386625,"lng":120.562774}	2021-03-17 06:48:52.132+00
1226	1	15	{"lat":15.1386659,"lng":120.5627719}	2021-03-17 06:48:58.328+00
1227	1	15	{"lat":15.1386532,"lng":120.5627617}	2021-03-17 06:49:02.145+00
1228	1	15	{"lat":15.138647,"lng":120.5627575}	2021-03-17 06:49:07.241+00
1229	1	15	{"lat":15.1386423,"lng":120.5627496}	2021-03-17 06:49:17.234+00
1230	1	15	{"lat":15.1386788,"lng":120.5628106}	2021-03-17 06:49:27.102+00
1231	1	15	{"lat":15.1386677,"lng":120.5628047}	2021-03-17 06:49:32.185+00
1232	1	15	{"lat":15.1386609,"lng":120.562781}	2021-03-17 06:49:42.097+00
1233	1	15	{"lat":15.1386766,"lng":120.5628068}	2021-03-17 06:49:47.179+00
1234	1	15	{"lat":15.1386146,"lng":120.5627596}	2021-03-17 06:49:57.131+00
1235	1	15	{"lat":15.1386117,"lng":120.5627298}	2021-03-17 06:50:07.112+00
1236	1	15	{"lat":15.1386349,"lng":120.562753}	2021-03-17 06:50:12.18+00
1237	1	15	{"lat":15.1386082,"lng":120.5627447}	2021-03-17 06:50:22.213+00
1238	1	15	{"lat":15.1387036,"lng":120.5629732}	2021-03-17 06:50:29.217+00
1239	1	15	{"lat":15.1387036,"lng":120.5629732}	2021-03-17 06:50:30.765+00
1240	1	15	{"lat":15.1387771,"lng":120.5630892}	2021-03-17 06:50:35.886+00
1241	1	15	{"lat":15.1388672,"lng":120.5628716}	2021-03-17 06:50:42.175+00
1242	1	15	{"lat":15.1387967,"lng":120.5628544}	2021-03-17 06:50:48.544+00
1243	1	15	{"lat":15.1388039,"lng":120.5628278}	2021-03-17 06:50:53.635+00
1244	1	15	{"lat":15.1387563,"lng":120.5628306}	2021-03-17 06:50:58.55+00
1245	1	15	{"lat":15.1387584,"lng":120.5627983}	2021-03-17 06:51:03.506+00
1246	1	15	{"lat":15.1387721,"lng":120.5627266}	2021-03-17 06:51:08.523+00
1247	1	15	{"lat":15.1387653,"lng":120.5628667}	2021-03-17 06:51:13.663+00
1248	1	15	{"lat":15.1387327,"lng":120.5628149}	2021-03-17 06:51:18.538+00
1249	1	15	{"lat":15.1388235,"lng":120.5627968}	2021-03-17 06:51:23.59+00
1250	1	15	{"lat":15.1387612,"lng":120.562805}	2021-03-17 06:51:28.548+00
1251	1	15	{"lat":15.1387683,"lng":120.5628021}	2021-03-17 06:51:33.876+00
1252	1	15	{"lat":15.1387683,"lng":120.5628021}	2021-03-17 06:51:35.748+00
1253	1	15	{"lat":15.1388196,"lng":120.5629336}	2021-03-17 06:51:42.174+00
1254	1	15	{"lat":15.1387999,"lng":120.5628913}	2021-03-17 06:51:48.873+00
1255	1	15	{"lat":15.1387999,"lng":120.5628913}	2021-03-17 06:51:50.787+00
1256	1	15	{"lat":15.1387776,"lng":120.5629125}	2021-03-17 06:51:55.747+00
1257	1	15	{"lat":15.1388027,"lng":120.5629078}	2021-03-17 06:52:02.155+00
1258	1	15	{"lat":15.1387981,"lng":120.5627927}	2021-03-17 06:52:08.234+00
1259	1	15	{"lat":15.1387994,"lng":120.5628353}	2021-03-17 06:52:13.68+00
1260	1	15	{"lat":15.1387825,"lng":120.5628847}	2021-03-17 06:52:18.607+00
1261	1	15	{"lat":15.1387323,"lng":120.5628089}	2021-03-17 06:52:24.115+00
1262	1	15	{"lat":15.1387323,"lng":120.5628089}	2021-03-17 06:52:25.846+00
1263	1	15	{"lat":15.1387804,"lng":120.5628084}	2021-03-17 06:52:30.899+00
1264	1	15	{"lat":15.1388076,"lng":120.5628089}	2021-03-17 06:52:39.047+00
1265	1	15	{"lat":15.1388076,"lng":120.5628089}	2021-03-17 06:52:41.025+00
1266	1	15	{"lat":15.1387887,"lng":120.5628141}	2021-03-17 06:52:50.971+00
1267	1	15	{"lat":15.138781,"lng":120.5628151}	2021-03-17 06:52:59.678+00
1268	1	15	{"lat":15.1387778,"lng":120.5628157}	2021-03-17 06:53:05.897+00
1269	1	15	{"lat":15.1387778,"lng":120.5628157}	2021-03-17 06:53:10.99+00
1270	1	15	{"lat":15.138781,"lng":120.5628149}	2021-03-17 06:53:16.112+00
1271	1	15	{"lat":15.138781,"lng":120.5628149}	2021-03-17 06:53:20.818+00
1272	1	15	{"lat":15.1387811,"lng":120.5628149}	2021-03-17 06:53:25.757+00
1273	1	15	{"lat":15.142683,"lng":120.560342}	2021-03-17 06:53:30.862+00
1274	1	15	{"lat":15.1428635,"lng":120.5602551}	2021-03-17 06:53:35.993+00
1275	1	15	{"lat":15.1430544,"lng":120.5601072}	2021-03-17 06:53:40.91+00
1276	1	15	{"lat":15.143212,"lng":120.5599929}	2021-03-17 06:53:46.049+00
1277	1	15	{"lat":15.143212,"lng":120.5599929}	2021-03-17 06:53:50.984+00
1278	1	15	{"lat":15.1432956,"lng":120.5599489}	2021-03-17 06:53:55.882+00
1279	1	15	{"lat":15.1433772,"lng":120.5598998}	2021-03-17 06:54:00.776+00
1280	1	15	{"lat":15.1433772,"lng":120.5598998}	2021-03-17 06:54:05.834+00
1281	1	15	{"lat":15.143461,"lng":120.5598408}	2021-03-17 06:54:11.048+00
1282	1	15	{"lat":15.1435501,"lng":120.5597818}	2021-03-17 06:54:16.158+00
1283	1	15	{"lat":15.1435501,"lng":120.5597818}	2021-03-17 06:54:21.049+00
1284	1	15	{"lat":15.1436791,"lng":120.5597237}	2021-03-17 06:54:26.03+00
1285	1	15	{"lat":15.1437603,"lng":120.5596973}	2021-03-17 06:54:30.827+00
1286	1	15	{"lat":15.1438389,"lng":120.5596525}	2021-03-17 06:54:35.902+00
1287	1	15	{"lat":15.1439592,"lng":120.559583}	2021-03-17 06:54:41.242+00
1288	1	15	{"lat":15.1439592,"lng":120.559583}	2021-03-17 06:54:45.771+00
1289	1	15	{"lat":15.1439592,"lng":120.559583}	2021-03-17 06:54:51.147+00
1290	1	15	{"lat":15.1440487,"lng":120.5595535}	2021-03-17 06:54:56.22+00
1291	1	15	{"lat":15.1440487,"lng":120.5595535}	2021-03-17 06:55:01.009+00
1292	1	15	{"lat":15.1441739,"lng":120.5594987}	2021-03-17 06:55:06.209+00
1293	1	15	{"lat":15.1441739,"lng":120.5594987}	2021-03-17 06:55:11.037+00
1294	1	15	{"lat":15.1442781,"lng":120.5594558}	2021-03-17 06:55:16.404+00
1295	1	15	{"lat":15.1442781,"lng":120.5594558}	2021-03-17 06:55:20.769+00
1296	1	15	{"lat":15.1443481,"lng":120.5594336}	2021-03-17 06:55:25.979+00
1297	1	15	{"lat":15.1443481,"lng":120.5594336}	2021-03-17 06:55:31.434+00
1298	1	15	{"lat":15.144375,"lng":120.5594318}	2021-03-17 06:55:36.02+00
1299	1	15	{"lat":15.144375,"lng":120.5594318}	2021-03-17 06:55:41.37+00
1300	1	15	{"lat":15.144524,"lng":120.5594247}	2021-03-17 06:55:46.119+00
1301	1	15	{"lat":15.144524,"lng":120.5594247}	2021-03-17 06:55:51.484+00
1302	1	15	{"lat":15.1444297,"lng":120.5594494}	2021-03-17 06:55:55.951+00
1303	1	15	{"lat":15.1444297,"lng":120.5594494}	2021-03-17 06:56:01.293+00
1304	1	15	{"lat":15.1444297,"lng":120.5594494}	2021-03-17 06:56:06.246+00
1305	1	15	{"lat":15.1442594,"lng":120.5595033}	2021-03-17 06:56:10.814+00
1306	1	15	{"lat":15.1442594,"lng":120.5595033}	2021-03-17 06:56:16.287+00
1307	1	15	{"lat":15.1442907,"lng":120.5595}	2021-03-17 06:56:21.386+00
1308	1	15	{"lat":15.1442907,"lng":120.5595}	2021-03-17 06:56:25.915+00
1309	1	15	{"lat":15.1442907,"lng":120.5595}	2021-03-17 06:56:31.389+00
1310	1	15	{"lat":15.1444969,"lng":120.559509}	2021-03-17 06:56:36.31+00
1311	1	15	{"lat":15.1444969,"lng":120.559509}	2021-03-17 06:56:41.071+00
1312	1	15	{"lat":15.1444969,"lng":120.559509}	2021-03-17 06:56:46.551+00
1313	1	15	{"lat":15.1446126,"lng":120.5595298}	2021-03-17 06:56:51.337+00
1314	1	15	{"lat":15.1446126,"lng":120.5595298}	2021-03-17 06:56:56.582+00
1315	1	15	{"lat":15.1447673,"lng":120.5595476}	2021-03-17 06:57:00.808+00
1316	1	15	{"lat":15.1446712,"lng":120.5595515}	2021-03-17 06:57:05.94+00
1317	1	15	{"lat":15.1446712,"lng":120.5595515}	2021-03-17 06:57:10.943+00
1318	1	15	{"lat":15.1446712,"lng":120.5595515}	2021-03-17 06:57:16.211+00
1319	1	15	{"lat":15.1443633,"lng":120.5595165}	2021-03-17 06:57:21.644+00
1320	1	15	{"lat":15.1443633,"lng":120.5595165}	2021-03-17 06:57:26.189+00
1321	1	15	{"lat":15.1443633,"lng":120.5595165}	2021-03-17 06:57:31.64+00
1322	1	15	{"lat":15.1443633,"lng":120.5595165}	2021-03-17 06:57:36.042+00
1323	1	15	{"lat":15.1443633,"lng":120.5595165}	2021-03-17 06:57:41.737+00
1324	1	15	{"lat":15.1443633,"lng":120.5595165}	2021-03-17 06:57:46.428+00
1325	1	15	{"lat":15.1443633,"lng":120.5595165}	2021-03-17 06:57:51.246+00
1326	1	15	{"lat":15.1443688,"lng":120.5594919}	2021-03-17 06:57:56.04+00
1327	1	15	{"lat":15.1443688,"lng":120.5594919}	2021-03-17 06:58:00.785+00
1328	1	15	{"lat":15.1443688,"lng":120.5594919}	2021-03-17 06:58:05.834+00
1329	1	15	{"lat":15.1444552,"lng":120.5594797}	2021-03-17 06:58:20.551+00
1330	1	15	{"lat":15.1444552,"lng":120.5594797}	2021-03-17 06:58:21.676+00
1331	1	15	{"lat":15.1444432,"lng":120.5594795}	2021-03-17 06:58:28.493+00
1332	1	15	{"lat":15.1444091,"lng":120.5594812}	2021-03-17 06:58:32.08+00
1333	1	15	{"lat":15.1444212,"lng":120.5594819}	2021-03-17 06:58:37.191+00
1334	1	15	{"lat":15.1444348,"lng":120.5594826}	2021-03-17 06:58:42.935+00
1335	1	15	{"lat":15.1443927,"lng":120.5594855}	2021-03-17 06:58:51.429+00
1336	1	15	{"lat":15.1443834,"lng":120.5594863}	2021-03-17 06:58:58.433+00
1337	1	15	{"lat":15.1443834,"lng":120.5594863}	2021-03-17 06:59:06.072+00
1338	1	15	{"lat":15.1443761,"lng":120.559487}	2021-03-17 06:59:11.038+00
1339	1	15	{"lat":15.1443761,"lng":120.559487}	2021-03-17 06:59:15.961+00
1340	1	15	{"lat":15.1443611,"lng":120.5594966}	2021-03-17 06:59:20.822+00
1341	1	15	{"lat":15.1443716,"lng":120.5594969}	2021-03-17 06:59:27.739+00
1342	1	15	{"lat":15.1443848,"lng":120.5594975}	2021-03-17 06:59:31.237+00
1343	1	15	{"lat":15.1443914,"lng":120.5594982}	2021-03-17 06:59:36.358+00
1344	1	15	{"lat":15.1625618,"lng":120.5564959}	2021-03-17 06:59:52.122+00
1345	1	15	{"lat":15.1625551,"lng":120.5564935}	2021-03-17 06:59:57.186+00
1346	1	15	{"lat":15.1625551,"lng":120.5564935}	2021-03-17 07:00:01.017+00
1347	1	15	{"lat":15.1625585,"lng":120.556496}	2021-03-17 07:00:06.8+00
1348	1	15	{"lat":15.1625585,"lng":120.556496}	2021-03-17 07:00:11.908+00
1349	1	15	{"lat":15.1625609,"lng":120.5564971}	2021-03-17 07:00:18.406+00
1350	1	15	{"lat":15.1625625,"lng":120.5564964}	2021-03-17 07:00:23.504+00
1351	1	15	{"lat":15.1625611,"lng":120.5564962}	2021-03-17 07:00:28.817+00
1352	1	15	{"lat":15.1443432,"lng":120.5595213}	2021-03-17 07:00:46.077+00
1765	3	\N	{"lat":"15.1625647","lng":"120.5565012"}	2021-03-17 07:03:46.365+00
2018	2	7	{"lat":15.1445797,"lng":120.5612859}	2021-03-17 06:56:12.272+00
2019	2	7	{"lat":15.1445797,"lng":120.5612859}	2021-03-17 06:56:17.3+00
2020	2	7	{"lat":15.1445797,"lng":120.5612859}	2021-03-17 06:56:22.275+00
2021	2	7	{"lat":15.1445797,"lng":120.5612859}	2021-03-17 06:56:31.465+00
2022	2	7	{"lat":15.1445797,"lng":120.5612859}	2021-03-17 06:56:36.45+00
2023	2	7	{"lat":15.1445797,"lng":120.5612859}	2021-03-17 06:56:41.46+00
2024	2	7	{"lat":15.1445797,"lng":120.5612859}	2021-03-17 06:56:48.272+00
2025	2	7	{"lat":15.1445797,"lng":120.5612859}	2021-03-17 06:57:08.193+00
2026	2	7	{"lat":15.1445797,"lng":120.5612859}	2021-03-17 06:57:41.101+00
2027	2	7	{"lat":15.1445797,"lng":120.5612859}	2021-03-17 06:58:23.529+00
2028	2	7	{"lat":15.1445797,"lng":120.5612859}	2021-03-17 06:58:37.456+00
2029	2	7	{"lat":15.1445797,"lng":120.5612859}	2021-03-17 06:58:51.062+00
2030	2	7	{"lat":15.1445797,"lng":120.5612859}	2021-03-17 06:59:26.079+00
2031	2	7	{"lat":15.1445797,"lng":120.5612859}	2021-03-17 07:00:49.328+00
2032	2	7	{"lat":15.1445797,"lng":120.5612859}	2021-03-17 07:00:54.326+00
2033	2	7	{"lat":15.1445797,"lng":120.5612859}	2021-03-17 07:01:03.558+00
2034	2	7	{"lat":15.1445797,"lng":120.5612859}	2021-03-17 07:01:13.682+00
2035	2	7	{"lat":15.1487341,"lng":120.5798926}	2021-03-17 07:01:23.138+00
2036	2	7	{"lat":15.1487341,"lng":120.5798926}	2021-03-17 07:01:32.584+00
2037	2	7	{"lat":15.1487341,"lng":120.5798926}	2021-03-17 07:01:54.618+00
2038	2	7	{"lat":15.1487341,"lng":120.5798926}	2021-03-17 07:02:11.55+00
2039	2	7	{"lat":15.1487341,"lng":120.5798926}	2021-03-17 07:02:24.466+00
2040	2	7	{"lat":15.1487341,"lng":120.5798926}	2021-03-17 07:02:42.667+00
2041	2	7	{"lat":15.1487341,"lng":120.5798926}	2021-03-17 07:02:54.032+00
2042	2	7	{"lat":15.1487341,"lng":120.5798926}	2021-03-17 07:03:03.7+00
2043	2	7	{"lat":15.1487341,"lng":120.5798926}	2021-03-17 07:03:49.347+00
2044	2	7	{"lat":15.1487341,"lng":120.5798926}	2021-03-17 07:04:15.463+00
2045	2	7	{"lat":15.1487341,"lng":120.5798926}	2021-03-17 07:04:22.334+00
2046	2	7	{"lat":15.1487341,"lng":120.5798926}	2021-03-17 07:04:38.586+00
2047	2	7	{"lat":15.1487341,"lng":120.5798926}	2021-03-17 07:04:44.15+00
2048	2	7	{"lat":15.1487341,"lng":120.5798926}	2021-03-17 07:04:53.066+00
2049	2	7	{"lat":15.1487341,"lng":120.5798926}	2021-03-17 07:05:07.508+00
2050	2	7	{"lat":15.1487341,"lng":120.5798926}	2021-03-17 07:05:12.537+00
2051	2	7	{"lat":15.1487341,"lng":120.5798926}	2021-03-17 07:05:35.503+00
2052	2	7	{"lat":15.1487341,"lng":120.5798926}	2021-03-17 07:05:56.205+00
2053	2	7	{"lat":15.1487341,"lng":120.5798926}	2021-03-17 07:06:03.504+00
2054	2	7	{"lat":15.1487341,"lng":120.5798926}	2021-03-17 07:06:08.499+00
2055	2	7	{"lat":15.1487341,"lng":120.5798926}	2021-03-17 07:06:28.161+00
2056	2	7	{"lat":15.1487341,"lng":120.5798926}	2021-03-17 07:06:50.229+00
2057	2	7	{"lat":15.1487341,"lng":120.5798926}	2021-03-17 07:07:16.095+00
2058	2	7	{"lat":15.1487341,"lng":120.5798926}	2021-03-17 07:07:21.091+00
2059	2	7	{"lat":15.1620614,"lng":120.5910419}	2021-03-17 07:07:26.085+00
2060	2	7	{"lat":15.1620614,"lng":120.5910419}	2021-03-17 07:07:33.268+00
2061	2	7	{"lat":15.1620614,"lng":120.5910419}	2021-03-17 07:07:41.443+00
2062	2	7	{"lat":15.1620614,"lng":120.5910419}	2021-03-17 07:07:46.428+00
2063	2	7	{"lat":15.1620614,"lng":120.5910419}	2021-03-17 07:07:51.433+00
2064	2	7	{"lat":15.1620614,"lng":120.5910419}	2021-03-17 07:07:56.472+00
1353	1	\N	{"lat":"15.1443432","lng":"120.5595213"}	2021-03-17 07:00:55.388+00
1766	3	\N	{"lat":"15.1625653","lng":"120.5565011"}	2021-03-17 07:04:14.294+00
2065	2	7	{"lat":15.1620614,"lng":120.5910419}	2021-03-17 07:08:01.463+00
2066	2	7	{"lat":15.1620614,"lng":120.5910419}	2021-03-17 07:08:06.458+00
2067	2	7	{"lat":15.1620614,"lng":120.5910419}	2021-03-17 07:08:11.463+00
2068	2	7	{"lat":15.1639243,"lng":120.5909097}	2021-03-17 07:08:18.828+00
2069	2	7	{"lat":15.1636031,"lng":120.5909901}	2021-03-17 07:08:23.546+00
2072	2	\N	{"lat":"15.163604","lng":"120.5908978"}	2021-03-17 07:09:13.984+00
2167	8	6	{"lat":15.1552469,"lng":120.5602252}	2021-03-17 06:43:08.324+00
2168	8	6	{"lat":15.1548203,"lng":120.560266}	2021-03-17 06:43:13.273+00
2169	8	6	{"lat":15.1543949,"lng":120.5602693}	2021-03-17 06:43:18.308+00
2170	8	6	{"lat":15.1539375,"lng":120.5602557}	2021-03-17 06:43:23.263+00
2171	8	6	{"lat":15.1534846,"lng":120.5602049}	2021-03-17 06:43:28.235+00
2172	8	6	{"lat":15.1530284,"lng":120.5599423}	2021-03-17 06:43:33.309+00
2173	8	6	{"lat":15.1525702,"lng":120.5596052}	2021-03-17 06:43:38.255+00
2174	8	6	{"lat":15.1520368,"lng":120.5593577}	2021-03-17 06:43:43.323+00
2175	8	6	{"lat":15.1514052,"lng":120.5592689}	2021-03-17 06:43:48.26+00
2176	8	6	{"lat":15.1507467,"lng":120.5592723}	2021-03-17 06:43:53.24+00
2177	8	6	{"lat":15.1501324,"lng":120.5592958}	2021-03-17 06:43:58.286+00
2178	8	6	{"lat":15.1496289,"lng":120.5593132}	2021-03-17 06:44:03.237+00
2179	8	6	{"lat":15.1490788,"lng":120.5593545}	2021-03-17 06:44:08.281+00
2180	8	6	{"lat":15.1484055,"lng":120.5593593}	2021-03-17 06:44:13.293+00
2181	8	6	{"lat":15.1476825,"lng":120.5593467}	2021-03-17 06:44:18.263+00
2182	8	6	{"lat":15.1469266,"lng":120.5593609}	2021-03-17 06:44:23.305+00
2183	8	6	{"lat":15.1462174,"lng":120.5593706}	2021-03-17 06:44:28.265+00
2184	8	6	{"lat":15.1456275,"lng":120.5593834}	2021-03-17 06:44:33.246+00
2185	8	6	{"lat":15.1452387,"lng":120.5593606}	2021-03-17 06:44:38.279+00
2186	8	6	{"lat":15.1450678,"lng":120.5593611}	2021-03-17 06:44:43.311+00
2187	8	6	{"lat":15.1449295,"lng":120.5593584}	2021-03-17 06:44:48.253+00
2188	8	6	{"lat":15.1448095,"lng":120.5593612}	2021-03-17 06:44:53.278+00
2189	8	6	{"lat":15.1447655,"lng":120.5593649}	2021-03-17 06:44:58.488+00
2190	8	6	{"lat":15.1447404,"lng":120.5593929}	2021-03-17 06:45:03.288+00
2191	8	6	{"lat":15.1446369,"lng":120.55951}	2021-03-17 06:45:08.277+00
2192	8	6	{"lat":15.1445336,"lng":120.5596422}	2021-03-17 06:45:13.34+00
2193	8	6	{"lat":15.1445091,"lng":120.5599645}	2021-03-17 06:45:18.267+00
2194	8	6	{"lat":15.1445637,"lng":120.5606559}	2021-03-17 06:45:23.293+00
2195	8	6	{"lat":15.1446254,"lng":120.561341}	2021-03-17 06:45:28.262+00
2196	8	6	{"lat":15.1446984,"lng":120.5620276}	2021-03-17 06:45:33.28+00
2197	8	6	{"lat":15.1447597,"lng":120.5626765}	2021-03-17 06:45:38.276+00
2198	8	6	{"lat":15.1448296,"lng":120.5632669}	2021-03-17 06:45:43.218+00
2199	8	6	{"lat":15.1448942,"lng":120.5639886}	2021-03-17 06:45:48.302+00
2200	8	6	{"lat":15.1449347,"lng":120.5645516}	2021-03-17 06:45:52.949+00
2201	8	6	{"lat":15.1450688,"lng":120.5652542}	2021-03-17 06:45:58.297+00
2202	8	6	{"lat":15.1451691,"lng":120.565815}	2021-03-17 06:46:03.259+00
2203	8	6	{"lat":15.1452583,"lng":120.5662704}	2021-03-17 06:46:08.321+00
2204	8	6	{"lat":15.1453255,"lng":120.5666118}	2021-03-17 06:46:13.269+00
2205	8	6	{"lat":15.1454491,"lng":120.5670472}	2021-03-17 06:46:18.232+00
2206	8	6	{"lat":15.1455714,"lng":120.5675161}	2021-03-17 06:46:23.281+00
2207	8	6	{"lat":15.145686,"lng":120.5680356}	2021-03-17 06:46:28.265+00
2208	8	6	{"lat":15.1458508,"lng":120.5686636}	2021-03-17 06:46:33.292+00
2209	8	6	{"lat":15.1460875,"lng":120.5693456}	2021-03-17 06:46:38.249+00
2210	8	6	{"lat":15.1463287,"lng":120.5699625}	2021-03-17 06:46:43.324+00
2211	8	6	{"lat":15.1465509,"lng":120.5705449}	2021-03-17 06:46:48.244+00
2212	8	6	{"lat":15.1467789,"lng":120.5711164}	2021-03-17 06:46:53.265+00
2213	8	6	{"lat":15.1470316,"lng":120.5717477}	2021-03-17 06:46:58.227+00
2214	8	6	{"lat":15.1473066,"lng":120.5724636}	2021-03-17 06:47:03.266+00
2215	8	6	{"lat":15.1474999,"lng":120.5730125}	2021-03-17 06:47:08.235+00
2216	8	6	{"lat":15.1476454,"lng":120.5732998}	2021-03-17 06:47:13.297+00
2217	8	6	{"lat":15.1478003,"lng":120.5736294}	2021-03-17 06:47:18.244+00
2218	8	6	{"lat":15.1480059,"lng":120.5740281}	2021-03-17 06:47:23.293+00
2219	8	6	{"lat":15.1481102,"lng":120.574282}	2021-03-17 06:47:28.422+00
2220	8	6	{"lat":15.1481458,"lng":120.5743697}	2021-03-17 06:47:33.269+00
2221	8	6	{"lat":15.1482101,"lng":120.5744939}	2021-03-17 06:47:38.246+00
2222	8	6	{"lat":15.1483196,"lng":120.574787}	2021-03-17 06:47:43.283+00
2223	8	6	{"lat":15.1484736,"lng":120.5752889}	2021-03-17 06:47:48.272+00
2224	8	6	{"lat":15.1486241,"lng":120.5758548}	2021-03-17 06:47:53.232+00
2225	8	6	{"lat":15.148727,"lng":120.5762691}	2021-03-17 06:47:58.3+00
2226	8	6	{"lat":15.1488265,"lng":120.5765842}	2021-03-17 06:48:03.266+00
2227	8	6	{"lat":15.1488945,"lng":120.5768869}	2021-03-17 06:48:07.88+00
2228	8	6	{"lat":15.1488798,"lng":120.5768569}	2021-03-17 06:48:12.844+00
2229	8	6	{"lat":15.1492548,"lng":120.5783532}	2021-03-17 06:48:18.279+00
2230	8	6	{"lat":15.1493173,"lng":120.5788566}	2021-03-17 06:48:23.29+00
2231	8	6	{"lat":15.1493193,"lng":120.579148}	2021-03-17 06:48:28.226+00
2232	8	6	{"lat":15.1493206,"lng":120.5794903}	2021-03-17 06:48:33.295+00
2233	8	6	{"lat":15.1493304,"lng":120.5799247}	2021-03-17 06:48:38.293+00
2234	8	6	{"lat":15.1493347,"lng":120.5803635}	2021-03-17 06:48:43.267+00
2235	8	6	{"lat":15.14933,"lng":120.5808029}	2021-03-17 06:48:48.297+00
2236	8	6	{"lat":15.1493395,"lng":120.5812201}	2021-03-17 06:48:53.208+00
2237	8	6	{"lat":15.1493573,"lng":120.5817782}	2021-03-17 06:48:58.271+00
2238	8	6	{"lat":15.1493895,"lng":120.5824114}	2021-03-17 06:49:03.284+00
2239	8	6	{"lat":15.1493981,"lng":120.5828012}	2021-03-17 06:49:08.278+00
2240	8	6	{"lat":15.1494073,"lng":120.583128}	2021-03-17 06:49:13.268+00
2241	8	6	{"lat":15.1494707,"lng":120.583421}	2021-03-17 06:49:18.28+00
2242	8	6	{"lat":15.1495943,"lng":120.58373}	2021-03-17 06:49:23.272+00
2243	8	6	{"lat":15.1496915,"lng":120.5839777}	2021-03-17 06:49:28.274+00
2244	8	6	{"lat":15.1498136,"lng":120.5842132}	2021-03-17 06:49:33.51+00
2245	8	6	{"lat":15.149715,"lng":120.584351}	2021-03-17 06:49:38.329+00
2246	8	6	{"lat":15.1492419,"lng":120.5846074}	2021-03-17 06:49:43.281+00
2247	8	6	{"lat":15.1488429,"lng":120.5847808}	2021-03-17 06:49:48.401+00
2248	8	6	{"lat":15.148632,"lng":120.5849562}	2021-03-17 06:49:53.239+00
2249	8	6	{"lat":15.1483011,"lng":120.5852075}	2021-03-17 06:49:58.222+00
2250	8	6	{"lat":15.1478697,"lng":120.5855262}	2021-03-17 06:50:03.282+00
2251	8	6	{"lat":15.1474225,"lng":120.5859028}	2021-03-17 06:50:08.235+00
2252	8	6	{"lat":15.1469658,"lng":120.586273}	2021-03-17 06:50:13.247+00
2253	8	6	{"lat":15.1465741,"lng":120.5865943}	2021-03-17 06:50:18.233+00
2254	8	6	{"lat":15.1463362,"lng":120.5867929}	2021-03-17 06:50:23.308+00
2255	8	6	{"lat":15.1462648,"lng":120.5868213}	2021-03-17 06:50:28.259+00
2256	8	6	{"lat":15.1461272,"lng":120.5867022}	2021-03-17 06:50:33.464+00
2257	8	6	{"lat":15.1457915,"lng":120.5862475}	2021-03-17 06:50:38.283+00
2258	8	6	{"lat":15.1454539,"lng":120.5857631}	2021-03-17 06:50:43.252+00
2259	8	6	{"lat":15.1451818,"lng":120.5854091}	2021-03-17 06:50:48.456+00
2260	8	6	{"lat":15.1449201,"lng":120.5850695}	2021-03-17 06:50:53.254+00
2261	8	6	{"lat":15.144703,"lng":120.5847469}	2021-03-17 06:50:58.255+00
2262	8	6	{"lat":15.1445614,"lng":120.5845534}	2021-03-17 06:51:03.479+00
2263	8	6	{"lat":15.1444308,"lng":120.5844018}	2021-03-17 06:51:08.303+00
2264	8	6	{"lat":15.1440664,"lng":120.5840644}	2021-03-17 06:51:13.24+00
2265	8	6	{"lat":15.1436645,"lng":120.5837716}	2021-03-17 06:51:18.282+00
2266	8	6	{"lat":15.1432363,"lng":120.58342}	2021-03-17 06:51:23.279+00
2267	8	6	{"lat":15.1428794,"lng":120.5831178}	2021-03-17 06:51:28.286+00
2268	8	6	{"lat":15.1425075,"lng":120.5828123}	2021-03-17 06:51:33.282+00
2269	8	6	{"lat":15.1420897,"lng":120.582451}	2021-03-17 06:51:38.27+00
2270	8	6	{"lat":15.1418741,"lng":120.5822815}	2021-03-17 06:51:43.391+00
2271	8	6	{"lat":15.1417355,"lng":120.5823785}	2021-03-17 06:51:48.291+00
2272	8	6	{"lat":15.1413219,"lng":120.5828226}	2021-03-17 06:51:53.251+00
2273	8	6	{"lat":15.1410136,"lng":120.5833281}	2021-03-17 06:51:58.224+00
2274	8	6	{"lat":15.1407761,"lng":120.5838183}	2021-03-17 06:52:03.266+00
2275	8	6	{"lat":15.1405365,"lng":120.5842916}	2021-03-17 06:52:08.265+00
2276	8	6	{"lat":15.1403718,"lng":120.5845997}	2021-03-17 06:52:13.26+00
2277	8	6	{"lat":15.1402268,"lng":120.5849057}	2021-03-17 06:52:18.258+00
2278	8	6	{"lat":15.1400655,"lng":120.5852404}	2021-03-17 06:52:23.249+00
2279	8	6	{"lat":15.1399662,"lng":120.5854296}	2021-03-17 06:52:28.3+00
2280	8	6	{"lat":15.1398995,"lng":120.5855252}	2021-03-17 06:52:33.46+00
2281	8	6	{"lat":15.1397147,"lng":120.5858534}	2021-03-17 06:52:38.283+00
2282	8	6	{"lat":15.139615,"lng":120.5860501}	2021-03-17 06:52:43.442+00
2283	8	6	{"lat":15.1395759,"lng":120.5861275}	2021-03-17 06:52:48.248+00
2284	8	6	{"lat":15.1394781,"lng":120.5863217}	2021-03-17 06:52:53.354+00
2285	8	6	{"lat":15.1393579,"lng":120.5866209}	2021-03-17 06:52:58.263+00
2286	8	6	{"lat":15.1392169,"lng":120.5869729}	2021-03-17 06:53:03.274+00
2287	8	6	{"lat":15.1391101,"lng":120.5872735}	2021-03-17 06:53:08.256+00
2288	8	6	{"lat":15.1390059,"lng":120.5874404}	2021-03-17 06:53:13.462+00
2289	8	6	{"lat":15.1388465,"lng":120.5874867}	2021-03-17 06:53:18.238+00
2290	8	6	{"lat":15.1386559,"lng":120.5874544}	2021-03-17 06:53:23.276+00
2291	8	6	{"lat":15.1383758,"lng":120.5873042}	2021-03-17 06:53:28.284+00
2292	8	6	{"lat":15.1379833,"lng":120.5870327}	2021-03-17 06:53:33.285+00
2293	8	6	{"lat":15.1376353,"lng":120.5868186}	2021-03-17 06:53:38.288+00
2294	8	6	{"lat":15.137248,"lng":120.5866136}	2021-03-17 06:53:45.23+00
2295	8	6	{"lat":15.1370179,"lng":120.5864979}	2021-03-17 06:53:50.269+00
2296	8	6	{"lat":15.1367915,"lng":120.5865514}	2021-03-17 06:53:55.262+00
2297	8	6	{"lat":15.1365758,"lng":120.5869213}	2021-03-17 06:54:00.266+00
2298	8	6	{"lat":15.1364358,"lng":120.5873532}	2021-03-17 06:54:05.261+00
2299	8	6	{"lat":15.1363323,"lng":120.5876059}	2021-03-17 06:54:10.332+00
2300	8	6	{"lat":15.1363516,"lng":120.5877134}	2021-03-17 06:54:15.261+00
2301	8	6	{"lat":15.1363299,"lng":120.5877951}	2021-03-17 06:54:20.281+00
2302	8	6	{"lat":15.1363197,"lng":120.5878791}	2021-03-17 06:54:24.734+00
2303	8	6	{"lat":15.1363569,"lng":120.5878826}	2021-03-17 06:54:29.462+00
2304	8	6	{"lat":15.1363522,"lng":120.5878873}	2021-03-17 06:54:34.623+00
2305	8	6	{"lat":15.1362539,"lng":120.5879275}	2021-03-17 06:54:40.327+00
2306	8	6	{"lat":15.1362405,"lng":120.58797}	2021-03-17 06:54:45.267+00
2307	8	6	{"lat":15.1362646,"lng":120.5880665}	2021-03-17 06:54:50.294+00
2308	8	6	{"lat":15.136345,"lng":120.5881552}	2021-03-17 06:54:55.281+00
2309	8	6	{"lat":15.1364427,"lng":120.5882151}	2021-03-17 06:55:00.288+00
2310	8	6	{"lat":15.1364836,"lng":120.5882492}	2021-03-17 06:55:04.964+00
2311	8	6	{"lat":15.136494,"lng":120.5882558}	2021-03-17 06:55:10.302+00
2312	8	6	{"lat":15.1365011,"lng":120.5882458}	2021-03-17 06:55:14.877+00
2313	8	6	{"lat":15.136468,"lng":120.5882431}	2021-03-17 06:55:19.514+00
2314	8	6	{"lat":15.1364187,"lng":120.5882316}	2021-03-17 06:55:24.594+00
2315	8	6	{"lat":15.1364678,"lng":120.5882404}	2021-03-17 06:55:30.311+00
2316	8	6	{"lat":15.1365039,"lng":120.5882343}	2021-03-17 06:55:34.486+00
2317	8	6	{"lat":15.1364988,"lng":120.5882296}	2021-03-17 06:55:40.318+00
2318	8	6	{"lat":15.1364982,"lng":120.5882288}	2021-03-17 06:55:45.3+00
2319	8	6	{"lat":15.1364987,"lng":120.588228}	2021-03-17 06:55:50.256+00
2320	8	6	{"lat":15.1364995,"lng":120.588227}	2021-03-17 06:55:55.265+00
2321	8	6	{"lat":15.136491,"lng":120.5882189}	2021-03-17 06:56:00.304+00
2322	8	6	{"lat":15.136449,"lng":120.5881785}	2021-03-17 06:56:04.513+00
2323	8	6	{"lat":15.1364394,"lng":120.5881685}	2021-03-17 06:56:09.494+00
2324	8	6	{"lat":15.1365288,"lng":120.5882231}	2021-03-17 06:56:15.254+00
2325	8	6	{"lat":15.1364748,"lng":120.5882016}	2021-03-17 06:56:19.642+00
2326	8	6	{"lat":15.1364923,"lng":120.5882369}	2021-03-17 06:56:25.289+00
2327	8	6	{"lat":15.1364949,"lng":120.5882429}	2021-03-17 06:56:30.29+00
2328	8	6	{"lat":15.1364918,"lng":120.5882449}	2021-03-17 06:56:35.338+00
2329	8	6	{"lat":15.1364849,"lng":120.588246}	2021-03-17 06:56:40.312+00
2330	8	6	{"lat":15.1364761,"lng":120.5882491}	2021-03-17 06:56:45.306+00
2331	8	6	{"lat":15.136472,"lng":120.5882475}	2021-03-17 06:56:50.308+00
2332	8	6	{"lat":15.1364685,"lng":120.5882463}	2021-03-17 06:56:55.388+00
2333	8	6	{"lat":15.1364613,"lng":120.5882492}	2021-03-17 06:57:00.539+00
2334	8	6	{"lat":15.136485,"lng":120.5882424}	2021-03-17 06:57:05.24+00
2335	8	6	{"lat":15.1364926,"lng":120.5882319}	2021-03-17 06:57:10.247+00
2336	8	6	{"lat":15.1364724,"lng":120.5882107}	2021-03-17 06:57:15.434+00
2337	8	6	{"lat":15.1364487,"lng":120.5881553}	2021-03-17 06:57:20.279+00
2338	8	6	{"lat":15.1364123,"lng":120.5881357}	2021-03-17 06:57:24.843+00
2339	8	6	{"lat":15.1363867,"lng":120.5881497}	2021-03-17 06:57:29.514+00
2340	8	6	{"lat":15.1363508,"lng":120.5881271}	2021-03-17 06:57:35.287+00
2341	8	6	{"lat":15.1363406,"lng":120.5881222}	2021-03-17 06:57:39.804+00
2342	8	6	{"lat":15.1363436,"lng":120.5881099}	2021-03-17 06:57:45.348+00
2343	8	6	{"lat":15.1363489,"lng":120.588107}	2021-03-17 06:57:49.533+00
2344	8	6	{"lat":15.1363556,"lng":120.5880912}	2021-03-17 06:57:54.472+00
2345	8	6	{"lat":15.1363607,"lng":120.5880841}	2021-03-17 06:57:59.498+00
2346	8	6	{"lat":15.1363699,"lng":120.5880465}	2021-03-17 06:58:04.704+00
2347	8	6	{"lat":15.1363718,"lng":120.5880138}	2021-03-17 06:58:09.483+00
2348	8	6	{"lat":15.1363683,"lng":120.5879877}	2021-03-17 06:58:14.889+00
2349	8	6	{"lat":15.1364623,"lng":120.5878867}	2021-03-17 06:58:20.61+00
2350	8	6	{"lat":15.1363889,"lng":120.5879699}	2021-03-17 06:58:24.606+00
2351	8	6	{"lat":15.136373,"lng":120.5879838}	2021-03-17 06:58:29.67+00
2352	8	6	{"lat":15.1363976,"lng":120.5879705}	2021-03-17 06:58:34.633+00
2353	8	6	{"lat":15.1364068,"lng":120.5879646}	2021-03-17 06:58:39.544+00
2354	8	6	{"lat":15.1363865,"lng":120.587922}	2021-03-17 06:58:45.56+00
2355	8	6	{"lat":15.1364826,"lng":120.5878615}	2021-03-17 06:58:50.538+00
2356	8	6	{"lat":15.1365688,"lng":120.5878397}	2021-03-17 06:58:55.56+00
2357	8	6	{"lat":15.1365671,"lng":120.5878503}	2021-03-17 06:59:00.631+00
2358	8	6	{"lat":15.1365439,"lng":120.5878588}	2021-03-17 06:59:05.452+00
2359	8	6	{"lat":15.136405,"lng":120.5879077}	2021-03-17 06:59:10.4+00
2360	8	6	{"lat":15.1364954,"lng":120.5878747}	2021-03-17 06:59:15.558+00
2361	8	6	{"lat":15.1365708,"lng":120.5878539}	2021-03-17 06:59:20.604+00
2362	8	6	{"lat":15.1365712,"lng":120.5878534}	2021-03-17 06:59:25.572+00
2363	8	6	{"lat":15.136489,"lng":120.5879131}	2021-03-17 06:59:29.515+00
2364	8	6	{"lat":15.1364901,"lng":120.5879126}	2021-03-17 06:59:34.51+00
2365	8	6	{"lat":15.136502,"lng":120.5879022}	2021-03-17 06:59:39.888+00
2366	8	6	{"lat":15.1365054,"lng":120.5879}	2021-03-17 06:59:45.559+00
2367	8	6	{"lat":15.1364298,"lng":120.5879004}	2021-03-17 06:59:51.08+00
2368	8	6	{"lat":15.136542,"lng":120.5878493}	2021-03-17 06:59:56.242+00
2369	8	6	{"lat":15.1364708,"lng":120.5878593}	2021-03-17 07:00:00.733+00
2370	8	6	{"lat":15.1365661,"lng":120.5878408}	2021-03-17 07:00:05.603+00
2371	8	6	{"lat":15.1365714,"lng":120.5878408}	2021-03-17 07:00:10.67+00
2372	8	6	{"lat":15.1365676,"lng":120.5878462}	2021-03-17 07:00:15.843+00
2373	8	6	{"lat":15.1365619,"lng":120.5878501}	2021-03-17 07:00:20.956+00
2374	8	6	{"lat":15.1365773,"lng":120.5878434}	2021-03-17 07:00:25.853+00
2375	8	6	{"lat":15.1365753,"lng":120.587846}	2021-03-17 07:00:31.145+00
2376	8	6	{"lat":15.1364276,"lng":120.587898}	2021-03-17 07:00:39.046+00
2377	8	6	{"lat":15.1365372,"lng":120.5878646}	2021-03-17 07:01:10.841+00
2378	8	6	{"lat":15.1363848,"lng":120.5881742}	2021-03-17 07:03:39.887+00
2379	8	6	{"lat":15.1365178,"lng":120.5882349}	2021-03-17 07:03:44.428+00
2380	8	6	{"lat":15.136505,"lng":120.5882349}	2021-03-17 07:03:49.397+00
2381	8	6	{"lat":15.136512,"lng":120.5882789}	2021-03-17 07:03:54.381+00
2382	8	6	{"lat":15.1365088,"lng":120.588238}	2021-03-17 07:04:00.344+00
2383	8	6	{"lat":15.136512,"lng":120.5882354}	2021-03-17 07:04:05.439+00
2384	8	6	{"lat":15.1365132,"lng":120.5882347}	2021-03-17 07:04:10.454+00
2385	8	6	{"lat":15.1365151,"lng":120.5882348}	2021-03-17 07:04:15.446+00
2386	8	6	{"lat":15.1365161,"lng":120.5882352}	2021-03-17 07:04:20.326+00
2387	8	6	{"lat":15.1365189,"lng":120.5882359}	2021-03-17 07:04:25.45+00
2388	8	6	{"lat":15.1365262,"lng":120.5882398}	2021-03-17 07:04:30.324+00
2389	8	6	{"lat":15.1365266,"lng":120.5882434}	2021-03-17 07:04:35.27+00
2390	8	6	{"lat":15.1365229,"lng":120.5882446}	2021-03-17 07:04:40.433+00
2391	8	6	{"lat":15.1365201,"lng":120.5882463}	2021-03-17 07:04:45.306+00
2392	8	6	{"lat":15.1365209,"lng":120.5882462}	2021-03-17 07:04:50.414+00
2393	8	6	{"lat":15.1365226,"lng":120.5882429}	2021-03-17 07:04:55.318+00
2394	8	6	{"lat":15.1365313,"lng":120.5882376}	2021-03-17 07:05:00.446+00
2395	8	6	{"lat":15.1365331,"lng":120.5882383}	2021-03-17 07:05:05.326+00
2396	8	6	{"lat":15.1365335,"lng":120.5882381}	2021-03-17 07:05:10.44+00
2397	8	6	{"lat":15.1365131,"lng":120.5882233}	2021-03-17 07:05:15.363+00
2398	8	6	{"lat":15.1364648,"lng":120.5881778}	2021-03-17 07:05:20.415+00
2399	8	6	{"lat":15.1364148,"lng":120.5881099}	2021-03-17 07:05:25.346+00
2400	8	6	{"lat":15.1363655,"lng":120.5880587}	2021-03-17 07:05:30.439+00
2401	8	6	{"lat":15.1363796,"lng":120.5878892}	2021-03-17 07:05:35.356+00
2402	8	6	{"lat":15.1365934,"lng":120.5877392}	2021-03-17 07:05:40.375+00
2403	8	6	{"lat":15.1368672,"lng":120.5878831}	2021-03-17 07:05:45.435+00
2404	8	6	{"lat":15.1372354,"lng":120.5881861}	2021-03-17 07:05:50.203+00
2405	8	6	{"lat":15.1375951,"lng":120.5885175}	2021-03-17 07:05:55.254+00
2406	8	6	{"lat":15.13776,"lng":120.5886604}	2021-03-17 07:06:00.3+00
2407	8	6	{"lat":15.1378338,"lng":120.5886805}	2021-03-17 07:06:05.219+00
2408	8	6	{"lat":15.1379964,"lng":120.5885573}	2021-03-17 07:06:10.278+00
2409	8	6	{"lat":15.1381138,"lng":120.5884}	2021-03-17 07:06:15.427+00
2410	8	6	{"lat":15.1381729,"lng":120.5883014}	2021-03-17 07:06:19.315+00
2411	8	6	{"lat":15.1385531,"lng":120.5878874}	2021-03-17 07:06:25.271+00
2412	8	6	{"lat":15.1387691,"lng":120.5876415}	2021-03-17 07:06:30.272+00
2413	8	6	{"lat":15.1390924,"lng":120.587437}	2021-03-17 07:06:35.281+00
2414	8	6	{"lat":15.1394972,"lng":120.5874648}	2021-03-17 07:06:40.253+00
2415	8	6	{"lat":15.1398931,"lng":120.5875475}	2021-03-17 07:06:45.321+00
2416	8	6	{"lat":15.1401824,"lng":120.5876064}	2021-03-17 07:06:50.259+00
2417	8	6	{"lat":15.1404078,"lng":120.5876469}	2021-03-17 07:06:55.293+00
2418	8	6	{"lat":15.1406476,"lng":120.5877072}	2021-03-17 07:07:00.265+00
2419	8	6	{"lat":15.1409745,"lng":120.5877897}	2021-03-17 07:07:05.347+00
2420	8	6	{"lat":15.1412401,"lng":120.5878407}	2021-03-17 07:07:10.265+00
2421	8	6	{"lat":15.1415533,"lng":120.5879137}	2021-03-17 07:07:15.318+00
2422	8	6	{"lat":15.1419204,"lng":120.5880223}	2021-03-17 07:07:20.241+00
2423	8	6	{"lat":15.1422639,"lng":120.5881305}	2021-03-17 07:07:25.248+00
2424	8	6	{"lat":15.1426012,"lng":120.5882276}	2021-03-17 07:07:30.58+00
2425	8	6	{"lat":15.1429281,"lng":120.5883052}	2021-03-17 07:07:35.319+00
2426	8	6	{"lat":15.1432616,"lng":120.5883733}	2021-03-17 07:07:40.25+00
2427	8	6	{"lat":15.1436317,"lng":120.5884412}	2021-03-17 07:07:45.286+00
2428	8	6	{"lat":15.1441072,"lng":120.5885368}	2021-03-17 07:07:50.257+00
2429	8	6	{"lat":15.1446213,"lng":120.5886474}	2021-03-17 07:07:55.284+00
2430	8	6	{"lat":15.1449432,"lng":120.5887445}	2021-03-17 07:08:00.26+00
2431	8	6	{"lat":15.1452635,"lng":120.5888294}	2021-03-17 07:08:05.303+00
2432	8	6	{"lat":15.1458174,"lng":120.5889902}	2021-03-17 07:08:10.24+00
2433	8	6	{"lat":15.1463473,"lng":120.5891257}	2021-03-17 07:08:15.281+00
2434	8	6	{"lat":15.1465928,"lng":120.5891948}	2021-03-17 07:08:20.313+00
2435	8	6	{"lat":15.1467687,"lng":120.589252}	2021-03-17 07:08:25.302+00
2436	8	6	{"lat":15.1468554,"lng":120.5892882}	2021-03-17 07:08:30.297+00
2437	8	6	{"lat":15.1469167,"lng":120.5893156}	2021-03-17 07:08:35.279+00
2438	8	6	{"lat":15.1470895,"lng":120.5893816}	2021-03-17 07:08:40.387+00
2439	8	6	{"lat":15.147359,"lng":120.5894882}	2021-03-17 07:08:45.345+00
2440	8	6	{"lat":15.1474144,"lng":120.5895114}	2021-03-17 07:08:50.288+00
2441	8	6	{"lat":15.1476636,"lng":120.5896313}	2021-03-17 07:08:55.353+00
2442	8	6	{"lat":15.1481884,"lng":120.5898864}	2021-03-17 07:09:00.283+00
2443	8	6	{"lat":15.148782,"lng":120.5901668}	2021-03-17 07:09:05.249+00
2444	8	6	{"lat":15.1493681,"lng":120.5904375}	2021-03-17 07:09:10.335+00
2445	8	6	{"lat":15.1499297,"lng":120.5906956}	2021-03-17 07:09:15.315+00
2446	8	6	{"lat":15.1505028,"lng":120.59096}	2021-03-17 07:09:20.326+00
2447	8	6	{"lat":15.1510351,"lng":120.5912102}	2021-03-17 07:09:25.316+00
2448	8	6	{"lat":15.1514828,"lng":120.5914239}	2021-03-17 07:09:30.326+00
2449	8	6	{"lat":15.1519241,"lng":120.5916316}	2021-03-17 07:09:35.313+00
2450	8	6	{"lat":15.1523342,"lng":120.5918332}	2021-03-17 07:09:40.324+00
2451	8	6	{"lat":15.1526314,"lng":120.5919963}	2021-03-17 07:09:45.375+00
2452	8	6	{"lat":15.1525937,"lng":120.5919852}	2021-03-17 07:09:50.333+00
2453	8	6	{"lat":15.1525771,"lng":120.5919822}	2021-03-17 07:09:55.318+00
2454	8	6	{"lat":15.1525918,"lng":120.5919844}	2021-03-17 07:10:00.349+00
2455	8	6	{"lat":15.152651,"lng":120.5920291}	2021-03-17 07:10:05.25+00
2456	8	6	{"lat":15.1532667,"lng":120.5920913}	2021-03-17 07:10:10.318+00
2457	8	6	{"lat":15.1539269,"lng":120.5921206}	2021-03-17 07:10:15.332+00
2458	8	6	{"lat":15.1546636,"lng":120.5921919}	2021-03-17 07:10:20.288+00
2459	8	6	{"lat":15.155353,"lng":120.5922459}	2021-03-17 07:10:25.291+00
2460	8	6	{"lat":15.1559508,"lng":120.5922772}	2021-03-17 07:10:30.347+00
2461	8	6	{"lat":15.156463,"lng":120.5923017}	2021-03-17 07:10:35.26+00
2462	8	6	{"lat":15.1569446,"lng":120.5923344}	2021-03-17 07:10:40.254+00
2463	8	6	{"lat":15.1574049,"lng":120.5923322}	2021-03-17 07:10:45.273+00
2464	8	6	{"lat":15.157815,"lng":120.5922956}	2021-03-17 07:10:50.246+00
2465	8	6	{"lat":15.1581954,"lng":120.5922254}	2021-03-17 07:10:55.317+00
2466	8	6	{"lat":15.1583682,"lng":120.5921987}	2021-03-17 07:11:00.311+00
2467	8	6	{"lat":15.1584533,"lng":120.5921702}	2021-03-17 07:11:05.248+00
2468	8	6	{"lat":15.158594,"lng":120.59213}	2021-03-17 07:11:10.337+00
2469	8	6	{"lat":15.1590478,"lng":120.5919955}	2021-03-17 07:11:15.327+00
2470	8	6	{"lat":15.1593978,"lng":120.5919069}	2021-03-17 07:11:20.252+00
2471	8	6	{"lat":15.1597842,"lng":120.5918037}	2021-03-17 07:11:25.394+00
2472	8	6	{"lat":15.1602762,"lng":120.5917065}	2021-03-17 07:11:31.335+00
2473	8	6	{"lat":15.1606936,"lng":120.5916289}	2021-03-17 07:11:35.341+00
2474	8	6	{"lat":15.1613011,"lng":120.5914889}	2021-03-17 07:11:40.325+00
2475	8	6	{"lat":15.1619273,"lng":120.5913373}	2021-03-17 07:11:45.302+00
2476	8	6	{"lat":15.1624038,"lng":120.5912226}	2021-03-17 07:11:50.312+00
2477	8	6	{"lat":15.1627419,"lng":120.5911261}	2021-03-17 07:11:55.447+00
2478	8	6	{"lat":15.1630532,"lng":120.5910596}	2021-03-17 07:12:00.257+00
2479	8	6	{"lat":15.1633269,"lng":120.5909965}	2021-03-17 07:12:05.348+00
2480	8	6	{"lat":15.1636237,"lng":120.5909179}	2021-03-17 07:12:10.334+00
2481	8	6	{"lat":15.1638863,"lng":120.5908544}	2021-03-17 07:12:15.319+00
2482	8	6	{"lat":15.1640353,"lng":120.5908141}	2021-03-17 07:12:20.364+00
2483	8	6	{"lat":15.1644633,"lng":120.5906926}	2021-03-17 07:12:25.33+00
2484	8	6	{"lat":15.1646668,"lng":120.5906608}	2021-03-17 07:12:30.403+00
2485	8	6	{"lat":15.1646223,"lng":120.590686}	2021-03-17 07:12:34.55+00
2486	8	6	{"lat":15.1644447,"lng":120.5907456}	2021-03-17 07:12:39.434+00
2487	8	6	{"lat":15.1640966,"lng":120.5908265}	2021-03-17 07:12:44.422+00
2488	8	6	{"lat":15.1639381,"lng":120.5908686}	2021-03-17 07:12:49.341+00
2489	8	6	{"lat":15.1637429,"lng":120.5909251}	2021-03-17 07:12:54.407+00
2490	8	6	{"lat":15.1635462,"lng":120.5909749}	2021-03-17 07:12:59.346+00
2491	8	6	{"lat":15.1634352,"lng":120.5909982}	2021-03-17 07:13:04.307+00
2492	8	6	{"lat":15.1632271,"lng":120.591042}	2021-03-17 07:13:09.56+00
2493	8	6	{"lat":15.1630887,"lng":120.5910748}	2021-03-17 07:13:14.45+00
2494	8	6	{"lat":15.1629919,"lng":120.5910993}	2021-03-17 07:13:19.481+00
2495	8	6	{"lat":15.1628676,"lng":120.5911346}	2021-03-17 07:13:24.456+00
2496	8	6	{"lat":15.1627747,"lng":120.5911619}	2021-03-17 07:13:29.45+00
2497	8	6	{"lat":15.162763,"lng":120.5911633}	2021-03-17 07:13:34.447+00
2498	8	6	{"lat":15.1627687,"lng":120.5911644}	2021-03-17 07:13:39.806+00
2499	8	6	{"lat":15.16274,"lng":120.5911712}	2021-03-17 07:13:44.98+00
2500	8	6	{"lat":15.1626862,"lng":120.5911906}	2021-03-17 07:13:49.48+00
2501	8	6	{"lat":15.1626629,"lng":120.5912014}	2021-03-17 07:13:56.042+00
2502	8	6	{"lat":15.1626556,"lng":120.5912015}	2021-03-17 07:14:02.602+00
2503	8	6	{"lat":15.1626632,"lng":120.5911968}	2021-03-17 07:14:04.345+00
2504	8	6	{"lat":15.1626617,"lng":120.5911916}	2021-03-17 07:14:09.394+00
2505	8	6	{"lat":15.1626508,"lng":120.5911926}	2021-03-17 07:14:14.338+00
2506	8	6	{"lat":15.1626208,"lng":120.5911823}	2021-03-17 07:14:20.296+00
2507	8	6	{"lat":15.162634,"lng":120.5911624}	2021-03-17 07:14:26.088+00
2508	8	6	{"lat":15.1626437,"lng":120.5911506}	2021-03-17 07:14:29.346+00
2509	8	6	{"lat":15.1626867,"lng":120.5911389}	2021-03-17 07:14:35.668+00
2510	8	6	{"lat":15.1627458,"lng":120.5911231}	2021-03-17 07:14:40.051+00
2511	8	6	{"lat":15.1628276,"lng":120.5911027}	2021-03-17 07:14:45.218+00
2512	8	6	{"lat":15.1627859,"lng":120.5911152}	2021-03-17 07:14:50.851+00
2513	8	6	{"lat":15.1628551,"lng":120.5910671}	2021-03-17 07:14:55.223+00
2514	8	6	{"lat":15.1631909,"lng":120.5909148}	2021-03-17 07:15:00.764+00
2515	8	6	{"lat":15.1640033,"lng":120.5906635}	2021-03-17 07:15:05.874+00
2516	8	6	{"lat":15.1645194,"lng":120.5905706}	2021-03-17 07:15:10.535+00
2517	8	6	{"lat":15.1643687,"lng":120.5907993}	2021-03-17 07:15:15.453+00
2518	8	6	{"lat":15.1638739,"lng":120.590928}	2021-03-17 07:15:20.328+00
2519	8	6	{"lat":15.1638561,"lng":120.5909177}	2021-03-17 07:15:25.305+00
2520	8	6	{"lat":15.1638664,"lng":120.5909171}	2021-03-17 07:15:30.276+00
2521	9	5	{"lat":15.1626386,"lng":120.5910329}	2021-03-17 07:13:58.361+00
2522	9	5	{"lat":15.1626494,"lng":120.5911951}	2021-03-17 07:14:01.992+00
2523	9	5	{"lat":15.1626233,"lng":120.5911693}	2021-03-17 07:14:06.948+00
2524	9	5	{"lat":15.162725,"lng":120.5911393}	2021-03-17 07:14:11.604+00
2525	9	5	{"lat":15.1629268,"lng":120.591079}	2021-03-17 07:14:16.615+00
2526	9	5	{"lat":15.1631312,"lng":120.5910135}	2021-03-17 07:14:21.585+00
2527	9	5	{"lat":15.1633138,"lng":120.590946}	2021-03-17 07:14:26.587+00
2528	9	5	{"lat":15.1635131,"lng":120.5908878}	2021-03-17 07:14:31.616+00
2529	9	5	{"lat":15.1636771,"lng":120.590851}	2021-03-17 07:14:36.592+00
2530	9	5	{"lat":15.1638686,"lng":120.5908054}	2021-03-17 07:14:41.603+00
2531	9	5	{"lat":15.1639761,"lng":120.5907853}	2021-03-17 07:14:46.594+00
2532	9	5	{"lat":15.1639681,"lng":120.5907776}	2021-03-17 07:14:51.654+00
2533	9	5	{"lat":15.1639642,"lng":120.5907761}	2021-03-17 07:14:56.659+00
2534	9	5	{"lat":15.163965,"lng":120.5907805}	2021-03-17 07:15:01.629+00
2535	9	5	{"lat":15.1639173,"lng":120.5907857}	2021-03-17 07:15:06.677+00
2536	9	5	{"lat":15.1638606,"lng":120.5907972}	2021-03-17 07:15:11.682+00
2537	9	5	{"lat":15.1638572,"lng":120.5907993}	2021-03-17 07:15:16.645+00
2538	9	5	{"lat":15.163858,"lng":120.5908003}	2021-03-17 07:15:21.79+00
2539	9	5	{"lat":15.163859,"lng":120.5908042}	2021-03-17 07:15:27.031+00
2540	9	5	{"lat":15.1638688,"lng":120.5908012}	2021-03-17 07:15:31.993+00
2541	9	5	{"lat":15.1638637,"lng":120.5907935}	2021-03-17 07:15:37.016+00
2542	9	5	{"lat":15.1638567,"lng":120.5907897}	2021-03-17 07:15:42.025+00
2543	9	5	{"lat":15.1638534,"lng":120.5907942}	2021-03-17 07:15:46.933+00
2544	9	5	{"lat":15.1638534,"lng":120.5907942}	2021-03-17 07:15:47.691+00
2545	9	\N	{"lat":"15.1638534","lng":"120.5907942"}	2021-03-17 07:15:50.297+00
2546	9	\N	{"lat":"15.1656025","lng":"120.5875688"}	2021-03-17 07:18:05.231+00
2547	9	\N	{"lat":"15.1663534","lng":"120.5873524"}	2021-03-17 07:18:33.345+00
2548	5	26	{"lat":15.1626669,"lng":120.5565622}	2021-03-17 06:42:30.215+00
2549	5	26	{"lat":15.1626679,"lng":120.5565613}	2021-03-17 06:42:35.242+00
2550	5	26	{"lat":15.1626679,"lng":120.5565613}	2021-03-17 06:42:40.279+00
2551	5	26	{"lat":15.1626674,"lng":120.556562}	2021-03-17 06:42:45.251+00
2552	5	26	{"lat":15.1626677,"lng":120.5565635}	2021-03-17 06:42:50.279+00
2553	5	26	{"lat":15.1626729,"lng":120.5565654}	2021-03-17 06:42:55.273+00
2554	5	26	{"lat":15.1626802,"lng":120.5565583}	2021-03-17 06:43:00.206+00
2555	5	26	{"lat":15.1626739,"lng":120.5565623}	2021-03-17 06:43:05.24+00
2556	5	26	{"lat":15.1626782,"lng":120.556563}	2021-03-17 06:43:10.248+00
2557	5	26	{"lat":15.1626704,"lng":120.5565602}	2021-03-17 06:43:15.222+00
2558	5	26	{"lat":15.1626718,"lng":120.5565627}	2021-03-17 06:43:20.259+00
2559	5	26	{"lat":15.1626756,"lng":120.5565641}	2021-03-17 06:43:25.256+00
2560	5	26	{"lat":15.1626745,"lng":120.5565606}	2021-03-17 06:43:30.219+00
2561	5	26	{"lat":15.162675,"lng":120.5565602}	2021-03-17 06:43:35.251+00
2562	5	26	{"lat":15.1626739,"lng":120.5565594}	2021-03-17 06:43:40.259+00
2563	5	26	{"lat":15.1626726,"lng":120.556566}	2021-03-17 06:43:45.233+00
2564	5	26	{"lat":15.1626746,"lng":120.5565675}	2021-03-17 06:43:50.25+00
2565	5	26	{"lat":15.1626746,"lng":120.5565675}	2021-03-17 06:43:53.643+00
2566	5	26	{"lat":15.1626746,"lng":120.5565675}	2021-03-17 06:43:58.654+00
2567	5	26	{"lat":15.1626746,"lng":120.5565675}	2021-03-17 06:44:26.788+00
2568	5	26	{"lat":15.1626746,"lng":120.5565675}	2021-03-17 06:44:58.507+00
2569	5	26	{"lat":15.1626746,"lng":120.5565675}	2021-03-17 06:45:22.867+00
2570	5	26	{"lat":15.1626746,"lng":120.5565675}	2021-03-17 06:47:50.142+00
2571	5	26	{"lat":15.1626746,"lng":120.5565675}	2021-03-17 06:50:29.775+00
2572	5	26	{"lat":15.1626746,"lng":120.5565675}	2021-03-17 06:51:00.548+00
2573	5	26	{"lat":15.1626746,"lng":120.5565675}	2021-03-17 06:52:46.867+00
2574	5	26	{"lat":15.1365817,"lng":120.5878295}	2021-03-17 06:58:38.01+00
2575	5	26	{"lat":15.1365425,"lng":120.5878457}	2021-03-17 06:58:47.423+00
2576	5	26	{"lat":15.1365425,"lng":120.5878457}	2021-03-17 06:58:47.909+00
2577	5	26	{"lat":15.1365767,"lng":120.5878329}	2021-03-17 06:58:57.456+00
2578	5	26	{"lat":15.1365767,"lng":120.5878329}	2021-03-17 06:58:57.942+00
2579	5	26	{"lat":15.1365758,"lng":120.5878383}	2021-03-17 06:59:07.39+00
2580	5	26	{"lat":15.1365758,"lng":120.5878383}	2021-03-17 06:59:07.936+00
2581	5	26	{"lat":15.1364908,"lng":120.5878594}	2021-03-17 06:59:17.436+00
2582	5	26	{"lat":15.1364908,"lng":120.5878594}	2021-03-17 06:59:17.932+00
2583	5	26	{"lat":15.13638,"lng":120.5878938}	2021-03-17 06:59:27.425+00
2584	5	26	{"lat":15.13638,"lng":120.5878938}	2021-03-17 06:59:27.906+00
2585	5	26	{"lat":15.1365186,"lng":120.5878496}	2021-03-17 06:59:33.459+00
2586	5	26	{"lat":15.1365579,"lng":120.5878425}	2021-03-17 06:59:42.486+00
2587	5	26	{"lat":15.1365579,"lng":120.5878425}	2021-03-17 06:59:42.928+00
2588	5	26	{"lat":15.1365579,"lng":120.5878425}	2021-03-17 06:59:52.918+00
2589	5	26	{"lat":15.1365579,"lng":120.5878425}	2021-03-17 06:59:58.542+00
2590	5	26	{"lat":15.1365579,"lng":120.5878425}	2021-03-17 07:00:03.483+00
2591	5	26	{"lat":15.1365579,"lng":120.5878425}	2021-03-17 07:00:08.481+00
2592	5	26	{"lat":15.1365579,"lng":120.5878425}	2021-03-17 07:00:37.394+00
2593	5	26	{"lat":15.1365579,"lng":120.5878425}	2021-03-17 07:01:08.607+00
2594	5	26	{"lat":15.1365579,"lng":120.5878425}	2021-03-17 07:01:13.594+00
2595	5	26	{"lat":15.1365579,"lng":120.5878425}	2021-03-17 07:01:18.587+00
2596	5	26	{"lat":15.1365579,"lng":120.5878425}	2021-03-17 07:01:23.592+00
2597	5	26	{"lat":15.1365579,"lng":120.5878425}	2021-03-17 07:01:28.586+00
2598	5	26	{"lat":15.1365579,"lng":120.5878425}	2021-03-17 07:01:33.616+00
2599	5	26	{"lat":15.1364189,"lng":120.5881877}	2021-03-17 07:01:41.951+00
2600	5	26	{"lat":15.1364189,"lng":120.5881877}	2021-03-17 07:01:43.604+00
2601	5	26	{"lat":15.1363342,"lng":120.5880795}	2021-03-17 07:01:51.682+00
2602	5	26	{"lat":15.1363342,"lng":120.5880795}	2021-03-17 07:01:53.615+00
2603	5	26	{"lat":15.1363342,"lng":120.5880795}	2021-03-17 07:02:03.896+00
2604	5	26	{"lat":15.1363342,"lng":120.5880795}	2021-03-17 07:02:19.796+00
2605	5	26	{"lat":15.1363342,"lng":120.5880795}	2021-03-17 07:02:24.836+00
2606	5	26	{"lat":15.1363342,"lng":120.5880795}	2021-03-17 07:02:56.749+00
2607	5	26	{"lat":15.1363342,"lng":120.5880795}	2021-03-17 07:03:46.552+00
2608	5	26	{"lat":15.1363342,"lng":120.5880795}	2021-03-17 07:04:21.875+00
2609	5	26	{"lat":15.1363342,"lng":120.5880795}	2021-03-17 07:06:23.084+00
2610	5	26	{"lat":15.1363342,"lng":120.5880795}	2021-03-17 07:06:40.912+00
2611	5	26	{"lat":15.1363342,"lng":120.5880795}	2021-03-17 07:07:35.97+00
2612	5	26	{"lat":15.1363342,"lng":120.5880795}	2021-03-17 07:07:41.017+00
2613	5	26	{"lat":15.1363342,"lng":120.5880795}	2021-03-17 07:09:00.883+00
2614	5	26	{"lat":15.1363342,"lng":120.5880795}	2021-03-17 07:10:36.755+00
2615	5	26	{"lat":15.1363342,"lng":120.5880795}	2021-03-17 07:10:41.799+00
2616	5	26	{"lat":15.1672223,"lng":120.5799973}	2021-03-17 07:17:46.817+00
2617	5	26	{"lat":15.1672223,"lng":120.5799973}	2021-03-17 07:17:48.046+00
2618	5	26	{"lat":15.1672673,"lng":120.5800062}	2021-03-17 07:17:57.64+00
2619	5	26	{"lat":15.1672673,"lng":120.5800062}	2021-03-17 07:17:58.034+00
2620	5	26	{"lat":15.1673116,"lng":120.5799968}	2021-03-17 07:18:04.414+00
2621	5	26	{"lat":15.1673379,"lng":120.579992}	2021-03-17 07:18:08.183+00
2622	5	26	{"lat":15.1671118,"lng":120.5801395}	2021-03-17 07:18:18.584+00
2623	5	26	{"lat":15.1671118,"lng":120.5801395}	2021-03-17 07:18:23.004+00
2624	5	26	{"lat":15.1668799,"lng":120.5802736}	2021-03-17 07:18:28.23+00
2625	5	26	{"lat":15.1662951,"lng":120.5811271}	2021-03-17 07:18:36.782+00
2626	5	26	{"lat":15.1662951,"lng":120.5811271}	2021-03-17 07:18:38.026+00
2627	5	26	{"lat":15.1673761,"lng":120.5799438}	2021-03-17 07:18:47.146+00
2628	5	26	{"lat":15.1673761,"lng":120.5799438}	2021-03-17 07:18:47.611+00
2629	5	\N	{"lat":"15.1673761","lng":"120.5799438"}	2021-03-17 07:18:48.731+00
2630	9	\N	{"lat":"15.1666655","lng":"120.5863914"}	2021-03-17 07:19:03.197+00
2631	8	\N	{"lat":"15.1668417","lng":"120.5861809"}	2021-03-17 07:19:13.59+00
2632	5	\N	{"lat":"15.1671098","lng":"120.5801552"}	2021-03-17 07:19:23.219+00
2633	9	\N	{"lat":"15.1670089","lng":"120.5858219"}	2021-03-17 07:19:29.852+00
2634	8	\N	{"lat":"15.1668368","lng":"120.5859693"}	2021-03-17 07:19:52.937+00
2635	5	\N	{"lat":"15.1673994","lng":"120.5799843"}	2021-03-17 07:19:53.305+00
2636	9	\N	{"lat":"15.1667007","lng":"120.5844013"}	2021-03-17 07:20:02.503+00
2637	8	\N	{"lat":"15.1666971","lng":"120.5844517"}	2021-03-17 07:20:17.007+00
2638	9	\N	{"lat":"15.166546","lng":"120.5831584"}	2021-03-17 07:20:31.783+00
2639	1	10	{"lat":15.1440693,"lng":120.5595698}	2021-03-17 07:17:13.664+00
2640	1	10	{"lat":15.1445392,"lng":120.5591203}	2021-03-17 07:17:17.456+00
2641	1	10	{"lat":15.145063,"lng":120.5593635}	2021-03-17 07:17:27.956+00
2642	1	10	{"lat":15.146291,"lng":120.5595655}	2021-03-17 07:17:37.058+00
2643	1	10	{"lat":15.1463368,"lng":120.5595717}	2021-03-17 07:17:41.784+00
2644	1	10	{"lat":15.1476205,"lng":120.5595046}	2021-03-17 07:17:47.546+00
2645	1	10	{"lat":15.1489076,"lng":120.5593952}	2021-03-17 07:17:56.692+00
2646	1	10	{"lat":15.1489899,"lng":120.5593892}	2021-03-17 07:18:01.243+00
2647	1	10	{"lat":15.150174,"lng":120.5594227}	2021-03-17 07:18:07.398+00
2648	1	10	{"lat":15.1506625,"lng":120.5593821}	2021-03-17 07:18:12.495+00
2649	1	10	{"lat":15.1517341,"lng":120.5594386}	2021-03-17 07:18:19.72+00
2650	1	10	{"lat":15.1517341,"lng":120.5594386}	2021-03-17 07:18:21.136+00
2651	1	10	{"lat":15.1520719,"lng":120.5594507}	2021-03-17 07:18:26.247+00
2652	1	10	{"lat":15.153294,"lng":120.5602242}	2021-03-17 07:18:32.413+00
2653	1	10	{"lat":15.1541922,"lng":120.5603597}	2021-03-17 07:18:40.697+00
2654	1	10	{"lat":15.1541922,"lng":120.5603597}	2021-03-17 07:18:41.156+00
2655	1	10	{"lat":15.1543926,"lng":120.5603886}	2021-03-17 07:18:46.269+00
2656	1	10	{"lat":15.1557314,"lng":120.5607013}	2021-03-17 07:18:52.482+00
2657	1	10	{"lat":15.1566302,"lng":120.5600875}	2021-03-17 07:18:58.847+00
2658	1	10	{"lat":15.1572886,"lng":120.5599244}	2021-03-17 07:19:03.802+00
2659	1	10	{"lat":15.1578614,"lng":120.5598081}	2021-03-17 07:19:08.822+00
2660	1	10	{"lat":15.1582213,"lng":120.5594644}	2021-03-17 07:19:13.754+00
2661	1	10	{"lat":15.1584102,"lng":120.5589908}	2021-03-17 07:19:19.762+00
2662	1	10	{"lat":15.1584102,"lng":120.5589908}	2021-03-17 07:19:21.143+00
2663	1	10	{"lat":15.1586662,"lng":120.5584407}	2021-03-17 07:19:27.668+00
2664	1	10	{"lat":15.1589894,"lng":120.5585045}	2021-03-17 07:19:33.81+00
2665	1	10	{"lat":15.159288,"lng":120.5584289}	2021-03-17 07:19:39.289+00
2666	1	10	{"lat":15.159288,"lng":120.5584289}	2021-03-17 07:19:41.142+00
2667	1	10	{"lat":15.1598687,"lng":120.5582969}	2021-03-17 07:19:47.381+00
2668	1	10	{"lat":15.1602756,"lng":120.5581624}	2021-03-17 07:19:54.731+00
2669	1	10	{"lat":15.1602756,"lng":120.5581624}	2021-03-17 07:19:56.155+00
2670	1	10	{"lat":15.1604276,"lng":120.5581364}	2021-03-17 07:20:01.277+00
2671	1	10	{"lat":15.1610717,"lng":120.5579653}	2021-03-17 07:20:07.489+00
2672	1	10	{"lat":15.1614009,"lng":120.5578007}	2021-03-17 07:20:13.871+00
2673	1	10	{"lat":15.1617242,"lng":120.5576951}	2021-03-17 07:20:19.711+00
2674	1	10	{"lat":15.1617242,"lng":120.5576951}	2021-03-17 07:20:21.117+00
2675	1	10	{"lat":15.1623424,"lng":120.5574809}	2021-03-17 07:20:28.854+00
2676	1	10	{"lat":15.1628511,"lng":120.557283}	2021-03-17 07:20:33.815+00
2677	1	10	{"lat":15.1630199,"lng":120.557018}	2021-03-17 07:20:39.326+00
2678	1	10	{"lat":15.1630199,"lng":120.557018}	2021-03-17 07:20:41.139+00
2679	1	10	{"lat":15.162776,"lng":120.5565604}	2021-03-17 07:20:49.024+00
2680	1	10	{"lat":15.1626889,"lng":120.5564969}	2021-03-17 07:20:53.793+00
2681	1	10	{"lat":15.1626851,"lng":120.5564666}	2021-03-17 07:20:58.795+00
2682	1	10	{"lat":15.1626714,"lng":120.5565582}	2021-03-17 07:21:07.419+00
2683	1	10	{"lat":15.1626726,"lng":120.5565619}	2021-03-17 07:21:17.441+00
2684	1	10	{"lat":15.1626575,"lng":120.5565578}	2021-03-17 07:21:22.493+00
2685	1	10	{"lat":15.1625661,"lng":120.5565146}	2021-03-17 07:21:32.394+00
2686	1	10	{"lat":15.1625606,"lng":120.5565059}	2021-03-17 07:21:37.512+00
2687	1	10	{"lat":15.1625499,"lng":120.5565083}	2021-03-17 07:21:47.399+00
2688	1	10	{"lat":15.1625559,"lng":120.5565082}	2021-03-17 07:21:52.43+00
2689	1	10	{"lat":15.1625598,"lng":120.5565006}	2021-03-17 07:22:02.445+00
2690	1	10	{"lat":15.162564,"lng":120.5565005}	2021-03-17 07:22:07.43+00
2691	1	10	{"lat":15.1625691,"lng":120.5564936}	2021-03-17 07:22:17.389+00
2692	1	10	{"lat":15.1625594,"lng":120.5564938}	2021-03-17 07:22:27.356+00
2693	1	10	{"lat":15.1625596,"lng":120.5565004}	2021-03-17 07:22:32.423+00
2694	1	10	{"lat":15.1625619,"lng":120.5564968}	2021-03-17 07:22:42.395+00
2695	1	10	{"lat":15.162561,"lng":120.5564985}	2021-03-17 07:22:52.429+00
2696	1	10	{"lat":15.162561,"lng":120.5564985}	2021-03-17 07:22:54.117+00
2697	1	\N	{"lat":"15.1625625","lng":"120.5564962"}	2021-03-17 07:23:02.372+00
2698	1	\N	{"lat":"15.16256","lng":"120.5564939"}	2021-03-17 07:23:18.796+00
2699	1	\N	{"lat":"15.1625684","lng":"120.5565035"}	2021-03-17 07:23:34.024+00
2700	10	4	{"lat":15.1626668,"lng":120.5565638}	2021-03-17 06:35:03.206+00
2701	10	4	{"lat":15.1626673,"lng":120.5565628}	2021-03-17 06:35:08.189+00
2702	10	4	{"lat":15.1626696,"lng":120.5565621}	2021-03-17 06:35:13.224+00
2703	10	4	{"lat":15.1626706,"lng":120.556564}	2021-03-17 06:35:18.434+00
2704	10	4	{"lat":15.1626705,"lng":120.5565635}	2021-03-17 06:35:23.169+00
2705	10	4	{"lat":15.1626686,"lng":120.5565639}	2021-03-17 06:35:28.195+00
2706	10	4	{"lat":15.1626723,"lng":120.5565647}	2021-03-17 06:35:33.116+00
2707	10	4	{"lat":15.1626684,"lng":120.5565606}	2021-03-17 06:35:38.256+00
2708	10	4	{"lat":15.1626691,"lng":120.5565607}	2021-03-17 06:35:43.354+00
2709	10	4	{"lat":15.1626677,"lng":120.556561}	2021-03-17 06:35:48.199+00
2710	10	4	{"lat":15.1626727,"lng":120.5565614}	2021-03-17 06:35:53.198+00
2711	10	4	{"lat":15.1626676,"lng":120.5565606}	2021-03-17 06:35:58.246+00
2712	10	4	{"lat":15.1626745,"lng":120.5565611}	2021-03-17 06:36:03.415+00
2713	10	4	{"lat":15.1626691,"lng":120.5565618}	2021-03-17 06:36:08.137+00
2714	10	4	{"lat":15.1626701,"lng":120.5565604}	2021-03-17 06:36:13.128+00
2715	10	4	{"lat":15.1626686,"lng":120.5565611}	2021-03-17 06:36:18.135+00
2716	10	4	{"lat":15.1626677,"lng":120.5565607}	2021-03-17 06:36:23.231+00
2717	10	4	{"lat":15.1626631,"lng":120.5565598}	2021-03-17 06:36:28.377+00
2718	10	4	{"lat":15.1626683,"lng":120.5565619}	2021-03-17 06:36:33.195+00
2719	10	4	{"lat":15.1626675,"lng":120.5565614}	2021-03-17 06:36:38.196+00
2720	10	4	{"lat":15.1626654,"lng":120.5565609}	2021-03-17 06:36:43.161+00
2721	10	4	{"lat":15.1626691,"lng":120.5565609}	2021-03-17 06:36:48.512+00
2722	10	4	{"lat":15.1626721,"lng":120.5565611}	2021-03-17 06:36:53.241+00
2723	10	4	{"lat":15.1626677,"lng":120.5565625}	2021-03-17 06:36:58.159+00
2724	10	4	{"lat":15.1626672,"lng":120.5565639}	2021-03-17 06:37:03.194+00
2725	10	4	{"lat":15.1626717,"lng":120.5565635}	2021-03-17 06:37:08.198+00
2726	10	4	{"lat":15.1626663,"lng":120.5565639}	2021-03-17 06:37:13.413+00
2727	10	4	{"lat":15.1626649,"lng":120.5565601}	2021-03-17 06:37:18.143+00
2728	10	4	{"lat":15.1626649,"lng":120.5565601}	2021-03-17 06:37:22.165+00
2729	10	4	{"lat":15.1626649,"lng":120.5565601}	2021-03-17 06:37:27.191+00
2730	10	4	{"lat":15.1626649,"lng":120.5565601}	2021-03-17 06:37:32.204+00
2731	10	4	{"lat":15.1626649,"lng":120.5565601}	2021-03-17 06:37:37.217+00
2732	10	4	{"lat":15.1626649,"lng":120.5565601}	2021-03-17 06:38:01.221+00
2733	10	4	{"lat":15.1626649,"lng":120.5565601}	2021-03-17 06:38:15.061+00
2734	10	4	{"lat":15.1626649,"lng":120.5565601}	2021-03-17 06:38:27.723+00
2735	10	4	{"lat":15.1626649,"lng":120.5565601}	2021-03-17 06:38:32.371+00
2736	10	4	{"lat":15.1626649,"lng":120.5565601}	2021-03-17 06:38:37.336+00
2737	10	4	{"lat":15.1626649,"lng":120.5565601}	2021-03-17 06:38:42.366+00
2738	10	4	{"lat":15.1626649,"lng":120.5565601}	2021-03-17 06:38:47.364+00
2739	10	4	{"lat":15.1626649,"lng":120.5565601}	2021-03-17 06:38:52.36+00
2740	10	4	{"lat":15.1626649,"lng":120.5565601}	2021-03-17 06:38:57.365+00
2741	10	4	{"lat":15.1626649,"lng":120.5565601}	2021-03-17 06:39:02.365+00
2742	10	4	{"lat":15.1626649,"lng":120.5565601}	2021-03-17 06:39:39.171+00
2743	10	4	{"lat":15.1626649,"lng":120.5565601}	2021-03-17 06:40:04.027+00
2744	10	4	{"lat":15.1626649,"lng":120.5565601}	2021-03-17 06:40:09.028+00
2745	10	4	{"lat":15.1626649,"lng":120.5565601}	2021-03-17 06:40:19.085+00
2746	10	4	{"lat":15.1626649,"lng":120.5565601}	2021-03-17 06:40:24.018+00
2747	10	4	{"lat":15.1626652,"lng":120.5565595}	2021-03-17 06:40:29.687+00
2748	10	4	{"lat":15.1626711,"lng":120.5565648}	2021-03-17 06:40:35.052+00
2749	10	4	{"lat":15.1626701,"lng":120.5565595}	2021-03-17 06:40:39.987+00
2750	10	4	{"lat":15.1626701,"lng":120.5565595}	2021-03-17 06:40:44.613+00
2751	10	4	{"lat":15.1626701,"lng":120.5565595}	2021-03-17 06:41:24.238+00
2752	10	4	{"lat":15.1626701,"lng":120.5565595}	2021-03-17 06:41:29.235+00
2753	10	4	{"lat":15.1626701,"lng":120.5565595}	2021-03-17 06:41:51.086+00
2754	10	4	{"lat":15.1626701,"lng":120.5565595}	2021-03-17 06:43:23.447+00
2755	10	4	{"lat":15.1626701,"lng":120.5565595}	2021-03-17 06:43:32.903+00
2756	10	4	{"lat":15.1626701,"lng":120.5565595}	2021-03-17 06:44:01.715+00
2757	10	4	{"lat":15.1626701,"lng":120.5565595}	2021-03-17 06:45:31.415+00
2758	10	4	{"lat":15.1626701,"lng":120.5565595}	2021-03-17 06:45:36.415+00
2759	10	4	{"lat":15.1626701,"lng":120.5565595}	2021-03-17 06:45:41.414+00
2760	10	4	{"lat":15.1626701,"lng":120.5565595}	2021-03-17 06:46:13.834+00
2761	10	4	{"lat":15.1626701,"lng":120.5565595}	2021-03-17 06:47:33.576+00
2762	10	4	{"lat":15.1626701,"lng":120.5565595}	2021-03-17 06:47:38.576+00
2763	10	4	{"lat":15.1626701,"lng":120.5565595}	2021-03-17 06:47:43.576+00
2764	10	4	{"lat":15.1626701,"lng":120.5565595}	2021-03-17 06:48:19.253+00
2765	10	4	{"lat":15.1626701,"lng":120.5565595}	2021-03-17 06:48:54.535+00
2766	10	4	{"lat":15.1626701,"lng":120.5565595}	2021-03-17 06:49:37.297+00
2767	10	4	{"lat":15.1626701,"lng":120.5565595}	2021-03-17 06:49:42.283+00
2768	10	4	{"lat":15.1626701,"lng":120.5565595}	2021-03-17 06:50:14.254+00
2769	10	4	{"lat":15.1626701,"lng":120.5565595}	2021-03-17 06:50:27.633+00
2770	10	4	{"lat":15.1626701,"lng":120.5565595}	2021-03-17 06:50:33.087+00
2771	10	4	{"lat":15.1380119,"lng":120.5870697}	2021-03-17 06:53:52.942+00
2772	10	4	{"lat":15.1380119,"lng":120.5870697}	2021-03-17 06:54:19.075+00
2773	10	4	{"lat":15.1380119,"lng":120.5870697}	2021-03-17 06:54:56.198+00
2774	10	4	{"lat":15.1380119,"lng":120.5870697}	2021-03-17 06:55:50.075+00
2775	10	4	{"lat":15.1380119,"lng":120.5870697}	2021-03-17 06:55:55.038+00
2776	10	4	{"lat":15.1380119,"lng":120.5870697}	2021-03-17 06:56:00.048+00
2777	10	4	{"lat":15.1380119,"lng":120.5870697}	2021-03-17 06:56:05.028+00
2778	10	4	{"lat":15.1363943,"lng":120.5879684}	2021-03-17 06:56:44.618+00
2779	10	4	{"lat":15.1363943,"lng":120.5879684}	2021-03-17 06:56:45.136+00
2780	10	4	{"lat":15.1363943,"lng":120.5879684}	2021-03-17 06:56:50.118+00
2781	10	4	{"lat":15.1364041,"lng":120.5881482}	2021-03-17 06:56:57.553+00
2782	10	4	{"lat":15.1364041,"lng":120.5881482}	2021-03-17 06:57:00.139+00
2783	10	4	{"lat":15.1364041,"lng":120.5881482}	2021-03-17 06:57:05.153+00
2784	10	4	{"lat":15.1364041,"lng":120.5881482}	2021-03-17 06:57:10.156+00
2785	10	4	{"lat":15.1364041,"lng":120.5881482}	2021-03-17 06:57:15.158+00
2786	10	4	{"lat":15.1364041,"lng":120.5881482}	2021-03-17 06:57:20.134+00
2787	10	4	{"lat":15.1363134,"lng":120.5881183}	2021-03-17 06:57:25.319+00
2788	10	4	{"lat":15.1362717,"lng":120.5880751}	2021-03-17 06:57:30.923+00
2789	10	4	{"lat":15.1362576,"lng":120.5880571}	2021-03-17 06:57:36.506+00
2790	10	4	{"lat":15.1362493,"lng":120.5880262}	2021-03-17 06:57:41.499+00
2791	10	4	{"lat":15.1362655,"lng":120.5879907}	2021-03-17 06:57:46.552+00
2792	10	4	{"lat":15.1363093,"lng":120.5879354}	2021-03-17 06:57:51.521+00
2793	10	4	{"lat":15.1363259,"lng":120.5879087}	2021-03-17 06:57:56.425+00
2794	10	4	{"lat":15.1363351,"lng":120.5878932}	2021-03-17 06:58:00.301+00
2795	10	4	{"lat":15.1363449,"lng":120.5878755}	2021-03-17 06:58:05.266+00
2796	10	4	{"lat":15.1363525,"lng":120.587862}	2021-03-17 06:58:10.284+00
2797	10	4	{"lat":15.1363758,"lng":120.5880135}	2021-03-17 06:58:16.421+00
2798	10	4	{"lat":15.1363766,"lng":120.5880879}	2021-03-17 06:58:20.435+00
2799	10	4	{"lat":15.1363586,"lng":120.5881253}	2021-03-17 06:58:31.618+00
2800	10	4	{"lat":15.1363248,"lng":120.5880987}	2021-03-17 06:58:36.409+00
2801	10	4	{"lat":15.1362861,"lng":120.5880838}	2021-03-17 06:58:41.502+00
2802	10	4	{"lat":15.1362825,"lng":120.5880376}	2021-03-17 06:58:46.452+00
2803	10	4	{"lat":15.1362816,"lng":120.5879919}	2021-03-17 06:58:51.556+00
2804	10	4	{"lat":15.1363025,"lng":120.5879402}	2021-03-17 06:58:56.508+00
2805	10	4	{"lat":15.1363109,"lng":120.5879149}	2021-03-17 06:59:00.298+00
2806	10	4	{"lat":15.1363109,"lng":120.5879149}	2021-03-17 06:59:05.154+00
2807	10	4	{"lat":15.1360431,"lng":120.5885244}	2021-03-17 06:59:10.143+00
2808	10	4	{"lat":15.1360431,"lng":120.5885244}	2021-03-17 06:59:15.119+00
2809	10	4	{"lat":15.1360431,"lng":120.5885244}	2021-03-17 06:59:20.16+00
2810	10	4	{"lat":15.1360431,"lng":120.5885244}	2021-03-17 06:59:25.135+00
2811	10	4	{"lat":15.1360431,"lng":120.5885244}	2021-03-17 06:59:30.165+00
2812	10	4	{"lat":15.1365411,"lng":120.5878786}	2021-03-17 06:59:36.022+00
2813	10	4	{"lat":15.1365751,"lng":120.58784}	2021-03-17 06:59:41.144+00
2814	10	4	{"lat":15.1365542,"lng":120.587851}	2021-03-17 06:59:46.496+00
2815	10	4	{"lat":15.1365339,"lng":120.5878291}	2021-03-17 06:59:51.403+00
2816	10	4	{"lat":15.1364984,"lng":120.5878597}	2021-03-17 06:59:56.147+00
2817	10	4	{"lat":15.1365424,"lng":120.5878446}	2021-03-17 07:00:01.047+00
2818	10	4	{"lat":15.1365147,"lng":120.5878521}	2021-03-17 07:00:06.167+00
2819	10	4	{"lat":15.1365335,"lng":120.5878574}	2021-03-17 07:00:11.35+00
2820	10	4	{"lat":15.1365093,"lng":120.5878599}	2021-03-17 07:00:16.271+00
2821	10	4	{"lat":15.1365584,"lng":120.5878529}	2021-03-17 07:00:21.209+00
2822	10	4	{"lat":15.1365743,"lng":120.5878449}	2021-03-17 07:00:26.128+00
2823	10	4	{"lat":15.136576,"lng":120.5878469}	2021-03-17 07:00:31.045+00
2824	10	4	{"lat":15.1365439,"lng":120.5878596}	2021-03-17 07:00:36.468+00
2825	10	4	{"lat":15.1365689,"lng":120.5878454}	2021-03-17 07:00:41.587+00
2826	10	4	{"lat":15.1363883,"lng":120.587895}	2021-03-17 07:00:46.502+00
2827	10	4	{"lat":15.1363883,"lng":120.587895}	2021-03-17 07:00:50.153+00
2828	10	4	{"lat":15.1363883,"lng":120.587895}	2021-03-17 07:00:55.155+00
2829	10	4	{"lat":15.1363883,"lng":120.587895}	2021-03-17 07:01:00.118+00
2830	10	4	{"lat":15.1363883,"lng":120.587895}	2021-03-17 07:01:05.157+00
2831	10	4	{"lat":15.1363883,"lng":120.587895}	2021-03-17 07:01:10.148+00
2832	10	4	{"lat":15.1363883,"lng":120.587895}	2021-03-17 07:01:15.149+00
2833	10	4	{"lat":15.1363883,"lng":120.587895}	2021-03-17 07:01:20.154+00
2834	10	4	{"lat":15.1363883,"lng":120.587895}	2021-03-17 07:01:25.146+00
2835	10	4	{"lat":15.1363883,"lng":120.587895}	2021-03-17 07:01:30.151+00
2836	10	4	{"lat":15.1363883,"lng":120.587895}	2021-03-17 07:01:35.15+00
2837	10	4	{"lat":15.1363883,"lng":120.587895}	2021-03-17 07:01:40.108+00
2838	10	4	{"lat":15.1363503,"lng":120.588191}	2021-03-17 07:01:46.472+00
2839	10	4	{"lat":15.1363278,"lng":120.5882156}	2021-03-17 07:01:51.695+00
2840	10	4	{"lat":15.1363674,"lng":120.5881059}	2021-03-17 07:01:56.474+00
2841	10	4	{"lat":15.1363867,"lng":120.5881443}	2021-03-17 07:02:01.463+00
2842	10	4	{"lat":15.1363867,"lng":120.5881443}	2021-03-17 07:02:05.107+00
2843	10	4	{"lat":15.1363867,"lng":120.5881443}	2021-03-17 07:02:10.156+00
2844	10	4	{"lat":15.1363648,"lng":120.5881778}	2021-03-17 07:02:16.486+00
2845	10	4	{"lat":15.136302,"lng":120.5882238}	2021-03-17 07:02:21.406+00
2846	10	4	{"lat":15.1363643,"lng":120.5881893}	2021-03-17 07:02:26.581+00
2847	10	4	{"lat":15.1363448,"lng":120.5881755}	2021-03-17 07:02:31.565+00
2848	10	4	{"lat":15.1363869,"lng":120.5881261}	2021-03-17 07:02:36.467+00
2849	10	4	{"lat":15.1364227,"lng":120.5881447}	2021-03-17 07:02:41.48+00
2850	10	4	{"lat":15.1363902,"lng":120.5881642}	2021-03-17 07:02:46.526+00
2851	10	4	{"lat":15.1363603,"lng":120.5881807}	2021-03-17 07:02:51.675+00
2852	10	4	{"lat":15.1363806,"lng":120.5881934}	2021-03-17 07:02:56.428+00
2853	10	4	{"lat":15.1363328,"lng":120.5881167}	2021-03-17 07:03:01.454+00
2854	10	4	{"lat":15.1362289,"lng":120.588129}	2021-03-17 07:03:06.388+00
2855	10	4	{"lat":15.136245,"lng":120.5881269}	2021-03-17 07:03:16.601+00
2856	10	4	{"lat":15.136245,"lng":120.5881269}	2021-03-17 07:03:25.142+00
2857	10	4	{"lat":15.136245,"lng":120.5881269}	2021-03-17 07:03:30.118+00
2858	10	4	{"lat":15.136245,"lng":120.5881269}	2021-03-17 07:03:35.201+00
2859	10	4	{"lat":15.136245,"lng":120.5881269}	2021-03-17 07:03:40.113+00
2860	10	4	{"lat":15.136245,"lng":120.5881269}	2021-03-17 07:03:45.153+00
2861	10	4	{"lat":15.136245,"lng":120.5881269}	2021-03-17 07:03:50.233+00
2862	10	4	{"lat":15.136245,"lng":120.5881269}	2021-03-17 07:03:55.266+00
2863	10	4	{"lat":15.136245,"lng":120.5881269}	2021-03-17 07:04:00.188+00
2864	10	4	{"lat":15.136245,"lng":120.5881269}	2021-03-17 07:04:05.141+00
2865	10	4	{"lat":15.1363095,"lng":120.5879224}	2021-03-17 07:04:10.196+00
2866	10	4	{"lat":15.1363095,"lng":120.5879224}	2021-03-17 07:04:15.355+00
2867	10	4	{"lat":15.1363095,"lng":120.5879224}	2021-03-17 07:04:20.207+00
2868	10	4	{"lat":15.1366147,"lng":120.5877862}	2021-03-17 07:04:25.339+00
2869	10	4	{"lat":15.1366147,"lng":120.5877862}	2021-03-17 07:04:30.143+00
2870	10	4	{"lat":15.1366147,"lng":120.5877862}	2021-03-17 07:04:35.162+00
2871	10	4	{"lat":15.1366147,"lng":120.5877862}	2021-03-17 07:04:40.113+00
2872	10	4	{"lat":15.1366147,"lng":120.5877862}	2021-03-17 07:04:45.141+00
2873	10	4	{"lat":15.1366147,"lng":120.5877862}	2021-03-17 07:04:50.179+00
2874	10	4	{"lat":15.1366147,"lng":120.5877862}	2021-03-17 07:04:55.127+00
2875	10	4	{"lat":15.1366147,"lng":120.5877862}	2021-03-17 07:05:00.193+00
2876	10	4	{"lat":15.1366147,"lng":120.5877862}	2021-03-17 07:05:05.152+00
2877	10	4	{"lat":15.1366147,"lng":120.5877862}	2021-03-17 07:05:10.189+00
2878	10	4	{"lat":15.1379742,"lng":120.5870005}	2021-03-17 07:05:15.287+00
2879	10	4	{"lat":15.1379742,"lng":120.5870005}	2021-03-17 07:05:20.138+00
2880	10	4	{"lat":15.1379742,"lng":120.5870005}	2021-03-17 07:05:25.167+00
2881	10	4	{"lat":15.1373953,"lng":120.5867504}	2021-03-17 07:05:30.174+00
2882	10	4	{"lat":15.1373614,"lng":120.5867201}	2021-03-17 07:05:35.17+00
2883	10	4	{"lat":15.1373614,"lng":120.5867201}	2021-03-17 07:05:40.139+00
2884	10	4	{"lat":15.1373614,"lng":120.5867201}	2021-03-17 07:05:45.131+00
2885	10	4	{"lat":15.1373614,"lng":120.5867201}	2021-03-17 07:05:50.124+00
2886	10	4	{"lat":15.1373614,"lng":120.5867201}	2021-03-17 07:05:55.129+00
2887	10	4	{"lat":15.1373614,"lng":120.5867201}	2021-03-17 07:06:00.147+00
2888	10	4	{"lat":15.1373614,"lng":120.5867201}	2021-03-17 07:06:05.123+00
2889	10	4	{"lat":15.1373614,"lng":120.5867201}	2021-03-17 07:06:10.146+00
2890	10	4	{"lat":15.1373614,"lng":120.5867201}	2021-03-17 07:06:15.142+00
2891	10	4	{"lat":15.1373614,"lng":120.5867201}	2021-03-17 07:06:20.147+00
2892	10	4	{"lat":15.1373866,"lng":120.5866435}	2021-03-17 07:06:25.192+00
2893	10	4	{"lat":15.1372756,"lng":120.5866235}	2021-03-17 07:06:30.168+00
2894	10	4	{"lat":15.1372756,"lng":120.5866235}	2021-03-17 07:06:35.139+00
2895	10	4	{"lat":15.1372756,"lng":120.5866235}	2021-03-17 07:06:40.147+00
2896	10	4	{"lat":15.1372756,"lng":120.5866235}	2021-03-17 07:06:45.142+00
2897	10	4	{"lat":15.1372756,"lng":120.5866235}	2021-03-17 07:06:50.342+00
2898	10	4	{"lat":15.1372756,"lng":120.5866235}	2021-03-17 07:06:55.155+00
2899	10	4	{"lat":15.1372756,"lng":120.5866235}	2021-03-17 07:07:00.271+00
2900	10	4	{"lat":15.1372756,"lng":120.5866235}	2021-03-17 07:07:05.196+00
2901	10	4	{"lat":15.1372756,"lng":120.5866235}	2021-03-17 07:07:10.13+00
2902	10	4	{"lat":15.1372756,"lng":120.5866235}	2021-03-17 07:07:15.125+00
2903	10	4	{"lat":15.1364818,"lng":120.5877612}	2021-03-17 07:07:20.29+00
2904	10	4	{"lat":15.1364818,"lng":120.5877612}	2021-03-17 07:07:25.17+00
2905	10	4	{"lat":15.1367524,"lng":120.5878943}	2021-03-17 07:07:30.215+00
2906	10	4	{"lat":15.1367728,"lng":120.5879019}	2021-03-17 07:07:35.151+00
2907	10	4	{"lat":15.1367728,"lng":120.5879019}	2021-03-17 07:07:40.15+00
2908	10	4	{"lat":15.1367728,"lng":120.5879019}	2021-03-17 07:07:45.127+00
2909	10	4	{"lat":15.1367728,"lng":120.5879019}	2021-03-17 07:07:50.212+00
2910	10	4	{"lat":15.1367728,"lng":120.5879019}	2021-03-17 07:07:55.16+00
2911	10	4	{"lat":15.1367728,"lng":120.5879019}	2021-03-17 07:08:00.27+00
2912	10	4	{"lat":15.1367728,"lng":120.5879019}	2021-03-17 07:08:05.198+00
2913	10	4	{"lat":15.1367728,"lng":120.5879019}	2021-03-17 07:08:10.148+00
2914	10	4	{"lat":15.1367728,"lng":120.5879019}	2021-03-17 07:08:15.22+00
2915	10	4	{"lat":15.1367728,"lng":120.5879019}	2021-03-17 07:08:20.129+00
2916	10	4	{"lat":15.1383885,"lng":120.5881526}	2021-03-17 07:08:25.162+00
2917	10	4	{"lat":15.1386204,"lng":120.5878354}	2021-03-17 07:08:30.137+00
2918	10	4	{"lat":15.1386204,"lng":120.5878354}	2021-03-17 07:08:35.195+00
2919	10	4	{"lat":15.1386204,"lng":120.5878354}	2021-03-17 07:08:40.174+00
2920	10	4	{"lat":15.1386204,"lng":120.5878354}	2021-03-17 07:08:45.156+00
2921	10	4	{"lat":15.1386204,"lng":120.5878354}	2021-03-17 07:08:50.137+00
2922	10	4	{"lat":15.1386204,"lng":120.5878354}	2021-03-17 07:08:55.194+00
2923	10	4	{"lat":15.1386204,"lng":120.5878354}	2021-03-17 07:09:00.141+00
2924	10	4	{"lat":15.1386204,"lng":120.5878354}	2021-03-17 07:09:05.162+00
2925	10	4	{"lat":15.1386204,"lng":120.5878354}	2021-03-17 07:09:10.172+00
2926	10	4	{"lat":15.1386204,"lng":120.5878354}	2021-03-17 07:09:15.152+00
2927	10	4	{"lat":15.1396496,"lng":120.5859579}	2021-03-17 07:09:20.211+00
2928	10	4	{"lat":15.1396496,"lng":120.5859579}	2021-03-17 07:09:25.123+00
2929	10	4	{"lat":15.1402486,"lng":120.5848378}	2021-03-17 07:09:30.138+00
2930	10	4	{"lat":15.1403977,"lng":120.5845193}	2021-03-17 07:09:35.232+00
2931	10	4	{"lat":15.1403977,"lng":120.5845193}	2021-03-17 07:09:40.143+00
2932	10	4	{"lat":15.1403977,"lng":120.5845193}	2021-03-17 07:09:45.152+00
2933	10	4	{"lat":15.1403977,"lng":120.5845193}	2021-03-17 07:09:50.272+00
2934	10	4	{"lat":15.1403977,"lng":120.5845193}	2021-03-17 07:09:55.117+00
2935	10	4	{"lat":15.1403977,"lng":120.5845193}	2021-03-17 07:10:00.222+00
2936	10	4	{"lat":15.1403977,"lng":120.5845193}	2021-03-17 07:10:05.139+00
2937	10	4	{"lat":15.1403977,"lng":120.5845193}	2021-03-17 07:10:10.135+00
2938	10	4	{"lat":15.1403977,"lng":120.5845193}	2021-03-17 07:10:15.119+00
2939	10	4	{"lat":15.1403977,"lng":120.5845193}	2021-03-17 07:10:20.124+00
2940	10	4	{"lat":15.1423752,"lng":120.581636}	2021-03-17 07:10:25.147+00
2941	10	4	{"lat":15.1423951,"lng":120.5816096}	2021-03-17 07:10:30.124+00
2942	10	4	{"lat":15.1423951,"lng":120.5816096}	2021-03-17 07:10:35.141+00
2943	10	4	{"lat":15.1423951,"lng":120.5816096}	2021-03-17 07:10:40.125+00
2944	10	4	{"lat":15.1423951,"lng":120.5816096}	2021-03-17 07:10:45.114+00
2945	10	4	{"lat":15.1423951,"lng":120.5816096}	2021-03-17 07:10:50.158+00
2946	10	4	{"lat":15.1423951,"lng":120.5816096}	2021-03-17 07:10:55.132+00
2947	10	4	{"lat":15.1423951,"lng":120.5816096}	2021-03-17 07:11:00.15+00
2948	10	4	{"lat":15.1423951,"lng":120.5816096}	2021-03-17 07:11:05.154+00
2949	10	4	{"lat":15.1423951,"lng":120.5816096}	2021-03-17 07:11:10.141+00
2950	10	4	{"lat":15.1423951,"lng":120.5816096}	2021-03-17 07:11:15.116+00
2951	10	4	{"lat":15.1442586,"lng":120.5791297}	2021-03-17 07:11:20.12+00
2952	10	4	{"lat":15.1442586,"lng":120.5791297}	2021-03-17 07:11:25.14+00
2953	10	4	{"lat":15.1446105,"lng":120.5786634}	2021-03-17 07:11:30.119+00
2954	10	4	{"lat":15.1447146,"lng":120.5785312}	2021-03-17 07:11:35.132+00
2955	10	4	{"lat":15.1447146,"lng":120.5785312}	2021-03-17 07:11:40.139+00
2956	10	4	{"lat":15.1447146,"lng":120.5785312}	2021-03-17 07:11:45.124+00
2957	10	4	{"lat":15.1447146,"lng":120.5785312}	2021-03-17 07:11:50.138+00
2958	10	4	{"lat":15.1447146,"lng":120.5785312}	2021-03-17 07:11:55.137+00
2959	10	4	{"lat":15.1447146,"lng":120.5785312}	2021-03-17 07:12:00.189+00
2960	10	4	{"lat":15.1447146,"lng":120.5785312}	2021-03-17 07:12:05.118+00
2961	10	4	{"lat":15.1447146,"lng":120.5785312}	2021-03-17 07:12:10.123+00
2962	10	4	{"lat":15.1447146,"lng":120.5785312}	2021-03-17 07:12:15.121+00
2963	10	4	{"lat":15.1447146,"lng":120.5785312}	2021-03-17 07:12:20.153+00
2964	10	4	{"lat":15.1461495,"lng":120.5767166}	2021-03-17 07:12:25.156+00
2965	10	4	{"lat":15.1462761,"lng":120.5764891}	2021-03-17 07:12:30.154+00
2966	10	4	{"lat":15.1462761,"lng":120.5764891}	2021-03-17 07:12:35.122+00
2967	10	4	{"lat":15.1462761,"lng":120.5764891}	2021-03-17 07:12:40.13+00
2968	10	4	{"lat":15.1462761,"lng":120.5764891}	2021-03-17 07:12:45.126+00
2969	10	4	{"lat":15.1462761,"lng":120.5764891}	2021-03-17 07:12:50.116+00
2970	10	4	{"lat":15.1462761,"lng":120.5764891}	2021-03-17 07:12:55.128+00
2971	10	4	{"lat":15.1462761,"lng":120.5764891}	2021-03-17 07:13:00.187+00
2972	10	4	{"lat":15.1462761,"lng":120.5764891}	2021-03-17 07:13:05.172+00
2973	10	4	{"lat":15.1462761,"lng":120.5764891}	2021-03-17 07:13:10.148+00
2974	10	4	{"lat":15.1462761,"lng":120.5764891}	2021-03-17 07:13:15.149+00
2975	10	4	{"lat":15.1475593,"lng":120.5750568}	2021-03-17 07:13:20.117+00
2976	10	4	{"lat":15.1475593,"lng":120.5750568}	2021-03-17 07:13:25.346+00
2977	10	4	{"lat":15.1478451,"lng":120.5747599}	2021-03-17 07:13:30.312+00
2978	10	4	{"lat":15.1479915,"lng":120.5746025}	2021-03-17 07:13:35.312+00
2979	10	4	{"lat":15.1480406,"lng":120.5745553}	2021-03-17 07:13:40.149+00
2980	10	4	{"lat":15.1480406,"lng":120.5745553}	2021-03-17 07:13:45.117+00
2981	10	4	{"lat":15.1480406,"lng":120.5745553}	2021-03-17 07:13:50.124+00
2982	10	4	{"lat":15.1480406,"lng":120.5745553}	2021-03-17 07:13:55.124+00
2983	10	4	{"lat":15.1480406,"lng":120.5745553}	2021-03-17 07:14:00.132+00
2984	10	4	{"lat":15.1480406,"lng":120.5745553}	2021-03-17 07:14:05.497+00
2985	10	4	{"lat":15.1480406,"lng":120.5745553}	2021-03-17 07:14:10.146+00
2986	10	4	{"lat":15.1480406,"lng":120.5745553}	2021-03-17 07:14:15.125+00
2987	10	4	{"lat":15.1480406,"lng":120.5745553}	2021-03-17 07:14:20.121+00
2988	10	4	{"lat":15.1480406,"lng":120.5745553}	2021-03-17 07:14:25.115+00
2989	10	4	{"lat":15.1476652,"lng":120.5732121}	2021-03-17 07:14:30.128+00
2990	10	4	{"lat":15.1475592,"lng":120.5729966}	2021-03-17 07:14:35.124+00
2991	10	4	{"lat":15.1475592,"lng":120.5729966}	2021-03-17 07:14:40.12+00
2992	10	4	{"lat":15.1475592,"lng":120.5729966}	2021-03-17 07:14:45.116+00
2993	10	4	{"lat":15.1475592,"lng":120.5729966}	2021-03-17 07:14:50.113+00
2994	10	4	{"lat":15.1475592,"lng":120.5729966}	2021-03-17 07:14:55.114+00
2995	10	4	{"lat":15.1475592,"lng":120.5729966}	2021-03-17 07:15:00.126+00
2996	10	4	{"lat":15.1470005,"lng":120.5715777}	2021-03-17 07:15:05.291+00
2997	10	4	{"lat":15.1470005,"lng":120.5715777}	2021-03-17 07:15:10.141+00
2998	10	4	{"lat":15.1469164,"lng":120.5713907}	2021-03-17 07:15:15.217+00
2999	10	4	{"lat":15.1468302,"lng":120.5711253}	2021-03-17 07:15:20.138+00
3000	10	4	{"lat":15.1465419,"lng":120.5703734}	2021-03-17 07:15:25.177+00
3001	10	4	{"lat":15.146377,"lng":120.5699437}	2021-03-17 07:15:30.273+00
3002	10	4	{"lat":15.1461261,"lng":120.5692893}	2021-03-17 07:15:35.19+00
3003	10	4	{"lat":15.1459064,"lng":120.5687057}	2021-03-17 07:15:40.165+00
3004	10	4	{"lat":15.1457473,"lng":120.5680657}	2021-03-17 07:15:45.192+00
3005	10	4	{"lat":15.145605,"lng":120.5674578}	2021-03-17 07:15:50.167+00
3006	10	4	{"lat":15.1454509,"lng":120.5668191}	2021-03-17 07:15:55.195+00
3007	10	4	{"lat":15.1454509,"lng":120.5668191}	2021-03-17 07:16:05.134+00
3008	10	4	{"lat":15.1454509,"lng":120.5668191}	2021-03-17 07:16:10.198+00
3009	10	4	{"lat":15.1454509,"lng":120.5668191}	2021-03-17 07:16:15.158+00
3010	10	4	{"lat":15.1454509,"lng":120.5668191}	2021-03-17 07:16:20.146+00
3011	10	4	{"lat":15.1454509,"lng":120.5668191}	2021-03-17 07:16:25.13+00
3012	10	4	{"lat":15.1454509,"lng":120.5668191}	2021-03-17 07:16:30.152+00
3013	10	4	{"lat":15.1448243,"lng":120.5627057}	2021-03-17 07:16:35.135+00
3014	10	4	{"lat":15.1448243,"lng":120.5627057}	2021-03-17 07:16:40.144+00
3015	10	4	{"lat":15.1448243,"lng":120.5627057}	2021-03-17 07:16:45.13+00
3016	10	4	{"lat":15.1448243,"lng":120.5627057}	2021-03-17 07:16:50.135+00
3017	10	4	{"lat":15.1448243,"lng":120.5627057}	2021-03-17 07:16:55.11+00
3018	10	4	{"lat":15.1448243,"lng":120.5627057}	2021-03-17 07:17:00.156+00
3019	10	4	{"lat":15.1448243,"lng":120.5627057}	2021-03-17 07:17:05.126+00
3020	10	4	{"lat":15.1448243,"lng":120.5627057}	2021-03-17 07:17:10.11+00
3021	10	4	{"lat":15.1448243,"lng":120.5627057}	2021-03-17 07:17:15.134+00
3022	10	4	{"lat":15.1448243,"lng":120.5627057}	2021-03-17 07:17:20.129+00
3023	10	4	{"lat":15.1452248,"lng":120.5594746}	2021-03-17 07:17:25.104+00
3024	10	4	{"lat":15.1452248,"lng":120.5594746}	2021-03-17 07:17:30.107+00
3025	10	4	{"lat":15.1465988,"lng":120.5594556}	2021-03-17 07:17:35.108+00
3026	10	4	{"lat":15.1470569,"lng":120.5594503}	2021-03-17 07:17:40.098+00
3027	10	4	{"lat":15.1476237,"lng":120.5594481}	2021-03-17 07:17:45.122+00
3028	10	4	{"lat":15.1482791,"lng":120.559417}	2021-03-17 07:17:50.117+00
3029	10	4	{"lat":15.1485614,"lng":120.5594417}	2021-03-17 07:17:55.128+00
3030	10	4	{"lat":15.1485614,"lng":120.5594417}	2021-03-17 07:18:00.111+00
3031	10	4	{"lat":15.1485614,"lng":120.5594417}	2021-03-17 07:18:05.131+00
3032	10	4	{"lat":15.1485614,"lng":120.5594417}	2021-03-17 07:18:10.119+00
3033	10	4	{"lat":15.1485614,"lng":120.5594417}	2021-03-17 07:18:15.127+00
3034	10	4	{"lat":15.1485614,"lng":120.5594417}	2021-03-17 07:18:20.112+00
3035	10	4	{"lat":15.1485614,"lng":120.5594417}	2021-03-17 07:18:25.133+00
3036	10	4	{"lat":15.1485614,"lng":120.5594417}	2021-03-17 07:18:30.132+00
3037	10	4	{"lat":15.1485614,"lng":120.5594417}	2021-03-17 07:18:35.157+00
3038	10	4	{"lat":15.1485614,"lng":120.5594417}	2021-03-17 07:18:40.115+00
3039	10	4	{"lat":15.1538424,"lng":120.560344}	2021-03-17 07:18:45.108+00
3040	10	4	{"lat":15.1538424,"lng":120.560344}	2021-03-17 07:18:50.12+00
3041	10	4	{"lat":15.1550682,"lng":120.5603166}	2021-03-17 07:18:55.116+00
3042	10	4	{"lat":15.1554297,"lng":120.5602789}	2021-03-17 07:19:00.126+00
3043	10	4	{"lat":15.1554297,"lng":120.5602789}	2021-03-17 07:19:05.116+00
3044	10	4	{"lat":15.1554297,"lng":120.5602789}	2021-03-17 07:19:10.123+00
3045	10	4	{"lat":15.1554297,"lng":120.5602789}	2021-03-17 07:19:15.12+00
3046	10	4	{"lat":15.1554297,"lng":120.5602789}	2021-03-17 07:19:20.123+00
3047	10	4	{"lat":15.1554297,"lng":120.5602789}	2021-03-17 07:19:25.108+00
3048	10	4	{"lat":15.1554297,"lng":120.5602789}	2021-03-17 07:19:30.107+00
3049	10	4	{"lat":15.1554297,"lng":120.5602789}	2021-03-17 07:19:35.142+00
3050	10	4	{"lat":15.1554297,"lng":120.5602789}	2021-03-17 07:19:40.106+00
3051	10	4	{"lat":15.1554297,"lng":120.5602789}	2021-03-17 07:19:45.11+00
3052	10	4	{"lat":15.1594719,"lng":120.5584872}	2021-03-17 07:19:50.104+00
3053	10	4	{"lat":15.1594719,"lng":120.5584872}	2021-03-17 07:19:55.111+00
3054	10	4	{"lat":15.1594719,"lng":120.5584872}	2021-03-17 07:20:00.105+00
3055	10	4	{"lat":15.1594719,"lng":120.5584872}	2021-03-17 07:20:05.118+00
3056	10	4	{"lat":15.1594719,"lng":120.5584872}	2021-03-17 07:20:10.109+00
3057	10	4	{"lat":15.1594719,"lng":120.5584872}	2021-03-17 07:20:15.111+00
3058	10	4	{"lat":15.1594719,"lng":120.5584872}	2021-03-17 07:20:20.106+00
3059	10	4	{"lat":15.1594719,"lng":120.5584872}	2021-03-17 07:20:25.116+00
3060	10	4	{"lat":15.1594719,"lng":120.5584872}	2021-03-17 07:20:30.127+00
3061	10	4	{"lat":15.1594719,"lng":120.5584872}	2021-03-17 07:20:35.126+00
3062	10	4	{"lat":15.1625961,"lng":120.5573193}	2021-03-17 07:20:40.104+00
3063	10	4	{"lat":15.1625961,"lng":120.5573193}	2021-03-17 07:20:45.102+00
3064	10	4	{"lat":15.162953,"lng":120.5570526}	2021-03-17 07:20:50.104+00
3065	10	4	{"lat":15.162953,"lng":120.5570526}	2021-03-17 07:20:55.11+00
3066	10	4	{"lat":15.162953,"lng":120.5570526}	2021-03-17 07:21:00.118+00
3067	10	4	{"lat":15.162953,"lng":120.5570526}	2021-03-17 07:21:05.114+00
3068	10	4	{"lat":15.162953,"lng":120.5570526}	2021-03-17 07:21:10.156+00
3069	10	4	{"lat":15.162953,"lng":120.5570526}	2021-03-17 07:21:15.126+00
3070	10	4	{"lat":15.162953,"lng":120.5570526}	2021-03-17 07:21:20.103+00
3071	10	4	{"lat":15.162953,"lng":120.5570526}	2021-03-17 07:21:25.111+00
3072	10	4	{"lat":15.162953,"lng":120.5570526}	2021-03-17 07:21:30.12+00
3073	10	4	{"lat":15.162953,"lng":120.5570526}	2021-03-17 07:21:35.106+00
3074	10	4	{"lat":15.1626546,"lng":120.5565647}	2021-03-17 07:21:40.104+00
3075	10	4	{"lat":15.1626546,"lng":120.5565647}	2021-03-17 07:21:45.103+00
3076	10	4	{"lat":15.1626652,"lng":120.5565608}	2021-03-17 07:21:50.107+00
3077	10	4	{"lat":15.1626652,"lng":120.5565608}	2021-03-17 07:21:55.11+00
3078	10	4	{"lat":15.1626574,"lng":120.5565599}	2021-03-17 07:22:00.115+00
3079	10	4	{"lat":15.1626574,"lng":120.5565599}	2021-03-17 07:22:05.108+00
3080	10	4	{"lat":15.1626574,"lng":120.5565599}	2021-03-17 07:22:10.111+00
3081	10	4	{"lat":15.1626574,"lng":120.5565599}	2021-03-17 07:22:15.111+00
3082	10	4	{"lat":15.1626574,"lng":120.5565599}	2021-03-17 07:22:20.117+00
3083	10	4	{"lat":15.1624188,"lng":120.5566729}	2021-03-17 07:22:25.156+00
3084	10	4	{"lat":15.1624188,"lng":120.5566729}	2021-03-17 07:22:30.14+00
3085	10	4	{"lat":15.1624025,"lng":120.5566898}	2021-03-17 07:22:35.141+00
3086	10	4	{"lat":15.162557,"lng":120.5565166}	2021-03-17 07:22:40.13+00
3087	10	4	{"lat":15.1625713,"lng":120.5564946}	2021-03-17 07:22:45.118+00
3088	10	4	{"lat":15.1625815,"lng":120.556489}	2021-03-17 07:22:50.147+00
3089	10	4	{"lat":15.1625723,"lng":120.556496}	2021-03-17 07:22:55.124+00
3090	10	4	{"lat":15.1625664,"lng":120.5565035}	2021-03-17 07:23:00.109+00
3091	10	4	{"lat":15.1625617,"lng":120.5564979}	2021-03-17 07:23:06.084+00
3092	10	4	{"lat":15.1625622,"lng":120.556503}	2021-03-17 07:23:11.059+00
3093	10	4	{"lat":15.16256,"lng":120.5564941}	2021-03-17 07:23:16.236+00
3094	10	4	{"lat":15.1625639,"lng":120.5564964}	2021-03-17 07:23:21.317+00
3095	10	4	{"lat":15.1625626,"lng":120.5564956}	2021-03-17 07:23:26.134+00
3096	10	4	{"lat":15.1625631,"lng":120.556501}	2021-03-17 07:23:31.161+00
3097	10	4	{"lat":15.162565,"lng":120.5565}	2021-03-17 07:23:36.068+00
3098	10	\N	{"lat":"15.1625623","lng":"120.5564999"}	2021-03-17 07:23:47.411+00
3099	10	\N	{"lat":"15.1625675","lng":"120.5564983"}	2021-03-17 07:24:01.584+00
3100	10	\N	{"lat":"15.1625633","lng":"120.5564987"}	2021-03-17 07:24:08.762+00
3101	10	\N	{"lat":"15.1625638","lng":"120.5564988"}	2021-03-17 07:24:14.366+00
3102	10	\N	{"lat":"15.1625604","lng":"120.556503"}	2021-03-17 07:25:11.727+00
3103	10	\N	{"lat":"15.1626451","lng":"120.5565512"}	2021-03-17 07:25:40.777+00
3104	10	\N	{"lat":"15.1626723","lng":"120.556561"}	2021-03-17 07:26:10.773+00
3105	10	\N	{"lat":"15.1626674","lng":"120.5565621"}	2021-03-17 07:26:42.02+00
3106	10	\N	{"lat":"15.1626675","lng":"120.5565606"}	2021-03-17 07:27:10.814+00
3107	6	8	{"lat":15.1673514,"lng":120.579913}	2021-03-17 06:59:21.809+00
3108	6	8	{"lat":15.167024,"lng":120.5804903}	2021-03-17 06:59:41.91+00
3109	6	8	{"lat":15.1672657,"lng":120.5801391}	2021-03-17 06:59:46.637+00
3110	6	8	{"lat":15.1661524,"lng":120.5811787}	2021-03-17 06:59:52.079+00
3111	6	8	{"lat":15.1664681,"lng":120.5809374}	2021-03-17 07:00:06.686+00
3112	6	8	{"lat":15.1665815,"lng":120.5808111}	2021-03-17 07:00:11.402+00
3113	6	8	{"lat":15.1669649,"lng":120.580549}	2021-03-17 07:00:16.912+00
3114	6	8	{"lat":15.16762,"lng":120.578745}	2021-03-17 07:00:25.288+00
3115	6	8	{"lat":15.16755,"lng":120.579145}	2021-03-17 07:00:33.321+00
3116	6	8	{"lat":15.16755,"lng":120.579145}	2021-03-17 07:00:34.841+00
3117	6	8	{"lat":15.1672378,"lng":120.5792176}	2021-03-17 07:00:44.337+00
3118	6	8	{"lat":15.1672378,"lng":120.5792176}	2021-03-17 07:00:44.768+00
3119	6	8	{"lat":15.1673417,"lng":120.57726}	2021-03-17 07:01:09.29+00
3120	6	8	{"lat":15.1673417,"lng":120.57726}	2021-03-17 07:01:09.781+00
3121	6	8	{"lat":15.1671667,"lng":120.5798583}	2021-03-17 07:01:19.765+00
3122	6	8	{"lat":15.1671414,"lng":120.5798607}	2021-03-17 07:01:28.35+00
3123	6	8	{"lat":15.1671414,"lng":120.5798607}	2021-03-17 07:01:29.844+00
3124	6	8	{"lat":15.1670499,"lng":120.5797555}	2021-03-17 07:01:49.471+00
3125	6	8	{"lat":15.1670499,"lng":120.5797555}	2021-03-17 07:01:49.856+00
3126	6	8	{"lat":15.1662133,"lng":120.5790383}	2021-03-17 07:02:01.276+00
3127	6	8	{"lat":15.1652017,"lng":120.580565}	2021-03-17 07:02:15.143+00
3128	6	8	{"lat":15.1652017,"lng":120.580565}	2021-03-17 07:02:24.773+00
3129	6	8	{"lat":15.1652017,"lng":120.580565}	2021-03-17 07:02:29.84+00
3130	6	8	{"lat":15.1652017,"lng":120.580565}	2021-03-17 07:02:34.846+00
3131	6	8	{"lat":15.1652017,"lng":120.580565}	2021-03-17 07:02:39.768+00
3132	6	8	{"lat":15.1652017,"lng":120.580565}	2021-03-17 07:02:44.841+00
3133	6	8	{"lat":15.1652017,"lng":120.580565}	2021-03-17 07:02:49.854+00
3134	6	8	{"lat":15.1652017,"lng":120.580565}	2021-03-17 07:03:16.117+00
3135	6	8	{"lat":15.1666953,"lng":120.5708187}	2021-03-17 07:03:31.301+00
3136	6	8	{"lat":15.16688,"lng":120.5697468}	2021-03-17 07:03:40.298+00
3137	6	8	{"lat":15.1671075,"lng":120.5682894}	2021-03-17 07:03:48.377+00
3138	6	8	{"lat":15.1671075,"lng":120.5682894}	2021-03-17 07:03:49.804+00
3139	6	8	{"lat":15.16748,"lng":120.5658767}	2021-03-17 07:04:08.338+00
3140	6	8	{"lat":15.16748,"lng":120.5658767}	2021-03-17 07:04:09.848+00
3141	6	8	{"lat":15.1672817,"lng":120.56358}	2021-03-17 07:04:23.323+00
3142	6	8	{"lat":15.1672817,"lng":120.56358}	2021-03-17 07:04:24.841+00
3143	6	8	{"lat":15.1672817,"lng":120.56358}	2021-03-17 07:04:29.855+00
3144	6	8	{"lat":15.1672817,"lng":120.56358}	2021-03-17 07:04:34.849+00
3145	6	8	{"lat":15.1672817,"lng":120.56358}	2021-03-17 07:04:46.293+00
3146	6	8	{"lat":15.1672817,"lng":120.56358}	2021-03-17 07:05:01.766+00
3147	6	8	{"lat":15.1672817,"lng":120.56358}	2021-03-17 07:05:18.687+00
3148	6	8	{"lat":15.1672817,"lng":120.56358}	2021-03-17 07:05:47.081+00
3149	6	8	{"lat":15.1672817,"lng":120.56358}	2021-03-17 07:06:07.502+00
3150	6	8	{"lat":15.1672817,"lng":120.56358}	2021-03-17 07:06:34.47+00
3151	6	8	{"lat":15.1672817,"lng":120.56358}	2021-03-17 07:06:40.797+00
3152	6	8	{"lat":15.1672817,"lng":120.56358}	2021-03-17 07:06:55.393+00
3153	6	8	{"lat":15.1672817,"lng":120.56358}	2021-03-17 07:07:11.136+00
3154	6	8	{"lat":15.1672817,"lng":120.56358}	2021-03-17 07:07:16.162+00
3155	6	8	{"lat":15.1672817,"lng":120.56358}	2021-03-17 07:07:21.175+00
3156	6	8	{"lat":15.1672817,"lng":120.56358}	2021-03-17 07:07:26.117+00
3157	6	8	{"lat":15.1672817,"lng":120.56358}	2021-03-17 07:07:31.132+00
3158	6	8	{"lat":15.1672817,"lng":120.56358}	2021-03-17 07:07:36.173+00
3159	6	8	{"lat":15.1672817,"lng":120.56358}	2021-03-17 07:07:41.17+00
3160	6	8	{"lat":15.1672817,"lng":120.56358}	2021-03-17 07:08:15.834+00
3161	6	8	{"lat":15.1672817,"lng":120.56358}	2021-03-17 07:08:16.131+00
3162	6	8	{"lat":15.1672817,"lng":120.56358}	2021-03-17 07:08:26.479+00
3163	6	8	{"lat":15.1672817,"lng":120.56358}	2021-03-17 07:09:11.443+00
3164	6	8	{"lat":15.1672817,"lng":120.56358}	2021-03-17 07:10:05.004+00
3165	6	8	{"lat":15.1672817,"lng":120.56358}	2021-03-17 07:10:52.545+00
3166	6	8	{"lat":15.1672817,"lng":120.56358}	2021-03-17 07:11:35.804+00
3167	6	8	{"lat":15.1672817,"lng":120.56358}	2021-03-17 07:12:21.111+00
3168	6	8	{"lat":15.1672817,"lng":120.56358}	2021-03-17 07:14:22.376+00
3169	6	8	{"lat":15.1345665,"lng":120.5670874}	2021-03-17 07:14:42.381+00
3170	6	8	{"lat":15.1345665,"lng":120.5670874}	2021-03-17 07:14:43.232+00
3171	6	8	{"lat":15.1345665,"lng":120.5670874}	2021-03-17 07:14:48.157+00
3172	6	8	{"lat":15.1345949,"lng":120.5670968}	2021-03-17 07:15:04.911+00
3173	6	8	{"lat":15.134659,"lng":120.5671226}	2021-03-17 07:15:08.734+00
3174	6	8	{"lat":15.1346587,"lng":120.5671182}	2021-03-17 07:15:13.287+00
3175	6	8	{"lat":15.1346038,"lng":120.5670864}	2021-03-17 07:15:39.944+00
3176	6	8	{"lat":15.1346073,"lng":120.5670852}	2021-03-17 07:15:45.921+00
3177	6	8	{"lat":15.1346088,"lng":120.5670845}	2021-03-17 07:15:49.493+00
3178	6	8	{"lat":15.1346059,"lng":120.5670836}	2021-03-17 07:15:53.833+00
3179	6	8	{"lat":15.1347541,"lng":120.5669988}	2021-03-17 07:16:04.657+00
3180	6	8	{"lat":15.1346847,"lng":120.5670494}	2021-03-17 07:16:20.186+00
3181	6	8	{"lat":15.1346689,"lng":120.5671007}	2021-03-17 07:16:40.47+00
3182	6	8	{"lat":15.1346533,"lng":120.5670975}	2021-03-17 07:16:45.468+00
3183	6	8	{"lat":15.1346267,"lng":120.5671883}	2021-03-17 07:16:51.721+00
3184	6	8	{"lat":15.1346267,"lng":120.5671883}	2021-03-17 07:16:53.215+00
3185	6	8	{"lat":15.1346367,"lng":120.56719}	2021-03-17 07:17:01.693+00
3186	6	8	{"lat":15.1346367,"lng":120.56719}	2021-03-17 07:17:03.217+00
3187	6	8	{"lat":15.1346367,"lng":120.56719}	2021-03-17 07:17:23.236+00
3188	6	8	{"lat":15.1346367,"lng":120.56719}	2021-03-17 07:17:28.21+00
3189	6	8	{"lat":15.1346367,"lng":120.56719}	2021-03-17 07:17:33.234+00
3190	6	8	{"lat":15.1346367,"lng":120.56719}	2021-03-17 07:17:38.24+00
3191	6	8	{"lat":15.1346367,"lng":120.56719}	2021-03-17 07:17:43.24+00
3192	6	8	{"lat":15.1346367,"lng":120.56719}	2021-03-17 07:17:48.243+00
3193	6	8	{"lat":15.1346367,"lng":120.56719}	2021-03-17 07:17:53.233+00
3194	6	8	{"lat":15.1346367,"lng":120.56719}	2021-03-17 07:17:58.239+00
3195	6	8	{"lat":15.1346367,"lng":120.56719}	2021-03-17 07:18:03.147+00
3196	6	8	{"lat":15.1352847,"lng":120.5662697}	2021-03-17 07:18:08.942+00
3197	6	8	{"lat":15.1348813,"lng":120.5669705}	2021-03-17 07:18:14.848+00
3198	6	8	{"lat":15.1348724,"lng":120.5671356}	2021-03-17 07:18:21.744+00
3199	6	8	{"lat":15.1348724,"lng":120.5671356}	2021-03-17 07:18:23.201+00
3200	6	8	{"lat":15.1374833,"lng":120.5644733}	2021-03-17 07:18:42.775+00
3201	6	8	{"lat":15.1374833,"lng":120.5644733}	2021-03-17 07:18:43.214+00
3202	6	8	{"lat":15.1374583,"lng":120.5645767}	2021-03-17 07:18:51.722+00
3203	6	8	{"lat":15.1374583,"lng":120.5645767}	2021-03-17 07:18:53.2+00
3204	6	8	{"lat":15.1374583,"lng":120.5645767}	2021-03-17 07:19:24.8+00
3205	6	8	{"lat":15.1374583,"lng":120.5645767}	2021-03-17 07:19:28.239+00
3206	6	8	{"lat":15.1374583,"lng":120.5645767}	2021-03-17 07:19:33.238+00
3207	6	8	{"lat":15.1374583,"lng":120.5645767}	2021-03-17 07:19:59.005+00
3208	6	8	{"lat":15.1374583,"lng":120.5645767}	2021-03-17 07:20:05.326+00
3209	6	8	{"lat":15.1374583,"lng":120.5645767}	2021-03-17 07:20:30.467+00
3210	6	8	{"lat":15.1374583,"lng":120.5645767}	2021-03-17 07:20:45.471+00
3211	6	8	{"lat":15.1374583,"lng":120.5645767}	2021-03-17 07:20:50.683+00
3212	6	8	{"lat":15.1374583,"lng":120.5645767}	2021-03-17 07:21:34.721+00
3213	6	8	{"lat":15.1374583,"lng":120.5645767}	2021-03-17 07:22:07.119+00
3214	6	8	{"lat":15.1519099,"lng":120.5592143}	2021-03-17 07:22:14.21+00
3215	6	8	{"lat":15.1520067,"lng":120.5596516}	2021-03-17 07:22:21.788+00
3216	6	8	{"lat":15.1520067,"lng":120.5596516}	2021-03-17 07:22:23.204+00
3217	6	8	{"lat":15.1525141,"lng":120.5596063}	2021-03-17 07:22:31.861+00
3218	6	8	{"lat":15.1525141,"lng":120.5596063}	2021-03-17 07:22:33.227+00
3219	6	8	{"lat":15.1523969,"lng":120.5590186}	2021-03-17 07:22:41.747+00
3220	6	8	{"lat":15.1523969,"lng":120.5590186}	2021-03-17 07:22:43.211+00
3221	6	8	{"lat":15.1539317,"lng":120.5602933}	2021-03-17 07:22:54.747+00
3222	6	8	{"lat":15.1540023,"lng":120.5601837}	2021-03-17 07:23:04.768+00
3223	6	8	{"lat":15.1542481,"lng":120.5596448}	2021-03-17 07:23:09.794+00
3224	6	8	{"lat":15.1542481,"lng":120.5596448}	2021-03-17 07:23:13.223+00
3225	6	8	{"lat":15.1542481,"lng":120.5596448}	2021-03-17 07:23:18.179+00
3226	6	8	{"lat":15.1542481,"lng":120.5596448}	2021-03-17 07:23:24.353+00
3227	6	8	{"lat":15.1542481,"lng":120.5596448}	2021-03-17 07:23:29.058+00
3228	6	8	{"lat":15.1542481,"lng":120.5596448}	2021-03-17 07:23:44.018+00
3229	6	8	{"lat":15.1542481,"lng":120.5596448}	2021-03-17 07:24:08.274+00
3230	6	8	{"lat":15.1542481,"lng":120.5596448}	2021-03-17 07:24:25.057+00
3231	6	8	{"lat":15.1542481,"lng":120.5596448}	2021-03-17 07:24:37.141+00
3232	6	8	{"lat":15.1542481,"lng":120.5596448}	2021-03-17 07:25:03.016+00
3233	6	8	{"lat":15.1542481,"lng":120.5596448}	2021-03-17 07:25:23.763+00
3234	6	8	{"lat":15.1542481,"lng":120.5596448}	2021-03-17 07:25:58.353+00
3235	6	8	{"lat":15.1626783,"lng":120.55656}	2021-03-17 07:26:19.265+00
3236	6	8	{"lat":15.1625866,"lng":120.5565201}	2021-03-17 07:26:50.716+00
3237	6	8	{"lat":15.1625908,"lng":120.5565223}	2021-03-17 07:26:55.807+00
3238	6	8	{"lat":15.1625884,"lng":120.5565157}	2021-03-17 07:27:05.621+00
3239	6	8	{"lat":15.1625644,"lng":120.5565058}	2021-03-17 07:27:30.681+00
3240	6	\N	{"lat":"15.1625651","lng":"120.5565044"}	2021-03-17 07:27:36.86+00
3241	10	\N	{"lat":"15.1626675","lng":"120.5565606"}	2021-03-17 07:27:40.807+00
3242	6	\N	{"lat":"15.1625533","lng":"120.5564995"}	2021-03-17 07:28:09.052+00
3243	6	\N	{"lat":"15.1625562","lng":"120.5564986"}	2021-03-17 07:28:39.576+00
3244	4	9	{"lat":15.1654099,"lng":120.5764185}	2021-03-17 07:04:58.756+00
3245	4	9	{"lat":15.1654144,"lng":120.5764185}	2021-03-17 07:05:04.039+00
3246	4	9	{"lat":15.1654202,"lng":120.5764204}	2021-03-17 07:05:09.069+00
3247	4	9	{"lat":15.166002,"lng":120.5769139}	2021-03-17 07:05:12.432+00
3248	4	9	{"lat":15.166019,"lng":120.575998}	2021-03-17 07:05:19.144+00
3249	4	9	{"lat":15.1660628,"lng":120.5755916}	2021-03-17 07:05:24.137+00
3250	4	9	{"lat":15.1660958,"lng":120.5750919}	2021-03-17 07:05:29.132+00
3251	4	9	{"lat":15.1661878,"lng":120.5745019}	2021-03-17 07:05:34.159+00
3252	4	9	{"lat":15.1662879,"lng":120.5739276}	2021-03-17 07:05:39.144+00
3253	4	9	{"lat":15.1664131,"lng":120.573245}	2021-03-17 07:05:44.118+00
3254	4	9	{"lat":15.1665228,"lng":120.5726199}	2021-03-17 07:05:49.132+00
3255	4	9	{"lat":15.1666071,"lng":120.5720759}	2021-03-17 07:05:54.145+00
3256	4	9	{"lat":15.1666799,"lng":120.5715625}	2021-03-17 07:05:59.122+00
3257	4	9	{"lat":15.1667563,"lng":120.5709663}	2021-03-17 07:06:04.181+00
3258	4	9	{"lat":15.1668769,"lng":120.5703169}	2021-03-17 07:06:09.123+00
3259	4	9	{"lat":15.1669942,"lng":120.5694874}	2021-03-17 07:06:15.147+00
3260	4	9	{"lat":15.1670779,"lng":120.5688919}	2021-03-17 07:06:19.137+00
3261	4	9	{"lat":15.1671922,"lng":120.5681612}	2021-03-17 07:06:24.138+00
3262	4	9	{"lat":15.1673366,"lng":120.5673935}	2021-03-17 07:06:29.121+00
3263	4	9	{"lat":15.1674818,"lng":120.5665003}	2021-03-17 07:06:34.126+00
3264	4	9	{"lat":15.1675253,"lng":120.5659207}	2021-03-17 07:06:39.146+00
3265	4	9	{"lat":15.1675237,"lng":120.5651779}	2021-03-17 07:06:44.134+00
3266	4	9	{"lat":15.1674114,"lng":120.5643625}	2021-03-17 07:06:49.177+00
3267	4	9	{"lat":15.1673067,"lng":120.5635561}	2021-03-17 07:06:54.124+00
3268	4	9	{"lat":15.1671685,"lng":120.5627602}	2021-03-17 07:06:59.145+00
3269	4	9	{"lat":15.1670122,"lng":120.5617936}	2021-03-17 07:07:04.135+00
3270	4	9	{"lat":15.1669247,"lng":120.5611462}	2021-03-17 07:07:09.139+00
3271	4	9	{"lat":15.1668578,"lng":120.5603782}	2021-03-17 07:07:14.154+00
3272	4	9	{"lat":15.1666094,"lng":120.5597255}	2021-03-17 07:07:19.173+00
3273	4	9	{"lat":15.1662498,"lng":120.5590845}	2021-03-17 07:07:24.153+00
3274	4	9	{"lat":15.1658992,"lng":120.5583868}	2021-03-17 07:07:29.154+00
3275	4	9	{"lat":15.1655493,"lng":120.5576388}	2021-03-17 07:07:34.164+00
3276	4	9	{"lat":15.1651594,"lng":120.5568821}	2021-03-17 07:07:39.16+00
3277	4	9	{"lat":15.1647788,"lng":120.5561802}	2021-03-17 07:07:44.152+00
3278	4	9	{"lat":15.1643605,"lng":120.555495}	2021-03-17 07:07:49.173+00
3279	4	9	{"lat":15.1640547,"lng":120.554838}	2021-03-17 07:07:54.155+00
3280	4	9	{"lat":15.1638116,"lng":120.5543994}	2021-03-17 07:07:57.562+00
3281	4	9	{"lat":15.1634832,"lng":120.5538073}	2021-03-17 07:08:02.922+00
3282	4	9	{"lat":15.1635899,"lng":120.5528322}	2021-03-17 07:08:09.151+00
3283	4	9	{"lat":15.1635529,"lng":120.5520896}	2021-03-17 07:08:14.149+00
3284	4	9	{"lat":15.1636187,"lng":120.5515607}	2021-03-17 07:08:19.162+00
3285	4	9	{"lat":15.163691,"lng":120.5511633}	2021-03-17 07:08:24.126+00
3286	4	9	{"lat":15.1637453,"lng":120.5510016}	2021-03-17 07:08:29.14+00
3287	4	9	{"lat":15.163757,"lng":120.5509873}	2021-03-17 07:08:34.076+00
3288	4	9	{"lat":15.1637504,"lng":120.551028}	2021-03-17 07:08:37.424+00
3289	4	9	{"lat":15.1637327,"lng":120.5510955}	2021-03-17 07:08:44.066+00
3290	4	9	{"lat":15.1637113,"lng":120.551072}	2021-03-17 07:08:47.462+00
3291	4	9	{"lat":15.1636894,"lng":120.5510452}	2021-03-17 07:08:54.114+00
3292	4	9	{"lat":15.1637412,"lng":120.5511255}	2021-03-17 07:08:57.447+00
3293	4	9	{"lat":15.163747,"lng":120.5510616}	2021-03-17 07:09:04.156+00
3294	4	9	{"lat":15.1637523,"lng":120.5510191}	2021-03-17 07:09:09.153+00
3295	4	9	{"lat":15.1637813,"lng":120.5508608}	2021-03-17 07:09:14.148+00
3296	4	9	{"lat":15.1636773,"lng":120.5505728}	2021-03-17 07:09:19.136+00
3297	4	9	{"lat":15.1632032,"lng":120.5504871}	2021-03-17 07:09:24.152+00
3298	4	9	{"lat":15.1626299,"lng":120.5504396}	2021-03-17 07:09:29.137+00
3299	4	9	{"lat":15.1620497,"lng":120.5504827}	2021-03-17 07:09:34.159+00
3300	4	9	{"lat":15.1617601,"lng":120.5507327}	2021-03-17 07:09:39.134+00
3301	4	9	{"lat":15.161541,"lng":120.5511081}	2021-03-17 07:09:44.153+00
3302	4	9	{"lat":15.161611,"lng":120.5511589}	2021-03-17 07:09:49.088+00
3303	4	9	{"lat":15.1617756,"lng":120.5514985}	2021-03-17 07:09:54.161+00
3304	4	9	{"lat":15.1617756,"lng":120.5514985}	2021-03-17 07:09:57.335+00
3305	4	9	{"lat":15.1617756,"lng":120.5514985}	2021-03-17 07:10:02.361+00
3306	4	9	{"lat":15.1617756,"lng":120.5514985}	2021-03-17 07:10:07.343+00
3307	4	9	{"lat":15.1617756,"lng":120.5514985}	2021-03-17 07:10:50.693+00
3308	4	9	{"lat":15.1626164,"lng":120.5538692}	2021-03-17 07:10:53.822+00
3309	4	9	{"lat":15.1627918,"lng":120.5543453}	2021-03-17 07:10:59.161+00
3310	4	9	{"lat":15.1627882,"lng":120.5544013}	2021-03-17 07:11:04.36+00
3311	4	9	{"lat":15.1626413,"lng":120.5551189}	2021-03-17 07:11:09.106+00
3312	4	9	{"lat":15.1625241,"lng":120.5551101}	2021-03-17 07:11:14.029+00
3313	4	9	{"lat":15.1620163,"lng":120.5552045}	2021-03-17 07:11:19.163+00
3314	4	9	{"lat":15.1616512,"lng":120.5554062}	2021-03-17 07:11:24.155+00
3315	4	9	{"lat":15.1613154,"lng":120.5556094}	2021-03-17 07:11:29.136+00
3316	4	9	{"lat":15.1610138,"lng":120.5557866}	2021-03-17 07:11:34.155+00
3317	4	9	{"lat":15.1607177,"lng":120.5559339}	2021-03-17 07:11:39.162+00
3318	4	9	{"lat":15.1605839,"lng":120.5560419}	2021-03-17 07:11:44.159+00
3319	4	9	{"lat":15.1605191,"lng":120.5560842}	2021-03-17 07:11:49.141+00
3320	4	9	{"lat":15.160245,"lng":120.5562439}	2021-03-17 07:11:54.168+00
3321	4	9	{"lat":15.1597352,"lng":120.5564423}	2021-03-17 07:11:59.163+00
3322	4	9	{"lat":15.1593437,"lng":120.5566445}	2021-03-17 07:12:04.152+00
3323	4	9	{"lat":15.1589695,"lng":120.5569577}	2021-03-17 07:12:09.14+00
3324	4	9	{"lat":15.1586959,"lng":120.5573768}	2021-03-17 07:12:14.127+00
3325	4	9	{"lat":15.1585483,"lng":120.5579148}	2021-03-17 07:12:19.129+00
3326	4	9	{"lat":15.1584004,"lng":120.5585116}	2021-03-17 07:12:24.147+00
3327	4	9	{"lat":15.1582407,"lng":120.5590531}	2021-03-17 07:12:29.135+00
3328	4	9	{"lat":15.158023,"lng":120.5596609}	2021-03-17 07:12:34.155+00
3329	4	9	{"lat":15.1575326,"lng":120.5598408}	2021-03-17 07:12:39.154+00
3330	4	9	{"lat":15.156758,"lng":120.5599708}	2021-03-17 07:12:45.169+00
3331	4	9	{"lat":15.1561786,"lng":120.5600638}	2021-03-17 07:12:49.165+00
3332	4	9	{"lat":15.1555421,"lng":120.5601638}	2021-03-17 07:12:54.152+00
3333	4	9	{"lat":15.1550024,"lng":120.560209}	2021-03-17 07:12:59.14+00
3334	4	9	{"lat":15.1545484,"lng":120.5601714}	2021-03-17 07:13:04.151+00
3335	4	9	{"lat":15.1541911,"lng":120.56018}	2021-03-17 07:13:09.151+00
3336	4	9	{"lat":15.153949,"lng":120.5601997}	2021-03-17 07:13:14.153+00
3337	4	9	{"lat":15.1537406,"lng":120.5601822}	2021-03-17 07:13:19.169+00
3338	4	9	{"lat":15.153533,"lng":120.5600905}	2021-03-17 07:13:24.143+00
3339	4	9	{"lat":15.1531669,"lng":120.5599535}	2021-03-17 07:13:29.141+00
3340	4	9	{"lat":15.1527535,"lng":120.5596724}	2021-03-17 07:13:34.115+00
3341	4	9	{"lat":15.1522317,"lng":120.5593602}	2021-03-17 07:13:39.154+00
3342	4	9	{"lat":15.1517117,"lng":120.5592545}	2021-03-17 07:13:44.155+00
3343	4	9	{"lat":15.1510326,"lng":120.5592891}	2021-03-17 07:13:49.146+00
3344	4	9	{"lat":15.1504733,"lng":120.5592663}	2021-03-17 07:13:54.151+00
3345	4	9	{"lat":15.1499282,"lng":120.5592636}	2021-03-17 07:13:59.149+00
3346	4	9	{"lat":15.1493792,"lng":120.5593086}	2021-03-17 07:14:04.143+00
3347	4	9	{"lat":15.1487637,"lng":120.5593021}	2021-03-17 07:14:09.13+00
3348	4	9	{"lat":15.1481087,"lng":120.5593103}	2021-03-17 07:14:14.176+00
3349	4	9	{"lat":15.1474348,"lng":120.5592879}	2021-03-17 07:14:19.147+00
3350	4	9	{"lat":15.1468852,"lng":120.559287}	2021-03-17 07:14:24.154+00
3351	4	9	{"lat":15.1464795,"lng":120.5593151}	2021-03-17 07:14:29.137+00
3352	4	9	{"lat":15.1460573,"lng":120.5593153}	2021-03-17 07:14:34.16+00
3353	4	9	{"lat":15.1456342,"lng":120.5593029}	2021-03-17 07:14:39.156+00
3354	4	9	{"lat":15.1451819,"lng":120.5593252}	2021-03-17 07:14:44.143+00
3355	4	9	{"lat":15.1447541,"lng":120.5592996}	2021-03-17 07:14:49.156+00
3356	4	9	{"lat":15.1444327,"lng":120.5593041}	2021-03-17 07:14:54.132+00
3357	4	9	{"lat":15.1441051,"lng":120.5593022}	2021-03-17 07:14:59.157+00
3358	4	9	{"lat":15.1436226,"lng":120.5594454}	2021-03-17 07:15:04.141+00
3359	4	9	{"lat":15.1430174,"lng":120.5599567}	2021-03-17 07:15:10.158+00
3360	4	9	{"lat":15.1426032,"lng":120.5603049}	2021-03-17 07:15:14.129+00
3361	4	9	{"lat":15.1419879,"lng":120.5607572}	2021-03-17 07:15:19.159+00
3362	4	9	{"lat":15.1413792,"lng":120.5611118}	2021-03-17 07:15:24.158+00
3363	4	9	{"lat":15.1407437,"lng":120.5614885}	2021-03-17 07:15:29.146+00
3364	4	9	{"lat":15.1401782,"lng":120.5618575}	2021-03-17 07:15:34.136+00
3365	4	9	{"lat":15.1395648,"lng":120.5622574}	2021-03-17 07:15:39.151+00
3366	4	9	{"lat":15.1390338,"lng":120.5626976}	2021-03-17 07:15:44.142+00
3367	4	9	{"lat":15.1384786,"lng":120.5631462}	2021-03-17 07:15:49.127+00
3368	4	9	{"lat":15.1379488,"lng":120.5635911}	2021-03-17 07:15:54.155+00
3369	4	9	{"lat":15.137262,"lng":120.5642894}	2021-03-17 07:15:59.146+00
3370	4	9	{"lat":15.1366994,"lng":120.5648394}	2021-03-17 07:16:04.147+00
3371	4	9	{"lat":15.1363169,"lng":120.5652849}	2021-03-17 07:16:09.155+00
3372	4	9	{"lat":15.1358688,"lng":120.5657822}	2021-03-17 07:16:14.158+00
3373	4	9	{"lat":15.1354397,"lng":120.5662362}	2021-03-17 07:16:19.166+00
3374	4	9	{"lat":15.1351848,"lng":120.5665022}	2021-03-17 07:16:24.149+00
3375	4	9	{"lat":15.1349064,"lng":120.5667958}	2021-03-17 07:16:30.166+00
3376	4	9	{"lat":15.1347611,"lng":120.5669468}	2021-03-17 07:16:34.13+00
3377	4	9	{"lat":15.1346717,"lng":120.5671532}	2021-03-17 07:16:40.151+00
3378	4	9	{"lat":15.1347463,"lng":120.5671586}	2021-03-17 07:16:44.145+00
3379	4	9	{"lat":15.1347361,"lng":120.5671861}	2021-03-17 07:16:47.544+00
3380	4	9	{"lat":15.1347408,"lng":120.5672094}	2021-03-17 07:16:54.122+00
3381	4	9	{"lat":15.1347461,"lng":120.5672261}	2021-03-17 07:16:57.47+00
3382	4	9	{"lat":15.134655,"lng":120.5670974}	2021-03-17 07:17:04.881+00
3383	4	9	{"lat":15.1347134,"lng":120.5671793}	2021-03-17 07:17:09.135+00
3384	4	9	{"lat":15.1347147,"lng":120.5671973}	2021-03-17 07:17:14.139+00
3385	4	9	{"lat":15.1347127,"lng":120.5672012}	2021-03-17 07:17:19.123+00
3386	4	9	{"lat":15.1347241,"lng":120.5671896}	2021-03-17 07:17:24.752+00
3387	4	9	{"lat":15.1347166,"lng":120.5671851}	2021-03-17 07:17:29.496+00
3388	4	9	{"lat":15.1346692,"lng":120.5671421}	2021-03-17 07:17:35.068+00
3389	4	9	{"lat":15.1346575,"lng":120.5671306}	2021-03-17 07:17:37.508+00
3390	4	9	{"lat":15.134643,"lng":120.5670985}	2021-03-17 07:17:44.681+00
3391	4	9	{"lat":15.1346272,"lng":120.5670751}	2021-03-17 07:17:49.038+00
3392	4	9	{"lat":15.1346413,"lng":120.5670866}	2021-03-17 07:17:54.138+00
3393	4	9	{"lat":15.1346224,"lng":120.5670809}	2021-03-17 07:17:58.219+00
3394	4	9	{"lat":15.1346232,"lng":120.5670818}	2021-03-17 07:18:03.153+00
3395	4	9	{"lat":15.13464,"lng":120.5671103}	2021-03-17 07:18:09.568+00
3396	4	9	{"lat":15.1346866,"lng":120.5671669}	2021-03-17 07:18:14.595+00
3397	4	9	{"lat":15.1346326,"lng":120.5671188}	2021-03-17 07:18:19.601+00
3398	4	9	{"lat":15.1346097,"lng":120.5670795}	2021-03-17 07:18:24.496+00
3399	4	9	{"lat":15.1346325,"lng":120.5670899}	2021-03-17 07:18:29.499+00
3400	4	9	{"lat":15.1346545,"lng":120.5671307}	2021-03-17 07:18:34.542+00
3401	4	9	{"lat":15.1346089,"lng":120.5670642}	2021-03-17 07:18:39.671+00
3402	4	9	{"lat":15.134584,"lng":120.5670501}	2021-03-17 07:18:44.714+00
3403	4	9	{"lat":15.1346009,"lng":120.5670875}	2021-03-17 07:18:49.594+00
3404	4	9	{"lat":15.1346529,"lng":120.5671484}	2021-03-17 07:18:54.638+00
3405	4	9	{"lat":15.13466,"lng":120.5671485}	2021-03-17 07:18:59.566+00
3406	4	9	{"lat":15.1346419,"lng":120.5671312}	2021-03-17 07:19:04.537+00
3407	4	9	{"lat":15.1346114,"lng":120.5670715}	2021-03-17 07:19:09.584+00
3408	4	9	{"lat":15.1345932,"lng":120.5670515}	2021-03-17 07:19:14.49+00
3409	4	9	{"lat":15.1346797,"lng":120.5671524}	2021-03-17 07:19:19.645+00
3410	4	9	{"lat":15.1346501,"lng":120.5671256}	2021-03-17 07:19:28.944+00
3411	4	9	{"lat":15.1346419,"lng":120.5671153}	2021-03-17 07:19:37.531+00
3412	4	9	{"lat":15.1346429,"lng":120.567117}	2021-03-17 07:19:44.577+00
3413	4	9	{"lat":15.1346371,"lng":120.5671302}	2021-03-17 07:19:49.687+00
3414	4	9	{"lat":15.1346458,"lng":120.5671338}	2021-03-17 07:19:54.515+00
3415	4	9	{"lat":15.1346223,"lng":120.5670939}	2021-03-17 07:19:59.545+00
3416	4	9	{"lat":15.1346252,"lng":120.5670999}	2021-03-17 07:20:03.772+00
3417	4	9	{"lat":15.1345901,"lng":120.56707}	2021-03-17 07:20:09.156+00
3418	4	9	{"lat":15.1345913,"lng":120.5672063}	2021-03-17 07:20:13.962+00
3419	4	9	{"lat":15.1345987,"lng":120.5671913}	2021-03-17 07:20:17.531+00
3420	4	9	{"lat":15.1346538,"lng":120.5672466}	2021-03-17 07:20:24.148+00
3421	4	9	{"lat":15.1347038,"lng":120.5672585}	2021-03-17 07:20:29.129+00
3422	4	9	{"lat":15.1347241,"lng":120.5672652}	2021-03-17 07:20:34.164+00
3423	4	9	{"lat":15.1347238,"lng":120.5672654}	2021-03-17 07:20:39.589+00
3424	4	9	{"lat":15.1346921,"lng":120.5671722}	2021-03-17 07:20:44.143+00
3425	4	9	{"lat":15.1347302,"lng":120.56725}	2021-03-17 07:20:49.154+00
3426	4	9	{"lat":15.1347366,"lng":120.5672548}	2021-03-17 07:20:54.149+00
3427	4	9	{"lat":15.1347375,"lng":120.5672506}	2021-03-17 07:20:59.15+00
3428	4	9	{"lat":15.1347376,"lng":120.5672486}	2021-03-17 07:21:04.153+00
3429	4	9	{"lat":15.1347365,"lng":120.5672474}	2021-03-17 07:21:09.157+00
3430	4	9	{"lat":15.1347346,"lng":120.5672454}	2021-03-17 07:21:14.167+00
3431	4	9	{"lat":15.1347341,"lng":120.5672443}	2021-03-17 07:21:19.162+00
3432	4	9	{"lat":15.134734,"lng":120.567244}	2021-03-17 07:21:22.517+00
3433	4	9	{"lat":15.1347341,"lng":120.5672443}	2021-03-17 07:21:27.676+00
3434	4	9	{"lat":15.1349539,"lng":120.5668515}	2021-03-17 07:21:34.16+00
3435	4	9	{"lat":15.1354875,"lng":120.5663339}	2021-03-17 07:21:39.127+00
3436	4	9	{"lat":15.1358814,"lng":120.5659453}	2021-03-17 07:21:44.146+00
3437	4	9	{"lat":15.136203,"lng":120.5655628}	2021-03-17 07:21:49.151+00
3438	4	9	{"lat":15.1366121,"lng":120.5651171}	2021-03-17 07:21:54.128+00
3439	4	9	{"lat":15.1370884,"lng":120.5645833}	2021-03-17 07:21:59.16+00
3440	4	9	{"lat":15.1375188,"lng":120.5640833}	2021-03-17 07:22:04.158+00
3441	4	9	{"lat":15.1380143,"lng":120.5636659}	2021-03-17 07:22:09.145+00
3442	4	9	{"lat":15.1384906,"lng":120.5632217}	2021-03-17 07:22:14.136+00
3443	4	9	{"lat":15.1389269,"lng":120.5628305}	2021-03-17 07:22:19.143+00
3444	4	9	{"lat":15.1394668,"lng":120.5624393}	2021-03-17 07:22:25.145+00
3445	4	9	{"lat":15.1398714,"lng":120.5622261}	2021-03-17 07:22:29.168+00
3446	4	9	{"lat":15.1403741,"lng":120.5619857}	2021-03-17 07:22:34.132+00
3447	4	9	{"lat":15.1410986,"lng":120.5615317}	2021-03-17 07:22:39.154+00
3448	4	9	{"lat":15.1416188,"lng":120.5611078}	2021-03-17 07:22:45.156+00
3449	4	9	{"lat":15.1420221,"lng":120.5608318}	2021-03-17 07:22:49.148+00
3450	4	9	{"lat":15.1427523,"lng":120.5603269}	2021-03-17 07:22:52.423+00
3451	4	9	{"lat":15.1430934,"lng":120.5601806}	2021-03-17 07:22:59.155+00
3452	4	9	{"lat":15.1435555,"lng":120.559814}	2021-03-17 07:23:04.146+00
3453	4	9	{"lat":15.1439514,"lng":120.559519}	2021-03-17 07:23:09.132+00
3454	4	9	{"lat":15.1443166,"lng":120.5594055}	2021-03-17 07:23:14.142+00
3455	4	9	{"lat":15.1443431,"lng":120.5594321}	2021-03-17 07:23:19.108+00
3456	4	9	{"lat":15.144333,"lng":120.5594304}	2021-03-17 07:23:24.153+00
3457	4	9	{"lat":15.1442861,"lng":120.5594329}	2021-03-17 07:23:29.158+00
3458	4	9	{"lat":15.1442906,"lng":120.5594342}	2021-03-17 07:23:34.132+00
3459	4	9	{"lat":15.1442928,"lng":120.5594344}	2021-03-17 07:23:39.145+00
3460	4	9	{"lat":15.1442965,"lng":120.5594284}	2021-03-17 07:23:44.16+00
3461	4	9	{"lat":15.1443162,"lng":120.5594428}	2021-03-17 07:23:49.139+00
3462	4	9	{"lat":15.1443799,"lng":120.5594586}	2021-03-17 07:23:54.099+00
3463	4	9	{"lat":15.1449995,"lng":120.5594714}	2021-03-17 07:23:59.143+00
3464	4	9	{"lat":15.1457704,"lng":120.5594894}	2021-03-17 07:24:04.142+00
3465	4	9	{"lat":15.1463785,"lng":120.559486}	2021-03-17 07:24:09.133+00
3466	4	9	{"lat":15.1469907,"lng":120.5594482}	2021-03-17 07:24:14.15+00
3467	4	9	{"lat":15.1476662,"lng":120.5594527}	2021-03-17 07:24:19.161+00
3468	4	9	{"lat":15.1483695,"lng":120.5594593}	2021-03-17 07:24:24.136+00
3469	4	9	{"lat":15.1490028,"lng":120.559458}	2021-03-17 07:24:29.141+00
3470	4	9	{"lat":15.149643,"lng":120.5594176}	2021-03-17 07:24:34.153+00
3471	4	9	{"lat":15.1503184,"lng":120.5593899}	2021-03-17 07:24:39.13+00
3472	4	9	{"lat":15.1508532,"lng":120.5594166}	2021-03-17 07:24:44.148+00
3473	4	9	{"lat":15.1514689,"lng":120.5594052}	2021-03-17 07:24:49.135+00
3474	4	9	{"lat":15.1521554,"lng":120.5593929}	2021-03-17 07:24:54.135+00
3475	4	9	{"lat":15.1528947,"lng":120.5596498}	2021-03-17 07:25:00.133+00
3476	4	9	{"lat":15.1533637,"lng":120.5600545}	2021-03-17 07:25:04.153+00
3477	4	9	{"lat":15.15393,"lng":120.5602961}	2021-03-17 07:25:09.154+00
3478	4	9	{"lat":15.1545576,"lng":120.5602756}	2021-03-17 07:25:14.153+00
3479	4	9	{"lat":15.1551725,"lng":120.5602724}	2021-03-17 07:25:19.141+00
3480	4	9	{"lat":15.1562007,"lng":120.5601362}	2021-03-17 07:25:27.166+00
3481	4	9	{"lat":15.1568962,"lng":120.5600324}	2021-03-17 07:25:32.15+00
3482	4	9	{"lat":15.1574904,"lng":120.5599211}	2021-03-17 07:25:37.149+00
3483	4	9	{"lat":15.1578824,"lng":120.5597959}	2021-03-17 07:25:42.143+00
3484	4	9	{"lat":15.1581588,"lng":120.5596033}	2021-03-17 07:25:47.149+00
3485	4	9	{"lat":15.1583041,"lng":120.5591975}	2021-03-17 07:25:52.125+00
3486	4	9	{"lat":15.1584327,"lng":120.558843}	2021-03-17 07:25:57.152+00
3487	4	9	{"lat":15.1586949,"lng":120.5586845}	2021-03-17 07:26:02.146+00
3488	4	9	{"lat":15.1591054,"lng":120.5585589}	2021-03-17 07:26:07.158+00
3489	4	9	{"lat":15.1595088,"lng":120.5584196}	2021-03-17 07:26:12.156+00
3490	4	9	{"lat":15.1601115,"lng":120.5582121}	2021-03-17 07:26:17.147+00
3491	4	9	{"lat":15.160747,"lng":120.5579985}	2021-03-17 07:26:23.125+00
3492	4	9	{"lat":15.1612137,"lng":120.5578356}	2021-03-17 07:26:27.146+00
3493	4	9	{"lat":15.1618911,"lng":120.5576079}	2021-03-17 07:26:32.143+00
3494	4	9	{"lat":15.1624151,"lng":120.5573738}	2021-03-17 07:26:37.147+00
3495	4	9	{"lat":15.1628548,"lng":120.557084}	2021-03-17 07:26:42.139+00
3496	4	9	{"lat":15.1630381,"lng":120.5568824}	2021-03-17 07:26:47.138+00
3497	4	9	{"lat":15.1628204,"lng":120.5566698}	2021-03-17 07:26:52.134+00
3498	4	9	{"lat":15.1626268,"lng":120.5564415}	2021-03-17 07:26:57.174+00
3499	4	9	{"lat":15.1626635,"lng":120.556603}	2021-03-17 07:27:03.139+00
3500	4	9	{"lat":15.1626503,"lng":120.5566398}	2021-03-17 07:27:07.155+00
3501	4	9	{"lat":15.1626613,"lng":120.5566361}	2021-03-17 07:27:12.146+00
3502	4	9	{"lat":15.1626612,"lng":120.5566367}	2021-03-17 07:27:17.139+00
3503	4	9	{"lat":15.1626612,"lng":120.5566367}	2021-03-17 07:27:22.802+00
3504	4	9	{"lat":15.1626735,"lng":120.5565708}	2021-03-17 07:27:27.598+00
3505	4	9	{"lat":15.1626736,"lng":120.5565668}	2021-03-17 07:27:31.343+00
3506	4	9	{"lat":15.1626741,"lng":120.5565652}	2021-03-17 07:27:37.623+00
3507	4	9	{"lat":15.162669,"lng":120.5565728}	2021-03-17 07:27:41.646+00
3508	4	9	{"lat":15.1626667,"lng":120.5565772}	2021-03-17 07:27:45.543+00
3509	4	9	{"lat":15.1626425,"lng":120.5565481}	2021-03-17 07:27:52.596+00
3510	4	9	{"lat":15.1626214,"lng":120.5565366}	2021-03-17 07:27:57.602+00
3511	4	9	{"lat":15.1625842,"lng":120.5565157}	2021-03-17 07:28:02.428+00
3512	4	9	{"lat":15.1625694,"lng":120.5565072}	2021-03-17 07:28:05.65+00
3513	4	9	{"lat":15.1625587,"lng":120.556503}	2021-03-17 07:28:12.542+00
3514	4	9	{"lat":15.1625612,"lng":120.5565139}	2021-03-17 07:28:17.579+00
3515	4	9	{"lat":15.1625666,"lng":120.5565138}	2021-03-17 07:28:20.527+00
3516	4	9	{"lat":15.1625612,"lng":120.5565061}	2021-03-17 07:28:27.634+00
3517	4	9	{"lat":15.1625621,"lng":120.5565}	2021-03-17 07:28:34.168+00
3518	4	9	{"lat":15.1625621,"lng":120.5565}	2021-03-17 07:28:35.392+00
3519	4	9	{"lat":15.1625655,"lng":120.5565005}	2021-03-17 07:28:42.979+00
3520	4	9	{"lat":15.1625641,"lng":120.5564974}	2021-03-17 07:28:47.673+00
3521	4	9	{"lat":15.1625584,"lng":120.5564998}	2021-03-17 07:28:52.585+00
3522	4	9	{"lat":15.1625584,"lng":120.5564998}	2021-03-17 07:28:53.905+00
3523	10	\N	{"lat":"15.1626675","lng":"120.5565606"}	2021-03-17 07:29:01.291+00
3524	6	\N	{"lat":"15.1625573","lng":"120.5565113"}	2021-03-17 07:29:15.647+00
3525	6	\N	{"lat":"15.1626721","lng":"120.556567"}	2021-03-17 07:29:39.106+00
3526	10	\N	{"lat":"15.1626724","lng":"120.5565604"}	2021-03-17 07:29:40.749+00
3527	7	3	{"lat":15.1625585,"lng":120.5564993}	2021-03-17 07:02:27.873+00
3528	7	3	{"lat":15.1625585,"lng":120.5564993}	2021-03-17 07:02:29.67+00
3529	7	3	{"lat":15.1625582,"lng":120.5564991}	2021-03-17 07:02:37.58+00
3530	7	3	{"lat":15.1625563,"lng":120.5565}	2021-03-17 07:02:42.009+00
3531	7	3	{"lat":15.1625499,"lng":120.5565011}	2021-03-17 07:02:44.831+00
3532	7	3	{"lat":15.1625532,"lng":120.5565095}	2021-03-17 07:02:52.083+00
3533	7	3	{"lat":15.1625535,"lng":120.5565086}	2021-03-17 07:02:56.425+00
3534	7	3	{"lat":15.1626446,"lng":120.5565479}	2021-03-17 07:03:02.665+00
3535	7	3	{"lat":15.1626552,"lng":120.5565539}	2021-03-17 07:03:07.349+00
3536	7	3	{"lat":15.1626754,"lng":120.5565653}	2021-03-17 07:03:11.489+00
3537	7	3	{"lat":15.1626835,"lng":120.5565687}	2021-03-17 07:03:14.817+00
3538	7	3	{"lat":15.1626709,"lng":120.5565599}	2021-03-17 07:03:22.254+00
3539	7	3	{"lat":15.1626446,"lng":120.5565653}	2021-03-17 07:03:26.243+00
3540	7	3	{"lat":15.1626422,"lng":120.5565669}	2021-03-17 07:03:30.312+00
3541	7	3	{"lat":15.1626387,"lng":120.5565684}	2021-03-17 07:03:36.237+00
3542	7	3	{"lat":15.1626371,"lng":120.5565703}	2021-03-17 07:03:41.247+00
3543	7	3	{"lat":15.1626459,"lng":120.5566066}	2021-03-17 07:03:46.241+00
3544	7	3	{"lat":15.1626522,"lng":120.556622}	2021-03-17 07:03:51.246+00
3545	7	3	{"lat":15.1626507,"lng":120.5566212}	2021-03-17 07:03:56.253+00
3546	7	3	{"lat":15.1626544,"lng":120.5566167}	2021-03-17 07:04:01.245+00
3547	7	3	{"lat":15.1626578,"lng":120.5566181}	2021-03-17 07:04:06.259+00
3548	7	3	{"lat":15.1626531,"lng":120.5566081}	2021-03-17 07:04:11.232+00
3549	7	3	{"lat":15.1626549,"lng":120.5566056}	2021-03-17 07:04:16.246+00
3550	7	3	{"lat":15.1626602,"lng":120.5565993}	2021-03-17 07:04:21.253+00
3551	7	3	{"lat":15.1626708,"lng":120.5565774}	2021-03-17 07:04:26.245+00
3552	7	3	{"lat":15.1626908,"lng":120.556556}	2021-03-17 07:04:31.236+00
3553	7	3	{"lat":15.1626832,"lng":120.5565743}	2021-03-17 07:04:36.243+00
3554	7	3	{"lat":15.1626913,"lng":120.5565875}	2021-03-17 07:04:40.6+00
3555	7	3	{"lat":15.1627044,"lng":120.556607}	2021-03-17 07:04:44.842+00
3556	7	3	{"lat":15.1627033,"lng":120.5566186}	2021-03-17 07:04:50.998+00
3557	7	3	{"lat":15.1628883,"lng":120.5569069}	2021-03-17 07:04:56.258+00
3558	7	3	{"lat":15.1629302,"lng":120.5570285}	2021-03-17 07:04:59.843+00
3559	7	3	{"lat":15.1629632,"lng":120.5570972}	2021-03-17 07:05:04.808+00
3560	7	3	{"lat":15.1621555,"lng":120.5575979}	2021-03-17 07:05:11.229+00
3561	7	3	{"lat":15.1617021,"lng":120.5577482}	2021-03-17 07:05:16.26+00
3562	7	3	{"lat":15.1613098,"lng":120.5578501}	2021-03-17 07:05:21.249+00
3563	7	3	{"lat":15.1608923,"lng":120.5579666}	2021-03-17 07:05:26.232+00
3564	7	3	{"lat":15.1604268,"lng":120.558112}	2021-03-17 07:05:31.247+00
3565	7	3	{"lat":15.1599107,"lng":120.5582052}	2021-03-17 07:05:36.236+00
3566	7	3	{"lat":15.1595397,"lng":120.558337}	2021-03-17 07:05:41.221+00
3567	7	3	{"lat":15.1591325,"lng":120.5584851}	2021-03-17 07:05:46.253+00
3568	7	3	{"lat":15.1587614,"lng":120.5586091}	2021-03-17 07:05:51.251+00
3569	7	3	{"lat":15.1583941,"lng":120.5587331}	2021-03-17 07:05:56.261+00
3570	7	3	{"lat":15.158384,"lng":120.5587122}	2021-03-17 07:06:01.241+00
3571	7	3	{"lat":15.15836,"lng":120.5587048}	2021-03-17 07:06:05.634+00
3572	7	3	{"lat":15.1582091,"lng":120.5592051}	2021-03-17 07:06:11.251+00
3573	7	3	{"lat":15.1579953,"lng":120.5596111}	2021-03-17 07:06:16.227+00
3574	7	3	{"lat":15.1575681,"lng":120.5598213}	2021-03-17 07:06:21.239+00
3575	7	3	{"lat":15.1569564,"lng":120.5599209}	2021-03-17 07:06:26.235+00
3576	7	3	{"lat":15.1563441,"lng":120.560034}	2021-03-17 07:06:31.241+00
3577	7	3	{"lat":15.155678,"lng":120.5601586}	2021-03-17 07:06:36.228+00
3578	7	3	{"lat":15.15509,"lng":120.5602471}	2021-03-17 07:06:41.221+00
3579	7	3	{"lat":15.1546381,"lng":120.5602679}	2021-03-17 07:06:46.213+00
3580	7	3	{"lat":15.1541775,"lng":120.5602526}	2021-03-17 07:06:51.248+00
3581	7	3	{"lat":15.1539111,"lng":120.5602525}	2021-03-17 07:06:56.244+00
3582	7	3	{"lat":15.1535119,"lng":120.5601956}	2021-03-17 07:07:01.265+00
3583	7	3	{"lat":15.1531234,"lng":120.5599842}	2021-03-17 07:07:06.265+00
3584	7	3	{"lat":15.1527249,"lng":120.5596504}	2021-03-17 07:07:11.233+00
3585	7	3	{"lat":15.1522837,"lng":120.5593795}	2021-03-17 07:07:16.246+00
3586	7	3	{"lat":15.1517999,"lng":120.5592674}	2021-03-17 07:07:21.256+00
3587	7	3	{"lat":15.1514592,"lng":120.5592951}	2021-03-17 07:07:26.235+00
3588	7	3	{"lat":15.1510184,"lng":120.5592902}	2021-03-17 07:07:31.232+00
3589	7	3	{"lat":15.1505537,"lng":120.5592799}	2021-03-17 07:07:36.239+00
3590	7	3	{"lat":15.1501602,"lng":120.5593158}	2021-03-17 07:07:41.257+00
3591	7	3	{"lat":15.1497525,"lng":120.5593632}	2021-03-17 07:07:46.241+00
3592	7	3	{"lat":15.1492676,"lng":120.559325}	2021-03-17 07:07:51.241+00
3593	7	3	{"lat":15.1487087,"lng":120.5593175}	2021-03-17 07:07:56.239+00
3594	7	3	{"lat":15.1480924,"lng":120.5593328}	2021-03-17 07:08:01.248+00
3595	7	3	{"lat":15.1475079,"lng":120.5593329}	2021-03-17 07:08:06.242+00
3596	7	3	{"lat":15.146942,"lng":120.5592951}	2021-03-17 07:08:11.234+00
3597	7	3	{"lat":15.1463438,"lng":120.5593127}	2021-03-17 07:08:16.235+00
3598	7	3	{"lat":15.1457046,"lng":120.5593056}	2021-03-17 07:08:21.239+00
3599	7	3	{"lat":15.1451658,"lng":120.5592879}	2021-03-17 07:08:26.261+00
3600	7	3	{"lat":15.144795,"lng":120.5592869}	2021-03-17 07:08:31.248+00
3601	7	3	{"lat":15.1445601,"lng":120.5592762}	2021-03-17 07:08:36.248+00
3602	7	3	{"lat":15.1445359,"lng":120.5592782}	2021-03-17 07:08:41.246+00
3603	7	3	{"lat":15.1444638,"lng":120.5592547}	2021-03-17 07:08:46.244+00
3604	7	3	{"lat":15.1443985,"lng":120.5592066}	2021-03-17 07:08:51.22+00
3605	7	3	{"lat":15.1443396,"lng":120.5592552}	2021-03-17 07:08:56.242+00
3606	7	3	{"lat":15.1439799,"lng":120.5593227}	2021-03-17 07:09:01.245+00
3607	7	3	{"lat":15.1433768,"lng":120.5597025}	2021-03-17 07:09:06.238+00
3608	7	3	{"lat":15.1429668,"lng":120.5600654}	2021-03-17 07:09:11.24+00
3609	7	3	{"lat":15.1425576,"lng":120.5604065}	2021-03-17 07:09:16.235+00
3610	7	3	{"lat":15.1420564,"lng":120.5607415}	2021-03-17 07:09:21.253+00
3611	7	3	{"lat":15.1414795,"lng":120.5610952}	2021-03-17 07:09:26.232+00
3612	7	3	{"lat":15.1408578,"lng":120.5614544}	2021-03-17 07:09:31.227+00
3613	7	3	{"lat":15.140322,"lng":120.561743}	2021-03-17 07:09:36.239+00
3614	7	3	{"lat":15.139781,"lng":120.5620942}	2021-03-17 07:09:41.24+00
3615	7	3	{"lat":15.1391995,"lng":120.5624732}	2021-03-17 07:09:46.213+00
3616	7	3	{"lat":15.138749,"lng":120.56283}	2021-03-17 07:09:51.227+00
3617	7	3	{"lat":15.1383383,"lng":120.5632927}	2021-03-17 07:09:56.237+00
3618	7	3	{"lat":15.1380111,"lng":120.5635865}	2021-03-17 07:10:01.236+00
3619	7	3	{"lat":15.1379102,"lng":120.5637169}	2021-03-17 07:10:06.248+00
3620	7	3	{"lat":15.1379155,"lng":120.5637095}	2021-03-17 07:10:11.237+00
3621	7	3	{"lat":15.1378564,"lng":120.5637604}	2021-03-17 07:10:16.23+00
3622	7	3	{"lat":15.1377566,"lng":120.5639023}	2021-03-17 07:10:21.246+00
3623	7	3	{"lat":15.1376074,"lng":120.5640979}	2021-03-17 07:10:26.263+00
3624	7	3	{"lat":15.137128,"lng":120.5645061}	2021-03-17 07:10:31.232+00
3625	7	3	{"lat":15.1365935,"lng":120.5650231}	2021-03-17 07:10:36.247+00
3626	7	3	{"lat":15.1360681,"lng":120.565544}	2021-03-17 07:10:41.23+00
3627	7	3	{"lat":15.1354375,"lng":120.566174}	2021-03-17 07:10:46.234+00
3628	7	3	{"lat":15.1351471,"lng":120.5664724}	2021-03-17 07:10:51.251+00
3629	7	3	{"lat":15.1348174,"lng":120.5667974}	2021-03-17 07:10:56.233+00
3630	7	3	{"lat":15.1346028,"lng":120.5669941}	2021-03-17 07:11:01.248+00
3631	7	3	{"lat":15.1346424,"lng":120.5669617}	2021-03-17 07:11:06.245+00
3632	7	3	{"lat":15.1347258,"lng":120.5671248}	2021-03-17 07:11:11.243+00
3633	7	3	{"lat":15.1347236,"lng":120.5672001}	2021-03-17 07:11:16.252+00
3634	7	3	{"lat":15.1347108,"lng":120.5671891}	2021-03-17 07:11:21.251+00
3635	7	3	{"lat":15.1346964,"lng":120.5671338}	2021-03-17 07:11:26.245+00
3636	7	3	{"lat":15.1346849,"lng":120.5671135}	2021-03-17 07:11:31.238+00
3637	7	3	{"lat":15.1346617,"lng":120.5670954}	2021-03-17 07:11:36.239+00
3638	7	3	{"lat":15.1346446,"lng":120.5670813}	2021-03-17 07:11:41.683+00
3639	7	3	{"lat":15.1346306,"lng":120.5670585}	2021-03-17 07:11:46.61+00
3640	7	3	{"lat":15.1346493,"lng":120.5671029}	2021-03-17 07:11:51.62+00
3641	7	3	{"lat":15.134699,"lng":120.5671637}	2021-03-17 07:11:56.64+00
3642	7	3	{"lat":15.1346561,"lng":120.5670927}	2021-03-17 07:12:02.252+00
3643	7	3	{"lat":15.1346282,"lng":120.567062}	2021-03-17 07:12:06.66+00
3644	7	3	{"lat":15.1345806,"lng":120.5670105}	2021-03-17 07:12:11.607+00
3645	7	3	{"lat":15.1346096,"lng":120.567097}	2021-03-17 07:12:16.582+00
3646	7	3	{"lat":15.134596,"lng":120.5670875}	2021-03-17 07:12:21.817+00
3647	7	3	{"lat":15.1345762,"lng":120.56707}	2021-03-17 07:12:26.928+00
3648	7	3	{"lat":15.1345762,"lng":120.56707}	2021-03-17 07:12:34.696+00
3649	7	3	{"lat":15.1345762,"lng":120.56707}	2021-03-17 07:12:39.671+00
3650	7	3	{"lat":15.1345762,"lng":120.56707}	2021-03-17 07:12:44.683+00
3651	7	3	{"lat":15.1345762,"lng":120.56707}	2021-03-17 07:12:54.899+00
3652	7	3	{"lat":15.1345762,"lng":120.56707}	2021-03-17 07:13:20.238+00
3653	7	3	{"lat":15.1348281,"lng":120.5672994}	2021-03-17 07:13:23.529+00
3654	7	3	{"lat":15.1348281,"lng":120.5672994}	2021-03-17 07:13:28.384+00
3655	7	3	{"lat":15.1348281,"lng":120.5672994}	2021-03-17 07:13:33.387+00
3656	7	3	{"lat":15.1348281,"lng":120.5672994}	2021-03-17 07:13:38.39+00
3657	7	3	{"lat":15.1348281,"lng":120.5672994}	2021-03-17 07:13:43.392+00
3658	7	3	{"lat":15.1348281,"lng":120.5672994}	2021-03-17 07:13:48.381+00
3659	7	3	{"lat":15.1348281,"lng":120.5672994}	2021-03-17 07:13:53.382+00
3660	7	3	{"lat":15.1348281,"lng":120.5672994}	2021-03-17 07:13:58.702+00
3661	7	3	{"lat":15.1347155,"lng":120.567181}	2021-03-17 07:14:05.229+00
3662	7	3	{"lat":15.1347173,"lng":120.5671855}	2021-03-17 07:14:09.217+00
3663	7	3	{"lat":15.1347184,"lng":120.567189}	2021-03-17 07:14:15.249+00
3664	7	3	{"lat":15.1347192,"lng":120.5671895}	2021-03-17 07:14:20.233+00
3665	7	3	{"lat":15.1347209,"lng":120.5671907}	2021-03-17 07:14:24.559+00
3666	7	3	{"lat":15.1347206,"lng":120.5671913}	2021-03-17 07:14:28.466+00
3667	7	3	{"lat":15.1347206,"lng":120.5671913}	2021-03-17 07:14:33.384+00
3668	7	3	{"lat":15.1347206,"lng":120.5671913}	2021-03-17 07:14:38.382+00
3669	7	3	{"lat":15.1347206,"lng":120.5671913}	2021-03-17 07:14:43.401+00
3670	7	3	{"lat":15.1347206,"lng":120.5671913}	2021-03-17 07:14:48.383+00
3671	7	3	{"lat":15.1347206,"lng":120.5671913}	2021-03-17 07:14:53.388+00
3672	7	3	{"lat":15.1494492,"lng":120.58315}	2021-03-17 07:23:17.457+00
3673	7	3	{"lat":15.1501215,"lng":120.5848009}	2021-03-17 07:23:18.393+00
3674	7	3	{"lat":15.1501212,"lng":120.5847917}	2021-03-17 07:23:23.495+00
3675	7	3	{"lat":15.150123,"lng":120.5847884}	2021-03-17 07:23:28.501+00
3676	7	3	{"lat":15.1501231,"lng":120.5847886}	2021-03-17 07:23:33.494+00
3677	7	3	{"lat":15.1501233,"lng":120.5847886}	2021-03-17 07:23:38.475+00
3678	7	3	{"lat":15.1501233,"lng":120.5847887}	2021-03-17 07:23:43.485+00
3679	7	3	{"lat":15.1501239,"lng":120.5847818}	2021-03-17 07:23:48.431+00
3680	7	3	{"lat":15.1501253,"lng":120.5847909}	2021-03-17 07:23:53.522+00
3681	7	3	{"lat":15.1501256,"lng":120.5848026}	2021-03-17 07:23:58.497+00
3682	7	3	{"lat":15.1501437,"lng":120.584813}	2021-03-17 07:24:03.487+00
3683	7	3	{"lat":15.1501263,"lng":120.5848219}	2021-03-17 07:24:23.473+00
3684	7	3	{"lat":15.1501175,"lng":120.5848304}	2021-03-17 07:24:28.474+00
3685	7	3	{"lat":15.1500998,"lng":120.584827}	2021-03-17 07:24:33.472+00
3686	7	3	{"lat":15.1501753,"lng":120.5849489}	2021-03-17 07:24:38.478+00
3687	7	3	{"lat":15.1503136,"lng":120.5853143}	2021-03-17 07:24:43.471+00
3688	7	3	{"lat":15.1504334,"lng":120.5855818}	2021-03-17 07:24:48.481+00
3689	7	3	{"lat":15.1505545,"lng":120.5859212}	2021-03-17 07:24:53.505+00
3690	7	3	{"lat":15.1506967,"lng":120.5863308}	2021-03-17 07:24:58.477+00
3691	7	3	{"lat":15.1508606,"lng":120.5868168}	2021-03-17 07:25:03.482+00
3692	7	3	{"lat":15.1510012,"lng":120.5872307}	2021-03-17 07:25:08.467+00
3693	7	3	{"lat":15.1511342,"lng":120.5876071}	2021-03-17 07:25:13.512+00
3694	7	3	{"lat":15.1511893,"lng":120.587731}	2021-03-17 07:25:18.473+00
3695	7	3	{"lat":15.1512282,"lng":120.5878236}	2021-03-17 07:25:23.499+00
3696	7	3	{"lat":15.1513682,"lng":120.588156}	2021-03-17 07:25:28.488+00
3697	7	3	{"lat":15.1515512,"lng":120.5885457}	2021-03-17 07:25:33.491+00
3698	7	3	{"lat":15.1517384,"lng":120.588958}	2021-03-17 07:25:38.46+00
3699	7	3	{"lat":15.1519164,"lng":120.5893201}	2021-03-17 07:25:43.457+00
3700	7	3	{"lat":15.1520293,"lng":120.5895731}	2021-03-17 07:25:48.49+00
3701	7	3	{"lat":15.15218,"lng":120.5899199}	2021-03-17 07:25:53.482+00
3702	7	3	{"lat":15.1523129,"lng":120.5902137}	2021-03-17 07:25:58.479+00
3703	7	3	{"lat":15.1524796,"lng":120.5905908}	2021-03-17 07:26:03.464+00
3704	7	3	{"lat":15.1526222,"lng":120.5909284}	2021-03-17 07:26:08.458+00
3705	7	3	{"lat":15.1527622,"lng":120.5912187}	2021-03-17 07:26:13.481+00
3706	7	3	{"lat":15.152861,"lng":120.5914763}	2021-03-17 07:26:18.474+00
3707	7	3	{"lat":15.152926,"lng":120.591732}	2021-03-17 07:26:23.499+00
3708	7	3	{"lat":15.1529026,"lng":120.591804}	2021-03-17 07:26:28.466+00
3709	7	3	{"lat":15.1529071,"lng":120.5917937}	2021-03-17 07:26:33.491+00
3710	7	3	{"lat":15.1529092,"lng":120.591799}	2021-03-17 07:26:38.478+00
3711	7	3	{"lat":15.1528704,"lng":120.5918476}	2021-03-17 07:26:43.475+00
3712	7	3	{"lat":15.1527996,"lng":120.5919468}	2021-03-17 07:26:48.48+00
3713	7	3	{"lat":15.1528077,"lng":120.592083}	2021-03-17 07:26:53.499+00
3714	7	3	{"lat":15.1528725,"lng":120.5920977}	2021-03-17 07:26:58.501+00
3715	7	3	{"lat":15.1531642,"lng":120.5920278}	2021-03-17 07:27:03.447+00
3716	7	3	{"lat":15.1535675,"lng":120.5920399}	2021-03-17 07:27:08.494+00
3717	7	3	{"lat":15.1540472,"lng":120.5920844}	2021-03-17 07:27:13.509+00
3718	7	3	{"lat":15.1545355,"lng":120.5921167}	2021-03-17 07:27:18.468+00
3719	7	3	{"lat":15.1549433,"lng":120.5921459}	2021-03-17 07:27:23.471+00
3720	7	3	{"lat":15.1553198,"lng":120.5921775}	2021-03-17 07:27:28.458+00
3721	7	3	{"lat":15.1556994,"lng":120.5922107}	2021-03-17 07:27:33.489+00
3722	7	3	{"lat":15.1560958,"lng":120.5922536}	2021-03-17 07:27:38.439+00
3723	7	3	{"lat":15.156354,"lng":120.5922797}	2021-03-17 07:27:43.433+00
3724	7	3	{"lat":15.1569904,"lng":120.5923248}	2021-03-17 07:27:48.397+00
3725	7	3	{"lat":15.1574187,"lng":120.592319}	2021-03-17 07:27:53.426+00
3726	7	3	{"lat":15.1577877,"lng":120.5922715}	2021-03-17 07:27:58.465+00
3727	7	3	{"lat":15.1581075,"lng":120.592208}	2021-03-17 07:28:03.456+00
3728	7	3	{"lat":15.158431,"lng":120.5921234}	2021-03-17 07:28:08.492+00
3729	7	3	{"lat":15.1588123,"lng":120.5920318}	2021-03-17 07:28:13.48+00
3730	7	3	{"lat":15.1592371,"lng":120.5919446}	2021-03-17 07:28:18.467+00
3731	7	3	{"lat":15.1596579,"lng":120.5918316}	2021-03-17 07:28:23.468+00
3732	7	3	{"lat":15.1600411,"lng":120.5917338}	2021-03-17 07:28:28.434+00
3733	7	3	{"lat":15.1604366,"lng":120.5916212}	2021-03-17 07:28:33.467+00
3734	7	3	{"lat":15.1604366,"lng":120.5916212}	2021-03-17 07:28:38.392+00
3735	7	3	{"lat":15.1604366,"lng":120.5916212}	2021-03-17 07:28:43.402+00
3736	7	3	{"lat":15.1604366,"lng":120.5916212}	2021-03-17 07:28:48.389+00
3737	7	3	{"lat":15.1604366,"lng":120.5916212}	2021-03-17 07:28:53.395+00
3738	7	3	{"lat":15.1604366,"lng":120.5916212}	2021-03-17 07:28:58.393+00
3739	7	3	{"lat":15.1604366,"lng":120.5916212}	2021-03-17 07:29:03.396+00
3740	7	3	{"lat":15.1638681,"lng":120.59079}	2021-03-17 07:29:35.037+00
3741	7	3	{"lat":15.1638722,"lng":120.5907907}	2021-03-17 07:29:40.244+00
3742	7	\N	{"lat":"15.1638765","lng":"120.5907914"}	2021-03-17 07:29:45.237+00
3745	4	\N	{"lat":"15.1626905","lng":"120.5565625"}	2021-03-17 07:30:07.363+00
3748	7	\N	{"lat":"15.1641922","lng":"120.5905146"}	2021-03-17 07:30:17.928+00
3750	10	\N	{"lat":"15.162679","lng":"120.556563"}	2021-03-17 07:30:40.783+00
5209	10	\N	{"lat":"15.1658172","lng":"120.582301"}	2021-03-17 07:58:47.724+00
5272	4	35	{"lat":15.1634454,"lng":120.5553063}	2021-03-17 07:35:35.001+00
5273	4	35	{"lat":15.1634745,"lng":120.5553354}	2021-03-17 07:35:40.046+00
5274	4	35	{"lat":15.1634754,"lng":120.5553478}	2021-03-17 07:35:45.059+00
5275	4	35	{"lat":15.1633849,"lng":120.5552709}	2021-03-17 07:35:48.379+00
5276	4	35	{"lat":15.1634535,"lng":120.5553322}	2021-03-17 07:35:55.016+00
5277	4	35	{"lat":15.1634653,"lng":120.5553379}	2021-03-17 07:36:00.097+00
5278	4	35	{"lat":15.1634024,"lng":120.555277}	2021-03-17 07:36:03.383+00
5279	4	35	{"lat":15.1634473,"lng":120.5553188}	2021-03-17 07:36:10.074+00
5280	4	35	{"lat":15.1634093,"lng":120.5552808}	2021-03-17 07:36:13.429+00
5281	4	35	{"lat":15.1634579,"lng":120.5553192}	2021-03-17 07:36:20.057+00
5282	4	35	{"lat":15.1634701,"lng":120.5553395}	2021-03-17 07:36:25.059+00
5283	4	35	{"lat":15.1634105,"lng":120.5552999}	2021-03-17 07:36:28.369+00
5284	4	35	{"lat":15.1634462,"lng":120.5553159}	2021-03-17 07:36:35.093+00
5285	4	35	{"lat":15.1633976,"lng":120.5553053}	2021-03-17 07:36:38.365+00
5286	4	35	{"lat":15.1634553,"lng":120.5553285}	2021-03-17 07:36:45.047+00
5287	4	35	{"lat":15.1633971,"lng":120.555308}	2021-03-17 07:36:48.368+00
5288	4	35	{"lat":15.1634614,"lng":120.555331}	2021-03-17 07:36:55.007+00
5289	4	35	{"lat":15.1634613,"lng":120.5553325}	2021-03-17 07:37:00.108+00
5290	4	35	{"lat":15.1634003,"lng":120.5553142}	2021-03-17 07:37:03.37+00
5291	4	35	{"lat":15.1633913,"lng":120.5553133}	2021-03-17 07:37:10.162+00
5292	4	35	{"lat":15.1633885,"lng":120.5553129}	2021-03-17 07:37:15.035+00
5293	4	35	{"lat":15.1634333,"lng":120.555338}	2021-03-17 07:37:20.047+00
5294	4	35	{"lat":15.1634638,"lng":120.5553497}	2021-03-17 07:37:25.059+00
5295	4	35	{"lat":15.1633974,"lng":120.5553223}	2021-03-17 07:37:28.4+00
5296	4	35	{"lat":15.163471,"lng":120.5553277}	2021-03-17 07:37:35.018+00
5297	4	35	{"lat":15.1634748,"lng":120.5553277}	2021-03-17 07:37:40.043+00
5298	4	35	{"lat":15.1633937,"lng":120.5553217}	2021-03-17 07:37:43.375+00
5299	4	35	{"lat":15.1633957,"lng":120.5553226}	2021-03-17 07:37:50.13+00
5300	4	35	{"lat":15.1633957,"lng":120.5553226}	2021-03-17 07:37:55.055+00
5301	4	35	{"lat":15.163395,"lng":120.5553267}	2021-03-17 07:37:58.397+00
3743	4	\N	{"lat":"15.1626823","lng":"120.5565552"}	2021-03-17 07:29:58.044+00
3744	4	\N	{"lat":"15.1626823","lng":"120.5565552"}	2021-03-17 07:29:58.752+00
3746	6	\N	{"lat":"15.162669","lng":"120.5565592"}	2021-03-17 07:30:09.537+00
3747	10	\N	{"lat":"15.1626704","lng":"120.5565618"}	2021-03-17 07:30:10.896+00
3749	6	\N	{"lat":"15.1626799","lng":"120.5565599"}	2021-03-17 07:30:26.511+00
3751	10	\N	{"lat":"15.162675","lng":"120.5565589"}	2021-03-17 07:33:00.711+00
3752	9	36	{"lat":15.1661646,"lng":120.582253}	2021-03-17 07:20:46.368+00
3753	9	36	{"lat":15.1662155,"lng":120.5819322}	2021-03-17 07:20:50.002+00
3754	9	36	{"lat":15.1661637,"lng":120.5815196}	2021-03-17 07:20:55.412+00
3755	9	36	{"lat":15.1660762,"lng":120.581053}	2021-03-17 07:21:00.383+00
3756	9	36	{"lat":15.1659831,"lng":120.5805653}	2021-03-17 07:21:05.386+00
3757	9	36	{"lat":15.1658774,"lng":120.580067}	2021-03-17 07:21:10.436+00
3758	9	36	{"lat":15.1657987,"lng":120.5796109}	2021-03-17 07:21:15.408+00
3759	9	36	{"lat":15.1657494,"lng":120.5792051}	2021-03-17 07:21:20.392+00
3760	9	36	{"lat":15.1656549,"lng":120.5788097}	2021-03-17 07:21:25.401+00
3761	9	36	{"lat":15.1655567,"lng":120.5783939}	2021-03-17 07:21:30.405+00
3762	9	36	{"lat":15.1654828,"lng":120.577945}	2021-03-17 07:21:35.39+00
3763	9	36	{"lat":15.1654104,"lng":120.5774824}	2021-03-17 07:21:40.393+00
3764	9	36	{"lat":15.1653258,"lng":120.5769831}	2021-03-17 07:21:45.406+00
3765	9	36	{"lat":15.1652747,"lng":120.5765302}	2021-03-17 07:21:50.397+00
3766	9	36	{"lat":15.1652699,"lng":120.5760674}	2021-03-17 07:21:55.378+00
3767	9	36	{"lat":15.1652908,"lng":120.5755638}	2021-03-17 07:22:00.408+00
3768	9	36	{"lat":15.1653441,"lng":120.5750412}	2021-03-17 07:22:05.421+00
3769	9	36	{"lat":15.1654183,"lng":120.5746105}	2021-03-17 07:22:10.406+00
3770	9	36	{"lat":15.1654706,"lng":120.5742531}	2021-03-17 07:22:15.405+00
3771	9	36	{"lat":15.1655162,"lng":120.5739185}	2021-03-17 07:22:20.392+00
3772	9	36	{"lat":15.1655632,"lng":120.5735783}	2021-03-17 07:22:25.407+00
3773	9	36	{"lat":15.165629,"lng":120.5731465}	2021-03-17 07:22:30.402+00
3774	9	36	{"lat":15.1657114,"lng":120.5726509}	2021-03-17 07:22:35.424+00
3775	9	36	{"lat":15.1657877,"lng":120.572137}	2021-03-17 07:22:40.427+00
3776	9	36	{"lat":15.165843,"lng":120.5716623}	2021-03-17 07:22:46.87+00
3777	9	36	{"lat":15.1659647,"lng":120.5709851}	2021-03-17 07:22:52.408+00
3778	9	36	{"lat":15.1660304,"lng":120.5705034}	2021-03-17 07:22:57.429+00
3779	9	36	{"lat":15.1661153,"lng":120.5699962}	2021-03-17 07:23:02.421+00
3780	9	36	{"lat":15.1661987,"lng":120.569476}	2021-03-17 07:23:07.335+00
3781	9	36	{"lat":15.1662752,"lng":120.5689647}	2021-03-17 07:23:12.35+00
3782	9	36	{"lat":15.1663531,"lng":120.5684377}	2021-03-17 07:23:17.418+00
3783	9	36	{"lat":15.1664412,"lng":120.5678988}	2021-03-17 07:23:22.417+00
3784	9	36	{"lat":15.1665363,"lng":120.5673163}	2021-03-17 07:23:27.414+00
3785	9	36	{"lat":15.166625,"lng":120.5667225}	2021-03-17 07:23:32.422+00
3786	9	36	{"lat":15.1667107,"lng":120.5661114}	2021-03-17 07:23:37.401+00
3787	9	36	{"lat":15.1667601,"lng":120.5654771}	2021-03-17 07:23:42.425+00
3788	9	36	{"lat":15.1667044,"lng":120.5649534}	2021-03-17 07:23:47.45+00
3789	9	36	{"lat":15.16665,"lng":120.5645398}	2021-03-17 07:23:52.421+00
3790	9	36	{"lat":15.1665899,"lng":120.5642565}	2021-03-17 07:23:57.413+00
3791	9	36	{"lat":15.166535,"lng":120.5638881}	2021-03-17 07:24:02.416+00
3792	9	36	{"lat":15.1664803,"lng":120.5634332}	2021-03-17 07:24:07.425+00
3793	9	36	{"lat":15.1664298,"lng":120.5629225}	2021-03-17 07:24:12.462+00
3794	9	36	{"lat":15.1663779,"lng":120.562425}	2021-03-17 07:24:17.418+00
3795	9	36	{"lat":15.1663174,"lng":120.5619619}	2021-03-17 07:24:22.46+00
3796	9	36	{"lat":15.1662741,"lng":120.5614938}	2021-03-17 07:24:27.413+00
3797	9	36	{"lat":15.1661732,"lng":120.5609937}	2021-03-17 07:24:32.456+00
3798	9	36	{"lat":15.1660097,"lng":120.5605339}	2021-03-17 07:24:37.446+00
3799	9	36	{"lat":15.1657823,"lng":120.560118}	2021-03-17 07:24:42.451+00
3800	9	36	{"lat":15.1655565,"lng":120.5596749}	2021-03-17 07:24:47.442+00
3801	9	36	{"lat":15.1653364,"lng":120.5592376}	2021-03-17 07:24:52.488+00
3802	9	36	{"lat":15.1651273,"lng":120.5588211}	2021-03-17 07:24:57.471+00
3803	9	36	{"lat":15.1649968,"lng":120.5585465}	2021-03-17 07:25:02.462+00
3804	9	36	{"lat":15.1649824,"lng":120.5585178}	2021-03-17 07:25:06.787+00
3805	9	36	{"lat":15.1649041,"lng":120.5583467}	2021-03-17 07:25:12.291+00
3806	9	36	{"lat":15.1649041,"lng":120.5583467}	2021-03-17 07:25:16.861+00
3807	9	36	{"lat":15.1649041,"lng":120.5583467}	2021-03-17 07:25:21.837+00
3808	9	36	{"lat":15.1649041,"lng":120.5583467}	2021-03-17 07:25:26.858+00
3809	9	36	{"lat":15.1649041,"lng":120.5583467}	2021-03-17 07:25:31.867+00
3810	9	36	{"lat":15.1649041,"lng":120.5583467}	2021-03-17 07:25:36.886+00
3811	9	36	{"lat":15.1649041,"lng":120.5583467}	2021-03-17 07:25:41.878+00
3812	9	36	{"lat":15.1649041,"lng":120.5583467}	2021-03-17 07:26:13.996+00
3813	9	36	{"lat":15.1649041,"lng":120.5583467}	2021-03-17 07:26:23.483+00
3814	9	36	{"lat":15.1643759,"lng":120.5572738}	2021-03-17 07:26:29.877+00
3815	9	36	{"lat":15.1640655,"lng":120.5567037}	2021-03-17 07:26:34.093+00
3816	9	36	{"lat":15.1637834,"lng":120.5561365}	2021-03-17 07:26:39.224+00
3817	9	36	{"lat":15.1634053,"lng":120.5554173}	2021-03-17 07:26:45.395+00
3818	9	36	{"lat":15.1633318,"lng":120.5552731}	2021-03-17 07:26:48.336+00
3819	9	36	{"lat":15.1630053,"lng":120.5547298}	2021-03-17 07:26:54.282+00
3820	9	36	{"lat":15.1626857,"lng":120.5548548}	2021-03-17 07:26:59.231+00
3821	9	36	{"lat":15.1622349,"lng":120.5551209}	2021-03-17 07:27:04.214+00
3822	9	36	{"lat":15.1617183,"lng":120.5554056}	2021-03-17 07:27:09.281+00
3823	9	36	{"lat":15.1611963,"lng":120.5556756}	2021-03-17 07:27:14.174+00
3824	9	36	{"lat":15.1606934,"lng":120.5559464}	2021-03-17 07:27:19.198+00
3825	9	36	{"lat":15.1602228,"lng":120.5562011}	2021-03-17 07:27:24.176+00
3826	9	36	{"lat":15.1599266,"lng":120.5563791}	2021-03-17 07:27:29.202+00
3827	9	36	{"lat":15.1599268,"lng":120.5564325}	2021-03-17 07:27:34.172+00
3828	9	36	{"lat":15.1599301,"lng":120.5564342}	2021-03-17 07:27:38.713+00
3829	9	36	{"lat":15.1599428,"lng":120.5564255}	2021-03-17 07:27:44.166+00
3830	9	36	{"lat":15.1599437,"lng":120.5564248}	2021-03-17 07:27:49.199+00
3831	9	36	{"lat":15.1599438,"lng":120.5564248}	2021-03-17 07:27:54.226+00
3832	9	36	{"lat":15.1599438,"lng":120.5564248}	2021-03-17 07:27:58.344+00
3833	9	36	{"lat":15.1599438,"lng":120.5564248}	2021-03-17 07:28:03.411+00
3834	9	36	{"lat":15.1599438,"lng":120.5564248}	2021-03-17 07:28:08.335+00
3835	9	36	{"lat":15.1600256,"lng":120.5565374}	2021-03-17 07:28:13.345+00
3836	9	36	{"lat":15.1600256,"lng":120.5565374}	2021-03-17 07:28:18.367+00
3837	9	36	{"lat":15.1600199,"lng":120.5565862}	2021-03-17 07:28:23.398+00
3838	9	36	{"lat":15.1600199,"lng":120.5565862}	2021-03-17 07:28:28.393+00
3839	9	36	{"lat":15.1600199,"lng":120.5565862}	2021-03-17 07:28:33.403+00
3840	9	36	{"lat":15.1600199,"lng":120.5565862}	2021-03-17 07:28:38.3+00
3841	9	36	{"lat":15.1600199,"lng":120.5565862}	2021-03-17 07:28:43.292+00
3842	9	36	{"lat":15.1600199,"lng":120.5565862}	2021-03-17 07:28:48.349+00
3843	9	36	{"lat":15.1600199,"lng":120.5565862}	2021-03-17 07:28:53.293+00
3844	9	36	{"lat":15.1600199,"lng":120.5565862}	2021-03-17 07:28:58.324+00
3845	9	36	{"lat":15.1600199,"lng":120.5565862}	2021-03-17 07:29:03.356+00
3846	9	36	{"lat":15.1600199,"lng":120.5565862}	2021-03-17 07:29:08.385+00
3847	9	36	{"lat":15.1600199,"lng":120.5565862}	2021-03-17 07:29:13.348+00
3848	9	36	{"lat":15.1600199,"lng":120.5565862}	2021-03-17 07:29:18.413+00
3849	9	36	{"lat":15.1600199,"lng":120.5565862}	2021-03-17 07:29:23.378+00
3850	9	36	{"lat":15.1600199,"lng":120.5565862}	2021-03-17 07:29:28.356+00
3851	9	36	{"lat":15.1600199,"lng":120.5565862}	2021-03-17 07:29:33.405+00
3852	9	36	{"lat":15.1600199,"lng":120.5565862}	2021-03-17 07:29:38.357+00
3853	9	36	{"lat":15.1600199,"lng":120.5565862}	2021-03-17 07:29:43.386+00
3854	9	36	{"lat":15.1600199,"lng":120.5565862}	2021-03-17 07:29:48.331+00
3855	9	36	{"lat":15.1600199,"lng":120.5565862}	2021-03-17 07:29:53.374+00
3856	9	36	{"lat":15.1600199,"lng":120.5565862}	2021-03-17 07:29:58.367+00
3857	9	36	{"lat":15.1600199,"lng":120.5565862}	2021-03-17 07:30:03.372+00
3858	9	36	{"lat":15.1600199,"lng":120.5565862}	2021-03-17 07:30:08.392+00
3859	9	36	{"lat":15.1611132,"lng":120.5559173}	2021-03-17 07:30:14.173+00
3860	9	36	{"lat":15.1611572,"lng":120.5560204}	2021-03-17 07:30:19.215+00
3861	9	36	{"lat":15.1612222,"lng":120.556161}	2021-03-17 07:30:24.197+00
3862	9	36	{"lat":15.1613108,"lng":120.5563353}	2021-03-17 07:30:29.204+00
3863	9	36	{"lat":15.1614181,"lng":120.5563521}	2021-03-17 07:30:34.202+00
3864	9	36	{"lat":15.1614777,"lng":120.5562908}	2021-03-17 07:30:39.225+00
3865	9	36	{"lat":15.1616823,"lng":120.5561556}	2021-03-17 07:30:43.729+00
3866	9	36	{"lat":15.1617993,"lng":120.5561161}	2021-03-17 07:30:48.423+00
3867	9	36	{"lat":15.1617993,"lng":120.5561161}	2021-03-17 07:30:53.388+00
3868	9	36	{"lat":15.1617993,"lng":120.5561161}	2021-03-17 07:30:58.419+00
3869	9	36	{"lat":15.1618202,"lng":120.5561107}	2021-03-17 07:31:03.991+00
3870	9	36	{"lat":15.1624486,"lng":120.5561262}	2021-03-17 07:31:08.627+00
3871	9	36	{"lat":15.162532,"lng":120.5563081}	2021-03-17 07:31:13.305+00
3872	9	36	{"lat":15.1626649,"lng":120.556547}	2021-03-17 07:31:19.312+00
3873	9	36	{"lat":15.162669,"lng":120.5565589}	2021-03-17 07:31:24.197+00
3874	9	36	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:31:29.338+00
3875	9	36	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:31:33.397+00
3876	9	36	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:31:38.395+00
3877	9	36	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:31:43.405+00
3878	9	36	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:31:48.403+00
3879	9	36	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:31:53.403+00
3880	9	36	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:31:58.401+00
3881	9	36	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:32:03.397+00
3882	9	36	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:32:08.324+00
3883	9	36	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:32:13.343+00
3884	9	36	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:32:18.313+00
3885	9	36	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:32:23.349+00
3886	9	36	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:32:28.407+00
3887	9	36	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:32:33.324+00
3888	9	36	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:32:38.345+00
3889	9	36	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:32:43.387+00
3890	9	36	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:32:48.323+00
3891	9	36	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:32:53.382+00
3892	9	36	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:32:58.331+00
3893	9	36	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:33:03.314+00
3894	9	36	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:33:08.331+00
3895	9	36	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:33:13.295+00
3896	9	36	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:33:14.357+00
3897	9	\N	{"lat":"15.1626714","lng":"120.5565598"}	2021-03-17 07:33:15.699+00
3898	1	44	{"lat":15.1625625,"lng":120.5565084}	2021-03-17 07:24:03.009+00
3899	1	44	{"lat":15.1625512,"lng":120.5565057}	2021-03-17 07:24:13.003+00
3900	1	44	{"lat":15.1626534,"lng":120.5565575}	2021-03-17 07:24:23.037+00
3901	1	44	{"lat":15.1626704,"lng":120.5565637}	2021-03-17 07:24:33.027+00
3902	1	44	{"lat":15.1626657,"lng":120.5565566}	2021-03-17 07:24:42.964+00
3903	1	44	{"lat":15.1626729,"lng":120.5565603}	2021-03-17 07:24:52.968+00
3904	1	44	{"lat":15.1626792,"lng":120.5565484}	2021-03-17 07:24:58.042+00
3905	1	44	{"lat":15.1626801,"lng":120.5565617}	2021-03-17 07:25:07.936+00
3906	1	44	{"lat":15.1626772,"lng":120.5565558}	2021-03-17 07:25:13.008+00
3907	1	44	{"lat":15.1627514,"lng":120.5565467}	2021-03-17 07:25:19.34+00
3908	1	44	{"lat":15.1627367,"lng":120.5565973}	2021-03-17 07:25:24.307+00
3909	1	44	{"lat":15.1626981,"lng":120.5565649}	2021-03-17 07:25:29.276+00
3910	1	44	{"lat":15.1627307,"lng":120.5565609}	2021-03-17 07:25:34.327+00
3911	1	44	{"lat":15.1626753,"lng":120.556572}	2021-03-17 07:25:39.715+00
3912	1	44	{"lat":15.1626646,"lng":120.5565366}	2021-03-17 07:25:44.279+00
3913	1	44	{"lat":15.1627212,"lng":120.5565039}	2021-03-17 07:25:49.711+00
3914	1	44	{"lat":15.1626608,"lng":120.5564919}	2021-03-17 07:25:54.406+00
3915	1	44	{"lat":15.1624723,"lng":120.5561179}	2021-03-17 07:25:59.816+00
3916	1	44	{"lat":15.1624723,"lng":120.5561179}	2021-03-17 07:26:01.727+00
3917	1	44	{"lat":15.1624105,"lng":120.5559324}	2021-03-17 07:26:06.854+00
3918	1	44	{"lat":15.1621144,"lng":120.5559522}	2021-03-17 07:26:13.059+00
3919	1	44	{"lat":15.1620452,"lng":120.5561671}	2021-03-17 07:26:19.642+00
3920	1	44	{"lat":15.1618094,"lng":120.5562554}	2021-03-17 07:26:24.806+00
3921	1	44	{"lat":15.1618094,"lng":120.5562554}	2021-03-17 07:26:26.729+00
3922	1	44	{"lat":15.1613334,"lng":120.5564117}	2021-03-17 07:26:34.326+00
3923	1	44	{"lat":15.1612886,"lng":120.5561889}	2021-03-17 07:26:39.658+00
3924	1	44	{"lat":15.1611525,"lng":120.5559198}	2021-03-17 07:26:44.753+00
3925	1	44	{"lat":15.1611525,"lng":120.5559198}	2021-03-17 07:26:46.725+00
3926	1	44	{"lat":15.1610601,"lng":120.5557525}	2021-03-17 07:26:53.073+00
3927	1	44	{"lat":15.1609974,"lng":120.5558603}	2021-03-17 07:26:59.349+00
3928	1	44	{"lat":15.1606726,"lng":120.5560031}	2021-03-17 07:27:04.769+00
3929	1	44	{"lat":15.1606726,"lng":120.5560031}	2021-03-17 07:27:06.728+00
3930	1	44	{"lat":15.1600635,"lng":120.5563457}	2021-03-17 07:27:14.412+00
3931	1	44	{"lat":15.1599456,"lng":120.5564516}	2021-03-17 07:27:19.344+00
3932	1	44	{"lat":15.1599347,"lng":120.5564857}	2021-03-17 07:27:24.36+00
3933	1	44	{"lat":15.1599851,"lng":120.5565533}	2021-03-17 07:27:29.338+00
3934	1	44	{"lat":15.1599859,"lng":120.5565618}	2021-03-17 07:27:34.725+00
3935	1	44	{"lat":15.1599859,"lng":120.5565618}	2021-03-17 07:27:36.728+00
3936	1	44	{"lat":15.1599835,"lng":120.5565613}	2021-03-17 07:27:41.834+00
3937	1	44	{"lat":15.160021,"lng":120.5565709}	2021-03-17 07:27:48.058+00
3938	1	44	{"lat":15.1599664,"lng":120.5565499}	2021-03-17 07:27:55.745+00
3939	1	44	{"lat":15.1599664,"lng":120.5565499}	2021-03-17 07:27:56.704+00
3940	1	44	{"lat":15.1599498,"lng":120.5565435}	2021-03-17 07:28:01.86+00
3941	1	44	{"lat":15.1600239,"lng":120.5565816}	2021-03-17 07:28:08.027+00
3942	1	44	{"lat":15.1600098,"lng":120.556544}	2021-03-17 07:28:15.044+00
3943	1	44	{"lat":15.1600098,"lng":120.556544}	2021-03-17 07:28:16.741+00
3944	1	44	{"lat":15.1600008,"lng":120.5565264}	2021-03-17 07:28:21.837+00
3945	1	44	{"lat":15.1600211,"lng":120.5565866}	2021-03-17 07:28:28.029+00
3946	1	44	{"lat":15.1599622,"lng":120.5564861}	2021-03-17 07:28:34.547+00
3947	1	44	{"lat":15.1600242,"lng":120.5565736}	2021-03-17 07:28:40.156+00
3948	1	44	{"lat":15.1600242,"lng":120.5565736}	2021-03-17 07:28:41.726+00
3949	1	44	{"lat":15.1601887,"lng":120.5566277}	2021-03-17 07:28:48.726+00
3950	1	44	{"lat":15.1597872,"lng":120.5563629}	2021-03-17 07:28:55.036+00
3951	1	44	{"lat":15.1597872,"lng":120.5563629}	2021-03-17 07:28:56.726+00
3952	1	44	{"lat":15.1599679,"lng":120.556541}	2021-03-17 07:29:04.796+00
3953	1	44	{"lat":15.1599679,"lng":120.556541}	2021-03-17 07:29:06.704+00
3954	1	44	{"lat":15.1601341,"lng":120.5563962}	2021-03-17 07:29:13.097+00
3955	1	44	{"lat":15.160162,"lng":120.5563813}	2021-03-17 07:29:19.761+00
3956	1	44	{"lat":15.160162,"lng":120.5563813}	2021-03-17 07:29:21.726+00
3957	1	44	{"lat":15.1602884,"lng":120.5563361}	2021-03-17 07:29:26.853+00
3958	1	44	{"lat":15.1609661,"lng":120.5558875}	2021-03-17 07:29:33.069+00
3959	1	44	{"lat":15.1611692,"lng":120.5559844}	2021-03-17 07:29:39.375+00
3960	1	44	{"lat":15.161313,"lng":120.5562009}	2021-03-17 07:29:44.845+00
3961	1	44	{"lat":15.161313,"lng":120.5562009}	2021-03-17 07:29:46.724+00
3962	1	44	{"lat":15.1613637,"lng":120.5563081}	2021-03-17 07:29:53.072+00
3963	1	44	{"lat":15.1616397,"lng":120.5562495}	2021-03-17 07:29:59.707+00
3964	1	44	{"lat":15.1618924,"lng":120.5561452}	2021-03-17 07:30:04.775+00
3965	1	44	{"lat":15.1618924,"lng":120.5561452}	2021-03-17 07:30:06.726+00
3966	1	44	{"lat":15.1621985,"lng":120.5559442}	2021-03-17 07:30:13.115+00
3967	1	44	{"lat":15.162345,"lng":120.5560891}	2021-03-17 07:30:19.856+00
3968	1	44	{"lat":15.162345,"lng":120.5560891}	2021-03-17 07:30:21.738+00
3969	1	44	{"lat":15.162399,"lng":120.5561996}	2021-03-17 07:30:26.903+00
3970	1	44	{"lat":15.1626709,"lng":120.5565437}	2021-03-17 07:30:33.035+00
3971	1	44	{"lat":15.1627439,"lng":120.5563354}	2021-03-17 07:30:41.077+00
3972	1	44	{"lat":15.1627439,"lng":120.5563354}	2021-03-17 07:30:41.73+00
3973	1	44	{"lat":15.1627499,"lng":120.5562724}	2021-03-17 07:30:46.866+00
3974	1	44	{"lat":15.1626725,"lng":120.5565452}	2021-03-17 07:30:53.053+00
3975	1	44	{"lat":15.1626655,"lng":120.5564619}	2021-03-17 07:31:02.993+00
3976	1	44	{"lat":15.1626674,"lng":120.5565569}	2021-03-17 07:31:12.993+00
3977	1	44	{"lat":15.1626663,"lng":120.5565665}	2021-03-17 07:31:23.029+00
3978	1	44	{"lat":15.1626678,"lng":120.5565652}	2021-03-17 07:31:33.022+00
3979	1	44	{"lat":15.1626677,"lng":120.5565629}	2021-03-17 07:31:42.995+00
3980	1	44	{"lat":15.1626411,"lng":120.5565498}	2021-03-17 07:31:52.969+00
3981	1	44	{"lat":15.1626486,"lng":120.5565483}	2021-03-17 07:31:58.051+00
3982	1	44	{"lat":15.1625652,"lng":120.5565122}	2021-03-17 07:32:07.979+00
3983	1	44	{"lat":15.1625593,"lng":120.5565094}	2021-03-17 07:32:13.004+00
3984	1	44	{"lat":15.1625603,"lng":120.5564947}	2021-03-17 07:32:23.017+00
3985	1	44	{"lat":15.1625597,"lng":120.5565035}	2021-03-17 07:32:28.105+00
3986	1	44	{"lat":15.1625564,"lng":120.5565073}	2021-03-17 07:32:37.979+00
3987	1	44	{"lat":15.162559,"lng":120.5565093}	2021-03-17 07:32:48.005+00
3988	1	44	{"lat":15.1625657,"lng":120.5565029}	2021-03-17 07:32:58.038+00
3989	1	44	{"lat":15.1625625,"lng":120.5564971}	2021-03-17 07:33:03.057+00
3990	1	44	{"lat":15.1625612,"lng":120.5564918}	2021-03-17 07:33:13.08+00
3991	8	32	{"lat":15.1664983,"lng":120.5833639}	2021-03-17 07:20:48.808+00
3992	8	32	{"lat":15.1664983,"lng":120.5833639}	2021-03-17 07:20:50.046+00
3993	8	32	{"lat":15.1661008,"lng":120.5814742}	2021-03-17 07:20:56.158+00
3994	8	32	{"lat":15.1659902,"lng":120.5807006}	2021-03-17 07:21:01.117+00
3995	8	32	{"lat":15.1659382,"lng":120.5803218}	2021-03-17 07:21:06.152+00
3996	8	32	{"lat":15.1658547,"lng":120.5798664}	2021-03-17 07:21:11.117+00
3997	8	32	{"lat":15.1657717,"lng":120.5794108}	2021-03-17 07:21:16.29+00
3998	8	32	{"lat":15.1657283,"lng":120.5790164}	2021-03-17 07:21:21.144+00
3999	8	32	{"lat":15.1656435,"lng":120.5786121}	2021-03-17 07:21:26.115+00
4000	8	32	{"lat":15.1655442,"lng":120.5781805}	2021-03-17 07:21:31.18+00
4001	8	32	{"lat":15.165474,"lng":120.5777357}	2021-03-17 07:21:36.117+00
4002	8	32	{"lat":15.1654149,"lng":120.5772657}	2021-03-17 07:21:41.145+00
4003	8	32	{"lat":15.1653661,"lng":120.5767883}	2021-03-17 07:21:46.165+00
4004	8	32	{"lat":15.1653247,"lng":120.5763179}	2021-03-17 07:21:51.153+00
4005	8	32	{"lat":15.1653076,"lng":120.5758426}	2021-03-17 07:21:56.147+00
4006	8	32	{"lat":15.1653268,"lng":120.5753472}	2021-03-17 07:22:01.103+00
4007	8	32	{"lat":15.1653372,"lng":120.5753342}	2021-03-17 07:22:05.055+00
4008	8	32	{"lat":15.1654562,"lng":120.5744368}	2021-03-17 07:22:11.201+00
4009	8	32	{"lat":15.1655311,"lng":120.5740627}	2021-03-17 07:22:16.166+00
4010	8	32	{"lat":15.165579,"lng":120.5737186}	2021-03-17 07:22:21.166+00
4011	8	32	{"lat":15.1656234,"lng":120.5733655}	2021-03-17 07:22:26.173+00
4012	8	32	{"lat":15.1656867,"lng":120.5729473}	2021-03-17 07:22:31.145+00
4013	8	32	{"lat":15.1657663,"lng":120.5724901}	2021-03-17 07:22:36.159+00
4014	8	32	{"lat":15.1658544,"lng":120.5719532}	2021-03-17 07:22:41.127+00
4015	8	32	{"lat":15.1659355,"lng":120.5714227}	2021-03-17 07:22:46.141+00
4016	8	32	{"lat":15.1660104,"lng":120.570926}	2021-03-17 07:22:51.13+00
4017	8	32	{"lat":15.1660812,"lng":120.5704365}	2021-03-17 07:22:56.137+00
4018	8	32	{"lat":15.1661474,"lng":120.5699377}	2021-03-17 07:23:01.12+00
4019	8	32	{"lat":15.1662192,"lng":120.5694175}	2021-03-17 07:23:06.177+00
4020	8	32	{"lat":15.166294,"lng":120.5688887}	2021-03-17 07:23:11.133+00
4021	8	32	{"lat":15.1663738,"lng":120.5683667}	2021-03-17 07:23:16.124+00
4022	8	32	{"lat":15.1663748,"lng":120.5683596}	2021-03-17 07:23:20.057+00
4023	8	32	{"lat":15.1665541,"lng":120.5672412}	2021-03-17 07:23:26.104+00
4024	8	32	{"lat":15.1665562,"lng":120.5672287}	2021-03-17 07:23:30.056+00
4025	8	32	{"lat":15.16674,"lng":120.5660543}	2021-03-17 07:23:36.173+00
4026	8	32	{"lat":15.1667675,"lng":120.5654611}	2021-03-17 07:23:41.11+00
4027	8	32	{"lat":15.166694,"lng":120.5649346}	2021-03-17 07:23:46.126+00
4028	8	32	{"lat":15.1666535,"lng":120.5645432}	2021-03-17 07:23:51.065+00
4029	8	32	{"lat":15.1665935,"lng":120.5642194}	2021-03-17 07:23:56.123+00
4030	8	32	{"lat":15.1665505,"lng":120.5638577}	2021-03-17 07:24:01.15+00
4031	8	32	{"lat":15.1665029,"lng":120.563412}	2021-03-17 07:24:06.192+00
4032	8	32	{"lat":15.1664616,"lng":120.5628987}	2021-03-17 07:24:11.178+00
4033	8	32	{"lat":15.1664006,"lng":120.5623944}	2021-03-17 07:24:16.134+00
4034	8	32	{"lat":15.1663475,"lng":120.5619322}	2021-03-17 07:24:21.168+00
4035	8	32	{"lat":15.1662976,"lng":120.5614674}	2021-03-17 07:24:26.168+00
4036	8	32	{"lat":15.1662972,"lng":120.5614592}	2021-03-17 07:24:30.06+00
4037	8	32	{"lat":15.1660506,"lng":120.5605192}	2021-03-17 07:24:37.459+00
4038	8	32	{"lat":15.1658372,"lng":120.5600693}	2021-03-17 07:24:42.552+00
4039	8	32	{"lat":15.1656021,"lng":120.5596325}	2021-03-17 07:24:47.543+00
4040	8	32	{"lat":15.1653747,"lng":120.559191}	2021-03-17 07:24:52.744+00
4041	8	32	{"lat":15.16516,"lng":120.5587813}	2021-03-17 07:24:57.718+00
4042	8	32	{"lat":15.1649967,"lng":120.5584807}	2021-03-17 07:25:02.584+00
4043	8	32	{"lat":15.1648445,"lng":120.5581867}	2021-03-17 07:25:07.574+00
4044	8	32	{"lat":15.1646845,"lng":120.5578702}	2021-03-17 07:25:12.587+00
4045	8	32	{"lat":15.1645086,"lng":120.5575136}	2021-03-17 07:25:17.538+00
4046	8	32	{"lat":15.1642935,"lng":120.5570553}	2021-03-17 07:25:22.524+00
4047	8	32	{"lat":15.1640019,"lng":120.5564698}	2021-03-17 07:25:27.591+00
4048	8	32	{"lat":15.1636365,"lng":120.5557745}	2021-03-17 07:25:32.506+00
4049	8	32	{"lat":15.1632885,"lng":120.5551182}	2021-03-17 07:25:37.547+00
4050	8	32	{"lat":15.1630679,"lng":120.5547406}	2021-03-17 07:25:42.568+00
4051	8	32	{"lat":15.1629919,"lng":120.554737}	2021-03-17 07:25:47.593+00
4052	8	32	{"lat":15.1627887,"lng":120.554874}	2021-03-17 07:25:52.599+00
4053	8	32	{"lat":15.1619154,"lng":120.5553118}	2021-03-17 07:25:57.569+00
4054	8	32	{"lat":15.1613542,"lng":120.555598}	2021-03-17 07:26:02.597+00
4055	8	32	{"lat":15.1608345,"lng":120.5558718}	2021-03-17 07:26:07.529+00
4056	8	32	{"lat":15.1603423,"lng":120.556131}	2021-03-17 07:26:12.591+00
4057	8	32	{"lat":15.1599818,"lng":120.5563641}	2021-03-17 07:26:17.536+00
4058	8	32	{"lat":15.1599314,"lng":120.5564849}	2021-03-17 07:26:22.67+00
4059	8	32	{"lat":15.1599409,"lng":120.5564802}	2021-03-17 07:26:27.533+00
4060	8	32	{"lat":15.1599432,"lng":120.5564709}	2021-03-17 07:26:32.548+00
4061	8	32	{"lat":15.159944,"lng":120.556469}	2021-03-17 07:26:37.546+00
4062	8	32	{"lat":15.1599444,"lng":120.5564687}	2021-03-17 07:26:42.549+00
4063	8	32	{"lat":15.1599445,"lng":120.5564687}	2021-03-17 07:26:47.576+00
4064	8	32	{"lat":15.159961,"lng":120.5565079}	2021-03-17 07:26:52.555+00
4065	8	32	{"lat":15.1599654,"lng":120.5565112}	2021-03-17 07:26:57.695+00
4066	8	32	{"lat":15.1599669,"lng":120.5565116}	2021-03-17 07:27:02.547+00
4067	8	32	{"lat":15.1599679,"lng":120.5565118}	2021-03-17 07:27:07.53+00
4068	8	32	{"lat":15.1599683,"lng":120.5565118}	2021-03-17 07:27:12.563+00
4069	8	32	{"lat":15.1599685,"lng":120.5565118}	2021-03-17 07:27:17.496+00
4070	8	32	{"lat":15.1599686,"lng":120.5565118}	2021-03-17 07:27:22.546+00
4071	8	32	{"lat":15.1599687,"lng":120.5565118}	2021-03-17 07:27:27.53+00
4072	8	32	{"lat":15.1599687,"lng":120.5565118}	2021-03-17 07:27:32.641+00
4073	8	32	{"lat":15.1599687,"lng":120.5565118}	2021-03-17 07:27:37.553+00
4074	8	32	{"lat":15.1599687,"lng":120.5565118}	2021-03-17 07:27:42.499+00
4075	8	32	{"lat":15.1599687,"lng":120.5565118}	2021-03-17 07:27:47.501+00
4076	8	32	{"lat":15.1599687,"lng":120.5565118}	2021-03-17 07:27:52.547+00
4077	8	32	{"lat":15.1599687,"lng":120.5565118}	2021-03-17 07:27:57.524+00
4078	8	32	{"lat":15.1599687,"lng":120.5565118}	2021-03-17 07:28:02.526+00
4079	8	32	{"lat":15.1599687,"lng":120.5565118}	2021-03-17 07:28:07.481+00
4080	8	32	{"lat":15.1599687,"lng":120.5565118}	2021-03-17 07:28:12.539+00
4081	8	32	{"lat":15.1599687,"lng":120.5565118}	2021-03-17 07:28:17.516+00
4082	8	32	{"lat":15.1599687,"lng":120.5565118}	2021-03-17 07:28:22.535+00
4083	8	32	{"lat":15.1599687,"lng":120.5565118}	2021-03-17 07:28:27.63+00
4084	8	32	{"lat":15.1599687,"lng":120.5565118}	2021-03-17 07:28:32.511+00
4085	8	32	{"lat":15.1599687,"lng":120.5565118}	2021-03-17 07:28:37.574+00
4086	8	32	{"lat":15.1599789,"lng":120.5564765}	2021-03-17 07:28:42.506+00
4087	8	32	{"lat":15.1599855,"lng":120.5564655}	2021-03-17 07:28:47.555+00
4088	8	32	{"lat":15.1599871,"lng":120.5564638}	2021-03-17 07:28:52.55+00
4089	8	32	{"lat":15.1599909,"lng":120.5564612}	2021-03-17 07:28:57.695+00
4090	8	32	{"lat":15.1599915,"lng":120.556461}	2021-03-17 07:29:02.486+00
4091	8	32	{"lat":15.1599923,"lng":120.5564608}	2021-03-17 07:29:07.522+00
4092	8	32	{"lat":15.1599926,"lng":120.5564608}	2021-03-17 07:29:12.552+00
4093	8	32	{"lat":15.1599928,"lng":120.5564608}	2021-03-17 07:29:17.496+00
4094	8	32	{"lat":15.1599929,"lng":120.5564608}	2021-03-17 07:29:22.565+00
4095	8	32	{"lat":15.159993,"lng":120.5564608}	2021-03-17 07:29:27.588+00
4096	8	32	{"lat":15.159993,"lng":120.5564608}	2021-03-17 07:29:32.557+00
4097	8	32	{"lat":15.159993,"lng":120.5564608}	2021-03-17 07:29:37.554+00
4098	8	32	{"lat":15.159993,"lng":120.5564608}	2021-03-17 07:29:42.578+00
4099	8	32	{"lat":15.159993,"lng":120.5564608}	2021-03-17 07:29:47.61+00
4100	8	32	{"lat":15.1599979,"lng":120.5564619}	2021-03-17 07:29:52.526+00
4101	8	32	{"lat":15.16005,"lng":120.5564304}	2021-03-17 07:29:56.926+00
4102	8	32	{"lat":15.1606891,"lng":120.556053}	2021-03-17 07:30:02.552+00
4103	8	32	{"lat":15.1610069,"lng":120.5558835}	2021-03-17 07:30:07.584+00
4104	8	32	{"lat":15.161138,"lng":120.555911}	2021-03-17 07:30:12.595+00
4105	8	32	{"lat":15.1611362,"lng":120.5559781}	2021-03-17 07:30:17.523+00
4106	8	32	{"lat":15.1611472,"lng":120.555991}	2021-03-17 07:30:21.931+00
4107	8	32	{"lat":15.1612066,"lng":120.5561036}	2021-03-17 07:30:26.948+00
4108	8	32	{"lat":15.1612059,"lng":120.5561025}	2021-03-17 07:30:31.933+00
4109	8	32	{"lat":15.1616625,"lng":120.5562625}	2021-03-17 07:30:37.621+00
4110	8	32	{"lat":15.1618124,"lng":120.5562121}	2021-03-17 07:30:41.797+00
4111	8	32	{"lat":15.1618645,"lng":120.5561157}	2021-03-17 07:30:46.746+00
4112	8	32	{"lat":15.1619162,"lng":120.5560824}	2021-03-17 07:30:51.674+00
4113	8	32	{"lat":15.1623888,"lng":120.5559759}	2021-03-17 07:30:57.645+00
4114	8	32	{"lat":15.1624218,"lng":120.5559969}	2021-03-17 07:31:02.498+00
4115	8	32	{"lat":15.1624605,"lng":120.5560894}	2021-03-17 07:31:06.805+00
4116	8	32	{"lat":15.1624948,"lng":120.5561757}	2021-03-17 07:31:11.892+00
4117	8	32	{"lat":15.1626197,"lng":120.5564276}	2021-03-17 07:31:16.695+00
4118	8	32	{"lat":15.1627195,"lng":120.5566267}	2021-03-17 07:31:22.608+00
4119	8	32	{"lat":15.1626925,"lng":120.5565864}	2021-03-17 07:31:26.603+00
4120	8	32	{"lat":15.1626689,"lng":120.5565553}	2021-03-17 07:31:31.948+00
4121	8	32	{"lat":15.1626397,"lng":120.5565927}	2021-03-17 07:31:37.581+00
4122	8	32	{"lat":15.1626502,"lng":120.5566326}	2021-03-17 07:31:42.47+00
4123	8	32	{"lat":15.162686,"lng":120.5565771}	2021-03-17 07:31:46.591+00
4124	8	32	{"lat":15.1626861,"lng":120.5565562}	2021-03-17 07:31:52.483+00
4125	8	32	{"lat":15.1626618,"lng":120.5565613}	2021-03-17 07:31:57.141+00
4126	8	32	{"lat":15.1626674,"lng":120.5565676}	2021-03-17 07:32:02.472+00
4127	8	32	{"lat":15.1626731,"lng":120.5565717}	2021-03-17 07:32:06.725+00
4128	8	32	{"lat":15.1626724,"lng":120.5565706}	2021-03-17 07:32:11.269+00
4129	8	32	{"lat":15.1626722,"lng":120.5565682}	2021-03-17 07:32:16.221+00
4130	8	32	{"lat":15.1626681,"lng":120.5565652}	2021-03-17 07:32:22.355+00
4131	8	32	{"lat":15.1626454,"lng":120.5565525}	2021-03-17 07:32:26.229+00
4132	8	32	{"lat":15.1626272,"lng":120.5565388}	2021-03-17 07:32:32.71+00
4133	8	32	{"lat":15.1625844,"lng":120.5565171}	2021-03-17 07:32:38.125+00
4134	8	32	{"lat":15.1625632,"lng":120.5565093}	2021-03-17 07:32:43.08+00
4135	8	32	{"lat":15.1625507,"lng":120.556501}	2021-03-17 07:32:48.465+00
4136	8	32	{"lat":15.1625481,"lng":120.5564936}	2021-03-17 07:32:53.435+00
4137	8	32	{"lat":15.16256,"lng":120.5564972}	2021-03-17 07:32:58.319+00
4138	8	32	{"lat":15.1626208,"lng":120.5565329}	2021-03-17 07:33:02.524+00
4139	8	32	{"lat":15.1626178,"lng":120.5565324}	2021-03-17 07:33:07.671+00
4140	8	32	{"lat":15.1626064,"lng":120.5565248}	2021-03-17 07:33:13.298+00
4141	8	32	{"lat":15.1626012,"lng":120.5565215}	2021-03-17 07:33:18.184+00
4142	8	32	{"lat":15.1625985,"lng":120.5565183}	2021-03-17 07:33:23.025+00
4143	8	32	{"lat":15.1625629,"lng":120.5564977}	2021-03-17 07:33:29.077+00
4144	8	32	{"lat":15.1625568,"lng":120.5564937}	2021-03-17 07:33:33.073+00
4145	8	32	{"lat":15.1625577,"lng":120.556495}	2021-03-17 07:33:38.213+00
4146	8	\N	{"lat":"15.1625628","lng":"120.5564977"}	2021-03-17 07:33:44.014+00
4147	9	\N	{"lat":"15.1626714","lng":"120.5565598"}	2021-03-17 07:33:46.876+00
4148	10	\N	{"lat":"15.162675","lng":"120.5565589"}	2021-03-17 07:33:58.865+00
4149	8	\N	{"lat":"15.1625557","lng":"120.5565094"}	2021-03-17 07:34:15.46+00
4150	9	\N	{"lat":"15.1626714","lng":"120.5565598"}	2021-03-17 07:34:17.02+00
4151	8	\N	{"lat":"15.1625885","lng":"120.5565026"}	2021-03-17 07:34:45.379+00
4152	9	\N	{"lat":"15.1626714","lng":"120.5565598"}	2021-03-17 07:34:47.106+00
4153	8	\N	{"lat":"15.1626714","lng":"120.5565611"}	2021-03-17 07:34:58.94+00
4154	3	2	{"lat":15.1638763,"lng":120.5907844}	2021-03-17 07:34:41.405+00
4155	3	2	{"lat":15.1639286,"lng":120.5907793}	2021-03-17 07:34:47.212+00
4156	3	2	{"lat":15.1641186,"lng":120.5907733}	2021-03-17 07:34:52.126+00
4157	3	2	{"lat":15.1639999,"lng":120.590802}	2021-03-17 07:34:57.262+00
4158	3	\N	{"lat":"15.1641904","lng":"120.5907768"}	2021-03-17 07:35:03.365+00
4159	8	\N	{"lat":"15.1626695","lng":"120.5565632"}	2021-03-17 07:35:04.525+00
4160	3	\N	{"lat":"15.1645823","lng":"120.5905246"}	2021-03-17 07:35:23.692+00
4161	2	14	{"lat":15.1636215,"lng":120.5908888}	2021-03-17 07:09:35.161+00
4162	2	14	{"lat":15.1633287,"lng":120.5908583}	2021-03-17 07:09:40.082+00
4163	2	14	{"lat":15.1633287,"lng":120.5908583}	2021-03-17 07:09:43.11+00
4164	2	14	{"lat":15.1633287,"lng":120.5908583}	2021-03-17 07:10:14.121+00
4165	2	14	{"lat":15.1633287,"lng":120.5908583}	2021-03-17 07:10:27.115+00
4166	2	14	{"lat":15.1633287,"lng":120.5908583}	2021-03-17 07:10:51.613+00
4167	2	14	{"lat":15.1633287,"lng":120.5908583}	2021-03-17 07:11:03.029+00
4168	2	14	{"lat":15.1633287,"lng":120.5908583}	2021-03-17 07:11:33.13+00
4169	2	14	{"lat":15.1633287,"lng":120.5908583}	2021-03-17 07:11:44.41+00
4170	2	14	{"lat":15.1633287,"lng":120.5908583}	2021-03-17 07:11:53.356+00
4171	2	14	{"lat":15.1633287,"lng":120.5908583}	2021-03-17 07:12:21.641+00
4172	2	14	{"lat":15.1633287,"lng":120.5908583}	2021-03-17 07:13:11.58+00
4173	2	14	{"lat":15.1633287,"lng":120.5908583}	2021-03-17 07:13:41.452+00
4174	2	14	{"lat":15.1633287,"lng":120.5908583}	2021-03-17 07:13:49.557+00
4175	2	14	{"lat":15.1633287,"lng":120.5908583}	2021-03-17 07:13:57.369+00
4176	2	14	{"lat":15.1633287,"lng":120.5908583}	2021-03-17 07:14:02.384+00
4177	2	14	{"lat":15.1633287,"lng":120.5908583}	2021-03-17 07:14:24.533+00
4178	2	14	{"lat":15.1633287,"lng":120.5908583}	2021-03-17 07:14:47.851+00
4179	2	14	{"lat":15.1633287,"lng":120.5908583}	2021-03-17 07:14:55.146+00
4180	2	14	{"lat":15.1633287,"lng":120.5908583}	2021-03-17 07:15:23.528+00
4181	2	14	{"lat":15.1633287,"lng":120.5908583}	2021-03-17 07:15:42.072+00
4182	2	14	{"lat":15.1633287,"lng":120.5908583}	2021-03-17 07:15:47.07+00
4183	2	14	{"lat":15.1633287,"lng":120.5908583}	2021-03-17 07:15:55.3+00
4184	2	14	{"lat":15.1633287,"lng":120.5908583}	2021-03-17 07:16:11.369+00
4185	2	14	{"lat":15.1633287,"lng":120.5908583}	2021-03-17 07:16:41.083+00
4186	2	14	{"lat":15.1633287,"lng":120.5908583}	2021-03-17 07:17:55.157+00
4187	2	14	{"lat":15.1633287,"lng":120.5908583}	2021-03-17 07:18:08.787+00
4188	2	14	{"lat":15.1633287,"lng":120.5908583}	2021-03-17 07:18:31.501+00
4189	2	14	{"lat":15.1633287,"lng":120.5908583}	2021-03-17 07:18:40.898+00
4190	2	14	{"lat":15.1633287,"lng":120.5908583}	2021-03-17 07:18:45.89+00
4191	2	14	{"lat":15.1633287,"lng":120.5908583}	2021-03-17 07:19:10.338+00
4192	2	14	{"lat":15.1633287,"lng":120.5908583}	2021-03-17 07:19:30.063+00
4193	2	14	{"lat":15.1444615,"lng":120.5598091}	2021-03-17 07:21:42.778+00
4194	2	14	{"lat":15.1444615,"lng":120.5598091}	2021-03-17 07:21:46.612+00
4195	2	14	{"lat":15.1444615,"lng":120.5598091}	2021-03-17 07:22:13.558+00
4196	2	14	{"lat":15.1444615,"lng":120.5598091}	2021-03-17 07:22:18.571+00
4197	2	14	{"lat":15.1444615,"lng":120.5598091}	2021-03-17 07:22:23.526+00
4198	2	14	{"lat":15.1444615,"lng":120.5598091}	2021-03-17 07:22:28.596+00
4199	2	14	{"lat":15.1444615,"lng":120.5598091}	2021-03-17 07:22:58.972+00
4200	2	14	{"lat":15.1444615,"lng":120.5598091}	2021-03-17 07:23:14.521+00
4201	2	14	{"lat":15.1444615,"lng":120.5598091}	2021-03-17 07:23:29.759+00
4202	2	14	{"lat":15.1444615,"lng":120.5598091}	2021-03-17 07:23:37.966+00
4203	2	14	{"lat":15.1444615,"lng":120.5598091}	2021-03-17 07:24:05.182+00
4204	2	14	{"lat":15.1444615,"lng":120.5598091}	2021-03-17 07:24:10.177+00
4205	2	14	{"lat":15.1345925,"lng":120.5671256}	2021-03-17 07:24:15.361+00
4206	2	14	{"lat":15.1346077,"lng":120.5670985}	2021-03-17 07:24:22.214+00
4207	2	14	{"lat":15.1346057,"lng":120.567064}	2021-03-17 07:24:27.577+00
4208	2	14	{"lat":15.1345929,"lng":120.5671291}	2021-03-17 07:24:33.436+00
4209	2	14	{"lat":15.1345929,"lng":120.5671291}	2021-03-17 07:24:35.18+00
4210	2	14	{"lat":15.1345914,"lng":120.5670486}	2021-03-17 07:24:43.6+00
4211	2	14	{"lat":15.1345914,"lng":120.5670486}	2021-03-17 07:24:45.142+00
4212	2	14	{"lat":15.1345923,"lng":120.5670872}	2021-03-17 07:25:03.312+00
4213	2	14	{"lat":15.1346771,"lng":120.5673244}	2021-03-17 07:25:11.535+00
4214	2	14	{"lat":15.13468,"lng":120.5673325}	2021-03-17 07:25:18.359+00
4215	2	14	{"lat":15.1346838,"lng":120.567171}	2021-03-17 07:25:23.379+00
4216	2	14	{"lat":15.1345899,"lng":120.5670803}	2021-03-17 07:25:28.406+00
4217	2	14	{"lat":15.1346187,"lng":120.567084}	2021-03-17 07:25:33.374+00
4218	2	14	{"lat":15.1346358,"lng":120.5671009}	2021-03-17 07:25:37.337+00
4219	2	14	{"lat":15.1345964,"lng":120.5671416}	2021-03-17 07:25:46.694+00
4220	2	14	{"lat":15.1345817,"lng":120.5671541}	2021-03-17 07:25:51.362+00
4221	2	14	{"lat":15.1345817,"lng":120.5671541}	2021-03-17 07:25:56.361+00
4222	2	14	{"lat":15.1345429,"lng":120.5670934}	2021-03-17 07:26:01.586+00
4223	2	14	{"lat":15.1346081,"lng":120.5670879}	2021-03-17 07:26:06.533+00
4224	2	14	{"lat":15.1345874,"lng":120.5670909}	2021-03-17 07:26:13.404+00
4225	2	14	{"lat":15.1345946,"lng":120.5670779}	2021-03-17 07:26:18.377+00
4226	2	14	{"lat":15.1345843,"lng":120.5670796}	2021-03-17 07:26:22.38+00
4227	2	14	{"lat":15.1345843,"lng":120.5670796}	2021-03-17 07:26:26.426+00
4228	2	14	{"lat":15.1345843,"lng":120.5670796}	2021-03-17 07:26:31.387+00
4229	2	14	{"lat":15.1345843,"lng":120.5670796}	2021-03-17 07:26:36.386+00
4230	2	14	{"lat":15.1345843,"lng":120.5670796}	2021-03-17 07:26:41.385+00
4231	2	14	{"lat":15.1345843,"lng":120.5670796}	2021-03-17 07:26:46.385+00
4232	2	14	{"lat":15.1345843,"lng":120.5670796}	2021-03-17 07:26:51.404+00
4233	2	14	{"lat":15.134586,"lng":120.5670933}	2021-03-17 07:26:56.465+00
4234	2	14	{"lat":15.134586,"lng":120.5670933}	2021-03-17 07:27:01.384+00
4235	2	14	{"lat":15.134586,"lng":120.5670933}	2021-03-17 07:27:09.451+00
4236	2	14	{"lat":15.134586,"lng":120.5670933}	2021-03-17 07:27:55.55+00
4237	2	14	{"lat":15.134586,"lng":120.5670933}	2021-03-17 07:28:59.42+00
4238	2	14	{"lat":15.134586,"lng":120.5670933}	2021-03-17 07:29:04.7+00
4239	2	14	{"lat":15.134586,"lng":120.5670933}	2021-03-17 07:29:09.755+00
4240	2	14	{"lat":15.134586,"lng":120.5670933}	2021-03-17 07:29:54.916+00
4241	2	14	{"lat":15.134586,"lng":120.5670933}	2021-03-17 07:30:38.084+00
4242	2	14	{"lat":15.134586,"lng":120.5670933}	2021-03-17 07:30:57.26+00
4243	2	14	{"lat":15.134586,"lng":120.5670933}	2021-03-17 07:31:07.034+00
4244	2	14	{"lat":15.134586,"lng":120.5670933}	2021-03-17 07:31:12.032+00
4245	2	14	{"lat":15.134586,"lng":120.5670933}	2021-03-17 07:32:01.345+00
4246	2	14	{"lat":15.1556083,"lng":120.5553782}	2021-03-17 07:32:06.35+00
4247	2	14	{"lat":15.1556083,"lng":120.5553782}	2021-03-17 07:32:11.347+00
4248	2	14	{"lat":15.1556083,"lng":120.5553782}	2021-03-17 07:32:23.426+00
4249	2	14	{"lat":15.1556083,"lng":120.5553782}	2021-03-17 07:32:43.834+00
4250	2	14	{"lat":15.1556083,"lng":120.5553782}	2021-03-17 07:33:15.955+00
4251	2	14	{"lat":15.1556083,"lng":120.5553782}	2021-03-17 07:33:21.057+00
4252	2	14	{"lat":15.1556083,"lng":120.5553782}	2021-03-17 07:33:26.077+00
4253	2	14	{"lat":15.1556083,"lng":120.5553782}	2021-03-17 07:33:30.996+00
4254	2	14	{"lat":15.1556083,"lng":120.5553782}	2021-03-17 07:33:36.079+00
4255	2	14	{"lat":15.1556083,"lng":120.5553782}	2021-03-17 07:33:41.037+00
4256	2	14	{"lat":15.1556083,"lng":120.5553782}	2021-03-17 07:33:50.074+00
4257	2	14	{"lat":15.1556083,"lng":120.5553782}	2021-03-17 07:33:58.48+00
4258	2	14	{"lat":15.1626458,"lng":120.5565499}	2021-03-17 07:34:23.4+00
4259	2	14	{"lat":15.1625597,"lng":120.5564982}	2021-03-17 07:34:27.472+00
4260	2	14	{"lat":15.1625524,"lng":120.5565024}	2021-03-17 07:34:32.565+00
4261	2	14	{"lat":15.1625587,"lng":120.5565001}	2021-03-17 07:34:37.535+00
4262	2	14	{"lat":15.1625721,"lng":120.5565171}	2021-03-17 07:34:42.452+00
4263	2	14	{"lat":15.1625725,"lng":120.5565169}	2021-03-17 07:34:47.407+00
4264	2	14	{"lat":15.1625637,"lng":120.5565088}	2021-03-17 07:34:52.377+00
4265	2	14	{"lat":15.1625556,"lng":120.5565006}	2021-03-17 07:34:55.938+00
4266	2	14	{"lat":15.1625566,"lng":120.5564964}	2021-03-17 07:35:01.246+00
4267	2	14	{"lat":15.1625638,"lng":120.5564981}	2021-03-17 07:35:07.499+00
4268	2	14	{"lat":15.1625632,"lng":120.5564998}	2021-03-17 07:35:12.456+00
4269	2	14	{"lat":15.1625637,"lng":120.5565022}	2021-03-17 07:35:17.458+00
4270	2	14	{"lat":15.1625629,"lng":120.5565005}	2021-03-17 07:35:22.445+00
4271	2	14	{"lat":15.1625645,"lng":120.5565025}	2021-03-17 07:35:27.477+00
4272	2	\N	{"lat":"15.162563","lng":"120.556501"}	2021-03-17 07:35:33.882+00
5210	7	\N	{"lat":"15.1626729","lng":"120.5565601"}	2021-03-17 07:58:47.943+00
5211	4	35	{"lat":15.162685,"lng":120.5565565}	2021-03-17 07:30:30.704+00
5212	4	35	{"lat":15.1626804,"lng":120.5565606}	2021-03-17 07:30:35.516+00
5213	4	35	{"lat":15.1626767,"lng":120.5565605}	2021-03-17 07:30:40.694+00
5214	4	35	{"lat":15.1626776,"lng":120.5565592}	2021-03-17 07:30:45.156+00
5215	4	35	{"lat":15.1626805,"lng":120.556557}	2021-03-17 07:30:50.16+00
5216	4	35	{"lat":15.1626811,"lng":120.5565573}	2021-03-17 07:30:55.158+00
5217	4	35	{"lat":15.1626873,"lng":120.5565606}	2021-03-17 07:31:00.137+00
5218	4	35	{"lat":15.1626883,"lng":120.556561}	2021-03-17 07:31:05.133+00
5219	4	35	{"lat":15.1626909,"lng":120.5565627}	2021-03-17 07:31:10.156+00
5220	4	35	{"lat":15.1626911,"lng":120.5565628}	2021-03-17 07:31:15.147+00
4273	8	\N	{"lat":"15.1626726","lng":"120.5565632"}	2021-03-17 07:35:36.552+00
4274	3	\N	{"lat":"15.1641248","lng":"120.5907973"}	2021-03-17 07:35:53.609+00
4275	2	\N	{"lat":"15.1626058","lng":"120.5565281"}	2021-03-17 07:36:05.852+00
4276	3	\N	{"lat":"15.1642108","lng":"120.5907534"}	2021-03-17 07:36:24.787+00
4277	2	\N	{"lat":"15.1626731","lng":"120.5565666"}	2021-03-17 07:36:35.842+00
4278	3	\N	{"lat":"15.1650881","lng":"120.5904052"}	2021-03-17 07:36:56.755+00
4279	2	\N	{"lat":"15.1626731","lng":"120.5565666"}	2021-03-17 07:37:13.782+00
4280	3	\N	{"lat":"15.1649936","lng":"120.5895091"}	2021-03-17 07:37:25.28+00
4281	2	\N	{"lat":"15.162667","lng":"120.556565"}	2021-03-17 07:37:42.24+00
4282	3	\N	{"lat":"15.1650881","lng":"120.5904052"}	2021-03-17 07:37:55.238+00
4283	3	\N	{"lat":"15.1650881","lng":"120.5904052"}	2021-03-17 07:40:19.089+00
4284	3	\N	{"lat":"15.1650881","lng":"120.5904052"}	2021-03-17 07:41:04.966+00
4285	3	\N	{"lat":"15.1665466","lng":"120.583701"}	2021-03-17 07:41:14.433+00
4286	3	\N	{"lat":"15.1665466","lng":"120.583701"}	2021-03-17 07:41:45.011+00
4287	6	46	{"lat":15.1626834,"lng":120.5565579}	2021-03-17 07:30:42.147+00
4288	6	46	{"lat":15.1626417,"lng":120.5565567}	2021-03-17 07:30:48.86+00
4289	6	46	{"lat":15.1626417,"lng":120.5565567}	2021-03-17 07:30:50.325+00
4290	6	46	{"lat":15.16265,"lng":120.5564733}	2021-03-17 07:30:56.857+00
4291	6	46	{"lat":15.162685,"lng":120.5564551}	2021-03-17 07:31:01.912+00
4292	6	46	{"lat":15.162675,"lng":120.5564783}	2021-03-17 07:31:09.855+00
4293	6	46	{"lat":15.162675,"lng":120.5564783}	2021-03-17 07:31:10.353+00
4294	6	46	{"lat":15.162695,"lng":120.55646}	2021-03-17 07:31:19.919+00
4295	6	46	{"lat":15.162695,"lng":120.55646}	2021-03-17 07:31:20.301+00
4296	6	46	{"lat":15.1626517,"lng":120.5565283}	2021-03-17 07:31:37.268+00
4297	6	46	{"lat":15.1626711,"lng":120.5565399}	2021-03-17 07:31:57.457+00
4298	6	46	{"lat":15.1626783,"lng":120.5565608}	2021-03-17 07:32:07.399+00
4299	6	46	{"lat":15.1626949,"lng":120.5565566}	2021-03-17 07:32:22.497+00
4300	6	46	{"lat":15.1626896,"lng":120.5565532}	2021-03-17 07:32:32.582+00
4301	6	46	{"lat":15.1626896,"lng":120.5565532}	2021-03-17 07:32:35.365+00
4302	6	46	{"lat":15.1626797,"lng":120.5565532}	2021-03-17 07:32:40.37+00
4303	6	46	{"lat":15.1626797,"lng":120.5565532}	2021-03-17 07:33:04.067+00
4304	6	46	{"lat":15.1626797,"lng":120.5565532}	2021-03-17 07:33:18.317+00
4305	6	46	{"lat":15.1626797,"lng":120.5565532}	2021-03-17 07:34:05.645+00
4306	6	46	{"lat":15.1626797,"lng":120.5565532}	2021-03-17 07:34:29.097+00
4307	6	46	{"lat":15.1626797,"lng":120.5565532}	2021-03-17 07:34:42.983+00
4308	6	46	{"lat":15.1626797,"lng":120.5565532}	2021-03-17 07:34:54.603+00
4309	6	46	{"lat":15.1626797,"lng":120.5565532}	2021-03-17 07:35:31.74+00
4310	6	46	{"lat":15.1626797,"lng":120.5565532}	2021-03-17 07:35:38.971+00
4311	6	46	{"lat":15.1600247,"lng":120.5565803}	2021-03-17 07:36:06.394+00
4312	6	46	{"lat":15.1600342,"lng":120.5565738}	2021-03-17 07:36:11.895+00
4313	6	46	{"lat":15.1600342,"lng":120.5565738}	2021-03-17 07:36:13.375+00
4314	6	46	{"lat":15.1599356,"lng":120.5565204}	2021-03-17 07:36:38.869+00
4315	6	46	{"lat":15.1598583,"lng":120.55648}	2021-03-17 07:36:45.019+00
4316	6	46	{"lat":15.1599167,"lng":120.5559533}	2021-03-17 07:37:02.917+00
4317	6	46	{"lat":15.1599167,"lng":120.5559533}	2021-03-17 07:37:03.384+00
4318	6	46	{"lat":15.1599052,"lng":120.556178}	2021-03-17 07:37:24.522+00
4319	6	46	{"lat":15.1599265,"lng":120.5563467}	2021-03-17 07:37:29.983+00
4320	6	46	{"lat":15.1606301,"lng":120.5560454}	2021-03-17 07:37:51.321+00
4321	6	46	{"lat":15.1608194,"lng":120.5560115}	2021-03-17 07:38:09+00
4322	6	46	{"lat":15.161078,"lng":120.5559975}	2021-03-17 07:38:15.595+00
4323	6	46	{"lat":15.161105,"lng":120.555955}	2021-03-17 07:38:37.73+00
4324	6	46	{"lat":15.161105,"lng":120.555955}	2021-03-17 07:38:38.406+00
4325	6	46	{"lat":15.1617116,"lng":120.5562083}	2021-03-17 07:38:43.353+00
4326	6	46	{"lat":15.1618448,"lng":120.5562106}	2021-03-17 07:38:48.405+00
4327	6	46	{"lat":15.1619341,"lng":120.5560764}	2021-03-17 07:38:53.357+00
4328	6	46	{"lat":15.1621071,"lng":120.5559753}	2021-03-17 07:38:58.36+00
4329	6	46	{"lat":15.1622625,"lng":120.5558869}	2021-03-17 07:39:03.362+00
4330	6	46	{"lat":15.1623575,"lng":120.5559308}	2021-03-17 07:39:08.367+00
4331	6	46	{"lat":15.1623913,"lng":120.5560423}	2021-03-17 07:39:13.378+00
4332	6	46	{"lat":15.1624505,"lng":120.5561821}	2021-03-17 07:39:18.363+00
4333	6	46	{"lat":15.1625125,"lng":120.5563125}	2021-03-17 07:39:23.366+00
4334	6	46	{"lat":15.1625924,"lng":120.5564372}	2021-03-17 07:39:28.353+00
4335	6	46	{"lat":15.1626124,"lng":120.5565501}	2021-03-17 07:39:33.384+00
4336	6	46	{"lat":15.1625749,"lng":120.5565994}	2021-03-17 07:39:38.382+00
4337	6	46	{"lat":15.1625478,"lng":120.5566164}	2021-03-17 07:39:43.372+00
4338	6	46	{"lat":15.1625428,"lng":120.5566195}	2021-03-17 07:39:49.857+00
4339	6	46	{"lat":15.162535,"lng":120.5566183}	2021-03-17 07:39:55.016+00
4340	6	46	{"lat":15.1626717,"lng":120.55661}	2021-03-17 07:40:13.351+00
4341	6	46	{"lat":15.1626583,"lng":120.5565992}	2021-03-17 07:40:22.941+00
4342	6	46	{"lat":15.1626583,"lng":120.5565992}	2021-03-17 07:40:23.38+00
4343	6	46	{"lat":15.1626343,"lng":120.5565527}	2021-03-17 07:40:55.1+00
4344	6	46	{"lat":15.1626191,"lng":120.556531}	2021-03-17 07:41:00.211+00
4345	6	46	{"lat":15.1625538,"lng":120.5565094}	2021-03-17 07:41:05.352+00
4346	6	46	{"lat":15.1625588,"lng":120.5564943}	2021-03-17 07:41:10.365+00
4347	6	46	{"lat":15.1625505,"lng":120.5565015}	2021-03-17 07:41:30.354+00
4348	6	46	{"lat":15.1625578,"lng":120.5565037}	2021-03-17 07:41:35.438+00
4349	6	46	{"lat":15.1625598,"lng":120.5564945}	2021-03-17 07:41:55.438+00
4350	6	46	{"lat":15.162563,"lng":120.5564981}	2021-03-17 07:42:10.249+00
4351	6	46	{"lat":15.162563,"lng":120.5564981}	2021-03-17 07:42:11.411+00
4352	6	\N	{"lat":"15.162563","lng":"120.5564981"}	2021-03-17 07:42:12.819+00
4353	3	\N	{"lat":"15.1665466","lng":"120.583701"}	2021-03-17 07:42:14.898+00
4354	10	\N	{"lat":"15.1347024","lng":"120.5671737"}	2021-03-17 07:42:17.663+00
4355	3	\N	{"lat":"15.1658912","lng":"120.5762958"}	2021-03-17 07:42:45.655+00
4356	10	\N	{"lat":"15.1346963","lng":"120.5671393"}	2021-03-17 07:42:48.077+00
4357	3	\N	{"lat":"15.1658912","lng":"120.5762958"}	2021-03-17 07:43:14.969+00
4358	10	\N	{"lat":"15.1346869","lng":"120.5671387"}	2021-03-17 07:43:16.813+00
4359	10	\N	{"lat":"15.1346447","lng":"120.5670635"}	2021-03-17 07:43:49.485+00
4360	10	\N	{"lat":"15.1346613","lng":"120.5670858"}	2021-03-17 07:44:21.302+00
4361	10	\N	{"lat":"15.134669","lng":"120.5670997"}	2021-03-17 07:44:50.446+00
4362	8	52	{"lat":15.1626821,"lng":120.5565638}	2021-03-17 07:35:51.004+00
4363	8	52	{"lat":15.1626718,"lng":120.5565607}	2021-03-17 07:35:55.42+00
4364	8	52	{"lat":15.1626591,"lng":120.5565599}	2021-03-17 07:36:00.42+00
4365	8	52	{"lat":15.1626561,"lng":120.556565}	2021-03-17 07:36:05.409+00
4366	8	52	{"lat":15.1626615,"lng":120.5565637}	2021-03-17 07:36:10.428+00
4367	8	52	{"lat":15.16266,"lng":120.5565613}	2021-03-17 07:36:15.421+00
4368	8	52	{"lat":15.1626611,"lng":120.5565704}	2021-03-17 07:36:20.585+00
4369	8	52	{"lat":15.1626581,"lng":120.5565629}	2021-03-17 07:36:25.395+00
4370	8	52	{"lat":15.1626608,"lng":120.5565646}	2021-03-17 07:36:30.397+00
4371	8	52	{"lat":15.1626607,"lng":120.5565651}	2021-03-17 07:36:35.394+00
4372	8	52	{"lat":15.1626601,"lng":120.5565637}	2021-03-17 07:36:40.418+00
4373	8	52	{"lat":15.1626593,"lng":120.5565675}	2021-03-17 07:36:45.373+00
4374	8	52	{"lat":15.1626738,"lng":120.5565473}	2021-03-17 07:36:50.413+00
4375	8	52	{"lat":15.1626628,"lng":120.5565622}	2021-03-17 07:36:55.434+00
4376	8	52	{"lat":15.1626117,"lng":120.5565876}	2021-03-17 07:37:00.385+00
4377	8	52	{"lat":15.1626067,"lng":120.5565924}	2021-03-17 07:37:05.554+00
4378	8	52	{"lat":15.1626065,"lng":120.556598}	2021-03-17 07:37:10.452+00
4379	8	52	{"lat":15.1626,"lng":120.5566001}	2021-03-17 07:37:15.371+00
4380	8	52	{"lat":15.1626297,"lng":120.5565796}	2021-03-17 07:37:20.446+00
4381	8	52	{"lat":15.1626256,"lng":120.5565593}	2021-03-17 07:37:25.405+00
4382	8	52	{"lat":15.1625456,"lng":120.5563878}	2021-03-17 07:37:30.387+00
4383	8	52	{"lat":15.1624687,"lng":120.5561912}	2021-03-17 07:37:35.444+00
4384	8	52	{"lat":15.1623788,"lng":120.5560042}	2021-03-17 07:37:40.404+00
4385	8	52	{"lat":15.1623459,"lng":120.555983}	2021-03-17 07:37:45.051+00
4386	8	52	{"lat":15.1618405,"lng":120.5561311}	2021-03-17 07:37:50.446+00
4387	8	52	{"lat":15.1615642,"lng":120.5562867}	2021-03-17 07:37:55.413+00
4388	8	52	{"lat":15.1613694,"lng":120.5563967}	2021-03-17 07:38:00.479+00
4389	8	52	{"lat":15.1612949,"lng":120.5563543}	2021-03-17 07:38:05.452+00
4390	8	52	{"lat":15.161209,"lng":120.5561699}	2021-03-17 07:38:10.616+00
4391	8	52	{"lat":15.1611361,"lng":120.555947}	2021-03-17 07:38:15.537+00
4392	8	52	{"lat":15.1610906,"lng":120.5558434}	2021-03-17 07:38:20.446+00
4393	8	52	{"lat":15.1610894,"lng":120.5558393}	2021-03-17 07:38:24.936+00
4394	8	52	{"lat":15.1610719,"lng":120.5558398}	2021-03-17 07:38:30.445+00
4395	8	52	{"lat":15.1609608,"lng":120.5558559}	2021-03-17 07:38:35.513+00
4396	8	52	{"lat":15.1605443,"lng":120.5560604}	2021-03-17 07:38:40.581+00
4397	8	52	{"lat":15.1602277,"lng":120.5562169}	2021-03-17 07:38:45.408+00
4398	8	52	{"lat":15.1599936,"lng":120.5564149}	2021-03-17 07:38:50.421+00
4399	8	52	{"lat":15.1599255,"lng":120.5564673}	2021-03-17 07:38:55.481+00
4400	8	52	{"lat":15.1599411,"lng":120.5564868}	2021-03-17 07:39:00.446+00
4401	8	52	{"lat":15.1599444,"lng":120.5565004}	2021-03-17 07:39:05.534+00
4402	8	52	{"lat":15.1599447,"lng":120.5565011}	2021-03-17 07:39:10.453+00
4403	8	52	{"lat":15.1599447,"lng":120.5565011}	2021-03-17 07:39:15.078+00
4404	8	52	{"lat":15.1599866,"lng":120.5565086}	2021-03-17 07:39:20.403+00
4405	8	52	{"lat":15.1599892,"lng":120.5565084}	2021-03-17 07:39:25.55+00
4406	8	52	{"lat":15.1599894,"lng":120.5565082}	2021-03-17 07:39:30.451+00
4407	8	52	{"lat":15.1599873,"lng":120.5565099}	2021-03-17 07:39:35.369+00
4408	8	52	{"lat":15.1599883,"lng":120.5565107}	2021-03-17 07:39:40.393+00
4409	8	52	{"lat":15.1599933,"lng":120.5565088}	2021-03-17 07:39:45.384+00
4410	8	52	{"lat":15.1599953,"lng":120.5565073}	2021-03-17 07:39:50.375+00
4411	8	52	{"lat":15.1599868,"lng":120.5565023}	2021-03-17 07:39:55.385+00
4412	8	52	{"lat":15.1599735,"lng":120.5565086}	2021-03-17 07:40:00.385+00
4413	8	52	{"lat":15.1599685,"lng":120.5564723}	2021-03-17 07:40:05.358+00
4414	8	52	{"lat":15.160067,"lng":120.5563661}	2021-03-17 07:40:10.42+00
4415	8	52	{"lat":15.1602551,"lng":120.5562303}	2021-03-17 07:40:15.392+00
4416	8	52	{"lat":15.160521,"lng":120.5560878}	2021-03-17 07:40:20.308+00
4417	8	52	{"lat":15.160749,"lng":120.5559688}	2021-03-17 07:40:25.409+00
4418	8	52	{"lat":15.1611191,"lng":120.5557728}	2021-03-17 07:40:30.336+00
4419	8	52	{"lat":15.1615313,"lng":120.5555674}	2021-03-17 07:40:35.39+00
4420	8	52	{"lat":15.1619166,"lng":120.555355}	2021-03-17 07:40:40.45+00
4421	8	52	{"lat":15.1622255,"lng":120.5551917}	2021-03-17 07:40:45.406+00
4422	8	52	{"lat":15.1625079,"lng":120.5550594}	2021-03-17 07:40:50.359+00
4423	8	52	{"lat":15.1627321,"lng":120.5549402}	2021-03-17 07:40:55.44+00
4424	8	52	{"lat":15.1629489,"lng":120.5548273}	2021-03-17 07:41:00.393+00
4425	8	52	{"lat":15.1630967,"lng":120.5549415}	2021-03-17 07:41:05.401+00
4426	8	52	{"lat":15.1632797,"lng":120.5553029}	2021-03-17 07:41:10.437+00
4427	8	52	{"lat":15.1634481,"lng":120.5556392}	2021-03-17 07:41:15.386+00
4428	8	52	{"lat":15.1636981,"lng":120.5561228}	2021-03-17 07:41:20.386+00
4429	8	52	{"lat":15.163942,"lng":120.5565562}	2021-03-17 07:41:25.338+00
4430	8	52	{"lat":15.1640861,"lng":120.5568097}	2021-03-17 07:41:31.55+00
4431	8	52	{"lat":15.1642035,"lng":120.5570033}	2021-03-17 07:41:35.363+00
4432	8	52	{"lat":15.1643577,"lng":120.5573117}	2021-03-17 07:41:40.352+00
4433	8	52	{"lat":15.1645884,"lng":120.5577473}	2021-03-17 07:41:45.355+00
4434	8	52	{"lat":15.1648408,"lng":120.558249}	2021-03-17 07:41:50.329+00
4435	8	52	{"lat":15.1650872,"lng":120.5587686}	2021-03-17 07:41:55.389+00
4436	8	52	{"lat":15.1653809,"lng":120.5593704}	2021-03-17 07:42:00.357+00
4437	8	52	{"lat":15.1656574,"lng":120.5598746}	2021-03-17 07:42:05.335+00
4438	8	52	{"lat":15.1658915,"lng":120.5603675}	2021-03-17 07:42:10.551+00
4439	8	52	{"lat":15.1661308,"lng":120.5610239}	2021-03-17 07:42:15.361+00
4440	8	52	{"lat":15.1662683,"lng":120.5616835}	2021-03-17 07:42:20.341+00
4441	8	52	{"lat":15.1663394,"lng":120.5623716}	2021-03-17 07:42:25.372+00
4442	8	52	{"lat":15.1664116,"lng":120.5631035}	2021-03-17 07:42:30.398+00
4443	8	52	{"lat":15.1664387,"lng":120.5634187}	2021-03-17 07:42:35.548+00
4444	8	52	{"lat":15.1664727,"lng":120.5636227}	2021-03-17 07:42:40.44+00
4445	8	52	{"lat":15.1665576,"lng":120.5642393}	2021-03-17 07:42:45.374+00
4446	8	52	{"lat":15.1666198,"lng":120.564741}	2021-03-17 07:42:50.349+00
4447	8	52	{"lat":15.1667105,"lng":120.5648815}	2021-03-17 07:42:55.395+00
4448	8	52	{"lat":15.1668009,"lng":120.5648766}	2021-03-17 07:43:00.367+00
4449	8	52	{"lat":15.1669121,"lng":120.564979}	2021-03-17 07:43:05.449+00
4450	8	52	{"lat":15.1671557,"lng":120.5652678}	2021-03-17 07:43:10.413+00
4451	8	52	{"lat":15.1672422,"lng":120.5657998}	2021-03-17 07:43:15.38+00
4452	8	52	{"lat":15.1671876,"lng":120.5665312}	2021-03-17 07:43:20.361+00
4453	8	52	{"lat":15.1670513,"lng":120.5673684}	2021-03-17 07:43:25.411+00
4454	8	52	{"lat":15.1669159,"lng":120.5682793}	2021-03-17 07:43:30.366+00
4455	8	52	{"lat":15.1667681,"lng":120.5692601}	2021-03-17 07:43:35.4+00
4456	8	52	{"lat":15.1666139,"lng":120.5702626}	2021-03-17 07:43:40.377+00
4457	8	52	{"lat":15.1664744,"lng":120.5711768}	2021-03-17 07:43:45.369+00
4458	8	52	{"lat":15.1663323,"lng":120.5720376}	2021-03-17 07:43:50.382+00
4459	8	52	{"lat":15.1661878,"lng":120.57297}	2021-03-17 07:43:55.395+00
4460	8	52	{"lat":15.1660366,"lng":120.5739298}	2021-03-17 07:44:00.365+00
4461	8	52	{"lat":15.1658958,"lng":120.5748618}	2021-03-17 07:44:05.364+00
4462	8	52	{"lat":15.1657965,"lng":120.5755876}	2021-03-17 07:44:10.38+00
4463	8	52	{"lat":15.1657911,"lng":120.5761223}	2021-03-17 07:44:15.511+00
4464	8	52	{"lat":15.1658745,"lng":120.576641}	2021-03-17 07:44:20.347+00
4465	8	52	{"lat":15.165984,"lng":120.577268}	2021-03-17 07:44:25.404+00
4466	8	52	{"lat":15.1661349,"lng":120.5780651}	2021-03-17 07:44:30.359+00
4467	8	52	{"lat":15.1662931,"lng":120.5789163}	2021-03-17 07:44:35.329+00
4468	8	52	{"lat":15.1664405,"lng":120.5797489}	2021-03-17 07:44:40.361+00
4469	8	52	{"lat":15.1665761,"lng":120.5803936}	2021-03-17 07:44:45.378+00
4470	8	52	{"lat":15.1665954,"lng":120.580622}	2021-03-17 07:44:50.434+00
4471	8	52	{"lat":15.1665966,"lng":120.58064}	2021-03-17 07:44:55.392+00
4472	8	52	{"lat":15.166598,"lng":120.5806524}	2021-03-17 07:45:00.362+00
4473	8	52	{"lat":15.1665981,"lng":120.5806531}	2021-03-17 07:45:05.344+00
4474	8	52	{"lat":15.1666662,"lng":120.580611}	2021-03-17 07:45:10.426+00
4475	8	52	{"lat":15.1667077,"lng":120.5802979}	2021-03-17 07:45:15.375+00
4476	8	52	{"lat":15.1666498,"lng":120.5797277}	2021-03-17 07:45:20.461+00
4477	8	52	{"lat":15.1665565,"lng":120.5792178}	2021-03-17 07:45:25.381+00
4478	8	52	{"lat":15.1666328,"lng":120.5793949}	2021-03-17 07:45:30.531+00
4479	8	52	{"lat":15.1667548,"lng":120.5800173}	2021-03-17 07:45:35.364+00
4480	8	52	{"lat":15.1668925,"lng":120.5804004}	2021-03-17 07:45:40.515+00
4481	8	52	{"lat":15.166955,"lng":120.5803465}	2021-03-17 07:45:45.385+00
4482	8	52	{"lat":15.167001,"lng":120.5802986}	2021-03-17 07:45:50.357+00
4483	8	52	{"lat":15.1670054,"lng":120.5802778}	2021-03-17 07:45:56.21+00
4484	8	52	{"lat":15.1670062,"lng":120.5802642}	2021-03-17 07:46:00.954+00
4485	8	52	{"lat":15.1670062,"lng":120.5802642}	2021-03-17 07:46:01.186+00
4486	8	\N	{"lat":"15.1670062","lng":"120.5802642"}	2021-03-17 07:46:02.535+00
4487	8	\N	{"lat":"15.1674048","lng":"120.5800011"}	2021-03-17 07:46:34.371+00
4488	8	\N	{"lat":"15.1674219","lng":"120.5799882"}	2021-03-17 07:47:04.073+00
4489	8	\N	{"lat":"15.164849","lng":"120.5726761"}	2021-03-17 07:47:34.311+00
4490	5	19	{"lat":15.1673994,"lng":120.5799843}	2021-03-17 07:19:53.98+00
4491	5	19	{"lat":15.1674476,"lng":120.5799157}	2021-03-17 07:19:59.112+00
4492	5	19	{"lat":15.1674821,"lng":120.5798674}	2021-03-17 07:20:04.263+00
4493	5	19	{"lat":15.1675228,"lng":120.5798481}	2021-03-17 07:20:13.098+00
4494	5	19	{"lat":15.1675228,"lng":120.5798481}	2021-03-17 07:20:13.98+00
4495	5	19	{"lat":15.1675288,"lng":120.5798325}	2021-03-17 07:20:23.304+00
4496	5	19	{"lat":15.1675288,"lng":120.5798325}	2021-03-17 07:20:23.981+00
4497	5	19	{"lat":15.167505,"lng":120.5798603}	2021-03-17 07:20:33.091+00
4498	5	19	{"lat":15.167505,"lng":120.5798603}	2021-03-17 07:20:33.98+00
4499	5	19	{"lat":15.1674949,"lng":120.5798583}	2021-03-17 07:20:43.32+00
4500	5	19	{"lat":15.1674949,"lng":120.5798583}	2021-03-17 07:20:43.975+00
4501	5	19	{"lat":15.1674949,"lng":120.5798583}	2021-03-17 07:20:48.983+00
4502	5	19	{"lat":15.1674841,"lng":120.5798743}	2021-03-17 07:20:59.66+00
4503	5	19	{"lat":15.1674841,"lng":120.5798743}	2021-03-17 07:21:00.892+00
4504	5	19	{"lat":15.1674841,"lng":120.5798743}	2021-03-17 07:21:05.831+00
4505	5	19	{"lat":15.1674841,"lng":120.5798743}	2021-03-17 07:21:17.869+00
4506	5	19	{"lat":15.1674841,"lng":120.5798743}	2021-03-17 07:22:56.611+00
4507	5	19	{"lat":15.1674841,"lng":120.5798743}	2021-03-17 07:23:33.604+00
4508	5	19	{"lat":15.1674841,"lng":120.5798743}	2021-03-17 07:23:38.603+00
4509	5	19	{"lat":15.1674841,"lng":120.5798743}	2021-03-17 07:26:12.628+00
4510	5	19	{"lat":15.1674841,"lng":120.5798743}	2021-03-17 07:30:46.035+00
4511	5	19	{"lat":15.1674841,"lng":120.5798743}	2021-03-17 07:30:51.078+00
4512	5	19	{"lat":15.1674841,"lng":120.5798743}	2021-03-17 07:30:56.073+00
4513	5	19	{"lat":15.1533653,"lng":120.5597494}	2021-03-17 07:31:04.955+00
4514	5	19	{"lat":15.1533653,"lng":120.5597494}	2021-03-17 07:33:47.758+00
4515	5	19	{"lat":15.1533653,"lng":120.5597494}	2021-03-17 07:35:04.353+00
4516	5	19	{"lat":15.1346964,"lng":120.5671584}	2021-03-17 07:35:11.294+00
4517	5	19	{"lat":15.1346989,"lng":120.5671658}	2021-03-17 07:35:15.879+00
4518	5	19	{"lat":15.1346988,"lng":120.5671575}	2021-03-17 07:35:20.875+00
4519	5	19	{"lat":15.13469,"lng":120.5671424}	2021-03-17 07:35:25.934+00
4520	5	19	{"lat":15.134676,"lng":120.5671164}	2021-03-17 07:35:30.905+00
4521	5	19	{"lat":15.1346661,"lng":120.5671322}	2021-03-17 07:35:35.99+00
4522	5	19	{"lat":15.1346881,"lng":120.5671437}	2021-03-17 07:35:41.003+00
4523	5	19	{"lat":15.1347017,"lng":120.5671663}	2021-03-17 07:35:45.924+00
4524	5	19	{"lat":15.1347017,"lng":120.5671663}	2021-03-17 07:35:49.369+00
4525	5	19	{"lat":15.1347017,"lng":120.5671663}	2021-03-17 07:35:55.197+00
4526	5	19	{"lat":15.1347017,"lng":120.5671663}	2021-03-17 07:36:06.582+00
4527	5	19	{"lat":15.1347017,"lng":120.5671663}	2021-03-17 07:36:11.584+00
4528	5	19	{"lat":15.1347017,"lng":120.5671663}	2021-03-17 07:36:50.293+00
4529	5	19	{"lat":15.1347017,"lng":120.5671663}	2021-03-17 07:37:21.283+00
4530	5	19	{"lat":15.1347017,"lng":120.5671663}	2021-03-17 07:38:07.558+00
4531	5	19	{"lat":15.1347017,"lng":120.5671663}	2021-03-17 07:39:01.702+00
4532	5	19	{"lat":15.1347017,"lng":120.5671663}	2021-03-17 07:39:22.08+00
4533	5	19	{"lat":15.1347017,"lng":120.5671663}	2021-03-17 07:39:59.57+00
4534	5	19	{"lat":15.1347017,"lng":120.5671663}	2021-03-17 07:40:04.571+00
4535	5	19	{"lat":15.1347017,"lng":120.5671663}	2021-03-17 07:40:24.082+00
4536	5	19	{"lat":15.1347017,"lng":120.5671663}	2021-03-17 07:42:19.039+00
4537	5	19	{"lat":15.1347017,"lng":120.5671663}	2021-03-17 07:42:29.846+00
4538	5	19	{"lat":15.1347017,"lng":120.5671663}	2021-03-17 07:44:18.98+00
4539	5	19	{"lat":15.1347017,"lng":120.5671663}	2021-03-17 07:44:26.555+00
4540	5	19	{"lat":15.1347017,"lng":120.5671663}	2021-03-17 07:44:41.806+00
4541	5	19	{"lat":15.1347017,"lng":120.5671663}	2021-03-17 07:44:49.006+00
4542	5	19	{"lat":15.1347017,"lng":120.5671663}	2021-03-17 07:45:16.04+00
4543	5	19	{"lat":15.1347017,"lng":120.5671663}	2021-03-17 07:45:21.04+00
4544	5	19	{"lat":15.1347017,"lng":120.5671663}	2021-03-17 07:45:28.185+00
4545	5	19	{"lat":15.1347017,"lng":120.5671663}	2021-03-17 07:45:34.393+00
4546	5	19	{"lat":15.1659842,"lng":120.5816894}	2021-03-17 07:45:54.019+00
4547	5	19	{"lat":15.1659842,"lng":120.5816894}	2021-03-17 07:45:54.796+00
4548	5	19	{"lat":15.1659842,"lng":120.5816894}	2021-03-17 07:46:01.006+00
4549	5	19	{"lat":15.1659842,"lng":120.5816894}	2021-03-17 07:46:06.001+00
4550	5	19	{"lat":15.1659842,"lng":120.5816894}	2021-03-17 07:46:14.828+00
4551	5	19	{"lat":15.1659842,"lng":120.5816894}	2021-03-17 07:46:32.964+00
4552	5	19	{"lat":15.1659842,"lng":120.5816894}	2021-03-17 07:47:34.822+00
4553	5	19	{"lat":15.1659842,"lng":120.5816894}	2021-03-17 07:47:43.972+00
4554	5	19	{"lat":15.1659842,"lng":120.5816894}	2021-03-17 07:47:48.954+00
4555	5	19	{"lat":15.1673499,"lng":120.5799745}	2021-03-17 07:47:55.23+00
4556	5	19	{"lat":15.1673499,"lng":120.5799745}	2021-03-17 07:47:56.379+00
4557	5	\N	{"lat":"15.1673499","lng":"120.5799745"}	2021-03-17 07:47:56.865+00
4558	8	\N	{"lat":"15.1668641","lng":"120.5716969"}	2021-03-17 07:48:04.148+00
4559	8	\N	{"lat":"15.1668968","lng":"120.5716496"}	2021-03-17 07:48:34.273+00
4560	8	\N	{"lat":"15.1661405","lng":"120.5687751"}	2021-03-17 07:49:04.046+00
4561	5	\N	{"lat":"15.1673499","lng":"120.5799745"}	2021-03-17 07:49:07.942+00
4562	8	\N	{"lat":"15.1665909","lng":"120.5632843"}	2021-03-17 07:49:34.066+00
4563	8	\N	{"lat":"15.1653923","lng":"120.5593038"}	2021-03-17 07:50:04.368+00
4564	8	\N	{"lat":"15.1664987","lng":"120.5632392"}	2021-03-17 07:50:33.08+00
4565	8	\N	{"lat":"15.1664381","lng":"120.5631479"}	2021-03-17 07:51:04.066+00
4566	3	\N	{"lat":"15.1658912","lng":"120.5762958"}	2021-03-17 07:51:13.424+00
4567	3	\N	{"lat":"15.1658872","lng":"120.5741526"}	2021-03-17 07:51:19.656+00
4568	8	\N	{"lat":"15.1653137","lng":"120.5603238"}	2021-03-17 07:51:24.711+00
4569	8	\N	{"lat":"15.1655947","lng":"120.5595263"}	2021-03-17 07:51:28.922+00
4570	3	\N	{"lat":"15.1629509","lng":"120.5570733"}	2021-03-17 07:51:31.763+00
4571	8	\N	{"lat":"15.1636167","lng":"120.5560031"}	2021-03-17 07:52:01.904+00
4572	3	\N	{"lat":"15.1629503","lng":"120.5570667"}	2021-03-17 07:52:27.653+00
4573	8	\N	{"lat":"15.1629769","lng":"120.5551524"}	2021-03-17 07:52:33.076+00
4574	3	\N	{"lat":"15.1629503","lng":"120.5570667"}	2021-03-17 07:52:58+00
4575	8	\N	{"lat":"15.1630156","lng":"120.5551187"}	2021-03-17 07:53:45.52+00
4576	3	\N	{"lat":"15.162944","lng":"120.5570651"}	2021-03-17 07:55:19.556+00
4577	1	41	{"lat":15.1625642,"lng":120.5565}	2021-03-17 07:55:13.475+00
4578	1	41	{"lat":15.1625646,"lng":120.5564996}	2021-03-17 07:55:18.036+00
4579	1	\N	{"lat":"15.1625628","lng":"120.5564992"}	2021-03-17 07:55:25.446+00
4580	9	28	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:34:55.232+00
4581	9	28	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:35:00.261+00
4582	9	28	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:35:05.34+00
4583	9	28	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:35:10.337+00
4584	9	28	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:35:15.329+00
4585	9	28	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:35:20.281+00
4586	9	28	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:35:25.314+00
4587	9	28	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:35:30.331+00
4588	9	28	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:35:35.246+00
4589	9	28	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:35:40.264+00
4590	9	28	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:35:45.288+00
4591	9	28	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:35:50.294+00
4592	9	28	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:35:55.295+00
4593	9	28	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:36:00.272+00
4594	9	28	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:36:05.275+00
4595	9	28	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:36:10.327+00
4596	9	28	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:36:15.291+00
4597	9	28	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:36:20.319+00
4598	9	28	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:36:25.288+00
4599	9	28	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:36:30.283+00
4600	9	28	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:36:35.28+00
4601	9	28	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:36:40.304+00
4602	9	28	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:36:45.331+00
4603	9	28	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:36:50.339+00
4604	9	28	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:36:55.276+00
4605	9	28	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:37:00.248+00
4606	9	28	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:37:05.315+00
4607	9	28	{"lat":15.1626714,"lng":120.5565598}	2021-03-17 07:37:10.271+00
4608	9	28	{"lat":15.1627166,"lng":120.556518}	2021-03-17 07:37:16.258+00
4609	9	28	{"lat":15.1627163,"lng":120.5565179}	2021-03-17 07:37:21.268+00
4610	9	28	{"lat":15.1627125,"lng":120.5565173}	2021-03-17 07:37:26.183+00
4611	9	28	{"lat":15.1627122,"lng":120.5565171}	2021-03-17 07:37:30.533+00
4612	9	28	{"lat":15.1627734,"lng":120.5566527}	2021-03-17 07:37:36.183+00
4613	9	28	{"lat":15.1629419,"lng":120.5570101}	2021-03-17 07:37:41.174+00
4614	9	28	{"lat":15.162973,"lng":120.5571578}	2021-03-17 07:37:46.214+00
4615	9	28	{"lat":15.1629705,"lng":120.5571521}	2021-03-17 07:37:50.294+00
4616	9	28	{"lat":15.1624724,"lng":120.5573758}	2021-03-17 07:37:56.162+00
4617	9	28	{"lat":15.1624294,"lng":120.5573945}	2021-03-17 07:38:00.499+00
4618	9	28	{"lat":15.1620447,"lng":120.5575697}	2021-03-17 07:38:06.257+00
4619	9	28	{"lat":15.1619299,"lng":120.5576217}	2021-03-17 07:38:11.198+00
4620	9	28	{"lat":15.1616491,"lng":120.5577343}	2021-03-17 07:38:16.231+00
4621	9	28	{"lat":15.1612795,"lng":120.5578562}	2021-03-17 07:38:21.232+00
4622	9	28	{"lat":15.1609387,"lng":120.5579817}	2021-03-17 07:38:26.165+00
4623	9	28	{"lat":15.1605134,"lng":120.5581041}	2021-03-17 07:38:31.193+00
4624	9	28	{"lat":15.1600307,"lng":120.5582347}	2021-03-17 07:38:36.204+00
4625	9	28	{"lat":15.1596406,"lng":120.5583766}	2021-03-17 07:38:41.179+00
4626	9	28	{"lat":15.1596034,"lng":120.5583904}	2021-03-17 07:38:45.272+00
4627	9	28	{"lat":15.1592609,"lng":120.5585081}	2021-03-17 07:38:50.35+00
4628	9	28	{"lat":15.1592609,"lng":120.5585081}	2021-03-17 07:38:56.208+00
4629	9	28	{"lat":15.1592609,"lng":120.5585081}	2021-03-17 07:39:27.392+00
4630	9	28	{"lat":15.1592609,"lng":120.5585081}	2021-03-17 07:39:41.567+00
4631	9	28	{"lat":15.1592609,"lng":120.5585081}	2021-03-17 07:40:13.322+00
4632	9	28	{"lat":15.1592609,"lng":120.5585081}	2021-03-17 07:40:43.568+00
4633	9	28	{"lat":15.1592609,"lng":120.5585081}	2021-03-17 07:41:45.963+00
4634	9	28	{"lat":15.1592609,"lng":120.5585081}	2021-03-17 07:42:26.266+00
4635	9	28	{"lat":15.1592609,"lng":120.5585081}	2021-03-17 07:44:21.221+00
4636	9	28	{"lat":15.1592609,"lng":120.5585081}	2021-03-17 07:44:36.853+00
4637	9	28	{"lat":15.1358916,"lng":120.5676632}	2021-03-17 07:44:45.483+00
4638	9	28	{"lat":15.1347156,"lng":120.5672206}	2021-03-17 07:44:46.845+00
4639	9	28	{"lat":15.1346923,"lng":120.5672235}	2021-03-17 07:44:52.469+00
4640	9	28	{"lat":15.1347073,"lng":120.5672254}	2021-03-17 07:44:57.45+00
4641	9	28	{"lat":15.1347306,"lng":120.5672043}	2021-03-17 07:45:02.281+00
4642	9	28	{"lat":15.1347247,"lng":120.5671829}	2021-03-17 07:45:06.841+00
4643	9	28	{"lat":15.1346503,"lng":120.5671462}	2021-03-17 07:45:13.129+00
4644	9	28	{"lat":15.1345821,"lng":120.5670977}	2021-03-17 07:45:18.185+00
4645	9	28	{"lat":15.1345252,"lng":120.5670563}	2021-03-17 07:45:23.172+00
4646	9	28	{"lat":15.1344684,"lng":120.5670125}	2021-03-17 07:45:28.179+00
4647	9	28	{"lat":15.1344684,"lng":120.5670125}	2021-03-17 07:45:31.858+00
4648	9	28	{"lat":15.1344684,"lng":120.5670125}	2021-03-17 07:45:36.897+00
4649	9	28	{"lat":15.1345525,"lng":120.5670531}	2021-03-17 07:45:43.13+00
4650	9	28	{"lat":15.1345852,"lng":120.5670787}	2021-03-17 07:45:48.14+00
4651	9	28	{"lat":15.1345949,"lng":120.5670891}	2021-03-17 07:45:53.213+00
4652	9	28	{"lat":15.1345938,"lng":120.5670975}	2021-03-17 07:45:58.153+00
4653	9	28	{"lat":15.1345984,"lng":120.5671066}	2021-03-17 07:46:03.125+00
4654	9	28	{"lat":15.1346027,"lng":120.5671116}	2021-03-17 07:46:08.136+00
4655	9	28	{"lat":15.1346057,"lng":120.5671142}	2021-03-17 07:46:13.133+00
4656	9	28	{"lat":15.1346085,"lng":120.5671168}	2021-03-17 07:46:18.141+00
4657	9	28	{"lat":15.1346102,"lng":120.567118}	2021-03-17 07:46:23.135+00
4658	9	28	{"lat":15.1346213,"lng":120.5671264}	2021-03-17 07:46:28.134+00
4659	9	28	{"lat":15.1346355,"lng":120.5671114}	2021-03-17 07:46:33.123+00
4660	9	28	{"lat":15.1346647,"lng":120.5670552}	2021-03-17 07:46:38.131+00
4661	9	28	{"lat":15.134668,"lng":120.5670458}	2021-03-17 07:46:43.116+00
4662	9	28	{"lat":15.1346692,"lng":120.5670452}	2021-03-17 07:46:48.162+00
4663	9	28	{"lat":15.1346698,"lng":120.5670424}	2021-03-17 07:46:53.149+00
4664	9	28	{"lat":15.1346917,"lng":120.5670128}	2021-03-17 07:46:58.172+00
4665	9	28	{"lat":15.1348508,"lng":120.5668498}	2021-03-17 07:47:03.168+00
4666	9	28	{"lat":15.135195,"lng":120.5665104}	2021-03-17 07:47:08.153+00
4667	9	28	{"lat":15.1352,"lng":120.566506}	2021-03-17 07:47:11.823+00
4668	9	28	{"lat":15.1354395,"lng":120.5662598}	2021-03-17 07:47:16.87+00
4669	9	28	{"lat":15.1354395,"lng":120.5662598}	2021-03-17 07:47:35.573+00
4670	9	28	{"lat":15.1354395,"lng":120.5662598}	2021-03-17 07:48:35.126+00
4671	9	28	{"lat":15.1354395,"lng":120.5662598}	2021-03-17 07:50:10.292+00
4672	9	28	{"lat":15.1354395,"lng":120.5662598}	2021-03-17 07:50:38.79+00
4673	9	28	{"lat":15.1354395,"lng":120.5662598}	2021-03-17 07:50:44.746+00
4674	9	28	{"lat":15.1354395,"lng":120.5662598}	2021-03-17 07:51:06.598+00
4675	9	28	{"lat":15.1354395,"lng":120.5662598}	2021-03-17 07:51:11.743+00
4676	9	28	{"lat":15.1354395,"lng":120.5662598}	2021-03-17 07:54:11.292+00
4677	9	28	{"lat":15.1354395,"lng":120.5662598}	2021-03-17 07:54:14.254+00
4678	9	28	{"lat":15.1354395,"lng":120.5662598}	2021-03-17 07:54:19.238+00
4679	9	28	{"lat":15.1626728,"lng":120.5565652}	2021-03-17 07:54:24.367+00
4680	9	28	{"lat":15.1626708,"lng":120.5565635}	2021-03-17 07:54:30.716+00
4681	9	28	{"lat":15.1626692,"lng":120.5565605}	2021-03-17 07:54:35.331+00
4682	9	28	{"lat":15.1626654,"lng":120.5565612}	2021-03-17 07:54:40.439+00
4683	9	28	{"lat":15.1626363,"lng":120.5565433}	2021-03-17 07:54:45.385+00
4684	9	28	{"lat":15.1625872,"lng":120.5565168}	2021-03-17 07:54:50.421+00
4685	9	28	{"lat":15.1625545,"lng":120.5565104}	2021-03-17 07:54:55.338+00
4686	9	28	{"lat":15.1625533,"lng":120.5565038}	2021-03-17 07:55:00.361+00
4687	9	28	{"lat":15.1625588,"lng":120.5565063}	2021-03-17 07:55:05.494+00
4688	9	28	{"lat":15.162558,"lng":120.556498}	2021-03-17 07:55:10.502+00
4689	9	28	{"lat":15.1625514,"lng":120.5564979}	2021-03-17 07:55:15.541+00
4690	9	28	{"lat":15.1625625,"lng":120.5565022}	2021-03-17 07:55:20.342+00
4691	9	28	{"lat":15.1625592,"lng":120.5564963}	2021-03-17 07:55:25.463+00
4692	9	28	{"lat":15.162557,"lng":120.5564936}	2021-03-17 07:55:30.434+00
4693	9	\N	{"lat":"15.1625607","lng":"120.5564935"}	2021-03-17 07:55:36.511+00
4694	7	40	{"lat":15.1641998,"lng":120.5907619}	2021-03-17 07:30:25.059+00
4695	7	40	{"lat":15.1641524,"lng":120.5907697}	2021-03-17 07:30:30.223+00
4696	7	40	{"lat":15.1639506,"lng":120.5907885}	2021-03-17 07:30:35.13+00
4697	7	40	{"lat":15.1639218,"lng":120.5907966}	2021-03-17 07:30:38.569+00
4698	7	40	{"lat":15.1645169,"lng":120.5905175}	2021-03-17 07:30:45.003+00
4699	7	40	{"lat":15.1647155,"lng":120.5905519}	2021-03-17 07:30:50.194+00
4700	7	40	{"lat":15.1648663,"lng":120.5904755}	2021-03-17 07:30:55.248+00
4701	7	40	{"lat":15.1648932,"lng":120.5904729}	2021-03-17 07:31:00.066+00
4702	7	40	{"lat":15.1650179,"lng":120.5904151}	2021-03-17 07:31:05.038+00
4703	7	40	{"lat":15.1650458,"lng":120.5903676}	2021-03-17 07:31:10.02+00
4704	7	40	{"lat":15.1648898,"lng":120.5903827}	2021-03-17 07:31:15.268+00
4705	7	40	{"lat":15.1648389,"lng":120.5904077}	2021-03-17 07:31:20.093+00
4706	7	40	{"lat":15.1647813,"lng":120.5904407}	2021-03-17 07:31:23.379+00
4707	7	40	{"lat":15.1640236,"lng":120.5906894}	2021-03-17 07:31:30.019+00
4708	7	40	{"lat":15.1630938,"lng":120.5909689}	2021-03-17 07:31:35.041+00
4709	7	40	{"lat":15.1627084,"lng":120.590982}	2021-03-17 07:31:40.257+00
4710	7	40	{"lat":15.1625201,"lng":120.5909479}	2021-03-17 07:31:45.064+00
4711	7	40	{"lat":15.1624383,"lng":120.5909849}	2021-03-17 07:31:50.075+00
4712	7	40	{"lat":15.1624095,"lng":120.5910132}	2021-03-17 07:31:55.053+00
4713	7	40	{"lat":15.1622432,"lng":120.5911056}	2021-03-17 07:32:00.123+00
4714	7	40	{"lat":15.1622139,"lng":120.5911296}	2021-03-17 07:32:05.134+00
4715	7	40	{"lat":15.1617652,"lng":120.5912404}	2021-03-17 07:32:08.164+00
4716	7	40	{"lat":15.1611038,"lng":120.591377}	2021-03-17 07:32:15.272+00
4717	7	40	{"lat":15.1606385,"lng":120.5914738}	2021-03-17 07:32:20.242+00
4718	7	40	{"lat":15.160341,"lng":120.5915655}	2021-03-17 07:32:25.248+00
4719	7	40	{"lat":15.1601624,"lng":120.5916349}	2021-03-17 07:32:30.263+00
4720	7	40	{"lat":15.1600676,"lng":120.5916507}	2021-03-17 07:32:35.228+00
4721	7	40	{"lat":15.1599475,"lng":120.5916702}	2021-03-17 07:32:38.236+00
4722	7	40	{"lat":15.1595658,"lng":120.5917854}	2021-03-17 07:32:45.233+00
4723	7	40	{"lat":15.1593151,"lng":120.5918602}	2021-03-17 07:32:50.228+00
4724	7	40	{"lat":15.1590364,"lng":120.5919024}	2021-03-17 07:32:55.27+00
4725	7	40	{"lat":15.1588967,"lng":120.5919353}	2021-03-17 07:32:58.276+00
4726	7	40	{"lat":15.1589997,"lng":120.5918903}	2021-03-17 07:33:04.765+00
4727	7	40	{"lat":15.1589997,"lng":120.5918903}	2021-03-17 07:33:08.282+00
4728	7	40	{"lat":15.1581063,"lng":120.5921643}	2021-03-17 07:33:15.263+00
4729	7	40	{"lat":15.1577268,"lng":120.592219}	2021-03-17 07:33:20.241+00
4730	7	40	{"lat":15.1572879,"lng":120.59221}	2021-03-17 07:33:25.237+00
4731	7	40	{"lat":15.15704,"lng":120.5922081}	2021-03-17 07:33:30.263+00
4732	7	40	{"lat":15.1569924,"lng":120.5921975}	2021-03-17 07:33:35.256+00
4733	7	40	{"lat":15.1568892,"lng":120.5921802}	2021-03-17 07:33:38.264+00
4734	7	40	{"lat":15.1564986,"lng":120.5922097}	2021-03-17 07:33:45.27+00
4735	7	40	{"lat":15.1563499,"lng":120.592202}	2021-03-17 07:33:50.254+00
4736	7	40	{"lat":15.1559287,"lng":120.5921758}	2021-03-17 07:33:55.242+00
4737	7	40	{"lat":15.1555876,"lng":120.5921672}	2021-03-17 07:34:00.244+00
4738	7	40	{"lat":15.1551767,"lng":120.5921386}	2021-03-17 07:34:05.228+00
4739	7	40	{"lat":15.1546859,"lng":120.5920993}	2021-03-17 07:34:10.25+00
4740	7	40	{"lat":15.154331,"lng":120.5920789}	2021-03-17 07:34:15.249+00
4741	7	40	{"lat":15.1540824,"lng":120.5920349}	2021-03-17 07:34:20.249+00
4742	7	40	{"lat":15.1538425,"lng":120.5920013}	2021-03-17 07:34:25.234+00
4743	7	40	{"lat":15.1535939,"lng":120.5919927}	2021-03-17 07:34:30.265+00
4744	7	40	{"lat":15.1535299,"lng":120.5919885}	2021-03-17 07:34:35.223+00
4745	7	40	{"lat":15.1532926,"lng":120.5919478}	2021-03-17 07:34:40.237+00
4746	7	40	{"lat":15.1529553,"lng":120.5917432}	2021-03-17 07:34:45.248+00
4747	7	40	{"lat":15.1528005,"lng":120.5913874}	2021-03-17 07:34:50.253+00
4748	7	40	{"lat":15.1526705,"lng":120.591076}	2021-03-17 07:34:55.224+00
4749	7	40	{"lat":15.1525287,"lng":120.590722}	2021-03-17 07:35:00.246+00
4750	7	40	{"lat":15.1524163,"lng":120.5904413}	2021-03-17 07:35:05.239+00
4751	7	40	{"lat":15.1523124,"lng":120.5902154}	2021-03-17 07:35:10.22+00
4752	7	40	{"lat":15.1521957,"lng":120.589999}	2021-03-17 07:35:15.271+00
4753	7	40	{"lat":15.1520876,"lng":120.5897748}	2021-03-17 07:35:20.249+00
4754	7	40	{"lat":15.151992,"lng":120.5895439}	2021-03-17 07:35:25.223+00
4755	7	40	{"lat":15.1518948,"lng":120.5893071}	2021-03-17 07:35:30.251+00
4756	7	40	{"lat":15.1517736,"lng":120.5890504}	2021-03-17 07:35:35.238+00
4757	7	40	{"lat":15.151624,"lng":120.5887352}	2021-03-17 07:35:40.249+00
4758	7	40	{"lat":15.151451,"lng":120.588317}	2021-03-17 07:35:45.248+00
4759	7	40	{"lat":15.1513173,"lng":120.5879836}	2021-03-17 07:35:50.223+00
4760	7	40	{"lat":15.1512241,"lng":120.5877402}	2021-03-17 07:35:55.243+00
4761	7	40	{"lat":15.1511445,"lng":120.5875587}	2021-03-17 07:36:00.267+00
4762	7	40	{"lat":15.1511351,"lng":120.5875653}	2021-03-17 07:36:05.029+00
4763	7	40	{"lat":15.1510265,"lng":120.5872584}	2021-03-17 07:36:10.253+00
4764	7	40	{"lat":15.1510128,"lng":120.5872133}	2021-03-17 07:36:15.13+00
4765	7	40	{"lat":15.1509473,"lng":120.5870255}	2021-03-17 07:36:18.187+00
4766	7	40	{"lat":15.1507697,"lng":120.5865183}	2021-03-17 07:36:25.043+00
4767	7	40	{"lat":15.1506514,"lng":120.5862098}	2021-03-17 07:36:30.122+00
4768	7	40	{"lat":15.1506448,"lng":120.5861734}	2021-03-17 07:36:33.661+00
4769	7	40	{"lat":15.1505441,"lng":120.5858231}	2021-03-17 07:36:40.128+00
4770	7	40	{"lat":15.1505094,"lng":120.5858072}	2021-03-17 07:36:43.146+00
4771	7	40	{"lat":15.1504966,"lng":120.585777}	2021-03-17 07:36:49.993+00
4772	7	40	{"lat":15.1504582,"lng":120.585671}	2021-03-17 07:36:55.196+00
4773	7	40	{"lat":15.1504339,"lng":120.5856072}	2021-03-17 07:37:00.09+00
4774	7	40	{"lat":15.1504133,"lng":120.5855518}	2021-03-17 07:37:05.061+00
4775	7	40	{"lat":15.1503416,"lng":120.5853413}	2021-03-17 07:37:10.05+00
4776	7	40	{"lat":15.1501841,"lng":120.584871}	2021-03-17 07:37:15.05+00
4777	7	40	{"lat":15.1501841,"lng":120.584871}	2021-03-17 07:37:23.121+00
4778	7	40	{"lat":15.1501841,"lng":120.584871}	2021-03-17 07:37:28.133+00
4779	7	40	{"lat":15.1501841,"lng":120.584871}	2021-03-17 07:37:40.453+00
4780	7	40	{"lat":15.1480842,"lng":120.5740842}	2021-03-17 07:43:59.782+00
4781	7	40	{"lat":15.1345864,"lng":120.5670825}	2021-03-17 07:44:05.235+00
4782	7	40	{"lat":15.134643,"lng":120.5670969}	2021-03-17 07:44:09.93+00
4783	7	40	{"lat":15.1346486,"lng":120.5671002}	2021-03-17 07:44:15.196+00
4784	7	40	{"lat":15.1344865,"lng":120.5670928}	2021-03-17 07:44:20.232+00
4785	7	40	{"lat":15.1344876,"lng":120.5671111}	2021-03-17 07:44:24.235+00
4786	7	40	{"lat":15.1344999,"lng":120.5671301}	2021-03-17 07:44:29.98+00
4787	7	40	{"lat":15.1346919,"lng":120.5672075}	2021-03-17 07:44:34.246+00
4788	7	40	{"lat":15.1347187,"lng":120.5672203}	2021-03-17 07:44:38.437+00
4789	7	40	{"lat":15.1346757,"lng":120.5671496}	2021-03-17 07:44:45.054+00
4790	7	40	{"lat":15.1346194,"lng":120.5670768}	2021-03-17 07:44:50.005+00
4791	7	40	{"lat":15.1347531,"lng":120.5671775}	2021-03-17 07:44:55.248+00
4792	7	40	{"lat":15.1347561,"lng":120.5671803}	2021-03-17 07:45:00.18+00
4793	7	40	{"lat":15.134742,"lng":120.5671802}	2021-03-17 07:45:03.133+00
4794	7	40	{"lat":15.1346785,"lng":120.5671217}	2021-03-17 07:45:10.022+00
4795	7	40	{"lat":15.1347244,"lng":120.5671726}	2021-03-17 07:45:15.243+00
4796	7	40	{"lat":15.1347371,"lng":120.5671872}	2021-03-17 07:45:19.987+00
4797	7	40	{"lat":15.1347233,"lng":120.5671724}	2021-03-17 07:45:24.237+00
4798	7	40	{"lat":15.1347208,"lng":120.5671702}	2021-03-17 07:45:30.015+00
4799	7	40	{"lat":15.1346632,"lng":120.5671076}	2021-03-17 07:45:34.97+00
4800	7	40	{"lat":15.1346613,"lng":120.5671076}	2021-03-17 07:45:39.474+00
4801	7	40	{"lat":15.1346776,"lng":120.5671149}	2021-03-17 07:45:45.188+00
4802	7	40	{"lat":15.1347182,"lng":120.5671613}	2021-03-17 07:45:48.125+00
4803	7	40	{"lat":15.134722,"lng":120.5671656}	2021-03-17 07:45:55.25+00
4804	7	40	{"lat":15.1347211,"lng":120.5671646}	2021-03-17 07:45:59.986+00
4805	7	40	{"lat":15.1346757,"lng":120.5671259}	2021-03-17 07:46:05.137+00
4806	7	40	{"lat":15.1347132,"lng":120.5671578}	2021-03-17 07:46:10.219+00
4807	7	40	{"lat":15.1347151,"lng":120.5671576}	2021-03-17 07:46:14.224+00
4808	7	40	{"lat":15.1347166,"lng":120.5671581}	2021-03-17 07:46:19.243+00
4809	7	40	{"lat":15.1347176,"lng":120.5671584}	2021-03-17 07:46:24.979+00
4810	7	40	{"lat":15.1347157,"lng":120.5671572}	2021-03-17 07:46:30.235+00
4811	7	40	{"lat":15.1347153,"lng":120.5671568}	2021-03-17 07:46:35.085+00
4812	7	40	{"lat":15.1347152,"lng":120.5671568}	2021-03-17 07:46:38.373+00
4813	7	40	{"lat":15.1347156,"lng":120.5671563}	2021-03-17 07:46:44.24+00
4814	7	40	{"lat":15.1347156,"lng":120.5671563}	2021-03-17 07:46:50.175+00
4815	7	40	{"lat":15.1347122,"lng":120.5671527}	2021-03-17 07:46:53.129+00
4816	7	40	{"lat":15.134709,"lng":120.5671485}	2021-03-17 07:47:00.038+00
4817	7	40	{"lat":15.1346408,"lng":120.5670306}	2021-03-17 07:47:04.956+00
4818	7	40	{"lat":15.1348567,"lng":120.5669063}	2021-03-17 07:47:10.23+00
4819	7	40	{"lat":15.135106,"lng":120.5665896}	2021-03-17 07:47:15.224+00
4820	7	40	{"lat":15.1353783,"lng":120.5663383}	2021-03-17 07:47:19.215+00
4821	7	40	{"lat":15.1357864,"lng":120.5659058}	2021-03-17 07:47:25.247+00
4822	7	40	{"lat":15.1361306,"lng":120.5655703}	2021-03-17 07:47:30.219+00
4823	7	40	{"lat":15.136423,"lng":120.5652813}	2021-03-17 07:47:34.231+00
4824	7	40	{"lat":15.1368816,"lng":120.564836}	2021-03-17 07:47:40.183+00
4825	7	40	{"lat":15.1372817,"lng":120.5644014}	2021-03-17 07:47:45.255+00
4826	7	40	{"lat":15.1377264,"lng":120.5640001}	2021-03-17 07:47:50.238+00
4827	7	40	{"lat":15.1381354,"lng":120.5635985}	2021-03-17 07:47:55.242+00
4828	7	40	{"lat":15.1384726,"lng":120.563249}	2021-03-17 07:47:59.241+00
4829	7	40	{"lat":15.1389958,"lng":120.5627164}	2021-03-17 07:48:05.216+00
4830	7	40	{"lat":15.1393649,"lng":120.5624209}	2021-03-17 07:48:09.237+00
4831	7	40	{"lat":15.1400042,"lng":120.5620557}	2021-03-17 07:48:15.213+00
4832	7	40	{"lat":15.1405452,"lng":120.5617518}	2021-03-17 07:48:20.246+00
4833	7	40	{"lat":15.1409825,"lng":120.5614922}	2021-03-17 07:48:24.23+00
4834	7	40	{"lat":15.1416831,"lng":120.5610816}	2021-03-17 07:48:30.258+00
4835	7	40	{"lat":15.1420991,"lng":120.5608042}	2021-03-17 07:48:34.247+00
4836	7	40	{"lat":15.1426848,"lng":120.560405}	2021-03-17 07:48:40.246+00
4837	7	40	{"lat":15.14302,"lng":120.5601614}	2021-03-17 07:48:44.21+00
4838	7	40	{"lat":15.1433808,"lng":120.559875}	2021-03-17 07:48:49.23+00
4839	7	40	{"lat":15.143731,"lng":120.5595916}	2021-03-17 07:48:55.244+00
4840	7	40	{"lat":15.1438508,"lng":120.5595118}	2021-03-17 07:48:59.256+00
4841	7	40	{"lat":15.1438414,"lng":120.5595219}	2021-03-17 07:49:05.07+00
4842	7	40	{"lat":15.1440008,"lng":120.5595033}	2021-03-17 07:49:09.264+00
4843	7	40	{"lat":15.1440533,"lng":120.5595091}	2021-03-17 07:49:14.25+00
4844	7	40	{"lat":15.1443846,"lng":120.5595186}	2021-03-17 07:49:20.258+00
4845	7	40	{"lat":15.1444452,"lng":120.5595537}	2021-03-17 07:49:24.971+00
4846	7	40	{"lat":15.1445027,"lng":120.5598078}	2021-03-17 07:49:30.269+00
4847	7	40	{"lat":15.1445199,"lng":120.5597652}	2021-03-17 07:49:35.215+00
4848	7	40	{"lat":15.1446778,"lng":120.5594912}	2021-03-17 07:49:39.262+00
4849	7	40	{"lat":15.144823,"lng":120.5594733}	2021-03-17 07:49:44.245+00
4850	7	40	{"lat":15.1455451,"lng":120.5594184}	2021-03-17 07:49:50.248+00
4851	7	40	{"lat":15.1462588,"lng":120.5594305}	2021-03-17 07:49:55.212+00
4852	7	40	{"lat":15.1470616,"lng":120.5594014}	2021-03-17 07:50:00.25+00
4853	7	40	{"lat":15.1475221,"lng":120.5593913}	2021-03-17 07:50:05.243+00
4854	7	40	{"lat":15.1479336,"lng":120.5593582}	2021-03-17 07:50:10.25+00
4855	7	40	{"lat":15.1485212,"lng":120.5593663}	2021-03-17 07:50:15.241+00
4856	7	40	{"lat":15.1491821,"lng":120.5593633}	2021-03-17 07:50:20.255+00
4857	7	40	{"lat":15.1498677,"lng":120.5593705}	2021-03-17 07:50:25.23+00
4858	7	40	{"lat":15.1504024,"lng":120.5593914}	2021-03-17 07:50:29.243+00
4859	7	40	{"lat":15.1509646,"lng":120.5593832}	2021-03-17 07:50:34.247+00
4860	7	40	{"lat":15.1516455,"lng":120.5593717}	2021-03-17 07:50:40.199+00
4861	7	40	{"lat":15.1521326,"lng":120.5594677}	2021-03-17 07:50:44.221+00
4862	7	40	{"lat":15.1526677,"lng":120.5596345}	2021-03-17 07:50:49.228+00
4863	7	40	{"lat":15.1531142,"lng":120.5599684}	2021-03-17 07:50:54.23+00
4864	7	40	{"lat":15.1536045,"lng":120.5602816}	2021-03-17 07:50:59.238+00
4865	7	40	{"lat":15.1540247,"lng":120.5603466}	2021-03-17 07:51:05.234+00
4866	7	40	{"lat":15.1542724,"lng":120.560291}	2021-03-17 07:51:09.243+00
4867	7	40	{"lat":15.1546998,"lng":120.5602897}	2021-03-17 07:51:15.213+00
4868	7	40	{"lat":15.155088,"lng":120.5602678}	2021-03-17 07:51:20.226+00
4869	7	40	{"lat":15.1555538,"lng":120.5602273}	2021-03-17 07:51:25.234+00
4870	7	40	{"lat":15.1560913,"lng":120.5601466}	2021-03-17 07:51:30.242+00
4871	7	40	{"lat":15.156387,"lng":120.5600834}	2021-03-17 07:51:35.249+00
4872	7	40	{"lat":15.1564266,"lng":120.5600837}	2021-03-17 07:51:39.229+00
4873	7	40	{"lat":15.1566426,"lng":120.5600538}	2021-03-17 07:51:45.256+00
4874	7	40	{"lat":15.1571694,"lng":120.5599454}	2021-03-17 07:51:50.243+00
4875	7	40	{"lat":15.1576394,"lng":120.5598551}	2021-03-17 07:51:54.229+00
4876	7	40	{"lat":15.1580518,"lng":120.5596558}	2021-03-17 07:52:00.244+00
4877	7	40	{"lat":15.1582,"lng":120.5593713}	2021-03-17 07:52:05.244+00
4878	7	40	{"lat":15.1582867,"lng":120.5590133}	2021-03-17 07:52:10.212+00
4879	7	40	{"lat":15.1584023,"lng":120.5587264}	2021-03-17 07:52:15.259+00
4880	7	40	{"lat":15.1584871,"lng":120.5586994}	2021-03-17 07:52:19.252+00
4881	7	40	{"lat":15.1589707,"lng":120.5586045}	2021-03-17 07:52:25.258+00
4882	7	40	{"lat":15.1593824,"lng":120.5584748}	2021-03-17 07:52:30.251+00
4883	7	40	{"lat":15.1597438,"lng":120.5583328}	2021-03-17 07:52:35.237+00
4884	7	40	{"lat":15.1600303,"lng":120.5582247}	2021-03-17 07:52:40.227+00
4885	7	40	{"lat":15.1602511,"lng":120.558128}	2021-03-17 07:52:44.238+00
4886	7	40	{"lat":15.1605746,"lng":120.5580161}	2021-03-17 07:52:50.248+00
4887	7	40	{"lat":15.1609207,"lng":120.55794}	2021-03-17 07:52:55.248+00
4888	7	40	{"lat":15.1612286,"lng":120.5578122}	2021-03-17 07:52:59.245+00
4889	7	40	{"lat":15.1616751,"lng":120.5576821}	2021-03-17 07:53:05.228+00
4890	7	40	{"lat":15.1619214,"lng":120.5576529}	2021-03-17 07:53:09.247+00
4891	7	40	{"lat":15.1619712,"lng":120.5576359}	2021-03-17 07:53:14.242+00
4892	7	40	{"lat":15.1621002,"lng":120.5575418}	2021-03-17 07:53:20.192+00
4893	7	40	{"lat":15.162444,"lng":120.5573193}	2021-03-17 07:53:25.262+00
4894	7	40	{"lat":15.162444,"lng":120.5573193}	2021-03-17 07:53:33.077+00
4895	7	40	{"lat":15.162444,"lng":120.5573193}	2021-03-17 07:53:38.056+00
4896	7	40	{"lat":15.1628805,"lng":120.5569746}	2021-03-17 07:53:45.263+00
4897	7	40	{"lat":15.16287,"lng":120.5569572}	2021-03-17 07:53:50.027+00
4898	7	40	{"lat":15.1627334,"lng":120.556652}	2021-03-17 07:53:55.236+00
4899	7	40	{"lat":15.1627324,"lng":120.5566034}	2021-03-17 07:53:59.248+00
4900	7	40	{"lat":15.1627116,"lng":120.5565955}	2021-03-17 07:54:05.237+00
4901	7	40	{"lat":15.1626641,"lng":120.5565963}	2021-03-17 07:54:10.231+00
4902	7	40	{"lat":15.1626583,"lng":120.5566003}	2021-03-17 07:54:15.217+00
4903	7	40	{"lat":15.1626574,"lng":120.5566039}	2021-03-17 07:54:20.211+00
4904	7	40	{"lat":15.162658,"lng":120.5566024}	2021-03-17 07:54:25.248+00
4905	7	40	{"lat":15.162658,"lng":120.5566023}	2021-03-17 07:54:30.863+00
4906	7	40	{"lat":15.162658,"lng":120.5566023}	2021-03-17 07:54:38.053+00
4907	7	40	{"lat":15.162658,"lng":120.5566023}	2021-03-17 07:54:43.08+00
4908	7	40	{"lat":15.162658,"lng":120.5566023}	2021-03-17 07:54:58.034+00
4909	7	40	{"lat":15.162658,"lng":120.5566023}	2021-03-17 07:55:17.725+00
4910	7	40	{"lat":15.1625668,"lng":120.5565057}	2021-03-17 07:55:22.689+00
4911	7	40	{"lat":15.1625668,"lng":120.5565057}	2021-03-17 07:55:32.063+00
4912	7	40	{"lat":15.1625505,"lng":120.5565061}	2021-03-17 07:55:42.245+00
4913	7	\N	{"lat":"15.1625608","lng":"120.5564994"}	2021-03-17 07:55:51.45+00
4914	7	\N	{"lat":"15.1625622","lng":"120.5565008"}	2021-03-17 07:55:56.14+00
4915	7	\N	{"lat":"15.1625622","lng":"120.5565008"}	2021-03-17 07:55:57.584+00
4916	1	\N	{"lat":"15.1625662","lng":"120.5565028"}	2021-03-17 07:55:58.124+00
4917	1	\N	{"lat":"15.1625569","lng":"120.5565046"}	2021-03-17 07:56:03.911+00
4918	3	\N	{"lat":"15.162944","lng":"120.5570651"}	2021-03-17 07:56:05.936+00
4919	9	\N	{"lat":"15.1625581","lng":"120.5565009"}	2021-03-17 07:56:09.258+00
4920	7	\N	{"lat":"15.1625587","lng":"120.5565075"}	2021-03-17 07:56:11.607+00
4921	7	\N	{"lat":"15.1626395","lng":"120.5565494"}	2021-03-17 07:56:33.256+00
4922	1	\N	{"lat":"15.1626719","lng":"120.5565601"}	2021-03-17 07:57:06.008+00
4923	10	\N	{"lat":"15.1670408","lng":"120.5802662"}	2021-03-17 07:57:22.545+00
4924	10	21	{"lat":15.1625613,"lng":120.5565024}	2021-03-17 07:24:36.815+00
4925	10	21	{"lat":15.1625718,"lng":120.5565003}	2021-03-17 07:24:41.722+00
4926	10	21	{"lat":15.1625542,"lng":120.5565014}	2021-03-17 07:24:47.046+00
4927	10	21	{"lat":15.1625595,"lng":120.5565038}	2021-03-17 07:24:51.769+00
4928	10	21	{"lat":15.1625584,"lng":120.5565006}	2021-03-17 07:24:56.707+00
4929	10	21	{"lat":15.1625576,"lng":120.5565092}	2021-03-17 07:25:01.744+00
4930	10	21	{"lat":15.1625577,"lng":120.5565101}	2021-03-17 07:25:06.841+00
4931	10	21	{"lat":15.1625604,"lng":120.556503}	2021-03-17 07:25:10.828+00
4932	10	21	{"lat":15.1625902,"lng":120.556525}	2021-03-17 07:25:16.718+00
4933	10	21	{"lat":15.1626451,"lng":120.5565512}	2021-03-17 07:25:21.736+00
4934	10	21	{"lat":15.1626451,"lng":120.5565512}	2021-03-17 07:25:25.742+00
4935	10	21	{"lat":15.1626451,"lng":120.5565512}	2021-03-17 07:25:30.745+00
4936	10	21	{"lat":15.1626451,"lng":120.5565512}	2021-03-17 07:25:35.739+00
4937	10	21	{"lat":15.1626451,"lng":120.5565512}	2021-03-17 07:25:40.745+00
4938	10	21	{"lat":15.1626451,"lng":120.5565512}	2021-03-17 07:25:45.749+00
4939	10	21	{"lat":15.1626451,"lng":120.5565512}	2021-03-17 07:25:50.819+00
4940	10	21	{"lat":15.1626723,"lng":120.556561}	2021-03-17 07:25:56.99+00
4941	10	21	{"lat":15.1626723,"lng":120.556561}	2021-03-17 07:26:00.72+00
4942	10	21	{"lat":15.1626723,"lng":120.556561}	2021-03-17 07:26:05.746+00
4943	10	21	{"lat":15.1626723,"lng":120.556561}	2021-03-17 07:26:10.706+00
4944	10	21	{"lat":15.1626723,"lng":120.556561}	2021-03-17 07:26:15.709+00
4945	10	21	{"lat":15.1626723,"lng":120.556561}	2021-03-17 07:26:20.705+00
4946	10	21	{"lat":15.1626723,"lng":120.556561}	2021-03-17 07:26:25.697+00
4947	10	21	{"lat":15.1626723,"lng":120.556561}	2021-03-17 07:26:30.711+00
4948	10	21	{"lat":15.162674,"lng":120.5565608}	2021-03-17 07:26:36.985+00
4949	10	21	{"lat":15.1626674,"lng":120.5565621}	2021-03-17 07:26:40.71+00
4950	10	21	{"lat":15.1626675,"lng":120.5565606}	2021-03-17 07:26:46.733+00
4951	10	21	{"lat":15.1626675,"lng":120.5565606}	2021-03-17 07:26:51.01+00
4952	10	21	{"lat":15.1626675,"lng":120.5565606}	2021-03-17 07:26:56.014+00
4953	10	21	{"lat":15.1626675,"lng":120.5565606}	2021-03-17 07:27:01.012+00
4954	10	21	{"lat":15.1626675,"lng":120.5565606}	2021-03-17 07:27:06.092+00
4955	10	21	{"lat":15.1626675,"lng":120.5565606}	2021-03-17 07:27:11.013+00
4956	10	21	{"lat":15.1626675,"lng":120.5565606}	2021-03-17 07:27:16.014+00
4957	10	21	{"lat":15.1626675,"lng":120.5565606}	2021-03-17 07:27:21.014+00
4958	10	21	{"lat":15.1626675,"lng":120.5565606}	2021-03-17 07:27:26.015+00
4959	10	21	{"lat":15.1626675,"lng":120.5565606}	2021-03-17 07:27:31.012+00
4960	10	21	{"lat":15.1626675,"lng":120.5565606}	2021-03-17 07:27:36.012+00
4961	10	21	{"lat":15.1626675,"lng":120.5565606}	2021-03-17 07:27:41.014+00
4962	10	21	{"lat":15.1626675,"lng":120.5565606}	2021-03-17 07:27:46.018+00
4963	10	21	{"lat":15.1626675,"lng":120.5565606}	2021-03-17 07:27:51.013+00
4964	10	21	{"lat":15.1626675,"lng":120.5565606}	2021-03-17 07:27:56.012+00
4965	10	21	{"lat":15.1626675,"lng":120.5565606}	2021-03-17 07:28:07.956+00
4966	10	21	{"lat":15.1626675,"lng":120.5565606}	2021-03-17 07:28:37.746+00
4967	10	21	{"lat":15.1626675,"lng":120.5565606}	2021-03-17 07:29:01.49+00
4968	10	21	{"lat":15.1626675,"lng":120.5565606}	2021-03-17 07:29:06.497+00
4969	10	21	{"lat":15.1626718,"lng":120.5565586}	2021-03-17 07:29:20.202+00
4970	10	21	{"lat":15.1626724,"lng":120.5565672}	2021-03-17 07:29:26.134+00
4971	10	21	{"lat":15.1626737,"lng":120.5565683}	2021-03-17 07:29:31.089+00
4972	10	21	{"lat":15.1626777,"lng":120.5565617}	2021-03-17 07:29:36.094+00
4973	10	21	{"lat":15.1626724,"lng":120.5565604}	2021-03-17 07:29:40.057+00
4974	10	21	{"lat":15.1626751,"lng":120.5565662}	2021-03-17 07:29:46.348+00
4975	10	21	{"lat":15.1626751,"lng":120.5565654}	2021-03-17 07:29:51.079+00
4976	10	21	{"lat":15.1626751,"lng":120.5565654}	2021-03-17 07:29:55.102+00
4977	10	21	{"lat":15.1626751,"lng":120.5565654}	2021-03-17 07:30:00.09+00
4978	10	21	{"lat":15.1626743,"lng":120.5565656}	2021-03-17 07:30:05.251+00
4979	10	21	{"lat":15.1626704,"lng":120.5565618}	2021-03-17 07:30:10.068+00
4980	10	21	{"lat":15.1626805,"lng":120.5565591}	2021-03-17 07:30:16.387+00
4981	10	21	{"lat":15.1626801,"lng":120.5565604}	2021-03-17 07:30:21.093+00
4982	10	21	{"lat":15.1626797,"lng":120.5565672}	2021-03-17 07:30:26.108+00
4983	10	21	{"lat":15.1626771,"lng":120.5565637}	2021-03-17 07:30:31.053+00
4984	10	21	{"lat":15.1626738,"lng":120.5565587}	2021-03-17 07:30:36.218+00
4985	10	21	{"lat":15.162679,"lng":120.556563}	2021-03-17 07:30:40.134+00
4986	10	21	{"lat":15.162679,"lng":120.556563}	2021-03-17 07:30:45.121+00
4987	10	21	{"lat":15.162679,"lng":120.556563}	2021-03-17 07:30:53.084+00
4988	10	21	{"lat":15.162679,"lng":120.556563}	2021-03-17 07:31:26.324+00
4989	10	21	{"lat":15.1626755,"lng":120.5565603}	2021-03-17 07:31:37.319+00
4990	10	21	{"lat":15.1626775,"lng":120.5565579}	2021-03-17 07:31:42.773+00
4991	10	21	{"lat":15.1626717,"lng":120.5565553}	2021-03-17 07:31:46.61+00
4992	10	21	{"lat":15.1626727,"lng":120.556555}	2021-03-17 07:31:52.407+00
4993	10	21	{"lat":15.1626808,"lng":120.5565629}	2021-03-17 07:31:57.468+00
4994	10	21	{"lat":15.162675,"lng":120.5565589}	2021-03-17 07:32:02.52+00
4995	10	21	{"lat":15.162675,"lng":120.5565589}	2021-03-17 07:32:06.42+00
4996	10	21	{"lat":15.162675,"lng":120.5565589}	2021-03-17 07:32:11.398+00
4997	10	21	{"lat":15.162675,"lng":120.5565589}	2021-03-17 07:33:00.984+00
4998	10	21	{"lat":15.162675,"lng":120.5565589}	2021-03-17 07:33:33.497+00
4999	10	21	{"lat":15.162675,"lng":120.5565589}	2021-03-17 07:33:38.538+00
5000	10	21	{"lat":15.162675,"lng":120.5565589}	2021-03-17 07:33:43.536+00
5001	10	21	{"lat":15.162675,"lng":120.5565589}	2021-03-17 07:33:48.534+00
5002	10	21	{"lat":15.162675,"lng":120.5565589}	2021-03-17 07:33:53.531+00
5003	10	21	{"lat":15.162675,"lng":120.5565589}	2021-03-17 07:33:58.531+00
5004	10	21	{"lat":15.1626755,"lng":120.5565646}	2021-03-17 07:34:04.244+00
5005	10	21	{"lat":15.1626755,"lng":120.5565646}	2021-03-17 07:34:09.214+00
5006	10	21	{"lat":15.1629348,"lng":120.5567801}	2021-03-17 07:34:15.194+00
5007	10	21	{"lat":15.1628504,"lng":120.5570607}	2021-03-17 07:34:20.959+00
5008	10	21	{"lat":15.1625231,"lng":120.5573765}	2021-03-17 07:34:29.134+00
5009	10	21	{"lat":15.1625231,"lng":120.5573765}	2021-03-17 07:34:34.123+00
5010	10	21	{"lat":15.1625231,"lng":120.5573765}	2021-03-17 07:34:39.132+00
5011	10	21	{"lat":15.1625231,"lng":120.5573765}	2021-03-17 07:35:05.027+00
5012	10	21	{"lat":15.1625231,"lng":120.5573765}	2021-03-17 07:35:10.029+00
5013	10	21	{"lat":15.1625231,"lng":120.5573765}	2021-03-17 07:35:15.023+00
5014	10	21	{"lat":15.1625231,"lng":120.5573765}	2021-03-17 07:35:36.613+00
5015	10	21	{"lat":15.1625114,"lng":120.5573883}	2021-03-17 07:36:22.471+00
5016	10	21	{"lat":15.1579609,"lng":120.553462}	2021-03-17 07:36:27.483+00
5017	10	21	{"lat":15.1556292,"lng":120.5599524}	2021-03-17 07:36:33.732+00
5018	10	21	{"lat":15.1550831,"lng":120.5602139}	2021-03-17 07:36:38.885+00
5019	10	21	{"lat":15.154639,"lng":120.5603884}	2021-03-17 07:36:43.739+00
5020	10	21	{"lat":15.1542059,"lng":120.5603363}	2021-03-17 07:36:47.384+00
5021	10	21	{"lat":15.1542059,"lng":120.5603363}	2021-03-17 07:36:52.386+00
5022	10	21	{"lat":15.1542059,"lng":120.5603363}	2021-03-17 07:39:00.11+00
5023	10	21	{"lat":15.1542059,"lng":120.5603363}	2021-03-17 07:39:05.328+00
5024	10	21	{"lat":15.1542059,"lng":120.5603363}	2021-03-17 07:39:10.609+00
5025	10	21	{"lat":15.1542059,"lng":120.5603363}	2021-03-17 07:41:01.136+00
5026	10	21	{"lat":15.1542059,"lng":120.5603363}	2021-03-17 07:41:06.199+00
5027	10	21	{"lat":15.1542059,"lng":120.5603363}	2021-03-17 07:41:11.133+00
5028	10	21	{"lat":15.1542059,"lng":120.5603363}	2021-03-17 07:41:38.323+00
5029	10	21	{"lat":15.1542059,"lng":120.5603363}	2021-03-17 07:42:02.174+00
5030	10	21	{"lat":15.1368111,"lng":120.5658646}	2021-03-17 07:42:07.51+00
5031	10	21	{"lat":15.1346963,"lng":120.5671393}	2021-03-17 07:42:48.771+00
5032	10	21	{"lat":15.1346696,"lng":120.5671265}	2021-03-17 07:42:54.81+00
5033	10	21	{"lat":15.1346931,"lng":120.5671658}	2021-03-17 07:43:00.185+00
5034	10	21	{"lat":15.1346856,"lng":120.5671473}	2021-03-17 07:43:04.739+00
5035	10	21	{"lat":15.1346907,"lng":120.5671524}	2021-03-17 07:43:09.753+00
5036	10	21	{"lat":15.1346869,"lng":120.5671387}	2021-03-17 07:43:14.755+00
5037	10	21	{"lat":15.1346901,"lng":120.567157}	2021-03-17 07:43:19.959+00
5038	10	21	{"lat":15.1346885,"lng":120.5671629}	2021-03-17 07:43:24.846+00
5039	10	21	{"lat":15.1346934,"lng":120.5671531}	2021-03-17 07:43:29.767+00
5040	10	21	{"lat":15.1347058,"lng":120.5671615}	2021-03-17 07:43:34.77+00
5041	10	21	{"lat":15.1346825,"lng":120.5671107}	2021-03-17 07:43:39.782+00
5042	10	21	{"lat":15.1346447,"lng":120.5670635}	2021-03-17 07:43:45.051+00
5043	10	21	{"lat":15.1346447,"lng":120.5670635}	2021-03-17 07:43:53.797+00
5044	10	21	{"lat":15.1346447,"lng":120.5670635}	2021-03-17 07:44:01.77+00
5045	10	21	{"lat":15.1346532,"lng":120.5670743}	2021-03-17 07:44:07.938+00
5046	10	21	{"lat":15.1346577,"lng":120.5670633}	2021-03-17 07:44:12.749+00
5047	10	21	{"lat":15.1346613,"lng":120.5670858}	2021-03-17 07:44:18.311+00
5048	10	21	{"lat":15.1346613,"lng":120.5670858}	2021-03-17 07:44:22.778+00
5049	10	21	{"lat":15.1346713,"lng":120.5671033}	2021-03-17 07:44:27.775+00
5050	10	21	{"lat":15.1346686,"lng":120.5671002}	2021-03-17 07:44:32.75+00
5051	10	21	{"lat":15.134669,"lng":120.5670997}	2021-03-17 07:44:37.755+00
5052	10	21	{"lat":15.134669,"lng":120.5670997}	2021-03-17 07:44:42.746+00
5053	10	21	{"lat":15.134669,"lng":120.5670997}	2021-03-17 07:44:47.76+00
5054	10	21	{"lat":15.134669,"lng":120.5670997}	2021-03-17 07:44:52.742+00
5055	10	21	{"lat":15.1346959,"lng":120.5670626}	2021-03-17 07:44:57.762+00
5056	10	21	{"lat":15.134726,"lng":120.567024}	2021-03-17 07:45:02.803+00
5057	10	21	{"lat":15.134726,"lng":120.567024}	2021-03-17 07:45:07.753+00
5058	10	21	{"lat":15.134726,"lng":120.567024}	2021-03-17 07:45:12.745+00
5059	10	21	{"lat":15.134726,"lng":120.567024}	2021-03-17 07:45:17.748+00
5060	10	21	{"lat":15.134726,"lng":120.567024}	2021-03-17 07:45:22.742+00
5061	10	21	{"lat":15.1366784,"lng":120.5650446}	2021-03-17 07:45:27.741+00
5062	10	21	{"lat":15.1366784,"lng":120.5650446}	2021-03-17 07:45:32.743+00
5063	10	21	{"lat":15.1366784,"lng":120.5650446}	2021-03-17 07:45:37.829+00
5064	10	21	{"lat":15.1366784,"lng":120.5650446}	2021-03-17 07:45:42.797+00
5065	10	21	{"lat":15.1366784,"lng":120.5650446}	2021-03-17 07:45:47.807+00
5066	10	21	{"lat":15.1366784,"lng":120.5650446}	2021-03-17 07:45:52.775+00
5067	10	21	{"lat":15.1366784,"lng":120.5650446}	2021-03-17 07:45:57.777+00
5068	10	21	{"lat":15.1366784,"lng":120.5650446}	2021-03-17 07:46:02.798+00
5069	10	21	{"lat":15.1366784,"lng":120.5650446}	2021-03-17 07:46:07.809+00
5070	10	21	{"lat":15.1366784,"lng":120.5650446}	2021-03-17 07:46:12.778+00
5071	10	21	{"lat":15.1412755,"lng":120.5613122}	2021-03-17 07:46:17.777+00
5072	10	21	{"lat":15.1412755,"lng":120.5613122}	2021-03-17 07:46:22.789+00
5073	10	21	{"lat":15.1423296,"lng":120.5606593}	2021-03-17 07:46:27.781+00
5074	10	21	{"lat":15.1423296,"lng":120.5606593}	2021-03-17 07:46:32.786+00
5075	10	21	{"lat":15.1423296,"lng":120.5606593}	2021-03-17 07:46:37.78+00
5076	10	21	{"lat":15.1423296,"lng":120.5606593}	2021-03-17 07:46:42.791+00
5077	10	21	{"lat":15.1423296,"lng":120.5606593}	2021-03-17 07:46:47.783+00
5078	10	21	{"lat":15.1423296,"lng":120.5606593}	2021-03-17 07:46:52.763+00
5079	10	21	{"lat":15.1423296,"lng":120.5606593}	2021-03-17 07:46:57.746+00
5080	10	21	{"lat":15.1423296,"lng":120.5606593}	2021-03-17 07:47:02.789+00
5081	10	21	{"lat":15.1423296,"lng":120.5606593}	2021-03-17 07:47:07.781+00
5082	10	21	{"lat":15.1423296,"lng":120.5606593}	2021-03-17 07:47:12.812+00
5083	10	21	{"lat":15.1452355,"lng":120.5594365}	2021-03-17 07:47:17.79+00
5084	10	21	{"lat":15.1452355,"lng":120.5594365}	2021-03-17 07:47:22.778+00
5085	10	21	{"lat":15.1462128,"lng":120.5594266}	2021-03-17 07:47:27.77+00
5086	10	21	{"lat":15.1462128,"lng":120.5594266}	2021-03-17 07:47:32.778+00
5087	10	21	{"lat":15.1462128,"lng":120.5594266}	2021-03-17 07:47:37.78+00
5088	10	21	{"lat":15.1462128,"lng":120.5594266}	2021-03-17 07:47:42.767+00
5089	10	21	{"lat":15.1462128,"lng":120.5594266}	2021-03-17 07:47:47.749+00
5090	10	21	{"lat":15.1462128,"lng":120.5594266}	2021-03-17 07:47:52.749+00
5091	10	21	{"lat":15.1462128,"lng":120.5594266}	2021-03-17 07:47:57.747+00
5092	10	21	{"lat":15.1462128,"lng":120.5594266}	2021-03-17 07:48:02.766+00
5093	10	21	{"lat":15.1462128,"lng":120.5594266}	2021-03-17 07:48:07.754+00
5094	10	21	{"lat":15.1462128,"lng":120.5594266}	2021-03-17 07:48:12.761+00
5095	10	21	{"lat":15.150734,"lng":120.5594395}	2021-03-17 07:48:17.776+00
5096	10	21	{"lat":15.150734,"lng":120.5594395}	2021-03-17 07:48:22.762+00
5097	10	21	{"lat":15.1519644,"lng":120.5594572}	2021-03-17 07:48:27.768+00
5098	10	21	{"lat":15.1519644,"lng":120.5594572}	2021-03-17 07:48:32.749+00
5099	10	21	{"lat":15.1519644,"lng":120.5594572}	2021-03-17 07:48:37.751+00
5100	10	21	{"lat":15.1519644,"lng":120.5594572}	2021-03-17 07:48:42.769+00
5101	10	21	{"lat":15.1519644,"lng":120.5594572}	2021-03-17 07:48:47.753+00
5102	10	21	{"lat":15.1519644,"lng":120.5594572}	2021-03-17 07:48:52.752+00
5103	10	21	{"lat":15.1519644,"lng":120.5594572}	2021-03-17 07:48:57.747+00
5104	10	21	{"lat":15.1519644,"lng":120.5594572}	2021-03-17 07:49:02.745+00
5105	10	21	{"lat":15.1519644,"lng":120.5594572}	2021-03-17 07:49:07.748+00
5106	10	21	{"lat":15.1519644,"lng":120.5594572}	2021-03-17 07:49:12.747+00
5107	10	21	{"lat":15.1570701,"lng":120.5599626}	2021-03-17 07:49:17.765+00
5108	10	21	{"lat":15.1570701,"lng":120.5599626}	2021-03-17 07:49:22.743+00
5109	10	21	{"lat":15.1580895,"lng":120.5595865}	2021-03-17 07:49:27.747+00
5110	10	21	{"lat":15.1580895,"lng":120.5595865}	2021-03-17 07:49:32.738+00
5111	10	21	{"lat":15.1580895,"lng":120.5595865}	2021-03-17 07:49:37.741+00
5112	10	21	{"lat":15.1580895,"lng":120.5595865}	2021-03-17 07:49:42.754+00
5113	10	21	{"lat":15.1580895,"lng":120.5595865}	2021-03-17 07:49:47.744+00
5114	10	21	{"lat":15.1580895,"lng":120.5595865}	2021-03-17 07:49:52.75+00
5115	10	21	{"lat":15.1580895,"lng":120.5595865}	2021-03-17 07:49:57.741+00
5116	10	21	{"lat":15.1580895,"lng":120.5595865}	2021-03-17 07:50:02.742+00
5117	10	21	{"lat":15.1580895,"lng":120.5595865}	2021-03-17 07:50:07.748+00
5118	10	21	{"lat":15.1580895,"lng":120.5595865}	2021-03-17 07:50:12.742+00
5119	10	21	{"lat":15.1612706,"lng":120.5578548}	2021-03-17 07:50:17.754+00
5120	10	21	{"lat":15.1612706,"lng":120.5578548}	2021-03-17 07:50:22.738+00
5121	10	21	{"lat":15.1619719,"lng":120.5575889}	2021-03-17 07:50:27.745+00
5122	10	21	{"lat":15.1619719,"lng":120.5575889}	2021-03-17 07:50:32.811+00
5123	10	21	{"lat":15.1619719,"lng":120.5575889}	2021-03-17 07:50:37.784+00
5124	10	21	{"lat":15.1619719,"lng":120.5575889}	2021-03-17 07:50:42.787+00
5125	10	21	{"lat":15.1619719,"lng":120.5575889}	2021-03-17 07:50:47.861+00
5126	10	21	{"lat":15.1619719,"lng":120.5575889}	2021-03-17 07:50:52.785+00
5127	10	21	{"lat":15.1619719,"lng":120.5575889}	2021-03-17 07:50:57.757+00
5128	10	21	{"lat":15.1619719,"lng":120.5575889}	2021-03-17 07:51:02.803+00
5129	10	21	{"lat":15.1619719,"lng":120.5575889}	2021-03-17 07:51:07.822+00
5130	10	21	{"lat":15.1619719,"lng":120.5575889}	2021-03-17 07:51:12.751+00
5131	10	21	{"lat":15.1643565,"lng":120.5573351}	2021-03-17 07:51:17.835+00
5132	10	21	{"lat":15.1643565,"lng":120.5573351}	2021-03-17 07:51:22.776+00
5133	10	21	{"lat":15.1647737,"lng":120.5581626}	2021-03-17 07:51:27.78+00
5134	10	21	{"lat":15.1647737,"lng":120.5581626}	2021-03-17 07:51:32.787+00
5135	10	21	{"lat":15.1647737,"lng":120.5581626}	2021-03-17 07:51:37.819+00
5136	10	21	{"lat":15.1647737,"lng":120.5581626}	2021-03-17 07:51:42.76+00
5137	10	21	{"lat":15.1647737,"lng":120.5581626}	2021-03-17 07:51:47.759+00
5138	10	21	{"lat":15.1647737,"lng":120.5581626}	2021-03-17 07:51:52.763+00
5139	10	21	{"lat":15.1647737,"lng":120.5581626}	2021-03-17 07:51:57.793+00
5140	10	21	{"lat":15.1647737,"lng":120.5581626}	2021-03-17 07:52:02.757+00
5141	10	21	{"lat":15.1647737,"lng":120.5581626}	2021-03-17 07:52:07.748+00
5142	10	21	{"lat":15.1647737,"lng":120.5581626}	2021-03-17 07:52:12.787+00
5143	10	21	{"lat":15.1663563,"lng":120.5623042}	2021-03-17 07:52:17.802+00
5144	10	21	{"lat":15.1663563,"lng":120.5623042}	2021-03-17 07:52:22.766+00
5145	10	21	{"lat":15.1663563,"lng":120.5623042}	2021-03-17 07:52:27.755+00
5146	10	21	{"lat":15.1664912,"lng":120.5634425}	2021-03-17 07:52:32.784+00
5147	10	21	{"lat":15.1664912,"lng":120.5634425}	2021-03-17 07:52:37.789+00
5148	10	21	{"lat":15.1664912,"lng":120.5634425}	2021-03-17 07:52:42.767+00
5149	10	21	{"lat":15.1664912,"lng":120.5634425}	2021-03-17 07:52:47.75+00
5150	10	21	{"lat":15.1664912,"lng":120.5634425}	2021-03-17 07:52:52.79+00
5151	10	21	{"lat":15.1664912,"lng":120.5634425}	2021-03-17 07:52:57.768+00
5152	10	21	{"lat":15.1664912,"lng":120.5634425}	2021-03-17 07:53:02.738+00
5153	10	21	{"lat":15.167247,"lng":120.5659281}	2021-03-17 07:53:07.776+00
5154	10	21	{"lat":15.167247,"lng":120.5659281}	2021-03-17 07:53:12.773+00
5155	10	21	{"lat":15.167247,"lng":120.5659281}	2021-03-17 07:53:17.775+00
5156	10	21	{"lat":15.167247,"lng":120.5659281}	2021-03-17 07:53:22.754+00
5157	10	21	{"lat":15.167247,"lng":120.5659281}	2021-03-17 07:53:27.763+00
5158	10	21	{"lat":15.1667464,"lng":120.5693025}	2021-03-17 07:53:32.768+00
5159	10	21	{"lat":15.1667464,"lng":120.5693025}	2021-03-17 07:53:37.756+00
5160	10	21	{"lat":15.1667464,"lng":120.5693025}	2021-03-17 07:53:42.752+00
5161	10	21	{"lat":15.1667464,"lng":120.5693025}	2021-03-17 07:53:47.759+00
5162	10	21	{"lat":15.1667464,"lng":120.5693025}	2021-03-17 07:53:52.776+00
5163	10	21	{"lat":15.1667464,"lng":120.5693025}	2021-03-17 07:53:57.784+00
5164	10	21	{"lat":15.1667464,"lng":120.5693025}	2021-03-17 07:54:02.771+00
5165	10	21	{"lat":15.1667464,"lng":120.5693025}	2021-03-17 07:54:07.774+00
5166	10	21	{"lat":15.1667464,"lng":120.5693025}	2021-03-17 07:54:12.741+00
5167	10	21	{"lat":15.1667464,"lng":120.5693025}	2021-03-17 07:54:17.762+00
5168	10	21	{"lat":15.1660206,"lng":120.5740574}	2021-03-17 07:54:22.759+00
5169	10	21	{"lat":15.1660206,"lng":120.5740574}	2021-03-17 07:54:27.777+00
5170	10	21	{"lat":15.1658414,"lng":120.5752197}	2021-03-17 07:54:32.749+00
5171	10	21	{"lat":15.1658414,"lng":120.5752197}	2021-03-17 07:54:37.747+00
5172	10	21	{"lat":15.1658414,"lng":120.5752197}	2021-03-17 07:54:42.786+00
5173	10	21	{"lat":15.1658414,"lng":120.5752197}	2021-03-17 07:54:47.758+00
5174	10	21	{"lat":15.1658414,"lng":120.5752197}	2021-03-17 07:54:52.753+00
5175	10	21	{"lat":15.1658414,"lng":120.5752197}	2021-03-17 07:54:57.756+00
5176	10	21	{"lat":15.1658414,"lng":120.5752197}	2021-03-17 07:55:02.747+00
5177	10	21	{"lat":15.1658414,"lng":120.5752197}	2021-03-17 07:55:07.746+00
5178	10	21	{"lat":15.1658414,"lng":120.5752197}	2021-03-17 07:55:12.759+00
5179	10	21	{"lat":15.1658414,"lng":120.5752197}	2021-03-17 07:55:17.738+00
5180	10	21	{"lat":15.1665714,"lng":120.5805085}	2021-03-17 07:55:22.743+00
5181	10	21	{"lat":15.1665714,"lng":120.5805085}	2021-03-17 07:55:27.74+00
5182	10	21	{"lat":15.1667137,"lng":120.5803783}	2021-03-17 07:55:32.744+00
5183	10	21	{"lat":15.1667137,"lng":120.5803783}	2021-03-17 07:55:37.75+00
5184	10	21	{"lat":15.1667137,"lng":120.5803783}	2021-03-17 07:55:42.747+00
5185	10	21	{"lat":15.1667137,"lng":120.5803783}	2021-03-17 07:55:47.758+00
5186	10	21	{"lat":15.1667137,"lng":120.5803783}	2021-03-17 07:55:52.744+00
5187	10	21	{"lat":15.1667137,"lng":120.5803783}	2021-03-17 07:55:57.74+00
5188	10	21	{"lat":15.1667137,"lng":120.5803783}	2021-03-17 07:56:02.74+00
5189	10	21	{"lat":15.1667137,"lng":120.5803783}	2021-03-17 07:56:07.748+00
5190	10	21	{"lat":15.1667137,"lng":120.5803783}	2021-03-17 07:56:12.759+00
5191	10	21	{"lat":15.1667137,"lng":120.5803783}	2021-03-17 07:56:17.752+00
5192	10	21	{"lat":15.1670409,"lng":120.5802659}	2021-03-17 07:56:22.747+00
5193	10	21	{"lat":15.1670409,"lng":120.5802659}	2021-03-17 07:56:27.744+00
5194	10	21	{"lat":15.1670408,"lng":120.5802662}	2021-03-17 07:56:32.746+00
5195	10	21	{"lat":15.1670408,"lng":120.5802662}	2021-03-17 07:56:37.744+00
5196	10	21	{"lat":15.1670408,"lng":120.5802662}	2021-03-17 07:56:42.738+00
5197	10	21	{"lat":15.1670408,"lng":120.5802662}	2021-03-17 07:56:47.736+00
5198	10	21	{"lat":15.1670408,"lng":120.5802662}	2021-03-17 07:56:52.736+00
5199	10	21	{"lat":15.1670408,"lng":120.5802662}	2021-03-17 07:56:57.741+00
5200	10	21	{"lat":15.1670408,"lng":120.5802662}	2021-03-17 07:57:02.751+00
5201	10	21	{"lat":15.1670408,"lng":120.5802662}	2021-03-17 07:57:06.579+00
5202	10	21	{"lat":15.1670408,"lng":120.5802662}	2021-03-17 07:57:10.529+00
5203	10	21	{"lat":15.1670408,"lng":120.5802662}	2021-03-17 07:57:15.555+00
5204	10	21	{"lat":15.1670408,"lng":120.5802662}	2021-03-17 07:57:17.822+00
5205	10	21	{"lat":15.1669031,"lng":120.5802386}	2021-03-17 07:57:24.525+00
5206	10	21	{"lat":15.1669031,"lng":120.5802386}	2021-03-17 07:57:26.062+00
5207	10	\N	{"lat":"15.1669031","lng":"120.5802386"}	2021-03-17 07:57:27.084+00
5208	9	\N	{"lat":"15.1625605","lng":"120.5565129"}	2021-03-17 07:57:52.856+00
5221	4	35	{"lat":15.162691,"lng":120.5565628}	2021-03-17 07:31:20.152+00
5222	4	35	{"lat":15.162691,"lng":120.5565628}	2021-03-17 07:31:25.153+00
5223	4	35	{"lat":15.1626911,"lng":120.5565628}	2021-03-17 07:31:30.146+00
5224	4	35	{"lat":15.1626912,"lng":120.5565627}	2021-03-17 07:31:35.152+00
5225	4	35	{"lat":15.1626912,"lng":120.5565627}	2021-03-17 07:31:40.127+00
5226	4	35	{"lat":15.1626867,"lng":120.5565627}	2021-03-17 07:31:45.539+00
5227	4	35	{"lat":15.1626753,"lng":120.5565628}	2021-03-17 07:31:50.127+00
5228	4	35	{"lat":15.1626793,"lng":120.5565638}	2021-03-17 07:31:55.007+00
5229	4	35	{"lat":15.1626814,"lng":120.5565641}	2021-03-17 07:31:59.117+00
5230	4	35	{"lat":15.1626747,"lng":120.5565618}	2021-03-17 07:32:05.514+00
5231	4	35	{"lat":15.1626694,"lng":120.5565597}	2021-03-17 07:32:10.717+00
5232	4	35	{"lat":15.1626703,"lng":120.5565623}	2021-03-17 07:32:14.298+00
5233	4	35	{"lat":15.162671,"lng":120.5565644}	2021-03-17 07:32:20.679+00
5234	4	35	{"lat":15.162668,"lng":120.5565665}	2021-03-17 07:32:25.138+00
5235	4	35	{"lat":15.1626674,"lng":120.5565686}	2021-03-17 07:32:30.152+00
5236	4	35	{"lat":15.1626781,"lng":120.5565694}	2021-03-17 07:32:35.126+00
5237	4	35	{"lat":15.1626843,"lng":120.5565727}	2021-03-17 07:32:40.148+00
5238	4	35	{"lat":15.1626855,"lng":120.556575}	2021-03-17 07:32:45.117+00
5239	4	35	{"lat":15.162685,"lng":120.5565746}	2021-03-17 07:32:50.148+00
5240	4	35	{"lat":15.1626843,"lng":120.5565738}	2021-03-17 07:32:55.153+00
5241	4	35	{"lat":15.1626803,"lng":120.5565635}	2021-03-17 07:33:00.862+00
5242	4	35	{"lat":15.162675,"lng":120.5565623}	2021-03-17 07:33:05.626+00
5243	4	35	{"lat":15.1626752,"lng":120.5565636}	2021-03-17 07:33:10.165+00
5244	4	35	{"lat":15.16268,"lng":120.556562}	2021-03-17 07:33:15.803+00
5245	4	35	{"lat":15.1626814,"lng":120.5565626}	2021-03-17 07:33:20.142+00
5246	4	35	{"lat":15.1626828,"lng":120.556572}	2021-03-17 07:33:25.148+00
5247	4	35	{"lat":15.1626829,"lng":120.5565729}	2021-03-17 07:33:30.12+00
5248	4	35	{"lat":15.1626834,"lng":120.5565729}	2021-03-17 07:33:35.145+00
5249	4	35	{"lat":15.1626831,"lng":120.5565599}	2021-03-17 07:33:40.738+00
5250	4	35	{"lat":15.1626797,"lng":120.5565566}	2021-03-17 07:33:45.717+00
5251	4	35	{"lat":15.162679,"lng":120.5565559}	2021-03-17 07:33:50.15+00
5252	4	35	{"lat":15.162683,"lng":120.5565694}	2021-03-17 07:33:55.156+00
5253	4	35	{"lat":15.1626835,"lng":120.556571}	2021-03-17 07:34:00.14+00
5254	4	35	{"lat":15.1626833,"lng":120.5565706}	2021-03-17 07:34:05.146+00
5255	4	35	{"lat":15.1626833,"lng":120.5565699}	2021-03-17 07:34:08.6+00
5256	4	35	{"lat":15.1626779,"lng":120.5565322}	2021-03-17 07:34:15.15+00
5257	4	35	{"lat":15.1626496,"lng":120.5564186}	2021-03-17 07:34:20.158+00
5258	4	35	{"lat":15.1625436,"lng":120.5561582}	2021-03-17 07:34:25.169+00
5259	4	35	{"lat":15.1625031,"lng":120.5560957}	2021-03-17 07:34:28.459+00
5260	4	35	{"lat":15.1624413,"lng":120.556}	2021-03-17 07:34:33.502+00
5261	4	35	{"lat":15.1623809,"lng":120.5559061}	2021-03-17 07:34:38.462+00
5262	4	35	{"lat":15.1625887,"lng":120.5557139}	2021-03-17 07:34:45.156+00
5263	4	35	{"lat":15.1628822,"lng":120.5555572}	2021-03-17 07:34:50.139+00
5264	4	35	{"lat":15.1632216,"lng":120.5553924}	2021-03-17 07:34:56.144+00
5265	4	35	{"lat":15.1632744,"lng":120.5553596}	2021-03-17 07:34:58.501+00
5266	4	35	{"lat":15.1633078,"lng":120.5553134}	2021-03-17 07:35:05.162+00
5267	4	35	{"lat":15.1633326,"lng":120.5552941}	2021-03-17 07:35:08.517+00
5268	4	35	{"lat":15.1633555,"lng":120.5552747}	2021-03-17 07:35:13.48+00
5269	4	35	{"lat":15.163446,"lng":120.5553238}	2021-03-17 07:35:20.039+00
5270	4	35	{"lat":15.1634108,"lng":120.5552697}	2021-03-17 07:35:25.174+00
5271	4	35	{"lat":15.1634023,"lng":120.5552601}	2021-03-17 07:35:30+00
5302	4	35	{"lat":15.1634712,"lng":120.5553555}	2021-03-17 07:38:05.062+00
5303	4	35	{"lat":15.1634034,"lng":120.5553282}	2021-03-17 07:38:08.372+00
5304	4	35	{"lat":15.1631992,"lng":120.5554329}	2021-03-17 07:38:15.063+00
5305	4	35	{"lat":15.1633774,"lng":120.5553344}	2021-03-17 07:38:18.384+00
5306	4	35	{"lat":15.1634531,"lng":120.5553318}	2021-03-17 07:38:25.064+00
5307	4	35	{"lat":15.1633982,"lng":120.5553255}	2021-03-17 07:38:28.375+00
5308	4	35	{"lat":15.1634407,"lng":120.5553404}	2021-03-17 07:38:35.111+00
5309	4	35	{"lat":15.1633829,"lng":120.555324}	2021-03-17 07:38:40.016+00
5310	4	35	{"lat":15.1631546,"lng":120.5553269}	2021-03-17 07:38:45.053+00
5311	4	35	{"lat":15.1633719,"lng":120.5553248}	2021-03-17 07:38:48.407+00
5312	4	35	{"lat":15.1631968,"lng":120.555349}	2021-03-17 07:38:55.052+00
5313	4	35	{"lat":15.1633735,"lng":120.5553262}	2021-03-17 07:39:01.14+00
5314	4	35	{"lat":15.1633917,"lng":120.555324}	2021-03-17 07:39:05.04+00
5315	4	35	{"lat":15.1633798,"lng":120.5553254}	2021-03-17 07:39:08.396+00
5316	4	35	{"lat":15.1632047,"lng":120.5554307}	2021-03-17 07:39:15.052+00
5317	4	35	{"lat":15.1633703,"lng":120.5553304}	2021-03-17 07:39:18.388+00
5318	4	35	{"lat":15.1632183,"lng":120.5554385}	2021-03-17 07:39:24.996+00
5319	4	35	{"lat":15.1631734,"lng":120.5554352}	2021-03-17 07:39:30.061+00
5320	4	35	{"lat":15.1633656,"lng":120.55533}	2021-03-17 07:39:33.386+00
5321	4	35	{"lat":15.1629971,"lng":120.5555115}	2021-03-17 07:39:40.042+00
5322	4	35	{"lat":15.1631363,"lng":120.5554648}	2021-03-17 07:39:45.065+00
5323	4	35	{"lat":15.1633659,"lng":120.5553303}	2021-03-17 07:39:48.374+00
5324	4	35	{"lat":15.1633309,"lng":120.5554541}	2021-03-17 07:39:55.054+00
5325	4	35	{"lat":15.163371,"lng":120.5553317}	2021-03-17 07:39:58.38+00
5326	4	35	{"lat":15.1633744,"lng":120.5553235}	2021-03-17 07:40:05.124+00
5327	4	35	{"lat":15.1633757,"lng":120.5553204}	2021-03-17 07:40:10.043+00
5328	4	35	{"lat":15.1633706,"lng":120.555323}	2021-03-17 07:40:13.372+00
5329	4	35	{"lat":15.1632425,"lng":120.5554428}	2021-03-17 07:40:20.063+00
5330	4	35	{"lat":15.1632109,"lng":120.5554607}	2021-03-17 07:40:25.047+00
5331	4	35	{"lat":15.1631026,"lng":120.5554946}	2021-03-17 07:40:30.072+00
5332	4	35	{"lat":15.1633623,"lng":120.5553323}	2021-03-17 07:40:33.387+00
5333	4	35	{"lat":15.16318,"lng":120.5554487}	2021-03-17 07:40:40.043+00
5334	4	35	{"lat":15.1631578,"lng":120.5555387}	2021-03-17 07:40:45.113+00
5335	4	35	{"lat":15.1634134,"lng":120.5552947}	2021-03-17 07:40:50.055+00
5336	4	35	{"lat":15.1633696,"lng":120.5553264}	2021-03-17 07:40:53.39+00
5337	4	35	{"lat":15.1632284,"lng":120.5554622}	2021-03-17 07:41:00.038+00
5338	4	35	{"lat":15.163363,"lng":120.5553327}	2021-03-17 07:41:03.431+00
5339	4	35	{"lat":15.1632422,"lng":120.5555151}	2021-03-17 07:41:10.057+00
5340	4	35	{"lat":15.1633613,"lng":120.5553405}	2021-03-17 07:41:13.374+00
5341	4	35	{"lat":15.1633115,"lng":120.5555057}	2021-03-17 07:41:20.111+00
5342	4	35	{"lat":15.1633708,"lng":120.5553245}	2021-03-17 07:41:25.069+00
5343	4	35	{"lat":15.1633667,"lng":120.5553308}	2021-03-17 07:41:28.388+00
5344	4	35	{"lat":15.1631928,"lng":120.5554444}	2021-03-17 07:41:35.07+00
5345	4	35	{"lat":15.1633589,"lng":120.5553368}	2021-03-17 07:41:38.394+00
5346	4	35	{"lat":15.1631801,"lng":120.5554336}	2021-03-17 07:41:45.069+00
5347	4	35	{"lat":15.163355,"lng":120.5553387}	2021-03-17 07:41:48.36+00
5348	4	35	{"lat":15.1631083,"lng":120.5554443}	2021-03-17 07:41:55.051+00
5349	4	35	{"lat":15.1633366,"lng":120.5553452}	2021-03-17 07:41:58.383+00
5350	4	35	{"lat":15.1631678,"lng":120.5554034}	2021-03-17 07:42:05.033+00
5351	4	35	{"lat":15.1630984,"lng":120.5554352}	2021-03-17 07:42:10.065+00
5352	4	35	{"lat":15.1633459,"lng":120.555341}	2021-03-17 07:42:13.371+00
5353	4	35	{"lat":15.1632494,"lng":120.5554374}	2021-03-17 07:42:20.07+00
5354	4	35	{"lat":15.1633582,"lng":120.5553425}	2021-03-17 07:42:23.378+00
5355	4	35	{"lat":15.1632696,"lng":120.5555025}	2021-03-17 07:42:30.059+00
5356	4	35	{"lat":15.1631202,"lng":120.5555256}	2021-03-17 07:42:35.029+00
5357	4	35	{"lat":15.1631372,"lng":120.5555364}	2021-03-17 07:42:40.027+00
5358	4	35	{"lat":15.1631208,"lng":120.5554916}	2021-03-17 07:42:45.055+00
5359	4	35	{"lat":15.1633552,"lng":120.5553418}	2021-03-17 07:42:48.369+00
5360	4	35	{"lat":15.163364,"lng":120.5553462}	2021-03-17 07:42:55.069+00
5361	4	35	{"lat":15.1632945,"lng":120.5553732}	2021-03-17 07:43:00.14+00
5362	4	35	{"lat":15.1629826,"lng":120.5555451}	2021-03-17 07:43:05.131+00
5363	4	35	{"lat":15.1625617,"lng":120.5557003}	2021-03-17 07:43:10.117+00
5364	4	35	{"lat":15.1622483,"lng":120.5558814}	2021-03-17 07:43:15.145+00
5365	4	35	{"lat":15.161946,"lng":120.556079}	2021-03-17 07:43:20.128+00
5366	4	35	{"lat":15.1616282,"lng":120.5562566}	2021-03-17 07:43:25.125+00
5367	4	35	{"lat":15.16142,"lng":120.5563465}	2021-03-17 07:43:30.155+00
5368	4	35	{"lat":15.1614144,"lng":120.556336}	2021-03-17 07:43:35.148+00
5369	4	35	{"lat":15.1613885,"lng":120.5563544}	2021-03-17 07:43:38.514+00
5370	4	35	{"lat":15.161338,"lng":120.5563835}	2021-03-17 07:43:43.495+00
5371	4	35	{"lat":15.1612897,"lng":120.5564115}	2021-03-17 07:43:48.478+00
5372	4	35	{"lat":15.161242,"lng":120.5564392}	2021-03-17 07:43:53.543+00
5373	4	35	{"lat":15.161936,"lng":120.5575042}	2021-03-17 07:44:01.14+00
5374	4	35	{"lat":15.1619583,"lng":120.5575913}	2021-03-17 07:44:03.503+00
5375	4	35	{"lat":15.1619774,"lng":120.5576882}	2021-03-17 07:44:08.483+00
5376	4	35	{"lat":15.1619743,"lng":120.5576118}	2021-03-17 07:44:15.097+00
5377	4	35	{"lat":15.1621104,"lng":120.5576089}	2021-03-17 07:44:18.613+00
5378	4	35	{"lat":15.162032,"lng":120.557543}	2021-03-17 07:44:23.539+00
5379	4	35	{"lat":15.1619631,"lng":120.5575157}	2021-03-17 07:44:28.68+00
5380	4	35	{"lat":15.1619122,"lng":120.5574875}	2021-03-17 07:44:33.486+00
5381	4	35	{"lat":15.159323,"lng":120.5584914}	2021-03-17 07:44:40.158+00
5382	4	35	{"lat":15.1589323,"lng":120.5585618}	2021-03-17 07:44:45.153+00
5383	4	35	{"lat":15.1586665,"lng":120.5586567}	2021-03-17 07:44:50.142+00
5384	4	35	{"lat":15.158477,"lng":120.5587769}	2021-03-17 07:44:55.168+00
5385	4	35	{"lat":15.1584638,"lng":120.5588043}	2021-03-17 07:45:00.133+00
5386	4	35	{"lat":15.158403,"lng":120.558833}	2021-03-17 07:45:03.477+00
5387	4	35	{"lat":15.1583486,"lng":120.5588441}	2021-03-17 07:45:09.287+00
5388	4	35	{"lat":15.1583912,"lng":120.5588466}	2021-03-17 07:45:13.499+00
5389	4	35	{"lat":15.1546155,"lng":120.5601091}	2021-03-17 07:45:18.509+00
5390	4	35	{"lat":15.1543432,"lng":120.5597495}	2021-03-17 07:45:23.503+00
5391	4	35	{"lat":15.1559658,"lng":120.5597838}	2021-03-17 07:45:28.849+00
5392	4	35	{"lat":15.155998,"lng":120.5597854}	2021-03-17 07:45:34.871+00
5393	4	35	{"lat":15.156005,"lng":120.5597858}	2021-03-17 07:45:38.495+00
5394	4	35	{"lat":15.154192,"lng":120.5602625}	2021-03-17 07:45:45.162+00
5395	4	35	{"lat":15.153795,"lng":120.5602559}	2021-03-17 07:45:50.139+00
5396	4	35	{"lat":15.1534138,"lng":120.5601717}	2021-03-17 07:45:55.155+00
5397	4	35	{"lat":15.1530029,"lng":120.5598776}	2021-03-17 07:46:00.136+00
5398	4	35	{"lat":15.1525736,"lng":120.5594774}	2021-03-17 07:46:05.145+00
5399	4	35	{"lat":15.1519741,"lng":120.5592187}	2021-03-17 07:46:10.134+00
5400	4	35	{"lat":15.1512976,"lng":120.5592257}	2021-03-17 07:46:15.119+00
5401	4	35	{"lat":15.1505995,"lng":120.5592533}	2021-03-17 07:46:20.151+00
5402	4	35	{"lat":15.1499208,"lng":120.5592559}	2021-03-17 07:46:25.139+00
5403	4	35	{"lat":15.1492965,"lng":120.559282}	2021-03-17 07:46:30.158+00
5404	4	35	{"lat":15.1484949,"lng":120.5592523}	2021-03-17 07:46:36.13+00
5405	4	35	{"lat":15.1478897,"lng":120.5592477}	2021-03-17 07:46:40.137+00
5406	4	35	{"lat":15.1471188,"lng":120.5592601}	2021-03-17 07:46:45.112+00
5407	4	35	{"lat":15.1463274,"lng":120.5592858}	2021-03-17 07:46:50.158+00
5408	4	35	{"lat":15.1455419,"lng":120.5593222}	2021-03-17 07:46:55.139+00
5409	4	35	{"lat":15.1449638,"lng":120.5593039}	2021-03-17 07:47:00.123+00
5410	4	35	{"lat":15.1446019,"lng":120.5592848}	2021-03-17 07:47:05.155+00
5411	4	35	{"lat":15.1445854,"lng":120.5592657}	2021-03-17 07:47:10.117+00
5412	4	35	{"lat":15.144477,"lng":120.5592395}	2021-03-17 07:47:15.059+00
5413	4	35	{"lat":15.1444202,"lng":120.559213}	2021-03-17 07:47:18.334+00
5414	4	35	{"lat":15.144367,"lng":120.5591704}	2021-03-17 07:47:25.044+00
5415	4	35	{"lat":15.1435426,"lng":120.5595844}	2021-03-17 07:47:30.151+00
5416	4	35	{"lat":15.1427126,"lng":120.5602468}	2021-03-17 07:47:35.146+00
5417	4	35	{"lat":15.1423096,"lng":120.5605576}	2021-03-17 07:47:40.148+00
5418	4	35	{"lat":15.1418116,"lng":120.5609143}	2021-03-17 07:47:45.152+00
5419	4	35	{"lat":15.1413398,"lng":120.5612096}	2021-03-17 07:47:50.141+00
5420	4	35	{"lat":15.1410308,"lng":120.5614429}	2021-03-17 07:47:55.133+00
5421	4	35	{"lat":15.1406887,"lng":120.5616692}	2021-03-17 07:48:00.151+00
5422	4	35	{"lat":15.1402784,"lng":120.5619128}	2021-03-17 07:48:05.163+00
5423	4	35	{"lat":15.1398838,"lng":120.5620819}	2021-03-17 07:48:10.144+00
5424	4	35	{"lat":15.139569,"lng":120.5622167}	2021-03-17 07:48:15.12+00
5425	4	35	{"lat":15.1392878,"lng":120.5623935}	2021-03-17 07:48:20.156+00
5426	4	35	{"lat":15.1389712,"lng":120.5625924}	2021-03-17 07:48:25.149+00
5427	4	35	{"lat":15.1387281,"lng":120.5627816}	2021-03-17 07:48:30.166+00
5428	4	35	{"lat":15.1387739,"lng":120.5627614}	2021-03-17 07:48:34.369+00
5429	4	35	{"lat":15.1387842,"lng":120.5627802}	2021-03-17 07:48:40.071+00
5430	4	35	{"lat":15.1387495,"lng":120.5627892}	2021-03-17 07:48:43.383+00
5431	4	35	{"lat":15.1387477,"lng":120.5627977}	2021-03-17 07:48:50.006+00
5432	4	35	{"lat":15.1387687,"lng":120.5628289}	2021-03-17 07:48:55.049+00
5433	4	35	{"lat":15.1387527,"lng":120.5627968}	2021-03-17 07:49:00.152+00
5434	4	35	{"lat":15.1387462,"lng":120.5627847}	2021-03-17 07:49:06.131+00
5435	4	35	{"lat":15.1387464,"lng":120.5627852}	2021-03-17 07:49:10.027+00
5436	4	35	{"lat":15.1387465,"lng":120.5627854}	2021-03-17 07:49:15.066+00
5437	4	35	{"lat":15.1386339,"lng":120.5627782}	2021-03-17 07:49:20.044+00
5438	4	35	{"lat":15.1386399,"lng":120.5627748}	2021-03-17 07:49:25.046+00
5439	4	35	{"lat":15.1386418,"lng":120.5627636}	2021-03-17 07:49:30.014+00
5440	4	35	{"lat":15.1386491,"lng":120.5627706}	2021-03-17 07:49:35.047+00
5441	4	35	{"lat":15.1386307,"lng":120.5627421}	2021-03-17 07:49:40.044+00
5442	4	35	{"lat":15.1386286,"lng":120.5627426}	2021-03-17 07:49:45.037+00
5443	4	35	{"lat":15.1386448,"lng":120.5627575}	2021-03-17 07:49:50.077+00
5444	4	35	{"lat":15.1387206,"lng":120.5627678}	2021-03-17 07:49:55.006+00
5445	4	35	{"lat":15.1387592,"lng":120.5627572}	2021-03-17 07:50:00.05+00
5446	4	35	{"lat":15.1387095,"lng":120.5627594}	2021-03-17 07:50:03.389+00
5447	4	35	{"lat":15.138707,"lng":120.5627671}	2021-03-17 07:50:10.151+00
5448	4	35	{"lat":15.1387095,"lng":120.5627714}	2021-03-17 07:50:15.083+00
5449	4	35	{"lat":15.1387108,"lng":120.5627685}	2021-03-17 07:50:18.391+00
5450	4	35	{"lat":15.1387243,"lng":120.5627676}	2021-03-17 07:50:25.068+00
5451	4	35	{"lat":15.1388333,"lng":120.5627411}	2021-03-17 07:50:30.08+00
5452	4	35	{"lat":15.1390628,"lng":120.5626854}	2021-03-17 07:50:33.382+00
5453	4	35	{"lat":15.139344,"lng":120.5603699}	2021-03-17 07:50:40.348+00
5454	4	35	{"lat":15.1407221,"lng":120.5614941}	2021-03-17 07:50:45.075+00
5455	4	35	{"lat":15.1407691,"lng":120.5614765}	2021-03-17 07:50:50.014+00
5456	4	35	{"lat":15.1408439,"lng":120.5614424}	2021-03-17 07:50:55.078+00
5457	4	35	{"lat":15.1414634,"lng":120.5611143}	2021-03-17 07:50:58.373+00
5458	4	35	{"lat":15.142404,"lng":120.560515}	2021-03-17 07:51:05.048+00
5459	4	35	{"lat":15.142597,"lng":120.560477}	2021-03-17 07:51:08.364+00
5460	4	35	{"lat":15.1433876,"lng":120.5598769}	2021-03-17 07:51:15.056+00
5461	4	35	{"lat":15.1435609,"lng":120.5596845}	2021-03-17 07:51:18.349+00
5462	4	35	{"lat":15.1445776,"lng":120.5587759}	2021-03-17 07:51:25.066+00
5463	4	35	{"lat":15.144329,"lng":120.5593185}	2021-03-17 07:51:28.366+00
5464	4	35	{"lat":15.1443509,"lng":120.5593764}	2021-03-17 07:51:35.058+00
5465	4	35	{"lat":15.1444912,"lng":120.5594504}	2021-03-17 07:51:38.357+00
5466	4	35	{"lat":15.1449359,"lng":120.5592654}	2021-03-17 07:51:45.048+00
5467	4	35	{"lat":15.1455289,"lng":120.559384}	2021-03-17 07:51:50.064+00
5468	4	35	{"lat":15.1454322,"lng":120.5593974}	2021-03-17 07:51:53.376+00
5469	4	35	{"lat":15.1463023,"lng":120.5594162}	2021-03-17 07:52:00.083+00
5470	4	35	{"lat":15.1471788,"lng":120.5594749}	2021-03-17 07:52:05.142+00
5471	4	35	{"lat":15.1478097,"lng":120.5594519}	2021-03-17 07:52:10.13+00
5472	4	35	{"lat":15.1484184,"lng":120.5594697}	2021-03-17 07:52:15.141+00
5473	4	35	{"lat":15.148954,"lng":120.5594903}	2021-03-17 07:52:20.158+00
5474	4	35	{"lat":15.1494647,"lng":120.5594956}	2021-03-17 07:52:25.133+00
5475	4	35	{"lat":15.1500969,"lng":120.5594715}	2021-03-17 07:52:30.145+00
5476	4	35	{"lat":15.1504537,"lng":120.5594593}	2021-03-17 07:52:35.151+00
5477	4	35	{"lat":15.1508447,"lng":120.5594452}	2021-03-17 07:52:40.14+00
5478	4	35	{"lat":15.1513582,"lng":120.5594643}	2021-03-17 07:52:45.145+00
5479	4	35	{"lat":15.1519738,"lng":120.5594798}	2021-03-17 07:52:50.147+00
5480	4	35	{"lat":15.1526955,"lng":120.5596857}	2021-03-17 07:52:56.138+00
5481	4	35	{"lat":15.1531229,"lng":120.5600505}	2021-03-17 07:53:00.131+00
5482	4	35	{"lat":15.1536169,"lng":120.5603668}	2021-03-17 07:53:05.136+00
5483	4	35	{"lat":15.1540599,"lng":120.5604135}	2021-03-17 07:53:10.134+00
5484	4	35	{"lat":15.1545677,"lng":120.5604005}	2021-03-17 07:53:15.132+00
5485	4	35	{"lat":15.1551038,"lng":120.5603425}	2021-03-17 07:53:20.13+00
5486	4	35	{"lat":15.1556348,"lng":120.5602918}	2021-03-17 07:53:25.151+00
5487	4	35	{"lat":15.1561821,"lng":120.560113}	2021-03-17 07:53:30.124+00
5488	4	35	{"lat":15.1567776,"lng":120.5599784}	2021-03-17 07:53:35.145+00
5489	4	35	{"lat":15.157343,"lng":120.559896}	2021-03-17 07:53:40.133+00
5490	4	35	{"lat":15.1578082,"lng":120.5598142}	2021-03-17 07:53:45.146+00
5491	4	35	{"lat":15.1581266,"lng":120.559642}	2021-03-17 07:53:50.131+00
5492	4	35	{"lat":15.1582532,"lng":120.5593183}	2021-03-17 07:53:55.143+00
5493	4	35	{"lat":15.1583553,"lng":120.5589378}	2021-03-17 07:54:00.129+00
5494	4	35	{"lat":15.1584845,"lng":120.5587122}	2021-03-17 07:54:05.144+00
5495	4	35	{"lat":15.1585624,"lng":120.5587033}	2021-03-17 07:54:08.555+00
5496	4	35	{"lat":15.1590124,"lng":120.5586115}	2021-03-17 07:54:15.137+00
5497	4	35	{"lat":15.1594452,"lng":120.5584832}	2021-03-17 07:54:20.151+00
5498	4	35	{"lat":15.159794,"lng":120.5582907}	2021-03-17 07:54:25.135+00
5499	4	35	{"lat":15.1601326,"lng":120.5581504}	2021-03-17 07:54:30.14+00
5500	4	35	{"lat":15.160418,"lng":120.5580242}	2021-03-17 07:54:35.159+00
5501	4	35	{"lat":15.1604823,"lng":120.5580079}	2021-03-17 07:54:38.652+00
5502	4	35	{"lat":15.1604823,"lng":120.5580079}	2021-03-17 07:54:48.284+00
5503	4	35	{"lat":15.1604823,"lng":120.5580079}	2021-03-17 07:54:53.287+00
5504	4	35	{"lat":15.1604823,"lng":120.5580079}	2021-03-17 07:54:58.318+00
5505	4	35	{"lat":15.1630858,"lng":120.5579508}	2021-03-17 07:58:37.168+00
5506	4	35	{"lat":15.1625411,"lng":120.5572313}	2021-03-17 07:58:43.614+00
5507	4	\N	{"lat":"15.1625597","lng":"120.5564981"}	2021-03-17 07:58:57.135+00
5508	4	\N	{"lat":"15.1625625","lng":"120.556502"}	2021-03-17 08:00:30.743+00
5509	3	\N	{"lat":"15.1626795","lng":"120.5565638"}	2021-03-17 08:00:31.18+00
5510	4	\N	{"lat":"15.1625565","lng":"120.5564948"}	2021-03-17 08:01:05.784+00
5511	4	\N	{"lat":"15.1625702","lng":"120.5565045"}	2021-03-17 08:01:30.638+00
5512	10	\N	{"lat":"15.1663252","lng":"120.5826485"}	2021-03-17 08:01:32.194+00
5513	5	\N	{"lat":"15.1625659","lng":"120.5565013"}	2021-03-17 08:01:32.649+00
5514	3	\N	{"lat":"15.1626795","lng":"120.5565638"}	2021-03-17 08:01:50.156+00
5515	10	\N	{"lat":"15.1660396","lng":"120.5808392"}	2021-03-17 08:01:56.822+00
5516	5	\N	{"lat":"15.1626671","lng":"120.5565618"}	2021-03-17 08:02:11.686+00
5517	10	\N	{"lat":"15.1656759","lng":"120.5789678"}	2021-03-17 08:02:23.949+00
5518	3	\N	{"lat":"15.1626795","lng":"120.5565638"}	2021-03-17 08:03:18.903+00
5519	10	\N	{"lat":"15.1660151","lng":"120.5705453"}	2021-03-17 08:03:30.467+00
5520	6	54	{"lat":15.1625662,"lng":120.5564977}	2021-03-17 07:42:36.223+00
5521	6	54	{"lat":15.1625656,"lng":120.556501}	2021-03-17 07:42:41.138+00
5522	6	54	{"lat":15.1625664,"lng":120.5565035}	2021-03-17 07:42:47.49+00
5523	6	54	{"lat":15.1625664,"lng":120.5565035}	2021-03-17 07:42:49.083+00
5524	6	54	{"lat":15.1625664,"lng":120.5565035}	2021-03-17 07:42:54.102+00
5525	6	54	{"lat":15.1625664,"lng":120.5565035}	2021-03-17 07:42:59.103+00
5526	6	54	{"lat":15.1625664,"lng":120.5565035}	2021-03-17 07:43:39.22+00
5527	6	54	{"lat":15.1625664,"lng":120.5565035}	2021-03-17 07:43:52.782+00
5528	6	54	{"lat":15.1625664,"lng":120.5565035}	2021-03-17 07:44:56.746+00
5529	6	54	{"lat":15.1625664,"lng":120.5565035}	2021-03-17 07:45:12.204+00
5530	6	54	{"lat":15.1625664,"lng":120.5565035}	2021-03-17 07:45:51.421+00
5531	6	54	{"lat":15.1625664,"lng":120.5565035}	2021-03-17 07:46:40.404+00
5532	6	54	{"lat":15.1625664,"lng":120.5565035}	2021-03-17 07:47:38.582+00
5533	6	54	{"lat":15.1625664,"lng":120.5565035}	2021-03-17 07:47:43.646+00
5534	6	54	{"lat":15.1625664,"lng":120.5565035}	2021-03-17 07:48:12.254+00
5535	6	54	{"lat":15.1625664,"lng":120.5565035}	2021-03-17 07:48:32.437+00
5536	6	54	{"lat":15.1494203,"lng":120.55926}	2021-03-17 07:48:37.457+00
5537	6	54	{"lat":15.1494203,"lng":120.55926}	2021-03-17 07:48:42.459+00
5538	6	54	{"lat":15.1494203,"lng":120.55926}	2021-03-17 07:48:49.973+00
5539	6	54	{"lat":15.1494203,"lng":120.55926}	2021-03-17 07:50:14.515+00
5540	6	54	{"lat":15.1494203,"lng":120.55926}	2021-03-17 07:51:01.591+00
5541	6	54	{"lat":15.1386476,"lng":120.5627528}	2021-03-17 07:51:28.258+00
5542	6	54	{"lat":15.138651,"lng":120.5629006}	2021-03-17 07:51:59.974+00
5543	6	54	{"lat":15.138693,"lng":120.5629002}	2021-03-17 07:52:04.79+00
5544	6	54	{"lat":15.1386718,"lng":120.5629065}	2021-03-17 07:52:12.712+00
5545	6	54	{"lat":15.1386718,"lng":120.5629065}	2021-03-17 07:52:13.133+00
5546	6	54	{"lat":15.1386562,"lng":120.5629104}	2021-03-17 07:52:18.333+00
5547	6	54	{"lat":15.1387167,"lng":120.563005}	2021-03-17 07:52:45.667+00
5548	6	54	{"lat":15.138729,"lng":120.5629857}	2021-03-17 07:52:52.699+00
5549	6	54	{"lat":15.138729,"lng":120.5629857}	2021-03-17 07:52:53.136+00
5550	6	54	{"lat":15.138759,"lng":120.5629411}	2021-03-17 07:53:00.058+00
5551	6	54	{"lat":15.138759,"lng":120.5629411}	2021-03-17 07:53:03.16+00
5552	6	54	{"lat":15.138759,"lng":120.5629411}	2021-03-17 07:53:08.163+00
5553	6	54	{"lat":15.138759,"lng":120.5629411}	2021-03-17 07:53:33.893+00
5554	6	54	{"lat":15.138759,"lng":120.5629411}	2021-03-17 07:53:44.533+00
5555	6	54	{"lat":15.138759,"lng":120.5629411}	2021-03-17 07:53:56.843+00
5556	6	54	{"lat":15.138759,"lng":120.5629411}	2021-03-17 07:54:05.285+00
5557	6	54	{"lat":15.13857,"lng":120.5627223}	2021-03-17 07:54:10.343+00
5558	6	54	{"lat":15.1386731,"lng":120.5628424}	2021-03-17 07:54:21.689+00
5559	6	54	{"lat":15.1387394,"lng":120.5629608}	2021-03-17 07:54:51.676+00
5560	6	54	{"lat":15.1386632,"lng":120.5627615}	2021-03-17 07:54:56.704+00
5561	6	54	{"lat":15.1387156,"lng":120.5629116}	2021-03-17 07:55:11.735+00
5562	6	54	{"lat":15.1386849,"lng":120.5629792}	2021-03-17 07:55:27.648+00
5563	6	54	{"lat":15.1386849,"lng":120.5629792}	2021-03-17 07:55:28.252+00
5564	6	54	{"lat":15.1386367,"lng":120.5627267}	2021-03-17 07:55:49.333+00
5565	6	54	{"lat":15.1386367,"lng":120.5627267}	2021-03-17 07:55:59.742+00
5566	6	54	{"lat":15.1388464,"lng":120.5626458}	2021-03-17 07:56:19.327+00
5567	6	54	{"lat":15.1388464,"lng":120.5626458}	2021-03-17 07:56:23.288+00
5568	6	54	{"lat":15.1388464,"lng":120.5626458}	2021-03-17 07:56:28.222+00
5569	6	54	{"lat":15.1388464,"lng":120.5626458}	2021-03-17 07:56:37.016+00
5570	6	54	{"lat":15.1388464,"lng":120.5626458}	2021-03-17 07:57:07.977+00
5571	6	54	{"lat":15.1388464,"lng":120.5626458}	2021-03-17 07:57:15.925+00
5572	6	54	{"lat":15.1388464,"lng":120.5626458}	2021-03-17 07:57:55.578+00
5573	6	54	{"lat":15.1388464,"lng":120.5626458}	2021-03-17 07:58:03.27+00
5574	6	54	{"lat":15.1388464,"lng":120.5626458}	2021-03-17 07:58:42.406+00
5575	6	54	{"lat":15.1388464,"lng":120.5626458}	2021-03-17 07:59:00.381+00
5576	6	54	{"lat":15.1388464,"lng":120.5626458}	2021-03-17 07:59:13.563+00
5577	6	54	{"lat":15.1388464,"lng":120.5626458}	2021-03-17 07:59:35.567+00
5578	6	54	{"lat":15.1388464,"lng":120.5626458}	2021-03-17 08:00:22.067+00
5579	6	54	{"lat":15.1388464,"lng":120.5626458}	2021-03-17 08:00:41.224+00
5580	6	54	{"lat":15.1388464,"lng":120.5626458}	2021-03-17 08:00:46.23+00
5581	6	54	{"lat":15.1388464,"lng":120.5626458}	2021-03-17 08:01:11.745+00
5582	6	54	{"lat":15.1598553,"lng":120.5583516}	2021-03-17 08:01:16.705+00
5583	6	54	{"lat":15.1598553,"lng":120.5583516}	2021-03-17 08:01:27.935+00
5584	6	54	{"lat":15.1598553,"lng":120.5583516}	2021-03-17 08:01:42.814+00
5585	6	54	{"lat":15.1598553,"lng":120.5583516}	2021-03-17 08:02:04.912+00
5586	6	54	{"lat":15.1598553,"lng":120.5583516}	2021-03-17 08:03:13.044+00
5587	6	54	{"lat":15.162703,"lng":120.5565629}	2021-03-17 08:03:18.041+00
5588	6	54	{"lat":15.1625445,"lng":120.5564951}	2021-03-17 08:03:34.978+00
5589	6	54	{"lat":15.1625427,"lng":120.5564875}	2021-03-17 08:03:54.573+00
5590	6	\N	{"lat":"15.1625557","lng":"120.5564813"}	2021-03-17 08:04:20.937+00
5591	6	\N	{"lat":"15.1625232","lng":"120.5564884"}	2021-03-17 08:04:43.248+00
5592	6	\N	{"lat":"15.1625232","lng":"120.5564884"}	2021-03-17 08:04:43.657+00
5593	6	\N	{"lat":"15.1625278","lng":"120.5564816"}	2021-03-17 08:04:47.869+00
5594	6	\N	{"lat":"15.1625281","lng":"120.5564799"}	2021-03-17 08:04:49.454+00
5595	9	\N	{"lat":"15.1625605","lng":"120.5565129"}	2021-03-17 08:04:52.785+00
5596	6	\N	{"lat":"15.1625281","lng":"120.5564799"}	2021-03-17 08:05:30.823+00
5597	10	\N	{"lat":"15.1658266","lng":"120.5601416"}	2021-03-17 08:05:37.688+00
5598	10	\N	{"lat":"15.1626837","lng":"120.5565396"}	2021-03-17 08:07:34.784+00
5599	10	\N	{"lat":"15.1626837","lng":"120.5565396"}	2021-03-17 08:08:16.842+00
5600	2	47	{"lat":15.1626697,"lng":120.556565}	2021-03-17 07:37:55.03+00
5601	2	47	{"lat":15.1626713,"lng":120.5565627}	2021-03-17 07:38:00.041+00
5602	2	47	{"lat":15.1626676,"lng":120.5565616}	2021-03-17 07:38:05.021+00
5603	2	47	{"lat":15.1626683,"lng":120.5565618}	2021-03-17 07:38:10.038+00
5604	2	47	{"lat":15.162672,"lng":120.5565648}	2021-03-17 07:38:14.999+00
5605	2	47	{"lat":15.162672,"lng":120.5565648}	2021-03-17 07:38:18.452+00
5606	2	47	{"lat":15.162672,"lng":120.5565648}	2021-03-17 07:38:23.798+00
5607	2	47	{"lat":15.162672,"lng":120.5565648}	2021-03-17 07:38:30.406+00
5608	2	47	{"lat":15.162672,"lng":120.5565648}	2021-03-17 07:38:35.42+00
5609	2	47	{"lat":15.162672,"lng":120.5565648}	2021-03-17 07:38:40.411+00
5610	2	47	{"lat":15.162672,"lng":120.5565648}	2021-03-17 07:38:45.415+00
5611	2	47	{"lat":15.162672,"lng":120.5565648}	2021-03-17 07:38:50.408+00
5612	2	47	{"lat":15.162672,"lng":120.5565648}	2021-03-17 07:38:55.411+00
5613	2	47	{"lat":15.162672,"lng":120.5565648}	2021-03-17 07:39:00.444+00
5614	2	47	{"lat":15.162672,"lng":120.5565648}	2021-03-17 07:39:05.451+00
5615	2	47	{"lat":15.162672,"lng":120.5565648}	2021-03-17 07:39:10.448+00
5616	2	47	{"lat":15.162672,"lng":120.5565648}	2021-03-17 07:39:15.444+00
5617	2	47	{"lat":15.162672,"lng":120.5565648}	2021-03-17 07:39:20.452+00
5618	2	47	{"lat":15.162672,"lng":120.5565648}	2021-03-17 07:39:25.406+00
5619	2	47	{"lat":15.162672,"lng":120.5565648}	2021-03-17 07:39:30.488+00
5620	2	47	{"lat":15.162672,"lng":120.5565648}	2021-03-17 07:39:35.445+00
5621	2	47	{"lat":15.162672,"lng":120.5565648}	2021-03-17 07:39:40.446+00
5622	2	47	{"lat":15.162672,"lng":120.5565648}	2021-03-17 07:39:45.443+00
5623	2	47	{"lat":15.162672,"lng":120.5565648}	2021-03-17 07:39:50.445+00
5624	2	47	{"lat":15.162672,"lng":120.5565648}	2021-03-17 07:39:55.495+00
5625	2	47	{"lat":15.162672,"lng":120.5565648}	2021-03-17 07:40:00.424+00
5626	2	47	{"lat":15.162672,"lng":120.5565648}	2021-03-17 07:40:06.768+00
5627	2	47	{"lat":15.162672,"lng":120.5565648}	2021-03-17 07:40:14.104+00
5628	2	47	{"lat":15.162672,"lng":120.5565648}	2021-03-17 07:40:30.32+00
5629	2	47	{"lat":15.162672,"lng":120.5565648}	2021-03-17 07:40:36.017+00
5630	2	47	{"lat":15.162672,"lng":120.5565648}	2021-03-17 07:40:45.442+00
5631	2	47	{"lat":15.162672,"lng":120.5565648}	2021-03-17 07:41:13.024+00
5632	2	47	{"lat":15.162672,"lng":120.5565648}	2021-03-17 07:42:06.102+00
5633	2	47	{"lat":15.162672,"lng":120.5565648}	2021-03-17 07:42:48.677+00
5634	2	47	{"lat":15.162672,"lng":120.5565648}	2021-03-17 07:42:57.462+00
5635	2	47	{"lat":15.162672,"lng":120.5565648}	2021-03-17 07:43:16.102+00
5636	2	47	{"lat":15.162672,"lng":120.5565648}	2021-03-17 07:44:25.197+00
5637	2	47	{"lat":15.162672,"lng":120.5565648}	2021-03-17 07:44:30.217+00
5638	2	47	{"lat":15.162672,"lng":120.5565648}	2021-03-17 07:44:35.236+00
5639	2	47	{"lat":15.162672,"lng":120.5565648}	2021-03-17 07:44:42.194+00
5640	2	47	{"lat":15.162672,"lng":120.5565648}	2021-03-17 07:44:58.293+00
5641	2	47	{"lat":15.162672,"lng":120.5565648}	2021-03-17 07:45:06.339+00
5642	2	47	{"lat":15.162672,"lng":120.5565648}	2021-03-17 07:46:12.236+00
5643	2	47	{"lat":15.162672,"lng":120.5565648}	2021-03-17 07:46:50.839+00
5644	2	47	{"lat":15.1300407,"lng":120.5745272}	2021-03-17 07:46:55.841+00
5645	2	47	{"lat":15.1300407,"lng":120.5745272}	2021-03-17 07:47:00.807+00
5646	2	47	{"lat":15.1300407,"lng":120.5745272}	2021-03-17 07:47:05.821+00
5647	2	47	{"lat":15.1300407,"lng":120.5745272}	2021-03-17 07:47:10.843+00
5648	2	47	{"lat":15.1300407,"lng":120.5745272}	2021-03-17 07:47:15.843+00
5649	2	47	{"lat":15.1300407,"lng":120.5745272}	2021-03-17 07:47:22.104+00
5650	2	47	{"lat":15.1300407,"lng":120.5745272}	2021-03-17 07:47:45.053+00
5651	2	47	{"lat":15.1300407,"lng":120.5745272}	2021-03-17 07:48:29.952+00
5652	2	47	{"lat":15.1300407,"lng":120.5745272}	2021-03-17 07:48:49.398+00
5653	2	47	{"lat":15.1300407,"lng":120.5745272}	2021-03-17 07:49:30.234+00
5654	2	47	{"lat":15.1300407,"lng":120.5745272}	2021-03-17 07:49:35.657+00
5655	2	47	{"lat":15.1300407,"lng":120.5745272}	2021-03-17 07:50:03.889+00
5656	2	47	{"lat":15.1300407,"lng":120.5745272}	2021-03-17 07:50:08.852+00
5657	2	47	{"lat":15.1300407,"lng":120.5745272}	2021-03-17 07:50:13.883+00
5658	2	47	{"lat":15.1300407,"lng":120.5745272}	2021-03-17 07:50:18.852+00
5659	2	47	{"lat":15.1300407,"lng":120.5745272}	2021-03-17 07:50:25.741+00
5660	2	47	{"lat":15.1300407,"lng":120.5745272}	2021-03-17 07:50:32.28+00
5661	2	47	{"lat":15.1300407,"lng":120.5745272}	2021-03-17 07:51:02.465+00
5662	2	47	{"lat":15.1300407,"lng":120.5745272}	2021-03-17 07:51:52.9+00
5663	2	47	{"lat":15.1363414,"lng":120.5881198}	2021-03-17 07:51:57.953+00
5664	2	47	{"lat":15.1363414,"lng":120.5881198}	2021-03-17 07:52:02.865+00
5665	2	47	{"lat":15.1363591,"lng":120.5880364}	2021-03-17 07:52:11.218+00
5666	2	47	{"lat":15.1363591,"lng":120.5880364}	2021-03-17 07:52:12.901+00
5667	2	47	{"lat":15.1363339,"lng":120.5879462}	2021-03-17 07:52:18.963+00
5668	2	47	{"lat":15.1363508,"lng":120.5878958}	2021-03-17 07:52:24.15+00
5669	2	47	{"lat":15.1363603,"lng":120.5878561}	2021-03-17 07:52:28.734+00
5670	2	47	{"lat":15.1363689,"lng":120.5878172}	2021-03-17 07:52:33.009+00
5671	2	47	{"lat":15.1363809,"lng":120.5878338}	2021-03-17 07:52:38.256+00
5672	2	47	{"lat":15.1365168,"lng":120.587848}	2021-03-17 07:52:57.947+00
5673	2	47	{"lat":15.1364614,"lng":120.5878693}	2021-03-17 07:53:02.002+00
5674	2	47	{"lat":15.1364453,"lng":120.5878861}	2021-03-17 07:53:05.499+00
5675	2	47	{"lat":15.1364453,"lng":120.5878861}	2021-03-17 07:53:10.471+00
5676	2	47	{"lat":15.1364453,"lng":120.5878861}	2021-03-17 07:53:15.482+00
5677	2	47	{"lat":15.1364453,"lng":120.5878861}	2021-03-17 07:53:20.65+00
5678	2	47	{"lat":15.1364453,"lng":120.5878861}	2021-03-17 07:53:28.762+00
5679	2	47	{"lat":15.1364453,"lng":120.5878861}	2021-03-17 07:53:33.761+00
5680	2	47	{"lat":15.1364453,"lng":120.5878861}	2021-03-17 07:53:38.756+00
5681	2	47	{"lat":15.1364453,"lng":120.5878861}	2021-03-17 07:53:43.725+00
5682	2	47	{"lat":15.1364453,"lng":120.5878861}	2021-03-17 07:53:48.761+00
5683	2	47	{"lat":15.1364453,"lng":120.5878861}	2021-03-17 07:53:53.718+00
5684	2	47	{"lat":15.1364453,"lng":120.5878861}	2021-03-17 07:54:08.178+00
5685	2	47	{"lat":15.1364453,"lng":120.5878861}	2021-03-17 07:54:30.109+00
5686	2	47	{"lat":15.1364453,"lng":120.5878861}	2021-03-17 07:55:01.706+00
5687	2	47	{"lat":15.1364453,"lng":120.5878861}	2021-03-17 07:55:20.48+00
5688	2	47	{"lat":15.1364453,"lng":120.5878861}	2021-03-17 07:55:31.696+00
5689	2	47	{"lat":15.1364453,"lng":120.5878861}	2021-03-17 07:55:39.76+00
5690	2	47	{"lat":15.1364453,"lng":120.5878861}	2021-03-17 07:55:56.465+00
5691	2	47	{"lat":15.1364453,"lng":120.5878861}	2021-03-17 07:56:06.773+00
5692	2	47	{"lat":15.1364453,"lng":120.5878861}	2021-03-17 07:56:37.087+00
5693	2	47	{"lat":15.1364453,"lng":120.5878861}	2021-03-17 07:57:10.631+00
5694	2	47	{"lat":15.1364453,"lng":120.5878861}	2021-03-17 07:57:57.32+00
5695	2	47	{"lat":15.1364453,"lng":120.5878861}	2021-03-17 07:58:02.688+00
5696	2	47	{"lat":15.1364453,"lng":120.5878861}	2021-03-17 07:58:07.67+00
5697	2	47	{"lat":15.1364453,"lng":120.5878861}	2021-03-17 07:58:12.685+00
5698	2	47	{"lat":15.1364453,"lng":120.5878861}	2021-03-17 07:58:20.745+00
5699	2	47	{"lat":15.1364453,"lng":120.5878861}	2021-03-17 07:58:37.514+00
5700	2	47	{"lat":15.1364453,"lng":120.5878861}	2021-03-17 07:58:49.708+00
5701	2	47	{"lat":15.1364453,"lng":120.5878861}	2021-03-17 07:59:43.143+00
5702	2	47	{"lat":15.1364453,"lng":120.5878861}	2021-03-17 08:01:02.698+00
5703	2	47	{"lat":15.1364453,"lng":120.5878861}	2021-03-17 08:03:01.134+00
5704	2	47	{"lat":15.1450008,"lng":120.5591696}	2021-03-17 08:03:09.23+00
5705	2	47	{"lat":15.1450008,"lng":120.5591696}	2021-03-17 08:03:30.578+00
5706	2	47	{"lat":15.1450008,"lng":120.5591696}	2021-03-17 08:03:35.579+00
5707	2	47	{"lat":15.1450008,"lng":120.5591696}	2021-03-17 08:03:40.584+00
5708	2	47	{"lat":15.1450008,"lng":120.5591696}	2021-03-17 08:04:01.076+00
5709	2	47	{"lat":15.1450008,"lng":120.5591696}	2021-03-17 08:04:50.913+00
5710	2	47	{"lat":15.1450008,"lng":120.5591696}	2021-03-17 08:06:46.313+00
5711	2	47	{"lat":15.1450008,"lng":120.5591696}	2021-03-17 08:06:51.309+00
5712	2	47	{"lat":15.1450008,"lng":120.5591696}	2021-03-17 08:06:59.602+00
5713	2	47	{"lat":15.1450008,"lng":120.5591696}	2021-03-17 08:07:04.567+00
5714	2	47	{"lat":15.1450008,"lng":120.5591696}	2021-03-17 08:07:09.61+00
5715	2	47	{"lat":15.1450008,"lng":120.5591696}	2021-03-17 08:07:14.59+00
5716	2	47	{"lat":15.1450008,"lng":120.5591696}	2021-03-17 08:07:19.603+00
5717	2	47	{"lat":15.1450008,"lng":120.5591696}	2021-03-17 08:07:24.601+00
5718	2	47	{"lat":15.1450008,"lng":120.5591696}	2021-03-17 08:07:29.674+00
5719	2	47	{"lat":15.1450008,"lng":120.5591696}	2021-03-17 08:07:41.255+00
5720	2	47	{"lat":15.1450008,"lng":120.5591696}	2021-03-17 08:07:57.751+00
5721	2	47	{"lat":15.1450008,"lng":120.5591696}	2021-03-17 08:08:04.314+00
5722	2	47	{"lat":15.1450008,"lng":120.5591696}	2021-03-17 08:08:11.354+00
5723	2	47	{"lat":15.1450008,"lng":120.5591696}	2021-03-17 08:08:16.571+00
5724	2	47	{"lat":15.1450008,"lng":120.5591696}	2021-03-17 08:08:33.844+00
5725	2	47	{"lat":15.1450008,"lng":120.5591696}	2021-03-17 08:08:39.75+00
5726	2	47	{"lat":15.1450008,"lng":120.5591696}	2021-03-17 08:08:46.071+00
5727	2	47	{"lat":15.1450008,"lng":120.5591696}	2021-03-17 08:08:52.422+00
5728	2	47	{"lat":15.1450008,"lng":120.5591696}	2021-03-17 08:09:01.421+00
5729	2	47	{"lat":15.1625693,"lng":120.5564979}	2021-03-17 08:09:06.419+00
5730	2	47	{"lat":15.1625693,"lng":120.5564979}	2021-03-17 08:09:11.406+00
5731	2	47	{"lat":15.1625693,"lng":120.5564979}	2021-03-17 08:09:16.394+00
5732	2	47	{"lat":15.1625693,"lng":120.5564979}	2021-03-17 08:09:21.425+00
5733	2	\N	{"lat":"15.1625646","lng":"120.556502"}	2021-03-17 08:09:27.127+00
5734	2	\N	{"lat":"15.1625562","lng":"120.5565078"}	2021-03-17 08:09:39.367+00
5735	3	\N	{"lat":"15.1626677","lng":"120.5565612"}	2021-03-17 08:11:51.448+00
5736	3	\N	{"lat":"15.1626677","lng":"120.5565612"}	2021-03-17 08:12:56.551+00
5737	8	\N	{"lat":"15.1630635","lng":"120.5554041"}	2021-03-17 08:13:39.642+00
5738	3	\N	{"lat":"15.1626677","lng":"120.5565612"}	2021-03-17 08:14:21.478+00
5739	3	\N	{"lat":"15.1626677","lng":"120.5565612"}	2021-03-17 08:15:51.913+00
5740	8	\N	{"lat":"15.1625585","lng":"120.5564995"}	2021-03-17 08:17:34.164+00
5741	8	\N	{"lat":"15.1625585","lng":"120.5564995"}	2021-03-17 08:17:34.758+00
5742	8	31	{"lat":15.1625655,"lng":120.5565042}	2021-03-17 08:17:57.986+00
5743	8	31	{"lat":15.1625583,"lng":120.5564974}	2021-03-17 08:18:03.13+00
5744	8	31	{"lat":15.1625618,"lng":120.5564956}	2021-03-17 08:18:08.054+00
5745	8	31	{"lat":15.1625628,"lng":120.5564968}	2021-03-17 08:18:13.106+00
5746	8	31	{"lat":15.1625576,"lng":120.5564947}	2021-03-17 08:18:18.053+00
5747	8	31	{"lat":15.1625564,"lng":120.5564961}	2021-03-17 08:18:23.084+00
5748	8	31	{"lat":15.1625616,"lng":120.5564933}	2021-03-17 08:18:28.065+00
5749	8	31	{"lat":15.1625631,"lng":120.5564955}	2021-03-17 08:18:33.08+00
5750	8	31	{"lat":15.162556,"lng":120.5564931}	2021-03-17 08:18:38.078+00
5751	8	31	{"lat":15.1625585,"lng":120.5564947}	2021-03-17 08:18:43.16+00
5752	8	31	{"lat":15.1625587,"lng":120.5564957}	2021-03-17 08:18:48.125+00
5753	8	31	{"lat":15.162562,"lng":120.5564986}	2021-03-17 08:18:53.365+00
5754	8	31	{"lat":15.162557,"lng":120.5564945}	2021-03-17 08:18:58.069+00
5755	8	31	{"lat":15.1625581,"lng":120.5564964}	2021-03-17 08:19:03.063+00
5756	8	31	{"lat":15.1625592,"lng":120.5564997}	2021-03-17 08:19:08.083+00
5757	8	\N	{"lat":"15.1625592","lng":"120.5564997"}	2021-03-17 08:19:09.887+00
5758	3	\N	{"lat":"15.16181","lng":"120.555439"}	2021-03-17 08:21:36.837+00
5759	2	\N	{"lat":"15.1626737","lng":"120.5565631"}	2021-03-17 08:23:03.447+00
\.


                                                                                                                                                                    3265.dat                                                                                            0000600 0004000 0002000 00000004217 14024343251 0014253 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        10	23	http://18.166.234.218:8000/public/rider/default-rider.png	1	15.16268370000000000000	120.55653960000000000000	{"brand":"Honda","model":"TMX 155","plate_number":"1309 LN","color":"Black"}	2021-03-17 05:56:18.198+00
4	17	http://18.166.234.218:8000/public/rider/default-rider.png	3	15.16257020000000000000	120.55650450000000000000	{"brand":"Yamaha","model":"Sniper 150","plate_number":"9728 GH","color":"Yellow"}	2021-03-17 05:56:18.022+00
5	18	http://18.166.234.218:8000/public/rider/default-rider.png	3	15.16266710000000000000	120.55656180000000000000	{"brand":"Suzuki","model":"Smash 150","plate_number":"6640 KD","color":"Black"}	2021-03-17 05:56:18.05+00
8	21	http://18.166.234.218:8000/public/rider/default-rider.png	1	15.16255920000000000000	120.55649970000000000000	{"brand":"Honda","model":"TMX 155","plate_number":"1309 LN","color":"Black"}	2021-03-17 05:56:18.135+00
7	20	http://18.166.234.218:8000/public/rider/default-rider.png	3	15.16267290000000000000	120.55656010000000000000	{"brand":"Honda","model":"TMX 155","plate_number":"1309 LN","color":"Black"}	2021-03-17 05:56:18.106+00
3	16	http://18.166.234.218:8000/public/rider/default-rider.png	1	15.16181000000000000000	120.55543900000000000000	{"brand":"Yamaha","model":"NMax","plate_number":"8647 CA","color":"Red"}	2021-03-17 05:56:17.992+00
2	15	http://18.166.234.218:8000/public/rider/default-rider.png	3	15.16267370000000000000	120.55656310000000000000	{"brand":"Yamaha","model":"Mio I 125","plate_number":"3547 YB","color":"BLUE"}	2021-03-17 05:56:17.958+00
1	14	http://18.166.234.218:8000/public/rider/default-rider.png	3	15.16267190000000000000	120.55656010000000000000	{"brand":"Honda","model":"TMX 155","plate_number":"1309 LN","color":"Black"}	2021-03-17 05:56:17.928+00
9	22	http://18.166.234.218:8000/public/rider/default-rider.png	1	15.16256050000000000000	120.55651290000000000000	{"brand":"Honda","model":"TMX 155","plate_number":"1309 LN","color":"Black"}	2021-03-17 05:56:18.164+00
6	19	http://18.166.234.218:8000/public/rider/default-rider.png	1	15.16252810000000000000	120.55647990000000000000	{"brand":"Honda","model":"TMX 155","plate_number":"1309 LN","color":"Black"}	2021-03-17 05:56:18.079+00
\.


                                                                                                                                                                                                                                                                                                                                                                                 3275.dat                                                                                            0000600 0004000 0002000 00000000005 14024343251 0014243 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           3257.dat                                                                                            0000600 0004000 0002000 00000017762 14024343251 0014265 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	1	Sundaeguk 	Sundaeguk - is a soup	http://18.166.234.218:8000/public/store/restaurants/1-1.jpg	300	300.00	279.00	[1,2]	[1,2,3,4,5]	0	0	soup	available	2021-03-17 05:56:17.05+00	2021-03-17 05:56:17.05+00
2	1	Ppyeo Haejang-guk 	Ppyeo Haejang-guk - is a soup	http://18.166.234.218:8000/public/store/restaurants/1-2.jpg	400	400.00	372.00	[3,4]	[1,2]	0	0	soup	available	2021-03-17 05:56:17.054+00	2021-03-17 05:56:17.054+00
3	1	Osorigukbap	Osorigukbap - is a soup	http://18.166.234.218:8000/public/restaurants/1-3.jpg	350	350.00	325.50	[]	[]	0	0	soup	available	2021-03-17 05:56:17.058+00	2021-03-17 05:56:17.058+00
4	2	Ddung Macaron	Ddung Macaron - is a Coffee	http://18.166.234.218:8000/public/store/restaurants/2-1.jpg	129	138.03	129.00	[5]	[6]	0	0	coffee	available	2021-03-17 05:56:17.114+00	2021-03-17 05:56:17.114+00
5	2	Dan Pat Bbang	Dan Pat Bbang - is a coffee	http://18.166.234.218:8000/public/store/restaurants/2-3.jpg	60	60.00	55.80	[]	[6]	0	0	coffee	available	2021-03-17 05:56:17.117+00	2021-03-17 05:56:17.117+00
6	2	Dalgona Latte	Dalgona Latte - is a Coffee	http://18.166.234.218:8000/public/store/restaurants/2-2.jpg	180	192.60	180.00	[5]	[]	0	0	coffee	available	2021-03-17 05:56:17.121+00	2021-03-17 05:56:17.121+00
7	3	Americano	Americano - is a Coffee	http://18.166.234.218:8000/public/store/restaurants/3-1.png	130	130.00	120.90	[6]	[7]	0	0	coffee	available	2021-03-17 05:56:17.175+00	2021-03-17 05:56:17.175+00
8	3	Caramel Macchiatto	Caramel Macchiatto - is a Coffee	http://18.166.234.218:8000/public/store/restaurants/3-2.jpg	180	180.00	167.40	[6]	[]	0	0	coffee	available	2021-03-17 05:56:17.179+00	2021-03-17 05:56:17.179+00
9	3	Coldbrew	Coldbrew - is a coffee	http://18.166.234.218:8000/public/store/restaurants/3-3.jpg	60	60.00	55.80	[]	[7]	0	0	coffee	available	2021-03-17 05:56:17.182+00	2021-03-17 05:56:17.182+00
10	4	Combination Pizza	Combination Pizza - is a Pizza	http://18.166.234.218:8000/public/store/restaurants/4-1.png	399	399.00	371.07	[7]	[8]	0	0	pizza	available	2021-03-17 05:56:17.231+00	2021-03-17 05:56:17.231+00
11	4	Bulgogi Pizza	Bulgogi Pizza - is a Pizza	http://18.166.234.218:8000/public/store/restaurants/4-2.png	499	499.00	464.07	[7]	[]	0	0	pizza	available	2021-03-17 05:56:17.235+00	2021-03-17 05:56:17.235+00
12	4	Cheese Tteokbokki	Cheese Tteokbokki - is a coffee	http://18.166.234.218:8000/public/store/restaurants/4-3.jpg	249	249.00	231.57	[]	[]	0	0	rice cake	available	2021-03-17 05:56:17.239+00	2021-03-17 05:56:17.239+00
14	5	Origangjeong	Origangjeong - is a Chicken	http://18.166.234.218:8000/public/store/restaurants/5-2.jpg	280	280.00	260.40	[]	[]	0	0	chicken	available	2021-03-17 05:56:17.274+00	2021-03-17 05:56:17.274+00
15	5	Oritang	Oritang  - is a soup	http://18.166.234.218:8000/public/store/restaurants/5-3.jpg	249	249.00	231.57	[]	[]	0	0	soup	available	2021-03-17 05:56:17.276+00	2021-03-17 05:56:17.276+00
16	6	Shabu Shabu Mix	per kilo	http://18.166.234.218:8000/public/store/restaurants/6-1.png	510	527.84	492.15	[]	[]	0	0	frozen meal	available	2021-03-17 05:56:17.308+00	2021-03-17 05:56:17.308+00
17	6	Mango Powder	250 Grams	http://18.166.234.218:8000/public/store/restaurants/6-2.png	250	258.75	241.25	[]	[]	0	0	Spice	available	2021-03-17 05:56:17.311+00	2021-03-17 05:56:17.311+00
18	6	Durian	per kilo	http://18.166.234.218:8000/public/store/restaurants/6-3.png	260	269.09	250.90	[]	[]	0	0	Fruit	available	2021-03-17 05:56:17.314+00	2021-03-17 05:56:17.314+00
19	6	Samanco		http://18.166.234.218:8000/public/store/restaurants/6-4.png	30	31.04	28.95	[]	[]	0	0	Ice Cream	available	2021-03-17 05:56:17.318+00	2021-03-17 05:56:17.318+00
22	7	Tanduay Ice in Bottle 330ml		http://18.166.234.218:8000/public/store/restaurants/7-3.jpg	43	43.00	39.99	[]	[]	0	0	Beer	available	2021-03-17 05:56:17.361+00	2021-03-17 05:56:17.361+00
26	8	Galbitang	Galbitang - is a soup	http://18.166.234.218:8000/public/store/restaurants/8-1.jpg	480	480.00	446.40	[9,10]	[9,10,11,12,13]	0	0	soup	available	2021-03-17 05:56:17.457+00	2021-03-17 05:56:17.457+00
27	8	Kimchijjigae	Kimchijjigae - is a soup	http://18.166.234.218:8000/public/store/restaurants/8-2.jpg	270	270.00	251.10	[9]	[9,10,11,13]	0	0	soup	available	2021-03-17 05:56:17.461+00	2021-03-17 05:56:17.461+00
28	8	Dwenjangjjigae	Dwenjangjjigae - is a soup	http://18.166.234.218:8000/public/store/restaurants/8-3.jpg	300	300.00	279.00	[10]	[9,10,11,13]	0	0	soup	available	2021-03-17 05:56:17.465+00	2021-03-17 05:56:17.465+00
29	9	Jjajangmyun	Manboklim - is a noodle	http://18.166.234.218:8000/public/store/restaurants/9-1.jpg	300	300.00	279.00	[11,12,13]	[14,15,16,17,18]	0	0	noodle	available	2021-03-17 05:56:17.553+00	2021-03-17 05:56:17.553+00
30	9	Jjambbong	Jjambbong - is a noodle	http://18.166.234.218:8000/public/store/restaurants/9-2.jpg	350	350.00	325.50	[12]	[14,15,16,18]	0	0	soup	available	2021-03-17 05:56:17.556+00	2021-03-17 05:56:17.556+00
31	9	Tangsuyuk	Tangsuyuk - is a noodle	http://18.166.234.218:8000/public/store/restaurants/9-3.jpg	800	800.00	744.00	[13]	[14,15,16,18]	0	0	soup	available	2021-03-17 05:56:17.559+00	2021-03-17 05:56:17.559+00
32	10	Seaujang	Seaujang - is a noodle	http://18.166.234.218:8000/public/store/restaurants/10-1.jpg	400	400.00	372.00	[15,16]	[19,20,21,22,23]	0	0	all	available	2021-03-17 05:56:17.653+00	2021-03-17 05:56:17.653+00
33	10	Bulgogi	Bulgogi - is a rice cake	http://18.166.234.218:8000/public/store/restaurants/10-2.jpg	600	600.00	558.00	[15]	[19,20,21,23]	0	0	all	available	2021-03-17 05:56:17.657+00	2021-03-17 05:56:17.657+00
34	10	Bibimbab	Bibimbab - is a rice	http://18.166.234.218:8000/public/store/restaurants/10-3.jpg	300	300.00	279.00	[16]	[19,20,21,23]	0	0	soup	available	2021-03-17 05:56:17.667+00	2021-03-17 05:56:17.667+00
35	11	Tuna sasimi	Tuna sasimi - is a sasimi	http://18.166.234.218:8000/public/store/restaurants/11-1.jpg	500	500.00	465.00	[18,19]	[24,25,26,27,28]	0	0	sasimi	available	2021-03-17 05:56:17.776+00	2021-03-17 05:56:17.776+00
36	11	Salmon Sasimi	Salmon Sasimi - is a Sasimi	http://18.166.234.218:8000/public/store/restaurants/11-2.jpg	600	600.00	558.00	[18]	[24,25,26,28]	0	0	sasimi	available	2021-03-17 05:56:17.779+00	2021-03-17 05:56:17.779+00
37	11	Octopus sasimi	Octopus sasimi - is a sasimi	http://18.166.234.218:8000/public/store/restaurants/11-3.jpg	350	350.00	325.50	[19]	[24,25,26,28]	0	0	soup	available	2021-03-17 05:56:17.782+00	2021-03-17 05:56:17.782+00
38	12	Fried Chicken	Fried Chicken - is a Fried Chicken	http://18.166.234.218:8000/public/store/restaurants/12-1.jpg	500	500.00	465.00	[21,22]	[29,30,31,32,33]	0	0	chicken	available	2021-03-17 05:56:17.885+00	2021-03-17 05:56:17.885+00
39	12	Golbeng	Golbeng - is a Golbeng	http://18.166.234.218:8000/public/store/restaurants/12-2.jpg	400	400.00	372.00	[21]	[29,30,31,33]	0	0	chicken	available	2021-03-17 05:56:17.889+00	2021-03-17 05:56:17.889+00
40	12	Canpung	Canpung - is a Canpung	http://18.166.234.218:8000/public/store/restaurants/11-3.jpg	700	700.00	651.00	[22]	[29,30,31,33]	0	0	chicken	available	2021-03-17 05:56:17.893+00	2021-03-17 05:56:17.893+00
21	7	San Miguel Apple Flavored Beer in Can 330ml		http://18.166.234.218:8000/public/store/restaurants/7-2.jpg	56	56.00	52.08	[]	[]	0	0	Beer	out-of-stock	2021-03-17 05:56:17.358+00	2021-03-17 07:46:50.806+00
25	7	Red Horse in Can 330ml		http://18.166.234.218:8000/public/store/restaurants/7-6.jpg	50	50.00	46.50	[]	[]	0	0	Beer	available	2021-03-17 05:56:17.371+00	2021-03-17 06:17:30.958+00
23	7	Heineken 6 pack		http://18.166.234.218:8000/public/store/restaurants/7-4.jpg	799	799.00	743.07	[]	[]	0	0	Beer	out-of-stock	2021-03-17 05:56:17.365+00	2021-03-17 07:46:52.51+00
20	7	Corona 6 pack		http://18.166.234.218:8000/public/store/restaurants/7-1.jpg	240	240.00	223.20	[]	[]	0	0	Beer	out-of-stock	2021-03-17 05:56:17.354+00	2021-03-17 07:47:06.68+00
24	7	San Miguel Pale Pilsen in Can 330ml		http://18.166.234.218:8000/public/store/restaurants/7-5.jpg	49	49.00	45.57	[]	[]	0	0	Beer	available	2021-03-17 05:56:17.368+00	2021-03-17 07:47:28.743+00
13	5	Ori Suyuk	Ori Suyuk - is a Combo Meal	http://18.166.234.218:8000/public/store/restaurants/5-1.jpg	1750	1750.00	1627.50	[]	[]	0	0	combo meal	available	2021-03-17 05:56:17.271+00	2021-03-17 06:56:39.572+00
\.


              3255.dat                                                                                            0000600 0004000 0002000 00000025326 14024343251 0014256 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        2	3	2	Blooming Angel Cafe & Bakery	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	15.13470178008279100000	120.56731798848779000000		active	open	restaurant	markup	coffee	Philippines	Pampanga	Angeles	Anunas	5.00	http://18.166.234.218:8000/public/store/restaurants/default.jpg	http://18.166.234.218:8000/public/store/restaurants/2.jpg	t	00:00:00	00:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	2021-03-17 05:56:17.087+00	2021-03-17 05:56:17.087+00
3	4	2	M.C Cafe	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	15.16312903091036400000	120.55566835504950000000		active	open	restaurant	commission	coffee	Philippines	Pampanga	Angeles	Anunas	5.00	http://18.166.234.218:8000/public/store/restaurants/default.jpg	http://18.166.234.218:8000/public/store/restaurants/3.jpg	t	00:00:00	00:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	2020-11-10 05:11:10+00	2021-03-17 05:56:17.151+00
4	5	2	RaRa Kitchen	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	15.13642235431965600000	120.58784314425043000000		active	open	restaurant	commission	coffee	Philippines	Pampanga	Angeles	Anunas	5.00	http://18.166.234.218:8000/public/store/restaurants/default.jpg	http://18.166.234.218:8000/public/store/restaurants/4.jpg	t	00:00:00	00:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	2020-11-10 05:11:10+00	2021-03-17 05:56:17.21+00
5	6	2	Happy Duck	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	15.16227220030624400000	120.55492039889194000000		active	open	restaurant	commission		Philippines	Pampanga	Angeles	Anunas	5.00	http://18.166.234.218:8000/public/store/restaurants/default.jpg	http://18.166.234.218:8000/public/store/restaurants/5.jpg	t	00:00:00	00:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	2020-11-10 05:11:10+00	2021-03-17 05:56:17.266+00
6	7	2	One Mart	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	15.15922088131948300000	120.55665227031089000000		active	open	mart	half		Philippines	Pampanga	Angeles	Anunas	5.00	http://18.166.234.218:8000/public/store/restaurants/default.jpg	http://18.166.234.218:8000/public/store/restaurants/6.png	t	00:00:00	00:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	2020-11-10 05:11:10+00	2021-03-17 05:56:17.304+00
8	9	2	Jung's Kitchen	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	15.16084667727340700000	120.55570363998413000000	Clark	active	open	restaurant	commission	korean	Philippines	Pampanga	Angeles	Anunas	5.00	http://18.166.234.218:8000/public/store/restaurants/8-logo.jpg	http://18.166.234.218:8000/public/store/restaurants/8.png	t	00:00:00	00:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	2021-03-17 05:56:17.399+00	2021-03-17 05:56:17.399+00
9	10	2	Manboklim	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	15.16084667727340700000	120.55570363998413000000	Clark	active	open	restaurant	commission	korean	Philippines	Pampanga	Angeles	Anunas	5.00	http://18.166.234.218:8000/public/store/restaurants/default.jpg	http://18.166.234.218:8000/public/store/restaurants/9.jpg	t	00:00:00	00:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	2021-03-17 05:56:17.494+00	2021-03-17 05:56:17.494+00
1	2	2	Bongane	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	15.17454003471960700000	120.51514603451642000000	Clark	active	temporary-close	restaurant	commission	korean	Philippines	Pampanga	Angeles	Anunas	5.00	http://18.166.234.218:8000/public/store/restaurants/default.jpg	http://18.166.234.218:8000/public/store/restaurants/1.png	t	00:00:00	00:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	2021-03-17 05:56:16.965+00	2021-03-17 06:30:13.516+00
10	11	2	Manchoo	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	15.16084667727340700000	120.55570363998413000000	Clark	active	open	restaurant	commission	korean	Philippines	Pampanga	Angeles	Anunas	5.00	http://18.166.234.218:8000/public/store/restaurants/default.jpg	http://18.166.234.218:8000/public/store/restaurants/10.jpg	t	00:00:00	00:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	2021-03-17 05:56:17.587+00	2021-03-17 05:56:17.587+00
12	13	2	Norang Chicken	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	15.16146442451438300000	120.55532705085352000000	Clark	active	open	restaurant	commission	korean	Philippines	Pampanga	Angeles	Anunas	5.00	http://18.166.234.218:8000/public/store/restaurants/default.jpg	http://18.166.234.218:8000/public/store/restaurants/12.jpg	t	00:00:00	00:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	2021-03-17 05:56:17.811+00	2021-03-17 05:56:17.811+00
11	12	2	Tamla Sushi	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	15.16084667727340700000	120.55570363998413000000	Clark	active	open	restaurant	commission	korean	Philippines	Pampanga	Angeles	Anunas	5.00	http://18.166.234.218:8000/public/store/restaurants/default.jpg	http://18.166.234.218:8000/public/store/restaurants/11.jpg	t	00:00:00	00:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	2021-03-17 05:56:17.708+00	2021-03-17 05:56:17.708+00
7	8	2	Seven Eleven	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	15.15996646443442000000	120.55659949779510000000	FriendShip	active	temporary-close	mart	commission		Philippines	Pampanga	Angeles	Anunas	5.00	http://18.166.234.218:8000/public/store/restaurants/default.jpg	http://18.166.234.218:8000/public/store/restaurants/7.jpg	t	00:00:00	00:00:00	t	00:00:00	23:59:00	t	00:00:00	23:59:00	t	00:00:00	23:59:00	t	00:00:00	23:59:00	t	00:00:00	23:59:00	t	00:00:00	23:59:00	2020-11-10 05:11:10+00	2021-03-17 07:50:12.24+00
\.


                                                                                                                                                                                                                                                                                                          3251.dat                                                                                            0000600 0004000 0002000 00000001554 14024343251 0014247 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	29	Home	{"lat":15.1625661,"lng":120.55650179999998}	355 Yukon St , Angeles Central Luzon		2021-03-17 05:59:48.09+00
2	30	Lets Bee Office	{"lat":15.162618094504847,"lng":120.55654216557741}	Yukon Street Margot, Angeles City Pampanga	Pasok lang sa office kuya sa taas.	2021-03-17 06:04:30.483+00
3	26	Work	{"lat":15.162788633889923,"lng":120.55652439594269}	355 Yukon St , Angeles Central Luzon	Let's Bee Office	2021-03-17 06:08:27.196+00
4	32	sm clark	{"lat":15.1675411,"lng":120.5802923}	SM City Clark Bldg. Clark Freeport, Angeles Central Luzon	flagpole	2021-03-17 06:28:37.519+00
5	31	METROBANK BALIBAGO	{"lat":15.163856200842517,"lng":120.59085365384817}	Mon Tang Avenue Santa Teresita, Angeles City Pampanga	INFRONT OF CASINO	2021-03-17 06:29:00.905+00
6	33	Home	{"lat":15.1625562,"lng":120.5564923}	355 Yukon St , Angeles Central Luzon		2021-03-17 08:25:58.499+00
\.


                                                                                                                                                    3249.dat                                                                                            0000600 0004000 0002000 00000035760 14024343251 0014264 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	Admin Admin	admin@gmail.com	$2a$08$zXJGOByYT7O.LWMqANg38.sZMNMtsNaIZjBoXp6b2pRS0D44jGUki	email	\N	\N	super-admin	09567543906	0	t	2021-03-17 05:56:16.935+00	2021-03-17 05:56:16.935+00
4	M.C Cafe	mc-cafe@gmail.com	$2a$08$SC/1cHt1gayf3BunPujWg.VotlVz/hgNTPLLlFTSVexfemeROMHjy	email	\N	\N	partner	09567543906	0	t	2021-03-17 05:56:17.146+00	2021-03-17 05:56:17.146+00
9	Jung's Kitchen	jung@gmail.com	$2a$08$C0YEveYJifsHEoM8BnjVqOuT4FVZcCUQxbnasEz4PRAIjZo3aih96	email	\N	\N	partner	09567543906	0	t	2021-03-17 05:56:17.395+00	2021-03-17 05:56:17.395+00
10	Manboklim	manboklim@gmail.com	$2a$08$ar45vUfB0FM/1uR/R3oFZe23lyi8iXE2G61dyONC6EwUmZmRwcagC	email	\N	\N	partner	09567543906	0	t	2021-03-17 05:56:17.49+00	2021-03-17 05:56:17.49+00
11	Manchoo	manchoo@gmail.com	$2a$08$9h6vaoSGfoa0h5e8oK5YqOQXeBZspwYL6icJ2QWy3Q0/yNtK.yGYm	email	\N	\N	partner	09567543906	0	t	2021-03-17 05:56:17.584+00	2021-03-17 05:56:17.584+00
12	Tamla Sushi	tamla-sushi@gmail.com	$2a$08$227abjRStSZHF31KDbGA8egdYQrrtrwoC1AktkvFqIvzRHnIjxjUu	email	\N	\N	partner	09567543906	0	t	2021-03-17 05:56:17.694+00	2021-03-17 05:56:17.694+00
13	Norang Chicken	norang-chicken@gmail.com	$2a$08$tYeguDSS6Z71i7yl6K5ZOutbkbJ8NDOjF5PbvbhDOkxizuIy3okfu	email	\N	\N	partner	09567543906	0	t	2021-03-17 05:56:17.807+00	2021-03-17 05:56:17.807+00
24	Abner Lets Bee	letsbee-abner@gmail.com	$2a$08$9WPQpBJ/TlH3Jdo6iVbDYeNNR86ebTKixB2N0g1mAAVUaKR5GrCMW	email	\N	\N	customer	09567543906	0	t	2021-03-17 05:56:18.222+00	2021-03-17 05:56:18.222+00
25	Chai Lets Bee	letsbee-chai@gmail.com	$2a$08$78GJvacgXiObfE.voETPyei61XnXkMK9q3Sq.Me8yYipA8jx2Ygzm	email	\N	\N	customer	09567543906	0	t	2021-03-17 05:56:18.247+00	2021-03-17 05:56:18.247+00
27	Jacob Lets Bee	letsbee-jacob@gmail.com	$2a$08$B/dpiM.HWyjU2.OzajTtE.Ft1H/.fVW9cfr66GmhXfziJ1lK/hXmS	email	\N	\N	customer	09567543906	0	t	2021-03-17 05:56:18.296+00	2021-03-17 05:56:18.296+00
28	Luis Lets Bee	letsbee-luis@gmail.com	$2a$08$j5PfAMtY3N5PLlSammO13uUpJp8UMO8RPaFNaogrocJFOqibMmpA.	email	\N	\N	customer	09567543906	0	t	2021-03-17 05:56:18.32+00	2021-03-17 05:56:18.32+00
21	Matthew Dolores	letsbee-matthew@gmail.com	$2a$08$zwegHnk3Mojkq/fcda8fv.KufdLijkoEIr3/jOQ/v5P0lmltxDi.i	email	\N	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjEsInJvbGUiOiJyaWRlciIsImlhdCI6MTYxNTk2MTc0MSwiZXhwIjoxNjE2MDQ4MTQxfQ.U72ig2Snkdwi4DYsp_jA8tvvBbCxIHxoo4Pzvq71VPg	rider	09567543906	0	t	2021-03-17 05:56:18.132+00	2021-03-17 06:15:41.392+00
22	Ian Santos	letsbee-ian@gmail.com	$2a$08$.Re5nDRoCZ3zN03fEPsqaeocGZ0XJ6AWFbpylntwamfaFPuZ7Z..O	email	\N	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjIsInJvbGUiOiJyaWRlciIsImlhdCI6MTYxNTk2MTAzMCwiZXhwIjoxNjE2MDQ3NDMwfQ.TEvdvvpUBtprwpI2s4_oMAtudx7z99yxqJdz7iq-D0g	rider	09567543906	0	t	2021-03-17 05:56:18.16+00	2021-03-17 06:03:50.456+00
2	Bongane	bongane@gmail.com	$2a$08$MWcPrJnI4izE9kqbYZVAlujXvL9WqCBPsRY1UWdxvh/xCsov5Q9a.	email	\N	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Miwicm9sZSI6InBhcnRuZXIiLCJpYXQiOjE2MTU5NjI2NzgsImV4cCI6MTYxNjA0OTA3OH0.n6dLdZEoydjT4AowteFHQyMwpdnIKm_wqngcOdIb7BA	partner	09567543906	0	t	2021-03-17 05:56:16.961+00	2021-03-17 06:31:18.952+00
6	Happy Duck	happy-duck@gmail.com	$2a$08$b74KWrvgdAgk9y3svb6e0uYqePWGygFVK0KY0CVSzt7EHSoLdkc9S	email	\N	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Niwicm9sZSI6InBhcnRuZXIiLCJpYXQiOjE2MTU5NjE0OTAsImV4cCI6MTYxNjA0Nzg5MH0.PYgBy0hquDbKq-Uo4czrZ-6PpmaHkiaA2Vnk91lhjwo	partner	09567543906	0	t	2021-03-17 05:56:17.263+00	2021-03-17 06:11:30.673+00
16	Dexter Manahan	letsbee-dexter@gmail.com	$2a$08$hCMQ19fUqL4p5eI2OdK1EeY/G8A7F33hSNzFJ3E2ZAvg9kQzM3kXe	email	\N	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTYsInJvbGUiOiJyaWRlciIsImlhdCI6MTYxNTk2MTQ0NiwiZXhwIjoxNjE2MDQ3ODQ2fQ.du0txdJfLgtq86t7YeoiOmt4Filj8JN9IdjEFSUy__g	rider	09567543906	0	t	2021-03-17 05:56:17.982+00	2021-03-17 06:10:46.602+00
20	Mark Dimagiba	letsbee-mark@gmail.com	$2a$08$/llKBSbW4aVU6tTp9fxe4uE77dBoJtPWdT8U53Jq6qzSNK1SUJ4Q.	email	\N	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjAsInJvbGUiOiJyaWRlciIsImlhdCI6MTYxNTk2MTQ5NywiZXhwIjoxNjE2MDQ3ODk3fQ.orDn05yfQPHPfmUzA2aWHr-Up6ZFytJcGVKXxQJaV7Y	rider	09567543906	0	t	2021-03-17 05:56:18.103+00	2021-03-17 06:11:37.792+00
15	Carl Manahan	letsbee-carl@gmail.com	$2a$08$CvgXgoUGtXDhp8Ka7BneNeQiWIypkpantLVhWBEdJEsxcYglteRWu	email	\N	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTUsInJvbGUiOiJyaWRlciIsImlhdCI6MTYxNTk2MTU0NiwiZXhwIjoxNjE2MDQ3OTQ2fQ.y2M1xbr57O5hmNo8u8cuSLjMWxMtAi4i10dCGv8Kgd4	rider	09567543906	0	t	2021-03-17 05:56:17.954+00	2021-03-17 06:12:26.167+00
14	John Carlos	letsbee-john@gmail.com	$2a$08$h3S2Ww7pQ8zEmgZyKHyod.M1mZdixFlmufztWJylNRnAmnxfgatHe	email	\N	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTQsInJvbGUiOiJyaWRlciIsImlhdCI6MTYxNTk2MTU3NSwiZXhwIjoxNjE2MDQ3OTc1fQ.1brYqg0RAs3OoHD6svv3ciuxdkD9BW8i29MHfHXYczY	rider	09567543906	0	t	2021-03-17 05:56:17.925+00	2021-03-17 06:12:55.081+00
18	Joed	letsbee-joed@gmail.com	$2a$08$/KTHaqeNYaMXuEoE1OP5B.LusrO9Svx553WR0FlTmVQu39z4nf9dK	email	\N	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTgsInJvbGUiOiJyaWRlciIsImlhdCI6MTYxNTk2MTYzMCwiZXhwIjoxNjE2MDQ4MDMwfQ.FpuwzWpI3HUU2MBmVQD_Wz3pSmT6apOS3DuBZhwG3e0	rider	09567543906	0	t	2021-03-17 05:56:18.047+00	2021-03-17 06:13:50.183+00
19	Aldrin Manalo	letsbee-aldrin@gmail.com	$2a$08$B7uIpNc3WyJclRU8Kmn65e6xA4uZhsFPaJj9i63xLinOjkB/tyq7a	email	\N	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTksInJvbGUiOiJyaWRlciIsImlhdCI6MTYxNTk2Mjk4MiwiZXhwIjoxNjE2MDQ5MzgyfQ.su_a9o0jm1kCbzF057Z2nC1aJHm4KTKkgieesX972K8	rider	09567543906	0	t	2021-03-17 05:56:18.075+00	2021-03-17 06:36:22.089+00
17	Nicolo Dizon	letsbee-nicolo@gmail.com	$2a$08$JOdpPBU0k3.eJV2.yBtOZOeGKbuhUGGzLI9T1IseraQV2ejD18bvG	email	\N	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTcsInJvbGUiOiJyaWRlciIsImlhdCI6MTYxNTk2MTc3MywiZXhwIjoxNjE2MDQ4MTczfQ.DG2GC3DXz9ul3cslbffwPxcy_gdWD3jNhRclZWmJQvg	rider	09567543906	0	t	2021-03-17 05:56:18.018+00	2021-03-17 06:16:13.736+00
3	Blooming Angel Cafe & Bakery	bloming-angel-cafe@gmail.com	$2a$08$yISv5FWM96xWx0HeWXHG/O1Zn9zz70TT22XfL8RDbN4DxF.GyJgFa	email	\N	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Mywicm9sZSI6InBhcnRuZXIiLCJpYXQiOjE2MTU5NjE5MDksImV4cCI6MTYxNjA0ODMwOX0.ZxIF-XqGlyFJ5PFVVjqtvbDL2kYUWFSJbKWsyHueHsg	partner	09567543906	0	t	2021-03-17 05:56:17.084+00	2021-03-17 06:18:29.412+00
7	One Mart	one-mart@gmail.com	$2a$08$g/j75oo3R7tvCsJFpQWDUOvOgV8zxNnBgqjRFab.7icrxrL32mOq6	email	\N	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Nywicm9sZSI6InBhcnRuZXIiLCJpYXQiOjE2MTU5NjE5MTIsImV4cCI6MTYxNjA0ODMxMn0.IpiSbCOrFH2BEo3xnmicwyKAxn8PZlnsJ6P7fA51QAE	partner	09567543906	0	t	2021-03-17 05:56:17.301+00	2021-03-17 06:18:32.055+00
8	Seven Eleven	seven-eleven@gmail.com	$2a$08$hhXbqLtU0T6LEQF34KVubu8xU46O2l4pB3AIB.AbTr0.X30FR3ClC	email	\N	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6OCwicm9sZSI6InBhcnRuZXIiLCJpYXQiOjE2MTU5NjE5NzUsImV4cCI6MTYxNjA0ODM3NX0.gOvXZadx-9ayhk2BBhI-4-QIlq6tp6ofj5gWnwyUJA4	partner	09567543906	0	t	2021-03-17 05:56:17.346+00	2021-03-17 06:19:35.298+00
5	RaRa Kitchen	rara-chicken@gmail.com	$2a$08$z3RutgrvjFe01k7PZGpzUuGxKUVurYHBbToaxy/6xFQUpglSpmU5u	email	\N	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwicm9sZSI6InBhcnRuZXIiLCJpYXQiOjE2MTU5NzAyNjYsImV4cCI6MTYxNjA1NjY2Nn0.oHfkPpGnjov1Fkx88cIyb-rmdzuyLemRQubtpx4oyAw	partner	09567543906	0	t	2021-03-17 05:56:17.207+00	2021-03-17 08:37:46.941+00
26	Gervene Lets Bee	letsbee-gervene@gmail.com	$2a$08$Sm22921Km/5iMt7vItKgY.cy1pq1AzO3peYkZqXBqNDPEPq.kMlqC	email	\N	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjYsInJvbGUiOiJjdXN0b21lciIsImlhdCI6MTYxNTk2MzQyNSwiZXhwIjoxNjE2MDQ5ODI1fQ.YZsj_rpUk6ps9U2nezOwhlzWceEEYa_lWL6b8eilgJM	customer	09567543905	1	t	2021-03-17 05:56:18.271+00	2021-03-17 06:43:45.129+00
31	FRANCE	franceadriansiopongco@gmail.com	\N	google	eyJhbGciOiJSUzI1NiIsImtpZCI6Ijg0NjJhNzFkYTRmNmQ2MTFmYzBmZWNmMGZjNGJhOWMzN2Q2NWU2Y2QiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI1ODQ5ODU4NTA2MzAtNzFuNGMwZWswYWdscjE5aWduYXQ0b2Rncm1qcjN0YWkuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI1ODQ5ODU4NTA2MzAtNzFuNGMwZWswYWdscjE5aWduYXQ0b2Rncm1qcjN0YWkuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMDQ4MDYzMDk4ODk2NTUwMjkzODMiLCJlbWFpbCI6ImZyYW5jZWFkcmlhbnNpb3Bvbmdjb0BnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiYXRfaGFzaCI6ImVrWGxhb0RpcFZBMExSSWlYZVlmQWciLCJub25jZSI6IlJ0am1wNVdGcmdiU0x4SUZZRTJreDJJXzBzWmtaQlFYVnJrS1R2ZVBxc0EiLCJuYW1lIjoiRlJBTkNFIiwicGljdHVyZSI6Imh0dHBzOi8vbGgzLmdvb2dsZXVzZXJjb250ZW50LmNvbS9hLS9BT2gxNEdpaHhrcEpaaFBDSVRTUkNSWXJwck5QOFF3X05kU0RoclY1M2lESGdRPXM5Ni1jIiwiZ2l2ZW5fbmFtZSI6IkZSQU5DRSIsImxvY2FsZSI6ImVuIiwiaWF0IjoxNjE1OTYxNDcxLCJleHAiOjE2MTU5NjUwNzF9.jDFa5Yvgmm_HSfwP8ysneYyVYJTd2srBcDx5P2HwiN6hf8OuYgn9Ok1erTWOy-WRk-xfvKdt8Asbf_3OdHFATWneQoYKHKO9mCFv4fdIagPdOVL7p681ZBsDCoOX32Cj7vygaq8eSymnyBR7E7GOhgRqkKbA7Y15H6V_xwOubFbDp3cm9I4gY-CB4PVZJSVFwIiktVs4BHD_UWRE8YPPhMrBPLtWKy_Jgzd3j5nCY593B2eibcCM2kJbalWB3PPVZrAhRs-aMKcA3AzYU8esHL4dreHl56Tu79R31IAqiI6s2pqNiUHjj0Lkh-A9ySJgq9P1idX9binY_rDvBK0mtA	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MzEsInJvbGUiOiJjdXN0b21lciIsImlhdCI6MTYxNTk3MDQxMCwiZXhwIjoxNjE2MDU2ODEwfQ.lQolPH83sqBiYkV1C_dRgfAwLC2Sg3s8QOxhBUT4PS4	customer	09774483946	1	t	2021-03-17 06:11:29.559+00	2021-03-17 08:40:10.942+00
23	Dave Dawne	letsbee-dave@gmail.com	$2a$08$ieW.NYoQzhwrEwu4ZecPRuqjRgcDec1yhOvc0wmYKlbbnnzN/BOje	email	\N	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjMsInJvbGUiOiJyaWRlciIsImlhdCI6MTYxNTk2MTU5MCwiZXhwIjoxNjE2MDQ3OTkwfQ.04rnUfTWgYnzVb6Ug5NGP92siEY5r4odYqBcypC35fI	rider	09567543906	0	t	2021-03-17 05:56:18.195+00	2021-03-17 06:13:10.482+00
32	Aldrin Cunanan	letsbeedevaldrin@gmail.com	\N	google	eyJhbGciOiJSUzI1NiIsImtpZCI6Ijg0NjJhNzFkYTRmNmQ2MTFmYzBmZWNmMGZjNGJhOWMzN2Q2NWU2Y2QiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI1ODQ5ODU4NTA2MzAtNzloMG5pZWJpY3RianZxdGZiOHFnZ2h1YXIxajRkYzYuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI1ODQ5ODU4NTA2MzAtM280ZmxscDMyMTMzYzJlM3U0MHVnaGhidXJvbTV0aGIuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTA5NzM1NDAyNDM0MjI3MjgxOTAiLCJlbWFpbCI6ImxldHNiZWVkZXZhbGRyaW5AZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsIm5hbWUiOiJBbGRyaW4gQ3VuYW5hbiIsInBpY3R1cmUiOiJodHRwczovL2xoNC5nb29nbGV1c2VyY29udGVudC5jb20vLTE0Y01qZEhXY1JBL0FBQUFBQUFBQUFJL0FBQUFBQUFBQUFBL0FNWnV1Y242NzZqSTFwaGc2b2ZrSUZXd2xJbDhacjhlQlEvczk2LWMvcGhvdG8uanBnIiwiZ2l2ZW5fbmFtZSI6IkFsZHJpbiIsImZhbWlseV9uYW1lIjoiQ3VuYW5hbiIsImxvY2FsZSI6ImVuIiwiaWF0IjoxNjE1OTYxNzE4LCJleHAiOjE2MTU5NjUzMTh9.XF34QAQ1o3xdx-o0fsOefTDhG4eoWpbMWMC6u_7GeAvbDz-nzcP_l91_Njaet5d2yBns-8M8Xc1HeCyt6IFYOu2f9z20BsD41LQboeEInAjPEOWkhKg2m_DXUH1A8PYsXzLsljxGSjR4Ly3PXnemte5sp9tsB95YbqHZb-g7mI5IoXd1y73BjII2B9-HUoRFJ5TYDTghT0pAZL3QDtllPKPqubqK1v9x-Ax5z5s8-hLe4m4f5hv1qt-4poNNYzSa87-OOZIxa1bm6LZ-s2pi5HtxE6Xs2826b8bgVIse9X72jlNZDWVzyl974dJUNDnd3Bzcf3N8xpf-EmWK-YaUoQ	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MzIsInJvbGUiOiJjdXN0b21lciIsImlhdCI6MTYxNTk3MDMzNCwiZXhwIjoxNjE2MDU2NzM0fQ.9-5oD3iv81tAjkiB2bYJ2f6iimX17BvbzD0AR_DWddc	customer	09173061651	1	t	2021-03-17 06:15:20.768+00	2021-03-17 08:38:54.569+00
29	Abner baluyut	baluyutabner@gmail.com	\N	google	eyJhbGciOiJSUzI1NiIsImtpZCI6Ijg0NjJhNzFkYTRmNmQ2MTFmYzBmZWNmMGZjNGJhOWMzN2Q2NWU2Y2QiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI1ODQ5ODU4NTA2MzAtNzloMG5pZWJpY3RianZxdGZiOHFnZ2h1YXIxajRkYzYuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI1ODQ5ODU4NTA2MzAtM280ZmxscDMyMTMzYzJlM3U0MHVnaGhidXJvbTV0aGIuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTc1MzU3NjA2OTg5NDczOTczMjIiLCJlbWFpbCI6ImJhbHV5dXRhYm5lckBnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwibmFtZSI6IkFibmVyIGJhbHV5dXQiLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EtL0FPaDE0R2dFNHR0cTYwNkl6Nnh4dnVaMDUyYXlfM2xGX2xWQnNrUjh0dlBtN1E9czk2LWMiLCJnaXZlbl9uYW1lIjoiQWJuZXIiLCJmYW1pbHlfbmFtZSI6ImJhbHV5dXQiLCJsb2NhbGUiOiJlbiIsImlhdCI6MTYxNTk2MDI2MCwiZXhwIjoxNjE1OTYzODYwfQ.vwrqImNC2DFbINJBlnlEtRWGOE8C7wZ1NCdD-SNQgDITIs0QCP6QWTKV1DRW_NNsAbGYZODuX_RkcQiKtfHv4S2DEcyzHvOf0gMt7dVUx6IcT8c8pod-7nsXaDzzjaK3bd_dhgPbQxWa1Nhormv4aGqv3gBZ4zrkI-qsM-tVVjR2gnKBVxJb-ndmPiBsK2cAh1803zQNP3k2Tqzj3G37tnF9G0bneoN4ar-6Xw7u11osmQooJ1kICus8L1VE3IV8pPTR5BHaoET0F3cT1Q0gssshHnYAEzUuxThhHLwk3fk0GphM4UreU-cfUEKdG7t2Q2CR6cufzuXD-CDGyV3C1w	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjksInJvbGUiOiJjdXN0b21lciIsImlhdCI6MTYxNTk3MDQ0MiwiZXhwIjoxNjE2MDU2ODQyfQ.8MvK8IgAyZh5haK-rSwKeyy9y3N_2MMlPRgRFzHNrWQ	customer	09283350416	1	t	2021-03-17 05:57:45.35+00	2021-03-17 08:40:42.232+00
30	Lets Bee Dev Chai	letsbeedevchai@gmail.com	\N	google	eyJhbGciOiJSUzI1NiIsImtpZCI6Ijg0NjJhNzFkYTRmNmQ2MTFmYzBmZWNmMGZjNGJhOWMzN2Q2NWU2Y2QiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI1ODQ5ODU4NTA2MzAtNzFuNGMwZWswYWdscjE5aWduYXQ0b2Rncm1qcjN0YWkuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI1ODQ5ODU4NTA2MzAtNzFuNGMwZWswYWdscjE5aWduYXQ0b2Rncm1qcjN0YWkuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMDM3NTU1OTg1MjA4NTM3NzExODMiLCJlbWFpbCI6ImxldHNiZWVkZXZjaGFpQGdtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJhdF9oYXNoIjoicEU2UHV2YzltbVF4Q1R6N0pnLWpWZyIsIm5vbmNlIjoiMVI0R2h2cm94SEpYeWlsOGQxUUdPNEEwdXJzMXBMS0RNdnhFbGt6eUdsVSIsIm5hbWUiOiJDaGFpcm9mZXIgQ3J1eiIsInBpY3R1cmUiOiJodHRwczovL2xoNC5nb29nbGV1c2VyY29udGVudC5jb20vLTZWVXFyTTVUOTNZL0FBQUFBQUFBQUFJL0FBQUFBQUFBQUFBL0FNWnV1Y240Z0ZYVFJUQXdxNGFKME9YT2FqdDZWeWExdkEvczk2LWMvcGhvdG8uanBnIiwiZ2l2ZW5fbmFtZSI6IkNoYWlyb2ZlciIsImZhbWlseV9uYW1lIjoiQ3J1eiIsImxvY2FsZSI6ImVuIiwiaWF0IjoxNjE1OTYwOTQ3LCJleHAiOjE2MTU5NjQ1NDd9.BYWwFKJDm-CzWVJw5SjqZarqBnLIM0212xJ8XZnhbJTVrius6FH658RrxrY-4WQupdRNbcY5i85zCo7nMcjNganeD86O3t-UA7ptN7GNVeNUhH1IXwJ_wdPFA3gidPUBv9ZSws9-wuovKnMsWSUAivnHIP_WkcyhZzAd_vT8RPx624OEqt7Bg0_BzmlrATPlhinZYu0xOzo-PwaTFYqe9UQ6GtFVMR3QVWn8YJPdNVJiYQf4hUQyqf9AP7smlb4z7cfdDQH0CBvtF5u9F_4c-WTwzOHCPSwk13X0MthmCO2-Tc171U4Vxd406tMSG1_3_Ll45Y0fV_Qz0fPVLBfy4g	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MzAsInJvbGUiOiJjdXN0b21lciIsImlhdCI6MTYxNTk2Njk2MiwiZXhwIjoxNjE2MDUzMzYyfQ.-QGbD2PEJ7K-H1WAMtFr1MKNKYyjOrr-6aI2Be0hPkw	customer	09267840749	1	t	2021-03-17 06:02:27.369+00	2021-03-17 07:42:42.736+00
33	luis2	luis.jang@gmail.com	\N	google	eyJhbGciOiJSUzI1NiIsImtpZCI6Ijg0NjJhNzFkYTRmNmQ2MTFmYzBmZWNmMGZjNGJhOWMzN2Q2NWU2Y2QiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI1ODQ5ODU4NTA2MzAtNzloMG5pZWJpY3RianZxdGZiOHFnZ2h1YXIxajRkYzYuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI1ODQ5ODU4NTA2MzAtM280ZmxscDMyMTMzYzJlM3U0MHVnaGhidXJvbTV0aGIuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTA1NzU0NzA5NDQ4MDM0NzE1OTYiLCJlbWFpbCI6Imx1aXMuamFuZ0BnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwibmFtZSI6Ikx1aXMgSmFuZyIsInBpY3R1cmUiOiJodHRwczovL2xoNS5nb29nbGV1c2VyY29udGVudC5jb20vLUJRMnBvckkycFJVL0FBQUFBQUFBQUFJL0FBQUFBQUFBQUFBL0FNWnV1Y2wtQkcySHMtOFNvQ1dnSEdRY25NcTRRTVZIY1Evczk2LWMvcGhvdG8uanBnIiwiZ2l2ZW5fbmFtZSI6Ikx1aXMiLCJmYW1pbHlfbmFtZSI6IkphbmciLCJsb2NhbGUiOiJlbiIsImlhdCI6MTYxNTk2OTUxMywiZXhwIjoxNjE1OTczMTEzfQ.C6hV2jb8I3lSxW5BeEN3PQMmJK_JQF3zVlC-dJ3MEKVbSeGwJ4Se3Q03cnkdNxQg-rKATJ7MqfPUDGTeww6toR_WmK85olVV7yE0vQk3wD1CC2fgaqoMrcNyaXOkQYMBZBj38EzOrAe362KCkg8nxXzFfG5hr4mdiT4h7kz_rgsoHJ_h8-QSlqjUZU4xrIVksJ2ydEIQ2PIYbo5ZU7NKQr4Q31L6nIJdI9PBFO4LLRCE5IKTQ54IFc2g_rHOmbXUnkrIzpkZdU-bYP4SWE5S1BN9txHDxZHBPei2mHMBawfU9hVs-VpsoGc_LjCg0-j0MhTx8FPc2USe7eKsTdAuzw	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MzMsInJvbGUiOiJjdXN0b21lciIsImlhdCI6MTYxNTk2OTU1OCwiZXhwIjoxNjE2MDU1OTU4fQ.kmB61wb51-b9v6eKt_1ma0AEXV1cvUZzWWU3mNw67ts	customer	09162118647	1	t	2021-03-17 08:25:15.571+00	2021-03-17 08:25:58.571+00
\.


                3261.dat                                                                                            0000600 0004000 0002000 00000012511 14024343251 0014243 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        2	1	Coke Zero	0	0	0	t	2021-03-17 05:56:16.977+00	2021-03-17 05:56:16.977+00
1	1	Coke	0	0	0	t	2021-03-17 05:56:16.977+00	2021-03-17 05:56:16.977+00
3	1	Sprite	0	0	0	t	2021-03-17 05:56:16.977+00	2021-03-17 05:56:16.977+00
4	1	Pineapple juice	15	15.00	13.95	t	2021-03-17 05:56:16.978+00	2021-03-17 05:56:16.978+00
5	2	Sausage	0	0	0	t	2021-03-17 05:56:16.992+00	2021-03-17 05:56:16.992+00
6	2	Beef	20	20.00	18.60	t	2021-03-17 05:56:16.993+00	2021-03-17 05:56:16.993+00
7	2	Pork	10	10.00	9.30	t	2021-03-17 05:56:16.993+00	2021-03-17 05:56:16.993+00
8	3	a	0	0	0	t	2021-03-17 05:56:17.006+00	2021-03-17 05:56:17.006+00
9	3	b	20	20.00	18.60	t	2021-03-17 05:56:17.007+00	2021-03-17 05:56:17.007+00
10	3	c	20	20.00	18.60	t	2021-03-17 05:56:17.007+00	2021-03-17 05:56:17.007+00
11	4	a	0	0	0	t	2021-03-17 05:56:17.022+00	2021-03-17 05:56:17.022+00
12	4	b	0	0	0	t	2021-03-17 05:56:17.022+00	2021-03-17 05:56:17.022+00
13	4	c	0	0	0	t	2021-03-17 05:56:17.022+00	2021-03-17 05:56:17.022+00
14	5	Regular	0	0	0	t	2021-03-17 05:56:17.099+00	2021-03-17 05:56:17.099+00
15	5	Medium	20	21.40	20.00	t	2021-03-17 05:56:17.099+00	2021-03-17 05:56:17.099+00
16	5	Large	30	32.10	30.00	t	2021-03-17 05:56:17.1+00	2021-03-17 05:56:17.1+00
17	6	Regular	0	0	0	t	2021-03-17 05:56:17.161+00	2021-03-17 05:56:17.161+00
18	6	Medium	20	20.00	18.60	t	2021-03-17 05:56:17.161+00	2021-03-17 05:56:17.161+00
19	6	Large	30	30.00	27.90	t	2021-03-17 05:56:17.161+00	2021-03-17 05:56:17.161+00
20	7	Regular	0	0	0	t	2021-03-17 05:56:17.217+00	2021-03-17 05:56:17.217+00
21	7	Medium	50	50.00	46.50	t	2021-03-17 05:56:17.217+00	2021-03-17 05:56:17.217+00
22	7	Large	100	100.00	93.00	t	2021-03-17 05:56:17.217+00	2021-03-17 05:56:17.217+00
23	8	Coke	0	0	0	t	2021-03-17 05:56:17.408+00	2021-03-17 05:56:17.408+00
24	8	Coke Zero	0	0	0	t	2021-03-17 05:56:17.408+00	2021-03-17 05:56:17.408+00
25	8	Sprite	0	0	0	t	2021-03-17 05:56:17.408+00	2021-03-17 05:56:17.408+00
26	8	Pineapple juice	15	15.00	13.95	t	2021-03-17 05:56:17.409+00	2021-03-17 05:56:17.409+00
27	9	a	0	0	0	t	2021-03-17 05:56:17.423+00	2021-03-17 05:56:17.423+00
28	9	b	20	20.00	18.60	t	2021-03-17 05:56:17.423+00	2021-03-17 05:56:17.423+00
29	9	c	20	20.00	18.60	t	2021-03-17 05:56:17.423+00	2021-03-17 05:56:17.423+00
30	10	a	0	0	0	t	2021-03-17 05:56:17.434+00	2021-03-17 05:56:17.434+00
31	10	b	0	0	0	t	2021-03-17 05:56:17.434+00	2021-03-17 05:56:17.434+00
32	10	c	0	0	0	t	2021-03-17 05:56:17.435+00	2021-03-17 05:56:17.435+00
33	11	Coke	0	0	0	t	2021-03-17 05:56:17.504+00	2021-03-17 05:56:17.504+00
34	11	Coke Zero	0	0	0	t	2021-03-17 05:56:17.504+00	2021-03-17 05:56:17.504+00
35	11	Sprite	0	0	0	t	2021-03-17 05:56:17.504+00	2021-03-17 05:56:17.504+00
36	11	Pineapple juice	15	15.00	13.95	t	2021-03-17 05:56:17.505+00	2021-03-17 05:56:17.505+00
37	12	a	0	0	0	t	2021-03-17 05:56:17.52+00	2021-03-17 05:56:17.52+00
38	12	b	20	20.00	18.60	t	2021-03-17 05:56:17.521+00	2021-03-17 05:56:17.521+00
39	12	c	20	20.00	18.60	t	2021-03-17 05:56:17.521+00	2021-03-17 05:56:17.521+00
40	13	a	0	0	0	t	2021-03-17 05:56:17.531+00	2021-03-17 05:56:17.531+00
41	13	b	0	0	0	t	2021-03-17 05:56:17.531+00	2021-03-17 05:56:17.531+00
42	13	c	0	0	0	t	2021-03-17 05:56:17.532+00	2021-03-17 05:56:17.532+00
43	14	Coke	0	0	0	t	2021-03-17 05:56:17.596+00	2021-03-17 05:56:17.596+00
44	14	Coke Zero	0	0	0	t	2021-03-17 05:56:17.596+00	2021-03-17 05:56:17.596+00
45	14	Sprite	0	0	0	t	2021-03-17 05:56:17.596+00	2021-03-17 05:56:17.596+00
46	14	Pineapple juice	15	15.00	13.95	t	2021-03-17 05:56:17.596+00	2021-03-17 05:56:17.596+00
47	15	a	0	0	0	t	2021-03-17 05:56:17.608+00	2021-03-17 05:56:17.608+00
48	15	b	20	20.00	18.60	t	2021-03-17 05:56:17.608+00	2021-03-17 05:56:17.608+00
49	15	c	20	20.00	18.60	t	2021-03-17 05:56:17.609+00	2021-03-17 05:56:17.609+00
50	16	a	0	0	0	t	2021-03-17 05:56:17.62+00	2021-03-17 05:56:17.62+00
51	16	b	0	0	0	t	2021-03-17 05:56:17.62+00	2021-03-17 05:56:17.62+00
52	16	c	0	0	0	t	2021-03-17 05:56:17.62+00	2021-03-17 05:56:17.62+00
53	17	Coke	0	0	0	t	2021-03-17 05:56:17.72+00	2021-03-17 05:56:17.72+00
54	17	Coke Zero	0	0	0	t	2021-03-17 05:56:17.72+00	2021-03-17 05:56:17.72+00
55	17	Sprite	0	0	0	t	2021-03-17 05:56:17.72+00	2021-03-17 05:56:17.72+00
56	17	Pineapple juice	15	15.00	13.95	t	2021-03-17 05:56:17.72+00	2021-03-17 05:56:17.72+00
57	18	a	0	0	0	t	2021-03-17 05:56:17.736+00	2021-03-17 05:56:17.736+00
58	18	b	20	20.00	18.60	t	2021-03-17 05:56:17.736+00	2021-03-17 05:56:17.736+00
59	18	c	20	20.00	18.60	t	2021-03-17 05:56:17.737+00	2021-03-17 05:56:17.737+00
60	19	a	0	0	0	t	2021-03-17 05:56:17.748+00	2021-03-17 05:56:17.748+00
61	19	b	0	0	0	t	2021-03-17 05:56:17.748+00	2021-03-17 05:56:17.748+00
62	19	c	0	0	0	t	2021-03-17 05:56:17.748+00	2021-03-17 05:56:17.748+00
63	20	Coke	0	0	0	t	2021-03-17 05:56:17.828+00	2021-03-17 05:56:17.828+00
64	20	Coke Zero	0	0	0	t	2021-03-17 05:56:17.829+00	2021-03-17 05:56:17.829+00
65	20	Sprite	0	0	0	t	2021-03-17 05:56:17.829+00	2021-03-17 05:56:17.829+00
66	20	Pineapple juice	15	15.00	13.95	t	2021-03-17 05:56:17.829+00	2021-03-17 05:56:17.829+00
67	21	a	0	0	0	t	2021-03-17 05:56:17.85+00	2021-03-17 05:56:17.85+00
68	21	b	20	20.00	18.60	t	2021-03-17 05:56:17.85+00	2021-03-17 05:56:17.85+00
69	21	c	20	20.00	18.60	t	2021-03-17 05:56:17.85+00	2021-03-17 05:56:17.85+00
70	22	a	0	0	0	t	2021-03-17 05:56:17.86+00	2021-03-17 05:56:17.86+00
71	22	b	0	0	0	t	2021-03-17 05:56:17.86+00	2021-03-17 05:56:17.86+00
72	22	c	0	0	0	t	2021-03-17 05:56:17.861+00	2021-03-17 05:56:17.861+00
\.


                                                                                                                                                                                       3259.dat                                                                                            0000600 0004000 0002000 00000003135 14024343251 0014254 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	1	Choice of Drinks	t	2021-03-17 05:56:16.972+00	2021-03-17 05:56:16.972+00
2	1	Choice of Meat	t	2021-03-17 05:56:16.988+00	2021-03-17 05:56:16.988+00
3	1	Choice A	t	2021-03-17 05:56:17.001+00	2021-03-17 05:56:17.001+00
4	1	Choice B	t	2021-03-17 05:56:17.018+00	2021-03-17 05:56:17.018+00
5	2	Choice of Drink Size	t	2021-03-17 05:56:17.095+00	2021-03-17 05:56:17.095+00
6	3	Choice of Drink Size	t	2021-03-17 05:56:17.158+00	2021-03-17 05:56:17.158+00
7	4	Choice of Size	t	2021-03-17 05:56:17.214+00	2021-03-17 05:56:17.214+00
8	8	Choice of Drinks	t	2021-03-17 05:56:17.405+00	2021-03-17 05:56:17.405+00
9	8	Choice A	t	2021-03-17 05:56:17.419+00	2021-03-17 05:56:17.419+00
10	8	Choice B	t	2021-03-17 05:56:17.431+00	2021-03-17 05:56:17.431+00
11	9	Choice of Drinks	t	2021-03-17 05:56:17.499+00	2021-03-17 05:56:17.499+00
12	9	Choice A	t	2021-03-17 05:56:17.516+00	2021-03-17 05:56:17.516+00
13	9	Choice B	t	2021-03-17 05:56:17.528+00	2021-03-17 05:56:17.528+00
14	10	Choice of Drinks	t	2021-03-17 05:56:17.593+00	2021-03-17 05:56:17.593+00
15	10	Choice A	t	2021-03-17 05:56:17.605+00	2021-03-17 05:56:17.605+00
16	10	Choice B	t	2021-03-17 05:56:17.617+00	2021-03-17 05:56:17.617+00
17	11	Choice of Drinks	t	2021-03-17 05:56:17.715+00	2021-03-17 05:56:17.715+00
18	11	Choice A	t	2021-03-17 05:56:17.733+00	2021-03-17 05:56:17.733+00
19	11	Choice B	t	2021-03-17 05:56:17.744+00	2021-03-17 05:56:17.744+00
20	12	Choice of Drinks	t	2021-03-17 05:56:17.823+00	2021-03-17 05:56:17.823+00
21	12	Choice A	t	2021-03-17 05:56:17.847+00	2021-03-17 05:56:17.847+00
22	12	Choice B	t	2021-03-17 05:56:17.857+00	2021-03-17 05:56:17.857+00
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                   restore.sql                                                                                         0000600 0004000 0002000 00000561601 14024343251 0015373 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        --
-- NOTE:
--
-- File paths need to be edited. Search for $$PATH$$ and
-- replace it with the path to the directory containing
-- the extracted data files.
--
--
-- PostgreSQL database dump
--

-- Dumped from database version 13.2 (Ubuntu 13.2-1.pgdg20.04+1)
-- Dumped by pg_dump version 13.2 (Ubuntu 13.2-1.pgdg20.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE lets_bee;
--
-- Name: lets_bee; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE lets_bee WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'C.UTF-8';


ALTER DATABASE lets_bee OWNER TO postgres;

\connect lets_bee

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: enum_carts_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_carts_status AS ENUM (
    'active',
    'ordered',
    'changed',
    'removed'
);


ALTER TYPE public.enum_carts_status OWNER TO postgres;

--
-- Name: enum_orders_contract_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_orders_contract_type AS ENUM (
    'commission',
    'markup',
    'half'
);


ALTER TYPE public.enum_orders_contract_type OWNER TO postgres;

--
-- Name: enum_orders_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_orders_status AS ENUM (
    'processing',
    'pending',
    'store-accepted',
    'store-declined',
    'rider-accepted',
    'rider-picked-up',
    'delivered',
    'cancelled'
);


ALTER TYPE public.enum_orders_status OWNER TO postgres;

--
-- Name: enum_store_applications_business_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_store_applications_business_type AS ENUM (
    'mart',
    'restaurant'
);


ALTER TYPE public.enum_store_applications_business_type OWNER TO postgres;

--
-- Name: enum_store_applications_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_store_applications_status AS ENUM (
    'approved',
    'pending',
    'rejected',
    'on-hold'
);


ALTER TYPE public.enum_store_applications_status OWNER TO postgres;

--
-- Name: enum_store_products_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_store_products_status AS ENUM (
    'available',
    'unavailable',
    'out-of-stock'
);


ALTER TYPE public.enum_store_products_status OWNER TO postgres;

--
-- Name: enum_stores_contract_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_stores_contract_type AS ENUM (
    'commission',
    'markup',
    'half'
);


ALTER TYPE public.enum_stores_contract_type OWNER TO postgres;

--
-- Name: enum_stores_stature; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_stores_stature AS ENUM (
    'temporary-close',
    'closed',
    'suspended',
    'open'
);


ALTER TYPE public.enum_stores_stature OWNER TO postgres;

--
-- Name: enum_stores_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_stores_status AS ENUM (
    'active',
    'deactivated',
    'pending'
);


ALTER TYPE public.enum_stores_status OWNER TO postgres;

--
-- Name: enum_stores_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_stores_type AS ENUM (
    'restaurant',
    'mart'
);


ALTER TYPE public.enum_stores_type OWNER TO postgres;

--
-- Name: enum_users_provider; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_users_provider AS ENUM (
    'email',
    'facebook',
    'google',
    'kakao'
);


ALTER TYPE public.enum_users_provider OWNER TO postgres;

--
-- Name: enum_users_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_users_role AS ENUM (
    'customer',
    'partner',
    'rider',
    'admin',
    'super-admin'
);


ALTER TYPE public.enum_users_role OWNER TO postgres;

--
-- Name: create_addon(integer, character varying, numeric, numeric, numeric); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_addon(p_user_id integer, p_name character varying, p_price numeric, p_customer_price numeric, p_seller_price numeric) RETURNS TABLE(id integer, status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_addon_id INT := 0;
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Additional successfully created!';
BEGIN
  IF EXISTS (
    SELECT
      ao.id
    FROM public.additionals AS ao
    INNER JOIN public.stores AS s
      ON ao.store_id = s.id
    WHERE
      s.user_id = p_user_id
    AND
      ao.name = p_name
  ) THEN
    v_status := 'warning';
    v_message := CONCAT(p_name, ' already exists!');
    RETURN QUERY SELECT v_addon_id, v_status, v_message;
    RETURN;

  END IF;

  INSERT INTO public.additionals (
    store_id,
    "name",
    price,
    customer_price,
    seller_price,
    "status",
    "createdAt",
    "updatedAt"
  )
  SELECT
    s.id,
    p_name,
    p_price,
    p_customer_price,
    p_seller_price,
    true,
    now(),
    now()
  FROM public.stores AS s
  WHERE s.user_id = p_user_id
  RETURNING public.additionals.id INTO v_addon_id;

  RETURN QUERY
  SELECT v_addon_id, v_status, v_message;
END;
$$;


ALTER FUNCTION public.create_addon(p_user_id integer, p_name character varying, p_price numeric, p_customer_price numeric, p_seller_price numeric) OWNER TO postgres;

--
-- Name: create_mart(character varying, character varying, character varying, character varying, character varying, character varying, numeric, numeric, character varying, public.enum_stores_contract_type, character varying, character varying, character varying, character varying, character varying, text, text, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_mart(p_user_name character varying, p_email character varying, p_password character varying, p_cellphone_number character varying, p_store_name character varying, p_description character varying, p_latitude numeric, p_longitude numeric, p_location_name character varying, p_contract_type public.enum_stores_contract_type, p_category character varying, p_country character varying, p_state character varying, p_city character varying, p_barangay character varying, p_logo_url text, p_photo_url text, p_sunday boolean, p_sunday_opening_time time without time zone, p_sunday_closing_time time without time zone, p_monday boolean, p_monday_opening_time time without time zone, p_monday_closing_time time without time zone, p_tuesday boolean, p_tuesday_opening_time time without time zone, p_tuesday_closing_time time without time zone, p_wednesday boolean, p_wednesday_opening_time time without time zone, p_wednesday_closing_time time without time zone, p_thursday boolean, p_thursday_opening_time time without time zone, p_thursday_closing_time time without time zone, p_friday boolean, p_friday_opening_time time without time zone, p_friday_closing_time time without time zone, p_saturday boolean, p_saturday_opening_time time without time zone, p_saturday_closing_time time without time zone) RETURNS TABLE(mart_id integer, user_id integer, status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_mart_id INT := 0;
  v_user_id INT := 0;
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Mart successfully created!';
BEGIN
  IF EXISTS(SELECT 1 FROM public.users AS u WHERE u.email = p_email) THEN
    v_status := 'warning';
    v_message := 'The email address you entered for this mart already exists.';
    RETURN QUERY SELECT v_mart_id, v_user_id, v_status, v_message;
    RETURN;
  END IF;

  INSERT INTO public.users (name, email, password, role, cellphone_number, "createdAt", "updatedAt")
    VALUES (p_user_name, p_email, p_password, 'partner', p_cellphone_number, now(), now())
    RETURNING public.users.id INTO v_user_id;

  INSERT INTO public.stores (user_id, name, description, latitude, longitude, location_name, type, contract_type, category, country, state, city, barangay, logo_url, photo_url, sunday, sunday_opening_time, sunday_closing_time, monday, monday_opening_time, monday_closing_time, tuesday, tuesday_opening_time, tuesday_closing_time, wednesday, wednesday_opening_time, wednesday_closing_time, thursday, thursday_opening_time, thursday_closing_time, friday, friday_opening_time, friday_closing_time, saturday, saturday_opening_time, saturday_closing_time, "createdAt", "updatedAt")
    VALUES (v_user_id, p_store_name, p_description, p_latitude, p_longitude, p_location_name, 'mart', p_contract_type, p_category, p_country, p_state, p_city, p_barangay, p_logo_url, p_photo_url, p_sunday, p_sunday_opening_time, p_sunday_closing_time, p_monday, p_monday_opening_time, p_monday_closing_time, p_tuesday, p_tuesday_opening_time, p_tuesday_closing_time, p_wednesday, p_wednesday_opening_time, p_wednesday_closing_time, p_thursday, p_thursday_opening_time, p_thursday_closing_time, p_friday, p_friday_opening_time, p_friday_closing_time, p_saturday, p_saturday_opening_time, p_saturday_closing_time, now(), now());
  
  RETURN QUERY
    SELECT v_mart_id, v_user_id, v_status, v_message;
END;
$$;


ALTER FUNCTION public.create_mart(p_user_name character varying, p_email character varying, p_password character varying, p_cellphone_number character varying, p_store_name character varying, p_description character varying, p_latitude numeric, p_longitude numeric, p_location_name character varying, p_contract_type public.enum_stores_contract_type, p_category character varying, p_country character varying, p_state character varying, p_city character varying, p_barangay character varying, p_logo_url text, p_photo_url text, p_sunday boolean, p_sunday_opening_time time without time zone, p_sunday_closing_time time without time zone, p_monday boolean, p_monday_opening_time time without time zone, p_monday_closing_time time without time zone, p_tuesday boolean, p_tuesday_opening_time time without time zone, p_tuesday_closing_time time without time zone, p_wednesday boolean, p_wednesday_opening_time time without time zone, p_wednesday_closing_time time without time zone, p_thursday boolean, p_thursday_opening_time time without time zone, p_thursday_closing_time time without time zone, p_friday boolean, p_friday_opening_time time without time zone, p_friday_closing_time time without time zone, p_saturday boolean, p_saturday_opening_time time without time zone, p_saturday_closing_time time without time zone) OWNER TO postgres;

--
-- Name: create_menu(integer, character varying, text, text, numeric, numeric, numeric, text, text, integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_menu(p_store_id integer, p_name character varying, p_description text, p_image text, p_price numeric, p_customer_price numeric, p_seller_price numeric, p_choices text, p_additionals text, p_quantity integer, p_max_order integer, p_category character varying) RETURNS TABLE(id integer, status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_menu_id INT := 0;
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Menu successfully created!';
BEGIN
  INSERT INTO public.store_products (
    store_id,
    name,
    description,
    image,
    price,
    customer_price,
    seller_price,
    choices,
    additionals,
    quantity,
    max_order,
    category,
    status,
    "createdAt",
    "updatedAt"
  ) VALUES (
    p_store_id,
    p_name,
    p_description,
    p_image,
    p_price,
    p_customer_price,
    p_seller_price,
    p_choices,
    p_additionals,
    p_quantity,
    p_max_order,
    p_category,
    'available',
    now(),
    now()
  ) RETURNING public.store_products.id INTO v_menu_id;

  RETURN QUERY
    SELECT v_menu_id, v_status, v_message;
END;
$$;


ALTER FUNCTION public.create_menu(p_store_id integer, p_name character varying, p_description text, p_image text, p_price numeric, p_customer_price numeric, p_seller_price numeric, p_choices text, p_additionals text, p_quantity integer, p_max_order integer, p_category character varying) OWNER TO postgres;

--
-- Name: create_order(integer, integer, public.enum_orders_status, text, text, text, text, public.enum_orders_contract_type, text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_order(p_store_id integer, p_user_id integer, p_status public.enum_orders_status, p_products text, p_fee text, p_address text, p_payment text, p_contract_type public.enum_orders_contract_type, p_note text DEFAULT ''::text, p_timeframe text DEFAULT NULL::text, p_reason text DEFAULT ''::text) RETURNS TABLE(order_id integer)
    LANGUAGE plpgsql
    AS $$ 
DECLARE
  v_order_id INT := 0;
  v_so_id INT := 0;
BEGIN
  SELECT COUNT(*) AS count INTO v_so_id FROM public.orders as o WHERE o.store_id = p_store_id AND o."createdAt"::date = CURRENT_DATE;

  v_so_id = v_so_id + 1;

  INSERT INTO public.orders (so_id, store_id, user_id, status, products, fee, timeframe, address, payment, contract_type, reason, note, "createdAt", "updatedAt")
    VALUES (v_so_id, p_store_id, p_user_id, p_status, p_products, p_fee, p_timeframe, p_address, p_payment, p_contract_type, p_reason, p_note, now(), now())
    RETURNING public.orders.id INTO v_order_id;

  RETURN QUERY SELECT v_order_id;
END;
$$;


ALTER FUNCTION public.create_order(p_store_id integer, p_user_id integer, p_status public.enum_orders_status, p_products text, p_fee text, p_address text, p_payment text, p_contract_type public.enum_orders_contract_type, p_note text, p_timeframe text, p_reason text) OWNER TO postgres;

--
-- Name: create_product(integer, character varying, text, text, numeric, numeric, numeric, text, text, integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_product(p_user_id integer, p_name character varying, p_description text, p_image text, p_price numeric, p_customer_price numeric, p_seller_price numeric, p_variants text, p_additionals text, p_quantity integer, p_max_order integer, p_category character varying) RETURNS TABLE(id integer, status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_product_id INT := 0;
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Product successfully created!';
BEGIN
	IF EXISTS (
		SELECT
			sp.id
		FROM public.store_products AS sp
		INNER JOIN public.stores AS s
			ON sp.store_id = s.id
		WHERE
			sp.name = p_name
		AND
			s.user_id = p_user_id
	) THEN
		v_status := 'warning';
    v_message := CONCAT(p_name, ' already exists! Please enter a different name.');
    RETURN QUERY SELECT v_product_id, v_status, v_message;
		RETURN;
	END IF;

  INSERT INTO public.store_products (
		store_id,
		name,
		description,
		image,
		price,
		customer_price,
		seller_price,
		variants,
		additionals,
		quantity,
		max_order,
		category,
		status,
		"createdAt",
		"updatedAt"
	)
	SELECT
		s.id,
		p_name,
		p_description,
		p_image,
		p_price,
		p_customer_price,
		p_seller_price,
		p_variants,
		p_additionals,
		p_quantity,
		p_max_order,
		p_category,
		'available',
		now(),
		now()
	FROM public.stores AS s
	WHERE s.user_id = p_user_id RETURNING public.store_products.id INTO v_product_id;

  RETURN QUERY
    SELECT v_product_id, v_status, v_message;
END;
$$;


ALTER FUNCTION public.create_product(p_user_id integer, p_name character varying, p_description text, p_image text, p_price numeric, p_customer_price numeric, p_seller_price numeric, p_variants text, p_additionals text, p_quantity integer, p_max_order integer, p_category character varying) OWNER TO postgres;

--
-- Name: create_restaurant(character varying, character varying, character varying, character varying, character varying, character varying, numeric, numeric, character varying, public.enum_stores_contract_type, character varying, character varying, character varying, character varying, character varying, text, text, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_restaurant(p_user_name character varying, p_email character varying, p_password character varying, p_cellphone_number character varying, p_store_name character varying, p_description character varying, p_latitude numeric, p_longitude numeric, p_location_name character varying, p_contract_type public.enum_stores_contract_type, p_category character varying, p_country character varying, p_state character varying, p_city character varying, p_barangay character varying, p_logo_url text, p_photo_url text, p_sunday boolean, p_sunday_opening_time time without time zone, p_sunday_closing_time time without time zone, p_monday boolean, p_monday_opening_time time without time zone, p_monday_closing_time time without time zone, p_tuesday boolean, p_tuesday_opening_time time without time zone, p_tuesday_closing_time time without time zone, p_wednesday boolean, p_wednesday_opening_time time without time zone, p_wednesday_closing_time time without time zone, p_thursday boolean, p_thursday_opening_time time without time zone, p_thursday_closing_time time without time zone, p_friday boolean, p_friday_opening_time time without time zone, p_friday_closing_time time without time zone, p_saturday boolean, p_saturday_opening_time time without time zone, p_saturday_closing_time time without time zone) RETURNS TABLE(restaurant_id integer, user_id integer, status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_restaurant_id INT := 0;
  v_user_id INT := 0;
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Restaurant successfully created!';
BEGIN
  IF EXISTS(SELECT 1 FROM public.users AS u WHERE u.email = p_email) THEN
    v_status := 'warning';
    v_message := 'The email address you entered for this restaurant already exists.';
    RETURN QUERY SELECT v_restaurant_id, v_user_id, v_status, v_message;
    RETURN;
  END IF;

  INSERT INTO public.users (name, email, password, role, cellphone_number, "createdAt", "updatedAt")
    VALUES (p_user_name, p_email, p_password, 'partner', p_cellphone_number, now(), now())
    RETURNING public.users.id INTO v_user_id;

  INSERT INTO public.stores (user_id, name, description, latitude, longitude, location_name, type, contract_type, category, country, state, city, barangay, logo_url, photo_url, sunday, sunday_opening_time, sunday_closing_time, monday, monday_opening_time, monday_closing_time, tuesday, tuesday_opening_time, tuesday_closing_time, wednesday, wednesday_opening_time, wednesday_closing_time, thursday, thursday_opening_time, thursday_closing_time, friday, friday_opening_time, friday_closing_time, saturday, saturday_opening_time, saturday_closing_time, "createdAt", "updatedAt")
    VALUES (v_user_id, p_store_name, p_description, p_latitude, p_longitude, p_location_name, 'restaurant', p_contract_type, p_category, p_country, p_state, p_city, p_barangay, p_logo_url, p_photo_url, p_sunday, p_sunday_opening_time, p_sunday_closing_time, p_monday, p_monday_opening_time, p_monday_closing_time, p_tuesday, p_tuesday_opening_time, p_tuesday_closing_time, p_wednesday, p_wednesday_opening_time, p_wednesday_closing_time, p_thursday, p_thursday_opening_time, p_thursday_closing_time, p_friday, p_friday_opening_time, p_friday_closing_time, p_saturday, p_saturday_opening_time, p_saturday_closing_time, now(), now());
  
  RETURN QUERY
    SELECT v_restaurant_id, v_user_id, v_status, v_message;
END;
$$;


ALTER FUNCTION public.create_restaurant(p_user_name character varying, p_email character varying, p_password character varying, p_cellphone_number character varying, p_store_name character varying, p_description character varying, p_latitude numeric, p_longitude numeric, p_location_name character varying, p_contract_type public.enum_stores_contract_type, p_category character varying, p_country character varying, p_state character varying, p_city character varying, p_barangay character varying, p_logo_url text, p_photo_url text, p_sunday boolean, p_sunday_opening_time time without time zone, p_sunday_closing_time time without time zone, p_monday boolean, p_monday_opening_time time without time zone, p_monday_closing_time time without time zone, p_tuesday boolean, p_tuesday_opening_time time without time zone, p_tuesday_closing_time time without time zone, p_wednesday boolean, p_wednesday_opening_time time without time zone, p_wednesday_closing_time time without time zone, p_thursday boolean, p_thursday_opening_time time without time zone, p_thursday_closing_time time without time zone, p_friday boolean, p_friday_opening_time time without time zone, p_friday_closing_time time without time zone, p_saturday boolean, p_saturday_opening_time time without time zone, p_saturday_closing_time time without time zone) OWNER TO postgres;

--
-- Name: create_rider(character varying, character varying, character varying, character varying, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_rider(p_name character varying, p_email character varying, p_password character varying, p_cellphone_number character varying, p_motorcycle_details text) RETURNS TABLE(id integer, status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_rider_id INT := 0;
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Rider account has been created';
BEGIN
  IF EXISTS(SELECT 1 FROM public.users AS u WHERE u.email = p_email) THEN
    v_status := 'warning';
    v_message := 'A rider with the same email address already exists';
    
    RETURN QUERY SELECT v_rider_id, v_status, v_message;
    RETURN;
  END IF;

  INSERT INTO public.users (name, email, password, cellphone_number, role, "createdAt", "updatedAt")
    VALUES (p_name, p_email, p_password, p_cellphone_number, 'rider', now(), now())
    RETURNING id INTO v_rider_id;

  INSERT INTO public.riders (user_id, motorcycle_details, "createdAt")
    VALUES (v_rider_id, p_motorcycle_details, now());
    
  RETURN QUERY
  SELECT v_rider_id, v_status, v_message;
END;
$$;


ALTER FUNCTION public.create_rider(p_name character varying, p_email character varying, p_password character varying, p_cellphone_number character varying, p_motorcycle_details text) OWNER TO postgres;

--
-- Name: create_variant(integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_variant(p_user_id integer, p_type character varying) RETURNS TABLE(id integer, status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_variant_id INT := 0;
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Variant successfully created!';
BEGIN
  IF EXISTS (
    SELECT
      v.id
    FROM public.variants AS v
    INNER JOIN public.stores AS s
      ON v.store_id = s.id
    WHERE s.user_id = p_user_id
    AND v.type = p_type
  ) THEN
    v_status := 'warning';
    v_message := CONCAT(p_type, ' already exists!');
    RETURN QUERY SELECT v_variant_id, v_status, v_message;
    RETURN;
  END IF;

  INSERT INTO public.variants (
    store_id,
    "type",
    "status",
    "createdAt",
    "updatedAt"
  )
  SELECT
    s.id,
    p_type,
    true,
    now(),
    now()
  FROM public.stores AS s
  WHERE s.user_id = p_user_id
  RETURNING public.variants.id INTO v_variant_id;

  RETURN QUERY
  SELECT v_variant_id, v_status, v_message;
END;
$$;


ALTER FUNCTION public.create_variant(p_user_id integer, p_type character varying) OWNER TO postgres;

--
-- Name: create_variant_option(integer, character varying, numeric, numeric, numeric); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_variant_option(p_variant_id integer, p_name character varying, p_price numeric, p_customer_price numeric, p_seller_price numeric) RETURNS TABLE(id integer, status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_variant_option_id INT := 0;
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Variant option successfully created!';
BEGIN
  IF EXISTS (
    SELECT
      vo.id
    FROM public.variant_options AS vo
    WHERE vo.name = p_name
    AND vo.variant_id = p_variant_id
  ) THEN
    v_status := 'warning';
    v_message := CONCAT(p_name, ' already exists! Please enter a different name');
    RETURN QUERY
      SELECT v_variant_option_id, v_status, v_message;
    RETURN;
  END IF;

  INSERT INTO public.variant_options (
    variant_id,
    "name",
    price,
    customer_price,
    seller_price,
    "status",
    "createdAt",
    "updatedAt"
  ) VALUES (
    p_variant_id,
    p_name,
    p_price,
    p_customer_price,
    p_seller_price,
    true,
    now(),
    now()
  )
  RETURNING public.variant_options.id INTO v_variant_option_id;

  RETURN QUERY
  SELECT v_variant_option_id, v_status, v_message;
END;
$$;


ALTER FUNCTION public.create_variant_option(p_variant_id integer, p_name character varying, p_price numeric, p_customer_price numeric, p_seller_price numeric) OWNER TO postgres;

--
-- Name: disable_mart(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.disable_mart(p_mart_id integer) RETURNS TABLE(status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'The mart has been disabled';
BEGIN
  IF NOT EXISTS (SELECT s.id FROM public.stores AS s WHERE id = p_mart_id) THEN
    v_status := 'warning';
    v_message := 'The mart you are trying to disable does not exist.';
    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  UPDATE public.stores
    SET
      status = 'deactivated',
      "updatedAt" = now()
    WHERE id = p_mart_id;

  RETURN QUERY SELECT v_status, v_message;
END;
$$;


ALTER FUNCTION public.disable_mart(p_mart_id integer) OWNER TO postgres;

--
-- Name: disable_menu(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.disable_menu(p_id integer) RETURNS TABLE(status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Menu successfully disabled.';
BEGIN
  IF NOT EXISTS (SELECT m.id FROM public.store_products AS m WHERE m.id = p_id) THEN
    v_status := 'warning';
    v_message := 'The menu you are trying to disable does not exist.';
    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  UPDATE public.store_products
  SET
    status = 'unavailable',
    "updatedAt" = now()
  WHERE id = p_id;

  RETURN QUERY SELECT v_status, v_message;
END;
$$;


ALTER FUNCTION public.disable_menu(p_id integer) OWNER TO postgres;

--
-- Name: disable_restaurant(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.disable_restaurant(p_restaurant_id integer) RETURNS TABLE(status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'The restaurant has been disabled';
BEGIN
  IF NOT EXISTS (SELECT s.id FROM public.stores AS s WHERE id = p_restaurant_id) THEN
    v_status := 'warning';
    v_message := 'The restaurant you are trying to delete does not exist.';
    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  UPDATE public.stores
    SET
      status = 'deactivated',
      "updatedAt" = now()
    WHERE id = p_restaurant_id;

  RETURN QUERY SELECT v_status, v_message;
END;
$$;


ALTER FUNCTION public.disable_restaurant(p_restaurant_id integer) OWNER TO postgres;

--
-- Name: disable_rider(integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.disable_rider(p_user_id integer, p_email_address character varying) RETURNS TABLE(status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'The rider has been disabled';
BEGIN
  IF NOT EXISTS (
    SELECT
      u.id
    FROM public.users AS u
    WHERE u.id = p_user_id
  ) THEN
    v_status := 'warning';
    v_message := 'Rider does not exist';

    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  IF EXISTS (
    SELECT
      u.id
    FROM public.users AS u
    WHERE u.email = p_email_address
    AND u.id <> p_user_id
  ) THEN
    v_status := 'warning';
    v_message := 'Email address and ID do not match';

    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  UPDATE public.users
  SET 
    status = false,
    "updatedAt" = now()
  WHERE id = p_user_id;
  
  RETURN QUERY SELECT v_status, v_message;
END;
$$;


ALTER FUNCTION public.disable_rider(p_user_id integer, p_email_address character varying) OWNER TO postgres;

--
-- Name: find_addon_by_id(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.find_addon_by_id(p_user_id integer, p_addon_id integer) RETURNS TABLE(id integer, store_id integer, addon_name character varying, price numeric, customer_price numeric, seller_price numeric, addon_status boolean, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    ao.id AS id,
    ao.store_id AS store_id,
    ao.name AS addon_name,
    ao.price AS price,
    ao.customer_price AS customer_price,
    ao.seller_price AS seller_price,
    ao.status AS addon_status,
    ao."createdAt" AS "createdAt",
    ao."updatedAt" AS "updatedAt"
  FROM additionals AS ao
  INNER JOIN stores AS s
    ON ao.store_id = s.id
  WHERE
    s.user_id = p_user_id
  AND
    ao.id = p_addon_id;
END;
$$;


ALTER FUNCTION public.find_addon_by_id(p_user_id integer, p_addon_id integer) OWNER TO postgres;

--
-- Name: find_mart_by_id(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.find_mart_by_id(p_id integer) RETURNS TABLE(id integer, user_name character varying, cellphone_number character varying, email character varying, mart_name character varying, description text, latitude numeric, longitude numeric, location_name character varying, status public.enum_stores_status, stature public.enum_stores_stature, contract_type public.enum_stores_contract_type, category character varying, country character varying, state character varying, city character varying, barangay character varying, rating numeric, logo_url text, photo_url text, sunday boolean, sunday_opening_time time without time zone, sunday_closing_time time without time zone, monday boolean, monday_opening_time time without time zone, monday_closing_time time without time zone, tuesday boolean, tuesday_opening_time time without time zone, tuesday_closing_time time without time zone, wednesday boolean, wednesday_opening_time time without time zone, wednesday_closing_time time without time zone, thursday boolean, thursday_opening_time time without time zone, thursday_closing_time time without time zone, friday boolean, friday_opening_time time without time zone, friday_closing_time time without time zone, saturday boolean, saturday_opening_time time without time zone, saturday_closing_time time without time zone, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    s.id AS id,
    u.name AS user_name,
    u.cellphone_number AS cellphone_number,
    u.email AS email,
    s.name AS mart_name,
    s.description AS description,
    s.latitude AS latitude,
    s.longitude AS longitude,
    s.location_name AS location_name,
    s.status AS status,
    s.stature AS stature,
    s.contract_type AS contract_type,
    s.category AS category,
    s.country AS country,
    s.state AS state,
    s.city AS city,
    s.barangay AS barangay,
    s.rating AS rating,
    s.logo_url AS logo_url,
    s.photo_url AS photo_url,
    s.sunday AS sunday,
    s.sunday_opening_time AS sunday_opening_time,
    s.sunday_closing_time AS sunday_closing_time,
    s.monday AS monday,
    s.monday_opening_time AS monday_opening_time,
    s.monday_closing_time AS monday_closing_time,
    s.tuesday AS tuesday,
    s.tuesday_opening_time AS tuesday_opening_time,
    s.tuesday_closing_time AS tuesday_closing_time,
    s.wednesday AS wednesday,
    s.wednesday_opening_time AS wednesday_opening_time,
    s.wednesday_closing_time AS wednesday_closing_time,
    s.thursday AS thursday,
    s.thursday_opening_time AS thursday_opening_time,
    s.thursday_closing_time AS thursday_closing_time,
    s.friday AS friday,
    s.friday_opening_time AS friday_opening_time,
    s.friday_closing_time AS friday_closing_time,
    s.saturday AS saturday,
    s.saturday_opening_time AS saturday_opening_time,
    s.saturday_closing_time AS saturday_closing_time,
    s."createdAt" AS "createdAt",
    s."updatedAt" AS "updatedAt"
  FROM public.stores AS s
  INNER JOIN public.users AS u
    ON s.user_id = u.id
  WHERE s.type = 'mart'
  AND s.id = p_id;
END;
$$;


ALTER FUNCTION public.find_mart_by_id(p_id integer) OWNER TO postgres;

--
-- Name: find_partner_by_email(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.find_partner_by_email(p_email_address character varying) RETURNS TABLE(id integer, partner_name character varying, email character varying, hashed_password character varying, partner_status boolean, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    u.id as id,
    u.name as partner_name,
    u.email as email,
    u.password as hashed_password,
    u.status as partner_status,
    u."createdAt" as "createdAt",
    u."updatedAt" as "updatedAt"
  FROM
    public.users as u
  WHERE u.role = 'partner'
  AND u.email = p_email_address;
END;
$$;


ALTER FUNCTION public.find_partner_by_email(p_email_address character varying) OWNER TO postgres;

--
-- Name: find_partner_by_id(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.find_partner_by_id(p_id integer) RETURNS TABLE(id integer, partner_name character varying, email character varying, hashed_password character varying, partner_status boolean, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    u.id as id,
    u.name as partner_name,
    u.email as email,
    u.password as hashed_password,
    u.status as partner_status,
    u."createdAt" as "createdAt",
    u."updatedAt" as "updatedAt"
  FROM
    public.users as u
  WHERE u.role = 'partner'
  AND u.id = p_id;
END;
$$;


ALTER FUNCTION public.find_partner_by_id(p_id integer) OWNER TO postgres;

--
-- Name: find_product_by_id(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.find_product_by_id(p_user_id integer, p_product_id integer) RETURNS TABLE(id integer, product_name character varying, product_description text, product_image text, price numeric, customer_price numeric, seller_price numeric, variants json, additionals json, quantity integer, max_order integer, category character varying, product_status public.enum_store_products_status, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    sp.id AS id,
    sp.name AS product_name,
    sp.description AS product_description,
    sp.image AS product_image,
    sp.price AS price,
    sp.customer_price AS customer_price,
    sp.seller_price AS seller_price,
    (
      SELECT
        json_agg(
          json_build_object(
            'id', v.id,
            'type', v.type,
            'status', v.status,
            'options', tmp.variant_options
          )
        )
      FROM public.variants AS v
      LEFT JOIN (
        SELECT
          json_agg(vo.*) AS variant_options, vo.variant_id AS variant_id
        FROM public.variant_options AS vo
        GROUP BY vo.variant_id
      ) AS tmp ON tmp.variant_id = v.id
      WHERE v.id = ANY(
        REPLACE(
          REPLACE(
            sp.variants,
            '[',
            '{'
          ),
          ']',
          '}'
        )::int[]
      )
    ) AS variants,
    (
      SELECT json_agg(ad.*)
      FROM public.additionals AS ad
      WHERE ad.id = ANY(
          REPLACE(
            REPLACE(
              sp.additionals,
              '[',
              '{'
            ),
            ']',
            '}'
          )::int[]
        )
    ) AS additionals,
    sp.quantity AS quantity,
    sp.max_order AS max_order,
    sp.category AS category,
    sp.status AS product_status,
    sp."createdAt" AS "createdAt",
    sp."updatedAt" AS "updatedAt"
  FROM public.store_products AS sp
  INNER JOIN public.stores AS s
    ON sp.store_id = s.id
  WHERE s.user_id = p_user_id
  AND sp.id = p_product_id
  GROUP BY sp.id;
END;
$$;


ALTER FUNCTION public.find_product_by_id(p_user_id integer, p_product_id integer) OWNER TO postgres;

--
-- Name: find_restaurant_by_id(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.find_restaurant_by_id(p_id integer) RETURNS TABLE(id integer, user_name character varying, cellphone_number character varying, email character varying, restaurant_name character varying, description text, latitude numeric, longitude numeric, location_name character varying, status public.enum_stores_status, stature public.enum_stores_stature, contract_type public.enum_stores_contract_type, category character varying, country character varying, state character varying, city character varying, barangay character varying, rating numeric, logo_url text, photo_url text, sunday boolean, sunday_opening_time time without time zone, sunday_closing_time time without time zone, monday boolean, monday_opening_time time without time zone, monday_closing_time time without time zone, tuesday boolean, tuesday_opening_time time without time zone, tuesday_closing_time time without time zone, wednesday boolean, wednesday_opening_time time without time zone, wednesday_closing_time time without time zone, thursday boolean, thursday_opening_time time without time zone, thursday_closing_time time without time zone, friday boolean, friday_opening_time time without time zone, friday_closing_time time without time zone, saturday boolean, saturday_opening_time time without time zone, saturday_closing_time time without time zone, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    s.id AS id,
    u.name AS user_name,
    u.cellphone_number AS cellphone_number,
    u.email AS email,
    s.name AS restaurant_name,
    s.description AS description,
    s.latitude AS latitude,
    s.longitude AS longitude,
    s.location_name AS location_name,
    s.status AS status,
    s.stature AS stature,
    s.contract_type AS contract_type,
    s.category AS category,
    s.country AS country,
    s.state AS state,
    s.city AS city,
    s.barangay AS barangay,
    s.rating AS rating,
    s.logo_url AS logo_url,
    s.photo_url AS photo_url,
    s.sunday AS sunday,
    s.sunday_opening_time AS sunday_opening_time,
    s.sunday_closing_time AS sunday_closing_time,
    s.monday AS monday,
    s.monday_opening_time AS monday_opening_time,
    s.monday_closing_time AS monday_closing_time,
    s.tuesday AS tuesday,
    s.tuesday_opening_time AS tuesday_opening_time,
    s.tuesday_closing_time AS tuesday_closing_time,
    s.wednesday AS wednesday,
    s.wednesday_opening_time AS wednesday_opening_time,
    s.wednesday_closing_time AS wednesday_closing_time,
    s.thursday AS thursday,
    s.thursday_opening_time AS thursday_opening_time,
    s.thursday_closing_time AS thursday_closing_time,
    s.friday AS friday,
    s.friday_opening_time AS friday_opening_time,
    s.friday_closing_time AS friday_closing_time,
    s.saturday AS saturday,
    s.saturday_opening_time AS saturday_opening_time,
    s.saturday_closing_time AS saturday_closing_time,
    s."createdAt" AS "createdAt",
    s."updatedAt" AS "updatedAt"
  FROM public.stores AS s
  INNER JOIN public.users AS u
    ON s.user_id = u.id
  WHERE s.type = 'restaurant'
  AND s.id = p_id;
END;
$$;


ALTER FUNCTION public.find_restaurant_by_id(p_id integer) OWNER TO postgres;

--
-- Name: find_rider_by_email_address(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.find_rider_by_email_address(p_email_address character varying) RETURNS TABLE(id integer, rider_id integer, name character varying, email character varying, cellphone_number character varying, cellphone_status integer, status boolean, latitude numeric, longitude numeric, motorcycle_details text, createdat timestamp with time zone, updatedat timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    u.id,
    r.id,
    u.name,
    u.email,
    u.cellphone_number,
    u.cellphone_status,
    u.status,
    r.latitude,
    r.longitude,
    r.motorcycle_details,
    u."createdAt",
    u."updatedAt"
  FROM public.users as u
  LEFT JOIN public.riders as r
    ON r.user_id = u.id
  WHERE u.role = 'rider'
  AND u.email = p_email_address;
END;
$$;


ALTER FUNCTION public.find_rider_by_email_address(p_email_address character varying) OWNER TO postgres;

--
-- Name: find_rider_by_id(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.find_rider_by_id(p_user_id integer) RETURNS TABLE(id integer, rider_id integer, name character varying, email character varying, cellphone_number character varying, cellphone_status integer, status boolean, latitude numeric, longitude numeric, motorcycle_details text, createdat timestamp with time zone, updatedat timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    u.id,
    r.id,
    u.name,
    u.email,
    u.cellphone_number,
    u.cellphone_status,
    u.status,
    r.latitude,
    r.longitude,
    r.motorcycle_details,
    u."createdAt",
    u."updatedAt"
  FROM public.users as u
  LEFT JOIN public.riders as r
    ON u.id = r.user_id
  WHERE u.role = 'rider'
  AND u.id = p_user_id;
END;
$$;


ALTER FUNCTION public.find_rider_by_id(p_user_id integer) OWNER TO postgres;

--
-- Name: find_store_by_id(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.find_store_by_id(p_user_id integer) RETURNS TABLE(id integer, user_name character varying, cellphone_number character varying, email character varying, store_name character varying, district json, description text, latitude numeric, longitude numeric, location_name character varying, status public.enum_stores_status, stature public.enum_stores_stature, contract_type public.enum_stores_contract_type, category character varying, country character varying, state character varying, city character varying, barangay character varying, rating numeric, logo_url text, photo_url text, sunday boolean, sunday_opening_time time without time zone, sunday_closing_time time without time zone, monday boolean, monday_opening_time time without time zone, monday_closing_time time without time zone, tuesday boolean, tuesday_opening_time time without time zone, tuesday_closing_time time without time zone, wednesday boolean, wednesday_opening_time time without time zone, wednesday_closing_time time without time zone, thursday boolean, thursday_opening_time time without time zone, thursday_closing_time time without time zone, friday boolean, friday_opening_time time without time zone, friday_closing_time time without time zone, saturday boolean, saturday_opening_time time without time zone, saturday_closing_time time without time zone, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    s.id AS id,
    u.name AS user_name,
    u.cellphone_number AS cellphone_number,
    u.email AS email,
    s.name AS store_name,
    (
      SELECT
        json_build_object(
          'district_id', d.id,
          'district_name', d.name,
          'zip_code', d.zip_code
        )
      FROM public.districts AS d
      WHERE d.id = s.district_id
    ) AS district,
    s.description AS description,
    s.latitude AS latitude,
    s.longitude AS longitude,
    s.location_name AS location_name,
    s.status AS status,
    s.stature AS stature,
    s.contract_type AS contract_type,
    s.category AS category,
    s.country AS country,
    s.state AS state,
    s.city AS city,
    s.barangay AS barangay,
    s.rating AS rating,
    s.logo_url AS logo_url,
    s.photo_url AS photo_url,
    s.sunday AS sunday,
    s.sunday_opening_time AS sunday_opening_time,
    s.sunday_closing_time AS sunday_closing_time,
    s.monday AS monday,
    s.monday_opening_time AS monday_opening_time,
    s.monday_closing_time AS monday_closing_time,
    s.tuesday AS tuesday,
    s.tuesday_opening_time AS tuesday_opening_time,
    s.tuesday_closing_time AS tuesday_closing_time,
    s.wednesday AS wednesday,
    s.wednesday_opening_time AS wednesday_opening_time,
    s.wednesday_closing_time AS wednesday_closing_time,
    s.thursday AS thursday,
    s.thursday_opening_time AS thursday_opening_time,
    s.thursday_closing_time AS thursday_closing_time,
    s.friday AS friday,
    s.friday_opening_time AS friday_opening_time,
    s.friday_closing_time AS friday_closing_time,
    s.saturday AS saturday,
    s.saturday_opening_time AS saturday_opening_time,
    s.saturday_closing_time AS saturday_closing_time,
    s."createdAt" AS "createdAt",
    s."updatedAt" AS "updatedAt"
  FROM public.stores AS s
  INNER JOIN public.users AS u
    ON s.user_id = u.id
  WHERE u.id = p_user_id;
END;
$$;


ALTER FUNCTION public.find_store_by_id(p_user_id integer) OWNER TO postgres;

--
-- Name: find_variant_by_id(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.find_variant_by_id(p_user_id integer, p_variant_id integer) RETURNS TABLE(id integer, store_id integer, variant_type character varying, variant_status boolean, variant_options json, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    v.id AS id,
    v.store_id AS store_id,
    v.type AS variant_type,
    v.status AS variant_status,
    (
      SELECT
        json_agg(vo.*)
      FROM public.variant_options AS vo
      WHERE vo.variant_id = v.id
    ) AS variant_options,
    v."createdAt" AS "createdAt",
    v."updatedAt" AS "updatedAt"
  FROM public.variants AS v
  INNER JOIN public.stores AS s
    ON v.store_id = s.id
  WHERE s.user_id = p_user_id
  AND v.id = p_variant_id;
END;
$$;


ALTER FUNCTION public.find_variant_by_id(p_user_id integer, p_variant_id integer) OWNER TO postgres;

--
-- Name: find_variant_option_by_id(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.find_variant_option_by_id(p_user_id integer, p_variant_option_id integer) RETURNS TABLE(id integer, variant_id integer, variant_option_name character varying, price numeric, customer_price numeric, seller_price numeric, variant_option_status boolean, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    vo.id AS id,
    vo.variant_id AS variant_id,
    vo.name AS variant_option_name,
    vo.price AS price,
    vo.customer_price AS customer_price,
    vo.seller_price AS seller_price,
    vo.status AS variant_option_status,
    vo."createdAt" AS "createdAt",
    vo."updatedAt" AS "updatedAt"
  FROM public.variant_options AS vo
  INNER JOIN public.variants AS v
    ON vo.variant_id = v.id
  INNER JOIN public.stores AS s
    ON v.store_id = s.id
  WHERE
    s.user_id = p_user_id
  AND
    vo.id = p_variant_option_id;
END;
$$;


ALTER FUNCTION public.find_variant_option_by_id(p_user_id integer, p_variant_option_id integer) OWNER TO postgres;

--
-- Name: get_all_history(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_all_history() RETURNS TABLE(order_id integer, customer_id integer, rider_id integer, rider_user_id integer, store_id integer, customer_name character varying, rider_name character varying, store_name character varying, order_status public.enum_orders_status, products json, fee json, timeframe json, order_address json, payment json, reason text, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    o.id as order_id,
    c.id as customer_id,
    r.id as rider_id,
    u.id as rider_user_id,
    s.id as store_id,
    c.name as customer_name,
    u.name as rider_name,
    s.name as store_name,
    o.status as order_status,
    JSON(o.products) as products,
    JSON(o.fee) as fee,
    JSON(o.timeframe) as timeframe,
    JSON(o.address) as order_address,
    JSON(o.payment) as payment,
    o.reason as reason,
    o."createdAt" as "createdAt",
    o."updatedAt" as "updatedAt"
  FROM public.orders as o
  INNER JOIN public.users as c
    ON o.user_id = c.id
  INNER JOIN public.riders as r
    ON o.rider_id = r.id
  INNER JOIN public.users as u
    ON r.user_id = u.id
  INNER JOIN public.stores as s
    ON o.store_id = s.id
  ORDER BY o."createdAt" DESC;
END;
$$;


ALTER FUNCTION public.get_all_history() OWNER TO postgres;

--
-- Name: get_all_marts(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_all_marts() RETURNS TABLE(id integer, mart_name character varying, description text, latitude numeric, longitude numeric, location_name character varying, status integer, stature public.enum_stores_stature, contract_type public.enum_stores_contract_type, country character varying, state character varying, city character varying, barangay character varying, rating numeric, logo_url text, photo_url text, sunday boolean, sunday_opening_time timestamp with time zone, sunday_closing_time timestamp with time zone, monday boolean, monday_opening_time timestamp with time zone, monday_closing_time timestamp with time zone, tuesday boolean, tuesday_opening_time timestamp with time zone, tuesday_closing_time timestamp with time zone, wednesday boolean, wednesday_opening_time timestamp with time zone, wednesday_closing_time timestamp with time zone, thursday boolean, thursday_opening_time timestamp with time zone, thursday_closing_time timestamp with time zone, friday boolean, friday_opening_time timestamp with time zone, friday_closing_time timestamp with time zone, saturday boolean, saturday_opening_time timestamp with time zone, saturday_closing_time timestamp with time zone, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    s.id AS id,
    s.name AS mart_name,
    s.description AS description,
    s.latitude AS latitude,
    s.longitude AS longitude,
    s.location_name AS location_name,
    s.status AS status,
    s.stature AS stature,
    s.contract_type AS contract_type,
    s.country AS country,
    s.state AS state,
    s.city AS city,
    s.barangay AS barangay,
    s.rating AS rating,
    s.logo_url AS logo_url,
    s.photo_url AS photo_url,
    s.sunday AS sunday,
    s.sunday_opening_time AS sunday_opening_time,
    s.sunday_closing_time AS sunday_closing_time,
    s.monday AS monday,
    s.monday_opening_time AS monday_opening_time,
    s.monday_closing_time AS monday_closing_time,
    s.tuesday AS tuesday,
    s.tuesday_opening_time AS tuesday_opening_time,
    s.tuesday_closing_time AS tuesday_closing_time,
    s.wednesday AS wednesday,
    s.wednesday_opening_time AS wednesday_opening_time,
    s.wednesday_closing_time AS wednesday_closing_time,
    s.thursday AS thursday,
    s.thursday_opening_time AS thursday_opening_time,
    s.thursday_closing_time AS thursday_closing_time,
    s.friday AS friday,
    s.friday_opening_time AS friday_opening_time,
    s.friday_closing_time AS friday_closing_time,
    s.saturday AS saturday,
    s.saturday_opening_time AS saturday_opening_time,
    s.saturday_closing_time AS saturday_closing_time,
    s."createdAt" AS "createdAt",
    s."updatedAt" AS "updatedAt"
  FROM public.stores AS s
  WHERE s.type = 'mart';
END;
$$;


ALTER FUNCTION public.get_all_marts() OWNER TO postgres;

--
-- Name: get_all_restaurants(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_all_restaurants() RETURNS TABLE(id integer, restaurant_name character varying, description text, latitude numeric, longitude numeric, location_name character varying, status integer, stature public.enum_stores_stature, contract_type public.enum_stores_contract_type, country character varying, state character varying, city character varying, barangay character varying, rating numeric, logo_url text, photo_url text, sunday boolean, sunday_opening_time timestamp with time zone, sunday_closing_time timestamp with time zone, monday boolean, monday_opening_time timestamp with time zone, monday_closing_time timestamp with time zone, tuesday boolean, tuesday_opening_time timestamp with time zone, tuesday_closing_time timestamp with time zone, wednesday boolean, wednesday_opening_time timestamp with time zone, wednesday_closing_time timestamp with time zone, thursday boolean, thursday_opening_time timestamp with time zone, thursday_closing_time timestamp with time zone, friday boolean, friday_opening_time timestamp with time zone, friday_closing_time timestamp with time zone, saturday boolean, saturday_opening_time timestamp with time zone, saturday_closing_time timestamp with time zone, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    s.id AS id,
    s.name AS restaurant_name,
    s.description AS description,
    s.latitude AS latitude,
    s.longitude AS longitude,
    s.location_name AS location_name,
    s.status AS status,
    s.stature AS stature,
    s.contract_type AS contract_type,
    s.country AS country,
    s.state AS state,
    s.city AS city,
    s.barangay AS barangay,
    s.rating AS rating,
    s.logo_url AS logo_url,
    s.photo_url AS photo_url,
    s.sunday AS sunday,
    s.sunday_opening_time AS sunday_opening_time,
    s.sunday_closing_time AS sunday_closing_time,
    s.monday AS monday,
    s.monday_opening_time AS monday_opening_time,
    s.monday_closing_time AS monday_closing_time,
    s.tuesday AS tuesday,
    s.tuesday_opening_time AS tuesday_opening_time,
    s.tuesday_closing_time AS tuesday_closing_time,
    s.wednesday AS wednesday,
    s.wednesday_opening_time AS wednesday_opening_time,
    s.wednesday_closing_time AS wednesday_closing_time,
    s.thursday AS thursday,
    s.thursday_opening_time AS thursday_opening_time,
    s.thursday_closing_time AS thursday_closing_time,
    s.friday AS friday,
    s.friday_opening_time AS friday_opening_time,
    s.friday_closing_time AS friday_closing_time,
    s.saturday AS saturday,
    s.saturday_opening_time AS saturday_opening_time,
    s.saturday_closing_time AS saturday_closing_time,
    s."createdAt" AS "createdAt",
    s."updatedAt" AS "updatedAt"
  FROM public.stores AS s
  WHERE s.type = 'restaurant';
END;
$$;


ALTER FUNCTION public.get_all_restaurants() OWNER TO postgres;

--
-- Name: get_all_stats(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_all_stats() RETURNS TABLE(grand_subtotal numeric, delivery_total numeric, discount_total numeric, grand_total numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    COALESCE(SUM((JSON(fee) ->> 'sub_total')::decimal), 0) AS grand_subtotal,
    COALESCE(SUM((JSON(fee) ->> 'delivery')::decimal), 0) AS delivery_total,
    COALESCE(SUM((JSON(fee) ->> 'discount_price')::decimal), 0) AS discount_total,
    COALESCE(SUM((JSON(fee) ->> 'total')::decimal), 0) AS grand_total
  FROM public.orders AS o;
END;
$$;


ALTER FUNCTION public.get_all_stats() OWNER TO postgres;

--
-- Name: get_daily_stats(integer, date, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_daily_stats(p_user_id integer, p_start_date date, p_end_date date) RETURNS TABLE(date_start timestamp without time zone, date_end timestamp without time zone, delivered_count bigint, cancelled_count bigint, sales numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    CONCAT(d::date, ' 00:00:00')::TIMESTAMP AS date_start,
    CONCAT(d::date, ' 23:59:59')::TIMESTAMP AS date_end,
    COUNT(o.id) FILTER (
      WHERE o.status = 'delivered'
      AND o."createdAt" >= CONCAT(d::date, ' 00:00:00')::TIMESTAMP
      AND o."createdAt" <= CONCAT(d::date, ' 23:59:59')::TIMESTAMP
    ) AS delivered_count,
    COUNT(o.id) FILTER (
      WHERE o.status = 'store-declined'
      AND o."createdAt" >= CONCAT(d::date, ' 00:00:00')::TIMESTAMP
      AND o."createdAt" <= CONCAT(d::date, ' 23:59:59')::TIMESTAMP
    ) AS cancelled_count,
    COALESCE (
      SUM((JSON(o.fee)->>'seller_total_price')::NUMERIC) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(d::date, ' 00:00:00')::TIMESTAMP
        AND o."createdAt" <= CONCAT(d::date, ' 23:59:59')::TIMESTAMP
      ),
      0
    ) AS sales
  FROM generate_series(
      p_start_date,
      p_end_date,
      '1 day'
  ) AS d
  LEFT JOIN public.orders AS o
    ON TRUE
  INNER JOIN public.stores AS s
    ON o.store_id = s.id
  WHERE s.user_id = p_user_id
  GROUP BY d.d
  ORDER BY date_start;
END;
$$;


ALTER FUNCTION public.get_daily_stats(p_user_id integer, p_start_date date, p_end_date date) OWNER TO postgres;

--
-- Name: get_history_by_id(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_history_by_id(p_id integer) RETURNS TABLE(order_id integer, customer_id integer, rider_id integer, rider_user_id integer, store_id integer, customer_name character varying, rider_name character varying, store_name character varying, order_status public.enum_orders_status, products json, fee json, timeframe json, order_address json, payment json, reason text, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    o.id as order_id,
    c.id as customer_id,
    r.id as rider_id,
    u.id as rider_user_id,
    s.id as store_id,
    c.name as customer_name,
    u.name as rider_name,
    s.name as store_name,
    o.status as order_status,
    JSON(o.products) as products,
    JSON(o.fee) as fee,
    JSON(o.timeframe) as timeframe,
    JSON(o.address) as order_address,
    JSON(o.payment) as payment,
    o.reason as reason,
    o."createdAt" as "createdAt",
    o."updatedAt" as "updatedAt"
  FROM public.orders as o
  INNER JOIN public.users as c
    ON o.user_id = c.id
  INNER JOIN public.riders as r
    ON o.rider_id = r.id
  INNER JOIN public.users as u
    ON r.user_id = u.id
  INNER JOIN public.stores as s
    ON o.store_id = s.id
  WHERE o.id = p_id
  ORDER BY o."createdAt" DESC;
END;
$$;


ALTER FUNCTION public.get_history_by_id(p_id integer) OWNER TO postgres;

--
-- Name: get_menu_by_id(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_menu_by_id(p_id integer) RETURNS TABLE(id integer, store_id integer, name character varying, description text, image text, price numeric, customer_price numeric, seller_price numeric, choices text, additionals text, quantity integer, max_order integer, category character varying, status public.enum_store_products_status, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    m.id AS id,
    m.store_id AS store_id,
    m.name AS name,
    m.description AS description,
    m.image AS image,
    m.price AS price,
    m.customer_price AS customer_price,
    m.seller_price AS seller_price,
    m.choices AS choices,
    m.additionals AS additionals,
    m.quantity AS quantity,
    m.max_order AS max_order,
    m.category AS category,
    m.status AS status,
    m."createdAt" AS "createdAt",
    m."updatedAt" AS "updatedAt"
  FROM
    public.store_products AS m
  WHERE m.id = p_id;
END;
$$;


ALTER FUNCTION public.get_menu_by_id(p_id integer) OWNER TO postgres;

--
-- Name: get_order_stats(integer, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_order_stats(p_user_id integer, p_today date) RETURNS TABLE(delivered_today bigint, delivered_yesterday bigint, cancelled_today bigint, cancelled_yesterday bigint, net_sales_today numeric, net_sales_yesterday numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    COUNT(o.id)
      FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_today, ' 00:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_today, ' 23:59:59')::TIMESTAMPTZ
      ) AS delivered_today,
    COUNT(o.id)
      FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_today, ' 00:00:00')::TIMESTAMPTZ - INTERVAL '1 DAY'
        AND o."createdAt" <= CONCAT(p_today, ' 23:59:59')::TIMESTAMPTZ - INTERVAL '1 DAY'
      ) AS delivered_yesterday,
    COUNT(o.id)
      FILTER (
        WHERE o.status = 'cancelled'
        AND o."createdAt" >= CONCAT(p_today, ' 00:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_today, ' 23:59:59')::TIMESTAMPTZ
      ) AS cancelled_today,
    COUNT(o.id)
      FILTER (
        WHERE o.status = 'cancelled'
        AND o."createdAt" >= CONCAT(p_today, ' 00:00:00')::TIMESTAMPTZ - INTERVAL '1 DAY'
        AND o."createdAt" <= CONCAT(p_today, ' 23:59:59')::TIMESTAMPTZ - INTERVAL '1 DAY'
      ) AS cancelled_yesterday,
    COALESCE(
      SUM((JSON(o.fee)->>'seller_total_price')::numeric)
        FILTER (
          WHERE o.status = 'delivered'
          AND o."createdAt" >= CONCAT(p_today, ' 00:00:00')::TIMESTAMPTZ
          AND o."createdAt" <= CONCAT(p_today, ' 23:59:59')::TIMESTAMPTZ
        ),
      0
    ) AS net_sales_today,
    COALESCE(
      SUM((JSON(o.fee)->>'seller_total_price')::numeric)
        FILTER (
          WHERE o.status = 'delivered'
          AND o."createdAt" >= CONCAT(p_today, ' 00:00:00')::TIMESTAMPTZ - INTERVAL '1 DAY'
          AND o."createdAt" <= CONCAT(p_today, ' 23:59:59')::TIMESTAMPTZ - INTERVAL '1 DAY'
        ),
      0
    ) AS net_sales_yesterday
  FROM public.orders AS o
  INNER JOIN public.stores AS s
    ON o.store_id = s.id
  INNER JOIN public.users AS u
    ON s.user_id = u.id
  WHERE u.id = p_user_id;
END;
$$;


ALTER FUNCTION public.get_order_stats(p_user_id integer, p_today date) OWNER TO postgres;

--
-- Name: get_partner_stats(integer, timestamp with time zone, timestamp with time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_partner_stats(p_user_id integer, p_start_date timestamp with time zone, p_end_date timestamp with time zone) RETURNS TABLE(delivered bigint, cancelled bigint, net_sales numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    COUNT(o.id)
      FILTER (
        WHERE o.status = 'delivered'
      )
    AS delivered,
    COUNT(o.id)
      FILTER (
        WHERE o.status = 'cancelled'
      )
    AS cancelled,
    COALESCE (
      SUM((JSON(o.fee)->>'seller_total_price')::NUMERIC)
      FILTER (
        WHERE o.status = 'delivered'
      ),
      0
    )
    AS net_sales
  FROM public.orders AS o
  INNER JOIN public.stores AS s
    ON o.store_id = s.id
  INNER JOIN public.users AS u
    ON s.user_id = u.id
  WHERE u.id = p_user_id
  AND (
    p_start_date IS NULL
    OR o."createdAt" >= p_start_date
  ) AND (
    p_start_date IS NULL
    OR o."createdAt" <= p_end_date
  );
END;
$$;


ALTER FUNCTION public.get_partner_stats(p_user_id integer, p_start_date timestamp with time zone, p_end_date timestamp with time zone) OWNER TO postgres;

--
-- Name: get_peak_hours(integer, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_peak_hours(p_user_id integer, p_date date) RETURNS TABLE(hour time without time zone, orders bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    ph.hour AS hour,
    ph.orders AS orders
  FROM (
    SELECT
      '00:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 00:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 00:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '01:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 01:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 01:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '02:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 02:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 02:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '03:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 03:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 03:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '04:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 04:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 04:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '05:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 05:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 05:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '06:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 06:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 06:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '07:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 07:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 07:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '08:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 08:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 08:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '09:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 09:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 09:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '10:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 10:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 10:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '11:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 11:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 11:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '12:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 12:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 12:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '13:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 13:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 13:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '14:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 14:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 14:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '15:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 15:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 15:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '16:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 16:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 16:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '17:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 17:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 17:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '18:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 18:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 18:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '19:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 19:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 19:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '20:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 20:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 20:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '21:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 21:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 21:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '22:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 22:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 22:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
    UNION ALL
    SELECT
      '23:00:00'::time AS "hour",
      COUNT(o.id) FILTER (
        WHERE o.status = 'delivered'
        AND o."createdAt" >= CONCAT(p_date, ' 23:00:00')::TIMESTAMPTZ
        AND o."createdAt" <= CONCAT(p_date, ' 23:59:59')::TIMESTAMPTZ
      ) AS orders
    FROM public.orders AS o
    INNER JOIN public.stores AS s
      ON o.store_id = s.id
      INNER JOIN public.users AS u
      ON s.user_id = u.id
      WHERE u.id = p_user_id
  ) AS ph
  ORDER BY ph.orders DESC LIMIT 1;
END;
$$;


ALTER FUNCTION public.get_peak_hours(p_user_id integer, p_date date) OWNER TO postgres;

--
-- Name: get_pending_store_applications_count(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_pending_store_applications_count() RETURNS TABLE(total_count bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
    SELECT
      COUNT(a.id) AS total_count
    FROM public.store_applications AS a
    WHERE "status" = 'pending';
END;
$$;


ALTER FUNCTION public.get_pending_store_applications_count() OWNER TO postgres;

--
-- Name: get_popular_products(integer, timestamp with time zone, timestamp with time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_popular_products(p_user_id integer, p_start_date timestamp with time zone, p_end_date timestamp with time zone) RETURNS TABLE(product_name character varying, number_of_orders bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    sp.name AS product_name,
    COUNT(o.id) AS number_of_orders
  FROM public.store_products AS sp
  LEFT JOIN (
    SELECT *, json_array_elements((o.products)::JSON)->>'product_id' AS product_id FROM public.orders AS o
  ) AS o ON sp.id = o.product_id::int
  INNER JOIN public.stores AS s
    ON o.store_id = s.id
  INNER JOIN public.users AS u
    ON s.user_id = u.id
  WHERE u.id = p_user_id
  AND (
    p_start_date IS NULL
    OR o."createdAt" >= p_start_date
  )
  AND (
    p_end_date IS NULL
    OR o."createdAt" <= p_end_date
  )
  AND o.status = 'delivered'
  GROUP BY sp.id
  ORDER BY number_of_orders DESC;
END;
$$;


ALTER FUNCTION public.get_popular_products(p_user_id integer, p_start_date timestamp with time zone, p_end_date timestamp with time zone) OWNER TO postgres;

--
-- Name: get_riders(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_riders() RETURNS TABLE(id integer, rider_id integer, name character varying, email character varying, cellphone_number character varying, cellphone_status integer, status boolean, latitude numeric, longitude numeric, motorcycle_details text, createdat timestamp with time zone, updatedat timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    u.id,
    r.id,
    u.name,
    u.email,
    u.cellphone_number,
    u.cellphone_status,
    u.status,
    r.latitude,
    r.longitude,
    r.motorcycle_details,
    u."createdAt",
    u."updatedAt"
  FROM public.users as u
  LEFT JOIN public.riders as r
    ON u.id = r.user_id
  WHERE u.role = 'rider'
  ORDER BY u.name ASC;
END;
$$;


ALTER FUNCTION public.get_riders() OWNER TO postgres;

--
-- Name: get_store_application_by_id(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_store_application_by_id(p_id integer) RETURNS TABLE(id integer, business_name character varying, business_type public.enum_store_applications_business_type, district_id integer, district_name character varying, contact_person character varying, email character varying, contact_number character varying, business_address character varying, status public.enum_store_applications_status, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
    SELECT
      a.id AS id,
      a.business_name AS business_name,
      a.business_type AS business_type,
      a.district_id AS district_id,
      d.name AS district_name,
      a.contact_person AS contact_person,
      a.email AS email,
      a.contact_number AS contact_number,
      a.business_address AS business_address,
      a.status AS status,
      a."createdAt" AS "createdAt",
      a."updatedAt" AS "updatedAt"
    FROM public.store_applications AS a
    LEFT JOIN public.districts AS d
      ON a.district_id = d.id
    WHERE a.id = p_id;
END;
$$;


ALTER FUNCTION public.get_store_application_by_id(p_id integer) OWNER TO postgres;

--
-- Name: get_store_menus(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_store_menus(p_store_id integer) RETURNS TABLE(id integer, store_id integer, name character varying, description text, image text, price numeric, customer_price numeric, seller_price numeric, choices text, additionals text, quantity integer, max_order integer, category character varying, status public.enum_store_products_status, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    m.id AS id,
    m.store_id AS store_id,
    m.name AS name,
    m.description AS description,
    m.image AS image,
    m.price AS price,
    m.customer_price AS customer_price,
    m.seller_price AS seller_price,
    m.choices AS choices,
    m.additionals AS additionals,
    m.quantity AS quantity,
    m.max_order AS max_order,
    m.category AS category,
    m.status AS status,
    m."createdAt" AS "createdAt",
    m."updatedAt" AS "updatedAt"
  FROM
    public.store_products AS m
  WHERE m.store_id = p_store_id;
END;
$$;


ALTER FUNCTION public.get_store_menus(p_store_id integer) OWNER TO postgres;

--
-- Name: get_week_stats(integer, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_week_stats(p_user_id integer, p_base_date date) RETURNS TABLE(monday numeric, tuesday numeric, wednesday numeric, thursday numeric, friday numeric, saturday numeric, sunday numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    COALESCE(
        SUM((JSON(o.fee)->>'seller_total_price')::numeric)
          FILTER (
            WHERE o.status = 'delivered'
            AND o."createdAt" >= CONCAT(p_base_date, ' 00:00:00')::TIMESTAMPTZ
            AND o."createdAt" <= CONCAT(p_base_date, ' 23:59:59')::TIMESTAMPTZ
          ),
        0
      ) AS monday,
    COALESCE(
        SUM((JSON(o.fee)->>'seller_total_price')::numeric)
          FILTER (
            WHERE o.status = 'delivered'
            AND o."createdAt" >= CONCAT(p_base_date, ' 00:00:00')::TIMESTAMPTZ + INTERVAL '1 DAY'
            AND o."createdAt" <= CONCAT(p_base_date, ' 23:59:59')::TIMESTAMPTZ + INTERVAL '1 DAY'
          ),
        0
      ) AS tuesday,
    COALESCE(
        SUM((JSON(o.fee)->>'seller_total_price')::numeric)
          FILTER (
            WHERE o.status = 'delivered'
            AND o."createdAt" >= CONCAT(p_base_date, ' 00:00:00')::TIMESTAMPTZ + INTERVAL '2 DAYS'
            AND o."createdAt" <= CONCAT(p_base_date, ' 23:59:59')::TIMESTAMPTZ + INTERVAL '2 DAYS'
          ),
        0
      ) AS wednesday,
    COALESCE(
        SUM((JSON(o.fee)->>'seller_total_price')::numeric)
          FILTER (
            WHERE o.status = 'delivered'
            AND o."createdAt" >= CONCAT(p_base_date, ' 00:00:00')::TIMESTAMPTZ + INTERVAL '3 DAYS'
            AND o."createdAt" <= CONCAT(p_base_date, ' 23:59:59')::TIMESTAMPTZ + INTERVAL '3 DAYS'
          ),
        0
      ) AS thursday,
    COALESCE(
        SUM((JSON(o.fee)->>'seller_total_price')::numeric)
          FILTER (
            WHERE o.status = 'delivered'
            AND o."createdAt" >= CONCAT(p_base_date, ' 00:00:00')::TIMESTAMPTZ + INTERVAL '4 DAYS'
            AND o."createdAt" <= CONCAT(p_base_date, ' 23:59:59')::TIMESTAMPTZ + INTERVAL '4 DAYS'
          ),
        0
      ) AS friday,
    COALESCE(
        SUM((JSON(o.fee)->>'seller_total_price')::numeric)
          FILTER (
            WHERE o.status = 'delivered'
            AND o."createdAt" >= CONCAT(p_base_date, ' 00:00:00')::TIMESTAMPTZ + INTERVAL '5 DAYS'
            AND o."createdAt" <= CONCAT(p_base_date, ' 23:59:59')::TIMESTAMPTZ + INTERVAL '5 DAYS'
          ),
        0
      ) AS saturday,
    COALESCE(
        SUM((JSON(o.fee)->>'seller_total_price')::numeric)
          FILTER (
            WHERE o.status = 'delivered'
            AND o."createdAt" >= CONCAT(p_base_date, ' 00:00:00')::TIMESTAMPTZ + INTERVAL '6 DAYS'
            AND o."createdAt" <= CONCAT(p_base_date, ' 23:59:59')::TIMESTAMPTZ + INTERVAL '6 DAYS'
          ),
        0
      ) AS sunday
  FROM public.orders AS o
  INNER JOIN public.stores AS s
    ON o.store_id = s.id
  INNER JOIN public.users AS u
    ON s.user_id = u.id
  WHERE u.id = p_user_id;
END;
$$;


ALTER FUNCTION public.get_week_stats(p_user_id integer, p_base_date date) OWNER TO postgres;

--
-- Name: register_store(character varying, public.enum_store_applications_business_type, integer, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.register_store(p_business_name character varying, p_business_type public.enum_store_applications_business_type, p_district_id integer, p_contact_person character varying, p_email character varying, p_contact_number character varying, p_business_address character varying, p_tracking_number character varying) RETURNS TABLE(store_application_id integer, status character varying, message character varying, tracking_number character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_store_application_id INT := 0;
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Your application has been sent successfully!';
  v_tracking_number VARCHAR(255) := '';
BEGIN
  IF EXISTS (SELECT s.id FROM public.store_applications AS s WHERE s.email = p_email) THEN
    v_status := 'warning';
    v_message := 'The email address you entered is already registered.';
    RETURN QUERY SELECT v_store_application_id, v_status, v_message, v_tracking_number;
    RETURN;
  END IF;

  INSERT INTO public.store_applications (
    business_name,
    business_type,
    district_id,
    contact_person,
    email,
    contact_number,
    business_address,
    "status",
    tracking_number,
    "createdAt",
    "updatedAt"
  ) VALUES (
    p_business_name,
    p_business_type,
    p_district_id,
    p_contact_person,
    p_email,
    p_contact_number,
    p_business_address,
    'pending',
    p_tracking_number,
    now(),
    now()
  ) RETURNING public.store_applications.id INTO v_store_application_id;

  v_tracking_number := p_tracking_number;

  RETURN QUERY
    SELECT v_store_application_id, v_status, v_message, v_tracking_number;
END;
$$;


ALTER FUNCTION public.register_store(p_business_name character varying, p_business_type public.enum_store_applications_business_type, p_district_id integer, p_contact_person character varying, p_email character varying, p_contact_number character varying, p_business_address character varying, p_tracking_number character varying) OWNER TO postgres;

--
-- Name: search_addons(integer, character varying, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.search_addons(p_user_id integer, p_query character varying, p_limit integer, p_offset integer) RETURNS TABLE(id integer, store_id integer, addon_name character varying, price numeric, customer_price numeric, seller_price numeric, addon_status boolean, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone, total_count bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    ao.id AS id,
    ao.store_id AS store_id,
    ao.name AS addon_name,
    ao.price AS price,
    ao.customer_price AS customer_price,
    ao.seller_price AS seller_price,
    ao.status AS addon_status,
    ao."createdAt" AS "createdAt",
    ao."updatedAt" AS "updatedAt",
    COUNT(ao.id) OVER() AS total_count
  FROM additionals AS ao
  INNER JOIN stores AS s
    ON ao.store_id = s.id
  WHERE
    s.user_id = p_user_id
  AND (
    p_query IS NULL
    OR LOWER(ao.name) LIKE CONCAT('%', LOWER(p_query), '%')
  )
  ORDER BY ao.name
  LIMIT p_limit
  OFFSET p_offset;
END;
$$;


ALTER FUNCTION public.search_addons(p_user_id integer, p_query character varying, p_limit integer, p_offset integer) OWNER TO postgres;

--
-- Name: search_customer_history(integer, timestamp with time zone, timestamp with time zone, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.search_customer_history(p_user_id integer, p_start timestamp with time zone, p_end timestamp with time zone, p_limit integer, p_offset integer) RETURNS TABLE(order_id integer, customer_id integer, rider_id integer, rider_user_id integer, restaurant_id integer, customer_name character varying, rider_name character varying, store_name character varying, order_status public.enum_orders_status, products text, fee text, order_address character varying, payment text, reason text, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    o.id as order_id,
    c.id as customer_id,
    r.id as rider_id,
    u.id as rider_user_id,
    s.id as store_id,
    c.name as customer_name,
    u.name as rider_name,
    s.name as store_name,
    o.status as order_status,
    o.products as products,
    o.fee as fee,
    o.timeframe as timeframe,
    o.address as order_address,
    o.payment as payment,
    o.reason as reason,
    o."createdAt" as "createdAt",
    o."updatedAt" as "updatedAt"
  FROM public.orders as o
  INNER JOIN public.users as c
    ON o.user_id = c.id
  INNER JOIN public.riders as r
    ON o.rider_id = r.id
  INNER JOIN public.users as u
    ON r.user_id = u.id
  INNER JOIN public.stores as s
    ON o.store_id = s.id
  WHERE (
    p_user_id IS NULL
    OR c.id = p_user_id
  ) AND (
    p_start IS NULL
    OR o."createdAt" >= p_start
  ) AND (
    p_end IS NULL
    OR o."createdAt" <= p_end
  ) AND o."status" IN ('delivered', 'cancelled')
  ORDER BY o."createdAt"
  LIMIT p_limit
  OFFSET p_offset;
END;
$$;


ALTER FUNCTION public.search_customer_history(p_user_id integer, p_start timestamp with time zone, p_end timestamp with time zone, p_limit integer, p_offset integer) OWNER TO postgres;

--
-- Name: search_marts(character varying, numeric, numeric); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.search_marts(p_search_term character varying, p_customer_latitude numeric, p_customer_longitude numeric) RETURNS TABLE(id integer, user_name character varying, cellphone_number character varying, email character varying, name character varying, description text, latitude numeric, longitude numeric, location_name character varying, status public.enum_stores_status, stature public.enum_stores_stature, contract_type public.enum_stores_contract_type, category character varying, country character varying, state character varying, city character varying, barangay character varying, rating numeric, logo_url text, photo_url text, sunday boolean, sunday_opening_time time without time zone, sunday_closing_time time without time zone, monday boolean, monday_opening_time time without time zone, monday_closing_time time without time zone, tuesday boolean, tuesday_opening_time time without time zone, tuesday_closing_time time without time zone, wednesday boolean, wednesday_opening_time time without time zone, wednesday_closing_time time without time zone, thursday boolean, thursday_opening_time time without time zone, thursday_closing_time time without time zone, friday boolean, friday_opening_time time without time zone, friday_closing_time time without time zone, saturday boolean, saturday_opening_time time without time zone, saturday_closing_time time without time zone, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone, distance double precision)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT t.* FROM (
    SELECT
      s.id AS id,
      u.name AS user_name,
      u.cellphone_number AS cellphone_number,
      u.email AS email,
      s.name AS mart_name,
      s.description AS description,
      s.latitude AS latitude,
      s.longitude AS longitude,
      s.location_name AS location_name,
      s.status AS status,
      s.stature AS stature,
      s.contract_type AS contract_type,
      s.category AS category,
      s.country AS country,
      s.state AS state,
      s.city AS city,
      s.barangay AS barangay,
      s.rating AS rating,
      s.logo_url AS logo_url,
      s.photo_url AS photo_url,
      s.sunday AS sunday,
      s.sunday_opening_time AS sunday_opening_time,
      s.sunday_closing_time AS sunday_closing_time,
      s.monday AS monday,
      s.monday_opening_time AS monday_opening_time,
      s.monday_closing_time AS monday_closing_time,
      s.tuesday AS tuesday,
      s.tuesday_opening_time AS tuesday_opening_time,
      s.tuesday_closing_time AS tuesday_closing_time,
      s.wednesday AS wednesday,
      s.wednesday_opening_time AS wednesday_opening_time,
      s.wednesday_closing_time AS wednesday_closing_time,
      s.thursday AS thursday,
      s.thursday_opening_time AS thursday_opening_time,
      s.thursday_closing_time AS thursday_closing_time,
      s.friday AS friday,
      s.friday_opening_time AS friday_opening_time,
      s.friday_closing_time AS friday_closing_time,
      s.saturday AS saturday,
      s.saturday_opening_time AS saturday_opening_time,
      s.saturday_closing_time AS saturday_closing_time,
      s."createdAt" AS "createdAt",
      s."updatedAt" AS "updatedAt",
      (6371 * acos (cos ( radians(p_customer_latitude) ) * cos( radians( s.latitude ) ) * cos( radians( s.longitude ) - radians(p_customer_longitude) ) + sin ( radians(p_customer_latitude) ) * sin( radians( s.latitude ) ))) AS distance
    FROM public.stores AS s
    INNER JOIN public.users AS u
      ON s.user_id = u.id
    WHERE s.type = 'mart'
    AND (
      p_search_term IS NULL
      OR LOWER(s.name) LIKE CONCAT('%', LOWER(p_search_term), '%')
    ) ORDER BY s.name
  ) t WHERE t.distance <= 5 ;
END;
$$;


ALTER FUNCTION public.search_marts(p_search_term character varying, p_customer_latitude numeric, p_customer_longitude numeric) OWNER TO postgres;

--
-- Name: search_menus(integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.search_menus(p_store_id integer, p_term character varying) RETURNS TABLE(id integer, store_id integer, name character varying, description text, image text, price numeric, customer_price numeric, seller_price numeric, choices text, additionals text, quantity integer, max_order integer, category character varying, status public.enum_store_products_status, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    m.id AS id,
    m.store_id AS store_id,
    m.name AS name,
    m.description AS description,
    m.image AS image,
    m.price AS price,
    m.customer_price AS customer_price,
    m.seller_price AS seller_price,
    m.choices AS choices,
    m.additionals AS additionals,
    m.quantity AS quantity,
    m.max_order AS max_order,
    m.category AS category,
    m.status AS status,
    m."createdAt" AS "createdAt",
    m."updatedAt" AS "updatedAt"
  FROM
    public.store_products AS m
  WHERE m.store_id = p_store_id
  AND (
    p_term IS NULL
    OR m.name LIKE CONCAT('%', p_term, '%')
  );
END;
$$;


ALTER FUNCTION public.search_menus(p_store_id integer, p_term character varying) OWNER TO postgres;

--
-- Name: search_partner_history(integer, timestamp with time zone, timestamp with time zone, character varying, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.search_partner_history(p_store_id integer, p_start timestamp with time zone, p_end timestamp with time zone, p_query character varying, p_limit integer, p_offset integer) RETURNS TABLE(order_id integer, customer_id integer, rider_id integer, rider_user_id integer, store_id integer, customer_name character varying, rider_name character varying, store_name character varying, store_type public.enum_stores_type, order_status public.enum_orders_status, products json, fee json, timeframe json, order_address json, payment json, reason text, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    o.id as order_id,
    c.id as customer_id,
    r.id as rider_id,
    u.id as rider_user_id,
    s.id as store_id,
    c.name as customer_name,
    u.name as rider_name,
    s.name as store_name,
    s.type as store_type,
    o.status as order_status,
    JSON(o.products) as products,
    JSON(o.fee) as fee,
    JSON(o.timeframe) as timeframe,
    JSON(o.address) as order_address,
    JSON(o.payment) as payment,
    o.reason as reason,
    o."createdAt" as "createdAt",
    o."updatedAt" as "updatedAt"
  FROM public.orders as o
  INNER JOIN public.users as c
    ON o.user_id = c.id
  INNER JOIN public.riders as r
    ON o.rider_id = r.id
  INNER JOIN public.users as u
    ON r.user_id = u.id
  INNER JOIN public.stores as s
    ON o.store_id = s.id
  WHERE (
    p_store_id IS NULL
    OR s.id = p_store_id
  ) AND (
    p_start IS NULL
    OR o."createdAt" >= p_start
    OR o."updatedAt" >= p_start
  ) AND (
    p_end IS NULL
    OR o."createdAt" <= p_end
    OR o."updatedAt" <= p_end
  ) AND (
    o.status IN ('delivered', 'store-declined')
  ) AND (
    p_query IS NULL
    OR LOWER(c.name) LIKE CONCAT('%', LOWER(p_query), '%')
    OR LOWER(s.name) LIKE CONCAT('%', LOWER(p_query), '%')
    OR LOWER(u.name) LIKE CONCAT('%', LOWER(p_query), '%')
  )
  ORDER BY o."createdAt"
  LIMIT p_limit
  OFFSET p_offset;
END;
$$;


ALTER FUNCTION public.search_partner_history(p_store_id integer, p_start timestamp with time zone, p_end timestamp with time zone, p_query character varying, p_limit integer, p_offset integer) OWNER TO postgres;

--
-- Name: search_partner_stats(integer, timestamp with time zone, timestamp with time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.search_partner_stats(p_store_id integer, p_start timestamp with time zone, p_end timestamp with time zone) RETURNS TABLE(total_sales numeric, total_delivery numeric, pending_count bigint, total_pending numeric, accepted_count bigint, total_accepted numeric, declined_count bigint, total_declined numeric, delivered_count bigint, total_delivered numeric, cancelled_count bigint, total_cancelled numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    COALESCE(SUM((JSON(fee) ->> 'seller_total_price')::decimal), 0) AS total_sales,
    COALESCE(SUM((JSON(fee) ->> 'delivery')::decimal), 0) AS total_delivery,
    COUNT(o.id) FILTER (where o.status = 'pending') AS pending_count,
    COALESCE(SUM(CASE WHEN o.status = 'pending' THEN (JSON(o.fee) ->> 'seller_total_price')::decimal ELSE 0 END), 0) AS total_pending,
    COUNT(o.id) FILTER (where o.status = 'store-accepted') AS accepted_count,
    COALESCE(SUM(CASE WHEN o.status = 'store-accepted' THEN (JSON(o.fee) ->> 'seller_total_price')::decimal ELSE 0 END), 0) AS total_accepted,
    COUNT(o.id) FILTER (where o.status = 'store-declined') AS declined_count,
    COALESCE(SUM(CASE WHEN o.status = 'store-declined' THEN (JSON(o.fee) ->> 'seller_total_price')::decimal ELSE 0 END), 0) AS total_declined,
    COUNT(o.id) FILTER (where o.status = 'delivered') AS delivered_count,
    COALESCE(SUM(CASE WHEN o.status = 'delivered' THEN (JSON(o.fee) ->> 'seller_total_price')::decimal ELSE 0 END), 0) AS total_delivered,
    COUNT(o.id) FILTER (where o.status = 'cancelled') AS cancelled_count,
    COALESCE(SUM(CASE WHEN o.status = 'cancelled' THEN (JSON(o.fee) ->> 'seller_total_price')::decimal ELSE 0 END), 0) AS total_cancelled
  FROM public.orders AS o
  WHERE (
    p_store_id IS NULL
    OR o.store_id = p_store_id
  ) AND (
    p_start IS NULL
    OR o."createdAt" >= p_start
  ) AND (
    p_end IS NULL
    OR o."createdAt" <= p_end
  );
END;
$$;


ALTER FUNCTION public.search_partner_stats(p_store_id integer, p_start timestamp with time zone, p_end timestamp with time zone) OWNER TO postgres;

--
-- Name: search_product_categories(integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.search_product_categories(p_user_id integer, p_query character varying) RETURNS TABLE(category character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    sp.category AS category
  FROM public.store_products AS sp
  INNER JOIN public.stores AS s
    ON sp.store_id = s.id
  WHERE s.user_id = p_user_id
  AND (
    p_query IS NULL
    OR LOWER(sp.category) LIKE CONCAT('%', LOWER(p_query), '%') 
  )
  GROUP BY sp.category
  ORDER BY sp.category;
END;
$$;


ALTER FUNCTION public.search_product_categories(p_user_id integer, p_query character varying) OWNER TO postgres;

--
-- Name: search_products(integer, character varying, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.search_products(p_user_id integer, p_query character varying, p_limit integer, p_offset integer) RETURNS TABLE(id integer, product_name character varying, product_description text, product_image text, price numeric, customer_price numeric, seller_price numeric, variants json, additionals json, quantity integer, max_order integer, category character varying, product_status public.enum_store_products_status, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone, total_count bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    sp.id AS id,
    sp.name AS product_name,
    sp.description AS product_description,
    sp.image AS product_image,
    sp.price AS price,
    sp.customer_price AS customer_price,
    sp.seller_price AS seller_price,
    (
      SELECT
        json_agg(
          json_build_object(
            'id', v.id,
            'type', v.type,
            'status', v.status,
            'options', tmp.variant_options
          )
        )
      FROM public.variants AS v
      LEFT JOIN (
        SELECT
          json_agg(vo.*) AS variant_options, vo.variant_id AS variant_id
        FROM public.variant_options AS vo
        GROUP BY vo.variant_id
      ) AS tmp ON tmp.variant_id = v.id
      WHERE v.id = ANY(
        REPLACE(
          REPLACE(
            sp.variants,
            '[',
            '{'
          ),
          ']',
          '}'
        )::int[]
      )
    ) AS variants,
    (
      SELECT json_agg(ad.*)
      FROM public.additionals AS ad
      WHERE ad.id = ANY(
          REPLACE(
            REPLACE(
              sp.additionals,
              '[',
              '{'
            ),
            ']',
            '}'
          )::int[]
        )
    ) AS additionals,
    sp.quantity AS quantity,
    sp.max_order AS max_order,
    sp.category AS category,
    sp.status AS product_status,
    sp."createdAt" AS "createdAt",
    sp."updatedAt" AS "updatedAt",
  COUNT(sp.id) OVER() AS total_count
  FROM public.store_products AS sp
  INNER JOIN public.stores AS s
    ON sp.store_id = s.id
  WHERE s.user_id = p_user_id
  AND (
    p_query IS NULL
    OR LOWER(sp.name) LIKE CONCAT('%', LOWER(p_query), '%')
  )
  GROUP BY sp.id
  ORDER BY sp.name
  LIMIT p_limit
  OFFSET p_offset;
END;
$$;


ALTER FUNCTION public.search_products(p_user_id integer, p_query character varying, p_limit integer, p_offset integer) OWNER TO postgres;

--
-- Name: search_restaurants(character varying, numeric, numeric); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.search_restaurants(p_search_term character varying, p_customer_latitude numeric, p_customer_longitude numeric) RETURNS TABLE(id integer, user_name character varying, cellphone_number character varying, email character varying, name character varying, description text, latitude numeric, longitude numeric, location_name character varying, status public.enum_stores_status, stature public.enum_stores_stature, contract_type public.enum_stores_contract_type, category character varying, country character varying, state character varying, city character varying, barangay character varying, rating numeric, logo_url text, photo_url text, sunday boolean, sunday_opening_time time without time zone, sunday_closing_time time without time zone, monday boolean, monday_opening_time time without time zone, monday_closing_time time without time zone, tuesday boolean, tuesday_opening_time time without time zone, tuesday_closing_time time without time zone, wednesday boolean, wednesday_opening_time time without time zone, wednesday_closing_time time without time zone, thursday boolean, thursday_opening_time time without time zone, thursday_closing_time time without time zone, friday boolean, friday_opening_time time without time zone, friday_closing_time time without time zone, saturday boolean, saturday_opening_time time without time zone, saturday_closing_time time without time zone, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone, distance double precision)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT t.* FROM (
    SELECT
      s.id AS id,
      u.name AS user_name,
      u.cellphone_number AS cellphone_number,
      u.email AS email,
      s.name AS restaurant_name,
      s.description AS description,
      s.latitude AS latitude,
      s.longitude AS longitude,
      s.location_name AS location_name,
      s.status AS status,
      s.stature AS stature,
      s.contract_type AS contract_type,
      s.category AS category,
      s.country AS country,
      s.state AS state,
      s.city AS city,
      s.barangay AS barangay,
      s.rating AS rating,
      s.logo_url AS logo_url,
      s.photo_url AS photo_url,
      s.sunday AS sunday,
      s.sunday_opening_time AS sunday_opening_time,
      s.sunday_closing_time AS sunday_closing_time,
      s.monday AS monday,
      s.monday_opening_time AS monday_opening_time,
      s.monday_closing_time AS monday_closing_time,
      s.tuesday AS tuesday,
      s.tuesday_opening_time AS tuesday_opening_time,
      s.tuesday_closing_time AS tuesday_closing_time,
      s.wednesday AS wednesday,
      s.wednesday_opening_time AS wednesday_opening_time,
      s.wednesday_closing_time AS wednesday_closing_time,
      s.thursday AS thursday,
      s.thursday_opening_time AS thursday_opening_time,
      s.thursday_closing_time AS thursday_closing_time,
      s.friday AS friday,
      s.friday_opening_time AS friday_opening_time,
      s.friday_closing_time AS friday_closing_time,
      s.saturday AS saturday,
      s.saturday_opening_time AS saturday_opening_time,
      s.saturday_closing_time AS saturday_closing_time,
      s."createdAt" AS "createdAt",
      s."updatedAt" AS "updatedAt",
      (6371 * acos (cos ( radians(p_customer_latitude) ) * cos( radians( s.latitude ) ) * cos( radians( s.longitude ) - radians(p_customer_longitude) ) + sin ( radians(p_customer_latitude) ) * sin( radians( s.latitude ) ))) AS distance
    FROM public.stores AS s
    INNER JOIN public.users AS u
      ON s.user_id = u.id
    WHERE s.type = 'restaurant'
    AND (
      p_search_term IS NULL
      OR LOWER(s.name) LIKE CONCAT('%', p_search_term, '%')
    ) ORDER BY s.name
  ) t WHERE t.distance <= 5 ;
END;
$$;


ALTER FUNCTION public.search_restaurants(p_search_term character varying, p_customer_latitude numeric, p_customer_longitude numeric) OWNER TO postgres;

--
-- Name: search_riders(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.search_riders(p_query character varying) RETURNS TABLE(id integer, rider_id integer, name character varying, email character varying, cellphone_number character varying, cellphone_status integer, status boolean, latitude numeric, longitude numeric, motorcycle_details text, createdat timestamp with time zone, updatedat timestamp with time zone, total_count bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    u.id,
    r.id,
    u.name,
    u.email,
    u.cellphone_number,
    u.cellphone_status,
    u.status,
    r.latitude,
    r.longitude,
    r.motorcycle_details,
    u."createdAt",
    u."updatedAt",
    COUNT(*) OVER () AS total_count
  FROM public.users as u
  LEFT JOIN public.riders as r
    ON u.id = r.user_id
  WHERE 
    (
        p_query IS NULL 
        OR LOWER(u.name) LIKE CONCAT('%', p_query, '%')
        OR LOWER(u.email) LIKE CONCAT('%', p_query, '%')
        OR u.cellphone_number LIKE CONCAT('%', p_query, '%')
    )
    AND u.role = 'rider'
  ORDER BY
    u.name ASC;
END;
$$;


ALTER FUNCTION public.search_riders(p_query character varying) OWNER TO postgres;

--
-- Name: search_riders_history(integer, timestamp with time zone, timestamp with time zone, character varying, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.search_riders_history(p_rider_id integer, p_start timestamp with time zone, p_end timestamp with time zone, p_query character varying, p_limit integer, p_offset integer) RETURNS TABLE(order_id integer, customer_id integer, rider_id integer, rider_user_id integer, store_id integer, customer_name character varying, rider_name character varying, store_name character varying, order_status public.enum_orders_status, products json, fee json, timeframe json, order_address json, payment json, reason text, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    o.id as order_id,
    c.id as customer_id,
    r.id as rider_id,
    u.id as rider_user_id,
    s.id as store_id,
    c.name as customer_name,
    u.name as rider_name,
    s.name as store_name,
    o.status as order_status,
    JSON(o.products) as products,
    JSON(o.fee) as fee,
    JSON(o.timeframe) as timeframe,
    JSON(o.address) as order_address,
    JSON(o.payment) as payment,
    o.reason as reason,
    o."createdAt" as "createdAt",
    o."updatedAt" as "updatedAt"
  FROM public.orders as o
  INNER JOIN public.users as c
    ON o.user_id = c.id
  INNER JOIN public.riders as r
    ON o.rider_id = r.id
  INNER JOIN public.users as u
    ON r.user_id = u.id
  INNER JOIN public.stores as s
    ON o.store_id = s.id
  WHERE (
    p_rider_id IS NULL
    OR r.id = p_rider_id
  ) AND (
    p_start IS NULL
    OR o."createdAt" >= p_start
    OR o."updatedAt" >= p_start
  ) AND (
    p_end IS NULL
    OR o."createdAt" <= p_end
    OR o."updatedAt" <= p_end
  ) AND (
    o.status = 'delivered'
  ) AND (
    p_query IS NULL
    OR LOWER(c.name) LIKE CONCAT('%', LOWER(p_query), '%')
    OR LOWER(s.name) LIKE CONCAT('%', LOWER(p_query), '%')
    OR LOWER(u.name) LIKE CONCAT('%', LOWER(p_query), '%')
  )
  ORDER BY o."createdAt"
  LIMIT p_limit
  OFFSET p_offset;
END;
$$;


ALTER FUNCTION public.search_riders_history(p_rider_id integer, p_start timestamp with time zone, p_end timestamp with time zone, p_query character varying, p_limit integer, p_offset integer) OWNER TO postgres;

--
-- Name: search_riders_stats(integer, timestamp with time zone, timestamp with time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.search_riders_stats(p_rider_id integer, p_start timestamp with time zone, p_end timestamp with time zone) RETURNS TABLE(total_count bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    COUNT(o.id) AS total_count
  FROM public.orders AS o
  WHERE (
    p_rider_id IS NULL
    OR o.rider_id = p_rider_id
  ) AND (
    p_start IS NULL
    OR o."createdAt" >= p_start
  ) AND (
    p_end IS NULL
    OR o."createdAt" <= p_end
  ) AND status = 'delivered';
END;
$$;


ALTER FUNCTION public.search_riders_stats(p_rider_id integer, p_start timestamp with time zone, p_end timestamp with time zone) OWNER TO postgres;

--
-- Name: search_store_applications(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.search_store_applications(p_query character varying) RETURNS TABLE(id integer, business_name character varying, business_type public.enum_store_applications_business_type, district_id integer, district_name character varying, contact_person character varying, email character varying, contact_number character varying, business_address character varying, status public.enum_store_applications_status, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
    SELECT
      a.id AS id,
      a.business_name AS business_name,
      a.business_type AS business_type,
      a.district_id AS district_id,
      d.name AS district_name,
      a.contact_person AS contact_person,
      a.email AS email,
      a.contact_number AS contact_number,
      a.business_address AS business_address,
      a.status AS status,
      a."createdAt" AS "createdAt",
      a."updatedAt" AS "updatedAt"
    FROM public.store_applications AS a
    LEFT JOIN public.districts AS d
      ON a.district_id = d.id
    WHERE (
      p_query IS NULL
      OR LOWER(a.business_name) LIKE CONCAT('%', LOWER(p_query), '%')
      OR LOWER(a.business_type::text) LIKE CONCAT('%', LOWER(p_query), '%')
      OR LOWER(d.name) LIKE CONCAT('%', LOWER(p_query), '%')
      OR LOWER(a.contact_person) LIKE CONCAT('%', LOWER(p_query), '%')
      OR LOWER(a.email) LIKE CONCAT('%', LOWER(p_query), '%')
      OR a.contact_number LIKE CONCAT('%', p_query, '%')
      OR LOWER(a.status::text) LIKE CONCAT('%', LOWER(p_query), '%')
    ) ORDER BY a."createdAt";
END;
$$;


ALTER FUNCTION public.search_store_applications(p_query character varying) OWNER TO postgres;

--
-- Name: search_variant_options(integer, integer, character varying, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.search_variant_options(p_user_id integer, p_variant_id integer, p_query character varying, p_limit integer, p_offset integer) RETURNS TABLE(id integer, variant_id integer, variant_option_name character varying, price numeric, customer_price numeric, seller_price numeric, variant_option_status boolean, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone, total_count bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    vo.id AS id,
    vo.variant_id AS variant_id,
    vo.name AS variant_option_name,
    vo.price AS price,
    vo.customer_price AS customer_price,
    vo.seller_price AS seller_price,
    vo.status AS variant_option_status,
    vo."createdAt" AS "createdAt",
    vo."updatedAt" AS "updatedAt",
    COUNT(vo.id) OVER() AS total_count
  FROM public.variant_options AS vo
  INNER JOIN public.variants AS v
    ON vo.variant_id = v.id
  INNER JOIN public.stores AS s
    ON v.store_id = s.id
  WHERE
    s.user_id = p_user_id
  AND
    vo.variant_id = p_variant_id
  AND (
    p_query IS NULL
    OR LOWER(vo.name) LIKE CONCAT('%', LOWER(p_query), '%')
  )
  ORDER BY vo.name
  LIMIT p_limit
  OFFSET p_offset;
END;
$$;


ALTER FUNCTION public.search_variant_options(p_user_id integer, p_variant_id integer, p_query character varying, p_limit integer, p_offset integer) OWNER TO postgres;

--
-- Name: search_variants(integer, character varying, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.search_variants(p_user_id integer, p_query character varying, p_limit integer, p_offset integer) RETURNS TABLE(id integer, store_id integer, variant_type character varying, variant_status boolean, variant_options json, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone, total_count bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    v.id AS id,
    v.store_id AS store_id,
    v.type AS variant_type,
    v.status AS variant_status,
    (
      SELECT
        json_agg(
          json_build_object(
            'id', vo.id,
            'variant_id', vo.variant_id,
            'variant_option_name', vo.name,
            'price', vo.price,
            'customer_price', vo.customer_price,
            'seller_price', vo.seller_price,
            'variant_option_status', vo.status,
            'createdAt', vo."createdAt",
            'updatedAt', vo."updatedAt"
		      )
        )
      FROM public.variant_options AS vo
      WHERE vo.variant_id = v.id
    ) AS variant_options,
    v."createdAt" AS "createdAt",
    v."updatedAt" AS "updatedAt",
    COUNT(v.id) OVER() AS total_count
  FROM public.variants AS v
  INNER JOIN public.stores AS s
    ON v.store_id = s.id
  WHERE s.user_id = p_user_id
  AND (
    p_query IS NULL
    OR LOWER(v.type) LIKE CONCAT('%', LOWER(p_query), '%')
  )
  ORDER BY v.type
  LIMIT p_limit
  OFFSET p_offset;
END;
$$;


ALTER FUNCTION public.search_variants(p_user_id integer, p_query character varying, p_limit integer, p_offset integer) OWNER TO postgres;

--
-- Name: update_addon(integer, integer, character varying, numeric, numeric, numeric, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_addon(p_user_id integer, p_addon_id integer, p_name character varying, p_price numeric, p_customer_price numeric, p_seller_price numeric, p_status boolean) RETURNS TABLE(status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Additional successfully updated!';
BEGIN
  IF NOT EXISTS (
    SELECT
      ao.id
    FROM public.additionals AS ao
    INNER JOIN public.stores AS s
      ON ao.store_id = s.id
    WHERE
      ao.id = p_addon_id
    AND
      s.user_id = p_user_id
  ) THEN
    v_status := 'warning';
    v_message := 'The addon you are trying to update does not exist.';
    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  IF EXISTS (
    SELECT
      ao.id
    FROM public.additionals AS ao
    INNER JOIN public.stores AS s
      ON ao.store_id = s.id
    WHERE s.user_id = p_user_id
    AND ao.name = p_name
    AND ao.id != p_addon_id
  ) THEN
    v_status := 'warning';
    v_message := CONCAT(p_name, ' already exists!');
    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  UPDATE public.additionals AS ao
  SET
    "name" = p_name,
    price = p_price,
    customer_price = p_customer_price,
    seller_price = p_seller_price,
    "status" = p_status,
    "updatedAt" = now()
  WHERE ao.id = p_addon_id;

  RETURN QUERY
  SELECT v_status, v_message;
END;
$$;


ALTER FUNCTION public.update_addon(p_user_id integer, p_addon_id integer, p_name character varying, p_price numeric, p_customer_price numeric, p_seller_price numeric, p_status boolean) OWNER TO postgres;

--
-- Name: update_addon_status(integer, integer, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_addon_status(p_user_id integer, p_addon_id integer, p_status boolean) RETURNS TABLE(status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Additional status successfully updated!';
BEGIN
  IF NOT EXISTS (
    SELECT
      ao.id
    FROM public.additionals AS ao
    INNER JOIN public.stores AS s
      ON ao.store_id = s.id
    WHERE
      ao.id = p_addon_id
    AND
      s.user_id = p_user_id
  ) THEN
    v_status := 'warning';
    v_message := 'The addon you are trying to update does not exist.';
    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  UPDATE public.additionals AS ao
  SET
    "status" = p_status,
    "updatedAt" = now()
  WHERE ao.id = p_addon_id;

  RETURN QUERY
  SELECT v_status, v_message;
END;
$$;


ALTER FUNCTION public.update_addon_status(p_user_id integer, p_addon_id integer, p_status boolean) OWNER TO postgres;

--
-- Name: update_mart(integer, character varying, character varying, character varying, character varying, character varying, numeric, numeric, character varying, public.enum_stores_contract_type, character varying, character varying, character varying, character varying, character varying, text, text, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_mart(p_mart_id integer, p_user_name character varying, p_email character varying, p_cellphone_number character varying, p_store_name character varying, p_description character varying, p_latitude numeric, p_longitude numeric, p_location_name character varying, p_contract_type public.enum_stores_contract_type, p_category character varying, p_country character varying, p_state character varying, p_city character varying, p_barangay character varying, p_logo_url text, p_photo_url text, p_sunday boolean, p_sunday_opening_time time without time zone, p_sunday_closing_time time without time zone, p_monday boolean, p_monday_opening_time time without time zone, p_monday_closing_time time without time zone, p_tuesday boolean, p_tuesday_opening_time time without time zone, p_tuesday_closing_time time without time zone, p_wednesday boolean, p_wednesday_opening_time time without time zone, p_wednesday_closing_time time without time zone, p_thursday boolean, p_thursday_opening_time time without time zone, p_thursday_closing_time time without time zone, p_friday boolean, p_friday_opening_time time without time zone, p_friday_closing_time time without time zone, p_saturday boolean, p_saturday_opening_time time without time zone, p_saturday_closing_time time without time zone) RETURNS TABLE(mart_id integer, user_id integer, status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_mart_id INT := 0;
  v_user_id INT := 0;
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Mart successfully updated!';
BEGIN
  IF NOT EXISTS(SELECT s.id FROM public.stores AS s WHERE s.id = p_mart_id) THEN
    v_status := 'warning';
    v_message := 'This mart does not exist.';
    RETURN QUERY SELECT v_mart_id, v_user_id, v_status, v_message;
    RETURN;
  END IF;

  IF EXISTS(SELECT s.id FROM public.users AS u INNER JOIN public.stores AS s ON u.id = s.user_id WHERE u.email = p_email AND s.id != p_mart_id) THEN
    v_status := 'warning';
    v_message := 'The email address you entered for this mart already belongs another mart.';
    RETURN QUERY SELECT v_mart_id, v_user_id, v_status, v_message;
    RETURN;
  END IF;

  UPDATE public.users AS u
	SET
		name = p_user_name,
		email = p_email,
		cellphone_number = p_cellphone_number,
		"updatedAt" = now()
	FROM public.stores AS s
		WHERE u.id = s.user_id
		AND s.id = p_mart_id;

  UPDATE public.stores
    SET
      name = p_store_name,
      description = p_description,
      latitude = p_latitude,
      longitude = p_longitude,
      location_name = p_location_name,
      contract_type = p_contract_type,
      category = p_category,
      country = p_country,
      state = p_state,
      city = p_city,
      barangay = p_barangay,
      logo_url = p_logo_url,
      photo_url = p_photo_url,
      sunday = p_sunday,
      sunday_opening_time = p_sunday_opening_time,
      sunday_closing_time = p_sunday_closing_time,
      monday = p_monday,
      monday_opening_time = p_monday_opening_time,
      monday_closing_time = p_monday_closing_time,
      tuesday = p_tuesday,
      tuesday_opening_time = p_tuesday_opening_time,
      tuesday_closing_time = p_tuesday_closing_time,
      wednesday = p_wednesday,
      wednesday_opening_time = p_wednesday_opening_time,
      wednesday_closing_time = p_wednesday_closing_time,
      thursday = p_thursday,
      thursday_opening_time = p_thursday_opening_time,
      thursday_closing_time = p_thursday_closing_time,
      friday = p_friday,
      friday_opening_time = p_friday_opening_time,
      friday_closing_time = p_friday_closing_time,
      saturday = p_saturday,
      saturday_opening_time = p_saturday_opening_time,
      saturday_closing_time = p_saturday_closing_time,
      "updatedAt" = now()
    WHERE id = p_mart_id;
  
  RETURN QUERY
    SELECT v_mart_id, v_user_id, v_status, v_message;
END;
$$;


ALTER FUNCTION public.update_mart(p_mart_id integer, p_user_name character varying, p_email character varying, p_cellphone_number character varying, p_store_name character varying, p_description character varying, p_latitude numeric, p_longitude numeric, p_location_name character varying, p_contract_type public.enum_stores_contract_type, p_category character varying, p_country character varying, p_state character varying, p_city character varying, p_barangay character varying, p_logo_url text, p_photo_url text, p_sunday boolean, p_sunday_opening_time time without time zone, p_sunday_closing_time time without time zone, p_monday boolean, p_monday_opening_time time without time zone, p_monday_closing_time time without time zone, p_tuesday boolean, p_tuesday_opening_time time without time zone, p_tuesday_closing_time time without time zone, p_wednesday boolean, p_wednesday_opening_time time without time zone, p_wednesday_closing_time time without time zone, p_thursday boolean, p_thursday_opening_time time without time zone, p_thursday_closing_time time without time zone, p_friday boolean, p_friday_opening_time time without time zone, p_friday_closing_time time without time zone, p_saturday boolean, p_saturday_opening_time time without time zone, p_saturday_closing_time time without time zone) OWNER TO postgres;

--
-- Name: update_mart_stature(integer, public.enum_stores_stature); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_mart_stature(p_mart_id integer, p_stature public.enum_stores_stature) RETURNS TABLE(mart_id integer, status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_mart_id INT := 0;
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Mart status successfully updated';
BEGIN
  IF NOT EXISTS(SELECT s.id FROM public.stores AS s WHERE s.id = p_mart_id) THEN
    v_status := 'warning';
    v_message := 'This mart does not exist.';
    RETURN QUERY SELECT v_mart_id, v_status, v_message;
    RETURN;
  END IF;

  UPDATE public.stores AS s
  SET
    stature = p_stature
  WHERE
    s.id = p_mart_id;

  RETURN QUERY
    SELECT v_mart_id, v_status, v_message;
END;
$$;


ALTER FUNCTION public.update_mart_stature(p_mart_id integer, p_stature public.enum_stores_stature) OWNER TO postgres;

--
-- Name: update_menu(integer, integer, character varying, text, text, numeric, numeric, numeric, text, text, integer, integer, character varying, public.enum_store_products_status); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_menu(p_id integer, p_store_id integer, p_name character varying, p_description text, p_image text, p_price numeric, p_customer_price numeric, p_seller_price numeric, p_choices text, p_additionals text, p_quantity integer, p_max_order integer, p_category character varying, p_status public.enum_store_products_status) RETURNS TABLE(status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Menu successfully updated!';
BEGIN
  UPDATE public.store_products
  SET
    store_id = p_store_id,
    name = p_name,
    description = p_description,
    image = p_image,
    price = p_price,
    customer_price = p_customer_price,
    seller_price = p_seller_price,
    choices = p_choices,
    additionals = p_additionals,
    quantity = p_quantity,
    max_order = p_max_order,
    category = p_category,
    status = p_status,
    "updatedAt" = now()
  WHERE id = p_id;

  RETURN QUERY
    SELECT v_status, v_message;
END;
$$;


ALTER FUNCTION public.update_menu(p_id integer, p_store_id integer, p_name character varying, p_description text, p_image text, p_price numeric, p_customer_price numeric, p_seller_price numeric, p_choices text, p_additionals text, p_quantity integer, p_max_order integer, p_category character varying, p_status public.enum_store_products_status) OWNER TO postgres;

--
-- Name: update_product(integer, integer, character varying, text, text, numeric, numeric, numeric, text, text, integer, integer, character varying, public.enum_store_products_status); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_product(p_user_id integer, p_product_id integer, p_name character varying, p_description text, p_image text, p_price numeric, p_customer_price numeric, p_seller_price numeric, p_variants text, p_additionals text, p_quantity integer, p_max_order integer, p_category character varying, p_status public.enum_store_products_status) RETURNS TABLE(status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Product successfully updated!';
BEGIN
  IF NOT EXISTS (
    SELECT sp.id FROM public.store_products AS sp
    INNER JOIN public.stores AS s
      ON s.id = sp.store_id
    WHERE
      sp.id = p_product_id
    AND
      s.user_id = p_user_id
  ) THEN
    v_status := 'warning';
    v_message := 'The product you are trying to update does not exist.';
    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  IF EXISTS (
		SELECT
			sp.id
		FROM public.store_products AS sp
		INNER JOIN public.stores AS s
			ON sp.store_id = s.id
		WHERE
			sp.name = p_name
		AND
			s.user_id = p_user_id
    AND sp.id != p_product_id
	) THEN
		v_status := 'warning';
    v_message := CONCAT(p_name, ' already exists! Please enter a different name.');
    RETURN QUERY SELECT v_status, v_message;
		RETURN;
	END IF;

  UPDATE public.store_products AS sp
  SET
    name = p_name,
    description = p_description,
    image = COALESCE(p_image, image),
    price = p_price,
    customer_price = p_customer_price,
    seller_price = p_seller_price,
    variants = p_variants,
    additionals = p_additionals,
    quantity = p_quantity,
    max_order = p_max_order,
    category = p_category,
    status = p_status,
    "updatedAt" = now()
  WHERE sp.id = p_product_id;

  RETURN QUERY
  SELECT v_status, v_message;
END;
$$;


ALTER FUNCTION public.update_product(p_user_id integer, p_product_id integer, p_name character varying, p_description text, p_image text, p_price numeric, p_customer_price numeric, p_seller_price numeric, p_variants text, p_additionals text, p_quantity integer, p_max_order integer, p_category character varying, p_status public.enum_store_products_status) OWNER TO postgres;

--
-- Name: update_product_status(integer, integer, public.enum_store_products_status); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_product_status(p_user_id integer, p_product_id integer, p_status public.enum_store_products_status) RETURNS TABLE(status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Product status successfully updated!';
BEGIN
  IF NOT EXISTS (
    SELECT sp.id FROM public.store_products AS sp
    INNER JOIN public.stores AS s
      ON s.id = sp.store_id
    WHERE
      sp.id = p_product_id
    AND
      s.user_id = p_user_id
  ) THEN
    v_status := 'warning';
    v_message := 'The product you are trying to update does not exist.';
    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  UPDATE public.store_products AS sp
  SET
    status = p_status,
    "updatedAt" = now()
  WHERE sp.id = p_product_id;

  RETURN QUERY
  SELECT v_status, v_message;
END;
$$;


ALTER FUNCTION public.update_product_status(p_user_id integer, p_product_id integer, p_status public.enum_store_products_status) OWNER TO postgres;

--
-- Name: update_restaurant(integer, character varying, character varying, character varying, character varying, character varying, numeric, numeric, character varying, public.enum_stores_contract_type, character varying, character varying, character varying, character varying, character varying, text, text, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_restaurant(p_restaurant_id integer, p_user_name character varying, p_email character varying, p_cellphone_number character varying, p_store_name character varying, p_description character varying, p_latitude numeric, p_longitude numeric, p_location_name character varying, p_contract_type public.enum_stores_contract_type, p_category character varying, p_country character varying, p_state character varying, p_city character varying, p_barangay character varying, p_logo_url text, p_photo_url text, p_sunday boolean, p_sunday_opening_time time without time zone, p_sunday_closing_time time without time zone, p_monday boolean, p_monday_opening_time time without time zone, p_monday_closing_time time without time zone, p_tuesday boolean, p_tuesday_opening_time time without time zone, p_tuesday_closing_time time without time zone, p_wednesday boolean, p_wednesday_opening_time time without time zone, p_wednesday_closing_time time without time zone, p_thursday boolean, p_thursday_opening_time time without time zone, p_thursday_closing_time time without time zone, p_friday boolean, p_friday_opening_time time without time zone, p_friday_closing_time time without time zone, p_saturday boolean, p_saturday_opening_time time without time zone, p_saturday_closing_time time without time zone) RETURNS TABLE(restaurant_id integer, user_id integer, status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_restaurant_id INT := 0;
  v_user_id INT := 0;
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Restaurant successfully updated!';
BEGIN
  IF NOT EXISTS(SELECT s.id FROM public.stores AS s WHERE s.id = p_restaurant_id) THEN
    v_status := 'warning';
    v_message := 'This restaurant does not exist.';
    RETURN QUERY SELECT v_restaurant_id, v_user_id, v_status, v_message;
    RETURN;
  END IF;

  IF EXISTS(SELECT s.id FROM public.users AS u INNER JOIN public.stores AS s ON u.id = s.user_id WHERE u.email = p_email AND s.id != p_restaurant_id) THEN
    v_status := 'warning';
    v_message := 'The email address you entered for this restaurant already belongs another restaurant.';
    RETURN QUERY SELECT v_restaurant_id, v_user_id, v_status, v_message;
    RETURN;
  END IF;

  UPDATE public.users AS u
	SET
		name = p_user_name,
		email = p_email,
		cellphone_number = p_cellphone_number,
		"updatedAt" = now()
	FROM public.stores AS s
		WHERE u.id = s.user_id
		AND s.id = p_restaurant_id;

  UPDATE public.stores
    SET
      name = p_store_name,
      description = p_description,
      latitude = p_latitude,
      longitude = p_longitude,
      location_name = p_location_name,
      contract_type = p_contract_type,
      category = p_category,
      country = p_country,
      state = p_state,
      city = p_city,
      barangay = p_barangay,
      logo_url = p_logo_url,
      photo_url = p_photo_url,
      sunday = p_sunday,
      sunday_opening_time = p_sunday_opening_time,
      sunday_closing_time = p_sunday_closing_time,
      monday = p_monday,
      monday_opening_time = p_monday_opening_time,
      monday_closing_time = p_monday_closing_time,
      tuesday = p_tuesday,
      tuesday_opening_time = p_tuesday_opening_time,
      tuesday_closing_time = p_tuesday_closing_time,
      wednesday = p_wednesday,
      wednesday_opening_time = p_wednesday_opening_time,
      wednesday_closing_time = p_wednesday_closing_time,
      thursday = p_thursday,
      thursday_opening_time = p_thursday_opening_time,
      thursday_closing_time = p_thursday_closing_time,
      friday = p_friday,
      friday_opening_time = p_friday_opening_time,
      friday_closing_time = p_friday_closing_time,
      saturday = p_saturday,
      saturday_opening_time = p_saturday_opening_time,
      saturday_closing_time = p_saturday_closing_time,
      "updatedAt" = now()
    WHERE id = p_restaurant_id;
  
  RETURN QUERY
    SELECT v_restaurant_id, v_user_id, v_status, v_message;
END;
$$;


ALTER FUNCTION public.update_restaurant(p_restaurant_id integer, p_user_name character varying, p_email character varying, p_cellphone_number character varying, p_store_name character varying, p_description character varying, p_latitude numeric, p_longitude numeric, p_location_name character varying, p_contract_type public.enum_stores_contract_type, p_category character varying, p_country character varying, p_state character varying, p_city character varying, p_barangay character varying, p_logo_url text, p_photo_url text, p_sunday boolean, p_sunday_opening_time time without time zone, p_sunday_closing_time time without time zone, p_monday boolean, p_monday_opening_time time without time zone, p_monday_closing_time time without time zone, p_tuesday boolean, p_tuesday_opening_time time without time zone, p_tuesday_closing_time time without time zone, p_wednesday boolean, p_wednesday_opening_time time without time zone, p_wednesday_closing_time time without time zone, p_thursday boolean, p_thursday_opening_time time without time zone, p_thursday_closing_time time without time zone, p_friday boolean, p_friday_opening_time time without time zone, p_friday_closing_time time without time zone, p_saturday boolean, p_saturday_opening_time time without time zone, p_saturday_closing_time time without time zone) OWNER TO postgres;

--
-- Name: update_restaurant_stature(integer, public.enum_stores_stature); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_restaurant_stature(p_restaurant_id integer, p_stature public.enum_stores_stature) RETURNS TABLE(restaurant_id integer, status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_restaurant_id INT := 0;
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Restaurant status successfully updated';
BEGIN
  IF NOT EXISTS(SELECT s.id FROM public.stores AS s WHERE s.id = p_restaurant_id) THEN
    v_status := 'warning';
    v_message := 'This restaurant does not exist.';
    RETURN QUERY SELECT v_restaurant_id, v_status, v_message;
    RETURN;
  END IF;

  UPDATE public.stores AS s
  SET
    stature = p_stature
  WHERE
    s.id = p_restaurant_id;

  RETURN QUERY
    SELECT v_restaurant_id, v_status, v_message;
END;
$$;


ALTER FUNCTION public.update_restaurant_stature(p_restaurant_id integer, p_stature public.enum_stores_stature) OWNER TO postgres;

--
-- Name: update_rider(integer, character varying, character varying, character varying, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_rider(p_id integer, p_name character varying, p_email character varying, p_cellphone_number character varying, p_motorcycle_details text) RETURNS TABLE(status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'The rider has been updated';
BEGIN
  IF NOT EXISTS (SELECT u.id FROM public.users AS u WHERE u.id = p_id) THEN
    v_status := 'warning';
    v_message := 'User does not exist';
    
    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  IF EXISTS (SELECT u.id FROM public.users AS u
      WHERE u.email = p_email AND u.id <> p_id) THEN
    v_status := 'warning';
    v_message := 'Email address already exists';

    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  UPDATE public.users
    SET 
      name = p_name,
      email = p_email,
      cellphone_number = p_cellphone_number,
      "updatedAt" = now()
    WHERE id = p_id;

  UPDATE public.riders
    SET
      motorcycle_details = p_motorcycle_details
    WHERE user_id = p_id;
  
  RETURN QUERY SELECT v_status, v_message;
END;
$$;


ALTER FUNCTION public.update_rider(p_id integer, p_name character varying, p_email character varying, p_cellphone_number character varying, p_motorcycle_details text) OWNER TO postgres;

--
-- Name: update_store(integer, integer, character varying, text, numeric, numeric, character varying, character varying, character varying, character varying, character varying, text, text, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_store(p_store_id integer, p_user_id integer, p_store_name character varying, p_description text, p_latitude numeric, p_longitude numeric, p_category character varying, p_country character varying, p_state character varying, p_city character varying, p_barangay character varying, p_logo_url text, p_photo_url text, p_sunday boolean, p_sunday_opening_time time without time zone, p_sunday_closing_time time without time zone, p_monday boolean, p_monday_opening_time time without time zone, p_monday_closing_time time without time zone, p_tuesday boolean, p_tuesday_opening_time time without time zone, p_tuesday_closing_time time without time zone, p_wednesday boolean, p_wednesday_opening_time time without time zone, p_wednesday_closing_time time without time zone, p_thursday boolean, p_thursday_opening_time time without time zone, p_thursday_closing_time time without time zone, p_friday boolean, p_friday_opening_time time without time zone, p_friday_closing_time time without time zone, p_saturday boolean, p_saturday_opening_time time without time zone, p_saturday_closing_time time without time zone, p_user_name character varying, p_cellphone_number character varying) RETURNS TABLE(status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Store profile successfully updated!';
BEGIN
  UPDATE public.users AS u
    SET
      name = p_user_name,
      cellphone_number = p_cellphone_number,
      "updatedAt" = now()
    WHERE u.id = p_user_id;
  
  UPDATE public.stores AS s
    SET
      name = p_store_name,
      description = p_description,
      latitude = p_latitude,
      longitude = p_longitude,
      category = p_category,
      country = p_country,
      state = p_state,
      city = p_city,
      barangay = p_barangay,
      logo_url = COALESCE(p_logo_url, logo_url),
      photo_url = COALESCE(p_photo_url, photo_url),
      sunday = p_sunday,
      sunday_opening_time = p_sunday_opening_time,
      sunday_closing_time = p_sunday_closing_time,
      monday = p_monday,
      monday_opening_time = p_monday_opening_time,
      monday_closing_time = p_monday_closing_time,
      tuesday = p_tuesday,
      tuesday_opening_time = p_tuesday_opening_time,
      tuesday_closing_time = p_tuesday_closing_time,
      wednesday = p_wednesday,
      wednesday_opening_time = p_wednesday_opening_time,
      wednesday_closing_time = p_wednesday_closing_time,
      thursday = p_thursday,
      thursday_opening_time = p_thursday_opening_time,
      thursday_closing_time = p_thursday_closing_time,
      friday = p_friday,
      friday_opening_time = p_friday_opening_time,
      friday_closing_time = p_friday_closing_time,
      saturday = p_saturday,
      saturday_opening_time = p_saturday_opening_time,
      saturday_closing_time = p_saturday_closing_time,
      "updatedAt" = now()
    WHERE s.id = p_store_id;

    RETURN QUERY
    SELECT v_status, v_message;
END;
$$;


ALTER FUNCTION public.update_store(p_store_id integer, p_user_id integer, p_store_name character varying, p_description text, p_latitude numeric, p_longitude numeric, p_category character varying, p_country character varying, p_state character varying, p_city character varying, p_barangay character varying, p_logo_url text, p_photo_url text, p_sunday boolean, p_sunday_opening_time time without time zone, p_sunday_closing_time time without time zone, p_monday boolean, p_monday_opening_time time without time zone, p_monday_closing_time time without time zone, p_tuesday boolean, p_tuesday_opening_time time without time zone, p_tuesday_closing_time time without time zone, p_wednesday boolean, p_wednesday_opening_time time without time zone, p_wednesday_closing_time time without time zone, p_thursday boolean, p_thursday_opening_time time without time zone, p_thursday_closing_time time without time zone, p_friday boolean, p_friday_opening_time time without time zone, p_friday_closing_time time without time zone, p_saturday boolean, p_saturday_opening_time time without time zone, p_saturday_closing_time time without time zone, p_user_name character varying, p_cellphone_number character varying) OWNER TO postgres;

--
-- Name: update_store_application_status(integer, public.enum_store_applications_status); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_store_application_status(p_id integer, p_status public.enum_store_applications_status) RETURNS TABLE(application_id integer, status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_application_id INT := 0;
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Store application status successfully updated!';
BEGIN
  IF NOT EXISTS(SELECT a.id FROM public.store_applications AS a WHERE a.id = p_id) THEN
    v_status := 'warning';
    v_message := 'The store application you are trying to approve/reject does not exist.';
    RETURN QUERY SELECT v_application_id, v_status, v_message;
    RETURN;
  END IF;

  UPDATE public.store_applications
    SET
      "status" = p_status,
      "updatedAt" = now()
    WHERE "id" = p_id;

  RETURN QUERY
    SELECT v_application_id, v_status, v_message;
END;
$$;


ALTER FUNCTION public.update_store_application_status(p_id integer, p_status public.enum_store_applications_status) OWNER TO postgres;

--
-- Name: update_store_stature(integer, public.enum_stores_stature); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_store_stature(p_user_id integer, p_stature public.enum_stores_stature) RETURNS TABLE(status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Store stature successfully updated!';
BEGIN
  UPDATE public.stores AS s
    SET
      stature = p_stature
    WHERE s.user_id = p_user_id;

    RETURN QUERY
    SELECT v_status, v_message;
END;
$$;


ALTER FUNCTION public.update_store_stature(p_user_id integer, p_stature public.enum_stores_stature) OWNER TO postgres;

--
-- Name: update_variant(integer, integer, character varying, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_variant(p_user_id integer, p_variant_id integer, p_type character varying, p_status boolean) RETURNS TABLE(status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Variant successfully updated!';
BEGIN
  IF NOT EXISTS (
    SELECT
      v.id
    FROM public.variants AS v
    INNER JOIN public.stores AS s
      ON v.store_id = s.id
    WHERE
      v.id = p_variant_id
    AND
      s.user_id = p_user_id
  ) THEN
    v_status := 'warning';
    v_message := 'The variant you are trying to update does not exist.';
    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  IF EXISTS (
    SELECT
      v.id
    FROM public.variants AS v
    INNER JOIN public.stores AS s
      ON v.store_id = s.id
    WHERE s.user_id = p_user_id
    AND v.type = p_type
    AND v.id != p_variant_id
  ) THEN
    v_status := 'warning';
    v_message := CONCAT(p_type, ' already exists!');
    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  UPDATE public.variants AS v
  SET
    "type" = p_type,
    "status" = p_status,
    "updatedAt" = now()
  WHERE v.id = p_variant_id;

  RETURN QUERY
  SELECT v_status, v_message;
END;
$$;


ALTER FUNCTION public.update_variant(p_user_id integer, p_variant_id integer, p_type character varying, p_status boolean) OWNER TO postgres;

--
-- Name: update_variant_option(integer, integer, character varying, numeric, numeric, numeric, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_variant_option(p_user_id integer, p_variant_option_id integer, p_name character varying, p_price numeric, p_customer_price numeric, p_seller_price numeric, p_status boolean) RETURNS TABLE(status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Variant status successfully updated!';
BEGIN
  IF NOT EXISTS (
    SELECT
      vo.id
    FROM public.variant_options AS vo
    INNER JOIN public.variants AS v
      ON vo.variant_id = v.id
    INNER JOIN public.stores AS s
      ON v.store_id = s.id
    WHERE
      vo.id = p_variant_option_id
    AND
      s.user_id = p_user_id
  ) THEN
    v_status := 'warning';
    v_message := CONCAT(p_variant_option_id, p_user_id, 'The variant you are trying to update does not exist.');
    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  IF EXISTS (
    SELECT
      vo.id
    FROM public.variant_options AS vo
    WHERE vo.name = p_name
    AND vo.id != p_variant_option_id
  ) THEN
    v_status := 'warning';
    v_message := CONCAT(p_name, ' already exists! Please enter a different name');
    RETURN QUERY
      SELECT v_variant_option_id, v_status, v_message;
    RETURN;
  END IF;

  UPDATE public.variant_options AS v
  SET
    "name" = p_name,
    price = p_price,
    customer_price = p_customer_price,
    seller_price = p_seller_price,
    "status" = p_status,
    "updatedAt" = now()
  WHERE v.id = p_variant_option_id;

  RETURN QUERY
  SELECT v_status, v_message;
END;
$$;


ALTER FUNCTION public.update_variant_option(p_user_id integer, p_variant_option_id integer, p_name character varying, p_price numeric, p_customer_price numeric, p_seller_price numeric, p_status boolean) OWNER TO postgres;

--
-- Name: update_variant_option_status(integer, integer, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_variant_option_status(p_user_id integer, p_variant_option_id integer, p_status boolean) RETURNS TABLE(status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Variant option status successfully updated!';
BEGIN
  IF NOT EXISTS (
    SELECT
      vo.id
    FROM public.variant_options AS vo
    INNER JOIN public.variants AS v
      ON vo.variant_id = v.id
    INNER JOIN public.stores AS s
      ON v.store_id = s.id
    WHERE
      vo.id = p_variant_option_id
    AND
      s.user_id = p_user_id
  ) THEN
    v_status := 'warning';
    v_message := 'The variant option you are trying to update does not exist.';
    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  UPDATE public.variant_options AS v
  SET
    "status" = p_status,
    "updatedAt" = now()
  WHERE v.id = p_variant_option_id;

  RETURN QUERY
  SELECT v_status, v_message;
END;
$$;


ALTER FUNCTION public.update_variant_option_status(p_user_id integer, p_variant_option_id integer, p_status boolean) OWNER TO postgres;

--
-- Name: update_variant_status(integer, integer, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_variant_status(p_user_id integer, p_variant_id integer, p_status boolean) RETURNS TABLE(status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Variant status successfully updated!';
BEGIN
  IF NOT EXISTS (
    SELECT
      v.id
    FROM public.variants AS v
    INNER JOIN public.stores AS s
      ON v.store_id = s.id
    WHERE
      v.id = p_variant_id
    AND
      s.user_id = p_user_id
  ) THEN
    v_status := 'warning';
    v_message := 'The variant you are trying to update does not exist.';
    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  UPDATE public.variants AS v
  SET
    "status" = p_status,
    "updatedAt" = now()
  WHERE v.id = p_variant_id;

  RETURN QUERY
  SELECT v_status, v_message;
END;
$$;


ALTER FUNCTION public.update_variant_status(p_user_id integer, p_variant_id integer, p_status boolean) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: additionals; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.additionals (
    id integer NOT NULL,
    store_id integer NOT NULL,
    name character varying(255) NOT NULL,
    price numeric NOT NULL,
    customer_price numeric NOT NULL,
    seller_price numeric NOT NULL,
    status boolean DEFAULT true,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.additionals OWNER TO postgres;

--
-- Name: additionals_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.additionals_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.additionals_id_seq OWNER TO postgres;

--
-- Name: additionals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.additionals_id_seq OWNED BY public.additionals.id;


--
-- Name: carts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.carts (
    id integer NOT NULL,
    store_id integer NOT NULL,
    user_id integer NOT NULL,
    store_product_id integer NOT NULL,
    product_details text NOT NULL,
    total_price numeric(10,2) NOT NULL,
    customer_total_price numeric(10,2) NOT NULL,
    seller_total_price numeric(10,2) NOT NULL,
    choices text,
    additionals text,
    quantity integer DEFAULT 1,
    note text,
    status public.enum_carts_status DEFAULT 'active'::public.enum_carts_status NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.carts OWNER TO postgres;

--
-- Name: carts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.carts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.carts_id_seq OWNER TO postgres;

--
-- Name: carts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.carts_id_seq OWNED BY public.carts.id;


--
-- Name: chats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.chats (
    id integer NOT NULL,
    user_id integer,
    order_id integer,
    message text,
    "createdAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.chats OWNER TO postgres;

--
-- Name: chats_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.chats_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.chats_id_seq OWNER TO postgres;

--
-- Name: chats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.chats_id_seq OWNED BY public.chats.id;


--
-- Name: districts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.districts (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    zip_code integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.districts OWNER TO postgres;

--
-- Name: districts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.districts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.districts_id_seq OWNER TO postgres;

--
-- Name: districts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.districts_id_seq OWNED BY public.districts.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    id integer NOT NULL,
    so_id integer NOT NULL,
    store_id integer NOT NULL,
    user_id integer NOT NULL,
    rider_id integer,
    status public.enum_orders_status DEFAULT 'pending'::public.enum_orders_status NOT NULL,
    products text NOT NULL,
    fee text NOT NULL,
    timeframe text,
    address text NOT NULL,
    payment text NOT NULL,
    contract_type public.enum_orders_contract_type,
    note text,
    reason text,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.orders_id_seq OWNER TO postgres;

--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- Name: rider_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rider_logs (
    id integer NOT NULL,
    rider_id integer NOT NULL,
    status_from integer NOT NULL,
    status_to integer NOT NULL,
    "createdAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.rider_logs OWNER TO postgres;

--
-- Name: rider_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rider_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rider_logs_id_seq OWNER TO postgres;

--
-- Name: rider_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rider_logs_id_seq OWNED BY public.rider_logs.id;


--
-- Name: rider_tracks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rider_tracks (
    id integer NOT NULL,
    rider_id integer NOT NULL,
    order_id integer,
    location character varying(255) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.rider_tracks OWNER TO postgres;

--
-- Name: rider_tracks_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rider_tracks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rider_tracks_id_seq OWNER TO postgres;

--
-- Name: rider_tracks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rider_tracks_id_seq OWNED BY public.rider_tracks.id;


--
-- Name: riders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.riders (
    id integer NOT NULL,
    user_id integer NOT NULL,
    photo text NOT NULL,
    status integer DEFAULT 3,
    latitude numeric(25,20),
    longitude numeric(25,20),
    motorcycle_details text DEFAULT '{"brand":"","model":"","plate_number":"","color":""}'::text NOT NULL,
    "createdAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.riders OWNER TO postgres;

--
-- Name: riders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.riders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.riders_id_seq OWNER TO postgres;

--
-- Name: riders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.riders_id_seq OWNED BY public.riders.id;


--
-- Name: store_applications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.store_applications (
    id integer NOT NULL,
    business_name character varying(255) NOT NULL,
    business_type public.enum_store_applications_business_type DEFAULT 'restaurant'::public.enum_store_applications_business_type NOT NULL,
    district_id integer NOT NULL,
    contact_person character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    contact_number character varying(255) NOT NULL,
    business_address character varying(255) NOT NULL,
    status public.enum_store_applications_status DEFAULT 'pending'::public.enum_store_applications_status NOT NULL,
    tracking_number character varying(255) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.store_applications OWNER TO postgres;

--
-- Name: store_applications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.store_applications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.store_applications_id_seq OWNER TO postgres;

--
-- Name: store_applications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.store_applications_id_seq OWNED BY public.store_applications.id;


--
-- Name: store_products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.store_products (
    id integer NOT NULL,
    store_id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    image text,
    price numeric NOT NULL,
    customer_price numeric NOT NULL,
    seller_price numeric NOT NULL,
    variants text,
    additionals text,
    quantity integer DEFAULT 0,
    max_order integer DEFAULT 0,
    category character varying(255),
    status public.enum_store_products_status DEFAULT 'available'::public.enum_store_products_status,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.store_products OWNER TO postgres;

--
-- Name: store_products_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.store_products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.store_products_id_seq OWNER TO postgres;

--
-- Name: store_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.store_products_id_seq OWNED BY public.store_products.id;


--
-- Name: stores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stores (
    id integer NOT NULL,
    user_id integer,
    district_id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    latitude numeric(25,20) NOT NULL,
    longitude numeric(25,20) NOT NULL,
    location_name character varying(255),
    status public.enum_stores_status DEFAULT 'active'::public.enum_stores_status NOT NULL,
    stature public.enum_stores_stature DEFAULT 'open'::public.enum_stores_stature NOT NULL,
    type public.enum_stores_type NOT NULL,
    contract_type public.enum_stores_contract_type,
    category character varying(255),
    country character varying(255) NOT NULL,
    state character varying(255) NOT NULL,
    city character varying(255) NOT NULL,
    barangay character varying(255) NOT NULL,
    rating numeric(5,2) DEFAULT 0 NOT NULL,
    logo_url text NOT NULL,
    photo_url text,
    sunday boolean DEFAULT false,
    sunday_opening_time time without time zone,
    sunday_closing_time time without time zone,
    monday boolean DEFAULT false,
    monday_opening_time time without time zone,
    monday_closing_time time without time zone,
    tuesday boolean DEFAULT false,
    tuesday_opening_time time without time zone,
    tuesday_closing_time time without time zone,
    wednesday boolean DEFAULT false,
    wednesday_opening_time time without time zone,
    wednesday_closing_time time without time zone,
    thursday boolean DEFAULT false,
    thursday_opening_time time without time zone,
    thursday_closing_time time without time zone,
    friday boolean DEFAULT false,
    friday_opening_time time without time zone,
    friday_closing_time time without time zone,
    saturday boolean DEFAULT false,
    saturday_opening_time time without time zone,
    saturday_closing_time time without time zone,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.stores OWNER TO postgres;

--
-- Name: stores_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stores_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stores_id_seq OWNER TO postgres;

--
-- Name: stores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.stores_id_seq OWNED BY public.stores.id;


--
-- Name: user_addresses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_addresses (
    id integer NOT NULL,
    user_id integer NOT NULL,
    name character varying(255) NOT NULL,
    location character varying(255) NOT NULL,
    address character varying(255) NOT NULL,
    note character varying(255),
    "createdAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.user_addresses OWNER TO postgres;

--
-- Name: user_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_addresses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_addresses_id_seq OWNER TO postgres;

--
-- Name: user_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_addresses_id_seq OWNED BY public.user_addresses.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(255),
    provider public.enum_users_provider DEFAULT 'email'::public.enum_users_provider,
    provider_token text,
    token text,
    role public.enum_users_role DEFAULT 'customer'::public.enum_users_role NOT NULL,
    cellphone_number character varying(255) DEFAULT 0 NOT NULL,
    cellphone_status integer DEFAULT 0 NOT NULL,
    status boolean DEFAULT true NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: variant_options; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.variant_options (
    id integer NOT NULL,
    variant_id integer NOT NULL,
    name character varying(255) NOT NULL,
    price numeric NOT NULL,
    customer_price numeric NOT NULL,
    seller_price numeric NOT NULL,
    status boolean DEFAULT true,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.variant_options OWNER TO postgres;

--
-- Name: variant_options_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.variant_options_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.variant_options_id_seq OWNER TO postgres;

--
-- Name: variant_options_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.variant_options_id_seq OWNED BY public.variant_options.id;


--
-- Name: variants; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.variants (
    id integer NOT NULL,
    store_id integer NOT NULL,
    type character varying(255) NOT NULL,
    status boolean DEFAULT true,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.variants OWNER TO postgres;

--
-- Name: variants_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.variants_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.variants_id_seq OWNER TO postgres;

--
-- Name: variants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.variants_id_seq OWNED BY public.variants.id;


--
-- Name: additionals id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.additionals ALTER COLUMN id SET DEFAULT nextval('public.additionals_id_seq'::regclass);


--
-- Name: carts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts ALTER COLUMN id SET DEFAULT nextval('public.carts_id_seq'::regclass);


--
-- Name: chats id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chats ALTER COLUMN id SET DEFAULT nextval('public.chats_id_seq'::regclass);


--
-- Name: districts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.districts ALTER COLUMN id SET DEFAULT nextval('public.districts_id_seq'::regclass);


--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: rider_logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rider_logs ALTER COLUMN id SET DEFAULT nextval('public.rider_logs_id_seq'::regclass);


--
-- Name: rider_tracks id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rider_tracks ALTER COLUMN id SET DEFAULT nextval('public.rider_tracks_id_seq'::regclass);


--
-- Name: riders id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.riders ALTER COLUMN id SET DEFAULT nextval('public.riders_id_seq'::regclass);


--
-- Name: store_applications id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_applications ALTER COLUMN id SET DEFAULT nextval('public.store_applications_id_seq'::regclass);


--
-- Name: store_products id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_products ALTER COLUMN id SET DEFAULT nextval('public.store_products_id_seq'::regclass);


--
-- Name: stores id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stores ALTER COLUMN id SET DEFAULT nextval('public.stores_id_seq'::regclass);


--
-- Name: user_addresses id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_addresses ALTER COLUMN id SET DEFAULT nextval('public.user_addresses_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: variant_options id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.variant_options ALTER COLUMN id SET DEFAULT nextval('public.variant_options_id_seq'::regclass);


--
-- Name: variants id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.variants ALTER COLUMN id SET DEFAULT nextval('public.variants_id_seq'::regclass);


--
-- Data for Name: additionals; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.additionals (id, store_id, name, price, customer_price, seller_price, status, "createdAt", "updatedAt") FROM stdin;
\.
COPY public.additionals (id, store_id, name, price, customer_price, seller_price, status, "createdAt", "updatedAt") FROM '$$PATH$$/3263.dat';

--
-- Data for Name: carts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.carts (id, store_id, user_id, store_product_id, product_details, total_price, customer_total_price, seller_total_price, choices, additionals, quantity, note, status, "createdAt", "updatedAt") FROM stdin;
\.
COPY public.carts (id, store_id, user_id, store_product_id, product_details, total_price, customer_total_price, seller_total_price, choices, additionals, quantity, note, status, "createdAt", "updatedAt") FROM '$$PATH$$/3247.dat';

--
-- Data for Name: chats; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.chats (id, user_id, order_id, message, "createdAt") FROM stdin;
\.
COPY public.chats (id, user_id, order_id, message, "createdAt") FROM '$$PATH$$/3269.dat';

--
-- Data for Name: districts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.districts (id, name, zip_code, "createdAt", "updatedAt") FROM stdin;
\.
COPY public.districts (id, name, zip_code, "createdAt", "updatedAt") FROM '$$PATH$$/3253.dat';

--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (id, so_id, store_id, user_id, rider_id, status, products, fee, timeframe, address, payment, contract_type, note, reason, "createdAt", "updatedAt") FROM stdin;
\.
COPY public.orders (id, so_id, store_id, user_id, rider_id, status, products, fee, timeframe, address, payment, contract_type, note, reason, "createdAt", "updatedAt") FROM '$$PATH$$/3267.dat';

--
-- Data for Name: rider_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rider_logs (id, rider_id, status_from, status_to, "createdAt") FROM stdin;
\.
COPY public.rider_logs (id, rider_id, status_from, status_to, "createdAt") FROM '$$PATH$$/3273.dat';

--
-- Data for Name: rider_tracks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rider_tracks (id, rider_id, order_id, location, "createdAt") FROM stdin;
\.
COPY public.rider_tracks (id, rider_id, order_id, location, "createdAt") FROM '$$PATH$$/3271.dat';

--
-- Data for Name: riders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.riders (id, user_id, photo, status, latitude, longitude, motorcycle_details, "createdAt") FROM stdin;
\.
COPY public.riders (id, user_id, photo, status, latitude, longitude, motorcycle_details, "createdAt") FROM '$$PATH$$/3265.dat';

--
-- Data for Name: store_applications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.store_applications (id, business_name, business_type, district_id, contact_person, email, contact_number, business_address, status, tracking_number, "createdAt", "updatedAt") FROM stdin;
\.
COPY public.store_applications (id, business_name, business_type, district_id, contact_person, email, contact_number, business_address, status, tracking_number, "createdAt", "updatedAt") FROM '$$PATH$$/3275.dat';

--
-- Data for Name: store_products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.store_products (id, store_id, name, description, image, price, customer_price, seller_price, variants, additionals, quantity, max_order, category, status, "createdAt", "updatedAt") FROM stdin;
\.
COPY public.store_products (id, store_id, name, description, image, price, customer_price, seller_price, variants, additionals, quantity, max_order, category, status, "createdAt", "updatedAt") FROM '$$PATH$$/3257.dat';

--
-- Data for Name: stores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stores (id, user_id, district_id, name, description, latitude, longitude, location_name, status, stature, type, contract_type, category, country, state, city, barangay, rating, logo_url, photo_url, sunday, sunday_opening_time, sunday_closing_time, monday, monday_opening_time, monday_closing_time, tuesday, tuesday_opening_time, tuesday_closing_time, wednesday, wednesday_opening_time, wednesday_closing_time, thursday, thursday_opening_time, thursday_closing_time, friday, friday_opening_time, friday_closing_time, saturday, saturday_opening_time, saturday_closing_time, "createdAt", "updatedAt") FROM stdin;
\.
COPY public.stores (id, user_id, district_id, name, description, latitude, longitude, location_name, status, stature, type, contract_type, category, country, state, city, barangay, rating, logo_url, photo_url, sunday, sunday_opening_time, sunday_closing_time, monday, monday_opening_time, monday_closing_time, tuesday, tuesday_opening_time, tuesday_closing_time, wednesday, wednesday_opening_time, wednesday_closing_time, thursday, thursday_opening_time, thursday_closing_time, friday, friday_opening_time, friday_closing_time, saturday, saturday_opening_time, saturday_closing_time, "createdAt", "updatedAt") FROM '$$PATH$$/3255.dat';

--
-- Data for Name: user_addresses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_addresses (id, user_id, name, location, address, note, "createdAt") FROM stdin;
\.
COPY public.user_addresses (id, user_id, name, location, address, note, "createdAt") FROM '$$PATH$$/3251.dat';

--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name, email, password, provider, provider_token, token, role, cellphone_number, cellphone_status, status, "createdAt", "updatedAt") FROM stdin;
\.
COPY public.users (id, name, email, password, provider, provider_token, token, role, cellphone_number, cellphone_status, status, "createdAt", "updatedAt") FROM '$$PATH$$/3249.dat';

--
-- Data for Name: variant_options; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.variant_options (id, variant_id, name, price, customer_price, seller_price, status, "createdAt", "updatedAt") FROM stdin;
\.
COPY public.variant_options (id, variant_id, name, price, customer_price, seller_price, status, "createdAt", "updatedAt") FROM '$$PATH$$/3261.dat';

--
-- Data for Name: variants; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.variants (id, store_id, type, status, "createdAt", "updatedAt") FROM stdin;
\.
COPY public.variants (id, store_id, type, status, "createdAt", "updatedAt") FROM '$$PATH$$/3259.dat';

--
-- Name: additionals_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.additionals_id_seq', 33, true);


--
-- Name: carts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.carts_id_seq', 15, true);


--
-- Name: chats_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.chats_id_seq', 98, true);


--
-- Name: districts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.districts_id_seq', 20, true);


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_id_seq', 55, true);


--
-- Name: rider_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rider_logs_id_seq', 1, false);


--
-- Name: rider_tracks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rider_tracks_id_seq', 5759, true);


--
-- Name: riders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.riders_id_seq', 10, true);


--
-- Name: store_applications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.store_applications_id_seq', 1, false);


--
-- Name: store_products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.store_products_id_seq', 40, true);


--
-- Name: stores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.stores_id_seq', 12, true);


--
-- Name: user_addresses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_addresses_id_seq', 6, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 33, true);


--
-- Name: variant_options_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.variant_options_id_seq', 72, true);


--
-- Name: variants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.variants_id_seq', 22, true);


--
-- Name: additionals additionals_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.additionals
    ADD CONSTRAINT additionals_pkey PRIMARY KEY (id);


--
-- Name: carts carts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT carts_pkey PRIMARY KEY (id);


--
-- Name: chats chats_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chats
    ADD CONSTRAINT chats_pkey PRIMARY KEY (id);


--
-- Name: districts districts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.districts
    ADD CONSTRAINT districts_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: rider_logs rider_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rider_logs
    ADD CONSTRAINT rider_logs_pkey PRIMARY KEY (id);


--
-- Name: rider_tracks rider_tracks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rider_tracks
    ADD CONSTRAINT rider_tracks_pkey PRIMARY KEY (id);


--
-- Name: riders riders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.riders
    ADD CONSTRAINT riders_pkey PRIMARY KEY (id);


--
-- Name: store_applications store_applications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_applications
    ADD CONSTRAINT store_applications_pkey PRIMARY KEY (id);


--
-- Name: store_products store_products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_products
    ADD CONSTRAINT store_products_pkey PRIMARY KEY (id);


--
-- Name: stores stores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stores
    ADD CONSTRAINT stores_pkey PRIMARY KEY (id);


--
-- Name: user_addresses user_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_addresses
    ADD CONSTRAINT user_addresses_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: variant_options variant_options_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.variant_options
    ADD CONSTRAINT variant_options_pkey PRIMARY KEY (id);


--
-- Name: variants variants_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.variants
    ADD CONSTRAINT variants_pkey PRIMARY KEY (id);


--
-- Name: additionals additionals_store_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.additionals
    ADD CONSTRAINT additionals_store_id_fkey FOREIGN KEY (store_id) REFERENCES public.stores(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: chats chats_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chats
    ADD CONSTRAINT chats_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: chats chats_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chats
    ADD CONSTRAINT chats_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: orders orders_rider_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_rider_id_fkey FOREIGN KEY (rider_id) REFERENCES public.riders(id) ON UPDATE CASCADE;


--
-- Name: orders orders_store_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_store_id_fkey FOREIGN KEY (store_id) REFERENCES public.stores(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: orders orders_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE;


--
-- Name: rider_logs rider_logs_rider_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rider_logs
    ADD CONSTRAINT rider_logs_rider_id_fkey FOREIGN KEY (rider_id) REFERENCES public.riders(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rider_tracks rider_tracks_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rider_tracks
    ADD CONSTRAINT rider_tracks_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: rider_tracks rider_tracks_rider_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rider_tracks
    ADD CONSTRAINT rider_tracks_rider_id_fkey FOREIGN KEY (rider_id) REFERENCES public.riders(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: riders riders_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.riders
    ADD CONSTRAINT riders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: store_applications store_applications_district_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_applications
    ADD CONSTRAINT store_applications_district_id_fkey FOREIGN KEY (district_id) REFERENCES public.districts(id) ON UPDATE CASCADE;


--
-- Name: store_products store_products_store_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_products
    ADD CONSTRAINT store_products_store_id_fkey FOREIGN KEY (store_id) REFERENCES public.stores(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: stores stores_district_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stores
    ADD CONSTRAINT stores_district_id_fkey FOREIGN KEY (district_id) REFERENCES public.districts(id) ON UPDATE CASCADE;


--
-- Name: stores stores_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stores
    ADD CONSTRAINT stores_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_addresses user_addresses_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_addresses
    ADD CONSTRAINT user_addresses_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: variant_options variant_options_variant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.variant_options
    ADD CONSTRAINT variant_options_variant_id_fkey FOREIGN KEY (variant_id) REFERENCES public.variants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: variants variants_store_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.variants
    ADD CONSTRAINT variants_store_id_fkey FOREIGN KEY (store_id) REFERENCES public.stores(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               