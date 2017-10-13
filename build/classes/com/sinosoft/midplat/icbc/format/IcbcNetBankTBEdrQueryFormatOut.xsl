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
				<!-- 展现返回的结果 -->
				<xsl:apply-templates select="TranData/Body"/>
			</TXLifeResponse>
		</TXLife>
	</xsl:template>
	
	

	<xsl:template name="OLifE" match="Body">		
		<OLifE>
			<!-- 保单数据 -->
			<Holding id="Holding_1">
				<Policy>
					<!--保单号-->
					<PolNumber><xsl:value-of select="PubContInfo/ContNo"/></PolNumber>						
					<!--保单状态-->
					<PolicyStatus><xsl:value-of select="PubEdorQuery/PolicyStatus"/></PolicyStatus>
					<!-- 给付方式 -->
					<BenefitMode><xsl:value-of select="PubEdorQuery/BenefitMode"/></BenefitMode>
					<!-- 累计红利 -->
					<OLifEExtension VendorCode="10">
						<BonusAmnt><xsl:value-of select="PubEdorQuery/BonusAmnt"/></BonusAmnt>							
					</OLifEExtension>
				</Policy>
				<FinancialActivity>
					<!--财务活动金额-->
					<FinActivityGrossAmt><xsl:value-of select="PubContInfo/FinActivityGrossAmt"/></FinActivityGrossAmt>						
				</FinancialActivity>
			</Holding>
	    </OLifE>
		<!-- 动态打印标志 -->
		<DynamicPrintIndicator>Y</DynamicPrintIndicator>
		<!--凭证逐行打印接口，非实时打印受理单使用，且要求DynamicPrintIndicator节点值为Y-->
		<Print>
			<!--凭证个数-->
			<VoucherNum>1</VoucherNum>
			<SubVoucher>
				<!--凭证类型 批单-->
				<VoucherType>8</VoucherType>
				<!--凭证文本-->
				<!--总页数-->
				<PageTotal>1</PageTotal>
				<Text>
					<!--页号-->
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
