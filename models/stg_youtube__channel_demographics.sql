{{ config(enabled=var('youtube__using_channel_demographics', true)) }}

with base as (

    select * 
    from {{ ref('stg_youtube__channel_demographics_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_youtube__channel_demographics_tmp')),
                staging_columns=get_channel_demographics_columns()
            )
        }}
        
    from base
),

final as (
    
    select 
        _fivetran_id,
        date as date_day,
        video_id,
        channel_id,
        age_group,
        country_code,
        gender,
        live_or_on_demand,
        subscribed_status,
        views_percentage / 100.0 as views_percentage,
        _fivetran_synced
    from fields
)

select * 
from final
