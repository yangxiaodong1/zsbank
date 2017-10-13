<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
	<xsl:template match="INSU">
		<TranData>
			<!-- ����ͷ -->
			<Head>
				<TranDate><xsl:value-of select="MAIN/BANK_DATE"/></TranDate>
				<xsl:variable name ="time" select ="java:com.sinosoft.midplat.common.DateUtil.getCur8Time()"/>
				<TranTime><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.time8to6($time)"/></TranTime>
				<TellerNo><xsl:value-of select="MAIN/TELLERNO"/></TellerNo>
				<TranNo><xsl:value-of select="MAIN/TRANSRNO"/></TranNo>
				<NodeNo>
					<xsl:value-of select="MAIN/ZONENO"/>
					<xsl:value-of select="MAIN/BRNO"/>
				</NodeNo>
				<xsl:copy-of select="Head/*"/>
				<BankCode><xsl:value-of select="Head/TranCom/@outcode"/></BankCode>
			</Head>
			<Body>
				<xsl:apply-templates select="MAIN" />
				<!-- Ͷ������Ϣ -->
				<xsl:apply-templates select="TBR" />
				<!-- ����������Ϣ -->
				<xsl:apply-templates select="BBR" />
				<!-- ��������Ϣ -->
				<xsl:apply-templates select="SYRS/SYR" />
				<!-- ������Ϣ -->
				<xsl:apply-templates select="PRODUCTS/PRODUCT[PRODUCTID=MAINPRODUCTID]" />
			</Body>
		</TranData>
	</xsl:template>
	
	<!-- ������ -->
	<xsl:template name="Body" match="MAIN">
		<xsl:variable name="MainRisk" select="../PRODUCTS/PRODUCT[PRODUCTID=MAINPRODUCTID]" />
		<ProposalPrtNo><xsl:value-of select="APPLYNO" /></ProposalPrtNo>
		<ContPrtNo><xsl:value-of select="BD_PRINT_NO" /></ContPrtNo>
		<PolApplyDate><xsl:value-of select="TB_DATE" /></PolApplyDate>
		<AccName><xsl:value-of select="PAYNAME" /></AccName>
		<AccNo><xsl:value-of select="PAYACC" /></AccNo>
		<GetPolMode></GetPolMode>
		<JobNotice><xsl:value-of select="../BBR/BBR_METIERDANGERINF" /></JobNotice>
		<HealthNotice><xsl:value-of select="../HEALTH_NOTICE/NOTICE_ITEM" /></HealthNotice>
		<PolicyIndicator></PolicyIndicator>
		<AgentComName><xsl:value-of select="BRNONAME" /></AgentComName>
		<AgentComCertiCode><xsl:value-of select="BRNOCERTCODE" /></AgentComCertiCode>
		<SellerNo><xsl:value-of select="MARKETER_ID" /></SellerNo>
		<TellerName><xsl:value-of select="MARKETER_NAME" /></TellerName>
		<TellerCertiCode><xsl:value-of select="MARKETER_CERTCODE" /></TellerCertiCode>
		<!-- ��Ʒ��� -->
        <ContPlan>
			<ContPlanCode>
				<xsl:call-template name="tran_contPlancode">
					<xsl:with-param name="contPlancode">
						<xsl:value-of select="$MainRisk/MAINPRODUCTID" />
					</xsl:with-param>
				</xsl:call-template>
			</ContPlanCode>
			
			<!-- ��Ʒ��Ϸ��� -->
			<ContPlanMult>
				<xsl:if test="$MainRisk/MAINPRODUCTID = 50002">
					<xsl:value-of select="format-number($MainRisk/AMT_UNIT,'#')" />
				</xsl:if>
			</ContPlanMult>
        </ContPlan>
   </xsl:template>
   <!-- Ͷ������Ϣ -->
   <xsl:template name="Appnt" match="TBR">
	<Appnt>
		<Name><xsl:value-of select="TBR_NAME" /></Name>
		<Sex>
			<xsl:call-template name="tran_Sex">
				 <xsl:with-param name="sex">
				 	<xsl:value-of select="TBR_SEX"/>
			     </xsl:with-param>
			 </xsl:call-template>
		</Sex>
		<Birthday><xsl:value-of select="TBR_BIRTH" /></Birthday>
		<IDType>
			<xsl:call-template name="tran_IDType">
				 <xsl:with-param name="idtype">
				 	<xsl:value-of select="TBR_IDTYPE"/>
			     </xsl:with-param>
			 </xsl:call-template>
		</IDType>
		<IDNo><xsl:apply-templates select="TBR_IDNO" /></IDNo>	
		<IDTypeStartDate><xsl:value-of select="TBR_IDEFFSTARTDATE" /></IDTypeStartDate>	
		<IDTypeEndDate><xsl:value-of select="TBR_IDEFFENDDATE" /></IDTypeEndDate>
		
		<JobCode><xsl:value-of select="TBR_OCCUTYPE" /></JobCode>
		<Nationality><xsl:value-of select="TBR_NATIVEPLACE"/></Nationality>
		<Stature></Stature>
		<Weight></Weight>
		<!-- Ͷ����������(����Ԫ) -->
		<xsl:choose>
			<xsl:when test="TBR_REVENUE=''">
				<Salary />
			</xsl:when>
			<xsl:otherwise>
				<Salary>
					<xsl:value-of
						select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(TBR_REVENUE)" />
				</Salary>
			</xsl:otherwise>
		</xsl:choose>
		<!-- 1.����2.ũ�� -->
		<LiveZone><xsl:apply-templates select="TBR_RESIDENTS" /></LiveZone>
		<Address><xsl:value-of select="TBR_ADDR" /></Address>
		<ZipCode><xsl:value-of select="TBR_POSTCODE" /></ZipCode>
		<Mobile><xsl:value-of select="TBR_MOBILE" /></Mobile>
		<Phone><xsl:value-of select="TBR_TEL" /></Phone>
		<RelaToInsured>
			<xsl:call-template name="tran_RelaToInsured">
				 <xsl:with-param name="relaToInsured">
				 	<xsl:value-of select="TBR_BBR_RELA"/>
			     </xsl:with-param>
			 </xsl:call-template>
		</RelaToInsured>	
	</Appnt>
   </xsl:template>
    
    <!-- ����������Ϣ -->
    <xsl:template name="Insured" match="BBR">
    <Insured>
    	<Name><xsl:value-of select="BBR_NAME" /></Name>
		<Sex>
			<xsl:call-template name="tran_Sex">
				 <xsl:with-param name="sex">
				 	<xsl:value-of select="BBR_SEX"/>
			     </xsl:with-param>
			 </xsl:call-template>
		</Sex>
		<Birthday><xsl:value-of select="BBR_BIRTH" /></Birthday>
		<IDType>
			<xsl:call-template name="tran_IDType">
				 <xsl:with-param name="idtype">
				 	<xsl:value-of select="BBR_IDTYPE"/>
			     </xsl:with-param>
			 </xsl:call-template>
		</IDType>
		<IDNo><xsl:value-of select="BBR_IDNO" /></IDNo>
		<IDTypeStartDate><xsl:value-of select="BBR_IDEFFSTARTDATE" /></IDTypeStartDate>	
		<IDTypeEndDate><xsl:value-of select="BBR_IDEFFENDDATE" /></IDTypeEndDate>
		<JobCode><xsl:value-of select="BBR_OCCUTYPE" /></JobCode>
		<Nationality><xsl:value-of  select="BBR_NATIVEPLACE" /></Nationality>
		<Stature></Stature>
		<Weight></Weight>
		<MaritalStatus></MaritalStatus>
		<Address><xsl:value-of select="BBR_ADDR" /></Address>
		<ZipCode><xsl:value-of select="BBR_POSTCODE" /></ZipCode>
		<Mobile><xsl:value-of select="BBR_MOBILE" /></Mobile>
		<Phone><xsl:value-of select="BBR_TEL" /></Phone>
		<Email></Email>
    </Insured>
    </xsl:template>  
     <!-- ��������Ϣ -->
    <xsl:template name="Bnf" match="SYRS/SYR">
    	<xsl:if test="SYR_BBR_RELA!=0">
    		<Bnf>
       		<!-- Ĭ��Ϊ��1-��������ˡ� -->
       		<Type>1</Type>
       		<Grade><xsl:value-of select="SYR_TEMP" /></Grade>
       		<Name><xsl:value-of select="SYR_NAME" /></Name>
       		<Sex>
       		<xsl:call-template name="tran_Sex">
				 <xsl:with-param name="sex">
				 	<xsl:value-of select="SYR_SEX"/>
			     </xsl:with-param>
			 </xsl:call-template>
       		</Sex>
       		<Birthday><xsl:value-of select="SYR_BIRTH" /></Birthday>
       		<IDType>
       		<xsl:call-template name="tran_IDType">
				 <xsl:with-param name="idtype">
				 	<xsl:value-of select="SYR_IDTYPE"/>
			     </xsl:with-param>
			 </xsl:call-template>
       		</IDType>
       		<IDNo><xsl:value-of select="SYR_IDNO" /></IDNo>
       		<IDTypeStartDate><xsl:value-of select="SYR_IDEFFSTARTDATE" /></IDTypeStartDate>	
       		<IDTypeEndDate><xsl:value-of select="SYR_IDEFFENDDATE" /></IDTypeEndDate>
       		<Nationality><xsl:value-of select="SYR_NATIVEPLACE" /></Nationality>
       		<RelaToInsured>
       		<xsl:call-template name="tran_RelaToInsured">
				 <xsl:with-param name="relaToInsured">
				 	<xsl:value-of select="SYR_BBR_RELA"/>
			     </xsl:with-param>
			 </xsl:call-template>
       		</RelaToInsured>
       		<Lot><xsl:value-of select="SYR_PCT" /></Lot>
       	</Bnf>
    	</xsl:if>
    </xsl:template>  
    <xsl:template name="Risk" match="PRODUCTS/PRODUCT[PRODUCTID=MAINPRODUCTID]">   
       <Risk>
       		<RiskCode>
       			<xsl:call-template name="tran_riskcode">
					<xsl:with-param name="riskcode" select="PRODUCTID" />
				</xsl:call-template>
       		</RiskCode>
       		<MainRiskCode>
       			<xsl:call-template name="tran_riskcode">
					<xsl:with-param name="riskcode" select="MAINPRODUCTID" />
				</xsl:call-template>
       		</MainRiskCode>
       		<Amnt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(AMNT)" /></Amnt>
       		<Prem><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(PREMIUM)" /></Prem>
       		<Mult><xsl:value-of select="format-number(AMT_UNIT,'#')" /></Mult>
       		<PayMode><xsl:apply-templates select="//MAIN/PAYMODE" /></PayMode>
       		<PayIntv><xsl:apply-templates select="//MAIN/PAYMETHOD" /></PayIntv>
       		<InsuYearFlag><xsl:apply-templates select="COVERAGE_PERIOD" /></InsuYearFlag>
       		<!-- ������������ -->
			<InsuYear>
				<xsl:if test="COVERAGE_PERIOD = '1'">106</xsl:if><!-- ������ -->
				<xsl:if test="COVERAGE_PERIOD != '1'">
					<xsl:value-of select="COVERAGE_YEAR" />
				</xsl:if>
			</InsuYear>
       		<!-- �ɷ����������־ -->
			<xsl:choose>
				<xsl:when
					test="CHARGE_PERIOD = '1'">
					<!-- ���������� -->
					<PayEndYearFlag>Y</PayEndYearFlag>
					<PayEndYear>1000</PayEndYear>
				</xsl:when>
				<xsl:otherwise>
					<!-- �����ɷ����� -->
					<PayEndYearFlag>
						<xsl:apply-templates select="CHARGE_PERIOD" />
					</PayEndYearFlag>
					<PayEndYear>
						<xsl:value-of select="CHARGE_YEAR" />
					</PayEndYear>
				</xsl:otherwise>
			</xsl:choose>
       		<BonusGetMode><xsl:apply-templates select="DVDMETHOD" /></BonusGetMode>
       		<FullBonusGetMode></FullBonusGetMode>
       		<GetYearFlag></GetYearFlag>
       		<GetYear><xsl:value-of select="REVAGE" /></GetYear>
       		<GetIntv><xsl:apply-templates select="REVMETHOD" /></GetIntv>
       		<GetBankCode></GetBankCode>
       		<GetBankAccNo></GetBankAccNo>
       		<GetAccName></GetAccName>
       		<AutoPayFlag><xsl:value-of select="ALFLAG" /></AutoPayFlag>
       	</Risk>
	</xsl:template>
	<!-- �Ա� -->
	<xsl:template name="tran_Sex">
	<xsl:param name="sex" />
		<xsl:choose>
			<xsl:when test="$sex='1'">0</xsl:when><!-- �� -->
			<xsl:when test="$sex='2'">1</xsl:when><!-- Ů -->
			<xsl:otherwise>-</xsl:otherwise><!-- ��ȷ�� -->
		</xsl:choose>
	</xsl:template>
	
	<!-- ֤������ -->
	<xsl:template name="tran_IDType">
	<xsl:param name="idtype">0</xsl:param>
		<xsl:choose>
			<xsl:when test="$idtype='0'">0</xsl:when><!-- �������֤����ʱ���֤ -->
			<xsl:when test="$idtype='1'">8</xsl:when><!-- ��ҵ�ͻ�Ӫҵִ�� -->
			<xsl:when test="$idtype='2'">8</xsl:when><!-- ��ҵ����֤ -->
			<xsl:when test="$idtype='3'">8</xsl:when><!-- ��ҵ�ͻ�������Ч֤�� -->
			<xsl:when test="$idtype='4'">2</xsl:when><!-- �������֤ -->
			<xsl:when test="$idtype='5'">8</xsl:when><!-- �侯���֤ -->
			<xsl:when test="$idtype='6'">8</xsl:when><!-- �۰�̨������Ч���֤ -->
			<xsl:when test="$idtype='7'">1</xsl:when><!-- ������� -->
			<xsl:when test="$idtype='8'">8</xsl:when><!-- ���˿ͻ�������Ч֤�� -->
			<xsl:when test="$idtype='9'">1</xsl:when><!-- �й����� -->
			<xsl:when test="$idtype='A'">6</xsl:when><!-- �۰ľ��������ڵ�ͨ��֤ -->
			<xsl:when test="$idtype='B'">7</xsl:when><!-- ̨�����������½ͨ��֤ -->
			<xsl:when test="$idtype='C'">8</xsl:when><!-- ��������þ���֤ -->
		</xsl:choose>
	</xsl:template>
	<!-- �뱻�����˹�ϵ -->
	<xsl:template name="tran_RelaToInsured">
	<xsl:param name="relaToInsured" />
		<xsl:choose>
			<xsl:when test="$relaToInsured='0'"></xsl:when><!-- ���� -->
			<xsl:when test="$relaToInsured='1'">00</xsl:when><!-- ���� -->
			<xsl:when test="$relaToInsured='2'">02</xsl:when><!-- ��ż -->
			<xsl:when test="$relaToInsured='3'">01</xsl:when><!-- ��ĸ -->
			<xsl:when test="$relaToInsured='4'">03</xsl:when><!-- ��Ů -->
			<xsl:when test="$relaToInsured='5'">04</xsl:when><!-- ���� -->
		</xsl:choose>
	</xsl:template>
	<!-- Ͷ���˾������� -->
	<xsl:template match="TBR_RESIDENTS">
		<xsl:choose>
			<xsl:when test=".='0'">1</xsl:when><!-- ���� -->
			<xsl:when test=".='1'">2</xsl:when><!-- ũ�� -->
		</xsl:choose>
	</xsl:template>
	
	<!-- �ɷ��������� -->
	<xsl:template match="CHARGE_PERIOD">
		<xsl:choose>
			<xsl:when test=".='1'">Y</xsl:when><!-- ���� -->
			<xsl:when test=".='2'">Y</xsl:when><!-- ��� -->
			<xsl:when test=".='3'"></xsl:when><!-- ����� -->
			<xsl:when test=".='4'"></xsl:when><!-- ���� -->
			<xsl:when test=".='5'">M</xsl:when><!-- �½� -->
			<xsl:when test=".='6'">A</xsl:when><!-- ����ĳȷ������ -->
			<xsl:when test=".='7'">A</xsl:when><!-- ����ɷ� -->
			<xsl:when test=".='8'"></xsl:when><!-- �����ڽ� -->
		</xsl:choose>
	</xsl:template>
	
	<!-- ������������1 ������2 �����ޱ���3 ����ĳȷ�����䣬4 ���±���5 ���챣 -->
	<xsl:template match="COVERAGE_PERIOD">
		<xsl:choose>
			<xsl:when test=".='1'">A</xsl:when><!-- ������ -->
			<xsl:when test=".='2'">Y</xsl:when><!-- �����ޱ� -->
			<xsl:when test=".='3'">A</xsl:when><!-- ����ĳȷ������ -->
			<xsl:when test=".='4'">M</xsl:when><!-- ���±� -->
			<xsl:when test=".='5'">D</xsl:when><!-- ���챣 -->
		</xsl:choose>
	</xsl:template>
	
	<!-- ��ȡ��ʽ -->
	<xsl:template match="REVMETHOD">
		<xsl:choose>
			<xsl:when test=".='1'">1</xsl:when><!-- ���� -->
			<xsl:when test=".='2'">12</xsl:when><!-- ���� -->
			<xsl:when test=".='3'">0</xsl:when><!-- ���죨һ������ȡ�� -->
			<xsl:when test=".='4'"></xsl:when><!-- �̶�����ƽ׼ʽ���� -->
			<xsl:when test=".='5'"></xsl:when><!-- 6����������ʽ���� -->
		</xsl:choose>
	</xsl:template>
	
	<!-- ������ȡ��ʽ -->
	<xsl:template match="DVDMETHOD">
		<xsl:choose>
			<xsl:when test=".='1'">1</xsl:when><!-- �ۻ���Ϣ -->
			<xsl:when test=".='2'">3</xsl:when><!-- �ֽ����� -->
			<xsl:when test=".='3'"></xsl:when><!-- ����� -->
			<xsl:when test=".='4'"></xsl:when><!-- �ֽ���ȡ -->
		</xsl:choose>
	</xsl:template>
	
	<!-- �ɷ���ʽ -->
	<xsl:template match="PAYMODE">
		<xsl:choose>
			<xsl:when test=".='0'">1</xsl:when><!-- �ֽ� -->
			<xsl:when test=".='1'">7</xsl:when><!-- ת�� -->
		</xsl:choose>
	</xsl:template>
	
	<!-- �ɷѼ��1���ɣ�5�½ɣ�4���ɣ�3����ɣ�2��� -->
	<xsl:template match="PAYMETHOD">
		<xsl:choose>
			<xsl:when test=".='1'">0</xsl:when><!-- ���� -->
			<xsl:when test=".='2'">12</xsl:when><!-- ��� -->
			<xsl:when test=".='3'">6</xsl:when><!-- ����� -->
			<xsl:when test=".='4'">3</xsl:when><!-- ���� -->
			<xsl:when test=".='5'">1</xsl:when><!-- �½� -->
		</xsl:choose>
	</xsl:template>
	
	<!-- ���ִ��� -->
	<xsl:template name="tran_riskcode">
		<xsl:param name="riskcode" />
		<xsl:choose>
			<!-- ʢ��3�Ų�Ʒ������start -->
			<!-- PBKINSR-626 ��ҵ��������ͨ�����²�Ʒ��ʢ��3�ţ� -->
			<!-- <xsl:when test="$riskcode='122010'">L12078</xsl:when> --><!-- ����ʢ��3���������գ������ͣ� -->
			<xsl:when test="$riskcode='122010'">L12100</xsl:when>	<!-- ����ʢ��3���������գ������ͣ� -->
			<!-- ʢ��3�Ų�Ʒ������end -->
			<!-- PBKINSR-909 ��ҵ��������ͨ���Ӳ�Ʒ��ʢ��2�� -->
			<xsl:when test="$riskcode='L12079'">L12079</xsl:when>	<!-- ����ʢ��2���������գ������ͣ� -->
			<xsl:when test="$riskcode='50002'">50015</xsl:when>
			<!-- 50002-�������Ӯ���ռƻ�:���գ�122046 - �������Ӯ1����ȫ����,�����գ�122047 - ����ӳ�����Ӯ��ȫ����,122048 - ����������������գ������ͣ� -->
			<!-- 50015-�������Ӯ���ռƻ�:���գ�122046 - �������Ӯ1����ȫ����,�����գ�122047 - ����ӳ�����Ӯ��ȫ����,L12081 - ����������������գ������ͣ� -->
			<xsl:when test="$riskcode='L12080'">L12080</xsl:when>	<!-- ����ʢ��1���������գ������ͣ� -->
			<xsl:when test="$riskcode='L12089'">L12089</xsl:when>	<!-- ����ʢ��1��B���������գ������ͣ� -->
			<xsl:when test="$riskcode='L12087'">L12087</xsl:when>	<!-- �����5����ȫ���գ������ͣ� -->
			<xsl:when test="$riskcode='L12086'">L12086</xsl:when>	<!-- �����3����ȫ���գ������ͣ� -->
			<xsl:when test="$riskcode='L12085'">L12085</xsl:when>	<!-- �����2����ȫ���գ������ͣ� -->
			<xsl:when test="$riskcode='L12088'">L12088</xsl:when>	<!-- �����9����ȫ���գ������ͣ� -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ��Ʒ��ϴ��� -->
	<xsl:template name="tran_contPlancode">
		<xsl:param name="contPlancode" />
		<xsl:choose>
			<!-- 50015-�������Ӯ���ռƻ�:���գ�122046 - �������Ӯ1����ȫ����,�����գ�122047 - ����ӳ�����Ӯ��ȫ����,L12081 - ����������������գ������ͣ� -->
			<xsl:when test="$contPlancode=50002">50015</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
