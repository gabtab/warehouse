with checkout_order as (
    select * from {{ source('website_db', 'checkout_order') }}
),

final as (

    select
    
        id::integer as checkout_order_id,
        status as checkout_order_status,
        total_amount as checkout_total_amount,
        created_at as checkout_order_created_at,
        updated_at as checkout_order_updated_at,
        user_id as checkout_order_user_id,
        guest_id as checkout_order_guest_id,
        customer_id as checkout_order_customer_id

    from checkout_order

)

select * from final