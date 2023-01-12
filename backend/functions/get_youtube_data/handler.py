import json
import requests
import os
from lib import helpers


def handler(event, context):
    regions = ["LK"]

    for region in regions:
        videos = get_videos(region)

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