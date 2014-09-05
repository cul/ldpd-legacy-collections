<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs xd marc"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:marc="http://www.loc.gov/MARC21/slim"
    version="2.0">
    <xsl:output indent="yes"/>
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Jan 2, 2013</xd:p>
            <xd:p><xd:b>Author:</xd:b> terry</xd:p>
            <xd:p/>
        </xd:desc>
    </xd:doc>
    <xsl:param name="resultPath">
        <xsl:text>mods/</xsl:text>
    </xsl:param>
    <xsl:param name="collection_id">
        <xsl:text>ggva</xsl:text>
    </xsl:param>
     <xsl:param name="collection_name">
        <xsl:text>Greene &amp; Greene architectural records and papers</xsl:text>
    </xsl:param>
 
    <xsl:template match="/">
        <xsl:for-each select="//marc:datafield[@tag = '035']/marc:subfield[@code = 'a']">
            <xsl:if test="starts-with(.,'(CStRLIN)')">
                <xsl:variable name="item_id">
                    <xsl:value-of select="substring-after(.,'(CStRLIN)')" />
                </xsl:variable>
                <xsl:result-document
                    href="{$resultPath}{$collection_id}/ldpd_ggva_{translate($item_id, '.', '_')}_mods.xml">
                    <xsl:call-template name="item">
                        <xsl:with-param name="item_id" select="$item_id"/>
                    </xsl:call-template>
                </xsl:result-document>
                <xsl:if test="count(//marc:datafield[@tag = '789']) > 1">
                    <xsl:result-document
                        href="structMap/{$collection_id}/ldpd_ggva_{translate($item_id, '.', '_')}_structMap.xml">
                        <xsl:call-template name="structMap">
                            <xsl:with-param name="item_id" select="$item_id"/>
                        </xsl:call-template>
                    </xsl:result-document>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="//marc:datafield[@tag = '789']">
            <xsl:variable name="part_id">
                <!-- <xsl:value-of select="child::marc:subfield[@code = '1']"/> -->
                <xsl:value-of select="child::marc:subfield[@code = 'i']"/>
            </xsl:variable>
            <xsl:result-document
                href="{$resultPath}{$collection_id}/{translate($part_id, '.', '_')}mods.xml">
                <xsl:call-template name="asset">
                    <xsl:with-param name="part_id" select="$part_id"/>
                </xsl:call-template>
            </xsl:result-document>
        </xsl:for-each>

    </xsl:template>
    <xsl:template name="subfields">
        <xsl:param name="strip"/>
        <xsl:choose>
            <xsl:when test="$strip = 'yes'">
                <xsl:value-of select="translate(., '][', '')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="position() != last()">
            <xsl:text>&#160;</xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template name="structMap">
        <xsl:param name="item_id"/>
        <mets:structMap xmlns:mets="http://www.loc.gov/METS/" LABEL="ldpd.ggva.{$item_id}">
            <xsl:attribute name="LABEL"><xsl:text>ldpd.ggva.</xsl:text><xsl:value-of select="$item_id"/></xsl:attribute>
            <xsl:for-each select="//marc:datafield[@tag = '789']">
                <xsl:variable name="part_id">
                    <xsl:value-of select="child::marc:subfield[@code = 'i']"/>
                </xsl:variable>
                <xsl:variable name="order">
                    <xsl:choose>
                        <xsl:when test="child::marc:subfield[@code = '1']">
                            <xsl:value-of select="child::marc:subfield[@code = '1']"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="child::marc:subfield[@code = 'l']"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <mets:div>
                    <xsl:attribute name="ORDER"><xsl:value-of select="translate($order,'][','')"/></xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="ends-with($part_id,'.')">
                            <xsl:attribute name="CONTENTIDS"><xsl:value-of select="substring($part_id,0,string-length($part_id))"/></xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="CONTENTIDS"><xsl:value-of select="$part_id"/></xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:attribute name="LABEL">
                        <xsl:for-each select="child::marc:subfield[@code = 't']">
                            <xsl:value-of select="translate(., '][', '')"/>
                        </xsl:for-each>
                        <xsl:for-each select="marc:subfield[@code = 'n']">
                            <xsl:text>&#160;</xsl:text>
                            <xsl:value-of select="."/>
                        </xsl:for-each>
                    </xsl:attribute>
                </mets:div>
            </xsl:for-each>
        </mets:structMap>
    </xsl:template>
    <xsl:template name="item">
        <xsl:param name="item_id"/>

        <MODS:mods xmlns:MODS="http://www.loc.gov/mods/v3"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd"
            version="3.5">

            <MODS:identifier type="local">ldpd.ggva.<xsl:value-of select="$item_id"/></MODS:identifier>
            <MODS:identifier type="CLIO"><xsl:value-of select="//marc:controlfield[@tag = '001']"/></MODS:identifier>
            <xsl:for-each select="//marc:datafield[@tag = '100'][@ind1 = '1']/*">
                <MODS:name type="personal">
                    <MODS:namePart>
                        <xsl:call-template name="subfields"/>
                    </MODS:namePart>
                </MODS:name>
            </xsl:for-each>
            
            <xsl:for-each select="//marc:datafield[@tag = '110'][@ind1 = '2']/*">
                <MODS:name type="corporate">
                    <MODS:namePart>
                        <xsl:call-template name="subfields"/>
                    </MODS:namePart>
                </MODS:name>
            </xsl:for-each>

            <MODS:titleInfo type="uniform">
                <MODS:title>
                    <xsl:for-each select="//marc:datafield[@tag = '240']/*">
                        <xsl:call-template name="subfields">
                            <xsl:with-param name="strip">
                                <xsl:text>yes</xsl:text>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:for-each>
                </MODS:title>
            </MODS:titleInfo>
            <MODS:titleInfo>
                <MODS:title>
                    <!-- 245 $a -->
                    <xsl:value-of
                        select="translate(//marc:datafield[@tag = '245']/marc:subfield[@code = 'a'], '][', '')"/>
                </MODS:title>
            </MODS:titleInfo>
            <MODS:originInfo>
                <MODS:dateCreated>
                    <!--260 $c -->
                    <xsl:value-of select="//marc:datafield[@tag = '260']/marc:subfield[@code = 'c']"
                    />
                </MODS:dateCreated>

                <!--008 07-10-->
                <xsl:choose>
                    <xsl:when test="substring(//marc:controlfield[@tag = '008'], 7, 1) = 'n'">
                        <MODS:dateCreated keyDate="yes">
                            <xsl:text>0000-00-00</xsl:text>
                        </MODS:dateCreated>
                    </xsl:when>
                    <xsl:when
                        test="contains(substring(//marc:controlfield[@tag = '008'], 12, 4), '1') ">
                        <MODS:dateCreated encoding="w3cdtf" keyDate="yes" point="start">
                            <xsl:value-of
                                select="substring(//marc:controlfield[@tag = '008'], 8, 4) "/>
                        </MODS:dateCreated>
                        <MODS:dateCreated encoding="w3cdtf" point="end">
                            <xsl:value-of
                                select="substring(//marc:controlfield[@tag = '008'], 12, 4) "/>
                        </MODS:dateCreated>
                    </xsl:when>
                    <xsl:otherwise>
                        <MODS:dateCreated encoding="w3cdtf" keyDate="yes">
                            <xsl:value-of
                                select="substring(//marc:controlfield[@tag = '008'], 8, 4) "/>
                        </MODS:dateCreated>
                    </xsl:otherwise>
                </xsl:choose>
            </MODS:originInfo>
            <MODS:physicalDescription>
                <xsl:choose>
                    <xsl:when test="count(//marc:datafield[@tag = '789']) &gt; 1">
                        <MODS:extent><xsl:value-of select="count(//marc:datafield[@tag = '789'])" /> sheets</MODS:extent>
                    </xsl:when>
                    <xsl:otherwise>
                        <MODS:extent>1 sheet</MODS:extent>
                    </xsl:otherwise>
                </xsl:choose>
                <MODS:form authority="gmgpc">architectural drawings</MODS:form>
                <MODS:digitalOrigin>reformatted digital</MODS:digitalOrigin>
                <MODS:reformattingQuality>access</MODS:reformattingQuality>
                <MODS:form authority="marcform">electronic</MODS:form>
            </MODS:physicalDescription>
            <MODS:typeOfResource>still image</MODS:typeOfResource>
            <xsl:for-each select="//marc:datafield[@tag = '561']">
                <MODS:note type="ownership">
                    <xsl:call-template name="subfields"/>
                </MODS:note>
            </xsl:for-each>
            <MODS:accessCondition type="useAndReproduction">No known restrictions.</MODS:accessCondition>
            <MODS:relatedItem displayLabel="Collection" type="host">
                <MODS:titleInfo>
                    <MODS:title>
                        <xsl:text>Greene &amp; Greene architectural records and papers</xsl:text>
                    </MODS:title>
                </MODS:titleInfo>
            </MODS:relatedItem>
            <MODS:relatedItem displayLabel="Project" type="host">
                <MODS:titleInfo>
                    <MODS:title>
                        <xsl:text>Greene &amp; Greene Project</xsl:text>
                    </MODS:title>
                </MODS:titleInfo>
                <MODS:location>
                    <url>http://www.columbia.edu/cgi-bin/cul/resolve?clio4278328</url>
                </MODS:location>
            </MODS:relatedItem>
            <MODS:location>
                <MODS:physicalLocation authority="marcorg">NNC-A</MODS:physicalLocation>
                <MODS:physicalLocation>Avery Architectural &amp; Fine Arts Library, Columbia University</MODS:physicalLocation>
                <MODS:url access="object in context" usage="primary display">http://www.columbia.edu/cu/lweb/eresources/archives/avery/greene/images/images_<xsl:value-of select="$item_id" />.html</MODS:url>
                
                <MODS:holdingSimple>
                    <MODS:copyInformation>
                        <MODS:subLocation>Drawings &amp; Archives</MODS:subLocation>
                    </MODS:copyInformation>
                </MODS:holdingSimple>
            </MODS:location>
            <MODS:recordInfo>
                <MODS:recordContentSource>NNC</MODS:recordContentSource>
                <MODS:recordOrigin>Cataloging by project AVIADOR staff, edited to conform to MODS, version 3.5.</MODS:recordOrigin>
            </MODS:recordInfo>
        </MODS:mods>
    </xsl:template>
    <xsl:template name="asset">
        <xsl:param name="part_id"/>

        <MODS:mods xmlns:MODS="http://www.loc.gov/mods/v3"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd"
            version="3.5">

            <MODS:identifier type="local">
                <xsl:choose>
                    <xsl:when test="ends-with($part_id,'.')">
                        <xsl:value-of select="substring($part_id,0,string-length($part_id))"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$part_id"/>
                    </xsl:otherwise>
                </xsl:choose>
            </MODS:identifier>
            <MODS:titleInfo>
                <MODS:title>
                    <!-- 789 0_ $t $n -->
                    <xsl:for-each
                        select="//marc:datafield[@tag = '789'][@ind1 = '0'][child::marc:subfield[@code = 't']][child::marc:subfield[@code = 'i']  = $part_id]">
                        <xsl:if test="position() > 1">
                          <xsl:text>,&#160;</xsl:text>
                        </xsl:if>
                        <xsl:for-each select="child::marc:subfield[@code = 't']">
                            <xsl:value-of select="translate(., '][', '')"/>
                        </xsl:for-each>
                        <xsl:for-each select="marc:subfield[@code = 'n']">
                            <xsl:text>&#160;</xsl:text>
                            <xsl:value-of select="."/>
                        </xsl:for-each>
                    </xsl:for-each>
                </MODS:title>
            </MODS:titleInfo>
            <MODS:originInfo>
                <MODS:dateCreated>
                    <!--260 $c -->
                    <xsl:value-of select="//marc:datafield[@tag = '260']/marc:subfield[@code = 'c']"
                    />
                </MODS:dateCreated>

                <!--008 07-10-->
                <xsl:choose>
                    <xsl:when test="substring(//marc:controlfield[@tag = '008'], 7, 1) = 'n'">
                        <MODS:dateCreated keyDate="yes">
                            <xsl:text>0000-00-00</xsl:text>
                        </MODS:dateCreated>
                    </xsl:when>
                    <xsl:when
                        test="contains(substring(//marc:controlfield[@tag = '008'], 12, 4), '1') ">
                        <MODS:dateCreated encoding="w3cdtf" keyDate="yes" point="start">
                            <xsl:value-of
                                select="substring(//marc:controlfield[@tag = '008'], 8, 4) "/>
                        </MODS:dateCreated>
                        <MODS:dateCreated encoding="w3cdtf" point="end">
                            <xsl:value-of
                                select="substring(//marc:controlfield[@tag = '008'], 12, 4) "/>
                        </MODS:dateCreated>
                    </xsl:when>
                    <xsl:otherwise>
                        <MODS:dateCreated encoding="w3cdtf" keyDate="yes">
                            <xsl:value-of
                                select="substring(//marc:controlfield[@tag = '008'], 8, 4) "/>
                        </MODS:dateCreated>
                    </xsl:otherwise>
                </xsl:choose>
            </MODS:originInfo>
            <MODS:physicalDescription>
                <MODS:extent>1 sheet</MODS:extent>
                <MODS:form authority="gmgpc">architectural drawings</MODS:form>
                <MODS:digitalOrigin>reformatted digital</MODS:digitalOrigin>
                <MODS:reformattingQuality>access</MODS:reformattingQuality>
                <MODS:form authority="marcform">electronic</MODS:form>
            </MODS:physicalDescription>
            <MODS:typeOfResource>still image</MODS:typeOfResource>
            <xsl:for-each
                select="//marc:datafield[@tag = '789'][@ind1 = '0'][child::marc:subfield[@code = 'i'] = $part_id]/marc:subfield[@code = 'o']">
                <MODS:note>
                    <!--789 0_ $o -->
                    <xsl:value-of select="."/>
                </MODS:note>
            </xsl:for-each>
            <xsl:for-each
                select="//marc:datafield[@tag = '789'][@ind1 = '0'][child::marc:subfield[@code = 'i']  = $part_id]/marc:subfield[@code = 'p']">
                <MODS:note type="physical details">
                    <!--789 0_ $p -->
                    <xsl:value-of select="."/>
                </MODS:note>
            </xsl:for-each>
            <MODS:note>
                <xsl:text>Digital image created from an analog slide.</xsl:text>
            </MODS:note>
            <MODS:accessCondition type="useAndReproduction">No known restrictions.</MODS:accessCondition>
            <MODS:location>
                <MODS:physicalLocation authority="marcorg">NNC-A</MODS:physicalLocation>
                <MODS:physicalLocation>Avery Architectural &amp; Fine Arts Library, Columbia University</MODS:physicalLocation>
                <xsl:for-each
                    select="//marc:datafield[@tag = '789'][@ind1 = '0'][child::marc:subfield[@code = 'i'] = $part_id]">
                    <MODS:shelfLocator>
                        <xsl:value-of select="child::marc:subfield[@code = 'i']"/>
                    </MODS:shelfLocator>
                </xsl:for-each>
                <MODS:holdingSimple>
                    <MODS:copyInformation>
                        <MODS:subLocation>Drawings &amp; Archives</MODS:subLocation>
                    </MODS:copyInformation>
                </MODS:holdingSimple>
            </MODS:location>
            <MODS:recordInfo>
                <MODS:recordContentSource>NNC</MODS:recordContentSource>
                <MODS:recordOrigin>Cataloging by project AVIADOR staff, edited to conform to MODS, version 3.5.</MODS:recordOrigin>
            </MODS:recordInfo>
        </MODS:mods>
    </xsl:template>
</xsl:stylesheet>
