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
<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]"/>

<PbInsuType>
	<xsl:call-template name="tran_ContPlanCode">
		<xsl:with-param name="contPlanCode" select="$MainRisk/MainRiskCode" />
	</xsl:call-template>
</PbInsuType>	
<PiEndDate><xsl:value-of select="$MainRisk/InsuEndDate" /></PiEndDate>

<PbFinishDate></PbFinishDate>
<LiDrawstring></LiDrawstring>
<LiCashValueCount>0</LiCashValueCount>	<!-- ���Ų���ȡ�˴����ּۺͺ�����ֱ����0 ���ʵ� -->
<LiBonusValueCount>0</LiBonusValueCount><!-- ���Ų���ȡ�˴����ּۺͺ�����ֱ����0 ���ʵ� -->
<PbInsuSlipNo><xsl:value-of select="ContNo" /></PbInsuSlipNo>
<BkTotAmt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></BkTotAmt>
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
			<xsl:text>����������Ͷ���ˣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Appnt/Name, 33)" />
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
		<BkDetail1>������������������</BkDetail1>
		<BkDetail1>����������------------------------------------------------------------------------------------------------</BkDetail1>
		<BkDetail1><xsl:text>������������������������������������������������������������������    �������ս��\</xsl:text></BkDetail1>
		<BkDetail1><xsl:text>��������������������������������              �����ڼ�      ��������    �ս�����\    ���շ�      ����Ƶ��</xsl:text></BkDetail1>
		<BkDetail1><xsl:text>������������������������                                                ����\����</xsl:text></BkDetail1>
		<BkDetail1>����������------------------------------------------------------------------------------------------------</BkDetail1>
		<xsl:for-each select="Risk">
		<xsl:variable name="PayIntv" select="PayIntv"/>
		<xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
		<xsl:variable name="ActPrem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)"/>
				<BkDetail1><xsl:text>����������</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 39)"/>
				<xsl:choose>
					<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('����', 12)"/>
					</xsl:when>
					<xsl:when test="InsuYearFlag = 'Y'">
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '��'), 12)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '����'), 12)"/>
						<xsl:text></xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="PayIntv = 0">
					    <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(' 1��', 11)"/>
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
			</BkDetail1>
		</xsl:for-each>
		<BkDetail1>����������------------------------------------------------------------------------------------------------</BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1>�������������շѺϼƣ�<xsl:value-of select="ActSumPremText" />��RMB<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>Ԫ����</BkDetail1>
		<BkDetail1>����������------------------------------------------------------------------------------------------------</BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1>����������------------------------------------------------------------------------------------------------</BkDetail1>
		<xsl:variable name="SpecContent" select="SpecContent"/>
		
		<BkDetail1>�������������յ��ر�Լ����</BkDetail1>
		<xsl:choose>
			<xsl:when test="$SpecContent=''">
				<BkDetail1><xsl:text>���ޣ�</xsl:text></BkDetail1>
			</xsl:when>
			<xsl:otherwise>
				<BkDetail1><xsl:text>����������    ������ٰ���3������ռƻ��������ա�����ٰ���3������ա��������ա�����ӳ�����</xsl:text></BkDetail1>
				<BkDetail1><xsl:text>������������3����ȫ���գ������ͣ�����ɡ����������������ͬ������ղ�Ʒ��������������������Զ�</xsl:text></BkDetail1>
				<BkDetail1><xsl:text>����������ת�븽���������˻��У��������ո��������½�Ϣ���ʽ���ֵ����</xsl:text></BkDetail1>
			</xsl:otherwise>
		</xsl:choose>
		<BkDetail1>����������-------------------------------------------------------------------------------------------------</BkDetail1>
		<BkDetail1>
			<xsl:text>�������������պ�ͬ�������ڣ�</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,1,4)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,5,2)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,7,2)"/>��<xsl:text>                               ���պ�ͬ��Ч���ڣ�</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,1,4)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,5,2)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,7,2)"/>��</BkDetail1>
		<!--  -->
		<BkDetail1></BkDetail1>
		<BkDetail1><xsl:text>����������Ӫҵ������</xsl:text><xsl:value-of select="ComName" /></BkDetail1>
     
		<BkDetail1><xsl:text>����������Ӫҵ��ַ��</xsl:text><xsl:value-of select="ComLocation" /></BkDetail1>

		<BkDetail1><xsl:text>�����������ͻ��������ߣ�95569                                            ��ַ��http://www.anbang-life.com</xsl:text></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1><xsl:text>����������Ϊȷ�����ı���Ȩ�棬�뼰ʱ�����ҹ�˾����绰����½��վ�򵽹�̨���в�ѯ����ʵ������Ϣ�����ڱ�����</xsl:text></BkDetail1>
		<BkDetail1><xsl:text>������������һ�������ϵ����ձ��������������յ�����֮����10��������״β�ѯ����</xsl:text></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1><xsl:text>���������������������ƣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComName,49)"/><xsl:text>����������Ա���ţ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(SellerNo, 0)"/></BkDetail1>	
	</Detail>
</Detail_List>
<xsl:if test="$MainRisk/CashValues/CashValue != ''">
<xsl:variable name="RiskCount" select="count(Risk)"/>
		<xsl:variable name="CashValueCount" select="count($MainRisk/CashValues/CashValue)"/>
	    <xsl:variable name="CashValueDiv" select="$CashValueCount div 2"/>
		<xsl:variable name="CashValueDiv2">
		    <xsl:if test="floor($CashValueDiv)=$CashValueDiv">
		        <xsl:value-of select="floor($CashValueDiv)+1" />
		    </xsl:if>
		    <xsl:if test="floor($CashValueDiv)!=$CashValueDiv">
		        <xsl:value-of select="floor($CashValueDiv)+2" />
		    </xsl:if>
		 </xsl:variable>
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
		<BkDetail1><xsl:text>������                                        </xsl:text>�ֽ��ֵ��</BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1>�������������յ����룺<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(ContNo, 60)"/>��ֵ��λ�������Ԫ </BkDetail1>
		<BkDetail1>����������------------------------------------------------------------------------------------------------</BkDetail1>
		<BkDetail1><xsl:text>������������������������</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name,49)"/><xsl:text>�������ƣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName, 0)"/></BkDetail1>	
		<BkDetail1><xsl:text/>�����������������ĩ<xsl:text>       </xsl:text>
				   <xsl:text>       �ֽ��ֵ</xsl:text><xsl:text/>����������       �������ĩ<xsl:text>    </xsl:text>
				   <xsl:text>       �ֽ��ֵ</xsl:text></BkDetail1>
		   	<xsl:variable name="EndYear" select="EndYear"/>
						  <xsl:variable name='n' select='$CashValueDiv2'/>
			            <xsl:for-each select='$MainRisk/CashValues/CashValue'>
			            <xsl:variable name='n2' select='position()+($CashValueDiv2)-1'/>
                        <xsl:if test='position() &lt; $n'>
                            <BkDetail1><xsl:text/><xsl:text>����������</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(position(),''),8)"/><xsl:text>���������� </xsl:text>
                            <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(./Cash), 'Ԫ'),32)"/>   
                            <xsl:if test='../CashValue[$n2]/Cash &gt; 0  or ../CashValue[$n2]/Cash = 0'><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat($n2,''),8)"/><xsl:text>�������� </xsl:text>
                            <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../CashValue[$n2]/Cash), 'Ԫ'),0)"/></xsl:if></BkDetail1>
                        </xsl:if>
						</xsl:for-each>
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
	<xsl:when test=".=0">���֤</xsl:when>
	<xsl:when test=".=1">����  </xsl:when>
	<xsl:when test=".=2">����֤</xsl:when>
	<xsl:when test=".=3">����  </xsl:when>
	<xsl:when test=".=5">���ڲ�</xsl:when>
	<xsl:when test=".=7">̨��֤</xsl:when>
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
	<xsl:when test="$riskcode='L12079'">122012</xsl:when>	<!-- ����ʢ��2���������գ������ͣ� -->
	<xsl:when test="$riskcode='L12078'">122010</xsl:when>	<!-- ����ʢ��3���������գ������ͣ� -->
	<xsl:when test="$riskcode='L12100'">122010</xsl:when>	<!-- ����ʢ��3���������գ������ͣ� -->
	<xsl:when test="$riskcode='L12073'">122029</xsl:when>	<!-- ����ʢ��5���������գ������ͣ� -->
	
	<xsl:when test="$riskcode='122009'">122009</xsl:when>	<!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A�� -->
	<xsl:when test="$riskcode='122036'">122036</xsl:when>	<!-- ����ƽ�6����ȫ���գ��ֺ��ͣ�A�� -->
	<xsl:when test="$riskcode='L12074'">122035</xsl:when>	<!-- ����ʢ��9����ȫ���գ������ͣ� -->
	
	<!-- 50002-�������Ӯ2����ȫ�������: 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�122048-����������������գ������ͣ���� -->
	<xsl:when test="$riskcode='122046'">122046</xsl:when>	<!-- �������Ӯ1����ȫ���� -->
	<xsl:when test="$riskcode='122047'">122047</xsl:when>	<!-- ����ӳ�����Ӯ��ȫ���� -->
	<xsl:when test="$riskcode='122048'">122048</xsl:when>	<!-- ����������������գ������ͣ� -->
	
	<!-- add by duanjz 2015-6-18 ���Ӱ���ٰ���5�ű��ռƻ�50012 begin -->
	<xsl:when test="$riskcode='L12070'">L12070</xsl:when>	<!-- ����ٰ���5������� -->
	<xsl:when test="$riskcode='L12071'">L12071</xsl:when>	<!-- ����ӳ�������5����ȫ���գ������ͣ� -->
	<!-- add by duanjz 2015-6-18 ���Ӱ���ٰ���5�ű��ռƻ�50012 end -->
	
	<!-- add by duanjz 2015-10-20 ���Ӱ���ٰ���3�ű��ռƻ�50011 begin -->
	<xsl:when test="$riskcode='L12068'">L12068</xsl:when>	<!-- ����ٰ���3������� -->
	<xsl:when test="$riskcode='L12069'">L12069</xsl:when>	<!-- ����ӳ�������3����ȫ���գ������ͣ� -->
	<!-- add by duanjz 2015-10-20 ���Ӱ���ٰ���3�ű��ռƻ�50011 end -->
	
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ��Ʒ��ϱ��� -->
<xsl:template name="tran_ContPlanCode">
	<xsl:param name="contPlanCode" />

	<xsl:choose>
		<!-- 50002-�������Ӯ2����ȫ�������: 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�122048-����������������գ������ͣ���� -->
		<xsl:when test="$contPlanCode='122046'">50002</xsl:when>
	    <!-- add by duanjz 2015-6-18 ���Ӱ���ٰ���5�ű��ռƻ�50012 begin -->
	    <xsl:when test="$contPlanCode='L12070'">50012</xsl:when>
	    <!-- add by duanjz 2015-6-18 ���Ӱ���ٰ���5�ű��ռƻ�50012 end -->
	    <!-- add by duanjz 2015-10-20 ���Ӱ���ٰ���3�ű��ռƻ�50012 begin -->
	    <xsl:when test="$contPlanCode='L12068'">50011</xsl:when>
	    <!-- add by duanjz 2015-10-20 ���Ӱ���ٰ���3�ű��ռƻ�50012 end -->
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
