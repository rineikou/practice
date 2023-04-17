package javase;

import java.util.Arrays;
import java.util.Scanner;

public class Struct {
    public static void main(String[] args) {
        //====用户交互scanner
        Scanner scanner = new Scanner(System.in);
        System.out.print("使用next方法接收：");
        System.out.println("输出："+scanner.next());//以空格为结束符，必须有有效字符输入
        scanner.nextLine();//返回扫描器所有内容，相当于清空扫描器，防止影响下文对扫描器的读取和判断
        System.out.print("使用nextLine方法接收：");
        System.out.println("输出："+scanner.nextLine());//以回车为结束符，会返回扫描器所有内容；可以输入空白内容

        System.out.print("请输入一个整数：");
        System.out.println(scanner.hasNextByte()?"是整数数据:"+scanner.nextLine():scanner.nextLine()+"\t不是整数数据");
        System.out.print("请输入一个小数：");
        if(scanner.hasNextFloat()){
            System.out.println("小数数据："+scanner.nextFloat());
        }
        else{
            System.out.println("不是小数数据");

        }
        scanner.nextLine();//清空扫描器
        double sum =0;
        int i =0;
        System.out.print("请输入数据进行统计：");
        while(scanner.hasNextDouble()){
            double d = scanner.nextDouble();
            i++;
            sum = sum + d;
            System.out.println("你输入了第"+i+"个数据，当前sum="+sum);
            System.out.print("请继续输入数据（输入非数字结束计算）:");
        }
        scanner.nextLine();
        System.out.println(i+"个数的和是"+sum);
        System.out.println(i+"个数的平均值是"+(sum/i));
        scanner.close();//不需要scanner的时候记得关掉；会同时关闭System.in，所以需要确保不需要System.in再关闭
    }
}
