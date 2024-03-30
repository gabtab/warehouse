{{ config(materialized='table') }}

with 
    dim_stripe as (select * from {{ ref('dim_stripe') }}),
    dim_sumup as (select * from {{ ref('dim_sumup') }}),
    source_fact_stripe as (select * from {{ ref('int_stripe_transactions') }}),
    source_fact_sumup as (select * from {{ ref('int_sumup_transactions') }}),

s_fact_stripe as (

    select 
        {{ dbt_utils.generate_surrogate_key(['source_fact_stripe.transaction_id']) }} as transaction_pk,
        source_fact_stripe.transaction_id,
        transaction_timestamp,
        transaction_date,
        transaction_amount,
        transaction_amount_net,
        transaction_fee,
        dim_stripe.dim_stripe_pk as dim_stripe_fk,
        null as dim_sumup_fk

    from source_fact_stripe

    join dim_stripe on dim_stripe.transaction_id = source_fact_stripe.transaction_id

),

s_fact_sumup as (

    select 
        {{ dbt_utils.generate_surrogate_key(['source_fact_sumup.transaction_id']) }} as transaction_pk,
        source_fact_sumup.transaction_id,
        transaction_timestamp,
        transaction_date,
        transaction_amount,
        transaction_amount_net,
        transaction_fee,
        null as dim_stripe_fk,
        dim_sumup_pk as dim_sumup_fk

    from source_fact_sumup

    join dim_sumup on dim_sumup.transaction_id = source_fact_sumup.transaction_id

),

final as (

    select * from s_fact_stripe
    union all
    select * from s_fact_sumup

)

select * from final