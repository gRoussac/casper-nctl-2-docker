#!/bin/bash
cd /app
rm casper-node/target/release/*.rlib
rm -r casper-node/.git
rm -r casper-node/target/debug
rm -r casper-node/target/release/build
rm -r casper-node/target/release/deps
rm -r casper-node/target/release/.fingerprint
rm -r casper-node/target/wasm32-unknown-unknown/release/build
rm -r casper-node/target/wasm32-unknown-unknown/release/deps
rm -r casper-node/target/wasm32-unknown-unknown/release/.fingerprint
rm -r casper-node-launcher/.git
rm -r casper-node-launcher/target/debug
rm -r casper-node-launcher/target/release/build
rm -r casper-node-launcher/target/release/deps
rm -r casper-node-launcher/target/release/.fingerprint
rm -r casper-client-rs/.git
rm -r casper-client-rs/target/debug
rm -r casper-client-rs/target/release/build
rm -r casper-client-rs/target/release/deps
rm -r casper-client-rs/target/release/.fingerprint