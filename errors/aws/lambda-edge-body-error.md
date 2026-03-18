# Lambda@Edge body is not a string, Buffer, or ReadableStream

> The body is not a string, is not a Buffer, and is not a ReadableStream

## What happened
A Lambda@Edge function returned a response with a body that CloudFront cannot process. The body must be a string or a Buffer, not a raw object.

## Why it happens
Lambda@Edge has strict requirements for the response body format. If you are modifying the origin response or generating a response, the `body` field must be a string. When handling binary content, it must be base64-encoded with `bodyEncoding: 'base64'`. Returning a JavaScript object, number, or undefined as the body triggers this error.

## How to fix it

For text responses (HTML, JSON):
```javascript
exports.handler = async (event) => {
    const response = event.Records[0].cf.response;

    // Modify origin response body - must be a string
    response.body = JSON.stringify({ message: "Hello from edge" });
    response.headers['content-type'] = [{ key: 'Content-Type', value: 'application/json' }];

    return response;
};
```

For generating a new response:
```javascript
exports.handler = async (event) => {
    return {
        status: '200',
        statusDescription: 'OK',
        headers: {
            'content-type': [{ key: 'Content-Type', value: 'text/html' }],
        },
        body: '<html><body>Hello</body></html>',  // must be a string
    };
};
```

For binary content, use base64 encoding:
```javascript
exports.handler = async (event) => {
    const imageBuffer = await fetchImage();

    return {
        status: '200',
        statusDescription: 'OK',
        headers: {
            'content-type': [{ key: 'Content-Type', value: 'image/png' }],
        },
        body: imageBuffer.toString('base64'),
        bodyEncoding: 'base64',
    };
};
```

## Still not working?
- Lambda@Edge has a 1MB body limit for origin responses and 40KB for viewer responses. If the body exceeds this, return it from the origin instead.
- Make sure you return the `cf.response` object (not a Lambda proxy response). Lambda@Edge uses a different response format than API Gateway.
- Check the trigger type: viewer-request, viewer-response, origin-request, and origin-response have different constraints.
- Test locally with the CloudFront event structure from the AWS documentation before deploying.
