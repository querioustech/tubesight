import boto3
import json
import os
from datetime import datetime
from botocore.exceptions import ClientError

def generate_file_name_by_dt(extension):
    today_dt = datetime.today()

    file_name = "{}T{}-{}-{}.{}".format(today_dt.date(), today_dt.hour, today_dt.minute, today_dt.second, extension)

    return file_name

def get_secret(secret_name, region_name):

    # Create a Secrets Manager client
    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=region_name
    )

    try:
        get_secret_value_response = client.get_secret_value(
            SecretId=secret_name
        )
    except ClientError as e:
        # For a list of exceptions thrown, see
        # https://docs.aws.amazon.com/secretsmanager/latest/apireference/API_GetSecretValue.html
        raise e

    # Decrypts secret using the associated KMS key.
    secret = get_secret_value_response['SecretString']

    return json.loads(secret)

def upload_file(region, data):
    client = boto3.client('s3')

    bucket = os.environ['RESPONSES_RAW_BUCKET']
    file_name = generate_file_name_by_dt("json")

    upload_path = '/tmp/{}.json'.format(file_name)
    object_path = '{}/{}'.format(region, file_name)

    with open(upload_path, 'w') as outfile:
        json.dump(data, outfile)
    
    client.upload_file(upload_path, bucket, object_path)
