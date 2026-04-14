with x as(

select 

    -- Date field: bulletproof parsing with CASE for multiple formats
    case
        -- Format: DD/MM/YYYY H:MM (e.g., "31/10/2023 0:00")
        when date like '%/%' and date not like '%:%:%' then parse_timestamp('%d/%m/%Y %H:%M', date)
        
        -- Format: YYYY-MM-DD HH:MM:SS (e.g., "2023-01-12 00:00:00")
        when date like '%-%' and date like '%:%:%' then parse_timestamp('%Y-%m-%d %H:%M:%S', date)
        
        -- Format: Day Mon DD HH:MM:SS UTC YYYY (e.g., "Thu Jan 12 00:00:00 UTC 2023")
        when date like '%UTC%' then parse_timestamp('%a %b %d %H:%M:%S UTC %Y', date)
        
        -- Format: YYYY/MM/DD HH:MM:SS (e.g., "2023/01/12 00:00:00")
        when date like '%/%' and date like '%:%:%' then parse_timestamp('%Y/%m/%d %H:%M:%S', date)
        
        -- Fallback: try to cast directly
        else cast(date as timestamp)
    end as date,
    
    -- String dimensions
    cast(channel as string) as channel,
    cast(country as string) as country,
    cast(city as string) as city,
    cast(sales_rep as string) as sales_rep,
    cast(account_manager as string) as account_manager,
    
    -- Numeric metrics: cast to FLOAT64 (or NUMERIC for currency)
    cast(spend as float64) as spend, 
    cast(impression as int64) as impression,
    cast(cpm as float64) as cpm,
    cast(unique_visitors as int64) as unique_visitors,
    cast(click_through_rate as float64) as click_through_rate,
    cast(opt_ins as int64) as opt_ins,
    cast(landing_page_conversion as float64) as landing_page_conversion,
    cast(number_of_bookings as int64) as number_of_bookings,
    cast(number_of_showups as int64) as number_of_showups,
    cast(show_up_rate as float64) as show_up_rate,
    cast(close_rate as float64) as close_rate,
    cast(customer_acquisition_cost as float64) as customer_acquisition_cost,
    cast(customer_lifetime_value as float64) as customer_lifetime_value,
    cast(cac_payback_period as int64) as cac_payback_period,
    cast(time_to_conversion as int64) as time_to_conversion

from {{ source('bigquery', 'service_based_business_database_service_based_business_database_csv') }}

) 
select * from x