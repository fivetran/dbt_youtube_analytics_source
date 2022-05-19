{{ config(enabled=var('youtube__using_video_metadata', false)) }}

with base as (

    select * 
    from {{ ref('stg_youtube__video_metadata_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_youtube__video_metadata_tmp')),
                staging_columns=get_video_metadata_columns()
            )
        }}
        
    from base
),

final as (
    
    select 
        id as video_id,
        title,
        description,
        thumbnails,
        cast (published_at as {{ dbt_utils.type_timestamp() }}) as published_at,
        channel_title,
        _fivetran_batch,
        _fivetran_index,
        _fivetran_synced
    from fields
)

select * 
from final
