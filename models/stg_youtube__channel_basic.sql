
with base as (

    select * 
    from {{ ref('stg_youtube__channel_basic_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_youtube__channel_basic_tmp')),
                staging_columns=get_channel_basic_columns()
            )
        }}
        
    from base
),

final as (
    
    select 
        date as date_day,
        likes,
        dislikes,
        shares
    from fields
)

select * from final
