#!/bin/bash

y=$(w | grep -v root | grep `logname` | wc -l)

if 

    [ $y -gt 1 ]

then

    echo "Multiple sessions detected for" `logname`

sleep 5

    echo "Terminating your session"

sleep 5

exit

fi