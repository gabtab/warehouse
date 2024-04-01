{{ config(materialized='table') }}
with stripe_sessions as (
    select * from {{ ref('stg_landing_stripe_sessions') }}
),

final as (

    select 
    stripe_session_id, 
    allow_promotion_codes, 
    amount_subtotal::decimal(38,2), 
    cast((shipping_cost->'amount_subtotal')::numeric / 100.0 as decimal(38,2)) as shipping_sub_total,
    cast((shipping_cost->'amount_total')::numeric / 100.0 as decimal(38,2)) as shipping_total,
    cast((total_details->'amount_discount')::numeric / 100.0 as decimal(38,2)) as discount_total,
    amount_total::decimal(38,2),
    round(0.25 + amount_total * {{ var('stripe_charge') }},2) as total_charge,
    to_timestamp(created::bigint)::date as created_date,
    to_timestamp(expires_at::bigint)::date as expired_date, 
    currency, 
    customer_creation,
    mode, 
    payment_intent, 
    payment_method_types, 
    payment_status,  
    recovered_from,
    status, 
    success_url

    from stripe_sessions
)

select * from final
