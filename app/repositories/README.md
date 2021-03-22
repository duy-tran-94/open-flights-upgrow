# Repositories

## What?
**Repositories** are read-only, immutable POROs (enforced by the magic of `BaseModel < ImmutableObject`) that represent
entity instances (i.e. query results) returned from **Repositories**.

## Why?

See the Why section in README in `app/records`

## Discussion

The available implementation of Upgrow's Repository pattern raises a few discussion points:

- Verbosity: all methods need to call `to_model()` and `to_*_model()` for associated **Models**.


- "You get a repo, you get a repo, everyone gets a repo": **Repositories** hold no state, so it's a head-scratcher 
  as to why a new repo instance is created for every action. Other implementations of the repository pattern 
  ([for example](https://kellysutton.com/2019/10/29/taming-large-rails-codebases-with-private-activerecord-models.html))
  often have all methods be class methods and just call `AirlineRepository.find()` instead of 
  `AirlineRepository.new.find()`.


- Lack of error handling: this is part of a larger discussion on error handling, but all **Repositories'"**
methods currently fail to handle the case when a record is not found. This currently makes 
  `to_model(record.attributes)` calls fail since a `record = Airline.find()` call may return nil and 
  so `nil.attributes` panics.
  
How do we handle errors at the Repository layer? Exceptions could be categorized as expected (checked) and unexpected
(runtime). Unexpected exceptions (lost db connection, timeout waiting for db connection pool) is often dealt with 
generically by the framework or manually, but expected ones could be handled in a few ways:

1. Not doing anything. Not great, expected exceptions (validation errors, RecordNotFound) should fail gracefully.
2. Re-raise the exception and handle generically elsewhere. This just shifts the responsibility away with no real 
   solution. Exceptions are also less performant than other mechanisms of flow control.
3. Interactor pattern: Quite nice, this is the pattern used by ServiceObjects in the main app, with caller checking for 
   errors explicitly (`success?` and `errors?`), this also avoids the high cost of exception raising and rescuing. This 
   pattern can be combined with Result-like wrappers for **Actions** to deal with (kinda like how **Actions** returns
   **Results** for **Controllers** to deal with)
4. Repositories only returning Result-like wrappers or Enumerables: Not a general approach for error handling, but 
   for RecordNotFound situations, **Repositories** could follow a simple contract to return a Result-like wrapper (success 
   or failure) OR an Enumerable. If no record is found, this guarantees that **Actions** will get an empty Enumerable,
   or need to explicitly deal with the Result wrapper (`and_then` & `or_else`), nudging the developer to handle potential 
   `nil` values up front.

For (3) and (4), see a few possibilities [here](https://stackoverflow.com/questions/51607163/best-practice-of-error-handling-on-controller-and-interactor).