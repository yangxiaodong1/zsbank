<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<xsl:apply-templates select="TranData/Head" />  <!-- ���ǲ�̫��������Ĺ�ϵ -->
			<xsl:apply-templates select="TranData/Body" />
		</TranData>
	</xsl:template>

	<!-- ����ͷ -->
	<xsl:template name="Transaction_Head" match="Head">
		<Head>
			<!-- 0��ʾ�ɹ���1��ʾʧ�� -->
			<Flag>
				<xsl:value-of select="Flag" />
			</Flag>
			<!-- ʧ��ʱ�����ش�����Ϣ -->
			<Desc>
				<xsl:value-of select="Desc" />
			</Desc>
		</Head>
	</xsl:template>
	
	<!-- ������ -->
	<xsl:template name="Transaction_Body" match="Body">
		<Body>
			<!-- ���յ��� -->
		  	<ContNo>
		  		<xsl:value-of select="ContNo" />
		  	</ContNo>
		  	<!-- Ͷ����(ӡˢ)�� -->
			<ProposalPrtNo>
				<xsl:value-of select="ProposalPrtNo" />
			</ProposalPrtNo>
			<!-- ������ͬӡˢ�� -->
			<ContPrtNo>
				<xsl:value-of select="ContPrtNo" />
			</ContPrtNo>
			<!-- �ܱ���(��) -->
			<Prem>
				<xsl:value-of select="Prem" />
			</Prem>
			<!-- �ܱ��Ѵ�д -->
			<PremText>
				<xsl:value-of select="PremText" />
			</PremText>
			<!--ʵ�ձ���-->
			<ActSumPrem>
				<xsl:value-of select="ActSumPrem" />
			</ActSumPrem>
			<!--ʵ�ձ��Ѵ�д-->
			<ActSumPremText>
				<xsl:value-of select="ActSumPremText" />
			</ActSumPremText>
			<!-- �����˱�00�� -->
			<AgentCode>
				<xsl:value-of select="AgentCode" />
			</AgentCode>
			<!-- ���������� -->
			<AgentName>
				<xsl:value-of select="AgentName" />
			</AgentName>
			<!-- �������ʸ�֤ -->
			<AgentCertiCode>
				<xsl:value-of select="AgentCertiCode" />
			</AgentCertiCode>
			<!-- ������������ -->
			<AgentGrpCode>
				<xsl:value-of select="AgentGrpCode" />
			</AgentGrpCode>
			<!-- ��������� -->
			<AgentGrpName>
				<xsl:value-of select="AgentGrpName" />
			</AgentGrpName>
			<!-- ����������� -->
			<AgentCom>
				<xsl:value-of select="AgentCom" />
			</AgentCom>
			<!-- ����������� -->
			<AgentComName>
				<xsl:value-of select="AgentComName" />
			</AgentComName>
			<!-- ��������ʸ�֤ -->
			<AgentComCertiCode>
				<xsl:value-of select="AgentComCertiCode" />
			</AgentComCertiCode>
			<!-- �б���˾���� -->
			<ComCode>
				<xsl:value-of select="ComCode" />
			</ComCode>
			<!-- �б���˾��ַ -->
			<ComLocation>
				<xsl:value-of select="ComLocation" />
			</ComLocation>
			<!-- �б���˾���� -->
			<ComName>
				<xsl:value-of select="ComName" />
			</ComName>
			<!-- �б���˾�ʱ� -->
			<ComZipCode>
				<xsl:value-of select="ComZipCode" />
			</ComZipCode>
			<!-- �б���˾�绰 -->
			<ComPhone>
				<xsl:value-of select="ComPhone" />
			</ComPhone>
			<!-- ��Ա���� -->
			<TellerNo>
				<xsl:value-of select="TellerNo" />
			</TellerNo>
			<!--����������Ա���� -->
			<SellerNo>
				<xsl:value-of select="SellerNo" />
			</SellerNo>
			<!--����������Ա���� -->
			<TellerName>
				<xsl:value-of select="TellerName" />
			</TellerName>
			<!--����������Ա�ʸ�֤ -->
			<TellerCertiCode>
				<xsl:value-of select="TellerCertiCode" />
			</TellerCertiCode>
			<!--���б���ҵ�����˹��� -->
			<AgentManageNo>
				<xsl:value-of select="AgentManageNo" />
			</AgentManageNo>
			<!--���б���ҵ���������� -->
			<AgentManageName>
				<xsl:value-of select="AgentManageName" />
			</AgentManageName>
			<SpecContent>
				<xsl:value-of select="SpecContent" />
			</SpecContent>
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
		  	
		  	<!--����״̬-->
		  	<ContState>
		  		<xsl:value-of select="ContState" />
		  	</ContState>
		  	<!--����ҵ������--> 
			<BusinessTypes> 
				<!--���屣��ҵ������--> 
				<BusinessType><xsl:value-of select="BusinessType" /></BusinessType> 
			</BusinessTypes>
			<EdorInfos>
				<EdorInfo>
					<!-- ��ȫ����-->
					<EdorType>
						<xsl:value-of select="EdorType" />
					</EdorType>
					<EdorAppDate>
						<xsl:value-of select="EdorAppDate" />
					</EdorAppDate>
					<EdorValidDate>
						<xsl:value-of select="EdorValidDate" />
					</EdorValidDate>
					<!--��ȫ����״̬ -->
					<EdorState>
						<xsl:value-of select="EdorState" /><!--��ȫ״̬-->
					</EdorState>
				</EdorInfo>
			</EdorInfos>
			<!--������Ѻ״̬�� 0δ��Ѻ��1��Ѻ-->
			<MortStatu>
				<xsl:value-of select="MortStatu" />
			</MortStatu> 
			<!-- �˱� -->
			<Surr> 
				 <!--������ֵ�����ղ�ѯ������λ������ҷ�-->
				 <CashvalueD>
				 	<xsl:value-of select="CashvalueD" />
				 </CashvalueD> 
				 <!--������ֵ������������Ϣ���˻���ֵ������λ������ҷ�-->
				 <CashvalueIntD>
				 	<xsl:value-of select="CashvalueIntD" />
				 </CashvalueIntD> 
				 <!--�˱��ɷ�������λ������ҷ�-->
				 <GetMoney>
				 	<xsl:value-of select="GetMoney" />
				 </GetMoney>
				 <!--�˱������ѣ���λ������ҷ�--> 
				 <GetCharge>
				 	<xsl:value-of select="GetCharge" />
				 </GetCharge> 
			</Surr>
		</Body>
	</xsl:template>
	<!-- Ͷ���� -->
	<xsl:template name="Appnt" match="Appnt">
		<Appnt>
			<!-- �ͻ��� -->
		    <CustomerNo>
		    	<xsl:value-of select="CustomerNo" />
		    </CustomerNo>
		    <!-- ���� -->
			<Name>
				<xsl:value-of select="Name" />
			</Name>
			<!-- �Ա� -->
			<Sex>
				<xsl:value-of select="Sex" />
			</Sex>
			<!-- ��������(yyyyMMdd) -->
			<Birthday>
				<xsl:value-of select="Birthday" />
			</Birthday>
			<!-- ֤������ -->
			<IDType>
				<xsl:value-of select="IDType" />
			</IDType>
			<!-- ֤������ -->
			<IDNo>
				<xsl:value-of select="IDNo" />
			</IDNo>
			<!-- ְҵ��� -->
			<JobType>
				<xsl:value-of select="JobType" />
			</JobType>
			<!-- ְҵ���� -->
			<JobCode>
				<xsl:value-of select="JobCode" />
			</JobCode>
			<!-- ְҵ���� -->
			<JobName>
				<xsl:value-of select="JobName" />
			</JobName>
			<!-- ����-->
			<Nationality>
				<xsl:value-of select="Nationality" />
			</Nationality>
			<!-- ���(cm) -->
			<Stature>
				<xsl:value-of select="Stature" />
			</Stature>
			<!-- ����(g) -->
			<Weight>
				<xsl:value-of select="Weight" />
			</Weight>
			<!-- ���(N/Y) -->
			<MaritalStatus>
				<xsl:value-of select="MaritalStatus" />
			</MaritalStatus>
			<!-- ��ַ -->
			<Address>
				<xsl:value-of select="Address" />
			</Address>
			<!-- �ʱ� -->
			<ZipCode>
				<xsl:value-of select="ZipCode" />
			</ZipCode>
			<!-- �ƶ��绰 -->
			<Mobile>
				<xsl:value-of select="Mobile" />
			</Mobile>
			<!-- �̶��绰 -->
			<Phone>
				<xsl:value-of select="Phone" />
			</Phone>
			<!-- �����ʼ�-->
			<Email>
				<xsl:value-of select="Email" />
			</Email>
			<!-- �뱻���˹�ϵ -->
			<RelaToInsured>
				<xsl:value-of select="RelaToInsured" />
			</RelaToInsured>
		 </Appnt>
	</xsl:template>
	<!-- �������� -->
	<xsl:template name="Insured" match="Insured">
		<Insured>
			<!-- �ͻ��� -->
		    <CustomerNo>
		    	<xsl:value-of select="CustomerNo" />
		    </CustomerNo>
		    <!-- ���� -->
			<Name>
				<xsl:value-of select="Name" />
			</Name>
			<!-- �Ա� -->
			<Sex>
				<xsl:value-of select="Sex" />
			</Sex>
			<!-- ��������(yyyyMMdd) -->
			<Birthday>
				<xsl:value-of select="Birthday" />
			</Birthday>
			<!-- ֤������ -->
			<IDType>
				<xsl:value-of select="IDType" />
			</IDType>
			<!-- ֤������ -->
			<IDNo>
				<xsl:value-of select="IDNo" />
			</IDNo>
			<!-- ְҵ��� -->
			<JobType>
				<xsl:value-of select="JobType" />
			</JobType>
			<!-- ְҵ���� -->
			<JobCode>
				<xsl:value-of select="JobCode" />
			</JobCode>
			<!-- ְҵ���� -->
			<JobName>
				<xsl:value-of select="JobName" />
			</JobName>
			<!-- ���(cm)-->
			<Stature>
				<xsl:value-of select="Stature" />
			</Stature>
			<!-- ����-->
			<Nationality>
				<xsl:value-of select="Nationality" />
			</Nationality>
			<!-- ����(g) -->
			<Weight>
				<xsl:value-of select="Weight" />
			</Weight>
			<!-- ���(N/Y) -->
			<MaritalStatus>
				<xsl:value-of select="MaritalStatus" />
			</MaritalStatus>
			<!-- ��ַ -->
			<Address>
				<xsl:value-of select="Address" />
			</Address>
			<!-- �ʱ� -->
			<ZipCode>
				<xsl:value-of select="ZipCode" />
			</ZipCode>
			<!-- �ƶ��绰 -->
			<Mobile>
				<xsl:value-of select="Mobile" />
			</Mobile>
			<!-- �̶��绰 -->
			<Phone>
				<xsl:value-of select="Phone" />
			</Phone>
			<!-- �����ʼ�-->
			<Email>
				<xsl:value-of select="Email" />
			</Email>
		 </Insured>
	</xsl:template>
	<!-- ������ -->
	<xsl:template name="Bnf" match="Bnf">		
		  <Bnf>
		  	<!-- ��������� -->
		    <Type>
		    	<xsl:value-of select="Type" />
		    </Type>
		    <!-- ����˳�� -->
			<Grade>
				<xsl:value-of select="Grade" />
			</Grade>
			<!-- ���� -->
			<Name>
				<xsl:value-of select="Name" />
			</Name>
			<!-- �Ա� -->
			<Sex>
				<xsl:value-of select="Sex" />
			</Sex>
			<!-- ��������(yyyyMMdd) -->
			<Birthday>
				<xsl:value-of select="Birthday" />
			</Birthday>
			<!-- ֤������ -->
			<IDType>
				<xsl:value-of select="IDType" />
			</IDType>
			<!-- ֤������ -->
			<IDNo>
				<xsl:value-of select="IDNo" />
			</IDNo>
			<!-- �뱻���˹�ϵ -->
			<RelaToInsured>
				<xsl:value-of select="RelaToInsured" />
			</RelaToInsured>
			<!-- �������(�������ٷֱ�)  -->
			<Lot>
				<xsl:value-of select="Lot" />
			</Lot>
		  </Bnf>
	</xsl:template>
	<!-- ������Ϣ -->
	<xsl:template name="Risk" match="Risk">		
		 <Risk>
		 	<xsl:choose>
				<xsl:when test="../ContPlan/ContPlanCode!=''">
					<!-- ���ִ��� -->
					<RiskCode>
				    	<xsl:call-template name="tran_RiskCode">
		                    <xsl:with-param name="riskCode">
		                        <xsl:value-of select="../ContPlan/ContPlanCode" />
		                    </xsl:with-param>
		                </xsl:call-template>
				    </RiskCode>
				    <!-- �������� -->
					<RiskName>
						<xsl:value-of select="../ContPlan/ContPlanName" />
					</RiskName>
					<!-- ���մ��� -->
					<MainRiskCode>
						<xsl:call-template name="tran_RiskCode">
		                    <xsl:with-param name="riskCode">
		                        <xsl:value-of select="../ContPlan/ContPlanCode" />
		                    </xsl:with-param>
		                </xsl:call-template>
					</MainRiskCode>	
					<!-- ����(��) -->
					<Amnt>
						<xsl:value-of select="../Amnt" />
					</Amnt>
					<!-- ���շ�(��) -->
					<Prem>
						<xsl:value-of select="../ActSumPrem" />
					</Prem>
					<!-- Ͷ������ -->		
					<Mult>
						<xsl:value-of select="../ContPlan/ContPlanMult" />
					</Mult>		
				</xsl:when>
				<xsl:otherwise>
					<!-- ���ִ��� -->
					<RiskCode>
				    	<xsl:call-template name="tran_RiskCode">
		                    <xsl:with-param name="riskCode">
		                        <xsl:value-of select="RiskCode" />
		                    </xsl:with-param>
		                </xsl:call-template>
				    </RiskCode>
				    <!-- �������� -->
					<RiskName>
						<xsl:value-of select="RiskName" />
					</RiskName>
					<!-- ���մ��� -->
					<MainRiskCode>
						<xsl:call-template name="tran_RiskCode">
		                    <xsl:with-param name="riskCode">
		                        <xsl:value-of select="MainRiskCode" />
		                    </xsl:with-param>
		                </xsl:call-template>
					</MainRiskCode>
					<!-- ����(��) -->
					<Amnt>
						<xsl:value-of select="../Amnt" />
					</Amnt>
					<!-- ���շ�(��) -->
					<Prem>
						<xsl:value-of select="../ActSumPrem" />
					</Prem>
					<!-- Ͷ������ -->
					<Mult>
						<xsl:value-of select="Mult" />
					</Mult>
				</xsl:otherwise>
			</xsl:choose>		
		    <!-- �ɷ�Ƶ�� -->
			<PayIntv>
				<xsl:value-of select="PayIntv" />
			</PayIntv>
			<!-- �ɷ���ʽ -->
			<PayMode>
				<xsl:value-of select="PayMode" />
			</PayMode>
			<!-- Ͷ������(yyyyMMdd) -->
			<PolApplyDate>
				<xsl:value-of select="PolApplyDate" />
			</PolApplyDate>
			<!-- �б�����(yyyyMMdd) -->
			<SignDate>
				<xsl:value-of select="SignDate" />
			</SignDate>
			<!-- ������(yyyyMMdd) -->
			<CValiDate>
				<xsl:value-of select="CValiDate" />
			</CValiDate>
			<!-- �����������ڱ�־ -->
			<InsuYearFlag>
				<xsl:value-of select="InsuYearFlag" />
			</InsuYearFlag>
			<!-- ������������ -->
			<InsuYear>
				<xsl:value-of select="InsuYear" />
			</InsuYear>
			<!-- ����������ֹ���� -->
			<InsuEndDate>
				<xsl:value-of select="InsuEndDate" />
			</InsuEndDate>
			<!-- �����ڼ� -->
			<Years>
				<xsl:value-of select="Years" />
			</Years>
			<!-- �ɷ��������� -->
			<PayEndYearFlag>
				<xsl:value-of select="PayEndYearFlag" />
			</PayEndYearFlag>
			<!-- �ɷ����� -->
			<PayEndYear>
				<xsl:value-of select="PayEndYear" />
			</PayEndYear>
			<!-- �ս����� -->
			<PayEndDate>
				<xsl:value-of select="PayEndDate" />
			</PayEndDate>
			<!-- �ۿ��� -->
			<CostIntv>
				<xsl:value-of select="CostIntv" />
			</CostIntv>
			<!-- �ۿ�ʱ�� -->
			<CostDate>
				<xsl:value-of select="CostDate" />
			</CostDate>
			<!-- ��������(yyyyMMdd) -->
			<PayToDate>
				<xsl:value-of select="PayToDate" />
			</PayToDate>
			<!-- ��ȡ�������ڱ�־ -->
			<GetYearFlag>
				<xsl:value-of select="GetYearFlag" />
			</GetYearFlag>
			<!-- ��������(yyyyMMdd) -->
			<GetStartDate>
				<xsl:value-of select="GetStartDate" />
			</GetStartDate>
			<!-- ��ȡ���� -->
			<GetYear>
				<xsl:value-of select="GetYear" />
			</GetYear>
			<!-- ��ȡ��ʽ -->
			<GetIntv>
				<xsl:value-of select="GetIntv" />
			</GetIntv>
			<!-- ��ȡ���б��� -->
			<GetBankCode>
				<xsl:value-of select="GetBankCode" />
			</GetBankCode>
			<!-- ��ȡ�����˻� -->
			<GetBankAccNo>
				<xsl:value-of select="GetBankAccNo" />
			</GetBankAccNo>
			<!-- ��ȡ���л��� -->
			<GetAccName>
				<xsl:value-of select="GetAccName" />
			</GetAccName>
			<!-- �Զ��潻��־ -->
			<AutoPayFlag>
				<xsl:value-of select="AutoPayFlag" />
			</AutoPayFlag>
			<!-- ������ȡ��ʽ -->
			<BonusGetMode>
				<xsl:value-of select="BonusGetMode" />
			</BonusGetMode>
			<!-- ������־ -->
			<SubFlag>
				<xsl:value-of select="SubFlag" />
			</SubFlag>
			<!-- ������ȡ����ȡ��ʽ -->
			<FullBonusGetMode>
				<xsl:value-of select="FullBonusGetMode" />
			</FullBonusGetMode>
		
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
            <xsl:when test=".='122009'">122009</xsl:when><!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A�� -->
			<xsl:when test=".='122010'">L12100</xsl:when><!-- ����ʢ��3���������գ������ͣ� -->
			<!-- xsl:when test=".='122010'">L12078</xsl:when>  --><!-- ����ʢ��3���������գ������ͣ� -->
			<xsl:when test=".='122012'">L12079</xsl:when><!-- ����ʢ��2���������գ������ͣ�  -->
			<xsl:when test=".='122036'">122036</xsl:when><!-- ����ƽ�6����ȫ���գ��ֺ��ͣ�A�� -->
			<xsl:when test=".='50002'">50015</xsl:when>  <!-- �������Ӯ���ռƻ�  -->
			<xsl:when test=".='L12080'">L12080</xsl:when>  <!-- ����ʢ��1���������գ������ͣ� -->
			<!--<xsl:when test=".='L12089'">L12089</xsl:when>-->  <!-- ����ʢ��1���������գ������ͣ�B�� -->
			<xsl:when test=".='L12074'">L12074</xsl:when>  <!-- ����ʢ��9����ȫ���գ������ͣ� -->
			<xsl:when test=".='L12087'">L12087</xsl:when><!-- �����5����ȫ���գ������ͣ�  -->
			<xsl:when test=".='L12086'">L12086</xsl:when><!-- �����3����ȫ���գ������ͣ� ���� -->
			<xsl:when test=".='L12085'">L12085</xsl:when><!-- �����2����ȫ���գ������ͣ� ���� -->
            <xsl:when test=".='L12088'">L12088</xsl:when><!-- �����9����ȫ���գ������ͣ� ���� -->
            <xsl:when test=".='L12091'">L12091</xsl:when><!-- �����Ӯ1�������A��-->
			<xsl:otherwise></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>