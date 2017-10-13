<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	<xsl:template match="TranData">
		<TranData>
			<Head>
				<xsl:copy-of select="Head/*"/>
			</Head>
			<Body>
				<Count>
					<xsl:value-of
						select="Body/Detail[LineNum='0']/Column[3]" />
				</Count>
				         
				<xsl:for-each select="Body/Detail[LineNum!='0']">
					<Detail> 
						<TranDate>
							<xsl:value-of select="../../Head/TranDate" />
						</TranDate>
						<!--  �����������  -->
						<NodeNo>
							<xsl:value-of select="Column[11]" />
						</NodeNo>
						<!--  ������ˮ��  -->
						<TranNo></TranNo>
						<!--Ͷ������-->
         				<ProposalPrtNo>
         					<xsl:value-of select="Column[1]" />
         				</ProposalPrtNo>
         				<!--Ͷ������/����-->
        			 	<AccNo>
        			 		<xsl:value-of select="Column[5]" />
        			 	</AccNo>
         				<!--Ͷ��������-->
         				<AppntName>
         					<xsl:value-of select="Column[2]" />
         				</AppntName>
         				<!--Ͷ����֤������-->
         				<AppntIDType>
         					<xsl:apply-templates select="Column[3]" />
         				</AppntIDType>
         				<!--Ͷ����֤����-->
         				<AppntIDNo>
         					<xsl:value-of select="Column[4]" />
         				</AppntIDNo>
         				<!-- ��������-->
						<SourceType>0</SourceType>
						<!--   ʵ�����-->
						<Prem>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(Column[8])" />
						</Prem>
						<!-- ���ֱ���  -->
         				<RiskCode>
         					<xsl:apply-templates select="Column[6]" />
         				</RiskCode>
					</Detail>
				</xsl:for-each>
			</Body>
		</TranData>

	</xsl:template>
	<!-- ֤������ -->
	<xsl:template match="Column[3]">
		<xsl:choose>
		      <xsl:when test=".='011'">0</xsl:when>	  <!-- ��һ���������֤         -->
			  <xsl:when test=".='021'">0</xsl:when>	  <!-- �ڶ����������֤         -->
			  <xsl:when test=".='031'">0</xsl:when>	  <!-- ��ʱ���֤               -->
			  <xsl:when test=".='042'">1</xsl:when>	  <!-- �й�����                 -->
			  <xsl:when test=".='056'">5</xsl:when>	  <!-- ���ڲ�                   -->
			  <xsl:when test=".='068'">8</xsl:when>	  <!-- ����ίԱ��֤��           -->
			  <xsl:when test=".='078'">8</xsl:when>	  <!-- ѧ��֤                   -->
			  <xsl:when test=".='083'">2</xsl:when>	  <!--  ����֤                  -->
			  <xsl:when test=".='098'">8</xsl:when>	  <!-- ���ݸɲ�����֤           -->
			  <xsl:when test=".='108'">8</xsl:when>	  <!-- ��������֤               -->
			  <xsl:when test=".='118'">8</xsl:when>	  <!-- ��ְ�ɲ�����֤           -->
			  <xsl:when test=".='128'">8</xsl:when>	  <!-- ����ѧԱ֤               -->
			  <xsl:when test=".='134'">2</xsl:when>	  <!-- �侯֤                   -->
			  <xsl:when test=".='137'">2</xsl:when>	  <!-- ����֤                   -->
			  <xsl:when test=".='148'">2</xsl:when>	  <!-- ʿ��֤                   -->
			  <xsl:when test=".='155'">6</xsl:when>	  <!-- ���ͨ��֤               -->
			  <xsl:when test=".='165'">6</xsl:when>	  <!-- ����ͨ��֤               -->
			  <xsl:when test=".='175'">7</xsl:when>	  <!-- ̨��ͨ��֤����Ч����֤�� -->
			  <xsl:when test=".='18A'">8</xsl:when>	  <!-- ��������þ���֤         -->
			  <xsl:when test=".='199'">8</xsl:when>	  <!-- ������뾳ͨ��֤         -->
			  <xsl:when test=".='202'">1</xsl:when>	  <!-- �������                 -->
			  <xsl:when test=".='218'">8</xsl:when>	  <!-- ����                     -->
			  <xsl:when test=".='210'">8</xsl:when>	  <!-- ���幤�̻�Ӫҵִ��       -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ���ִ��� -->
	<xsl:template match="Column[6]">
		<xsl:choose>
		      <xsl:when test=".='20000050'">122009</xsl:when>	  <!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A��  -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>