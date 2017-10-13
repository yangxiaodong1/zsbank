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
	<!-- �����ļ����� -->
	<Ret_File_Num>0</Ret_File_Num>
	<Detail_List>
		<!-- ��ʾ��Ϣ���� -->
		<Prmpt_Inf_Dsc></Prmpt_Inf_Dsc>
		<!-- ������ƾ֤���ʹ��� -->
		<AgIns_Vchr_TpCd></AgIns_Vchr_TpCd>
		<!-- �����ؿձ�� -->
		<Ins_IBVoch_ID></Ins_IBVoch_ID>
		<!-- ѭ����¼���� -->
		<Rvl_Rcrd_Num>0</Rvl_Rcrd_Num>
		<Detail>
			<!-- ������Ϣ -->
			<Ret_Inf></Ret_Inf>
		</Detail>
	</Detail_List>

</xsl:template>

		
</xsl:stylesheet>

