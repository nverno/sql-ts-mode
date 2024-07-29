

MERGE INTO accounts t
  USING monthly_accounts_update s
  ON t.customer = s.customer
    WHEN MATCHED
        THEN DELETE

;



MERGE INTO accounts t
USING monthly_accounts_update s
  ON (t.customer = s.customer)
  WHEN MATCHED
  THEN UPDATE SET purchases = s.purchases + t.purchases
  WHEN NOT MATCHED
  THEN INSERT (customer, purchases, address)
  VALUES(s.customer, s.purchases, s.address)

;



MERGE INTO accounts t
USING monthly_accounts_update s
    ON (t.customer = s.customer)
    WHEN MATCHED AND s.address = 'Centreville'
        THEN DELETE
    WHEN MATCHED
        THEN UPDATE
            SET purchases = s.purchases + t.purchases, address = s.address
    WHEN NOT MATCHED
        THEN INSERT (customer, purchases, address)
              VALUES(s.customer, s.purchases, s.address)

;
