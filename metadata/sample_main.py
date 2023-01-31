import requests
import json


def assemble_response_json(insert):
    response_dict = {
        "state": {"videos": 1},
        "schema": {"videos": {"primary_key": ["id"]}},
        "insert": {"videos": insert},
        "hasMore": False,
    }
    return json.dumps(response_dict)


def get_youtube_data(channel_id, api_key, next_page_id=None):

    api_url = "https://youtube.googleapis.com/youtube/v3/search"
    params = {
        "part": "snippet",
        "channelId": channel_id,
        "key": api_key,
        "maxResults": 50,
        "type": "video",
    }
    if next_page_id:
        params["pageToken"] = next_page_id
    r = requests.get(url=api_url, params=params, headers={"Accept": "application/json"})
    return r.json()


def handler(request):

    request_json = request.get_json()
    api_key = request_json["secrets"]["api_key"]
    channels = request_json["secrets"]["channels"]

    videos = []

    for channel in channels:
        video_index = 0
        max_videos = 50
        next_page_id = None
        while video_index < max_videos:
            data = get_youtube_data(channel, api_key, next_page_id)
            video_index += 50
            max_videos = data["pageInfo"]["totalResults"]
            next_page_id = data.get("nextPageToken")
            for entry in data["items"]:
                video = {
                    "id": entry["id"]["videoId"],
                    "published_at": entry["snippet"]["publishedAt"],
                    "title": entry["snippet"]["title"],
                    "description": entry["snippet"]["description"],
                    "channel_id": entry["snippet"]["channelId"],
                    "channel_title": entry["snippet"]["channelTitle"],
                    "thumbnails": entry["snippet"]["thumbnails"]
                }
                videos.append(video)
                
    return assemble_response_json(videos), 200, {"Content-Type": "application/json"}