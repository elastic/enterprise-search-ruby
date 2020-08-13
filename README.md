# Elastic Enterprise Search Client

This project is in development and is not ready for use in production yet.

## Enterprise Search

```ruby
http_auth = {user: 'elastic', password: 'password'}
ent_client = Elastic::EnterpriseSearch::Client.new(host: 'host', http_auth: http_auth)
ent_client.health
```

## Workplace Search

```ruby
ent_client = Elastic::EnterpriseSearch::Client.new
http_auth = '<content source access token>'
ent_client.workplace_search.http_auth = http_auth
ent_client.index_documents(content_source_key, documents)
```

## License

Apache-2.0
