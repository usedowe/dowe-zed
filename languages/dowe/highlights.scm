(import_statement (import_keyword) @keyword (from_keyword) @keyword)
(import_statement (identifier) @variable)
(import_path) @string
(type_declaration (type_keyword) @keyword (type_name) @type)
(translation_root "translations" @keyword)
(translation_entry_line "translation" @keyword)
(translation_key_line name: (identifier) @property)
(node_line name: (line_name (root_keyword) @keyword))
(node_line name: (line_name (block_keyword) @keyword))
(node_line name: (line_name (control_keyword) @keyword))
(node_line
  name: (line_name (fn_keyword) @keyword)
  (#match? @keyword "^(database|cache|vector|queue)$"))
(node_line
  name: (line_name (fn_keyword) @function)
  (#not-match? @function "^(database|cache|vector|queue)$"))
(node_line name: (callable_name (identifier) @function))
(type_prop (type_keyword) @keyword (type_reference) @type)
(body_type_binding (body_keyword) @variable (type_reference) @type)
(type_field (type_field_key) @property)
(type_field (type_reference) @type)
(array_type_reference) @type
(host_function) @function
(node_line name: (line_name (component_name) @constructor))
(node_line name: (line_name (user_component_name) @constructor))
(prop (property_name) @property)
(code_property_line (property_name) @property)
(object_entry (property_name) @property)
(value (identifier) @variable)
(value (property_name) @variable)
(text_line) @string
(text_line (text_token (reference) @variable))
(text_fragment) @string
(string) @string
(multiline_string) @string
(number) @number
(boolean) @boolean
(null) @constant.builtin
(reference) @variable
(method_name) @constant
(path_literal) @string.special
(punctuation) @punctuation.delimiter
(suite_marker) @punctuation.delimiter
