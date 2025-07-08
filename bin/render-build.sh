#!/usr/bin/env bash
set -o errexit

echo "Installing gems..."
bundle install

echo "Clobbering old assets..."
SECRET_KEY_BASE=dummy bundle exec rails assets:clobber

echo "Precompiling assets for production..."
SECRET_KEY_BASE=dummy bundle exec rails assets:precompile

echo "✅ Build complete"