
package de.htwg.konstanz.mgse.generator

import java.util.HashMap
import java.util.Map
import java.util.Scanner

class Model {

	String land

	new(String land) {
		this.land = land;

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
