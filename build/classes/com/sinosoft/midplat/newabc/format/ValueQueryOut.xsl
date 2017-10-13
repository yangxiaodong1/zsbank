<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/TranData">
		<TranData>
			<xsl:copy-of select="Head" />
			<xsl:apply-templates select="Body" />
		</TranData>
	</xsl:template>

	<xsl:template match="Body">
		<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]"/>
		<App>
			<Ret>
				<!-- �˱��ɷ������ -->
				<Amt>
					<xsl:value-of
						select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Surr/GetMoney)" />
				</Amt>
				<!-- �˱������� -->
				<FeeAmt>
					<xsl:value-of
						select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Surr/GetCharge)" />
				</FeeAmt>
				<!-- ���������� -->
				<ExpireDate>
					<xsl:value-of
						select="$MainRisk/InsuEndDate" />
				</ExpireDate>
				<!-- �ֽ��ֵ��ӡ���� java�ж�̬��ֵ-->
				<PrntCount></PrntCount>
				<xsl:if test="$MainRisk/CashValues/CashValue != ''"> 
					<!-- �����ֽ��ֵʱ����ӡ�ֽ��ֵ -->	
					<xsl:variable name="RiskCount" select="count(Risk)"/>
				    <Prnt/>
					<Prnt/>
					<Prnt/>
					<Prnt/>
					<Prnt/>
					<Prnt/>
					<Prnt/>
					<Prnt/>
					<Prnt/>
					<Prnt><xsl:text>������                                        </xsl:text>�ֽ��ֵ��</Prnt>
					<Prnt/>
					<Prnt>���������յ����룺<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(ContNo, 60)"/>��ֵ��λ�������Ԫ </Prnt>
					<Prnt>������------------------------------------------------------------------------------------------------</Prnt>
					<Prnt>��������������������<xsl:value-of select="Insured/Name"/></Prnt>
	                <xsl:if test="$RiskCount=1">
				        <Prnt>
					    <xsl:text>�������������ƣ�                   </xsl:text><xsl:value-of select="$MainRisk/RiskName"/></Prnt>
				        <Prnt><xsl:text/>�������������ĩ<xsl:text>                              </xsl:text>
						   <xsl:text>�ֽ��ֵ</xsl:text></Prnt>
				   	       <xsl:variable name="EndYear" select="EndYear"/>
				        <xsl:for-each select="$MainRisk/CashValues/CashValue">
					    <xsl:variable name="EndYear" select="EndYear"/>
					    <Prnt><xsl:text/><xsl:text>����������</xsl:text>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,36)"/>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)"/>Ԫ</Prnt>
					    </xsl:for-each>
		            </xsl:if>
		 
		            <xsl:if test="$RiskCount!=1">
			 	        <Prnt>
					    <xsl:text>�������������ƣ�          </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName,40)"/><xsl:value-of select="Risk[RiskCode!=MainRiskCode]/RiskName"/></Prnt>
				        <Prnt><xsl:text/>�������������ĩ<xsl:text>                                        </xsl:text>
						   <xsl:text>�ֽ��ֵ</xsl:text></Prnt>
				   	       <xsl:variable name="EndYear" select="EndYear"/>
				        <xsl:for-each select="$MainRisk/CashValues/CashValue">
					    <xsl:variable name="EndYear" select="EndYear"/>
					    <Prnt>
							 <xsl:text/><xsl:text>����������</xsl:text>
							 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,24)"/>
							 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash), 'Ԫ'),40)"/>
							 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../../../Risk[RiskCode!=MainRiskCode]/CashValues/CashValue[EndYear=$EndYear]/Cash)"/>Ԫ</Prnt>
					    </xsl:for-each>
		            </xsl:if>
					<Prnt>������------------------------------------------------------------------------------------------------</Prnt>
					<Prnt/>
					<Prnt>��������ע��</Prnt>
					<Prnt>�����������ֽ��ֵΪ��Ӧ�������ĩ��ֵ����������ڵ��ֽ��ֵ���������򱾹�˾��ѯ��</Prnt>
					<Prnt>������------------------------------------------------------------------------------------------------</Prnt>		
				</xsl:if>
			</Ret>
		</App>
	</xsl:template>
</xsl:stylesheet>
