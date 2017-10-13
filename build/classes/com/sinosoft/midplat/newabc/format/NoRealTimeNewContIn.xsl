<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="ABCB2I">
		<TranData>
			<!-- ����ͷ -->
			<xsl:apply-templates select="Header" />

			<!-- ������ -->
			<xsl:apply-templates select="App/Req" />

		</TranData>
	</xsl:template>

	<!--����ͷ��Ϣ-->
	<xsl:template match="Header">
		<!--������Ϣ-->
		<Head>
			<!-- ���н������� -->
			<TranDate>
				<xsl:value-of select="TransDate" />
			</TranDate>
			<!-- ����ʱ�� ũ�в�������ʱ�� ȡϵͳ��ǰʱ�� -->
			<TranTime>
				<xsl:value-of select="TransTime" />
			</TranTime>
			<!-- ��Ա���� -->
			<TellerNo>
				<xsl:value-of select="Tlid" />
			</TellerNo>
			<!-- ���н�����ˮ�� -->
			<TranNo>
				<xsl:value-of select="SerialNo" />
			</TranNo>
			<!-- ������+������ -->
			<NodeNo>
				<xsl:value-of select="ProvCode" />
				<xsl:value-of select="BranchNo" />
			</NodeNo>
			<BankCode>
				<xsl:value-of select="../Head/TranCom/@outcode" />
			</BankCode>
			<!-- YBT��֯�Ľڵ���Ϣ -->
			<xsl:copy-of select="../Head/*" />
		</Head>
	</xsl:template>

	<!--��������Ϣ-->
	<xsl:template match="App/Req">
		<Body>
			<ProposalPrtNo>
				<xsl:value-of select="PolicyApplyNo" />
			</ProposalPrtNo><!-- Ͷ����(ӡˢ)�� -->
			<PolApplyDate>
				<xsl:value-of select="../../Header/TransDate" />
			</PolApplyDate><!-- Ͷ������ -->
			<AgentComName>
				<xsl:value-of select="Base/BranchName" />
			</AgentComName><!--������������-->
			<AgentComCertiCode>
				<xsl:value-of select="Base/BranchCertNo" />
			</AgentComCertiCode><!--���������ʸ�֤-->
			<TellerName>
				<xsl:value-of select="Base/Saler" />
			</TellerName><!--����������Ա����-->
			<TellerCertiCode>
				<xsl:value-of select="Base/SalerCertNo" />
			</TellerCertiCode><!--����������Ա�ʸ�֤-->
			<AccName></AccName><!-- �˻����� -->
			<AccNo>
				<xsl:value-of select="AccNo" />
			</AccNo><!-- �����˻� -->
			<!-- ��Ʒ��� -->
			<ContPlan>
				<!-- ��Ʒ��ϱ��� -->
				<ContPlanCode>
					<xsl:apply-templates select="RiskCode" mode="contplan" />
				</ContPlanCode>
			</ContPlan>
			<!-- Ͷ���� -->
			<xsl:apply-templates select="Appl" />
			<!-- ���� -->
			<Risk>
				<!-- ���ֺ� -->
				<RiskCode>
					<xsl:apply-templates select="RiskCode" mode="risk" />
				</RiskCode>
				<!-- ���պ� -->
				<MainRiskCode>
					<xsl:apply-templates select="RiskCode" mode="risk" />
				</MainRiskCode>
				<!-- ���ѣ�ũ�� Ԫ�� -->
				<Prem>
					<xsl:value-of
						select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Prem)" />
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
	</xsl:template>

	<!--Ͷ������Ϣ-->
	<xsl:template match="Appl">
		<Appnt>
			<!-- ���� -->
			<Name>
				<xsl:value-of select="Name" />
			</Name>
			<!-- �Ա� -->
			<Sex></Sex>
			<!-- ��������(yyyyMMdd) -->
			<Birthday></Birthday>
			<!-- ֤������ -->
			<IDType>
				<xsl:apply-templates select="IDKind" />
			</IDType>
			<!-- ֤������ -->
			<IDNo>
				<xsl:value-of select="IDCode" />
			</IDNo>
			<!-- Ͷ������������-->
			<LiveZone>
				<xsl:apply-templates select="CustSource" />
			</LiveZone>
			<!-- ��ַ -->
			<Address>
				<xsl:value-of select="Address" />
			</Address>
			<!-- �ʱ� -->
			<ZipCode>
				<xsl:value-of select="ZipCode" />
			</ZipCode>
			<!-- �ƶ��绰 -->
			<Mobile>
				<xsl:value-of select="CellPhone" />
			</Mobile>
			<!-- �̶��绰 -->
			<Phone>
				<xsl:value-of select="Phone" />
			</Phone>
		</Appnt>
	</xsl:template>

	<!-- ֤������ -->
	<xsl:template match="IDKind">
		<xsl:choose>
			<xsl:when test=".='110001'">0</xsl:when><!--�������֤                -->
			<xsl:when test=".='110002'">0</xsl:when><!--�غž������֤            -->
			<xsl:when test=".='110003'">0</xsl:when><!--��ʱ�������֤            -->
			<xsl:when test=".='110004'">0</xsl:when><!--�غ���ʱ�������֤        -->
			<xsl:when test=".='110005'">5</xsl:when><!--���ڲ�                    -->
			<xsl:when test=".='110006'">5</xsl:when><!--�غŻ��ڲ�                -->
			<xsl:when test=".='110023'">1</xsl:when><!--�л����񹲺͹�����        -->
			<xsl:when test=".='110024'">1</xsl:when><!--�غ��л����񹲺͹�����    -->
			<xsl:when test=".='110025'">1</xsl:when><!--�������                  -->
			<xsl:when test=".='110026'">1</xsl:when><!--�غ��������              -->
			<xsl:when test=".='110027'">2</xsl:when><!--����֤                    -->
			<xsl:when test=".='110028'">2</xsl:when><!--�غž���֤                -->
			<xsl:when test=".='110029'">2</xsl:when><!--��ְ�ɲ�֤                -->
			<xsl:when test=".='110030'">2</xsl:when><!--�غ���ְ�ɲ�֤            -->
			<xsl:otherwise>8</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--�ͻ���Դ -->
	<xsl:template match="CustSource">
		<xsl:choose>
			<xsl:when test=".='0'">1</xsl:when><!-- ���� -->
			<xsl:when test=".='1'">2</xsl:when><!-- ũ�� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ���ִ��� -->
	<xsl:template match="RiskCode" mode="risk">
		<xsl:choose>
			<xsl:when test=".='122046'">50001</xsl:when><!-- ������Ӯ1���ײ� -->
			<xsl:when test=".='50002'">50002</xsl:when><!-- ������Ӯ�����ײͼƻ� -->
			<xsl:when test=".='122012'">122012</xsl:when><!-- ����ʢ��2���������գ������ͣ�  -->
			<!-- <xsl:when test=".='122010'">122010</xsl:when> --> <!-- ����ʢ��3���������գ������ͣ�  -->
			<xsl:when test=".='122035'">122035</xsl:when><!-- ����ʢ��9����ȫ���գ������ͣ�  -->
			<xsl:when test=".='L12089'">L12089</xsl:when><!-- ����ʢ��1����ȫ���գ������ͣ�B��  -->
			<xsl:when test=".='L12080'">L12080</xsl:when><!-- ����ʢ��1����ȫ���գ������ͣ�  -->
			<xsl:when test=".='L12085'">L12085</xsl:when><!-- �����2����ȫ���գ������ͣ�  -->
			
			<xsl:when test=".='50015'">50015</xsl:when><!-- ������Ӯ�����ײͼƻ� -->
			<xsl:when test=".='L12079'">L12079</xsl:when><!-- ����ʢ��2���������գ������ͣ�  -->
			<!-- ʢ��3�Ų�Ʒ������start -->
			<!-- <xsl:when test=".='L12078'">L12078</xsl:when> --><!-- ����ʢ��3���������գ������ͣ�  -->
			<xsl:when test=".='122010'">L12100</xsl:when><!-- ����ʢ��3���������գ������ͣ�  -->
			<xsl:when test=".='L12078'">L12100</xsl:when><!-- ����ʢ��3���������գ������ͣ�  -->
			<!-- ʢ��3�Ų�Ʒ������end -->
			<xsl:when test=".='L12074'">L12074</xsl:when><!-- ����ʢ��9����ȫ���գ������ͣ�  -->
			
			<xsl:when test=".='122009'">122009</xsl:when><!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A��  -->
			<xsl:when test=".='122036'">122036</xsl:when><!-- ����ƽ�6����ȫ���գ��ֺ��ͣ�A��  -->

			<xsl:when test=".='122006'">122006</xsl:when><!-- ����۱���2����ȫ���գ��ֺ��ͣ�A��  -->
			<xsl:when test=".='122008'">122008</xsl:when><!-- ���������1����������(������)  -->
			<xsl:when test=".='122002'">122002</xsl:when><!-- ����ƽ�2����ȫ����(�ֺ���)A��  -->
			<xsl:when test=".='122005'">122005</xsl:when><!-- ����ƽ�3����ȫ����(�ֺ���)A��  -->
			
			<xsl:when test=".='50012'">50012</xsl:when><!-- ����ٰ���5�ű��ռƻ�50012 -->
			<xsl:when test=".='L12087'">L12087</xsl:when><!-- �����5����ȫ���գ������ͣ�  -->
			
			<xsl:when test=".='L12086'">L12086</xsl:when><!-- �����3����ȫ���գ������ͣ�  -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �ײʹ��� -->
	<xsl:template match="RiskCode" mode="contplan">
		<xsl:choose>
			<xsl:when test=".='122046'">50001</xsl:when><!-- ���� �ײ� -->
			<!-- �����ո��죬���ָĴ�������漰ʢ������Ӯϵ�У����в��䱣�չ�˾�������ִ���仯 -->
			<xsl:when test=".='50002'">50015</xsl:when><!-- ������Ӯ�����ײͼƻ� -->
			
			<!-- ����ٰ���5�ű��ռƻ�50012,����ٰ���5�������L12070,����ӳ�������5����ȫ���գ������ͣ�L12071 -->
			<xsl:when test=".='50012'">50012</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>


</xsl:stylesheet>