package security;

import java.net.NetworkInterface;
import java.util.Collections;

public class SystemCheck {

    public static boolean allow() {
        try {
            for (NetworkInterface ni :
                    Collections.list(NetworkInterface.getNetworkInterfaces())) {

                byte[] mac = ni.getHardwareAddress();
                if (mac != null) {
                    String m = "";
                    for (byte b : mac) {
                        m += String.format("%02X", b);
                    }
                    if (m.equals("5ECDC94ACB87")) { 
                        return true;
                    }
                }
            }
        } catch (Exception e) {}
        return false;
    }
}