<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> 
                           <!ENTITY colon "&#160;:&#160;">
                           <!ENTITY header SYSTEM "header.html">
                           <!ENTITY footer SYSTEM "footer.html">
                           <!ENTITY frfooter SYSTEM "footer.fr.html"> ]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:tdd="http://www.cra-arc.gc.ca/xmlns/tdd/2-1-0" 
    xmlns:noa="http://www.cra-arc.gc.ca/xmlns/tdd/noa/1-0-0" 
    exclude-result-prefixes="tdd noa">
    
        
    <xsl:output method="html" /> 
    
    <xsl:template match="text()">
    
    </xsl:template> 
    <!-- Don't output anything -->
    <xsl:template match="//tdd:*|//noa:IndividualTaxpayerIdentifier|//noa:AssessmentSummaryText">
    </xsl:template>
       
  
<xsl:template match="//noa:T1Notice">

    <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html></xsl:text>
        
    <html class="no-js">
    <xsl:comment >Created by version 1.02 </xsl:comment>
    &header;
    <body> 
      
    <xsl:if test="noa:LanguageCode = 'F'">
    <xsl:apply-templates 
        select="document('banner.fr.html')"/>
    </xsl:if>
    
    <xsl:if test="noa:LanguageCode = 'E'">
    <xsl:apply-templates 
        select="document('banner.html')"/>
    </xsl:if>
    
     
        
    
    
   
    
    
      
    <main role="main" property="mainContentOfPage" class="container">      
            <h1>  
                <xsl:value-of select="noa:NoticeTitle"/>
            </h1>
            <div id="Notice details">
                <section class="panel panel-default">
                    <header class="panel-heading">
                    <h2>
                        <xsl:value-of select="noa:NoticeDetailsTitle"/>
                    </h2>
                    </header>
                    <div class="panel-body">
                        <div class="row">
                            <div class="col-md-6 mrgn-bttm-sm">
	                            <xsl:value-of select="noa:NameTitle"/>&colon;
	                                <span class="noticeValue"><xsl:value-of select="noa:TaxPayerGivenName" />&nbsp;<xsl:value-of select="noa:TaxPayerSurname"/></span>
                            </div>    
                            <div class="col-md-6 mrgn-bttm-sm">
                                <xsl:value-of select="noa:AccountNumberTitle"/>&colon;
                                    <span class="noticeValue"><xsl:value-of select="noa:MaskedAccountNumber"/></span>
                            </div>
                        </div>
                                             
                        <div class="row">
                            <div class="col-md-6 mrgn-bttm-sm">
                                <xsl:value-of select="noa:AssessmentTitle"/>&colon;
                                    <span class="noticeValue"><xsl:value-of select="noa:AssessmentDate"/></span>
                             </div>
                             <div class="col-md-6 mrgn-bttm-sm">
                                <xsl:value-of select="noa:TaxYearTitle"/>&colon;
                                <span class="noticeValue"><xsl:value-of select="noa:TaxYearId"/></span>
                             </div>
                         </div>
                         
                         <div class="row">
                         
                            <div class="col-md-6 mrgn-bttm-sm">                      
                            <xsl:value-of select="noa:TaxCentreTitle"/>&colon;
                            <span class="noticeValue">
                                <xsl:for-each select="noa:TaxCentreTable">
                                    <xsl:value-of select="noa:TaxCentreLine"/>&nbsp;
                                </xsl:for-each>
                             </span>
                             </div>
                              
                             <div class="col-md-6 mrgn-bttm-sm">
                                <span class="noticeValue">
                                    <xsl:value-of select="noa:BankruptcyText"/>
                                </span>
                                    
                             </div>
                             
                          </div>
                              
                    </div>              
                                    
                
                    
                </section>
                <div class="text-right">
                    <xsl:value-of select="noa:InternetAccessCodeTitle"/>&nbsp;
                        <span class="noticeValue"><xsl:value-of select="noa:InternetAccessCode"/></span>
                </div>
            </div>
                    
            
            <div>
              
             
                        
        
             
             
                                           
                                            
                                                
             
        </div>      

            
         <xsl:apply-templates select="noa:BalanceTableCount[. > 0]"/>  
         <xsl:apply-templates select="noa:TaxAssessmentTableCount[. >0]"/>
         <xsl:apply-templates select="noa:SummaryTitle"/>
 
         <xsl:apply-templates select="noa:ExplanationTableCount[. > 0]"/>
         <xsl:apply-templates select="noa:RrspTitle[(normalize-space())]"/>
         <xsl:apply-templates select="noa:HbpTitle[(normalize-space())]"/>
         <xsl:apply-templates select="noa:LlpTitle[(normalize-space())]"/>
         <xsl:apply-templates select="noa:MoreInformationTitle[(normalize-space())]"/>
         </main>
         <xsl:if test="noa:LanguageCode = 'F'">
            &frfooter;
         </xsl:if>
    
	    <xsl:if test="noa:LanguageCode = 'E'">
	        &footer;
	    </xsl:if>
         
         
      </body>
      </html>          
       
</xsl:template>

<xsl:template match="noa:BalanceTableCount[. > 0]">
    <div class="noticeSection">
     <div >
                <xsl:for-each select="../noa:BalanceTable">
                    <p>
                         <xsl:value-of select="noa:BalanceTextLine"/>
                    </p>
                </xsl:for-each>
     </div>
     
     <div>
         <xsl:value-of select="../noa:CommissionerName"/>
                
     </div>
     <div>
         <xsl:value-of select="../noa:CommissionerTitle"/>
                
      </div>
     </div>
</xsl:template>

<xsl:template match="noa:TaxAssessmentTableCount[. > 0]">
    <div class="noticeAction">
        <h2><xsl:value-of select="../noa:TaxAssessmentTitle"/></h2>
                <xsl:for-each select="../noa:TaxAssessmentTable">
                    <p>
                         <xsl:value-of select="noa:TaxAssessmentTextLine"/>
                    </p>
                </xsl:for-each>
     </div>
</xsl:template>

<xsl:template match="noa:SummaryTitle">
    <div class="table-responsive" id="summary">
         <table class="table table-striped table-condensed">
            <caption><h2 class="text-left"><xsl:value-of select="."/></h2></caption>    
               <tr>         
                <th>
                                        <xsl:value-of select="../noa:LineTitle"/>
                </th>
                <th>
                                        <xsl:value-of select="../noa:DescriptionTitle"/>
                </th>
                
                <xsl:if test="../noa:NoticeType = '1491'">
	                <th class="noaAmount">
	                                        <xsl:value-of select="../noa:PreviousAmountTitle"/>
	                </th>
	                 
	                <th class="noaAmount">
	                                        <xsl:value-of select="../noa:RevisedAmountTitle"/>
	                </th>
                </xsl:if>
                <xsl:if test="../noa:NoticeType = '1451'">
                    <th class="noaAmount">
                                            <xsl:value-of select="../noa:AmountTitle"/>
                    </th>
                   
                    
                </xsl:if>
                
                <th>
                                        <xsl:value-of select="../noa:SummaryDebitCreditTitle"/>
                </th>
               </tr>
               <xsl:for-each select="../noa:SummaryTable">
               
                    
                    
                    <tr> 
                        <xsl:if test="position() = last()">
                            <xsl:attribute name="class">totalNoaRow</xsl:attribute>
                        </xsl:if>
                        <xsl:if test="position() != last()"> 
                            <xsl:attribute name="class">noaRow</xsl:attribute>
                        </xsl:if>
                        
                     <td>
                          <xsl:value-of select="noa:SummaryLineNumber"/>
                      </td>
                     <td>
                          
                                    <xsl:value-of select="noa:DetailDescription1"/>
                      </td>
                      <xsl:if test="../noa:NoticeType = '1491'">
	                      <td class="noaAmount">
	                                    <xsl:value-of select="noa:DetailAmount1"/>
	                      </td>
                      </xsl:if>
                      <td class="noaAmount">
                                    <xsl:value-of select="noa:DetailAmount2"/>
                      </td>
                      <td>
                                    <xsl:value-of select="noa:DebitCreditCode"/>
                      </td>
                      </tr>
                  </xsl:for-each>
          </table>
    </div>
</xsl:template>


<xsl:template match="noa:RrspTitle[(normalize-space())]">
    
        <h2><xsl:value-of select="."/></h2>
    
    <div>    
            <xsl:value-of select="../noa:RrspIntroParagraph/noa:RrspIntroTextLine"/>
    </div>
    <div class="table-responsive">
         
         <table class="table table-striped table-condensed">
                
            <tr>
                <th>
                    <xsl:value-of select="../noa:RrspDescriptionTitle"/>
                </th>
                <th class="noaAmount">
                    <xsl:value-of select="../noa:RrspAmountTitle"/>
                </th>
                                      
            </tr>
            
            
                <xsl:for-each select="../noa:RrspTable">
                    <tr>
                        <xsl:if test="noa:RrspSubTotal ='Y'">
                            <xsl:attribute name="class">totalNoaRow</xsl:attribute>
                        </xsl:if>
                       <td> 
                         
                       
                                <xsl:value-of select="noa:RrspDescriptionMath"/>
                                    <xsl:if test="noa:RrspFinalLine = 'Y'">
                                        <span><xsl:value-of select="noa:RrspDescription"/></span>
                                    </xsl:if>
                               <xsl:if test="noa:RrspFinalLine = 'N'">
                                    <xsl:value-of select="noa:RrspDescription"/>
                                </xsl:if>
                        
                       </td>
                       <td class="noaAmount">
                                                       
                                  <xsl:value-of select="noa:RrspAmount"/>
                                                   
                            
                        </td>
                    </tr>
           </xsl:for-each>
                    
        </table>
        <div>
            <span><xsl:value-of select="../noa:RrspFootParagraph/noa:RrspFootNote"/></span>
        
            <xsl:value-of select="../noa:RrspFootParagraph/noa:RrspFootTextLine"/>
        </div>
             
    </div>
    
    
    
        
        
        
       
</xsl:template>
<xsl:template match="noa:HbpTitle[string-length(text()) > 0]|noa:LlpTitle[string-length(text()) > 0]">

    <xsl:variable name="planName" select="substring(local-name(),1,3)" />
    
    <h2>
        
            <xsl:value-of select="."/>
     </h2>
      <div class="table-responsive">
         
         <table class="table table-striped table-condensed">
                
            <tr>
                
                <th>
    
                   <xsl:value-of select="../noa:HbpDescriptionTitle|../noa:LlpDescriptiontTitle"/>
                </th>
    
                <th class="noaAmount">
                                <xsl:value-of select="../noa:HbpAmountTitle|../noa:LlpAmountTitle"/>
                </th>
            </tr>
            <xsl:for-each select="../noa:HbpTable|../noa:LlpTable">
                <xsl:if test="starts-with(local-name(),$planName)">
                
                <tr>
                    <xsl:if test="noa:HbpFinalLine ='Y'">
                            <xsl:attribute name="class">totalNoaRow</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="noa:LlpFinalLine ='Y'">
                            <xsl:attribute name="class">totalNoaRow</xsl:attribute>
                    </xsl:if>
      
                <td>
                    <span><xsl:value-of select="noa:HbpDescriptionMath|noa:LlpDescriptionMath"/></span> 
                               <xsl:value-of select="noa:HbpDescription|noa:LlpDescription"/>
                                                       
                </td>
      
                            
                <td class="noaAmount">
                        <xsl:value-of select="noa:HbpAmount|noa:LlpAmount"/>
                </td>
                </tr>            
                </xsl:if>
                 </xsl:for-each>
         </table> 
      </div>
                    
             
</xsl:template>
<xsl:template match="noa:ExplanationTableCount[. > 0]">
    
              
     <h2><xsl:value-of select="../noa:ExplanationTitle"/></h2>
     
     <div class="noaSection">
     <xsl:for-each select="../noa:ExplanationTable">
        <p>
            <xsl:value-of select="noa:ExplanationParagraph"/>
        </p>
     </xsl:for-each>
     </div>
</xsl:template>

<xsl:template match="noa:MoreInformationTitle[(normalize-space())]">
    
            
     <h2><xsl:value-of select="../noa:MoreInformationTitle"/></h2>
     
     <div class="noaSection">
     <xsl:for-each select="../noa:MoreInformation/noa:MoreInformationTable">
     
       

     
        <xsl:if test="noa:MoreInformationLineType = 'P'">
        
            
        <p>
            <xsl:value-of select="noa:MoreInformationTextLine"/>
        </p>
        </xsl:if>
        <xsl:if test="noa:MoreInformationLineType = 'B'">
        
        <p>
            <span> &#8226; </span><xsl:value-of select="noa:MoreInformationTextLine"/>
        </p>
        </xsl:if>
        <xsl:if test="noa:MoreInformationLineType = 'T'">
        
        
        <h2>
            <xsl:value-of select="noa:MoreInformationTextLine"/>
        </h2>
        
        
        </xsl:if>
     </xsl:for-each>
     </div>
</xsl:template>
 
 <!-- 
 
    Modified identity template to copy banner.html with a slight transform to the
    tobject element.  Some versions of Java cannot handle the large attribute contained
    in <object>
  -->
 <xsl:template match="node()[not(namespace-uri())]|@*[not(namespace-uri())]">
    
    <!-- Copy the current node -->
    <xsl:copy>
      <!-- Including any attributes it has and any child nodes -->
      <xsl:apply-templates select="@*[not(namespace-uri())]|node()[not(namespace-uri())]"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="//tobject"> 
    <xsl:text disable-output-escaping="yes"> &lt;img </xsl:text> 
    <xsl:for-each select="./*">
        <xsl:value-of select="local-name()"/><xsl:text>="</xsl:text><xsl:value-of select="."/><xsl:text>" </xsl:text>
        
    </xsl:for-each>
    
    <xsl:text disable-output-escaping="yes">>&lt;/img></xsl:text>
  </xsl:template>
  
  

</xsl:stylesheet>