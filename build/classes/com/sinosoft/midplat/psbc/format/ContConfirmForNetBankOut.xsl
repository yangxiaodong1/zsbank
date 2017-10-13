<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:output indent='yes'/>
<xsl:template match="/TranData">
<RETURN>
	 <MAIN>
	 	<!--������-->
	 	<RESULTCODE>
	 		<xsl:apply-templates select="Head/Flag" />
	 	</RESULTCODE>
	 	<!--��������-->
	 	<ERR_INFO>
	 		<xsl:value-of select="Head/Desc" />
	 	</ERR_INFO>
	 	<!-- ������׳ɹ����ŷ�������Ľ�� -->
		<xsl:if test="Head/Flag='0'">
	 	<!--Ͷ������-->
	 	<APPLNO>
	 		<xsl:value-of select="Body/ProposalPrtNo" />
	 	</APPLNO>
	 	<!--������( ���ձ��պ�ͬ��)-->
	 	<POLICY>
	 		<xsl:value-of select="Body/ContNo" />
	 	</POLICY>
	 	<!--Ͷ�����ڣ�CD01��-->
	 	<ACCEPT>
	 		<xsl:value-of select="Body/Risk/PolApplyDate" />
	 	</ACCEPT>
	 	<!--���ڱ��ѣ�CD23��-->
	 	<PREM>
	 		<xsl:value-of select="Body/Prem" />
	 	</PREM>
	 	<!--���ڱ��Ѵ�д-->
	 	<xsl:variable name="SumPremYuan"
	 		select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/Prem)" />
	 	<PREMC>
	 		<xsl:value-of
	 			select="java:com.sinosoft.midplat.common.NumberUtil.money2CN(Body/Prem)" />
	 	</PREMC>
	 	<!--������Ч���ڣ�CD01��-->
	 	<VALIDATE>
	 		<xsl:value-of select="Body/Risk/CValiDate" />
	 	</VALIDATE>
	 	<!--Ͷ��������-->
	 	<TBR_NAME>
	 		<xsl:value-of select="Body/Appnt/Name" />
	 	</TBR_NAME>
	 	<!--Ͷ���˿ͻ���-->
	 	<TBRPATRON>
	 		<xsl:value-of select="Body/Appnt/CustomerNo" />
	 	</TBRPATRON>
	 	<!--����������-->
	 	<BBR_NAME>
	 		<xsl:value-of select="Body/Insured/Name" />
	 	</BBR_NAME>
	 	<!--�����˿ͻ���-->
	 	<BBRPATRON>
	 		<xsl:value-of select="Body/Insured/CustomerNo" />
	 	</BBRPATRON>
	 	<!--�ɷѷ�ʽ��CD24��-->
	 	<xsl:variable name="PayIntv"
	 		select="Body/Risk[RiskCode=MainRiskCode]/PayIntv" />
	 	<PAYMETHOD>
	 		<xsl:call-template name="tran_PayIntv">
	 			<xsl:with-param name="PayIntv">
	 				<xsl:value-of select="$PayIntv" />
	 			</xsl:with-param>
	 		</xsl:call-template>
	 	</PAYMETHOD>
	 	<!--�ɷѷ�ʽ(����)-->
	 	<PAY_METHOD>
	 		<xsl:apply-templates select="$PayIntv" />
	 	</PAY_METHOD>
	 	<!--�ɷ����ڣ�CD01��-->
	 	<PAYDATE>
	 		<xsl:value-of select="Body/Risk/PolApplyDate" />
	 	</PAYDATE>
	 	<!--�б���˾����-->
	 	<ORGAN>
	 		<xsl:value-of select="Body/ComName" />
	 	</ORGAN>
	 	<!--�б���˾��ַ-->
	 	<LOC>
	 		<xsl:value-of select="Body/ComLocation" />
	 	</LOC>
	 	<!--�б���˾�绰-->
	 	<TEL>
	 		<xsl:value-of select="Body/ComPhone" />
	 	</TEL>
	 	<!--�ر�Լ����ӡ��־��CD25��-->
	 	<ASSUM>0</ASSUM>
	 	<!--Ͷ���˿ͻ����������ڣ�CD01��-->
	 	<TBR_OAC_DATE></TBR_OAC_DATE>
	 	<!--�����˿ͻ����������ڣ�CD01��-->
	 	<BBR_OAC_DATE></BBR_OAC_DATE>
	 	<!--�б���˾����-->
	 	<ORGANCODE>
	 		<xsl:value-of select="Body/ComCode" />
	 	</ORGANCODE>
	 	<!--���ڽɷ����ڣ�����������-->
	 	<PAYDATECHN></PAYDATECHN>
	 	<!--�ɷ���ֹ���ڣ�����������-->
	 	<PAYSEDATECHN></PAYSEDATECHN>
	 	<!--�ɷ�����-->
	 	<PAYYEAR></PAYYEAR>
	 	</xsl:if>
	 </MAIN>
	<!-- ������׳ɹ����ŷ�������Ľ�� -->
	<xsl:if test="Head/Flag='0'">
	 <!--������Ϣ-->
	<PTS>
	    <PT_COUNT><xsl:value-of select="count(Body/Risk)"/></PT_COUNT>
	    <xsl:for-each select= "Body/Risk">
	    <PT>
	        <xsl:variable name="ContEndDateText" select="java:com.sinosoft.midplat.common.DateUtil.formatTrans(InsuEndDate, 'yyyyMMdd', 'yyyy��MM��dd��')"/>
	        <xsl:variable name="RiskCode" select="RiskCode"/>
	        <xsl:variable name="MainRiskCode" select="MainRiskCode"/>
	        <POLICY><xsl:value-of select="../ContNo"/></POLICY>
	        <UNIT><xsl:value-of select="Mult"/></UNIT>
	        <xsl:if test="$RiskCode = $MainRiskCode">
		        <MAINSUBFLG>1</MAINSUBFLG>
		    </xsl:if>
	        <xsl:if test="$RiskCode != $MainRiskCode">
		        <MAINSUBFLG>0</MAINSUBFLG>
			</xsl:if>
	        <AMT><xsl:value-of select="Amnt"/></AMT>
	        <PREM><xsl:value-of select="Prem"/></PREM>
	        <NAME><xsl:value-of select="RiskName"/></NAME>
	        <PERIOD><xsl:value-of select="$ContEndDateText"/></PERIOD>
	        <INSUENDDATE><xsl:value-of select="$ContEndDateText"/></INSUENDDATE>
	        <INSUENDDATE_CPAI><xsl:value-of select="InsuEndDate"/></INSUENDDATE_CPAI>
	        <PAYENDDATE><xsl:value-of select="PayEndDate"/></PAYENDDATE>
	        <CHARGE_PERIOD>
	        	<xsl:call-template name="tran_PayEndYearFlag">
	        		<xsl:with-param name="payendyearflag">
	        			<xsl:value-of select="PayEndYearFlag" />
	        		</xsl:with-param>
	        		<xsl:with-param name="payendyear">
	        			<xsl:value-of select="PayEndYear" />
	        		</xsl:with-param>
	        	</xsl:call-template>
	        </CHARGE_PERIOD>
	        <CHARGE_YEAR><xsl:value-of select="PayEndYear"/></CHARGE_YEAR>
	    </PT>
	    </xsl:for-each>  
	</PTS>
	<PRT></PRT>
    </xsl:if>
</RETURN>
</xsl:template>


<!-- ֤�����͡�ע�⣺������  ���ո��Ű��õģ�����ȥ���� -->
<xsl:template match="IDType">
<xsl:choose>
	<xsl:when test=".=0">���֤</xsl:when>
	<xsl:when test=".=1">����  </xsl:when>
	<xsl:when test=".=2">����֤</xsl:when>
	<xsl:when test=".=3">����  </xsl:when>
	<xsl:when test=".=5">���ڲ�</xsl:when>
	<xsl:otherwise>--  </xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- �ɷѼ��  -->
<xsl:template match="PayIntv">
<xsl:choose>
	<xsl:when test=".=0">����</xsl:when>		
	<xsl:when test=".=1">�½�</xsl:when>
	<xsl:when test=".=3">����</xsl:when>
	<xsl:when test=".=6">�����</xsl:when>
	<xsl:when test=".=12">���</xsl:when>
	<xsl:when test=".=-1">�����ڽ�</xsl:when>
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>
 
 <!-- �Ա�ע�⣺����     ���ո��Ű��õģ�����ȥ����-->
<xsl:template match="Sex">
<xsl:choose>
	<xsl:when test=".=0">��  </xsl:when>		
	<xsl:when test=".=1">Ů  </xsl:when>
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ������ȡ  -->
<xsl:template match="Risk[RiskCode=MainRiskCode]/BonusGetMode">
<xsl:choose>
	<xsl:when test=".=1">�ۼ���Ϣ</xsl:when>
	<xsl:when test=".=2">��ȡ�ֽ�</xsl:when>
	<xsl:when test=".=3">�ֽɱ���</xsl:when>
	<xsl:when test=".=5">�����</xsl:when>
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ���ؽɷѷ�ʽ -->
<xsl:template name="tran_PayIntv">
    <xsl:param name="PayIntv">0</xsl:param>
	<xsl:choose>
	    <xsl:when test="$PayIntv = 0">W</xsl:when>
		<xsl:when test="$PayIntv = 12">Y</xsl:when>
		<xsl:when test="$PayIntv = 1">M</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$PayIntv"/>
		</xsl:otherwise>
	</xsl:choose>
 </xsl:template>
 
<xsl:template match="Head/Flag">
<xsl:choose>
	<xsl:when test=".='0'">0000</xsl:when>
	<xsl:when test=".='1'">0001</xsl:when>
	<xsl:otherwise>
	    <xsl:value-of select="Head/Flag"/>
	</xsl:otherwise>
</xsl:choose>
</xsl:template>

	<!-- �ɷ����������־ -->
	<xsl:template name="tran_PayEndYearFlag">
		<xsl:param name="payendyearflag" />
		<xsl:param name="payendyear" />
		<xsl:choose>
			<xsl:when test="$payendyearflag='Y' and $payendyear=1000">1</xsl:when><!-- ���� -->
			<xsl:when test="$payendyearflag='Y'">2</xsl:when><!-- ���� -->
			<xsl:when test="$payendyearflag='A'">4</xsl:when><!-- �����ɷ� -->
			<xsl:when test="$payendyearflag='A'">3</xsl:when><!-- ����ĳȷ������ -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
