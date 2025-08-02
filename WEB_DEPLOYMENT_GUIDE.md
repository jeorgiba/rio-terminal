# Rio Terminal WebAssembly Deployment Guide

## 🙏 Credits

**Rio Terminal** - A hardware-accelerated GPU terminal emulator  
**Original Author**: Raphael Amorim <rapha850@gmail.com>  
**Original Repository**: https://github.com/raphamorim/rio  
**License**: MIT  
**Documentation**: https://rioterm.com

*This deployment guide is based on the amazing work by Raphael Amorim and the Rio terminal project contributors.*

## 🌐 Deploy Rio Terminal to the Web

Rio terminal supports WebAssembly deployment through its Sugarloaf rendering engine, allowing you to run Rio in any modern web browser.

## 📋 Prerequisites

### 1. Install Required Tools
```powershell
# Install WASM target for Rust
rustup target add wasm32-unknown-unknown

# Install wasm-bindgen-cli
cargo install wasm-bindgen-cli

# Install cargo-server for local development
cargo install cargo-server

# Install wasm-opt (optional, for optimization)
# Download from: https://github.com/WebAssembly/binaryen
```

### 2. Install Node.js/npm (Alternative deployment)
```powershell
# For deploying to services like Vercel, Netlify
winget install OpenJS.NodeJS
```

## 🔧 Build for WebAssembly

### Method 1: Using the Project's Build System
```powershell
# Navigate to project root
cd D:\Repo\Personal\rio

# Build WASM target
cargo build -p rioterm --target wasm32-unknown-unknown --lib

# Generate WASM bindings
cd frontends\wasm
wasm-bindgen ..\target\wasm32-unknown-unknown\debug\rioterm.wasm --out-dir wasm --target web --no-typescript

# Run local development server
cargo server --open
```

### Method 2: Using Make (if Make is available)
```powershell
# From the root directory
make run-wasm

# Or from frontends/wasm directory
cd frontends\wasm
make install  # Install dependencies
make build    # Build WASM
make run      # Run local server
```

## 🚀 Deployment Options

### Option 1: Render.com (Recommended for Production)

Render.com offers excellent support for Rust/WASM applications with automatic builds and global CDN.

#### Method 1: Using render.yaml (Recommended)
1. **Setup Repository**: Push your Rio code to GitHub
2. **Configure Build**: The `render.yaml` file is already created in the project root
3. **Deploy**: 
   - Go to [Render Dashboard](https://dashboard.render.com/)
   - Click "New" → "Blueprint"
   - Connect your GitHub repository
   - Render will automatically detect `render.yaml` and deploy

#### Method 2: Manual Render.com Setup
1. **Create Web Service**:
   - Go to [Render Dashboard](https://dashboard.render.com/)
   - Click "New" → "Web Service"
   - Connect your GitHub repository

2. **Configure Build Settings**:
   ```
   Build Command:
   rustup target add wasm32-unknown-unknown &&
   cargo install wasm-bindgen-cli &&
   cargo build -p rioterm --target wasm32-unknown-unknown --release --lib &&
   cd frontends/wasm &&
   wasm-bindgen ../target/wasm32-unknown-unknown/release/rioterm.wasm --out-dir wasm --target web --no-typescript
   
   Publish Directory: frontends/wasm
   ```

3. **Set Environment Variables**:
   - `RUST_VERSION`: `1.88`
   - `CARGO_TARGET_DIR`: `target`

4. **Configure Headers** (in Render dashboard):
   - Path: `/*`
   - `Cross-Origin-Embedder-Policy`: `require-corp`
   - `Cross-Origin-Opener-Policy`: `same-origin`

#### Method 3: Docker Deployment on Render
1. **Use Dockerfile**: The `Dockerfile.render` is ready for Render.com
2. **Deploy**:
   - Create Web Service on Render
   - Select "Docker" 
   - Point to `Dockerfile.render`
   - Set port to `10000`

#### Render.com Benefits:
- ✅ **Automatic Builds**: Builds on every git push
- ✅ **Global CDN**: Fast worldwide access
- ✅ **Free Tier**: Great for testing and personal projects
- ✅ **Custom Domains**: Easy to add your own domain
- ✅ **SSL Certificates**: Automatic HTTPS
- ✅ **Build Logs**: Detailed build and deployment logs

### Option 2: Local Development Server
```powershell
# Build and serve locally
cd frontends\wasm
cargo server --port 8000 --open

# Access at: http://localhost:8000
```

### Option 2: Static File Hosting (Netlify, Vercel, GitHub Pages)

#### Create deployment package:
```powershell
# Build release version
cargo build -p rioterm --target wasm32-unknown-unknown --release --lib

# Generate optimized WASM bindings
cd frontends\wasm
wasm-bindgen ..\target\wasm32-unknown-unknown\release\rioterm.wasm --out-dir wasm --target web --no-typescript

# Optimize WASM file (if wasm-opt is installed)
wasm-opt -O wasm\rioterm_bg.wasm -o wasm\rioterm_bg.wasm
```

#### Deploy to Netlify:
1. Create `netlify.toml` in `frontends/wasm/`:
```toml
[build]
  publish = "."
  
[[headers]]
  for = "/*"
  [headers.values]
    Cross-Origin-Embedder-Policy = "require-corp"
    Cross-Origin-Opener-Policy = "same-origin"
```

2. Drag and drop the `frontends/wasm` folder to [Netlify Drop](https://app.netlify.com/drop)

#### Deploy to Vercel:
1. Create `vercel.json` in `frontends/wasm/`:
```json
{
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        {
          "key": "Cross-Origin-Embedder-Policy",
          "value": "require-corp"
        },
        {
          "key": "Cross-Origin-Opener-Policy", 
          "value": "same-origin"
        }
      ]
    }
  ]
}
```

2. Install Vercel CLI: `npm install -g vercel`
3. Deploy: `vercel --prod`

#### Deploy to Render.com:
1. Create `render.yaml` in project root:
```yaml
services:
  - type: web
    name: rio-terminal
    env: static
    buildCommand: |
      rustup target add wasm32-unknown-unknown
      cargo install wasm-bindgen-cli
      cargo build -p rioterm --target wasm32-unknown-unknown --release --lib
      cd frontends/wasm
      wasm-bindgen ../target/wasm32-unknown-unknown/release/rioterm.wasm --out-dir wasm --target web --no-typescript
    staticPublishPath: ./frontends/wasm
    headers:
      - path: /*
        name: Cross-Origin-Embedder-Policy
        value: require-corp
      - path: /*
        name: Cross-Origin-Opener-Policy
        value: same-origin
    routes:
      - type: rewrite
        source: /*
        destination: /index.html
```

2. Alternative: Create `Dockerfile` for Render:
```dockerfile
# Multi-stage build for Render.com
FROM rust:1.88 as builder

# Install WASM tools
RUN rustup target add wasm32-unknown-unknown
RUN cargo install wasm-bindgen-cli

# Copy source code
WORKDIR /app
COPY . .

# Build WASM
RUN cargo build -p rioterm --target wasm32-unknown-unknown --release --lib
RUN cd frontends/wasm && \
    wasm-bindgen ../target/wasm32-unknown-unknown/release/rioterm.wasm --out-dir wasm --target web --no-typescript

# Production stage
FROM nginx:alpine
COPY --from=builder /app/frontends/wasm /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 10000
CMD ["nginx", "-g", "daemon off;"]
```

3. Deploy options:
   - **GitHub Integration**: Connect your GitHub repo to Render
   - **Manual Deploy**: Upload files via Render dashboard
   - **CLI Deploy**: Use Render CLI tools

### Option 3: Docker Web Server
```dockerfile
# Dockerfile
FROM nginx:alpine
COPY frontends/wasm/ /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

```nginx
# nginx.conf
events {
    worker_connections 1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
    
    server {
        listen 80;
        server_name localhost;
        
        add_header Cross-Origin-Embedder-Policy require-corp;
        add_header Cross-Origin-Opener-Policy same-origin;
        
        location / {
            root   /usr/share/nginx/html;
            index  index.html;
            try_files $uri $uri/ /index.html;
        }
    }
}
```

## 🔧 Development Workflow

### 1. Development with Hot Reload
```powershell
cd frontends\wasm

# Watch for changes and rebuild
cargo watch -- make build

# In another terminal, serve files
cargo server --port 8000
```

### 2. Testing WASM Build
```powershell
# Test WASM target specifically
cargo test --target wasm32-unknown-unknown -p sugarloaf --tests

# Run with WASM test runner
CARGO_TARGET_WASM32_UNKNOWN_UNKNOWN_RUNNER=wasm-bindgen-test-runner cargo test --target wasm32-unknown-unknown -p sugarloaf --tests
```

## 🌐 Access Your Web Terminal

Once deployed, you can access Rio terminal in any modern browser that supports:
- WebGPU (Chrome 113+, Firefox 110+, Safari 16.4+)
- WebAssembly
- SharedArrayBuffer (requires secure context)

### Browser Compatibility:
- ✅ Chrome 113+
- ✅ Firefox 110+  
- ✅ Safari 16.4+
- ✅ Edge 113+

## 📱 Mobile Support

Rio WASM can run on mobile browsers with WebGPU support:
- iOS Safari 16.4+
- Android Chrome 113+

## ⚡ Performance Tips

1. **Use Release Builds**: Always build with `--release` for production
2. **Enable WASM Optimization**: Use `wasm-opt -O` to reduce bundle size
3. **Enable Compression**: Configure your web server to use gzip/brotli
4. **Cache Strategy**: Set appropriate cache headers for `.wasm` files

## 🔒 Security Headers

Required for SharedArrayBuffer support:
```
Cross-Origin-Embedder-Policy: require-corp
Cross-Origin-Opener-Policy: same-origin
```

## 📊 Bundle Size

Typical Rio WASM bundle sizes:
- Debug build: ~15-20MB
- Release build: ~8-12MB  
- Optimized with wasm-opt: ~6-10MB

## 🐛 Troubleshooting

### Common Issues:
1. **WASM build fails**: Ensure `wasm32-unknown-unknown` target is installed
2. **Browser crashes**: Check WebGPU support and enable required flags
3. **Security errors**: Verify CORS headers are set correctly
4. **Performance issues**: Use release builds and enable optimization

### Debug Commands:
```powershell
# Check WASM target
rustup target list --installed

# Verify wasm-bindgen version
wasm-bindgen --version

# Check generated files
Get-ChildItem frontends\wasm\wasm\
```

## 🚀 Ready to Deploy!

Your Rio terminal will be accessible via web browser with full GPU acceleration and terminal functionality!

## ⚡ Quick Start: Deploy to Render.com

### 5-Minute Deployment:
1. **Push to GitHub**: Ensure your code is at https://github.com/jeorgiba/rio-terminal.git
2. **Sign up** at [render.com](https://render.com) (free account)
3. **Create Blueprint** service and connect your GitHub repo: `jeorgiba/rio-terminal`
4. **Wait for build** (5-10 minutes for first build)
5. **Access your terminal** at `https://rio-terminal-wasm.onrender.com`

### Build Time Expectations:
- **First build**: 10-15 minutes (downloads Rust toolchain)
- **Subsequent builds**: 3-5 minutes (cached dependencies)
- **WASM bundle size**: ~8-12MB optimized

### URLs after deployment:
- **Render.com**: `https://rio-terminal-wasm.onrender.com`
- **Repository**: `https://github.com/jeorgiba/rio-terminal.git`
- **Custom domain**: Configure in Render dashboard
- **Preview URLs**: Available for pull requests

### Cost:
- **Free tier**: Perfect for personal use and testing
- **Starter plan**: $7/month for production use
- **No bandwidth limits** on free tier
