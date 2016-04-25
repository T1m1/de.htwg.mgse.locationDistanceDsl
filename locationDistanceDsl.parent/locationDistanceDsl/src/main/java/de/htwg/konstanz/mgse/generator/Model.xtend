
package de.htwg.konstanz.mgse.generator

import java.util.HashMap
import java.util.Map
import java.util.Scanner

class Model {

	String land

	new(String land) {
		this.land = land;

	}

	def modelGeokoordinaten() {
		val Map<String, String> fields = new HashMap<String, String>();
		fields.put("name", "String");
		fields.put("x", "double");
		fields.put("y", "double");

		return '''
			package «land.toFirstLower».model;

			public class Geokoordinaten {

				«bean("Geokoordinaten", fields, "")»

			}
		'''
	}

	def bean(String name, Map<String, String> fields, String ctor) '''
		public «name» («FOR field : fields.keySet SEPARATOR ', '»«fields.get(field)» «field»«ENDFOR») {
		«FOR field : fields.keySet»
			this.«field» = «field»;
		«ENDFOR»
		«ctor»
		}
		«FOR field : fields.keySet»
			«fieldGetSet(field, fields.get(field))»
		«ENDFOR»
		
	'''

	def fieldGetSet(String fieldName, String type) '''
		private «type» «fieldName»;
		
		public «type» get«fieldName.toFirstUpper»() {
			return «fieldName»;
		}
		
		public void set«fieldName.toFirstUpper»(«type» «fieldName») {
			this.«fieldName» = «fieldName»;
		}
	'''
}
