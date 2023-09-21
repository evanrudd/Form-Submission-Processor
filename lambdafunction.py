import json
import boto3

def lambda_handler(event, context):
    form_data = json.loads(event["body"])
    sender_email = "evanrudd02@gmail.com"

    html_message = f"""
    <html>
    <head></head>
    <body>
        <h1>New Contact Form Submission</h1>
        <p><strong>Name:</strong> {form_data["name"]}</p>
        <p><strong>Email:</strong> {form_data["email"]}</p>
        <p><strong>Message:</strong> {form_data["message"]}</p>
    </body>
    </html>
    """

    ses = boto3.client("ses", region_name="us-east-1")
    ses.send_email(
        Source=sender_email,
        Destination={"ToAddresses": ["evanrudd02@gmail.com"]},
        Message={
            "Subject": {"Data": "New Contact Form Submission"},
            "Body": {"Html": {"Data": html_message}},
        },
    )

    response = {
        "statusCode": 200,
        "body": json.dumps({"message": "Form submitted successfully"}),
    }

    return response
