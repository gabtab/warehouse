with checkout_order_item as (
    select * from {{ source('website_db', 'checkout_orderitem') }}
),

final as (

    select
    
        id::integer as checkout_order_item_id,
        quantity as checkout_order_quantity,
        price as checkout_order_item_price,
        order_id as checkout_order_id,
        product_id as checkout_order_item_product_id

    from checkout_order_item

)

select * from final