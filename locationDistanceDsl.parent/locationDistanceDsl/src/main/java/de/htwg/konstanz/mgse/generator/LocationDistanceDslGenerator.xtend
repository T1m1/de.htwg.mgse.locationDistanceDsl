package de.htwg.konstanz.mgse.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext


import de.htwg.konstanz.mgse.locationDistanceDsl.Land
import de.htwg.konstanz.mgse.locationDistanceDsl.Trip
import de.htwg.konstanz.mgse.locationDistanceDsl.Location
import de.htwg.konstanz.mgse.locationDistanceDsl.Geokoordinaten

import java.util.HashMap
import java.util.Map


class LocationDistanceDslGenerator extends AbstractGenerator {

	var Land land

	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		land = resource.contents.filter(typeof(Land)).head

		generateModel(fsa)

		fsa.generateFile(land.name.toFirstLower + "\\" + land.name.toFirstUpper + ".java", land.content(resource))
	}

	def content(Land land, Resource resource) {
		val Map<String, String> fields = new HashMap<String, String>();
		fields.put("name", "String");

		return '''
					package «land.name.toFirstLower»;

					import java.util.List;
					import java.util.LinkedList;
					import java.util.Scanner;

					import «land.name.toFirstLower».model.*;

					public class «land.name.toFirstUpper» {

				private	List<Trip> trips = new LinkedList<Trip>();

				public «land.name.toFirstUpper»() {


                    «FOR location : resource.allContents.toIterable.filter(typeof(Location))»
					    «addLocation(location)»
				    «ENDFOR»

					«FOR trip : resource.allContents.toIterable.filter(typeof(Trip))»
						«addTrip(trip)»
					«ENDFOR»

				}

				public static void main(String[] args) throws InterruptedException {
				    «land.name.toFirstUpper» «land.name.toFirstLower» = new «land.name.toFirstUpper»();

					System.out.println("Herzlichen Willkomen zu Locator");
					System.out.println("Hier sind euere Trips:");
					System.out.print("Loading: ");

					for (int i = 0; i < 15; i++) {
						tripProgress(i);
						Thread.sleep(200);
					}
					System.out.println(" ready");


					List<Trip> trips = «land.name.toFirstLower».trips;
					for (Trip trip : trips) {
						System.out.println("(" + trips.indexOf(trip) + "): " + trip.toString());
					}

					System.out.println("Bitte wähle einen Trip aus um zu beginnen!");

					Scanner in = new Scanner(System.in);
					int choice = 0;

					while (in.hasNext()) {

						try {
							choice = Integer.parseInt(in.nextLine());
						} catch (Exception e) {
							System.out.println("Falsche Eingabe, bitte nochmal!");
							continue;
						}

						if (choice < 0 || choice > trips.size() - 1) {
							System.out.println("Falsche Eingabe, bitte nochmal!");
							continue;
						}

						System.out.println("Sie haben Trip <" + trips.get(choice) + "> ausgewählt. Viel Spaß dabei!");
						break;
					}

					takeTheTrip(trips.get(choice));
				}

				private static void takeTheTrip(Trip trip) throws InterruptedException {
				    Thread.sleep(300);
					System.out.println();
					List<Location> locations = trip.getLocations();
					for (Location loc : locations) {
					    int currentIndex = locations.indexOf(loc);
					    System.out.println(currentIndex + 1 + ".Halt: " + loc);

					    if (locations.size() - 1 > locations.indexOf(loc)) {
					        // calculate distance
					        Integer distance = Math.toIntExact(Math.round(getDistance(loc, locations.get(currentIndex + 1)) / 1000));
					        System.out.println("Zur nächsten Location sind es " + distance + " km");

					        Thread.sleep(2000);

							for (int i = 0; i < distance + 2; i++) {
								tripProgress(i);
								Thread.sleep(200);
							}

							System.out.println(" Endlich da:");
						} else {
							System.out.println("Letzter Halt!");
						}
					}
				}

                public static Double getDistance(Location location1, Location location2) {
                    double lat1 = location1.getGeokoordinaten().getX();
                    double lat2 = location2.getGeokoordinaten().getX();

                    double lon1 = location1.getGeokoordinaten().getY();
                    double lon2 = location2.getGeokoordinaten().getY();

                    final int R = 6371; // Radius of the earth

                    Double latDistance = Math.toRadians(lat2 - lat1);
                    Double lonDistance = Math.toRadians(lon2 - lon1);
                    Double a = Math.sin(latDistance / 2) * Math.sin(latDistance / 2)
                        + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                        * Math.sin(lonDistance / 2) * Math.sin(lonDistance / 2);
                    Double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
                    double distance = R * c * 1000; // convert to meters

                    double height = 0;

                    distance = Math.pow(distance, 2) + Math.pow(height, 2);

                    return Math.sqrt(distance);
                }

			    private static void tripProgress(int progress) {
				String progressString = "\r|";
				for (int i = 0; i < progress; i++) {
					progressString = progressString + "=";
				}
				System.out.print(progressString + ">");
				}




			}
		'''
	}

	def addTrip(Trip trip) '''
		Trip «trip.name.toFirstLower» = new Trip("«trip.name»");
		«FOR location : trip.locations»
			«trip.name.toFirstLower».addLocation(«location.name.toFirstLower»);
		«ENDFOR»
		trips.add(«trip.name.toFirstLower»);
	'''

	def addLocation(Location location) '''
        Geokoordinaten «location.geokoordinaten.name.toFirstLower» = new Geokoordinaten ("«location.geokoordinaten.name»", «location.geokoordinaten.x»,«location.geokoordinaten.y»);
		Location «location.name.toFirstLower» = new Location(«location.geokoordinaten.name.toFirstLower», "«location.name»");
	'''

	def addGeokoordinaten(Geokoordinaten geokoordinaten)'''
        Geokoordinaten «geokoordinaten.name.toFirstLower» = new Geokoordinaten("«geokoordinaten.name»", «geokoordinaten.x» ,«geokoordinaten.y»);
    '''

	def generateModel(IFileSystemAccess2 fsa) {
		val modelGen = new Model(land.name);

		fsa.generateFile(land.name.toFirstLower + "\\model\\Location.java", modelGen.modelLocation)
		fsa.generateFile(land.name.toFirstLower + "\\model\\Trip.java", modelGen.modelTrip)
		fsa.generateFile(land.name.toFirstLower + "\\model\\Geokoordinaten.java", modelGen.modelGeokoordinaten)
	}
}