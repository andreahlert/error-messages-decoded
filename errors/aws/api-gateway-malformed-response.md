# API Gateway malformed Lambda proxy response

> Execution failed due to configuration error: Malformed Lambda proxy response

## What happened
API Gateway received a response from your Lambda function that does not match the expected format for Lambda proxy integration.

## Why it happens
When using Lambda proxy integration, API Gateway expects the Lambda function to return a response object with a specific structure: `statusCode` (number), `headers` (object), and `body` (string). If any of these are missing or the body is not a string (e.g., returning a raw object instead of `JSON.stringify()`), API Gateway cannot parse the response and returns a 502 error.

## How to fix it

Return the correct response format from your Lambda function:
```javascript
// Node.js
exports.handler = async (event) => {
    const data = { message: "Hello" };

    return {
        statusCode: 200,
        headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*"
        },
        body: JSON.stringify(data),  // body MUST be a string
        isBase64Encoded: false
    };
};
```

Python example:
```python
import json

def handler(event, context):
    data = {"message": "Hello"}

    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*"
        },
        "body": json.dumps(data),  # body MUST be a string
        "isBase64Encoded": False
    }
```

Make sure error paths also return the correct format:
```javascript
exports.handler = async (event) => {
    try {
        const result = await doWork();
        return {
            statusCode: 200,
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(result)
        };
    } catch (err) {
        // Error responses must also follow the format
        return {
            statusCode: 500,
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ error: err.message })
        };
    }
};
```

## Still not working?
- Check that `statusCode` is a number (not a string): `statusCode: 200` not `statusCode: "200"`.
- If returning binary data (images, PDFs), set `isBase64Encoded: true` and base64-encode the body.
- Test your Lambda function directly (not through API Gateway) to see the raw response: `aws lambda invoke --function-name my-func output.json`.
- Check CloudWatch Logs for the Lambda execution to see if an unhandled exception is returning a non-object response.
