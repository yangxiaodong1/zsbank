<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/TranData">
<INSUREQRET>
	<xsl:copy-of select="Head" />
	<!-- ����Ϣ -->
	<MAIN>
		<CORP_DEPNO></CORP_DEPNO>
		<CORP_AGENTNO></CORP_AGENTNO>
		<POLICY><xsl:value-of select="Body/ContNo"/></POLICY>
		<INSUREAMT><xsl:value-of select="Body/ActSumPrem" /></INSUREAMT>
    </MAIN>
	<xsl:apply-templates select="Body" />
</INSUREQRET>
</xsl:template>

<!-- ��ӡ��Ϣ -->
<xsl:template name="PRINT" match="Body">
	<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]" />
	<PRINT>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE><xsl:text>���������յ����룺</xsl:text><xsl:value-of select="ContNo" /><xsl:text>                                                    ��ֵ��λ�������Ԫ</xsl:text></PRINT_LINE>
		<PRINT_LINE>������------------------------------------------------------------------------------------------------</PRINT_LINE>
		<PRINT_LINE>
			<xsl:text>������Ͷ���ˣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Appnt/Name, 33)" />
			<xsl:text>֤�����ͣ�</xsl:text><xsl:apply-templates select="Appnt/IDType" />
			<xsl:text>        ֤�����룺</xsl:text><xsl:value-of select="Appnt/IDNo" />
		</PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE>
			<xsl:text>�������������ˣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name, 31)" />
			<xsl:text>֤�����ͣ�</xsl:text><xsl:apply-templates select="Insured/IDType" />
			<xsl:text>        ֤�����룺</xsl:text><xsl:value-of select="Insured/IDNo" />
		</PRINT_LINE>
		<PRINT_LINE>������------------------------------------------------------------------------------------------------</PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE>������------------------------------------------------------------------------------------------------</PRINT_LINE>
		<xsl:if test="count(Bnf) = 0">
		<PRINT_LINE><xsl:text>��������������ˣ�����                </xsl:text>
				   <xsl:text>����˳��1                   </xsl:text>
				   <xsl:text>���������100%</xsl:text></PRINT_LINE>
		</xsl:if>
		<xsl:if test="count(Bnf)>0">
		<xsl:for-each select="Bnf">
		<PRINT_LINE>
			<xsl:text>��������������ˣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>
			<xsl:text>����˳��</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Grade, 16)"/>
			<xsl:text>���������</xsl:text><xsl:value-of select="Lot"/><xsl:text>%</xsl:text>
		</PRINT_LINE>
		</xsl:for-each>
		</xsl:if>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE>������------------------------------------------------------------------------------------------------</PRINT_LINE>
		<PRINT_LINE>��������������</PRINT_LINE>
		<PRINT_LINE>������------------------------------------------------------------------------------------------------</PRINT_LINE>
		<PRINT_LINE><xsl:text>��������������������                                               �������ս��\</xsl:text></PRINT_LINE>
		<PRINT_LINE><xsl:text>����������������������������                �����ڼ�    ��������     �ս�����\    ���շ�    ����Ƶ��</xsl:text></PRINT_LINE>
		<PRINT_LINE><xsl:text>��������������������                                                 ����\����</xsl:text></PRINT_LINE>
		<PRINT_LINE>������------------------------------------------------------------------------------------------------</PRINT_LINE>
		<xsl:for-each select="Risk">
		<xsl:variable name="PayIntv" select="PayIntv"/>
		<xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
		<xsl:variable name="ActPrem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)"/>
		<PRINT_LINE>
				<xsl:text>������</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 40)"/>
				<xsl:choose>
					<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('����', 11)"/>
					</xsl:when>
					<xsl:when test="InsuYearFlag = 'Y'">
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '��'), 11)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '����'), 11)"/>
						<xsl:text></xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="PayIntv = 0">
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(' 1��', 12)"/>
					</xsl:when>
					<xsl:when test="PayEndYearFlag = 'Y'">
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(PayEndYear, '��'), 12)"/>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
					    <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('�����ʻ���ֵ',13)"/>
					</xsl:when>
						<xsl:otherwise>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Amnt,13)"/>
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
		</PRINT_LINE>
		</xsl:for-each>
		<PRINT_LINE>������------------------------------------------------------------------------------------------------</PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE>���������շѺϼƣ�<xsl:value-of select="ActSumPremText" />��RMB<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>Ԫ����</PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE>������------------------------------------------------------------------------------------------------</PRINT_LINE>
		<PRINT_LINE>������------------------------------------------------------------------------------------------------</PRINT_LINE>
		<xsl:variable name="SpecContent" select="SpecContent"/>
		<PRINT_LINE>������<xsl:text>���յ��ر�Լ����</xsl:text></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
				<xsl:choose>
					<xsl:when test="$SpecContent=''">
						<xsl:text>���ޣ�</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<PRINT_LINE><xsl:text>������     ������ٰ���5������ռƻ��������ա�����ٰ���5������ա��������ա�����ӳ�������</xsl:text></PRINT_LINE>
						<PRINT_LINE></PRINT_LINE>
						<PRINT_LINE><xsl:text>������ 5����ȫ���գ������ͣ�����ɡ����������������ͬ������ղ�Ʒ��������������������Զ�ת��</xsl:text></PRINT_LINE>
						<PRINT_LINE></PRINT_LINE>
						<PRINT_LINE><xsl:text>������ �����������˻��У��������ո��������½�Ϣ���ʽ���ֵ����</xsl:text></PRINT_LINE>	
					</xsl:otherwise>
				</xsl:choose>
		<PRINT_LINE>������-------------------------------------------------------------------------------------------------</PRINT_LINE>
		<PRINT_LINE>
			<xsl:text>���������պ�ͬ�������ڣ�</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,1,4)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,5,2)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,7,2)"/>��<xsl:text>                               ���պ�ͬ��Ч���ڣ�</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,1,4)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,5,2)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,7,2)"/>��</PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE><xsl:text>������Ӫҵ������</xsl:text><xsl:value-of select="ComName" /></PRINT_LINE>
		<PRINT_LINE><xsl:text>������Ӫҵ��ַ��</xsl:text><xsl:value-of select="ComLocation" /></PRINT_LINE>
		<PRINT_LINE><xsl:text>�������ͻ��������ߣ�95569                                            ��ַ��http://www.anbang-life.com</xsl:text></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE><xsl:text>������Ϊȷ�����ı���Ȩ�棬�뼰ʱ�����ҹ�˾����绰����½��վ�򵽹�̨���в�ѯ����ʵ������Ϣ�����ڱ�����</xsl:text></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE><xsl:text>��������һ�������ϵ����ձ��������������յ�����֮����10��������״β�ѯ����</xsl:text></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE><xsl:text>�����������������ƣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComName,49)"/><xsl:text>����������Ա���ţ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(SellerNo, 0)"/></PRINT_LINE>
		
	</PRINT>
	 <xsl:variable name="RiskCount" select="count(Risk)"/>
	<PRINT>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE><xsl:text>������                                        </xsl:text>�ֽ��ֵ��</PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE>���������յ����룺<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(ContNo, 60)"/>��ֵ��λ�������Ԫ </PRINT_LINE>
		<PRINT_LINE>������------------------------------------------------------------------------------------------------</PRINT_LINE>
		<PRINT_LINE><xsl:text>������������������������</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name,44)"/><xsl:text>�������ƣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName, 0)"/></PRINT_LINE>	
		<PRINT_LINE><xsl:text/>�����������������ĩ<xsl:text>       </xsl:text>
				   <xsl:text>       �ֽ��ֵ</xsl:text><xsl:text/>����������       �������ĩ<xsl:text>    </xsl:text>
				   <xsl:text>       �ֽ��ֵ</xsl:text></PRINT_LINE>
		   	<xsl:variable name="EndYear" select="EndYear"/>
			   <PRINT_LINE><xsl:text/><xsl:text>����������    </xsl:text>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('1',20)"/>
										<xsl:variable name="Cash1" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/CashValues/CashValue[1]/Cash)"/>
										<xsl:variable name="Cash1a" select="concat($Cash1,'Ԫ')"/>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Cash1a,10)"/><xsl:text>����������        </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(' 9',18)"/>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/CashValues/CashValue[9]/Cash)"/>Ԫ</PRINT_LINE>
			   <PRINT_LINE><xsl:text/><xsl:text>����������    </xsl:text>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('2',20)"/>
										<xsl:variable name="Cash2" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/CashValues/CashValue[2]/Cash)"/>
										<xsl:variable name="Cash2a" select="concat($Cash2,'Ԫ')"/>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Cash2a,10)"/><xsl:text>����������        </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('10',18)"/>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/CashValues/CashValue[10]/Cash)"/>Ԫ</PRINT_LINE>
			   <PRINT_LINE><xsl:text/><xsl:text>����������    </xsl:text>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('3',20)"/>
										<xsl:variable name="Cash3" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/CashValues/CashValue[3]/Cash)"/>
										<xsl:variable name="Cash3a" select="concat($Cash3,'Ԫ')"/>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Cash3a,10)"/><xsl:text>����������        </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('11',18)"/>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/CashValues/CashValue[11]/Cash)"/>Ԫ</PRINT_LINE>
			   <PRINT_LINE><xsl:text/><xsl:text>����������    </xsl:text>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('4',20)"/>
										<xsl:variable name="Cash4" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/CashValues/CashValue[4]/Cash)"/>
										<xsl:variable name="Cash4a" select="concat($Cash4,'Ԫ')"/>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Cash4a,10)"/><xsl:text>����������        </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('12',18)"/>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/CashValues/CashValue[12]/Cash)"/>Ԫ</PRINT_LINE>
			   <PRINT_LINE><xsl:text/><xsl:text>����������    </xsl:text>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('5',20)"/>
										<xsl:variable name="Cash5" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/CashValues/CashValue[5]/Cash)"/>
										<xsl:variable name="Cash5a" select="concat($Cash5,'Ԫ')"/>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Cash5a,10)"/><xsl:text>����������        </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('13',18)"/>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/CashValues/CashValue[13]/Cash)"/>Ԫ</PRINT_LINE>
			   <PRINT_LINE><xsl:text/><xsl:text>����������    </xsl:text>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('6',20)"/>
										<xsl:variable name="Cash6" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/CashValues/CashValue[6]/Cash)"/>
										<xsl:variable name="Cash6a" select="concat($Cash6,'Ԫ')"/>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Cash6a,10)"/><xsl:text>����������        </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('14',18)"/>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/CashValues/CashValue[14]/Cash)"/>Ԫ</PRINT_LINE>
			   <PRINT_LINE><xsl:text/><xsl:text>����������    </xsl:text>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('7',20)"/>
										<xsl:variable name="Cash7" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/CashValues/CashValue[7]/Cash)"/>
										<xsl:variable name="Cash7a" select="concat($Cash7,'Ԫ')"/>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Cash7a,10)"/><xsl:text>����������        </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('15',18)"/>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/CashValues/CashValue[15]/Cash)"/>Ԫ</PRINT_LINE>
			   <PRINT_LINE><xsl:text/><xsl:text>����������    </xsl:text>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('8',20)"/>
										<xsl:variable name="Cash8" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($MainRisk/CashValues/CashValue[8]/Cash)"/>
										<xsl:variable name="Cash8a" select="concat($Cash8,'Ԫ')"/>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Cash8a,10)"/></PRINT_LINE>
	
		<PRINT_LINE>������------------------------------------------------------------------------------------------------</PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE>��������ע��</PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE>�����������ֽ��ֵΪ��Ӧ�������ĩ��ֵ����������ڵ��ֽ��ֵ���������򱾹�˾��ѯ�� </PRINT_LINE>
		<PRINT_LINE>������------------------------------------------------------------------------------------------------</PRINT_LINE>
    </PRINT>
</xsl:template>

<!-- ֤�����͡�ע�⣺������  ���ո��Ű��õģ�����ȥ���� -->
<xsl:template match="IDType">
	<xsl:choose>
		<xsl:when test=".=0">���֤</xsl:when>
		<xsl:when test=".=1">����  </xsl:when>
		<xsl:when test=".=2">����֤</xsl:when>
		<xsl:when test=".=3">����  </xsl:when>
		<xsl:when test=".=5">���ڲ�</xsl:when>
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
