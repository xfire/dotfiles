#!/usr/bin/env python
#
# vim:syntax=python:sw=4:ts=4:expandtab

import sys
import imaplib
import re

hostname, username, password = sys.argv[1:4]
port = 993
if ':' in hostname:
    hostname, port = hostname.split(':')

list_response_pattern = re.compile(r'\((.*?)\) "(.*)" (?P<name>.*)')

def mailbox_name(line):
    mb = list_response_pattern.match(line).groupdict().get('name')
    mb = mb.strip('"').lstrip('INBOX.')
    return mb

connection = imaplib.IMAP4_SSL(hostname)
connection.login(username, password)
try:
    typ, data = connection.list()
    if typ == 'OK':
        mblist = (mailbox_name(d) for d in data)
        for mb in sorted([mb for mb in mblist if mb]):
            print mb
finally:
    connection.logout()
