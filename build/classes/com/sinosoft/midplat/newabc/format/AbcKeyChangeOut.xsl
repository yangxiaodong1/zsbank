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
				<TransCode>1001</TransCode>
				<!-- ���չ�˾��ˮ�� �ڳ����и�ֵ-->
				<InsuSerial></InsuSerial>
				<!-- ���д��� -->
				<BankCode>00</BankCode>
				<!-- ���չ�˾���� -->
				<CorpNo>3002</CorpNo>
				<!-- ���׷��� -->
				<TransSide>0</TransSide>
				<!-- ί�з�ʽ -->
				<EntrustWay>20</EntrustWay>
			</Header>
			<App>
				<Req>
					<!-- ���ܷ�ʽ 01: Ĭ�Ϸ�ʽRSA+AES��ʽ-->
					<EncType>01</EncType>
					<!-- ����Կ-->
					<PriKey>01</PriKey>
					<!-- ԭ��Կ-->
					<OrgKey>cacert.crt</OrgKey>
				</Req>
			</App>
		</ABCB2I>
	</xsl:template>
</xsl:stylesheet>
