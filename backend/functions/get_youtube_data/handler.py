import json
import requests
import os
from lib import helpers


def handler(event, context):
    videos = get_videos("LK")

    return videos

    # return {
    #     "statusCode": 200,
    #     "body": json.dumps({
    #         "result": YOUTUBE_API_KEY
    #     }),
    # }

def get_videos(region_code):
    YOUTUBE_API_KEY = helpers.get_secret(os.environ['YOUTUBE_API_KEY'], os.environ['REGION'])
    if YOUTUBE_API_KEY:
        YOUTUBE_API_KEY = YOUTUBE_API_KEY[os.environ['YOUTUBE_API_KEY']]
    else:
        return False

    url = 'https://youtube.googleapis.com/youtube/v3/videos?part=snippet&chart=mostPopular&regionCode={0}&key={1}'.format(region_code, YOUTUBE_API_KEY)

    response = requests.get(url)

    return response.json()