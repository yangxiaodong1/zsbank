<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	<xsl:template match="/">
		<TranData>
			<!--������Ϣ-->
			<Head>
				<!-- ���н������� -->
				<TranDate>
					<xsl:value-of
						select="java:com.sinosoft.midplat.common.DateUtil.getCur8Date()" />
				</TranDate>
				<!-- ����ʱ�� ũ�в�������ʱ�� ȡϵͳ��ǰʱ�� -->
				<TranTime>
					<xsl:value-of
						select="java:com.sinosoft.midplat.common.DateUtil.getCur6Time()" />
				</TranTime>
				<!-- ��Ա���� -->
				<TellerNo>sys</TellerNo>
				<!-- ���н�����ˮ�� -->
				<TranNo>cacert.crt</TranNo>
				<!-- ������+������ -->
				<NodeNo>05001</NodeNo>
				<BankCode></BankCode>
			</Head>
			<Body>
				<!-- ����Կ -->
				<OldLogNo></OldLogNo>
				<!-- ����Կ -->
				<ContPrtNo></ContPrtNo>
			</Body>
		</TranData>
	</xsl:template>
</xsl:stylesheet>