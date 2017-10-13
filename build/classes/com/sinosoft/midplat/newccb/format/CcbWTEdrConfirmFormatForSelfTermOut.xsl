<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
<TX>
	<xsl:copy-of select="TranData/Head" />
	<TX_BODY>
		<ENTITY>
			<APP_ENTITY>
				<xsl:apply-templates select="TranData/Body"/>
			</APP_ENTITY>
		</ENTITY>
	</TX_BODY>
</TX>
</xsl:template>


<xsl:template match="Body">
	<!-- 返回文件数量 -->
	<Ret_File_Num>0</Ret_File_Num>
	<Detail_List>
		<!-- 提示信息描述 -->
		<Prmpt_Inf_Dsc></Prmpt_Inf_Dsc>
		<!-- 代理保险凭证类型代码 -->
		<AgIns_Vchr_TpCd></AgIns_Vchr_TpCd>
		<!-- 保险重空编号 -->
		<Ins_IBVoch_ID></Ins_IBVoch_ID>
		<!-- 循环记录条数 -->
		<Rvl_Rcrd_Num>0</Rvl_Rcrd_Num>
		<Detail>
			<!-- 返回信息 -->
			<Ret_Inf></Ret_Inf>
		</Detail>
	</Detail_List>

</xsl:template>

		
</xsl:stylesheet>

