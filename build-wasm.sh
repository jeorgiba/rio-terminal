#!/bin/bash
# Build script for Rio Terminal WASM deployment
# 
# Credits: Based on Rio Terminal by Raphael Amorim
# Original project: https://github.com/raphamorim/rio

set -e

echo "🦀 Installing Rust and WASM tools..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source ~/.cargo/env
rustup target add wasm32-unknown-unknown
cargo install wasm-bindgen-cli

echo "🔨 Building Rio Terminal for WebAssembly..."
cd frontends/wasm
cargo build --target wasm32-unknown-unknown --release

echo "🌐 Generating JavaScript bindings..."
wasm-bindgen ../../target/wasm32-unknown-unknown/release/rioterm_wasm.wasm \
    --out-dir . \
    --target web \
    --no-typescript

echo "✅ Build complete! Files are ready in frontends/wasm/"
ls -la *.wasm *.js 2>/dev/null || echo "Generated files will be available after build"
