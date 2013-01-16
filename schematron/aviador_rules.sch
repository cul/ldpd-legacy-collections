<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://www.ascc.net/xml/schematron">
    <ns uri="http://www.loc.gov/mods/v3" prefix="mods"/>
    <pattern name="dates">
        <rule context="mods:originInfo">
            <assert test="count(child::mods:dateCreated/@keyDate) = 1">
                The should only be one dateCreated element with keyDate attribute
            </assert>
        </rule>
    </pattern>
    
</schema>