<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:java="http://xml.apache.org/xslt/java" 
    exclude-result-prefixes="java">
    
	<xsl:template match="/TranData">
		<RETURN>
		    <xsl:if test="Head/Flag='0'">
		       <ACKSTS>0</ACKSTS>
		       <STSDESC>����</STSDESC>
		       <BUSI>
                 <SUBJECT>1</SUBJECT>
                 <TRANS></TRANS>
                 <PRINT>
                   <xsl:variable name="leftPadFlag" select="java:java.lang.Boolean.parseBoolean('true')" />
                   <xsl:variable name="ContPlanMultWith0" select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(Body/ContPlan/ContPlanMult,5,$leftPadFlag)"/>
                   <xsl:variable name="printmult1" select="concat('-(00001��',$ContPlanMultWith0)"/>
 	               <xsl:variable name="printmult2" select="concat($printmult1,')')"/>				   				
				    <PRINT_LINE/>
				    <PRINT_LINE/>
				    <PRINT_LINE><xsl:text>���յ����룺</xsl:text><xsl:value-of select="Body/ContNo" /><xsl:text>-(00001��</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat($ContPlanMultWith0,')'),5)" />
				    <xsl:text>                                  ��ֵ��λ�������Ԫ</xsl:text></PRINT_LINE>
				    <PRINT_LINE>------------------------------------------------------------------------------------------------</PRINT_LINE>
				    <PRINT_LINE>
					   <xsl:text>Ͷ����������</xsl:text>
					   <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Body/Appnt/Name, 29)"/>
					   <xsl:text>֤�����ͣ�</xsl:text>
					   <xsl:call-template name="tran_idtype">
							<xsl:with-param name="idtype">
								<xsl:value-of select="Body/Appnt/IDType"/>
							</xsl:with-param>
						</xsl:call-template>
					   <!--  <xsl:apply-templates select="Body/Appnt/IDType"/> -->
					   <xsl:text>       ֤�����룺</xsl:text>
					   <xsl:value-of select="Body/Appnt/IDNo"/>
				    </PRINT_LINE>
				    <PRINT_LINE>
					   <xsl:text>�������ˣ�</xsl:text>
					   <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Body/Insured/Name, 31)"/>
					   <xsl:text>֤�����ͣ�</xsl:text>
					   <xsl:call-template name="tran_idtype">
							<xsl:with-param name="idtype">
								<xsl:value-of select="Body/Insured/IDType"/>
							</xsl:with-param>
						</xsl:call-template>
					  <!--   <xsl:apply-templates select="Body/Insured/IDType"/>-->
					   <xsl:text>       ֤�����룺</xsl:text>
					   <xsl:value-of select="Body/Insured/IDNo"/>
				    </PRINT_LINE>
				    <PRINT_LINE/>
				    <PRINT_LINE>------------------------------------------------------------------------------------------------</PRINT_LINE>
				    <PRINT_LINE>------------------------------------------------------------------------------------------------</PRINT_LINE>
				    <xsl:if test="count(Body/Bnf) = 0">
				    <PRINT_LINE><xsl:text>��������ˣ�����                </xsl:text>
				       <xsl:text>����˳��1                   </xsl:text>
				       <xsl:text>���������100%</xsl:text></PRINT_LINE>
		            </xsl:if>
				    <xsl:if test="count(Body/Bnf)>0">
					   <xsl:for-each select="Body/Bnf">
						  <PRINT_LINE>
							<xsl:text>��������ˣ�</xsl:text>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>
							<xsl:text>����˳��</xsl:text>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Grade, 16)"/>
							<xsl:text>���������</xsl:text>
							<xsl:value-of select="Lot"/>
							<xsl:text>%</xsl:text>
						 </PRINT_LINE>
					   </xsl:for-each>
				    </xsl:if>
				    <PRINT_LINE>------------------------------------------------------------------------------------------------</PRINT_LINE>
				
				    <PRINT_LINE>��������</PRINT_LINE>
				    <PRINT_LINE>------------------------------------------------------------------------------------------------</PRINT_LINE>
				    <PRINT_LINE>
					   <xsl:text>�������������������������������������������������������������������ս��\</xsl:text>
				    </PRINT_LINE>
				    <PRINT_LINE>
					   <xsl:text>����������������������               �����ڼ�    ��������     �ս�����\     ���շ�     ����Ƶ��</xsl:text>
				    </PRINT_LINE>
				    <PRINT_LINE>
					   <xsl:text>������������������������������������������������������������������\����</xsl:text>
				    </PRINT_LINE>
				    <PRINT_LINE>------------------------------------------------------------------------------------------------</PRINT_LINE>
				    <xsl:for-each select="Body/Risk">
					   <xsl:variable name="PayIntv" select="PayIntv"/>
					   <xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
					   <xsl:variable name="Prem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)"/>
					   <xsl:choose>
						  <xsl:when test="RiskCode='L12081'">
						      <PRINT_LINE>
								<xsl:text>������</xsl:text>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 40)"/>
								<xsl:choose>
									<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('����', 11)"/>
									</xsl:when>
									<xsl:when test="InsuYearFlag = 'Y'">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '��'), 11)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '����'), 11)"/>
										<xsl:text/>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="PayIntv = 0">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-', 11)"/>
									</xsl:when>
									<xsl:when test="PayEndYearFlag = 'Y'">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(PayEndYear, '��'), 11)"/>
									</xsl:when>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-',14)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Amnt,14)"/>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-',13)"/>
								<xsl:choose>
									<xsl:when test="PayIntv = 0">
										<xsl:text>-</xsl:text>
									</xsl:when>
									<xsl:when test="PayIntv = 12">
										<xsl:text>���</xsl:text>
									</xsl:when>
									<xsl:when test="PayIntv = 6">
										<xsl:text>�����</xsl:text>
									</xsl:when>
									<xsl:when test="PayIntv = 3">
										<xsl:text>����</xsl:text>
									</xsl:when>
									<xsl:when test="PayIntv = 1">
										<xsl:text>�½�</xsl:text>
									</xsl:when>
									<xsl:when test="PayIntv = -1">
										<xsl:text>�����ڽ�</xsl:text>
									</xsl:when>
								</xsl:choose>
							</PRINT_LINE>
						  </xsl:when>
						  <xsl:otherwise>
						     <PRINT_LINE>
						  <xsl:text></xsl:text>
						  <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 40)"/>
						  <xsl:choose>
							 <xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('����', 11)"/>
							 </xsl:when>
							 <xsl:when test="InsuYearFlag = 'Y'">
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '��'), 11)"/>
							 </xsl:when>
							 <xsl:otherwise>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '����'), 11)"/>
								<xsl:text/>
							 </xsl:otherwise>
						  </xsl:choose>
						  <xsl:choose>
							 <xsl:when test="PayIntv = 0">
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('һ�ν���', 10)"/>
							 </xsl:when>
							 <xsl:when test="PayEndYearFlag = 'Y'">
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(PayEndYear, '��'), 10)"/>
							 </xsl:when>
						  </xsl:choose>
						  <xsl:choose>
							 <xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('�����ʻ���ֵ',15)"/>
							 </xsl:when>
							 <xsl:otherwise>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Amnt,15)"/>
							 </xsl:otherwise>
						  </xsl:choose>
						  <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Prem,13)"/>
						  <xsl:choose>
							 <xsl:when test="PayIntv = 0">
								<xsl:text>����</xsl:text>
							 </xsl:when>
							 <xsl:when test="PayIntv = 12">
								<xsl:text>���</xsl:text>
							 </xsl:when>
							 <xsl:when test="PayIntv = 6">
								<xsl:text>�����</xsl:text>
							 </xsl:when>
							 <xsl:when test="PayIntv = 3">
								<xsl:text>����</xsl:text>
							 </xsl:when>
							 <xsl:when test="PayIntv = 1">
								<xsl:text>�½�</xsl:text>
							 </xsl:when>
							 <xsl:when test="PayIntv = -1">
								<xsl:text>�����ڽ�</xsl:text>
							 </xsl:when>
						 </xsl:choose>
					  </PRINT_LINE>
					      </xsl:otherwise>
					   </xsl:choose> 
				   </xsl:for-each>
				   <PRINT_LINE>------------------------------------------------------------------------------------------------</PRINT_LINE>
				   <PRINT_LINE/>
				   <PRINT_LINE>���շѺϼƣ�<xsl:value-of select="Body/ActSumPremText" />��RMB<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/ActSumPrem)"/>Ԫ����</PRINT_LINE>
				   <PRINT_LINE/>
				   <PRINT_LINE/>
				   <PRINT_LINE>------------------------------------------------------------------------------------------------</PRINT_LINE>
				   <PRINT_LINE/>	 
				   <PRINT_LINE>������<xsl:if test="Body/Risk[RiskCode=MainRiskCode]/RiskType='2'">�ֺ챣�պ�����ȡ��ʽ���ۻ���Ϣ</xsl:if></PRINT_LINE>
				   <PRINT_LINE>------------------------------------------------------------------------------------------------</PRINT_LINE>
				 	<PRINT_LINE>���յ��ر�Լ����</PRINT_LINE>
					<PRINT_LINE>������ı��ղ�ƷΪ���������Ӯ���ռƻ����������ڱ��պ�ͬ��Ч�������˱�������˾���˻����յ�</PRINT_LINE>
					<PRINT_LINE>�ֽ��ֵ��</PRINT_LINE>
					<PRINT_LINE>���������Ӯ1����ȫ���յ����ͬԼ����������ʱ�������պ�ͬЧ����ֹ�������պ�ͬͬʱ��ֹ����</PRINT_LINE>
					<PRINT_LINE>�������պ�ͬ�������պ�ͬ�������ڱ��ս�֮�͵�101.5%�Ľ��Զ�ת�밲��������������գ������ͣ�</PRINT_LINE>
					<PRINT_LINE>�ĸ����˻��У��������պ�ͬ�����������Զ�ת�������ʱ����Ч��</PRINT_LINE>
					<PRINT_LINE/>
				   <PRINT_LINE>------------------------------------------------------------------------------------------------</PRINT_LINE>
				   <PRINT_LINE><xsl:text>���պ�ͬ�������ڣ�</xsl:text><xsl:value-of  select="substring(Body/Risk[RiskCode=MainRiskCode]/PolApplyDate,1,4)"/>��<xsl:value-of  select="substring(Body/Risk[RiskCode=MainRiskCode]/PolApplyDate,5,2)"/>��<xsl:value-of  select="substring(Body/Risk[RiskCode=MainRiskCode]/PolApplyDate,7,2)"/>��<xsl:text>                               ���պ�ͬ��Ч���ڣ�</xsl:text><xsl:value-of  select="substring(Body/Risk[RiskCode=MainRiskCode]/CValiDate,1,4)"/>��<xsl:value-of  select="substring(Body/Risk[RiskCode=MainRiskCode]/CValiDate,5,2)"/>��<xsl:value-of  select="substring(Body/Risk[RiskCode=MainRiskCode]/CValiDate,7,2)"/>��</PRINT_LINE>
				   <PRINT_LINE></PRINT_LINE>
				   <PRINT_LINE><xsl:text>Ӫҵ������</xsl:text><xsl:value-of select="Body/ComName" /></PRINT_LINE>
				
				   <PRINT_LINE><xsl:text>Ӫҵ��ַ��</xsl:text><xsl:value-of select="Body/ComLocation" /></PRINT_LINE>
				
				   <PRINT_LINE><xsl:text>�ͻ��������ߣ�95569                                            ��ַ��http://www.anbang-life.com</xsl:text></PRINT_LINE>
				   <PRINT_LINE></PRINT_LINE>
				   <PRINT_LINE><xsl:text>Ϊȷ�����ı���Ȩ�棬�뼰ʱ�����ҹ�˾����绰����½��վ�򵽹�̨���в�ѯ����ʵ������Ϣ�����ڱ�����</xsl:text></PRINT_LINE>
				   <PRINT_LINE><xsl:text>��һ�������ϵ����ձ��������������յ�����֮����10��������״β�ѯ����</xsl:text></PRINT_LINE>
				   <PRINT_LINE></PRINT_LINE>
				   <PRINT_LINE><xsl:text>�����������ƣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Body/AgentComName, 49)"/><xsl:text>����������Ա��</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Body/TellerName, 49)"/></PRINT_LINE>
                   <xsl:variable name="MainRisk" select="Body/Risk[RiskCode=MainRiskCode]"/>
                   <xsl:if test="$MainRisk/CashValues/CashValue != ''"> <!-- �����ֽ��ֵʱ����ӡ�ֽ��ֵ -->	

                  <xsl:variable name="RiskCount" select="count(Risk)"/>				
				   <PRINT_LINE/>
					<PRINT_LINE/>
					<PRINT_LINE/>
					<PRINT_LINE/>
					<PRINT_LINE/>
					<PRINT_LINE/>
					<PRINT_LINE><xsl:text>������                                        </xsl:text>�ֽ��ֵ��</PRINT_LINE>
					<PRINT_LINE/>
					<PRINT_LINE>���յ����룺<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(Body/ContNo,$printmult2), 60)"/>��ֵ��λ�������Ԫ </PRINT_LINE>
					<PRINT_LINE>------------------------------------------------------------------------------------------------</PRINT_LINE>
					<PRINT_LINE>��������������<xsl:value-of select="Body/Insured/Name"/></PRINT_LINE>
	                <xsl:if test="$RiskCount=1">
			        <PRINT_LINE>
				    <xsl:text>�������ƣ�                  </xsl:text><xsl:value-of select="$MainRisk/RiskName"/></PRINT_LINE>
			        <PRINT_LINE><xsl:text/>�������������ĩ<xsl:text>                              </xsl:text>
					   <xsl:text>�ֽ��ֵ</xsl:text></PRINT_LINE>
			   	       <xsl:variable name="EndYear" select="EndYear"/>
			        <xsl:for-each select="$MainRisk/CashValues/CashValue">
				    <xsl:variable name="EndYear" select="EndYear"/>
				    <PRINT_LINE><xsl:text/><xsl:text>����</xsl:text>
											<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,36)"/>
											<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)"/>Ԫ</PRINT_LINE>
				    </xsl:for-each>
		            </xsl:if>
		 
		            <xsl:if test="$RiskCount!=1">
		 	        <PRINT_LINE>
				    <xsl:text>�������ƣ�          </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName,38)"/><xsl:value-of select="Body/Risk[RiskCode!=MainRiskCode]/RiskName"/></PRINT_LINE>
			        <PRINT_LINE><xsl:text/>�������ĩ<xsl:text>                 </xsl:text>
					   <xsl:text>�ֽ��ֵ                                �ֽ��ֵ</xsl:text></PRINT_LINE>
			   	       <xsl:variable name="EndYear" select="EndYear"/>
			        <xsl:for-each select="$MainRisk/CashValues/CashValue">
				    <xsl:variable name="EndYear" select="EndYear"/>
				    <PRINT_LINE>
						 <xsl:text/><xsl:text>����</xsl:text>
						 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,23)"/>
						 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash), 'Ԫ'),40)"/>
						 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../../../Risk[RiskCode!=MainRiskCode]/CashValues/CashValue[EndYear=$EndYear]/Cash)"/>Ԫ</PRINT_LINE>
				    </xsl:for-each>
		            </xsl:if>
					<PRINT_LINE>------------------------------------------------------------------------------------------------</PRINT_LINE>
					<PRINT_LINE/>
					<PRINT_LINE>��ע��</PRINT_LINE>
					<PRINT_LINE>�����ֽ��ֵΪ��Ӧ�������ĩ��ֵ����������ڵ��ֽ��ֵ���������򱾹�˾��ѯ��</PRINT_LINE>
					<PRINT_LINE>------------------------------------------------------------------------------------------------</PRINT_LINE>
			</xsl:if>
                 </PRINT>
               </BUSI>		   
		    </xsl:if>
		    <xsl:if test="Head/Flag!='0'">
		       <ACKSTS>0</ACKSTS>
		       <STSDESC>����</STSDESC>
		       <BUSI>
                 <SUBJECT>1</SUBJECT>
                 <TRANS></TRANS>
                 <CONTENT>
                    <!-- �ܱ�ԭ�����,����Ϊ0000 -->
                    <REJECT_CODE>0001</REJECT_CODE>
                    <!-- �ܱ�ԭ��˵�� -->
                    <REJECT_DESC><xsl:value-of select="Head/Desc"/></REJECT_DESC>
		         </CONTENT>
		        </BUSI>	        
		    </xsl:if>		
		</RETURN>
				
	</xsl:template>
	
<!-- ֤������ -->
<xsl:template name="tran_idtype">
<xsl:param name="idtype" />
<xsl:choose>
	<xsl:when test="$idtype='0'">���֤</xsl:when>	<!-- ���֤ -->
	<xsl:when test="$idtype='1'">����</xsl:when>	<!-- ���� -->
	<xsl:when test="$idtype='2'">����֤</xsl:when>	<!-- ����֤ -->
	<xsl:when test="$idtype='2'">�侯֤</xsl:when>	<!-- �侯֤-����֤ -->
	<xsl:when test="$idtype='6'">�۰ľ��������ڵ�ͨ��֤</xsl:when>	<!-- �۰ľ��������ڵ�ͨ��֤ -->
	<xsl:when test="$idtype='5'">���ڲ�</xsl:when>	<!-- ���ڲ� -->
	<xsl:when test="$idtype='8'">����</xsl:when>	<!-- ���� -->
	<xsl:when test="$idtype='2'">����֤</xsl:when>	<!-- ����֤-����֤ -->
	<xsl:when test="$idtype='8'">ִ�й���֤</xsl:when>	<!-- ִ�й���֤-���� -->	
	<xsl:when test="$idtype='8'">ʿ��֤</xsl:when>	<!-- ʿ��֤-���� -->
	<xsl:when test="$idtype='7'">̨�����������½ͨ��֤</xsl:when>	<!-- ̨�����������½ͨ��֤ -->
	<xsl:when test="$idtype='0'">��ʱ���֤</xsl:when>	<!-- ��ʱ���֤-���֤ -->
	<xsl:when test="$idtype='8'">����˾���֤</xsl:when>	<!-- ����˾���֤-���� -->
	<xsl:otherwise>7</xsl:otherwise>
</xsl:choose>
</xsl:template>
	
</xsl:stylesheet>