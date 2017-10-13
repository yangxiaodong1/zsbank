<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	<xsl:template match="/">
		<Req>
			<!--������Ϣ-->
			<Head>
				<!-- ������ -->
				<TrCode>I90901</TrCode>
				<!-- �������� -->
				<Sender>
					<!-- ��������:����������Ϊ���գ���̶���д��I�� -->
					<OrgType>I</OrgType>
					<!-- ����ID -->
					<OrgId>IF10039</OrgId>
					<!-- ��֧���� -->
					<BrchId></BrchId>
					<!-- ������� -->
					<SubBrchId></SubBrchId>
					<!-- �����ն˺� -->
					<TermId></TermId>
					<!-- ���׹�Ա�� -->
					<TrOper>sys</TrOper>
					<!-- ���׹�Ա���� -->
					<TrOperName>sys</TrOperName>
					<!-- �������� -->
					<ChanNo>93</ChanNo>
					<!-- ԭҵ������ -->
					<OriBusDate></OriBusDate>
					<!-- ԭ������ˮ�� -->
					<OriSeqNo></OriSeqNo>
					<!-- ҵ������ -->
					<BusDate><xsl:value-of
						select="java:com.sinosoft.midplat.common.DateUtil.getCur8Date()" /></BusDate>
					<!-- ������ˮ�� -->
					<SeqNo></SeqNo>
					<!-- �������� -->
					<TrDate><xsl:value-of
						select="java:com.sinosoft.midplat.common.DateUtil.getCur8Date()" /></TrDate>
					<!-- ����ʱ�� -->
					<TrTime><xsl:value-of
						select="java:com.sinosoft.midplat.common.DateUtil.getCur6Time()" /></TrTime>					
				</Sender>
				<Recver>
					<!-- ��������:������Ӧ��Ϊ���У���̶���д��B�� -->
					<OrgType>B</OrgType>
					<!-- ����ID -->
					<OrgId>3012900</OrgId>
					<!-- ��֧���� -->
					<BrchId></BrchId>
					<!-- ������� -->
					<SubBrchId></SubBrchId>
				</Recver>				
			</Head>
			<Body>
				<!-- ԭ��Կ�汾�� -->
				<OriKeyId>1</OriKeyId>
				<!-- ��Կ�汾�� -->
				<KeyId>1</KeyId>
				<!-- ������Կ -->
				<WorkKey>EDCC8A136A5DC46D9DD06A1BAEB78746</WorkKey>
				<!-- ͨѶ��Կ -->
				<CommKey>EDCC8A136A5DC46D9DD06A1BAEB78746</CommKey>
			</Body>
		</Req>
	</xsl:template>
</xsl:stylesheet>