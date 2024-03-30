with catalogue_product as (
    select * from {{ source('website_db', 'catalogue_product') }}
),

final as (
    
    select 
    id as catalogue_product_id, 
    name as catalogue_product_name, 
    description, 
    price, 
    image, 
    benefit, 
    instructions, 
    slug

	from catalogue_product
    
)

select * from final