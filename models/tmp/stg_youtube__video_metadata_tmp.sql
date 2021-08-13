{{ config(enabled=var('youtube__using_video_metadata', false)) }}

select * 
from {{ var('video_metadata') }}
