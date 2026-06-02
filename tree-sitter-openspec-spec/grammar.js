/// <reference types="tree-sitter-cli/dsl" />
// @ts-check

module.exports = grammar({
  name: "openspec_spec",

  extras: (_) => [/\s/],

  // Use word boundaries for keyword extraction
  word: ($) => $.word,

  rules: {
    document: ($) =>
      repeat(
        choice(
          $.delta_section,
          $.requirement,
          $.title,
        ),
      ),

    title: (_) => token(seq("#", / [^\n]+/)),

    delta_section: ($) =>
      prec.right(
        seq(
          $.delta_header,
          repeat($.requirement),
        ),
      ),

    delta_header: (_) =>
      token(
        seq(
          "## ",
          choice("ADDED", "MODIFIED", "REMOVED", "RENAMED"),
          " Requirements",
        ),
      ),

    requirement: ($) =>
      prec.right(
        seq(
          "### Requirement:",
          $.requirement_name,
          optional($.requirement_body),
          repeat($.scenario),
        ),
      ),

    requirement_name: (_) => /[^\n]+/,

    requirement_body: ($) =>
      prec.right(
        repeat1(
          choice(
            $.keyword,
            $.word,
            $._punctuation,
          ),
        ),
      ),

    keyword: ($) =>
      prec(
        2,
        choice(
          seq("SHALL", "NOT"),
          seq("MUST", "NOT"),
          "SHALL",
          "MUST",
        ),
      ),

    // The word token: any sequence of non-whitespace that isn't a keyword
    // or structural marker
    word: (_) => /[a-zA-Z][a-zA-Z0-9_-]*/,

    _punctuation: (_) => /[^a-zA-Z\s#][^\s#]*/,

    scenario: ($) =>
      prec.right(
        seq(
          "#### Scenario:",
          $.scenario_name,
          repeat(
            choice(
              $.condition,
              $.assertion,
              $.continuation,
            ),
          ),
        ),
      ),

    scenario_name: (_) => /[^\n]+/,

    condition: ($) =>
      seq(
        optional($._bold_marker),
        alias("WHEN", $.condition_keyword),
        optional($._bold_end),
        /[^\n]+/,
      ),

    assertion: ($) =>
      seq(
        optional($._bold_marker),
        alias("THEN", $.assertion_keyword),
        optional($._bold_end),
        /[^\n]+/,
      ),

    continuation: ($) =>
      seq(
        optional($._bold_marker),
        alias("AND", $.continuation_keyword),
        optional($._bold_end),
        /[^\n]+/,
      ),

    _bold_marker: (_) => token(seq("-", / /, "**")),
    _bold_end: (_) => "**",
  },
});
