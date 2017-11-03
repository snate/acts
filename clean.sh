#!/bin/bash
################################################################################
# Remove docker related files
################################################################################
level=

function help
{
   exit_code=${1:-}
   echo "Usage: "$0" -l [option]"
   echo "   -l :     clean level:"
   echo "               0 : (light) removes only local generated templates and pending unnamed images"
   echo "               1 : (medium-volumes) removes as light + prunes all unused volumes (requires confirmation by the user) + view_default network"
   echo "               2 : (medium-containers) medium-volumes + all the existing containers which are NOT running (no swarm mode)"
   echo "               3 : (deep-swarm) removes as medium-containers + stops and removes all the existing stacks of services generated by swarm"
   echo "Example:"
   echo "   (deep clean)"
   echo "   $0 -l 3"
   echo ""

   if [ -z "$exit_code" ];
   then
      exit 0;
   fi
   exit $exit_code
}


# get options
{
   l_flag=0;
   while getopts l: name
   do
       case $name in
       l)   l_flag=$(( l_flag+1 ))
            $CITY_ROOT/config/utils/check_flag.sh "$l_flag" "2" "-l"
            level=${OPTARG:-};;
       ?)   help "1";;
       esac
   done
   if [ -z "$level" ];
   then
      help
   fi
}
##### light level -l 0
# remove generated templates
if [ -f $CITY_ROOT/config/backend/Dockerfile ];
then
   rm $CITY_ROOT/config/backend/Dockerfile
fi
if [ -f $CITY_ROOT/config/mw/Dockerfile ];
then
   rm $CITY_ROOT/config/mw/Dockerfile
fi
if [ -f $CITY_ROOT/config/fe/Dockerfile ];
then
   rm -f $CITY_ROOT/config/fe/Dockerfile
fi
if [ -f $CITY_ROOT/config/fe_postgres/init-user-db.sh ];
then
   rm -f $CITY_ROOT/config/fe_postgres/init-user-db.sh
fi
if [ -f $CITY_ROOT/config/templates/backend-mw.template ];
then
   rm $CITY_ROOT/config/templates/backend-mw.template
fi
if [ -f $CITY_ROOT/config/templates/backend-mw-fe.template ];
then
   rm $CITY_ROOT/config/templates/backend-mw-fe.template
fi
# remove generated docker-compose files
files=($(ls $CITY_ROOT/config/ | grep docker-compose.*))
if [ ! ${#files[@]} -eq 0 ]; then
   for file in "${files[@]}"
   do
      rm $CITY_ROOT/config/$file
   done
fi
# remove pending unnamed images
docker rmi $(docker images | grep "^<none>" | awk "{print $3}")
# medium-volumes level
if [[ ( "$level" > 0 ) ]];
then
   docker network rm view_default
   docker network rm 0_default
   docker network rm 1_default
   docker volume prune
fi
# medium-containers level
if [[ ( "$level" > 1 ) ]];
then
   docker rm $(docker ps -aq)
fi
# deep-swarm level
if [[ ( "$level" > 2 ) ]];
then
   docker stack rm $(docker stack ls | cut -d' ' -f1 | tail -n +2)
fi