DELETE `BQ_TABLE_NAME` tab 
WHERE  EXISTS 
       ( 
              SELECT 1 
              FROM   ( 
                            SELECT po_id, 
                                   garment_id, 
                                   sku_id, 
                                   event_type, 
                                   event_subtype, 
                                   location_id, 
                                   location_desc, 
                                   expected_rentals, 
                                   quantity_received, 
                                   unit_cost, 
                                   event_datetime,
                                   dedupe_v1 
                            FROM   ( 
                                            SELECT   po_id, 
                                                     garment_id, 
                                                     sku_id, 
                                                     event_type, 
                                                     event_subtype, 
                                                     location_id, 
                                                     location_desc, 
                                                     expected_rentals, 
                                                     quantity_received, 
                                                     unit_cost, 
                                                     event_datetime,
                                                     dedupe_v1, 
                                                     row_number() OVER (partition BY po_id, garment_id, sku_id, event_type, event_subtype, location_id, location_desc, expected_rentals, quantity_received, cast(unit_cost AS string) ORDER BY event_datetime ) row_number
                                            FROM     `BQ_TABLE_NAME` ) 
                            WHERE  row_number > 1) dup 
              WHERE  tab.dedupe_v1 = dup.dedupe_v1
              AND    dup.dedupe_v1 IS NOT NULL
              )