toc.dat                                                                                             0000600 0004000 0002000 00000600257 14022554213 0014447 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        PGDMP           9                y            lets_bee     13.2 (Ubuntu 13.2-1.pgdg20.04+1)     13.2 (Ubuntu 13.2-1.pgdg20.04+1) ?    ?           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false         ?           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false         ?           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false         ?           1262    16384    lets_bee    DATABASE     Y   CREATE DATABASE lets_bee WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'C.UTF-8';
    DROP DATABASE lets_bee;
                postgres    false         7           1247    19199    enum_carts_status    TYPE     l   CREATE TYPE public.enum_carts_status AS ENUM (
    'active',
    'ordered',
    'changed',
    'removed'
);
 $   DROP TYPE public.enum_carts_status;
       public          postgres    false                    1247    30298    enum_orders_contract_type    TYPE     e   CREATE TYPE public.enum_orders_contract_type AS ENUM (
    'commission',
    'markup',
    'half'
);
 ,   DROP TYPE public.enum_orders_contract_type;
       public          postgres    false                     1247    30281    enum_orders_status    TYPE     ?   CREATE TYPE public.enum_orders_status AS ENUM (
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
       public          postgres    false         ,           1247    30385 %   enum_store_applications_business_type    TYPE     c   CREATE TYPE public.enum_store_applications_business_type AS ENUM (
    'mart',
    'restaurant'
);
 8   DROP TYPE public.enum_store_applications_business_type;
       public          postgres    false         /           1247    30390    enum_store_applications_status    TYPE     |   CREATE TYPE public.enum_store_applications_status AS ENUM (
    'approved',
    'pending',
    'rejected',
    'on-hold'
);
 1   DROP TYPE public.enum_store_applications_status;
       public          postgres    false         ?           1247    30189    enum_store_products_status    TYPE     r   CREATE TYPE public.enum_store_products_status AS ENUM (
    'available',
    'unavailable',
    'out-of-stock'
);
 -   DROP TYPE public.enum_store_products_status;
       public          postgres    false         ?           1247    30150    enum_stores_contract_type    TYPE     e   CREATE TYPE public.enum_stores_contract_type AS ENUM (
    'commission',
    'markup',
    'half'
);
 ,   DROP TYPE public.enum_stores_contract_type;
       public          postgres    false         ?           1247    30134    enum_stores_stature    TYPE     u   CREATE TYPE public.enum_stores_stature AS ENUM (
    'temporary-close',
    'closed',
    'suspended',
    'open'
);
 &   DROP TYPE public.enum_stores_stature;
       public          postgres    false         ?           1247    30126    enum_stores_status    TYPE     b   CREATE TYPE public.enum_stores_status AS ENUM (
    'active',
    'deactivated',
    'pending'
);
 %   DROP TYPE public.enum_stores_status;
       public          postgres    false         ?           1247    30144    enum_stores_type    TYPE     N   CREATE TYPE public.enum_stores_type AS ENUM (
    'restaurant',
    'mart'
);
 #   DROP TYPE public.enum_stores_type;
       public          postgres    false                    1247    30064    enum_users_provider    TYPE     k   CREATE TYPE public.enum_users_provider AS ENUM (
    'email',
    'facebook',
    'google',
    'kakao'
);
 &   DROP TYPE public.enum_users_provider;
       public          postgres    false                    1247    30074    enum_users_role    TYPE     {   CREATE TYPE public.enum_users_role AS ENUM (
    'customer',
    'partner',
    'rider',
    'admin',
    'super-admin'
);
 "   DROP TYPE public.enum_users_role;
       public          postgres    false         4           1255    30484 C   create_addon(integer, character varying, numeric, numeric, numeric)    FUNCTION     ?  CREATE FUNCTION public.create_addon(p_user_id integer, p_name character varying, p_price numeric, p_customer_price numeric, p_seller_price numeric) RETURNS TABLE(id integer, status character varying, message character varying)
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
       public          postgres    false                     1255    30432 ?  create_mart(character varying, character varying, character varying, character varying, character varying, character varying, numeric, numeric, character varying, public.enum_stores_contract_type, character varying, character varying, character varying, character varying, character varying, text, text, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone)    FUNCTION     K  CREATE FUNCTION public.create_mart(p_user_name character varying, p_email character varying, p_password character varying, p_cellphone_number character varying, p_store_name character varying, p_description character varying, p_latitude numeric, p_longitude numeric, p_location_name character varying, p_contract_type public.enum_stores_contract_type, p_category character varying, p_country character varying, p_state character varying, p_city character varying, p_barangay character varying, p_logo_url text, p_photo_url text, p_sunday boolean, p_sunday_opening_time time without time zone, p_sunday_closing_time time without time zone, p_monday boolean, p_monday_opening_time time without time zone, p_monday_closing_time time without time zone, p_tuesday boolean, p_tuesday_opening_time time without time zone, p_tuesday_closing_time time without time zone, p_wednesday boolean, p_wednesday_opening_time time without time zone, p_wednesday_closing_time time without time zone, p_thursday boolean, p_thursday_opening_time time without time zone, p_thursday_closing_time time without time zone, p_friday boolean, p_friday_opening_time time without time zone, p_friday_closing_time time without time zone, p_saturday boolean, p_saturday_opening_time time without time zone, p_saturday_closing_time time without time zone) RETURNS TABLE(mart_id integer, user_id integer, status character varying, message character varying)
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
       public          postgres    false    733                    1255    30446    create_menu(integer, character varying, text, text, numeric, numeric, numeric, text, text, integer, integer, character varying)    FUNCTION     ?  CREATE FUNCTION public.create_menu(p_store_id integer, p_name character varying, p_description text, p_image text, p_price numeric, p_customer_price numeric, p_seller_price numeric, p_choices text, p_additionals text, p_quantity integer, p_max_order integer, p_category character varying) RETURNS TABLE(id integer, status character varying, message character varying)
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
       public          postgres    false         8           1255    30488    create_order(integer, integer, public.enum_orders_status, text, text, text, text, public.enum_orders_contract_type, text, text)    FUNCTION     ?  CREATE FUNCTION public.create_order(p_store_id integer, p_user_id integer, p_status public.enum_orders_status, p_products text, p_fee text, p_address text, p_payment text, p_contract_type public.enum_orders_contract_type, p_timeframe text DEFAULT NULL::text, p_reason text DEFAULT ''::text) RETURNS TABLE(order_id integer)
    LANGUAGE plpgsql
    AS $$ 
DECLARE
  v_order_id INT := 0;
  v_so_id INT := 0;
BEGIN
  SELECT COUNT(*) AS count INTO v_so_id FROM public.orders as o WHERE o.store_id = p_store_id AND o."createdAt"::date = CURRENT_DATE;

  v_so_id = v_so_id + 1;

  INSERT INTO public.orders (so_id, store_id, user_id, status, products, fee, timeframe, address, payment, contract_type, reason, "createdAt", "updatedAt")
    VALUES (v_so_id, p_store_id, p_user_id, p_status, p_products, p_fee, p_timeframe, p_address, p_payment, p_contract_type, p_reason, now(), now())
    RETURNING public.orders.id INTO v_order_id;

  RETURN QUERY SELECT v_order_id;
END;
$$;
 ?   DROP FUNCTION public.create_order(p_store_id integer, p_user_id integer, p_status public.enum_orders_status, p_products text, p_fee text, p_address text, p_payment text, p_contract_type public.enum_orders_contract_type, p_timeframe text, p_reason text);
       public          postgres    false    768    771         (           1255    30472 ?   create_product(integer, character varying, text, text, numeric, numeric, numeric, text, text, integer, integer, character varying)    FUNCTION     d  CREATE FUNCTION public.create_product(p_user_id integer, p_name character varying, p_description text, p_image text, p_price numeric, p_customer_price numeric, p_seller_price numeric, p_choices text, p_additionals text, p_quantity integer, p_max_order integer, p_category character varying) RETURNS TABLE(id integer, status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_product_id INT := 0;
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Product successfully created!';
BEGIN
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
 "  DROP FUNCTION public.create_product(p_user_id integer, p_name character varying, p_description text, p_image text, p_price numeric, p_customer_price numeric, p_seller_price numeric, p_choices text, p_additionals text, p_quantity integer, p_max_order integer, p_category character varying);
       public          postgres    false                    1255    30439 ?  create_restaurant(character varying, character varying, character varying, character varying, character varying, character varying, numeric, numeric, character varying, public.enum_stores_contract_type, character varying, character varying, character varying, character varying, character varying, text, text, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone)    FUNCTION     {  CREATE FUNCTION public.create_restaurant(p_user_name character varying, p_email character varying, p_password character varying, p_cellphone_number character varying, p_store_name character varying, p_description character varying, p_latitude numeric, p_longitude numeric, p_location_name character varying, p_contract_type public.enum_stores_contract_type, p_category character varying, p_country character varying, p_state character varying, p_city character varying, p_barangay character varying, p_logo_url text, p_photo_url text, p_sunday boolean, p_sunday_opening_time time without time zone, p_sunday_closing_time time without time zone, p_monday boolean, p_monday_opening_time time without time zone, p_monday_closing_time time without time zone, p_tuesday boolean, p_tuesday_opening_time time without time zone, p_tuesday_closing_time time without time zone, p_wednesday boolean, p_wednesday_opening_time time without time zone, p_wednesday_closing_time time without time zone, p_thursday boolean, p_thursday_opening_time time without time zone, p_thursday_closing_time time without time zone, p_friday boolean, p_friday_opening_time time without time zone, p_friday_closing_time time without time zone, p_saturday boolean, p_saturday_opening_time time without time zone, p_saturday_closing_time time without time zone) RETURNS TABLE(restaurant_id integer, user_id integer, status character varying, message character varying)
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
       public          postgres    false    733         ?            1255    30429 ^   create_rider(character varying, character varying, character varying, character varying, text)    FUNCTION     O  CREATE FUNCTION public.create_rider(p_name character varying, p_email character varying, p_password character varying, p_cellphone_number character varying, p_motorcycle_details text) RETURNS TABLE(id integer, status character varying, message character varying)
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
       public          postgres    false         +           1255    30475 *   create_variant(integer, character varying)    FUNCTION       CREATE FUNCTION public.create_variant(p_user_id integer, p_type character varying) RETURNS TABLE(id integer, status character varying, message character varying)
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
       public          postgres    false         /           1255    30479 L   create_variant_option(integer, character varying, numeric, numeric, numeric)    FUNCTION     Y  CREATE FUNCTION public.create_variant_option(p_variant_id integer, p_name character varying, p_price numeric, p_customer_price numeric, p_seller_price numeric) RETURNS TABLE(id integer, status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_variant_option_id INT := 0;
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Variant option successfully created!';
BEGIN
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
       public          postgres    false                    1255    30433    disable_mart(integer)    FUNCTION     ?  CREATE FUNCTION public.disable_mart(p_mart_id integer) RETURNS TABLE(status character varying, message character varying)
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
       public          postgres    false                    1255    30447    disable_menu(integer)    FUNCTION     ?  CREATE FUNCTION public.disable_menu(p_id integer) RETURNS TABLE(status character varying, message character varying)
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
       public          postgres    false                    1255    30440    disable_restaurant(integer)    FUNCTION     ?  CREATE FUNCTION public.disable_restaurant(p_restaurant_id integer) RETURNS TABLE(status character varying, message character varying)
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
       public          postgres    false         ?            1255    30431 )   disable_rider(integer, character varying)    FUNCTION     ?  CREATE FUNCTION public.disable_rider(p_user_id integer, p_email_address character varying) RETURNS TABLE(status character varying, message character varying)
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
       public          postgres    false         5           1255    30485 "   find_addon_by_id(integer, integer)    FUNCTION       CREATE FUNCTION public.find_addon_by_id(p_user_id integer, p_addon_id integer) RETURNS TABLE(id integer, store_id integer, addon_name character varying, price numeric, customer_price numeric, seller_price numeric, addon_status boolean, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
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
       public          postgres    false                    1255    30434    find_mart_by_id(integer)    FUNCTION     H  CREATE FUNCTION public.find_mart_by_id(p_id integer) RETURNS TABLE(id integer, user_name character varying, cellphone_number character varying, email character varying, mart_name character varying, description text, latitude numeric, longitude numeric, location_name character varying, status public.enum_stores_status, stature public.enum_stores_stature, contract_type public.enum_stores_contract_type, category character varying, country character varying, state character varying, city character varying, barangay character varying, rating numeric, logo_url text, photo_url text, sunday boolean, sunday_opening_time time without time zone, sunday_closing_time time without time zone, monday boolean, monday_opening_time time without time zone, monday_closing_time time without time zone, tuesday boolean, tuesday_opening_time time without time zone, tuesday_closing_time time without time zone, wednesday boolean, wednesday_opening_time time without time zone, wednesday_closing_time time without time zone, thursday boolean, thursday_opening_time time without time zone, thursday_closing_time time without time zone, friday boolean, friday_opening_time time without time zone, friday_closing_time time without time zone, saturday boolean, saturday_opening_time time without time zone, saturday_closing_time time without time zone, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
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
       public          postgres    false    733    727    724                    1255    30452 (   find_partner_by_email(character varying)    FUNCTION     ?  CREATE FUNCTION public.find_partner_by_email(p_email_address character varying) RETURNS TABLE(id integer, partner_name character varying, email character varying, hashed_password character varying, partner_status boolean, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
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
       public          postgres    false                    1255    30453    find_partner_by_id(integer)    FUNCTION     k  CREATE FUNCTION public.find_partner_by_id(p_id integer) RETURNS TABLE(id integer, partner_name character varying, email character varying, hashed_password character varying, partner_status boolean, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
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
       public          postgres    false         '           1255    30471 $   find_product_by_id(integer, integer)    FUNCTION       CREATE FUNCTION public.find_product_by_id(p_user_id integer, p_product_id integer) RETURNS TABLE(id integer, product_name character varying, product_description text, product_image text, price numeric, customer_price numeric, seller_price numeric, variants json, additionals json, quantity integer, max_order integer, category character varying, product_status public.enum_store_products_status, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
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
            sp.variants,
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
       public          postgres    false    741         	           1255    30441    find_restaurant_by_id(integer)    FUNCTION     `  CREATE FUNCTION public.find_restaurant_by_id(p_id integer) RETURNS TABLE(id integer, user_name character varying, cellphone_number character varying, email character varying, restaurant_name character varying, description text, latitude numeric, longitude numeric, location_name character varying, status public.enum_stores_status, stature public.enum_stores_stature, contract_type public.enum_stores_contract_type, category character varying, country character varying, state character varying, city character varying, barangay character varying, rating numeric, logo_url text, photo_url text, sunday boolean, sunday_opening_time time without time zone, sunday_closing_time time without time zone, monday boolean, monday_opening_time time without time zone, monday_closing_time time without time zone, tuesday boolean, tuesday_opening_time time without time zone, tuesday_closing_time time without time zone, wednesday boolean, wednesday_opening_time time without time zone, wednesday_closing_time time without time zone, thursday boolean, thursday_opening_time time without time zone, thursday_closing_time time without time zone, friday boolean, friday_opening_time time without time zone, friday_closing_time time without time zone, saturday boolean, saturday_opening_time time without time zone, saturday_closing_time time without time zone, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
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
       public          postgres    false    733    724    727         ?            1255    30428 .   find_rider_by_email_address(character varying)    FUNCTION     "  CREATE FUNCTION public.find_rider_by_email_address(p_email_address character varying) RETURNS TABLE(id integer, rider_id integer, name character varying, email character varying, cellphone_number character varying, cellphone_status integer, status boolean, latitude numeric, longitude numeric, motorcycle_details text, createdat timestamp with time zone, updatedat timestamp with time zone)
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
       public          postgres    false         ?            1255    30427    find_rider_by_id(integer)    FUNCTION     ?  CREATE FUNCTION public.find_rider_by_id(p_user_id integer) RETURNS TABLE(id integer, rider_id integer, name character varying, email character varying, cellphone_number character varying, cellphone_status integer, status boolean, latitude numeric, longitude numeric, motorcycle_details text, createdat timestamp with time zone, updatedat timestamp with time zone)
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
       public          postgres    false                    1255    30458    find_store_by_id(integer)    FUNCTION     ?  CREATE FUNCTION public.find_store_by_id(p_user_id integer) RETURNS TABLE(id integer, user_name character varying, cellphone_number character varying, email character varying, store_name character varying, description text, latitude numeric, longitude numeric, location_name character varying, status public.enum_stores_status, stature public.enum_stores_stature, contract_type public.enum_stores_contract_type, category character varying, country character varying, state character varying, city character varying, barangay character varying, rating numeric, logo_url text, photo_url text, sunday boolean, sunday_opening_time time without time zone, sunday_closing_time time without time zone, monday boolean, monday_opening_time time without time zone, monday_closing_time time without time zone, tuesday boolean, tuesday_opening_time time without time zone, tuesday_closing_time time without time zone, wednesday boolean, wednesday_opening_time time without time zone, wednesday_closing_time time without time zone, thursday boolean, thursday_opening_time time without time zone, thursday_closing_time time without time zone, friday boolean, friday_opening_time time without time zone, friday_closing_time time without time zone, saturday boolean, saturday_opening_time time without time zone, saturday_closing_time time without time zone, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
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
       public          postgres    false    724    733    727         #           1255    30467 $   find_variant_by_id(integer, integer)    FUNCTION     %  CREATE FUNCTION public.find_variant_by_id(p_user_id integer, p_variant_id integer) RETURNS TABLE(id integer, store_id integer, variant_type character varying, variant_status boolean, variant_options json, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
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
       public          postgres    false         2           1255    30482 +   find_variant_option_by_id(integer, integer)    FUNCTION     ?  CREATE FUNCTION public.find_variant_option_by_id(p_user_id integer, p_variant_option_id integer) RETURNS TABLE(id integer, variant_id integer, variant_option_name character varying, price numeric, customer_price numeric, seller_price numeric, variant_option_status boolean, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
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
       public          postgres    false         ?            1255    30417    get_all_history()    FUNCTION       CREATE FUNCTION public.get_all_history() RETURNS TABLE(order_id integer, customer_id integer, rider_id integer, rider_user_id integer, store_id integer, customer_name character varying, rider_name character varying, store_name character varying, order_status public.enum_orders_status, products json, fee json, timeframe json, order_address json, payment json, reason text, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
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
       public          postgres    false    768                    1255    30435    get_all_marts()    FUNCTION       CREATE FUNCTION public.get_all_marts() RETURNS TABLE(id integer, mart_name character varying, description text, latitude numeric, longitude numeric, location_name character varying, status integer, stature public.enum_stores_stature, contract_type public.enum_stores_contract_type, country character varying, state character varying, city character varying, barangay character varying, rating numeric, logo_url text, photo_url text, sunday boolean, sunday_opening_time timestamp with time zone, sunday_closing_time timestamp with time zone, monday boolean, monday_opening_time timestamp with time zone, monday_closing_time timestamp with time zone, tuesday boolean, tuesday_opening_time timestamp with time zone, tuesday_closing_time timestamp with time zone, wednesday boolean, wednesday_opening_time timestamp with time zone, wednesday_closing_time timestamp with time zone, thursday boolean, thursday_opening_time timestamp with time zone, thursday_closing_time timestamp with time zone, friday boolean, friday_opening_time timestamp with time zone, friday_closing_time timestamp with time zone, saturday boolean, saturday_opening_time timestamp with time zone, saturday_closing_time timestamp with time zone, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
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
       public          postgres    false    727    733         
           1255    30442    get_all_restaurants()    FUNCTION     &  CREATE FUNCTION public.get_all_restaurants() RETURNS TABLE(id integer, restaurant_name character varying, description text, latitude numeric, longitude numeric, location_name character varying, status integer, stature public.enum_stores_stature, contract_type public.enum_stores_contract_type, country character varying, state character varying, city character varying, barangay character varying, rating numeric, logo_url text, photo_url text, sunday boolean, sunday_opening_time timestamp with time zone, sunday_closing_time timestamp with time zone, monday boolean, monday_opening_time timestamp with time zone, monday_closing_time timestamp with time zone, tuesday boolean, tuesday_opening_time timestamp with time zone, tuesday_closing_time timestamp with time zone, wednesday boolean, wednesday_opening_time timestamp with time zone, wednesday_closing_time timestamp with time zone, thursday boolean, thursday_opening_time timestamp with time zone, thursday_closing_time timestamp with time zone, friday boolean, friday_opening_time timestamp with time zone, friday_closing_time timestamp with time zone, saturday boolean, saturday_opening_time timestamp with time zone, saturday_closing_time timestamp with time zone, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
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
       public          postgres    false    727    733         ?            1255    30422    get_all_stats()    FUNCTION     '  CREATE FUNCTION public.get_all_stats() RETURNS TABLE(grand_subtotal numeric, delivery_total numeric, discount_total numeric, grand_total numeric)
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
       public          postgres    false         &           1255    30470 $   get_daily_stats(integer, date, date)    FUNCTION       CREATE FUNCTION public.get_daily_stats(p_user_id integer, p_start_date date, p_end_date date) RETURNS TABLE(date_start timestamp without time zone, date_end timestamp without time zone, delivered_count bigint, cancelled_count bigint, sales numeric)
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
       public          postgres    false         ?            1255    30418    get_history_by_id(integer)    FUNCTION     '  CREATE FUNCTION public.get_history_by_id(p_id integer) RETURNS TABLE(order_id integer, customer_id integer, rider_id integer, rider_user_id integer, store_id integer, customer_name character varying, rider_name character varying, store_name character varying, order_status public.enum_orders_status, products json, fee json, timeframe json, order_address json, payment json, reason text, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
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
       public          postgres    false    768                    1255    30448    get_menu_by_id(integer)    FUNCTION     ?  CREATE FUNCTION public.get_menu_by_id(p_id integer) RETURNS TABLE(id integer, store_id integer, name character varying, description text, image text, price numeric, customer_price numeric, seller_price numeric, choices text, additionals text, quantity integer, max_order integer, category character varying, status public.enum_store_products_status, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
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
       public          postgres    false    741                    1255    30454    get_order_stats(integer, date)    FUNCTION     ?  CREATE FUNCTION public.get_order_stats(p_user_id integer, p_today date) RETURNS TABLE(delivered_today bigint, delivered_yesterday bigint, cancelled_today bigint, cancelled_yesterday bigint, net_sales_today numeric, net_sales_yesterday numeric)
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
       public          postgres    false                    1255    30460 N   get_partner_stats(integer, timestamp with time zone, timestamp with time zone)    FUNCTION     ?  CREATE FUNCTION public.get_partner_stats(p_user_id integer, p_start_date timestamp with time zone, p_end_date timestamp with time zone) RETURNS TABLE(delivered bigint, cancelled bigint, net_sales numeric)
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
      )
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
       public          postgres    false                    1255    30455    get_peak_hours(integer, date)    FUNCTION     ;,  CREATE FUNCTION public.get_peak_hours(p_user_id integer, p_date date) RETURNS TABLE(hour time without time zone, orders bigint)
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
       public          postgres    false                    1255    30461 &   get_pending_store_applications_count()    FUNCTION       CREATE FUNCTION public.get_pending_store_applications_count() RETURNS TABLE(total_count bigint)
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
       public          postgres    false                    1255    30456 Q   get_popular_products(integer, timestamp with time zone, timestamp with time zone)    FUNCTION     ?  CREATE FUNCTION public.get_popular_products(p_user_id integer, p_start_date timestamp with time zone, p_end_date timestamp with time zone) RETURNS TABLE(product_name character varying, number_of_orders bigint)
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
       public          postgres    false         ?            1255    30425    get_riders()    FUNCTION     ?  CREATE FUNCTION public.get_riders() RETURNS TABLE(id integer, rider_id integer, name character varying, email character varying, cellphone_number character varying, cellphone_status integer, status boolean, latitude numeric, longitude numeric, motorcycle_details text, createdat timestamp with time zone, updatedat timestamp with time zone)
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
       public          postgres    false                    1255    30462 $   get_store_application_by_id(integer)    FUNCTION     R  CREATE FUNCTION public.get_store_application_by_id(p_id integer) RETURNS TABLE(id integer, business_name character varying, business_type public.enum_store_applications_business_type, district_id integer, district_name character varying, contact_person character varying, email character varying, contact_number character varying, business_address character varying, status public.enum_store_applications_status, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
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
       public          postgres    false    815    812                    1255    30449    get_store_menus(integer)    FUNCTION       CREATE FUNCTION public.get_store_menus(p_store_id integer) RETURNS TABLE(id integer, store_id integer, name character varying, description text, image text, price numeric, customer_price numeric, seller_price numeric, choices text, additionals text, quantity integer, max_order integer, category character varying, status public.enum_store_products_status, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
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
       public          postgres    false    741                    1255    30457    get_week_stats(integer, date)    FUNCTION     ?  CREATE FUNCTION public.get_week_stats(p_user_id integer, p_base_date date) RETURNS TABLE(monday numeric, tuesday numeric, wednesday numeric, thursday numeric, friday numeric, saturday numeric, sunday numeric)
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
       public          postgres    false                    1255    30463 ?   register_store(character varying, public.enum_store_applications_business_type, integer, character varying, character varying, character varying, character varying, character varying)    FUNCTION     ?  CREATE FUNCTION public.register_store(p_business_name character varying, p_business_type public.enum_store_applications_business_type, p_district_id integer, p_contact_person character varying, p_email character varying, p_contact_number character varying, p_business_address character varying, p_tracking_number character varying) RETURNS TABLE(store_application_id integer, status character varying, message character varying, tracking_number character varying)
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
       public          postgres    false    812         3           1255    30483 ;   search_addons(integer, character varying, integer, integer)    FUNCTION     ?  CREATE FUNCTION public.search_addons(p_user_id integer, p_query character varying, p_limit integer, p_offset integer) RETURNS TABLE(id integer, store_id integer, addon_name character varying, price numeric, customer_price numeric, seller_price numeric, addon_status boolean, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone, total_count bigint)
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
  LIMIT p_limit
  OFFSET p_offset;
END;
$$;
 u   DROP FUNCTION public.search_addons(p_user_id integer, p_query character varying, p_limit integer, p_offset integer);
       public          postgres    false         ?            1255    30419 f   search_customer_history(integer, timestamp with time zone, timestamp with time zone, integer, integer)    FUNCTION     j  CREATE FUNCTION public.search_customer_history(p_user_id integer, p_start timestamp with time zone, p_end timestamp with time zone, p_limit integer, p_offset integer) RETURNS TABLE(order_id integer, customer_id integer, rider_id integer, rider_user_id integer, restaurant_id integer, customer_name character varying, rider_name character varying, store_name character varying, order_status public.enum_orders_status, products text, fee text, order_address character varying, payment text, reason text, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
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
  ORDER BY o."createdAt" DESC
  LIMIT p_limit
  OFFSET p_offset;
END;
$$;
 ?   DROP FUNCTION public.search_customer_history(p_user_id integer, p_start timestamp with time zone, p_end timestamp with time zone, p_limit integer, p_offset integer);
       public          postgres    false    768                    1255    30436 1   search_marts(character varying, numeric, numeric)    FUNCTION     ?  CREATE FUNCTION public.search_marts(p_search_term character varying, p_customer_latitude numeric, p_customer_longitude numeric) RETURNS TABLE(id integer, user_name character varying, cellphone_number character varying, email character varying, name character varying, description text, latitude numeric, longitude numeric, location_name character varying, status public.enum_stores_status, stature public.enum_stores_stature, contract_type public.enum_stores_contract_type, category character varying, country character varying, state character varying, city character varying, barangay character varying, rating numeric, logo_url text, photo_url text, sunday boolean, sunday_opening_time time without time zone, sunday_closing_time time without time zone, monday boolean, monday_opening_time time without time zone, monday_closing_time time without time zone, tuesday boolean, tuesday_opening_time time without time zone, tuesday_closing_time time without time zone, wednesday boolean, wednesday_opening_time time without time zone, wednesday_closing_time time without time zone, thursday boolean, thursday_opening_time time without time zone, thursday_closing_time time without time zone, friday boolean, friday_opening_time time without time zone, friday_closing_time time without time zone, saturday boolean, saturday_opening_time time without time zone, saturday_closing_time time without time zone, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone, distance double precision)
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
       public          postgres    false    727    733    724                    1255    30450 (   search_menus(integer, character varying)    FUNCTION     g  CREATE FUNCTION public.search_menus(p_store_id integer, p_term character varying) RETURNS TABLE(id integer, store_id integer, name character varying, description text, image text, price numeric, customer_price numeric, seller_price numeric, choices text, additionals text, quantity integer, max_order integer, category character varying, status public.enum_store_products_status, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
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
       public          postgres    false    741         ?            1255    30420 x   search_partner_history(integer, timestamp with time zone, timestamp with time zone, character varying, integer, integer)    FUNCTION     ?  CREATE FUNCTION public.search_partner_history(p_store_id integer, p_start timestamp with time zone, p_end timestamp with time zone, p_query character varying, p_limit integer, p_offset integer) RETURNS TABLE(order_id integer, customer_id integer, rider_id integer, rider_user_id integer, store_id integer, customer_name character varying, rider_name character varying, store_name character varying, store_type public.enum_stores_type, order_status public.enum_orders_status, products json, fee json, timeframe json, order_address json, payment json, reason text, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
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
  CROSS JOIN LATERAL json_array_elements(JSON(o.products)) AS products_json
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
    OR LOWER((JSON(order_address)->>'city')) LIKE CONCAT('%', LOWER(p_query), '%')
    OR LOWER(products_json->>'name') LIKE CONCAT('%', LOWER(p_query), '%')
  )
  ORDER BY o."createdAt" DESC
  LIMIT p_limit
  OFFSET p_offset;
END;
$$;
 ?   DROP FUNCTION public.search_partner_history(p_store_id integer, p_start timestamp with time zone, p_end timestamp with time zone, p_query character varying, p_limit integer, p_offset integer);
       public          postgres    false    768    730         ?            1255    30423 Q   search_partner_stats(integer, timestamp with time zone, timestamp with time zone)    FUNCTION     ?  CREATE FUNCTION public.search_partner_stats(p_store_id integer, p_start timestamp with time zone, p_end timestamp with time zone) RETURNS TABLE(total_sales numeric, total_delivery numeric, pending_count bigint, total_pending numeric, accepted_count bigint, total_accepted numeric, declined_count bigint, total_declined numeric, delivered_count bigint, total_delivered numeric, cancelled_count bigint, total_cancelled numeric)
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
       public          postgres    false         $           1255    30468 5   search_product_categories(integer, character varying)    FUNCTION     ?  CREATE FUNCTION public.search_product_categories(p_user_id integer, p_query character varying) RETURNS TABLE(category character varying)
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
       public          postgres    false         %           1255    30469 =   search_products(integer, character varying, integer, integer)    FUNCTION     ?  CREATE FUNCTION public.search_products(p_user_id integer, p_query character varying, p_limit integer, p_offset integer) RETURNS TABLE(id integer, product_name character varying, product_description text, product_image text, price numeric, customer_price numeric, seller_price numeric, variants json, additionals json, quantity integer, max_order integer, category character varying, product_status public.enum_store_products_status, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone, total_count bigint)
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
            sp.variants,
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
       public          postgres    false    741                    1255    30443 7   search_restaurants(character varying, numeric, numeric)    FUNCTION     ?  CREATE FUNCTION public.search_restaurants(p_search_term character varying, p_customer_latitude numeric, p_customer_longitude numeric) RETURNS TABLE(id integer, user_name character varying, cellphone_number character varying, email character varying, name character varying, description text, latitude numeric, longitude numeric, location_name character varying, status public.enum_stores_status, stature public.enum_stores_stature, contract_type public.enum_stores_contract_type, category character varying, country character varying, state character varying, city character varying, barangay character varying, rating numeric, logo_url text, photo_url text, sunday boolean, sunday_opening_time time without time zone, sunday_closing_time time without time zone, monday boolean, monday_opening_time time without time zone, monday_closing_time time without time zone, tuesday boolean, tuesday_opening_time time without time zone, tuesday_closing_time time without time zone, wednesday boolean, wednesday_opening_time time without time zone, wednesday_closing_time time without time zone, thursday boolean, thursday_opening_time time without time zone, thursday_closing_time time without time zone, friday boolean, friday_opening_time time without time zone, friday_closing_time time without time zone, saturday boolean, saturday_opening_time time without time zone, saturday_closing_time time without time zone, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone, distance double precision)
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
       public          postgres    false    733    727    724         ?            1255    30426     search_riders(character varying)    FUNCTION       CREATE FUNCTION public.search_riders(p_query character varying) RETURNS TABLE(id integer, rider_id integer, name character varying, email character varying, cellphone_number character varying, cellphone_status integer, status boolean, latitude numeric, longitude numeric, motorcycle_details text, createdat timestamp with time zone, updatedat timestamp with time zone, total_count bigint)
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
       public          postgres    false         ?            1255    30421 w   search_riders_history(integer, timestamp with time zone, timestamp with time zone, character varying, integer, integer)    FUNCTION     ?  CREATE FUNCTION public.search_riders_history(p_rider_id integer, p_start timestamp with time zone, p_end timestamp with time zone, p_query character varying, p_limit integer, p_offset integer) RETURNS TABLE(order_id integer, customer_id integer, rider_id integer, rider_user_id integer, store_id integer, customer_name character varying, rider_name character varying, store_name character varying, order_status public.enum_orders_status, products json, fee json, timeframe json, order_address json, payment json, reason text, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
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
  CROSS JOIN LATERAL json_array_elements(JSON(o.products)) AS products_json
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
    OR LOWER((JSON(order_address)->>'city')) LIKE CONCAT('%', LOWER(p_query), '%')
    OR LOWER(products_json->>'name') LIKE CONCAT('%', LOWER(p_query), '%')
  )
  ORDER BY o."createdAt" DESC
  LIMIT p_limit
  OFFSET p_offset;
END;
$$;
 ?   DROP FUNCTION public.search_riders_history(p_rider_id integer, p_start timestamp with time zone, p_end timestamp with time zone, p_query character varying, p_limit integer, p_offset integer);
       public          postgres    false    768         ?            1255    30424 P   search_riders_stats(integer, timestamp with time zone, timestamp with time zone)    FUNCTION     ?  CREATE FUNCTION public.search_riders_stats(p_rider_id integer, p_start timestamp with time zone, p_end timestamp with time zone) RETURNS TABLE(total_count bigint)
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
       public          postgres    false                     1255    30464 ,   search_store_applications(character varying)    FUNCTION     X  CREATE FUNCTION public.search_store_applications(p_query character varying) RETURNS TABLE(id integer, business_name character varying, business_type public.enum_store_applications_business_type, district_id integer, district_name character varying, contact_person character varying, email character varying, contact_number character varying, business_address character varying, status public.enum_store_applications_status, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
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
       public          postgres    false    812    815         .           1255    30478 M   search_variant_options(integer, integer, character varying, integer, integer)    FUNCTION     C  CREATE FUNCTION public.search_variant_options(p_user_id integer, p_variant_id integer, p_query character varying, p_limit integer, p_offset integer) RETURNS TABLE(id integer, variant_id integer, variant_option_name character varying, price numeric, customer_price numeric, seller_price numeric, variant_option_status boolean, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone, total_count bigint)
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
  LIMIT p_limit
  OFFSET p_offset;
END;
$$;
 ?   DROP FUNCTION public.search_variant_options(p_user_id integer, p_variant_id integer, p_query character varying, p_limit integer, p_offset integer);
       public          postgres    false         "           1255    30466 =   search_variants(integer, character varying, integer, integer)    FUNCTION     ?  CREATE FUNCTION public.search_variants(p_user_id integer, p_query character varying, p_limit integer, p_offset integer) RETURNS TABLE(id integer, store_id integer, variant_type character varying, variant_status boolean, variant_options json, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone, total_count bigint)
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
  LIMIT p_limit
  OFFSET p_offset;
END;
$$;
 w   DROP FUNCTION public.search_variants(p_user_id integer, p_query character varying, p_limit integer, p_offset integer);
       public          postgres    false         6           1255    30486 U   update_addon(integer, integer, character varying, numeric, numeric, numeric, boolean)    FUNCTION     ?  CREATE FUNCTION public.update_addon(p_user_id integer, p_addon_id integer, p_name character varying, p_price numeric, p_customer_price numeric, p_seller_price numeric, p_status boolean) RETURNS TABLE(status character varying, message character varying)
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
       public          postgres    false         7           1255    30487 .   update_addon_status(integer, integer, boolean)    FUNCTION     k  CREATE FUNCTION public.update_addon_status(p_user_id integer, p_addon_id integer, p_status boolean) RETURNS TABLE(status character varying, message character varying)
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
       public          postgres    false                    1255    30437 ?  update_mart(integer, character varying, character varying, character varying, character varying, character varying, numeric, numeric, character varying, public.enum_stores_contract_type, character varying, character varying, character varying, character varying, character varying, text, text, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone)    FUNCTION     >  CREATE FUNCTION public.update_mart(p_mart_id integer, p_user_name character varying, p_email character varying, p_cellphone_number character varying, p_store_name character varying, p_description character varying, p_latitude numeric, p_longitude numeric, p_location_name character varying, p_contract_type public.enum_stores_contract_type, p_category character varying, p_country character varying, p_state character varying, p_city character varying, p_barangay character varying, p_logo_url text, p_photo_url text, p_sunday boolean, p_sunday_opening_time time without time zone, p_sunday_closing_time time without time zone, p_monday boolean, p_monday_opening_time time without time zone, p_monday_closing_time time without time zone, p_tuesday boolean, p_tuesday_opening_time time without time zone, p_tuesday_closing_time time without time zone, p_wednesday boolean, p_wednesday_opening_time time without time zone, p_wednesday_closing_time time without time zone, p_thursday boolean, p_thursday_opening_time time without time zone, p_thursday_closing_time time without time zone, p_friday boolean, p_friday_opening_time time without time zone, p_friday_closing_time time without time zone, p_saturday boolean, p_saturday_opening_time time without time zone, p_saturday_closing_time time without time zone) RETURNS TABLE(mart_id integer, user_id integer, status character varying, message character varying)
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
       public          postgres    false    733                    1255    30438 8   update_mart_stature(integer, public.enum_stores_stature)    FUNCTION     ?  CREATE FUNCTION public.update_mart_stature(p_mart_id integer, p_stature public.enum_stores_stature) RETURNS TABLE(mart_id integer, status character varying, message character varying)
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
       public          postgres    false    727                    1255    30451 ?   update_menu(integer, integer, character varying, text, text, numeric, numeric, numeric, text, text, integer, integer, character varying, public.enum_store_products_status)    FUNCTION       CREATE FUNCTION public.update_menu(p_id integer, p_store_id integer, p_name character varying, p_description text, p_image text, p_price numeric, p_customer_price numeric, p_seller_price numeric, p_choices text, p_additionals text, p_quantity integer, p_max_order integer, p_category character varying, p_status public.enum_store_products_status) RETURNS TABLE(status character varying, message character varying)
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
       public          postgres    false    741         )           1255    30473 ?   update_product(integer, integer, character varying, text, text, numeric, numeric, numeric, text, text, integer, integer, character varying, public.enum_store_products_status)    FUNCTION     ?  CREATE FUNCTION public.update_product(p_user_id integer, p_product_id integer, p_name character varying, p_description text, p_image text, p_price numeric, p_customer_price numeric, p_seller_price numeric, p_variants text, p_additionals text, p_quantity integer, p_max_order integer, p_category character varying, p_status public.enum_store_products_status) RETURNS TABLE(status character varying, message character varying)
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
       public          postgres    false    741         *           1255    30474 J   update_product_status(integer, integer, public.enum_store_products_status)    FUNCTION     ?  CREATE FUNCTION public.update_product_status(p_user_id integer, p_product_id integer, p_status public.enum_store_products_status) RETURNS TABLE(status character varying, message character varying)
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
       public          postgres    false    741                    1255    30444 ?  update_restaurant(integer, character varying, character varying, character varying, character varying, character varying, numeric, numeric, character varying, public.enum_stores_contract_type, character varying, character varying, character varying, character varying, character varying, text, text, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone)    FUNCTION     ?  CREATE FUNCTION public.update_restaurant(p_restaurant_id integer, p_user_name character varying, p_email character varying, p_cellphone_number character varying, p_store_name character varying, p_description character varying, p_latitude numeric, p_longitude numeric, p_location_name character varying, p_contract_type public.enum_stores_contract_type, p_category character varying, p_country character varying, p_state character varying, p_city character varying, p_barangay character varying, p_logo_url text, p_photo_url text, p_sunday boolean, p_sunday_opening_time time without time zone, p_sunday_closing_time time without time zone, p_monday boolean, p_monday_opening_time time without time zone, p_monday_closing_time time without time zone, p_tuesday boolean, p_tuesday_opening_time time without time zone, p_tuesday_closing_time time without time zone, p_wednesday boolean, p_wednesday_opening_time time without time zone, p_wednesday_closing_time time without time zone, p_thursday boolean, p_thursday_opening_time time without time zone, p_thursday_closing_time time without time zone, p_friday boolean, p_friday_opening_time time without time zone, p_friday_closing_time time without time zone, p_saturday boolean, p_saturday_opening_time time without time zone, p_saturday_closing_time time without time zone) RETURNS TABLE(restaurant_id integer, user_id integer, status character varying, message character varying)
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
       public          postgres    false    733                    1255    30445 >   update_restaurant_stature(integer, public.enum_stores_stature)    FUNCTION     !  CREATE FUNCTION public.update_restaurant_stature(p_restaurant_id integer, p_stature public.enum_stores_stature) RETURNS TABLE(restaurant_id integer, status character varying, message character varying)
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
       public          postgres    false    727         ?            1255    30430 T   update_rider(integer, character varying, character varying, character varying, text)    FUNCTION     ?  CREATE FUNCTION public.update_rider(p_id integer, p_name character varying, p_email character varying, p_cellphone_number character varying, p_motorcycle_details text) RETURNS TABLE(status character varying, message character varying)
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
       public          postgres    false                    1255    30459 i  update_store(integer, integer, character varying, text, numeric, numeric, character varying, character varying, character varying, character varying, character varying, text, text, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, boolean, time without time zone, time without time zone, character varying, character varying)    FUNCTION     ?  CREATE FUNCTION public.update_store(p_store_id integer, p_user_id integer, p_store_name character varying, p_description text, p_latitude numeric, p_longitude numeric, p_category character varying, p_country character varying, p_state character varying, p_city character varying, p_barangay character varying, p_logo_url text, p_photo_url text, p_sunday boolean, p_sunday_opening_time time without time zone, p_sunday_closing_time time without time zone, p_monday boolean, p_monday_opening_time time without time zone, p_monday_closing_time time without time zone, p_tuesday boolean, p_tuesday_opening_time time without time zone, p_tuesday_closing_time time without time zone, p_wednesday boolean, p_wednesday_opening_time time without time zone, p_wednesday_closing_time time without time zone, p_thursday boolean, p_thursday_opening_time time without time zone, p_thursday_closing_time time without time zone, p_friday boolean, p_friday_opening_time time without time zone, p_friday_closing_time time without time zone, p_saturday boolean, p_saturday_opening_time time without time zone, p_saturday_closing_time time without time zone, p_user_name character varying, p_cellphone_number character varying) RETURNS TABLE(status character varying, message character varying)
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
       public          postgres    false         !           1255    30465 O   update_store_application_status(integer, public.enum_store_applications_status)    FUNCTION     s  CREATE FUNCTION public.update_store_application_status(p_id integer, p_status public.enum_store_applications_status) RETURNS TABLE(application_id integer, status character varying, message character varying)
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
       public          postgres    false    815         ,           1255    30476 <   update_variant(integer, integer, character varying, boolean)    FUNCTION     ?  CREATE FUNCTION public.update_variant(p_user_id integer, p_variant_id integer, p_type character varying, p_status boolean) RETURNS TABLE(status character varying, message character varying)
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
       public          postgres    false         1           1255    30481 ^   update_variant_option(integer, integer, character varying, numeric, numeric, numeric, boolean)    FUNCTION     ?  CREATE FUNCTION public.update_variant_option(p_user_id integer, p_variant_option_id integer, p_name character varying, p_price numeric, p_customer_price numeric, p_seller_price numeric, p_status boolean) RETURNS TABLE(status character varying, message character varying)
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
    v_message := 'The variant you are trying to update does not exist.';
    RETURN QUERY SELECT v_status, v_message;
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
       public          postgres    false         0           1255    30480 7   update_variant_option_status(integer, integer, boolean)    FUNCTION     ?  CREATE FUNCTION public.update_variant_option_status(p_user_id integer, p_variant_option_id integer, p_status boolean) RETURNS TABLE(status character varying, message character varying)
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
       public          postgres    false         -           1255    30477 0   update_variant_status(integer, integer, boolean)    FUNCTION     f  CREATE FUNCTION public.update_variant_status(p_user_id integer, p_variant_id integer, p_status boolean) RETURNS TABLE(status character varying, message character varying)
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
       public          postgres    false         ?            1259    30247    additionals    TABLE     q  CREATE TABLE public.additionals (
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
       public         heap    postgres    false         ?            1259    30245    additionals_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.additionals_id_seq
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
       public         heap    postgres    false    823    823         ?            1259    19207    carts_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.carts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.carts_id_seq;
       public          postgres    false    201         ?           0    0    carts_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.carts_id_seq OWNED BY public.carts.id;
          public          postgres    false    200         ?            1259    30334    chats    TABLE     ?   CREATE TABLE public.chats (
    id integer NOT NULL,
    user_id integer,
    order_id integer,
    message text,
    "createdAt" timestamp with time zone NOT NULL
);
    DROP TABLE public.chats;
       public         heap    postgres    false         ?            1259    30332    chats_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.chats_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.chats_id_seq;
       public          postgres    false    223         ?           0    0    chats_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.chats_id_seq OWNED BY public.chats.id;
          public          postgres    false    222         ?            1259    30119 	   districts    TABLE     ?   CREATE TABLE public.districts (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    zip_code integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);
    DROP TABLE public.districts;
       public         heap    postgres    false         ?            1259    30117    districts_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.districts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.districts_id_seq;
       public          postgres    false    207         ?           0    0    districts_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.districts_id_seq OWNED BY public.districts.id;
          public          postgres    false    206         ?            1259    30307    orders    TABLE     +  CREATE TABLE public.orders (
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
    reason text,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);
    DROP TABLE public.orders;
       public         heap    postgres    false    768    768    771         ?            1259    30305    orders_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.orders_id_seq;
       public          postgres    false    221         ?           0    0    orders_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;
          public          postgres    false    220         ?            1259    30373 
   rider_logs    TABLE     ?   CREATE TABLE public.rider_logs (
    id integer NOT NULL,
    rider_id integer NOT NULL,
    status_from integer NOT NULL,
    status_to integer NOT NULL,
    "createdAt" timestamp with time zone NOT NULL
);
    DROP TABLE public.rider_logs;
       public         heap    postgres    false         ?            1259    30371    rider_logs_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.rider_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.rider_logs_id_seq;
       public          postgres    false    227         ?           0    0    rider_logs_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.rider_logs_id_seq OWNED BY public.rider_logs.id;
          public          postgres    false    226         ?            1259    30355    rider_tracks    TABLE     ?   CREATE TABLE public.rider_tracks (
    id integer NOT NULL,
    rider_id integer NOT NULL,
    order_id integer,
    location character varying(255) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL
);
     DROP TABLE public.rider_tracks;
       public         heap    postgres    false         ?            1259    30353    rider_tracks_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.rider_tracks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.rider_tracks_id_seq;
       public          postgres    false    225         ?           0    0    rider_tracks_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.rider_tracks_id_seq OWNED BY public.rider_tracks.id;
          public          postgres    false    224         ?            1259    30264    riders    TABLE     f  CREATE TABLE public.riders (
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
       public         heap    postgres    false         ?            1259    30262    riders_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.riders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.riders_id_seq;
       public          postgres    false    219         ?           0    0    riders_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.riders_id_seq OWNED BY public.riders.id;
          public          postgres    false    218         ?            1259    30401    store_applications    TABLE     ?  CREATE TABLE public.store_applications (
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
       public         heap    postgres    false    812    815    815    812         ?            1259    30399    store_applications_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.store_applications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.store_applications_id_seq;
       public          postgres    false    229         ?           0    0    store_applications_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.store_applications_id_seq OWNED BY public.store_applications.id;
          public          postgres    false    228         ?            1259    30197    store_products    TABLE     m  CREATE TABLE public.store_products (
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
       public         heap    postgres    false    741    741         ?            1259    30195    store_products_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.store_products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.store_products_id_seq;
       public          postgres    false    211         ?           0    0    store_products_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.store_products_id_seq OWNED BY public.store_products.id;
          public          postgres    false    210         ?            1259    30159    stores    TABLE     y  CREATE TABLE public.stores (
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
       public         heap    postgres    false    724    727    727    733    730    724         ?            1259    30157    stores_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.stores_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.stores_id_seq;
       public          postgres    false    209         ?           0    0    stores_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.stores_id_seq OWNED BY public.stores.id;
          public          postgres    false    208         ?            1259    30103    user_addresses    TABLE     7  CREATE TABLE public.user_addresses (
    id integer NOT NULL,
    user_id integer NOT NULL,
    name character varying(255) NOT NULL,
    location character varying(255) NOT NULL,
    address character varying(255) NOT NULL,
    note character varying(255),
    "createdAt" timestamp with time zone NOT NULL
);
 "   DROP TABLE public.user_addresses;
       public         heap    postgres    false         ?            1259    30101    user_addresses_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.user_addresses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.user_addresses_id_seq;
       public          postgres    false    205         ?           0    0    user_addresses_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.user_addresses_id_seq OWNED BY public.user_addresses.id;
          public          postgres    false    204         ?            1259    30087    users    TABLE     ?  CREATE TABLE public.users (
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
       public         heap    postgres    false    783    786    786    783         ?            1259    30085    users_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public          postgres    false    203         ?           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
          public          postgres    false    202         ?            1259    30230    variant_options    TABLE     w  CREATE TABLE public.variant_options (
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
       public         heap    postgres    false         ?            1259    30228    variant_options_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.variant_options_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.variant_options_id_seq;
       public          postgres    false    215         ?           0    0    variant_options_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.variant_options_id_seq OWNED BY public.variant_options.id;
          public          postgres    false    214         ?            1259    30216    variants    TABLE     
  CREATE TABLE public.variants (
    id integer NOT NULL,
    store_id integer NOT NULL,
    type character varying(255) NOT NULL,
    status boolean DEFAULT true,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);
    DROP TABLE public.variants;
       public         heap    postgres    false         ?            1259    30214    variants_id_seq    SEQUENCE     ?   CREATE SEQUENCE public.variants_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.variants_id_seq;
       public          postgres    false    213         ?           0    0    variants_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.variants_id_seq OWNED BY public.variants.id;
          public          postgres    false    212         ?           2604    30250    additionals id    DEFAULT     p   ALTER TABLE ONLY public.additionals ALTER COLUMN id SET DEFAULT nextval('public.additionals_id_seq'::regclass);
 =   ALTER TABLE public.additionals ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    217    216    217         ?           2604    19212    carts id    DEFAULT     d   ALTER TABLE ONLY public.carts ALTER COLUMN id SET DEFAULT nextval('public.carts_id_seq'::regclass);
 7   ALTER TABLE public.carts ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    200    201    201         ?           2604    30337    chats id    DEFAULT     d   ALTER TABLE ONLY public.chats ALTER COLUMN id SET DEFAULT nextval('public.chats_id_seq'::regclass);
 7   ALTER TABLE public.chats ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    223    222    223         ?           2604    30122    districts id    DEFAULT     l   ALTER TABLE ONLY public.districts ALTER COLUMN id SET DEFAULT nextval('public.districts_id_seq'::regclass);
 ;   ALTER TABLE public.districts ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    207    206    207         ?           2604    30310 	   orders id    DEFAULT     f   ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);
 8   ALTER TABLE public.orders ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    220    221    221         ?           2604    30376    rider_logs id    DEFAULT     n   ALTER TABLE ONLY public.rider_logs ALTER COLUMN id SET DEFAULT nextval('public.rider_logs_id_seq'::regclass);
 <   ALTER TABLE public.rider_logs ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    227    226    227         ?           2604    30358    rider_tracks id    DEFAULT     r   ALTER TABLE ONLY public.rider_tracks ALTER COLUMN id SET DEFAULT nextval('public.rider_tracks_id_seq'::regclass);
 >   ALTER TABLE public.rider_tracks ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    225    224    225         ?           2604    30267 	   riders id    DEFAULT     f   ALTER TABLE ONLY public.riders ALTER COLUMN id SET DEFAULT nextval('public.riders_id_seq'::regclass);
 8   ALTER TABLE public.riders ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    218    219    219         ?           2604    30404    store_applications id    DEFAULT     ~   ALTER TABLE ONLY public.store_applications ALTER COLUMN id SET DEFAULT nextval('public.store_applications_id_seq'::regclass);
 D   ALTER TABLE public.store_applications ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    228    229    229         ?           2604    30200    store_products id    DEFAULT     v   ALTER TABLE ONLY public.store_products ALTER COLUMN id SET DEFAULT nextval('public.store_products_id_seq'::regclass);
 @   ALTER TABLE public.store_products ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    211    210    211         ?           2604    30162 	   stores id    DEFAULT     f   ALTER TABLE ONLY public.stores ALTER COLUMN id SET DEFAULT nextval('public.stores_id_seq'::regclass);
 8   ALTER TABLE public.stores ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    208    209    209         ?           2604    30106    user_addresses id    DEFAULT     v   ALTER TABLE ONLY public.user_addresses ALTER COLUMN id SET DEFAULT nextval('public.user_addresses_id_seq'::regclass);
 @   ALTER TABLE public.user_addresses ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    205    204    205         ?           2604    30090    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    202    203    203         ?           2604    30233    variant_options id    DEFAULT     x   ALTER TABLE ONLY public.variant_options ALTER COLUMN id SET DEFAULT nextval('public.variant_options_id_seq'::regclass);
 A   ALTER TABLE public.variant_options ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    215    214    215         ?           2604    30219    variants id    DEFAULT     j   ALTER TABLE ONLY public.variants ALTER COLUMN id SET DEFAULT nextval('public.variants_id_seq'::regclass);
 :   ALTER TABLE public.variants ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    213    212    213         ?          0    30247    additionals 
   TABLE DATA           ?   COPY public.additionals (id, store_id, name, price, customer_price, seller_price, status, "createdAt", "updatedAt") FROM stdin;
    public          postgres    false    217       3262.dat ?          0    19209    carts 
   TABLE DATA           ?   COPY public.carts (id, store_id, user_id, store_product_id, product_details, total_price, customer_total_price, seller_total_price, choices, additionals, quantity, note, status, "createdAt", "updatedAt") FROM stdin;
    public          postgres    false    201       3246.dat ?          0    30334    chats 
   TABLE DATA           L   COPY public.chats (id, user_id, order_id, message, "createdAt") FROM stdin;
    public          postgres    false    223       3268.dat ?          0    30119 	   districts 
   TABLE DATA           Q   COPY public.districts (id, name, zip_code, "createdAt", "updatedAt") FROM stdin;
    public          postgres    false    207       3252.dat ?          0    30307    orders 
   TABLE DATA           ?   COPY public.orders (id, so_id, store_id, user_id, rider_id, status, products, fee, timeframe, address, payment, contract_type, reason, "createdAt", "updatedAt") FROM stdin;
    public          postgres    false    221       3266.dat ?          0    30373 
   rider_logs 
   TABLE DATA           W   COPY public.rider_logs (id, rider_id, status_from, status_to, "createdAt") FROM stdin;
    public          postgres    false    227       3272.dat ?          0    30355    rider_tracks 
   TABLE DATA           U   COPY public.rider_tracks (id, rider_id, order_id, location, "createdAt") FROM stdin;
    public          postgres    false    225       3270.dat ?          0    30264    riders 
   TABLE DATA           r   COPY public.riders (id, user_id, photo, status, latitude, longitude, motorcycle_details, "createdAt") FROM stdin;
    public          postgres    false    219       3264.dat ?          0    30401    store_applications 
   TABLE DATA           ?   COPY public.store_applications (id, business_name, business_type, district_id, contact_person, email, contact_number, business_address, status, tracking_number, "createdAt", "updatedAt") FROM stdin;
    public          postgres    false    229       3274.dat ?          0    30197    store_products 
   TABLE DATA           ?   COPY public.store_products (id, store_id, name, description, image, price, customer_price, seller_price, variants, additionals, quantity, max_order, category, status, "createdAt", "updatedAt") FROM stdin;
    public          postgres    false    211       3256.dat ?          0    30159    stores 
   TABLE DATA           n  COPY public.stores (id, user_id, district_id, name, description, latitude, longitude, location_name, status, stature, type, contract_type, category, country, state, city, barangay, rating, logo_url, photo_url, sunday, sunday_opening_time, sunday_closing_time, monday, monday_opening_time, monday_closing_time, tuesday, tuesday_opening_time, tuesday_closing_time, wednesday, wednesday_opening_time, wednesday_closing_time, thursday, thursday_opening_time, thursday_closing_time, friday, friday_opening_time, friday_closing_time, saturday, saturday_opening_time, saturday_closing_time, "createdAt", "updatedAt") FROM stdin;
    public          postgres    false    209       3254.dat ?          0    30103    user_addresses 
   TABLE DATA           a   COPY public.user_addresses (id, user_id, name, location, address, note, "createdAt") FROM stdin;
    public          postgres    false    205       3250.dat ?          0    30087    users 
   TABLE DATA           ?   COPY public.users (id, name, email, password, provider, provider_token, token, role, cellphone_number, cellphone_status, status, "createdAt", "updatedAt") FROM stdin;
    public          postgres    false    203       3248.dat ?          0    30230    variant_options 
   TABLE DATA           ?   COPY public.variant_options (id, variant_id, name, price, customer_price, seller_price, status, "createdAt", "updatedAt") FROM stdin;
    public          postgres    false    215       3260.dat ?          0    30216    variants 
   TABLE DATA           X   COPY public.variants (id, store_id, type, status, "createdAt", "updatedAt") FROM stdin;
    public          postgres    false    213       3258.dat ?           0    0    additionals_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.additionals_id_seq', 33, true);
          public          postgres    false    216         ?           0    0    carts_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.carts_id_seq', 15, true);
          public          postgres    false    200         ?           0    0    chats_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.chats_id_seq', 85, true);
          public          postgres    false    222         ?           0    0    districts_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.districts_id_seq', 20, true);
          public          postgres    false    206         ?           0    0    orders_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.orders_id_seq', 13, true);
          public          postgres    false    220         ?           0    0    rider_logs_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.rider_logs_id_seq', 1, false);
          public          postgres    false    226         ?           0    0    rider_tracks_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.rider_tracks_id_seq', 808, true);
          public          postgres    false    224         ?           0    0    riders_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.riders_id_seq', 10, true);
          public          postgres    false    218         ?           0    0    store_applications_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.store_applications_id_seq', 1, false);
          public          postgres    false    228         ?           0    0    store_products_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.store_products_id_seq', 40, true);
          public          postgres    false    210         ?           0    0    stores_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.stores_id_seq', 14, true);
          public          postgres    false    208         ?           0    0    user_addresses_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.user_addresses_id_seq', 3, true);
          public          postgres    false    204         ?           0    0    users_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.users_id_seq', 32, true);
          public          postgres    false    202         ?           0    0    variant_options_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.variant_options_id_seq', 72, true);
          public          postgres    false    214         ?           0    0    variants_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.variants_id_seq', 22, true);
          public          postgres    false    212                    2606    30256    additionals additionals_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.additionals
    ADD CONSTRAINT additionals_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.additionals DROP CONSTRAINT additionals_pkey;
       public            postgres    false    217         ?           2606    19219    carts carts_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.carts
    ADD CONSTRAINT carts_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.carts DROP CONSTRAINT carts_pkey;
       public            postgres    false    201                    2606    30342    chats chats_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.chats
    ADD CONSTRAINT chats_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.chats DROP CONSTRAINT chats_pkey;
       public            postgres    false    223                    2606    30124    districts districts_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.districts
    ADD CONSTRAINT districts_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.districts DROP CONSTRAINT districts_pkey;
       public            postgres    false    207                    2606    30316    orders orders_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_pkey;
       public            postgres    false    221                    2606    30378    rider_logs rider_logs_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.rider_logs
    ADD CONSTRAINT rider_logs_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.rider_logs DROP CONSTRAINT rider_logs_pkey;
       public            postgres    false    227                    2606    30360    rider_tracks rider_tracks_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.rider_tracks
    ADD CONSTRAINT rider_tracks_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.rider_tracks DROP CONSTRAINT rider_tracks_pkey;
       public            postgres    false    225                    2606    30274    riders riders_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.riders
    ADD CONSTRAINT riders_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.riders DROP CONSTRAINT riders_pkey;
       public            postgres    false    219                    2606    30411 *   store_applications store_applications_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.store_applications
    ADD CONSTRAINT store_applications_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.store_applications DROP CONSTRAINT store_applications_pkey;
       public            postgres    false    229                    2606    30208 "   store_products store_products_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.store_products
    ADD CONSTRAINT store_products_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.store_products DROP CONSTRAINT store_products_pkey;
       public            postgres    false    211                    2606    30177    stores stores_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.stores
    ADD CONSTRAINT stores_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.stores DROP CONSTRAINT stores_pkey;
       public            postgres    false    209                    2606    30111 "   user_addresses user_addresses_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.user_addresses
    ADD CONSTRAINT user_addresses_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.user_addresses DROP CONSTRAINT user_addresses_pkey;
       public            postgres    false    205         ?           2606    30100    users users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    203                    2606    30239 $   variant_options variant_options_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.variant_options
    ADD CONSTRAINT variant_options_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.variant_options DROP CONSTRAINT variant_options_pkey;
       public            postgres    false    215         	           2606    30222    variants variants_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.variants
    ADD CONSTRAINT variants_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.variants DROP CONSTRAINT variants_pkey;
       public            postgres    false    213                     2606    30257 %   additionals additionals_store_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.additionals
    ADD CONSTRAINT additionals_store_id_fkey FOREIGN KEY (store_id) REFERENCES public.stores(id) ON UPDATE CASCADE ON DELETE CASCADE;
 O   ALTER TABLE ONLY public.additionals DROP CONSTRAINT additionals_store_id_fkey;
       public          postgres    false    217    209    3077         &           2606    30348    chats chats_order_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.chats
    ADD CONSTRAINT chats_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON UPDATE CASCADE ON DELETE CASCADE;
 C   ALTER TABLE ONLY public.chats DROP CONSTRAINT chats_order_id_fkey;
       public          postgres    false    223    221    3089         %           2606    30343    chats chats_user_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.chats
    ADD CONSTRAINT chats_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;
 B   ALTER TABLE ONLY public.chats DROP CONSTRAINT chats_user_id_fkey;
       public          postgres    false    223    203    3071         $           2606    30327    orders orders_rider_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_rider_id_fkey FOREIGN KEY (rider_id) REFERENCES public.riders(id) ON UPDATE CASCADE;
 E   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_rider_id_fkey;
       public          postgres    false    3087    219    221         "           2606    30317    orders orders_store_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_store_id_fkey FOREIGN KEY (store_id) REFERENCES public.stores(id) ON UPDATE CASCADE ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_store_id_fkey;
       public          postgres    false    221    3077    209         #           2606    30322    orders orders_user_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE;
 D   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_user_id_fkey;
       public          postgres    false    203    221    3071         )           2606    30379 #   rider_logs rider_logs_rider_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.rider_logs
    ADD CONSTRAINT rider_logs_rider_id_fkey FOREIGN KEY (rider_id) REFERENCES public.riders(id) ON UPDATE CASCADE ON DELETE CASCADE;
 M   ALTER TABLE ONLY public.rider_logs DROP CONSTRAINT rider_logs_rider_id_fkey;
       public          postgres    false    227    219    3087         (           2606    30366 '   rider_tracks rider_tracks_order_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.rider_tracks
    ADD CONSTRAINT rider_tracks_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON UPDATE CASCADE ON DELETE SET NULL;
 Q   ALTER TABLE ONLY public.rider_tracks DROP CONSTRAINT rider_tracks_order_id_fkey;
       public          postgres    false    225    3089    221         '           2606    30361 '   rider_tracks rider_tracks_rider_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.rider_tracks
    ADD CONSTRAINT rider_tracks_rider_id_fkey FOREIGN KEY (rider_id) REFERENCES public.riders(id) ON UPDATE CASCADE ON DELETE CASCADE;
 Q   ALTER TABLE ONLY public.rider_tracks DROP CONSTRAINT rider_tracks_rider_id_fkey;
       public          postgres    false    225    219    3087         !           2606    30275    riders riders_user_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.riders
    ADD CONSTRAINT riders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;
 D   ALTER TABLE ONLY public.riders DROP CONSTRAINT riders_user_id_fkey;
       public          postgres    false    3071    203    219         *           2606    30412 6   store_applications store_applications_district_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.store_applications
    ADD CONSTRAINT store_applications_district_id_fkey FOREIGN KEY (district_id) REFERENCES public.districts(id) ON UPDATE CASCADE;
 `   ALTER TABLE ONLY public.store_applications DROP CONSTRAINT store_applications_district_id_fkey;
       public          postgres    false    207    3075    229                    2606    30209 +   store_products store_products_store_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.store_products
    ADD CONSTRAINT store_products_store_id_fkey FOREIGN KEY (store_id) REFERENCES public.stores(id) ON UPDATE CASCADE ON DELETE CASCADE;
 U   ALTER TABLE ONLY public.store_products DROP CONSTRAINT store_products_store_id_fkey;
       public          postgres    false    211    3077    209                    2606    30183    stores stores_district_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.stores
    ADD CONSTRAINT stores_district_id_fkey FOREIGN KEY (district_id) REFERENCES public.districts(id) ON UPDATE CASCADE;
 H   ALTER TABLE ONLY public.stores DROP CONSTRAINT stores_district_id_fkey;
       public          postgres    false    3075    207    209                    2606    30178    stores stores_user_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.stores
    ADD CONSTRAINT stores_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;
 D   ALTER TABLE ONLY public.stores DROP CONSTRAINT stores_user_id_fkey;
       public          postgres    false    203    3071    209                    2606    30112 *   user_addresses user_addresses_user_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.user_addresses
    ADD CONSTRAINT user_addresses_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;
 T   ALTER TABLE ONLY public.user_addresses DROP CONSTRAINT user_addresses_user_id_fkey;
       public          postgres    false    3071    205    203                    2606    30240 /   variant_options variant_options_variant_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.variant_options
    ADD CONSTRAINT variant_options_variant_id_fkey FOREIGN KEY (variant_id) REFERENCES public.variants(id) ON UPDATE CASCADE ON DELETE CASCADE;
 Y   ALTER TABLE ONLY public.variant_options DROP CONSTRAINT variant_options_variant_id_fkey;
       public          postgres    false    3081    215    213                    2606    30223    variants variants_store_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.variants
    ADD CONSTRAINT variants_store_id_fkey FOREIGN KEY (store_id) REFERENCES public.stores(id) ON UPDATE CASCADE ON DELETE CASCADE;
 I   ALTER TABLE ONLY public.variants DROP CONSTRAINT variants_store_id_fkey;
       public          postgres    false    3077    213    209                                                                                                                                                                                                                                                                                                                                                         3262.dat                                                                                            0000600 0004000 0002000 00000005422 14022554213 0014247 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	1	Extra Rice	15	15.00	13.95	t	2021-03-12 00:09:01.642+00	2021-03-12 00:09:01.642+00
2	1	Extra Kimchi	20	20.00	18.60	t	2021-03-12 00:09:01.646+00	2021-03-12 00:09:01.646+00
3	1	Egg	10	10.00	9.30	t	2021-03-12 00:09:01.65+00	2021-03-12 00:09:01.65+00
4	1	Extra Soup	30	30.00	27.90	t	2021-03-12 00:09:01.653+00	2021-03-12 00:09:01.653+00
5	1	Sausage	35	35.00	32.55	t	2021-03-12 00:09:01.656+00	2021-03-12 00:09:01.656+00
6	2	Whipped Cream	15	16.05	15.00	t	2021-03-12 00:09:01.718+00	2021-03-12 00:09:01.718+00
7	3	Whipped Cream	15	15.00	13.95	t	2021-03-12 00:09:01.777+00	2021-03-12 00:09:01.777+00
8	4	Extra Cheese	40	40.00	37.20	t	2021-03-12 00:09:01.837+00	2021-03-12 00:09:01.837+00
9	8	Extra Rice	15	15.00	13.95	t	2021-03-12 00:09:02.048+00	2021-03-12 00:09:02.048+00
10	8	Extra Kimchi	20	20.00	18.60	t	2021-03-12 00:09:02.052+00	2021-03-12 00:09:02.052+00
11	8	Egg	10	10.00	9.30	t	2021-03-12 00:09:02.055+00	2021-03-12 00:09:02.055+00
12	8	Extra Soup	30	30.00	27.90	t	2021-03-12 00:09:02.058+00	2021-03-12 00:09:02.058+00
13	8	Sausage	35	35.00	32.55	t	2021-03-12 00:09:02.061+00	2021-03-12 00:09:02.061+00
14	9	Extra Rice	15	15.00	13.95	t	2021-03-12 00:09:02.142+00	2021-03-12 00:09:02.142+00
15	9	Extra Kimchi	20	20.00	18.60	t	2021-03-12 00:09:02.146+00	2021-03-12 00:09:02.146+00
16	9	Egg	10	10.00	9.30	t	2021-03-12 00:09:02.148+00	2021-03-12 00:09:02.148+00
17	9	Extra Soup	30	30.00	27.90	t	2021-03-12 00:09:02.151+00	2021-03-12 00:09:02.151+00
18	9	Sausage	35	35.00	32.55	t	2021-03-12 00:09:02.154+00	2021-03-12 00:09:02.154+00
19	10	Extra Rice	15	15.00	13.95	t	2021-03-12 00:09:02.237+00	2021-03-12 00:09:02.237+00
20	10	Extra Kimchi	20	20.00	18.60	t	2021-03-12 00:09:02.243+00	2021-03-12 00:09:02.243+00
21	10	Egg	10	10.00	9.30	t	2021-03-12 00:09:02.247+00	2021-03-12 00:09:02.247+00
22	10	Extra Soup	30	30.00	27.90	t	2021-03-12 00:09:02.251+00	2021-03-12 00:09:02.251+00
23	10	Sausage	35	35.00	32.55	t	2021-03-12 00:09:02.256+00	2021-03-12 00:09:02.256+00
24	11	Extra Rice	15	15.00	13.95	t	2021-03-12 00:09:02.358+00	2021-03-12 00:09:02.358+00
25	11	Extra Kimchi	20	20.00	18.60	t	2021-03-12 00:09:02.362+00	2021-03-12 00:09:02.362+00
26	11	Egg	10	10.00	9.30	t	2021-03-12 00:09:02.365+00	2021-03-12 00:09:02.365+00
27	11	Extra Soup	30	30.00	27.90	t	2021-03-12 00:09:02.368+00	2021-03-12 00:09:02.368+00
28	11	Sausage	35	35.00	32.55	t	2021-03-12 00:09:02.372+00	2021-03-12 00:09:02.372+00
29	12	Extra Rice	15	15.00	13.95	t	2021-03-12 00:09:02.457+00	2021-03-12 00:09:02.457+00
30	12	Extra Kimchi	20	20.00	18.60	t	2021-03-12 00:09:02.461+00	2021-03-12 00:09:02.461+00
31	12	Egg	10	10.00	9.30	t	2021-03-12 00:09:02.463+00	2021-03-12 00:09:02.463+00
32	12	Extra Soup	30	30.00	27.90	t	2021-03-12 00:09:02.469+00	2021-03-12 00:09:02.469+00
33	12	Sausage	35	35.00	32.55	t	2021-03-12 00:09:02.473+00	2021-03-12 00:09:02.473+00
\.


                                                                                                                                                                                                                                              3246.dat                                                                                            0000600 0004000 0002000 00000012020 14022554213 0014241 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	3	24	7	{"name":"Americano","price":"130.00","customer_price":"130.00","seller_price":"120.90","image":"http://18.166.234.218:8000/public/store/restaurants/3-1.png"}	495.00	495.00	460.35	[{"id":1,"pick_id":2,"name":"Size","price":"20.00","customer_price":"20.00","seller_price":"18.60","pick":"Medium"}]	[{"id":1,"name":"Whipped Cream","price":"15.00","customer_price":"15.00","seller_price":"13.95"}]	3	\N	ordered	2021-02-19 07:30:13.363+00	2021-02-19 07:44:41.706+00
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


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                3268.dat                                                                                            0000600 0004000 0002000 00000012542 14022554213 0014256 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	17	2	Hi, This is your driver Carl Manahan. I'm currently on the way to the store to pick up your order.	2021-03-12 01:10:13.524+00
2	17	2	I'm near, please be ready. Thank you!	2021-03-12 01:10:21.789+00
3	16	3	Hi, This is your driver John Carlos. I'm currently on the way to the store to pick up your order.	2021-03-12 01:23:14.881+00
4	16	3	I'm near, please be ready. Thank you!	2021-03-12 01:23:20.325+00
5	17	2	Your order has been picked up by your Driver	2021-03-12 01:23:44.223+00
6	17	4	Hi, This is your driver Carl Manahan. I'm currently on the way to the store to pick up your order.	2021-03-12 01:24:26.529+00
7	17	4	I'm near, please be ready. Thank you!	2021-03-12 01:24:32.795+00
8	16	3	Your order has been picked up by your Driver	2021-03-12 01:24:41.201+00
9	32	3	hello	2021-03-12 01:24:58.737+00
10	16	3	hsjjrsstj	2021-03-12 01:25:05.72+00
11	16	3	standard\tvs\tvs\tc	2021-03-12 01:25:19.361+00
12	16	3	fhhhhx	2021-03-12 01:25:30.883+00
13	16	3	hxdhdydysg	2021-03-12 01:25:49.507+00
14	16	5	Hi, This is your driver John Carlos. I'm currently on the way to the store to pick up your order.	2021-03-12 01:27:42.584+00
15	16	5	I'm near, please be ready. Thank you!	2021-03-12 01:27:48.921+00
16	16	5	Your order has been picked up by your Driver	2021-03-12 01:27:58.843+00
17	16	5	fsdghfhchch	2021-03-12 01:28:17.429+00
18	32	5	hi	2021-03-12 01:28:27.727+00
19	16	5	nfxxfhx	2021-03-12 01:28:39.657+00
20	32	5	ahradh	2021-03-12 01:28:46.295+00
21	16	5	sjxmg	2021-03-12 01:28:51.223+00
22	32	5	afjfNf	2021-03-12 01:29:01.975+00
23	16	5	xbfbnfxjgd	2021-03-12 01:29:04.001+00
24	16	5	zngsdgj	2021-03-12 01:29:11.988+00
25	16	5	abner	2021-03-12 01:29:18.786+00
26	16	6	Hi, This is your driver John Carlos. I'm currently on the way to the store to pick up your order.	2021-03-12 01:30:41.917+00
27	32	6	ok	2021-03-12 01:30:54.245+00
28	16	6	I'm near, please be ready. Thank you!	2021-03-12 01:30:54.701+00
29	16	6	hcchcj	2021-03-12 01:31:28.981+00
30	32	6	 ff ff	2021-03-12 01:31:38.302+00
31	32	6	bad fafnafna	2021-03-12 01:32:03.854+00
32	16	6	kgcgjdkykdykd	2021-03-12 01:32:09.421+00
33	16	6	xhfxfhsfj	2021-03-12 01:32:23.857+00
34	16	6	htdsjdjtdgsfjgjdgjxgjxcgjgkcckhkhv	2021-03-12 01:32:37.869+00
35	16	6	th 	2021-03-12 01:32:43.035+00
36	16	6	vr	2021-03-12 01:32:43.221+00
37	16	6	vs vs vr	2021-03-12 01:32:43.518+00
38	16	6	vs d	2021-03-12 01:32:43.601+00
39	16	6	d v	2021-03-12 01:32:43.723+00
40	16	6	vd	2021-03-12 01:32:43.837+00
41	16	6	vdfevge	2021-03-12 01:32:44.087+00
42	16	6	v	2021-03-12 01:32:44.203+00
43	16	6	vfevfw	2021-03-12 01:32:44.464+00
44	16	6	vfwv	2021-03-12 01:32:44.715+00
45	32	6	sngagjxxxx	2021-03-12 01:33:08.55+00
46	16	6	fhzshfshfsfsjg	2021-03-12 01:33:27.051+00
47	16	6	eef	2021-03-12 01:33:41.187+00
48	16	6	eefvf	2021-03-12 01:33:41.289+00
49	16	6	eefvfev	2021-03-12 01:33:41.365+00
50	16	6	eefvfevfw	2021-03-12 01:33:41.472+00
51	16	6	vfwv	2021-03-12 01:33:41.672+00
52	16	6	vfwvfvwf	2021-03-12 01:33:45.658+00
53	16	6	Your order has been picked up by your Driver	2021-03-12 01:33:50.275+00
54	16	6	kchkkxkg	2021-03-12 01:35:44.863+00
55	32	6	hi	2021-03-12 01:37:06.363+00
56	16	6	cggcg	2021-03-12 01:37:09.786+00
57	16	6	jgdg	2021-03-12 01:37:13.762+00
58	16	6	jgcjjg	2021-03-12 01:37:14.885+00
59	16	6	xjgcjg	2021-03-12 01:37:15.969+00
60	32	6	nckd	2021-03-12 01:37:21.325+00
61	16	6	wrgfev	2021-03-12 01:37:23.67+00
62	16	6	bsfbsfbb	2021-03-12 01:37:28.026+00
63	16	6	b	2021-03-12 01:37:29.208+00
64	16	6	f2fngd	2021-03-12 01:37:30.638+00
65	16	6	fhhmf	2021-03-12 01:37:31.855+00
66	16	7	Hi, This is your driver John Carlos. I'm currently on the way to the store to pick up your order.	2021-03-12 01:57:18.278+00
67	16	7	I'm near, please be ready. Thank you!	2021-03-12 01:57:24.951+00
68	16	7	Your order has been picked up by your Driver	2021-03-12 01:57:57.843+00
69	17	4	Your order has been picked up by your Driver	2021-03-12 02:30:26.572+00
70	17	8	Hi, This is your driver Carl Manahan. I'm currently on the way to the store to pick up your order.	2021-03-12 02:30:54.641+00
71	17	8	I'm near, please be ready. Thank you!	2021-03-12 02:31:13.788+00
72	17	8	Your order has been picked up by your Driver	2021-03-12 02:32:02.261+00
73	17	9	Hi, This is your driver Carl Manahan. I'm currently on the way to the store to pick up your order.	2021-03-12 02:32:54.374+00
74	17	9	I'm near, please be ready. Thank you!	2021-03-12 02:33:09.065+00
75	17	9	Your order has been picked up by your Driver	2021-03-12 02:38:32.517+00
76	16	10	Hi, This is your driver John Carlos. I'm currently on the way to the store to pick up your order.	2021-03-12 02:39:48.045+00
77	16	10	Your order has been picked up by your Driver	2021-03-12 02:40:05.227+00
78	16	10	I'm near, please be ready. Thank you!	2021-03-12 02:40:05.466+00
79	17	11	Hi, This is your driver Carl Manahan. I'm currently on the way to the store to pick up your order.	2021-03-12 02:41:50.748+00
80	17	11	I'm near, please be ready. Thank you!	2021-03-12 02:41:57.883+00
81	17	11	Your order has been picked up by your Driver	2021-03-12 02:42:53.722+00
82	16	12	Hi, This is your driver John Carlos. I'm currently on the way to the store to pick up your order.	2021-03-12 02:47:09.831+00
83	16	12	I'm near, please be ready. Thank you!	2021-03-12 02:47:15.731+00
84	16	12	Your order has been picked up by your Driver	2021-03-12 02:48:07.31+00
85	17	13	Hi, This is your driver Carl Manahan. I'm currently on the way to the store to pick up your order.	2021-03-12 02:54:45.757+00
\.


                                                                                                                                                              3252.dat                                                                                            0000600 0004000 0002000 00000002553 14022554213 0014250 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	all	\N	2021-03-12 00:09:01.414+00	2021-03-12 00:09:01.414+00
2	Angeles City	2009	2021-03-12 00:09:01.423+00	2021-03-12 00:09:01.423+00
3	Mabalacat	2010	2021-03-12 00:09:01.426+00	2021-03-12 00:09:01.426+00
4	San Fernando	2000	2021-03-12 00:09:01.428+00	2021-03-12 00:09:01.428+00
5	Manila	\N	2021-03-12 00:09:01.431+00	2021-03-12 00:09:01.431+00
6	Caloocan	\N	2021-03-12 00:09:01.434+00	2021-03-12 00:09:01.434+00
7	Las Pinas	\N	2021-03-12 00:09:01.442+00	2021-03-12 00:09:01.442+00
8	Makati	\N	2021-03-12 00:09:01.445+00	2021-03-12 00:09:01.445+00
9	Malabon	\N	2021-03-12 00:09:01.448+00	2021-03-12 00:09:01.448+00
10	Mandaluyong	\N	2021-03-12 00:09:01.453+00	2021-03-12 00:09:01.453+00
11	Marikina	\N	2021-03-12 00:09:01.456+00	2021-03-12 00:09:01.456+00
12	Muntinlupa	\N	2021-03-12 00:09:01.459+00	2021-03-12 00:09:01.459+00
13	Navotas	\N	2021-03-12 00:09:01.462+00	2021-03-12 00:09:01.462+00
14	paranaque	\N	2021-03-12 00:09:01.465+00	2021-03-12 00:09:01.465+00
15	pasay	\N	2021-03-12 00:09:01.468+00	2021-03-12 00:09:01.468+00
16	pasig	\N	2021-03-12 00:09:01.471+00	2021-03-12 00:09:01.471+00
17	Quezon City	\N	2021-03-12 00:09:01.474+00	2021-03-12 00:09:01.474+00
18	San Juan	\N	2021-03-12 00:09:01.477+00	2021-03-12 00:09:01.477+00
19	Taguig	\N	2021-03-12 00:09:01.48+00	2021-03-12 00:09:01.48+00
20	Valenzuela City	\N	2021-03-12 00:09:01.482+00	2021-03-12 00:09:01.482+00
\.


                                                                                                                                                     3266.dat                                                                                            0000600 0004000 0002000 00000033010 14022554213 0014245 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	1	1	26	\N	store-declined	[{"product_id":1,"name":"Sundaeguk ","price":"300","customer_price":"300.00","seller_price":"279.00","quantity":1,"variants":[{"type":"Choice of Drinks","price":"15.00","customer_price":"15.00","seller_price":"13.95","pick":"Pineapple juice"},{"type":"Choice of Meat","price":"0.00","customer_price":"0.00","seller_price":"0.00","pick":"Sausage"}],"additionals":[],"note":"","removable":false}]	{"sub_total":"315.00","delivery":"60.00","discount_code":null,"discount_price":0,"total_price":"315.00","customer_total_price":"375.00","seller_total_price":"292.95"}	{"store_pick_time":"2021-03-12T00:38:45.485Z","store_estimated_time":null,"rider_pick_time":null,"rider_pick_up_time":null,"rider_estimated_time":null,"delivered_time":null,"is_near":null}	{"location":{"lat":15.161082910242591,"lng":120.55571302771568},"complete_address":"Friendship Highway Margot, Angeles City Pampanga","note":"tesst"}	{"method":"cod","status":"pending","details":{}}	commission	Item not available	2021-03-12 00:26:38.529936+00	2021-03-12 00:38:45.491+00
2	1	6	31	2	delivered	[{"product_id":16,"name":"Shabu Shabu Mix","price":"510","customer_price":"527.84","seller_price":"492.15","quantity":4,"variants":[],"additionals":[],"note":"","removable":false},{"product_id":17,"name":"Mango Powder","price":"250","customer_price":"258.75","seller_price":"241.25","quantity":3,"variants":[],"additionals":[],"note":"","removable":false}]	{"sub_total":"2887.61","delivery":"10.00","discount_code":null,"discount_price":0,"total_price":"2790.00","customer_total_price":"2897.61","seller_total_price":"2692.35"}	{"store_pick_time":null,"store_estimated_time":null,"rider_pick_time":"2021-03-12T01:10:13.516Z","rider_pick_up_time":"2021-03-12T01:23:44.215Z","rider_estimated_time":null,"delivered_time":"2021-03-12T01:23:54.971Z","is_near":true}	{"location":{"lat":15.1626758,"lng":120.5565679},"complete_address":"355 Yukon St , Angeles Central Luzon","note":""}	{"method":"cod","status":"pending","details":{}}	half		2021-03-12 01:09:09.572551+00	2021-03-12 01:23:54.994+00
3	2	1	32	1	delivered	[{"product_id":1,"name":"Sundaeguk ","price":"300","customer_price":"300.00","seller_price":"279.00","quantity":1,"variants":[{"type":"Choice of Drinks","price":"0.00","customer_price":"0.00","seller_price":"0.00","pick":"Coke"},{"type":"Choice of Meat","price":"0.00","customer_price":"0.00","seller_price":"0.00","pick":"Sausage"}],"additionals":[{"id":2,"name":"Extra Kimchi","price":"20.00","customer_price":"20.00","seller_price":"18.60"},{"id":1,"name":"Extra Rice","price":"15.00","customer_price":"15.00","seller_price":"13.95"},{"id":3,"name":"Egg","price":"10.00","customer_price":"10.00","seller_price":"9.30"},{"id":4,"name":"Extra Soup","price":"30.00","customer_price":"30.00","seller_price":"27.90"},{"id":5,"name":"Sausage","price":"35.00","customer_price":"35.00","seller_price":"32.54"}],"note":"snl s kbocosbxoboxbso bls bsichiabxoa osxobw","removable":true}]	{"sub_total":"410.00","delivery":"60.00","discount_code":null,"discount_price":0,"total_price":"410.00","customer_total_price":"470.00","seller_total_price":"381.30"}	{"store_pick_time":"2021-03-12T01:22:45.447Z","store_estimated_time":"50 Minutes","rider_pick_time":"2021-03-12T01:23:14.872Z","rider_pick_up_time":"2021-03-12T01:24:41.183Z","rider_estimated_time":null,"delivered_time":"2021-03-12T01:27:14.150Z","is_near":true}	{"location":{"lat":15.1626116224192,"lng":120.55652808398008},"complete_address":"Yukon Street Margot, Angeles City Pampanga","note":"tyyyygft"}	{"method":"cod","status":"pending","details":{}}	commission		2021-03-12 01:21:45.679027+00	2021-03-12 01:27:14.164+00
4	2	6	31	2	delivered	[{"product_id":16,"name":"Shabu Shabu Mix","price":"510","customer_price":"527.84","seller_price":"492.15","quantity":4,"variants":[],"additionals":[],"note":"","removable":false},{"product_id":17,"name":"Mango Powder","price":"250","customer_price":"258.75","seller_price":"241.25","quantity":5,"variants":[],"additionals":[],"note":"","removable":false}]	{"sub_total":"3405.11","delivery":"10.00","discount_code":null,"discount_price":0,"total_price":"3290.00","customer_total_price":"3415.11","seller_total_price":"3174.85"}	{"store_pick_time":null,"store_estimated_time":null,"rider_pick_time":"2021-03-12T01:24:26.516Z","rider_pick_up_time":"2021-03-12T02:30:26.562Z","rider_estimated_time":null,"delivered_time":"2021-03-12T02:30:34.581Z","is_near":true}	{"location":{"lat":15.1626758,"lng":120.5565679},"complete_address":"355 Yukon St , Angeles Central Luzon","note":""}	{"method":"cod","status":"pending","details":{}}	half		2021-03-12 01:24:05.679502+00	2021-03-12 02:30:34.588+00
5	3	1	32	1	delivered	[{"product_id":1,"name":"Sundaeguk ","price":"300","customer_price":"300.00","seller_price":"279.00","quantity":1,"variants":[{"type":"Choice of Drinks","price":"0.00","customer_price":"0.00","seller_price":"0.00","pick":"Sprite"},{"type":"Choice of Meat","price":"20.00","customer_price":"20.00","seller_price":"18.60","pick":"Beef"}],"additionals":[{"id":5,"name":"Sausage","price":"35.00","customer_price":"35.00","seller_price":"32.54"}],"note":"","removable":false}]	{"sub_total":"355.00","delivery":"60.00","discount_code":null,"discount_price":0,"total_price":"355.00","customer_total_price":"415.00","seller_total_price":"330.15"}	{"store_pick_time":"2021-03-12T01:27:25.766Z","store_estimated_time":"50 Minutes","rider_pick_time":"2021-03-12T01:27:42.577Z","rider_pick_up_time":"2021-03-12T01:27:58.834Z","rider_estimated_time":null,"delivered_time":"2021-03-12T01:29:42.037Z","is_near":true}	{"location":{"lat":15.1626116224192,"lng":120.55652808398008},"complete_address":"Yukon Street Margot, Angeles City Pampanga","note":"tyyyygft"}	{"method":"cod","status":"pending","details":{}}	commission		2021-03-12 01:26:46.976905+00	2021-03-12 01:29:42.073+00
6	4	1	32	1	delivered	[{"product_id":1,"name":"Sundaeguk ","price":"300","customer_price":"300.00","seller_price":"279.00","quantity":1,"variants":[{"type":"Choice of Drinks","price":"0.00","customer_price":"0.00","seller_price":"0.00","pick":"Sprite"},{"type":"Choice of Meat","price":"20.00","customer_price":"20.00","seller_price":"18.60","pick":"Beef"}],"additionals":[],"note":"","removable":false}]	{"sub_total":"320.00","delivery":"60.00","discount_code":null,"discount_price":0,"total_price":"320.00","customer_total_price":"380.00","seller_total_price":"297.60"}	{"store_pick_time":"2021-03-12T01:29:51.679Z","store_estimated_time":"50 Minutes","rider_pick_time":"2021-03-12T01:30:41.901Z","rider_pick_up_time":"2021-03-12T01:33:50.267Z","rider_estimated_time":null,"delivered_time":"2021-03-12T01:43:41.682Z","is_near":true}	{"location":{"lat":15.1626116224192,"lng":120.55652808398008},"complete_address":"Yukon Street Margot, Angeles City Pampanga","note":"tyyyygft"}	{"method":"cod","status":"pending","details":{}}	commission		2021-03-12 01:29:45.981422+00	2021-03-12 01:43:41.708+00
8	4	6	31	2	delivered	[{"product_id":18,"name":"Durian","price":"260","customer_price":"269.09","seller_price":"250.90","quantity":4,"variants":[],"additionals":[],"note":"","removable":false}]	{"sub_total":"1076.35","delivery":"10.00","discount_code":null,"discount_price":0,"total_price":"1040.00","customer_total_price":"1086.35","seller_total_price":"1003.60"}	{"store_pick_time":null,"store_estimated_time":null,"rider_pick_time":"2021-03-12T02:30:54.633Z","rider_pick_up_time":"2021-03-12T02:32:02.252Z","rider_estimated_time":null,"delivered_time":"2021-03-12T02:32:23.293Z","is_near":true}	{"location":{"lat":15.1626758,"lng":120.5565679},"complete_address":"355 Yukon St , Angeles Central Luzon","note":""}	{"method":"cod","status":"pending","details":{}}	half		2021-03-12 02:30:45.36534+00	2021-03-12 02:32:23.308+00
9	5	6	31	2	delivered	[{"product_id":18,"name":"Durian","price":"260","customer_price":"269.09","seller_price":"250.90","quantity":3,"variants":[],"additionals":[],"note":"","removable":false},{"product_id":19,"name":"Samanco","price":"30","customer_price":"31.04","seller_price":"28.95","quantity":3,"variants":[],"additionals":[],"note":"","removable":false},{"product_id":17,"name":"Mango Powder","price":"250","customer_price":"258.75","seller_price":"241.25","quantity":1,"variants":[],"additionals":[],"note":"","removable":false},{"product_id":16,"name":"Shabu Shabu Mix","price":"510","customer_price":"527.84","seller_price":"492.15","quantity":1,"variants":[],"additionals":[],"note":"","removable":false}]	{"sub_total":"1686.98","delivery":"10.00","discount_code":null,"discount_price":0,"total_price":"1630.00","customer_total_price":"1696.98","seller_total_price":"1572.95"}	{"store_pick_time":null,"store_estimated_time":null,"rider_pick_time":"2021-03-12T02:32:54.363Z","rider_pick_up_time":"2021-03-12T02:38:32.503Z","rider_estimated_time":null,"delivered_time":"2021-03-12T02:38:52.472Z","is_near":true}	{"location":{"lat":15.1626758,"lng":120.5565679},"complete_address":"355 Yukon St , Angeles Central Luzon","note":""}	{"method":"cod","status":"pending","details":{}}	half		2021-03-12 02:32:13.473196+00	2021-03-12 02:38:52.484+00
7	3	6	31	1	delivered	[{"product_id":16,"name":"Shabu Shabu Mix","price":"510","customer_price":"527.84","seller_price":"492.15","quantity":3,"variants":[],"additionals":[],"note":"","removable":false},{"product_id":18,"name":"Durian","price":"260","customer_price":"269.09","seller_price":"250.90","quantity":4,"variants":[],"additionals":[],"note":"","removable":false}]	{"sub_total":"2659.88","delivery":"10.00","discount_code":null,"discount_price":0,"total_price":"2570.00","customer_total_price":"2669.88","seller_total_price":"2480.04"}	{"store_pick_time":null,"store_estimated_time":null,"rider_pick_time":"2021-03-12T01:57:18.267Z","rider_pick_up_time":"2021-03-12T01:57:57.824Z","rider_estimated_time":null,"delivered_time":"2021-03-12T01:58:02.313Z","is_near":true}	{"location":{"lat":15.1626758,"lng":120.5565679},"complete_address":"355 Yukon St , Angeles Central Luzon","note":""}	{"method":"cod","status":"pending","details":{}}	half		2021-03-12 01:57:14.295137+00	2021-03-12 01:58:02.323+00
10	6	6	31	1	delivered	[{"product_id":16,"name":"Shabu Shabu Mix","price":"510","customer_price":"527.84","seller_price":"492.15","quantity":5,"variants":[],"additionals":[],"note":"","removable":false}]	{"sub_total":"2639.20","delivery":"10.00","discount_code":null,"discount_price":0,"total_price":"2550.00","customer_total_price":"2649.20","seller_total_price":"2460.75"}	{"store_pick_time":null,"store_estimated_time":null,"rider_pick_time":"2021-03-12T02:39:48.036Z","rider_pick_up_time":"2021-03-12T02:40:05.224Z","rider_estimated_time":null,"delivered_time":"2021-03-12T02:40:13.355Z","is_near":true}	{"location":{"lat":15.1626758,"lng":120.5565679},"complete_address":"355 Yukon St , Angeles Central Luzon","note":""}	{"method":"cod","status":"pending","details":{}}	half		2021-03-12 02:39:34.655072+00	2021-03-12 02:40:13.377+00
11	7	6	31	2	delivered	[{"product_id":17,"name":"Mango Powder","price":"250","customer_price":"258.75","seller_price":"241.25","quantity":1,"variants":[],"additionals":[],"note":"","removable":false}]	{"sub_total":"258.75","delivery":"10.00","discount_code":null,"discount_price":0,"total_price":"250.00","customer_total_price":"268.75","seller_total_price":"241.25"}	{"store_pick_time":null,"store_estimated_time":null,"rider_pick_time":"2021-03-12T02:41:50.740Z","rider_pick_up_time":"2021-03-12T02:42:53.695Z","rider_estimated_time":null,"delivered_time":"2021-03-12T02:43:01.816Z","is_near":true}	{"location":{"lat":15.1626758,"lng":120.5565679},"complete_address":"355 Yukon St , Angeles Central Luzon","note":""}	{"method":"cod","status":"pending","details":{}}	half		2021-03-12 02:39:56.512679+00	2021-03-12 02:43:01.847+00
12	5	1	32	1	delivered	[{"product_id":1,"name":"Sundaeguk ","price":"300","customer_price":"300.00","seller_price":"279.00","quantity":1,"variants":[{"type":"Choice of Drinks","price":"0.00","customer_price":"0.00","seller_price":"0.00","pick":"Coke"},{"type":"Choice of Meat","price":"0.00","customer_price":"0.00","seller_price":"0.00","pick":"Sausage"}],"additionals":[{"id":2,"name":"Extra Kimchi","price":"20.00","customer_price":"20.00","seller_price":"18.60"}],"note":"bhgg","removable":false}]	{"sub_total":"320.00","delivery":"60.00","discount_code":null,"discount_price":0,"total_price":"320.00","customer_total_price":"380.00","seller_total_price":"297.60"}	{"store_pick_time":"2021-03-12T02:46:40.421Z","store_estimated_time":"10 Minutes","rider_pick_time":"2021-03-12T02:47:09.821Z","rider_pick_up_time":"2021-03-12T02:48:07.300Z","rider_estimated_time":null,"delivered_time":"2021-03-12T02:53:23.410Z","is_near":true}	{"location":{"lat":15.1626116224192,"lng":120.55652808398008},"complete_address":"Yukon Street Margot, Angeles City Pampanga","note":"tyyyygft"}	{"method":"cod","status":"pending","details":{}}	commission		2021-03-12 02:44:15.320638+00	2021-03-12 02:53:23.422+00
13	8	6	32	2	rider-accepted	[{"product_id":16,"name":"Shabu Shabu Mix","price":"510","customer_price":"527.84","seller_price":"492.15","quantity":1,"variants":[],"additionals":[],"note":"","removable":true}]	{"sub_total":"527.84","delivery":"10.00","discount_code":null,"discount_price":0,"total_price":"510.00","customer_total_price":"537.84","seller_total_price":"492.15"}	{"store_pick_time":null,"store_estimated_time":null,"rider_pick_time":"2021-03-12T02:54:45.744Z","rider_pick_up_time":null,"rider_estimated_time":null,"delivered_time":null,"is_near":null}	{"location":{"lat":15.1626116224192,"lng":120.55652808398008},"complete_address":"Yukon Street Margot, Angeles City Pampanga","note":"tyyyygft"}	{"method":"cod","status":"pending","details":{}}	half		2021-03-12 02:54:39.993406+00	2021-03-12 02:54:45.756+00
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        3272.dat                                                                                            0000600 0004000 0002000 00000000005 14022554213 0014240 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           3270.dat                                                                                            0000600 0004000 0002000 00000161602 14022554213 0014251 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:14:56.768+00
2	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:15:37.769+00
3	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:16:08.694+00
4	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:16:39.934+00
5	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:16:59.916+00
6	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:17:29.255+00
7	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:18:02.456+00
8	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:18:29.2+00
9	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:19:05.065+00
10	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:19:28.947+00
11	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:20:07.642+00
12	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:20:37.023+00
13	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:21:28.941+00
14	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:22:00.928+00
15	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:22:28.92+00
16	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:23:07.129+00
17	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:23:28.917+00
18	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:23:56.942+00
19	1	\N	{"lat":"15.162545","lng":"120.5565584"}	2021-03-12 00:24:56.518+00
20	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:25:07.059+00
21	1	\N	{"lat":"15.162545","lng":"120.5565584"}	2021-03-12 00:25:27.366+00
22	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:25:30.092+00
23	1	\N	{"lat":"15.162545","lng":"120.5565584"}	2021-03-12 00:26:11.292+00
24	1	\N	{"lat":"15.162545","lng":"120.5565584"}	2021-03-12 00:26:25.155+00
25	1	\N	{"lat":"15.162545","lng":"120.5565584"}	2021-03-12 00:26:27.004+00
26	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:26:27.946+00
27	1	\N	{"lat":"15.162545","lng":"120.5565584"}	2021-03-12 00:26:28.306+00
28	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:26:56.945+00
29	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:27:13.709+00
30	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:27:20.734+00
31	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:45:08.802+00
32	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:45:43.058+00
33	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:45:53.879+00
34	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:46:29.64+00
35	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:46:33.136+00
36	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:46:35.387+00
37	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:46:39.347+00
38	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:47:09.525+00
39	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:47:42.521+00
40	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:48:12.524+00
41	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:48:40.504+00
42	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:49:12.69+00
43	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:49:41.473+00
44	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:50:14.671+00
45	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:50:45.102+00
46	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:51:13.677+00
47	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:51:39.516+00
48	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:52:10.489+00
49	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:56:20.984+00
50	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:56:53.464+00
51	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:57:21.241+00
52	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:57:58.239+00
53	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:58:22.283+00
54	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:58:53.238+00
55	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:59:21.207+00
56	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 00:59:54.212+00
57	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 01:00:31.522+00
58	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 01:00:53.436+00
59	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 01:01:22.347+00
60	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 01:01:56.531+00
61	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 01:02:21.256+00
62	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 01:02:58.149+00
63	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 01:06:30.155+00
64	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 01:06:42.524+00
65	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 01:07:13.728+00
66	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 01:07:45.073+00
67	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 01:08:17.866+00
68	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 01:08:45.835+00
69	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 01:09:12.824+00
70	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 01:09:49.832+00
71	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 01:10:23.208+00
72	1	\N	{"lat":"15.1626012","lng":"120.5565721"}	2021-03-12 01:15:46.038+00
73	1	\N	{"lat":"15.1626012","lng":"120.5565721"}	2021-03-12 01:16:01.765+00
74	1	\N	{"lat":"15.1626012","lng":"120.5565721"}	2021-03-12 01:16:41.969+00
75	1	\N	{"lat":"15.1626012","lng":"120.5565721"}	2021-03-12 01:17:06.069+00
76	1	\N	{"lat":"15.1626012","lng":"120.5565721"}	2021-03-12 01:17:32.552+00
77	1	\N	{"lat":"15.1626012","lng":"120.5565721"}	2021-03-12 01:18:02.947+00
78	1	\N	{"lat":"15.1626012","lng":"120.5565721"}	2021-03-12 01:18:33.068+00
79	1	\N	{"lat":"15.1626012","lng":"120.5565721"}	2021-03-12 01:23:03.208+00
80	1	\N	{"lat":"15.1626012","lng":"120.5565721"}	2021-03-12 01:23:10.407+00
81	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:10:18.577+00
82	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:10:23.575+00
83	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:10:28.582+00
84	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:10:33.58+00
85	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:10:38.578+00
86	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:10:43.574+00
87	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:10:48.579+00
88	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:10:53.578+00
89	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:10:58.575+00
90	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:11:03.578+00
91	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:11:08.574+00
92	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:11:13.578+00
93	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:11:18.584+00
94	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:11:23.587+00
95	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:11:28.59+00
96	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:11:33.59+00
97	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:11:38.593+00
98	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:11:43.591+00
99	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:11:48.595+00
100	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:11:53.597+00
101	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:11:58.594+00
102	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:12:03.593+00
103	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:12:08.593+00
104	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:12:13.592+00
105	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:12:18.593+00
106	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:12:23.595+00
107	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:12:28.593+00
108	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:12:33.594+00
109	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:12:38.594+00
110	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:12:43.591+00
111	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:12:48.589+00
112	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:12:53.594+00
113	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:12:58.591+00
114	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:13:03.591+00
115	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:13:08.59+00
116	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:13:13.589+00
117	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:13:18.59+00
118	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:13:23.589+00
119	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:13:28.59+00
120	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:13:33.586+00
121	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:13:38.585+00
122	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:13:43.587+00
123	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:13:48.59+00
124	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:13:53.583+00
125	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:13:58.59+00
126	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:14:03.584+00
127	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:14:08.588+00
128	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:14:13.586+00
129	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:14:18.589+00
130	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:14:23.582+00
131	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:14:28.586+00
132	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:14:33.582+00
133	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:14:38.586+00
134	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:14:43.59+00
135	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:14:48.58+00
136	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:14:53.586+00
137	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:14:58.583+00
138	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:15:03.584+00
139	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:15:08.584+00
140	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:15:13.585+00
141	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:15:18.578+00
142	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:15:23.581+00
143	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:15:28.584+00
144	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:15:33.584+00
145	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:15:38.58+00
146	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:15:43.582+00
147	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:15:48.582+00
148	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:15:53.581+00
149	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:15:58.584+00
150	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:16:03.588+00
151	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:16:08.592+00
152	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:16:13.594+00
153	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:16:18.591+00
154	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:16:23.614+00
155	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:16:28.604+00
156	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:16:33.601+00
157	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:16:38.598+00
158	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:16:43.599+00
159	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:16:48.602+00
160	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:16:53.6+00
161	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:16:58.592+00
162	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:17:03.598+00
163	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:17:08.597+00
164	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:17:13.599+00
165	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:17:18.6+00
166	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:17:23.599+00
167	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:17:28.594+00
168	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:17:33.599+00
169	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:17:38.603+00
170	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:17:43.596+00
171	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:17:48.592+00
172	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:17:53.596+00
173	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:17:58.598+00
174	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:18:03.594+00
175	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:18:08.589+00
176	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:18:13.6+00
177	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:18:18.593+00
178	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:18:23.616+00
179	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:18:28.694+00
180	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:18:33.589+00
181	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:18:38.59+00
182	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:18:43.595+00
183	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:18:48.592+00
184	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:18:53.589+00
185	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:18:58.591+00
186	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:19:03.591+00
187	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:19:08.6+00
188	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:19:13.594+00
189	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:19:18.592+00
190	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:19:23.597+00
191	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:19:28.588+00
192	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:19:33.591+00
193	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:19:38.595+00
194	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:19:43.592+00
195	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:19:48.593+00
196	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:19:53.598+00
197	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:19:58.588+00
198	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:20:03.59+00
199	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:20:08.594+00
200	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:20:13.586+00
201	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:20:18.59+00
202	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:20:23.59+00
203	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:20:28.589+00
204	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:20:33.588+00
205	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:20:38.588+00
206	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:20:43.587+00
207	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:20:48.586+00
208	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:20:53.585+00
209	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:20:58.585+00
210	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:21:03.584+00
211	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:21:08.582+00
212	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:21:13.585+00
213	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:21:18.585+00
214	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:21:23.59+00
215	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:21:28.581+00
216	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:21:33.585+00
217	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:21:38.585+00
218	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:21:43.586+00
219	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:21:48.582+00
220	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:21:53.579+00
221	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:21:58.585+00
222	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:22:03.58+00
223	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:22:08.579+00
224	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:22:13.579+00
225	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:22:18.578+00
226	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:22:23.578+00
227	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:22:28.579+00
228	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:22:33.583+00
229	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:22:38.577+00
230	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:22:43.578+00
231	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:22:48.58+00
232	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:22:53.585+00
233	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:22:58.576+00
234	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:23:03.58+00
235	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:23:08.582+00
236	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:23:13.579+00
237	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:23:18.578+00
238	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:23:23.577+00
239	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:23:28.578+00
240	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:23:33.574+00
241	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:23:38.576+00
242	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:23:43.578+00
243	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:23:47.593+00
244	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:23:48.574+00
245	2	2	{"lat":15.162884,"lng":120.55664}	2021-03-12 01:23:53.577+00
246	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 01:23:57.286+00
247	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:23:24.52+00
248	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:23:29.509+00
249	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:23:34.54+00
250	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:23:39.505+00
251	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:23:44.525+00
252	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:23:49.519+00
253	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:23:54.531+00
254	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:23:59.529+00
255	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:24:04.524+00
256	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:24:09.53+00
257	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:24:14.539+00
258	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:24:19.528+00
259	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:24:24.513+00
260	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:24:29.555+00
261	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:24:34.54+00
262	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:24:39.526+00
263	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:24:44.539+00
264	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:24:49.509+00
265	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:24:54.523+00
266	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:24:59.724+00
267	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:25:04.515+00
268	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:25:09.518+00
269	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:25:14.521+00
270	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:25:19.512+00
271	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:25:24.512+00
272	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:25:29.522+00
273	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:25:34.513+00
274	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:25:39.521+00
275	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:25:44.521+00
276	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:25:49.52+00
277	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:25:54.516+00
278	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:25:59.507+00
279	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:26:04.509+00
280	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:26:09.542+00
281	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:26:14.513+00
282	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:26:16.48+00
283	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:26:19.522+00
284	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:26:24.546+00
285	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:26:29.528+00
286	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:26:34.522+00
287	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:26:39.539+00
288	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:26:44.536+00
289	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:26:49.509+00
290	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:26:54.514+00
291	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:26:59.518+00
292	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:27:04.524+00
293	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:27:07.648+00
294	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:27:10.215+00
295	1	3	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:27:15.197+00
296	1	\N	{"lat":"15.1626012","lng":"120.5565721"}	2021-03-12 01:27:24.369+00
297	1	\N	{"lat":"15.1626012","lng":"120.5565721"}	2021-03-12 01:27:41.441+00
298	1	\N	{"lat":"15.1626012","lng":"120.5565721"}	2021-03-12 01:27:47.233+00
299	1	\N	{"lat":"15.1626707","lng":"120.5565658"}	2021-03-12 01:28:49+00
300	1	\N	{"lat":"15.1626466","lng":"120.556565"}	2021-03-12 01:29:17.968+00
301	1	5	{"lat":15.1626012,"lng":120.5565721}	2021-03-12 01:27:52.22+00
302	1	5	{"lat":15.1626707,"lng":120.5565658}	2021-03-12 01:27:57.229+00
303	1	5	{"lat":15.1626707,"lng":120.5565658}	2021-03-12 01:28:02.227+00
304	1	5	{"lat":15.1626707,"lng":120.5565658}	2021-03-12 01:28:07.227+00
305	1	5	{"lat":15.1626707,"lng":120.5565658}	2021-03-12 01:28:12.233+00
306	1	5	{"lat":15.1626707,"lng":120.5565658}	2021-03-12 01:28:17.241+00
307	1	5	{"lat":15.1626707,"lng":120.5565658}	2021-03-12 01:28:22.208+00
308	1	5	{"lat":15.1626707,"lng":120.5565658}	2021-03-12 01:28:27.218+00
309	1	5	{"lat":15.1626707,"lng":120.5565658}	2021-03-12 01:28:32.221+00
310	1	5	{"lat":15.1626707,"lng":120.5565658}	2021-03-12 01:28:37.227+00
311	1	5	{"lat":15.1626707,"lng":120.5565658}	2021-03-12 01:28:42.225+00
312	1	5	{"lat":15.1626707,"lng":120.5565658}	2021-03-12 01:28:47.227+00
313	1	5	{"lat":15.1626707,"lng":120.5565658}	2021-03-12 01:28:52.261+00
314	1	5	{"lat":15.1626466,"lng":120.556565}	2021-03-12 01:28:57.22+00
315	1	5	{"lat":15.1626466,"lng":120.556565}	2021-03-12 01:29:02.223+00
316	1	5	{"lat":15.1626466,"lng":120.556565}	2021-03-12 01:29:07.226+00
317	1	5	{"lat":15.1626466,"lng":120.556565}	2021-03-12 01:29:12.226+00
318	1	5	{"lat":15.1626466,"lng":120.556565}	2021-03-12 01:29:17.227+00
319	1	5	{"lat":15.1626466,"lng":120.556565}	2021-03-12 01:29:22.219+00
320	1	5	{"lat":15.1626466,"lng":120.556565}	2021-03-12 01:29:27.222+00
321	1	5	{"lat":15.1626466,"lng":120.556565}	2021-03-12 01:29:32.229+00
322	1	5	{"lat":15.1626466,"lng":120.556565}	2021-03-12 01:29:37.227+00
323	1	5	{"lat":15.1626466,"lng":120.556565}	2021-03-12 01:29:42.231+00
324	1	5	{"lat":15.1626466,"lng":120.556565}	2021-03-12 01:29:45.49+00
325	1	\N	{"lat":"15.1626466","lng":"120.556565"}	2021-03-12 01:29:49.287+00
326	1	\N	{"lat":"15.162652","lng":"120.5565654"}	2021-03-12 01:30:24.905+00
327	1	\N	{"lat":"15.1626453","lng":"120.5565656"}	2021-03-12 01:31:46.361+00
328	1	\N	{"lat":"15.1626453","lng":"120.5565656"}	2021-03-12 01:32:20.228+00
329	1	\N	{"lat":"15.1626328","lng":"120.5565623"}	2021-03-12 01:32:47.426+00
330	1	\N	{"lat":"15.1626328","lng":"120.5565623"}	2021-03-12 01:33:16.679+00
331	1	\N	{"lat":"15.1626328","lng":"120.5565623"}	2021-03-12 01:33:49.149+00
332	1	\N	{"lat":"15.1626328","lng":"120.5565623"}	2021-03-12 01:34:26.366+00
333	1	\N	{"lat":"15.1626328","lng":"120.5565623"}	2021-03-12 01:35:46.416+00
334	1	\N	{"lat":"15.1626328","lng":"120.5565623"}	2021-03-12 01:36:16.907+00
335	1	\N	{"lat":"15.1626328","lng":"120.5565623"}	2021-03-12 01:36:48.33+00
336	1	\N	{"lat":"15.1626328","lng":"120.5565623"}	2021-03-12 01:37:16.737+00
337	1	\N	{"lat":"15.1626328","lng":"120.5565623"}	2021-03-12 01:37:46.924+00
338	1	\N	{"lat":"15.1626328","lng":"120.5565623"}	2021-03-12 01:38:48.132+00
339	1	\N	{"lat":"15.1626328","lng":"120.5565623"}	2021-03-12 01:39:17.448+00
340	1	\N	{"lat":"15.1626328","lng":"120.5565623"}	2021-03-12 01:39:46.361+00
341	1	\N	{"lat":"15.1626328","lng":"120.5565623"}	2021-03-12 01:40:26.139+00
342	1	\N	{"lat":"15.1626328","lng":"120.5565623"}	2021-03-12 01:40:51.183+00
343	1	\N	{"lat":"15.1626328","lng":"120.5565623"}	2021-03-12 01:41:23.135+00
344	1	\N	{"lat":"15.1626526","lng":"120.5565648"}	2021-03-12 01:41:46.82+00
345	1	\N	{"lat":"15.1626723","lng":"120.5565637"}	2021-03-12 01:42:47.344+00
346	1	\N	{"lat":"15.1625036","lng":"120.5565624"}	2021-03-12 01:43:16.582+00
347	1	6	{"lat":15.1626551,"lng":120.556566}	2021-03-12 01:30:51.596+00
348	1	6	{"lat":15.1626551,"lng":120.556566}	2021-03-12 01:30:56.653+00
349	1	6	{"lat":15.1626444,"lng":120.5565668}	2021-03-12 01:31:01.876+00
350	1	6	{"lat":15.162637,"lng":120.5565684}	2021-03-12 01:31:07.299+00
351	1	6	{"lat":15.1626375,"lng":120.5565689}	2021-03-12 01:31:11.665+00
352	1	6	{"lat":15.1626375,"lng":120.5565689}	2021-03-12 01:31:16.593+00
353	1	6	{"lat":15.162637,"lng":120.5565693}	2021-03-12 01:31:22.024+00
354	1	6	{"lat":15.1626409,"lng":120.5565677}	2021-03-12 01:31:26.621+00
355	1	6	{"lat":15.1626453,"lng":120.5565656}	2021-03-12 01:31:31.619+00
356	1	6	{"lat":15.1626453,"lng":120.5565656}	2021-03-12 01:31:36.593+00
357	1	6	{"lat":15.1626453,"lng":120.5565656}	2021-03-12 01:31:41.587+00
358	1	6	{"lat":15.1626453,"lng":120.5565656}	2021-03-12 01:31:46.589+00
359	1	6	{"lat":15.1626453,"lng":120.5565656}	2021-03-12 01:31:51.588+00
360	1	6	{"lat":15.1626453,"lng":120.5565656}	2021-03-12 01:31:56.589+00
361	1	6	{"lat":15.1626453,"lng":120.5565656}	2021-03-12 01:32:01.606+00
362	1	6	{"lat":15.1626453,"lng":120.5565656}	2021-03-12 01:32:06.606+00
363	1	6	{"lat":15.1626453,"lng":120.5565656}	2021-03-12 01:32:11.611+00
364	1	6	{"lat":15.1626453,"lng":120.5565656}	2021-03-12 01:32:16.594+00
365	1	6	{"lat":15.1626453,"lng":120.5565656}	2021-03-12 01:32:21.606+00
366	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:32:26.588+00
367	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:32:31.6+00
368	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:32:36.597+00
369	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:32:41.59+00
370	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:32:46.589+00
371	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:32:51.587+00
372	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:32:56.593+00
373	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:33:01.621+00
374	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:33:06.6+00
375	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:33:11.604+00
376	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:33:16.599+00
377	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:33:21.589+00
378	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:33:26.592+00
379	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:33:31.619+00
380	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:33:36.595+00
381	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:33:41.6+00
382	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:33:46.592+00
383	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:33:51.583+00
384	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:33:56.591+00
385	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:34:01.597+00
386	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:34:06.603+00
387	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:34:11.599+00
388	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:34:16.599+00
389	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:34:21.588+00
390	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:34:26.582+00
391	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:34:31.601+00
392	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:34:36.587+00
393	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:34:41.587+00
394	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:34:46.596+00
395	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:34:51.589+00
396	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:34:56.585+00
397	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:35:01.594+00
398	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:35:06.587+00
399	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:35:11.588+00
400	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:35:16.598+00
401	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:35:21.586+00
402	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:35:26.592+00
403	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:35:31.595+00
404	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:35:36.611+00
405	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:35:41.605+00
406	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:35:46.593+00
407	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:35:51.581+00
408	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:35:56.588+00
409	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:36:01.604+00
410	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:36:06.591+00
411	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:36:11.589+00
412	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:36:16.599+00
413	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:36:21.582+00
414	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:36:26.586+00
415	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:36:31.609+00
416	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:36:36.589+00
417	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:36:41.591+00
418	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:36:46.591+00
419	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:36:51.583+00
420	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:36:56.585+00
421	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:37:01.587+00
422	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:37:06.595+00
423	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:37:11.586+00
424	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:37:16.596+00
425	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:37:21.586+00
426	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:37:26.586+00
427	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:37:31.603+00
428	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:37:36.594+00
429	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:37:41.598+00
430	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:37:46.594+00
431	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:37:51.584+00
432	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:37:56.583+00
433	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:38:01.594+00
434	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:38:06.59+00
435	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:38:11.591+00
436	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:38:16.598+00
437	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:38:21.582+00
438	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:38:26.591+00
439	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:38:31.587+00
440	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:38:36.589+00
441	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:38:41.592+00
442	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:38:46.596+00
443	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:38:51.584+00
444	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:38:56.579+00
445	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:39:01.589+00
446	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:39:06.582+00
447	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:39:11.591+00
448	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:39:16.588+00
449	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:39:21.58+00
450	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:39:26.577+00
451	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:39:31.601+00
452	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:39:36.586+00
453	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:39:41.589+00
454	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:39:46.603+00
455	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:39:51.586+00
456	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:39:56.582+00
457	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:40:01.593+00
458	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:40:06.592+00
459	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:40:11.584+00
460	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:40:16.593+00
461	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:40:21.579+00
462	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:40:26.588+00
463	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:40:31.583+00
464	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:40:36.603+00
465	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:40:41.587+00
466	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:40:46.595+00
467	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:40:51.594+00
468	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:40:56.588+00
469	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:41:01.608+00
470	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:41:06.591+00
471	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:41:11.59+00
472	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:41:16.587+00
473	1	6	{"lat":15.1626328,"lng":120.5565623}	2021-03-12 01:41:21.58+00
474	1	6	{"lat":15.1626526,"lng":120.5565648}	2021-03-12 01:41:26.59+00
475	1	6	{"lat":15.1626526,"lng":120.5565648}	2021-03-12 01:41:31.586+00
476	1	6	{"lat":15.1626526,"lng":120.5565648}	2021-03-12 01:41:36.604+00
477	1	6	{"lat":15.1626526,"lng":120.5565648}	2021-03-12 01:41:41.588+00
478	1	6	{"lat":15.1626526,"lng":120.5565648}	2021-03-12 01:41:46.593+00
479	1	6	{"lat":15.1626526,"lng":120.5565648}	2021-03-12 01:41:51.601+00
480	1	6	{"lat":15.1626723,"lng":120.5565637}	2021-03-12 01:41:56.583+00
481	1	6	{"lat":15.1626723,"lng":120.5565637}	2021-03-12 01:42:01.594+00
482	1	6	{"lat":15.1626723,"lng":120.5565637}	2021-03-12 01:42:06.597+00
483	1	6	{"lat":15.1626723,"lng":120.5565637}	2021-03-12 01:42:11.585+00
484	1	6	{"lat":15.1626723,"lng":120.5565637}	2021-03-12 01:42:16.588+00
485	1	6	{"lat":15.1626723,"lng":120.5565637}	2021-03-12 01:42:21.585+00
486	1	6	{"lat":15.1626723,"lng":120.5565637}	2021-03-12 01:42:26.586+00
487	1	6	{"lat":15.1626723,"lng":120.5565637}	2021-03-12 01:42:31.596+00
488	1	6	{"lat":15.1626723,"lng":120.5565637}	2021-03-12 01:42:36.598+00
489	1	6	{"lat":15.1626723,"lng":120.5565637}	2021-03-12 01:42:41.599+00
490	1	6	{"lat":15.1626723,"lng":120.5565637}	2021-03-12 01:42:46.599+00
491	1	6	{"lat":15.1626723,"lng":120.5565637}	2021-03-12 01:42:51.591+00
492	1	6	{"lat":15.1625036,"lng":120.5565624}	2021-03-12 01:42:56.594+00
493	1	6	{"lat":15.1625036,"lng":120.5565624}	2021-03-12 01:43:01.601+00
494	1	6	{"lat":15.1625036,"lng":120.5565624}	2021-03-12 01:43:06.594+00
495	1	6	{"lat":15.1625036,"lng":120.5565624}	2021-03-12 01:43:11.603+00
496	1	6	{"lat":15.1625036,"lng":120.5565624}	2021-03-12 01:43:16.597+00
497	1	6	{"lat":15.1625036,"lng":120.5565624}	2021-03-12 01:43:21.589+00
498	1	6	{"lat":15.1625036,"lng":120.5565624}	2021-03-12 01:43:26.591+00
499	1	6	{"lat":15.1625036,"lng":120.5565624}	2021-03-12 01:43:31.594+00
500	1	6	{"lat":15.1625036,"lng":120.5565624}	2021-03-12 01:43:36.608+00
501	1	6	{"lat":15.1625036,"lng":120.5565624}	2021-03-12 01:43:41.599+00
502	1	6	{"lat":15.1625036,"lng":120.5565624}	2021-03-12 01:43:45.808+00
503	1	\N	{"lat":"15.1625036","lng":"120.5565624"}	2021-03-12 01:43:42.54+00
504	1	\N	{"lat":"15.1625036","lng":"120.5565624"}	2021-03-12 01:44:13.455+00
505	1	\N	{"lat":"15.1625036","lng":"120.5565624"}	2021-03-12 01:44:52.668+00
506	1	\N	{"lat":"15.1625036","lng":"120.5565624"}	2021-03-12 01:45:13.29+00
507	1	\N	{"lat":"15.1625036","lng":"120.5565624"}	2021-03-12 01:45:49.956+00
508	1	\N	{"lat":"15.1625036","lng":"120.5565624"}	2021-03-12 01:46:53.682+00
509	1	\N	{"lat":"15.1625036","lng":"120.5565624"}	2021-03-12 01:47:12.938+00
510	1	\N	{"lat":"15.1625036","lng":"120.5565624"}	2021-03-12 01:47:43.641+00
511	1	\N	{"lat":"15.1625036","lng":"120.5565624"}	2021-03-12 01:48:13.3+00
512	1	\N	{"lat":"15.1625036","lng":"120.5565624"}	2021-03-12 01:49:20.323+00
513	1	\N	{"lat":"15.1625036","lng":"120.5565624"}	2021-03-12 01:49:50+00
514	1	\N	{"lat":"15.1625036","lng":"120.5565624"}	2021-03-12 01:51:59.804+00
515	1	\N	{"lat":"15.1625036","lng":"120.5565624"}	2021-03-12 01:52:19.842+00
516	1	\N	{"lat":"15.1625036","lng":"120.5565624"}	2021-03-12 01:52:44.546+00
517	1	\N	{"lat":"15.1625036","lng":"120.5565624"}	2021-03-12 01:53:19.764+00
518	1	\N	{"lat":"15.1625036","lng":"120.5565624"}	2021-03-12 01:53:46.073+00
519	1	\N	{"lat":"15.1625036","lng":"120.5565624"}	2021-03-12 01:54:19.785+00
520	1	\N	{"lat":"15.1625036","lng":"120.5565624"}	2021-03-12 01:54:49.765+00
521	1	\N	{"lat":"15.1625036","lng":"120.5565624"}	2021-03-12 01:55:16.741+00
522	1	\N	{"lat":"15.1625036","lng":"120.5565624"}	2021-03-12 01:55:45.747+00
523	1	\N	{"lat":"15.1625036","lng":"120.5565624"}	2021-03-12 01:56:29.778+00
524	1	\N	{"lat":"15.1625036","lng":"120.5565624"}	2021-03-12 01:56:46.765+00
525	1	\N	{"lat":"15.1625036","lng":"120.5565624"}	2021-03-12 01:57:13.909+00
526	1	7	{"lat":15.1625036,"lng":120.5565624}	2021-03-12 01:57:27.985+00
527	1	7	{"lat":15.1625036,"lng":120.5565624}	2021-03-12 01:57:32.975+00
528	1	7	{"lat":15.1625036,"lng":120.5565624}	2021-03-12 01:57:37.993+00
529	1	7	{"lat":15.1625036,"lng":120.5565624}	2021-03-12 01:57:42.98+00
530	1	7	{"lat":15.1625036,"lng":120.5565624}	2021-03-12 01:57:47.982+00
531	1	7	{"lat":15.1625036,"lng":120.5565624}	2021-03-12 01:57:52.98+00
532	1	7	{"lat":15.1625036,"lng":120.5565624}	2021-03-12 01:57:57.965+00
533	1	7	{"lat":15.1625036,"lng":120.5565624}	2021-03-12 01:58:02.966+00
534	1	7	{"lat":15.1625036,"lng":120.5565624}	2021-03-12 01:58:04.627+00
535	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 01:58:50.632+00
536	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 01:59:22.571+00
537	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 01:59:50.328+00
538	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:00:15.619+00
539	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:00:45.93+00
540	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:01:44.575+00
541	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:02:16.631+00
542	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:02:52.607+00
543	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:03:13.779+00
544	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:03:43.103+00
545	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:04:14.209+00
546	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:04:46.902+00
547	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:05:18.73+00
548	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:05:50.195+00
549	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:06:13.7+00
550	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:06:43.534+00
551	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:07:13.587+00
552	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:07:49.55+00
553	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:08:17.036+00
554	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:08:46.694+00
555	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:09:15.68+00
556	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:09:43.137+00
557	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:10:13.693+00
558	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:10:50.551+00
559	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:11:18.893+00
560	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:11:43.536+00
561	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:12:15.537+00
562	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:12:43.547+00
563	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:13:19.667+00
564	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:13:43.564+00
565	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:14:19.62+00
566	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:14:43.534+00
567	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:15:22.544+00
568	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:15:59.544+00
569	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:16:19.655+00
570	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:17:29.564+00
571	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:17:45.66+00
572	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:18:29.583+00
573	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:19:16.575+00
574	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:19:53.546+00
575	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:20:22.561+00
576	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:20:43.406+00
577	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:21:29.54+00
578	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:22:13.52+00
579	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:22:45.567+00
580	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:23:15.564+00
581	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:23:43.531+00
582	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:24:19.544+00
583	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:24:53.508+00
584	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:25:25.558+00
585	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:25:44.732+00
586	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:26:22.629+00
587	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:26:49.571+00
588	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:27:16.693+00
589	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:27:49.548+00
590	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:28:25.885+00
591	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:29:14.919+00
592	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:29:54.006+00
593	2	4	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:28:44.933+00
594	2	4	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:28:49.93+00
595	2	4	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:28:54.928+00
596	2	4	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:28:59.932+00
597	2	4	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:29:04.928+00
598	2	4	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:29:09.93+00
599	2	4	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:29:14.927+00
600	2	4	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:29:19.927+00
601	2	4	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:29:24.928+00
602	2	4	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:29:29.929+00
603	2	4	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:29:34.928+00
604	2	4	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:29:39.928+00
605	2	4	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:29:44.927+00
606	2	4	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:29:49.923+00
607	2	4	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:29:54.931+00
608	2	4	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:29:59.921+00
609	2	4	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:30:04.926+00
610	2	4	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:30:09.925+00
611	2	4	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:30:14.926+00
612	2	4	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:30:19.923+00
613	2	4	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:30:24.929+00
614	2	4	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:30:29.927+00
615	2	4	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:30:31.203+00
616	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 02:30:37.876+00
617	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 02:30:41.402+00
618	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:30:42.1+00
619	2	8	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:30:59.692+00
620	2	8	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:31:04.688+00
621	2	8	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:31:09.689+00
622	2	8	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:31:14.691+00
623	2	8	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:31:20.686+00
624	2	8	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:31:25.685+00
625	2	8	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:31:30.691+00
626	2	8	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:31:35.684+00
627	2	8	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:31:40.688+00
628	2	8	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:31:45.683+00
629	2	8	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:31:50.686+00
630	2	8	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:31:55.683+00
631	2	8	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:32:00.686+00
632	2	8	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:32:05.686+00
633	2	8	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:32:10.686+00
634	2	8	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:32:15.686+00
635	2	8	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:32:17.598+00
636	2	8	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:32:20.684+00
637	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 02:32:30.641+00
638	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:33:24.39+00
639	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:33:30.576+00
640	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:33:36.022+00
641	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:34:06.808+00
642	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:34:40.666+00
643	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:34:41.964+00
644	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:35:22.285+00
645	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:35:43.84+00
646	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:37:14.265+00
647	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:37:42.832+00
648	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:38:13.142+00
649	1	\N	{"lat":"15.1626726","lng":"120.5565614"}	2021-03-12 02:38:49.78+00
650	2	9	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:36:47.504+00
651	2	9	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:36:52.494+00
652	2	9	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:36:57.5+00
653	2	9	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:37:02.5+00
654	2	9	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:37:07.499+00
655	2	9	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:37:13.032+00
656	2	9	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:37:18.035+00
657	2	9	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:37:24.184+00
658	2	9	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:37:33.344+00
659	2	9	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:37:40.297+00
660	2	9	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:37:45.299+00
661	2	9	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:37:50.303+00
662	2	9	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:37:55.3+00
663	2	9	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:38:00.299+00
664	2	9	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:38:05.297+00
665	2	9	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:38:10.303+00
666	2	9	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:38:15.299+00
667	2	9	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:38:20.301+00
668	2	9	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:38:25.301+00
669	2	9	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:38:30.298+00
670	2	9	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:38:35.297+00
671	2	9	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:38:36.372+00
672	2	9	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:38:40.294+00
673	2	9	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:38:45.302+00
674	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 02:38:54.746+00
675	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 02:39:33.953+00
676	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 02:39:54.995+00
677	1	10	{"lat":15.1626726,"lng":120.5565614}	2021-03-12 02:39:57.806+00
678	1	10	{"lat":15.1626726,"lng":120.5565614}	2021-03-12 02:40:02.834+00
679	1	10	{"lat":15.1626726,"lng":120.5565614}	2021-03-12 02:40:08.746+00
680	1	10	{"lat":15.1626726,"lng":120.5565614}	2021-03-12 02:40:13.643+00
681	1	10	{"lat":15.1626726,"lng":120.5565614}	2021-03-12 02:40:16.013+00
682	1	\N	{"lat":"15.1626283","lng":"120.5565648"}	2021-03-12 02:40:15.638+00
683	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 02:40:28.864+00
684	1	\N	{"lat":"15.1626283","lng":"120.5565648"}	2021-03-12 02:40:32.429+00
685	1	\N	{"lat":"15.1626283","lng":"120.5565648"}	2021-03-12 02:40:36.418+00
686	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 02:41:04.827+00
687	1	\N	{"lat":"15.1626283","lng":"120.5565648"}	2021-03-12 02:41:13.593+00
688	1	\N	{"lat":"15.1626283","lng":"120.5565648"}	2021-03-12 02:41:16.853+00
689	1	\N	{"lat":"15.1626283","lng":"120.5565648"}	2021-03-12 02:41:26.669+00
690	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 02:41:31.034+00
691	1	\N	{"lat":"15.1626283","lng":"120.5565648"}	2021-03-12 02:41:55.039+00
692	2	11	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:41:55.786+00
693	2	11	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:42:00.794+00
694	2	11	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:42:05.798+00
695	2	11	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:42:10.801+00
696	2	11	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:42:15.8+00
697	2	11	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:42:20.801+00
698	2	11	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:42:25.802+00
699	2	11	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:42:30.805+00
700	2	11	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:42:35.803+00
701	2	11	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:42:40.804+00
702	2	11	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:42:45.805+00
703	2	11	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:42:50.802+00
704	2	11	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:42:55.798+00
705	2	11	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:42:59.6+00
706	2	11	{"lat":15.162884,"lng":120.55664}	2021-03-12 02:43:00.801+00
707	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 02:43:04.357+00
708	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 02:45:44.921+00
709	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 02:46:15.169+00
710	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 02:46:49.066+00
711	1	\N	{"lat":"15.1626628","lng":"120.5565694"}	2021-03-12 02:47:08.859+00
712	1	\N	{"lat":"15.1626628","lng":"120.5565694"}	2021-03-12 02:47:09.281+00
713	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 02:47:15.336+00
714	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 02:47:55.023+00
715	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 02:48:15.173+00
716	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 02:48:52.327+00
717	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 02:49:15.312+00
718	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 02:49:55.198+00
719	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 02:50:22.354+00
720	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 02:50:25.028+00
721	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 02:50:54.614+00
722	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 02:51:22.619+00
723	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 02:51:55.633+00
724	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 02:52:22.732+00
725	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 02:52:55.835+00
726	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 02:53:22.609+00
727	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:47:19.46+00
728	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:47:24.476+00
729	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:47:29.471+00
730	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:47:34.46+00
731	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:47:39.462+00
732	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:47:44.459+00
733	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:47:49.466+00
734	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:47:54.596+00
735	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:47:59.462+00
736	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:48:04.479+00
737	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:48:09.484+00
738	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:48:14.467+00
739	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:48:19.474+00
740	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:48:24.466+00
741	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:48:29.461+00
742	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:48:34.464+00
743	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:48:39.466+00
744	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:48:44.466+00
745	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:48:49.467+00
746	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:48:54.472+00
747	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:48:59.466+00
748	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:49:04.465+00
749	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:49:09.469+00
750	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:49:14.478+00
751	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:49:19.472+00
752	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:49:24.465+00
753	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:49:29.466+00
754	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:49:34.466+00
755	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:49:39.469+00
756	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:49:44.475+00
757	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:49:49.466+00
758	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:49:54.468+00
759	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:49:59.472+00
760	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:50:04.466+00
761	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:50:09.467+00
762	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:50:14.475+00
763	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:50:19.48+00
764	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:50:24.491+00
765	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:50:29.466+00
766	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:50:34.479+00
767	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:50:39.466+00
768	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:50:44.473+00
769	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:50:49.469+00
770	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:50:54.465+00
771	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:50:59.467+00
772	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:51:04.463+00
773	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:51:09.472+00
774	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:51:14.47+00
775	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:51:19.464+00
776	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:51:24.467+00
777	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:51:29.468+00
778	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:51:34.467+00
779	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:51:39.472+00
780	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:51:44.466+00
781	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:51:49.465+00
782	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:51:54.47+00
783	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:51:59.472+00
784	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:52:04.467+00
785	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:52:09.465+00
786	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:52:14.468+00
787	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:52:19.454+00
788	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:52:24.472+00
789	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:52:29.47+00
790	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:52:34.465+00
791	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:52:39.467+00
792	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:52:44.476+00
793	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:52:49.47+00
794	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:52:54.464+00
795	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:52:59.466+00
796	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:53:04.47+00
797	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:53:09.469+00
798	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:53:14.506+00
799	1	12	{"lat":15.1626628,"lng":120.5565694}	2021-03-12 02:53:14.854+00
800	1	12	{"lat":15.162677,"lng":120.5565642}	2021-03-12 02:53:19.481+00
801	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 02:54:02.479+00
802	1	\N	{"lat":"15.162677","lng":"120.5565642"}	2021-03-12 02:54:04.663+00
803	2	\N	{"lat":"15.162884","lng":"120.55664"}	2021-03-12 02:54:26.494+00
804	1	\N	{"lat":"15.162677","lng":"120.5565642"}	2021-03-12 02:54:40.679+00
805	1	\N	{"lat":"15.162677","lng":"120.5565642"}	2021-03-12 02:55:04.375+00
806	1	\N	{"lat":"15.162677","lng":"120.5565642"}	2021-03-12 02:55:41.358+00
807	1	\N	{"lat":"15.162677","lng":"120.5565642"}	2021-03-12 02:56:21.708+00
808	1	\N	{"lat":"15.162677","lng":"120.5565642"}	2021-03-12 02:57:04.147+00
\.


                                                                                                                              3264.dat                                                                                            0000600 0004000 0002000 00000004215 14022554213 0014250 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        3	18	http://18.166.234.218:8000/public/rider/default-rider.png	1	15.15953928116513800000	120.58231350755459000000	{"brand":"Yamaha","model":"NMax","plate_number":"8647 CA","color":"Red"}	2021-03-12 00:09:02.638+00
4	19	http://18.166.234.218:8000/public/rider/default-rider.png	1	15.15953928116513800000	120.58231350755459000000	{"brand":"Yamaha","model":"Sniper 150","plate_number":"9728 GH","color":"Yellow"}	2021-03-12 00:09:02.666+00
5	20	http://18.166.234.218:8000/public/rider/default-rider.png	1	15.15953928116513800000	120.58231350755459000000	{"brand":"Suzuki","model":"Smash 150","plate_number":"6640 KD","color":"Black"}	2021-03-12 00:09:02.693+00
6	21	http://18.166.234.218:8000/public/rider/default-rider.png	1	15.16314296015477000000	120.55553433274990000000	{"brand":"Honda","model":"TMX 155","plate_number":"1309 LN","color":"Black"}	2021-03-12 00:09:02.721+00
7	22	http://18.166.234.218:8000/public/rider/default-rider.png	1	15.16314296015477000000	120.55553433274990000000	{"brand":"Honda","model":"TMX 155","plate_number":"1309 LN","color":"Black"}	2021-03-12 00:09:02.749+00
8	23	http://18.166.234.218:8000/public/rider/default-rider.png	1	15.16314296015477000000	120.55553433274990000000	{"brand":"Honda","model":"TMX 155","plate_number":"1309 LN","color":"Black"}	2021-03-12 00:09:02.779+00
9	24	http://18.166.234.218:8000/public/rider/default-rider.png	1	15.16314296015477000000	120.55553433274990000000	{"brand":"Honda","model":"TMX 155","plate_number":"1309 LN","color":"Black"}	2021-03-12 00:09:02.81+00
10	25	http://18.166.234.218:8000/public/rider/default-rider.png	1	15.16314296015477000000	120.55553433274990000000	{"brand":"Honda","model":"TMX 155","plate_number":"1309 LN","color":"Black"}	2021-03-12 00:09:02.839+00
2	17	http://18.166.234.218:8000/public/rider/default-rider.png	2	15.16288400000000000000	120.55664000000000000000	{"brand":"Yamaha","model":"Mio I 125","plate_number":"3547 YB","color":"BLUE"}	2021-03-12 00:09:02.61+00
1	16	http://18.166.234.218:8000/public/rider/default-rider.png	1	15.16267700000000000000	120.55656420000000000000	{"brand":"Honda","model":"TMX 155","plate_number":"1309 LN","color":"Black"}	2021-03-12 00:09:02.58+00
\.


                                                                                                                                                                                                                                                                                                                                                                                   3274.dat                                                                                            0000600 0004000 0002000 00000000005 14022554213 0014242 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           3256.dat                                                                                            0000600 0004000 0002000 00000017737 14022554213 0014266 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	1	Sundaeguk 	Sundaeguk - is a soup	http://18.166.234.218:8000/public/store/restaurants/1-1.jpg	300	300.00	279.00	[1,2]	[1,2,3,4,5]	0	0	soup	available	2021-03-12 00:09:01.66+00	2021-03-12 00:09:01.66+00
2	1	Ppyeo Haejang-guk 	Ppyeo Haejang-guk - is a soup	http://18.166.234.218:8000/public/store/restaurants/1-2.jpg	400	400.00	372.00	[3,4]	[1,2]	0	0	soup	available	2021-03-12 00:09:01.665+00	2021-03-12 00:09:01.665+00
3	1	Osorigukbap	Osorigukbap - is a soup	http://18.166.234.218:8000/public/restaurants/1-3.jpg	350	350.00	325.50	[]	[]	0	0	soup	available	2021-03-12 00:09:01.669+00	2021-03-12 00:09:01.669+00
4	2	Ddung Macaron	Ddung Macaron - is a Coffee	http://18.166.234.218:8000/public/store/restaurants/2-1.jpg	129	138.03	129.00	[5]	[6]	0	0	coffee	available	2021-03-12 00:09:01.722+00	2021-03-12 00:09:01.722+00
5	2	Dan Pat Bbang	Dan Pat Bbang - is a coffee	http://18.166.234.218:8000/public/store/restaurants/2-3.jpg	60	60.00	55.80	[]	[6]	0	0	coffee	available	2021-03-12 00:09:01.726+00	2021-03-12 00:09:01.726+00
6	2	Dalgona Latte	Dalgona Latte - is a Coffee	http://18.166.234.218:8000/public/store/restaurants/2-2.jpg	180	192.60	180.00	[5]	[]	0	0	coffee	available	2021-03-12 00:09:01.73+00	2021-03-12 00:09:01.73+00
7	3	Americano	Americano - is a Coffee	http://18.166.234.218:8000/public/store/restaurants/3-1.png	130	130.00	120.90	[6]	[7]	0	0	coffee	available	2021-03-12 00:09:01.78+00	2021-03-12 00:09:01.78+00
8	3	Caramel Macchiatto	Caramel Macchiatto - is a Coffee	http://18.166.234.218:8000/public/store/restaurants/3-2.jpg	180	180.00	167.40	[6]	[]	0	0	coffee	available	2021-03-12 00:09:01.783+00	2021-03-12 00:09:01.783+00
9	3	Coldbrew	Coldbrew - is a coffee	http://18.166.234.218:8000/public/store/restaurants/3-3.jpg	60	60.00	55.80	[]	[7]	0	0	coffee	available	2021-03-12 00:09:01.786+00	2021-03-12 00:09:01.786+00
10	4	Combination Pizza	Combination Pizza - is a Pizza	http://18.166.234.218:8000/public/store/restaurants/4-1.png	399	399.00	371.07	[7]	[8]	0	0	pizza	available	2021-03-12 00:09:01.841+00	2021-03-12 00:09:01.841+00
11	4	Bulgogi Pizza	Bulgogi Pizza - is a Pizza	http://18.166.234.218:8000/public/store/restaurants/4-2.png	499	499.00	464.07	[7]	[]	0	0	pizza	available	2021-03-12 00:09:01.844+00	2021-03-12 00:09:01.844+00
12	4	Cheese Tteokbokki	Cheese Tteokbokki - is a coffee	http://18.166.234.218:8000/public/store/restaurants/4-3.jpg	249	249.00	231.57	[]	[]	0	0	rice cake	available	2021-03-12 00:09:01.848+00	2021-03-12 00:09:01.848+00
13	5	Ori Suyuk	Ori Suyuk - is a Combo Meal	http://18.166.234.218:8000/public/store/restaurants/5-1.jpg	1750	1750.00	1627.50	[]	[]	0	0	combo meal	available	2021-03-12 00:09:01.88+00	2021-03-12 00:09:01.88+00
14	5	Origangjeong	Origangjeong - is a Chicken	http://18.166.234.218:8000/public/store/restaurants/5-2.jpg	280	280.00	260.40	[]	[]	0	0	chicken	available	2021-03-12 00:09:01.883+00	2021-03-12 00:09:01.883+00
15	5	Oritang	Oritang  - is a soup	http://18.166.234.218:8000/public/store/restaurants/5-3.jpg	249	249.00	231.57	[]	[]	0	0	soup	available	2021-03-12 00:09:01.886+00	2021-03-12 00:09:01.886+00
16	6	Shabu Shabu Mix	per kilo	http://18.166.234.218:8000/public/store/restaurants/6-1.png	510	527.84	492.15	[]	[]	0	0	frozen meal	available	2021-03-12 00:09:01.918+00	2021-03-12 00:09:01.918+00
17	6	Mango Powder	250 Grams	http://18.166.234.218:8000/public/store/restaurants/6-2.png	250	258.75	241.25	[]	[]	0	0	Spice	available	2021-03-12 00:09:01.922+00	2021-03-12 00:09:01.922+00
18	6	Durian	per kilo	http://18.166.234.218:8000/public/store/restaurants/6-3.png	260	269.09	250.90	[]	[]	0	0	Fruit	available	2021-03-12 00:09:01.925+00	2021-03-12 00:09:01.925+00
19	6	Samanco		http://18.166.234.218:8000/public/store/restaurants/6-4.png	30	31.04	28.95	[]	[]	0	0	Ice Cream	available	2021-03-12 00:09:01.928+00	2021-03-12 00:09:01.928+00
20	7	Corona 6 pack		http://18.166.234.218:8000/public/store/restaurants/7-1.jpg	240	240.00	223.20	[]	[]	0	0	Beer	available	2021-03-12 00:09:01.965+00	2021-03-12 00:09:01.965+00
21	7	San Miguel Apple Flavored Beer in Can 330ml		http://18.166.234.218:8000/public/store/restaurants/7-2.jpg	56	56.00	52.08	[]	[]	0	0	Beer	available	2021-03-12 00:09:01.968+00	2021-03-12 00:09:01.968+00
22	7	Tanduay Ice in Bottle 330ml		http://18.166.234.218:8000/public/store/restaurants/7-3.jpg	43	43.00	39.99	[]	[]	0	0	Beer	available	2021-03-12 00:09:01.971+00	2021-03-12 00:09:01.971+00
23	7	Heineken 6 pack		http://18.166.234.218:8000/public/store/restaurants/7-4.jpg	799	799.00	743.07	[]	[]	0	0	Beer	available	2021-03-12 00:09:01.974+00	2021-03-12 00:09:01.974+00
24	7	San Miguel Pale Pilsen in Can 330ml		http://18.166.234.218:8000/public/store/restaurants/7-5.jpg	49	49.00	45.57	[]	[]	0	0	Beer	available	2021-03-12 00:09:01.978+00	2021-03-12 00:09:01.978+00
25	7	Red Horse in Can 330ml		http://18.166.234.218:8000/public/store/restaurants/7-6.jpg	50	50.00	46.50	[]	[]	0	0	Beer	available	2021-03-12 00:09:01.981+00	2021-03-12 00:09:01.981+00
26	8	Galbitang	Galbitang - is a soup	http://18.166.234.218:8000/public/store/restaurants/8-1.jpg	480	480.00	446.40	[9,10]	[9,10,11,12,13]	0	0	soup	available	2021-03-12 00:09:02.064+00	2021-03-12 00:09:02.064+00
27	8	Kimchijjigae	Kimchijjigae - is a soup	http://18.166.234.218:8000/public/store/restaurants/8-2.jpg	270	270.00	251.10	[9]	[9,10,11,13]	0	0	soup	available	2021-03-12 00:09:02.068+00	2021-03-12 00:09:02.068+00
28	8	Dwenjangjjigae	Dwenjangjjigae - is a soup	http://18.166.234.218:8000/public/store/restaurants/8-3.jpg	300	300.00	279.00	[10]	[9,10,11,13]	0	0	soup	available	2021-03-12 00:09:02.072+00	2021-03-12 00:09:02.072+00
29	9	Jjajangmyun	Manboklim - is a noodle	http://18.166.234.218:8000/public/store/restaurants/9-1.jpg	300	300.00	279.00	[11,12,13]	[14,15,16,17,18]	0	0	noodle	available	2021-03-12 00:09:02.157+00	2021-03-12 00:09:02.157+00
30	9	Jjambbong	Jjambbong - is a noodle	http://18.166.234.218:8000/public/store/restaurants/9-2.jpg	350	350.00	325.50	[12]	[14,15,16,18]	0	0	soup	available	2021-03-12 00:09:02.161+00	2021-03-12 00:09:02.161+00
31	9	Tangsuyuk	Tangsuyuk - is a noodle	http://18.166.234.218:8000/public/store/restaurants/9-3.jpg	800	800.00	744.00	[13]	[14,15,16,18]	0	0	soup	available	2021-03-12 00:09:02.165+00	2021-03-12 00:09:02.165+00
32	10	Seaujang	Seaujang - is a noodle	http://18.166.234.218:8000/public/store/restaurants/10-1.jpg	400	400.00	372.00	[15,16]	[19,20,21,22,23]	0	0	all	available	2021-03-12 00:09:02.26+00	2021-03-12 00:09:02.26+00
33	10	Bulgogi	Bulgogi - is a rice cake	http://18.166.234.218:8000/public/store/restaurants/10-2.jpg	600	600.00	558.00	[15]	[19,20,21,23]	0	0	all	available	2021-03-12 00:09:02.264+00	2021-03-12 00:09:02.264+00
34	10	Bibimbab	Bibimbab - is a rice	http://18.166.234.218:8000/public/store/restaurants/10-3.jpg	300	300.00	279.00	[16]	[19,20,21,23]	0	0	soup	available	2021-03-12 00:09:02.27+00	2021-03-12 00:09:02.27+00
35	11	Tuna sasimi	Tuna sasimi - is a sasimi	http://18.166.234.218:8000/public/store/restaurants/11-1.jpg	500	500.00	465.00	[18,19]	[24,25,26,27,28]	0	0	sasimi	available	2021-03-12 00:09:02.376+00	2021-03-12 00:09:02.376+00
36	11	Salmon Sasimi	Salmon Sasimi - is a Sasimi	http://18.166.234.218:8000/public/store/restaurants/11-2.jpg	600	600.00	558.00	[18]	[24,25,26,28]	0	0	sasimi	available	2021-03-12 00:09:02.379+00	2021-03-12 00:09:02.379+00
37	11	Octopus sasimi	Octopus sasimi - is a sasimi	http://18.166.234.218:8000/public/store/restaurants/11-3.jpg	350	350.00	325.50	[19]	[24,25,26,28]	0	0	soup	available	2021-03-12 00:09:02.382+00	2021-03-12 00:09:02.382+00
38	12	Fried Chicken	Fried Chicken - is a Fried Chicken	http://18.166.234.218:8000/public/store/restaurants/12-1.jpg	500	500.00	465.00	[21,22]	[29,30,31,32,33]	0	0	chicken	available	2021-03-12 00:09:02.477+00	2021-03-12 00:09:02.477+00
39	12	Golbeng	Golbeng - is a Golbeng	http://18.166.234.218:8000/public/store/restaurants/12-2.jpg	400	400.00	372.00	[21]	[29,30,31,33]	0	0	chicken	available	2021-03-12 00:09:02.48+00	2021-03-12 00:09:02.48+00
40	12	Canpung	Canpung - is a Canpung	http://18.166.234.218:8000/public/store/restaurants/11-3.jpg	700	700.00	651.00	[22]	[29,30,31,33]	0	0	chicken	available	2021-03-12 00:09:02.484+00	2021-03-12 00:09:02.484+00
\.


                                 3254.dat                                                                                            0000600 0004000 0002000 00000030765 14022554213 0014260 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	2	2	Bongane	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	15.17454003471960700000	120.51514603451642000000	Clark	active	open	restaurant	commission	korean	Philippines	Pampanga	Angeles	Anunas	5.00	http://18.166.234.218:8000/public/store/restaurants/default.jpg	http://18.166.234.218:8000/public/store/restaurants/1.png	t	00:00:00	00:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	2021-03-12 00:09:01.573+00	2021-03-12 00:09:01.573+00
2	3	2	Blooming Angel Cafe & Bakery	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	15.13470178008279100000	120.56731798848779000000		active	open	restaurant	markup	coffee	Philippines	Pampanga	Angeles	Anunas	5.00	http://18.166.234.218:8000/public/store/restaurants/default.jpg	http://18.166.234.218:8000/public/store/restaurants/2.jpg	t	00:00:00	00:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	2021-03-12 00:09:01.701+00	2021-03-12 00:09:01.701+00
3	4	2	M.C Cafe	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	15.16312903091036400000	120.55566835504950000000		active	open	restaurant	commission	coffee	Philippines	Pampanga	Angeles	Anunas	5.00	http://18.166.234.218:8000/public/store/restaurants/default.jpg	http://18.166.234.218:8000/public/store/restaurants/3.jpg	t	00:00:00	00:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	2020-11-10 05:11:10+00	2021-03-12 00:09:01.759+00
4	5	2	RaRa Kitchen	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	15.13642235431965600000	120.58784314425043000000		active	open	restaurant	commission	coffee	Philippines	Pampanga	Angeles	Anunas	5.00	http://18.166.234.218:8000/public/store/restaurants/default.jpg	http://18.166.234.218:8000/public/store/restaurants/4.jpg	t	00:00:00	00:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	2020-11-10 05:11:10+00	2021-03-12 00:09:01.816+00
5	6	2	Happy Duck	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	15.16227220030624400000	120.55492039889194000000		active	open	restaurant	commission		Philippines	Pampanga	Angeles	Anunas	5.00	http://18.166.234.218:8000/public/store/restaurants/default.jpg	http://18.166.234.218:8000/public/store/restaurants/5.jpg	t	00:00:00	00:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	2020-11-10 05:11:10+00	2021-03-12 00:09:01.876+00
6	7	2	One Mart	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	15.15922088131948300000	120.55665227031089000000		active	open	mart	half		Philippines	Pampanga	Angeles	Anunas	5.00	http://18.166.234.218:8000/public/store/restaurants/default.jpg	http://18.166.234.218:8000/public/store/restaurants/6.png	t	00:00:00	00:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	2020-11-10 05:11:10+00	2021-03-12 00:09:01.914+00
7	8	2	Seven Eleven	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	15.15996646443442000000	120.55659949779510000000	FriendShip	active	open	mart	commission		Philippines	Pampanga	Angeles	Anunas	5.00	http://18.166.234.218:8000/public/store/restaurants/default.jpg	http://18.166.234.218:8000/public/store/restaurants/7.jpg	t	00:00:00	00:00:00	t	00:00:00	23:59:00	t	00:00:00	23:59:00	t	00:00:00	23:59:00	t	00:00:00	23:59:00	t	00:00:00	23:59:00	t	00:00:00	23:59:00	2020-11-10 05:11:10+00	2021-03-12 00:09:01.96+00
8	9	2	Jung's Kitchen	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	15.16084667727340700000	120.55570363998413000000	Clark	active	open	restaurant	commission	korean	Philippines	Pampanga	Angeles	Anunas	5.00	http://18.166.234.218:8000/public/store/restaurants/8-logo.jpg	http://18.166.234.218:8000/public/store/restaurants/8.png	t	00:00:00	00:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	2021-03-12 00:09:02.01+00	2021-03-12 00:09:02.01+00
9	10	2	Manboklim	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	15.16084667727340700000	120.55570363998413000000	Clark	active	open	restaurant	commission	korean	Philippines	Pampanga	Angeles	Anunas	5.00	http://18.166.234.218:8000/public/store/restaurants/default.jpg	http://18.166.234.218:8000/public/store/restaurants/9.jpg	t	00:00:00	00:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	2021-03-12 00:09:02.101+00	2021-03-12 00:09:02.101+00
10	11	2	Manchoo	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	15.16084667727340700000	120.55570363998413000000	Clark	active	open	restaurant	commission	korean	Philippines	Pampanga	Angeles	Anunas	5.00	http://18.166.234.218:8000/public/store/restaurants/default.jpg	http://18.166.234.218:8000/public/store/restaurants/10.jpg	t	00:00:00	00:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	2021-03-12 00:09:02.199+00	2021-03-12 00:09:02.199+00
12	13	2	Norang Chicken	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	15.16146442451438300000	120.55532705085352000000	Clark	active	open	restaurant	commission	korean	Philippines	Pampanga	Angeles	Anunas	5.00	http://18.166.234.218:8000/public/store/restaurants/default.jpg	http://18.166.234.218:8000/public/store/restaurants/12.jpg	t	00:00:00	00:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	2021-03-12 00:09:02.41+00	2021-03-12 00:09:02.41+00
11	12	2	Tamla Sushi	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	15.16084667727340700000	120.55570363998413000000	Clark	active	open	restaurant	commission	korean	Philippines	Pampanga	Angeles	Anunas	5.00	http://18.166.234.218:8000/public/store/restaurants/default.jpg	http://18.166.234.218:8000/public/store/restaurants/11.jpg	t	00:00:00	00:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	2021-03-12 00:09:02.308+00	2021-03-12 00:09:02.308+00
13	14	2	Bongane XX	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	15.17454003471960700000	120.51514603451642000000	Clark	active	open	restaurant	commission	korean	Philippines	Pampanga	Angeles	Anunas	5.00	http://18.166.234.218:8000/public/store/restaurants/default.jpg	http://18.166.234.218:8000/public/store/restaurants/1.png	t	00:00:00	00:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	2021-03-12 00:09:02.518+00	2021-03-12 00:09:02.518+00
14	15	2	Blooming Angel Cafe & Bakery XX	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.	15.13470178008279100000	120.56731798848779000000		active	open	restaurant	markup	coffee	Philippines	Pampanga	Angeles	Anunas	5.00	http://18.166.234.218:8000/public/store/restaurants/default.jpg	http://18.166.234.218:8000/public/store/restaurants/2.jpg	t	00:00:00	00:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	t	10:00:00	18:00:00	2021-03-12 00:09:02.547+00	2021-03-12 00:09:02.547+00
\.


           3250.dat                                                                                            0000600 0004000 0002000 00000000620 14022554213 0014237 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	26	test	{"lat":15.161082910242591,"lng":120.55571302771568}	Friendship Highway Margot, Angeles City Pampanga	tesst	2021-03-12 00:26:30.362+00
2	31	Home	{"lat":15.1626758,"lng":120.5565679}	355 Yukon St , Angeles Central Luzon		2021-03-12 01:08:44.323+00
3	32	home	{"lat":15.1626116224192,"lng":120.55652808398008}	Yukon Street Margot, Angeles City Pampanga	tyyyygft	2021-03-12 01:16:55.706+00
\.


                                                                                                                3248.dat                                                                                            0000600 0004000 0002000 00000015261 14022554213 0014255 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	Admin Admin	admin@gmail.com	$2a$08$ssL3pQteb2yEsSw3H/1W1udiAhKWU5KPf5upoSBNI3ihU43EZlwAS	email	\N	\N	super-admin	09567543906	0	t	2021-03-12 00:09:01.532+00	2021-03-12 00:09:01.532+00
3	Blooming Angel Cafe & Bakery	bloming-angel-cafe@gmail.com	$2a$08$dIf5hLkHgxJ84tjUm6nPAuYm0Kwt9GsjZG78PHTknpOGdpOKoerHu	email	\N	\N	partner	09567543906	0	t	2021-03-12 00:09:01.697+00	2021-03-12 00:09:01.697+00
4	M.C Cafe	mc-cafe@gmail.com	$2a$08$ofZW5h6pCPEl.XBIpzxZUu6bTO3BWxMWhXV3zQopBlqZ56IsWtw3W	email	\N	\N	partner	09567543906	0	t	2021-03-12 00:09:01.755+00	2021-03-12 00:09:01.755+00
5	RaRa Kitchen	rara-chicken@gmail.com	$2a$08$hH8P2CBl/49bK0sLVOa4X.CKrc6tm.LIbE/CTlqt4j7bC.am5XXJy	email	\N	\N	partner	09567543906	0	t	2021-03-12 00:09:01.811+00	2021-03-12 00:09:01.811+00
6	Happy Duck	happy-duck@gmail.com	$2a$08$gfmVpYPjncJ3HJOs8hNakuEOkM4SwPSh1GLThSVLcMjparq8iPy02	email	\N	\N	partner	09567543906	0	t	2021-03-12 00:09:01.872+00	2021-03-12 00:09:01.872+00
7	One Mart	one-mart@gmail.com	$2a$08$VTGHJV6Ciu1j2.d0nXo0AeGWtPdcVoMXGvfEFyA9tyA0HTRj9aaOS	email	\N	\N	partner	09567543906	0	t	2021-03-12 00:09:01.911+00	2021-03-12 00:09:01.911+00
8	Seven Eleven	seven-eleven@gmail.com	$2a$08$MpxUmS.jLy3zadq7YS9Qd.BGSmoWsEG2cF2ArMVhEafnieKtRCBHm	email	\N	\N	partner	09567543906	0	t	2021-03-12 00:09:01.957+00	2021-03-12 00:09:01.957+00
9	Jung's Kitchen	jung@gmail.com	$2a$08$K9INsb4MHiDUmAgdS0eY.OOvK2Vews1P5RbN1P.DdT8rb5OPQBe3a	email	\N	\N	partner	09567543906	0	t	2021-03-12 00:09:02.006+00	2021-03-12 00:09:02.006+00
10	Manboklim	manboklim@gmail.com	$2a$08$C1gubfdQZR1x7V0T/HJfIuq7XTreV3S3x/j93x4goQKKUUBh.MTVS	email	\N	\N	partner	09567543906	0	t	2021-03-12 00:09:02.097+00	2021-03-12 00:09:02.097+00
11	Manchoo	manchoo@gmail.com	$2a$08$QC0aqcIf8cCnJjmaZnSd..3Nts9o4eH.BYoGbrQmigIF3xxBm5oue	email	\N	\N	partner	09567543906	0	t	2021-03-12 00:09:02.195+00	2021-03-12 00:09:02.195+00
12	Tamla Sushi	tamla-sushi@gmail.com	$2a$08$qUOqD8ng5Xs38Sf7DXT5m.QJJu7htObOtFh1aSFtq/uGhDVlEInyW	email	\N	\N	partner	09567543906	0	t	2021-03-12 00:09:02.302+00	2021-03-12 00:09:02.302+00
13	Norang Chicken	norang-chicken@gmail.com	$2a$08$msCiWJPT.Wmmpe0VbFoli.aeQEYE5jdNQHyzi05rm3yMbgxwRTFb2	email	\N	\N	partner	09567543906	0	t	2021-03-12 00:09:02.406+00	2021-03-12 00:09:02.406+00
14	Bongane XX	bongane-xx@gmail.com	$2a$08$7n7.fkJwu0.PlO9GZuMrY.GMtH4WbDLezzJvl42U5OOgx5yzQlFqq	email	\N	\N	partner	09567543906	0	t	2021-03-12 00:09:02.515+00	2021-03-12 00:09:02.515+00
15	Blooming Angel Cafe & Bakery XX	bloming-angel-cafe-xx@gmail.com	$2a$08$2Ns.l.2AQzvexLuuu9vJseL5lQU.lL58NfyXghfbJ.200bUeyNlX6	email	\N	\N	partner	09567543906	0	t	2021-03-12 00:09:02.543+00	2021-03-12 00:09:02.543+00
18	Dexter Manahan	letsbee-dexter@gmail.com	$2a$08$3WGnDv1CICDUp6lEfTBKh.OT5/PA7etdChXDyoL96UQFqMXfiZaKq	email	\N	\N	rider	09567543906	0	t	2021-03-12 00:09:02.635+00	2021-03-12 00:09:02.635+00
19	Nicolo Dizon	letsbee-nicolo@gmail.com	$2a$08$sXBnoNMQKM5t0TYeymLQoe/GHTZNPxpgN7gaajWPhaxaIro07yVmW	email	\N	\N	rider	09567543906	0	t	2021-03-12 00:09:02.663+00	2021-03-12 00:09:02.663+00
20	Joed	letsbee-joed@gmail.com	$2a$08$AnJRV.xNe6P691ZxEz9deOPPzccfbGc.zCjBitPdBvo6TmTKEgYF.	email	\N	\N	rider	09567543906	0	t	2021-03-12 00:09:02.69+00	2021-03-12 00:09:02.69+00
21	Aldrin Manalo	letsbee-aldrin@gmail.com	$2a$08$4.6Asn9V/VrRFzQnKks62.2ZArREWi7yt/ytAWxaUfGDq71Spc8ce	email	\N	\N	rider	09567543906	0	t	2021-03-12 00:09:02.718+00	2021-03-12 00:09:02.718+00
22	Mark Dimagiba	letsbee-mark@gmail.com	$2a$08$hlg8/V7UkuAWmnnB2zaWRutdbC4QhSMkLInJBaUzHsN/VK4ZkW.g.	email	\N	\N	rider	09567543906	0	t	2021-03-12 00:09:02.746+00	2021-03-12 00:09:02.746+00
23	Matthew Dolores	letsbee-matthew@gmail.com	$2a$08$eVs.JJrRyhHCTTYh4zaCVe5TefOxSafsjsELase9PaGtmByKHHDpG	email	\N	\N	rider	09567543906	0	t	2021-03-12 00:09:02.774+00	2021-03-12 00:09:02.774+00
24	Ian Santos	letsbee-ian@gmail.com	$2a$08$cfeVakswpYW/3f4GP8KAUeDBESFT9njCi718xp3uK9TCO/wdS7qtC	email	\N	\N	rider	09567543906	0	t	2021-03-12 00:09:02.806+00	2021-03-12 00:09:02.806+00
25	Dave Dawne	letsbee-dave@gmail.com	$2a$08$eM2UwIYVby0vNCAzDr7BbeWiPhSB.AGGVsL.lsrXdHxTUJsNPjsnC	email	\N	\N	rider	09567543906	0	t	2021-03-12 00:09:02.835+00	2021-03-12 00:09:02.835+00
26	Abner Lets Bee	letsbee-abner@gmail.com	$2a$08$9QLZMDoD.Lz.z58fxi1jUOpa/gLxbBfBxK3AWvMnKuILRMxV22u02	email	\N	\N	customer	09567543906	0	t	2021-03-12 00:09:02.863+00	2021-03-12 00:09:02.863+00
27	Chai Lets Bee	letsbee-chai@gmail.com	$2a$08$qbxy2Yg.EkstxLst7qQ6BuoWBFNmEyX1.1VDvvEoMRVhqEBwBwTy2	email	\N	\N	customer	09567543906	0	t	2021-03-12 00:09:02.89+00	2021-03-12 00:09:02.89+00
28	Gervene Lets Bee	letsbee-gervene@gmail.com	$2a$08$XHOk0RSOvypW.P2lj7kcMuV5bB.ueGJhMHjeewm5195S2wdrsGFxu	email	\N	\N	customer	09567543905	0	t	2021-03-12 00:09:02.915+00	2021-03-12 00:09:02.915+00
29	Jacob Lets Bee	letsbee-jacob@gmail.com	$2a$08$SoAP3SMu1tn3W8bytMjude.jFMei/NDh7ubC9nNtDAhNjQx2p1rTK	email	\N	\N	customer	09567543906	0	t	2021-03-12 00:09:02.94+00	2021-03-12 00:09:02.94+00
30	Luis Lets Bee	letsbee-luis@gmail.com	$2a$08$kjpelLEj6IPPagitp8T/Pu1ADJvDpBU/1fqYjlhI0XInZVOei5Knm	email	\N	\N	customer	09567543906	0	t	2021-03-12 00:09:02.967+00	2021-03-12 00:09:02.967+00
16	John Carlos	letsbee-john@gmail.com	$2a$08$pGrOeDtfOqopsLv36gQD4ezHrU7bjJLBJnz.tBu.KAvHrSGu2n06m	email	\N	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTYsInJvbGUiOiJyaWRlciIsImlhdCI6MTYxNTUwODY3MCwiZXhwIjoxNjE1NTk1MDcwfQ.3mhICC9rOr9EcQP0iMdLBeIvMm4ru49A23HL4_ftrig	rider	09567543906	0	t	2021-03-12 00:09:02.576+00	2021-03-12 00:24:30.709+00
17	Carl Manahan	letsbee-carl@gmail.com	$2a$08$Qo2apy0bDvkEAOWCICstDOqVKjDhR8aR3rTSnE6Uy3lnIdgpeyIYC	email	\N	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTcsInJvbGUiOiJyaWRlciIsImlhdCI6MTYxNTUxNzI0OCwiZXhwIjoxNjE1NjAzNjQ4fQ.RGFK1Wi0Br9kpyrufQJBkTnP9-TM-Kgv01iiwLegYIk	rider	09567543906	0	t	2021-03-12 00:09:02.606+00	2021-03-12 02:47:28.965+00
2	Bongane	bongane@gmail.com	$2a$08$GvtJGDTEmYDmj8bY76XgQ.3kQIKimnziQ1AFOMHqO4.Ra7hntN73G	email	\N	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Miwicm9sZSI6InBhcnRuZXIiLCJpYXQiOjE2MTU1MTIwNDgsImV4cCI6MTYxNTU5ODQ0OH0.yKkE5S9Jsb2L0pWBQP-Ogw9nvtTYhiv8rmh2PEC4j4w	partner	09567543906	0	t	2021-03-12 00:09:01.558+00	2021-03-12 01:20:48.496+00
31	JacobTest	qwerty@test.com	$2a$08$LH0BsvqZQTOHYT0HNPuj6ulrx/XLS/mpEfUtGq9fJQMHHJEEVPTUa	email	\N	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MzEsInJvbGUiOiJjdXN0b21lciIsImlhdCI6MTYxNTUxMTMyNCwiZXhwIjoxNjE1NTk3NzI0fQ.6Glf2elWKB5o50LGZIluLpye97FFEaSoA3cpvtwhnpw	customer	09988633579	1	t	2021-03-12 01:08:01.881+00	2021-03-12 01:08:44.473+00
32	Test	test@gmail.com	$2a$08$9xd0wO.MZQ8/xoaXuPyAJeO0pFG9ANd7..8SOyvPnIxn0SZANhE8a	email	\N	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MzIsInJvbGUiOiJjdXN0b21lciIsImlhdCI6MTYxNTUxMjk2NSwiZXhwIjoxNjE1NTk5MzY1fQ.PCafCh3zhMRhC1uH96gE1NRWam4mPn1pgC6cxtqyeZI	customer	09664489094	1	t	2021-03-12 01:16:36.864+00	2021-03-12 01:36:05.222+00
\.


                                                                                                                                                                                                                                                                                                                                               3260.dat                                                                                            0000600 0004000 0002000 00000012535 14022554213 0014250 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	1	Coke	0	0	0	t	2021-03-12 00:09:01.585+00	2021-03-12 00:09:01.585+00
2	1	Coke Zero	0	0	0	t	2021-03-12 00:09:01.585+00	2021-03-12 00:09:01.585+00
3	1	Sprite	0	0	0	t	2021-03-12 00:09:01.585+00	2021-03-12 00:09:01.585+00
4	1	Pineapple juice	15	15.00	13.95	t	2021-03-12 00:09:01.586+00	2021-03-12 00:09:01.586+00
5	2	Sausage	0	0	0	t	2021-03-12 00:09:01.604+00	2021-03-12 00:09:01.604+00
6	2	Beef	20	20.00	18.60	t	2021-03-12 00:09:01.605+00	2021-03-12 00:09:01.605+00
7	2	Pork	10	10.00	9.30	t	2021-03-12 00:09:01.605+00	2021-03-12 00:09:01.605+00
8	3	a	0	0	0	t	2021-03-12 00:09:01.618+00	2021-03-12 00:09:01.618+00
9	3	b	20	20.00	18.60	t	2021-03-12 00:09:01.618+00	2021-03-12 00:09:01.618+00
10	3	c	20	20.00	18.60	t	2021-03-12 00:09:01.619+00	2021-03-12 00:09:01.619+00
11	4	a	0	0	0	t	2021-03-12 00:09:01.633+00	2021-03-12 00:09:01.633+00
12	4	b	0	0	0	t	2021-03-12 00:09:01.633+00	2021-03-12 00:09:01.633+00
13	4	c	0	0	0	t	2021-03-12 00:09:01.633+00	2021-03-12 00:09:01.633+00
14	5	Regular	0	0	0	t	2021-03-12 00:09:01.71+00	2021-03-12 00:09:01.71+00
15	5	Medium	20	21.40	20.00	t	2021-03-12 00:09:01.71+00	2021-03-12 00:09:01.71+00
16	5	Large	30	32.10	30.00	t	2021-03-12 00:09:01.71+00	2021-03-12 00:09:01.71+00
17	6	Regular	0	0	0	t	2021-03-12 00:09:01.768+00	2021-03-12 00:09:01.768+00
18	6	Medium	20	20.00	18.60	t	2021-03-12 00:09:01.769+00	2021-03-12 00:09:01.769+00
19	6	Large	30	30.00	27.90	t	2021-03-12 00:09:01.77+00	2021-03-12 00:09:01.77+00
20	7	Regular	0	0	0	t	2021-03-12 00:09:01.827+00	2021-03-12 00:09:01.827+00
21	7	Medium	50	50.00	46.50	t	2021-03-12 00:09:01.827+00	2021-03-12 00:09:01.827+00
22	7	Large	100	100.00	93.00	t	2021-03-12 00:09:01.828+00	2021-03-12 00:09:01.828+00
23	8	Coke	0	0	0	t	2021-03-12 00:09:02.019+00	2021-03-12 00:09:02.019+00
24	8	Coke Zero	0	0	0	t	2021-03-12 00:09:02.019+00	2021-03-12 00:09:02.019+00
25	8	Sprite	0	0	0	t	2021-03-12 00:09:02.019+00	2021-03-12 00:09:02.019+00
26	8	Pineapple juice	15	15.00	13.95	t	2021-03-12 00:09:02.019+00	2021-03-12 00:09:02.019+00
27	9	a	0	0	0	t	2021-03-12 00:09:02.031+00	2021-03-12 00:09:02.031+00
28	9	b	20	20.00	18.60	t	2021-03-12 00:09:02.031+00	2021-03-12 00:09:02.031+00
29	9	c	20	20.00	18.60	t	2021-03-12 00:09:02.032+00	2021-03-12 00:09:02.032+00
30	10	a	0	0	0	t	2021-03-12 00:09:02.041+00	2021-03-12 00:09:02.041+00
31	10	b	0	0	0	t	2021-03-12 00:09:02.042+00	2021-03-12 00:09:02.042+00
32	10	c	0	0	0	t	2021-03-12 00:09:02.042+00	2021-03-12 00:09:02.042+00
33	11	Coke	0	0	0	t	2021-03-12 00:09:02.11+00	2021-03-12 00:09:02.11+00
34	11	Coke Zero	0	0	0	t	2021-03-12 00:09:02.111+00	2021-03-12 00:09:02.111+00
35	11	Sprite	0	0	0	t	2021-03-12 00:09:02.111+00	2021-03-12 00:09:02.111+00
36	11	Pineapple juice	15	15.00	13.95	t	2021-03-12 00:09:02.112+00	2021-03-12 00:09:02.112+00
37	12	a	0	0	0	t	2021-03-12 00:09:02.124+00	2021-03-12 00:09:02.124+00
38	12	b	20	20.00	18.60	t	2021-03-12 00:09:02.124+00	2021-03-12 00:09:02.124+00
39	12	c	20	20.00	18.60	t	2021-03-12 00:09:02.125+00	2021-03-12 00:09:02.125+00
40	13	a	0	0	0	t	2021-03-12 00:09:02.136+00	2021-03-12 00:09:02.136+00
41	13	b	0	0	0	t	2021-03-12 00:09:02.136+00	2021-03-12 00:09:02.136+00
42	13	c	0	0	0	t	2021-03-12 00:09:02.136+00	2021-03-12 00:09:02.136+00
43	14	Coke	0	0	0	t	2021-03-12 00:09:02.206+00	2021-03-12 00:09:02.206+00
44	14	Coke Zero	0	0	0	t	2021-03-12 00:09:02.206+00	2021-03-12 00:09:02.206+00
45	14	Sprite	0	0	0	t	2021-03-12 00:09:02.207+00	2021-03-12 00:09:02.207+00
46	14	Pineapple juice	15	15.00	13.95	t	2021-03-12 00:09:02.207+00	2021-03-12 00:09:02.207+00
47	15	a	0	0	0	t	2021-03-12 00:09:02.219+00	2021-03-12 00:09:02.219+00
48	15	b	20	20.00	18.60	t	2021-03-12 00:09:02.219+00	2021-03-12 00:09:02.219+00
49	15	c	20	20.00	18.60	t	2021-03-12 00:09:02.219+00	2021-03-12 00:09:02.219+00
50	16	a	0	0	0	t	2021-03-12 00:09:02.231+00	2021-03-12 00:09:02.231+00
51	16	b	0	0	0	t	2021-03-12 00:09:02.231+00	2021-03-12 00:09:02.231+00
52	16	c	0	0	0	t	2021-03-12 00:09:02.231+00	2021-03-12 00:09:02.231+00
53	17	Coke	0	0	0	t	2021-03-12 00:09:02.318+00	2021-03-12 00:09:02.318+00
54	17	Coke Zero	0	0	0	t	2021-03-12 00:09:02.318+00	2021-03-12 00:09:02.318+00
55	17	Sprite	0	0	0	t	2021-03-12 00:09:02.319+00	2021-03-12 00:09:02.319+00
56	17	Pineapple juice	15	15.00	13.95	t	2021-03-12 00:09:02.319+00	2021-03-12 00:09:02.319+00
57	18	a	0	0	0	t	2021-03-12 00:09:02.337+00	2021-03-12 00:09:02.337+00
58	18	b	20	20.00	18.60	t	2021-03-12 00:09:02.338+00	2021-03-12 00:09:02.338+00
59	18	c	20	20.00	18.60	t	2021-03-12 00:09:02.339+00	2021-03-12 00:09:02.339+00
60	19	a	0	0	0	t	2021-03-12 00:09:02.351+00	2021-03-12 00:09:02.351+00
61	19	b	0	0	0	t	2021-03-12 00:09:02.352+00	2021-03-12 00:09:02.352+00
62	19	c	0	0	0	t	2021-03-12 00:09:02.352+00	2021-03-12 00:09:02.352+00
63	20	Coke	0	0	0	t	2021-03-12 00:09:02.421+00	2021-03-12 00:09:02.421+00
64	20	Coke Zero	0	0	0	t	2021-03-12 00:09:02.422+00	2021-03-12 00:09:02.422+00
65	20	Sprite	0	0	0	t	2021-03-12 00:09:02.422+00	2021-03-12 00:09:02.422+00
66	20	Pineapple juice	15	15.00	13.95	t	2021-03-12 00:09:02.422+00	2021-03-12 00:09:02.422+00
67	21	a	0	0	0	t	2021-03-12 00:09:02.438+00	2021-03-12 00:09:02.438+00
68	21	b	20	20.00	18.60	t	2021-03-12 00:09:02.438+00	2021-03-12 00:09:02.438+00
69	21	c	20	20.00	18.60	t	2021-03-12 00:09:02.438+00	2021-03-12 00:09:02.438+00
70	22	a	0	0	0	t	2021-03-12 00:09:02.447+00	2021-03-12 00:09:02.447+00
71	22	b	0	0	0	t	2021-03-12 00:09:02.447+00	2021-03-12 00:09:02.447+00
72	22	c	0	0	0	t	2021-03-12 00:09:02.447+00	2021-03-12 00:09:02.447+00
\.


                                                                                                                                                                   3258.dat                                                                                            0000600 0004000 0002000 00000003131 14022554213 0014247 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	1	Choice of Drinks	t	2021-03-12 00:09:01.58+00	2021-03-12 00:09:01.58+00
2	1	Choice of Meat	t	2021-03-12 00:09:01.599+00	2021-03-12 00:09:01.599+00
3	1	Choice A	t	2021-03-12 00:09:01.613+00	2021-03-12 00:09:01.613+00
4	1	Choice B	t	2021-03-12 00:09:01.629+00	2021-03-12 00:09:01.629+00
5	2	Choice of Drink Size	t	2021-03-12 00:09:01.706+00	2021-03-12 00:09:01.706+00
6	3	Choice of Drink Size	t	2021-03-12 00:09:01.765+00	2021-03-12 00:09:01.765+00
7	4	Choice of Size	t	2021-03-12 00:09:01.822+00	2021-03-12 00:09:01.822+00
8	8	Choice of Drinks	t	2021-03-12 00:09:02.015+00	2021-03-12 00:09:02.015+00
9	8	Choice A	t	2021-03-12 00:09:02.028+00	2021-03-12 00:09:02.028+00
10	8	Choice B	t	2021-03-12 00:09:02.038+00	2021-03-12 00:09:02.038+00
11	9	Choice of Drinks	t	2021-03-12 00:09:02.106+00	2021-03-12 00:09:02.106+00
12	9	Choice A	t	2021-03-12 00:09:02.12+00	2021-03-12 00:09:02.12+00
13	9	Choice B	t	2021-03-12 00:09:02.132+00	2021-03-12 00:09:02.132+00
14	10	Choice of Drinks	t	2021-03-12 00:09:02.203+00	2021-03-12 00:09:02.203+00
15	10	Choice A	t	2021-03-12 00:09:02.215+00	2021-03-12 00:09:02.215+00
16	10	Choice B	t	2021-03-12 00:09:02.227+00	2021-03-12 00:09:02.227+00
17	11	Choice of Drinks	t	2021-03-12 00:09:02.314+00	2021-03-12 00:09:02.314+00
18	11	Choice A	t	2021-03-12 00:09:02.333+00	2021-03-12 00:09:02.333+00
19	11	Choice B	t	2021-03-12 00:09:02.348+00	2021-03-12 00:09:02.348+00
20	12	Choice of Drinks	t	2021-03-12 00:09:02.418+00	2021-03-12 00:09:02.418+00
21	12	Choice A	t	2021-03-12 00:09:02.435+00	2021-03-12 00:09:02.435+00
22	12	Choice B	t	2021-03-12 00:09:02.444+00	2021-03-12 00:09:02.444+00
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                       restore.sql                                                                                         0000600 0004000 0002000 00000554067 14022554213 0015403 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        --
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
-- Name: create_order(integer, integer, public.enum_orders_status, text, text, text, text, public.enum_orders_contract_type, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_order(p_store_id integer, p_user_id integer, p_status public.enum_orders_status, p_products text, p_fee text, p_address text, p_payment text, p_contract_type public.enum_orders_contract_type, p_timeframe text DEFAULT NULL::text, p_reason text DEFAULT ''::text) RETURNS TABLE(order_id integer)
    LANGUAGE plpgsql
    AS $$ 
DECLARE
  v_order_id INT := 0;
  v_so_id INT := 0;
BEGIN
  SELECT COUNT(*) AS count INTO v_so_id FROM public.orders as o WHERE o.store_id = p_store_id AND o."createdAt"::date = CURRENT_DATE;

  v_so_id = v_so_id + 1;

  INSERT INTO public.orders (so_id, store_id, user_id, status, products, fee, timeframe, address, payment, contract_type, reason, "createdAt", "updatedAt")
    VALUES (v_so_id, p_store_id, p_user_id, p_status, p_products, p_fee, p_timeframe, p_address, p_payment, p_contract_type, p_reason, now(), now())
    RETURNING public.orders.id INTO v_order_id;

  RETURN QUERY SELECT v_order_id;
END;
$$;


ALTER FUNCTION public.create_order(p_store_id integer, p_user_id integer, p_status public.enum_orders_status, p_products text, p_fee text, p_address text, p_payment text, p_contract_type public.enum_orders_contract_type, p_timeframe text, p_reason text) OWNER TO postgres;

--
-- Name: create_product(integer, character varying, text, text, numeric, numeric, numeric, text, text, integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_product(p_user_id integer, p_name character varying, p_description text, p_image text, p_price numeric, p_customer_price numeric, p_seller_price numeric, p_choices text, p_additionals text, p_quantity integer, p_max_order integer, p_category character varying) RETURNS TABLE(id integer, status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_product_id INT := 0;
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Product successfully created!';
BEGIN
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


ALTER FUNCTION public.create_product(p_user_id integer, p_name character varying, p_description text, p_image text, p_price numeric, p_customer_price numeric, p_seller_price numeric, p_choices text, p_additionals text, p_quantity integer, p_max_order integer, p_category character varying) OWNER TO postgres;

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
            sp.variants,
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

CREATE FUNCTION public.find_store_by_id(p_user_id integer) RETURNS TABLE(id integer, user_name character varying, cellphone_number character varying, email character varying, store_name character varying, description text, latitude numeric, longitude numeric, location_name character varying, status public.enum_stores_status, stature public.enum_stores_stature, contract_type public.enum_stores_contract_type, category character varying, country character varying, state character varying, city character varying, barangay character varying, rating numeric, logo_url text, photo_url text, sunday boolean, sunday_opening_time time without time zone, sunday_closing_time time without time zone, monday boolean, monday_opening_time time without time zone, monday_closing_time time without time zone, tuesday boolean, tuesday_opening_time time without time zone, tuesday_closing_time time without time zone, wednesday boolean, wednesday_opening_time time without time zone, wednesday_closing_time time without time zone, thursday boolean, thursday_opening_time time without time zone, thursday_closing_time time without time zone, friday boolean, friday_opening_time time without time zone, friday_closing_time time without time zone, saturday boolean, saturday_opening_time time without time zone, saturday_closing_time time without time zone, "createdAt" timestamp with time zone, "updatedAt" timestamp with time zone)
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
      )
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
  ORDER BY o."createdAt" DESC
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
  CROSS JOIN LATERAL json_array_elements(JSON(o.products)) AS products_json
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
    OR LOWER((JSON(order_address)->>'city')) LIKE CONCAT('%', LOWER(p_query), '%')
    OR LOWER(products_json->>'name') LIKE CONCAT('%', LOWER(p_query), '%')
  )
  ORDER BY o."createdAt" DESC
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
            sp.variants,
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
  CROSS JOIN LATERAL json_array_elements(JSON(o.products)) AS products_json
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
    OR LOWER((JSON(order_address)->>'city')) LIKE CONCAT('%', LOWER(p_query), '%')
    OR LOWER(products_json->>'name') LIKE CONCAT('%', LOWER(p_query), '%')
  )
  ORDER BY o."createdAt" DESC
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
        json_agg(vo.*)
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
    v_message := 'The variant you are trying to update does not exist.';
    RETURN QUERY SELECT v_status, v_message;
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
COPY public.additionals (id, store_id, name, price, customer_price, seller_price, status, "createdAt", "updatedAt") FROM '$$PATH$$/3262.dat';

--
-- Data for Name: carts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.carts (id, store_id, user_id, store_product_id, product_details, total_price, customer_total_price, seller_total_price, choices, additionals, quantity, note, status, "createdAt", "updatedAt") FROM stdin;
\.
COPY public.carts (id, store_id, user_id, store_product_id, product_details, total_price, customer_total_price, seller_total_price, choices, additionals, quantity, note, status, "createdAt", "updatedAt") FROM '$$PATH$$/3246.dat';

--
-- Data for Name: chats; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.chats (id, user_id, order_id, message, "createdAt") FROM stdin;
\.
COPY public.chats (id, user_id, order_id, message, "createdAt") FROM '$$PATH$$/3268.dat';

--
-- Data for Name: districts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.districts (id, name, zip_code, "createdAt", "updatedAt") FROM stdin;
\.
COPY public.districts (id, name, zip_code, "createdAt", "updatedAt") FROM '$$PATH$$/3252.dat';

--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (id, so_id, store_id, user_id, rider_id, status, products, fee, timeframe, address, payment, contract_type, reason, "createdAt", "updatedAt") FROM stdin;
\.
COPY public.orders (id, so_id, store_id, user_id, rider_id, status, products, fee, timeframe, address, payment, contract_type, reason, "createdAt", "updatedAt") FROM '$$PATH$$/3266.dat';

--
-- Data for Name: rider_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rider_logs (id, rider_id, status_from, status_to, "createdAt") FROM stdin;
\.
COPY public.rider_logs (id, rider_id, status_from, status_to, "createdAt") FROM '$$PATH$$/3272.dat';

--
-- Data for Name: rider_tracks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rider_tracks (id, rider_id, order_id, location, "createdAt") FROM stdin;
\.
COPY public.rider_tracks (id, rider_id, order_id, location, "createdAt") FROM '$$PATH$$/3270.dat';

--
-- Data for Name: riders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.riders (id, user_id, photo, status, latitude, longitude, motorcycle_details, "createdAt") FROM stdin;
\.
COPY public.riders (id, user_id, photo, status, latitude, longitude, motorcycle_details, "createdAt") FROM '$$PATH$$/3264.dat';

--
-- Data for Name: store_applications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.store_applications (id, business_name, business_type, district_id, contact_person, email, contact_number, business_address, status, tracking_number, "createdAt", "updatedAt") FROM stdin;
\.
COPY public.store_applications (id, business_name, business_type, district_id, contact_person, email, contact_number, business_address, status, tracking_number, "createdAt", "updatedAt") FROM '$$PATH$$/3274.dat';

--
-- Data for Name: store_products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.store_products (id, store_id, name, description, image, price, customer_price, seller_price, variants, additionals, quantity, max_order, category, status, "createdAt", "updatedAt") FROM stdin;
\.
COPY public.store_products (id, store_id, name, description, image, price, customer_price, seller_price, variants, additionals, quantity, max_order, category, status, "createdAt", "updatedAt") FROM '$$PATH$$/3256.dat';

--
-- Data for Name: stores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stores (id, user_id, district_id, name, description, latitude, longitude, location_name, status, stature, type, contract_type, category, country, state, city, barangay, rating, logo_url, photo_url, sunday, sunday_opening_time, sunday_closing_time, monday, monday_opening_time, monday_closing_time, tuesday, tuesday_opening_time, tuesday_closing_time, wednesday, wednesday_opening_time, wednesday_closing_time, thursday, thursday_opening_time, thursday_closing_time, friday, friday_opening_time, friday_closing_time, saturday, saturday_opening_time, saturday_closing_time, "createdAt", "updatedAt") FROM stdin;
\.
COPY public.stores (id, user_id, district_id, name, description, latitude, longitude, location_name, status, stature, type, contract_type, category, country, state, city, barangay, rating, logo_url, photo_url, sunday, sunday_opening_time, sunday_closing_time, monday, monday_opening_time, monday_closing_time, tuesday, tuesday_opening_time, tuesday_closing_time, wednesday, wednesday_opening_time, wednesday_closing_time, thursday, thursday_opening_time, thursday_closing_time, friday, friday_opening_time, friday_closing_time, saturday, saturday_opening_time, saturday_closing_time, "createdAt", "updatedAt") FROM '$$PATH$$/3254.dat';

--
-- Data for Name: user_addresses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_addresses (id, user_id, name, location, address, note, "createdAt") FROM stdin;
\.
COPY public.user_addresses (id, user_id, name, location, address, note, "createdAt") FROM '$$PATH$$/3250.dat';

--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name, email, password, provider, provider_token, token, role, cellphone_number, cellphone_status, status, "createdAt", "updatedAt") FROM stdin;
\.
COPY public.users (id, name, email, password, provider, provider_token, token, role, cellphone_number, cellphone_status, status, "createdAt", "updatedAt") FROM '$$PATH$$/3248.dat';

--
-- Data for Name: variant_options; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.variant_options (id, variant_id, name, price, customer_price, seller_price, status, "createdAt", "updatedAt") FROM stdin;
\.
COPY public.variant_options (id, variant_id, name, price, customer_price, seller_price, status, "createdAt", "updatedAt") FROM '$$PATH$$/3260.dat';

--
-- Data for Name: variants; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.variants (id, store_id, type, status, "createdAt", "updatedAt") FROM stdin;
\.
COPY public.variants (id, store_id, type, status, "createdAt", "updatedAt") FROM '$$PATH$$/3258.dat';

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

SELECT pg_catalog.setval('public.chats_id_seq', 85, true);


--
-- Name: districts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.districts_id_seq', 20, true);


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_id_seq', 13, true);


--
-- Name: rider_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rider_logs_id_seq', 1, false);


--
-- Name: rider_tracks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rider_tracks_id_seq', 808, true);


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

SELECT pg_catalog.setval('public.stores_id_seq', 14, true);


--
-- Name: user_addresses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_addresses_id_seq', 3, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 32, true);


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

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         