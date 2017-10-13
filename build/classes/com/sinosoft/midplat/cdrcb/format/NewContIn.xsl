<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/INSUREQ">
<TranData>    
	<xsl:apply-templates select="MAIN" />
	
	<Body>
		<ProposalPrtNo><xsl:value-of select="MAIN/APPLNO" /></ProposalPrtNo> <!-- Ͷ����(ӡˢ)�� -->
		<ContPrtNo></ContPrtNo> <!-- ������ͬӡˢ�� -->
		<PolApplyDate><xsl:value-of select="MAIN/TB_DATE" /></PolApplyDate> <!-- Ͷ������ -->
		
		<!--������������-->
		<AgentComName><xsl:value-of select="MAIN/BRACH_NAME"/></AgentComName>
		<!--����������Ա����-->
		<SellerNo><xsl:value-of select="MAIN/TELLER_NO"/></SellerNo>
				
		<AccName><xsl:value-of select="MAIN/PAYACC_NAME" /></AccName> <!-- �˻����� -->
		<AccNo><xsl:value-of select="MAIN/PAYACC" /></AccNo> <!-- �����˻� -->
		<GetPolMode></GetPolMode> <!-- �������ͷ�ʽ -->
		<JobNotice></JobNotice>   <!-- ְҵ��֪(N/Y) -->
		<HealthNotice><xsl:value-of select="MAIN/HEALTH_NOTICE_FLAG" /></HealthNotice> <!-- ������֪(N/Y)  -->	
		<PolicyIndicator></PolicyIndicator><!--δ���걻�������Ƿ����������չ�˾Ͷ����ʱ��� Y��N��-->
        <InsuredTotalFaceAmount></InsuredTotalFaceAmount><!--�ۼ�Ͷ����ʱ���-->
        
        <!-- ��Ʒ��� -->
        <ContPlan>
        	<!-- ��Ʒ��ϱ��� -->
			<ContPlanCode>
				<xsl:call-template name="tran_ContPlanCode">
					<xsl:with-param name="contPlanCode">
						<xsl:value-of select="PRODUCTS/PRODUCT/PRODUCTID" />
					</xsl:with-param>
				</xsl:call-template>
			</ContPlanCode>
			
			<!-- ��Ʒ��Ϸ��� -->
			<ContPlanMult>
				<xsl:value-of select="PRODUCTS/PRODUCT/AMT_UNIT" />
			</ContPlanMult>
        </ContPlan>
        
        
		<!-- Ͷ���� -->
		<xsl:apply-templates select="TBR" />
		
		<!-- ������ -->
		<xsl:apply-templates select="BBR" />		
		
		<!-- ������ -->
		<xsl:for-each select="SYRS/SYR">
			<xsl:choose>
				<xsl:when test="SYR_NAME!=''">
					<Bnf>
						<Type>1</Type>	<!-- Ĭ��Ϊ��1-��������ˡ� -->
					    <Grade><xsl:value-of select="SYR_ORDER" /></Grade> <!-- ����˳�� -->
					    <Name><xsl:value-of select="SYR_NAME" /></Name> <!-- ���� -->
					    <Sex><xsl:value-of select="SYR_SEX" /></Sex> <!-- �Ա� -->
					    <Birthday><xsl:value-of select="SYR_BIRTH" /></Birthday> <!-- ��������(yyyyMMdd) -->
					    <IDType>
					        <xsl:call-template name="tran_idtype">
								<xsl:with-param name="idtype">
									<xsl:value-of select="SYR_CERT_TYPE"/>
								</xsl:with-param>
							</xsl:call-template>
					    </IDType> <!-- ֤������ -->
					    <IDNo><xsl:value-of select="SYR_CERT_NO" /></IDNo> <!-- ֤������ -->
					    <RelaToInsured>
					        <xsl:call-template name="tran_relation">
								<xsl:with-param name="relation">
									<xsl:value-of select="SYR_BBR_RELATE"/>
								</xsl:with-param>
							</xsl:call-template>
					    </RelaToInsured> <!-- �뱻���˹�ϵ -->
					    <Lot><xsl:value-of select="SYR_BNFT_PROFIT" /></Lot> <!-- �������(�������ٷֱ�) -->
					</Bnf>
				</xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		
		<!-- ������Ϣ -->
		<xsl:apply-templates select="PRODUCTS/PRODUCT" />			
	</Body>
</TranData>
</xsl:template>

<xsl:template name="Head" match="MAIN">
<Head>
	<TranDate><xsl:value-of select="TRANSRDATE"/></TranDate>
    <TranTime><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur6Time()"/></TranTime>
    <TellerNo><xsl:value-of select="TELLER_NO"/></TellerNo>
    <TranNo><xsl:value-of select="TRANSRNO"/></TranNo>
    <NodeNo><xsl:value-of select="BRACH_NO"/></NodeNo>
    <xsl:copy-of select="../Head/*"/>
    <BankCode><xsl:value-of select="../Head/TranCom/@outcode"/></BankCode>
</Head>
</xsl:template>

<!-- Ͷ���� -->
<xsl:template name="Appnt" match="TBR">
<Appnt>
	<Name><xsl:value-of select="TBR_NAME" /></Name> <!-- ���� -->
	<Sex><!-- �Ա� -->
		<xsl:call-template name="tran_sex">
			<xsl:with-param name="sex">
				<xsl:value-of select="TBR_SEX"/>
			</xsl:with-param>
		</xsl:call-template>
	</Sex>
	<Birthday><xsl:value-of select="TBR_BIRTH" /></Birthday><!-- ��������(yyyyMMdd) -->
	<IDType><!-- ֤������ -->
		<xsl:call-template name="tran_idtype">
			<xsl:with-param name="idtype">
				<xsl:value-of select="TBR_CERT_TYPE"/>
			</xsl:with-param>
		</xsl:call-template>
	</IDType>
	<IDNo><xsl:value-of select="TBR_CERT_NO" /></IDNo><!-- ֤������ -->
	<IDTypeStartDate></IDTypeStartDate > <!-- ֤����Ч���� -->
    <IDTypeEndDate></IDTypeEndDate > <!-- ֤����Чֹ�� -->
	<JobCode>
	    <xsl:call-template name="tran_jobcode">
			<xsl:with-param name="jobcode">
				<xsl:value-of select="../MAIN/WORK_NOTICE_FLAG"/>
			</xsl:with-param>
		</xsl:call-template></JobCode> <!-- ְҵ���� -->
		
	<!-- Ͷ���������룬���е�λԪ�����չ�˾��λ�� -->
	<Salary>
		<xsl:choose>
			<xsl:when test="TBR_AVR_SALARY=''">
				<xsl:value-of select="TBR_AVR_SALARY" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(TBR_AVR_SALARY)"/>
			</xsl:otherwise>
		</xsl:choose>
	</Salary>
	
	<!-- �ͻ����� -->
	<LiveZone>
		<xsl:apply-templates select="TBR_AVR_TYPE" />
	</LiveZone>
	
    <Nationality>CHN</Nationality> <!-- ���� -->
    <Stature></Stature> <!-- ���(cm) -->
    <Weight></Weight> <!-- ����(kg) -->
    <MaritalStatus></MaritalStatus> <!-- ���(N/Y) -->
    <Address><xsl:value-of select="TBR_ADDR" /></Address> <!-- ��ַ -->
    <ZipCode><xsl:value-of select="TBR_POSTCODE" /></ZipCode> <!-- �ʱ� -->
    <Mobile><xsl:value-of select="TBR_MOBILE" /></Mobile> <!-- �ƶ��绰 -->
    <Phone><xsl:value-of select="TBR_TEL" /></Phone> <!-- �̶��绰 -->
    <Email></Email> <!-- �����ʼ�-->
    <RelaToInsured>
    	<xsl:call-template name="tran_relation">
			<xsl:with-param name="relation">
				<xsl:value-of select="TBR_BBR_RELATE"/>
			</xsl:with-param>
		</xsl:call-template>
    </RelaToInsured> <!-- �뱻���˹�ϵ -->
</Appnt>
</xsl:template>

<!-- ������ -->
<xsl:template name="Insured" match="BBR">
<Insured>
	<Name><xsl:value-of select="BBR_NAME" /></Name> <!-- ���� -->
    <Sex><!-- �Ա� -->
        <xsl:call-template name="tran_sex">
			<xsl:with-param name="sex">
				<xsl:value-of select="BBR_SEX"/>
			</xsl:with-param>
		</xsl:call-template>
	</Sex>
    <Birthday><xsl:value-of select="BBR_BIRTH" /></Birthday> <!-- ��������(yyyyMMdd) -->
    <IDType> <xsl:call-template name="tran_idtype">
		    <xsl:with-param name="idtype">
				<xsl:value-of select="BBR_CERT_TYPE"/>
			</xsl:with-param>
		</xsl:call-template>
	</IDType> <!-- ֤������ -->
    <IDNo><xsl:value-of select="BBR_CERT_NO" /></IDNo> <!-- ֤������ -->
    <IDTypeStartDate></IDTypeStartDate > <!-- ֤����Ч���� -->
    <IDTypeEndDate></IDTypeEndDate > <!-- ֤����Чֹ�� -->
    <JobCode>        
        <xsl:call-template name="tran_jobcode">
			<xsl:with-param name="jobcode">
				<xsl:value-of select="../MAIN/WORK_NOTICE_FLAG"/>
			</xsl:with-param>
		</xsl:call-template></JobCode> <!-- ְҵ���� -->
    <Stature></Stature> <!-- ���(cm)-->	
    <Nationality>CHN</Nationality> <!-- ����-->
    <Weight></Weight> <!-- ����(kg) -->
    <MaritalStatus></MaritalStatus> <!-- ���(N/Y) -->
    <Address><xsl:value-of select="BBR_ADDR" /></Address> <!-- ��ַ -->
    <ZipCode><xsl:value-of select="BBR_POSTCODE" /></ZipCode> <!-- �ʱ� -->
    <Mobile><xsl:value-of select="BBR_MOBILE" /></Mobile> <!-- �ƶ��绰 -->
    <Phone><xsl:value-of select="BBR_TEL" /></Phone> <!-- �̶��绰 -->
    <Email></Email> <!-- �����ʼ�-->
</Insured>
</xsl:template>

<!-- ������Ϣ  -->
<xsl:template name="Risk" match="PRODUCTS/PRODUCT">
<Risk>
	<RiskCode>
	    <xsl:call-template name="tran_riskcode">
			<xsl:with-param name="riskcode" select="PRODUCTID" />
		</xsl:call-template>
	</RiskCode><!-- ���ִ��� -->
	<MainRiskCode>
		<xsl:call-template name="tran_riskcode">
			<xsl:with-param name="riskcode" select="../PRODUCT[MAINSUBFLG='0']/PRODUCTID" />
		</xsl:call-template>
	</MainRiskCode><!-- �������ִ��� -->
	<RiskType><xsl:value-of select="PRODUCT_TYPE"/></RiskType><!-- �������� -->
	<Amnt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(AMT)"/></Amnt><!-- ����(��) -->
	<Prem><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(PREMIU_AMT)"/></Prem><!-- ���շ�(��) -->
	<Mult><xsl:value-of select="AMT_UNIT"/></Mult><!-- Ͷ������ -->
	<PayIntv><!-- �ɷ�Ƶ�� -->
		<xsl:call-template name="tran_PayIntv">
			<xsl:with-param name="payintv">
				<xsl:value-of select="../../MAIN/PAYMETHOD"/>
			</xsl:with-param>
		</xsl:call-template>
	</PayIntv>
	<PayMode>
		<xsl:call-template name="tran_PayMode">
			<xsl:with-param name="paymode">
				<xsl:value-of select="../../MAIN/PAY_METHOD"/>
			</xsl:with-param>
		</xsl:call-template>
	</PayMode><!-- �ɷ���ʽ -->
	<InsuYearFlag><!-- �������������־ -->
		<xsl:call-template name="tran_InsuYearFlag">
			<xsl:with-param name="insuyearflag">
				<xsl:value-of
					select="COVERAGE_PERIOD" />
			</xsl:with-param>
		</xsl:call-template>
	</InsuYearFlag>
	<InsuYear><!-- ������ -->
		<xsl:if test="COVERAGE_PERIOD=5">106</xsl:if>
		<xsl:if test="COVERAGE_PERIOD!=5"><xsl:value-of select="COVERAGE_YEAR" /></xsl:if>
	</InsuYear>	
	<xsl:if test="../../MAIN/PAYMETHOD = 5"><!-- ���� -->
		<PayEndYearFlag>Y</PayEndYearFlag>
		<PayEndYear>1000</PayEndYear>
	</xsl:if>
	<xsl:if test="../../MAIN/PAYMETHOD != 5">
		<PayEndYearFlag>
		<xsl:call-template name="tran_PayEndYearFlag">
			<xsl:with-param name="payendyearflag">
				<xsl:value-of
					select="CHARGE_PERIOD" />
			</xsl:with-param>
		</xsl:call-template>
	    </PayEndYearFlag><!-- �ɷ����������־ -->
		<PayEndYear><xsl:value-of select="CHARGE_YEAR"/></PayEndYear><!-- �ɷ��������� -->
	</xsl:if>

	<BonusGetMode>
		<xsl:call-template name="tran_BonusGetMode">
			<xsl:with-param name="bonusgetmode" select="DVDMETHOD" />
		</xsl:call-template>
	</BonusGetMode><!-- ������ȡ��ʽ -->
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
  	<xsl:when test="$sex = 1">0</xsl:when>
  	<xsl:when test="$sex = 2">1</xsl:when>
  	<xsl:otherwise></xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ֤������ -->
<xsl:template name="tran_idtype">
<xsl:param name="idtype" />
<xsl:choose>
	<xsl:when test="$idtype=0">0</xsl:when>	<!-- ���֤ -->
	<xsl:when test="$idtype=1">1</xsl:when>	<!-- ���� -->
	<xsl:when test="$idtype=2">2</xsl:when>	<!-- ����֤ -->
	<xsl:when test="$idtype=3">2</xsl:when>	<!-- ʿ��֤ -->
	<xsl:when test="$idtype=4">8</xsl:when>	<!-- ����֤ -->
	<xsl:when test="$idtype=5">8</xsl:when>	<!-- ��ʱ���֤ -->
	<xsl:when test="$idtype=6">5</xsl:when>	<!-- ���ڱ� -->
	<xsl:when test="$idtype=7">2</xsl:when>	<!-- ����֤ -->
	<xsl:when test="$idtype=8">4</xsl:when>	<!-- ����֤ -->
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
	<xsl:if test="$payintv = '1'">12</xsl:if> <!-- ��� -->
	<xsl:if test="$payintv = '2'">6</xsl:if>  <!-- ���꽻 -->
	<xsl:if test="$payintv = '3'">3</xsl:if>  <!-- ����-->
	<xsl:if test="$payintv = '4'">1</xsl:if>  <!-- �½� -->
	<xsl:if test="$payintv = '5'">0</xsl:if>  <!-- ���� -->
</xsl:template>

<!-- �ɷ���ʽ -->
<xsl:template name="tran_PayMode">
<xsl:param name="paymode">0</xsl:param>
	<xsl:if test="$paymode = '1'">7</xsl:if> <!-- ����ת��  -->
</xsl:template>
	
<!-- �����������ڱ�־ -->
<xsl:template name="tran_InsuYearFlag">
<xsl:param name="insuyearflag" />
<xsl:choose>
	<xsl:when test="$insuyearflag=0">D</xsl:when>	<!-- ���� -->
	<xsl:when test="$insuyearflag=1">M</xsl:when>	<!-- ���� -->
	<xsl:when test="$insuyearflag=2">Y</xsl:when>	<!-- ���� -->
	<xsl:when test="$insuyearflag=5">A</xsl:when>   <!-- ���� -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- �ɷ����������־ -->
<xsl:template name="tran_PayEndYearFlag">
<xsl:param name="payendyearflag" />
<xsl:choose>
	<xsl:when test="$payendyearflag=0">D</xsl:when>	<!-- ���� -->
	<xsl:when test="$payendyearflag=1">M</xsl:when>	<!-- ���� -->
	<xsl:when test="$payendyearflag=2">Y</xsl:when>	<!-- ���� -->
	<xsl:when test="$payendyearflag=5">A</xsl:when> <!-- ���� -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ���ִ��� -->
<!-- ��ʹ���к���˾���ִ�����ͬҲҪת����Ϊ������ĳ������ֻ���������� -->
<xsl:template name="tran_riskcode">
<xsl:param name="riskcode" />
<xsl:choose>
	<xsl:when test="$riskcode=122006">122006</xsl:when>	<!-- ����۱���2����ȫ���գ��ֺ��ͣ�A�� -->
	<xsl:when test="$riskcode=122008">122008</xsl:when>	<!-- ���������1���������գ������ͣ� -->
	<xsl:when test="$riskcode=122009">122009</xsl:when>	<!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A�� -->
	<xsl:when test="$riskcode=50002">50015</xsl:when>	<!-- �������Ӯ1����ȫ������� -->
	<!-- add by 20151109 PBKINSR-725:�ɶ�ũ��������ʢ2��ʢ3  begin-->
	<xsl:when test="$riskcode='L12079'">L12079</xsl:when>	<!-- ����ʢ��2���������գ������ͣ� -->
	<xsl:when test="$riskcode='L12078'">L12078</xsl:when>	<!-- ����ʢ��3���������գ������ͣ� -->
		<xsl:when test="$riskcode='L12080'">L12080</xsl:when> 
	<!-- ���Ӱ����5����ȫ���գ������ͣ� -->
	<xsl:when test="$riskcode='L12087'">L12087</xsl:when>	<!-- �����5����ȫ���գ������ͣ� -->
	<!-- add by 20151109 PBKINSR-725:�ɶ�ũ��������ʢ2��ʢ3  begin-->
	<!-- add by duanjz 2015-6-17 ���Ӱ���5����ϲ�Ʒ    begin -->
	<xsl:when test="$riskcode=50012">50012</xsl:when>	<!-- ����ٰ���5�ű��ռƻ� -->
	<!-- add by duanjz 2015-6-17 ���Ӱ���5����ϲ�Ʒ    end -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ��Ʒ��ϴ��� -->
<xsl:template name="tran_ContPlanCode">
	<xsl:param name="contPlanCode" />
	<xsl:choose>
		<!-- 50002(50015): 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�122048-����������������գ������ͣ���� -->
		<xsl:when test="$contPlanCode='50002'">50015</xsl:when>
		<!-- add by duanjz 2015-6-17 ���Ӱ���5����ϲ�Ʒ    begin -->
		<!-- 50012 ����ٰ���5�ű��ռƻ������գ�L12070������ٰ���5������գ���������L12071������ӳ�������5����ȫ���գ������ͣ��� -->
	    <xsl:when test="$contPlanCode='50012'">50012</xsl:when>	<!-- ����ٰ���5�ű��ռƻ� -->
	    <!-- add by duanjz 2015-6-17 ���Ӱ���5����ϲ�Ʒ    end -->
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- ְҵ���� -->
<xsl:template name="tran_jobcode">
<xsl:param name="jobcode" />
<xsl:choose>
    <xsl:when test="$jobcode=0">4030111</xsl:when>	<!-- ���һ��ء���Ⱥ��֯����ҵ����ҵ��λ��Ա -->
	<xsl:when test="$jobcode=1">3010102</xsl:when>	<!-- ���һ��ء���Ⱥ��֯����ҵ����ҵ��λ��Ա -->
	<xsl:when test="$jobcode=2">1020203</xsl:when>	<!-- ��ҵְ�ܲ��ž�������� -->
	<xsl:when test="$jobcode=3">5010101</xsl:when>	<!-- ũ��-->
	<xsl:when test="$jobcode=4">2090114</xsl:when>	<!-- ѧ�� -->
	<xsl:when test="$jobcode=5">8010101</xsl:when>	<!-- ��ҵ -->	
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
		<xsl:when test=".='1'">1</xsl:when><!--	���� -->
		<xsl:when test=".='2'">2</xsl:when><!--	ũ�� -->
		<xsl:otherwise></xsl:otherwise><!--	���� -->
	</xsl:choose>
</xsl:template>


</xsl:stylesheet>
