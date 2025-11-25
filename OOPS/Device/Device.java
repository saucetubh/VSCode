public class Device {
    private String model;
    private int version;
    public Device(String model, int version) {
        this.model = model;
        this.version=version;
    }
    public void updateVersion(int newversion) {
        if(FirmwareChecker.isValid(this, newversion)) {
            this.version = newversion;
            System.out.println("UPDATED");
        }
        else {
            System.out.println("INVALID");
        }
    }
    static class FirmwareChecker {
        static boolean isValid(Device d, int newversion) {
            return(newversion > d.version); 
        }
    }

}