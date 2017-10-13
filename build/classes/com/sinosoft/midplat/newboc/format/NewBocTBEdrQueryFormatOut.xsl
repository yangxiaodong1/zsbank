<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/TranData">
		<InsuRet>
			<Main>
				<xsl:if test="Head/Flag='0'">
					<ResultCode>0000</ResultCode>
					<ResultInfo>
						<xsl:value-of select="Head/Desc" />
					</ResultInfo>
					<!--保单状态--><!-- 后期更改 -->
					<TranType>
						<xsl:value-of select="Body/PubContInfo/AppntName" />
					</TranType>
					<!--退保金额-->
					<Backmium>
						<xsl:value-of
							select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/PubContInfo/FinActivityGrossAmt)" />
					</Backmium>
					<!-- 提示信息 -->
					<Comments>
						<xsl:value-of
							select="Body/PubContInfo/Remark" />
					</Comments>
				</xsl:if>
				<xsl:if test="Head/Flag!='0'">
					<ResultCode>0001</ResultCode>
					<ResultInfo>
						<xsl:value-of select="Head/Desc" />
					</ResultInfo>
					<TranType></TranType>
					<!--退保金额-->
					<Backmium></Backmium>
					<!-- 提示信息 -->
					<Comments>
						<xsl:value-of
							select="Body/PubContInfo/Remark" />
					</Comments>
				</xsl:if>
			</Main>
		</InsuRet>
	</xsl:template>
	
</xsl:stylesheet>