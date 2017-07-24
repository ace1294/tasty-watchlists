# tasty-watchlists for coding challenge

iOS App built in Swift 3 using Facebook login to create user profiles with watchlists and symbols.

A user can login with their facebook account then add watchlists with stocks symbols. User can select symbols and get more details and price history of that symbol.

# Users

To create a new user POST to 
```
http://tasty-watchlist.trade:8080/user
```
with params in this format
["name" : "John Doe", "facebook_user_id : "123456789"]

Can GET the user two different ways, with facebook_user_id
```
http://tasty-watchlist.trade:8080/user/facebookUserId/{facebook_user_id}
```
And can GET the user with the server id that comes down when originally loggin in as well
```
http://tasty-watchlist.trade:8080/user/{user_id}
```

Sample User json response

```javascript
{
"id": 2,
"name": "Jason",
"facebook_user_id": "1361761390544819",
"watch_lists": [
{
"id": 3,
"name": "Jason first List",
"symbols": [
{
"id": 3,
"name": "AAPL"
},
{
"id": 4,
"name": "MSFT"
},
{
"id": 5,
"name": "ES"
},
{
"id": 11,
"name": "FORD"
}
]
},
{
"id": 4,
"name": "Hot Stocks",
"symbols": [
{
"id": 6,
"name": "AMD"
},
{
"id": 7,
"name": "NVDA"
},
{
"id": 8,
"name": "ORA"
},
{
"id": 9,
"name": "TSLA"
},
{
"id": 10,
"name": "SLRA"
}
]
}
]
}
```


# Watchlists
Create new Watchlist by POSTing to 
```
http://tasty-watchlist.trade:8080/user/{user_id}/watchlist
```
with params in this format
["name" : "Hot Stocks"]

Watchlist information comes down nested in the user object when calling GET, but can still get watchlist for a single user by call GET on
```
http://tasty-watchlist.trade:8080/user/{user_id}/watchlist
```

Or you can get a single watchlist by calling GET on
```
http://tasty-watchlist.trade:8080/user/{user_id}/watchlist/{watchlist_id}
```

# Symbols
Create new Symbol by POSTing to 
```
http://tasty-watchlist.trade:8080/user/{user_id}/watchlist/{watchlist_id/symbol
```
with params in this format
["name" : "AAPL"]

Symbol information comes down nested in the watchlist objects that are nested in the user object when calling get, but can still get symbols for an individual watchlist by calling GET on
```
http://tasty-watchlist.trade:8080/user/{user_id}/watchlist/{watchlist_id}/symbol
```

Or you can get a single symbol by calling GET on
```
http://tasty-watchlist.trade:8080/user/{user_id}/watchlist/{watchlist_id}/symbol/{symbol_id}
```
