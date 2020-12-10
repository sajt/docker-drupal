myBuild() {
    RED='\033[5;31m'
    NC='\033[0m' # No Color
    echo -e "${RED}Build${NC}: $buildVersion, Tag: $tagVersion"
    docker build --build-arg="DRUPAL_VERSION=$buildVersion" -t sajt/drupal:$tagVersion --no-cache .
    docker tag drupal:$tagVersion sajt/drupal:$tagVersion
    docker push sajt/drupal:$tagVersion
}


# docker pull php:cli 
# docker run -ti -v $PWD/xml.php:/xml.php php:cli php /xml.php > /tmp/versions
# IFS=" "
version=9.1
fullVersion=9.1.0
# url=https://ftp.drupal.org/files/projects/drupal-9.1.0.tar.gz #not used
# while read version fullVersion url md5
#do

    buildVersion=$fullVersion
    tagVersion=$version
    myBuild

    buildVersion=$fullVersion
    tagVersion=$fullVersion
    myBuild

    if [ "$version" == "9.1" ]; then
        buildVersion=$fullVersion
        tagVersion="latest"
        myBuild
    fi
#done < versions

