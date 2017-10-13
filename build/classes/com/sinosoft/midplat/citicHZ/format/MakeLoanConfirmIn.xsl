<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="Transaction">
		<TranData>
			<xsl:apply-templates select="Transaction_Header"/>

			<Body>
			    <!-- ��ȫ���� -->	
				<PubEdorInfo>  
		           <!-- �����˱�����[yyyy-MM-dd]-->		  <!--������-->
		           <EdorAppDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()" /></EdorAppDate>                
   	 	           <NonAppNoFlag>1</NonAppNoFlag> <!-- ��У�鱣ȫ�������,�˴�Ҳ��Ҫȷ���Ƿ�У�鱣ȫ��������أ��������� -->
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
			      <SourceType>0</SourceType>
			      <!-- ���ͱ�־:0��1��--><!--������-->
			      <RepeatType></RepeatType>
			      <!-- ���յ����� --><!--������ -->
			      <ContNo><xsl:value-of select="Transaction_Body/PbInsuSlipNo" /></ContNo>
			      <!-- Ͷ����ӡˢ���� -->
			      <PrtNo></PrtNo>
			      <!-- �������� -->
			      <ContNoPSW></ContNoPSW>
			      <!-- ���ղ�Ʒ���� �����գ�-->
			      <RiskCode></RiskCode>
			      <!-- Ͷ����֤������ -->
			      <AppntIDType>
			          <xsl:call-template name="tran_idtype">
					    <xsl:with-param name="idtype">
						   <xsl:value-of select="Transaction_Body/LiRcgnIdType" />
					    </xsl:with-param>
				      </xsl:call-template>
			      </AppntIDType>
			      <!-- Ͷ����֤������ -->
			      <AppntIDNo><xsl:value-of select="Transaction_Body/LiRcgnId" /></AppntIDNo>
			      <!-- Ͷ�������� -->
			      <AppntName><xsl:value-of select="Transaction_Body/PbInsuName" /></AppntName>
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
			      <BankAccNo><xsl:value-of select="Transaction_Body/stdpriacno" /></BankAccNo>
			      <!-- ���˷��ʻ�����--><!--ȷ�Ͻ���ʱΪ������-->
			      <BankAccName><xsl:value-of select="Transaction_Body/PbInsuName" /></BankAccName>
				  <!-- ��ȫ�������� -->
	              <EdorType>ZL</EdorType>
	              <!-- ��ѯ=1��ȷ��=2��־ -->
	              <EdorFlag>2</EdorFlag>
	              <!-- �˹�������־���˹�����=1��ֱ����Ч=0��ȷ��ʱ��1����ѯʱ��0 -->
	              <!-- Ŀǰ���н�֧�������˱���Ӱ�����˲���Ӱ��ֱ����Ч -->
	              <ExamFlag>0</ExamFlag>
		      </PubContInfo>
		      <EdorZLInfo>
                 <LoanMoney><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Transaction_Body/PbInsuAmt)"/></LoanMoney>
              </EdorZLInfo>
		   </Body>
		</TranData>
	</xsl:template>

    <xsl:template name="Head" match="Transaction_Header">
       <Head>
	      <TranDate><xsl:value-of select="BkPlatDate"/></TranDate>
	      <TranTime><xsl:value-of select="BkPlatTime"/></TranTime>
          <NodeNo><xsl:value-of select="BkBrchNo"/></NodeNo>
	      <TellerNo><xsl:value-of select="BkTellerNo"/></TellerNo>
	      <TranNo><xsl:value-of select="BkPlatSeqNo"/></TranNo>
	      <xsl:copy-of select="../Head/*"/>
	      <BankCode><xsl:value-of select="../Head/TranCom/@outcode"/></BankCode>
      </Head>
    </xsl:template>
    <!-- ֤������ -->
	<xsl:template name="tran_idtype">
		<xsl:param name="idtype" />
		<xsl:choose>
		   <xsl:when test="$idtype='A'">0</xsl:when>	<!-- ���֤ -->
	       <xsl:when test="$idtype='B'">2</xsl:when>	<!-- ����֤ -->
	       <xsl:when test="$idtype='F'">5</xsl:when>	<!-- ���ڱ� -->
	       <xsl:when test="$idtype='I'">1</xsl:when>	<!-- ������� ����-->
	       <xsl:when test="$idtype='8'">7</xsl:when>	<!-- ̨�����������½ͨ��֤-->
	       <xsl:when test="$idtype='G'">6</xsl:when>   <!-- �۰Ļ���֤ -->
	       <xsl:otherwise>8</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
    
</xsl:stylesheet>