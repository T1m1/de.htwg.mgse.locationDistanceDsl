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