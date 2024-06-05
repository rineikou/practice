package javase;

import java.math.BigDecimal;
//JavaSE, 01基础
/**
 * @author jojo
 * @version 1.0
 * @since jdk17
 */
public class Base {
    /**
     *
     * @param args 参数
     * @throws Exception 抛出异常
     */
    public static void main(String[] args) throws Exception {
        //基本数据类型
        boolean flag = true;
        char char1 = '淦';
        char char2 = '\u0061';
        byte byte1 = 10;
        short short1 = 4323;//16位
        int int1 =0b10;//二进制
        int int2 = 010;//八进制
        int int3 = 10;
        int int4 = 0x10;//十六进制
        long long1 = 32_3546_1257_5434_3454L;//long后面要加L
        float float1 = 123.456788F;//float后面要加F，7~8位有效数字
        float float2 = 123.456789f;
        double double1 = 123_3243_2333.456789;//15位有效数
        double double2 = (double)byte1;//强制转换类型；由低到高，不能转换bool
        System.out.printf("布尔：%b\t字符：%s,%s\n",flag,char1,char2);
        System.out.printf("整数%d,%d,%d,%d,%d,%d,%d\n",byte1,short1,int1,int2,int3,int4,long1);
        System.out.printf("浮点数%f,%f,%.2f,%f\n",float1,double1,double1,double2);// "%.2f"表示保留2位小数
        System.out.printf("比较float:%b\n",float1==float2);//超出有效数字
        System.out.printf("常量：%f\n",PI);
        BigDecimal bigDecimal1 = new BigDecimal(1234.567800000);
        double pow1 = Math.pow(2,3.3);
        System.out.printf("小数：%f\t幂运算：%f\n",bigDecimal1,pow1);
    }
    static final double PI = 3.1415926535897932;//static表示只能本文件内调用，final表示常量
}
