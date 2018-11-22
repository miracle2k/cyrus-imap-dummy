cyrus-imapd-dummy
-----------------

A docker image that runs a Cyrus IMAP server, with JMAP support.

It requires no password, accepts any user and password combination
and starts new users off with an empty mailbox.

The idea is to use this for testing IMAP clients, and in particular,
Cyrus is built here with JMAP support, so it's a nice playground for
JMAP.


Usage
-----

Run the image (not on the docker hub currently)::

    docker run -it -p 144:143 -p 80:8080 cyrus


Send a JMAP request:

    curl -X POST -H "Content-Type: application/json" -H "Accept: application/json" --user test:test -d '{"using": [], "methodCalls": [["Mailbox/query", {}, "#1"]]}' http://localhost:80/jmap/

NOTE: This will currently fail, unless the user previously logged in through IMAP
(message: could not autoprovision calendars). Might be a bug in Cyrus.
