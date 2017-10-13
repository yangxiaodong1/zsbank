<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
 	exclude-result-prefixes="java">

<xsl:output indent='yes'/>
<xsl:template match="/TranData">
<TXLife>
	<!-- ���׷����� -->
	<ResultCode>
	     <xsl:if test="Head/Flag='0'">00</xsl:if>
	  	 <xsl:if test="Head/Flag='1'">99</xsl:if>
	</ResultCode>
	<ResultInfoDesc><xsl:value-of select ="Head/Desc"/></ResultInfoDesc>
	<!-- ������׳ɹ����ŷ�������Ľ�� -->
	<xsl:if test="Head/Flag='0'">
	<xsl:variable name="MainRisk" select="Body/Risk[RiskCode=MainRiskCode]"/>
	<xsl:variable name="InsuredSex" select="Body/Insured/Sex"/>
	<!-- Ͷ������ -->
	<HOAppFormNumber><xsl:value-of select ="Body/ProposalPrtNo"/></HOAppFormNumber>
	<!--�ϼƱ���(���ձ��ѣ������ձ���) -->
	<PaymentAmt><xsl:value-of select ="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/Prem)"/></PaymentAmt>
	<!-- ���ִ��� -->
	<ProductCode>
		<xsl:call-template name="tran_riskcode">
			<xsl:with-param name="riskcode" select="$MainRisk/MainRiskCode" />
		</xsl:call-template>
	</ProductCode>
	<!--���ձ���=(���յĽɷѱ�׼��ְҵ�ӷѣ��ۺϼӷ�)*���շ��� -->
	<ModalPremAmt><xsl:value-of select ="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/Prem)"/></ModalPremAmt>
	<!-- �������� -->
	<PlanName><xsl:value-of select ="$MainRisk/RiskName"/></PlanName>
	<!-- Ͷ������ -->
	<SubmissionDate><xsl:value-of select ="$MainRisk/PolApplyDate"/></SubmissionDate>
	<!-- Ͷ�������з���λ��Ԫ -->
	<IntialNumberOfUnits><xsl:value-of select ="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/Amnt)*0.0001"/></IntialNumberOfUnits>
	<!-- Ͷ������ -->
	<AgeTouBao></AgeTouBao>
	<!-- �ɷѷ�ʽ�� -->
	<PaymentMode>
	    <xsl:call-template name="tran_PayIntv">
	        <xsl:with-param name="payIntv"> <xsl:value-of select="$MainRisk/PayIntv"/></xsl:with-param>
	    </xsl:call-template>
    </PaymentMode>
	<!-- �ɷѷ�ʽ���� -->
	<PaymentModeName>
	    <xsl:call-template name="tran_PayIntvCha">
	        <xsl:with-param name="payIntv"> <xsl:value-of select="$MainRisk/PayIntv" /></xsl:with-param>
	    </xsl:call-template>
	</PaymentModeName>
	<!-- �ɷ����� -->
	<PaymentDuration><xsl:value-of select ="$MainRisk/PayEndYear"/></PaymentDuration>
	<!-- ����ҵ��Ա���� -->
	<CpicTeller><xsl:value-of select ="Body/AgentCode"/></CpicTeller>
	<!-- ��ȡ���� -->
	<PayoutStart><xsl:value-of select ="$MainRisk/GetYear"/></PayoutStart>
	<!-- ������ȡ��ʽ���� -->
	<DivType>
	    <xsl:call-template name="tran_BonusGetMode">
	        <xsl:with-param name="bonusGetMode"> <xsl:value-of select="$MainRisk/BonusGetMode" /></xsl:with-param>
	    </xsl:call-template>
	</DivType>
	<!-- ������ȡ��ʽ���� -->
	<DivTypeName>
	    <xsl:call-template name="tran_BonusGetModeText">
	        <xsl:with-param name="bonusGetMode"><xsl:value-of select="$MainRisk/BonusGetMode" /></xsl:with-param>
	    </xsl:call-template>
	</DivTypeName>
	<!-- ��ȡ/������ʽ���� -->
	<BenefitMode>
	    <xsl:call-template name="tran_GetIntv">
	        <xsl:with-param name="getIntv"><xsl:value-of select="$MainRisk/GetIntv" /></xsl:with-param>
	    </xsl:call-template>
	</BenefitMode>
	<!-- ��ȡ/������ʽ���� -->
	<BenefitModeName>
	    <xsl:call-template name="tran_GetIntvText">
	        <xsl:with-param name="getIntv"><xsl:value-of select="$MainRisk/GetIntv" /></xsl:with-param>
	    </xsl:call-template>
	</BenefitModeName>
	<!-- ���������ȡ���� -->
	<FirstPayOutDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8($MainRisk/GetStartDate)" /></FirstPayOutDate>	 
	<!-- �ɷѱ�׼ -->
	<FeeStd><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/Prem)" /></FeeStd>
	<!-- �ۺϼӷѱ�׼ -->
	<FeeCon></FeeCon>
	<!-- ְҵ�ӷѱ�׼ -->
	<FeePro></FeePro>
	<!-- �ɷ���ֹ���� -->
	<PaymentEndAge><xsl:value-of select ="$MainRisk/PayEndYear"/></PaymentEndAge>
	<!-- �ɷ���ʼ����,������ʱǩ������Ϊ��ֵ���˴�ȡͶ������ -->
	<PaymentDueDate><xsl:value-of select="$MainRisk/PolApplyDate" /></PaymentDueDate>
	<!-- �ɷ���ֹ���� -->
	<FinalPaymentDate><xsl:value-of select ="$MainRisk/PayEndDate"/></FinalPaymentDate>
	<!-- ������ʼ���� -->
	<EffDate><xsl:value-of select="$MainRisk/CValiDate" /></EffDate>
	<!-- ������ֹ���� -->
	<TermDate><xsl:value-of select ="$MainRisk/InsuEndDate"/></TermDate>	
	
	<!-- ������˵�� -->
	<ResultInfo></ResultInfo>	
	<!-- ���� -->
	<BeiYong></BeiYong>
	
	
	<!-- Ͷ������Ϣ -->
	<PolicyHolder>
		<!-- Ͷ����֤������ -->
		<GovtID><xsl:value-of select ="Body/Appnt/IDNo"/></GovtID>
		<!-- Ͷ����֤������ -->
		<GovtIDTC>
			<xsl:call-template name="tran_IDType">
				<xsl:with-param name="idtype" select="Body/Appnt/IDType" />
			</xsl:call-template>
		</GovtIDTC>
		<!-- Ͷ�������� -->
		<FullName><xsl:value-of select ="Body/Appnt/Name"/></FullName>
		<!-- Ͷ�����Ա� -->
		<Gender>
			<xsl:call-template name="tran_sex">
				<xsl:with-param name="sex" select="Body/Appnt/Sex" />
			</xsl:call-template>
		</Gender>
		<!-- 
		<Gender><xsl:apply-templates select="Gender" /></Gender>
		-->
		<!-- Ͷ���˳������� -->
		<BirthDate><xsl:value-of select ="Body/Appnt/Birthday"/></BirthDate>
		<!-- �ɷѵ�ַ -->
		<Line1><xsl:value-of select ="Body/Appnt/Address"/></Line1>
		<!-- �ɷѵ绰 -->
		<DialNumber><xsl:value-of select ="Body/Appnt/Mobile"/></DialNumber>
		<!-- �ɷ��ʱ� -->
		<Zip><xsl:value-of select ="Body/Appnt/ZipCode"/></Zip>
		<!-- �뱻���˹�ϵ -->
		<RelatedToInsuredRoleCode>
			<xsl:call-template name="tran_RelationRoleCode">
			    <xsl:with-param name="relaToInsured"><xsl:value-of select="Body/Appnt/RelaToInsured"/></xsl:with-param>
				<xsl:with-param name="insuredSex"><xsl:value-of select="$InsuredSex"/></xsl:with-param>
				<xsl:with-param name="sex"><xsl:value-of select="Body/Appnt/Sex"/></xsl:with-param>
			</xsl:call-template>
		</RelatedToInsuredRoleCode>
		<!-- �뱻���˹�ϵ����-->
		<RelatedToInsuredRoleName>
			<xsl:call-template name="tran_RelationRoleCodeText">
			    <xsl:with-param name="relaToInsured"><xsl:value-of select="Body/Appnt/RelaToInsured"/></xsl:with-param>
				<xsl:with-param name="insuredSex"><xsl:value-of select="$InsuredSex"/></xsl:with-param>
				<xsl:with-param name="sex"><xsl:value-of select="Body/Appnt/Sex"/></xsl:with-param>
			</xsl:call-template>
        </RelatedToInsuredRoleName>
	</PolicyHolder>
	<!-- ��������Ϣ -->
	<Insured>
		<!-- ������֤������ -->
		<GovtID><xsl:value-of select ="Body/Insured/IDNo"/></GovtID>
		<!--������֤������ -->
		<GovtIDTC>
			<xsl:call-template name="tran_IDType">
				<xsl:with-param name="idtype" select="Body/Insured/IDType" />
			</xsl:call-template>
		</GovtIDTC>
		<!-- ���������� -->
		<FullName><xsl:value-of select="Body/Insured/Name"/></FullName>
		<!-- �������Ա� -->
		<Gender>
			<xsl:call-template name="tran_sex">
				<xsl:with-param name="sex" select="$InsuredSex" />
			</xsl:call-template>
		</Gender>
		<!-- �����˳������� -->
		<BirthDate><xsl:value-of select="Body/Insured/Birthday"/></BirthDate>
		<!-- ������ְҵ��� -->
		<OccupationType><xsl:value-of select="Body/Insured/JobType"/></OccupationType>
		<!-- �����˾�ס��ַ -->
		<Line1><xsl:value-of select="Body/Insured/Address"/></Line1>
		<!-- �����˾�ס�ʱ� -->
		<Zip><xsl:value-of select="Body/Insured/ZipCode"/></Zip>
		<!-- �����˵绰 -->
		<DialNumber><xsl:value-of select="Body/Insured/Mobile"/></DialNumber>
	</Insured>

	<!--�������Ƿ�Ϊ������־:���д�ʲô�����չ�˾����ʲô����newcont.java�д���
	<BeneficiaryIndicator></BeneficiaryIndicator>
	-->
	
	<!-- �����˸��� -->
	<BeneficiaryCount><xsl:value-of select ="count(Body/Bnf)"/></BeneficiaryCount>
	<!-- ��������Ϣ�������д��ݵ���Ϣ�������еı�ǩ�ٷ��ػ�ȥ����newcont.java�ķ���std2NoStd�д��� -->
	<xsl:for-each select="Body/Bnf">
	    <!-- �������Լ�� -->
		<Beneficiary>
			<!-- ���䷽ʽ -->
			<BeneficiaryMethod><xsl:value-of select="Grade" /></BeneficiaryMethod>
			<!-- �����˺� -->
			<GovtID><xsl:value-of select ="IDNo"/></GovtID>
			<!-- ���������� -->
			<FullName><xsl:value-of select ="Name"/></FullName>
			<!-- �������Ա� -->
			<Gender>
				<xsl:call-template name="tran_sex">
					<xsl:with-param name="sex" select="Sex" />
				</xsl:call-template>
			</Gender>
			<!-- �뱻���˹�ϵ -->
			<RelatedToInsuredRoleCode>
				<xsl:call-template name="tran_RelationRoleCode">
				    <xsl:with-param name="relaToInsured"><xsl:value-of select="RelaToInsured"/></xsl:with-param>
					<xsl:with-param name="insuredSex"><xsl:value-of select="$InsuredSex"/></xsl:with-param>
					<xsl:with-param name="sex"><xsl:value-of select="Sex"/></xsl:with-param>
				</xsl:call-template>
			</RelatedToInsuredRoleCode>
			<!-- �������������� -->
			<InterestPercent><xsl:value-of select="Lot" /></InterestPercent>
	    </Beneficiary>
	</xsl:for-each>
		
	<!-- ����������� -->
	<BasePreCount>0</BasePreCount>
	<!-- ��������ṹ -->
	<BasePre1>
		<!-- ������������ -->
		<BasePerName></BasePerName>
		<!-- ������ֵ -->
		<BasePeramount><xsl:value-of select ="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/Amnt)"/></BasePeramount>
	</BasePre1>
	<!-- �����ո��� -->
	<CoverageCount><xsl:value-of select ="count(Body/Risk[RiskCode != MainRiskCode])"/></CoverageCount>
	
	<!-- �����շ��ýṹ -->
	<Extension1>
		<!-- ���ִ��� -->
		<ProductCode></ProductCode>
		<!--�����ձ���=(�����յĽɷѱ�׼��ְҵ�ӷѣ��ۺϼӷ�)*�����շ��� -->
		<ModalPremAmt></ModalPremAmt>
		<!-- ���ִ������� -->
		<PlanName></PlanName>
		<!-- �����շ��� -->
		<IntialNumberOfUnits></IntialNumberOfUnits>
		<!-- ������ÿ�ݽɷѱ�׼ -->
		<FeeStd></FeeStd>
		<!-- ������ÿ���ۺϼӷ� -->
		<FeeCon></FeeCon>
		<!-- ������ÿ��ְҵ�ӷ� -->
		<FeePro></FeePro>
		<!-- �����ջ������� -->
		<BasePremAmt></BasePremAmt>
		<!-- �����սɷ���ֹ���� -->
		<PaymentEndAge></PaymentEndAge>
		<!-- �����սɷ���ֹ���� -->
		<FinalPaymentDate></FinalPaymentDate>
		<!-- ������������ֹ���� -->
		<TermDate></TermDate>
		<!-- �ɷѷ�ʽ���� -->
		<PaymentMode></PaymentMode>
		<!-- �ɷѷ�ʽ���� -->
		<PaymentModeName></PaymentModeName>
		<!-- �ɷ����� -->
		<PayoutDuration></PayoutDuration>
		<!-- ��ȡ/������ʽ���� -->
		<BenefitMode></BenefitMode>
		<!-- ��ȡ/������ʽ���� -->
		<BenefitModeName></BenefitModeName>
		<!-- ������ȡ��ʽ���� -->
		<DivType></DivType>
		<!-- ������ȡ��ʽ���� -->
		<DivTypeName></DivTypeName>
		<!-- ��ȡ���� -->
		<PayOutDate></PayOutDate>
		<!--��������ȡ���� -->
		<PayoutStart></PayoutStart> 
	</Extension1>
	
	<!-- �����ֽ��ֵ�� -->
	<!-- �����ֽ��ֵ�� -->
		<CashValue1>
			<!-- ��ĩ�ֽ��ֵ -->
			<Cash></Cash>
			<!-- ������� -->
			<Year></Year>
		</CashValue1>
		
		<CashValue2>
			<!-- ��ĩ�ֽ��ֵ -->
			<Cash></Cash>
			<!-- ������� -->
			<Year></Year>
		</CashValue2>
		<CashValue3>
			<!-- ��ĩ�ֽ��ֵ -->
			<Cash></Cash>
			<!-- ������� -->
			<Year></Year>
		</CashValue3>
		<CashValue4>
			<!-- ��ĩ�ֽ��ֵ -->
			<Cash></Cash>
			<!-- ������� -->
			<Year></Year>
		</CashValue4>
		<CashValue5>
			<!-- ��ĩ�ֽ��ֵ -->
			<Cash></Cash>
			<!-- ������� -->
			<Year></Year>
		</CashValue5>
		<CashValue6>
			<!-- ��ĩ�ֽ��ֵ -->
			<Cash></Cash>
			<!-- ������� -->
			<Year></Year>
		</CashValue6>
		<CashValue7>
			<!-- ��ĩ�ֽ��ֵ -->
			<Cash></Cash>
			<!-- ������� -->
			<Year></Year>
		</CashValue7>
		<CashValue8>
			<!-- ��ĩ�ֽ��ֵ -->
			<Cash></Cash>
			<!-- ������� -->
			<Year></Year>
		</CashValue8>
		<CashValue9>
			<!-- ��ĩ�ֽ��ֵ -->
			<Cash></Cash>
			<!-- ������� -->
			<Year></Year>
		</CashValue9>
		<CashValue10>
			<!-- ��ĩ�ֽ��ֵ -->
			<Cash></Cash>
			<!-- ������� -->
			<Year></Year>
		</CashValue10>
		<CashValue11>
			<!-- ��ĩ�ֽ��ֵ -->
			<Cash></Cash>
			<!-- ������� -->
			<Year></Year>
		</CashValue11>
		<CashValue12>
			<!-- ��ĩ�ֽ��ֵ -->
			<Cash></Cash>
			<!-- ������� -->
			<Year></Year>
		</CashValue12>
		<CashValue13>
			<!-- ��ĩ�ֽ��ֵ -->
			<Cash></Cash>
			<!-- ������� -->
			<Year></Year>
		</CashValue13>
		<CashValue14>
			<!-- ��ĩ�ֽ��ֵ -->
			<Cash></Cash>
			<!-- ������� -->
			<Year></Year>
		</CashValue14>
		<!--  
		<xsl:for-each select="Body/Risk/CashValues/CashValue">
			<CashValue1>
				<Cash><xsl:value-of select ="Cash"/></Cash>
				<Year><xsl:value-of select ="EndYear"/></Year>
			</CashValue1>
		</xsl:for-each>
		-->
	<LoanStartDate><xsl:value-of select ="java:com.sinosoft.midplat.common.DateUtil.date10to8(Body/LoanStartDate)"/></LoanStartDate>
	<LoanEndDate><xsl:value-of select ="java:com.sinosoft.midplat.common.DateUtil.date10to8(Body/LoanEndDate)"/></LoanEndDate>
	<!--��ͬ��Ϣ-->
	<ContractInfo>
		<!--�������ս��-->
		<RiskAmt><xsl:value-of select ="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/Risk/Amnt)"/></RiskAmt>
		<!--�����ۼƱ��ս��-->
		<TotalRiskAmt><xsl:value-of select ="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/Risk/Amnt)"/></TotalRiskAmt>
	</ContractInfo>
	</xsl:if> <!-- ������׳ɹ����ŷ�������Ľ�� -->
</TXLife>
</xsl:template>

<!-- +++++++++++++++++++++++++++++++++++++++++ģ����++++++++++++++++++++++++++++++++++++++++++++++++ -->
<!-- �ɷ�Ƶ�� 
 ����: 01������         10���½�     11������    12�����꽻    13���꽻          02��������
    ����:  0��һ�ν���/���� 1:  �½�     3:����      6:���꽻	  12���꽻          -1:�����ڽ� -->
<xsl:template name="tran_PayIntv">
	<xsl:param name="payIntv">0</xsl:param>
	<xsl:if test="$payIntv = '0'">01</xsl:if>
	<xsl:if test="$payIntv = '1'">10</xsl:if>
	<xsl:if test="$payIntv = '3'">11</xsl:if>
	<xsl:if test="$payIntv = '6'">12</xsl:if>
	<xsl:if test="$payIntv = '12'">13</xsl:if>
	<xsl:if test="$payIntv = '-1'">02</xsl:if>
</xsl:template>

   <xsl:template name="tran_PayIntvCha">
	<xsl:param name="payIntv">0</xsl:param>
	<xsl:if test="$payIntv = '0'">����</xsl:if>
	<xsl:if test="$payIntv = '1'">�½�</xsl:if>
	<xsl:if test="$payIntv = '3'">����</xsl:if>
	<xsl:if test="$payIntv = '6'">���꽻</xsl:if>
	<xsl:if test="$payIntv = '12'">�꽻</xsl:if>
	<xsl:if test="$payIntv = '-1'">�����ڽ�</xsl:if>
</xsl:template>

<!-- ֤������
    ����:1���֤   4����   8����֤  10����    11����֤    7���ڲ�    99����       2ʧҵ֤��3����֤��5ǩ֤��6ѧ��֤��9��������֤��
    ����:0���֤   1����   2����֤   3:����   4:����֤��  5:���ڲ�   8:���� 9:�쳣���֤
 -->
 <xsl:template name="tran_IDType">
	<xsl:param name="idtype"></xsl:param>
    <xsl:choose>
		<xsl:when test="$idtype = '0'">1</xsl:when>
		<xsl:when test="$idtype = '1'">4</xsl:when>
		<xsl:when test="$idtype = '2'">8</xsl:when>
		<xsl:when test="$idtype = '3'">10</xsl:when>
		<xsl:when test="$idtype = '4'">11</xsl:when>
		<xsl:when test="$idtype = '5'">7</xsl:when>
	    <xsl:otherwise>99</xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- ������ȡ��ʽ
00-�� 11-�ֽ���ȡ 12-�ۻ���Ϣ 13-�ֽɱ��� 14-�������� 
4�ֽ���ȡ    1�ۻ���Ϣ  3�ֽɱ���    5�������    2ԤԼת�� 
 -->
<xsl:template name="tran_BonusGetMode">
    <xsl:param name="bonusGetMode">0</xsl:param>
    <xsl:if test="$bonusGetMode='4'">11</xsl:if>
    <xsl:if test="$bonusGetMode='1'">12</xsl:if>
    <xsl:if test="$bonusGetMode='3'">13</xsl:if>
    <xsl:if test="$bonusGetMode='5'">14</xsl:if>
    <xsl:if test="$bonusGetMode='0'">00</xsl:if>
</xsl:template>
<xsl:template name="tran_BonusGetModeText">
    <xsl:param name="bonusGetMode">0</xsl:param>
    <xsl:if test="$bonusGetMode='4'">�ֽ���ȡ</xsl:if>
    <xsl:if test="$bonusGetMode='1'">�ۻ���Ϣ</xsl:if>
    <xsl:if test="$bonusGetMode='3'">�ֽɱ���</xsl:if>
    <xsl:if test="$bonusGetMode='5'">�������</xsl:if>
    <xsl:if test="$bonusGetMode='0'">��</xsl:if>
</xsl:template>	
	
<!--������ʽ
1-һ�θ��� 2-�����  3-�������  4-������  5-�¸���  6-����
0-����     12����    6������     3����     1����     36������  120ʮ����
 -->
<xsl:template name="tran_GetIntv">
    <xsl:param name="getIntv">0</xsl:param>
    <xsl:choose>
	    <xsl:when test="$getIntv='0'">1</xsl:when>
	    <xsl:when test="$getIntv='12'">2</xsl:when>
	    <xsl:when test="$getIntv='6'">3</xsl:when>
	    <xsl:when test="$getIntv='3'">4</xsl:when>
	    <xsl:when test="$getIntv='1'">5</xsl:when>
	    <xsl:otherwise>6</xsl:otherwise>
    </xsl:choose>
</xsl:template>	
<xsl:template name="tran_GetIntvText">
    <xsl:param name="getIntv">0</xsl:param>
    <xsl:choose>
	    <xsl:when test="$getIntv='0'">һ�θ���</xsl:when>
	    <xsl:when test="$getIntv='12'">�����</xsl:when>
	    <xsl:when test="$getIntv='6'">�������</xsl:when>
	    <xsl:when test="$getIntv='3'">������</xsl:when>
	    <xsl:when test="$getIntv='1'">�¸���</xsl:when>
	    <xsl:otherwise>����</xsl:otherwise>
    </xsl:choose>
</xsl:template>		

<!-- ��ϵ
���У� 301���� 302���� 303ĸŮ 304��Ů 305���� 306ĸ�� 307�ֵ� 308���� 309���� 310���� 311���� 312��Ӷ 313ֶ��
 314ֶŮ 315��� 316���� 317����Ů 318���� 319���� 320��ϱ 321��ɩ  323�� 324���� 325���� 399����
 
���ģ�00���� ��01��ĸ��,02��ż��03��Ů,04����,05��Ӷ,06����,07����,08����
      0 �У�1Ů
 -->
<xsl:template name="tran_RelationRoleCode">
    <xsl:param name="relaToInsured"></xsl:param>
    <xsl:param name="insuredSex"></xsl:param>
    <xsl:param name="sex"></xsl:param>
	<xsl:choose>
		<!-- ���� -->
		<xsl:when test="$relaToInsured='00'">301</xsl:when>
		<!-- ��ż -->
		<xsl:when test="$relaToInsured='02'">310</xsl:when>
		<!-- ��ĸ -->
		<xsl:when test="$relaToInsured='01'">
		    <xsl:if test="$sex='0'">
		        <xsl:if test="$insuredSex='0'">309</xsl:if>
		        <xsl:if test="$insuredSex='1'">304</xsl:if>
		    </xsl:if>
		    <xsl:if test="$sex='1'">
		        <xsl:if test="$insuredSex='0'">306</xsl:if>
		        <xsl:if test="$insuredSex='1'">303</xsl:if>
		    </xsl:if>
        </xsl:when>
		<!-- ��Ů -->
		<xsl:when test="$relaToInsured='03'">
		    <xsl:if test="$sex='0'">
		        <xsl:if test="$insuredSex='0'">309</xsl:if>
		        <xsl:if test="$insuredSex='1'">304</xsl:if>
		    </xsl:if>
		    <xsl:if test="$sex='1'">
		        <xsl:if test="$insuredSex='0'">306</xsl:if>
		        <xsl:if test="$insuredSex='1'">303</xsl:if>
		    </xsl:if>
        </xsl:when>
		<!-- ���� -->
		<xsl:when test="$relaToInsured='04'">399</xsl:when>
		<!-- ��Ӷ -->
		<xsl:when test="$relaToInsured='05'">312</xsl:when>
		<!-- �ֵܽ��� -->
		<xsl:when test="$relaToInsured='12'">
		    <xsl:if test="$sex='0'">
		        <xsl:if test="$insuredSex='0'">307</xsl:if>
		        <xsl:if test="$insuredSex='1'">319</xsl:if>
		    </xsl:if>
		    <xsl:if test="$sex='1'">
		        <xsl:if test="$insuredSex='0'">319</xsl:if>
		        <xsl:if test="$insuredSex='1'">308</xsl:if>
		    </xsl:if>
        </xsl:when>
		<!-- �������� -->
		<xsl:when test="$relaToInsured='25'">324</xsl:when>
		<!-- ���� -->
		<xsl:when test="$relaToInsured='27'">316</xsl:when>
		<!-- ���� -->
		<xsl:otherwise>399</xsl:otherwise>
	</xsl:choose>
</xsl:template>	

<xsl:template name="tran_RelationRoleCodeText">
    <xsl:param name="relaToInsured"></xsl:param>
    <xsl:param name="insuredSex"></xsl:param>
    <xsl:param name="sex"></xsl:param>
	<xsl:choose>
		<!-- ���� -->
		<xsl:when test="$relaToInsured='00'">����</xsl:when>
		<!-- ��ĸ -->
		<xsl:when test="$relaToInsured='01'">��ĸ</xsl:when>
		<!-- ��ż -->
		<xsl:when test="$relaToInsured='02'">��ż</xsl:when>
		<!-- ��Ů -->
		<xsl:when test="$relaToInsured='03'">��Ů</xsl:when>
		<!-- �游��ĸ -->
		<xsl:when test="$relaToInsured='04'">����</xsl:when>
		<!-- ��Ӷ -->
		<xsl:when test="$relaToInsured='05'">��Ӷ</xsl:when>
		<!-- �ֵܽ��� -->
		<xsl:when test="$relaToInsured='12'">�ֵܽ���</xsl:when>
		<!-- �������� -->
		<xsl:when test="$relaToInsured='25'">����</xsl:when>
		<!-- ���� -->
		<xsl:when test="$relaToInsured='27'">����</xsl:when>
		<!-- ���� -->
		<xsl:otherwise>����</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- �Ա� -->
<xsl:template name="tran_sex">
	<xsl:param name="sex" />
	<xsl:choose>
		<xsl:when test="$sex=1">0</xsl:when>	<!-- �� -->
		<xsl:when test="$sex=0">1</xsl:when>	<!-- Ů -->
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- ���ִ��� -->
<xsl:template name="tran_riskcode">
<xsl:param name="riskcode" />
<xsl:choose>
	<!-- �������������˺����� -->
	<!-- 
	<xsl:when test="$riskcode=122015">EL5612</xsl:when>
	 -->
	<xsl:when test="$riskcode='L12049'">EL5612</xsl:when>	
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

</xsl:stylesheet>