/**
 * @description  : Random string generator
 * @author       : simon@hyphen8.com
 * @created      : 18/10/2021
**/
public without sharing class AnonymiseHelper {
    private static final String STRING_CHARS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    private static final String NUMBER_CHARS = '1234567890';
    private static final String MIX_CHARS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
    private static Map<String, String> dataTypeToChars = new Map<String, String>{
        'String' => STRING_CHARS,
        'Number' => NUMBER_CHARS,
        'Mix' => MIX_CHARS
    };

    public static String generateRandomString(String dataType, Integer len) {
        final String chars = dataTypeToChars.get(dataType);
        String randStr = '';
        while (randStr.length() < len) {
           Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
           randStr += chars.substring(idx, idx+1);
        }
        return randStr; 
    }
}
