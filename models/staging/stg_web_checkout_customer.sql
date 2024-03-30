with checkout_customer as (
    select * from {{ source('website_db', 'checkout_customer') }}
),

final as (

    select
    
        id::integer as checkout_customer_id,
        full_name as checkout_customer_full_name,
        email as checkout_email,
        shipping_address_line1 as checkout_shipping_address_line1,
        shipping_address_line2 as checkout_shipping_address_line2,
        shipping_postal_code, 
        shipping_country, 
        shipping_state, 
        billing_address_line1, 
        billing_address_line2, 
        billing_postal_code, 
        billing_country, 
        billing_state, 
        created_at, 
        updated_at

    from checkout_customer

)

select * from final