<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
<Transaction>
	<xsl:copy-of select="TranData/Head" />
     <Transaction_Body>
		<xsl:apply-templates select="TranData/Body" />
	</Transaction_Body>
</Transaction>
</xsl:template>

<xsl:template name="Transaction_Body" match="Body">
<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]" />

<PbInsuType>
	<xsl:call-template name="tran_riskcode">
		<xsl:with-param name="riskcode" select="$MainRisk/MainRiskCode" />
	</xsl:call-template>
</PbInsuType>	
<PiEndDate><xsl:value-of select="$MainRisk/InsuEndDate" /></PiEndDate>
<PbFinishDate></PbFinishDate>
<LiDrawstring></LiDrawstring>
<LiCashValueCount>0</LiCashValueCount>	<!-- ���Ų���ȡ�˴����ּۺͺ�����ֱ����0 ���ʵ� -->
<LiBonusValueCount>0</LiBonusValueCount><!-- ���Ų���ȡ�˴����ּۺͺ�����ֱ����0 ���ʵ� -->
<PbInsuSlipNo><xsl:value-of select="ContNo" /></PbInsuSlipNo>
<BkTotAmt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)" /></BkTotAmt>
<LiSureRate></LiSureRate>
<PbBrokId></PbBrokId>
<LiBrokName></LiBrokName>
<LiBrokGroupNo></LiBrokGroupNo>
<BkOthName></BkOthName>
<BkOthAddr></BkOthAddr>
<PiCpicZipcode></PiCpicZipcode>
<PiCpicTelno></PiCpicTelno>
<xsl:if test="$MainRisk/CashValues/CashValue != ''"><!-- ������ֽ��ֵ��ʾ2ҳ -->
<BkFileNum>2</BkFileNum>
</xsl:if>
<xsl:if test="count($MainRisk/CashValues/CashValue) = 0"><!-- ���û���ֽ��ֵ��ʾ1ҳ -->
<BkFileNum>1</BkFileNum>
</xsl:if>
<Detail_List>
	<BkFileDesc>��������</BkFileDesc>
	<BkType1>010058000001</BkType1>	<!-- �ؿ����� -->
	<BkVchNo><xsl:value-of select="ContPrtNo" /></BkVchNo>
	<BkRecNum></BkRecNum>	<!-- ���ı��Ĵ�ӡ���� �����գ������渳ֵ�� -->
	<Detail>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1><xsl:text>�������������յ����룺</xsl:text><xsl:value-of select="ContNo" /><xsl:text>                                                    ��ֵ��λ�������Ԫ</xsl:text></BkDetail1>
		<BkDetail1>����������------------------------------------------------------------------------------------------------</BkDetail1>
		<BkDetail1>
			<xsl:text>����������Ͷ����������</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Appnt/Name, 29)" />
			<xsl:text>֤�����ͣ�</xsl:text><xsl:apply-templates select="Appnt/IDType" />
			<xsl:text>        ֤�����룺</xsl:text><xsl:value-of select="Appnt/IDNo" />
		</BkDetail1>
		<BkDetail1>
			<xsl:text>�����������������ˣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name, 31)" />
			<xsl:text>֤�����ͣ�</xsl:text><xsl:apply-templates select="Insured/IDType" />
			<xsl:text>        ֤�����룺</xsl:text><xsl:value-of select="Insured/IDNo" />
		</BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1>����������------------------------------------------------------------------------------------------------</BkDetail1>
		<BkDetail1>����������------------------------------------------------------------------------------------------------</BkDetail1>
		<xsl:if test="count(Bnf) = 0">
		<BkDetail1><xsl:text>������������������ˣ�����                </xsl:text>
				   <xsl:text>����˳��1                   </xsl:text>
				   <xsl:text>���������100%</xsl:text></BkDetail1>
		</xsl:if>
		<xsl:if test="count(Bnf)>0">
		<xsl:for-each select="Bnf">
		<BkDetail1>
			<xsl:text>������������������ˣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>
			<xsl:text>����˳��</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Grade, 16)"/>
			<xsl:text>���������</xsl:text><xsl:value-of select="Lot"/><xsl:text>%</xsl:text>
		</BkDetail1>
		</xsl:for-each>
		</xsl:if>
		<BkDetail1>����������------------------------------------------------------------------------------------------------</BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1>������������������</BkDetail1>
		<BkDetail1>����������------------------------------------------------------------------------------------------------</BkDetail1>
		<BkDetail1><xsl:text>��������������������������������              �����ڼ�    ��������    �������ս��    ���շ�    ����Ƶ��</xsl:text></BkDetail1>
		<BkDetail1>����������------------------------------------------------------------------------------------------------</BkDetail1>
		<xsl:for-each select="Risk">
		<xsl:variable name="PayIntv" select="PayIntv"/>
		<xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
		<xsl:variable name="Prem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)"/>
		<BkDetail1><xsl:text>����������</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 40)"/>
								<xsl:choose>
									<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('����', 8)"/>
									</xsl:when>
									<xsl:when test="InsuYearFlag = 'Y'">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '��'), 8)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '����'), 8)"/>
										<xsl:text></xsl:text>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="PayIntv = 0">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('һ�ν���', 12)"/>
									</xsl:when>
									<xsl:when test="PayEndYearFlag = 'Y'">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(PayEndYear, '��'), 12)"/>
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
		</BkDetail1>
		</xsl:for-each>
		<BkDetail1>����������------------------------------------------------------------------------------------------------</BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1>�������������շѺϼƣ�<xsl:value-of select="PremText" />��RMB<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)"/>Ԫ����</BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1>����������------------------------------------------------------------------------------------------------</BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1>����������------------------------------------------------------------------------------------------------</BkDetail1>
		<xsl:variable name="SpecContent" select="Risk[RiskCode=MainRiskCode]/SpecContent"/>
		<xsl:variable name="AppIDType" select="Appnt/IDType"/>
		<xsl:variable name="InsIDType" select="Insured/IDType"/>
		<BkDetail1>�������������յ��ر�Լ����<xsl:choose>
		                    <xsl:when test="$SpecContent!='' or $AppIDType='6' or $AppIDType='7' or $InsIDType='6' or $InsIDType='7'">
								<xsl:value-of select="$SpecContent"/>
							</xsl:when>
								<xsl:otherwise>
									<xsl:text>���ޣ�</xsl:text>
								</xsl:otherwise>
							</xsl:choose></BkDetail1>
		<BkDetail1></BkDetail1>
		<xsl:choose>
					<xsl:when test="$AppIDType='6' or $AppIDType='7' or $InsIDType='6' or $InsIDType='7'">
						<BkDetail1>
							<xsl:text>������       ����ͬ���ᵽ�ġ��۰Ļ���֤��Ϊ���۰ľ���������½ͨ��֤����ƣ�����ͬ���ᵽ�ġ�̨��֤��Ϊ��̨��</xsl:text>									
						</BkDetail1>
						<BkDetail1>
							<xsl:text>������    ����������½ͨ��֤����ơ�</xsl:text>
						</BkDetail1>
					</xsl:when>
					<xsl:otherwise>
						<BkDetail1/>
						<BkDetail1/>
					</xsl:otherwise>
		</xsl:choose>
		<BkDetail1>����������-------------------------------------------------------------------------------------------------</BkDetail1>
		<BkDetail1>
			<xsl:text>�������������պ�ͬ�������ڣ�</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,1,4)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,5,2)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,7,2)"/>��<xsl:text>                               ���պ�ͬ��Ч���ڣ�</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,1,4)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,5,2)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,7,2)"/>��</BkDetail1>
		<!--  -->
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1><xsl:text>����������Ӫҵ������</xsl:text><xsl:value-of select="ComName" /></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1><xsl:text>����������Ӫҵ��ַ��</xsl:text><xsl:value-of select="ComLocation" /></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1><xsl:text>�����������ͻ��������ߣ�95569                                            ��ַ��http://www.anbang-life.com</xsl:text></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1><xsl:text>����������Ϊȷ�����ı���Ȩ�棬�뼰ʱ�����ҹ�˾����绰����½��վ�򵽹�̨���в�ѯ����ʵ������Ϣ�����ڱ�����</xsl:text></BkDetail1>
		<BkDetail1><xsl:text>������������һ�������ϵ����ձ��������������յ�����֮����10��������״β�ѯ����</xsl:text></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1><xsl:text>���������������������ƣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComName,49)"/><xsl:text>����������Ա���ţ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(SellerNo, 0)"/></BkDetail1>	

	</Detail>
</Detail_List>
<xsl:if test="$MainRisk/CashValues/CashValue != ''">
 <Detail_List>
 	<xsl:variable name="RiskCount" select="count(Risk)"/>
 	<BkFileDesc>��������</BkFileDesc>
	<BkType1>010058000001</BkType1>	<!-- �ؿ����� -->
	<BkVchNo><xsl:value-of select="ContPrtNo" /></BkVchNo>
	<BkRecNum></BkRecNum>	<!-- ���ı��Ĵ�ӡ���� �����գ������渳ֵ�� -->
	<Detail>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1><xsl:text>������                                        </xsl:text>�ֽ��ֵ��</BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1>�������������յ����룺<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(ContNo, 60)"/>��ֵ��λ�������Ԫ </BkDetail1>
		<BkDetail1>����������------------------------------------------------------------------------------------------------</BkDetail1>
		<BkDetail1>������������������������<xsl:value-of select="Insured/Name"/></BkDetail1>
	<xsl:if test="$RiskCount=1">
		<BkDetail1>
			<xsl:text>�����������������ƣ�                  </xsl:text><xsl:value-of select="$MainRisk/RiskName"/></BkDetail1>
		<BkDetail1><xsl:text/>�����������������ĩ<xsl:text>                              </xsl:text>
				   <xsl:text>�ֽ��ֵ</xsl:text></BkDetail1>
		   	<xsl:variable name="EndYear" select="EndYear"/>
		   <xsl:for-each select="$MainRisk/CashValues/CashValue">
			 <xsl:variable name="EndYear" select="EndYear"/>
			   <BkDetail1><xsl:text/><xsl:text>����������</xsl:text>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,40)"/>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)"/>Ԫ</BkDetail1>
			</xsl:for-each>
	 </xsl:if>
	 
	 <xsl:if test="$RiskCount!=1">
	 	<BkDetail1>
			<xsl:text>�����������������ƣ�          </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName,38)"/><xsl:value-of select="Risk[RiskCode!=MainRiskCode]/RiskName"/></BkDetail1>
		<BkDetail1><xsl:text/>�����������������ĩ<xsl:text>                                        </xsl:text>
				   <xsl:text>�ֽ��ֵ</xsl:text></BkDetail1>
		   	<xsl:variable name="EndYear" select="EndYear"/>
		   <xsl:for-each select="$MainRisk/CashValues/CashValue">
			 <xsl:variable name="EndYear" select="EndYear"/>
			   <BkDetail1>
					  <xsl:text/><xsl:text>����������</xsl:text>
					 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,40)"/>
					 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash), 'Ԫ'),40)"/>
					 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../../../Risk[RiskCode!=MainRiskCode]/CashValues/CashValue[EndYear=$EndYear]/Cash)"/>Ԫ</BkDetail1>
			</xsl:for-each>
	 </xsl:if>
		<BkDetail1>����������------------------------------------------------------------------------------------------------</BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1>������������ע��</BkDetail1>
		<BkDetail1>���������������ֽ��ֵΪ��Ӧ�������ĩ��ֵ����������ڵ��ֽ��ֵ���������򱾹�˾��ѯ�� </BkDetail1>
		<BkDetail1>����������------------------------------------------------------------------------------------------------</BkDetail1>
    </Detail>
</Detail_List>
</xsl:if>
</xsl:template>

<!-- ֤�����͡�ע�⣺������  ���ո��Ű��õģ�����ȥ���� --><!-- ���ʵ� �������е����֤�����֣��������֤���룬����֤Ϊ�����ˣ��侯�����֤���ȵ� -->
<xsl:template match="IDType">
<xsl:choose>
	<xsl:when test=".=0">���֤    </xsl:when>
	<xsl:when test=".=1">����      </xsl:when>
	<xsl:when test=".=2">����֤    </xsl:when>
	<xsl:when test=".=3">����      </xsl:when>
	<xsl:when test=".=5">���ڲ�    </xsl:when>
	<xsl:when test=".=7">̨��֤    </xsl:when>
	<xsl:when test=".=6">�۰Ļ���֤</xsl:when>
	<xsl:otherwise>--  </xsl:otherwise>
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
	<xsl:when test=".=0">��  </xsl:when>		
	<xsl:when test=".=1">Ů  </xsl:when>
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template name="tran_riskcode">
<xsl:param name="riskcode" />
<xsl:choose>
	<xsl:when test="$riskcode='L12080'">L12080</xsl:when>	<!-- ����ʢ��1���������գ������ͣ� -->
	<xsl:when test="$riskcode='L12079'">122012</xsl:when>	<!-- ����ʢ��2���������գ������ͣ� -->
	<xsl:when test="$riskcode='L12078'">122010</xsl:when>	<!-- ����ʢ��3���������գ������ͣ� -->
	<xsl:when test="$riskcode='L12100'">122010</xsl:when>	<!-- ����ʢ��3���������գ������ͣ� -->
	<xsl:when test="$riskcode='L12073'">122029</xsl:when>	<!-- ����ʢ��5���������գ������ͣ� -->
	
	<xsl:when test="$riskcode='122009'">122009</xsl:when>	<!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A�� -->
	<xsl:when test="$riskcode='122036'">122036</xsl:when>	<!-- ����ƽ�6����ȫ���գ��ֺ��ͣ�A�� -->
	<xsl:when test="$riskcode='L12074'">122035</xsl:when>	<!-- ����ʢ��9����ȫ���գ������ͣ� -->
	
	<xsl:when test="$riskcode='122046'">122046</xsl:when>	<!-- �������Ӯ1����ȫ���� -->
	<xsl:when test="$riskcode='122047'">122047</xsl:when>	<!-- ����ӳ�����Ӯ��ȫ���� -->
	<xsl:when test="$riskcode='L12089'">L12089</xsl:when>	<!-- ����ʢ��1���������գ������ͣ�B��-->
	
	<xsl:when test="$riskcode='L12087'">L12087</xsl:when>	<!-- �����5����ȫ���գ������ͣ�-->
	<xsl:when test="$riskcode='L12086'">L12086</xsl:when>	<!-- �����3����ȫ���գ������ͣ�-->
	
	<xsl:when test="$riskcode='L12090'">122010</xsl:when>	<!-- ����ʢ��3���������գ������ͣ� �����㽭ר����Ʒ-->
	
	<xsl:when test="$riskcode='L12098'">122012</xsl:when>	<!-- ����ʢ��2���������գ������ͣ� ���ż��Ϸ���ר����Ʒ-->
	
	<!-- PBKINSR-1469 ���Ź��涫��9�� L12088 zx add 20160808 -->
	<xsl:when test="$riskcode='L12088'">L12088</xsl:when>
	<!-- PBKINSR-1458 ���Ź��涫��2�� L12085 zx add 20160808 -->
	<xsl:when test="$riskcode='L12085'">L12085</xsl:when>
	
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ��Ʒ��ϱ��� -->
<xsl:template name="tran_contPlanCode">
	<xsl:param name="contPlanCode"/>

	<xsl:choose>
		<!-- �������Ӯ1����ȫ�������:���գ�122046 - �������Ӯ1����ȫ����,�����գ�122047 - ����ӳ�����Ӯ��ȫ���� -->
		<xsl:when test="$contPlanCode='50015'">50002</xsl:when>
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
