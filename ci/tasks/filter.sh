#!/bin/bash


#cat $1 | jq -r '.organizations[].name,name'

#cat $1

#cat $1 | jq -r '.organizations[] | [.name, .total_app_instance_count|tostring]| join(" ; ")' 

#cat $1 | jq -r '.organizations[] |  [.name, .spaces[].name] ' 

#cat $1 | jq -r '.organizations[] | [.name, .spaces[] | [.name, .name] ]'' 


#.organizations[] | [.name + " " +  .spaces[].name + " " +  .spaces[].total_app_instance_count|tostring]

#.organizations[] | [.name + " " +  .spaces[].name + " " +  (.spaces[].guid|tostring)]


echo "org;org_ai;space;space_ai"

cat $1 | jq -r '
.organizations[] | [ .name  + " ; " + (.total_app_instance_count|tostring) + " ; " +  (.spaces[] | [ .name , .total_app_instance_count|tostring]| join(" ; ") ) ]' | grep ";" | tr -d ' ' | tr -d '"' | tr -d ','
