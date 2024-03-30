{{ config(materialized='table') }}

with 
    s_sumup_trans as (select * from {{ ref('int_sumup_transactions') }}),

    final as (
    select 
        {{ dbt_utils.generate_surrogate_key(
            ['source',
            'transaction_id',
            'transaction_type']
        ) }} as dim_sumup_pk,
        source,
        transaction_id,
        transaction_type

    from s_sumup_trans
)

select * from final