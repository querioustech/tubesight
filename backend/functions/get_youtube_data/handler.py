import json
import requests
import os
from lib import helpers


def handler(event, context):
    regions = ["LK"]

    for region in regions:
        videos_resp = get_videos(region)
        if 'items' in videos_resp:
            videos = {}
            videos['items'] = videos_resp['items']
            videos['regionCode'] = region
            videos['generatedTime'] = helpers.get_dt().strftime('%Y-%m-%d %H:%M:%S')
            
            helpers.upload_file(region, videos)

    return {
        "statusCode": 200,
        "body": json.dumps({
            "result": "success"
        }),
    }

def get_videos(region_code):
    YOUTUBE_API_KEY = helpers.get_secret(os.environ['YOUTUBE_API_KEY'], os.environ['REGION'])
    if YOUTUBE_API_KEY:
        YOUTUBE_API_KEY = YOUTUBE_API_KEY[os.environ['YOUTUBE_API_KEY']]
    else:
        return False

    url = 'https://youtube.googleapis.com/youtube/v3/videos?part=snippet&chart=mostPopular&maxResults=100&regionCode={0}&key={1}'.format(region_code, YOUTUBE_API_KEY)

    response = requests.get(url)

    return response.json()