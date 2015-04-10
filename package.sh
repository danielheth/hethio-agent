#! /bin/bash

python setup.py \
--command-packages=stdeb.command debianize \
--suite `lsb_release -sc`


VERSION=`git tag | tail -n 1`

TOPLINE=`head -n 1 debian/changelog`
BOTTOMLINE=`tail -n 1 debian/changelog`

echo $TOPLINE > debian/changelog
echo "" >> debian/changelog
git shortlog $VERSION..HEAD | tail -n+2 | while read line
do
  if [ -n "$line" ]; then
    echo "  * $line" >> debian/changelog
  fi
done
echo "" >> debian/changelog
echo " $BOTTOMLINE" >> debian/changelog


VERSION=`cat VERSION.txt`
cp debian/changelog ./$VERSION.changes

python setup.py sdist
mv dist/hethio-agent* ./


BUILD=`cat ../hethio-agent*.build`
echo $BUILD



#  By convention, an 'exit 0' indicates success,
#+ while a non-zero exit value means an error or anomalous condition.
#  See the "Exit Codes With Special Meanings" appendix.
if [[ $BUILD == *"error"* ]]; then
	exit 1
fi