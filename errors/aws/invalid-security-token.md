# The security token included in the request is invalid

> An error occurred (InvalidClientTokenId) when calling the GetCallerIdentity operation: The security token included in the request is invalid.
> An error occurred (ExpiredTokenException) when calling the XXX operation: The security token included in the request is expired.

## What happened

The AWS credentials you're using are invalid, expired, or malformed. AWS can't authenticate you at all.

## Why it happens

- Temporary session credentials (from `aws sso login` or `sts assume-role`) expired
- You copy-pasted credentials and missed a character or included whitespace
- Environment variables override your intended profile
- The access key was rotated or deleted in the IAM console

## How to fix it

**Check your current credentials:**

```bash
aws sts get-caller-identity
# If this fails, your credentials are the problem
```

**If using SSO:**

```bash
aws sso login --profile my-profile
```

**If using temporary credentials, refresh them:**

```bash
# Re-assume the role
aws sts assume-role --role-arn arn:aws:iam::123456789012:role/MyRole \
  --role-session-name mysession

# Or if using a script that exports creds
eval $(assume-role my-role)
```

**Check for conflicting environment variables:**

```bash
echo $AWS_ACCESS_KEY_ID
echo $AWS_SECRET_ACCESS_KEY
echo $AWS_SESSION_TOKEN

# Clear them if they're stale
unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
```

**Check credential file for corruption:**

```bash
cat ~/.aws/credentials
# Make sure there's no trailing whitespace or extra newlines in the keys
```

## Don't do this

- Don't create new access keys every time this happens. Check if the current ones are valid first.
- Don't hardcode credentials in your code to "avoid this problem."

## Still not working?

- Check if your system clock is off. AWS rejects requests with timestamps more than 5 minutes off: `date -u`.
- If in a container/Lambda, the metadata endpoint might be unreachable. Check `curl http://169.254.169.254/latest/meta-data/`.
- Verify the key exists and is active in IAM console under Security Credentials.
