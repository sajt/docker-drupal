# docker pull php:cli 
# docker run -ti -v $PWD/xml.php:/xml.php php:cli php /xml.php > /tmp/versions
IFS=" "
while read version fullVersion url md5
do
    echo "Build: $fullVersion, Tag: $version"
    BUILDKIT_PROGRESS=plain docker build --build-arg="DRUPAL_VERSION=$fullVersion" -t sajt/drupal:$version .
    docker push sajt/drupal:$version
    echo "Build: $fullVersion, Tag: $fullVersion"
    BUILDKIT_PROGRESS=plain docker build --build-arg="DRUPAL_VERSION=$fullVersion" -t sajt/drupal:$fullVersion .
    docker push sajt/drupal:$fullVersion
    if [ "$version" == "9.1" ]; then
        echo "Build: $fullVersion, Tag: latest"
        BUILDKIT_PROGRESS=plain docker build --build-arg="DRUPAL_VERSION=$fullVersion" -t sajt/drupal:latest .
        docker push sajt/drupal:latest
    fi
done < versions