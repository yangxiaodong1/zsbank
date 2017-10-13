<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
	 <!--yxd ������3�����Բ�֪�������  -->
	 <!-- ����һ���ļ��Ǻ�˭ƥ���  ������ <xsl:value-of select="TranTime" /> ������ȡ��ֵ�������ﶨ���             ���xsl�Ĺ��ܾ���ת�껻��ʽ�Ĺ�����-->
	<xsl:template match="TranData">  <!-- ģ��ƥ����� TranData-->
		<TranData>
			<!-- ����ͷ -->
			<Head>
				<xsl:apply-templates select="Head" /><!-- ƥ���ģ����head -->
            </Head>
			<!-- ������ -->
			<Body>
				<xsl:apply-templates select="Body" /> <!-- ƥ���ģ����body -->
			</Body>
		</TranData>
	</xsl:template>
	
	<xsl:template name="Head" match="Head">
		 <!-- ��������[yyyyMMdd] -->
        <TranDate>
           <xsl:value-of select="TranDate" />
        </TranDate>
        <!-- ����ʱ��[hhmmss] -->
        <TranTime>
           <xsl:value-of select="TranTime" />
        </TranTime>
        <!-- �������루����Ϊ�ղ���ֵ��-->
        <ZoneNo>
           <xsl:value-of select="ZoneNo" />
        </ZoneNo>
        <!-- �������� -->
        <NodeNo>
            <xsl:value-of select="NodeNo" />
        </NodeNo>
        <!-- ��Ա���� -->
        <TellerNo>
            <xsl:value-of select="TellerNo" />
        </TellerNo>
        <!-- ������ˮ�� -->
        <TranNo>
            <xsl:value-of select="TranNo" />
        </TranNo>
        <!-- ����������0-���� 1- ���� 17-�ֻ����� --> 
        <SourceType >
           <xsl:value-of select="SourceType" />
        </SourceType>
        <xsl:copy-of select="FuncFlag" /> <!-- ͷ����û��functFlag ͬ��������3���¸���ģ�����  ���������Щֵ�� -->
        <xsl:copy-of select="ClientIp" />
        <xsl:copy-of select="TranCom" />
        <BankCode>
            <xsl:value-of select="TranCom/@outcode" /> <!-- ��ȡ���д��룬������ -->
        </BankCode>
        
	</xsl:template>
	
	  <!-- ��������Ϣ -->
    <xsl:template name="Body" match="Body">   <!-- �������ݵ���ʽ -->
        <xsl:variable name="MainRisk"
            select="Risk[RiskCode=MainRiskCode]" /><!-- MainRiskCode���մ��뵫���ڣ����д����ô�ͱ�Ĳ�һ�� -->
        <IsPremCal>
        	<xsl:value-of select="IsPremCal" /><!-- ���������� -->
        </IsPremCal>
        <!-- Ͷ����(ӡˢ)�� -->
        <ProposalPrtNo>
            <xsl:value-of select="ProposalPrtNo" />
        </ProposalPrtNo>
        <!-- ������ͬӡˢ�� -->
        <ContPrtNo>
            <xsl:value-of select="ContPrtNo" />
        </ContPrtNo>
        <!-- Ͷ������[yyyyMMdd] -->
        <PolApplyDate>
            <xsl:value-of select="PolApplyDate" />
        </PolApplyDate>
        <!-- �˻����� -->
        <AccName>
            <xsl:value-of select="AccName" />
        </AccName>
        <!-- �����˻� -->
        <AccNo>
            <xsl:value-of select="AccNo" />
        </AccNo>
        <!-- �������ͷ�ʽ:1=�ʼģ�2=���й�����ȡ -->
        <GetPolMode>
        	<xsl:value-of select="GetPolMode" />
        </GetPolMode>
        <!-- ְҵ��֪(N/Y) -->
        <JobNotice>
            <xsl:value-of select="JobNotice" />
        </JobNotice>
        <!-- ������֪(N/Y)  -->
        <HealthNotice>
            <xsl:choose>
                <xsl:when test="HealthNotice='N'">N</xsl:when>
                <xsl:otherwise>Y</xsl:otherwise>
            </xsl:choose>
        </HealthNotice>
		<!--δ���걻�������Ƿ����������չ�˾Ͷ����ʱ��� Y��/N��-->
        <PolicyIndicator>
            <xsl:choose>
                <xsl:when test="InsuredTotalFaceAmount > 0">Y</xsl:when>
                <xsl:otherwise>N</xsl:otherwise>
            </xsl:choose>
        </PolicyIndicator>
        <!--�ۼ�Ͷ����ʱ���(���ĵ�λ��Ԫ)-->
        <InsuredTotalFaceAmount>
        	 <xsl:value-of select="InsuredTotalFaceAmount" />
        </InsuredTotalFaceAmount>
        <!--������������-->
        <AgentComName>
            <xsl:value-of select="AgentComName" />
        </AgentComName>
        <!-- �������֤-->
        <AgentComCertiCode>
            <xsl:value-of select="AgentComCertiCode" />
        </AgentComCertiCode>
        <!-- ������Ա���-->
   		<SellerNo>
   			<xsl:value-of select="SellerNo" />
   		</SellerNo>
        <!--����������Ա����-->
        <TellerName>
            <xsl:value-of select="TellerName" />
        </TellerName>
        <!-- ������Ա�ʸ�֤-->
        <TellerCertiCode>
            <xsl:value-of select="TellerCertiCode" />
        </TellerCertiCode>
        <!-- ������Ա��������-->
        <TellerEmail>
            <xsl:value-of select="TellerEmail" />
        </TellerEmail>
        <!-- Ͷ���� -->
        <Appnt>
            <xsl:apply-templates select="Appnt" />
        </Appnt>
        <!-- ������ -->
        <Insured>
            <xsl:apply-templates select="Insured" />
        </Insured>
        <!-- ������ -->
        <xsl:apply-templates select="Bnf" />

        <!-- ������Ϣ -->
        <xsl:apply-templates select="Risk" />
    </xsl:template>
    
    <!-- Ͷ������Ϣ -->
    <xsl:template name="Appnt" match="Appnt">
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
            <xsl:value-of select="IDType" />
        </IDType>
        <!-- ֤������ -->
        <IDNo>
            <xsl:value-of select="IDNo" />
        </IDNo>
        <!-- ֤����Ч���ڣ�yyyymmdd�� -->
        <IDTypeStartDate>
            <xsl:value-of select="IDTypeStartDate" />
        </IDTypeStartDate>
        <!-- ֤����Чֹ�ڣ�yyyymmdd�� -->
        <IDTypeEndDate>
            <xsl:value-of select="IDTypeEndDate" />
        </IDTypeEndDate>
        <!-- ְҵ���� -->
        <JobCode>
            <xsl:value-of select="JobCode" />
        </JobCode>
        <!-- ���� -->
        <Nationality>
            <xsl:value-of select="Nationality" />
        </Nationality>
        <!-- ���(cm)-->
        <Stature>
            <xsl:value-of select="Stature" />
        </Stature>
        <!-- ����(g)  -->
        <Weight>
            <xsl:value-of select="Weight" />
        </Weight>
        <!-- Ͷ����������(��) -->
        <Salary>
            <xsl:value-of select="Salary" />
        </Salary>
        <!-- Ͷ���˼�ͥ������(��) -->
        <FamilySalary>
            <xsl:value-of select="FamilySalary" />
        </FamilySalary>
        <!-- 1.����2.ũ�� -->
        <LiveZone>
            <xsl:value-of select="LiveZone" />
        </LiveZone>
        <!-- �Ƿ��Ͷ���˽���������������ճ��������������ҷ������Ĳ�������ʺ�Ͷ����ǰ���ղ�Ʒ ��1�ǣ�0�� ���Ǳ�����-->
        <EvalRisk>
        	<xsl:value-of select="EvalRisk" />
        </EvalRisk>
        <!-- ����״���������޷�����¼������Ϣ���Ǳ�� -->
        <MaritalStatus>
            <xsl:value-of select="MaritalStatus" />
        </MaritalStatus>
        <!-- ��ַ -->
        <Address>
            <xsl:value-of select="Address" />
        </Address>
        <!-- �ʱ� -->
        <ZipCode>
            <xsl:value-of select="ZipCode" />
        </ZipCode>
        <!-- �ֻ� -->
        <Mobile>
            <xsl:value-of select="Mobile" />
        </Mobile>
        <!-- ���� -->
        <Phone>
            <xsl:value-of select="Phone" />
        </Phone>
        <!-- ���� -->
        <Email>
            <xsl:value-of select="Email" />
        </Email>
        <!-- Ͷ�����뱻���˹�ϵ -->
        <RelaToInsured>
            <xsl:value-of select="RelaToInsured" />
        </RelaToInsured>
        <!--����Ԥ���� ���֣�-->
        <Premiumbudget>
        	<xsl:value-of select="Premiumbudget" />
        </Premiumbudget>
    </xsl:template>


    <!-- ����������Ϣ -->
    <xsl:template name="Insured" match="Insured">
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
            <xsl:value-of select="IDType" />
        </IDType>
        <!-- ֤������ -->
        <IDNo>
            <xsl:value-of select="IDNo" />
        </IDNo>
        <!-- ֤����Ч���ڣ�yyyymmdd�� -->
        <IDTypeStartDate>
            <xsl:value-of select="IDTypeStartDate" />
        </IDTypeStartDate>
        <!-- ֤����Чֹ�ڣ�yyyymmdd�� -->
        <IDTypeEndDate>
            <xsl:value-of select="IDTypeEndDate" />
        </IDTypeEndDate>
        <!-- ְҵ���� -->
        <JobCode>
            <xsl:value-of select="JobCode" />
        </JobCode>
        <!-- ���� -->
        <Nationality>
            <xsl:value-of select="Nationality" />
        </Nationality>
        <!-- ��ߣ�cm�� -->
        <Stature>
            <xsl:value-of select="Stature" />
        </Stature>
        <!-- ���أ�kg�� -->
        <Weight>
            <xsl:value-of select="Weight" />
        </Weight>
        <!-- ��� -->
        <MaritalStatus>
            <xsl:apply-templates select="HY" />
        </MaritalStatus>
        <!-- ��ַ -->
        <Address>
            <xsl:value-of select="Address" />
        </Address>
        <!-- �ʱ� -->
        <ZipCode>
            <xsl:value-of select="ZipCode" />
        </ZipCode>
        <!-- �ֻ� -->
        <Mobile>
            <xsl:value-of select="Mobile" />
        </Mobile>
        <!-- ���� -->
        <Phone>
            <xsl:value-of select="Phone" />
        </Phone>
        <!-- ���� -->
        <Email>
            <xsl:value-of select="Email" />
        </Email>
    </xsl:template>

    <!-- ��������Ϣ -->
    <xsl:template match="Bnf">
        <Bnf>                                                                  <!-- Ϊɶ�������˾�û����� -->
            <Type>1</Type>
            <!-- ����˳�� (��������1��ʼ) -->
            <Grade>
                <xsl:value-of select="Grade" />
            </Grade>
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
                <xsl:value-of select="IDType" />
            </IDType>
            <!-- ֤������ -->
            <IDNo>
                <xsl:value-of select="IDNo" />
            </IDNo>
            <!-- ֤����Ч���ڣ�yyyymmdd�� -->
            <IDTypeStartDate>
                <xsl:value-of select="IDTypeStartDate" />
            </IDTypeStartDate>
            <!-- ֤����Чֹ�ڣ�yyyymmdd�� -->
            <IDTypeEndDate>
                <xsl:value-of select="IDTypeEndDate" />
            </IDTypeEndDate>
            <!-- �������뱻�����˹�ϵ -->
            <RelaToInsured>
                <xsl:value-of select="RelaToInsured" />
            </RelaToInsured>
            <!-- ��������������� -->
            <Lot>
                <xsl:value-of select="Lot" />
            </Lot>
        </Bnf>
    </xsl:template>

    <!-- ������Ϣ -->
    <xsl:template match="Risk">
        <Risk>
            <!-- ���ִ��� -->
            <RiskCode>
                <xsl:call-template name="tran_RiskCode">
                    <xsl:with-param name="riskCode">              <!-- ���ֲ�����ʲô��˼���������� -->
                        <xsl:value-of select="RiskCode" />
                    </xsl:with-param>
                </xsl:call-template>
            </RiskCode>
            <!-- �������ִ��� -->
            <MainRiskCode>
                <xsl:call-template name="tran_RiskCode">
                    <xsl:with-param name="riskCode">
                        <xsl:value-of select="MainRiskCode" />
                    </xsl:with-param>
                </xsl:call-template>
            </MainRiskCode>
            <!-- ����(��λΪ��) ����ʱΪ��-->
            <Amnt>
                <xsl:value-of select="Amnt" />
            </Amnt>
            <!-- ���շ�(��λΪ��)���������� -->
            <Prem>
                <xsl:value-of select="Prem" />
            </Prem>
            <!-- Ͷ����������ʱΪ��- -->
            <Mult>
                <xsl:value-of select="Mult" />
            </Mult>
            <!-- �ɷ���ʽ -->
            <PayMode>
            	<xsl:value-of select="PayMode" />
            </PayMode>
            <!-- �ɷ�Ƶ�� -->
            <PayIntv>
                <xsl:value-of select="PayIntv" />
            </PayIntv>
            <!-- �������������־ -->
            <InsuYearFlag>
                <xsl:value-of select="InsuYearFlag" />
            </InsuYearFlag>
            <!-- ������������ ������д��106-->
            <InsuYear>
                <xsl:value-of select="InsuYear" />
            </InsuYear>
            <!-- �ɷ����������־ -->
            <PayEndYearFlag>
                <xsl:value-of select="PayEndYearFlag" />
            </PayEndYearFlag>
            <!-- �ɷ��������� ����д��1000-->
            <PayEndYear>
                <xsl:value-of select="PayEndYear" />
            </PayEndYear>
            <!-- ������ȡ��ʽ -->
            <BonusGetMode>
                <xsl:value-of select="BonusGetMode" />
            </BonusGetMode>
            <!-- ������ȡ����ȡ��ʽ -->
            <FullBonusGetMode>
            	<xsl:value-of select="FullBonusGetMode" />
            </FullBonusGetMode> 
            <!-- ��ȡ�������ڱ�־ -->
		    <GetYearFlag>
		    	<xsl:value-of select="GetYearFlag" />
		    </GetYearFlag> 
		    <!-- ��ȡ���� -->	
		    <GetYear>
		    	<xsl:value-of select="GetYear" />
		    </GetYear> 
		    <!-- ��ȡ��ʽ -->		
		    <GetIntv>
		    	<xsl:value-of select="GetIntv" />
		    </GetIntv> 	
		    <!-- ��ȡ���б��� -->		
		    <GetBankCode>
		    	<xsl:value-of select="GetBankCode" />
		    </GetBankCode> 
		    <!-- ��ȡ�����˻� -->
		    <GetBankAccNo>
		    	<xsl:value-of select="GetBankAccNo" />
		    </GetBankAccNo> 
		    <!-- ��ȡ���л��� -->
		    <GetAccName>
		    	<xsl:value-of select="GetAccName" />
		    </GetAccName> 
		    <!-- �Զ��潻��־ -->
		    <AutoPayFlag>
		    	<xsl:value-of select="AutoPayFlag" />
		    </AutoPayFlag> 
        </Risk>
    </xsl:template>

    <!-- ��Ʒ��ϴ��� -->
    <xsl:template name="tran_ContPlanCode">
        <xsl:param name="contPlanCode" />
        <xsl:choose>
            <!-- 50002�ײ�-->
            <xsl:when test="$contPlanCode='50015'">50015</xsl:when>
            <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- ���ִ��룬���ļ���δʹ��ת����ֻ�Ǽ�¼�����ߵ����� -->
    <xsl:template name="tran_RiskCode">
        <xsl:param name="riskCode" />
        <xsl:choose>
            <xsl:when test="$riskCode='122009'">122009</xsl:when><!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A�� -->
			<xsl:when test="$riskCode='122010'">L12100</xsl:when><!-- ����ʢ��3���������գ������ͣ� -->
			<!-- xsl:when test=".='122010'">L12078</xsl:when>  --><!-- ����ʢ��3���������գ������ͣ� -->
			<xsl:when test="$riskCode='122012'">L12079</xsl:when><!-- ����ʢ��2���������գ������ͣ�  -->
			<xsl:when test="$riskCode='122036'">122036</xsl:when><!-- ����ƽ�6����ȫ���գ��ֺ��ͣ�A�� -->
			<xsl:when test="$riskCode='50002'">50015</xsl:when>  <!-- �������Ӯ���ռƻ�  -->
			<xsl:when test="$riskCode='L12080'">L12080</xsl:when>  <!-- ����ʢ��1���������գ������ͣ� -->
			<!--<xsl:when test=".='L12089'">L12089</xsl:when>-->  <!-- ����ʢ��1���������գ������ͣ�B�� -->
			<xsl:when test="$riskCode='L12074'">L12074</xsl:when>  <!-- ����ʢ��9����ȫ���գ������ͣ� -->
			<xsl:when test="$riskCode='L12087'">L12087</xsl:when><!-- �����5����ȫ���գ������ͣ�  -->
			<xsl:when test="$riskCode='L12086'">L12086</xsl:when><!-- �����3����ȫ���գ������ͣ� ���� -->
			<xsl:when test="$riskCode='L12085'">L12085</xsl:when><!-- �����2����ȫ���գ������ͣ� ���� -->
            <xsl:when test="$riskCode='L12088'">L12088</xsl:when><!-- �����9����ȫ���գ������ͣ� ���� -->
            <xsl:when test="$riskCode='L12091'">L12091</xsl:when><!-- �����Ӯ1�������A��-->
            <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- ���(N/Y) -->
    <xsl:template name="HY" match="HY">
        <xsl:choose>
            <xsl:when test=".='0'">Y</xsl:when>     <!-- �ѻ� -->
            <xsl:when test=".='1'">N</xsl:when>   <!-- δ�� -->
            <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>