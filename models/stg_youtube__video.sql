
with base as (

    select * 
    from {{ ref('stg_youtube__video_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_youtube__video_tmp')),
                staging_columns=get_video_columns()
            )
        }}
    from base
),

final as (
    
    select 
        _fivetran_synced,
        content_details_caption,
        content_details_definition,
        content_details_dimension,
        content_details_duration,
        content_details_has_custom_thumbnail,
        content_details_licensed_content,
        content_details_projection,
        content_details_region_restriction,
        etag,
        id,
        kind,
        player_embed_height,
        player_embed_html,
        player_embed_width,
        privacy_status,
        snippet_category_id,
        snippet_channel_id,
        snippet_channel_title,
        snippet_default_audio_language,
        snippet_default_language,
        snippet_description,
        snippet_live_broadcast_content,
        snippet_localized,
        snippet_published_at,
        snippet_tags,
        snippet_thumbnails,
        snippet_title,
        statistics_comment_count,
        statistics_dislike_count,
        statistics_favorite_count,
        statistics_like_count,
        statistics_view_count,
        status_embeddable,
        status_failure_reason,
        status_license,
        status_made_for_kids,
        status_public_stats_viewable,
        status_publish_at,
        status_rejection_reason,
        status_self_declared_made_for_kids,
        upload_status
    from fields
)

select *
from final
