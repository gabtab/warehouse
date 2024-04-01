with stripe_transactions as (
    select * from {{ source('landing_python', 'stripe_transactions') }}
),

final as (
    
    select
    
    id  as stripe_transaction_id, 
    object as stripe_object_type,
    case when amount ~ '^\d+$' then amount::integer / 100.0 else null end as amount_subtotal, 
    to_timestamp(available_on::bigint) as available_on,
    to_timestamp(created::bigint) as created,
    currency, 
    description, 
    exchange_rate, 
    fee, 
    fee_details, 
    case when net ~ '^\d+$' then net::integer / 100.0 else null end as net, 
    reporting_category, 
    source, 
    status, 
    type
    
	from stripe_transactions
)

select * from final