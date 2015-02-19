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

BUILD_HOME='/home/'$USER'/compile-crawler'
PKG_DIR='pkgs'
SOURCE_DIR='source'

NUTCH_SRC=$PKG_DIR/apache-nutch-2.3-src.tar.gz
HBASE_SRC=$PKG_DIR/hbase-0.94.14.tar.gz
SOLR_SRC=$PKG_DIR/solr-4.10.3.tgz

if [ "$BUILD" -eq "1" ]
then
    if [ ! -f $NUTCH_SRC ]
    then
        wget -P $PKG_DIR https://archive.apache.org/dist/nutch/2.3/apache-nutch-2.3-src.tar.gz
    fi
    tar -xvf $NUTCH_SRC -C $BUILD_HOME

    if [ ! -f $HBASE_SRC ]
    then
        wget -P $PKG_DIR https://archive.apache.org/dist/hbase/hbase-0.94.14/hbase-0.94.14.tar.gz
    fi
    tar -xvf $HBASE_SRC -C $BUILD_HOME

    if [ ! -f $SOLR_SRC ]
    then
        wget -P $PKG_DIR https://archive.apache.org/dist/lucene/solr/4.10.3/solr-4.10.3.tgz
    fi
    tar -xvf $SOLR_SRC -C $BUILD_HOME
fi

sleep 1
echo "Copying Solr config"
cp -r $SOURCE_DIR/solr/* $BUILD_HOME/solr-4.10.3/

sleep 1
echo "Copying hbase config"
cp -r $SOURCE_DIR/hbase/* $BUILD_HOME/hbase-0.94.14/

sleep 1
NUTCH_HOME=$BUILD_HOME/apache-nutch-2.3
echo "Copying Nutch config"
cp -r $SOURCE_DIR/nutch/* $NUTCH_HOME

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
