---
title: "Fixing problem with ODBC connection in RStudio on Mac M1"
description: "Fixing problems with ODBC connections"
url: "/2024/odbc-mac-m1"
date: "2024-08-24T1:00:00-07:00"
draft: true
tags: [til, odbc,sql, R]
---

Example QMD file below:

````
---
title: "SQLite Database Creation and Connection Demo"
format: html
editor: visual
---

## Setup

First, we'll load the necessary libraries and set up our file paths.

```{r setup}
#| message: false
#| warning: false
Sys.setenv(ODBCSYSINI = "/opt/homebrew/etc")
library(RSQLite)
library(DBI)
library(odbc)
library(here)

# Define the database file path
db_path <here::here("sample_database.sqlite")

# Print the database path for verification
print(paste("Database path:", db_path))
```

## Create SQLite Database and Add Dummy Data

Now, let's create a SQLite database and populate it with some dummy data.

```{r create_db}
# Create a connection to a new SQLite database
con <dbConnect(RSQLite::SQLite(), dbname = db_path)

# Create a table
dbExecute(con, "CREATE TABLE IF NOT EXISTS employees (
            id INTEGER PRIMARY KEY,
            name TEXT,
            department TEXT,
            salary REAL
          )")

# Create some dummy data
employees <data.frame(
  name = c("Alice", "Bob", "Charlie", "David", "Eve"),
  department = c("HR", "IT", "Sales", "Marketing", "Finance"),
  salary = c(50000, 60000, 55000, 52000, 58000)
)

# Insert the dummy data into the table
dbWriteTable(con, "employees", employees, append = TRUE)

# Verify the data
result <dbGetQuery(con, "SELECT * FROM employees")
print(result)

# Close the connection
dbDisconnect(con)
```

## Connect to SQLite Database using ODBC

Now that we have created our SQLite database, let's connect to it using ODBC.

```{r odbc_connect}
# Create the connection string
conn_string <paste0("Driver={SQLite3};Database=", db_path, ";")

# Create an ODBC connection
con_odbc <dbConnect(odbc::odbc(), .connection_string = conn_string)

# This connection should now appear in the Connections pane

# Verify the connection by querying the data
result_odbc <dbGetQuery(con_odbc, "SELECT * FROM employees")
print(result_odbc)

# Don't forget to close the connection when you're done
dbDisconnect(con_odbc)
```

## Cleanup

If you want to remove the database file after running this demo, uncomment and run the following code:

```{r cleanup}
# Remove the database file
# file.remove(db_path)
```
````