<?xml version="1.0"?>
<xsl:transform
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
 version="1.0">
 <xsl:output method="xml"/>
 
<!-- A -->
 <xsl:key name="account-lookup" match="account" use="hash"/>
 
 
 
<!-- B -->
 <xsl:variable name="account-top" select="document('accounts.xml')/Accounts"/>
 
  <xsl:template match="node()|@*">
      <!-- Copy the current node -->
      <xsl:copy>
        <!-- Including any attributes it has and any child nodes -->
        <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
    </xsl:template>

 
 <xsl:template match="//TaxPayerGivenName/text()">

  <xsl:apply-templates select="$account-top">
   <xsl:with-param name="curr-hash" select="."/>
   <xsl:with-param name="attr">GivenName</xsl:with-param>
  </xsl:apply-templates>
 </xsl:template>

<xsl:template match="//TaxPayerSurname/text()">

  <xsl:apply-templates select="$account-top">
   <xsl:with-param name="curr-hash" select="."/>
   <xsl:with-param name="attr">LastName</xsl:with-param>
  </xsl:apply-templates>
 </xsl:template>
 
 <xsl:template match="//MaskedAccountNumber/text()">
 
   <xsl:apply-templates select="$account-top">
    <xsl:with-param name="curr-hash" select="."/>
    <xsl:with-param name="attr">Mask</xsl:with-param>
   </xsl:apply-templates>
 </xsl:template>

 <xsl:template match="Accounts">
  <xsl:param name="curr-hash"/>
  <xsl:param name="attr"/>

  <xsl:if test="$attr = 'GivenName'">
      <xsl:value-of select="key('account-lookup', $curr-hash)/GivenName"/>
  </xsl:if>
  <xsl:if test="$attr = 'LastName'">
        <xsl:value-of select="key('account-lookup', $curr-hash)/LastName"/>
  </xsl:if>
  <xsl:if test="$attr = 'Mask'">
          <xsl:value-of select="key('account-lookup', $curr-hash)/Mask"/>
  </xsl:if>
 </xsl:template>
 
 <xsl:template match="AddressLine1Text">
   <AddressLine1Text><xsl:value-of select="key('account-lookup', $curr-hash)/GivenName"/>  <xsl:value-of select="key('account-lookup', $curr-hash)/LastName"/></AddressLine1Text>
 </xsl:template>
 
 
</xsl:transform>

