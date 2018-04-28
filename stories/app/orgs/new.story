###
Create a new organization
###

# username: Organization GitHub username
# type: installation type (managed, shared, enterprise)
# region:

psql """
[TODO] insert new org
"""

# [TODO] create new google account
g = gcp create_account

# [TODO] bootstrap kubernetes stack stack
k = gke ...
cluster =

# create dns record
dnsimple new_dns
  --domain asyncyapp.com
  --type 'A'
  --name username
  --ip cluster.ip
