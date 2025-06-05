#!/bin/bash

USERNAME=gorostis@gmail.com
PASSWORD=pa55w0rd
CLIENT_ID=220228fe-bdcd-4633-af38-b6385b7ad6a4
CLIENT_SECRET=5557bf9e-954f-4113-af98-4f265dfce500
USER_GROUP_KEY=gr20
USER_GROUP_NAME="Group 20"

echo "Client Id / Secret : ${CLIENT_ID} / ${CLIENT_SECRET}"
echo "User : ${USERNAME} / ${PASSWORD}"

BASE_URL="https://localhost:8443"
REALM_URL="${BASE_URL}/admin/realms/master"
# ----------------
# Get Admin Token
# ----------------
ADMIN_TOKEN=$(curl -k --location --request POST "${BASE_URL}/realms/master/protocol/openid-connect/token" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'client_id=admin-cli' \
--data-urlencode 'username=admin' \
--data-urlencode 'password=admin' \
--data-urlencode 'grant_type=password' | \
jq -r .access_token)

echo "admin token=${ADMIN_TOKEN}"

# --------------
# Create Client
# --------------
CLIENT_POST='{
  "id" : "_CLIENT_ID_",
  "name" : "Test Client",
  "secret" : "_CLIENT_SECRET_",
  "webOrigins" : ["https://dev-qtepl0vf.us.auth0.com/"],
  "redirectUris" : ["https://dev-qtepl0vf.us.auth0.com/login/callback"],
  "protocolMappers" : [
    {
      "name": "Group Name",
      "protocol": "openid-connect",
      "protocolMapper": "oidc-usermodel-attribute-mapper",
      "consentRequired": false,
      "config": {
        "userinfo.token.claim": "true",
        "user.attribute": "group-name",
        "id.token.claim": "true",
        "access.token.claim": "false",
        "claim.name": "group-name",
        "jsonType.label": "String"
      }
    },
    {
      "name": "Group Key",
      "protocol": "openid-connect",
      "protocolMapper": "oidc-usermodel-attribute-mapper",
      "consentRequired": false,
      "config": {
        "userinfo.token.claim": "true",
        "user.attribute": "group-key",
        "id.token.claim": "true",
        "access.token.claim": "false",
        "claim.name": "group-key",
        "jsonType.label": "String"
      }
    }
  ]
}'

CLIENT_POST=$(echo "${CLIENT_POST}" | \
  sed "s/_CLIENT_ID_/${CLIENT_ID}/" | \
  sed "s/_CLIENT_SECRET_/${CLIENT_SECRET}/")
echo "Client POST: ${CLIENT_POST}"

curl -k --verbose --location --request POST "${REALM_URL}/clients" \
--header "Authorization: Bearer ${ADMIN_TOKEN}" \
--header 'Content-Type: application/json' \
--data-raw "${CLIENT_POST}"

# ------------
# Create User
# ------------
USER_POST='{
  "username" : "_USERNAME_",
  "email" : "_USERNAME_",
  "emailVerified" : true,
  "enabled" : true,
  "firstName" : "Olivier",
  "lastName" : "Gorostis",
  "requiredActions" : [],
  "attributes" : {"group-key":"_GROUP_KEY_","group-name":"_GROUP_NAME_"},
  "credentials": [{"type": "password","temporary":false, "value":"_PASSWORD_"}]
}'

USER_POST=`echo "${USER_POST}" | \
sed "s/_GROUP_KEY_/${USER_GROUP_KEY}/g" | \
sed "s/_GROUP_NAME_/${USER_GROUP_NAME}/g" | \
sed "s/_USERNAME_/${USERNAME}/g" | \
sed "s/_PASSWORD_/${PASSWORD}/g"`
echo "User POST: ${USER_POST}"

curl -k --verbose --location --request POST "${REALM_URL}/users" \
--header "Authorization: Bearer ${ADMIN_TOKEN}" \
--header 'Content-Type: application/json' \
--data-raw "${USER_POST}"
