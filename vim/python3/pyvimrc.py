# encoding: utf-8
"""
Misc python entities used from vimrc
"""

import vim
import re

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

def bookmark_fold_text(fstart, fend, flevel):
    """
    Return a fold text for bookmark yaml display.
    """

    fstart = int(fstart)
    fend = int(fend)
    flevel = int(flevel)
    buf = vim.current.buffer

    if flevel != 1:
        return "--"

    if yaml is None:
        return "--"

    text = "\n".join(buf[fstart -1:fend])
    bmark = yaml.load(text)
    ret = bmark[0]["title"].strip()
    return ret

def extract_url(text):
    """
    Extract url from text.
    """

    urls = WEB_URL_RE.findall(text)
    ret = urls[0] if urls else ""
    return ret

