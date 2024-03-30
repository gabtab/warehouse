with web_sessions as (
    select * from {{ source('website_db', 'django_session') }}
),

final as (
    
    select

        session_key as session_key,
        session_data as session_data, --encoded in django need depickle it
        expire_date as expire_date

    from web_sessions

)

select * from final