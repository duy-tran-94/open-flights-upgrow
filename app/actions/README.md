# Actions & Results

## What?
**Actions** are objects that exposes an app's core business operations. They are meant to be small, modular, and 
encapsulates one single specific use case, hence a strict requirement: "any given HTTP request handled by the app 
should be handled by a single Action."

**Results** are wrapper objects returned from **Actions** to **Controllers** that contains either a `success` and `failure` 
result, exposing `and_then` and `or_else` methods for easy handling.

## Why?

In the same way classic ActiveRecords are decomposed into three layers, **Records**, **Repositories**, 
and **Model**, classic ActionControllers are often bloated with multiple responsibilities, which Upgrow decomposes into:

1. **Actions**: perform core business operations, one-to-one relationship with API endpoints (i.e. **Controllers'** methods). 
   The functionality and justification for **Actions** is roughly the same as those of ServiceObjects widely used in 
   the main app (see [here](https://employmenthero.atlassian.net/wiki/spaces/EKS/pages/389185648/Service+object+convention)).


2. **Inputs**: represent user-entered data and their validation logic, passed from **Controllers** to **Actions**


3. **Results**: return objects from **Actions** to **Controllers** that facilitate predictable success or error handling


4. **Controllers**: handle only HTTP-related concerns (extracting request params), contain no business logic, 
   calling the right **Action** and passing **Inputs** along (for requests), and choosing the right serializer 
   for the **Results** (for responses)


## Discussion
Note that for now we may not need to adopt the specific Upgrow implementation of **Actions** and **Results** as 
ServiceObjects seem to be functionally equivalent, its usage established and also simpler.

Regarding **Actions**, Upgrow recognizes that they would have the highest chance of becoming big and bloated, and offers
a few pointers [here](https://github.com/szTheory/upgrow/blob/main/docs/guide/caveats.md). The "one endpoint == one Action"
requirement may also leads to a proliferation of endpoints, which need to be balanced with "fat" Actions.

Similar to **Repositories**, another discussion point for **Actions** is whether `Action#perform` should be a static/
class method, or each request would create a new instance of that **Action**. This depends on whether **Action** should
have state or not. The jury is out on this, since this demo app is too simple of an example.

Results are essentially the Optional or Maybe types from other languages, which all treat both nil and non-nil objects
similarly ([Null Object pattern](https://thoughtbot.com/blog/rails-refactoring-example-introduce-null-object)
is a less-general way to do this). As such, it can be replaced with similar gems like dry-monads instead of rolling our 
own. One potential problem with using Result: it doubles the space of possible types an object can have 
(see [here](https://bendyworks.com/blog/tragedy-maybe-monad-ruby)), so adding type validation & coercion could be a 
good idea for Results (e.g. dry-types, used by Grape since v1.3.0)


