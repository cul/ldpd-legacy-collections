<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs xd marc"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:marc="http://www.loc.gov/MARC21/slim"
    version="2.0">
    <xsl:output indent="yes" omit-xml-declaration="yes"/>
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Jan 2, 2013</xd:p>
            <xd:p><xd:b>Author:</xd:b> terry</xd:p>
            <xd:p><xd:b>Updated on:</xd:b> Sept, 2014</xd:p>
            <xd:p><xd:b>Author:</xd:b> barmintor</xd:p>
            <xd:p/>
        </xd:desc>
    </xd:doc>
    <xsl:param name="resultPath">
        <xsl:text>json/</xsl:text>
    </xsl:param>
    <xsl:param name="collection_id">
        <xsl:choose>
            <xsl:when test="contains(//marc:datafield[@tag = '110'][@ind1='2']/marc:subfield[@code = 'a'],'Greene &amp; Greene')">
                <xsl:text>ggva</xsl:text>
            </xsl:when>
            <xsl:when test="contains(//marc:datafield[@tag = '799']/marc:subfield[@code = 'a'],'Greene &amp; Greene')">
                <xsl:text>ggva</xsl:text>
            </xsl:when>
            <xsl:when test="contains(//marc:datafield[@tag = '773']/marc:subfield[@code = 'a'],'Greene &amp; Greene')">
                <xsl:text>ggva</xsl:text>
            </xsl:when>
            <xsl:when test="contains(string-join(//marc:datafield[@tag = '710'][@ind1='2']/marc:subfield[@code = 'a'],' '),'Greene &amp; Greene')">
                <xsl:text>ggva</xsl:text>
            </xsl:when>
            <xsl:when test="contains(string-join(//marc:datafield[@tag = '500']/marc:subfield[@code = 'a'],' '),'Greene &amp; Greene')">
                <xsl:text>ggva</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>ferriss</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:param>
    <xsl:param name="project">
        <xsl:choose>
            <xsl:when test="$collection_id = 'ggva'">
                <xsl:text>Greene &amp; Greene Project</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Hugh Ferriss Architectural Drawings</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:param> 
    <xsl:param name="project_url">
        <xsl:choose>
            <xsl:when test="$collection_id = 'ggva'">
                <xsl:text>http://www.columbia.edu/cgi-bin/cul/resolve?clio4278328</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>http://library.columbia.edu/indiv/avery/da/collections/ferriss.html</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:param>
    <xsl:template match="/">
        <xsl:for-each select="//marc:datafield[@tag = '035']/marc:subfield[@code = 'a']">
            <xsl:if test="starts-with(.,'(CStRLIN)')">
                <xsl:variable name="item_id">
                    <xsl:value-of select="substring-after(.,'(CStRLIN)')" />
                </xsl:variable>
                <xsl:result-document
                    href="{$resultPath}{$collection_id}/ldpd_{$collection_id}_{translate($item_id, '.', '_')}.json">
                    <xsl:call-template name="item">
                        <xsl:with-param name="item_id" select="$item_id"/>
                    </xsl:call-template>
                </xsl:result-document>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="xmlPath">
        <xsl:param name="item_id"/>
        <xsl:param name="type" />
    	<xsl:value-of select="string-join(('',$type,$collection_id,''),'/')" />
    	<xsl:value-of select="string-join((translate($item_id, '.', '_'),$type),'_')" />
    	<xsl:text>.xml</xsl:text>
    </xsl:template>
    <xsl:template name="item">
        <xsl:param name="item_id"/>
        <xsl:variable name="local_id">
        	<xsl:value-of select="string-join(('ldpd',$collection_id,$item_id),'.')" />
        </xsl:variable>
        <xsl:text>{&#10; "id":"</xsl:text><xsl:value-of select="$local_id" /><xsl:text>",&#10;</xsl:text>
        <xsl:text> "descMetadata":"</xsl:text>
        <xsl:call-template name="xmlPath"><xsl:with-param name="item_id" select="$local_id"/><xsl:with-param name="type" select="'mods'"/></xsl:call-template>
        <xsl:text>",&#10;</xsl:text>
        <xsl:if test="count(//marc:datafield[@tag = '789']) > 1">
	        <xsl:text> "structMetadata":"</xsl:text>
	        <xsl:call-template name="xmlPath"><xsl:with-param name="item_id" select="$local_id"/><xsl:with-param name="type" select="'structMap'"/></xsl:call-template>
	        <xsl:text>",&#10;</xsl:text>
	    </xsl:if>
        <xsl:text> "members":[&#10;</xsl:text>

        <xsl:for-each select="//marc:datafield[@tag = '789']">
        	<xsl:variable name="member_id">
	        	<xsl:choose>
	        		<xsl:when test="ends-with(child::marc:subfield[@code = 'i'],'.')">
		                <xsl:value-of select="substring(child::marc:subfield[@code = 'i'],0,string-length(child::marc:subfield[@code = 'i']))" />
	        		</xsl:when>
	        		<xsl:otherwise>
			            <xsl:value-of select="child::marc:subfield[@code = 'i']"/>
	        		</xsl:otherwise>
	        	</xsl:choose>
	        </xsl:variable>
        	<xsl:text> {"id":"</xsl:text><xsl:value-of select="$member_id" />
        	<xsl:text>","descMetadata":"</xsl:text>
			<xsl:call-template name="xmlPath"><xsl:with-param name="item_id" select="$member_id"/><xsl:with-param name="type" select="'mods'"/></xsl:call-template>
	        <xsl:text>"}</xsl:text>
            <xsl:if test="position() != last()">
            	<xsl:text>,</xsl:text>
            </xsl:if>
        	<xsl:text>&#10;</xsl:text>
        </xsl:for-each>
        <xsl:text> ]&#10;}</xsl:text>
    </xsl:template>
</xsl:stylesheet>
