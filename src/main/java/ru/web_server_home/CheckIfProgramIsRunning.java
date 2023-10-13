package ru.web_server_home;

/*import com.sun.jna.Library;
import com.sun.jna.Native;
import com.sun.jna.platform.win32.WinDef;
import com.sun.jna.platform.win32.WinNT;
import com.sun.jna.platform.win32.WinBase;
import com.sun.jna.platform.win32.Tlhelp32;
import com.sun.jna.ptr.IntByReference;*/

public class CheckIfProgramIsRunning {
   /* public interface Kernel32 extends Library {
        Kernel32 INSTANCE = (Kernel32) Native.load("kernel32", Kernel32.class);

        WinNT.HANDLE CreateToolhelp32Snapshot(WinDef.DWORD flags, WinDef.DWORD processID);

        boolean Process32First(WinNT.HANDLE snapshot, Tlhelp32.PROCESSENTRY32 processEntry);

        boolean Process32Next(WinNT.HANDLE snapshot, Tlhelp32.PROCESSENTRY32 processEntry);

        void CloseHandle(WinNT.HANDLE hObject);
    }

    public static void main(String[] args) {
        String programName = "SQLiteExpertPers64.exe"; // Название программы, которую вы хотите проверить

        WinNT.HANDLE snapshot = Kernel32.INSTANCE.CreateToolhelp32Snapshot(Tlhelp32.TH32CS_SNAPPROCESS, new WinDef.DWORD(0));

        Tlhelp32.PROCESSENTRY32 processEntry = new Tlhelp32.PROCESSENTRY32();
        processEntry.dwSize = new WinDef.DWORD(processEntry.size());

        boolean isRunning = false;

        if (Kernel32.INSTANCE.Process32First(snapshot, processEntry)) {
            do {
                String runningProcessName = Native.toString(processEntry.szExeFile);
                if (runningProcessName.equals(programName)) {
                    isRunning = true;
                    break;
                }
            } while (Kernel32.INSTANCE.Process32Next(snapshot, processEntry));
        }

        Kernel32.INSTANCE.CloseHandle(snapshot);

        if (isRunning) {
            System.out.println(programName + " запущена.");
        } else {
            System.out.println(programName + " не запущена.");
        }
    }*/
}
