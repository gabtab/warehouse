import os
from sendgrid import SendGridAPIClient
from sendgrid.helpers.mail import Mail

message = Mail(
    from_email='info@happyhusky.ie',
    to_emails='byrne.gavin5@gmail.com',
    subject='Warehouse Update',
    plain_text_content='The warehouse has been updated')

try:
    sg = SendGridAPIClient(os.environ.get('MAIL_KEY'))
    response = sg.send(message)
    print(response.status_code)
    print(response.body)
    print(response.headers)
except Exception as e:
    print(str(e))