package de.htwg.konstanz.mgse.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext


import de.htwg.konstanz.mgse.locationDistanceDsl.Land
import de.htwg.konstanz.mgse.locationDistanceDsl.Trip
import de.htwg.konstanz.mgse.locationDistanceDsl.Location
import de.htwg.konstanz.mgse.locationDistanceDsl.Geokoordinaten


class LocationDistanceDslGenerator extends AbstractGenerator {

	var Land land

	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		land = resource.contents.filter(typeof(Land)).head

		generateModel(fsa)

		// todo generate land klass
	}

	def generateModel(IFileSystemAccess2 fsa) {

	}
}
