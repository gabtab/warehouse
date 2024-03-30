 
{{ config(materialized='table') }}

with 
    s_stripe_trans as (select * from {{ ref('int_stripe_transactions') }}),

    final as (
    select 
        {{ dbt_utils.generate_surrogate_key(
            ['source',
            'transaction_id',
            'transaction_type',
            'description',
            'stripe_object_type',
            'currency',
            'status',
            'type']
        ) }} as dim_stripe_pk,
        source,
        transaction_id,
        transaction_type,
        description,
        stripe_object_type,
        currency,
        status,
        type

    from s_stripe_trans
)

select * from final