# Schemas

- `app_public` is visible to GraphQL
- `app_hidden` is visible but not exposed by GraphQL
- `app_private` is not visible (at all) to GraphQL


# `psql`
```sh
docker-compose exec postgres psql 'options=--search_path=app_public,app_hidden,app_private,public user=postgres'
# or
psql 'options=--search_path=app_public,app_hidden,app_private,public dbname=asyncy'
```
