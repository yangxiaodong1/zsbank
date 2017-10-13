package com.sinosoft.midplat.common;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
/**
 * 日期工具类
 * @author ab041417
 *
 */
public class DateTimeUtils {

	/**
	 * 获取当前日期之后的日期
	 * 
	 * @param dateStr
	 *            当前日期:
	 * @param regex
	 *            格式(当前日期的格式)
	 * @param days
	 *            天数 +增加； -减少
	 * @return
	 * @throws ParseException
	 */
	public static String getNDaysLater(String dateStr, String regex, int days)throws ParseException {

		SimpleDateFormat df = new SimpleDateFormat(regex);

		Calendar calstart = Calendar.getInstance();
		calstart.setTime(df.parse(dateStr));

		calstart.add(Calendar.DAY_OF_YEAR, days);

		return new SimpleDateFormat(regex).format(calstart.getTime());

	}
	
	public static void main(String[] args) {
		try {
			System.out.println(getNext8Day());
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	   public static String getNext8Day()throws ParseException {

	        SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");

	        Calendar calstart = Calendar.getInstance();

	        calstart.add(Calendar.DAY_OF_YEAR, 1);

	        return df.format(calstart.getTime());

	    }
}

