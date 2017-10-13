<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
	<xsl:template match="Req">
		<TranData>
			<xsl:apply-templates select="Head/Sender" />
			<Body>
				<xsl:apply-templates select="Body" />
			</Body>
		</TranData>
	</xsl:template>
	<xsl:template name="Head" match="Sender">
		<Head>
			<TranDate>
				<xsl:value-of select="BusDate" />
			</TranDate>
			<TranTime>
				<xsl:value-of select="TrTime" />
			</TranTime>
			<TellerNo>
				<xsl:value-of select="TrOper" />
			</TellerNo>
			<TranNo>
				<xsl:value-of select="SeqNo" />
			</TranNo>
			<NodeNo>
				<xsl:value-of select="BrchId" /><xsl:value-of select="SubBrchId" />
			</NodeNo>
			<BankCode><xsl:value-of select="../TranCom/@outcode"/></BankCode>		
			<xsl:copy-of select="../ClientIp" />
			<xsl:copy-of select="../FuncFlag" />
			<xsl:copy-of select="../TranCom" />
		</Head>
	</xsl:template>
	
	<xsl:template name="Body" match="Body">
		<!-- ������Ϣ�����ڵ� -->
      <PubContInfo>
      	 <!--���н�������(0-��̨��1-������8-�����ն�) -->
         <SourceType><xsl:apply-templates select="../Head/Sender/ChanNo" /></SourceType>
         <RepeatType />
         <!-- ������ -->
         <ContNo><xsl:value-of select="PolItem/PolNo" /></ContNo>
         <!-- ����ӡˢ�� -->
         <PrtNo />
         <ContNoPSW />
         <!-- ���ִ��� -->
         <RiskCode></RiskCode>
         <!-- Ͷ����֤������ -->
         <AppntIDType><xsl:apply-templates select="AppItem/CusItem/IdType" /></AppntIDType>
         <!-- Ͷ����֤���� -->
         <AppntIDNo><xsl:value-of select="AppItem/CusItem/IdNo" /></AppntIDNo>
         <!-- Ͷ�������� -->
         <AppntName><xsl:value-of select="AppItem/CusItem/Name" /></AppntName>
         <!-- Ͷ����֤����Ч�� -->
         <AppntIdTypeEndDate />
         <AppntPhone />
         <!-- ������֤������ -->
         <InsuredIDType></InsuredIDType>
         <!-- ������֤���� -->
         <InsuredIDNo></InsuredIDNo>
         <!-- ���������� -->
         <InsuredName></InsuredName>
         <!-- ������֤����Ч�� -->
         <InsuredIdTypeEndDate />
         <InsuredPhone />
         <RelationRoleCode1></RelationRoleCode1>
         <RelationRoleName1 />
         <RelationRoleCode2></RelationRoleCode2>
         <RelationRoleName2 />
         <PayMode>7</PayMode>
         <PayGetBankCode />
         <BankName />
         <!-- �˱��˻� -->
         <BankAccNo><xsl:value-of select="PolItem/CusActItem/ActNo" /></BankAccNo>
         <!-- �˱��˻��� -->
         <BankAccName><xsl:value-of select="PolItem/CusActItem/ActName" /></BankAccName>
         <!--�����֤������ -->
		 <BankAccIDType></BankAccIDType>
         <!--�����֤���� -->
   	 	 <BankAccIDNo></BankAccIDNo>
         <!-- ��ȫ�������� -->
         <EdorType>WT</EdorType>
         <!-- ��ѯ=1��ȷ��=2��־ -->
         <EdorFlag>2</EdorFlag>
		 <!-- �˹�������־���˹�����=1��ֱ����Ч=0 -->
	     <ExamFlag>0</ExamFlag>
      </PubContInfo>
      <!-- ��ȫ��Ϣ�����ڵ� -->
      <PubEdorInfo>
      	 <!-- �������� (yyyy-mm-dd)-->
         <EdorAppDate><xsl:value-of
					select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()" />
		</EdorAppDate>
         <!-- ������ -->
         <EdorAppName></EdorAppName>
         <Certify>
			<!-- ��֤����( 1-��ȫ�����飬 9-����) -->
            <CertifyType>1</CertifyType>
			<!--��ȫ����-->
            <CertifyName />
			<!--��ȫ���뵥��-->
            <CertifyCode></CertifyCode>
         </Certify>
      </PubEdorInfo>
	  <EdorCTInfo>
         <EdorReasonCode />
		 <!--��ȫ����ԭ��-->
         <EdorReason />
         <CertificateIndicator />
         <LostVoucherIndicator />
      </EdorCTInfo>		
	</xsl:template>
	<!-- ���� -->
	<xsl:template name="ChanNo" match="ChanNo">
		<xsl:choose>
			<xsl:when test=".=00">0</xsl:when>	<!-- ���� -->
			<xsl:when test=".=21">1</xsl:when>	<!-- �������� -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ֤������ -->
	<xsl:template name="IdType" match="IdType">
		<xsl:choose>
			<xsl:when test=".='0101'">0</xsl:when> <!-- ���֤ -->
			<xsl:when test=".='0102'">0</xsl:when> <!-- ���֤ -->
			<xsl:when test=".='0200'">0</xsl:when> <!-- ���֤ -->
			<xsl:when test=".='0300'">5</xsl:when> <!-- ���ڲ� -->
			<xsl:when test=".='0301'">8</xsl:when> <!-- ���� -->
			<xsl:when test=".='0400'">5</xsl:when> <!-- ���ڲ� -->
			<xsl:when test=".='0601'">2</xsl:when> <!-- ����֤ -->
			<xsl:when test=".='0604'">2</xsl:when> <!-- ����֤ -->
			<xsl:when test=".='0700'">2</xsl:when> <!-- ����֤ -->
			<xsl:when test=".='0701'">2</xsl:when> <!-- ����֤ -->
			<xsl:when test=".='0800'">2</xsl:when> <!-- ����֤ -->
			<xsl:when test=".='1000'">1</xsl:when> <!-- ���� -->
			<xsl:when test=".='1100'">8</xsl:when> <!-- ���� -->
			<xsl:when test=".='1110'">8</xsl:when> <!-- ���� -->
			<xsl:when test=".='1111'">8</xsl:when> <!-- ���� -->
			<xsl:when test=".='1112'">8</xsl:when> <!-- ���� -->
			<xsl:when test=".='1113'">8</xsl:when> <!-- ���� -->
			<xsl:when test=".='1114'">8</xsl:when> <!-- ���� -->
			<xsl:when test=".='1120'">8</xsl:when> <!-- ���� -->
			<xsl:when test=".='1121'">6</xsl:when> <!-- �۰ľ��������ڵ�ͨ��֤ -->
			<xsl:when test=".='1122'">6</xsl:when> <!-- �۰ľ��������ڵ�ͨ��֤ -->
			<xsl:when test=".='1123'">7</xsl:when> <!-- ̨�����������½ͨ��֤ -->
			<xsl:when test=".='1300'">8</xsl:when> <!-- ���� -->
			<xsl:when test=".='9999'">8</xsl:when> <!-- ���� -->
			<xsl:otherwise>8</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>