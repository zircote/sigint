---
# Image generation provider
provider: svg

# SVG-specific settings
svg_style: illustrated

# Dark mode support
dark_mode: true

# Output settings
output_path: .github/social-preview.svg
dimensions: 1280x640
include_text: true
colors: dark

# README infographic settings
infographic_output: .github/readme-infographic.svg
infographic_style: hybrid

# Upload to repository (requires gh CLI)
upload_to_repo: false
---

# GitHub Social Plugin Configuration

This configuration was created by `/github-social:setup`.

## Provider: SVG

Claude generates clean SVG graphics directly. No API key required.
- **Pros**: Free, instant, editable, small file size (10-50KB)
- **Best for**: Professional, predictable results

## Style: Illustrated

Organic paths with hand-drawn aesthetic. Good for projects with a creative or research-focused identity like sigint.

## Dark Mode: Enabled

Generates dark mode variant only, matching modern developer preferences.

## Commands

- `/social-preview` - Generate social preview image
- `/readme-enhance` - Add marketing badges and infographic to README
- `/github-social:all` - Run all skills in sequence

## Override Settings

Override any setting via command flags:
```bash
/social-preview --svg-style=minimal
/social-preview --dark-mode=both
```
