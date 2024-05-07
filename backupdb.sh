#!/bin/bash
mysqldump -u root --password="********" --all-databases > nrtechdb.`date +%d%m%y%H%M%S`.sql
mv  nrtechdb* /home/backups/
cd /home/backups
aws s3 cp nrtechdb* s3://nrtechbackups/db_backups/
rm -f /home/backups/*