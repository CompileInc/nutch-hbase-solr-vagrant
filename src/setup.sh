#! /bin/bash

BUILD=0
while getopts ":b" opt; do
  case $opt in
    b)
      BUILD=1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

BUILD_HOME='/home/vagrant/compile-crawler'
PKG_DIR='pkgs'
SOURCE_DIR='source'

if [ "$BUILD" -eq "1" ]
then
wget -P $PKG_DIR https://archive.apache.org/dist/nutch/2.3/apache-nutch-2.3-src.tar.gz
tar -xvf $PKG_DIR/apache-nutch-2.3-src.tar.gz -C $BUILD_HOME
wget -P $PKG_DIR https://archive.apache.org/dist/hbase/hbase-0.94.14/hbase-0.94.14.tar.gz
tar -xvf $PKG_DIR/hbase-0.94.14.tar.gz -C $BUILD_HOME
wget -P $PKG_DIR https://archive.apache.org/dist/lucene/solr/4.10.3/solr-4.10.3.tgz
tar -xvf $PKG_DIR/solr-4.10.3.tgz -C $BUILD_HOME
fi

sleep 1
echo "Copying Solr config"
cp -r $SOURCE_DIR/solr $BUILD_HOME/solr-4.10.3/

sleep 1
echo "Copying hbase config"
cp -r $SOURCE_DIR/hbase $BUILD_HOME/hbase-0.94.14/

sleep 1
echo "Copying Nutch config"
cp -r $SOURCE_DIR/nutch $BUILD_HOME/apache-nutch-2.3

if [ "$BUILD" -eq "1" ]
then
echo "Building Nutch"
cd $NUTCH_HOME
ant runtime
fi

echo "INSTRUCTIONS:"
echo "Start solr: java -jar start.jar"
echo "Start hbase: bin/start_hbase.sh"
echo "Start nutch by injecting few urls and running crawls. Read more here: http://wiki.apache.org/nutch/Nutch2Tutorial"
