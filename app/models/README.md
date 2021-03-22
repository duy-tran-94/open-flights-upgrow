# Models

## What?
**Models** are read-only, immutable POROs (enforced by the magic of `BaseModel < ImmutableObject`) that represent 
entity instances (i.e. query results) returned from **Repositories**.

## Why?

See the Why section in README in `app/records`

## Discussion
After retrieving a **Model** from **Repositories**, **Actions** wrap it in **Results** and return it to **Controllers**.
In this demo, **Controllers** then simply serializes **Models** into JSON, but more complex needs may require a separate
serialization layer (e.g. EH main app defines serializer classes, and unifies their structure with GoogleJSONSerializer). 

Upgrow does not address this need, so we may need to DIY it. The main app way would be to introduce another layer
of serializer classes (i.e. Data Transfer Object pattern in non-Rails framework), or to be less verbose and overload 
**Models** with this responsibility (but violating the Single Responsibility principle).