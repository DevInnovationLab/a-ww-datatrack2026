"""Render session4_slide_content.md as a reveal.js deck for review.

Usage:  python3 presentations/build_session4_slides.py
Output: presentations/session4_slides.html

Style follows the DIL reveal.js theme used in
github.com/DevInnovationLab/trainings-public/tree/main/rp-workshop
(dist/theme/dil.css): light grey background, Montserrat headings in
maroon, maroon section dividers, gold exercise slides.
The page adds a review panel with each slide's timing, flags and speaker
notes. Re-run the script after editing the markdown.

Slide types, from the "## Slide N — <title> · <timing>" headings:
  Title, Section divider        special layouts
  EXERCISE ... / SPOT THE ...   gold background (participants work)
  DEMO ...                      light-gold background (facilitator on screen,
                                e.g. slide 19c, the GitHub -> Overleaf demo)
  ... solved / ... revealed     solution slide: "SOLUTION" tag, compact code
                                and tables (e.g. 13 Five bugs, revealed;
                                19b Exercise 2, solved)
  anything else                 regular content slide
Slide labels can carry a letter suffix (e.g. "Slide 19a") for slides
inserted between existing ones.

Two columns (e.g. Stata next to R): put these HTML comments on their own
lines, with blank lines around them. They are invisible when the markdown is
read as plain text.
  <!-- columns -->      ...left column...
  <!-- next column -->  ...right column...
  <!-- end columns -->
"""

import base64
import html
import re
from pathlib import Path

HERE = Path(__file__).parent
SRC = HERE / "session4_slide_content.md"
OUT = HERE / "session4_slides.html"
LOGO = HERE / "img" / "DIL_logo.svg"

HEADER = "DATA ANALYSIS: CONSTRUCTION &amp; EXPLORATION"
FOOTER = ("Development Innovation Lab / University of Chicago · "
          "Data analysis: Construction &amp; Exploration")


def split_slides(text):
    """Return (todo_lines, [(heading, body_lines)]), ignoring fenced code."""
    lines = text.split("\n")
    todos, slides, cur, in_fence, section = [], [], None, False, None
    for line in lines:
        if line.lstrip("> ").startswith("```"):
            in_fence = not in_fence
        if not in_fence and re.match(r"^## (Slides? |Appendix)", line):
            cur = (line[3:].strip(), [])
            slides.append(cur)
            section = "slide"
            continue
        if not in_fence and line.startswith("## To-dos"):
            section = "todo"
            continue
        if section == "todo":
            if line.strip() == "---":
                section = None
            else:
                todos.append(line)
        elif section == "slide":
            cur[1].append(line)
    return todos, slides


def parse_heading(heading):
    label, _, rest = heading.partition(" — ")
    flags = re.findall(r"\*\*\(([^)]*)\)\*\*", rest)
    rest = re.sub(r"\s*\*\*\([^)]*\)\*\*", "", rest).strip()
    parts = [p.strip() for p in rest.split(" · ")]
    title_parts, timing_parts = [], []
    for p in parts:
        if timing_parts or re.match(r"^(\d+(\.\d+)? min|\*\(part of)", p):
            timing_parts.append(p)
        else:
            title_parts.append(p)
    title = " · ".join(title_parts)
    timing = " · ".join(timing_parts).replace("*", "")
    return label, title, timing, flags


def minutes(timing):
    if timing.startswith("(part of"):
        return 0.0
    return sum(float(m) for m in re.findall(r"(\d+(?:\.\d+)?) min", timing))


def split_notes(body):
    content, notes = [], []
    for line in body:
        if line.startswith(">"):
            notes.append(re.sub(r"^> ?", "", line))
        else:
            content.append(line)
    while content and content[-1].strip() in ("", "---"):
        content.pop()
    note_md = "\n".join(notes).strip()
    note_md = re.sub(r"^\*\*Notes:\*\*\s*", "", note_md, flags=re.M)
    return "\n".join(content).strip(), note_md


def md_section(content_md, notes_md, attrs=""):
    body = content_md
    if notes_md:
        body += "\n\nNote:\n" + notes_md
    return (f'<section data-markdown data-separator="^=====NOSPLIT=====$" '
            f'data-separator-notes="^Note:"{attrs}>'
            f'<textarea data-template>\n{html.escape(body, quote=False)}\n'
            f'</textarea></section>')


def meta_attrs(label, title, timing, flags, start):
    return (f' data-label="{html.escape(label)}"'
            f' data-title="{html.escape(title)}"'
            f' data-timing="{html.escape(timing)}"'
            f' data-start="{start:g}"'
            f' data-flags="{html.escape(" | ".join(flags))}"')


def inline(md):
    s = html.escape(md, quote=False)
    s = re.sub(r"\*\*(.+?)\*\*", r"<b>\1</b>", s)
    s = re.sub(r"\*(.+?)\*", r"<em>\1</em>", s)
    return s


def columns(md):
    """Turn the column markers into a two-column grid (see the docstring)."""
    md = md.replace("<!-- columns -->", '<div class="cols"><div class="col">\n')
    md = md.replace("<!-- next column -->", '\n</div><div class="col">\n')
    return md.replace("<!-- end columns -->", "\n</div></div>")


def build():
    todos, slides = split_slides(SRC.read_text())
    if LOGO.exists():
        logo_html = ('<img class="logo" src="data:image/svg+xml;base64,'
                     f'{base64.b64encode(LOGO.read_bytes()).decode()}" alt="DIL logo">')
    else:
        print(f"Note: {LOGO} not found; the title slide shows text instead of the logo.")
        logo_html = '<p class="logo-text">Development Innovation Lab</p>'

    sections, clock = [], 0.0
    for heading, body in slides:
        label, title, timing, flags = parse_heading(heading)
        content, notes = split_notes(body)
        attrs = meta_attrs(label, title, timing, flags, clock)
        clock += minutes(timing)

        if title == "Title":
            lines = [l for l in content.split("\n") if l.strip()]
            kicker = next((l for l in lines if l.startswith("**")), "")
            h1 = next(l for l in lines if l.startswith("# "))[2:]
            sub = next((l for l in lines
                        if l.startswith("*") and not l.startswith("**")), "")
            rest = [l for l in lines
                    if l not in (kicker, sub) and not l.startswith("# ")]
            parts = [
                f'<section class="title-slide"{attrs}>',
                logo_html,
            ]
            if kicker:
                parts.append(f'<p class="kicker">{inline(kicker)}</p>')
            parts.append(f'<h1>{inline(h1)}</h1>')
            if sub:
                parts.append(f'<p class="subtitle">{inline(sub)}</p>')
            parts += [f'<p class="byline">{inline(l)}</p>' for l in rest]
            parts.append(f'<aside class="notes" data-markdown-notes>'
                         f'{html.escape(notes)}</aside></section>')
            sections.append("".join(parts))
        elif title == "Section divider":
            lines = [l for l in content.split("\n") if l.strip()]
            num, _, name = lines[0].strip("*").partition(" · ")
            sections.append(
                f'<section class="divider" data-background="#80001E"{attrs}>'
                f'<p class="section-num">{inline(num)}</p>'
                f'<h2>{inline(name)}</h2>'
                + "".join(f'<p class="divider-sub">{inline(l)}</p>' for l in lines[1:])
                + '</section>')
        else:
            is_ex = bool(re.match(r"^(EXERCISE|SPOT THE)", title))
            is_demo = title.startswith("DEMO")
            cls = ' data-background="#faa319" class="exercise"' if is_ex else ""
            if is_demo:
                cls = ' data-background="#fde8c2" class="demo"'
            if re.search(r"\b(solved|revealed)\b", title, re.I):
                cls = ' class="solution"'
            if label.startswith("Appendix"):
                cls = ' class="appendix"'
            md = f"## {title}\n\n{columns(content)}"
            sections.append(md_section(md, notes, cls + attrs))

    todo_md = "## Draft to-dos\n\n" + "\n".join(todos).strip()
    sections.append(md_section(
        todo_md, "", ' class="appendix todos" data-label="To-dos"'
        ' data-title="Draft to-dos" data-timing="" data-flags=""'
        f' data-start="{clock:g}"'))

    page = TEMPLATE.replace("{{SLIDES}}", "\n".join(sections))
    page = page.replace("{{HEADER}}", HEADER).replace("{{FOOTER}}", FOOTER)
    page = page.replace("{{TOTAL}}", f"{clock:g}")
    OUT.write_text(page)
    print(f"Wrote {OUT} ({len(sections)} slides, {clock:g} min)")


CDN = "https://cdnjs.cloudflare.com/ajax/libs/reveal.js/5.1.0"

TEMPLATE = """<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Session 4 slides</title>
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Montserrat:700|Open+Sans:400,700,400italic,700italic&display=swap">
<link rel="stylesheet" href="CDN/reset.min.css">
<link rel="stylesheet" href="CDN/reveal.min.css">
<link rel="stylesheet" href="CDN/plugin/highlight/monokai.min.css">
<style>
/* ---- DIL theme (from rp-workshop/dist/theme/dil.css) ---- */
:root {
	--r-background-color: #eee;
	--r-main-font: "Open Sans", sans-serif;
	--r-main-font-size: 30px;
	--r-main-color: #4D4D4D;
	--r-block-margin: 20px;
	--r-heading-margin: 0 0 20px 0;
	--r-heading-font: Montserrat, Impact, sans-serif;
	--r-heading-color: #80001E;
	--r-heading-line-height: 1.2;
	--r-heading-letter-spacing: -0.03em;
	--r-code-font: monospace;
	--r-link-color: #004161;
	--r-link-color-hover: #6a90a3;
	--r-control-color: #faa319;
	--r-selection-background-color: #faa319;
	--r-selection-color: #fff;
	--panel-bg: #fff;
	--panel-text: #333;
	--panel-muted: #777;
	--panel-border: #ddd;
}
html, body { margin: 0; height: 100%; background: #d9d9d9; }
.reveal-viewport { background-color: var(--r-background-color); }
.reveal { font-family: var(--r-main-font); font-size: var(--r-main-font-size); color: var(--r-main-color); }
.reveal ::selection { color: var(--r-selection-color); background: var(--r-selection-background-color); }
.reveal .slides section { line-height: 1.3; text-align: left; }
.reveal h1, .reveal h2, .reveal h3, .reveal h4 {
	margin: var(--r-heading-margin); color: var(--r-heading-color);
	font-family: var(--r-heading-font); font-weight: normal;
	line-height: var(--r-heading-line-height); letter-spacing: var(--r-heading-letter-spacing);
	text-transform: none; text-shadow: none; word-wrap: break-word;
}
.reveal h1 { font-size: 2.4em; }
.reveal h2 { font-size: 1.45em; }
.reveal p { margin: 14px 0; line-height: 1.3; }
.reveal strong, .reveal b { font-weight: bold; }
.reveal em { font-style: italic; }
.reveal ol, .reveal ul { display: inline-block; text-align: left; margin: 0 0 0 1em; }
.reveal ul ul, .reveal ol ul { display: block; margin-left: 40px; }
.reveal li { margin: 4px 0; }
.reveal pre { width: 100%; margin: 14px 0; font-size: 0.62em; line-height: 1.25em; box-shadow: 0 5px 15px rgba(0,0,0,.15); }
.reveal pre code { max-height: 460px; padding: 10px 14px; }
.reveal code { font-family: var(--r-code-font); }
.reveal :not(pre) > code { background: rgba(0,0,0,.06); padding: 0 .2em; border-radius: 3px; font-size: .9em; }
.reveal table { margin: 10px 0; border-collapse: collapse; font-size: .82em; }
.reveal table th, .reveal table td { text-align: left; padding: .3em .6em; border-bottom: 1px solid; }
.reveal table tbody tr:last-child td { border-bottom: none; }
.reveal a { color: var(--r-link-color); text-decoration: none; }
.reveal .controls { color: var(--r-control-color); }
.reveal .progress { color: var(--r-control-color); }
.highlight { color: var(--r-control-color); }

/* ---- slide chrome ---- */
.chrome { position: absolute; left: 40px; right: 40px; font-size: 13px; color: #888; letter-spacing: .06em; pointer-events: none; z-index: 5; font-family: var(--r-main-font); }
.chrome.top { top: 14px; font-weight: 700; }
.chrome.bottom { bottom: 12px; }
.hide-chrome .chrome { display: none; }
.reveal .slides section.title-slide { text-align: left; }
.title-slide .logo { width: 300px; margin: 0 0 30px; }
.title-slide .logo-text { font-family: var(--r-heading-font); color: #80001E; font-size: .7em; margin: 0 0 30px; }
.title-slide .kicker { font-size: .5em; letter-spacing: .08em; color: #80001E; }
.title-slide .subtitle { font-size: .8em; }
.title-slide .byline { font-size: .55em; margin: 4px 0; }
.divider .section-num { color: #faa319; font-family: var(--r-heading-font); font-size: 1.1em; margin: 0; }
.reveal .divider h2 { color: #fff; font-size: 2em; }
.divider .divider-sub { color: #fff; font-size: .8em; margin: 6px 0; opacity: .9; }
.reveal .exercise h2 { color: #222; }
.reveal .demo h2 { color: #80001E; }
.reveal .solution h2::after { content: "SOLUTION"; margin-left: .6em; vertical-align: middle; font: 700 .32em "Open Sans", sans-serif; letter-spacing: .1em; color: #fff; background: #2e7d32; padding: .25em .6em; border-radius: 3px; }
.reveal .solution p { margin: 8px 0 4px; }
.reveal .solution pre { font-size: .5em; margin: 4px 0 10px; }
.reveal .solution pre code { max-height: none; padding: 6px 12px; }
.reveal .solution table { font-size: .68em; }
.reveal .cols { display: grid; grid-template-columns: 1fr 1fr; gap: 28px; align-items: start; }
.reveal .cols p { margin: 8px 0; }
.reveal .cols pre { font-size: .62em; margin: 6px 0; }
.reveal .cols pre code { max-height: none; }
.reveal .demo p:first-of-type em { color: #80001E; font-weight: 700; font-style: normal; letter-spacing: .02em; }
.reveal .exercise, .reveal .exercise table th, .reveal .exercise table td { color: #222; }
.reveal .todos { font-size: .6em; }
.reveal .todos ul { list-style: none; margin: 0; }
.reveal .todos input { margin-right: .5em; }
.reveal .appendix h2 { color: #555; }
.reveal .slides section .notes { display: none; }

/* ---- review layout ---- */
#app { display: flex; height: 100vh; }
#deck { flex: 1 1 auto; position: relative; min-width: 0; }
#deck .reveal { width: 100%; height: 100%; }
#panel { flex: 0 0 34%; max-width: 560px; background: var(--panel-bg); color: var(--panel-text); border-left: 1px solid var(--panel-border); overflow-y: auto; padding: 20px 24px 40px; box-sizing: border-box; font: 15px/1.5 "Open Sans", sans-serif; }
#panel.hidden { display: none; }
#panel .label { font: 700 12px Montserrat, sans-serif; letter-spacing: .08em; text-transform: uppercase; color: #80001E; margin: 0; }
#panel h3 { font: 700 18px/1.3 Montserrat, sans-serif; margin: 4px 0 8px; color: #222; }
#panel .meta { color: var(--panel-muted); font-size: 13px; margin-bottom: 12px; }
#panel .flag { display: inline-block; background: #80001E; color: #fff; font-size: 12px; font-weight: 700; padding: 2px 8px; border-radius: 3px; margin: 0 6px 6px 0; }
#panel .notes-body ul { padding-left: 1.2em; margin: 0; }
#panel .notes-body li { margin: 0 0 8px; }
#panel .notes-body p { margin: 0 0 10px; }
#panel .notes-body code { background: #f2f2f2; padding: 0 .25em; border-radius: 3px; font-size: .9em; }
#panel .notes-body pre { background: #f6f6f6; padding: 8px; overflow-x: auto; font-size: 12px; }
#panel .notes-body pre code, #panel .notes-body pre code * { color: inherit !important; background: none !important; }
#panel .empty { color: var(--panel-muted); font-style: italic; }
#panel .clock { margin-top: 18px; padding-top: 10px; border-top: 1px solid var(--panel-border); color: var(--panel-muted); font-size: 12px; }
#toggle { position: fixed; right: 12px; bottom: 12px; z-index: 30; font: 700 12px Montserrat, sans-serif; background: #80001E; color: #fff; border: 0; border-radius: 4px; padding: 7px 12px; cursor: pointer; }
@media (max-width: 800px) {
	#app { flex-direction: column; }
	#deck { flex: 0 0 56vh; }
	#panel { flex: 1 1 auto; max-width: none; border-left: 0; border-top: 1px solid var(--panel-border); }
}
@media (prefers-color-scheme: dark) {
	:root:not([data-theme="light"]) { --panel-bg: #1e1e1e; --panel-text: #ddd; --panel-muted: #999; --panel-border: #333; }
	:root:not([data-theme="light"]) body { background: #111; }
	:root:not([data-theme="light"]) #panel h3 { color: #eee; }
	:root:not([data-theme="light"]) #panel .label { color: #faa319; }
	:root:not([data-theme="light"]) #panel .notes-body code, :root:not([data-theme="light"]) #panel .notes-body pre { background: #2a2a2a; }
}
:root[data-theme="dark"] { --panel-bg: #1e1e1e; --panel-text: #ddd; --panel-muted: #999; --panel-border: #333; }
</style>
</head>
<body>
<div id="app">
	<div id="deck">
		<div class="reveal">
			<div class="chrome top">{{HEADER}}</div>
			<div class="chrome bottom">{{FOOTER}}</div>
			<div class="slides">
{{SLIDES}}
			</div>
		</div>
	</div>
	<aside id="panel" aria-label="Speaker notes">
		<p class="label" id="p-label"></p>
		<h3 id="p-title"></h3>
		<div class="meta" id="p-meta"></div>
		<div id="p-flags"></div>
		<div class="notes-body" id="p-notes"></div>
		<div class="clock" id="p-clock"></div>
	</aside>
</div>
<button id="toggle" type="button">Hide notes</button>

<script src="CDN/reveal.min.js"></script>
<script src="CDN/plugin/markdown/markdown.min.js"></script>
<script src="CDN/plugin/highlight/highlight.min.js"></script>
<script src="CDN/plugin/notes/notes.min.js"></script>
<script>
const TOTAL = {{TOTAL}};
const deck = new Reveal(document.querySelector('.reveal'), {
	embedded: true, hash: /^(https?|file):$/.test(location.protocol), slideNumber: 'c/t', center: false,
	width: 1280, height: 720, margin: 0.06, transition: 'none', backgroundTransition: 'none',
	plugins: [RevealMarkdown, RevealHighlight, RevealNotes]
});

function fit(section) {
	// Shrink text on slides whose content overflows the 1280x720 frame.
	if (!section || section.classList.contains('title-slide')) return;
	section.style.fontSize = '';
	let size = 100;
	while (section.scrollHeight > 720 - 60 && size > 50) {
		size -= 4;
		section.style.fontSize = size + '%';
	}
}

function renderPanel(section) {
	const d = section.dataset;
	document.getElementById('p-label').textContent = d.label || '';
	document.getElementById('p-title').textContent = d.title || '';
	document.getElementById('p-meta').textContent = d.timing ? '⏱ ' + d.timing : '';
	const flags = (d.flags || '').split(' | ').filter(Boolean);
	document.getElementById('p-flags').innerHTML = flags.map(f => '<span class="flag"></span>').join('');
	document.querySelectorAll('#p-flags .flag').forEach((el, i) => el.textContent = flags[i]);
	const aside = section.querySelector('aside.notes');
	const box = document.getElementById('p-notes');
	if (aside && aside.innerHTML.trim()) {
		box.innerHTML = aside.hasAttribute('data-markdown-notes')
			? deck.getPlugin('markdown').marked.parse(aside.textContent) : aside.innerHTML;
	} else {
		box.innerHTML = '<p class="empty">No speaker notes.</p>';
	}
	const start = parseFloat(d.start || '0');
	document.getElementById('p-clock').textContent =
		'Starts at minute ' + start + ' of ' + TOTAL + ' planned (session is 75).';
	document.querySelector('.reveal').classList.toggle('hide-chrome',
		section.classList.contains('title-slide') || section.classList.contains('divider'));
}

function onSlide(e) { fit(e.currentSlide); renderPanel(e.currentSlide); }
deck.initialize().then(() => {
	onSlide({ currentSlide: deck.getCurrentSlide() });
	deck.on('slidechanged', onSlide);
});

const panel = document.getElementById('panel');
const toggle = document.getElementById('toggle');
toggle.addEventListener('click', () => {
	panel.classList.toggle('hidden');
	toggle.textContent = panel.classList.contains('hidden') ? 'Show notes' : 'Hide notes';
	setTimeout(() => { deck.layout(); fit(deck.getCurrentSlide()); }, 0);
});
</script>
</body>
</html>
""".replace("CDN/", CDN + "/")


if __name__ == "__main__":
    build()
