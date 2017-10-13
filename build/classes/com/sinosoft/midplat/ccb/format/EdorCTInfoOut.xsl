<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
<Transaction>
	<xsl:copy-of select="TranData/Head" />
	<Transaction_Body>
		<BkRecNum><xsl:value-of select="count(TranData/Body/Detail)" /></BkRecNum>
		<Detail_List>
			<xsl:apply-templates select="TranData/Body/Detail" />
		</Detail_List>
	</Transaction_Body>
</Transaction>
</xsl:template>

<xsl:template match="Detail">
<Detail>
	<PbInsuType>
	<xsl:call-template name="tran_riskcode">
		<xsl:with-param name="riskcode" select="RiskCode" />
	</xsl:call-template>
	</PbInsuType>
	<PbInsuSlipNo><xsl:value-of select="ContNo"/></PbInsuSlipNo>
	<BkActBrch><xsl:value-of select="NodeNo"/></BkActBrch>
	<BkActTeller><xsl:value-of select="TellerNo"/></BkActTeller>
	<PbHoldName><xsl:value-of select="AppntName"/></PbHoldName>
	<LiRcgnName><xsl:value-of select="InsuredName"/></LiRcgnName>
	<BkTotAmt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(SumPrem)"/></BkTotAmt>
	<BkFlag1>G</BkFlag1> <!-- �˱���־��д��Ϊ��G-����ȫ����ԥ���˱��� -->
	<PbSlipNumb><xsl:value-of select="Mult"/></PbSlipNumb>
	<PiAmount><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(EdorCTPrem)"/></PiAmount>
	<BkOthTxCode>02</BkOthTxCode> <!-- �˱��������ͣ�д��Ϊ��02-��ԥ�����˱��� -->
	<PiQdDate><xsl:value-of select="SignDate"/></PiQdDate>
	<Bk8Date1><xsl:value-of select="EdorCTDate"/></Bk8Date1>
</Detail>
</xsl:template>
<!-- ���ִ��� -->
<xsl:template name="tran_riskcode">
<xsl:param name="riskcode" />
<xsl:choose>
	<xsl:when test="$riskcode='122001'">2001</xsl:when>	<!-- ����ƽ�1����ȫ���գ��ֺ��ͣ�A�� -->
	<xsl:when test="$riskcode='122002'">2002</xsl:when>	<!-- ����ƽ�2����ȫ���գ��ֺ��ͣ�A�� -->
	<xsl:when test="$riskcode='122003'">2003</xsl:when>	<!-- ����۱���1����ȫ���գ��ֺ��ͣ�A�� -->
	<xsl:when test="$riskcode='122004'">2004</xsl:when>	<!-- ����ӻƽ�2����ȫ���գ��ֺ��ͣ�A�� -->
	<xsl:when test="$riskcode='122005'">2005</xsl:when>	<!-- ����ƽ�3����ȫ���գ��ֺ��ͣ�A�� -->
	<xsl:when test="$riskcode='122006'">2006</xsl:when>	<!-- ����۱���2����ȫ���գ��ֺ��ͣ�A�� -->
	<xsl:when test="$riskcode='122008'">2008</xsl:when>	<!-- ���������1���������գ������ͣ� -->
	<xsl:when test="$riskcode='122009'">2009</xsl:when>	<!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A�� -->
	<xsl:when test="$riskcode='122010'">2010</xsl:when>	<!-- ����ʢ��3���������գ������ͣ� -->
	<xsl:when test="$riskcode='122035'">2035</xsl:when>	<!-- ����ʢ��9�� -->
	<!-- ����ƷΪ��ϲ�Ʒʱ�������з��͵�������ת��Ϊ��׼���ĺ����մ���Ϊ50002������bak1��Ӧ����ת����׼���Ǳ�׼ʱ�Ὣbak1��ֵ��д��ȥ����˴˴�������122046 -->
	<xsl:when test="$riskcode='50002'">2046</xsl:when>	<!-- 50002: 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�122048-����������������գ������ͣ���� -->
	<!-- 50006: �������Ӯ1������ռƻ�,2014-08-29ͣ�� -->
	<!-- 
	<xsl:when test="$riskcode=50006">2052</xsl:when>
	-->
	<xsl:when test="$riskcode='L12052'">2052</xsl:when>	<!-- �������Ӯ1������� -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

</xsl:stylesheet>