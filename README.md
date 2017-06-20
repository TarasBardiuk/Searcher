# Searcher

_**Searcher** application can be used for dynamic filtering data from JSON-file 
of the specified structure and getting the results in the form of a table._

## About implementation

* Implementation uses Ruby on Rails, JavaScript and HTML, including some 
additional libraries - Bootstrap and jQuery.
* Application is based on Ruby 2.4.0 and Rails 5.0.1.
* As incoming data, application uses JSON-file **data.json** located in the 
root directory.
* Search logic is implemented in Ruby and written by repository owner.

## Functionality

* The application uses AJAX to search without updating the entire page.
* **_Searcher_** is not case-sensitive, so you can use Caps Lock if you like.
* **_Searcher_** isn't word-order-sensitive as well. It means, that for `Lisp 
Common` and `Common Lisp`, results will be the same.
* More words - less results. With every new word in search field, 
**_Searcher_** will filter data deeper and deeper, so your results always 
will be precise.
* **_Searcher_** finds matches in different fields.
* Search results ordered by relevance. When **_Searcher_** finds something, it 
evaluates the result depending on which field the match was found in, and 
sorts the results from the highest to the lowest valuation.
* **_Searcher_** supports exact matches by using double brackets, eg. 
`Interpreted "Thomas Eugene"` will match **BASIC**, but not **Haskell**.
* Support negative searches, eg. `john -array` will match **BASIC**, 
**Haskell**, **Lisp** and **S-Lang**, but not **Chapel**, **Fortran** or **S**.
