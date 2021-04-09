## hasura-webhook-auth

### ConfigFile.json

```json
{
    "jwk_url": "https://www.googleapis.com/service_accounts/v1/jwk/securetoken@system.gserviceaccount.com",
    "audience": ["aud1", "aud2"],
    "functions": [
        {
            "secret": "secret-token",
            "hasura_role": "function",
            "hasura_id": "1"
        }
    ]
}
```

### Run

```
docker run -v ./ConfigFile.josn:/app/ConfigFile.json -p 4000:4000 jacobmoura7/hasura-webhook-auth
```