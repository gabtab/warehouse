with invoice as (
    select * from {{ source('website_db', 'invoice_invoice') }}
),

final as (
    
    select 
    id as invoice_id, 
    invoice_number, 
    generated_at, 
    pdf_data as pdf_location, 
    order_id as invoice_order_id 

	from invoice
    
)

select * from final