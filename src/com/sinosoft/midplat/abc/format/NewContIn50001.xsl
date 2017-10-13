<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
 	exclude-result-prefixes="java">

<xsl:output indent='yes'/>
<xsl:template match="/Req">
	  <!--��ũ�зǱ�׼����ת��Ϊ�п����׼����-->
	  <TranData>
	  	<!--������Ϣ-->
	 <Head>
	    <TranDate><xsl:value-of select="BankDate"/></TranDate>
	    <TranTime><xsl:value-of select="BankTime"/></TranTime>
	    <TellerNo><xsl:value-of select="TellerNo"/></TellerNo>
	    <TranNo><xsl:value-of select="TransrNo"/></TranNo>
	    <NodeNo><xsl:value-of select="ZoneNo"/><xsl:value-of select="BrNo"/></NodeNo>
	    <xsl:copy-of select="Head/*"/>
	    <BankCode><xsl:value-of select="Head/TranCom/@outcode"/></BankCode>
     </Head>
	  	
    <Body>
		<ProposalPrtNo><xsl:value-of select ="Base/ProposalContNo"/></ProposalPrtNo> <!-- Ͷ����(ӡˢ)�� -->
        <ContPrtNo><xsl:value-of select="Base/PrtNo"/></ContPrtNo> <!-- ������ͬӡˢ�� -->
        <PolApplyDate><xsl:value-of select ="Base/PolApplyDate"/></PolApplyDate> <!-- Ͷ������ -->
        <AccName><xsl:value-of select ="Base/AccName"/></AccName> <!-- �˻����� -->
        <AccNo><xsl:value-of select ="Base/BankAccNo"/></AccNo> <!-- �����˻� -->
        <GetPolMode></GetPolMode> <!-- �������ͷ�ʽ -->
        <JobNotice></JobNotice> <!-- ְҵ��֪(N/Y) -->
        <HealthNotice>        	
        	<xsl:call-template name="tran_healthnotice">
		          <xsl:with-param name="healthnotice" select="Risks/Risk/HealthFlag" />
	      </xsl:call-template>
	    </HealthNotice> <!-- ������֪(N/Y)  -->        
        <PolicyIndicator></PolicyIndicator><!--δ���걻�������Ƿ����������չ�˾Ͷ����ʱ��� Y��N��-->
        <InsuredTotalFaceAmount></InsuredTotalFaceAmount><!--�ۼ�Ͷ����ʱ���-->
        
        <!-- ��ϲ�Ʒ���� -->
		<xsl:variable name="ContPlanMult"><xsl:value-of select="Risks/Risk[Code=MainRiskCode]/Mult" /></xsl:variable>
		<!-- ����,�˴��ǲ�Ʒ��ϱ��� -->
		<xsl:variable name="ContPlanCode">
			<xsl:call-template name="tran_ContPlanCode">
				<xsl:with-param name="contPlanCode" select="Risks/Risk[Code=MainRiskCode]/MainRiskCode" />
			</xsl:call-template>
		</xsl:variable>

		<!-- ��Ʒ��� -->
		<ContPlan>
			<!-- ��Ʒ��ϱ��� -->
			<ContPlanCode><xsl:value-of select="$ContPlanCode" /></ContPlanCode>
			<!-- ��Ʒ��Ϸ��� -->
			<ContPlanMult><xsl:value-of select="$ContPlanMult" /></ContPlanMult>
		</ContPlan>
	<Appnt>	
        <Name><xsl:value-of select ="Appl/Name"/></Name> <!-- ���� -->
        <Sex><xsl:value-of select ="Appl/Sex"/></Sex> <!-- �Ա� -->
        <Birthday><xsl:value-of select ="Appl/Birthday"/></Birthday> <!-- ��������(yyyyMMdd) -->
        <IDType>
         <xsl:call-template name="tran_IDType">
					<xsl:with-param name="idtype">
						<xsl:value-of select ="Appl/IDType"/>
					</xsl:with-param>
		</xsl:call-template>
		</IDType> <!-- ֤������ -->
        <IDNo><xsl:value-of select ="Appl/IDNo"/></IDNo> <!-- ֤������ -->
        <IDTypeStartDate></IDTypeStartDate > <!-- ֤����Ч���� -->
        <IDTypeEndDate><xsl:value-of select ="Appl/ValidYear"/></IDTypeEndDate > <!-- ֤����Чֹ��yyyyMMdd -->
        <JobCode>
          <xsl:call-template name="tran_jobcode">
					<xsl:with-param name="jobcode">
						<xsl:value-of select="Appl/JobCode" />
					</xsl:with-param>
		  </xsl:call-template>
		</JobCode> <!-- ְҵ���� -->
        <Nationality>
		<xsl:call-template name="tran_Nationality">
		  <xsl:with-param name="nationality">
		 	<xsl:value-of select="Appl/Country"/>
	      </xsl:with-param>
	    </xsl:call-template>
	    </Nationality> <!-- ���� -->
        <Stature></Stature> <!-- ���(cm) -->
        <Weight></Weight> <!-- ����(g) -->
        <MaritalStatus></MaritalStatus> <!-- ���(N/Y) -->
        <Address><xsl:value-of select ="Appl/Address"/></Address> <!-- ��ַ -->
        <ZipCode><xsl:value-of select ="Appl/ZipCode"/></ZipCode> <!-- �ʱ� -->
        <Mobile><xsl:value-of select ="Appl/Mobile"/></Mobile> <!-- �ƶ��绰 -->
        <Phone><xsl:value-of select ="Appl/Phone"/></Phone> <!-- �̶��绰 -->
        <Email><xsl:value-of select ="Appl/Email"/></Email> <!-- �����ʼ�-->
        <RelaToInsured>
         	<xsl:call-template name="tran_RelationRoleCode">
					<xsl:with-param name="relaToInsured">
						<xsl:value-of select="Appl/RelaToInsured"/>
					</xsl:with-param>
		   </xsl:call-template>
        </RelaToInsured> <!-- �뱻���˹�ϵ -->
    </Appnt>
		

   <Insured>
      <Name><xsl:value-of select="Insu/Name"/></Name> <!-- ���� -->
      <Sex><xsl:value-of select="Insu/Sex"/></Sex> <!-- �Ա� -->
      <Birthday><xsl:value-of select="Insu/Birthday"/></Birthday> <!-- ��������(yyyyMMdd) -->
      <IDType>
      <xsl:call-template name="tran_IDType">
		 <xsl:with-param name="idtype">
		 	<xsl:value-of select="Insu/IDType"/>
	     </xsl:with-param>
	  </xsl:call-template>
      </IDType> <!-- ֤������ -->
      <IDNo><xsl:value-of select="Insu/IDNo"/></IDNo> <!-- ֤������ -->
      <IDTypeStartDate></IDTypeStartDate > <!-- ֤����Ч���� -->
      <IDTypeEndDate><xsl:value-of select="Insu/ValidYear"/></IDTypeEndDate > <!-- ֤����Чֹ�� -->
      <JobCode>
       <xsl:call-template name="tran_jobcode">
		  <xsl:with-param name="jobcode">
			 <xsl:value-of select="Insu/JobCode" />
		  </xsl:with-param>
      </xsl:call-template>
      </JobCode> <!-- ְҵ���� -->
      <Stature></Stature> <!-- ���(cm)-->	
      <Nationality>
      <xsl:call-template name="tran_Nationality">
		 <xsl:with-param name="nationality">
		 	<xsl:value-of select="Insu/Country"/>
	     </xsl:with-param>
	  </xsl:call-template>
	  </Nationality> <!-- ���� -->
      <Weight></Weight> <!-- ����(g) -->
      <MaritalStatus></MaritalStatus> <!-- ���(N/Y) -->
  	  <Address><xsl:value-of select="Insu/Address"/></Address>
	  <ZipCode><xsl:value-of select="Insu/ZipCode"/></ZipCode>
	  <Mobile><xsl:value-of select="Insu/Mobile"/></Mobile>
	  <Phone><xsl:value-of select="Insu/Phone"/></Phone>
	  <Email><xsl:value-of select="Insu/Email"/></Email>
   </Insured>
   
   <xsl:variable name ="count" select ="Bnfs/Count"/>
		<xsl:if test="$count!=0">
			<xsl:for-each select="Bnfs/Bnf">
			<!-- ������ -->
				<Bnf>
					<Type><xsl:value-of select="Type"/></Type>
					<Grade><xsl:value-of select="BnfGrade"/></Grade>
					<Name><xsl:value-of select="Name"/></Name>
					<Sex><xsl:value-of select="Sex"/></Sex>
					<Birthday><xsl:value-of select="Birthday"/></Birthday>
					<IDType>
						<xsl:call-template name="tran_IDType">
							<xsl:with-param name="idtype">
								<xsl:value-of select="IDType"/>
							</xsl:with-param>
						</xsl:call-template>
					</IDType>
					<IDNo><xsl:value-of select="IDNo"/></IDNo>
					<RelaToInsured>
					<xsl:call-template name="tran_RelationRoleCode">
					<xsl:with-param name="relaToInsured">
						<xsl:value-of select="RelationToInsured"/>
					</xsl:with-param>
				 </xsl:call-template></RelaToInsured>
					<Lot><xsl:value-of select="BnfLot"/></Lot>
				</Bnf>
			</xsl:for-each>
		</xsl:if>
		
		<xsl:for-each select="Risks/Risk">
			<!-- ���� -->
			<Risk>
				<RiskCode><xsl:value-of select="Code"/></RiskCode>
				<MainRiskCode><xsl:value-of select="MainRiskCode"/></MainRiskCode>
				<RiskType></RiskType>
				<Amnt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Amnt)"/></Amnt>
				
				<xsl:choose>
					<xsl:when test="Prem=''">
						<Prem><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen($ContPlanMult*1000)"/></Prem>
					</xsl:when>
					<xsl:otherwise>
						<Prem><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Prem)"/></Prem>						
					</xsl:otherwise>
				</xsl:choose>
				
				<Mult><xsl:value-of select="Mult"/></Mult>
				<PayIntv>
					<xsl:call-template name="tran_PayIntv">
						<xsl:with-param name="payintv">
							<xsl:value-of select="PayIntv"/>
						</xsl:with-param>
					</xsl:call-template>
				</PayIntv>
				<PayMode></PayMode>
				<CostIntv></CostIntv>
				<CostDate></CostDate>
				<Years><xsl:value-of select="Years"/></Years>
				<InsuYearFlag>
					<xsl:call-template name="tran_YearFlag">
						<xsl:with-param name="YearFlag">
							<xsl:value-of
								select="InsuYearFlag" />
						</xsl:with-param>
					</xsl:call-template>
				</InsuYearFlag>
				<InsuYear><!-- ������ -->
		            <xsl:if test="InsuYearFlag=5">106</xsl:if>
		            <xsl:if test="InsuYearFlag!=5"><xsl:value-of select="InsuYear" /></xsl:if>
	            </InsuYear>
				<xsl:if test="PayIntv = 1">
					<PayEndYearFlag>Y</PayEndYearFlag>
					<PayEndYear>1000</PayEndYear>
				</xsl:if>
				<xsl:if test="PayIntv != 1">
					<PayEndYearFlag>
						<xsl:call-template name="tran_YearFlag">
							<xsl:with-param name="YearFlag">
								<xsl:value-of
									select="PayEndYearFlag" />
							</xsl:with-param>
						</xsl:call-template>
					</PayEndYearFlag>
					<PayEndYear><xsl:value-of select="PayEndYear"/></PayEndYear>
				</xsl:if>
				<GetYearFlag>
					<xsl:call-template name="tran_YearFlag">
						<xsl:with-param name="YearFlag">
							<xsl:value-of
								select="GetYearFlag" />
						</xsl:with-param>
					</xsl:call-template>
				</GetYearFlag>
				<GetYear><xsl:value-of select="GetYear"/></GetYear>
				<GetIntv></GetIntv>
				<GetBankCode></GetBankCode>
				<GetBankAccNo></GetBankAccNo>
				<GetAccName></GetAccName>
				<AutoPayFlag><xsl:value-of select="IsCashAutoPay"/></AutoPayFlag>
				<BonusPayMode><xsl:value-of select="BonusPayMode"/></BonusPayMode>
				<SubFlag><xsl:value-of select="SubFlag"/></SubFlag>
				<!-- ����ũ�к�����ȡ��ʽ -->
				<BonusGetMode><xsl:value-of select="BonusGetMode"/></BonusGetMode>
				<FullBonusGetMode><xsl:value-of select="FullBonusGetMode"/></FullBonusGetMode>
			</Risk>
		</xsl:for-each>
		</Body>
	</TranData>
</xsl:template>


<!-- ��Ʒ��ϴ��� -->
<xsl:template name="tran_ContPlanCode">
<xsl:param name="contPlanCode" />
<xsl:choose>
	<!-- 50001-�������Ӯ1����ȫ�������:���գ�122046 - �������Ӯ1����ȫ����,�����գ�122047 - ����ӳ�����Ӯ��ȫ���� -->
	<xsl:when test="$contPlanCode=122046">50001</xsl:when>
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>


<xsl:template name="tran_YearFlag">
	<xsl:param name="YearFlag">Y</xsl:param>
	<xsl:if test="$YearFlag = 1">A</xsl:if>
	<xsl:if test="$YearFlag = 2">M</xsl:if>
	<xsl:if test="$YearFlag = 3">D</xsl:if>
	<xsl:if test="$YearFlag = 4">Y</xsl:if>
	<xsl:if test="$YearFlag = 5">A</xsl:if>
</xsl:template>
	
	
<!-- �ɷ�Ƶ��  ����: 1������  2���½�     3������    4�����꽻    5���꽻             6��������
                   ����:  0��һ�ν���/���� 1:�½�  3:����   6:���꽻	   12���꽻          -1:�����ڽ� -->
<xsl:template name="tran_PayIntv">
	<xsl:param name="payintv">0</xsl:param>
	<xsl:if test="$payintv = '1'">0</xsl:if>
	<xsl:if test="$payintv = '2'">1</xsl:if>
	<xsl:if test="$payintv = '3'">3</xsl:if>
	<xsl:if test="$payintv = '4'">6</xsl:if>
	<xsl:if test="$payintv = '5'">12</xsl:if>
	<xsl:if test="$payintv = '6'">-1</xsl:if>
</xsl:template>
	
<!-- ֤������ -->
<xsl:template name="tran_IDType">
<xsl:param name="idtype">0</xsl:param>
	<xsl:choose>
		<xsl:when test="$idtype = 110001">0</xsl:when>	<!-- ���֤ -->
		<xsl:when test="$idtype = 110002">9</xsl:when>	<!-- �غž������֤ -->
		<xsl:when test="$idtype = 110003">0</xsl:when>	<!-- ��ʱ���֤ -->
		<xsl:when test="$idtype = 110004">9</xsl:when>	<!-- �غ���ʱ�������֤ -->
		<xsl:when test="$idtype = 110005">5</xsl:when>	<!-- ���ڲ� -->
		<xsl:when test="$idtype = 110023">1</xsl:when>	<!-- �л����񹲺͹����� -->
		<xsl:when test="$idtype = 110025">1</xsl:when>	<!-- ������� -->
		<xsl:when test="$idtype = 110027">2</xsl:when>	<!-- ����֤ -->
		<xsl:when test="$idtype = 110031">2</xsl:when>	<!-- ����֤ -->
		<xsl:when test="$idtype = 110033">2</xsl:when>	<!-- ����ʿ��֤ -->
		<xsl:when test="$idtype = 110035">2</xsl:when>	<!-- �侯ʿ��֤ -->
		<xsl:otherwise>8</xsl:otherwise>
	</xsl:choose>
</xsl:template>
	
<!-- ְҵ���� -->
<xsl:template name="tran_jobcode">
<xsl:param name="jobcode" />
	<xsl:choose>
		<xsl:when test="$jobcode='01'">4030111</xsl:when>	<!-- ���һ��ء���Ⱥ��֯����ҵ����ҵ��λ��Ա -->
		<xsl:when test="$jobcode='02'">2050101</xsl:when>	<!-- ����רҵ������Ա -->
		<xsl:when test="$jobcode='03'">2070109</xsl:when>	<!-- ����ҵ����Ա -->
		<xsl:when test="$jobcode='04'">2080103</xsl:when>	<!-- ����רҵ��Ա -->
		<xsl:when test="$jobcode='05'">2090104</xsl:when>	<!-- ��ѧ��Ա -->
		<xsl:when test="$jobcode='06'">2100106</xsl:when>	<!-- ���ų��漰��ѧ����������Ա -->
		<xsl:when test="$jobcode='07'">2130101</xsl:when>	<!-- �ڽ�ְҵ�� -->
		<xsl:when test="$jobcode='08'">3030101</xsl:when>	<!-- �����͵���ҵ����Ա -->
		<xsl:when test="$jobcode='09'">4010101</xsl:when>	<!-- ��ҵ������ҵ��Ա -->
		<xsl:when test="$jobcode='10'">5010107</xsl:when>	<!-- ũ���֡������桢ˮ��ҵ������Ա -->
		<xsl:when test="$jobcode='11'">6240105</xsl:when>	<!-- ������Ա -->
		<xsl:when test="$jobcode='12'">2020103</xsl:when>	<!-- ��ַ��̽��Ա -->
		<xsl:when test="$jobcode='13'">2020906</xsl:when>	<!-- ����ʩ����Ա -->
		<xsl:when test="$jobcode='14'">6050611</xsl:when>	<!-- �ӹ����졢���鼰������Ա -->
		<xsl:when test="$jobcode='15'">7010103</xsl:when>	<!-- ���� -->
		<xsl:when test="$jobcode='16'">8010101</xsl:when>	<!-- ��ҵ -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>
    
<!-- ��ϵ -->		
<xsl:template name="tran_RelationRoleCode">
    <xsl:param name="relaToInsured">0</xsl:param>
	<xsl:choose>
		<xsl:when test="$relaToInsured='2'">02</xsl:when>
		<xsl:when test="$relaToInsured='3'">02</xsl:when>
		<!-- ��ż -->
		<xsl:when test="$relaToInsured='4'">01</xsl:when>
		<xsl:when test="$relaToInsured='5'">01</xsl:when>
		<!-- ��ĸ -->
		<xsl:when test="$relaToInsured='6'">03</xsl:when>
		<xsl:when test="$relaToInsured='7'">03</xsl:when>
		<xsl:when test="$relaToInsured='1'">00</xsl:when>
		<!-- ���� -->
		<xsl:otherwise>04</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- ����ת�� -->
<xsl:template name="tran_Nationality">
	<xsl:param name="nationality">0</xsl:param>
	<xsl:choose>
		<xsl:when test="$nationality = '036'">AU</xsl:when>  <!-- �Ĵ����� -->
		<xsl:when test="$nationality = '156'">CHN</xsl:when> <!-- �й�  -->
		<xsl:when test="$nationality = '826'">GB</xsl:when>  <!-- Ӣ��  -->
		<xsl:when test="$nationality = '392'">JP</xsl:when>  <!-- �ձ�  -->
		<xsl:when test="$nationality = '643'">RU</xsl:when>  <!-- ����˹  -->
		<xsl:when test="$nationality = '840'">US</xsl:when>  <!-- ����  -->
		<xsl:otherwise>OTH</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- ������֪  -->
<xsl:template name="tran_healthnotice">
<xsl:param name="healthnotice" />
<xsl:choose>
	<xsl:when test="$healthnotice=0">N</xsl:when>	<!-- �޽�����֪ -->
	<xsl:when test="$healthnotice=1">Y</xsl:when>	<!-- �н�����֪ -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>
		
</xsl:stylesheet>