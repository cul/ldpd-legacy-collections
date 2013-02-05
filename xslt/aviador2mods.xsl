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
        <xsl:text>/Users/terry/tmp/legacy-mods/</xsl:text>
    </xsl:param>

    <xsl:param name="collection_id"/> 




    <xsl:template match="/">
        <xsl:param name="collection_name">
            <xsl:choose>
                <xsl:when test="$collection_id = 'ferriss'">
                    <xsl:text>Hugh Ferriss architectural drawings and papers</xsl:text>
                    <xsl:message>
                        <xsl:text>$collection_name is Hugh Ferriss architectural drawings and papers</xsl:text>
                    </xsl:message>
                </xsl:when>
                <xsl:when test="$collection_id = 'ggva'">
                    <xsl:text>Greene &amp; Greene architectural records and papers</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:message>
                        <xsl:text>ERROR: collection_id parameter value incorrect: expected either 'ferriss' or 'ggva'</xsl:text>
                    </xsl:message>
                </xsl:otherwise>
            </xsl:choose>

        </xsl:param>

        <xsl:choose>
            <xsl:when test="count(//marc:datafield[@tag = '789']) &gt; 1">
                <xsl:for-each select="//marc:datafield[@tag = '789']">
                    <xsl:variable name="part_id">
                        <!-- <xsl:value-of select="child::marc:subfield[@code = '1']"/> -->
                        <xsl:value-of select="child::marc:subfield[@code = 'i']"/>
                    </xsl:variable>
                    <xsl:result-document
                        href="{$resultPath}{$collection_id}/{translate($part_id, '.', '_')}mods.xml">
                        <xsl:call-template name="record">
                            <xsl:with-param name="part_id" select="$part_id"/>

                        </xsl:call-template>
                    </xsl:result-document>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="part_id"
                    select="//marc:datafield[@tag = '789']/marc:subfield[@code = 'i']"/>
                <xsl:result-document
                    href="{$resultPath}{$collection_id}/{translate($part_id, '.', '_')}mods.xml">
                    <xsl:call-template name="record">
                        <xsl:with-param name="part_id" select="$part_id"/>
                    </xsl:call-template>
                </xsl:result-document>
            </xsl:otherwise>
        </xsl:choose>

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
    <xsl:template name="record">
        <xsl:param name="part_id"/>

        <MODS:mods xmlns:MODS="http://www.loc.gov/mods/v3"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-4.xsd"
            version="3.4">

            <MODS:name type="personal">
                <MODS:namePart>
                    <xsl:for-each select="//marc:datafield[@tag = '100'][@ind1 = '1']/*">
                        <xsl:call-template name="subfields"/>
                    </xsl:for-each>
                </MODS:namePart>
            </MODS:name>

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
            <!--
            <xsl:for-each select="//marc:datafield[@tag = '130'][@ind1 = '0']/*">
                <MODS:titleInfo type="uniform">
                    <MODS:title>
                        <xsl:call-template name="subfields"/>
                    </MODS:title>
                </MODS:titleInfo>
            </xsl:for-each>
-->
            <MODS:titleInfo>
                <MODS:title>
                    <!-- 245 $a, 789 0_ $t $n -->
                    <xsl:value-of
                        select="translate(//marc:datafield[@tag = '245']/marc:subfield[@code = 'a'], '][', '')"/>
                    <xsl:for-each
                        select="//marc:datafield[@tag = '789'][@ind1 = '0'][child::marc:subfield[@code = 't']][child::marc:subfield[@code = 'i']  = $part_id]">
                        <xsl:text>,&#160;</xsl:text>
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
                        <xsl:message>
                            <xsl:text>END DATE </xsl:text>
                            <xsl:value-of
                                select="substring(//marc:controlfield[@tag = '008'], 12, 4)"/>
                        </xsl:message>
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
                <!--       <xsl:if
                    test="substring(//marc:controlfield[@tag = '008'], 12, 4) castable as xs:integer">
                    
                </xsl:if>
                -->
            </MODS:originInfo>
            <MODS:physicalDescription>
                <MODS:extent>1 sheet</MODS:extent>
                <MODS:form authority="gmgpc">architectural drawings</MODS:form>
                <MODS:digitalOrigin>reformatted digital</MODS:digitalOrigin>
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
            <xsl:for-each select="//marc:datafield[@tag = '561']">
                <MODS:note type="ownership">
                    <xsl:call-template name="subfields"/>
                </MODS:note>
            </xsl:for-each>
            <xsl:choose>
                <xsl:when test="$collection_id = 'ggva'">
                    <MODS:accessCondition type="useAndReproduction">No known
                        restrictions.</MODS:accessCondition>
                </xsl:when>
                <xsl:when test="$collection_id = 'ferriss'">
                    <MODS:accessCondition type="useAndReproduction">Columbia Libraries Staff Use
                        Only</MODS:accessCondition>
                </xsl:when>
            </xsl:choose>
            <!-- 
               <MODS:subject authority="lcsh">
                <MODS:topic>Architecture/United States-/Designs and plans</MODS:topic>
            </MODS:subject>
            -->
            <MODS:relatedItem displayLabel="Project" type="host">
                <MODS:titleInfo>
                    <MODS:title>
                        <xsl:choose>
                            <xsl:when test="$collection_id = 'ggva'">
                                <xsl:text>Greene &amp; Greene Project</xsl:text>
                            </xsl:when>
                            <xsl:when test="$collection_id = 'ferriss'">
                                <xsl:text>Hugh Ferriss Architectural Drawings</xsl:text>
                            </xsl:when>
                        </xsl:choose>
                    </MODS:title>
                </MODS:titleInfo>
            </MODS:relatedItem>
            <MODS:location>
                <MODS:physicalLocation authority="marcorg">NNC-A</MODS:physicalLocation>
                <MODS:physicalLocation>Avery Architectural &amp; Fine Arts Library, Columbia
                    University</MODS:physicalLocation>
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
            <MODS:identifier type="local">
                <xsl:message>
                    <xsl:value-of select="$part_id"/>
                </xsl:message>
                <xsl:for-each
                    select="//marc:datafield[@tag = '789'][@ind1 = '0'][child::marc:subfield[@code = 'i'] = $part_id]">
                    <xsl:value-of
                        select="child::marc:subfield[@code = 'i']"/>
                </xsl:for-each>
            </MODS:identifier>
            <MODS:identifier type="CLIO">
                <xsl:value-of select="//marc:controlfield[@tag = '001']"/>
            </MODS:identifier>
            <MODS:recordInfo>
                <MODS:recordContentSource>NNC</MODS:recordContentSource>
                <MODS:recordOrigin>Cataloging by project AVIADOR staff, edited to conform to MODS,
                    version 3.4.</MODS:recordOrigin>
                <!-- 
                    <MODS:recordCreationDate encoding="w3cdtf">system
                    generated?</MODS:recordCreationDate>
                -->
            </MODS:recordInfo>
        </MODS:mods>
    </xsl:template>
</xsl:stylesheet>
