-- 1. Aggregate earliest completed AI analysis job for each user
WITH analysis_count as (
    SELECT
        user_id,
        COUNT(1) as analysis_completed_count,
        MIN(created_at) as first_analysis_at
    FROM    
        analytics.job_progress
    WHERE
        status_text = 'Analysis completed successfully!'
        AND progress_percent = 100
    GROUP BY
        user_id
),

-- 2. Aggregate earliest file download event from system master logs
download_count as (
    SELECT
        user_id,
        COUNT(1) as download_count,
        MIN(timestamp) as first_downloaded_at
    FROM
        master_logs
    WHERE
        message LIKE 'File downloaded from storage' OR message LIKE 'Video Downloaded'
    GROUP BY
        user_id
),

-- 3. Aggregate earliest video upload event for each user
video_upload as (
    SELECT
        user_id,
        MIN(created_at) as first_upload_at,
        COUNT(1) as upload_count
    FROM
        analytics.user_videos
    GROUP BY
        user_id
),

  -- 4. Aggregate rageclick interaction events from PostHog logs (casting person_id)
rageclick_summary as (
    SELECT
        toString(e.person_id) as user_id, 
        COUNT(1) as rageclick_count
    FROM
        events as e
    JOIN
        analytics.profiles as p ON toString(e.person_id) = p.user_id 
    WHERE
        e.event = '$rageclick'
        AND e.created_at > p.created_at 
        AND e.created_at <= p.created_at + INTERVAL 24 HOUR
    GROUP BY
        toString(e.person_id)
),

-- 5. Base user cohort isolation and profile attribute joining
event_table as (
    SELECT
        p.user_id,
        p.created_at,
        p.cohort,
        p.newsletter_subscribed,
        ifNull(r.rageclick_count, 0) as rageclick_count
    FROM
        analytics.profiles as p
    LEFT JOIN
        rageclick_summary as r ON p.user_id = r.user_id
    WHERE
        p.user_id IN (
                SELECT
                    user_id
                FROM
                    v_user_activity
        )
)

-- 6. Final Feature Engineering: Compute TTV and Binary 24-hour Activation Flags
SELECT
    e.user_id,
    e.created_at,
    e.cohort,
    e.newsletter_subscribed,
    e.rageclick_count,
    
    -- Elapsed Hours
    dateDiff('hour', e.created_at, up.first_upload_at) as time_to_upload_analysis,
    dateDiff('hour', e.created_at, a.first_analysis_at) as time_to_first_analysis,
    dateDiff('hour', e.created_at, d.first_downloaded_at) as time_to_first_download,
    
    -- Volumetric Counts
    ifNull(up.upload_count, 0) as upload_count,
    ifNull(d.download_count, 0) as download_count,
    ifNull(a.analysis_completed_count, 0) as analysis_completed_count,
    
    -- Binary 24-Hour Behavioral Flags
    CASE WHEN ifNull(dateDiff('hour', e.created_at, up.first_upload_at), 50) < 24 THEN 1 ELSE 0 END as has_uploaded_video_24h,
    CASE WHEN ifNull(dateDiff('hour', e.created_at, a.first_analysis_at), 50) < 24 THEN 1 ELSE 0 END as has_analyzed_video_24h,
    CASE WHEN ifNull(dateDiff('hour', e.created_at, d.first_downloaded_at), 50) < 24 THEN 1 ELSE 0 END as has_downloaded_video_24h

FROM
    event_table as e
LEFT JOIN
    analysis_count as a ON e.user_id = a.user_id
LEFT JOIN
    download_count as d ON e.user_id = d.user_id
LEFT JOIN
    video_upload as up ON e.user_id = up.user_id;
