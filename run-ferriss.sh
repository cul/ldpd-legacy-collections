#!/bin/bash
SAXON_PATH=/Users/benjamin/bin/SaxonHE9-5-1-7J/saxon9he.jar
#java -cp $SAXON_PATH net.sf.saxon.Transform -s:marc/ferriss/3459595_marc.xml -xsl:xslt/aviador2mods.xsl
#java -cp $SAXON_PATH net.sf.saxon.Transform -s:marc/ferriss/3459888_marc.xml -xsl:xslt/aviador2mods.xsl
#java -cp $SAXON_PATH net.sf.saxon.Transform -s:marc/ggva/3464644_marc.xml -xsl:xslt/aviador2mods.xsl
#java -cp $SAXON_PATH net.sf.saxon.Transform -s:marc/ggva/3462131_marc.xml -xsl:xslt/aviador2mods.xsl
for f in `find marc/ferriss -name "*.xml"`; do
  java -cp $SAXON_PATH net.sf.saxon.Transform -s:$f -xsl:xslt/aviador2mods.xsl
done