<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
	<xsl:template match="INSUREQ">
		<TranData>
			<!-- ����ͷ -->
			<Head>
				<TranDate><xsl:value-of select="MAIN/TRANSRDATE"/></TranDate>
				<TranTime><xsl:value-of select="MAIN/TRANSRTIME"/></TranTime>
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
				<xsl:apply-templates select="PRODUCTS/PRODUCT" />
			</Body>
		</TranData>
	</xsl:template>
	
	<!-- ������ -->
	<xsl:template name="Body" match="MAIN">
		<ProposalPrtNo><xsl:value-of select="APPLNO" /></ProposalPrtNo>
		<ContPrtNo></ContPrtNo>	<!-- ӡˢ����ǩ��ȷ��ʱ���д��� -->
		<PolApplyDate><xsl:value-of select="TB_DATE" /></PolApplyDate>
		<AccName><xsl:value-of select="../ACCOUNT_INFO/PAY_IN_ACC_NAME" /></AccName>
		<AccNo><xsl:value-of select="../ACCOUNT_INFO/PAY_IN_ACC" /></AccNo>
		<GetPolMode><xsl:apply-templates select="SENDMETHOD" /></GetPolMode>
		<JobNotice></JobNotice>
		<HealthNotice><xsl:value-of select="../HEALTH_NOTICE/NOTICE_ITEM" /></HealthNotice>
		<PolicyIndicator></PolicyIndicator>
		<AgentComName><xsl:value-of select="BRNA_NAME" /></AgentComName>
		<!--�������֤-->
		<AgentComCertiCode><xsl:value-of select="AGENTCODE" /></AgentComCertiCode>
		<!--����������Ա���ţ������3�������Ӹ��ֶ�-->
		<SellerNo><xsl:value-of select="SELLERCODE" /></SellerNo>
		<!--����������Ա����-->
		<TellerName><xsl:value-of select="SELLERNAME" /></TellerName>
		<!-- ���մ����ҵ֤���� -->
		<TellerCertiCode><xsl:value-of select="AGENTNO" /></TellerCertiCode>
		<!-- ��Ʒ��� -->
        <ContPlan>
			<ContPlanCode>
				<xsl:call-template name="tran_contPlancode">
					<xsl:with-param name="contPlancode">
						<xsl:value-of select="../PRODUCTS/PRODUCT/PRODUCTID" />
					</xsl:with-param>
				</xsl:call-template>
			</ContPlanCode>
			<!-- ��Ʒ��Ϸ��� -->
			<ContPlanMult>
				<xsl:value-of select="format-number(../PRODUCTS/PRODUCT/AMT_UNIT,'#')" />
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
		<IDTypeStartDate></IDTypeStartDate>	
		<IDTypeEndDate></IDTypeEndDate>
		<JobCode>
			<xsl:call-template name="tran_JobCode">
				 <xsl:with-param name="jobCode">
				 	<xsl:value-of select="TBR_WORKCODE"/>
			     </xsl:with-param>
			 </xsl:call-template>
		</JobCode>
		<Nationality>
			<xsl:call-template name="tran_Nationality">
				 <xsl:with-param name="nationality">
				 	<xsl:value-of select="TBR_NATION"/>
			     </xsl:with-param>
			 </xsl:call-template>
		</Nationality>
		<Stature></Stature>
		<Weight></Weight>
		<!-- Ͷ����������(����Ԫ) -->
		<xsl:choose>
			<xsl:when test="TBR_AVR_SALARY=''">
				<Salary />
			</xsl:when>
			<xsl:otherwise>
				<Salary>
					<xsl:value-of
						select="TBR_AVR_SALARY" />
				</Salary>
			</xsl:otherwise>
		</xsl:choose>
		<!-- 1.����2.ũ�� -->
		<LiveZone><xsl:apply-templates select="TBR_RESEDTYPE" /></LiveZone>
		<Address><xsl:value-of select="TBR_ADDR" /></Address>
		<ZipCode><xsl:value-of select="TBR_POSTCODE" /></ZipCode>
		<Mobile><xsl:value-of select="TBR_MOBILE" /></Mobile>
		<Phone><xsl:value-of select="TBR_TEL" /></Phone>
		<Email><xsl:value-of select="TBR_EMAIL" /></Email>
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
		<IDTypeStartDate></IDTypeStartDate>	
		<IDTypeEndDate></IDTypeEndDate>
		<JobCode>
			<xsl:call-template name="tran_JobCode">
				 <xsl:with-param name="jobCode">
				 	<xsl:value-of select="BBR_WORKCODE"/>
			     </xsl:with-param>
			 </xsl:call-template>
		</JobCode>
		<Nationality>
			<xsl:call-template name="tran_Nationality">
				 <xsl:with-param name="nationality">
				 	<xsl:value-of select="BBR_NATION"/>
			     </xsl:with-param>
			 </xsl:call-template>
		</Nationality>
		<Stature></Stature>
		<Weight></Weight>
		<MaritalStatus></MaritalStatus>
		<Address><xsl:value-of select="BBR_ADDR" /></Address>
		<ZipCode><xsl:value-of select="BBR_POSTCODE" /></ZipCode>
		<Mobile><xsl:value-of select="BBR_MOBILE" /></Mobile>
		<Phone><xsl:value-of select="BBR_TEL" /></Phone>
		<Email><xsl:value-of select="BBR_EMAIL" /></Email>
		<Email></Email>
    </Insured>
    </xsl:template>  
     <!-- ��������Ϣ -->
    <xsl:template name="Bnf" match="SYRS/SYR">
    <xsl:if test="SYR_BBR_RELA != '5'"><!-- ������Ϊ���� -->
       	<Bnf>
       		<!-- Ĭ��Ϊ��1-��������ˡ� -->
       		<Type>1</Type>
       		<Grade><xsl:value-of select="SYR_ORDER" /></Grade>
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
       		<IDTypeStartDate></IDTypeStartDate>	
       		<IDTypeEndDate></IDTypeEndDate>
       		<Nationality></Nationality>
       		<RelaToInsured>
       		<xsl:call-template name="tran_RelaToInsured">
				 <xsl:with-param name="relaToInsured">
				 	<xsl:value-of select="SYR_BBR_RELA"/>
			     </xsl:with-param>
			 </xsl:call-template>
       		</RelaToInsured>
       		<Lot><xsl:value-of select="BNFT_PROFIT_PCENT" /></Lot>
       	</Bnf>
       	</xsl:if>
    </xsl:template>  
    <xsl:template name="Risk" match="PRODUCTS/PRODUCT">   
       <Risk>
       		<RiskCode>
       			<xsl:call-template name="tran_riskcode">
					<xsl:with-param name="riskcode" select="PRODUCTID" />
				</xsl:call-template>
       		</RiskCode>
       		<MainRiskCode>
       			<xsl:call-template name="tran_riskcode">
					<xsl:with-param name="riskcode" select="PRODUCTID" />
				</xsl:call-template>
       		</MainRiskCode>
       		<Amnt></Amnt>
       		<Prem><xsl:value-of select="PREMIUM" /></Prem>
       		<Mult><xsl:value-of select="format-number(AMT_UNIT,'#')" /></Mult>
       		<PayMode></PayMode>
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
  			<GetBankCode><xsl:value-of select="../ACCOUNT_INFO/PAY_OUT_ACC_BANK" /></GetBankCode>
      		<GetBankAccNo><xsl:value-of select="../ACCOUNT_INFO/PAY_OUT_ACC" /></GetBankAccNo>
      		<GetAccName><xsl:value-of select="../ACCOUNT_INFO/PAY_OUT_ACC_NAME" /></GetAccName>
       		<AutoPayFlag><xsl:value-of select="ALFLAG" /></AutoPayFlag>
       	</Risk>
	</xsl:template>
	<!-- �Ա� -->
	<xsl:template name="tran_Sex">
	<xsl:param name="sex" />
		<xsl:choose>
			<xsl:when test="$sex='1'">0</xsl:when><!-- �� -->
			<xsl:when test="$sex='2'">1</xsl:when><!-- Ů -->
			<xsl:otherwise>--</xsl:otherwise><!-- ��ȷ�� -->
		</xsl:choose>
	</xsl:template>
	
	<!-- ֤������ -->
	<xsl:template name="tran_IDType">
	<xsl:param name="idtype">0</xsl:param>
		<xsl:choose>
			<xsl:when test="$idtype='1'">0</xsl:when><!-- �������֤����ʱ���֤ -->
			<xsl:when test="$idtype='2'">2</xsl:when><!-- ����֤ -->
			<xsl:when test="$idtype='3'">1</xsl:when><!-- ���� -->
			<xsl:when test="$idtype='4'">4</xsl:when><!-- ����֤ -->
			<xsl:when test="$idtype='5'">8</xsl:when><!-- ���� -->
		</xsl:choose>
	</xsl:template>
	<!-- ���� -->
	<xsl:template name="tran_Nationality">
	<xsl:param name="nationality" />
		<xsl:choose>
			<xsl:when test="$nationality='0'">CHN</xsl:when><!-- �й�     -->
			<xsl:when test="$nationality='1'">AU</xsl:when><!-- �Ĵ����� -->
			<xsl:when test="$nationality='2'">GB</xsl:when><!-- Ӣ��     -->
			<xsl:when test="$nationality='3'">JP</xsl:when><!-- �ձ�     -->
			<xsl:when test="$nationality='4'">US</xsl:when><!-- ����     -->
			<xsl:when test="$nationality='5'">RU</xsl:when><!-- ����˹   -->
			<xsl:when test="$nationality='6'">OTH</xsl:when><!-- ����     -->  
		</xsl:choose>
	</xsl:template>
	
	<!-- ְҵ -->
	<xsl:template name="tran_JobCode">
	<xsl:param name="jobCode" />
		<xsl:choose>
			<xsl:when test="$jobCode='4000001'">4010101</xsl:when><!-- ��ҵ��������Ա              -->
			<xsl:when test="$jobCode='2000002'">2090104</xsl:when><!-- ��ѧ��Ա                    -->
			<xsl:when test="$jobCode='2000003'">2080103</xsl:when><!-- ����רҵ��Ա                -->
			<xsl:when test="$jobCode='2000004'">2070109</xsl:when><!-- ����רҵ��Ա                -->
			<xsl:when test="$jobCode='4000005'">4030111</xsl:when><!-- ���һ��ء���ҵ����ҵ��λ��Ա-->
			<xsl:when test="$jobCode='2000006'">2100106</xsl:when><!-- ������ѧ����������Ա        -->
			<xsl:when test="$jobCode='2000007'">2130101</xsl:when><!-- �ڽ�ְҵ��                  -->  
			<xsl:when test="$jobCode='7000008'">7010103</xsl:when><!-- ����                        -->
			<xsl:when test="$jobCode='2000009'">2090114</xsl:when><!-- ѧ��                        -->
			<xsl:when test="$jobCode='8000010'"></xsl:when><!-- ��������ȷ�ϣ�                        -->			
		</xsl:choose>
	</xsl:template>
	
	<!-- �뱻�����˹�ϵ -->
	<xsl:template name="tran_RelaToInsured">
	<xsl:param name="relaToInsured" />
		<xsl:choose>
			<xsl:when test="$relaToInsured='1'">02</xsl:when><!-- ��ż -->
			<xsl:when test="$relaToInsured='2'">01</xsl:when><!-- ��ĸ -->
			<xsl:when test="$relaToInsured='3'">03</xsl:when><!-- ��Ů -->
			<xsl:when test="$relaToInsured='4'">04</xsl:when><!-- ���� -->
			<xsl:when test="$relaToInsured='5'">00</xsl:when><!-- ���� -->
			<xsl:when test="$relaToInsured='6'">04</xsl:when><!-- ���� -->
		</xsl:choose>
	</xsl:template>
	<!-- Ͷ���˾������� -->
	<xsl:template match="TBR_RESEDTYPE">
		<xsl:choose>
			<xsl:when test=".='0'">1</xsl:when><!-- ���� -->
			<xsl:when test=".='1'">2</xsl:when><!-- ũ�� -->
		</xsl:choose>
	</xsl:template>
	
	<!-- �ɷ���������0 �޹أ�1 ������2 �����޽���3 ����ĳȷ�����䣬4 �������ѣ�5 �����ڽ� -->
	<xsl:template match="CHARGE_PERIOD">
		<xsl:choose>
			<xsl:when test=".='0'"></xsl:when><!-- �޹� -->
			<xsl:when test=".='1'">Y</xsl:when><!-- ���� -->
			<xsl:when test=".='2'">Y</xsl:when><!-- ��� -->
			<xsl:when test=".='3'">A</xsl:when><!-- ����ĳȷ������ -->
			<xsl:when test=".='4'">A</xsl:when><!-- ����ɷ� -->
			<xsl:when test=".='5'"></xsl:when><!-- �����ڽ� -->
		</xsl:choose>
	</xsl:template>
	
	<!-- ������������0 �޹أ�1 ������2 �����ޱ���3 ����ĳȷ�����䣬4 ���±���5 ���챣 -->
	<xsl:template match="COVERAGE_PERIOD">
		<xsl:choose>
			<xsl:when test=".='0'"></xsl:when><!-- �޹� -->
			<xsl:when test=".='1'">A</xsl:when><!-- ������ -->
			<xsl:when test=".='2'">Y</xsl:when><!-- �����ޱ� -->
			<xsl:when test=".='3'">A</xsl:when><!-- ����ĳȷ������ -->
			<xsl:when test=".='4'">M</xsl:when><!-- ���±� -->
			<xsl:when test=".='5'">D</xsl:when><!-- ���챣 -->
		</xsl:choose>
	</xsl:template>
	
	<!-- ��ȡ��ʽ1 ���� ��  2 ���� ��  3 ���� -->
	<xsl:template match="REVMETHOD">
		<xsl:choose>
			<xsl:when test=".='1'">1</xsl:when><!-- ���� -->
			<xsl:when test=".='2'">12</xsl:when><!-- ���� -->
			<xsl:when test=".='3'">0</xsl:when><!-- ���죨һ������ȡ�� -->
		</xsl:choose>
	</xsl:template>
	
	<!-- ������ȡ��ʽ0 �ֽ���� ��1�ֽ����� �� 2�ۼ���Ϣ -->
	<xsl:template match="DVDMETHOD">
		<xsl:choose>
			<xsl:when test=".='0'"></xsl:when><!-- �ֽ���ȡ -->
			<xsl:when test=".='1'">3</xsl:when><!-- �ֽ����� -->
			<xsl:when test=".='2'">1</xsl:when><!-- �ۻ���Ϣ -->			
		</xsl:choose>
	</xsl:template>
	<!-- �������ͷ�ʽ 1 ���ŷ��ͣ�2 �ʼģ�3 ���ŵ��ͣ�4 ���й�̨  -->
	<xsl:template match="SENDMETHOD">
		<xsl:choose>
			<xsl:when test=".='1'"></xsl:when><!-- ���ŷ��� -->
			<xsl:when test=".='2'">1</xsl:when><!-- �ʼ� -->
			<xsl:when test=".='3'"></xsl:when><!-- ���ŵ��� -->
			<xsl:when test=".='4'">2</xsl:when><!-- ���й�̨ -->				
		</xsl:choose>
	</xsl:template>
	
	<!-- �ɷѷ�ʽY���꽻��M���½���W������ -->
	<xsl:template match="PAYMETHOD">
		<xsl:choose>
			<xsl:when test=".='Y'">12</xsl:when><!-- ��� -->
			<xsl:when test=".='M'">1</xsl:when><!-- �½� -->
			<xsl:when test=".='W'">0</xsl:when><!-- ���� -->
		</xsl:choose>
	</xsl:template>
	
	<!-- ���ִ��� -->
	<xsl:template name="tran_riskcode">
		<xsl:param name="riskcode" />
		<xsl:choose>
			<xsl:when test="$riskcode=50002">50015</xsl:when>
			<!-- 50002-�������Ӯ���ռƻ�:���գ�122046 - �������Ӯ1����ȫ����,�����գ�122047 - ����ӳ�����Ӯ��ȫ����,122048 - ����������������գ������ͣ� -->
			<!-- PBKINSR-785 ����ũ�����У�����ͨ�⣬��ʢ2����ʢ3����5�²�Ʒ���� -->
			<xsl:when test="$riskcode='L12079'">L12079</xsl:when> 	<!-- ����ʢ��2���������գ������ͣ� -->
			<xsl:when test="$riskcode='L12078'">L12078</xsl:when> 	<!-- ����ʢ��2���������գ������ͣ� -->
			<xsl:when test="$riskcode='L12080'">L12080</xsl:when> 	<!-- ����ʢ��1���������գ������ͣ� -->
			<xsl:when test="$riskcode='L12089'">L12089</xsl:when> 	<!-- ����ʢ��1���������գ������ͣ�B�� -->
			<xsl:when test="$riskcode='122009'">122009</xsl:when> 	<!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A�� -->
			<!-- PBKINSR-785 ����ũ�����У�����ͨ�⣬��ʢ2����ʢ3����5�²�Ʒ���� -->
			
			<!-- guoxl 2016.6.15 ��ʼ -->
			<xsl:when test="$riskcode='L12087'">L12087</xsl:when> 	<!-- �����5����ȫ���գ������ͣ� -->
			<!-- guoxl 2016.6.15 ���� -->
			
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ��Ʒ��ϴ��� -->
	<xsl:template name="tran_contPlancode">
		<xsl:param name="contPlancode" />
		<xsl:choose>
			<!-- 50002-�������Ӯ���ռƻ�:���գ�122046 - �������Ӯ1����ȫ����,�����գ�122047 - ����ӳ�����Ӯ��ȫ����,122048 - ����������������գ������ͣ� -->
			<xsl:when test="$contPlancode=50002">50015</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
