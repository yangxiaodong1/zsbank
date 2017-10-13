<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
	<xsl:template match="/">
		<TXLife> 			
			<xsl:copy-of select="TranData/Head" />
			<TXLifeResponse>				
				<TransRefGUID/>
				<TransType></TransType>
				<TransExeDate>
					<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()"/>
				</TransExeDate>
				<TransExeTime>
					<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur8Time()"/>
				</TransExeTime>							
				<!-- չ�ַ��صĽ�� -->
				<xsl:apply-templates select="TranData/Body"/>
			</TXLifeResponse>
		</TXLife>
	</xsl:template>
	
	

	<xsl:template name="OLifE" match="Body">		
		<OLifE>
			<!-- �������� -->
			<Holding id="Holding_1">
				<Policy>
					<!--������-->
					<PolNumber><xsl:value-of select="PubContInfo/ContNo"/></PolNumber>						
					<!--����״̬-->
					<PolicyStatus><xsl:value-of select="PubEdorQuery/PolicyStatus"/></PolicyStatus>
					<!-- ������ʽ -->
					<BenefitMode><xsl:value-of select="PubEdorQuery/BenefitMode"/></BenefitMode>
					<!-- �ۼƺ��� -->
					<OLifEExtension VendorCode="10">
						<BonusAmnt><xsl:value-of select="PubEdorQuery/BonusAmnt"/></BonusAmnt>							
					</OLifEExtension>
				</Policy>
				<FinancialActivity>
					<!--�������-->
					<FinActivityGrossAmt><xsl:value-of select="PubContInfo/FinActivityGrossAmt"/></FinActivityGrossAmt>						
				</FinancialActivity>
			</Holding>
	    </OLifE>
		<!-- ��̬��ӡ��־ -->
		<DynamicPrintIndicator>Y</DynamicPrintIndicator>
		<!--ƾ֤���д�ӡ�ӿڣ���ʵʱ��ӡ����ʹ�ã���Ҫ��DynamicPrintIndicator�ڵ�ֵΪY-->
		<Print>
			<!--ƾ֤����-->
			<VoucherNum>1</VoucherNum>
			<SubVoucher>
				<!--ƾ֤���� ����-->
				<VoucherType>8</VoucherType>
				<!--ƾ֤�ı�-->
				<!--��ҳ��-->
				<PageTotal>1</PageTotal>
				<Text>
					<!--ҳ��-->
					<PageNum>1</PageNum>
					<RowTotal>1</RowTotal>
					<TextContent>
						  <RowNum>1</RowNum>
					    <TextRowContent>aaaaaaa</TextRowContent>
					</TextContent>
				</Text>
			</SubVoucher>
		</Print>
	</xsl:template>
	
</xsl:stylesheet>
