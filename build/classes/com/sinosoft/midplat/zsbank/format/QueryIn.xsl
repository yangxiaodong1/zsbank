<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

	<xsl:template match="TranData">
		<TranData>
			<!-- 报文头 -->
			<Head>
				<xsl:copy-of select="//Head/*" />  <!-- 是指所有的包头信息吗？？ -->
            </Head>
			<!-- 报文体 -->
			<Body>
				<xsl:copy-of select="//Body/*" />
			</Body>
		</TranData>
	</xsl:template>
	
	<!-- 报文头信息 -->
	<xsl:template name="Head" match="Head">
		<!-- 报文头 -->
		   <!-- 交易日期[yyyyMMdd] -->
              <TranDate>
                 <xsl:value-of select="TranDate" />
              </TranDate>
              <!-- 交易时间[hhmmss] -->
              <TranTime>
                 <xsl:value-of select="TranTime" />
              </TranTime>
              <!-- 地区代码（银行为空不传值）-->
              <ZoneNo>
                 <xsl:value-of select="ZoneNo" />
              </ZoneNo>
              <!-- 银行网点 -->
              <NodeNo>
                  <xsl:value-of select="NodeNo" />
              </NodeNo>
              <!-- 柜员代码 -->
              <TellerNo>
                  <xsl:value-of select="TellerNo" />
              </TellerNo>
              <!-- 交易流水号 -->
              <TranNo>
                  <xsl:value-of select="TranNo" />
              </TranNo>
              <!-- 交易渠道：0-柜面 1- 网银 17-手机银行 --> 
              <SourceType >
                 <xsl:value-of select="SourceType" />
              </SourceType>
              <xsl:copy-of select="FuncFlag" />
		      <xsl:copy-of select="ClientIp" />
		      <xsl:copy-of select="TranCom" />
		      <BankCode>
                <xsl:value-of select="TranCom/@outcode" /> <!-- 这样/@书写规则是啥样的 TranCom/@outcode这个是怎么加载到的  -->
              </BankCode>
		      
	</xsl:template>
	
	<!-- 报文体信息 -->
	<xsl:template name="Body" match="Body">
		<!-- 报文体 -->
			<!-- 保险单号,必输项 -->
			<ContNo>
				<xsl:value-of select="ContNo" />
			</ContNo>
			<!-- 投保单(印刷)号，非必输项 -->
			<ProposalPrtNo>
				<xsl:value-of select="ProposalPrtNo" />
			</ProposalPrtNo> 
			<!-- 保全类型，非必输项 -->
			<EdorType>
				<xsl:value-of select="EdorType" /> <!-- 这个保全类型是加载下面的吗？ -->
			</EdorType>
	</xsl:template>
	
	<!-- 保全类型 -->
	<xsl:template name="Edor_Type" match="Edor_Type">
		<xsl:choose>
			<xsl:when test=".=CT">退保    </xsl:when>
			<xsl:when test=".=MQ">满期    </xsl:when>
			<xsl:when test=".=XQ">续期    </xsl:when>
			<xsl:when test=".=WT">犹退    </xsl:when>
			<xsl:when test=".=PN">提现    </xsl:when>
			<xsl:when test=".=CA">修改客户信息</xsl:when>
			<xsl:when test=".=BL">保单质押冻结</xsl:when>
			<xsl:when test=".=BD">保单质押解冻</xsl:when>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
