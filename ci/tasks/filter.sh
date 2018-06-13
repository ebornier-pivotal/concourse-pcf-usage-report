#!/bin/bash


#cat $1 | jq -r '.organizations[].name,name'

#cat $1

#cat $1 | jq -r '.organizations[] | [.name, .total_app_instance_count|tostring]| join(" ; ")' 

#cat $1 | jq -r '.organizations[] |  [.name, .spaces[].name] ' 

#cat $1 | jq -r '.organizations[] | [.name, .spaces[] | [.name, .name] ]'' 


#.organizations[] | [.name + " " +  .spaces[].name + " " +  .spaces[].total_app_instance_count|tostring]

#.organizations[] | [.name + " " +  .spaces[].name + " " +  (.spaces[].guid|tostring)]


#
#        PCF_API_ENDPOINT: {{pcf-api-endpoint}}
#        PCF_APPS_DOMAIN: {{pcf-apps-domain}}
#        SYS_ADMIN_USER: {{pcf-sys-admin-user}}
#        SYS_ADMIN_PASSWORD: {{pcf-sys-admin-user-password}}
#        PCF_ORG: {{pcf-org}}
#        PCF_SPACE: {{pcf-space}}

# set -x

echo "org;org_ai;space;space_ai"

# cat $2 | jq -r '
# .organizations[] | [ .name  + " ; " + (.total_app_instance_count|tostring) + " ; " +  (.spaces[] | [ .name , .total_app_instance_count|tostring]| join(" ; ") ) ]' | grep ";" | tr -d ' ' | tr -d '"' | tr -d ','

echo "init"

org_ids=$(cf curl /v2/organizations| jq -r ".resources[].metadata.guid")
total_ai_count=0

for org_id in $org_ids; do

  org=`cf curl /v2/organizations/$org_id`

  org_name=`echo $org | jq -r ".entity.name"`
  org_creation_date=`echo $org | jq -r ".metadata.created_at"`
  org_ai_count=0

  upper_1=$(echo $1 | tr '[:lower:]' '[:upper:]')
  upper_org_name=$(echo $org_name | tr '[:lower:]' '[:upper:]')


  if [[ "$upper_org_name" = *"$upper_1"* ]] || [[ "$org_name" = "system" ]];
  then
    echo "ignore" $org_name
  else
    echo "Browsing  : " $org_name
    space_ids=$(cf curl /v2/organizations/$org_id/spaces| jq -r ".resources[].metadata.guid")


  for space_id in $space_ids; do
    space_name=`cf curl /v2/spaces/$space_id/summary  | jq -r ".name"`
    space_ai_count=0
    # echo ">>" $space_id
    app_ids=$(cf curl /v2/spaces/$space_id/apps| jq -r ".resources[].metadata.guid")

  for app_id in $app_ids; do
     echo ++ $app_id

    state=$(cf curl /v2/apps/$app_id/summary | jq -r ".state")
    #  echo $app_id;

    if [[ "$state" = *"STARTED"* ]] ;
    then
       total_ai_count=$((total_ai_count + 1))
       org_ai_count=$((org_ai_count + 1))
       space_ai_count=$((space_ai_count + 1))
    fi

  done
    echo "$org_name;$org_id;$org_creation_date;$space_name;$space_ai_count" 
  done
  fi
done

echo "AI : " $total_ai_count
