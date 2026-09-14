; Mantiq / Nizam — Indentation Queries
; =============================================================================

; Indent after block-opening colon
(block_body) @indent.begin
(enum_body) @indent.begin

; Dedent at end of block
(block_body) @indent.end
(enum_body) @indent.end

; Indent branches
(if_stmt ":" @indent.begin)
(for_stmt ":" @indent.begin)
(while_stmt ":" @indent.begin)
(match_case ":" @indent.begin)
(try_stmt ":" @indent.begin)
(with_stmt ":" @indent.begin)

; Function/class/struct bodies
(named_function ":" @indent.begin)
(anonymous_function ":" @indent.begin)
(class_decl ":" @indent.begin)
(struct_decl ":" @indent.begin)
(enum_decl ":" @indent.begin)
(union_decl ":" @indent.begin)
(interface_decl ":" @indent.begin)
(macro_decl ":" @indent.begin)
(extern_block ":" @indent.begin)

