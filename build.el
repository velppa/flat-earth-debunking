(setq user-emacs-directory "/tmp/emacs-build/")
(make-directory "/tmp/emacs-build/" t)
(setq package-enable-at-startup nil)

(add-to-list 'load-path "/home/claude/flat-earth-blog/jack/")
(add-to-list 'load-path "/home/claude/flat-earth-blog/emacs-htmlize/")
(add-to-list 'load-path "/home/claude/flat-earth-blog/one.el/")

(require 'jack)
(require 'htmlize)
(require 'one)

;; Custom render functions
(defun flat-earth-css-string ()
":root {
  --bg: #0d1117; --surface: #161b22; --border: #30363d;
  --text: #e6edf3; --muted: #8b949e; --accent: #58a6ff;
  --accent2: #3fb950; --code-bg: #1f2428;
}
* { box-sizing: border-box; margin: 0; padding: 0; }
body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
       background: var(--bg); color: var(--text); line-height: 1.75; font-size: 17px; }
header { background: var(--surface); border-bottom: 1px solid var(--border);
         padding: 1rem 2rem; display: flex; align-items: center; gap: 1rem; }
.logo { font-size: 1.4rem; font-weight: 700; color: var(--accent); text-decoration: none; }
.tagline { color: var(--muted); font-size: 0.85rem; }
nav { margin-left: auto; display: flex; gap: 1.5rem; flex-wrap: wrap; }
nav a { color: var(--muted); text-decoration: none; font-size: 0.9rem; }
nav a:hover { color: var(--text); }
main { max-width: 760px; margin: 0 auto; padding: 3rem 2rem; }
h1 { font-size: 2rem; font-weight: 700; line-height: 1.25; margin-bottom: 1rem; }
h2 { font-size: 1.25rem; font-weight: 600; color: var(--accent);
     margin: 2.5rem 0 0.75rem; border-bottom: 1px solid var(--border); padding-bottom: 0.4rem; }
h3 { font-size: 1.05rem; font-weight: 600; margin: 1.5rem 0 0.5rem; }
p { margin: 0.9rem 0; }
a { color: var(--accent); text-decoration: none; }
a:hover { text-decoration: underline; }
blockquote { border-left: 3px solid var(--accent); padding: 0.75rem 1.25rem;
             margin: 1.5rem 0; background: var(--surface); border-radius: 0 6px 6px 0;
             color: var(--muted); font-style: italic; }
code { font-family: monospace; background: var(--code-bg); padding: 0.15em 0.4em;
       border-radius: 4px; font-size: 0.88em; color: var(--accent2); border: 1px solid var(--border); }
ul, ol { margin: 0.9rem 0 0.9rem 1.75rem; }
li { margin: 0.4rem 0; }
.hero { text-align: center; padding: 4rem 0 3rem; border-bottom: 1px solid var(--border); margin-bottom: 3rem; }
.hero h1 { font-size: 2.8rem; }
.hero .sub { color: var(--muted); font-size: 1.1rem; max-width: 520px; margin: 1rem auto 0; }
.badge { display: inline-block; background: var(--surface); border: 1px solid var(--accent);
         color: var(--accent); padding: 0.2rem 0.8rem; border-radius: 20px;
         font-size: 0.78rem; margin-bottom: 1.25rem; letter-spacing: 0.05em; text-transform: uppercase; }
.articles { list-style: none; margin: 0; padding: 0; }
.articles li { border: 1px solid var(--border); border-radius: 8px;
               padding: 1.25rem 1.5rem; margin: 0.75rem 0; background: var(--surface); }
.articles li:hover { border-color: var(--accent); }
.articles li a { color: var(--text); font-weight: 600; }
.breadcrumb { color: var(--muted); font-size: 0.85rem; margin-bottom: 2rem; }
.breadcrumb a { color: var(--muted); }
footer { border-top: 1px solid var(--border); padding: 2rem; text-align: center;
         color: var(--muted); font-size: 0.85rem; margin-top: 5rem; }")

(defun flat-earth-shell (title body-html)
  (concat
   "<!DOCTYPE html><html lang=\"en\"><head>"
   "<meta charset=\"utf-8\">"
   "<meta name=\"viewport\" content=\"width=device-width,initial-scale=1\">"
   "<title>" title " — Flat Earth Debunked</title>"
   "<style>" (flat-earth-css-string) "</style>"
   "</head><body>"
   "<header>"
   "<a class=\"logo\" href=\"/\">🌍 Flat Earth Debunked</a>"
   "<span class=\"tagline\">Science over speculation</span>"
   "<nav>"
   "<a href=\"/\">Home</a>"
   "<a href=\"/debunking-horizon/\">Horizon</a>"
   "<a href=\"/debunking-gravity/\">Gravity</a>"
   "<a href=\"/debunking-antarctica/\">Antarctica</a>"
   "<a href=\"/debunking-iss/\">Space</a>"
   "<a href=\"/debunking-ships/\">Ships</a>"
   "</nav></header>"
   "<main>" body-html "</main>"
   "<footer><p>Flat Earth Debunked — Science over speculation</p></footer>"
   "</body></html>"))

(defun flat-earth-home (page-tree pages _global)
  (let* ((content (org-export-data-with-backend
                   (org-element-contents page-tree) 'one-ox nil)))
    (flat-earth-shell
     "Home"
     (concat
      "<div class=\"hero\">"
      "<span class=\"badge\">Science-Based</span>"
      "<h1>The Earth Is Not Flat</h1>"
      "<p class=\"sub\">Every major claim of flat earth theory has been tested, measured, and refuted. Here's how.</p>"
      "</div>"
      content))))

(defun flat-earth-post (page-tree pages _global)
  (let* ((title (org-element-property :raw-value page-tree))
         (content (org-export-data-with-backend
                   (org-element-contents page-tree) 'one-ox nil)))
    (flat-earth-shell
     title
     (concat
      "<div class=\"breadcrumb\"><a href=\"/\">← Back to all articles</a></div>"
      "<h1>" title "</h1>"
      content))))

(setq default-directory "/home/claude/flat-earth-blog/site/")
(find-file "/home/claude/flat-earth-blog/site/one.org")
(one-build)
(message "BUILD DONE")
