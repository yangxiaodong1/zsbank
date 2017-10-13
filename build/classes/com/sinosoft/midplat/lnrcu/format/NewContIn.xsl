<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/TXLife">
<TranData>
	<Head>
	    <TranDate><xsl:value-of select="TransExeDate"/></TranDate>
	    <TranTime><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur6Time()"/></TranTime>
	    <TellerNo><xsl:value-of select="Teller"/></TellerNo>
	    <TranNo><xsl:value-of select="TransNo"/></TranNo>
	    <NodeNo><xsl:value-of select="BankCode"/><xsl:value-of select="Branch"/></NodeNo>
	    <xsl:copy-of select="Head/*"/>
	    <BankCode><xsl:value-of select="Head/TranCom/@outcode"/></BankCode>
     </Head>
	
	<Body>
		<!-- lnrcu Ͷ�����ź͵�֤����һ���� -->
		<ProposalPrtNo><xsl:value-of select="HOAppFormNumber" /></ProposalPrtNo>
		<ContPrtNo><xsl:value-of select="HOAppFormNumber" /></ContPrtNo>
		<PolApplyDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(ApplicationInfo/SubmissionDate)" /></PolApplyDate>
		<!-- 
		<HealthNotice><xsl:value-of select="HealthIndicator" /></HealthNotice>
		 -->
		<HealthNotice>
			<xsl:call-template name="tran_HealthNotice">
				<xsl:with-param name="healthNotice" select="HealthIndicator" />
			</xsl:call-template>
		</HealthNotice>
	    <SocialInsure></SocialInsure>
	    <FreeMedical></FreeMedical>
	    <OtherMedical></OtherMedical>
	    <ContractNo><xsl:value-of select="ContractInfo/LoanContractNo" /></ContractNo>  				        <!--�����ͬ�� -->  <!--������-->
	    <LoanSetComName><xsl:value-of select="PolicyHolder/FullName" /></LoanSetComName>								<!--����Ż������� -->  <!--������-->
	    <LoanMoney><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(IntialNumberOfUnits*10000)" /></LoanMoney>										<!--������,��λ���� -->  <!--������-->
	    <LoanStartDate><xsl:value-of select="ContractInfo/LoanStartDate" /></LoanStartDate>						        <!--��������[YYYY-MM-dd] -->  <!--������-->
	    <LoanEndDate><xsl:value-of select="ContractInfo/LoanEndDate" /></LoanEndDate>								    <!--����ֹ��[YYYY-MM-dd] -->  <!--������-->
	    <LoanName><xsl:value-of select="PolicyHolder/FullName" /></LoanName>												<!--���������� -->
	    <VoucherNo><xsl:value-of select="ContractInfo/LoanInvoiceNo" /></VoucherNo>										<!--����ƾ֤�� -->    	    	
	    <!-- �ɷ��˻����� -->
	    <AccName><xsl:value-of select="PolicyHolder/FullName" /></AccName>
	    <!-- �ɷ��˻��˺� -->
	    <AccNo><xsl:value-of select="Banking/AccountNumber" /></AccNo>
		<!-- Ͷ���� -->
		<xsl:apply-templates select="PolicyHolder" />	
		<!-- ������ -->
		<xsl:apply-templates select="Insured" />
		<!-- ������1 -->
		<xsl:apply-templates select="Beneficiary1" />
		<!-- ������2 -->
		<xsl:apply-templates select="Beneficiary2" />
		<!-- ������3 -->
		<xsl:apply-templates select="Beneficiary3" />
		<!-- ������4 -->
		<xsl:apply-templates select="Beneficiary4" />
		<!-- ������5 -->
		<xsl:apply-templates select="Beneficiary5" />
		<!-- ������6 -->
		<xsl:apply-templates select="Beneficiary6" />


		<xsl:variable name="MainRiskCode">
				<xsl:call-template name="tran_riskcode">
					<xsl:with-param name="riskcode" select="ProductCode" />
				</xsl:call-template>
		</xsl:variable>
		<Risk>
			<RiskCode><xsl:value-of select="$MainRiskCode" /></RiskCode>
			
			<MainRiskCode><xsl:value-of select="$MainRiskCode" /></MainRiskCode>
			<!-- ���д������ı��λ�ǣ���Ԫ�����ı��λ�ǣ��� -->
			<Amnt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(IntialNumberOfUnits*10000)" /></Amnt>
			<Prem>0</Prem>
		    <Mult></Mult>
		    <PayMode>A</PayMode><!-- A:����ͨ����ת�� -->
			<PayIntv><xsl:apply-templates select="PaymentMode" /></PayIntv>
			<!-- Ŀǰ����������գ�ֻ�б�������Ϊһ��Ĳ�Ʒ��û���������� -->
			<InsuYearFlag></InsuYearFlag>
			<!-- ������п��ܴ���Ҳ���ܲ������ɸ��ݱ������ںͱ���ֹ�ڼ��㱣������ -->
			<InsuYear><xsl:value-of select="PaymentDuration" /></InsuYear>
			<!-- �ɷ����� -->
			<PayEndYearFlag>Y</PayEndYearFlag>
			<!-- �ɷ��ڼ䣬����ʱΪ1000 -->
			<PayEndYear>1000</PayEndYear>
			<GetIntv>
				<xsl:call-template name="tran_GetIntv">
				    <xsl:with-param name="getIntv"><xsl:value-of select="BenefitMode" /></xsl:with-param>
				</xsl:call-template>
			</GetIntv>
			<BonusGetMode>
				<xsl:call-template name="tran_BonusGetMode">
				    <xsl:with-param name="divtype"><xsl:value-of select="DivType" /></xsl:with-param>
				</xsl:call-template>
			</BonusGetMode>
		</Risk>
		<!-- ���� -->
		<xsl:apply-templates select="Extension" />

	</Body>
</TranData>
</xsl:template>

<!-- ְҵ���룺���и��ı�����û��Ͷ���˵�ְҵ������Ͷ���˵�ְҵ����ñ����˵�ְҵ��� -->
<xsl:variable name="JobCode">
	<xsl:call-template name="tran_jobCode">
		<xsl:with-param name="jobCode" select="TXLife/Insured/OccupationType" />
	</xsl:call-template>
</xsl:variable>
		
		
<!-- Ͷ���� -->
<xsl:template name="Appnt" match="PolicyHolder">
<Appnt>
	<Name><xsl:value-of select="FullName" /></Name>
	<Sex><xsl:apply-templates select="Gender" /></Sex>
	<Birthday><xsl:value-of select="BirthDate" /></Birthday>
	<IDType><xsl:apply-templates select="GovtIDTC" /></IDType>
	<IDNo><xsl:value-of select="GovtID" /></IDNo>
	
	<!-- ְҵ���ת���� -->	
	<!---->
	<JobCode><xsl:value-of select="$JobCode" /></JobCode>
	
	<Nationality></Nationality>
	<Address><xsl:value-of	select="Line1" /></Address>
    <ZipCode><xsl:value-of	select="Zip" /></ZipCode>
    <Mobile><xsl:value-of select="DialNumber" /></Mobile>
    <Phone><xsl:value-of select="DialNumber" /></Phone>
    <Email></Email>
    <RelaToInsured><xsl:apply-templates select="RelatedToInsuredRoleCode" /></RelaToInsured>
</Appnt>
</xsl:template>

<!-- ������ -->
<xsl:template name="Insured" match="Insured">
<Insured>
	<Name><xsl:value-of select="FullName" /></Name>
	<Sex><xsl:apply-templates select="Gender" /></Sex>
	<Birthday><xsl:value-of select="BirthDate" /></Birthday>
	<IDType><xsl:apply-templates select="GovtIDTC" /></IDType>
	<IDNo><xsl:value-of select="GovtID" /></IDNo>
	<!-- ְҵ���ת���� -->	
	<JobCode><xsl:value-of select="$JobCode" /></JobCode>
	
	<Nationality></Nationality>
	<Address><xsl:value-of	select="Line1" /></Address>
    <ZipCode><xsl:value-of	select="Zip" /></ZipCode>
    <Mobile><xsl:value-of select="DialNumber" /></Mobile>
    <Phone><xsl:value-of select="DialNumber" /></Phone>
    <Email></Email>
</Insured>
</xsl:template>

<!-- ������1 -->
<xsl:template name="Bnf1" match="Beneficiary1">
<Bnf>
	<Type>1</Type>	<!-- Ĭ��Ϊ��1-���������ˡ� -->
	<Grade><xsl:value-of select="BeneficiaryMethod" /></Grade><!-- �����˼��� -->
	<Name><xsl:value-of select="FullName" /></Name>
	<Sex><xsl:apply-templates select="Gender" /></Sex>
	<Birthday><xsl:value-of select="BirthDate" /></Birthday>
	<IDType><xsl:apply-templates select="GovtIDTC" /></IDType>
	<IDNo><xsl:value-of select="GovtID" /></IDNo>
	<Lot><xsl:value-of select="InterestPercent" /></Lot>
	<!--
	<Lot><xsl:value-of select="number(InterestPercent) div 100" /></Lot> 
	��Ҫת��010000-100 -->	
	<RelaToInsured><xsl:apply-templates select="RelatedToInsuredRoleCode" /></RelaToInsured>
</Bnf>
</xsl:template>

<!-- ������2 -->
<xsl:template name="Bnf2" match="Beneficiary2">
<Bnf>
	<Type>1</Type>	<!-- Ĭ��Ϊ��1-���������ˡ� -->
	<Grade><xsl:value-of select="BeneficiaryMethod" /></Grade><!-- �����˼��� -->
	<Name><xsl:value-of select="FullName" /></Name>
	<Sex><xsl:apply-templates select="Gender" /></Sex>
	<Birthday><xsl:value-of select="BirthDate" /></Birthday>
	<IDType><xsl:apply-templates select="GovtIDTC" /></IDType>
	<IDNo><xsl:value-of select="GovtID" /></IDNo>
	<Lot><xsl:value-of select="InterestPercent" /></Lot>
	<!--
	<Lot><xsl:value-of select="number(InterestPercent) div 100" /></Lot> 
	��Ҫת��010000-100 -->	
	<RelaToInsured><xsl:apply-templates select="RelatedToInsuredRoleCode" /></RelaToInsured>
</Bnf>
</xsl:template>

<!-- ������3 -->
<xsl:template name="Bnf3" match="Beneficiary3">
<Bnf>
	<Type>1</Type>	<!-- Ĭ��Ϊ��1-���������ˡ� -->
	<Grade><xsl:value-of select="BeneficiaryMethod" /></Grade><!-- �����˼��� -->
	<Name><xsl:value-of select="FullName" /></Name>
	<Sex><xsl:apply-templates select="Gender" /></Sex>
	<Birthday><xsl:value-of select="BirthDate" /></Birthday>
	<IDType><xsl:apply-templates select="GovtIDTC" /></IDType>
	<IDNo><xsl:value-of select="GovtID" /></IDNo>
	<Lot><xsl:value-of select="InterestPercent" /></Lot>
	<!--
	<Lot><xsl:value-of select="number(InterestPercent) div 100" /></Lot> 
	��Ҫת��010000-100 -->	
	<RelaToInsured><xsl:apply-templates select="RelatedToInsuredRoleCode" /></RelaToInsured>
</Bnf>
</xsl:template>

<!-- ������4 -->
<xsl:template name="Bnf4" match="Beneficiary4">
<Bnf>
	<Type>1</Type>	<!-- Ĭ��Ϊ��1-���������ˡ� -->
	<Grade><xsl:value-of select="BeneficiaryMethod" /></Grade><!-- �����˼��� -->
	<Name><xsl:value-of select="FullName" /></Name>
	<Sex><xsl:apply-templates select="Gender" /></Sex>
	<Birthday><xsl:value-of select="BirthDate" /></Birthday>
	<IDType><xsl:apply-templates select="GovtIDTC" /></IDType>
	<IDNo><xsl:value-of select="GovtID" /></IDNo>
	<Lot><xsl:value-of select="InterestPercent" /></Lot>
	<!--
	<Lot><xsl:value-of select="number(InterestPercent) div 100" /></Lot> 
	��Ҫת��010000-100 -->	
	<RelaToInsured><xsl:apply-templates select="RelatedToInsuredRoleCode" /></RelaToInsured>
</Bnf>
</xsl:template>

<!-- ������5 -->
<xsl:template name="Bnf5" match="Beneficiary5">
<Bnf>
	<Type>1</Type>	<!-- Ĭ��Ϊ��1-���������ˡ� -->
	<Grade><xsl:value-of select="BeneficiaryMethod" /></Grade><!-- �����˼��� -->
	<Name><xsl:value-of select="FullName" /></Name>
	<Sex><xsl:apply-templates select="Gender" /></Sex>
	<Birthday><xsl:value-of select="BirthDate" /></Birthday>
	<IDType><xsl:apply-templates select="GovtIDTC" /></IDType>
	<IDNo><xsl:value-of select="GovtID" /></IDNo>
	<Lot><xsl:value-of select="InterestPercent" /></Lot>
	<!--
	<Lot><xsl:value-of select="number(InterestPercent) div 100" /></Lot> 
	��Ҫת��010000-100 -->	
	<RelaToInsured><xsl:apply-templates select="RelatedToInsuredRoleCode" /></RelaToInsured>
</Bnf>
</xsl:template>
<xsl:template name="Bnf6" match="Beneficiary6">
<Bnf>
	<Type>1</Type>	<!-- Ĭ��Ϊ��1-���������ˡ� -->
	<Grade><xsl:value-of select="BeneficiaryMethod" /></Grade><!-- �����˼��� -->
	<Name><xsl:value-of select="FullName" /></Name>
	<Sex><xsl:apply-templates select="Gender" /></Sex>
	<Birthday><xsl:value-of select="BirthDate" /></Birthday>
	<IDType><xsl:apply-templates select="GovtIDTC" /></IDType>
	<IDNo><xsl:value-of select="GovtID" /></IDNo>
	<Lot><xsl:value-of select="InterestPercent" /></Lot>
	<!--
	<Lot><xsl:value-of select="number(InterestPercent) div 100" /></Lot> 
	��Ҫת��010000-100 -->	
	<RelaToInsured><xsl:apply-templates select="RelatedToInsuredRoleCode" /></RelaToInsured>
</Bnf>
</xsl:template>


<!-- ����,������ -->
<xsl:template name="Risk" match="Extension">
<Risk>
	<RiskCode><xsl:value-of select="../ProductCode" /></RiskCode>    <!-- ��Ʒ���� -->
	<MainRiskCode><xsl:value-of select="../ProductCode" /></MainRiskCode>
	<Amnt></Amnt>
	<Prem>0</Prem>
    <Mult></Mult>
    <PayMode>7</PayMode>
	<PayIntv><xsl:apply-templates select="../PaymentMode" /></PayIntv>
	<!-- Ŀǰ����������գ�ֻ�б�������Ϊһ��Ĳ�Ʒ��û���������� -->
	<InsuYearFlag>Y</InsuYearFlag>
	<InsuYear>1</InsuYear>
	<PayEndYearFlag>Y</PayEndYearFlag>
	<PayEndYear><xsl:value-of select="../PaymentDuration" /></PayEndYear>
	<GetIntv>
		<xsl:call-template name="tran_GetIntv">
		    <xsl:with-param name="getIntv"><xsl:value-of select="../BenefitMode" /></xsl:with-param>
		</xsl:call-template>
	</GetIntv>
	<BonusGetMode>
		<xsl:call-template name="tran_BonusGetMode">
		    <xsl:with-param name="divtype"><xsl:value-of select="../DivType" /></xsl:with-param>
		</xsl:call-template>
	</BonusGetMode>
</Risk>
<!-- ����,������ -->

</xsl:template>


<!-- ���ִ��� -->
<xsl:template name="tran_riskcode">
<xsl:param name="riskcode" />
<xsl:choose>
	<!-- �������������˺����� -->
	<!-- 
	<xsl:when test="$riskcode='EL5612'">122015</xsl:when>
	 -->
	<xsl:when test="$riskcode='EL5612'">L12049</xsl:when>
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ְҵ���룺���и��ı�����û��Ͷ���˵�ְҵ������Ͷ���˵�ְҵ����ñ����˵�ְҵ���Ŀǰ���з�û��¼��ְҵ�����¼������ԻᴫĬ��ֵ:9999999 -->
<xsl:template name="tran_jobCode">
	<xsl:param name="jobCode" />
	<xsl:choose>
		<xsl:when test="$jobCode=9999999">000000</xsl:when>	<!-- ���д���Ĭ�ϱ����ǣ��ҷ�ת��Ϊ6��0 -->
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- ������֪�����з���Y��1��-������N��0��-�����������չ�˾��Y-��������N-���� -->
<xsl:template name="tran_HealthNotice">
	<xsl:param name="healthNotice" />
	<xsl:choose>
		<xsl:when test="$healthNotice='1'">N</xsl:when>
		<xsl:when test="$healthNotice='0'">Y</xsl:when>
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- �Ա� -->
<xsl:template name="tran_sex" match="Gender">
<xsl:choose>
	<xsl:when test=".=1">0</xsl:when>	<!-- �� -->
	<xsl:when test=".=0">1</xsl:when>	<!-- Ů -->
	<xsl:otherwise></xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ֤������
    ����:1���֤   4����   8����֤  10����    11����֤    7���ڲ�    99����       2ʧҵ֤��3����֤��5ǩ֤��6ѧ��֤��9��������֤��
    ����:0���֤   1����   2����֤   3:����   4:����֤��  5:���ڲ�   8:���� 9:�쳣���֤
 -->
<xsl:template name="tran_idtype" match="GovtIDTC">
<xsl:choose>
	<xsl:when test=".=1">0</xsl:when>	<!-- ���֤ -->
	<xsl:when test=".=4">1</xsl:when>	<!-- ���� -->
	<xsl:when test=".=8">2</xsl:when>	<!-- ����֤ -->
	<xsl:when test=".=10">3</xsl:when>	<!-- ʿ��֤ -->
	<xsl:when test=".=11">4</xsl:when>	<!-- ��ʱ���֤ -->
	<xsl:when test=".=7">5</xsl:when>	<!-- ���ڱ�  -->
	<xsl:otherwise>8</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ��ϵ
���У� 301���� 302���� 303ĸŮ 304��Ů 305���� 306ĸ�� 307�ֵ� 308���� 309���� 310���� 311���� 312��Ӷ 313ֶ��
 314ֶŮ 315��� 316���� 317����Ů 318���� 319���� 320��ϱ 321��ɩ  323�� 324���� 325���� 399����
 
���ģ�00���� ��01��ĸ��,02��ż��03��Ů,04����,05��Ӷ,06����,07����,08����
      0 �У�1Ů
 -->
<xsl:template name="tran_relation" match="RelatedToInsuredRoleCode">
<xsl:choose>
	<xsl:when test=".=301">00</xsl:when>	<!-- ���� -->
	<xsl:when test=".=303">01</xsl:when>	<!-- ��ĸ -->
	<xsl:when test=".=304">01</xsl:when>	<!-- ��ĸ -->
	<xsl:when test=".=310">02</xsl:when>	<!-- ��ż -->
	<xsl:when test=".=306">01</xsl:when>	<!-- ��ĸ -->
	<xsl:when test=".=309">01</xsl:when>	<!-- ��ĸ -->
	<xsl:when test=".=312">05</xsl:when>	<!-- ��Ӷ -->
	<xsl:when test=".=325">06</xsl:when>	<!-- ���� -->
	<!-- ������ũ�����һ������Ϊ�����Ż���������Ͷ���˹�ϵֻ���ǣ�399-���� -->
	<xsl:when test=".=399">04</xsl:when>	<!-- ���� -->
	<xsl:otherwise>04</xsl:otherwise>		<!-- ���� -->
</xsl:choose>
</xsl:template>

<!-- �ɷ�Ƶ�� -->
<xsl:template name="tran_payintv" match="PaymentMode">
<xsl:choose>
	<xsl:when test=".=13">12</xsl:when>	<!-- ��� -->
	<xsl:when test=".=10">1</xsl:when>	<!-- �½� -->
	<xsl:when test=".=12">6</xsl:when>	<!-- ����� -->
	<xsl:when test=".=11">3</xsl:when>	<!-- ���� -->
	<xsl:when test=".=01">0</xsl:when>	<!-- ���� -->
	<xsl:when test=".=02">-1</xsl:when>	<!-- ������ -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- �ս����ڱ�־��ת�� -->
<xsl:template name="tran_payendyearflag" match="PaymentDurationMode">
<xsl:choose>
	<xsl:when test=".=1">A</xsl:when>	<!-- ����ĳȷ������ -->
	<xsl:when test=".=2">Y</xsl:when>	<!-- �� -->
	<xsl:when test=".=3">M</xsl:when>	<!-- �� -->
	<xsl:when test=".=4">D</xsl:when>	<!-- �� -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- �����������ڱ�־ -->
<xsl:template name="tran_InsuYearFlag" match="DurationMode">
<xsl:choose>
	<xsl:when test=".=1">A</xsl:when>	<!-- ����ĳȷ������ -->
	<xsl:when test=".=2">Y</xsl:when>	<!-- �걣 -->
	<xsl:when test=".=3">M</xsl:when>	<!-- �±� -->
	<xsl:when test=".=4">D</xsl:when>	<!-- �ձ� -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ������ȡ��ʽ��ת�������з���11-�ֽ���ȡ 12-�ۻ���Ϣ 13-�ֽɱ��� 14-������� -->
<xsl:template name="tran_BonusGetMode">
<xsl:param name="divtype" />
<xsl:choose>
	<xsl:when test="$divtype=12">1</xsl:when>	<!-- �ۻ���Ϣ -->
	<xsl:when test="$divtype=13">3</xsl:when>	<!-- �ֽ����� -->
	<xsl:when test="$divtype=11">4</xsl:when>	<!-- �ֽ���ȡ -->
	<xsl:when test="$divtype=14">5</xsl:when>	<!-- ������� -->
	<xsl:otherwise></xsl:otherwise>
</xsl:choose>
</xsl:template>



<!--������ʽ
1-һ�θ��� 2-�����  3-�������  4-������  5-�¸���  6-����
0-����     12����    6������     3����     1����     36������  120ʮ����
 -->
<xsl:template name="tran_GetIntv">
    <xsl:param name="getIntv"/>
    <xsl:choose>
	    <xsl:when test="$getIntv='1'">0</xsl:when>
	    <xsl:when test="$getIntv='2'">12</xsl:when>
	    <xsl:when test="$getIntv='3'">6</xsl:when>
	    <xsl:when test="$getIntv='4'">3</xsl:when>
	    <xsl:when test="$getIntv='5'">1</xsl:when>
	    <xsl:otherwise>6</xsl:otherwise>
    </xsl:choose>
</xsl:template>	
<xsl:template name="tran_GetIntvText">
    <xsl:param name="getIntv"/>
    <xsl:choose>
	    <xsl:when test="$getIntv='1'">һ�θ���</xsl:when>
	    <xsl:when test="$getIntv='2'">�����</xsl:when>
	    <xsl:when test="$getIntv='3'">�������</xsl:when>
	    <xsl:when test="$getIntv='4'">������</xsl:when>
	    <xsl:when test="$getIntv='5'">�¸���</xsl:when>
	    <xsl:otherwise>����</xsl:otherwise>
    </xsl:choose>
</xsl:template>


</xsl:stylesheet>
