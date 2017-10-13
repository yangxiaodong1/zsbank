<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:java="http://xml.apache.org/xslt/java" 
    exclude-result-prefixes="java">
    
	<xsl:template match="/TranData">
		<InsuRet>
		    <Main>
		 
		     
		       <ResultCode>0001</ResultCode>
		       <ResultInfo>此交易暂不支持！</ResultInfo>
		     
		   </Main>	
		   <Policy> 	
		   		<OldPolicyStatus></OldPolicyStatus>
		   		<BackPrem></BackPrem>
		   		<TotalPrem></TotalPrem>
		   		<NetPrem></NetPrem>
		   		<TranType></TranType>
		   </Policy>
		</InsuRet>
	</xsl:template>
	
</xsl:stylesheet>