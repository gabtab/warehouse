@echo off

REM 1. Activate the virtual environment
call ..\venv\Scripts\activate

REM Check if the virtual environment is activated
IF NOT DEFINED VIRTUAL_ENV (
    echo Failed to activate virtual environment
    exit /b
)
echo Activated virtual environment successfully

REM 2. Check if port 4000 is in use and kill the process if it is
FOR /F "tokens=5" %%P IN ('netstat -ano ^| findstr :4000') DO (
    IF NOT "%%P"=="0" (
        echo Killing process on port 4000 with PID: %%P
        taskkill /F /PID %%P
    )
)

REM Create a port tunnel 
start /B ssh -i ~/.ssh/hh-for-jump.pem -L 4000:hhdatabasev2.c1mrowwap63w.eu-west-1.rds.amazonaws.com:5432 jumpbox -N
IF %ERRORLEVEL% NEQ 0 (
    echo Failed to create first port tunnel
    exit /b
)
echo Created first port (4000) tunnel successfully

REM 3. Check if port 4001 is in use and kill the process if it is
FOR /F "tokens=5" %%P IN ('netstat -ano ^| findstr :4001') DO (
    IF NOT "%%P"=="0" (
        echo Killing process on port 4001 with PID: %%P
        taskkill /F /PID %%P
    )
)

start /B ssh -i ~/.ssh/hh-for-jump.pem -L 4001:hhdatabasev2.c1mrowwap63w.eu-west-1.rds.amazonaws.com:5432 jumpbox -N
IF %ERRORLEVEL% NEQ 0 (
    echo Failed to create second port tunnel
    exit /b
)
echo Created 2nd port (4001) tunnel successfully

REM 4. Run Python scripts for loading your warehouse
python ..\ingestion\stripe_sessions.py
IF %ERRORLEVEL% NEQ 0 (
    echo Failed to run stripe_sessions.py
    exit /b
)
echo Ran stripe_sessions.py successfully

python ..\ingestion\stripe_transactions.py
IF %ERRORLEVEL% NEQ 0 (
    echo Failed to run stripe_transactions.py
    exit /b
)
echo Ran stripe_transactions.py successfully

python ..\ingestion\sumup.py
IF %ERRORLEVEL% NEQ 0 (
    echo Failed to run sumup.py
    exit /b
)
echo Ran sumup.py successfully

REM 5. Run dbt
dbt run
IF %ERRORLEVEL% NEQ 0 (
    echo Failed to run dbt
    exit /b
)
echo Ran dbt run successfully

REM This is an example using the `Send-MailMessage` cmdlet, replace with your actual notification command
Send-MailMessage -SmtpServer your_smtp_server -To "your_email@example.com" -From "your_email@example.com" -Subject "Warehouse Update" -Body "The warehouse has been updated"
IF %ERRORLEVEL% NEQ 0 (
    echo Failed to send email
    exit /b
)

REM 6. Run Superset command to get dashboard up
REM You might need to specify the full path to the superset executable
superset runserver
IF %ERRORLEVEL% NEQ 0 (
    echo Failed to run Superset
    exit /b
)