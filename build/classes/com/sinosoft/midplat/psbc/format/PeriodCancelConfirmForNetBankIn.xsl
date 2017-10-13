<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="TRANDATA">
		<TranData>
			<Head>
				<xsl:copy-of select="Head/*" />
				<TranDate>
					<xsl:value-of select="MAIN/TRANSEXEDATE" />
				</TranDate>
				<TranTime>
					<xsl:value-of select="MAIN/TRANSEXETIME" />
				</TranTime>
				<TranNo>
					<xsl:value-of select="MAIN/TRANSREFGUID" />
				</TranNo>
				<NodeNo>
					<xsl:value-of select="MAIN/REGIONCODE" />
					<xsl:value-of select="MAIN/BRANCH" />
				</NodeNo>
				<TellerNo>
					<xsl:value-of select="MAIN/TELLER" />
				</TellerNo>
				<xsl:copy-of select="Head/*" />
				<BankCode>
					<xsl:value-of select="Head/TranCom/@outcode" />
				</BankCode>
				<SourceType><xsl:apply-templates select="MAIN/SOURCETYPE" /></SourceType>
			</Head>

			<Body>
			    <!-- ��ȫ���� -->	
				<PubEdorInfo>  
		           <!-- �����˱�����[yyyy-MM-dd]-->		  <!--������-->
		           <EdorAppDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()" /></EdorAppDate>                  
   	 	           <!-- ����������-->			          <!--������-->
   	 	           <EdorAppName></EdorAppName>                             		
		           <Certify>
				      <!-- ��֤����( 1-��ȫ������ 9-����) -->	<!--ȷ�Ͻ���ʱΪ������-->
				      <CertifyType></CertifyType>                        	
				      <!-- ��֤����(��ȫ���������) -->	    	<!--ȷ�Ͻ���ʱΪ������-->
				      <CertifyName></CertifyName>           	
				      <!-- ��֤ӡˢ��(1-��ȫ���������)-->		<!--ȷ�Ͻ���ʱΪ������-->
				      <CertifyCode></CertifyCode>             	
   		           </Certify>
   	           </PubEdorInfo>
   	           <!-- �˱������ֶ� -->
   	           <EdorCTInfo> 
		          <!-- �˱�ԭ����� -->
   		          <EdorReasonCode></EdorReasonCode>        
   		          <!-- �˱�ԭ�� -->             
   		          <EdorReason></EdorReason>               
   		          <!-- �Ƿ��ύ���л����񹲺͹��м���֤�����������Ͻ���ȡ֤��Y��N�� -->        
   		          <CertificateIndicator></CertificateIndicator>          
   		          <!-- ���ڱ��շѷ�Ʊ��ʧ Y��N�� -->
   		          <LostVoucherIndicator></LostVoucherIndicator>         
	          </EdorCTInfo>
	          <!--  ���� -->
	          <PubContInfo>
			      <!-- ���н�������(��̨/����),0=����ͨ��1=������8=�����ն�,����Ĭ��Ϊ0-->
			      <SourceType>1</SourceType>
			      <!-- ���ͱ�־:0��1��--><!--������-->
			      <RepeatType></RepeatType>
			      <!-- ���յ����� --><!--������ -->
			      <ContNo><xsl:value-of select="MAIN/POLNUMBER" /></ContNo>
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
			      <PayMode>7</PayMode><!-- TODO ��Ҫ��������ȷ���Ƿ�Ӧ���Ǻ���Ĭ�� -->
			      <!-- �ո������б��--><!--ȷ�Ͻ���ʱΪ������-->
			      <PayGetBankCode></PayGetBankCode>
			      <!-- �ո�����������  ʡ �� ����--><!--ȷ�Ͻ���ʱΪ������-->
			      <BankName></BankName>
			      <!-- ���˷��ʻ��ʺ�--><!--ȷ�Ͻ���ʱΪ������-->
			      <BankAccNo><xsl:value-of select="MAIN/ACCOUNTNUMBER" /></BankAccNo>
			      <!-- ���˷��ʻ�����--><!--ȷ�Ͻ���ʱΪ������-->
			      <BankAccName><xsl:value-of select="MAIN/ACCTHOLDERNAME" /></BankAccName>
				  <!-- ��ȫ�������� -->
	              <EdorType>WT</EdorType>
	              <!-- ��ѯ=1��ȷ��=2��־ -->
	              <EdorFlag>2</EdorFlag>
	              <!-- �˹�������־���˹�����=1��ֱ����Ч=0��ȷ��ʱ��1����ѯʱ��0 -->
	              <!-- Ŀǰ���н�֧�������˱���Ӱ�����˲���Ӱ��ֱ����Ч -->
	              <ExamFlag>0</ExamFlag>
		      </PubContInfo>
		   </Body>
		</TranData>
	</xsl:template>

    <!-- �������� -->
	<xsl:template match="SOURCETYPE">
		<xsl:choose>
			<xsl:when test=".='0'">0</xsl:when><!-- ���� -->
			<xsl:when test=".='1'">1</xsl:when><!-- ���� -->
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>