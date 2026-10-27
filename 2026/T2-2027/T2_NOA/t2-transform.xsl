<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY header SYSTEM "header.html">
						   <!ENTITY banner SYSTEM "banner.html">
						   <!ENTITY frbanner SYSTEM "banner.fr.html">
						   <!ENTITY footer SYSTEM "footer.html">
						   <!ENTITY frfooter SYSTEM "footer.fr.html"> ]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      						  xmlns:tdd="http://www.cra-arc.gc.ca/xmlns/tdd/2-1-0" 
      						  xmlns:bn="http://www.cra-arc.gc.ca/xmlns/tdd/bn/1-0-0"
      						  xmlns:noa="http://www.cra-arc.gc.ca/xmlns/bn/1-0-0"
    						  exclude-result-prefixes="tdd bn">

	<xsl:output method="html" encoding="UTF-8"/>
	<xsl:strip-space elements="line paragraph_content"/>

	<!-- Don't output anything -->
	<xsl:template match="//tdd:*|//bn:Manifest|//bn:T2ReturnData|//bn:T2ReturnBalances|//bn:CorporationAccountBalances|//bn:CorporationBNData">
    </xsl:template>

	
	<xsl:template match="//noa:Correspondence | //noa:correspondence">
		<xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html></xsl:text>
		<html class="no-js">
    	<head>
    	&header;
    	<link rel="stylesheet" href="css/theme.min.css" />
		<link rel="stylesheet" href="css/cra-branding.css" />
		<link rel="stylesheet" href="images/favicon.ico" />
    	</head>
    	<body>
		<xsl:if test="noa:Index/noa:Language = '01' or noa:index/noa:language = '01'">
			&banner;
		</xsl:if>
		<xsl:if test="noa:Index/noa:Language = '02' or noa:index/noa:language = '02'">
			&frbanner;
		</xsl:if>
    	<main role="main" property="mainContentOfPage" class="container">      
            <xsl:apply-templates/>
		</main>
		<xsl:if test="noa:Index/noa:Language = '01' or noa:index/noa:language = '01'">
			&footer;
		</xsl:if>
		<xsl:if test="noa:Index/noa:Language = '02' or noa:index/noa:language = '02'">
			&frfooter;
		</xsl:if>
	    </body>
      	</html>
	</xsl:template>

	<xsl:template name="process-table-verse">
		<xsl:param name="bold" />
		<xsl:variable name="prev-sibling-count" select="count(preceding-sibling::ColumnContent)" />

		<xsl:choose>
			<xsl:when test="noa:HAlign='R' and $bold='F' and $prev-sibling-count=0">
				<th class="text-right ntbld" scope="row"> 
					<xsl:value-of select="noa:ColumnText"/>
				</th>
			</xsl:when>
			<xsl:when test="noa:HAlign='R' and $bold='F' and $prev-sibling-count &gt; 0">
				<td class="text-right">
					<xsl:value-of select="noa:ColumnText"/>
				</td>
			</xsl:when>

			<xsl:when test="noa:HAlign='L' and $bold='F' and $prev-sibling-count=0">
				<th class="text-left ntbld" scope="row"> 
					<xsl:value-of select="noa:ColumnText"/>
				</th>
			</xsl:when>
			<xsl:when test="noa:HAlign='L' and $bold='F' and $prev-sibling-count &gt; 0">
				<td class="text-left">
					<xsl:value-of select="noa:ColumnText"/>
				</td>
			</xsl:when>

			<xsl:when test="noa:HAlign='R' and $bold='T' and $prev-sibling-count=0">
				<th class="text-right" scope="row"> 
					<strong>
						<xsl:value-of select="noa:ColumnText"/>
					</strong>
				</th>
			</xsl:when>
			<xsl:when test="noa:HAlign='R' and $bold='T' and $prev-sibling-count &gt; 0">
				<td class="text-right">
					<strong>
						<xsl:value-of select="noa:ColumnText"/>
					</strong>
				</td>
			</xsl:when>

			<xsl:when test="noa:HAlign='L' and $bold='T' and $prev-sibling-count=0">
				<th class="text-left" scope="row"> 
					<strong>
						<xsl:value-of select="noa:ColumnText"/>
					</strong>
				</th>
			</xsl:when>
			<xsl:when test="noa:HAlign='L' and $bold='T' and $prev-sibling-count &gt; 0">
				<td class="text-left">
					<strong>
						<xsl:value-of select="noa:ColumnText"/>
					</strong>
				</td>
			</xsl:when>

			<xsl:otherwise>
				<td class="text-left">
					<xsl:value-of select="noa:ColumnText"/>
				</td>
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:template>

	<xsl:template name="insert-space-when-french">
		<xsl:if test="noa:Index/noa:Language='02'">
			<xsl:value-of select="'&#160;'"/>
		</xsl:if>
	</xsl:template>

	<xsl:template name="insert-colon-and-space">
		<!-- colon : -->
		<xsl:value-of select="'&#58;'"/>
		<!-- non-breaking space -->
		<xsl:value-of select="'&#160;'"/>
	</xsl:template>
	
	<xsl:template match="noa:index">
	</xsl:template>
	
	<!-- Header -->
	<!-- Return Mail -->
	<xsl:template match="noa:header/noa:return_mail_address">
		<xsl:if test="noa:return_mail_content/noa:line!=' '">
			<div id="undeliverable_mail">
				<strong>
					<xsl:value-of select="noa:return_mail_label"/>
					<xsl:call-template name="insert-space-when-french"/>
					<xsl:call-template name="insert-colon-and-space"/>
				</strong>
				<xsl:for-each select="noa:return_mail_content/noa:line">
					<xsl:value-of select="."/>
					<br/>
				</xsl:for-each> 
			</div>
		</xsl:if>
	</xsl:template>

	<!-- Taxpayer legal name -->
	<xsl:template match="noa:correspondence/noa:header/noa:taxpayer_legal_name">
		<xsl:value-of select="."/> 
	</xsl:template>

	<!-- Address -->
	<xsl:template match="noa:header/noa:address">
		<div id="address">
			<strong>
				<xsl:value-of select="noa:address_label"/>
				<xsl:call-template name="insert-space-when-french"/>
				<xsl:call-template name="insert-colon-and-space"/>
			</strong>
			<xsl:for-each select="noa:address_formatted_content/noa:line">
				<xsl:if test=". !=''">
					<xsl:value-of select="."/>
					<br/>
				</xsl:if>
			</xsl:for-each> 
		</div>
	</xsl:template>

	<xsl:template match="noa:header/noa:date">
		<!-- Date -->
		<div id="date">
			<strong>
				<xsl:value-of select="noa:date_label"/>
				<xsl:call-template name="insert-space-when-french"/>
				<xsl:call-template name="insert-colon-and-space"/>
			</strong>
			<xsl:value-of select="noa:date_content"/>  
		</div>
	</xsl:template>

	<!-- Account -->
	<xsl:template match="noa:header/noa:account_number">
		<div id="account">
			<strong>
				<xsl:value-of select="noa:account_number_label"/>
				<xsl:call-template name="insert-space-when-french"/>
				<xsl:call-template name="insert-colon-and-space"/>
			</strong>
			<xsl:for-each select="noa:formatted_account_number/noa:line">
				<xsl:value-of select="."/>
				<br/>
			</xsl:for-each> 
		</div>
	</xsl:template>

	<!-- Period Covered -->
	<xsl:template match="noa:header/noa:period_covered">
		<xsl:if test="noa:period_covered_label !='' and noa:period_covered_label !=' ' ">
			<div id="period_covered">
				<strong>
					<xsl:value-of select="noa:period_covered_label"/>
					<xsl:call-template name="insert-space-when-french"/>
					<xsl:call-template name="insert-colon-and-space"/>
				</strong>
				<xsl:value-of select="noa:period_covered_content/noa:line"/> 
			</div>
		</xsl:if>
	</xsl:template>

	<!-- Reference Number -->
	<xsl:template match="noa:header/noa:reference_number">
		<xsl:if test="noa:reference_number_label !='' and noa:reference_number_label !=' ' ">
			<div id="reference_number">
				<strong>
					<xsl:value-of select="noa:reference_number_label"/>
					<xsl:call-template name="insert-space-when-french"/>
					<xsl:call-template name="insert-colon-and-space"/>
				</strong>
				<xsl:for-each select="noa:formatted_reference_number/noa:line">
					<xsl:value-of select="."/>
					<br/>
				</xsl:for-each> 
			</div>
		</xsl:if>
	</xsl:template>

	<!-- Title -->
	<xsl:template match="noa:title">  
		<!-- <h2> <xsl:value-of select="."/> </h2> --> 
	</xsl:template>

	<!-- Body Sections -->
	<xsl:template match="noa:section">

		<br/>
		<div style="overflow:auto;">
			<xsl:for-each select="noa:paragraph">
				<xsl:choose>
					<xsl:when test="noa:paragraph_title_use='title' ">
						<h2> 
							<xsl:for-each select="noa:paragraph_content/noa:line">
								<xsl:value-of select="."/>
								<xsl:value-of select="'&#32;'" />
								<!-- a space -->
							</xsl:for-each> 
						</h2>
					</xsl:when>

					<!-- ELCS Body Sections -->
					<xsl:when test="noa:paragraph_type='Body           ' ">
						<div style="font-family:monospace; white-space:pre;">
							<xsl:for-each select="noa:paragraph_content">
								<xsl:for-each select="*">
									<xsl:variable name="current_node" select="local-name()"/>

									<xsl:choose>
										<xsl:when test="$current_node='heading'">
											<h2>
												<xsl:value-of select="."/>
											</h2> 
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="."/>
											<xsl:value-of select="'&#xA;'" />

										</xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>
							</xsl:for-each>
							<br/>
						</div>
					</xsl:when>
					<xsl:when test="noa:paragraph_type='Salutation     ' or noa:paragraph_type='SIGNATURE      ' or noa:paragraph_type='Re Line        ' ">
						<p style="font-family:monospace; white-space:pre;">  
							<xsl:for-each select="noa:paragraph_content">
								<xsl:for-each select="*">
									<xsl:value-of select="."/>
									<xsl:value-of select="'&#xA;'" />
								</xsl:for-each>
							</xsl:for-each>
						</p>
					</xsl:when>
					<!-- end ELCS Body Sections -->

					<!-- BCCS columnar verses, paragraph type not equal to 01 need to maintain whitespace for alignment -->
					<xsl:when test="noa:paragraph_format='columnar' and noa:paragraph_type!='01'">
						<p style="font-family:monospace; white-space:pre;"> 
							<xsl:for-each select="noa:paragraph_content/noa:line">
								<xsl:value-of select="."/>
								<xsl:value-of select="'&#xA;'" />
							</xsl:for-each> 
						</p>
					</xsl:when>

					<!-- BCCS columnar verses, paragraph type is 01.  Don't need to maintain whitespace  -->
					<xsl:when test="noa:paragraph_format='columnar' and noa:paragraph_type='01'">
						<p> 
							<xsl:for-each select="noa:paragraph_content/noa:line">
								<xsl:value-of select="."/>
								<xsl:value-of select="'&#160;'"/>
							</xsl:for-each> 
						</p>
					</xsl:when>

					<xsl:otherwise>
						<p>
							<xsl:value-of select="noa:paragraph_content"/> 
						</p>
					</xsl:otherwise>

				</xsl:choose>
			</xsl:for-each>
		</div>
	</xsl:template>

	<!-- element names updated to align with ITB standards + EAC changes -->




	<xsl:template match="noa:Index">
	</xsl:template>

	<!-- Header -->
	<xsl:template match="noa:Header">

		<xsl:choose>
			<xsl:when test="noa:HeaderTitle!=''">
				<section class="panel panel-default">
					<header class="panel-heading">
						<h2 class="mrgn-tp-0 mrgn-bttm-0">
							<xsl:value-of select="noa:HeaderTitle"/>
						</h2>
					</header>
					<div class="panel-body">
						<div class="row">
							<div class="noaPrintRow">
								<div class="col-md-12 noaPrintTuple12">
									<div class="col-md-2">
										<strong>
											<xsl:value-of select="noa:Address/noa:AddressLabel"/>
											<xsl:call-template name="insert-space-when-french"/>
											<xsl:call-template name="insert-colon-and-space"/>
										</strong>
									</div>
									<div class="col-md-10">
										<xsl:for-each select="noa:Address/noa:AddressFormattedContent/noa:Line">
											<xsl:if test=". != '' and . != ' '">
												<xsl:value-of select="."/>
												<br/>
											</xsl:if>
										</xsl:for-each> 
									</div>
								</div>
							</div>
						</div>
						<!-- Account number -->
						<div class="noaPrintRow">
							<div class="col-md-6 noaPrintTuple6">
								<div class="mrgn-bttm-sm">
									<strong>
										<xsl:value-of select="noa:AccountNumber/noa:AccountNumberLabel"/>
										<xsl:call-template name="insert-space-when-french"/>
										<xsl:call-template name="insert-colon-and-space"/>
									</strong>
									<xsl:value-of select="noa:AccountNumber/noa:FormattedAccountNumber/noa:Line"/>
								</div>
							</div>

							<!-- Period Covered -->
							<xsl:if test="noa:PeriodCovered/noa:PeriodCoveredLabel != '' and noa:PeriodCovered/noa:PeriodCoveredLabel != ' '">
								<div class="col-md-6 noaPrintTuple6">
									<div class="mrgn-bttm-sm">
										<strong>
											<xsl:value-of select="noa:PeriodCovered/noa:PeriodCoveredLabel"/>
											<xsl:call-template name="insert-space-when-french"/>
											<xsl:call-template name="insert-colon-and-space"/>
										</strong>
										<xsl:value-of select="noa:PeriodCovered/noa:PeriodCoveredContent/Line"/>  
									</div>
								</div>
							</xsl:if>
						</div>
						<!-- Date issued and Filing date -->
						<xsl:if test="noa:Date/noa:DateLabel != '' and noa:Date/noa:DateLabel != ' '">
							<div class="noaPrintRow">
								<div class="col-md-6 noaPrintTuple6">
									<div class="mrgn-bttm-sm">
										<strong>
											<xsl:value-of select="noa:Date/noa:DateLabel"/>
											<xsl:call-template name="insert-space-when-french"/>
											<xsl:call-template name="insert-colon-and-space"/>
										</strong>
										<xsl:value-of select="noa:Date/noa:DateContent"/>  
									</div>
								</div>
								<xsl:if test="noa:FilingDate/noa:FilingDateLabel != '' and noa:FilingDate/noa:FilingDateLabel != ' '">
									<div class="col-md-6 noaPrintTuple6">
										<div>
											<strong> 
												<xsl:value-of select="noa:FilingDate/noa:FilingDateLabel"/>
												<xsl:call-template name="insert-space-when-french"/>
												<xsl:call-template name="insert-colon-and-space"/>
											</strong> 
											<xsl:for-each select="noa:FilingDate/noa:FilingDateContent/Line">
												<xsl:value-of select="."/>
												<br/>
											</xsl:for-each>										
										</div>
									</div>
								</xsl:if>
							</div>
						</xsl:if>
						<!-- BalanceDueDate -->
						<xsl:if test="noa:BalanceDueDate/noa:BalanceDueDateLabel != '' and noa:BalanceDueDate/noa:BalanceDueDateLabel != ' '">
							<div class="noaPrintRow">
								<div class="col-md-6 noaPrintTuple6">
									<div>
										<strong>
											<xsl:value-of select="noa:BalanceDueDate/noa:BalanceDueDateLabel"/>
											<xsl:call-template name="insert-space-when-french"/>
											<xsl:call-template name="insert-colon-and-space"/>
										</strong> 
										<xsl:for-each select="noa:BalanceDueDate/noa:BalanceDueDateContent/Line">
											<xsl:value-of select="."/>
											<br/>
										</xsl:for-each>										
									</div>
								</div>
							</div>
						</xsl:if>

						<!-- Reference Number -->
						<xsl:if test="noa:ReferenceNumber/noa:ReferenceNumberLabel != '' and noa:ReferenceNumber/noa:ReferenceNumberLabel != ' '">
							<div class="noaPrintRow">
								<div class="col-md-6 noaPrintTuple6">
									<div>
										<strong>
											<xsl:value-of select="noa:ReferenceNumber/noa:ReferenceNumberLabel"/>
											<xsl:call-template name="insert-space-when-french"/>
											<xsl:call-template name="insert-colon-and-space"/>
										</strong> 
										<xsl:for-each select="noa:ReferenceNumber/noa:FormattedReferenceNumber/noa:Line">
											<xsl:value-of select="."/>
											<br/>
										</xsl:for-each>										
									</div>
								</div>
							</div>
						</xsl:if>
						<!-- Taxpayer legal name -->
						<xsl:if test="noa:TaxpayerLegalName/noa:TaxpayerLegalNameLabel != '' and noa:TaxpayerLegalName/noa:TaxpayerLegalNameLabel != ' '">
							<div class="noaPrintRow">
								<div class="col-md-12 noaPrintTuple12">
									<div>
										<strong>
											<xsl:value-of select="noa:TaxpayerLegalName/noa:TaxpayerLegalNameLabel"/>
											<xsl:call-template name="insert-space-when-french"/>
											<xsl:call-template name="insert-colon-and-space"/>
										</strong>
										<xsl:value-of select="noa:TaxpayerLegalName/noa:TaxpayerLegalNameContent"/>  
									</div>
								</div>
							</div>
						</xsl:if>
					</div>

				</section>
			</xsl:when>

			<!-- the OTHERWISE clause handles letters, since these have no value for the HeaderTitle -->
			<xsl:otherwise>
				<p>
					<!-- Address  -->
					<strong>
						<xsl:value-of select="noa:Address/noa:AddressLabel"/>
						<xsl:call-template name="insert-space-when-french"/>
						<xsl:call-template name="insert-colon-and-space"/>
					</strong>
					<xsl:for-each select="noa:Address/noa:AddressFormattedContent/Line">
						<xsl:if test=". != '' and . != ' '">
							<xsl:value-of select="."/>
							<br/>
						</xsl:if>
					</xsl:for-each> 
					<!-- Date  -->
					<xsl:if test="noa:Date/noa:DateLabel != '' and noa:Date/noa:DateLabel != ' '">
						<strong>
							<xsl:value-of select="noa:Date/noa:DateLabel"/>
							<xsl:call-template name="insert-space-when-french"/>
							<xsl:call-template name="insert-colon-and-space"/>
						</strong>
						<xsl:value-of select="noa:Date/noa:DateContent"/>  
						<br/>
					</xsl:if>

					<!-- Account number -->
					<xsl:if test="noa:AccountNumber/noa:AccountNumberLabel != '' and noa:AccountNumber/noa:AccountNumberLabel != ' '">
						<strong>
							<xsl:value-of select="noa:AccountNumber/noa:AccountNumberLabel"/>
							<xsl:call-template name="insert-space-when-french"/>
							<xsl:call-template name="insert-colon-and-space"/>
						</strong>
						<xsl:value-of select="noa:AccountNumber/noa:FormattedAccountNumber/noa:Line"/>
						<br/>
					</xsl:if>
				</p>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<!-- Title -->
	<xsl:template match="noa:Title">  
		<!-- <h2> <xsl:value-of select="."/> </h2> --> 
	</xsl:template>

	<!-- Body Sections -->
	<xsl:template match="noa:Section">
		<xsl:variable name="section_type_code" select="noa:SectionType"/>
		<style type="text/css">th.ntbld {font-weight:normal;}
		</style>

		<xsl:for-each select="*">
			<xsl:variable name="current_node" select="local-name()"/>
			<xsl:choose>
				<!-- Tables -->
				<xsl:when test="$current_node='Table'">
					<div class="table-responsive">
						<table class="table table-condensed table-striped">
							<xsl:for-each select="noa:Paragraph">
								<xsl:choose>
									<xsl:when test="noa:ParagraphType='04'">
										<caption>
											<h3 class="text-left">
												<xsl:value-of select="noa:ParagraphContent/noa:Line"/>
											</h3>
										</caption>
									</xsl:when>
									<xsl:when test="noa:ParagraphType='13'">
										<caption>
											<p class="text-left">
												<xsl:value-of select="noa:ParagraphContent/noa:Line"/>
											</p>
										</caption>
									</xsl:when>
									<xsl:when test="noa:ParagraphType='05'">
										<thead>
											<tr class="active">
												<xsl:for-each select="noa:TableRow/noa:ColumnContent">
													<xsl:choose>
														<xsl:when test="noa:HAlign='R' ">
															<th class="text-right" scope="col">
																<xsl:value-of select="noa:ColumnText"/>
															</th>
														</xsl:when>
														<xsl:otherwise>
															<th class="text-left" scope="col">
																<xsl:value-of select="noa:ColumnText"/>
															</th>
														</xsl:otherwise>
													</xsl:choose>									
												</xsl:for-each>
											</tr>
										</thead>
									</xsl:when>
									<xsl:when test="noa:ParagraphType='06'">
										<tr>
											<xsl:for-each select="noa:TableRow/noa:ColumnContent">
												<xsl:call-template name="process-table-verse">
													<xsl:with-param name="bold" select="'F'" />
												</xsl:call-template>									
											</xsl:for-each>
										</tr>					 
									</xsl:when>
									<xsl:when test="noa:ParagraphType='07' or noa:ParagraphType='11'">
										<tr>
											<xsl:for-each select="noa:TableRow/noa:ColumnContent">
												<xsl:call-template name="process-table-verse">
													<xsl:with-param name="bold" select="'T'" />
												</xsl:call-template>									
											</xsl:for-each>
										</tr>					 
									</xsl:when>
									<xsl:when test="noa:ParagraphType='12'">
										<tr>
											<xsl:for-each select="noa:TableRow/noa:ColumnContent">
												<xsl:call-template name="process-table-verse">
													<xsl:with-param name="bold" select="'T'" />
												</xsl:call-template>										
											</xsl:for-each>
										</tr>					 
									</xsl:when>
								</xsl:choose>
							</xsl:for-each>
						</table>
					</div>
				</xsl:when>
				<!-- Paragraphs -->
				<xsl:when test="$current_node='Header'">
					<div>
						<xsl:value-of select="label"/>
						<xsl:call-template name="insert-colon-and-space"/>
						<strong>
							<xsl:value-of select="content/Line"/>  
						</strong>
					</div>
				</xsl:when>

				<xsl:when test="$current_node='Paragraph'">
					<xsl:variable name="paraFormat" select="noa:ParagraphFormat"/>
					<xsl:choose>
						<xsl:when test="noa:ParagraphTitleUse='title' and noa:ParagraphUseSubCode='level2' ">
							<h2> 
								<xsl:for-each select="noa:ParagraphContent/noa:Line">
									<xsl:value-of select="."/>
									<xsl:value-of select="'&#32;'" />
									<!-- a space -->
								</xsl:for-each> 
							</h2>
						</xsl:when>

						<xsl:when test="noa:ParagraphTitleUse='title' and noa:ParagraphUseSubCode='level3' ">
							<h3> 
								<xsl:for-each select="noa:ParagraphContent/noa:Line">
									<xsl:value-of select="."/>
									<xsl:value-of select="'&#32;'" />
									<!-- a space -->
								</xsl:for-each> 
							</h3>
						</xsl:when>

						<xsl:when test="noa:ParagraphType='01'">
							<p> 
								<xsl:for-each select="noa:ParagraphContent/noa:Line">
									<xsl:choose>
										<xsl:when test=".='' or .=' ' ">
											<br/>
											<br/>
										</xsl:when>
										<xsl:when test="$paraFormat='norm' ">
											<xsl:value-of select="." disable-output-escaping="yes"/>
											<xsl:value-of select="'&#32;'" />
										</xsl:when>
										<xsl:when test="$paraFormat='bold' ">
											<strong>
												<xsl:value-of select="."/>
											</strong>
											<xsl:value-of select="'&#32;'" />
										</xsl:when>
										<xsl:when test="$paraFormat='csig' ">										
											<xsl:value-of select="."/>
											<br/>
										</xsl:when>
									</xsl:choose>
								</xsl:for-each> 
							</p>
						</xsl:when>
						<xsl:when test="noa:ParagraphType='10' and $section_type_code='03' ">
							<p>
								<xsl:for-each select="noa:ParagraphContent/noa:Line">
									<xsl:choose>
										<xsl:when test="$paraFormat='norm' ">
											<xsl:value-of select="." disable-output-escaping="yes"/>
										</xsl:when>
										<xsl:when test="$paraFormat='bold' ">
											<strong>
												<xsl:value-of select="." disable-output-escaping="yes"/>
											</strong>
										</xsl:when>
									</xsl:choose>
									<br/>
								</xsl:for-each>
							</p>
						</xsl:when>
						<xsl:when test="noa:ParagraphType='10' and $paraFormat='vbrk'">   
							<p> 
								<xsl:for-each select="noa:ParagraphContent/noa:Line">
									<xsl:choose>
										<xsl:when test=".='' or .=' ' ">
											<br/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="." disable-output-escaping="yes"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>
							</p>
						</xsl:when>
						<xsl:when test="noa:ParagraphType='10' or noa:ParagraphType='99' or noa:ParagraphType='15'">
							<p> 
								<xsl:for-each select="noa:ParagraphContent/noa:Line">
									<xsl:choose>
										<xsl:when test=".='' or .=' ' ">
											<br/>
											<br/>
										</xsl:when>
										<xsl:when test="$paraFormat='norm' ">
											<xsl:value-of select="." disable-output-escaping="yes"/>
										</xsl:when>
										<xsl:when test="$paraFormat='bold' ">
											<strong>
												<xsl:value-of select="."/>
											</strong>
										</xsl:when>
										<xsl:when test="$paraFormat='csig' ">										
											<xsl:value-of select="."/>
											<br/>
										</xsl:when>
										<xsl:when test="$paraFormat='vbrk' ">										
											<xsl:value-of select="." disable-output-escaping="yes"/>
											<br/>
										</xsl:when>
									</xsl:choose>

								</xsl:for-each> 
							</p>
						</xsl:when>

						<xsl:when test="noa:ParagraphType='02' or noa:ParagraphType='03'">
							<p style="font-family:monospace; white-space:pre;"> 
								<xsl:for-each select="noa:ParagraphContent/noa:Line">
									<xsl:choose>
										<xsl:when test="$paraFormat='norm' ">
											<xsl:value-of select="."/>
										</xsl:when>
										<xsl:when test="$paraFormat='bold' ">
											<strong>
												<xsl:value-of select="."/>
											</strong>
										</xsl:when>
									</xsl:choose>
									<xsl:value-of select="'&#xA;'" />
								</xsl:for-each> 
							</p>
						</xsl:when>
						<xsl:otherwise>
							<p> 
								<xsl:for-each select="noa:ParagraphContent/noa:Line">
									<xsl:choose>
										<xsl:when test="$paraFormat='norm' ">
											<xsl:value-of select="." disable-output-escaping="yes"/>
										</xsl:when>
										<xsl:when test="$paraFormat='bold' ">
											<strong>
												<xsl:value-of select="."/>
											</strong>
										</xsl:when>
										<xsl:when test="$paraFormat='csig' ">										
											<xsl:value-of select="."/>
											<br/>
										</xsl:when>
									</xsl:choose>
									<xsl:value-of select="'&#32;'"/>
								</xsl:for-each> 
							</p>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$current_node='List'">
					<xsl:choose>
						<xsl:when test="noa:ListType='A'">
							<ol type="A">
								<xsl:for-each select="noa:Paragraph/noa:Line">
									<li>
										<xsl:value-of select="."/>
									</li>
								</xsl:for-each> 
							</ol> 
						</xsl:when>
					</xsl:choose>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>