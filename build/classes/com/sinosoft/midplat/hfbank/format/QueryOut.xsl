<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
		<TranData>
			<xsl:apply-templates select="TranData/Head" />
			<xsl:apply-templates select="TranData/Body" />
		</TranData>
	</xsl:template>

	<xsl:template name="Transaction_Head" match="Head">
		<Head>
			<Flag>
				<xsl:value-of select="Flag" />
			</Flag><!-- 0��ʾ�ɹ���1��ʾʧ�� -->
			<Desc>
				<xsl:value-of select="Desc" />
			</Desc><!-- ʧ��ʱ�����ش�����Ϣ -->
		</Head>
	</xsl:template>
	
	<xsl:template name="Transaction_Body" match="Body">
		<Body>
		  	<ContNo><xsl:value-of select="ContNo" /></ContNo><!-- ���յ��� -->
			<ProposalPrtNo><xsl:value-of select="ProposalPrtNo" /></ProposalPrtNo><!-- Ͷ����(ӡˢ)�� -->
			<ContPrtNo><xsl:value-of select="ContPrtNo" /></ContPrtNo><!-- ������ͬӡˢ�� -->
			<AccNo><xsl:value-of select="AccNo" /></AccNo><!-- �����˻� -->
			<Prem><xsl:value-of select="Prem" /></Prem><!-- �ܱ���(��) -->
			<PremText><xsl:value-of select="PremText" /></PremText><!-- �ܱ��Ѵ�д -->
			<ActSumPrem><xsl:value-of select="ActSumPrem" /></ActSumPrem><!--ʵ�ձ���-->
			<ActSumPremText><xsl:value-of select="ActSumPremText" /></ActSumPremText><!--ʵ�ձ��Ѵ�д-->
			<EFMoney><xsl:value-of select="EFMoney" /></EFMoney><!--���ڽ���ϲ�Ʒ50015ʱʹ��-->
			<AgentCode><xsl:value-of select="AgentCode" /></AgentCode><!-- �����˱�00�� -->
			<AgentName><xsl:value-of select="AgentName" /></AgentName><!-- ���������� -->
			<AgentCertiCode><xsl:value-of select="AgentCertiCode" /></AgentCertiCode><!-- �������ʸ�֤ -->
			<AgentGrpCode><xsl:value-of select="AgentGrpCode" /></AgentGrpCode><!-- ������������ -->
			<AgentGrpName><xsl:value-of select="AgentGrpName" /></AgentGrpName><!-- ��������� -->
			<AgentCom><xsl:value-of select="AgentCom" /></AgentCom><!-- ����������� -->
			<AgentComName><xsl:value-of select="AgentComName" /></AgentComName><!-- ����������� -->
			<AgentComCertiCode><xsl:value-of select="AgentComCertiCode" /></AgentComCertiCode><!-- ��������ʸ�֤ -->
			<ComCode><xsl:value-of select="ComCode" /></ComCode><!-- �б���˾���� -->
			<ComLocation><xsl:value-of select="ComLocation" /></ComLocation><!-- �б���˾��ַ -->
			<ComName><xsl:value-of select="ComName" /></ComName><!-- �б���˾���� -->
			<ComZipCode><xsl:value-of select="ComZipCode" /></ComZipCode><!-- �б���˾�ʱ� -->
			<ComPhone><xsl:value-of select="ComPhone" /></ComPhone><!-- �б���˾�绰 -->
			<SellerNo><xsl:value-of select="SellerNo" /></SellerNo><!--����������Ա���� -->
			<TellerName><xsl:value-of select="TellerName" /></TellerName><!--����������Ա���� -->
			<TellerCertiCode><xsl:value-of select="TellerCertiCode" /></TellerCertiCode><!--����������Ա�ʸ�֤ -->
			<AgentManageNo><xsl:value-of select="AgentManageNo" /></AgentManageNo><!--���б���ҵ�����˹��� -->
			<AgentManageName><xsl:value-of select="AgentManageName" /></AgentManageName><!--���б���ҵ���������� -->
			<SubBankCode><xsl:value-of select="SubBankCode" /></SubBankCode>
			<!--�����սɷ�ҵ��ϸ�ִ��� 01-ʵʱͶ���ɷ� 02-��ʵʱͶ���ɷ� 03-���ڽ���-->
			<AgentPayType><xsl:value-of select="AgentPayType" /></AgentPayType>
			<SpecContent><xsl:value-of select="SpecContent" /></SpecContent>
			<!--��ϲ�Ʒ-->
		  	<ContPlan>
		   		<!--��ϲ�Ʒ����-->
		    	<ContPlanCode></ContPlanCode>
		   		<!--��ϲ�Ʒ����-->
		     	<ContPlanName></ContPlanName>
		   		<!--��ϲ�Ʒ����-->
		     	<ContPlanMult></ContPlanMult>
		  	</ContPlan>
		  	<!-- Ͷ���� -->
		  	<xsl:apply-templates select="Appnt" />
		  	<!-- ������ -->
		  	<xsl:apply-templates select="Insured" />
		  	<!-- ������ -->
		  	<xsl:apply-templates select="Bnf" />
		  	<!-- ������Ϣ -->
		  	<xsl:apply-templates select="Risk[RiskCode=MainRiskCode]" />
		</Body>
	</xsl:template>
	<!-- Ͷ���� -->
	<xsl:template name="Appnt" match="Appnt">
		<Appnt>
		    <CustomerNo><xsl:value-of select="CustomerNo" /></CustomerNo><!-- �ͻ��� -->
			<Name><xsl:value-of select="Name" /></Name><!-- ���� -->
			<Sex><xsl:value-of select="Sex" /></Sex><!-- �Ա� -->
			<Birthday><xsl:value-of select="Birthday" /></Birthday><!-- ��������(yyyyMMdd) -->
			<IDType><xsl:value-of select="IDType" /></IDType><!-- ֤������ -->
			<IDNo><xsl:value-of select="IDNo" /></IDNo><!-- ֤������ -->
			<JobType><xsl:value-of select="JobType" /></JobType><!-- ְҵ��� -->
			<JobCode><xsl:value-of select="JobCode" /></JobCode><!-- ְҵ���� -->
			<JobName><xsl:value-of select="JobName" /></JobName><!-- ְҵ���� -->
			<Nationality><xsl:value-of select="Nationality" /></Nationality><!-- ����-->
			<Stature><xsl:value-of select="Stature" /></Stature><!-- ���(cm) -->
			<Weight><xsl:value-of select="Weight" /></Weight><!-- ����(g) -->
			<MaritalStatus><xsl:value-of select="MaritalStatus" /></MaritalStatus><!-- ���(N/Y) -->
			<Address><xsl:value-of select="Address" /></Address><!-- ��ַ -->
			<ZipCode><xsl:value-of select="ZipCode" /></ZipCode><!-- �ʱ� -->
			<Mobile><xsl:value-of select="Mobile" /></Mobile><!-- �ƶ��绰 -->
			<Phone><xsl:value-of select="Phone" /></Phone><!-- �̶��绰 -->
			<Email><xsl:value-of select="Email" /></Email><!-- �����ʼ�-->
			<RelaToInsured><xsl:value-of select="RelaToInsured" /></RelaToInsured><!-- �뱻���˹�ϵ -->
		 </Appnt>
	</xsl:template>
	<!-- �������� -->
	<xsl:template name="Insured" match="Insured">
		<Insured>
		    <CustomerNo><xsl:value-of select="CustomerNo" /></CustomerNo><!-- �ͻ��� -->
			<Name><xsl:value-of select="Name" /></Name><!-- ���� -->
			<Sex><xsl:value-of select="Sex" /></Sex><!-- �Ա� -->
			<Birthday><xsl:value-of select="Birthday" /></Birthday><!-- ��������(yyyyMMdd) -->
			<IDType><xsl:value-of select="IDType" /></IDType><!-- ֤������ -->
			<IDNo><xsl:value-of select="IDNo" /></IDNo><!-- ֤������ -->
			<JobType><xsl:value-of select="JobType" /></JobType><!-- ְҵ��� -->
			<JobCode><xsl:value-of select="JobCode" /></JobCode><!-- ְҵ���� -->
			<JobName><xsl:value-of select="JobName" /></JobName><!-- ְҵ���� -->
			<Stature><xsl:value-of select="Stature" /></Stature><!-- ���(cm)-->
			<Nationality><xsl:value-of select="Nationality" /></Nationality><!-- ����-->
			<Weight><xsl:value-of select="Weight" /></Weight><!-- ����(g) -->
			<MaritalStatus><xsl:value-of select="MaritalStatus" /></MaritalStatus><!-- ���(N/Y) -->
			<Address><xsl:value-of select="Address" /></Address><!-- ��ַ -->
			<ZipCode><xsl:value-of select="ZipCode" /></ZipCode><!-- �ʱ� -->
			<Mobile><xsl:value-of select="Mobile" /></Mobile><!-- �ƶ��绰 -->
			<Phone><xsl:value-of select="Phone" /></Phone><!-- �̶��绰 -->
			<Email><xsl:value-of select="Email" /></Email><!-- �����ʼ�-->
		 </Insured>
	</xsl:template>
	<!-- ������ -->
	<xsl:template name="Bnf" match="Bnf">		
		  <Bnf>
		    <Type><xsl:value-of select="Type" /></Type><!-- ��������� -->
			<Grade><xsl:value-of select="Grade" /></Grade><!-- ����˳�� -->
			<Name><xsl:value-of select="Name" /></Name><!-- ���� -->
			<Sex><xsl:value-of select="Sex" /></Sex><!-- �Ա� -->
			<Birthday><xsl:value-of select="Birthday" /></Birthday><!-- ��������(yyyyMMdd) -->
			<IDType><xsl:value-of select="IDType" /></IDType><!-- ֤������ -->
			<IDNo><xsl:value-of select="IDNo" /></IDNo><!-- ֤������ -->
			<RelaToInsured><xsl:value-of select="RelaToInsured" /></RelaToInsured><!-- �뱻���˹�ϵ -->
			<Lot><xsl:value-of select="Lot" /></Lot><!-- �������(�������ٷֱ�)  -->
		  </Bnf>
	</xsl:template>
	<!-- ������Ϣ -->
	<xsl:template name="Risk" match="Risk">		
		 <Risk>
		 	<xsl:choose>
				<xsl:when test="../ContPlan/ContPlanCode!=''">
					<RiskCode>
				    	<xsl:call-template name="tran_RiskCode">
		                    <xsl:with-param name="riskCode">
		                        <xsl:value-of select="../ContPlan/ContPlanCode" />
		                    </xsl:with-param>
		                </xsl:call-template>
				    </RiskCode><!-- ���ִ��� -->
					<RiskName><xsl:value-of select="../ContPlan/ContPlanName" /></RiskName><!-- �������� -->
					<MainRiskCode>
						<xsl:call-template name="tran_RiskCode">
		                    <xsl:with-param name="riskCode">
		                        <xsl:value-of select="../ContPlan/ContPlanCode" />
		                    </xsl:with-param>
		                </xsl:call-template>
					</MainRiskCode>		
					<Mult><xsl:value-of select="../ContPlan/ContPlanMult" /></Mult><!-- Ͷ������ -->			
				</xsl:when>
				<xsl:otherwise>
					<RiskCode>
				    	<xsl:call-template name="tran_RiskCode">
		                    <xsl:with-param name="riskCode">
		                        <xsl:value-of select="RiskCode" />
		                    </xsl:with-param>
		                </xsl:call-template>
				    </RiskCode><!-- ���ִ��� -->
					<RiskName><xsl:value-of select="RiskName" /></RiskName><!-- �������� -->
					<MainRiskCode>
						<xsl:call-template name="tran_RiskCode">
		                    <xsl:with-param name="riskCode">
		                        <xsl:value-of select="MainRiskCode" />
		                    </xsl:with-param>
		                </xsl:call-template>
					</MainRiskCode>
					<Mult><xsl:value-of select="Mult" /></Mult><!-- Ͷ������ -->
				</xsl:otherwise>
			</xsl:choose>		
		    
			<RiskType><xsl:value-of select="RiskType" /></RiskType><!-- ����1-��ͳ��2-�ֺ�3-Ͷ��4-����5-���� -->
			<Amnt><xsl:value-of select="../Amnt" /></Amnt><!-- ����(��) -->
			<Prem><xsl:value-of select="../ActSumPrem" /></Prem><!-- ���շ�(��) -->
			
			<PayIntv><xsl:value-of select="PayIntv" /></PayIntv><!-- �ɷ�Ƶ�� -->
			<PayMode><xsl:value-of select="PayMode" /></PayMode><!-- �ɷ���ʽ -->
			<PolApplyDate><xsl:value-of select="PolApplyDate" /></PolApplyDate><!-- Ͷ������(yyyyMMdd) -->
			<SignDate><xsl:value-of select="SignDate" /></SignDate><!-- �б�����(yyyyMMdd) -->
			<CValiDate><xsl:value-of select="CValiDate" /></CValiDate><!-- ������(yyyyMMdd) -->
			<InsuYearFlag><xsl:value-of select="InsuYearFlag" /></InsuYearFlag><!-- �����������ڱ�־ -->
			<InsuYear><xsl:value-of select="InsuYear" /></InsuYear><!-- ������������ -->
			<InsuEndDate><xsl:value-of select="InsuEndDate" /></InsuEndDate><!-- ����������ֹ���� -->
			<Years><xsl:value-of select="Years" /></Years><!-- �����ڼ� -->
			<PayEndYearFlag><xsl:value-of select="PayEndYearFlag" /></PayEndYearFlag><!-- �ɷ��������� -->
			<PayEndYear><xsl:value-of select="PayEndYear" /></PayEndYear><!-- �ɷ����� -->
			<PayEndDate><xsl:value-of select="PayEndDate" /></PayEndDate><!-- �ս����� -->
			<CostIntv><xsl:value-of select="CostIntv" /></CostIntv><!-- �ۿ��� -->
			<CostDate><xsl:value-of select="CostDate" /></CostDate><!-- �ۿ�ʱ�� -->
			<PayToDate><xsl:value-of select="PayToDate" /></PayToDate><!-- ��������(yyyyMMdd) -->
			<GetYearFlag><xsl:value-of select="GetYearFlag" /></GetYearFlag><!-- ��ȡ�������ڱ�־ -->
			<GetStartDate><xsl:value-of select="GetStartDate" /></GetStartDate><!-- ��������(yyyyMMdd) -->
			<GetYear><xsl:value-of select="GetYear" /></GetYear><!-- ��ȡ���� -->
			<GetIntv><xsl:value-of select="GetIntv" /></GetIntv><!-- ��ȡ��ʽ -->
			<GetBankCode><xsl:value-of select="GetBankCode" /></GetBankCode><!-- ��ȡ���б��� -->
			<GetBankAccNo><xsl:value-of select="GetBankAccNo" /></GetBankAccNo><!-- ��ȡ�����˻� -->
			<GetAccName><xsl:value-of select="GetAccName" /></GetAccName><!-- ��ȡ���л��� -->
			<AutoPayFlag><xsl:value-of select="AutoPayFlag" /></AutoPayFlag><!-- �Զ��潻��־ -->
			<BonusGetMode><xsl:value-of select="BonusGetMode" /></BonusGetMode><!-- ������ȡ��ʽ -->
			<SubFlag><xsl:value-of select="SubFlag" /></SubFlag><!-- ������־ -->
			<FullBonusGetMode><xsl:value-of select="FullBonusGetMode" /></FullBonusGetMode><!-- ������ȡ����ȡ��ʽ -->
			<PayNum><xsl:value-of select="PayNum" /></PayNum><!-- ���ѽɷ�����-->
			<HsitPrd><xsl:value-of select="HsitPrd" /></HsitPrd><!-- ������ԥ���� -->
			<StartPayDate><xsl:value-of select="StartPayDate" /></StartPayDate><!-- ����Ӧ������YYYY-MM-DD  -->
			<PayTotalCount><xsl:value-of select="PayTotalCount" /></PayTotalCount><!-- ����Ӧ������ -->
			<PayCount><xsl:value-of select="PayCount" /></PayCount><!-- ��������-->
		
		    <!-- �����˻� -->
		    <Account>
		      <AccNo /> <!-- �˻����� -->
		      <AccMoney /> <!-- �˻���� -->
		      <AccRate /> <!-- �˻����� -->
		    </Account>
		    
		    <!-- �ֽ��ֵ�� -->
		    <CashValues>
		      <CashValue>
		        <EndYear></EndYear> <!-- ��� -->
		        <Cash></Cash> <!-- �ֽ��ֵ-->
		      </CashValue>
		    </CashValues>
		    
		    <!-- ������������ĩ�����ֵ�� -->
		    <BonusValues>
		      <BonusValue>
		        <EndYear /> <!-- ��� -->
		        <EndYearCash /> <!-- �����ֵ-->
		      </BonusValue>
		    </BonusValues>
		    <SpecContent /> <!-- �ر�Լ�� -->
		  </Risk>
	</xsl:template>
	<!-- ���ִ��� -->
    <xsl:template name="tran_RiskCode">
        <xsl:param name="riskCode" />
        <xsl:choose>        	
            <xsl:when test="$riskCode='50015'">50015</xsl:when><!-- �������Ӯ���ռƻ� -->
            <xsl:otherwise>--</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>