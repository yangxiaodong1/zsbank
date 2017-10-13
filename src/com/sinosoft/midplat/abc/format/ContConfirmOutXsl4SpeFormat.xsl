<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
 	exclude-result-prefixes="java">

<xsl:output indent='yes'/>
<xsl:template match="/TranData">
	  <!--���п����׼����ת��Ϊũ�зǱ�׼����-->
	  <Ret>
	  	<!-- �������ݰ� -->
	  <RetData>
	  		<Flag>
	  		  <xsl:if test="Head/Flag='0'">1</xsl:if>
	  		  <xsl:if test="Head/Flag='1'">0</xsl:if>
	  		</Flag>
	  		<Mesg><xsl:value-of select ="Head/Desc"/></Mesg>
	  	</RetData>
		<!-- ������׳ɹ����ŷ�������Ľ�� -->
		<xsl:if test="Head/Flag='0'">
			<!--Ͷ����Ϣ-->
			<Base>
				<ContNo><xsl:value-of select ="Body/ContNo"/></ContNo>
				<ProposalContNo><xsl:value-of select ="Body/ProposalPrtNo"/></ProposalContNo>
				<SignDate><xsl:value-of select ="Body/Risk[RiskCode=MainRiskCode]/SignDate"/></SignDate>
				<RiskName><xsl:value-of select ="Body/Risk[RiskCode=MainRiskCode]/RiskName"/></RiskName>
				<BankAccName><xsl:value-of select ="Body/BankAccName"/></BankAccName>
				<AgentCode><xsl:value-of select ="Body/AgentCode"/></AgentCode>
		    	<Prem><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/Prem)"/></Prem>
		    	<ContBgnDate><xsl:value-of select ="Body/Risk[RiskCode=MainRiskCode]/CValiDate"/></ContBgnDate>
		    	<ContEndDate><xsl:value-of select ="Body/Risk[RiskCode=MainRiskCode]/InsuEndDate"/></ContEndDate>
				<ComPhone>95569</ComPhone>
			</Base>
			<!-- �����б� -->
			<Risks>
				<Count><xsl:value-of select="count(Body/Risk)"/></Count>
				<xsl:for-each select="Body/Risk">
					<!-- ���� -->
					<Risk>
						<Name><xsl:value-of select="RiskName"/></Name>
						<Mult><xsl:value-of select="Mult"/></Mult>
						<Prem><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)"/></Prem>
						<PayEndYear><xsl:value-of select="PayEndYear"/></PayEndYear>
						<PayIntv><xsl:call-template name="tran_PayIntv">
								<xsl:with-param name="payIntv">
									<xsl:value-of select="PayIntv"/>
								</xsl:with-param>
							</xsl:call-template>
						</PayIntv>
					</Risk>
				</xsl:for-each>
			</Risks>
		<xsl:variable name="MainRisk" select="Body/Risk[RiskCode=MainRiskCode]"/>
        <!-- ���ִ�ӡ�б� -->
        <Prnts>
        	<Count></Count>
        	<Prnt>
        		<Value />
			</Prnt>
			<Prnt>
        		<Value />
			</Prnt>
			<Prnt>
        		<Value />
			</Prnt>
			<Prnt>
        		<Value />
			</Prnt>
			<Prnt>
        		<Value />
			</Prnt>
			<Prnt>
        		<Value />
			</Prnt>
			<Prnt>
        		<Value />
			</Prnt>
			<Prnt>
        		<Value />
			</Prnt>
            <Prnt>
              <Value>���յ����룺<xsl:value-of select="Body/ContNo"/>                                                    ��ֵ��λ�������Ԫ</Value>
            </Prnt>
            <Prnt>
            	<Value>------------------------------------------------------------------------------------------------</Value>
		    </Prnt>
            <Prnt>
              <Value>Ͷ����������<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Body/Appnt/Name, 29)"/>֤�����ͣ�<xsl:call-template name="tran_IDType"><xsl:with-param name="idtype"><xsl:value-of select ="Body/Appnt/IDType"/></xsl:with-param></xsl:call-template>    ֤�����룺<xsl:value-of select="Body/Appnt/IDNo"/></Value>
            </Prnt>
            <Prnt>
              <Value>�������ˣ�<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Body/Insured/Name, 31)"/>֤�����ͣ�<xsl:call-template name="tran_IDType"><xsl:with-param name="idtype"><xsl:value-of select ="Body/Insured/IDType"/></xsl:with-param></xsl:call-template>    ֤�����룺<xsl:value-of select="Body/Insured/IDNo"/></Value>
            </Prnt>
            <Prnt>
            	<Value />
            </Prnt>
            <Prnt>
            	<Value>------------------------------------------------------------------------------------------------</Value>
		    </Prnt>
		    <Prnt>
            	<Value>------------------------------------------------------------------------------------------------</Value>
		    </Prnt>
		    <xsl:if test="count(Body/Bnf)=0">
		    	<Prnt>
		    		<Value><xsl:text>��������ˣ�����                </xsl:text>
		    				<xsl:text>����˳��1                   </xsl:text>
		    				<xsl:text>���������100%</xsl:text></Value>
		    	</Prnt>
            </xsl:if>
            <xsl:if test="count(Body/Bnf)!=0">
            	<xsl:for-each select="Body/Bnf">
            		<Prnt>
            			<Value>��������ˣ�<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>����˳��<xsl:value-of select="Grade"/>                ���������<xsl:value-of select="Lot"/>%</Value> 
            		</Prnt>
            	</xsl:for-each>
            </xsl:if>
            <Prnt>
            	<Value>------------------------------------------------------------------------------------------------</Value>
		    </Prnt>
		    <Prnt>
		    	<Value />
            </Prnt>
		    <Prnt>
            	<Value>��������</Value>
		    </Prnt>
		    <Prnt>
            	<Value>------------------------------------------------------------------------------------------------</Value>
		    </Prnt>
		    <Prnt>
		    	<Value><xsl:text>��������������������                                        �������ս��\</xsl:text></Value>
            </Prnt>
		    <Prnt>
		    	<Value><xsl:text>����������������������                �����ڼ�    ��������    �ս�����\      ���շ�     ����Ƶ��</xsl:text></Value>
		    	
            </Prnt>
            <Prnt>
            	<Value><xsl:text>��������������������                                        ����\����</xsl:text></Value>
            </Prnt>
            <Prnt>
            	<Value>------------------------------------------------------------------------------------------------</Value>
		    </Prnt>
		    <xsl:for-each select="Body/Risk">
		    	<xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
		    	<xsl:variable name="Prem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)"/>
		    	<xsl:variable name="Falseflag" select="java:java.lang.Boolean.parseBoolean('true')"/>
		    	<Prnt>
		    		<Value><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 40)"/>
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
								</xsl:choose></Value>
				</Prnt>
			</xsl:for-each>
			<Prnt>
            	<Value>------------------------------------------------------------------------------------------------</Value>
		    </Prnt>
		    <Prnt>
        		<Value />
			</Prnt>
			<Prnt>
        		<Value />
			</Prnt>
			<Prnt>
        		<Value />
			</Prnt>
			<Prnt>
				<Value><xsl:text/>���շѺϼƣ�<xsl:value-of select="Body/PremText"/>��RMB<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Body/Prem)"/>Ԫ����</Value>
			</Prnt>
			<Prnt>
        		<Value />
			</Prnt>
			<Prnt>
            	<Value>------------------------------------------------------------------------------------------------</Value>
		    </Prnt>
		    <xsl:if test="$MainRisk/CashValues/CashValue != ''"> <!-- �����ֽ��ֵʱ����ӡ�ֽ��ֵ -->
		    	<Prnt>
	        		<Value>�ֺ챣�պ�����ȡ��ʽ���ۻ���Ϣ</Value>
				</Prnt>
		    </xsl:if>
		    <xsl:if test="$MainRisk/CashValues = ''"> <!-- �����ֽ��ֵʱ����ӡ����ҳ�հס� -->
			    <Prnt>
	        		<Value />
				</Prnt>
		    </xsl:if>
		    
			<Prnt>
            	<Value>------------------------------------------------------------------------------------------------</Value>
		    </Prnt>
		    <Prnt>
		    	<Value>���յ��ر�Լ����<xsl:choose>
								<xsl:when test="Body/Risk[RiskCode=MainRiskCode]/SpecContent = ''">
									<xsl:text>���ޣ�</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="Body/Risk[RiskCode=MainRiskCode]/SpecContent"/>
								</xsl:otherwise>
							</xsl:choose></Value>
			</Prnt>
			<Prnt>
        		<Value />
			</Prnt>
			<Prnt>
        		<Value />
			</Prnt>
			<Prnt>
        		<Value />
			</Prnt>
			<Prnt>
        		<Value />
			</Prnt>
			<Prnt>
            	<Value>------------------------------------------------------------------------------------------------</Value>
		    </Prnt>
		    <Prnt>
		    	<Value><xsl:text>���պ�ͬ�������ڣ�</xsl:text><xsl:value-of  select="substring(Body/Risk[RiskCode=MainRiskCode]/SignDate,1,4)"/>��<xsl:value-of  select="substring(Body/Risk[RiskCode=MainRiskCode]/SignDate,5,2)"/>��<xsl:value-of  select="substring(Body/Risk[RiskCode=MainRiskCode]/SignDate,7,2)"/>��<xsl:text>                               ���պ�ͬ��Ч���ڣ�</xsl:text><xsl:value-of  select="substring(Body/Risk[RiskCode=MainRiskCode]/CValiDate,1,4)"/>��<xsl:value-of  select="substring(Body/Risk[RiskCode=MainRiskCode]/CValiDate,5,2)"/>��<xsl:value-of  select="substring(Body/Risk[RiskCode=MainRiskCode]/CValiDate,7,2)"/>��</Value>
		    </Prnt>
		    <!--  -->
		    <Prnt>
        		<Value />
			</Prnt>
			<Prnt>
        		<Value />
			</Prnt>
		    <Prnt>
		    	<Value><xsl:text>Ӫҵ������</xsl:text><xsl:value-of select="Body/ComName" /></Value>
		    </Prnt>
		    <Prnt>
        		<Value />
			</Prnt>
			<Prnt>
        		<Value><xsl:text>Ӫҵ��ַ��</xsl:text><xsl:value-of select="Body/ComLocation" /></Value>
			</Prnt>
			<Prnt>
        		<Value />
			</Prnt>
			<Prnt>
        		<Value><xsl:text>�ͻ��������ߣ�95569                                            ��ַ��http://www.anbang-life.com</xsl:text></Value>
			</Prnt>
			<Prnt>
        		<Value />
			</Prnt>
			<Prnt>
        		<Value><xsl:text>Ϊȷ�����ı���Ȩ�棬�뼰ʱ�����ҹ�˾����绰����½��վ�򵽹�̨���в�ѯ����ʵ������Ϣ�����ڱ�����</xsl:text></Value>
			</Prnt>
			<Prnt>
        		<Value><xsl:text>��һ�������ϵ����ձ��������������յ�����֮����10��������״β�ѯ����</xsl:text></Value>
			</Prnt>
	</Prnts>

<xsl:if test="$MainRisk/CashValues/CashValue != ''"> <!-- �����ֽ��ֵʱ����ӡ�ֽ��ֵ -->	
<Messages>
	<Count></Count>
	<Message>
		<Value />
	</Message>
	<Message>
		<Value />
	</Message>
	<Message>
		<Value />
	</Message>
	<Message>
		<Value />
	</Message>
	<Message>
		<Value />
	</Message>
	<Message>
		<Value />
	</Message>
	<Message>
		<Value />
	</Message>
	<Message>
		<Value />
	</Message>
    <Message>
       <Value><xsl:text>������                                        </xsl:text>�ֽ��ֵ��</Value>
    </Message>
     <Message>
       <Value>���յ����룺<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Body/ContNo, 60)"/>��ֵ��λ�������Ԫ</Value>
    </Message>
    <Message>
    	<Value>------------------------------------------------------------------------------------------------</Value> 
    </Message>
    <Message>
    	<Value>��������������<xsl:value-of select="Body/Insured/Name"/></Value>
    </Message>
    <xsl:variable name="RiskCount" select="count(Body/Risk)"/>
    <xsl:if test="$RiskCount=1">
    	<Message>
    		<Value><xsl:text>�������ƣ�                  </xsl:text><xsl:value-of select="$MainRisk/RiskName"/></Value>
    	</Message>
    	<Message>
    		<Value><xsl:text>�������ĩ                              �ֽ��ֵ</xsl:text></Value>
    	</Message>
    	<xsl:for-each select="$MainRisk/CashValues/CashValue">
    		<Message>
    			<Value><xsl:text>����</xsl:text>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,36)"/>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)"/>Ԫ</Value>
    		</Message>
    	</xsl:for-each>
    </xsl:if>
    <xsl:if test="$RiskCount!=1">
    	<Message>
    		<Value><xsl:text>�������ƣ�          </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName,38)"/><xsl:value-of select="Body/Risk[RiskCode!=MainRiskCode]/RiskName"/></Value>
    	</Message>
    	<Message>
    		<Value><xsl:text>�������ĩ                                        �ֽ��ֵ</xsl:text></Value>
    	</Message>
    	<xsl:for-each select="$MainRisk/CashValues/CashValue">
    		<xsl:variable name="EndYear" select="EndYear"/>
    		<Message>
    			<Value><xsl:text>����</xsl:text>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,28)"/>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash), 'Ԫ'),40)"/>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../../../Risk[RiskCode!=MainRiskCode]/CashValues/CashValue[EndYear=$EndYear]/Cash)"/>Ԫ</Value>
    		</Message>
    	</xsl:for-each>
    </xsl:if>
    <Message>
    	<Value>------------------------------------------------------------------------------------------------</Value> 
    </Message>
    <Message>
		<Value />
	</Message>
	<Message>
		<Value>��ע:</Value>
	</Message>
	<Message>
		<Value>�����ֽ��ֵΪ��Ӧ�������ĩ��ֵ����������ڵ��ֽ��ֵ���������򱾹�˾��ѯ��</Value>
	</Message>
	<Message>
    	<Value>------------------------------------------------------------------------------------------------</Value> 
    </Message>
</Messages>
</xsl:if>

<xsl:if test="$MainRisk/CashValues = ''"> <!-- �����ֽ��ֵʱ����ӡ����ҳ�հס� -->
<Messages>
	<Count>0</Count>  
</Messages>
</xsl:if>

 </xsl:if> <!-- ������׳ɹ����ŷ�������Ľ�� -->		
 					  
 </Ret>
	</xsl:template>
	
	<!-- �ɷ�Ƶ��  ����: 1������  2���½�     3������    4�����꽻    5���꽻             6��������
                    ����:  0��һ�ν���/���� 1:�½�  3:����   6:���꽻	   12���꽻          -1:�����ڽ� -->
	<xsl:template name="tran_PayIntv">
		<xsl:param name="payIntv">0</xsl:param>
		<xsl:if test="$payIntv = '0'">1</xsl:if>
		<xsl:if test="$payIntv = '1'">2</xsl:if>
		<xsl:if test="$payIntv = '3'">3</xsl:if>
		<xsl:if test="$payIntv = '6'">4</xsl:if>
		<xsl:if test="$payIntv = '12'">5</xsl:if>
		<xsl:if test="$payIntv = '-1'">6</xsl:if>
	</xsl:template>
	
    <xsl:template name="tran_PayIntvCha">
		<xsl:param name="payIntv">0</xsl:param>
		<xsl:if test="$payIntv = '0'">����</xsl:if>
		<xsl:if test="$payIntv = '1'">�½�</xsl:if>
		<xsl:if test="$payIntv = '3'">����</xsl:if>
		<xsl:if test="$payIntv = '6'">���꽻</xsl:if>
		<xsl:if test="$payIntv = '12'">�꽻</xsl:if>
		<xsl:if test="$payIntv = '-1'">�����ڽ�</xsl:if>
	</xsl:template>
	   <xsl:template name="tran_IDType">
		<xsl:param name="idtype">���֤</xsl:param>
		<xsl:if test="$idtype = '0'">���֤    </xsl:if>
		<xsl:if test="$idtype = '1'">����      </xsl:if>
		<xsl:if test="$idtype = '2'">����֤    </xsl:if>
		<xsl:if test="$idtype = '5'">���ڲ�    </xsl:if>
		<xsl:if test="$idtype = '9'">�쳣���֤</xsl:if>
		<xsl:if test="$idtype = '8'">����      </xsl:if>
	</xsl:template>
</xsl:stylesheet>