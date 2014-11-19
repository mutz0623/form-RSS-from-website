#!/bin/sh


cat <<EOT
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:sy="http://purl.org/rss/1.0/modules/syndication/"
	xmlns:admin="http://webns.net/mvcb/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">

	<channel>
		<title>TITLE</title>
		<link>URL</link>
		<description>[generatedRSS]DESCRIPTION</description>
		<dc:language>ja</dc:language>
		<dc:creator>CREATER</dc:creator>
		<dc:date>`date "+%F %T"`</dc:date>
EOT

curl URL 2>/dev/null|
nkf -wLu |
awk '/START/ , /END/' |
sed -r -e "s/patern//g" |
while read LINE
do
 
  #echo "$LINE"
  ITEM_TITLE="$(echo "$LINE" |cut -d"," -f1)"
  ITEM_URL="$(echo "$LINE" |cut -d"," -f2)"
  ITEM_DATE="$(date -R -d "$( echo "$LINE" |cut -d"," -f3 |sed -r "s/^(....)-(..)-(..)-(..)-(..)$/\1\/\2\/\3 \4:\5/" )" )"
  ITEM_DESC="$(echo "$LINE" |cut -d"," -f4)"

  echo "                <item>"
  echo "                <title>`echo "$ITEM_TITLE"`</title>"
  echo "                <link>`echo "$ITEM_URL"`</link>"
  echo "                <description>`echo "$ITEM_DESC"`</description>"
  echo "                <dc:date>`echo "$ITEM_DATE"`</dc:date>"
  echo "                </item>"
done


cat <<EOT
	</channel>
</rss>
EOT
