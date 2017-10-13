<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/Transaction">
		<TranData>
			<xsl:apply-templates select="TransHeader" />
			<Body>
				<xsl:apply-templates select="TransBody/Request" />
			</Body>
		</TranData>
	</xsl:template>

	<xsl:template name="Head" match="TransHeader">
		<Head>
			<TranDate><xsl:value-of select="TransDate"/></TranDate>
		    <TranTime><xsl:value-of select="TransTime"/></TranTime>
		    <TellerNo><xsl:value-of select="../TransBody/Request/UserNo"/></TellerNo>
		    <TranNo><xsl:value-of select="XDSerialNo"/></TranNo>
		    <!-- <NodeNo><xsl:value-of select="../TransBody/Request/OrgNo"/></NodeNo> -->
		    <NodeNo>02100000</NodeNo>
		    <xsl:copy-of select="../Head/*"/>
		    <BankCode><xsl:value-of select="../Head/TranCom/@outcode"/></BankCode>
		</Head>
	</xsl:template>
	
	<!--  ������Ϣ -->
	<xsl:template name="Request" match="Request">
		<PubContInfo>
			<!-- ���н�������(0-��ͳ����ͨ��1-������8-�����նˡ�17-�ֻ���z-ֱ������)��������ʱδ�ṩ-->
			<SourceType>z</SourceType>
			<!-- ���ͱ�־:0��1��--><!--������-->
			<RepeatType></RepeatType>
			<!-- ���յ����� --><!--������ -->
			<ContNo>
				<xsl:value-of select="InsurNo" />
			</ContNo>
			<!-- ����ӡˢ���� -->
			<PrtNo></PrtNo>
			<!-- ����Ѻ��� -->
			<PledgeAmt>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Amount)" />
			</PledgeAmt>
			<!-- ������ -->
			<GrossAmt></GrossAmt>

			<!-- ������ -->
			<BorrowRate></BorrowRate>

			<ContNoPSW></ContNoPSW>
			<!-- Ͷ�������� -->
			<AppntName>
				<xsl:value-of select="CustName" />
			</AppntName>
			<!-- Ͷ����֤������ -->
			<AppntIDNo>
				<xsl:value-of select="CertID" />
			</AppntIDNo>
			<!-- Ͷ����֤������ -->
			<AppntIDType>
				<xsl:apply-templates select="CertIDType" />
			</AppntIDType>
			<Sex></Sex>
			<Birthday></Birthday>
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
			<!-- �ո��ѷ�ʽ(09-�޿�֧��) Ĭ��Ϊ7=����ת��(�Ʒ���)--><!-- ȷ�Ͻ���ʱΪ������ -->
			<PayMode>7</PayMode>
			<!-- �ո������б��--><!-- ȷ�Ͻ���ʱΪ������ -->
			<PayGetBankCode></PayGetBankCode>
			<!-- �ո�����������  ʡ �� ����--><!-- ȷ�Ͻ���ʱΪ������ -->
			<BankName></BankName>
			<!-- ���˷��ʻ��ʺ�--><!-- ȷ�Ͻ���ʱΪ������ -->
			<BankAccNo></BankAccNo>
			<!-- ���˷��ʻ�����--><!-- ȷ�Ͻ���ʱΪ������ -->
			<BankAccName></BankAccName>
			<!--�����֤������ -->
			<BankAccIDType></BankAccIDType>
			<!--�����֤���� -->
			<BankAccIDNo></BankAccIDNo>
			<!-- ҵ������: CT=�˱���WT=���ˣ�CA=�޸Ŀͻ���Ϣ��MQ=���ڣ�XQ=���� BL-������Ѻ��BD-������Ѻ��� -->
			<EdorType>BL</EdorType>
			<!-- ��ѯ=1;ȷ��=2 -->
			<EdorFlag>2</EdorFlag>
		</PubContInfo>

    <!-- ��ȫ��Ϣ�����ڵ� -->
		<PubEdorInfo>
			<!-- �����˱�����[yyyy-MM-dd] -->
			<EdorAppDate>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()" />
			</EdorAppDate>
			<!--�����ֵΪ1������Ĳ�У�鱣ȫ�������Ϊ������ -->
			<NonAppNoFlag>1</NonAppNoFlag>
			<!-- ����������-->
			<EdorAppName><xsl:value-of select="CustName" /></EdorAppName>
			<Certify>
				<!-- ��֤����( 1-��ȫ������ 9-����) --><!-- ȷ�Ͻ���ʱΪ������ -->
				<CertifyType></CertifyType>
				<!-- ��֤����(��ȫ���������) --><!-- ȷ�Ͻ���ʱΪ������ -->
				<CertifyName></CertifyName>
				<!-- ��֤ӡˢ��(1-��ȫ���������)--><!-- ȷ�Ͻ���ʱΪ������ -->
				<CertifyCode></CertifyCode>
			</Certify>
		</PubEdorInfo>
	</xsl:template>

	<!-- ֤������ -->
	<xsl:template name="CertIDType" match="CertIDType">
		<xsl:choose>
			<xsl:when test=".='01'">0</xsl:when><!-- ���֤ -->
			<xsl:otherwise>8</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>





