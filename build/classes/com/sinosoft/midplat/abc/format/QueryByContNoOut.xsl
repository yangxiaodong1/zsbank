<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
 	exclude-result-prefixes="java">

	<xsl:output indent='yes'/>
	<xsl:template match="/TranData">
	<xsl:variable name="InsuredSex" select="Body/Insured/Sex"/>
	  <Ret>
	  	<RetData>
	  		<Flag>
	  		  <xsl:if test="Head/Flag='0'">1</xsl:if>
	  		  <xsl:if test="Head/Flag='1'">0</xsl:if>
	  		</Flag>
	  		<Mesg><xsl:value-of select ="Head/Desc"/></Mesg>
	  	</RetData>
	  	<!-- 如果交易成功，才返回下面的结点 -->
		<xsl:if test="Head/Flag='0'">
			<Base>
				<ContNo><xsl:value-of select ="Body/ContNo"/></ContNo>
				<ProposalContNo><xsl:value-of select ="Body/ProposalPrtNo"/></ProposalContNo>
				<SignDate><xsl:value-of select ="Body/Risk[RiskCode=MainRiskCode]/SignDate"/></SignDate>
				<RiskName><xsl:value-of select ="Body/Risk[RiskCode=MainRiskCode]/RiskName"/></RiskName>
				<BankAccName><xsl:value-of select ="Body/AccName"/></BankAccName>
				<AgentCode><xsl:value-of select ="Body/AgentCode"/></AgentCode>
		    	<AgentGroup><xsl:value-of select ="Body/AgentGrpCode"/></AgentGroup>
		    	<AgentName><xsl:value-of select ="Body/AgentName"/></AgentName>
		    	<Prem><xsl:value-of select ="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/Prem)"/></Prem>
		    	<CValiDate><xsl:value-of select ="Body/Risk[RiskCode=MainRiskCode]/CValiDate"/></CValiDate>
		    	<BankName></BankName>
		    	<BankAccNo></BankAccNo>
		    	<BankAccName></BankAccName>
		    	<ContEndDate><xsl:value-of select ="Body/Risk[RiskCode=MainRiskCode]/InsuEndDate "/></ContEndDate>
			</Base>
			<Appl>
				<Name><xsl:value-of select ="Body/Appnt/Name"/></Name>
				<Sex><xsl:value-of select ="Body/Appnt/Sex"/></Sex>
				<IDType>
					<xsl:call-template name="tran_IDType">
						<xsl:with-param name="idtype">
							<xsl:value-of select ="Body/Appnt/IDType"/>
						</xsl:with-param>
					</xsl:call-template>
				</IDType>
				<IDNo><xsl:value-of select ="Body/Appnt/IDNo"/></IDNo>
				<No><xsl:value-of select ="Body/Appnt/CustomerNo"/></No>
				<Birthday><xsl:value-of select ="Body/Appnt/Birthday"/></Birthday>
				<Address><xsl:value-of select ="Body/Appnt/Address"/></Address>
				<PostCode><xsl:value-of select ="Body/Appnt/ZipCode"/></PostCode>
				<Phone><xsl:value-of select ="Body/Appnt/Phone"/></Phone>
				<Mobile><xsl:value-of select ="Body/Appnt/Mobile"/></Mobile>
				<EMail><xsl:value-of select ="Body/Appnt/Email"/></EMail>
				<RelaToInsured>
				 <xsl:call-template name="tran_RelationRoleCode">
					<xsl:with-param name="relaToInsured">
						<xsl:value-of select="Body/Appnt/RelaToInsured"/>
					</xsl:with-param>
					<xsl:with-param name="sex">
						<xsl:value-of select="Body/Appnt/Sex"/>
					</xsl:with-param>
				 </xsl:call-template>
				 </RelaToInsured>
				<OccuCode><xsl:value-of select ="Body/Appnt/JobCode"/></OccuCode>
			</Appl>
			<Insu>
				<Name><xsl:value-of select="Body/Insured/Name"/></Name>
				<Sex><xsl:value-of select="Body/Insured/Sex"/></Sex>
				<Birthday><xsl:value-of select="Body/Insured/Birthday"/></Birthday>
				<IDType>
					<xsl:call-template name="tran_IDType">
						<xsl:with-param name="idtype">
							<xsl:value-of select="Body/Insured/IDType"/>
						</xsl:with-param>
					</xsl:call-template>
				</IDType>
				<IDNo><xsl:value-of select="Body/Insured/IDNo"/></IDNo>
				<InsurNo><xsl:value-of select="Body/Insured/CustomerNo"/></InsurNo>
				<Address><xsl:value-of select="Body/Insured/Address"/></Address>
				<ZipCode><xsl:value-of select="Body/Insured/ZipCode"/></ZipCode>
				<Mobile><xsl:value-of select="Body/Insured/Mobile"/></Mobile>
				<Phone><xsl:value-of select="Body/Insured/Phone"/></Phone>
				<EMail><xsl:value-of select="Body/Insured/Email"/></EMail>
			</Insu>
			<Bnfs>
				<Count><xsl:value-of select="count(Body/Bnf)"/></Count>
				<xsl:for-each select="Body/Bnf">
					<Bnf>
						<Name><xsl:value-of select="Name"/></Name>
					    <Sex><xsl:value-of select="Sex"/></Sex>
					    <Birthday><xsl:value-of select="Birthday"/></Birthday>
					    <IDType>
					    	<xsl:call-template name="tran_IDType">
								<xsl:with-param name="idtype">
									<xsl:value-of select="IDType"/>
								</xsl:with-param>
							</xsl:call-template>
					    </IDType>
					    <IDNo><xsl:value-of select="IDNo"/></IDNo>
					    <RelationToInsured>
					    <xsl:call-template name="tran_RelationRoleCode">
					        <xsl:with-param name="relaToInsured">
						        <xsl:value-of select="RelaToInsured"/>
					        </xsl:with-param>
					    <xsl:with-param name="sex">
					        <xsl:value-of select="Sex"/>
				     	</xsl:with-param>
				        </xsl:call-template>
				       </RelationToInsured>
					  	<BnfGrade><xsl:value-of select="Grade"/></BnfGrade>
						<BnfLot><xsl:value-of select="Lot"/></BnfLot>
					</Bnf>
				</xsl:for-each>
			</Bnfs>
			<Risks>
				<Count><xsl:value-of select="count(Body/Risk)"/></Count>
				<xsl:for-each select="Body/Risk">
					<Risk>
						<Code><xsl:value-of select="RiskCode"/></Code>
						<MainRiskCode><xsl:value-of select="MainRiskCode"/></MainRiskCode>
						<Name><xsl:value-of select="RiskName"/></Name>
						<Prem><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)"/></Prem>
						<PremRate><xsl:value-of select="PremRate"/></PremRate>
						<InsuYear><xsl:value-of select="Years"/></InsuYear>
						<InsuYearFlag><xsl:value-of select="InsuYearFlag"/></InsuYearFlag>
						<InsuYearAge><xsl:value-of select="InsuYear"/></InsuYearAge>
						<Mult><xsl:value-of select="Mult"/></Mult>
						<PayMode>
						    <xsl:call-template name="tran_PayIntv">
								<xsl:with-param name="payIntv">
									<xsl:value-of select="PayIntv"/>
								</xsl:with-param>
							</xsl:call-template>
						</PayMode>
						<CValiDate><xsl:value-of select="CValiDate"/></CValiDate>
						<EndDate><xsl:value-of select="InsuEndDate"/></EndDate>
						<Amnt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/></Amnt>
						<BonusAmnt></BonusAmnt>
					</Risk>
				</xsl:for-each>
			</Risks>			
			<Accts>
				<RiskCode><xsl:value-of select="Body/Risk/MainRiskCode"/></RiskCode>
				<Count><xsl:value-of select="count(Body/Account)"/></Count>
				<xsl:for-each select="Body/Account">
					<Acct>
						<AccNo><xsl:value-of select="AccNo"/></AccNo>
						<AccName><xsl:value-of select="AccName"/></AccName>
						<Fee><xsl:value-of select="AccMoney"/></Fee>
						<Rate><xsl:value-of select="AccRate"/></Rate>
					</Acct>
				</xsl:for-each>
			</Accts>
		</xsl:if> <!-- 如果交易成功，才返回上面的结点 -->
	  </Ret>
	  <!-- 证件类型 -->
	</xsl:template>
	   <xsl:template name="tran_IDType">
		<xsl:param name="idtype">110001</xsl:param>
		<xsl:if test="$idtype = '0'">110001</xsl:if>
		<xsl:if test="$idtype = '1'">110023</xsl:if>
		<xsl:if test="$idtype = '2'">110033</xsl:if>
		<xsl:if test="$idtype = '5'">110005</xsl:if>
		<xsl:if test="$idtype = '9'">110002</xsl:if>
		<xsl:if test="$idtype = '8'">119999</xsl:if>
	</xsl:template>
	
	<!-- 缴费频次  银行: 1：趸交  2：月交     3：季交    4：半年交    5：年交             6：不定期
                    核心:  0：一次交清/趸交 1:月交  3:季交   6:半年交	   12：年交          -1:不定期交 -->
	   <xsl:template name="tran_PayIntv">
		<xsl:param name="payIntv">0</xsl:param>
		<xsl:if test="$payIntv = '0'">1</xsl:if>
		<xsl:if test="$payIntv = '1'">2</xsl:if>
		<xsl:if test="$payIntv = '3'">3</xsl:if>
		<xsl:if test="$payIntv = '6'">4</xsl:if>
		<xsl:if test="$payIntv = '12'">5</xsl:if>
		<xsl:if test="$payIntv = '-1'">6</xsl:if>
	</xsl:template>
    <!-- 关系 -->		
	<xsl:template name="tran_RelationRoleCode">
	   <xsl:param name="relaToInsured">0</xsl:param>
	   <xsl:param name="sex">0</xsl:param>
		<xsl:choose>
			<xsl:when test="$relaToInsured='00'">1</xsl:when>
			<xsl:when test="$relaToInsured='01'">
			    <xsl:if test="$sex='0'">4</xsl:if>
			    <xsl:if test="$sex='1'">5</xsl:if>
			</xsl:when>
			<!-- 父母 -->
			<xsl:when test="$relaToInsured=02">
			  <xsl:if test="$sex='0'">2</xsl:if>
			  <xsl:if test="$sex='1'">3</xsl:if>
			</xsl:when>
			<!-- 配偶 -->
			<xsl:when test=".=03">
			      <xsl:if test="$sex='0'">6</xsl:if>
			      <xsl:if test="$sex='1'">7</xsl:if>
			</xsl:when>
			<!-- 子女 -->
			<xsl:otherwise>30</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>