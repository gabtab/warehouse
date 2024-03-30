with cart as (
    select * from {{ source('website_db', 'cart_cart') }}
),

enriched as (
    
    select
        cart.*
    from cart
    join {{ source('website_db', 'cart_cartitem') }} as cart_item
    on cart.id = cart_item.cart_id
)

select * from enriched