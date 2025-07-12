# Web Deployment Guide

This document explains how to deploy the Chakame Flutter web app to GitHub Pages.

## Automatic Deployment

The project includes a GitHub Actions workflow that automatically builds and deploys the web app to GitHub Pages when changes are pushed to the main/master branch.

### Setup Instructions

1. **Enable GitHub Pages**:
   - Go to your repository settings
   - Navigate to "Pages" section
   - Under "Source", select "GitHub Actions"

2. **Configure Repository Settings**:
   - Ensure the repository is public (required for GitHub Pages on free accounts)
   - The workflow requires the following permissions:
     - `contents: read`
     - `pages: write`
     - `id-token: write`

3. **Trigger Deployment**:
   - Push changes to the main/master branch
   - The workflow will automatically build and deploy
   - The app will be available at: `https://yourusername.github.io/Chakame/`

### Workflow Details

The deployment workflow (`.github/workflows/deploy-web.yml`) includes:

- **Build Job**:
  - Sets up Flutter stable channel
  - Installs dependencies
  - Generates localization files
  - Builds JSON annotations
  - Builds web app with proper base href
  - Uploads build artifacts

- **Deploy Job**:
  - Deploys to GitHub Pages
  - Only runs on main/master branch pushes
  - Provides deployment URL

### Configuration Files

- **`.nojekyll`**: Tells GitHub Pages not to process files with Jekyll
- **`CNAME`**: Optional file for custom domain configuration
- **`web/index.html`**: Updated with proper meta tags and title
- **`web/manifest.json`**: Configured for PWA with proper branding
- **`web/privacy-policy.html`**: Static HTML privacy policy page
- **`web/.htaccess`**: URL rewriting configuration for Apache servers
- **`web/_config.yml`**: Jekyll configuration for GitHub Pages redirects

### Custom Domain (Optional)

To use a custom domain:

1. Update the `CNAME` file with your domain name
2. Configure your domain's DNS to point to GitHub Pages
3. Update the `--base-href` in the workflow to `/` instead of `/Chakame/`

### Build Settings

The web build uses:
- HTML renderer for better compatibility
- Release mode for optimized performance
- Proper base href for GitHub Pages subdirectory hosting
- Localization support for Farsi and English
- Static privacy policy page accessible at `/privacy-policy`

### Privacy Policy Access

The privacy policy is available at multiple URLs:
- `https://yourusername.github.io/Chakame/privacy-policy.html`
- `https://yourusername.github.io/Chakame/privacy-policy/`
- `https://yourusername.github.io/Chakame/privacy-policy` (with URL rewriting)

### Troubleshooting

- **Build fails**: Check Flutter version compatibility
- **404 errors**: Verify base href configuration
- **Fonts not loading**: Ensure font files are included in assets
- **Routing issues**: Check that routing is configured for web deployment

### Local Testing

To test the web build locally:

```bash
flutter build web --release
cd build/web
python -m http.server 8000
```

Visit `http://localhost:8000` to test the build.