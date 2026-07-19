import codegen/internal/highlight

// --- Gleam -------------------------------------------------------------------

pub fn gleam_string_test() {
  assert highlight.gleam_to_html("\"hi\"")
    == "<span class=\"text-syntax-literal\">\"hi\"</span>"
}

pub fn gleam_number_test() {
  assert highlight.gleam_to_html("1.5")
    == "<span class=\"text-syntax-literal\">1.5</span>"
}

pub fn gleam_comment_test() {
  assert highlight.gleam_to_html("// c")
    == "<span class=\"text-syntax-comment italic\">// c</span>"
}

pub fn gleam_operator_test() {
  assert highlight.gleam_to_html("a <> b")
    == "a <span class=\"text-syntax-operator\">&lt;&gt;</span> b"
}

pub fn gleam_type_test() {
  assert highlight.gleam_to_html("Option")
    == "<span class=\"text-syntax-type\">Option</span>"
}

pub fn gleam_boolean_test() {
  assert highlight.gleam_to_html("True")
    == "<span class=\"text-syntax-boolean\">True</span>"
  assert highlight.gleam_to_html("False")
    == "<span class=\"text-syntax-boolean\">False</span>"
}

pub fn gleam_function_and_brackets_test() {
  assert highlight.gleam_to_html("fn f() {}")
    == "<span class=\"text-syntax-keyword\">fn</span> "
    <> "<span class=\"text-syntax-function\">f</span>"
    <> "<span class=\"text-syntax-punctuation\">(</span>"
    <> "<span class=\"text-syntax-punctuation\">)</span> "
    <> "<span class=\"text-syntax-punctuation\">{</span>"
    <> "<span class=\"text-syntax-punctuation\">}</span>"
}

pub fn gleam_dot_and_comma_test() {
  assert highlight.gleam_to_html("a.b(c, d)")
    == "<span class=\"text-syntax-type\">a</span>"
    <> "<span class=\"text-syntax-punctuation\">.</span>"
    <> "<span class=\"text-syntax-function\">b</span>"
    <> "<span class=\"text-syntax-punctuation\">(</span>"
    <> "c<span class=\"text-syntax-punctuation\">,</span> d"
    <> "<span class=\"text-syntax-punctuation\">)</span>"
}

pub fn gleam_html_escape_test() {
  assert highlight.gleam_to_html("\"<&>\"")
    == "<span class=\"text-syntax-literal\">\"&lt;&amp;&gt;\"</span>"
}

pub fn gleam_empty_test() {
  assert highlight.gleam_to_html("") == ""
}

// --- JavaScript --------------------------------------------------------------

pub fn javascript_string_test() {
  assert highlight.javascript_to_html("\"hi\"")
    == "<span class=\"text-syntax-literal\">\"hi\"</span>"
}

pub fn javascript_template_plain_test() {
  assert highlight.javascript_to_html("`abc`")
    == "<span class=\"text-syntax-literal\">`abc`</span>"
}

pub fn javascript_template_one_interpolation_test() {
  assert highlight.javascript_to_html("`a${b}c`")
    == "<span class=\"text-syntax-literal\">`a</span>"
    <> "<span class=\"text-syntax-operator\">"
    <> "${</span>b<span class=\"text-syntax-operator\">}</span>"
    <> "<span class=\"text-syntax-literal\">c`</span>"
}

pub fn javascript_template_leading_interpolation_test() {
  assert highlight.javascript_to_html("`${x}`")
    == "<span class=\"text-syntax-literal\">`</span>"
    <> "<span class=\"text-syntax-operator\">${</span>"
    <> "x<span class=\"text-syntax-operator\">}</span>"
    <> "<span class=\"text-syntax-literal\">`</span>"
}

pub fn javascript_template_two_interpolations_test() {
  assert highlight.javascript_to_html("`a${b}c${d}e`")
    == "<span class=\"text-syntax-literal\">`a</span>"
    <> "<span class=\"text-syntax-operator\">${</span>"
    <> "b<span class=\"text-syntax-operator\">}</span>"
    <> "<span class=\"text-syntax-literal\">c</span>"
    <> "<span class=\"text-syntax-operator\">${</span>"
    <> "d<span class=\"text-syntax-operator\">}</span>"
    <> "<span class=\"text-syntax-literal\">e`</span>"
}

pub fn javascript_template_adjacent_interpolations_test() {
  assert highlight.javascript_to_html("`${x}${y}`")
    == "<span class=\"text-syntax-literal\">`</span>"
    <> "<span class=\"text-syntax-operator\">${</span>"
    <> "x<span class=\"text-syntax-operator\">}</span>"
    <> "<span class=\"text-syntax-operator\">${</span>"
    <> "y<span class=\"text-syntax-operator\">}</span>"
    <> "<span class=\"text-syntax-literal\">`</span>"
}

pub fn javascript_number_test() {
  assert highlight.javascript_to_html("42")
    == "<span class=\"text-syntax-literal\">42</span>"
}

pub fn javascript_comment_test() {
  assert highlight.javascript_to_html("// c")
    == "<span class=\"text-syntax-comment italic\">// c</span>"
}

pub fn javascript_function_test() {
  assert highlight.javascript_to_html("function f() {}")
    == "<span class=\"text-syntax-keyword\">function</span>"
    <> " <span class=\"text-syntax-function\">f</span>"
    <> "<span class=\"text-syntax-punctuation\">(</span>"
    <> "<span class=\"text-syntax-punctuation\">)</span> "
    <> "<span class=\"text-syntax-punctuation\">{</span>"
    <> "<span class=\"text-syntax-punctuation\">}</span>"
}

pub fn javascript_class_test() {
  assert highlight.javascript_to_html("class C {}")
    == "<span class=\"text-syntax-keyword\">class</span>"
    <> " <span class=\"text-syntax-type\">C</span> "
    <> "<span class=\"text-syntax-punctuation\">{</span>"
    <> "<span class=\"text-syntax-punctuation\">}</span>"
}

pub fn javascript_operator_test() {
  assert highlight.javascript_to_html("a + b")
    == "a <span class=\"text-syntax-operator\">+</span> b"
}

pub fn javascript_regexp_test() {
  assert highlight.javascript_to_html("/x/g")
    == "<span class=\"text-syntax-literal\">/x/g</span>"
}

pub fn javascript_html_escape_test() {
  assert highlight.javascript_to_html("\"<&>\"")
    == "<span class=\"text-syntax-literal\">\"&lt;&amp;&gt;\"</span>"
}

pub fn javascript_empty_test() {
  assert highlight.javascript_to_html("") == ""
}

// --- CSS ---------------------------------------------------------------------

pub fn css_at_rule_test() {
  assert highlight.css_to_html("@media screen {}")
    == "<span class=\"text-syntax-keyword\">@media</span> "
    <> "<span class=\"text-syntax-keyword\">screen</span> "
    <> "<span class=\"text-syntax-punctuation\">{</span>"
    <> "<span class=\"text-syntax-punctuation\">}</span>"
}

pub fn css_function_test() {
  assert highlight.css_to_html("a { width: calc(1px); }")
    == "<span class=\"text-syntax-function\">a</span> "
    <> "<span class=\"text-syntax-punctuation\">{</span> "
    <> "<span class=\"text-syntax-keyword\">width</span>"
    <> "<span class=\"text-syntax-punctuation\">:</span> "
    <> "<span class=\"text-syntax-function\">calc</span>"
    <> "<span class=\"text-syntax-punctuation\">(</span>"
    <> "<span class=\"text-syntax-literal\">1</span>"
    <> "<span class=\"text-syntax-operator\">px</span>"
    <> "<span class=\"text-syntax-punctuation\">)</span>"
    <> "<span class=\"text-syntax-punctuation\">;</span> "
    <> "<span class=\"text-syntax-punctuation\">}</span>"
}

pub fn css_variable_test() {
  assert highlight.css_to_html("a { color: var(--x); }")
    == "<span class=\"text-syntax-function\">a</span> "
    <> "<span class=\"text-syntax-punctuation\">{</span> "
    <> "<span class=\"text-syntax-keyword\">color</span>"
    <> "<span class=\"text-syntax-punctuation\">:</span> "
    <> "<span class=\"text-syntax-function\">var</span>"
    <> "<span class=\"text-syntax-punctuation\">(</span>"
    <> "<span class=\"text-syntax-keyword\">--x</span>"
    <> "<span class=\"text-syntax-punctuation\">)</span>"
    <> "<span class=\"text-syntax-punctuation\">;</span> "
    <> "<span class=\"text-syntax-punctuation\">}</span>"
}

pub fn css_hash_disambiguation_test() {
  assert highlight.css_to_html("#foo { color: #fff; }")
    == "<span class=\"text-syntax-function\">#foo</span> "
    <> "<span class=\"text-syntax-punctuation\">{</span> "
    <> "<span class=\"text-syntax-keyword\">color</span>"
    <> "<span class=\"text-syntax-punctuation\">:</span> "
    <> "<span class=\"text-syntax-literal\">#fff</span>"
    <> "<span class=\"text-syntax-punctuation\">;</span> "
    <> "<span class=\"text-syntax-punctuation\">}</span>"
}

pub fn css_comment_test() {
  assert highlight.css_to_html("/* c */")
    == "<span class=\"text-syntax-comment italic\">/* c */</span>"
}

pub fn css_html_escape_test() {
  assert highlight.css_to_html("a { content: \"<&>\"; }")
    == "<span class=\"text-syntax-function\">a</span> "
    <> "<span class=\"text-syntax-punctuation\">{</span> "
    <> "<span class=\"text-syntax-keyword\">content</span>"
    <> "<span class=\"text-syntax-punctuation\">:</span> "
    <> "<span class=\"text-syntax-literal\">\"&lt;&amp;&gt;\"</span>"
    <> "<span class=\"text-syntax-punctuation\">;</span> "
    <> "<span class=\"text-syntax-punctuation\">}</span>"
}

pub fn css_empty_test() {
  assert highlight.css_to_html("") == ""
}

// --- Tailwind CSS @apply Utility Merging -------------------------------------

pub fn apply_opacity_modifier_fuses_test() {
  assert highlight.css_to_html("a { @apply bg-primary/10; }")
    == "<span class=\"text-syntax-function\">a</span> "
    <> "<span class=\"text-syntax-punctuation\">{</span> "
    <> "<span class=\"text-syntax-keyword\">@apply</span> "
    <> "<span class=\"text-syntax-keyword\">bg-primary/10</span>"
    <> "<span class=\"text-syntax-punctuation\">;</span> "
    <> "<span class=\"text-syntax-punctuation\">}</span>"
}

pub fn apply_important_marker_fuses_test() {
  assert highlight.css_to_html("a { @apply text-sm!; }")
    == "<span class=\"text-syntax-function\">a</span> "
    <> "<span class=\"text-syntax-punctuation\">{</span> "
    <> "<span class=\"text-syntax-keyword\">@apply</span> "
    <> "<span class=\"text-syntax-keyword\">text-sm!</span>"
    <> "<span class=\"text-syntax-punctuation\">;</span> "
    <> "<span class=\"text-syntax-punctuation\">}</span>"
}

pub fn apply_fraction_fuses_test() {
  assert highlight.css_to_html("a { @apply w-1/2; }")
    == "<span class=\"text-syntax-function\">a</span> "
    <> "<span class=\"text-syntax-punctuation\">{</span> "
    <> "<span class=\"text-syntax-keyword\">@apply</span> "
    <> "<span class=\"text-syntax-keyword\">w-1/2</span>"
    <> "<span class=\"text-syntax-punctuation\">;</span> "
    <> "<span class=\"text-syntax-punctuation\">}</span>"
}

pub fn apply_variant_separator_recolours_test() {
  assert highlight.css_to_html("a { @apply hover:bg-primary; }")
    == "<span class=\"text-syntax-function\">a</span> "
    <> "<span class=\"text-syntax-punctuation\">{</span> "
    <> "<span class=\"text-syntax-keyword\">@apply</span> "
    <> "<span class=\"text-syntax-keyword\">hover</span>"
    <> "<span class=\"text-syntax-keyword\">:bg-primary</span>"
    <> "<span class=\"text-syntax-punctuation\">;</span> "
    <> "<span class=\"text-syntax-punctuation\">}</span>"
}

pub fn apply_compound_variant_recolours_test() {
  assert highlight.css_to_html("a { @apply has-checked:bg-primary; }")
    == "<span class=\"text-syntax-function\">a</span> "
    <> "<span class=\"text-syntax-punctuation\">{</span> "
    <> "<span class=\"text-syntax-keyword\">@apply</span> "
    <> "<span class=\"text-syntax-keyword\">has-checked</span>"
    <> "<span class=\"text-syntax-keyword\">:bg-primary</span>"
    <> "<span class=\"text-syntax-punctuation\">;</span> "
    <> "<span class=\"text-syntax-punctuation\">}</span>"
}

pub fn apply_arbitrary_value_does_not_fuse_test() {
  assert highlight.css_to_html("a { @apply bg-[#fff]; }")
    == "<span class=\"text-syntax-function\">a</span> "
    <> "<span class=\"text-syntax-punctuation\">{</span> "
    <> "<span class=\"text-syntax-keyword\">@apply</span> "
    <> "<span class=\"text-syntax-keyword\">bg-</span>"
    <> "<span class=\"text-syntax-punctuation\">[</span>"
    <> "<span class=\"text-syntax-punctuation\">#fff</span>"
    <> "<span class=\"text-syntax-punctuation\">]</span>"
    <> "<span class=\"text-syntax-punctuation\">;</span> "
    <> "<span class=\"text-syntax-punctuation\">}</span>"
}

pub fn apply_arbitrary_variant_bracket_depth_test() {
  assert highlight.css_to_html("a { @apply [&:hover]:w-full; }")
    == "<span class=\"text-syntax-function\">a</span> "
    <> "<span class=\"text-syntax-punctuation\">{</span> "
    <> "<span class=\"text-syntax-keyword\">@apply</span> "
    <> "<span class=\"text-syntax-punctuation\">[</span>"
    <> "<span class=\"text-syntax-function\">&amp;</span>:hover"
    <> "<span class=\"text-syntax-punctuation\">]</span>"
    <> "<span class=\"text-syntax-keyword\">:w-full</span>"
    <> "<span class=\"text-syntax-punctuation\">;</span> "
    <> "<span class=\"text-syntax-punctuation\">}</span>"
}

pub fn apply_resets_on_semicolon_test() {
  assert highlight.css_to_html("a { @apply w-1/2; color: red; }")
    == "<span class=\"text-syntax-function\">a</span> "
    <> "<span class=\"text-syntax-punctuation\">{</span> "
    <> "<span class=\"text-syntax-keyword\">@apply</span> "
    <> "<span class=\"text-syntax-keyword\">w-1/2</span>"
    <> "<span class=\"text-syntax-punctuation\">;</span> "
    <> "<span class=\"text-syntax-keyword\">color</span>"
    <> "<span class=\"text-syntax-punctuation\">:</span> "
    <> "<span class=\"text-syntax-keyword\">red</span>"
    <> "<span class=\"text-syntax-punctuation\">;</span> "
    <> "<span class=\"text-syntax-punctuation\">}</span>"
}

pub fn apply_resets_on_brace_test() {
  assert highlight.css_to_html("a { @apply w-1/2 } .b:hover {}")
    == "<span class=\"text-syntax-function\">a</span> "
    <> "<span class=\"text-syntax-punctuation\">{</span> "
    <> "<span class=\"text-syntax-keyword\">@apply</span> "
    <> "<span class=\"text-syntax-keyword\">w-1/2</span> "
    <> "<span class=\"text-syntax-punctuation\">}</span> "
    <> "<span class=\"text-syntax-function\">.b</span>:hover "
    <> "<span class=\"text-syntax-punctuation\">{</span>"
    <> "<span class=\"text-syntax-punctuation\">}</span>"
}
