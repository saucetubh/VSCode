import java.util.*;

/*
 VehicleManagement keeps track of registered vehicles and provides
 lookup utilities. Requirements covered:
 1) Store every registered vehicle in a HashMap named 'vehs'.
	- Key   : registrationNo (Integer)
	- Value : VehicleRegistration object (contains chasisNo, ownerName)
 2) Provide retrieval methods for Vehicle objects by:
	a) registrationNo
	b) insuranceNo
	c) ownerName (as a Set of vehicles)

 Notes:
 - VehicleRegistration is a static nested class inside Vehicle.
 - Subclasses (Car, Bike, Truck) each expose getVehReg() to access it.
 - VehicleInsurance details are available via Vehicle#getVehicleInsurance().
*/
class VehicleManagement {
	// Map as mandated by the problem statement
	// Key: registrationNo; Value: VehicleRegistration (chasisNo, ownerName held inside)
	public final Map<Integer, Vehicle.VehicleRegistration> vehs = new HashMap<>();

	// Internal indexes to quickly retrieve Vehicle objects
	private final Map<Integer, Vehicle> regNoToVehicle = new HashMap<>();
	private final Map<Integer, Set<Vehicle>> insuranceToVehicles = new HashMap<>();
	private final Map<String, Set<Vehicle>> ownerToVehicles = new HashMap<>();

	// Register a vehicle into all indexes
	void registerVehicle(Vehicle v) {
		if (v == null) return;
		Vehicle.VehicleRegistration vr = getVehReg(v);
		if (vr == null) return; // cannot register without registration

		int regNo = vr.getRegistrationNo();
		String owner = vr.getOwnerName();
		int insuranceNo = v.getVehicleInsurance() != null ? v.getVehicleInsurance().getInsuranceNo() : -1;

		vehs.put(regNo, vr);
		regNoToVehicle.put(regNo, v);
		if (insuranceNo != -1) {
			insuranceToVehicles.computeIfAbsent(insuranceNo, k -> new HashSet<>()).add(v);
		}
		if (owner != null) {
			ownerToVehicles.computeIfAbsent(owner, k -> new HashSet<>()).add(v);
		}
	}

	// Retrieve a Vehicle by registration number
	Vehicle getVehicleByRegistrationNo(int registrationNo) {
		return regNoToVehicle.get(registrationNo);
	}

	// Retrieve Vehicles by insurance number
	Set<Vehicle> getVehiclesByInsuranceNo(int insuranceNo) {
		Set<Vehicle> result = insuranceToVehicles.get(insuranceNo);
		return (result == null) ? Collections.emptySet() : new HashSet<>(result);
	}

	// Retrieve Vehicles owned by a given owner
	Set<Vehicle> getVehiclesByOwner(String ownerName) {
		if (ownerName == null) return Collections.emptySet();
		Set<Vehicle> result = ownerToVehicles.get(ownerName);
		return (result == null) ? Collections.emptySet() : new HashSet<>(result);
	}

	// Helper: extract VehicleRegistration from a Vehicle instance via downcast
	private static Vehicle.VehicleRegistration getVehReg(Vehicle v) {
		if (v instanceof Car) return ((Car) v).getVehReg();
		if (v instanceof Bike) return ((Bike) v).getVehReg();
		if (v instanceof Truck) return ((Truck) v).getVehReg();
		return null;
	}
}

