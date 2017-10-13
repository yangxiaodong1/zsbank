<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
<TranData>
	<xsl:apply-templates select="Transaction/Transaction_Header"/>
	
	<Body>
	   <!-- 
	   <Count><xsl:value-of select="Transaction/Transaction_Body/BkTotNum"/></Count>
       <Prem><xsl:value-of select="sum(Transaction/Transaction_Body/Detail_List/Detail/BkTotAmt)*100"/></Prem>
        --><!-- �˶�ע�ͣ��ڳ�����ƴ������Ϣ -->
	   <xsl:apply-templates select="Transaction/Transaction_Body/Detail_List/Detail"/>
	</Body>
</TranData>
</xsl:template>

<xsl:template name="Head" match="Transaction_Header">
<Head>
	<TranDate><xsl:value-of select="BkPlatDate"/></TranDate>
	<TranTime><xsl:value-of select="BkPlatTime"/></TranTime>
	<TellerNo><xsl:value-of select="BkTellerNo"/></TellerNo>
	<TranNo><xsl:value-of select="BkPlatSeqNo"/></TranNo>
	<NodeNo><xsl:value-of select="BkBrchNo"/></NodeNo>
	<xsl:copy-of select="../Head/*"/>
	<BankCode><xsl:value-of select="../Head/TranCom/@outcode"/></BankCode>
</Head>
</xsl:template>

<xsl:template name="Body" match="Detail">
<xsl:if test="BkOthTxCode = 'OPR011'"><!-- �µ����� -->
<Detail>
	<TranDate><xsl:value-of select="BkPlatDate10"/></TranDate>
	<TranNo><xsl:value-of select="BkOthSeq"/></TranNo>
	<ContNo><xsl:value-of select="PbInsuSlipNo"/></ContNo>
	<Prem><xsl:value-of select="BkTotAmt*100"/></Prem>
	<NodeNo><xsl:value-of select="BkPlatBrch"/></NodeNo>
	<TranType><xsl:value-of select="BkOthTxCode"/></TranType>
</Detail>
</xsl:if>

<xsl:if test="BkOthTxCode != 'OPR011'"><!-- ��ȫ���� -->
<Detail>
	<TranNo><xsl:value-of select="BkOthSeq"/></TranNo> <!-- ������ˮ�� -->
    <BankCode><xsl:value-of select="BkPlatBrch"/></BankCode> <!-- ����� -->
    <EdorType>
      <xsl:call-template name="tran_EdorType">
		 <xsl:with-param name="edortype">
		 	<xsl:value-of select="BkOthTxCode"/>
	     </xsl:with-param>
	  </xsl:call-template>
	</EdorType>  <!-- ��ȫ�������� -->
    <EdorAppNo><xsl:value-of select="BkVchNo"/></EdorAppNo> <!-- ��ȫ��������� -->
    <EdorNo><xsl:value-of select="BkVchNo"/></EdorNo> <!-- ��ȫ��������[�Ǳ���] -->
    <EdorAppDate><xsl:value-of select="BkPlatDate10"/></EdorAppDate> <!-- ��ȫ������������ YYYYMMDD-->
    <ContNo><xsl:value-of select="PbInsuSlipNo"/></ContNo> <!-- ������ -->
    <RiskCode><xsl:value-of select="PbInsuType"/></RiskCode> <!-- ���ִ���[�Ǳ���]������������յ� -->   
    <TranMoney><xsl:value-of select="BkTotAmt*100"/></TranMoney> <!-- ���׽�� ��λ���֣�1000000�ִ���10000Ԫ-->
    <AccNo></AccNo> <!-- �����˻�[�Ǳ���] -->
    <AccName></AccName> <!-- �˻�����[�Ǳ���] --> 
    <RCode>0</RCode> <!-- ��Ӧ�� 0�ɹ���1ʧ��-->
    <TranType><xsl:value-of select="BkOthTxCode"/></TranType>
</Detail>
</xsl:if>
</xsl:template>

<!-- ��ȫ����ת�� -->
<xsl:template name="tran_EdorType">
    <xsl:param name="edortype">0</xsl:param>
	<xsl:choose>
		<xsl:when test="$edortype = 'SPE010'">1</xsl:when>  <!-- �ͻ�ǩԼ -->
		<xsl:when test="$edortype = 'SPE013'">2</xsl:when>  <!-- �ͻ���Լ  -->
		<xsl:when test="$edortype = 'OPR002'">3</xsl:when>  <!-- ��ԥ���˱���ѯ  -->
		<xsl:when test="$edortype = 'OPR012'">4</xsl:when>  <!-- ��ԥ���˱�  -->
		<xsl:otherwise>OTHER</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
