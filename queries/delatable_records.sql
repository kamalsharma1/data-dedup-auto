SELECT po_id, 
       garment_id, 
       sku_id, 
       event_type, 
       event_subtype,
       event_datetime,
       unit_cost, 
       location_id, 
       location_desc, 
       expected_rentals, 
       quantity_received 
    FROM   ( 
            SELECT   po_id, 
                     garment_id, 
                     sku_id, 
                     event_type, 
                     event_subtype,
                     event_datetime,
                     unit_cost, 
                     location_id, 
                     location_desc, 
                     expected_rentals, 
                     quantity_received, 
                     row_number() OVER (partition BY po_id, garment_id, sku_id, event_type, event_subtype, location_id, location_desc, expected_rentals, quantity_received, cast(unit_cost AS string) ORDER BY event_datetime ) row_number
            FROM     `BQ_TABLE_NAME` ) 
WHERE  row_number > 1