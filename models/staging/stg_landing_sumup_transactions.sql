with stripe_transactions as (
    select * from {{ source('landing_python', 'sumup_transactions') }}
),

final as (
    
    select
    
    index,
    amount::decimal(20,2) as amount, 
    card_type, 
    currency, 
    entry_mode, 
    id, 
    installments_count, 
    internal_client_transaction_id, 
    internal_id, internal_payment_type, 
    internal_status, internal_tx_result,
    payment_type, 
    payout_plan, 
    payouts_received, 
    payouts_total, 
    product_summary, 
    refunded_amount, 
    status, 
    "timestamp"::timestamp as sumup_trans_timestamp, 
    transaction_code, 
    transaction_id, 
    type, 
    "user", 
    internal_bin,
    internal_card_scheme, 
    internal_card_type, 
    internal_entry_mode_id, 
    to_date(payout_date,'YYYY-MM-DD') as payout_date, 
    payout_type
    
	from stripe_transactions
)

select * from final