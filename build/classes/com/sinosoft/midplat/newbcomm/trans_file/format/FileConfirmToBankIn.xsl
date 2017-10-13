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
				<TrCode>I60911</TrCode>
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
					<BusDate></BusDate>
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
				<!-- �ļ���-->
				<FileName></FileName>
				<!-- �ܱ��� -->
				<TotalNum></TotalNum>
				<!-- �ܽ�� -->
				<TotalAmt></TotalAmt>
				<!-- ���������κ� -->
				<BatNo></BatNo>
			</Body>
		</Req>
	</xsl:template>
</xsl:stylesheet>