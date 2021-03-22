# OpenFlights-Upgrow

This repo partially re-implements the sample app [OpenFlights](https://github.com/zayneio/open-flights) following the 
Upgrow architecture (see [mirror](https://github.com/szTheory/upgrow)). Some Upgrow source code is obtained from the 
original [Upgrow gem](https://rubydoc.info/gems/upgrow/Upgrow).

## Reading Guide
Upgrow introduces many more abstractions and layers, trading more organizational overhead and boilerplate for the
promise of more maintainable architecture as RoR apps grow bigger. While definitely not the Rails way, these layers are 
simply a more systematic approach of the various ways the Rails community has tried to refactor apps (e.g. see [here](
https://codeclimate.com/blog/7-ways-to-decompose-fat-activerecord-models/)), and we can easily pick and choose what
would work for us and our needs. For example, this demo app does not implement or discuss the View layer, since
modern apps' front-ends are often SPAs, not ERB templates.

A strength of Upgrow is that the architecture consists of pragmatic, tried-and-true patterns from FP, OOP, and
other web frameworks' best practices, while forming a coherent, one-way data flow for the entire request-response cycle.
I recommend reading the original Upgrow Architecture (next section) first for more context and better explanation,
but if you want to delve into the code/discussion/how we can apply this at EH, keep the Upgrow architecture diagram 
below open, and follow the READMEs and associated source files in the following order:

1. [app/records/README.md](app/records/README.md)
2. [app/repositories/README.md](app/repositories/README.md)
3. [app/models/README.md](app/models/README.md)
4. [app/actions/README.md](app/actions/README.md)
5. [app/inputs/README.md](app/inputs/README.md)
6. [app/controllers/README.md](app/controllers/README.md)

There are random thoughts sprinkled here and there in source files, <kbd>Ctrl+F</kbd> `# Discussion` should bring them up.
Feedback is welcome, either directly or GitHub Discussions or through PRs.

## Upgrow Architecture

![Upgrow](https://raw.githubusercontent.com/szTheory/upgrow/main/docs/images/diagram_3.jpg)

Originally available [here](https://upgrow.shopify.io/) and then taken down for unknown reasons, Upgrow sketches out
an alternative "sustainable architecture" for Ruby on Rails applications. The original documentation can be accessed 
following the index below:
1. [Introduction](https://github.com/szTheory/upgrow/blob/main/docs/guide/introduction.md)
2. [The Goal of Good Software Design](https://github.com/szTheory/upgrow/blob/main/docs/guide/the-goal-of-good-software-design.md)
3. [Code Smells in Rails Apps](https://github.com/szTheory/upgrow/blob/main/docs/guide/code-smells-in-rails-apps.md)
4. [Software Design Principles](https://github.com/szTheory/upgrow/blob/main/docs/guide/software-deisgn-principles.md)
5. [A Better Architecture](https://github.com/szTheory/upgrow/blob/main/docs/guide/a-better-architecture.md)
6. [The Missing Pieces](https://github.com/szTheory/upgrow/blob/main/docs/guide/the-missing-pieces.md)
7. [Extensions](https://github.com/szTheory/upgrow/blob/main/docs/guide/extensions.md)
8. [Caveats](https://github.com/szTheory/upgrow/blob/main/docs/guide/caveats.md)
9. [Final Words](https://github.com/szTheory/upgrow/blob/main/docs/guide/final-words.md)

## OpenFlights
OpenFlights is a simple CRUD app, allowing users to CRUD reviews for airlines. Only the back-end API is replicated here, 
since the front-end is not of Upgrow's concern.

The endpoint list is:
```
api_v1_airlines GET    /api/v1/airlines(.:format)       api/v1/airlines#index
                POST   /api/v1/airlines(.:format)       api/v1/airlines#create
 api_v1_airline GET    /api/v1/airlines/:slug(.:format) api/v1/airlines#show
                PATCH  /api/v1/airlines/:slug(.:format) api/v1/airlines#update
                PUT    /api/v1/airlines/:slug(.:format) api/v1/airlines#update
                DELETE /api/v1/airlines/:slug(.:format) api/v1/airlines#destroy
 api_v1_reviews POST   /api/v1/reviews(.:format)        api/v1/reviews#create
  api_v1_review DELETE /api/v1/reviews/:id(.:format)    api/v1/reviews#destroy
```

## Get Started
- Clone
- `bundle install`
- Replace postgres with sqlite in database.yml if preferred (and add sqlite3 into Gemfile), if not go ahead and 
  `rails db:create`, `rails db:migrate`, and `rails db:seed`
- `rails s` and the API is ready!  

## Notes
This section is just draft space for other patterns not included in Upgrow but worth learning/considering:
- Schema annotation in ActiveRecord models (Records): a goal of Rails 5's Attributes API and various model annotation gems,
  one place to easily see a model's attributes and relationships (like ROM, Hanami)
- Dependency injection: this is a contentious topic in the Rails community, so a lot more discussion required.
  https://dhh.dk/2012/dependency-injection-is-not-a-virtue.html
  
  https://solnic.codes/2013/12/17/the-world-needs-another-post-about-dependency-injection-in-ruby/
- Domain-driven directory structure: instead of grouping files by function (records into records dir, actions into 
  actions dir), group files of the same domain/business logic into one directory
- Minimize fat helpers, prefer layer-specific, single-responsibility helper
- ActiveSupport::Concern is concerning, then how to be DRY but explicit?
