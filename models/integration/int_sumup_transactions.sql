{{ config(materialized='table') }}


with 
    s_sumup_trans as (select * from {{ ref('stg_landing_sumup_transactions') }}),

    calc as (
        select 
            'sumup' as source,
            'sumup-' || id as transaction_id,
            case when type = 'PAYMENT' then 'payout' end as transaction_type,
            sumup_trans_timestamp as transaction_timestamp,
            payout_date as transaction_date,
            amount as transaction_amount,
            round(amount - (amount * {{ var('sumup_charge') }}),2) as transaction_amount_net
        from s_sumup_trans
    ),

    final as (
        
        select 
            source,
            transaction_id,
            transaction_type,
            transaction_timestamp,
            transaction_date,
            transaction_amount,
            transaction_amount_net,
            transaction_amount - transaction_amount_net as transaction_fee
        from calc
    )

select * from final