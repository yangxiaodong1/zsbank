<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

<xsl:template match="ABCB2I">
		<TranData>
			<!-- ����ͷ -->
			<xsl:apply-templates select="Header" />
			
			<!-- ������ -->
			<Body>
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
		  <!-- �����˱�����[yyyy-MM-dd]-->		  <!--������-->
		  <EdorAppDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()" /></EdorAppDate>                   
   	 	  <!-- ����������-->			              <!--������-->
   	 	  <EdorAppName></EdorAppName>                             		
		    <Certify>
				<!-- ��֤����( 1-��ȫ������ 9-����) -->	<!--ȷ�Ͻ���ʱΪ������-->
				<CertifyType></CertifyType>                        	
				<!-- ��֤����(��ȫ���������) -->	    	<!--ȷ�Ͻ���ʱΪ������-->
				<CertifyName></CertifyName>           	
				<!-- ��֤ӡˢ��(1-��ȫ���������)-->		<!--ȷ�Ͻ���ʱΪ������-->
				<CertifyCode>000000</CertifyCode>             	
   		  </Certify>
   	  </PubEdorInfo>
 
		<EdorXQInfo> 
		   <!-- ��� -->
   		  <GrossAmt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(PayAmt)" /></GrossAmt>                       
   		   <!-- Ӧ������[yyyyMMdd] --> 	     
   		  <FinEffDate></FinEffDate>               
	    </EdorXQInfo> 
			
		<PubContInfo>
			<!-- ���н�������(��̨/����)-->
			<SourceType>0</SourceType>
			<!-- ���ͱ�־:0��1��--><!--������-->
			<RepeatType></RepeatType>                              
			<!-- ���յ����� --><!--������ -->
			<ContNo><xsl:value-of select="PolicyNo" /></ContNo> 
			<!-- Ͷ����ӡˢ���� -->					  	 	  														  
  	 	 	<PrtNo></PrtNo>		
  	 	 	<!-- �������� -->									
  	 	 	<ContNoPSW></ContNoPSW>   
  	 	 	<!-- ���ղ�Ʒ���� �����գ�-->                 
  	 		<RiskCode><xsl:apply-templates select="RiskCode"  mode="risk"/></RiskCode>
  	 		<!-- Ͷ����֤������ -->
			<AppntIDType><xsl:apply-templates select="Appl/IDKind" /></AppntIDType>
			<!-- Ͷ����֤������ -->					   			            	
	   	 	<AppntIDNo><xsl:value-of select="Appl/IDCode" /></AppntIDNo>                    
	   	 	 <!-- Ͷ�������� --> 	
	   	 	<AppntName><xsl:value-of select="Appl/Name" /></AppntName>  
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
   	 	    <BankAccNo><xsl:value-of select="PayAcc" /></BankAccNo>       
   	 	    <!-- ���˷��ʻ�����--><!--ȷ�Ͻ���ʱΪ������-->                   	
   	 	    <BankAccName><xsl:value-of select="Appl/Name" /></BankAccName>                  			
	  </PubContInfo>
	</xsl:template>				
	
		<!-- ֤������ -->
	<xsl:template match="IDKind">
		<xsl:choose>
			<xsl:when test=".='110001'">0</xsl:when><!--�������֤                -->
			<xsl:when test=".='110002'">0</xsl:when><!--�غž������֤            -->
			<xsl:when test=".='110003'">0</xsl:when><!--��ʱ�������֤            -->
			<xsl:when test=".='110004'">0</xsl:when><!--�غ���ʱ�������֤        -->
			<xsl:when test=".='110005'">5</xsl:when><!--���ڲ�                    -->
			<xsl:when test=".='110006'">5</xsl:when><!--�غŻ��ڲ�                -->			
			<xsl:when test=".='110023'">1</xsl:when><!--�л����񹲺͹�����        -->
			<xsl:when test=".='110024'">1</xsl:when><!--�غ��л����񹲺͹�����    -->
			<xsl:when test=".='110025'">1</xsl:when><!--�������                  -->
			<xsl:when test=".='110026'">1</xsl:when><!--�غ��������              -->
			<xsl:when test=".='110027'">2</xsl:when><!--����֤                    -->
			<xsl:when test=".='110028'">2</xsl:when><!--�غž���֤                -->
			<xsl:when test=".='110029'">2</xsl:when><!--��ְ�ɲ�֤                -->
			<xsl:when test=".='110030'">2</xsl:when><!--�غ���ְ�ɲ�֤            -->
            <xsl:otherwise>8</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ���ִ��� -->
	<xsl:template  match="RiskCode"  mode="risk">
		<xsl:choose>
			<xsl:when test=".='122046'">50001</xsl:when><!-- ������Ӯ1���ײ� -->
			<xsl:when test=".='50002'">50002</xsl:when><!-- ������Ӯ���ռƻ� -->
			<xsl:when test=".='122012'">122012</xsl:when><!-- ����ʢ��2���������գ������ͣ�  -->
			<!-- <xsl:when test=".='122010'">122010</xsl:when>  --><!-- ����ʢ��3���������գ������ͣ�  -->
			<xsl:when test=".='122035'">122035</xsl:when><!-- ����ʢ��9����ȫ���գ������ͣ�  -->
			<xsl:when test=".='L12089'">L12089</xsl:when><!-- ����ʢ��1����ȫ���գ������ͣ�B��  -->
			<xsl:when test=".='L12080'">L12080</xsl:when><!-- ����ʢ��1����ȫ���գ������ͣ�  -->
			
			<xsl:when test=".='50015'">50015</xsl:when><!-- ������Ӯ���ռƻ� -->
			<xsl:when test=".='L12079'">L12079</xsl:when><!-- ����ʢ��2���������գ������ͣ�  -->
			<!-- ʢ��3�Ų�Ʒ������start -->
			<!-- <xsl:when test=".='L12078'">L12078</xsl:when> --><!-- ����ʢ��3���������գ������ͣ�  -->
			<xsl:when test=".='122010'">L12100</xsl:when><!-- ����ʢ��3���������գ������ͣ�  -->
			<xsl:when test=".='L12078'">L12100</xsl:when><!-- ����ʢ��3���������գ������ͣ�  -->
			<!-- ʢ��3�Ų�Ʒ������end -->
			<xsl:when test=".='L12074'">L12074</xsl:when><!-- ����ʢ��9����ȫ���գ������ͣ�  -->
			
			<xsl:when test=".='122009'">122009</xsl:when><!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A��  -->
			<xsl:when test=".='122036'">122036</xsl:when><!-- ����ƽ�6����ȫ���գ��ֺ��ͣ�A��  -->
			
			<xsl:when test=".='122006'">122006</xsl:when><!-- ����۱���2����ȫ���գ��ֺ��ͣ�A��  -->
			<xsl:when test=".='122008'">122008</xsl:when><!-- ���������1����������(������)  -->
			<xsl:when test=".='122002'">122002</xsl:when><!-- ����ƽ�2����ȫ����(�ֺ���)A��  -->
			<xsl:when test=".='122005'">122005</xsl:when><!-- ����ƽ�3����ȫ����(�ֺ���)A��  -->
			
			<!-- ����ٰ���5�ű��ռƻ�50012,����ٰ���5�������L12070,����ӳ�������5����ȫ���գ������ͣ�L12071 -->
			<xsl:when test=".='50012'">50012</xsl:when>
			
			<!-- �����3����ȫ���գ������ͣ�L12086 -->
			<xsl:when test=".='L12086'">L12086</xsl:when>
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>