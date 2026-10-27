<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> 
                           <!ENTITY colon "&#160;:&#160;">
                           <!ENTITY header SYSTEM "header.html">
                           <!ENTITY footer SYSTEM "footer.html">
                           <!ENTITY frfooter SYSTEM "footer.fr.html"> ]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
							  xmlns:noa="http://www.cra-arc.gc.ca/xmlns/tdd/noa/1-1-0" 
							  xmlns:tdd="http://www.cra-arc.gc.ca/xmlns/tdd/2-1-0" 
							  xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" 
							  exclude-result-prefixes="tdd noa soap">

	<xsl:output method="html" encoding="UTF-8"/>
	<xsl:include href="xnoa-body-transform.xsl"/>
	
	<xsl:template match="text()">
    </xsl:template> 
    
    <!-- Don't output anything -->
    <xsl:template match="//soap:*">
    	<xsl:apply-templates select="//noa:T1Notice"/>
    </xsl:template>
    <xsl:template match="//tdd:*|//noa:IndividualTaxpayerIdentifier|//noa:AssessmentSummaryText">
    </xsl:template>
	
	<xsl:template match="//noa:T1Notice">
		<xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html></xsl:text>
		<html class="no-js">
    	<head>
    	&header;
    	<link rel="stylesheet" href="css/theme.min.css" />
		<link rel="stylesheet" href="css/cra-branding.css" />
		<link rel="stylesheet" href="images/favicon.ico" />
    	</head>
    	<body> 

		<xsl:if test="noa:Language = 'E'">
    		<xsl:apply-templates select="document('banner.html')"/>
    	</xsl:if>
    	 
    	<xsl:if test="noa:Language = 'F'">
    		<xsl:apply-templates select="document('banner.fr.html')"/>
    	</xsl:if>
    	
    	<main role="main" property="mainContentOfPage" class="container">      
            <h1>  
                <xsl:value-of select="noa:NoticeTitle"/>
            </h1>
			<xsl:call-template name="process-xnoa"/>
		</main>
		
		<xsl:if test="noa:Language = 'E'">
	        &footer;
	    </xsl:if>
	    
		<xsl:if test="noa:Language = 'F'">
            &frfooter;
        </xsl:if>
        
	    </body>
      	</html> 
	</xsl:template>
	
	<xsl:template match="node()|@*">
    
	    <!-- Copy the current node -->
	    <xsl:copy>
	      	<!-- Including any attributes it has and any child nodes -->
	      	<xsl:apply-templates select="@*|node()"/>
	    </xsl:copy>
  	</xsl:template>
  	
</xsl:stylesheet>