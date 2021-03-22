## What?
**Controllers** in Upgrow are now quite bare-bone, with most of its classic responsibilities delegated to other layers.

From Upgrow doc:

"The controller now has the single responsibility of abstracting away HTTP concerns, such as extracting data from 
request parameters and forwarding them to the proper Actions. According to the Result returned, the controller then 
crafts the appropriate HTTP response. Controllers don’t hold any logic regarding validations, persistence, or anything 
else behind an Action."

## Why?

See the Why section in README in `app/actions`

## Discussion
Upgrow does not address how authentication/authorization should be done. These are often performed with callbacks in
classic ActionControllers, but with **Controllers** now meant to only deal with HTTP concerns, this is established 
in the main app but for an Upgrow app, it is unclear where authn/authz logic should be. 

An initial thought is to keep the current way the main app authenticates and populates the user context, but include
authorization logic at the **Action** layer, keeping the **Controllers** clean of potential complex authorization logic
(that potentially needs to query the database).