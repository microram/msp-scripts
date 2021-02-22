#!/bin/bash
# Upload newest backup file to S3
/root/.local/bin/aws s3 cp `ls -1t /var/lib/vz/dump/vzdump-qemu-100-*.gz | head -1` s3://backup_bucket/clients/clientname/vm/