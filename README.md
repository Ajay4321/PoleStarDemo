# PoleStarDemo

Used MVVM design pattern for this demo.

Created Landing page where search input available with "Get Books" button on right navigation item.
User can also get search result from tap of "Search" in keyboard.

# Below conditions i have checked for input validation:

1. If user taps on "Get Books" or "Search" without a keyword in search field then message appears as 
    ("Please type some keyword in search input to search books.").

2. In Search Input only 30 Characters are allowed including white spaces.

3. In Search Input Only below characters are allowed to search which are inside the brackets.
    ( ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_.).

4. If User tries to input other than these above characters, the message appears on tap of "Get Books" or "Search" as 
    ("Please type some valid keyword in search input to search books.”).

5. If user tries to search same keyword again and pressed "Get Books" or "Search" then this message appears 
    ("You are searching again for same keyword.").

# Below Conditions are checked for search results from api:

1. Found -> If everything goes well and i got the result then data is displayed to user.

2. NotFound -> If search input does not match with api results or any matching data not found the message appears as below.
    ("Search results not found.")

3. Failed -> If search request failed then below message appears as below.
    ("Search request failed.")

# Major Functionalities

1. PoleStarDemo application tries to search, first from database if data not found in database, then it fetches records from api and store top 10 results in database.

2. Like If user tries to search first time "Lord of the rings" or any valid keyword which returns valid response, then top 10 results are stored in sqlite database.

3. if user tries to search other keyword than "Lord of the rings" then it will fetch records from the api.

4. if user tries to search "Lord of the rings" then it will display records from database only.

# More Features covered 

1. Implemented toast.
2. Implemented Image Cache for UITableViewCell scrolling image flickering issue.
3. if there is not an image url, then placeholder image is shown.

# Known Issue

for cover images this type of url not handled
http://covers.openlibrary.org/b/isbn/0976143232-M.jpg  

In this case image url is returning very small dot size images so placeholder case also not working. it seems to be blank space in cover but there is a very small image.


