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

	<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]" />
	<Cvr_ID>
		<xsl:call-template name="tran_Riskcode">
			<xsl:with-param name="riskcode" select="$MainRisk/MainRiskCode" />
		</xsl:call-template>
	</Cvr_ID>
	<!-- �������� -->
	<InsPolcy_No><xsl:value-of select="ContNo" /></InsPolcy_No>
	<!-- PDF�ļ����� -->
	<Rvl_Rcrd_Num_1>0</Rvl_Rcrd_Num_1>
	<Pdf_Prmpt_List>
		<Pdf_Prmpt_Detail>
			<!-- ��ʾ��Ϣ���� -->
			<Prmpt_Inf_Dsc></Prmpt_Inf_Dsc>
		</Pdf_Prmpt_Detail>
	</Pdf_Prmpt_List>
	
	<!-- ������ֽ��ֵ��ʾ2ҳ��û���ֽ���ʾ1ҳ -->
	<!-- ����ҳ��,���ش����в���Ҫ���Ƿ����ֽ�ҳ�����Դ˴����ر���ҳ��Ϊ1  -->
	<Rvl_Rcrd_Num>1</Rvl_Rcrd_Num>
	
	<!-- 
	<xsl:if test="$MainRisk/CashValues/CashValue != ''">
		<Rvl_Rcrd_Num>2</Rvl_Rcrd_Num>
	</xsl:if>
	<xsl:if test="count($MainRisk/CashValues/CashValue) = 0">
		<Rvl_Rcrd_Num>1</Rvl_Rcrd_Num>
	</xsl:if>
	 -->
</xsl:template>


<!-- ����ת�� -->
<xsl:template name="tran_Riskcode">
	<xsl:param name="riskcode" />
	<xsl:choose>
		<xsl:when test="$riskcode='122001'">122001</xsl:when>	<!-- ����ƽ�1����ȫ���գ��ֺ��ͣ�A�� -->
		<xsl:when test="$riskcode='122002'">122002</xsl:when>	<!-- ����ƽ�2����ȫ���գ��ֺ��ͣ�A�� -->
		<xsl:when test="$riskcode='122003'">122003</xsl:when>	<!-- ����۱���1����ȫ���գ��ֺ��ͣ�A�� -->
		<xsl:when test="$riskcode='122004'">122004</xsl:when>	<!-- ����ӻƽ�2����ȫ���գ��ֺ��ͣ�A�� -->
		<xsl:when test="$riskcode='122005'">122005</xsl:when>	<!-- ����ƽ�3����ȫ���գ��ֺ��ͣ�A�� -->
		<xsl:when test="$riskcode='122006'">122006</xsl:when>	<!-- ����۱���2����ȫ���գ��ֺ��ͣ�A�� -->
		<xsl:when test="$riskcode='122008'">122008</xsl:when>	<!-- ���������1���������գ������ͣ� -->
		<xsl:when test="$riskcode='122009'">122009</xsl:when>	<!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A�� -->
		<xsl:when test="$riskcode='L12079'">L12079</xsl:when>	<!-- ����ʢ��2���������գ������ͣ� -->
		<xsl:when test="$riskcode='L12078'">122010</xsl:when>	<!-- ����ʢ��3���������գ������ͣ� -->
		<xsl:when test="$riskcode='L12100'">122010</xsl:when>	<!-- ����ʢ��3���������գ������ͣ� -->
		<xsl:when test="$riskcode='L12089'">L12089</xsl:when>	<!-- ����ʢ��1�������գ������ͣ�B�� -->
		<xsl:when test="$riskcode='L12074'">122035</xsl:when>	<!-- ����ʢ��9����ȫ���գ������ͣ� -->
		<xsl:when test="$riskcode='L12052'">L12052</xsl:when>	<!-- �������Ӯ1������� -->
		<xsl:when test="$riskcode='122046'">50002</xsl:when>	<!-- ������Ӯ���ռƻ� -->
		<!-- add by duanjz 2015-7-6 PBKINSR-694 ���Ӱ���5�Ų�Ʒת�� begin -->
		<xsl:when test="$riskcode='L12070'">50012</xsl:when>	<!-- ����ٰ���5�ű��ռƻ� -->
		<!-- add by duanjz 2015-7-6 PBKINSR-694 ���Ӱ���5�Ų�Ʒת�� end -->
		<xsl:when test="$riskcode='L12087'">L12087</xsl:when>	<!-- �����5����ȫ���գ������ͣ� -->
		<xsl:when test="$riskcode='L12085'">L12085</xsl:when>	<!-- �����2����ȫ���գ������ͣ� -->
		<xsl:when test="$riskcode='L12086'">L12086</xsl:when>	<!-- �����3����ȫ���գ������ͣ� -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>


</xsl:stylesheet>

