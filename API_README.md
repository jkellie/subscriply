#Subscriply API

The Subscriply API provides a number of endpoints for basic user, subscription, and transaction information.

#Requests

- All successful requests will return a status from the 200 set.
- Authentication errors will return 401.
- Error states will all return 500.
- All requests expect and return JSON.
- All results are scoped to the user. ex. /subscriptions/active will only return active subscriptions for the logged in user.

##Versioning

API versioning is declared by path. Prepend urls with `/api/v1` for version 1 of the api.


#Authentication

Subscriply uses a combination of the `X-User-Token` and `X-User-Email` HTTP headers for API authentication. The token can be created or retrieved for a particular user through a call to  `/api/v1/authentication/sign_in`, and used for any subsequent API requests with no forced expiry.


#Endpoints


##Authentication
###sign_in

`POST /api/v1/authentication/sign_in`

A `POST` to `/api/v1/authentication/sign_in` with the user's login information will return some basic user info and an auth token.

```curl
curl -H 'Content-Type: application/json'   -H 'Accept: application/json' -X POST http://fishies.subscriply.dev/api/v1/authentication/sign_in   -d '{"user": {"email": "test@account.org", "password": "abcd1234"}}'
```
Results:

```json
{
    "user": {
        "active_subscriptions": [1],
        "authentication_token": "emCErzeHf23SAMCSrLU9",
        "email": "test@account.org",
        "first_name": "Sales",
        "last_name": "Repperton",
        "subscriptions": [1]
    }
}
```

##Users
###current

`GET /api/v1/users/current`

Returns information on the currently authenticated user.

###User Object

```json
{
    "user": {
        "active_subscriptions": [1],
        "authentication_token": "emCErzeHf23SAMCSrLU9",
        "email": "test@account.org",
        "first_name": "Sales",
        "last_name": "Repperton",
        "subscriptions": [1]
    }
}
```

##Subscriptions
###show

`GET /api/v1/subscriptions/:id`

Returns extended information for a specific subscription.

###active

`GET /api/v1/subscriptions/active`

Returns all active subscriptions for the current user.


```curl
curl -H 'Content-Type: application/json'   -H 'Accept: application/json' -H 'X-User-Token: emCErzeHf23SAMCSrLU9' -H 'X-User-Email: test@account.org' -X GET http://fishies.subscriply.dev/api/v1/subscriptions/active
```

###index

`GET /api/v1/subscriptions`

Returns all subscriptions for the current user.


```curl
curl -H 'Content-Type: application/json'   -H 'Accept: application/json' -H 'X-User-Token: emCErzeHf23SAMCSrLU9' -H 'X-User-Email: test@account.org' -X GET http://fishies.subscriply.dev/api/v1/subscriptions
```

###Subscription Object

Individual Subscription

```
{
    "subscription": {
        "canceled_on": null,
        "changing_to": null,
        "created_at": "2015-02-25T09:19:07.753-05:00",
        "id": 1,
        "location": null,
        "location_id": null,
        "next_bill_on": "2015-05-01",
        "next_ship_on": "2015-05-04",
        "organization_id": 1,
        "plan": {
            "amount": "54.95",
            "charge_every": 1,
            "code": "direct_eng",
            "created_at": "2015-02-24T14:17:11.721-05:00",
            "description": "Your monthly education program consists of 4 audio CDs, a book, and access to the eFinity Media mobile app.",
            "free_trial_length": 0,
            "id": 4,
            "name": "CEP Plus!",
            "organization_id": 1,
            "plan_type": "shipped",
            "product_id": 1,
            "subtitle": "(Shipped) - English",
            "updated_at": "2015-02-24T14:17:11.721-05:00"
        },
        "plan_id": 4,
        "product": {
            "created_at": "2015-02-23T13:38:22.037-05:00",
            "description": "Write a short overview of the product category for the subscripiton sign up page. Details about each individual plan can be added when you create them.",
            "id": 1,
            "image": {
                "image": {
                    "full": {
                        "url": "fallback/product_default.png"
                    },
                    "medium": {
                        "url": "fallback/product_default.png"
                    },
                    "url": "fallback/product_default.png"
                }
            },
            "name": "Continuing Education",
            "organization_id": 1,
            "prepend_code": "cep",
            "updated_at": "2015-02-23T13:38:22.037-05:00"
        },
        "start_date": "2015-03-01",
        "state": "active",
        "updated_at": "2015-04-07T20:41:13.412-04:00",
        "user_id": 4,
        "uuid": "2d2fe643-aa31-c0b1-cae4-7c4aa28e3b29"
    }
}
```

##Transactions

`/api/v1/subscriptions/:subscription_id/transactions`

Transaction calls are nested within their associated subscription.

###index

`GET /api/v1/subscriptions/:subscription_id/transactions`

Shows all transactions for a subscription.

###successful

`GET /api/v1/subscriptions/:subscription_id/transactions/successful`

Shows only successful transactions for a subscription.

###failed

`GET /api/v1/subscriptions/:subscription_id/transactions/failed`

Shows only failed transactions for a subscription.

###Transaction Object
```
{
    "transaction": {
        "amount_in_cents": 1488,
        "created_at": "2015-03-31T20:42:58.000-04:00",
        "id": 1,
        "invoice": {
            "created_at": "2015-03-31T20:42:56.000-04:00",
            "href": null,
            "id": 4,
            "number": 1976,
            "state": "collected",
            "subscription_id": 7,
            "total_in_cents": 1488,
            "user_id": 10,
            "uuid": "2de13997-b857-dd0d-f4e6-074e64b5f96d"
        },
        "invoice_id": 4,
        "state": "success",
        "subscription_id": 7,
        "transaction_type": "charge",
        "user_id": 10,
        "uuid": "2de1399c-047f-6d2c-d01c-1f45c1accc5b"
    }
}
```
