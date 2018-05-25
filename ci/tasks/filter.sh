#!/bin/bash


#cat $1 | jq -r '.organizations[].name,name'

#cat $1

#cat $1 | jq -r '.organizations[] | [.name, .total_app_instance_count|tostring]| join(" ; ")' 

#cat $1 | jq -r '.organizations[] |  [.name, .spaces[].name] ' 

#cat $1 | jq -r '.organizations[] | [.name, .spaces[] | [.name, .name] ]'' 


#.organizations[] | [.name + " " +  .spaces[].name + " " +  .spaces[].total_app_instance_count|tostring]

#.organizations[] | [.name + " " +  .spaces[].name + " " +  (.spaces[].guid|tostring)]

cat $1 | jq -r '.organizations[] | [ .name  + " ; " +   (.spaces[] | [ .name , .total_app_instance_count|tostring]| join(" ; ") ) ]' 