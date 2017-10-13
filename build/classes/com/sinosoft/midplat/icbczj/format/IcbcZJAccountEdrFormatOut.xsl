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
				<retcode><xsl:apply-templates select="Head/Flag" /></retcode>
				<retmsg><xsl:value-of select="Head/Desc" /></retmsg>
				<cmpdate><xsl:value-of select="Body/PubContInfo/TransExeDate" /></cmpdate>
				<cmptime><xsl:value-of select="Body/PubContInfo/TransExeTime" /></cmptime>
			</pub>  -->
			<ans>
				<!-- ���չ�˾�������� -->
				<transexedate><xsl:value-of select="Body/PubContInfo/TransExeDate" /></transexedate>
				<!-- ���չ�˾����ʱ�� -->
				<transexetime><xsl:value-of select="Body/PubContInfo/TransExeTime" /></transexetime>
				<!-- ������ˮ�� -->
				<transrefguid></transrefguid>
				<!-- �����־ -->
				<transtype></transtype>
				<!-- ����ģʽ -->
				<transmode></transmode>
				<!-- �����˻�  -->
				<accountnumber><xsl:value-of select="Body/PubContInfo/BankAccNo" /></accountnumber>
				
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

</xsl:stylesheet>
