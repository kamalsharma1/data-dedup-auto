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
                                   event_datetime 
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
                                                     row_number() OVER (partition BY po_id, garment_id, sku_id, event_type, event_subtype, location_id, location_desc, expected_rentals, quantity_received, cast(unit_cost AS string) ORDER BY event_datetime ) row_number
                                            FROM     `BQ_TABLE_NAME` ) 
                            WHERE  row_number > 1) dup 
              WHERE  tab.po_id = dup.po_id 
              AND    tab.garment_id = dup.garment_id 
              AND    tab.sku_id = dup.sku_id 
              AND    tab.event_type = dup.event_type 
              AND    tab.event_subtype = dup.event_subtype 
              AND    tab.location_id = dup.location_id 
              AND    tab.location_desc = dup.location_desc 
              AND    tab.expected_rentals = dup.expected_rentals 
              AND    tab.quantity_received = dup.quantity_received 
              AND    cast(tab.unit_cost AS string) = cast(dup.unit_cost AS string) 
              AND    tab.event_datetime = dup.event_datetime )