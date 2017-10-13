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
                 <xsl:value-of select="TranCom/@outcode" />
            </BankCode>
	</xsl:template>
	
	<!-- 报文体 -->
	<xsl:template name="Body" match="Body" >	
		<!-- 保险单号-->
		<ContNo>
			<xsl:value-of select="ContNo"/>
		</ContNo>
		<!-- 险种代码 -->
		<RiskCode>
			<xsl:apply-templates select="PRODUCTID"  mode="risk"/>
		</RiskCode>
		<!-- 申请日期[yyyyMMdd] -->
		<EdorAppDate>
			<xsl:value-of select="EdorAppDate"/>
		</EdorAppDate>
		<!-- 申请号 -->
		<EdorAppNo>
			<xsl:value-of select="EdorAppNo"/>
		</EdorAppNo>
		<!-- 投保人证件类型 -->
		<AppntIDType>
			<xsl:apply-templates select="GovtIDTC"/>
		</AppntIDType>
		<!-- 投保人证件号码 -->
		<AppntIDNo>
			<xsl:value-of select="AppntIDNo"/>
		</AppntIDNo>
		<!-- 投保人姓名 -->
		<AppntName>
			<xsl:value-of select="AppntName"/>
		</AppntName>
		<!-- 银行账户 -->
		<BankAccNo>
			<xsl:value-of select="BankAccNo"/>
		</BankAccNo>
		<!-- 银行账户名 -->
		<BankAccName>
			<xsl:value-of select="BankAccName"/>
		</BankAccName>
		<!-- 贷款金额,单位是分 -->
		<LoanMoney>
			<xsl:value-of select="LoanMoney"/>
		</LoanMoney>
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
	
	<!-- 险种代码 -->
	<xsl:template match="PRODUCTID" mode="risk">
		<xsl:choose>
			<xsl:when test=".='122009'">122009</xsl:when><!-- 安邦黄金鼎5号两全保险（分红型）A款 -->
			<xsl:when test=".='122010'">L12100</xsl:when><!-- 安邦盛世3号终身寿险（万能型） -->
			<!-- xsl:when test=".='122010'">L12078</xsl:when>  --><!-- 安邦盛世3号终身寿险（万能型） -->
			<xsl:when test=".='122012'">L12079</xsl:when><!-- 安邦盛世2号终身寿险（万能型）  -->
			<xsl:when test=".='122036'">122036</xsl:when><!-- 安邦黄金鼎6号两全保险（分红型）A款 -->
			<xsl:when test=".='50002'">50015</xsl:when>  <!-- 安邦长寿稳赢保险计划  -->
			<xsl:when test=".='L12080'">L12080</xsl:when>  <!-- 安邦盛世1号终身寿险（万能型） -->
			<!--<xsl:when test=".='L12089'">L12089</xsl:when>-->  <!-- 安邦盛世1号终身寿险（万能型）B款 -->
			<xsl:when test=".='L12074'">L12074</xsl:when>  <!-- 安邦盛世9号两全保险（万能型） -->
			<xsl:when test=".='L12087'">L12087</xsl:when><!-- 安邦东风5号两全保险（万能型）  -->
			<xsl:when test=".='L12086'">L12086</xsl:when><!-- 安邦东风3号两全保险（万能型） 主险 -->
			<xsl:when test=".='L12085'">L12085</xsl:when><!-- 安邦东风2号两全保险（万能型） 主险 -->
            <xsl:when test=".='L12088'">L12088</xsl:when><!-- 安邦东风9号两全保险（万能型） 主险 -->
            <xsl:when test=".='L12091'">L12091</xsl:when><!-- 安邦汇赢1号年金保险A款-->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>		
</xsl:stylesheet>


	

