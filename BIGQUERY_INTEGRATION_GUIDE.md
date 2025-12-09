# BigQuery Integration Guide for CTRL App

## Overview
This guide provides comprehensive instructions for integrating Google BigQuery with CTRL for scalable data collection, training, and analytics to support massive user databases.

---

## 🎯 What BigQuery Provides for CTRL

### 1. **Scalable Data Warehousing**
- Handle millions of social media events per day
- Petabyte-scale storage capacity
- Real-time data ingestion via Streaming API

### 2. **Machine Learning Training Data**
- SQL-based data preparation for ML models
- Integration with Google Cloud AI Platform
- Feature engineering at scale

### 3. **Analytics & Reporting**
- Complex query execution in seconds
- User behavior pattern analysis
- Cost-effective ad-hoc queries

### 4. **API Infrastructure Support**
- Query result caching for faster responses
- Materialized views for common queries
- Cost optimization through slot management

---

## 📦 Prerequisites

### 1. Google Cloud Platform Account
```bash
# Install Google Cloud SDK
curl https://sdk.cloud.google.com | bash
exec -l $SHELL

# Initialize gcloud
gcloud init
```

### 2. Create GCP Project
```bash
# Create new project
gcloud projects create ctrl-bigquery-prod --name="CTRL BigQuery"

# Set as active project
gcloud config set project ctrl-bigquery-prod

# Enable required APIs
gcloud services enable bigquery.googleapis.com
gcloud services enable bigquerydatatransfer.googleapis.com
gcloud services enable storage-api.googleapis.com
```

### 3. Create Service Account
```bash
# Create service account for backend access
gcloud iam service-accounts create ctrl-bigquery-sa \
  --description="CTRL BigQuery Service Account" \
  --display-name="CTRL BigQuery SA"

# Grant BigQuery permissions
gcloud projects add-iam-policy-binding ctrl-bigquery-prod \
  --member="serviceAccount:ctrl-bigquery-sa@ctrl-bigquery-prod.iam.gserviceaccount.com" \
  --role="roles/bigquery.dataEditor"

gcloud projects add-iam-policy-binding ctrl-bigquery-prod \
  --member="serviceAccount:ctrl-bigquery-sa@ctrl-bigquery-prod.iam.gserviceaccount.com" \
  --role="roles/bigquery.jobUser"

# Download service account key
gcloud iam service-accounts keys create ~/ctrl-bigquery-key.json \
  --iam-account=ctrl-bigquery-sa@ctrl-bigquery-prod.iam.gserviceaccount.com
```

---

## 🗄️ BigQuery Schema Setup

### 1. Create Dataset
```sql
-- Create main analytics dataset
CREATE SCHEMA IF NOT EXISTS ctrl_analytics
OPTIONS(
  location="US",
  description="CTRL social media analytics and training data"
);
```

### 2. Create Social Media Events Table
```sql
CREATE TABLE ctrl_analytics.social_media_events (
  event_id STRING NOT NULL,
  user_id STRING NOT NULL,
  platform STRING NOT NULL,
  event_type STRING NOT NULL,
  event_data JSON,
  screen_time_seconds INT64,
  engagement_rate FLOAT64,
  timestamp TIMESTAMP NOT NULL,
  processed BOOLEAN DEFAULT FALSE
)
PARTITION BY DATE(timestamp)
CLUSTER BY user_id, platform
OPTIONS(
  description="Real-time social media events from all platforms",
  require_partition_filter=TRUE
);
```

### 3. Create Training Data View
```sql
CREATE VIEW ctrl_analytics.ml_training_data AS
SELECT 
  user_id,
  platform,
  DATE(timestamp) as event_date,
  COUNT(*) as event_count,
  SUM(screen_time_seconds) as total_screen_time,
  AVG(engagement_rate) as avg_engagement_rate,
  ARRAY_AGG(DISTINCT event_type) as event_types,
  MAX(timestamp) as last_activity
FROM ctrl_analytics.social_media_events
WHERE processed = TRUE
GROUP BY user_id, platform, event_date;
```

### 4. Create User Aggregations Table
```sql
CREATE TABLE ctrl_analytics.user_daily_aggregations (
  user_id STRING NOT NULL,
  date DATE NOT NULL,
  total_posts INT64,
  total_comments INT64,
  total_shares INT64,
  total_screen_time_seconds INT64,
  platforms_active ARRAY<STRING>,
  engagement_score FLOAT64,
  calculated_at TIMESTAMP
)
PARTITION BY date
CLUSTER BY user_id
OPTIONS(
  description="Daily aggregated user statistics for quick analytics"
);
```

---

## 🔌 Flutter BigQuery Client Setup

### 1. Add Required Dependencies
```yaml
# pubspec.yaml
dependencies:
  googleapis: ^12.0.0
  googleapis_auth: ^1.4.1
  dio: ^5.7.0
```

### 2. Configure Environment Variables
```bash
# Add to your .env or build configuration
BIGQUERY_PROJECT_ID=ctrl-bigquery-prod
BIGQUERY_DATASET_ID=ctrl_analytics
BIGQUERY_SERVICE_ACCOUNT_KEY=/path/to/ctrl-bigquery-key.json
```

### 3. Initialize BigQuery Client
The `BigQueryService` in `lib/services/bigquery_service.dart` is already implemented with:
- Data insertion methods
- Query execution
- Cost estimation
- Export functionality

---

## 📊 Data Collection Patterns

### 1. Real-Time Streaming
```dart
// Stream social media events as they occur
final event = {
  'event_id': uuid.v4(),
  'user_id': userId,
  'platform': 'Instagram',
  'event_type': 'post_created',
  'event_data': {'post_id': '123', 'caption': 'Hello World'},
  'timestamp': DateTime.now().toUtc().toIso8601String(),
};

await bigQueryService.insertSocialMediaEvent(
  userId: userId,
  platform: 'Instagram',
  eventType: 'post_created',
  eventData: event['event_data'],
);
```

### 2. Batch Processing
```dart
// Collect events and batch insert for efficiency
final events = <Map<String, dynamic>>[];

// ... collect multiple events ...

await bigQueryService.streamSocialMediaData(events);
```

### 3. Scheduled Aggregations
```sql
-- Create scheduled query for daily aggregations
CREATE OR REPLACE TABLE ctrl_analytics.user_daily_aggregations
PARTITION BY date
AS
SELECT 
  user_id,
  DATE(timestamp) as date,
  COUNTIF(event_type = 'post_created') as total_posts,
  COUNTIF(event_type = 'comment_created') as total_comments,
  COUNTIF(event_type = 'share') as total_shares,
  SUM(screen_time_seconds) as total_screen_time_seconds,
  ARRAY_AGG(DISTINCT platform) as platforms_active,
  AVG(engagement_rate) as engagement_score,
  CURRENT_TIMESTAMP() as calculated_at
FROM ctrl_analytics.social_media_events
WHERE DATE(timestamp) = CURRENT_DATE() - 1
GROUP BY user_id, date;
```

---

## 🤖 ML Training Data Preparation

### 1. Feature Extraction Query
```sql
-- Extract features for ML model training
SELECT 
  user_id,
  -- Time-based features
  EXTRACT(HOUR FROM timestamp) as hour_of_day,
  EXTRACT(DAYOFWEEK FROM timestamp) as day_of_week,
  
  -- Platform features
  platform,
  COUNT(*) as event_count,
  
  -- Engagement features
  AVG(engagement_rate) as avg_engagement,
  STDDEV(engagement_rate) as engagement_variance,
  
  -- Screen time features
  SUM(screen_time_seconds) / 3600.0 as total_hours,
  AVG(screen_time_seconds) / 60.0 as avg_minutes_per_event,
  
  -- Behavior patterns
  COUNTIF(event_type = 'scroll') as scroll_count,
  COUNTIF(event_type = 'post_created') as post_count,
  COUNTIF(event_type = 'comment_created') as comment_count
  
FROM ctrl_analytics.social_media_events
WHERE timestamp BETWEEN @start_date AND @end_date
GROUP BY user_id, platform, hour_of_day, day_of_week;
```

### 2. Export for Training
```dart
// Export training data to Google Cloud Storage
final query = '''
  EXPORT DATA OPTIONS(
    uri='gs://ctrl-ml-training/data-*.csv',
    format='CSV',
    overwrite=true,
    header=true
  ) AS
  SELECT * FROM ctrl_analytics.ml_training_data
  WHERE date >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY);
''';

await bigQueryService.exportQueryResults(
  query: query,
  destinationUri: 'gs://ctrl-ml-training/export/',
);
```

---

## 💰 Cost Optimization

### 1. Query Cost Estimation
```dart
// Always estimate costs before expensive queries
final estimate = await bigQueryService.estimateQueryCost(query);
print('Query will process: ${estimate['estimatedBytes']}');
print('Estimated cost: ${estimate['estimatedCost']}');
```

### 2. Partitioning Strategy
- **Date Partitioning**: Automatically applied on `timestamp` column
- **Clustering**: Applied on `user_id` and `platform` for common queries
- **Require Partition Filter**: Prevents full table scans

### 3. Materialized Views
```sql
-- Create materialized view for frequently accessed data
CREATE MATERIALIZED VIEW ctrl_analytics.recent_user_activity
AS
SELECT 
  user_id,
  platform,
  MAX(timestamp) as last_activity,
  COUNT(*) as event_count_24h
FROM ctrl_analytics.social_media_events
WHERE timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 24 HOUR)
GROUP BY user_id, platform;
```

---

## 📈 Analytics & Monitoring

### 1. Infrastructure Health Queries
```sql
-- Monitor data pipeline health
SELECT 
  DATE(timestamp) as date,
  platform,
  COUNT(*) as event_count,
  AVG(TIMESTAMP_DIFF(processed_at, timestamp, SECOND)) as avg_delay_seconds,
  COUNTIF(processed = FALSE) as unprocessed_count
FROM ctrl_analytics.social_media_events
WHERE timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 7 DAY)
GROUP BY date, platform
ORDER BY date DESC, platform;
```

### 2. User Growth Analytics
```sql
-- Track user growth and engagement trends
SELECT 
  DATE_TRUNC(date, WEEK) as week,
  COUNT(DISTINCT user_id) as active_users,
  AVG(total_screen_time_seconds) / 3600.0 as avg_hours_per_user,
  AVG(engagement_score) as avg_engagement
FROM ctrl_analytics.user_daily_aggregations
GROUP BY week
ORDER BY week DESC;
```

---

## 🔐 Security Best Practices

### 1. Row-Level Security
```sql
-- Create row-level security policy
CREATE ROW ACCESS POLICY user_isolation_policy
ON ctrl_analytics.social_media_events
GRANT TO ("serviceAccount:ctrl-app@ctrl-bigquery-prod.iam.gserviceaccount.com")
FILTER USING (user_id = SESSION_USER());
```

### 2. Data Encryption
- All data encrypted at rest by default
- Use Customer-Managed Encryption Keys (CMEK) for additional control
- TLS 1.2+ enforced for data in transit

### 3. Access Control
```bash
# Principle of least privilege
# Analytics team - read-only access
gcloud projects add-iam-policy-binding ctrl-bigquery-prod \
  --member="group:analytics@ctrl.com" \
  --role="roles/bigquery.dataViewer"

# ML team - read training data, write results
gcloud projects add-iam-policy-binding ctrl-bigquery-prod \
  --member="group:ml-engineers@ctrl.com" \
  --role="roles/bigquery.dataEditor"
```

---

## 🚀 Scaling for Massive User Base

### 1. Streaming Insert Optimization
- Batch events (up to 10,000 rows per request)
- Use `insertId` for deduplication
- Implement retry logic with exponential backoff

### 2. Slot Reservations
```bash
# Purchase committed slots for predictable performance
bq mk --reservation \
  --project_id=ctrl-bigquery-prod \
  --location=US \
  --slots=500 \
  ctrl_production_reservation
```

### 3. Query Performance
- Use clustered columns in WHERE clauses
- Limit SELECT to required columns only
- Leverage approximate aggregation functions for huge datasets

---

## 📊 Sample Integration in CTRL

### Backend Infrastructure Monitor Integration
The Backend Infrastructure Monitor screen already integrates with BigQuery:

1. **BigQueryMetricsWidget**: Displays real-time metrics
2. **DataPipelineWidget**: Shows ingestion rates
3. **BigQueryService**: Handles all data operations

### Usage Example
```dart
// In your Flutter app
final bigQueryService = BigQueryService();

// Stream social media event
await bigQueryService.insertSocialMediaEvent(
  userId: 'user_12345',
  platform: 'Instagram',
  eventType: 'post_created',
  eventData: {
    'post_id': 'post_abc',
    'likes': 42,
    'comments': 8,
  },
);

// Query training data
final trainingData = await bigQueryService.queryTrainingData(
  startDate: DateTime.now().subtract(Duration(days: 30)),
  endDate: DateTime.now(),
);
```

---

## 🔧 Troubleshooting

### Common Issues

1. **Authentication Errors**
   - Verify service account key path
   - Check IAM permissions
   - Ensure APIs are enabled

2. **Query Quota Exceeded**
   - Implement rate limiting
   - Use batch operations
   - Purchase committed slots

3. **High Costs**
   - Always use partition filters
   - Leverage clustering
   - Estimate query costs first

---

## 📚 Resources

- [BigQuery Documentation](https://cloud.google.com/bigquery/docs)
- [BigQuery Pricing](https://cloud.google.com/bigquery/pricing)
- [Best Practices](https://cloud.google.com/bigquery/docs/best-practices)
- [Query Optimization](https://cloud.google.com/bigquery/docs/best-practices-performance-overview)

---

## ✅ Implementation Checklist

- [ ] GCP Project created and configured
- [ ] Service account with proper permissions
- [ ] BigQuery dataset and tables created
- [ ] Flutter BigQuery service implemented
- [ ] Environment variables configured
- [ ] Social media trackers integrated
- [ ] Data aggregation service connected
- [ ] Cost monitoring enabled
- [ ] Security policies applied
- [ ] ML training pipeline configured

---

## Support

For BigQuery-specific issues:
1. Check Google Cloud Console logs
2. Review BigQuery query history
3. Monitor slot utilization
4. Contact Google Cloud Support for quota increases

Good luck building a scalable, production-ready analytics infrastructure! 🚀