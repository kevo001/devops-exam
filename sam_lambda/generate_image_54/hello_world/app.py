import base64
import boto3
import json
import random
import os
import logging

# Sett opp logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Sett opp AWS-klienter
bedrock_client = boto3.client("bedrock-runtime", region_name="us-east-1")
s3_client = boto3.client("s3")

# Hent bucket-navn fra miljøvariabel (definert i SAM template)
bucket_name = os.environ["S3_BUCKET_NAME"]
candidate_number = os.getenv("CANDIDATE_NUMBER", "54")

def lambda_handler(event, context):
    """Lambda-funksjon som genererer bilde basert på en prompt"""

    # Logg miljøvariabler
    logger.info(f"Using bucket: {bucket_name}")
    logger.info(f"Using candidate number: {candidate_number}")

    # Hent prompt fra POST-body
    try:
        body = json.loads(event["body"])
        prompt = body.get("prompt", "")
        logger.info(f"Received prompt: {prompt}")
    except Exception as e:
        logger.error(f"Error parsing request body: {e}")
        return {
            "statusCode": 400,
            "body": json.dumps({"message": "Invalid request body"})
        }

    if not prompt:
        return {
            "statusCode": 400,
            "body": json.dumps({"message": "Prompt is required"})
        }

    # Generer et tilfeldig seed
    seed = random.randint(0, 2147483647)
    s3_image_path = f"{candidate_number}/generated_images/titan_{seed}.png"
    logger.info(f"Generated image path: {s3_image_path}")

    # Bygg forespørselen til Bedrock
    native_request = {
        "taskType": "TEXT_IMAGE",
        "textToImageParams": {"text": prompt},
        "imageGenerationConfig": {
            "numberOfImages": 1,
            "quality": "standard",
            "cfgScale": 8.0,
            "height": 1024,
            "width": 1024,
            "seed": seed,
        }
    }

    # Send forespørsel til Bedrock
    try:
        response = bedrock_client.invoke_model(modelId="amazon.titan-image-generator-v1", body=json.dumps(native_request))
        model_response = json.loads(response["body"].read())
        logger.info("Received response from Bedrock")
    except Exception as e:
        logger.error(f"Error calling Bedrock API: {e}")
        return {
            "statusCode": 500,
            "body": json.dumps({"message": "Error generating image from Bedrock"})
        }

    # Hent og dekode Base64-bildedata
    try:
        base64_image_data = model_response["images"][0]
        image_data = base64.b64decode(base64_image_data)
        logger.info("Image data decoded successfully")
    except Exception as e:
        logger.error(f"Error decoding image data: {e}")
        return {
            "statusCode": 500,
            "body": json.dumps({"message": "Error processing image data"})
        }

    # Last opp bildet til S3
    try:
        s3_client.put_object(Bucket=bucket_name, Key=s3_image_path, Body=image_data)
        logger.info("Image uploaded to S3 successfully")
    except Exception as e:
        logger.error(f"Error uploading image to S3: {e}")
        return {
            "statusCode": 500,
            "body": json.dumps({"message": "Error uploading image to S3"})
        }

    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": "Image generated successfully",
            "image_url": f"s3://{bucket_name}/{s3_image_path}"
        })
    }