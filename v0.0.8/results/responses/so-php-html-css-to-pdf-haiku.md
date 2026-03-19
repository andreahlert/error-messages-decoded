The "root cause" is that **PDF generators don't render HTML/CSS the same way browsers do**. Most PHP PDF libraries have limited CSS support, causing layout breaks, missing styles, or missing content.

## Common specific issues:

1. **CSS not supported** — Flexbox, Grid, modern selectors often fail in TCPDF/dompdf
2. **External resources fail silently** — Images, fonts, stylesheets with relative paths don't load
3. **Complex styling ignored** — Gradients, shadows, transforms often get dropped
4. **Font issues** — System fonts unavailable; web fonts not embedded

## Solutions (in order of reliability):

**Best: Use a headless browser** (renders exactly like a browser)
```php
// wkhtmltopdf (simplest)
exec('wkhtmltopdf input.html output.pdf');

// Or Chromium via Puppeteer-PHP
$browser = await Puppeteer::launch();
$page = await $browser->newPage();
await $page->goto('file:///path/to/file.html');
await $page->pdf(['path' => 'output.pdf']);
```

**Good: Use a capable library with inline CSS**
```php
// dompdf or mPDF - move all CSS inline first
$html = '<html><body><div style="color: red;">Text</div></body></html>';
$dompdf = new Dompdf();
$dompdf->loadHtml($html);
$dompdf->render();
```

**Key fixes:**
- Convert external stylesheets to **inline `style=` attributes**
- Use **absolute file paths** for images: `file:///absolute/path/image.png`
- Stick to **basic CSS**: widths, margins, colors, borders (avoid Grid/Flexbox if using TCPDF)
- Embed fonts or use system fonts PDF libraries know about

What's your specific use case? Are you hitting layout issues, missing content, or styling problems?
