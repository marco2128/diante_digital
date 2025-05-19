import os
import boto3

CLIENT = {}
CREDENTIALS = {}

def get_client():
    if "instance" not in CLIENT:
        CLIENT["instance"] = boto3.client("secretsmanager", region_name=os.environ.get("AWS_REGION", "us-east-1"))
    return CLIENT["instance"]

def get_credentials(secrets, client=get_client()):
    return tuple(get_credential(secret, client) for secret in secrets)

def get_credential(secret, client=get_client()):
    if secret not in CREDENTIALS:
        response = client.get_secret_value(SecretId=secret)
        CREDENTIALS[secret] = response.get("SecretString", "")
    return CREDENTIALS[secret]
