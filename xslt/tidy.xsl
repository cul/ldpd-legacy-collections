<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:MODS="http://www.loc.gov/mods/v3"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:functx="http://www.functx.com"
    exclude-result-prefixes="xd" version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Jan 22, 2013</xd:p>
            <xd:p><xd:b>Author:</xd:b> terry</xd:p>
            <xd:p>Various templates to clean up MODS records</xd:p>
        </xd:desc>
    </xd:doc>

    <!-- Identity Template -->
    <!-- Whenever you match any node or any attribute -->
    <xsl:template match="node()|@*">
        <!-- Copy the current node -->
        <xsl:copy>
            <!-- Including any attributes it has and any child nodes -->
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    <!-- strip elements not defined as empty which have no content       -->
    <xsl:template
        match="*[normalize-space() = ''][not(child::*)]"><xsl:comment><xsl:text>EMPTY ELEMENT&#160; </xsl:text><xsl:value-of select="name()"/><xsl:text>&#160; REMOVED</xsl:text></xsl:comment></xsl:template>
    
    <!-- Remove period after creator name -->
    
    <xsl:template match="MODS:namePart">
        <xsl:element name="MODS:namePart">
            <xsl:copy-of select="@*"/>
            <xsl:value-of select="replace(., '^(.*)[\.:,]$', '$1')"/>
        </xsl:element>
    </xsl:template>
    
    <!-- Remove trailing whitespace -->
    
    <xsl:template match="MODS:title">
        <xsl:comment><xsl:text>ELEMENT&#160; </xsl:text><xsl:value-of select="name()"/><xsl:text>&#160; SPACE-NORMALIZED</xsl:text></xsl:comment>
        <xsl:element name="MODS:title">
            <xsl:copy-of select="@*"/>
            <xsl:value-of select="normalize-space(replace(replace(., '\.,', ','), ' ;', ';'))"/>
        </xsl:element>
    </xsl:template>
    
    <!-- Remove trailing punctuation -->
    
    <xsl:template match="MODS:shelfLocator | MODS:identifier">
        <xsl:comment><xsl:text>ELEMENT&#160; </xsl:text><xsl:value-of select="name()"/><xsl:text>&#160; trailing punctuation removed</xsl:text></xsl:comment>
        <xsl:element name="{name()}">
            <xsl:copy-of select="@*"/>
            <xsl:value-of select="replace(., '^(.*)[\.:,]$', '$1')"/>
        </xsl:element>
    </xsl:template>


</xsl:stylesheet>
