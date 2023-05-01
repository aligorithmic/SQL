-- Postgres JSONB Syntax
----------
-- NOTE: The notation in JSONPath differs from Postgres operators for manipulating JSON and from the notation of JSQuery.
-- The hierarchy is denoted by dots:
-- $.a.b.c (in the notation of Postgres 11 we would have it as 'a'->'b'->'c');
----------
-- PostgreSQL has two native operators -> and ->> to query JSON documents.
-- The first operator -> returns a JSON object, while the operator ->> returns text.
-- These operators work on both JSON as well as JSONB columns.

-- Because the -> operator returns an object, you can chain it to inspect deep into a JSON document.
SELECT rule_template -> '$parameters' -> 'THICKNESS' ->> 'path'
FROM graph1.rule_templates;

-- The containment operator @> tests whether one document contains another.

-- Use the JSONB existence operator ? to check if a string exists as a top-level key.
SELECT rule_template -> '$parameters' ? 'THICKNESS'
FROM graph1.rule_templates;

-- FUNCTIONS: jsonb_each, jsonb_object_keys, jsonb_extract_path, jsonb_pretty
-- Expands the top-level JSON document into a set of key-value pairs.
SELECT jsonb_each(rule_template) FROM graph1.rule_templates;

-- Returns the keys of the top-level JSON document.
SELECT id, jsonb_object_keys(rule_template) FROM graph1.rule_templates;

-- Returns a JSON object that is traversed by a "path".
SELECT id, jsonb_extract_path(rule_template, '$parameters', 'THICKNESS', 'path')
FROM graph1.rule_templates;

-- By default, PostgreSQL returns a compact representation which works for machineconsumption.
-- If you want your JSON documents pretty printed for human consumption, use this function:
SELECT jsonb_pretty( '{"name": "Alice", "agent": {"bot": true} }'::jsonb );

-- Removing a key/value from a jsonb object is very simple, just use the subtraction operator:
SELECT '{"a": 1, "b": 2}'::jsonb - 'a';

-- Update JSON value:
jsonb_set(target jsonb, path text[], new_value jsonb, [create_missing boolean])
-- Returns target with the section designated by path replaced by new_value, or with new_value added if create_missing
-- is true (default is true) and the item designated by path does not exist. As with the path oriented operators,
-- negative integers that appear in path count from the end of JSON arrays.
UPDATE "Example" SET "details"=jsonb_set("details"::jsonb, '{url}', '"images/0001.jpg"'
WHERE "details"::json->>'name'='Eiffel Tower';

----------------------
Operator : Description
->  Get JSON array element (indexed from zero, negative integers count from the end)
->  Get JSON object field by key
->> Get JSON array element as text
->> Get JSON object field as text
#>  Get JSON object at the specified path
#>> Get JSON object at the specified path as text
@>  Does the left JSON value contain the right JSON path/value entries at the top level?
<@  Are the left JSON path/value entries contained at the top level within the right JSON value?
?   Does the string exist as a top-level key within the JSON value?
?|  Do any of these array strings exist as top-level keys?
?&  Do all of these array strings exist as top-level keys?
||  Concatenate two jsonb values into a new jsonb value
-   Delete key/value pair or string element from left operand. Key/value pairs are matched based on their key value.
-   Delete multiple key/value pairs or string elements from left operand. Key/value pairs are matched based on their key value.
-   Delete the array element with specified index (Negative integers count from the end). Throws an error if top level container is not an array.
#-  Delete the field or element with specified path (for JSON arrays, negative integers count from the end)
@?  Does JSON path return any item for the specified JSON value?
@@  Returns the result of JSON path predicate check for the specified JSON value. Only the first item of the result is taken into account. If the result is not Boolean, then null is returned.

