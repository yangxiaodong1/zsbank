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

	<!-- һ�����к� -->
	<Lv1_Br_No><xsl:value-of select="PubContInfo/SubBankCode" /></Lv1_Br_No>
	<!-- �������� -->
	<InsPolcy_No><xsl:value-of select="PubContInfo/ContNo" /></InsPolcy_No>
	<Cvr_ID></Cvr_ID>
	<Btch_BillNo></Btch_BillNo>
	<!-- �޸����� -->
	<Mod_Cntnt>    ��<xsl:value-of select="APP_ENTITY/Plchd_Nm"/>���룬������<xsl:value-of select="APP_ENTITY/InsPolcy_No"/>�ı��յ�������Ͷ������Ϣ���,���������ݾ�����������Ϊ׼���̶��绰���룺<xsl:value-of select="APP_ENTITY/PlchdFixTelDmstDstcNo" />-<xsl:value-of select="APP_ENTITY/Plchd_Fix_TelNo"/>���ƶ��绰���룺<xsl:value-of select="APP_ENTITY/Plchd_Move_TelNo"/>���������룺<xsl:value-of select="APP_ENTITY/Plchd_ZipECD"/>��ͨѶ��ַ��<xsl:value-of select="APP_ENTITY/Plchd_Comm_Adr"/>��
	</Mod_Cntnt>
	<Ret_File_Num>0</Ret_File_Num>
	<Detail_List>
		<Prmpt_Inf_Dsc></Prmpt_Inf_Dsc>
		<AgIns_Vchr_TpCd></AgIns_Vchr_TpCd>
		<Ins_IBVoch_ID></Ins_IBVoch_ID>
		<!-- ѭ����¼���� -->
		<Rvl_Rcrd_Num>0</Rvl_Rcrd_Num>
		<Detail>
			<Ret_Inf></Ret_Inf>
		</Detail>
	</Detail_List>

</xsl:template>


</xsl:stylesheet>

