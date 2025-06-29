# Capsul Landing Page

A modern, responsive landing page for Capsul - an AI-powered inbox app that connects businesses with their clients.

## Features

- **Modern Design**: Clean, professional design with gradient accents and smooth animations
- **Fully Responsive**: Optimized for desktop, tablet, and mobile devices
- **Interactive Elements**: Smooth scrolling, hover effects, and mobile menu
- **Performance Optimized**: Fast loading with optimized CSS and JavaScript
- **Accessibility**: Proper semantic HTML and focus states
- **SEO Ready**: Meta tags and structured content

## File Structure

```
website/
├── index.html          # Main HTML file
├── styles.css          # CSS styles and responsive design
├── script.js           # JavaScript functionality
└── README.md           # This file
```

## Customization

### Colors and Branding

The color scheme is defined using CSS custom properties in `styles.css`. You can easily modify:

```css
:root {
    --primary-color: #6366f1;        /* Main brand color */
    --primary-dark: #4f46e5;         /* Darker shade for hover states */
    --secondary-color: #f8fafc;      /* Light background color */
    --text-primary: #1e293b;         /* Main text color */
    --text-secondary: #64748b;       /* Secondary text color */
    /* ... other colors */
}
```

### Content Updates

1. **Hero Section**: Update the main headline and subtitle in `index.html`
2. **Features**: Modify the feature cards to match your product's capabilities
3. **CTA Buttons**: Update button text and links to point to your actual application
4. **Footer**: Update company information and links

### Adding Your Application Link

Replace the placeholder links (`href="#"`) with your actual application URL:

```html
<!-- In the navigation -->
<a href="https://your-app-url.com" class="cta-button">Get Started</a>

<!-- In the hero section -->
<a href="https://your-app-url.com" class="primary-button">Try Capsul Free</a>

<!-- In the CTA section -->
<a href="https://your-app-url.com" class="primary-button large">Start Your Free Trial</a>
```

## Deployment

### Option 1: Static Hosting (Recommended)

1. **Netlify**: Drag and drop the folder to [netlify.com](https://netlify.com)
2. **Vercel**: Connect your repository to [vercel.com](https://vercel.com)
3. **GitHub Pages**: Push to a GitHub repository and enable Pages
4. **AWS S3**: Upload files to an S3 bucket with static website hosting

### Option 2: Traditional Web Hosting

Upload all files to your web server's public directory.

### Option 3: Local Development

Simply open `index.html` in a web browser or use a local server:

```bash
# Using Python
python -m http.server 8000

# Using Node.js (if you have http-server installed)
npx http-server

# Using PHP
php -S localhost:8000
```

## Browser Support

- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)
- Mobile browsers (iOS Safari, Chrome Mobile)

## Performance Tips

1. **Optimize Images**: If you add images, compress them for web use
2. **Minify CSS/JS**: For production, minify the CSS and JavaScript files
3. **CDN**: Consider using a CDN for faster global delivery
4. **Caching**: Set appropriate cache headers for static assets

## Customization Examples

### Adding a Logo

Replace the text logo with an image:

```html
<div class="logo">
    <img src="path/to/your/logo.png" alt="Capsul" height="40">
</div>
```

### Adding More Sections

You can easily add new sections by following the existing pattern:

```html
<section class="new-section">
    <div class="container">
        <h2 class="section-title">Your New Section</h2>
        <!-- Your content here -->
    </div>
</section>
```

### Changing Fonts

Update the Google Fonts link in `index.html` and modify the font-family in `styles.css`.

## Analytics and Tracking

To add analytics, insert your tracking code in the `<head>` section of `index.html`:

```html
<!-- Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=GA_MEASUREMENT_ID"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'GA_MEASUREMENT_ID');
</script>
```

## Support

This landing page is built with modern web standards and should work across all modern browsers. If you need help with customization or deployment, feel free to modify the code to suit your needs.

## License

This landing page template is free to use and modify for your business needs. 