#!/bin/bash
SAXON_PATH=/Users/ba2213/bin/SaxonHE9-5-1-7J/saxon9he.jar
java -cp $SAXON_PATH net.sf.saxon.Transform -s:marc/ggva -o:. -xsl:xslt/aviador2members.xsl
java -cp $SAXON_PATH net.sf.saxon.Transform -s:marc/ferriss -o:. -xsl:xslt/aviador2members.xsl
