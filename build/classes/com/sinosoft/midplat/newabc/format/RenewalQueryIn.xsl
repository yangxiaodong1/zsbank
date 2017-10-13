<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="ABCB2I">
		<TranData>
			<!-- ����ͷ -->
			<xsl:apply-templates select="Header" />
			<Body>
				<!-- ������ -->
				<xsl:apply-templates select="App/Req" />
			</Body>
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

		<PubEdorInfo>
			<!-- �����˱�����[yyyy-MM-dd]--><!--������-->
			<EdorAppDate>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()" />
			</EdorAppDate>
			<!-- ����������--><!--������-->
			<EdorAppName></EdorAppName>
			<Certify>
				<!-- ��֤����( 1-��ȫ������ 9-����) --><!--ȷ�Ͻ���ʱΪ������-->
				<CertifyType></CertifyType>
				<!-- ��֤����(��ȫ���������) --><!--ȷ�Ͻ���ʱΪ������-->
				<CertifyName></CertifyName>
				<!-- ��֤ӡˢ��(1-��ȫ���������)--><!--ȷ�Ͻ���ʱΪ������-->
				<CertifyCode>000000</CertifyCode>
			</Certify>
		</PubEdorInfo>

		<EdorXQInfo>
			<!-- ��� -->
			<GrossAmt></GrossAmt>
			<!-- Ӧ������[yyyyMMdd] -->
			<FinEffDate></FinEffDate>
		</EdorXQInfo>

		<PubContInfo>
			<!-- ���н�������(��̨/����)-->
			<SourceType></SourceType>
			<!-- ���ͱ�־:0��1��--><!--������-->
			<RepeatType></RepeatType>
			<!-- ���յ����� --><!--������ -->
			<ContNo>
				<xsl:value-of select="PolicyNo" />
			</ContNo>
			<!-- Ͷ����ӡˢ���� -->
			<PrtNo></PrtNo>
			<!-- �������� -->
			<ContNoPSW></ContNoPSW>
			<!-- ���ղ�Ʒ���� �����գ�-->
			<RiskCode></RiskCode>
			<!-- Ͷ����֤������ -->
			<AppntIDType></AppntIDType>
			<!-- Ͷ����֤������ -->
			<AppntIDNo></AppntIDNo>
			<!-- Ͷ�������� -->
			<AppntName></AppntName>
			<!-- Ͷ����֤����Ч��ֹ���� -->
			<AppntIdTypeEndDate></AppntIdTypeEndDate>
			<!-- Ͷ����סլ�绰 (Ͷ������ϵ�绰) -->
			<AppntPhone></AppntPhone>
			<!-- ������֤������ -->
			<InsuredIDType></InsuredIDType>
			<!-- ������֤������ -->
			<InsuredIDNo></InsuredIDNo>
			<!-- ���������� -->
			<InsuredName></InsuredName>
			<!-- ������֤����Ч��ֹ���� -->
			<InsuredIdTypeEndDate></InsuredIdTypeEndDate>
			<!-- ������סլ�绰 (Ͷ������ϵ�绰) -->
			<InsuredPhone></InsuredPhone>
			<!-- Ͷ���˹�ϵ���� -->
			<RelationRoleCode1></RelationRoleCode1>
			<!-- Ͷ���˹�ϵ -->
			<RelationRoleName1></RelationRoleName1>
			<!-- �����˹�ϵ���� -->
			<RelationRoleCode2></RelationRoleCode2>
			<!-- �����˹�ϵ -->
			<RelationRoleName2></RelationRoleName2>
			<!-- �ո��ѷ�ʽ(09-�޿�֧��) Ĭ��Ϊ7�����д���--><!--ȷ�Ͻ���ʱΪ������-->
			<PayMode>7</PayMode>
			<!-- �ո������б��--><!--ȷ�Ͻ���ʱΪ������-->
			<PayGetBankCode></PayGetBankCode>
			<!-- �ո�����������  ʡ �� ����--><!--ȷ�Ͻ���ʱΪ������-->
			<BankName></BankName>
			<!-- ���˷��ʻ��ʺ�--><!--ȷ�Ͻ���ʱΪ������-->
			<BankAccNo></BankAccNo>
			<!-- ���˷��ʻ�����--><!--ȷ�Ͻ���ʱΪ������-->
			<BankAccName></BankAccName>
		</PubContInfo>
	</xsl:template>
</xsl:stylesheet>