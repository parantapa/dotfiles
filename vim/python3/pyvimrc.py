"""Misc python entities used from vimrc."""

import vim
import re
from pathlib import Path
from subprocess import run

try:
    import yaml
except ImportError:
    yaml = None

# Liberal Regex Pattern for Web URLs
# https://gist.github.com/gruber/8891611
WEB_URL_RE = re.compile("""
\\b
( # Capture 1: entire matched URL
    (?:
        https?: # URL protocol and colon
        (?:
            /{1,3} # 1-3 slashes
            | #   or
            [a-z0-9%] # Single letter or digit or '%'
                      # (Trying not to match e.g. "URI::Escape")
        )
        | # or
        [a-z0-9.\-]+[.](?:[a-z]{2,13}) # looks like domain name followed by a slash
        /
    )
    (?: # One or more:
        [^\s()<>{}\[\]]+ # Run of non-space, non-()<>{}[]
        | # or
        \([^\s()]*?\([^\s()]+\)[^\s()]*?\) # balanced parens, one level deep: (…(…)…)
        |
        \([^\s]+?\) # balanced parens, non-recursive: (…)
    )+
    (?: # End with:
        \([^\s()]*?\([^\s()]+\)[^\s()]*?\) # balanced parens, one level deep: (…(…)…)
        |
        \([^\s]+?\) # balanced parens, non-recursive: (…)
        |
        [^\s`!()\[\]{};:'".,<>?«»“”‘’] # not a space or one of these punct chars
    )
    | # OR, the following to match naked domains:
    (?:
        (?<!@) # not preceded by a @, avoid matching foo@_gmail.com_
        [a-z0-9]+
        (?:[.\-][a-z0-9]+)*
        [.]
        (?:[a-z]{2,13})
        \\b
        /?
        (?!@) # not succeeded by a @, avoid matching "foo.na" in "foo.na@example.com"
    )
)
""".strip(), re.I | re.X)

def extract_url(text):
    """Extract url from text."""

    urls = WEB_URL_RE.findall(text)
    ret = urls[0] if urls else ""
    return ret

def rename_current_file(new_name):
    """Rename current file."""
    cur_path = Path(vim.eval("@%"))
    new_path = cur_path.parent / new_name
    run(["mv", str(cur_path), str(new_path)], check=True)
