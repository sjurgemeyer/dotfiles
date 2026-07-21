#!/bin/bash

/opt/homebrew/bin/icalBuddy -npn -nc -ps "/\n/" -iep "title,datetime,attendees,location" -po "title, datetime, attendees, location" -ps '|\n|\n[[@|]]\n|' -b "\n### " -tf "%H:%M" -ic "Calendar" eventsToday | sed -E 's/, /\]\] \[\[@/g' | sed -E 's/\[\[@Shaun Jurgemeyer\]\]//g' | sed -E 's/ - IAA//g' | sed -E 's/^ //g' | sed -E 's/^Microsoft Teams Meeting$//g'
f  
