<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
 	exclude-result-prefixes="java">

	<xsl:output indent='yes'/>
	<xsl:template match="/TranData">
		<TranData>
			<!-- ����ͷ -->
			<xsl:copy-of select="Head" />
			<!-- ������ -->
			<xsl:apply-templates select="Body" />
		</TranData>
	</xsl:template>


	<xsl:template match="Body">
		<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]"/>
		<xsl:variable name="leftPadFlag" select="java:java.lang.Boolean.parseBoolean('true')" />
        <xsl:variable name="ContPlanMultWith0" select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(ContPlan/ContPlanMult,5,$leftPadFlag)"/>

		
		<App>
			<!-- ������Ϣ -->
			<Ret>
				<!-- ������ -->
				<PolicyNo>
					<xsl:value-of select="ContNo" />
				</PolicyNo>
				<!-- ����ӡˢ�� -->
				<VchNo>
					<xsl:value-of select="ContPrtNo" />
				</VchNo>
				<!-- ǩԼ���� -->
				<AcceptDate>
					<xsl:value-of select="$MainRisk/SignDate" />
				</AcceptDate>
				<!-- ������Ч���� -->
				<ValidDate>
					<xsl:value-of select="$MainRisk/CValiDate" />
				</ValidDate>
				<!-- ������ֹ���� -->
				<PolicyDuedate>
					<xsl:value-of select="$MainRisk/InsuEndDate" />
				</PolicyDuedate>
				<!-- �������� -->
				<DueDate>
					<xsl:value-of select="$MainRisk/PayEndDate" />
				</DueDate>
				<!-- ҵ��Ա���� -->
				<UserId></UserId>
				<!-- �ɷ��˻� -->
				<PayAccount></PayAccount>
				<!-- �ɷѽ�� -->
				<Prem>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" />
				</Prem>
				<!-- ������Ϣ -->
				<Risks>
					<!-- ������������ -->
					<Name>
						<xsl:value-of select="ContPlan/ContPlanName" />
					</Name>
					<!-- Ͷ������ -->
					<Share>
						<xsl:value-of select="ContPlan/ContPlanMult" />
					</Share>
					<!-- ���� -->
					<Prem>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/ActPrem)" />
					</Prem>
					<!-- �ɷ����� -->
					<PayDueDate>1</PayDueDate>
					<!-- �ɷѷ�ʽ -->
					<PayType>
						<xsl:apply-templates select="$MainRisk/PayIntv" />
					</PayType>
				</Risks>
				<!-- ���ִ�ӡ�б� -->
        		<Prnts>
        			<Count></Count>
 					<Prnt/>
					<Prnt/>
					<Prnt/>
					<Prnt/>
					<Prnt/>
					<Prnt/>
					<Prnt/>
					<Prnt/>
					<Prnt><xsl:text>������ ���յ����룺</xsl:text><xsl:value-of select="ContNo" /><xsl:text>-(00001��</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat($ContPlanMultWith0,')'),5)" />
					<xsl:text>                                      ��ֵ��λ�������Ԫ</xsl:text></Prnt>
					<Prnt>������------------------------------------------------------------------------------------------------</Prnt>
					<Prnt>
						<xsl:text>������Ͷ����������</xsl:text>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Appnt/Name, 29)"/>
						<xsl:text>֤�����ͣ�</xsl:text>
						<xsl:apply-templates select="Appnt/IDType"/>
						<xsl:text>        ֤�����룺</xsl:text>
						<xsl:value-of select="Appnt/IDNo"/>
					</Prnt>
					<Prnt>
						<xsl:text>�������������ˣ�</xsl:text>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name, 31)"/>
						<xsl:text>֤�����ͣ�</xsl:text>
						<xsl:apply-templates select="Insured/IDType"/>
						<xsl:text>        ֤�����룺</xsl:text>
						<xsl:value-of select="Insured/IDNo"/>
					</Prnt>
					<Prnt>������------------------------------------------------------------------------------------------------</Prnt>
					<Prnt>������------------------------------------------------------------------------------------------------</Prnt>
					<xsl:if test="count(Bnf) = 0">
					<Prnt><xsl:text>���������������ˣ�����                </xsl:text>
					   <xsl:text>����˳��1                   </xsl:text>
					   <xsl:text>���������100%</xsl:text></Prnt>
			        </xsl:if>
					<xsl:if test="count(Bnf)>0">
						<xsl:for-each select="Bnf">
							<Prnt>
								<xsl:text>���������������ˣ�</xsl:text>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>
								<xsl:text>����˳��</xsl:text>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Grade, 16)"/>
								<xsl:text>���������</xsl:text>
								<xsl:value-of select="Lot"/>
								<xsl:text>%</xsl:text>
							</Prnt>
						</xsl:for-each>
					</xsl:if>
					<Prnt>������------------------------------------------------------------------------------------------------</Prnt>
					<Prnt>��������������</Prnt>
					<Prnt>������------------------------------------------------------------------------------------------------</Prnt>
					<Prnt><xsl:text>��������     ������������                                        �������ս��\</xsl:text></Prnt>
					<Prnt><xsl:text>����������������������                     �����ڼ�    ��������    �ս�����\      ���շ�     ����Ƶ��</xsl:text></Prnt>
					<Prnt><xsl:text>��������������     ������                                          ����\����</xsl:text></Prnt>
					<Prnt>������------------------------------------------------------------------------------------------------</Prnt>
					<xsl:for-each select="Risk">
						<xsl:variable name="PayIntv" select="PayIntv"/>
						<xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
						<xsl:variable name="Prem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)"/>
						<Prnt>
							<xsl:choose>
								<xsl:when test="RiskCode='L12081'">
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
											<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-', 10)"/>
										</xsl:when>
										<xsl:when test="PayEndYearFlag = 'Y'">
											<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(PayEndYear, '��'), 10)"/>
										</xsl:when>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
											<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-',15)"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Amnt,15)"/>
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
								</xsl:when>
								<xsl:otherwise>
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
											<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('һ����', 10)"/>
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
								</xsl:otherwise>
							</xsl:choose>
						</Prnt>
					</xsl:for-each>
					<Prnt>������------------------------------------------------------------------------------------------------</Prnt>
					<Prnt>���������շѺϼƣ�<xsl:value-of select="ActSumPremText"/>��RMB<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>Ԫ����</Prnt>
					<Prnt>������------------------------------------------------------------------------------------------------</Prnt>
					<Prnt/>
					<Prnt>������------------------------------------------------------------------------------------------------</Prnt>
					<Prnt>���������յ��ر�Լ����</Prnt>
   		    		<Prnt>
   		    	    	<xsl:text>������    ������ı��ղ�ƷΪ���������Ӯ���ռƻ����������ڱ��պ�ͬ��Ч�������˱�������˾���˻����յ�</xsl:text>
   		    		</Prnt>
   		    		<Prnt>
   		    	    	<xsl:text>�������ֽ��ֵ��</xsl:text>
   		    		</Prnt>
   		    		<Prnt>
   		    	    	<xsl:text>������    ���������Ӯ1����ȫ���յ����ͬԼ����������ʱ�������պ�ͬЧ����ֹ�������պ�ͬͬʱ��ֹ����</xsl:text>
   		    		</Prnt>
   		    		<Prnt>
   		    	    	<xsl:text>�������������պ�ͬ�������պ�ͬ�������ڱ��ս�֮�͵�101.5%�Ľ��Զ�ת�밲��������������գ������ͣ�</xsl:text>
   		    		</Prnt>
   		    		<Prnt>
   		    	    	<xsl:text>�������ĸ����˻��У��������պ�ͬ�����������Զ�ת�������ʱ����Ч��</xsl:text>
   		    		</Prnt>
					<Prnt>������-------------------------------------------------------------------------------------------------</Prnt>
					<Prnt><xsl:text>���������պ�ͬ�������ڣ�</xsl:text><xsl:value-of  select="substring($MainRisk/PolApplyDate,1,4)"/>��<xsl:value-of  select="substring($MainRisk/PolApplyDate,5,2)"/>��<xsl:value-of  select="substring($MainRisk/PolApplyDate,7,2)"/>��<xsl:text>                               ���պ�ͬ��Ч���ڣ�</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,1,4)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,5,2)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,7,2)"/>��</Prnt>
					<Prnt/>
					<Prnt/>
					<Prnt><xsl:text>������Ӫҵ������</xsl:text><xsl:value-of select="ComName" /></Prnt>
					<Prnt/>
					<Prnt><xsl:text>������Ӫҵ��ַ��</xsl:text><xsl:value-of select="ComLocation" /></Prnt>
					<Prnt/>
					<Prnt><xsl:text>�������ͻ��������ߣ�95569                                            ��ַ��http://www.anbang-life.com</xsl:text></Prnt>
					<Prnt/>
					<Prnt><xsl:text>������Ϊȷ�����ı���Ȩ�棬�뼰ʱ�����ҹ�˾����绰����½��վ�򵽹�̨���в�ѯ����ʵ������Ϣ�����ڱ�����</xsl:text></Prnt>
					<Prnt><xsl:text>��������һ�������ϵ����ձ��������������յ�����֮����10��������״β�ѯ����</xsl:text></Prnt>
					<Prnt/>
					<Prnt><xsl:text>�����������������ƣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComName, 49)"/>ҵ������֤��ţ�<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComCertiCode, 20)"/></Prnt>
					<Prnt><xsl:text>����������������Ա��</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerName,49)"/>��ҵ�ʸ�֤��ţ�<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerCertiCode, 20)"/></Prnt>
				    <Prnt><xsl:text>�����������յ������и��ݱ��չ�˾����Ȩ�������ۣ���غ�ͬ�����ɱ��չ�˾�е���</xsl:text></Prnt>
				</Prnts>

				<Messages>
					<Count></Count>
					<xsl:if test="$MainRisk/CashValues/CashValue != ''"> 
						<!-- �����ֽ��ֵʱ����ӡ�ֽ��ֵ -->	
						<xsl:variable name="RiskCount" select="count(Risk)"/>
						<xsl:variable name="printmult1" select="concat('-(00001��',$ContPlanMultWith0)"/>
 	                    <xsl:variable name="printmult2" select="concat($printmult1,')')"/>
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
						<Prnt>���������յ����룺<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(ContNo,$printmult2), 60)"/>��ֵ��λ�������Ԫ </Prnt>
						<Prnt>������------------------------------------------------------------------------------------------------</Prnt>
						<Prnt>��������������������<xsl:value-of select="Insured/Name"/></Prnt>
			 	        <Prnt>
					    <xsl:text>�������������ƣ�              </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName,40)"/><xsl:value-of select="Risk[RiskCode!=MainRiskCode]/RiskName"/></Prnt>
				        <Prnt><xsl:text/>�������������ĩ                      �ֽ��ֵ                                �ֽ��ֵ</Prnt>
				   	       <xsl:variable name="EndYear" select="EndYear"/>
				        <xsl:for-each select="$MainRisk/CashValues/CashValue">
					    <xsl:variable name="EndYear" select="EndYear"/>
					    <Prnt>
							 <xsl:text/><xsl:text>����������</xsl:text>
							 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,28)"/>
							 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash), 'Ԫ'),40)"/>
							 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../../../Risk[RiskCode!=MainRiskCode]/CashValues/CashValue[EndYear=$EndYear]/Cash)"/>Ԫ</Prnt>
					    </xsl:for-each>
						<Prnt>������------------------------------------------------------------------------------------------------</Prnt>
						<Prnt/>
						<Prnt>��������ע��</Prnt>
						<Prnt>�����������ֽ��ֵΪ��Ӧ�������ĩ��ֵ����������ڵ��ֽ��ֵ���������򱾹�˾��ѯ��</Prnt>
						<Prnt>������------------------------------------------------------------------------------------------------</Prnt>		
					</xsl:if>
				</Messages>
			</Ret>
 		</App>
	</xsl:template>
	
	<!-- �ɷ�Ƶ�� -->
	<xsl:template match="PayIntv">
		<xsl:choose>
		    <xsl:when test=".='-1'">0</xsl:when><!--  ������ -->
		    <xsl:when test=".='0'">1</xsl:when><!--  ���� -->
			<xsl:when test=".='1'">2</xsl:when><!-- �½� -->
			<xsl:when test=".='3'">3</xsl:when><!-- ���� -->
			<xsl:when test=".='6'">4</xsl:when><!-- ���꽻 -->
			<xsl:when test=".='12'">5</xsl:when><!-- �꽻 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ֤�����͡�ע�⣺������  ���ո��Ű��õģ�����ȥ���� -->
	<xsl:template match="IDType">
	<xsl:choose>
		<xsl:when test=".=0">����֤</xsl:when>
		<xsl:when test=".=1">����  </xsl:when>
		<xsl:when test=".=2">����֤</xsl:when>
		<xsl:when test=".=3">����  </xsl:when>
		<xsl:when test=".=5">���ڲ�</xsl:when>
		<xsl:otherwise>--  </xsl:otherwise>
	</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>