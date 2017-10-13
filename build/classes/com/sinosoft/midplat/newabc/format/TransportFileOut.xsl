<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	<xsl:template match="/">
		<ABCB2I>
			<Header>
				<!-- �������� -->
				<TransDate>
					<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur8Date()" />
				</TransDate>
				<!-- ����ʱ�� -->
				<TransTime>
					<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur6Time()" />
				</TransTime>
				<!-- ������ -->
				<TransCode>1017</TransCode>
				<!-- ���չ�˾��ˮ�� �ڳ����и�ֵ-->
				<InsuSerial></InsuSerial>
				<!-- ���д��� -->
				<BankCode>00</BankCode>
				<!-- ���չ�˾���� -->
				<CorpNo>3048</CorpNo>
				<!-- ���׷��� -->
				<TransSide>0</TransSide>
				<!-- ί�з�ʽ -->
				<EntrustWay></EntrustWay>
			</Header>
			<App>
				<!-- ģ���еĸ�ֵΪ����֤���ļ���ֵ-->
				<Req>
					<!-- ���ͷ�ʽ 0: �ϴ� 1: ���� �ڳ����и�ֵ-->
					<TransFlag>1</TransFlag>
					<!-- �ļ����� 01: ֤���ļ� 02: �����ļ� �ڳ����и�ֵ-->
					<FileType>01</FileType>
					<!-- �ļ����� �ڳ����и�ֵ-->
					<FileName>cacert.crt</FileName>
					<!-- �ļ����� �ڳ����и�ֵ-->
					<FileLen>00000000</FileLen>
					<!-- �ļ��޸�ʱ��� yyyy-MM-dd HH:mm:ss.SSS-->
					<FileTimeStamp>
						<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCurDate('yyyy-MM-dd HH:mm:ss.SSS')" />
					</FileTimeStamp>
				</Req>
			</App>
		</ABCB2I>
	</xsl:template>
</xsl:stylesheet>
