#!/bin/bash

#Enable transform secrets engine
vault secrets enable transform

#Setup FPE transform for email
vault write transform/transformations/fpe/fpe-email \
     template="fpe-email-tmpl" \
     tweak_source=internal \
     allowed_roles=payments

# Create a new alphabet for the fpe email transform to use
vault write transform/alphabet/alphanumeric-plus alphabet="abcdefghijklmnopqrstuvwxyzABCDEFGHIJCKLMNOPQRSTUVWXYZ-_@.0123456789#"

# Create a new template for the fpe email transform
vault write transform/template/fpe-email-tmpl type=regex \
    pattern="(.+)@.+" \
    alphabet=alphanumeric-plus

# The regex below should enable format preserving for email addresses of format
# fake-email@fake-domain.com but still work if the format differs from that
vault write transform/template/fpe-email-tmpl type=regex \
    pattern="(.+)-|(.+)@.+" \
    alphabet=alphanumeric-plus

# Enable the fpe email tweaked transform
vault write transform/transformations/fpe/fpe-email-tweaked \
     template="fpe-email-tmpl" \
     tweak_source=supplied \
     allowed_roles=payments

#Setup masking email template
vault write transform/template/mask-email-tmpl type=regex \
    pattern="(.+)@.+" \
#    alphabet=builtin/alphanumeric \
    alphabet=alphanumeric-plus

#Setup masking email transform to use the template
vault write transform/transformations/masking/mask-email \
    template=mask-email-tmpl \
    masking_character=# \
    allowed_roles=payments

#Setup token transform for email
vault write transform/transformations/tokenization/tokenize-email \
    allowed_roles=payments \
    max_ttl=24h

#Configure date-time fpe transform
vault write transform/template/date-time type=regex pattern="(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})"  alphabet=builtin/numeric

vault write transform/transformations/fpe/date-time template=date-time  tweak_source=internal  allowed_roles=payments

# Configure credit card number transform

vault write transform/transformations/fpe/card-number \
    template="builtin/creditcardnumber" \
    tweak_source=internal \
    allowed_roles=payments

# Configure decimal transform
vault write transform/template/decimal type=regex pattern="(\d{2}).(\d{15})" alphabet=builtin/numeric

vault write transform/transformations/fpe/decimal template=decimal tweak_source=internal allowed_roles=payments

# Enable the payments role for all the transforms
vault write transform/role/payments transformations=card-number,decimal,date-time,mask-email,tokenize-email,fpe-email,fpe-email-tweaked

# Test transforms
vault write transform/encode/payments value="fake-name@fake-domain.com" transformation=fpe-email

vault write transform/encode/payments value="fake-name@fake-domain.com" transformation=mask-email

vault write transform/encode/payments value="fake-name@fake-domain.com" transformation=tokenize-email

vault write transform/encode/payments value="fake-name@fake-domain.com" \
     transformation=tokenize-email \
     ttl=8h \
     metadata="Organization=HashiCorp" \
     metadata="Product=Vault" \
     metadata="Purpose=Benchmarks"