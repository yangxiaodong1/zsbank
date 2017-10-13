<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
	 <TranData>
		<Head>
			<xsl:copy-of select="TX/Head/*"/>
		</Head>
		<Body>
			<xsl:apply-templates select="TX/TX_BODY/ENTITY/APP_ENTITY"/>
		</Body>
	</TranData>
</xsl:template>

<xsl:template name="Body" match="APP_ENTITY">
	<!-- PubContInfo -->
	<PubContInfo>
		<!-- ���н�������(��̨/����) 0=����ͨ��1=������8=�����ն� -->
		<SourceType>17</SourceType>
		<!-- ���ͱ�־:0��1��--><!--������-->
		<RepeatType></RepeatType>                              
		<!-- ���յ����� --><!--������ -->
		<ContNo><xsl:value-of select="InsPolcy_No" /></ContNo> 
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
		<BankAccNo><xsl:value-of select="CCB_AccNo" /></BankAccNo>       
		<!-- ���˷��ʻ�����--><!--ȷ�Ͻ���ʱΪ������-->                   	
		<BankAccName></BankAccName>
		<!--�����֤������ -->
		<BankAccIDType />
		<!--�����֤���� -->
		<BankAccIDNo />
		<!-- ҵ������:WT=���ˣ�CT=��ԥ�����˱���MQ=���� -->
		<EdorType>WT</EdorType>
		<!-- ��ѯ=1;ȷ��=2 -->
		<EdorFlag>2</EdorFlag>                  			
	</PubContInfo>
  				
	<!-- PubEdorInfo -->
	<PubEdorInfo>  
	  <!-- �����˱�����[yyyy-MM-dd]-->		  <!--������-->
	  <EdorAppDate>
	 	 <xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()" />
	  </EdorAppDate>                   
  	 	  <!-- ����������-->			              <!--������-->
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
	<!-- EdorCTInfo -->
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
</xsl:template>

</xsl:stylesheet>

