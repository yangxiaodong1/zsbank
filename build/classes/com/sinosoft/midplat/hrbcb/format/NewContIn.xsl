<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:java="http://xml.apache.org/xslt/java"
    exclude-result-prefixes="java">

    <xsl:template match="TranData">
        <TranData>
            <xsl:apply-templates select="Head" />
            <Body>
                <xsl:apply-templates select="Body" />
            </Body>
        </TranData>
    </xsl:template>

    <!-- ����ͷ��Ϣ -->
    <xsl:template name="Head" match="Head">
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
                <xsl:value-of select="TranNo" />
            </TranNo>
            <!-- �������� ����û�е����� -->
            <NodeNo>
                <xsl:value-of select="NodeNo" />
            </NodeNo>
            <xsl:copy-of select="FuncFlag" />
            <xsl:copy-of select="ClientIp" />
            <xsl:copy-of select="TranCom" />
            <BankCode>
                <xsl:value-of select="TranCom/@outcode" />
            </BankCode>
        </Head>
    </xsl:template>

    <!-- ��������Ϣ -->
    <xsl:template name="Body" match="Body">
        <xsl:variable name="MainRisk"
            select="Risk[RiskCode=MainRiskCode]" />
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
        <GetPolMode></GetPolMode>
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

        <!-- ��Ʒ��� -->
        <ContPlan>
            <!-- ��Ʒ��ϱ��� -->
            <ContPlanCode>
                <xsl:call-template name="tran_ContPlanCode">
                    <xsl:with-param name="contPlanCode">
                        <xsl:value-of select="$MainRisk/RiskCode" />
                    </xsl:with-param>
                </xsl:call-template>
            </ContPlanCode>
            <!-- ��Ʒ��Ϸ��� -->
            <ContPlanMult>
                <xsl:value-of select="$MainRisk/Mult" />
            </ContPlanMult>
        </ContPlan>
        <!--δ���걻�������Ƿ����������չ�˾Ͷ�����ʱ��� Y��/N��-->
        <PolicyIndicator>
            <xsl:choose>
                <xsl:when test="InsuredTotalFaceAmount > 0">Y</xsl:when>
                <xsl:otherwise>N</xsl:otherwise>
            </xsl:choose>
        </PolicyIndicator>
        <!--�ۼ�Ͷ�����ʱ���(���ĵ�λ��Ԫ)-->
        <InsuredTotalFaceAmount></InsuredTotalFaceAmount>
        <!--������������-->
        <AgentComName>
            <xsl:value-of select="AgentComName" />
        </AgentComName>
        <!-- ��������֤-->
        <AgentComCertiCode>
            <xsl:value-of select="AgentComCertiCode" />
        </AgentComCertiCode>
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
        <!-- ����(cm)-->
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
        <!-- �Ƿ��ѽ��з��������ʾ����� -->
        <RiskAssess>
            <xsl:value-of select="EvalRisk" />
        </RiskAssess>
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
        <!-- ���ߣ�cm�� -->
        <Stature>
            <xsl:value-of select="Stature" />
        </Stature>
        <!-- ���أ�kg�� -->
        <Weight>
            <xsl:value-of select="Weight" />
        </Weight>
        <!-- ��� -->
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
    </xsl:template>

    <!-- ��������Ϣ -->
    <xsl:template match="Bnf">
        <Bnf>
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
                    <xsl:with-param name="riskCode">
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
            <PayMode></PayMode>
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
            <FullBonusGetMode></FullBonusGetMode>
        </Risk>
    </xsl:template>

    <!-- ��Ʒ��ϴ��� -->
    <xsl:template name="tran_ContPlanCode">
        <xsl:param name="contPlanCode" />
        <xsl:choose>
            <!-- 50002�ײ�-->
            <xsl:when test="$contPlanCode='50002'">50015</xsl:when>
            <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- ���ִ��룬���ļ���δʹ��ת����ֻ�Ǽ�¼�����ߵ����� -->
    <xsl:template name="tran_RiskCode">
        <xsl:param name="riskCode" />
        <xsl:choose>
            <xsl:when test="$riskCode='50002'">50015</xsl:when>      <!-- �������Ӯ���ռƻ� -->
            <xsl:when test="$riskCode='L12080'">L12080</xsl:when>    <!-- ����ʢ��1���������գ������ͣ�  -->
            <xsl:when test="$riskCode='122012'">L12079</xsl:when>    <!-- ����ʢ��2���������գ������ͣ�  -->
            <xsl:when test="$riskCode='122010'">L12078</xsl:when>    <!-- ����ʢ��3���������գ������ͣ�  -->
            <xsl:when test="$riskCode='122029'">L12073</xsl:when>    <!-- ����ʢ��5���������գ������ͣ�  -->     
            <xsl:when test="$riskCode='122009'">122009</xsl:when>    <!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A��  --> 
            <xsl:when test="$riskCode='L12087'">L12087</xsl:when> <!-- �����5����ȫ���գ������ͣ� -->     
            <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>