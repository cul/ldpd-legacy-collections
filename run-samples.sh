#!/bin/bash
SAXON_PATH=/Users/ba2213/bin/SaxonHE9-5-1-7J/saxon9he.jar
java -cp $SAXON_PATH net.sf.saxon.Transform -s:marc/ferriss/3459595_marc.xml -xsl:xslt/aviador2mods.xsl
java -cp $SAXON_PATH net.sf.saxon.Transform -s:marc/ferriss/3459888_marc.xml -xsl:xslt/aviador2mods.xsl
java -cp $SAXON_PATH net.sf.saxon.Transform -s:marc/ferriss/3460530_marc.xml -xsl:xslt/aviador2mods.xsl
java -cp $SAXON_PATH net.sf.saxon.Transform -s:marc/ferriss/3460015_marc.xml -xsl:xslt/aviador2mods.xsl
java -cp $SAXON_PATH net.sf.saxon.Transform -s:marc/ggva/3464646_marc.xml -xsl:xslt/aviador2mods.xsl
java -cp $SAXON_PATH net.sf.saxon.Transform -s:marc/ggva/3464644_marc.xml -xsl:xslt/aviador2mods.xsl
java -cp $SAXON_PATH net.sf.saxon.Transform -s:marc/ggva/3462131_marc.xml -xsl:xslt/aviador2mods.xsl