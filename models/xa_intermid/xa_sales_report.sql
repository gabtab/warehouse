{{ config(materialized='table') }}

with stripe_transactions as (
    select 
        'stripe' as source,
        stripe_session_id as transaction_id,
        created_date as transaction_date, 
        status as transaction_type,
        total_charge as transaction_fee,
        discount_total as discount_total,
        shipping_total as shipping_total,
        amount_total as transaction_amount

    from {{ ref('int_stripe_actions_sessions') }}

),

sumup_transactions as (
    select 
        source,
        transaction_id as transaction_id,
        transaction_timestamp::date as transaction_date, 
        transaction_type as transaction_type,
        transaction_fee as transaction_fee,
        0.00 as discount_total,
        0.00 as shipping_total,
        transaction_amount as transaction_amount
        
    from {{ ref('int_sumup_transactions') }}

)

select * from stripe_transactions
union all
select * from sumup_transactions

