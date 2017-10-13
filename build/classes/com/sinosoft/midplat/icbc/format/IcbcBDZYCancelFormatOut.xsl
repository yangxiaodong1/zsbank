<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	<xsl:template match="/">
		<TXLife>
			<xsl:copy-of select="TranData/Head" />
			<TXLifeResponse>
				<TransRefGUID>
					<xsl:value-of select="TranNo" />
				</TransRefGUID>
				<TransType>1018</TransType>
				<TransSubType>2</TransSubType>
				<TransExeDate>
					<xsl:value-of
						select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()" />
				</TransExeDate>
				<TransExeTime>
					<xsl:value-of
						select="java:com.sinosoft.midplat.common.DateUtil.getCur8Time()" />
				</TransExeTime>

				<!-- 展现返回的结果 -->
				<xsl:apply-templates select="TranData/Body" />

				<!-- 原始交易代码 -->
				<OLifEExtension VendorCode="1">
					<TransNo><xsl:value-of select="OldTranNo" /></TransNo>
				</OLifEExtension>
			<!-- 平保前置流水号 -->  
				<RcptId></RcptId>			
			</TXLifeResponse>
		</TXLife>
	</xsl:template>

	<xsl:template name="OLifE" match="Body">
		<OLifE>
			<!-- 保单数据 -->
			<Holding id="Holding_1">
				<Policy>
					<!--保单号-->
					<PolNumber>
						<xsl:value-of select="ContNo" />
					</PolNumber>


				</Policy>
				
				<Arrangement>
					<ArrType tc="36" />
					<!-- Account Value Adjustment 冲正 -->
					<ArrDestination HoldingID="Acct_1" />
				</Arrangement>
				
			</Holding>
				<Holding id="Acct_1">
					<Banking>
					<!-- 银行账号 -->
					<AccountNumber>
						<xsl:value-of select="//PubContInfo/BankAccNo" />
					</AccountNumber>
				
				</Banking>
				
			</Holding>	
			
			<!-- 单证信息 -->
			<FormInstance id="Form_1">
				<!-- 单证名称 -->
				<FormName>批单</FormName>
				<!-- 批单号 -->
				<DocumentControlNumber>
					<xsl:value-of select="PubEdorConfirm/FormNumber"></xsl:value-of>
				</DocumentControlNumber>
				<!-- 批单信息区 -->
				<Attachment id="Attachment_Form_1">
					<Description>
						Document content attachment
					</Description>
					<!-- 批单内容 -->
					<AttachmentData>content</AttachmentData>
					<AttachmentType tc="2147483647">
						Other
					</AttachmentType>
					<AttachmentLocation tc="1">
						In Line
					</AttachmentLocation>
				</Attachment>
			</FormInstance>
				<FormInstance id="Form_2">
				<!-- 单证名称 -->
				<FormName>收据</FormName>
				<!-- 收据号 -->
				<DocumentControlNumber>
					<xsl:value-of select="PubEdorConfirm/FormNumber"></xsl:value-of>
				</DocumentControlNumber>
			</FormInstance>
		</OLifE>
	</xsl:template>

 
	<!-- 性别 -->
	<xsl:template name="tran_sex" match="Sex">
		<xsl:choose>
			<xsl:when test=".='0'">1</xsl:when><!-- 男 -->
			<xsl:when test=".='1'">2</xsl:when><!-- 女 -->
			<xsl:when test=".='2'">3</xsl:when><!-- 其他 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
