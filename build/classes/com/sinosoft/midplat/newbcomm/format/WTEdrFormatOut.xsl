<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
	<xsl:template match="/">
		<Rsp>			
			<xsl:apply-templates select="TranData/Head" />
			<xsl:apply-templates select="TranData/Body" />
		</Rsp>
	</xsl:template>
	<xsl:template name="Transaction_Head" match="Head">
		<Head>
			<Flag>
				<xsl:value-of select="Flag" />
			</Flag><!-- 0��ʾ�ɹ���1��ʾʧ�� -->
			<Desc>
				<xsl:value-of select="Desc" />
			</Desc><!-- ʧ��ʱ�����ش�����Ϣ -->
		</Head>
	</xsl:template>
	<xsl:template name="Body" match="Body">
	 <Body>
		 <PolItem>
		 	<!-- ������ -->
			<PolNo><xsl:value-of select="PubContInfo/ContNo" /></PolNo>
			<!-- ������ -->
			<EdmNo><xsl:value-of select="PubEdorConfirm/FormNumber" /></EdmNo>
			<!-- ������Ч���� -->
			<InvValiDate>
				<xsl:value-of
					select="PubContInfo/EdorValidDate" />
			</InvValiDate>
			<!-- �˿��� -->
			<PayAmt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(PubContInfo/FinActivityGrossAmt)" /></PayAmt>
			<!-- ����״̬ -->
			<PolStat>3</PolStat>
		 </PolItem>
		 <!-- ��ʽ���Ĵ�ӡ��Ϣ -->
		<PrtList />	
      </Body>
	</xsl:template>
</xsl:stylesheet>