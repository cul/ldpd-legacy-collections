<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs xd marc"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:marc="http://www.loc.gov/MARC21/slim"
    version="2.0">
    <xsl:output indent="yes" encoding="UTF-8"/>
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
            <xsl:text>Greene &amp; Greene architectural records and papers</xsl:text>
        </xsl:param>
        <xsl:apply-templates select="//marc:datafield[@tag = '789']"/>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '789']">
        <xsl:variable name="part_id">
            <xsl:value-of select="child::marc:subfield[@code = 'i']"/>
        </xsl:variable>
        <xsl:result-document
            href="{$resultPath}{$collection_id}/{translate($part_id, '.', '_')}mods.xml"
            indent="yes" method="xml">
            <xsl:call-template name="record">
                <xsl:with-param name="part_id" select="$part_id"/>
            </xsl:call-template>
        </xsl:result-document>
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

        <mods:mods xmlns:mods="http://www.loc.gov/mods/v3"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-4.xsd"
            version="3.4">

            <xsl:for-each select="//marc:datafield[@tag = '100'][@ind1 = '1']/*">
            <mods:name type="personal">
                <mods:namePart>
                    <xsl:call-template name="subfields"/>
                </mods:namePart>
            </mods:name>
            </xsl:for-each>
            <xsl:for-each select="//marc:datafield[@tag = '110'][@ind1 = '2']/*">
                <mods:name type="corporate">
                    <mods:namePart>
                        <xsl:call-template name="subfields"/>
                    </mods:namePart>
                </mods:name>
            </xsl:for-each>

            <mods:titleInfo type="uniform">
                <mods:title>
                    <xsl:for-each select="//marc:datafield[@tag = '240']/*">
                        <xsl:call-template name="subfields">
                            <xsl:with-param name="strip">
                                <xsl:text>yes</xsl:text>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:for-each>
                </mods:title>
            </mods:titleInfo>

            <mods:titleInfo>
                <mods:title>
                    <!-- 245 $a, 789 0_ $t $n -->
                    <!--                    <xsl:value-of
                        select="translate(//marc:datafield[@tag = '245']/marc:subfield[@code = 'a'], '][', '')"/>
                        -->
                    <xsl:for-each
                        select="//marc:datafield[@tag = '789'][@ind1 = '0'][child::marc:subfield[@code = 't']][child::marc:subfield[@code = 'i']  = $part_id]">
                        <xsl:for-each select="child::marc:subfield[@code = 't']">
                            <xsl:value-of select="translate(., '][', '')"/>
                        </xsl:for-each>
                        <xsl:for-each select="marc:subfield[@code = 'n']">
                            <xsl:text>&#160;</xsl:text>
                            <xsl:value-of select="."/>
                        </xsl:for-each>
                    </xsl:for-each>
                </mods:title>
            </mods:titleInfo>
            <mods:originInfo>
                <mods:dateCreated>
                    <!--260 $c -->
                    <xsl:value-of select="//marc:datafield[@tag = '260']/marc:subfield[@code = 'c']"
                    />
                </mods:dateCreated>

                <!--008 07-10-->
                <xsl:choose>
                    <xsl:when test="substring(//marc:controlfield[@tag = '008'], 7, 1) = 'n'">
                        <mods:dateCreated keyDate="yes">
                            <xsl:text>0000-00-00</xsl:text>
                        </mods:dateCreated>
                    </xsl:when>
                    <xsl:when
                        test="contains(substring(//marc:controlfield[@tag = '008'], 12, 4), '1') ">
                        <xsl:message>
                            <xsl:text>END DATE </xsl:text>
                            <xsl:value-of
                                select="substring(//marc:controlfield[@tag = '008'], 12, 4)"/>
                        </xsl:message>
                        <mods:dateCreated encoding="w3cdtf" keyDate="yes" point="start">
                            <xsl:value-of
                                select="substring(//marc:controlfield[@tag = '008'], 8, 4) "/>
                        </mods:dateCreated>
                        <mods:dateCreated encoding="w3cdtf" point="end">
                            <xsl:value-of
                                select="substring(//marc:controlfield[@tag = '008'], 12, 4) "/>
                        </mods:dateCreated>
                    </xsl:when>
                    <xsl:otherwise>
                        <mods:dateCreated encoding="w3cdtf" keyDate="yes">
                            <xsl:value-of
                                select="substring(//marc:controlfield[@tag = '008'], 8, 4) "/>
                        </mods:dateCreated>
                    </xsl:otherwise>
                </xsl:choose>
                <!--       <xsl:if
                    test="substring(//marc:controlfield[@tag = '008'], 12, 4) castable as xs:integer">
                    
                </xsl:if>
                -->
            </mods:originInfo>
            <mods:physicalDescription>
                <mods:extent>1 sheet</mods:extent>
                <mods:form authority="gmgpc">architectural drawings</mods:form>
                <mods:digitalOrigin>reformatted digital</mods:digitalOrigin>
                <mods:reformattingQuality>access</mods:reformattingQuality>
                <mods:form authority="marcform">electronic</mods:form>
            </mods:physicalDescription>
            <mods:typeOfResource>still image</mods:typeOfResource>
            <xsl:for-each
                select="//marc:datafield[@tag = '789'][@ind1 = '0'][child::marc:subfield[@code = 'i'] = $part_id]/marc:subfield[@code = 'o']">
                <mods:note>
                    <!--789 0_ $o -->
                    <xsl:value-of select="."/>
                </mods:note>
            </xsl:for-each>
            <xsl:for-each
                select="//marc:datafield[@tag = '789'][@ind1 = '0'][child::marc:subfield[@code = 'i']  = $part_id]/marc:subfield[@code = 'p']">
                <mods:note type="physical details">
                    <!--789 0_ $p -->
                    <xsl:value-of select="."/>
                </mods:note>
            </xsl:for-each>
            <xsl:for-each select="//marc:datafield[@tag = '561']">
                <mods:note type="ownership">
                    <xsl:call-template name="subfields"/>
                </mods:note>
            </xsl:for-each>
            <mods:note>
                <xsl:text>Digital image created from an analog slide.</xsl:text>
            </mods:note>
            <xsl:choose>
                <xsl:when test="$collection_id = 'ggva'">
                    <mods:accessCondition type="useAndReproduction">No known
                        restrictions.</mods:accessCondition>
                </xsl:when>
                <xsl:when test="$collection_id = 'ferriss'">
                    <mods:accessCondition type="useAndReproduction">Columbia Libraries Staff Use Only</mods:accessCondition>
                </xsl:when>
            </xsl:choose>
            <mods:relatedItem displayLabel="Project" type="host">
                <mods:titleInfo>
                    <mods:title>
                        <xsl:text>Greene &amp; Greene Project</xsl:text>
                    </mods:title>
                </mods:titleInfo>
                <mods:location>
                    <mods:url>http://www.columbia.edu/cgi-bin/cul/resolve?clio4278328</mods:url>
                </mods:location>
            </mods:relatedItem>
            <mods:relatedItem displayLabel="Collection" type="host">
                <mods:titleInfo>
                    <mods:title>
                        <xsl:text>Greene &amp; Greene architectural records and papers</xsl:text>
                    </mods:title>
                </mods:titleInfo>
                <mods:part>
                    <mods:detail type="series" level="2">
                        <mods:title>Project Drawings</mods:title>
                    </mods:detail>
                </mods:part>
                <mods:part>
                    <mods:detail type="subseries" level="3">
                        <mods:title>
                            <xsl:for-each select="//marc:datafield[@tag = '240']/*">
                                <xsl:call-template name="subfields">
                                    <xsl:with-param name="strip">
                                        <xsl:text>yes</xsl:text>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:for-each>
                        </mods:title>
                    </mods:detail>
                </mods:part>
            </mods:relatedItem>
            <mods:location>
                <mods:physicalLocation authority="marcorg">NNC-A</mods:physicalLocation>
                <mods:physicalLocation>Avery Architectural &amp; Fine Arts Library, Columbia
                    University</mods:physicalLocation>
                <xsl:for-each
                    select="//marc:datafield[@tag = '789'][@ind1 = '0'][child::marc:subfield[@code = 'i'] = $part_id]">
                    <mods:shelfLocator>
                        <xsl:value-of select="child::marc:subfield[@code = 'i']"/>
                    </mods:shelfLocator>
                </xsl:for-each>
                <mods:url access="object in context" usage="primary display">
                    <xsl:value-of
                        select="concat('http://www.columbia.edu/cu/lweb/eresources/archives/avery/greene/html/subs/', normalize-space(substring-after(//marc:datafield[@tag = '035'][contains(child::marc:subfield[@code = 'a']/text(), 'CStRLIN')], ')')), '.html')"
                    />
                </mods:url>
                <mods:holdingSimple>
                    <mods:copyInformation>
                        <mods:subLocation>Drawings &amp; Archives</mods:subLocation>
                    </mods:copyInformation>
                </mods:holdingSimple>
            </mods:location>
            <mods:identifier type="local">
                <xsl:message>
                    <xsl:value-of select="$part_id"/>
                </xsl:message>
                <xsl:for-each
                    select="//marc:datafield[@tag = '789'][@ind1 = '0'][child::marc:subfield[@code = 'i'] = $part_id]">
                    <xsl:value-of select="child::marc:subfield[@code = 'i']"/>
                </xsl:for-each>
            </mods:identifier>
            <mods:identifier type="CLIO">
                <xsl:value-of select="//marc:controlfield[@tag = '001']"/>
            </mods:identifier>
            <mods:recordInfo>
                <mods:recordContentSource>NNC</mods:recordContentSource>
                <xsl:choose>
                    <xsl:when
                        test="contains(//marc:datafield[@tag = '100'][@ind1 = '1']/marc:subfield[@code = 'a']/text(), 'Hulbert')">
                        <mods:recordOrigin>Edited to conform to mods, version
                            3.4.</mods:recordOrigin>
                    </xsl:when>
                    <xsl:otherwise>
                        <mods:recordOrigin>Cataloging by project AVIADOR staff, edited to conform to MODS, version 3.4.</mods:recordOrigin>
                    </xsl:otherwise>
                </xsl:choose>
                    <mods:recordCreationDate encoding="w3cdtf"><xsl:value-of select="current-date()"/></mods:recordCreationDate>
            </mods:recordInfo>
        </mods:mods>
    </xsl:template>
</xsl:stylesheet>
