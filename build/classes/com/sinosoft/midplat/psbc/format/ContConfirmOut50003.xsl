<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:output indent='yes'/>
<xsl:template match="/TranData">
<RETURN>
	 <MAIN>
	 	<!--������-->
	 	<RESULTCODE>
	 		<xsl:apply-templates select="Head/Flag" />
	 	</RESULTCODE>
	 	<!--��������-->
	 	<ERR_INFO>
	 		<xsl:value-of select="Head/Desc" />
	 	</ERR_INFO>
	 	<!-- ������׳ɹ����ŷ�������Ľ�� -->
		<xsl:if test="Head/Flag='0'">
		 	<!--Ͷ������-->
		 	<APPLNO>
		 		<xsl:value-of select="Body/ProposalPrtNo" />
		 	</APPLNO>
		 	<!--������( ���ձ��պ�ͬ��)-->
		 	<POLICY>
		 		<xsl:value-of select="Body/ContNo" />
		 	</POLICY>
		 	<!--Ͷ�����ڣ�CD01��-->
		 	<ACCEPT>
		 		<xsl:value-of select="Body/Risk/PolApplyDate" />
		 	</ACCEPT>
		 	<!--���ڱ��ѣ�CD23��-->
		 	<PREM>
		 		<xsl:value-of select="Body/ActSumPrem" />
		 	</PREM>
		 	<!--���ڱ��Ѵ�д-->
		 	<xsl:variable name="SumPremYuan"
		 		select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/ActSumPrem)" />
		 	<PREMC>
		 		<xsl:value-of
		 			select="java:com.sinosoft.midplat.common.NumberUtil.money2CN(Body/ActSumPrem)" />
		 	</PREMC>
		 	<!--������Ч���ڣ�CD01��-->
		 	<VALIDATE>
		 		<xsl:value-of select="Body/Risk/CValiDate" />
		 	</VALIDATE>
		 	<!--Ͷ��������-->
		 	<TBR_NAME>
		 		<xsl:value-of select="Body/Appnt/Name" />
		 	</TBR_NAME>
		 	<!--Ͷ���˿ͻ���-->
		 	<TBRPATRON>
		 		<xsl:value-of select="Body/Appnt/CustomerNo" />
		 	</TBRPATRON>
		 	<!--����������-->
		 	<BBR_NAME>
		 		<xsl:value-of select="Body/Insured/Name" />
		 	</BBR_NAME>
		 	<!--�����˿ͻ���-->
		 	<BBRPATRON>
		 		<xsl:value-of select="Body/Insured/CustomerNo" />
		 	</BBRPATRON>
		 	<!--�ɷѷ�ʽ��CD24��-->
		 	<xsl:variable name="PayIntv"
		 		select="Body/Risk[RiskCode=MainRiskCode]/PayIntv" />
		 	<PAYMETHOD>
		 		<xsl:call-template name="tran_PayIntv">
		 			<xsl:with-param name="PayIntv">
		 				<xsl:value-of select="$PayIntv" />
		 			</xsl:with-param>
		 		</xsl:call-template>
		 	</PAYMETHOD>
		 	<!--�ɷѷ�ʽ(����)-->
		 	<PAY_METHOD>
		 		<xsl:apply-templates select="$PayIntv" />
		 	</PAY_METHOD>
		 	<!--�ɷ����ڣ�CD01��-->
		 	<PAYDATE>
		 		<xsl:value-of select="Body/Risk/PolApplyDate" />
		 	</PAYDATE>
		 	<!--�б���˾����-->
		 	<ORGAN>
		 		<xsl:value-of select="Body/ComName" />
		 	</ORGAN>
		 	<!--�б���˾��ַ-->
		 	<LOC>
		 		<xsl:value-of select="Body/ComLocation" />
		 	</LOC>
		 	<!--�б���˾�绰-->
		 	<TEL>
		 		<xsl:value-of select="Body/ComPhone" />
		 	</TEL>
		 	<!--�ر�Լ����ӡ��־��CD25��-->
		 	<ASSUM>0</ASSUM>
		 	<!--Ͷ���˿ͻ����������ڣ�CD01��-->
		 	<TBR_OAC_DATE></TBR_OAC_DATE>
		 	<!--�����˿ͻ����������ڣ�CD01��-->
		 	<BBR_OAC_DATE></BBR_OAC_DATE>
		 	<!--�б���˾����-->
		 	<ORGANCODE>
		 		<xsl:value-of select="Body/ComCode" />
		 	</ORGANCODE>
		 	<!--���ڽɷ����ڣ�����������-->
		 	<PAYDATECHN></PAYDATECHN>
		 	<!--�ɷ���ֹ���ڣ�����������-->
		 	<PAYSEDATECHN></PAYSEDATECHN>
		 	<!--�ɷ�����-->
		 	<PAYYEAR></PAYYEAR>
		 </xsl:if>
	 </MAIN>
 	<!-- ������׳ɹ����ŷ�������Ľ�� -->
	<xsl:if test="Head/Flag='0'">
 		<xsl:apply-templates select="Body" />
 	</xsl:if>
</RETURN>
</xsl:template>

<xsl:template  match="Body">
	 <!--������Ϣ-->
	<PTS>
	    <PT_COUNT>1</PT_COUNT>
	    <xsl:for-each select= "Risk[RiskCode=MainRiskCode]">
	    <PT>
	        <xsl:variable name="ContEndDateText" select="java:com.sinosoft.midplat.common.DateUtil.formatTrans(InsuEndDate, 'yyyyMMdd', 'yyyy��MM��dd��')"/>
	        <POLICY><xsl:value-of select="../ContNo"/></POLICY>
	        <UNIT><xsl:value-of select="Mult"/></UNIT>
	        <MAINSUBFLG>1</MAINSUBFLG>
	        <AMT><xsl:value-of select="sum(../Risk/Amnt)"/></AMT>
	        <PREM><xsl:value-of select="sum(../Risk/ActPrem)"/></PREM>
	        <NAME><xsl:value-of select="../ContPlan/ContPlanName"/></NAME>
	        <PERIOD><xsl:value-of select="$ContEndDateText"/></PERIOD>
	        <INSUENDDATE><xsl:value-of select="$ContEndDateText"/></INSUENDDATE>
	        <INSUENDDATE_CPAI><xsl:value-of select="InsuEndDate"/></INSUENDDATE_CPAI>
	        <PAYENDDATE><xsl:value-of select="PayEndDate"/></PAYENDDATE>
	        <CHARGE_PERIOD>1</CHARGE_PERIOD>
	        <CHARGE_YEAR>1000</CHARGE_YEAR>
	    </PT>
	    </xsl:for-each>  
	</PTS>
	<xsl:variable name="leftPadFlag" select="java:java.lang.Boolean.parseBoolean('true')" />
    <xsl:variable name="ContPlanMultWith0" select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(ContPlan/ContPlanMult,5,$leftPadFlag)"/>

	
	<!-- ��ӡ��Ϣ -->
	<PRT>
		<PRT_NUM>2</PRT_NUM>
	    <PRTS>
			<PRT_TYPE>1</PRT_TYPE>
		    <PRT_REC_NUM>0</PRT_REC_NUM>
		    <PRT_DETAIL>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE><xsl:text>���������յ����룺</xsl:text><xsl:value-of select="ContNo" /><xsl:text>-(00001��</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat($ContPlanMultWith0,')'),5)" />
				<xsl:text>                                      ��ֵ��λ�������Ԫ</xsl:text></PRT_LINE>
				<PRT_LINE>������------------------------------------------------------------------------------------------------</PRT_LINE>
				<PRT_LINE>
					<xsl:text>������Ͷ����������</xsl:text>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Appnt/Name, 28)"/>
					<xsl:text>֤�����ͣ�</xsl:text>
					<xsl:apply-templates select="Appnt/IDType"/>
					<xsl:text>        ֤�����룺</xsl:text>
					<xsl:value-of select="Appnt/IDNo"/>
				</PRT_LINE>
				<PRT_LINE>
					<xsl:text>�������������ˣ�</xsl:text>
					<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name, 30)"/>
					<xsl:text>֤�����ͣ�</xsl:text>
					<xsl:apply-templates select="Insured/IDType"/>
					<xsl:text>        ֤�����룺</xsl:text>
					<xsl:value-of select="Insured/IDNo"/>
				</PRT_LINE>
				<PRT_LINE>������------------------------------------------------------------------------------------------------</PRT_LINE>
				<PRT_LINE>������------------------------------------------------------------------------------------------------</PRT_LINE>
				<xsl:if test="count(Bnf) = 0">
				<PRT_LINE><xsl:text>��������������ˣ�����                </xsl:text>
				   <xsl:text>����˳��1                   </xsl:text>
				   <xsl:text>���������100%</xsl:text></PRT_LINE>
		        </xsl:if>
				<xsl:if test="count(Bnf)>0">
					<xsl:for-each select="Bnf">
						<PRT_LINE>
							<xsl:text>��������������ˣ�</xsl:text>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>
							<xsl:text>����˳��</xsl:text>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Grade, 16)"/>
							<xsl:text>���������</xsl:text>
							<xsl:value-of select="Lot"/>
							<xsl:text>%</xsl:text>
						</PRT_LINE>
					</xsl:for-each>
				</xsl:if>
				<PRT_LINE>������------------------------------------------------------------------------------------------------</PRT_LINE>
				<PRT_LINE/>
				<PRT_LINE>��������������</PRT_LINE>
				<PRT_LINE>������------------------------------------------------------------------------------------------------</PRT_LINE>
				<PRT_LINE>
					<xsl:text>����������������������������               �����ڼ�    ��������    �������ս��    ���շ�     ����Ƶ��</xsl:text>
				</PRT_LINE>
				<PRT_LINE>������------------------------------------------------------------------------------------------------</PRT_LINE>
				<xsl:for-each select="Risk">
					<xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
					<xsl:variable name="ActPrem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)"/>
					<xsl:choose>
						<xsl:when test="RiskCode='L12081'">
						<!-- ����������������գ������ͣ� -->
							<PRT_LINE>
								<xsl:text>������</xsl:text>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 40)"/>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('����', 11)"/>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-', 10)"/>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-',16)"/>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-',13)"/>
								<xsl:text>-</xsl:text>
							</PRT_LINE>
						</xsl:when>
						<xsl:otherwise>
							<PRT_LINE>
								<xsl:text>������</xsl:text>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 40)"/>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '��'), 11)"/>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('һ����', 10)"/>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Amnt,16)"/>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($ActPrem,13)"/>
								<xsl:text>����</xsl:text>
							</PRT_LINE>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				<PRT_LINE>������------------------------------------------------------------------------------------------------</PRT_LINE>
				<PRT_LINE/>
				<PRT_LINE>���������շѺϼƣ�<xsl:value-of select="ActSumPremText" />��RMB<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>Ԫ����</PRT_LINE>
				<PRT_LINE>������------------------------------------------------------------------------------------------------</PRT_LINE>
				<PRT_LINE/>
				<PRT_LINE>������------------------------------------------------------------------------------------------------</PRT_LINE>
				<PRT_LINE>
					<xsl:text>      </xsl:text>
					<xsl:text>���յ��ر�Լ����</xsl:text>
				</PRT_LINE>
				<PRT_LINE>
				    <xsl:text>      </xsl:text>
					<xsl:text>    ������ı��ղ�ƷΪ����������ᱣ�ռƻ����������ڱ��պ�ͬ��Ч�������˱�������˾���˻����յ�</xsl:text>
				</PRT_LINE>
				<PRT_LINE>
				    <xsl:text>      </xsl:text>
					<xsl:text>�ֽ��ֵ��</xsl:text>
				</PRT_LINE>
				<PRT_LINE>
				    <xsl:text>      </xsl:text>
					<xsl:text>    ���������Ӯ1����ȫ���յ����ͬԼ����������ʱ�������պ�ͬЧ����ֹ�������պ�ͬͬʱ��ֹ����</xsl:text>
				</PRT_LINE>
				<PRT_LINE>
				    <xsl:text>      </xsl:text>
					<xsl:text>�������պ�ͬ�������պ�ͬ�������ڱ��ս�֮�͵�104%�Ľ��Զ�ת�밲��������������գ������ͣ���</xsl:text>
				</PRT_LINE>
				<PRT_LINE>
				    <xsl:text>      </xsl:text>
					<xsl:text>�����˻��У��������պ�ͬ�����������Զ�ת�������ʱ����Ч��</xsl:text>
				</PRT_LINE>
				<PRT_LINE/>
				<PRT_LINE>������------------------------------------------------------------------------------------------------</PRT_LINE>
				<PRT_LINE><xsl:text>���������պ�ͬ�������ڣ�</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,1,4)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,5,2)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,7,2)"/>��<xsl:text>                               ���պ�ͬ��Ч���ڣ�</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,1,4)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,5,2)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,7,2)"/>��</PRT_LINE>
				<PRT_LINE></PRT_LINE>
				<PRT_LINE><xsl:text>������Ӫҵ������</xsl:text><xsl:value-of select="ComName" /></PRT_LINE>
				<PRT_LINE></PRT_LINE>
				<PRT_LINE><xsl:text>������Ӫҵ��ַ��</xsl:text><xsl:value-of select="ComLocation" /></PRT_LINE>
				<PRT_LINE></PRT_LINE>
				<PRT_LINE><xsl:text>�������ͻ��������ߣ�95569                                            ��ַ��http://www.anbang-life.com</xsl:text></PRT_LINE>
				<PRT_LINE></PRT_LINE>
				<PRT_LINE><xsl:text>������Ϊȷ�����ı���Ȩ�棬�뼰ʱ�����ҹ�˾����绰����½��վ�򵽹�̨���в�ѯ����ʵ������Ϣ�����ڱ�����</xsl:text></PRT_LINE>
				<PRT_LINE><xsl:text>��������һ�������ϵ����ձ��������������յ�����֮����10��������״β�ѯ����</xsl:text></PRT_LINE>
				<PRT_LINE></PRT_LINE>
				<PRT_LINE><xsl:text>�����������������ƣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComName, 49)"/><xsl:text>����������Ա���ţ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(SellerNo, 0)"/></PRT_LINE>
			</PRT_DETAIL>
	    </PRTS>
	    <PRTS>
	    	<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]" />
	    	<xsl:variable name="fRisk" select="Risk[RiskCode!=MainRiskCode and CashValues/CashValue !='' ]" />
	    	<xsl:variable name="printmult1" select="concat('-(00001��',$ContPlanMultWith0)"/>
 	        <xsl:variable name="printmult2" select="concat($printmult1,')')"/>
	        <PRT_TYPE>2</PRT_TYPE>
	        <PRT_REC_NUM>0</PRT_REC_NUM>
	        <PRT_DETAIL>
			    <PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE/>
				<PRT_LINE><xsl:text>������                                        </xsl:text>�ֽ��ֵ��</PRT_LINE>
				<PRT_LINE/>
				<PRT_LINE>���������յ����룺<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(ContNo,$printmult2), 60)"/>��ֵ��λ�������Ԫ </PRT_LINE>
				<PRT_LINE>������------------------------------------------------------------------------------------------------</PRT_LINE>
				<PRT_LINE>��������������������<xsl:value-of select="Insured/Name"/></PRT_LINE>
	 	        <PRT_LINE>
			    <xsl:text>�������������ƣ�              </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName,38)"/><xsl:value-of select="$fRisk/RiskName"/></PRT_LINE>
		        <PRT_LINE><xsl:text/>�������������ĩ<xsl:text>                      </xsl:text>
				   <xsl:text>�ֽ��ֵ                              </xsl:text><xsl:text>�ֽ��ֵ</xsl:text></PRT_LINE>
		        <xsl:for-each select="$MainRisk/CashValues/CashValue">
			    <xsl:variable name="EndYear" select="EndYear"/>
			    <PRT_LINE>
					 <xsl:text/><xsl:text>����������</xsl:text>
					 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,28)"/>
					 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash), 'Ԫ'),38)"/>
					 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan($fRisk/CashValues/CashValue[EndYear=$EndYear]/Cash)"/>Ԫ</PRT_LINE>
			    </xsl:for-each>
				<PRT_LINE>������------------------------------------------------------------------------------------------------</PRT_LINE>
				<PRT_LINE/>
				<PRT_LINE>��������ע��</PRT_LINE>
				<PRT_LINE>�����������ֽ��ֵΪ��Ӧ�������ĩ��ֵ����������ڵ��ֽ��ֵ���������򱾹�˾��ѯ��</PRT_LINE>
				<PRT_LINE>������------------------------------------------------------------------------------------------------</PRT_LINE>	
			</PRT_DETAIL>	
	    </PRTS>
    </PRT>
</xsl:template> 


<!-- ֤�����͡�ע�⣺������  ���ո��Ű��õģ�����ȥ���� -->
<xsl:template match="IDType">
<xsl:choose>
	<xsl:when test=".=0">���֤  </xsl:when>
	<xsl:when test=".=1">����    </xsl:when>
	<xsl:when test=".=2">����֤  </xsl:when>
	<xsl:when test=".=3">����    </xsl:when>
	<xsl:when test=".=4">����֤��</xsl:when>
	<xsl:when test=".=5">���ڲ�  </xsl:when>
	<xsl:otherwise>--      </xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- �ɷѼ��  -->
<xsl:template match="PayIntv">
<xsl:choose>
	<xsl:when test=".=0">����</xsl:when>		
	<xsl:when test=".=1">�½�</xsl:when>
	<xsl:when test=".=3">����</xsl:when>
	<xsl:when test=".=6">�����</xsl:when>
	<xsl:when test=".=12">���</xsl:when>
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

<!-- ���ؽɷѷ�ʽ -->
<xsl:template name="tran_PayIntv">
    <xsl:param name="PayIntv">0</xsl:param>
	<xsl:choose>
	    <xsl:when test="$PayIntv = 0">W</xsl:when>
		<xsl:when test="$PayIntv = 12">Y</xsl:when>
		<xsl:when test="$PayIntv = 1">M</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$PayIntv"/>
		</xsl:otherwise>
	</xsl:choose>
 </xsl:template>
 
<xsl:template match="Head/Flag">
<xsl:choose>
	<xsl:when test=".='0'">0000</xsl:when>
	<xsl:when test=".='1'">0001</xsl:when>
	<xsl:otherwise>
	    <xsl:value-of select="Head/Flag"/>
	</xsl:otherwise>
</xsl:choose>
</xsl:template>

	<!-- �ɷ����������־ -->
	<xsl:template name="tran_PayEndYearFlag">
		<xsl:param name="payendyearflag" />
		<xsl:param name="payendyear" />
		<xsl:choose>
			<xsl:when test="$payendyearflag='Y' and $payendyear=1000">1</xsl:when><!-- ���� -->
			<xsl:when test="$payendyearflag='Y'">2</xsl:when><!-- ���� -->
			<xsl:when test="$payendyearflag='A'">4</xsl:when><!-- �����ɷ� -->
			<xsl:when test="$payendyearflag='A'">3</xsl:when><!-- ����ĳȷ������ -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
