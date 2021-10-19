/**
 * @author       : simon@hyphen8.com
 * @created      : 19/10/2021
**/
@IsTest
public class AnonymiseHelperTest {
    @IsTest
    static void testGenerateRandomStringString(){
        String testString = 'ThisIsATestString';
        testString = AnonymiseHelper.generateRandomString('String', 10);

        System.assertEquals(10, testString.length());
        System.assertNotEquals('ThisIsATestString', testString);
    }

    @IsTest
    static void testGenerateRandomStringNumber(){
        String testString = '0123456789';
        testString = AnonymiseHelper.generateRandomString('Number', 5);

        System.assertEquals(5, testString.length());
        System.assertNotEquals('0123456789', testString);
    }

    @IsTest
    static void testGenerateRandomStringMix(){
        String testString = 'ThisIsATestStringForMixing';
        testString = AnonymiseHelper.generateRandomString('Mix', 10);

        System.assertEquals(10, testString.length());
        System.assertNotEquals('ThisIsATestStringForMixing', testString);
    }
}
