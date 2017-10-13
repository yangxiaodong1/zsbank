/**
 * Copyright (c) 2006 sinosoft Co. Ltd.
 * All right reserved.
 */

package com.sinosoft.lis.vschema;

import com.sinosoft.lis.schema.HxbankManagerSchema;
import com.sinosoft.utility.*;

/**
 * <p>ClassName: HxbankManagerSet </p>
 * <p>Description: HxbankManagerSchemaSet���ļ� </p>
 * <p>Company: sinosoft </p>
 * @Database: PHYSICAL_DATA_MODEL_1
 * @author��Maker
 * @CreateDate��2014-04-23
 */
public class HxbankManagerSet extends SchemaSet
{
	// @Method
	public boolean add(HxbankManagerSchema aSchema)
	{
		return super.add(aSchema);
	}

	public boolean add(HxbankManagerSet aSet)
	{
		return super.add(aSet);
	}

	public boolean remove(HxbankManagerSchema aSchema)
	{
		return super.remove(aSchema);
	}

	public HxbankManagerSchema get(int index)
	{
		HxbankManagerSchema tSchema = (HxbankManagerSchema)super.getObj(index);
		return tSchema;
	}

	public boolean set(int index, HxbankManagerSchema aSchema)
	{
		return super.set(index,aSchema);
	}

	public boolean set(HxbankManagerSet aSet)
	{
		return super.set(aSet);
	}

	/**
	* ���ݴ������ XML ��ʽ�����˳��μ�<A href ={@docRoot}/dataStructure/tb.html#PrpHxbankManager����/A>���ֶ�
	* @return: String ���ش�����ַ���
	**/
	public String encode()
	{
		StringBuffer strReturn = new StringBuffer("");
		int n = this.size();
		for (int i = 1; i <= n; i++)
		{
			HxbankManagerSchema aSchema = this.get(i);
			strReturn.append(aSchema.encode());
			if( i != n ) strReturn.append(SysConst.RECORDSPLITER);
		}

		return strReturn.toString();
	}

	/**
	* ���ݽ��
	* @param: str String ������ַ���
	* @return: boolean
	**/
	public boolean decode( String str )
	{
		int nBeginPos = 0;
		int nEndPos = str.indexOf('^');
		this.clear();

		while( nEndPos != -1 )
		{
			HxbankManagerSchema aSchema = new HxbankManagerSchema();
			if(aSchema.decode(str.substring(nBeginPos, nEndPos)))
			{
			this.add(aSchema);
			nBeginPos = nEndPos + 1;
			nEndPos = str.indexOf('^', nEndPos + 1);
			}
			else
			{
				// @@������
				this.mErrors.copyAllErrors( aSchema.mErrors );
				return false;
			}
		}
		HxbankManagerSchema tSchema = new HxbankManagerSchema();
		if(tSchema.decode(str.substring(nBeginPos)))
		{
		this.add(tSchema);
		return true;
		}
		else
		{
			// @@������
			this.mErrors.copyAllErrors( tSchema.mErrors );
			return false;
		}
	}

}
