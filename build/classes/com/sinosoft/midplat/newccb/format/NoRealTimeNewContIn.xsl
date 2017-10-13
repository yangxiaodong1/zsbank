<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
	 <TranData>
		<Head>
			<xsl:copy-of select="TX/Head/*"/>
		</Head>
		<Body>
			<xsl:apply-templates select="TX/TX_BODY/ENTITY/APP_ENTITY"/>
		</Body>
	</TranData>
</xsl:template>


<xsl:template name="Body" match="APP_ENTITY">
	
	<!-- Ͷ������ -->
	<ProposalPrtNo><xsl:value-of select="Ins_Bl_Prt_No" /></ProposalPrtNo>
	<!-- Ͷ������ -->
	<PolApplyDate><xsl:value-of select="InsPolcy_RgDt" /></PolApplyDate>
	 <!--������������-->
	<AgentComName><xsl:value-of select="BO_Nm" /></AgentComName>
	<!--����������Ա����-->
	<SellerNo><xsl:value-of select="BO_Sale_Stff_ID"/></SellerNo>
	<!--���������ʸ�֤-->
	<AgentComCertiCode><xsl:value-of select="BOInsPrAgnBsnLcns_ECD"/></AgentComCertiCode>
	<!--����������Ա����-->
	<TellerName><xsl:value-of select="BO_Sale_Stff_Nm"/></TellerName>
	<!--����������Ա�ʸ�֤-->
	<TellerCertiCode><xsl:value-of select="Sale_Stff_AICSQCtf_ID"/></TellerCertiCode>
	<!-- FIXME ���л���3���������Ϣ�������Ƿ񱣴棿 -->
	<AccName><xsl:value-of select="Plchd_Nm" /></AccName>	<!-- ȡͶ�������� -->
	<AccNo />
	<SubBankCode><xsl:value-of select="Lv1_Br_No" /></SubBankCode>
	
	
	<!-- ��ϲ�Ʒ����  -->
	<xsl:variable name="tContPlanCode">
		<xsl:call-template name="tran_ContPlanCode">
			<xsl:with-param name="contPlanCode" select="Bu_List/Bu_Detail[position()=1]/Cvr_ID" />
		</xsl:call-template>
	</xsl:variable>
	
	<!-- ��Ʒ��� -->
	<ContPlan>
		<!-- ��Ʒ��ϱ��� -->
		<ContPlanCode><xsl:value-of select="$tContPlanCode" /></ContPlanCode>
	</ContPlan>
	
	<!-- Ͷ������Ϣ -->
	<xsl:call-template name="Appnt" />
	
	<xsl:for-each select="Bu_List/Bu_Detail">
		<Risk>
			<RiskCode>
				<xsl:call-template name="tran_Riskcode">
					<xsl:with-param name="riskcode" select="Cvr_ID" />
				</xsl:call-template>
			</RiskCode>
			<MainRiskCode />
			<Amnt />
			<Prem />
			<Mult />
		    <PayMode />
			<PayIntv />
			<PayEndYearFlag />
			<PayEndYear />
			<InsuYearFlag />
			<InsuYear />
		</Risk>
	</xsl:for-each>
		
</xsl:template>

<!-- Ͷ������Ϣ -->
<xsl:template name="Appnt">
	<Appnt>
		<Name><xsl:value-of select="Plchd_Nm" /></Name>
		<Sex />
		<Birthday />
		<IDType>
			<xsl:call-template name="tran_IDType">
				<xsl:with-param name="idtype" select="Plchd_Crdt_TpCd" />
			</xsl:call-template>
		</IDType>
		<IDNo><xsl:value-of select="Plchd_Crdt_No" /></IDNo>
		<LiveZone />
		<Address />
		<Mobile><xsl:value-of select="Plchd_Move_TelNo" /></Mobile>
		<xsl:if test="PlchdFixTelDmstDstcNo != '' " >
		    <Phone><xsl:value-of select="PlchdFixTelDmstDstcNo" />-<xsl:value-of select="Plchd_Fix_TelNo" /></Phone>
		</xsl:if>
		<xsl:if test="PlchdFixTelDmstDstcNo = '' " >
		    <Phone><xsl:value-of select="Plchd_Fix_TelNo" /></Phone>
		</xsl:if>
	</Appnt>
</xsl:template>


<!-- ֤������ת�� -->
<xsl:template name="tran_IDType">
	<xsl:param name="idtype" />
	<xsl:choose>
		<xsl:when test="$idtype='1010'">0</xsl:when>	<!-- ���֤ -->
		<xsl:when test="$idtype='1011'">0</xsl:when>	<!-- ���֤ -->
		<xsl:when test="$idtype='1052'">1</xsl:when>	<!-- ���� -->
		<xsl:when test="$idtype='1020'">2</xsl:when>	<!-- ����֤ -->
		<xsl:when test="$idtype='1030'">2</xsl:when>	<!-- ����֤ -->
		<xsl:when test="$idtype='1040'">5</xsl:when>	<!-- ���ڲ� -->
		<xsl:when test="$idtype=''">9</xsl:when>	<!-- �쳣���֤ -->
		<xsl:otherwise>8</xsl:otherwise><!-- ���� -->
	</xsl:choose>
</xsl:template>


<!-- ���ִ��� -->
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
		<!-- �ݲ�����ʢ2��Ʒ -->
		<!-- <xsl:when test="$riskcode='L12079'">L12079</xsl:when>  -->	<!-- ����ʢ��2���������գ������ͣ� -->
		<xsl:when test="$riskcode='122010'">L12100</xsl:when>	<!-- ����ʢ��3���������գ������ͣ� -->
		<xsl:when test="$riskcode='122035'">L12074</xsl:when>	<!-- ����ʢ��9����ȫ���գ������ͣ� -->
		<xsl:when test="$riskcode='L12089'">L12089</xsl:when>	<!-- ����ʢ��1�������գ������ͣ�B�� -->
		<xsl:when test="$riskcode='50002'">50015</xsl:when>	    <!-- �������Ӯ���ռƻ� -->
		<xsl:when test="$riskcode='L12052'">L12052</xsl:when>	<!-- �������Ӯ1������� -->
		<!-- add by duanjz 2015-7-6 PBKINSR-694 ���Ӱ���5�Ų�Ʒ  begin -->
		<!--<xsl:when test="$riskcode='50012'">50012</xsl:when>-->    <!-- ����ٰ���5�ű��ռƻ� -->
		<!-- add by duanjz 2015-7-6 PBKINSR-694 ���Ӱ���5�Ų�Ʒ  end -->
		<xsl:when test="$riskcode='L12087'">L12087</xsl:when>	<!-- �����5����ȫ���գ������ͣ� -->
		<!-- <xsl:when test="$riskcode='L12085'">L12085</xsl:when> -->	<!-- �����2����ȫ���գ������ͣ� -->
		<!-- <xsl:when test="$riskcode='L12086'">L12086</xsl:when> -->	<!-- �����3����ȫ���գ������ͣ� -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- ��ϲ�Ʒ���� -->
<xsl:template name="tran_ContPlanCode">
	<xsl:param name="contPlanCode" />
	<xsl:choose>
		<xsl:when test="$contPlanCode=50002">50015</xsl:when>	<!-- �������Ӯ���ռƻ� -->
		<!-- add by duanjz 2015-7-6 PBKINSR-694 ���Ӱ���5�Ų�Ʒ  begin -->
		<!--<xsl:when test="$contPlanCode=50012">50012</xsl:when>-->	<!-- ����ٰ���5�ű��ռƻ� -->
		<!-- add by duanjz 2015-7-6 PBKINSR-694 ���Ӱ���5�Ų�Ʒ  begin -->
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:template>


</xsl:stylesheet>
