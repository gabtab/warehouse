with stripe_sessions as (
    select * from {{ source('landing_python', 'stripe_sessions') }}
),

final as (
    
    select 
    id as stripe_session_id, 
    object, 
    after_expiration, 
    allow_promotion_codes, 
    CASE WHEN amount_subtotal ~ '^\d+$' THEN amount_subtotal::integer / 100.0 ELSE NULL END as amount_subtotal, 
    CASE WHEN amount_total ~ '^\d+$' THEN amount_total::integer / 100.0 ELSE NULL END as amount_total, 
    automatic_tax::jsonb,
    billing_address_collection, 
    cancel_url, 
    client_reference_id, 
    client_secret, 
    consent, 
    consent_collection, 
    created, currency, 
    currency_conversion, 
    custom_fields, 
    custom_text::jsonb, 
    customer, 
    customer_creation,
    customer_details::jsonb, 
    customer_email, 
    expires_at, 
    invoice, 
    invoice_creation::jsonb, 
    livemode, 
    locale, 
    metadata, 
    mode, 
    payment_intent, 
    payment_link, 
    payment_method_collection,
    payment_method_configuration_details, 
    payment_method_options::jsonb, 
    payment_method_types, 
    payment_status, 
    phone_number_collection, 
    recovered_from, 
    setup_intent, 
    shipping_address_collection::jsonb, 
    shipping_cost::jsonb, 
    shipping_details::jsonb, 
    shipping_options, 
    status, 
    submit_type, 
    subscription,
    success_url, 
    total_details::jsonb, 
    ui_mode, 
    url
    
	from stripe_sessions
)

select * from final