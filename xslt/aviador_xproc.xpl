<?xml version="1.0" encoding="UTF-8"?>
<!-- <p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0">
    <p:input port="source"/>
    <p:output port="result"/>-->
    <p:pipeline  xmlns:p="http://www.w3.org/ns/xproc" version="1.0">
        <p:xslt>
            <p:input port="stylesheet">
                <p:document href="identity.xsl"/>
            </p:input>
        </p:xslt>
       <p:xslt>
            <p:input port="stylesheet">
                <p:document href="tidy.xsl"/>
            </p:input>
        </p:xslt>
        

    </p:pipeline>
 <!--  <p:identity/>
</p:declare-step> -->
