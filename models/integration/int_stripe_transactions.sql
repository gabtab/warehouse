{{ config(materialized='table') }}

with 
    s_stripe_trans as (select * from {{ ref('stg_landing_stripe_transactions') }}),

    final as (

    select 
        'stripe' as source,
        'stripe-' || stripe_transaction_id as transaction_id,
        reporting_category as transaction_type,
        created as transaction_timestamp,
        created::date as transaction_date,
        round(amount_subtotal,2) as transaction_amount,
        round(net,2) as transaction_amount_net,
        round(cast(fee as decimal)/100, 2)  as transaction_fee,
        description,
        stripe_object_type,
        currency,
        status,
        type


        from s_stripe_trans
    )

    select * from final