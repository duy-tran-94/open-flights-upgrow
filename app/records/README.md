# Records

## What?
Rails models (ActiveRecord's children classes) are now called **Records** and located in `app/records` as seen here.

**Records** are basically bare-bone Rails models, they have two responsibilities: (1) database-level constraint validation, and (2) representing a table and its associations
(e.g. `has_many`, `belongs_to`).


## Why?
**Records** is the closest-to-database abstraction layer, it is the first layer among the three 
that are meant to "hide" ActiveRecord. 

ActiveRecord instances often bear too many responsibilities and exposes too big of a public surface 
(`AirlineRecord.public_methods.size == 689`). Upgrow separates out three main responsibilities into 
three separate layers:

1. Relation representation (schema attributes, constraints, and relationships) == **Records**
2. Querying & Persistence == **Repositories**
3. Entity instances (query results) == **Model**
   
Note: Upgrow uses the term **Models** to refer to immutable, read-only entities which are retrieved by **Repositories**.
See `app/models` for more.

## Discussion
In terms of cost-benefit analysis, Repository pattern is probably the most worthwhile and popular pattern in non-Rails
Ruby frameworks (e.g. Hanami, ROM), since querying logic (1) quickly pollutes ActiveRecord instances, and (2) is 
conceptually distinct from other responsibilities.

The pattern to return read-only objects (Model) from Repositories is much less well-known, and requires more discussion. 
In other frameworks, oftentimes, Repositories returns instances of Records, since it bridges the Object-Relation connection
conceptually (i.e. Record class represents a table, so naturally Record instances represents its rows). The read-only
nature of Model also means Inputs are required for Repositories' write operations.

At the cost of more boilerplate, Models (and Inputs) are used to make the data to flow in only one way for one direction 
(see diagram). This achieves another goal of Upgrow: completely hiding ActiveRecord instances from Action/Controller layers.
Models make sense in this context.
