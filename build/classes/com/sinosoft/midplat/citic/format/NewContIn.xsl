<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
<TranData>
	<xsl:apply-templates select="Transaction/Transaction_Header"/>
	
	<Body>
		<xsl:apply-templates select="Transaction/Transaction_Body" />
	</Body>
</TranData>
</xsl:template>

<xsl:template name="Head" match="Transaction_Header">
<Head>
	<TranDate><xsl:value-of select="BkPlatDate"/></TranDate>
	<TranTime><xsl:value-of select="BkPlatTime"/></TranTime>
    <NodeNo><xsl:value-of select="BkBrchNo"/></NodeNo>
	<TellerNo><xsl:value-of select="BkTellerNo"/></TellerNo>
	<TranNo><xsl:value-of select="BkPlatSeqNo"/></TranNo>
	<xsl:copy-of select="../Head/*"/>
	<BankCode><xsl:value-of select="../Head/TranCom/@outcode"/></BankCode>
</Head>
</xsl:template>

<xsl:template name="Body" match="Transaction_Body">
<ProposalPrtNo><xsl:value-of select="PbApplNo" /></ProposalPrtNo>
<ContPrtNo><xsl:value-of select="BkVchNo" /></ContPrtNo>
<PolApplyDate><xsl:value-of select="../Transaction_Header/BkPlatDate" /></PolApplyDate>	<!-- �������в���Ͷ�����ڣ�ȡ�������� -->

<!--������������-->
<AgentComName><xsl:value-of select="BkBranName"/></AgentComName>
<!--����������Ա����-->
<SellerNo><xsl:value-of select="BkRckrNo"/></SellerNo>

<AccName><xsl:value-of select="PbHoldName" /></AccName>	<!-- ȡͶ�������� -->
<AccNo><xsl:value-of select="BkAcctNo1" /></AccNo>
<GetPolMode>2</GetPolMode>

<JobNotice>
	<xsl:call-template name="tran_JobNotice">
		<xsl:with-param name="JobNotice" select="PbRemark1" />
	</xsl:call-template>
</JobNotice> <!-- ְҵ��֪(N/Y) -->
<HealthNotice>
	<xsl:call-template name="tran_healthnotice">
		<xsl:with-param name="healthnotice" select="LiHealthTag" />
	</xsl:call-template>
</HealthNotice> <!-- ������֪(N/Y) -->
<PolicyIndicator>
    <xsl:if test="PiZxbe20=''">N</xsl:if>
    <xsl:if test="PiZxbe20!=''">Y</xsl:if>
</PolicyIndicator>
<!--δ���걻�������Ƿ����������չ�˾Ͷ����ʱ��� Y��N��-->
<InsuredTotalFaceAmount><xsl:value-of select="PiZxbe20*0.01" /></InsuredTotalFaceAmount>
<!--�ۼ�δ������Ͷ����ʱ���-->

<xsl:call-template name="Appnt" />
<xsl:call-template name="Insured" />
<xsl:apply-templates select="Benf_List/Benf_Detail" />

<!-- ��ϲ�Ʒ���� -->
<xsl:variable name="ContPlanMult">
	<xsl:choose>
		<xsl:when test="PbSlipNumb=''">
			<xsl:value-of select="PbSlipNumb" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="format-number(PbSlipNumb,'#')" />
		</xsl:otherwise>
	</xsl:choose>	
</xsl:variable>

<!-- ���� -->
<xsl:variable name="MainRiskCode">
	<xsl:call-template name="tran_riskcode">
		<xsl:with-param name="riskcode" select="PbInsuType" />
	</xsl:call-template>
</xsl:variable>

<!-- ��ϲ�Ʒ���� -->
<xsl:variable name="tContPlanCode">
	<xsl:call-template name="tran_ContPlanCode">
		<xsl:with-param name="contPlanCode" select="PbInsuType" />
	</xsl:call-template>
</xsl:variable>

<!-- ��Ʒ��� -->
<ContPlan>
	<!-- ��Ʒ��ϱ��� -->
	<ContPlanCode><xsl:value-of select="$tContPlanCode" /></ContPlanCode>
	<!-- ��Ʒ��Ϸ��� -->
	<ContPlanMult><xsl:value-of select="$ContPlanMult" /></ContPlanMult>
</ContPlan>

<xsl:variable name="PayIntv"><xsl:apply-templates select="PbPayPeriod" /></xsl:variable>
<xsl:variable name="InsuYearFlag"><xsl:apply-templates select="PbInsuYearFlag" /></xsl:variable>
<xsl:variable name="PayEndYearFlag"><xsl:apply-templates select="PbInsuYearFlag" /></xsl:variable>	<!-- �������и���PbInsuYearFlag��ȡ,���в�����־��Ŀǰ������ɴ��������ܴ˴������  ���ʵ㣺���������Ƿ�ͽ���һ��-->
<xsl:variable name="BonusGetMode"><xsl:apply-templates select="LiBonusGetMode" /></xsl:variable>
<xsl:variable name="PbInsuYearFlag" select="PbInsuYearFlag"></xsl:variable>

<Risk>	<!-- ���� -->
	<RiskCode><xsl:value-of select="$MainRiskCode" /></RiskCode>
	<MainRiskCode><xsl:value-of select="$MainRiskCode" /></MainRiskCode>
	<Amnt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(PbInsuAmt)" /></Amnt>
	<Prem><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(PbInsuExp)" /></Prem>
	<Mult><xsl:value-of select="$ContPlanMult" /></Mult>
    <PayMode></PayMode>
	<PayIntv><xsl:value-of select="$PayIntv" /></PayIntv>
	<InsuYearFlag><xsl:value-of select="$InsuYearFlag" /></InsuYearFlag>
	<InsuYear><xsl:if test="$PbInsuYearFlag=1">106</xsl:if>
	<xsl:if test="$PbInsuYearFlag!=1"><xsl:value-of select="LiInsuPeriod" /></xsl:if>
	</InsuYear>
	<PayEndYearFlag><xsl:value-of select="$PayEndYearFlag" /></PayEndYearFlag>
	<xsl:choose>
		<xsl:when test="$PayIntv=0">	<!-- ���� -->
			<PayEndYear>1000</PayEndYear>
		</xsl:when>
		<xsl:otherwise>	<!-- ���� -->
			<PayEndYear><xsl:value-of select="PbPayAgeTag" /></PayEndYear>
		</xsl:otherwise>
	</xsl:choose>
	<BonusGetMode><xsl:value-of select="$BonusGetMode" /></BonusGetMode>
</Risk>
<xsl:for-each select="Appd_List/Appd_Detail">	<!-- ������ -->
<Risk>
	<RiskCode>
		<xsl:call-template name="tran_riskcode">
			<xsl:with-param name="riskcode" select="LiAppdInsuType" />
		</xsl:call-template>
	</RiskCode>
	<MainRiskCode><xsl:value-of select="$MainRiskCode" /></MainRiskCode>
	<Amnt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(LiAppdInsuAmot)" /></Amnt>
	<Prem><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(LiAppdInsuExp)" /></Prem>
	<Mult><xsl:value-of select="format-number(LiAppdInsuNumb, '#')" /></Mult>
    <PayMode></PayMode>
	<PayIntv><xsl:value-of select="$PayIntv" /></PayIntv>
	<InsuYearFlag><xsl:value-of select="$InsuYearFlag" /></InsuYearFlag>
	<InsuYear>
	<xsl:if test="$PbInsuYearFlag=1">106</xsl:if>
	<xsl:if test="$PbInsuYearFlag!=1"><xsl:value-of select="LiAppdInsuTerm" /></xsl:if>
	</InsuYear>
	<PayEndYearFlag><xsl:value-of select="$PayEndYearFlag" /></PayEndYearFlag>
	<xsl:choose>
		<xsl:when test="$PayIntv=0">	<!-- ���� -->
			<PayEndYear>1000</PayEndYear>
		</xsl:when>
		<xsl:otherwise>	<!-- ���� -->
			<PayEndYear><xsl:value-of select="LiAppdInsuPayTerm" /></PayEndYear>
		</xsl:otherwise>
	</xsl:choose>
	<BonusGetMode><xsl:value-of select="$BonusGetMode" /></BonusGetMode>
</Risk>
</xsl:for-each>
</xsl:template>

<!-- Ͷ���� -->
<xsl:template name="Appnt">
<Appnt>
	<Name><xsl:value-of select="PbHoldName" /></Name>
	<Sex>
		<xsl:call-template name="tran_sex">
			<xsl:with-param name="sex" select="PbHoldSex" />
		</xsl:call-template>
	</Sex>
	<Birthday><xsl:value-of select="PbHoldBirdy" /></Birthday>
	<IDType>
		<xsl:call-template name="tran_idtype">
			<xsl:with-param name="idtype" select="PbHoldIdType" />
		</xsl:call-template>
	</IDType>
	<IDNo><xsl:value-of select="PbHoldId" /></IDNo>
	<IDTypeStartDate><xsl:value-of select="PbIdStartDate" /></IDTypeStartDate > <!-- ֤����Ч���� -->
	<IDTypeEndDate><xsl:value-of select="PbIdEndDate" /></IDTypeEndDate > <!-- ֤����Чֹ�� -->
	<JobCode>
		<xsl:call-template name="tran_jobcode">
			<xsl:with-param name="jobcode" select="PbHoldOccupCode" />
		</xsl:call-template>
	</JobCode>
	
	<!-- Ͷ���������� -->
	<Salary>
		<xsl:choose>
			<xsl:when test="PbIncome=''">
				<xsl:value-of select="PbIncome" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(PbIncome)*10000"/>
			</xsl:otherwise>
		</xsl:choose>
	</Salary>
	<!-- 1.����2.ũ�� -->
	<LiveZone><xsl:value-of select="PbLiveZone"/></LiveZone>
	<!-- ���ղ�������Ƿ��ʺ�Ͷ�� Y=�߱��ʸ�N=���߱� -->
	<RiskAssess><xsl:value-of select="RiskIdentFlag"/></RiskAssess>
	
	<Nationality>
		<xsl:call-template name="tran_Nationality">
		  <xsl:with-param name="nationality">
		 	<xsl:value-of select="PbNationality"/>
	      </xsl:with-param>
	    </xsl:call-template>
	</Nationality> <!-- ���� -->
	<Address><xsl:value-of select="PbHoldHomeAddr" /></Address>
	<ZipCode><xsl:value-of select="PbHoldHomePost" /></ZipCode>
	<Mobile><xsl:value-of select="PbHoldMobl" /></Mobile>
	<Phone><xsl:value-of select="PbHoldHomeTele" /></Phone>
	<Email><xsl:value-of select="PbHoldEmail" /></Email>
	<RelaToInsured>
		<xsl:call-template name="tran_relation">
			<xsl:with-param name="relation" select="PbHoldRcgnRela" />
		</xsl:call-template>
	</RelaToInsured>
</Appnt>
</xsl:template>

<!-- ������ -->
<xsl:template name="Insured">
<Insured>
	<Name><xsl:value-of select="LiRcgnName" /></Name>
	<Sex>
		<xsl:call-template name="tran_sex">
			<xsl:with-param name="sex" select="LiRcgnSex" />
		</xsl:call-template>
	</Sex>
	<Birthday><xsl:value-of select="LiRcgnBirdy" /></Birthday>
	<IDType>
		<xsl:call-template name="tran_idtype">
			<xsl:with-param name="idtype" select="LiRcgnIdType" />
		</xsl:call-template>
	</IDType>
	<IDNo><xsl:value-of select="LiRcgnId" /></IDNo>
	<IDTypeStartDate><xsl:value-of select="LiIdStartDate" /></IDTypeStartDate > <!-- ֤����Ч���� -->
	<IDTypeEndDate><xsl:value-of select="LiIdEndDate" /></IDTypeEndDate > <!-- ֤����Чֹ�� -->
	<JobCode>
		<xsl:call-template name="tran_jobcode">
			<xsl:with-param name="jobcode" select="LiRcgnOccupCode" />
		</xsl:call-template>
	</JobCode>
	<Nationality>
		<xsl:call-template name="tran_Nationality">
		  <xsl:with-param name="nationality">
		 	<xsl:value-of select="LiNationality"/>
	      </xsl:with-param>
	    </xsl:call-template>
	</Nationality> <!-- ���� -->
	<Address><xsl:value-of select="LiRcgnAddr" /></Address>
	<ZipCode><xsl:value-of select="LiRcgnPost" /></ZipCode>
	<Mobile><xsl:value-of select="LiRcgnMobl" /></Mobile>
	<Phone><xsl:value-of select="LiRcgnTele" /></Phone>
	<Email><xsl:value-of select="LiRcgnEmail" /></Email>
</Insured>
</xsl:template>

<!-- ������ -->
<xsl:template name="Bnf" match="Benf_Detail">
<Bnf>
	<Type>1</Type>	<!-- Ĭ��Ϊ��1-��������ˡ� -->
	<Grade><xsl:value-of select="PbBenfSequ" /></Grade>
	<Name><xsl:value-of select="PbBenfName" /></Name>
	<Sex>
		<xsl:call-template name="tran_sex">
			<xsl:with-param name="sex" select="PbBenfSex" />
		</xsl:call-template>
	</Sex>
	<Birthday><xsl:value-of select="PbBenfBirdy" /></Birthday>
	<IDType>
		<xsl:call-template name="tran_idtype">
			<xsl:with-param name="idtype" select="PbBenfIdType" />
		</xsl:call-template>
	</IDType>
	<IDNo><xsl:value-of select="PbBenfId" /></IDNo>
	<Lot><xsl:value-of select="PbBenfProp" /></Lot>
	<RelaToInsured>
		<xsl:call-template name="tran_relation">
			<xsl:with-param name="relation" select="PbBenfHoldRela" />
		</xsl:call-template>
    </RelaToInsured>
</Bnf>
</xsl:template>


<xsl:template name="MainRisk">

</xsl:template>

<!-- ������֪ -->
<xsl:template name="tran_HealthNotice" match="LiHealthTag">
<xsl:choose>
	<xsl:when test=".=1">Y</xsl:when>
	<xsl:otherwise>N</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- �Ա� -->
<xsl:template name="tran_sex">
<xsl:param name="sex" />
<xsl:choose>
	<xsl:when test="$sex=1">0</xsl:when>	<!-- �� -->
	<xsl:when test="$sex=2">1</xsl:when>	<!-- Ů -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ְҵ���ո�֪ -->
<xsl:template name="tran_JobNotice">
<xsl:param name="JobNotice"/>
<xsl:choose>
	<xsl:when test="$JobNotice=0">N</xsl:when>	<!-- ��Σ��ְҵ -->
	<xsl:when test="$JobNotice=1">Y</xsl:when>	<!-- Σ��ְҵ -->
	<xsl:otherwise></xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ֤������ -->
<xsl:template name="tran_idtype">
<xsl:param name="idtype" />
<xsl:choose>
	<xsl:when test="$idtype='A'">0</xsl:when>	<!-- ���֤ -->
	<xsl:when test="$idtype='B'">2</xsl:when>	<!-- ����֤ -->
	<xsl:when test="$idtype='F'">5</xsl:when>	<!-- ���ڱ� -->
	<xsl:when test="$idtype='I'">1</xsl:when>	<!-- ������� ����-->
	<xsl:when test="$idtype='8'">7</xsl:when>	<!-- ̨�����������½ͨ��֤-->
	<xsl:when test="$idtype='G'">6</xsl:when>   <!-- �۰Ļ���֤ -->
	<xsl:otherwise>8</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ְҵ���� -->
<xsl:template name="tran_jobcode">
<xsl:param name="jobcode" />
<xsl:choose>
	<xsl:when test="$jobcode='A'">4030111</xsl:when>	<!-- ���һ��ء���Ⱥ��֯����ҵ����ҵ��λ��Ա -->
	<xsl:when test="$jobcode='B'">2050101</xsl:when>	<!-- ����רҵ������Ա -->
	<xsl:when test="$jobcode='C'">2070109</xsl:when>	<!-- ����ҵ����Ա -->
	<xsl:when test="$jobcode='D'">2080103</xsl:when>	<!-- ����רҵ��Ա -->
	<xsl:when test="$jobcode='E'">2090104</xsl:when>	<!-- ��ѧ��Ա -->
	<xsl:when test="$jobcode='F'">2100106</xsl:when>	<!-- ���ų��漰��ѧ����������Ա -->
	<xsl:when test="$jobcode='G'">2130101</xsl:when>	<!-- �ڽ�ְҵ�� -->
	<xsl:when test="$jobcode='H'">3030101</xsl:when>	<!-- �����͵���ҵ����Ա -->
	<xsl:when test="$jobcode='I'">4010101</xsl:when>	<!-- ��ҵ������ҵ��Ա -->
	<xsl:when test="$jobcode='J'">5010107</xsl:when>	<!-- ũ���֡������桢ˮ��ҵ������Ա -->
	<xsl:when test="$jobcode='K'">6240105</xsl:when>	<!-- ������Ա -->
	<xsl:when test="$jobcode='L'">2020103</xsl:when>	<!-- ��ַ��̽��Ա -->
	<xsl:when test="$jobcode='M'">2020906</xsl:when>	<!-- ����ʩ����Ա -->
	<xsl:when test="$jobcode='N'">6050611</xsl:when>	<!-- �ӹ����졢���鼰������Ա -->
	<xsl:when test="$jobcode='O'">7010103</xsl:when>	<!-- ���� -->
	<xsl:when test="$jobcode='P'">8010101</xsl:when>	<!-- ��ҵ -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ��ϵ -->
<xsl:template name="tran_relation">
<xsl:param name="relation" />
<xsl:choose>
	<xsl:when test="$relation=1">00</xsl:when>	<!-- ���� -->
	<xsl:when test="$relation=2">02</xsl:when>	<!-- ��ż -->
	<xsl:when test="$relation=3">02</xsl:when>	<!-- ��ż -->
	<xsl:when test="$relation=4">01</xsl:when>	<!-- ��ĸ -->
	<xsl:when test="$relation=5">01</xsl:when>	<!-- ��ĸ -->
	<xsl:when test="$relation=6">03</xsl:when>	<!-- ��Ů -->
	<xsl:when test="$relation=7">03</xsl:when>	<!-- ��Ů -->
	<xsl:when test="$relation=30">04</xsl:when>
	<xsl:otherwise>04</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ���ִ��� -->
<xsl:template name="tran_riskcode"><!-- ���ʵ㣬��������û���ṩ���ִ���� -->
<xsl:param name="riskcode" />
<xsl:choose>
	<xsl:when test="$riskcode=122012">L12079</xsl:when>	<!-- ����ʢ��2���������գ������ͣ� -->
	<xsl:when test="$riskcode=122010">L12100</xsl:when>	<!-- ����ʢ��3���������գ������ͣ� -->
	<xsl:when test="$riskcode=122029">L12073</xsl:when>	<!-- ����ʢ��5���������գ������ͣ� -->
	
	<xsl:when test="$riskcode=122009">122009</xsl:when>	<!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A�� -->
	<xsl:when test="$riskcode=122036">122036</xsl:when>	<!-- ����ƽ�6����ȫ���գ��ֺ��ͣ�A�� -->
	<xsl:when test="$riskcode=122035">L12074</xsl:when>	<!-- ����ʢ��9����ȫ���գ������ͣ� -->
	
	<xsl:when test="$riskcode=50006">50006</xsl:when>	<!-- �������Ӯ1������ռƻ� -->
	<xsl:when test="$riskcode='L12080'">L12080</xsl:when>	<!-- ����ʢ��1���������գ������ͣ�-->
	<xsl:when test="$riskcode='L12089'">L12089</xsl:when>	<!-- ����ʢ��1���������գ������ͣ�B��-->
	
	<!-- <xsl:when test="$riskcode='L12087'">L12087</xsl:when> -->	<!-- �����5����ȫ���գ������ͣ�-->
	<!-- <xsl:when test="$riskcode='L12086'">L12086</xsl:when> -->	<!-- �����3����ȫ���գ������ͣ�-->
	
	<!-- PBKINSR-1469 ���Ź��涫��9�� L12088 zx add 20160808 -->
	<!-- <xsl:when test="$riskcode='L12088'">L12088</xsl:when> -->
	<!-- PBKINSR-1458 ���Ź��涫��2�� L12085 zx add 20160808 -->
	<!-- <xsl:when test="$riskcode='L12085'">L12085</xsl:when> -->
	
	<!-- �����6����ȫ���գ��ֺ��ͣ� -->
	<!-- 
	<xsl:when test="$riskcode=122020">122020</xsl:when>
	 -->
	 <!-- ����۱���1����ȫ���գ��ֺ��ͣ�A�� -->
	 <!-- 
	 <xsl:when test="$riskcode=122003">122003</xsl:when>
	  -->
	
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ��ϲ�Ʒ����ת�� -->
<xsl:template name="tran_ContPlanCode">
	<xsl:param name="contPlanCode" />
	<xsl:choose>
		<xsl:when test="$contPlanCode=50006">50006</xsl:when>	<!-- �������Ӯ1������ռƻ� -->
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- �����ĽɷѼ��/Ƶ�� -->
<xsl:template name="tran_payEndYearFlag" match="PbPayPeriod">
<xsl:choose>
    <xsl:when test=".=-1">-1</xsl:when>	  <!-- �����ڽ� -->
    <xsl:when test=".=0">0</xsl:when>	  <!-- ���� -->
	<xsl:when test=".=1">1</xsl:when>	  <!-- �½� -->
	<xsl:when test=".=3">3</xsl:when>	  <!-- ���� -->
	<xsl:when test=".=6">6</xsl:when>	  <!-- ���꽻 -->
	<xsl:when test=".=12">12</xsl:when>	  <!-- �꽻 -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- �������������־ -->
<xsl:template name="tran_insuyearflag" match="PbInsuYearFlag">
<xsl:choose>
	<xsl:when test=".=2">Y</xsl:when>	<!-- ���� -->
	<xsl:when test=".=4">M</xsl:when>	<!-- ���� -->
	<xsl:when test=".=5">D</xsl:when>	<!-- ���� -->
	<xsl:when test=".=1">A</xsl:when>   <!-- ���� -->
	<xsl:when test=".=6">A</xsl:when>   <!-- ��ĳһ���� -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ������ȡ��ʽ -->
<xsl:template name="tran_bonusgetmode" match="LiBonusGetMode">
<xsl:choose>
	<xsl:when test=".=0">2</xsl:when>	<!-- ֱ�Ӹ��� -->
	<xsl:when test=".=1">3</xsl:when>	<!-- �ֽ����� -->
	<xsl:when test=".=2">1</xsl:when>	<!-- �ۼ���Ϣ -->
	<xsl:when test=".=3">5</xsl:when>	<!-- �����  -->
	<xsl:otherwise></xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ����ת�� -->
<xsl:template name="tran_Nationality">
	<xsl:param name="nationality">0</xsl:param>
	<xsl:choose>		
		<xsl:when test="$nationality = '0156'">CHN</xsl:when> <!-- �й�  -->
		<xsl:when test="$nationality = '0344'">CHN</xsl:when> <!-- �й����  -->
		<xsl:when test="$nationality = '0158'">CHN</xsl:when> <!-- �й�̨��  -->
		<xsl:when test="$nationality = '0446'">CHN</xsl:when> <!-- �й�����  -->
		<xsl:when test="$nationality = '0392'">JP</xsl:when>  <!-- �ձ�  -->
		<xsl:when test="$nationality = '0840'">US</xsl:when>  <!-- ����  -->
		<xsl:when test="$nationality = '0643'">RU</xsl:when>  <!-- ����˹  -->
		<xsl:when test="$nationality = '0826'">GB</xsl:when>  <!-- Ӣ��  -->
		<xsl:when test="$nationality = '0250'">FR</xsl:when>  <!-- ����  -->
		<xsl:when test="$nationality = '0276'">DE</xsl:when>  <!-- �¹�  -->
		<xsl:when test="$nationality = '0410'">KR</xsl:when>  <!-- ����  -->
		<xsl:when test="$nationality = '0702'">SG</xsl:when>  <!-- �¼���  -->
		<xsl:when test="$nationality = '0360'">ID</xsl:when>  <!-- ӡ��������  -->
	    <xsl:when test="$nationality = '0356'">IN</xsl:when>  <!-- ӡ��  -->
	    <xsl:when test="$nationality = '0380'">IT</xsl:when>  <!-- �����  -->
		<xsl:when test="$nationality = '0458'">MY</xsl:when>  <!-- ��������  -->
		<xsl:when test="$nationality = '0764'">TH</xsl:when>  <!-- ̩��  -->
		<xsl:otherwise>OTH</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- ������֪  -->
<xsl:template name="tran_healthnotice">
<xsl:param name="healthnotice" />
<xsl:choose>
	<xsl:when test="$healthnotice=0">N</xsl:when>	<!-- �޽�����֪ -->
	<xsl:when test="$healthnotice=1">Y</xsl:when>	<!-- �н�����֪ -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

</xsl:stylesheet>
