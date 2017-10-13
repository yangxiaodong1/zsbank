<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<!-- head -->
			<xsl:apply-templates select="TXLife/TXLifeRequest" />
			<Body>
				<!-- PubContInfo -->
				<xsl:apply-templates select="TXLife/TXLifeRequest/OLifE/Holding/Policy" />								
				<!-- PubEdorInfo -->
				<xsl:apply-templates select="TXLife/TXLifeRequest/OLifE" />								
   	  			<!-- EdorXQInfo -->
   	  			<xsl:apply-templates select="TXLife/TXLifeRequest/OLifE/Holding/Policy/FinancialActivity" />			    																
			</Body>
		</TranData>
	</xsl:template>
	<!-- head -->
	<xsl:template name="Head" match="TXLifeRequest">
		<Head>
			<TranDate>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.DateUtil.date10to8(TransExeDate)" />
			</TranDate>
			<TranTime>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.DateUtil.time8to6(TransExeTime)" />
			</TranTime>
			<TellerNo>
				<xsl:value-of select="OLifEExtension/Teller" />
			</TellerNo>
			<TranNo>
				<xsl:value-of select="TransRefGUID" />
			</TranNo>
			<NodeNo>
				<xsl:value-of select="OLifEExtension/RegionCode" />
				<xsl:value-of select="OLifEExtension/Branch" />
			</NodeNo>
			<xsl:copy-of select="../Head/*" />
			<BankCode>
				<xsl:value-of select="../Head/TranCom/@outcode" />
			</BankCode>
		</Head>
	</xsl:template>
	
	<!-- ��ȫ���� -->	
	<xsl:template name="PubEdorInfo" match="OLifE" >	
		<PubEdorInfo>  
		
		  <!-- �����˱�����[yyyy-MM-dd]-->		  <!--������-->
		  <EdorAppDate>
		 	 <xsl:value-of
					select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()" />
		  </EdorAppDate>                   
   	 	  <!-- ����������-->			              <!--������-->
   	 	  <EdorAppName></EdorAppName>                             		
		    <Certify>
				<!-- ��֤����( 1-��ȫ������ 9-����) -->	<!--ȷ�Ͻ���ʱΪ������-->
				<CertifyType>					
				</CertifyType>                        	
				<!-- ��֤����(��ȫ���������) -->	    	<!--ȷ�Ͻ���ʱΪ������-->
				<CertifyName></CertifyName>           	
				<!-- ��֤ӡˢ��(1-��ȫ���������)-->		<!--ȷ�Ͻ���ʱΪ������-->
				<CertifyCode>000000</CertifyCode>             	
   		  </Certify>
   	  </PubEdorInfo>
	</xsl:template>
		
	<!-- ���������ֶ� -->
	<xsl:template name="EdorXQInfo" match="FinancialActivity" >
		<EdorXQInfo> 
   		  <GrossAmt><xsl:value-of select="FinActivityGrossAmt" /></GrossAmt>                               <!-- ��� -->	     
   		  <FinEffDate>
   		  	<xsl:value-of
					select="java:com.sinosoft.midplat.common.DateUtil.date10to8(FinEffDate)" />
   		  </FinEffDate>                       <!-- Ӧ������[yyyyMMdd] -->
	    </EdorXQInfo> 
	</xsl:template>
	
	<!--  ���� -->
	<xsl:template name="PubContInfo" match="Policy" >				
		<PubContInfo>
			<!-- ���н�������(��̨/����)-->
			<SourceType>0</SourceType><!-- TODO ������Ҫ���ֵΪ1 ����Ȼ�޷����������ף��Ѿ���������ȷ�Ϲ� -->
			<!-- ���ͱ�־:0��1��--><!--������-->
			<RepeatType></RepeatType>                              
			<!-- ���յ����� --><!--������ -->
			<ContNo><xsl:value-of select="PolNumber" /></ContNo> 
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
   	 	    <BankAccNo><xsl:apply-templates select="../../Holding/Banking/AccountNumber" /></BankAccNo>       
   	 	    <!-- ���˷��ʻ�����--><!--ȷ�Ͻ���ʱΪ������-->                   	
   	 	    <BankAccName><xsl:apply-templates select="../../Holding/Banking/AcctHolderName" /></BankAccName>                  			
	  </PubContInfo>
	</xsl:template>		
</xsl:stylesheet>


	

