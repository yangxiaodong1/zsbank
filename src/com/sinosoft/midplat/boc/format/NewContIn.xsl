<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:java="http://xml.apache.org/xslt/java" 
    exclude-result-prefixes="java">
	<xsl:output indent="yes"/>
	
	<xsl:template match="/TranData">
		<TranData>
			<xsl:apply-templates select="Head"/>
			<xsl:apply-templates select="Body"/>
		</TranData>
	</xsl:template>
	
	<xsl:template name="Transaction_Head" match="Head">
		<Head>
		    <TranDate><xsl:value-of select="TranDate"/></TranDate><!-- ��������[yyyyMMdd] -->
            <TranTime><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.time8to6(TranTime)" /></TranTime><!-- ����ʱ��[hhmmss] -->
            <TranCom outcode="08"><xsl:value-of select="TranCom"/></TranCom><!-- ���׵�λ(����/ũ����/������˾) -->            
            <NodeNo><xsl:value-of select="ZoneNo"/><xsl:value-of select="NodeNo"/></NodeNo><!-- �������� +�������� -->
            <TellerNo><xsl:value-of select="TellerNo"/></TellerNo><!-- ��Ա���� -->
            <TranNo><xsl:value-of select="TranNo"/></TranNo><!-- ������ˮ�� -->
            <FuncFlag><xsl:value-of select="FuncFlag"/></FuncFlag><!-- �������� -->
			<BankCode><xsl:value-of select="TranCom/@outcode"/></BankCode>
		</Head>
	</xsl:template>
	
	<xsl:template name="Transaction_Body" match="Body">
		<Body>
			<ProposalPrtNo>
				<xsl:value-of select="ProposalPrtNo"/>
			</ProposalPrtNo>
			<!-- Ͷ����(ӡˢ)�� -->
			<ContPrtNo>
				<xsl:value-of select="ContPrtNo"/>
			</ContPrtNo>
			<!-- ������ͬӡˢ�� -->
			<PolApplyDate>
				<xsl:value-of select="PolApplyDate"/>
			</PolApplyDate>
			<!-- Ͷ������ -->
			<AccName>
				<xsl:value-of select="AccName"/>
			</AccName>
			<!-- �˻����� -->
			<AccNo>
				<xsl:value-of select="AccNo"/>
			</AccNo>
			<!-- �����˻� -->
			<GetPolMode>
				<xsl:value-of select="GetPolMode"/>
			</GetPolMode>
			<!-- �������ͷ�ʽ -->
			<JobNotice>
				<xsl:value-of select="GetPolMode"/>
			</JobNotice>
			<!-- ְҵ��֪(N/Y) -->
			<HealthNotice>
				<xsl:value-of select="HealthNotice"/>
			</HealthNotice>
			<!-- ������֪(N/Y)  -->
			<PolicyIndicator>
			    <xsl:value-of select="PolicyIndicator"/>
			</PolicyIndicator>
			<!--δ���걻�������Ƿ����������չ�˾Ͷ����ʱ��� Y��N��-->
			<InsuredTotalFaceAmount>
			    <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(InsuredTotalFaceAmount)" />
			</InsuredTotalFaceAmount>
			<!--�ۼ�δ������Ͷ����ʱ���-->
			<Appnt>
				<!-- Ͷ������Ϣ  -->
				<Name>
					<xsl:value-of select="Appnt/Name"/>
				</Name>
				<!-- ���� -->
				<Sex>
					<xsl:value-of select="Appnt/Sex"/>
				</Sex>
				<!-- �Ա� -->
				<Birthday>
					<xsl:value-of select="Appnt/Birthday"/>
				</Birthday>
				<!-- ��������(yyyyMMdd) -->
				<IDType>
					<xsl:value-of select="Appnt/IDType"/>
				</IDType>
				<!-- ֤������ -->
				<IDNo>
					<xsl:value-of select="Appnt/IDNo"/>
				</IDNo>
				<!-- ֤������ -->
				<IDTypeStartDate>
					<xsl:value-of select="Appnt/IDTypeStartDate"/>
				</IDTypeStartDate>
				<!-- ֤����Ч���� -->
				<IDTypeEndDate>
					<xsl:value-of select="Appnt/IDTypeEndDate"/>
				</IDTypeEndDate>
				<!-- ֤����Чֹ�� -->
				<JobCode>
					<xsl:value-of select="Appnt/JobCode"/>
				</JobCode>
				<!-- ְҵ���� -->
				<Nationality>
		            <xsl:call-template name="tran_Nationality">
		                <xsl:with-param name="nationality">
		 	            <xsl:value-of select="Appnt/Nationality"/>
	                </xsl:with-param>
	            </xsl:call-template>
				</Nationality>
				<!-- ���� -->
				<Stature>
					<xsl:value-of select="Appnt/Stature"/>
				</Stature>
				<!-- ���(cm) -->
				<Weight>
					<xsl:value-of select="Appnt/Weight"/>
				</Weight>
				<!-- ����(g) -->
				<MaritalStatus>
					<xsl:value-of select="Appnt/MaritalStatus"/>
				</MaritalStatus>
				<!-- ���(N/Y) -->
				<Address>
					<xsl:value-of select="Appnt/Address"/>
				</Address>
				<!-- ��ַ -->
				<ZipCode>
					<xsl:value-of select="Appnt/ZipCode"/>
				</ZipCode>
				<!-- �ʱ� -->
				<Mobile>
					<xsl:value-of select="Appnt/Mobile"/>
				</Mobile>
				<!-- �ƶ��绰 -->
				<Phone>
					<xsl:value-of select="Appnt/Phone"/>
				</Phone>
				<!-- �̶��绰 -->
				<Email>
					<xsl:value-of select="Appnt/Email"/>
				</Email>
				<!-- �����ʼ�-->
				<RelaToInsured>
					<xsl:value-of select="Appnt/RelaToInsured"/>
				</RelaToInsured>
				<!-- �뱻���˹�ϵ -->
			</Appnt>
			<Insured>
				<!-- ��������Ϣ  -->
				<Name>
					<xsl:value-of select="Insured/Name"/>
				</Name>
				<!-- ���� -->
				<Sex>
					<xsl:value-of select="Insured/Sex"/>
				</Sex>
				<!-- �Ա� -->
				<Birthday>
					<xsl:value-of select="Insured/Birthday"/>
				</Birthday>
				<!-- ��������(yyyyMMdd) -->
				<IDType>
					<xsl:value-of select="Insured/IDType"/>
				</IDType>
				<!-- ֤������ -->
				<IDNo>
					<xsl:value-of select="Insured/IDNo"/>
				</IDNo>
				<!-- ֤������ -->
				<IDTypeStartDate>
					<xsl:value-of select="Insured/IDTypeStartDate"/>
				</IDTypeStartDate>
				<!-- ֤����Ч���� -->
				<IDTypeEndDate>
					<xsl:value-of select="Insured/IDTypeEndDate"/>
				</IDTypeEndDate>
				<!-- ֤����Чֹ�� -->
				<JobCode>
					<xsl:value-of select="Insured/JobCode"/>
				</JobCode>
				<!-- ְҵ���� -->
				<Nationality>
		            <xsl:call-template name="tran_Nationality">
		                <xsl:with-param name="nationality">
		 	            <xsl:value-of select="Insured/Nationality"/>
	                </xsl:with-param>
	            </xsl:call-template>
				</Nationality>
				<!-- ���� -->
				<Stature>
					<xsl:value-of select="Insured/Stature"/>
				</Stature>
				<!-- ���(cm) -->
				<Weight>
					<xsl:value-of select="Insured/Weight"/>
				</Weight>
				<!-- ����(g) -->
				<MaritalStatus>
					<xsl:value-of select="Insured/MaritalStatus"/>
				</MaritalStatus>
				<!-- ���(N/Y) -->
				<Address>
					<xsl:value-of select="Insured/Address"/>
				</Address>
				<ZipCode>
					<xsl:value-of select="Insured/ZipCode"/>
				</ZipCode>
				<Mobile>
					<xsl:value-of select="Insured/Mobile"/>
				</Mobile>
				<Phone>
					<xsl:value-of select="Insured/Phone"/>
				</Phone>
				<Email>
					<xsl:value-of select="Insured/Email"/>
				</Email>
			</Insured>
			<!-- ��������Ϣ  -->
			<xsl:for-each select="Bnf">
				<xsl:choose>
					<xsl:when test="Name!=''">
						<Bnf>
							<Type>
								<xsl:value-of select="Type"/>
							</Type>
							<!-- ��������� -->
							<Grade>
								<xsl:value-of select="Grade"/>
							</Grade>
							<!-- ����˳�� -->
							<Name>
								<xsl:value-of select="Name"/>
							</Name>
							<!-- ���� -->
							<Sex>
								<xsl:value-of select="Sex"/>
							</Sex>
							<!-- �Ա� -->
							<Birthday>
								<xsl:value-of select="Birthday"/>
							</Birthday>
							<!-- ��������(yyyyMMdd) -->
							<IDType>
								<xsl:value-of select="IDType"/>
							</IDType>
							<!-- ֤������ -->
							<IDNo>
								<xsl:value-of select="IDNo"/>
							</IDNo>
							<!-- ֤������ -->
							<IDTypeStartDate>
								<xsl:value-of select="IDTypeStartDate"/>
							</IDTypeStartDate>
							<!-- ֤����Ч���� -->
							<IDTypeEndDate>
								<xsl:value-of select="IDTypeEndDate"/>
							</IDTypeEndDate>
							<!-- ֤����Чֹ�� -->
							<RelaToInsured>
								<xsl:value-of select="RelationToInsured"/>
							</RelaToInsured>
							<!-- �뱻���˹�ϵ -->
							<Lot>
								<xsl:value-of select="Lot"/>
							</Lot>
							<!-- �������(�������ٷֱ�) -->
						</Bnf>
					</xsl:when>
					<xsl:otherwise/>
				</xsl:choose>
			</xsl:for-each>
			<!-- ������Ϣ  -->
			<xsl:for-each select="Risk">
				<xsl:choose>
					<xsl:when test="RiskCode!=''">
						<Risk>
							<RiskCode>
								<xsl:value-of select="RiskCode"/>
							</RiskCode>
							<!-- ���ִ��� -->
							<MainRiskCode>
								<xsl:value-of select="MainRiskCode"/>
							</MainRiskCode>
							<!-- �������ִ��� -->
							<RiskType>
								<xsl:value-of select="RiskType"/>
							</RiskType>
							<!-- �������� -->
							<Amnt>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Amnt)"/>
							</Amnt>
							<!-- ����(��) -->
							<Prem>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Prem)"/>
							</Prem>
							<!-- ���շ�(��) -->
							<Mult>
								<xsl:value-of select="Mult"/>
							</Mult>
							<!-- Ͷ������ -->
							<PayMode>
								<xsl:value-of select="PayMode"/>
							</PayMode>
							<!-- �ɷ���ʽ -->
							<PayIntv>
								<xsl:value-of select="PayIntv"/>
							</PayIntv>
							<!-- �ɷ�Ƶ�� -->
							<CostIntv/>
							<CostDate/>
							<Years>
								<xsl:value-of select="Years"/>
							</Years>
							<InsuYearFlag>
								<xsl:value-of select="InsuYearFlag"/>
							</InsuYearFlag>
							<!-- �������������־ -->
							<InsuYear>
								<!-- ������ -->
								<xsl:if test="InsuYearFlag=A">106</xsl:if>
								<xsl:if test="InsuYearFlag!=A">
									<xsl:value-of select="InsuYear"/>
								</xsl:if>
							</InsuYear>
							<!-- ������������ -->
							<xsl:if test="PayIntv = 0">
								<PayEndYearFlag>Y</PayEndYearFlag>
								<PayEndYear>1000</PayEndYear>
							</xsl:if>
							<xsl:if test="PayIntv != 0">
								<PayEndYearFlag>
									<xsl:value-of select="PayEndYearFlag"/>
								</PayEndYearFlag>
								<!-- �ɷ����������־ -->
								<PayEndYear>
									<xsl:value-of select="PayEndYear"/>
								</PayEndYear>
								<!-- �ɷ��������� -->
							</xsl:if>
							<BonusGetMode>
								<xsl:value-of select="BonusGetMode"/>
							</BonusGetMode>
							<!-- ������ȡ��ʽ -->
							<FullBonusGetMode>
								<xsl:value-of select="FullBonusGetMode"/>
							</FullBonusGetMode>
							<!-- ������ȡ����ȡ��ʽ -->
							<GetYearFlag>
								<xsl:value-of select="GetYearFlag"/>
							</GetYearFlag>
							<!-- ��ȡ�������ڱ�־ -->
							<GetYear>
								<xsl:value-of select="GetYear"/>
							</GetYear>
							<!-- ��ȡ���� -->
							<GetIntv>
								<xsl:value-of select="GetIntv"/>
							</GetIntv>
							<!-- ��ȡ��ʽ -->
							<GetBankCode>
								<xsl:value-of select="GetBankCode"/>
							</GetBankCode>
							<!-- ��ȡ���б��� -->
							<GetBankAccNo>
								<xsl:value-of select="GetBankAccNo"/>
							</GetBankAccNo>
							<!-- ��ȡ�����˻� -->
							<GetAccName>
								<xsl:value-of select="GetAccName"/>
							</GetAccName>
							<!-- ��ȡ���л��� -->
							<AutoPayFlag>
								<xsl:value-of select="AutoPayFlag"/>
							</AutoPayFlag>
							<!-- �Զ��潻��־ -->
						</Risk>
					</xsl:when>
					<xsl:otherwise/>
				</xsl:choose>
			</xsl:for-each>
		</Body>
	</xsl:template>
	
	
<!-- ����ת�� -->
<xsl:template name="tran_Nationality">
	<xsl:param name="nationality">0</xsl:param>
	<xsl:choose>
		<xsl:when test="$nationality = 'AUS'">AU</xsl:when>  <!-- �Ĵ����� -->
		<xsl:when test="$nationality = 'CHN'">CHN</xsl:when> <!-- �й�  -->
		<xsl:when test="$nationality = 'ENG'">GB</xsl:when>  <!-- Ӣ��  -->
		<xsl:when test="$nationality = 'JAN'">JP</xsl:when>  <!-- �ձ�  -->
		<xsl:when test="$nationality = 'RUS'">RU</xsl:when>  <!-- ����˹  -->
		<xsl:when test="$nationality = 'USA'">US</xsl:when>  <!-- ����  -->
		<xsl:otherwise>OTH</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
