#!/usr/bin/python
import sys
import boto3
import botocore
import os
from urlparse import urlparse
from requests import get

def http_download(url):

    u = urlparse(url)
    file_name = os.path.basename(u.path)

    try:
        with open(file_name, "wb") as file:
            response = get(url)
            file.write(response.content)
    except IOError:
        print("Could not write file to disk")

def s3_download(url):

    s3object = urlparse(url)
    bucket = s3object.netloc
    key = s3object.path
    file_name = os.path.basename(s3object.path)

    s3 = boto3.resource('s3')

    try:
        s3.Bucket(bucket).download_file(key, file_name)
    except botocore.exceptions.ClientError as e:
        if e.response['Error']['Code'] == "404":
            print("The object does not exist.")
        else:
            raise


def get_url(args):
    for url in args:
        if "http://" in url:
            http_download(url)
        elif "s3://" in url:
            s3_download(url)
        else:
            print("protocol not recognized " + arg)


get_url(sys.argv[1:])