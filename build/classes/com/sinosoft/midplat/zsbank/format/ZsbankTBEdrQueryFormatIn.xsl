<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="TranData">
		<TranData>
		    <!-- 报文头 -->
			<Head>
				<xsl:apply-templates select="Head" />
            </Head>
			<!-- 报文体 -->
			<Body>
				<xsl:apply-templates select="Body" />
			</Body>
		</TranData>
	</xsl:template>

	<xsl:template name="Headinfo" match="Head">
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
               <xsl:value-of select="//Head/NodeNo" />
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
               <xsl:value-of select="TranCom/@outcode" />
           </BankCode>
	</xsl:template>
	
	<!-- 报文体 -->
	<xsl:template name="Bodyinfo" match="Body" >	
		<!-- 保险单号，必填项 -->
		<ContNo>
			<xsl:value-of select="ContNo"/>
		</ContNo>
		<!-- 申请日期[yyyyMMdd]，必填项 -->
		<EdorAppDate>
			<xsl:value-of select="EdorAppDate"/>
		</EdorAppDate>
		<!-- 投保人证件类型，必填项 -->
		<AppntIDType>
			<xsl:apply-templates select="GovtIDTC"/>
		</AppntIDType>
		<!-- 投保人证件号码，必填项 -->
		<AppntIDNo>
			<xsl:value-of select="AppntIDNo"/>
		</AppntIDNo>
		<!-- 投保人姓名，必填项 -->
		<AppntName>
			<xsl:value-of select="AppntName"/>
		</AppntName>
		<!-- 被保人证件类型，必填项 -->
		<InsuredIDType>
			<xsl:apply-templates select="GovtIDTC"/>
		</InsuredIDType>
		<!-- 被保人证件号码，必填项 -->
		<InsuredIDNo>
			<xsl:value-of select="InsuredIDNo"/>
		</InsuredIDNo>
		<!-- 被保人姓名，必填项 -->
		<InsuredName>
			<xsl:value-of select="InsuredName"/>
		</InsuredName>
		<!-- 领款人姓名 -->
		<BankAccNo>
			<xsl:value-of select="BankAccNo"/>
		</BankAccNo>
		<!-- 领款人账号 -->
		<BankAccName >
			<xsl:value-of select="BankAccName"/>
		</BankAccName>
	</xsl:template>
		
	
	<!-- 证件类型【注意：“护照  ”空格排版用的，不能去掉】 -->
	<xsl:template name="GovtIDTC" match="GovtIDTC">
		<xsl:choose>
			<xsl:when test=".=0">身份证    </xsl:when>
			<xsl:when test=".=1">护照      </xsl:when>
			<xsl:when test=".=2">军官证    </xsl:when>
			<xsl:when test=".=3">驾照      </xsl:when>
			<xsl:when test=".=4">出生证明  </xsl:when>
			<xsl:when test=".=5">户口簿    </xsl:when>
			<xsl:when test=".=8">其他      </xsl:when>
			<xsl:when test=".=9">异常身份证</xsl:when>
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>			
</xsl:stylesheet>


	

