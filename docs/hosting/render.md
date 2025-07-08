# Deploying Maybe to Render

This guide covers deploying the Maybe app to [Render](https://render.com) using the included `render.yaml` configuration file.

## Prerequisites

- A Render account
- Your Maybe repository connected to GitHub
- Basic familiarity with Render's dashboard

## Quick Deploy

### Option 1: One-Click Deploy (Recommended)
1. Fork or clone the Maybe repository to your GitHub account
2. In Render, create a new service and connect your repository
3. Render will automatically detect the `render.yaml` file and create all necessary services:
   - Web service (Rails app)
   - Worker service (Sidekiq background jobs)
   - PostgreSQL database
   - Redis instance

### Option 2: Manual Configuration
If you prefer to set up services manually, follow the steps below.

## Manual Setup

### 1. Create the Database
1. In your Render dashboard, create a new **PostgreSQL** database
2. Name it `maybe-db`
3. Set the database name to `maybe_production`
4. Choose the **Starter** plan (or higher based on your needs)

### 2. Create Redis Instance
1. Create a new **Redis** service
2. Name it `maybe-redis`
3. Choose the **Starter** plan
4. Set maxmemory policy to `allkeys-lru`

### 3. Create the Web Service
1. Create a new **Web Service**
2. Connect your GitHub repository
3. Configure the service:
   - **Name**: `maybe-web`
   - **Environment**: `Ruby`
   - **Plan**: `Starter` (or higher)
   - **Build Command**: `./bin/render-build.sh`
   - **Start Command**: `./bin/rails server`

### 4. Create the Worker Service
1. Create a new **Background Worker**
2. Connect the same GitHub repository
3. Configure the service:
   - **Name**: `maybe-worker`
   - **Environment**: `Ruby`
   - **Plan**: `Starter` (or higher)
   - **Build Command**: `./bin/render-build.sh`
   - **Start Command**: `bundle exec sidekiq`

## Environment Variables

The `render.yaml` file automatically configures most environment variables, but you may want to customize these:

### Required (Auto-configured)
- `RAILS_ENV=production`
- `SELF_HOSTED=true`
- `RAILS_SERVE_STATIC_FILES=true`
- `SECRET_KEY_BASE` (auto-generated)
- `DATABASE_URL` (from PostgreSQL service)
- `REDIS_URL` (from Redis service)

### Optional Configuration
Add these environment variables for additional functionality:

#### Email Configuration (SMTP)
```
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=your-email@gmail.com
SMTP_PASSWORD=your-app-password
SMTP_DOMAIN=gmail.com
SMTP_AUTHENTICATION=plain
SMTP_ENABLE_STARTTLS_AUTO=true
```

#### File Storage (AWS S3)
```
ACTIVE_STORAGE_SERVICE=amazon
AWS_ACCESS_KEY_ID=your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-key
AWS_REGION=us-east-1
AWS_BUCKET=your-bucket-name
```

#### Plaid Integration (Bank Syncing)
```
PLAID_CLIENT_ID=your-plaid-client-id
PLAID_SECRET=your-plaid-secret
PLAID_ENV=sandbox  # or 'production'
```

## Custom Domain

To use a custom domain:
1. Update the `domains` section in `render.yaml`
2. Or configure it in the Render dashboard after deployment
3. Set up DNS records as instructed by Render

## Deployment Process

1. **Initial Deploy**: Push your code to GitHub. Render will:
   - Build your application using the render-build script
   - Install gems and precompile assets
   - Start the Rails server and Sidekiq worker

2. **Database Setup**: On first deployment, the database will be automatically prepared via the docker-entrypoint script

3. **Health Checks**: The web service includes a health check at `/up` endpoint

## Monitoring & Logs

- **Application Logs**: Available in Render dashboard under each service
- **Database Logs**: Monitor PostgreSQL performance in the database dashboard
- **Background Jobs**: Sidekiq web UI available at `/sidekiq` (in production, you may want to secure this)

## Scaling

Render makes it easy to scale your application:

- **Web Service**: Increase the plan or add more instances
- **Worker Service**: Scale based on background job volume
- **Database**: Upgrade to higher-tier PostgreSQL plans
- **Redis**: Increase memory allocation as needed

## Troubleshooting

### Common Issues

1. **Build Failures**: Check that all dependencies are properly specified in `Gemfile`
2. **Database Connection**: Verify the `DATABASE_URL` environment variable is correctly set
3. **Asset Compilation**: Ensure the render-build script has proper permissions (`chmod +x bin/render-build.sh`)

### Debugging Steps

1. Check service logs in the Render dashboard
2. Verify all environment variables are set correctly
3. Ensure the database is accessible from the web service
4. Check that Redis is running and accessible

## Cost Optimization

- **Free Tier**: Render offers free tiers for web services and PostgreSQL
- **Starter Plans**: Recommended for production use
- **Scaling**: Only scale services that need it based on usage patterns

## Security Considerations

- **Environment Variables**: Keep sensitive data in environment variables, not in code
- **Database Access**: PostgreSQL is only accessible from your Render services
- **HTTPS**: All Render services include free SSL certificates
- **Secrets**: Use Render's secret management for sensitive configuration

## Support

For Render-specific issues:
- [Render Documentation](https://render.com/docs)
- [Render Community Forum](https://community.render.com)
- Render support (for paid plans)

For Maybe app issues:
- [Maybe GitHub Repository](https://github.com/maybe-finance/maybe)
- [Maybe Community](https://github.com/maybe-finance/maybe/discussions)