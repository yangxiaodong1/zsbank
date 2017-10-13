<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:variable name="InsuredSex" select="/TranData/Insured/Sex"/>
	<xsl:template match="/TranData">
		<RETURN>
			<!-- ����ͷ -->
			<xsl:copy-of select="Head" />
			
			<!-- ������ -->
			<xsl:if test="Head/Flag='0'">
				<xsl:apply-templates select="Body" />
			</xsl:if>
			<xsl:if test="Head/Flag='1'">
				<MAIN />
			</xsl:if>
		</RETURN>
	</xsl:template>

	<!-- ������ -->
	<xsl:template name="TRAN_BODY" match="Body">
		<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]" />
		<MAIN>
			
			<!-- ���յ��� -->
			<POLICY_NO><xsl:value-of select="ContNo" /></POLICY_NO>
			<TOT_PREM><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></TOT_PREM>
			<!-- ���ڱ��� -->
			<INIT_PREM_AMT><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></INIT_PREM_AMT>
			<!-- ���ڱ���, ��д -->
			<INIT_PREM_TXT><xsl:value-of select="ActSumPremText" /></INIT_PREM_TXT>
			<!-- ��Ч���� -->
			<VALIDATE><xsl:value-of select="$MainRisk/CValiDate" /></VALIDATE>
			<CONTENDDATE><xsl:value-of select="$MainRisk/PolApplyDate" /></CONTENDDATE>
			<!-- �б���˾ -->
			<ORGAN><xsl:value-of select="ComName" /></ORGAN>
			<!-- ��˾��ַ -->
			<LOC><xsl:value-of select="ComLocation" /></LOC>
			<!-- ��˾�绰 -->
			<TEL>95569</TEL>
			<!-- ҳ�� -->
			<xsl:if test="$MainRisk/CashValues/CashValue != ''"><!-- ������ֽ��ֵ��ʾ2ҳ -->
				<TOTALPAGE>2</TOTALPAGE>
			</xsl:if>
			<xsl:if test="count($MainRisk/CashValues/CashValue) = 0"><!-- ���û���ֽ��ֵ��ʾ1ҳ -->
				<TOTALPAGE>1</TOTALPAGE>
			</xsl:if>
		</MAIN>

		<xsl:variable name="RiskCount" select="count(Risk)"/>
		<xsl:variable name="ProductCode" select="$MainRisk/RiskCode" />
			
		<Prnts>
			<Type>8</Type>	<!-- ���յ�  ��ӡ���ͽڵ㣬����Type=8���ֽ��ֵType=9-->
			<Count></Count>
			<Page>
				<Prnt><Value>��</Value></Prnt>
				<Prnt><Value>��</Value></Prnt>
				<Prnt><Value>��</Value></Prnt>
				<Prnt><Value>��</Value></Prnt>
				<Prnt><Value>��</Value></Prnt>
				<Prnt><Value><xsl:text>���յ����룺</xsl:text><xsl:value-of select="ContNo" /><xsl:text>                                                ��ֵ��λ�������Ԫ</xsl:text></Value></Prnt>
				<Prnt><Value>-------------------------------------------------------------------------------------------------------------------------</Value></Prnt>
				<Prnt><Value>
					<xsl:text>Ͷ���ˣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Appnt/Name, 33)" />
					<xsl:text>֤�����ͣ�</xsl:text><xsl:call-template name="tran_IDName"><xsl:with-param name="idName" select="Appnt/IDType" /></xsl:call-template>
					<xsl:text>      ֤�����룺</xsl:text><xsl:value-of select="Appnt/IDNo" />
				</Value></Prnt>
				<Prnt><Value>
					<xsl:text>�������ˣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name, 30)" />
					<xsl:text>֤�����ͣ�</xsl:text><xsl:call-template name="tran_IDName"><xsl:with-param name="idName" select="Insured/IDType" /></xsl:call-template>
					<xsl:text>      ֤�����룺</xsl:text><xsl:value-of select="Insured/IDNo" />
				</Value></Prnt>
				<Prnt><Value>��</Value></Prnt>
				<Prnt><Value>-------------------------------------------------------------------------------------------------------------------------</Value></Prnt>
				<Prnt><Value>-------------------------------------------------------------------------------------------------------------------------</Value></Prnt>
				<xsl:if test="count(Bnf) = 0">
				<Prnt><Value><xsl:text>���������ˣ�����                </xsl:text>
						   <xsl:text>����˳��1                   </xsl:text>
						   <xsl:text>���������100%</xsl:text></Value></Prnt>
				</xsl:if>
				<xsl:if test="count(Bnf)>0">
				<xsl:for-each select="Bnf">
				<Prnt><Value>
					<xsl:text>���������ˣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>
					<xsl:text>����˳��</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Grade, 16)"/>
					<xsl:text>���������</xsl:text><xsl:value-of select="Lot"/><xsl:text>%</xsl:text>
				</Value></Prnt>
				</xsl:for-each>
				</xsl:if>
				<Prnt><Value>-------------------------------------------------------------------------------------------------------------------------</Value></Prnt>
				<Prnt><Value>��</Value></Prnt>
				<Prnt><Value>��������</Value></Prnt>
				<Prnt><Value>-------------------------------------------------------------------------------------------------------------------------</Value></Prnt>
				<Prnt><Value><xsl:text>�������������������������������������������������������������������ս��\</xsl:text></Value></Prnt>
				<Prnt><Value><xsl:text>����������������������               �����ڼ�    ��������     �ս�����\     ���շ�     ����Ƶ��</xsl:text></Value></Prnt>
				<Prnt><Value><xsl:text>������������������������������������������������������������������\����</xsl:text></Value></Prnt>
								<Prnt><Value>-------------------------------------------------------------------------------------------------------------------------</Value></Prnt>
				<xsl:for-each select="Risk">
					<xsl:variable name="PayIntv" select="PayIntv"/>
					<xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
					<xsl:variable name="ActPrem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)"/>			
						<Prnt><Value><xsl:text></xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 39)"/>
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
									<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('һ����', 13)"/>
								</xsl:when>
								<xsl:when test="PayEndYearFlag = 'Y'">
									<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(PayEndYear, '��'), 14)"/>
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
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($ActPrem,14)"/>
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
						</Value></Prnt>						
				</xsl:for-each>
				<Prnt><Value>-------------------------------------------------------------------------------------------------------------------------</Value></Prnt>
				<Prnt><Value>��</Value></Prnt>
				<Prnt><Value>���շѺϼƣ�<xsl:value-of select="ActSumPremText" />��RMB<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>Ԫ����</Value></Prnt>
				<Prnt><Value>��</Value></Prnt>
				<Prnt><Value>-------------------------------------------------------------------------------------------------------------------------</Value></Prnt>
				<Prnt><Value>��</Value></Prnt>
				<Prnt><Value>��</Value></Prnt>
				<Prnt><Value>-------------------------------------------------------------------------------------------------------------------------</Value></Prnt>
				
				<xsl:variable name="SpecContent" select="SpecContent"/>
				<Prnt><Value>���յ��ر�Լ����</Value></Prnt>
				<xsl:choose>
					<xsl:when test="$SpecContent=''">
						<Prnt><Value><xsl:text>���ޣ�</xsl:text></Value></Prnt>
					</xsl:when>
					<xsl:otherwise>
						<Prnt><Value>   ������ٰ���3������ռƻ��������ա�����ٰ���3������ա��������ա�����ӳ���</Value></Prnt>
						<Prnt><Value>����3����ȫ���գ������ͣ�����ɡ����������������ͬ������ղ�Ʒ�������������������</Value></Prnt>
						<Prnt><Value>�Զ�ת�븽���������˻��У��������ո��������½�Ϣ���ʽ���ֵ����</Value></Prnt>
					</xsl:otherwise>
				</xsl:choose>
				<Prnt><Value>--------------------------------------------------------------------------------------------------------------------------</Value></Prnt>
				<Prnt><Value><xsl:text>���պ�ͬ�������ڣ�</xsl:text><xsl:value-of  select="java:com.sinosoft.midplat.common.DateUtil.formatTrans($MainRisk/PolApplyDate,'yyyyMMdd','yyyy��MM��dd��')"/><xsl:text>                             ���պ�ͬ��Ч���ڣ�</xsl:text><xsl:value-of  select="java:com.sinosoft.midplat.common.DateUtil.formatTrans($MainRisk/CValiDate,'yyyyMMdd','yyyy��MM��dd��')"/></Value></Prnt>
				<Prnt><Value>��</Value></Prnt>
				<Prnt><Value><xsl:text>Ӫҵ������</xsl:text><xsl:value-of select="ComName" /></Value></Prnt>
			    <Prnt><Value><xsl:text>Ӫҵ��ַ��</xsl:text><xsl:value-of select="ComLocation" /></Value></Prnt>
				<Prnt><Value><xsl:text>�ͻ��������ߣ�95569                                            ��ַ��http://www.anbang-life.com</xsl:text></Value></Prnt>
				<Prnt><Value>��</Value></Prnt>
				<Prnt><Value><xsl:text>Ϊȷ�����ı���Ȩ�棬�뼰ʱ�����ҹ�˾����绰����½��վ�򵽹�̨���в�ѯ����ʵ������Ϣ�����ڱ�</xsl:text></Value></Prnt>
				<Prnt><Value><xsl:text>������һ�������ϵ����ձ��������������յ�����֮����10��������״β�ѯ����</xsl:text></Value></Prnt>
				<Prnt/>
				<Prnt><Value><xsl:text>�����������ƣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComName, 49)"/><xsl:text>ҵ������֤��ţ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComCertiCode,0)"/></Value></Prnt>
				<Prnt><Value><xsl:text>����������Ա��</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerName,49)"/><xsl:text>��ҵ�ʸ�֤��ţ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerCertiCode,0)"/></Value></Prnt>
				<Prnt><Value><xsl:text>����������Ա���ţ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(SellerNo,0)"/></Value></Prnt>
			</Page>
		</Prnts>
		<!-- �ֽ��ֵҳ��ӡ -->
		<xsl:variable name="CashValueCount" select="count($MainRisk/CashValues/CashValue)"/>
		<xsl:variable name="CashValueDiv" select="$CashValueCount div 2"/>
		<xsl:variable name="CashValueDiv2" select="floor($CashValueDiv)+2"/>
		<Messages>
			<Type>9</Type>  <!-- �ֽ��ֵ��   ��ӡ���ͽڵ㣬����Type=8���ֽ��ֵType=9 -->
			<Count></Count>
			<Page>
				<Message><xsl:text>������                                        </xsl:text>�ֽ��ֵ��</Message>
				<Message><Value>��</Value></Message>
				<Message><Value>���������յ����룺<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(ContNo, 60)"/>��ֵ��λ�������Ԫ </Value></Message>
				<Message><Value>������-------------------------------------------------------------------------------------------------------------------------</Value></Message>
				<Message><Value><xsl:text>��������������������</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name,48)"/><xsl:text>�������ƣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName,0)"/></Value></Message>
		        <Message><Value><xsl:text/>�������������ĩ<xsl:text>    </xsl:text>
				   <xsl:text>         �ֽ��ֵ</xsl:text><xsl:text/>������              �������ĩ<xsl:text>    </xsl:text>
				   <xsl:text>       �ֽ��ֵ</xsl:text></Value></Message>
			    
			    <xsl:variable name='n' select='$CashValueDiv2'/>
			    <xsl:for-each select='$MainRisk/CashValues/CashValue'>
			    <xsl:variable name='n2' select='position()+($CashValueDiv2)-1'/>
                   <xsl:if test='position() &lt; $n'>
                     <Message><Value><xsl:text/><xsl:text>����������</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(position(),''),8)"/><xsl:text>���������� </xsl:text>
                     <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(./Cash), 'Ԫ'),32)"/>   
                     <xsl:if test='../CashValue[$n2]/Cash &gt; 0  or ../CashValue[$n2]/Cash = 0'><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat($n2,''),8)"/><xsl:text>�������� </xsl:text>
                     <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../CashValue[$n2]/Cash), 'Ԫ'),0)"/></xsl:if></Value></Message>
                   </xsl:if>
				</xsl:for-each> 
				<Message><Value>������-------------------------------------------------------------------------------------------------------------------------</Value></Message>
				<Message><Value>��</Value></Message>
				<Message><Value>��������ע��</Value></Message>
				<Message><Value>�����������ֽ��ֵΪ��Ӧ�������ĩ��ֵ����������ڵ��ֽ��ֵ���������򱾹�˾��ѯ��</Value></Message>
				<Message><Value>������-------------------------------------------------------------------------------------------------------------------------</Value></Message>
			</Page>
		
		</Messages>
	</xsl:template>

	<!-- ֤�����͡�ע�⣺������  ���ո��Ű��õģ�����ȥ���� -->
	<xsl:template name="tran_IDName">
		<xsl:param name="idName" />
		<xsl:choose>
			<xsl:when test="$idName='0'">����֤  </xsl:when>
			<xsl:when test="$idName='1'">����    </xsl:when>
			<xsl:when test="$idName='2'">����֤  </xsl:when>
			<xsl:when test="$idName='3'">����    </xsl:when>
			<xsl:when test="$idName='4'">����֤��</xsl:when>
			<xsl:when test="$idName='5'">���ڲ�  </xsl:when>
			<xsl:when test="$idName='6'">�۰Ļ���֤</xsl:when>
			<xsl:when test="$idName='7'">̨��֤  </xsl:when>
			<xsl:when test="$idName='8'">����    </xsl:when>
			<xsl:when test="$idName='9'">�쳣����֤</xsl:when>
			<xsl:otherwise>����    </xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>