#!/bin/bash
SAXON_PATH=/Users/ba2213/bin/SaxonHE9-5-1-7J/saxon9he.jar
java -cp $SAXON_PATH net.sf.saxon.Transform -s:marc/ggva/3464644_marc.xml -xsl:xslt/ggva2mods.xsl
#for f in `find marc/ggva -name "*.xml"`; do
#  java -cp $SAXON_PATH net.sf.saxon.Transform -s:$f -xsl:xslt/ggva2mods.xsl
#done