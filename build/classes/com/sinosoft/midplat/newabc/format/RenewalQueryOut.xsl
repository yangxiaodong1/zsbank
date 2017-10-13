<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
	
	<xsl:template match="/TranData">
		<TranData>
			<xsl:copy-of select="Head" />
			<xsl:apply-templates select="Body" />
		</TranData>
	</xsl:template>
	
	<!--��������Ϣ-->
	<xsl:template match="Body">
		<App>
			<Ret>
				<!--Ͷ������Ϣ-->
				<Appl>
					<!--Ͷ��������-->
					<Name><xsl:value-of select="PubContInfo/AppntName" /></Name>
					<!--֤������-->
					<IDKind><xsl:apply-templates select="PubContInfo/AppntIDType" /></IDKind>
					<!--֤������-->
					<IDCode><xsl:value-of select="PubContInfo/AppntIDNo" /></IDCode>
				</Appl>
				<!--Ӧ������-->
				<DuePeriod><xsl:value-of select="EdorXQInfo/PaymentTimes" /></DuePeriod>
				<!--Ӧ������-->
				<DueDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(EdorXQInfo/FinEffDate)" /></DueDate>
				<!--Ӧ�ɽ��-->
				<DueAmt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(EdorXQInfo/FinActivityGrossAmt)" /></DueAmt>
				<!--���չ�˾�����ִ���-->
				<RiskCode><xsl:apply-templates select="PubContInfo/MainRiskCode"  mode="risk"/></RiskCode>
				<!--������-->
				<PolicyNo><xsl:value-of select="PubContInfo/ContNo" /></PolicyNo>
			</Ret>
		</App>
	</xsl:template>

    <!-- ֤������ -->
	<xsl:template  match="AppntIDType">
		<xsl:choose>
			<xsl:when test=".=0">110001</xsl:when><!-- ���֤ -->
			<xsl:when test=".=1">110023</xsl:when><!-- ���� -->
			<xsl:when test=".=2">110027</xsl:when><!-- ����֤ -->
			<xsl:when test=".=3">119999</xsl:when><!-- ����  -->
			<xsl:when test=".=4">119999</xsl:when><!-- ����֤��  -->
			<xsl:when test=".=5">110019</xsl:when><!-- �۰�ͨ��֤  -->
			<xsl:when test=".=6">110003</xsl:when><!-- ��ʱ���֤  -->
			<xsl:when test=".=7">110033</xsl:when><!-- ʿ��֤  -->
			<xsl:when test=".=8">110021</xsl:when><!-- ̨��֤  -->
			<xsl:when test=".=9">110005</xsl:when><!-- ���ڱ�  -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ���ִ��� -->
	<xsl:template  match="MainRiskCode"  mode="risk">
		<xsl:choose>
			<!-- FIXME ����ط�����ʱҪ���⿴���ķ��ص�50001����500015��Ӧ����������ʲô? -->
			<xsl:when test=".='122046'">122046</xsl:when><!-- ������Ӯ1���ײ� -->
			
			<xsl:when test=".='50015'">50015</xsl:when><!-- ������Ӯ���ռƻ� -->
			<xsl:when test=".='L12079'">L12079</xsl:when><!-- ����ʢ��2���������գ������ͣ�  -->
			<xsl:when test=".='L12078'">L12078</xsl:when><!-- ����ʢ��3���������գ������ͣ�  -->
			<!-- ʢ��3�Ų�Ʒ������start -->
			<xsl:when test=".='L12100'">122010</xsl:when><!-- ����ʢ��3���������գ������ͣ�  -->
			<!-- ʢ��3�Ų�Ʒ������end -->
			<xsl:when test=".='L12074'">L12074</xsl:when><!-- ����ʢ��9����ȫ���գ������ͣ�  -->
			<xsl:when test=".='L12089'">L12089</xsl:when><!-- ����ʢ��1����ȫ���գ������ͣ�B��  -->
			<xsl:when test=".='L12080'">L12080</xsl:when><!-- ����ʢ��1����ȫ���գ������ͣ�  -->
			
			<xsl:when test=".='122009'">122009</xsl:when><!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A��  -->
			<xsl:when test=".='122036'">122036</xsl:when><!-- ����ƽ�6����ȫ���գ��ֺ��ͣ�A��  -->
			
			<xsl:when test=".='122006'">122006</xsl:when><!-- ����۱���2����ȫ���գ��ֺ��ͣ�A��  -->
			<xsl:when test=".='122008'">122008</xsl:when><!-- ���������1����������(������)  -->
			<xsl:when test=".='122002'">122002</xsl:when><!-- ����ƽ�2����ȫ����(�ֺ���)A��  -->
			<xsl:when test=".='122005'">122005</xsl:when><!-- ����ƽ�3����ȫ����(�ֺ���)A��  -->
			
			<!-- �����ִ������ߺ󣬻�������ִ��벢������ -->
			<xsl:when test=".='50002'">50002</xsl:when><!-- ������Ӯ���ռƻ� -->
			<xsl:when test=".='122012'">122012</xsl:when><!-- ����ʢ��2���������գ������ͣ�  -->
			<xsl:when test=".='122010'">122010</xsl:when><!-- ����ʢ��3���������գ������ͣ�  -->
			<xsl:when test=".='122035'">122035</xsl:when><!-- ����ʢ��9����ȫ���գ������ͣ�  -->
			
			<!-- ����ٰ���5�ű��ռƻ�50012,����ٰ���5�������L12070,����ӳ�������5����ȫ���գ������ͣ�L12071 -->
			<xsl:when test=".='50012'">50012</xsl:when>
			
			<!--  �����3����ȫ���գ������ͣ�L12086 -->
			<xsl:when test=".='L12086'">L12086</xsl:when>
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
