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
	  	 <xsl:if test="Head/Flag='1'">68</xsl:if>
	</ResultCode>
	<ResultInfoDesc><xsl:value-of select ="Head/Desc"/></ResultInfoDesc>
	<!-- ������׳ɹ����ŷ�������Ľ�� -->
	<xsl:if test="Head/Flag='0'">
		<xsl:variable name="MainRisk" select="Body/Risk[RiskCode=MainRiskCode]"/>
		<xsl:variable name="InsuredSex" select="Body/Insured/Sex"/>
		<!-- ������ -->
		<PolNumber><xsl:value-of select ="Body/ContNo"/></PolNumber>
		<!-- ��ѯ����-->
		<Passwd></Passwd>
		<!-- ����״̬ -->
		<PolicyStatus>�б�</PolicyStatus>
		<!-- �ɷ�״̬ -->
		<PayStatus>�ѽ�</PayStatus>
		<!-- ���ִ���-->
		<ProductCode>
			<xsl:call-template name="tran_riskcode">
				<xsl:with-param name="riskcode" select="$MainRisk/MainRiskCode" />
			</xsl:call-template>
		</ProductCode>
		<!-- ��������-->
		<PlanName><xsl:value-of select="$MainRisk/RiskName"/></PlanName>
		<!-- ÿ�ݽɷѱ�׼ -->
		<FeeStd><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/Prem)" /></FeeStd>
		<!-- �ɷ��ۿ���,�����м���ȷ���ݲ���д -->
		<RatioStd></RatioStd>
		<!-- ÿ���ۺϼӷ�,,�����м���ȷ���ݲ���д -->
		<FeeCon></FeeCon>
		<!-- ÿ��ְҵ�ӷ�,,�����м���ȷ���ݲ���д -->
		<FeePro></FeePro>
		<!-- �ɷѷ�ʽ���� -->
		<PaymentModeName>
		    <xsl:call-template name="tran_PayIntvCha">
		        <xsl:with-param name="payIntv"> <xsl:value-of select="$MainRisk/PayIntv" /></xsl:with-param>
		    </xsl:call-template>
	    </PaymentModeName>
		<!-- �ɷ���ʼ����, ��Ӧ������ѯҳ���"��ʼ����"�������б���ʼ���ڡ���Ҫ��ҵ��ͬ��ȷ�� -->
		<PaymentDueDate><xsl:value-of select="$MainRisk/CValiDate" /></PaymentDueDate>
		<!-- 
		<PaymentDueDate><xsl:value-of select="$MainRisk/SignDate" /></PaymentDueDate>
		 -->
		<!-- �ɷ���ֹ����, ��Ӧ������ѯҳ���"��ֹ����"�������б���ֹ���ڣ���Ҫ��ҵ��ͬ��ȷ��-->
		<FinalPaymentDate><xsl:value-of select ="$MainRisk/InsuEndDate"/></FinalPaymentDate>
		<!-- 
		<FinalPaymentDate><xsl:value-of select ="$MainRisk/PayEndDate"/></FinalPaymentDate>
		 -->
		<!-- ������ֹ���� -->
		<TermDate><xsl:value-of select ="$MainRisk/InsuEndDate"/></TermDate>
		
		<!-- �ɷ����� -->
		<PaymentDuration>
			<xsl:choose>
				<xsl:when test="$MainRisk/PayIntv=0">1</xsl:when>
				<xsl:otherwise><xsl:value-of select ="$MainRisk/PayEndYear"/></xsl:otherwise>
			</xsl:choose>
		</PaymentDuration>
		<!-- �ѽ�����, ��Ҫ��ҵ��ͬ��ȷ�� -->
		<Yijiaoshu>1</Yijiaoshu>
		<!-- �ۼƽɷѽ�� -->
		<Pamount><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/Prem)" /></Pamount>
		
		<!-- ��ȡ/������ʽ���� -->
		<BenefitModeName>
		    <xsl:call-template name="tran_GetIntvText">
		        <xsl:with-param name="getIntv"><xsl:value-of select="$MainRisk/GetIntv" /></xsl:with-param>
		    </xsl:call-template>
		</BenefitModeName>
		<!-- ���������ȡ���� -->
		<FirstPayOutDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8($MainRisk/GetStartDate)" /></FirstPayOutDate>
		<!-- Ͷ�������з���λ��Ԫ -->
		<IntialNumberOfUnits><xsl:value-of select ="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/Amnt)"/>Ԫ</IntialNumberOfUnits>
		<!-- Ͷ������ -->
		<AgeTouBao><xsl:value-of select ="$MainRisk/GetYear"/></AgeTouBao>
		<!-- Ͷ������ -->
		<SubmissionDate><xsl:value-of select ="$MainRisk/PolApplyDate"/></SubmissionDate>
		<!-- ������ȡ��ʽ����:11-�ֽ���ȡ 12-�ۻ���Ϣ 13-�ֽɱ��� 14-�������� -->
		<DivTypeName>��</DivTypeName>
		
		<!-- Ԥ������ -->
		<Yujiaoshu>0</Yujiaoshu>
		<!-- Ԥ�ɽ�� -->
		<Yuamount>0.00</Yuamount>
		<!-- Ӧ������ -->
		<Yingqishu>1</Yingqishu>
		<!-- Ӧ�ɽ�� -->
		<Yingamount><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/Prem)" /></Yingamount>
		<!-- Ӧ���ڼ����ڣ��˴�Ϊ���������ڣ�����ǲ���Ӧ���Ǳ��յĽɷ����ڣ���Ϊ������������Ӧ���ڼ����ڡ�Ӧ���ڼ�ֹ��ͬΪ���յĽɷ����ڣ�Ҳ����ǩ�����ڣ��� -->
		<Yingqdate><xsl:value-of select ="$MainRisk/SignDate"/></Yingqdate>
		<!-- 
		<Yingqdate><xsl:value-of select ="$MainRisk/CValiDate"/></Yingqdate>
		 -->
		<!-- Ӧ���ڼ�ֹ�ڣ��˴�Ϊ������ֹ�ڣ�����ǲ���Ӧ���Ǳ��յĽɷ����ڣ���Ϊ������������Ӧ���ڼ����ڡ�Ӧ���ڼ�ֹ��ͬΪ���յĽɷ����ڣ�Ҳ����ǩ�����ڣ��� -->
		<Yingzdate><xsl:value-of select ="$MainRisk/PayEndDate"/></Yingzdate>
		<!-- 
		<Yingzdate><xsl:value-of select ="$MainRisk/InsuEndDate"/></Yingzdate>
		 -->
		<!-- ���� -->
		<BeiYong></BeiYong>
		
		<PolicyHolder>
			<!-- Ͷ����֤������ -->
			<GovtID><xsl:value-of select ="Body/Appnt/IDNo"/></GovtID>
			<!-- Ͷ����֤������ -->
			<GovtIDTC>
				<xsl:call-template name="tran_IDType">
					<xsl:with-param name="idtype" select="Body/Appnt/IDType" />
				</xsl:call-template>
			</GovtIDTC>
			<!-- Ͷ���˳������� -->
			<BirthDate><xsl:value-of select ="Body/Appnt/Birthday"/></BirthDate>
			<!-- Ͷ�������� -->
			<FullName><xsl:value-of select ="Body/Appnt/Name"/></FullName>
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
			<!-- ������֤������ -->
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

		<!--�������Ƿ�Ϊ������־,�˴�д����5������ -->
		<BeneficiaryIndicator>5</BeneficiaryIndicator>
		<!--  
		<xsl:if test="count(Body/Bnf)=0"><BeneficiaryIndicator>��</BeneficiaryIndicator></xsl:if>
		<xsl:if test="count(Body/Bnf)!=0"><BeneficiaryIndicator>��</BeneficiaryIndicator></xsl:if>
		-->
		<!-- �����˸��� -->
		<BeneficiaryCount><xsl:value-of select ="count(Body/Bnf)"/></BeneficiaryCount>
		<xsl:for-each select="Body/Bnf">
		    <!-- �������Լ�� -->
			<Beneficiary>
				<!-- ���䷽ʽ -->
				<BeneficiaryMethodName>
					<xsl:call-template name="tran_BeneficiaryMethodName">
						<xsl:with-param name="beneficiaryMethod" select="Grade" />
					</xsl:call-template>
				</BeneficiaryMethodName>
				<!-- 
				<BeneficiaryMethod>3</BeneficiaryMethod>
				 -->
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
				<RelatedToInsuredRoleName>
					<xsl:call-template name="tran_RelationRoleCodeText">
					    <xsl:with-param name="relaToInsured"><xsl:value-of select="RelaToInsured"/></xsl:with-param>
						<xsl:with-param name="insuredSex"><xsl:value-of select="$InsuredSex"/></xsl:with-param>
						<xsl:with-param name="sex"><xsl:value-of select="Sex"/></xsl:with-param>
					</xsl:call-template>
				</RelatedToInsuredRoleName>
				<!-- 
				<RelatedToInsuredRoleCode>
					<xsl:call-template name="tran_RelationRoleCode">
					    <xsl:with-param name="relaToInsured"><xsl:value-of select="RelaToInsured"/></xsl:with-param>
						<xsl:with-param name="insuredSex"><xsl:value-of select="$InsuredSex"/></xsl:with-param>
						<xsl:with-param name="sex"><xsl:value-of select="Sex"/></xsl:with-param>
					</xsl:call-template>
				</RelatedToInsuredRoleCode>
				 -->
				<InterestPercent><xsl:value-of select="Lot" /></InterestPercent>
		    </Beneficiary>
		</xsl:for-each>
	
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
			<IntialNumberOfUnits>0</IntialNumberOfUnits>
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
		<!-- ��ż -->
		<xsl:when test="$relaToInsured='02'">��ż</xsl:when>
		<!-- ��ĸ -->
		<xsl:when test="$relaToInsured='01'">��ĸ</xsl:when>
		<!-- ��Ů -->
		<xsl:when test="$relaToInsured='03'">��Ů</xsl:when>
		<!-- ���� -->
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

<!-- ���䷽ʽ��1-˳λ  2-����  3-����  4-����  5-����  6-���� -->
<xsl:template name="tran_BeneficiaryMethodName">
	<xsl:param name="beneficiaryMethod" />
	<xsl:choose>
		<xsl:when test="$beneficiaryMethod=1">˳λ</xsl:when>	<!-- �� -->
		<xsl:when test="$beneficiaryMethod=2">����</xsl:when>	<!-- Ů -->
		<xsl:when test="$beneficiaryMethod=3">����</xsl:when>	<!-- Ů -->
		<xsl:when test="$beneficiaryMethod=4">����</xsl:when>	<!-- Ů -->
		<xsl:when test="$beneficiaryMethod=5">����</xsl:when>	<!-- Ů -->
		<xsl:when test="$beneficiaryMethod=6">����</xsl:when>	<!-- Ů -->
		<xsl:otherwise>��</xsl:otherwise>
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