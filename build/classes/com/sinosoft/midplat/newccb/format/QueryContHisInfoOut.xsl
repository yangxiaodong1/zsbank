<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
<TX>
	<xsl:copy-of select="TranData/Head" />
	<TX_BODY>
		<ENTITY>
			<APP_ENTITY>
				<xsl:apply-templates select="TranData/Body"/>
			</APP_ENTITY>
		</ENTITY>
	</TX_BODY>
</TX>
</xsl:template>


<xsl:template match="Body">

	<!-- ���ڽɷѱ��� -->
	<Rnew_PyF_Dnum><xsl:value-of select="RenewInfos/Count"/></Rnew_PyF_Dnum>
	<!-- ���ڽɷ���Ϣѭ�� -->
	<InsPyF_List>
		<xsl:for-each select="RenewInfos/RenewInfo">
			<InsPyF_Detail>
				<Ins_PyF_Dt><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(PayDate)"/></Ins_PyF_Dt>
				<!-- ��λ��Ԫ -->
				<Ins_PyF_Amt><xsl:value-of select="PayMoney"/></Ins_PyF_Amt>
			</InsPyF_Detail>		
		</xsl:for-each>
	</InsPyF_List>
	<!-- �ֺ���� -->
	<Dvdn_Cnt><xsl:value-of select="BonusInfos/Count"/></Dvdn_Cnt>
	<!-- �ֺ���Ϣѭ�� -->
	<XtraDvdn_List>
		<xsl:for-each select="BonusInfos/BonusInfo">
			<XtraDvdn_Detail>
			<!-- ����ʵ�ʷ������� -->
			<XtraDvdn_Act_Dstr_Dt><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(GetDate)"/></XtraDvdn_Act_Dstr_Dt>
			<!-- ��������ʽ���� -->
			<XtraDvdn_Pcsg_MtdCd><xsl:apply-templates select="GetMode" /></XtraDvdn_Pcsg_MtdCd>
			<!-- ���ں������, ��λ��Ԫ -->
			<CrnPrd_XtDvdAmt><xsl:value-of select="BonusMoney"/></CrnPrd_XtDvdAmt>
			<!-- ���˺������ -->
			<ATEndOBns_Amt></ATEndOBns_Amt>
			<!-- �ۻ�������� -->
			<Acm_XtDvdAmt></Acm_XtDvdAmt>
		</XtraDvdn_Detail>
		</xsl:for-each>
	</XtraDvdn_List>
	<!-- ��ȫҵ����� -->
	<PsvBsn_Dnum><xsl:value-of select="EdorInfos/Count"/></PsvBsn_Dnum>
	<!-- ��ȫ��Ϣѭ�� -->
	<Prsrvt_List>
		<xsl:for-each select="EdorInfos/EdorInfo">
			<Prsrvt_Detail>
				<!-- ��ȫ���� -->
				<Prsrvt_Dt><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(EdorValiDate)"/></Prsrvt_Dt>
				<!-- ��ȫ�䶯�������� -->
				<Prsrvt_Chg_Itm_Dsc><xsl:value-of select="EdorDes"/></Prsrvt_Chg_Itm_Dsc>
			</Prsrvt_Detail>
		</xsl:for-each>
	</Prsrvt_List>
	
	<!-- ������Ч��Ч���� -->
	<InsPolcyEff_Rinst_Cnt><xsl:value-of select="AvaiInfos/Count"/></InsPolcyEff_Rinst_Cnt>
	<!-- ʧЧ/��Ч��Ϣѭ�� -->
	<InsPolcyDt_Lis>
		<xsl:for-each select="AvaiInfos/AvaiInfo">
			<!-- ����ʧЧ���� -->
			<InsPolcy_ExpDt><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(ValiDate)"/></InsPolcy_ExpDt>
			<!-- ������Ч���� -->
			<InsPolcy_Rinst_Dt><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(InValiDate)"/></InsPolcy_Rinst_Dt>
			<!-- �����պ�Լ״̬���� -->
			<AcIsAR_StCd><xsl:apply-templates select="state" /></AcIsAR_StCd>
		</xsl:for-each>
	</InsPolcyDt_Lis>
	
	<!-- ��������䶯���� -->
	<InsPolcy_Cvr_Chg_Cnt><xsl:value-of select="AmntChgInfos/Count"/></InsPolcy_Cvr_Chg_Cnt>
	<!-- ����/����/�˱���Ϣ -->
	<InsPolcyAply_List>
		<xsl:for-each select="AmntChgInfos/BonusInfo">
			<InsPolcyAply_Detail>
				<!-- ��������ҵ�������� -->
				<InsPolcyAplyBsnCgyCd><xsl:apply-templates select="code" /></InsPolcyAplyBsnCgyCd>
				<!-- ҵ���������� -->
				<Bapl_Dt><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(ValiDate)"/></Bapl_Dt>
			</InsPolcyAply_Detail>
		</xsl:for-each>
	</InsPolcyAply_List>
	
	<!-- �����¼�� -->
	<SetlOfClms_Rcrd_Num><xsl:value-of select="ClaimInfos/Count"/></SetlOfClms_Rcrd_Num>
	<!-- ������Ϣѭ����ʼ -->
	<SetlOfClms_List>
		<xsl:for-each select="ClaimInfos/ClaimInfo">
			<SetlOfClms_Detail>
				<!-- �����¼���� -->
				<SetlOfClms_Rcrd_Dt><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(ClaimDate)"/></SetlOfClms_Rcrd_Dt>
				<!-- ������ -->
				<SetlOfClms_Amt><xsl:value-of select="ClaimMoney"/></SetlOfClms_Amt>
			</SetlOfClms_Detail>
		</xsl:for-each>
	</SetlOfClms_List>
	
	<!-- ��ֵ���� -->
	<NetVal_Dt><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(CashInfo/CashDate)"/></NetVal_Dt>
	<!-- �������ֽ�ֵ -->
	<AgIns_Cash_NetVal><xsl:value-of select="(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(CashInfo/CashValue*100))"/></AgIns_Cash_NetVal>
</xsl:template>

<!-- ������ȡ��ʽ -->
<xsl:template name="tran_GetMode" match="GetMode">
	<xsl:choose>
		<xsl:when test=".=1">2</xsl:when><!-- �ۻ���Ϣ -->
		<xsl:when test=".=2">0</xsl:when><!-- ��ȡ�ֽ� -->
		<xsl:when test=".=3">1</xsl:when><!-- �ֽɱ��� -->
		<xsl:when test=".=5">3</xsl:when><!-- ����� -->
		<xsl:otherwise></xsl:otherwise><!-- ���� -->
	</xsl:choose>
</xsl:template>

<!-- �����պ�Լ״̬���� -->
<xsl:template name="tran_state" match="state">
	<xsl:choose>
		<xsl:when test=".=0">76034</xsl:when><!-- ʧЧ -->
		<xsl:when test=".=1">76035</xsl:when><!-- ��Ч -->
	</xsl:choose>
</xsl:template>

<!-- ��������ҵ�������� -->
<xsl:template name="tran_code" match="code">
	<xsl:choose>
		<xsl:when test=".=0">2</xsl:when><!-- ���� -->
		<xsl:when test=".=1">3</xsl:when><!-- ���� -->
		<xsl:when test=".=2">4</xsl:when><!-- �˱� -->
	</xsl:choose>
</xsl:template>
</xsl:stylesheet>

