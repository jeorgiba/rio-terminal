# Rio Terminal - Render.com Deployment Checklist

## 🙏 Credits

**Rio Terminal** - A hardware-accelerated GPU terminal emulator  
**Original Author**: Raphael Amorim <rapha850@gmail.com>  
**Original Repository**: https://github.com/raphamorim/rio  
**License**: MIT  
**Documentation**: https://rioterm.com

*This deployment configuration is based on the excellent Rio terminal project.*

## 🎯 Your Repository Setup
- **GitHub Repository**: https://github.com/jeorgiba/rio-terminal.git
- **Render.com Service**: rio-terminal-wasm
- **Expected URL**: https://rio-terminal-wasm.onrender.com

## ✅ Pre-Deployment Checklist

### 1. Repository Setup
- [ ] Code pushed to: https://github.com/jeorgiba/rio-terminal.git
- [ ] `render.yaml` configuration file present
- [ ] `Dockerfile.render` present (backup option)
- [ ] `WEB_DEPLOYMENT_GUIDE.md` available for reference

### 2. Render.com Account
- [ ] Create account at [render.com](https://render.com)
- [ ] Connect GitHub account
- [ ] Grant access to `jeorgiba/rio-terminal` repository

### 3. Deployment Method (Choose One)

#### Option A: Blueprint Deployment (Recommended)
- [ ] Go to Render Dashboard
- [ ] Click "New" → "Blueprint"
- [ ] Select repository: `jeorgiba/rio-terminal`
- [ ] Render auto-detects `render.yaml`
- [ ] Click "Apply"

#### Option B: Manual Web Service
- [ ] Go to Render Dashboard  
- [ ] Click "New" → "Web Service"
- [ ] Connect to `jeorgiba/rio-terminal`
- [ ] Set Build Command (see WEB_DEPLOYMENT_GUIDE.md)
- [ ] Set Publish Directory: `frontends/wasm`
- [ ] Add CORS headers

#### Option C: Docker Service
- [ ] Create "Web Service" 
- [ ] Select "Docker"
- [ ] Point to `Dockerfile.render`
- [ ] Set port to 10000

## 🚀 Deployment Steps

1. **Trigger Build**:
   ```bash
   git add .
   git commit -m "Deploy Rio Terminal to Render.com"
   git push origin main
   ```

2. **Monitor Build**:
   - Check Render dashboard for build logs
   - First build: ~10-15 minutes
   - Subsequent builds: ~3-5 minutes

3. **Access Terminal**:
   - URL: https://rio-terminal-wasm.onrender.com
   - Test WebGPU compatibility in browser
   - Verify CORS headers are working

## 📊 Expected Results

### Build Process:
```
✅ Install Rust 1.88
✅ Add wasm32-unknown-unknown target  
✅ Install wasm-bindgen-cli
✅ Build Rio for WebAssembly
✅ Generate JavaScript bindings
✅ Deploy to Render.com CDN
```

### Final Output:
- **WASM Bundle**: ~8-12MB
- **Load Time**: 3-5 seconds (first visit)
- **Performance**: Full GPU acceleration
- **Compatibility**: Chrome 113+, Firefox 110+, Safari 16.4+

## 🛠️ Troubleshooting

### Build Fails?
- Check build logs in Render dashboard
- Verify Rust 1.88 compatibility
- Check WASM target installation

### Site Not Loading?
- Verify CORS headers are set
- Check browser WebGPU support
- Enable browser flags if needed

### Performance Issues?
- Ensure release build is used
- Check gzip compression
- Verify CDN caching

## 📞 Support

- **Render.com Docs**: https://render.com/docs
- **Rio Terminal Issues**: https://github.com/jeorgiba/rio-terminal/issues
- **WebGPU Support**: Check browser compatibility

## 🎉 Success!
Once deployed, your Rio terminal will be accessible worldwide at:
**https://rio-terminal-wasm.onrender.com**
