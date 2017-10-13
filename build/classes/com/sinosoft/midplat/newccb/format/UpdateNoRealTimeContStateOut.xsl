<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
<TX>
	<xsl:copy-of select="TranData/Head" />
	<TX_BODY>
		<ENTITY>
			<APP_ENTITY>
				<xsl:apply-templates select="TranData/Body"/>
			</APP_ENTITY>
		</ENTITY>
	</TX_BODY>
</TX>
</xsl:template>


<xsl:template match="Body">
	<!-- ѭ����¼���� -->
	<Rvl_Rcrd_Num><xsl:value-of select="Count" /></Rvl_Rcrd_Num>
	<Insu_List>
		<xsl:for-each select="Detail">
			<Insu_Detail>
				<!-- Ͷ������ -->
				<Ins_BillNo><xsl:value-of select="ProposalPrtNo"/></Ins_BillNo>
				<!-- �����պ�Լ״̬���� -->
				<AcIsAR_StCd>
					<xsl:if test="NonRTContState='-1' or NonRTContState='06'">
						<xsl:call-template name="tran_State">
							<xsl:with-param name="contState">
								<xsl:value-of select="ContState" />
							</xsl:with-param>
						</xsl:call-template>
					</xsl:if>
					<xsl:if test="NonRTContState!='-1' and NonRTContState!='06'">
						<xsl:call-template name="tran_nonRTContState">
							<xsl:with-param name="nonRTContState">
								<xsl:value-of select="NonRTContState" />
							</xsl:with-param>
						</xsl:call-template>
					</xsl:if>
					<!-- 
					<xsl:call-template name="tran_State">
						<xsl:with-param name="contState">
							<xsl:value-of select="ContState" />
						</xsl:with-param>
						<xsl:with-param name="nonRTContState">
							<xsl:value-of select="NonRTContState" />
						</xsl:with-param>
					</xsl:call-template>
					 -->
				</AcIsAR_StCd>
				<!-- add 20150820 ��һ��2.2�汾����  �˱���Ϣ-->
				<Uwrt_Inf></Uwrt_Inf>
				<!-- add 20150820 ��һ��2.2�汾����  �ܱ��ѽ��-->
				<Tot_InsPrem_Amt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)" /></Tot_InsPrem_Amt>
				<!-- add 20150820 ��һ��2.2�汾����  ���սɷѽ��-->
				<Ins_PyF_Amt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)" /></Ins_PyF_Amt>
				<!-- add 20150820 ��һ��2.2�汾����  �ɷѽ�ֹ����-->
				<PyF_CODt><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(NonRTPayEndDate)" /></PyF_CODt>
				<!-- add 20150820 ��һ��2.2�汾����  �������������� -->
				<xsl:if test="RiskCode='122009'" ><Ins_Yr_Prd_CgyCd>03</Ins_Yr_Prd_CgyCd></xsl:if>
				<!-- ����5�� -->
				<xsl:if test="RiskCode='L12087'" ><Ins_Yr_Prd_CgyCd>03</Ins_Yr_Prd_CgyCd></xsl:if>
				<xsl:if test="RiskCode!='122009' and RiskCode!='L12087'" >
				   <Ins_Yr_Prd_CgyCd>					
					  <xsl:call-template name="tran_PayEndYearFlag">
					       <xsl:with-param name="payEndYear" select="PayEndYear" />
					       <xsl:with-param name="payEndYearFlag" select="PayEndYearFlag" />
				       </xsl:call-template>
				   </Ins_Yr_Prd_CgyCd>			
				</xsl:if>
				<!-- add 20150820 ��һ��2.2�汾����  �������� -->
				<Ins_Ddln>
                      <xsl:if test="RiskCode='122046'" >999</xsl:if>
					   <xsl:if test="RiskCode!='122046'" >
					       <xsl:if test="InsuYearFlag='A'">999</xsl:if>
					       <xsl:if test="InsuYearFlag!='A'"><xsl:value-of select="InsuYear" /></xsl:if>  
					   </xsl:if>
				</Ins_Ddln>
				<!-- add 20150820 ��һ��2.2�汾����  �������ڴ��� -->
				<Ins_Cyc_Cd><xsl:apply-templates select="InsuYearFlag" /></Ins_Cyc_Cd>
				<!-- add 20150820 ��һ��2.2�汾����  ���ѽɷѷ�ʽ���� -->
				<InsPrem_PyF_MtdCd><xsl:apply-templates select="Payintv" mode="payintv"/></InsPrem_PyF_MtdCd>
				<!-- add 20150820 ��һ��2.2�汾����  ���ѽɷ����� -->
				<InsPrem_PyF_Prd_Num>
					<xsl:if test="InsuYearFlag!='A'">
					    <xsl:if test="PayEndYear = '1000'">
					        <xsl:if test="Payintv = '0'">1</xsl:if>
					        <xsl:if test="Payintv != '0'"><xsl:value-of select="PayEndYear" /></xsl:if>      
					    </xsl:if>
					    <xsl:if test="PayEndYear != '1000'">
					       <xsl:value-of select="PayEndYear" />    
					    </xsl:if>
					    <!-- 
					    <xsl:choose>
							<xsl:when test="PayEndYear = '1000'">1</xsl:when>
							<xsl:otherwise><xsl:value-of select="PayEndYear" /></xsl:otherwise>
						</xsl:choose>
					     -->
					</xsl:if>
					<xsl:if test="RiskCode='L12078'" >1</xsl:if>
					<xsl:if test="RiskCode='L12100'" >1</xsl:if>
					<xsl:if test="RiskCode='122010'" >1</xsl:if>
					<xsl:if test="RiskCode='L12089'" >1</xsl:if>
				</InsPrem_PyF_Prd_Num>
				<!-- add 20150820 ��һ��2.2�汾����  ���ѽɷ����ڴ��� -->
				<InsPrem_PyF_Cyc_Cd><xsl:apply-templates select="Payintv" mode="zhouqi"/></InsPrem_PyF_Cyc_Cd>
			</Insu_Detail>
		</xsl:for-each>
	</Insu_List>
</xsl:template>

<!-- ������Լ״̬ FIXME �ⲿ����Ҫ����Ĺ�ͨȷ�����ӳ���ϵ -->
<xsl:template name="tran_State">
	<xsl:param name="contState"></xsl:param>
	<xsl:choose><!-- ��˾����=�������� -->
		<xsl:when test="$contState='00'">076012</xsl:when>		<!-- ǩ���ѻ�ִ=��������Ч���ͻ���ǩ�� -->
		<xsl:when test="$contState='A'">076016</xsl:when>		<!-- �ܱ�������=���չ�˾�ܱ�(�˱�δͨ��) -->
		<xsl:when test="$contState='B'">076036</xsl:when>		<!-- ��ʵʱ�����ѽɷѴ���ȡ���� -->
		<xsl:when test="$contState='C'">076023</xsl:when>		<!-- ���ճ���=���ճ������� -->
		<xsl:when test="$contState='WT'">076024</xsl:when>		<!-- ��ԥ�����˱���ֹ=��ԥ���˱����� -->
		<xsl:when test="$contState='02'">076025</xsl:when>		<!-- �˱���ֹ=����ԥ���˱����� -->
		<xsl:when test="$contState='01'">076030</xsl:when>		<!-- ������ֹ=�����Ѹ��� -->
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:template>


<xsl:template name="tran_nonRTContState">
	<xsl:param name="nonRTContState"></xsl:param>
	<xsl:choose><!-- ��˾����=�������� -->
		<xsl:when test="$nonRTContState='08'">076011</xsl:when>	<!-- ǩ��δ��ִ=��������Ч���ͻ�δǩ�� -->
		<xsl:when test="$nonRTContState='06'">076012</xsl:when>	<!-- ǩ���ѻ�ִ=��������Ч���ͻ���ǩ�� -->
		<xsl:when test="$nonRTContState='00'">076014</xsl:when>	<!-- δ����=���չ�˾�ѽ��շ�ʵʱ�˱���Ϣ -->
		<xsl:when test="$nonRTContState='01'">076014</xsl:when>	<!-- ¼����=���չ�˾�ѽ��շ�ʵʱ�˱���Ϣ -->
		<xsl:when test="$nonRTContState='02'">076014</xsl:when>	<!-- �˱���=���չ�˾�ѽ��շ�ʵʱ�˱���Ϣ -->
		<xsl:when test="$nonRTContState='03'">076014</xsl:when>	<!-- ֪ͨ����ظ�=���չ�˾�ѽ��շ�ʵʱ�˱���Ϣ -->
		<xsl:when test="$nonRTContState='07'">076015</xsl:when>	<!-- ����=������������ -->
		<xsl:when test="$nonRTContState='05'">076016</xsl:when>	<!-- �ܱ�������=���չ�˾�ܱ�(�˱�δͨ��) -->
		<xsl:when test="$nonRTContState='04'">076019</xsl:when>	<!-- �˱�ͨ��=��ʵʱ�������չ�˾�˱�ͨ�����ɷ� -->
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:template>
<!-- �����ĽɷѼ��/Ƶ�� -->
<xsl:template match="Payintv" mode="payintv">
	<xsl:choose>
		<xsl:when test=".='0'">02</xsl:when><!--	���� -->
		<xsl:when test=".='12'">03</xsl:when><!-- �꽻 -->
		<xsl:when test=".='1'">03</xsl:when><!--	�½� -->
		<xsl:when test=".='3'">03</xsl:when><!--	���� -->
		<xsl:when test=".='6'">03</xsl:when><!--	���꽻 -->
		<xsl:when test=".='-1'">01</xsl:when><!-- �����ڽ� -->
		<xsl:otherwise></xsl:otherwise><!--	���� -->
	</xsl:choose>
</xsl:template>

<xsl:template name="tran_PayEndYearFlag">
	<xsl:param name="payEndYear" />
	<xsl:param name="payEndYearFlag" />
	<xsl:choose>
		<xsl:when test="$payEndYearFlag='Y' and $payEndYear!='1000'">03</xsl:when><!--������ -->
		<xsl:when test="$payEndYearFlag='M'">03</xsl:when><!--������ -->
		<xsl:when test="$payEndYearFlag='D'">03</xsl:when><!--������ -->
		<xsl:when test="$payEndYearFlag='A'">05</xsl:when><!--���� -->
		<xsl:when test="$payEndYearFlag='Y' and $payEndYear ='1000'">05</xsl:when><!--���� -->
		<xsl:otherwise></xsl:otherwise><!--	���� -->
	</xsl:choose>
</xsl:template>


<!-- �ɷ��������� -->
<xsl:template match="Payintv" mode="zhouqi">
	<xsl:choose>
		<xsl:when test=".='3'">0201</xsl:when><!--	���� -->
		<xsl:when test=".='6'">0202</xsl:when><!--	����� -->
		<xsl:when test=".='12'">0203</xsl:when><!--	��� -->
		<xsl:when test=".='1'">0204</xsl:when><!--	�½� -->
		<xsl:when test=".='0'">0100</xsl:when><!--	���� -->
		<xsl:otherwise></xsl:otherwise><!--	���� -->
	</xsl:choose>
</xsl:template>

<!-- ������������ -->
<xsl:template match="InsuYearFlag">
	<xsl:choose>
		<xsl:when test=".='Y'">03</xsl:when><!-- ���� -->
		<xsl:when test=".='M'">04</xsl:when><!-- ���� -->
		<xsl:when test=".='D'">05</xsl:when><!-- ���� -->
		<xsl:when test=".='A'">03</xsl:when><!-- ���� -->
		<xsl:otherwise>99</xsl:otherwise>
	</xsl:choose>
</xsl:template>
</xsl:stylesheet>



