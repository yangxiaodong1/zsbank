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
					<TextContent>    
				    	<RowNum>16</RowNum>
					    <TextRowContent><xsl:apply-templates select="PubContInfo" /></TextRowContent>					     
					</TextContent>
					<TextContent>    
						  <RowNum>17</RowNum>
						  <TextRowContent>    ʵ�˽�<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(PubContInfo/FinActivityGrossAmt)" />Ԫ</TextRowContent>					     
					</TextContent>
					<TextContent>    
						  <RowNum>18</RowNum>
						  <TextRowContent></TextRowContent>					     
					</TextContent>
					<TextContent>    
						  <RowNum>19</RowNum>
						  <TextRowContent>    ������Ч���ڣ�<xsl:apply-templates select="PubContInfo/EdorAppDate" /></TextRowContent>					     
					</TextContent>
				  <TextContent>    
						  <RowNum>20</RowNum>
						  <TextRowContent></TextRowContent>					     
					</TextContent>
					<TextContent>    
						  <RowNum>21</RowNum>
						  <TextRowContent>    �ش����ģ�</TextRowContent>					     
					</TextContent>				
				</Text>
			</SubVoucher>
		</Print>
		
	</xsl:template>

	<!-- ������Ϣ -->
	<xsl:template name="AttachmentData" match="PubContInfo">							
		 <xsl:choose>
		      <xsl:when test="MainRiskCode =122001">    ����ƽ�1����ȫ���գ��ֺ��ͣ�A��            </xsl:when>	
		      <xsl:when test="MainRiskCode =122002">    ����ƽ�2����ȫ���գ��ֺ��ͣ�A��            </xsl:when>	
		      <xsl:when test="MainRiskCode =122004">    ����ӻƽ�2����ȫ���գ��ֺ��ͣ�A��        </xsl:when>	
		      <xsl:when test="MainRiskCode =122003">    ����۱���1����ȫ���գ��ֺ��ͣ�A��            </xsl:when>	
		      <xsl:when test="MainRiskCode =122006">    ����۱���2����ȫ���գ��ֺ��ͣ�A��            </xsl:when>	
		      <xsl:when test="MainRiskCode =122008">    ���������1���������գ������ͣ�               </xsl:when>	
		      <xsl:when test="MainRiskCode =122009">    ����ƽ�5����ȫ���գ��ֺ��ͣ�A��            </xsl:when>	
		      <xsl:when test="MainRiskCode =122011">    ����ʢ��1���������գ������ͣ�                 </xsl:when>
		      <xsl:when test="MainRiskCode =122012">    ����ʢ��2���������գ������ͣ�                 </xsl:when>	
		      <xsl:when test="MainRiskCode =122010">    ����ʢ��3���������գ������ͣ�                 </xsl:when>
		      <xsl:when test="MainRiskCode =122029">    ����ʢ��5���������գ������ͣ�                 </xsl:when>
		      <xsl:when test="MainRiskCode =122020">    �����6����ȫ���գ��ֺ��ͣ�                 </xsl:when>
		      <xsl:when test="MainRiskCode =122036">    ����ƽ�6����ȫ���գ��ֺ��ͣ�A��            </xsl:when>
		      <xsl:when test="MainRiskCode =122038">    �����ֵ����8���������գ��ֺ��ͣ�A��          </xsl:when>
		      <!-- PBKINSR-679 ����ʢ2�����桢�����������նˣ���ʢ3�����桢�����������նˣ���ʢ9�����棩��50002�����桢�����������նˣ���Ʒ���� -->
			  <xsl:when test="MainRiskCode ='L12079'">    ����ʢ��2���������գ������ͣ�                 </xsl:when>	
			  <xsl:when test="MainRiskCode ='L12078'">    ����ʢ��3���������գ������ͣ�                 </xsl:when>
			   <xsl:when test="MainRiskCode =L12100">    ����ʢ��3���������գ������ͣ�                 </xsl:when>
			  <!-- PBKINSR-679 ����ʢ2�����桢�����������նˣ���ʢ3�����桢�����������նˣ���ʢ9�����棩��50002�����桢�����������նˣ���Ʒ���� -->
			  <!-- PBKINSR-787 ���У�����ͨ����ʢ��9���²�Ʒ��Ŀ -->
			  <xsl:when test="MainRiskCode ='L12074'">    ����ʢ��9����ȫ���գ������ͣ�                 </xsl:when>	
			  <!-- PBKINSR-787 ���У�����ͨ����ʢ��9���²�Ʒ��Ŀ -->
			  <!-- PBKINSR-818 �㽭����ר���Ʒ��Ŀ��һ�ڣ� -->
			  <xsl:when test="MainRiskCode ='L12077'">    ����ʢ��2���������գ������ͣ�                 </xsl:when>
			  <!-- PBKINSR-818 �㽭����ר���Ʒ��Ŀ��һ�ڣ� -->
			  <!-- PBKINSR-924 �������������²�Ʒ�������Ӯ2�������A�-->
			  <xsl:when test="MainRiskCode ='L12084'">    �����Ӯ2�������A��                        </xsl:when>
			  <xsl:when test="MainRiskCode ='L12089'">    ����ʢ��1���������գ������ͣ�B��            </xsl:when>
			  <xsl:when test="MainRiskCode ='L12093'">    ����ʢ��9����ȫ����B������ͣ�               </xsl:when>
			  <xsl:when test="MainRiskCode ='L12086'">    �����3����ȫ���գ������ͣ�               </xsl:when>
		      <xsl:when test="MainRiskCode ='L12102'">    ����ʢ��9����ȫ���գ������ͣ�                 </xsl:when>	
			  <xsl:when test="MainRiskCode ='L12088'">    �����9����ȫ���գ������ͣ�               </xsl:when>
			  <xsl:when test="MainRiskCode ='L12085'">    �����2����ȫ���գ������ͣ�               </xsl:when>
			  <xsl:when test="MainRiskCode ='L12087'">    �����5����ȫ���գ������ͣ�			  </xsl:when>
			  
		      <xsl:otherwise>--</xsl:otherwise>
		  </xsl:choose>
			<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('����', 13)"/>
			<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(FinActivityGrossAmt)" />Ԫ</xsl:template>	
</xsl:stylesheet>
