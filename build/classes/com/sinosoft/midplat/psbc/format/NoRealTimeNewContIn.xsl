<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/INSUREQ">
		<TranData>
			<!-- ����ͷ -->
			<xsl:apply-templates select="MAIN" />

			<!-- ������ -->
			<Body>
			   <ProposalPrtNo><xsl:value-of select="MAIN/APPLNO" /></ProposalPrtNo><!-- Ͷ����(ӡˢ)�� -->
			   <PolApplyDate>
				   <xsl:value-of select="MAIN/TB_DATE" />
			   </PolApplyDate><!-- Ͷ������ -->
			   <AgentComName>
				   <xsl:value-of select="MAIN/BRNM" />
			   </AgentComName><!--������������-->
			   <AgentComCertiCode></AgentComCertiCode><!--���������ʸ�֤-->
			   <TellerName></TellerName><!--����������Ա����-->
			   <TellerCertiCode></TellerCertiCode><!--����������Ա�ʸ�֤-->
			   <AccName></AccName><!-- �˻����� -->
			   <AccNo>
				   <xsl:value-of select="TBR/PAYACC" />
			   </AccNo><!-- �����˻� -->
			   <!-- ��Ʒ��� -->
			   <ContPlan>
			 	   <!-- ��Ʒ��ϱ��� -->
				   <ContPlanCode>
					   <xsl:apply-templates select="MAIN/PRODUCTID" mode="contplan" />
				   </ContPlanCode>
			   </ContPlan>
			   <!-- Ͷ���� -->
			   <xsl:apply-templates select="TBR" />
			   <!-- ���� -->
			   <Risk>
				   <!-- ���ֺ� -->
				   <RiskCode>
					   <xsl:apply-templates select="MAIN/PRODUCTID" mode="risk" />
				   </RiskCode>
				   <!-- ���պ� -->
				   <MainRiskCode>
					   <xsl:apply-templates select="MAIN/PRODUCTID" mode="risk" />
				   </MainRiskCode>
				   <!-- ���ѣ���λ Ԫ?�� -->
				   <Prem>
					  <xsl:value-of select="TBR/AMT_PREMIUM" />
				   </Prem>
				   <Amnt></Amnt>
				   <Mult></Mult><!-- Ͷ������ -->
				   <PayIntv></PayIntv><!-- �ɷ�Ƶ�� -->
				   <InsuYearFlag></InsuYearFlag><!-- �������������־ -->
				   <InsuYear></InsuYear><!-- ������������ ������д��106-->
				   <PayEndYearFlag></PayEndYearFlag><!-- �ɷ����������־ -->
				   <PayEndYear></PayEndYear><!-- �ɷ��������� ����д��1000-->
			  </Risk>
		   </Body>

		</TranData>
	</xsl:template>

	<!--����ͷ��Ϣ-->
	<xsl:template name="Head" match="MAIN">
		<Head>
			<TranDate>
				<xsl:value-of select="TRANSRDATE" />
			</TranDate>
			<TranTime>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.DateUtil.getCur6Time()" />
			</TranTime>
			<TellerNo>
				<xsl:value-of select="TELLERNO" />
			</TellerNo>
			<TranNo>
				<xsl:value-of select="TRANSRNO" />
			</TranNo>
			<NodeNo>
				<xsl:value-of select="ZONENO" />
				<xsl:value-of select="BRNO" />
			</NodeNo>
			<xsl:copy-of select="../Head/*" />
			<BankCode>
				<xsl:value-of select="../Head/TranCom/@outcode" />
			</BankCode>
		</Head>
	</xsl:template>
		
	<!--Ͷ������Ϣ-->
	<xsl:template match="TBR">
		<Appnt>
			<!-- ���� -->
			<Name>
				<xsl:value-of select="TBR_NAME" />
			</Name>
			<!-- �Ա� -->
			<Sex></Sex>
			<!-- ��������(yyyyMMdd) -->
			<Birthday></Birthday>
			<!-- ֤������ -->
			<IDType>
				<xsl:apply-templates select="TBR_IDTYPE" />
			</IDType>
			<!-- ֤������ -->
			<IDNo>
				<xsl:value-of select="TBR_IDNO" />
			</IDNo>
			<!-- Ͷ������������-->
			<LiveZone></LiveZone>
			<!-- ��ַ -->
			<Address></Address>
			<!-- �ʱ� -->
			<ZipCode></ZipCode>
			<!-- �ƶ��绰 -->
			<Mobile>
				<xsl:value-of select="TBR_MOBILE" />
			</Mobile>
			<!-- �̶��绰 -->
			<Phone>
				<xsl:value-of select="TBR_TEL" />
			</Phone>
		</Appnt>
	</xsl:template>

	<!-- ֤������ -->
	<xsl:template match="TBR_IDTYPE">
		<xsl:choose>
			<xsl:when test=".='1'">0</xsl:when><!-- ���֤ -->
			<xsl:when test=".='2'">2</xsl:when><!-- ����֤ -->
			<xsl:when test=".='3'">1</xsl:when><!-- ���� -->
			<xsl:when test=".='4'">4</xsl:when><!-- ����֤ -->
			<xsl:otherwise>8</xsl:otherwise><!-- ���� -->
		</xsl:choose>
	</xsl:template>

	<!-- ���ִ��� -->
	<xsl:template match="PRODUCTID" mode="risk">
		<xsl:choose>
			<xsl:when test=".='L12074'">L12074</xsl:when><!-- ����ʢ��9����ȫ���գ��ֺ��ͣ� -->
			<xsl:when test=".='122006'">122006</xsl:when><!-- ����۱���2����ȫ���գ��ֺ��ͣ�A�� -->
			<xsl:when test=".='122009'">122009</xsl:when><!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A�� -->
			<xsl:when test=".='122012'">L12079</xsl:when><!-- ����ʢ��2���������գ������ͣ�-->
			<xsl:when test=".='122010'">L12100</xsl:when><!-- ����ʢ��3���������գ������ͣ�-->		
			<xsl:when test=".='50003'">50016</xsl:when><!-- 50003(50016)-��������ᱣ�ռƻ� -->	
			<xsl:when test=".='L12084'">L12084</xsl:when><!-- �����Ӯ2�������A��  -->
			<xsl:when test=".='L12087'">L12087</xsl:when><!-- �����5����ȫ���գ������ͣ�-->
			<!--<xsl:when test=".='L12094'">L12094</xsl:when>--><!-- �����Ӯ3�������A��-->	
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �ײʹ��� -->
	<xsl:template match="PRODUCTID" mode="contplan">
		<xsl:choose>
			<xsl:when test=".='50003'">50016</xsl:when><!-- 50003(50016)-��������ᱣ�ռƻ� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>


</xsl:stylesheet>