with cart_item as (
    select * from {{ source('website_db', 'cart_cartitem') }}
),

final as (

    select
    
        id::integer as cart_item_id,
        quantity as cart_item_quantity,
        cart_id as cart_id,
        product_id as cart_item_product_id,
        added_at as cart_item_added_at,
        total_price as total_price_cart_item,
        unit_price as unit_price_cart_item

    from cart_item

)

select * from final