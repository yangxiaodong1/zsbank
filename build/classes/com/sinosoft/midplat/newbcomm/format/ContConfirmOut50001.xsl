<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
<Rsp>
	<xsl:apply-templates select="TranData/Head"/>
	<xsl:apply-templates select="TranData/Body"/>
</Rsp>
</xsl:template>

<xsl:template name="Transaction_Head" match="Head">
		<Head>
			<Flag>
				<xsl:value-of select="Flag" />
			</Flag><!-- 0��ʾ�ɹ���1��ʾʧ�� ��3ת��ʵʱ-->
			<Desc>
				<xsl:value-of select="Desc" />
			</Desc><!-- ʧ��ʱ�����ش�����Ϣ -->
		</Head>
</xsl:template>

<xsl:template name="Transaction_Body" match="Body">
<Body>
	<PolItem>
		<xsl:variable name="MainRisk1" select="Risk[RiskCode=MainRiskCode]"/>
		<!-- ������ -->
		<PolNo><xsl:value-of select="ContNo" /></PolNo>
		<!-- ����״̬:�ѽɷѲ��˱� -->
		<PolStat>1</PolStat>
		<!-- �ɷѽ�� -->
		<PayAmt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></PayAmt>
		<!-- �б����� -->
		<AcceptDate><xsl:value-of select="$MainRisk1/PolApplyDate" /></AcceptDate>
		<!-- ��Ч���� -->
		<ValiDate><xsl:value-of select="$MainRisk1/CValiDate" /></ValiDate>
		<!-- ��ֹ���� -->
		<xsl:choose>
			<xsl:when test="$MainRisk1/InsuYearFlag='A' and $MainRisk1/InsuYear=106">
				<InvaliDate>99991231</InvaliDate>
			</xsl:when>
			<xsl:otherwise>
				<InvaliDate><xsl:value-of select="$MainRisk1/InsuEndDate" /></InvaliDate>
			</xsl:otherwise>
		</xsl:choose>	
		<!-- ���ڽɷ����� -->
		<TermDate></TermDate>				
	</PolItem>
	<!-- ��Ϊ���棬����Ҫ��ӡ���� -->
	<NoteList />
	<PrtList>
		<Count>1</Count>
		<PrtItem>
			<VchId>1</VchId>
			<xsl:variable name="RiskName" select="ContPlan/ContPlanName" />
			<!-- ��ǰƾ֤����ʾ�ı�:��ҵ���ṩ -->
			<VchInfo><xsl:value-of select="$RiskName" />�հױ�����ÿ�ű���һʽ��������ӡ�ͻ�������дҵ������������</VchInfo>
			<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]"/>
			<Count>2</Count>			
			<PageItem>
				<PageId>1</PageId>
				<!-- ��ӡ��ҳǰ����ʾ��Ա׼����ҳ����:��ҵ���ṩ -->
				<PageInfo>��һҳ/����ҳ</PageInfo>			
				<!-- ��ǰҳ����������ÿҳ���֧��70�� -->
				<Count></Count>							
				<RowItem><RowId></RowId>
					<RowText><xsl:text> </xsl:text></RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText><xsl:text> </xsl:text></RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText><xsl:text> </xsl:text></RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText><xsl:text> </xsl:text></RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText><xsl:text> </xsl:text></RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText><xsl:text> </xsl:text></RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText><xsl:text>���������յ����룺</xsl:text><xsl:value-of select="ContNo" />
<xsl:text>                                           ��ֵ��λ�������Ԫ</xsl:text></RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText>������------------------------------------------------------------------------------------------------</RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText>
					<xsl:text>������Ͷ���ˣ�</xsl:text>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Appnt/Name, 33)"/>
					<xsl:text>֤�����ͣ�</xsl:text>
					<xsl:apply-templates select="Appnt/IDType"/>
					<xsl:text>       ֤�����룺</xsl:text>
					<xsl:value-of select="Appnt/IDNo"/>
				</RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText>
					<xsl:text>�������������ˣ�</xsl:text>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name, 31)"/>
					<xsl:text>֤�����ͣ�</xsl:text>
					<xsl:apply-templates select="Insured/IDType"/>
					<xsl:text>       ֤�����룺</xsl:text>
					<xsl:value-of select="Insured/IDNo"/>
				</RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText><xsl:text> </xsl:text></RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText>������------------------------------------------------------------------------------------------------</RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText>������------------------------------------------------------------------------------------------------</RowText>
				<Remark></Remark></RowItem>
				<xsl:if test="count(Bnf) = 0">
				<RowItem><RowId></RowId>
					<RowText><xsl:text>��������������ˣ�����                </xsl:text>
				   <xsl:text>����˳��1                   </xsl:text>
				   <xsl:text>���������100%</xsl:text></RowText>
				<Remark></Remark></RowItem>
		        </xsl:if>
				<xsl:if test="count(Bnf)>0">
					<xsl:for-each select="Bnf">
						<RowItem><RowId></RowId>
					<RowText>
							<xsl:text>��������������ˣ�</xsl:text>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>
							<xsl:text>����˳��</xsl:text>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Grade, 16)"/>
							<xsl:text>���������</xsl:text>
							<xsl:value-of select="Lot"/>
							<xsl:text>%</xsl:text>
						</RowText>
				<Remark></Remark></RowItem>
					</xsl:for-each>
				</xsl:if>
				<RowItem><RowId></RowId>
					<RowText>������------------------------------------------------------------------------------------------------</RowText>
				<Remark></Remark></RowItem>
				
				<RowItem><RowId></RowId>
					<RowText>��������������</RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText>������------------------------------------------------------------------------------------------------</RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText>
					<xsl:text>�������������������������������������������������������������������������ս��\</xsl:text>
				</RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText>
					<xsl:text>����������������������������               �����ڼ�    ��������     �ս�����\     ���շ�     ����Ƶ��</xsl:text>
				</RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText>
					<xsl:text>������������������������������������������������������������������������\����</xsl:text>
				</RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText>������------------------------------------------------------------------------------------------------</RowText>
				<Remark></Remark></RowItem>
				<xsl:for-each select="Risk">
					<xsl:variable name="PayIntv" select="PayIntv"/>
					<xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
					<xsl:variable name="ActPrem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)"/>
					<RowItem><RowId></RowId>
					<RowText>
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
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('һ�ν���', 11)"/>
							</xsl:when>
							<xsl:when test="PayEndYearFlag = 'Y'">
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(PayEndYear, '��'), 11)"/>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('�����ʻ���ֵ',14)"/>
							</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Amnt,14)"/>
						</xsl:otherwise>
						</xsl:choose>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($ActPrem,13)"/>
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
					</RowText>
				<Remark></Remark></RowItem>
				</xsl:for-each>
				<RowItem><RowId></RowId>
					<RowText>������------------------------------------------------------------------------------------------------</RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText><xsl:text> </xsl:text></RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText>���������շѺϼƣ�<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>Ԫ��Сд��</RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText><xsl:text> </xsl:text></RowText>
				<Remark></Remark></RowItem>
				<xsl:if test="$MainRisk/CashValues/CashValue != ''"> <!-- �����ֽ��ֵʱ����ӡ�ֽ��ֵ -->
			    <RowItem><RowId></RowId>
					<RowText>
		        		<xsl:text>�������ֺ챣�պ�����ȡ��ʽ���ۻ���Ϣ</xsl:text>
					</RowText>
				<Remark></Remark></RowItem>
		    	</xsl:if>
				<RowItem><RowId></RowId>
					<RowText><xsl:text> </xsl:text></RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText>������------------------------------------------------------------------------------------------------</RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText><xsl:text> </xsl:text></RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText>������------------------------------------------------------------------------------------------------</RowText>
				<Remark></Remark></RowItem>
				<xsl:variable name="SpecContent" select="SpecContent"/>
				<RowItem><RowId></RowId>
					<RowText>���������յ��ر�Լ����</RowText>
				<Remark></Remark></RowItem>
					<xsl:choose>
						<xsl:when test="$SpecContent=''">
							<RowItem><RowId></RowId>
					<RowText><xsl:text>���ޣ�</xsl:text></RowText>
				<Remark></Remark></RowItem>
						</xsl:when>
						<xsl:otherwise>
							<RowItem><RowId></RowId>
					<RowText>������    ������ı��ղ�ƷΪ���������Ӯ1����ȫ������ϡ��������ڱ��պ�ͬ��Ч�������˱�������˾��</RowText>
				<Remark></Remark></RowItem>
							<RowItem><RowId></RowId>
					<RowText>�������˻����յ��ֽ��ֵ��</RowText>
				<Remark></Remark></RowItem>
						</xsl:otherwise>
					</xsl:choose>
				<RowItem><RowId></RowId>
					<RowText><xsl:text> </xsl:text></RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText>������-------------------------------------------------------------------------------------------------</RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText><xsl:text>���������պ�ͬ�������ڣ�</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,1,4)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,5,2)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,7,2)"/>��<xsl:text>                               ���պ�ͬ��Ч���ڣ�</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,1,4)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,5,2)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,7,2)"/>��</RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText></RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText><xsl:text>������Ӫҵ������</xsl:text><xsl:value-of select="ComName" /></RowText>
				<Remark></Remark></RowItem>
			
				<RowItem><RowId></RowId>
					<RowText><xsl:text>������Ӫҵ��ַ��</xsl:text><xsl:value-of select="ComLocation" /></RowText>
				<Remark></Remark></RowItem>
				
				<RowItem><RowId></RowId>
					<RowText><xsl:text>�������ͻ��������ߣ�95569                                            ��ַ��http://www.anbang-life.com</xsl:text></RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText></RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText><xsl:text>������Ϊȷ�����ı���Ȩ�棬�뼰ʱ�����ҹ�˾����绰����½��վ�򵽹�̨���в�ѯ����ʵ������Ϣ�����ڱ�����</xsl:text></RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText><xsl:text>��������һ�������ϵ����ձ��������������յ�����֮����10��������״β�ѯ����</xsl:text></RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText></RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText><xsl:text>����������������Ա���ţ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(SellerNo, 45)"/><xsl:text>ҵ�����֤��ţ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComCertiCode, 20)"/></RowText>
				<Remark></Remark></RowItem>
				<RowItem><RowId></RowId>
					<RowText><xsl:text>����������������Ա��</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerName, 49)"/><xsl:text>��ҵ�ʸ�֤��ţ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerCertiCode, 20)"/></RowText>
				<Remark></Remark></RowItem>		
			</PageItem>
			<xsl:if test="$MainRisk/CashValues/CashValue != ''"> <!-- �����ֽ��ֵʱ����ӡ�ֽ��ֵ -->
				<xsl:variable name="RiskCount" select="count(Risk)"/>
				<PageItem>
					<PageId>2</PageId>
					<!-- ��ӡ��ҳǰ����ʾ��Ա׼����ҳ����:��ҵ���ṩ -->
					<PageInfo>�ڶ�ҳ/����ҳ</PageInfo>			
					<!-- ��ǰҳ����������ÿҳ���֧��70�� -->
					<Count></Count>
					<RowItem><RowId></RowId>
						<RowText><xsl:text> </xsl:text></RowText>
					<Remark></Remark></RowItem>
					<RowItem><RowId></RowId>
							<RowText><xsl:text> </xsl:text></RowText>
						<Remark></Remark></RowItem>
					<RowItem><RowId></RowId>
							<RowText><xsl:text> </xsl:text></RowText>
						<Remark></Remark></RowItem>
					<RowItem><RowId></RowId>
							<RowText><xsl:text> </xsl:text></RowText>
						<Remark></Remark></RowItem>
					<RowItem><RowId></RowId>
							<RowText><xsl:text> </xsl:text></RowText>
						<Remark></Remark></RowItem>
					<RowItem><RowId></RowId>
							<RowText><xsl:text> </xsl:text></RowText>
						<Remark></Remark></RowItem>
					<RowItem><RowId></RowId>
							<RowText><xsl:text> </xsl:text></RowText>
						<Remark></Remark></RowItem>
					<RowItem><RowId></RowId>
							<RowText><xsl:text> </xsl:text></RowText>
						<Remark></Remark></RowItem>
					<RowItem><RowId></RowId>
						<RowText><xsl:text>������                                        </xsl:text>�ֽ��ֵ��</RowText>
					<Remark></Remark></RowItem>
					<RowItem><RowId></RowId>
						<RowText><xsl:text> </xsl:text></RowText>
					<Remark></Remark></RowItem>
					<RowItem><RowId></RowId>
						<RowText>���������յ����룺<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(ContNo, 60)"/>��ֵ��λ�������Ԫ </RowText>
					<Remark></Remark></RowItem>
					<RowItem><RowId></RowId>
						<RowText>������------------------------------------------------------------------------------------------------</RowText>
					<Remark></Remark></RowItem>
					<RowItem><RowId></RowId>
						<RowText>��������������������<xsl:value-of select="Insured/Name"/></RowText>
					<Remark></Remark></RowItem>
	                <xsl:if test="$RiskCount=1">
			        <RowItem><RowId></RowId>
						<RowText>
				    <xsl:text>�������������ƣ�                  </xsl:text><xsl:value-of select="$MainRisk/RiskName"/></RowText>
					<Remark></Remark></RowItem>
			        <RowItem><RowId></RowId>
						<RowText><xsl:text/>�������������ĩ<xsl:text>                              </xsl:text>
					   <xsl:text>�ֽ��ֵ</xsl:text></RowText>
					<Remark></Remark></RowItem>
			   	       <xsl:variable name="EndYear" select="EndYear"/>
			        <xsl:for-each select="$MainRisk/CashValues/CashValue">
				    <xsl:variable name="EndYear" select="EndYear"/>
				    <RowItem><RowId></RowId>
						<RowText><xsl:text/><xsl:text>����������</xsl:text>
											<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,36)"/>
											<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)"/>Ԫ</RowText>
					<Remark></Remark></RowItem>
				    </xsl:for-each>
		            </xsl:if>
		 
		            <xsl:if test="$RiskCount!=1">
		 	        <RowItem><RowId></RowId>
						<RowText>
				    <xsl:text>�������������ƣ�          </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName,38)"/><xsl:value-of select="Risk[RiskCode!=MainRiskCode]/RiskName"/></RowText>
					<Remark></Remark></RowItem>
			        <RowItem><RowId></RowId>
						<RowText><xsl:text/>�������������ĩ<xsl:text>                                        </xsl:text>
					   <xsl:text>�ֽ��ֵ</xsl:text></RowText>
					<Remark></Remark></RowItem>
			   	       <xsl:variable name="EndYear" select="EndYear"/>
			        <xsl:for-each select="$MainRisk/CashValues/CashValue">
				    <xsl:variable name="EndYear" select="EndYear"/>
				    <RowItem><RowId></RowId>
						<RowText>
						 <xsl:text/><xsl:text>����������</xsl:text>
						 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,28)"/>
						 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash), 'Ԫ'),40)"/>
						 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../../../Risk[RiskCode!=MainRiskCode]/CashValues/CashValue[EndYear=$EndYear]/Cash)"/>Ԫ</RowText>
					<Remark></Remark></RowItem>
				    </xsl:for-each>
		            </xsl:if>
					<RowItem><RowId></RowId>
						<RowText>������------------------------------------------------------------------------------------------------</RowText>
					<Remark></Remark></RowItem>
					<RowItem><RowId></RowId>
						<RowText><xsl:text> </xsl:text></RowText>
					<Remark></Remark></RowItem>
					<RowItem><RowId></RowId>
						<RowText>��������ע��</RowText>
					<Remark></Remark></RowItem>
					<RowItem><RowId></RowId>
						<RowText>�����������ֽ��ֵΪ��Ӧ�������ĩ��ֵ����������ڵ��ֽ��ֵ���������򱾹�˾��ѯ��</RowText>
					<Remark></Remark></RowItem>
					<RowItem><RowId></RowId>
						<RowText>������------------------------------------------------------------------------------------------------</RowText>
					<Remark></Remark></RowItem>				
				</PageItem>
			</xsl:if>
		</PrtItem>
	</PrtList>	
</Body>
</xsl:template>
	<!-- ֤�����͡�ע�⣺������  ���ո��Ű��õģ�����ȥ���� -->
	<xsl:template match="IDType">
		<xsl:choose>
			<xsl:when test=".=0">���֤    </xsl:when>
			<xsl:when test=".=1">����      </xsl:when>
			<xsl:when test=".=2">����֤    </xsl:when>
			<xsl:when test=".=3">����      </xsl:when>
			<xsl:when test=".=4">����֤��  </xsl:when>
			<xsl:when test=".=5">���ڲ�    </xsl:when>
			<xsl:when test=".=8">����      </xsl:when>
			<xsl:when test=".=9">�쳣���֤</xsl:when>
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- �ɷѼ��  -->
	<xsl:template match="PayIntv">
		<xsl:choose>
			<xsl:when test=".=0">һ�ν���</xsl:when>
			<xsl:when test=".=1">�½�</xsl:when>
			<xsl:when test=".=3">����</xsl:when>
			<xsl:when test=".=6">���꽻</xsl:when>
			<xsl:when test=".=12">�꽻</xsl:when>
			<xsl:when test=".=-1">�����ڽ�</xsl:when>
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- �Ա�ע�⣺����     ���ո��Ű��õģ�����ȥ����-->
	<xsl:template match="Sex">
		<xsl:choose>
			<xsl:when test=".=0">��</xsl:when>
			<xsl:when test=".=1">Ů</xsl:when>
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
</xsl:stylesheet>