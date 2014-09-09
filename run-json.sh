#!/bin/bash
SAXON_PATH=/Users/benjamin/bin/SaxonHE9-5-1-7J/saxon9he.jar
for f in `find marc -name "*.xml"`; do
  java -cp $SAXON_PATH net.sf.saxon.Transform -s:$f -xsl:xslt/aviador2members.xsl
done