<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
<TranData>
	<xsl:apply-templates select="TranData/BaseInfo" />
	
	<Body>
		<xsl:apply-templates select="TranData/LCCont" />
		
		<!-- Ͷ���� -->
		<xsl:apply-templates select="TranData/LCCont/LCAppnt" />
		
		<!-- ������(1��) -->
		<xsl:apply-templates select="TranData/LCCont/LCInsureds/LCInsured" />
		
		<xsl:variable name ="count" select ="TranData/LCCont/LCInsureds/LCInsured/Risks/Risk[MainRiskCode=RiskCode]/LCBnfs/LCBnfCount"/>
		<xsl:if test="$count!=0">
			<xsl:for-each select="TranData/LCCont/LCInsureds/LCInsured/Risks/Risk[MainRiskCode=RiskCode]/LCBnfs/LCBnf">
					<!-- ������ -->
				<Bnf>
					<Type><xsl:value-of select="BnfType" /></Type>	
					<Grade><xsl:value-of select="BnfGrade" /></Grade>
					<Name><xsl:value-of select="Name" /></Name>
					<Sex><xsl:value-of select="Sex" /></Sex>
					<Birthday><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(Birthday)" /></Birthday>
					<IDType><xsl:call-template name="tran_IDType">
						 <xsl:with-param name="idtype">
						 	<xsl:value-of select="IDType"/>
					     </xsl:with-param>
					  </xsl:call-template></IDType>
					<IDNo><xsl:value-of select="IDNo" /></IDNo>
					<Lot><xsl:value-of select="BnfLot" /></Lot>	
					<RelaToInsured>
						<xsl:call-template name="tran_RelationToInsured">
							<xsl:with-param name="relationToInsured">
								<xsl:value-of select="RelationToInsured"/>
							</xsl:with-param>
				   </xsl:call-template>
					</RelaToInsured>
				</Bnf>
		</xsl:for-each>
		</xsl:if>
		
		<!-- ���� -->
		
		<xsl:for-each select="TranData/LCCont/LCInsureds/LCInsured/Risks/Risk">
		<Risk>
			<RiskCode>
			<xsl:call-template name="tran_RiskCode">
				<xsl:with-param name="riskCode">
					<xsl:value-of select="RiskCode" />
				</xsl:with-param>
			</xsl:call-template>
			<!-- <xsl:apply-templates select="RiskCode" />  -->
			</RiskCode>
			<MainRiskCode>
			<xsl:call-template name="tran_RiskCode">
				<xsl:with-param name="riskCode">
					<xsl:value-of select="MainRiskCode" />
				</xsl:with-param>
			</xsl:call-template>
			<!-- <xsl:apply-templates select="MainRiskCode" />  -->
			</MainRiskCode>
			<Amnt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Amnt)" /></Amnt>
			<Prem><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Prem)" /></Prem>
		    <Mult>
		    	<xsl:value-of select="format-number(Mult,'#')" />
		   </Mult>
			<PayMode>
			<xsl:call-template name="tran_PayMode">
							<xsl:with-param name="payMode">
								<xsl:value-of select="PayMode"/>
							</xsl:with-param>
				   </xsl:call-template>
			</PayMode>
			<PayIntv><xsl:apply-templates select="PayIntv" /></PayIntv>
			<PayEndYearFlag><xsl:apply-templates select="PayEndYearFlag" /></PayEndYearFlag>
			<PayEndYear>
				<xsl:variable name ="payIntv" select ="PayIntv"/>
				<xsl:choose>
					<xsl:when test="$payIntv = 0">1000</xsl:when>
					<xsl:otherwise><xsl:apply-templates select="PayEndYear" /></xsl:otherwise>
				</xsl:choose>
			
			</PayEndYear>
			<InsuYearFlag><xsl:apply-templates select="InsuYearFlag" /></InsuYearFlag>
			<InsuYear><xsl:apply-templates select="InsuYear" /></InsuYear>
			<BonusGetMode><xsl:apply-templates select="BonusGetMode" /></BonusGetMode>
			<FullBonusGetMode><xsl:apply-templates select="FullBonusGetMode" /></FullBonusGetMode>
			<GetYearFlag><xsl:apply-templates select="GetYearFlag" /></GetYearFlag>
			<GetYear><xsl:apply-templates select="GetYear" /></GetYear>
			<GetIntv><xsl:apply-templates select="GetIntv" /></GetIntv>
			<GetBankCode><xsl:apply-templates select="GetBankCode" /></GetBankCode>
			<GetBankAccNo><xsl:apply-templates select="GetBankAccNo" /></GetBankAccNo>
			<GetAccName><xsl:apply-templates select="GetAccName" /></GetAccName>
			<AutoPayFlag><xsl:apply-templates select="AutoPayFlag" /></AutoPayFlag>
		</Risk>
		</xsl:for-each>
	
	</Body>
</TranData>
</xsl:template>

<xsl:template name="Head" match="BaseInfo">
<Head>
	<TranDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(BankDate)"/></TranDate>
	<xsl:variable name ="time" select ="java:com.sinosoft.midplat.common.DateUtil.getCur8Time()"/>
	<TranTime><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.time8to6($time)"/></TranTime>
	<TellerNo><xsl:value-of select="TellerNo"/></TellerNo>
	<TranNo><xsl:value-of select="TransrNo"/></TranNo>
	<NodeNo>
		<xsl:value-of select="ZoneNo"/>
		<xsl:value-of select="BrNo"/>
	</NodeNo>
	<xsl:copy-of select="../Head/*"/>
	<BankCode><xsl:value-of select="../Head/TranCom/@outcode"/></BankCode>
</Head>
</xsl:template>

<xsl:template name="Body" match="LCCont">
	<!-- Ͷ������ -->
	<ProposalPrtNo><xsl:value-of select="ProposalContNo" /></ProposalPrtNo>
	<!-- ������ͬӡˢ�� -->
	<ContPrtNo><xsl:value-of select="PrtNo" /></ContPrtNo>
	<!-- Ͷ������ -->
	<PolApplyDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(PolApplyDate)"/></PolApplyDate>
	<!-- ����ֹܴ�����ҵ�����˱�� -->
	<ManagerNo></ManagerNo>
	<!-- ����ֹܴ�����ҵ���������� -->
	<ManagerName></ManagerName>
	<!-- ����������Ա���ţ������3�������Ӹ��ֶ� -->
	<SellerNo><xsl:value-of select="BankAgentCode" /></SellerNo>
	<!-- ������������ -->
	<AgentComName><xsl:value-of select="../BaseInfo/BrName" /></AgentComName>
	<!-- ���������ʸ�֤ -->
	<AgentComCertiCode></AgentComCertiCode>
	<!-- ����Ա������ -->
	<TellerName><xsl:value-of select="BankAgentName" /></TellerName>
	<!--����������Ա�ʸ�֤-->
	<TellerCertiCode></TellerCertiCode> 
	
	<!-- �˻�����������Ĭ��Ͷ����������Ϊ�˻����� -->
	<AccName><xsl:value-of select="LCAppnt/AppntName" /></AccName>
	<!-- �����˻� -->
	<AccNo><xsl:value-of select="BankAccNo" /></AccNo>
	<!-- �������ͷ�ʽ -->
	<GetPolMode><xsl:value-of select="GetPolMode" /></GetPolMode>
	<!-- ְҵ��֪(N/Y) -->
	<JobNotice/>
	<!-- ������֪(N/Y)  -->
	<HealthNotice><xsl:value-of select="LCInsureds/LCInsured/TellInfos/HealthFlag" /></HealthNotice>
	<!-- ��Ʒ��� -->
        <ContPlan>
        	<!-- ��Ʒ��ϱ��� -->
        	<xsl:variable name="mainRiskCode" select="LCInsureds/LCInsured/Risks/Risk[MainRiskCode=RiskCode]/RiskCode"/>
			<ContPlanCode>
				<xsl:call-template name="tran_ContPlanCode">
					<xsl:with-param name="contPlanCode">
						<xsl:value-of select="$mainRiskCode" />
					</xsl:with-param>
				</xsl:call-template>
			<!-- 	<xsl:if test="$mainRiskCode = 50002">
					<xsl:value-of select="$mainRiskCode" />
				</xsl:if>   -->
			</ContPlanCode>
			
			<!-- ��Ʒ��Ϸ��� -->
			<ContPlanMult>
				<xsl:value-of select="format-number(LCInsureds/LCInsured/Risks/Risk[MainRiskCode=RiskCode]/Mult,'#')" />
			<!-- 	<xsl:if test="$mainRiskCode = 50002">
					<xsl:value-of select="format-number(LCInsureds/LCInsured/Risks/Risk[MainRiskCode=RiskCode]/Mult,'#')" />
					
				</xsl:if>   -->
			</ContPlanMult>
        </ContPlan>
</xsl:template>

<!-- Ͷ���� -->
<xsl:template name="Appnt" match="LCAppnt">

<Appnt>
	<Name><xsl:value-of select="AppntName" /></Name>
	<Sex><xsl:value-of select="AppntSex" /></Sex>
	<Birthday><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(AppntBirthday)" /></Birthday>
	<IDType>
		<xsl:call-template name="tran_IDType">
					<xsl:with-param name="idtype">
						<xsl:value-of select ="AppntIDType"/>
					</xsl:with-param>
		</xsl:call-template></IDType>
	<IDNo><xsl:value-of select="AppntIDNo" /></IDNo>
	<IDTypeStartDate/>
	<IDTypeEndDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(AppntIDEndDate)" /></IDTypeEndDate>	
	<JobCode>
	<xsl:call-template name="tran_jobcode">
					<xsl:with-param name="jobcode">
						<xsl:value-of select ="AppntJobCode"/>
					</xsl:with-param>
		</xsl:call-template>
	</JobCode>
	<!-- Ͷ���������룬���з���λ:�֣����Ķ˵�λ���� -->
	<xsl:choose>
		<xsl:when test="AppntWage=''">
			<Salary />
		</xsl:when>
		<xsl:otherwise>
			<Salary>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(AppntWage)" />
			</Salary>
		</xsl:otherwise>
	</xsl:choose>
	<!-- Ͷ���˼�ͥ�����룬���з���λ:�֣����Ķ˵�λ���� -->	
	<FamilySalary></FamilySalary>
	<!-- Ͷ������������ 1������2��ũ��-->
	<LiveZone>
	<xsl:call-template name="tran_livezone">
					<xsl:with-param name="livezone">
						<xsl:value-of select ="CityType"/>
					</xsl:with-param>
		</xsl:call-template>
	</LiveZone>
	<!-- ���� -->
	<Nationality>
	<xsl:call-template name="tran_nationality">
					<xsl:with-param name="nationality">
						<xsl:value-of select ="AppntNativePlace"/>
					</xsl:with-param>
		</xsl:call-template>
	</Nationality>
	<!-- ���cm -->
	<Stature>
	
	<xsl:value-of	select="AppntStature" /></Stature>
	<!-- ����kg -->
	<Weight><xsl:value-of	select="AppntAvoirdupois" /></Weight>
	
	<Address><xsl:value-of	select="MailAddress" /></Address>
    <ZipCode><xsl:value-of	select="MailZipCode" /></ZipCode>
    <Mobile><xsl:value-of select="AppntMobile" /></Mobile>
    <Phone><xsl:value-of select="AppntOfficePhone" /></Phone>
    <Email><xsl:value-of select="AppntEmail" /></Email>
  <!--   <RelaToInsured>00</RelaToInsured>  -->
    <RelaToInsured>
		<xsl:call-template name="tran_RelationRoleCode">
			<xsl:with-param name="relationRoleCode">
				<xsl:value-of select="../LCInsureds/LCInsured/RelaToAppnt"/>
			</xsl:with-param>
   		</xsl:call-template>
	</RelaToInsured>
</Appnt>
</xsl:template>

<!-- ������ -->
<xsl:template name="Insured" match="LCInsured">
<Insured>
	<Name><xsl:value-of select="Name"/></Name> <!-- ���� -->
      <Sex><xsl:value-of select="Sex"/></Sex> <!-- �Ա� -->
      <Birthday><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(Birthday)" /></Birthday>
      <IDType>
      <xsl:call-template name="tran_IDType">
		 <xsl:with-param name="idtype">
		 	<xsl:value-of select="IDType"/>
	     </xsl:with-param>
	  </xsl:call-template>
      </IDType> <!-- ֤������ -->
      <IDNo><xsl:value-of select="IDNo"/></IDNo> <!-- ֤������ -->
      <IDTypeStartDate></IDTypeStartDate > <!-- ֤����Ч���� -->
      <IDTypeEndDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(IDEndDate)" /></IDTypeEndDate>
      <!-- ���� -->
	<Nationality>
	<xsl:call-template name="tran_nationality">
					<xsl:with-param name="nationality">
						<xsl:value-of select ="NativePlace"/>
					</xsl:with-param>
		</xsl:call-template>
	</Nationality>
	<MaritalStatus></MaritalStatus> <!-- ���(N/Y) -->
	<!-- ���cm -->
	<Stature>
		<xsl:variable name ="stature" select ="Stature"/>
		<xsl:choose>
			<xsl:when test="$stature = 0.0"></xsl:when>
			<xsl:otherwise><xsl:apply-templates select="Stature" /></xsl:otherwise>
		</xsl:choose>
	</Stature>
	<!-- ����kg -->
	<Weight>
		<xsl:variable name ="avoirdupois" select ="Avoirdupois"/>
		<xsl:choose>
			<xsl:when test="$avoirdupois = 0.0"></xsl:when>
			<xsl:otherwise><xsl:apply-templates select="Avoirdupois" /></xsl:otherwise>
		</xsl:choose></Weight>
      <JobCode>
       <xsl:call-template name="tran_jobcode">
		  <xsl:with-param name="jobcode">
			 <xsl:value-of select="JobCode" />
		  </xsl:with-param>
      </xsl:call-template>
      </JobCode> <!-- ְҵ���� -->
  	  <Address><xsl:value-of select="MailAddress"/></Address>
	  <ZipCode><xsl:value-of select="MailZipCode"/></ZipCode>
	  <Mobile><xsl:value-of select="Mobile"/></Mobile>
	  <Phone><xsl:value-of select="Phone"/></Phone>
	  <Email><xsl:value-of select="Email"/></Email>
</Insured>
</xsl:template>

 <!-- ��Ʒ��ϴ��� -->
<xsl:template name="tran_ContPlanCode">
	<xsl:param name="contPlanCode" />
	<xsl:choose>
		<!-- PBKINSR-673 ��������ʢ2��ʢ3��50002��Ʒ���� -->
		<!-- 50002-�������Ӯ���ռƻ�:���գ�122046 - �������Ӯ1����ȫ����, �����գ�122047 - ����ӳ�����Ӯ��ȫ���� , 122048-����������������գ������ͣ�-->
		<xsl:when test="$contPlanCode='50002'">50015</xsl:when>
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- ���ִ��룬���ļ���δʹ��ת����ֻ�Ǽ�¼�����ߵ����� -->
<xsl:template name="tran_RiskCode">
	<xsl:param name="riskCode" />
	<xsl:choose>
		<!-- PBKINSR-673 ��������ʢ2��ʢ3��50002��Ʒ���� -->
		<xsl:when test="$riskCode='50002'">50015</xsl:when><!-- �������Ӯ���ռƻ� -->			
		<xsl:when test="$riskCode='122010'">L12100</xsl:when><!-- ����ʢ��3���������գ������ͣ� -->
		<xsl:when test="$riskCode='122012'">L12079</xsl:when><!-- ����ʢ��2���������գ������ͣ� -->
		
		<xsl:when test="$riskCode='L12080'">L12080</xsl:when><!-- ����ʢ��1���������գ������ͣ� -->
		<xsl:when test="$riskCode='L12074'">L12074</xsl:when><!-- ����ʢ��9����ȫ���գ������ͣ� -->
		<xsl:when test="$riskCode='L12091'">L12091</xsl:when><!-- �����Ӯ1�������A�� -->
		<!-- <xsl:when test="$riskCode='L12085'">L12085</xsl:when> --><!-- �����2����ȫ���գ������ͣ� -->
		<!-- <xsl:when test="$riskCode='L12086'">L12086</xsl:when> --><!-- �����3����ȫ���գ������ͣ� -->
		<!-- <xsl:when test="$riskCode='L12088'">L12088</xsl:when> --><!-- �����9����ȫ���գ������ͣ� -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<!-- ֤������ -->

<!-- ���ģ�0	�������֤,1 ����,2 ����֤,3 ����,4 ����֤��,5	���ڲ�,8	����,9	�쳣���֤ -->
<xsl:template name="tran_IDType">
<xsl:param name="idtype">0</xsl:param>
	<xsl:choose>
		<xsl:when test="$idtype='0'">0</xsl:when><!-- ���֤ -->
		<xsl:when test="$idtype='1'">1</xsl:when><!-- ���� -->
		<xsl:when test="$idtype='2'">2</xsl:when><!-- ����֤ -->
		<xsl:when test="$idtype='3'">5</xsl:when><!-- ���ڲ� -->
		<xsl:when test="$idtype='4'">8</xsl:when><!-- �۰�̨ͨ��֤ -->
		<xsl:when test="$idtype='5'">8</xsl:when><!-- �侯���֤ -->
		<xsl:when test="$idtype='6'">8</xsl:when><!-- ������뾳ͨ��֤ -->
	</xsl:choose>
</xsl:template>

<!-- ְҵ���� -->
<xsl:template name="tran_jobcode">
<xsl:param name="jobcode" />
	<xsl:choose>
		<xsl:when test="$jobcode= '001'">1010106</xsl:when><!-- ���һ��ء���Ⱥ��֯����ҵ����ҵ��λ��Ա-->
		<xsl:when test="$jobcode= '002'">2050601</xsl:when><!-- ����רҵ������Ա                      -->
		<xsl:when test="$jobcode= '003'">2070502</xsl:when><!-- ����ҵ����Ա???                       -->
		<xsl:when test="$jobcode= '004'">2080103</xsl:when><!-- ����רҵ��Ա                          -->
		<xsl:when test="$jobcode= '005'">2090101</xsl:when><!-- ��ѧ��Ա                              -->
		<xsl:when test="$jobcode= '006'">2120109</xsl:when><!-- ���ų��漰��ѧ����������Ա            -->
		<xsl:when test="$jobcode= '007'">2130101</xsl:when><!-- �ڽ�ְҵ��                            -->
		<xsl:when test="$jobcode= '008'">3030101</xsl:when><!-- �����͵���ҵ����Ա                    -->
		<xsl:when test="$jobcode= '009'">9210102</xsl:when><!-- ��ҵ������ҵ��Ա                      -->
		<xsl:when test="$jobcode= '010'">5050104</xsl:when><!-- ũ���֡������桢ˮ��ҵ������Ա        -->
		<xsl:when test="$jobcode= '011'">6240107</xsl:when><!-- ������Ա??                            -->
		<xsl:when test="$jobcode= '012'">2020101</xsl:when><!-- ���ʿ�����Ա                          -->
		<xsl:when test="$jobcode= '013'">6230911</xsl:when><!-- ����ʩ����Ա?                         -->
		<xsl:when test="$jobcode= '014'">6050908</xsl:when><!-- �ӹ����졢���鼰������Ա              -->
		<xsl:when test="$jobcode= '015'">7010121</xsl:when><!-- ����                                  -->
		<xsl:when test="$jobcode= '016'">8010101</xsl:when><!-- ��ҵ                                  -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Ͷ���˳������� TBR_LIVEZONE -->
<xsl:template name="tran_livezone">
<xsl:param name="livezone" />
<xsl:choose>
	<xsl:when test="$livezone=0">1</xsl:when>	<!-- ������� -->
	<xsl:when test="$livezone=1">2</xsl:when>	<!-- ũ����� -->
</xsl:choose>
</xsl:template>
<!-- ���� -->
<xsl:template name="tran_nationality">
<xsl:param name="nationality" />
<xsl:choose>
		<xsl:when test="$nationality='ABW'">AW</xsl:when><!--  ��³��                    			-->	
		<xsl:when test="$nationality='AFG'">AF</xsl:when><!--  ������                         -->
		<xsl:when test="$nationality='AGO'">AO</xsl:when><!--  ������                         -->
		<xsl:when test="$nationality='AIA'">AI</xsl:when><!--  ������                         -->
		<xsl:when test="$nationality='ALB'">AL</xsl:when><!--  ����������                     -->
		<xsl:when test="$nationality='AND'">AD</xsl:when><!--  ������                         -->
		<xsl:when test="$nationality='ANT'">AN</xsl:when><!--  ����������˹                   -->
		<xsl:when test="$nationality='ARE'">AE</xsl:when><!--  ������                         -->
		<xsl:when test="$nationality='ARG'">AR</xsl:when><!--  ����͢                         -->
		<xsl:when test="$nationality='ARM'">AM</xsl:when><!--  ��������                       -->
		<xsl:when test="$nationality='ASM'">AS</xsl:when><!--  ������Ħ��                     -->
		<xsl:when test="$nationality='ATA'">OTH</xsl:when><!-- �ϼ���                         -->
		<xsl:when test="$nationality='ATF'">OTH</xsl:when><!-- �����ϲ�����                   -->
		<xsl:when test="$nationality='ATG'">AG</xsl:when><!--  ����ϺͰͲ���                 -->
		<xsl:when test="$nationality='AUS'">AU</xsl:when><!--  �Ĵ�����                       -->
		<xsl:when test="$nationality='AUT'">AT</xsl:when><!--  �µ���                         -->
		<xsl:when test="$nationality='AZE'">AZ</xsl:when><!--	 �����ݽ�                 	    -->
		<xsl:when test="$nationality='BDI'">BI</xsl:when><!--  ��¡��                         -->
		<xsl:when test="$nationality='BEL'">BE</xsl:when><!--  ����ʱ                         -->
		<xsl:when test="$nationality='BEN'">BJ</xsl:when><!--  ����                           -->
		<xsl:when test="$nationality='BFA'">BF</xsl:when><!--  �����ɷ���                     -->
		<xsl:when test="$nationality='BGD'">BD</xsl:when><!--  �ϼ�����                       -->
		<xsl:when test="$nationality='BGR'">BG</xsl:when><!--  ��������                       -->
		<xsl:when test="$nationality='BHR'">BH</xsl:when><!--  ����                           -->
		<xsl:when test="$nationality='BHS'">BS</xsl:when><!--  �͹���                         -->
		<xsl:when test="$nationality='BIH'">BA</xsl:when><!--  ��˹���Ǻͺ�����ά��           -->
		<xsl:when test="$nationality='BLR'">BY</xsl:when><!--  �׶���˹                       -->
		<xsl:when test="$nationality='BLZ'">BZ</xsl:when><!--  ������                         -->
		<xsl:when test="$nationality='BMU'">BM</xsl:when><!--  ��Ľ��                         -->
		<xsl:when test="$nationality='BOL'">BO</xsl:when><!--  ����ά��                       -->
		<xsl:when test="$nationality='BRA'">BR</xsl:when><!--  ����                           -->
		<xsl:when test="$nationality='BRB'">BB</xsl:when><!--  �ͰͶ�˹                       -->
		<xsl:when test="$nationality='BRN'">BN</xsl:when><!--  ����                           -->
		<xsl:when test="$nationality='BTN'">BT</xsl:when><!--  ����                           -->
		<xsl:when test="$nationality='BVT'">OTH</xsl:when><!-- ��ά��                         -->
		<xsl:when test="$nationality='BWA'">BW</xsl:when><!--  ��������                       -->
		<xsl:when test="$nationality='CAF'">CF</xsl:when><!--  �з�                           -->
		<xsl:when test="$nationality='CAN'">CA</xsl:when><!--  ���ô�                         -->
		<xsl:when test="$nationality='CCK'">OTH</xsl:when><!-- �ƿ�˹����Ⱥ��                 -->
		<xsl:when test="$nationality='CHE'">CH</xsl:when><!--  ��ʿ                           -->
		<xsl:when test="$nationality='CHL'">CL</xsl:when><!--  ����                           -->
		<xsl:when test="$nationality='CHN'">CHN</xsl:when><!-- �й�                           -->
		<xsl:when test="$nationality='CIV'">CI</xsl:when><!--  ���ص���                       -->
		<xsl:when test="$nationality='CMR'">CM</xsl:when><!--  ����¡                         -->
		<xsl:when test="$nationality='COD'">CG</xsl:when><!--  �չ���                         -->
		<xsl:when test="$nationality='COG'">ZR</xsl:when><!--  �չ���                         -->
		<xsl:when test="$nationality='COK'">CK</xsl:when><!--  ���Ⱥ��                       -->
		<xsl:when test="$nationality='COL'">CO</xsl:when><!--  ���ױ���                       -->
		<xsl:when test="$nationality='COM'">KM</xsl:when><!--  ��Ħ��                         -->
	  <xsl:when test="$nationality='CPV'">CV</xsl:when><!--      ��ý�                         -->
	  <xsl:when test="$nationality='CRI'">CR</xsl:when><!--      ��˹�����                     -->
	  <xsl:when test="$nationality='CUB'">CU</xsl:when><!--      �Ű�                           -->
	  <xsl:when test="$nationality='CXR'">OTH</xsl:when><!--     ʥ����                         -->
	  <xsl:when test="$nationality='CYM'">KY</xsl:when><!--      ����Ⱥ��                       -->
	  <xsl:when test="$nationality='CYP'">CY</xsl:when><!--      ����·˹                       -->
	  <xsl:when test="$nationality='CZE'">CZ</xsl:when><!--      �ݿ�                           -->
	  <xsl:when test="$nationality='DEU'">DE</xsl:when><!--      �¹�                           -->
	  <xsl:when test="$nationality='DJI'">DJ</xsl:when><!--      ������                         -->
	  <xsl:when test="$nationality='DMA'">DM</xsl:when><!--      �������                       -->
	  <xsl:when test="$nationality='DNK'">DK</xsl:when><!--      ����                           -->
	  <xsl:when test="$nationality='DOM'">DO</xsl:when><!--      ������ӹ��͹�                 -->
	  <xsl:when test="$nationality='DZA'">DZ</xsl:when><!--      ����������                     -->
	  <xsl:when test="$nationality='ECU'">EC</xsl:when><!--      ��϶��                       -->
	  <xsl:when test="$nationality='EGY'">EG</xsl:when><!--      ����                           -->
	  <xsl:when test="$nationality='ERI'">ER</xsl:when><!--      ����������                     -->
	  <xsl:when test="$nationality='ESH'">OTH</xsl:when><!--     ��������                       -->
	  <xsl:when test="$nationality='ESP'">ES</xsl:when><!--      ������                         -->
	  <xsl:when test="$nationality='EST'">EE</xsl:when><!--      ��ɳ����                       -->
	  <xsl:when test="$nationality='ETH'">ET</xsl:when><!--      ���������                     -->
	  <xsl:when test="$nationality='FIN'">FI</xsl:when><!--      ����                           -->
	  <xsl:when test="$nationality='FJI'">FJ</xsl:when><!--      쳼�                           -->
	  <xsl:when test="$nationality='FLK'">OTH</xsl:when><!--     ���ά��˹Ⱥ��������Ⱥ��       -->
	  <xsl:when test="$nationality='FRA'">FR</xsl:when><!--      ����                           -->
	  <xsl:when test="$nationality='FRO'">FO</xsl:when><!--      ����Ⱥ��                       -->
	  <xsl:when test="$nationality='FSM'">OTH</xsl:when><!--     �ܿ���������                   -->
	  <xsl:when test="$nationality='GAB'">GA</xsl:when><!--      ����                           -->
	  <xsl:when test="$nationality='GBR'">GB</xsl:when><!--      Ӣ��                           -->
	  <xsl:when test="$nationality='GEO'">GE</xsl:when><!--      ��³����                       -->
	  <xsl:when test="$nationality='GHA'">GH</xsl:when><!--      ����                           -->
	  <xsl:when test="$nationality='GIB'">GI</xsl:when><!--      ֱ������                       -->
	  <xsl:when test="$nationality='GIN'">GN</xsl:when><!--      ������                         -->
	  <xsl:when test="$nationality='GLP'">GP</xsl:when><!--      �ϵ�����                       -->
	  <xsl:when test="$nationality='GMB'">GM</xsl:when><!--      �Ա���                         -->
	  <xsl:when test="$nationality='GNB'">GW</xsl:when><!--      �����Ǳ���                     -->
	  <xsl:when test="$nationality='GNQ'">GQ</xsl:when><!--      ���������                     -->
	  <xsl:when test="$nationality='GRC'">GR</xsl:when><!--      ϣ��                           -->
	  <xsl:when test="$nationality='GRD'">GD</xsl:when><!--      �����ɴ�                       -->
	  <xsl:when test="$nationality='GRL'">GL</xsl:when><!--      ������                         -->
	  <xsl:when test="$nationality='GTM'">GT</xsl:when><!--      Σ������                       -->
	  <xsl:when test="$nationality='GUF'">GF</xsl:when><!--      ����������                     -->
	  <xsl:when test="$nationality='GUM'">GU</xsl:when><!--      �ص�                           -->
	  <xsl:when test="$nationality='GUY'">GY</xsl:when><!--      ������                         -->
	  <xsl:when test="$nationality='HKG'">CHN</xsl:when><!--     ���                           -->
	  <xsl:when test="$nationality='HMD'">OTH</xsl:when><!--     �յµ���������ɵ�             -->
	  <xsl:when test="$nationality='HND'">HN</xsl:when><!--      �鶼��˹                       -->
	  <xsl:when test="$nationality='HRV'">HR</xsl:when><!--      ���޵���                       -->
	  <xsl:when test="$nationality='HTI'">HT</xsl:when><!--      ����                           -->
	  <xsl:when test="$nationality='HUN'">HU</xsl:when><!--      ������                         -->
	  <xsl:when test="$nationality='IDN'">ID</xsl:when><!--      ӡ��������                     -->
	  <xsl:when test="$nationality='IND'">IN</xsl:when><!--      ӡ��                           -->
	  <xsl:when test="$nationality='IOT'">OTH</xsl:when><!--     Ӣ��ӡ��������                 -->
	  <xsl:when test="$nationality='IRL'">IE</xsl:when><!--      ������                         -->
	  <xsl:when test="$nationality='IRN'">IR</xsl:when><!--      ����                           -->
	  <xsl:when test="$nationality='IRQ'">IQ</xsl:when><!--      ������                         -->
	  <xsl:when test="$nationality='ISL'">IS</xsl:when><!--      ����                           -->
	  <xsl:when test="$nationality='ISR'">IL</xsl:when><!--      ��ɫ��                         -->
	  <xsl:when test="$nationality='ITA'">IT</xsl:when><!--      �����                         -->
	  <xsl:when test="$nationality='JAM'">JM</xsl:when><!--      �����                         -->
	  <xsl:when test="$nationality='JOR'">JO</xsl:when><!--      Լ��                           -->
	  <xsl:when test="$nationality='JPN'">JP</xsl:when><!--      �ձ�                           -->
	  <xsl:when test="$nationality='KAZ'">KZ</xsl:when><!--      ������˹̹                     -->
	  <xsl:when test="$nationality='KEN'">KE</xsl:when><!--      ������                         -->
	  <xsl:when test="$nationality='KGZ'">KG</xsl:when><!--      ������˹˹̹                   -->
	  <xsl:when test="$nationality='KHM'">KH</xsl:when><!--      ����կ                         -->
	  <xsl:when test="$nationality='KIR'">KT</xsl:when><!--      �����˹                       -->
	  <xsl:when test="$nationality='KNA'">SX</xsl:when><!--      ʥ���ĺ���ά˹                 -->
	  <xsl:when test="$nationality='KOR'">KR</xsl:when><!--      ����                           -->
	  <xsl:when test="$nationality='KWT'">KW</xsl:when><!--      ������                         -->
	  <xsl:when test="$nationality='LAO'">LA</xsl:when><!--      ����                           -->
	  <xsl:when test="$nationality='LBN'">LB</xsl:when><!--      �����                         -->
	  <xsl:when test="$nationality='LBR'">LR</xsl:when><!--      ��������                       -->
	  <xsl:when test="$nationality='LBY'">LY</xsl:when><!--      ������                         -->
	  <xsl:when test="$nationality='LCA'">SQ</xsl:when><!--      ʥ¬����                       -->
	  <xsl:when test="$nationality='LIE'">LI</xsl:when><!--      ��֧��ʿ��                     -->
	  <xsl:when test="$nationality='LKA'">LK</xsl:when><!--      ˹������                       -->
	  <xsl:when test="$nationality='LSO'">LS</xsl:when><!--      ������                         -->
	  <xsl:when test="$nationality='LTU'">LT</xsl:when><!--      ������                         -->
	  <xsl:when test="$nationality='LUX'">LU</xsl:when><!--      ¬ɭ��                         -->
	  <xsl:when test="$nationality='LVA'">LV</xsl:when><!--      ����ά��                       -->
	  <xsl:when test="$nationality='MAC'">CHN</xsl:when><!--     ����                           -->
	  <xsl:when test="$nationality='MAR'">MA</xsl:when><!--      Ħ���                         -->
	  <xsl:when test="$nationality='MCO'">MC</xsl:when><!--      Ħ�ɸ�                         -->
	  <xsl:when test="$nationality='MDA'">MD</xsl:when><!--      Ħ������                       -->
	  <xsl:when test="$nationality='MDG'">MG</xsl:when><!--      ����˹��                     -->
	  <xsl:when test="$nationality='MDV'">MV</xsl:when><!--      �������                       -->
	  <xsl:when test="$nationality='MEX'">MX</xsl:when><!--      ī����                         -->
	  <xsl:when test="$nationality='MHL'">MH</xsl:when><!--      ���ܶ�Ⱥ��                     -->
	  <xsl:when test="$nationality='MKD'">MK</xsl:when><!--      ��˹��                         -->
	  <xsl:when test="$nationality='MLI'">ML</xsl:when><!--      ����                           -->
	  <xsl:when test="$nationality='MLT'">MT</xsl:when><!--      �����                         -->
	  <xsl:when test="$nationality='MMR'">MM</xsl:when><!--      ���                           -->
	  <xsl:when test="$nationality='MNG'">MN</xsl:when><!--      �ɹ�                           -->
	  <xsl:when test="$nationality='MNP'">MP</xsl:when><!--      ����������                     -->
	  <xsl:when test="$nationality='MOZ'">MZ</xsl:when><!--      Īɣ�ȿ�                       -->
	  <xsl:when test="$nationality='MRT'">MR</xsl:when><!--      ë��������                     -->
	  <xsl:when test="$nationality='MSR'">MS</xsl:when><!--      ����������                     -->
	  <xsl:when test="$nationality='MTQ'">MQ</xsl:when><!--      �������                       -->
	  <xsl:when test="$nationality='MUS'">MU</xsl:when><!--      ë����˹                       -->
	  <xsl:when test="$nationality='MWI'">MW</xsl:when><!--      ����ά                         -->
	  <xsl:when test="$nationality='MYS'">MY</xsl:when><!--      ��������                       -->
	  <xsl:when test="$nationality='MYT'">YT</xsl:when><!--      ��Լ��                         -->
	  <xsl:when test="$nationality='NAM'">NA</xsl:when><!--      ���ױ���                       -->
	  <xsl:when test="$nationality='NCL'">NC</xsl:when><!--      �¿��������                   -->
	  <xsl:when test="$nationality='NER'">NE</xsl:when><!--      ���ն�                         -->
	  <xsl:when test="$nationality='NFK'">NF</xsl:when><!--      ŵ���˵�                       -->
	  <xsl:when test="$nationality='NGA'">NG</xsl:when><!--      ��������                       -->
	  <xsl:when test="$nationality='NIC'">NI</xsl:when><!--      �������                       -->
	  <xsl:when test="$nationality='NIU'">NU</xsl:when><!--      Ŧ��                           -->
	  <xsl:when test="$nationality='NLD'">NL</xsl:when><!--      ����                           -->
	  <xsl:when test="$nationality='NOR'">NO</xsl:when><!--      Ų��                           -->
	  <xsl:when test="$nationality='NPL'">NP</xsl:when><!--      �Ჴ��                         -->
	  <xsl:when test="$nationality='NRU'">NR</xsl:when><!--      �³                           -->
	  <xsl:when test="$nationality='NZL'">NZ</xsl:when><!--      ������                         -->
	  <xsl:when test="$nationality='OMN'">OM</xsl:when><!--      ����                           -->
	  <xsl:when test="$nationality='PAK'">PK</xsl:when><!--      �ͻ�˹̹                       -->
	  <xsl:when test="$nationality='PAN'">PA</xsl:when><!--      ������                         -->
	  <xsl:when test="$nationality='PCN'">OTH</xsl:when><!--     Ƥ�ؿ���Ⱥ��                   -->
	  <xsl:when test="$nationality='PER'">PE</xsl:when><!--      ��³                           -->
	  <xsl:when test="$nationality='PHL'">PH</xsl:when><!--      ���ɱ�                         -->
	  <xsl:when test="$nationality='PLW'">PW</xsl:when><!--      ����                           -->
	  <xsl:when test="$nationality='PNG'">PG</xsl:when><!--      �Ͳ����¼�����                 -->
	  <xsl:when test="$nationality='POL'">PL</xsl:when><!--      ����                           -->
	  <xsl:when test="$nationality='PRI'">PR</xsl:when><!--      �������                       -->
	  <xsl:when test="$nationality='PRK'">KP</xsl:when><!--      ����                           -->
	  <xsl:when test="$nationality='PRT'">PT</xsl:when><!--      ������                         -->
	  <xsl:when test="$nationality='PRY'">PY</xsl:when><!--      ������                         -->
	  <xsl:when test="$nationality='PSE'">OTH</xsl:when><!--     ����˹̹                       -->
	  <xsl:when test="$nationality='PYF'">PF</xsl:when><!--      ��������������                 -->
	  <xsl:when test="$nationality='QAT'">QA</xsl:when><!--      ������                         -->
	  <xsl:when test="$nationality='REU'">RE</xsl:when><!--      ������                         -->
	  <xsl:when test="$nationality='ROM'">RO</xsl:when><!--      ��������                       -->
	  <xsl:when test="$nationality='RUS'">RU</xsl:when><!--      ����˹                         -->
	  <xsl:when test="$nationality='RWA'">RW</xsl:when><!--      ¬����                         -->
	  <xsl:when test="$nationality='SAU'">SA</xsl:when><!--      ɳ�ذ�����                     -->
	  <xsl:when test="$nationality='SCG'">OTH</xsl:when><!--     ����ά�Ǻͺ�ɽ                 -->
	  <xsl:when test="$nationality='SDN'">SD</xsl:when><!--      �յ�                           -->
	  <xsl:when test="$nationality='SEN'">SN</xsl:when><!--      ���ڼӶ�                       -->
	  <xsl:when test="$nationality='SGP'">SG</xsl:when><!--      �¼���                         -->
	  <xsl:when test="$nationality='SGS'">OTH</xsl:when><!--     �������ǵ�����ɣ��Τ�浺       -->
	  <xsl:when test="$nationality='SHN'">OTH</xsl:when><!--     ʥ������                       -->
	  <xsl:when test="$nationality='SJM'">OTH</xsl:when><!--     ˹�߶���Ⱥ��������Ⱥ��         -->
	  <xsl:when test="$nationality='SLB'">SB</xsl:when><!--      ������Ⱥ��                     -->
	  <xsl:when test="$nationality='SLE'">SL</xsl:when><!--      ��������                       -->
	  <xsl:when test="$nationality='SLV'">SV</xsl:when><!--      �����߶�                       -->
	  <xsl:when test="$nationality='SMR'">SM</xsl:when><!--      ʥ����ŵ                       -->
	  <xsl:when test="$nationality='SOM'">SO</xsl:when><!--      ������                         -->
	  <xsl:when test="$nationality='SPM'">OTH</xsl:when><!--     ʥƤ�������ܿ�¡               -->
	  <xsl:when test="$nationality='STP'">ST</xsl:when><!--      ʥ��������������               -->
	  <xsl:when test="$nationality='SUR'">SR</xsl:when><!--      ������                         -->
	  <xsl:when test="$nationality='SVK'">SK</xsl:when><!--      ˹�工��                       -->
	  <xsl:when test="$nationality='SVN'">SI</xsl:when><!--      ˹��������                     -->
	  <xsl:when test="$nationality='SWE'">SE</xsl:when><!--      ���                           -->
	  <xsl:when test="$nationality='SWZ'">SZ</xsl:when><!--      ˹��ʿ��                       -->
	  <xsl:when test="$nationality='SYC'">SC</xsl:when><!--      �����                         -->
	  <xsl:when test="$nationality='SYR'">SY</xsl:when><!--      ������                         -->
	  <xsl:when test="$nationality='TCA'">TC</xsl:when><!--      �ؿ�˹�Ϳ���˹Ⱥ��             -->
	  <xsl:when test="$nationality='TCD'">TD</xsl:when><!--      է��                           -->
	  <xsl:when test="$nationality='TGO'">TG</xsl:when><!--      ���                           -->
	  <xsl:when test="$nationality='THA'">TH</xsl:when><!--      ̩��                           -->
	  <xsl:when test="$nationality='TJK'">TJ</xsl:when><!--      ������˹̹                     -->
	  <xsl:when test="$nationality='TKL'">OTH</xsl:when><!--     �п���                         -->
	  <xsl:when test="$nationality='TKM'">TM</xsl:when><!--      ������˹̹                     -->
	  <xsl:when test="$nationality='TMP'">OTH</xsl:when><!--     ������                         -->
	  <xsl:when test="$nationality='TON'">TO</xsl:when><!--      ����                           -->
	  <xsl:when test="$nationality='TTO'">TT</xsl:when><!--      �������Ͷ�͸�               -->
	  <xsl:when test="$nationality='TUN'">TN</xsl:when><!--      ͻ��˹                         -->
	  <xsl:when test="$nationality='TUR'">TR</xsl:when><!--      ������                         -->
	  <xsl:when test="$nationality='TUV'">TV</xsl:when><!--      ͼ��¬                         -->
	  <xsl:when test="$nationality='TWN'">CHN</xsl:when><!--     �й�̨��                       -->
	  <xsl:when test="$nationality='TZA'">TZ</xsl:when><!--      ̹ɣ����                       -->
	  <xsl:when test="$nationality='UGA'">UG</xsl:when><!--      �ڸɴ�                         -->
	  <xsl:when test="$nationality='UKR'">UA</xsl:when><!--      �ڿ���                         -->
	  <xsl:when test="$nationality='UMI'">OTH</xsl:when><!--     ����������С����               -->
	  <xsl:when test="$nationality='URY'">UY</xsl:when><!--      ������                         -->
	  <xsl:when test="$nationality='USA'">US</xsl:when><!--      ����                           -->
	  <xsl:when test="$nationality='UZB'">UZ</xsl:when><!--      ���ȱ��˹̹                   -->
	  <xsl:when test="$nationality='VAT'">OTH</xsl:when><!--     ��ٸ�                         -->
	  <xsl:when test="$nationality='VCT'">VC</xsl:when><!--      ʥ��ɭ�غ͸����ɶ�˹           -->
	  <xsl:when test="$nationality='VEN'">VE</xsl:when><!--      ί������                       -->
	  <xsl:when test="$nationality='VGB'">VG</xsl:when><!--      Ӣ��ά����Ⱥ��                 -->
	  <xsl:when test="$nationality='VIR'">VI</xsl:when><!--      ����ά����Ⱥ��                 -->
	  <xsl:when test="$nationality='VNM'">VN</xsl:when><!--      Խ��                           -->
	  <xsl:when test="$nationality='VUT'">VU</xsl:when><!--      ��Ŭ��ͼ                       -->
	  <xsl:when test="$nationality='WLF'">OTH</xsl:when><!--     ����˹�͸�ͼ��Ⱥ��             -->
	  <xsl:when test="$nationality='WSM'">WS</xsl:when><!--      ����Ħ��                       -->
	  <xsl:when test="$nationality='YEM'">YE</xsl:when><!--      Ҳ��                           -->
	  <xsl:when test="$nationality='ZAF'">ZA</xsl:when><!--      �Ϸ�                           -->
	  <xsl:when test="$nationality='ZAR'">OTH</xsl:when><!--     ������                         -->
	  <xsl:when test="$nationality='ZMB'">ZM</xsl:when><!--      �ޱ���                         -->
	  <xsl:when test="$nationality='ZWE'">ZW</xsl:when><!--      ��Ͳ�Τ                       -->
	  <xsl:when test="$nationality='OTH'">OTH</xsl:when><!--    ����                            -->
</xsl:choose>
</xsl:template>
<!-- ��ϵ -->
<xsl:template name="tran_RelationRoleCode">
<xsl:param name="relationRoleCode" />
<xsl:choose>
	<xsl:when test="$relationRoleCode=00">00</xsl:when>	<!-- ���� -->
	<xsl:when test="$relationRoleCode=01">03</xsl:when>	<!-- ��ĸ -->
	<xsl:when test="$relationRoleCode=02">01</xsl:when>	<!-- ��Ů -->
	<xsl:when test="$relationRoleCode=03">02</xsl:when>	<!-- ��ż -->  
	<xsl:when test="$relationRoleCode=04">04</xsl:when>	<!-- ���� -->
</xsl:choose>
</xsl:template>
<!-- paymode -->
<xsl:template name="tran_PayMode">
<xsl:param name="payMode" />
<xsl:choose>
	<xsl:when test="$payMode=1">1</xsl:when>	<!-- �ֽ� -->
	<xsl:when test="$payMode=2">7</xsl:when>	<!-- ����ת�� -->
	
</xsl:choose>
</xsl:template>
<!-- �����˹�ϵ -->
<xsl:template name="tran_RelationToInsured">
<xsl:param name="relationToInsured" />
<xsl:choose>
	<xsl:when test="$relationToInsured=0"></xsl:when> <!-- ���� -->
	<xsl:when test="$relationToInsured=1">01</xsl:when> <!-- ��ĸ������ô�����ڳ������жϣ� -->
	<xsl:when test="$relationToInsured=2">01</xsl:when> <!-- ��ĸ������ô�����ڳ������жϣ� -->
	<xsl:when test="$relationToInsured=3">01</xsl:when> <!-- ��ĸ������ô�����ڳ������жϣ� -->
	<xsl:when test="$relationToInsured=4">01</xsl:when> <!-- ��ĸ������ô�����ڳ������жϣ� -->
	<xsl:when test="$relationToInsured=5">04</xsl:when> <!-- ���� -->
	<xsl:when test="$relationToInsured=00">00</xsl:when> <!-- ���� -->
	<xsl:when test="$relationToInsured=7">02</xsl:when> <!-- ��ż -->
	<xsl:when test="$relationToInsured=8">04</xsl:when> <!-- ���� -->
	<xsl:when test="$relationToInsured=9">04</xsl:when> <!-- ���� -->
	<xsl:when test="$relationToInsured=10">04</xsl:when> <!-- ���� -->
	<xsl:when test="$relationToInsured=11">04</xsl:when> <!-- ���� -->
	<xsl:when test="$relationToInsured=12">04</xsl:when> <!-- ���� -->
	<xsl:when test="$relationToInsured=13">04</xsl:when> <!-- ���� -->
	<xsl:when test="$relationToInsured=14">04</xsl:when> <!-- ���� -->
	<xsl:when test="$relationToInsured=15">04</xsl:when> <!-- ���� -->
	<xsl:when test="$relationToInsured=16">04</xsl:when> <!-- ���� -->
	<xsl:when test="$relationToInsured=17">04</xsl:when> <!-- ���� -->
	<xsl:when test="$relationToInsured=18">04</xsl:when> <!-- ���� -->
	<xsl:when test="$relationToInsured=19">04</xsl:when> <!-- ���� -->
	<xsl:when test="$relationToInsured=20">04</xsl:when> <!-- ���� -->
	<xsl:when test="$relationToInsured=21">05</xsl:when> <!-- ��Ӷ -->
	<xsl:when test="$relationToInsured=22">04</xsl:when> <!-- ���� -->
</xsl:choose>
</xsl:template>
</xsl:stylesheet>
