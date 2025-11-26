class Vehicle {
    static int c;
    String model, fuelType;
    int startCount=0;
    Maintenance[] checklist;
    public Vehicle(String model, String fuelType) {
        this.model = model;
        this.fuelType=fuelType;
    }
    static class Maintenance {
        int startCnt;
        static String[][] maintenanceReq = {{"Hyundai", "2020", "petrol", "2"}, {"Hyundai", "2025", "petrol", "3"}, {"Maruti", "2020", "diesel", "1"}, {"Maruti", "2025", "diesel", "4"}, {"Comet", "2025", "EV", "2"}};
        public Maintenance(int startCnt) {
            this.startCnt = startCnt;
        }
    }
    public void check() {
        Maintenance m = new Maintenance(this.startCount);
        maintain(m);
    }
    public void maintain(Maintenance m) {
        int i;
        int j=3;
        if(this.model.equals("Hyundai2020")) i=0;
        else if(this.model.equals("Hyundai2025")) i=1;
        else if(this.model.equals("Maruti2020")) i=2;
        else if(this.model.equals("Maruti2025")) i=3;
        else i=4;

        if(this.startCount >= Integer.valueOf(Maintenance.maintenanceReq[i][j])) {
            this.checklist[++c] = m;
            startCount = 0;
        }
    }
}