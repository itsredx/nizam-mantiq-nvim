; Mantiq / Nizam — Neovim Tree-sitter Highlight Queries

; ── Comments ────────────────────────────────────────────────────────
(comment) @comment

; ── Literals ────────────────────────────────────────────────────────
(number) @number
(string) @string
(interpolated_str) @string.special
(boolean_literal) @boolean
(null_literal) @constant.builtin
(color_literal) @number
(self_reference) @variable.builtin

; ── Keywords — Declarations ──────────────────────────────────────────
[
  "fn" "class" "struct" "enum" "union" "interface" "type" "macro" "block"
] @keyword.type

(access_modifier) @keyword.modifier

; ── Keywords — Storage & Variables ──────────────────────────────────
["let" "var" "const"] @keyword

; ── Keywords — Control Flow ──────────────────────────────────────────
[
  "if" "elif" "else"
  "for" "while"
] @keyword.conditional

(kw_match) @keyword.conditional
(kw_case) @keyword.conditional
(kw_try) @keyword.conditional
(kw_except) @keyword.conditional
(kw_finally) @keyword.conditional
(kw_with) @keyword.conditional

["return" "break" "continue" "raise" "pass"] @keyword.return

; ── Keywords — Import ────────────────────────────────────────────────
["import" "from" "link"] @keyword.import

; ── Keywords — Operators (words) ────────────────────────────────────
(kw_and) @keyword.operator
(kw_or) @keyword.operator
(kw_not) @keyword.operator
(kw_is) @keyword.operator
(kw_in) @keyword.operator
(kw_to) @keyword.operator
"as" @keyword.operator

; ── Keywords — Modifiers ────────────────────────────────────────────
[
  "async" "inline" "static" "extern" "volatile" "atomic" "abstract" "final" "override"
  "public" "private" "protected" "internal"
  "mut"
] @keyword.modifier

(kw_unsafe) @keyword.modifier

; ── Keywords — Memory & Concurrency ──────────────────────────────────
["ref" "deref" "life"] @keyword.modifier
["spawn" "await"] @keyword.coroutine

; ── Identifier Fallback Matcher ──────────────────────────────────────
((identifier) @keyword
 (#match? @keyword "^(fn|public|private|internal|protected|var|let|const|struct|enum|interface|trait|impl|type|alias|as|to|mut|ref|deref|return|if|elif|else|while|loop|match|case|break|continue|defer|spawn|await|yield|unsafe|import|from|link|pass|raise|with|try|except|finally|size|ptr)$"))

; ── Definitions & Declarations ───────────────────────────────────────
(named_function
  (identifier) @function)

(struct_decl
  (identifier) @type.definition)

(enum_decl
  (identifier) @type.definition)

(union_decl
  (identifier) @type.definition)

(interface_decl
  (identifier) @type.definition)

(type_decl
  (identifier) @type.definition)

(enum_variant
  (identifier) @constant)

(var_decl
  (identifier) @variable)

(param_decl
  name: (identifier) @variable.parameter)

; ── Extern Declarations ──────────────────────────────────────────────
(extern_block
  "extern" @keyword.modifier
  tag: (identifier)? @keyword.type
  module: (string) @string)

(extern_block
  module: (identifier) @module)

(extern_fn_decl
  "extern" @keyword.modifier
  tag: (identifier)? @keyword.type
  module: (string) @string
  "fn" @keyword.type)

(extern_fn_decl
  module: (identifier) @module)

; ── Calls ────────────────────────────────────────────────────────────
(call_expression
  function: (primary (identifier) @function.call))

(call_expression
  function: (member_expression
    property: (identifier) @function.method.call))

(member_expression
  property: (identifier) @property)

(macro_invocation
  (identifier) @function.macro)

(macro_decl
  (identifier) @function.macro)

; ── Types ────────────────────────────────────────────────────────────
(type_annotation
  (identifier) @type)

(return_annotation
  (identifier) @type)

(type_list
  (identifier) @type)

((identifier) @type.builtin
 (#match? @type.builtin "^(i8|i16|i32|i64|i128|i256|i512|i1024|u8|u16|u32|u64|u128|u256|u512|u1024|isize|usize|f16|bf16|f32|f64|f128|f256|f512|bool|char|byte|str|cstr|webstr|asciistr|rangestr|utf8str|ptr|void|Any|String|Option|List|Dict|Set|Result|Codepoint|PyObject)$"))

; ── Import Paths & Decorators ────────────────────────────────────────
(module_path
  (identifier) @module)

(decorator
  "@" @attribute
  (identifier) @attribute)

; ── Operators & Punctuation ──────────────────────────────────────────
(assign_op) @operator

[
  "+" "-" "*" "/" "%" "**"
  "==" "!=" "<" ">" "<=" ">="
  "<<" ">>"
  "&" "|" "^" "~"
  "!" ".." "??"
] @operator

["=>" "->"] @keyword.operator

["(" ")" "[" "]" "{" "}"] @punctuation.bracket
["," "." "?." ":"] @punctuation.delimiter
["..." "@"] @punctuation.special

"super" @variable.builtin
