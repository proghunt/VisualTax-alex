<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
							  xmlns:noa="http://www.cra-arc.gc.ca/xmlns/tdd/noa/1-2-0" 	
							  xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"  
							  xmlns:tdd="http://www.cra-arc.gc.ca/xmlns/tdd/2-1-0"  
							  exclude-result-prefixes="tdd noa soap">

	<xsl:output method="html" encoding="UTF-8"/>

	<xsl:template name="process-xnoa-paragraph">
		<xsl:param name="currentParagraph" />
		<xsl:choose>
			<xsl:when test="noa:Subtitle ='Y'">
				<xsl:if test="noa:ParagraphObjectText!='' ">
					<xsl:value-of select="noa:ParagraphObjectText"/>
				</xsl:if>
			</xsl:when>
			<xsl:when test="noa:BoldIndicator ='Y'"> 
				<xsl:if test="noa:ParagraphObjectText!='' ">
					<strong><xsl:value-of select="noa:ParagraphObjectText"/></strong>
				</xsl:if>
			</xsl:when>
			
			<xsl:otherwise>
				<xsl:for-each select="*">
					<xsl:variable name="current" select="local-name()"/>
					<xsl:choose>
						<xsl:when test="$current='NewLineIndicator'">
							<xsl:if test="current()='Y'">
								<br/>
							</xsl:if>
						</xsl:when>
						<xsl:when test="$current='ParagraphObjectText'">
							<xsl:choose>
								<xsl:when test="starts-with(current(), 'cra.gc') or starts-with(current(), 'arc.gc') or starts-with(current(), 'canada.ca') 
								             or starts-with(current(), ' cra.gc') or starts-with(current(), ' arc.gc')">
									<strong>
										<xsl:value-of select="."/>
									</strong>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="."/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
					</xsl:choose>	
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="process-xnoa-v5">
		<!-- Notice Details -->
		<section class="panel panel-default">
			<header class="panel-heading">
				<h2 class="mrgn-tp-0 mrgn-bttm-0">
					<xsl:value-of select="noa:NoticeDetailsTitle"/>
				</h2>
			</header>
			<div class="panel-body">				
				<div class="row">	
					<!-- Address  -->
					<div class="noaPrintRow">
						<div class="col-md-2 noaPrintTuple2">
							<div class="mrgn-bttm-sm">
								<strong>
									<xsl:value-of select="noa:AddressTitle"/> 
									<xsl:if test="noa:Language='F'">
										<xsl:value-of select="'&#160;'"/>
									</xsl:if>
									<xsl:value-of select="'&#58;'"/>
								</strong>
							</div>
						</div>
						<div class="col-md-10 noaPrintTuple10">
							<div class="mrgn-bttm-sm">
								<xsl:if test="noa:AddressLine1Text !='' and noa:AddressLine1Text !=' '">
									<xsl:value-of select="noa:AddressLine1Text"/>
									<br/>
								</xsl:if>
								<xsl:if test="noa:AddressLine2Text !='' and noa:AddressLine2Text !=' '">
									<xsl:value-of select="noa:AddressLine2Text"/>
									<br/>
								</xsl:if>
								<xsl:if test="noa:AddressLine3Text !='' and noa:AddressLine3Text !=' '">
									<xsl:value-of select="noa:AddressLine3Text"/>
									<br/>
								</xsl:if>
								<xsl:if test="noa:AddressLine4Text !='' and noa:AddressLine4Text !=' '">
									<xsl:value-of select="noa:AddressLine4Text"/>
									<br/>
								</xsl:if>
								<xsl:if test="noa:AddressLine5Text !='' and noa:AddressLine5Text !=' '">
									<xsl:value-of select="noa:AddressLine5Text"/>
									<br/>
								</xsl:if>
								<xsl:if test="noa:AddressLine6Text !='' and noa:AddressLine6Text !=' '">
									<xsl:value-of select="noa:AddressLine6Text"/>
									<br/>
								</xsl:if>
								<xsl:if test="noa:AddressLine7Text !='' and noa:AddressLine7Text !=' '">
									<xsl:value-of select="noa:AddressLine7Text"/>
									<br/>
								</xsl:if>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="noaPrintRow">
						<!-- SIN -->
						<xsl:if test="noa:AccountNumberTitle !='' and noa:AccountNumberTitle !=' '"> 
							<div class="col-md-6 noaPrintTuple6">
								<div class="mrgn-bttm-sm">
									<strong>
										<xsl:value-of select="noa:AccountNumberTitle"/> 
										<xsl:if test="noa:Language='F'">
											<xsl:value-of select="'&#160;'"/>
										</xsl:if>
										<xsl:value-of select="'&#58;'"/>
										<xsl:value-of select="'&#160;'"/>
									</strong>
									<xsl:value-of select="noa:MaskedAccountNumber"/> 
								</div>
							</div>
						</xsl:if>
						<!-- Tax year	-->
						<xsl:if test="noa:TaxYearTitle !='' and noa:TaxYearTitle !=' '">
							<div class="col-md-6 noaPrintTuple6">
								<div class="mrgn-bttm-sm">
									<strong>
										<xsl:value-of select="noa:TaxYearTitle"/> 
										<xsl:if test="noa:Language='F'">
											<xsl:value-of select="'&#160;'"/>
										</xsl:if>
										<xsl:value-of select="'&#58;'"/>
										<xsl:value-of select="'&#160;'"/>
									</strong>
									<xsl:value-of select="noa:TaxYear"/>
								</div>
							</div>
						</xsl:if>
					</div>
				</div>
				<div class="row">
					<div class="noaPrintRow">
						<!-- Date issued -->
						<xsl:if test="noa:AssessmentTitle !='' and noa:AssessmentTitle !=' '">
							<div class="col-md-6 noaPrintTuple6">
								<div class="mrgn-bttm-sm">
									<strong>
										<xsl:value-of select="noa:AssessmentTitle"/> 
										<xsl:if test="noa:Language='F'">
											<xsl:value-of select="'&#160;'"/>
										</xsl:if>
										<xsl:value-of select="'&#58;'"/>
										<xsl:value-of select="'&#160;'"/>
									</strong>
									<xsl:value-of select="noa:AssessmentDateText"/>
								</div>
							</div>
						</xsl:if>
						<!-- Return type -->
						<xsl:if test="noa:ReturnType !='' and noa:ReturnType !=' '">
							<div class="col-md-6 noaPrintTuple6">
								<div class="mrgn-bttm-sm">
									<strong>
										<xsl:value-of select="noa:ReturnTypeTitle"/> 
										<xsl:if test="noa:Language='F'">
											<xsl:value-of select="'&#160;'"/>
										</xsl:if>
										<xsl:value-of select="'&#58;'"/>
										<xsl:value-of select="'&#160;'"/>
									</strong>
									<xsl:value-of select="noa:ReturnType"/> 
								</div>
							</div>
						</xsl:if>
						<!-- Return Mail XNOA -->
						<xsl:if test="noa:ReturnMail/noa:ReturnMailText !='' and noa:ReturnMail/noa:ReturnMailText !=' '">
							<div class="col-md-6 noaPrintTuple6">
								<div class="mrgn-bttm-sm">
									<strong>
										<xsl:if test="noa:Language='E'">
											<xsl:text>Tax centre</xsl:text>
										</xsl:if>
										<xsl:if test="noa:Language='F'">
											<xsl:text>Centre fiscal</xsl:text>
											<xsl:value-of select="'&#160;'"/>
										</xsl:if>
										<xsl:value-of select="'&#58;'"/>
										<xsl:value-of select="'&#160;'"/>
									</strong>
									<xsl:value-of select="noa:ReturnMail/noa:ReturnMailText"/> 
								</div>
							</div>
						</xsl:if>
					</div>
				</div>
			</div>
		</section>

		<!-- Internet Access Code -->
		<xsl:if test="noa:AccessCode !='' and noa:AccessCode !=' '">
			<div class="text-right">
				<strong>
					<xsl:value-of select="noa:AccessCodeTitle"/>  
					<xsl:if test="noa:Language='F'">
						<xsl:value-of select="'&#160;'"/>
					</xsl:if>
					<xsl:value-of select="'&#58;'"/>
					<xsl:value-of select="'&#160;'"/>
				</strong>
				<xsl:value-of select="noa:AccessCode"/>
			</div>
		</xsl:if>

		<!-- Account balance section -->
		<div class="accountBalanceSection">
			<xsl:if test="noa:BalanceTitle != '' and noa:BalanceTitle != ' '">
				<h2>
					<xsl:value-of select="BalanceTitle"/>
				</h2>
			</xsl:if>
			<xsl:for-each select="noa:BalanceText">
				<p>
					<xsl:for-each select="noa:ParagraphObject">
						<xsl:call-template name="process-xnoa-paragraph" >
							<xsl:with-param name="currentParagraph" select="current()" />
						</xsl:call-template>
					</xsl:for-each>
				</p>	
			</xsl:for-each>
		</div>

		<!-- Commissioner -->
		<div class="commissionerSection">	
			<xsl:for-each select="noa:CommisionerSignatureText">
				<p>
					<xsl:for-each select="noa:ParagraphObject">
						<xsl:call-template name="process-xnoa-paragraph" >
							<xsl:with-param name="currentParagraph" select="current()" />
						</xsl:call-template>
					</xsl:for-each>
				</p>	
			</xsl:for-each>
		</div>

		<!-- Account Summary -->
		<xsl:if test="noa:AccountSummaryTitle !='' and noa:AccountSummaryTitle !=' '"> 
			<div>	
				<h2>
					<xsl:value-of select="noa:AccountSummaryTitle"/>
				</h2>
				<p class="text-left">
					<xsl:value-of select="noa:AccountSummaryText"/> 		
				</p>
				<p>
					<strong>
						<xsl:value-of select="noa:FinalBalanceAmountTitle"/>
						<xsl:value-of select="'&#160;'"/>
					</strong>
					<xsl:value-of select="noa:FinalBalanceAmount"/>

					<br />
					<strong>
						<xsl:value-of select="noa:PayByTitle"/>
						<xsl:value-of select="'&#160;'"/>
					</strong>
					<xsl:value-of select="noa:PayByDate"/>
				</p>
			</div>
		</xsl:if>
		<!-- Tax Assessment -->
		<div class="taxAssessmentSection">
			<h2>
				<xsl:value-of select="noa:TaxAssessmentTitle"/>
			</h2>
			<xsl:for-each select="noa:TaxAssessment">
				<p>
					<xsl:for-each select="noa:ParagraphObject">
						<xsl:call-template name="process-xnoa-paragraph" >
							<xsl:with-param name="currentParagraph" select="current()" />
						</xsl:call-template>
					</xsl:for-each>
				</p>	
			</xsl:for-each>
		</div>

		<!-- Summary -->
		<div class="table-responsive">
			<xsl:variable name="noticeType" select="noa:NoticeType"/>
			<!-- Summary table -->
			<table class="table table-condensed table-striped">
				<caption>
					<h3 class="text-left"> 
						<xsl:value-of select="noa:SummaryTitle"/>
					</h3>
				</caption>
				<thead>
					<tr>
						<th class="text-left" scope="col">
							<xsl:value-of select="noa:LineTitle"/>
						</th>
						<th class="text-left" scope="col">
							<xsl:value-of select="noa:DescriptionTitle"/>
						</th>
						<xsl:if test="$noticeType='0267' or $noticeType='0268' or $noticeType='0269' or $noticeType='0271'
							          	or $noticeType='0273' or $noticeType='0276' or $noticeType='0277' or $noticeType='0339' 
							          	or $noticeType='0491' or $noticeType='0767' or $noticeType='T491'">
							<th class="text-right" scope="col">
								<xsl:value-of select="noa:ReturnAmountTitle"/>
							</th>  
							<th class="text-left" scope="col">
								<xsl:value-of select="noa:CRDRReturnAmountTitle"/>
							</th> 
						</xsl:if>
						<th class="text-right" scope="col">
							<xsl:value-of select="noa:FinalAmountTitle"/>
						</th>  
						<th class="text-left" scope="col">
							<xsl:value-of select="noa:CRDRFinalAmountTitle"/>
						</th> 
					</tr> 
				</thead>
				<tbody>	
					<xsl:for-each select="noa:SummaryTableRow">
						<tr>
							<xsl:choose>
								<xsl:when test="position()=last()">
									<!--the row should be strong when true -->
									<td class="text-left">
										<strong>
											<xsl:value-of select="noa:SummaryLineNumber"/>
										</strong>
									</td>
									<td class="text-left">
										<strong>
											<xsl:value-of select="noa:SummaryDescription"/>
										</strong>
									</td>
									<xsl:if test="$noticeType='0267' or $noticeType='0268' or $noticeType='0269' or $noticeType='0271'
							          	or $noticeType='0273' or $noticeType='0276' or $noticeType='0277' or $noticeType='0339' 
							          	or $noticeType='0491' or $noticeType='0767' or $noticeType='T491'">
										<td class="text-right">
											<strong>
												<xsl:value-of select="noa:ReturnAmount"/>
											</strong>
										</td>
										<td class="text-left">
											<strong>
												<xsl:value-of select="noa:CRDRReturnAmountIndicator"/>
											</strong>
										</td>
									</xsl:if>
									<td class="text-right">
										<strong>
											<xsl:value-of select="noa:FinalAmount"/>
										</strong>
									</td>
									<td class="text-left">
										<strong>
											<xsl:value-of select="noa:CRDRFinalAmountIndicator"/>
										</strong>
									</td>
								</xsl:when>
								<xsl:otherwise>
									<td class="text-left">
										<xsl:value-of select="noa:SummaryLineNumber"/>
									</td>
									<td class="text-left">
										<xsl:value-of select="noa:SummaryDescription"/>
									</td>
									<xsl:if test="$noticeType='0267' or $noticeType='0268' or $noticeType='0269' or $noticeType='0271'
							          	or $noticeType='0273' or $noticeType='0276' or $noticeType='0277' or $noticeType='0339' 
							          	or $noticeType='0491' or $noticeType='0767' or $noticeType='T491'">
										<td class="text-right">
											<xsl:value-of select="noa:ReturnAmount"/>
										</td>
										<td class="text-left">
											<xsl:value-of select="noa:CRDRReturnAmountIndicator"/>
										</td>
									</xsl:if>
									<td class="text-right">
										<xsl:value-of select="noa:FinalAmount"/>
									</td>
									<td class="text-left">
										<xsl:value-of select="noa:CRDRFinalAmountIndicator"/>
									</td>
								</xsl:otherwise>
							</xsl:choose>
						</tr>
					</xsl:for-each>
				</tbody>	
			</table>
		</div>

		<!-- Explan -->
		<div>
			<h4>
				<xsl:value-of select="noa:ExplanTitle"/>
			</h4>	

			<xsl:for-each select="noa:ExplanText">
				<p>
					<xsl:for-each select="noa:ParagraphObject">
						<xsl:call-template name="process-xnoa-paragraph" >
							<xsl:with-param name="currentParagraph" select="current()" />
						</xsl:call-template>
					</xsl:for-each>
				</p>	
			</xsl:for-each>
		</div>

		<!-- RRSP section -->
		<xsl:if test="noa:RRSPTitle !=''">
			<h4>
				<xsl:value-of select="noa:RRSPTitle"/>
			</h4>

			<p class="text-left">
				<xsl:for-each select="noa:RRSPIntro">
					<xsl:choose>
						<xsl:when test="noa:BoldIndicator ='Y'"> 
							<strong>
								<xsl:value-of select="noa:RRSPIntroText"/>
							</strong>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="not(contains(current(), 'cra.gc')) and not(contains(current(), 'arc.gc'))">
									<xsl:value-of select="noa:RRSPIntroText"/>
								</xsl:when>
								<xsl:otherwise>
									<strong>
										<xsl:value-of select="noa:RRSPIntroText"/>
									</strong>
								</xsl:otherwise>
							</xsl:choose>

						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</p>

			<div class="table-responsive">		
				<table class="table table-condensed table-striped">
					<thead>
						<tr>
							<th class="text-left" scope="col">
								<xsl:value-of select="noa:RRSPDescriptionTitle"/>
							</th>	
							<th class="text-right" scope="col">
								<xsl:value-of select="noa:RRSPAmountTitle"/>
							</th>
						</tr> 
					</thead>
					<tbody>	
						<xsl:for-each select="noa:RRSPTableRow">
							<tr>
								<xsl:choose>
									<xsl:when test="noa:RRSPSubTotalRowIndicator='Y'"> 
										<!--the row should be strong when true -->
										<td class="text-left">
											<xsl:for-each select="noa:RRSPDescription">
												<strong>
													<xsl:value-of select="noa:RRSPDescriptionText"/>
												</strong>
											</xsl:for-each>
										</td>								
										<td class="text-right">
											<xsl:for-each select="noa:RRSPAmount">
												<strong>
													<xsl:value-of select="noa:RRSPAmountText"/>
												</strong>
											</xsl:for-each>
										</td>
									</xsl:when>
									<xsl:otherwise>
										<td class="text-left">
											<xsl:for-each select="noa:RRSPDescription">
												<xsl:if test="noa:BoldIndicator ='N'"> 
													<xsl:value-of select="noa:RRSPDescriptionText"/>
												</xsl:if>
												<xsl:if test="noa:BoldIndicator ='Y'"> 
													<strong>
														<xsl:value-of select="noa:RRSPDescriptionText"/>
													</strong>
													<xsl:value-of select="'&#160;'"/>
												</xsl:if>
											</xsl:for-each>
										</td>
										<td class="text-right">
											<xsl:for-each select="noa:RRSPAmount">
												<xsl:if test="noa:BoldIndicator ='N'"> 
													<xsl:value-of select="noa:RRSPAmountText"/>
												</xsl:if>
												<xsl:if test="noa:BoldIndicator ='Y'"> 
													<strong>
														<xsl:value-of select="noa:RRSPAmountText"/>
													</strong>
												</xsl:if>
											</xsl:for-each>
										</td>
									</xsl:otherwise>
								</xsl:choose>
							</tr>
						</xsl:for-each>
					</tbody>	
				</table>
			</div>

			<p class="text-left">
				<xsl:for-each select="noa:RRSPNote">
					<xsl:choose>
						<xsl:when test="noa:BoldIndicator ='Y'"> 
							<strong>
								<xsl:value-of select="noa:RRSPNoteText"/>
							</strong>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="noa:RRSPNoteText"/>
						</xsl:otherwise>
					</xsl:choose>

				</xsl:for-each>
			</p>
		</xsl:if>

		<!-- Home Buyer's Plan section -->
		<xsl:if test="noa:HBPTitle !=''">
			<div class="table-responsive">
				<table class="table table-condensed table-striped">
					<caption>
						<h4 class="text-left"> 
							<xsl:value-of select="noa:HBPTitle"/>
						</h4>
					</caption>
					<thead>
						<tr>
							<th class="text-left" scope="col">
								<xsl:value-of select="noa:HBPDescriptionTitle"/>
							</th>
							<th class="text-right" scope="col">
								<xsl:value-of select="noa:HBPAmountTitle"/>
							</th>
						</tr>
					</thead>
					<tbody>	
						<xsl:for-each select="noa:HBPTableRow">
							<tr>
								<xsl:choose>
									<xsl:when test="noa:HBPSubTotalRowIndicator='Y'"> 
										<!--the row should be strong when true -->
										<td class="text-left">
											<xsl:for-each select="noa:HBPDescription">
												<strong>
													<xsl:value-of select="noa:HBPDescriptionText"/>
												</strong>
											</xsl:for-each>
										</td>								
										<td class="text-right">
											<xsl:for-each select="noa:HBPAmount">
												<strong>
													<xsl:value-of select="noa:HBPAmountText"/>
												</strong>
											</xsl:for-each>
										</td>
									</xsl:when>
									<xsl:otherwise>
										<td class="text-left">
											<xsl:for-each select="noa:HBPDescription">
												<xsl:if test="noa:BoldIndicator ='N'"> 
													<xsl:value-of select="noa:HBPDescriptionText"/>
												</xsl:if>
												<xsl:if test="noa:BoldIndicator ='Y'"> 
													<strong>
														<xsl:value-of select="noa:HBPDescriptionText"/>
													</strong>
												</xsl:if>
											</xsl:for-each>
										</td>
										<td class="text-right">
											<xsl:for-each select="noa:HBPAmount">
												<xsl:if test="noa:BoldIndicator ='N'"> 
													<xsl:value-of select="noa:HBPAmountText"/>
												</xsl:if>
												<xsl:if test="noa:BoldIndicator ='Y'"> 
													<strong>
														<xsl:value-of select="noa:HBPAmountText"/>
													</strong>
												</xsl:if>
											</xsl:for-each>
										</td>
									</xsl:otherwise>
								</xsl:choose>
							</tr>
						</xsl:for-each>
					</tbody>	
				</table>
			</div>
		</xsl:if>

		<!-- Lifelong Learning Plan section -->					
		<xsl:if test="noa:LLPTitle !=''">
			<div class="table-responsive">
				<table class="table table-condensed table-striped">
					<caption>
						<h4 class="text-left"> 
							<xsl:value-of select="noa:LLPTitle"/>
						</h4>
					</caption>
					<thead>
						<tr>
							<th class="text-left" scope="col">
								<xsl:value-of select="noa:LLPDescriptionTitle"/>
							</th>
							<th class="text-right" scope="col">
								<xsl:value-of select="noa:LLPAmountTitle"/>
							</th>                     
						</tr>
					</thead>
					<tbody>	
						<xsl:for-each select="noa:LLPTableRow">
							<tr>
								<xsl:choose>
									<xsl:when test="noa:LLPSubTotalRowIndicator='Y'"> 
										<!--the row should be strong when true -->
										<td class="text-left">
											<xsl:for-each select="noa:LLPDescription">
												<strong>
													<xsl:value-of select="noa:LLPDescriptionText"/>
												</strong>
											</xsl:for-each>
										</td>								
										<td class="text-right">
											<xsl:for-each select="noa:LLPAmount">
												<strong>
													<xsl:value-of select="noa:LLPAmountText"/>
												</strong>
											</xsl:for-each>
										</td>
									</xsl:when>
									<xsl:otherwise>
										<td class="text-left">
											<xsl:for-each select="noa:LLPDescription">
												<xsl:if test="noa:BoldIndicator ='N'"> 
													<xsl:value-of select="noa:LLPDescriptionText"/>
												</xsl:if>
												<xsl:if test="noa:BoldIndicator ='Y'"> 
													<strong>
														<xsl:value-of select="noa:LLPDescriptionText"/>
													</strong>
												</xsl:if>
											</xsl:for-each>
										</td>
										<td class="text-right">
											<xsl:for-each select="noa:LLPAmount">
												<xsl:if test="noa:BoldIndicator ='N'"> 
													<xsl:value-of select="noa:LLPAmountText"/>
												</xsl:if>
												<xsl:if test="noa:BoldIndicator ='Y'"> 
													<strong>
														<xsl:value-of select="noa:LLPAmountText"/>
													</strong>
												</xsl:if>
											</xsl:for-each>
										</td>
									</xsl:otherwise>
								</xsl:choose>
							</tr>
						</xsl:for-each>
					</tbody>	
				</table>
			</div>
		</xsl:if>

		<div class="moreInformationSection">
			<h2>
				<xsl:value-of select="noa:MoreInformationTitle"/>
			</h2>
			<xsl:for-each select="noa:MoreInformation">
				<xsl:choose>
					<xsl:when test="noa:ParagraphObject/noa:Subtitle='Y' ">
						<h3>
							<xsl:for-each select="noa:ParagraphObject">
								<xsl:call-template name="process-xnoa-paragraph" >
									<xsl:with-param name="currentParagraph" select="current()" />
								</xsl:call-template>
							</xsl:for-each>
						</h3>
					</xsl:when>
					<xsl:otherwise>
						<p>
							<xsl:for-each select="noa:ParagraphObject">
								<xsl:call-template name="process-xnoa-paragraph" >
									<xsl:with-param name="currentParagraph" select="current()" />
								</xsl:call-template>
							</xsl:for-each>
						</p>
					</xsl:otherwise>
				</xsl:choose>	

			</xsl:for-each>
		</div>
	</xsl:template>
	
	<xsl:template name="process-xnoa-v6">
		<!-- Notice Details -->
		<section class="panel panel-default">
			<header class="panel-heading">
				<h2 class="mrgn-tp-0 mrgn-bttm-0">
					<xsl:value-of select="noa:NoticeDetailsTitle"/>
				</h2>
			</header>
			<div class="panel-body">				
				<div class="row">	
					<!-- Address  -->
					<div class="noaPrintRow">
						<div class="col-md-2 noaPrintTuple2">
							<div class="mrgn-bttm-sm">
								<strong>
									<xsl:value-of select="noa:AddressTitle"/> 
									<xsl:if test="noa:Language='F'">
										<xsl:value-of select="'&#160;'"/>
									</xsl:if>
									<xsl:value-of select="'&#58;'"/>
								</strong>
							</div>
						</div>
						<div class="col-md-10 noaPrintTuple10">
							<div class="mrgn-bttm-sm">
								<xsl:if test="noa:AddressLine1Text !='' and noa:AddressLine1Text !=' '">
									<xsl:value-of select="noa:AddressLine1Text"/>
									<br/>
								</xsl:if>
								<xsl:if test="noa:AddressLine2Text !='' and noa:AddressLine2Text !=' '">
									<xsl:value-of select="noa:AddressLine2Text"/>
									<br/>
								</xsl:if>
								<xsl:if test="noa:AddressLine3Text !='' and noa:AddressLine3Text !=' '">
									<xsl:value-of select="noa:AddressLine3Text"/>
									<br/>
								</xsl:if>
								<xsl:if test="noa:AddressLine4Text !='' and noa:AddressLine4Text !=' '">
									<xsl:value-of select="noa:AddressLine4Text"/>
									<br/>
								</xsl:if>
								<xsl:if test="noa:AddressLine5Text !='' and noa:AddressLine5Text !=' '">
									<xsl:value-of select="noa:AddressLine5Text"/>
									<br/>
								</xsl:if>
								<xsl:if test="noa:AddressLine6Text !='' and noa:AddressLine6Text !=' '">
									<xsl:value-of select="noa:AddressLine6Text"/>
									<br/>
								</xsl:if>
								<xsl:if test="noa:AddressLine7Text !='' and noa:AddressLine7Text !=' '">
									<xsl:value-of select="noa:AddressLine7Text"/>
									<br/>
								</xsl:if>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="noaPrintRow">
						<!-- SIN -->
						<xsl:if test="noa:AccountNumberTitle !='' and noa:AccountNumberTitle !=' '"> 
							<div class="col-md-6 noaPrintTuple6">
								<div class="mrgn-bttm-sm">
									<strong>
										<xsl:value-of select="noa:AccountNumberTitle"/> 
										<xsl:if test="noa:Language='F'">
											<xsl:value-of select="'&#160;'"/>
										</xsl:if>
										<xsl:value-of select="'&#58;'"/>
										<xsl:value-of select="'&#160;'"/>
									</strong>
									<xsl:value-of select="noa:MaskedAccountNumber"/> 
								</div>
							</div>
						</xsl:if>
						<!-- Tax year	-->
						<xsl:if test="noa:TaxYearTitle !='' and noa:TaxYearTitle !=' '">
							<div class="col-md-6 noaPrintTuple6">
								<div class="mrgn-bttm-sm">
									<strong>
										<xsl:value-of select="noa:TaxYearTitle"/> 
										<xsl:if test="noa:Language='F'">
											<xsl:value-of select="'&#160;'"/>
										</xsl:if>
										<xsl:value-of select="'&#58;'"/>
										<xsl:value-of select="'&#160;'"/>
									</strong>
									<xsl:value-of select="noa:TaxYear"/>
								</div>
							</div>
						</xsl:if>
					</div>
				</div>
				<div class="row">
					<div class="noaPrintRow">
						<!-- Date issued -->
						<xsl:if test="noa:AssessmentTitle !='' and noa:AssessmentTitle !=' '">
							<div class="col-md-6 noaPrintTuple6">
								<div class="mrgn-bttm-sm">
									<strong>
										<xsl:value-of select="noa:AssessmentTitle"/> 
										<xsl:if test="noa:Language='F'">
											<xsl:value-of select="'&#160;'"/>
										</xsl:if>
										<xsl:value-of select="'&#58;'"/>
										<xsl:value-of select="'&#160;'"/>
									</strong>
									<xsl:value-of select="noa:AssessmentDateText"/>
								</div>
							</div>
						</xsl:if>
						<!-- Return type -->
						<xsl:if test="noa:ReturnType !='' and noa:ReturnType !=' '">
							<div class="col-md-6 noaPrintTuple6">
								<div class="mrgn-bttm-sm">
									<strong>
										<xsl:value-of select="noa:ReturnTypeTitle"/> 
										<xsl:if test="noa:Language='F'">
											<xsl:value-of select="'&#160;'"/>
										</xsl:if>
										<xsl:value-of select="'&#58;'"/>
										<xsl:value-of select="'&#160;'"/>
									</strong>
									<xsl:value-of select="noa:ReturnType"/> 
								</div>
							</div>
						</xsl:if>
						<!-- Return Mail XNOA -->
						<xsl:if test="noa:ReturnMail/noa:ReturnMailText !='' and noa:ReturnMail/noa:ReturnMailText !=' '">
							<div class="col-md-6 noaPrintTuple6">
								<div class="mrgn-bttm-sm">
									<strong>
										<xsl:if test="noa:Language='E'">
											<xsl:text>Tax centre</xsl:text>
										</xsl:if>
										<xsl:if test="noa:Language='F'">
											<xsl:text>Centre fiscal</xsl:text>
											<xsl:value-of select="'&#160;'"/>
										</xsl:if>
										<xsl:value-of select="'&#58;'"/>
										<xsl:value-of select="'&#160;'"/>
									</strong>
									<xsl:value-of select="noa:ReturnMail/noa:ReturnMailText"/> 
								</div>
							</div>
						</xsl:if>
					</div>
				</div>
			</div>
		</section>

		<!-- Internet Access Code -->
		<xsl:if test="noa:AccessCode !='' and noa:AccessCode !=' '">
			<div class="text-right">
				<strong>
					<xsl:value-of select="noa:AccessCodeTitle"/>  
					<xsl:if test="noa:Language='F'">
						<xsl:value-of select="'&#160;'"/>
					</xsl:if>
					<xsl:value-of select="'&#58;'"/>
					<xsl:value-of select="'&#160;'"/>
				</strong>
				<xsl:value-of select="noa:AccessCode"/>
			</div>
		</xsl:if>

		<!-- Account balance section -->
		<div class="accountBalanceSection">
			<xsl:if test="noa:BalanceTitle != '' and noa:BalanceTitle != ' '">
				<h2>
					<xsl:value-of select="BalanceTitle"/>
				</h2>
			</xsl:if>
			<xsl:for-each select="noa:BalanceText">
				<p>
					<xsl:for-each select="noa:ParagraphObject">
						<xsl:call-template name="process-xnoa-paragraph" >
							<xsl:with-param name="currentParagraph" select="current()" />
						</xsl:call-template>
					</xsl:for-each>
				</p>	
			</xsl:for-each>
		</div>

		<!-- Commissioner -->
		<div class="commissionerSection">	
			<xsl:for-each select="noa:CommisionerSignatureText">
				<p>
					<xsl:for-each select="noa:ParagraphObject">
						<xsl:call-template name="process-xnoa-paragraph" >
							<xsl:with-param name="currentParagraph" select="current()" />
						</xsl:call-template>
					</xsl:for-each>
				</p>	
			</xsl:for-each>
		</div>

		<!-- Account Summary -->
		<xsl:if test="noa:AccountSummaryTitle !='' and noa:AccountSummaryTitle !=' '"> 
			<div>	
				<h2>
					<xsl:value-of select="noa:AccountSummaryTitle"/>
				</h2>
				<p class="text-left">
					<xsl:value-of select="noa:AccountSummaryText"/> 		
				</p>
				<p>
					<strong>
						<xsl:value-of select="noa:FinalBalanceAmountTitle"/>
						<xsl:value-of select="'&#160;'"/>
					</strong>
					<xsl:value-of select="noa:FinalBalanceAmount"/>

					<br />
					<strong>
						<xsl:value-of select="noa:PayByTitle"/>
						<xsl:value-of select="'&#160;'"/>
					</strong>
					<xsl:value-of select="noa:PayByDate"/>
				</p>
			</div>
		</xsl:if>
		<!-- Tax Assessment -->
		<div class="taxAssessmentSection">
			<h2>
				<xsl:value-of select="noa:TaxAssessmentTitle"/>
			</h2>
			<xsl:for-each select="noa:TaxAssessment">
				<p>
					<xsl:for-each select="noa:ParagraphObject">
						<xsl:call-template name="process-xnoa-paragraph" >
							<xsl:with-param name="currentParagraph" select="current()" />
						</xsl:call-template>
					</xsl:for-each>
				</p>	
			</xsl:for-each>
		</div>

		<!-- Summary -->
		<div class="table-responsive">
			<xsl:variable name="noticeType" select="noa:NoticeType"/>
			<!-- Summary table -->
			<table class="table table-condensed table-striped">
				<caption>
					<h3 class="text-left"> 
						<xsl:value-of select="noa:SummaryTitle"/>
					</h3>
				</caption>
				<thead>
					<tr>
						<th class="text-left" scope="col">
							<xsl:value-of select="noa:LineTitle"/>
						</th>
						<th class="text-left" scope="col">
							<xsl:value-of select="noa:DescriptionTitle"/>
						</th>
						<xsl:if test="$noticeType='0267' or $noticeType='0268' or $noticeType='0269' or $noticeType='0271'
							          	or $noticeType='0273' or $noticeType='0276' or $noticeType='0277' or $noticeType='0339' 
							          	or $noticeType='0491' or $noticeType='0767' or $noticeType='T491'">
							<th class="text-right" scope="col">
								<xsl:value-of select="noa:ReturnAmountTitle"/>
							</th>  
							<th class="text-left" scope="col">
								<xsl:value-of select="noa:CRDRReturnAmountTitle"/>
							</th> 
						</xsl:if>
						<th class="text-right" scope="col">
							<xsl:value-of select="noa:FinalAmountTitle"/>
						</th>  
						<th class="text-left" scope="col">
							<xsl:value-of select="noa:CRDRFinalAmountTitle"/>
						</th> 
					</tr> 
				</thead>
				<tbody>	
					<xsl:for-each select="noa:SummaryTableRow">
						<tr>
							<xsl:choose>
								<xsl:when test="position()=last()">
									<!--the row should be strong when true -->
									<td class="text-left">
										<strong>
											<xsl:value-of select="noa:SummaryLineNumber"/>
										</strong>
									</td>
									<td class="text-left">
										<strong>
											<xsl:value-of select="noa:SummaryDescription"/>
										</strong>
									</td>
									<xsl:if test="$noticeType='0267' or $noticeType='0268' or $noticeType='0269' or $noticeType='0271'
							          	or $noticeType='0273' or $noticeType='0276' or $noticeType='0277' or $noticeType='0339' 
							          	or $noticeType='0491' or $noticeType='0767' or $noticeType='T491'">
										<td class="text-right">
											<strong>
												<xsl:value-of select="noa:ReturnAmount"/>
											</strong>
										</td>
										<td class="text-left">
											<strong>
												<xsl:value-of select="noa:CRDRReturnAmountIndicator"/>
											</strong>
										</td>
									</xsl:if>
									<td class="text-right">
										<strong>
											<xsl:value-of select="noa:FinalAmount"/>
										</strong>
									</td>
									<td class="text-left">
										<strong>
											<xsl:value-of select="noa:CRDRFinalAmountIndicator"/>
										</strong>
									</td>
								</xsl:when>
								<xsl:otherwise>
									<td class="text-left">
										<xsl:value-of select="noa:SummaryLineNumber"/>
									</td>
									<td class="text-left">
										<xsl:value-of select="noa:SummaryDescription"/>
									</td>
									<xsl:if test="$noticeType='0267' or $noticeType='0268' or $noticeType='0269' or $noticeType='0271'
							          	or $noticeType='0273' or $noticeType='0276' or $noticeType='0277' or $noticeType='0339' 
							          	or $noticeType='0491' or $noticeType='0767' or $noticeType='T491'">
										<td class="text-right">
											<xsl:value-of select="noa:ReturnAmount"/>
										</td>
										<td class="text-left">
											<xsl:value-of select="noa:CRDRReturnAmountIndicator"/>
										</td>
									</xsl:if>
									<td class="text-right">
										<xsl:value-of select="noa:FinalAmount"/>
									</td>
									<td class="text-left">
										<xsl:value-of select="noa:CRDRFinalAmountIndicator"/>
									</td>
								</xsl:otherwise>
							</xsl:choose>
						</tr>
					</xsl:for-each>
				</tbody>	
			</table>
		</div>

		<!-- Explan -->
		<div>
			<h4>
				<xsl:value-of select="noa:ExplanTitle"/>
			</h4>	

			<xsl:for-each select="noa:ExplanText">
				<p>
					<xsl:for-each select="noa:ParagraphObject">
						<xsl:call-template name="process-xnoa-paragraph" >
							<xsl:with-param name="currentParagraph" select="current()" />
						</xsl:call-template>
					</xsl:for-each>
				</p>	
			</xsl:for-each>
		</div>

		<!-- RRSP section -->
		<xsl:if test="noa:RRSPTableGroup/noa:RRSPGroupTitle !=''">
			<h4>
				<xsl:value-of select="noa:RRSPTableGroup/noa:RRSPGroupTitle"/>
			</h4>
			
			<p class="text-left">
				<xsl:for-each select="noa:RRSPTableGroup/noa:RRSPIntro">
					<xsl:choose>
						<xsl:when test="noa:BoldIndicator ='Y'"> 
							<strong>
								<xsl:value-of select="noa:RRSPIntroText"/>
							</strong>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="not(contains(current(), 'cra.gc')) and not(contains(current(), 'arc.gc'))">
									<xsl:value-of select="noa:RRSPIntroText"/>
								</xsl:when>
								<xsl:otherwise>
									<strong>
										<xsl:value-of select="noa:RRSPIntroText"/>
									</strong>
								</xsl:otherwise>
							</xsl:choose>

						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</p>

			<xsl:for-each select="noa:RRSPTableGroup/noa:RRSPTables">
				<xsl:if test="noa:RRSPTableTitle !=''">
					<h4>
						<xsl:value-of select="noa:RRSPTableTitle"/>
					</h4>
					<div class="table-responsive">		
						<table class="table table-condensed table-striped">
							<thead>
								<tr>
									<th class="text-left" scope="col">
										<xsl:value-of select="noa:RRSPDescriptionTitle"/>
									</th>	
									<th class="text-right" scope="col">
										<xsl:value-of select="noa:RRSPAmountTitle"/>
									</th>
								</tr> 
							</thead>
							<tbody>	
								<xsl:for-each select="noa:RRSPTableRow">
									<tr>
										<xsl:choose>
											<xsl:when test="noa:RRSPSubTotalRowIndicator='Y'"> 
												<!--the row should be strong when true -->
												<td class="text-left">
													<xsl:for-each select="noa:RRSPDescription">
														<strong>
															<xsl:value-of select="noa:RRSPDescriptionText"/>
														</strong>
													</xsl:for-each>
												</td>								
												<td class="text-right">
													<xsl:for-each select="noa:RRSPAmount">
														<strong>
															<xsl:value-of select="noa:RRSPAmountText"/>
														</strong>
													</xsl:for-each>
												</td>
											</xsl:when>
											<xsl:otherwise>
												<td class="text-left">
													<xsl:for-each select="noa:RRSPDescription">
														<xsl:if test="noa:BoldIndicator ='N'"> 
															<xsl:value-of select="noa:RRSPDescriptionText"/>
														</xsl:if>
														<xsl:if test="noa:BoldIndicator ='Y'"> 
															<strong>
																<xsl:value-of select="noa:RRSPDescriptionText"/>
															</strong>
															<xsl:value-of select="'&#160;'"/>
														</xsl:if>
													</xsl:for-each>
												</td>
												<td class="text-right">
													<xsl:for-each select="noa:RRSPAmount">
														<xsl:if test="noa:BoldIndicator ='N'"> 
															<xsl:value-of select="noa:RRSPAmountText"/>
														</xsl:if>
														<xsl:if test="noa:BoldIndicator ='Y'"> 
															<strong>
																<xsl:value-of select="noa:RRSPAmountText"/>
															</strong>
														</xsl:if>
													</xsl:for-each>
												</td>
											</xsl:otherwise>
										</xsl:choose>
									</tr>
								</xsl:for-each>
							</tbody>	
						</table>
					</div>
				</xsl:if>
			</xsl:for-each>
			
			<p class="text-left">
				<xsl:for-each select="noa:RRSPTableGroup/noa:RRSPNote">
					<xsl:choose>
						<xsl:when test="noa:BoldIndicator ='Y'"> 
							<strong>
								<xsl:value-of select="noa:RRSPNoteText"/>
							</strong>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="noa:RRSPNoteText"/>
						</xsl:otherwise>
					</xsl:choose>
	
				</xsl:for-each>
			</p>
		</xsl:if>

		<!-- Home Buyer's Plan section -->
		<xsl:if test="noa:HBPTitle !=''">
			<div class="table-responsive">
				<table class="table table-condensed table-striped">
					<caption class="text-left">
						<h4> 
							<xsl:value-of select="noa:HBPTitle"/>
						</h4>
						<span class="fw-normal">
							<xsl:for-each select="noa:HBPIntro">
								<xsl:if test="noa:BoldIndicator ='N'"> 
										<xsl:value-of select="noa:HBPIntroText"/>
								</xsl:if>
								<xsl:if test="noa:BoldIndicator ='Y'"> 
									<strong>
											<xsl:value-of select="noa:HBPIntroText"/>
									</strong>
								</xsl:if>
							</xsl:for-each>
						</span>
					</caption>
					<thead>
						<tr>
							<th class="text-left" scope="col">
								<xsl:value-of select="noa:HBPDescriptionTitle"/>
							</th>
							<th class="text-right" scope="col">
								<xsl:value-of select="noa:HBPAmountTitle"/>
							</th>
						</tr>
					</thead>
					<tbody>	
						<xsl:for-each select="noa:HBPTableRow">
							<tr>
								<xsl:choose>
									<xsl:when test="noa:HBPSubTotalRowIndicator='Y'"> 
										<!--the row should be strong when true -->
										<td class="text-left">
											<xsl:for-each select="noa:HBPDescription">
												<strong>
													<xsl:value-of select="noa:HBPDescriptionText"/>
												</strong>
											</xsl:for-each>
										</td>								
										<td class="text-right">
											<xsl:for-each select="noa:HBPAmount">
												<strong>
													<xsl:value-of select="noa:HBPAmountText"/>
												</strong>
											</xsl:for-each>
										</td>
									</xsl:when>
									<xsl:otherwise>
										<td class="text-left">
											<xsl:for-each select="noa:HBPDescription">
												<xsl:if test="noa:BoldIndicator ='N'"> 
													<xsl:value-of select="noa:HBPDescriptionText"/>
												</xsl:if>
												<xsl:if test="noa:BoldIndicator ='Y'"> 
													<strong>
														<xsl:value-of select="noa:HBPDescriptionText"/>
													</strong>
												</xsl:if>
											</xsl:for-each>
										</td>
										<td class="text-right">
											<xsl:for-each select="noa:HBPAmount">
												<xsl:if test="noa:BoldIndicator ='N'"> 
													<xsl:value-of select="noa:HBPAmountText"/>
												</xsl:if>
												<xsl:if test="noa:BoldIndicator ='Y'"> 
													<strong>
														<xsl:value-of select="noa:HBPAmountText"/>
													</strong>
												</xsl:if>
											</xsl:for-each>
										</td>
									</xsl:otherwise>
								</xsl:choose>
							</tr>
						</xsl:for-each>
					</tbody>	
				</table>
			</div>
		</xsl:if>

		<!-- Lifelong Learning Plan section -->					
		<xsl:if test="noa:LLPTitle !=''">
			<div class="table-responsive">
				<table class="table table-condensed table-striped">
					<caption class="text-left">
						<h4> 
							<xsl:value-of select="noa:LLPTitle"/>
						</h4>
						<span class="fw-normal">
							<xsl:for-each select="noa:LLPIntro">
								<xsl:if test="noa:BoldIndicator ='N'"> 
										<xsl:value-of select="noa:LLPIntroText"/>
								</xsl:if>
								<xsl:if test="noa:BoldIndicator ='Y'"> 
									<strong>
											<xsl:value-of select="noa:LLPIntroText"/>
									</strong>
								</xsl:if>
							</xsl:for-each>
						</span>
					</caption>
					<thead>
						<tr>
							<th class="text-left" scope="col">
								<xsl:value-of select="noa:LLPDescriptionTitle"/>
							</th>
							<th class="text-right" scope="col">
								<xsl:value-of select="noa:LLPAmountTitle"/>
							</th>                     
						</tr>
					</thead>
					<tbody>	
						<xsl:for-each select="noa:LLPTableRow">
							<tr>
								<xsl:choose>
									<xsl:when test="noa:LLPSubTotalRowIndicator='Y'"> 
										<!--the row should be strong when true -->
										<td class="text-left">
											<xsl:for-each select="noa:LLPDescription">
												<strong>
													<xsl:value-of select="noa:LLPDescriptionText"/>
												</strong>
											</xsl:for-each>
										</td>								
										<td class="text-right">
											<xsl:for-each select="noa:LLPAmount">
												<strong>
													<xsl:value-of select="noa:LLPAmountText"/>
												</strong>
											</xsl:for-each>
										</td>
									</xsl:when>
									<xsl:otherwise>
										<td class="text-left">
											<xsl:for-each select="noa:LLPDescription">
												<xsl:if test="noa:BoldIndicator ='N'"> 
													<xsl:value-of select="noa:LLPDescriptionText"/>
												</xsl:if>
												<xsl:if test="noa:BoldIndicator ='Y'"> 
													<strong>
														<xsl:value-of select="noa:LLPDescriptionText"/>
													</strong>
												</xsl:if>
											</xsl:for-each>
										</td>
										<td class="text-right">
											<xsl:for-each select="noa:LLPAmount">
												<xsl:if test="noa:BoldIndicator ='N'"> 
													<xsl:value-of select="noa:LLPAmountText"/>
												</xsl:if>
												<xsl:if test="noa:BoldIndicator ='Y'"> 
													<strong>
														<xsl:value-of select="noa:LLPAmountText"/>
													</strong>
												</xsl:if>
											</xsl:for-each>
										</td>
									</xsl:otherwise>
								</xsl:choose>
							</tr>
						</xsl:for-each>
					</tbody>	
				</table>
			</div>
		</xsl:if>
		
		<!-- First Home Savings Account section -->					
		<xsl:if test="noa:FHSATitle !=''">
			<div class="table-responsive">
				<table class="table table-condensed table-striped">
					<caption class="text-left">
						<h4> 
							<xsl:value-of select="noa:FHSATitle"/>
						</h4>
						<span class="fw-normal">
							<xsl:for-each select="noa:FHSAIntro">
								<xsl:if test="noa:BoldIndicator ='N'"> 
									<xsl:value-of select="noa:FHSAIntroText"/>
								</xsl:if>
								<xsl:if test="noa:BoldIndicator ='Y'"> 
									<strong>
										<xsl:value-of select="noa:FHSAIntroText"/>
									</strong>
								</xsl:if>
							</xsl:for-each>
						</span>
					</caption>
					<thead>
						<tr>
							<th class="text-left" scope="col">
								<xsl:value-of select="noa:FHSADescriptionTitle"/>
							</th>
							<th class="text-right" scope="col">
								<xsl:value-of select="noa:FHSAAmountTitle"/>
							</th>                     
						</tr>
					</thead>
					<tbody>	
						<xsl:for-each select="noa:FHSATableRow">
							<tr>
								<xsl:choose>
									<xsl:when test="noa:FHSASubTotalRowIndicator='Y'"> 
										<!--the row should be strong when true -->
										<td class="text-left">
											<xsl:for-each select="noa:FHSADescription">
												<strong>
													<xsl:value-of select="noa:FHSADescriptionText"/>
												</strong>
											</xsl:for-each>
										</td>								
										<td class="text-right">
											<xsl:for-each select="noa:FHSAAmount">
												<strong>
													<xsl:value-of select="noa:FHSAAmountText"/>
												</strong>
											</xsl:for-each>
										</td>
									</xsl:when>
									<xsl:otherwise>
										<td class="text-left">
											<xsl:for-each select="noa:FHSADescription">
												<xsl:if test="noa:BoldIndicator ='N'"> 
													<xsl:value-of select="noa:FHSADescriptionText"/>
												</xsl:if>
												<xsl:if test="noa:BoldIndicator ='Y'"> 
													<strong>
														<xsl:value-of select="noa:FHSADescriptionText"/>
													</strong>
												</xsl:if>
											</xsl:for-each>
										</td>
										<td class="text-right">
											<xsl:for-each select="noa:FHSAAmount">
												<xsl:if test="noa:BoldIndicator ='N'"> 
													<xsl:value-of select="noa:FHSAAmountText"/>
												</xsl:if>
												<xsl:if test="noa:BoldIndicator ='Y'"> 
													<strong>
														<xsl:value-of select="noa:FHSAAmountText"/>
													</strong>
												</xsl:if>
											</xsl:for-each>
										</td>
									</xsl:otherwise>
								</xsl:choose>
							</tr>
						</xsl:for-each>
					</tbody>	
				</table>
			</div>
			
			<p class="text-left">
				<xsl:for-each select="noa:FHSANote">
					<xsl:choose>
						<xsl:when test="noa:BoldIndicator ='Y'">
							<xsl:if test="noa:FHSANoteText ='Note 2:' or noa:FHSANoteText ='Remarque 2 :'">
					 			<br></br>
							</xsl:if>  
							<strong>
								<xsl:value-of select="noa:FHSANoteText"/>
							</strong>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="noa:FHSANoteText"/>
						</xsl:otherwise>
					</xsl:choose>

				</xsl:for-each>
			</p>
		</xsl:if>

		<div class="moreInformationSection">
			<h2>
				<xsl:value-of select="noa:MoreInformationTitle"/>
			</h2>
			<xsl:for-each select="noa:MoreInformation">
				<xsl:choose>
					<xsl:when test="noa:ParagraphObject/noa:Subtitle='Y' ">
						<h3>
							<xsl:for-each select="noa:ParagraphObject">
								<xsl:call-template name="process-xnoa-paragraph" >
									<xsl:with-param name="currentParagraph" select="current()" />
								</xsl:call-template>
							</xsl:for-each>
						</h3>
					</xsl:when>
					<xsl:otherwise>
						<p>
							<xsl:for-each select="noa:ParagraphObject">
								<xsl:call-template name="process-xnoa-paragraph" >
									<xsl:with-param name="currentParagraph" select="current()" />
								</xsl:call-template>
							</xsl:for-each>
						</p>
					</xsl:otherwise>
				</xsl:choose>	

			</xsl:for-each>
		</div>
	</xsl:template>
</xsl:stylesheet>