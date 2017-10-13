<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/REQUEST">
<TranData>    
	<Head>
	    <!-- �������� -->
	    <TranDate><xsl:value-of select="BUSI/TRSDATE"/></TranDate>
	    <!-- ����ʱ�� -->
        <TranTime><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur6Time()"/></TranTime>
        <!-- ��Ա���� -->
        <TellerNo><xsl:value-of select="DIST/TELLER"/></TellerNo>
        <!-- ������ˮ�� -->
        <TranNo><xsl:value-of select="BUSI/TRANS"/></TranNo>
        <!-- ������+������� -->
        <NodeNo>
             <xsl:value-of select="DIST/ZONE"/><xsl:value-of select="DIST/DEPT"/>
        </NodeNo>
        <xsl:copy-of select="Head/*"/>
        <!-- ���׵�λ -->
        <BankCode><xsl:value-of select="Head/TranCom/@outcode"/></BankCode>
    </Head>
	
	<Body>
		<ProposalPrtNo><xsl:value-of select="BUSI/CONTENT/MAIN/APPNO" /></ProposalPrtNo> <!-- Ͷ����(ӡˢ)�� -->
		<ContPrtNo></ContPrtNo> <!-- ������ͬӡˢ�� -->
		<PolApplyDate><xsl:value-of select="BUSI/CONTENT/MAIN/APPDATE" /></PolApplyDate> <!-- Ͷ������ -->		
		<!--������������-->
		<AgentComName><xsl:value-of select="DIST/BankBranchName"/></AgentComName>
		<!--����������Ա����-->
		<SellerNo><xsl:value-of select="DIST/FINANCIALID"/></SellerNo>
		<TellerName><xsl:value-of select="DIST/FINANCIALNAME"/></TellerName>		
		<AccName><xsl:value-of select="BUSI/CONTENT/TBR/NAME" /></AccName> <!-- �˻����� -->
		<AccNo><xsl:value-of select="BUSI/CONTENT/MAIN/PAYACC" /></AccNo> <!-- �����˻� -->
		<!-- �������ͷ�ʽ -->
		<GetPolMode>
		    <xsl:call-template name="tran_getPolMode">
			   <xsl:with-param name="getPolMode">
				  <xsl:value-of select="BUSI/CONTENT/MAIN/DELIVER"/>
			   </xsl:with-param>
		    </xsl:call-template>
		</GetPolMode> 
		<JobNotice><xsl:value-of select="BUSI/CONTENT/INFORM1/Occupation" /></JobNotice>   <!-- ְҵ��֪(N/Y) -->
		<HealthNotice><xsl:value-of select="BUSI/CONTENT/HEALTH/NOTICE" /></HealthNotice> <!-- ������֪(N/Y)  -->	
		<xsl:variable name="InsuredTotalFaceAmount"><xsl:value-of select="BUSI/CONTENT/INFORM1/JuvDieAssured*0.01"/></xsl:variable>
		<!-- δ���걻�������Ƿ����������չ�˾Ͷ����ʱ��� Y��N�� -->
		<PolicyIndicator>
			<xsl:choose>
			    <xsl:when test="$InsuredTotalFaceAmount>0">Y</xsl:when>
			    <xsl:otherwise>N</xsl:otherwise>
		    </xsl:choose>
		</PolicyIndicator>
		<!-- �ۼ�Ͷ����ʱ��� �������ֶαȽ����⣬��λ�ǰ�Ԫ -->
		<InsuredTotalFaceAmount><xsl:value-of select="$InsuredTotalFaceAmount" /></InsuredTotalFaceAmount>
        <!-- ��Ʒ��� -->
        <ContPlan>
        	<!-- ��Ʒ��ϱ��� -->
			<ContPlanCode>
				<xsl:call-template name="tran_ContPlanCode">
					<xsl:with-param name="contPlanCode">
						<xsl:value-of select="BUSI/CONTENT/PTS/PT/ID" />
					</xsl:with-param>
				</xsl:call-template>
			</ContPlanCode>
			
			<!-- ��Ʒ��Ϸ��� -->
			<ContPlanMult>
				<xsl:value-of select="BUSI/CONTENT/PTS/PT/UNIT" />
			</ContPlanMult>
        </ContPlan>
        
		<!-- Ͷ���� -->
		<xsl:apply-templates select="BUSI/CONTENT/TBR" />
		
		<!-- ������ -->
		<xsl:apply-templates select="BUSI/CONTENT/BBR" />		
		
		<!-- ������ -->
		<xsl:for-each select="BUSI/CONTENT/SYR">
			<xsl:choose>
				<xsl:when test="NAME!=''">
					<Bnf>
						<Type>1</Type>	<!-- Ĭ��Ϊ��1-��������ˡ� -->
					    <Grade><xsl:value-of select="ORDER" /></Grade> <!-- ����˳�� -->
					    <Name><xsl:value-of select="NAME" /></Name> <!-- ���� -->
					    <Sex>
					       <xsl:call-template name="tran_sex">
			                  <xsl:with-param name="sex">
				                 <xsl:value-of select="SEX"/>
			                  </xsl:with-param>
		                   </xsl:call-template>
					    </Sex> <!-- �Ա� -->
					    <Birthday><xsl:value-of select="BIRTH" /></Birthday> <!-- ��������(yyyyMMdd) -->
					    <!-- ֤������ -->
					    <IDType>
					        <xsl:call-template name="tran_idtype">
								<xsl:with-param name="idtype">
									<xsl:value-of select="IDTYPE"/>
								</xsl:with-param>
							</xsl:call-template>
					    </IDType> 
					    <IDNo><xsl:value-of select="IDNO" /></IDNo> <!-- ֤������ -->
					    <!-- �뱻���˹�ϵ -->
					    <RelaToInsured>
					        <xsl:call-template name="tran_relation">
								<xsl:with-param name="relation">
									<xsl:value-of select="BBR_RELA"/>
								</xsl:with-param>
							</xsl:call-template>
					    </RelaToInsured> 
					    <Lot><xsl:value-of select="RATIO" /></Lot> <!-- �������(�������ٷֱ�) -->
					</Bnf>
				</xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		
		<!-- ������Ϣ -->
		<xsl:apply-templates select="BUSI/CONTENT/PTS/PT" />			
	</Body>
</TranData>
</xsl:template>

<!-- Ͷ���� -->
<xsl:template name="Appnt" match="TBR">
<Appnt>
	<Name><xsl:value-of select="NAME" /></Name> <!-- ���� -->
	<Sex><!-- �Ա� -->
		<xsl:call-template name="tran_sex">
			<xsl:with-param name="sex">
				<xsl:value-of select="SEX"/>
			</xsl:with-param>
		</xsl:call-template>
	</Sex>
	<Birthday><xsl:value-of select="BIRTH" /></Birthday><!-- ��������(yyyyMMdd) -->
	<IDType><!-- ֤������ -->
		<xsl:call-template name="tran_idtype">
			<xsl:with-param name="idtype">
				<xsl:value-of select="IDTYPE"/>
			</xsl:with-param>
		</xsl:call-template>
	</IDType>
	<IDNo><xsl:value-of select="IDNO" /></IDNo><!-- ֤������ -->
	<IDTypeStartDate><xsl:value-of select="IDVALIDATE2" /></IDTypeStartDate > <!-- ֤����Ч���� -->
    <IDTypeEndDate><xsl:value-of select="IDVALIDATE" /></IDTypeEndDate > <!-- ֤����Чֹ�� ��Ҫȷ��������Ч������δ�ֵ��-->
	<!-- ְҵ���� ��-->
	<JobCode>
	    <xsl:call-template name="tran_jobcode">
			<xsl:with-param name="jobcode">
				<xsl:value-of select="Occupation"/>
			</xsl:with-param>
		</xsl:call-template>
	</JobCode>
	<!-- Ͷ���������룬���е�λ�֣����չ�˾��λ�� -->
	<Salary>
	    <xsl:value-of select="IncomeYear" />
	</Salary>
	<!-- �ͻ����� -->
	<LiveZone>
		<xsl:apply-templates select="Resident" />
	</LiveZone>
	<!-- ���� -->
    <Nationality>
        <xsl:apply-templates select="COUNTRY_CODE" />
    </Nationality> 
    <Stature></Stature> <!-- ���(cm) -->
    <Weight></Weight> <!-- ����(kg) -->
    <!-- ���(N/Y) -->
    <MaritalStatus></MaritalStatus>
    <Address><xsl:value-of select="ADDR" /></Address> <!-- ��ַ -->
    <ZipCode><xsl:value-of select="ZIP" /></ZipCode> <!-- �ʱ� -->
    <Mobile><xsl:value-of select="MP" /></Mobile> <!-- �ƶ��绰 -->
    <Phone><xsl:value-of select="TEL" /></Phone> <!-- �̶��绰 -->
    <Email><xsl:value-of select="EMAIL" /></Email> <!-- �����ʼ�-->
    <RelaToInsured>
    	<xsl:call-template name="tran_relation">
			<xsl:with-param name="relation">
				<xsl:value-of select="BBR_RELA"/>
			</xsl:with-param>
		</xsl:call-template>
    </RelaToInsured> <!-- �뱻���˹�ϵ -->
</Appnt>
</xsl:template>

<!-- ������ -->
<xsl:template name="Insured" match="BBR">
<Insured>
	<Name><xsl:value-of select="NAME" /></Name> <!-- ���� -->
    <Sex><!-- �Ա� -->
        <xsl:call-template name="tran_sex">
			<xsl:with-param name="sex">
				<xsl:value-of select="SEX"/>
			</xsl:with-param>
		</xsl:call-template>
	</Sex>
    <Birthday><xsl:value-of select="BIRTH" /></Birthday> <!-- ��������(yyyyMMdd) -->
    <IDType> <xsl:call-template name="tran_idtype">
		    <xsl:with-param name="idtype">
				<xsl:value-of select="IDTYPE"/>
			</xsl:with-param>
		</xsl:call-template>
	</IDType> <!-- ֤������ -->
    <IDNo><xsl:value-of select="IDNO" /></IDNo> <!-- ֤������ -->
    <IDTypeStartDate><xsl:value-of select="IDVALIDATE2" /></IDTypeStartDate > <!-- ֤����Ч���� -->
    <IDTypeEndDate><xsl:value-of select="IDVALIDATE" /></IDTypeEndDate > <!-- ֤����Чֹ�� -->
    <!-- ְҵ���� -->
    <JobCode>        
        <xsl:call-template name="tran_jobcode">
			<xsl:with-param name="jobcode">
				<xsl:value-of select="Occupation"/>
			</xsl:with-param>
		</xsl:call-template>
    </JobCode>
    <Stature></Stature> <!-- ���(cm)-->
    <!-- ����-->
    <Nationality>
        <xsl:apply-templates select="COUNTRY_CODE" />
    </Nationality> 
    <Weight></Weight> <!-- ����(kg) -->
    <MaritalStatus></MaritalStatus> <!-- ���(N/Y) -->
    <Address><xsl:value-of select="ADDR" /></Address> <!-- ��ַ -->
    <ZipCode><xsl:value-of select="ZIP" /></ZipCode> <!-- �ʱ� -->
    <Mobile><xsl:value-of select="MP" /></Mobile> <!-- �ƶ��绰 -->
    <Phone><xsl:value-of select="TEL" /></Phone> <!-- �̶��绰 -->
    <Email><xsl:value-of select="EMAIL" /></Email> <!-- �����ʼ�-->
</Insured>
</xsl:template>

<!-- ������Ϣ  -->
<xsl:template name="Risk" match="PT">
<Risk>
    <!-- ���ִ��� -->
	<RiskCode>
	    <xsl:call-template name="tran_riskcode">
			<xsl:with-param name="riskcode" select="ID" />
		</xsl:call-template>
	</RiskCode>
	<MainRiskCode>
		<xsl:call-template name="tran_riskcode">
			<xsl:with-param name="riskcode" select="ID" />
		</xsl:call-template>
	</MainRiskCode><!-- �������ִ��� -->
	<RiskType></RiskType><!-- �������� -->
	<Amnt><xsl:value-of select="AMNT"/></Amnt><!-- ����(��) -->
	<Prem><xsl:value-of select="PREMIUM"/></Prem><!-- ���շ�(��) -->
	<Mult><xsl:value-of select="UNIT"/></Mult><!-- Ͷ������ -->
	<!-- �ɷ�Ƶ�� -->
	<PayIntv>
		<xsl:call-template name="tran_PayIntv">
			<xsl:with-param name="payintv">
				<xsl:value-of select="CRG_T"/>
			</xsl:with-param>
		</xsl:call-template>
	</PayIntv>
	<!-- �ɷ���ʽ -->
	<PayMode></PayMode>
	<!-- �������������־ -->
	<InsuYearFlag>
		<xsl:call-template name="tran_InsuYearFlag">
			<xsl:with-param name="insuyearflag">
				<xsl:value-of select="COVER_T" />
			</xsl:with-param>
		</xsl:call-template>
	</InsuYearFlag>
	<InsuYear><!-- ������ -->
		<xsl:if test="COVER_T=1">106</xsl:if>
		<xsl:if test="COVER_T!=1"><xsl:value-of select="COVER_Y" /></xsl:if>
	</InsuYear>	
	<xsl:if test="CRG_T = 1"><!-- ���� -->
		<PayEndYearFlag>Y</PayEndYearFlag>
		<PayEndYear>1000</PayEndYear>
	</xsl:if>
	<!-- �ɷ����������־ -->
	<xsl:if test="CRG_T != 1">
		<PayEndYearFlag>
		   <xsl:call-template name="tran_PayEndYearFlag">
			  <xsl:with-param name="payendyearflag">
				<xsl:value-of select="CRG_T" />
			</xsl:with-param>
		</xsl:call-template>
	    </PayEndYearFlag>
	    <!-- �ɷ��������� -->
		<PayEndYear><xsl:value-of select="CRG_Y"/></PayEndYear>
	</xsl:if>

	<BonusGetMode></BonusGetMode><!-- ������ȡ��ʽ -->
    <FullBonusGetMode></FullBonusGetMode><!-- ������ȡ����ȡ��ʽ -->	
	<GetYearFlag></GetYearFlag><!-- ��ȡ�������ڱ�־ -->
	<GetYear></GetYear><!-- ��ȡ���� -->
	<GetIntv></GetIntv><!-- ��ȡ��ʽ -->
	<GetBankCode></GetBankCode><!-- ��ȡ���б��� -->
	<GetBankAccNo></GetBankAccNo><!-- ��ȡ�����˻� -->
	<GetAccName></GetAccName><!-- ��ȡ���л��� -->
	<AutoPayFlag></AutoPayFlag> <!-- �Զ��潻��־ -->
</Risk>
</xsl:template>



<!-- ��Ҫ�ֶδ���ת��������ϸ�˶ԣ� -->
<!-- �Ա� -->
<xsl:template name="tran_sex">
  <xsl:param name="sex">0</xsl:param>
  <xsl:choose>
  	<xsl:when test="$sex = 1">0</xsl:when><!-- �� -->
  	<xsl:when test="$sex = 2">1</xsl:when><!-- Ů -->
  	<xsl:otherwise></xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ֤������ -->
<xsl:template name="tran_idtype">
<xsl:param name="idtype" />
<xsl:choose>
	<xsl:when test="$idtype=1">0</xsl:when>	<!-- ���֤ -->
	<xsl:when test="$idtype=2">1</xsl:when>	<!-- ���� -->
	<xsl:when test="$idtype=3">2</xsl:when>	<!-- ����֤ -->
	<xsl:when test="$idtype=4">2</xsl:when>	<!-- �侯֤-����֤ -->
	<xsl:when test="$idtype=5">6</xsl:when>	<!-- �۰ľ��������ڵ�ͨ��֤ -->
	<xsl:when test="$idtype=6">5</xsl:when>	<!-- ���ڲ� -->
	<xsl:when test="$idtype=7">8</xsl:when>	<!-- ���� -->
	<xsl:when test="$idtype=8">2</xsl:when>	<!-- ����֤-����֤ -->
	<xsl:when test="$idtype=9">8</xsl:when>	<!-- ִ�й���֤-���� -->	
	<xsl:when test="$idtype=A">8</xsl:when>	<!-- ʿ��֤-���� -->
	<xsl:when test="$idtype=B">7</xsl:when>	<!-- ̨�����������½ͨ��֤ -->
	<xsl:when test="$idtype=C">0</xsl:when>	<!-- ��ʱ���֤-���֤ -->
	<xsl:when test="$idtype=D">8</xsl:when>	<!-- ����˾���֤-���� -->
	<xsl:otherwise>8</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- Ͷ�����뱻���˹�ϵ -->
<xsl:template name="tran_relation">
<xsl:param name="relation" />
<xsl:choose>
	<xsl:when test="$relation=1">02</xsl:when>	<!-- ��ż -->
	<xsl:when test="$relation=2">01</xsl:when>	<!-- ��ĸ -->
	<xsl:when test="$relation=3">03</xsl:when>	<!-- ��Ů -->
	<xsl:when test="$relation=4">04</xsl:when>	<!-- ���� -->	
	<xsl:when test="$relation=5">00</xsl:when>	<!-- ���� -->
	<xsl:when test="$relation=6">04</xsl:when>	<!-- ���� -->
	<xsl:otherwise>04</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- �ɷ�Ƶ�� -->
<xsl:template name="tran_PayIntv">
<xsl:param name="payintv">0</xsl:param>
	<xsl:if test="$payintv = '2'">12</xsl:if> <!-- ��� -->
	<xsl:if test="$payintv = '3'">6</xsl:if>  <!-- ���꽻 -->
	<xsl:if test="$payintv = '1'">0</xsl:if>  <!-- ���� -->
	<xsl:if test="$payintv = '4'">3</xsl:if>  <!-- ���� -->
	<xsl:if test="$payintv = '5'">1</xsl:if>  <!-- �½� -->
	<xsl:if test="$payintv = '8'">-1</xsl:if>  <!-- �����ڽ� -->
</xsl:template>
	
<!-- �����������ڱ�־ -->
<xsl:template name="tran_InsuYearFlag">
<xsl:param name="insuyearflag" />
<xsl:choose>
	<xsl:when test="$insuyearflag=5">D</xsl:when>	<!-- ���� -->
	<xsl:when test="$insuyearflag=4">M</xsl:when>	<!-- ���� -->
	<xsl:when test="$insuyearflag=2">Y</xsl:when>	<!-- ���� -->
	<xsl:when test="$insuyearflag=1">A</xsl:when>   <!-- ���� -->
	<xsl:when test="$insuyearflag=3">A</xsl:when>   <!-- ��ĳȷ������ -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- �ɷ����������־ -->
<xsl:template name="tran_PayEndYearFlag">
<xsl:param name="payendyearflag" />
<xsl:choose>
	<xsl:when test="$payendyearflag=1">Y</xsl:when>	<!-- ���� -->
	<xsl:when test="$payendyearflag=2">Y</xsl:when>	<!-- ���� -->
	<xsl:when test="$payendyearflag=5">M</xsl:when>	<!-- ���� -->
	<xsl:when test="$payendyearflag=6">A</xsl:when> <!-- ��ĳȷ������ -->
	<xsl:when test="$payendyearflag=7">A</xsl:when> <!-- ���� -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ���ִ��� -->
<!-- ��ʹ���к���˾���ִ�����ͬҲҪת����Ϊ������ĳ������ֻ���������� -->
<xsl:template name="tran_riskcode">
<xsl:param name="riskcode" />
<xsl:choose>
	<xsl:when test="$riskcode=122009">L12079</xsl:when>	<!-- ����ʢ��2���������գ������ͣ� -->
	<xsl:when test="$riskcode=53000001">50015</xsl:when>	<!-- �������Ӯ1����ȫ������� -->	
	<!-- guning -->
	<xsl:when test="$riskcode=53000002">L12074</xsl:when>	<!-- ����ʢ��9����ȫ���գ������ͣ� -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ��Ʒ��ϴ��� -->
<xsl:template name="tran_ContPlanCode">
	<xsl:param name="contPlanCode" />
	<xsl:choose>
		<!-- 50002(50015): 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�122048-����������������գ������ͣ���� -->
		<xsl:when test="$contPlanCode='53000001'">50015</xsl:when>
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- ְҵ���� ��-->
<xsl:template name="tran_jobcode">
<xsl:param name="jobcode" />
<xsl:choose>
   <xsl:when test="$jobcode='B001001'">9210103</xsl:when>  <!-- ����ũҵ,��ҵ,����ҵ,�ܽ�ҵ,װ�ҵ,����ҵ,�Ҿ�����ҵ,���⳵����ҵ����Ա -->
  <xsl:when test="$jobcode='B001002'">9210103</xsl:when>  <!-- ����ũҵ,��ҵ,����ҵ,�ܽ�ҵ,װ�ҵ,����ҵ,�Ҿ�����ҵ,���⳵����ҵ����Ա -->
  <xsl:when test="$jobcode='B001003'">9210103</xsl:when>  <!-- ����ũҵ,��ҵ,����ҵ,�ܽ�ҵ,װ�ҵ,����ҵ,�Ҿ�����ҵ,���⳵����ҵ����Ա -->
  <xsl:when test="$jobcode='B001004'">9210103</xsl:when>  <!-- ����ũҵ,��ҵ,����ҵ,�ܽ�ҵ,װ�ҵ,����ҵ,�Ҿ�����ҵ,���⳵����ҵ����Ա -->
  <xsl:when test="$jobcode='B001005'">9210103</xsl:when>  <!-- ����ũҵ,��ҵ,����ҵ,�ܽ�ҵ,װ�ҵ,����ҵ,�Ҿ�����ҵ,���⳵����ҵ����Ա -->
  <xsl:when test="$jobcode='C001001'">9210102</xsl:when>  <!-- ��������,�ù�,����,��ҵ��һ�������ҵ���Ǵ���ְ����,�����漰Σ�յ�ְҵ,������ҵ, ��־ҵ�� -->
  <xsl:when test="$jobcode='C001002'">9210102</xsl:when>  <!-- ��������,�ù�,����,��ҵ��һ�������ҵ���Ǵ���ְ����,�����漰Σ�յ�ְҵ,������ҵ, ��־ҵ�� -->
  <xsl:when test="$jobcode='C001003'">9210102</xsl:when>  <!-- ��������,�ù�,����,��ҵ��һ�������ҵ���Ǵ���ְ����,�����漰Σ�յ�ְҵ,������ҵ, ��־ҵ�� -->
  <xsl:when test="$jobcode='C001004'">9210102</xsl:when>  <!-- ��������,�ù�,����,��ҵ��һ�������ҵ���Ǵ���ְ����,�����漰Σ�յ�ְҵ,������ҵ, ��־ҵ�� -->
  <xsl:when test="$jobcode='C001005'">9210102</xsl:when>  <!-- ��������,�ù�,����,��ҵ��һ�������ҵ���Ǵ���ְ����,�����漰Σ�յ�ְҵ,������ҵ, ��־ҵ�� -->
  <xsl:when test="$jobcode='C001006'">9210102</xsl:when>  <!-- ��������,�ù�,����,��ҵ��һ�������ҵ���Ǵ���ְ����,�����漰Σ�յ�ְҵ,������ҵ, ��־ҵ�� -->
  <xsl:when test="$jobcode='C001007'">9210102</xsl:when>  <!-- ��������,�ù�,����,��ҵ��һ�������ҵ���Ǵ���ְ����,�����漰Σ�յ�ְҵ,������ҵ, ��־ҵ�� -->
  <xsl:when test="$jobcode='C001008'">9210102</xsl:when>  <!-- ��������,�ù�,����,��ҵ��һ�������ҵ���Ǵ���ְ����,�����漰Σ�յ�ְҵ,������ҵ, ��־ҵ�� -->
  <xsl:when test="$jobcode='C001009'">9210102</xsl:when>  <!-- ��������,�ù�,����,��ҵ��һ�������ҵ���Ǵ���ְ����,�����漰Σ�յ�ְҵ,������ҵ, ��־ҵ�� -->
  <xsl:when test="$jobcode='C001010'">9210102</xsl:when>  <!-- ��������,�ù�,����,��ҵ��һ�������ҵ���Ǵ���ְ����,�����漰Σ�յ�ְҵ,������ҵ, ��־ҵ�� -->
  <xsl:when test="$jobcode='C001011'">9210102</xsl:when>  <!-- ��������,�ù�,����,��ҵ��һ�������ҵ���Ǵ���ְ����,�����漰Σ�յ�ְҵ,������ҵ, ��־ҵ�� -->
  <xsl:when test="$jobcode='C001012'">9210102</xsl:when>  <!-- ��������,�ù�,����,��ҵ��һ�������ҵ���Ǵ���ְ����,�����漰Σ�յ�ְҵ,������ҵ, ��־ҵ�� -->
  <xsl:when test="$jobcode='C001013'">9210102</xsl:when>  <!-- ��������,�ù�,����,��ҵ��һ�������ҵ���Ǵ���ְ����,�����漰Σ�յ�ְҵ,������ҵ, ��־ҵ�� -->
  <xsl:when test="$jobcode='C001014'">9210102</xsl:when>  <!-- ��������,�ù�,����,��ҵ��һ�������ҵ���Ǵ���ְ����,�����漰Σ�յ�ְҵ,������ҵ, ��־ҵ�� -->
  <xsl:when test="$jobcode='C001015'">9210102</xsl:when>  <!-- ��������,�ù�,����,��ҵ��һ�������ҵ���Ǵ���ְ����,�����漰Σ�յ�ְҵ,������ҵ, ��־ҵ�� -->
  <xsl:when test="$jobcode='C001016'">9210102</xsl:when>  <!-- ��������,�ù�,����,��ҵ��һ�������ҵ���Ǵ���ְ����,�����漰Σ�յ�ְҵ,������ҵ, ��־ҵ�� -->
  <xsl:when test="$jobcode='C001017'">9210102</xsl:when>  <!-- ��������,�ù�,����,��ҵ��һ�������ҵ���Ǵ���ְ����,�����漰Σ�յ�ְҵ,������ҵ, ��־ҵ�� -->
  <xsl:when test="$jobcode='C001018'">9210102</xsl:when>  <!-- ��������,�ù�,����,��ҵ��һ�������ҵ���Ǵ���ְ����,�����漰Σ�յ�ְҵ,������ҵ, ��־ҵ�� -->
  <xsl:when test="$jobcode='C001019'">9210102</xsl:when>  <!-- ��������,�ù�,����,��ҵ��һ�������ҵ���Ǵ���ְ����,�����漰Σ�յ�ְҵ,������ҵ, ��־ҵ�� -->
  <xsl:when test="$jobcode='D001001'">9210103</xsl:when>  <!-- ����ũҵ,��ҵ,����ҵ,�ܽ�ҵ,װ�ҵ,����ҵ,�Ҿ�����ҵ,���⳵����ҵ����Ա -->
  <xsl:when test="$jobcode='D001002'">9210103</xsl:when>  <!-- ����ũҵ,��ҵ,����ҵ,�ܽ�ҵ,װ�ҵ,����ҵ,�Ҿ�����ҵ,���⳵����ҵ����Ա -->
  <xsl:when test="$jobcode='D001003'">9210103</xsl:when>  <!-- ����ũҵ,��ҵ,����ҵ,�ܽ�ҵ,װ�ҵ,����ҵ,�Ҿ�����ҵ,���⳵����ҵ����Ա -->
  <xsl:when test="$jobcode='D001004'">9210103</xsl:when>  <!-- ����ũҵ,��ҵ,����ҵ,�ܽ�ҵ,װ�ҵ,����ҵ,�Ҿ�����ҵ,���⳵����ҵ����Ա -->
  <xsl:when test="$jobcode='D001005'">9210103</xsl:when>  <!-- ����ũҵ,��ҵ,����ҵ,�ܽ�ҵ,װ�ҵ,����ҵ,�Ҿ�����ҵ,���⳵����ҵ����Ա -->
  <xsl:when test="$jobcode='D001006'">9210103</xsl:when>  <!-- ����ũҵ,��ҵ,����ҵ,�ܽ�ҵ,װ�ҵ,����ҵ,�Ҿ�����ҵ,���⳵����ҵ����Ա -->
  <xsl:when test="$jobcode='D001007'">9210103</xsl:when>  <!-- ����ũҵ,��ҵ,����ҵ,�ܽ�ҵ,װ�ҵ,����ҵ,�Ҿ�����ҵ,���⳵����ҵ����Ա -->
  <xsl:when test="$jobcode='D001008'">9210103</xsl:when>  <!-- ����ũҵ,��ҵ,����ҵ,�ܽ�ҵ,װ�ҵ,����ҵ,�Ҿ�����ҵ,���⳵����ҵ����Ա -->
  <xsl:when test="$jobcode='D001009'">9210103</xsl:when>  <!-- ����ũҵ,��ҵ,����ҵ,�ܽ�ҵ,װ�ҵ,����ҵ,�Ҿ�����ҵ,���⳵����ҵ����Ա -->
  <xsl:when test="$jobcode='D001010'">9210103</xsl:when>  <!-- ����ũҵ,��ҵ,����ҵ,�ܽ�ҵ,װ�ҵ,����ҵ,�Ҿ�����ҵ,���⳵����ҵ����Ա -->
  <xsl:when test="$jobcode='D001011'">9210103</xsl:when>  <!-- ����ũҵ,��ҵ,����ҵ,�ܽ�ҵ,װ�ҵ,����ҵ,�Ҿ�����ҵ,���⳵����ҵ����Ա -->
  <xsl:when test="$jobcode='D001012'">9210103</xsl:when>  <!-- ����ũҵ,��ҵ,����ҵ,�ܽ�ҵ,װ�ҵ,����ҵ,�Ҿ�����ҵ,���⳵����ҵ����Ա -->
  <xsl:when test="$jobcode='D002001'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='D002002'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='D002003'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='D002004'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='D002005'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='D002006'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='D002007'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='D002008'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='D002009'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='D002010'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='D002011'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='D002012'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='D002013'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='D003001'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='D003002'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='D003003'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='D003004'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='F001001'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='F001002'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='F001003'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='F001004'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='F001005'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='F001006'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='F001007'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='F001008'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='F001009'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->  
  <xsl:when test="$jobcode='G001001'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='G001002'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='G001003'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='G001004'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='G001005'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='G001006'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='G001007'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='G001008'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='G001009'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='G001010'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='G001011'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='G001012'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='G001013'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='G001014'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='G001015'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='G001016'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='G001017'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='G001018'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='G001019'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='G001020'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='G001021'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='G001022'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='G001023'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='G001024'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='G001025'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='G001026'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='G001027'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='G001028'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='G001029'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='G001030'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='G001031'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='G001032'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='G001033'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='G001034'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='G001035'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ -->
  <xsl:when test="$jobcode='H001001'">9210107</xsl:when>  <!-- ���º�����ҵ,����,Σ���˶�����Ա,������Ա -->
  <xsl:when test="$jobcode='H001002'">9210107</xsl:when>  <!-- ���º�����ҵ,����,Σ���˶�����Ա,������Ա -->
  <xsl:when test="$jobcode='H001003'">9210107</xsl:when>  <!-- ���º�����ҵ,����,Σ���˶�����Ա,������Ա -->
  <xsl:when test="$jobcode='H001004'">9210107</xsl:when>  <!-- ���º�����ҵ,����,Σ���˶�����Ա,������Ա -->
  <xsl:when test="$jobcode='H001005'">9210107</xsl:when>  <!-- ���º�����ҵ,����,Σ���˶�����Ա,������Ա -->
  <xsl:when test="$jobcode='H001006'">9210107</xsl:when>  <!-- ���º�����ҵ,����,Σ���˶�����Ա,������Ա -->
  <xsl:when test="$jobcode='H001007'">9210107</xsl:when>  <!-- ���º�����ҵ,����,Σ���˶�����Ա,������Ա -->
  <xsl:when test="$jobcode='H001008'">9210107</xsl:when>  <!-- ���º�����ҵ,����,Σ���˶�����Ա,������Ա -->
  <xsl:when test="$jobcode='H001009'">9210107</xsl:when>  <!-- ���º�����ҵ,����,Σ���˶�����Ա,������Ա -->
  <xsl:when test="$jobcode='H001010'">9210107</xsl:when>  <!-- ���º�����ҵ,����,Σ���˶�����Ա,������Ա -->
  <xsl:when test="$jobcode='H001011'">9210107</xsl:when>  <!-- ���º�����ҵ,����,Σ���˶�����Ա,������Ա -->
  <xsl:when test="$jobcode='H001012'">9210107</xsl:when>  <!-- ���º�����ҵ,����,Σ���˶�����Ա,������Ա -->
  <xsl:when test="$jobcode='H001013'">9210107</xsl:when>  <!-- ���º�����ҵ,����,Σ���˶�����Ա,������Ա -->
  <xsl:when test="$jobcode='H001014'">9210107</xsl:when>  <!-- ���º�����ҵ,����,Σ���˶�����Ա,������Ա -->
  <xsl:when test="$jobcode='H001015'">9210107</xsl:when>  <!-- ���º�����ҵ,����,Σ���˶�����Ա,������Ա -->
  <xsl:when test="$jobcode='H001016'">9210107</xsl:when>  <!-- ���º�����ҵ,����,Σ���˶�����Ա,������Ա -->
  <xsl:when test="$jobcode='H001017'">9210107</xsl:when>  <!-- ���º�����ҵ,����,Σ���˶�����Ա,������Ա -->
  <xsl:when test="$jobcode='H001018'">9210107</xsl:when>  <!-- ���º�����ҵ,����,Σ���˶�����Ա,������Ա -->
  <xsl:when test="$jobcode='H001019'">9210107</xsl:when>  <!-- ���º�����ҵ,����,Σ���˶�����Ա,������Ա -->
  <xsl:when test="$jobcode='H001020'">9210107</xsl:when>  <!-- ���º�����ҵ,����,Σ���˶�����Ա,������Ա -->
  <xsl:when test="$jobcode='H001021'">9210107</xsl:when>  <!-- ���º�����ҵ,����,Σ���˶�����Ա,������Ա -->
  <xsl:when test="$jobcode='H001022'">9210107</xsl:when>  <!-- ���º�����ҵ,����,Σ���˶�����Ա,������Ա -->
  <xsl:when test="$jobcode='H001023'">9210107</xsl:when>  <!-- ���º�����ҵ,����,Σ���˶�����Ա,������Ա -->
  <xsl:when test="$jobcode='H001024'">9210107</xsl:when>  <!-- ���º�����ҵ,����,Σ���˶�����Ա,������Ա -->
  <xsl:when test="$jobcode='H001025'">9210107</xsl:when>  <!-- ���º�����ҵ,����,Σ���˶�����Ա,������Ա -->
  <xsl:when test="$jobcode='H001026'">9210107</xsl:when>  <!-- ���º�����ҵ,����,Σ���˶�����Ա,������Ա -->
  <xsl:when test="$jobcode='H001027'">9210107</xsl:when>  <!-- ���º�����ҵ,����,Σ���˶�����Ա,������Ա -->
  <xsl:when test="$jobcode='H001028'">9210107</xsl:when>  <!-- ���º�����ҵ,����,Σ���˶�����Ա,������Ա -->
  <xsl:when test="$jobcode='H001029'">9210107</xsl:when>  <!-- ���º�����ҵ,����,Σ���˶�����Ա,������Ա -->
  <xsl:when test="$jobcode='H001030'">9210107</xsl:when>  <!-- ���º�����ҵ,����,Σ���˶�����Ա,������Ա -->
  <xsl:when test="$jobcode='H001031'">9210107</xsl:when>  <!-- ���º�����ҵ,����,Σ���˶�����Ա,������Ա -->
  <xsl:when test="$jobcode='H001032'">9210107</xsl:when>  <!-- ���º�����ҵ,����,Σ���˶�����Ա,������Ա -->
  <xsl:when test="$jobcode='H001033'">9210107</xsl:when>  <!-- ���º�����ҵ,����,Σ���˶�����Ա,������Ա -->
  <xsl:when test="$jobcode='H001034'">9210107</xsl:when>  <!-- ���º�����ҵ,����,Σ���˶�����Ա,������Ա -->
  <xsl:when test="$jobcode='H001035'">9210107</xsl:when>  <!-- ���º�����ҵ,����,Σ���˶�����Ա,������Ա -->
  <xsl:when test="$jobcode='H001036'">9210107</xsl:when>  <!-- ���º�����ҵ,����,Σ���˶�����Ա,������Ա -->
  <xsl:when test="$jobcode='H001037'">9210107</xsl:when>  <!-- ���º�����ҵ,����,Σ���˶�����Ա,������Ա -->
  <xsl:when test="$jobcode='H001038'">9210107</xsl:when>  <!-- ���º�����ҵ,����,Σ���˶�����Ա,������Ա -->
  <xsl:when test="$jobcode='H001039'">9210107</xsl:when>  <!-- ���º�����ҵ,����,Σ���˶�����Ա,������Ա -->
  <xsl:when test="$jobcode='H001040'">9210107</xsl:when>  <!-- ���º�����ҵ,����,Σ���˶�����Ա,������Ա -->
  <xsl:when test="$jobcode='H001041'">9210107</xsl:when>  <!-- ���º�����ҵ,����,Σ���˶�����Ա,������Ա -->
  <xsl:when test="$jobcode='H001042'">9210107</xsl:when>  <!-- ���º�����ҵ,����,Σ���˶�����Ա,������Ա -->
                           
  <xsl:when test="$jobcode='H002001'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='H002002'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='H002003'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='H002004'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='H002005'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='H002006'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='H002007'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='H002008'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='H002009'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='H002010'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='H002011'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='H002012'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='H002013'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='H002014'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='H002015'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='H002016'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='H002017'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->

  <xsl:when test="$jobcode='J001001'">9210101</xsl:when>  <!-- ��������,��ҵ��λ�Ĺ�����Ա�Լ�������ְ��Ա -->
  <xsl:when test="$jobcode='J001002'">9210101</xsl:when>  <!-- ��������,��ҵ��λ�Ĺ�����Ա�Լ�������ְ��Ա -->
  <xsl:when test="$jobcode='J001003'">9210101</xsl:when>  <!-- ��������,��ҵ��λ�Ĺ�����Ա�Լ�������ְ��Ա -->
  <xsl:when test="$jobcode='J001004'">9210101</xsl:when>  <!-- ��������,��ҵ��λ�Ĺ�����Ա�Լ�������ְ��Ա -->
  
  <xsl:when test="$jobcode='J003001'">9210103</xsl:when>  <!-- ����ũҵ,��ҵ,����ҵ,�ܽ�ҵ,װ�ҵ,����ҵ,�Ҿ�����ҵ,���⳵����ҵ����Ա -->
  <xsl:when test="$jobcode='J003002'">9210103</xsl:when>  <!-- ����ũҵ,��ҵ,����ҵ,�ܽ�ҵ,װ�ҵ,����ҵ,�Ҿ�����ҵ,���⳵����ҵ����Ա -->
  <xsl:when test="$jobcode='J003003'">9210103</xsl:when>  <!-- ����ũҵ,��ҵ,����ҵ,�ܽ�ҵ,װ�ҵ,����ҵ,�Ҿ�����ҵ,���⳵����ҵ����Ա -->
  <xsl:when test="$jobcode='J003004'">9210103</xsl:when>  <!-- ����ũҵ,��ҵ,����ҵ,�ܽ�ҵ,װ�ҵ,����ҵ,�Ҿ�����ҵ,���⳵����ҵ����Ա -->
  <xsl:when test="$jobcode='J003005'">9210103</xsl:when>  <!-- ����ũҵ,��ҵ,����ҵ,�ܽ�ҵ,װ�ҵ,����ҵ,�Ҿ�����ҵ,���⳵����ҵ����Ա -->
  <xsl:when test="$jobcode='J003006'">9210103</xsl:when>  <!-- ����ũҵ,��ҵ,����ҵ,�ܽ�ҵ,װ�ҵ,����ҵ,�Ҿ�����ҵ,���⳵����ҵ����Ա -->
  <xsl:when test="$jobcode='J003007'">9210103</xsl:when>  <!-- ����ũҵ,��ҵ,����ҵ,�ܽ�ҵ,װ�ҵ,����ҵ,�Ҿ�����ҵ,���⳵����ҵ����Ա -->
  <xsl:when test="$jobcode='J003008'">9210103</xsl:when>  <!-- ����ũҵ,��ҵ,����ҵ,�ܽ�ҵ,װ�ҵ,����ҵ,�Ҿ�����ҵ,���⳵����ҵ����Ա -->
  <xsl:when test="$jobcode='J003009'">9210103</xsl:when>  <!-- ����ũҵ,��ҵ,����ҵ,�ܽ�ҵ,װ�ҵ,����ҵ,�Ҿ�����ҵ,���⳵����ҵ����Ա -->
  <xsl:when test="$jobcode='J004001'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='J004002'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='J004003'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='J004004'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='J004005'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='J004006'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='J004007'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='J004008'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='J004009'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='J004010'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='J004011'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='J004012'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='J004013'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='J004014'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='J004015'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='J004016'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='J004017'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='J004018'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='J004019'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='J004020'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='J004021'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='J004022'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='J004023'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='J004024'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='J004025'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='J004026'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='J004027'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='J004028'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='J004029'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='J004030'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='J004031'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='J004032'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='J004033'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='J004034'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='J004035'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='J004036'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='J004037'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='J005001'">9210101</xsl:when>  <!-- ��������,��ҵ��λ�Ĺ�����Ա�Լ�������ְ��Ա -->
  <xsl:when test="$jobcode='J005002'">9210101</xsl:when>  <!-- ��������,��ҵ��λ�Ĺ�����Ա�Լ�������ְ��Ա -->
  <xsl:when test="$jobcode='J005003'">9210101</xsl:when>  <!-- ��������,��ҵ��λ�Ĺ�����Ա�Լ�������ְ��Ա -->
  <xsl:when test="$jobcode='J005004'">9210101</xsl:when>  <!-- ��������,��ҵ��λ�Ĺ�����Ա�Լ�������ְ��Ա -->
  <xsl:when test="$jobcode='J005005'">9210101</xsl:when>  <!-- ��������,��ҵ��λ�Ĺ�����Ա�Լ�������ְ��Ա -->
  <xsl:when test="$jobcode='J005006'">9210101</xsl:when>  <!-- ��������,��ҵ��λ�Ĺ�����Ա�Լ�������ְ��Ա -->
  <xsl:when test="$jobcode='J006001'">9210108</xsl:when>  <!-- �ӵ�����ҵ,Ǳˮ��Ա,������Ա,ըҩҵ,�򱩾��켰���ֱ�,ս�ؼ���,�ؼ���Ա,����԰ѱ��ʦ,������ѹ�繤����ʩ��Ա,�����˶�Ա������,��ɡ�˶�Ա������ -->
  <xsl:when test="$jobcode='J006002'">9210108</xsl:when>  <!-- �ӵ�����ҵ,Ǳˮ��Ա,������Ա,ըҩҵ,�򱩾��켰���ֱ�,ս�ؼ���,�ؼ���Ա,����԰ѱ��ʦ,������ѹ�繤����ʩ��Ա,�����˶�Ա������,��ɡ�˶�Ա������ -->
  <xsl:when test="$jobcode='J006003'">9210108</xsl:when>  <!-- �ӵ�����ҵ,Ǳˮ��Ա,������Ա,ըҩҵ,�򱩾��켰���ֱ�,ս�ؼ���,�ؼ���Ա,����԰ѱ��ʦ,������ѹ�繤����ʩ��Ա,�����˶�Ա������,��ɡ�˶�Ա������ -->
  <xsl:when test="$jobcode='J006004'">9210108</xsl:when>  <!-- �ӵ�����ҵ,Ǳˮ��Ա,������Ա,ըҩҵ,�򱩾��켰���ֱ�,ս�ؼ���,�ؼ���Ա,����԰ѱ��ʦ,������ѹ�繤����ʩ��Ա,�����˶�Ա������,��ɡ�˶�Ա������ -->
  <xsl:when test="$jobcode='J006005'">9210108</xsl:when>  <!-- �ӵ�����ҵ,Ǳˮ��Ա,������Ա,ըҩҵ,�򱩾��켰���ֱ�,ս�ؼ���,�ؼ���Ա,����԰ѱ��ʦ,������ѹ�繤����ʩ��Ա,�����˶�Ա������,��ɡ�˶�Ա������ -->
  <xsl:when test="$jobcode='J006006'">9210108</xsl:when>  <!-- �ӵ�����ҵ,Ǳˮ��Ա,������Ա,ըҩҵ,�򱩾��켰���ֱ�,ս�ؼ���,�ؼ���Ա,����԰ѱ��ʦ,������ѹ�繤����ʩ��Ա,�����˶�Ա������,��ɡ�˶�Ա������ -->
  <xsl:when test="$jobcode='J006007'">9210108</xsl:when>  <!-- �ӵ�����ҵ,Ǳˮ��Ա,������Ա,ըҩҵ,�򱩾��켰���ֱ�,ս�ؼ���,�ؼ���Ա,����԰ѱ��ʦ,������ѹ�繤����ʩ��Ա,�����˶�Ա������,��ɡ�˶�Ա������ -->
  <xsl:when test="$jobcode='J006008'">9210108</xsl:when>  <!-- �ӵ�����ҵ,Ǳˮ��Ա,������Ա,ըҩҵ,�򱩾��켰���ֱ�,ս�ؼ���,�ؼ���Ա,����԰ѱ��ʦ,������ѹ�繤����ʩ��Ա,�����˶�Ա������,��ɡ�˶�Ա������ -->
  <xsl:when test="$jobcode='J006009'">9210108</xsl:when>  <!-- �ӵ�����ҵ,Ǳˮ��Ա,������Ա,ըҩҵ,�򱩾��켰���ֱ�,ս�ؼ���,�ؼ���Ա,����԰ѱ��ʦ,������ѹ�繤����ʩ��Ա,�����˶�Ա������,��ɡ�˶�Ա������ -->
  <xsl:when test="$jobcode='J006010'">9210108</xsl:when>  <!-- �ӵ�����ҵ,Ǳˮ��Ա,������Ա,ըҩҵ,�򱩾��켰���ֱ�,ս�ؼ���,�ؼ���Ա,����԰ѱ��ʦ,������ѹ�繤����ʩ��Ա,�����˶�Ա������,��ɡ�˶�Ա������ -->
  <xsl:when test="$jobcode='J006011'">9210108</xsl:when>  <!-- �ӵ�����ҵ,Ǳˮ��Ա,������Ա,ըҩҵ,�򱩾��켰���ֱ�,ս�ؼ���,�ؼ���Ա,����԰ѱ��ʦ,������ѹ�繤����ʩ��Ա,�����˶�Ա������,��ɡ�˶�Ա������ -->
  <xsl:when test="$jobcode='J006012'">9210108</xsl:when>  <!-- �ӵ�����ҵ,Ǳˮ��Ա,������Ա,ըҩҵ,�򱩾��켰���ֱ�,ս�ؼ���,�ؼ���Ա,����԰ѱ��ʦ,������ѹ�繤����ʩ��Ա,�����˶�Ա������,��ɡ�˶�Ա������ -->
  <xsl:when test="$jobcode='J006013'">9210108</xsl:when>  <!-- �ӵ�����ҵ,Ǳˮ��Ա,������Ա,ըҩҵ,�򱩾��켰���ֱ�,ս�ؼ���,�ؼ���Ա,����԰ѱ��ʦ,������ѹ�繤����ʩ��Ա,�����˶�Ա������,��ɡ�˶�Ա������ -->
  <xsl:when test="$jobcode='J006014'">9210108</xsl:when>  <!-- �ӵ�����ҵ,Ǳˮ��Ա,������Ա,ըҩҵ,�򱩾��켰���ֱ�,ս�ؼ���,�ؼ���Ա,����԰ѱ��ʦ,������ѹ�繤����ʩ��Ա,�����˶�Ա������,��ɡ�˶�Ա������ -->
  <xsl:when test="$jobcode='J006015'">9210108</xsl:when>  <!-- �ӵ�����ҵ,Ǳˮ��Ա,������Ա,ըҩҵ,�򱩾��켰���ֱ�,ս�ؼ���,�ؼ���Ա,����԰ѱ��ʦ,������ѹ�繤����ʩ��Ա,�����˶�Ա������,��ɡ�˶�Ա������ -->
  <xsl:when test="$jobcode='J006016'">9210108</xsl:when>  <!-- �ӵ�����ҵ,Ǳˮ��Ա,������Ա,ըҩҵ,�򱩾��켰���ֱ�,ս�ؼ���,�ؼ���Ա,����԰ѱ��ʦ,������ѹ�繤����ʩ��Ա,�����˶�Ա������,��ɡ�˶�Ա������ -->
  <xsl:when test="$jobcode='J006017'">9210108</xsl:when>  <!-- �ӵ�����ҵ,Ǳˮ��Ա,������Ա,ըҩҵ,�򱩾��켰���ֱ�,ս�ؼ���,�ؼ���Ա,����԰ѱ��ʦ,������ѹ�繤����ʩ��Ա,�����˶�Ա������,��ɡ�˶�Ա������ -->
  <xsl:when test="$jobcode='J006018'">9210108</xsl:when>  <!-- �ӵ�����ҵ,Ǳˮ��Ա,������Ա,ըҩҵ,�򱩾��켰���ֱ�,ս�ؼ���,�ؼ���Ա,����԰ѱ��ʦ,������ѹ�繤����ʩ��Ա,�����˶�Ա������,��ɡ�˶�Ա������ -->
  <xsl:when test="$jobcode='J006019'">9210108</xsl:when>  <!-- �ӵ�����ҵ,Ǳˮ��Ա,������Ա,ըҩҵ,�򱩾��켰���ֱ�,ս�ؼ���,�ؼ���Ա,����԰ѱ��ʦ,������ѹ�繤����ʩ��Ա,�����˶�Ա������,��ɡ�˶�Ա������ -->
  <xsl:when test="$jobcode='J006020'">9210108</xsl:when>  <!-- �ӵ�����ҵ,Ǳˮ��Ա,������Ա,ըҩҵ,�򱩾��켰���ֱ�,ս�ؼ���,�ؼ���Ա,����԰ѱ��ʦ,������ѹ�繤����ʩ��Ա,�����˶�Ա������,��ɡ�˶�Ա������ -->
  <xsl:when test="$jobcode='J006021'">9210108</xsl:when>  <!-- �ӵ�����ҵ,Ǳˮ��Ա,������Ա,ըҩҵ,�򱩾��켰���ֱ�,ս�ؼ���,�ؼ���Ա,����԰ѱ��ʦ,������ѹ�繤����ʩ��Ա,�����˶�Ա������,��ɡ�˶�Ա������ -->
  <xsl:when test="$jobcode='J006022'">9210108</xsl:when>  <!-- �ӵ�����ҵ,Ǳˮ��Ա,������Ա,ըҩҵ,�򱩾��켰���ֱ�,ս�ؼ���,�ؼ���Ա,����԰ѱ��ʦ,������ѹ�繤����ʩ��Ա,�����˶�Ա������,��ɡ�˶�Ա������ -->
  <xsl:when test="$jobcode='J006023'">9210108</xsl:when>  <!-- �ӵ�����ҵ,Ǳˮ��Ա,������Ա,ըҩҵ,�򱩾��켰���ֱ�,ս�ؼ���,�ؼ���Ա,����԰ѱ��ʦ,������ѹ�繤����ʩ��Ա,�����˶�Ա������,��ɡ�˶�Ա������ -->
  <xsl:when test="$jobcode='J006024'">9210108</xsl:when>  <!-- �ӵ�����ҵ,Ǳˮ��Ա,������Ա,ըҩҵ,�򱩾��켰���ֱ�,ս�ؼ���,�ؼ���Ա,����԰ѱ��ʦ,������ѹ�繤����ʩ��Ա,�����˶�Ա������,��ɡ�˶�Ա������ -->
  <xsl:when test="$jobcode='J006025'">9210108</xsl:when>  <!-- �ӵ�����ҵ,Ǳˮ��Ա,������Ա,ըҩҵ,�򱩾��켰���ֱ�,ս�ؼ���,�ؼ���Ա,����԰ѱ��ʦ,������ѹ�繤����ʩ��Ա,�����˶�Ա������,��ɡ�˶�Ա������ -->
  <xsl:when test="$jobcode='J006026'">9210108</xsl:when>  <!-- �ӵ�����ҵ,Ǳˮ��Ա,������Ա,ըҩҵ,�򱩾��켰���ֱ�,ս�ؼ���,�ؼ���Ա,����԰ѱ��ʦ,������ѹ�繤����ʩ��Ա,�����˶�Ա������,��ɡ�˶�Ա������ -->
  <xsl:when test="$jobcode='J006027'">9210108</xsl:when>  <!-- �ӵ�����ҵ,Ǳˮ��Ա,������Ա,ըҩҵ,�򱩾��켰���ֱ�,ս�ؼ���,�ؼ���Ա,����԰ѱ��ʦ,������ѹ�繤����ʩ��Ա,�����˶�Ա������,��ɡ�˶�Ա������ -->
  <xsl:when test="$jobcode='J006028'">9210108</xsl:when>  <!-- �ӵ�����ҵ,Ǳˮ��Ա,������Ա,ըҩҵ,�򱩾��켰���ֱ�,ս�ؼ���,�ؼ���Ա,����԰ѱ��ʦ,������ѹ�繤����ʩ��Ա,�����˶�Ա������,��ɡ�˶�Ա������ -->
  <xsl:when test="$jobcode='J006029'">9210108</xsl:when>  <!-- �ӵ�����ҵ,Ǳˮ��Ա,������Ա,ըҩҵ,�򱩾��켰���ֱ�,ս�ؼ���,�ؼ���Ա,����԰ѱ��ʦ,������ѹ�繤����ʩ��Ա,�����˶�Ա������,��ɡ�˶�Ա������ -->
  <xsl:when test="$jobcode='K001001'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='K001002'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001003'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001004'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001005'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001006'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001007'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001008'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001009'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001010'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001011'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='K001012'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001013'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001014'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001015'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001016'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001017'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001018'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001019'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001020'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001021'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='K001022'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001023'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001024'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001025'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001026'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001027'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001028'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001029'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001030'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001031'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='K001032'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001033'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001034'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001035'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001036'">9210105</xsl:when>
  <xsl:when test="$jobcode='K001037'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002001'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002002'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002003'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002004'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002005'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002006'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002007'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002008'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002009'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002010'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002011'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002012'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002013'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002014'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002015'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002016'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002017'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002018'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002019'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002020'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002021'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002022'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002023'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002024'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002025'">9210105</xsl:when>
  <xsl:when test="$jobcode='K002026'">9210105</xsl:when>
  <xsl:when test="$jobcode='L001001'">9210105</xsl:when>
  <xsl:when test="$jobcode='L001002'">9210105</xsl:when>
  <xsl:when test="$jobcode='L001003'">9210105</xsl:when>
  <xsl:when test="$jobcode='L001004'">9210105</xsl:when>
  <xsl:when test="$jobcode='L001005'">9210105</xsl:when>
  <xsl:when test="$jobcode='L001006'">9210105</xsl:when>
  <xsl:when test="$jobcode='L001007'">9210105</xsl:when>
  <xsl:when test="$jobcode='L001008'">9210105</xsl:when>
  <xsl:when test="$jobcode='L001009'">9210105</xsl:when>
  <xsl:when test="$jobcode='L001010'">9210105</xsl:when>
  <xsl:when test="$jobcode='L001011'">9210105</xsl:when>  <!-- ��������ҵ,½���Ϳ󿪲�ҵ,����ҵ,��·����,���޴�ҵ�ҵ�����ҵ,���ż�����ҵ,������,��е��,�Լ�Σ�ճ̶��Ըߵ�ְҵ-->
  <xsl:when test="$jobcode='L001012'">9210105</xsl:when>
  <xsl:when test="$jobcode='L001013'">9210105</xsl:when>
  <xsl:when test="$jobcode='L001014'">9210105</xsl:when>
  <xsl:when test="$jobcode='L001015'">9210105</xsl:when>
  <xsl:when test="$jobcode='L001016'">9210105</xsl:when>
  <xsl:when test="$jobcode='L002001'">9210103</xsl:when>  <!-- ����ũҵ,��ҵ,����ҵ,�ܽ�ҵ,װ�ҵ,����ҵ,�Ҿ�����ҵ,���⳵����ҵ����Ա-->
  <xsl:when test="$jobcode='L002002'">9210103</xsl:when>
  <xsl:when test="$jobcode='L002003'">9210103</xsl:when>
  <xsl:when test="$jobcode='L002004'">9210103</xsl:when>
  <xsl:when test="$jobcode='L002005'">9210103</xsl:when>
  <xsl:when test="$jobcode='L002006'">9210103</xsl:when>
  <xsl:when test="$jobcode='L002007'">9210103</xsl:when>
  <xsl:when test="$jobcode='L002008'">9210103</xsl:when>
  <xsl:when test="$jobcode='L002009'">9210103</xsl:when>
  <xsl:when test="$jobcode='L002010'">9210103</xsl:when>
  <xsl:when test="$jobcode='L002011'">9210103</xsl:when>  <!-- ����ũҵ,��ҵ,����ҵ,�ܽ�ҵ,װ�ҵ,����ҵ,�Ҿ�����ҵ,���⳵����ҵ����Ա-->
  <xsl:when test="$jobcode='L002012'">9210103</xsl:when>
  <xsl:when test="$jobcode='L002013'">9210103</xsl:when>
  <xsl:when test="$jobcode='L002014'">9210103</xsl:when>
  <xsl:when test="$jobcode='L002015'">9210103</xsl:when>
  <xsl:when test="$jobcode='L002016'">9210103</xsl:when>
  <xsl:when test="$jobcode='L002017'">9210103</xsl:when>
  <xsl:when test="$jobcode='L002018'">9210103</xsl:when>
  <xsl:when test="$jobcode='L002019'">9210103</xsl:when>
  <xsl:when test="$jobcode='L002020'">9210103</xsl:when>
  <xsl:when test="$jobcode='L002021'">9210103</xsl:when>  <!-- ����ũҵ,��ҵ,����ҵ,�ܽ�ҵ,װ�ҵ,����ҵ,�Ҿ�����ҵ,���⳵����ҵ����Ա-->
  <xsl:when test="$jobcode='L002022'">9210103</xsl:when>
  <xsl:when test="$jobcode='L002023'">9210103</xsl:when>
  <xsl:when test="$jobcode='L002024'">9210103</xsl:when>
  <xsl:when test="$jobcode='L002025'">9210103</xsl:when>
  <xsl:when test="$jobcode='L002026'">9210103</xsl:when>
  <xsl:when test="$jobcode='M001001'">9210103</xsl:when>
  <xsl:when test="$jobcode='M001002'">9210103</xsl:when>
  <xsl:when test="$jobcode='M001003'">9210103</xsl:when>
  <xsl:when test="$jobcode='M001004'">9210103</xsl:when>
  <xsl:when test="$jobcode='M001005'">9210103</xsl:when>
  <xsl:when test="$jobcode='M002005'">9210103</xsl:when>
  <xsl:when test="$jobcode='M002006'">9210103</xsl:when>
  <xsl:when test="$jobcode='M002016'">9210103</xsl:when>
  <xsl:when test="$jobcode='M002007'">9210103</xsl:when>
  <xsl:when test="$jobcode='M002015'">9210103</xsl:when>
  <xsl:when test="$jobcode='M002008'">9210103</xsl:when>
  <xsl:when test="$jobcode='M002009'">9210103</xsl:when>
  <xsl:when test="$jobcode='M002010'">9210103</xsl:when>
  <xsl:when test="$jobcode='M002011'">9210103</xsl:when>
  <xsl:when test="$jobcode='M002012'">9210103</xsl:when>
  <xsl:when test="$jobcode='M002001'">9210103</xsl:when>
  <xsl:when test="$jobcode='M002002'">9210103</xsl:when>
  <xsl:when test="$jobcode='M002003'">9210103</xsl:when>
  <xsl:when test="$jobcode='M002013'">9210103</xsl:when>
  <xsl:when test="$jobcode='M002004'">9210103</xsl:when>
  <xsl:when test="$jobcode='M002014'">9210103</xsl:when>
  <xsl:when test="$jobcode='N001001'">9210103</xsl:when>
  <xsl:when test="$jobcode='N001002'">9210103</xsl:when>
  <xsl:when test="$jobcode='N001003'">9210103</xsl:when>
  <xsl:when test="$jobcode='N001004'">9210103</xsl:when>  
  <xsl:when test="$jobcode='N001005'">9210103</xsl:when>  
  <xsl:when test="$jobcode='N001006'">9210103</xsl:when>  
  <xsl:when test="$jobcode='N001007'">9210103</xsl:when>  
  <xsl:when test="$jobcode='N001008'">9210103</xsl:when>
  <xsl:when test="$jobcode='N001009'">9210103</xsl:when>
  <xsl:when test="$jobcode='N001010'">9210103</xsl:when>
  <xsl:when test="$jobcode='N001011'">9210103</xsl:when>
  <xsl:when test="$jobcode='N001012'">9210103</xsl:when>
  <xsl:when test="$jobcode='Q001001'">9210103</xsl:when>
  <xsl:when test="$jobcode='Q001002'">9210103</xsl:when>
  <xsl:when test="$jobcode='Q001003'">9210103</xsl:when>
  <xsl:when test="$jobcode='Q001004'">9210103</xsl:when>  
  <xsl:when test="$jobcode='Q001005'">9210103</xsl:when>  
  <xsl:when test="$jobcode='Q001006'">9210103</xsl:when>  
  <xsl:when test="$jobcode='Q001007'">9210103</xsl:when>  
  <xsl:when test="$jobcode='Q001008'">9210103</xsl:when>
  <xsl:when test="$jobcode='Q001009'">9210103</xsl:when>
  <xsl:when test="$jobcode='Q001010'">9210103</xsl:when>
  <xsl:when test="$jobcode='Q001011'">9210103</xsl:when>
  <xsl:when test="$jobcode='Q002001'">9210101</xsl:when>
  <xsl:when test="$jobcode='Q002002'">9210101</xsl:when>
  <xsl:when test="$jobcode='S001001'">9210103</xsl:when>
  <xsl:when test="$jobcode='S001002'">9210103</xsl:when>
  <xsl:when test="$jobcode='S001003'">9210103</xsl:when>
  <xsl:when test="$jobcode='S001004'">9210103</xsl:when>  
  <xsl:when test="$jobcode='S001005'">9210103</xsl:when>  
  <xsl:when test="$jobcode='S001006'">9210103</xsl:when>  
  <xsl:when test="$jobcode='S001007'">9210103</xsl:when>  
  <xsl:when test="$jobcode='S001008'">9210103</xsl:when>
  <xsl:when test="$jobcode='S001009'">9210103</xsl:when>
  <xsl:when test="$jobcode='S001010'">9210103</xsl:when>
  <xsl:when test="$jobcode='S001011'">9210103</xsl:when>
  <xsl:when test="$jobcode='S001012'">9210103</xsl:when>
  <xsl:when test="$jobcode='S002001'">9210103</xsl:when>
  <xsl:when test="$jobcode='S002002'">9210103</xsl:when>
  <xsl:when test="$jobcode='S002003'">9210103</xsl:when>
  <xsl:when test="$jobcode='S002004'">9210103</xsl:when>  
  <xsl:when test="$jobcode='S002005'">9210103</xsl:when>  
  <xsl:when test="$jobcode='S002006'">9210103</xsl:when>  
  <xsl:when test="$jobcode='S002007'">9210103</xsl:when>  
  <xsl:when test="$jobcode='S002008'">9210103</xsl:when>
  <xsl:when test="$jobcode='S002009'">9210103</xsl:when>
  <xsl:when test="$jobcode='S002010'">9210103</xsl:when>
  <xsl:when test="$jobcode='S002011'">9210103</xsl:when>
  <xsl:when test="$jobcode='S002012'">9210103</xsl:when>
  <xsl:when test="$jobcode='S002013'">9210103</xsl:when>
  <xsl:when test="$jobcode='S003001'">9210104</xsl:when>
  <xsl:when test="$jobcode='S003002'">9210104</xsl:when>
  <xsl:when test="$jobcode='S003003'">9210104</xsl:when>
  <xsl:when test="$jobcode='S003004'">9210104</xsl:when>  
  <xsl:when test="$jobcode='S003005'">9210104</xsl:when>  
  <xsl:when test="$jobcode='S003006'">9210104</xsl:when>  
  <xsl:when test="$jobcode='S003007'">9210104</xsl:when>  
  <xsl:when test="$jobcode='S003008'">9210104</xsl:when>
  <xsl:when test="$jobcode='S003009'">9210104</xsl:when>
  <xsl:when test="$jobcode='S003010'">9210104</xsl:when>
  <xsl:when test="$jobcode='S003011'">9210104</xsl:when>
  <xsl:when test="$jobcode='S003012'">9210104</xsl:when>
  <xsl:when test="$jobcode='S003013'">9210104</xsl:when>
  <xsl:when test="$jobcode='S003014'">9210104</xsl:when>
  <xsl:when test="$jobcode='S004001'">9210104</xsl:when>
  <xsl:when test="$jobcode='S004002'">9210104</xsl:when>
  <xsl:when test="$jobcode='S004003'">9210104</xsl:when>
  <xsl:when test="$jobcode='S004004'">9210104</xsl:when>  
  <xsl:when test="$jobcode='S004005'">9210104</xsl:when>  
  <xsl:when test="$jobcode='S004006'">9210104</xsl:when>  
  <xsl:when test="$jobcode='S004007'">9210104</xsl:when>  
  <xsl:when test="$jobcode='S004008'">9210104</xsl:when>
  <xsl:when test="$jobcode='S005001'">9210104</xsl:when>
  <xsl:when test="$jobcode='S005002'">9210104</xsl:when>
  <xsl:when test="$jobcode='S005003'">9210104</xsl:when>
  <xsl:when test="$jobcode='S005004'">9210104</xsl:when>  
  <xsl:when test="$jobcode='S005005'">9210104</xsl:when>  
  <xsl:when test="$jobcode='S005006'">9210104</xsl:when>  
  <xsl:when test="$jobcode='S005007'">9210104</xsl:when>  
  <xsl:when test="$jobcode='S005008'">9210104</xsl:when>
  <xsl:when test="$jobcode='S005009'">9210104</xsl:when>
  <xsl:when test="$jobcode='T001001'">9210105</xsl:when>
  <xsl:when test="$jobcode='T001002'">9210105</xsl:when>
  <xsl:when test="$jobcode='T001003'">9210105</xsl:when>
  <xsl:when test="$jobcode='T001004'">9210105</xsl:when>
  <xsl:when test="$jobcode='T001005'">9210105</xsl:when>
  <xsl:when test="$jobcode='T001006'">9210105</xsl:when>
  <xsl:when test="$jobcode='T001007'">9210105</xsl:when>
  <xsl:when test="$jobcode='T001008'">9210105</xsl:when>
  <xsl:when test="$jobcode='T001009'">9210105</xsl:when>
  <xsl:when test="$jobcode='T001010'">9210105</xsl:when>
  <xsl:when test="$jobcode='T001011'">9210105</xsl:when>
  <xsl:when test="$jobcode='T001012'">9210105</xsl:when>
  <xsl:when test="$jobcode='T001013'">9210105</xsl:when>
  <xsl:when test="$jobcode='T001014'">9210105</xsl:when>
  <xsl:when test="$jobcode='T001015'">9210105</xsl:when>
  <xsl:when test="$jobcode='T001016'">9210105</xsl:when>
  <xsl:when test="$jobcode='T001017'">9210105</xsl:when>
  <xsl:when test="$jobcode='T002001'">9210104</xsl:when>
  <xsl:when test="$jobcode='T002002'">9210104</xsl:when>
  <xsl:when test="$jobcode='T002003'">9210104</xsl:when>
  <xsl:when test="$jobcode='T002004'">9210104</xsl:when>  
  <xsl:when test="$jobcode='T002005'">9210104</xsl:when>  
  <xsl:when test="$jobcode='T002006'">9210104</xsl:when>  
  <xsl:when test="$jobcode='T002007'">9210104</xsl:when>  
  <xsl:when test="$jobcode='T002008'">9210104</xsl:when>
  <xsl:when test="$jobcode='T002009'">9210104</xsl:when>
  <xsl:when test="$jobcode='T002010'">9210104</xsl:when>
  <xsl:when test="$jobcode='T002011'">9210104</xsl:when>
  <xsl:when test="$jobcode='T002012'">9210104</xsl:when>
  <xsl:when test="$jobcode='T002013'">9210104</xsl:when>
  <xsl:when test="$jobcode='T002014'">9210104</xsl:when>  
  <xsl:when test="$jobcode='T002015'">9210104</xsl:when>  
  <xsl:when test="$jobcode='T002016'">9210104</xsl:when>  
  <xsl:when test="$jobcode='T002017'">9210104</xsl:when>  
  <xsl:when test="$jobcode='T002018'">9210104</xsl:when>
  <xsl:when test="$jobcode='T002019'">9210104</xsl:when>
  <xsl:when test="$jobcode='T002020'">9210104</xsl:when>
  <xsl:when test="$jobcode='T002021'">9210104</xsl:when>
  <xsl:when test="$jobcode='T002022'">9210104</xsl:when>
  <xsl:when test="$jobcode='T002023'">9210104</xsl:when>
  <xsl:when test="$jobcode='T002024'">9210104</xsl:when>  
  <xsl:when test="$jobcode='T002025'">9210104</xsl:when>  
  <xsl:when test="$jobcode='T002026'">9210104</xsl:when>  
  <xsl:when test="$jobcode='T002027'">9210104</xsl:when>  
  <xsl:when test="$jobcode='T002028'">9210104</xsl:when>
  <xsl:when test="$jobcode='T002029'">9210104</xsl:when>
  <xsl:when test="$jobcode='T002030'">9210104</xsl:when>
  <xsl:when test="$jobcode='T002031'">9210104</xsl:when>
  <xsl:when test="$jobcode='T002032'">9210104</xsl:when>
  <xsl:when test="$jobcode='W001003'">9210101</xsl:when>
  <xsl:when test="$jobcode='W001004'">9210101</xsl:when>
  <xsl:when test="$jobcode='W001005'">9210101</xsl:when>
  <xsl:when test="$jobcode='W001006'">9210101</xsl:when>
  <xsl:when test="$jobcode='W001007'">9210101</xsl:when>
  <xsl:when test="$jobcode='W001008'">9210101</xsl:when>
  <xsl:when test="$jobcode='W001009'">9210101</xsl:when>
  <xsl:when test="$jobcode='W001010'">9210101</xsl:when>
  <xsl:when test="$jobcode='W001011'">9210101</xsl:when>
  <xsl:when test="$jobcode='W001012'">9210101</xsl:when>
  <xsl:when test="$jobcode='W001001'">9210101</xsl:when>
  <xsl:when test="$jobcode='W001002'">9210101</xsl:when>
  <xsl:when test="$jobcode='W002001'">9210106</xsl:when>
  <xsl:when test="$jobcode='W002002'">9210106</xsl:when>
  <xsl:when test="$jobcode='W002003'">9210106</xsl:when>
  <xsl:when test="$jobcode='W002004'">9210106</xsl:when>
  <xsl:when test="$jobcode='W002005'">9210106</xsl:when>
  <xsl:when test="$jobcode='W002006'">9210106</xsl:when>
  <xsl:when test="$jobcode='X001001'">9210101</xsl:when>
  <xsl:when test="$jobcode='X001002'">9210102</xsl:when>
  <xsl:when test="$jobcode='X001003'">9210102</xsl:when>
  <xsl:when test="$jobcode='X001004'">9210108</xsl:when>
  <xsl:when test="$jobcode='X001005'">9210102</xsl:when>  
  <xsl:when test="$jobcode='X001006'">9210102</xsl:when>
  <xsl:when test="$jobcode='X001007'">9210102</xsl:when>  
  <xsl:when test="$jobcode='X001008'">9210102</xsl:when>
  <xsl:when test="$jobcode='X001009'">9210102</xsl:when>  
  <xsl:when test="$jobcode='X001010'">9210102</xsl:when>
  <xsl:when test="$jobcode='X001011'">9210102</xsl:when>  
  <xsl:when test="$jobcode='X001012'">9210102</xsl:when>
  <xsl:when test="$jobcode='X001013'">9210102</xsl:when>  
  <xsl:when test="$jobcode='X001014'">9210102</xsl:when>
  <xsl:when test="$jobcode='X001015'">9210102</xsl:when>  
  <xsl:when test="$jobcode='X001016'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y001001'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y001002'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y001003'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y001004'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y001005'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y001006'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y001007'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y001008'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y001009'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y001010'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y001011'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y001012'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y001013'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y001014'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y001015'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y001016'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y001017'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y001018'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y001019'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y001020'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y001021'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y001022'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y001023'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y001024'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y002025'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y002026'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y002027'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y002028'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y002029'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y002030'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y002031'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y002032'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y002033'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y002034'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y002035'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y002036'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y002037'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y002038'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y002039'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y002040'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y002001'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y002002'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y002003'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y002004'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y002005'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y002006'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y002007'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y002008'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y002009'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y002010'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y002011'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y002012'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y002013'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y002014'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y002015'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y002016'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y002017'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y002018'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y002019'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y002020'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y002021'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y002022'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y002023'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y002024'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y003001'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y003002'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y003003'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y003004'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y003005'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y003006'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y003007'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y003008'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y003009'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y003010'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y003011'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y003012'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y003013'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y003014'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y003015'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y003016'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y002017'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y004001'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y004002'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y004003'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y004004'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y004005'">9210102</xsl:when>  
  <xsl:when test="$jobcode='Y004006'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y004007'">9210108</xsl:when>
  <xsl:when test="$jobcode='Y004008'">9210108</xsl:when>
  <xsl:when test="$jobcode='Y004009'">9210108</xsl:when>
  <xsl:when test="$jobcode='Y004010'">9210108</xsl:when>
  <xsl:when test="$jobcode='Y004011'">9210108</xsl:when>
  <xsl:when test="$jobcode='Y004012'">9210105</xsl:when>
  <xsl:when test="$jobcode='Y004013'">9210105</xsl:when>
  <xsl:when test="$jobcode='Y004014'">9210105</xsl:when>
  <xsl:when test="$jobcode='Y004015'">9210105</xsl:when>
  <xsl:when test="$jobcode='Y004016'">9210105</xsl:when>
  <xsl:when test="$jobcode='Y004017'">9210105</xsl:when>
  <xsl:when test="$jobcode='Y004018'">9210105</xsl:when>
  <xsl:when test="$jobcode='Y005001'">9210105</xsl:when>
  <xsl:when test="$jobcode='Y005002'">9210107</xsl:when>
  <xsl:when test="$jobcode='Y005003'">9210107</xsl:when>
  <xsl:when test="$jobcode='Y005004'">9210107</xsl:when>
  <xsl:when test="$jobcode='Y005005'">9210107</xsl:when>
  <xsl:when test="$jobcode='Y005006'">9210107</xsl:when>
  <xsl:when test="$jobcode='Y005007'">9210107</xsl:when>
  <xsl:when test="$jobcode='Y005008'">9210107</xsl:when>
  <xsl:when test="$jobcode='Y005009'">9210107</xsl:when>
  <xsl:when test="$jobcode='Y005010'">9210107</xsl:when>
  <xsl:when test="$jobcode='Y005011'">9210107</xsl:when>
  <xsl:when test="$jobcode='Y005012'">9210107</xsl:when>
  <xsl:when test="$jobcode='Y006001'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006002'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006003'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006004'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006005'">9210108</xsl:when>
  <xsl:when test="$jobcode='Y006006'">9210108</xsl:when>
  <xsl:when test="$jobcode='Y006007'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006008'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006009'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006010'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006011'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006012'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006013'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006014'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006015'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006016'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006017'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006018'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006019'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006020'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006021'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006022'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006023'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006024'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006025'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006026'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006027'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006028'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006029'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006030'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006031'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006032'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006033'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006034'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006035'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006036'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006037'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006038'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006039'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006040'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006041'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006042'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006046'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006047'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006048'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006049'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006050'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006051'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006052'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006053'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006054'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006055'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006056'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006057'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006058'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006059'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006060'">9210102</xsl:when>
  <xsl:when test="$jobcode='Y006061'">9210104</xsl:when>
  <xsl:when test="$jobcode='Y006062'">9210104</xsl:when>
  <xsl:when test="$jobcode='Y006063'">9210104</xsl:when>
  <xsl:when test="$jobcode='Y006064'">9210104</xsl:when>
  <xsl:when test="$jobcode='Y006065'">9210104</xsl:when>
  <xsl:when test="$jobcode='Y006066'">9210104</xsl:when>
  <xsl:when test="$jobcode='Y006067'">9210104</xsl:when>
  <xsl:when test="$jobcode='Y006068'">9210104</xsl:when>
  <xsl:when test="$jobcode='Y006069'">9210104</xsl:when>
  <xsl:when test="$jobcode='Y006070'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z001001'">9210105</xsl:when>
  <xsl:when test="$jobcode='Z001002'">9210105</xsl:when>
  <xsl:when test="$jobcode='Z001003'">9210105</xsl:when>  
  <xsl:when test="$jobcode='Z001004'">9210105</xsl:when>
  <xsl:when test="$jobcode='Z001005'">9210105</xsl:when>  
  <xsl:when test="$jobcode='Z001006'">9210105</xsl:when>
  <xsl:when test="$jobcode='Z001007'">9210105</xsl:when>  
  <xsl:when test="$jobcode='Z001008'">9210105</xsl:when>
  <xsl:when test="$jobcode='Z001009'">9210105</xsl:when>  
  <xsl:when test="$jobcode='Z002001'">9210105</xsl:when>
  <xsl:when test="$jobcode='Z002002'">9210105</xsl:when>
  <xsl:when test="$jobcode='Z002003'">9210105</xsl:when>  
  <xsl:when test="$jobcode='Z002004'">9210105</xsl:when>
  <xsl:when test="$jobcode='Z002005'">9210105</xsl:when>  
  <xsl:when test="$jobcode='Z002006'">9210105</xsl:when>
  <xsl:when test="$jobcode='Z003001'">9210108</xsl:when>
  <xsl:when test="$jobcode='Z004001'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004002'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004003'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004004'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004005'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004006'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004007'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004008'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004009'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004010'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004011'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004012'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004013'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004014'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004015'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004016'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004017'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004018'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004019'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004020'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004021'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004022'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004023'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004024'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004025'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004026'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004027'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004028'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004029'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004030'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004033'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004034'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004035'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004036'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004037'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004038'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004039'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004040'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004041'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004042'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004043'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004044'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004045'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004046'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004047'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004048'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004049'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004050'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004051'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004052'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004053'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004054'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004031'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004032'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004055'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004065'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004056'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004066'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004057'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004067'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004058'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004068'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004059'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004069'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004060'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004070'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004061'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004062'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z004063'">9210104</xsl:when>  
  <xsl:when test="$jobcode='Z004064'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z005001'">9210102</xsl:when>
  <xsl:when test="$jobcode='Z005002'">9210102</xsl:when>
  <xsl:when test="$jobcode='Z005003'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z005004'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z005005'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z005006'">9210104</xsl:when>
  <xsl:when test="$jobcode='Z005007'">9210107</xsl:when>
  <xsl:when test="$jobcode='Z005008'">9210107</xsl:when>
  <xsl:when test="$jobcode='Z005009'">9210107</xsl:when>
  <xsl:when test="$jobcode='Z005010'">9210107</xsl:when>  
  <xsl:when test="$jobcode='Z005011'">9210107</xsl:when>
  <xsl:when test="$jobcode='Z005010'">9210107</xsl:when>  
  <xsl:when test="$jobcode='Z005011'">9210107</xsl:when>  
  <xsl:when test="$jobcode='Z005012'">9210107</xsl:when>  
  <xsl:when test="$jobcode='Z005013'">9210107</xsl:when>
  <xsl:when test="$jobcode='Z005014'">9210107</xsl:when>  
  <xsl:when test="$jobcode='Z005015'">9210107</xsl:when>
  <xsl:when test="$jobcode='Z005016'">9210107</xsl:when>  
  <xsl:when test="$jobcode='Z005017'">9210107</xsl:when>
  <xsl:when test="$jobcode='Z006001'">9210101</xsl:when>
  <xsl:when test="$jobcode='Z006002'">9210101</xsl:when>
  <xsl:when test="$jobcode='Z006003'">9210101</xsl:when>
  <xsl:when test="$jobcode='Z006004'">9210101</xsl:when>
  <xsl:when test="$jobcode='Z006005'">9210101</xsl:when>
  <xsl:when test="$jobcode='Z007001'">9210101</xsl:when>
  <xsl:when test="$jobcode='Z007002'">9210101</xsl:when>
  <xsl:when test="$jobcode='Z007003'">9210101</xsl:when>
  <xsl:when test="$jobcode='Z008001'">9210101</xsl:when>
  <xsl:when test="$jobcode='Z008002'">9210101</xsl:when>
  <xsl:when test="$jobcode='Z008003'">9210101</xsl:when>
  <xsl:when test="$jobcode='Z008004'">9210101</xsl:when>
  <xsl:when test="$jobcode='Z008005'">9210101</xsl:when>  
                           	
	<!--  <xsl:when test="$jobcode=5">8010101</xsl:when>	��ҵ -->	
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ������ȡ��ʽ -->
<xsl:template name="tran_BonusGetMode">
<xsl:param name="bonusgetmode" />
<xsl:choose>
	<xsl:when test="$bonusgetmode=1">1</xsl:when>	<!-- �ۼ���Ϣ -->
	<xsl:when test="$bonusgetmode=2">3</xsl:when>	<!-- �ֽ����� -->
	<xsl:when test="$bonusgetmode=3">5</xsl:when>	<!-- ����� -->
	<xsl:when test="$bonusgetmode=4">4</xsl:when>	<!-- ֱ�Ӹ���  -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ������Դ -->
<xsl:template match="TBR_AVR_TYPE">
	<xsl:choose>
		<xsl:when test=".='2'">1</xsl:when><!--	���� -->
		<xsl:when test=".='1'">2</xsl:when><!--	ũ�� -->
		<xsl:otherwise></xsl:otherwise><!--	���� -->
	</xsl:choose>
</xsl:template>

<!-- �������ͷ�ʽ -->
<xsl:template name="tran_getPolMode">
<xsl:param name="getPolMode" />
<xsl:choose>
	<xsl:when test="$getPolMode=1">1</xsl:when>	<!-- �ʼ� -->
	<xsl:when test="$getPolMode=4">2</xsl:when>	<!-- ���й�����ȡ -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ���� -->
<xsl:template match="COUNTRY_CODE">
	<xsl:choose>
		<xsl:when test=".='ABW'">AW</xsl:when><!--	��³�� -->
		<xsl:when test=".='AFG'">AF</xsl:when><!--	������ -->
        <xsl:when test=".='AGO'">AO</xsl:when><!--  ������        -->
        <xsl:when test=".='AIA'">AI</xsl:when><!--  ������        -->
        <xsl:when test=".='ALB'">AL</xsl:when><!--  ����������    -->
        <xsl:when test=".='AND'">AD</xsl:when><!--  ������        -->
        <xsl:when test=".='ANT'">AN</xsl:when><!--  ����������˹  -->
        <xsl:when test=".='ARE'">AE</xsl:when><!--  ������        -->
        <xsl:when test=".='ARG'">AR</xsl:when><!--  ����͢        -->
        <xsl:when test=".='ARM'">AM</xsl:when><!--  ��������      -->
        <xsl:when test=".='ASM'">AS</xsl:when><!--  ����Ħ��      -->
        <xsl:when test=".='ATA'">OTH</xsl:when><!-- ����          -->
        <xsl:when test=".='ATG'">AG</xsl:when><!--  ����ϺͰͲ���-->
        <xsl:when test=".='AUS'">AU</xsl:when><!--  �Ĵ�����   -->
        <xsl:when test=".='AUT'">AT</xsl:when><!--  �µ���     -->
        <xsl:when test=".='AZE'">AZ</xsl:when><!--  �����ݽ�   -->
        <xsl:when test=".='BDI'">BI</xsl:when><!--  ��¡��     -->
        <xsl:when test=".='BEL'">BE</xsl:when><!--  ����ʱ     -->
        <xsl:when test=".='BEN'">BJ</xsl:when><!--  ����       -->
        <xsl:when test=".='BFA'">BF</xsl:when><!--  �����ɷ��� -->
        <xsl:when test=".='BGD'">BD</xsl:when><!--  �ϼ���     -->
        <xsl:when test=".='BGR'">BG</xsl:when><!--  ��������   -->
        <xsl:when test=".='BHR'">BH</xsl:when><!--  ����       -->
        <xsl:when test=".='BHS'">BS</xsl:when><!--  �͹���     -->
        <xsl:when test=".='BIH'">BA</xsl:when><!--  ��˹���ǣ�������ά��  -->
        <xsl:when test=".='BLR'">BY</xsl:when><!--  �׶���˹  -->
        <xsl:when test=".='BLZ'">BZ</xsl:when><!--  ������    -->
        <xsl:when test=".='BMU'">BM</xsl:when><!--  ��Ľ��    -->
        <xsl:when test=".='BOL'">BO</xsl:when><!--  ����ά��  -->
        <xsl:when test=".='BRA'">BR</xsl:when><!--  ����      -->
        <xsl:when test=".='BRB'">BB</xsl:when><!--  �ͰͶ���  -->
        <xsl:when test=".='BRN'">BN</xsl:when><!--  ����      -->
        <xsl:when test=".='BTN'">BT</xsl:when><!--  ����      -->
        <xsl:when test=".='BVT'">OTH</xsl:when><!--  ����     -->
        <xsl:when test=".='BWA'">BW</xsl:when><!--  ��������  -->
        <xsl:when test=".='CAF'">CF</xsl:when><!--  �зǹ��͹�-->
        <xsl:when test=".='CAN'">CA</xsl:when><!--  ���ô�    -->
        <xsl:when test=".='CCK'">OTH</xsl:when><!--  ����     -->
        <xsl:when test=".='CHE'">CH</xsl:when><!--  ��ʿ      -->
        <xsl:when test=".='CHL'">CL</xsl:when><!--  ����      -->
        <xsl:when test=".='CHN'">CHN</xsl:when><!--  �й�     -->
        <xsl:when test=".='CIV'">CI</xsl:when><!--  ���ص���  -->
        <xsl:when test=".='CMR'">CM</xsl:when><!--  ����¡        -->
        <xsl:when test=".='COD'">CG</xsl:when><!--  �չ�����    -->
        <xsl:when test=".='COG'">ZR</xsl:when><!--  �չ�������    -->
        <xsl:when test=".='COK'">CK</xsl:when><!--  ���Ⱥ��      -->
        <xsl:when test=".='COL'">CO</xsl:when><!--  ���ױ���      -->
        <xsl:when test=".='COM'">KM</xsl:when><!--  ��Ħ��Ⱥ��    -->
        <xsl:when test=".='CPV'">CV</xsl:when><!--  ��ý�Ⱥ��    -->
        <xsl:when test=".='CRI'">CR</xsl:when><!--  ��˹�����    -->
        <xsl:when test=".='CUB'">CU</xsl:when><!--  �Ű�          -->
        <xsl:when test=".='CSR'">OTH</xsl:when><!--  ����         -->
        <xsl:when test=".='CYM'">KY</xsl:when><!--  ����Ⱥ��      -->
        <xsl:when test=".='CYP'">CY</xsl:when><!--  ����·˹      -->
        <xsl:when test=".='CZE'">CZ</xsl:when><!--  �ݿ˹��͹�    -->
        <xsl:when test=".='DEU'">DE</xsl:when><!--  �¹�          -->
        <xsl:when test=".='DJI'">DJ</xsl:when><!--  ������        -->
        <xsl:when test=".='DMA'">DM</xsl:when><!--  �����������  -->
        <xsl:when test=".='DNK'">DK</xsl:when><!--  ����          -->
        <xsl:when test=".='DOM'">DO</xsl:when><!--  ������ӹ��͹�-->
        <xsl:when test=".='DZA'">DZ</xsl:when><!--  ���������� -->
        <xsl:when test=".='ECU'">EC</xsl:when><!--  ��϶��   -->
        <xsl:when test=".='EGY'">EG</xsl:when><!--  ����       -->
        <xsl:when test=".='ERI'">ER</xsl:when><!--  ���������� -->
        <xsl:when test=".='ESH'">OTH</xsl:when><!--   ����     -->   
        <xsl:when test=".='ESP'">ES</xsl:when><!--   ������    -->
        <xsl:when test=".='EST'">EE</xsl:when><!--   ��ɳ����  -->
        <xsl:when test=".='ETH'">ET</xsl:when><!--   ���������-->
        <xsl:when test=".='FIN'">FI</xsl:when><!--   ����      -->
        <xsl:when test=".='FJI'">FJ</xsl:when><!--   쳼�      -->
        <xsl:when test=".='FLK'">OTH</xsl:when><!--   ����     -->
        <xsl:when test=".='FRA'">FR</xsl:when><!--   ����      -->
        <xsl:when test=".='FRO'">FO</xsl:when><!--  ��Ⱥ��     -->
        <xsl:when test=".='FSM'">OTH</xsl:when><!-- ��?        -->
        <xsl:when test=".='GAB'">GA</xsl:when><!--   ����      -->
        <xsl:when test=".='GBR'">GB</xsl:when><!--   Ӣ��      -->
        <xsl:when test=".='GEO'">GE</xsl:when><!--   ��³����  -->
        <xsl:when test=".='GHA'">GH</xsl:when><!--   ����      -->
        <xsl:when test=".='GIB'">GI</xsl:when><!--   ֱ������  -->
        <xsl:when test=".='GIN'">GN</xsl:when><!--   ������    -->
        <xsl:when test=".='GLP'">GP</xsl:when><!--   �ϵ�����  -->
        <xsl:when test=".='GMB'">GM</xsl:when><!--   �Ա���    -->
        <xsl:when test=".='GNB'">GW</xsl:when><!--   �����Ǳ��� -->
        <xsl:when test=".='GNQ'">GQ</xsl:when><!--   ��������� -->
        <xsl:when test=".='GRC'">GR</xsl:when><!--   ϣ��       -->
        <xsl:when test=".='GRD'">GD</xsl:when><!--   �����ɴ�   -->
        <xsl:when test=".='GRL'">GL</xsl:when><!--   ��������   -->
        <xsl:when test=".='GTM'">GT</xsl:when><!--   Σ������   -->
        <xsl:when test=".='GUF'">GF</xsl:when><!--   ���������� -->
        <xsl:when test=".='ATF'">OTH</xsl:when><!--   ����      -->
        <xsl:when test=".='GUM'">GU</xsl:when><!--   �ص�       -->
        <xsl:when test=".='GUY'">GY</xsl:when><!--   ������     -->
        <xsl:when test=".='HKG'">CHN</xsl:when><!--   �й�      -->
        <xsl:when test=".='HMD'">OTH</xsl:when><!--   ����      -->
        <xsl:when test=".='HND'">HN</xsl:when><!--   �鶼��˹   -->
        <xsl:when test=".='HRV'">HR</xsl:when><!--   ���޵���   -->
        <xsl:when test=".='HTI'">HT</xsl:when><!--   ����       -->
        <xsl:when test=".='HUN'">HU</xsl:when><!--   ������     -->
        <xsl:when test=".='IDN'">ID</xsl:when><!--   ӡ�������� -->
        <xsl:when test=".='IND'">IN</xsl:when><!--   ӡ��       -->
        <xsl:when test=".='IOT'">OTH</xsl:when><!--   ����      -->
        <xsl:when test=".='IRL'">IE</xsl:when><!--   ������     -->
        <xsl:when test=".='IRN'">IR</xsl:when><!--   ����   -->
        <xsl:when test=".='IRQ'">IQ</xsl:when><!--   ������ -->
        <xsl:when test=".='ISL'">IS</xsl:when><!--   ����   -->
        <xsl:when test=".='ISR'">IL</xsl:when><!--   ��ɫ�� -->
        <xsl:when test=".='ITA'">IT</xsl:when><!--   ����� -->
        <xsl:when test=".='JAM'">JM</xsl:when><!--   ����� -->
        <xsl:when test=".='JOR'">JO</xsl:when><!--   Լ��   -->
        <xsl:when test=".='JPN'">JP</xsl:when><!--   �ձ�   -->
        <xsl:when test=".='KAZ'">KZ</xsl:when><!--   ������˹̹-->
        <xsl:when test=".='KEN'">KE</xsl:when><!--   ������    -->
        <xsl:when test=".='KGZ'">KG</xsl:when><!--   ������˼  -->
        <xsl:when test=".='KHM'">KH</xsl:when><!--   ����կ    -->
        <xsl:when test=".='KIR'">KT</xsl:when><!--   ������˹  -->
        <xsl:when test=".='KNA'">SX</xsl:when><!--   ʥ���ĺ���ά˹��-->
        <xsl:when test=".='KOR'">KR</xsl:when><!--   ����      -->
        <xsl:when test=".='KWT'">KW</xsl:when><!--   ������    -->
        <xsl:when test=".='LAO'">LA</xsl:when><!--   ����      -->
        <xsl:when test=".='LBN'">LB</xsl:when><!--   �����    -->
        <xsl:when test=".='LBR'">LR</xsl:when><!--   ��������  -->
        <xsl:when test=".='LBY'">LY</xsl:when><!--   ������    -->
        <xsl:when test=".='LCA'">SQ</xsl:when><!--   ʥ¬����  -->
        <xsl:when test=".='LIE'">LI</xsl:when><!--   ��֧��ʿ��-->
        <xsl:when test=".='LKA'">LK</xsl:when><!--   ˹������  -->
        <xsl:when test=".='LSO'">LS</xsl:when><!--   ������    -->
        <xsl:when test=".='LTU'">LT</xsl:when><!--   ������    -->
        <xsl:when test=".='LUX'">LU</xsl:when><!--   ¬ɭ��    -->
        <xsl:when test=".='LVA'">LV</xsl:when><!--   ����ά��  -->
        <xsl:when test=".='MAC'">CHN</xsl:when><!--   �й�     -->
        <xsl:when test=".='MAR'">MA</xsl:when><!--   Ħ���    -->
        <xsl:when test=".='MCO'">MC</xsl:when><!--   Ħ�ɸ�    -->
        <xsl:when test=".='MDA'">MD</xsl:when><!--   Ħ������  -->
        <xsl:when test=".='MDG'">MG</xsl:when><!--   ����˹��-->
        <xsl:when test=".='MDV'">MV</xsl:when><!--   �������  -->
        <xsl:when test=".='MEX'">MX</xsl:when><!--   ī����    -->
        <xsl:when test=".='MHL'">MH</xsl:when><!--   ���ٶ�Ⱥ��-->
        <xsl:when test=".='MKD'">MK</xsl:when><!--   �����    -->
        <xsl:when test=".='MLI'">ML</xsl:when><!--   ����      -->
        <xsl:when test=".='MLT'">MT</xsl:when><!--   �����    -->
        <xsl:when test=".='MMR'">MM</xsl:when><!--   ���      -->
        <xsl:when test=".='MNG'">MN</xsl:when><!--    �ɹ�     -->
        <xsl:when test=".='MNP'">MP</xsl:when><!--    ����������Ⱥ��-->
        <xsl:when test=".='MOZ'">MZ</xsl:when><!--    Īɣ�ȿ�      -->
        <xsl:when test=".='MRT'">MR</xsl:when><!--    ë��������    -->
        <xsl:when test=".='MSR'">MS</xsl:when><!--    ����������    -->
        <xsl:when test=".='MTQ'">MQ</xsl:when><!--    �������      -->
        <xsl:when test=".='MUS'">MU</xsl:when><!--    ë����˹      -->
        <xsl:when test=".='MWI'">MW</xsl:when><!--    ����ά        -->
        <xsl:when test=".='MYS'">MY</xsl:when><!--    ��������      -->
        <xsl:when test=".='MYT'">YT</xsl:when><!--    ��Լ�ص�      -->
        <xsl:when test=".='NAM'">NA</xsl:when><!--    ���ױ���      -->
        <xsl:when test=".='NCL'">NC</xsl:when><!--    �¿��������-->
        <xsl:when test=".='NER'">NE</xsl:when><!--    ���ն�      -->
        <xsl:when test=".='NFK'">NF</xsl:when><!--    ŵ����Ⱥ��  -->
        <xsl:when test=".='NGA'">NG</xsl:when><!--    ��������    -->
        <xsl:when test=".='NIC'">NI</xsl:when><!--    �������    -->
        <xsl:when test=".='NIU'">NU</xsl:when><!--    Ŧ����      -->
        <xsl:when test=".='NLD'">NL</xsl:when><!--    ����        -->
        <xsl:when test=".='NOR'">NO</xsl:when><!--    Ų��        -->
        <xsl:when test=".='NPL'">NP</xsl:when><!--    �Ჴ��      -->
        <xsl:when test=".='NRU'">NR</xsl:when><!--    �³        -->
        <xsl:when test=".='NZL'">NZ</xsl:when><!--    ������      -->
        <xsl:when test=".='OMN'">OM</xsl:when><!--    ����        -->
        <xsl:when test=".='PAK'">PK</xsl:when><!--    �ͻ�˹̹-->
        <xsl:when test=".='PAN'">PA</xsl:when><!--    ������  -->
        <xsl:when test=".='PCN'">OTH</xsl:when><!--    ����   -->
        <xsl:when test=".='PER'">PE</xsl:when><!--    ��³    -->
        <xsl:when test=".='PHL'">PH</xsl:when><!--    ���ɱ�  -->
        <xsl:when test=".='PLW'">OTH</xsl:when><!--    ����   -->
        <xsl:when test=".='PNG'">PG</xsl:when><!--    �Ͳ����¼�����-->
        <xsl:when test=".='POL'">PL</xsl:when><!--    ����    -->
        <xsl:when test=".='PRI'">PR</xsl:when><!--    �������-->
        <xsl:when test=".='PRK'">KP</xsl:when><!--    ����    -->
        <xsl:when test=".='PRT'">PT</xsl:when><!--    ������  -->
        <xsl:when test=".='PRY'">PY</xsl:when><!--    ������  -->
        <xsl:when test=".='PSE'">OTH</xsl:when><!--    ����   -->
        <xsl:when test=".='PYF'">PF</xsl:when><!--    ��������������-->
        <xsl:when test=".='QAT'">QA</xsl:when><!--    ������    -->
        <xsl:when test=".='REU'">RE</xsl:when><!--    ��������  -->
        <xsl:when test=".='ROM'">RO</xsl:when><!--    ��������  -->
        <xsl:when test=".='RUS'">RU</xsl:when><!--    ����˹    -->
        <xsl:when test=".='RWA'">RW</xsl:when><!--    ¬����    -->
        <xsl:when test=".='SAU'">SA</xsl:when><!--    ɳ�ذ�����-->
        <xsl:when test=".='CSR'">OTH</xsl:when><!--    ����   -->
        <xsl:when test=".='SCG'">OTH</xsl:when><!--    ����   -->
        <xsl:when test=".='SDN'">SD</xsl:when><!--    �յ�    -->
        <xsl:when test=".='SEN'">SN</xsl:when><!--    ���ڼӶ�-->
        <xsl:when test=".='SGP'">SG</xsl:when><!--    �¼���  -->
        <xsl:when test=".='SGS'">OTH</xsl:when><!--    ����   -->
        <xsl:when test=".='SHN'">OTH</xsl:when><!--    ����   -->
        <xsl:when test=".='SJM'">OTH</xsl:when><!--  ����     -->
        <xsl:when test=".='SLB'">SB</xsl:when><!--  ������Ⱥ��-->
        <xsl:when test=".='SLE'">SL</xsl:when><!--  �����ﰺ  -->
        <xsl:when test=".='SLV'">SV</xsl:when><!--  �����߶�  -->
        <xsl:when test=".='SMR'">SM</xsl:when><!--  ʥ����ŵ  -->
        <xsl:when test=".='SOM'">SO</xsl:when><!--  ������    -->
        <xsl:when test=".='SPM'">OTH</xsl:when><!--  ����     -->
        <xsl:when test=".='STP'">ST</xsl:when><!--  ʥ��������������-->
        <xsl:when test=".='SUR'">SR</xsl:when><!--  ������    -->
        <xsl:when test=".='SVK'">SK</xsl:when><!--  ˹�工��  -->
        <xsl:when test=".='SVN'">SI</xsl:when><!--  ˹��������-->
        <xsl:when test=".='SWE'">SE</xsl:when><!--  ���      -->
        <xsl:when test=".='SWZ'">SZ</xsl:when><!--  ˹��ʿ��  -->
        <xsl:when test=".='SYC'">SC</xsl:when><!--  �����    -->
        <xsl:when test=".='SYR'">SY</xsl:when><!--  ������    -->
        <xsl:when test=".='TCA'">TC</xsl:when><!--  �ؿ�˹�Ϳ���˹Ⱥ��    -->
        <xsl:when test=".='TCD'">TD</xsl:when><!--  է�� -->
        <xsl:when test=".='TGO'">TG</xsl:when><!--  ��� -->
        <xsl:when test=".='THA'">TH</xsl:when><!--  ̩�� -->
        <xsl:when test=".='TJK'">TJ</xsl:when><!--  ������˹̹ -->
        <xsl:when test=".='TKL'">OTH</xsl:when><!--  ����      -->
        <xsl:when test=".='TKM'">TM</xsl:when><!--  ������˹̹ -->
        <xsl:when test=".='TMP'">OTH</xsl:when><!--  ����      -->
        <xsl:when test=".='TON'">TO</xsl:when><!--  ����       -->
        <xsl:when test=".='TTO'">OTH</xsl:when><!--  ����      -->
        <xsl:when test=".='TUN'">TN</xsl:when><!--  ͻ��˹     -->
        <xsl:when test=".='TUR'">TR</xsl:when><!--  ������     -->
        <xsl:when test=".='TUV'">TV</xsl:when><!--  ͼ��¬     -->
        <xsl:when test=".='TWN'">CHN</xsl:when><!--  �й�      -->
        <xsl:when test=".='TZA'">TZ</xsl:when><!--  ̹ɣ����   -->
        <xsl:when test=".='UGA'">UG</xsl:when><!--  �ڸɴ� -->
        <xsl:when test=".='UKR'">UA</xsl:when><!--  �ڿ��� -->
        <xsl:when test=".='UMI'">OTH</xsl:when><!--  ����  -->
        <xsl:when test=".='URY'">UY</xsl:when><!--  ������ -->
        <xsl:when test=".='USA'">US</xsl:when><!--  ����   -->
        <xsl:when test=".='UZB'">UZ</xsl:when><!--  ���ȱ��˹̹ -->
        <xsl:when test=".='VAT'">OTH</xsl:when><!--  ����        -->
        <xsl:when test=".='VCT'">VC</xsl:when><!--  ʥ��˹��     -->
        <xsl:when test=".='VEN'">VE</xsl:when><!--  ί������     -->
        <xsl:when test=".='VGB'">VG</xsl:when><!--  Ӣ��ά����Ⱥ��-->
        <xsl:when test=".='VIR'">VI</xsl:when><!--  ����ά����Ⱥ��-->
        <xsl:when test=".='VNM'">VN</xsl:when><!--  Խ��     -->
        <xsl:when test=".='VUT'">VU</xsl:when><!--  ��Ŭ��ͼ -->
        <xsl:when test=".='WLF'">OTH</xsl:when><!--  ����    -->
        <xsl:when test=".='WSM'">WS</xsl:when><!--  ��Ħ��-->
        <xsl:when test=".='YEM'">YE</xsl:when><!--  Ҳ��  -->
        <xsl:when test=".='ZAF'">ZA</xsl:when><!--  �Ϸ�  -->
        <xsl:when test=".='ZAR'">OTH</xsl:when><!--  ����   -->
        <xsl:when test=".='ZMB'">ZM</xsl:when><!--  �ޱ���  -->
        <xsl:when test=".='ZWE'">ZW</xsl:when><!--  ��Ͳ�Τ-->
		<xsl:otherwise></xsl:otherwise><!--	���� -->
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
