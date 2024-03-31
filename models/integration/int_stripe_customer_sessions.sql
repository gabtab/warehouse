{{ config(materialized='table') }}
with stripe_sessions as (
    select * from {{ ref('stg_landing_stripe_sessions') }}
),

final as (
    SELECT 
        stripe_session_id,
        customer_details->>'email' AS customer_email,
        customer_details->>'name' AS customer_name,
        customer_details->'address'->>'city' AS customer_city,
        customer_details->'address'->>'line1' AS customer_line1,
        customer_details->'address'->>'line2' AS customer_line2,
        customer_details->'address'->>'state' AS customer_state,
        customer_details->'address'->>'country' AS customer_country,
        customer_details->'address'->>'postal_code' AS customer_postal_code,
        shipping_details->'address'->>'city' AS shipping_city,
        shipping_details->'address'->>'line1' AS shipping_line1,
        shipping_details->'address'->>'line2' AS shipping_line2,
        shipping_details->'address'->>'state' AS shipping_state,
        shipping_details->'address'->>'country' AS shipping_country,
        shipping_details->'address'->>'postal_code' AS shipping_postal_code
    FROM 
    stripe_sessions
    where status='complete'

)

select * from final
where customer_email != 'byrne.gavin5@gmail.com'