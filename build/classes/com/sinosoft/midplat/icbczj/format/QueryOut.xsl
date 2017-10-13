<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="TranData">
		<package>
			<xsl:copy-of select="Head" />
			<!-- 
			<pub>
				<workdate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur8Date()" /></workdate>
				<retcode><xsl:apply-templates select="Head/Flag" /></retcode>
				<retmsg><xsl:value-of select="Head/Desc" /></retmsg>
			</pub>  -->
			<ans>
				<!-- ���չ�˾�������� -->
				<transexedate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()" /></transexedate>
				<!-- ���չ�˾����ʱ�� -->
				<transexetime><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur8Time()" /></transexetime>
				<!-- ������ˮ�� -->
				<transrefguid></transrefguid>
				<!-- ������ -->
				<resultcode><xsl:apply-templates select="Head/Flag" /></resultcode>
				<!-- ���ش�����Ϣ -->
				<resultinfodesc><xsl:value-of select="Head/Desc" /></resultinfodesc>
				<!-- ������֤������ -->
				<govtidtc><xsl:apply-templates select="Body/Appnt/IDType" /></govtidtc>
				<!-- ������֤������ -->
				<govtid><xsl:value-of select="Body/Appnt/IDNo" /></govtid>
				<!-- ���������� -->
				<fullname><xsl:value-of select="Body/Appnt/Name" /></fullname>
				<!-- �����˻� 20�ֽ� -->
				<accountnumber><xsl:value-of select="Body/AccNo" /></accountnumber>
				<!-- �����˵绰���� -->
				<dialnumber><xsl:value-of select="Body/Appnt/Mobile" /></dialnumber>
				<!-- ����״̬ -->
				<status><xsl:apply-templates select="Body/ContState" /></status>
				<!-- Ͷ����� -->
				<amount><xsl:apply-templates select="Body/Amnt" /></amount>
				<!-- �ֽ��ֵ ��amount���ֽ��ֵ���������绰��ͨ��Ӧ���Ƿ���ԭʼ���ѣ�ԭʼ���Ͻ�-->
				<cashvalue><xsl:apply-templates select="Body/ActSumPrem" /></cashvalue>
			</ans>
		</package>
	</xsl:template>

	<!-- �ɹ�ʧ�ܱ�־-->
	<xsl:template match="Flag">
		<xsl:choose>
			<xsl:when test=".='0'">00000</xsl:when><!-- �ɹ� -->
			<xsl:when test=".='1'">B0002</xsl:when><!-- ϵͳ�� -->
		</xsl:choose>
	</xsl:template>
	
	<!-- ֤������-->
	<xsl:template match="IDType">
		<xsl:choose>
			<xsl:when test=".='0'">0</xsl:when><!-- ���֤ -->
			<xsl:when test=".='1'">1</xsl:when><!-- ���� -->
			<xsl:when test=".='2'">2</xsl:when><!-- ����֤ -->
			<xsl:when test=".='5'">6</xsl:when><!-- ���ڲ�  -->
			<xsl:when test=".='8'">7</xsl:when><!-- ����  -->
			<xsl:when test=".='9'">0</xsl:when><!-- �쳣���֤  -->
			<xsl:otherwise>7</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ����״̬ ����ת�o�y�У������Ҫ�޸ģ����л�δ�ṩ��-->
	<xsl:template match="ContState">
		<xsl:choose>
			<xsl:when test=".='00'">00</xsl:when><!-- ������Ч  -->
			<xsl:when test=".='01'">04</xsl:when><!-- ������ֹ -->
			<xsl:when test=".='02'">01</xsl:when><!-- �˱���ֹ-->
			<xsl:when test=".='04'">07</xsl:when><!-- ������ֹ-->
			<xsl:when test=".='WT'">03</xsl:when><!-- ��ԥ�����˱���ֹ-->
			<xsl:when test=".='B'">08</xsl:when><!-- ��ǩ��-->
			<xsl:when test=".='C'">02</xsl:when><!-- ���ճ���-->
			<xsl:otherwise>05</xsl:otherwise><!-- ����������״̬����ȷ -->
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
