<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
	<xsl:template match="/">
		<TXLife> 		
			<xsl:copy-of select="TranData/Head" /><!-- icbcNetImpl���������head���������ؽڵ� -->				
			<TXLifeResponse>
				<TransRefGUID/>
				<TransType></TransType>
				<TransExeDate>
					<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()"/>
				</TransExeDate>
				<TransExeTime>
					<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur8Time()"/>
				</TransExeTime>															
				<!-- չ�ַ��صĽ�� -->
				<xsl:apply-templates select="TranData/Body"/>
			</TXLifeResponse>
		</TXLife>
	</xsl:template>
	
	<xsl:template name="OLifE" match="Body">		
		<OLifE>
			<FormInstance id="Form_1">
				<!-- ��֤���� TODO �Ƿ���Ҫת��code-->
				<FormName><xsl:value-of select="PubEdorConfirm/FormType"></xsl:value-of></FormName>
				<!-- ������ -->
				<DocumentControlNumber><xsl:value-of select="PubEdorConfirm/FormNumber"></xsl:value-of></DocumentControlNumber>
				<!-- ���ģ����ظ��� -->
				<Attachment id="Attachment_1">
					<!-- ��������1����һ�У� -->
					<AttachmentData>content</AttachmentData>
				</Attachment>
				<Attachment id="Attachment_2">
					<!-- ��������2���ڶ��У� -->
					<AttachmentData>content</AttachmentData>
				</Attachment>
				<Attachment id="Attachment_3">
					<!-- ��������3�������У� -->
					<AttachmentData>content</AttachmentData>
				</Attachment>
			</FormInstance>
		</OLifE>
		<!-- ��̬��ӡ��־ -->
		<DynamicPrintIndicator>Y</DynamicPrintIndicator>
		<!--ƾ֤���д�ӡ�ӿڣ���Ҫ��DynamicPrintIndicator�ڵ�ֵΪY-->
		<Print>
			<!--ƾ֤����-->
			<VoucherNum>1</VoucherNum>
			<SubVoucher>
				<!--ƾ֤���� ����-->
				<VoucherType>8</VoucherType>
				<!--ƾ֤�ı�-->
				<!--��ҳ��-->
				<PageTotal>1</PageTotal>
				<Text>
					<!--ҳ��-->
					<PageNum>1</PageNum>
					<TextContent>
						  <RowNum>1</RowNum>
					    <TextRowContent></TextRowContent>
					</TextContent>
					<TextContent>
						  <RowNum>2</RowNum>
					    <TextRowContent></TextRowContent>
					</TextContent>
					<TextContent>
						  <RowNum>3</RowNum>
					    <TextRowContent></TextRowContent>
					</TextContent>
					<TextContent>
						  <RowNum>4</RowNum>
					    <TextRowContent></TextRowContent>
					</TextContent>
									<TextContent>
						  <RowNum>5</RowNum>
					    <TextRowContent></TextRowContent>
					</TextContent>
					<TextContent>
						  <RowNum>6</RowNum>
					    <TextRowContent>                               ��    ��    ��    ��</TextRowContent>
					</TextContent>
					<TextContent>
						  <RowNum>7</RowNum>
					    <TextRowContent>                              ������ͨ��ȫҵ��ר�ã�</TextRowContent>
					</TextContent>
					<TextContent>
						  <RowNum>8</RowNum>
					    <TextRowContent></TextRowContent>
					</TextContent>
					<TextContent>
						  <RowNum>9</RowNum>
					    <TextRowContent>    Ͷ���ˣ�<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(PubContInfo/AppntName, 16)"/>�������ˣ�<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(PubContInfo/InsuredName, 16)"/>�����ţ�<xsl:value-of select="PubEdorConfirm/FormNumber" /></TextRowContent>
					</TextContent>
					<TextContent>
						  <RowNum>10</RowNum>
					    <TextRowContent></TextRowContent>
					</TextContent>
					<TextContent>
						  <RowNum>11</RowNum>
					    <TextRowContent>        ��<xsl:value-of select="PubContInfo/AppntName" />���룬����˾���ͬ�⣬��<xsl:value-of select="PubContInfo/ContNo" />�ű�����������ע��   </TextRowContent>
					</TextContent>										
					<TextContent>
						  <RowNum>12</RowNum>
					    <TextRowContent></TextRowContent>
					</TextContent>
					<TextContent>    
					    <RowNum>13</RowNum>
					    <TextRowContent>    �����Ŀ�������ͬ</TextRowContent>
					</TextContent>
					<TextContent>    
					    <RowNum>14</RowNum>
					    <TextRowContent>    ������ݣ�</TextRowContent>
					</TextContent>
					<TextContent>    
					    <RowNum>15</RowNum>
					    <TextRowContent>������������   �������ơ���������               ��������       Ӧ�˽��</TextRowContent>
					</TextContent>
					<xsl:for-each select="PubContInfo/Risk">
						<TextContent>    
					    	<RowNum><xsl:value-of select="15 + position()"/></RowNum>
						    
						    <TextRowContent>
								<xsl:choose>
									<xsl:when test="RiskCode =122001">����������ƽ�1����ȫ���գ��ֺ��ͣ�A��            </xsl:when>	
									<xsl:when test="RiskCode =122002">����������ƽ�2����ȫ���գ��ֺ��ͣ�A��            </xsl:when>	
									<xsl:when test="RiskCode =122004">����������ӻƽ�2����ȫ���գ��ֺ��ͣ�A��        </xsl:when>	
									<xsl:when test="RiskCode =122003">����������۱���1����ȫ���գ��ֺ��ͣ�A��            </xsl:when>	
									<xsl:when test="RiskCode =122006">����������۱���2����ȫ���գ��ֺ��ͣ�A��            </xsl:when>	
									<xsl:when test="RiskCode =122008">���������������1���������գ������ͣ�               </xsl:when>	
									<xsl:when test="RiskCode =122009">����������ƽ�5����ȫ���գ��ֺ��ͣ�A��            </xsl:when>	
									<xsl:when test="RiskCode =122011">����������ʢ��1���������գ������ͣ�                 </xsl:when>
									<xsl:when test="RiskCode =122012"> ���� ����ʢ��2���������գ������ͣ�                 </xsl:when>	
									<xsl:when test="RiskCode =122010">����������ʢ��3���������գ������ͣ�                 </xsl:when>
									<xsl:when test="RiskCode =122029">����������ʢ��5���������գ������ͣ�                 </xsl:when>
									<xsl:when test="RiskCode =122020"> ���� �����6����ȫ���գ��ֺ��ͣ�                 </xsl:when>
									<xsl:when test="RiskCode =122036">  ��������ƽ�6����ȫ���գ��ֺ��ͣ�A��            </xsl:when>
									
									<!-- 50002: 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�122048-����������������գ������ͣ����  -->
									<!-- ǰ����50002����Ʒ������Ϊ122046�������������յĲ�ƷΪ122048,���5������˱�ʱ���Ĵ����������ֱ����122048 -->
									
									<!-- <xsl:when test="RiskCode =122046"> �����������Ӯ1����ȫ����                      </xsl:when>
									<xsl:when test="RiskCode =122047"> ��������ӳ�����Ӯ��ȫ����                     </xsl:when> -->
									<xsl:when test="RiskCode =122048"> ��������������������գ������ͣ�               </xsl:when>
										
									<!-- PBKINSR-679 ����ʢ2�����桢�����������նˣ���ʢ3�����桢�����������նˣ���ʢ9�����棩��50002�����桢�����������նˣ���Ʒ���� -->
									<xsl:when test="RiskCode ='L12079'">  ��������ʢ��2���������գ������ͣ�                 </xsl:when>	
									<xsl:when test="RiskCode ='L12078'">����������ʢ��3���������գ������ͣ�                 </xsl:when>
									<xsl:when test="RiskCode ='L12100'">����������ʢ��3���������գ������ͣ�                 </xsl:when>
									<xsl:when test="RiskCode ='122046'">  �����������Ӯ1����ȫ����                      </xsl:when>
									<xsl:when test="RiskCode ='122047'">  ��������ӳ�����Ӯ��ȫ����                     </xsl:when>
									<xsl:when test="RiskCode ='L12081'">  ��������������������գ������ͣ�               </xsl:when>
									<!-- PBKINSR-679 ����ʢ2�����桢�����������նˣ���ʢ3�����桢�����������նˣ���ʢ9�����棩��50002�����桢�����������նˣ���Ʒ���� -->
									<xsl:otherwise>--</xsl:otherwise>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="RiskCode=MainRiskCode">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('����', 14)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('������', 14)"/>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(GetMoney)"/>Ԫ</TextRowContent>
						</TextContent>
					</xsl:for-each>
					<TextContent>    
						  <RowNum>19</RowNum>
						  <TextRowContent>    ʵ�˽�<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(PubContInfo/FinActivityGrossAmt)" />Ԫ</TextRowContent>					     
					</TextContent>
					<TextContent>    
						  <RowNum>20</RowNum>
						  <TextRowContent></TextRowContent>					     
					</TextContent>
					<TextContent>    
						  <RowNum>21</RowNum>
						  <TextRowContent>    ������Ч���ڣ�<xsl:apply-templates select="PubContInfo/EdorAppDate" /></TextRowContent>					     
					</TextContent>
				  <TextContent>    
						  <RowNum>22</RowNum>
						  <TextRowContent></TextRowContent>					     
					</TextContent>
					<TextContent>    
						  <RowNum>23</RowNum>
						  <TextRowContent>    �ش����ģ�</TextRowContent>					     
					</TextContent>				
				</Text>
			</SubVoucher>
		</Print>
		
	</xsl:template>

	<!-- ������Ϣ -->
	<xsl:template name="AttachmentData" match="Risk">							
		<xsl:choose>
			<xsl:when test="RiskCode =122001">    ����ƽ�1����ȫ���գ��ֺ��ͣ�A��            </xsl:when>	
			<xsl:when test="RiskCode =122002">    ����ƽ�2����ȫ���գ��ֺ��ͣ�A��            </xsl:when>	
			<xsl:when test="RiskCode =122004">    ����ӻƽ�2����ȫ���գ��ֺ��ͣ�A��        </xsl:when>	
			<xsl:when test="RiskCode =122003">    ����۱���1����ȫ���գ��ֺ��ͣ�A��            </xsl:when>	
			<xsl:when test="RiskCode =122006">    ����۱���2����ȫ���գ��ֺ��ͣ�A��            </xsl:when>	
			<xsl:when test="RiskCode =122008">    ���������1���������գ������ͣ�               </xsl:when>	
			<xsl:when test="RiskCode =122009">    ����ƽ�5����ȫ���գ��ֺ��ͣ�A��            </xsl:when>	
			<xsl:when test="RiskCode =122011">    ����ʢ��1���������գ������ͣ�                 </xsl:when>	
			<xsl:when test="RiskCode =122012">    ����ʢ��2���������գ������ͣ�                 </xsl:when>	
			<xsl:when test="RiskCode =122010">    ����ʢ��3���������գ������ͣ�                 </xsl:when>
			<xsl:when test="RiskCode =L12100">    ����ʢ��3���������գ������ͣ�                 </xsl:when>
			
			<xsl:when test="RiskCode =122029">    ����ʢ��5���������գ������ͣ�                 </xsl:when>
			<xsl:when test="RiskCode =122020">    �����6����ȫ���գ��ֺ��ͣ�                 </xsl:when>
			<xsl:when test="RiskCode =122036">    ����ƽ�6����ȫ���գ��ֺ��ͣ�A��            </xsl:when>
			
			<!-- 50002: 122046-�������Ӯ1����ȫ���ա�122047-����ӳ�����Ӯ��ȫ���ա�122048-����������������գ������ͣ����  -->
			<!-- ǰ����50002����Ʒ������Ϊ122046�������������յĲ�ƷΪ122048,���5������˱�ʱ���Ĵ����������ֱ����122048 -->
			
			<!-- <xsl:when test="RiskCode =122046">    �������Ӯ1����ȫ����                      </xsl:when>
			<xsl:when test="RiskCode =122047">    ����ӳ�����Ӯ��ȫ����                     </xsl:when> -->
			<xsl:when test="RiskCode =122048">    ����������������գ������ͣ�                </xsl:when>  
			
			<!-- PBKINSR-679 ����ʢ2�����桢�����������նˣ���ʢ3�����桢�����������նˣ���ʢ9�����棩��50002�����桢�����������նˣ���Ʒ���� -->
			<xsl:when test="RiskCode ='L12079'">    ����ʢ��2���������գ������ͣ�                 </xsl:when>	
			<xsl:when test="RiskCode ='L12078'">    ����ʢ��3���������գ������ͣ�                 </xsl:when>
			<xsl:when test="RiskCode ='122046'">    �������Ӯ1����ȫ����                      </xsl:when>
			<xsl:when test="RiskCode ='122047'">    ����ӳ�����Ӯ��ȫ����                     </xsl:when>
			<xsl:when test="RiskCode ='L12081'">    ����������������գ������ͣ�               </xsl:when>
			<!-- PBKINSR-679 ����ʢ2�����桢�����������նˣ���ʢ3�����桢�����������նˣ���ʢ9�����棩��50002�����桢�����������նˣ���Ʒ���� -->	
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="RiskCode=MainRiskCode">
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('����', 14)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('������', 12)"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(GetMoney)"/>Ԫ</xsl:template>
</xsl:stylesheet>
