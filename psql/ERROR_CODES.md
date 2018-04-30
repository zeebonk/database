# ERRCODE lookup

Security/permissions:

* `SECPD` - 'permissions' value was invalid - wrong number of dimensions
* `SECPX` - 'permissions' value was invalid - permission doesn't exist

## Rules

To avoid conflicting with built in PostgreSQL error codes, we use these rules:

* Start with a capital letter but not F (predefined config file errors), H (fdw), P (PL/pgSQL) or X (internal).
* Do not use 0 (zero) or P in the 3rd column. Predefined error codes use these commonly.
* Use a capital letter in the 4th position. No predefined error codes have this.

Or, re-written for each character:

1. [A-Z] except F, H, P, X
2. [A-Z0-9]
3. [A-Z0-9] except 0 (zero), P
4. [A-Z]
5. [A-Z0-9]

Source: https://stackoverflow.com/questions/22594395/custom-error-code-class-range-in-postgresql
