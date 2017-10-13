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

	<!-- 一级分行号 -->
	<Lv1_Br_No><xsl:value-of select="PubContInfo/SubBankCode" /></Lv1_Br_No>
	<!-- 保单号码 -->
	<InsPolcy_No><xsl:value-of select="PubContInfo/ContNo" /></InsPolcy_No>
	<Cvr_ID></Cvr_ID>
	<Btch_BillNo></Btch_BillNo>
	<!-- 修改内容 -->
	<Mod_Cntnt>    经<xsl:value-of select="APP_ENTITY/Plchd_Nm"/>申请，保单号<xsl:value-of select="APP_ENTITY/InsPolcy_No"/>的保险单中如下投保人信息变更,变更后的内容均以下列内容为准：固定电话号码：<xsl:value-of select="APP_ENTITY/PlchdFixTelDmstDstcNo" />-<xsl:value-of select="APP_ENTITY/Plchd_Fix_TelNo"/>、移动电话号码：<xsl:value-of select="APP_ENTITY/Plchd_Move_TelNo"/>、邮政编码：<xsl:value-of select="APP_ENTITY/Plchd_ZipECD"/>、通讯地址：<xsl:value-of select="APP_ENTITY/Plchd_Comm_Adr"/>。
	</Mod_Cntnt>
	<Ret_File_Num>0</Ret_File_Num>
	<Detail_List>
		<Prmpt_Inf_Dsc></Prmpt_Inf_Dsc>
		<AgIns_Vchr_TpCd></AgIns_Vchr_TpCd>
		<Ins_IBVoch_ID></Ins_IBVoch_ID>
		<!-- 循环记录条数 -->
		<Rvl_Rcrd_Num>0</Rvl_Rcrd_Num>
		<Detail>
			<Ret_Inf></Ret_Inf>
		</Detail>
	</Detail_List>

</xsl:template>


</xsl:stylesheet>

