<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:java="http://xml.apache.org/xslt/java"
    exclude-result-prefixes="java">

    <xsl:template match="InsuReq">
        <TranData>
            <xsl:apply-templates select="Main" />
            <Body>
                <!-- Ͷ����(ӡˢ)�� -->
                <ProposalPrtNo><xsl:value-of select="Main/ApplyNo" /></ProposalPrtNo>
                <!-- ������ͬӡˢ�� -->
                <ContPrtNo></ContPrtNo>
                <!-- Ͷ������[yyyyMMdd] -->
                <PolApplyDate>
                   <xsl:value-of select="Main/ApplyDate" />
                </PolApplyDate>
                <!-- �˻����� -->
                <AccName>
                   <xsl:value-of select="Risks/Appendix/PayAccName" />
                </AccName>
                <!-- �����˻� -->
                <AccNo>
                    <xsl:value-of select="Risks/Appendix/PayAcc" />
                </AccNo>
                <!-- �������ͷ�ʽ:1=�ʼģ�2=���й�����ȡ -->
                <GetPolMode><xsl:value-of select="Risks/Appendix/SendMethod" /></GetPolMode>
                <!-- ְҵ��֪(N/Y) -->
                <JobNotice>
                    <xsl:value-of select="Risks/Appendix/OccupationFlag" />
                </JobNotice>
                <!-- ������֪(N/Y)  -->
                <HealthNotice>
                    <xsl:value-of select="Risks/Appendix/HealthFlag" />
                </HealthNotice>
                <AutoPayFlag></AutoPayFlag>
                <!-- ��Ʒ��� -->
                <ContPlan>
                	<!-- ��Ʒ��ϱ��� -->
                	<ContPlanCode>
                		<xsl:call-template name="tran_ContPlanCode">
                			<xsl:with-param name="contPlanCode">
                				<xsl:value-of select="Risks/Risk/Code" />
                			</xsl:with-param>
                		</xsl:call-template>
                	</ContPlanCode>
                	<!-- ��Ʒ��Ϸ��� -->
                	<ContPlanMult><xsl:value-of select="Risks/Risk/Unit" /></ContPlanMult>
                </ContPlan>
                <!--δ���걻�������Ƿ����������չ�˾Ͷ����ʱ��� Y��/N��-->
               <PolicyIndicator></PolicyIndicator>
              <!--�ۼ�Ͷ����ʱ���(���ĵ�λ��Ԫ)-->
              <InsuredTotalFaceAmount></InsuredTotalFaceAmount>
              <!--������������-->
              <AgentComName>
                 <xsl:value-of select="Main/BrName" />
              </AgentComName>
              <!-- �������֤-->
              <AgentComCertiCode>
                 <xsl:value-of select="Main/BrCertID" />
              </AgentComCertiCode>
              <!--����������Ա����-->
              <SellerNo>
                 <xsl:value-of select="Main/SellTeller" />
              </SellerNo>
              <!--����������Ա����-->
              <TellerName>
                 <xsl:value-of select="Main/SellTellerName" />
              </TellerName>
              <!-- ������Ա�ʸ�֤-->
              <TellerCertiCode>
                 <xsl:value-of select="Main/SellCertID" />
              </TellerCertiCode>
              <!-- ������Ա��������-->
              <TellerEmail></TellerEmail>
              <!-- Ͷ���� -->
              <Appnt>
                <xsl:apply-templates select="Appnt" />
              </Appnt>
              <!-- ������ -->
              <Insured>
                <xsl:apply-templates select="Insured" />
              </Insured>
              <!-- ������ -->
              <xsl:apply-templates select="Bnfs" />
              <!-- ������Ϣ -->
              <xsl:apply-templates select="Risks" />
           </Body>
        </TranData>
    </xsl:template>

    <!-- ����ͷ��Ϣ -->
    <xsl:template name="Head" match="Main">
        <Head>
            <!-- ��������[yyyyMMdd] -->
            <TranDate>
                <xsl:value-of select="TranDate" />
            </TranDate>
            <!-- ����ʱ��[hhmmss] -->
            <TranTime>
                <xsl:value-of select="TranTime" />
            </TranTime>
            <!-- ��Ա���� -->
            <TellerNo>
                <xsl:value-of select="TellerNo" />
            </TellerNo>
            <!-- ������ˮ�� -->
            <TranNo>
                <xsl:value-of select="TransNo" />
            </TranNo>
            <!-- ������+������ -->
            <NodeNo>
                <xsl:value-of select="ZoneNo" />
                <xsl:value-of select="BrNo" />
            </NodeNo>
            <xsl:copy-of select="../Head/*" />
            <BankCode>
                <xsl:value-of select="../Head/TranCom/@outcode" />
            </BankCode>
        </Head>
    </xsl:template>
    
    <!-- Ͷ������Ϣ -->
    <xsl:template name="Appnt" match="Appnt">
        <!-- ���� -->
        <Name>
            <xsl:value-of select="Name" />
        </Name>
        <!-- �Ա� -->
        <Sex>
            <xsl:apply-templates select="Sex" />
        </Sex>
        <!-- ��������(yyyyMMdd) -->
        <Birthday>
            <xsl:value-of select="Birthday" />
        </Birthday>
        <!-- ֤������ -->
        <IDType>
            <xsl:apply-templates select="IDType" />
        </IDType>
        <!-- ֤������ -->
        <IDNo>
            <xsl:value-of select="IDNo" />
        </IDNo>
        <!-- ֤����Ч���ڣ�yyyymmdd�� -->
        <IDTypeStartDate>
            <xsl:value-of select="IDStartDate" />
        </IDTypeStartDate>
        <!-- ֤����Чֹ�ڣ�yyyymmdd�� -->
        <xsl:if test="IDEndDate='99999999'"><IDTypeEndDate>9999-12-31</IDTypeEndDate></xsl:if>        
        <xsl:if test="IDEndDate!='99999999'"><IDTypeEndDate><xsl:value-of select="IDEndDate" /></IDTypeEndDate></xsl:if>    
        <!-- ְҵ���� -->
        <JobCode>
            <xsl:value-of select="JobCode" />
        </JobCode>
        <!-- ���� -->
        <Nationality>
            <xsl:call-template name="tran_Nationality">
				<xsl:with-param name="Nationality" select="Nationality" />
				<xsl:with-param name="IDType" select="IDType" />
		    </xsl:call-template>
            <!--<xsl:apply-templates select="Nationality" />-->
        </Nationality>
        <!-- ���(cm)-->
        <Stature></Stature>
        <!-- ����(g)  -->
        <Weight></Weight>
        <!-- Ͷ����������(��) -->
        <Salary>
            <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Income)" />
        </Salary>
        <!-- Ͷ���˼�ͥ������(��) -->
        <FamilySalary>
            <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(FamilyIncome)" />
        </FamilySalary>
        <!-- 1.����2.ũ�� -->
        <LiveZone>
           <xsl:apply-templates select="ResiType" />
        </LiveZone>
        <!-- �Ƿ��ѽ��з��������ʾ���� -->
        <RiskAssess>
           <xsl:choose>
    		  <xsl:when test="../Risks/Appendix/RiskAssess != ''">
    			<xsl:value-of select="../Risks/Appendix/RiskAssess" />
    		  </xsl:when>
    		  <xsl:otherwise>Y</xsl:otherwise>
    	   </xsl:choose>
        </RiskAssess>
        <!-- ����״���������޷�����¼������Ϣ���Ǳ�� �����Ǵ��룬��Ҫȷ�Ϻ��Ĵ������ӳ�䣿 -->
        <MaritalStatus>
            <xsl:value-of select="Marriage" />
        </MaritalStatus>
        <!-- ��ַ ��ָͨѶ�����ʼ��أ�-->
        <Address>
            <xsl:value-of select="HomeAddr" />
        </Address>
        <!-- �ʱ� -->
        <ZipCode>
            <xsl:value-of select="HomeZipCode" />
        </ZipCode>
        <!-- �ֻ� -->
        <Mobile>
            <xsl:value-of select="MobilePhone" />
        </Mobile>
        <!-- ���� -->
        <Phone>
            <xsl:value-of select="HomePhone" />
        </Phone>
        <!-- ���� -->
        <Email>
            <xsl:value-of select="Email" />
        </Email>
        <!-- Ͷ�����뱻���˹�ϵ -->
        <RelaToInsured>
            <xsl:apply-templates select="RelaToInsured" />
        </RelaToInsured>
        <!-- ����Ԥ���� -->
        <Premiumbudget><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(PremBudget)" /></Premiumbudget>
    </xsl:template>


    <!-- ����������Ϣ -->
    <xsl:template name="Insured" match="Insured">
        <!-- ���� -->
        <Name>
            <xsl:value-of select="Name" />
        </Name>
        <!-- �Ա� -->
        <Sex>
            <xsl:apply-templates select="Sex" />
        </Sex>
        <!-- ��������(yyyyMMdd) -->
        <Birthday>
            <xsl:value-of select="Birthday" />
        </Birthday>
        <!-- ֤������ -->
        <IDType>
            <xsl:apply-templates select="IDType" />
        </IDType>
        <!-- ֤������ -->
        <IDNo>
            <xsl:value-of select="IDNo" />
        </IDNo>
        <!-- ֤����Ч���ڣ�yyyymmdd�� -->
        <IDTypeStartDate>
            <xsl:value-of select="IDStartDate" />
        </IDTypeStartDate>
        <!-- ֤����Чֹ�ڣ�yyyymmdd�� -->
        <xsl:if test="IDEndDate='99999999'"><IDTypeEndDate>9999-12-31</IDTypeEndDate></xsl:if>        
        <xsl:if test="IDEndDate!='99999999'"><IDTypeEndDate><xsl:value-of select="IDEndDate" /></IDTypeEndDate></xsl:if>
        <!-- ְҵ���� -->
        <JobCode>
            <xsl:value-of select="JobCode" />
        </JobCode>
        <!-- ���� -->
        <Nationality>
            <xsl:call-template name="tran_Nationality">
				<xsl:with-param name="Nationality" select="Nationality" />
				<xsl:with-param name="IDType" select="IDType" />
		    </xsl:call-template>
            <!-- <xsl:apply-templates select="Nationality" /> -->
        </Nationality>
        <!-- ��ߣ�cm�� -->
        <Stature></Stature>
        <!-- ���أ�kg�� -->
        <Weight></Weight>
        <!-- ��� -->
        <MaritalStatus>
            <xsl:value-of select="Marriage" />
        </MaritalStatus>
        <!-- ��ַ -->
        <Address>
            <xsl:value-of select="HomeAddr" />
        </Address>
        <!-- �ʱ� -->
        <ZipCode>
            <xsl:value-of select="HomeZipCode" />
        </ZipCode>
        <!-- �ֻ� -->
        <Mobile>
            <xsl:value-of select="MobilePhone" />
        </Mobile>
        <!-- ���� -->
        <Phone>
            <xsl:value-of select="HomePhone" />
        </Phone>
        <!-- ���� -->
        <Email>
            <xsl:value-of select="Email" />
        </Email>
    </xsl:template>

    <!-- ��������Ϣ -->
    <xsl:template match="Bnfs">
       <xsl:for-each select="Bnf">
        <Bnf>
            <Type>1</Type>
            <!-- ����˳�� (��������1��ʼ) -->
            <Grade>
                <xsl:value-of select="Order" />
            </Grade>
            <!-- ���� -->
            <Name>
                <xsl:value-of select="Name" />
            </Name>
            <!-- �Ա� -->
            <Sex>
                <xsl:apply-templates select="Sex" />
            </Sex>
            <!-- ��������(yyyyMMdd) -->
            <Birthday>
                <xsl:value-of select="Birthday" />
            </Birthday>
            <!-- ֤������ -->
            <IDType>
                <xsl:apply-templates select="IDType" />
            </IDType>
            <!-- ֤������ -->
            <IDNo>
                <xsl:value-of select="IDNo" />
            </IDNo>
            <!-- ֤����Ч���ڣ�yyyymmdd�� -->
            <IDTypeStartDate>
                <xsl:value-of select="IDStartDate" />
            </IDTypeStartDate>
            <!-- ֤����Чֹ�ڣ�yyyymmdd�����д�ֵΪ99999999����Ҫȷ�Ϻ���������ЧĬ��ֵΪʲô�� -->
            <xsl:if test="IDEndDate='99999999'"><IDTypeEndDate>9999-12-31</IDTypeEndDate></xsl:if>        
            <xsl:if test="IDEndDate!='99999999'"><IDTypeEndDate><xsl:value-of select="IDEndDate" /></IDTypeEndDate></xsl:if>
            <!-- �������뱻�����˹�ϵ -->
            <RelaToInsured>
                <xsl:apply-templates select="RelationToInsured" />
            </RelaToInsured>
            <!-- ��������������� -->
            <Lot>
                <xsl:value-of select="Percent" />
            </Lot>
        </Bnf>
       </xsl:for-each>
    </xsl:template>

    <!-- ������Ϣ -->
    <xsl:template match="Risks">
       <xsl:for-each select="Risk[MainSubFlag = '1']">
        <Risk>
            <!-- ���ִ��� -->
            <RiskCode>
                <xsl:call-template name="tran_RiskCode">
                    <xsl:with-param name="Code">
                        <xsl:value-of select="Code" />
                    </xsl:with-param>
                </xsl:call-template>
            </RiskCode>
            <!-- �������ִ��� -->
            <MainRiskCode>
                <xsl:call-template name="tran_RiskCode">
                    <xsl:with-param name="Code">
                        <xsl:value-of select="Code" />
                    </xsl:with-param>
                </xsl:call-template>
            </MainRiskCode>
            <!-- ����(��λΪ��) ����ʱΪ��-->
            <Amnt>
                <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(InsuAmount)" />
            </Amnt>
            <!-- ���շ�(��λΪ��)���������� -->
            <Prem>
                <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Premium)" />
            </Prem>
            <!-- Ͷ����������ʱΪ��- -->
            <Mult>
                <xsl:value-of select="Unit" />
            </Mult>
            <!-- �ɷ���ʽ -->
            <PayMode>A</PayMode>
            <!-- �ɷ�Ƶ�� -->
            <PayIntv>
                <xsl:apply-templates select="../Appendix/PayIntv" />
            </PayIntv>
            <!-- �������������־ -->
            <InsuYearFlag>
                <xsl:apply-templates select="InsuYearFlag" />
            </InsuYearFlag>
            <!-- ������������ ������д��106-->
            <InsuYear>
               <xsl:choose>
				  <xsl:when test="InsuYearFlag = '06'">106</xsl:when>
				  <xsl:otherwise>
					<xsl:value-of select="InsuYear" />
				  </xsl:otherwise>
			   </xsl:choose>
            </InsuYear>
            <!-- �ɷ����������־ -->
            <PayEndYearFlag>
                <xsl:apply-templates select="PayEndYearFlag" />
            </PayEndYearFlag>
            <!-- �ɷ��������� ����д��1000-->
            <PayEndYear>
               <xsl:choose>
				  <xsl:when test="PayEndYearFlag='01'">1000</xsl:when>
				  <xsl:otherwise>
					<xsl:value-of select="PayEndYear" />
				  </xsl:otherwise>
			   </xsl:choose>
            </PayEndYear>
            <!-- ������ȡ��ʽ -->
            <BonusGetMode>
                <xsl:value-of select="../Appendix/BonusGetMode" />
            </BonusGetMode>
            <FullBonusGetMode></FullBonusGetMode>
            <!-- ��ȡ�������ڱ�־ -->
            <GetYearFlag></GetYearFlag> 
            <!-- ��ȡ���� -->
            <GetYear></GetYear>
            <!-- ��ȡ��ʽ -->
            <GetIntv></GetIntv>
            <!-- ��ȡ���б��� -->
            <GetBankCode></GetBankCode>
            <!-- ��ȡ�����˻� -->
            <GetBankAccNo></GetBankAccNo>
            <!-- ��ȡ���л��� -->
            <GetAccName></GetAccName>
            <!-- �Զ��潻��־ -->
            <AutoPayFlag></AutoPayFlag>
        </Risk>
        </xsl:for-each>
    </xsl:template>

    <!-- �ɷѷ�ʽ��Ƶ�Σ� -->
	<xsl:template name="tran_payintv" match="PayIntv">
		<xsl:choose>
			<xsl:when test=".='01'">0</xsl:when><!-- ���� -->
			<xsl:when test=".='02'">12</xsl:when><!-- ��� -->
			<xsl:when test=".='03'">6</xsl:when><!-- ����� -->
			<xsl:when test=".='04'">3</xsl:when><!-- ���� -->
			<xsl:when test=".='05'">1</xsl:when><!-- �½� -->
			<xsl:when test=".='06'">-1</xsl:when><!-- �����ڽ� -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- �Ա� -->
	<xsl:template name="tran_sex" match="Sex">
		<xsl:choose>
			<xsl:when test=".=1">0</xsl:when><!-- �� -->
			<xsl:when test=".=0">1</xsl:when><!-- Ů -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ֤������-->
	<xsl:template name="tran_idtype" match="IDType">
		<xsl:choose>
			<xsl:when test=".=01">0</xsl:when><!-- �������֤ -->
			<xsl:when test=".=02">0</xsl:when><!-- ��ʱ���֤ -->
			<xsl:when test=".=03">1</xsl:when><!-- ���� -->
			<xsl:when test=".=04">5</xsl:when><!-- ���ڲ� -->
			<xsl:when test=".=05">2</xsl:when><!-- �������֤ -->
			<xsl:when test=".=06">2</xsl:when><!-- ��װ�������֤  -->
			<xsl:when test=".=08">8</xsl:when><!-- �⽻��Ա���֤ -->
			<xsl:when test=".=09">8</xsl:when><!-- ����˾������֤-->
			<xsl:when test=".=10">8</xsl:when><!-- ������뾳ͨ��֤�� -->
			<xsl:when test=".=11">8</xsl:when><!-- ���� -->
			<xsl:when test=".=47">6</xsl:when><!-- �۰ľ��������ڵ�ͨ��֤����ۣ� -->
			<xsl:when test=".=48">6</xsl:when><!-- �۰ľ��������ڵ�ͨ��֤�����ţ� -->
			<xsl:when test=".=49">7</xsl:when><!-- ̨�����������½ͨ��֤ -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- �����˹�ϵ��ӳ��-->
	<xsl:template name="tran_Relation_Insured" match="RelaToInsured">
		<xsl:choose>
			<xsl:when test=".=01">00</xsl:when><!-- ����=���� -->
			<xsl:when test=".=02">02</xsl:when><!-- �ɷ�=��ż -->
			<xsl:when test=".=03">02</xsl:when><!-- ����=��ż -->
			<xsl:when test=".=04">01</xsl:when><!-- ����=��ĸ -->
			<xsl:when test=".=05">01</xsl:when><!-- ĸ��=��ĸ -->
			<xsl:when test=".=06">03</xsl:when><!-- ����=��Ů  -->
			<xsl:when test=".=07">03</xsl:when><!-- Ů��=��Ů -->
			<xsl:when test=".=08">04</xsl:when><!-- �游=����-->
			<xsl:when test=".=09">04</xsl:when><!-- ��ĸ=����-->
			<xsl:when test=".=10">04</xsl:when><!-- ����=����-->
			<xsl:when test=".=11">04</xsl:when><!-- ��Ů=����-->
			<xsl:when test=".=12">04</xsl:when><!-- ���游=����-->
			<xsl:when test=".=13">04</xsl:when><!-- ����ĸ=����-->
			<xsl:when test=".=14">04</xsl:when><!-- ����=����-->
			<xsl:when test=".=15">04</xsl:when><!-- ����Ů=����-->
			<xsl:when test=".=16">04</xsl:when><!-- ���=����-->
			<xsl:when test=".=17">04</xsl:when><!-- ���=����-->
			<xsl:when test=".=18">04</xsl:when><!-- �ܵ�=����-->
			<xsl:when test=".=19">04</xsl:when><!-- ����=����-->
			<xsl:when test=".=99">04</xsl:when><!-- ����=����-->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- �����˹�ϵ��ӳ��-->
	<xsl:template name="tran_Relation_Bef" match="RelationToInsured">
		<xsl:choose>
			<xsl:when test=".=01">00</xsl:when><!-- ����=���� -->
			<xsl:when test=".=02">02</xsl:when><!-- �ɷ�=��ż -->
			<xsl:when test=".=03">02</xsl:when><!-- ����=��ż -->
			<xsl:when test=".=04">01</xsl:when><!-- ����=��ĸ -->
			<xsl:when test=".=05">01</xsl:when><!-- ĸ��=��ĸ -->
			<xsl:when test=".=06">03</xsl:when><!-- ����=��Ů  -->
			<xsl:when test=".=07">03</xsl:when><!-- Ů��=��Ů -->
			<xsl:when test=".=08">04</xsl:when><!-- �游=����-->
			<xsl:when test=".=09">04</xsl:when><!-- ��ĸ=����-->
			<xsl:when test=".=10">04</xsl:when><!-- ����=����-->
			<xsl:when test=".=11">04</xsl:when><!-- ��Ů=����-->
			<xsl:when test=".=12">04</xsl:when><!-- ���游=����-->
			<xsl:when test=".=13">04</xsl:when><!-- ����ĸ=����-->
			<xsl:when test=".=14">04</xsl:when><!-- ����=����-->
			<xsl:when test=".=15">04</xsl:when><!-- ����Ů=����-->
			<xsl:when test=".=16">04</xsl:when><!-- ���=����-->
			<xsl:when test=".=17">04</xsl:when><!-- ���=����-->
			<xsl:when test=".=18">04</xsl:when><!-- �ܵ�=����-->
			<xsl:when test=".=19">04</xsl:when><!-- ����=����-->
			<xsl:when test=".=99">04</xsl:when><!-- ����=����-->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- �ɷ������������� -->
	<xsl:template name="tran_payendyearflag" match="PayEndYearFlag">
		<xsl:choose>
		    <xsl:when test=".='08'">A</xsl:when><!-- ���� -->
			<xsl:when test=".='07'">A</xsl:when><!-- ����ĳȷ������ -->
			<xsl:when test=".='05'">M</xsl:when><!-- �½� -->
			<xsl:when test=".='06'">D</xsl:when><!-- �ս� -->
			<xsl:when test=".='02'">Y</xsl:when><!-- ��� -->
			<xsl:when test=".='01'">Y</xsl:when><!-- ���� -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ���������������� -->
	<xsl:template name="tran_insuyearflag" match="InsuYearFlag">
		<xsl:choose>
			<xsl:when test=".='05'">A</xsl:when><!-- ����ĳȷ������ -->
			<xsl:when test=".='03'">M</xsl:when><!-- �±� -->
			<xsl:when test=".='04'">D</xsl:when><!-- �ձ� -->
			<xsl:when test=".='01'">Y</xsl:when><!-- �걣 -->
			<xsl:when test=".='06'">A</xsl:when><!-- ������ -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- �������ͷ�ʽ -->
	<xsl:template name="tran_getPolMode" match="SendMethod">
		<xsl:choose>
			<xsl:when test=".=1">2</xsl:when><!-- ������ȡ -->
			<xsl:when test=".=2">1</xsl:when><!-- �ʼĻ�ר�� -->
			<xsl:otherwise>1</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ����ת�� -->
	<xsl:template name="tran_Nationality">
	    <xsl:param name="Nationality" />
	    <xsl:param name="IDType" />
		<xsl:choose>
		    <xsl:when test="$Nationality='' and $IDType='01'">CHN</xsl:when>	<!-- �й� -->
		    <xsl:when test="$Nationality='' and $IDType='02'">CHN</xsl:when>	<!-- �й� -->
		    <xsl:when test="$Nationality='' and $IDType='04'">CHN</xsl:when>	<!-- �й� -->
		    <xsl:when test="$Nationality='' and $IDType='05'">CHN</xsl:when>	<!-- �й� -->
		    <xsl:when test="$Nationality='' and $IDType='06'">CHN</xsl:when>	<!-- �й� -->
		    <xsl:when test="$Nationality='ZZ' and $IDType='01'">CHN</xsl:when>	<!-- �й� -->
		    <xsl:when test="$Nationality='ZZ' and $IDType='02'">CHN</xsl:when>	<!-- �й� -->
		    <xsl:when test="$Nationality='ZZ' and $IDType='04'">CHN</xsl:when>	<!-- �й� -->
		    <xsl:when test="$Nationality='ZZ' and $IDType='05'">CHN</xsl:when>	<!-- �й� -->
		    <xsl:when test="$Nationality='ZZ' and $IDType='06'">CHN</xsl:when>	<!-- �й� -->
			<xsl:when test="$Nationality='AD'">AD</xsl:when><!--	������   -->       
			<xsl:when test="$Nationality='AE'">AE</xsl:when><!--	������   -->       
			<xsl:when test="$Nationality='AF'">AF</xsl:when><!--	������   -->       
			<xsl:when test="$Nationality='AG'">AG</xsl:when><!--	����ϺͰͲ���-->  
			<xsl:when test="$Nationality='AI'">AI</xsl:when><!--	������      -->    
			<xsl:when test="$Nationality='AL'">AL</xsl:when><!--	����������  -->    
			<xsl:when test="$Nationality='AM'">AM</xsl:when><!--	��������    -->    
			<xsl:when test="$Nationality='AN'">AN</xsl:when><!--	����������˹-->    
			<xsl:when test="$Nationality='AO'">AO</xsl:when><!--	������      -->    
			<xsl:when test="$Nationality='AQ'">OTH</xsl:when><!--����        -->    
			<xsl:when test="$Nationality='AR'">AR</xsl:when><!--	����͢      -->    
			<xsl:when test="$Nationality='AS'">AS</xsl:when><!--	 ����Ħ��   -->    
			<xsl:when test="$Nationality='AT'">AT</xsl:when><!--	�µ���      -->    
			<xsl:when test="$Nationality='AU'">AU</xsl:when><!--	�Ĵ�����    -->    
			<xsl:when test="$Nationality='AW'">AW</xsl:when><!--	��³�ͣ��ɣ�-->    
			<xsl:when test="$Nationality='AX'">OTH</xsl:when><!--����        -->    
			<xsl:when test="$Nationality='AZ'">AZ</xsl:when><!--	�����ݽ�     -->   
			<xsl:when test="$Nationality='BA'">BA</xsl:when><!--	��˹���ǣ�������ά-->
			<xsl:when test="$Nationality='BB'">BB</xsl:when><!--	�ͰͶ�˹    -->    
			<xsl:when test="$Nationality='BD'">BD</xsl:when><!--	�ϼ�����    -->    
			<xsl:when test="$Nationality='BE'">BE</xsl:when><!--	����ʱ      -->    
			<xsl:when test="$Nationality='BF'">BF</xsl:when><!--	�����ɷ���  -->    
			<xsl:when test="$Nationality='BG'">BG</xsl:when><!--	��������    -->    
			<xsl:when test="$Nationality='BH'">BH</xsl:when><!--	����        -->    
			<xsl:when test="$Nationality='BI'">BI</xsl:when><!-- ��¡��      -->    
			<xsl:when test="$Nationality='BJ'">BJ</xsl:when><!-- ����        -->    
			<xsl:when test="$Nationality='BM'">BM</xsl:when><!-- ��Ľ��      -->    
			<xsl:when test="$Nationality='BN'">BN</xsl:when><!--   ����      -->    
			<xsl:when test="$Nationality='BO'">BO</xsl:when> <!--	����ά��  -->    
			<xsl:when test="$Nationality='BR'">BR</xsl:when> <!--	����      -->    
			<xsl:when test="$Nationality='BS'">BS</xsl:when> <!--	�͹���     -->   
			<xsl:when test="$Nationality='BT'">BT</xsl:when> <!--	 ����      -->   
			<xsl:when test="$Nationality='BV'">OTH</xsl:when><!--	����       -->   
			<xsl:when test="$Nationality='BW'">BW</xsl:when> <!--	��������   -->   
			<xsl:when test="$Nationality='BY'">BY</xsl:when> <!--	�׶���˹   -->   
			<xsl:when test="$Nationality='BZ'">BZ</xsl:when> <!--	������     -->   
			<xsl:when test="$Nationality='CA'">CA</xsl:when> <!-- ���ô�     -->    
			<xsl:when test="$Nationality='CC'">OTH</xsl:when><!-- ����       -->    
			<xsl:when test="$Nationality='CD'">CG</xsl:when> <!-- �չ����� -->    
			<xsl:when test="$Nationality='CF'">CF</xsl:when> <!-- �з�       -->    
			<xsl:when test="$Nationality='CG'">ZR</xsl:when> <!--	�չ������� -->   
			<xsl:when test="$Nationality='CH'">CH</xsl:when> <!--	��ʿ      -->    
			<xsl:when test="$Nationality='CI'">CI</xsl:when> <!--	 ���ص��� -->    
			<xsl:when test="$Nationality='CK'">CK</xsl:when> <!--	���Ⱥ��  -->    
			<xsl:when test="$Nationality='CL'">CL</xsl:when> <!--	����      -->    
			<xsl:when test="$Nationality='CM'">CM</xsl:when> <!--	����¡    -->    
			<xsl:when test="$Nationality='CN'">CHN</xsl:when><!--	�й�      -->    
			<xsl:when test="$Nationality='CO'">CO</xsl:when> <!--	���ױ���  -->    
			<xsl:when test="$Nationality='CR'">CR</xsl:when> <!-- ��˹����� -->    
			<xsl:when test="$Nationality='CU'">CU</xsl:when> <!-- �Ű�       -->    
			<xsl:when test="$Nationality='CW'">OTH</xsl:when><!-- ����       -->    
			<xsl:when test="$Nationality='CV'">CV</xsl:when> <!-- ��ý�     -->    
			<xsl:when test="$Nationality='CX'">OTH</xsl:when><!-- ����      -->     
			<xsl:when test="$Nationality='CY'">CY</xsl:when> <!-- ����·˹  -->     
			<xsl:when test="$Nationality='CZ'">CZ</xsl:when> <!-- �ݿ�     -->      
			<xsl:when test="$Nationality='DE'">DE</xsl:when> <!-- �¹�     -->      
			<xsl:when test="$Nationality='DJ'">DJ</xsl:when> <!-- ������   -->      
			<xsl:when test="$Nationality='DK'">DK</xsl:when> <!-- ����     -->      
			<xsl:when test="$Nationality='DM'">DM</xsl:when> <!-- ������� -->      
			<xsl:when test="$Nationality='DO'">DO</xsl:when> <!-- ������� -->      
			<xsl:when test="$Nationality='DZ'">DZ</xsl:when> <!-- ���������� -->    
			<xsl:when test="$Nationality='EC'">EC</xsl:when> <!-- ��϶��   -->    
			<xsl:when test="$Nationality='EE'">EE</xsl:when> <!-- ��ɳ����   -->    
			<xsl:when test="$Nationality='EG'">EG</xsl:when> <!-- ����       -->    
			<xsl:when test="$Nationality='EH'">OTH</xsl:when><!-- ����        -->   
			<xsl:when test="$Nationality='ER'">ER</xsl:when> <!-- ����������  -->   
			<xsl:when test="$Nationality='ES'">ES</xsl:when> <!-- ������    -->     
			<xsl:when test="$Nationality='ET'">ET</xsl:when> <!-- ���������-->     
			<xsl:when test="$Nationality='FI'">FI</xsl:when> <!-- ����      -->     
			<xsl:when test="$Nationality='FJ'">FJ</xsl:when> <!-- 쳼�      -->     
			<xsl:when test="$Nationality='FK'">OTH</xsl:when><!-- ����      -->     
			<xsl:when test="$Nationality='FM'">OTH</xsl:when><!-- ����         -->  
			<xsl:when test="$Nationality='FO'">FO</xsl:when><!-- ����Ⱥ��������-->  
			<xsl:when test="$Nationality='FR'">FR</xsl:when><!-- ����  -->          
			<xsl:when test="$Nationality='GA'">GA</xsl:when><!-- ����  -->          
			<xsl:when test="$Nationality='GB'">GB</xsl:when> <!-- Ӣ��  -->         
			<xsl:when test="$Nationality='GD'">GD</xsl:when> <!--	�����ɴ�  -->    
			<xsl:when test="$Nationality='GE'">GE</xsl:when> <!--	��³����   -->   
			<xsl:when test="$Nationality='GF'">GF</xsl:when> <!--	����������  -->  
			<xsl:when test="$Nationality='GG'">OTH</xsl:when><!--	����        -->  
			<xsl:when test="$Nationality='GH'">GH</xsl:when> <!--	����        -->  
			<xsl:when test="$Nationality='GI'">GI</xsl:when> <!--	ֱ������    -->  
			<xsl:when test="$Nationality='GL'">GL</xsl:when> <!--	������      -->  
			<xsl:when test="$Nationality='GM'">GM</xsl:when> <!--	�Ա���      -->  
			<xsl:when test="$Nationality='GN'">GN</xsl:when> <!-- ������     -->    
			<xsl:when test="$Nationality='GP'">GP</xsl:when> <!-- �ϵ�����   -->    
			<xsl:when test="$Nationality='GQ'">GQ</xsl:when> <!-- ��������� -->    
			<xsl:when test="$Nationality='GR'">GR</xsl:when> <!-- ϣ��       -->    
			<xsl:when test="$Nationality='GS'">OTH</xsl:when> <!-- ����       -->   
			<xsl:when test="$Nationality='GT'">GT</xsl:when> <!--	Σ������   -->   
			<xsl:when test="$Nationality='GU'">GU</xsl:when> <!--	�ص������� -->   
			<xsl:when test="$Nationality='GW'">GW</xsl:when> <!--	�����Ǳ��� -->   
			<xsl:when test="$Nationality='GY'">GY</xsl:when> <!--	������     -->   
			<xsl:when test="$Nationality='HK'">CHN</xsl:when> <!--	:�й�      -->   
			<xsl:when test="$Nationality='HM'">OTH</xsl:when> <!--	:����     -->    
			<xsl:when test="$Nationality='HN'">HN</xsl:when> <!--	�鶼��˹  -->    
			<xsl:when test="$Nationality='HR'">HR</xsl:when> <!-- ���޵���   -->    
			<xsl:when test="$Nationality='HT'">HT</xsl:when> <!-- ����       -->    
			<xsl:when test="$Nationality='HU'">HU</xsl:when> <!-- ������     -->    
			<xsl:when test="$Nationality='ID'">ID</xsl:when> <!-- ӡ�������� -->    
			<xsl:when test="$Nationality='IE'">IE</xsl:when> <!--	������    -->    
			<xsl:when test="$Nationality='IL'">IL</xsl:when> <!--	��ɫ��    -->    
			<xsl:when test="$Nationality='IM'">OTH</xsl:when> <!--	����      -->    
			<xsl:when test="$Nationality='IN'">IN</xsl:when> <!--	ӡ��      -->    
			<xsl:when test="$Nationality='IO'">OTH</xsl:when> <!--	����      -->    
			<xsl:when test="$Nationality='IQ'">IQ</xsl:when> <!--	������    -->    
			<xsl:when test="$Nationality='IR'">IR</xsl:when> <!--	����      -->    
			<xsl:when test="$Nationality='IS'">IS</xsl:when> <!--	����      -->    
			<xsl:when test="$Nationality='IT'">IT</xsl:when> <!-- �����     -->    
			<xsl:when test="$Nationality='JE'">JE</xsl:when> <!-- ������     -->    
			<xsl:when test="$Nationality='JM'">JM</xsl:when> <!-- �����     -->    
			<xsl:when test="$Nationality='JO'">JO</xsl:when> <!-- Լ��       -->    
			<xsl:when test="$Nationality='JP'">JP</xsl:when> <!-- �ձ�       -->    
			<xsl:when test="$Nationality='KE'">KE</xsl:when> <!--	������    -->    
			<xsl:when test="$Nationality='KG'">KG</xsl:when> <!--	������˹  -->    
			<xsl:when test="$Nationality='KH'">KH</xsl:when> <!--	����կ    -->    
			<xsl:when test="$Nationality='KI'">KT</xsl:when> <!--	������˹  -->    
			<xsl:when test="$Nationality='KM'">KM</xsl:when> <!--	��Ħ��    -->    
			<xsl:when test="$Nationality='KN'">SX</xsl:when> <!--	ʥ���ĺ���ά˹ -->
			<xsl:when test="$Nationality='KP'">KP</xsl:when> <!--  ����      -->    
			<xsl:when test="$Nationality='KR'">KR</xsl:when> <!--  ����      -->    
			<xsl:when test="$Nationality='KW'">KW</xsl:when> <!--  ������    -->    
			<xsl:when test="$Nationality='KY'">KY</xsl:when> <!--  ����Ⱥ��  -->    
			<xsl:when test="$Nationality='KZ'">KZ</xsl:when> <!--  ������˹̹  -->  
			<xsl:when test="$Nationality='LA'">LA</xsl:when> <!--  ����       -->   
			<xsl:when test="$Nationality='LB'">LB</xsl:when> <!--  �����     -->   
			<xsl:when test="$Nationality='LC'">SQ</xsl:when> <!--  ʥ¬����   -->   
			<xsl:when test="$Nationality='LI'">LI</xsl:when> <!--  ��֧��ʿ�� -->   
			<xsl:when test="$Nationality='LK'">LK</xsl:when> <!--  ˹������   -->   
			<xsl:when test="$Nationality='LR'">LR</xsl:when> <!--  ��������   -->   
			<xsl:when test="$Nationality='LS'">LS</xsl:when> <!--  ������     -->   
			<xsl:when test="$Nationality='LT'">LT</xsl:when> <!--  ������     -->   
			<xsl:when test="$Nationality='LU'">LU</xsl:when> <!--  ¬ɭ��     -->   
			<xsl:when test="$Nationality='LV'">LV</xsl:when> <!--  ����ά��   -->   
			<xsl:when test="$Nationality='LY'">LY</xsl:when> <!--  ������     -->   
			<xsl:when test="$Nationality='MA'">MA</xsl:when> <!--  Ħ���     -->   
			<xsl:when test="$Nationality='MC'">MC</xsl:when> <!--  Ħ�ɸ�     -->   
			<xsl:when test="$Nationality='MD'">MD</xsl:when> <!--  Ħ������   -->   
			<xsl:when test="$Nationality='ME'">OTH</xsl:when> <!--  ����      -->   
			<xsl:when test="$Nationality='MG'">MG</xsl:when> <!--  ����˹�� -->   
			<xsl:when test="$Nationality='MH'">MH</xsl:when> <!--  ���ܶ�Ⱥ��-->    
			<xsl:when test="$Nationality='MK'">MK</xsl:when> <!--   �����   -->    
			<xsl:when test="$Nationality='ML'">ML</xsl:when> <!--  ����      -->    
			<xsl:when test="$Nationality='MM'">MM</xsl:when> <!--  ���      -->    
			<xsl:when test="$Nationality='MN'">MN</xsl:when> <!--  �ɹ�      -->    
			<xsl:when test="$Nationality='MO'">CHN</xsl:when> <!--  �й�      -->   
			<xsl:when test="$Nationality='MP'">MP</xsl:when> <!--  ����������Ⱥ�� -->
			<xsl:when test="$Nationality='MQ'">MQ</xsl:when> <!--  �������   -->   
			<xsl:when test="$Nationality='MR'">MR</xsl:when> <!--  ë�������� -->   
			<xsl:when test="$Nationality='MS'">MS</xsl:when> <!--  ���������� -->   
			<xsl:when test="$Nationality='MT'">MT</xsl:when> <!--  �����     -->   
			<xsl:when test="$Nationality='MU'">MU</xsl:when> <!--  ë����˹   -->   
			<xsl:when test="$Nationality='MV'">MV</xsl:when> <!--  �������   -->   
			<xsl:when test="$Nationality='MW'">MW</xsl:when> <!--  ����ά     -->   
			<xsl:when test="$Nationality='MX'">MX</xsl:when> <!--  ī����     -->   
			<xsl:when test="$Nationality='MY'">MY</xsl:when> <!--  ��������   -->   
			<xsl:when test="$Nationality='MZ'">MZ</xsl:when> <!--  Īɣ�ȿ�   -->   
			<xsl:when test="$Nationality='NA'">NA</xsl:when> <!--  ���ױ���   -->   
			<xsl:when test="$Nationality='NC'">NC</xsl:when> <!--  �¿��������-->  
			<xsl:when test="$Nationality='NE'">NE</xsl:when> <!--  ���ն�   -->     
			<xsl:when test="$Nationality='NF'">NF</xsl:when> <!--  ŵ���˵� -->     
			<xsl:when test="$Nationality='NG'">NG</xsl:when> <!--  �������� -->     
			<xsl:when test="$Nationality='NI'">NI</xsl:when> <!--  ������� -->     
			<xsl:when test="$Nationality='NL'">NL</xsl:when> <!--  ����     -->     
			<xsl:when test="$Nationality='NO'">NO</xsl:when> <!--  Ų��     -->     
			<xsl:when test="$Nationality='NP'">NP</xsl:when> <!--  �Ჴ��   -->     
			<xsl:when test="$Nationality='NR'">NR</xsl:when> <!--  �³     -->     
			<xsl:when test="$Nationality='NU'">NU</xsl:when> <!--  Ŧ��     -->     
			<xsl:when test="$Nationality='NZ'">NZ</xsl:when> <!--  ������   -->     
			<xsl:when test="$Nationality='OM'">OM</xsl:when> <!--  ����     -->     
			<xsl:when test="$Nationality='PA'">PA</xsl:when> <!--  ������   -->     
			<xsl:when test="$Nationality='PE'">PE</xsl:when> <!--  ��³     -->     
			<xsl:when test="$Nationality='PF'">PF</xsl:when> <!--  �������������� -->
			<xsl:when test="$Nationality='PG'">PG</xsl:when> <!--  �Ͳ����¼����� -->
			<xsl:when test="$Nationality='PH'">PH</xsl:when> <!--  ���ɱ�      -->  
			<xsl:when test="$Nationality='PK'">PK</xsl:when> <!--  �ͻ�˹̹    -->  
			<xsl:when test="$Nationality='PL'">PL</xsl:when> <!--  ����        -->  
			<xsl:when test="$Nationality='PM'">OTH</xsl:when> <!--  ����       -->  
			<xsl:when test="$Nationality='PN'">OTH</xsl:when> <!--  Ƥ�ؿ�       -->
			<xsl:when test="$Nationality='PR'">PR</xsl:when> <!--  �������    -->  
			<xsl:when test="$Nationality='PS'">OTH</xsl:when> <!--  ����       -->  
			<xsl:when test="$Nationality='PT'">PT</xsl:when> <!--  ������      -->  
			<xsl:when test="$Nationality='PW'">PW</xsl:when> <!--  ����        -->  
			<xsl:when test="$Nationality='PY'">PY</xsl:when> <!--  ������      -->  
			<xsl:when test="$Nationality='QA'">QA</xsl:when> <!--  ������      -->  
			<xsl:when test="$Nationality='RE'">RE</xsl:when> <!--  ������������-->  
			<xsl:when test="$Nationality='RO'">RO</xsl:when> <!--  ��������    -->  
			<xsl:when test="$Nationality='RS'">OTH</xsl:when> <!--  ����       -->  
			<xsl:when test="$Nationality='RU'">RU</xsl:when> <!--  ����˹      -->  
			<xsl:when test="$Nationality='RW'">RW</xsl:when> <!--  ¬����      -->  
			<xsl:when test="$Nationality='SA'">SA</xsl:when> <!--  ɳ�ذ����� -->   
			<xsl:when test="$Nationality='SB'">SB</xsl:when> <!--  ������Ⱥ�� -->   
			<xsl:when test="$Nationality='SC'">SC</xsl:when> <!--  �����     -->   
			<xsl:when test="$Nationality='SD'">SD</xsl:when> <!--  �յ�       -->   
			<xsl:when test="$Nationality='SE'">SE</xsl:when> <!--  ���       -->   
			<xsl:when test="$Nationality='SG'">SG</xsl:when> <!--  �¼���     -->   
			<xsl:when test="$Nationality='SH'">OTH</xsl:when> <!--  ����      -->   
			<xsl:when test="$Nationality='SI'">SI</xsl:when> <!--  ˹�������� -->   
			<xsl:when test="$Nationality='SJ'">OTH</xsl:when> <!--  ����      -->   
			<xsl:when test="$Nationality='SK'">SK</xsl:when> <!--  ˹�工��   -->   
			<xsl:when test="$Nationality='SL'">SL</xsl:when> <!--  ��������   -->   
			<xsl:when test="$Nationality='SM'">SM</xsl:when> <!--  ʥ����ŵ   -->   
			<xsl:when test="$Nationality='SN'">SN</xsl:when> <!--  ���ڼӶ�   -->   
			<xsl:when test="$Nationality='SO'">SO</xsl:when> <!--  ������     -->   
			<xsl:when test="$Nationality='SR'">SR</xsl:when> <!--  ������           -->
			<xsl:when test="$Nationality='ST'">ST</xsl:when> <!--  ʥ�������������� -->
			<xsl:when test="$Nationality='SV'">SV</xsl:when> <!--  �����߶�         -->
			<xsl:when test="$Nationality='SY'">SY</xsl:when> <!--  ������           -->
			<xsl:when test="$Nationality='SZ'">SZ</xsl:when> <!--  ˹��ʿ��         -->
			<xsl:when test="$Nationality='TC'">TC</xsl:when> <!--  �ؿ�˹�Ϳ���˹Ⱥ-->
			<xsl:when test="$Nationality='TD'">TD</xsl:when> <!--  է��          -->
			<xsl:when test="$Nationality='TF'">OTH</xsl:when> <!--  ����         -->
			<xsl:when test="$Nationality='TG'">TG</xsl:when> <!--  ���          -->
			<xsl:when test="$Nationality='TH'">TH</xsl:when> <!--  ̩��          -->
			<xsl:when test="$Nationality='TJ'">TJ</xsl:when> <!--  ������˹̹    -->
			<xsl:when test="$Nationality='TK'">OTH</xsl:when> <!--  ����         -->
			<xsl:when test="$Nationality='TL'">OTH</xsl:when> <!--  ����         -->
			<xsl:when test="$Nationality='TM'">TM</xsl:when> <!--  ������˹̹    -->
			<xsl:when test="$Nationality='TN'">TN</xsl:when> <!--  ͻ��˹        -->
			<xsl:when test="$Nationality='TO'">TO</xsl:when> <!--  ����          -->
			<xsl:when test="$Nationality='TR'">TR</xsl:when> <!--  ������        -->
			<xsl:when test="$Nationality='TT'">TT</xsl:when> <!--  �������Ͷ�͸�--> 
			<xsl:when test="$Nationality='TV'">TV</xsl:when> <!--  ͼ��¬       --> 
			<xsl:when test="$Nationality='TW'">CHN</xsl:when> <!--  �й�        --> 
			<xsl:when test="$Nationality='TZ'">TZ</xsl:when> <!--  ̹ɣ����     --> 
			<xsl:when test="$Nationality='UA'">UA</xsl:when> <!--  �ڿ���       --> 
			<xsl:when test="$Nationality='UG'">UG</xsl:when> <!--  �ڸɴ�       --> 
			<xsl:when test="$Nationality='UM'">OTH</xsl:when> <!--  ����        --> 
			<xsl:when test="$Nationality='US'">US</xsl:when> <!--  ����         --> 
			<xsl:when test="$Nationality='UY'">UY</xsl:when> <!--  ������       --> 
			<xsl:when test="$Nationality='UZ'">UZ</xsl:when> <!--  ���ȱ��˹̹ --> 
			<xsl:when test="$Nationality='VA'">OTH</xsl:when> <!--  ����        --> 
			<xsl:when test="$Nationality='VC'">VC</xsl:when> <!--   ʥ��˹��    --> 
			<xsl:when test="$Nationality='VE'">VE</xsl:when> <!--  ί������        -->
			<xsl:when test="$Nationality='VG'">VG</xsl:when> <!--  Ӣ��ά����Ⱥ��  -->
			<xsl:when test="$Nationality='VI'">VI</xsl:when> <!--  ����ά����Ⱥ��  -->
			<xsl:when test="$Nationality='VN'">VN</xsl:when> <!--  Խ��       -->   
			<xsl:when test="$Nationality='VU'">VU</xsl:when> <!--  ��Ŭ��ͼ   -->   
			<xsl:when test="$Nationality='WF'">OTH</xsl:when> <!--  ����      -->   
			<xsl:when test="$Nationality='WS'">WS</xsl:when> <!--  ��Ħ��     -->   
			<xsl:when test="$Nationality='YE'">YE</xsl:when> <!--  Ҳ��       -->   
			<xsl:when test="$Nationality='YT'">YT</xsl:when> <!--  ��Լ��     -->   
			<xsl:when test="$Nationality='YU'">YU</xsl:when> <!--  ��˹����   -->   
			<xsl:when test="$Nationality='ZA'">ZA</xsl:when> <!--  �Ϸ�       -->   
			<xsl:when test="$Nationality='ZM'">ZM</xsl:when> <!--  �ޱ���     -->   
			<xsl:when test="$Nationality='ZW'">ZW</xsl:when> <!--  ��Ͳ�Τ   -->   
			<xsl:when test="$Nationality='ZZ'">OTH</xsl:when> <!--  ����      -->   
			<xsl:when test="$Nationality='01'">BG</xsl:when> <!--  ��������   -->   
			<xsl:when test="$Nationality='02'">BO</xsl:when> <!--  ����ά��   -->   
			<xsl:when test="$Nationality='03'">MX</xsl:when> <!--  ī����     -->   
			<xsl:when test="$Nationality='05'">CL</xsl:when> <!--  ����       -->   
			<xsl:when test="$Nationality='06'">GW</xsl:when> <!--  �����Ǳ��� -->   
			<xsl:when test="$Nationality='10'">OTH</xsl:when> <!--  ����      -->   
			<xsl:otherwise>OTH</xsl:otherwise><!--	����          -->
		</xsl:choose>
	</xsl:template>
	
	<!-- ����״̬�� -->
	
	<!-- ������ȡ��ʽ�� -->
	<xsl:template name="tran_bonusgetmode" match="BonusGetMode">
		<xsl:choose>
			<xsl:when test=".='1'">1</xsl:when><!-- �ۼ���Ϣ -->
			<xsl:when test=".='2'">4</xsl:when><!-- �ֽ���ȡ -->
			<xsl:when test=".='3'">3</xsl:when><!-- �ֽɱ��� -->
			<xsl:when test=".='4'">5</xsl:when><!-- ����� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
    <!-- �Զ��潻��־ ?-->
	<xsl:template name="tran_autoPayFlag" match="AutoPayFlag">
		<xsl:choose>
			<xsl:when test=".='1'">1</xsl:when><!-- ���潻 -->
			<xsl:when test=".='2'">2</xsl:when><!-- �Զ��潻 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

    <!-- ������Դ -->
	<xsl:template name="tran_livezone" match="ResiType">
		<xsl:choose>
			<xsl:when test=".=0">1</xsl:when><!-- ���� -->
			<xsl:when test=".=1">2</xsl:when><!-- ũ�� -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

    <!-- ��Ʒ��ϴ��� -->
    <xsl:template name="tran_ContPlanCode">
        <xsl:param name="contPlanCode" />
        <xsl:choose>
            <xsl:when test="$contPlanCode='50015'">50015</xsl:when>
            <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- ���ִ��룬���ļ���δʹ��ת����ֻ�Ǽ�¼�����ߵ����� -->
    <xsl:template name="tran_RiskCode">
        <xsl:param name="Code" />
        <xsl:choose>
            <xsl:when test="$Code='L12079'">L12079</xsl:when>      <!-- ����ʢ��2���������գ������ͣ� -->
            <xsl:when test="$Code='L12087'">L12087</xsl:when>      <!-- ����5����ȫ���գ������ͣ� ���� add by jbq -->
            <xsl:when test="$Code='L12085'">L12085</xsl:when>      <!-- ����2����ȫ���գ������ͣ� ���� -->
            <xsl:when test="$Code='50015'">50015</xsl:when>
            
            <xsl:when test="$Code='L12086'">L12086</xsl:when><!--�����3����ȫ���գ������ͣ�-->
            <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
