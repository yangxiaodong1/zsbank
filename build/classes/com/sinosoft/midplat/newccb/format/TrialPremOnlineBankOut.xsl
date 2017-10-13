<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
<TX>
	<Head>
		<xsl:copy-of select="TranData/Head/*" />
	</Head>
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
	<Ins_Co_ID>010058</Ins_Co_ID> <!-- ���չ�˾��� -->
	<Ins_Co_Nm>�������ٱ������޹�˾</Ins_Co_Nm> <!-- ���չ�˾���� -->
	<Rvl_Rcrd_Num>1</Rvl_Rcrd_Num> <!-- ѭ����¼���� -->
	<!-- ������ -->
	<xsl:variable name="Risk" select="TradeData/BackInfo/LCInsureds/LCInsured/Risks/Risk[RiskCode=MainRiskCode]" />
	
	<xsl:variable name="Risk2" select="TradeData/BackInfo/LCCont" />
	
	<Life_List>
		<!-- ����������Ϣ begin -->
		<Life_Detail>
			<!-- ���ֱ�� -->
			<Cvr_ID>
				<xsl:call-template name="tran_Riskcode">
					<xsl:with-param name="riskcode" select="$Risk/RiskCode" />
				</xsl:call-template>
			</Cvr_ID> 
			<!-- �������� -->
			<Cvr_Nm>
				<xsl:call-template name="tran_Riskcode_to_RiskName">
					<xsl:with-param name="riskcode" select="$Risk/RiskCode" />
				</xsl:call-template>
			</Cvr_Nm> 
			<InsPrem_Amt><xsl:value-of select="java:com.sinosoft.midplat.newccb.format.Trans_newccb.getInsPrem_Amt($Risk2/Prem)" /></InsPrem_Amt> <!-- ���ѽ�� -->
			<Ins_Cvr><xsl:value-of select="java:com.sinosoft.midplat.newccb.format.Trans_newccb.getInsPrem_Amt($Risk2/Amnt)" /></Ins_Cvr> <!-- Ͷ������ -->
			<xsl:if test = "$Risk2/Mult = 'NaN'">
			   <Ins_Cps>0</Ins_Cps> <!-- Ͷ������ -->
			</xsl:if>
			<xsl:if test = "$Risk2/Mult != 'NaN'">
			   <Ins_Cps><xsl:value-of select="$Risk2/Mult" /></Ins_Cps> <!-- Ͷ������ -->
			</xsl:if>
		</Life_Detail>
		<!-- ����������Ϣ end -->
	</Life_List> 
	<!-- ������ end -->
	<Tot_InsPrem_Amt><xsl:value-of select="java:com.sinosoft.midplat.newccb.format.Trans_newccb.getInsPrem_Amt($Risk2/Prem)" /></Tot_InsPrem_Amt> <!-- �ܱ��ѽ�� -->
	<Init_PyF_Amt><xsl:value-of select="java:com.sinosoft.midplat.newccb.format.Trans_newccb.getInsPrem_Amt($Risk2/Prem)" /></Init_PyF_Amt> <!-- ���ڽɷѽ�� -->
	<Anulz_InsPrem_Amt></Anulz_InsPrem_Amt> <!-- �껯���ѽ�� -->
	<EcIst_PyF_Amt_Inf></EcIst_PyF_Amt_Inf> <!-- ÿ�ڽɷѽ����Ϣ -->
	<InsPrem_PyF_Prd_Num></InsPrem_PyF_Prd_Num> <!-- ���ѽɷ����� -->
	<InsPrem_PyF_Cyc_Cd></InsPrem_PyF_Cyc_Cd> <!-- ���ѽɷ����ڴ��� -->
</xsl:template>


<!-- ����ת�� -->
<xsl:template name="tran_Riskcode">
	<xsl:param name="riskcode" />
	<xsl:choose>
		<xsl:when test="$riskcode='122001'">122001</xsl:when>	<!-- ����ƽ�1����ȫ���գ��ֺ��ͣ�A�� -->
		<xsl:when test="$riskcode='122002'">122002</xsl:when>	<!-- ����ƽ�2����ȫ���գ��ֺ��ͣ�A�� -->
		<xsl:when test="$riskcode='122003'">122003</xsl:when>	<!-- ����۱���1����ȫ���գ��ֺ��ͣ�A�� -->
		<xsl:when test="$riskcode='122004'">122004</xsl:when>	<!-- ����ӻƽ�2����ȫ���գ��ֺ��ͣ�A�� -->
		<xsl:when test="$riskcode='122005'">122005</xsl:when>	<!-- ����ƽ�3����ȫ���գ��ֺ��ͣ�A�� -->
		<xsl:when test="$riskcode='122006'">122006</xsl:when>	<!-- ����۱���2����ȫ���գ��ֺ��ͣ�A�� -->
		<xsl:when test="$riskcode='122008'">122008</xsl:when>	<!-- ���������1���������գ������ͣ� -->
		<xsl:when test="$riskcode='122009'">122009</xsl:when>	<!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A�� -->
		<xsl:when test="$riskcode='L12079'">L12079</xsl:when>	<!-- ����ʢ��2���������գ������ͣ� -->
		<xsl:when test="$riskcode='L12100'">122010</xsl:when>	<!-- ����ʢ��3���������գ������ͣ� -->
		
		<xsl:when test="$riskcode='L12074'">122035</xsl:when>	<!-- ����ʢ��9����ȫ���գ������ͣ� -->
		<xsl:when test="$riskcode='L12052'">L12052</xsl:when>	<!-- �������Ӯ1������� -->
		<xsl:when test="$riskcode='50015'">50002</xsl:when>	<!-- �������Ӯ���ռƻ� -->
		<!-- ���ִ��벢�� -->
		<xsl:when test="$riskcode='L12089'">L12089</xsl:when>	<!-- ����ʢ��1�������գ������ͣ�B�� -->
		<xsl:when test="$riskcode='122010'">122010</xsl:when>	<!-- ����ʢ��3���������գ������ͣ� -->
		<xsl:when test="$riskcode='122035'">122035</xsl:when>	<!-- ����ʢ��9����ȫ���գ������ͣ� -->
		<xsl:when test="$riskcode='L12087'">L12087</xsl:when>	<!-- �����5����ȫ���գ������ͣ� -->
		<xsl:when test="$riskcode='L12085'">L12085</xsl:when>	<!-- �����2����ȫ���գ������ͣ� -->
		<xsl:when test="$riskcode='L12086'">L12086</xsl:when>	<!-- �����3����ȫ���գ������ͣ� -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- ���ִ���ת��Ϊ�������� -->
<xsl:template name="tran_Riskcode_to_RiskName">
	<xsl:param name="riskcode" />
	<xsl:choose>
		<xsl:when test="$riskcode='122001'">����ƽ�1����ȫ���գ��ֺ��ͣ�A��</xsl:when>	<!-- ����ƽ�1����ȫ���գ��ֺ��ͣ�A�� -->
		<xsl:when test="$riskcode='122002'">����ƽ�2����ȫ���գ��ֺ��ͣ�A��</xsl:when>	<!-- ����ƽ�2����ȫ���գ��ֺ��ͣ�A�� -->
		<xsl:when test="$riskcode='122003'">����۱���1����ȫ���գ��ֺ��ͣ�A��</xsl:when>	<!-- ����۱���1����ȫ���գ��ֺ��ͣ�A�� -->
		<xsl:when test="$riskcode='122004'">����ӻƽ�2����ȫ���գ��ֺ��ͣ�A��</xsl:when>	<!-- ����ӻƽ�2����ȫ���գ��ֺ��ͣ�A�� -->
		<xsl:when test="$riskcode='122005'">����ƽ�3����ȫ���գ��ֺ��ͣ�A��</xsl:when>	<!-- ����ƽ�3����ȫ���գ��ֺ��ͣ�A�� -->
		<xsl:when test="$riskcode='122006'">����۱���2����ȫ���գ��ֺ��ͣ�A��</xsl:when>	<!-- ����۱���2����ȫ���գ��ֺ��ͣ�A�� -->
		<xsl:when test="$riskcode='122008'">���������1���������գ������ͣ�</xsl:when>	<!-- ���������1���������գ������ͣ� -->
		<xsl:when test="$riskcode='122009'">����ƽ�5����ȫ���գ��ֺ��ͣ�A��</xsl:when>	<!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A�� -->
		<xsl:when test="$riskcode='L12079'">����ʢ��2���������գ������ͣ�</xsl:when>	<!-- ����ʢ��2���������գ������ͣ� -->
		<xsl:when test="$riskcode='L12100'">����ʢ��3���������գ������ͣ�</xsl:when>	<!-- ����ʢ��3���������գ������ͣ� -->
		
		<xsl:when test="$riskcode='L12074'">����ʢ��9����ȫ���գ������ͣ�</xsl:when>	<!-- ����ʢ��9����ȫ���գ������ͣ� -->
		<xsl:when test="$riskcode='L12052'">�������Ӯ1�������</xsl:when>	<!-- �������Ӯ1������� -->
		
		<!-- ���ִ��벢�� -->
		<xsl:when test="$riskcode='L12089'">����ʢ��1�������գ������ͣ�B��</xsl:when>	<!-- ����ʢ��1�������գ������ͣ�B�� -->
		<xsl:when test="$riskcode='122010'">����ʢ��3���������գ������ͣ�</xsl:when>	<!-- ����ʢ��3���������գ������ͣ� -->
		<xsl:when test="$riskcode='122035'">����ʢ��9����ȫ���գ������ͣ�</xsl:when>	<!-- ����ʢ��9����ȫ���գ������ͣ� -->
		<xsl:when test="$riskcode='L12087'">�����5����ȫ���գ������ͣ�</xsl:when>	<!-- �����5����ȫ���գ������ͣ� -->
		<xsl:when test="$riskcode='L12085'">�����2����ȫ���գ������ͣ�</xsl:when>	<!-- �����2����ȫ���գ������ͣ� -->
		<xsl:when test="$riskcode='L12086'">�����3����ȫ���գ������ͣ�</xsl:when>	<!-- �����3����ȫ���գ������ͣ� -->
		<xsl:when test="$riskcode='50015'">�������Ӯ���ռƻ�</xsl:when>	<!-- �������Ӯ���ռƻ� -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>


</xsl:stylesheet>





