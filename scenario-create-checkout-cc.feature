Scenario Create successful credit card transaction
  Given a credit card payment number 0000 0000 0000 0000 exp 12/25 cvv 123
  When a transaction of 30.00 is received
  And Risk does not block the transaction
  Then the credit card process should be successful
