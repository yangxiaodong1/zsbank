<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
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
			<!-- Ͷ��������Ϣ -->
			<xsl:apply-templates select="Base" />
			<!-- ��������˳��� -->
			<OldLogNo>
				<xsl:value-of select="AppNo" />
			</OldLogNo>
			<!-- �������ͷ�ʽ -->
			<GetPolMode></GetPolMode>
			<!-- ְҵ��֪(N/Y) -->
			<JobNotice>
				<xsl:apply-templates select="Insu/IsRiskJob" />
			</JobNotice>
			<!-- ������֪(N/Y)  -->
			<HealthNotice>
				<xsl:apply-templates select="Insu/HealthNotice" />
			</HealthNotice>
			<!--δ���걻�������Ƿ����������չ�˾Ͷ����ʱ��� Y��N��-->
			<PolicyIndicator></PolicyIndicator>
			<!--�ۼ�Ͷ����ʱ���-->
			<InsuredTotalFaceAmount></InsuredTotalFaceAmount>
			<!-- ��Ʒ��� -->
			<ContPlan>
				<!-- ��Ʒ��ϱ��� -->
				<ContPlanCode>
					<xsl:apply-templates select="Risks/RiskCode" mode="contplan"/>
				</ContPlanCode>
			</ContPlan>
			<!-- Ͷ���� -->
			<xsl:apply-templates select="Appl" />
			<!-- ������ -->
			<xsl:apply-templates select="Insu" />
			<!-- ������ -->
			<xsl:apply-templates select="Bnfs" />
			<!-- ������Ϣ -->
			<xsl:apply-templates select="Risks" />
		</Body>
	</xsl:template>

	<!--Ͷ��������Ϣ-->
	<xsl:template match="Base">
        <!-- Ͷ����(ӡˢ)�� -->
		<ProposalPrtNo>
		    <xsl:value-of select ="PolicyApplySerial"/>
		</ProposalPrtNo> 
		<!-- ������ͬӡˢ�� -->
        <ContPrtNo>
            <xsl:value-of select="VchNo"/>
        </ContPrtNo> 
        <!-- Ͷ������ -->
        <PolApplyDate>
            <xsl:value-of select ="ApplyDate"/>
        </PolApplyDate> 
        <!-- �˻����� -->
        <AccName></AccName> 
        <!-- �����˻� -->
        <AccNo></AccNo>
		<!--���������ʸ�֤-->
    	<AgentComCertiCode>
    		<xsl:value-of select="BranchCertNo" />
    	</AgentComCertiCode>
    	<!--������������-->
    	<AgentComName>
    		<xsl:value-of select="BranchName" />
    	</AgentComName>
    	<!--������Ա����-->
    	<TellerName>
    		<xsl:value-of select="Saler" />
    	</TellerName>
    	<!--��Ա�ʸ�֤-->
    	<TellerCertiCode>
    		<xsl:value-of select="SalerCertNo" />
    	</TellerCertiCode>		
	</xsl:template>
	
	<!--Ͷ������Ϣ-->
	<xsl:template match="Appl">
		<Appnt>
			<!-- ���� -->
			<Name>
				<xsl:value-of select="Name" />
			</Name>
			<!-- �Ա� -->
			<Sex>
				<xsl:value-of select="Sex" />
			</Sex>
			<!-- ��������(yyyyMMdd) -->
			<Birthday>
				<xsl:value-of select="Birthday" />
			</Birthday>
			<!-- ֤������ -->
			<IDType>
				<xsl:apply-templates select="IDKind" />
			</IDType>
			<!-- ֤������ -->
			<IDNo>
				<xsl:value-of select="IDCode" />
			</IDNo>
			<!-- ֤����Ч���� -->
			<IDTypeStartDate></IDTypeStartDate>
			<!-- ֤����Чֹ��yyyyMMdd -->
			<IDTypeEndDate>
				<xsl:value-of select="InvalidDate" />
			</IDTypeEndDate>
			<!-- ְҵ���� -->
			<JobCode>
				<xsl:value-of select="JobCode" />
			</JobCode>
			<!-- Ͷ���������� -->
			<Salary>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(AnnualIncome)" />
			</Salary>
			<!-- Ͷ���˼�ͥ������-->
			<FamilySalary></FamilySalary>
			<!-- Ͷ������������-->
			<LiveZone>
				<xsl:apply-templates select="CustSource" />
			</LiveZone>
			<!-- ���� -->
			<Nationality>
				<xsl:apply-templates select="Country" />
			</Nationality>
			<!-- ���(cm) -->
			<Stature></Stature>
			<!-- ����(g) -->
			<Weight></Weight>
			<!-- ���(N/Y) -->
			<MaritalStatus></MaritalStatus>
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
				<xsl:value-of select="Mobile" />
			</Mobile>
			<!-- �̶��绰 -->
			<Phone>
				<xsl:value-of select="Phone" />
			</Phone>
			<!-- �����ʼ�-->
			<Email>
				<xsl:value-of select="Email" />
			</Email>
			<!-- �뱻���˹�ϵ -->
			<RelaToInsured>
				<xsl:apply-templates select="RelaToInsured" />
			</RelaToInsured>
		</Appnt>
	</xsl:template>

	<!--��������Ϣ-->
	<xsl:template match="Insu">
		<Insured>
			<!-- ���� -->
			<Name>
				<xsl:value-of select="Name" />
			</Name>
			<!-- �Ա� -->
			<Sex>
				<xsl:value-of select="Sex" />
			</Sex>
			<!-- ��������(yyyyMMdd) -->
			<Birthday>
				<xsl:value-of select="Birthday" />
			</Birthday>
			<!-- ֤������ -->
			<IDType>
				<xsl:apply-templates select="IDKind" />
			</IDType>
			<!-- ֤������ -->
			<IDNo>
				<xsl:value-of select="IDCode" />
			</IDNo>
			<!-- ֤����Ч���� -->
			<IDTypeStartDate></IDTypeStartDate>
			<!-- ֤����Чֹ�� -->
			<IDTypeEndDate>
				<xsl:value-of select="ValidDate" />
			</IDTypeEndDate>
			<!-- ְҵ���� -->
			<JobCode>
				<xsl:value-of select="JobCode" />
			</JobCode>
			<!-- ���(cm)-->
			<Stature><xsl:value-of select="Tall" /></Stature>
			<!-- ���� -->
			<Nationality>
				<xsl:apply-templates select="Country" />
			</Nationality>
			<!-- ����(kg) -->
			<Weight><xsl:value-of select="Weight" /></Weight>
			<!-- ���(N/Y) -->
			<MaritalStatus></MaritalStatus>
			<!-- ��ϵ��ַ -->
			<Address>
				<xsl:value-of select="Address" />
			</Address>
			<!-- �ʱ� -->
			<ZipCode>
				<xsl:value-of select="ZipCode" />
			</ZipCode>
			<!-- �ֻ��� -->
			<Mobile>
				<xsl:value-of select="Mobile" />
			</Mobile>
			<!-- �绰�� -->
			<Phone>
				<xsl:value-of select="Phone" />
			</Phone>
			<!-- �������� -->
			<Email>
				<xsl:value-of select="Email" />
			</Email>
		</Insured>
	</xsl:template>

	<!--������-->
	<xsl:template match="Bnfs">
		<xsl:for-each select="Bnf">
			<!-- ������ -->
			<Bnf>
				<!-- ���������� 1-���������� -->
				<Type>1</Type>
				<!-- ������˳λ -->
				<Grade>
					<xsl:value-of select="Sequence" />
				</Grade>
				<!-- ������� -->
				<Lot>
					<xsl:value-of select="Prop" />
				</Lot>
				<!-- ���������� -->
				<Name>
					<xsl:value-of select="Name" />
				</Name>
				<!-- �������Ա� -->
				<Sex>
					<xsl:value-of select="Sex" />
				</Sex>
				<!-- ���������� -->
				<Birthday>
					<xsl:value-of select="Birthday" />
				</Birthday>
				<!-- ������֤������ -->
				<IDType>
					<xsl:apply-templates select="IDKind" />
				</IDType>
				<!-- ������֤����� -->
				<IDNo>
					<xsl:value-of select="IDCode" />
				</IDNo>
				<!-- �������뱻�����˹�ϵ -->
				<RelaToInsured>
					<xsl:apply-templates select="RelaToInsured" />
				</RelaToInsured>
			</Bnf>
		</xsl:for-each>
	</xsl:template>

	<!--������Ϣ-->
	<xsl:template match="Risks">
		<!-- ���� -->
		<Risk>
			<!-- ���ֺ� -->
			<RiskCode>
				<xsl:apply-templates select="RiskCode"  mode="risk"/>
			</RiskCode>
			<!-- ���պ� -->
			<MainRiskCode>
				<xsl:apply-templates select="RiskCode"  mode="risk"/>
			</MainRiskCode>
			<!-- ���ũ��Ԫ�� -->
			<Amnt>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Amnt)" />
			</Amnt>
			<!-- ���ѣ�ũ��Ԫ�� -->
			<Prem>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Prem)" />
			</Prem>
			<!-- ���� -->
			<Mult>
				<xsl:value-of select="Share" />
			</Mult>
			<!-- �ɷ�Ƶ�� -->
			<PayIntv>
				<xsl:apply-templates select="PayType" />
			</PayIntv>
			<PayMode></PayMode>
			
			<xsl:choose>
				<!-- ������ -->
				<xsl:when
					test="InsuDueType='6'">
					<InsuYearFlag>A</InsuYearFlag>
					<InsuYear>106</InsuYear>
				</xsl:when>
				<xsl:otherwise>
					<!--  ��������/�����־  -->
					<InsuYearFlag>
						<xsl:apply-templates
							select="InsuDueType" />
					</InsuYearFlag>
					<!--  ��������  -->
					<InsuYear>
						<xsl:value-of select="InsuDueDate" />
					</InsuYear>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:choose>
				<!-- ���� -->
				<xsl:when test="PayType = '1'">
					<PayEndYearFlag>Y</PayEndYearFlag>
					<PayEndYear>1000</PayEndYear>
				</xsl:when>
				<xsl:otherwise><!-- ���� -->
					<!--  ��������/��������  -->
					<PayEndYearFlag>
						<xsl:apply-templates
							select="PayDueType" />
					</PayEndYearFlag>
					<!--  ��������/����  -->
					<PayEndYear>
						<xsl:value-of
							select="PayDueDate" />
					</PayEndYear>
				</xsl:otherwise>
			</xsl:choose>
			<!-- ��ȡ�������ڱ�־ -->
			<GetYearFlag>
				<xsl:apply-templates select="FullBonusGetMode" />
			</GetYearFlag>
			<!-- ��ȡ���� -->
			<GetYear>
				<xsl:value-of select="GetYear" />
			</GetYear>
			<!-- ��ȡƵ�� -->
			<GetIntv>
				<xsl:apply-templates select="GetYearFlag" />
			</GetIntv>
			<AutoPayFlag>
				<xsl:value-of select="AutoPayFlag" />
			</AutoPayFlag>
			<!-- ����ũ�к�����ȡ��ʽ -->
			<BonusGetMode>
				<xsl:apply-templates select="BonusGetMode" />
			</BonusGetMode>
			<!-- ������ȡ��ʽ -->
			<FullBonusGetMode></FullBonusGetMode>
		</Risk>
	</xsl:template>

	<!-- ���������������� -->
	<xsl:template match="InsuDueType">
		<xsl:choose>
			<xsl:when test=".='1'">D</xsl:when><!-- �� -->
			<xsl:when test=".='2'">M</xsl:when><!-- �� -->
			<xsl:when test=".='4'">Y</xsl:when><!-- �� -->
			<xsl:when test=".='5'">A</xsl:when><!-- ���� -->
			<xsl:when test=".='6'">A</xsl:when><!-- ���� -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>	
	
	<!-- �ɷ������������� -->
	<xsl:template  match="PayDueType">
		<xsl:choose>
			<xsl:when test=".='1'">A</xsl:when><!-- ���� -->
			<xsl:when test=".='2'">M</xsl:when><!-- �� -->
			<xsl:when test=".='3'">D</xsl:when><!-- �� -->
			<xsl:when test=".='4'">Y</xsl:when><!-- �� -->
			<xsl:when test=".='5'">A</xsl:when><!-- �� -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ��ȡ������������ -->
	<xsl:template  match="GetYearFlag">
		<xsl:choose>
			<xsl:when test=".='0'">0</xsl:when><!-- ���� -->
			<xsl:when test=".='1'">1</xsl:when><!-- ���� -->
			<xsl:when test=".='2'">3</xsl:when><!-- ���� -->
			<xsl:when test=".='3'">6</xsl:when><!-- ������ -->
			<xsl:when test=".='4'">12</xsl:when><!-- ���� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>	

	<!--��ȡ�������ڱ�־ -->
	<xsl:template  match="FullBonusGetMode">
		<xsl:choose>
			<xsl:when test=".='0'">Y</xsl:when><!-- ���� -->
			<xsl:when test=".='1'">A</xsl:when><!-- ������ -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>	
	
	<!-- �ɷѷ�ʽ��Ƶ�Σ� -->
	<xsl:template match="PayType">
		<xsl:choose>
		    <xsl:when test=".='0'">-1</xsl:when><!--  ������ -->
			<xsl:when test=".='1'">0</xsl:when><!-- ���� -->
			<xsl:when test=".='2'">1</xsl:when><!-- �½� -->
			<xsl:when test=".='3'">3</xsl:when><!-- ���� -->
			<xsl:when test=".='4'">6</xsl:when><!-- ���꽻 -->
			<xsl:when test=".='5'">12</xsl:when><!-- �꽻 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
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
    
	<!-- ��ϵ -->
	<xsl:template match="RelaToInsured">
		<xsl:choose>
			<xsl:when test=".='01'">00</xsl:when><!-- ���� -->
			<xsl:when test=".='02'">02</xsl:when><!-- ��ż -->
			<xsl:when test=".='03'">02</xsl:when><!-- ��ż -->
			<xsl:when test=".='04'">01</xsl:when><!-- ��ĸ -->
			<xsl:when test=".='05'">01</xsl:when><!-- ��ĸ -->
			<xsl:when test=".='06'">03</xsl:when><!-- ��Ů -->
			<xsl:when test=".='07'">03</xsl:when><!-- ��Ů -->
			<xsl:otherwise>04</xsl:otherwise><!-- ���� -->
		</xsl:choose>
	</xsl:template>

	<!-- ����ת�� -->
	<xsl:template match="Country">
		<xsl:choose>
			<xsl:when test=".='156'">CHN</xsl:when><!-- �Ї� -->
			<xsl:when test=".='344'">CHN</xsl:when><!-- �Ї���� -->
			<xsl:when test=".='158'">CHN</xsl:when><!-- �Ї��_�� -->
			<xsl:when test=".='446'">CHN</xsl:when><!-- �Ї����� -->
			<xsl:when test=".='392'">JP</xsl:when><!-- �ձ� -->
			<xsl:when test=".='840'">US</xsl:when><!-- ���� -->
			<xsl:when test=".='643'">RU</xsl:when><!-- ����˹ -->
			<xsl:when test=".='826'">GB</xsl:when><!-- Ӣ�� -->
			<xsl:otherwise>OTH</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<!--������� -->
	<xsl:template match="HealthNotice">
		<xsl:choose>
			<xsl:when test=".='0'">N</xsl:when><!-- �� -->
			<xsl:when test=".='1'">Y</xsl:when><!-- �� -->
			<xsl:otherwise>N</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--ְҵ��֪ -->
	<xsl:template match="IsRiskJob">
		<xsl:choose>
			<xsl:when test=".='0'">N</xsl:when><!-- �� -->
			<xsl:when test=".='1'">Y</xsl:when><!-- �� -->
			<xsl:otherwise>N</xsl:otherwise>
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
	<xsl:template  match="RiskCode"  mode="risk">
		<xsl:choose>
			<xsl:when test=".='122046'">50001</xsl:when><!-- ������Ӯ1���ײ� -->
			<xsl:when test=".='50002'">50002</xsl:when><!-- ������Ӯ���ռƻ� -->
			<xsl:when test=".='122012'">122012</xsl:when><!-- ����ʢ��2���������գ������ͣ�  -->
			<!-- <xsl:when test=".='122010'">122010</xsl:when> --><!-- ����ʢ��3���������գ������ͣ�  -->
			<xsl:when test=".='122035'">122035</xsl:when><!-- ����ʢ��9����ȫ���գ������ͣ�  -->
			<xsl:when test=".='L12089'">L12089</xsl:when><!-- ����ʢ��1���������գ������ͣ�B��  -->
			<xsl:when test=".='L12080'">L12080</xsl:when><!-- ����ʢ��1���������գ������ͣ�  -->
			<xsl:when test=".='L12085'">L12085</xsl:when><!-- �����2����ȫ���գ������ͣ�  -->
			
			<xsl:when test=".='50015'">50015</xsl:when><!-- ������Ӯ���ռƻ� -->
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
			
			<!-- ����ٰ���5�ű��ռƻ�50012,����ٰ���5�������L12070,����ӳ�������5����ȫ���գ������ͣ�L12071 -->
			<xsl:when test=".='50012'">50012</xsl:when><!-- ����ٰ���5�ű��ռƻ� -->
			
			<!-- �����5����ȫ���գ������ͣ�L12087 -->
			<xsl:when test=".='L12087'">L12087</xsl:when><!-- �����5����ȫ���գ������ͣ�  -->
			
			<!-- �����3����ȫ���գ������ͣ�L12086 -->
			<xsl:when test=".='L12086'">L12086</xsl:when>
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- �ײʹ��� -->
	<xsl:template  match="RiskCode"  mode="contplan">
		<xsl:choose>
			<!-- 50001-�������Ӯ1����ȫ�������:���գ�122046 - �������Ӯ1����ȫ����,�����գ�122047 - ����ӳ�����Ӯ��ȫ���� -->
			<xsl:when test=".=122046">50001</xsl:when>
			<!-- 50002(50015): 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�122048(L12081)-����������������գ������ͣ���� -->
			<xsl:when test=".='50002'">50002</xsl:when>
			<xsl:when test=".='50015'">50015</xsl:when>
			<!-- ����ٰ���5�ű��ռƻ�50012,����ٰ���5�������L12070,����ӳ�������5����ȫ���գ������ͣ�L12071 -->
			<xsl:when test=".='50012'">50012</xsl:when><!-- ����ٰ���5�ű��ռƻ� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ������ȡ��ʽ-->
	<xsl:template match="BonusGetMode">
		<xsl:choose>
			<xsl:when test=".='2'">1</xsl:when><!-- �ۻ���Ϣ -->
			<xsl:when test=".='1'">3</xsl:when><!-- �ֽ����� -->
			<xsl:when test=".=''"></xsl:when><!-- Ĭ�� -->
			<xsl:otherwise>9</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>