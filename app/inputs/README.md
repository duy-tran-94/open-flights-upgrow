## What?
**Inputs** are objects that hold user-entered data (no ID) and its constraints. It uses ActiveModel validation helpers 
to perform the validation often done in ActiveRecord, saving time and cycles on invalid inputs.

## Why?

See the Why section in README in `app/actions`

## Discussion
The case for adopting **Inputs** may not be that strong. In the main app, Grape is used for input
validation, which means validation logic would stay in **Controllers**. This is probably sufficient for most cases.
Even if we don't use Grape, Upgrow's use of ActiveModel validation helpers could be replaced by other gems, 
e.g. dry-validation, dry-schema, which also includes type checking.

Upgrow also does not address input transformation (say, helpers that modify input values), but the use case for this
is probably not huge.


