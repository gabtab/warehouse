with cart as (
    select * from {{ source('website_db', 'cart_cart') }}
),

final as (
    
    select

        id::integer as cart_id,
        user_id::integer as cart_user_id,
        created_at as total,
        status as cart_status,
        updated_at as cart_updated_at,
        guest_session_id as cart_guest_session_id

    from cart

)

select * from final