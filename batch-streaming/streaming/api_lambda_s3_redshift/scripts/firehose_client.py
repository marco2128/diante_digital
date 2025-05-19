import os
import boto3
import json
from datetime import datetime

client = boto3.client("firehose", region_name=os.environ.get("AWS_REGION", "us-east-1"))
DELIVERY_STREAM_NAME = os.environ.get("DELIVERY_STREAM_NAME")  # ex: terranova-firehose-stream

def publish(data: str, option: str):
    """
    Publica dados no Amazon Kinesis Firehose.
    """
    if isinstance(data, dict):
        data = json.dumps(data, cls=DateTimeEncoder)

    record = {
        "Data": (data + "\n").encode("utf-8")  # necessário para Firehose ler como linha
    }

    response = client.put_record(
        DeliveryStreamName=DELIVERY_STREAM_NAME,
        Record=record
    )

    return response

class DateTimeEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, datetime):
            return obj.isoformat()
        return super().default(obj)
